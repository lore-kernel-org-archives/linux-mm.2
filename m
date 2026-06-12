Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10DA2CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 05:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463BB6B0088; Fri, 12 Jun 2026 01:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B9A6B0092; Fri, 12 Jun 2026 01:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350646B0093; Fri, 12 Jun 2026 01:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 260AB6B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:15:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B25A6404B1
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:15:13 +0000 (UTC)
X-FDA: 84870096906.23.72ED356
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9A41A10000C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:15:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ihFprrwP;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781241311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ytd7iPwY/amgpO/lDKmmEiHlsDrpfROrVFTbD1YMi6c=;
	b=exvEpWY5PwUB93JCj+i2bQOifBxRyxZ2E8ihzpW82QdnjnN5MEKz73lWUpCRiU14mir6Ho
	pHBOp889tOex2PzOUYX1NZOfM6Mbz/kaOTUArw/Twc9RdKDkKryeEsdpS+0uvUxHRvL59B
	GBuW4lggcKpI2luWAm+LJ3pi+fdYq8Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ihFprrwP;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781241311;
	b=ZLGFSaHjvLHzIkXZsXOLY5RzJUERhH31sfJs4MZbPzxFXg2JOOxz+w5ZnUBcjWEM1gnJ2T
	hKWr2PBMIOw3D/Go8tA2MhYy/1LZdDZw4xr56P95TltX1Fu3wV9EDwKUkCONwGFlwMx5MQ
	z9k7JIbTcFC8dV233DoZfUS10vUSCWU=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51788280e71so6198671cf.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1781241310; x=1781846110; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ytd7iPwY/amgpO/lDKmmEiHlsDrpfROrVFTbD1YMi6c=;
        b=ihFprrwPdWesFWOWuUCFxNB//SczqIDBDRWzV1+xuDM0Qdm4el7NotvG1xv6/KaJMp
         8vmDu5OYbjFuvqBm1+NnvcJn67T3M0iKinLB0F58oac5gVlVAiWxQz7h+RjLGR90CkiT
         TegY44IpaO4sWTU9dy9fbfjhJRjpvwA3b4/u3V9HBHHig19aHrLvMSbmWW4ByV9ObmYl
         o8L8k+r2gfgl8DwI5yZrPiapIV7B6i7r79LORtYK2B1g5oC6t7b0p41cP/cz7DJbyq0X
         mLaeR/utYQFmOj14vUbWyw2gq7Ow2XGZG3wNyM0N4jFiPbgCfih9aFV1RvQzmc5na6tO
         AGww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781241311; x=1781846111;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ytd7iPwY/amgpO/lDKmmEiHlsDrpfROrVFTbD1YMi6c=;
        b=e6jnHg+u2XmwZUKsql1XbCO/wVdk43BCNhP7sDkHvrZH2kZ4LlQ2tAORVq9MeCyMQI
         TZiOQL99RQ//kB6vweCxk299QOmBWlKkm0Jj9vwnbbSaFBQegt8e/4xItvF8JLNM+dhz
         e4BVTggW/Duhx95/BIpnILXldwhiol1WxGSN237eDkGHwowgeXBO+nUfH8kqiIuV/Y/E
         thV2zRFIhFofDJH53+zcAfy1qveI4lo2mUzhvKio+G1I4jU5l0wSZSVLsnHp6lH1VY77
         ItrSLmTd4wfgZpDFT85FxrDbyaxZbeAHsUzpyILt4aiQx+4qL/Gh9i0zflSpu+LwlfEq
         FJ/A==
X-Forwarded-Encrypted: i=1; AFNElJ9Mm7iHJ1IUq6ZTtmNQN8JMn5ZnBZD27HEkvrHBP2SPXqo+/Nb8OxdL4IyAVaMnU7bzI4cG/grOJQ==@kvack.org
X-Gm-Message-State: AOJu0YwKIY+AHAyF1ZBzgC4v1vkkC9h1fHl8kRgBpwYAKZewTkRo38wD
	Mp5ITM3rrITomhOsmfodHarZcByicgkPWDoMULLpb+xD/pH4jDd+HVyosWr1JExzlYQ=
X-Gm-Gg: Acq92OHdO9CqSHuJ2rhTrgjYPHojsrIOgQUyaex+MhevJXqOIrHEXpQgoadLf738BGc
	PN6YuuHffAB2p3XdvreY6virbMT2V7lG2oSMZOC4jFVoG9k1GX1PvqFQVfMweSpJrRDiWep9u/7
	/+Mgd3CLubYC6/hZDAy/oBRv1+esNhPE4YOXYgZf8PQRX8aCXFlokh5LWRZbKYA3V1wFJWHYNwx
	xQ7fZIcEwiuOC21fY0vDRfFBj2FbC0t7djTPciWuqamzZyyUnKhxj/dNmokCSQJYPqRk+tDz+19
	2OdTFZkBOhnpIhmLQsZVCNPl5S+NfAjxRukUQB/1XUs+kTPlKI2SYJGihzRe5wlmcF+pX+BDXCJ
	EnCiJI/yNtjgsUlIeabounKaeMvEsuKIyhk/AiMD4C5zkSPeuILppZf/BLWVCYsrtcl2i2lIT5s
	GZpkQmV7z6kt+wLhQ813la3C5A03dYfHxf8wNSFYrqsHQV5mtHi7lONDzwWOhE
X-Received: by 2002:a05:622a:60c:b0:517:6b31:8058 with SMTP id d75a77b69052e-517fe50614bmr16606071cf.40.1781241310554;
        Thu, 11 Jun 2026 22:15:10 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb7e8900sm12732291cf.23.2026.06.11.22.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 22:15:10 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 01/12] PCI: liveupdate: Set up FLB handler for the
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
In-Reply-To: <20260522202410.3104264-2-dmatlack@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-2-dmatlack@google.com>
Date: Fri, 12 Jun 2026 05:15:02 +0000
Message-Id: <178124130274.908199.14827357870284807134.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4474;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=EzD98ff1aItiQM04E7u7INRRf8aew7gIPA1oAqmmEbk=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqK5Xc6OMuwmCG+aG2z1N7L1TcMXvQcxKu7DUJX
 +1rPXHL7kiJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCaiuV3AAKCRC7dyhM23N6
 3sl4D/49rTQw3AtcTrHTcVdJeLsKzlzrERbSSrQdqByRDKt/VZ3tYXxZ42pX6dtH57jB2TwPimJ
 fosBa4kw60OkjlCXDe0327bTsC/RBIpO8fpRg1nrQ4mdgxcxCA9WDOPf7nJKIGccIBHIyBSvzMH
 F1ist4SEhl3S9htSG08rn/5MOMDrQMbyPYpiMXJkCX8jmEnu+IhogD/W9GVaoN48kPyeW1BSYys
 rlDCm4C1C+TpXxkc9eQoTDokqxutzb6n9L+BmuGFXMZzLRT+Cvyy2XYoSMZ7h/ca1urQmGkcYQI
 C94Kxe+cqfGA4hE2Id/Dtrfj2Cv5PJVKahykKX4kp5vdFS8qGiWiexcvY5qrgFRIkuR467BP+WH
 IjdCg6yY0k1YvqmZTee/96z3eDX+BL7agDjBDpQJ6P92fVdayoI0kDL71lX9FhtUoobW0gUipjR
 UEi/3DifS9I2vz9+U7MN2RA4kPvyOQjqLtNmo9v4FSBa/YkCLnoyRA0LlRsIjF9d9WdtKu8M1ad
 CMeu4L4tloS40kHaM4VoOCDpVOxau7uk165pKvOGsyGdRN5wGMShHp0btN7htAjYMh9jz2E1mw7
 uMP27uJMOKTo6YqcPACF1qa4YPc+FVG+bLp/Qp6ddOr+7jiJvg9s9XVb469tJ1qe/BZiKMpm5tf
 9wtlEwOJSVNY0UA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Queue-Id: 9A41A10000C
X-Stat-Signature: rz9rnbmmqq65p6qcampzrdwejxa88byt
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781241311-562298
X-HE-Meta: U2FsdGVkX1+4aXxBWSBudipNfwGQYQSMWLRVr3wO+IGn+sLW588xB4S7FUBcr9CDVLQFV7D74hEIx1A6REMk3ysVchVxSpyFDIk4gRuO3iLV3K2oMqpmCUSM+Nn+eEWjTATrrZiQcRSNWrytm0xFq403kG1jqGmr3DmJciVbftOnaIlkUg/7yjkI9mCBBV6uz3hesfFvegbZg2d43mq8r/xP9+khR67RccCSZ272C51k+PwospcHRXBJpdLUCyJPz9ne//K/negF+HAE/hVzTBEz9+g9ctiWLIIeHhK36WqEMnmcR177r7X5VNfuIGSyxa9D/4NaVODrmEH76ZMpRL0h7Wst5dNz+Pa88pJ6Q1eZ8xHlkbhjlLmuf87sDDgunkDbkaaW49iw6OoFGxXDCfF/vbGxukk0/AtWYmRjlIgpfrqjCmpi4bzITbNvoedbHn0tg/hSBu76h9IzIq7NATXjCKW+md+qpPmCTRPNhNxGuos9+oFSDu2GVvjgz3K+zAFo/Ye/jLqQ8+zMqzOS4Znapi8iIXiRnzTDJEpmT+R1bs6qut+WE/MEvkT/fFXJqLDwFZUJzVWyTPDUDIfLn9OT3OvJCF5TdDjKd2RRySZu7EgyN36m4vD73FoR+HsrD1avds7VkEz6BqZZNfVJ8VIqSLA1FIeDQgVEA51ZEjgebkSHCUldjDIJiAu3GXwsD4Pt/wY6uV4TTtztcZjO+7mqatkSObhdlRGiTCVLYNWKCNN2v3Xbtw8n0Bw8FmLRYt9rNkH1LGa/g+g7mazx+vePVORtvEYmE9G64TNAS48hQgXB0FhPZx/FH+rpZqxjZZd6EQ2t8hsvjvRAf5N2XIX8lLZIuah4v4pEhXs7AmAabejoKsJiKgBmcWjbfX1yyttBQuSDBnsK9CDY+o81xp4jtgD/IASlwQqd/tPdjTXD6YRlxPbQZd4NHNQL5qqsu/Lg5QL23UPGIZfS88W
 KuBapkdj
 6WiKk1grCS3jNab73uh6yZ5SdPre8RY/wuYkWeDtyCKWt5KA/R9ZjXtxIJZm8HSm3JwUO2977UEDwLMQRXFobmWiK3St29lpk+8u/m33i5Ga+hCOmoEcPhh/BVVNaqY+cwD382yxHJBDRz+2MCWnzGGlx7ZRWVPUDDgsMgdiPH9viH5kFjyiI2cN/EAyT9iNGWNt9lf4gb6dr3Fl4TXSa3ysr0qtT9GLlOJ0S7evzmuY8bPAcWBjnf0SUk95uIb1eiqYvjCiQgrw3ffQcsHMKAAGvwupEVoki3i6LkHiSEPKBbMyAlZokt6EvFrgPPpjWxVs1DmO7QVk+e8CnqifqATYhe6SoR8PSoZB28He0J1mrr+7bIOecBOotOE6rJ6MvW2cG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 20:23:59 +0000, David Matlack <dmatlack@google.com> wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2fb1c75afd16..6c618830cf61 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20530,6 +20530,16 @@ L:	linux-pci@vger.kernel.org
>  S:	Supported
>  F:	Documentation/PCI/pci-error-recovery.rst
>  
> +PCI LIVE UPDATE
> +M:	David Matlack <dmatlack@google.com>

Please add Pratyush, Mike, and myself so we are notified directly of 
incoming patches, the same as with other areas where the liveupdate/ 
tree is specified.

>
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> new file mode 100644
> index 000000000000..737e7b9366db
> --- /dev/null
> +++ b/drivers/pci/liveupdate.c
> @@ -0,0 +1,145 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (c) 2026, Google LLC.
> + * David Matlack <dmatlack@google.com>
> + */
> +
> +/**
> + * DOC: PCI Live Update
> + *
> + * The PCI subsystem participates in the Live Update process to enable drivers
> + * to preserve their PCI devices across kexec.
> + *
> + * File-Lifecycle-Bound (FLB) Data
> + * ===============================

...

> + *
> + * PCI device preservation across Live Update is built on top of the Live Update
> + * Orchestrator's (LUO) support for file preservation across kexec. Drivers

I prefer to just use acronyms FLB, and LUO, but have links to the actual 
documentations about them.

So, something like this:

  * :ref:`FLB <flb>` Data
  * =====================
  *
  * PCI device preservation across Live Update is built on top of the
  * :ref:`LUO <luo>` support for file preservation across kexec. Drivers

And also add _luo and _flb to Documentation/core-api/liveupdate.rst

.. _luo:

 ========================
 Live Update Orchestrator
 ========================

.. _flb:

 LUO File Lifecycle Bound Global Data
 ====================================

> [ ... skip 17 lines ... ]
> + *
> + *  * ``pci_liveupdate_register_flb(driver_file_handler)``
> + *  * ``pci_liveupdate_unregister_flb(driver_file_handler)``
> + */
> +
> +#define pr_fmt(fmt) "PCI: liveupdate: " fmt

Nit, may be:

> +
> +#include <linux/io.h>
> +#include <linux/kexec_handover.h>
> +#include <linux/kho/abi/pci.h>
> +#include <linux/liveupdate.h>
> +#include <linux/mutex.h>
> +#include <linux/mm.h>

Please sort alphabetically.

> [ ... skip 12 lines ... ]
> +	 * future to increase the chances that there is enough room to preserve
> +	 * devices that are not yet present on the system (e.g. VFs, hot-plugged
> +	 * devices).
> +	 */
> +	for_each_pci_dev(dev)
> +		max_nr_devices++;

I think, we want to use kho_block [1] (it is in liveupdate/next branch) 
to allow number of supported devices to be dynamic.

To support this, we would redefine the ABI and tracking structures like 
so:

/* include/linux/kho/abi/pci.h */
struct pci_ser {
	u64 devices;      /* Phys address of the first block header of kho_block_set */
	u64 nr_devices;   /* Total count of active preserved devices */
} __packed;

/* drivers/pci/liveupdate.c */
struct pci_flb_outgoing {
	struct pci_ser *ser;            /* Points to the FDT/KHO-allocated ABI struct */
	struct kho_block_set block_set;  /* Controls the active blocks on the fly */
};

In  __pci_liveupdate_preserve_device() , we would search for 
and reuse any inactive  pci_dev_ser  slot first, and only call 
kho_block_set_grow() to expand if no inactive slots are available.

In pci_liveupdate_unpreserve_device(), we would simply 
mark the  pci_dev_ser as inactive.

>
> diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
> new file mode 100644
> index 000000000000..8ec98beefcb4
> --- /dev/null
> +++ b/include/linux/pci_liveupdate.h
> @@ -0,0 +1,30 @@
> [ ... skip 24 lines ... ]
> +static inline void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
> +{
> +}
> +#endif
> +
> +#endif /* LINUX_PCI_LIVEUPDATE_H */

[1] https://lore.kernel.org/all/20260603154402.468928-1-pasha.tatashin@soleen.com/

Preserving: In  __pci_liveupdate_preserve_device() , we would search for 
Unpreserving: In  pci_liveupdate_unpreserve_device(), we would simply

Preserving: In  __pci_liveupdate_preserve_device() , we would search for 
Unpreserving: In  pci_liveupdate_unpreserve_device(), we would simply 

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

