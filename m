Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F363AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35086B0088; Thu,  9 Jul 2026 11:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5856B008A; Thu,  9 Jul 2026 11:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAFBE6B0092; Thu,  9 Jul 2026 11:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB6FC6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:39:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59C451C141D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:39:37 +0000 (UTC)
X-FDA: 84969647994.11.5CA3E52
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 80F4640011
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:39:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eTnjEWRs;
	spf=pass (imf11.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783611575;
	b=K8Q2aIT1SlCXy7OFm7kkglaBwPwredSDfCe8/k52dBf8xMe9RyJdoY97tfpRTRa8uK4Fim
	gzxAkNyv6ri6Qz5b/An2mimCuCC+eJict+X3Z0RUFc/73uGNaiMcuiwaQstqRqBLQdLd8f
	m8Vtml3qlDzyzZsMu9LHzPCmlqkTCBQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eTnjEWRs;
	spf=pass (imf11.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783611575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXXGap0Q/LiZLJdfHOXl3AEYRU8Fj6byPx+ImpQAltY=;
	b=ZLFmV8okuIUimAuP+Tm+NqyJQsLRYlKJHEMUWo1Xsnm9i/XRjiq6jpg2+KQ7O9AIPaCgau
	mwGfa67LVUu/eDUF+oP/H9gkCyGh7iCJaPL80F4x3HwHCDuL2I3Nvxznn/ZhPDFy/RGeZ9
	CPZuh+G50JmD1S395pRyEpIQQP1enY0=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84537d04408so101558b3a.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783611574; x=1784216374; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lXXGap0Q/LiZLJdfHOXl3AEYRU8Fj6byPx+ImpQAltY=;
        b=eTnjEWRsESGy3/febTS3Ejrzx2DiN1Jza+zvySzE+8fhAFzh2CSwcz+POtymrG+FBc
         Rq50ooXUPhQEZjDAs3HP4o7YRyrFkQtEGfC3LBp5LbwT/uGw4ja5EfUd0pl1NOaV1agj
         UiNiG3ig62fNZgxqLbfJaeBTC2z9JoC+18aIF0WmczaHO3ICUz3NzImuJy2yIpcnhWBY
         cZiH9qHY+/71fa0coFQkRJB9C2vIyPWOUq6RC0IrrHr4Je8ixgsr+718P8dPA0Wefkiw
         NuRfIIOXWt8OQ59niwr13mhTgIyZD3b1R9O2AIsFqLrc5AWDRa0d45SiOkqHpjcmfoIc
         z7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783611574; x=1784216374;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lXXGap0Q/LiZLJdfHOXl3AEYRU8Fj6byPx+ImpQAltY=;
        b=SeaBelMNZ4Uo0tC3NswmTH8EUHSBem4I58xbOgT5VB8FbPy+QgmD6fvAosba9CHl3O
         3/vmYrIddlNtKT3aatByapxjEkpKtkFt/Z1I5VwHgsMFQzg2V6hEbSNDmViy3YCg0BiZ
         d+872hx5tZ26Ygcd4veRy11Ftk8LjFbcaoHFUclktp1HsD+RHIq6/7Qdeo1mHm8XtXHb
         LD9Buv22aAzXL6tnkZOwsqKo+6IE7IUeWTNNk2VMBUO8FO9pEJufrKUY00x/WiR+LjoQ
         jmPwCB+rBeZMoTzprF/UR3u64doKd/MpkuxLDfgv6GcXAN3i+Mp5TwWSO2Pz70vvzJ9F
         IDwA==
X-Forwarded-Encrypted: i=1; AHgh+RrjsObXT4vdy/QbQRpg7UVp+7UjT1ECGIDLaYTyaWtbHKt7WONVs/K6XW/bRjOud63A5AE3VDoIgw==@kvack.org
X-Gm-Message-State: AOJu0Yx5YtnA2EwriuSwI3gvW2EPyRiF8PaD5eCh2BD6NbF3l5aUFf5R
	twXRzJ+0+vOFdsp8bnGY/avrc9z5xHovpaoQHgkBseryGRBYaJ0jXpY2
X-Gm-Gg: AfdE7clSrGXnMNENXTl8vQuVzHfJEeWRVvJ/+f9f7psMYiUyMMnVDUbFRev4nj0I+YD
	ZicXBWZ9XVghjHa0RnwA4xRi2Z1PxSvwRTBHpfncwx8+mtXrfBkJxZbhMf36JCYwLyjOEjmnYkC
	fay1ojab/5Hjd1WpPqyfbHDM6M2UfmU31xcgsxfuDkcwNKkQOPUh2+wqATj4Cs7NXmPqQRGbGXD
	fXCjMF8/GcjGkc/0Caxsy3sAQns78V1h/ufW52sd/+WWdLAl3MOaR/uiuOqd2onl6t5r5baQ8Qy
	ct1EVbCxFc4iQBRs8mMFQDE8/mTCJmYwz4UCr2xNuyFlht5dcZhQhXPAXwmnu3k3W+ZtyTtsg5a
	ELbx5/i/gwGVDYr73g0ydPUGie0l499OyaGHkh0kcenxOQUT+5K3qeGTnS4QBrqmV5zRmHDN6oi
	fcCAg2FbAHKYHS4TQWlmFj75CPVSk5j1cm2xFSCOy+JSgktVgEUw/Db7E=
X-Received: by 2002:a05:6a00:a93:b0:847:8971:87d8 with SMTP id d2e1a72fcca58-848560021c5mr3191674b3a.6.1783611574014;
        Thu, 09 Jul 2026 08:39:34 -0700 (PDT)
Received: from debian.lan ([240e:391:ea3:6910::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84856d5d619sm1491303b3a.39.2026.07.09.08.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:39:33 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: hannes@cmpxchg.org
Cc: xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	baohua@kernel.org,
	zhaonanzhe@xiaomi.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Subject: Re: [RFC PATCH v2 2/3] mm: distinguish large folio swap allocation failures
Date: Thu,  9 Jul 2026 23:39:24 +0800
Message-ID: <20260709153924.772408-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ak-4d67hVnC2_BBH@cmpxchg.org>
References: <ak-4d67hVnC2_BBH@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 80F4640011
X-Stat-Signature: qmhr954t4751eindx4x3rcp4zumptimq
X-HE-Tag: 1783611575-623904
X-HE-Meta: U2FsdGVkX1+UtXuBAM5+uWV0h/gTmkvyEsbHlKstIVBZg+x07mwIxwSesbBzgcxQsefiI1ZHwBdFVXeezhD4wjV/05qu0Sq5dvCjRPm1Vy/0Eb/dg/eCsetOtijdXT57xLRqO6eRHe1zdZ0t+nwYYI35USNkqFN4l2XMw7D1WB/6BvZmyd3ITD0D+wvrwdv72T65y0j2nvhnC5TyycOoayMtnVntBoAcufmHCN7w6jNuLzzQhyw0TIcyB0+IZF/Dtc63R5VinxvrC4stOHGUkh7pJsTf+c2gQbh6hQSVCGfKmQlMAZzTY9RW0iujD2A7KJFgJn/aCo/0Z0lp9XDT97gBpH0r2jwf07PB2XszCi9HrdBCQvxAdC+3C6idyBtu4WvlH47m3Vb9PBSIyw6KneGsXL/3daFjp5idCyvtRaePmC66/jcpGtFJSm/kyCuZ2Jj9ZuWYI7+Ypd4PvBI5/cDrPck+AX9TfYv4HH7Kai562p810WUKNR3GTCMpvyliTUYFoxPCPAIP5cYWDCyNAEqXOs4vgR7jpFIb5iGUmDRxAL+a7FcP0NRo0BxOuE8ilRJ8uuBrfNXoGpIDSYkBRIMHZVeD9VfE1K3GhVNnAyJ8Eeh4wX4RCVcvVPA/YVrAmL08T79QjryLVP2e7XNA7d6g/5tcsZ7u660q10K5t7wMqPmR0l7Q0P10z3WsbDse7kHJKT4lm4587cL6A7gWXg1v7MSEN4+rb5UJ5WfF6ptTBiNWuW+nn8s9+Kk1XCrewYED3zxrRyXQsGRt+aaRSSLXw7mXsVDcd2fUOX3oaL8DuVweNd3ZI4nSqnZBGfk/uUEkDZ04tLdV8uWz7fAlui6SSUzA6eks6qMQ0o5ABMlrqU0OFD8LM3XYsSC2/LV3cBMC8DN/K6sFgeHZ5EkaYqrYgVmpAWHyWzkU54u/AuiB9szs1AtxU4lkMedP+ZxP6zIhqjhN2bMh9F2yg+q
 jeZuhyn1
 IbKefqp8E+gD+rmxUdaPXKr6X6dn7wIeUlRPum2oejawtMrDpjWQStKEkqLbCLAOEOcgMQCEIyhglselcE9NDn1tPeHpsjOYlO4Yo22jZffOFWKiys76dKTjiAKYyk4ljNiHP/HjLkzvm9CnsgqjhU5sO6RgdsqFMxE+f8ckm6m6hO7E25RHMolYnmMmUhCy/GyX6hCYnifluRzYc3K2Gs+THRlRpkgUkODs1wNiK2DFO4jlS21DeRX4XTJq59Wa1q55jKhBh7DX0RTNbOR6kPEnT+NC9pWm8DwByxxbSFkaXN+131TDh52wsr7K140P50XE8pki10qkApJV6aaYC/Rd1H2n1q05f5SgteOXJGgaz2ZJfHxVuMGc1JdqAdl26wFLSCQo9SR+vwEDcxMb6qfAwTWE42SdYiu4QX7p88EWvXMSttDqG02aSTbGIKkRy5476rCYrVsVOv6kXy3xtbKQFeA++6AtDmQGNzWa1IsS0mE1X3M8kpno7hXzE7Ctqxw4pr+qLKEflAZxbtspBmmKWf0taRwDS9XVjTRFtEVmaEaltZvZLBvydZZaTDV8BKjKskHoNByN4iTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Jul 09, 2026 at 11:04:23AM -0400, Johannes Weiner wrote:

Hi Johannes,

>On Thu, Jul 09, 2026 at 11:01:12AM -0400, Johannes Weiner wrote:
>> On Thu, Jul 09, 2026 at 10:51:23PM +0800, Xueyuan Chen wrote:
>> > @@ -5550,10 +5558,7 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>> >  
>> >  	if (mem_cgroup_disabled() || do_memsw_account())
>> >  		return nr_swap_pages;
>> > -	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
>> > -		nr_swap_pages = min_t(long, nr_swap_pages,
>> > -				      READ_ONCE(memcg->swap.max) -
>> > -				      page_counter_read(&memcg->swap));
>> > +	nr_swap_pages = min(nr_swap_pages, page_counter_margin(&memcg->swap));
>> 
>> This hunk is unrelated to this patch. Don't mix refactor work with new
>> functionality. Make the previous patch a pure refactor job (where you
>> add page_counter_margin() and use it here ^), like I had proposed.

You're right, that refactor doesn't belong in patch 2.

>I also liked my version of mem_cgroup_get_nr_swap_pages() a bit
>better. Please just use my patch, keep the From: and you can add
>
>Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>

I'll use your version in v3, keep your From: and Signed-off-by, and make
patch 1 a pure refactor patch that adds page_counter_margin() and
converts mem_cgroup_get_nr_swap_pages() to use it.

Patch 2 will only keep the functional folio_alloc_swap()/memcg charge
changes.

Thanks,
Xueyuan

