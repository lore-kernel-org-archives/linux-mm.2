Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6D9DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20476B0095; Wed,  8 Jul 2026 03:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4AD6B0098; Wed,  8 Jul 2026 03:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4196B009B; Wed,  8 Jul 2026 03:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF276B0095
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:47:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A12E1C83C6
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:47:03 +0000 (UTC)
X-FDA: 84964828326.26.DAD9F99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3269940006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:47:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tq0udb3O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783496821;
	b=s90OdCleP06HMCDnKwtRwCIlmOM9H80m7Dk7o3cJWQPl90SL9f3t5WTYOusafOJIbtP6V6
	ICT5PAnvHLhalUByz4gH/GALHkiqDwW3I5jcO0yBMqlmGiq7/7owY7F8rmVQrnMulXyszi
	AC6K1W7HGhuLiLKkjh5ZUuJbuxcnjhw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tq0udb3O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783496821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnyQ+PHT+3eNwL4WaZUpFwQj5QvjLSiiyEcci+5680M=;
	b=X/t84kLISTmiVJPCQs4yoTMaLcmLnKB9dtaBgRn1X03iCJ4lD888gXcjvw+5KbZlVg4uyt
	jwsSIjlEGJK9KwkNCE7Y17qeBvDRoC487jsP7aO6EnrIXki52kBRpVQxr/mselizV071qg
	5Syh2gsXI/FTT2mK3br/GPSXgoynHQE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D59141860;
	Wed,  8 Jul 2026 07:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB9A1F00A3A;
	Wed,  8 Jul 2026 07:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783496820;
	bh=xnyQ+PHT+3eNwL4WaZUpFwQj5QvjLSiiyEcci+5680M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Tq0udb3O/Y9T5qnEC8H++LRf8y4Zc8mrOdGACzi9BjbXQYJSAXNBhJSdbu6IN0QRt
	 Vl++O0GIH59JskKPG6pUkT/ls6L7BMcwdVHGy10AqTHQEeiNeyzCl/UoR1S3mgb88F
	 qVR9okijsk5wGLVjo4plGelA5kTJr86x3ltmCiZCZz1uZMzAiWJM9/wD32/H5tOlZd
	 kABS48CVXsyQSPNaKy0SyMtppbYYCQu824UximWMfOD9UUdp9FMMHIzxqcQ6sb6i9r
	 +DZsikgFOHtsb78F/7Tu1WiCpFXTvxxq3eWfTwB75m/Ac6nEyf49IBeMwgkR81UxT6
	 SUmE/ldoco4Jw==
Message-ID: <ad31d36d-ac84-4053-a5d9-e18c346f3908@kernel.org>
Date: Wed, 8 Jul 2026 09:46:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] mm: split underused anonymous mTHP folios
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707201735.4113107-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3269940006
X-Rspam-User: 
X-Stat-Signature: s9c3igxwo6j8mmsbofuw95homw14p6h3
X-Rspamd-Server: rspam03
X-HE-Tag: 1783496821-514385
X-HE-Meta: U2FsdGVkX1+mDpzLAMuYpz0lttCctXAxNVFS40dvgqXJc7GDXz/0/ecfNm3K+E1dzc3Yr7ET230yCJHQy8Xtx6qlbhCi9yOdrkg3Pv2o9rULvhQUcs5Z4jkuOZUQOvSz4mfoa+zduyilf6bcZ8/QKqZ4AwbdZ5oG4rs9q9Dx5/v55Tgf05rbuSyziX7k2zPcl3GD09eX/KNDlKDO1og3n0867feq+Eo1bUfvGp0QQ6+exK7NMgL1W7Z9ntSItdtGcbGWuOtqYhJyZzQsv78F3aWDZjPsQk4QTwyYUzk9kYH1LFcn7yp2XRQI/mLYKjnCUpt1rZjGuXgCFhO/V4W2i28XeL6QzjlfofmqgcpNG4oYmcFlY4o4PKEL28gPrhRGT9fIh17JZPX4ecqlOK9R3mrn9S5p/zlsDcvXeP0yRI0zYdHzuD8S7DKu6xJgeqwb2NCH73r8fU7SjCZ61DbC9+Pu+/1A1LuwjwFvE0zitt77qsT7gMNt8TPAzTVlvM7YlyufmyoI/2J1bo+7Q/FDgGYlaRFgxigbECCOl/dHccVKeaX1AMNOcEaNdPwOZl0Av/G1n+Z9t/qx+wU9w3P4fllQP2lcRWqjN0lhpyQhu4tU8SmpNCYVQJ9LExijPEkFIMe+RgHRX9LMMiKZMRgqCXY6A+kaS77q/mFAsU/qnfP/zIM6z649tw0r+Uflg9PXlUOQtHbSnaX7/WEsud4GVS5A92uKICc0aq3LcHeA+CXNMBwd6ykGbxEkWD9KYp85sT+1Mwejx8aE9oyuOTygrpafr4gttEQh2crLe5biasW0it3Xg2IJLOdHIXGLsKHdDQLiOU7DLdxR/84pVL7sJIg3Hb2U3IShNXNS+j73zR9hWsYhNMvgdCRZr9tYBxb8zEjiLxB75atn8B94DxrbdPHEAMXc9Z3zZLFr4l4Js8uakNelLWJUsjp76kThorq3ypNHsIimHsse17Y5EW2
 pV6b0BCp
 VLqqOZOJp5a3sea0KVxDm/k8KTlh22+mX6tt3GAafvPrGVTCYeW0aNQYwj0EIvmPWuI+rujActT3YxEvUP+imSFRc8J2CcZPEHIGB/B59hh9kminWgqb7ib6OH17kGIGmMV7u1OqG8mgkjR2kOiLhc8a1gFKZvNVGxaD3cMp6qHX59rRG+bxdHgWSvJYXXA2bxEGFfr3Lp0zoYc2xN1P2Ku8/ftelQ4nQgNiogbzCdlFTAkeisgscFHuCqmkYXAiB9cMg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 22:17, Joanne Koong wrote:
> PMD-sized THPs that are mostly zero-filled are reclaimed under memory pressure
> by the deferred split shrinker, but this is not done for mTHP folios. At Meta,
> we would like to deploy 2M THP=always on ARM (with 64k base pages), as 2M
> provides contpte benefits and 512M is too big. However, 2M THP=always will
> result in a memory regression unless the extra unused portions of THPs can be
> broken down and reclaimed.
> 
> This series has two patches:
> Patch 1 - makes thp_underused() work for non-PMD-sized folios by scaling
> khugepaged_max_ptes_none proportionally to the folio size and using that
> as the threshold for how many zero-filled pages a folio can contain before
> it's considered underused.
Did you look at the khugepaged side, and how we handle it there?

-- 
Cheers,

David

