Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C3ECA0FF7
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 08:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E186D6B0030; Fri, 29 Aug 2025 04:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA16F6B0031; Fri, 29 Aug 2025 04:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C684F6B0062; Fri, 29 Aug 2025 04:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAD0D6B0030
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:42:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 658AB1A05F4
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:42:54 +0000 (UTC)
X-FDA: 83829154668.08.80627C4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id DA70B100007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:42:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QCu3LzRk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756456972; a=rsa-sha256;
	cv=none;
	b=gFB6pXvX4wRXMuwEgvGm5RIoNmRpzMP76orn+lkFXZevrilA6gOsLUo2YxVdJ77hFItPzy
	EFSOUeoPMzsT6jdil0COxvrxEnHzAQw9HcilsWHEfX5s9UbC1cmGPGWCRqq6n6aIB8wGCK
	hALF7M/GBa+sObJrQrtKq7w+DJlw4Zo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QCu3LzRk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756456972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbeBHr+taTbsP5JGIPmUvS94n2HMJooGubjx7rvWayk=;
	b=Xu001p6lZXsrlVLxSrNXeGefvVRkxJnaGhahpBHOEwKo1/C+EvT0p1ZxAbIJIZ3vati7LD
	mzxGqO1bSXBvasR1pD0fcX2c8kx0XQNQOfLZ23XgstBipN4fFYTPMu6bhZIyxWHra2uTlO
	qU0xRuZQCgy6Rnfjd0cVRyd6G5nBU8U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756456971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UbeBHr+taTbsP5JGIPmUvS94n2HMJooGubjx7rvWayk=;
	b=QCu3LzRk0S7//KOPzR1P+TPw9JZ17lKUf7HV4wt0ovNGRcKh+sugMBkMkaWTVXOIElUkOX
	/c5KuaxXgGmjz7gAdletvJ/3fnvAnyKjsUtKzgIIynpN0L0cjJAyPgskTM5nXCJQohcyk4
	g0/I5cm7lXM56QhX3hCmV10NFK0vU2M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-DRjIl_60McirXt0RycqDNQ-1; Fri, 29 Aug 2025 04:42:49 -0400
X-MC-Unique: DRjIl_60McirXt0RycqDNQ-1
X-Mimecast-MFC-AGG-ID: DRjIl_60McirXt0RycqDNQ_1756456968
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b7a0d1a71so11625145e9.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:42:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756456968; x=1757061768;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UbeBHr+taTbsP5JGIPmUvS94n2HMJooGubjx7rvWayk=;
        b=wsFhlHeUHrOAUdezkFcrCT6Pnd1kY9HKRLiTTkuvhsykQjcax8r32UmS2S4eoSk1pw
         eMgErofBwzl256WOj6oKrxU6o176VvPVX5YIRz0RPihEVw732KT80am1NClaYv9vHfPE
         c+Vd4tchUdMOcCic+ZMffyZS4EwYZVmtewvluryyAGlqeFU2sG5pEKdUl/WbUF0xJmce
         lmaXQU1IOyOxIX+NTQ5N75RYaOmHDeyDUIv874Ah9huswLGIteq1cbzWB63LbuHhykoH
         q00VAkbyhC7JPi0LDjjcmgb8L7kP4GB6Lsx/JQI2pNN9+2K2cRv3uaF5onkM5ksgeVDv
         VKTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAM/QuBxgbTExQCweV+VMeRaLKXVp41u3TeSPQXomAz8Mxnd31TXfi5NJjIDjNX4u7k6TaWndoDw==@kvack.org
X-Gm-Message-State: AOJu0YzcO8q6zMR0UZVKdvno67LSwN9WmlAXllxGsdFTuhY3RuJuS8Ts
	eGc94Szxjfi+kKBkn149NffUTwpgDaC1XeicfO2CvZxcx+dFsAnBdY+eDV2sl1UyGlY0Q420HWT
	Y8aC4bZ163FeN1sBWt4Xw2R1WrA4SDw+y75XxGY007Z9zPkncgU42
X-Gm-Gg: ASbGncsDhZgemRIsD9UROkY0Jzey2R2U4jMif73eJeFhGcOM8MuWYbWc23eJzA0q5aV
	A70n6VNq/9DWiJtkO5nPWYVXTS5+niTyxmPNQcCjYASc/03hIsiiNqZmamHMthmfCmrGbtAYsZu
	FfI6k6sjgyvAx8twWcdwXsszfIWIuXBEhxT5pGyBk5U6Mh21sxNgpmobjo4LBFtnDg3LvT/hJRk
	DL7nnuo3hOis8vjod1fERou9fZV2Cv3OIdxri7RrFAls0V4ruEE6RwRmrS5SLfzIjOq6g4mPCUC
	F4vNTObi3lkEcAUX9qb5aAT9Orsa+tAQHP6UV7PGsJLPFM6McLGZMZ6mpdGUNi7DO0OjS6o6Zla
	oUzZDo7XZf4dog5PB5I5UyWy1SfD4p8pjGnSmxHYf6sl7INW2liUBcjQe6OT34Hz5
X-Received: by 2002:a05:600c:4a22:b0:45b:7580:6f29 with SMTP id 5b1f17b1804b1-45b75807bd4mr38150575e9.4.1756456968261;
        Fri, 29 Aug 2025 01:42:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLquX+Mi/AkVH2BhQ59mZtnAzUWapPkSncAvoK+DN68l+a/Jv8BNYFZPh6/XKoEruQOA/2lw==
X-Received: by 2002:a05:600c:4a22:b0:45b:7580:6f29 with SMTP id 5b1f17b1804b1-45b75807bd4mr38150355e9.4.1756456967824;
        Fri, 29 Aug 2025 01:42:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b66bbcf19sm70603965e9.4.2025.08.29.01.42.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 01:42:47 -0700 (PDT)
Message-ID: <f5cb68a7-19eb-40aa-95f7-51fd004a3f8e@redhat.com>
Date: Fri, 29 Aug 2025 10:42:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
To: Lokesh Gidra <lokeshgidra@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Barry Song <21cnbao@gmail.com>,
 "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, android-mm <android-mm@google.com>,
 linux-kernel <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com>
 <a0350dd8-748b-41d5-899e-1505bd2b2e80@lucifer.local>
 <CA+EESO73TRAcMWeo_aXkLM+0rT5nt1cxyvf+Ye3Xp9kqxL5=6Q@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+EESO73TRAcMWeo_aXkLM+0rT5nt1cxyvf+Ye3Xp9kqxL5=6Q@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iobg1zWqgaxoHCfUeQp89F5sH8vW6RvZR49E3pn7l3s_1756456968
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DA70B100007
X-Stat-Signature: 16h1cht8yas93wtxt5m349mhhhhnqnd1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756456971-261429
X-HE-Meta: U2FsdGVkX1/UPk9BwOG1QGHkpO8kM191lwoNNn46dj2BW8P8uPIYvx7EJWZGVMIpSqIpj7xdJHYC5vw2oCRI6VQioAGOnKuZfj2UBP/1UVMDAaBnuaFe1JXLvG6b7RVl+BkGjmDGiVTycd7gTwCbFgsAqaXWAlLXH8IsRyNM173w88bz9yj1CTWuk2hstygk6YGpnWpuOpeGvtvkFIYxXimrLPqjuEon8uSiJ01z7fUofKlkEZawudXxRTIs2xCscXYJ5DSg2/8/s43zqtqXP1fbLKmAV1e+THkoPb3xEf8BqA9LA6Fvd8bRUE8Svnx0xj9sfxtVTLzEbIdDJPilUjk8icRl3bkA5Gt0gR4vc6wFe+WUjjVr8+32pevwIV7WeOxeLdGktHEcWK1fIg8IP8cTUXO7baiPbFk/horTAG8qbng+1qktQjm0BxJYEQ/kGZeGXOSaJE2wgpI8oBmL24WL2ip/Aum8kHVr4Lm3WNVNWAkrweCZW4gu5aozSfixr5dE3/uoHX80T/5cDj2TZLKSlvk/Mq2N42ymJVHtb1UPzQ5NDjrFsciwQYzNrHpjOr5i2FrtBQqwWxh61iRUWK1/xTLaXp8N8loJorwb1eCVKIcfJiRD3363IV6qYOAjPZT2yhp2wTfbLAK7FFidSUcuYS3Iv78hMrL4J9B4J26D/HOVZuZX/XhUqJ71svsH2WFsIA+sCj4jsxvxoVygmh/9YVXtDiD95N84OVIcWGc0bKH6c9YxUPPECX9TqCfdNo6gvkwf0y9DdVmvP2cRZwrO7D+eNaHoYbjkn18j/KRsYP3WeJWXPhGWT4oQ/IHl4MsCJ6aBS+Ath7goLLV7fAxhziqwYMO34xbZ77SrdhxuwtjfvUgwfxIaoFQE5gAwOnZot8ad9NuoZQF/JJEnGwCpXN6DY7scudWtdPXJ2WFzqc6o+CZT1+Q+PPEmL1E+P5sIg0Iqsyovt11MQKF
 LXBXCcMA
 E7ThIUczJgW+/u83agaETFQrmKXM9LD/FP8Uk4kgMRPHK4zk0zu/aKvQ0K1namXntrZFgcT7rqg3mvICUhwVKnitOVRsuy0WAzZp3bGzEtvo5uAt94lSIYtXJDaNO/zIxf25ZgnbZbxJJewfAs2k6I/ZauDbikBH3EWsb7F/LMRXXMzkq8vlOVAkx54B3n0d9g7zoDccwDSBwQEHSDGmBAu9bxGxH5SraZGwjAK1urgG+Vqp/+IFk7x5Isc4FQ780RWoRi2QHVe9/2E7cWyq7BJPyNeZ4q8gBjbhZUJgjzcW1F/HLBWo6sxX4/96YSl0x1lHx56xyb2gFfRvcxevsztZWOFjcfkikk2UyuDO5dTo2/608smVl1aqedjQfZTXVGhgNGvlQFTDiyOoSGsD8JZbNkstsOX8fYrC3ga2N2CZyABLcbiYghVLMH+9oJbTHBShCE6SrDK22hUx9Qavt0HmUdinCWgbDrrFV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> I do wonder if we can identify this case and handle things differently.
>>
>> Perhaps even saying 'try and get the rmap lock, but if there's "too much"
>> contention, grab the folio lock.
> 
> Can you please elaborate what you mean? Where do you mean we can
> possibly do something like this?
> 
> UFFD move only works on PageAnonExclusive folios. So, would it help
> (in terms of avoiding contention) if we were to change the condition:

I think we shouldn't be using PAE here. Once could consider using 
folio_maybe_mapped_shared(), and assume contention on the folio lock if 
it is maybe mapped shared.

But the real question is with whom we would be contending for the folio 
lock.

Is it really other processes mapping that folio? I'm not so sure.

-- 
Cheers

David / dhildenb


