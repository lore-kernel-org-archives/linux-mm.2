Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0416C87FD3
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 05:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42ACB6B007B; Mon,  4 Aug 2025 01:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB8D6B0088; Mon,  4 Aug 2025 01:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F16C6B0089; Mon,  4 Aug 2025 01:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 219E76B007B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 01:52:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85D36BE000
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:52:16 +0000 (UTC)
X-FDA: 83738004672.08.69734EA
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8F0BA140009
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 05:52:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Vuv3SgPW;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754286734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=idg3NNQd7Aifs0NYERU3OcyOP33KhlyKv3C8P2yZD1A=;
	b=Ko5q8jGXo+YPLNHHGem9IlVJAp/Tx9FnNU94UV3yJQQ1GTQJA8KuCxqXRi5KGEh24gRYYS
	g0gphE93qEKgzPpX354VXVzoi5QJsiU5NR5mMFMT5BICJWJZUqMgYtY/y/szAMgyptxh2J
	jjUvQ2myHI3NVjxAFFwdEBJTce2Az2o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754286734; a=rsa-sha256;
	cv=none;
	b=bb5Tym5h1eRVwuhwR9LCJjw8r5Cqj9Fy3N+PvmPdbn56Puo15NRGtxOFLND0IvJASVMan7
	khyb0e8QGoANF1Ht/yCtZq3GUY/98CfTx7JLhK2TQ1LlQELLqyis/7Z3PVJnvEhLMMpiKL
	QPD4r8FXeSc6JOtDGEKLJHRvOxJZgGY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Vuv3SgPW;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-4589968e001so25401025e9.0
        for <linux-mm@kvack.org>; Sun, 03 Aug 2025 22:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754286733; x=1754891533; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=idg3NNQd7Aifs0NYERU3OcyOP33KhlyKv3C8P2yZD1A=;
        b=Vuv3SgPWatmeJfEsE/GKk7JkI8Okdr39WOfy6vD/Ha7/a/qc9QMA5Lvk11R8kjSIII
         ZPbF/TBkNYQ7K42bekxpG4d9PUkd2OPmhORo+/Krclo7DF2BbHlQitwkZljkJeeTPub8
         qt09UXyrJIZzOq3jymLpEuOBm9+y+8aUFiMajZdnIXbMvEe6ketAZgBQA1Je+kLkx4u7
         LoYmiv798Y/m8aRtrprJ2nltYkm1Z1SJ4isrkc4RV6iIcgBqvkC2Y/6lZSb7uTc8lYAf
         Qmb1MGGOV9hkxMGk2eP3knuUfwNTzaWID2ceQ9v8MDo56uGqWpBiTXua/iPEKh2Q9xG+
         wbDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754286733; x=1754891533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=idg3NNQd7Aifs0NYERU3OcyOP33KhlyKv3C8P2yZD1A=;
        b=rrPyutfkrOErAn8fuD8tyBhUT64tYsuRdfEO1L6kPZ5CQjSuxTgKmjBPCjQsdCcdjC
         XB1sEkf+Z0eatay5D2sa6uJIjcr9NQEOSUUcotILJgxTSKh6iAZFgdit7DNpS5TJwWqZ
         0hnkcYo+mhNGqXvf/7Q+ekw9dST34a1phxa3kC2IHv1tYwWNIyQsnLIcEiVCAJVMmn1y
         LqA3VZLTZg+gxSy8rlJV/kAgu8gMlGTfIoaf6wkUSNlEr1+hGpxtdb7x6bn1ipgRJU/y
         arUHurtOBs7glOKEFKku/Nhl4hmfjyQujKt+lPlUbH3DGSthkX95PxtvlxRX3+07ome8
         V8+w==
X-Gm-Message-State: AOJu0YyZoMn8R/xYKgpvpyS2zcCAy8PGlp/osIDD9QG5a4W8svZ7FGyO
	zOSTKabhDNzkv1JIxurFMFiTYc1fdacT8XD8hLyEfya1MXotfZnx8hbUUA3cfK55oDE=
X-Gm-Gg: ASbGncvVZmjLc49hFa9IqaXCbnH+udnSxUUXbTohPfSi5YaW6fiVXfjHjTy2++zhHbq
	u8A+QQZL+TSmhr8m3UI57scq+WwH4OnY06u2FDsUUAgPd6qGm4CpD1erwoD6/S3E/X9bBl9NN/b
	vIMe63ti/5PZBPb8irNiAQmiGIaGKslmbN39ylE0nCQ0ShKrTuTiE9CEUTMl3sVGeTD2YQdm6tg
	dMmjcD1UKfD6JGPGci2bh7MTfHYjqLOaiy5TLjoQNYEJLE4M6TDx32MPWIFMZCn5zs5xTgmKhoE
	7OiPEni32OXF6OBxCrQzXzMEyP5LpOhyT0+6UIJ7C01BjzJ0V5iFrlh0eZgINrf8lhNWUCfh2Lq
	NsXekLC856nf4EVM3y54fCOlk06MSt5Uf
X-Google-Smtp-Source: AGHT+IEb/gs7A5IisLAar+pvZRhJ0O+ov/gL2LSqq2vTlFreLuE94t0ionTmHOTEOhZ2ozfUiGkRlg==
X-Received: by 2002:a05:600c:1d08:b0:459:db5a:b0b9 with SMTP id 5b1f17b1804b1-459db5ab3a2mr11465575e9.28.1754286732845;
        Sun, 03 Aug 2025 22:52:12 -0700 (PDT)
Received: from localhost (109-81-86-79.rct.o2.cz. [109.81.86.79])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c4a2f03sm14103393f8f.72.2025.08.03.22.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Aug 2025 22:52:12 -0700 (PDT)
Date: Mon, 4 Aug 2025 07:52:10 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji@honor.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, rientjes@google.com,
	shakeel.butt@linux.dev, npache@redhat.com,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	peterz@infradead.org, dvhart@infradead.org, dave@stgolabs.net,
	andrealmeid@igalia.com, liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [[PATCH v2] 2/2] futex: Only delay OOM reaper for processes
 using robust futex
Message-ID: <aJBKijr1nR1CleBL@tiehlicka>
References: <20250801153649.23244-1-zhongjinji@honor.com>
 <20250801153649.23244-2-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801153649.23244-2-zhongjinji@honor.com>
X-Stat-Signature: wzyew9ryf193cuxktkduh4it6msrzryh
X-Rspamd-Queue-Id: 8F0BA140009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754286734-687215
X-HE-Meta: U2FsdGVkX18tAOkVdbHwQNLOnV91aPIYj7GdF30uHvcGbLs8HP4UHQN6eloI/e26tQpgtrny7+iaQRwpUeCaetlmXslGytYmpcSXqHYOU3DFBe2OniCHFVMgoTZmREgt1arJ6FId9BI1pwZx1FMLQmLAW84wn/CfIFNJnMW2WBxtM9RfvG06clxxAppgxufKnSpW6erfjSVFA+hlElqE4OYiZAlE48ZOorQrpZhVehig7vRGUcOdnP8L7JhSK36LfUbWv3+MOy1TTc6WfJk366kAtNC/9OhXUczBYgDFzIedGGPm5151KAZ2m2H4i3kfejSkz88kyZy5XJp78zAcG16K+De34rAylZtfrfn+fm9CC1PtjKxdyF+sKylIJILlBTN1lw+zbvRD0ArncXvFUf+aLLpexw3s+u/Yko/yvoDC+C9pocOsSiRZa/3VRgL9HRbFa88O+ttQ2qYpvVeZUXPkS9Mll4ebtB3BsERlOnRl5UFmctyKnqJaXRM9wKMyurYO4UbTq/GWLpaXzH+TmXIs0rYVbreB7DnErGxKdzsprfiJgXAz7zGdKujOU+LbCOMljveZ9nWtGvlwzWngGCtVgekFrnZWiDRc0NVcvq5WGt3hd1/ajxUhiOg5Qg78lDL998bPuZv9KP7sOyOax8y69xywzlEe2YGCaPmDDYTi4kkvblddgnTTooL8gnQDW142yQizpVpfGjw1stOXbkFHsorVZD9lmdRbYBA5uoN/sEyuymvCjqrslWMIYAqqYcwFhK/2PlRCjZPRg270oemaTfg15LP1aMrk+uZQyhkJ39QSrMnO0epUAi7wIJZp/t2mHO64Uh02gXtLhbDS1ynkSFSlqCqWOH/Px4uDtW2PbTGyewjM7KyKm60gJ+IQl4T3ZUUX5LOEYE7HPNUYdA94B7xhlGOsvDhgLPVyMGUd35m9X/ey+7vOGA9OlP/ErlbDoD7ARupEx89f/nj
 dV6yBuov
 dt1RFAoB0vcC6pbn8SxaRQg9uxXpRJ+/Xx1gZLkIkTD50HsIUvKREidgns11qDuuzMRkOxxd0SL3V+/zIf2JfoEjPiMe0+aIbavrlv9KAYgOUPCecrIoKM4qw/MVuB5aMYFMa1qNnvre0/ZRsZkQoU/5wOLC5VX18dBayN815vdMYyF2pv9GhH5UvdKEcRtkdpAcyptfGdM/RVZQagywtCsYFRXBymD1uYbtLJte9keu569exiPVAwkPzi7zQmI9kIVsLlIy5pGnKtN+TNETKJjgw3eV6hviteAQ0Rpof/qjzxcOq2Pikpsfb7KSBFlaB1EyqPkBE3p7VBPcW+4Z4sDaWG5vITYbMoatm5fxDE3h8uPEuBKJjDKwTYHzM8n57i6N4HiOGqNaETRxf4JRakJW/mfopEad7c1KFvTlvJ2aBgEe3gLooLVkU+8upUV+u5C40H9wqAlyuoFdzQIhW5Os9sBjQEupmnu8OzbryvBMFDEEp8Z4DxXO9BWbS7Y6KKggE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 01-08-25 23:36:49, zhongjinji@honor.com wrote:
> From: zhongjinji <zhongjinji@honor.com>
> 
> After merging the patch
> https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u,
> the OOM reaper runs less frequently because many processes exit within 2 seconds.
> 
> However, when a process is killed, timely handling by the OOM reaper allows
> its memory to be freed faster.
> 
> Since relatively few processes use robust futex, delaying the OOM reaper for
> all processes is undesirable, as many killed processes cannot release memory
> more quickly.

Could you elaborate more about why this is really needed? OOM should be
a very slow path. Why do you care about this potential improvement in
that situation? In other words what is the usecase?

-- 
Michal Hocko
SUSE Labs

