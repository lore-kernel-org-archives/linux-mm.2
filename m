Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06459C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 18:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 862786B008A; Mon, 28 Jul 2025 14:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83A136B008C; Mon, 28 Jul 2025 14:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74FA36B0092; Mon, 28 Jul 2025 14:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66A276B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:35:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 22ED61A0388
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:35:40 +0000 (UTC)
X-FDA: 83714526840.23.E04F3D2
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0E7A3A0011
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:35:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="FoIAvCk/";
	spf=pass (imf15.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753727738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78uPmEmg1jJUm+vcAxFvheQL2RNbyr9u5uHfG0T4KU0=;
	b=66DLf8cvusrdSaWysFGqyhL04DQSoGEDovic1wJ6alysAyyQZiyd383I0cho6ElsTrDd72
	FdvyBzeEcx+lX7ckzFR1RDOT3/gwON2ZE6ibn8G4JvYGRhrTV1V8sZApTRLAKVLKf5RMld
	kf/+OGLQCJ/q0OE9FA/arEImEyRwgvw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753727738; a=rsa-sha256;
	cv=none;
	b=H/wOueSbRU1lS/fre1EDtzDegLerhSQzmY+5ejnDMcAwgKXfaa2xLu8U5Ww09EfBhd0cLv
	kOriWfy3S9dfve/NySjaaLeN+DaD2yPLnEpQxXWUlIm3+syMjhwqQcBvTf4OOvpgE8f/Yl
	Mn/mAurKOPfFkXmLVS/K09zX1ewN19o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="FoIAvCk/";
	spf=pass (imf15.hostedemail.com: domain of asml.silence@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=asml.silence@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ae360b6249fso836667366b.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 11:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753727736; x=1754332536; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=78uPmEmg1jJUm+vcAxFvheQL2RNbyr9u5uHfG0T4KU0=;
        b=FoIAvCk/5CmGCkBSbqoCW1jfq8Kc+KgOTGAU+sAmzBEHZQ/kY5B+UiFWebv2Ao7cZU
         /1o+3JU8XIhEFwlnVua1sF12gftEhIZvLD/C50ORLasHSEBf1VNLaOqX4aYVk5Cn3Uxh
         rmDswXE/3/Vtb4VQdcxi8C/RqDfGLKpUxHlERq6oPHSzXhQttuQ5QaQs6wHVZAqq1U6c
         +Ia2pRbjdVu8vTNeS6gsQGgxraE0qL1dF1ozdCxljoohQTQPhC3nBn+PbcHx4y//Kvk/
         mGCOYaK9G9CzeUGA7d4mNBmQka4OX/pIQYgckkS3gwxf4zZjcM8W1bcIGLNBffkmr5VI
         BPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753727736; x=1754332536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=78uPmEmg1jJUm+vcAxFvheQL2RNbyr9u5uHfG0T4KU0=;
        b=W/7FrAQkTNewosJZAYQOKSvwPhN2fo6rbmiySoAs9z0pLVu/oWzcxtNV/6uj1TJ8N+
         JP52PHKEs2UWC3Aay+1KMAyliTBE5MIc5E77Dbc8i19tKABgfvCbwQZyoTcHnOd4PJ4L
         QqB5kSxhESOLN1rODuhUlfXDkh/ufSPx99LfIhpVMTQrKZOw4TbINsqWFECPxtoASrDQ
         fr+fFRG9wYb2P86OWK7D1tmbGfUFqyIKQMNasPRUo5gIeAtnESG5kukhSXEJ/kfK2bW2
         DTHBe4rURK1FukutI00R2oS9YS2jpPAipjofXM6J038FFntjrvo49gQ3nLCcOTX8d4+B
         THEA==
X-Forwarded-Encrypted: i=1; AJvYcCXnWpo4RlBUQIKCkXNG1AxULbvArJl7jqnJm3mUsX0HIpyqMzAWCSyz8kXKJXEGLuTMJFFRVu/8dg==@kvack.org
X-Gm-Message-State: AOJu0Yy56KJKDy4t+F0XM7sYYdnDMy172QmSeHGUZSvqHIKmYb+omaZJ
	E2Qb7zmXDMB9tfKH/A8E3D9cZ3oCeCPegj6PC3CtR9L3Ng7UqFFAQyTU
X-Gm-Gg: ASbGncucYrsV4FxNwZY6j1I0/m7JswdEy+SdxA+wu9TRsYiiPVnAPLt0fC3EBzeWlj5
	UvL4GGXXhQ/mVof4BICeh0sRFHQ/vX2FFZqueZjZGY34F5tJH/qGGBJaTqZEcthu3a4j6meRWSg
	o+ZleuGYgMnzC/xXq0BqtBiFyAnczXzViDz7Wez1CnFBW3K9pEup6ubUSK1ohO+BPXqkXGK4fTu
	fyYFbwzZYcVc+SCdVn0PnQkJ/XU+CXLewdJj0m8HRvKntjunLyN1YRZ3BwHmgccoo8dZnfgrpKa
	+oyfr8SXQzB8eVPfGPekl0G4bEEMwbGbeC9+JPWoit/fEvRxDwdaTPJLHCfhIpzdVHT14Duvzjf
	ljhKOwGx9KKn7lqU1Qzwp0itke3teWK0=
X-Google-Smtp-Source: AGHT+IFgxhpFnrUM7/Tj+j4V+oCATiKKeV1GCz2P0yLgvuPSqvqeNh/T3kaG38PILpE4Urdvmq1apg==
X-Received: by 2002:a17:906:4fd6:b0:ae0:d804:5bca with SMTP id a640c23a62f3a-af61ca9ed34mr1318179566b.17.1753727736013;
        Mon, 28 Jul 2025 11:35:36 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.164])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61500addc6asm3584548a12.53.2025.07.28.11.35.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 11:35:35 -0700 (PDT)
Message-ID: <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
Date: Mon, 28 Jul 2025 19:36:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm, page_pool: introduce a new page type for page pool
 in page type
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
 brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, toke@redhat.com, bpf@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20250728052742.81294-1-byungchul@sk.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250728052742.81294-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0E7A3A0011
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ecpcinbm8zk4yomfmnfob6woi3godawp
X-HE-Tag: 1753727737-318724
X-HE-Meta: U2FsdGVkX18vJejYp9hmH28t0v3JaALsYlPM8JpmVfFq3d0W+eee2rpic/pMxNMKgcwT5BhvDJS/aS2lUjPkYzOM1k2k8fc701e7HbUrbQ92skkZ6DvfA8a3PdklZUIBTZ/9PjbDa1wn6T5uKZMSkBJeEPls3OpfJ5+hBG4KngHccscLErW+IH5Z6hY7Ef60vuVndPmNaNvtRvdJPODDEOjFfauRj2yFkv1CghneoEp4WFvBcs+CakfvAmEXclo1gEfGT+GLrbZ8NNAJWt39jf5OLhXH48Ua+OdvUdmqR3pwU+SYlWC21yjKQjEiKAqcA3EukKNEUxQDgLcKDc0neQ8zT48kyTRoWE6b3l4c9FIelKtwybqCjAnkLze3TDrIv43YeXbRnuYAkHy+3w18kG1vAGnIaBRbGxXXEce+9uMc4LExVFsjCRV80h8Yp3v7UV6HnRfM0ekE/LStM6jNcBG5YWNX+lE/CV6oD4fVOTGI6+S11NjvSjuGBT+t8OVSKyRhvZSBLofxBrYMYuYminFU+ar4TDfKZ87bAej/UR3Vq3RuQ+phNRZqUBfrkOy2C+C6SN3EF6dZf1+6+jYBBL5oQZtzYfcK6sQJbZdGCH0Pkm071IZR4iVy3CBVlykDiOunvbfjqIj95n2LDHJk/4Mb2cNye2FAjqd6/NkpnOC013Ib+PMbSZkE2EMdnLCG40rTpobXRJUfxEJVAqqiuZVHX9SXl3w9D6h/icW/yuf/1i7xWUt9/u5vjNXbb/QtfXkcwU5/wHpJxsy6s/FLsph8FNLnB6q/kcyrMcCiTVcJoq6HU9BiJCF5OqWgamKPdZhhu8CqPCIHU8zpN7aVwMjq2LXBCE/XCvR1DEq3zAX7a0XVRIiRTGPfY42dwsYz3b2Xcp1b6am7VlflbSIje3sOBg4x6oOLfOYtYS7bp79XxY9Z+rk4HO+SjYLSxsLjWv6lhggqygbLQ9n4uMk
 yPpbli/4
 nQPJdXVKEo/9JM5Qyc/fBGwGn94RCoAznUQoaTWCT6VC0XU2yh18lzhCNp0axX080VoHvkRqhuNJmJHC6TYqfNNNX5EAbB1xUi7vdAkwmDC+gqJsrIlp8t+Z9/0jZbN5/3H3M57fPqU/Ut6oYsK7l42CQHxrY9ucAEjNL2JL3d91CRRQCYzy7MQO4MynKWzFkTKEiXeJ0YeQLrrLTX8fX/iT/p21rVaRc4dbIh4OjjLN8gSEeYatwL8JjS6jDf+8knw1z0CruVGrUpiEVQ0TlwM4+S3Sicf+szjjRulVWKAeg9K6ResUgZRuRld6gYeIU7uV4I4q504ZVJuFuE/MSJHrKqPNKWew6KlVl/e62jIYFKOm2IPjM0cqgorH22Ctt8RCo95LcwJsNr6ugaXq6sgbZ5q0gL+ajcZMyvfoviEMk5X8KcKjBGUxHtUCtiyTvWE8s/6QKi1LB5E42rwdmEcSEAx8543n7wnhKgJpy99EFAELu7ndH3sJpA0F9yuNcdtb895FI1L/q80s+Jr/ZOXjHhRF4fjcoPoBCDNf/cnc86uCh6ZkKBu0odzDfUtmrsHFk8CpAi67283njO1LytXgzkI1MlfLTVEX/IrxLwohAMNX0LPeX9f723p+1IYJdUNsKaDgOS2cjT2s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/25 06:27, Byungchul Park wrote:
> Changes from v1:
> 	1. Rebase on linux-next.

net-next is closed, looks like until August 11.

> 	2. Initialize net_iov->pp = NULL when allocating net_iov in
> 	   net_devmem_bind_dmabuf() and io_zcrx_create_area().
> 	3. Use ->pp for net_iov to identify if it's pp rather than
> 	   always consider net_iov as pp.
> 	4. Add Suggested-by: David Hildenbrand <david@redhat.com>.

Oops, looks you killed my suggested-by tag now. Since it's still
pretty much my diff spliced with David's suggestions, maybe
Co-developed-by sounds more appropriate. Even more so goes for
the second patch getting rid of __netmem_clear_lsb().

Looks fine, just one comment below.

...> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 100b75ab1e64..34634552cf74 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -444,6 +444,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
>   		area->freelist[i] = i;
>   		atomic_set(&area->user_refs[i], 0);
>   		niov->type = NET_IOV_IOURING;
> +		niov->pp = NULL;

It's zero initialised, you don't need it.

And a friendly reminder, please never send patches modifying a
subsystem without CC'ing it, especially kept in another tree.
Sure, you CC'ed me, but it's easy to lose.

-- 
Pavel Begunkov


