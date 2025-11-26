Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48F72D1039D
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C2AC6B002B; Wed, 26 Nov 2025 05:19:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9733A6B002C; Wed, 26 Nov 2025 05:19:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888B16B002D; Wed, 26 Nov 2025 05:19:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 728F86B002B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:19:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0A1B4FCDA
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:19:15 +0000 (UTC)
X-FDA: 84152360670.23.53BAAD1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id DBDCF10000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:19:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764152354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2EezXp1iuJioPJQW13iIP0PBMsX76sjrnF2YwQpS464=;
	b=TGa0y6i7lMgPXHSNtOBIOZ9uJjpiBlhKFSsBPYeYr75gtIzhBTFKkkwqf16j9+ayFGCJ/+
	C1gurw+7GIAxAbsRrLLXo3tAZX+mTLRvX/r7HVk+bC0yJx2eblHdutXS9UbhhJrlIR45Xg
	OcI0u7y3oRvWQzOPfGzDNNJFz26irw4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764152354; a=rsa-sha256;
	cv=none;
	b=0X0Apd6kCtK1PJtcb6/Y1VxeyHKZN9wn3uNqQsnC1PO+DjZTwJJ6hWnrJfGGYNOtsiXGQ8
	stsh8Cx1GIooJHm21F/yiPJuojDjtYG4/Z6UnOmlYJP1XuQSE+ELMkmEZpA3udM8KSnTYl
	70GpniFB7Bd3TT/aOKpfj6QfMsdSVpo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AA84168F;
	Wed, 26 Nov 2025 02:19:05 -0800 (PST)
Received: from [10.1.33.153] (unknown [10.1.33.153])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5F2E3F73B;
	Wed, 26 Nov 2025 02:19:10 -0800 (PST)
Message-ID: <323987c5-aecc-40c2-9837-9630186367b6@arm.com>
Date: Wed, 26 Nov 2025 10:19:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: use standard page table accessors
Content-Language: en-GB
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev,
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org
References: <20251126064723.4053-1-richard.weiyang@gmail.com>
 <506e7a41-a199-461e-91b1-035ebd5d5527@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <506e7a41-a199-461e-91b1-035ebd5d5527@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DBDCF10000C
X-Rspamd-Server: rspam02
X-Stat-Signature: yigi6xe5um7xokix6u7gdoijr5fxjwbx
X-Rspam-User: 
X-HE-Tag: 1764152353-565345
X-HE-Meta: U2FsdGVkX1/Slfjf5WH4obyqbNWi+1SXDwrl/x7UfMRq1sRZdlzuVL7VREQ8Yg9Jw+39nO0q7JOOEwqm+T19zIuGbOQk30qOCR0bAyafpxE6eZlgfBSWez8QCj66Pi/jbQZnKMTriqE97eKdKQZfWY8y4wyFQC6al3nBtLS+Re2FGBmVuK4HGJMulCiYFTQtfGsc1dvAF5QC4133+pvyVzKcJ2t3ZrbfS0XTumY70SJAvfOIAfA1qGLhT8Az7Cr3ugjFt5WrhJxviWj9WKf8uLG5RzSkL3I2z3MYZeXCfdXLHRMEPGcvIa2fa7R+g1eg0806Gty8QT6newE58A+6mApFPJU+p3Ss1xYLZeco4sAtfEpAvy3QlXMkF0bc4kmTev7/DZ2ZpEqjw7qT007jkaPQAgT4x2QnC6w1KGxpeHzKml7xBKYH8O3aXljsHWLdGqaz/O8swWbcJnf3nlIfJMWwQ90pzuKwM7FzdNawMrBY40yPwXdqDuSwczpcCTeVU4dY0DcDjfj9VFE8M/yhXRUJErkUIpaIbzEK7/kcWGo1xlwe4hd8oRYP/MOl6lIRDjeSCRB5zms2Ykhc4ILp7YL7aAhiYvRDEL17Rok3gLxGkXPCa0Kwa9Tj7OHx19Mtfpp6j/1o3YtRo3VmWWaAVJy18rD3nzoHuCktyMBQD0UV19VUwfs9Je1cOCPlvaQ9O1MShgKCJA6sqpr39tzKeIFCHsIfFjXZDZErFJoGyR+Qz6XO/3uYfOnrsC/KoepzJjP/l+SOluxrtYZF2cwyhoaEQsU4LWJs+ult+KKh6gr619qxoxYZu51rFkFKZUzcBuqJ1pVjreaEpTHt7VbPr4zoR/YQQyXRpvHT1ZTgmYzCKNQhSr3FzDjXkWqMYQhvdNMaR7Sz1IY2SkBtLSD+eakva7r5o2+fvQfobXbE0P+E1Lnk31+JQuohK1uMTVwWG6PEvPerK3kIMiwaRkY
 K6naXAS6
 ECvjsr1vcE+wYIMbgjfdbtb0XqPerSy9K+WOTdAKjpQD5ClFlo/p6bpNNcVBCVdgpwSbO4K4ENy5zT9Zbfc/+bFpCnk0BC64oOrIJJ7iLPeZ+RKjYpn8rzPWKdFEHstzLH5PfhqhcY5qBRkjPCXOz0Xc0UqLpYPDjM/bF/oUCSoiSdh75tkgzcUWQ52kCFX4k3ZlvecOnXw+WUMMeraKx1XWxHpojwSPTOTgIBrTSPBeiXUf7HXXvflOoiIbkuUkHnpv/QfeE077Lh2lxbtTsY52Vieox5a+45qlsZsYIZp0bq1A/m6rVCVMR+bPKYEreREg0rWDVvJXKvHZOCZ/GqT5lreuABwQRK3PB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Anshuman

On 26/11/2025 09:09, David Hildenbrand (Red Hat) wrote:
> On 11/26/25 07:47, Wei Yang wrote:
>> Use standard page table accessors i.e pxdp_get() to get the value of
>> pxdp.
>>
> 
> Isn't this covered by
> 
> https://lkml.kernel.org/r/20251113014656.2605447-1-samuel.holland@sifive.com
> 
> In particular
> 
> https://lkml.kernel.org/r/20251113014656.2605447-7-samuel.holland@sifive.com
> 
> ?

Ahh this is very interesting - I wasn't aware of this new attempt! We could
benefit from this on arm64 too.

We have some experience and opinions about this; I'll reply to the patch with
some details...

But as for this patch, I don't see the value in changing just a few instances.
I'd prefer to see it converted systematically, taking into consideration all the
complexities.

Thanks,
Ryan


