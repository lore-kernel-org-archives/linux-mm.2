Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF38606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GjJqSRCY
Received: by kanga.kvack.org (Postfix)
	id CA8DA6B05B1; Mon, 26 Oct 2026 06:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C81926B05BE; Mon, 26 Oct 2026 06:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9A066B05BF; Mon, 26 Oct 2026 06:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6BB6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:38:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47FD2A82F4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:38:28 +0000 (UTC)
X-FDA: 85364428296.25.8D5B8B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1B54520003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:38:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GjJqSRCY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793011106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GU+AeFEAdhUpi99K1fdWPGQG0dY4SWw4OfyLJR/C7kM=;
	b=J4xO/ahfuVD2z8E3AhlOtlXPvI/APCy/qMMzGtcNRRoCJBLr/PNgcrNo38wpGHSlvRqyLO
	LZvzvQIHQkh2AikkyEbaifEER394WwsRBG74DcGuL4p016eiaKhMV9hME+jX1Gyskh2Vt0
	rDavUi9SggR9EYZfoRNHZnCKX5ntbVs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GjJqSRCY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793011106;
	b=TzD5OhiBxOTdEm5gGNprw5/LX73NzWVhbFnPxMC/3KmA45gHLVXBO5aeDlYLJibfr/B8Uv
	aDw7iszk2Q+W405lJiklbSDPBvkOU/JYq1Tm87A0Erp++xnuaOesIDihCeA2bj2EqSdhXh
	P1OfGIpDj7iqhJVoIn/sK7xpwd5BkFM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9C1243459;
	Mon, 26 Oct 2026 10:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014A31F01825;
	Mon, 26 Oct 2026 10:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793011105;
	bh=GU+AeFEAdhUpi99K1fdWPGQG0dY4SWw4OfyLJR/C7kM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GjJqSRCYjZC1eqOEvkoQv7CyrY/C8hYbCw9lhik1jwBNpK/JU6ARH4dUDH9wDjplg
	 7+HYKT/3ey+4DDpk+wNszxM0z0tSoUjSFxmSCzZGcqfdAP5jG7azU1HS1+RqKX0Af/
	 PPXcjf1sjNjzmUzXaSWoYS2AuLUvTU1y1uzcfMszeb88moHX74pDNzwD1ro/AUHI5z
	 pZFHGXHd9mkeuQxdwnU09Oez3yyzRwalR4K1lVvDRY+R/LgoWZWijfxiSMLAgfgf+d
	 1A0iVUdrFfAUGMI1Ps6+uMMHj8Wv9aJ8S3P0FPaHfsOMTxGud6ZKuYBiPkbPGERS4b
	 Jv2sr4SpcX8cA==
Message-ID: <e7326e8f-a5a1-433e-9df2-6134948d129a@kernel.org>
Date: Mon, 26 Oct 2026 11:38:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: generalize PMD page table allocation
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Arnd Bergmann <arnd@arndb.de>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, linux-mm@kvack.org,
 linux-arch@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261014035910.687847-1-songmuchun@bytedance.com>
 <20261014035910.687847-3-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261014035910.687847-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1B54520003
X-Stat-Signature: xmaecd6cykja9t67uopafr4jo6qg531h
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793011106-787806
X-HE-Meta: U2FsdGVkX1+02PPJrneyzmjd5iJM3K6bakplC5K/IPE6vl/6EEkW3fjVNseuigOjd4bMVUvg3HZuUnNjsmCcK7ivcHcK+sZmXa4MaGcbeY6aVIw/39oH8S14yjIpDP3tf61E+ZHOJ5tITu3shAfykovXtL/3ymaBa8JGW+Q0NhzkdIVePST+T+qeNq30EvxlrMEdJNmpXWdzh2YZiO+kQ5Xhd62PtJucX/d1CsDeDpHlHqHWGS8u9WxV8vkjCRQVEC2xmbWo8qGajqV/Fd5nnEg8DO00WvlvCRkBzSwwXEgrPHDAvzDRidltxbzEtl0wKf7ESW4nIyoeh5b5EcfstYdPGIHSLV3v9dJaF9TdFiSRCQ3kt3KY1SY0OedjlSlqndUVq5ziVkeIvGTH/GBOqtzHdynSOp5jyTDGkkOWDcqgLjav3bRW1bw7oJUU5EZyj1gU5NbnmOSQSfgR5gw8Pgfv2PPoCyCumrB27KkxWNy2v7Y4a1joGh/q4NMTwkH0wpSqQNLmCItFDmA6rdqBefD7DPwimw16Z3jhV5fzO3nV44BLMfJQ6e8OWvtx3ZSsAviNJA9DsK+hQftzoiWXMxtRftsZXeWsKYfMvkUZWu5S2SGDtdjw8GV0Zpeq6qriNRByeE3tnqpWQh4jYANFhm1AnIU5CdAubtAF8Dz1/L8OMJ/pjd6zd6yVv2tRQJulMJZtC1Owpa2PMXJXkUEfA4/lBamFgLp2g7GWg3B2HP/IO5jrhesKl/df4uEtHH5jVWhXPHFEQAX3sa/lwyX3CdPkh81KmfrfQjyvXAweLKRd5WY2B2ZFBlFuBRB/yN9bKbyCGoS4B582leWHwGx+3w+Cyls/iVSXGNQbDC/sbhTFPqRJK7sAw8g13/b6F60jifq/QaPYW9PDEOoo1wErxn8W/x/sdvW/6Zyt4Xb1Ju23KbseG10JGSLlRLv/YDsa9UgKZbORRppgEXQI7b2
 +wRo+dc+
 D/lNEmy2/rq5eQUjl+w9NMTKqZjnlREK3DTbq9msYVnRuZUSqHloxP6ophN6naskct+bPlIG/5UE9E6TI9F7R/2rgjt/LxJvI62HtRWnaUU54/ZlY9Rv732VAsPu2Rduqq60sDAWqdycYHUILT3VpqwlKwfAVuLI6yiGxtxnywJGEnCRKq0LGzRgx85ehiGtvIDAldm1Ny04FFFxp3+vGYZWqCeM4Uf04BSr0gPwSXKQgmzGOBSbeARb45evGvUS5XEsx5TXw80KmAPjO/GJoe7eaCOygsjstZU3WaO7+cACNypqKb5yXALTliDeqipX0+4OTP8rzo6jzzwFnmnPabbQ/0NBajOjB7ZJBlUjy0EUMKMCpi7/ynxtKvxXFJ57RO6fi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/14/26 05:59, Muchun Song wrote:
> The generic PMD allocator assumes order-0 page tables and zero-valued
> empty entries. MIPS and LoongArch need pmd_init() to install their invalid
> entries, while MIPS and parisc use PMD_TABLE_ORDER to describe the
> allocation size.
> 
> Default PMD_TABLE_ORDER to zero, honor architecture overrides, and invoke
> pmd_init() from the generic allocator. MIPS, LoongArch, and parisc can then
> use the generic GFP selection, constructor handling, and kernel ptdesc
> marking instead of duplicating most of the helper.
> 
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

