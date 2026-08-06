Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41082C55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38D3A6B008A; Thu,  6 Aug 2026 03:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33E586B0092; Thu,  6 Aug 2026 03:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2544B6B0093; Thu,  6 Aug 2026 03:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F297E6B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:17:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 661A8140691
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:17:01 +0000 (UTC)
X-FDA: 85069987842.18.1FD8BBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C11542000D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:16:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2eClChD;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786000619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXENzFGewvbVKEIJwXHYAIoiYNIgGa+Cz5Fo0Nhu2JQ=;
	b=X5lY4xyqMg9tWGwkzlfHTA+BPNbStVGSmSERCG3MpmeACMnexv+hVNhl6p2NyXUbdCZEKb
	iyRNrfSoLaXOLv32PNNtV/+TmoMeFEzJTNKSnRluzSAiWjGiEwIJ4QZvaDhr3yWZMbw0nm
	lSxZatT2vR7nkis3RCq/5Xw7x4YrDI0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2eClChD;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786000619;
	b=rVQdmD4Bzvf1olvsCbfYYvs0+iOEewd7wGXhMx0anvvUhf0CQTbEF28G2oh0Dl3mdK+W60
	c1hxKZyv0L+6QOlmmr/0mkLb4tPtkyFDmiNknTOu+XvkWkRwMQbnJ3laqpQFAZm4FTGSHI
	Mt9d/lbCYhlsX+Gf3UTqpsrrKmrowM0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 515A360A64;
	Thu,  6 Aug 2026 07:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CEE1F000E9;
	Thu,  6 Aug 2026 07:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786000619;
	bh=NXENzFGewvbVKEIJwXHYAIoiYNIgGa+Cz5Fo0Nhu2JQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P2eClChD/AaOKwmAmAyPQS1DUnipFlxmEzB/eMjNEPjEZ5aqwC0SmjO6Gyf/gc9Mf
	 Y8TZpzplAPvWlbF9BNnJxxPUlusi9jGsZkeCvUZIhmRdYmNFXoQarDX1ytS+V60mGE
	 vMzHPk+Q4aZKzwILGzfSNWjeY/XsFH+sOUJJPSMii1RG1HdF8/za5vnD1S/ynoDBKM
	 nnZMlXWiW2gRlqlxwvxMwBlaEaoQegPOoN+OtOvVaF+G3COJg+PqcpJ0htnn+2mAM5
	 H/nKGQ08QO9jgCFDwzl6sJmNYiICc/IQW2zsN/jzKgslc5XdoBHmPvJB3FTZMZl6Fn
	 EHwjv/NOpoFlg==
Date: Thu, 6 Aug 2026 10:16:48 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH] drivers/base, mm: move arch_numa.c to mm/
Message-ID: <anQ04CpxDjqktbbB@kernel.org>
References: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
 <anQyFuRVekkN8Z5a@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anQyFuRVekkN8Z5a@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C11542000D
X-Stat-Signature: 9ei7i9czyionhrniup8ycncmtqg16i6q
X-HE-Tag: 1786000619-250985
X-HE-Meta: U2FsdGVkX18HkHsO2iRKGvDR1wjdDntf1RCTgJ3GaaQIJpqMy2+shGIAEL7kfOTa3H/pzt7/MXGSGs4TSpRP3vwPY6lowx0eFIqEKYot6nrBANvQxpw/Li2tOlW4OAYCuPdODs4Qkz+/XRKqMyBPP0Q22LiVLVPFNs4W4VQuFeGcBh0CKWICTzewto7va1vlBVN0+Ae9WkUBHoRCWGyOU0Vewnva3Oz0gQHPdjfykoHlTKXUFmLhZr/06B2OLTWZqi8Gi56vTRfi3GKSoPyCP3MzBn4gTcXjb7eJuGFugFhm0rzBZ4Tnlg+QXW5NG9j/zQEhm8ToIB84hvVYNxVyP8eDYB/ITe4/zIkxHWK6dqtGgULfcccz2j2On/g4/Eej8TcA2LOabhAYb486Yd0GfN5yeOt4CJCCcHc856sHex8zsFyqvNQt7irX7Hhf0BxOrCy3OtU+byfTc3GdPetgvfIXR4Mi/ZC1EUxgtFOWNb+SO0JvCT3YYDJCYEcgqhrOG+c0B2kYGMPK3s9K3Mc3VxhhLGgb05WfPCgI5TozodxaBckJbHM52/g3v1+1LETpyEeE5UTZA4+ea60xM0z6EfGPg1MZpwqllenrQ9G3hFI/0gnbltVjDVOICp0Hh2wLGEcL8P8B0DhFAn/3SeM6o9JZkRPRH8NiCxIkZX98S+PxEKmAOxFQm1dpzkemPrHWueVWBTAZlSDaKm9dwWD0ddCTYcLSH8QbVDIYyuFbSYUzGkEa/OWsmpCuTMdTml6PkdbjYEN2zoMCi4Y4GLFm5K2ClC/GKkitn/QMa6TCy37Cyt5h+35NwhagJPUT+wJCfQSxJpWMBj16Jpy0iYswQbVeYvokOsWdQwN6ePLt7temqfPCHfiv34Xl5jnInNjPSeyI38F/t5zOJwisBJqWc0Y89D+5B4ug4+JAJ6PVdAAJU9XJ/mpz9nrnrK8aPi1XIRTrMqsmbnomgIT/JaG
 Z8Xyyaws
 0gXNPywR8cWg3L5yCtfp8AaGSrnba725hrbh7ocVi3Wc4Kthg4U3MXyLj/O207or0VSEQ0KTw0e9BKIanClsg3tn3OhZsfm2MS2VcTNWm07TSN+/lN/Ho69V+JUKHBx0Ve9Z6l4xSL/cuEkC8DL9fVpUiqYIoSVMryz+S808Nkk6lLaGhzkMvs7598B+k2j0Kb6UNPH2pXsW93z0IvxwkzBVKL2P0VRtoG20YpweH/XzVm6X9rzJxGTztASvAJFYv2odYpFRSc34IsxpXARNCJFvxCOxE8DfLNgLYpzhRdzrphVif3OGUjjXWce2iSf3yBGgcUYaS/KbHECk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 08:06:12AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 06, 2026 at 09:58:38AM +0300, Mike Rapoport (Microsoft) wrote:
> > arch_numa.c implements boot time discovery and initialization of NUMA
> > topology on architectures that select GENERIC_ARCH_NUMA (currently arm64
> > and riscv).
> >
> > Since this is step in the initialization of the memory management
> > subsystem, it's logical to have arch_numa.c in mm/ alongside numa.c,
> > numa_memblks.c and numa_emulation.c.
> >
> > Move arch_numa.c to mm/ and add its F: entry to "MEMBLOCK AND MEMORY
> > MANAGEMENT INITIALIZATION" in MAINTAINERS.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Everything is proceeding as I have foreseen... soon we shall have control
> of all of the kernel! ;)

I'm also eyeing drivers/base/memory.c, but that one is more involved :)
 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
 
Thanks!

-- 
Sincerely yours,
Mike.

