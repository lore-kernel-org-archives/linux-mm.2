Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DB3CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0DE88E0058; Tue, 19 Aug 2025 14:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70C98E000F; Tue, 19 Aug 2025 14:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960298E0058; Tue, 19 Aug 2025 14:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C01D8E000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:03:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E2F481FD4
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:03:52 +0000 (UTC)
X-FDA: 83794280304.07.60E768D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6AEDF1C000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:03:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rdp41m9x;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755626630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4yW/YbySh4tQ1C6hmLrN8qxsXiAjFwbt8uLVEK+Bi0=;
	b=WhSjIwSM12HGrFHEiLN2HEbkdwvMQlBMQIx1p+/P5EMPiXJGX0VaVpv2m7pnra1MeADNfO
	QChPdFfT6giOqlE/eTf0wCHMD7awhMRs9Uz3/6IxcBo5tM6ZHVZ76GcKzEZ1zXFswT+zoJ
	fkhJnUUgBKAJ7RZUYCQCKzV8jX37Ah0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rdp41m9x;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755626630; a=rsa-sha256;
	cv=none;
	b=c/rfXGVkdbt6iVTF1l/HmeX/ffzYGBFjS/4udrgwsAi+O73EqIAOHY9SRb+CW+N56l4LZP
	QfUQfCvC6EA7ZyznxRfIeBXAkeiD7Ry3957Ep9FZFyhf1As/eUxURpu+6Xuuq6uDhRxGkP
	Fp6E2x3gDTmkUyUkay/laSDp2V/PeuE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B02F456D7;
	Tue, 19 Aug 2025 18:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E74BC113D0;
	Tue, 19 Aug 2025 18:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755626629;
	bh=F62FyC88y55IwNEaGhr59itkIJTjmWaqtjD2Xo8S9lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rdp41m9xY68OPmiEA18fXO3+3gQXycbZPO3QBmePtHJd7L58Ni8M61MHwsNsqYJAE
	 lib0wPl5tF8kqZg1KPIf3fxorIBfxQife5TwhP7iYapUteD2gvZ2sDRRPNSIzg9LBW
	 J8Y59flPHO/IpqQI5+0KBtoMwumtp4UsviYXEAHNSx8Czscwa9hkw9sWxkbVzwerTx
	 gybQY4WiaxS7E1izEveajYzoh0vbGvkkXzTUYij0NUKxC6K3do2rdlv7AWUbvEU579
	 mFWof+W1KmeXYPIhPndXexMSynRAFnOZyOy/08g6iOnQCuMMHe2WRDS1f4OETqw+uA
	 AR9hlhJ2Ffyfw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Tue, 19 Aug 2025 11:03:47 -0700
Message-Id: <20250819180347.45187-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250819172718.44530-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dtp7szmcwroe7yb5wgukcak8z6cfu4dd
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AEDF1C000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1755626630-665769
X-HE-Meta: U2FsdGVkX19wdi9VMIlagQARySm3IE4Psn+LK6PGtQQNH7rF2m7zCO/QbuzDcTZjXhntRLVcmqYQ5oHqtSUMGmVxUTGQ8ALQvkQpw/8EN92ePbmonQ0SHtHYf31HMMCCUpRxE6k2Q1JusUiZiFD//ciDtMH5IC4W2oiresju9Gx1bWmxOeVYfGASA+WVb12doJVXubLTM0tA2xZEtANVmwMDHuXX+AblfGPrjroOqE7kT5W8c3zYrKP5udemv6UogDQpkRDYbKGgggTeclYo7rIWmUQu3Jfe71dvrrj2Z6+SvRz90q+CUiL8RLR9alJ4r4lcR5HZ2YjHun6SYg3obg8b4JI+NzDuWp3amczBu6q9Pd2/h+eHpI0ETQOdySdRzIBFPI58LUbs5+GTLdLDpjhDdWaUdtlKsRNZu1hUIcfuOIQTnH1OYf6e6wB1sjqD3PWRJEjNcCC1Ms7/c4iSBW+KVacLClSVO4xoMFP//ZnJx6EVQ3oISKHsmdBGDVOXKq/wPGudwFFX1WJBc40EW8NJAJ1Jd1qZSMuLT2BJ1n4Zq1O7ANyJh4TGY+0+KITlt8j/wajS1PgllK3y23B634Xq4afyWeq/O8D4oByQKaSM8U2zbKt/y9QwhqWg1C6zHSayM6R3KDruggdybgtGcolMFolGuFtnMSNQPrPHnH1xnOUtsNGicPzmXdmot+ETmBJUAtCPFHsXGhxJM2OQsVx9jv856mK6lxBh3VQPkiMWkOxXrQ5pGnsn0I6t91/kGduc6DZAAUyl1pVmpr4ziJyVivxgT15peEAQTMg0Ih+ZewOHX8vOHKQD+mG6i7SIEwN5tUBtY0+kdlBzMogVRIAU/KpSC787EaGAXHNqcBdPjaNdWl1ByOcViSEDTZqZjN9d0Lx2PI88senlXlUHTf4wo2sYT7AoKy+ZjVAI2xCEPCqgRac69Rkqc0hzeC6WndyRAsxTnfjpDqV5HDL
 P1U2kNGE
 m4jXe2iTdZEttcdEZNpn7N2fabm1DbprcRXfCW8MDF6nKiffdFO4d0DEiQFh2enZP0+hI7Hi4xunS/OwxvxejmoeDkCrN2oXiXDCjlnM/xBzomHuthgJlxvHTakKNgYSOzo1ruUB+4yb8RoGLxjy6HbNfkLsi1IMeKQ/wMS56gxdJMtzoBgDBF5OcFBywsUR9ATcgnFbs5mshfs+zJSSKJ9cHmw9zEPtRMCaB/xW7x9roxD28XkzYzkzBYcFsD81p/RnDiBiGK1cRm33bJTcDp8JtEESmCcuoUicCeuXt6yzbhbw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Andrew

On Tue, 19 Aug 2025 10:27:18 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Wed, 20 Aug 2025 00:01:23 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
> > Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> > include/linux/jiffies.h
> > 
> > /*
> >  * Have the 32 bit jiffies value wrap 5 minutes after boot
> >  * so jiffies wrap bugs show up earlier.
> >  */
> >  #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> > 
> > And they cast unsigned value to signed to cover wraparound
> 
> "they" sounds bit vague.  I think "jiffies comparison helper functions" would
> be better.
> 
> > 
> >  #define time_after_eq(a,b) \
> >   (typecheck(unsigned long, a) && \
> >   typecheck(unsigned long, b) && \
> >   ((long)((a) - (b)) >= 0))
> > 
> > In 64bit system, these might not be a problem because wrapround occurs
> > 300 million years after the boot, assuming HZ value is 1000.
> > 
> > With same assuming, In 32bit system, wraparound occurs 5 minutues after
> > the initial boot and every 49 days after the first wraparound. And about
> > 25 days after first wraparound, it continues quota charging window up to
> > next 25 days.
> 
> It would be nice if you can further explain what real user impacts that could
> make.  To my understanding the impact is that, when the unexpected extension of
> the charging window is happened, the scheme will work until the quota is full,
> but then stops working until the unexpectedly extended window is over.
> 
> The after-boot issue is really bad since there is no way to work around other
> than reboot the machine.
> 
> > 
> > Example 1: initial boot
> > jiffies=0xFFFB6C20, charged_from+interval=0x000003E8
> > time_after_eq(jiffies, charged_from+interval)=(long)0xFFFB6838; In
> > signed values, it is considered negative so it is false.
> 
> The above part is using hex numbers and look like psuedo-code.  This is
> unnecessarily difficult to read.  To me, this feels like your personal note
> rather than a nice commit message that written for others.  I think you could
> write this in a much better way.
> 
> > 
> > Example 2: after about 25 days first wraparound
> > jiffies=0x800004E8, charged_from+interval=0x000003E8
> > time_after_eq(jiffies, charged_from+interval)=(long)0x80000100; In
> > signed values, it is considered negative so it is false
> 
> Ditto.
> 
> > 
> > So, change quota->charged_from to jiffies at damos_adjust_quota() when
> > it is consider first charge window.
> > 
> > In theory; but almost impossible; quota->total_charged_sz and
> > qutoa->charged_from should be both zero even if it is not in first
> 
> s/should/could/ ?
> 
> Also, explaining when that "could" happen will be nice.
> 
> > charge window. But It will only delay one reset_interval, So it is not
> > big problem.
> > 
> > Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control") # 5.16
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> 
> I think the commit message could be much be improved, but the code change seems
> right.
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
> > ---
> > Changes from v1 [1]
> > - not change current default value of quota->charged_from
> > - set quota->charged_from when it is consider first charge below
> > - add more description of jiffies and wraparound example to commit
> >   messages
> > 
> > SeongJae, please re-check Fixes commit is valid. Thank you.
> 
> I think it is valid.  Thank you for addressing my comments!
> 
> 
> Thanks,
> SJ
> 
> [...]

