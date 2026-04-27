Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6052FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01DFB6B0088; Mon, 27 Apr 2026 10:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F37F26B008A; Mon, 27 Apr 2026 10:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27626B008C; Mon, 27 Apr 2026 10:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D13CB6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:40:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C6161B88A0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:37:18 +0000 (UTC)
X-FDA: 84704588556.10.B54438D
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id B87C74000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:37:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=V8N+qBjl;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=vbabka@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777300634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8VFYyvlKojOOO2+l6jJaxHSJX5GHJpaq7eGFfHuQ08c=;
	b=YEGs8w78JqpwZFtqty7i4t+UfTrdUOTGYCoG1D+GDB+sj+C9p0fTXnsjyAYEqtiW3A+Dna
	y3o+PnN0IINAR8IHcwIW01GpXvt5AAniapBYwr5aLyFWOhOPMAyySxMmVSzjT/fWJgqxa+
	w6VCSXjFIa9GqTA9kPNQALcL8oDcREI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777300634; a=rsa-sha256;
	cv=none;
	b=LbbG9Xuu0hSstCEWWJ+FxlGaouduGoScpZfe7nqGMx/3x8da7XzGLBmkaaBda9r2Xmq9Ea
	vxJ+GxJMoF6wqrN2vVK/n97ovrBx04N9soBmBzcf5/3V9CVIYlzo/3W/eiKYHEy0CVjews
	iLN8WX6/r2axZW3Ak4/Ji8f9jGaQ2oc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=V8N+qBjl;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=vbabka@suse.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-44369c9c6c2so98071f8f.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777300633; x=1777905433; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8VFYyvlKojOOO2+l6jJaxHSJX5GHJpaq7eGFfHuQ08c=;
        b=V8N+qBjlIDaGNPArYk3B6dqm14LMQfXefmQXnH4tvkTHSbVfmVwqIdNX3Fgs2dEK14
         JaPwBvOwR3FplqXzHAkWMy2G4x+QXTVy7YszPuAEelzWJD+cWVIDf9LPv0PGPRf3qxRW
         t+9dCSetj49zJRF5h8PA80j5O5oaQmI4CIqnNyzAQbrfUhlDVsZj32Rqvh3k3nJjzFqg
         M3q6BfoBdM6eYobsteXdHd8IHOwMjmeeswty/xcclB3viA26Vu4mACWm5cfXCNAHnvTa
         NpH9gnso0fv2tqyEzVzskg+GpGRyHR03htYcuOsUPimg6d0Yq/JcZVOR6DlfY74vxXxy
         v8xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777300633; x=1777905433;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8VFYyvlKojOOO2+l6jJaxHSJX5GHJpaq7eGFfHuQ08c=;
        b=UDgiCitW+llUvIY4IKqoFQcrATnoynuHrh43zaq66er5FAxUrAlx3XFlNQYx2CLxgq
         P5v5czOA2+p9rQmrNvBec0Ta0Cil0ujicJt5QQ1m3/xDav8te1r4aPVcMDpnfR+tTolg
         dIOhyIXQEWT3rXbn0u44ylnZiJiMnQ1JXlMzoVccCuSt8TCAARdi8ppsLO3xsBtgMWZf
         vPyzSVBI0B3rv2FswxkxSQM4acTwm/wA61pnoagc3ArxosxUZnnFx7jF5fKB8k+IDMIt
         w0Jy9rhALTFrnyukGAzd0qELeclE5DROyXTQjNgNAVb0f6jc/KsWTvYM4grKM0lXhdTv
         D4eQ==
X-Forwarded-Encrypted: i=1; AFNElJ/E111AnclPRPigmbMv/kcmn40h9I/Xi+j1rC51rG0CZvB7fmM8BxBh/bV+WJ4cka37m1ZV7xIXkw==@kvack.org
X-Gm-Message-State: AOJu0YykG1UfsBTh1YBcpG4DvnqiOOu3QfObMOOFCb8dMIldoaPxejub
	CbYaCeTLtHEiB1VI6yLCN+OVs/kQBLuZCFn4lD6v0a7Yc3btvoLvTsg/45FdEXFsXAw=
X-Gm-Gg: AeBDieur2hOEPZIsT6d0kUY/pUjGdYFkmBKJqb+E4iFWo1QtwgXdGx6UVARpBFm1aDz
	p71R4RQnOHftoihIl/Q61R2pcPI8lRPeyZ80F2h8RRjWAv6XFgkA/wfBw14+KaUC1zb9e7BE7yF
	YTknGqdLhU6s0T5shA2mzqZYH5jZYkUjKSsCJ7/oCbBPx5TDS+gPnH6LJKXeeV1a67qkdSUiUa4
	A1dmFUjoOsxizylNY58i8mNGFJqo2BQfi16q98m9DxxxTljP/ijkL8wd2q2hN8xY2x1C6PBJCGQ
	tBaXgdpU7WEyUVGTwn4QUOhUN6yKMmCkI8gDA+il2yedVX1We1ZbaHdnqmBZulV7W/KB8w6bbQH
	HLpvyAxUOPXmTo5MNZUP5UlGZCfnr4mWWHWkNeNokcOz4w+wBa0/7s2vCs94qH2Lz3YOeE3PZ/C
	E7k3FW2n+epBNhmSYR/7zeXzxrG3iDpzOmPWXCCWZH4dT8bimA1z7AKA1z/M2qywSW0ey7
X-Received: by 2002:a5d:4569:0:b0:446:9d8:bb6d with SMTP id ffacd0b85a97d-44609d8bc72mr52152f8f.2.1777300632863;
        Mon, 27 Apr 2026 07:37:12 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb135asm86796551f8f.6.2026.04.27.07.37.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 07:37:12 -0700 (PDT)
Message-ID: <6cae0418-eabe-4864-b87f-b1f953de06b0@suse.com>
Date: Mon, 27 Apr 2026 16:37:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm] c6307674ed:
 BUG:sleeping_function_called_from_invalid_context_at_mm/vmalloc.c
Content-Language: en-US
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Harry Yoo
 <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
 Thomas Graf <tgraf@suug.ch>, oe-lkp@lists.linux.dev, lkp@intel.com,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, Marco Elver <elver@google.com>,
 Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org
References: <202604211323.fac1b29e-lkp@intel.com> <aedvSnhOGM_mauYP@milan>
 <aehdcxC14ycvY481@gondor.apana.org.au> <aeh2Ii9CxtgfsX_p@milan>
 <aeh_2WwIb8nAIcy2@gondor.apana.org.au> <aeiHkG7X_dieMdw5@milan>
 <aemTW8yiAe6y1tsQ@gondor.apana.org.au>
 <4e269fb1-cd6c-46ca-ac2a-168ce9fd06fe@suse.com> <ae9wFZp7dS8QF8br@milan>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <ae9wFZp7dS8QF8br@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B87C74000D
X-Rspamd-Server: rspam04
X-Stat-Signature: xc6nfzuweuynhiz6uex8tmgjc6taa9xf
X-HE-Tag: 1777300634-740167
X-HE-Meta: U2FsdGVkX1+carkrHL/TNnO5tupelBX91K1Ecn12MA1gXNBfKd1AsDd6ivLJuRw/g9a1QagTpdPAjKtE/7rBfLLssPCkMtfYsh6JL4hIJKGso8hZDkk90TYGlIoNpHBZT72m3GD3Nhkk/uKNQYy8QInMwXyzr3viEADN/Am05mHQhfr2AUq4suTzh2erM+CUfElB+Dc15a+SWbQRDd/a4Dkde+Rg6Vh0H5AAl1HtniEWdu9UCQ9Gxh49KuzNFUlVhBiir7jxDDJEr+xChBnvd0B9QWtaBdvjaVuT/hHKrS0zdy8Nq1Lf5RcuWJN6AwHYacuj4qCqJwkZSV/MOfKkYgMj+1fH6L66amGt49/R++Fr2E+/NNlRXlY8WCB5hZ+u4yk2fXojaKrWyU+uyQpZSFcuQTsMyjBPhRxvBukGvh3IbLPItlY/ylH8UuIcHmgfi8sEPi5ygTqDikFfJg6h1n89nxFMi8/E3dZGYPtn33NoE52+G/ELrtmd4CRraGWmq6pslW3/D1PMuyXgrbutGy0aL0AOh54elY8cDeorTq3o/xnaK1HCrX3Bq1XqjMrHEpfNv2QRvDxBGaAcrSKuc+pLJrgev8DMPpv4QtlfCAtQI3i61vriF8riascXVxeVH0PRsDRu4UGOdtvCn0qX96eivP5pkbwaZnVXRgWQAn/v4z7ICe8EKoAgoLe1i2CJqkAVvDMPt0buGvSMq4GIZTEYjgfEQCg4Kh9kekLYqutTprsgbBu4wNcPV32pybegeX95cIA72Ep6DaAKcobmavn2NVhh/6sLl5vSpzZzsZ9XTQ9IIUIuxKfnhU8VPap6lzWqh2U9B53F+cyVUMp5fgrIsWlDi5awe95x4IwwNT4CiYYrFtXy6Aveqaf/0mNgkCdD+zfS8d4X2FKioWLu95nxuslPD6ADX3+XlcXjR7e1ol5U9ELZ14RxZuZHPdZj5Af3xDxgwBHnSEhIBZH
 35rEh86k
 dDtByhxEdD+eYxTHuKzVOAl5Ema6+ene2MlOXD5rV0cVYvOzkMnMpWyG+XwdcCDoINTwqLmBeN7CD/TxX0KipP/4BMUYMdI3BmIW1Q7inkbfiU9l2CHASOfeP95+4PYxT3T/yjdPf9YLi/zwwntSzbyyDlV850P/zfByKs863ZOlRlg9x7oevXgEp9joofQbWr3FOtme11UqaWS+ms1VRfq2OUHJ7yDOjdZjQU9e6AIw6V3WvMprfrJ9xr1YywmZVkUONr0uu9VMPooGsptHLmc+SFpbnifBGFR24qlKyR9nwyCBBeU/ZTzlgD/pjb7B8mdLEWh6zwlwMjQNEbosL1uSrIxEXmdyl/yXsV96vXtGn7g7cLyL0uPHUln3/AJR/9VtjoneWm46sxbRAf6LKj28W6o/MQYkYsVBSNMHGE5PATA4mJAMprYEtI44AmmuxIYddM6C/JpdctSBLWJBYXJPHhkiUqZHeZCkbKdptl41YUm2U9SPPQ5YGBTjO3Pl1rLFwbeD9HdbH0f1PBXL8o23He2lXhFksaUrgjG+mCAP9LEbWWu2WlLlXHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 16:17, Uladzislau Rezki wrote:
> On Mon, Apr 27, 2026 at 10:53:52AM +0200, Vlastimil Babka wrote:
>> On 4/23/26 05:34, Herbert Xu wrote:
>> > On Wed, Apr 22, 2026 at 10:32:16AM +0200, Uladzislau Rezki wrote:
>> >>
>> >> We have added non-sleeping flags for vmalloc() to extend kvmalloc()
>> >> functionality as folk need those.
>> >>  
>> >> Another option, would be: always use vfree_atomic() from the kvfree()
>> >> path.
>> >>  
>> >> Any thoughts?
>> > 
>> > Perhaps add a kvfree_atomic that just calls vfree_atomic?
>> 
>> kvfree()'s comment says
>> 
>> " * Context: Either preemptible task context or not-NMI interrupt."
>> 
> I am not sure the description clearly reflects the intended usage.
> To me it sounds like all contexts but excluding NMI.

Agree it's not clear, my immediate reaction was the same and took me a bit
to understand.

> For example, calling this under spin_lock() will be invalid, as
> the vfree() path may invoke cond_resched().

Yeah, it's covered by the "preemptible" word, but not super clear.
IIUC it all boils down to this in vfree():


        if (unlikely(in_interrupt())) {
                vfree_atomic(addr);
                return;
        }

Which can do the right thing in an interrupt, but obviously cannot
automatically recognize the "under spin_lock()" situation.

So I don't think we can change it now with all the existing callers, but if
a better wording exists, we could make the comment more clear.

>> so this is neither. It might be ok then to create kvfree_atomic(). Always
>> using vfree_atomic() from kvfree() might be wasteful.
>> 
>> > For rhashtable it really makes no difference either way.  But it
>> > would eliminate the unsightly call to is_vmalloc_addr in rhashtable.
>> > 
> Seems atomic version makes sense here:
> 
> <snip>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 15a60b501b95..2b5ab488e96b 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -1234,6 +1234,9 @@ void *kvrealloc_node_align_noprof(const void *p, size_t size, unsigned long alig
>  extern void kvfree(const void *addr);
>  DEFINE_FREE(kvfree, void *, if (!IS_ERR_OR_NULL(_T)) kvfree(_T))
>  
> +extern void kvfree_atomic(const void *addr);
> +DEFINE_FREE(kvfree_atomic, void *, if (!IS_ERR_OR_NULL(_T)) kvfree_atomic(_T))
> +
>  extern void kvfree_sensitive(const void *addr, size_t len);
>  
>  unsigned int kmem_cache_size(struct kmem_cache *s);
> diff --git a/mm/slub.c b/mm/slub.c
> index 2b2d33cc735c..e25a0eab6ff7 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6802,6 +6802,22 @@ void kvfree(const void *addr)
>  }
>  EXPORT_SYMBOL(kvfree);
>  
> +/**
> + * kvfree_atomic() - Free memory.
> + * @addr: Pointer to allocated memory.
> + *
> + * Same as kvfree(), but safe to use in atomic contexts.
> + * Must not be called from NMI context.
> + */
> +void kvfree_atomic(const void *addr)
> +{
> +	if (is_vmalloc_addr(addr))
> +		vfree_atomic(addr);
> +	else
> +		kfree(addr);
> +}
> +EXPORT_SYMBOL(kvfree_atomic);
> +
>  /**
>   * kvfree_sensitive - Free a data object containing sensitive information.
>   * @addr: address of the data object to be freed.
> <snip>
> 
> I can post it if no objections.

LGTM but also should be now used in rhashtable_try_insert() I think?

> 
> --
> Uladzislau Rezki


