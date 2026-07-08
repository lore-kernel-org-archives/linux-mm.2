Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 560B3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BCD96B0092; Wed,  8 Jul 2026 03:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493AB6B0096; Wed,  8 Jul 2026 03:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383A36B00A0; Wed,  8 Jul 2026 03:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11BA36B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:51:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8ED001C3D02
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:51:01 +0000 (UTC)
X-FDA: 84964838322.07.811A7B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A2404140009
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:50:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m/dsYTHV";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783497059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1XQkZo2eR7ZM42tf1xDfDsvue3fQhs/RXMdTrjh2OM=;
	b=Ee/PuZXbgk17pPAFUsCiqD6+P2A1YoBYSW6O7RwB8s9ss7ZC5/7EhNPABSa80sJDwT69/z
	OmN2N7v2willJdAIUqYIsMropVp3Z13hnmmb5seD1HNL0AnSFp2CkiECpUhaR56qQxCLUy
	fDB6MdCKBhJ2CjovNIiuB3LoipsaC3c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="m/dsYTHV";
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783497059;
	b=pnLQDIjnbTvrV+32qBRiYjECcmHeCifV6T6CgCY0qQrum5oe/fc+vF4nAAha3cIQHVfzE8
	0BR4arIpXppBHgQbH5f4Qmkb0/HaVIcXPuxHLrIdd1bQktpm7lte8qZj8lR/gHOAC6LIZR
	ABWKUPp1mBpJanjmSSSn01jzaun78Gs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCE4141B23;
	Wed,  8 Jul 2026 07:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3F11F00A3D;
	Wed,  8 Jul 2026 07:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783497058;
	bh=b1XQkZo2eR7ZM42tf1xDfDsvue3fQhs/RXMdTrjh2OM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m/dsYTHVHuIvELsx8PPNfFFI5J7f0fJ5q48N89vKvt1BK7Lwil/6XCJJUw61F/WL3
	 u8dXmp4kqrkNDUyVgGMxCzeQpv01gqoOVZrQXkcorNJl7HrwfWWQoYXD74ycQtuwU5
	 ZYeLImtZ4oLH8ZYhrdFwQsL7mKe3rPsNKVsMF/+xC0ikE1uxE1aDW1LF/6gLMroriM
	 QM0PDcfDNkgNLVMyn/If/6RtfZ2mvuL/5rcO11s3CgZmgvpIKuUTLxNieCS9vE1qp/
	 XIEoxCL/QIRSDgYLRNIPq7NT7RVh4ZMzmhzCq4M7jieE5xKxm8DsZGCvyEOVRluDN8
	 tMJAaOTiXq4bA==
Message-ID: <79ab5b36-c9a3-4af4-b9ba-7fa883cc5323@kernel.org>
Date: Wed, 8 Jul 2026 09:50:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/ksm: Initialize the addr only once in
 collect_procs_ksm
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <202607081219094603lvrfl0HWd-31cAGrp79l@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <202607081219094603lvrfl0HWd-31cAGrp79l@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2404140009
X-Stat-Signature: 38izajatewrqz9z5r85guay6h5kmbsr7
X-HE-Tag: 1783497059-348230
X-HE-Meta: U2FsdGVkX19JQfwsBxWrwcjQ6HDFUWqZ7GcJQDeWks55gVAGFDBevf/X+b1/cjHWzzQ6c8O2CSW8R4nE6trmgC+kqlPymRn8G5cJwX4fFsUwR9S6A/C7qOv+qCtZu9tRVrHCZGh5PGuG+0i8VkitA67+p2z1cGQ0Ue3970WttYL1BsSRxs1JbdRbIVuOuNuLlG1HnyS79+MaUBl/zosXLyIrGO4o4Prok+gKyGhZER66QHmhOo8iqbPw2vButfbjBR/ULsgSENrL0oQfnLVFKXp3PlF4cXgH0YN/PtpoaK8ScAE4ueAILXIUI+fRZSsuxESSCASXG/5KXu6BzBtR6HdTVJKJv9BTOY1YucORmLf94Iqv1Fm4s92sjE8uijn/4+NzIVmbf/hx46noGpmZrcnxH6kIrW9o40p3gp42/kEA5gdGgv2Df8IwiQd2GGcgixN3xZJaORuoFvj9oJi0r97ayjMHO3sfZbB7xvyokwP4wE4Pq+nko2SNE5yhYgUCXIQsOMb/qk6wA0/yaMHgdFIM92Dhx7cwWlAnShTX3XrlOWsHdjmd+6GPpEKJYZBq0oWXIWiY371N78DVuGRLpXJVk/nNJNJqpKmmNZTTJVhXlmy9hdfAqDxuqQ4f6lzFUDC2u+opQEuwkYDiIeuBGej3qUXeXcSBd+267i2M3lecukNS91fJmcF3RElIxRy3ZBR2WrEBxoNjI9AmQDEvDPQ7AwgBBs34w3SioqTbzLii7nzW5pPyzD3f2FydFXyoPALtwureZV5iNeaGOt1C4vC8FhkCOPCTLJOH1f2yi2mdZPKgcECh9a1JVdMzzfSEXa/tRDfbV24QeJaiKEbewszKkvpAR+LUZrlS72uveKdB3BGlPvSm7s85Hw14xnhS2ANaJhAw8Qxod9CbLgvFSawKspgB742yUdIotxl47K87uHeTytLdPo5fE3EKcy0lrZ3tJCgX4MhveD+O9nb
 E3AmbZb8
 yFox9/Dix3sDBchb2dYxdkA32eR8VK6JF/v+52bA5yPA2Bhe4cubpFG2AYP8kVAofmy9cpyvL7ZJ5QKWlOzoDyG7twwbifUudqMCxpmXC29Fj+lGxFWtRhGr4ukmvKfAMsIQNPcKSwW3RlVa2vGb9LPN5iKnbzzuiX3rBFwSh9dhGCAbse0aznW6LqeC5mgPrUo3d2A9TwZFPaqt/Dh559Z3Tb3j0q1amterLJ2QLhDJGGHIxAh+REc2Bm3+bfiZBYEEMRFadydM0+m6Eme9aFk/aMmqhK53h2LR/oznkschTYgBwbdaB0l8i2qsKrPjRcsC6zUIag87TqpO/YGegQGW0A041Mk0FTaoRE5CVcV/H3ATaQdiJoJ8cI5IRqB0J9gfF8O6LHh4MCYo3hSA2858FnCt4ph+9+xQPlAUQlARmEhQHukP5Ndwp1TKIo9kRQTVu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 06:19, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Similar with 318d87b8fa7 ("ksm: initialize the addr only once in rmap_walk_ksm"),
> Only initialize the addr only once in rmap_walk_ksm because the addr variable
> doesn't change across iterations.
> 
> Signed-off-by: Xu Xin <xu.xin16@zte.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

