Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BDDD606A89D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=KX+6iwOv
Received: by kanga.kvack.org (Postfix)
	id ACDD56B05B4; Thu, 12 Nov 2026 12:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F066B05B5; Thu, 12 Nov 2026 12:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D1F6B05B6; Thu, 12 Nov 2026 12:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F82A6B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:56:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B849405AF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:56:29 +0000 (UTC)
X-FDA: 85427221698.21.10C0AC7
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 198DF40006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:56:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KX+6iwOv;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794506187;
	b=lYDpTMyg+EA/49xJhnKM291QueYzPnQ/9lhz7vOC63O/dQJLLM5bPAORWbWD5GfiVPYpT7
	aJPzg+ssIu8czyInwXxR7gm1aCiitptWxkCCfn4us31uSmi+jVtKH2ytj+ZE4nz1kCTcRv
	iCWTTI7n4XUMBCBv5F39Q/rMkuCL+ZE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794506187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oX1FfxSvKmY7PUz36O/ZliPw6+lwphICskypKstU3eM=;
	b=qkZZDXiHhIB/fVQRlE9us7rv9HNloVsqOU3XZMUXK2+6Q4dYfbKyfnCfW+UhNXLjfB/+nw
	JpNtmgD3oMlpHqTxbb6IgNARIthRb9IS2v1Miughyb/xHsWoyODFUiYAyi1TwKdQsn+EHF
	Prhf6DQJL1+CFABxywqA5GJ3RwDIg3I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KX+6iwOv;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-91eda36322fso297356d6.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794506186; x=1795110986; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oX1FfxSvKmY7PUz36O/ZliPw6+lwphICskypKstU3eM=;
        b=KX+6iwOv1dXO3gN5dOrjB8kfawWRUyuS8Aqv00T9U2voPQjv69NGFUQoNeBsnNQvMN
         TYMzBcHNunujI0Pgbuy/xXqCkL2l3iJ9Uwf7Y0ktGzEW8vnQnOrmJm5gMPHrL0e8+KF2
         kd6E8Ptt3/lfPFpLUf2BYNgBHd5gDuFTECoeu77VaQ76enyW1OyO+B8kpKriBagW6nwB
         MaC+t4EZnyePzOCPqY3occJIO78ZL1VCsYbraJvdVJS8Xyft7cf2Kl0PDmdtPsYqIgLa
         lpEnDzF/5PlFSvSunHA23ppBOxmJXn3jhixF8KCZbTGa7tyQ87uBMhWfOrk9f3esJcuD
         rJFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794506186; x=1795110986;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oX1FfxSvKmY7PUz36O/ZliPw6+lwphICskypKstU3eM=;
        b=yMTzzvHofQEX4WwpMHRfGh4naNz7HalaD7a2MkJLksW9STvwVHGUvvJfbJ8tob8qoj
         o4H/U9mF5hq6bCKr8JgUixBFg/PobX8WuaIlUI/qZeok+VVu3mxoJwkJ+yRAD5NA3s9j
         sL+UwR9HsGtL8InQyHpesf8BYJQvNzEutSt605so+d4x6uhT+XRwMduvhg1lI+m7PCT7
         iY6vyiisoVxy+akMfPal7DQTy4MESBQwqtDCbqRmIttKr34MT/+ZyB45Ejvd1oxDrj4z
         ReAwCJE8nSa3RWlRLeVrWvNSWtZCU/h+K7Be26BA/bYAAJhcq/ALNN9ZtdfewgFDOnHM
         6Reg==
X-Forwarded-Encrypted: i=1; AL+hErENALqlSlSLoKN8XQdyxjaocut1uTckF/ifGmZMRMVqW0AHT+wtoKy9Ywk6Y3OJij21WNJxHDsMdQ==@kvack.org
X-Gm-Message-State: APuU4Z8Jl8HAr9E/s/u83hP5tBCRoy2aRBVhzwSEdbFE89cLGis0nu1X
	LiW1ZHywIbqiDJMRn1AcAjqwSpbfKPwG4eJo6aF9sU33EcVqsKqq/tTJqoee9zZONo4=
X-Gm-Gg: AYBFou0bByf3z3JYpr6XEvWzKjZNkLyJqyh0P61rwrwbe0SFELteTc4ly10/KMhRs77
	9B3dgwmViiyp+A3NoYlBfy4h9j8KczAKvQCZXHGFxhantQSI2nhYXyff97EE081tlTtxA+5f+4F
	dKiGNM6E8te8WdwN75WVy4bgxeJr7IY6EPVJvPElwvJEkBlnNxwowsI2eJ/Hj571IsqQ+5X1Gy7
	K8N75a+nyPxPUocOb307WuutjaZ/DdVJ+XLCqbpNtefHBqJOLqqLY0MVs3LH6+OcJZh8itwpcR9
	UO9wXhhpGGE7DQhRlD5Gv5749P2IRVTmCffSj/cwu1wtMTv08zHYc/VWh8ajJWgwJCCXSDSpdnN
	ptE+g2v47TWQWWjdH6S/bhrzYWNOqwVn9v0h9aE4dwGZVEWM521BJ/jGs6NfPDocVQP75V7VU18
	Eb5Nk85Mn5F3J0dDZhCtHPhUKUYl3zouDxlt1EAdKgDaRWYBEs43LOS6AKVpTyO2sGd7bzYmeqa
	oQ2Id0aJuP7DoRzZbYgPibEaay4Vx7XiLlX/z1X0QkSBwcNYRyjR8AsfVpKUljqkHQEUyzpsuYL
	00cnA1ayzkSo+0GDMEk/EPN/CU6uA24JbJzE1UaO4U2VRTS38xQfRPEJw2G6Lz7Crxu6fGOYpYO
	bF+lBZEA=
X-Received: by 2002:a05:6214:858d:20b0:91e:9b17:2be9 with SMTP id 6a1803df08f44-91f24203591mr468026d6.36.1794506186056;
        Thu, 12 Nov 2026 09:56:26 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d70489sm1212506d6.21.2026.11.12.09.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 09:56:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 06/13] mm/migrate_device: don't let go of the fault
 page
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-6-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-6-3d2454362e8d@kernel.org>
Date: Thu, 12 Nov 2026 12:56:24 -0500
Message-Id: <179450618409.482102.8556965317179106876.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 198DF40006
X-Rspamd-Server: rspam12
X-Stat-Signature: cxz74jr9p8jisjyik4sqt4atcomd7esd
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794506186-340969
X-HE-Meta: U2FsdGVkX1+iSKTZ3g7YJmSYP06B2rsf0GSNOzm2Tf6EjpEexTF+kbRNwHqpV0eovOxC4t0NaXs0psADJ0OnBYgI293Xu1hSfc62y9v89dWeXOQpKFBRaMGpC9vx8AGk/vkLDR1bBXMiW6QZ46tCsPTc/yBHTclBPRdn5/fhWVE2HukDnJqQvgVzxZM2x5nzj0mP0Vv9WNBa5pNNOCuq/BasUm0hUbyPWMMgpKARdQ2i6/f/jckObvdw+dgN2HPSaaD9alOFx3zS6jYCIfGUhsEDHZY8oqshgtrQalZLMjHZxiT/HCZiQGtdh7pJAZpK1V5vA1sbZ67rGt5B50L6TMCTBXj/HMZq9fi2+0gEqPdQND0gE6BiZHrX7t4l4G7mseHlP9wiUCmjGMxthmyqJoEcadyMUBb5nS3sU17msEhvtNww/S2dFIO4ZLG/wK6oVIxTasOaGFdIkPdszeULo3fbKKzYKkJxL1qM63WZ6X9FVRJPhpBr4FPTHyrhzy7lvQxiqr4dkgvZB2kPll3k+gnw6JwoXY3VjXFBHnRrpkvXkyuE/xp7Nr9jeVFqALKm6wFltoInGc70FW3/F/tBmX5fMYpQBrI2dJDw2J27GsnATo2nhJHSPmsLRMeF9pfyL3SVVvqubcEkrOg9/8fWPEa8N/gT3pJrhD5606hUjbpyfWRs8h0qrm1xasxrU3Yxmiub8wrQRvqCygETAVHmdTWfPQ2AWADHdQAFcAxuLz4kH9Oy9ZacC6NJPTE+f2D6ywIaee+QYobJ4Yd0FC+8qmhZeNzpJheVv+6cWhDjnoGZhbIg0uLaPCB6Ha8vmtLPMWAiwK7q4PFJ5oyoG6n8quCn10v6EgP5nQKCBTxNAWkY2r92ZaJdOWXmsUJ56g7RAt6hV5dkwxIrwLM2h5e1Lh3+YZBBxpteZxqozol7v/prfenVzLN4SPC1UVhCYUH6p5/8HO+4LiUR59++SNN
 2/GO71RC
 NXW3f6RTvInffCAnOOqJFUy5MsEirionPZwXev8Uy0Ji42m+5N6iT9FMpsMDEVgI7AGlJqKG1v1rpJImzeWEm0G2kLsf90NSTgc4myOcls8jzwHZlcmXDJNGoFDTCHTTI/tHeOTj5FypU8sWlYURYSFne4P6EzK+fvKKfVxTWIkpd4r33rc5bVxplht2Ae4WP/IuVGM0ZKvLBLODlYYbBXYkIAC6S1HcMYhTHOGPUG3QzzlN5iQFhiYIUar1zX7+66CJqu1AiSmyAevFEh8+4YczjXB/hkP3qsSW24URA5wBU+VDYKVMmknn56xIAbkLZvl6WZ/e2OkATLbcm7zPoPg4q+CRIqqDXibSv4wgNmZdczX8zyISK8CXe1v/PGCGjlOmHaDi4iCsS4tPKkCxz1EapnlOdG+A4Eo8b/5/OBJWlWZZZqF9TVi3NHwpY9RU+GReUoOrwmrSYMzOsdf+b+xt5akzHuwJQpd1RDQTmYoB+CMB6lgoqjxoC8Yc1TeqVgNLhMY+EX4ki4WKjmNKFPLDmmEZqjuwRQi4tcDlsFTVxlYhDGjaFOI1Qow1ma9G7YSN/fNhRYhL3+96J36mM6KwQMGbuePtV+59xR3Om539pHNNQ7u8jmzhAHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> When migrate_vma_split_folio() has split the folio of the fault page,
> the lock and the reference which the fault handler has taken are at the
> former head page.
> 
> It then moves them to the folio which now holds the fault page, by
> taking a reference on and locking that folio, then unlocking and putting
> the former head.
> 
> split_folio() has unlocked the new folio and has dropped its own
> reference on it, so until folio_get() nothing but the page table entry
> holds it.
> 
> Only the mmap lock is held for read, which does not prevent another thread
> from zapping the entry with MADV_DONTNEED.
> 
> If this happens the folio is freed which results in folio_get() taking a
> reference on a free device page, which the driver can hand out again at any
> time.
> 
> In addition, folio_lock() can sleep here with the lock of the head page
> held.
> 
> Utilise split_huge_page() which will leave the lock and reference at the
> fault page correctly.
> 
> Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ ljs: tweaked commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

I was able to reproduce/observe the ownership gap trivially.

With some effort i was able to generate folio_get()'s zero-ref BUG()

Can't say I understand the change well enough to give an R-by, but
the patch does resolve the issue.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


