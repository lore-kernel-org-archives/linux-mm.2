Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C075C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 06:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D9FD6B0088; Wed, 26 Aug 2026 02:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38A566B008A; Wed, 26 Aug 2026 02:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252C56B008C; Wed, 26 Aug 2026 02:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8E516B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:53:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 80D1F1A02A2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:53:48 +0000 (UTC)
X-FDA: 85142505336.21.FD3C7E2
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8814FA0005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:53:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tAhKVKdt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787727226;
	b=R2Z9YaSo/9r94XakVfLdsKtOxoLvgNpgBuEWON6g28MO+Dq7tnqRjKGfBUVPMTAApd0/tQ
	ZC12zBTDf7NfszKT/38odwGhhZL1jkVBUofaSLrZxtzwgEzXTfk/nVEqyxG5+pY8lZLMSN
	pL/hy+2cDWD6PSFmHKBzMx8yKgiLOIE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tAhKVKdt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787727226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gunoR0/5m2ShIW1cBAYYWni95R3wXjfnlI5bo7Tk+30=;
	b=iFBiceIdqerx0y8Nq24LMEkc+H/uv3FpemtezRV2p4R0T2xYDiMQSb7jMYl4NpPJOTS4tA
	p/gI0BEvZZbiEljZ9XCnqHyaN5Lltbr/7ITd0eNMr9O1ErAtmBfIv5V7NhrGyzouZZHH2n
	oZXKmm82iThbTNkMq3TkcieQT3i9WUQ=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-52b3934af3fso6987061cf.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 23:53:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787727226; cv=none;
        d=google.com; s=arc-20260327;
        b=EPIQp4msoYmHc9wNQvLjr0bqYOLsLvdcvD4u93rB7gQdzZr4/8ui4EGpxrPGRVswO1
         HqSMI7YVx732lyxIhVx/0SqtErdSad5FuRsWC4gLfRT5SrlcIxnJ7NgbjTsrlBeiA136
         bYXjh49sSwEpRJXQG/NvGPZ9EQ+w6WoJj9lY5VTECX0xgHLwgg5VBh+OJKjP7USg5UgS
         env7+ShbfKBN1Xr9zmzEatTCPoaT7SgAFSRnDHynXIFptU+Wsw8aTjH/PYlTAmvqnmnz
         ifbsEu84zvYMDioNb6mSSzm9HQP9/nXk6plR9d9JF2/IYmg3KDw3Gmxpc0TMeLZFzdVK
         GxPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=gunoR0/5m2ShIW1cBAYYWni95R3wXjfnlI5bo7Tk+30=;
        fh=RIp4yOD3iqqqoNQsCEv2nqxu5YxdoFRz/NirMbh8y0o=;
        b=VsMTtemYostZU0jbk3bhh37Bb6RMlBrJxaUFn5t9ZVkjpIRZA66Q4/vgr3RcNUcHWv
         KHkiCPWC44zf/kgO3SvM3tOJvNbbrWyIdJQbCgBoVmsVQdANRzW/5FrGafObwpQ+uvnb
         +DZMDZ8BnYre7CjbOJyHhGZOOGzyDZnklN1anb2gCXqxxI/v/BuEscV1YHJ0z3GtqDF2
         hfn+uJT2Vmy9/St+OZGS737fQk8qKt1DWKgKMueL4pqXfGNE+ssqR0MY/jFYRCMSHyjL
         Upz4exOr+yFQxsy6kjF/TYdpkqxDduw6Y/LkTN1Sv5e8WY5SVa84XC7/jpb8py0vPjOA
         Dctw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787727226; x=1788332026; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gunoR0/5m2ShIW1cBAYYWni95R3wXjfnlI5bo7Tk+30=;
        b=tAhKVKdtCJY04ODqvj9vEzv+6axJmV2XT9GhxnMSxFuLL3ZojHPetNNCXVe2K/m4+8
         WQy5fx4pWcQEUSj6wna8+xHoo84BwH1k94s5SSHHJPvVL1s6H2S5aIIAcgpJF8mMabgC
         2iYFyPPJoTsA4Jj4bOj4bt7VcD5K79Ymm4Bi3r4tYBj+epSqjkXi08vwA4zc/lXzr8sP
         Cb4ko54XHSnapk7jgftjiAUibbnSRHUyIiaKmJA41QDJeyDjIAawk6eGgdrPZc00h1g9
         z2fyZOrfXHb/mschvp//BdcsmtDl7p/eN1l+1V4ydFbYMTBcHOy/fKmcM1CO2kcsDxaT
         OlaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787727226; x=1788332026;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gunoR0/5m2ShIW1cBAYYWni95R3wXjfnlI5bo7Tk+30=;
        b=Ov23hiELEAmJ4bN96I/usW8F4Z6e4BlCwWIDmQt3ItixIVGJUvSW5aXKZc6R/S1rVC
         rX251PNbqNRfkY3WHcO8O6JGSWk/sehcPsiei5KGaM2kVIWAFGZg2MBwExbDo7VxnjDw
         Jgm912j+xTmQjoYOo4jCd/nKUWXU6DZjlAY1eoV8yiBFW7lWvX/6FZro5yyUYzU0veHP
         AjaFburEFigqSIp/WmbYsogKf1IEFHgmms0nu4ejQ/JtRQCTuqNlXGn23R4x+j67e3wR
         bSYQ+bcbvsoQbVOxVI+Mvl7tV4d2w9JpjvT0j+UD+iYy7pUeChuRfSMymctV/WLImTxo
         oAzA==
X-Forwarded-Encrypted: i=1; AHgh+RqNstH2c6kQwUa/zNrf9inIt/5Lygph+M+9qbL9vzAZI4ts/NlKlNzqaY2/X9We+PRQqZ+I1HoXuA==@kvack.org
X-Gm-Message-State: AFuF++nKaZ1X7/oFp6/YBCbu650GlIqjKWbEXbX+qYJXuUE+sLQ7nBLZ
	uf0CUgo4PPmLE9ytX68ZGMCSo9L239xt19wvJHEb+m2jJy44C+eCjH3YzwqOWfW40Vwr8/lQId5
	P9vzi6IPnaLIlxEzh1JvomJ3IunhXy7MlGsF9x5Tx
X-Gm-Gg: AR+sD13hi89FgM8R8eqKY//QXIOyNY/VdNs89Fe62vthh2ulqS6PwJl4VK+uDeC9egV
	zSlrJf5a1Xj4XQOyb23PKLJJfgzkGdEVIhttv2U8J8A6u8CyUeKWv68UFdOADi0it9qYfQM9l+L
	h+iK9bkBSzQDNnbjkupnGCzWkmN/nY3TwsDDWhe9xRTRoJrMr7t3ehREU/f/JiNQGnSSeAXFvs8
	kc+/cz05fAWGWcbr2BG7nCfHan4vY2sOQ7CUpMNVMOZXtJdSFkTXTB7s+qYJ+LpPd4CNIN5N/Wf
	BSuSRkNjjnrSnwBlSeRLP7Y2yyvQTht+pV8DIcckku9uMxxSFVY6DSHPvYR0YeGpGqv+3rknAXY
	/dkp68zldfMgZR2zI9G/U7YsKN8On6Q==
X-Received: by 2002:a05:622a:1b86:b0:51c:fc4:a144 with SMTP id
 d75a77b69052e-52e4228ddf0mr40451941cf.4.1787727224807; Tue, 25 Aug 2026
 23:53:44 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 25 Aug 2026 23:53:43 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 25 Aug 2026 23:53:43 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <ao4Gmn5tSZMhl_nX@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
 <a410cca6-0776-44af-8353-9b7375e2fd4e@intel.com> <CAEvNRgGvxMus6pp=xuDYOumH3Ge4oi0=YKjTaFykFHwXuzRDwg@mail.gmail.com>
 <54d1bd0e-c27a-4033-ab97-02cd9579a620@intel.com> <CAEvNRgFhjbgC9Ng1qviPx4oE=qihUwiBcsYOgJG3yOU-nLG1hQ@mail.gmail.com>
 <ao4Gmn5tSZMhl_nX@google.com>
MIME-Version: 1.0
Date: Tue, 25 Aug 2026 23:53:43 -0700
X-Gm-Features: AcwNN1W7XYwPjQi0IwDu9VBVz85rJlKXjtpX9LauU0RxJJUn8oPq1JlhbiQWidY
Message-ID: <CAEvNRgEHZZLXyhQ5HiHcTbCk65Y2Lb-fYu0fZ+LRMm1_eWgeSg@mail.gmail.com>
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: oy5wcgyncnw15aff8jnshzonk561r4st
X-Rspamd-Queue-Id: 8814FA0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1787727226-822222
X-HE-Meta: U2FsdGVkX1/u+io5tKle3EDlPN3rJY3oL0rNU2FtzDsgiSBTIduSX3gEJbClUUQ7kmgPZwK1MIUKlTc/6FWhlG92e/R/4WpbGpcDGaVnqgnpDZ0+0W6r9h6acMm0TIZrEWB9HbYW1diI9whOv5OsoeiLCzILdZu6MHl80z+rvLL3THAsM15kmhVbldkRgvYD7IH5kPx0q+ID/1Hss+DnhyDoNYsFZAPHRbN8+80JUetC7JFv+ke50pEaG0kBukys0jCH4oNR52xA9Xs1njozkrP93LwnWg8Q2Ifto8+bLN8fWjf4fTecI1GQhEDtvXEdKxrFGzBEwdgFaobjFJMG6V6sHErTa8R4OhEFFrqpjgFmVdukolH3oFoGnjzZFydmjrFYUHBVZYoecPhj4/we8b2bZhXh+d1Eo+udB7XNVuNdnTnHFj8HNN0w4HNq+yrRQnUK8vGy/bxeLB6EcRt/DAeWwJLixdLhXBken7A0tpsd4iZmqtG5Y35B/L+6NFvP69TJwnzIBw4vJ+V2qPsmLcbvFb4pyV/+YGOS1L0hlcmPLf1b7sRVAQsuo07Z4Ij58PCqVu8vUGGK1n/3omouwv1lCPEqs01CXnH8D1EA1fZncp1AMTmlXPIFQ3Njku3hPnbhsGqgs7O+k/t3BdEuGyIxwsuztIybwbAPvTDsynV2St6Twur8LOaGa7zwqOzJSUEjUYTTHw2fwCslrN2UG6jjwtT015JjFejgE2ZfJBGslt6DBv3omF8tsuA7MgEU5m6vSvfZDRo0uTqEUZb1PeDaYmK4t9LS2c9sxlnxCXqGvD8NPQ1PqQrXiYtU56XSE3b9xRySqUvZQ7rXn94tcr/Vm3mh2Uc/7hLdolJL25Z9/ljTXau8MgokxGQ69M3MtazwxnSseiHdM54i6t/bnMFuVq001pxeLki72GYDzTb4K09hC0hZTthglWqpHrXf/PeZdG1AkbS4R+GYmSM
 NWdW5XsY
 OFxjlFP3tMbCoGbjJUaTpPc0QPC7KNTmKqpTcYefDYUTN9nbvjkk9wqNtUx8Z0y9JTlhSdIv1IhoqvjDgSWAUcpZnRgxN0ODM3uSLq1vnfEPyPGjjPdYnV9mBC8of+GQ46g//+IcG65K74La+USRlaWcclVCWGh0lfHRP0g+VeQWh4azwfG6wjxACPjw08G584tsxCYAVfvGu/mFRtdSvGJwStU56CgyWvU9yaNQGzLlKsmkh63rGn/mDpjWpjgyFrk1FRoVwXqaEfRmm99S0jh/11qIxF9IGxsBtU8+jlI8NNIvOT2tOts5AVrYteVPjDuPg/u9gIIzZuKN83v/UeYobixCL/Rhk1Jx7rDnwweVcyScwC9TbpKAnKA==
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
>> >
>> > I'm looking at the doc of KVM_SET_USER_MEMORY_REGION2, which reads
>> >
>> > # When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
>> > # userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
>> > # state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
>> > # is '0' for all gfns.  Userspace can control whether memory is shared/private by
>> > # toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as needed.
>>
>> I'm not sure how this snippet from the documentation connects with what
>> you'd like changed.
>
> It's flat out wrong once in-place conversion lands, because it assumes PRIVATE
> is tracked per-VM.  Something like this?
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 4eb7e75a7473..c9769e5e7329 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6383,9 +6383,12 @@ on-demand.
>
>  When mapping a gfn into the guest, KVM selects shared vs. private, i.e consumes
>  userspace_addr vs. guest_memfd, based on the gfn's KVM_MEMORY_ATTRIBUTE_PRIVATE
> -state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
> -is '0' for all gfns.  Userspace can control whether memory is shared/private by
> +state.  If in-place conversion is disabled, i.e. PRIVATE is tracked per-VM,
> +then at VM creation time, all memory is shared, i.e. the PRIVATE attribute is
> +'0' for all gfns.  Userspace can control whether memory is shared/private by
>  toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as needed.
> +If in-place conversion is enabled, then the starting PRIVATE vs. SHARED state
> +of a gfn is determined by the relevant guest_memfd instance.
>
>  S390:
>  ^^^^^

Will apply this, thanks!

