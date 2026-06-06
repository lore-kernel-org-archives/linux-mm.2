Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AE73CD8C85
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 11:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4416B0005; Sat,  6 Jun 2026 07:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374D96B008A; Sat,  6 Jun 2026 07:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2639E6B008C; Sat,  6 Jun 2026 07:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 160A16B0005
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 07:10:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5716A0444
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 11:10:42 +0000 (UTC)
X-FDA: 84849219924.12.7F151D2
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id C46E540002
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 11:10:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p4W7WVGw;
	spf=pass (imf17.hostedemail.com: domain of praan@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780744240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1UvGUn3KRDrygvBE4DSDRKEnm/sK5Y67p5+Nbu/YEQ=;
	b=qUmZczKTSiXFEvCUt8hMTzp6INj+JRlrImZiu2LXgtMrj3LrXoWiIFO2kAW5wIUdhy2tF4
	06aLiAv7xmc1UWeRH8vjyMGjDUChPYAnVI4mfBvZWMqnMVU6UuwW2t3oZl2WBoptP4Q3fL
	5yMgUOeKR1KciFuczCytG/ZI/ulOxfk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p4W7WVGw;
	spf=pass (imf17.hostedemail.com: domain of praan@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780744240;
	b=vCLKgPEz+a8uv5I27xiXv3fiVCDsbssAPZp3XHNDnpWkW4lWUKyTZn2ccxRY9CaS8x9aMw
	6P4sqBD7cXQS46usXsnCiNZU9gEjmydeSodFNAPz7U15ojhpOJjKUiOgeNXZMiDoxWF11Y
	VuFnS9DK9+LOeoCTNH8Opb7GqAUQNxI=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-133362c30cfso19656c88.0
        for <linux-mm@kvack.org>; Sat, 06 Jun 2026 04:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780744239; x=1781349039; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F1UvGUn3KRDrygvBE4DSDRKEnm/sK5Y67p5+Nbu/YEQ=;
        b=p4W7WVGwe7JTkacAOS6AHZUoM0lzTEfei7RaG75ZbdHeKTRrCpUoVoG5GOgyVaofDd
         GYo8KeQy7Qvlb+pUoWOsn1KKLYZ2WyVmj94ZQXhB0ICP7wyWBF9efZQQE0Sr+x9R/OGc
         ilEznxWlsZVvHuzKACK8OHjnxpij8d3Nz11yHlzAXNt83YT05p/nllRWy9a7vRMU42Rs
         Hl9q+rK6iZSktbyFC7PZbY6rNDXFIvDgF0Yfysic+Gxqnz5LPsQoX+MpptyZglbDAyF7
         WS7BgZNcsA1dv51ZheYbI+QJ8DW7UETcCZzTWZ8Iqv2dpbELDypSB+auzRfwKX/lX4Uy
         dO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780744239; x=1781349039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F1UvGUn3KRDrygvBE4DSDRKEnm/sK5Y67p5+Nbu/YEQ=;
        b=irju79aSK63Z3MJX+LTrXxplqNvCL7hN6mwD4kGooNADVhuX+DSd0urekBjMITV9TU
         3MtOL0h9Qu7XkdmpiXVuHB20O4s1qS/4PNXLYstLInFCerdsdYGprwBMaC/vMTF/a7vQ
         02qty51np9ZAWmgxW7YUCqObhTbWC+h/OA474watR4mB1Gzh3h8Uz14ZtZU/QC7Vtiy5
         fz9PcLaL1ZuAXTNke8/b0HoHPOhttsHCKR/05xes3/STrQpQsl4BViFE9cHWKkIxHhJQ
         BOgVX/UqdGOWQv5BU52a+IF7VKVUILzO+lR1vmhfMAsHx1stbs+U6sw2HQsnPHrWkIJK
         y7VQ==
X-Forwarded-Encrypted: i=1; AFNElJ9wTycJ1T91RgJxJ/U+KtAQzY5Gb37+9pWgeaQA8Yvbr9KsllzikiukfTNxXxxU9Giav100gl4rxQ==@kvack.org
X-Gm-Message-State: AOJu0YwefCwFFb71igLeKrvFtqEnx6ht9Ulc5hxt510SsIIMXe/6ODaB
	l4IRn1pNOnN3rtkv4txLwtOgNw5Q8TY2Ugd/a0kjeHZn3fqMpKnm/VJucLmfpfDcQQ==
X-Gm-Gg: Acq92OHy2+aWNVLmVXuZ2fumQWOH+ZHsequ6xbWHyFn2kPiYNc+kaSI9mFp3nEKtyCd
	U3ZBK6LnZ9tFpcpwc3BXml6RAnG6PekdR3tZ1kSVNwXgvHWiIHf0Bw6wetP+Zjp1jHCOYnyJimw
	G4VrG4UMEwMf9AMQvJCXj7v2piUVpuZx/Ii10uxvOsOiNHVp7Vf09lW5UKDoTqyYUsLFg9OV5Vo
	1UXPQP/4St7zLMGvaLUqpfHkAKTMH9FDVFNSmeYUzh8gjvQDyefHeSWoM5vsAGs3T4QjQOKNCtD
	bQT/NJPZtTfCb7odsqZoOuEkrRIygpxKHQv05pPF5vXq8566mF6SdhMXw1m5tH0CzhJKrtPyI3r
	V1BV/bMOv24nLiq2PWeS2H8EEEdKVJFObyItizy/AItYXFmCNc6mGmWiUjdqJ2us8NOASRjAdH9
	CGKMBpUXpS4M1kPEaTNhfAekTAou4KFwG8M0WtxEL75VWXEiOAUifc62KTGd0HHSRUxxNjUlTTH
	4ARBJZqZQ==
X-Received: by 2002:a05:7022:38f:b0:133:12e0:aab7 with SMTP id a92af1059eb24-13807c6a877mr251422c88.11.1780744238685;
        Sat, 06 Jun 2026 04:10:38 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13803eb106esm4391089c88.5.2026.06.06.04.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 04:10:38 -0700 (PDT)
Date: Sat, 6 Jun 2026 11:10:29 +0000
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
Subject: Re: [PATCH v6 05/12] PCI: liveupdate: Keep bus numbers constant
 during Live Update
Message-ID: <aiQAJRINEKiwCmVm@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-6-dmatlack@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C46E540002
X-Stat-Signature: 4rf3azrw3bnqx6p3bagzk68df1bkneyy
X-Rspam-User: 
X-HE-Tag: 1780744240-23237
X-HE-Meta: U2FsdGVkX1+3ZdYDPCMBYwJvs89/fI5lrnNVaLU45Qbuo/snpoccnrQMwjYWnstI0U8EEZf1HRR/qEL+TlhbKqTfaWLvESCosTfaRsNtOwUF8Tik7zRu/oQrB+rZIPuutLgjeKniDv4apqLOqdj4NALChR/NsDjtVClnvmKBE9PzaUgSPwIyz9Oqz+Z0YrqkGk2SF9fk9aa5MS2sGzVosL3M4fJ1WQLtILqQcbx5+EUN50Us6QxGVJTJJ758uzhmXu5lyuz1v+HNxEH3uCS5rsWoti+fwMnKpgyUhZmwEn5687NzSzdHet54JJSsuJ6RgVW52fV4fpTmAQNxe9CrYqwoeUx3444YatpPROY9YRFH/N7IlzNiES9bkZ37eBpf0knnmKxkOpWAOhRSE1SIWJSgnBvUaG8hbbfPvM8yHJB7ZgLpcrNo/ifRc8t8ouQe9EDygZmzC0L5agXNOnbgXMrtFCpEf0uypw27eElnRNv5huLdU3EF+zyKNymfLBYAMBbJRbWvcfq8WKu3NhyL9+Dr3tZL3ZA5ZeP6K6DS4J+82mlhh5S+4Qt6i7oBWIZJ0+3jnaRvZUuseO2ycyQttxTFAgzXaVBjPH/uRo8M9xpYYRQ4Zlflnkxpfz+j952ukICuK1/2xeoZDrbLwM9M8JHqJZDBmkp1UD1QtQvpteupQpB9dHMgEC1GRVCswzdBOZj0+A7wf/jODNE6Qsyx+c1cWncY9IAdmQldMBOH7/tO+Xr2ZJxlADwtxYIY19kXf/cN0FThJFCVGp7pBnxv2FpX5AVt1swZ3yP18vUiUf8EjNdSHcL6ts/WOjnnlWUdohfwsylj7cmHgozeaHln6SdwFC0y4QJHNgUNrtzlGFSxZv7rS66kZsD6QISKYP6HnvQWXfIalDcG/dk/edvrZL/4vaBVx6xKzVQuoQvzm9eh5w/fJ0/X/NQx/G0eNpdrniCZzAQkuITQXjMEL25
 oVZ+662m
 Flji+V/gDLuJsz2dzFhGBg7aeKGuhGS3UBifteMlBdRxsPZYHV9K+RGOK6jpkLf0hudTomdxvWKt+FRN5AzVepGuFcceFsAkcQukzCO+glk6uHnGi3zC5UUICH9yCJ+syupLjV/QGmlH+T519IJEON/2n/JB+5d4mUqKWhqRLsF1zuLbcbRbaqNkTuMUIbO3rYPpWpa03GPTzXNQQNWdjrD+tWQmIN363KJc8+AxBVGhY0FLan2aTswdUBsQwid///dKcaRvVyl7DxV2wp30ogn80ULotLMkHA0ZlxJKlCZHSXC4qoKc1IGFsPiFcvH/EtZPHlfREtabB4TdDxOUUMSSQOCSBOqcd6edP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:03PM +0000, David Matlack wrote:
> During a Live Update, preserved devices must be allowed to continue
> performing memory transactions so the kernel cannot change the fabric
> topology, including bus numbers, since that would require disabling
> and flushing any memory transactions first.
> 
> To keep bus numbers constant, always inherit the secondary and
> subordinate bus numbers assigned to bridges during scanning, instead of
> assigning new ones, if any PCI devices are being preserved. Note that
> the kernel inherits bus numbers even on bridges without any downstream
> endpoints that were preserved. This avoids accidentally assigning a
> bridge a new window that overlaps with a preserved device that is
> downstream of a different bridge.
> 
> If a bridge is scanned with a broken topology or has no bus numbers
> set during a Live Update, refuse to assign it new bus numbers and refuse
> to enumerate devices below it until the Live Update is finished. This is
> a safety measure to prevent topology conflicts.
> 
> Require that CONFIG_CARDBUS is not enabled to enable
> CONFIG_PCI_LIVEUPDATE since inheriting bus numbers on PCI-to-CardBus
> bridges requires additional work but is not a priority at the moment.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  6 +-
>  drivers/pci/Kconfig                           |  2 +-
>  drivers/pci/liveupdate.c                      | 83 ++++++++++++++++++-
>  drivers/pci/liveupdate.h                      | 14 ++++
>  drivers/pci/probe.c                           | 17 +++-
>  include/linux/pci_liveupdate.h                |  4 +
>  6 files changed, 119 insertions(+), 7 deletions(-)
> 

[...]

> +		incoming = pci_liveupdate_flb_get_incoming();
> +		if (!incoming) {
> +			dev->liveupdate.inherit_buses = false;
> +			goto out;
> +		}
> +
> +		/*
> +		 * It is safe to sample incoming->ser->nr_devices and then
> +		 * drop the rwsem since nr_devices will only decrease. Thus the
> +		 * only "race" is that the current scan will be overly
> +		 * conservative and force bus inheritance.
> +		 */
> +		dev->liveupdate.inherit_buses = incoming->ser->nr_devices;

Nit: inherit_buses is a bool, while compiler will handle it correctly,
maybe we could:

dev->liveupdate.inherit_buses = !!incoming->ser->nr_devices 

OR

dev->liveupdate.inherit_buses = (incoming->ser->nr_devices > 0)

for readability?

> +		pci_liveupdate_flb_put_incoming();
> +	}
> +
> +out:
> +	return dev->liveupdate.inherit_buses;
> +}
> +
 
[...]

>  		/*
> @@ -1497,8 +1501,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  		 * do in the second pass.
>  		 */
>  		if (!pass) {
> -			if (pcibios_assign_all_busses() || broken)
> -
> +			if (assign_new_buses || broken)
>  				/*
>  				 * Temporarily disable forwarding of the
>  				 * configuration cycles on all bridges in
> @@ -1512,6 +1515,11 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  			goto out;
>  		}
>  
> +		if (liveupdate) {
> +			pci_err(dev, "Cannot reconfigure bridge during Live Update, skipping\n");
> +			goto out;
> +		}

Quite helpful! Thanks :)

> +
>  		/* Clear errors */
>  		pci_write_config_word(dev, PCI_STATUS, 0xffff);
>  
> @@ -1572,6 +1580,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
>  	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, bctl);
>  
>  	pm_runtime_put(&dev->dev);
> +	pci_liveupdate_scan_bridge_end(dev, pass);
>  
>  	return max;
>  }

With the minor nit above,
Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

