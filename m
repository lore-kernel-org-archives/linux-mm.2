Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E8E8C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43026B00F3; Mon, 29 Jun 2026 14:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A146B00F4; Mon, 29 Jun 2026 14:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A616B00F5; Mon, 29 Jun 2026 14:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6CA6B00F3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:12:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08F951C62BD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:12:46 +0000 (UTC)
X-FDA: 84933745932.12.658186B
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id C2508100006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:12:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=MXFaeSok;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782756764;
	b=OWxOkXZVV8xP6pGJezNhk+j8FmhdejgF+g+YtmHOyoOcgjpTPhlkSOQygx/E3z0eDy9WjF
	wX9ZGKMaxECFympUKvrp9txV2VKNakNy+hzWrc1K+hThS5xtXOnxjPdrVzOmWiHVYfSvT2
	CXKL9cAXL5WycZtR6/hhqLKBnmDVpwQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782756764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkgSZTX5dgpJDd1Pw+Y21Lq+ktYzI2xthklt27JpA2c=;
	b=CXJmsr2POucKhQMpW3R0u6Dd6n7pfa77gRx9GiYM1vMo+yitxFqDBDeW7r68VjC19ILlvm
	cdPDZbAysNMK8O5GZ4c4MAhsUKvVm3G4uL2EkNiQo8Dt4GHP49P41Ol1WgpsfcxNGuczzZ
	USJVRrtIlsrAaB6m0gu3aWGuMjxLmMI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=MXFaeSok;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8ee88fce572so20740906d6.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782756763; x=1783361563; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KkgSZTX5dgpJDd1Pw+Y21Lq+ktYzI2xthklt27JpA2c=;
        b=MXFaeSoktWMB5wVAduwg3EpGKqw4JAssmDbGT82DD1XBzsanLqJyunaUtL0/2kr6q5
         /eCas6ek5D83IG/XAb5NDy1ZRvoZgHGnAQogH9xw/L5hnSXitB3Tsb97PTAfY96pGUPx
         49qXIWfu6p2vT20jT05wd+jGnP1Thn2GXAiCDgao1NCSO4GWhO0rkykM8CuRjgdtZzoJ
         C+ZSHIfO5UfRyMVe5lPmBLC8V0ridoOIoEgR0HIngebjAnPKjvDkNXrLZeeShbLfbGa5
         +RbtAS8QJ7TWFC/KcZIZ/+I2YJOVv6z1LFuZ79wj9iVQuADn3TkbeLfznrkryNfBFxHD
         N31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782756763; x=1783361563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KkgSZTX5dgpJDd1Pw+Y21Lq+ktYzI2xthklt27JpA2c=;
        b=saYzCoKkyhhnDPmvTRZdSOQDprhbdcZAnh105vQkhWb61pClJX5A2Fdn+DeSxK5HCR
         giHuFlgmiByX7gNrwspmb1wBIGiefu+EDxUGAkSnewgiLWTZD/xic3JeYIxqw9xekYWM
         J6vLHU1KC8vqqlOEgKlhiBm5QVl57zK4rWQ29RswpidZGa1E6ByH7ig2VekjGxavpMpz
         foEx3iFdtxhb7mHazoHFrtiD1yKvNll0JjJ2zEeDbu6oDtAIKPIBzBnYJjFjw2RtrGYL
         Xh1x3tTU3YNtm5EGhlq4LjqmfGS20poLlmYLCZjfIgKGtIZnZ3gZF0apEL4KrLvO7xTv
         7wig==
X-Forwarded-Encrypted: i=1; AHgh+Rr+DKgE5V+zOExt71vWeDRr7cCj/75zDc5mbyHqGKCSjKqN+g6RTD1YUbKYhlWo7kJuiBOPKaqiaA==@kvack.org
X-Gm-Message-State: AOJu0YxMicgsYCkCLL1ZPiIw2Bxfk/dyzS6QttAs4nDyxBAymwXYhMCO
	U8Np5EhRJrrU9s1PKGE/vsXSNxohgpQ9fDoZ+l+fLvnR1+ct6LjDXiw1SrO2V+bouGc=
X-Gm-Gg: AfdE7cmFm3OEE4SvMQOVyiNOZaH0gUURoQ7LGQtcHHecBPqpAEGahQ3tfSicuiDCmKM
	nMIhjup8yB+kfZtXjaSZdQn4y/X4EzXsr1Ej+SkHvJNSn2AkvDk5CBACepP0ddkbSrBP/7syZB9
	AtR4UGU7KEd5c6ULWCfKVUg5ZGHe5wTejJSGpRKmHOHr51KknXI/bg4BvVIQlnaHHN1FRd1Ntxi
	fiqM00Ahm9mwlgyUx23Qg8ZFvAaCA/a1CKomt1PYtrf9yPW+KQke5g5woLf7f9GO0sSlEmjeN6L
	kYYlAuZonbIqAN6eS9BIGy/v4NHfJWfecUCnnOUewEe7fEwkN4oJsLnndre/l3FqW+EWLbVWT0+
	lBG0CGzBJzGubHC8c4mIlT2ALYVRiBzmTlk9gnob3p7PQrdNw1LZlIsOYUDD7gHn9ggh63cA9ET
	9Bg7O8BeykhUw=
X-Received: by 2002:a0c:f004:0:b0:8ef:1103:7f3 with SMTP id 6a1803df08f44-8f1bb8f4be6mr5715736d6.37.1782756762664;
        Mon, 29 Jun 2026 11:12:42 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a69c2dfbsm3847966d6.30.2026.06.29.11.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:12:42 -0700 (PDT)
Date: Mon, 29 Jun 2026 14:12:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com,
	shakeel.butt@linux.dev, roman.gushchin@linux.dev,
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
	mhocko@suse.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
Message-ID: <akK1lm7mVUXEmIZm@cmpxchg.org>
References: <20260629130042.2649505-1-usama.arif@linux.dev>
 <20260629130042.2649505-3-usama.arif@linux.dev>
 <akKhzR8uHh-wzrx2@cmpxchg.org>
 <b84a497d-9159-4967-b355-44913a3865cf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b84a497d-9159-4967-b355-44913a3865cf@linux.dev>
X-Stat-Signature: fxph4w394oid9ppk88ptdy49bu5gr591
X-Rspamd-Queue-Id: C2508100006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782756763-310805
X-HE-Meta: U2FsdGVkX196YzGodLPRo2ba4KNKo7MhcZlAydyZ1UAs3dk9lWsitqlXAflcrSr4bUcTTt/Nc3TxBK0Ikwfs7LhTopgQ7KD+UkpAUPpa3jmUs9UUcJvKH0lGTC4Qnx4qiCgXw7B9RXcClp6RbmlpTSR/5eJlF6uwVSpvfpR2YTQNDy5Q7QuthkplGQhzY0WdzQLyPQrQ7B17n4jrj+OsYv+9gZB0aMpU6RRBdaTUFu3oIHynK4q6mRdpAiTqf/4sCu/AafGshRaCu0EQkHndvClX31GMlEjN66Sgq3jVTMAeK6Kh2wApdacWShRN2EU/w1ul49V57iTpTxZXtef+fy9kX2PC8d1BM6BOq6vQlLcFgMlj3BdmjqOgYR0hDki47pegR1T5iWD5FQhpYb0VyeBsWn64rj2aN1z9LfCjXJQuqfeFlxMSpA+5kz1/vTMfsvtpsyXagGE3iIDUJcl4CcX2QKqPBUGCITnevv+fc2Z0gV4hNxLjv7IwHmAU6Xwl+Btdtn8/ReW3GmKyXdFwVsbfzpUGnTlTOsXkNmY69ry00TYk8iQlNxYda6FecRT7U7vlGnm7gmmhd+wHSz0hZ9ImyBoxQdmQUyyxVuRDUygVCwp8DUNI/qxXLdANbjTU62cyGkxfloRRdsu3Shbbsiuj16JRMY1npQ3u4d9oNCyLVq20VaoeY2VOGgFwPu8i6kGg6w3u2oBbAyztTnaNtPnjG4o2TvhArqPHB7n6aLKthabLv+617ksl8s0xje2pSXbuWjdfUTdQrCC1Z6xE4UX9iBk86Bljh4PKHeWeoyjUziy0FljDLGk/+AT6WvY7ICnSTaLRaNlEOEnCa5q6RE03muU7W6YWHnlFWn/yr8w2RBnHsLq55++HvM8+tgFC91Om3hrWN++4/lMOxdXAMXtw18a9kjJcEgJ7c4Du7/3wPickdq0BhnJgp9S8y49Dwr0EfyqH1a8H4U//rtB
 3v9cMqV8
 EmB9ZP5Z9hL4CnlMoeiLfVBLgRb6iOehnxaOgL2cE8weQKfrzrRSeKkHzgKlIGZYfLQF66Af4Gu9xUaoFXdgYd4XYdsm5x3cVv02F0a/oA7d2u93LWhuLqTpjJAfrf/OdXOz8L5SDiHGv+LYbUWK31zkmXvHdFOBuM+TVwNYnj8nX+VYw0hMkTa6ExVnjs4ZgtMx4TG+TFx43ToFMKE5627xxHFNcRWb20MRaG0qbcZGLqIN2cbLctCVitLDCB4OJs/txOAYq1YVuwOgA01/VF7eHisjeW+NxkDLtH9E9M9bJz4G3srQZqUhsjUbh83ypG4/AEtVd0jNzeiqvo1rrvAWxbAfgGuPfn2RUgVJWjj1l+K3P4D+HRXBd7ES5N/Jhh8/JPfMhL2QxhjkFf+rYqD0f9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 06:23:58PM +0100, Usama Arif wrote:
> 
> 
> On 29/06/2026 17:48, Johannes Weiner wrote:
> > On Mon, Jun 29, 2026 at 05:59:37AM -0700, Usama Arif wrote:
> >> @@ -101,7 +101,7 @@ obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
> >>  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
> >>  obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
> >>  obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
> >> -obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
> >> +obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o vmpressure-v1.o
> > 
> > Might as well move the interface part to memcontrol-v1.c instead of
> > creating a new file.
> > 
> 
> I think it would make it easier once we move cgroup v2 off of
> vmpressure. Then we can rename vmpressure-v1.c to just vmpressure.c
> and gate it to CONFIG_MEMCG_V1. The other option would be everything
> living in memcontrol-v1.c?

Hm? I just mean move whatever you move into that new vmpressure-v1.c
into memcontrol-v1.c instead.

> I think its nice to keep it separate as
> memcontrol-v1.c is already 2K+ lines and this is standalone feature
> that can sit in a separate file.

It's all deprecated code with no active development. Containing it and
making it easy to see the footprint of the cgroup1 option is the
higher priority, more than maintaining neat component separation.

No need to work it naturally into the file either - decls/variables up
top, functions somewhere further down etc. Just paste it into one
contiguous vmpressure block under memcg1_oom_finish(). That's how that
file is already structured with the other components in there.

