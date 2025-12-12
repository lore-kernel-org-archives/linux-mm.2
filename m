Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA271D4336E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 05:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492A56B0005; Fri, 12 Dec 2025 00:57:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C436B0006; Fri, 12 Dec 2025 00:57:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3B16B0007; Fri, 12 Dec 2025 00:57:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 173BB6B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:57:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1BAE12D88
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:57:31 +0000 (UTC)
X-FDA: 84209761902.16.12CF3D4
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 07DEA1C0004
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:57:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=se4oZAcj;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765519050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i21Se228o7e5LfVMJKhazW4UhnTrDBucZ7bfhKbl75Q=;
	b=TKl274wFBS0ODt3yJ8aCj/qk1T6Ea2ak1VuQWSApT/bbraE8XXi4ivG31dgS55evMSGVyz
	Jn8M8Qf2UGQSylInBv/8jFT3aEKE0oP+AzLpnAIigmg/5QumC6cByUHC0YW/e0kEu5NdJG
	aNaNbAIdGOF6NPieb6o0kxj3G4eAeDI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=se4oZAcj;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765519050; a=rsa-sha256;
	cv=none;
	b=GSwMnI4ksrFmz+QssqVkp4iC8QvcDHWykIove9LXFMouJMvOqUWRXbdkNwT15nQTlBX7SW
	e3bAZ4tvY/VUV8fTAuieGjNj5fEoGZlhYpfQqbsvMJkn/VskvNxS9bGxFSRm/uebeFulzM
	fj2p079LhsNIlcuEZsMpegnAVysUXlA=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-78a6a7654a4so9435867b3.0
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765519049; x=1766123849; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i21Se228o7e5LfVMJKhazW4UhnTrDBucZ7bfhKbl75Q=;
        b=se4oZAcjHrdPZROx9G2ZwVivrRiu4YnCq50lZDZ+utEy6aNfis0idJxMEnrbcE9amD
         IPExJe23ApKh2T5dtAoehZf1SJq2ttoXSlUDJHM3LxqeX3YelEj1JasRqUe6VC7xv2/k
         IpMKyWSmB/j8MKglywpOjcCxmOdvL2yl9kvLO9b22KNmwnWqD0XZQIg3HH3b+Vc1in7x
         JRL/fiZ9Egl1djQufQatBLsEFIkHugDtx8XhOk1f943+uaxBYaeITpS1U226TVzLpO0d
         ZSVJY2tN+Op7eonJ2m/W3EB1njeHGyJYAHnJc0blmhTbpJwm3OZHNY0aNYMMfMfiG4W5
         XiTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765519049; x=1766123849;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i21Se228o7e5LfVMJKhazW4UhnTrDBucZ7bfhKbl75Q=;
        b=bQLT9SHcBJJBGXsFSPtLD1RBZ5+gZ674c776W1I7WXN40z+xx+oGR5vdCnhUoLZBF8
         BwMiEAyDDs28s5GTF0q04wmG1IEgdg1ku/XhI5apjiDcuagN/pDM/IZCNnhqhCKnH/nb
         KH5RBWm63SUWjSJBX2uma682RaJ7ED5KrKQYXKjZKPWf7OC9LZjCl5syHVFx1hexs88b
         /ua2JIXvF6DPauOzhxVnOLJvTk9GWgM0ejcaJ3CTQ28fAjIu+8ChPBXhfbp6R0mPAKOV
         D6jSVEN/wy+olkLxKwViiDN/tlZMfGyr0TNiQfFAuNiFKi1MPBMVic4wpTecQCb5qYSt
         Onjw==
X-Forwarded-Encrypted: i=1; AJvYcCXbe0DxXQtt4B4Y3nIHb33Sq8qLXPqe1Qxj45TfgzlziyHBWov1vJ3l33f5/eVOEhM8E36KW+21Qw==@kvack.org
X-Gm-Message-State: AOJu0YzgYO7Mc9FS16o7UFQ/UP6Z4X9aYsJOp8ZTT53Ho2fFVHAPUpig
	NzepDJE4rljX1a9NoMTuRGMQ1bLSLb0pJMv4Fd6aR1aUyeOj6mHZSq1mZ7KmUbWa2A==
X-Gm-Gg: AY/fxX6AfbBVfTet0x0VWqtO4tnFDj6wD9w3GmZ5/IjyJ5BMsMAwXWCg8C8Sm/lGQn8
	5bgdu+6ZuUM46rGYii9zY4myJ7zfipRIHLAz24+mLAy3JeoTsc8VxsHhvAUat3cfVLoBkUGczqh
	4cMy6n3ehNyICXG0SSP9RjbRQCD7H7DLIsuBlYNEyflsnjGHt7THVXuAvqcvEHOvvqy9V6GfgAp
	pyAvmI+py8t1O3P7n759a7IFEaQ/bZL8lGdd0muSzYPAj4qLSecwhckCfi7J3RW0YSvNaxOnwad
	I7qdEiTy0R5WIKZtnspaKH3V+LXZxEEkyG/PHtInN656keRbP899LD5dFHW/B0DrU+YU2J22KIS
	hom4AtN/s0yJcy9yCg13B9L5Ff0waYwXxkEAYU1v+IvpvqtrJxA5UczoqdVKEzFb4q4g0gVytVy
	aUD2Ohqwfm7GypFtDVI1hfaxj+tmz4Oejp8w7sDb6/E0WrZW/N9i7qi+nubrM+/8qfOxXSjp8=
X-Google-Smtp-Source: AGHT+IGZuHDsISTjDfQK5H60ZIz8jILBSpG+DpOMHG7/zrdVqW5LxRspyhN1oRFnpxvNHaCcPwfZVw==
X-Received: by 2002:a05:690c:6c86:b0:787:d1e7:e75b with SMTP id 00721157ae682-78e66ea2090mr8375797b3.64.1765519048813;
        Thu, 11 Dec 2025 21:57:28 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e69ffa216sm1656407b3.15.2025.12.11.21.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 21:57:28 -0800 (PST)
Date: Thu, 11 Dec 2025 21:57:15 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Hugh Dickins <hughd@google.com>, Christian Brauner <brauner@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 6.19 tmpfs __d_lookup() lockup
In-Reply-To: <20251212053452.GE1712166@ZenIV>
Message-ID: <8ab63110-38b2-2188-91c5-909addfc9b23@google.com>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com> <20251212050225.GD1712166@ZenIV> <20251212053452.GE1712166@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 07DEA1C0004
X-Stat-Signature: suhy61p6x9af7t8zw1cux1o7acmsnz1n
X-Rspam-User: 
X-HE-Tag: 1765519049-993188
X-HE-Meta: U2FsdGVkX19w2QPSulH1oW37rNbGsW+P1//UNZtc2T14L7RfOutzmIWW6fEmKyMwwDmBG6g+3v7Xumpn3dmZebP6hCOCyAuSJHzBTvfD8v61g1ZeUZuT192ucX2Tv8JLGscOwFYhlzn4U+06ZkuQ143z50kQ18KRej+z7OYeEsBbRporlqfuR/gFAsE2nxTuAvmPjnW8SsUlQaB0bxJF/HgALqhR2oC2xVKhOfN8dZGrjG+QUsJppnbjzL3Tz7yZ5ONUa9xD+3d/r8ZTGpKrAkLkIiP70Xxm2mBEp0gsn7mSyBl9XSSdItkLuJf2d91irqorOSrk7Iftb5UAJNej0I0xTLGCvKihKw8x5OQ3Fq5JyxeM4SJkmxHwXwH99P34Fk8qjYFumDhQ1jGgdKPWjRGItTzoNN2C3nSFRsSRrVWIpjZ8qPNwe+j6ldGdUnRQt6TeQJBiLx5xbDdDgU9QMxRR8Q4sSV0Cdx1L7Pd3dZ0I1wV/UY/Fy8niUcL2+U2bta3ip7YE7RLzJnWQzJBJiR2PYrcg0oGtB2JlSgmn8FokEuteZ7j81Mmo9XfDsQa84Pqhxiyf2P0BDO4wEgVb3nyQHR2Af7MunivdXtzKu5ZUPK93GABBlnHptuimqSotAFxw6A+mkVc+jGbaph//Bg0u8IGLOsceIVmv/3sXR57062SZMLjeP2A2olh6lM0OkVbo3jfP/t4oejTjuws4Gom/j7dLYc1SI06NTZcfpHm/gxWQX25cTTWoroR702g9xRuh8RMUL+KKHsIQxYOWYWChkIQOXQ6GYpGGmZ2ZGIdam/xZtPr/53p42NE4elm8OxXYDaWcGxyOuLn5xrTNoaGliTCOGikIYohQEnUNHSm+zKwOZ4awVujfqN/PUq43lliVUq//0ch+rJXqHpicY8b2IdC6FPXamUFJeTnkTVNfLefotA2LsC6R0+0785MZmOdvCg4XTD7q7MY4JWz
 tkb4Vl+R
 GqbCQgZ3GFeRXFvWi90jdjTZgzk56vQ+G0vLi25t5cVyorVHhYelyhL80Lc+fNPwOG89RIMzryiiM2anw/uCGui6pvK3GCbwKpz3QNYHAFC7Kt2TvZvHyFukWa1sZ+hyICfjbrm+hN+PvGlMfyb8YYfTJUA/w9LpUu3oKqjQ6nGl7yODbbG2D+5S7nMB5by3aR6a3Xh1AO2eA64ieGDZvVUNJhnvbHGRgqVyOzTH8jU7C+wBb2cjTJbS8af7nN1+cton1tx8e6B5/IaaNO2AlNdJLvn/iP+JeAuiPan/l1WO3aIoBXKNafDDxYx/aWujRn39UTD9bSlMP/n2DIJLVICN53d/iPszBBUdLgl6ExdIabF8m8upZQGrqO3EooNf4EMDcjpMEwAjuB32T5J+yuMdxng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025, Al Viro wrote:
> On Fri, Dec 12, 2025 at 05:02:25AM +0000, Al Viro wrote:
> > On Thu, Dec 11, 2025 at 07:56:38PM -0800, Hugh Dickins wrote:
> > 
> > > Of course, 2313598222f9 ("convert ramfs and tmpfs") (of Feb 26 2024!)
> > > comes out as the first failing commit, no surprise there.
> > > 
> > > I did try inserting a BUG_ON(node == node->next) on line 2438 of
> > > fs/dcache.c, just after __d_lookup's hlist_bl_for_each_entry_rcu(),
> > > and that BUG was immediately hit (but, for all I know, perhaps that's
> > > an unreliable asserition, perhaps it's acceptable for a race to result
> > > in a momentary node == node->next there).
> > 
> > Hmm...  Could you check if we are somehow hitting d_in_lookup(dentry)
> > in d_make_persistent()?
> 
> Another question: is it a CONFIG_UNICODE build and are you running with
> casefolding anywhere in the vicinity?  If so, does this thing reproduce
> without that?
> 
> Because that's one potential area of difference between shmem and ramfs
> (as well as just about anything else where tree-in-dcache might be
> relevant); if that's where the breakage happens, it would narrow the
> things down nicely...

No, sad to say, CONFIG_UNICODE is not set.

(I see why you're asking, I did notice from the diff that the
case-folding stuff in shmem.c used to do something different but
now the same in several places; but the case-folding people will
have to look out for themselves, it's beyond me.)

(And yes, I was being stupid in my previous response: once I looked
at how simple d_in_lookup() is, I understood your "hitting"; but at
least I gave the right answer, no, that warning does not show up.)

Hugh

