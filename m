Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5F5610BA42B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 05:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00BE6B0095; Fri, 27 Mar 2026 01:50:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8956B0096; Fri, 27 Mar 2026 01:50:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16046B0098; Fri, 27 Mar 2026 01:50:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D421C6B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:50:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9BF451B93AB
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:50:36 +0000 (UTC)
X-FDA: 84590768472.26.6A3EE58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B6AC9140002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:50:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Z1oPSHRy;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774590634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlWPsRZ5eg4ebr0CP6MSk8XH8PhzWTV6BknR665dbRI=;
	b=CjcaPW1MzTXj0u2QfkOPLvtHyCpao7e6EL0OTptIIEUx4D3OlspOx0x/7ZlZ/RDLKgkZPA
	yeOIO4TcwP4i3/Uy+2EwKOxg2oH84loTZGQoDImyeJs8aqjoCDe7vWwOvcsHsOThcskrJV
	k3+Wn2towP6SfNdmQjL9n0gO0YoLj6A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774590634; a=rsa-sha256;
	cv=none;
	b=v8tulLi333RUOXl4sMk6SE9dYhUDbH5wsdyad/Mhs2WKDklFpj5CR3qb0b+z3tukRtQ1Ni
	yhgJlnaL0QDrJDNfv+vzgCql/jJYMrC1YrI2Vz8GoeQ2WjInImeBqfm/bxZwdD5uS57PJI
	aUUEHSFWYEyvoJjZFzBcKCfKLjySbNM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Z1oPSHRy;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B84FC60134;
	Fri, 27 Mar 2026 05:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF49C2BCB1;
	Fri, 27 Mar 2026 05:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774590633;
	bh=dlWPsRZ5eg4ebr0CP6MSk8XH8PhzWTV6BknR665dbRI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Z1oPSHRysMy+6wXBJFXG9mFzlDuQc+AG+9J9n6b3eqNtsV8pZVMQ81vG2zjJgE3r9
	 Vwk8DGJTLM5wMJYNlTCMV3P4HxBM5Fzh2kN4K4FctjtR5IEakY8OgdYhQKEYI2Hecn
	 asywffkE1Ac9oHnjQ0d+0ALgtZqNzZ21R6Hlrgko=
Date: Thu, 26 Mar 2026 22:50:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Kees Cook
 <kees@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vineet
 Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Brian
 Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Dinh
 Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin"
 <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Michal
 Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley
 <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 selinux@vger.kernel.org
Subject: Re: [PATCH v4 00/25] mm/vma: convert vm_flags_t to vma_flags_t in
 vma code
Message-Id: <20260326225031.87e04d2c652923bc10aef0ee@linux-foundation.org>
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B6AC9140002
X-Stat-Signature: 4qcc1zcsb5dz7pygctaneqsbwso6g3ns
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774590634-973381
X-HE-Meta: U2FsdGVkX1++onl7woA+71sXui0ihXOhzBTn7nBA3w/Nz/AUsiWnZR2NEFYzhoNMYDVM/GdBz+zabILRuAg6jOM0pxNm98zyGaLRvEgvgv5Jfrea1kjxJdb9V6AFyE+usDeg5DIOYhiwUuI8plJG5dSCPyCvaVFBUTvFS5sxYuTAE4eW4ozakU02LEoIyD3XRhAqwheJIomUBmc6tkIowRXDjTNoJ/JCjM/Lp6q47si2xTR9AtcqQd84LmAvmgda+0mgJZulqKAJZk5lOE8ph8SY7uwWEpACBdccqBJtjbRUjf3zGW68xWo3e2MuLf7JZst4Imi6CnICiuepUtPsDp+nxZv1I2/YJeH+njY5UdD5dXj1yF3Mfrv50zP457AAsu7aUiklx/+F3m1u2UY9jLqC66Yf71/IVXR7hr8SPDkx2YzmmyCcE/qb5ZhgYx9QH+tsYuh5fXmB5+ULFvWP4bD/Xl/OkjBto/kw2JllyD/9EOT2DjBVmYaobMGt7tmOc5mp5QC8cAlGMhtDHKFmcYex7e0ARFxzD8Ny8G2c9aAXbKkZP4cPnaMQ10R6ajsGX3Z/AdGJofBRmwCBhxCirkDE3+wwcFPphMVzQ604gexJX53tHo3/eR3ByHstc1CIHsmtVQT4F/iPJrnzmQwb9dyPhhyFU7sjL3vEEkNGiimucwXyUWvYdHBJIWSEHs0olHx1bIOR5j/tN9vkFMyNIG1ZzXr0OWWoVnRB8VlEB5fwKTPeS4+LtLv2W69c4yUYiEL+V/Euf83Lm1HdmQb72uEihKOEHzamU1hfMVyeHkEV0llgLsZU5+1p9dXTmBsQpJAtfY5YrN+ouXmAI7Cj95DRDkLq0mOwK+jme07tydKaIJS/LzYBF+uxGDtTgK17/XDowkCj9bhEfNfc6Oj6r7exUiHFzGcbAfDI2HeU5901miAOAJTifmV2+bfm1uwLG/W0z74jxUIxtlW7dqS
 F0RHUESW
 IPkyc3I51m+dHhTokZD392bbSX3w3muM5sz4V/uhrdKpV/70TtwKzDFwRk7gYnqJyw/LhUhGi4chGjiucHVYswHwn2sbJNuZjohu4aiEDQG30SsaRHneaYIXSUYV6Y42G7Hd5fiwu7MLDJhL+S1KODPP/nFItHQJo1dlRiEOxfcrd5pNOCqMDaUYnCRXvivbAGZwYGOj318s0lCa9O9hvop8v1YdP5MC2SDIi4ob2WKM1EsrBWK544nkA2p7as8IrBvalRfX4tN48304Kb5UPG23UbNa//IK7MFiTSiXReeRJ2994DImQL1/hCsocLeIeZsi2dZV3dQBTJreOvClkXe8RFEIVA77o1Jk6vViACKpJDnz+JEBM2cQ/+x50TMZYx+aJMJOPOW7Dl48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 19:38:17 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> This series converts a lot of the existing use of the legacy vm_flags_t
> data type to the new vma_flags_t type which replaces it.

Series has nine unreviewed patches.

Again, I plan to upstream this as-is - lots of Lorenzopatches remain
unreviewed and I'm OK with that.

