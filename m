Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8CD4606A33B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EMtUFTzy
Received: by kanga.kvack.org (Postfix)
	id E8DA66B05B5; Mon,  9 Nov 2026 07:58:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E645C6B05B7; Mon,  9 Nov 2026 07:58:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA4326B05B8; Mon,  9 Nov 2026 07:58:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B90D46B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:58:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D856160404
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:58:25 +0000 (UTC)
X-FDA: 85415584170.28.4B74B94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 998DFC000E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:58:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMtUFTzy;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794229103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RSimsWPOZBXQbAeQ2f3HPd3mk4s0VSZIzKVvoSmcClw=;
	b=75mrLm85IoAOCjpiTIxE8yW5huWghu/4XfRkhx6T/hNt9bmLT4TmdjKOXDoyb2JEeADRiC
	s3NFV59faZNmqvoGyk9GQ7BkwbL706IHDNwVICCgEC+5rgCB8KH10QeW3qf5s9eyOlDvfW
	5+WWAA8IstojgEByNJlUVpFUi14ETtA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794229103;
	b=PYZQF8eU30rQJez3EKbQN5WsKaPY4euUtsvzm3c3VwA6OUt2K3ythhHkhFmgdZcqgCv7Uo
	bzKOFIqPREmbPFXUmbymgHAf8GuU4ZVRy3K5K51pu+7sX9onfJYst3GJ2/r9hQQdAPT2R4
	uhXVeYnOwmTbdk3ZCMcYWnrch4QJJ3M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EMtUFTzy;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4D2940D82;
	Mon,  9 Nov 2026 12:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1461F0089F;
	Mon,  9 Nov 2026 12:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794229102;
	bh=RSimsWPOZBXQbAeQ2f3HPd3mk4s0VSZIzKVvoSmcClw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=EMtUFTzy81jxztIjs5l1INafd4UnMB4yWLOg8JrycpGzUSStaJHu6NpG/XazaW8hc
	 So+q40a2nZpEBVrYZ85AVxAGpAwhLFqpM19BLQ4IIPIs8cXbjPdo5RbiB+658116Rh
	 4ym76jQ7shpSd23Ph0IdqIc6YBcCK3m1+o2KL2OOp91htCTm355FvbJ679kLo7D6sN
	 1iAT6xDyER9rJILLxMDSbhgKgRFFhQ4qfxoW7c0tmwN9I1CDa6tpfRTbb2/Ek50voR
	 5pkY4GJANQDkumkqek8KvteWvAaPzqEOFrJPRvlhqKqjE2lhkxfz12VlP85Qr2ZVOr
	 qISOioNIlumDg==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>, 
 Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
References: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
Subject: Re: [PATCH] mm/huge_memory: use folio_dup_file_rmap_pud() in
 copy_huge_pud()
Message-Id: <179422909975.6621.7905864498527659893.b4-ty@b4>
Date: Mon, 09 Nov 2026 13:58:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: jj83r1x59i5jnutdstgbfrr18qdd5u4x
X-Rspamd-Queue-Id: 998DFC000E
X-Rspam-User: 
X-HE-Tag: 1794229103-338863
X-HE-Meta: U2FsdGVkX187qJQdN3dJIt2EcIRkbpG0zuQybNXurqPdHQa4OW+Kguf0eAkelezOUJuakgTg97fahiULew55RkfqhL9chCS435dMATUQRi01xk7G4r6/fKgyOyiHuZyMwpjgr6zdyybsVbL7y7Q+V0m+KMd4qsgb4sjabqVcUO1ArC5yTOuyERy7w2EDFJCNx7dGOtWWi9zaNxQ4dLoIdxl0711+hckej/WrRbFKt4YfJ1DEhc09iSwqy/MgN8RF6CvgvVgMyO2ZMydqEQK9cPWcTt+nfqRQigp2NQ26pM8usWsu3FUtaDat6ewlD91RMKMGjttWpG745QWx1676347lL05Hk/KRXzF6BwKUyW965ud5Ae34rQQA7wZN965RwK941lqJ6UR9J1EWc6rAMwjBIJusSUzxeD8zJESI96oLkBEL9BCsnzJakq0+ujICiqbH29aS/1QIk2meD9I4QJdqJkj1Z++HXGQpUi+iJBdqOG8EA6KFMUyMrhUzWYYqJgA1OYY7FeHhFqF5kwOaEoWEVxd+tqhMae/RolKHVPl63Ci2Y3dgDismdj73pzC/7OZpYeJGbWVr3gYpzzytsJXVuOpg/yNJLVu7qeB5GptLkPTx4E8qbPQ7rlwxHmT3QcjPJFxEbe05SMTCClOoEUyJyd12NYG92B9v0rL9RUlIrtjabLpbJLnO8wKB3khLJ6rrHFnFtAW/fBw1N4TFjdbJYKSqjQKb1/57Tsuv8PJ++EGGkyy7Zkwjb+pk3r9ehZ4KdmSd/ZcDBfOFxASc6h4FwyHHVanFSyFMEq66hqaGxWJbLrIcp/6oon9Z5dMJNgmJ8f2xH5MUX3JPJnS6u9v7q67ERfcw4/42D3fdOXIOq9PpoYHqm3Ah6m82Bak2xn6SIkhkJyzMCWuplClcGU17SDj1bceG63G9Qu5FBWQqLPmrjGkjSoN8KKdkrxGWkhxq9sLLm8XI6FizSy8
 M+vGpx2n
 /Zl3UjziWMUHQdCu+CXEwOgS6wYfnbbxIUD3FFgukmDpYsuVYtWaJNdT7jX6FJxfNWtpTeGSYzptrN8+VLByv4dsgW7MN5nP4HwkTp3PhJrbRpkPA81FRmCbKhEzCPBz9RwKxcnRqYJTQ5bjFrLX3d9LdiJJBACfcT/L/5hGsSOMn7ERwvB8oZFc40ksYiBsMMPe7q527Rrm45WtpGNfbwnBhlOtYSM0TsZR6vGU4kYDYJRmYhrr9exfeUE2CFzM7J6wS6YB30l7oyaZgZtjJRa4N49uxQqga06MQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 18:05:20 +0100, Konstantin Khorenko wrote:
> copy_huge_pud() adds the child's rmap of a device DAX PUD with
> folio_add_file_rmap_pud(). That helper maps a folio afresh: it updates
> NR_FILE_MAPPED when the folio becomes mapped and mlocks it in a
> VM_LOCKED VMA. Neither applies at fork: the parent keeps the folio mapped
> under the page table lock, and dup_mmap() clears VM_LOCKED in the
> child's VMA.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: thp-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/huge_memory: use folio_dup_file_rmap_pud() in copy_huge_pud()
      https://git.kernel.org/mm/core/c/f403b8aa

-- 
Cheers,

David


