Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBD7BF99340
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 07:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AEE46B0005; Thu, 23 Apr 2026 03:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05FAD6B008A; Thu, 23 Apr 2026 03:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90A26B008C; Thu, 23 Apr 2026 03:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8EFD6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:17:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7108EA03B2
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:17:45 +0000 (UTC)
X-FDA: 84688965690.29.0F62564
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7A049120003
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:17:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=S4DSIbVq;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776928663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pt8k19vyvcqDIr8XmsEkmZnWHbLVSULR09dmEZb914=;
	b=ein8C3U6+YmeROoQjh7J1Ttb3EfVruUBk7v517v9T13VPyaZ/SPdxNC9DtyJqVPNtogrBA
	hUIHXU6YFXGj7tp7jjuTIvJg4MOckp8bwwdcbW/hnEfINHdfa1kFO+P+/gFw8iwaC/RGZb
	p5hF/ZGXME60fFZAtRDZ4YpAGCKnwz4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=S4DSIbVq;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776928663; a=rsa-sha256;
	cv=none;
	b=t4CspWqtpuHeJwcDIMTj02g6/ZFt3JbE+VamK9pU/kt+YOFYfEUJap+AVu6OivVEak721n
	8zwcpmaC2cJxeVT4F4uYMev38oLLQh+ZHPZF4Y8cIe9IEhXSQTzbUTcUVNXcD9MVhuohbr
	e67m9P3XC1TeKZ8BVCHYzAlFkgv8JQQ=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4891b0786beso37815635e9.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776928662; x=1777533462; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7pt8k19vyvcqDIr8XmsEkmZnWHbLVSULR09dmEZb914=;
        b=S4DSIbVqsD/TDINKMIFqPcPebi9T02yg1xHAQMtp08XB1PhmDYE5PNIh1jsHDtSRY7
         3KkXuAMC8NwLkqJY3aCVgBo9qfrTOlamnWZ2R+LbEwHv9L+B4WT34/lO/7zRzarIebUr
         3AZr5Z1MSjXdOV2svkM7DKpWGUUj5UrwlBUCyE9PydAPgtdCG2PtspysIIkZowL1uVB4
         XzEBiea9P3Rcbh5RN1DKtDgqpz09g7WqAIIwR6S26M4h/g0blS0QILEyEtCGA17Qs0+f
         XnBZQWGsTE4mTXgYUt+UUSKwW5hikQw27yvkS2PcheL5n5vLqqmzSAcss0xGTQ/LOoRa
         IwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776928662; x=1777533462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7pt8k19vyvcqDIr8XmsEkmZnWHbLVSULR09dmEZb914=;
        b=bdBupkPtWI16qI9zEkTRTbSAAMNbtLQEDrwUwe2tlJ8XYeQtLLvlRV16pjRKbbe6R3
         qWHGSo5jXFF4GUUCYSjXbPgIiF4yR5QXFNvIOhBhDyw3uGyJWC6B9ZdwufmH64/m4z0I
         s00TlneVDQMfqks55V+BeqmuznOIKlHdE2aAhYdTGQpeezN+Hi4zn/+JsfYNJ3eu3Djt
         7/gp+jfOjQxumqACKM3SX2nZywLv7PhXbmpNten9n8zKMx5sGsG5k5N7WXAZT3Hrst2b
         TJ00tPzze+RE6NSO1GVQdGPsMuVHZqrELkzIXfzvesd0nWtVW08MmJxXmKSASB47a++T
         kV5A==
X-Forwarded-Encrypted: i=1; AFNElJ/3co1v3GFZkavYvny5jGQcX/iUkGFYPvMMMgtk1f2+C4BUfXf25kbhaFA87hBYi/4aDV9zEOVG9Q==@kvack.org
X-Gm-Message-State: AOJu0Yz6OoVyg5ReHxqR7rYI9DvIHtiRMfGzxR00qzmqh8ag013csnct
	jp4CCOOTFvhAc93cuWl73UB5Y+29MRFaPpPXk5w7YKCtv12wFWEVqPyssO5L49pdyYI=
X-Gm-Gg: AeBDieuNvp6Az+h5xLhW7W8BZB9tBWFFzWWq3IQJbsAAdCb4koJ0ABl2h3/rSYbq5sq
	FhEL+92Z988OZFJyj0T4Sg4KLBIIfqbsqYVZbgfX9M55BAO7hjzgW6YTDtS+XL9KkM+3WYuHZJY
	sknZQkNa3GDDXNzEKOcqpRLUJAVPR1fXmTLZQi6JMe/MPANU2bHKyWwxFLyxiNYyZAIRtU1DMwS
	5B8AR7Wht2uj16/zyESIvI8jTOmYmiqKtKfWmkJvOljj9noUKNphx2ZZN5HZc8mu2GYsD+67vvP
	tuv1Ads43K8ZfAGztB5ZRe9Ra2IYJq3NqWPF+hkPhJHvVqJ7CRxsP1BlbFYX6oJi8jhEHPrts3K
	pb+stCgmjk+9FL59dDhzz9yv/u6mHC3GfcQNNBlkvkutR40dZe/guvB1Fj8jjG6dyO1M9iYY8r8
	WSfNNLTWCtPynooeGqv7msImMU8mh+aYXNmnrq/G0ej/J0+Lvoudv4/wfa/A==
X-Received: by 2002:a05:600c:37c4:b0:48a:5501:7995 with SMTP id 5b1f17b1804b1-48a55017b71mr161954475e9.18.1776928661638;
        Thu, 23 Apr 2026 00:17:41 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a5499b0edsm187793265e9.14.2026.04.23.00.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 00:17:41 -0700 (PDT)
Date: Thu, 23 Apr 2026 09:17:39 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, akpm@linux-foundation.org,
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	surenb@google.com, timmurray@google.com
Subject: Re: [RFC 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <aenHk3E-1ZIRI2YU@tiehlicka>
References: <20260413223948.556351-1-minchan@kernel.org>
 <20260413223948.556351-4-minchan@kernel.org>
 <20260416-planktont-abwinken-b9499483b939@brauner>
 <aeHTcXfCyCED4WSl@google.com>
 <aeHbf7joGitRz7rB@tiehlicka>
 <aeae2Cl4ybcx0fHA@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeae2Cl4ybcx0fHA@google.com>
X-Stat-Signature: 8japzxzbigxxe43ig94mjah38febijes
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7A049120003
X-HE-Tag: 1776928663-317917
X-HE-Meta: U2FsdGVkX1/tC7f4sFORXLU1lQ+ZUTFEYiXUXE2t/XRlz97AgBtvr+jP8POlHAxdzNAwPXGL07O1mS0Zq1EOrwM/OWpnkHSNUXt48CaduVJwSdKxb+GXGoiwnzaHTRD55Tic/Ns5nYom5F1OM7eKC4cfbqPJLKOQ/gds9Mb9Knv8pPaoFR7G9YDl1FJFNS/xppVeG2mQ39H4ueRNdg80DKykxfV1PbtSb8b2g2z5murIQGbyInTBqTpK/OWZ+xowLoMh6oiZh1v6wgCDMmZ6WAuDmg+TjnFlk/oFCkFDOKPgBirbtLEMPDiz1XuORPW8/fCriwZqujayfyA3XgmsxfaW81h2CXMP3W11cruxey5z/rdHkPL3NQKqT11mx51+73w1GtcScucNiZCkz6v68O0KPTtT3DPxHW1kl655TAmPc/ONkBFY8tfW5obU7XfD7GW6VbnNMuqH0kTMvlitsOMEzcwCCnlLyoRoyHBadgcsD9Mb9BkrFEsQJIipSnHvkm6IB6dqQLRa33wWMy5nad4F/CWumv/wFMStVxtW+yN0Qo8FulBwAHO6D0h1IADkprE/drHcSkG97XExXxndwD5ONxNXZyQhGiiuUvP9IBw/DOOdlTf2AyScgzQENBx2tsbJ/NNTP2NNssLtqeIxFr5aMWp0HVTDnPlxLk5DKWoq6zb1lX4BCk3puLE88+Zh9xWlhVdBHXwRWNVi1pQULOat+nMfEjj4+0AYP/iS7B1VjG5E1tCwjn+30+JvfUEEFTc4lHXz1pj3e3XLUtUvrHNCBV8f8clZJht+tkc5DjiRyvgE5FfSTgDINWeZm8mw1RRnKPlTDrAzOK7vHlgA3nBBpGSUG5ua9zHunJJ2bjwI0+DYTVpkT2oSdBch9ZyCnOk8pnBSYNUCqKvHjqw/LQmvfhEW3xzLRtuHrST31qNemax8F302q3VI/fDb+IZmOFhf3qmd90zARfDZT0T
 JYunQr6O
 pj+SlpJWHnsTIWd0GN3Hb/0dAD2VvQfAToMr7D6Ej5gGf6RenG32pHZWlwtwoh3vURsm56iFL0UuKDGjVdKOIYi9PZkc1NttOaPQBFvVYoSJxfhr/3KN0Fj1aiuYxtGIs8e+SMcnH8azTnN/Q50P+/xbRIaTPviPsKpDmoNaM53M1XW4OTdTB1dsvA7jqjkn2A3Nv7Ozh8fj4McY98AyCTKbu4U//MNVwSrfNv4oX2MMS+X+4Pr3siV5riSJp7Yt2YZOwm8F5nrw+7gLdcfT+6il1wXj5a/GUlpchpZMDQjQ3OVPpmETqhWk5y1Q5slmb/rCmoUHKP0LGmepVR1/41vh0KFT7RH9JI7M3j1ZGRAbqrW7Op7RKe9dkW1MPUwXGoHxvx81X6CneSyGgcIgCVkP1Fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 20-04-26 14:47:04, Minchan Kim wrote:
> On Fri, Apr 17, 2026 at 09:04:31AM +0200, Michal Hocko wrote:
> > On Thu 16-04-26 23:30:09, Minchan Kim wrote:
> > > If I send the SIGKILL first to satisfy the process_mrelease() requirement,
> > > we immediately run into the scheduling race condition where the victim can
> > > enter the exit path before the reaper can set the flag.
> > 
> > Why don't you just grab the mm before you send the signal and then continue
> > with reaping? You just want to avoid a race where the victim manages to
> > process fatal signal, start its exit path and mrelease path losing that
> > race so you rely on the exit path, right?
> 
> The problem is that process_mrelease() operates on a task obtained from a pidfd.
> 
> Once the victim process receives the SIGKILL and enters the exit path (exit_mm),
> the kernel sets task->mm to NULL.
> 
> Even if we could somehow hold a reference to the mm_struct beforehand,
> process_mrelease() would still fail because mm_struct via task returns NULL
> after exit_mm() has been called.
> 
> Therefore, we cannot simply "grab the mm" before sending the signal and expect
> process_mrelease() to work after the victim starts exiting.

I do not follow. Why cannot you simply do this
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5c6c95c169ee..b80a96f5460a 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1241,9 +1241,14 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	if (task_will_free_mem(p))
 		reap = true;
 	else {
+		if (flags & PROCESS_MRELEASE_REAP_KILL) {
+		} else {
+			/* send SIGKILL */
+			reap = true;
 		/* Error only if the work has not been done already */
-		if (!mm_flags_test(MMF_OOM_SKIP, mm))
-			ret = -EINVAL;
+			if (!mm_flags_test(MMF_OOM_SKIP, mm))
+				ret = -EINVAL;
+		}
 	}
 	task_unlock(p);
 

-- 
Michal Hocko
SUSE Labs

