Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D197C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 19:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1069C6B009E; Fri, 17 Jul 2026 15:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7686B00B0; Fri, 17 Jul 2026 15:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9986B00B3; Fri, 17 Jul 2026 15:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A23B96B009E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:28:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33025140208
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:28:53 +0000 (UTC)
X-FDA: 84999256146.11.EE568C7
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 29DB81C0004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:28:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cGQ3un5e;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784316531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jiuq4RrEPSqzc2CjSOsVE6XMKzyT/WebTRpubajhs2o=;
	b=6wXI1ZV0uj3ul/6/6qEW+RG559NevdLWTfTnJ84tLujBIM/GpERuuxmjRy5cfmY9wqa4/w
	0USwHCEP+nviXYLT6rBQ+QlryTY+gm5SczEd2gPdqrE8tzYLRY8Zc954nWavMV6XfIqDIA
	c+KEialRHxmHvuFyOLHiJ3FlNJCBPsU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cGQ3un5e;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784316531;
	b=Q8dVq/OFQpXpdN5mp1SxfGSWzaAPFiygVMayu+FidfB4oFfCdYs5WtPlyCTHQ7oUuxoVld
	tWs88uLMdAyhYyI4MEkA6PDiXuinqRosTjD4jyWJH+8A3YFeohNRKCYstbTLoRfW1nFBWG
	dfU8dM/sOKQxm5/8928cIvCAohKcZmA=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9305a2121a1so454711085a.2
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784316530; x=1784921330; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Jiuq4RrEPSqzc2CjSOsVE6XMKzyT/WebTRpubajhs2o=;
        b=cGQ3un5e/sYgx7luhOnrKOBmiyl+VftBC7TFfW55ONzLP1yLEY9r0Akkh5QdYrvnlC
         lwx6wNZZy00WKx7BvhSDqfhcZK41nKpWwHGe1ixpN/cvp4/1XJsKmvkPDGc+sOjbefx2
         XyvAhCGGj7J2CDrXHItuZUKrZyqarfb5NfAtJC3xZCiMO38YZ3HbYhOUs0n1TNUsJUg2
         Ruzonkm0RH0yXgjEg2IeKkIOPlroXiufdRcOrUBtJaUy4M78PllqxMrxbbxY+yHF48Qf
         1xPlIP/fLw8Rm6DG8qVB5lE5zpuFeBmyJ4FlqL3hF2PFL+WiMVhxBkhEzbFsWVbS5CI/
         xmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784316530; x=1784921330;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jiuq4RrEPSqzc2CjSOsVE6XMKzyT/WebTRpubajhs2o=;
        b=MliVBfr84AgDjP1BDY1wL9r1ebieesbSwIiAXQtHgGbt6ySdyrmZd0GNsqShQbsjm8
         BOgyaUd1xLJ6uaqaaXlU/c4/jTmKJguzEJs/70pfdFnKYxx+twWTGtz5fHkt/D/EhvGJ
         Bz0Nc6+QDNv0JtmrEzFAq2x3BuZgY3TewVKHL9o65zkfNstP5JsDGAjJG32z7hNF57R6
         jXlPtKH/FnfH0vvOPQU5pDdm4JxrazUPkClCEgKl+9CpAF2M+4xqT7xd6FGqlxst9B3C
         vFHfxGC1OBihfL/G8V+WsSMHCl8cy++BbSiGoFoTOkTweVvbJd2Qa1okNdg62Lj1lxWj
         A37A==
X-Forwarded-Encrypted: i=1; AHgh+RphEbAEifKlpgAMuhtxdMw2mt+weerWrvFWNPTHd2k3GcIWJvB7DpJIy/HwwqlaZGAAHLFFOFI1Ow==@kvack.org
X-Gm-Message-State: AOJu0YwSYI4KnsoNTGpdOkIBnSE8rw/XESvY5l3K+7AZtcCLtYjIHxjk
	sT8m2mApoYrK6NYMInFKDhAmWj/2E+SICxQYKqJKei0RI3h6Li56Yww4UVbezYbLm2s=
X-Gm-Gg: AfdE7cloytXPNjbXaahY/8CUODtwwetxZIeFq2GtaCVCJfKZfFpaTByOSzig0nNIv5L
	vnj9G5ajPAX2CpnoPFCdSWsfAzFn+S9T+fGZl5exCGSKck/HOxsxLchbxP9ZS3PPo6tK9UUZO2Z
	E/6sILTElbo4364jwTUUO1xEtf70K71dWbFjVuVI0zRU5EhCcUd2kcgE7g92VuJiVvCtKoD5o+0
	ejm2DSXvab9tM9wgmueSe3ikcp8+sZaUu/w0vkwzmmPfmXbyfYknEE6Pxw0Yw/r6C+sX2Y7bdtM
	pQvrjJn8ZFS1nSxlXeArDzyt7blcu8sjaopQcH0zCaLm7xjCQGaZAk2uuE0r3S3Ogx0NmOCw8LY
	Z43nCDa2gUt3Jji5Ydt9HZa1g29roqSs1dEmyrMPc3FDQBrmhwnPYgtUUmjmquSJ/306PjE/Ahh
	n7pFm+JK/fUEqzJbhZivRkG3XxEiUyS02kto1N5+w=
X-Received: by 2002:a05:620a:4014:b0:930:b7f3:6c6a with SMTP id af79cd13be357-930b7f36ef3mr332805385a.66.1784316530109;
        Fri, 17 Jul 2026 12:28:50 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b5304a99sm231909285a.20.2026.07.17.12.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 12:28:49 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 01/12] PCI: liveupdate: Set up FLB handler for the
 PCI core
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
 Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pranjal Shrivastava <praan@google.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20260710212616.1351130-2-dmatlack@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-2-dmatlack@google.com>
Date: Fri, 17 Jul 2026 19:28:44 +0000
Message-Id: <178431652443.189683.17611165218179620081.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2399;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=WaZbN29Yb7QirGLZ6z5SCIc8GS0Y/8CnVePacwfjgX4=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqWoJwXimoKQnR5L+cGvO5hfmCHnc7/6Y+V/lnr
 /tiYHeaRyWJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCalqCcAAKCRC7dyhM23N6
 3mp/D/9E7WlpCbODIzubvEP77KqJASqif+QIFU1RjVar0csfnfO/87C1moo0vCfIbC5Wp4vev5R
 Weg8hCZ2vLXDJz3lZXkA4+MsTgUcAAUyQQEjh6Qz8ByxS+sRPt3KLMkTEMLvpv/RizG0xuuOxQF
 1MhV3yaBpkv3AqJR2aNw5bVIXcWGqdcGm4dwrzJQd1+mhwmw2ysi1ar4aCa91WcVxiPR5258FjR
 L6P9gv/F6g1QxuiohNcx/CYF+1WBiVYD5ElowzhhrrkWAlpbEyNU2WuMtDxB4Mk0UNqfL5d/HjP
 yvC16iyfwmfYtymywIPSxd+6EO5awcN1kN8GBHAgvqYdjGl/++zbvsYOhHeK0VSWNJ4r8ab03Yz
 saoGD2xsKkdhxtABu4cG0lWbRyKgCMc2jyvt4vYFCisgxPbIEVHpOE3ZdL5O9w0f6p9wglb0bd8
 o8lDkvrrVGsHSDlOgeiZel+Pah/XGVOb89wPQ5PnIhdyocdX/blr6+4xbeExmuVdcik4GWX3RC/
 OVRyYBeSlTJ+dIQxC/gyYJ6o7wcY28JEIbr/6z7yE0M2mJ7ZmuGjBoeX8sYSTxiFjR6Z0tfA9x/
 0Br6X1vRHcwO1p/zpTdETR3bzl5yaXnL/fAKnCWt7OlQVnA6hyKsV7ro9T3/H8PswPl2AIfElFc
 2EkAQsTiIeXe94g==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 29DB81C0004
X-Stat-Signature: exg77hgggz7eyoa5c8j5mt9eog3mg35k
X-HE-Tag: 1784316531-474589
X-HE-Meta: U2FsdGVkX1+/CggRnVrNhI5u8AWWxcuicS7f3uDujqKhk2YA9y7sS/k10vTsd0kti96BSBCkvxHeZEA1uzYuV/CxFlUBvCfSkDMjVQ/IeeWn2FogBQJxounRoFxUji0+QbcTDCn5+QlZm11jxfCtsyZXbnS4P5XUJFjah0rxYRGZ9PLpCHp2+K8zgKpRAXSO1sctP/9AknKuyDX+EoWaYpD0bWQkuez1IDrgm+xJ4SBnapVoAdrLvvFVoWmHE5z8FFW5hVmEoELXWqN60ADymZtM4dOXJVhZLFZeLRW8Y9RNSzSeJd98/76DCEODj0CsST+aAIDa4ewzD/lGjurOYm+9n/kalKVba7REEZJ7qq9GyA+tU9nhYoR6WPVc1OxWnoB1SMHqc89yJzeru4h6SL1TFEmX87u0e0QKzYeNf/QkimVZYu8NMfxmJcZYzKQAX92ydLI7xpx0Jmne6AnTFSdMYNiwncHGJJbkeAQYg5PJV+gk1lln3lgNG5LWTvZ4mcRw0EJ+CT5sxZ3BUTKlowtuKldM2MFwGtSuqH30fplwSJcIVwHC5BmL2Zvf9gMRUcEKDz0RyURIXOZbgxRjidvBLVDSMLRBG3V4JXnlB0V735mX0SNcfVSXrQVh5jfeZi9Cs1pglW2lJmHdn+LR1A3fBxsAhqsYJ8BXmzYFMFbJ2dxlExGLV7bVbXL1jddAevcTO5vsvwN3pkTOdsyMAqzcOEZPRF0KUcRANAWSFzeOo8OqEliQqXrJuozKG47+SwKNBKvLHPZl8yLQiJ0+U4fBy9H1VCfleA4r5/YDICw7ilHmwE/tOdO0s/WJwpQocZConF3T+Yv8NnF7JxrhNjSEdm+PBjULPxKeDXJK0aIeIP3YM6+j2nxUCHHBv5mta9QBTlViO7xjfhOKHaw1I/VBxPo8OLUup15m65+IKjzBHaD7y4KQYQgW0B4fSTajv/lgtvlDPtBsqGZJR2V
 SAP7jz4U
 a9waj2YlcnFjI11pXimlGmW7T/dGWa5712wzn/w04gUPsbrcdEEswdxowBm5MEz44D9iNcdNnYWveoedtKBXSJWe17VvGvJfd/NfbEJexyE5J25tx8neZGIjrOyX7gEgyfkAgdgKc7TDn0QPACJJj1sWAYFwILf2U428O0cUklmJqIii5+r6hlcX3eo31R7IhiCDk5bh05SitNQvBSdvJIOrVH+/30oiSL7dnVpLyGP96MUwYTbPzMy6Dg8fyTWF9DA0HJK9i4bo0iPN55qIAsQTd9nxHiF1sPmtVGo5XWXl8LwDiT9I68OrY7bl0r0v6U5hrrcFmRkjaQVxVwF2hB4npw6TED1llTFBP1jeGKOWyKSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:26:04 +0000, David Matlack <dmatlack@google.com> wrote:
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> new file mode 100644
> index 000000000000..899758883dd5
> --- /dev/null
> +++ b/drivers/pci/liveupdate.c
> @@ -0,0 +1,155 @@
> [ ... skip 50 lines ... ]
> +#include <linux/slab.h>
> +
> +/**
> + * struct pci_flb_outgoing - Outgoing PCI FLB object
> + * @ser: Pointer to the preserved struct pci_ser.
> + * @block_set: The KHO block set holding the outgoing devices.

AFAIK, these should be aligned after column:
@ser:       Pointer to ...
@block_set: The KHO block ...

> [ ... skip 26 lines ... ]
> +	ser->devices = 0;
> +
> +	outgoing->ser = ser;
> +	kho_block_set_init(&outgoing->block_set, sizeof(struct pci_dev_ser));
> +
> +	args->obj = outgoing;

Nit:
You could re-write the above:

args->obj = no_free_ptr(outgoing);

And declare outgoing like this:
struct pci_flb_outgoing *outgoing __free(kfree) = kzalloc_obj(*outgoing);

Also, remove kfree(outgoing) call.

>
> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> new file mode 100644
> index 000000000000..de549016807a
> --- /dev/null
> +++ b/include/linux/kho/abi/pci.h
> @@ -0,0 +1,58 @@
> [ ... skip 30 lines ... ]
> + * @domain: The device's PCI domain number (segment).
> + * @bdf: The device's PCI bus, device, and function number.
> + * @refcount: Reference count used by the PCI core to keep track of whether it
> + *            is done using a device's struct pci_dev_ser. The value of the
> + *            refcount is equal to 1 when the struct pci_dev_ser is in use, and
> + *            0 otherwise.

I believe descriptions must be aligned.

> + */
> +struct pci_dev_ser {
> +	u32 domain;
> +	u16 bdf;
> +	u16 refcount;
> +} __packed;
> +
> +/**
> + * struct pci_ser - PCI Subsystem Live Update State
> + *
> + * This struct tracks state about all devices that are being preserved across
> + * a Live Update for the next kernel.
> + *
> + * @nr_devices: The number of devices that were preserved.
> + * @devices: Physical address of the first KHO block containing pci_dev_ser.

I believe descriptions must be aligned.

Nit: Please order the included headers alphabetically.

Nit: Please order the included headers alphabetically.

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

