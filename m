Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC3C6C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 23:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494CC6B0092; Mon, 10 Aug 2026 19:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4456F6B0093; Mon, 10 Aug 2026 19:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334BF6B0095; Mon, 10 Aug 2026 19:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4FE6B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:45:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A7E1802B7
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:45:02 +0000 (UTC)
X-FDA: 85086992844.14.B937330
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf28.hostedemail.com (Postfix) with ESMTP id ABFF4C0007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:45:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lZL94BOh;
	spf=pass (imf28.hostedemail.com: domain of 3e2J6agYKCIQ0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3e2J6agYKCIQ0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786405500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lgf1v7ZyMRecW6GzYu5RKpdf3OAqJ1cTW2eoW0KSWKY=;
	b=e9K7hUsakWWEch7npR04dvErdUONMZZEkwELk8Yw0Gp+8X5fNkKPB3hrL+7DZbR9TEZwJS
	KeTqOl/ShRfm5nnOsbyIVd5cMvmrkjg336nsM3ONm1opL75NAEVYcblCVXIvSWGo4wsDpV
	NGVBLkL9iH0VInvVkAqD9rGESfVc8fE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lZL94BOh;
	spf=pass (imf28.hostedemail.com: domain of 3e2J6agYKCIQ0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3e2J6agYKCIQ0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786405500;
	b=a0qutnUgAkrWYeXHtAymdXARcz2zePHwM3JHMZf2Rn2ZkJjQmVfqg1EGJyiehHICanF33E
	g0rKf6/c0CygIR5h0CNypCbupbyMvsSQpO0p2kxYDzL7hu97hYDqsqPza13UhAn2DYytnq
	5g12FhejOmV4wVICS3k0xRBGIqzppvE=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-ca8aee88725so441235a12.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786405499; x=1787010299; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lgf1v7ZyMRecW6GzYu5RKpdf3OAqJ1cTW2eoW0KSWKY=;
        b=lZL94BOhUjlakwutonWw2FtCo703n+d6ecHi0W3X81tsgctnwFGCyc4+8r8/ZmagA2
         bxs1iOqsgM8HRjVZeKaEWZrg9MeMvLX6ZSJpayy4vBP1PdnZPBRBtGptXPrPbOXiytAn
         5QZnUerlNKObJx7wii9SW6IorLZeqzr4o2/EPgpVEqXPnrf6PhCpJsHkQUHSohx9Mdem
         pqNtt3VHEXBSa9h6d92EnFGWZQoaOnsLOpmicsgW16RKtcdvHYtYBPa4j/0hJlClZZit
         b99qjCR9evJWY7nlYCcdFb5E4C7uRPCpoVEiqFhv6h7lO5GIuF4xnqWwQyq4luedK67K
         SjGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786405499; x=1787010299;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lgf1v7ZyMRecW6GzYu5RKpdf3OAqJ1cTW2eoW0KSWKY=;
        b=pZ7CnHxWsgPFLMub5lCE8VZK7kMKplNthftkfKwCo2/lx8ZXUXBxzI6lk/h3SBB+um
         bLYs9ZzjdOyBZvwj08ogkqFi21tGela5KdsqcoFGcG/uwSFP1u2q7dsPonRQzl2Ku9dr
         EpQkOk7k6kteIBKNJyrS8BkP+aErk40dYoEOVx4TB8MZUtjpD2V0sXN1oCpO14HG+A0J
         0PSeBfsWVAbiVVMxr7Y3CsiJynNffJJeWnC49m4fuhPKcPRntGrpTUpvr9vEsCFlvMgS
         cOzPk8dyntyD6horig3CPipdxC9VhWi0JFUz7Y7HT8ZRoRLetRxn3csnLwisLLNY/0Fd
         UDuQ==
X-Forwarded-Encrypted: i=1; AHgh+RrnBhyXY0Uc/liTJWDyBSNwhPVtHK0pq/yPEEUCPVQ2YECRL8VGG4L0U+SXvfKL1WRLjzV+e0qBdw==@kvack.org
X-Gm-Message-State: AOJu0YzP4CkWMz+TCrIkQRybbKPU/pl2CRL4aAPo2T1ckGmDy8bVXhCI
	O5RyPBjeIF2YaVXKg+DjHvnLLaIqH6Xrcsr+vFGuInB/t4webJUgTvoo3q7DP4Ix1DYogkLvC1C
	r7xXWiQ==
X-Received: from pggg21.prod.google.com ([2002:a63:2015:0:b0:c9b:bdf2:2507])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:178a:b0:845:e97d:447e
 with SMTP id d2e1a72fcca58-84f2e040170mr49815116b3a.26.1786405499340; Mon, 10
 Aug 2026 16:44:59 -0700 (PDT)
Date: Mon, 10 Aug 2026 16:44:58 -0700
In-Reply-To: <20260728121138.1103610-8-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-8-tarunsahu@google.com>
Message-ID: <anpieno-RyRl54fp@google.com>
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
From: Sean Christopherson <seanjc@google.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ABFF4C0007
X-Stat-Signature: 9ht4wboz8ddsgz4o674n41cx19crcu5k
X-HE-Tag: 1786405500-918954
X-HE-Meta: U2FsdGVkX1/2TIpurqLnz7EhbjafyskI7r2FOZq0q1Jp/2EQK8pmYF52eMJgEqvsn3I/fExSW5umkoHIbGkVqJpSwZV5Q/TZi2p4JUAyegC4tzTezDq7OEW8t92VXTNT5QSbM5t0EaqlgnifbE8jKHoTMDiabtu0fu14/EcsBcMA27PIwy9p/wNNMIkAO1GhPmDxLylGr0iTtdSpJsxXBAtwDL11fKdUXpoZ6cQPTKSwuqyQZHhAP7q3eqU2La7zhmgqeV1CwVLTW29rLS5Wc5ZPeo7Q2I6tgBiBIFHh436CyrOy46CrJFaqKsKvPWvZYuFH+AdNQKPScum4NSMfmxPArCM4xwGOkIJQFnJc7hEttJB1CNsOdleZbLG3TqhMaFociVCylv3tegTJtf6g/HuC4IZ8hBH6S0yApY/00JoC/7msCNMzsFm+mzRVlwnla5WN35tyTzASgTOnd/iO5VSjCWDFAl659WwAXdTuaCTE/n1pr+hcaN0HBFy48Mdlten48sfHtCK4DkH9H0mVyhpom4hWLl2qNL/p3O4jsBFfva88t0r0ZWXzeBsM/X+oVhamCmoR4zOprdg3tXwHAgK/kYPV/D6c7npcYxn0koRBMsTHOZllRAmAQHyITEU9luvmzyJMh6KGUSIBTFOYGRdq2deygIg9T4mXjfnEk6wgDS7SBzwKIJg1vCYW1DJZr81eawtTVyMmj4pNI2y1FT2GVZ22nQcNLFz1jvFXK5uvpnODyM8G5qZ3EXJDtGwFlIlU9IgnNGmviKso6xdlL7cOELKQZZ1d6BLO3DH0LCzxVlMrGAymXHggzP/PyIndFCuMIMlFx2jTyQMK6EhW460kj+JKce+W9WkorwzMdSCQMRDNwGtIjsrcSVr8X5v2vZC/DpKIEmYaTCsNJt9OXqfx7Akt+zWvrxwrTfsiWwsXxyI65+GrkfFfxtDiX93ubCPYJ6bkXqkiqXWVLYk
 v+84xsx9
 oH30CWDQRLMTNeXnQtXugwQVQTDRRA6kng+Xm/qyhKXnS0TtDl5VvRLDsooBiV3aS4MdQCPBS7rN3u18HbwItM2mGOE2hRRShVHlLd2qCBsDo9+zLU0OAKPZT6N1r4OWG5xj3ZxfSdacyAq0tdtYmPj9uLSKkj+xQUeW+7BoP7JEoBQso09/daM6b57TptEOtayFN4yL29qa1J3MDC0ZmZfEkqgJ931ajW81eRCxg8fJMQ0wYT/vY9SxvklLVwpmAmvQLQwPW1e94egPQgW0ZU68qfg24+TDa9xzdDXXCWbjr3R8h59iaugbhWbfhmBTwH+zRyYdkvPhCZ+weuOLpp3IM35leOrxxDr2HA0YIUAyDKCv+HTx79aufLgX5PmWeMA2//uNfuQh6FWVYc/fzxQNHiZPo8hAx5d9slRUQF+mvT7gLihAqhbAALrzyg0/WgQgOHlE2FpsBRTK1jpbAsSq6u6Xuua9fY2XlFTP4IWDeVzbL2GcJN5r6/IWfJXO3/NTtLcUrhKZvwS8hJT8jDdeb+koo81c9yFO09myvEniFawczqgMeJBp8aC6Ljupuuj/UCFAvU805OERiMYlk0Ggl9R8jqwE5YfGKoBfMUSnZ+zZHGRVVUG71Avql2guFxxNf3a/SHVoxjZvW/CpL5va5va+mqb3HDIFzPGCnda3aOOk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026, Tarun Sahu wrote:
> +/**
> + * kvm_gmem_freeze - Freeze or unfreeze a guest_memfd inode mapping.
> + * @inode: The guest_memfd inode.
> + * @freeze: True to freeze, false to unfreeze.
> + *
> + * This API is used strictly during the live update / preservation transition
> + * window to prevent host userspace and guest-side faults from making any
> + * mapping modifications (such as fallocate or page fault allocation)
> + * to the guest_memfd page cache.
> + *
> + * Synchronization Strategy (Sleepable RCU):
> + * To avoid high-contention VFS locks (like inode_lock or
> + * filemap_invalidate_lock) on the vCPU page fault hot paths, this subsystem
> + * implements a lightweight, system-wide Sleepable RCU (SRCU) mechanism
> + * (`kvm_gmem_freeze_srcu`):
> + *
> + * Global vs. Per-Inode SRCU
> + * ======================
> + * A single system-wide global static `srcu_struct` is used instead of a
> + * per-inode SRCU structure to completely prevent unprivileged users from
> + * exhausting the host's per-CPU memory allocator. 

This argument doesn't hold up given that each kvm structure has two SRCU structs.

