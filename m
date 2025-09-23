Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C85ACAC5AE
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E12B8E000A; Tue, 23 Sep 2025 13:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9738E0001; Tue, 23 Sep 2025 13:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE7D8E000A; Tue, 23 Sep 2025 13:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BCDB8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:30:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B48D111A4D3
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:30:50 +0000 (UTC)
X-FDA: 83921205060.20.E097D1D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 36A3F40010
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:30:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ye4tZjGe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758648648; a=rsa-sha256;
	cv=none;
	b=5J9tLOHzX72H6couxtCuHnHWP3oYgTvQkmKUB/6hHf3GNyBvaG2r76zaGO8kGEYqFBXY/o
	QDOYTxKOkzCsQjoQUIfL4mGGYy/PyXygs0+xrNsF8oVUm/XkCLSkGS/N/wwjLes1bmx8Dk
	HB1u/VAcgaOy7dYosH0sBJbZ2coeJNg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ye4tZjGe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758648648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OFNQwbdODcls1yBrLTyCkOTsxOyxsNLxzpt49nq+oT4=;
	b=OrMi76zoCVxnWiTSnUGD5L5QWL1Ma1EszQKfYJ7949QNjVYwG6LGtZaAnoEc0z059gQEKv
	ouIvvHH5nYB4KxRhhs0WyCg7iirXMMfFw/TleoGq5WKY5PxB7ShdCS5iSMzNnBm/s5ZOkt
	ZGl8sZlbUPNF4ohIkHG+zXfmdgrjlJ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758648647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OFNQwbdODcls1yBrLTyCkOTsxOyxsNLxzpt49nq+oT4=;
	b=Ye4tZjGefHj0fV2k1fuaSh/GNWTAXMlo9tPp0qgXfjKm/IaL3BsqW7Up09IYvg8SbqFuoy
	Wb25z6WmpnMFyYXSZp7XApCUCRMCzUQAAeWErpn7ogRNLCiJ5GKYMgG9/WHnW7aqaxwBZQ
	p8w89A+3qwxavIFUbCueulzS0GgNMNw=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-345-aA0MvPhHNO2XqT1-JwZ6Hw-1; Tue, 23 Sep 2025 13:30:46 -0400
X-MC-Unique: aA0MvPhHNO2XqT1-JwZ6Hw-1
X-Mimecast-MFC-AGG-ID: aA0MvPhHNO2XqT1-JwZ6Hw_1758648645
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-4257fce57faso1571305ab.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 10:30:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758648645; x=1759253445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OFNQwbdODcls1yBrLTyCkOTsxOyxsNLxzpt49nq+oT4=;
        b=oxR/ssJJmYWUvTIeIf7h7dVDZjskuP1ZzZZ7Q0nquVpZF3awGuhuQz8tbZSjDinAzS
         rRF+4COmWn0jtH+BK1f7WtxQZMbPhDCJMIKRBFcbFf224YqzvTzCFJ1INTSnaEQfxW11
         BePHCMpT9z+9Ghru1Ck+8biaJ+UoQMkFb4RiWJXku6uiHKqIUj6W/KooVnKboYAKZdL1
         fjs8c/yyL+MBGFE1wlcfWx+j+p5K6S6LxZKRBE5O5JJG0cSpMxjAIMVCcbV9bUp0/vqr
         kpei9+xgtU+7q5wlEZVEkM5n36ssVbwhm6wPPXhKKwjXIQT4kTXpfyAL5KpQUf6XML1O
         eMMg==
X-Forwarded-Encrypted: i=1; AJvYcCWGcalZ5ODuSbPCooFosy10MpqpXlHCOFp6yEPmhxT6SRHUGjyfk7I7nHT6Xv2kpXtduhRHoilomA==@kvack.org
X-Gm-Message-State: AOJu0YwLfWO+SqUwbU4fGR62vD1nOUNc7Krf2RtFgnHGVMowVubnbqCG
	XTO0LuqOpSl6xuIm1KpadifChAlpNiTtJcb8QzpQpf3qlMu8gUPm6tBpUdfO0HUfttW+fR6wDfE
	comY6pQ3QfOUXHzl/C8E5HwXqKKLSruQJp+nrrmgJBLcdko6XiTZW/JU30Q0S
X-Gm-Gg: ASbGnctxH38NSBWP9QAldkJzjvVShG0pl31LbC8fQZpbNdRwC59LCB/o7LmM/OFfZ6y
	dqt+tVPhkJGB4bmx+y2D4HX8MhVBGO95G/9rxdIxOcD0nvpPW5sxobtZtltTqlD2sswD4xEhvhR
	4gpQ2iZfFA22Lvx+iSOBySYMGZ/y1n2sP11tu98gCtsW38ExxAzveMWy4aDsHv0BHGByIqYyUhT
	HHunmhTIL44YYvDWWLoHzt4Fad96PAvRmqmprASzqnTa1bn3mKHhBUyF5LmxqIfzFnVKIQh7u4/
	sw7mfzFkp1gH8CgApk3CRJZ544OlECx9a0fdQlJFLXc=
X-Received: by 2002:a05:6e02:164d:b0:400:7d06:dd6d with SMTP id e9e14a558f8ab-42581e09c50mr18780905ab.1.1758648644606;
        Tue, 23 Sep 2025 10:30:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNobmhXZYu8wcE6bAQtE0C6wCF0m0+GFNpZFLyv2Bpb6JP547FE77pkIiIGw0EG9S0P84Gyw==
X-Received: by 2002:a05:6e02:164d:b0:400:7d06:dd6d with SMTP id e9e14a558f8ab-42581e09c50mr18780695ab.1.1758648644175;
        Tue, 23 Sep 2025 10:30:44 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-566127693e0sm275326173.30.2025.09.23.10.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 10:30:43 -0700 (PDT)
Date: Tue, 23 Sep 2025 11:30:41 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, dri-devel@lists.freedesktop.org,
 iommu@lists.linux.dev, Jens Axboe <axboe@kernel.dk>, Joerg Roedel
 <joro@8bytes.org>, kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>, Marek Szyprowski
 <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Sumit
 Semwal <sumit.semwal@linaro.org>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250923113041.38bee711.alex.williamson@redhat.com>
In-Reply-To: <20250923150414.GA2608121@nvidia.com>
References: <cover.1757589589.git.leon@kernel.org>
	<1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
	<20250922150032.3e3da410.alex.williamson@redhat.com>
	<20250923150414.GA2608121@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Dl3I3pmPG_HGyYJDy3IFjgT73LWsPrsQeE-9E4LikFE_1758648645
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36A3F40010
X-Stat-Signature: bocec75sdom1xecef5s3jxw44mze93nf
X-Rspam-User: 
X-HE-Tag: 1758648647-829547
X-HE-Meta: U2FsdGVkX1/5ITCRhDcvhdb1aIj+XegWzuhTo+nNL/sU2oLMKDm9Wm5RAGu+Nmli0/pUHKFEF+EWpIwJVMLyorDRS1k77FFei02US8Vz7K/h/zGyheyZwECeG71PkMj7kzgL9+Jh+g935F5cAbP57FzHtHqkjDReBT7s6/LIrdbzwVyPK9EPYuy3uBqPT1rqQK6neyKsz+dCFyn+wNTp6cwhJYiSCGM31gXf1xJxJe39HwehcdaWGPwfkXpF+qsIhtcqWHfAsD52PR5SeKluoo3/6DSRqKJVXhRLziIy+DdueQCh9ErOVRcq8H6jfr1hKC6X/WP68SWGf8UTPX3278plrKAYTpYMtdqhXVzLAA2JLfzUrjVNP4CNZd2m0z65flE0jdmvBBHPV/NLhDhNCMw9nINJstXKduF2mSSNGLS/KKtn3k4szaVuZVb0pFgXJX6q1W5NlU0PK5GL6DPBSys6kxhBa+nuWQ8s5JePNIlY/kvjN0Z2Z1a1MYqvjCA/jBGHqzorcrMAP4ts1GTI5ZzTCR/8ohF5ipM46QMod/QuoGuzlryPp6cd5dG8HNJ3KHhMv057bkFhgIE0+FJ+po3KYj/JxuvCv7KcwkuV1SsDT2ywMYxxGHJkQ+eyy1IjM8ZrrBLlaRCtKcUn35Iv4+K5pjbgIE/ZSUgLpMU4RRLuWfzJ3ZLtKbL7SGIwktoBOiKJ7xae+cSt5NxFYA05XNqEL/c3tV+wg7xxVEvRc2gyaq0FlLG8puolW0C9CFUfe1EA4YreIsAW/lhIeWnpOHmBgowj2Gm/jyR6cjqXG5jdwmYBx9/1gl6JkVDgBduAUtOyDlO819A2YFKE7EZfcnmDq5YbNOvAUkXlEG+UKNGinnvt6VW3aBs3mP1EA85ujaYDsQPREffmhGDXL6Sdgww7W9W0Jkh/zIaDzw2SE6IRaFnqT8A9m9RCF/gHZVTJylelcL5ZDz9XJKRVZnC
 bG673OkA
 KZqUER1iHVDu3ebJ3/eVFMZRO0dZX03vLbJ3dTOkTKlhQ9DkDc0YyTGr/66AGzXe+4Xu/m1LWNSBb73FP82KbUhqqcoxswzr8kjSXMXOqDYH1Z5HaVKBrb24b0NfTBvizXj3aiyzAeziqYAjnkC803O4zxavL0/9JI7CBkSuwpXEaa+fJSLt3C4AYzfRcSdfbRyfNmWfFPtENE8f8HHepQbknCsZGpZfZ/QDnY2PNwtNveXQE/4hdqwc8huZhssTsnRwNCZbNbFSlyxncCvxxg2qSRW3oOwor79vh98y9PT9tadalFFcxoedzaP1RNhZ6k1C8en8xgYK4sjRpQUGoKGR5wYzQkQMPjncEKpfAC6psUvEIRXuV5JAB/nNF7Lq7QVajlzh+yjdPStbPo593B5LVvhHBs5D2pH1W3MRRf++aDm9oTUn8L9thfQUfef/FNcHCCH8m2VqLadMisptLIX25Nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Sep 2025 12:04:14 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Sep 22, 2025 at 03:00:32PM -0600, Alex Williamson wrote:
> > But then later in patch 8/ and again in 10/ why exactly do we cache
> > the provider on the vfio_pci_core_device rather than ask for it on
> > demand from the p2pdma?  
> 
> It makes the most sense if the P2P is activated once during probe(),
> it is just a cheap memory allocation, so no reason not to.
> 
> If you try to do it on-demand then it will require more locking.

I'm only wondering about splitting to an "initialize/setup" function
where providers for each BAR are setup, and a "get provider" interface,
which doesn't really seem to be a hot path anyway.  Batching could
still be done to setup all BAR providers at once.

However, the setup isn't really once per probe(), even in the case of a
new driver probing we re-use the previously setup providers.  Doesn't
that introduce a problem that the provider bus_offset can be stale if
something like a BAR resize has occurred between drivers?

Possibly the providers should be setup in PCI core, a re-init triggered
for resource updates, and the driver interface is only to get the
provider.  Thanks,

Alex


