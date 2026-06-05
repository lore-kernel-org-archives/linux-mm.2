Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 372D7CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 06:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7285F6B0005; Fri,  5 Jun 2026 02:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700C26B0088; Fri,  5 Jun 2026 02:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615DD6B008A; Fri,  5 Jun 2026 02:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 519406B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 02:11:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DEA2C409FF
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:11:32 +0000 (UTC)
X-FDA: 84844837224.17.AEA6B4A
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 10A5D100009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:11:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KC84OBwH;
	spf=pass (imf14.hostedemail.com: domain of praan@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780639891;
	b=NCcEpBIPTEbDFyMAUZKsREsUYGSekaMsLeTz0ixzEZd3rCZMOW1Ygew56qCGXz30Kaxk40
	4SyIk4LXC6f5Gge5XeEke9xq6LxlMquH2TaFw/Ne1klHhZ0mX+m9e9Uw4icFrBiIzIAaWH
	AvMgbo/T/KT+ssLaxWScVNi+DUaTgxQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KC84OBwH;
	spf=pass (imf14.hostedemail.com: domain of praan@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780639891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+JACYJJsZuvAWWpivo6XAMCeidn10mj5aCjcUHoRua0=;
	b=04GFcGYAhk+bko3wW0w62/zLoU1bpjwvq4+DaiDX2qvghZUD+ClRVWiMtYZK2C1CmTlFC2
	zp+kIS1feZFfWTgvqSKadatgGnfc9dIG6EZufQoFUWlUProN6iWieeNqmINM+0liE+Xfmu
	nrhrG/6EKlOxhOty5Yg9CipTLNcINAc=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-137ff9a7d5eso6268c88.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 23:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780639890; x=1781244690; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+JACYJJsZuvAWWpivo6XAMCeidn10mj5aCjcUHoRua0=;
        b=KC84OBwHcDG2R8uLNV82+sLPqoolbpFOl+9YTcvwhTbKjZWFs/L9y6C+ceNVS5PiOJ
         C+Uki494XELiBhVEdh6xDWpouP9bYm19ujw3Hv4yM/OAxUAZZUo9OOpI8kSt7Het8yDq
         jd2QJ6PPNdHyudKCgRkNXdW05BS6FRWCkRNjrMlKRJaj5i4pNcJHe67gJXQI2TStBR9r
         Wl80SFnsfxTIrYUR0AmSIPWe1LyAqj41ZS4fm/WAwSyF4cDLuHYm9Ff/UQ3GPixj8l5+
         IftZpPrTHDWkd2j3yqzjv0DQBwdGyZDXbPuc4cqmMDkS8fkahi7gXSmLcotkOf1PVeC5
         uA2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780639890; x=1781244690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+JACYJJsZuvAWWpivo6XAMCeidn10mj5aCjcUHoRua0=;
        b=X73CdPBt6rHjcP/V39Fj+TKta3QIaPMZRX4aCzwy6UOvHD9e0XmragHFHRHRgURqwK
         YvMcVOFZRher59l5N4ppykkS8ee2pzqtd0/R5uTCfSlXACHXB076sNZ/zfH74Vp38Okb
         Vv+UBG2n0OU4D5jj0IfZBVeuDVCrrYDXcphOGk6ZvPFyrhB9PwOjzgOF0qg7m8aWGTus
         uxg0vevYfrEH6YyLETObtwzt/BNA8trcy30DMl698Za/EzE05iFyV6ofriItKuWmIlJQ
         VcwF/IDAUQhX6phEsOWMmPTubawiGnpZHIYdfTLTk/KgAV7AaD9U4wQKMkZiGfui+Jgq
         PiPg==
X-Forwarded-Encrypted: i=1; AFNElJ/hZwVXc0lontyLLaudMEOhvqzkq7vX3XgJKMlgko8cI+Nok55OtzXj9sK/yaB2b0QYvJ7vC7arcQ==@kvack.org
X-Gm-Message-State: AOJu0YzlfGW9E4efOVqGzFJ0LGkg5MZAT6JX/6Le/m/8/xF6XubKxqyR
	w9fxEw3nws3jIxWOR+IR4g3ImpKVd3FGjz0r0feMnChU1JBtMIuG6DO3G6PitpsABA==
X-Gm-Gg: Acq92OHxlRXMZ1qqhORyzki8rACEGFhyBZ1YqLkf9nrhQY4XZOrEqfieu9LSt8P6Zko
	SqGHKJHEanMmQ2qHWRsX4Ip9r9LdtpeUpJsLh6Ru/moHEyV3RC4xtDodD+8QVw0MBJf11AkmruS
	VbG8jG3vphMVxweCMyMwCk5TVsmfoVC9yqFr6Pk4Nqz8DLC5SmnqdYwzQc1EKgllO3UcW3McsJ0
	ozcdHqFv32655Ub6XCnhagxa6CcpvBnHnA+mjtVsJ4svsbX26R8hw6+mmbYTXsQTyi6VBnKbeKO
	HI1z3JtJvDzrqRgLOV/Z4PsstWTOY4ehYiuFheEjfxN/JFLwzvUGM4XiH6rIu+yoZUqqtQmS4Tw
	IIkb5AUafFNlVwrk4watTQf6gFKerz8lTQPugmTxrlY32NA3oPhlesdsGUo1TxaJmErB6U2nLcx
	Igbm2zbghXw9tU1kBi1jXDQPfvws/3XXy7fgdMygQ+H3ANRn4vglYbJiThLAPLr4j8tEJngSE=
X-Received: by 2002:a05:7022:6289:b0:134:a710:ca44 with SMTP id a92af1059eb24-13807ccb5f0mr74668c88.18.1780639888034;
        Thu, 04 Jun 2026 23:11:28 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074d9fde90sm10632107eec.0.2026.06.04.23.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 23:11:27 -0700 (PDT)
Date: Fri, 5 Jun 2026 06:11:18 +0000
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
Subject: Re: [PATCH v6 02/12] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <aiJohr2dD6Jf8m3r@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-3-dmatlack@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 10A5D100009
X-Rspam-User: 
X-Stat-Signature: 4i39f4zr7njm9o1o94id4bt55g73dyy9
X-HE-Tag: 1780639890-527268
X-HE-Meta: U2FsdGVkX1/1Ke1pwTSnSYUoIvGZ6j6JJA+xZk6k8rTxa1cyIdybaC4OHtMnEVsCBinOxDeVctTjiQ+6KnNKfumItwR0Kdo0TnknyOnxU1vcXpeRrI2q2vxF90Mf6Jfb+VxGVr+mqQqamZYfULmWiVaazX81ddDRnMx+O18fXOViIYrMo3zhb9aWib2Z1PEstl/6XgaVeOJDPfwT2SXNW1s8n2HXVN+aqY3mahJzRV5F++tAQRHCTw8CF5Eppj2fK7Tl4Xuov5wWtSaS5TTYoOxjyw8Oughs3higzfbjsdFquZpLpl/DfZr5un9NYrn6l1XZT6EPkDyeUAQVOQpSlBquzXCxS0cYbc8jhGUKNWUQljs5GIxpJLR+LwkV69G5tVrkvgp5IL3R2gGJadn6KrCJ5rcDZYy7UXPFv37jvvX8fdKHucZoxqaVOf/n+TIxvKGeeJCS4n+0nCLjU4L7A0aJLtQTl9jO/qcy77r2sg2bMP+xX173ao9tS0DUa2dIrBHd6WOXT2htZf0YnouOlvaFH6HlevgWUgunmFzce+Dmv6KFT9HjTFF8c/hILUTwHzYiO2jt8ZKIPQ62tFDo3qEI0geW16gArMGU4I/hkbB3CnyLR8O1BKJ8qvrqBSsGg7oiMFpnR99dbgYxSwbkEFwo/q2eblURGwkd+n0OlJtciqIvgJrG50SJT/kjdtXCSOp4NZiqF9m62u7wgCP5U3g5dqawWdEzNhS3pg0u5fmL5URyl+rQIZ4vpvm5k6ND2aTlMNlTwTqjNWdNpc2ZBfe9Ya7tfpQ9oOvD40Y7vW2qLfYV07lUnepE/b3M9FniELaogDFbyOl7lWxhoabo+rX8K3+fD/mIkB0En5UdZKOSX3W0QMReJddYzlnwgS/mB8xESvv6/y6vELswnhms1pGBYCx96RYH7j4/GmsSDGtK8IJxy5i8eE3QFIjSqVluTUbRljkVJ5lRxkZkfrJ
 0NhEf9/X
 uPnBHm/R9pofwrx1fekIt19Ud8uVT8XGmC9s7CYVTd916F5F14HV08Aw0CTXgnICHlfPCeEiJcCb4c/i1dFUPGfdSx4GbRy+/R2ZNZuu+9VfU3upoD9ZOozglCsZDMn4jdILU2qTFoTY1RaPK10oqROV0TdTV/pI1oHh4FjyLeGgTz6zjaT4aMmcZLCEP2edDvpSuZ8Z+C+dqZRd9i81wxskuIkU9LXx93x0ZSQhPB9iy37jPSeWfW43oODgQdZvbFSsnHzITsfxsNyGTjVFcH5ELjlqO7YuMWdz4g1hJSRq/XeutlJkWWEuk13jXLMRqftiMJfxNeU6s6MH3MO5Z5Ut3QEQJYHrC6Wy0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:00PM +0000, David Matlack wrote:
> Add APIs to allow drivers to notify the PCI core of which devices are
> being preserved across a Live Update for the next kernel, i.e.
> "outgoing" devices.
> 
> Drivers must notify the PCI core when devices are preserved so that the
> PCI core can update its FLB data (struct pci_ser) and track the list of
> outgoing devices. pci_liveupdate_preserve() notifies the PCI core that a
> device must be preserved across Live Update. pci_liveupdate_unpreserve()
> reverses this (cancels the preservation of the device).
> 
> This tracking ensures the PCI core is fully aware of which devices may
> need special handling during shutdown and kexec, and so that it can be
> handed off to the next kernel.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

[...]

>  
>  /**
>   * struct pci_dev_ser - Serialized state about a single PCI device.
>   *
>   * @domain: The device's PCI domain number (segment).
>   * @bdf: The device's PCI bus, device, and function number.
> - * @padding: Padding to naturally align struct pci_dev_ser.
> + * @refcount: Reference count used by the PCI core to keep track of whether it
> + *            is done using a device's struct pci_dev_ser. The value of the
> + *            refcount is equal to 1 when the struct pci_dev_ser is in use, and
> + *            0 otherwise.

Note to fellow reviewers: This may seem like a bool instead of refcount,
but this is changed in Patch 6. 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

