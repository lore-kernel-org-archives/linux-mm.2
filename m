Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F140606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KrB138xA
Received: by kanga.kvack.org (Postfix)
	id AD7626B05B3; Fri,  6 Nov 2026 11:49:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEDF6B05B4; Fri,  6 Nov 2026 11:49:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99ED16B05B5; Fri,  6 Nov 2026 11:49:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71ADA6B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:49:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 016C4140139
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:49:00 +0000 (UTC)
X-FDA: 85405278882.17.B3CCA43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 31E4B4000D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:48:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KrB138xA;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793983739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqTUPu4uDFtmEky3eJGu8FbX8sNx+Or+hz+eWSfrOqw=;
	b=idoHv/OHtsfqhnqUpjBelX8pbZtG5iVhG0QIoeETgkMQesSUzNSkfsDKjqam2FLn9WtI/N
	XK1j7uZqubPZSImisJseFaqRIY86cjwkFOSW7BVoqV/1C9TLvLzNOkYw53Y9WKv399VTUS
	2dRRkg6ZO5fioQbBLz/ZNWS+dvEUrMU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793983739;
	b=4ir4zTbZLI0cLpS7c/swpyxjp5ZxjNbE3OUsATDjTwtJitD/7q4aj/sGaQEqWkjsWCt/rC
	QzFsEy2kKUg6qKLJ9m05SSbSnYBSv7UD+vBnA+7wx22rLPjiz2/SEx3wS20eNkwalPuzVL
	uOqjGjO9M7QQNmmbNAEO9TTVLEjvQus=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KrB138xA;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F76E40951;
	Fri,  6 Nov 2026 16:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAAA1F0089F;
	Fri,  6 Nov 2026 16:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793983738;
	bh=HqTUPu4uDFtmEky3eJGu8FbX8sNx+Or+hz+eWSfrOqw=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=KrB138xAbdqLx8TVda6AqfjjiVZ0NsgU1TRW1cY618TT61y16rSjHyRHAkKV03uqz
	 EuGNu32HEURaTyQCeheMZKE+ynBrS6XYkA6s95y02MrhkypV+S2pgdVQW34S+4eq/o
	 Pt7wGOjdZo8mi7Wok+w4eX/kTwtVv8PT19SVyadw=
Date: Fri, 6 Nov 2026 08:48:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau
 <kas@kernel.org>, Peter Xu <peterx@redhat.com>, Alex Williamson
 <alex@shazbot.org>, kvm@vger.kernel.org, =?ISO-8859-1?Q?Lo=EFc?= Molinari
 <loic.molinari@collabora.com>, Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan
 <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v5 0/4] mm/huge_memory: copy PMDs at fork like the PTE
 path does
Message-Id: <20261106084856.4b254c973694345ee58a9b63@linux-foundation.org>
In-Reply-To: <20261105211819.2a6a349b2edc077784ca52f9@linux-foundation.org>
References: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
	<20261105211819.2a6a349b2edc077784ca52f9@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: h5ueeydihrbaty6fyras384hjfq1rewj
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 31E4B4000D
X-Rspam-User: 
X-HE-Tag: 1793983739-308986
X-HE-Meta: U2FsdGVkX19kdiMxMxEOaB+EhxXKEUrlLW2NebIvIfoZVWRuaejzOhPJji7y+z2H3slglgQApRzQoQ6PGh9/V7tkSppQCHxpHunNXzT/OwLPLD3HXUbvJxQg9Gn5D+z3crWhcelum5K58nSP56EhG3pPbmJY78bQ0KlWLLWjHNbiW6Jp7QGDz/ULAaL0WlpbxeY2TD3WIyq6ceqGa0H4h7DkY3szqSYbPX+NMpa/oAwVyhFlgSmCU8CEpfgviKitKgYDwixS9PdH6QHoJHNY+EbJKl1MnNWNFpdjzkR80TqsP6dNy9vgbEoLFKCv3MUV5VX0BItKEXf/C8Wn/b93I6KRy49sxyEIrBcrjk1bzMQWgqjITjq1TW5brvetZ3NVnBAUC4bqrzM4WCpOgwNCM9ardRFzkb434DOMPfLcSV2X9/BaX7ATIYExn7WfZv7iTTbWbnRzg74gt3Bw8T02KT9WUh61GHm3eiqhYJ+U3de1V072LiXJIwUHhG7qoPVJHl+nizoA97D27Gc0QjQDcX7Dn+5Pe3lQSx5eHdP4PhngPNtDnb5EyiqsYakEuEhKbuLqc92egcbE4XkMKI0y2r3Pr83MIkyEzbFuTIAcOJvINwwEzVTx3yyO0ruBakgPN3yUeNTfgSB3IYVW9bhlr/dfcUa2yZgSneN6FzBTdh+wKcCT7Fr1lvbVOW9ZybUNupmfG+I7rBdo6ZXBezgrVyI7Ate07kZlf+9HkACLWiwKx4gug2P2Hd9i5WZHKnWTItOcfS116uoXv3GhurvoJu8B6epak+fTJ1xxHiuLOQr3m6nNbQzHMS7lBXgFUN/MuGxYsUlP7fRjC7Sn7EoILWhFcPsmtXzuQEXS+mmqia3mWmJBGSeUtfKTg3DYi3ClMDEpuLH0j2+S4JMwUoKOyyYm160JX16Ynz3zqtq4Zf2urwZ17PWL17CJT8jEHwUtIUJ21jpY/TFfa2YEvjQ
 1q/ePZFg
 olpfh+ivk+MFBsz+6dPeyRtlmq6Ipk3heij1+3PqGbWEeFjt3Azhe8cIkqmKmXglZBYlt0OkY7LBahwu5LRiXGA/Lod6qA4btLpZ/8C+YGWERmcmosAv0IjIqqjNdTJbhgpVHcf+GhxAa3GrS+yI7GpaYJN2Co4ZIzE6HKClHBxDsG07dcLj9pjPZ+3cEIJW4pXrPSWbsrnlmcOCZMvD8n1I6N1isKzUhfZBDMgzGQdKoFNhvJwgb0G8CxBE1p7o1D6oJGPTnWtohsgICoZ8Ny4IBc12yVw3oPmBva92r/QMGVEokgMT/jp4ZwtD72y4fFNbHVbR7vjMeGyjm9CsNA3oM9r1l3SP6TASrx4FVPWO61eRwrzGCqlHlKCJ1zetVEcH2crnZwwQjbraoGQ74FVarjk4N96cqBe2IXiMgU+QXW5CDWpyOsbzeKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 5 Nov 2026 21:18:19 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> I'm attempting to runtime test this on local LLM-driven live kernel
> test setup, but it keeps on kicking me out and calling me a
> cybercriminal.  Sigh.  Giving up

Success.

tl;dr: all seems good.  The expected performance gains and losses were
observed.  Can't performance-test powerpc because the unpatched kernels
crashed due to the bug the series fixes.

: I tested the four v5 patches and the selftest fix on matched x86-64
: kernels. Both shmem fork tests passed with the series and skipped on
: the pre-series kernel, as expected. They checked inherited PMDs,
: private and shared writes, parent mappings and ShmemPmdMapped after
: child exit.
: 
: The special-PMD race was reproduced with a virtual QXL device mapped
: through VFIO. Revocation before fork produced SIGBUS on both kernels.
: When revocation completed during a controlled pause in fork, the child
: accessed the revoked mapping before the series and received SIGBUS with
: the series. Both pauses were reached without timing out. No BUG,
: WARNING, KASAN report or oops appeared in these x86-64 runs.
: 
: I also built matched PowerPC kernels and tested a POWER9/pseries
: hash-MMU guest under software emulation: two vCPUs, 2 GiB RAM, 64 KiB
: base pages and 16 MiB PMDs. A trace confirmed order-8 VFIO PMD
: insertion from a 64 MiB virtual PCI shared-memory BAR. On the
: pre-series kernel, the child's first access after fork caused a NULL
: pointer dereference in __hash_page_thp() and a soft lockup; that guest
: required a bounded timeout. With the series, the child read and exited
: normally. Revocation before fork gave the child SIGBUS with the series.
: This is one comparison, not a PowerPC stress test.
: 
: I measured fork costs with a 512 MiB private shmem mapping, including
: 510 MiB actually mapped with PMDs. Median times from 100 forks per
: condition on each x86-64 kernel, following five warmups:
: 
:                          Before    With series
:   fork only                49 us       63 us
:   fork through child exit,
:     no child reads        132 us      202 us
:   fork through child exit,
:     one read per PMD      637 us      326 us
: 
: This workload pays more at fork and takes about half as long end-to-end
: when the child reads every PMD. These are single-boot measurements, not
: a broader performance characterization. The timing kernels had KASAN,
: lockdep and DEBUG_VM disabled; the correctness kernels had them enabled.
: The x86-64 KVM guests had 8 GiB, four vCPUs (one virtual socket, four
: single-threaded virtual cores) and one virtual NUMA node. The host has
: 64 physical cores and 128 SMT threads on one physical NUMA node;
: individual vCPUs were not pinned.
: 
: I attempted a PowerPC VFIO fork-only timing comparison. The pre-series
: kernel faulted on the first child exit, even without a child read, and
: the guest was stopped after a 90-second timeout. The patched kernel
: completed 100 fork/exit operations, averaging 2.77 ms under software
: emulation with tracing enabled. There is no matched PowerPC performance
: comparison.
: 
: Tested-by: Andrew Morton <akpm@linux-foundation.org>


