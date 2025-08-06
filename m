Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD36C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 10:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61C596B00B9; Wed,  6 Aug 2025 06:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3AC6B00BC; Wed,  6 Aug 2025 06:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3256B00BD; Wed,  6 Aug 2025 06:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC6C6B00B9
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 06:12:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08D13160533
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:12:55 +0000 (UTC)
X-FDA: 83745919110.10.261778F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9AB86C0008
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:12:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VMYMmkJU;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754475172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKNoeRnJQHE9xlWRNjmXu0K+b82kSOJOZJ1O9/cC1ug=;
	b=uTqx/ywavDVulvxc3bcSvlnRw/BcSRfyzcYc3oFbP/349cgSx1LipsSaSXNRfV2QyoPHEw
	/a3bsQbhWg4z6EfVAhHvtOED2ZclReDDmIrpF9dLQWjb0h+yJlmIjhQyaovW8IPs794zu4
	y9gVN8ocn1cqZEXvOwDzyyAqIftvmHY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VMYMmkJU;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754475172; a=rsa-sha256;
	cv=none;
	b=HCrc3uv3E6Ek/v6xQmk1u0Ca93059RUxaKqhhCKGenta2XsJ7I1qw37Q+nf7R1IipvmXCx
	gZ5Ix8GLuoant6qAn+7sxcZhyIGarkblMvfr+IPxnBx2Sb5yaoJojnAJxhpWZqUujcVvVv
	oWjHmxqkb6XE/DBstkLXw3EQnyvJJPU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754475172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nKNoeRnJQHE9xlWRNjmXu0K+b82kSOJOZJ1O9/cC1ug=;
	b=VMYMmkJUrC1HSImjaZ66IfzClOi4pljLpxOQE7UMWE5PAFDffLZysxK2HTVW2Zw2WGMdaS
	R29U++PVGWoGAiyOOCpJFEXvD4NooQgbZjGGPQqOjzWZ9dCjDRSW7B+IDbPvG8LkPpBuhc
	IC7KfBIrAN3mYKzGN4i6A2mLIaumiWM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-NqzzP-OXP9Ox5lZ2vLP9sw-1; Wed, 06 Aug 2025 06:12:50 -0400
X-MC-Unique: NqzzP-OXP9Ox5lZ2vLP9sw-1
X-Mimecast-MFC-AGG-ID: NqzzP-OXP9Ox5lZ2vLP9sw_1754475169
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b782c29be3so3812615f8f.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 03:12:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754475169; x=1755079969;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nKNoeRnJQHE9xlWRNjmXu0K+b82kSOJOZJ1O9/cC1ug=;
        b=io5op9r6w4d7SgpACEekmoTRWwZbfrD/VPoAb7YSswYK+utSH2q6Ho/Vjaaq/rJ2Or
         CZUe7wFXV0kAVyH0U5VNZDi1X+MGn6XxORoBW7aySqNbTmw1FVypsUTRm9C8vLbuHBqi
         fW8Sqpn/Nb5kvGRTK7CClmMUgewej3FdOOt9zpQNJ3T5NIwRCXwE1JTzPqlygBF3Ao5+
         SslOeU8wk3tmf09xCY1rPylTVYkn1xSOri3MC8SoE1mMshlb+hq//ZVJHXG8zKqFutsD
         +jCMOTPlljveObEMrUg4mwsi5OsLKoARCM3Z3PlXcRtIvFtqqGkujuWEkQA0TQNuaQiq
         kDKg==
X-Forwarded-Encrypted: i=1; AJvYcCWJmPaU9BnR+AvwC5N7mw1nU7+kfVBGrvgiHbm1vfABykF15ayk5qjOCWzeexGQ1OxvVYcbH5Q6yA==@kvack.org
X-Gm-Message-State: AOJu0YzGyrtGmPCMyBF+BZKER55sK7L0ZR7wOnzHDIgBkuq/+rfld2jE
	HB9HXZSfLqdFGUVYCrMV0H8bDFCme6tcIZaCYQ2tnebtl3ZwPK8EgDJ4c/mMmRGQL3lDm8TpLL4
	SHekG2uIfpnSLhVg54MMFeSfsyCqUyso7V8hdfTZWhEiFxsPhz+Q0
X-Gm-Gg: ASbGncvS+7o7CHW+HPoc8Yo14TkLaY4LunzDntH+FvVK2Vp3q8SIMP1/aW8aFzi1F3T
	G1CueKfkfBT+meuA2k0I0BEtejGJjr65OJsYZCkuWSehDEDubj+D1mJXFMl/xm6RC8zf45Tt91B
	3RlW+/WyHM22534Bcgx2g7jMdXZLuEAmFZ6wqfVoC+ttIl/CfYhu2f/M6O7X102lnL4Dn+x8693
	Y+/08/juP2e5vNhFNcUJx7UiG2fVLcrcHN7Li7jaG5MZRWiAm54NYbxndl4I9nxNsfvq4E5uTU5
	2cOQP+6bcZCDNxzbH5lWkY7PSPYsp2zuuWlUPLw83Oo9MJ+OWVHcK0xwmGeL+ptvjXQxQKs78XD
	u6NeOe7gK9BSK/9ZYVS/wmvXE/IetnG66mdI2JRR23CNts1wQbdjz0P41DjiKPlqHw74=
X-Received: by 2002:a5d:5d0c:0:b0:3b5:e2ca:1c2 with SMTP id ffacd0b85a97d-3b8f41595c0mr1938053f8f.2.1754475169348;
        Wed, 06 Aug 2025 03:12:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMTciqXottdcIXxB+Q4n4Az73fuhye2kzUIBiQJuGVEgLhsIdk2Fj8My1CS4lJuGy9WxthHg==
X-Received: by 2002:a5d:5d0c:0:b0:3b5:e2ca:1c2 with SMTP id ffacd0b85a97d-3b8f41595c0mr1938017f8f.2.1754475168846;
        Wed, 06 Aug 2025 03:12:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5d0b1afsm38474915e9.26.2025.08.06.03.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 03:12:48 -0700 (PDT)
Message-ID: <e7a52474-784f-4c7b-b4b5-d8dba30ddd75@redhat.com>
Date: Wed, 6 Aug 2025 12:12:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
To: Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz, jannh@google.com,
 anshuman.khandual@arm.com, peterx@redhat.com, joey.gouly@arm.com,
 ioworker0@gmail.com, baohua@kernel.org, kevin.brodsky@arm.com,
 quic_zhenhuah@quicinc.com, christophe.leroy@csgroup.eu,
 yangyicong@hisilicon.com, linux-arm-kernel@lists.infradead.org,
 hughd@google.com, yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
 <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
 <9552ddff-d778-4934-9349-37c7237cbb78@lucifer.local>
 <54ee1971-d91a-4fe6-90b8-16212c8568d1@redhat.com>
 <0d52d680-f3d3-454f-8c12-602f650469ab@arm.com>
 <9cbe9c6a-0013-4239-9347-bf5d43021fe3@lucifer.local>
 <1b3d4799-2a57-4f16-973b-82fc7b438862@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <1b3d4799-2a57-4f16-973b-82fc7b438862@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vS3qV8yED839NFRqt3sZmcS9zEyMqZN-SNNIbgzaPCg_1754475169
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kpyp8p6wspemr9sz518hj83ns9mhr7su
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9AB86C0008
X-Rspam-User: 
X-HE-Tag: 1754475172-920863
X-HE-Meta: U2FsdGVkX19MPLzo45u0lWVmty3UnX3+2Cek/NJvSlqtMjCEfYXNDiU5yV/kxhpl0PdKhFDEpDxZH+tkiKj7GhMC2D6z1azzZG5CoPtazUFcgdkh21oe3Eu9ZcbKTSfJYIXckHCqw940Xvqp2yLEoPeXpjBR96QEHxadIVF/CWPYWajN1nmzx+65RuaWo3b25DX/JDYYb56xCkjzYjartGo4b5L+zwOA3Cf7UxX6Vf261Kwe28f/ahTHS9vFD+XopRRpb5mqkHseN8b5y3cHQ7yztbkNFRNeiOzHw/lMQkgC/Pnsh9N6SH1Vihd0TR8oKniakZdeC4PEI0rllck1Bt1/AMlZAyABglXKB35mM9zxrlbl29AAvmnFYHVO1izm2un+3EIyoY4hTzBfe832s4dA7oeB+hEmRKTjvTZisW6c7lYEVOTtRUL9xDjMihxpId0BrXpwkpRETg/kuWzQbZg7YLKwnG9zFQ3pMF5CgPI4WI8EQRwixBz01N8aADbm1CezRNQTY1cSzJN4SLcgkVWm0HGINatN0mV2Raq01g07bDTtpL1DEFVsE3e7SK4wvBWGeQoRfokzSOBf3vyAJ3zaoFZXdSYk9hoUufBOvRkrrt2CRU/yiMFQ1yJm3QYfGLo+XK4/xL3K7gt0T32PfXtoGkjWCbgS0KVWNjgWnGRbPJHny0ry7XE85c/BORJvdz9Q75gAOo5VgEF43rC7UAQ4mTvTFYJmJwBImu8xSWwujlYU+C0ZKAQTtPe8HurjIcfjFkmfBZby/cKfYBqFuQ+q51lHYww1ae0YiggE/9sBqdTgCcfNJGJVWMHbDbiQvzOrwL1G2xHVGQOa4X20zspEZgQIzB0HYE5o8ZoFed1zwgEivZKmqWWmJJdSuQfKO8oQjfOnOOPkQdqctybF3La3slcNYI152wFlm/b5zMZP/ITgcwTR7q5oTPkSReQMSHPV3eVKnNkjlTvJGME
 0aJuNfuR
 /TT6Ym6xCaWQYUvxcHShwzvNZakpHnsADJd+etSC4CVcf4+vb1S9rAvueyM7nxWhztnsbgkzXs2J/1hYbYePIQMU9lk/wHeQdCjw/c5i8PocSpWhBdjBbaEr6LUaC646EzlJfpr4Pry/RIYkgZ8jfoYp/D2JZBBb+awFbmBPG1CIErsgfxWyWk0y11CPPA11mOZqK2CKUIWFKg7Yw2dlxB3Lz0GYYErOY6Hd4YEf/PmfFAgllEv3QgQDiGcH1A9AyeOmJm16ilek+WSTxPsu1ZvSkrxPvMFZo+BzK/p4llEhC8rLLa2fuIYjJQantG+y+K0VuT6NJDcGsqMrPJ2ASYeLiulLgtvIL69aelKXjyD9GwWNsFE6gCh/t8LYKnkXTftAuITao28j1MwV8b32LeV+imA04OnU3mJ0WstmK6bxxrCZdVWvuzw5Fj7C/DViIsfcE2hJcoavFWBc+lBMrUg66dxKlPo6wZaPp3RA9ZucjyiE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 12:04, Dev Jain wrote:
> 
> On 06/08/25 3:20 pm, Lorenzo Stoakes wrote:
>> On Wed, Aug 06, 2025 at 03:07:49PM +0530, Dev Jain wrote:
>>>>> You mean in _this_ PTE of the batch right? As we're invoking these
>>>>> on each part
>>>>> of the PTE table.
>>>>>
>>>>> I mean I guess we can simply do:
>>>>>
>>>>>      struct page *first_page = pte_page(ptent);
>>>>>
>>>>> Right?
>>>> Yes, but we should forward the result from vm_normal_page(), which does
>>>> exactly that for you, and increment the page accordingly as required,
>>>> just like with the pte we are processing.
>>> Makes sense, so I guess I will have to change the signature of
>>> prot_numa_skip()
>>>
>>> to pass a double ptr to a page instead of folio and derive the folio in the
>>> caller,
>>>
>>> and pass down both the folio and the page to
>>> set_write_prot_commit_flush_ptes.
>> I already don't love how we psas the folio back from there for very dubious
>> benefit. I really hate the idea of having a struct **page parameter...
>>
>> I wonder if we should just have a quick fixup for hotfix, and refine this more
>> later?
>>
>> I foresee some debate otherwise...
> 
> Yup I would personally prefer that. Although if you would like to see the churn, here
> it is (based on mm-hotfixes-unstable, untested):
> 
> ---
> mm/mprotect.c | 27 ++++++++++++++++-----------
> 1 file changed, 16 insertions(+), 11 deletions(-)
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 78bded7acf79..0735870e89ab 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -120,9 +120,10 @@ static int mprotect_folio_pte_batch(struct folio 
> *folio, pte_t *ptep,
> static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
> pte_t oldpte, pte_t *pte, int target_node,
> - struct folio **foliop)
> + struct page **pagep)
> {
> struct folio *folio = NULL;
> + struct page *page = NULL;
> bool ret = true;
> bool toptier;
> int nid;
> @@ -131,7 +132,9 @@ static bool prot_numa_skip(struct vm_area_struct 
> *vma, unsigned long addr,
> if (pte_protnone(oldpte))
> goto skip;
> - folio = vm_normal_folio(vma, addr, oldpte);
> + page = vm_normal_page(vma, addr, oldpte);
> + if (page)
> + folio = page_folio(page);

See the draft I just send, where we move that vm_normal_page() into the 
caller.


-- 
Cheers,

David / dhildenb


