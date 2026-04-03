Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3F6BD7309D
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 05:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1310F6B0005; Fri,  3 Apr 2026 01:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBE26B0089; Fri,  3 Apr 2026 01:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1586B008A; Fri,  3 Apr 2026 01:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8E416B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 01:09:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AE8A58E53
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:09:21 +0000 (UTC)
X-FDA: 84616066122.26.B71D397
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 96CFF12000B
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 05:09:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p2FhMQJk;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775192959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3EO3KZcrJUWPCB4Hstcu+7wwY1J06Wb0Uds4H2tFoho=;
	b=JOl4VKfmaZkdceyEvED9kyu5fgEXY7vWYwW86p+vYTy7PGMwCbq3ONJeVNk4XJARFBYuVa
	t8xQTXf7EcWeVAFwhl2v/NplIvJN0vT4A62GErDC7kPyz+Lx4eJOSn9Bw4MeaGi/tAICtx
	21b0zs/HdrcbkI1/y/7ijuDO/fn5/vo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775192959; a=rsa-sha256;
	cv=none;
	b=ihvi7CslcfxyPI74F35K8CStXhkdmtiaHdGl0li5TxIyE+SGuG5DDx6vpo2AfpjHbV2q/h
	C7dpYmOvdfRU5KnZWliVUlpfwdmOpS3OkBZehvwOkBvNwbvqFZYt2ONE1PouNmtxE4f1vG
	Fi/Q4f4qpwfdjuNpHRyFep/sPh9RMN4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p2FhMQJk;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <0be813e8-1117-48c1-aeba-c584cda9aa31@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775192957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3EO3KZcrJUWPCB4Hstcu+7wwY1J06Wb0Uds4H2tFoho=;
	b=p2FhMQJknXonfhMlg8x6dU8op9V7lepg5A5gFInMx8Eir2oQv8LJ2Lpj8S0mZdnlkH2nvs
	xYtAj7FODrkAuYpa48E6xc6SNkjXtuTpxq7//mVesG9nIGt0s+yIzmWbm4ICpIEXyWmF8u
	c2v1B3ogQ8VvF4CwQDjn397mu3xFcaM=
Date: Fri, 3 Apr 2026 13:09:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm: huge_memory: use sysfs_match_string() in
 defrag_store()
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>
Cc: linux-mm@kvack.org, Nico Pache <npache@redhat.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Ryan Roberts <ryan.roberts@arm.com>, David Hildenbrand <david@kernel.org>,
 Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, Lorenzo Stoakes <ljs@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org>
 <20260320-thp_defrag-v1-1-6ab15d0d26eb@debian.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260320-thp_defrag-v1-1-6ab15d0d26eb@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: pcg1j41tj6ex33jebzo96xh5bkubo7qi
X-Rspamd-Queue-Id: 96CFF12000B
X-Rspam-User: 
X-HE-Tag: 1775192959-733338
X-HE-Meta: U2FsdGVkX18y/KhpUc4Oddbys5ZZgWYyIIB0ERJACAHc6KXsU15U1lZANhxnL9B1C5b1DQQXh0IHNpV2KJAMIjjQzlXdcA+ZU2kraIFew/ivrA0/t1XZMYXueTF0PbqvRBbUSn8Wn1B2wOHtMFLjCrB3CoLwxHSPWfj/ka2tBbekM97PWUSwrj+sG4gFwqMYyjFEl+NMF2u6kcwDpG7UM9S+BCmlAmELZvNaKGwyTVnTdxwn2kZjTUZBgi2dB6Z7TkRjLH2hWvHuFwnkc/K25iQf6/t7AyCXj7GWMBoiERvQ5rIirAWKnBs/w9Gy3IYqVy8hk6OHcu5Zl9ZZSEv66DibE0jOIcCf4jd9Vz6//sJii/PGbl5aEsBUl4V9cTJist+AQGAReO7aBPNXWcMTFtBmu0TvUvqZIS3HfCtdoGiD0IYDPqKI77BLUy27ida9YajwHczRpWH0yzMszOra+PxmIZlXUm9cUTWiKCPzg0GxSYisSp9RFVAqd31Uw2SzzN7Jf1fb0c8pEKPtvzmkqrbOaM3cxeDfGWn/Vaeg+rtCOPVeNnpXppEmx47aFDha3OFNZkZf8KaOLOq4GimE7fN8PioenwkPkULld2bdjdGnMaQ7cesSFXAQVkNVCAZgX/1f39fb2fmL3coL2AtDqz4Yd5YGHBF3kGH7rIMk2SDLAkFrm1S3/U1+LNyLgf6T/CbX3Vdt8GcD2Sn9Cuj6RgSjLRGZoPvdlabilR13RVtyX9MwEhte6CoicGweSVQVj49n4OFlXFqbHWnUaC1IpjDCupx50HIzP//JGjecRmKT7Mr2W11OCnMet2UbPzhAjRHkIiTrvoDH2hi4AZ1iz8/TSj9NOCKRcFOz2Qw+9IfgqD/XFYQxlPEqhsunFXpJjpwW1lOo9a47bMAgof4vTj1T+CaQbDMCBnov/N3TNE+KrHIGT2goesGPnDRiIRFZUU7oFn5ySJJqree7tr8
 09HxmnCS
 ehg9lFjyPXnmwpae6wL2y0wsmR821MDCekRXsiZaXpBKGmKxrQQzd5rbWczfmMHSX1X64dv3XJ5c9PylprgNeYs1xmQfi9QvHtQ/bGsWY2A57nhdTmkFLjpHnuCLOpt9NAHY1UMHiP6WG1TmqZY7b4z7SAIgJaH/7K5khTia8etD3dN0yHTKr6DkviyGSc/oyuVA7C5b8i+rMVhKcBZcXMTIjpUfX2sj9/Yuo8kHzwUNbxnyquk2kyMgi6eU/Arn92Yo9C9/VS56ID8gRhMCMw71D0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/21 00:05, Breno Leitao wrote:
> Replace the if/else chain of sysfs_streq() calls in defrag_store()
> with sysfs_match_string() and a defrag_mode_strings[] table.
> 
> Introduce enum defrag_mode and defrag_flags[] array mapping each mode
> to its corresponding transparent_hugepage_flag. The store function now
> loops over defrag_flags[], setting the bit for the selected mode and
> clearing the others. When mode is DEFRAG_NEVER (index 4), no index
> in the 4-element defrag_flags[] matches, so all flags are cleared.
> 
> Note that the enum ordering (always, defer, defer+madvise, madvise,
> never) differs from the original if/else chain order in defrag_store()
> (always, defer+madvise, defer, madvise, never). This is intentional to
> match the display order used by defrag_show().
> 
> This is a follow-up cleanup to commit 522dfb4ba71f ("mm: huge_memory:
> refactor anon_enabled_store() with change_anon_orders()") which applied
> the same sysfs_match_string() pattern to anon_enabled_store().
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

Thanks.

Tested-by: Lance Yang <lance.yang@linux.dev>

With David's comments addressed, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

Cheers,
Lance

