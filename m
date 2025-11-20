Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F00E3CF8575
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E93E6B007B; Thu, 20 Nov 2025 04:24:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0F06B0089; Thu, 20 Nov 2025 04:24:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D69A6B008C; Thu, 20 Nov 2025 04:24:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 068EA6B007B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:24:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B01D413BB4C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:24:42 +0000 (UTC)
X-FDA: 84130450404.20.F15716D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E496EC0009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:24:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KWbw+OUy;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MexTHsODPsFaneP6axrOnEPrzTnipF93xhJ0bFbDIz8=;
	b=Otf1ETrIJZO/UDAs6C89i2uOSmDsaDG9p05jHVKuaxBu/RjH8hieo21gwlflilo+U76Ks1
	XwutSuZVGCaNAL4eaS/QD67pmuanOSJxqLa7+9Z3R3LPK4NqG5kEZtanT0wMJfLb6SFA7G
	K37m3yAM0nDXFoCOYt9l2y2XTaezBbU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KWbw+OUy;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630681; a=rsa-sha256;
	cv=none;
	b=E1xqYu2UkbZ9QbcTsD0xLcO55bAm52MSasWGviTz2ld5sX66BL3UmatojeVz6+nughC72Z
	+7f6O41RhDS+lEnc6J/BGxobMlumD3OYsDCPUhlziW97023X9PFPjivC9PPVYFmkbeSzxw
	fI28d8wD11foGQ0wKU6wp0Lck8Aucvg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5DA4416B3;
	Thu, 20 Nov 2025 09:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5A8C4CEF1;
	Thu, 20 Nov 2025 09:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630679;
	bh=yMpM6nvcM1itHRSp8tmlbz1cYUJ/Loqws7g5zCaxfzQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KWbw+OUy0Wv5wFZ6Y8BGC1yDMPrd1YgLC8xh53gmso8bTjGeqsB4zWE+kJUflx3UE
	 ViUBcBqTk/fhkjBp216aqkVvOgzV4GQYWxE/rABw44iVPQVzV8a5q7EOHTRja2YB9X
	 yaA6ul6O0ng8UAgA+ERWORkBsfp3c8Rdd9RYRTsZ2IQtAmijeV1W2QajdmJicONMGT
	 LU4LyeqPE+H5oHQ7tN0AR6sCKJDSes2RlmSaAXwvF/ZbB9l/CnIsnBMrYDbSNYS0/W
	 Nf2N7hOFKS5mEuRlmO1bGEM4xzpwmv+stVvqMwILPri2deacRUMvObwIZBMjkdeG99
	 hiy2SdVL5mvbA==
Message-ID: <21c6ef2d-6836-47cf-9529-6838a940d06f@kernel.org>
Date: Thu, 20 Nov 2025 10:24:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: fix NULL pointer deference when
 splitting folio
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr
Cc: linux-mm@kvack.org, stable@vger.kernel.org
References: <20251119235302.24773-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251119235302.24773-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E496EC0009
X-Stat-Signature: fk6rxnnncxd68rukstidsgnnczdwra4c
X-Rspam-User: 
X-HE-Tag: 1763630680-379558
X-HE-Meta: U2FsdGVkX19f3lRMsPD2OIZMta3FU6Dystu6SDAViIV9C0jg1wluHyoc+SKoFa3jNFPOEakY7CqckBvfqMxyzithfaKfyfV6oqmQsCbdQn+kjcwM4N9/QwP+zLbQC9gs0LJ5SQxIqeUuWpINBsGFDTVm2YblRxjc84OQBNTiDmpD+VbDds0WIets5ipk/gn9ZjFVxXE4cATYBKI2ezPCjrsR3NkXJgYZUzvesEeTkpE7+8CjHlCcYN/NhUilNxEFlsiVwb/ZanaCES6IgjEK3SUsTDuJD5+G+gotiz7B7WjEDTcKSPzDXLxD8ZP9timO0LxiAK/egglBhDpP1MI4w/dEdL1a7ML/OU1oIGB6mU0DB8c25Ytq/kLfLpvvuj7Bct9ORqcYflwSOJP8miRuFPvQGRF6WYfK7zGsOY2a4DKcvEb0tcmXLejdsSOegbpH61GBK9zB8XJoKmoP0FrzyjQsOkRAHNdrx7KR3Kd2O2AvMW+vnWkvkmzGNBVjFRMgiURMVe8K4BUs2LuRgmmoHSaEw3RHQfc1feTLM4KNTSXrbDNMawmwHPSVFL4f9ny4HsfuWAwJW0q89KS03FEYXjj7IPS7CigVyHc31qJHNGcdtS/0QriOv4cQuo+GzDD8ya1WxXutTsY7Tr9AZsdnvVvCX+5py2CfnWh6ufBFtKx1vA73ZkXqVC6RcneVLLZ2QxOR3i5iSyc/wqQ3GSS1kJg5XeSXXrMkbrM1SJv1GNncYM8GwkeFSLYDBdrYAxThdz2gF6FI/GG9F1TS+prE48nubefA0QoUnC0DFQAw5CKbKkvaFmTcByXECvqxTibl+fJrlIjLRSIjv0B4IKvPnjy5ckGMGm7NAD6FCvc1YCkqwxWjKvuu/DxcwD9ey9W13aZbB7NoACovYv9xrY5ioXEBHlzOs9j8c23umfa/EI64Ec2660Y5KrrTavqlBsTQD5ufdIZSWFCcfNgSGqY
 8Pi66Ee3
 WlMEpPlhSY7firUKjvRntj9kqJzGZKiqc47XsTMGBTt7SyPLTa5PmoArVlnAEPadUCoCKM5wKaX99MNdEW1iWk4F1BmXmpOqvBjGh3EkgPAEKZDNekLZmQqE5eK7ZDW0LFbKSCPym9Zvo5nBRqFn3K7/VbD/NsldZ93rP2XsozGcpCx2jlwepsY8ooXl6jtF9/8Mqlc62Ll1gvZZ/8+APCQFh/YkMojAI9TbFYXvwIkwiWwqXHUn+6xurBygQQ5GoLIi57dRypHB8jxj+FCxMZ3zNZjKQfZYdzP4aRv55YpCD5CnvuiPNXX5bN/40EXXV+U9tvPiAMmmbzYr9s/e9PRbCn7fQ8zfAZr9ZskZZ8PbpGQKxR5HJWGXSWGuDp/HYhrVSGEtEDcmvEPs+6CD6YP5lIGHf1sTF1KIVb5WbkW4VXdzIOn4nzxw0b6kmNr/JU+FFt/xyZbHGX7ST2P+iwEm4fOXGgYaIkQdHjn+aPBugXIh+oIAYaCM41Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 00:53, Wei Yang wrote:
> Commit c010d47f107f ("mm: thp: split huge page to any lower order
> pages") introduced an early check on the folio's order via
> mapping->flags before proceeding with the split work.
> 
> This check introduced a bug: for shmem folios in the swap cache and
> truncated folios, the mapping pointer can be NULL. Accessing
> mapping->flags in this state leads directly to a NULL pointer
> dereference.
> 
> This commit fixes the issue by moving the check for mapping != NULL
> before any attempt to access mapping->flags.
> 
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Cc: <stable@vger.kernel.org>

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

