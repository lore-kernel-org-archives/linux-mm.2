Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81613C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 21:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9946B0341; Thu, 24 Jul 2025 17:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83066B0342; Thu, 24 Jul 2025 17:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A976B0343; Thu, 24 Jul 2025 17:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F5D16B0341
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:56:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21015C0567
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:56:12 +0000 (UTC)
X-FDA: 83700516984.16.8E378D6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id C540540007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:56:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O8ktJ0JY;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753394169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnIYE6isHOtcopFB9zBfVfcEC5sN5etTBxSjFpgZalU=;
	b=EiUIw6Z2Z84CeN50BBp2LN4ibO3/SgfvrtuyqT07rZvQEOyUjoGfywDJj16rA4UbOOwr5j
	FatK/5XgA/DpheAMn6h42c89/ovHD79h3Ql922IQiz6Qn7oD4JSZjHevMVkbPbkwTucsJH
	BaBTin7lCpQb91TElpgFUsxVabckSX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753394169; a=rsa-sha256;
	cv=none;
	b=1LAkn0cCR+GryR5ofGshA70pTbUFgylO+YvmOnYeAvFGUB2lK7zVMmL6LrPvQid5Q29Edm
	uD/D+0ASgWHq0RgPtxeI7JUqhT0+ZdDlbXXAXBbRAK1um39Yc2t7Xsuuqf0b3CcqZe+60e
	19wIG/tPtNoOIgqriszeQujEKnmya5M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O8ktJ0JY;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753394169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TnIYE6isHOtcopFB9zBfVfcEC5sN5etTBxSjFpgZalU=;
	b=O8ktJ0JY/n/CYiPMbATYyYbygUTzSk7rP/PNKs6IwiRRvVpNyH2QmF9xRrvfY5MReRnUdw
	jzWyx3ZuxoOFivr7o47MojcnVLnO7Z8rbb6FlpZxwkiL7BUr5UqxjVqT4ZKEoZ3MvK4opp
	m+dIj2hbl56/aq0GPcfVYA6qnGb1Cyg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-WHYWO-QFNlqKwTava_jL5Q-1; Thu, 24 Jul 2025 17:56:07 -0400
X-MC-Unique: WHYWO-QFNlqKwTava_jL5Q-1
X-Mimecast-MFC-AGG-ID: WHYWO-QFNlqKwTava_jL5Q_1753394166
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4f7ebfd00so604894f8f.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:56:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753394166; x=1753998966;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TnIYE6isHOtcopFB9zBfVfcEC5sN5etTBxSjFpgZalU=;
        b=R73OKfyK38cgzj+eZ3U5IGTI62ZoNMuCxmyd5sIsOwQtcp60PC0687Y46v2F98YndI
         nojHZMhIpPnnps3W1666mbfsm4tvnY+sQycpsdXECkWQupLeazNHHIuioGQBpvWY+2RN
         SHtGz/jRfZtVh2UpZdzT+I9928dW1Qtw/iRnvpzQNF+iqX3el2VpS1OeSVmwqigKEV6I
         G8iAhs8eZqnXehspjAdE42UQ6pwOeHpavNjGgJoVyuIKWZyo1BuFo11IpROBiUa83VPV
         0Gp8d4ln1HDYzP8TLpYjbTxswpgcyuqw3I3EYjVf6SDrKu9FH/h2xQGyDk/93dc4pc16
         ng/g==
X-Gm-Message-State: AOJu0Yz3whm/qtT4SbMc1RfMg01MEQ9HSAMjfPJcpJwWahaJg/yZNvXP
	32cOWDO30gckk2EvsJZQjdOmpPJ71GztHt7n45Fgx/j1nYXczgki77yKG81p1pt6TvyqUBeh6J3
	JvNsZssRmuiCDny8c9Ws6/mfXDE1k8iF2iyNAh7ibFMy2Uk0LkfYmRkMANFcNXYQ=
X-Gm-Gg: ASbGncvPqEkFjeVUeWPYZIissYw2mqhKs8w9N4bGuArFbo1UEvHS/0xwveH2VG3xdsO
	dyPoBYJz2OM9rWSJPfn4wbLmchb5ZmcsQyFqVo+aaFiMRzbMvTowsBMBYEXUx/dxivwTOvrYVOq
	OJwi532P9b5spr0krHfVkWCkwuaanxPrQbqPa6cfT2LfKzOtuPDS1Qh0f0v9iWaOcEAsirPPzDj
	4k/fiXfjEE5hkjFhokqMKdQtc2r2tortuPYcLhxnp2jr3Pb71O6zRLhV8D+KwPSA8E9zhn8et7x
	2jEpON6hcvfKvU7SE/2hE3xcsN+VMK1bz34wuIoCcewefLELFTv81RAGFVpMhZZhIHIYJOtf1RW
	I5DCFWdcrtEc4DQ8dugpq7UjJJVafo6st6mtXPG2/PSYkxkG2hIkYNH3BMAOgCsR8Y7o=
X-Received: by 2002:a5d:5d07:0:b0:3b5:dc04:3f59 with SMTP id ffacd0b85a97d-3b768f162b3mr6550288f8f.37.1753394166456;
        Thu, 24 Jul 2025 14:56:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpj0Q/qfPPBHUfZgfVRBY+U0T8fmE6q5msKr2mfaAw9QwTWSOib0nfbwpWlSY/Dv9OPcQx1Q==
X-Received: by 2002:a5d:5d07:0:b0:3b5:dc04:3f59 with SMTP id ffacd0b85a97d-3b768f162b3mr6550278f8f.37.1753394166010;
        Thu, 24 Jul 2025 14:56:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f01:5500:ba83:3fd7:6836:62f6? (p200300d82f015500ba833fd7683662f6.dip0.t-ipconnect.de. [2003:d8:2f01:5500:ba83:3fd7:6836:62f6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705e39b1sm31164285e9.34.2025.07.24.14.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 14:56:05 -0700 (PDT)
Message-ID: <85c4a092-14df-4478-811c-f3789610e4b8@redhat.com>
Date: Thu, 24 Jul 2025 23:56:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
To: Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel
 <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TpzPy6OzL0BSRwRk-QqQf3QRhpjdKH4OBaB46J8cQMo_1753394166
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C540540007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 37mujfdkyghzb7hm1uhqkghirngzg98c
X-HE-Tag: 1753394169-525034
X-HE-Meta: U2FsdGVkX189FN+tSvAD3vURt0Bfceu9oBQ5PfMWh0zl9xO1+CGl2iP0Qikr18a2omMszNfKekQBCQkH35t+xhWSmJ7w6d3/9dR0cnELOnMPF6jjNGeYYE4/pcXi1cJkUofMa2OANJ3Wu/9ceqxaHAfB/bYih+Cku/M82gNz9M3KGEWb5X14XqmasTqnn9p/HjHmGQG9M4zv7hK75NUGFnaWO5vaW1jSt1DFuIaQxcEkhTwuC1x1WwQuN3UXcb1waIiPIkjoGJc/blnqRNS+dZTTNG4+Aujm7uEe4Q6BgM8XLFqucieQBlZ7KdcOQWnTw0sx8xzKbr2PF7ErqrfyI9F/Mstkr+sl6YtY6CXmnqnDMvEWRqaUYGPptbLztsX0VcBEevH+q6K6/ZGv5BIPe+r3uQCbi5QrAkdWZhrgOy259a3ft4hHGNM1xq/b4N+W+EE/Xy4MAj31qnQZ+PhiaZlPDMkgaEpvX5zzX63kcmq/13swmYgUVVMdhjnyWeBX+bwsZxPSQ5NbdiD6KYsuCC2snfNpqLqRqaApGmE9UmZfMOOzh1fjUvHHnz/to4H3rtigPszRXihm+3Tf8Nj7kCWEDvpIjmX3KgNAlUTAhVKftRTCY2oZCKspie+Q0hI9McO8odkTZE1V9OZI7u8ru6AT733CYg+KEEVC+CCTvL1ixBOIdfKU5YI9DA/Hwswk/V2Q9qyY3hFJ7fGE8PgDd0IzXfIUl/NnPv7OoKd3yvtJMGyQi1BKOKE4Y9RLW1gmmVwiQwQJ6QflFXeVuNcvUVJkNi06D2CsTPEgJb/5lRjiScVQuP2nMB9okO1RAcqRvdRTKbL3b72Pq1TeaKzCK4Nuz2fsfa+Tp6zZ8Y0+ImCO6c12ppy0ZDXGKc4USAsQbru4JBCKIk3Ryg1eOzCMQZJGm0X05CnzS54/iOUd87vPJydwOtWASe6n4HekvVOJdCNPM3oPEYacob3dlXL
 vDA6PfJY
 T4df+TPFRcIlJFhy1yKmtok84UAbfCiIsHG2yo8XeJulqCgEa0twctFzlD4VHGbuqtv5trGGRy70VOIZ7GoMvxCMJ+DAi1l4V5b4tZ3uRvalgq+KkT/GcvkHwdaxf3O7VNrdiOH2bD1yYIVT6MA4Z/Q4t9JVov1ewyjLQbyReNV5pKfgy5HsYaUQMWu2cuoq3VdwT2MJcFL4MA+fsB896DzkTCPSAatEJ8XBJYyxeJGyxujORj8fHuvz5EiQ3VzL9OIV+BhV6lBvzbTX0OXSvdbONxNj6J3t/zCLDNn+Mlhx3/Ke+PRLP2VS9QrcC6D/i/4+1Wr6FCXh1z5MiL6CoZyArZ9rrpuY4hZxAD9ENj5QrIASbSIMc82m43PipeMh70o7P3BjEFAznNPQd5oCwbCFkjKVqxACg4Xve+RIcSOKjjSwOC0k/tWN9KetPP2YYiv1fdIe8n1UYkSHKc3s2CZiNlVUvRRIoQzwGQq5DjoX04kDMBIK6oBEWJwDTQKViWynaF/V//AoFmJXkftkHuFUo28qF7jeRty6alne7sl9nd5VRbBmm8keUWIQ9wdYwIt15sLzHUPmXX5g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 21:13, Jann Horn wrote:
> If an anon page is mapped into userspace, its anon_vma must be alive,
> otherwise rmap walks can hit UAF.
> 
> There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> walks that seems to indicate that there can be pages with elevated mapcount
> whose anon_vma has already been freed, but I think we never figured out
> what the cause is; and syzkaller only hit these UAFs when memory pressure
> randomly caused reclaim to rmap-walk the affected pages, so it of course
> didn't manage to create a reproducer.
> 
> Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous pages to
> hopefully catch such issues more reliably.
> 
> Implementation note: I'm checking IS_ENABLED(CONFIG_DEBUG_VM) because,
> unlike the checks above, this one would otherwise be hard to write such
> that it completely compiles away in non-debug builds by itself, without
> looking extremely ugly.
> 
> [1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.com
> [2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.com
> 
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>   include/linux/rmap.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index c4f4903b1088..ba694c436f59 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -449,6 +449,19 @@ static inline void __folio_rmap_sanity_checks(const struct folio *folio,
>   	default:
>   		VM_WARN_ON_ONCE(true);
>   	}
> +
> +	/*
> +	 * Anon folios must have an associated live anon_vma as long as they're
> +	 * mapped into userspace.
> +	 * Part of the purpose of the atomic_read() is to make KASAN check that
> +	 * the anon_vma is still alive.
> +	 */
> +	if (IS_ENABLED(CONFIG_DEBUG_VM) && PageAnonNotKsm(page)) {

1) You probably don't need the CONFIG_DEBUG_VM check: the 
VM_WARN_ON_FOLIO should make everything get optimized out ... right?

2) We have a folio here, so ... better

if (folio_test_anon(folio) && !folio_test_ksm(folio)) {
	...
}

> +		unsigned long mapping = (unsigned long)folio->mapping;
> +		struct anon_vma *anon_vma = (void *)(mapping - PAGE_MAPPING_ANON);
> +
> +		VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
> +	}

In general,

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


