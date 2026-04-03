Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B7E0E88D71
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 22:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98256B0088; Fri,  3 Apr 2026 18:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48726B0089; Fri,  3 Apr 2026 18:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E8A6B008A; Fri,  3 Apr 2026 18:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 807206B0088
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:44:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EC875872E
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 22:44:01 +0000 (UTC)
X-FDA: 84618723882.27.D474598
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3832B1A0004
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 22:43:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lndq+JiA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775256239; a=rsa-sha256;
	cv=none;
	b=4M1X9la4A1NRdRFWdQ/14KGF4a0EDvLZVHr+XRH8yO6JmqnUSA/0Tay2myHCJzXUzh2zmE
	pVgEEAaRgkC87ZDSBbw8bfNybwAD0kfSza4XdhDapITlB41xumCwGNCFxw+HBVBGRbxwCY
	vZkR4JH2ujuo314zRjmQEPpj6SV8iHw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lndq+JiA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775256239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qx35t0u8V1hnom+zlOwAVqq7ZAPZSMLv0LXttTfbXbQ=;
	b=ZkfQLd7eyaAN2h7u/TLcJnOUrzbHnUlR8o8orBYes4TXRhBMGOMnJc1YXvPUxTClrGz6N4
	AvpysN6XoVrxgWFCnNUQWN0hBB0xCy11Aj6RRZiRqKEsUtj72rmOnCngJqxsfDi4dcw3yW
	lNmjX0uN0YP0s3TWo/h9r+1cLBD1img=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 39214418E9
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 22:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE7FC19424
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 22:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775256238;
	bh=qx35t0u8V1hnom+zlOwAVqq7ZAPZSMLv0LXttTfbXbQ=;
	h=From:Date:Subject:To:Cc:From;
	b=Lndq+JiAdy7abggD2muXH4SfgGmE2V5G7d1zzYnGBVta65EK5Bpo0GdgfQRNNqY5F
	 zmSqq7DpEsS3I3psOJoEnAFhZ8QfJXbpBHqh2Vr+iJekiqXaYTkdUe8TYyEu36day5
	 ip3hpJTxE0s6TdIhYDZUi+X0+mZ73IWvA/FwM09weYpzTW7dg93Jx6m28X+1xXOW3d
	 hlwsD+29TAz4Kstj0OOSl9MYcvTaV2qUMNLONaG+14J5rAPLxOey0wsh2bHPWHIhML
	 qW5B9ba8b6M+M7Vg44KqLIoDdoyjGFaaVcnfLNJEXsjrXurF4FkdhHK2qoo0jJiLPb
	 pqp1D50lLeqXQ==
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6501e465a8eso2625594d50.1
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 15:43:58 -0700 (PDT)
X-Gm-Message-State: AOJu0YypfCMJw5gekmPj9OQW+WiJmCeyPFp1oE13GKcN8G6yu0YZPfYP
	OeYnVlRexjRyH1YM1SMQ/952P3NsGqtpjbzVrldZA+uiejitBfX1vP5NpgOx8Vy0TcCiZczVDil
	xTDikD9qCuEAU8/eANJfWMFrTnkiawAkoGJpINYhg0Q==
X-Received: by 2002:a05:690e:140c:b0:650:3482:26b0 with SMTP id
 956f58d0204a3-650481341bamr3513661d50.34.1775256237373; Fri, 03 Apr 2026
 15:43:57 -0700 (PDT)
MIME-Version: 1.0
From: Chris Li <chrisl@kernel.org>
Date: Fri, 3 Apr 2026 15:43:46 -0700
X-Gmail-Original-Message-ID: <CACePvbXr0qLHReF5AgjZjf1NgHV5Y3GX7uugEFevnc_9ZdXCug@mail.gmail.com>
X-Gm-Features: AQROBzDtW4MDeLvpZV22upWhVjF6pe_UFOQaL5IkZgUvln-InJBIDSAFdav9zUE
Message-ID: <CACePvbXr0qLHReF5AgjZjf1NgHV5Y3GX7uugEFevnc_9ZdXCug@mail.gmail.com>
Subject: [LSF/MM/BPF TOPIC] Policy Groups: Decoupling Behavioral Policy from
 Resource Containment
To: lsf-pc@lists.linux-foundation.org
Cc: linux-mm <linux-mm@kvack.org>, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@suse.com>, YoungJun Park <youngjun.park@lge.com>, Kairui Song <ryncsn@gmail.com>, 
	Barry Song <21cnbao@gmail.com>, Baoquan He <bhe@redhat.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: go5tw4zadjzsd4oszpufqmihu7mbxr75
X-Rspamd-Queue-Id: 3832B1A0004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775256239-565302
X-HE-Meta: U2FsdGVkX19tEIIGbS35lEks178QQdYs919bA2i5IfKilYQnWMpZhhpBV/PoNofkgy3HVZ73OcGD9vva4q4dtBVrZESrrtVc8oEVhMPhl29fD7f8BiUsz6YEnbrTNA3UfbVZpKZ36nJy1cFY/vY44LQDqPcheVxdLzHKUhKXw1tKjBmIIHEuaw72f9t1ck3yQM/HrPtwtVqI4inggtcbZgIp0zL+Nc12Q4pRvNR5bZsdrbAYtErGn8yzkSX+UhTE8N/lrepbTpRvvxBb+BBupiUQ7tJlGuWyjr1DWVZ1v8EeulzGuwLcHdMuV0KXyQdRKnEpBptBw4eZuBeFzJnW4Uh5lugiIBkHZvKc1X0q44ocWGmamfpnkL8ek5/i798DMFxjzx1jYYWqfFBqARbOgO9KtaisDzCETeVfBR48R9KsJVwPZqpk1VNfFbBlzf0U+viKXf+7YisBxqEcCuYXRSsDwcs8QX0/qOaCLx0ZFc9M7BHGcr0Crgsdcu3DrvkY63NEP4tL61ojrVa5exLvTA6STtblVeqQ+XXRmKOLaQD4j15bcVyNWMrsfJKLphuJYzbJrmXL9NPZcQZUBAKRkG7aKmjILPUMF9F6kqvsAadjcGl/If4dXOOD8yfULcpYedJPsF3rqbIyf4b5hnw4iT/ilBpAIZhP6yyJpo9uj+aNCjrAr0B5AFo3+GZYb6DPlc/xv8+dSH+C5rH39eXg5lvO7ulsIUHdRRfRIQR6i/X6fMkKDyL3G+dbv5ddBPf33N+akg/fjzxHbbKQZyrVfVAcq2gp+8D8+BWcMI8XJUgcylwv0ffHba51cfsrOCQIAH14GOTSK+76D4Fqa/Hw/2eSYBGR8StBASk+/FkzK93ZUZmsmtVVpg7Y7nQ1peTIB9DsLlIQ3XMGuXRne7GJOIX3A1j1kn4C0GZFgYWo5x6fBbFgsakrSgyqKyLumaAA2bIjBbZdBqG74z9hJ1c
 NQBVTsfr
 5wvYEBbu9SCDmY0zDaCVap+/pY5QgEtKbCRnpivqqC9nENnlSniW6PahEiIX4IpTAcxoOKuz9PH5Jtx+4g2aCFQX8s+o2DGVEWenO3zI+IMisJfJl4xPiu7jlRKG8yQy+Jv7vhdTqpCx/zyMPl0o0mH+qhgENE/+slggSn4XySNNTlpyQP3V5Ocdi76nFpcpaOwrGARphbZ/1goG8fIaXs3eV0RrAH7JIkeTboFmGSl1ykQCxd3r6gzeBmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduction

The current cgroup (control group) infrastructure in the Linux kernel
is designed primarily for managing and isolating system resources. It
utilizes a hierarchical structure to express containment
relationships, where a parent cgroup's limits must always be greater
than or equal to those of its children. While this model is effective
for partitioning CPU, memory, and I/O bandwidth, it imposes
significant limitations when managing behavioral policies that are not
strictly related to resource constraints.

Problem
The "containing relationship" of the cgroup hierarchy is not ideal for
policy decisions. For example, in the context of selecting swap
backends for a job, a system might need to select a swap device based
on speed requirements. Latency-sensitive jobs may require high-speed
swap-in capabilities, while other jobs may not.

If a child group needs to utilize a swap device that is not present or
configured in its parent, it violates the typical cgroup resource
containment principle. Hierarchical resource management requires
parent resource parent >= child resource, but policy decisions often
do not follow this additive logic.

Another example is that in phone usage case, we can have different
behavioral policies for apps running in the foreground versus the
background app. Those are not necessary resource limit constraints.

Proposal: Policy Groups
I propose the introduction of Policy Groups, a mechanism conceptually
distinct from cgroups. Policy Groups would focus on managing
behavioral policies rather than resource limitations and would not be
bound by the hierarchical containment rules of cgroups.

Key features of the proposal include:

* Decoupled Governance: Policy Groups can serve policy management
needs better than the resource-centric cgroup model.
* Flexible Grouping: In many cases, Policy Groups could mirror
existing cgroup process sets to simplify synchronization. In this
mode, they act as a separate namespace for controlling
non-resource-related policies.
* Independent Views: Ideally, Policy Groups should allow for a
different view of process sets that does not necessarily match the
existing cgroup hierarchy.
* Simplified Hierarchy: A single-level (flat) structure may be
sufficient for many policy management tasks, removing the need for
complex hierarchical overhead.
Discussion:
I would like to discuss the following at LSF/MM/BPF:

1) Use Cases: Beyond swap backend selection, what other kernel
behaviors are better managed as policies than as resource constraints?
2) Interaction with cgroups: How can we implement Policy Groups to
allow for both "mirrored" and "independent" process sets?
3) Hierarchy vs. Flat: Is a flat namespace sufficient for policy
management, or is there a valid case for policy inheritance?
4) Minimizing Overhead: How can policy-specific metadata be allocated
with minimal memory impact?

Chris

