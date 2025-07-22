Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366C8C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58266B0089; Tue, 22 Jul 2025 15:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E936B008A; Tue, 22 Jul 2025 15:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6456B0095; Tue, 22 Jul 2025 15:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E59A6B0089
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:52:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FE76804A1
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:52:46 +0000 (UTC)
X-FDA: 83692948332.07.F3BD809
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id D9D3FA0002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:52:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NtObtWU9;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753213963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afDMNM/ets1wQdqXC3stxVj6V8QJ54jbNPfFinJzgxA=;
	b=YN4rmXcAb9pcP75pB2gn6u62jPltAMw36F1apOY8+otJdp4fMWnJihT5FpQRl5YTdbCWns
	VyrkplXZ/P5sAvxFrQrEiUAMMc5aZDo4SAFAfpT7ixzjEf2jp8BkZhOgOL3vtYnIR7g3+Z
	g0QQgs33Qpm+CuNr2SWpZ2vRACSpZGY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NtObtWU9;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753213963; a=rsa-sha256;
	cv=none;
	b=NWzhK/AfeRw9l3fq5CA4V7V/iBnYOcFoaUIaLbrUbeWG+YWaRdRYvlMzhusRDT1ym6WfCE
	xiRE98Ch0z/AvutnRa7G8wpndkdgP6j34jqpUvV0nBCYAu973ECKrOVYE/K2FQ38OKYmF7
	whCdMG5ylsLhdSknjzU3vQqITBsUsVE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753213963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=afDMNM/ets1wQdqXC3stxVj6V8QJ54jbNPfFinJzgxA=;
	b=NtObtWU9vGFSNxXgLTfcastkL5zFz1fihvYxgXFWaX2GiypvbagwYux6vvuDDwNNCXkV96
	JldGaxiumG34B365MkXC0GOJMVwx5oPWDqO/FUGY0TBc5fdmZPOgQq1EXMqlhRz3llOVZM
	VDBXWnOzqrIvAGWEuIGnTW78t5zekAg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-lT0guzaPP9SfA2HgN7pZeQ-1; Tue, 22 Jul 2025 15:52:41 -0400
X-MC-Unique: lT0guzaPP9SfA2HgN7pZeQ-1
X-Mimecast-MFC-AGG-ID: lT0guzaPP9SfA2HgN7pZeQ_1753213960
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a50816ccc6so3792597f8f.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:52:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753213960; x=1753818760;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=afDMNM/ets1wQdqXC3stxVj6V8QJ54jbNPfFinJzgxA=;
        b=A7RnIKyeI/cayzwjP/+dBVxsPQLLBHo4tRR/I3bic24+IvoEivoF8oAuiSNZmgg1KU
         q30aWA7ucOji1+fm6y76RYd7NpMzaTCMfaJGshDNFryL64JuEDnyGVwZ9xsWlPqt47/V
         UXJh16HD4T4pLhgIKtygN+mFVl7sPlItgoMxRiOPcTqJIhaJZUF9y0nRMPn1DBfu9wKB
         ep0/d3Rnw4sTv0tOpVpgBkGHI4wkTKZcnRKKVFC8Gv+X0B3kTGGcqgcawvbTTe9CMPzm
         5Q+ROq4emuoXG7pb4l1go+3wiEmk1F0GcdmkAe224n6WFbBTHg0HgYGqry0emXmD+09s
         SI6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWT60bt6VcOPwE79nawPD4fYvoaKXIrYT8o+qUxb2avkBFUcQWIKcg/FvNZIPHzTelKn4yM2XZESQ==@kvack.org
X-Gm-Message-State: AOJu0YzUvvKGxP+p7mO5hNTGCUD4qVe/0vkKawr932qvZdpe1Gi9C2BQ
	PlKiGcfGzQdd2lINb/0Y5IoAAEQPXol2n/HMWKwhNfKu14obNCch2wieFQPxiZn2x5d8je0eYUI
	3o/mbdayTIZW7yZHINMZpIMKadK2P8Ri5evPH4fmLHVecH4l6Puvx
X-Gm-Gg: ASbGncssJTwsCoc4EI2m9c6priyF2jdI+AdV4Pse9cIlCyJ4uIa6Fq74qZzcEvxzXx7
	obqRW5npX2ljfW11SlQ1XWA6AGaDjTQPxABGOaFXnFITmDrU42Yiadj55x5sHdtEnd60l1rOISs
	fKQCFdmgaH8BlKXgIfBrTLDIKp8WOagnw+03PvX5PaT3l584o3jLRl5qAy5mZ8LWLDVA2eKC0ZT
	RmYY4bxZUU2Kprcpzk/nA1+9sToyHkPHyaTHMGktzwD670QJxz6F3oIYC6QNYqXh1dndIoylYEW
	sh9qwHTymJldFoDsP3ZZNalYL1h2jStBzCdT9ZE+A2uPV3q+VyZyr1Q8UVzI2Ga1o03ZNSnn3hV
	LGqPvGDNP6j5lq/bwjbhfnL1EkdZu9lRl8EvDmo2CElVGOAdiJBS6tETybBHAhwbD1G0=
X-Received: by 2002:a5d:5d13:0:b0:3b4:990a:e6 with SMTP id ffacd0b85a97d-3b768c80d4emr397450f8f.0.1753213960395;
        Tue, 22 Jul 2025 12:52:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHst35ufjkfwSNwPNOo1bjqZrrkvMHnLiHFO3xBOhfcFGHyxPurs2yOJhrQR/AngBAvhnG9wQ==
X-Received: by 2002:a5d:5d13:0:b0:3b4:990a:e6 with SMTP id ffacd0b85a97d-3b768c80d4emr397427f8f.0.1753213959873;
        Tue, 22 Jul 2025 12:52:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4d7fasm14352053f8f.69.2025.07.22.12.52.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 12:52:39 -0700 (PDT)
Message-ID: <d1f70fc0-ef5a-4946-bc4e-8508b5e265a3@redhat.com>
Date: Tue, 22 Jul 2025 21:52:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add missing mm_slot.h file THP section
To: Nico Pache <npache@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>
References: <20250722171904.142306-1-lorenzo.stoakes@oracle.com>
 <CAA1CXcBY4rFLkNqJM2Dj-EajPw9TMTHNcYapw9P=U0bo=QNqkw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAA1CXcBY4rFLkNqJM2Dj-EajPw9TMTHNcYapw9P=U0bo=QNqkw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vECvHdgxhpAlAkrkn5KNElI_THculvovhB5JzyEEwAA_1753213960
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D9D3FA0002
X-Rspamd-Server: rspam06
X-Stat-Signature: 77huwbj3bpyxpe88ibj7rtjdbnh99kii
X-HE-Tag: 1753213963-556328
X-HE-Meta: U2FsdGVkX19x8LTd3Cg/ReUWP6j+gzn+ymFJcMSV/fTPmPCrloOEiWiGB4oytTuQgp0DFMgmUPcbMv/tVf7nCFSZi7w3YFKkB7W9ylmUFvmlSFEe0x/OJMII5z2ns0xxTMUrxM0J7sw98RiJoNjOCT7gchQi6NVeUgbYFHotnG22nNHbw7fuRabkMIZnzoNPAQoX9nftDmQihSdoiitvV9xpnYUSAhcHlIsLA8vkUIRMaMm1RPLFIoK5gUSL7v7gEN+eAdWIFlj2FXs0afUxOBcZ1WdfUZ6OeXkudxK8Ci8zH2rNmfbQEEniWFE/tzlHSO0k60nN5j5nNH8apYhKW3YwiUiyI+kWZ+H6TzfbzlU2CkG5IsPA8Nxj7VpHPVAbM3QyTAkcfXsCDYvA9w8yVhY4zn+CcXRjh/wKYJgX6hRaRo6yQF0zNh9n3MESxDt2xfIM4xPcBx2HKM09VA1eSJ9AjugrKeTj+lN94vR/taNobrdVQSrO3Tpj9zkWkYCUtNeNwXKuVVZnCcA6D5hYkX/lX/L44s6iffNvGrYpd08X1fb3S3y5XQE0WprJp8EsI7bmjQ0i0OQunVcC6E0ASqWMalnTEKqAgTDfSYNGzurxWzWLSsf/y0ZLtLroSThUquGKdA7T3DK0/BCPHh4liJ+YAdfmDkJuFwczhvPT1hUzLHodolgeB5Um7hQxqdS2HmJsKW4SH6eGb8276qfYcn6+KhP3qkHuImLVoeX2hpbKLWg4Y6M5onsop0cjQF+2G1A6TX/1c5juQOzcTpTY/6I1/vDGuMkrf8eJLrafDyKnw6UMnGmtH6VdoIxHw7pveeH3bXXndcg4xgG5iPP+MwBKFksXWsxuGbY6zFg18gp00ps4z1XcQbTbgOG6Waxc03J+4AhFJRddya1BfPxvZHQj7QoC8Vl1Eh92utgj4TJY9kw8ZbnCOPZKjIWGvTkRwyZZ4QcOJo3a9/MjHNP
 UiLp4W0G
 qUWGvT/z5KmbDEt+Xhk5+Yt69lIz76MHFlUWVddVf5EMfhoywSjUg8WfQoa4ijriDY9OS+RQcJycsgwvYKHokXJtRhLEDyXUcRZXDhgznyp4doF90Eb4TiaVdXL5LvIH4wFgDect86UTG4xF2vCdUNkJ1+zg/lO42BNxl+bPQ2/4MsQKnllnoXpNjfYaOT0XFopkalivh1E8IqraJE72kKpfrwDevW3mSZ390/PvhfeTFW1tIe5XF/rhjBekIgjpWXtnek9UR+M34Rx3bk+qyj7LOpfMZrRidUK7bs5XofDVDrXPNK0xbR1do8FZEVYLpGso2HAEGP10bUPybcxQJU12W7HhxY5s8nZPX0kbgg+FSsquqJU/xYvR8BHiBuV/AfwZ/5nBHdakVKMnSO+M20Vi8Ng1nqY9dMhrT58r8XBYTcT2PA9v5j4+ydjXLouJzuCSBQTojCVyhPrUDydkvozGunsEVcC9ArbieC8cvGPRe7L2rJ2jpeqHt+x9+QLtOh66k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 19:43, Nico Pache wrote:
> On Tue, Jul 22, 2025 at 11:19 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
>>
>> This seems to be the most appropriate place for this file.
>>
>> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> ---
>>   MAINTAINERS | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 837bc5cd6166..3f83fb317f51 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -15966,6 +15966,7 @@ F:      include/linux/khugepaged.h
>>   F:     include/trace/events/huge_memory.h
>>   F:     mm/huge_memory.c
>>   F:     mm/khugepaged.c
>> +F:     mm/mm_slot.h
>>   F:     tools/testing/selftests/mm/khugepaged.c
>>   F:     tools/testing/selftests/mm/split_huge_page_test.c
>>   F:     tools/testing/selftests/mm/transhuge-stress.c
>> --
>> 2.50.1
> It might also be worth adding it to the KSM section since both of them
> utilize it.

Yes, good point

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


