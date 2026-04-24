Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 028F1FB44C6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A03D6B008A; Fri, 24 Apr 2026 03:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378A76B008C; Fri, 24 Apr 2026 03:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E366B0092; Fri, 24 Apr 2026 03:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 150776B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:38:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2B9BC244D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:38:39 +0000 (UTC)
X-FDA: 84692647158.12.E1A18FE
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id B7D5F40007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:38:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=P5AWZQ4m;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777016318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7sRCoE676JeZHeB3B8L45JxboYFG9w4g6sbDNRxrI1Y=;
	b=Fp0gShyncNyqkQl+y8lJbjuPgrEFjC5NenOtQnaHTFk71wuPA6ahBLAeOwhH2UHqoGPaZR
	hw/p5IVzQOcy+yjTqiaZQJceYVAbcIeB9m/mdVTMAZIXpNS/ZXcfPL2OmN88Z2DP/WZBwb
	PJ6CIi8z6AAM+7ty4e77fHjKw3J4FCY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777016318; a=rsa-sha256;
	cv=none;
	b=0K7IQW6rHpwiU697MBmqFJ3tQMyIkhki/xC94xwu0VoWlJ7ZXTWZqUTN7aWcM9Lsva/xTs
	YIDctyAi9Rq5qv/3TWQ343jKK8uIMHl1kAUH6XHVj4guVlZAsAT2DbobfdcX8Tp8GVmWuu
	yR2DLsvGDMmqnIz9C2fYdWqegCMg0nc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=P5AWZQ4m;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso56108015e9.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777016316; x=1777621116; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7sRCoE676JeZHeB3B8L45JxboYFG9w4g6sbDNRxrI1Y=;
        b=P5AWZQ4m7TLJfaTDfzmwiuYJ1RzPYi9Sve5p4crcngVTh7qNqdFUnTtA6D21DvOSgU
         sE222oXRUVLSVf2MXgR+6QxDxbdPyN8Pp8/d+mcml4YeKlhamVb5RN9b/SE6JQw9hNDj
         M9n3V3CpHNzITZQJa5dD/LQl8w3Vs8uhoMcaq1tnBEbUCAiUTsnh2ABmLIZDcRfIxXmF
         Aq8HXsw4KEYTwo73nRePY8xXpPuZyrT1TrvFJh9/j53ncTnKUH1rAFilI1JPCQqTouEA
         JA/b9gW9H2wLG+tDE++lsRzka/4QWIQIsaROThWXGdrRiIranlNXx5clGWMz+3xis7dU
         6gaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777016316; x=1777621116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7sRCoE676JeZHeB3B8L45JxboYFG9w4g6sbDNRxrI1Y=;
        b=muKbydXC/Yyl8+TAcI5Kum54BG3fSOQ2g8GuOoE8e+ARNnPi0r65m3v0dlm/n0f2Ab
         AaEFaHUqxSxE83hbVIvZ1J9TAcr5hnB0alNloUqy0ttLyPwdwHju1HbNgzU4SbbiSrrD
         7d6cPPjlo3t/9K+bvzv4AdNnqJ6AoPAQ3vnuVwQwMdhkYSlphwmSX92F+WeOGHHFXYPZ
         pP3bQBmfeHniNoAqaepX8KrNT1FMhkvxMoIs6i+Bp06V4AmvePgcOWyPK4D8tcA0AM0X
         I3ZVWYHpzV4bHgbrFPYjZ4WAs5EjQo42SXmRtBFsz57mqkRWnWRGNMzOjrZdoK7dS39n
         gvvw==
X-Forwarded-Encrypted: i=1; AFNElJ+53cBkbDzCITDzhgpJnJFj6K+rlR+xAQmuTYZZqze+aMS6Wl064oXWBx4PeLmT579r1qntXrcC5Q==@kvack.org
X-Gm-Message-State: AOJu0Yw9WfnfXhwnYl9yIYA5DXs7c4PDN70xUxCzIZ5yk9/7Oxb8kubd
	P8Uki9mLRxj5o08EjzlzAKa/d9uz4Kjbyv0slGHizHVW4H3NKjk6219ZV0BAf/z4L5E=
X-Gm-Gg: AeBDiesfo4DIctnGJIgUACaC6VRZCcED5Gc2bPCk0HUtOqtJ6XEMv69dCj0DQmMMfKR
	6TybmhZYmSzrLX3AFEk7VutkS1i6FbeNZdWz+C6L9NF6liLLgOaVaiXBiSK66lOBt0rFpjg2dmy
	ugf1y/xVfdru7yfXApR33HS9CvyMvMxqRAHMlMB44bnjDbJuuLtFoY4ri6wH4khIzCoSD5enQe7
	87dy42TpwR6KQJFMI5KiAF+JoCUNf9KId6mH/BSVoredphtHNhR0AxsQg9Mzs6DNXDmWznYjvDM
	7rO+yx7zHngCm8sFWWa6YEqX7EL0V25mTFg6B2iREIS/kCZH0ZQdwuDpLecNRzHLu4B6eJOd6DB
	nEzNqfRh9V1+MHNBYjWZKzBvZr7XBnlvh0OtLdzCfFyq7/T1/ozswcjME+L7UTDA+kZhjZFhmJw
	WB+rM+u8zfb/U0YIYlV1sGfm16B7LJe4SJ9PfIKEPmmw+cvYU=
X-Received: by 2002:a05:600c:6206:b0:48a:599a:3716 with SMTP id 5b1f17b1804b1-48a599a3bfamr155991265e9.23.1777016315877;
        Fri, 24 Apr 2026 00:38:35 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc0f82bbsm979447725e9.3.2026.04.24.00.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 00:38:35 -0700 (PDT)
Date: Fri, 24 Apr 2026 09:38:34 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, akpm@linux-foundation.org,
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	surenb@google.com, timmurray@google.com
Subject: Re: [RFC 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <aesd-ojcfSFoZjsF@tiehlicka>
References: <20260413223948.556351-1-minchan@kernel.org>
 <20260413223948.556351-4-minchan@kernel.org>
 <20260416-planktont-abwinken-b9499483b939@brauner>
 <aeHTcXfCyCED4WSl@google.com>
 <aeHbf7joGitRz7rB@tiehlicka>
 <aeae2Cl4ybcx0fHA@google.com>
 <aenHk3E-1ZIRI2YU@tiehlicka>
 <aequtFtklmfbN7n0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aequtFtklmfbN7n0@google.com>
X-Stat-Signature: wsfcapyf1co4bsur3ugxxdgsbksbe5ep
X-Rspam-User: 
X-Rspamd-Queue-Id: B7D5F40007
X-Rspamd-Server: rspam05
X-HE-Tag: 1777016317-355910
X-HE-Meta: U2FsdGVkX1/Y05qRtW16GUqQkt5zSdmoXGmIs4jUPxyOndvyrDHUCiQ5eGYzpHT7nOQv+EzI8va5sSmXMLD8uSA0xO2Ze7tYtb2YV999kb+95VsIP0zYP0zKktrBMaduR9V8RppC4T3yIlvogm9Ha84x+riYYgmecoHn81kRA70a4ciSuT/PKIatQlqDwdwDhN4+PVCco6iNFVTZ72cmh18VzBdT8ixd9yVBDAadxbXE0HM1+YDu5ZXthqxkcARXSkfjFGEQ8t+5M527P6DTvTf9EC7y/j+c8UdI1SXpPtO8q8Yfcgd7ndueg/0l+FqfJUTsvQc8R5iyxTsraV9gQJAfWJ7n869lCarHBpKCF7/fmJWYhCd0pxvdki/sPel60cChh75/VU4B69XZb8gREzLcqsh5fWOwDq6hGmuFWieDzeDbBTZI82exU5y/c4wqCmaLj7sjhV5giVhhPbzdhUUJj2t4vXqckahv801h9RQM6+pn2hgoFvKVnrCRDU9EzjQLArxPjn9t7WOUVO2IH45HzidSkMoiZmmzeUq5EK+Mrp9GOK4CH116jSKYcVuHdToNWspcrOKnnAsnueht/Imtv7maFewkr5AZJY5Tccbb0KAS8t42uXpBGI4GzmEGrzOscuPeMYqoHb7SJpJyJTia9iiddPJx/3acR7b255emytJ7Fx+eRIr7SkR506bRgwyspRG2Gu2hK+kPuAF6k4Vb+h34YAXwbB3kONkIsJMjDl+t2Njao/hav6imiI+l7BugoMNPN2xWzbp7CSw85AJGGVeKosYx2kIA6WyKuPqr6C/fFjpuet41ln2N+j1vbfOY/iwGtxpjU+Ffc3TSzIIYB2UwpDV9GqQvfBkaZJBhsuKghJkwG+uqxS+jTZdkAOkkguKjLzrOAedC0XL/9AVV6zNYDJJ2FDfms7wBVYX8QsEtHw9KvC++BqFrAp2vaWC98XBAbxyh6ubbnGu
 OR1dCbiQ
 7gL1EmQjSWsV0qHnmpg0yzkni9CODEvz3fyrA137ONgrKH/7Mdx5OvvCOwz4fYgGOTgoKKjvtpQE2dyc8GZnFqW0W/US398CyQWBtzARgN0+dTFLIJRWlPNrmSmNgXScRsChLZOrfDbiaVWMP1qcQ43nKVrYYsfNzCtlJ/rAxcB3War1TMoLx3GD4R/9Mik7FsJlmu492S3rGYboNlK8fyShDVwIgsim4o6iWrC3+D9vXsPQQ/hOQhnCjaU9neswu9WMzkv1Uj7YGMM5zzBtaAQPD+VUU0d2xPLIN3zu/JRKFNjPnv5+slTVcEUek06PUz7aJj/MhJvNcdoPD5iKhF1y87GPclhTMfFRkokgn+4grd518HoqgVbtIlaTSvT5kcU3jLqWh5WWzC2mMqkbXayMEERqWB4adBVAnwOLXQMq1iKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 23-04-26 16:43:48, Minchan Kim wrote:
> On Thu, Apr 23, 2026 at 09:17:39AM +0200, Michal Hocko wrote:
> > On Mon 20-04-26 14:47:04, Minchan Kim wrote:
> > > On Fri, Apr 17, 2026 at 09:04:31AM +0200, Michal Hocko wrote:
> > > > On Thu 16-04-26 23:30:09, Minchan Kim wrote:
> > > > > If I send the SIGKILL first to satisfy the process_mrelease() requirement,
> > > > > we immediately run into the scheduling race condition where the victim can
> > > > > enter the exit path before the reaper can set the flag.
> > > > 
> > > > Why don't you just grab the mm before you send the signal and then continue
> > > > with reaping? You just want to avoid a race where the victim manages to
> > > > process fatal signal, start its exit path and mrelease path losing that
> > > > race so you rely on the exit path, right?
> > > 
> > > The problem is that process_mrelease() operates on a task obtained from a pidfd.
> > > 
> > > Once the victim process receives the SIGKILL and enters the exit path (exit_mm),
> > > the kernel sets task->mm to NULL.
> > > 
> > > Even if we could somehow hold a reference to the mm_struct beforehand,
> > > process_mrelease() would still fail because mm_struct via task returns NULL
> > > after exit_mm() has been called.
> > > 
> > > Therefore, we cannot simply "grab the mm" before sending the signal and expect
> > > process_mrelease() to work after the victim starts exiting.
> > 
> > I do not follow. Why cannot you simply do this
> 
> I misunderstood your point. Do you mean this?
> 
> https://lore.kernel.org/linux-mm/20260421230239.172582-4-minchan@kernel.org/
> 
> There are more details to figure out.

Yes, there are couple of details to iron out. The existing
reaping has some hard requirements in place. I am all for relaxing those
where possible (ideally without much of special casing for this specific
use case) but this is much more viable solution than KILL_MRELEASE you
are introducing here. Keep in mind that fundamentally this should be a
really as simple as trigger exit_mmap after sending SIGKILL. We are
reusing a large part of oom_reaper functionality because it was
comfortable but if there are constrains that stand in the way and they
make no sense for this usecase then do not sick with them.
-- 
Michal Hocko
SUSE Labs

