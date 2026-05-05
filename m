Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A931CD343B
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 18:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611AE6B0005; Tue,  5 May 2026 14:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9406B0088; Tue,  5 May 2026 14:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF116B0092; Tue,  5 May 2026 14:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EEBC6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:48:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEC5FC17EE
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:48:08 +0000 (UTC)
X-FDA: 84734251056.20.C2C254F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id BA6BC180006
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:48:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YhmH3Eid;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778006886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZD1WNE1k/WmJPg25LWZyiq7MLw0O15fr/MzhzoxqC8A=;
	b=B94hcuUBFWJP6/qFPvBl9nvMl1i0xb/S9X0rvqa7ricvHJ/qODPm2RcWxQBQ40Axy9qtI9
	g2qS0es+h8scbk6374bd8Bli7a82P1l6f61mPsGx5U2i8HdAE6ZhiJ5sWEMzxj6Ok9hs1C
	oKUWIJ9jdd26Eg/KvCwUNc75W92/uoY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YhmH3Eid;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778006886; a=rsa-sha256;
	cv=none;
	b=rwhewrQA6O4ZpYUd3VJmRrYdO8+6MwyFTdRrTOuIucYAkpd9scKO53RkZsYolMrYx07PVZ
	7UKxPZThnuLYxyWxHO3jcJLzaYqiPseAwRR0+tKnvm/itHQScnXu9g84Aq+QBhyE1ez5hH
	gZnu2C7dcQKG5yHl4XVXgM8MI3gYkIU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778006886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZD1WNE1k/WmJPg25LWZyiq7MLw0O15fr/MzhzoxqC8A=;
	b=YhmH3Eidi3aufJ3TvORGcUJsDe5DclQkrBRz49q3URbeN5ZtdFRdirQKknlsy6A354ShlH
	HFzuu6W/R95sUHzBeZbuC1xZZ3ajvqd2mBTjP+FGzXNT9uBYjGSuX3F/UTlNloXltFuL4d
	4CMOIUzruR0ukyicoedZeSMnMI1wVh4=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-OMPvWBOxPCyTs9k9iGGnfA-1; Tue, 05 May 2026 14:48:01 -0400
X-MC-Unique: OMPvWBOxPCyTs9k9iGGnfA-1
X-Mimecast-MFC-AGG-ID: OMPvWBOxPCyTs9k9iGGnfA_1778006880
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-38a1f798464so16497951fa.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 11:48:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778006880; x=1778611680;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C1bqbiEVoTmEPJHjXzHnukQrIZ297oQVbCi2us/0k/k=;
        b=aagYwZdaU/SkJSbGPwnriv+u1XPCYOQ+E1A+pC8J71D4HgC4UagZcNizDauJRpQIDI
         iul4BAFYfMEPldNEHzA1A99EcuvcCZC6MbS2FKzKtcFZLsMlVOQ8t3xakvMn8V3PtJ/a
         B6bdOjlYUosM19TLfN3F9xqWy4wySc7Y+CoabZjv4E9iulGYFuDDWyyCtqkAWgGJwKwL
         GSEMRYz/GRAqAzPI/Iy3EWQmXEHLDn3bgIfEdULAJBVKfAXTfkWaSVpLhBuBUCT80mHw
         7j+0QhkHBjzSbMrSMteyxjiIikyGpblrZ9mNkXz6L+iZk2kF8byNEXC2ouIxqTpP90bC
         iylA==
X-Forwarded-Encrypted: i=1; AFNElJ/gBncCel/U2gDMXXCu2CJAyCensEFyoI/0/qGSaYUPEFA9fkVxhwGKxmMuCPBoi9cYtZgT3Ltw+g==@kvack.org
X-Gm-Message-State: AOJu0YzliQwFgPStK1NDq6HjW1/ZyJhfAHquV9x8QV+9iWO8AUf41JYR
	7B9fZ7tuyaMoueS+UFTuDHiIcdYJPNjz+PGM8CRcgJLqBf6YrDw4iuqGQnhPf08h1gRohlr7HaI
	5P2MXZ4quGxjOLAfmIryDuXxlO8S8yb50EvV9wfxTklm4Gzj+W1I=
X-Gm-Gg: AeBDies1hCpWdd30bl0MzYNALGKbi8vPmmiViD3PYs6W2SQDrYGO01tuWDrJTFbapCH
	GMXFRLqNW4NDmL5yfqmL8HqTorvb8G4Il/O6zFgwsgGytJnD2CEARxu7RA2Y7cirJf6dxbqZ8mT
	LgpExKF5v844E3S/Skxr1tRIdbUv6Qz1FuKvTM83wUoB5RSC4t0glJdrxZPWuXloafqfm1TO4hr
	AlVQvDfLiPXmKa7QXrt8wbuK5KHU6Pia6bNzaL6OT1go2DI8P4fB6GL0+SRH1uj/CpS2P+dRBPn
	RHX/WkGiRVEbTdXsNCJnfY+Eyl/kfz7TrRoEIHBqRQNJQkz4Y4YXcox/ey3Zmmi3phU6hwVb7Yq
	qR2bmtSx9u2f/mZiIcvxMWdpz6RuIHe2W05H4/EFwG3845K8ZclKZd77UlA==
X-Received: by 2002:a2e:864e:0:b0:38e:2fcc:78fe with SMTP id 38308e7fff4ca-393c40bcb5cmr1627361fa.3.1778006880093;
        Tue, 05 May 2026 11:48:00 -0700 (PDT)
X-Received: by 2002:a2e:864e:0:b0:38e:2fcc:78fe with SMTP id 38308e7fff4ca-393c40bcb5cmr1627151fa.3.1778006879554;
        Tue, 05 May 2026 11:47:59 -0700 (PDT)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-393610ba631sm44569421fa.12.2026.05.05.11.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 11:47:59 -0700 (PDT)
Message-ID: <433d0729-b141-4f19-a0c3-656f033e8ea1@redhat.com>
Date: Tue, 5 May 2026 21:47:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/5] Migrate on fault for device pages
To: Matthew Brost <matthew.brost@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260505051658.2219537-1-mpenttil@redhat.com>
 <afmXIq8VY_vs1GPo@nvdebian.thelocal>
 <ecd81b6b-62ef-4dab-a93e-e65598d64841@redhat.com>
 <afowaUffi0JrnADf@gsse-cloud1.jf.intel.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <afowaUffi0JrnADf@gsse-cloud1.jf.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jW79ruUZ6spherNLhmBFhbr_qhb5F6GHglCfARLEDeQ_1778006880
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA6BC180006
X-Rspam-User: 
X-Stat-Signature: oqr8igrfz9tg6mbcsth1hmrb9ftsgx41
X-HE-Tag: 1778006886-854138
X-HE-Meta: U2FsdGVkX19PsFkxKQny/+5PIHcvn37xpedY5SAO2HKx8BiwdSrWuDpg1YTw5gYUzYrY1YBNEHJZ3dGdCrCEeiNlnhFGaYJczrR2wE+lkSIijzdQtVnvuj9CKQOy5vWFt82bmQ8BhENC6VJ4ZThd70iWXGEXBlGoPA+CrB6/fiXTJV8xfozFaiKiX2repls7dO+x6i5AhV+8VzKKejhz51ebjEJb9YxBaqRyiNu7JdYFDxplahWx4BftHAUBwMaUkWK2RNEY3WWoYINuwTvqp9kRWpFdiFzHzAbhY+3fowhoQptJpSvm5buUejqpuoqu6bPS6+z+UdrAb6/wXlTAUFYWICF+oLJfFkR4mL0cOpz5LMEq1oYpnr3+pR+IneWepYFenmSESIb7uKXASYGCdd8gchnBtZVv9MakWe0R3C6nZYRgqL0gVTp/algLoEfOLGi/KFDjWgp2aT49BZXEKCOgtyG3y3dXr/iU/elpSepRuM0WXoiWnrBdSTuhKfpgLIVqpDihMxwUduo1Pfl0SBHDBZ4RBj/TRtpRqD+rSLjkpb/IIhPexFcb/cVUr4kvf7+BKAKql3A12rVfWjZaxa+essEV7YEiuSwh9uYSPbzfIB8HIYTnFsAior/zeq/X5PNN+sVmP689qs2B0RFeWjNFh87VR3ghbtIFirWlczCzDhLk5nmzL2fRjWzmSOSMc8RPvtM+wDpVMT+nox7+8V4bdCklEEzQnIpUeyxjlCHqkx4ZUe24zMF7ZQ/4e8u/LxnkEWw4fMRxoNS65VoktC+cKP47gMrw0uJoEcIfrNvwcJh7b9p158O1OxMrTq+9+ydIWUUfjyrfvwLL42VAjo813w+U2Oty4/E9f0DoEc+xs9JCEmWLd4SBgtsiCtgNVdbomnKJy8zmrdvNcDc6hGecQUd5QXVIvFZ8iHLfYBMvhxWYzCy+GAGJyQP4GFY1zyqlDdtqxIMioatwyPM
 tysQ5NGN
 nI5fizV8HckFcGffmKeeL9wCF90LOvkLy0aJOMlpulH+TalCGKGSWVQBNkAaB+m1i1DkWZbk53X/sNZfJnyMJaRs59VNERO5KyjQaeFbV42//xpf7KSmhNkn3I+RxNjrdq7J0V3z8ogyXqyz5KEMBpwExRDj7cjuDyJ5G/biscF3OonB2TtMK5IohF414SGc2yJO8XQha2T8uMTxhF1/mCIDhtFcuJoHiHPfyzmk0Q0BsVjpepjzLrA5PxCDOMXnrxIe8RIM6PTPcRd/TmUxsGdcYfUm6HZ4udHdsftVwHDYuYqLDouVjyUVCNwVvKu4wltUiK8CqUll3a1BeZKPDjMKrqhU2E4pWbNa0Ohovqp5I5ckUGqRABDOQ/sFm4Dl7gqmEnvJwJlut4wmFA5224KyQ90r8Ab1As/6mFruPs3B5jAxunhrXu4+KoNgJcL/rZB9xwewcpsPeVeVvfkeIhuBtqYG2wH+z2OUnGRa+cb1Xfx3pKSvoBgDbGbrIgKXbUusr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/5/26 21:01, Matthew Brost wrote:

> On Tue, May 05, 2026 at 10:18:14AM +0300, Mika Penttil=C3=A4 wrote:
>> On 5/5/26 10:09, Alistair Popple wrote:
>>
>>> Thanks for doing this work Mika. I've been meaning to take a look at th=
is series
>>> for a while. I'm currently at LSFMM but will try and take a look this w=
eek or
>>> next as it sounds quite useful.
>>>
>>>  - Alistair
>> Thanks Alistair and no problem, appreciate your insights whenever you ha=
ve time.
>>
> It looks like this series is breaking Intel's CI [1]. Looks like
> something in RCU is blowing up:
>
> <4> [212.361418] ------------[ cut here ]------------
> <4> [212.361431] Voluntary context switch within RCU read-side critical s=
ection!
> <4> [212.361432] WARNING: kernel/rcu/tree_plugin.h:332 at rcu_note_contex=
t_switch+0x82/0x780, CPU#11: kworker/u65:5/2352
> <4> [212.361440] Modules linked in: snd_hda_codec_intelhdmi snd_hda_codec=
_hdmi mei_lb mei_gsc_proxy mtd_intel_dg mei_gsc xe drm_gpuvm drm_gpusvm_hel=
per drm_buddy gpu_sched drm_ttm_helper ttm drm_suballoc_helper drm_exec drm=
_display_helper cec rc_core drm_kunit_helpers i2c_algo_bit kunit overlay in=
tel_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequenc=
y_common intel_tcc_cooling x86_pkg_temp_thermal intel_powerclamp hid_generi=
c coretemp eeepc_wmi cmdlinepart asus_wmi binfmt_misc sparse_keymap spi_nor=
 mei_hdcp mei_pxp mtd wmi_bmof kvm_intel kvm irqbypass aesni_intel gf128mul=
 r8169 usbhid rapl hid intel_cstate realtek snd_hda_intel phy_package snd_i=
ntel_dspcfg intel_pmc_core snd_hda_codec idma64 nls_iso8859_1 pmt_telemetry=
 snd_hda_core video snd_hwdep pmt_discovery snd_pcm i2c_i801 pinctrl_alderl=
ake pmt_class snd_timer i2c_mux intel_pmc_ssram_telemetry acpi_tad acpi_pad=
 mei_me snd i2c_smbus spi_intel_pci soundcore mei spi_intel wmi intel_vsec =
dm_multipath msr nvme_fabrics fuse efi_pstore nfnetlink autofs4
> <4> [212.361711] CPU: 11 UID: 0 PID: 2352 Comm: kworker/u65:5 Tainted: G =
S   U              7.1.0-rc2-lgci-xe-xe-pw-165953v1-debug+ #1 PREEMPT(lazy)=
=20
> <4> [212.361715] Tainted: [S]=3DCPU_OUT_OF_SPEC, [U]=3DUSER
> <4> [212.361716] Hardware name: ASUS System Product Name/PRIME Z790-P WIF=
I, BIOS 0812 02/24/2023
> <4> [212.361718] Workqueue: xe_page_fault_work_queue xe_pagefault_queue_w=
ork [xe]
> <4> [212.361833] RIP: 0010:rcu_note_context_switch+0x82/0x780
> <4> [212.361838] Code: 45 85 c0 74 0f 65 8b 05 24 84 ab 02 85 c0 0f 84 8d=
 01 00 00 45 84 ed 75 16 8b 83 bc 08 00 00 85 c0 7e 0c 48 8d 3d de ad 4d 02=
 <67> 48 0f b9 3a 8b 83 bc 08 00 00 85 c0 7e 0d 80 bb c0 08 00 00 00
> <4> [212.361840] RSP: 0018:ffffc9000186f4a0 EFLAGS: 00010002
> <4> [212.361843] RAX: 0000000000000001 RBX: ffff88810a3a8040 RCX: 0000000=
000000000
> <4> [212.361845] RDX: 0000000000000000 RSI: 0000000000000000 RDI: fffffff=
f839bcea0
> <4> [212.361846] RBP: ffffc9000186f4e8 R08: 0000000000000001 R09: 0000000=
000000000
> <4> [212.361848] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888=
85f1b6a00
> <4> [212.361849] R13: 0000000000000000 R14: ffffffff83248312 R15: ffffc90=
00186f630
> <4> [212.361851] FS:  0000000000000000(0000) GS:ffff8888db203000(0000) kn=
lGS:0000000000000000
> <4> [212.361853] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4> [212.361854] CR2: 00007fe433b2f088 CR3: 000000000344a000 CR4: 0000000=
000f52ef0
> <4> [212.361856] PKRU: 55555554
> <4> [212.361858] Call Trace:
> <4> [212.361859]  <TASK>
> <4> [212.361862]  ? lock_is_held_type+0xa3/0x130
> <4> [212.361868]  __schedule+0x103/0x1f70
> <4> [212.361870]  ? lock_acquire+0xc4/0x300
> <4> [212.361874]  ? find_held_lock+0x31/0x90
> <4> [212.361877]  ? schedule+0x10e/0x180
> <4> [212.361880]  ? lock_release+0xd0/0x2b0
> <4> [212.361885]  schedule+0x3a/0x180
> <4> [212.361888]  io_schedule+0x4c/0x80
> <4> [212.361890]  ? softleaf_entry_wait_on_locked+0x147/0x2b0
> <4> [212.361894]  softleaf_entry_wait_on_locked+0x24f/0x2b0
> <4> [212.361899]  ? __pfx_wake_page_function+0x10/0x10
> <4> [212.361904]  migration_entry_wait+0xff/0x190
> <4> [212.361909]  hmm_vma_handle_pte+0x440/0x790
> <4> [212.361914]  hmm_vma_walk_pmd+0x5c8/0x1360
> <4> [212.361918]  ? xe_pagefault_queue_work+0x1a9/0x520 [xe]
> <4> [212.362015]  walk_pgd_range+0x57f/0xd70
> <4> [212.362017]  ? lock_is_held_type+0xa3/0x130
> <4> [212.362028]  __walk_page_range+0x8e/0x290
> <4> [212.362034]  walk_page_range_mm_unsafe+0x19e/0x270
> <4> [212.362036]  ? trace_hardirqs_on+0x22/0xf0
> <4> [212.362043]  walk_page_range+0x2a/0x40
> <4> [212.362045]  hmm_range_fault+0x94/0x190
> <4> [212.362053]  drm_gpusvm_get_pages+0x269/0xa30 [drm_gpusvm_helper]
> <4> [212.362067]  drm_gpusvm_range_get_pages+0x2e/0x50 [drm_gpusvm_helper=
]
> <4> [212.362071]  __xe_svm_handle_pagefault+0x3e0/0xef0 [xe]
> <4> [212.362181]  ? __lock_acquire+0x43e/0x2790
> <4> [212.362188]  ? lock_is_held_type+0xa3/0x130
> <4> [212.362193]  ? lock_is_held_type+0xa3/0x130
> <4> [212.362197]  ? xe_vm_find_overlapping_vma+0x57/0x1e0 [xe]
> <4> [212.362304]  xe_svm_handle_pagefault+0x3d/0xb0 [xe]
> <4> [212.362412]  xe_pagefault_queue_work+0x1a9/0x520 [xe]
> <4> [212.362509]  process_one_work+0x239/0x740
> <4> [212.362518]  worker_thread+0x200/0x3f0
> <4> [212.362521]  ? __pfx_worker_thread+0x10/0x10
> <4> [212.362524]  kthread+0x10d/0x150
> <4> [212.362527]  ? __pfx_kthread+0x10/0x10
> <4> [212.362530]  ret_from_fork+0x3bd/0x470
> <4> [212.362533]  ? __pfx_kthread+0x10/0x10
> <4> [212.362536]  ret_from_fork_asm+0x1a/0x30
> <4> [212.362546]  </TASK>
> <4> [212.362547] irq event stamp: 2057044
>
> I=E2=80=99ll be out this Thursday for five weeks, but assuming you can so=
rt this
> part out, I=E2=80=99m fine with the series moving forward. I=E2=80=99ve l=
ooked at this
> several times, and it seems sane enough to me.
>
> On our list we also have the Sashiko setup [2], which I=E2=80=99ve found =
to be
> incredibly helpful for series that do deep MM work. I=E2=80=99m not sure =
why
> Sashiko is saying this series didn=E2=80=99t apply, since it applied clea=
nly to
> our CI branches. If you can get Sashiko to run on it, that might be
> helpful as well.
>
> Matt

Yes there seemed to be a missing pte_unmap() before migration_entry_wait().=
.. fixed and sent v10.

--Mika


>
> [1] https://intel-gfx-ci.01.org/tree/intel-xe/xe-pw-165953v1/shard-bmg-4/=
igt@xe_exec_system_allocator@process-many-stride-mmap-race-nomemset.html
> [2] https://sashiko.dev/#/patchset/20260505051658.2219537-1-mpenttil%40re=
dhat.com
>
>


