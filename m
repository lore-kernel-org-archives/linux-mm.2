Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BD810BA43F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232046B009F; Fri, 27 Mar 2026 04:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209436B00A7; Fri, 27 Mar 2026 04:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146666B00A9; Fri, 27 Mar 2026 04:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0815E6B009F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:27:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A90EA5E135
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:27:33 +0000 (UTC)
X-FDA: 84591163986.18.BA687DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2BCE840006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:27:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R1FdErCm;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774600052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DoxlJLpzOFREqNzYvxXK+7Wyu48MgzL3nY3gxnlOqXc=;
	b=qagfMecU/kL2Y/QVY+xGJm1Z/94Pew+mVv+YNnJkifmAjeI98g2ZA7pBee0LUA1EDboWMh
	ec9PbAxIE65gXu4yATfB7KvSO6Acfty6LyfI1vRaGXeGTN9wUzumI9+DLUswa8XExrVX4A
	a4kg7o+bZw42T5e6AwOsEIwLoq2z1pQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R1FdErCm;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774600052; a=rsa-sha256;
	cv=none;
	b=pXhG8Y8kzWrXBdYA4TH6/KhpitS92ZJdOMa5fMTRoBQ7oZN9hCMCwTOZ+bQKza+GIOqn4j
	OhCkHBPfG3ofbMvJWWaBL/gzgarjnIKvf7oPUM655ZxVWn79PfPhwEEUJN9lLJ3iC4LVRW
	3vuObomPdbbI2pSa6ht1oI7axyEYq8U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DE7C6132B;
	Fri, 27 Mar 2026 08:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE27CC2BC87;
	Fri, 27 Mar 2026 08:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774600050;
	bh=rkUuEott97cRG5EOSGam/2vURy0iz3AdOFQvnDvFuRk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R1FdErCmpRUfW0Lp5ZacGDOniuT0AwJlAxVfVuljmrw2wCU7cAUPkqPI98IpTty16
	 NBIRt4fVUPiLgcyTUvdyX/EfQJaP/Fn+rUGOf8JpxGhClHrnG7f8KRPoQz2OYh1WaJ
	 H5o9DZM6WUru2OjwRibUTWgPS0u+3sPFUJBa/UzXV6LBqi+UjomHjJiBFcJiETq+MT
	 87z1mRd67LAk1ZwXpjMe9nbD7JZY1/qttMJlLYp/x5WS7qVfoyPw2boeixrn5xIQMI
	 FsKHOJV0ipEd+DPBQwi0B3HVifAvbXhgvRqUcdTuwlnZX1A9XjKSccTw9hYhAHIm+3
	 pgbO2wr7F/yFQ==
Message-ID: <c9bec45c-3312-46a7-a7bc-a7dba95bcda7@kernel.org>
Date: Fri, 27 Mar 2026 09:27:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/25] mm/vma: convert vm_flags_t to vma_flags_t in vma
 code
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
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
References: <cover.1774034900.git.ljs@kernel.org>
 <20260326225031.87e04d2c652923bc10aef0ee@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260326225031.87e04d2c652923bc10aef0ee@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2BCE840006
X-Stat-Signature: oakmiz1edgg61ip78tnbf6u3dcrh4z3s
X-Rspam-User: 
X-HE-Tag: 1774600051-387999
X-HE-Meta: U2FsdGVkX1/z3Nw7jw8+n2nXm1WFvtUFBseTCn5Aik53SUJQgcpgRtPpX6zqOGaM8ufD9xTJG1oc0pmMDKRvRS/ne0p2gOIgqIQIb8mIcm5xV/Dpkfr853vzppN6uky8BlEMieMcer3NSIBpMTBvgZwYl3iyAELYB2v0DVmFaFT1kTx9vIm2GwboSJpfOCid305TC3ZmCp4VUt2wkomXMIY37uMftlEYbFDfcFl51SGg/Y2MDU8/vZw7mIoSy2qxxM+JyTCGsJ5QLkCzj6he0lMdm1t+v5JRBOzVnpPUBo6+EOH0w5kkpPhiOpWENrZMskYLBnBfDBy7EiYzu+7qLqHKTA81Xb4DofnlNnf2ogiSoVt8Xyt2TAw1XR7sz2IGu9ZwSt0wioIdhasg2BdwXuVbGinFrEgAODI2ThrKcngMxFkvqqX9fU3rnpgvOo9Ii/kCVSMg8xUR7WxRVteOsdyYNkP3PAVHiz1HLDtZMzj3B8gbzLqMQzOkG2GjhMvuaU9y4oit39r6pUHxzQRyZJPGVy7V4pQ4zzePekIy7ffNKU+iVA8EHKPhuz3+gvOG3fv0nI2ZPKTakMQYaaPaP70pQLO47XgYoJBDpNb8euSt3R5TTmTguRwRSsEGEqwqjwt8/Gl5UiCEkmS76gDx/mgA7X6wiovfsQL/HfSOHKyBLiy5I+Wyn5FbEEfCueJCop7gI7d8JY7HpOiLILfKRy0U1iswXFiVYwWynw6o6OzMYFQUD1eZX6nns4SYnk+nqnkQT5JsDyazst36aqD9uZyN5cqnZPwdHmf6hpT82vJ38WmyZzb7J+Wct6QOsxFJMssl94OCTT9ehvgWlDnxk20z/ltGb2KXdi+HDrsPN0N7hCPv+WSq5QMmEQjPBcBUVxJ2XtIIWuU0lpsB9EYE3E+w+YcBDMxKmqrnDhlQM/xhDkfessBWgewDFHlIWPw5NM+GLnEr+Lvd5h7orys
 5RiyaHrZ
 OP6aDWRMmYrU5xvzCIGJA2gc1yumKHCX2icwjtAPoginAND/LIZYjOd47t9hLkHOA4pi2ER8tZaBmMy4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 06:50, Andrew Morton wrote:
> On Fri, 20 Mar 2026 19:38:17 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> 
>> This series converts a lot of the existing use of the legacy vm_flags_t
>> data type to the new vma_flags_t type which replaces it.
> 
> Series has nine unreviewed patches.

I think I only skipped those that were tools/testing only, because I'm lazy.
In case a tag is missing in a non-test patch, let me know please.

> Again, I plan to upstream this as-is - lots of Lorenzopatches remain
> unreviewed and I'm OK with that.

Ack, thanks!

