Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277B2606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 16:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=Y8nqlMG6
Received: by kanga.kvack.org (Postfix)
	id 33DF86B05B0; Sat, 24 Oct 2026 12:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C91E6B05B1; Sat, 24 Oct 2026 12:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191036B05B2; Sat, 24 Oct 2026 12:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB57F6B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 12:01:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 868AD1204AE
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 16:01:04 +0000 (UTC)
X-FDA: 85357983648.07.4668061
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1992240008
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 16:01:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Y8nqlMG6;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792857662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSkKqqPrcRVk3BVNulEaeACxkD/BbD3EQ9kOWBnKbIk=;
	b=3EcdkSTb8TPzx4JopbqZqBQnxWl6f2lIYEr8Nnjz1mhokONaTC5q3KQQEoGtGgU7VjXEdx
	fkRUTx8PpspsJ48Dluz7AaGVUmxCVinCSgktRL6yaNasWV4aybJ7F6NkOGbfJhJ4G3FztS
	ldtyTQU5BQOV/AKJ813y7O8CM/cNBQc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Y8nqlMG6;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792857662;
	b=4AI3PFOozbmdBIc+gxYO81k/ewNs8i9DRoS2K9Qyvs/EcyvekENvtTkRdI8fIYbnHZ1iA8
	6YTBordiRVc+FMeHuOper4Q1HBXlmJTPNcXWTH9MDD6SAlhBDJqPI+IPiBM87hH/HHVVqW
	Q7BWSvxeov1ndecBxI4IO6sYzutT/Y0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792857657; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=vSkKqqPrcRVk3BVNulEaeACxkD/BbD3EQ9kOWBnKbIk=;
 b=Y8nqlMG6xNk4CE50/o38uj+s9sIqVf8QCKM01PwMWpWmoxt9f3f48NdTZ8IhCJaMhNe0yI
 Degyuq0fWnZ+aqXwVdYnczcV/8uG34ZMqBkG7uLfASajhr2bQEvwkS9XRyp0Crpnnki6fq
 zXYlmXEDd9+zSfLSQ7X36bf3kBOk1CNP6agH4tIF0NPwBslNf1wpC22S2ySwuHDBmv7NTv
 KCkkEWXtHtomxwyFrZonIdeTUH2gVaD7AMmrED3Jl+Pn1Yoe397kVdoFYXfRTSEy96L4o+
 k2/SRf5q5nIew3oI1ciQp3CGUYNJ9AYgrx0JLQK5XWc1KYZq+IT/BBtaffFS5Q==
To: "David Hildenbrand (Arm)" <david@kernel.org>, <catalin.marinas@arm.com>, 
	<will@kernel.org>, "Ryan Roberts" <Ryan.Roberts@arm.com>
Cc: <dev.jain@arm.com>, <baolin.wang@linux.alibaba.com>, 
	<lance.yang@linux.dev>, <mark.rutland@arm.com>, 
	<akpm@linux-foundation.org>, <ljs@kernel.org>, <liam@infradead.org>, 
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>, 
	<mhocko@suse.com>, <linux-arm-kernel@lists.infradead.org>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid PTEs
Message-Id: <3b57c214-6a43-4fc7-a531-fb5eac196465@bytedance.com>
User-Agent: Mozilla Thunderbird
References: <20261013093600.54995-1-zhaogongyi@bytedance.com> <daab2f45-56c2-48ad-a24f-aa4f889e4da2@kernel.org> <e0f60526-bb95-4d39-9a7a-72cdf32ca5b6@bytedance.com> <cc2e3af6-bb56-41b1-9cde-151797c3068d@kernel.org>
Date: Sun, 25 Oct 2026 00:00:33 +0800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: <cc2e3af6-bb56-41b1-9cde-151797c3068d@kernel.org>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
X-Lms-Return-Path: <lba+26adcd637+161380+kvack.org+zhaogongyi@bytedance.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1992240008
X-Stat-Signature: 5np4oz9ynafty8c5x9fe5sjn44axe8kt
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792857661-55632
X-HE-Meta: U2FsdGVkX1/nJ+SMPlPXo6u9GuJKYOERWSEwNdiNejdr2yo4lAgVJEBKwvE0IxrX8Ew/Jhh5HK5Q+Cao6TGNi1DHgzQXwulXsGGooJQJH4ssyVwb7/TfvZzjDdDoqEIdsZq3z3EVwUjH/Dp3Q1mH5An7tn48qe84vb23EVrR0k+Kbe1xEsUMf9djJukeFPH+V9L22oDXsf5iXufyrErBLEhfZnNyimxrWEt7U/FbsPZIzBstYq/GB0G6jjNnWQJEYRqirpNC81S84SVTHk3FVG98sDkQYpMifu4eKc947MZuRiAEnH7hkD90NpI1rcwFGfpk2cC+dXyussmKi4OIIy1lEpS+6+QBe65UgGxxKqcK8yzpcNyh5YdGGeu0xmH6Qydbi1ri7F7R8Gq65KUHJqLDbDP2xOTYJffjPUDix8NMTuc82vadpsZKKvxqaZSOx/12qwcdu9xonbjBPym3xsmqvStWfb5URhq9IjsReuFpI6Y94s5yX7sTWgy0Jx0kXmbEd0qktxxLvJ1/IySTs2Jx5neELcEu1pQ/Vck0hLiP2PburHvEJ123/R2VgzzbaRbdOg+cfIbtk4O4O71n+ij1gTRjNCrmMZNhEOymu0lR90NOkjs9fX2z5t7bNi5Y3FyauN4AJUjdGGvEf+7b2LeU9ArxKkJD7QxjXk6cUV9fCo8NG63ukYgPr73R2EBnYJhx1XmHrkjrbRIPM4M1B1tCDpLZvVqUTQqdK0zZRwoRPY1QTN7RsJEtTBmoYZsvZzYLXm1OlCYSo3GKzIflKfjSb9OM9MaGDm93+mDaf+k2aQDnkqh4shXsuCbu0Nx0EbaRrVAl7WOQc3Fy+pxsfaSV2OzdiTnCYbCMfvK5De0pTS+VOAESSp6t75qXfvbcMbPO+xiJ9Aapie0thkRh0ETks+VD7TQxVGhFJ4KaLtpxTQu9xC+hDse9HaP8GDHcXmS2Y+/PIkVsSPYWy/a
 uvFCEaU5
 XhuOKtbjUW2CFCdDstIQve00tBrylLzbQfJ/OC+jSepXLJgde0OoGzOZYSFR+My/IlgRh92Qmtt2RgBoClhvnEtuYUyLdTPWN4Gyb7wNwdfq5gHXqm4sTgmcCjF+NX6bQjgAba6RVp7YGQW5t5BXHvKwEz5vI4dA6VBY4crqiZfXOstBmYetnmrf8k1zD+xtLxGRrh/nd6ki+jq/fjHMhLxIalF40+OCkk+ZSnufbMARwkBToQrQEaAW6fOF8KVBDNz5pCmDkqUp/E7kCfELAFhg5iuuzAWjCCPmaRnIEQSEMG6PcZat8rblNC8rW8rJVHPsP4CpbfO49+6tHawghK40Ivx/zT8Wi4c79
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/24/26 4:55 AM, David Hildenbrand (Arm) wrote:
> 
> Hi,
> 
> sorry for the late reply.
> 
> If we have the spare PTE bit, why shouldn't we just use it?
> 
> It will make batching over PTEs faster. And we care about that for present PTEs.
> 
> So I don't quite see why the stable fix couldn't just do it right away? Do you
> have a prototype that shows that it would require significant code changes?
> 

Hi David,

I tried a small prototype that keeps PTE_CONT on present-invalid PTEs.
It leaves contpte_set_ptes() unchanged and makes contpte_try_unfold()
recognize pte_present(pte) && pte_cont(pte), instead of checking only
pte_valid_cont(pte).

With this change, the guard-marker reproducer passed 100 iterations
in an arm64 QEMU/KVM guest running a KASAN-enabled kernel. The fork
and PMD-split probes passed five runs each, with no warnings or KASAN
reports. In the earlier A/B test, the unmodified kernel failed on the
first guard-marker iteration.

The prototype makes the reported reproducer pass with a small change
while retaining PTE_CONT. I therefore cannot point to evidence that
fixing this failure requires significant code changes.

Thanks,
Gongyi

