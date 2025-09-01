Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0686CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2475C8E0032; Mon,  1 Sep 2025 06:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7E58E000B; Mon,  1 Sep 2025 06:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BFE08E0032; Mon,  1 Sep 2025 06:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E707D8E000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:36:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94C081607B2
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:36:55 +0000 (UTC)
X-FDA: 83840328390.27.322A88A
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5755D4000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:36:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=S9byd6Dk;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756723013; a=rsa-sha256;
	cv=none;
	b=yAUxhtwfUZR+gc/FrcPW8eEDmWK/KdEofQPCL6/faEPmMaTnYhJovfKNMBTdwf4m2GPWlQ
	6FYne6IjedeiUHGKWGTChn5rPSB/4MMyoXzAtsPFw0MLjXPPKaMgzbtSWw2OmNdbzXYvjS
	2t6iw7l1owVhNtdYc43bqOUWPsGgKhA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=S9byd6Dk;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756723013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxGHGdFfILxmO9LAT6iJq8nCvFtGNCBHuBQCWD9Ke3c=;
	b=E3J0t9jEzs6JF6iYCME+t1siRblPdkrQsY1C8X+SQwD9e0Fwe3Bn2aBCfPh8BabtcuIrAJ
	YLeSIS6kkgLPLfjRRRg5coAxn1J6Z1jSkIyfcMKfvCs5kenMJ32uPe8wvwU32S0RD0mdAn
	++NvtWYVJH1TBlDahmnIpXypMVWNgy0=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb7ace3baso131481866b.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756723012; x=1757327812; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IxGHGdFfILxmO9LAT6iJq8nCvFtGNCBHuBQCWD9Ke3c=;
        b=S9byd6DkKAc46Rje003brFzGnZ4jBcXu0TwZFYlGdciKnxGfqBG10z9yntfK89vvnl
         vJr0w8YzZ9Uz3Sx+VIVAz+VANgvKe9pxcMF2kguwnRTqw5+Kqe5fm/Osw3wDUG8xwSAP
         OZvIDe+C967rJsbihnIBWsGcnVzLmKXVmKWU0Y7ELb7E/T6YXQCyz74gqVjZt87zFn3L
         LppTOFXoT8STAyee1iAQl8+UlPLdCW37m/3RnmF0KkIWcu+cyxo4i9Ws8BBiDX9Hbe0A
         wMYOVzNysUUCwd24f5J6sb0K8NwGkRn9Jr/R4kKJXXMs+8ZfdZ2suXHz9Ec0wG0IVg87
         myJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756723012; x=1757327812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IxGHGdFfILxmO9LAT6iJq8nCvFtGNCBHuBQCWD9Ke3c=;
        b=fTmubgUupV+T5xLBcTdg1n73Al3OU/wv/F9v5iQZzgbIkFKAW/XtqaM9dFKYps5iVX
         n50yfvT9sC/fK/A7h5gQ+xx0gfidKdYSNpCLE+65vLuu9nOaHSmgrj+ZjwbBLFqhicnR
         g+ZLnlxwk0hEaH6YGIAQBJiM/V3IWDon4P1J880Y0SWS7KHJBle64NYy+f9htm1QEL3N
         aSQi7W/dfssp1gHVySZ+y/BQ2PPnxHYfpJS2qieTF8oiUU7R6uPvn0qQ9jRdRTcGZj5L
         OgpeZ5OyprNwEqhIGx6gGMHuGndupONgA259P9fCxST0xio8m4B/7ilYet2LRfDhKulh
         jksw==
X-Forwarded-Encrypted: i=1; AJvYcCUAUIEPj8xBexCdIaiNnK18ug44c8iZHV9e2Sz0lxz1qTLDrBMbZU5RRnN2CBtFp2IpTqjcbomIdg==@kvack.org
X-Gm-Message-State: AOJu0YzG9CRfS1jPdb4y20XkAEWOvZaxf8iMWjvmjmraH11vaew3Thhy
	6bzCL/NMLjmh612IC678z28M//B7ICmPIwNRa25HlQgyVPXv6UAo74lYzWSkdwxSuTUcjJLZaT/
	AWwAeaENs7kCKaNefrCCnlOFokM4TSoTdlvUgctWqgw==
X-Gm-Gg: ASbGncsgqZACZ5nxCxl/lQBIEWk7PK1kdThFkt40/slTuDmuzMqKb/vV4Ev3SS6l2JG
	+Xy7a1xjmj3RZa7pbkCyMPJlmVWPiQceWH9erlrmk34VWYYQvsC6eS4cGCQv9QgynWVfV0oCMXN
	qx8LCyE/xrW0+Ljj45qLwb1voRbReyVHJk5Cz37H83ZGJPzGnIRYpTbmEY9tstaObs4nfnBuaVa
	hOUurPNHDj9Y7sDNVVUGMEPKraFZ6BZ0xDKld7N6o0xGQ==
X-Google-Smtp-Source: AGHT+IF7b7Fa96HeawzlccNm19A8JZGLHL8MRKn42K1Wdqx+XBHi7MGJjQr+rqYT76RP2cmaJo0VhIiErdCjMF9pXhc=
X-Received: by 2002:a17:907:7b8d:b0:b04:4175:62f7 with SMTP id
 a640c23a62f3a-b04417565a1mr57680666b.33.1756723011734; Mon, 01 Sep 2025
 03:36:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com> <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
 <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com> <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
 <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com> <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
 <661e6140-572b-4480-9ca2-6a127730f32b@redhat.com> <CAKPOu+_KbBRdtB-WiZuiva7Fqsus4x7zBOPkqdhwfYFkdS-doA@mail.gmail.com>
 <25f468d2-8474-4d27-9013-d4cac7675897@redhat.com> <CAKPOu+8YMLrtqbhhQ0SgfQN2xErVhZCLEoStRL-YJy-SeHE8ng@mail.gmail.com>
 <5636a473-2a0a-4d25-95a4-1db48a1752ec@redhat.com>
In-Reply-To: <5636a473-2a0a-4d25-95a4-1db48a1752ec@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 12:36:40 +0200
X-Gm-Features: Ac12FXzuAjDMNh01gCwDOq89AniTuQvmvFYacWfktC2xpar8D-emOZa2oiRnOak
Message-ID: <CAKPOu+8JwdcK4RJDt7amCj9-V0K8Xjmtt=HHWsrET=EEyPBthw@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer parameters
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org, 
	hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5755D4000B
X-Stat-Signature: imcz7tfxs9oh4sbe86ycbni4pzxekptq
X-Rspam-User: 
X-HE-Tag: 1756723013-30159
X-HE-Meta: U2FsdGVkX1/6SEoi+zfdIobgPuST44vEa3h2cxb/dhZD/dCkhaEy53fDPwxIwQPvnUKHXmDA4RjpRtB5djpBskg/P3oSMqVFY0/choSChNc9Axs+R+h9wWeDKM8YHQKMkCsKAVOeYeIyejzc27EjBnk3gvbDquGaBlHEU3E3um6V2QKiksPoufbEswTrlJIEFUNMOwOJvvtGwjkmBswS/S/JDheqaXfMGIf5yMGA6YPVzrG8Kdem7eUC0At9TYX+njMSoyqSBJZIy1PAkopLlJSO9p7cl8Spak5wFU7tTAHgW+UmWFykYRqy0Gu6+RpzHU/M2+E8tlfA05xWM2M2jWuw50CfguDG/jd87QwGcYS7e3CsJp1plb+Fmt1bEuLCmZLwromDgpejcy7bvTWSuVyFsZITl4NngXdN28BQeV8dWyg2CwBDMr4iVOJ83qvScnZKb+MI9BDyN0Wu9wbNE9iMOfe/tvAxD1i4GlHRwZ3z7mn9oH7DiES/4dwOuD3OxbrWmmbZORBxBd5VPThN0SdPyPyX0aqxf+9KJrf/XfTnNMf6+YjF3pMQzI1QqqOM6LlBey2GQ8P3J+/nTAJF9JNztxxnbEXiCxiWz54rCjcrTaTcndY5B/IRtoLzauhpZ8aZRr5JGQOffbR/oUg257HYxW4+8minFNBpN0Oj9fo+oEOGpuwLjt9EI24J6hOqyN8HTJTA1OOYYbjzTKUOEMOTQIUUL6o8yStobWjnVrd3Ma7+DJJIX/ZX+pfowgbzkZvw2LXO88c9dYB0DsyNRL2w+9VeLVQbTLJvxcQuSRFMCSsYDigUbk+Q8R2ruhk9xst/g8ZRr5jfZmyCp5sVdepVhxReKD5rQlYnDhHWaOlCSAoPV9ArbO2cSg0SYPNL9ttYgJ6wJXYq8ltlfonCxa3IXpatMx/oiwRNtAgKl7m+xODGsE9U5QbYrTfte/RGjfJqc6ENLvVizg5ofCw
 uB6d3Rpa
 YhBcjtswp6q5Hzu9ycyRBScYtqeG+8OjBZjURd4iRWpPhQQrTjh2Mt5Ae2LTm1qfQ/pyg4HAWmTFBoFYi6lIHmuYm9wjgqEULVCP3wEH+4yBSt9cajSaHJAD38YfVl6Q6exqNtDzUr+DE1jJ1V5xL/60CzpCHoIA2wU+nKgqb1TUlU4ROyiCMDKaZ26+gJ//RCUf9W/3IWbEO/TUhKskLA/rbesc8mTb4bUocLtOtiQMdGl3KGyK2rTADEJU8zXS5CXnYI19JxxzAmiWdW6g/2jnCtLGxSa2hZKlw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 12:07=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 01.09.25 12:00, Max Kellermann wrote:
> > On Mon, Sep 1, 2025 at 11:53=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> >> I'm sorry, I have no time to argue about the basics of writing a patch
> >> description. I even proposed a simple example of what we (multiple
> >> reviewers) would expect as a bare minimum.
> >
> > But Lorenzo Stoakes and Mike Rappoport wanted much more than that.
>
> Sure, if it's not a simple "test" function as the one I commented on, it
> might make sense to explain more why it is okay.

Lorenzo and Mike commented on the very same patch as you (i.e. 01/12).

I remember that you provided an example, and implementing that would
have been easy - but it would not have been enough.
Matthew's patches would not have been enough, had they been judged by
the same rules.

