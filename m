Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB5BE9B365
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC0C6B0089; Mon,  2 Mar 2026 06:29:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93A06B008A; Mon,  2 Mar 2026 06:29:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92A96B008C; Mon,  2 Mar 2026 06:29:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A72A66B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:29:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D003BCF20
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:29:03 +0000 (UTC)
X-FDA: 84500901366.10.5B6173E
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 29D234000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:29:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BoZAOTdG;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772450941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1aYNafgGLMp2zV21P8+oK10uFDyPLpaq2eVinuia9OY=;
	b=Y1U8LkMRjO+MQf/E1j+XhUwsUY7uwwiO9ckcBuM8V6jGrJF9sIGbQ0vR6716BzSPVsmvb2
	+RrQpR/SZS84ybhEhVL+H32OvpkOGi8QUfwEqFWkwgcsl5qZF5sVuBldLFeg2sbBRutkEp
	zW3fg0ncb8DzBmqPyDcL4Go8h0FTXZ0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BoZAOTdG;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772450941; a=rsa-sha256;
	cv=none;
	b=UHgtkb/I5pxuXTN/qPTrjxgpv7IKmAd9ySkW2n+kLqcIzddFzQn220+JtMe5mlZ0p5I+pX
	qD+lJ/zIqoF7f7LzUCZSa7wCflXmFJu80DeJDOXNZIJ6b67KB96MxF3OK3pODfM8MOrb0+
	nIPt2bs2gwaGvXF6AUIamA1OqycBQDo=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4832c8f9d87so5023255e9.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 03:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772450939; x=1773055739; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1aYNafgGLMp2zV21P8+oK10uFDyPLpaq2eVinuia9OY=;
        b=BoZAOTdGTycnN0ggWx43EE5Qzi+spXjUWvtrAEloSQvaUUqDRRGpCr9kxVkT+3yGUc
         oMsV3PvuqrwZKCzD7mjkO+qaeefwUdu0cFZwJp2bbAVUm3HUunKs3/974aXwdOeIbEsL
         SAXauY+BSFnev/HGfHKKBP4pmfgzQWeDoZRzUKSoYB4zPrey15uglnLEYRHO4NFXHaXq
         a7zmkvvipxW/0vcqCTTnzZn+ntRG1WSVFnVgTZLxK0fCnNuAAooA7NQ3uz8Es47CdYNH
         kDXsjCrsjMW2iUxhoGhfILzmGfi6MuvKvHylg1M7HLPcxz9ehFWxA/YVd6LiGPY5MGle
         XWkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450939; x=1773055739;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1aYNafgGLMp2zV21P8+oK10uFDyPLpaq2eVinuia9OY=;
        b=VY9ujQDAblzoCtHNZpm0KUD541nA2VngzCq9VJ3+MbtrRgzDVC7yMfYxSmLf4wY+yh
         isb9ftK5BLj/9UJ8w9Q7alg2tFiE7EalJyFs/PAYzQI/11S8uQqijwABq0fs+r0O/vSQ
         JSX53ftek08/SgAPIsmcJ1dKCHXelVmVqmyscAKjsslw7bkCh8V/4cwnCEDtb3ARHUpr
         4Y7Zw/RooalyfW2ev+JQZqXpCuH4KHnfRBKKI58+xRhW0AcPgIUagq+rvaGyx1LoRH+X
         /humc/5Ao0RDcIOPE0qKtraXw75XuZIwfz+PLDtNfnhJw9IJCmjR2qDx6ywKw7pccl6d
         7SyA==
X-Forwarded-Encrypted: i=1; AJvYcCXCDlhbi4ytaAWQeV0j6zk4mPV1UEZ4LOxHu49boPP13neXyiYhBNrAcnZoia7ZFzs1AE69aC06eg==@kvack.org
X-Gm-Message-State: AOJu0YzdVRzedZxy32fc5idxpzvAKLzuMXkfELKZP2FXYUZMCBUa/bWF
	7+BvDhI35VSEI47mhmIe++1S72c4mnmZ2NfajNg0mjD0G995JoZbsT3RzTDKrnCsowI=
X-Gm-Gg: ATEYQzyLrwWd6wk8N9DfdG6183KLxGpj6h/EJeWUXvarydcggZgjeXTHYbuhtdQGWkI
	rnG1Dj6Tu6YGJcr8klvRiNnw7U29zngeNJqX0fsVJzhSgnGDt4eGR1qhE5rLSukqM+UaLvmQ4YG
	KgyWPirwoBWHqE1/tHEzuVRLUAT8Cj7tE7sQB70U4Lyud8T/tymBK9CdSktIhZbiX3UOEWNyu5S
	yLNXC2VBn93WKHzpNq/DPYX3ZA+yHlM+Sx2pXp3DECIUxgHzrlLpIropy6AOyr8XITYK24bKd3u
	QBJ323yEQ53gnkzo4rFfkfX9TlXuRjCqZhK7cogLkUxGg8MWZriEC9NrZwfWQVhZ+XpZ32ElQmG
	YFUzDPMlj4OXMORPo2xjKvjChhHjOSGvrrtsXI3KajErX7GzJS97P8sh3opXJCqTJgSfZbGzylh
	Zfq5gtuBhv3xiRm2qJ/FXZP7IvRcMAhZ9ZV2osApnxo8Mu+DZ0YxB6x85v7Q==
X-Received: by 2002:a05:600c:1989:b0:46e:43f0:6181 with SMTP id 5b1f17b1804b1-483c9bfbdd5mr117360665e9.7.1772450939437;
        Mon, 02 Mar 2026 03:28:59 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfb789efsm210891065e9.2.2026.03.02.03.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 03:28:59 -0800 (PST)
Message-ID: <5097ff66-b727-4eac-b845-3bd08d1a0ead@suse.com>
Date: Mon, 2 Mar 2026 12:28:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 2/6] KVM: guest_memfd: Directly allocate folios
 with filemap_alloc_folio()
Content-Language: en-US
To: Ackerley Tng <ackerleytng@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com,
 yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com,
 vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com,
 pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com,
 tabba@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
 <20260225-gmem-st-blocks-v2-2-87d7098119a9@google.com>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260225-gmem-st-blocks-v2-2-87d7098119a9@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 29D234000B
X-Rspamd-Server: rspam07
X-Stat-Signature: s3h4qpwmgssbi9pn3g8kkdgs1uf99bg3
X-Rspam-User: 
X-HE-Tag: 1772450940-617725
X-HE-Meta: U2FsdGVkX19wdcxmGVDGUfUHvJRyAKxCViOZc/8wjQhVxTTngUp13Vug+peC7kL0in5SA7eYXA6rKyPJCPWp6JBN7l4qxnGV5fmbz99beWEETzQLMoOzZFZfStcn5qZr0VPZcqiwKY9ku3HQH0kSeqafmuOZmwF+VvW2gRnT++9rMs4Kzd8h8Ac7Vpds3iJNyVzmmctuclxk3wN5D/gn+f1X1P2cjwkvIz6fTeBclvRHnlegpJuEDsEAyyQBTdVroLrjuiVUW11WLiRXMlVwF4H7DnH85Q3VcE+IRkXKUVY8eHaUQdJX971ZGa+AanMnXdZS5loZaQzd5gIKcMDUEPc9s2E3qWIGAi6bUUDLUrzPwA/wfiEwuwouXS2GcTYu9Pn654j2zR5ZW6Uxt+nHRP9B9gVNad8GA5ejePiBqwO7vGJGZVBug04Lovi8A3ZF6PfErujlrAu6zgqEkbRnyTeftml10SPL4jJOQKMjDkH1k24vARjZuhjWz6v3lLZJ6nZ0qRXR9ThmMtg6UcstTzpZm95J+iHL2QlTauqPdZ+k6I1a6t8jK9LIIlY+uOyQ3jrGEm3GdtATgGJdT+eYkMR1JWSxrHfaBE3ulBbF3cBSuYEFydcgb8RyHJ8up3O4pxcT7mLJiq8oQdk4uHYXfNWZiHQDGSn21rlXFM3pe7XvILY5lfLxF+Cmvok5E80hCwM5VvcEL5tQVw9+0XvC8Wveg+S4VubeoQESoQO9bYa6EMgw+e0kkae6Wo9nJDvcTHuO8wrg1BEb/EcpqJ9Hd7AYGgD6b9CzcmcaRCOkiNoqtvSTY+V1KaclGSAhtP/bZ/ZJhDthEh+K4JuMhJZkM+tdnxhbpUR/s1UWGBCeD8KIpludYJuTFmM+iLz/RW80X6sPuhFqT07wIdXdTmRgtEZp5zHi1jeQP8iiZiubMoRS49+RAEuliQsVa9Ilnqt/yGcW9mHDmpeTpLd61dV
 Eza9PCGY
 zWyW6RL8MIyywQtMdjRzPGsEpcpkyRXCAeOLTAFSjzf5ECOEDSjCiawmSFaAsXh2XaTtF1GcZmbwpQFE2ZvC6OW4loBWkNe2slOtOxWKW30hbDoG0mmYozZ5ZxxjyA+k9tbUUw7nw4CJsuczCtE0cmkz9FCCsePzDLCgppjRY4dLtyxO2vWj76J8CtUPtrd3hEa3pu4H4roinE8aCg4oSo2BuhCc6sMTpiFSyAO7xnStdX+uMdr8esaogxkz7u/Y7G+NsWfFZWEkrqHC/eglt+WpmB3k2bsMWLiN4T8ijd7B30k5UBOMmvMzlAixQLpc9S9HsPSzymyYbsPjFZf9ommZD4h9SfJ6IJaTF7aaoGRVpkw3mMCTu6E9VqJDNE7EHtM8QsJ3vavyaTHPpnehOqnZQLcDUTMSDqMR6Dl8CAGy+pqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 08:20, Ackerley Tng wrote:
> __filemap_get_folio_mpol() is parametrized by a bunch of GFP flags, which

                                                           FGP?

> adds complexity for the reader. Since guest_memfd doesn't meaningfully use
> any of the other FGP flags, undo that complexity by directly calling
> filemap_alloc_folio().
> 
> Directly calling filemap_alloc_folio() also allows the order of 0 to be
> explicitly specified, which is the only order guest_memfd supports. This is
> easier to understand, and removes the chance of anything else being able to
> unintentionally influence allocated folio size.

Isn't it determined by FGF_GET_ORDER() so when you pass FGP_LOCK | FGP_CREAT
and no order, it's straigtforward the order will be 0?

But if this helps with patch 4, ok.

> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  virt/kvm/guest_memfd.c | 51 +++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 36 insertions(+), 15 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 2df27b6443115..2488d7b8f2b0d 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -107,6 +107,39 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>  }
>  
> +static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
> +{
> +	/* TODO: Support huge pages. */
> +	struct mempolicy *policy;
> +	struct folio *folio;
> +	gfp_t gfp;
> +	int ret;
> +
> +	/*
> +	 * Fast-path: See if folio is already present in mapping to avoid
> +	 * policy_lookup.
> +	 */
> +	folio = filemap_lock_folio(inode->i_mapping, index);
> +	if (!IS_ERR(folio))
> +		return folio;
> +
> +	gfp = mapping_gfp_mask(inode->i_mapping);
> +
> +	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
> +	folio = filemap_alloc_folio(gfp, 0, policy);
> +	mpol_cond_put(policy);
> +	if (!folio)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ret = filemap_add_folio(inode->i_mapping, folio, index, gfp);
> +	if (ret) {
> +		folio_put(folio);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return folio;
> +}
> +
>  /*
>   * Returns a locked folio on success.  The caller is responsible for
>   * setting the up-to-date flag before the memory is mapped into the guest.
> @@ -118,23 +151,11 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>   */
>  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  {
> -	/* TODO: Support huge pages. */
> -	struct mempolicy *policy;
>  	struct folio *folio;
>  
> -	/*
> -	 * Fast-path: See if folio is already present in mapping to avoid
> -	 * policy_lookup.
> -	 */
> -	folio = filemap_lock_folio(inode->i_mapping, index);
> -	if (!IS_ERR(folio))
> -		return folio;
> -
> -	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
> -	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
> -					 FGP_LOCK | FGP_CREAT,
> -					 mapping_gfp_mask(inode->i_mapping), policy);
> -	mpol_cond_put(policy);
> +	do {
> +		folio = __kvm_gmem_get_folio(inode, index);
> +	} while (PTR_ERR(folio) == -EEXIST);
>  
>  	/*
>  	 * External interfaces like kvm_gmem_get_pfn() support dealing
> 


