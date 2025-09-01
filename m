Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BD14CA1009
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7CC78E0010; Mon,  1 Sep 2025 11:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D518E0003; Mon,  1 Sep 2025 11:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4B18E0010; Mon,  1 Sep 2025 11:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3748E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:25:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3128A1DEC28
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:25:30 +0000 (UTC)
X-FDA: 83841055620.11.3734AF9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id B95A9100017
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:25:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JajueSMK;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756740327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7wTvc9eUbw7jtHlrnxQy+rN4qRUOO7ojXz7+PUk6M8=;
	b=T3JBHm3cj/wOJsGj59or5F4IeuNHba1eeayj8Tm4irikplBhfG01OwWeLLcwOCTVk+5XE2
	5gPx54TcGPVZwBeRGCDqHj0vtPi13pMqmFac8eBzx7djNW833oWIovVuJb/RU+MMITjGE3
	LaS5rwZ+5ETiXTYve82Pm80I/g2n4Oo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756740327; a=rsa-sha256;
	cv=none;
	b=A1+s/ndiCGwLkDkawDpFj60Ev2z+PLQcVYV4r9GXW/TccSMnlGLjw2nHbItpAmCmfmoY+B
	SDzR/dhCpDfOyEk8DrYtqRgCj/dENrB1yYnecehhUvY2uZI0as/YQb/Swrku6uXeCXhR87
	ewmyb8hGy2SmNuHdkT66Cu527ToKltg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JajueSMK;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756740327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=t7wTvc9eUbw7jtHlrnxQy+rN4qRUOO7ojXz7+PUk6M8=;
	b=JajueSMKM0IjV39DBZ6nXqgNqJmzASMyInByClVwCfutfAFEEr0Kl5ZWFHBJ3mCOLJmKWv
	iPYBCXfVcizcWGyeTIWqoBgm5gC/hyA59PIWTOOQM3SBS8/9FPtjk6+obGoNdPT6dYlOPX
	K65Jz9MGigTWU44Xe8gSUvqZau9e9WY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-yxRJRaQWP7aITK56SdK9Sw-1; Mon, 01 Sep 2025 11:25:26 -0400
X-MC-Unique: yxRJRaQWP7aITK56SdK9Sw-1
X-Mimecast-MFC-AGG-ID: yxRJRaQWP7aITK56SdK9Sw_1756740325
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3d3d2472b92so1008458f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:25:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756740325; x=1757345125;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t7wTvc9eUbw7jtHlrnxQy+rN4qRUOO7ojXz7+PUk6M8=;
        b=TN40ivPS34wZ9ZEB/WQWFpkRm7iy03xlWjQezg2PYEZgzEiCPf5WhOujY+nNWqbbpX
         mK5VPP+flq+5whCd3iBN+AGOuBviNDrERaIK4ZEV+NNY9JewFYk5TYX7An5ybp1cbVNN
         3lm78uG5K+QDZr6uP9ixI7koqwWbENfbOTqU3jIF4WOGmeV3E4F9XTQrzM9FkbMg/0sj
         /t/eo/U5m8nOWpPZnmt6+l3XuhAeV85RxPn4cPcvlTLQYjGU1Juv/toz8/XMZSl7jn6b
         RBUri/tRfRps4h62B6txcybHfpNsn/RIGKOCmdgn1sIRYYiFBsZK1hqIh/ng7djdw8kq
         cHOw==
X-Forwarded-Encrypted: i=1; AJvYcCU0+IgUg1SVl/EpgXjEPnmlEwPHjCq4EW2thBWTpYYT2MiQYKhqtH7BNoG4CCk6z0V4xnyBIrtxjQ==@kvack.org
X-Gm-Message-State: AOJu0YygRmDX2z/brX/1qLKJ04NptiTqbuGlhtDB6iQOlaQsf+SZuo9l
	rkiwWZeWQ7Sx5IOf+SMAaK50F35CjD+LWH0NmMSDYiFH3vvg6M3Lc2VJAhmDhjeutu34ZV/9qSA
	Y6jJhnQnvBZjQ3DBb+7aj9Va0VkM5sOzRI8/V+jOcz1aqD96Y2D0b
X-Gm-Gg: ASbGncuQHi8a4mH3vj1nFLGESqdLo+VcElWFeSj4Y2ejKUEyFhQRfKPvaC6v3t4bD0O
	iEkCa5vIurYAwh07uZ5GfYHb8Pv1lyTCC2mYL4hOT51SXu+CLny385Ffhm43XgWZRKjU7UNLtMo
	eZHwwCBR6SrTDe/CAjH9Fhnfc0K+Jrj/TZMVkzrE1wRX9tYjCggnFmXsVS4uusW3OtzYI8lcNTQ
	Mcshz+dcb1BZtRxgChCMex1dyQYkibm2fd2ZPnmZcJuu2i90kisdLy0GSMvongibM42d+wJ0ZBL
	yBLhSOBtp8b+3ooFZ+QPeMrbbeqDv6AJPNBAh/bO8EXHGrTuoJfOYA5AfYBiUW+hku3FBLM9c4H
	5Rzf6IhvEaG1U0RnVt74YehxIQkKAa4TfcQQjHC32JJmFq9+Hrkk8koC6b/ilfeq1x2w=
X-Received: by 2002:a5d:5d09:0:b0:3b8:893f:a185 with SMTP id ffacd0b85a97d-3d1df34f216mr7377130f8f.53.1756740324946;
        Mon, 01 Sep 2025 08:25:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyQFfDTfcx6weYHYURNCUN2TyUMgP1+sDx60HW3E6IenOe07uG2Bl4c+GEZR2K3WNO1i1qFA==
X-Received: by 2002:a5d:5d09:0:b0:3b8:893f:a185 with SMTP id ffacd0b85a97d-3d1df34f216mr7377103f8f.53.1756740324457;
        Mon, 01 Sep 2025 08:25:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d21a80c723sm10724135f8f.9.2025.09.01.08.25.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 08:25:23 -0700 (PDT)
Message-ID: <4ce074b4-8f79-4e69-81c1-d6e28239ccf0@redhat.com>
Date: Mon, 1 Sep 2025 17:25:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/12] mm: constify assert/test functions in mm.h
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 willy@infradead.org, hughd@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@hansenpartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-12-max.kellermann@ionos.com>
 <081a7335-ec84-4e26-9ea2-251e3fc42277@redhat.com>
 <CAKPOu+8xJJ91pOymWxJ0W3wum_mHPkn_nR7BegzmrjFwEMLrGg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+8xJJ91pOymWxJ0W3wum_mHPkn_nR7BegzmrjFwEMLrGg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U-aU6ZkOpCAF5wITs_Lel2V2Bb-KSimM8wYaORSFcXM_1756740325
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B95A9100017
X-Stat-Signature: 6bkfzwe5btz8cnne7xsgqc5psxrybheo
X-Rspam-User: 
X-HE-Tag: 1756740327-645227
X-HE-Meta: U2FsdGVkX1/w3rx7GWr9xAx97d7t01/+r/6DT8vCYNPjhX18BkcUQY20vWT+bYoK89e7FTlJa+TyVmMkBuwHT33qHIoKFPeuAzhAJjkaJpmJEneejrp0xPqMydW0jieDUmzdoMyyC6eqnoS7VUEMbh1YAYZfkzynwInCvIJGJc9cl/Y7KOwJ657X6P7jP9todV1qzuXRhp17Eg3aa4ijHwR7ZYyRoAOqedSDvb783spE4VL1CrXa95jqvcn8NShedYa1tDMfvxECnfGYT/bpjwt2L27MPz6wAX/8AQlsM+RqhuCMHwPamAKmUXahETqIKlyf1Kmp4rJc18KS5l09uyWD7F6cXFFB5SM7QAf3nXnQosA6dL7eERwgt9gV30DmSa9XgpqfDqkJsvRhZB265+gjxXAILiG5LLQ6115eY8osoQr/4Zm5eaop8ifu4XVtBCSE8VfUe6YSID9JyXCZ2wmDQDHp4+JM3klqRwr5wOVd+odOd6I0QjVNt1gN6wm2rORcbSBcPQ4sq3nO+xDmxj1IJhdelZ2o3/eiL872AFasD+epfseYPq2nWIziQibiA9qc7XeihTidVJxnaqkEEmgPAOviEi9+CvIqi9alpJsaGQysaB9rA0kwfMj+si/pK76K/PXlFZIUsFo5K2Vs24GnEaaw7eQ17Cpg5nTaDgv/JMeZgczR8QpHqlC4egx3XS9gD7wGcwEe0azjDiCHu5VP3OpzSsK+AQd1vKRE//9ke+kJahnsjryDBT9yNDFjTaZenrUgbkpuYLrhy8K+PGqNGQqGyu3d+YpZwg6Q83DHlT0FkbK0rlIZEikSFkA9gpc7PvbSnnXxjdi+J5a5yHYGNB781KY6gvO3OPNhviZtI7mtHrE5AtrEbcO8RYfqbzWN3M5nQ3NIuOifPgWcccNFHpf+MtV5oPfyKmc1TAgSQMCi3xl4YAl6CFmDsexwKcs0zVrYne1d+HNkedM
 uvqc0HEh
 xETNvcYdLve5h3DvsC1spGkS2gE0KAlcgtpcFcz8V9kP1Vii1D0syAzzfZPSVFy1/0BxD/QraGR7xWTre1+EbtvEtbnWqxaKpgPipcHEFFalT7Hx5HlfQWr6jgmCDDz4XyI7cABOqvpF76EdYAX4Q+uMNI56fi8z4HxMJIzeUcBZ4NNEobHhmdBjkevg7Fax3lVOEy0luy94xlfAjUCST5mQniTF9PipQdH/QNCdGXzHtdXdj86oXzlZq9GZ5KE1r+r8KH0DtOkp6De+pTAZLMrFgnfe8b+H/1rt9holLlPqCJdlyis79irw4GX/t2w9wlbH8i21NqP92ODtRHCWJ0CKtUPL4IRaVW+Pa00fyzgBQWU/4kDIFUBsmkLbJxOLkOKk1YhDVJDtK996c9dP8+iu6cwNPPNC7N1NNh0Sum0y0Oa7Z2ho8yQeN01E9RpCNwr60pWtpYn6UI2FeJLqGLLgYji1cysocmBkv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 17:17, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 4:07 PM David Hildenbrand <david@redhat.com> wrote:
>>> -static inline void assert_fault_locked(struct vm_fault *vmf)
>>> +static inline void assert_fault_locked(const struct vm_fault *vmf)
>>>    {
>>
>> This confused me a bit: in the upper variant it's "*const" and here it's
>> "const *".
> 
> That was indeed a mistake. Both should be "const*const".
> 
>> There are multiple such cases here, which might imply that it is not
>> "relatively trivial to const-ify them". :)
> 
> I double-checked this patch and couldn't find any other such mistake.
> Or do you mean the function vs prototype thing on parameter values?

If there is a simple rule (declaration/definition), then it's trivial. 
Probably worth spelling out that rule somewhere (unless I missed it).

As raised in the other reply, not sure if we should just keep them in sync.

I'm, not the biggest fan of the *const in general here. I can see why 
Andrew suggested it, but only doing that for pointers is a bit weird. 
Anyhow, that discussion is likely happening elsewhere, and I don't think 
there is real harm when doing it, as long as we are consistent with what 
we're doing.

-- 
Cheers

David / dhildenb


