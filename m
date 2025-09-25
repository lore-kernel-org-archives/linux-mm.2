Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A883FCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 11:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1D58E0013; Thu, 25 Sep 2025 07:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9E08E0001; Thu, 25 Sep 2025 07:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3118E0013; Thu, 25 Sep 2025 07:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D79C28E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:07:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8ACA8B9B19
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:07:06 +0000 (UTC)
X-FDA: 83927495652.21.151AE6D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 342E940017
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:07:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V6A1FTI3;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758798424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9UDG3UtRC260Q/xWcr5X83IjVV0HFkPuvmSUV/vqtYc=;
	b=WXxlmiD1JvEVaWANMVLhxkUSYJbhlKEkVxTJRIif2SYb/CjqTOU934x9os4DSHaK6esn8d
	BxRf74swPeUkKK3ZWxF17bVPjdIKzWnCDfELiDvlPw87p0YgZJWMSjirg5p+kSiIXgCklW
	+2vBlb1E9M+EB46vxWIFICui5qLg5Hc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758798424; a=rsa-sha256;
	cv=none;
	b=3uSN2SH7uKU6rmggmSFzRm2QFzeikx9HlrBS26ObrcAhchKVvDGT7ANPhZReYDjHgjlmHX
	Y9WRyegvc7l/v/mB90H0yYjf+pRyuGw1hBPiJF5pWJFALmtsxMC95ft+kI9GEj8Mu9rjzt
	IiXxRpKwp9kWMvPpS6nYtNBPt51CIME=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V6A1FTI3;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758798423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9UDG3UtRC260Q/xWcr5X83IjVV0HFkPuvmSUV/vqtYc=;
	b=V6A1FTI331HxinC0ZKLmuxTmqweoxnr6skexSuWOrracgyRwfjxZxUMi7YFPGcxuoW/Gbq
	uAy2WG0lsi6zx5sa6nOePuEw+cbwnULEGv2OScpnptLqFPiUrlcxG72GTrv94n/hngmir+
	bkp2kwXcw7/cElLeVNiNeFhQPxrKorM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-lQteg5dsOV2RutsjqDkSVA-1; Thu, 25 Sep 2025 07:07:02 -0400
X-MC-Unique: lQteg5dsOV2RutsjqDkSVA-1
X-Mimecast-MFC-AGG-ID: lQteg5dsOV2RutsjqDkSVA_1758798421
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e38bd6680so509005e9.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758798421; x=1759403221;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9UDG3UtRC260Q/xWcr5X83IjVV0HFkPuvmSUV/vqtYc=;
        b=MTbRd2uw+NumZo6x0N8ysevDPk5Qsr1VBb2wykU4bMxIDGaNgLSnhfOKfpwDxEpYPm
         OxKxjnfW5HmNB60kiUvdn/clUMEAQjEbbXOFyPiLPJPcUntMmeZHa54XF1cTR3OmoAYY
         IskbSgBDGSQkieEzZmbOt5BapjF4LPtdXywBB/ptHPGiFnOXwu2U77ovxoZU9e83iGF1
         peWEAVVjf+TpGboj3vwSv8tD1TuRH9I4/diHJxX9+i1Zkleffcv6VCG5yuf1pC2Ugx5t
         qEPS2K+MSPm24Uc/xAdMZX8Tq/siYqJ3ajb3Ym3pOGLNXUi0z+C4RX1i+5riHQxgZ1Js
         14pw==
X-Forwarded-Encrypted: i=1; AJvYcCXFr6jPOLllPD0zVRAkN1VJ7hjEzNUrvWevrkB+ASYymZI1WzjeHHn5qA8+7P0cRsy0eMAlEUwvhQ==@kvack.org
X-Gm-Message-State: AOJu0YznJNEMmi4e0h9hZIIUh8JQivJ6DLP5oxnQBf5Rykt/PDMLYFrZ
	33KAJ3EW0pzTeYBOWPs9Ku6X6zwIKaMyXFhaoH4XOL8Nhhf4l2OnkqHO324BHiX464GJTALQLVT
	WmsYgupI/XOjEiwEkBy+nm/Ed3Hc59NYytn3TRBT5KcQDikASB23W
X-Gm-Gg: ASbGnctzMHr2aczH0We/MUvE0XLb5MRtdbC0z1ctV8heWHewftDTtmxpFMGRTMOP++2
	tRcZeOdpZwSZCd3/9eQ8Ey4J9L/MMSEs/eZvI+UyMSkbW+6AqecrZbYT4kn+axQ2j0nogHcf4qU
	DpxP9fvMXuixrfLjStG7XlzjZCUr41+TEOGn4F9Xjk1shMgBfEmXIvmK3d8Isu8yeQpENX0RXtA
	2HQ/K2YGBFpOXq43JrRzSVLYdnMKzl5tmlIsr6+C22CgPrWQuyL8DDySHaMtmvCpsJQCMTS0JEk
	UtXvSzr/t5ib989YPCXN/m7fdUnNwuk/wHJN+8trM53ZwCN0VWE5NusHxwBSz0JE480yCq/yHQ5
	vyMdIem6nP5/BeEXApoOCP3PPTF5pRqfGl9tAnja87ZTlaznLiW29taIOdpXehhD5tCou
X-Received: by 2002:a05:600d:108:20b0:46e:1cc6:25f2 with SMTP id 5b1f17b1804b1-46e329b2b17mr25844065e9.12.1758798420945;
        Thu, 25 Sep 2025 04:07:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHK/Xlw6F+G3SF7DEkRQxLqqsR4p9KpsSWYAACG7TneRIoOHXtR7kgbnwym3WqTjLFGZCt2lg==
X-Received: by 2002:a05:600d:108:20b0:46e:1cc6:25f2 with SMTP id 5b1f17b1804b1-46e329b2b17mr25843745e9.12.1758798420503;
        Thu, 25 Sep 2025 04:07:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a996bf1sm73938005e9.1.2025.09.25.04.06.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 04:06:59 -0700 (PDT)
Message-ID: <7305f905-0f81-4268-a3b3-933ac00cdb6a@redhat.com>
Date: Thu, 25 Sep 2025 13:06:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Lokesh Gidra <lokeshgidra@google.com>,
 Dan Williams <dan.j.williams@intel.com>, Alistair Popple <apopple@nvidia.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
 ngeoffray@google.com, jannh@google.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>,
 SeongJae Park <sj@kernel.org>
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com>
 <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
 <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com>
 <5549ac3a-20cf-4959-ac53-0a89ed0eadd2@redhat.com>
 <CA+EESO5e0gupVfM9NgWqx34oMRk1jGzsNfM=X3idPKaXkRL2fg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+EESO5e0gupVfM9NgWqx34oMRk1jGzsNfM=X3idPKaXkRL2fg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eLyvZXd9VK4TsE-TpOy8tVearDbGOSpteAAH9_cit2A_1758798421
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 342E940017
X-Stat-Signature: xog7bdd5jd7phgeg8eurp9ri4boi6act
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758798424-525438
X-HE-Meta: U2FsdGVkX18S2YQuq0z/SThJ9x0OYix8r+Du626CT+is4AbyQhYsLsklZBfhoZmyTeKnGZlRyNwl5NfBXDKyTDrJJjCXEcKWZiyHCNILph09a0HeLU/wGeUJd1LC7N9nxilKFiTsyzS3FgXnOR05ZeqwKhs2IrXmWNbQUtC/VSVK/1cjCWsr6yHgriFomCNG2Ld/279ifmHGUA6cECeXNyaIAE+uHNZ5npYP/XbVv9OKla2LFuQFvooED91p4t8po+TuMe284bKrAhrJqLdUBQ6AqzXjbtZPovw9gwj4UgCltucBNN6kz4MJLeyLxhlSL8eU12rN5E72f2iPMHecRNH7/cDjY3FIrvuF7lH6Gb3Sj7Th/NfvBRteVKBQQWZtT/UG1wIi/XAmxkCxdOedfqw65SvGrVdVWtwJyDUigfHpZYFsGxuW5hrPs0VZre1NrKN2np0ut5ARYk69OoRchYJtmKrSTWnmPO/NDVW8Ls3C0IOf+GGfZ+ixw0OGwNsQauTr2/idJ0PC/brEvIDTSz1APdIS1MawlrENbSvhCaE32dtJclFflrur7esqcCANl8HdZ4gtGBGDZCQQDeVsMSeSJB01psOe4STQpEsJyk9D8mZnUekvptt7HGA4uIm43MfuJIyydrLAgs3MO44QvZ3uWJ+/Nnrspb1ZKaYEH/e8w+VJPlOHQAAPmB40ABCg861jSRnMyBeJTMETjD69CSQW5g/lBveVbdid2FSV85ddo7h5hDZDxvm1wqUqeDypkzco1kPSu5RMwNMd5AYNxg67WHkeTSC/GRobqhbEbrRzdq3AmSgClL8etP+UWcj3r2aMNydwhToeVxqpyenB3W4G2aRGlUoZjJ+vkU2qDCnwA03NjEA1mkkUwJcw7atvhYqNAA/zUSvgDR9QFQ67j/Is4EREKqHiVK9uOOhfVf1ixE7Z2EP4MytK/+1nkcbTEuXS2aivc6/u2xtd2RP
 sSmSSX+/
 jEp5pnN74BLC2qeGR6xY4JyRRdUqPCfwOPyPmVLXfGiI53wjoSHkfr6sM/BKf17+iXNZkziJ9AL8TcnSzda2FoPRDlAjgHFE9Yl3Ccd2Wq8FRmZPtOxMXUWUwRQpiukuZk6LE/BOfo2SwYjCbkmz7ObXK98CQtbTal9VClJUU6eMbSEqRcgkAoHfWhaqKe+STht2Nep29NUy/b5mpB1+z7X6DJCTGlNsF7rO6DlE5yP8mLa4YFbdfSD24iK4EFImHzDZ99kdCxy68Tg65KZFS/69Fl4N/wdNJjYu/0JW0Imdop4TliEqLFB1yBIPZvhIqSea5wLo83TrlVw+SGxidIGYP+LpTEM+S6txFXuDLSd4UpT09flLxT7im8nsfn3gM45p7feDzj53GELkECb4fM+cfidqvc49UYzUcGzK9B4LPvCrFxOpgxSPKMxSQTCIrLWYRhGITWDg5yCnzm52HykupPr8l7McRm+YHlgaqWEOsAmk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 21:17, Lokesh Gidra wrote:
> On Wed, Sep 24, 2025 at 3:00 AM David Hildenbrand <david@redhat.com> wrote:
>>
>>>>
>>>> Is mf_generic_kill_procs()->collect_procs() problematic?
>>>>
>>>> The dax_lock_folio/dax_unlock_folio part confuses me: I think it only
>>>> locks an entry in the page cache but not the actual folio ("Lock the DAX
>>>> entry corresponding to a folio")?
>>> Yeah. The name dax_lock_folio() gives an impression as if the folio is
>>> locked but it isn't :)
>>
>> Sorry for the late reply, I saw you posted v2 in the meantime.
>>
>>>
>>> IIUC, a dax folio can't have an anon_vma (folio->mapping is actually
>>> an address_space instead of anon_vma), right?
>>
>> We have these weird device-private dax folios that are anonymous and
>> should have the anon_vma set up.
>>
>>> So, I thought it wasn't
>>> required to actually lock the folio in this case. Please let me know
>>> if you want me to still lock the folio around collect_procs(), or add
>>> a comment?
>>
>> I think we can end up reaching memory_failure_dev_pagemap() with an
>> anonymous dax folio.
>>
>> Not sure if anything would prevent us into calling
>>
>> mf_generic_kill_procs()->collect_procs()->collect_procs_anon()->folio_lock_anon_vma_read()
>>
> I must be missing something but dax_lock_folio() dereferences

Maybe the code is missing something :)

> folio->mapping (to get to host) without checking for
> FOLIO_MAPPING_FLAGS presence. If it were an anon folio, wouldn't that
> be a problem? And then in collect_procs() we obviously check for
> folio_test_anon() on the same folio before calling
> collect_procs_anon().

Right, if we reach dax_lock_folio() with an anon folio we are probably 
already messing things up? Not sure if the "!dax_mapping(mapping)" would 
save us, likely not, because it would be an anon_vma.

Hopefully Dan+Alistair have a clue how this works and if it already 
works as expected with device-private anon folios.

-- 
Cheers

David / dhildenb


