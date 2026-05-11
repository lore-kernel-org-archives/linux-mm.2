Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3E7CD37B7
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 05:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEDC76B008C; Mon, 11 May 2026 01:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5AF6B0092; Mon, 11 May 2026 01:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB376B0093; Mon, 11 May 2026 01:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF6B46B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 01:42:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 574E61203AA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:42:04 +0000 (UTC)
X-FDA: 84754042968.12.CCD3328
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7BCA5140005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:42:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jAmw7zFt;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778478122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CalS/wYJQnB+1dDpokYD7iqpL51mWJHpxBNnm/DufMQ=;
	b=iZV+4XYB76onNyaCLcJVF3/yz7XEOprSVWyrDOQ+wB1JQ0PXOf2VE1A6iK3xsXPGt78WOj
	A0CVkS65cuaSj/8EgmJMsK8M3JU5NbZoAMeeF7W3ZfWGcqjzfX5R4OD+f1ncDk9JhnoTVM
	CXKBnr3PvbMJEFrf3IR30/FKRtw+DBM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778478122; a=rsa-sha256;
	cv=none;
	b=qoG78XFRBQcIEj/aeKoGHElewKYF0Vz+IIZHV9xRSNzeIYDUp+Kx2+ArbQyp1SWgqdLyHf
	JbE21z2CSrPbqPSdIzcpyK0RmT+6iHD3OfV+VpiPWNDvOxoqkHBvFy3uaTBOYSsN2OQ7Ny
	94BS3XoHQwE8CRPTBfCnEiWVu82okmU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jAmw7zFt;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F90A42AEB;
	Mon, 11 May 2026 05:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3737EC2BCB0;
	Mon, 11 May 2026 05:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778478121;
	bh=HNbv00CUdgQcLDl4kDngpInkYALplgFzgLl/PDHxdkQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jAmw7zFtpStO+89/12rLx//QpeWp/u18M7xnLGfAtF+YOSBgUADXpLrRe4HPXTBPl
	 V8DEKFfpjpEr4HOX3HTku9b8V2KU0ZYW1E/2hMlZUzdWiJS5fECq0j46aT3UANQ6e/
	 j6uLSUG+EG+rEwab5Hab7h0s3CiOiUFZqN1M/uvaggppnD91ggNDQP6xgTMcQX5Nd/
	 4IoZeAOrIevPeTAgCsNcl8M9CQn3+94DitpJ7Pqlz75IAQgntiBK8ntoJ7xZKqZe5e
	 uNqvKl8TPkEiH44HR59+/9N5CoMamNXQLNk2SFLclqnGVWnfxXcesPDIeeRkT6eAAB
	 d34IVWq3wgKGQ==
Message-ID: <14b2923f-ff61-44ab-a82d-deffdc4b48be@kernel.org>
Date: Mon, 11 May 2026 07:41:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/khugepaged: fix inconsistent MMF_VM_HUGEPAGE flag
 due to allocation failure order
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Xin Hao <xhao@linux.alibaba.com>
Cc: Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Andrew Morton <akpm@linux-foudation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260511025408.54035-1-ye.liu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260511025408.54035-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7BCA5140005
X-Rspam-User: 
X-Stat-Signature: 4czgfimzjhy8wjhufj1yem3ncxosgy8e
X-HE-Tag: 1778478122-12291
X-HE-Meta: U2FsdGVkX18OupY5t4Q5o5+vhVMHJbZpJlGh0ultW5RPpB7/DAoHt7FKE37UJm0KTOooctMlCqp3qsv2ylXEvpoW+WOyfYPjotP2XtcPaaaX/bQwgo8F4fwRLKRN9xagGxHCjGBA0SSEuO/1/qEcCiVeMfEsF0jz66SpLSJB/aKLhrTR6+i2krrJ68U95W9YOBp9/9VWepSllLmfcapER/uUGj3NJjivOiB3l53P0vi2MSnpzCmN/5GuoMW3QsaJanMDKUKvomrnG8iP+ys4ZxoFyA6Q3O4IOfpPU56n2bzvCSw5pLJwzx7Q+TRNEr4wHgn+LVrVrJqLdG4Led5aIX4iq1Q3tecf0avWZ3L0RsFr/Pp1qDl60b+FcVFZhncD4EkTdNv2a9o+X8yQeNujgasWeYPH3foFhGBiEIDHP+MqP4/ublvy1ekaoKg1VQGt2W8UsDptXyinFefN/hkh1bFKg9Tz+Caxk5TW9jHnnJ8NDiQaaOjECyQPKx7WvDQy1Bxc48ePU+zYWH7SPOJYah7Y6Tn2KYtVV//ym4SaVdq91XXh/lMnqtqQ++tUG8rbSRfyhScOfVH39oRb3BBW5GnwesNc1EzJlCWuI+CQXLJfsfR9ampy8uIkaHNW5/PX5ulA5/S6zrj9DASPKSEEjB6ygA2V8yqTsFG9UZNtO614kgj2ZQ7lCjesvRuVQ7YvrpaiXra5y8V20Zt+6Aq7s9FZI6pzGHM6rtUaA/rz9sgm7D+E9pn90iZNwA/4T0vYmpTRNDE8BEqFZdK0bWbRKZaaFiC67ba0trgrSe3C9N+XSYvVaaD1LYTMML0b2QfAd02hrMgzz1+4Zgru6vLESx4LQHZ0vAu+xaLh/Kin5DR+QTa/hsHEr2EyWQ1qLpzUazMCPDvENCuZs9zbLSv4IwY6fGbPk26UsAYkMhpFjeglbny0SbWHrbSAG7uMRx51+7GIAYdhaD6XiQShjrk
 UzWOb7Ki
 6nRe+0R/CYvFTTmrXUGZXCJN3vAj1pXuDIcbjQzUsN9AA38FyEWutlJWelCeLrGnM2Z1i4R1eDGPFun7qJ/DSIaOlyw2SxiAtRPIoKNdnJhMBGF5jwWgGp9WGev5OS8twzA3AwZ5kBS5N01hY/Yu3+M8iuROSeMQ61t3CbWV0g0tU4NTxeEbov1PgvixCAFv7Q3KQLAiKxpdqMWJY4HRoPzcJg0uQdgJ909CxKtAj4angSg7DAfN7uq0Zf2nsnvK6wRhq3Wx3fP4HCmUHUZg/k4+FxEW0ZqHSNKhxuT7GSRDUfC089U5aPz7WLBcYppTZROX35Yd7yUsImb/UyiIhjIDRvKUsb5m5Xwk8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 04:54, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
> corresponding mm_slot.  If mm_slot_alloc() fails, the function
> returns with the flag set but without inserting the mm into the
> khugepaged tracking structures, leaving the mm in an inconsistent
> state where future registration attempts are skipped.
> 
> Fix this by reordering: allocate the mm_slot first, then check and
> set the flag.  If the flag is already set, free the allocated slot
> and return.  This ensures the flag is only set when the mm is
> successfully registered in the khugepaged tracking structures.
> 
> Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for "struct mm_slot"")
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

