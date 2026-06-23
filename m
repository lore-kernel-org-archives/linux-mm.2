Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFEECDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 653B76B008C; Tue, 23 Jun 2026 05:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604446B0092; Tue, 23 Jun 2026 05:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5410A6B0093; Tue, 23 Jun 2026 05:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2940F6B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:24:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE555120427
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:24:21 +0000 (UTC)
X-FDA: 84910641522.13.4F5831A
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 13A3A80004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:24:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fzGLLJmw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782206660;
	b=tbAaWwiJFMLSllBBlinfuILhnAB3HhShtFLfhfcc2FhHVFA1+ZG6Au/dPa6YWFEcIBTzJJ
	3YSDoBgMwtz3agnCZgJDsmTQIj6uhn0CHuKDHIzBfydPD/GrQUgRxE6zM3oVQg8d8tMk8V
	TbIGEcwTHYG9BalFRa9F2zAxkd1epow=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782206660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Mg7/mS8RgXozaqYhQ8iMnWn2eKDtKf4olMO8sY5/wzw=;
	b=kzzMcl/Ovfb+9D8/v1B40WdGGqUL59VAQ5ah6s7b+AZIWw6ItCd2Yv5g9DQVjCLMuzhFBE
	pgu29BCp5IRbc8vQbgnxBUSMGkZxXXQhKyZIzt1QVrDQfyiEGaL7iPN0YOWzjzN3071u8m
	ut4IU/6ehmh1y4YM4R8DF9sFZVIPwsY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fzGLLJmw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-697dc263e5fso764816a12.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782206658; x=1782811458; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mg7/mS8RgXozaqYhQ8iMnWn2eKDtKf4olMO8sY5/wzw=;
        b=fzGLLJmwC4XQ9d6+oZNXmp/cXupUt7b8MjZHY4lIAoFJYZ6zYngxndn3djLvCUMDT9
         Nln/0fRD3TVLYEqbCzZyyEraSuH4nZ03rLkvgwsUB7qL1rMEOMar9n+U4aNgo5xHfCzs
         N179AEaa4dPpY8LFSi3YP/pH5ziDtolEKWpHAlpDFsZjdHSsphMY6Jq4wQjX2Jatca2i
         vNgX3w9MJcoGNpa/wFnmkBUz0QHAQdc6oh1UZ2orV/OA5/B0JajMAjXL+64qCd9EdifL
         1WNMJGpvCP3Y7tLQ6pkUHn03URkiO0MHOrlrJQ0OGKYa3VsukWpNcBOj3mb3iwVo6I30
         Z1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782206658; x=1782811458;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mg7/mS8RgXozaqYhQ8iMnWn2eKDtKf4olMO8sY5/wzw=;
        b=OEIHoKU+uUsWdsm8IK0xhAKS8tMT9fhPhn1vWbRo833WdKIZ48B6oLNPhFObRoJWJH
         bVQLvoP5bNvyjfmp7MeFb7XSrFlMTjriaSEnDeiIwlAB4PIWfFOINRy4v+udErlM+D2f
         dl7iO2Req9BYE1teK6sqw5YDi+ehapWDubfBWZPeixfDbIPifVGCUwtdz4nFtrtkyV1a
         R5Y9SZPAilRh6Db10Pw5j5ekU2MWZZJP9QnOFcdFIceH9cP92ejLVymNOjRczZUnQFrI
         P73J4kkQiQDFIKp7LSKDUauEahPGnvKBdvVVtoiXskkUOl8vnW4N5RMgfIqeqa73+hzC
         3xfw==
X-Gm-Message-State: AOJu0Yy3EDsUfRujkJNgf4WviKNp688RR0Y2FO6JkGB4Ixu3KhnIx+Lj
	2rezdYtxv4yqP7P/3KelLCPnasgN9YRUIuyG0Blp0xqsq3LZBIK/x8YEVeki+g==
X-Gm-Gg: AfdE7cmKptHQoVRzbMDKPs511mpGlVMh8Dbx4FsdkB5fDstRZGfRcM/VEG8ZC3yIDuo
	F6tQb795XfNWrJcljUE6BgrnTRxWR8yeSc+SPNPFqYs1zf9Ln2DfCUGmGedKi0xDaX8HvruhNbn
	sThhbqfPRJhtCg+I7fX53B9qvVIzLuRWPMifSrxLQDhKSOfErfjlp8llZ/TB2V/ih6g0yvW5hhc
	WUr2yEIdklxqjaPqdg6s/8oS+GYMKumoDnYWMp0+KCJlLbixOMKUvndI9ff/k1U7S4EtLHf/77P
	VUPfqZ3iMqzZ9p6ejDMFy4fd4Xk93k/4yfvxeSQ2MHBxnasuFcMgqVq7wOGX79Oe1l4yhnYBpL9
	EASabmu+SSKA8C8ifpxaHjVfF4TqHxbQ+ho9+53TkjTAv7d5SCQ+MWQa77mSh4PRUT+zNwBYuVu
	ejbQM8u6cqiVs=
X-Received: by 2002:a17:907:724d:b0:c06:3880:69fb with SMTP id a640c23a62f3a-c108c7fe70fmr88047266b.3.1782206658251;
        Tue, 23 Jun 2026 02:24:18 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-697d366f5c8sm1190158a12.31.2026.06.23.02.24.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Jun 2026 02:24:17 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	izumi.taku@jp.fujitsu.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	yuan1.liu@intel.com,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch 0/3] mm/mm_init: fix and cleanup mirrored_kernelcore
Date: Tue, 23 Jun 2026 09:23:48 +0000
Message-Id: <20260623092351.13031-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 13A3A80004
X-Rspam-User: 
X-Stat-Signature: 3wadpy8yo38ynsz5xpoazgf6ep1nisfb
X-HE-Tag: 1782206659-906194
X-HE-Meta: U2FsdGVkX1/VI345MlGMNl8KzfSkoJ1yZ+igkCZJEKNImS+Vr5hsiOywel/Uo42z4S/mcpdqisBsVogzdnoKkK64C02IPgXA2ms/37MQAkyjFdFmpf3AOpkTKIqTeupSIgoEaI4A+wXSAgJnVnNHQnyM+tsqlUW5UfvYB9ogpbTgnpFWM0Nupn+wbLmnU3HEiNi0ok79lHnWMM6kMUxGib4LPqiy8cibg19ZK6tQtLS+H4Jne8WsNRMI2cOwmvfCgo1Y3eWC9cMkekC0Mx9XW57/UYshK5QUvLSCMoynpgbm0eIvLI8S7lX2qlRXGG6J8LFYTJSuCzNwyicu+Z82Bv9yb6FG3UM/KdlIliRz1gu9WL7kfPhBvNPf3DyJlikZZkh1XijNL4CEe/dRCfN99lGaRxiGrtVdoG+/aJGFGy/6y8l3vC8J1cqyk00jIJzgzS+MX+v7IDgv4gtE4EIPnsXtt82B4U08zJScl3QXafujZfnp7oyK+/rdtRqtjlcyFNXYSSth73/N9PTdD7agIbh2Kh5Qfg46kD94MiJssaWcsKVU9jF/y6rqRYUHboE9B+2bewQXi1myj91fvD5qJLH1//hHTFg42ytwNLWmNymY3L5ntNUkVYKgziSu53Jd0GSkojeQ3jQki1qLMkyD1D+DUte3WiKJGvcDepEeYIh5p008fbi83obuQTepJf9TbjtmSDCSywVjnS7EC4d26DaOckLYxSKZWXef+C/lRJKvSebbHAcKvYaCvfoSi/mI217c4qyw5K4FUXP4kQomPWyXdrzM8fFF4IawQ07uT5rFdl1nz7gk/QPWDHZcVAepZ2nhmCDMwvhlRtXQHgkclPFWUYeFmxAcEP3dT7HnFxhDCLpqP66jdEeQ9lRnDhZSgxTQn4xYbzdc4zMEQYku2P7XkwR+Wunvf9thDrNNqTykV4ihYL5wwmsnHG+8fJWugH40PftZhUrTJmm+ptC
 IlW4rmCy
 eBKB3ZjaXNBe7m+AhkDT6VE69WepXO8WdXwJsg9Xv0NN3gdFTey6xq9NrAg0JcDk8Ozgs5i5lYX2jvDEF1ar6UNkiHu39A7qoc6ZZS2/WkVDvJsAr6b5Pt38qxEXq1VwhCtE5eCd8HHRuA7JAFdAyaZhk3MNALdUs8IYkkKYak9NEqKeaRc2jnD8M+ZE+3c0Tm333wEf1gYiLcNM6a+b8Suyss+KAyHUaigAT8aVedXoMJ2yQyxaIJtYEMrDLQpNwEvRF3FkPg6iqUB+8y3KALHKV9KJ3bul8s/TE362TLndoosYZQ8dz4kAWOPlPJgZ9Atfc0jY7jbdWcwHI8ymco1ZxP9jBVLFVQ7lGYb6saDgw32rB2i/mIQgrE9LjXiZOn+z6N92GBA6hf/fSN+iV7rNQEBJqzwn0hLmZ/rlZmSJM/6z3X6IiRr7Hes2GbWmKr2wfBMGE9o5djdXB+sQAThzjNI92ugZqQdVljHQ8TQYhP2rqkkcU3nruu4gnwSsdW8X4jT/OFQ4zcpLftJBtMG0qXHvw3mjs8zVt7JxYTPHm0J3YvT79PrSQCm0eLmL2jxvmztV+Ri4u5uyINVIAI9LHug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When reviewing patch set "mm/memory_hotplug: optimize zone contiguous check
when changing pfn range" [1], we notice mirrored_kernelcore introduced some
special case to handle.

While during the discussion and test, it shows current mirrored_kernelcore
implementation breaks other memmap_init() behavior:

  * disturbs defer_init()
  * some Movable zone range would be initialized twice

The reason is Zone Movable and Zone Normal overlaps and current logic doesn't
handle it well.

As Yuan shows in [2], physical overlapped zone seems not exist in practice. If
remove the possibility of overlapped zone, problem could be solved. And also
could benefit zone contiguous optimization, IIUC.

Patch [1]: remove the overlapped zone, which fix the above two problem
Patch [2]: remove overlap_memmap_init() as there is no overlapped zone, but
           record current double initialize problem for reference
Patch [3]: remove absent pages calculation for mirrored_kernelcore

[1]: https://lore.kernel.org/all/20260520093457.3719960-1-yuan1.liu@intel.com/T/#u
[2]: https://lore.kernel.org/all/20260520093457.3719960-1-yuan1.liu@intel.com/T/#mb0bd07ffd562a5b029f0f07751e580ca339c5b51

Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yuan Liu <yuan1.liu@intel.com>

Wei Yang (3):
  mm/mm_init: adjust overlapped zone for mirror memory too
  mm/mm_init: remove overlap_memmap_init() as no overlapped zone
  mm/mm_init: remove special handling absent pages for
    mirrored_kernelcore

 mm/mm_init.c | 58 ++--------------------------------------------------
 1 file changed, 2 insertions(+), 56 deletions(-)

---

This series is based on one proposed fix for node_spanned_pages:

https://lore.kernel.org/linux-mm/20260622022403.16375-1-richard.weiyang@gmail.com/

-- 
2.34.1


