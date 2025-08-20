Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3871CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 18:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F286B0112; Wed, 20 Aug 2025 14:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FFF86B0113; Wed, 20 Aug 2025 14:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 415BF6B0114; Wed, 20 Aug 2025 14:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2CCD86B0112
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 14:27:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A08D5118112
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:27:41 +0000 (UTC)
X-FDA: 83797969122.21.AAED735
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf21.hostedemail.com (Postfix) with ESMTP id E8FFF1C0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:27:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fTJAijor;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755714460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xBCFUOi9k8EaZo54t0KBG5qm58QTHBYGFO0Rbz+6cKY=;
	b=PesOeW5VOuYXNKXE6dICyR0rmwVJtwrCocAFhU60WlPTuDenaWX1NtOZjacV3saNLy0QV2
	j/2Cmuer7F1ZWmWtS1wfkw+OUn75lr0cL9ttPYYsSEelts4Ciz6SM0bueVr4atYmJGIKgA
	u3rZGZ4K3K1K1FC0TKPEBSQCUDcS5ro=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fTJAijor;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755714460; a=rsa-sha256;
	cv=none;
	b=5GBrMI9q9nPOEdYA9KRMf4CV4kA9hnE02LheuTUFS1/GJajDzwr9JHHZJ+i4XRPYrshbY4
	66ElGJec83GLty69yNIhLSx3DpHH8hl4gWmDJ8GXD+OKUg2mlh/MT4+5fOLNPS74uouT6y
	pQ4hFKkW+hctuCA6mRkPypJEYHVLGEw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 29142A548B8;
	Wed, 20 Aug 2025 18:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955E2C4CEE7;
	Wed, 20 Aug 2025 18:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755714458;
	bh=oFLkheXmHC67SEen1WsTdZ0OtW3OuMfl/32fOXPzKa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTJAijor/+hjR+u7n9UGW05n8/Cp6dxDGnfIHh+1uFNiFtyOIE4cxhPYy61jb5s/P
	 KaRxK2srhuQmodhMj2ECrqXgjf4ba+vLUpWvIaU76lqKs0J8U8FSZOf+jT1FxdSafk
	 ia20F4FKWkNM0sZdV4OnXHjN02qGXRG/JjtzgCGWZ2VHna9Xt1Xh7VwmO38OiYqtTe
	 0+Wsj67S3gpV7kPXOvsD3DBzj76CXVX+ZnjFAWLVnpEyoisqHnO3yZUXUepUUtGHrE
	 5XUxeyFvTG3NPR6e2z1F1cH4WvWsDmGBko5gQSHEnYCIRn/b78NgcCbBk5W/VtddLX
	 LmDjl/dHsXFvQ==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at first charge window
Date: Wed, 20 Aug 2025 11:27:36 -0700
Message-Id: <20250820182736.84941-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxMHpodpNQM_a=T0vf48k486mYqukCVnQPbanLh+G_HH+9g@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E8FFF1C0003
X-Stat-Signature: 3u953fbycyomumiqeuewae8egg4hiomp
X-Rspam-User: 
X-HE-Tag: 1755714459-9615
X-HE-Meta: U2FsdGVkX19jWVPnbkhU5IMFnjpLyoF96SDaBzrPb7gkkRd+xTT/UeQGJdQ7U8Vze83vbGYxcavIAi46VQLVZ69NkdFF0Rl5AG537ZHT8WnpiPp7D2w5HIRJebYfeQxlbnAKYYDY1dE3N4xsfys30ux862uoVmcfPBD4vPiTbFyGwB9ryASCWl+/50NZ+eCFL6Y5OGsagkMNnxOCIp+75gE3eiwgaavhI7rAR1/f7S5sI9JHXldKRa54kF/HFHI0+x4PV4vcqKhUfw/J76tAR1KqSU4oQO+OIxU9hq9WQ77yI+CLrhM8e29FpJEUGhFBiOq9huqewgYcHhIWj0OX+8/ncmk9AamZSFRkrD1sSXErun0Vfa9NtMo3gb7jBwGfHridbuMhNEnqQ+ip6ODIiXwCAi2T/QWqUThrC0mbkpoKZFzO+qFI7IT5/DKNE7gaW8JadK/9LHaC4vz26zL6PXxU1BXH7Dp1puzKcmtlnlOk/fYlX634+iyERVMsfZ+UGGmkONDVAN7Lo4hUWjupUcbia+DcjQmxITg1XX5bSdTKMkMTbWZDDlPMHNyArdxa+9+KoxZLiPxvLLpfATBiSR4bSKO7NKcABMNyLJyQL0LNLKZvM9y9hfe8mO1jn0VCuWqnuxF2bAs6tRBeIYnXzQ6bHeOvGFcdhaEKx1zGDTqC2cQ+A2uqXlgntcmsV65BKhWntbNbSGS2Exieq9fTjWMaD6Eu0j9Zn8MlFMMyQQUhjTaN3zfbZElsdRCglW58QSvKrd7FFXwyRqjbF6ADDSgcT1lwXStYCpwrLb/QA3xBhN9Wj26qCw/w7cZKpoBBZar3je4RONaYgd5UzGB4/Wf2dfe0FrttDlLBJqComIFXnHoJ0D5Vloa0+39kx7qD064dqyLLC89ZAO7IcHfXDVFV1YWnNmX17gSmvbPZDa0snBkvZJPt/LCpnmpECkqRypK1lPwJnWyyAvUwNKD
 L6VOR+Um
 HeQr52z8AwdzQkL4Z8U97F0wLgY74C0VFxci55TkJLhfhUld/fjLx9Wlde48l0Zjz5D4CvTJRktnHiO0VlWiudnkuArSXGr2nl7uUkY2XPhiKAsb8UzsM5ACC1PF1pkJ66zQIxP1yXnUiVqqkvKFmLa8aTXlWB31kbuOZPJZci3AMSviXtGHl3qU1wibe+liijUnIjcznlbOz+ywLYAGdvrh0dvj3VzYVdL5gE90qzYtoxh7/rbsoL32SGwROw/WhUyW3I3Q0OECBb7iWhRTuxsUadIKUxPvoumYlDpsJoFLIFeGE6QaTFrC8Y1VcXV/h9dJqVHhWgxDbKew=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 Aug 2025 22:18:53 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Hello, SeongJae
> 
> On Wed, Aug 20, 2025 at 2:27 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Wed, 20 Aug 2025 00:01:23 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >
> > > Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> > > include/linux/jiffies.h
> > >
> > > /*
> > >  * Have the 32 bit jiffies value wrap 5 minutes after boot
> > >  * so jiffies wrap bugs show up earlier.
> > >  */
> > >  #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> > >
> > > And they cast unsigned value to signed to cover wraparound
> >
> > "they" sounds bit vague.  I think "jiffies comparison helper functions" would
> > be better.
> 
> I agree, I will change it.
> 
> > >
> > >  #define time_after_eq(a,b) \
> > >   (typecheck(unsigned long, a) && \
> > >   typecheck(unsigned long, b) && \
> > >   ((long)((a) - (b)) >= 0))
> > >
> > > In 64bit system, these might not be a problem because wrapround occurs
> > > 300 million years after the boot, assuming HZ value is 1000.
> > >
> > > With same assuming, In 32bit system, wraparound occurs 5 minutues after
> > > the initial boot and every 49 days after the first wraparound. And about
> > > 25 days after first wraparound, it continues quota charging window up to
> > > next 25 days.
> >
> > It would be nice if you can further explain what real user impacts that could
> > make.  To my understanding the impact is that, when the unexpected extension of
> > the charging window is happened, the scheme will work until the quota is full,
> > but then stops working until the unexpectedly extended window is over.
> >
> > The after-boot issue is really bad since there is no way to work around other
> > than reboot the machine.
> 
> I agree with your point that user impact should be added to commit
> messages. Before modifying the commit message, I want to check that my
> understanding of "user impact" is correct.

I think you should make clear at least you believe you understand the
consequences of your patches including user impacts before sending your patches
without RFC tag.  I'd suggest you to take more time on making such
preparational confidences and/or discussions _before_ sending non-RFC patches.
You're nver lagging.  Take your time.

> 
> In the logic before this patch is applied, I think
> time_after_eq(jiffies, ...) should only evaluate to false when the MSB
> of jiffies is 1 and charged_from is 0. because if charging has
> occurred, it changes charge_from to jiffies at that time.

It is not the only case that time_after_eq() can be evaluated to false.  Maybe
you're saying only about the just-after-boot running case?  If so, please
clarify.  You and I know the context, but others may not.  I hope the commit
message be nicer for them.

> Therefore,
> esz should also be zero because it is initialized with charged_from.
> So I think the real user impact is that "quota is not applied", rather
> than "stops working". If my understanding is wrong, please let me know
> what point is wrong.

Thank you for clarifying your view.  The code is behaving in the way you
described above.  It is because damon_set_effective_quota(), which sets the
esz, is called only when the time_after_eq() call returns true.

However, this is a bug rather than an intended behavior.  The current behavior
is making the first charging window just be wasted without doing nothing.

Probably the bug was introduced by the commit that introduced esz.

> 
> > >
> > > Example 1: initial boot
> > > jiffies=0xFFFB6C20, charged_from+interval=0x000003E8
> > > time_after_eq(jiffies, charged_from+interval)=(long)0xFFFB6838; In
> > > signed values, it is considered negative so it is false.
> >
> > The above part is using hex numbers and look like psuedo-code.  This is
> > unnecessarily difficult to read.  To me, this feels like your personal note
> > rather than a nice commit message that written for others.  I think you could
> > write this in a much better way.
> >
> > >
> > > Example 2: after about 25 days first wraparound
> > > jiffies=0x800004E8, charged_from+interval=0x000003E8
> > > time_after_eq(jiffies, charged_from+interval)=(long)0x80000100; In
> > > signed values, it is considered negative so it is false
> >
> > Ditto.
> 
> Okay, I think I can fix these sections with explanation using MSB.

Also please make it easier to read for more human people.

> 
> > >
> > > So, change quota->charged_from to jiffies at damos_adjust_quota() when
> > > it is consider first charge window.
> > >
> > > In theory; but almost impossible; quota->total_charged_sz and
> > > qutoa->charged_from should be both zero even if it is not in first
> >
> > s/should/could/ ?
> 
> Sorry for my poor english.
> 
> > Also, explaining when that "could" happen will be nice.
> 
> I want to confirm this situation as well. I think the situation below
> is the only case.

Again, if there is anything unclear, let's do discussions before sending
non-RFC patches.

> 
> 1. jiffies overflows to exactly 0
> 2. And quota is configured but never actually applied, so total_charged_sz is 0

Or, total_charged_sz is also overflows and bcome 0.

> 3. And charging occurs at that exact moment.

It's not necessarily when charging occurs but when damon_adjust_quota() is
called.  More technically speaking once per the scheme's apply interval.

> 
> Is that right? If right, I think this situation is almost impossible
> and uncommon. I feel like It's unnecessary to describe it. I'm not
> trying to ignore your valuable opinion, but do you still think it's
> better to add a description?

I'm ok to completely drop the explanation.  But if you are gonna mention it
partially, please clarify.

> 
> > > charge window. But It will only delay one reset_interval, So it is not
> > > big problem.
> > >
> > > Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control") # 5.16
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> >
> > I think the commit message could be much be improved, but the code change seems
> > right.
> 
> Once again, Sorry for my poor english. I'm doing my best on my own.

This is not about English skill but the commit "message".  Your English skill
is good and probably betetr than mine.  But I ad a difficult time at reviewing
your patch, and feeling it could been easier if the message was nicer.

So what I'm saying is that I tink this patch's commit message can be more nice
to readers.


Thanks,
SJ

[...]

