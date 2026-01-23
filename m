Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43798D6CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A0326B03A6; Thu, 22 Jan 2026 23:39:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961106B03A8; Thu, 22 Jan 2026 23:39:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E786B03A9; Thu, 22 Jan 2026 23:39:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 746446B03A6
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:39:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF965160F35
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:10:54 +0000 (UTC)
X-FDA: 84361600428.02.FEA5C99
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id DF765140008
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:10:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NhwL5G+z;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769134253; a=rsa-sha256;
	cv=none;
	b=tPC5kk18jqxLSCul2z6nKQUFgv2DxgqTewPygyJcVfPmDwY5W+kJXGTFFrFmXVVz4VqIJ7
	OAv1f82VNqD7LTmqqzt7iNa4bRQm2OgrEBu7rMLNOYeeapIgiTx9rIoy3lWUrNAkTrU6AI
	P3YQOxz/Ln/aRroY4PeUaonhSNVAg90=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NhwL5G+z;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769134253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnkdjRLLyik86QeUx1Ny0zHlOwLZlul47rX6Odqclp8=;
	b=fPv1E6QtXc0Z+cJMW1hl5aWAcR2SYgPnhnDLUHfQCt6BlNyumZasCqBa7cdSSu21lF641s
	nyRUOJi8t0bZEs6uVjzfce/CPeC68+YEpWQni0Kei2bDC8S1TdPABIWC53zOGliSBNhtmy
	Kdvau+BQW5+QRjrZdC2jOs29+TvJQMA=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29f2676bb21so18908905ad.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1769134252; x=1769739052; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GnkdjRLLyik86QeUx1Ny0zHlOwLZlul47rX6Odqclp8=;
        b=NhwL5G+z0g3zZaBm0e+5BLR5wFT5a9/dIXBx8bR9WJJNUcIelryWlnQwMZ9CiEkxeo
         v0NYiI4AAUjRLgPEJ2ryepxWxzDLMQ0xFKoVXQNXxRbuH/k1xEWPWJ2iZDoA0FSqTPBS
         QK5vDGr4brKOdqLcVzePZ3jcTT33o5KtcgJuo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769134252; x=1769739052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GnkdjRLLyik86QeUx1Ny0zHlOwLZlul47rX6Odqclp8=;
        b=q6Rz48iv200C+OGjAV0mLzxl0HqszpdRtb05GLFAH6NIet6o+GQuvF37zOZ9FvPcG5
         hWuW+1E+2ITnAHyYjtOZGPXYCmHGXT9jZ2KvSKr1fPESzfASn7gjHYMB7FMDWvgY0j2u
         h0mqcHX6fXMqeKMP3vGYWWRazjvzRGQmRxHN7+NgiuaAhcdqDC08ipAWSC667XjF+9Ry
         6nyUrm0MqNfj9p/8wMHEbEFFRAF/rtprum1RPkrNWJxXD753YLNwNBNAbYp3BxuN4ZSR
         GRDdCBSmrdHwoa9bS1qihWQru2H22eo1bvW7nRCVineU0E6ooyWiWDf5eJBMDoqWdtL0
         iayg==
X-Forwarded-Encrypted: i=1; AJvYcCVkUEI601rGobzt9uUce3DBUjmTRoctmrEi+qa+0fY5cVPaS1Qnm9RaGiBjWjbaU9WD2TqdFHn6Xw==@kvack.org
X-Gm-Message-State: AOJu0Yy3PD5hPUbS30vEBjBAVcN3fm/0r1XoDAMarwj13U2SK4Ys2Tkt
	yClR/b80572U/BWKcdOpwlSBUcauhDuz35ReQpv4dBal/eYUFQfH/WUZY4BlnBCwQg==
X-Gm-Gg: AZuq6aJ4b1kxiC5tST4wRfKSXVPE3XEXHQiJe5f3TMKJHqUcGu5fWwzjZFb1dl8uZLv
	R2m2F1XYo2V3/p0MypWjN2GLKZcihfwbp921Q6/2gsUsapIiShk4ay0L7zdDW2J94/JJ0mKYzd5
	rJBDXnoI74Btn63yxyZvbSsT9BURDOygkx5b5tItVDNnEMTS4qSC4Cd+IFH5aLhFcxbu4i4F7LM
	kwL7wlTY7iWnqyETW1Jbdw05rc8eBfUHxrPXznCnxgb7aszCYCkO0wMSq7Q6mJ9jiZFcwyGVyqT
	sN3kLnxBEWqAgOInj4ZtocstfZ9mRYqq6sMzFUditST8sWp1ckhX6/Nj9tRBeFlDQ9cHwEEXvhY
	wHkmtM1Wb55UxhjyBhz/uciGy9tpJf0NV3hGXijR8P08pkZAXGsPVTL9JSPsjiyqkyTqsuhNMgu
	0m4IbbWuWxLyKNRLrd5pmzQV3gJ5fJmTOxAbbOTbnuZnXJzbLO+2M=
X-Received: by 2002:a17:903:32c9:b0:2a0:9081:8a6 with SMTP id d9443c01a7336-2a7fe569454mr11360005ad.20.1769134250727;
        Thu, 22 Jan 2026 18:10:50 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:2a02:adeb:f991:ffa6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802dcddb0sm4940395ad.38.2026.01.22.18.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 18:10:49 -0800 (PST)
Date: Fri, 23 Jan 2026 11:10:44 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [next-20260120] KASAN: maybe wild-memory-access in
 select_task_rq_fair
Message-ID: <ioixoqdz2hswusnfcj44aepgnrrhz2stgelzbedmlqn2ybdc7w@5l274tvonwfw>
References: <sjs2vhhxipw2zl7kya5owkrtdvrmj52dlqwul3r4rlyuodqnux@4rjdigvqofcr>
 <3e3af3b6-28fe-448f-90f1-4f2ed0c651f4@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e3af3b6-28fe-448f-90f1-4f2ed0c651f4@paulmck-laptop>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DF765140008
X-Stat-Signature: 7pzbsy5ehr3iokd57bdhm4xoeo4nwb88
X-HE-Tag: 1769134252-334570
X-HE-Meta: U2FsdGVkX1/bS856O8uNTLNo97xYTft45/Fl7y46kqTViBL34yNlxmcJ1LPVfOQKTesdxou1G0WMr2wZ35cypNHiaoG9/Tz71yWr5fsZ+Qc65PaCWXpYzW3ZgnSn8fiuC9oDEGYT/YdHg1GJzU/gOB1dz06yfH1pDAtZGMnWCBaVOXZlljbwkvsEueP+KeSejftAmIoc3PE4zkGXhq9GZGGZsz5leqPPe8VdrrL5KMwytT4vwWBkSWMLiFpvyj9oDoaqpkSaSDb0M1Rz+op3J5h7PxsKcipAg7IuR9CkNLldNL9PqXht0qvi4UkSVR2TNPPWUye8qUJlHlmReiub83upGV9vzS7wawcq906ffhp9KUs6CCRiBVEJxCRtkaDvshKybepKtKNGGNsHc3B9q90GE9iNDgNkdB7JsFJ5uURinAKcnE4WemXsH5IWZRkR2mWbFL5SgcBYNH5N4iT0swd4tQw3nq3YOmlp1UsFu0EpzNzv/gsP0TKjhPBp5NtdXkN6PLqciISSSfHlC4tD7JTo80+tYGT9Pra+KPPonA3B1E/yOuiykkZ58kDKy9d5CwhzFR55ObM+pt2p7wXhssKI7eDu2VIejlYhnexYelieEJga74/czN9QLKXYlLINze46vD1AtO2sDqj+W5UDELLe8Sghv5N4EbK5/HjDxDeubjKz4HUKoG1pz6/6GC7oOMJeTknxcwkuynYZDYCHj7Kod4xuUOeyvx2riVpfo/3XclcKAWbdsAYb2Yrd2sMC5qSuROcotdW+gicP+mwGVTw85Vz348ZuXO8QXnpyvrAG2YE5vJ0Wb7/JP/VDdRjqMSDqhHNGGXosZqMz6Cvt9RLOkqRODsNC6kiq6Ehmg83YwMm5O8d2GFGQ9PqcchPbndn9444H14zLXnC+CrwJpEQCg9in9mVdSWA/8czpS3XUP5uLwVLWO4z+wLwur+GK2h3AiJqBPP5zzTAA8v7
 AeVr0HnW
 x4Xb70D3JErSoM6S/CE68bM3nT+I8zeoFYhxVVbwclpYReu/xIkf6TZigI0iwpS8EJye0R7WkCg5Se9GiJarXf+Z2WWoRDpKzaYx/7Zhf729xjjprX0tiYls1RMmPUOyhejAgfZuzI7ya93CjIs8rq64sEy+4swQ0ogw6Bgl0+cElh/UKiI5ymcgzEFVaAp1K//WaLtyWcTNpli116zTpzL6wuiLc3fod0qkStlemo0J41wHmYmyGkqjXEauFsIwEWqC+HaBt7OQ0xbojRtik1U5nf5ZCr95T3yNsyGMqVWv4qbbFvGEhCVCvUAYMpgKfozGBliFKsOMDgmZh29mYskK8wAc3LdL3YgnaeKYe0j5BafPR+KvtPEZ/rHLO7GRYi54VpJFtU+LdRJyrHs5LT7obNVjDgQxckgiYW3s4o8KhAV6eAWXz4H4Nlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/20 21:11), Paul E. McKenney wrote:
> > I'm seeing the following KASAN report on next-20260120 (qemu x86_64).
> > There seems to be a lot of stuff going on in the call trace:
> 
> I'll say!
> 
> > [    1.714941][  T136] ==================================================================
> > [    1.715713][    C0] Oops: general protection fault, probably for non-canonical address 0xeb1125008e9810b0: 0000 [#1] SMP KASAN
> > [    1.715702][  T136] ------------[ cut here ]------------
> > [    1.716702][    C0] KASAN: maybe wild-memory-access in range [0x5889480474c08580-0x5889480474c08587]
> > [    1.716702][    C0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
> > [    1.715702][  T136] WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0xb6/0xe0, CPU#2: devtmpf.X/136

Someone beat me to it.  next-20260122 boots fine.

