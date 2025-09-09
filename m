Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDA10CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571288E0008; Mon,  8 Sep 2025 22:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5212F8E0001; Mon,  8 Sep 2025 22:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410958E0008; Mon,  8 Sep 2025 22:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2728E8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:17:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D420685E8F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:17:36 +0000 (UTC)
X-FDA: 83868100512.08.B3F6759
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7045EA0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:17:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RJFrSREz;
	spf=pass (imf25.hostedemail.com: domain of czhong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=czhong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757384254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZ+4tt+rn9s8rPGeKJnpPs6noZbHF7XcRHYsTojayAw=;
	b=BgXKobMGaxwj2l/8u6bLtEvbb44pPO1udqRP3+1uYsX02z4ZmMjKpuj5O4wlBhfuTwzT9a
	ahhzRIXx8bOrzQk9QncbueYLnVGutHo/gtBNeIe3aIfyAc50NTtgbCBDVHd5b2bh7qNhuQ
	jbii8Hqy+rF6H/bpOVMhWG5E8zCyCg0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757384254; a=rsa-sha256;
	cv=none;
	b=vLA6565HOs4d+XjaUbl6cfS7WlfJYsaiin3jqMOhPy3CV6XeFkbAugw3v6K840IMAkw4Dz
	WP3C01lkbEniAuPGR0q2eZYKj/R4ezU1yF2ZdA2WB5k1ic/+b9Cnam1fkZsCZrOrYPsQC2
	7gbjulmOkarv3iYDNprl1dcUfnf3iik=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RJFrSREz;
	spf=pass (imf25.hostedemail.com: domain of czhong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=czhong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757384253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZ+4tt+rn9s8rPGeKJnpPs6noZbHF7XcRHYsTojayAw=;
	b=RJFrSREz7VzcmTB61or4aXeTtF8gd2HOowBJcfg524uoGVIO5pEV66YITHO8yFn5ildm8W
	w2qCbDO6eBMPw0EIeQSPzzSkpW9kLgI5U31LXHFh0YP0b+Ydh0on9Rxw5WziVGALShnBf9
	SgCQYACOyvztuexTbCLWewz4sKzCSkk=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-Ro3_PmClO7WhUEdN1USwdg-1; Mon, 08 Sep 2025 22:17:31 -0400
X-MC-Unique: Ro3_PmClO7WhUEdN1USwdg-1
X-Mimecast-MFC-AGG-ID: Ro3_PmClO7WhUEdN1USwdg_1757384250
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2490768ee5fso40475585ad.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 19:17:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757384250; x=1757989050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MZ+4tt+rn9s8rPGeKJnpPs6noZbHF7XcRHYsTojayAw=;
        b=an1ggVZY6qb0zERg07Xn2mNH4ej19iAbbEp723OY/trV+6R+ZbftYLJHZmJvI6ODv+
         erhdHbQQYMswzzdvGI2k5mPQ5YN2bO0SdkeSDW6MB6NdbAWrDpgQe9Tmwl1dmJRvOqhz
         hAOlmafhv9Zfit7qKS0TzHYCVsinlI3lDVP4ZcaBtKZQcePalI0cbvGFJdCioxCBLKdz
         QHgLAetMICoilH9AcFuDFDgv/+zcnlM+yr17KTo24oPy7YuixISntpooN42badJ5jPs5
         QmKjrvk3jcQsjJg7aMuz48Vca5xtkok4iiUIrjbusvFeLG8BV1njge9sUJdcrU2W7/eL
         /M9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXc9Qtj4O6+qvvECEG9oWyY7Bkh8PsCyoJEwIaFJkCmv+9JaidvbUf1sFakO5AGKNpyNdAJ5OJmFg==@kvack.org
X-Gm-Message-State: AOJu0YzwWLrk1N5HkJrU2jOKrxpGxv6zYW1JDnqQR9PWZuxr2A5R0qW+
	qZ10fd2sAa750ElEb9NC4NEMqLrH7oDGLEMrvmHq46yTAojaZklEMeN3Laf2nou86DCDQBEKjxn
	Xr0W0OVopog4sCboWdj95JvpZqlIWVidfEXdFcQzJkBPBrV9zwHlMleJ17eWoJhWOw0Nm1XTjgx
	WMPKQpQI4K5vTRIPWCpTYalpO16+7jDWpTVcY119dYW0c=
X-Gm-Gg: ASbGncvQDqnA4KK9yHD3aY0Kn9Bf/Qtl0GGhQj45b7OcaC2NpxWPtT3xmuNsX0HP+8D
	DzjS3su/Z3DgTPuQAZ6QNj/SNNgCZrGc2ofw09b976QFZtfPcE+4AWDhiGJZkdXKDrQ5q45IrX4
	mMcrne3pNC3U4DwbvpVt+Nfw==
X-Received: by 2002:a17:902:f681:b0:250:74b2:a840 with SMTP id d9443c01a7336-25172483a34mr143564225ad.44.1757384249950;
        Mon, 08 Sep 2025 19:17:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFnBZ4kdc1eBvmuyAIpX/Cbpp1/H4HLDp9Gaw88uIZmil51sy2aZ4R3CoEMvDFZw7RAg4s2rAyhi8SyrbSVWI=
X-Received: by 2002:a17:902:f681:b0:250:74b2:a840 with SMTP id
 d9443c01a7336-25172483a34mr143563975ad.44.1757384249435; Mon, 08 Sep 2025
 19:17:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAGVVp+UtpGoW5WEdEU7uVTtsSCjPN=ksN6EcvyypAtFDOUf30A@mail.gmail.com>
 <CAGVVp+U7Sx+pf5ChXHhyWzT_WuyuOKsEtebo8_GjDkut5a0gXg@mail.gmail.com>
In-Reply-To: <CAGVVp+U7Sx+pf5ChXHhyWzT_WuyuOKsEtebo8_GjDkut5a0gXg@mail.gmail.com>
From: Changhui Zhong <czhong@redhat.com>
Date: Tue, 9 Sep 2025 10:17:17 +0800
X-Gm-Features: AS18NWB2_Jtz1fTcK6-ZkjZ5CK6mCAZo15L5_xenZJVz3bV-JyPzVzLMufgi1S0
Message-ID: <CAGVVp+WN0YvN182wCxTWVY19YQGmUJbDS8t3gOZ-=R8+rEfrhw@mail.gmail.com>
Subject: Re: [bug report] BUG zs_handle-zram0 (Tainted: G S ): Objects
 remaining on __kmem_cache_shutdown()
To: Linux Block Devices <linux-block@vger.kernel.org>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _rPoQnbgRawlJjqkFnS45BtMt5vS3ah4369Bcti5aNU_1757384250
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4fmwu1e6rkne4ziems3n11eazsf3dtdu
X-Rspam-User: 
X-Rspamd-Queue-Id: 7045EA0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757384254-197374
X-HE-Meta: U2FsdGVkX1+nTYVShbLfK2NV13Q35R+X5QCh1cx1hzM6wXvsRj0Br2hZ+4kiv73x/cC2jPsPxTIWBSBgmEei/8Nl/4vi/rZxaZoT6uTPGJmVG1qLzAJAfLJiVglfDVDMhw/Gnu3hqYjaonvEiq4q9t8IOs0TmETDad4mKPds/mWUIFFbBL8O5VlV6dxB/J+if0M95V3Z8YTyRauCbF0j0YY3OrX0fE+wsoWzLor0nLY1HUyd3sS6KfHC8nuPdoxrLS8Drfpkk/1Re1ydsMTzvBGgxm/GcdufMuw4WLVMybHB1LKCKHdqgPz0/Wa35WO/li13lCeBturZc5gdYiAOcFpn+WawVNKCcSfOGrX2SWuFFEG46Z5DD4D4HRTqrTgANwSxkVj5X60fZfc/LTJKgf+xIoPDGXaU52RrhcQRj74Yktxgxc5xcsCorF1npmHHSGKKiUJbb5McJ3VndwyFdv6xV6yMwSWIqqsJdLuohClcSXw76Q9vEuChcBhuWPrfwDXbzfoYAp8iajMncPkqPxQliwFZTYPLffiuwO82793Xcz7jkxHYuf7k5W6wG0bV4vztsCKIqzzsEIM2D7PAow/afNaUZNiGZYiM2k07oJh8CUw/vPjbjDeMjfVe4HdACujvxvR84UVbu1Og2P1BgyP4Dd1VPQSzGVAebgyRkFI+ySiofzkzbD2YuJDySxDGxVwiHy6Gj3LXqfHfZ2iKfvLSzvQ6Jj5Mvc+lhxErEeOVL1cpZdckkG7cq/e8tY3tQhOqnnjHSjD4S2YmFrnkkJMyOcKQKW3KN8QEAmekUarxB89VDdNg6+2KdVDewSYIXS4FsjC/GkldFWXLrNhKV00SGWZqjxBUhc9ecVtOPYLb/YudgKFoL3wAQEnoolHFfhpSXSrpYHY9ZFc+eXd4Br4N3KTYzNrv4SBBkgyJSRk5xRLc/zWTTpsI3v8YbaDsSOSdYiPnO4VnLTCLrzm
 xcDhRqwZ
 V56BiMk45w7PKgokb/O75qtAmfzDgkMY/2uLsCQZ2Qrrrt6QSXgNbAmYQLruy8s/SwZdYqIops8P4zUBFs9ZbvsEBA6o8HtQmx+yWH6ThEL5TfOYwdN5AwgcxDxG0ENgPqY0XcSLsfX/nNtfQKQgvvMxurzgH0WjBTe5lODEML1RYVLRSZJfUpkQXRs9u83lZASEGkzu4AHs/WlL/y3rk9Eyg0FtNn7GIhGK4YmLQQDB/ShiXsqC5mvTGbjV23JEDO/nPRREWJlrt+AFr06XbTxM2FYH71HeFyewN8aNc5iovTyxryxhbOLKsPcKjO96Mh/1m/cQDeV/MK+hYodfasz8ScZ3GLKoF5iRd9snrO6nR3vWX9Gi1PlWKUAfl1dYnwv9+jCn6YJDpM4T31W0wtK8AWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I still see this issue on v6.17.0-rc5, please take a look if you have a cha=
nce

[ 6915.287305] BUG zs_handle-zram0 (Tainted: G S                 ):
Objects remaining on __kmem_cache_shutdown()
[ 6915.298379] ------------------------------------------------------------=
-----------------
[ 6915.298379]
[ 6915.309166] Object 0x0000000023ce3ee6 @offset=3D960
[ 6915.314421] Slab 0x00000000913eaa62 objects=3D128 used=3D1
fp=3D0x0000000064bf6df4
flags=3D0x17ffffc0000200(workingset|node=3D0|zone=3D2|lastcpupid=3D0x1fffff=
)
[ 6915.329002] ------------[ cut here ]------------
[ 6915.334159] WARNING: CPU: 2 PID: 7198 at mm/slub.c:1176
__slab_err.part.0+0x19/0x20
[ 6915.342713] Modules linked in: zram 842_decompress lz4hc_compress
842_compress lz4_compress zstd_compress tls rpcsec_gss_krb5
auth_rpcgss nfsv4 dns_resolver nfs lockd grace nfs_localio netfs
intel_rapl_msr intel_rapl_common intel_uncore_frequency
intel_uncore_frequency_common i10nm_edac skx_edac_common nfit
libnvdimm x86_pkg_temp_thermal intel_powerclamp rfkill coretemp
kvm_intel kvm dax_hmem cxl_acpi cxl_port irqbypass cxl_core iTCO_wdt
cdc_ether rapl iTCO_vendor_support usbnet intel_cstate mii
intel_uncore mgag200 intel_th_gth isst_if_mbox_pci einj i2c_i801
i2c_algo_bit isst_if_mmio pcspkr mei_me isst_if_common intel_th_pci
ioatdma i2c_smbus mei intel_vsec acpi_power_meter ipmi_ssif
intel_pch_thermal intel_th dca ipmi_si acpi_ipmi ipmi_devintf
ipmi_msghandler acpi_pad sg fuse loop xfs sd_mod ghash_clmulni_intel
ahci libahci tg3 libata wmi sunrpc dm_mirror dm_region_hash dm_log
dm_multipath dm_mod nfnetlink [last unloaded: brd]
[ 6915.434755] CPU: 2 UID: 0 PID: 7198 Comm: bash Kdump: loaded
Tainted: G S  B               6.17.0-rc5 #1 PREEMPT(voluntary)
[ 6915.447281] Tainted: [S]=3DCPU_OUT_OF_SPEC, [B]=3DBAD_PAGE
[ 6915.453016] Hardware name: Lenovo ThinkSystem SR650 V2/7Z73CTO1WW,
BIOS AFE118M-1.32 06/29/2022
[ 6915.462728] RIP: 0010:__slab_err.part.0+0x19/0x20
[ 6915.467981] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
90 0f 1f 44 00 00 e8 f6 fc ff ff be 01 00 00 00 bf 05 00 00 00 e8 77
bf 29 00 <0f> 0b c3 cc cc cc cc 48 89 ee 48 c7 c7 eb a2 86 ab c6 05 10
13 c4
[ 6915.488939] RSP: 0018:ffa0000002fcf918 EFLAGS: 00010046
[ 6915.494773] RAX: 0000000000000000 RBX: ffd400000b6c3b80 RCX: ffffffffa80=
d3a9a
[ 6915.502740] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffffadd=
3f180
[ 6915.510706] RBP: ff11000149c51140 R08: 0000000000000001 R09: fffffbfff5b=
a7e30
[ 6915.518672] R10: ffffffffadd3f187 R11: 0000000062616c53 R12: ff11000285f=
f0000
[ 6915.526640] R13: ff11000285ff1000 R14: ff11000149c4f040 R15: ffd400000a1=
7fc00
[ 6915.534605] FS:  00007f9aa117a740(0000) GS:ff1100043db3d000(0000)
knlGS:0000000000000000
[ 6915.543637] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6915.550051] CR2: 000056332051e698 CR3: 00000001485c1002 CR4: 00000000007=
73ef0
[ 6915.558017] PKRU: 55555554
[ 6915.561037] Call Trace:
[ 6915.563766]  <TASK>
[ 6915.566108]  __kmem_cache_shutdown.cold+0x1c/0x43
[ 6915.571364]  kmem_cache_destroy+0x68/0x170
[ 6915.575938]  zs_destroy_pool+0x18b/0x250
[ 6915.580319]  zram_reset_device+0x233/0x600 [zram]
[ 6915.585576]  reset_store+0x20b/0x300 [zram]
[ 6915.590252]  ? __pfx_reset_store+0x10/0x10 [zram]
[ 6915.595506]  ? sysfs_file_kobj+0xb3/0x1c0
[ 6915.599982]  ? sysfs_file_kobj+0xbd/0x1c0
[ 6915.604449]  ? __pfx_sysfs_kf_write+0x10/0x10
[ 6915.609315]  kernfs_fop_write_iter+0x3a3/0x5a0
[ 6915.614278]  vfs_write+0x522/0xfd0
[ 6915.618078]  ? __pfx_vfs_write+0x10/0x10
[ 6915.622459]  ? local_clock_noinstr+0xd/0xe0
[ 6915.627130]  ? __lock_release.isra.0+0x1a4/0x2c0
[ 6915.632287]  ksys_write+0xf9/0x1d0
[ 6915.636086]  ? __pfx_ksys_write+0x10/0x10
[ 6915.640561]  ? lockdep_hardirqs_on+0x78/0x100
[ 6915.645426]  do_syscall_64+0x94/0x8d0
[ 6915.649515]  ? ktime_get_coarse_real_ts64+0x121/0x180
[ 6915.655155]  ? lockdep_hardirqs_on+0x78/0x100
[ 6915.660022]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 6915.665855]  ? lockdep_hardirqs_on+0x78/0x100
[ 6915.670719]  ? do_syscall_64+0x139/0x8d0
[ 6915.675089]  ? __x64_sys_openat+0x108/0x1d0
[ 6915.679762]  ? __pfx___x64_sys_openat+0x10/0x10
[ 6915.684819]  ? lockdep_hardirqs_on+0x78/0x100
[ 6915.689684]  ? syscall_trace_enter+0x13e/0x240
[ 6915.694648]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 6915.700481]  ? lockdep_hardirqs_on+0x78/0x100
[ 6915.705347]  ? do_syscall_64+0x139/0x8d0
[ 6915.709726]  ? rcu_is_watching+0x15/0xb0
[ 6915.714106]  ? clear_bhb_loop+0x50/0xa0
[ 6915.718390]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 6915.724031] RIP: 0033:0x7f9aa1276cd4
[ 6915.728023] Code: c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f
84 00 00 00 00 00 f3 0f 1e fa 80 3d f5 d3 0d 00 00 74 13 b8 01 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 48 89 54 24
18 48
[ 6915.748982] RSP: 002b:00007fff12e38d88 EFLAGS: 00000202 ORIG_RAX:
0000000000000001
[ 6915.757433] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f9aa12=
76cd4
[ 6915.765400] RDX: 0000000000000002 RSI: 000055cb65bac570 RDI: 00000000000=
00001
[ 6915.773356] RBP: 000055cb65bac570 R08: 0000000000000073 R09: 00000000fff=
fffff
[ 6915.781322] R10: 0000000000000000 R11: 0000000000000202 R12: 00000000000=
00002
[ 6915.789280] R13: 00007f9aa134d5c0 R14: 0000000000000002 R15: 00007f9aa13=
4af00
[ 6915.797249]  </TASK>



On Tue, Aug 19, 2025 at 10:29=E2=80=AFPM Changhui Zhong <czhong@redhat.com>=
 wrote:
>
> [ 5066.279543] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> [ 5066.288672] BUG zspage-zram0 (Tainted: G S  B   W    L     ):
> Objects remaining on __kmem_cache_shutdown()
> [ 5066.299449] ----------------------------------------------------------=
-------------------
> [ 5066.299449]
> [ 5066.310226] Object 0x000000003141ad3c @offset=3D840
> [ 5066.315476] Object 0x000000008aac8ad7 @offset=3D1848
> [ 5066.320823] Slab 0x00000000cce340bd objects=3D73 used=3D2
> fp=3D0x000000003f8c10b1
> flags=3D0x17ffffc0000200(workingset|node=3D0|zone=3D2|lastcpupid=3D0x1fff=
ff)
> [ 5066.335286] ------------[ cut here ]------------
> [ 5066.340439] WARNING: CPU: 5 PID: 2847 at mm/slub.c:1171
> __slab_err.part.0+0x19/0x20
> [ 5066.348985] Modules linked in: zram 842_decompress lz4hc_compress
> 842_compress lz4_compress zstd_compress tls rpcsec_gss_krb5
> auth_rpcgss nfsv4 dns_resolver nfs lockd grace nfs_localio netfs
> rfkill intel_rapl_msr intel_rapl_common intel_uncore_frequency
> intel_uncore_frequency_common i10nm_edac skx_edac_common nfit
> libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
> mgag200 dax_hmem irqbypass cxl_acpi rapl cxl_port iTCO_wdt ipmi_ssif
> intel_cstate cdc_ether iTCO_vendor_support cxl_core usbnet mei_me mii
> i2c_algo_bit isst_if_mbox_pci intel_uncore einj isst_if_mmio
> intel_th_gth i2c_i801 ioatdma mei pcspkr intel_th_pci isst_if_common
> i2c_smbus intel_vsec intel_th dca intel_pch_thermal ipmi_si
> acpi_power_meter acpi_ipmi ipmi_devintf ipmi_msghandler acpi_pad sg
> loop fuse xfs sd_mod ahci libahci tg3 libata ghash_clmulni_intel wmi
> sunrpc dm_mirror dm_region_hash dm_log dm_multipath dm_mod nfnetlink
> [last unloaded: brd]
> [ 5066.440862] CPU: 5 UID: 0 PID: 2847 Comm: bash Tainted: G S  B   W
>   L      6.17.0-rc2+ #1 PREEMPT(voluntary)
> [ 5066.452123] Tainted: [S]=3DCPU_OUT_OF_SPEC, [B]=3DBAD_PAGE, [W]=3DWARN=
,
> [L]=3DSOFTLOCKUP
> [ 5066.460379] Hardware name: Lenovo ThinkSystem SR650 V2/7Z73CTO1WW,
> BIOS AFE118M-1.32 06/29/2022
> [ 5066.470089] RIP: 0010:__slab_err.part.0+0x19/0x20
> [ 5066.475330] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
> 90 0f 1f 44 00 00 e8 66 fc ff ff be 01 00 00 00 bf 05 00 00 00 e8 f7
> 83 10 00 <0f> 0b e9 10 c2 e7 00 48 c7 c7 3c 20 2f aa c6 05 6d 80 f3 01
> 01 e8
> [ 5066.496286] RSP: 0018:ff7690a584a23c70 EFLAGS: 00010046
> [ 5066.502116] RAX: 0000000000000000 RBX: ff462f22566d3700 RCX: 000000000=
0000027
> [ 5066.510081] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 000000000=
0000005
> [ 5066.518046] RBP: ff462f22566d3700 R08: 0000000000000000 R09: ff7690a58=
4a23af8
> [ 5066.526009] R10: ffffffffaa922e28 R11: 0000000000000003 R12: ff7690a58=
4a23c90
> [ 5066.533975] R13: ff462f2260d55000 R14: ffdd3f4b84835540 R15: ff462f225=
6413900
> [ 5066.541940] FS:  00007f9902945740(0000) GS:ff462f25c45fb000(0000)
> knlGS:0000000000000000
> [ 5066.550971] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 5066.557383] CR2: 000055b941e4ad98 CR3: 0000000109ef6001 CR4: 000000000=
0773ef0
> [ 5066.565346] PKRU: 55555554
> [ 5066.568364] Call Trace:
> [ 5066.571092]  <TASK>
> [ 5066.573433]  __kmem_cache_shutdown.cold+0x1c/0x46
> [ 5066.578686]  kmem_cache_destroy+0x3f/0x150
> [ 5066.583257]  zs_destroy_pool+0xd0/0xf0
> [ 5066.587443]  zram_reset_device+0xdb/0x1c0 [zram]
> [ 5066.592597]  reset_store+0xa8/0x110 [zram]
> [ 5066.597170]  kernfs_fop_write_iter+0x13b/0x1f0
> [ 5066.602130]  vfs_write+0x25d/0x450
> [ 5066.605926]  ksys_write+0x6b/0xe0
> [ 5066.609625]  do_syscall_64+0x7f/0x980
> [ 5066.613703]  ? do_syscall_64+0xb1/0x980
> [ 5066.617985]  ? do_user_addr_fault+0x206/0x690
> [ 5066.622847]  ? clear_bhb_loop+0x50/0xa0
> [ 5066.627127]  ? clear_bhb_loop+0x50/0xa0
> [ 5066.631408]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 5066.637047] RIP: 0033:0x7f9902a41894
> [ 5066.641034] Code: c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f
> 84 00 00 00 00 00 f3 0f 1e fa 80 3d 35 d8 0d 00 00 74 13 b8 01 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 48 89 54 24
> 18 48
> [ 5066.661991] RSP: 002b:00007fff33d6ab28 EFLAGS: 00000202 ORIG_RAX:
> 0000000000000001
> [ 5066.670438] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f990=
2a41894
> [ 5066.678403] RDX: 0000000000000002 RSI: 0000556ee81a7570 RDI: 000000000=
0000001
> [ 5066.686368] RBP: 0000556ee81a7570 R08: 0000000000000073 R09: 00000000f=
fffffff
> [ 5066.694333] R10: 0000000000000000 R11: 0000000000000202 R12: 000000000=
0000002
> [ 5066.702296] R13: 00007f9902b185c0 R14: 0000000000000002 R15: 00007f990=
2b15f00
> [ 5066.710260]  </TASK>
> [ 5066.712698] ---[ end trace 0000000000000000 ]---
> [ 5066.717866] ------------[ cut here ]------------
> [ 5066.723022] kmem_cache_destroy zspage-zram0: Slab cache still has
> objects when called from zs_destroy_pool+0xd0/0xf0
> [ 5066.723027] WARNING: CPU: 5 PID: 2847 at mm/slab_common.c:525
> kmem_cache_destroy+0x13d/0x150
> [ 5066.744196] Modules linked in: zram 842_decompress lz4hc_compress
> 842_compress lz4_compress zstd_compress tls rpcsec_gss_krb5
> auth_rpcgss nfsv4 dns_resolver nfs lockd grace nfs_localio netfs
> rfkill intel_rapl_msr intel_rapl_common intel_uncore_frequency
> intel_uncore_frequency_common i10nm_edac skx_edac_common nfit
> libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
> mgag200 dax_hmem irqbypass cxl_acpi rapl cxl_port iTCO_wdt ipmi_ssif
> intel_cstate cdc_ether iTCO_vendor_support cxl_core usbnet mei_me mii
> i2c_algo_bit isst_if_mbox_pci intel_uncore einj isst_if_mmio
> intel_th_gth i2c_i801 ioatdma mei pcspkr intel_th_pci isst_if_common
> i2c_smbus intel_vsec intel_th dca intel_pch_thermal ipmi_si
> acpi_power_meter acpi_ipmi ipmi_devintf ipmi_msghandler acpi_pad sg
> loop fuse xfs sd_mod ahci libahci tg3 libata ghash_clmulni_intel wmi
> sunrpc dm_mirror dm_region_hash dm_log dm_multipath dm_mod nfnetlink
> [last unloaded: brd]
> [ 5066.836081] CPU: 5 UID: 0 PID: 2847 Comm: bash Tainted: G S  B   W
>   L      6.17.0-rc2+ #1 PREEMPT(voluntary)
> [ 5066.847347] Tainted: [S]=3DCPU_OUT_OF_SPEC, [B]=3DBAD_PAGE, [W]=3DWARN=
,
> [L]=3DSOFTLOCKUP
> [ 5066.855606] Hardware name: Lenovo ThinkSystem SR650 V2/7Z73CTO1WW,
> BIOS AFE118M-1.32 06/29/2022
> [ 5066.865318] RIP: 0010:kmem_cache_destroy+0x13d/0x150
> [ 5066.870862] Code: 00 85 ed 74 92 eb b1 e8 91 38 df ff eb 8f 48 8b
> 53 60 48 8b 4c 24 10 48 c7 c6 b0 03 c8 a9 48 c7 c7 60 35 25 aa e8 33
> b6 d2 ff <0f> 0b e9 0e ff ff ff e9 47 f8 a9 00 0f 1f 80 00 00 00 00 90
> 90 90
> [ 5066.891823] RSP: 0018:ff7690a584a23ce0 EFLAGS: 00010286
> [ 5066.897659] RAX: 0000000000000000 RBX: ff462f2256413900 RCX: 000000000=
0000027
> [ 5066.905629] RDX: ff462f256fb5c188 RSI: 0000000000000001 RDI: ff462f256=
fb5c180
> [ 5066.913595] RBP: 0000000000000001 R08: 0000000000000000 R09: ff7690a58=
4a23b58
> [ 5066.921555] R10: ffffffffaa922e28 R11: 0000000000000003 R12: ff462f22a=
1e2c600
> [ 5066.929522] R13: 00000000000000ff R14: ff462f23185d1000 R15: ff462f225=
5ed6320
> [ 5066.937480] FS:  00007f9902945740(0000) GS:ff462f25c45fb000(0000)
> knlGS:0000000000000000
> [ 5066.946514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 5066.952930] CR2: 000055b941e4ad98 CR3: 0000000109ef6001 CR4: 000000000=
0773ef0
> [ 5066.960896] PKRU: 55555554
> [ 5066.963918] Call Trace:
> [ 5066.966649]  <TASK>
> [ 5066.968994]  zs_destroy_pool+0xd0/0xf0
> [ 5066.973183]  zram_reset_device+0xdb/0x1c0 [zram]
> [ 5066.978341]  reset_store+0xa8/0x110 [zram]
> [ 5066.982919]  kernfs_fop_write_iter+0x13b/0x1f0
> [ 5066.987881]  vfs_write+0x25d/0x450
> [ 5066.991682]  ksys_write+0x6b/0xe0
> [ 5066.995384]  do_syscall_64+0x7f/0x980
> [ 5066.999475]  ? do_syscall_64+0xb1/0x980
> [ 5067.003758]  ? do_user_addr_fault+0x206/0x690
> [ 5067.008613]  ? clear_bhb_loop+0x50/0xa0
> [ 5067.012897]  ? clear_bhb_loop+0x50/0xa0
> [ 5067.017181]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 5067.022823] RIP: 0033:0x7f9902a41894
> [ 5067.026814] Code: c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f
> 84 00 00 00 00 00 f3 0f 1e fa 80 3d 35 d8 0d 00 00 74 13 b8 01 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 48 89 54 24
> 18 48
> [ 5067.047765] RSP: 002b:00007fff33d6ab28 EFLAGS: 00000202 ORIG_RAX:
> 0000000000000001
> [ 5067.056219] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f990=
2a41894
> [ 5067.064187] RDX: 0000000000000002 RSI: 0000556ee81a7570 RDI: 000000000=
0000001
> [ 5067.072155] RBP: 0000556ee81a7570 R08: 0000000000000073 R09: 00000000f=
fffffff
> [ 5067.080124] R10: 0000000000000000 R11: 0000000000000202 R12: 000000000=
0000002
> [ 5067.088093] R13: 00007f9902b185c0 R14: 0000000000000002 R15: 00007f990=
2b15f00
> [ 5067.096060]  </TASK>
> [ 5067.098500] ---[ end trace 0000000000000000 ]---
>
>
>
> On Tue, Aug 19, 2025 at 10:20=E2=80=AFPM Changhui Zhong <czhong@redhat.co=
m> wrote:
> >
> > Hello,
> >
> > the following bug and warning was triggered,
> > please help check and let me know if you need any info/test, thanks.
> >
> > repo=EF=BC=9Ahttps://git.kernel.org/pub/scm/linux/kernel/git/torvalds/l=
inux.git
> > branch=EF=BC=9Amaster
> > INFO: HEAD of cloned kernel=EF=BC=9A
> > commit be48bcf004f9d0c9207ff21d0edb3b42f253829e
> > Merge: 074e461d9ed5 74857fdc5dd2
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Mon Aug 18 09:17:42 2025 -0700
> >
> >     Merge tag 'for-6.17-rc2-tag' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
> >
> > reproducer:
> > # modprobe zram
> > # zramctl --find --size 4G --algorithm zstd
> > # fio --name=3Dtest \
> >         --filename=3D/dev/zram0 \
> >         --rw=3Drandrw \
> >         --bs=3D4k \
> >         --ioengine=3Dlibaio \
> >         --iodepth=3D16 \
> >         --numjobs=3D4 \
> >         --runtime=3D60 \
> >         --time_based \
> >         --group_reporting \
> >         --direct=3D1
> > # echo 1 > /sys/block/zram0/reset
> >
> > dmesg log:
> > [ 4861.143371] zsmalloc: Class-80 fullness group 1 is not empty
> > [ 4861.149696] zsmalloc: Class-112 fullness group 1 is not empty
> > [ 4861.156121] zsmalloc: Class-144 fullness group 1 is not empty
> > [ 4861.162541] zsmalloc: Class-160 fullness group 1 is not empty
> > [ 4861.168963] zsmalloc: Class-176 fullness group 1 is not empty
> > [ 4861.175379] zsmalloc: Class-192 fullness group 1 is not empty
> > [ 4861.181797] zsmalloc: Class-224 fullness group 1 is not empty
> > [ 4861.205986] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [ 4861.215123] BUG zs_handle-zram0 (Tainted: G S                 ):
> > Objects remaining on __kmem_cache_shutdown()
> > [ 4861.226193] --------------------------------------------------------=
---------------------
> > [ 4861.226193]
> > [ 4861.236981] Object 0x00000000364c25c1 @offset=3D3336
> > [ 4861.242331] Slab 0x0000000040c2ee59 objects=3D512 used=3D1
> > fp=3D0x00000000ad7304d7
> > flags=3D0x17ffffc0000200(workingset|node=3D0|zone=3D2|lastcpupid=3D0x1f=
ffff)
> > [ 4861.256893] Disabling lock debugging due to kernel taint
> > [ 4861.262831] ------------[ cut here ]------------
> > [ 4861.267982] WARNING: CPU: 23 PID: 2847 at mm/slub.c:1171
> > __slab_err.part.0+0x19/0x20
> > [ 4861.276635] Modules linked in: zram 842_decompress lz4hc_compress
> > 842_compress lz4_compress zstd_compress tls rpcsec_gss_krb5
> > auth_rpcgss nfsv4 dns_resolver nfs lockd grace nfs_localio netfs
> > rfkill intel_rapl_msr intel_rapl_common intel_uncore_frequency
> > intel_uncore_frequency_common i10nm_edac skx_edac_common nfit
> > libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
> > mgag200 dax_hmem irqbypass cxl_acpi rapl cxl_port iTCO_wdt ipmi_ssif
> > intel_cstate cdc_ether iTCO_vendor_support cxl_core usbnet mei_me mii
> > i2c_algo_bit isst_if_mbox_pci intel_uncore einj isst_if_mmio
> > intel_th_gth i2c_i801 ioatdma mei pcspkr intel_th_pci isst_if_common
> > i2c_smbus intel_vsec intel_th dca intel_pch_thermal ipmi_si
> > acpi_power_meter acpi_ipmi ipmi_devintf ipmi_msghandler acpi_pad sg
> > loop fuse xfs sd_mod ahci libahci tg3 libata ghash_clmulni_intel wmi
> > sunrpc dm_mirror dm_region_hash dm_log dm_multipath dm_mod nfnetlink
> > [last unloaded: brd]
> > [ 4861.368551] CPU: 23 UID: 0 PID: 2847 Comm: bash Tainted: G S  B
> >           6.17.0-rc2+ #1 PREEMPT(voluntary)
> > [ 4861.379913] Tainted: [S]=3DCPU_OUT_OF_SPEC, [B]=3DBAD_PAGE
> > [ 4861.385639] Hardware name: Lenovo ThinkSystem SR650 V2/7Z73CTO1WW,
> > BIOS AFE118M-1.32 06/29/2022
> > [ 4861.395350] RIP: 0010:__slab_err.part.0+0x19/0x20
> > [ 4861.400604] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
> > 90 0f 1f 44 00 00 e8 66 fc ff ff be 01 00 00 00 bf 05 00 00 00 e8 f7
> > 83 10 00 <0f> 0b e9 10 c2 e7 00 48 c7 c7 3c 20 2f aa c6 05 6d 80 f3 01
> > 01 e8
> > [ 4861.421562] RSP: 0018:ff7690a584a23c70 EFLAGS: 00010046
> > [ 4861.427387] RAX: 0000000000000000 RBX: ffdd3f4b88085780 RCX: 0000000=
000000027
> > [ 4861.435345] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ff462f2=
56ffdc180
> > [ 4861.443310] RBP: ff462f22566d3740 R08: 0000000000000000 R09: ff7690a=
584a23ae8
> > [ 4861.451276] R10: ffffffffaa922e28 R11: 0000000000000003 R12: ff7690a=
584a23c90
> > [ 4861.459242] R13: ff462f224a3f5000 R14: ffdd3f4b8428fd40 R15: ff462f2=
256412a00
> > [ 4861.467207] FS:  00007f9902945740(0000) GS:ff462f25c4a7b000(0000)
> > knlGS:0000000000000000
> > [ 4861.476230] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 4861.482646] CR2: 0000556ee84d1f90 CR3: 0000000109ef6002 CR4: 0000000=
000773ef0
> > [ 4861.490613] PKRU: 55555554
> > [ 4861.493624] Call Trace:
> > [ 4861.496354]  <TASK>
> > [ 4861.498686]  __kmem_cache_shutdown.cold+0x1c/0x46
> > [ 4861.503941]  kmem_cache_destroy+0x3f/0x150
> > [ 4861.508517]  zs_destroy_pool+0xc4/0xf0
> > [ 4861.512706]  zram_reset_device+0xdb/0x1c0 [zram]
> > [ 4861.517866]  reset_store+0xa8/0x110 [zram]
> > [ 4861.522443]  kernfs_fop_write_iter+0x13b/0x1f0
> > [ 4861.527406]  vfs_write+0x25d/0x450
> > [ 4861.531205]  ksys_write+0x6b/0xe0
> > [ 4861.534907]  do_syscall_64+0x7f/0x980
> > [ 4861.538996]  ? do_syscall_64+0xb1/0x980
> > [ 4861.543279]  ? do_user_addr_fault+0x206/0x690
> > [ 4861.548143]  ? clear_bhb_loop+0x50/0xa0
> > [ 4861.552426]  ? clear_bhb_loop+0x50/0xa0
> > [ 4861.556706]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [ 4861.562345] RIP: 0033:0x7f9902a41894
> > [ 4861.566328] Code: c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f
> > 84 00 00 00 00 00 f3 0f 1e fa 80 3d 35 d8 0d 00 00 74 13 b8 01 00 00
> > 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 48 89 54 24
> > 18 48
> > [ 4861.587279] RSP: 002b:00007fff33d6ab28 EFLAGS: 00000202 ORIG_RAX:
> > 0000000000000001
> > [ 4861.595729] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f9=
902a41894
> > [ 4861.603693] RDX: 0000000000000002 RSI: 0000556ee81a7570 RDI: 0000000=
000000001
> > [ 4861.611659] RBP: 0000556ee81a7570 R08: 0000000000000073 R09: 0000000=
0ffffffff
> > [ 4861.619616] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000=
000000002
> > [ 4861.627580] R13: 00007f9902b185c0 R14: 0000000000000002 R15: 00007f9=
902b15f00
> > [ 4861.635548]  </TASK>
> > [ 4861.637985] ---[ end trace 0000000000000000 ]---
> >
> > Best Regards,
> > Changhui


