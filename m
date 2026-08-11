Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26523C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05BEF6B008A; Tue, 11 Aug 2026 10:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032AD6B008C; Tue, 11 Aug 2026 10:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D4B6B0092; Tue, 11 Aug 2026 10:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9DCF6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:48:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CCB940472
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:48:38 +0000 (UTC)
X-FDA: 85089269916.18.1DD4FCD
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf16.hostedemail.com (Postfix) with ESMTP id 93F2D18000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:48:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aUhnFxXU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3QzZ7agYKCPYqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3QzZ7agYKCPYqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786459716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVhz6t6uiOZc1DDgF6HOTd7wvK1RF7/iSTLQV7TuFds=;
	b=EMdFOlmRAjmhiTkN+IkkxtewcA39Chphlh94knBRGHM6uMsQlBvxnUw4xKzKpVY7eSxpgj
	hnJRBIYm6IYM09l9A36IUBvdoQWiNYQt7REeRIBQWbYHfqYka+LNS86fFTUIVpxGXC3U1/
	sx7B7KAPIAvWEJNQx3ahvCfaKdEjNI8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aUhnFxXU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3QzZ7agYKCPYqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3QzZ7agYKCPYqcYlhaemmejc.amkjglsv-kkitYai.mpe@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786459716;
	b=hW2DpoZxt5Nmm9aZQBvuKr2Sjbo92cN5tRLIOHpfxi0CfSm5huIwGsn4okRlUbSzq7Ya/g
	6t8UqvyxhQt1AYv/jkJwHIdDA8mE6ziPgwjQk4oTe5Gu70Sy+22JDavaP2ibJygqW5z3P/
	yuC1WQk3mpfusdnv272I12ON/sp3S74=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cca5e0a0c9so68020375ad.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786459715; x=1787064515; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rVhz6t6uiOZc1DDgF6HOTd7wvK1RF7/iSTLQV7TuFds=;
        b=aUhnFxXUdpdPu+gEUWmT4Y3Gky4k66QGa58nzbYofTglBwQPFO6WELPKoN8fReYsLG
         8E3UgNq0vGUzVPMhn0psDagl5VtEd8rCt9yZGRqXaY1G7b1wNKP8QKduO2E8TLs0bmtP
         hcCdnSWMgzSGtwRm+EcHfP8fFM1oItfGXugSSaH8hMeXOoQejhy5ODwXuhAVwnN+x1cM
         5UvzzfY7esYDXlRQsQ4e8WOK1FV6nKTypXJSJl0H2hwzo+0CXBGi1pMrGBMxdbAdehDf
         BaWMFZjqJm5HfXiWKDxBwNZHSEw+pQzTDQI1CJ8iPgSD1q/UhVhBFKBFS62lNZGX1JTr
         RTFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786459715; x=1787064515;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rVhz6t6uiOZc1DDgF6HOTd7wvK1RF7/iSTLQV7TuFds=;
        b=SIJ32kx6hB/dfXmQ8uJWAnyINL1xW1WydcdbZai8zq5LaGsbkWnkPIkZA208HscIza
         677q0BKhryFlr3Q4Atyxj5nMBlGvyuIrwu64Az77+ZVXetwzaUQpj8fxwJCj/hJ20SuP
         cyVXF0fWQVRa6Hdv/TOjX+YEACQZnnNj+ksNREsqkcEJvraBkrzsJ3gJMMz62WJdcl5W
         bOQL26oDBTYMEKjtc3MnEYgv2jJ2HH1noS7dApZf2Ix344o27P7n6dOl6OLtNoJOoq/u
         vdp2njE/HugwALn6aKR1/PHODBooF/XxBHusMW2RTG+4QsSPBxvgKkT8VwChn6RUBh/F
         u17Q==
X-Forwarded-Encrypted: i=1; AHgh+RpAD+2JgIFpUSNdpOWasltp3+QTFj1diSbQy3AtKU3MFiYSfQ1CgRjK774tzIJ5KVFb5E3cF13IeA==@kvack.org
X-Gm-Message-State: AOJu0YzCRfWAGodSIU0pCUlErnXp357FMt3u4MEc2nXerjUjwh6mldpC
	VSFmI605QwEYB5V2ooYJ2qZN/e20MnW3trGl8KXY0nvX5PTkzsQkDyTxmCtFs7H1erXnWtDw57v
	wU14LhA==
X-Received: from plbje14.prod.google.com ([2002:a17:903:264e:b0:2ca:eea9:9845])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d488:b0:2d1:1a18:4d0a
 with SMTP id d9443c01a7336-2d3177a2163mr42800725ad.9.1786459715153; Tue, 11
 Aug 2026 07:48:35 -0700 (PDT)
Date: Tue, 11 Aug 2026 07:48:34 -0700
In-Reply-To: <9huzqzk4zt3n.fsf@tarunix.c.googlers.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-2-tarunsahu@google.com> <anpXjM_lg_UTpl0q@google.com> <9huzqzk4zt3n.fsf@tarunix.c.googlers.com>
Message-ID: <ans2Qvo0453cc_DD@google.com>
Subject: Re: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
From: Sean Christopherson <seanjc@google.com>
To: tarunsahu@google.com
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 8bsq6tkzyhz5f1ajc4usqkezukbdzgji
X-Rspamd-Queue-Id: 93F2D18000C
X-HE-Tag: 1786459716-583768
X-HE-Meta: U2FsdGVkX18ffCqPwkVt6OBWnrhZEtJSgUh/CAHgP5SBgiZAutKxOS1BLx0DdHwH+2pCj3ghLBn+cvMQxqaXZVwQxqZ1FcnqYYUb+lECiARoPwy4qso9EiADzAWml+ZkALDjV53Z4scS36sMSvwg0WL6pmLPFH3x70pA+6k4HfX4AVyw9lwUaFad+RckHp2j0FfZBpfmehu+jH7q8x2En8FFTsASxIH6mwj8I11yUEc5WGYrYgK8NGj/JfkB7pHbRm/uvA+HvDABXNFfK0KC3E1QVFZFQ7OveTURAxHQRZZWRkMVb/AiMhgHQHfqAlS5dV7S2p1E6gq7R25R9SSGIu716JdmHxZBVCypXfm82Z3Arpq4LR92YLZ3hU3u3KvCxdvncskixHy/LCmSm47z7I5a5O+bJQ+tR4SEPLm0Cmg3idMKhrd7J62Q1KLdItadGaoAWqyzFroKG244VgOwy1FvgpOBK/oal7wTt2AIHWhJzMRJVFaT2Yv2vZshw+BU59bZGes6DZvFwhQTi11Pm9h16yjSpGL9Uybf4g/0gZ0O2M5PgP/6rUSEVfrnUnRmm3g0Q/YudTZUDWL5TO7m6TkqgvfRhJ5U/UuI9snotP5tY0FBolx6f6XooykmmuQrCpHNeVG8H+f9mVD3d5vYrI4CkMJHDSZsNasUhUuPTHY2cl1G8Z1Bu6mMPJkv/w0bNowaeOV6BkpG3h7DsOGyIOuy09EWRfmxqAMb4sG6YKF37sy8l1GRrMNz0p80ogV/b7vvLVrIY10Hbg9FBK9pSeILCWpv7LyEx0+5iTx2vrAENyRH2ea0DqowIxc7hhp9uh1y0Sh80vBT1WD6u0Xqu+1uFrtKCIsIa/VmD/L+ReDsoyRcAO5WYCaTcJCckccdBk+JztJRuaLaWJ8U8DczQvIG8P38oZHCA4wqQ0npwOlnJERaRXHJG0HhJScNJb/iuHAHJGLYOMTpRKvgtOy
 OiaQafna
 9d4beszxHH83RlAKWA1zhUkE6zMMEgemb6F+7+YNq68Kn4PICWoJtSwb3DYDDROkQL0ZSZRPwfr+4YxV2H3oHkvogFUx4C7hrS/vPoxnE9OAz5MEzjt8+lTz2MlNfuMgPBW0PxGUpRr1p/KUUGJbIRhJM0BpwjnFajLfA3ve5xadXY8RwdfX8sM/PGi2MRgafnJBtGEXOmoxoyBjrd18e1iYyG6druMIcmNJj/NvI5zbXfthGNjxHQSS6iWOGp4UFUO33dj91gEr6fck9XFYjGFhX/xb2mbf41P+TG2VgIzrxA7J3Q4ffxNeu5qufyWQCpKgLUJWEiSW5ESkZRhkD6ITtFlaZu9UnC53nDhLjXMfy4OYhgzlPqDa3swiLFHfxA7ESPb8cGaXjgLl4WmkfBbDsgCHpT5mPr7Z+0L31DMkj1rKIh14rArJ2vrRPTKDR2BuN6LjzWOhEaDtYYmQiXzCNJ4belQYCoPT52Q/1Qq1vhGlvpcSKMZeGQpxaBK/D2YacQcxgzAOEJ14amZmAEQasqxTBTps2UuwqrxIrmS8XmlruckpFdO6AZVTV7WiKo/dVoaNTQNvQkPzTSdcM5IuOZ6waUMYEGtzjSmpsOOekQh1OjD5+t99lnFgZYBRIdjjX1fryC4nzuG5wF6FHnVmx/WXl+IplVWkf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026, tarunsahu@google.com wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Jul 28, 2026, Tarun Sahu wrote:
> >> Introduce the LIVEUPDATE_GUEST_MEMFD Kconfig option. This option
> >> enables live update support for KVM guest_memfd files, enabling
> >> guest_memfd-backed memory preservation across kernel upgrades.
> >> 
> >> Currently this support only guest_memfd files that are full-shared
> >> (INIT_SHARED and no support for private_mem).
> >
> > Why?  Specifically, why do we need/want a separate Kconfig for guest_memfd
> > liveupdate versus KVM liveupdate?  I can _maybe_ see a KVM-wide Kconfig, but
> > even that seems like a stretch given that (AFAIK) hypervisors are the one and
> > only use-case for liveupdate.
> 
> LIVEUPDATE is used in many subsystem. It is possible to enable
> liveupdate and kvm without enabling KVM_GUEST_MEMFD. So GUEST_MEMFD
> preservation must depend on CONFIG_LIVEUPDATE and KVM_GUEST_MEMFD both.
> LIVEUPDATE_GUEST_MEMFD Kconfig is wrapper on both of them. It need not
> to be visible in menu, So I can make it hidden. WDYT?
> 
> Also, KVM VM_FILE preservation and GUEST_MEMFD preservation both depends
> on LIVEUPDATE_GUEST_MEMFD in this patch series. [PATCH 05/11]*
> Which is wrong. So I will update KVM VM_FILE preservation to depend only
> on CONFIG_LIVEUPDATE.

Or just handle it all in the makefile?  E.g.

diff --git virt/kvm/Makefile.kvm virt/kvm/Makefile.kvm
index d047d4cf58c9..e6f098498795 100644
--- virt/kvm/Makefile.kvm
+++ virt/kvm/Makefile.kvm
@@ -13,3 +13,8 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
 kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
+
+ifdef CONFIG_LIVEUPDATE
+kvm-y += $(KVM)/kvm_luo.o
+kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd_luo.o
+endif


