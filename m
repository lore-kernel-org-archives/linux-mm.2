Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 585AB106286D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF346B0005; Wed, 11 Mar 2026 07:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9BA6B0089; Wed, 11 Mar 2026 07:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B836B008A; Wed, 11 Mar 2026 07:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E80496B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:44:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 477DB55202
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:44:29 +0000 (UTC)
X-FDA: 84533599458.04.EDC1636
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63312C0003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:44:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oX0/qMxh";
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773229467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J34oKXAGHt0kDLlGsV2li619UZ6TwOGEO+ecUWnzr6Y=;
	b=ZM8CkPClPcVla4mdYrntNo3wh8BIZC9gNHKmTh22jlxbTOzMy3jEKD/YPoDaPj3xM6YwTQ
	kRpKenHxfNG1TDTpz2OJ8AjZdTnavRaqdBE8uzVpPA4+2ODpTL8nZMe0DNEI+RABHd2dvZ
	nM4WSp1nK1v756m9iRHhfC6DPgoZTRQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oX0/qMxh";
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773229467; a=rsa-sha256;
	cv=none;
	b=f1sz5lL+jGDK04Sx5Ufw/RrDTRak81ZWk4hXOha6S2Uu3cYZt7p0aMXcYpNXJrQ0BmAaPJ
	3T0rfZ+DvTLOYlY35RBffFPNnTLFU2XKOFPLUeYrtRX8y1adJvcDtCNSbVmPrlOPMa18EQ
	Ga4M2hswZ2ey1rYR6ZAswGMv8wxj1IY=
Message-ID: <b922eda0-bf0a-4e23-90e9-97b3a5e57818@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773229464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J34oKXAGHt0kDLlGsV2li619UZ6TwOGEO+ecUWnzr6Y=;
	b=oX0/qMxhM9vQxBBOeW/tWwiiKCL3PRyhhmuNM3+BJZ6d/Z2lZcxB5ZUgsVPYagoKvtkdPw
	affC25J/2cLwQo/X2IADmBZKJbveeJeBV435NDuD22Tpct1TKsReFFlQ8fEfO4U9uqrVdk
	Rp7huVeylRmN8mPOteVd5PAo5D85fRA=
Date: Wed, 11 Mar 2026 19:44:08 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>
Cc: linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
 Dev Jain <dev.jain@arm.com>, usamaarif642@gmail.com,
 Baolin Wang <baolin.wang@linux.alibaba.com>, kas@kernel.org,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
 kernel-team@meta.com, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Ryan Roberts <ryan.roberts@arm.com>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
 <20260311-thp_logs-v6-2-421e30d881e0@debian.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260311-thp_logs-v6-2-421e30d881e0@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 63312C0003
X-Stat-Signature: xub6u16cn6sa448ewb1tkh3q9p3mtri8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773229467-16507
X-HE-Meta: U2FsdGVkX19Sv0ltwMo5HRy9OW8+jfFn/pmahJKzm/UONQ3/1i1HQJVSusdzdvIuot8GsEXAJuKMT2tOy1traLPx3A05+wmNhdaNqtqjeUkpCWbAH908FaT41LM13FrLWKZKlOhtti3eX7WqFTKY3AhE/CUaLCGTLQVwepsC0Yg4uOwHtdxihONM8NmA8Q3BxsEY8jNtOx8qvm69LL+oxxacQDoXmSlIveDiLDOdqpYlZvUgqaWHVAHZxQQ477XC7lzVwCOnxbcmz4xxtkREFicV5GN+MEPagYopJX3Zh60gcOU260mEehmApsEKHNvq+aLbgDrE++eg64bOY7VlI/kF74/TfsOtcsWPceyr+B7MC4BzOxtdOItAOY6mOIG0OavbrLwVUjDCQcqzmROsc7vo8QKGDpbtz5/vf/zDRAfSWdmi30+KdaYPSPE/Wf7LLErSzTe/R4xBWFp3grg/Z0EqqfxpgukEA7bjk/OqZJwGacWqaigYU+65MWZK0+5XTHmD8DROA/RdNJkL68xXxYHRUjvMfBpJYuuN2GmaD6yqrnCY06XnXEz/vsI5cPXOdBM+ySyb47BXm1mJ18n3KuBjBNRfycpF8JaUg2/+1aEylV5EQj15hoNwuEX/sGWyLRi4r+7FlOltoX8SjOaW0ZsOaXGsp6DbiC4FjOYK0yOdCPzMXuGSneaYOvYLe4SFPnR/p6Z5EhB/HKHraKUIM07Ih8cUQvcla4i6/vp9JEdJKkr6fUM0tXjVQrJ7bkBL0iE06A0M3DWmMLMFzwhdaUV3yPv11CQHBump/L8mp1cMghbLGxlGK+Y1Myn76/x5yp6yXEsgeBeb2tz5+qdAlUPJUCx0OhVz21epRsexSsFTHfc6r8HKcVSG+Y0QXHFdcmX5YRbAoGmZUXwEoHWb+3DlkYEyJAF4pCpTkSBgKVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/11 18:17, Breno Leitao wrote:
> Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
> anon_enabled_store() into a new change_anon_orders() helper that
> loops over an orders[] array, setting the bit for the selected mode
> and clearing the others.
> 
> Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
> for the per-order anon THP setting.
> 
> Use sysfs_match_string() with the anon_enabled_mode_strings[] table
> to replace the if/else chain of sysfs_streq() calls.
> 
> The helper uses test_and_set_bit()/test_and_clear_bit() to track
> whether the state actually changed, so start_stop_khugepaged() is
> only called when needed. When the mode is unchanged,
> set_recommended_min_free_kbytes() is called directly to preserve
> the watermark recalculation behavior of the original code.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

Thanks!

Tested-by: Lance Yang <lance.yang@linux.dev>

