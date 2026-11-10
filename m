Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75E83606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 19:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UMYdlrws
Received: by kanga.kvack.org (Postfix)
	id 8C4576B00EF; Tue, 10 Nov 2026 14:33:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89BEC6B05B0; Tue, 10 Nov 2026 14:33:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D99E6B05B1; Tue, 10 Nov 2026 14:33:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5755A6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:33:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCB59140565
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:33:09 +0000 (UTC)
X-FDA: 85420207698.25.986DEF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3883618000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:33:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMYdlrws;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794339188;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhXriI+DeJQWEBDJX8tiUAimmV8NOGhWTEqPg+S9eXE=;
	b=BhY4VY77UVGeU1UbpQuFUNmfLQN/IbskxfXcQ5bFYOvFx0rIddmaPaAMStfF55bBxJ9rXN
	QpxoBLvTnRvnvc+N5EJ+TNMaUDXqJSBXWsoGP54qr1Qb5fgzBte4W20yAWBut0QxmuWcZJ
	B+zZbQFqrqxKH3mUZa1qxJnlloBaug4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794339188;
	b=3wNRI2Hdeg8aAiQaxOLVu5yOcEyqfS4P6bYBXDuwoNXqOmu722jgKRc6bdzAMpQNB/xXpE
	JVupEKJxbdntxyREEK/oPW6DxthPThYB4rqK0pM6puf5Xu7xVV89mNm6M/veXFku2Q34Ja
	mZSLqNJ1VMZaCCMqKhqG2pv87L5jxbU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMYdlrws;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4E0E63B42;
	Tue, 10 Nov 2026 19:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FDD1F0089F;
	Tue, 10 Nov 2026 19:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794339187;
	bh=NhXriI+DeJQWEBDJX8tiUAimmV8NOGhWTEqPg+S9eXE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UMYdlrwsjqsMhAIX4rj8c2yXl5KEbZYNPDIHsDDQb60XGZ972TrQO/1FDDznVLutA
	 SSMNyK45jLCetNV3ePfOaPTXb55M7hJ0fqCiZVkZ/sgqtczUxHI094EYmt+9uE+K+7
	 Lbpbkzar3gssNK6Y8dP0PMA2UwotLHleFaUmBiAKfj5PmisA/JlmOb8njdC1Whra4G
	 zl+LmamQkumd/TGOasz7mtEbgeVld+uvsTVCC3sXajHT/mnSPou39tMySGfE1P1LU0
	 g7nF3PPsARw5v511r0S+0pnUfXeoNNFytsZYHgzqhJJAflaHUncnVapTkPEM5K7gtX
	 jn9XHrhYUeDOg==
Message-ID: <sashiko-outbox-207664@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 5/7] sched/numa: scan PID-inactive VMAs for promotion
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, linux-mm@kvack.org
Cc: kernel-team@meta.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@techsingularity.net, mingo@kernel.org, vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, matthew.brost@intel.com, byungchul@sk.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org, osalvador@suse.de, raghavendra.kt@amd.com
In-Reply-To: <20261110150446.2452975-6-gourry@gourry.net>
References: <20261110150446.2452975-1-gourry@gourry.net>
 <20261110150446.2452975-6-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 19:33:04 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3883618000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: imymapsi5e7q71k9uipbjs6gmgomciik
X-Rspam-User: 
X-HE-Tag: 1794339188-591319
X-HE-Meta: U2FsdGVkX1+6wTsRu0p6+lKJZ8Nee+aIZyjB/feI6671dXHaQXzYRnsJTJBbJzAvUaWNLER1Xm2Fdbhu4+TIPShDFdA+Kcac1K55G94Rhs/7k26qzO9nEyElE5tQmGLxYIytZL8ZFNcFV/lUxuyaOYIyT3QKW3m7noPe3SZpEOsK7s4i+d59uLD2C/5HAnRsQ+RgS5O/cJHmPrfWskvwqxWn6JG0Dvb9kMDrZglhTf/tYopnNLJu//ACphw/4PgX0deArLdszdMZPWox3bHDHZjd7fepYGWR+JLls+HnyXTfxOxgh6jludJuWi98MPXA3uBJEDqZ+cxEOoMXhIfvR5FmHml2TBDedH38TPAyikvcv4vPcDy95MLZbkTIhpfCURfssCMQHcYo0WQqTnD6Z6+rmGTm9XTcQIIQZNjrgm17CXp2S+/Qx0sxuw0YHGEBE/qwckjgdWPrHbdGNFyQR+aVNgAiJne59IOsyHBzFdwHvch8O1m/KkWTZBIm0OwK31igPk9mnLjJzdXylhm1WK8OyFFe59APVzK36LTHAweeIgJK36r2FfPw4morJYPL7tmKMkUkhmnhbGyK8aQWlC/POxcoSwRtJhnaZ0vVKVbEMX39PykFoPfzUWIBnhrrRnBLd82rBErEuAas9O/V2S+QqSZ1I0mOOif5m1yybV2aX1dAi7ytt7yx6Qd8ngoA9iTEvtd6IvOeIrPrPWvmV1Rkqyho2Izxas4MAJx/lWgGyyHP8JsBkw+gpVVaqvY+5zfEp9G4JqRfevcrLBU2dxRpd5hM4PAZqFsScShH5SWPRwKm+C4/wstl9aBOsM6L+Liq634FCmZt+db+lBHkHuM+9TNA6Nrcy0RfD+diOO1hOC/37LgTPKaxgwdHj7z6labrGt58aQcOqfY8frj7qd9YT7CjSzlmOUmZabSt0Bw2s/paLkVy/fhnKQQn1kAHUzI4FY0x5WK28az5+ZB
 ZZLzwLb+
 lrC86xdyQrUAcMiKQnjaY7G22ZtDKr9k/ZnI5lnsdtSTiScQU+BjogsjMeeBXWQeTPRI+ieNVQHcnqPcgUl8Qsehzjs6cLR2RGxPd5lf8QeXoLZ6jV/qps76EQqEaJeFQPrvDR7L3mfGHKkCSWZz5YDdKOILeMOC67rX1GKrhQeVuyqMfkAW7GRdjXa7FSD0adew59GgC1PG/LKdedmVy4byAdXIeeMUutsRfb64WGOkctfsw+pkSPtVQRsSoYoEcBzBxU1uagytCL02GT9tMYAyLwdwctncSD3QC5yZxgciY2TuY256+95Daqv1+pK7vjBbdCKNvCMMuUbBLTXbeb8J4kGub2KR94m2hXtRA9HJ2kIyaDTDkozLDjWglv2L/CUoEyTBZSil+9vWnecgbXHbqxff5FvkU0RLo0XnXcroh0zLmjyf01iYQiQFES1hwy3/nMzZ8HC2AoevsQUgszAFboY8N8tcxLuuk0wYPbRGZYe4+QJLeHrg28AzZNGpIf7pnZG40xeE4mD68e9D1z2stEVQqTqCtMl2xRxh8VV3xC9YoT62U3AY/KD6JeW+TPFTZ83N53MsJLLqH3mzf0UT3Up5pZDA8zA6GviONDx5K9SbYAPpEueLvmpnxP6Ds3FSoLTrn+ykxDG6ezIBSzVP0hILNVWfV+ofkLUprY/wr71r5RSIItqTKN4dqvMomihaJvOblckpXg+KOJEXPv1fSVL3gavR0BcV/6VxeihCu5LM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] sched/numa: skipped VMA scan completion update in
  task_numa_work()
--

commit f65331bdcd950c59eb449c304cff02b0db3d6e66
Author: Gregory Price (Meta) <gourry@gourry.net>

sched/numa: scan PID-inactive VMAs for promotion

This commit allows memory tiering to scan PID-inactive VMAs with
promotion-only scans when placement sampling is not due, and tracks the
last completed placement scan sequence separately from promotion-only
scans.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 778ba0ed34fe8..279bf12b74b64 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
[ ... ]
> @@ -4506,8 +4519,14 @@ static void task_numa_work(struct callback_head *w=
ork)
>  			cond_resched();
>  		} while (end !=3D vma->vm_end);
> =20
> -		/* VMA scan is complete, do not scan until next sequence. */
> +		/*
> +		 * VMA scan is complete, do not scan until next sequence.
> +		 * A promotion-only scan did not cover top-tier folios, so it
> +		 * does not count towards the placement-scan starvation check.
> +		 */
>  		vma->numab_state->prev_scan_seq =3D mm->numa_scan_seq;
> +		if (placement_scan)
> +			vma->numab_state->prev_placement_scan_seq =3D mm->numa_scan_seq;
>  		vma->numab_state->promo_only =3D false;

[Severity: Medium]
Can task_numa_work() skip updating prev_placement_scan_seq, prev_scan_seq
and promo_only when the final chunk of a VMA exhausts the scan budget?

Inside the loop right above this block, task_numa_work() jumps to out when
pages <=3D 0 || virtpages <=3D 0 before checking while (end !=3D vma->vm_en=
d):

kernel/sched/fair.c:task_numa_work() {
	...
			if (nr_pte_updates)
				pages -=3D (end - start) >> PAGE_SHIFT;
			virtpages -=3D (end - start) >> PAGE_SHIFT;

			start =3D end;
			if (pages <=3D 0 || virtpages <=3D 0)
				goto out;

			cond_resched();
		} while (end !=3D vma->vm_end);
	...
out:
	if (vma)
		mm->numa_scan_offset =3D start;
	...
}

When a VMA's size (or remaining unscanned range) is an exact multiple of
sysctl_numa_balancing_scan_size, the last chunk reaches end =3D=3D vma->vm_=
end
with pages <=3D 0 and jumps to out.  That sets mm->numa_scan_offset to
vma->vm_end, so the next task_numa_work() call moves on to the next VMA
without ever running the completion block for the finished VMA.

Because prev_placement_scan_seq is never updated on such a VMA,
vma_needs_placement_scan() permanently returns true once mm->numa_scan_seq
passes prev_placement_scan_seq + get_nr_threads(current), preventing
promotion-only scans on PID-inactive VMAs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110150446.2452=
975-1-gourry@gourry.net?part=3D5

