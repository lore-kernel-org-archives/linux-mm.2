Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B930AC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433816B0089; Mon,  4 Aug 2025 08:01:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40AF26B008C; Mon,  4 Aug 2025 08:01:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320DF6B0092; Mon,  4 Aug 2025 08:01:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 226EE6B0089
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:01:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94EF180254
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:01:44 +0000 (UTC)
X-FDA: 83738935728.02.53C961C
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	by imf04.hostedemail.com (Postfix) with ESMTP id 86ED540014
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:01:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dHy7IMrP;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.65 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754308902; a=rsa-sha256;
	cv=none;
	b=Hm2BsIc43wZjJwe85GAikmVszr9El3yDKSS1bTTtVu0EjYbVa3YGvVJXWofv3stKIkkzkv
	0nAAnaXkJQBkVo+KYXL1KlmHgMnXj3kqyoPZcf9LVs/9AYTJN2Y/KgUhUSsxgB1s6xbzCf
	Ktat1PQ3GhaUSDSCiF/gbvlq5qvS9js=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dHy7IMrP;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.65 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754308902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=di0riGk55zczJ8EKh7rIQmPGFzsVtoO3pRBdq0GJStM=;
	b=G75vk9Sw5RSbRKDY+D84QrohXBhio46cTijwXytAjsD4FsE6ukaTsju9aPSxuJs/CBmrXX
	AFJVzsyeTGbpX7vbjDw4v6oANBhIWao4gP2nfzRHclOQ/XXJNB9boTiS2Ed+w8k9zd9MbK
	+4t7p4m/Jc76EDe6d+f24TOuK02rTDs=
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-3b79bddd604so2774848f8f.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 05:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754308901; x=1754913701; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=di0riGk55zczJ8EKh7rIQmPGFzsVtoO3pRBdq0GJStM=;
        b=dHy7IMrPn5jNFPSeYtvzWkd+CJiRdjCzcFj3H0TBm844evcEwjlXuwEWwxeb118Uax
         6YD3phnfqyEUSHeIUMYGXY13yMw9f3jBZD6j/rouXcZ9bRf/zH9umM6QOO+DjsZcZH9c
         g1GjICZTPuk8tE0tdeN1dLvWTSrMnMHaDeQmKsnOdGB6DoLGQL2Q+8+OL1FvdMsAErNP
         vKm8tByRRfuNTCKmnGnSaCR0dQL6TSmz4v3XKYMYcsjRNdQUFXTF1q6VURJB34juPiF+
         x73q+HVDV/BXlT7isuku0Tt0mSfQZKavxoYhpsVcRudSWyPrNO5nIJ9ieVxGh0IvRBvR
         pCBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754308901; x=1754913701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=di0riGk55zczJ8EKh7rIQmPGFzsVtoO3pRBdq0GJStM=;
        b=eEQpUDgT/j3cckYI4DkIin2qMBNK+6arfi2PBOAhW4qqFDoRlaviZOR5FBUP3u4GZt
         DNVZ2+Dy1yTCFUWydkgrxDDkiL5VxhR7NwEVvjLnem9BfPiXNeuJgd3U2B03aY0iGE7S
         bYI0+jj4FvGWOL8X8s05iSqaNPkIS2gkGTSHQTCNXorzVeFuqS13qPNA04w/kwONLSMS
         ckXr+4AmEOxsjio2CeScx5mVtwcv/qJS/Ntrw5u6wFhrFmnfkpio0mXAbB0iRSAwFoqq
         iRXOcCbkyWKdnYw55n7PHZUbZMAMIsdq2OFnBoIX0HM/oZG+vhirtvqDEdpslKq+tQJv
         da5w==
X-Forwarded-Encrypted: i=1; AJvYcCVeSnrlAYPjGHuLHVd7E29vshYkRKhfFHekZoG8zD9zVjcJaqCPFARppdjlq+7HMhwHK7Q9JC0qZw==@kvack.org
X-Gm-Message-State: AOJu0Yy5kiJLZcZzrKrL/rCbFFsCGag5fKzfTmafgiS2aRdHapWZRBZf
	clmI10kuPfwWyO0h/8UQ3f+dADQhGtag0D0uv3CgdaEuGhern4cqyu5uSQbrf+m0lw0=
X-Gm-Gg: ASbGnctt3+GXaR1C9asEFrpskkVS09Mctr6VzIZ6GeIYg1wS+lHlAbDBKnrK1iPvc05
	4F6AV0yEqkej/ghPVwUJtqc2i+iV5ekiMpIWblGZ1cCrowZKfcqS8Y7gd/F/Ao+phAySP2Pc1Zf
	IeiTIm1k003HYp344AGFX24hbEjrGxUYNp4+ozSbd5Xe21U9L0md6nQO8eutvuoLHyWzrPl1xkE
	pWYIvOPX4AQpypX+ZHxyAHVg1N0dS73tPIIOf9RfuTjUk+dod6st22nWnvpuaTYR8EGTR5LGtCP
	oUiii1hY8QtKerooyh4jPFcz9OiY5pcvmhw+kTuVj4+HiAsFkh9sTGRXpFcbH56XqFCpPDWxxvw
	p4eyxAauCx+6YLIXrvnJ2zO73vMcp9gvBfVaa7HHSPTUsXq0d9JnOAH/HPemkfj1k5AGYaB+nes
	JUz0lZDS2KzA==
X-Google-Smtp-Source: AGHT+IHfc6goQ2eQE1kJNjz643XdqtkTBVPtH0xaI41xMBeazuSFtl5v9S2g96GLz7oEgyca65kjdQ==
X-Received: by 2002:a5d:5c84:0:b0:3b5:dc07:50a4 with SMTP id ffacd0b85a97d-3b8d94680admr7291293f8f.2.1754308900480;
        Mon, 04 Aug 2025 05:01:40 -0700 (PDT)
Received: from localhost (dynamic-2a00-1028-8394-58e6-9e1a-64e5-71bf-cbcb.ipv6.o2.cz. [2a00:1028:8394:58e6:9e1a:64e5:71bf:cbcb])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b8e054036bsm5498660f8f.31.2025.08.04.05.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 05:01:40 -0700 (PDT)
Date: Mon, 4 Aug 2025 14:01:39 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: akpm@linux-foundation.org, andrealmeid@igalia.com, dave@stgolabs.net,
	dvhart@infradead.org, feng.han@honor.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	liulu.liu@honor.com, mingo@redhat.com, npache@redhat.com,
	peterz@infradead.org, rientjes@google.com, shakeel.butt@linux.dev,
	tglx@linutronix.de
Subject: Re: [[PATCH v2] 2/2] futex: Only delay OOM reaper for processes
 using robust futex
Message-ID: <aJChI-LMwmuWEwpH@tiehlicka>
References: <aJBKijr1nR1CleBL@tiehlicka>
 <20250804115037.19690-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804115037.19690-1-zhongjinji@honor.com>
X-Stat-Signature: my9bis8gr38sy3x97i7ygynmzifkdgut
X-Rspam-User: 
X-Rspamd-Queue-Id: 86ED540014
X-Rspamd-Server: rspam02
X-HE-Tag: 1754308902-30583
X-HE-Meta: U2FsdGVkX18i+VWoYgNmBTUMu1w5sCb4ZCCXAx0zjXUrKb8EYrXPuHhaQGMYZrJ9UQ3bUnb7jnVURJleeIP8r2BwZ04oSGP6PFJ4VUV47p+zEjA6Kijs99sCL2A0BSVr7SnjjO9L2RTrgPK57537c2/Sl4dIOtnWSpkfM/xHERvJi1Zd9WraPUgEtZaeKKarrkcpAoeOycUy+7QPJZaYfLvP9wGGE/3JliqzDvWKx6iMqLyjXYrJLMhfaRx7XzdkWFyCGk4ryhv24IAuMxc+GpmJdWTQSnCDnFCRmtdzPG9aTdDc9CIhAMbKQwvmp0mLgiS94k9pxA/I8fBbOfrWoQ3+BilnF2TgnjooaoQLijAriDWDEWuvYP1eJZUDm9HjVI2SKO8vnig/IH5toIs+OOqmI7CQq6uEdSW7pvEKNvUG6tQRBa/41QUzoZqASEXHCCjXXlmnrQ9rBgRV/1kVknt6UWsiLwzLvWK3dSdgld/WnDTuv3gl9PuiUpWPF3/ogncPt42s9TdVIxbBbGHj2YTxcNesurXLE3TjoDD5zhvgETzADvPnNqcmP4BrwUB8JE2lH4JnTKLw8CvOQxsfKFhmECYjU/3sk/Bdp7DqECn0htkeAwPhKdenaba+g/Ht6Eg94g3cq4WA1tlNViabSbF9eEUhvwCeP/r11/GbPNZLIXnd3vCra68tnEMqPRwGcJpvuMsWrANnQhB+cJMFxgCmFm/0hjHx2m0DerbVpO2XcqJvf9N3e3UyBNuLMrIIP/XSCVkfUMZErU2Mozu564YQyxvWvdAr8++qq/rpfrYth7FmSaTAd/QDVxEH9klCFAyGRXWnXNK5ZacjXIyi+T+MQSk2nyyxdbpHUff2pLmhWmx5Kmg1S7lJbSdnQp2nOF+pK2tYCetfwEKXDyj+Ap8/Weo5DSgxBbTFgBZgrrq6bGTzt7Lo2nD1CI8z679/0JiygPy39X+TkNmzY/U
 FaDNBduK
 xsa/SQvb49eS08M+K4bGgnrCdn6D5ytJEQ+MctFbsvwSWd1UpfmjY2rIr2cdHlZdmTHzg1d2LBRMmfjllQE7053MH7UW/b1tSJk9du1FACh1VEXjqKOrNzmQagGxdT+Yk+Sx2NDdgYLRliTd08f3kAy9wihk2pzfxqjxrt/c9nmpBMDPOG6m41fuMPWEa+05USDK/OndOH6DE1ViK9A+Y2Cy4I3VkMPM2qPk8tssbYfIxtQef6IoGG7bQnXo4Awkyp04m+I+LZQLWDfW4Of/fTklBxiLm4yBMVukoR6f7gHKeAUWeoNK0bESnVuNimvhQkFSj0gt/XvuUbqOpVeRjYu5rFnnM/I45qpDf1zvXVhPuqHF2popN8jM58TExL+2yPKquXfMzaInOoOiLTovbOg7+Z64qOLSRMmIw8yrVXTcTt3E9M7jkUEfmSCzPNbshd9HQP2hXt5Adtfqt/k5KO8D2sZl9bIObnXeB5VuO/dp/AvUi9JJZDHbUFAf1KJPLC0uk3ZaYdf7PiGzxfhpicp7wJjVIf27MyVaUaxXqUXqhsnM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 04-08-25 19:50:37, zhongjinji wrote:
> >On Fri 01-08-25 23:36:49, zhongjinji@honor.com wrote:
> >> From: zhongjinji <zhongjinji@honor.com>
> >> 
> >> After merging the patch
> >> https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u,
> >> the OOM reaper runs less frequently because many processes exit within 2 seconds.
> >> 
> >> However, when a process is killed, timely handling by the OOM reaper allows
> >> its memory to be freed faster.
> >> 
> >> Since relatively few processes use robust futex, delaying the OOM reaper for
> >> all processes is undesirable, as many killed processes cannot release memory
> >> more quickly.
> >
> >Could you elaborate more about why this is really needed? OOM should be
> >a very slow path. Why do you care about this potential improvement in
> >that situation? In other words what is the usecase?
> 
> Well, We are using the cgroup v1 freezer. When a frozen process is
> killed, it cannot exit immediately and is blocked in __refrigerator until
> it is thawed. When the process cannot be thawed in time, it will result in 
> increased system memory pressure.

This is an important information to be part of the changelog! It is also
important to note why don't you care about processes that have robust
mutexes. Is this purely a probabilistic improvement because those are
less common?

TBH I find this to be really hackish and justification based on cgroup
v1 (which is considered legacy) doesn't make it particularly appealing.

-- 
Michal Hocko
SUSE Labs

