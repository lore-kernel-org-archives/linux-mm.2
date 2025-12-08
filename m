Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC6A0D3B7DD
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 08:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2902F6B0005; Mon,  8 Dec 2025 03:43:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2409E6B0007; Mon,  8 Dec 2025 03:43:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E20D6B0008; Mon,  8 Dec 2025 03:43:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F16C26B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:43:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 908051609FD
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:43:42 +0000 (UTC)
X-FDA: 84195665484.25.3E6AFC5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id EC6502000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:43:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qxw06UwZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XQVhkcFe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xPqIkeq4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pDZVdYJW;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765183420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yK0/tInIe5Sj2qH3JVl2XBHL+xgUUc9R4ncCoNXnSU0=;
	b=Gn4jeQTZNrxTEuy77D0lDaaT2UXTsyBN4zGP6a4lxKU2Fg/IRRd4/3Gpkh/pjhKRTg11qw
	CXOQBu/QlqC2qbaCo5f6etD/a2Qt+0hYZgnLfkMlAf61npyZmSlkQhd2r+w3FLD31kFCyZ
	1mSaKhj+EsQDR60UOkKC307QwvF4PYo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765183420; a=rsa-sha256;
	cv=none;
	b=JoCBEIoh3bm5G5RAxJ2rfvRPCgkWDJSZ049bm2+IoKs84ZET9/W5HZ65aDd33YIGaqzvkO
	jE9nrorznJ4+zOyN1N8ZYQlT2q7t/eNcwpIc0mp63HVHNqndZkbsAizhm/q2BhK2lByvGL
	U6BdvPKs5TgtmyZoRzIqYUBv97nvDrU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Qxw06UwZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XQVhkcFe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xPqIkeq4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pDZVdYJW;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 849D65BE9E;
	Mon,  8 Dec 2025 08:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765183417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yK0/tInIe5Sj2qH3JVl2XBHL+xgUUc9R4ncCoNXnSU0=;
	b=Qxw06UwZS5qHNayoN84eTuuEJ6F0YgGveCxb9ZOORmPLYSqXUO1LWmoQNCqyzeDbUywIrt
	OJCuAnS5nA8ekH84BXz6IEZ6/sBXt1Z3J2AlK2qzkWk1nOtlpZEIbq39lHfoM5GPlET8+e
	0KuMGzZ5P2csMCaQXN2LKxNLiCs2eIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765183417;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yK0/tInIe5Sj2qH3JVl2XBHL+xgUUc9R4ncCoNXnSU0=;
	b=XQVhkcFe4oAh5UPqVbLz27j6JA9DBob8cQ05m8rIum+7xzc06LyLgJPjT9SPZlpTyrfDeN
	kErtWPv9T/dBzHBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765183416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yK0/tInIe5Sj2qH3JVl2XBHL+xgUUc9R4ncCoNXnSU0=;
	b=xPqIkeq4/TtH5fjRyHywquhhlnSg8/Fxy8bZr03pv8viiAevOyMnIom8WgbWbH++TEt9AZ
	kYvI5EyjSuKAijyjXk/MgCiEEyl8pOfjiVaNv1g/vsk335KF8sHFbpuOzJ+wl3K8sX4TLk
	AV28/reQBE63us3h8C0JRTEGOD9OzQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765183416;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yK0/tInIe5Sj2qH3JVl2XBHL+xgUUc9R4ncCoNXnSU0=;
	b=pDZVdYJWDRQRqzbSZUgWu3LKhzmU9zU1tMR0Qwxcv2fVahBPz8vqRlnpcJfxtFHbRANHwg
	xQFrBUj3ApRtNuDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE7B53EA63;
	Mon,  8 Dec 2025 08:43:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Kf67ObePNmkjcAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 08 Dec 2025 08:43:35 +0000
Message-ID: <c68efe59-5405-4be5-a768-f27ce27d59d7@suse.cz>
Date: Mon, 8 Dec 2025 09:43:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/13] KVM: guest_memfd: Add flag to remove from direct
 map
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oupton@kernel.org" <oupton@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@kernel.org" <david@kernel.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
 "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com"
 <riel@surriel.com>, "baohua@kernel.org" <baohua@kernel.org>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "jgross@suse.com" <jgross@suse.com>,
 "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "prsampat@amd.com" <prsampat@amd.com>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
 "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
 "jmattson@google.com" <jmattson@google.com>,
 "jthoughton@google.com" <jthoughton@google.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "vannapurve@google.com" <vannapurve@google.com>,
 "jackmanb@google.com" <jackmanb@google.com>,
 "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
 "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 "Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
 <xmarcalx@amazon.co.uk>
References: <20251205165743.9341-1-kalyazin@amazon.com>
 <20251205165743.9341-6-kalyazin@amazon.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251205165743.9341-6-kalyazin@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EC6502000A
X-Stat-Signature: hauza3hewc58njzt1hzxtfxai74dpoxb
X-Rspam-User: 
X-HE-Tag: 1765183419-601941
X-HE-Meta: U2FsdGVkX19u7Vzaen+D1MoRa4V5+Zga2lID79BU3/hFKW+9/fLDiuwCgDWHfkdufI+p4elg+lsBD8Z1PwNbs6uTX7/D4513JsszdPogECZCp3dQmCelAdohmxKf2u+2oxq5EdvyGmLivBxKG3iTBtF3IpvaaPKjkYA/cZlqjk4JodQHAILmOw+xouLNtwX92SLPC+t99Xde7ELQ0o/TPjFgMmaCit/DDvfYd/HKAS+vBSiaHSBbSYuI9v+3reXts5odmhvoX1o5Vx5rZSzqzrQ6Jnzf73ocEkfcNjm0F7sOB0VI4XGwD5voB5Rb+hImo29Zxk7wjNYovz7nBtXJMPu6mARZCYcSSVEn+r84eVl4vo4BPLDqQ8gE98dfyS7H9KxNc5S8SseSjIawACtwXZQNHw5UPNHz6ZKSCVBMZFaUm4EeJCOK/PwlwC7UxNsjE7gafAXGtlnm5sZUDrBWozVI2QZL0dlchc9LWMHW10m9jOH26H/+NxOGwfZXBttJSX2I4YNdOXFI30z3wwhuvSYFWpIsVP+Z9Zd0S0mpuGH/PWTNGyDQ665Z+bba0H3LWG7XvntFumjozl1vyBSF7jyzjnbGnIL+VfGhQC5YP6vVAA3G9QUgf2Xcq9ToZsPhdHJ2ZoGGeyuOvXWSjTISCdotHW/MzA/ldogruL9GA+Tohl2SrqM5byfUC+lhr4i8a+mRc0jH5mFgUSFxJyexGNp3iivXIrSuGr0poPc5CqmlZiTAzjl1loZI1tiP5UPfbzSgn+P4oj6iH32H3wTZ0srixpk6Y/p0YoYp0ilo2j/cmMhkU/FoHrgRgnrEw63dcUHGELSu7A+cRgvKjCbR+aHGBREVRiaSi9fe4/9ggJ/o9syegtEWRixB3zW/p1/PSLcg4ETQxxGDVc7gF8xfYf3w1zhVylOQUBLQ1GklVtLP2Mmhq+0MsuMTtDOSpbJiRclzEynEv3279LHvHKj
 3PohS8fk
 vSIU/for951FFBmJy3hIAAzOfjMTaC0feK67dh0zp1U3p6EqQDofxGdLeAMNrOt4f1g340QXZRSvfAc8lax8rhTRdlsrZM4EGCbLnMZMadOYArnJOPt+4QbQHC8Ex8xHHyvxNPig9AfnEf9sTvYK/PFBxADMGA1IkU/Gcdl0YHxo7AjWipqJHXWVUcQAsfiUgFQYRsjBjBl2ZdmbFUVxKY0IamK6hy9i17QlYZpc9KgFZNYfDGHmul2Mtf6oEbkjViv81YgDhMnGayszvJkz2g4ICPgDU1am+9ls3NBBRbvY4ElUkR81T/Hj4wiUQvUChG9/7HP7VWLfgPo4WbL9HVLyr1u9sBDCkb8I1WVqQ5aB/TynXdJZI6PmdGJhOSEzQLOWszQ5v/VKIiDa8tET5SBIVx4FFCGmXl+lZotKu8zLC0reyV2X5V40iDz0PONUD3LnS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/5/25 17:58, Kalyazin, Nikita wrote:
> +static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
> +{
> +	int r = 0;
> +	unsigned long addr = (unsigned long) folio_address(folio);
> +	u64 gmem_flags = GMEM_I(folio_inode(folio))->flags;
> +
> +	if (kvm_gmem_folio_no_direct_map(folio) || !(gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP))
> +		goto out;
> +
> +	r = set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(folio),
> +					 false);
> +
> +	if (r)
> +		goto out;
> +
> +	folio->private = (void *) KVM_GMEM_FOLIO_NO_DIRECT_MAP;

With Dave's suggestion on patch 1/13 to have folio_zap_direct_map(), setting
this folio->private flag wouldn't be possible between the zap and tlb flush,
but it's not an issue to set it before the zap, right?

> +	flush_tlb_kernel_range(addr, addr + folio_size(folio));
> +
> +out:
> +	return r;
> +}
> +
> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
> +{
> +	/*
> +	 * Direct map restoration cannot fail, as the only error condition
> +	 * for direct map manipulation is failure to allocate page tables
> +	 * when splitting huge pages, but this split would have already
> +	 * happened in set_direct_map_invalid_noflush() in kvm_gmem_folio_zap_direct_map().
> +	 * Thus set_direct_map_valid_noflush() here only updates prot bits.
> +	 */
> +	if (kvm_gmem_folio_no_direct_map(folio))
> +		set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(folio),
> +					 true);

I think you're missing here clearing KVM_GMEM_FOLIO_NO_DIRECT_MAP from
folio->private, which means if there's another
kvm_gmem_folio_zap_direct_map() call on it in the future, it will do nothing?

> +}
> +
>  static inline void kvm_gmem_mark_prepared(struct folio *folio)
>  {
>  	folio_mark_uptodate(folio);
> @@ -398,6 +444,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	struct folio *folio;
>  	vm_fault_t ret = VM_FAULT_LOCKED;
> +	int err;
>  
>  	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>  		return VM_FAULT_SIGBUS;
> @@ -423,6 +470,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  		kvm_gmem_mark_prepared(folio);
>  	}
>  
> +	err = kvm_gmem_folio_zap_direct_map(folio);
> +	if (err) {
> +		ret = vmf_error(err);
> +		goto out_folio;
> +	}
> +
>  	vmf->page = folio_file_page(folio, vmf->pgoff);
>  
>  out_folio:
> @@ -533,6 +586,8 @@ static void kvm_gmem_free_folio(struct folio *folio)
>  	kvm_pfn_t pfn = page_to_pfn(page);
>  	int order = folio_order(folio);
>  
> +	kvm_gmem_folio_restore_direct_map(folio);
> +
>  	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
>  }
>  
> @@ -596,6 +651,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	/* Unmovable mappings are supposed to be marked unevictable as well. */
>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>  
> +	if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
> +		mapping_set_no_direct_map(inode->i_mapping);
> +
>  	GMEM_I(inode)->flags = flags;
>  
>  	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
> @@ -807,6 +865,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	if (!is_prepared)
>  		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>  
> +	kvm_gmem_folio_zap_direct_map(folio);
> +
>  	folio_unlock(folio);
>  
>  	if (!r)


