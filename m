Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 748E4D46624
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85B56B00E1; Thu, 15 Jan 2026 16:07:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33AF6B00E2; Thu, 15 Jan 2026 16:07:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB876B00E3; Thu, 15 Jan 2026 16:07:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A72936B00E1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:07:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40C611A049D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:07:10 +0000 (UTC)
X-FDA: 84335433420.15.6733084
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36BCA120009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:07:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TD1alt8j;
	spf=pass (imf29.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768511228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4BwArZ5FLhyM5BEN34gjuDvwbvdpN2Nxoskvco/5nM=;
	b=IqS0uS2dRhem09MsoiIyAMjMz1PMG5zubaVVFnItzXJG2j4K2/udcDIRG4P7zQx2NBFXLN
	ddITWoOybzJkfSgGoR7muiznMqD12GN98AvCNUEdTAGsXZ4+xM66FcfHoCSN56N4M+AmN3
	3iCEKImhWkW/cMIHpUtdfS+yS0mCrrE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TD1alt8j;
	spf=pass (imf29.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.43 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768511228; a=rsa-sha256;
	cv=pass;
	b=hUWBUBalVXvF74MZ5zESKCUKzZoJD2p4YxpwBl5i2lrMid/frFjaLE0mgx4efU7cadXGt+
	FyRZ2DN4UCqKTLZatFHCQMtYrRdvaVCt3Ug5+zz/v5Qu+FAWJD0HsmWqJOsvnAYpFdIr/C
	zRLqylp3jY6lqePvjKHSedbJPZrl6Ds=
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-5ebb6392f58so456503137.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:07:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768511227; cv=none;
        d=google.com; s=arc-20240605;
        b=AFQuZoqxuRQlcFZw2j2VFY05bEktUZzUIz6LxuEJVuf+Off9ngxhDp+hLwWQwRRe8r
         ruxprrNYqbiO2xi8gv2lRvam7qmZmpv5fEpyqQTaCZjFk1JB0Pug+CHns1Y6SDArsbTv
         0EbOW+xQXcYWEpM+aAkT+PQTQIhUKRVAZhlaOxRmeU50vfXS9uKPKi6khvd0ASTwiQLI
         1u5yUrorZfitgTDqxDNHq8Ktoy0W4yK6KVb2IvSMRIkYWuwDMCa9XXTSpHA6pVGmUkNM
         gdBSAixttxqX9mtF9t/YwvDqeGZ+y/gsiavlc4Q0D95EYlQMlihRULIuLIpob5RD7dLy
         x1Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=y4BwArZ5FLhyM5BEN34gjuDvwbvdpN2Nxoskvco/5nM=;
        fh=DEfbvdOv5qu8pyPqyjaFKQhYL/3XMrVUcVecEY849No=;
        b=hPCJFrcgL7rjUUg7jo+yUf8yut7kWEccKi/CkHwNFneUUM2RoEZ0nz57SzuM58BofH
         xLO7JI9Mxqwpf6nJ1ufsAa3ty7ERlfgrHUHvP2HvsvtKRD5+WTE6Dm8FQXNKN0yDrzK+
         QCfyYNz/nXF25rohiHurYiZTPJFo10Jnw/7oe98iC879GI6gCVIZ2uU3f1vkqlaC91bz
         J4u2sPJy5QW7PnE9/McsQBO7OacA7HCzBIBxvebOLJGBJCVVJyZzQ/Pn3miW5NOXyoPA
         sJV3/jIfHEzA3OCAcPg2YB56T0iAcX69D7EYFeu3amIArIVHiujebw211tTT15x2i/SH
         VfPw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768511227; x=1769116027; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=y4BwArZ5FLhyM5BEN34gjuDvwbvdpN2Nxoskvco/5nM=;
        b=TD1alt8j2wxyU50GXdzJb7UwUQOt1fma39JtCP1Q5MjWLSzau4wdzivQb9A2AhVijx
         4JqTd2t/uT6FCHd3Kca8gYqo2pGkh629wd8frk7M5GY9HN9TxcxTd+4cWCfVkZCkAS0k
         c2pRo8EY6FPSMDiszn+1P1tvj9iI5DtA5ZIw/5oV5HKelg6TPnGnwShw5Of3IB9NstZu
         QaM2EWgVLI/Gnr6chXh1mSkXpy9CJqpIFTqO+ySrAxgtOvdcgUJr4IQIHYqB9pP5xlf6
         KDJN0Yp1MTjUqdYgJftPBlViO2TCFBQ0yrfRhVHv3CVXvDjpSqcCi9zdshh1WLqXeYeE
         m3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768511227; x=1769116027;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y4BwArZ5FLhyM5BEN34gjuDvwbvdpN2Nxoskvco/5nM=;
        b=bH0yg0VCNmIodKGgcjYRU5aeIkADuHe6W3sOO/4PiL1AsJQzHCxIwIIbnepU/TGeKB
         g8xmhoH9fycqdBqJLCqhHEWW6xR0l0CHsaAIvmZVdHQBHPXA/kH5r2cpj747t3cCeXw+
         3U+3xiKfbT87JncSB2iaA+B3tGnP6N8HHPfNYpK+xEIn4rGCHjlOYDaKWpJyUj6OMVi2
         b14Eoz7Nebo8p2IVwzqVy3soWjIO0tKSOwmXo4ujsfNzvPkXj0LUnTPC7un4D3I98wT0
         FRph2MxFev9yIiSgkvP2ltiPRyONvnemAyqpYywTcY9C18qiyyIEwfxQ7hjThdmnfDp3
         97qA==
X-Forwarded-Encrypted: i=1; AJvYcCX7naeQQke65/KwLWBag/f8Tspnj8s78iQkodFKEADCywNHlEng+eHXfQbHAeBWzyKKBO8ox00fiQ==@kvack.org
X-Gm-Message-State: AOJu0YxjdNfqBYAVVaLBf0LI0ncVcUQ+n9IqyHSZZJO6MS8fUB91dJm6
	TJUgQZ6Kx/VqP/w1QqEfLnsD4N/4jGqoy9afmI7ECLVsmj+IZoBM+hbuPHyWKPSBzx1zRVQ+Our
	xX1f7hmvphSXAo4/OZL7zYlZVSGgcPJPD7Y6/A3Zk
X-Gm-Gg: AY/fxX6rR+nkxRQsyyebKPQmCvUzmUQBYrLvBo77FtCcG9Tgx55VPBVH18FPBSagMwu
	ZG5LOJocXCxwSM/N6+gRgnhjfReGFEwTYNXv4ZunrFPY77xnYewvOP51Ih355GiPPs9Ei5AMjdc
	CmF9C7Y25Vx/gNi+XzosmHT1vNz4D11rD6jrWSHZslGYdVizWFl0JS2yRA4iSUm08j7rrePbcD0
	ddabFlCTOltBAwrV2SOj1GKKdkN/1XHzkCE4ET16wOzMPydxSVozv9jioDyTr6Hs2tPR2tK3VvY
	yh0wcrHInGxKV3GJBnJSvE3yUw==
X-Received: by 2002:a05:6102:945:b0:5df:aff3:c41c with SMTP id
 ada2fe7eead31-5f1a719e362mr155618137.30.1768511226367; Thu, 15 Jan 2026
 13:07:06 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 13:07:05 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 13:07:05 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260114134510.1835-2-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-2-kalyazin@amazon.com>
MIME-Version: 1.0
Date: Thu, 15 Jan 2026 13:07:05 -0800
X-Gm-Features: AZwV_QitN6L4bb0XJb_ZZH7nFdRT7CH1pyddv4cbgutSArI7UeCs00Q7KzDEw7c
Message-ID: <CAEvNRgGXeow48BUJYyuAOUp8qK97v1LdF4KdTB=Nbk7pTs9tfw@mail.gmail.com>
Subject: Re: [PATCH v9 01/13] set_memory: add folio_{zap,restore}_direct_map helpers
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pjewyozb3pkwmfemj8dpiyd956j9jj4d
X-Rspamd-Queue-Id: 36BCA120009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768511228-977787
X-HE-Meta: U2FsdGVkX1/w4JQ1EzYb++FxViX+dGpSTxBNKsH5AWYF3pvf7KgLl3dexkzjkrZQlrtdhtFeuvb6Q2s8B5OHgjC3EcAJIeHDo4WSe4er5RdVlVDc8TM92tG3F18piwnYpv1twlBs0rohZ7u/hyVAXeGtpbDlnexkiseBlojL8hi8ElCQtxxecCGixcRegRT1DRGC9Zd6Sy7Ci70s48ilmHteeYfdPDrsCFR4DzCx8n+QKKSKHnim2JX1pXdA++6gJ9ikuwtmUyTd5cGU2XiW1C/OxP9xuorHiZ5AdhWoAlZAsq128PUTBoQFFjtSL4G00dh5xxZY+NCjQaCDZcXaEK+vnm4Gg9m2cy/uonVgn6dwrpcQF31+aehcKtlFEPKYMCupWRVhvleAy64s6e5zqxZo5bhqFBS+7J2WaGwAWYqw7JSvAp8rqLcbEqZg7xRwRQDvYnbxC3dqVvyvm6zxM+5/S1nWpf2Yh1CMoLV+3ZIN1cSwxoJe6YxJ0Gw8zSzIyLqZ300DE24BL1XP37BvWLi7JWFGvJBsQQjBGuY5T21PUTqSysuT+TGEo7cmc4cgAzSS3HwwY3+VzKkyk463fJow7xYRa/ViGlW1hIn2NUkNAF1H3YL48MC9OSe6XGMsokGh6UrWL1qLcr4Al0sYXp+zqHN5J63DmSnQ8P4UZMzbRPWn3xA5K/CQL9sQE09RjW7xD5yiuxuUSJEcorpSDuOEKS2kOsqROe2AXIobShlKvt5HYxxXWvtDqs40kK/fPCWm16YK8CqcbA91/xYRuGMX63Ago9HWawB6mwnYGE6PIQGU3azbjWHFmWx3x+TUDMARkkqJ67rQAdJEdEBfS7xUyeQGb4T4vtGKZAz9wPeaPulPtLsdPUUR7FqyR9EgVEGqGrSFaazSsHmfKKcpjtKqdeO8A2fXM0oeiyWiLHiNQWGyMbR8iz18CFKSjusZZeXWELge3j8k1GnP2Zf
 eHJfYbzg
 exvLFPC96a3DJvydgVzhr32EirrpYwFgcFCiKSczB5E1kz0hC2ra4K/PBEvWNcLcbPmEhJNG8SFtvcnPCqrSB3edHHxReVNNl8blvK7jbNoQVaGHIt6VT3BcgOwuTqG/MR4qGF5W0rJ+esZPriaEMq5A7lKaXMyYscnGUbxjKUu22NAKVWCE54BfNU4/2tpcy61AxMc7Rb/BixNPlEP+5Fs/SxbCYQz/zDMhw8vzPr3Q57oeceaCAPemP4QdOqKlt+p1u9j2JFYKcY15XO7MqDoRPY3+YfB0eaDtFCPB/0e4LSWMW2eZaj5z605tdAri2wFCUxfHjucCizin9okVbNAN7yi+f61DYDsd9oNKI7MYjClfy8sbhIdvzEpcx9akKpGIRvFf7V0Hn7hyDjFsYNzWLRGPIcSpoIG6KEoPwL8dCfxkxXRnRDPn50ltJZ5EPqF4y6maiUISCF4QMuQtqgqDRhrHHHkQB2cribS1vU6pFKv7wJP9ol3ZF+lzRMYz32YqEGPSCv0rhJRCQJNLWikv7a+Mq3xDSIOIqo5JKv5RCWqQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

> From: Nikita Kalyazin <kalyazin@amazon.com>
>
> These allow guest_memfd to remove its memory from the direct map.
> Only implement them for architectures that have direct map.
> In folio_zap_direct_map(), flush TLB on architectures where
> set_direct_map_valid_noflush() does not flush it internally.
>
> The new helpers need to be accessible to KVM on architectures that
> support guest_memfd (x86 and arm64).  Since arm64 does not support
> building KVM as a module, only export them on x86.
>
> Direct map removal gives guest_memfd the same protection that
> memfd_secret does, such as hardening against Spectre-like attacks
> through in-kernel gadgets.
>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  arch/arm64/include/asm/set_memory.h     |  2 ++
>  arch/arm64/mm/pageattr.c                | 12 ++++++++++++
>  arch/loongarch/include/asm/set_memory.h |  2 ++
>  arch/loongarch/mm/pageattr.c            | 16 ++++++++++++++++
>  arch/riscv/include/asm/set_memory.h     |  2 ++
>  arch/riscv/mm/pageattr.c                | 16 ++++++++++++++++
>  arch/s390/include/asm/set_memory.h      |  2 ++
>  arch/s390/mm/pageattr.c                 | 18 ++++++++++++++++++
>  arch/x86/include/asm/set_memory.h       |  2 ++
>  arch/x86/mm/pat/set_memory.c            | 20 ++++++++++++++++++++
>  include/linux/set_memory.h              | 10 ++++++++++
>  11 files changed, 102 insertions(+)
>
> diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
> index 90f61b17275e..d949f1deb701 100644
> --- a/arch/arm64/include/asm/set_memory.h
> +++ b/arch/arm64/include/asm/set_memory.h
> @@ -14,6 +14,8 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
>  int set_direct_map_invalid_noflush(struct page *page);
>  int set_direct_map_default_noflush(struct page *page);
>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
> +int folio_zap_direct_map(struct folio *folio);
> +int folio_restore_direct_map(struct folio *folio);
>  bool kernel_page_present(struct page *page);
>
>  int set_memory_encrypted(unsigned long addr, int numpages);
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index f0e784b963e6..a94eff324dda 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -357,6 +357,18 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>  	return set_memory_valid(addr, nr, valid);
>  }
>
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +	return set_direct_map_valid_noflush(folio_page(folio, 0),
> +					    folio_nr_pages(folio), false);
> +}
> +
> +int folio_restore_direct_map(struct folio *folio)
> +{
> +	return set_direct_map_valid_noflush(folio_page(folio, 0),
> +					    folio_nr_pages(folio), true);
> +}
> +

Was going to suggest a _noflush suffix to these functions, but saw
Aneesh's comment that these functions actually do flush_tlb_kernel [1]

[1] https://lore.kernel.org/all/yq5ajz07czvz.fsf@kernel.org/

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  /*
>   * This is - apart from the return value - doing the same
>
> [...snip...]
>

