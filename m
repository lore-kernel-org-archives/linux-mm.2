Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C369D73090
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 03:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290326B0005; Thu,  2 Apr 2026 23:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241406B0089; Thu,  2 Apr 2026 23:50:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156F86B008A; Thu,  2 Apr 2026 23:50:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 034C26B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:50:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6272A8B919
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 03:50:37 +0000 (UTC)
X-FDA: 84615867714.03.9F1864E
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	by imf26.hostedemail.com (Postfix) with ESMTP id B7334140006
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 03:50:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qnUDlCPy;
	spf=pass (imf26.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qnUDlCPy;
	spf=pass (imf26.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775188235; a=rsa-sha256;
	cv=none;
	b=z7qrae/Ogrc5NsHJZzZ/7wgS4nCDxFB+8Xhm/3vJVvRlatUVZTtjTywadWJJJiTo3ijm/f
	N9T21NspoTrxl65p+79g+w1P8V30uGr45ZSju/0uwCZ181p263YcTFeKdZDIDvXfh7SKOF
	K/MvckbRJfB2zMzmaqerYU750AOvmw0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775188235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQPI3LrOqxlbsCY21LUJwyhyqeC+P+kOUutUODQJ9hw=;
	b=x4db5Ai2R69xk0uEPkAiRsSt8HuDCf0ibM8IbGMmY84ltDFgk6GauzgzfE+AjrB4z/hXsF
	Wa/DjVvqQg15bXiyQx01PTUH2TaMmqsRr4kGUxWXX2sOIK7KbS9O51yUN4RX+bSrlCiX9o
	1V3CaS/eEqwfL5g2OkZlQmB30sdjX+8=
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-82a7539851fso691844b3a.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 20:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775188234; x=1775793034; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQPI3LrOqxlbsCY21LUJwyhyqeC+P+kOUutUODQJ9hw=;
        b=qnUDlCPyFKmCFTs6mraFpoKgrJyhRB16uin8Ik460EVmtRQ4ynVUqMyQilpnr7B9FW
         XVeYPbhPubaqYJ5SFrMkzC0jPcUbHFzxyUjh04Q2ZrZPBP4i3t4iqI26KdFZ1mU3Xrr0
         etHzrnCX5KpScJPLoxrn9IaBcUruS0PtWP6RXUgOmTP6YGJ1cynrR3AhRwC5GC4w6MnV
         pUqfAKp8NDo+qz7JJUIYzmXkP7uYL/rEtb7rJJLECAUHu4uPWUTvEFx83tL6MIEGd4K0
         Mf/ZVWgVC/kS4Mowt1nV2uhBxmGCaNFXYT8Z3saD2hU3pHdeuO4x8+HPKL1uEKzpGkgp
         FZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775188234; x=1775793034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HQPI3LrOqxlbsCY21LUJwyhyqeC+P+kOUutUODQJ9hw=;
        b=OqA6u/zW2PyMfhMPeO3XMvVjzWKzpJumSWU6rLAfXyIcwHQJT1KnjzVm5HyAK6FRH6
         5Vp+HicNKgtpwqQQkN05LfGrJr70LpMQ87Er7+19be7+wdkmbeuA7OtCxmcvDvGhS7sY
         KnKeXxi4CkfrLVb14mXUghh/tjFuirEFU4Dp92vaCSpdJWSyFINa3PYXPL76rOUSwu4u
         4TmjXOqHcxrHkaky6TXuaFP4TxwDZcKAm1dllrU+HYW4HlfLxq2FGGwoP/LQubnJzmMW
         bvoUQNDWsjebXTAUWtZ9SbL9dkVZd4b570CJM//R5EJBVKsRz6T7/eTwQQt6yoZ5bPqi
         lLzg==
X-Forwarded-Encrypted: i=1; AJvYcCWPI6Aj2+iOobQYu0WbekTN0rZSkAIjk3te3yJhoBcJ736r75le+UFBjdr4PK95xZomyjopiB7Yrg==@kvack.org
X-Gm-Message-State: AOJu0YzzVrYf/6ppQYAn78B1AgUHfxruACMFkmKokwG3Y1NF813puw2i
	gX2Xfrkv0yk5T2u8ZEl6GnJehuniERxXRBrdv2NNz8DCm42muiOdny3e
X-Gm-Gg: ATEYQzyaTa45pK+/sTZZmHf58tRQfxuMCafpKwEtcgt43OkZF1LdzCtKzUT7LdydxWl
	5xx001oN2dneK4XeNcoCGIMDAIhFb9zNeyV7+tBtSTPsBeZthJHRNoVUHsOoGeQEedly05h4tnm
	uxrbpBBMXNp4PmI3sABMwASNl8JoXB+lLthhk4gx11D7mfYPOu9KiW6WAc5xymRTSyXtB+v/B8v
	uH2+m9kJXl+JOUpwaSFDCAfUSynqhEnSh7Bu/G3nknA8hGYnOoEFGmKaOT8BUsVTSFqGs7UKC8H
	CmKX3MS7tYj8bZ2nCUae78EwGIa8NNNSiYisoPOxGVXfJ4FMuDBqaJUxCikdXx/+LqKTSR2VGr1
	qsmOm3WEyvzigi1xOd5A2eymqoG9XFGOicvRH1mjWU6M2DDJvUoehaGWxfcTQzgVU8AOc/rlyOQ
	xehlH5DcNrFccXlTUNEqQq7P5ybEehl5aOj9j0Ql6afCwH0KLYyKyRdGcroVmN
X-Received: by 2002:a05:6a00:4fc6:b0:827:3ff6:fb72 with SMTP id d2e1a72fcca58-82d0dbc3143mr1571310b3a.51.1775188234433;
        Thu, 02 Apr 2026 20:50:34 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.223])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c9cbf6sm4919005b3a.52.2026.04.02.20.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 20:50:34 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: zhangdandan@uniontech.com
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com,
	urezki@gmail.com,
	wangqing7171@gmail.com
Subject: Re: [PATCH] mm/vmalloc: fix KMSAN uninit-value warning in decay_va_pool_node()
Date: Fri,  3 Apr 2026 11:50:27 +0800
Message-Id: <20260403035027.2052972-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <DFF3B3301CBB8797+20260403033017.23370-1-zhangdandan@uniontech.com>
References: <DFF3B3301CBB8797+20260403033017.23370-1-zhangdandan@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B7334140006
X-Stat-Signature: xkhaacuoo8wzstuecykxgeubqhppm5jh
X-Rspam-User: 
X-HE-Tag: 1775188235-559854
X-HE-Meta: U2FsdGVkX190YmX8XH7frm1BmjbWzZXcQuOwHwIcBwgcYztPIWAyyr7EqDOoEWYSGSc3/mFJUMRiTr5xpaB+iNfyGSV66CVjYU+M3CDfCU/agyTZQzCJcnKnxfMsuWmmleisdCemkJ4AISDbSIpaSG6Udmt+YpKOwEBmDum/1bMtpMIXCv+sOcQizwbPtQmzcSSx73fYBK1BD1gEgkIKVqd4l5Ro9mGScZFNExAPYkxkZkawCpdofFVA+Z/AcWabTH23/O8y3fMQwwicUSTllMDTmtWvagYx1zorpd8vdr3DydmUSVgUKg4iBFy/eAnu2bvrnIazjlKWljgSGxgS2XhA6YQjuPs939Hxph1zG8CJ4BsJIXUxRrtCvov6SXnQwSpZ+sPhxYBE8YVcm8EV2E1oyHAWyzbrMYoYCZjA3OPf4p7M949DD+TYMpb++SnOk8kR0PE33BreH76UJZ2nuPuGeL8WntaDH0B/yS3zyZZSmh2KeBReX/Sus97HUumvldOh8ov7h8Qr6RM4qXX0vUGQlaxxLBiQQL1tUj2VfMd7CbJbzXLK1AsyP/t7v3raki5PbeAx23b/CiHVmeXmS0Ib2FF8sH8pQWKZ11PSKJWxUcV1VVk9W8Ja9t1hIDfaHNACt34Pf3e7CklhgQ4hHOm4GdYdYTZpFlomes8kXjowUTGe/mYZI9009qI3EYCJv560QdowYpqKtvYghUsIrlzn9tDcm8HgQyq7MOeLDOUsaTXbood6l1Q1BygM120D+cjzG4jBW9TO8S/xlEpPSQZw9K6Oc9mpdtMHU+E/wG7W7Jnl7vOEcvLNorYW39+qAEBEiHHU0qqWtKA1/3nYmNsl58kdFRFx6JFDkgzN5u+ZuplAWISnlSSlfnBKBjLDwWQ0SmlTaudwY0hFX1VjLhBJxm3JW70toJGrEkajqK6k/w4HRM8Et+SabXsZYObS4mSuOPS3f7TuI4WGZqS
 LRRkYf71
 2BrUWGDSLKYpEISMtHhXUJvrdUp01EFlcclyXT4+rnPkG6Ia1HeUNMpC3rBUxMA6NSbrsOkziXq/xgKptHa3shPU3FVVFgzpGBwh1DhqnE364JHxBpV4GSJLn6G3B9vd4n0mQXh3xWhH5ZoTvbgnfHG7XPEma6tL6W3zQFL21UMWU6S9Hk9JRM0vQX6yofPsfhLOHePg6hTiJ6R1Uu9bQ30G3mwmJ6foAvrAIxeM2s1CIbWMM74g5nKeosw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 03 Apr 2026 at 11:30, Morduan Zang <zhangdandan@uniontech.com> wrote:
> While adding INIT_LIST_HEAD(&va->list) in alloc_vmap_area() would indeed
> silence the KMSAN warning, I'm concerned that it might only be masking 
> a deeper issue rather than fixing the root cause.
> 
> It seems that the uninitialized access in decay_va_pool_node() suggests 
> a potential race condition where nodes from a concurrently repopulated 
> pool might be lost or the list structure could be incorrectly overwritten 
> during list_replace_init().
> 
> Instead of just initializing the list head to satisfy KMSAN, should we 
> consider modifying decay_va_pool_node() to avoid using list_replace_init() 
> which might drop concurrent repopulate nodes? Perhaps using list_splice() 
> or a proper merge of the leftover VAs would be a more robust fix for 
> the underlying synchronization issue.

Thank you very much for the reminder. I realized that my patch does not fix
the real issue(concurrent corruption of the list). Please ignore this patch
and let's focus on analyzing this concurrency issue.

---
Best Regards,
Qing

