Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AECEEEA875
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 01:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D03C6B0005; Thu, 12 Feb 2026 20:43:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953806B0089; Thu, 12 Feb 2026 20:43:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8281F6B008A; Thu, 12 Feb 2026 20:43:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BB356B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:43:41 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA15B13A9BF
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 01:43:40 +0000 (UTC)
X-FDA: 84437736600.06.13C4498
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id D0AA820003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 01:43:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=QbeekrTP;
	spf=pass (imf13.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770947019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHjmq7oQCnTopIXFLdHO0WCCRKYh0w5rSxJt0mJXwC8=;
	b=R+/QSd8dQTCVmab+ETjMwNP7H8sQA1dCv3wNI6oMHp4vI7xaoxJgpixqLLYbQwe2M67AQO
	+lgc+dXBo4HLgH/rEHnIFjreAMvFYu04q4U+0cgmgEenG9wunD/P4t0B+tw8CzimU8stH1
	R055vWlO81+iDmbBdsVoW8I4F2E8yxU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=QbeekrTP;
	spf=pass (imf13.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770947019; a=rsa-sha256;
	cv=none;
	b=emusIsYmHxUpa8nc2BfwbMmLYzQh5vpojBofuuCavSDAxphZGqVsQh915TxyMevN5EOQz+
	5bu+SAfpnzmEWTB7CrDb2eVX6a89VgYCIlM5DGcb7vosF76H7ktuZ22aBWpOz1BUdP2QHu
	j2WWQSRZDoTu07vKYqa8ygDJM+Q9Dhc=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b883c8dfb00so66859766b.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1770947017; x=1771551817; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yHjmq7oQCnTopIXFLdHO0WCCRKYh0w5rSxJt0mJXwC8=;
        b=QbeekrTPXGk8kmYq0AZtTyBZ0FeE/o4RFxS6WPGSr4XYQf8ihhNkKzS27fxsW2X/rg
         jhd6PEs4p5ocE5XWuDjOpHSA1eWTnUsxtamwhFMWzroJbE/bVF8UbH1YZlRQjUdIDpr+
         oS9wL9nV+Q2XwzNeraqiqX4cOrgn2mcCMDABg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770947017; x=1771551817;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yHjmq7oQCnTopIXFLdHO0WCCRKYh0w5rSxJt0mJXwC8=;
        b=PTdkVr1+n30YwyNcQRbYhHdFPjaPFbwiivwM7bbvgqL6JX90hbdRkGCMq2UgcscArg
         44aPFkiNRiVLhh2l9IwI4YSk3m+stritizfCm8WZugoKFUqVq/jEvuwZLBF9AnXbYOHO
         jSDGCtnhzX1/9aXMrxAUFjxj7MntHfMl66RyMByK4cTR+3ZiZ/EKfTu8FAZGBpTmb3AZ
         hEwDMQeCc4bEJXkfIzj0sk60xJfjtRDVset4SIqqj/aG1i7+qZUFkJ+TyDIiJzQLUnqJ
         0AiUKNDzeHyrXsVo78oYgun/8eRiuuzuVEJPZKVjWWZJyAIddj0lHRna+ssUwzmwXnuk
         UHJg==
X-Gm-Message-State: AOJu0Yy5RjOMd2K0r87OimRN+eeXboKHrO3VBlUsZN0ez4zZ38QvLcTh
	lyhsUtDoa/n8uETmYz0+vqvHaUa7xncjs4U2/kIdpQwvwQW/iqTxnYR4QhS2bM8F9d6goXm0TMO
	UDgiUrl8=
X-Gm-Gg: AZuq6aIeX1wR3dA6oqtJQOKGQj/hdQCwNXOBWHOPWBvXTOxyC1hIJ0DxgK9Wchv4Pbh
	kyxycyEN2gOjgKarSB5jGcswYLV7U+mgOVUidUjeMjvPmfQgXF4GlhPWPEcnrvv3L13DyXrchbf
	VHIdKziZSb5jwkEXI0ybecsL5UYiaZt2ZhK1ZCNe+N8R2/agLe5dZOEwUwAv7IJ+IMwlZ093MyT
	h7NWsvSkgU2DpV0Efn/5eoRPuXDjOEwLkl+cRtu94HXzAunk5pZl0kXqcWsQDdpfOUaz6sLAUrp
	cCwWHiYyf1wRA/1Fe+R0jKLbQrSjMmjCme6kDWCk0TV2yt0daGhCyqPe0XhyJjhKId9m6dpX4Cm
	viKGAN1kM7gdDCMiXwcVbDuBUUnGGjmjvqsN+HDFyrb4soOls6J/pKefz5BzLHU+4EgREDzFX7R
	1T/bPHlTq5RdRLpq2kC2lYt0ILZTZVuj8qJGZD+26kzoq64UogDx9YoUXL/PxPTRVdyax2FIw=
X-Received: by 2002:a17:907:980e:b0:b87:2abc:4a32 with SMTP id a640c23a62f3a-b8fb41edd8dmr7985166b.18.1770947016617;
        Thu, 12 Feb 2026 17:43:36 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8f6ec65779sm204529666b.57.2026.02.12.17.43.35
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 17:43:36 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-65807298140so574740a12.2
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:43:35 -0800 (PST)
X-Received: by 2002:a05:6402:40cd:b0:658:bab5:57f4 with SMTP id
 4fb4d7f45d1cf-65bb12aafc2mr65432a12.23.1770947015516; Thu, 12 Feb 2026
 17:43:35 -0800 (PST)
MIME-Version: 1.0
References: <20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org>
In-Reply-To: <20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Thu, 12 Feb 2026 17:43:18 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiHK5_oBUdUiNAaevmN9f-ORe+QBqbRefAZaw-RbgEn3w@mail.gmail.com>
X-Gm-Features: AZwV_Qhnyci3h7J2gOjPBK9e5nycSau58MfyE6OpHA3pFmGCllIyDj5q3lOfKbM
Message-ID: <CAHk-=wiHK5_oBUdUiNAaevmN9f-ORe+QBqbRefAZaw-RbgEn3w@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 7.0-rc1
To: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D0AA820003
X-Stat-Signature: 4a8a5i7jp1j98y4dtkq1gxacxp436z9y
X-Rspam-User: 
X-HE-Tag: 1770947018-723424
X-HE-Meta: U2FsdGVkX1/gFphA/LwC/l2kElc1CZQVMsrZL9OSMACFx0AE2Xszo3xUmhQ7F4R/cmYYkM4Kp3dVhLO0jYNOoYPuwXgdmM5M/fWC7VXWp4PUgfediaojPa3XpOtOmUu1D2fLRt1DOWGawqZFpKNcWNecFIyB0vfrmXzKfF3cE9LWfGFnhnrznminm/Aq5Uw7bMscKweP+wuZ7KA/gFZHmnNoscXpT5+LpmKyWZyByp0zExn02Wv9AwRatDIWEHVwtMKNR/yGs+oTIl+Hxiqp28AuSohjEEyUaAL/xBCdEZQMuVeWx6WOggEholxMENuA84WqmhefFL7+2QzqNU5mUvSIVvdO0Ovccm1qTTYfXwMHWI8vvDuE62KkvElCbrPPMj3U8e597dhc7XJBtiYQOms4yUcP24k1xDsmhjLjlihNeAWnNKP22+PaF4IvvvzJDsgeEGlwBs/7QPE7kwX9oFKtI1SoMoQkgGWK9Px9FPMPMece+IOeaa4aT0fC593zkRWtPhkhe3ZfCHfi8fdl1koIb7JTGdpxxToTPSJoLPm8XsZlHoiigAuwpMr4OYmgixFcQl26hsGSTavxgzIhe8CpETU69eiYMskVeWBeDg6Nz3dNWyG8kKPi9TFK7BIfjpiFn5tHh1rRs8hOdt57yj1Wv3frp6rHZsaLrdSMJ5TmjMiFUgZo8ImMENrf7m7ZJiKaZb1aqNtJvLlIq7a7+JEMm4Lg2iRgkxkHVh8nuU9rCQaw/+uUTISdXOnErnyz2oaerof+WyhQnu90Z7Jr/KuzbMmGsu8zUb6UABPJ0gTvrEjebG0Q3ouQe3O6EmIix+xooB2dXUpmsE2ISnmXGprN8WNC1RwBpoJ0DpYPgnLRd4F5tNj1G5RQDwM5k+aYB3HGtOwjojsWmID/zT9Pl3ZFCbuCiN7ThrPffwG5EAqBw6fzyCVQR8UjlusgEw86ymulAxSHQRcTF/B8fLF
 9zg7KD1T
 UT4OHYt56Wy683xmQit7Zv1qawxtFX3BVTXdDkZj95xCxcw29dIWMYPqkVwqzwv1pu8KME9oQfgyn4jpELNoghz/KEV3ZLyI6R3duTqtjiMneq9oPeYdYNjZpTCqokuCfzM6C70IybCI/sMiR7So0Gw1bPTxsVYPCC//99hCxr7HKRQMHS4CjShRccdxbJeAQfStY+/cC2VPoJI7sHzlABL/ifK0866FVQ8Aqbgbaeby1VcYQUQuGF40ylaMOW1eb754dkQbndS0ztb9pVJRSTFkjqbv0/857gScWXLASVHbZqnvjk6FOAH7aS0iio6mpDtaLYlynpuV6kV4O5SNR+V3RjpgrVNJZOZF2ahkaUkeOAtA6TUfmmmYb1ZW8ujyOEMEw/eoLavntQrRK0qrwd9Vc1z5ozXtwIPE7SJv+UDPI6FBUqRk9zmMgCOzg2aYKYRRIty3p3TqCnYXet0lopz+wxKJ0HE4gPTqyQEtJ9ixxEHU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bah, I keep noticing these things too late, and have to fix them up
separately, but let's keep edumacating people about this issue...

On Wed, 11 Feb 2026 at 19:23, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Lorenzo Stoakes (20):
>       selftests/mm: remove virtual_address_range test

When removing rules for generating files, PLEASE DO NOT REMOVE THE
.gitignore ENTRY!

Removing the rule for generating the file does not magically then make
the file itself disappear in a purple puff of smoke.

That's just not how reality works. The past still exists.

And that means that the old generated file still exists for people,
and it has *NOT* suddenly become so supremely interesting that people
should no longer ignore it.

So when you remove a rule for generating a file (or you move it to a
different directory, or rename it, or whatever), that gitignore entry
for the old file - or old location - should stay around.

This is more than a "keep git status happy" issue. This has caused
real issues in the past, where careless developers didn't notice, and
mistakenly added stale generated binaries to their commits.

No, people shouldn't do that either, and it's a sign of being too
careless and not looking at what you commit very carefully.

But mistakes happen, and the other side of that argument is that we
sure as heck shouldn't have files suddenly appear in the source tree
because they aren't properly ignored any more.

And I'm sure this has happened many times without me noticing, but
I'll keep harping on this when I _do_ notice, because people need to
realize that .gitignore files are very much about state being left
around by the build system.

So you *add* files to the .gitignore files, but you don't remove them.
Not for a long while, at least - people keep their build trees around
for months (or years) and don't necessarily clean them up very often.

(And yes, we do have a "remove-stale-files" script that is intended to
deal with some of this, but it hasn't worked very well, and if you
want to remove stale files I'd suggest you just do "git clean -dqtx"
after you are really *really* sure that you don't have any interesting
files in your source tree that weren't tracked by git)

              Linus

