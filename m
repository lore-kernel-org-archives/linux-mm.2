Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38CC8CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 05:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE5D6B0005; Fri,  5 Jun 2026 01:42:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795CD6B0088; Fri,  5 Jun 2026 01:42:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB866B008A; Fri,  5 Jun 2026 01:42:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE9D6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:42:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07A388B05C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:42:08 +0000 (UTC)
X-FDA: 84844763136.25.5A7985B
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 27D5C14000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:42:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XUFjbc2G;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of praan@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780638126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rbv0AZ2j24l1SmU6m1H5V7hzpCBteEa/IZu6sKIRnTI=;
	b=1ta35jkGMYPRYOVC11DRjpyyPKTilUyHs8f6jm3KcbFOqBY6ThEzHsTTaONbWdYWUb7Ml5
	Nex6SDrATk7mE9Tbj6XrudmnrgGEz1Uleb6eaXpFBidmuDiS1xucDzA/wFx5ynAcpRypQi
	xnAE5GdScbP32t7tDqpRHNavk1G9pBE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XUFjbc2G;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of praan@google.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780638126;
	b=gTryKOrciyYNq8c6rQ7SiDPBa/i62jqEWTRCUAUIpnjmYqZPSS02VokA17CMShtsIoKHvH
	6+zahkRoX9UuAcP/xGdgZ7nIl4sC3CtaveYgKPuZzxPMDaRRRhLVpnZdCZtvzmxGNijG+i
	4r0m43igbZ44tgHzatS9CeFuxY/07rU=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-137ff9a7d5eso6093c88.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 22:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780638125; x=1781242925; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rbv0AZ2j24l1SmU6m1H5V7hzpCBteEa/IZu6sKIRnTI=;
        b=XUFjbc2G/2eIABp0YZZwqGxapnv8EptAm7JxVYDIG/zn1c8qlq/++UKk+nqea+oiqu
         GI3i4QJETlh/2U0U44LKviLwbgoMpYcNSurDeZ5Ed8vZU3+PPTj5hnKCmZb0PdoocXak
         jVlAbE9SipYzfeA4yk6zq/qkOnp8ehHacznxhJt7DcAWuAkXWxDez/RbL9A0fES67Nfw
         V9c6kdFVBBozrDWvAEjfm5bcCJdN598d1Ka96QGc3Gcos+hcu+/BnRy/EgYOdmG0LkDZ
         02KfaOb5YKpk1yGLquUifiuV7CPJao3UiGHVKcI2wwA8Ag5tu+aUJ+54A2hXC6/LN7tV
         Zv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780638125; x=1781242925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rbv0AZ2j24l1SmU6m1H5V7hzpCBteEa/IZu6sKIRnTI=;
        b=tESgIgfG9Mum7c7xHnzbH+9PQiKunpo4bn8gz9C9b5rzEESukxn0RQ9ZcGmBmNsKKR
         bPjQoklc2sEB5tOVNqchMEJBD669+IGF0GRkdd91XtMaVZW597RLD5rqr0E/cyOw9egQ
         +8b3aB44An13/0mEkDaXVUrk0UJyoj457GKdQoJDbgj8YO4WYzlPCBepeAZhz2KGHLun
         so08MQvOoycfIFbn4/JDcH+MOCkTZUx2NSEpxCY/0Zc4C+x1fdYdW+olaenLOw1k1DQ+
         FRXKkiUlyjrrOWj/eFuCuuESFsh8CnybiXS/6eiqkwMsJQrlVdLY01HG9E09X3S8JuTG
         S31A==
X-Forwarded-Encrypted: i=1; AFNElJ88yHp2RQz5YY+XiKNU2kchOkq2XjyfYlCYsVpNNjwgzfPluho7E7QqhjHq3kTdfOnmRTJ2vUshrA==@kvack.org
X-Gm-Message-State: AOJu0YxA3iP2FMIBO4HfvcT0V/S4JNmJqGVwwPgMi11GyrNUN4XfzdiN
	zYRFYNcdeLGEk7UO+XgwQ9+J4elU96CMTsPGPwupVOqnwZkvevR8/j+QlCgZHmUhKQ==
X-Gm-Gg: Acq92OEPxylM9Fm+XNoNtqZJYElUkSGdzecGbxv6TXqhcC7ap4JuPM289EmGM3Tu1ts
	dEa7ACRwHbPaiZi2Cw1gfGJh8xUeeyPsUAqLXOS5PS5zXKz0jhpS1mO6/uRkuGPycZdsSpNXXt6
	KYgxbcLtbbJG4gjbl+WYy1yQQpUO0BxvzJqxyRgn5W/y/zI/ZACzuqVJYGqEBDS7V7Ofc2n1plH
	pZmVAPCxLoizzuZmfZ/EgJtkQ0LO9AFN3xzpXc632roVUBiZxM1KchnD2EeVcBIo0CZyvo0IDkL
	BIh0ZQIoL4JWcQln/9FyXD1TdBsnaeqFhyYKU6WgZDEM6426LVpbXAZFGz7uQLdXhLL5l8Gah7n
	5erOsO8LkTfFqsoiEiau2e5GBUDp3nhI6LU6j5Eu+E/NclMNzXMjRIRDSk2jxYt0BXFuc/myMho
	dgYSfLYDtACRdnxvS4y70hHmJNWBzSNDwoSTcuSjiE3acTJb7SjoOVsANCgo19JBtHLqwztYM=
X-Received: by 2002:a05:7022:107:b0:136:d02a:67ee with SMTP id a92af1059eb24-13807cf45e2mr63052c88.24.1780638123822;
        Thu, 04 Jun 2026 22:42:03 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074deaab1asm6539103eec.17.2026.06.04.22.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 22:42:03 -0700 (PDT)
Date: Fri, 5 Jun 2026 05:41:54 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <aiJhoq_Yj6-1Hl5r@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-2-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 27D5C14000C
X-Stat-Signature: zdzupwm8httprwcy9ir4eqwx1rmk1j9x
X-HE-Tag: 1780638125-156620
X-HE-Meta: U2FsdGVkX18RrsUoxJ8/h72YL/4Id/bOlSaWpUV/506bSnFzTI0EF4ckyit0Hibm54hAlU0I0TBHbKeuHmzLrDbXBBmvxINu8v+n50OKF6fFKfkmEy6QDBP+UgJdUJJW0ppD+6ANmug3ps8gAMR0MGSnANzJk4t387HBsa6BHPwS/fTqCdvI4kmapvUqkmW4cV+Q6cxDbUIsgOjQkO+QUGIRyiGXgarVWF0ruTij6p0DYwCBjCqP9WfTfxzVJYwWAKMsJ6WSjeZFCCVBr/oaWsmcj5t7nMk3kyHS9G0iQd4tUndFLoPau2TfPRja1q8sRqcqT7wPBX10uUfx3p8KiRRU3atPntSrYHgycVXjfFZtrBs7Li9yNP8lFH0ReH3iJbCnzhgOSKsr+LViXeUmrUGDMEXebEkZCPNKFQcgJZx3C7BCE37acQLL01QPGvMlLjDRlMHc13CaREW9AxxPemM5ca6qVbvNDOaDiA2MKn5t1ZgizsGDf6WsUkL0gszi+VckMRi7OEoXBwlnJwF2LyRj7OCuF9M8mbwbKgQ4S9JrtTlo/hjOry8WROWlElJNUfilurJd0blNLugiAzbx3Ni1av1cGYY4OF4fuGyVAE5K+JeeQZLMPrCJdUREPhZ1xYn5bCqtqyb7C8Q/GMnS8AVK0UYnyKS2f8I7XFFMyLmRjhSGKdHS4xDPQdH1wmMVuBjmGQPjS/heiypZcnfpwRhH0JsvcXRAA9yLFWGNlNxly4meu5tIt2o17yYjDbTF67wvbMyz0dll72mXNtDcnjCnsUJ9ywJTMc10WfcJ1LTvlZVJTcEzgZxO4yeIizVbYRF0r4d52JCFUWVN553wMr/IU8O5y/LsQfnQAX6+n93NapEBe0Sdl4k8mIYAwhAjFyxNoRT9bk9J4g5690YuTARXkNlElhXZmqvgu5tzmEouqbgUJm93EeRPCF5QvLlAI5yNpCaKlT02lChDnqg
 fVF6p2XO
 SfG/Ukz9896NG+iVSPKCRsmzdvrUeuibDXy9R7Bx+4Y2qJgvCZ8tOgxJORlSCyrrqX3Xu70BuGY4XPdWB3ITA/sUV37KGUubK3lr1skuoZh0q8wT9+mm9LDJ2s5JyAvZM4JlJNOllKGRkbIsY9ge49GPgVeCidZxknK5XyXuOXj0hlGiQP9xyM9f1V/UmMYm1tSzZlCWFVVzeAOvg2gV5J//RElRMp+m9k2xE0/CdqJ47JOKkRLJvJs3h1gVHKSb0+7FBYiQ5O03MCPTNVofN7EiUKthikppxH7Hh8iwW+e/Ufb3cE1oWhGUJUkmD4FWnoZEPBym4Nr5sxgKZTsWwIscP/osvQnQydoEf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:23:59PM +0000, David Matlack wrote:
> Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
> it to participate in the preservation of PCI devices across Live Update.
> Essentially, this commit enables the PCI core to allocate a struct
> (struct pci_ser) and preserve it across a Live Update whenever at least
> one device is preserved.
> 
> Preserving PCI devices across Live Update is built on top of the Live
> Update Orchestrator's (LUO) support for file preservation. Drivers are
> expected to expose a file to userspace to represent a single PCI device
> and support preservation of that file. This is intended primarily to
> support preservation of PCI devices bound to VFIO drivers.
> 
> This commit enables drivers to register their liveupdate_file_handler
> with the PCI core so that the PCI core can do its own tracking and
> enforcement of which devices are preserved.
> 
>   pci_liveupdate_register_flb(driver_file_handler);
>   pci_liveupdate_unregister_flb(driver_file_handler);
> 
> When the first file (with a handler registered with the PCI core) is
> preserved, the PCI core will be notified to allocate its tracking struct
> (pci_ser). When the last file is unpreserved (i.e. preservation
> cancelled) the PCI core will be notified to free struct pci_ser.
> 
> This struct is preserved across a Live Update using KHO and can be
> fetched by the PCI core during early boot (e.g. during device
> enumeration) so that it knows which devices were preserved.
> 
> Note: This commit only allocates struct pci_ser and preserves it across
> Live Update. A subsequent commit will add an API for drivers to tell the
> PCI core exactly which devices are being preserved.
> 
> Note: There is no reason to check for kho_is_enabled() since it can be
> assumed to return true. If KHO was not enabled then Live Update would
> not be enabled and these routines would never run.
> 

[...]

> +/**
> + * struct pci_dev_ser - Serialized state about a single PCI device.
> + *
> + * @domain: The device's PCI domain number (segment).
> + * @bdf: The device's PCI bus, device, and function number.
> + * @padding: Padding to naturally align struct pci_dev_ser.
> + */
> +struct pci_dev_ser {
> +	u32 domain;
> +	u16 bdf;
> +	u16 padding;
> +} __packed;
> +
> +/**
> + * struct pci_ser - PCI Subsystem Live Update State
> + *
> + * This struct tracks state about all devices that are being preserved across
> + * a Live Update for the next kernel.
> + *
> + * @max_nr_devices: The length of the devices[] flexible array.
> + * @nr_devices: The number of devices that were preserved.
> + * @devices: Flexible array of pci_dev_ser structs for each device.
> + */
> +struct pci_ser {
> +	u32 max_nr_devices;
> +	u32 nr_devices;
> +	struct pci_dev_ser devices[];
> +} __packed;
> +
> +/* Ensure all elements of devices[] are naturally aligned. */
> +static_assert(offsetof(struct pci_ser, devices) % sizeof(unsigned long) == 0);
> +static_assert(sizeof(struct pci_dev_ser) % sizeof(unsigned long) == 0);

Minor Nit: Shall we consider using specific bitwidth types here?
I'm wondering if down the line another u32 field is added to 
struct pci_dev_ser.. in that case on a 32-bit machine 12 % 4 == 0 but on
a 64-bit machine 12 % 8 != 0..

[...]

With the nit:

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

