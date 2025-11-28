Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 137EDD116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 16:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B6146B0012; Fri, 28 Nov 2025 11:07:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666EF6B0023; Fri, 28 Nov 2025 11:07:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5552A6B0027; Fri, 28 Nov 2025 11:07:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0516B0012
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:07:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3B121403B3
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:07:11 +0000 (UTC)
X-FDA: 84160495062.11.B9222F1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5B1402001B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:07:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E1u8bpBH;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764346029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZy7R+pUhNnAxYbDd9Nal/7PKahT9rfxVvsH8RmVk6k=;
	b=fNrRwpr+sMzuGB8mZcWnZmIZdxKBo+V/ZufFO+Dda+AdJFoRgywH66QOx8dITKC+AUku9K
	TeQzwBb55TwzvazIX1F5ArdfLoWef4o5WSOX1WWpTr1H0nKOIvFwMTcgfGtfJ1ydBHCk0Z
	oAq3O2n9qcAVe4R5J318DL0w23IgwSY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764346029; a=rsa-sha256;
	cv=none;
	b=hM7xkloZ7VSUq3tu6W3+pr7sh8Z0R/CJ6WIDQA3qkIba/A5Di0KZssRmvvmNG/xjpgSlGg
	Ue+j20vje452ay6b56d9UqSAvTwqgvlpOKDRdHVMtBxoH/F7De9wuYXltsxkVceHdkd4mW
	AyRF050ci4H8zjY+tag/YeiexCDhFP0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E1u8bpBH;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764346028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bZy7R+pUhNnAxYbDd9Nal/7PKahT9rfxVvsH8RmVk6k=;
	b=E1u8bpBHJthQVD97W/PH5rtWn+/N9A3t83hQD0tky+/yP1LagGrtLMs20yUFJ7pXS+DbgL
	L1u9l5DMKiV8GbGkx4iCg46bixYz1oqA3n1KhKbkS3o8S6kwgFK4OFJot8d7q/atSa3dMh
	eAwvSNTBMPo6gfSD8Z/fIKimET9EiiU=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-AX1DeC26PCmfCkGut4I3ng-1; Fri, 28 Nov 2025 11:07:07 -0500
X-MC-Unique: AX1DeC26PCmfCkGut4I3ng-1
X-Mimecast-MFC-AGG-ID: AX1DeC26PCmfCkGut4I3ng_1764346026
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-37c029db228so8987041fa.2
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:07:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764346026; x=1764950826;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bZy7R+pUhNnAxYbDd9Nal/7PKahT9rfxVvsH8RmVk6k=;
        b=rxRYBvkuneDfZCOhzLjgJ/lUBxaJ5gXJthc5sYcTiBWUhbEX3l+AC3DHVVMM2a9L4n
         AgI+HMz1BFo3/GdTMDzDdSItgwBEE1GCT63qfqGWr+vjglTJlSwYxMOU6yqbGLrB0Dlk
         8evjMuRtn9Z9IlsBNfoMP73cyvCIApgXs41YQcef4oriE1tauATigPGKsAaGPjqjcdyG
         5xlZIqroURdPxQ5Ln2q6rAdXLKlJQWTWOvaGUCniN6VZTRql0Gts7np3VKBNfJ5tPvQb
         whVnPOawHarRuxeEouZBaYDJZ+wwOXAF/1uEJV/Rhsa8/j0YgtGX/GSKk53AtE2AUaPb
         Rf1g==
X-Forwarded-Encrypted: i=1; AJvYcCWxj2ob3saR2+GtU331ktIBwafNK2l2yaKUO8Zu9I1vlyePWiTRlg1imgfjX3ByLSIdIX1ooNHZUQ==@kvack.org
X-Gm-Message-State: AOJu0Yx7bRPlqQiP0ZCls1bHbMMlDFJY1Mvk3XYJ+9joINWR0pdgYn6a
	bkn49d2KJeoiPKNP4dVjg0pRO9aeeBWsIhc/u4rGAFnikAyJjEpfrTjBCxQALrAbe7DPN/hREJM
	JXfbMuA3mQ2NjbB6qoJTUocDQVSnTpvdiKBdmAIx8U2QwVVcvDe8=
X-Gm-Gg: ASbGncu/siDt348rePZjbMYIUTzJ0ncJ09DlWxj/99aS2aWOt+09MoeDzv6xwRvQbjd
	EpNtFu5MaCZxI9wev4ZvheeL3WgM1Jzu4Mn248+CJ2XMQZqA+NTBt/yb1v1gqk6FRDHxiT7WIE0
	QH7Dx/HjrqIlWb6mV5kRiiZcTbt+rV/XXPYx767USr/el9U6LkOw7h6BG2/LA2FPUdLH7e2B6nb
	/Wc5S/7TqXcdQrRHdERfNSdo6l9mbJjpky6CI4ZyZOqErc5VrNicu8NUam04fGr0xQ9x5UMKRRC
	ZcHAjG8aYT6XvgZ5sto6vzvwLc9bHt5tKMUa2CJYV5d5yuVnydhXxLv/gyoodJi8Bp4zVNZ4bu7
	wjgMo3aKWMazQoe41B0emC/ekGg10mqmWjZ0=
X-Received: by 2002:a05:651c:31c5:b0:36d:114b:52e2 with SMTP id 38308e7fff4ca-37d0790d453mr40868261fa.34.1764346025773;
        Fri, 28 Nov 2025 08:07:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHaeDrW3aE2rJtyHnJXLuP6JMIkjJMIi3csdxl+Xm82rf0LDd0NXyBgcu2qlQnEwf+K3Fttpw==
X-Received: by 2002:a05:651c:31c5:b0:36d:114b:52e2 with SMTP id 38308e7fff4ca-37d0790d453mr40868151fa.34.1764346025292;
        Fri, 28 Nov 2025 08:07:05 -0800 (PST)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37d240ec1fasm11118901fa.36.2025.11.28.08.07.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Nov 2025 08:07:04 -0800 (PST)
Message-ID: <584671b7-f1a5-4e9b-af94-3e284b3edcf3@redhat.com>
Date: Fri, 28 Nov 2025 18:07:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Remove device private pages from physical address
 space
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 david@redhat.com, ziy@nvidia.com, apopple@nvidia.com,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, dakr@kernel.org,
 airlied@gmail.com, simona@ffwll.ch, rcampbell@nvidia.com, jgg@nvidia.com,
 willy@infradead.org
References: <20251128044146.80050-1-jniethe@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20251128044146.80050-1-jniethe@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NCPsKLD-eTcVy1Jh5yPmUWl9cNvtIyAsiB-6U3c-4mM_1764346026
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B1402001B
X-Stat-Signature: xm4w7n7djqspm9wwfepr9xhxdo6j9yh4
X-HE-Tag: 1764346029-880068
X-HE-Meta: U2FsdGVkX1/g+HsEMP9qoeRQpGlo/LrjUJ3pi/igj5n5BpzOtS9faG266iu45jelkpsy1MZeYSXj5IgGaUWbarPCDYW/WpnQ4FnzIyVEXxLnY1X5oO2uhAAa6p5JvYaRc4jEZ7nXB/n8OdoV8672TXM6+L0aXJQGADEWETbO9Act30N10gAmCpatYancXn3sdNXsgphGsE9kH/RYdAaFLZ8ireObo1XR7gjT3krajxIZ/NgxDSSIai+XLDP80n48z3iXXRawbiGov+NdYdxFcM92tE6OjhDGKc+OWbcjMY1dgLhwyVL8syevHLzCw1wCZGv8nOMx2zQ0rjcA16b9RhcIf6lJedOes1cZjT7tI/+k/QDNGXm9fHkFIwSht6yhAWDK2YD6js6PnWElo++z3893p4TF809uI4AUoySri+dpu3scwdB0R9XJ226ieQ2KulT8d8C4p9OM3eVi6KQ67/sXOMotU3pWOpYrlSjatitnTu+I9jx2kWjYMQZ8JG1j0e3eMjN1DmlbRTLUy296vI0aeORjvhe7K93PO5bsu8NoJMLNUU6WHNT09CqruVxUHZTCJzFvVM2+YuSrGcD3RjFdkZuOI8V1CZv8A3rlybfgeSxK7Vuc+d54SoxGRbUpWaX5x5NC3/nzolp1ywdkMi/npsoENWb22I5gFvZojZK2/0TCujT4Dl1tRpybZRpOIj7GU9+RP5o5K+Tyr7RblLtchwM4biKgn5pVogqrlT8FxJw0bX4lsPyJ6lXD5kA3Q14HnDVlecUUgu4NF8Tf4lfDwMmPoCxWTvJDFH8MCUG4oNyJbvMN/za7SenRgPeZmiqkYf6OjqN20wYFLqSghDE+9wnlGJfLHKsO0mB22Y4qm9E8fa8pHuCz7hvpukNflJVVs+bwmwKEl0aIsykq6nWtOMGikQRjXhxOyLS6dkEfdwKqUmAayrhbH5YXTUnP//6po90u4KjKVG2A0yZ
 5FHjwq96
 MwMqXFaZ4tyOeJiCgSfGTu/ojEJNpqpGn3so/9Ca1wyJ59VHC2gLBoas64adEtJxNomf/HVsb2HoLW7RkN5nQqNzMl+P9Nta6hVsGMITQtFfZ87gK49GM5tX6DDWLmS8fEQ0fZ7PPIgn6spnWNHO79h6izqAETShks8mUZDeNX6IhRlw13qakZeh/e+7O+O2aSfXnnfFC4R7vDrUoLM9++xopewJWsjdkMn3sbnD244K4Ky+5kOvfWCTSuMvsJSTYiaObjOitxroeSVGsulrJwj8+zqEA9xqRZOg/xJc7oWGq3GzpZtni39gczXF2NP+1uVfeohFUyU4ifrcXJceX9cuQxwR5RcmRAt+gJJlBl89jkLlZYz8YpCHbYaNMtlShBMYmmgvamH9hbFXNNxew/JKE2Dx0q7EzAvA/XAXENMcGW9rs3TfSCRRnSi1wPsiBacHEEn7NgzUBi2r2GKaguzTI0VODT1kq+FDvgcrRMHHF6uKtAJGtyOV9Cdh0Mxgt602m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jordan!

On 11/28/25 06:41, Jordan Niethe wrote:

> Today, when creating these device private struct pages, the first step
> is to use request_free_mem_region() to get a range of physical address
> space large enough to represent the devices memory. This allocated
> physical address range is then remapped as device private memory using
> memremap_pages.
>
I just did a quick read thru, and liked how it turned out to be, nice work!

--Mika



