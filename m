Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EF3BD66BBB
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 23:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8A16B0005; Wed, 17 Dec 2025 18:18:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6686B0089; Wed, 17 Dec 2025 18:18:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4E66B008A; Wed, 17 Dec 2025 18:18:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CCFF6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:18:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 558CB1A015D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:18:48 +0000 (UTC)
X-FDA: 84230529936.13.39BE34D
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 52FC71C000E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:18:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hSNvQzfL;
	spf=pass (imf21.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766013526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZvc3rVI0di0d/Re6Le5Bvc+vMvJtdhpmIxMnxjb6tA=;
	b=4HjM4z+m8UkXWa4DiO5b6x+t4VsEKcZ9FqZJWUp078xrVoq76gniKARce3yU1bm1o/Rla5
	CmZTVDjEUTgHU77E6+TZABYdzXGpP8HtpaBPd+ApkWO79+Acym2e0llBdQsp2x8CI3VEju
	2mPmFxsEG/Lx2ZDD86nwbGIgeSaxyh0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hSNvQzfL;
	spf=pass (imf21.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766013526; a=rsa-sha256;
	cv=none;
	b=Nk/w+AnqE3sCDepGd1oi/CPUYe5eYo3ai3GwwapUBBVXNrYRxkwtHFH25IHYHqJgVQ7iWJ
	2LBklx+S9eXJjvdCkXIzMurD5XZImlLjnbGSwTZrR/pyb0l44dNsCLFqvBcR6UWkeDaF3J
	OmJgBkk2DDS2Su+R8HeByjpcBNC0E6A=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-594270ec7f9so12138e87.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766013524; x=1766618324; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZvc3rVI0di0d/Re6Le5Bvc+vMvJtdhpmIxMnxjb6tA=;
        b=hSNvQzfLCzf2FcNvQ9otGgmqOFgdHjLA7yVPUx2dIZ82qZPMB/3nxUk7ydNr0l6ZBg
         WRZ5ymr5Cp0RD/7lsZEXpz0FHh3hi0/0GxaCuVAijCm3fCm7vS6EmLmKYdabhoy8oziZ
         fo4Vc7ZTAX/eVQEFf/pCjGL+xKBW61toImle/b0GTACf+3/DubDfjuHwIb+IAM1V1gFc
         fsmh8/wW+Lh6E/SW5JOPpnzKa3E6Z+1wEOfVp+gfh45WoHjsZfW6okiiATFPr+uEB9vK
         IiLlqD8pFDTISb5rS2o6f4C7rIAMCHWuxNwQL+3FIkDFQ7SoJ19jWcHitBwX1Ypi/7yi
         vUjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766013524; x=1766618324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AZvc3rVI0di0d/Re6Le5Bvc+vMvJtdhpmIxMnxjb6tA=;
        b=csGWvrRA3jI8xGZm7aKIkKid78tBENqy+sHIzZaTkjpMyLGQi/GSZS6mBUkv/nqAVQ
         gpRGwJ8RT0E41n65a4PzKc+SPSloIZ6zKFtdNx0BIzB40w0o1Uu/4YWgJMGAGY6MnCYZ
         WOUQHKwq7TqLbGgQvCvhruGtJxcEjnFU2LeuJVv+0Vuylp4qJqZftm5GYFo+V4Tk4boy
         5uR0+x+loTLXAZXrr0THiUlcbKyHe2KRrRD/fpGMudJp64wyTeVeF6P19+p4AWhxqb2d
         oUHYQCwk2wFNTcumIM7QEmdEajE2xHAhsPhyXfrZkW098ZjQ+dkQCtRWzUtxOI39CmMz
         D67Q==
X-Forwarded-Encrypted: i=1; AJvYcCWMmHa6dIh96TDd7jOAYi7ukOymn8zu425CvSwc6EqdbpSEw0cJukjCgL79vz5WXRbaqFQ+nfhaQQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+TZfLJs6DYUqesNk00hkEXIrkOORrWTTgHRoYGKSwOUhJNJMI
	lLLEhdYJ5JZtnatUKnZTKEALAI1rlrWXy0T4yWHaOHNfkcKqR7t9I3+u
X-Gm-Gg: AY/fxX4RtYcy4yfEUxMt51B7ZBN7ONYyhvsC9LOH3jjV+BjOD/hn/FJ2WnmHzMOvz44
	jL67JDGWCtyIhS4XCYEnxq0NjLswfETsGdpexm294L4yCwb5Mkig+SD5Pu3xvXgkp4KQUORX5cP
	hUMDgHIFEK1gNtLUFRe7LL+/oJfm/tPHz+xAZo2JEQ2RpK45d2na/eY76S822nLyVG0EwHalVA0
	rJXJKIeQbpIiuk8jyjIT57e7BTvwlbAyWad8nGI2iSBY8VR+ud43w7eTrvm8VCAGBjIabScs9hL
	KYgtysxJwwt8eUiwtRXYj0xobjlEfM0TNHn8KtI7UBAArwTA1q/CU3uljeUFbsSe7BZCDVTkEuz
	Wk63cssXKxPu4pd8ZIzLq2HXWa/RKjuJEFpnRG9IyLyBggW8/vl3cMEAqSXDuUMYFUTIXOl5u6K
	VYzb1LWsX4
X-Google-Smtp-Source: AGHT+IFoFgIAi9PMNEfIKCxeozWxswujwd1S6MJvMAmdk00BzJYAqN7Mqo6fE4Jz6OZ88KHyEwKy2w==
X-Received: by 2002:a05:6512:3ba2:b0:598:edd4:d68 with SMTP id 2adb3069b0e04-598faa5a3bamr5789014e87.28.1766013524025;
        Wed, 17 Dec 2025 15:18:44 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-381134b5011sm2807821fa.3.2025.12.17.15.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 15:18:42 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	pavel@ucw.cz,
	rafael@kernel.org,
	gmazyland@gmail.com
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Thu, 18 Dec 2025 02:18:37 +0300
Message-ID: <20251217231837.157443-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
References: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wsizhq8b431efx86pc3nq1ifr9qq6d7t
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 52FC71C000E
X-HE-Tag: 1766013526-215170
X-HE-Meta: U2FsdGVkX1/PhlFvnSjrPtWa9cMmxF/rO+B0UWr9I8Z6AlYlsmMVWiOfJeOICRDSu5Bc0HBt0cT97FZ71qq/9G5r3JlDdTfApqMjoJneUdO5jUgdIsksjMhPXx7y2ADtEo5OqQFgDufQa+S9Xnk4B6Q2SDmrwSAW+ldsxtfKf1oJHMKCHHPTQZCkmNq42EYmMPsAqfnOMnsIvfCqkpei230LC6w/q2mGP6NiifvcAuIRqgB5R9KUjWp51oP60pI13fm7+zyN5+2ARNRBkgMahU7XSR8UI6gjyqWobX4iHUPa1+DYf130ekHNuu3L3PkAmHYPLCxa0I8LwQJLi296Ycokr3UeTcqplVNlwGrGVrZy1NIgrIomiDWI7nIbUnPzi2t2eKIK/rNc2MoaXpnHCLktREsH9puAqLOhrHl4gHF956Mm4fkSsMR/eodheUBODQ7zK/r861rg4LsrARSvzcu12dyEI2URq+xe0xaTeS9+Dcqwwy6rhctUQBvGuJ7fm73MYcPbKRBfinn8gUwZSoDkLOwy0lD25360XEfRMpTQUhrnq53ebL2sXPEhKRwCXYPTl1+Dqgen9Nk8+SZmsjQNfllnDVAjt8WjDL9d0+fmcQhI7s4eU/8I3a5ljv9DplTYipUdGCBpRdzxGYMGbl90u4UzPXeYJAPqV/tIcUl+PxmWJeIt7w9cIg0ovkeiH2xQ1d76a2rtKCyTGuxugphcNW7OfaBJICxBt2JgcaLgQ21Bb0NBmQIis3/qIQLH2Ugn4pJoEhwtgRFcFkuIlUzMa5MjjGAtvcv/vMpCx/jdPfQ1jAUl5EJWxVLGQ+D7Oqg9h4AentelNbsLGR1eCwo+X4lVp99/P7EL4i86dH5CaznOKnCLMfN0dRRh+zkRiFqSV31HBxoZGJfUK8YfUKWqPaloIb8dmduoCXMHaRfHP87FsYJLkABX9xWSioSKvQySG7pSZYjy1eVDdWm
 DE496BJi
 x897DLc7oYgxF4eOwYkdXEReTkCwH0OjrZcxXoLT2l3Rkkmt5RbGUkvl+oAOOdNis/E0vqO2SS8KcXVaVHntI34genIof4/PWheXWFwvMJEClUeHqhXDGLWrsBL2K9/7hGG7XxPG86gUqrH6h8lIG5Q1bPtIC5C5Yu4R+ldfYpFhskHJtfdMUfVwffVUG8p1liLenP46Pn7r+H/1/pyGyc7nJLQXddCf+J/s66hLPptgTBwMs8Mj8APnYsFQP/FPYsmZt5VUFj8qD7Mkdt6KiR7aBoPMkD9YYcfTTM87EBXPa0LeOuND1JTXt5AVPwZ2VdfdAa7swWvOEp+/UqhzyykjQr9CsyGnRaEYxz07mFOAMT5DEBivq91O00yaXWnL1LerPrXoEA+FWQakMxp9Iyh0OGRsgm0IobsMNTcRgI0JNpkNZ4o+sfQLUi/qJvzTntwiXlpBNuz3KAWfoKCCvotOQraVe88xpPVEjFoQRvLvtlSSxuVw6BIpinhtvPkjXqszf58fQYYomNMaED64AyraY01xklH2I3cRA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mikulas Patocka <mpatocka@redhat.com>:
> Askar Safin requires swap and hibernation on the dm-integrity device mapper
> target because he needs to protect his data.

Hi, Mikulas, Milan and others.

I'm running swap on dm-integrity for 40 days.

It runs mostly without problems.

But yesterday my screen freezed for 4 minutes. And then continued to work
normally.

So, may I ask again a question: is swap on dm-integrity supposed to work
at all? (I. e. swap partition on top of dm-integrity partition on top of
actual disk partition.) (I'm talking about swap here, not about hibernation.)

Mikulas Patocka said here https://lore.kernel.org/all/3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com/ :

> Encrypted swap file is not supposed to work. It uses the loop device that 
> routes the requests to a filesystem and the filesystem needs to allocate 
> memory to process requests.

> So, this is what happened to you - the machine runs out of memory, it 
> needs to swap out some pages, dm-crypt encrypts the pages and generates 
> write bios, the write bios are directed to the loop device, the loop 
> device directs them to the filesystem, the filesystem attempts to allocate 
> more memory => deadlock.

Does the same apply to dm-integrity?

I. e. is it possible that write to dm-integrity will lead to allocation?

-- 
Askar Safin

