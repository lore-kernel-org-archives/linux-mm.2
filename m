Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA30CC561E6
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25106B007B; Wed,  5 Aug 2026 02:08:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5236B0092; Wed,  5 Aug 2026 02:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC78B6B0093; Wed,  5 Aug 2026 02:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A703C6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:08:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B08FF1C0B3E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:08:36 +0000 (UTC)
X-FDA: 85066186632.22.D703E2A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 758D340007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:08:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hZFLiu3U;
	spf=pass (imf12.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785910114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0Sm6aitHsc62gyEgQg2/9qpXlfx9wA/VX2KIRUAVSU=;
	b=Ov0Gn02JJV9u7QV/2bPOw06kckBsFvE4jsHMrdMq6/pI0FStBYqhedvu1VAC2awSeWnkaV
	OhZ5dTOl89pYgwKauHvNixTmnCLSRnGGGv2TeE9nfvSir0dbc1knG517gFVN5DMdrggw8B
	XXL/6GVBcR6HdWwyG14Y8pL0g/xjGs0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785910114;
	b=umbkNQM609ZjStqu4NgAvHkPxBiMEjW5GQ4crnsff2nsdtSeJdEzpbXkmVHS7cWfv8l3IN
	naTeXRD12CtcPE8Hy7sBek+/AMEhCBtfeI3ryveaqITw7VXlObT5w+vukKUZAmasajWk0h
	G5xiLrk1TM/T2ERpLRHsuNEoOngCgPg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hZFLiu3U;
	spf=pass (imf12.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785910112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0Sm6aitHsc62gyEgQg2/9qpXlfx9wA/VX2KIRUAVSU=;
	b=hZFLiu3UwUoW2CwdY6gEUvQDxXKoHngko7VL2leRakgVyhEHNySZZVGhEE3N85C9iKFZtE
	SR9Xm6562dgTI6qF/wnLs+3EMkGa5lzbkFlQwNZPNsBXioSXpQIdxeRfedTBj5Lx0E0Qqr
	h+mFlBMv4c+GA3DKqa1wBOQ5iaFmzb8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-702kZEQQOm2gfcaUtWd0xw-1; Wed, 05 Aug 2026 02:08:31 -0400
X-MC-Unique: 702kZEQQOm2gfcaUtWd0xw-1
X-Mimecast-MFC-AGG-ID: 702kZEQQOm2gfcaUtWd0xw_1785910110
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f810c8aebso296884f8f.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 23:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785910110; x=1786514910;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W0Sm6aitHsc62gyEgQg2/9qpXlfx9wA/VX2KIRUAVSU=;
        b=qA6cdODzYvLRpmPM8EI0MAmDFpmh9kFAaFoQfEQ0yMBf9zn4mWSPQf/YCztsOaS0S5
         NEXPULI+27L+w7FiIojEC78YXCUxJl6uLUV9F79YbXMrnnd1T4NI3mHEH9VN9daKE315
         Jd3gu6cKOvs+FPjUjnd1FpyJgqLZvpVV6ZlmE1ETlP2lE/Y1kDdC9dz7pmji4oNZvwny
         TsH0ziOH0Bc57bZGqdSxc1XMq+Crktwz2isI6qwc08vg8uq0GLyb+mEK1MgbY2PeHlch
         FahUsv+0jvaIvVTWi+mgMA0CHQpa8D+gkc6xFkGnWRZiAJMjJg7iDc76Tr8IfvmfNcz2
         JCSQ==
X-Forwarded-Encrypted: i=1; AHgh+RrDEVu/jKIpdn3zFXxhf6NUlRvbEEARhz6m0X0gqntq1URZf7UFIV4gBzwz/cCFe3u4M+RTCOT0ag==@kvack.org
X-Gm-Message-State: AOJu0YwlYpUpHAdaxwhNbwOjOCtthXJGzqtUjzk8vJQQsDkJHLS1USP9
	o+1nWPnrroqa8Ibsq1h/dhEN8aaMqRJCzOFd6wuheH/8ch0qUPATrKpYAtwMNG0F1iLSQgNOjjX
	r152SVLqlXbLlRQgzI2OiE0irZUsR1baP9kDmjgfGF2G+j4oVHHZBAE3Q1TfNbok6TOzoNP3TJy
	bxaQe7pyo9ZXbjWgAvavuKKZhBbfc=
X-Gm-Gg: AR+sD1015a0CenA3zJ/jTmA/1spQonItIMtI04aAuQ7OQ6O4rd5ffywm1rLnyThCtwg
	hHpx8LwsKyydGu4+6G65BwQnzFjGZGh84iaXpiJ1VmJF5uvEwmRPDPSIUl81KzzcRi1D6XvQI8k
	ngA6bC8ryv2yJ3pReVK4tY2SUXawr57XbcTWrHTkUbATsHD7VWmJ2nKEbPjxmfb4UyGJgewNauS
	vP5p7DTB2HZgktrxSxrCp6XQSngOYLavsdFMnyptCPfyZbthb/NIRmF8SY=
X-Received: by 2002:adf:e012:0:20b0:47f:753c:5393 with SMTP id ffacd0b85a97d-47fec4e888cmr5402595f8f.6.1785910109885;
        Tue, 04 Aug 2026 23:08:29 -0700 (PDT)
X-Received: by 2002:adf:e012:0:20b0:47f:753c:5393 with SMTP id
 ffacd0b85a97d-47fec4e888cmr5402532f8f.6.1785910109519; Tue, 04 Aug 2026
 23:08:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260804120529.1730187-1-pbonzini@redhat.com> <20260804120529.1730187-3-pbonzini@redhat.com>
 <20260804161549.4cd9a66f@fedora-21.home> <20260804161850.58c55c6e@fedora-21.home>
 <CABgObfbAveuhkjXzmemvGtycmcmDePKABr8Q35Y9mZP0den5aA@mail.gmail.com> <20260804164206.655874ce@fedora-21.home>
In-Reply-To: <20260804164206.655874ce@fedora-21.home>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 5 Aug 2026 08:08:17 +0200
X-Gm-Features: AUfX_mzo9t9ubVXz5xpYzVx4R9t4U8bdls__QKfQW65v6eCkMtC4FUkJ5hgXDI8
Message-ID: <CABgObfY67mdG9QZ5__Q9GDrEq9Wutc42_tHo8YGSMOPnruZmsg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] drm/shmem_helper: use vmf_insert_pfn_mkwrite()
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Alex Williamson <alex@shazbot.org>, bcm-kernel-feedback-list@broadcom.com, 
	Christian Koenig <christian.koenig@amd.com>, David Hildenbrand <david@kernel.org>, 
	dri-devel@lists.freedesktop.org, Fei Li <fei1.li@intel.com>, 
	Huang Rui <ray.huang@amd.com>, linux-mm@kvack.org, linux-s390@vger.kernel.org, 
	Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, Sergio Lopez <slp@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EdIVD9y-Zo43QprPzLWU1ZzfoiGgX01xXB_rLXCXepg_1785910110
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 758D340007
X-Stat-Signature: zm6ucbn5z1brxrrcm3hfr6k6uga7a7nq
X-Rspam-User: 
X-HE-Tag: 1785910113-154310
X-HE-Meta: U2FsdGVkX18M4TD9TYBBE12+4i6KK67nkSSjLDAe4atyeXFeK0DMcI3xM7n04ddH1xfa0i5c/uQW0Sl48Kmr7SBjIQOzg0HjIpVKXv/ccQRt7ehtdeOGepFpKxydGCLMfvaoGD9NQ4k4C9xB/ziVeKNZVE4RN0kdySjyx+vK5C+jW2BLHsnK+7ZNOkL+xaZlZwwWqEokV3+J/QsO1RdE4g0vpSDuO9B9Y50tRg7bEwdJJvaGWK+IeYImxzjNyGGcTAwYqkCEuouavVhTi3fxxgLcUzHTb9PuJ/vOc8mhKumuoLueWtalLAWVsY9nDZXiVS6HMIuVVT98s8PhpQ9kai0LsjAz+7j4ZG+c8tnzcuTiuHUQpACcJEjluP63crY/cjhyWEBkl5w/IaI8180kI1BctmcvfmN7l34w99lj9EX4eA9PT3Ssi/H5ykOrH7Stdzrz8a/ip9JyfljQGcpqGzOukk5KGo0FFf9pB7kSRWjaJD48QLEgUbhw6mrGeTkbfxCK1mzX2qPgcEGQRxffxU6QCMz2tiRoiwD3Ow2KEvbAnZ4sqB++TpRcssaNwnx32DyHVmEZ7/XNQoY3RfLZo3IAPrGHO2qIJuXZcS0yWQOU+UdG4KiStgJ3UpbeBcJXt9QWhCeoeg9sHg3sYQii4nLBYhCZExMVg3Ngjbh1XETf1c9iYO+hcxR2vIDhqbSZvX7jWWU7DeT0XLWTj2DW2bD/s2rfFO+2uPSECiU+A5brHHw1Z03I65GNISeg4HI7RzfdcGNDE2sHK1+/MRUrEcMfAmO9W4RNozpbjKM/Abxl5b5UeYEuLlNfyYf4uIsELx9LIFlnoyEUoUdFU4Z7ipgc6+ZHge/cQLUhXC+UelkUOy87D2Ud0NbJAoo9r/OE3N5WQQ6wNIiGy2krhr9zpaSaTOM4hyq3SJIIXDVJOgTak2psGwEhY5yY5BLgjegF0+WKvOWzDSZNVLuQSFQ
 ANvy5OKE
 d0244oFFEM0jSX3aafZRH7Rqh31vxiKQeCwytF2YNCAnkeWr6T7is6+qBiJP7c/ByejSFThhmhWfwHyee2q2ZrXNLRD5up+IXHkvClxf7MOCuy6QDZREXbKGYdclJyJ1LnlWMJZTuWwMobozT0mWTE82kN2gPNSSAGrCdBSNhxQms63PDeNa2zBt1YvwiwyPB2N8DyfU5qss9UP3YeZVacp4kUVoQFfjNm/6gpB8cVh59UmH5rz/1Izk5nVwFUk5YL0NYlfa1K3xzLrgJybgXY0yiDFCzXN4Mc6/dgX88xK4mUsJFh/65zwAkrY4C8ih9akHuCE7ufQ4q2t/P5FMsQd2ji4eJSzZc5V81HTe/ifJ0DyhuAgQEdiPSYXAkV78qSh1E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 4:42=E2=80=AFPM Boris Brezillon
<boris.brezillon@collabora.com> wrote:
> Okay, I thought I'd ask to be sure, because of all the implementations
> of pfn_mkwrite listed here [1], only drm_gem_shmem_helper.c and
> kernel/events/core.c do that.

Also the vmwgfx one in patch 3; and for the !DAX case ext4 and XFS too
(e.g. xfs_filemap_pfn_mkwrite gets to iomap_page_mkwrite, not to
filemap_fault).

> The rest have their "generic" fault
> handler (by generic I mean a fault handler helper that covers all the
> order/WRITE_FLAG combinations) called from pfn_mkwrite(), and return a
> non-zero vm_fault_t.

I see; I think you can do that, it is handled at
https://elixir.bootlin.com/linux/v7.2-rc5/source/mm/memory.c#L2681 and
indeed it returns VM_FAULT_NOPAGE. But it's more or work for no real
reason. Your .pfn_mkwrite is a single line of code and it is clearer
IMO if you can see that try_insert_pfn() is calling the same helper as
.pfn_mkwrite().

Paolo


