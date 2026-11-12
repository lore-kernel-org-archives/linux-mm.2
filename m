Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0433606A8A1
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=GsaMyhH2
Received: by kanga.kvack.org (Postfix)
	id D330B6B00EF; Thu, 12 Nov 2026 12:07:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3DD6B05B2; Thu, 12 Nov 2026 12:07:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BABA96B05B3; Thu, 12 Nov 2026 12:07:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 960CD6B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:07:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2556714068E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:07:25 +0000 (UTC)
X-FDA: 85427098050.03.3A9BF8D
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 325B8180006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:07:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GsaMyhH2;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794503243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhfyBc//VTsBjqGcAjilygXZyjWzwwcnsTJakX/xnqg=;
	b=oH9VkKD6xsEpjcj/j++TeI8UZ1ju8eAnxtMxCyBfAEe0oYZWU2pHz5xi/m5BWoYq3nnBPQ
	VsTCoETHuAPErDg+H7wECg1Ac1PCsF6RWWuOdtwJnHakGsvXb1/dlpmPYxdxvX1WDFtcTY
	LXgZc+0Fu1EjN0dSG86K6kuMSCzbdl4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GsaMyhH2;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794503243;
	b=2KdfMN9NFWZIN40MfPd6Kucu4smGvucr/VTonJxiUJ7lKStEla4wSM+vKRaWDTaXzp+WD5
	7WUiQUzCFjhM5N14drQqGX3EDZF1IEOJ316dnNOF44lXms387TRqub0IJC4PHopwDaTwCp
	zCGnycDZUSqERCIuaAsx5PHpyVU4v94=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5363c8de563so46343951cf.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794503242; x=1795108042; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KhfyBc//VTsBjqGcAjilygXZyjWzwwcnsTJakX/xnqg=;
        b=GsaMyhH23v4/o+4+zicTfqrBeB442Yxva9w18Sd6Oopn5kgWenLRhakQT7jU4WEDKH
         tILFC7CheKBbOrlH9dOJ59BUoV6MxKJdA6LljXHHaZCtXgRqVo3TEoN44KuSasKAjXBt
         NDFUyyiFcIXGiDNFaTusvW6UPLa2YPPSOKQHuHv+0NpmZbY5Q/89OL3laaa26SmL2zdE
         5HpV2IJIr4UJ5FLr3TfzoyJGU12yS9l5+F8ZqIAr/+/3pCKhVYXOoFXzP6hD15Urck1G
         e9+LF9DbtspzbaQDEWmqfR+RNsehZoLeSKWoVEtKSto1F+8O9cxbSih2FC8bs7d08HBz
         SYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794503242; x=1795108042;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KhfyBc//VTsBjqGcAjilygXZyjWzwwcnsTJakX/xnqg=;
        b=R/55znX6fIU4uLveM6zUE1XHH5QNWNb5elvaCdFiG/MbLLJ95ZbqJ6tsmrzGo3QGsS
         uWBfK/buoq7DsV0taCeTZadKsumYVOyouDZGVBI3lNSReU1Gr+gF3BkZRRN4CYO0zpTM
         a0bpWrWCXxj20eq0m6laNffC0g/tJYL7ZsyRVnDcA/HgXEBUMvZumjMZrkQOigXL68dh
         OsUqFI6K1TYQafBnrBhqf79q6PQea7oFJ78Vab4sLG99WeT2AabO/ZI1PaV4TB581z78
         qzWtTfdkKcSbfeV1PuLfV/wZqZMlF0I/TS/s7+tquBVwc55JBJ0VxSciVzgJVBEGlaQl
         LTbg==
X-Forwarded-Encrypted: i=1; AL+hErFnr3o7Q9nZocE9QX/9h2p6dzKKm1Zv8zkUDCvUd3L4ax2X3wRx4mITUXc2VzbAnE149n4jk0YGxg==@kvack.org
X-Gm-Message-State: APuU4Z+1SM59f/jz9xaC7KnVgS3UtchIKPQA4PEN3jy9hwZuaR4K0aKA
	JBVu9w1P4WL6lo40aiuYk+zsFAQODxJUtV+U1Cyk6UyDdJ3sbZmba37RMLD55K4yVrg=
X-Gm-Gg: AYBFou3ND/0A+nxxOd7QTODMOErH7VOxR0HHyT3M/vZXvQcqZpNk6IZ5JxuRdL85EIi
	5cDstMuOOt/iEL2IcctEc85ATwacXXDjiPQ+mFlUDEcUey00LGt70Kvhi41scUDBkrm2PFN+FOL
	ky32EsdqRRegQkTDzKAB0XWpbtR92HLtFni0DRr+XqiHb6EBSw4ilGveb8LRfFPY5Y1uSZPKuBP
	eslxoFRn5yJBK40WZT/sS4jUyuLsjuTeEVGxvd7SM5ttE9TOnlQsXs8AOsvIIJs4M1nY/WQlMCJ
	6jfZWTeb5sBnbhhfWb+gXb+fh4LB3iRGRRDeVcWqsx4Ytf0hO8RbXnk9inKGM/PVsbzOrurmY2/
	wDkIHwM06lxAKhW/hzPIu8Fta8GEfWn3J1IIt0ns48dgn7O8+ekRpu1zVqc24f2hFbCsyF2M582
	bgBJoXFYLL/n58GBpJyCk0WfRjWBLd8YNsdHjJQGheyGjJDMH6/e0x/eFuGPjf6qXNfT+clYUfC
	uwqfKJgtjF8PmEAafXZSP8pDeiz73B1kMPOGKrBhH1ipB7DpZKq2uKym0PKOQVW3K3pgRJRta25
	QNbppgJojq3c226T/EGQrerBTs1IWnVS2MkTEVqNQ6KW5Dogkog5uZPpgF1T9GlVRxPwJKj33zK
	jAyYcigM=
X-Received: by 2002:a05:622a:684a:10b0:535:70b4:3f7b with SMTP id d75a77b69052e-55aaaefd128mr5760821cf.65.1794503242102;
        Thu, 12 Nov 2026 09:07:22 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550bd33340sm78278751cf.21.2026.11.12.09.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 09:07:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 04/13] mm/migrate_device: allocate THP deferred split
 heads
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
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-4-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-4-3d2454362e8d@kernel.org>
Date: Thu, 12 Nov 2026 12:07:19 -0500
Message-Id: <179450323943.482102.10332650234844298705.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 325B8180006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gmpnpd3nnpthtz93exy54sys9ouqbrer
X-HE-Tag: 1794503242-699554
X-HE-Meta: U2FsdGVkX1/NlXu+gNQrRsiXc8VvU/5WZd0Kx7yfme3Td+gxt9t5nHE1S8W16pePdRw2SVHJovBlbesMGcDUc9Kwu/HyA4/ac0vJywzTY3LZ1IL4AvwYY9wgPuUIZpydAQSuRVnDLr5OQL5OiPA1nerCDokX70525tjEK1omW5fZfYFAhXS9azWxGQTlp7dyAh6DfjMqU5TeFMaxhNYCauw+Fo/sxqVn5C3hIbQcmjytgiExMvlC91hGVLUlh6hMoxmnVi1RkqUss2lOydzVvNNRwcLHJMttLloF2WaB/IcSudKIrN0rr0bvfRV3T7EZzIsWVWVZrJ4ATwS7wT8nUiipdSBawVI6s32HQA10jRmiahZS3nVHlVupl+XIx6P4MEZCozWzm8YOxlcQv8kbaYT0JTS4m+SUewuxMp7jQ0p/LLfKTgf90xYY1Vkjz5zxvNepzrabY7B2+e43vcDjDtUCF7Kzxc+YlwPBIxmxmrJy8LFzPW07Pgi2lcKCOgWk2jZh7SqTvpoIkonK3M/r9Wsdj9rlP3KdBgM/id2WI64X1vQ7ftlIH4HrwwK4CamWIg+m8/7N82zppzBo8njBKU4gZzV38ltae4En4bDNdFuIGLjpNG1rckjEXFM3Dt3KKp8QTk6d1E0hYvNS4HcjdA25W8i/hJCCV/U3DdbIW7DRDAqmcpq4BvSCClCtu5I2QTTIv2bVMViSkBfruJtT0AizFX26My+SZ9oFY9RC5colLFG3xohAgmHuvtaHdM5AvTqsWv3HTpmpYfLbe982JztUbNMaOqmK+HchSPOp5BoA0JLHhAcDG1ZwJS2OxsOCe1r0Shi2gSH/d6uGphXg+fWm6etlHeKrihz001Xh8Ok57ShBo0KwWQkj9ab4nn+VtV8COfJySDsItZczLprlbP42koad7hLueA5jsruBrGuVZfhPfIVMgkIA5HBVYBzTDWhHty8KYigNMWcT+qS
 ZE8EeucO
 sJrUxqXb7jG7X9H0g5aaXs+//6avQ4ZcQtT7qR2ADw0mPYu+ghnQU5VOjDBDyxH5EkUZR6oBaBnFfz3gnvokD614aC3Wx1GjnWnphuWuCvGqgfL4mbU9XOP6RhdzzksMeL1rJ2lYu3hhnwpVRS1h0bv3u/JpsayM8rfCgLInh0CQTtlu9KRmKQuyZZCTKvKk8+F+FJxEVLITbSci7kjRGlTAJ+B4qktcg7hvuu7sTdC+zMXbvRQ4LuJZxoCijUV4k82vUYjg/4gfwsRzakfUM57vqcWPo4ygJo6YTXn359IDp4DbW4Q2n65utBoauntJ7HxpGOMknXfn8EcKW+npmPSQnbpruSXqjvmWJr3ZR7TqsWGRJLzzWK+YZpLeVIWTHCuXD0yHC/+o/miAEgA3YbtGTQ8IWZxNEYOnAswg5+ONp1uMe613CwGzYZGlissMetHFwmfAU7uevmIez972HMNDgCqnRuCvrenrcHbPdRQBoN8XNM3mDUd7otP9INdft5RC+BXXYdJ/7s+c=
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
> A THP that device migration maps into an empty PMD can end up on the wrong
> deferred split list when it is later queued for a deferred split.
> 
> This occurs if the memcg has no heads yet (resulting in a warning if
> CONFIG_DEBUG_VM is set), where deferred_split_folio() will then queue the
> folio on the parent's list.
> 
> Once a later THP fault in the same memcg allocates the heads,
> __folio_unqueue_deferred_split() and the split path resolve folio_memcg()
> to the memcg's own, now existing, list and take its lock.  They then
> list_del_init() a folio that is linked on the parent's list, racing with
> anything holding the parent's lock, and both lists' nr_items counts go
> wrong.
> 
> Resolve the issue by calling folio_memcg_alloc_deferred() after the charge
> in migrate_vma_insert_huge_pmd_page() and falling back like a failed charge
> if that fails, as __do_huge_pmd_anonymous_page() does.
> 
> This was originally discovered by code inspection.
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ ljs: tweak commit message, remove unnecessary comment ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Was able to reproduce the warn this spits under CONFIG_DEBUG_VM
and see it relieved with the patch.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


