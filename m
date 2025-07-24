Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C5F3C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5B66B00E0; Thu, 24 Jul 2025 19:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDBF6B00E5; Thu, 24 Jul 2025 19:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB018E007C; Thu, 24 Jul 2025 19:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3B26B00E0
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:46:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 468D61A0554
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:46:55 +0000 (UTC)
X-FDA: 83700795990.07.4316487
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 90B7440003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:46:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hh3uHVPI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 37MWCaAsKCM0tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=37MWCaAsKCM0tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400813; a=rsa-sha256;
	cv=none;
	b=dVk3dkZkQ2HpODpHz9Lv9CzRLYWamGAGlyUWHhW3jCkg5e6CjWU9457uoEqctRljUxyK8H
	97qj5qwEvUCjnmxeYqSFpAdS+ewrSYE2UrK+iKxAyGUKBomFrAW+s5qcAbgkqhIAlXFJ7K
	EEVwPm5XqkoHtHsGWAeqrLnsbNQ6DsE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hh3uHVPI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 37MWCaAsKCM0tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=37MWCaAsKCM0tv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rq+CCcHnbrLIieKNkCZNAlk2vPBrV5d4uE0b045YV0c=;
	b=ckBjnHGZfjdPcM1VFcj5P5WJId5SakeX+xgEbZgswQ1PiVZfeAuFBTs7wixx0YMfkmsoUo
	7/5tUD+CMnO9i2sYvIMEhUGO5L5dXQgVg5f9lNxg/Lyah/kWD32C7SLjF2GNhBNX7fXgKw
	Kf5ceSJdTsTb/0ZFnXbZ6gQvzgATwMQ=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31220ecc586so1461792a91.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753400812; x=1754005612; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rq+CCcHnbrLIieKNkCZNAlk2vPBrV5d4uE0b045YV0c=;
        b=hh3uHVPIK+vm+s2e3QzJ/cSkIfnGDkPT+OSVHjtEt+H7izUI7eLxZkreZCu1fDyhvL
         Ilp9qxu0oyRQ2wdGDeURUiNimD08hNaGPb8EkcN/so2CSZUxD3PvNr8dYwc3AnpTWfFn
         QAZRIQ9UF/1TW6W+uBZAoP2wZk8wyehdMOtbJJ2VljHyZTpBb+HESa/D2636s6wz8pEk
         xUDAIKt2K2amOeLgmVqSgeiRX/9Hu6lbQX2Flab9bd8I+wH1xas53+q2hbbi/5YmHnyb
         G55xU6m4v1HjcEuexdPfeeTcVDFmiSBsfYeAHtqIUK9ly2aFPdnKAD3bNs8J88waN2Mj
         gKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400812; x=1754005612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rq+CCcHnbrLIieKNkCZNAlk2vPBrV5d4uE0b045YV0c=;
        b=HnInG/S0mk/uxcMrzOe7SdZJnCc4P8YpXuOxBFXi0uKtTk3fcpmM22CTIidBsKQ9d4
         KBj+glkrvkNnNPzlFeP0fz68RVO8yqQ1wZdv2hHlAgJa6n9+UpeMPdu9r+wgP2DJIm2+
         vVSNiZLE2c+UlhqghmAp39WZcQx7/GTFgpE2wM7V8y47GQaMndxBA8Ljeb0hCcJF5ouS
         teY9QNcMjBKJaKx5mb3p5ReIJSfIR+nh9wqqdskzTVPeWYkmlj8b7AS6inuqOstOdO06
         gRwNkBThVy86l27f9Qc1aZDisfSFAgIOPuXfikDNnq+pdI0yHmOBvfAebagRGrj16WQf
         eYQw==
X-Forwarded-Encrypted: i=1; AJvYcCWCpd4WA/Ro6CY5ccz4t0FKJfTOq/DpqEMamD5inUOMPkF9dC71f9oKnRbKypRyXB96xlIUoynlPg==@kvack.org
X-Gm-Message-State: AOJu0Yy8ET3JKRRspwEqj2ZtyyAJnIZQGk6BjAI0gfALCVSuWuq+LTcQ
	ctPwWBeNiWO50hdFuxHifR80rlTAO4LiTSlonviDz1QXGSZH2va1J735v1koaidU3vu1ZrF3n+Q
	YnvCHWL5ISJbSgJwdCuTA1Ut/HQ==
X-Google-Smtp-Source: AGHT+IHBbNLrQlITZTUEwJZc7PPMBuWUPvVh41ATm80JrPARR6vxu6fTSW3zd2GzVR7d4WnT1Q219CCX9tRIUbCxQw==
X-Received: from pji14.prod.google.com ([2002:a17:90b:3fce:b0:313:1c10:3595])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c90:b0:311:d3a5:572a with SMTP id 98e67ed59e1d1-31e5071cc94mr12799088a91.8.1753400812263;
 Thu, 24 Jul 2025 16:46:52 -0700 (PDT)
Date: Thu, 24 Jul 2025 16:46:50 -0700
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
Message-ID: <diqz4iv1dudx.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 00/22] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 90B7440003
X-Stat-Signature: ur6dsw1xttbssn7zpye13r4w3mmwdmh4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753400813-547946
X-HE-Meta: U2FsdGVkX1/l/ej+RQVG0yxl/qA+gpoTsyp2KTAx/Q356X+LjTAKNyQ7dT3QrxMzGew0EM5rdYgs7lLX3ZwQnp6zmYGdMw7mBTkILg42sWwI/mroM2rb1nMfL0P8MVSL5NQawiR6kiNDgz/ruaN6o7wC4rtTJ9GTIwnqK1W0VgYBXWmvDnvjMmrKANcW0wR8PZigdJsFvXx5gqeS4POWDG3cE7kQfPbgVjVFR4Erh1crxwLB/lADFQKCkPE2bsAUH76uLEAVZav4hkwahNtRbWj/5BT3QqmG6ay0vVNBBC2+xKNu0Nq2Nm5JC7AViZQfnzSWKbw88pvh6l12Zzs/h/Nt+z73apTftzG1/pjvcweDRkczg0tATQoIlr/jGMZokIH4Jts9k5ACiIsDgfQGtv0YCKuoFJ/VpYxq2O4BS94tb8eYLQjrGdqY9DAF+znIBibTAQzzI9fNBrEQ0IuUeRTNq/pjnwGCbeFl7E6on4PU2ig6xdJAFkB5z9gcbkREDdfvbm025CHydCi9VCzRsk/ftaaH5VsS1baxBm12EurxrGN++x2wYrT9FSwGkwP5Df67MQJO7lqCQlHJqeBrCn/KF3zpTPL/unVSOX5WqMQTJLkBu2Mfze2RR/CQFsIFfkHy9LCLTaYFTG+U8gEBvhrhlbYK/WnXy+fk+tOoJBxJZenODPzUQdFfq/qh42kb11qkJCliGULudwj7Rj1ImfvLTDSP7lnCFtdtK+od5COfVc4Poja1NlGaBb+hnMjy1Ku/bR1hyq9xiecI+zQR0dX4e4yDfCMb6XdwwfSjBgApA5a+uIykFWObnrZ1ifPg4u5llhEzZ9+JzaVZa/KNnv51a24ZUQoyPF6SZtlUjrwPNT/5+2O4IW62zavRXlKw8j0tLO5EI1QpPTS0arKnMi/yY7pLcuojucbP9fR2WHZVuEg9d66ZGyQ6RGL8SY3CzqmIf5Rczl/iogJh6du
 y5gKsKNg
 NXy15ifbAxzWNTvHbWp8xUvUD5S9qWxwPfLFHxg0TisblQ1lNj2fcEMzlN95Oy34vkWTaISZ9QycyYPmul3qUEB8RQCqyJyZW6idN4xiiZSmQ58GnpgcVA/GTzcv96u5D9FqcAbtaPeY7BRJ8tGj9iFOXDQGd8U9pHifGvnDVf9RiyzPk0ogs8PD1ZLX0u4szeyGBN78WBlDa77EbqXy6qUOiUk1+D9e1jwH4uyjtXk6JoPWsoKMYF/bZLEwmoElQPrO2SQu7HgTuSl21QCuuoqmK9hGqBqlzVs0HT/nycG+DV07yInHxmTm7I0qPKlqBwmsPhbb7TOrrMaLC3LjZp04fpQBPQqM1P1rLHRSX9i982cBy3ynAG+v3qqTw96x/ZTcdfYA+VwWa6nRnz1qlh196Hp9DF3MN5sGc214TN29TVOdM+HoyIOCNOT5jVKaBbKOf1NskylqWSNyIgUEjV3SRjRabsQ7wslWpDhFc812pdLX0Yv4fDM39S6TXLSGJbGsMmquswzk4GDP16AH40Omlw8Sq1Ro8owNCnF/ia29phHuOlb7RZr3HpAjYaHlETao8cz6lE4opIp5XWxbr3H/QxFS/pVyj+CXLrmwN+3GsvGwFg2PR2lEV1eddGvWSrwoa4cPnzoI4LkarjAmvdGU+hai6xMh25MeDFsmTvidZDMuFKLCNIKBri9SoxinIUwUA4M1Ub4vFEjH+hMklWbBEYoul/8M90RQ/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fuad Tabba <tabba@google.com> writes:

[snip]

Did the patch [1] for x86/mmu that actually allows faulting when
kvm_memslot_is_gmem_only() get dropped by accident?

[1] https://lore.kernel.org/all/20250717162731.446579-14-tabba@google.com/

