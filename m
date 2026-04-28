Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 830ACFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 17:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A696B0005; Tue, 28 Apr 2026 13:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A119B6B008A; Tue, 28 Apr 2026 13:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927866B008C; Tue, 28 Apr 2026 13:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 83FF96B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:36:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 292991C04D1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 17:36:00 +0000 (UTC)
X-FDA: 84708667680.15.966E63E
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 560D320005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 17:35:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uoRwICum;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777397758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ncltMbqb0oRbMvugQb2r0egpAWKoVDCs8cMwwYz9oEg=;
	b=YHw/U3NeiZd/gmYOytya4JHoZiFO1DNE3mS3goKIPQ9j7PWxS8XZTDE8sY4K/eMOkythlw
	F4A/vSg59z3OSB0RljoOB/Io9djYzni7kan9yGmQ9sj0oGIU+IS3VMSDc9kwLMPYJLxfiu
	BEgGH8FyzmdrINEt1hou0O4mdpPYodw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777397758; a=rsa-sha256;
	cv=none;
	b=cLWocHcvivaD4HbClH/MvKFoZo+/49wMbdLWHocT9Jd5frIUGqTnwUOZO6Ry65VoGHgZ4P
	lxQyJDoaiEpZBtnzgivXJPWczON/TocmCI39bDIh7y9a5XV7qvpCF0lYtZEytGHD/TWzxg
	aH6HojYoCuyf4Dxa3O5IfGpn1TzewVw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uoRwICum;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=skhawaja@google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso24315ad.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777397757; x=1778002557; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ncltMbqb0oRbMvugQb2r0egpAWKoVDCs8cMwwYz9oEg=;
        b=uoRwICum7TEMqIXfGevdfeTnRSFMAVE4On7PrGGnHDW1nabBXosDg33wG/dWP6q07a
         fEkuFl71KOiQJ4HAyPQHIA9p5oarfMlTd1M4AS8nK1kAnQQpozSgklAcXM404KKUhNCY
         9AtjlBwzCcpc0PWDXcumEMbN6+S4bXfcf/y8YNi9svRkyQeKCZazrVwd1u6itJ89j7GC
         2aDAkuJTenT0wLCo1ymjvSn7avMWTrhRUlUzCEsjbuIOY4/rE09+WGIGtDPwTtpRJteI
         a5YS/aEpIfqhvuXlDNRbHnbjPWR5Tc0zYfv5dVmzbTaUhaGtKLiUTYS2lXnwr7DcdOCA
         jFYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777397757; x=1778002557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ncltMbqb0oRbMvugQb2r0egpAWKoVDCs8cMwwYz9oEg=;
        b=IEZ+5dcXM16DAq9P6ei5jPAEljlAa2mHlV/UDLFNzOuBzipO60lO9D4nH+8XRKpg2Z
         FAdTmv52TTQn31jESpOsaHdUZYH74+4lR2Io5wwFI3hAvwZ9GkE+TZ+tSZzIOk35Q8qE
         R2L+2f3oXc4mgIhLUi2XOw2vNWWyzMqvM+VpuCU99d4SIJOD/NeN072BuuzJG4lePGmN
         5rCltLds/2freAFAEeNos0u9mHOeqDSdZOToaioAe13uu19n0cXuMU98/CwqZ3AaJevV
         z6hYsfHLQ1Hl4qA7YT4Dry81edyNMzvIOfrXQ9rSoo5loPAf+5CEtjm6qa4FCkGAQ1jc
         1/tw==
X-Forwarded-Encrypted: i=1; AFNElJ/2oc4TN0eIEUk0n7xHIJJNO3DL0BiuRaRE6/Aay2/PRq51tVlymAS3U0k+u7onk+RvriYNshdOgA==@kvack.org
X-Gm-Message-State: AOJu0Yy69VcuDSiWouZa+CgY4LrqgRPwCIQfgbmdhIv0qBcLTuOy526E
	sZ6f/bikCoqQxsC3hq17A7/wfJmOzTjG0qs0M/G72SIC6qDITksLfu8ikd/hF0wxcQ==
X-Gm-Gg: AeBDieuD9iCXK3WZmmzkwKxvdwMAYJKeVmluCbqF5oX+eg/ct4jPd3mdFqQ8ZprhSni
	t8TY883zA+mOwMdKG7t0usXS//lCjLSGbB6SrBMERxytxzpzVgAgnhm86FBgrK5h7mXMFENl1KI
	UYWt/VOUfhJeXGiwW1xWa+PNjInbqeJTBryGRAbfwElDc+0jzhCwgPkVsb+5DKnucDujBoC7hDW
	euLHorOYkZWsBIzF/2cNjjtuHlBZU7rn7oresQi/TIGlOc96NgoEplzFEQkpD89SWKliRRtEDrX
	Mq6TVWYai47KjwgdcsALIXRdLt6NGsfUHPF0XWpz7EkrtjMTAcVUh69OQo8eaWy7+xA/euN1GzJ
	GqZR+HG0K2X8AcCp9qoR+ewh332+y08q6KdhOjnLz1J/ivMVGDkYSOXMC6SkNIAb/tF2acjX+fW
	cZxY4xi4xti6hMSkuf0WsOE3HbmZgpJX6Gf2pfZvIz2c82+9VWZnjR1UptxYDYH+SgNI3UR7auQ
	4boYm4jlw0=
X-Received: by 2002:a17:902:cec2:b0:2b7:b03d:9dce with SMTP id d9443c01a7336-2b987ed382bmr144705ad.18.1777397756522;
        Tue, 28 Apr 2026 10:35:56 -0700 (PDT)
Received: from google.com (195.236.83.34.bc.googleusercontent.com. [34.83.236.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834daf7f43bsm3432664b3a.58.2026.04.28.10.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 10:35:56 -0700 (PDT)
Date: Tue, 28 Apr 2026 17:35:52 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <afDvVhkp8tQpsVlt@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-3-dmatlack@google.com>
 <afDqs6oqWlhoVqMN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <afDqs6oqWlhoVqMN@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 560D320005
X-Stat-Signature: exu6znuh378edy9hfijyoh3oqsdfc9o3
X-Rspam-User: 
X-HE-Tag: 1777397758-167562
X-HE-Meta: U2FsdGVkX18d8HfKimnlG6SRBtdhXZVJl+WfckEXu7B1z76GfAiT8S0O1rv/0lwrMwQl/Em9p/r53ZhVYlyb4dvWkf1BgLj/ltrUkFFlKStJ8EvMiDTIR7FLS3rY4MAlxJDU3vKOM1UqlkG6b52khLjdb/axfvfVbHZ3urRo3tcnmRwCknUlsTImue0aER+yqE/879llrbWMoW8W/pwbKfnBL5KZFNqZwtRHqsBjtIVE9ivoBTqp+ATgYxx3NmXroYoNXKj3fMA5ytmGetKn0IoNVfbCQqT+XHbUfpM4LG5Q3MYGD5BbtQfrWiOwnaGydebU/2dnwavsaZH4/ZkPW9xRPsqmVROtmguoLw7Kx7AICMY95i0PDE/XZcXiBWfLn/fPdVMhl8EUwc9T4Xi0+ubsXyYm4zkJXsGIlR2num1rvISIv3nrG0/mfcxubniH7wsms3O5XTZ6Kyy4U6WW+FGhs/ul3FdlID5QEsNrG0qTWzjwSuXbnaRBEd5GiHB1oybFPL7ZHM/+x1j6AqWdM8RmeFLBQ0yUc7yw26CpcyLqzNQE72IjU05AcFBT0u/m0n6iUY4Y35c8mMvdg/ucK33B9lhSjvv2TqQDi/COoMrhVdEQs3vOOPtmDwcokp0qx4e9WB0MYH3zpeQoqgYHrav7aXQBAC6V2vGF9AZBHjVCGpUmPpjV+NUlh+OvT+kpejuR94u3/KQlSpIv0Vkhc6d/alunbI2mxqGiwPDNIkUFTqsMinTlZ+B2F+xNAMrmqDEc+4fcO3Ltg+k/GS307p74rPg3VrJk73Eg2LLo75/fWzclm8gCWuZD7ezrBA5r0E29G5PI5ByboKF01u4NVEITHs6IURW51xGebOzIr3wIyXLLmvVC03/iWXwlYI3SaiyVuSU4zZwraVJlhhf1BAUzvQwWLTgH40ZfKmKEBLmTMiMRlx6Gtwi/Yep2YZvu6ehdA6Au70Nt+JyQ0dk
 9oljpl2G
 26Pu1E8dCZIpqaE4lJA96TCSAHofzypNjYTZud2lMAJPUtKYM1ERHh8eZYg+LXkw0ywTY5p740I/6t+1VxSftlDhdz6P7rGpooZ24kW+ATihWFCkA0GG/+hgP8EODwGdgvOfpETYfi0a9I+Xwuffvnixnras1YmNTzNM6cTE2S71VsGJ2ABxuH+Ujny1Xnkx0dgzdt6UTZ4PIBBzSBsX0ORCsNXuX7MKvzDrYsnNY6MTzr44L7zgdThQQ/UvIYEA4hV79suWf1sJzOQL2XNkmN5622phEeAs4tQchD8wls521rCnF6rYaaNALMGEW/nPRyAoJlPmvl7OtauTPOejMaJLKIvI1n0lDZ/Rs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 05:24:53PM +0000, Samiullah Khawaja wrote:
>On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:
>>Add APIs to allow drivers to notify the PCI core of which devices are
>>being preserved across a Live Update for the next kernel, i.e.
>>"outgoing" devices.
>>
>>Drivers must notify the PCI core when devices are preserved so that the
>>PCI core can update its FLB data (struct pci_ser) and track the list of
>>outgoing devices. pci_liveupdate_preserve() notifies the PCI core that a
>>device must be preserved across Live Update. pci_liveupdate_unpreserve()
>>reverses this (cancels the preservation of the device).
>>
>>This tracking ensures the PCI core is fully aware of which devices may
>>need special handling during shutdown and kexec, and so that it can be
>>handed off to the next kernel.
>>
>>Signed-off-by: David Matlack <dmatlack@google.com>
>>---
>>drivers/pci/liveupdate.c    | 101 ++++++++++++++++++++++++++++++++++++
>>include/linux/kho/abi/pci.h |   7 +--
>>include/linux/pci.h         |  26 ++++++++++
>>3 files changed, 131 insertions(+), 3 deletions(-)
>>
>>diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
>>index 5c0e92588c00..5b4c8d9e462c 100644
>>--- a/include/linux/kho/abi/pci.h
>>+++ b/include/linux/kho/abi/pci.h
>>@@ -23,19 +23,20 @@
>> * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
>> */
>>
>>-#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
>>+#define PCI_LUO_FLB_COMPATIBLE "pci-v2"
>>
>>/**
>> * struct pci_dev_ser - Serialized state about a single PCI device.
>> *
>> * @domain: The device's PCI domain number (segment).
>> * @bdf: The device's PCI bus, device, and function number.
>>- * @reserved: Reserved (to naturally align struct pci_dev_ser).
>>+ * @refcount: Reference count used by the PCI core to keep track of whether it
>>+ *            is done using a device's struct pci_dev_ser.

nit: I was wondering why is this named refcount and why it is needed. It
seems you are using it to track the preservation dependency between
parent devices and leaf. Maybe add a comment to clarify that.
>> */
>>struct pci_dev_ser {
>>	u32 domain;
>>	u16 bdf;
>>-	u16 reserved;
>>+	u16 refcount;
>>} __packed;
>>
>>/**

Sami

