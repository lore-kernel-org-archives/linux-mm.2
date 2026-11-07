Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E7AD606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 09:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RjxXIsm3
Received: by kanga.kvack.org (Postfix)
	id 4D3546B05B0; Sat,  7 Nov 2026 04:39:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484F06B05B1; Sat,  7 Nov 2026 04:39:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 373186B05B2; Sat,  7 Nov 2026 04:39:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 102B26B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:39:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0CC1C1C33F5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 09:39:40 +0000 (UTC)
X-FDA: 85407825720.02.E77AEC1
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 41A3020002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 09:39:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RjxXIsm3;
	spf=pass (imf13.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794044378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BhP7zGWAKdDhvoK/dqiwsbUC8TFOQvEskzC0SJWqEq8=;
	b=dCnRWGUfXbmhuIaE0l5ail4ZikZ981a7igIXuWZMpsAniag0h+Ek/WzwMyg/Evw8WQdgT1
	yGb0rJrXVHtVLk4pT5KaV9hw/B3tBJlc44XqqbjCtUB+lMzRDg9WGDMMpvRJjhuh1fbpG9
	w7zKtHVn3jnVrIlC2RyH6BvnM1pczA0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RjxXIsm3;
	spf=pass (imf13.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794044378;
	b=QbYl3RAAMXej/E+nQklRISpQ+FfZFt38ZFUGtHU4T2GQNM7qFqVoc4+p+eaDU+/uu6GAPK
	9Tf7apqEZI4o08LrsdxYXIOtVm5P9xY+PEwmU0eI/vFBBhSUb/nDxCfwIT9tguSeKWZg+L
	8Jxe4FNt6D+P6gIqRHSbmb+ukK5Sriw=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e98798cbddso6656755ad.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 01:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794044377; x=1794649177; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BhP7zGWAKdDhvoK/dqiwsbUC8TFOQvEskzC0SJWqEq8=;
        b=RjxXIsm36pGSMX3ZQUNgqcPkgZ1JBNPmRvVzZsIYXw19QdGL0FrOzV8VRGQMKtsqFy
         aaJA2xOxiFVC8GHaH9Xkz+AGoUX1+Z3//SEN8qxxLh0EG7fAyhFmUAMzBXrC/AaWmTnh
         +twVOIaqPJ1yK6Tej1KIDn41/yvOWuXqIzyI0gDe0qLmKltrIz5aZcLfEvyI6QcS2vL3
         tgeXqbUtTAO99A0OxPqb2x2XaybeSEH9e0ITeVIfoY9lVyKZdLdedzvedo4CL8j8GbdM
         sE2tUbbTRvowpZ7iEGoE+Th4nb1/SWJLsv1ASp4V+s/NDBGooPKcnnJ4smVowKuQN9tI
         ulWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794044377; x=1794649177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BhP7zGWAKdDhvoK/dqiwsbUC8TFOQvEskzC0SJWqEq8=;
        b=TxtP1mq+DYjYPov1r/nITzC1wvm5ZK7p7EAHUqAuLJ+RIthi49QyPWpB6aZ4nBaede
         Yn+wMOsJm7T7+r+U+PaUY547Lqxax5U80KMtxE377HZx5Md0kBf8jDf+wE6e1JAdh0UV
         PSaQHsawLYaOJGXklJ7v9t/0dQRto+VaoiYjPdOhxbniFAufn5RI6mvUQt6z6KnrBHNV
         ubwex3s77pRJg7Qz46NLGg+wR7/Me5oHHKatD1y45x5mwl6a67v2/qGAxo8TX5Hmm+5+
         bpPWnrJWCnRaMEMYDxFUFqrAjif23HTwyLXYmJeyt02lLwq902BHAYForztUfR59MtB7
         hXaA==
X-Gm-Message-State: APuU4Z/0IWwAdUJ+IP04cI4mKyvKIkwUV2WK7qWye25BrDjaAkp8ages
	z5walxFqKWfkfVtTL8BhcYN/BJimfQ2niXVrRWW6khpIBWefz2YlQaVl
X-Gm-Gg: AYBFou0uUR+YDsWwAQwBjMMsmUTYi3EyYWs7S7NBdjlucXRUlXBhyeZTlzG3q5MYkfq
	iFdW9rWlUUmsa+qIiojwBVkZQ0fMDl/eh/xUYSgg079ZTo8Dx7XuLrO+AQ3alXGQKZVUYwA9FEc
	b5e6a3bw4fDxh5mOF8FZkgZOQjNv3I2yeBMSivIY5a8KKdwrBJDO0a2k76xnn6CecZso3+H/rG6
	DPv/SLPXfZVbGeNTUluvQhcKHPchEq/sLNjP3Ev++41Bvx0CkBzrZl0R+KYwEu9Z9Gxa/z4orY1
	cw90CpjAkQ+0hwWo86czCupRxA/ZiUzjNBpf4qvyjqHH8CcE3h0Fh47zW2R1LHwbcejmamzL2NG
	NvlChzf/dGFYvtKo0s4IO3+d4xcC4oxRRCtb23SQy3RIHeDeGclMfjZXCpT8htKEoOw7HtixXEm
	q+mAU0Gn1mqaRzvfnVOmB+lHZoqQQ3Js80V3n67s+P4jeYcbeeabpTo3teGL9LIP7/okKHSqYlo
	pDHIoMbRhGqgxi5ZZl7cOhlcEXVgmMHgO9Ys+LszfzZF8hsxSB2ygxN0cxROwyDNbwOe/cwnE83
	7YkdzNz9CV0yg/Z/POELoKXtvdbwSVpoMsO3YL/rgPFhWOgz3/43ZT/y8Us8+zzzmyXm
X-Received: by 2002:a17:90b:3950:b0:3b0:92b2:2e74 with SMTP id 98e67ed59e1d1-3b0db6f6c35mr5119998a91.62.1794044376916;
        Sat, 07 Nov 2026 01:39:36 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1057b17f8sm2792987a91.1.2026.11.07.01.39.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 07 Nov 2026 01:39:36 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org
Subject: Re: [RFC PATCH v3 03/18] mm/swap: cleanup and document swap device availability flag usage
Date: Sat,  7 Nov 2026 17:38:35 +0800
Message-ID: <20261107093906.36492-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <sashiko-outbox-188132@kernel.org>
References: <cover.1793106426.git.lianux.mm@gmail.com>	<c3a660c13ec9a98af8a496b5f9139e73eab5aa3a.1793106426.git.lianux.mm@gmail.com>	<sashiko-outbox-188132@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zpdf3yp7rrsopyjymzjj6ho4rkhky3qb
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 41A3020002
X-HE-Tag: 1794044378-786273
X-HE-Meta: U2FsdGVkX19tFgNu56W4ik2k1OoVEDYT35ggnlnw2i8V4mLGWb0vlTOt6lk6rW987y4spxtoqmevLZnrFTh4YvoIuqVagX2Lwt3ApG7wOPkOvQ4dX/PoQvVyM4n7p8EqvmbqXGCEc1SJq1zWcYxCAOHLB9AezcsWDYCcD0TOyckncDLiZkeCK+QXqPzSp8sGdK9GtcORxhvuFjlpJyQZWipc7crweAL3DX3h4S6nbn4tcAvinhog73OdEO4mAIQtNmSVPhVEFoIG9/FLKg9Y1fkCxu1H8CuVWbB51eLwlsljtS6mpjb2b5jvJBFhtAIZQq30Dtm2OPiIPCQZQ6ebcVq96EQ6I5M0iZhcUzjX+qXXhihl9Ao8xJaR29Buzi2+7unT4rLngLvyGGjAq3fveIBVeYc7etjITV6jnDphk/RL61PeCs7lVBHdSlzGADLwQgmRVS+1VMKnGcKAcgJsFP7QJwhIdPJUY+qEhi8iQnvYZ2o3J8U0FHAvxD0nRmQ9ogrsXM5mybKS1zuiV4y7MQ39q4wj+c8X/MlUtak0gfw9ku328gNdc5oefHssUso2cmqHp94k5yHf7AnY5kbhRoylAFnayyaDP8QsZq5zmN3Z3jvTJW8xVAOMBfegVxEUYZmhe4VKXkbOB5Gdfime1fUYUPM/LFeIs+tZyc7uXuDQ/gUPG5qrNKsuUTIPaYhtAhVRjlhPMYAfGMppzq2g4iuVIc0FvA60DbmfAvMSSGCxydBlqkdRHw/4COUL7Td/H/qIct/dukc9Z6etrc49B0NLtHj6gVdbDoJg7ikUpFZLM04J0eBrE1paAjI9O90GxnkHCMYGBH+d5LD96FMIr67dE8VuSsHhHqGBIcxCFsCPxzAYgcgFIn2oJC0T5kd+QSqotvJm64dwx2++Qa+Be7Mcw5XAjlpPTcjYgIsA/7Jxk7N4V+zJW+CQUrTO2lqta5PYH37SnUeBmxyJvTo
 y9pNdj+I
 43tEvA/F8bTgkNJ/YIKk+onwByhBvV31wnUV7+SYoY+W4/szFNxzjPS0jYGyFKL9F5RW7zklt7Qn0tY0jMI4cLA5QXlILx1kXPWM4VCr0/XIMExnJ7+3+eoUXBcQpX8kk+xwz36QaPDbv2NM2Sx9zWsTpwQcZItMhmUcSx5BfVzl3u3wJEg1T7ePmzL/zFF9wUnv46IWEfoxwnz67DF2NvUzEvNSMdCN7ifuLYW35XG53gF9Fr4obf5EZJ42zNshPoaY+HEpAkNK1G8b3rVZuxxWi7iGVcnGcKcNPTKKdIKXn9RSaJHmNgmKT/mSJnuCwu0p0OFCFLYfi4IlcJEkt20UviKA1knWvtq2/PTbvFLbmbmckUpOIR46jnxtec13pkSfYFVzRkuYlxHFQ1McKc4JrleqAYZBrVan3tOUK/Om27Se7gxKdSytqr3/fcmSKPiL1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 16:14:54 +0000 sashiko-bot@kernel.org wrote:

> Can splitting the clearing of SWP_WRITEOK from del_from_avail_list(si, true)
> cause an infinite loop in alloc_swap_scan_list() and corrupt the cluster
> lists?

Separating these state transitions does open a selection window. I have
not found evidence of list-pointer corruption.

In the next revision, clearing SWP_WRITEOK, setting the off-list bit and
removing the device from the available list will again happen in one
swap_avail_lock critical section, before dropping swap_lock.

At this point in the series, allocators do not take the topology lock.
Moving two separately locked operations under that lock would therefore
not be sufficient.

When SWP_WRITEOK is clear, an order-0 allocation scanning a partially
occupied higher-order fragment cluster with scan_all=true can make no
progress. The cluster lock is released on each iteration, but the cluster
can keep returning to the same list.

An allocator that selected the device before disable can encounter the
same underlying scan problem on the base tree. I have prepared a separate
fix: stop before isolating the next cluster when SWP_WRITEOK is clear,
leaving the current iteration's normal cleanup intact.

I checked the scan helper in an isolated x86-64 KUnit guest. On v3, the
disabled higher-order-fragment case did not complete; the stall stack
included alloc_swap_scan_cluster(), and the host stopped the guest after
45 seconds. On the revised tree, that case and both enabled-scan controls
completed successfully.

This tests the scan path directly, not the concurrent swapoff selection
window through syscalls. The publication boundary is checked separately
in the code and through the intermediate commits.

Thanks for the report. I will include the availability-boundary correction
in the next revision and keep the base scan fix separate.

Lian

