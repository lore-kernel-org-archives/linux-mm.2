Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 757B7107761B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 21:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2DE6B033B; Wed, 18 Mar 2026 17:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963C56B033C; Wed, 18 Mar 2026 17:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8525C6B033D; Wed, 18 Mar 2026 17:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6ADBE6B033B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:08:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24207567C6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:08:53 +0000 (UTC)
X-FDA: 84560423346.16.9FCF7F7
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4090FA0016
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:08:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hWq4UVgJ;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773868131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjkVCGc9UuS/iYmQSMn+hsLjVouvW5XYtaAItifULpw=;
	b=IvUUBvjpB8Kv8tLr6O4TBA57nLjXWM0yotk08p2L9gXIhSRiHVE/NrMzWbo0MlYzCR0J/4
	4B3RnVuiB/5Ax3IsBhC2UL3UqW1+mPCE/7szEX/V8vAKJI9yWLYkMT3F+Jbnbg8fYtpUaL
	MEqI9bOPLclUrocvLFt2pjPV0VWp/As=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hWq4UVgJ;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773868131; a=rsa-sha256;
	cv=none;
	b=X5Ki4Zh5KfM8AYjFTFH1qHrtVhffNoZI7fEFk+h9rfUoK9wuIVZKtnDkW1t/zlh/1XFlD5
	tzVrLTxeCDguIgK3zW2RXVsX/VJliNgbi0FbyriXRqHb5iXXzjyag/dOzLqjs9V8i52YGX
	9wAnjb6mv2Pr05PvDsGly2eSBf16908=
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-67bade86c09so202190eaf.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773868130; x=1774472930; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjkVCGc9UuS/iYmQSMn+hsLjVouvW5XYtaAItifULpw=;
        b=hWq4UVgJZlAPvLNUJq9aBUY0pQMhNlJkDxn2Y1RNuabR+C1Bzyb/2aJt+cB3RlELlw
         J2R9n6AecYtZgIIiMlsO6wcxvJqtqgkRMs+WyJsjUdh2LUae2/FfdYjqRUtYB+5yMUZS
         VEbLOPrvlZ/6hMB1/+9d5OvGQw8RW19kigTNvbifh1Z9QsfWrYDLPuXk4DQtwxZ830ub
         JXWv27nojGMPbY4ykkrKoXD03N8jrHxwxD4r9kXcZRHfKc3wobzPArfR4/2ApPbqbLKF
         N3fFGhQZj9QAwOFlebuZ1VAzOtTVg5uhoHHGhMjbHw97Z8/SU1jaihGBqflj+AP1VsP2
         j6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773868130; x=1774472930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hjkVCGc9UuS/iYmQSMn+hsLjVouvW5XYtaAItifULpw=;
        b=K1/tLxKWUvCtADH8VYCoAJ1T74OVrHxvryglGmVeWnFa1eBibDvoqfM51KFDDoOoiu
         +/d1Q7Hrh9WQ0epkhIuMr7hBmtXUf9Oyosp7qNOXNXLq74TMxBSqWtwfRbYhTWeaAXn9
         rl7PtriAsYjRov9ByHwlBiSLqy67D6oEuzJpr0XJ2mFcsltJIJaj2ZkS37xa5TEM+4Jt
         OhppBDZI16MT56rsROezXBZ/ZnHhf/IxQBTaEnmpqgttCkc9jGbWL1AJvEL2P6tvBvU8
         2Ia8Lww09CPJ+E3BskJBJ9DCw9WFzG70MzD+AjGh0kPsyUvyGvecuH6jU2EQzsB7G62j
         nZkQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHaMa+r9FDiPJRrKtMFPmgYYBPd6V6qaoSnBM2dG8kIRfDZGh2kZH2SSm/XBibOb3KBxoPG08Ksg==@kvack.org
X-Gm-Message-State: AOJu0Yz//1MGQXbf2Sq9PV9hY34bWzP6+YHAzGX4MO+p0q3QP2MGww6Y
	c7ZBUvark0oF8oZ0kIocH/nz/vKzPIO0/8ez+fb+VEdhqqMwNiuEutxa
X-Gm-Gg: ATEYQzwavNEYtJdSUQayHchGQBY7FLyC+dqi2XCM22XAhXJ56vOtv5UndyRBlIvI7WF
	LzsKt1l13ZgnUCEQ9Qk4W7vGmLmQZnUQZdDmLFaydsSfRv3kJoT9+i7u5TRzn0SqnRHFeJpR8U5
	XEgKJ60jDbFgB5r7LNjBtB6LDfQOck/e4/N21rA5CjwtcbeJ1Byr3BuEDAMEBIiGKBPH+NHTXrf
	wZa5KBZ7o9BPRz6phDkeu4Q1BIp8SJs2KYEsZnOy+PheGbGMk8ZVcHAlC0JMmU6kuOCCz+FvPP7
	V1P1M+NfM/8SFLLxqEBs9lD1b/jIIxJu4utv4Y94Wnkke8na3+uq9KDQNU/yhX3gtIhJnqovWZw
	CRAzXGz/FtfoxM1F48GUtaAqtu5owXNfuojhoLMQAI2gfailRa6jAq0YmCAoxzutZlgusRcaky0
	voWsh46ngTog+RZDfn/neEygsaP2WGUPDA
X-Received: by 2002:a05:6820:4513:b0:67b:f775:e5fe with SMTP id 006d021491bc7-67c0db33831mr2728249eaf.65.1773868129977;
        Wed, 18 Mar 2026 14:08:49 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd2c3111dsm3532488fac.12.2026.03.18.14.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 14:08:48 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v2 12/16] mm: allow handling of stacked mmap_prepare hooks in more drivers
Date: Wed, 18 Mar 2026 14:08:45 -0700
Message-ID: <20260318210845.2591228-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <72750af6906fd96fb6f18e83ac3e694cf357a2c1.1773695307.git.ljs@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4090FA0016
X-Rspamd-Server: rspam08
X-Stat-Signature: 8f84mwgttynp6u78i5uiwrpaarz1cdto
X-HE-Tag: 1773868131-222669
X-HE-Meta: U2FsdGVkX19D0NSgzYSQlK8nbqtnqo50Iz/xGU/AB/HGaYqVweiD0rtFsPXYbfAvvBSsKFLHh896tl5Xpksd7AbNBd0tkjRqFmObk012Ljksfo5EkGnfR9oZd9cR6QuOqzna4SwqlDUKzV4oQYj1TWyufxvjKcr5wQVRcN/4QY9SjfQ5MZoNiLi+rTV1aIegdw14qRTVs5d9lwE5KulE0MGkaaQqSRYIolbKWkAnfIF1RADu14UQQG6BJIbmdvJWu5uxYgPyT4I0EuG87KpKYwMeqmWSQOrAOT4SCCul1DmxVzCk25lL2F/bBIbUJIRTIwtyjOIUaIgTaHuIxtV83CXRWBRJD/wnCg+zgw2zP/vR1Xh+z1IHOOlOVNvVWKB8Mp1KLiHdoaW0IwV6xVn+9HDeTi6AiFOjVCbPzMASW9cpbnpy8j1bdE0rYxgIOY3FZny7DJeutShPIOmnGP3+3Za95gOUzXinKdw/LArAgZjeP68LGsYsO/kP+n3vxjRt5ZbXeisxnoowZws+MRI2B8qD8FvaoTnepS/uIdWSiqEI1Bx8GRCGnvXP/iRgYVOoUByHXjaCTKNrY475ZhMg8UxN9TNcY8ToU0TbhUvjUBUIzWl2b/q4M10cp0Tj0HSZydXdlaGxNj7wAPEKwZvmVqkVoMkAJS22KJU6Tyb5xRZeGsOCkxCGO80b0/EL5FLGxUHuq8wQlIRievJ6SWg1oPVxeJRgoarYE6K8voaCQF80s+/7MtN5OLAk2kkk6wnIy3ehrw3Ow2Anb89pxZ+DSpg0rA9jSnKkWkY4PfLNp2x1jdajKFc3AUBCPmkkbIPPNdbUoOb7/Dmmz8PgBI0zmGEg336Wky2mjf5Pb6QnlIrmffaPFYIbnciOXBicHBqEtlyMLITrEPHAvBkrneT1QB5Y9rO0W4o6oCS4a5tkdLNXEWdAq+wwpskrUgKFd1i93lfCw00uX/1kfOumTCd
 bmZEUCPr
 uttkLmLlHWwRWehq4LOuii6A80to3Ol5g8fOSsgL3SyZUmp0Z9LjbUdz1ttgrg/SsQo6HyzYMgobkg8UeFjiodfdmJs2LkBcLpd0R63JlJpysgrrgUUl1aNs6tOBgAwYUXGpdW0Qnhz7TftlJAul4Co4J72TtU071ZcBbHAiCOxdAllWQwKpk7sRbTEt5QyaSGosfHiyV2Wx6lYsK0wMEACWfl8lu9UAwo9IlIrGHNkvpo0eM+DJwdfesBzkL7ETVCWag56pR/zVOUEb0H4h2B0oMFhaa5OPMVJtANZAQkOy7Cb8UzCLqUEmgpxc2LxY5yrGxA+OMnXQbRFgP5wq4vHEuf4nSQzz13zNXf1Mqzv39FJmix4zd9Cp/NheKlc/aMJ7FM3EzCsllVH451ZMFhUSgAICUqpQ/Tvz8ZEZ8TfAkxs336f5v16+LzbxxMRxN1M2ES35hVkiXArw1hSRhrHVUXJqJDIuiaW9r7XwqpMFP2nWjjBa6W+/RDykmN14CaUrpw/uShop+xngRTz6+IbY/PXtVJYudTukVhIDe8b2MgQdWXywYne9LzfWVx22JLAFHeEIlgCLVyFHa0U/ELihzI/rMcYDN1/rdfQlbf8UuRWPNR0nzr+9ehq2HWRZz21fG0FftTObD+g8aAODCHI5bCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 21:12:08 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> While the conversion of mmap hooks to mmap_prepare is underway, we wil
> encounter situations where mmap hooks need to invoke nested mmap_prepare
> hooks.
> 
> The nesting of mmap hooks is termed 'stacking'.  In order to flexibly
> facilitate the conversion of custom mmap hooks in drivers which stack, we
> must split up the existing compat_vma_mapped() function into two separate
> functions:
> 
> * compat_set_desc_from_vma() - This allows the setting of a vm_area_desc
>   object's fields to the relevant fields of a VMA.

Hello Lorenzo, I hope you are doing well!

Thank you for this patch. I was developing on top of mm-new today and had
an error that I think was caused by this patch. I want to preface this by
saying that I am not at all familiar with this area of the code, so please
do forgive me if I've misinterpreted the crash and mistakenly pointed
at this commit : -)

Here is the crash:

[    1.083795] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    1.083883] BUG: unable to handle page fault for address: ffa00000048efbb8
[    1.083957] #PF: supervisor instruction fetch in kernel mode
[    1.084030] #PF: error_code(0x0011) - permissions violation
[    1.084086] PGD 100000067 P4D 10035f067 PUD 100364067 PMD 441ed9067 PTE 80000004466a3163
[    1.084162] Oops: Oops: 0011 [#1] SMP
[    1.084218] CPU: 0 UID: 0 PID: 305 Comm: mkdir Tainted: G        W   E       7.0.0-rc4-virtme-00442-ge53de5a0302f-dirty #85 PREEMPTLAZY

As you can see, it's on a QEMU instance. I don't think this makes a difference
in the crash, though.

[    1.084321] Tainted: [W]=WARN, [E]=UNSIGNED_MODULE
[    1.084369] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-5.el9 11/05/2023
[    1.084450] RIP: 0010:0xffa00000048efbb8
[    1.084489] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <40> 12 0e 00 01 00 11 ff d0 fa 8e 04 00 00 a0 ff 80 33 51 02 01 00
[    1.084642] RSP: 0018:ffa00000048ef998 EFLAGS: 00010286
[    1.084692] RAX: ffa00000048efbb8 RBX: ff11000102512cc0 RCX: 000000000000000d
[    1.084766] RDX: ffffffffa06247d0 RSI: ffa00000048efa18 RDI: ff11000102512cc0
[    1.084826] RBP: ffa00000048ef9c8 R08: 0000000000000000 R09: 0000000000000007
[    1.084889] R10: ff110001047d1f08 R11: 00007effdc3d0fff R12: ff110001047d3b00
[    1.084954] R13: ff11000446cae600 R14: ff110001024efe00 R15: ff11000102510a80
[    1.085021] FS:  0000000000000000(0000) GS:ff110004aae72000(0000) knlGS:0000000000000000
[    1.085083] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.085136] CR2: ffa00000048efbb8 CR3: 0000000102667001 CR4: 0000000000771ef0
[    1.085201] PKRU: 55555554
[    1.085228] Call Trace:
[    1.085248]  <TASK>
[    1.085274]  ? __compat_vma_mmap+0x8e/0x130
[    1.085318]  ? compat_vma_mmap+0x76/0x80
[    1.085354]  ? mas_alloc_nodes+0xb2/0x110
[    1.085390]  ? backing_file_mmap+0xc3/0xf0
[    1.085426]  ? ovl_mmap+0x41/0x50
[    1.085463]  ? ovl_mmap+0x50/0x50
[    1.085499]  ? __mmap_region+0x7e8/0x1100
[    1.085539]  ? do_mmap+0x49f/0x5e0
[    1.085573]  ? vm_mmap_pgoff+0xef/0x1e0
[    1.085609]  ? ksys_mmap_pgoff+0x15c/0x1f0
[    1.085647]  ? do_syscall_64+0xab/0x980
[    1.085684]  ? entry_SYSCALL_64_after_hwframe+0x4b/0x53
[    1.085730]  </TASK>
[    1.085770] Modules linked in: virtio_mmio(E) 9pnet_virtio(E) 9p(E) 9pnet(E) netfs(E)
[    1.085838] CR2: ffa00000048efbb8
[    1.085874] ---[ end trace 0000000000000000 ]---
[    1.085875] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    1.085918] RIP: 0010:0xffa00000048efbb8
[    1.085921] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <40> 12 0e 00 01 00 11 ff d0 fa 8e 04 00 00 a0 ff 80 33 51 02 01 00
[    1.085988] BUG: unable to handle page fault for address: ffa00000048f7bb8
[    1.086026] RSP: 0018:ffa00000048ef998 EFLAGS: 00010286
[    1.086166] #PF: supervisor instruction fetch in kernel mode
[    1.086221]
[    1.086267] #PF: error_code(0x0011) - permissions violation
[    1.086321] RAX: ffa00000048efbb8 RBX: ff11000102512cc0 RCX: 000000000000000d
[    1.086348] PGD 100000067
[    1.086394] RDX: ffffffffa06247d0 RSI: ffa00000048efa18 RDI: ff11000102512cc0
[    1.086459] P4D 10035f067
[    1.086486] RBP: ffa00000048ef9c8 R08: 0000000000000000 R09: 0000000000000007
[    1.086550] PUD 100364067
[    1.086577] R10: ff110001047d1f08 R11: 00007effdc3d0fff R12: ff110001047d3b00
[    1.086641] PMD 441ed9067
[    1.086668] R13: ff11000446cae600 R14: ff110001024efe00 R15: ff11000102510a80
[    1.086731] PTE 80000004433d3163
[    1.086764] FS:  0000000000000000(0000) GS:ff110004aae72000(0000) knlGS:0000000000000000
[    1.086829]
[    1.086868] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.086931] Oops: Oops: 0011 [#2] SMP
[    1.086958] CR2: ffa00000048efbb8 CR3: 0000000102667001 CR4: 0000000000771ef0
[    1.087015] CPU: 29 UID: 0 PID: 306 Comm: mount Tainted: G      D W   E       7.0.0-rc4-virtme-00442-ge53de5a0302f-dirty #85 PREEMPTLAZY
[    1.087050] PKRU: 55555554
[    1.087115] Tainted: [D]=DIE, [W]=WARN, [E]=UNSIGNED_MODULE
[    1.087207] Kernel panic - not syncing: Fatal exception
[    2.158392] Shutting down cpus with NMI
[    2.158629] Kernel Offset: disabled
[    2.158668] ---[ end Kernel panic - not syncing: Fatal exception ]---

It crashes at compat_vma_mmap, and here is what I think could be the 
potential crash path:

- compat_vma_mmap() creates struct vm_area_desc desc;
  - compat_set_desc_from_vma Doesn't initialize the struct, but instead
    modifies independent fields. I think this is where the behavior
    diverges, since before we would use the C initializer and uninitialized
    variables would be set to 0 (including ommitted ones, like
    action.success_hook or action.error_hook). But action.type = MMAP_NOTHING
  - desc.action.success_hook remains uninitialized in vfs_mmap_prepare
  - mmap_action_complete()
    - Here, We've set action.type to be MMAP_NOTHING, so we have err = 0
    - mmap_action_finish(action, vma, 0)
      - And here, since err == 0, we check action->success_hook (which has
        garbage, therefore it's nonzero) and call action->success_hook(vma)

And I think action->success_hook(vma) where success_hook is uninitialized
stack garbage gets me to where I am.

Again, I'm not too familiar with this area of the kernel, this is just
based on the quick digging that I did. And aplogies again if I'm missing
something ; -) I do think that the uninitialized members could be a problem
though.

Thank you, I hope you have a great day Lorenzo!
Joshua

