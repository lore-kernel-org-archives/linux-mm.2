Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 138B2106ACDF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772B16B00AC; Thu, 12 Mar 2026 15:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725B16B00AE; Thu, 12 Mar 2026 15:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 652D36B00B1; Thu, 12 Mar 2026 15:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 547D56B00AC
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:30:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EF3258BAC
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:30:44 +0000 (UTC)
X-FDA: 84538403208.11.8E6EB7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00A07C0019
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:30:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MpZymGjS;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dppx5bZj4+zeqj0N8m+gDYvEY1V3ochaIFGxa6FTN9A=;
	b=g8t/m4gym7FxvxVrVPfR0vmkhp4Sg2PI/0J3E2omCtBoqzk8w8S//23X0KAoZ6OpRpQi4x
	vcVsH0KcJCnrWbAdEe8Seh/nJhZllBHvWfQe/KaQzsq7jDBXJTZU1sdWRBTxjjCxIp6tmX
	ikZXd9w9gDDyzto4jflnGkCkedguDrE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343842; a=rsa-sha256;
	cv=none;
	b=2u2jSa7m/mgdJPUz6YOP2RSc5Q39ru9MHl2aa7R4IVzoU+Z/RC2lBMMcBIQLs6aAAdwVsc
	juQp1YAfZUdy+5sJOcmQsf3nsGsXRstBfzETEOC11m1/ye3UryxS4Zkb6CvvbKVx7cxRuM
	INeROdFYoddWIAicgAh+KgC090Y7qYE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MpZymGjS;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 406E160142;
	Thu, 12 Mar 2026 19:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7617AC4CEF7;
	Thu, 12 Mar 2026 19:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343839;
	bh=dppx5bZj4+zeqj0N8m+gDYvEY1V3ochaIFGxa6FTN9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MpZymGjSfeezPsAxTR8is/y91vPi0xEPN0K7IFHZz77hM83w5Vj26pRQa3IjU+zwy
	 tbXTe0vQVq6U2m+k9m9HlIImXQzU1M/vS/yGyO63HG8DiJ/vWb+uh3H//T9IyA4hRD
	 LHmNXH5dbPF1f5a6PD6COunVyQVhVzAFmLKrarzr4fRbA4mQYsRv3xiTnLsrX7/jL3
	 WHpFX+yadIsp2XaB8uyt+zH82bPt5Vn2z3z5NgdxkOECEMl6n7PpL7zmNASsxMRVme
	 OdW87Byykc4nbucZ93idCIAIBC9mWbsdzDxSrxwiqiZl0Wrvakg+Vhl50YtatzUzD4
	 wIPQgYElJZvAQ==
Date: Thu, 12 Mar 2026 19:30:38 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kees Cook <kees@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Dinh Nguyen <dinguyen@kernel.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 02/20] tools/testing/vma: add unit tests for
 vma_flags_[empty, diff_pair, and]()
Message-ID: <9198d18c-a1a9-4321-bf34-13e48172eab4@lucifer.local>
References: <cover.1773340636.git.ljs@kernel.org>
 <87517d01b3973aa43f874164d0741d02cb123537.1773340636.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87517d01b3973aa43f874164d0741d02cb123537.1773340636.git.ljs@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 00A07C0019
X-Stat-Signature: 8mxfcqx9wi8e8onwfigky9rojkjghmuo
X-Rspam-User: 
X-HE-Tag: 1773343840-369202
X-HE-Meta: U2FsdGVkX1/IyF6Ifs0XrxTxSQRZqTmvb2IdcxJ0MkfB0IZzgUyk0jfHNu7CaghZoyp8bbSPdRIJiPzSRzyhaWyILAyIpxKL0Y6VQe8HgCZ4EhHNxwhBBLt1SEEstVEDY8U7TQ00bGeQQNNvj6z+yA3Xu1t2FpEQhqEi4Ooqm2VN2yIiUSzQoBbPKOgF/YBcC23fk21EUZxiRykoXWRx/o8D99V2z0BEH8tCJaV64PUCdtvqcVMB8rLHyvrI/5Y3CsrqQj9nAHEA+KAStMfnFqU3NFB3bDpK4nLBSYoG6FfpTrgKgqeiix1GxPCyZMs8f53v2t2XXpNVOLy1XiZgovVuznpQ0I+BMlDRzIvSJ8StRwBmGjU/4ohgxeIMC99F/4vlLPDyfZT8BJLwgRFtG7AXNw0J1UwEuU0ZkrINmRsulXjFZ0Th9u+7iynxL63jf34ZVVohqiPSaBSOxL5o9vHNZKxDHyIzvgjeqIISizy/1CDT/MRMPJvuEExBGLnwlbCVOXgAEvQ1WN8WvsqpUmgt0MdMEojTftD61WTWCWMFacMA+zh0smWHEGAAdfanb/sCnLpX2s0qIT+EF/BV8XMtyzxkzxcWTz++vu2ab3w5J5gzN2dz3UGmAnRDDkbZA5DUfYwllmAoqq1kyNghERWrWJA3kLX5JasY+oSo8idQNUSbZ+fQIF5GICsfQlifd2a2X6tXUcJUP4dkuz7s5eMRSFb8XdRKhXX2bmSB1R1+/PhcF4dcSlZUKLwFo1OBEfO1o+vf+o2e+FiC4F6O93FNZbwZYi4sv02dxWAt//SxC3C9wEf2hHHhgYHqePK+vwfLJyfatBB0AxMvkwS76LMDxM/fUcbcWH9mwMnCg8PoDbt2UgsEPsbTrGTzAJh/3vYy0GxJgJ7nXtgrAp4Hv1GyYsHgFo1NbFPSPoN4MxX2s8DzDfrCHxcSwBca465l2wcHusiSBtMtAHVraPz
 d76uf3yL
 BL0qvtMxWhe47yqt6oA3ztTjwe6JBgaTaeKh09ypxFJspX7xLS94OjI8EUaBvN316aSVZ2eylk/5j8nNDkHKmG6mQjZRkwbzG3FdDj92LUlzeEINctkwC080h6Ct9aeL+02nBj7hkKbCDB325AjiJJa0186UKMe6rmyGyFgHzrHPjEeARMKePugC+7KI/JhvTX2I5hqvt5dKW84QyG2Rpg9+I6q8Av0WAQRkgds/lDp6JgoFUFvC1bgBMEmSUvuhuAh95dq5+LJ+TVtNjwABHyY2s5En8Kwa5gxUx5/f5ScQpXNIzzm2Y1v7QFx2On0Ct8rcYczag5S9WMUM4F7eerXUzpsICHNAKtzs0xO4AXnlCHQjnFizmFAkGdN0Aw82p4qyL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Please ignore this patch, it was sent by mistake, the correct 2/20 is [0])

[0]:https://lore.kernel.org/linux-mm/ae25ef9cd48e20553babaad3868da1cf74f16af1.1773342102.git.ljs@kernel.org/

