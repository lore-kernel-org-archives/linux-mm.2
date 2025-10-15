Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA798CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE62E8E001D; Wed, 15 Oct 2025 08:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBEC68E0002; Wed, 15 Oct 2025 08:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DABEE8E001D; Wed, 15 Oct 2025 08:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAB9B8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:23:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 850C51177B4
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:23:48 +0000 (UTC)
X-FDA: 84000264936.21.049404E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0390340012
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:23:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fTWqUzG5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760531026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkqQTWDiFQG/rhmW5z9gOyGt97QuPR5S/ZSPPEuBM80=;
	b=A4PSHcfw7tts7qBJrY5ITb6oTI+za5VfUdqGHjD2ALLs0XsLG96kUIjvCyS3YwFvKz8cc+
	WUNGKUn9YK9f596Gjc8VPZmwM8zWDRGpIwoaiwNK+vCg51K2sIDeFCwD9MsBk9JBrC44Nd
	44GD4JUxMZUkBAqYAnwM7pC0TN9+UrY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760531026; a=rsa-sha256;
	cv=none;
	b=yKJsiWJwQzRCg28dwA3tpqPx0UfzQ/h4zFy7vI9USIJ5IN/e/oIGstKOHhytyYcPOmcdna
	pLi7kDX2WxHTTLtUIwGGvSg1MzuPgBqT7B75NJXju/eMvXo9OAlMgssrf9ihd7ttkgBrPH
	ivlxT9Da/FJ42JvDIyWdc2DAg7s10Tw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fTWqUzG5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760531025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZkqQTWDiFQG/rhmW5z9gOyGt97QuPR5S/ZSPPEuBM80=;
	b=fTWqUzG5Gcn0xi+fRKT7bqie5RvmHCc4c94nlidJsXVzfJjFyg6XeKtlJuIJdhAdOin//3
	3W/I/JvIaVX2ZtcsBWhr5LV8dA+2wguAYHU/FXNxKWWo30gDA97eYoeZLWgF4uUgqKL7pz
	QDXcO9VVacDn0Xr8GItz3xxZATlPLT0=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-YUa83x7aMR-lcr1SijJ1MA-1; Wed, 15 Oct 2025 08:23:44 -0400
X-MC-Unique: YUa83x7aMR-lcr1SijJ1MA-1
X-Mimecast-MFC-AGG-ID: YUa83x7aMR-lcr1SijJ1MA_1760531023
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b56ae0c8226so8521317a12.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:23:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760531023; x=1761135823;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZkqQTWDiFQG/rhmW5z9gOyGt97QuPR5S/ZSPPEuBM80=;
        b=QbD+ovipxmNZPrwyfYEpNDDkhLW53tY3gLxYNz+/XBZ3wNr4rad7a9Ac0CzbJ7Y8sj
         W10hFKgc3sCjJUkMNrZ0f1k5CwybfkdLc3kJsQuGAWgdeAsjLOkbJe4XBBgpklX6plwI
         mo00X/Od0vU+l1ABGLu6tP4kzgckwU7VKa/SPfTWixCagyZRIalPyOw5MPigMwooqcVQ
         nW3CtxD5QGIbD77HU1urCbUnbaoZnKhljNtApvY0xissRqoV0LKPAed3/OA+4aIImHzS
         dx+dQu6fBuDRN58t/woy47rgXv1uWrlIeAcABfBVV0qYXw4YTDP/mNDfx5BbFv6WH2tC
         xXRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwCZnfInBTi722YgmmL3emD+JBBXqlpm66iH++jYKWmsNyfSHDVXdhjrx9hz/S9BiKaypzAYPtNA==@kvack.org
X-Gm-Message-State: AOJu0Yw4NwjOk1IpnSoBOOBN/YEpRt8Se6FvSZ9+P4jLD+vqiOtG4nP0
	pyGlrQn+FVhx2CRhtM8CnFt8tEcUBy9TyqzhpgcQ4G3aHEyyetE9+mIS25lfhwPCdomFcRi4P4T
	T6Dg0GiTHIKhNiom9jhaA72R9/b92eXT9owswTl5pG20rMB7Kx3Xz
X-Gm-Gg: ASbGncv0AHObNsgnN/T/wm1C/Xu8olqI817k0CXMvxYkj43hu98XsnfTin2Wrge0+nG
	l5V+8BJAqSwp7NkwUYgsv0wwNpdXG0rU3Ms4PUYQopAYFCL5h5it+bSy9M2OeBA/Lo6291r+gyR
	F2vWPJl7lr9GLn+l2r87t0ZPk6nJeifxsNMaNzCC4JB+bgktmU9xhrF4GjHLGEIhLy+80pPBTbm
	Rg+WY/LwlnzGH8idLkw7csCXIMKY+kFPtm+VonV2/MY2I+k25cjH2RHBnI1s49C5qZ+Rn/9wPyQ
	M2Lkah4Gi2IvDAseMDPjxY7gkohl20R4lAt1TcZc0EY2l/kLwcwOBgAx1k2I1is=
X-Received: by 2002:a17:90b:4c4a:b0:335:228c:6f1f with SMTP id 98e67ed59e1d1-33b51168de3mr43078754a91.12.1760531022992;
        Wed, 15 Oct 2025 05:23:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHphda3lGGfkiLRoBnQzpvHA4Ky6Irwuv735W3mQQQTqQIM8ZJIPop8Z5JRhjHaRWbxoi3uKA==
X-Received: by 2002:a17:90b:4c4a:b0:335:228c:6f1f with SMTP id 98e67ed59e1d1-33b51168de3mr43078717a91.12.1760531022428;
        Wed, 15 Oct 2025 05:23:42 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b678df2360dsm15222181a12.25.2025.10.15.05.23.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 05:23:41 -0700 (PDT)
Message-ID: <b479a6af-1e13-41da-82b7-d4c17e9034dd@redhat.com>
Date: Wed, 15 Oct 2025 14:23:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v2 1/2] mm: add spurious fault fixing support for huge
 pmd
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-2-ying.huang@linux.alibaba.com>
 <4c453dcc-2837-4f1a-905b-3462270f5e31@lucifer.local>
 <87ldlcpnbx.fsf@DESKTOP-5N7EMDA>
 <d748bc6b-2aff-4cee-a233-008f4d2555fa@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d748bc6b-2aff-4cee-a233-008f4d2555fa@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZSYsuy6LTqebJdQ9H9vz1uZzXlRnoxLNILiM8pLh7JQ_1760531023
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: ahzu6swxsejc4ry9cred3o8kzawbbqtn
X-Rspam-User: 
X-Rspamd-Queue-Id: 0390340012
X-HE-Tag: 1760531025-154538
X-HE-Meta: U2FsdGVkX19LTx0uAmJpAMcX4NtUlub0p4ZHEv0ftcO+Gy90D485okbH2E5+8vITGnF3e6D/XdyHtIBC05Ak4GzF67QzO5XakkgauARoucRnklDa1iwwz1BFjMGVpU+mybhTZHrZ9yyFFiqcBvj9rweEAHXXzUDgk3V60oKFrepkyLQEdsDvoWLm73dH3bCZNn4rEmNUIfYrkEqQ3+yqxwZmf8iZbQDloXojd/rTWwt9oKYmfZunjIa1qzh8lKatHjN8ePWI6F0HSPIJs5DGj2a9CB7Q8gO9hysq/VGFLI18uz0csZ3CUrKSbVHCsNqDveVXOxF/aeKtOiuUrDvl82E3uaBcLMg9AicNSZlqMILRT+BoLcYqvYbmuGC6iQAM0bn7cbjnd2fwxQSXE/A+YfNVgEintrUq11IvTb8z1J/AbiCLNa7gMgnKvq+OfcBiZEbsg1oFuhdwFQx2gFaPRQnVKmvI6ht20EPSmNwN1dPWp6XZQEt9LTdmym4diD5y1E1leMXPUDfIHi9zm871EC9o3UZ3kQ3Dz22QMbimFXnqzT2ExMixlJKrCYimZHiamsOyr0vi4JP0DGVg6Ujvl4k/0sHpwznkVUZrpDrW5iEPAKnkdt44jas4VSKme6gv2wyP8003cZJoqj8ieMKQyuO+Bk6awBEAInOh0rZHkLwF+VJ9YGVLF8rlHhIT7Nc0AC6X3I7Ent/4EH/KhFNGZ8RVLBEaCLO4NE7qODirY8Dxc4Yj4IImiacm0vpIMOySRSS/IDX+mpKtqIqeSxXpySf4CGlgbNAV0x2meiJmVLKd/Jjoh1idWxr16jnZwzKtHklGcWigDCNIOctMhP6LijbiVEQh5w4yg2AUGPqvcx4jFFGltgtF0HZReK/T/wTJ1RJ+mJVMTEbZfycpM467ZnYZAUPDhB7cIMqSzMlYBrpxBXDciIy+YE04v5pQPot2iz57NBuzOT+GPea3HwO
 x09hb4Ss
 wT2CGGzt+Mmnd1fASXlu1t7A+8SpHAZcutnRu66f26h5amCy9Egr6nnssgWAV78lY3N8fKVvj1SDUN3WyncwBGz2v8RszkOsh8/MDQ4vD5XWsLpLqMWUBetCfdGuinw3y4qHNej9a1OafoFdtYDyNCC+wPL2V9Jcfw6R3+yradoVItqRE0COOGijCo+xEKKCbs3MQaAdnmei9VUhvvwuBg9hD9ifXLv4qcZw72N8EvSNduUDwPguwZBdVbydO1L1mnu4zFAOmP6k5smIysEtYk2KNvgLn4fHTnYWs8pZswkCQVt9Mwy3/t8+NKe2kfCuhM8f7bYKpFwiV0iYy5QSIWyNLaECb5TMckhaPU9Qai70jcX2UaFwGLzBl5NXThkSSCaMX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>>>>
>>>>   	_pmd = pmd_mkyoung(*pmd);
>>>>   	if (write)
>>>>   		_pmd = pmd_mkdirty(_pmd);
>>>> -	if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
>>>> -				  pmd, _pmd, write))
>>>> +	changed = pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
>>>> +					pmd, _pmd, write);
>>>> +	if (changed)
>>>>   		update_mmu_cache_pmd(vma, addr, pmd);
>>>
>>> We can make this simpler, e.g.:
>>>
>>> 	if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
>>> 				  pmd, entry, write)) {
>>> 		update_mmu_cache_pmd(vma, addr, pmd);
>>> 		return true;
>>> 	}
>>>
>>> 	return false;
>>
>> No problem.  As long as David is OK with this.
> 
> Sure I don't think he'd have an issue with it but he can raise it if so :)

Absolutely fine :)

-- 
Cheers

David / dhildenb


