Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E895C5DF88
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89FD56B0739; Tue, 18 Aug 2026 13:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850BA6B073A; Tue, 18 Aug 2026 13:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718A86B073B; Tue, 18 Aug 2026 13:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 45D866B0739
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:26:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD2DBA011A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:26:43 +0000 (UTC)
X-FDA: 85115069886.26.F659B9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1744A20004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:26:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VkTka9sB;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787074002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnEdMRtIz89oIwbynNL9OjJWy1tOvB6Av/Ys5ptNXPk=;
	b=sOUKE/lrFSa9uPoyXqXTjJWuragJJpB3GAJtEmDWSUnJtxFugCx7Y+gCLHm24ZESgVunfO
	1BYZqbvteM1xbsmaQ2UDM6CrfTglQfG1dxKIuR1eU7nSkGLD26gPlKSx+NDE6vGijlZyMv
	rbRESWehQ4/Yqz281L9MpFt7DwLAYrU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VkTka9sB;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787074002;
	b=AMQOPyRRE97QHTj0mlMPnvUPCAMSZ6zW+UXOMSiKefF9S3eHK/54KvEUXHdvfd3EpcrjLT
	xcjlKCUVFc7p7DHX84wp2DBTHJvA6axt3sJOaOaVkJ5dtSN52jSBjQxNYPjokBnVx4ZdPm
	zPHY5H+SAijLXp7QaZ8PizCzwe2MSII=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BC3743687;
	Tue, 18 Aug 2026 17:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62471F000E9;
	Tue, 18 Aug 2026 17:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787074001;
	bh=rnEdMRtIz89oIwbynNL9OjJWy1tOvB6Av/Ys5ptNXPk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VkTka9sBrgxZBjvuWUfpq/xlYMQqt4vpe7baWUl2zn2trNJ8rpzrhrpwL6vtjm3qW
	 wbBqpaxiu9lVfp57KyMZOJ7kiRQV+cpJAlq/k/zDZfJLSvyZUzi/0CTmFciWw53seW
	 vhjcZ7sV12pjEumpOcvCJzxXwMSMqf/WGil9kIw7Tu+AxtV8233UXYJIJiJB2/EHVb
	 WniMIdls6pU17tb/SWmZ8ViqAqCUJqJ72muZNyGzWteYnFUePKPv7MWye28Hnrbr6t
	 XqELe+93riD5Sw2O3gRt+a1tqkyKyasmmoOMQSHfaI6RV28GMzsXnPLYB2jq1hl07U
	 mMfTEguOfeKeg==
Message-ID: <12829f76-f577-4305-abe6-319405bf8dc6@kernel.org>
Date: Tue, 18 Aug 2026 19:26:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 5/8] sh/mm: Stop using pte_ERROR()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
 <20260818040041.1891769-6-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818040041.1891769-6-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1744A20004
X-Stat-Signature: 3pnribirqbi8ebzj9nnsowwq7pjegkqh
X-Rspam-User: 
X-HE-Tag: 1787074001-692881
X-HE-Meta: U2FsdGVkX19nejA81rHSkV8JfYevdWjux1up39dNoUahxAN8vGmg8QK2LHIWRoweRbTe6T0A5RVluss5IHe1tBOI7OVtcytY3FItoO/B6k3oW4BrDj/kbxXvaHiRYw/pmZQOjp8tE+XwgIOVEflbtzE7kXpQGC66eam7e+bqhqa0x15HZEPSE8v1gZIBBfRj/ABlw8HM69aWKDVO8PydkLP7ME+uRlC6a9yHorRZX7BWdUDEA1GHK6OvWRLkImG32xo4zANS+aF5uVagh7T+Tu5B43duEs9FfyiGuhCNqRYx68DHCan1S3rn1n7m8OazdZTFGs2Xw4r5ZE+yWqw07ea2N4YqHIotHvRGBIRCGtiRb6JydaH8xT3gOpDG5OmizsQ03NgIDcUGvOmQOwq9gZ1hv2gZyE0FfAhAamNq5qvmM6zIAPwJJbkPSgSsC14uyno1//yA0+RMMlIRcJNJKzESr/f4C+HSgIYvFyEk5K0leTl+/YBaRtaWT0lsJtQ8/xztCfn1YZ8U5DpowNQB5OsKmSe8oFe4qVbWAh4f6OZPfyVD7kEMRAZ2QSD4OhlnikB9QhnwPobivWdHGWEellAq22jTGPhRRjYp6QRclOde9OCEIhk1eL68Qvh+QagYbE31tBMTKDnCj+iDbgovpAUTVbggJttMtyX1LZvS1wBd8QRSw9kLjKM6lNAFJyi2bFZEcCS3xe0QOSg8iLvdvqPYwWCNtM7bGn/xBumOjchcYRXzDjZICyLf0GKW74VoUpXP59WehdfeGeJSl7S8XkKxax1ugm96eAsoCsa8sNK5nIicdnuwgp0BQuj9KTIFtVmaNFUwsIQnmtur6tGMSr0OBKi7r0jSxU27B0Zanp1lpDZ6BZFgU00J4Tp/AaOxg/Q8OvzT0//PPt59tG1rRAvVwbaqRFVCoZwyebGg52Y7vskhgFlGVMG3+scg+e7oRIwasRsua2U0sgIVvZC
 /sX+Y+rR
 oN9qWwmq8dH4KisBcBB8eQB+l/X64CMbFxrCpzGUvgI/8XkD1tJYDehjM+k/U4F7fFAs++1eUwXnxM89Bu3iChPAzaIOeHdWnbej0G/8JHqw3BfrBIAtbYuQicZcwVwiuL+44i8sZZqDGnK+9YngTIRlc/wucEeYXtJN9pB0yO7ROQ8fbdb3oDw/L9PplLoAchjPtvM4LpJvFktlVICQh53lyEULxyuxZO3XL7tO1MTfUWEcXhKXS8iXWAz3aNJ6rIVREYkPYmXc4rooGVXrjB1t5jFDHuwiR65cMsisc4d38HJJVRZNWGDUhEJApu/xMI78wI98AyfS8PLMUN2qn70w0RvouDfaIe0HF2otuAzIvBcKvCsMDIbrDtmzdZDKTbqgeu0PfUjHO6wKzoPRQ6cTfIFFh7lR9fhj28zBCzta35cX9ZmD3affu6INeuojvDsoOBcjVyZu8ioEYPaFGg1oJwD8bAPCrrleBbD73L+wPn+Ga7wbLaOYUtOXKKJa0C8H9ULvRPoKI36NVPSwrMpx1Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 06:00, Anshuman Khandual wrote:
> Directly use pr_err() in set_pte_phys() and drop pte_ERROR() which helps in
> eventually dropping pte_ERROR() macro across the tree. In this new printing
> __FILE__ and __LINE__ has been dropped because they are always the same and
> don't really add any value. Besides ptrval_to_str() has been able to handle
> different PTE representation with and without CONFIG_X2TLB, which helped in
> unifying error message printing.
> 
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Rich Felker <dalias@libc.org>
> Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

