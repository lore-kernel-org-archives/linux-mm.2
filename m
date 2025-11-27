Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 870A8D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:52:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73C16B002B; Thu, 27 Nov 2025 05:52:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4B986B002C; Thu, 27 Nov 2025 05:52:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61226B002D; Thu, 27 Nov 2025 05:52:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C46D36B002B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:52:58 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 713C58A5AC
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:52:58 +0000 (UTC)
X-FDA: 84156074436.24.F04EC89
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2805B40007
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:52:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764240776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dSkfS1PH0V2GqQ7JwCU589oUysx1YAYg5wc2qE7DJO8=;
	b=Kj1AITcbB5NyqoWQrbaj8oLDZUsMsMSLVYQUiZbvw+TfqFM68bt10NWYGsL24lCXqKXwCZ
	VMxcnd9mU6R6SkWAwbLF04o2pIyEInf0ONY8qZPqyqtcYQlKDN7kRyXURkRG10wXLpw9gg
	1NWqFR/O52ZMMgtX0eCj36/peSZimVE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764240776; a=rsa-sha256;
	cv=none;
	b=p/5OQKGycXrPg2DSX35Wsqn6+tGJuk/i1xcEKZYfu2FbKTut6jc0jul1uBITvVTCY8dajo
	opFj1cKAaG6t+ZBWmu/6F74pGzcqu6Qs0eskQlp0vCggcvYU1CpllRbO+1FA3wGslKTELr
	HmRZpKF30wim+od1NxfuiskoSmArLg4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7B48433693;
	Thu, 27 Nov 2025 10:52:54 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0C7F3EA63;
	Thu, 27 Nov 2025 10:52:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xrDGJ4ItKGlFNgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 27 Nov 2025 10:52:50 +0000
Date: Thu, 27 Nov 2025 10:52:49 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	Oven Liyang <liyangouwen1@oppo.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Wilcox <willy@infradead.org>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ada Couprie Diaz <ada.coupriediaz@arm.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kristina =?utf-8?Q?Mart=C5=A1enko?= <kristina.martsenko@arm.com>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	Wentao Guan <guanwentao@uniontech.com>, Thorsten Blum <thorsten.blum@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Yunhui Cui <cuiyunhui@bytedance.com>, 
	Nam Cao <namcao@linutronix.de>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <v-songbaohua@oppo.com>
Subject: Re: [RFC PATCH 1/2] mm/filemap: Retry fault by VMA lock if the lock
 was released for I/O
Message-ID: <5by7tko4v3kqvvpu4fdsgpw42yl5ed5qisbaz3la4an52hq4j2@v75fagey6gva>
References: <20251127011438.6918-1-21cnbao@gmail.com>
 <20251127011438.6918-2-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127011438.6918-2-21cnbao@gmail.com>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2805B40007
X-Rspamd-Server: rspam02
X-Stat-Signature: cp7rz6hswnuymj91q6akie9c4z39xg47
X-Rspam-User: 
X-HE-Tag: 1764240775-285846
X-HE-Meta: U2FsdGVkX18qXVwWqymX71nbnNsoNkKN5r+AXlUTXVQOK22KZklZ1J/520WFq5TFA2YfA+MDZjTkkkp+xy2ynXWnEN/IwLsLdSs5FuTf8Gl3Q+yCYISIlLBXss/SXnUMU6Bpo7gqhkEigSmfteNSJCRCKccM1Y2g4iXjdS9nbCzrLAoxZfW9kjXD20hkF23sHew90brNWpuOQupF4qfA3esbYZ52v/DZUy0rsxS+54AoBRDMSBxq8RYlAK0xLltFQcWs6UFsZH8kCVw9uV2H1pbXyQMPUfmj+2fpz7rjlbUSBqslWH6qc2dkp9JivNdki8kTOdlQB17UKjvxgrvEQa5XwhDLxejJgvlVX3BmD+3BlmESDv9s7MjnL2TPsJ7xPOCMEpXO+p+J113ZDsYfR05JxtY89MHpvkAPgVnTTa/kIj/yy/y78+ziCY6+JfKgrDnbq7dvXNH79FNH71Wz1uzMYq0NSFS35iFXCK7JZ9XGvXkuMNg3wTlIWaW0SCis/cUs5l3kjHNxwRExGRmLw7nlVL/mXcxhldgIfyWprgDydsFDs2xAIeJZ4a8Of2ljB+gYox04njE+pMka8OvroWAHcqOHKJQTOIKYafGjozo8Pi8s9ihtxkmrOXU8C4xS6nJq6o+PwcS66CKHphtIFzPtGpPESu6beFVfUKswiYjyFYnxmUZBgRCDUOBB5Ze3anke3CMAj+1kmLklI5fxoXQv/SqdKT9PsNQxAYCbKCfCq16fiMahQfSUZ8ctUc2acYPUuxYb/2aVm2OZbbg6TvODHMDKTZMk/h6TzCHsX8WbmIBc3LchUYK5Etrq1hEKxoI0gUh9Ne+hIJkO2HxTFhUv/t0vb16X4tT9+kctCBEy+/nll1Xaq/n5LVNFkT5AGdlpfPO2MBDnG9DU3pN0iqwYkwlqphy51iXWjXXSA6K88HIPzI2iU8UquV3Gi3Uht+bUpklCP53CUYdpSZk
 ir77TWyZ
 VRQknQOdHKI9kSUk8/iGee01beBeYShqWYswUtNDbtX2VqLd2fro58OIjflGNssrs4V495y6FvHHVJjB5Am3C8HuAS+efqZ8Rojtcw+3wUX9U3V1mp7rryKxqokXt1yk9PqsbUdVmxZ3OsfvlXYcYxQoKgeC4WM5+/B2RW281udCTeLcqda/eOEOa4uNO1QgTUCG4LMVs+4zPLqHDN0sMZAAGIt9F5SfTQTfk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 09:14:37AM +0800, Barry Song wrote:
> From: Oven Liyang <liyangouwen1@oppo.com>
> 
> If the current page fault is using the per-VMA lock, and we only released
> the lock to wait for I/O completion (e.g., using folio_lock()), then when
> the fault is retried after the I/O completes, it should still qualify for
> the per-VMA-lock path.
> 
<snip>
> Signed-off-by: Oven Liyang <liyangouwen1@oppo.com>
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> ---
>  arch/arm/mm/fault.c       | 5 +++++
>  arch/arm64/mm/fault.c     | 5 +++++
>  arch/loongarch/mm/fault.c | 4 ++++
>  arch/powerpc/mm/fault.c   | 5 ++++-
>  arch/riscv/mm/fault.c     | 4 ++++
>  arch/s390/mm/fault.c      | 4 ++++
>  arch/x86/mm/fault.c       | 4 ++++

If only we could unify all these paths :(

>  include/linux/mm_types.h  | 9 +++++----
>  mm/filemap.c              | 5 ++++-
>  9 files changed, 39 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index b71625378ce3..12b2d65ef1b9 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1670,10 +1670,11 @@ enum vm_fault_reason {
>  	VM_FAULT_NOPAGE         = (__force vm_fault_t)0x000100,
>  	VM_FAULT_LOCKED         = (__force vm_fault_t)0x000200,
>  	VM_FAULT_RETRY          = (__force vm_fault_t)0x000400,
> -	VM_FAULT_FALLBACK       = (__force vm_fault_t)0x000800,
> -	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
> -	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
> -	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
> +	VM_FAULT_RETRY_VMA      = (__force vm_fault_t)0x000800,

So, what I am wondering here is why we need one more fault flag versus
just blindly doing this on a plain-old RETRY. Is there any particular
reason why? I can't think of one. 

I would also like to see performance numbers.

The rest of the patch looks OK to me.

-- 
Pedro

