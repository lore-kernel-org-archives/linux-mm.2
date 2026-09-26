Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22B52C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 16:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0816B0088; Sat, 26 Sep 2026 12:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271386B008A; Sat, 26 Sep 2026 12:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1875F6B008C; Sat, 26 Sep 2026 12:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0CFF6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 12:20:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6852E40880
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 16:20:00 +0000 (UTC)
X-FDA: 85256424960.10.F7BF829
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8E58CA000B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 16:19:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MSwWLwFr;
	spf=pass (imf25.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790439598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRtKYg0sOGgBmCELm1fPJpD8C1O0ubIGfHJNiovVGiE=;
	b=I5Q5INSH/8VyPh54w1a+4t0mXPd92nYNHZxtadZIP5bNlr9ul9Xsfakw3hM3HszQMbcu7G
	69LV3w8dsP9Ew7O5KbC/bxsREKx7lG3LmCJjMzk79sIqHmtshVjJP4PlIJpHcAWtflC5Cd
	RDkEzr62m5KT9GEL1h5FXvVqLylZMFs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MSwWLwFr;
	spf=pass (imf25.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790439598;
	b=haHzXOqeu5+OwbLitNBjjGVhwk46UEH2axhIoNoIEXY7QqNohnMmUTZY2PFFUvUcfe974K
	mPOSpWBLXh7iSewt62jrK5ttP9u92H8nJssGaq71kvKRA1OYDB9QjpqIjt7iaIf8zuxEe9
	ocYU1UYiFVO2j7h5+8a80GJYo/jSVEE=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b91369d18so11156325e9.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790439597; x=1791044397; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eRtKYg0sOGgBmCELm1fPJpD8C1O0ubIGfHJNiovVGiE=;
        b=MSwWLwFrO6DqxZybiBdtzcU1P0w2+wXR3RjEicYPW1hv47tb+uGNmD0OMC67Sj8xI1
         DilabYwDJs06kyalz2K5iD4w6bn+bXvDSafhB9mSrQL2h3rapJsU6EXAi3582ZcM15n7
         4U0DjLzy1/ukD/786VTjsfPwL/vXTfPIc52I99DFYga19a7R9RTUF5AYjv/+B8pAn2UO
         czNWkIcgi4f7ctmtfXwda+xUXQOECsuZ2kDSyLuDiu0XsJoI1RwaX6I1Le3k3MoUG6hh
         ylfCpvyG86NuthT5ps/v19K2pUnXs6i9Gu2ehlIE432lEJJ9B/ZIfy18NUx8r5yZ8e7+
         2aIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790439597; x=1791044397;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eRtKYg0sOGgBmCELm1fPJpD8C1O0ubIGfHJNiovVGiE=;
        b=wTjIn71FCuAhK33GNmLITQjxTL+OOQj8dzARmB5OyJ4qYX/KPB6E2VktXTrLkwcRgB
         aIV90+6SLMCFNPT+HUjKGZvWjD2fILZyEVsdkOv47QALG9pVWo+0vXY6c3qUocIJVm33
         EXAoOQR1trptOjExTSymTh+QpuOBymQxPAb7HJABTyBVH+gutyWZikk0zd1CdPCe8Ssg
         N8SRh2RIW3lYhgkJf59EDoc50DocTfCcEDBy23Gbf4JfmZVJo7/+TJN6FH8vyzbP9KRI
         1d/JyEJodnJWRnkRwBvI4z3LMi7ycLy/vFXvzhAgp5qfuCmbzhJzw6hAAIyZYtLRzCvp
         VTAA==
X-Forwarded-Encrypted: i=1; AKwUvBxjMsJ1esmfUOBZp6lmhKJnr1i3FpJSoBAJFSylsPBXtMA18L/OCJdvx8nn6mrVlCfs9iwtU+qT5w==@kvack.org
X-Gm-Message-State: AFuF++lr8GolnL7s/NH8x2/QtMoYdwdQdv9yfcsLMQflFwNpFbVskCqD
	iNBs8H/Lplf4l9MwKz6kLqtD4WUWKFzPKlBScUkCWWE5ck4nIbcmLGFM
X-Gm-Gg: AYBFou0L5ioh3w17cS7ZCWIgkgU3VxNxHEZG0fzrMOTK6tR6/C9alQ82iaVD8VH70oW
	U9/CJUiygLGG31c0bOeSoWfNbD+1zcxIdJSyscl/ON8v3A+wDe8Ay0c23RBqpVKAOaFD+L916C3
	ADvgrlqaocLRtXBROV7YlatfKGLwcRzea2UwpYvjXcE2R3yvb2x9pW6Wssfo6YyikekTiExz3gx
	r9I6y8r5qI/HjV90YfftfUlCsEX+FTe7K9HR+d2//P3VQfqHUxemTwgZ5TiaMcFEMV7JivOIQbm
	D6tLpGTorZkoQc4KNh8BQo1PTcF9CR9MT4dkl0QkVZAg+aOkF7jTcDStGdFlsDPMQKolCB/0+Ah
	smvIOGX+Wy5AtriblGQgqqIwemCkjhhmTT4VYtDoi7mcKEOhjbLRsvTYmKOeb16XUPL8fxlLOwy
	1uGkLzsr9I/hiMO8FL9B0zGYnIMbFzu970cq13+dFQIYen/rHSlmNldV1SWU2KPcrhr0/D5bHVE
	sxdtd1kRNmStuEMgjig/il9dNikVtSkkesYh0lC2DXmmN4Q5Ny89yzqvwU/bijYNJzkFLT6Dx+t
	c3wTrfIt0TREjBcWO7qogQRjxLxNVK4WmmECkD4sNjrzLLBK5YD1+IxoLq3uALQR96kpC29V1rp
	StQj1
X-Received: by 2002:a05:600c:4703:b0:49c:fc6e:a3e1 with SMTP id 5b1f17b1804b1-49fe66fd374mr152026325e9.32.1790439597094;
        Sat, 26 Sep 2026 09:19:57 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-b162-c701-4960-a998-3de8-2fce.310.pool.telefonica.de. [2a02:3100:b162:c701:4960:a998:3de8:2fce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fef60da94sm102924275e9.4.2026.09.26.09.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 09:19:56 -0700 (PDT)
Date: Sat, 26 Sep 2026 18:19:54 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Russell King <linux@armlinux.org.uk>, 
	linux-arm-kernel@lists.infradead.org, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mm: align hugetlb mappings to the huge page size
Message-ID: <arfwK6XInu-S9COc@gmail.com>
References: <20260901085740.66283-1-kmehltretter@gmail.com>
 <5AB6FE85-4CB9-41EF-A700-BC5E071F29F5@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5AB6FE85-4CB9-41EF-A700-BC5E071F29F5@linux.dev>
X-Stat-Signature: xb5tqq5d5sy58agdesg9y9n5j8xnyx4y
X-Rspamd-Queue-Id: 8E58CA000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790439598-439847
X-HE-Meta: U2FsdGVkX18Gj7P73q6ylkCbunkDDCPw3F8jjIHyw5rH6hk5pG5BIUPzYCmvpQaypaqEj0wWOuZTl924KbEwucGVMIP1N8KZN57kwjxvNyimxsGC+X4Fgv8EdTpPxPsUNPmSEQ/XS4/XCVpPjB6FsUh+iQIbpJ1s/HaghN7pietwuLlZXYyEKjWrXwrM5d1nhqOBG7UAGXx60yndIpEjrmRzxwOz54UlwhZ1zCBKDrnZVTBN9YwUHe2U8B4pDS4VSv3dXFDpjMFUAeVjMtYpqJyKODm7cgVPbhbnzixFcFu7El4qQDtvaDb2ucy0hK7KuneEQmBytki8iKxVxHV6YbFJiPN/f4PbbsIDIR7P9Sft5TEljQfRfFARQEJy6QufCW82+QSAPSjzFO8k9AkoJ2dI9NG8sllLcMDCR2IINtAPdN4Gkfin6URUy1aTFpSLkNuAmEpsMMRtYAnS0wUbbQdf5fjGt4qtoeRTF0QqQQbeApUsa2hbP/pzyrdvbsM467QtLHc/JwEgJA28CuEvdizcfpFa7FoCltF/IQbBUJpI+HuEFNLI2xV3/zsaJf2L1npNZY37ih1Hm8CHIbSJ4rEWFHOc3FFRYvmsj6ZbJ6pFS1W9CSZFXWH5RYC34pV8C85Q8d2tHJs4hEZyrM/vY0DbHjqYg2Hg37DiaSRQ0lHrvXPDlpvHtJb6STb/ddvnQP7Vx3+n1lH7cIERpVFUAx/AhZKpKnupxgZ/gd7kNnRRDOYU8IxhicHL2g04NLIthXdtgWgGLeLi9Lx3BO4+nF+/uvhXEsGEHIQ62EQdar9YQ8Cx5VW4gvlNhddJOzMfGXnqztIVKbecA2wpuZ4CJrutiPV6ckHQYCocvzmn8rAXdfz18d1srC1mcQyqyduyS1AK/jhQEyGvawuOF3dZ9wJnw/q5psVp4rVKorgCFWoEH+7pc/K6TlSOvzTkKRQiXc6bMJS9zQVfrnZdnUp
 rLI3qUrN
 0Xv5KWm89ahocLBF4X+inonnStGpyvvx6S5j212GMglf08IPY9csuzEdoLJyppexAfTP6bPHYQARDDDI1l5gSEuryFlaE4RLvPJ8Tdpgbb/s/EGmrpr14tHa/1/Hj61k3bJ1uzbt2dPH0OtWx/F5lPCPqAjTkkPC2uDKo47Pj881ZqQVn7+6BJ4vCCqFjwhtrTxWX0iAaXbT9P/YgmDZ+o+PkoO6DM4KWfi7Zo6cE+BV1WQxDeO02PU7d1hkn/ckqgpYczpavVotSMFdHH9HWgK1j6VYbqObifZKyYMhOV8iuE/1EkFWQ6SV0YbO7ZfhETY9Xqqn3Yq1pnmQahC7d/u+KoxKX9xcQGswkeiXPbiV2JOWTzE2KqrjDPmwMOM0dqF5aU3G7AwZY+bkbZpm1/0tXk+1A3R0qnZqOGHz/aevQP6vkM4Vc5QxP9E+o+VWcQ+98OOWxNYfy1mweLFlD5JqD74KsGFVWYQpNxcZVkuwUkiJJ3o0xKd8nFzo28j4eYGInIptvRl/JQd7YzUEp9G4w1U3ziiAxBJfPXe1pjRkv+K/oHRSJZR16OtWlf5jwFNoybTnZ1+r2+iXdz0nNQl259g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 04:41:30PM +0100, Muchun Song wrote:
> > Fixes: 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags")
> > Cc: stable@vger.kernel.org
> > Assisted-by: LLM
> > Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> 
> Besides 32-bit Arm, the same regression appears to affect MIPS and
> SuperH: both support HugeTLB and provide custom arch_get_unmapped_area*()
> implementations that only enforce cache-colouring alignment, not the
> hstate’s huge-page alignment.
> 
> Acked-by: Muchun Song <muchun.song@linux.dev>

Hi Muchun,

Thanks for the ack. I've now submitted the patch to Russell's
patch tracker:

https://www.armlinux.org.uk/developer/patches/viewpatch.php?id=9524/1

I'll also take a look at the MIPS and SuperH cases you mentioned.

Karl

