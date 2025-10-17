Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D65CCD19F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ADAF8E009C; Fri, 17 Oct 2025 10:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785AC8E003B; Fri, 17 Oct 2025 10:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B7C8E009C; Fri, 17 Oct 2025 10:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 55A668E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:45:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 043A3140206
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:45:24 +0000 (UTC)
X-FDA: 84007879410.07.89D95E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5F76A4000E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:45:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WqTMoyVh;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760712322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50L0wSsrszh1IaUIuqNU04UiJRfz81dMny829g/ZpdA=;
	b=A8oy3dh/kEtFEqMaDDdCSlKtrCUQqn8vHtTKycIVGcE+p2RJwHX6IAhU4aIf7p3apmP5KD
	v2uB0CVGxhIfSeMO2KzifXlPR1BHZ9D5GjaBJzO2iHdis5cJsjCoodykubhlACuVeUf7A1
	7Z4C3T5OmG+DXoZ65qvtNrBsyeloSDg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WqTMoyVh;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760712322; a=rsa-sha256;
	cv=none;
	b=4kVqHOUuplUdNpktbZBMuCzkT8RFW6A479xEgu69ghhj0AUCLVIJagNFGSdEN7PbhpF52a
	UtsE3VQrlfUS7wYH6U4qjgHj2N6F7PggowGzpjRQxI4tSANdTAI9sSxGMSDLR2NKK8d7Hx
	AqV/4s9IDR478xK8bGkXveSjxGoMdz0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760712321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=50L0wSsrszh1IaUIuqNU04UiJRfz81dMny829g/ZpdA=;
	b=WqTMoyVhgqdpQUAhBomI+rMDmYd/iSqRqkEOc94Xj7bJPIHmea0sJZ33DnBMmOGtA5B/hJ
	TpYHN8pfh1f7XzlrDo/xFsiF24GmSp6z7ddZbFsg2VIBeDSYkcs7/7p91J/VsadGhtXgZq
	M0pmmV5wLgajbp3k5pd6NishUeFywzM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-yNw4WvcZPE6BknzLDexlrw-1; Fri, 17 Oct 2025 10:45:20 -0400
X-MC-Unique: yNw4WvcZPE6BknzLDexlrw-1
X-Mimecast-MFC-AGG-ID: yNw4WvcZPE6BknzLDexlrw_1760712319
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-426ede1d66fso1250221f8f.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760712319; x=1761317119;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=50L0wSsrszh1IaUIuqNU04UiJRfz81dMny829g/ZpdA=;
        b=Dfq+svxtZ1DaRvnQyJKYuutgINrV2qYf/zvKJIB3iFCLndTzy+NhJ6TVSLJk+uXI2M
         /HV64LWMwahCRbvdG9Ur8JWoXvA/PUIKYi3gDTtgs5WPmdw50yNViJ6KUqdxVHTG++R/
         vDLd81KmJDgbZ0VDs895YLL5PhruHsIcmpE6QEhslfpzPnCYLTB8zSdhiVG4B/2dD2ZO
         vW00IWcGI/o6KLoQKvF+alVn7+fx+4pwYK0bU6bC6CF0mRrwDu8XKgN8iMUajfteoawW
         6HnfkGbdwpPbwRiAtG8TL944x9JUy0uzTZhgOV98i7DYo2p2ZH9PD8vPvZiyhjzI2I/e
         UwaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWP+SSY77jXSKb6UdIl2PMQzpl1cNMQU9AdV3kWmJ9E2LFtafXwP11f7Q+9wKd/PLeeKJKFMdktsQ==@kvack.org
X-Gm-Message-State: AOJu0YzD5cHTOpcJIeVCm3bswCEXS/XNmSWmcaNg/SdU+bxosNlVrFOF
	Si5peQI0i+7O7pT4olznsUHspcG6spMp1qzDpw/IK5Bnm7UQ2g0oMriMh1ytLHCYGqrM5NZCYZw
	HBT1Bfj5m4f4Zk3jquAFxw7zvGlswCJp76lsXmPInICDgG3QfXMCa
X-Gm-Gg: ASbGncsGdv6VzZtzHbMF04smu8xp6zm1mMYRwj4/wGRjzaEFADcM1FD2e477NKFYGh+
	9pZ5T13Xhgi+pIz8sxyrzj08uwdV719O9ree8R3LNANdm1SY9WhUk4w1xjAYsJTLCLxYYBNzwG3
	uifHKIcQIO7IJ4G28Y3k7IWoFS8h1wmKNA2h7rkQnujyzBBKJb1gZrHyR2hm6iUfcnzZDRmKxyE
	JW+VeULX35rpTMmlsZDW3uL3aLT9F2TEfdFfeFgS4Wt4eoymEL4aZ0mQLTVH9KEGYQJlXvWnG/A
	IjBlSB4ZSrvVvwPtsnm3s/r/1nmmp0xhJqbOcrCBCSWeObCdGhY9ZbgfjgmNxCdscj/R5Bq477I
	cSpOnImHo4mJlOpR5PqNVUdTqTrZ2dCN2mcqRPfz43tnmG5X7rgsQVXkGML5hjxZktgUxWde4Le
	qDEoHO3DopGuQACPQejojKyU9uh8g=
X-Received: by 2002:a05:6000:2287:b0:426:ff4f:39d7 with SMTP id ffacd0b85a97d-42704d9447dmr2559587f8f.34.1760712319194;
        Fri, 17 Oct 2025 07:45:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMZ14so4gNdKhLYgCqIN9hQLQFT65q8ZlpDrXHep+wmcQdWI2usvv1G0M4plRSBFlmZyI4Gw==
X-Received: by 2002:a05:6000:2287:b0:426:ff4f:39d7 with SMTP id ffacd0b85a97d-42704d9447dmr2559561f8f.34.1760712318748;
        Fri, 17 Oct 2025 07:45:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426e6f03a76sm25459672f8f.36.2025.10.17.07.45.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 07:45:18 -0700 (PDT)
Message-ID: <d0a2c81b-a0e0-4457-b355-2363f30ecfb8@redhat.com>
Date: Fri, 17 Oct 2025 16:45:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
 <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sPpIxscjo1mDzIhN7ujoP3v38ZLl2WvnnE3Y1sUKnJY_1760712319
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F76A4000E
X-Stat-Signature: n4zpbuoqoqh4o8bafpf574jocjnuu35m
X-Rspam-User: 
X-HE-Tag: 1760712322-631114
X-HE-Meta: U2FsdGVkX1+N0rj5OWd4v58VdfffkvUC9EoG99q4jKN1glDfWEi2BCxpMxmgjxrLk9RfJwN4owfiZwhc0uKFlOzimjWcFGAcTfMEl1CggxTZOE/WIoyreGtQF9wSsvNJFmvdw5sVZSgVz8xsED49kdj1+7yFwuF9QZMYancmWY0k78THG4OCcWq/ACJZFojloje3hmM+yCU6Wne3o3d8Qs/XoH1t7P/kqp0/MW7c2aJuC00zMIF6WWWSECCKH2X7qRblf76FMubZfq99Pdyn0IanfJGWru4J+5Yrb2la3pfwDkfbDmEJO0GDm8MzECI1P9+Rd4Nte6ugllzoJ1zd+/Aex6nm/4dW33pBU6bn0VtIloUfn9wUX2jckS/oRTraGKtahLjYsLPsVsBbZ15//W7T/AoGXPipYUQInd4O0jVPDOzE+QnfFQbfWGNNSl32j1PbtiU2zC6eOgdORCdnzL1YnSAZy77qz6p6Sk7yMuzcQ88j6PqCjoCawX2Kza22l2eZkSPWhMmhmqBX+fGvGxQ3j24RY/Waa0ID4nZBUiP1ymlbzFzKxlYRikeFcPOjdOersXLB3F7r+SZyQy/ilxgj8nXCSu+L5+j44hfeoY7pPEjIj57UriSxvnTRkqnw37R+/pADDvE0oxZvNtlQmUtbtkCv+0jrT9GgR3h8cBrg3D8Vn2JZ9krOXDaM6Fx9JsPnBE3r1K033OwS1bvA2DVnt/UOWrXxAIjA9MtSjt0GTnrb9pkKZX4SivU7/QXBL3LKsy5C/N+S5r9ZY9UArdNMOr+Wo+Iq0NGOliXoEovXE+DyQvPycDJiRgMgeygJvzLdnKhU4+j4MW+Hwr/viYWT/wqAMW+FS4NbfnCZPELtrMdlYAR37jRzG9d1td3RVcQArvb6DnAedvzJbos8AT/iEyUF/WwJ0HR9er0yTAv7nAUeeKoEAGND+2oCczB3Dlg3QbaI+JTeZAeESTL
 nSLEc+zW
 zVFBGxEpLZJbohi6b4KWRUSOtxDmJprMmbbDtSEJARJqWrf2P0CJZCkhIeEn3L8bC1Hh4xwreKs83oEwYPi0B0qwL0T0SOcwuOvJ/jwaIYro6nj470uSLcc2bNORRnoRKt66foAGIGa05GBzP2Vf+47O0IraM2o9qFKPee06AnzzRRfsajU3Mx6995jS5BxPhHGHnO49O7dC5T+wgPZLwCpAXcRowTbUU9ZiRI9LFQJ66BHbjnbhnUjyNSd75S5vMrELDS2u441gKPX64BJsVjgKatlNEfGhiqLtVuauggfv6nLoN+5wRRcyJ2n5PC7GFoBiUCOPcTLWqxGWECFxlX/zd6ssniQptIsz4fMVMGkZKblUsHuEPTfQPrGaMQQuuyR8YaeTynAj7f9Zhq23cgfYoW3YvaDpyoS6cbtbSvwPDzAnlhnhxSw0U50uPEu8bjqy/ewXPVWbCS9vCKl0SE+/He/Ff9swAP1CNxdSaBdX3FE7nEh3LjJt+s5W+aBrSNgRZ9SVY8zumGVcjB7b4/4GQZtZSLPHtZxva3P8TuVB+cLfBVFrf+P38cw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.10.25 16:26, Zi Yan wrote:
> On 17 Oct 2025, at 5:44, Lorenzo Stoakes wrote:
> 
>> On Thu, Oct 16, 2025 at 12:46:13AM +0000, Wei Yang wrote:
>>> Existing __split_unmapped_folio() code splits the given folio and update
>>> stats, but it is complicated to understand.
>>>
>>> After simplification, __split_unmapped_folio() directly calculate and
>>> update the folio statistics upon a successful split:
>>>
>>> * All resulting folios are @split_order.
>>>
>>> * The number of new folios are calculated directly from @old_order
>>>    and @split_order.
>>>
>>> * The folio for the next split is identified as the one containing
>>>    @split_at.
>>>
>>> * An xas_try_split() error is returned directly without worrying
>>>    about stats updates.
>>
>> You seem to be doing two things at once, a big refactoring where you move stuff
>> about AND changing functionality.
> 
> No function change is done in this patchset. The wording might be
> confusing here, it should be read like:
> 
> After simplification, __split_unmapped_folio() directly calculate and
> update the folio statistics upon a successful split, so An xas_try_split()
> error is returned directly without worrying about stats updates.
> 
> David suggested a change[1] to make it clear:
> Stats fixup is no longer needed for an xas_try_split() error,
> since we now update the stats only after a successful split.
> 
> 
> [1] https://lore.kernel.org/linux-mm/518dedb8-d379-47c3-a4c1-f4afc789f1b4@redhat.com/
> 
>>
>> Can we split this out please? It makes review so much harder.
> 
> I asked Wei to use a single patch for this change, since the original
> code was complicated due to the initial implementation. After my
> recent change (first commit 6c7de9c83)[1], __split_unmmaped_folio()
> can be simplified like Wei did here.

I think it was too much split, agreed.

This patch was a bit hard for me to review, not sure if there would have 
been a better way to split some stuff out more logically.

Most changes just complicated way.

Not sure if splitting out the stats update change or the calculation of 
the number of folios could have been easily done.

-- 
Cheers

David / dhildenb


