Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABF1C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291386B0092; Fri, 25 Jul 2025 10:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268D86B0093; Fri, 25 Jul 2025 10:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F046B0095; Fri, 25 Jul 2025 10:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 06AD36B0092
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:51:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53C811607A9
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:51:15 +0000 (UTC)
X-FDA: 83703074910.11.B3533D3
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7E8AE80004
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:51:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=neoKQ5nc;
	spf=pass (imf02.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753455073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/nE+IEcqT09EYKsaI5wJz1uG4N+ePEQMWFP+OoeT0g=;
	b=UN03vmduY0lonTdL+Dkkj5Iywg9h5NweNeEP+us+anCr8mQ5UklWqWo2tCRQmVwDMRna2e
	0vULtPUZDv4h5oTna5M0Sv8xVlFCszHu9xogNOpRt5XXEQa454k6usJFvmWRvg+jYeSnrA
	MWX7M9pHrhNd7Sr5bVMsnGHyKh8oyS0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=neoKQ5nc;
	spf=pass (imf02.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753455073; a=rsa-sha256;
	cv=none;
	b=N9LUBsuQbhlxYsirVOAVjyweHsgNmRxJc2iL4eC5zhSte7X4V46qRDLJTFmAqbqBaUwaIr
	/em3vOl63GTU/R1YhimC/oFVUe5yWfrQ1B85gnb4T/BVlD4zVqxb+PrmHZfPziX4dYXQxe
	zL0wxR5KMI/lu32IoQf5HJynmKVbsM8=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-60b86fc4b47so8897a12.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753455072; x=1754059872; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/nE+IEcqT09EYKsaI5wJz1uG4N+ePEQMWFP+OoeT0g=;
        b=neoKQ5ncViBu3MMAMw+HQsfLBLyu9HDel21nbeK2sFG/3PpbASqBFBknkAJnxJUMdX
         rqTSSt5DXVfv/rRm3KN0XvfnkJZ+r397Nu8DqwcltlX8qc20RWEZbJ6n3NqZMYqI7wC7
         TZdaGdqoqfKqVgO4j/18Te4+3ujkGDp7wQkV/Z6cRC+3vAe1/zRLJjI+OqlugLfLVVqj
         Ou0TpOr26jiXj/UKMsTEiUg7okA2bDx0zZ5R8/40G7ArlYbnHmWF8Dk1Xg7MT0HgpwSu
         ZnaCxRR3G3z20fli4xj74O5nN0N5FX6+1gmf9CG0cfEiIowA53Z7iWEytxmJbvvr06bw
         rYpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753455072; x=1754059872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/nE+IEcqT09EYKsaI5wJz1uG4N+ePEQMWFP+OoeT0g=;
        b=QQTlRELcSrTiBNAo9aiiGkLmPwRYCO1TySV4PYdOYuQrMeorN/EAPU9ZdOQrJOtw55
         3zSm1bjbd6bVlY27wRoHHZLS43HZbab29y9zWg3o9abjKZP9odrknmp4I8eWpO2Pwm0r
         SXM+UD1L/DCTz+JNyx+MAGac3YCr8RKPEK0RiJRqBOhG6ylDblR54J/ukgeF++Z4ffH+
         eNtXLH7OVjUxUoTNmdFDBwqUTXQkRMM3o37Rnq7HHv9UsTIon9jwTxeVY1st0NuiD5xs
         Lxc6z69T9pbcGPhcF42Oa4ZYaoQrrbSIdRnOGtGPJ8/gHW/X+3h9NM7xnmXemTtMFbk9
         OiNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsoh9hKLTV3VqR6RxnOzbG/OcpN+fPcpDiI6xwt2X9Fd/4PFRvzvCO8WeMFlJJyYL8/jG2efA+gw==@kvack.org
X-Gm-Message-State: AOJu0Yy7em+EuBdRuoiNh5/uUQcaMdmqoPoLBK2pT7ZBeEXdR76Bx1j0
	im+gu7d7en173w5p+qNRp0wTRESrDCwLzgWRz07KFleM82NO7K45SKeL+XeWzn+D/g3C5aXcyQU
	kgjebyqWnojvfuOGAs1R/eTjnfCBp2oq6MYEFfT2DqOsB5ubhStbATvIdEu0=
X-Gm-Gg: ASbGncsJvrgqgtprRufroRotI8m456V0JarInThuZOxCgKU1hXvd0hjvQq5gUNb3k4i
	eDim1wqEFd6F1E1fP/ob0lWNe4wGSAu62FImR8X+KYbzs5K8q4CMUBI+eU1481SiehvGrVDoJC7
	NnZbQ1zI0jjXOo9vMs2EyJfEK0RX9KaOmvF306enxiPc/VBmEVHwbmzXN0oXNF1hyi/+WWjzsJC
	mADUCYYs7bt50ZyWBTE7sNFNxwrcPfwPQA=
X-Google-Smtp-Source: AGHT+IG1lwvRSpePK7y9eGYHxc9sTcfI3irMgXKR8bXMAVsFm8kAOC/of7gPaugNlGLD5gqriMXtX79x6wEI3XifrGs=
X-Received: by 2002:a05:6402:324f:b0:612:bec2:cf22 with SMTP id
 4fb4d7f45d1cf-614e7adb2b2mr113055a12.4.1753455071506; Fri, 25 Jul 2025
 07:51:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
 <c3f04c75-a73b-48bb-b56e-7b18e57c2382@lucifer.local> <CAG48ez31aVnoBiMMjUczbmThWnRGmod4yppgMVqf2Nu5-hjU2g@mail.gmail.com>
 <50502c3b-903f-4018-b796-4a158f939593@lucifer.local> <3a2810ed-74b5-4822-b3e1-bcaa97eec264@lucifer.local>
In-Reply-To: <3a2810ed-74b5-4822-b3e1-bcaa97eec264@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 16:50:34 +0200
X-Gm-Features: Ac12FXwno1Ye3Nj_ec3vwDkaWvQchsGEoLeSywsEebU12zoS1CIUQw1WpbRG1Nk
Message-ID: <CAG48ez1Weu==SNUZF4EZVxUe8KhG0vXnUHzHFwmuJ3mTezRHJQ@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x7gbw7xuywtezr5byixo8rbm93gi3c4p
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7E8AE80004
X-Rspam-User: 
X-HE-Tag: 1753455073-330075
X-HE-Meta: U2FsdGVkX18dpj14QXsbqigDU6P+wm1tKUHndh8QSMp8nfYJPl39BtJm7F9RxOcqxteHphZHcGqlm6OHGyCxVc6yAfjlM2zRxpHEcphi21GdJRgmjqb2Epv+NZB82VLfv6uSM8Saz7MEk6BHJ0BI1mLYXZxpg2f/KIq2Zod9kbBT7nchsK+CWgqrmsfMKCxPZPPNvQR/exv1B4kw5eV82DIfxRLwnAlpEq093G9brMRdBElq3p2e/V7TU6P/eGFq+K25+YfVr4IkMi5+RmbWwb61eHJRk67lrEld1//e0bqhRndN2fqq1elBjFjNJPOiS3vYklJG9bZUcEhLFhiy0u6H9mcY4lE37Tq9yln7XKusIp6mZPP3Jqf/dVtpfTMi/XUPX5bVgASh6xGDhMddJzgV/MTMo0VzxZvR39hPuK6Vgor8W9v1MHERov9WZV8pixnEZjdYYcbvslT4r4mYB4dBtYkHgmR7rrZ6RgDctHqTxgRM845xqOFjGz8ze8AUAj37Z/u+y46VKQBoED6AjMoV+uA/GNweF4GS+6It1uQfMZDUscpQlWILRB6BFLDRCLlxnrKKPQuENNq9CW+89H/bUq6DJUHo3XmxXJKeNU9W7k1OR2/nZ/H3lh2hLYFggh3C49q6+qFu5/jbrus9p2NGNZHhbVkFfHXMYg3iU0iLbN4LrrQRyMV6AiivE04gFhkKmdYxB6V1N26k+Lp/8SUHUCm2KQrPVLg+DXklN+WqB6XMvMjZ+4H2c88IlRSpEF59Sc9so3QZYBhxJzh0Pi7ri1WrXk8stvHj0lkZBXtkyFUUadEM+IjX6AJ4wThPldcqNIKLfSe7SFRAHd2jZ23lvwu7CKcU5XFgKqDlxCpDQeQ82r9reN40yMjTvUr8Z5DdwyQedMva3iOPgCMv5oZFpo1srKLKHlsx3XtpFRdEwdVr6pDHkGqNi+67f79eS5u0Y5IY+qk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 4:11=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> I went checking for this but was blind obviously since didn't find, Vlast=
a
> asked off-list about why anon_vma's are allocated SLAB_TYPESAFE_BY_RCU.
>
> I notice as well folio_get_anon_vma() is _tricky_:
>
> /*
>  * Getting a lock on a stable anon_vma from a page off the LRU is tricky!
>  *
>  * Since there is no serialization what so ever against folio_remove_rmap=
_*()
>  * the best this function can do is return a refcount increased anon_vma
>  * that might have been relevant to this page.
>  *
>  * The page might have been remapped to a different anon_vma or the anon_=
vma
>  * returned may already be freed (and even reused).
>  *
>  * In case it was remapped to a different anon_vma, the new anon_vma will=
 be a
>  * child of the old anon_vma, and the anon_vma lifetime rules will theref=
ore
>  * ensure that any anon_vma obtained from the page will still be valid fo=
r as
>  * long as we observe page_mapped() [ hence all those page_mapped() tests=
 ].
>  *
>  * All users of this function must be very careful when walking the anon_=
vma
>  * chain and verify that the page in question is indeed mapped in it
>  * [ something equivalent to page_mapped_in_vma() ].
>  *
>  * Since anon_vma's slab is SLAB_TYPESAFE_BY_RCU and we know from
>  * folio_remove_rmap_*() that the anon_vma pointer from page->mapping is =
valid
>  * if there is a mapcount, we can dereference the anon_vma after observin=
g
>  * those.
>
> ^--- this seems particularly pertinent...

Yep! This was also how that anon_vma bug a few years ago
(https://project-zero.issues.chromium.org/42451486) turned into UAF -
it allowed you to have a folio still mapped into userspace while its
anon_vma was already gone.

