Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6739C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59D26B0098; Thu, 30 Jul 2026 10:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A346B0099; Thu, 30 Jul 2026 10:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7F56B009E; Thu, 30 Jul 2026 10:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD426B0098
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:02:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CBA2A09DD
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:02:02 +0000 (UTC)
X-FDA: 85045606884.07.CBF99FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3070818001D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:02:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrwqsTj6;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWmtaLFdmiykJamcY8i4UABM60ooHpSbHhELBVfrJio=;
	b=1F6fyr+fGEs06dwTgSXLu14VVhkqMG28om8xWyMnL+Zszk9ePzN7jLf+xMFOxxY9CcEJvi
	HX7PI/8H4toqROrp6PiNPdu84c12NdmX8OK2SaBEiP2zADuvbVpuCDdmTl9QekySAzRUQZ
	mM+wdV3Et1Xudg4u/HV1R9Nt2P5b++8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785420120;
	b=y23aeE6xfjfsVqnc+e3RcqSLMuYJNQdBq0Fs7f65akakcADBI/lh+F0ffqYSASScBgenEl
	mB0crbkAwX90fLbP3bH7U6cNtQgDJnwCckmC2nKEmuye+4NYKDOtMcrMBZE46dQwlaBcjE
	KnvBxr5z+etRr4uDemrzbYXq69MjzVs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrwqsTj6;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D7DD40A4A;
	Thu, 30 Jul 2026 14:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6233C1F00A3A;
	Thu, 30 Jul 2026 14:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785420119;
	bh=aWmtaLFdmiykJamcY8i4UABM60ooHpSbHhELBVfrJio=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hrwqsTj6FxHQlXLVomxkWY2rpkcXY1CEhrOv5ZElV5+yQP3CXhoawsesrnZPO27In
	 n6zIWfSmbxhn+UZsMzvOdP6+TUk9rP1YTcw0T+DxcpEpoPYy+vziK8OJnbRPEkW5Iq
	 912j+xbLurg9kp7Y1S1hEyJlSBO4MHAGVsfuE9vZ3eJOmbQywvkpzhP8RZMy0bmf4Y
	 dkAnEtpKFwEv/uVEiTFhniqte+eF+idjXQwnLrn+pa2u8oPx0zZFiHtWfkyGvoM7sF
	 uulxi9AybWaA/U4ZPN2ZYyKftUaDH0MWRqZpzBTULJurrjMTQfUGmo6mZaIdVaLWpy
	 Ya1AN/t09VSKg==
Message-ID: <53afc7d5-0494-49e0-b053-5f7b55a44fed@kernel.org>
Date: Thu, 30 Jul 2026 16:01:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: replace mutex_lock/mutex_unlock usage
 with guard macro
To: jakov novak <jakovnovak30@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kernel-mentees@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "\\ Liam R . Howlett \\" <liam@infradead.org>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260728204636.20998-2-jakovnovak30@gmail.com>
 <b78f734a-440d-4fad-bba8-df77894c5aa0@kernel.org>
 <CAPUiDP1POYKJQ=Gfm-irzUmGaSNfZm+qO0xGP7Z=FO8a=R-6Kw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAPUiDP1POYKJQ=Gfm-irzUmGaSNfZm+qO0xGP7Z=FO8a=R-6Kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3070818001D
X-Stat-Signature: 4j6qcfs1rqftmp8p46kzfqqxrpxgiscf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785420120-844874
X-HE-Meta: U2FsdGVkX1/V7ZLpu40n7kr4RxW0IgQ8p0+OGvbaf59fFsZM/y8cYtsaf13vKOilKbjL2YUx8LHfDOFNeMyZahWyFMTaltxVv/bRjNoV/SPraH7mY1QG39Wi9twxUDNDwJjH5aT87bbBCp495qtn0dsc/3L94I1/PEjsP2AJnOqIWSrNvd0qK5D6VlTpW7UZypu3hBuRg19teVRFdqLmuKgAoTBUrtF2atxfPaYE5kI/4YPjgAWo7HnXfRUtl2bbSPYocrspDgZXQVCKwJnqZ/dMnzc687XMOaC2NBivBSBOjzSfPiG4z6MZ6LxsyXC5MyyG+pgZSXL+frGfNoY9FieU7C8AOuZ0uzNagoXYLnUh9L4og+glQhBag5edJcFtS3Hmlgiai+YQ7lkJ+br2UabTXr0tgjBPgzFocxh6m7tmgds/gzvfar5K8lUaJUdDqjx1np0kbhMiuHeS5KrDGds7xWKTYszyh+gNFbEiYq5jUY8HD2d0H6pCw6zKENwrvXPpE97jchZPOnoiX0cTa/0ujPFL03Zj2gY41ybNYxC34aRGfKPvLxzxqlcat2hcrtpZPFjofGswoSgJNBqMDeiRH7dBPNBxSsSfS8qZfnEa3IbK7YCfYQrKQY7Xe+FvxiE8RVmBUcoIyN3czyKWKBd28JQOEkmy0Hc9FaavNc0jOL8dGnwVNwyhsPuyg77EASQMfB06bvVUYrj+/AFY8w1hdH2vS9vj4rE2d4sGw5wX+0C9og6fkRWBHG9rpnPdkj0rI5i5Qs1fKo9hwBwlqPkjphznn9mddDSIiKXzl/BlbHJmZw5EEZy2BaWzrlJhQAhyldQvG2ZckPFl6YreftA6Jic/ufRA+3bqh1MPOmHXneSAjCFDMicRbrM79vUULtNycijJLvcgtu4tSSZe15TJ/P+/u+P9fncsFD7jh/FtepG+fBNHtJWGZ5lADV/frNHDA3q1ezhGBCUJoAf
 Ql25PUKK
 51nMyN4wWz5FwFUf2zSpVvp74eAdTNre4AKniEhuwzTDAMVGCbcBUU5KcPbYqwkBqTFXomf05xzS7kbLtr7zwGGTO2YlJHOzeJjtHlFynvP5/K5et4f1g/u+Li3lO9SEF+8xZzV49u994MuzuaHGxBRCTXGYdlPphGWzrlcBJlRtwhjwGTN9IIEJHzawpWxb2Yk/+40U7TJoibaagqQA1NIhCOx1XpV1p7IMNKA60Y6/HjrjhajMagAGjZpf54RNgKZoKIFZXDIGjsoCacFSDfVaUNuSeDL8IwwzLnvAk9YKDb8akd9/hzPFQK1gW9w1npP9REeFuVky1PKk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 13:56, jakov novak wrote:
> I guess the error checking could be moved inside the if
> (!khugepaged_thread) block like:
> 
> if (!khugepaged_thread) {
>   struct task_struct *new_thread = kthread_run...
> 
>   if (IS_ERR(new_thread)) {
>     pr_err...
>     return PTR_ERR(new_thread);
>   }
> 
>   khugepaged_thread = new_thread;
> }
> 
> I can send a v3 with these changes if this looks good to everybody.
>

Yes, please so so.

-- 
Cheers,

David

