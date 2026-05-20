Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A2B0CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AC666B0005; Wed, 20 May 2026 06:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05CDD6B0088; Wed, 20 May 2026 06:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8DEF6B008A; Wed, 20 May 2026 06:41:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7F656B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:41:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A32E40270
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:41:44 +0000 (UTC)
X-FDA: 84787457328.18.EB19EAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9EBF2100003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:41:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZlgz0kL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779273702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyWr+KcV0xbK8BeY/Tq82S3QHBk4hm+zEvAPjwjFLlQ=;
	b=WwSphIhJiEnsPlDIRl+8Ogzho+2XKwwbgoGrgDZjalxcN6hN05eXOFONooER1r+P0jLUnH
	P0cSaTK/kZLq6jZs5u8nnTerlrgBVrlCFm9BmmNchvYRgT6g7OhtDDxKNFp6QJeurda0MH
	3S+7fQS4anrp2nFGtTKk4zhgWHiJB0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779273702; a=rsa-sha256;
	cv=none;
	b=dzT7tFDUF/+DfUmmtaNIOQkPCMATv0m2lE36qe6OEg48B1b98IElINSvb7GUYIGqS7DTtQ
	8XkM7g8tnexwmXI5MW2ruM4vFwOx5GzSzfWL1mvO+tnQzAZArjw6G/kgd8N+KCc62RnFr2
	WzFBTv203J67hnSLtMiGXRfzaqjuDQo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZlgz0kL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A2DA600CB;
	Wed, 20 May 2026 10:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D23A1F000E9;
	Wed, 20 May 2026 10:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779273701;
	bh=fyWr+KcV0xbK8BeY/Tq82S3QHBk4hm+zEvAPjwjFLlQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GZlgz0kLFA7K+2vxdMyBecJFXMM+40kznp26wQBdVvDMoZaU4tyQidhckg0yunKH9
	 RoR59GwrRIeZf33pz/SYRQAtcurrynC+u9UAV/0p3KXsjrAWeGjOUi9uRqZdEcJavG
	 nI4hFa25iUYLPyxIhzipJapASCZDlAWb6Tvl+0Uo2Wy0nbRyog63ABlw002vPtw/2e
	 d7B15oCDuW1d1ErKGvMZA19Snxn87iK1TD5WGewO8Jeu8jKl4keztzr/YA5ojev0S9
	 QFV/JDk1W0gNJzAR0M/t/Wcps7QZlv1S2JWdZ2JQJfGlqczxbPLEzvhkeImSHt7cYB
	 ClZBugpGLPPGg==
Message-ID: <b976ec4e-d5cb-4856-885d-dd301b3ddd83@kernel.org>
Date: Wed, 20 May 2026 12:41:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 01/14] mm: Abstract printing of pxd_val()
To: Dave Hansen <dave.hansen@intel.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, Usama Arif <usama.arif@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
 <20260513044547.4128549-2-anshuman.khandual@arm.com>
 <74f66e30-ab3d-4352-89ef-1bccc7e9daeb@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <74f66e30-ab3d-4352-89ef-1bccc7e9daeb@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9EBF2100003
X-Stat-Signature: qzsesgx4waepykj5mp5e8sx73d9m3btr
X-Rspam-User: 
X-HE-Tag: 1779273702-63767
X-HE-Meta: U2FsdGVkX190qBnqqj5wwlGUz+k6SD49ykK1srTQ1MSxIb8SSCTLslKgaZ48wocj5KD/HawiaJpGcqeKKF1lpF8TUUAJ9AyrJjzG6trxsN/1dFKpaBaPpfCLKQg5PFf0/8bHGSkg6iXmQhi2zUybdr22IG+cb0kO8kJwtJBS23oCDbY2u7BygRkk1IFSgtv+u8fvYkj7NM1CIsmCCJBQooDOqrpv4vEhuQsYMqBY4EsT+AX1kOROlisWlqaRWWdlUoHv77qTEfBt6W88vL0pfzw4mps5sU6+yCXNwzD2PA1iAUY/P9t9BLudH38AlQ1EkgC9kKlkKuYtWtUecN+jnWo5dxcdzdE+v0JT3PVy881NK/LlENxMhgzMQgCdscykRJyVqIQEKfrR4vfhWJtbcSii5Dj/ItXZhY3tvhj+MihAhf16eOl8O7aqWjmj7FeVmI57bKxszvDmzADAF+9D3E4B26idJgXbjvCukd/z/RSyxr6wbpXJPvG1YKLg9O3Gztmh6iaORQDhSfLqmeDgvtrNdhQJd5ZvHWIGCDi4drly5UU6/CzPEMb6bxoZETDnKfu4LFM728cBiLoZfULn6L4KPf8LMy8BQoxL/XGF82SWKLCebw1W9iyaxi0eZ9bQ4YpzQyiDmucjh2IFWrMPNDzIUiNnDIuFKP/3yN94AtXAKT+XD/d+9j+cI7Pb6I4cHK15RIMMCbS9HIaHr0ebxgqE6HS7DSAJEg3Rvu+L4UCwHVwPNZkpOm3X/Hx9VOMhPqEMFeYiR6dCNLdkwPDGExpattnvq7DeYyod/nP7GcLA8Dp70lfpNb/heSFVkm98GO0qFEuhHYvR+u9v9qRciPSQSwRqKhoCKayMY3Gl1sabtVPWKcyfpWpNjrGOHcXF8Fiw7ghwh3I5+jL0cNwhaoyE5ZKMCU+PU0UBZp0/czkNKl8osVMexypfmzo2kUhizILkIX/d3LXk12QRhs7
 INIb3vxF
 95CniV4K6tnFL79F0ndfRJ+RjYYi5XEwlVOMOAy+WXnzjTgECKL3bKcGvEZwcdy0Vy4ZaNGxqezoU4YAa+1P++9LTbzZdRyn+aKdkrJBThNQ+ia35GHCie96XWyHNWFiRfmeSUwO5w8aQbHbsKRM/4SQ+6z85LNne3lzDESEGnwUmCCF0wAwZMGH/xhWwl9zGwB7mD1QLJnP1OHQnQLyHC936wq5QAOIGNRG8cM5fKgcNKcktb74vNew9pLN+i4UqVEja81YDinQSNc1+Xnt9Lra/orXkZaoQf35dKDeXqt8/ACUibLCdO22gVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 16:28, Dave Hansen wrote:
> On 5/12/26 21:45, Anshuman Khandual wrote:
>>  	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
>> -		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
>> +		pr_alert("pgd:%" __PRIpxx " p4d:%" __PRIpxx "\n",
>> +			 __PRIpxx_args(pgdv), __PRIpxx_args(p4dv));
>>  		return;
>>  	}
> 
> That's not the most readable result. Could a printk() format specifier
> make this nicer? Maybe use "%pT"?
> 
> 	pr_alert("pgd:%pT p4d:%pT\n", &pgd, &p4d);
> 
> I _think_ it could even get rid of the p??v variables.

That would be nicer indeed, if that works.

-- 
Cheers,

David

