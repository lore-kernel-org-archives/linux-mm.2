Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 617CCC5DF87
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1A76B0737; Tue, 18 Aug 2026 13:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A19F6B0738; Tue, 18 Aug 2026 13:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569946B0739; Tue, 18 Aug 2026 13:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D81F6B0737
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:26:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A28021401D0
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:26:06 +0000 (UTC)
X-FDA: 85115068332.28.C19057B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D6B7920002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:26:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hd4zZqYl;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787073965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVsmR2M21o1vKJ3cy/12UmIutLddLn3TpoYg5BwFDD0=;
	b=Sna8a/TEFrNI947R0ncSgxvVqiYqhkcr99e7r6OUtcLAuP3sO+vITYLeDPtzfJ4KuWfioB
	Xkzxjt5LODpgT/4cbli+kZMGxCcEcbtEaH70zhwMIF7h5lpzcgsXedwi30c40NtF6OlDiu
	HyWvMKeV8sRoiQ0zqmf7vz2M85vhX+M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hd4zZqYl;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787073965;
	b=fRlsNap4qY2i9X/3IFq5PHDAwO8tlODE62rktIHqMxdUO1LRcHrSHCAsEJmwEIujLmJAVW
	WHhzKBggGWgv/rNxC1yi9lln4OMZRzLID2n81Q0yUVasxuV3FdGT32T7MaeDJKF3DwQxmW
	QkBmh8lgVgfDf5PDBCp/Vpwl1M/We1U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DD6D403C9;
	Tue, 18 Aug 2026 17:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EAE1F000E9;
	Tue, 18 Aug 2026 17:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787073964;
	bh=bVsmR2M21o1vKJ3cy/12UmIutLddLn3TpoYg5BwFDD0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Hd4zZqYlsGKEx/jhtQpqKkSx9RTUboWG40nyZZJHu3aMW61Z87euXiGJSy0ADtjyR
	 m66jdF1q+357id1bqIreIhbEdpZ/sgMPUxHsRL5upT0UyFGrvM6HyCS9SVpJA4TU+d
	 gassLD90Xeh6KMJaO1fqTs+OebEDB8HnsqsPPn/z3u5gxAPalXv3a4gb1hT5xHadHh
	 fdg8S8VR8ZQvXv6NBUwwaSAUrE12u/ZJCbhBwd6+Psh5v0mgM7k+65hSQgJg6UjjKK
	 hdN0pPR0VYT1k9eqEIiOxYwmelrWgOV0PAZslwiEj/BEKTam2bKJR5YLAScDZA3fpC
	 RmKBXcclg5XyA==
Message-ID: <1de1adf1-84a6-4247-98c1-406686233d3f@kernel.org>
Date: Tue, 18 Aug 2026 19:25:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 3/8] loongarch/mm: Stop using pte_ERROR()
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
 <20260818040041.1891769-4-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818040041.1891769-4-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D6B7920002
X-Stat-Signature: e5fqsq4bunmcjux7rqdtuscm59bi4ezg
X-Rspam-User: 
X-HE-Tag: 1787073964-836239
X-HE-Meta: U2FsdGVkX18vuLELZwf+9lbw0nSJJnkT1szf/1dD0gg2zwlS/t8aU5TOGUhuYLr16DfCdXoitr8ZT9BfzRYdGV6gytDfbQrEV8CjKY3o8iqNLSHbZv1E/swr8sOpdjAXIM/ekcHE/+37c4cqk1A7DuuT2IaI9w4AxEvwlL0P0de38EmXzgJJgnj50X9Wa5M1zBEbpyRSuAaNxbtojvfHkde03dhUCs7PhbMSTjrhYA1vVK4UFjdwt2mqikt8fxN2PQalFn3QNlXPV5REsz+aPFrdBNcrtR/HPmKLnFpYVxPK9EX3B4mSCnTIKH8P+8Pz1mFLc10Rpscwh/kXE5L6je3tbHuxOjxVMgAbzBY9cYuzguO7SRktfDi0fYEArwMK81+8csilgLX0FSyGKbMWSfK9cBAqJ/759m7i45Owwq4h/GPKMJMsATuuqwT44sAQobabsXLixD+k6sA8c67qHIhlMOn6+jsAvoTh3nD+TEPJm72bRR23se86yY7He/VE3LANW8EPaf5I7LquVvHampkyC5fl1kpiHBPkmFcX7D+Eg7mn0k2F0evf0sLdweUf2u4jVhxZR1KqhS8Ae2C4dDZAGUa8jb6yoq5qFW3k6ErcTskhhlxtTn7bP+kbZYLdFg1O/tz+Ba2Ca7UDfsgqFaBRqPRp6rQSft97T9mAR9SyV3tEjuLNpDiF9N1Q8URFRbf3V2eK7ixMQxoSqiQwue+mon6JFP1QidBt1jMilzkZggJDNncZYRnd/MVjpAQ/5NZNTZzrtsrm0PqggdYQqem5QOybfAWC9yDTFZljrHyPda9Lds+GEgIyv0uwyVLs5tCsndFe8xqv77rlIbjE5VZqJ/SyqNGbIenMQqfKEMRUe66fZDLuflqmZIvfcvglWk/AHDNy3wSUVbJg+5n+cbttJLapXfQqmGiLMtuFH39Mt3rG2HwLiozzwD0kDB68NAY9D+vZsauu8F656Z9
 LFEzMvyU
 ahEHrGWz10dG0pynDhqWwrKsS8YnGGJ+UjlcPsG/ZykI8S96H3fv9ErR/FeMmZODe2c1pykL5aE0eIKofmo/WeFGaC2tXm2mVenfPeJGL5NKqCJzf6wSVgeaf5ZDwatDB3s8HpCwbipK1XCPXMx5Gy8d/U5wf1tOIgOlH8ktgHBhBOkgCfDihGanHvdG4zQ1qPjY8cTGrDoRNTAnblE6yQq74jV1YMIMRPmuQLmD/3DFvcKBH4A8pzGNp2EbE6SwY0GzuC3t+BdsdHEIO1AnUuxXWpGqz7zCpQtq1bQ3PJt1yf6lHXefDd4tIUSRIDovJ6LBRY7iyk9RKgqD3xdvpGDeCqZhbQJXUKfmDSlAVBtXp+RU8vu3LPvthzAoD5T0WeOs7AgICuKj+5+ackgu3QJu94hwoaqz06atymN7X0SkSPt4XXhpxgrqwGFDbVe18JzTEIvU9K7VqKmNX3cj9qoBLJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 06:00, Anshuman Khandual wrote:
> Directly use pr_err() in __set_fixmap() and drop pte_ERROR() which helps in
> eventually dropping pte_ERROR() macro across the tree. In this new printing
> __FILE__ and __LINE__ has been dropped because they are always the same and
> don't really add any value. The new ptval_to_str() helper is being used for
> converting pgtable entry value into a string. The error message itself has
> been cleaned up as well.
> 
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: loongarch@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

