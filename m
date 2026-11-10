Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B136606A335
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Um8HSqo0
Received: by kanga.kvack.org (Postfix)
	id 8CF306B05B5; Tue, 10 Nov 2026 17:29:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87FF56B05B6; Tue, 10 Nov 2026 17:29:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795E36B05B7; Tue, 10 Nov 2026 17:29:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AEC56B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:29:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ECF9DA7201
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:29:56 +0000 (UTC)
X-FDA: 85420653192.30.EA6CFFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4016440009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:29:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Um8HSqo0;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794349795;
	b=Ehm7vR7jsOe14gfW6jJzIV76uDWkdy/Hr/qIIMKHyJHnv3aRcWMSMcSHnVeqOIxsQQu0em
	9Bb2doAWeH9tfXTIDijixmiWcOFgIQJF7wa/QC448NvmsHe/mOwYXaiz5mTRdNxdjRkFov
	MkcnT7V31kVPeE6VbrmuYRjqd6Iuil4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Um8HSqo0;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794349795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VdROMlQmJbX1gHfrkVRtS1i5XA9kfJ95m7dZ9kFx1V0=;
	b=AiCvcBmA57aLHboYLnaf5SdeGETBCXv0qt4ONzmclEU8GB3qwKOLMlBJ/Mlawd25ejn2Qq
	EhJg3x6EQQleTCIqOQo98E7B3JYDzE533Bz22jeICSdit7SBJMhDSJMjM9pTq3aDMxCbXA
	2jsnGvKrzt+gxXRSxlH3AvOVVjlvu3I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6062E4348B;
	Tue, 10 Nov 2026 22:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47ECE1F008A3;
	Tue, 10 Nov 2026 22:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794349794;
	bh=VdROMlQmJbX1gHfrkVRtS1i5XA9kfJ95m7dZ9kFx1V0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Um8HSqo0e/qyCuooxYE3S43WlTBqf3p2D1B6gr/2AqyHtdbN7GKfEinvFb5SwtQF2
	 KZGCZ3JAJ/qcn2LFVxx74pcK6i6lu4ysfK5SuvAcsa87P4luukBbnRNg3AlyhYSsfj
	 Q+pjah8epaZ1ExXAITOmxKkuGphC30diBaBb8NfyWjwzVuURK5UYE2fz761TAqc6lc
	 nMt8czdCQ9gfxQFfr35doxmgpDUNRpSDD44szamLAsVAlJ1Y2ceGyUZStXgTUbwT3V
	 QZtnd0AbUw7hWhyetRJXLrf7Zrx+tOlbr/HfZ4QYfBeQ0JE8C7/oMMlaZ89Zl0SIJk
	 nxm1NwolMcXBQ==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mm/hugetlb: allow crashkernel to reuse hugetlb CMA
 memory
From: Mike Rapoport <rppt@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, baoquan.he@linux.dev, 
 rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
 ruirui.yang@linux.dev, corbet@lwn.net, skhan@linuxfoundation.org, 
 rdunlap@infradead.org, muchun.song@linux.dev, osalvador@suse.de, 
 david@kernel.org, jbohac@suse.cz, sourabhjain@linux.ibm.com, 
 ruanjinjie@huawei.com, leitao@debian.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com, 
 shakeel.butt@linux.dev, zaslonko@linux.ibm.com, brads@mainlining.org, 
 kernel-team@meta.com
In-Reply-To: <20261106165142.2847916-1-usama.arif@linux.dev>
References: <20261106165142.2847916-1-usama.arif@linux.dev>
Date: Wed, 11 Nov 2026 00:29:44 +0200
Message-Id: <179434978421.425130.1365679547411253774.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4016440009
X-Stat-Signature: otcrdjpjwxo8r4frnrsuoeozm43nmd4q
X-Rspam-User: 
X-HE-Tag: 1794349795-101428
X-HE-Meta: U2FsdGVkX1/K/jHSIPE498uEWKPltKN6BY4c2UhQ1JvIRHy0A2Ct9jr3mpPoWDqJWZBXolh7S7sVswG7IEO6xF6wq6/IN/aFFBpTbj6R776oIH4GPKH1wTjF01YzDN0RX1dEipkDlqZkXPkmUi9ZyeQqVsxMZctNdfKIsvz8owwRSj1UdNTvtG0yrAh2qt+7s9TcFi3EXKFY5l2AZNdvOMGk8DCtegdARyow864i38WxxIB4WY5fDg/cF9lD2zV8Ot1MamLgYih0S4G2uQTctIRK1dHkiLHm2EhKwYM0x0vuJ2MfD3ydYvlaqlBcADxoAEfhKTXuuyGTR/QaXGoIRQhnZTb6TvQ0vfNBu43+8ursY76hxJa4HlI4uGtgQq/Y/bummAb859RPL0SCoCrEusVfX+y7NK1A6uAcmEF5NDefw2v/2cFbg/Bf4EstoeszxOYdVmK/gZdPyv/lSZ5dh4ny9iecJBw4GW+NUxatGg+aTm0V0gxeCV1fnI4KzYWOCZrqUGdBIOmIN7RknqlWarQ8Ds5+iefl+7yFvvD4AJ0/nONsiwd6A/zBoTYsvxSNV3VtQdp/QbAHYqVSQ6ONLAvFUvTtTFF/f/PJYQhdZb41/MCxiQPxm71hLFLmDrTAlWd8NlChz1YRlO3mT8AdN505wxEr1qWmxCLZSM6u/3Lo2j6Qwv40AvrtB2E4Z7t0PSfdXKS30KwoEtNnJXbeQ+noPi244euGSCG7dMyE6TC2dPQdwDQZrzFIl2u/qNH68jvp35uDM+aLOuO24xzqx5jzSpNgzpUZ2uC3Z2hxmw881iY5nwXLKyiV8bw3z5MeTn6g94x56mPWsSBuOFHnU7aFdQC31Jvr3BjyxMWzWs3rjkBDUog1OrQWPETfR+wcbilfis9biQy1wah5tVCG25mlyDLdASyBgJKWaiBK7tuD0Ag+367MM0cnAyMIdeqOnBQdLdIZiBoKGhapAnh
 Eq6qdYNW
 kGcXcwi1aieouMhbnobQfXWriH5fvOOnJsP8s9RMhISeU9pqEeEbCMw8MqSbWnBwV8EuEl19Dd2cfo6yg//keCZsgWK65Q77e5ANcr/xY2vI2HbeuLp3o1oWypVPss9xwkDDPhg7zQWymny9iiThViIFoH8Xy/vghuaTOKuCQJtRzjZcIMGDgNkDBSqpDtEn7C+rBwJs5cbIhoR0By54HE8YEZFLNdSmvK8lc+SnLo6omB5jZhuJY+mjDyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 08:51:42 -0800, Usama Arif <usama.arif@linux.dev> wrote:
> crashkernel=size,cma reserves a separate CMA pool. On systems that
> already reserve several gigabytes with hugetlb_cma= (which is common in
> the Meta fleet), the crash kernel cannot use that existing memory as
> part of its working set. With hugetlb_cma=6G, requesting another 2G
> with crashkernel=2G,cma brings the total CMA reservation to 8G, none of
> which can serve unmovable kernel allocations.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


