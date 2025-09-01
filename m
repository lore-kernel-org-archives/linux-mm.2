Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37731CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 867D68E0012; Mon,  1 Sep 2025 04:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F368E000F; Mon,  1 Sep 2025 04:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E378E0012; Mon,  1 Sep 2025 04:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD648E000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:20:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 140931A0711
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:20:27 +0000 (UTC)
X-FDA: 83839984494.20.E227EDD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id C18EF180007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:20:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RcCD2E3B;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756714824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rutvY9tMMADig1z9n6TyG35p/uwBG7rZBt/hGHCxQyU=;
	b=Ht6VSUBU6n6wXgdfHbWlCDP6LtLDQXocb+IarxLw+E9AaOo4IjVGOoTsHrvYetVvrJwTTT
	g9cFNaT2rwtJI1lgXKxT0D1Ar6+grqfP1Ps+b/HEcGRj+50kn0UoqWDbtETnNNKvcuwz3o
	oRkDglsOi33y+Rg64lLj2rKfb8PbAek=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RcCD2E3B;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756714824; a=rsa-sha256;
	cv=none;
	b=ijb2SDve/JRYYptiDdAdxGQ9lnaMzpYsqHH/N0HUa3yDzpkNtqbRdgvTSdYVk+uz1QxLdm
	gWYcppLaC8nvD7SExKs/gIXCSV+3eGaXNqmsje7qWhvn849rR1T1jRVmj8tWWct8f0WxUc
	xVWcQ2t703BumaVtioG1WvTixbkD220=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756714824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rutvY9tMMADig1z9n6TyG35p/uwBG7rZBt/hGHCxQyU=;
	b=RcCD2E3B3sUJeItUUH9wHPug0IMCQoStUXZ91pcjDiCPnneZtLPvF7RHuuK3BC7swLvscY
	W61wTzUsOljPe+3nZSV0aOvbEeI8AIBHcL8vizdaK606e8vrOIDP0mR/tDB9PjteFsUf1K
	D/rtNO/EqyShiMGPptsrqTAu29+HECA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-WRJUpInGNBiPkjx7lKRNVA-1; Mon, 01 Sep 2025 04:20:20 -0400
X-MC-Unique: WRJUpInGNBiPkjx7lKRNVA-1
X-Mimecast-MFC-AGG-ID: WRJUpInGNBiPkjx7lKRNVA_1756714820
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3cf12498799so1640151f8f.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756714819; x=1757319619;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rutvY9tMMADig1z9n6TyG35p/uwBG7rZBt/hGHCxQyU=;
        b=f5Kg+9ylricfILiH61xWW6Eey0Nm7huQ3OFK5KK77nu8OS9FlLUHnVyJ4OB0611jKO
         Cf5tBOLk/6m1vbAFXcW9DRNYu4e2e2T8NfEgrEHCtsRQQeNdX2z69pFf2h69Bxa4Pgda
         deNgWzYl1n38YBBXIUasuk+Nq4R/ZO44CPQJCFOplS8lB4zh8HBAxTfw/iL2dSTJkRfH
         64YK9ctlgeyosoj3AVfONjfwmiyQMrc39+XhOCxnbphJp7ag5jJSwWY5a2YgtVNb/iXI
         25Uw5Scpp4onYGKnh+bi0cOEHR+Nr1OUuPzzFiRQuY9veMpE17uLiF72zRyHNMGecZ3w
         J6Pg==
X-Forwarded-Encrypted: i=1; AJvYcCVYAIh3rKBsuBhJVSr983BoDKMcSQCSsLy5Y5T9XeOGjRZCx7Rv2kwYdoVk8JbA2af96IElCAMhEg==@kvack.org
X-Gm-Message-State: AOJu0Yy4w9Dz4T81cgcpZ4EdPwWgumLtMjbNVNFRQzqTDX4yDTV1+FZ0
	t5didk7qD2Ik2fKrcnopnTwIOjPfNlPlSKMZG7WF+zW/X+jVRDOyEZMF4ef/hfCEV0Ax1XgwC8t
	uNFyv32qXRBqAU0x7Y7b8bLU4cVbxKJcxLIpNa77n3rxoCkuu1+BsiAT5ahya
X-Gm-Gg: ASbGnctrpHfDrgJWrKm+6TGSWllLMXVcEZZgU1gDeyZRhon7IfFMypE7EtK55Pwv6ws
	kl9iBhQ+8cjf/Wx/5CPRRrRg1KlTctoJyVAgM1sUOzuAh/3M9ltBKXiUx+RtTqOYEjDVRQvnTqn
	Wk14/0vi0/wtzhmoybLANr34+uKVdWdxFkPkq011um/SkkMxTTURXIpBRblxyTyHuAW5mrSI2HR
	bRxiBxaFrmogqAF/p9NTGV3aYfuzMZnspKjWZI05ddCg0z/jZQo3nE82JBrcTIPYjwFiYOXliy3
	oha/vrX6fx9KUptAYusaXuof0dROdQO0lJjeddkwLu+OKecNUhZgqAU/78hPjjkMAXGVfg/ukVA
	pnJzC+pNSDRK0GMTvCyXsovtAxUGMrVtzZEKgTmaMdVxrm8tzX6igxC8vAneDvHEnLmI=
X-Received: by 2002:a05:6000:4022:b0:3d8:1f1b:9c9f with SMTP id ffacd0b85a97d-3d81f1b9fcemr734428f8f.55.1756714819416;
        Mon, 01 Sep 2025 01:20:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdmh5ifuvjCOK9QWl3WkvBZapyglTpnSx78anU6PThhgybWIAF61QvgVITS8wexYd3afXp8Q==
X-Received: by 2002:a05:6000:4022:b0:3d8:1f1b:9c9f with SMTP id ffacd0b85a97d-3d81f1b9fcemr734398f8f.55.1756714818939;
        Mon, 01 Sep 2025 01:20:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d26f22f5bdsm8611397f8f.37.2025.09.01.01.20.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:20:18 -0700 (PDT)
Message-ID: <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com>
Date: Mon, 1 Sep 2025 10:20:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer
 parameters
To: Max Kellermann <max.kellermann@ionos.com>,
 Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 willy@infradead.org, hughd@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com>
 <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5wHULPi3y7RVlwg8q2yDeMZw98dmzm3owNQenOZmsEo_1756714820
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C18EF180007
X-Rspam-User: 
X-Stat-Signature: wcpbi7zifjyupumkbun8r871kwko9r88
X-Rspamd-Server: rspam09
X-HE-Tag: 1756714824-601421
X-HE-Meta: U2FsdGVkX19XaQ40ojPQcihyS59sOhOCUdWH+gUols4M5RBKcd5TRmhUiH3Xwqza3H3sUeH4iOURPRA7aKiE1XgTQFgbfgX0K19juEugHsbWS72pl9Zo7qDXZ5lOvXV7lsQZtjvgOv9ofgC+q0GDzHxKTkZKfTHooFaGDbhHBpwVUX39CSTspEQnm1aL7amPSbkuPaQqUfrU2evhHQSFV/pTbGUBtna1liIoiKBHHN24kaB3u+4DH09QonAuvKiJwSVcaw57tecL1iHW7SQdojFP77DyCys6xXpNH0Xt2OEU3XPDqw1Cxh/TAcS2etdFTTE4Pf+r3rC9Wzj2mOo5eZvQrxVgz/GyWzIAVndykg/+1nIY4pggOd7DsjGwx3gKuQNGQWTRcJIgxdczNfYxUwaIcaGFafEEoUzTBFmQQwUlKf/3Cu+UDN8f0WySPSN78POiEnA67f9PhyRxvYt765H2znPxdoTQ5ewuMS76GI8VqXVlX0y2TkZSUY/JGxfbxRRECVtDzuaHJeIOvYqfQql4M9l8DAcbY5u/XbIDQkHPdUAG48imnRLxZwam/l+XRyG5H9y6ytgkbHrtdDcOkw/fnmXYATNkvcb6CZtaUf2bKAOmjcm3FjZbJQBgDpJMh8AqKUIWfqw56VhAgCgpjwuL7xGBH0iCYV57BztDXsAxGNbI25q28diIrh7V0pVH5Ywyn6Uo/OuGcjm2BeBn4qkGo4BdFHnyCjsw+OzSbKn69wzG+yMI9pf8cEgm0RTIvge/VxevF0bTlPKaF+jrL5TZG0ubiatvgvldQjFsxdW/zP7GgZnvGApVB8Bkv+uwiCURytO88csB50aaw/zvfd9T7Xs9Nq4R7VlFcmgNN6FcMP+OE+MZnbly1YsvTDgDfbcZ68+khD0mns+zo/01Ah1t+rj7sLbigtlf6ID9aZDooEuEWAJA0hyxgnkD/Ct6fPuachKMob14MKD7tIM
 jWUmgDFw
 TIfhyuwrsdW2TKNNDVNUItjbAbWxDoCDMSPuhMHOEtD+2Y489nqsM24iOXGTRFoMP1VgtZSPDATwXo3L/fG46FgUnvC3qAFwZiiDVVtwyXr/ZHKrOCL+Gojz2SHtBFxxYRIzyZ2r4IG1OHeCLY0nWtkEopBdE9O1gLuw2t1Ph3UV2qRu/oaB7z5QbdOW+4JTJxnIhz3Jr3xYk09qa7NH8fOnBnl0z6DTfZ/FhLRInoyjzCL9MJz2lPwVJS8/wKm4wm9aHS/88LxR9Lp/nUWNqFIefjpM7V6od18I4QWJy0vrJZdi228muXq2MwyMsSIcaWUxMTvDwnvmFczHgLn+Nh5vTx/UORQJJZITbyv4sf+WFraF3ezL2LnCJwtdVor/PTsWHUXLkbRPjjytu44+hY5FE46T67DAJ/Z9FV9rm5VXXB9wS60ObjMIRfgErQbsh57lzEhWH8nijhMY+v5aUw2ljzcOhPefYP6fOYz/3tQi+WiHki7czCILFQVmlMWbg3BYhaKY0BHu5XG+TSdAp8xThnIEEo5e0ZjUtHDAgGcDgN2adqvXm+IjtfDj9qet6tY0DbvtbdKJWvkNtMhxxV/YPckb1Ad1qPQD+10AWHEOQWPI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 10:05, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 9:33 AM Kiryl Shutsemau <kirill@shutemov.name> wrote:
>>
>> On Sun, Aug 31, 2025 at 11:39:07AM +0200, Max Kellermann wrote:
>>> For improved const-correctness.
>>
>> It is not a proper commit message.
> 
> I believe it is proper for something as trivial as this. I think
> adding more text would just be noise, only wasting the time of people
> reading it. But that is a matter of perspective: I expect every
> competent C developer to know the concept of const-correctness.
> 
> Do you believe the commit message of 29cfe7556bfd ("mm: constify more
> page/folio tests") is "proper"?
> 

"Constify shmem related test functions for improved const-correctness."

-- 
Cheers

David / dhildenb


