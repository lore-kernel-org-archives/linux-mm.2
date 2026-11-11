Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5DD6606A331
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b4ruwrMY
Received: by kanga.kvack.org (Postfix)
	id C6C4D6B05B2; Wed, 11 Nov 2026 14:30:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CBC6B05B3; Wed, 11 Nov 2026 14:30:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D216B05B7; Wed, 11 Nov 2026 14:30:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 871BD6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:30:55 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0032A403EE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:30:54 +0000 (UTC)
X-FDA: 85423830828.29.05C8A38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EF86620006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:30:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b4ruwrMY;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794425453;
	b=waaB37D0fcbvMtDOjIYDPliV77udhzh2BbGaFFi0QYOoWiuRQusOxiMc46JGTMC/Q5HZim
	Q4LRrg1ipGNR6FviuThaKDr2NWLK07trNgxTbHejLc9myy2t1pYNivKxgMYA6FLsZ9Y1i2
	VWh5DO0pKepqYqTZqGOAtb4ZUsnhGdo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b4ruwrMY;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794425453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zo5UI9hZIeOxlpwJeSrtbBHTLqLuJCLcw0oCrYMAP/Q=;
	b=5S/Snmc48RvfpS4l29m+uutmTMCUFnRvg9LUjSEOB0R7IMKs9uFTxRFNv6vKNqHsPtbrIR
	0xFD58y0Jw+NCJJ1JW6K/y45qGtybfDEefIkw19opAabDVqpAY4AueDjVt2vrFTiJmE//Z
	f0dFdi3xiOM3hCRo5q6PwyLwMAjQxu4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D223458B1;
	Wed, 11 Nov 2026 19:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371F71F00A07;
	Wed, 11 Nov 2026 19:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794425452;
	bh=zo5UI9hZIeOxlpwJeSrtbBHTLqLuJCLcw0oCrYMAP/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b4ruwrMYtlS1zJIGm6IogVTN3GZoU1bw8A9H9t0VXLtSOdRH5GIKGoRYyljEKUw+/
	 SG+H/XmDobXyyRyJPIs1qMQBWHE9czbzjWdHeuIll36JCqC/pf+SjY0cWWMXiPz3S9
	 m3/4Cj+IjwE4RSAPlB0RhYwwKobjf8JV31kEu7plqziUlWBncfLxH5fv9qa5m0lyKh
	 7JRB+hChgEeLTC+3IrcyFlaRvO8FEE5CUXVpQNKLMRqWW2Pr4TUgAcc1hnDxhaS+jK
	 iFFU2uWPuV9t+kb7AMHgjGX/+YZkYYJm2DDUQq2+x2wpYrS5svzp07q7us1Uk8uMHd
	 JK/24r9x0KrEw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id AB9F41980047;
	Wed, 11 Nov 2026 14:30:40 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 11 Nov 2026 14:30:47 -0500
X-ME-Sender: <xms:YML0avxQD665O9t1dOvEy_Pxn46EG6tbREK5G8GJxGZfToS-P_E96A>
    <xme:YML0auLI4IXUOOkzv4D8YNfzHgc6iyiOeUALj4E_vez_S7kQDHH5FiZDzY5x1nkSQ
    U_t87QDYdoRXHCu0bbBh9aIEyfkBjQvf3hq-ZPSvgx2vZTEf5kmZhwF>
X-ME-Received: <xmr:YML0ak3ycEJWZ42qb5nc47unXvlIQ1E2mffU1-LR5bQMjjrYNlMGrPHwn4Y>
X-ME-Proxy-Cause: dmFkZTFg5mDn7G1jsxtJADJ5cuZf2Omafa/3hQOhBIIimTDafnO5A24NJOlsqczvUj1SEs
    klbDFZa+cCJm+hNR5NlTtmFKeH16BjQ/ZxuKgXmvAvddkkJHCf4bAKhqrKCRIBAvA6Tc2y
    MAgurUAn0Ed38s3Jo4oTLdfx0+Uk0ey3+EK9sO/AuYl+Tqpb2jiu/k6zbVx08ECTcsFIev
    gGlrZCAYO+PEDo7Hr4y8X6VfZYUHqPPZCdOzMI+4T1F8Ak4yqSjPQhNtOvIzum4W6w4HgL
    pgD6LrrmuoxneLsUL9/IOgiboNNN1/jsaLXgUv1tvI/NokEY0SdNO13wgeLnX0R8cwrCE3
    8ehWPlH6fkdPishwD569Pod8+ltBECxeUJy8OPUjEiYWjNy+7Hfyh6uTZFZ88Tvkj8SMA+
    42NlQI6vi5L4LH3ctQoSboEOjgfLEPqpV0Dr7UXLEwvJluDcASfBTGZgbVuKqS1IBGMJq+
    af4uNR8qUNzw2wjsxhfOtj6oE7jwa9EYfRiocIwsTNRCr239Hzkr7sKdRokFLmb2WJ4yIh
    ZSiYW2UFfMMhZcH5Oa7HuJdFq4YU9JG/xU3LrFPD516cliTB5DQu1cXYv3Mc/fBpDg9RhM
    1aC1d0yqB4lnWjEIGpBELNP2UNsUbFNyTqu9DLQbN7Hf/CeIBSHGezzY5VxQ
X-ME-Proxy: <xmx:YML0aiA7eKm0J3ecc2HVJFcpHzQFh93AOUTveT7lUEnWMcd8kZ7thg>
    <xmx:YML0agRUnpPsSFdFFRoziPzyCDbyt7q0m55EeuYcBcaYNQtB_Y6ZaA>
    <xmx:YML0alVKBOCzq20d-Ry4IgqgXV3vGWOwSpTvYTxBnGIvbXry41I-Kg>
    <xmx:YML0agEbAxt22YRy2B3-CKdMA1V4gsug3S8mlWpvJeL8XPG4TA2iNg>
    <xmx:YML0auoFfbVJP5a-7819JT5NJRy1483hK0PwMYuYYAAy6lHRcUvwL1hK>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 14:30:38 -0500 (EST)
Date: Wed, 11 Nov 2026 19:30:38 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH 04/13] mm/migrate_device: allocate THP deferred split
 heads
Message-ID: <avTB6h61nXfvCXUS@thinkstation>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-4-3d2454362e8d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-4-3d2454362e8d@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EF86620006
X-Stat-Signature: nbi5thpig1iz75idwqngfooh5tju96y6
X-Rspam-User: 
X-HE-Tag: 1794425452-183922
X-HE-Meta: U2FsdGVkX18saTxZEvD8zevyBFMt6S9Ii5tk1NlWKPQHNcRO/a3S325N0p1KvyFg8WJ1MDfdyrIc3SNmpc1q5PeE9iMgv8Q7YDVSzEPc2MihwwBDJQA9mKq4ajkXC3Q4djFVpKplkfgve2WL8qRSnVx9N6VDX2gto7K/7b+BE83xt6MlKeZAY0RsxR/+4wL36bgI5MJ/NwYmXvpFFeDcqWhaiMml+jZTI7f8JV7tWKbr1AUfv34A7bGrHgVBuVDI+a4qhak4uXZWVpnD/6eCFHfVHhBFavV0skbNqQ91AZIy8bJL/44FxSSDEHWRUJV7NYEPI5akP+vIaCPRbFyG8qLz4UoeZT1pBzIBwG19sp3Y2AuIkI+GhFqWdWoai4IQzKH2L5Mk0h2Fp1Em4vJftBdsLMPSAQHaVYL3AjNDCZLLZA+aVDGruy7/omJPHr5JSXiToRuAh5UBXRp/LowWdpTjPLbbnwpH/asWbLNoeFIlXoUGwotzZhYVqFu5xuDU1bDSB0cMN7N8Y3kujwHQ57rxTREHll2fXU6cEVXONizUFarMDthqvykOG9i3zyx2+aSBdnM5EjeBYqmiSeDcKfagTnzPbfbL4oMcXkdU8IUqMqzSuWEEGch9uIX3YTGTLp16lrYBJgcs4xmQX3EiMnGa7P4IzG9uQvf6D76ATbP2ScMZwY481uo2Use6L6ugezobJmMgJC5UY9FLeYYKVyU1FukqAU9sxSPzfAKVIEemlcaHsogyi42sjhuug/QOkGpq1zwz/QNt80sl2VfeasYbHV+v/K70qe+uHk93RMtLZ+R0heJLhjkRfSu3Bcq0lwyiRXDvqpYf4rNyWi/dKfjwgZO1aV/1d77ptBh/fNUQRV1UfN8yA6Ci5BqQK09VnGPjHw/cyhP0zwy5sfgGXh/spRkwj1CyTGPkD0NwD1m+yxxo3AP3Nt/4l2jObNDq7IfBoECTMzwGIZwvzC2
 3j7Ltco7
 yGSU5cKewbsZfY7M2dxnWOGmejcP19bpa8/Hjm2TpYqyAGyPWtNULKPoV40ZVYpbrq7DDOH5c4QfsqcFyMqi6SIUQDG14Zp8zCtvN+HP+rE5KW4/ykw8iSONiSJPIRjVXjAiUvgwnIEmQtnIgq1AGI0/Vdt3W7+L0Xkd24GcFipF/V6lD6jBH464LZJhckqNrVtOwLZjRIe6gtZoa5nCputS4PkzuQP090vJbyy0MZbhsY1CCjmImIW2SIrNV4JN1OeH0d4GkF3OD6KnzdkJwopy+2H0HhMMXwobIuJyMEBgrmu04Z/XR9cMcFnlGuPKguSK708JB8LRJM3Zd7d4O3ixdsXY7QdwD7OkWqdbSw2zJ45fLin8QNG62dG305Ur+ydmQEc2mOK9GnA2YyGjRYEA/WFS6SHCezS8u6aSkH0nQ8VXBsXs1Hw/FK4rO8NvG8rpnyGsssF5tlWvgdFdBUcu+lyE+l+WxYDfiQEZE28ZX2gA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 06:13:18PM +0000, Lorenzo Stoakes (ARM) wrote:
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

mm-new already has this: "mm/migrate_device: allocate deferred split
sublists for new huge folios", same Fixes: tag.

Hm?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

