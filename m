Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26446CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 13:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7E980055; Mon, 27 Oct 2025 09:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257428000A; Mon, 27 Oct 2025 09:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146DE80055; Mon, 27 Oct 2025 09:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 03EB38000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:39:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6AB1160112
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 13:39:26 +0000 (UTC)
X-FDA: 84044001132.04.CFB46E9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 39442160002
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 13:39:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uAJW/z40";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FP44aS9i;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uAJW/z40";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FP44aS9i;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761572364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i27u97N4e73GoXPAJTcuvMQHbHuPQ9/roOonBRBxYNQ=;
	b=X6Md275YDUrbpz1kzdI+BmDmSDq7Df8Xm+S2iOZdukistWM4vtMJh7UwXJz7jnA+w+DUXp
	1el334ruZsL6z4xs8W8XYYuHE+V7hQ9OICi1g5ca/6lSDIh66DcR4jczqdGRxvZ7D+r+aE
	2DI6DVI8M6vROpbt1LLzoMkrWjilav0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uAJW/z40";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FP44aS9i;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uAJW/z40";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FP44aS9i;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761572364; a=rsa-sha256;
	cv=none;
	b=LWvqS9iYB0uRI2FaKKW1hDPOmFE5TiAkLgn575tmbZnoXtGvTLmrjV07kPk5Wl879IuTDH
	C9JB3Qai7fgf42kopj/ul9vlF95krouhO512qoVMtI7FzydtO4ucAIPlg9PAEsge0s9isy
	sZCIejsOd0m88YBtH1NMrjivQ0GwIJ8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EA91A21B21;
	Mon, 27 Oct 2025 13:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761572362; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i27u97N4e73GoXPAJTcuvMQHbHuPQ9/roOonBRBxYNQ=;
	b=uAJW/z40YgANMYhmD50708FHkiKIs2E+rgLkpZiPOVKlkoft9lcSiCB+KMwvkdTBJuBdzG
	1UhGzq2JqoZjgk64YQEoitm2O+xU7kyYAzyXFfjZqOQD1GrLbQyjfVVeN1pq0lbMHR0hXh
	0oM2jHeDfCNTIQWopnQnaAudiOnYeFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761572362;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i27u97N4e73GoXPAJTcuvMQHbHuPQ9/roOonBRBxYNQ=;
	b=FP44aS9ioBrt+HRJvuoeyP4iKpqxYiMu9h1hjOQq5L0lX0/5TSitUuEAxeFuZ1UVlMVZLq
	5EXBdVJuMsSgBtDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761572362; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i27u97N4e73GoXPAJTcuvMQHbHuPQ9/roOonBRBxYNQ=;
	b=uAJW/z40YgANMYhmD50708FHkiKIs2E+rgLkpZiPOVKlkoft9lcSiCB+KMwvkdTBJuBdzG
	1UhGzq2JqoZjgk64YQEoitm2O+xU7kyYAzyXFfjZqOQD1GrLbQyjfVVeN1pq0lbMHR0hXh
	0oM2jHeDfCNTIQWopnQnaAudiOnYeFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761572362;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i27u97N4e73GoXPAJTcuvMQHbHuPQ9/roOonBRBxYNQ=;
	b=FP44aS9ioBrt+HRJvuoeyP4iKpqxYiMu9h1hjOQq5L0lX0/5TSitUuEAxeFuZ1UVlMVZLq
	5EXBdVJuMsSgBtDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 60BDB136CF;
	Mon, 27 Oct 2025 13:39:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lfDsFgl2/2gIWwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 27 Oct 2025 13:39:21 +0000
Message-ID: <b73fdd99-befe-4e2b-b029-909c4b31902b@suse.cz>
Date: Mon, 27 Oct 2025 14:39:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 08/37] KVM: guest_memfd: Don't set FGP_ACCESSED
 when getting folios
Content-Language: en-US
To: Ackerley Tng <ackerleytng@google.com>, cgroups@vger.kernel.org,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de,
 brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org,
 corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com,
 david@redhat.com, dmatlack@google.com, erdemaktas@google.com,
 fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org,
 hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com,
 jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com,
 jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com,
 kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev,
 liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
 mail@maciej.szmigiero.name, maobibo@loongson.cn,
 mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org,
 mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com,
 mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev,
 nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev,
 palmer@dabbelt.com, pankaj.gupta@amd.com, paul.walmsley@sifive.com,
 pbonzini@redhat.com, peterx@redhat.com, pgonda@google.com, prsampat@amd.com,
 pvorel@suse.cz, qperret@google.com, richard.weiyang@gmail.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, rostedt@goodmis.org,
 roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com,
 shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com,
 steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com,
 tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com,
 viro@zeniv.linux.org.uk, vkuznets@redhat.com, wei.w.wang@intel.com,
 will@kernel.org, willy@infradead.org, wyihan@google.com,
 xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com,
 yuzenghui@huawei.com, zhiquan1.li@intel.com
References: <cover.1760731772.git.ackerleytng@google.com>
 <dc5f58f5d3427b6291486a24061b6301761dda3d.1760731772.git.ackerleytng@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <dc5f58f5d3427b6291486a24061b6301761dda3d.1760731772.git.ackerleytng@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 39442160002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: x43rjkw74ippntrob8dgujnk3anmqxzk
X-HE-Tag: 1761572364-701668
X-HE-Meta: U2FsdGVkX19YqmusWoxqy8I5BKIudNNOGETK1X8c7+EAryGtZaRs6eNrBQtmsK7cfu/7pFpUcbZn95tzd8fuV//Yn+Y1qIDi/BhHVR3q1BBwBYrjKrsOdaD+c589TjgfmreFtQ8M+WOdTQO8mREpOiNjwDSvFVohj/MaIt50QbcL/Ebze+AxAoLZZ2JX09E0WDVeILKBuPiEImyoKivQBK2zP5p1V3QMtFWQud6L5s94NQK6Ws6P8TOf7tIOQ3M8AfNvVdpWeikHZrbYCCMkg5w31gIDPCDX8zkBPiRfO9vmwNPvMiGe0zICUn9IU36xni4w90awv8zEG2EJCz3uJ7EepSazr3p6IkZsrfXL8LeGn+/dJC5yf3VXMHI42iUH3x4Jm+lMBOJnWYapbLglQ9ZgzXfQtWSnBsR8CAUrZ/pzEnknpjPE4RQIAJvcmLs0kBPEXJbEJAN2lvjvoowCwjggd+pe7fX5qqPCTSmGno4iaHfOQvjdsgeYyVd5Kqig1Wj81ErQplzEjkfYmZi+3gaufXnv7njjaFl/CT4xJnWI8JcIHeleMxSGVXTRz7rY0pCRGG7uFeIhRuVd4qKMVD2HBd32cBZA1oVOi1L6EA+1gpk+A7d5mfttsivk4Nnz6WWA9rcXrCs4/perNNivXcHsc9IWlKaEFXpMQAOPoHxs2Zj+Bd6bXq2ckBvZEkS0X4j8Mq2wXf1tG4++QUKpoZ2xEhLU/MxWk4hHA5Wg9u7wTtSYKhbxTM9ysQF1jRm9A9mFz1XYccHNH8W/5oBY0gsA1iWC39BpjydgqzDozqce33dzUZ5euu4RCmcTwrw+i6PzdhjqEZ1Vmm/EojRUAyJvpswOG7lnogTdvVwolC7iqd9cVg6t+jAl5Lw/Y7WBzA+soEbPE+7P2QCBqgC7zzml2ftgNOr64zF+xHSL81g1SutoLWFzolzM3wIi1UxsyAcbLwnQajKgVl4fu8v
 X8Brgaq+
 PCosCoTT1m8FQnucxRZv1cr8+rak5OkwAmnYKA+fP4KveTx9kNbJQxXoOMgkPQvxIokr2WYtu4DGGnERDLk8cHfPh03qS1pO0iZjrqI2QTkH8NDgrpkYwDi7ysmxD8PMzdawakk/FT+wDwCNrrYur5N/k1Oo4SD/pwWjbYJta3JMpbrjxVDmxDjSv13KEgM8X9O95CVhJDLK7CUCDU3hvUbQXiQuURFo37Z9ebyzsi7VoI6XGQFKIaUctr4cxnPp66aaRzGD3GTeQ6hA22/6n0RK1wLL+DDW6M0S/0CO9eRuA2J15Rfsm79oramm+AxVzfV8ADDCgDCeRz/w9RYwe99RBOlXsO8KQGObXCM6jaW1+FfOqYL/hlba/i4+/POvPy6aIT4zd/rw6QUe61E02V48eXYo9aesUkufgI8pivNquscs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/17/25 22:11, Ackerley Tng wrote:
> guest_memfd folios don't care about accessed flags since the memory is
> unevictable and there is no storage to write back to, hence, cleanup the
> allocation path by not setting FGP_ACCESSED.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> [sean: split to separate patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  virt/kvm/guest_memfd.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 855e682041311..2a9e9220a48aa 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -167,14 +167,13 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  	 * Fast-path: See if folio is already present in mapping to avoid
>  	 * policy_lookup.
>  	 */
> -	folio = __filemap_get_folio(inode->i_mapping, index,
> -				    FGP_LOCK | FGP_ACCESSED, 0);
> +	folio = filemap_lock_folio(inode->i_mapping, index);
>  	if (!IS_ERR(folio))
>  		return folio;
>  
>  	policy = kvm_gmem_get_folio_policy(GMEM_I(inode), index);
>  	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
> -					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
> +					 FGP_LOCK | FGP_CREAT,
>  					 mapping_gfp_mask(inode->i_mapping), policy);
>  	mpol_cond_put(policy);
>  


