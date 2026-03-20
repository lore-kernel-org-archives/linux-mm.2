Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87A991093188
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 08:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAABF6B0365; Fri, 20 Mar 2026 04:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5AE86B0366; Fri, 20 Mar 2026 04:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49536B0367; Fri, 20 Mar 2026 04:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A33BC6B0365
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:48:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 544A81B8B53
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:48:56 +0000 (UTC)
X-FDA: 84565816272.26.1235165
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B4A91180006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:48:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aVDuHUfd;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773996534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IIQYWNglnf1cpJWekLlvTi81VUzC2YvRS4Y7/+4rsT0=;
	b=o6mIGN2IZttVams3w5hSjlkdaAZiWM04bFe1LiJfhLdZn8Xw7MA3DoJNJv7jABKW+yd9YY
	TkWuTeYkV25jP6C9d82tKtdowpgKzHjxwxr35W8ipD9yPVH4EQtdwi/P7SPNE1i+JLR85C
	12RufXZRp86DeAklnkw51P0qRRrDrIg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773996534; a=rsa-sha256;
	cv=none;
	b=lua3p1aXO3L6qVjbRNz4VMYPH0yBE9qOirGd9m6Hw/PW5hBHZQRkvpNkqeMbfuatHFa1i3
	G/DiwnmV+wPEA0m7eCkjCJa5amdfKoTO+B5KuB3uvUjffvlG19GlSPqmJ26hBQn9H7+A6V
	EiQvuh8NHcjYOY8dPJ9iVPfig33zp+Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aVDuHUfd;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D799E60121;
	Fri, 20 Mar 2026 08:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C6FC4CEF7;
	Fri, 20 Mar 2026 08:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773996533;
	bh=AVThdTFHSI3D63/uFwXEr2OGdo0OiWz7degFLaawtVQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aVDuHUfdDD8S+qMhhcb+8iyq+IuTk2K0qpRAv1mnSPjQTT7GWau5uX1CNTdDtfR/0
	 LFp++8Dnz2QwIE1kWsO/Av6uPpJORJ9xnJDFjFTcwzcgktO9VxcKv+wSUvrzz529wf
	 Jleh6q8+Izcw8eTwQjx9H+19qhhqrrp8JH/iFcDfQPCQTH5ptvLmvsD0tj3RuwnSdm
	 11tBmRkm8T9VJyB6mHacHEUYXp0QrFVfjmR41FNwWWw2f9UTt8GR5oY9fomV0MX3gt
	 Xge1GZpeSPAeqwc5HQZYEgN6ad+xpQ+XJTcqZodE/t9TJgLMJDqXmC2Sy8iqPyspGC
	 oOpqQ4TUqrEMQ==
Message-ID: <7bd728dc-f370-4e64-a120-bd8fdcd3207a@kernel.org>
Date: Fri, 20 Mar 2026 09:48:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/23] mm/vma: introduce vma_test[_any[_mask]](), and
 make inlining consistent
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1773846935.git.ljs@kernel.org>
 <7ea63af87bd35f20b204a14ad4912592e02b15a6.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <7ea63af87bd35f20b204a14ad4912592e02b15a6.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B4A91180006
X-Stat-Signature: bzinfhkdoy8cixbakjydf41umrz6w9mt
X-Rspam-User: 
X-HE-Tag: 1773996534-702823
X-HE-Meta: U2FsdGVkX1+mCfbNhVeLga3CzDlEfJ0ZdCXcD+jDZGvwWqVUTfxVaRhBSRcqIGx1jAPodZoKPmchFz4AByeMjJFqDP0O5B/oYztEKvafwQcloxkYyp2CaSYZGpyof9gRLUByWu7upramejtZNcdNXWxdUukj7HJKofYCCDOjyYn5MKAj3KKxN9jDjuqCcOAEvPS7bzFHd8rSdHez46MQajB1HJgtdeG5greC83gijxEpf/xPNZBKgLyzUbizLuMMtCFOGJWDpimFr0gE9tLmvAphRLoZhdM9ixboIZUCRUkIqGobWMraiqgosZDw3A1V/c6ELX5diAzB/p2ZNkL/SgYSWte9/qbmo1JdzYcNEYHfCiK0bD27bXxrspbEsstSaRcMQpRB5KyP7pTSzcX9D4aUvKQRkxMyfpMHVXcXZLjUPSSVKLi/WH6Qrcq05eSVywsntRM64PT/2wigm5mMzbHyhgghuYZpI7wmYLdm9vrPEUTyevoFZNfi5x7f8qK/viXIKZ90vliUjJZNm/3HN26RZhOibpZpQEG1HTHRbyO3EwKCwOK1pCXDR2VtD1JSkBi9OzG5lxDOWxxnG8qDi/2eeSgP0LbM7RwVLkNN+9tZ2uaEk6gBGcFmHQcNrvFP4rSc1sKbh401FbfcxfhyaDJUDVAAWKH4tcxov02j+e4B0StwCyiWOu1H81X8/4pN5Yi4pxttcYMJguG9bZLzmctwUYoAOugcSm7ciPS9DKJTarUoEX89Q15N5MDjYeIzeArk+3jCpgEIe8riWDDA3o1wXWf21IJ1sesD3HDbjOuEq/aLOOHjdkoAglK8iYwi35aNbwh1/83jVZIFMZpLa9PPSMjiwzdf3/ftzGRHNloDy/jJzsl8g9SxIK2yOAbdeHZmitGTPURQUCpEd3SklPB9nj0LgVasWpeQFuaEtthb/azJ9K5It4XSCHSBjP9/aqwRR0XLXZtjOsyskWA
 hticRyQz
 4oWdKemH4hDr8Yb+XlQTJ+hTjPGEkKwVKnvXkIHZz8vos73Sdv187qMSyiQxLQ3+EyfpEyjpVtabNbzBb/iSyL4u5s2EzQTUFlXVzVTfgnPiLbHptVhVjOeBdmG8h6IOv/lLLv+uag908juVXvIIKUmSr7HiNZ5yDL7BoLRhvQDrB0URb/L8PcG++1lMAP9MUNZj2L9ymPkn1PpN4g3IzSGLOigZJXruWUuRxkkKo2RiHXM9PQOEDMNHn/9Ak6vlW/n8JG5JXi/wo7MRPKcniegQaSEIUmmCq/S68FogFF3nwK9zn7QDeBK0Fo7EXBErX5oy0jprL8sDMAOwNyc93zUL9pL21uXGHb6MUqN+4zG9ZEmSeuDELT47daqYsxCPqKOr5Js0ewH10BKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> Introduce helper functions and macros to make it convenient to test flags
> and flag masks for VMAs, specifically:
> 
> * vma_test() - determine if a single VMA flag is set in a VMA.
> * vma_test_any_mask() - determine if any flags in a vma_flags_t value are
> 			set in a VMA.
> * vma_test_any() - Helper macro to test if any of specific flags are set.
> 
> Also, there are a mix of 'inline's and '__always_inline's in VMA helper
> function declarations, update to consistently use __always_inline.
> 
> Finally, update the VMA tests to reflect the changes.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


