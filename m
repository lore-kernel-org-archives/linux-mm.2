Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E248E1093193
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 08:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03EBB6B009B; Fri, 20 Mar 2026 04:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09D66B009D; Fri, 20 Mar 2026 04:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1B66B009F; Fri, 20 Mar 2026 04:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8FAC6B009B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:59:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 623D81B8B92
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:59:31 +0000 (UTC)
X-FDA: 84565842942.07.9F6E81D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BB673100004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:59:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vnv5g+fa;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773997169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qE1a8eSDmA7XKLylBZoZ2ff1KFzqTNT21inTj4bjszg=;
	b=kgSpjRwZ9egUPbIZ6Whg0omBw2SuQaNRKhW60CVawxXGovYzJn18etpwNTEgk8q66h1zv2
	RxIbom/rWSk99rkb0H/JQ/tkN4n5knk0EZoA0GfIkFDoPnkqsszn/U21MMwT/Z/F82eUtm
	5WzNH2v0xLAmHvIAW3IxKV9YuLSCf4M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773997169; a=rsa-sha256;
	cv=none;
	b=uTehee378rzr/I8hbMP6ybEaoZcOYbW5kVwCcq+q8bDEf+WbldDXzR9nGfrszc2OBAJz25
	/QmxNx5oTzoFP9k/nE8pOVj3Jojl3qrxWeBcjuOx1VkEQdcAWxH/WjBD9Se+vJWvwl/GoY
	Hoj9KqqnfFW1X8H8j6v8zwtlfnDPYdo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vnv5g+fa;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2603160121;
	Fri, 20 Mar 2026 08:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99035C4CEF7;
	Fri, 20 Mar 2026 08:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773997168;
	bh=gZ7mo8VD+NAhXZQb0GYWny9AT9mHJxVOkGXSXRSlXkU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Vnv5g+fajJemAepqRKZRz47c22+umNsA8K+bcibnuhBXHBu1d5YmKqWsG7qOfUFHJ
	 CztV2PyO5tXV2ndgWUvx38ZhYgi/lqkSfU/R+xvcHnxYaqLoT/e6BRXTA0NdY6badP
	 onDLOW/x64CNFEUrBONrSFSXSn2B8FQntJuy/TT5vt3gBjuLsep153gxDZT/dirYhC
	 CVXFpifY9igf7fwFZwHhAhTf6uDN0JdiB+PEafeRbGrcMqNb+21IkikxadesfcAOxw
	 W1QaWfzU+BhIh3qR/LFIA31TyjFUkVqrJLl/fZ5m//RUqAkbCbCMSFvmboEAlRrHUw
	 pulfK6egziujA==
Message-ID: <c45932ed-844c-48ab-9481-9973bd0193c3@kernel.org>
Date: Fri, 20 Mar 2026 09:59:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/23] mm: introduce vma_flags_count() and
 vma[_flags]_test_single_mask()
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
 <02a6b26542ab70d60175e0125cff5fd00073c7ae.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <02a6b26542ab70d60175e0125cff5fd00073c7ae.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BB673100004
X-Stat-Signature: j91a9iwfqf6ywoqaairftdhokmduazw7
X-Rspam-User: 
X-HE-Tag: 1773997169-149931
X-HE-Meta: U2FsdGVkX1+UaT1DKvVfYm6wmbpQMEInzLN/b8WppFXdgT3YL+bSH/yIbu/FeKzzSQDiB4HfvjvvFEtMpIqmYtyuj253w2Px2YfN5TB+JAAh0d+q28WA9mFnaNEfXQ6XXuo+tg07UeZbI3bbptQ28KQULunJOAEDEFgMSw6vEEAVwg5nu8r76Mbgev4tfPHTZNHawc3s/9eskefzrir39sTNy8HKNn9k3IOm94g+w02ohibBEyd2JMPMIfBqwfIdHI7IsbGgnp+wBgdcPDOI0iy7jrE3HmGcDTZ+tY745PnFT5+lF41FOOyypBj1VZxDl85gYb/EJKuTBezO2Urv+NlQPQxI1yqv79j4NHsdEFyVw75jor+hdiaY1qYWumInXu7vienBeq8bEhx9A4npP+gc3NVacOxGCIcqPMZFvr73xKiArTIpoZAr6JJ/QORR7yVXIJeoQOoOARBgIkOkbyaU7gX/XMDNZLJdVloK1ppJg8qDca9ym9QAW7jeGyVna1Ouh/1PHQrlvAe6nwZhPOWMEOStY4F7OSvb3Ha/JeMpaEv4togfxk+OOr9/dPLAkq8ZZrbXgiiaHUP3l4lx5PU1LK6usqCfasf8nj476tvnRRI0UfTViPKfdcVkv6o6jhEiHMItEATLqOqfccAvFsFGFJT5un4B+OZ8k35wfUcjtz1/q+yXEhVAlL71dVIvbxtH94WKB5lQQNNzMlfixEZ68T1nsu4oCdhl29xMNJrboc6dyTWVbHszCGD6NDlko4nPTn8EcBF8dQAAdXRnnb0DA7OubGAVSXW8bQr6OHIvwIfDZtpZ8Vln8OWQbwYtIx8FiVvokMLmuc1IBkgu5JWnIE15gcv4ayuzWwg5bKjx/kZmUXN+rtuVhAvMssOmc1VYhzILcN7ecM0ob7jFdS61sFHISZSu9H+7Renmn5rEENnU2zPNRwVppeNNEkDbVOFQxgPQulSHprZNiPg
 7X5DvrG2
 8rokm7tof6cJ5FufsoYv3GWuwGohN3eTwiIJ/MGfJNFYb4cVtqMwNHEZBrOSlswC2n2cI+2jD+nw+H4iLu8+ixxYROdjJZlDg4xT49vf1KBytp5tPpiqFFjxJOEEFBjpN0wJBy77YfaGBBTSNATGdULkt9nsBsLfsfowSM6LhigQsgUAVP/8LInCU4GTJCiRGgXXgGSTyFmNh8inakXPhUtKZZ2grUsTJXSgQspXs6UHhx70A7wP6HDHvgQawVkxgyOhYhnSVLcMmcMjSLoO8Qf9Ln4GZtmRX+KMI9jBorU/1vMljKTe4akZEA6hB9eIkEo4VALMv6a/kQAMmaWIIYhHG5yh2PztvJqIxNsU0Wg11+WUPmroJAnmgMfYaMYqHQ2D4DzMs3vtdDO0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> vma_flags_count() determines how many bits are set in VMA flags, using
> bitmap_weight().
> 
> vma_flags_test_single_mask() determines if a vma_flags_t set of flags
> contains a single flag specified as another vma_flags_t value, or if the
> sought flag mask is empty, it is defined to return false.
> 
> This is useful when we want to declare a VMA flag as optionally a single
> flag in a mask or empty depending on kernel configuration.
> 
> This allows us to have VM_NONE-like semantics when checking whether the
> flag is set.
> 
> In a subsequent patch, we introduce the use of VMA_DROPPABLE of type
> vma_flags_t using precisely these semantics.
> 
> It would be actively confusing to use vma_flags_test_any_single_mask() for
> this (and vma_flags_test_all_mask() is not correct to use here, as it
> trivially returns true when tested against an empty vma flags mask).
> 
> We introduce vma_flags_count() to be able to assert that the compared flag
> mask is singular or empty, checked when CONFIG_DEBUG_VM is enabled.
> 
> Also update the VMA tests as part of this change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


