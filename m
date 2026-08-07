Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B30DC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453ED6B008A; Fri,  7 Aug 2026 11:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405406B0093; Fri,  7 Aug 2026 11:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31B546B0095; Fri,  7 Aug 2026 11:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03D1E6B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D864A044A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:37:13 +0000 (UTC)
X-FDA: 85074877146.27.7C7A5F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C8478C000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:37:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NTVrrKZM;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786117031;
	b=absk6jSCAhaJkuP8DrMRjDI5EVwAmtK07Pc5i+9B8htOzxMmixe0UJ0PAD5S0me6f5Yrdn
	sym59fESs9t9DzH6Jv5BthTXsnR+WyexgLB9fNpBlk3IVwDBx0huIgRgPTxWwFOuwCuTtt
	1RDi2rPx/bInpwMB4G0ede4MqZLKstM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NTVrrKZM;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786117031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5RitbQenhrDoWq7k1wu9B70oWwVmOgYnYYYp4h7OS1E=;
	b=mJHicggG0K0vOH461wS14+YdCyXqxHyYE3fPSbkblJPlLk54/BT2/WZeIBM5BKicPPLh1e
	NbkS1fU5b4KFrF4qoSQ++wMaqecvN/aUovkd/FbJQRa0btXR3GxDYKDOzKSD6g9PxXaWZx
	jKxcg6GYY4tTpu3TriUxAhAUl9RpOpM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F81160A91;
	Fri,  7 Aug 2026 15:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F0C1F00A3D;
	Fri,  7 Aug 2026 15:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786117030;
	bh=5RitbQenhrDoWq7k1wu9B70oWwVmOgYnYYYp4h7OS1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NTVrrKZM1bG6Vvw5wY9rgG2SM3BG/ydY+6BoETIkSqLuw7GRzibg3KM8RNq7W8eO8
	 +IMp55X5+6WVBfj6gXSVowQZwjzKQ12cGdzf6QYRm7RyimoK4o2nm2neMs7fktzqrf
	 Uf8Hg4wwnK3OHp2PznFVCGw3jn+RbMDSd+EJjT6yLmiwsuei9M0c6DJd02BCh2DfX1
	 QHiQhhBI/Sue9e3Ea8OJW+qDGDXsv8swxwsl+u90PpfoMlRC8LtqNqLYqaSa3JKZM1
	 oyoxWf1EEmZsrfzSjw9DdEHMHkvh4TyfS+TQi3SSUCSCi8lHyR8k0RalEGRMrdOkSU
	 BTTfD6CUrr12w==
Message-ID: <6df7ba6d-0479-4b37-8e93-bb0b7d1288f7@kernel.org>
Date: Fri, 7 Aug 2026 17:37:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] mm: Make per-VMA locks available universally
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org,
 david@kernel.org, willy@infradead.org, shakeel.butt@linux.dev,
 jannh@google.com, aliceryhl@google.com, arve@android.com,
 cmllamas@google.com, christian@brauner.io, tkjos@android.com,
 dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-2-surenb@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260806200548.3124802-2-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C8478C000A
X-Stat-Signature: nkqpriaqrhk83dec4z1j9mah3gf3ko61
X-Rspam-User: 
X-HE-Tag: 1786117031-459981
X-HE-Meta: U2FsdGVkX19c8/Iwqigmjx72ZSDRNOpm4fUrF1nLYmvlFv1hAJ9TtivOB6irUpVs4ItbiguMB4974KMFBv+b9aFEcdwMFM0zO0z2+GZn44/8dpKJcn1bzcm4QVMBZkqLQvPH042/X9hz2XUgWh75dKbUQXdpnedaXzJiB7jtTb7PNOIDoGTjcnO7dT1kJM4ubKxpPvqKfSkDLGcTtNyRY9CfTpP29+/aqmC8eM6BI+Cccn9pZtjQU0z3uAswixr46zajnX7C3ZI38TrS0Z12XE+eEux6MVsadzbn5oF5uqG7vz0T1SrNDrGNsh6tWGq5LDaZsVgf98/aJkX5uad4u4h0i0CdD58qWMDX1J7yg3wRUVC8whbUlRes7rqQUqg0rIZvdbeo/Cuqh/VgDDqwPBkob208JVsOx7q8TQSM6MtbLqVqoWaGlB9QI8b05zJ2517hD8xS390wqn0LOgyvsvN8EoPDfGLVg/rQGMZ05MMdtB7ohBG22DxjMZvetx2qUFqrqEfHartAn9vu4AVWkyJAKWYWAAxFbBkzzp9Gv3gns+15LtjixdHUpqpckRPvRy0Q55AwNslBA7EBJFAuXDJByweDwPH1gCmG46kPz+0bSrSmoDnDBkscVpyJpl2ms6vkXaiCxY6j/BGdtnFHEoFpqSbAeTFrZtageyQ7RdkohxIMJu1qY423IMwzFIFqQwDJIpcvH4/fit+j5KdUkkqyhBwI7pgmHom/2VQ+y704sLXGQ5vvs60pabWfX+thVGFfnqskgCkl6yQ/p0zoi4HXhqbn8K49Qh4a1fDs8h8hSSf9HKOJSR4RnGScTl8Kqc7drOpJ26AMOPkoKvDZfElLTi6uRZnyDVX739j4lCP+3bH7arOWmTdkm2t+gpEDDqV5eEsz7+4+yFbkNw7Hb0OLFQ+GxuGUart9REI3iVYGyPQAYSoLof+f+vYSF0pt9r14Jr7/Mogq/onIm4E
 Cd/J+UaF
 fczDwGzpAmApd7Th/SrIrh1OTs3ThrnSOWIev8EUQDApxpbjkfpwUO0zYl2PfnpW/OQgUrWSxSdSunQzearjzHSIAcMTymA6MIWOsiL8HdcGUsSKWaU6HdiIdqOrOAC9GRpoMQXSc8Ih80uICFrpF0EsEHsYukoKe31oVv7Z2+RRPiRUkBmLyyDz5zS+C4PZqhFzYfsyOH4fjG/jSGPefr80KZbzLGsoUYy89R2BchsK/u+v7poAHh2WLoPT5+bV7U8FVGg8cy9BORq+/jVuE0aV4v1nqS/M3027jLjbqHjPikDfDc/LMUp1trW+spwUe69TRw4lSXiKbWcps4KmoLTOnQHhtv1T86rjx336Jzk7+bNQAjfbUcDbyOiZ6yjqxL3ByGPbk4UxFfWk4jej1PwRUeRruHmoT88W+fta6+u0u6ZUxEM7YO8NGpbLgmr7wch/vLhF2qh86/wlqjUx1onKBVtN9Rc9CxC5gBJN+rL5gRzM4zPQWX47d4rE6dNAIb6vMmBpm1BWiAsCmXYob1ZikkeoqDpOp7VvQD0SG9zcva9dOXP8nLXjSrwRw9lQ8dfdmLpOsN2aeKtXgAhzph81Jps4U+5zHHzDbKjvA+rtRf7KQTrxE7tj8oBoO80SCoKUROp/qobDzluE76KNMK6qbpoJzbP3mSkGotQXXgB9g70ApNEGqdnnCLsuTFjwISAGES5PsQ4zcpNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 22:05, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The per-VMA locks have been around for several years. They've had some
> bugs worked out of them and have seen quite wide use. However, they
> are still only available when architectures explicitly enable them.
> Remove the conditional compilation around the per-VMA locks, making
> them available on all architectures and configs.
> 
> The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> when the architecture started using per-VMA locks in the fault
> handler. But, contrary to the naming, the Kconfig option does not
> really indicate whether the architecture supports per-VMA locks or
> not. It is more of a marker for whether the architecture is likely to
> benefit from per-VMA locks.
> 
> To me, the most important thing side-effect of universal availability
> is letting per-VMA locks be used in SMP=n configs. This lets us use
> per-VMA locking in all x86 code without fallbacks.
> 
> Overall, this just generally makes the kernel simpler. Just look at
> the diffstat. It also opens the door to users that want to use the
> per-VMA locks in common code. Doing *that* brings additional
> simplifications.
> 
> The downside of this is adding some fields to vm_area_struct and
> mm_struct. There are likely ways to optimize this, especially for
> things like SMP=n configs. For now, do the simplest thing: use the
> same implementation everywhere.
> 
> == Considerations for NOMMU config ==
> 
> NOMMU systems do not write-lock VMAs, therefore read-locking a VMA
> would always succeed unless VMA is detached. Therefore for NOMMU
> config we make vma_mark_attached() a NOOP, which keeps VMAs always in
> detached state. This causes VMA read-locking to always fail and the
> caller falls back to locking mmap_lock.
> 
> The following functions will have a different implementation in NOMMU
> config:
> 
> - vma_mark_attached(), vma_mark_detached() are made NOOPs, keeping VMAs
> always in a detached state and preventing assertions and refcount
> underflows;
> 
> - vma_start_write(), vma_start_write_killable() are made NOOPs to avoid
> warnings in __vma_start_write() due to VMAs being detached.
> These functions are not used in NOMMU code but __vma_start_write()
> is an exported function, therefore might be used by drivers.
> 
> - vma_assert_attached() is made NOOP because it's reachable from NOMMU
> code via split_vma()->vma_iter_store_new()->vma_iter_store_overwrite();
> 
> - vma_assert_write_locked() is asserting vma->vm_mm is write-locked;
> 
> The following functions work for both MMU and NOMMU configs:
> 
> - vma_lock_init() performs the same initialization as for MMU config;
> 
> - mm_lock_seqcount_init(), mm_lock_seqcount_begin(), mm_lock_seqcount_end()
> are called from mmap_write_{lock|unlock} and update mm_lock_seq correctly.
> 
> - mmap_lock_speculate_try_begin(), mmap_lock_speculate_retry() work as is
> because mm_lock_seq is updated correctly;
> 
> - vma_start_read(), vma_start_read_locked() will always fail because VMAs
> are always detached;
> 
> - vma_end_read() will never be called because vma_start_read() never
> succeeds;
> 
> - vma_is_attached() always return false because VMAs are always detached;
> 
> - vma_assert_detached() will never trigger because VMAs are never attached;
> 
> Changes in the following files are not affecting NOMMU config:
> 
> task_mmu.c - not compiled when CONFIG_MMU=n;
> pagewalk.c - not compiled when CONFIG_MMU=n;
> userfaultfd.c - not compiled when CONFIG_MMU=n (CONFIG_USERFAULTFD depends
> on CONFIG_MMU);
> 
> The following changes are made to keep NOMMU config working like before:
> 
> stack_map_lock_vma() - keeps mmap_lock in NOMMU config;
> bpf_iter_task_vma_new() - bails out in NOMMU config;
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



