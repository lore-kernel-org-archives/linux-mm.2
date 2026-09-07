Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA9EC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8736B009B; Mon,  7 Sep 2026 12:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B01E6B009D; Mon,  7 Sep 2026 12:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6146B009E; Mon,  7 Sep 2026 12:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 691D56B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:16:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDF52120153
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:16:08 +0000 (UTC)
X-FDA: 85187468016.22.E1D1DAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 21BC540004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:16:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgkI3ujS;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788797767;
	b=ItYAzKuxqu6fvbMFfb7ZjaFUdzOeb5wiWPHpBSVmDcohH1GL87YBwAE3Nio5sd510IMlfo
	3L8xaDWpstvNFR4wXuqniDO7chZ9wJn+qEsW97cqIboF+WYLsAH/YV8hsBXZfPBcpslNd2
	BkIK/6myl4otla/ry/gy4qWSDvVuOHY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgkI3ujS;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788797767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5gCMZVvjY3jhzdUCpCDafX4/mtwLtsEY0ulBAQJCZU=;
	b=MGH+CwrE/orTnZZfU/5bIVveBp0TXwYBR9rrCqFpaUoPR6V5JLI0To/UhHCSfe/uWr+BiT
	tJbDBlN2laC3Mk1RWGWttPxqqWjXLKYMta3ga7Xi+JkxaA5MWGb1Wg5wrHAJaheRaPFrzE
	CBrNV1bFh+z1RYTWm9YuG1DOYrLsYJU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3D3A60A96;
	Mon,  7 Sep 2026 16:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABB71F00A3D;
	Mon,  7 Sep 2026 16:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788797766;
	bh=g5gCMZVvjY3jhzdUCpCDafX4/mtwLtsEY0ulBAQJCZU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HgkI3ujS3x61Lys7IBDcKfnZgKKBvTApLki3mnSwXUmxqfz6CqjPvU1NQA6j82btv
	 jMRP4VMJsfJwymk9nw3sWRpYbGIaHBOfkKvzZJIc7sOziuCS7LcFHK8+rZqb23OWO3
	 WAyGllgUmjqFdSeWhdczaxfLv9CG0THqg8tDFq02+x3Lw4+99hqsAgzHK88YG5e5zx
	 ZKGegeB1Jnyoix9YBlP04m9MjBd7Bk7Ky9A8o0MfbeaISnujnO3NpQ4uHQyoUPgTpX
	 LoNfZt5Dx0XstG+CTE7ANmCMDtDJ1JMu48yAG3FWCI2m87j3FZO455jgs80AaoPdJk
	 6D+HSQhT0EltQ==
Message-ID: <47652536-6f87-4ade-9866-67a20da8772d@kernel.org>
Date: Mon, 7 Sep 2026 18:15:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/18] mm: arm64: Add kernel replication feature
To: Nikita Panov <panov.nikita@huawei.com>, cl@gentwo.org
Cc: akpm@linux-foundation.org, artem.kuzin@huawei.com,
 catalin.marinas@arm.com, liam@infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux@armlinux.org.uk, ljs@kernel.org,
 mark.rutland@arm.com, mhocko@suse.com, rppt@kernel.org, surenb@google.com,
 vbabka@kernel.org, wangkefeng.wang@huawei.com, will@kernel.org,
 yang.shi@os.amperecomputing.com
References: <f47c0ab3-6d78-fcdc-b7c0-cd3a7b5c8276@gentwo.org>
 <20260829111953.893466-1-panov.nikita@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260829111953.893466-1-panov.nikita@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 21BC540004
X-Stat-Signature: gqyqj7kekej3cg7dsx4h1dw1g4ijoba7
X-Rspam-User: 
X-HE-Tag: 1788797766-191417
X-HE-Meta: U2FsdGVkX1+FV7grLPX1QcF8zZ40v8dnWluh3rwmwe8Dz6gRaeSCfJuJbVynAsOtcZcT+cdHIgjn9ROunyVyerP+yi2HSQVU4B3ZBHUXRIrrBweAVAl12hYPuCYa5EMov44uDDSo/XrNtCGsvB0XtBg3bFA4aAxiy0iUxOexTMAF9VfieNq1y8U0DqMr6lKKzbRZ+VL+bf1Qto87+e3+d2kA81mUnzNSamqnkREMr5eAwCSmFjquLIK2ivy/U53ZRdmfrpM6sPJeHG9QoQJHRvPc0Nm3KasPeGnaVPa1RuA0viFk9Dsu7QzeNvpkNGgVDpgSxiaaV8J7iMjQHqZqk8do4LnXjE1yIM1OZsv21Zs9AKkV52vbi/BRmjrN+fKeWWibNn2EFnqeafAlzI0n6AWKtlTZYDXn6f7enZla6d+YELdqKlgFauo0tOXxEacCV+BAlXFtHuEG/4ek+CXhFo9djhkym4uJHtfVmujhXJitLEo2F2TGPatxCR14UzfIt0glwkuUjr0thKroHNNQQPpwXUf/0cniPU4IGFgWR9XlZ7Imgif+7xo3DIKDx5A8HjNsm7p3EArfpSpE1/lxsRXmckcI7e5mYEfbg3bOLU0PiGEoRyjzCrPn2bnoeEU9hfNrmw6eD+18VPUKPmUbC4IP1FHTKQUSZcEAbJZDP/4nTnNYxO44Zzdh/mp+02a7I2WGUtwcAffFIzAKaHZ6tDtSJtUx2Os6x21Oqt1qU76/unZJCWISO0B+TsRsSYsvFScfAI+nOygesE14D/t6+O6h2KfZ78ysj5ptm6GajhtWgVtlTjhbSwc4GizVBMMk+TDHKRC+MMZpXsfTX2BiCDkDBgN/v5Eeoukysxbe/X1ceRozFEk5mspRLSHQAplWErOZXYTIRwQsTChLRwAgPzvtbmYANlhrrIDwHCN8UmOFlF9rbB/7PXjtKNfqadOnHkoWKOE6cmpKkUJ1N8m
 7h7jjnr8
 3HfC1N9uLIo7KuL6Z/h6fC+h10mNzbZJ8qWNbO7MFlcv7K08d5E8vlS5FzO8FeTds6zeS3l/R2GtaIxm+w6MuE2yr6z3GKhcv6yR0yicZZyw8bJpQs9SbRzDevx+avYgCxk/8QLGK/S4GMTlXwbY1RYnkZkpGzgNnwvK/G4dp81AMoHv1Rb9VH4jHj3Sp8Y7r3ZovjYMC37B1v7O3HqlsExpkyr98Wj5RsJRyo1Dk3VOe862+XY6BFFaYz0qf5cp8Jj78pmgUTf1JhHNnEYA1sjELZkvnYx53pl0F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> For me, it looks like the kernel text and rodata replication could be
> adapted on top of the "Optimize this_cpu_*" patch set.
> Problems with pgd synchronizations are the same and should be fixed as well.
> Since vmalloc code is used for percpu memory allocations, module replication
> might be supported, the only thing that should be taken into account -
> data locality.
> Consider all of this, we can focus on preparing the new patch series, on top of
> the Yang Shi's patches and share it. If that path is ok, we will start.

I would wait for feedback from arm64 maintainers before moving forward with this
plan.

-- 
Cheers,

David

