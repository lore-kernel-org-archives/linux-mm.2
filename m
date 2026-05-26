Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C282FCD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB4A6B00CE; Tue, 26 May 2026 08:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C33A6B00D0; Tue, 26 May 2026 08:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9306B00D1; Tue, 26 May 2026 08:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6E86B00CE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:00:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF2C3A040E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:00:12 +0000 (UTC)
X-FDA: 84809427864.20.F7C447C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 76C7B14001B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:00:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I1cT2A98;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779796810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPVI6FG+9wTp5VL8rvlsGJ2RfHITdLh7b6n9qoUv9X8=;
	b=XgVL6BnFeSr7GPsJ12/3o0LD7LpQg829ry+l770jkgs6zbOSm437SUPYuLJBlvoEi69cPt
	F7C80oenKMGgQq9KaiTDBtVdsNWn2+J3MCvwc9vng385f0NW65YoaSU8VJ+GailFeSh5YQ
	9opTk92wEmOCqQUlFgcQpK3/HqDivHI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779796810; a=rsa-sha256;
	cv=none;
	b=FDOfLjUpS9X78pkJm6AfiApNnwLtlw5JO4lsvjm/JSwctX2qk/mjfLUXO18+YSFwethyi6
	3eJyBFCn7Bc8MelrZGnXBzJrrUcLSc34/hs+FI+XnbQrsqbVkQH2VsDycoimEEyfkVZ53Q
	3dym0HvCiuOzVIkpu0ZAVauZcqKPiJ0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I1cT2A98;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779796809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dPVI6FG+9wTp5VL8rvlsGJ2RfHITdLh7b6n9qoUv9X8=;
	b=I1cT2A98XwUObqhYM/hRx6bXvFcMHe7qieHFRGsLO3NvcFJWpBa5QmQNvBmvT0rMeVAtTk
	DXd+9b++H+zVSdMT6wx1N+QPz2gjqcIhK54Hy/2DEXx84r2DNqNq2z3UwNETz+f6TzQjd4
	zNZWcnXJKM1VkCqY3iH+3gZRaQMKwY0=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-eW3TTtdyP7eYAy64BmUXtA-1; Tue, 26 May 2026 08:00:08 -0400
X-MC-Unique: eW3TTtdyP7eYAy64BmUXtA-1
X-Mimecast-MFC-AGG-ID: eW3TTtdyP7eYAy64BmUXtA_1779796808
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-658c29291c7so16566897d50.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 05:00:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779796808; x=1780401608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dPVI6FG+9wTp5VL8rvlsGJ2RfHITdLh7b6n9qoUv9X8=;
        b=fZOYGzgA9CGIg7sshFl7y1Fg6mzHdJD/Z9t3110I831RqFjih50M03qPFDtJXvMbUg
         xM0HjPhdhtr/2+OqVn3yuTZ6pnjEBr43iTRVCNgfsfkhUg0DKHps1wOJnPp+6WoufTPx
         UUhLiz1YWuU5Un+Bz5OqBf51S0Be2q/x0cRFeBKaavaXzOB6e1q/3G6W3YaIQxuHlHiv
         SEazKzvtbUA7qcZ0u6+Qh45+xw3a0ax+HVF1vqZ9RSj4wHu7N7oZhZ6R+LYPAtO1HaG4
         DT21xdppY04Z9BVC2Z+zo2V1VYeVTH9of7bXtNsbIVijUM5MoC0wtHt0poL8y2UiuqIn
         xvWQ==
X-Forwarded-Encrypted: i=1; AFNElJ8B9tEtSYlAeiLU6df9eT6iJG9DkaxI1BVwnyW79rgBrC2cvu4Oh3ZposYkWbFzKxV8PCJKtJqCGw==@kvack.org
X-Gm-Message-State: AOJu0YyFRUSp9hElR75+JXnG9t0soneTbMO2w+UnPjy7+2ezEGMDlE+0
	QH7g4xqMLpeaURlYTa/50bb76l14nddFHGUGcYiEskxP0rtyqpyTP4id0aFn4jpYPVHzzzXnxrh
	9OODBa/fonnXpMiRNEx7AunG4hjmIpbHj3165kdKxYeD9uT+4CPMpq4F2ap2z/+AOZCWZpIPYSH
	TbUidqEEiFWTRuZkxvFVr55fhE8YI=
X-Gm-Gg: Acq92OFp6ElqL/RoN1DQu1Bsg+bYuqdtkhGzNAQLAXtXiKeazVgEd1wPaAa9Br2eGFI
	og3I0so/SRK/ypNxl/SBv7nEmFH2ABdt8TXbL5JryCU8ON/Vw2iia9IqS8NAWAjjQvLjBpDbTDH
	sWKKLeHocfzzY5egA/kBXB80x7fnCZjOmJID14DuN9KJIOzicEFXpDwSVpiaFTxrttp7+4Ngrt0
	ZwwEA==
X-Received: by 2002:a05:690e:4186:b0:65c:febd:c0b7 with SMTP id 956f58d0204a3-65ec9772e80mr14934527d50.20.1779796807862;
        Tue, 26 May 2026 05:00:07 -0700 (PDT)
X-Received: by 2002:a05:690e:4186:b0:65c:febd:c0b7 with SMTP id
 956f58d0204a3-65ec9772e80mr14934471d50.20.1779796807277; Tue, 26 May 2026
 05:00:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com> <20260522150009.121603-15-npache@redhat.com>
 <94f759f8-e2ed-4f22-b9e7-4693ad005509@kernel.org>
In-Reply-To: <94f759f8-e2ed-4f22-b9e7-4693ad005509@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 26 May 2026 06:00:39 -0600
X-Gm-Features: AVHnY4I2kJlfEdj79rgn-OjWXsjv0gbtFCil3AHTWp4P9-K4HDgNbrjoGJeC5zg
Message-ID: <CAA1CXcD0w3CJKzwTvv6gaA80XBYwTTbZGnNGJjbirYMZnBmyHg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v18 14/14] Documentation: mm: update the admin
 guide for mTHP collapse
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com, Bagas Sanjaya <bagasdotme@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MVBRUmm8c0xbJsgxC70bwbi9aWruFFaLL5zwkz3_2Gw_1779796808
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 76C7B14001B
X-Stat-Signature: 184rrzu4f5b86s38ubrgj8xw3w6ijmab
X-Rspamd-Server: rspam06
X-HE-Tag: 1779796810-859134
X-HE-Meta: U2FsdGVkX199TjNsMnkiAGfXuuqHixTFQvouVlaH0F27kaMxclD36niPzZj5mqjNitETgEf6ayrisSspEza7ohz14PsW96XIr463nitmdumVu8cE2Jd4sqw/uW3CpxMFeRBxC0TZwGy16CWEiraayEho46pPB2lzwpLNUWVownYTvapLx6MXD2xS2lEn0IIWAFAfhjsitBTVxwW+4fEVjpjy5zAWx5j/9RdlTwHVGrFqCP2QwUJrfN5/xZiFtXi4QqpqtBfVD+q6j/67rD2lNC6prF3UwV0O8pNKu/QCmlmRmygRK7bcunsVFNcl2ByG8dRW3e5n8niu/w0SoyG0EGBo4atyLVTrhpmD+1y7uTHSJ3VSvJfFML6pO4agKWtq8E/vt9FNuOkDRIeKQEJFRTdRhWNikxxQ8M4wx3n4+1R9/pqlH4VABzvyvcm7bVcGbYhCYNkCoFFDdWqFBZSHWstEzNfGeGaTmAljk7hTMJ3nVMMq34WEO+cDBIGRMF9DuLJvHz/tl5egNt7lVyE3hMfb71r7+jDpJy5Jc1CYT1hzZ6F++tLCr5yfXa+8fZURma7F0BSjEjqc/sF3BcAz385JiUvBwzqJ+wnIeuU5amV/VeP6QmOj1PXmdedgbRTmF3wqx6LRXBlTMdSGbW6qXWP/6yjVBVRvGUH+4us0S8bonlpS5SLwXPTeaZaIz4RTdh6X4JZeUoXstQobReOVNqYatQ3FCOzTE+gKkp8A9yRockOaheH0xE1FhvTwh3y7ME+kWiUuJxl+bStnUUFfhGYJoXk37zSI0yZ45Y1URp5XpdoW49DjYgE/JBO3VDgQMxezGfriqOXp54K5fOMsNnx4m4zVf4nXKpFnVgzBMCs/vtB7Hdjw8KSZobi4ClhNyN/5JF0eqbaPH33+C8ZeFl7gADiLrAgPi8QJwdzE6s6NpEWcezzbtk+w45zQJtkp/47dmRd1wC2DwzKoPZq
 x27h7dOa
 XK03fkGOogHXgnRhmznDLS+0DjKIppgf4WlFo1xffh7igOAFbe6HdLdp1MkT5NVeXhCNC8T/TBkYKI221cDSZD2+IdD+/ZKbLT0i0YhQUGkQczyT5rfXrywCQLOtE88kMGWE1ibuSuVPzl6muMblpQOYpoENF2WVkZFaTA95VoisgGvIWP7iYwy8Etk07O0hltU6+jfMUkXMkjh9SQxjzqtuzDMRiZrYDDpLYW4H07SU2C1zJ6dgu2Rcf+xZNE20h8gwa3wzMZl2xxIyPpbEYl5xo8j6XyThlygWaw6QUNVZQTwtFT0ZbrmQ9zhvB7OuZfuD+jmCYniaT35UrUcXhD1LwDJXmGuiI6Tn4M3tqQ3s6fPhPHVl1IB9BhjbeWnBuvvNeKmy9id7uEQ6HD5FuQULtWWp1Wyz+LLJ9xthjYQ5E2USJvFLp6+f4Roq7AY4ErcjW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 3:59=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
>
> >
> >  process THP controls
> > @@ -264,11 +265,6 @@ support the following arguments::
> >  Khugepaged controls
> >  -------------------
> >
> > -.. note::
> > -   khugepaged currently only searches for opportunities to collapse to
> > -   PMD-sized THP and no attempt is made to collapse to other THP
> > -   sizes.
>
> Should we maybe leave this here and clarify that for file/shmem, it will =
still
> only collapse to PMD-sized THPs?

Ah yes that would be a good idea. Ill send a fixup!

Thank you :)

>
> --
> Cheers,
>
> David
>


