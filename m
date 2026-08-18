Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CDECC5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E166B0152; Tue, 18 Aug 2026 04:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDEB96B0158; Tue, 18 Aug 2026 04:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA65E6B015A; Tue, 18 Aug 2026 04:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF13F6B0152
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:22:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21B3640B60
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:22:56 +0000 (UTC)
X-FDA: 85113699552.05.EA43916
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1EB2720003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:22:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g0srMGQU;
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787041374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y79lKilZje+Nl3Rv+2N5vQhP9be8wEt4E0ek84GffA4=;
	b=sZRYic/JysnK6rM9pKCTEcbIlzWnPAq4OlxgT6dRP9861p+FDjT+FR6PWJ74ustLj2sdfr
	VXxvkp8ZXHO8PQi1xmmsqVKkwMqurIJ0rFiazjMg1MZKsOTtO6L5L/PpOKohK1+37XbgvO
	ZjIdsCqNBr2KveoOfBe/RkFfHqhJ9nw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787041374;
	b=VqMPtO897Re9HIhhZKevtj/sV2uQnnaWHHATMi9xxtchfb0c+uEEQBiyJy0ulxEnxbT4Vj
	qeWcF3H5+Jh6OSqMio6PG3h1pgqrgvXkYfR6jAhY7/VqHqTVNrXYHOWnzKVlJHdMCd/dM0
	9tjUZlfZ3YsOsBY5cdgNBu9tncLnMao=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g0srMGQU;
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso55312515ad.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:22:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787041373; cv=none;
        d=google.com; s=arc-20260327;
        b=pPO6KxpUjPZxyP/N5dF2+Q5M2ra9eR/shkGrs51LJzj48CD3WqiHgfbhXrM75k8xie
         8I/Mft53bXJPfhpSuXuc4GKjQNpeuNJFXL1PdqSBK4YwHg2iaB+QUmmpYz3c+YK59P9O
         J0yIQqxujd1ORGy/WpEcJCUbkDwFuaVM8duOKUiCcNquFkvJvWsl48quicyXD4GOCPNu
         aYQNfHfRZ+mawvBpINyihmrz1B6uMCbAA2xNvvMipm8B8EB+AyJXGA/oKQQzCiU/dcHf
         eYkBq5X9euNMuxXNq+hKommCnPfxS2ImTcVp5X8GWSOIu6aMndUSw1xfBvc8mvkW25KS
         pHmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=y79lKilZje+Nl3Rv+2N5vQhP9be8wEt4E0ek84GffA4=;
        fh=XylqQ5SJWKAqRcA0RWNomer7EmFHDpKgqmW3YhtbZio=;
        b=X/lXrHCm4NGAOhcgJbSvUXGaWn462eQkCGo9Pgfdv7CN8y5QvXtvFDAXaMGde3egga
         f8g7yzXW4r2xRJYPxdlKQabL8PrpnNOYuYRyaaB5WM8nJIykCwtIQlnU/a2PuVMZMkwA
         H8R3V9KuaPqnEUuBTz0hYDNljwajvFBFBy6rgJooGDdwFt/sVpy1WlOPPB3PpBVZJyCs
         BJlAoIghxTDIQ3rlMsmgGqY20r8BvTG/LQQTVuCKo0rYGvvFW1DPtQk+gTOHajP0abll
         LQsenopGUEELKHI8rwKpS3XVgELE+zloYpfJZDuzt5NyOKrXdTFy5Rg0CA6NE7LR5IWO
         CImA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787041373; x=1787646173; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y79lKilZje+Nl3Rv+2N5vQhP9be8wEt4E0ek84GffA4=;
        b=g0srMGQUfrTme8TL1eX6+TMz/+VvrJ+aV/arIDy4GvLC2jSEXORbeDbgzJfjoQU20j
         Ih4AixvVt8DH3b1geSu29FtPUL72oVve1d/va9rwZt+a44PffK8p7Ub5o+yYjygcgg7d
         CyIuJbfMeHskeiA2DG7LGAvdAOOp60NVz18Hiki9nbMP4abSARYJ4ZGFeIkpkoKr1+54
         2brCz7vre87CZMwIIp9YCgzCH2BFmqpLRcVOgMHHFRHPPtX6QOhMmtUqsWKA4YTbSVCw
         lD7FsJQRZ1MTJbtDZ15KBhNZ62ibADQT5reUSgaEDfVuUUCuBy5lRcZa5V45NQOea+Wb
         a4ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787041373; x=1787646173;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y79lKilZje+Nl3Rv+2N5vQhP9be8wEt4E0ek84GffA4=;
        b=nrYAd7noBCioNPuQYKGJr+iTYddK4xN4AzYnfqeJr5DUK9pDqTMFIWbsA6ky60k9aq
         UDW3NcGyyf7ZVpIqzg8RpWK1qKngva1/Ig7hs84ESd9P/+XxHJhSn+PGbiBZnsFfcc/c
         1baYtIPXYSyme9qybYJ//Xbcr97PQn4G1ebEFGFnxiFZZiZj0SrNk96seG+nltJfzSdW
         R5wRN6RSY74OijpLOu1d4jq3Lki5E3p00uiB7SwjoaQW2ELAc58EpgQQu5sd/PA+F5E6
         1fc/jlLPZHndD8TuYqGeiZazPqMwknW+EZHntZCdY8XlycamMEOfUTUYx68R13lr9+mD
         ETqw==
X-Forwarded-Encrypted: i=1; AHgh+Rq9ytYHPFM1UMXAxb+5DxxxjXNmQj2rczdq8w12ap9oleYtZDtTwhNBo2xoYz859GlyVZwFgFnGFQ==@kvack.org
X-Gm-Message-State: AOJu0YzbiMbqxkD1voKrdgFyVogfy64694MrLiKbq3HuCFMCAhH294kB
	emEwuZ+Af1DRzDVsEJO2/YGj1N2DRC5EIDkLdS0vLAphYVawqZh5p99Vra/ah6/JY75KFmQwujJ
	ehC06xkHn0cYo0AHNWYLAzusuanXB6IrMBjD0t/F1
X-Gm-Gg: AR+sD119yRRscruYcjvWE7ByBg/RWId0kkh88bK5XL9XZk/4jCQYBimlPAhhoTjO/Oc
	CO5TpUwXVaDvHJIx+V+5XmpGvnNU1lIOoOBhKbrXlTi3Juq/p0wZw8iA03a1CyjPx6pOJeatLdc
	/sF8wCss+gndzxcLISIPFkdgwWLfZGPf5o7P+dThkCF/Pe648QIAVkPKdpD+JBFOS2M6CrTAFKl
	MFbU7Nc2pTn2dR+R5VQHD2y/v1hbXQ/Bmc3oJeUC7OzVG4oZ7qwzT9gHiZfEUIwVnQrzbLMo/wC
	l3CtRwC4ZsHb5NkByvBg3CICLgpEX/YvuiG/lmkR7CInMUXbr6mX/wmt7+woaraA800s5b+14Jt
	jEWvOZp+qrQ==
X-Received: by 2002:a17:90b:314a:b0:395:5404:95 with SMTP id
 98e67ed59e1d1-3955a79c987mr7608716a91.12.1787041372060; Tue, 18 Aug 2026
 01:22:52 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 18 Aug 2026 01:22:50 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 18 Aug 2026 01:22:49 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aoOJRk5SXBzzT24K@google.com>
References: <CAEvNRgFWcndQKJE_q+ZATFZEMYd=6uRLygozLvg7L77bPX0cEQ@mail.gmail.com>
 <anqqKH6kuwpvuwp9@yzhao56-desk.sh.intel.com> <CAEvNRgGWDY_fxbyBM-5sMdYMevMe0HzVP9kbC1cCGLE_dV=_Gw@mail.gmail.com>
 <a71d4fccdffd1f6a12332ddd18fa812542ea2118.camel@intel.com>
 <CAEvNRgHxda6XK_XqWaqqVnA7oW=Fhp_C5gF4vNcL+-HfwfXMqQ@mail.gmail.com>
 <0c80b9b0e13e3ab2cbe4f9eaf4a02ebba25a7001.camel@intel.com>
 <an5RJYTwlYeym--O@google.com> <aoKnmW9St5zCoTD3@yzhao56-desk.sh.intel.com>
 <aoNrFX9yLfsM7KQI@google.com> <CAEvNRgH_=8YqKHb_OJfT583ZJ346cceRimd9YJ762Vv08uJGHQ@mail.gmail.com>
 <aoOJRk5SXBzzT24K@google.com>
MIME-Version: 1.0
Date: Tue, 18 Aug 2026 01:22:49 -0700
X-Gm-Features: AcwNN1UwBN-I8e5ZL1Wm4VeVuI85_vvgyrgG68xpeG1bFCBW0uOQsMiH1U5tIzU
Message-ID: <CAEvNRgHXXXBgO2Pw9PcaiaTLXBrm-F++nJKSeHn6m0rnZiT7RQ@mail.gmail.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
To: Sean Christopherson <seanjc@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"david@kernel.org" <david@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"steven.price@arm.com" <steven.price@arm.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"forkloop@google.com" <forkloop@google.com>, "tabba@google.com" <tabba@google.com>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, "willy@infradead.org" <willy@infradead.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "wyihan@google.com" <wyihan@google.com>, 
	"pratyush@kernel.org" <pratyush@kernel.org>, "aik@amd.com" <aik@amd.com>, 
	"jmattson@google.com" <jmattson@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "rientjes@google.com" <rientjes@google.com>, 
	"andrew.jones@linux.dev" <andrew.jones@linux.dev>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "chrisl@kernel.org" <chrisl@kernel.org>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "oupton@kernel.org" <oupton@kernel.org>, 
	"mhiramat@kernel.org" <mhiramat@kernel.org>, "baohua@kernel.org" <baohua@kernel.org>, 
	"tarunsahu@google.com" <tarunsahu@google.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jthoughton@google.com" <jthoughton@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "shivankg@amd.com" <shivankg@amd.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "youngjun.park@lge.com" <youngjun.park@lge.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "weixugc@google.com" <weixugc@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "qperret@google.com" <qperret@google.com>, 
	"brauner@kernel.org" <brauner@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "corbet@lwn.net" <corbet@lwn.net>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "liam@infradead.org" <liam@infradead.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "kas@kernel.org" <kas@kernel.org>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: juwpdx4ipx11ppahzmq4h45hmzsjfkix
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1EB2720003
X-HE-Tag: 1787041373-941147
X-HE-Meta: U2FsdGVkX1/xS1XpZ3yUY2Wt5RVpE/aVfy+5bCWWOaO1UZ7yak5jiLj8gWnxlzPCgQT0u8Gkkk5jbXv7L6xD4ghG/GOn+pQMU9ymQbq0R8Ngruu2xPSbaMjo3aBCN98N+abX2YqRpm9OmoNUXwWJz0L8Mxci28HgX1t1h0h+g2nQFSg5QRlb1mKS1ZoA84cwAZ3JAzPxPqBCHH3zpgCI71e6itJbQ9B9kz/QdQr2a1ULrwcIaLQdIY+14F3ASV180Lnd9XGInfMZfJ5HbxvXRjOHg8iZBy65yEWcdZQWd9ArSgRWPkpUfTK/SMza1yKyK4XC4RCQFwfl5yJRCU5PnJD8Ua2s0q8jgatJ+eoW0ZMeOU8A26nIloqqA3kbrOEhf55R4poIvXY7C9PL1xpKPXa9yt1wi07rU8hPVyBGakNMUPgx2LOh7oP/9is0gwH2ecmGNPt8NzGsHMPjD3j6U8OqrJFctOU0jAi7/OF1Q609MzE28g+4pO86scBWiqW7pJ9YyEWYA04jWee2s8izr4lcbtbu62grIRZzEoR3fJQAcIrk3UHWGp1/Tun1IAOTZObBh0BUooRhCTRZ+YSIie1Q2RUvARoQvJWSO9kid5WYkDjRkoxpa8gjKnOL0RvdHEVPDCv0AHcUGFXig8RNPepC7yy3COLUtKGd2/76ZRV2LG4QyTWMSECZbZg5vIdnvS3NNzWso1pgvTaoynQfXwFHosoAtuk3x39WLFVTCbIB/Y5gE0A+fPdjtv1YuhWpFWHmO44P9zlMWSvuCIrYq1rGmv6Zch00JLm/VgJCNCVJ0iMD2LHDlP7eWJCMAuJN/SSghe60kngmBcb2FUN6gCo2BZ1neLW2EVyprO8YuRSpGPm5IqdcvQ703ZNwnABSwKFrM+kou7+s23kC4usssTcXHaUX5zrxq53CP7LkzwX7uBPG/CN7kICiWs749QVgOk1+F/X8eyl8rZM9IBL
 d/hTwGBi
 tFgx9zWWDs6OUvwpmDoTAHh31fY3hK+lcAOwrstNxOoXj7aq1o0mBoP47SdCziFqrEi/mWVB31yFYO9wS1X6sWLiYdTep7kVC/GUvOGRXRHSELWoDlt1nIyAZ3QeJZZlmQuFQZMPa3ee0nGcIXGXowzjwk6as/oR/knUcpc5C196IOtC1FzI+BOnUoNzxkcwpm2rcKWwpnFAwm47XfEMI8MCjHCyn1YgTax6/XQh0w3jqun3taAja7xXHTUhTuqCwnru4uS7sbU1v6+0mUsPMm9nvaN3z5Zq15G26sfFrKDJJKP0ETaUtQwdr4KyG8D+a8ly4Xck2qJy0Pa2j6XgaD55XmWznrFVQVHBFwcvKmV2lN3sMd0LrEGiacmdbatRSqhbdsoS0E4RBxgcksZsQRguOn5LpS7WNPHrAG95SvvUK7WdNYLFtns17IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

>
> [...snip...]
>
>> > The only question is if we want to commit to
>> > guaranteeing that conversion will succeed in this scenario, or if we want to take
>> > the easy way out and formally document that conversion can fail with EAGAIN at any
>> > time, even if userspace has never mmap()'d the memory in question.
>>
>> I don't really think there's a need to commit to this, IIUC in principle,
>> ignoring that on many paths of those guest_memfd may be excluded, refcounts
>> can be taken even if there are no host userspace mappings. For one, memory
>> failure handling doesn't care if there are mappings, the refcount will be
>> taken for a short while and could cause this conversion failure.
>>
>> Here's the relevant part of the documentation added for conversions:
>>
>>   If this ioctl returns -EAGAIN, the offset of the page with unexpected
>>   refcounts will be returned in `error_offset`. This can occur if there
>>   are transient refcounts on the pages, taken by other parts of the
>>   kernel.
>>
>>   Userspace is expected to figure out how to remove all known refcounts
>>   on the shared pages, such as refcounts taken by get_user_pages(), and
>>   try the ioctl again. A possible source of these long term refcounts is
>>   if the guest_memfd memory was pinned in IOMMU page tables.
>>
>> > I'm leaning pretty strongly towards guaranteeing conversion will succeed.  We'll
>> > still need to document the EAGAIN behavior, but IMO there's a massive difference
>> > between conversion failing if there's a lingering reference acquired via a VMA,
>> > conversion failing because a vCPU page fault raced with conversion.  E.g. being
>> > able to assert success in a very curated test, as the stress test presumably does,
>> > would be extremely valuable for helping detect/prevent edge case bugs.
>> >
>> > The argument against guaranteeing success is that we might make our future lives
>> > harder, e.g. if it turns out there are legitimate, hard-to-solve edge cases.  But
>> > I'm ok with that risk, as it seems highly unlikely to be problematic in practice,
>> > and there is real benefit to guaranteeing success.
>> >
>>
>> Is there really a need to commit to anything? This is already documented
>> as "can fail", and it's orthogonal to whether the memory was mapped.
>
> Yes, but the above docs also say "it's userspace's problem".  Which I generally
> agree with, but that's not a very good story when it comes to KVM itself taking
> transient references, because then the answer becomes "Stop running all vCPUs",
> which I don't like.  E.g. in a very pathological scenario, it's theoretically
> possible that conversion may never succeed.  That's what gives me pause.
>
>> The transient nature of refcounts on pages in general makes it hard to
>> guarantee, and this stretches outside of KVM. I mean, anything could take a
>> refcount on a page in future and we can't be auditing the entire kernel for
>> no refcounts on guest_memfd pages ever.
>
> True, but at the same time, if there were never any VMAs then I would expect there
> to never be transient refcounts, modulo memory failure.  And it'd be easy enough
> to document the memory failure angle.
>

I think even modulo memory failure the contract in mm for pages is that
transient refcounts are allowed to be taken.

>> >> > As for in-place conversion, this is not a blocker.
>> >> Sorry. I didn't intend to block in-place conversion.
>> >
>> > LOL, what we intend and what happens aren't always the same. :-)
>>
>> I don't think we're ready to guarantee conversion success when guest_memfd
>> pages are not mapped to userspace
>
> Yeah, that was too strong of wording on my part.  The needle I was trying to
> thread was "conversion for this specific scenario, in a controlled environment,
> is guaranteed to succeed".
>

So I think we can only specifically fix this case Yan reported.

>> without dragging this out way further.
>>
>> I'm all for KVM not taking any references on guest_memfd, but I think
>> eliminating KVM itself as a source of transient refcounts can be a
>> series in itself.
>
> Yes, it would definitely be a separate mini-series.
>
>> KVM not taking any references on guest_memfd memory is definitely welcome,
>> it'll pave the way to using non-struct-page memory in guest_memfd.
>>
>> It'll come, can we not block on this please?
>
> FWIW, it doesn't have to block initial merge, just the final release.  E.g. even
> if we decide that this is a blocking issue, we can still land the in-place
> conversion series, so long as it's not exposed to userspace in the final release
> of 7.4 (or whatever kernel) without fixing the transient refcount issue.
>
>> If we find a way to strengthen the guarantee, wouldn't that be an iterative
>> improvement?
>
> Yes, but we do need to draw a line in the sand.  E.g. if conversion failed 99%
> of the time because KVM was taking spurious references, I think we'd all agree
> that needs to be fixed before the code is released.
>
> I'm still leaning towards saying this one has to be fixed, because it would give
> us a solid baseline from which to start, and a way to enforce it going forward
> (Yan's stress test).  I could certinaly be convinced otherwise, though dropping
> the transiest reference seems straightforward enough that hopefully it's a moot
> point, i.e. we land both in 7.4 and don't actually have to make a decision.

Sean seems confident enough that it's a small change to drop the
transient reference so I went ahead to put together the series [1] so we
can kick off the reviews.

I'll follow up soon with some testing and report on the other series
[1]. Yan, if you could provide a Tested-by on either series it'd be
great :)

Please send your reviews on [1] so we can make it for 7.4! ~7 weeks to
the soft-close of 7.3-rc5!

[1] https://lore.kernel.org/all/20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com/

