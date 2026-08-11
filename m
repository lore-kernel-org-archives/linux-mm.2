Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E5C5C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093DD6B0093; Tue, 11 Aug 2026 16:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045B16B0095; Tue, 11 Aug 2026 16:21:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76166B0096; Tue, 11 Aug 2026 16:21:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFFFB6B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:21:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 576BD1601C4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:21:44 +0000 (UTC)
X-FDA: 85090109328.08.43B90B2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id E5D7640009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:21:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P5Sn07vA;
	spf=pass (imf11.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786479702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bt1fxL8cERBCqsI9SSKDXDKzRvK6X8fCwUPGaC7m26c=;
	b=QX6nPj3U41//8joXTOBFctZjLqYVpVy0kaGmJEd0PMKsXV1Xs1hIzklIfrzzMODEHR901K
	tyl0LcZ2fhK0CZSzIJBmsmCfmnL0XVmHzc1S0slv0di45qth8nQebFqKVrmx+CRIFZiMGT
	aGzOLW0QP0U44sFzLBXVR6DxcyfxJ8A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=P5Sn07vA;
	spf=pass (imf11.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786479702;
	b=7RRZ/OISbzUy9hItdLRtRX+sm1BOkI2pLB1mPu9mcUhV85tnTgpd2AVFQsIaV/YWOIws2/
	sXGu06kSVdZGnhqusqH1XRifu3iu0lyWVLRJXCGCHNY4BL+gwTcY7Wp10t8WTig29oeHK0
	mYCHdx1H/pmm5gzfD8S3CVKD9Js/eSg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786479701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bt1fxL8cERBCqsI9SSKDXDKzRvK6X8fCwUPGaC7m26c=;
	b=P5Sn07vATsLCZPkxOaTxdJPn7MUhQkZVB/95DgXexhgkfJIcCPfzdyJxp6yKFzJS3COJvP
	rxAr1CszABtfSxFQ6j/q+oAASJQzpjqMY5sU4gFqL+QTi3GKthdGVLrzv403rz7lS5rxV7
	WmeMV6jy3RHjIl6wrUBHXahJG5uzYWM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-YLc_UMmlNsSq8Vlya28EpQ-1; Tue, 11 Aug 2026 16:21:35 -0400
X-MC-Unique: YLc_UMmlNsSq8Vlya28EpQ-1
X-Mimecast-MFC-AGG-ID: YLc_UMmlNsSq8Vlya28EpQ_1786479694
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47485fde05aso99806f8f.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:21:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786479694; x=1787084494;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bt1fxL8cERBCqsI9SSKDXDKzRvK6X8fCwUPGaC7m26c=;
        b=T9JdmKRmwCYwDOZMmwhNhzFvT8ONOz7TcySIZZcHuTPrtfaL+2Q7exBoViW3qslnQu
         pCMLSQJdH7RlKrkojWtseaEWgIlcmkqIrhTSevK6ERqfvcmpWQVXtIqfABb0TuW+Z6Uz
         Cqg7DYNkwI6kMlr3kkdQotRSPkKcqa0i2hFhXZfv371CRJQ5npMaG6/JAu8ZE/PRLV9m
         jPLU6y8dqwMpoD550GSkjg4aaUgD+ZCIVsgS/oKmgbArz8nnsKEybF5EKbkNs/BdIZnf
         CqyHwgpNE2Iouf7FPCJ/MlIpuU7JlOW1SHliXJIy/pEg7a/aP86BuL8p4R9VF1x6sKRq
         aNng==
X-Forwarded-Encrypted: i=1; AHgh+Rrpcg0cfjopT2CvrZIo+YLNb1Qt9tKiuiWaXjqo5Mgw+N3uY+enJdAFzNAOQLB6qB3QOIW/TUOCiw==@kvack.org
X-Gm-Message-State: AOJu0YzMplf8UtSo3oUIm/BLw/GauMqvMzPMUem7gD7won/bvQ9ujkya
	jvqPqtiUiD7RviDrzdOuirbQVtVniDT+DNbv7zOWb9PoxV6tlMyO6VIhwhtibF9Ad49yzsL6v1+
	Dyz6fBXLEkJR4T4K2bErKcCgW9wMesENu9z+2eS4wXfgLzFqj+3XII95tHWuY/LmIC+aetKiHy1
	oKNySklb5+XgWrVFkCRe8fWn4jAcM=
X-Gm-Gg: AR+sD10Z00FalYwM4C5CbhW4zV9JiUKrnNdwyqtKGVUodJKrdrAhrEYYz/1mO9lKQqD
	F5GPDi7xVw0vrSIjwMJ5W0CbiI0PWUG+slZ2MNJnd1uFHcOTEk8WwPj8Jxo40bSGB3n8OcByM1d
	38RaZ6Ve9dnRTPNG8KGkUMiG4OEw5mIWz8nq/wPWSGqVJoPS+THFRbu799JhIkrO1QKFeGItqgd
	fAkQqV12hcTxanwOEas4MvQFBqShnMb2LR9HpDCEnWfFrH24BQBm7CbAKY=
X-Received: by 2002:a05:6000:4011:b0:47f:97bf:d891 with SMTP id ffacd0b85a97d-4814ad755d1mr8659634f8f.1.1786479693853;
        Tue, 11 Aug 2026 13:21:33 -0700 (PDT)
X-Received: by 2002:a05:6000:4011:b0:47f:97bf:d891 with SMTP id
 ffacd0b85a97d-4814ad755d1mr8659586f8f.1.1786479693441; Tue, 11 Aug 2026
 13:21:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260811162423.GL544626@ziepe.ca> <f33571137d2e3973e440d09c7602edaebe08b714.camel@infradead.org>
 <20260811172627.GN544626@ziepe.ca> <B25708F5-8425-4075-8D95-5E2A00C933DF@infradead.org>
 <20260811181915.GO544626@ziepe.ca> <anuAq2s4mtyw4_Ql@google.com>
In-Reply-To: <anuAq2s4mtyw4_Ql@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 11 Aug 2026 22:21:20 +0200
X-Gm-Features: AUfX_myRxh8LArbRwhhI2WDXN4cv5LNCX8fqVJeZG8bZ6cm6DTva5ox9mCkJIi0
Message-ID: <CABgObfYR+vXBuSm3v5jbbZL8vF=XnocFAnjumdShgXBzod-HCQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
To: Sean Christopherson <seanjc@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, David Woodhouse <dwmw2@infradead.org>, akpm@linux-foundation.org, 
	david@kernel.org, mhocko@suse.com, rostedt@goodmis.org, bigeasy@linutronix.de, 
	simona.vetter@ffwll.ch, jglisse@redhat.com, christian.koenig@amd.com, 
	paulmck@kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hB4FmWFXStaRa11zgp3M5MtvdaFIgfeJ2SG55Q49kD8_1786479694
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E5D7640009
X-Stat-Signature: c3nneprqn3bzt5bptcgkynmsxb9f6swx
X-Rspam-User: 
X-HE-Tag: 1786479701-340017
X-HE-Meta: U2FsdGVkX1+kUi6tlkoZxkjCM4g9bsJYgb9e1/qWNMVsjebB02I4Chzybi2s8R9TYeBVKM0m47Fbh3GzNaH+2p73a/HH8C2pGK5kGRt345M4nJu7sP7assIoWhLrbW5xaktz2S34lAG4A9vZ4FfGjWyvflx6kKBrTmJjda9zfuVzhFXQBjodBBAz0vjQBhCKWqlOjZMK8wR7dfcoiWs9A2O1bIjR7gl00gtm+ISexl8BAEwPU3js00WEfSpSk1a812uMnT4vnYC/FwEyA9dXGOslRu6uB0oLavwvFGT1E0FxD/G9nijfC9s4uc0mJsycva54NX+DkbyUPi1JanrD1dRA2L90JAcCiXqwrhhx3gfln6I5GL+CsOnl9TGIyXvdqmzCkk+p3hxPsnFr2t5YEYu1PFY2IDwJdnxe0NkSMP8maQyrmLNAskdwrNQCDQYdQNabAVLK0A/iJqcgBrvGk0nid98FY/gh2qkegFI5IbhUFj/iDROH81qG/iyu4n7MPJaWgEafO2Cf1B6QyLtjZWiIDBkeQClCylK1BNiNIvpL0B4Jg9l9wnx36tiyQfnBqLGxrvFb54Zqod1HsRjjJBSuzZs1EzKtCgRLdQXuCWgCVPByL25suCER1NiT37z7MbNBcY9iUhqLXs3ljHriGJj3uho+RYNkudgw8gBmgiY6dPtX/STRQzPk3e7HS/wd+DP+hTkICQ2ydV3EkaxOo6X72MXcmhzm3UJ/7JytJj6H/F06syjlg6JRmTEvs37hqAf2KD+Kyiz7+pGsVDGKH9u2PIK50lOU4vCdUqS0ebEiULwIhoz8zNg5iDjSTIYlBvqkwnpTZkSiA4I2zAfM7OfbToRTQ1WyBsyJrPuC9C2zPVgA7fVaOc8d32tRmhtTRsPMg191dy/1/NJUrwEoHD4o6G30fCHx12KmbJCvevv7HXkea38l8/Fn4NSO5XC4ChqhlXwAKRegsvJFPDX
 FV7ho7K2
 j7J11BzzbwJJtUpQcvg+PHVwLkjYLeoWAjVStZULkGwkKFdKR0hNfcSsleIob6r/BlL3+Rniiu09YX7NgRyR2bgp+f4fm+Sw6VzYgrVwSQB4jVxAo1N86LsqMeFt8qOJYtTTWBtXRsVGoEKgtdNIbhiHbTLjMkJtNFnUEWl8/0rbGdD/QUNn3AzxhMCdOm0zr1q4U7nWmHtu+KxmcHcuIq1NFZbyDP9ZItOAF5z92UsV1mK6FxPTsFk6ulra4nRVNKxBWG6lkyklnDrsSSgimk5vyFgSzklL+/lhs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If you want to avoid global contention on reads, you can trade it with
for_each_present_cpu().

On Tue, Aug 11, 2026 at 10:06=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> +static inline unsigned long kvm_gpc_read_begin(struct kvm *kvm)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       cpumask_set_cpu(smp_processor_id(), kvm->gpc_readers);

per_cpu(kvm_gpc_reader, smp_processor_id()) =3D gpc;

> +}
> +
> +static inline void kvm_gpc_read_end(struct kvm *kvm, unsigned long flags=
)
> +{
> +       cpumask_clear_cpu(smp_processor_id(), kvm->gpc_readers);

per_cpu(kvm_gpc_reader, smp_processor_id()) =3D NULL;

> +       local_irq_restore(flags);
> +}

and then:

for_each_present_cpu(cpu)
    if (per_cpu(kvm_gpc_reader, cpu) =3D=3D gpc)
        cpumask_set_cpu(cpu, gpc_readers);
__kvm_kick_many_cpus(cpus, wait);

Alternatively, there's always the poor-man RCU using an rwlock_t; you
do read_lock/read_unlock as usual for begin/end of reads, while the
write side does

   write_lock(&kvm->gpc_readers);
   write_unlock(&kvm->gpc_readers);

in place of synchronize_src().

Paolo


