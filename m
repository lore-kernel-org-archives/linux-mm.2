Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A00B2CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5816B0095; Tue, 29 Sep 2026 03:43:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F0F6B009B; Tue, 29 Sep 2026 03:43:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DE46B009D; Tue, 29 Sep 2026 03:43:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7056B0095
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:43:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4815A6AB6
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:43:18 +0000 (UTC)
X-FDA: 85266009276.22.EBAF6A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2A18680009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:43:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mJschNlB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790667797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3uGJBgDueAYQpQ6UNN5wXxoFfi297uAcZttSK4/i90=;
	b=QMNmp9zM/lzoqf03y4IvjobYknowyLoPXCIJLbIwPs/gBWKQkAQNy0LugEqgVNsjd7pu1i
	rRjDkcERzZsdT8VltFqF3lahchAtVLTaJawegcPktQthEJ30y5Qx/pXprrX0uI8EW6Ik5Y
	B/Nk975opPSb/202C/04me/kJ2J6/Wg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mJschNlB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790667797;
	b=6svk83dgV202mQZJM8ihqR6SoQkOgyeGHpvamEsxAFEYRO9/nzH2yF2eHosblbpP5TbfrL
	jOERIsu1Q2nPM9fStaggaEG+GI2+QXs9DNIx7RVb15OEq0U2JuSPs+QT2+rtVqniXo9oHt
	wxmXGnHPGCJtVyidU/z9nJ/TCn7t6Uo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB8DF60210;
	Tue, 29 Sep 2026 07:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2393E1F000FF;
	Tue, 29 Sep 2026 07:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790667796;
	bh=l3uGJBgDueAYQpQ6UNN5wXxoFfi297uAcZttSK4/i90=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mJschNlBhoq9JKJyXT7dxafC1SkgQ74/itXQ7YwoOf11UukAMavZEzlz8PtWHfAno
	 SYhiTLj5jpURd1SowXyoIu2+Gwvol8zbHo91ZzqUSOsgnxKYa6ELES9UWm/7/P5tkA
	 zdDL0MswCGxbxULsDOWRMheevjty+5eUD4shlcnarGIbO+XJpSDYVd4c2TDUdw3vfb
	 FPX8+F1xS5SUJBU5R4Cg2hiqlUT6ia6fW/NQenc+kUfadGKMWypBlvGiJxGuvDKqsV
	 4MEB0Z8KPhQkF0PC3/501YPQrx5JRUtNETEuL77Yd7cB/n7vryd4mFKMkofjhhQIfL
	 OTqFoxUtsHukA==
Message-ID: <118caa06-71cf-432a-a7d4-d721e86cd905@kernel.org>
Date: Tue, 29 Sep 2026 09:43:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/12] Documentation/mm: update DAX vmemmap
 deduplication docs
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-13-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927025441.741633-13-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xib7uf3bbman4dqyhh3kc3ousr6bqne4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A18680009
X-HE-Tag: 1790667797-993369
X-HE-Meta: U2FsdGVkX18nrdwthiLaYmVO/kWAaZGpOWQr7nkpIvQ+IgJth/LlPLWOtJ0HFE9QAoYHuwhYgLckMXpVcNKXkprRB1iui7rD1Qgn7cwlUhU3adqDFElQ1Zj02q80A0qWnMtozIYgMGjv70XbGFL1pze8IJcrnTxZdJ1osmLSExzME4vtTaf2a2/M/RKS45bR5rztl0QoCV8sP4PaX8YmElzEvOBRmBSQGY+txjOaCSTKT4D/mYE+8uk650EIddiA5ZBF9B35G7eDBZ0upITvmHe/dUNKuLgmk+7gZTiCIPZSu4qzWeC1dQQKhmoB0la6GDx1tv+AmmyLj6Kk9lRqJd00/3dgGRVRTBT5gbbYXTRcXiEmYqkW3GEeOq2QxetsX6skuLzVDx7rck15YPCXjlg/qB5vJPpzsn2VwhEn+LmFE60hkv18HCW8VnHKaxruKPNnLJFg02k9dCtbShPmi2OXP7oK/48RSXKkrHe3SVOM2PkwCt6ElmXxRjHnzugOsLMsHcLr5Sp27OY0WSWlFDd8hbBQLgg0bB2oagccJEB7RumWYIUqyemQdkRFtcFb4m9SvbAHD2fNzOz0h9YWbIEdLJJ/PHjcGO1sj/KjwyraTTfKVQJ+tR3diYnMNtNFSnctctfcBr9OY8Otk3BVBG8EPk+TOQWGfIE59N/bRVFg0hYgTTZxMHgZ4Z6rhx+7yZ9gW+v3W6RaU/h5xJhvWxUTZgwkOK3TRf0MvRKfKUlBVAW+HHmIp7wFZejxSCbEsH5acEvwbPQ/0nDuwYf3r/eylLvoEyMtGN6fL+xf6TwDenHO6kmZ2ZhTXhMaR7rjYL123TEi9eaPfVDU5Y8AF6eGmA9cVGCPHPBzDHek4vKHSBGdE3Agy3guNy9SvjvwmunCKPw1KaMa5+LMHT9hq6QDtbQC0B+9ErdqhqoedjYy68w0LgmicV4Txf/u/ghPN5Bd/zzOGXkfD2tGK1E
 TBORDYKa
 suAx/w9Tv6mbhCpkYZXjoT0tHK1tuVQZ+/m398PCY3Ls2dVMdtEej8rqcMmWVpfp12Flc5DBaQYeYUMoiv1L9TQCKZVGIWdtexS/CYjp5LNw625WlTl0cKBodmXBto+dpbPYh+JJs32e7yB6kptxWigOOxcJXyfMmSnDaxMR9hDDyIaKQScgN37DZEHGq6K+gxu/SWGuOrNly1GTxDA3z/inyv39mHNIHG3uFLk4lUrHuYRjB9umvXtnScmZtoraKEk/VZyOc3DGLw+E6224YkGBR+xtM3yT8ISP6/ywd71eTky8bQqNrP9TLIuo7XSST+cVIwNVrY8brGE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 04:54, Muchun Song wrote:
> Device DAX now uses the common per-zone shared tail page for vmemmap
> deduplication. The old documentation still described a DAX-specific
> layout with a separately populated tail vmemmap page and half the HugeTLB
> savings.
> 
> Update the generic and powerpc documentation to describe the shared layout.
> In the powerpc document, keep the radix and 64K-specific details, drop the
> duplicated 4K PUD arithmetic, and replace the repeated device-dax diagrams
> with a single parameterized PMD/PUD diagram.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

