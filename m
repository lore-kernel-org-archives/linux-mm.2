Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC45ACA601F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEFA36B008C; Fri,  9 Oct 2026 14:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6716B0092; Fri,  9 Oct 2026 14:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B042A6B0095; Fri,  9 Oct 2026 14:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 85B796B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:02:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FEC8120487
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:02:13 +0000 (UTC)
X-FDA: 85303856946.22.250A3D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3890340011
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:02:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mQdv6piH;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791568931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDWkmzd5nGEabTYsK9qXPAue2kHd6b5xJpST40Nb+MY=;
	b=Q58UYeiEdZMO5Ur9lMa8Gmbxj33Sx25D5FkPWN6CnryK9RPWlMLKyMAZk+/QCk60ulkdMn
	3A9HsX2KlyXqfbs3k5DpuE854Vm1tGeIO++CoL+fSa3rPQrI6enEAwPt+k/dgUvnpu0Fy3
	id02JH80q65qt+lcNCiUwamgd/sNSDc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mQdv6piH;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791568931;
	b=iYwdqB2k0LkHJmWzHhseMw0R6b3tnLfDEvaWwTJcLc8UCD1AU/bJToDKuKdyNk2Zi9xWOH
	4Tj2462v4TFotLfvlD8xYKdba+qE5URza+OJ2tcnLoiTL1Ymqgbscw5HoPR3kpc/hEGRu7
	3vPsZb87olS/OY53wOQ4nBGBWwCdLRs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C45416020C;
	Fri,  9 Oct 2026 18:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7861F000FF;
	Fri,  9 Oct 2026 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791568930;
	bh=wDWkmzd5nGEabTYsK9qXPAue2kHd6b5xJpST40Nb+MY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mQdv6piHpP+kD36q4PZDoaT/P1azfp3irtTHkLwfATddsmdYCprwSoojI5BWHhu1S
	 bboeZ1nqGo3t2hHH9LvlgkeLrP0Wko/sKNjCj6rZpn73RlQsry7sRLOQ5ATj518Ti5
	 5G27ok2ROt/CuVLuPxe7/UcV7MRtjG42+zDH2FCJiShojX1InDH/ICe72/qw4jizkg
	 oZ497fJ4AiXalCamiRWSZAzJOe5PSKuVUD5DP6ryCbh4N0lC/zwVSPrZmiSATPT4Ue
	 LeUo0QmkIcGLDec3Vwv4TaLvVpR41Sncp5b65c9Y7suLfrJAcNph7tJ/8sA8xPpwsh
	 hLwpmu5n3CWDA==
Message-ID: <ec0072e0-0fba-41e2-948e-a89ae3bfde38@kernel.org>
Date: Fri, 9 Oct 2026 20:02:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/hugetlb: move hugetlb_sysfs_initialized into
 hugetlb_register_all_nodes()
To: Enze Li <lienze@kylinos.cn>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, enze.li@gmx.com
References: <20261009142010.552614-1-lienze@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009142010.552614-1-lienze@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3890340011
X-Rspam-User: 
X-Stat-Signature: gufksqa5qhnbwgseja4rtysabdfb3u6d
X-HE-Tag: 1791568931-300113
X-HE-Meta: U2FsdGVkX1+5YPo9EVqu1aj0/7+MWRb8VPQLjHUbTuyOT+zNF/7PuIWhlvOllZLebvHj1jjksLnrBYcUcoz/wbNBqVNyOBH8kaLoIoxsM7IhCb8aSrJiRRtlipWl6cwpwbNisqyJVMuKYNqgatgRfhjS+kcqLy/P+agahoBM2cYfb9Ib2gXO1eeRvpmByy/UVyIvNqMlggUmct0HKfZg4jUdUH8ctGQKb6nOpXv+2YgVdMFurEEt5vLkDejy0gCLmUjV8X4q6TXOVMNRBdonA4sdmB2Om3Foiqtlms/rnQVCUSENciVrofDrYt1ES7htOTDzWIYcRCIR09264S1+9K2r2ZcZJzJirYKsxB9gUgZHnkS57DmqM4zx5PfiBkfHW7Wg4V6KEvRmZugcg8zijFJaS/Ji6Cx8TcdPCXcE3iKqkGfVc98EOh9fQ5F8mP6Vo2d8h5Au7svXRpRPfnHXoWyTmQUOVVPjOTSejjdpAiFCeWwFT7l0CxqdhV9F9MfavCzDs5VicfyYIuUmeAmlMKv7CZKEOf/w2fDXX8GDw0KKsjJx/hEaV/aKZOJaY20AZrzH5YCxFQjk5W8xusMFnS+huNcZPQ6PbIs+q3sg1FHXST7NSwH3ptUoykgp3+D+VlrbbcdrZbfjKqcCBOGQ1ykywc4poXU2JotyyzRX9RvBLKRYI/yFMlk0VxbCx2iSQvsX6QzEWGTf1FP0dvteMRZM49TEFCQgMQuhSQqYfSXJnE+RDofnUVxJtikanQB9F3oAi/r9vo2sVcRbvCA+17S+f1CatN5JnDhDdzYq1rEJWwJ9dQq8D1dEBS8e9pKJeLNmfESXhn0Fa4V3m4ZbHmGnnyquyJCPVEJQPigICVyFFm88aWjWjVDiXBlb3Nx29usSiRdWha3T6mjhK8df4O9wF5yzdx9wZMkC+p/IfSZ7FP/h1C/fpnxWsFXtgzuOCzGjxrZP71TwgrwIOAq
 bVmv+YpP
 x1tLdIpRPqLJP06Hgu9CxX2HlmqK5t8VZG8oo/ZNY3rU0K4JGouV59JbsSTBlCZGPrmmZjrlYdmp1rlmhH7GU2vpVk1LJMC3b4J0W7Du+DGd/2aazBBDxi/cPqkj7GmbVsWh4mfQPX1KYrby9a+3cL5WkbunThA7mqH9orExC1XCu6RQvBUBsG4nCalYKWrZM/F/cwC1ylSZccckHqtgrfCoi4CJZQRA3usSPP7bvOcWEh2oRAdkB3aHjTZLxH4AEPaVz/wafs/k++8ZcsjnljKGtxGPGQLR5rUE1xA8q+gZzzkdjZgWHskiulb7DaWPhEouf15LombZ2DFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/26 16:20, Enze Li wrote:
> hugetlb_sysfs_init() guards the "hugetlb_sysfs_initialized = true"
> assignment with an #ifdef CONFIG_NUMA block, while the following
> hugetlb_register_all_nodes() call is left unguarded and relies on the empty
> !CONFIG_NUMA stub.
> 
> Move the assignment into the NUMA version of hugetlb_register_all_nodes(),
> before it registers the online nodes, so the #ifdef in hugetlb_sysfs_init()
> can go away.  Keep the !CONFIG_NUMA stub, so the call site is unconditional
> in both configurations.
> 
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

