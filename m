Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 619F5606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 00:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LJ36q2oa
Received: by kanga.kvack.org (Postfix)
	id 567D06B062D; Thu, 19 Nov 2026 19:06:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F7A6B070A; Thu, 19 Nov 2026 19:06:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D836B06C1; Thu, 19 Nov 2026 19:06:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 151DF6B070A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:06:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E15571C47F6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:06:45 +0000 (UTC)
X-FDA: 85453556370.01.DD4EFF8
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id E6B2540007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:06:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LJ36q2oa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795133204;
	b=GdL0dtdoUeS4qPZLUxn+c0x679XsKs2+MN+nNC1u9Ghy6XraPMnLgEFndqEqeEJbpKHhV7
	GfLDfyVPPixDDDTmowsxJYFUmBhVokbhkr0r6alI5//92i+d5kgrAonLbec9kvO5v6c3Ax
	k2jDUU533NnHqFYGSQEFK/ceREhIsYY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795133204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PsDwtqZ7ZOXHEr9V4C4myUyqMWkC/3w4Fd9za5pDc8=;
	b=y7tKp2A0Ay/wbS4yXyD/f/tmN6eXX8dndxpaSvfjCOCqYi8j4wNcKzBXaA65cDbK+lVVmG
	Gxw7k5hUUGqnkPlk0b3UuCCV0NnaeOjNwTnN2nsXeiXmjWL7wPq7mNkUtWUC5++vup7NPz
	gjZ+qJRB31k0/vjZ832xutnwOfc6m6s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LJ36q2oa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cde0daf3a2aso150235a12.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795133202; x=1795738002; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8PsDwtqZ7ZOXHEr9V4C4myUyqMWkC/3w4Fd9za5pDc8=;
        b=LJ36q2oaKa/oW2STc7jrxgWCzMtsr6Xm5ZqQBtY3Zv4OGCuNX1emu+nk5QqfbbPIwY
         2m6+VtKUomBR6Ty784rSlZcv2GWeT1zhgS1W4jhWzABgLQ+0Co4oLSY6sqqOFhYjwUl4
         lReLbwO1NZSQP/rWW1Bqfko0tjMfl64dflGxLypFz5sOYmEzyirKJZi1cmEjkAFjnzUy
         lVpOwqKn3MXN2KoBXLx6zLPKEoUaot3xab+Xo3slL856slCQPNBkXX0x2fGcpm9i3539
         ZTJuc3W2cbbqaEwcXYPV14iG5LAqzn+75SAk3iZoH3CfyHjuXQ7v4esaj2jh4NVzyAR6
         kYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795133202; x=1795738002;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8PsDwtqZ7ZOXHEr9V4C4myUyqMWkC/3w4Fd9za5pDc8=;
        b=YQh8nu1syEnAwDVFWbG3lBUCLatx463jos3fxM+ARM94SI7RMuxc/BsVQNbbd/vNam
         l67sYx3JWQyzZktQmzKWv0lbuXV699YXvwwjFoJfFgLtXhF/F2UU+02R31nUKmySunyf
         ZT37nFdIhsB8+ZIjmgvDJdpJqsYahPfXnOpgZbaSrp/TCrd7q2vSZXVACceGLqWSyiIq
         costBhPMxMIWqm2wjc/ubZmsZa40RfGR9RV/f4guo7tjha2zohGIX+zzsU+LzZaRQkL/
         T8fCfwrMKBLLQp8en2e43X9hH2rO06rlLYn1zYjkFcKEcIQWBOVz47+AhhUmHnEUFz/m
         7fXA==
X-Forwarded-Encrypted: i=1; AL+hErGlMFai9eeTPHPZIik5fKAukKjv/VKZVB9f5Lp+ZhZOzBGoWV+5c21h9a79tkDNR9dXdu4WRLPJMA==@kvack.org
X-Gm-Message-State: APuU4Z9P0WDZB3YkBBiH5fhgDA/86ML7W8UF4QgtLKU1j9GhsUfauVNL
	GgpML4BB0lF3SbQ10qvb6/NtrE0ORqxeeSZy62ZmJJ9dk51oO4/2rtkNa6uJ6VSTcg==
X-Gm-Gg: AZFdTZcUdsbmlkrAt8ZQCwQG6gSi0bedb763VliWt/WrH3mXeCa/l6jpPnz0yLp5usI
	QFIlxmlVCYHJyZYhEMtgSUqVGCpqA/kk5POwVoo679yv3DtzjUT6zbqQJqcBT1n7/f8DoOAAIhc
	PssD9bJ9nH/viOisRKYlKJvAsvq302Z5DiPxGibDJkGs2KZGep3gMjehGKT9Zcav7YW72k/FNEN
	OlwFjTEDLgOLkmXX+QJjz3TlR1GJMkMyaeC6HdqnmFwcZB6O0Srm1z1gqPFSkjkLHhcYcvtzSJV
	njWWQob3lnT5jeavHVr57WS3eX19HmEIHCA9ZdPNZS0TKOuvuZXiQ3/VkX+DUUp4M8pV3AMu0gV
	h2TUD2wvMWvAFbx+KwiXYPaQOTiFZAfPGXRaS5Yh3rK4FAW4Wk31qYe1cxfm1Rup7WDzsKIDVod
	RDEmUj3NcxWfc2QqfaZIHkR7mzG/DNBKkqZrNYhsCS9iwm0+sjaLbKP/E2ja279c3kMvFrK4BgE
	+4Rx6GarcB2U6tJWlJEG+rRCeQczwetl1zi4bspEV1t7u4keVt3y90Q26ATTk70ecMgOPYEB+Z1
	JeC/h/3flZUEAPePksmY02lK4R8yhTgtlJF7u6kG+qG656YNzIJsQ82oG1graHFR
X-Received: by 2002:a17:90b:442c:b0:3b3:ab74:cc9b with SMTP id 98e67ed59e1d1-3b41c554624mr967136a91.0.1795133201767;
        Thu, 19 Nov 2026 16:06:41 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ff5d3easm328044a91.1.2026.11.19.16.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 16:06:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 19 Nov 2026 16:06:38 -0800
Message-Id: <DMZLLYOVIGOU.1RXWYJN6UQTM@google.com>
From: "David Matlack" <dmatlack@google.com>
To: "Vipin Sharma" <vipinsh@google.com>, "David Matlack"
 <dmatlack@google.com>
Cc: <kexec@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <ajayachandra@nvidia.com>, <alex@shazbot.org>, <amastro@fb.com>,
 <ankita@nvidia.com>, <apopple@nvidia.com>, <bhelgaas@google.com>,
 <chrisl@kernel.org>, <christian.koenig@amd.com>, <corbet@lwn.net>,
 <graf@amazon.com>, <jacob.pan@linux.microsoft.com>, <jgg@nvidia.com>,
 <jgg@ziepe.ca>, <jrhilke@google.com>, <julianr@linux.ibm.com>,
 <kees@kernel.org>, <kevin.tian@intel.com>, <leon@kernel.org>,
 <leonro@nvidia.com>, <lukas@wunner.de>, <mattev@meta.com>,
 <michal.winiarski@intel.com>, <parav@nvidia.com>,
 <pasha.tatashin@soleen.com>, <praan@google.com>, <pratyush@kernel.org>,
 <rananta@google.com>, <rdunlap@infradead.org>, <rientjes@google.com>,
 <rodrigo.vivi@intel.com>, <rppt@kernel.org>, <saeedm@nvidia.com>,
 <schnelle@linux.ibm.com>, <skhan@linuxfoundation.org>,
 <skhawaja@google.com>, <vivek.kasireddy@intel.com>, <witu@nvidia.com>,
 <yanjun.zhu@linux.dev>, <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 07/27] vfio/pci: Preserve vfio-pci device files
 across Live Update
X-Mailer: aerc 0.21.0
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-8-vipinsh@google.com> <auzftbPFO_6XBYVw@google.com>
 <20261117220059.GA2250529.vipinsh@google.com>
In-Reply-To: <20261117220059.GA2250529.vipinsh@google.com>
X-Rspamd-Queue-Id: E6B2540007
X-Stat-Signature: 5hpqu4go6h1re6d98tdzpx3qm48raajo
X-Rspam-User:
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795133203-854220
X-HE-Meta: U2FsdGVkX18WOLDqGaJnoXdd6hLAW8q16/6HW5dIGmsqu7SBZ7UPos/tNv/JeaixBl5J20pwd54J5R4pcunM+l6AmXKEmKQZLiRfj7Y80gN6GN5CXH8IstQ0ZQkXyE48yBDQTbMCuxrDlwd84dnuuyIglC9+RWYil+PPgAjBJfTU6b5kM0QXzxMTkI9vVn/tELbcc+D6TN54SCnwAGlBKzp9nfRF52/JrErsKpYaBhOubpC4O6ZgbQsxUY7amHGr7XKIhFdiR3YxiGLbEFxlDqnwAiURwrYa8Yd6hALUCHXVVZctzd9Sh1E7ZVgCa3tGN7UDCM/guS9kj5MNclpfbc8VeevMLqUL7ZCbS+/NVii8axwcTkpdxo24Wt0yuY8bKREzXvvl/e8PAPYDbxl1vqH59Q5kvJOgDdmf7nF23/kKW6PHfYHYOdyECKtVkyPLuUoNf3wAWaPE/C9+0vFSq/eXGzeUkZ38cCQHnLpmnZrPvzfqMBwGFETQ7kSSC9j7UBJtsDcoW+Ujl3QCLfbJZkSLhG1jUKiJfcd/0dv+6JsdwmL+93TkhEm8qSNIBvbb6FqK/FGuPP0fG/XjT+WVlgV2DYQKv2AbePv3X+HweWKFyupqbOkm+Gun3mWQLmxRMWJ9NQeSckxeKwU1Z6fdKY3jZgoXXAOgssiZ2WodvJVytTO/IjUuhrzditPSEelZXfI/lIajqaKV2CABD39sI18AAkH4vQ/rDUiBgodVlxNcKiXgAmLW9IDbiNW4diayTVT7CcmRuAn9Cqz+ESLaKrBdQ3wlqTgTF5fm2h12c/HIRQg+uBMqWrbBjEaC4Sz+aE8Y4+aD+IamV1yZlHkXSYo2T3nU4dXFN1YyktmiiVaG6GUO+ouqugts9Z0rJ1lmUt4eYjrQIUX96fNAh1noP60FPzdduLNkPtnkMZakN/3DEoXIV4sEg06ZaFMWJ1cddBRrF+HprCAM/PfhV1E
 yu8eL3Sb
 hxZBSgsv7GmmdgQl+2OwX6ObPF7TOm/cl1H5TQhQh+XyKiZq/iUp1fe45SkDm4R21vpdIbJEBunwzvEURDKKycUCU+CSagEpatZsuzEzQekd/tGhpW0LTIK38OlU3YoIp2ZAbFP6IygrkVAbp0ic1IWbd4xSTvRYYM4VmyBaLmK3llt0ETfph0XcrqUnk6xs611tXppoQ7SeArH3xD6iScs+hP2ixRCv2k5nMf4zPfkjXkvIDuAYDcJAvw0uCAGChLj9iShfPGR+1oWbbdln4kJ7y7cEm6NeHBNf7mTMnx4KF3ISDKDSPakgFz6BImeJAIlvJn6I6QZv3Fh3PjjqRxipzFqrCU17JtvzsCPj6jVhSPWgFk329xuYvtGraE2ewL0pHhJOX17ezir76HxuyDM/l1R22pzqS8D5bh8/bhYcXgopf2NO4UuOMUCsDBmlbXElazNMPjcwpsU1C7hR/hSenBjUcdcSPWZHcDOhLDqus6RXgdEFGDizxAOx7FvviomNkQl+nJOZQ0L8s5n8XcmkyGQDoPdl6er+yGHtFpZe5XNEEBRs+dkvM+hsEXM/UWwxPFN8vjVYrxrt61oZRCrznMw8yILbG93mP73BLFhtdkX9RMy/SoZ2iTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 17, 2026 at 10:44 PM PST, Vipin Sharma wrote:
>> pci_config_map doesn't need to be preserved. PATCH 14 already rebuilds
>> it with vfio_config_init() in the next kernel and only uses the
>> preserved copy to check that the two are identical.
>>=20
>> I assume the intent is to detect changes to vfio-pci's config emulation
>> between the two kernels, but the map isn't a good proxy for that. It
>> changes for differences that don't matter (e.g. hiding a capability or
>> learning the length of a new extended capability), which would fail
>> take-over and lose the Live Update on exactly the kernel upgrades Live
>> Update is meant for. And it doesn't change for differences that do
>> matter, like which bits are virtualized or writable within a capability.
>
> I think it does matter because reads and writes of unitialized
> capabilities in VFIO PCI config space goes to hardware directly. So, in
> the new kernel if pci_config_map changes it from PCI_CAP_ID_INVALID to
> others then those reads/writes can go to vconfig which will contain
> stale unitialized data from the old kernel's heap.
>
> This also changes behavior under a running user. Writes that reached
> hardware before Live Update can be silently dropped or redirected to
> vconfig. See the comment above struct perm_bits unassigned_perms{}
> in vfio_pci_config.c

That's true. Unassigned bytes passed through and vconfig is never
initialized for them, so hiding or exposing a capability does matter.
For example, 6467d0740a2b ("vfio/pci: Add DVSEC PCI Extended Config
Capability to user visible list") changed DVSEC from hidden (all bytes
raw) to exposed with a virtualized header. Across that boundary, v6
would have served DVSEC from uninitialized bytes in vconfig.

> How would a userspace opt-in? New kernel can change a capability visiblit=
y
> or virt and write permission of the bits inside a capability. Kernel
> cannot know if userspace used the capability or not. Creating a VFIO
> device in the new kernel by default results in a opt-in and currently
> there is no way for userspace to opt-out unless we add a new
> functionality where userspace can disable/enable features something
> similar to KVM capabilities.
>
> For now, I think we don't need to worry about it. As this version will
> be a base and if any serialized data with flags set received in this
> kernel will lead to erroring out restore.

We don't need an opt-in mechanism in this series. Detecting mismatches
is enough to make Live Update safe in both directions: if the next
kernel would emulate the device in an incompatible way, retrieve should
fail.

But an opt-in is needed to make rollback possible once vfio-pci starts
changing its emulation. I imagine something like a VFIO_DEVICE_FEATURE
that userspace can use to enable new emulation behavior right after
opening the device, with the enabled bits recorded in a field appended
to struct vfio_pci_core_device_ser behind a required flag. Devices that
don't opt in keep the baseline emulation and stay compatible with older
kernels. But that can come in a follow-on series.

> In the next version, I will not preserve pci_config_map. Hopefully,
> anyone changing VFIO code doesn't forget to update flags if they change
> capability or permission bits (I will write comments at appropriate
> places.)
>
> If we want to be very careful, we can do two things in this series:
>
> 1. Create a per bit valid mask for the vconfig and compare this between
>    new and old kernel during restore. In the new kernel, VFIO then takes
>    each bit from the preserved copy only where the mask says it was
>    valid, and keeps its own freshly initialized value elsewhere.
> 2. Create a hash or store virt and writable bits in config space.
>    Compare it with the new kernel.
>
> Both of the above combined will safeguard against forgotten flag update
> in the code.
>
> We don't have to do it but it safeguards against mistakes. Let me know
> what you prefer.

I think we should do both in this series, as two per-bit masks over
config space, preserved in place of pci_config_map:

 - virt[]: the bits whose value vfio-pci keeps in vconfig and returns
   instead of the device's value. This says which bits of the preserved
   vconfig are valid.

 - write[]: the bits whose writes take effect. For bits in virt they
   update vconfig, and for other bits they are forwarded to the device
   (possibly after validation). Writes to other bits are ignored.

The masks should describe what vfio-pci actually does rather than copy
perm->virt and perm->write.

vfio-pci can keep changing its implementation in ways that don't break
Live Update, e.g. start intercepting writes to a register to sanity
check them before forwarding them to the device.

Something like:

  struct vfio_pci_core_device_ser {
          ...
          u8 virt[PCI_CFG_SPACE_EXP_SIZE];
          u8 write[PCI_CFG_SPACE_EXP_SIZE];
          u8 vconfig[PCI_CFG_SPACE_EXP_SIZE];
  } __packed;


[ Note: I'd probably store virt[], write[], and vconfig[] on their
  own folios to avoid multi-order folio allocations, but I am embedding
  them here for simplicity. ]

The outgoing kernel computes virt[] and write[] through a helper in
vfio_pci_config.c and saves vconfig[] during freeze().

The incoming kernel computes its own virt[] and write[] masks and
requires both to match exactly with what's in vfio_pci_core_device_ser,
otherwise it fails the retrieve. On take-over it uses the preserved
value for bits in virt and its own freshly initialized value for the
rest, like your option 1.

I'd store the full masks rather than a hash, so that a mismatch can be
pinpointed.

