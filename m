Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0566110398B2
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC946B00EF; Fri, 27 Feb 2026 15:57:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3676B00F1; Fri, 27 Feb 2026 15:57:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABFD6B00F4; Fri, 27 Feb 2026 15:57:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A37C6B00EF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:57:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1728313BDEC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:57:09 +0000 (UTC)
X-FDA: 84491446578.15.960BA53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 65023120009
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:57:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iahY6J2z;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772225827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLfKkhcWnH/9ohJ0h3h4HNDPIJWkQSaRBqAYqCO4DCk=;
	b=vRjEhtuqSM7p2ZCTnkFSbFPek/lWn54CEC5l61mHp5gdrDH7M2r8pcUsbiunf28Z5kA6vh
	dXOZXick0R46Ggyus8O8hBGqzyGDGZWsz3sDNEj6dsGizqSXviDQ9nX+sZVzpxo6L8NdrJ
	14H8lfE30rbZVr+vQP5qV3mnmBbigic=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iahY6J2z;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772225827; a=rsa-sha256;
	cv=none;
	b=FobIG44eT6ED7oLzI4pA4rGC2Gm9eNIDb1oACLw20KL3eNDr45SKvILFL39NIdaiQC9n10
	V7P9n6X0Bnvk1cohZpBY2wo3mTPLS8uTMV9CyoGDwteDoXWPfn8yKc2Sxos+P1VEHn/vPo
	kvu+7MWhZLjgC8YZhjvkD0d/Hl4Oyeo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E60C960137;
	Fri, 27 Feb 2026 20:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B82C116C6;
	Fri, 27 Feb 2026 20:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772225826;
	bh=jN++5+fyopK0ebaI0/tN+FMCYIwdoX+CiSE5DAc+JMQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iahY6J2zr+FK7pIkam758ib/IzAkZgx1/9bB/UUWqkE98qH1vXV0fLHroGZJN43sm
	 /otn4HZQEvxaSLhGfNvFm5WIDr947JvTf2AoGEkp6z8fk4osfrxg54NP0hUssco3uT
	 cMSmolOPEF9tVR/2y3G85Luv/4RPh4ACOTVQfqVR9yYqhRzKhDGNeiS3NeoVW6Y2gt
	 pD9VQKi5xLqz5gipcWs9XbHGj8jmoRZbACvFrHYKlLfqlAvQcE/mB0YLFWPPEGOaeJ
	 mUpUKgn1JyJxyGUcW54k8oyhbUoR/VmbjCVhN96Kv/oxrrjT/80poBfUV1S18TB8hH
	 OpiSbPkHKF5Xw==
Message-ID: <4f512562-1fed-454e-aca3-2e1a257c28b0@kernel.org>
Date: Fri, 27 Feb 2026 21:57:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] khugepaged: remove redundant index check for
 pmd-folios
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260227143501.1488110-1-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227143501.1488110-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 65023120009
X-Stat-Signature: 5d11tojtydxaq7rhie9w6pi6afbx36k5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772225827-875062
X-HE-Meta: U2FsdGVkX19NuPtpTPV5Y/+2uTNq+BWU9EtaSzuE3CVCPtLO8fcwPN4U30HWtD/Rqgkvq7bfiqcWnjFcc4V7QQ69b1bt8IszXuhnvNF9f5GbaVbfnC5b08veacavuvGU6oQWZ5HiTofp81JyJBiFDMQsKS2dCWgZK0yXuHDCTEEaWfbz7J7PjXOhTp5BXfF/Z11D82EI4y8UOBy2UyoBujKKnGrofj+OavqIRAtIq2xpNzto1ObWnHlsBAP2WhXFFvQzxsDYQpofTSeaooo82nzwWrT2dmrOSxU844d9CxNrVDCG1n7qDMdQLNK/onEdDCmyEriu9liNXlPu8djG+/D15LASspKaxJEngXjdcsO4/3zKz+uNWrB7IotVN+19eVMnYcagUxG+/NShA29zILR8ua8kdHdvPg06vtPP2NuId/29dbKw24kkc4TchrBGQtllj4nmCjvS2VZ8nyYdO3vv6WVIAxT/bcX6tzO4gDtYi+c2ft1FVkHYilOhdbmZrtdLmiux7LnTFxa3n/GW+h6bA6xysUWrzXxIbZgutfG06fn4Ih3NmB2bIYJJvsrU/0oOIhgXcfK5UtqYg0zmu4zDzjGi2wBGro8ap6rtC0rjYdiY/1VD99P7bN/RwJP45gC7SRGhYe5F5/qNqhwfy9ORtt/LFFu2ZpbwtYfiXcYb2nY/kYYdL7f8G3dRBWFbDKFMYo4S9aLJiWQzyh6YamaI410BBDCSMZwHjOZHrSZr6COQ7KvLpEEoTfp3ciEvHyg7pDTXmR9/B1CZFDT3Q8ZUWfVtbaw5f3BjLnTGT0pkbmJHbAqnjegblh6tDmrvJKvuq9VmUbq3l8btS6fItU3tD6M/mnBK1WiNDVz3S2A8u7s7wjudCusau3+xT1fxx/pkyae6+g8Qux8hhtICeoR9a6LtKFt78BradUoHySix3ucsv8WvcreIKogMqIpNg2p/y8J/1F9yH/MZ0d8
 LpkDZ6Ue
 JLta+j3CQLnh3t1h/IhN8js3LH49RpMprm+XgE0pKmz6vo2mnDI2BRwZMhHcZAQedzj/zSm0VCr1EWkyOLrTSXIV0rKcarFo9IEAQYeXL0SNgWXUjb+Hu3Huv4JHz915gW089DWNnCPJtRu5l7NRT/0VVztpVL+eZfkj7diHVwaFQV6ONMCkvFRELlQy4sqIt1xYKymtEyibShKMVjUgWMdYyyM+pZc2yRy00X0BQ7izxdPfdFlA6Rd4JE0xe+neSiIi2roIQrqZsby4Gm5l0de6s3Lj201tEvSlhRnKoz3uVV3ZZ3lMf7D3PZsDDGnUYR57uCTdvH5kSn08M3DScXVcqHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 15:35, Dev Jain wrote:
> Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.
> 
> Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
> iterate on the xarray, have the invariant that
> start <= folio->index < start + HPAGE_PMD_NR ... (i)
> 
> A folio is always naturally aligned in the pagecache, therefore
> folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)
> 
> thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
> offsets in the VMA are aligned to the order,
> => IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)
> 
> Combining (i), (ii) and (iii), the claim is proven.
> 
> Therefore, remove this check.
> While at it, simplify the comments.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

There might be some conflict with Nicos changes.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

