Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8151CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 17:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD9D6B008A; Tue, 23 Jun 2026 13:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E3F6B008C; Tue, 23 Jun 2026 13:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446516B0092; Tue, 23 Jun 2026 13:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19C116B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:06:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90BC3A0514
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:06:22 +0000 (UTC)
X-FDA: 84911805804.02.35014F1
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0CD2E1C0005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:06:12 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782234373;
	b=k7Ee41wE+gP5EkwYPgMlbjtQwuCfiCIrXw47x6w6MAhqSRjpnt9QUi9FhS7EzYNtIYmxvY
	HH/T5+CuY556GZ/RYDPNKHJ4D9BdXtc0OmevHzbRKgMKQPHpQgBWKvFAbw153ZLXbrW8FU
	ZDXQqUwrH9XTkjxB40QQ+cYttLQkx20=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782234373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tu79wS1tW2o86htP+jh+vF6ThoZY7vyXOnOxpMqA3sM=;
	b=vK6Ig5DPpyU7l4P81lLcwwRyQbf6lMt9P2HK9s//8Ifx1cjcAoDmkdw63W72oNXmSrv3cK
	xQH+HeMduc7E6NCjY7fPlThbcFrpjve8wyikuhtAnYTJYeHalDSeUoSX0xOpUQpraL6445
	3aCfynmByQkBbSjTWFLZ73Hp/YgbtcY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VKfV6XsA;
	spf=pass (imf21.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c6a4eccab1so785ad.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782234372; x=1782839172; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Tu79wS1tW2o86htP+jh+vF6ThoZY7vyXOnOxpMqA3sM=;
        b=VKfV6XsAFL+6YPLl5wQEXT/HiRrYwqAafkKVrZfnxwFsWZJYE6p5yFkoathYN70wuS
         T8qyk86Ng7ZhMwC0MoxM8UeXhAqUqAtKoRXjlIHM/LkjVUEOxgmx4VZ48OU724rxcoTY
         LzDLCDljHcZraZmFWpXezFSAa2ZJ07hutZIg7H80j+Xg/BWEIfqk7lh6YY5HtUTolQrV
         nAI4LcJqH4wCTHfbcyh0/iyuwhkZ/kVtaOVMaHnJyGaCPnLlczMwzn5eHI+HA1QywgMw
         7h5ojiMe9yPn3SYMDc6c4aeC7ex4pLtbxCxWPdYgkw0V47aHzD2Scbtgxr8WY5YVm35h
         O07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782234372; x=1782839172;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tu79wS1tW2o86htP+jh+vF6ThoZY7vyXOnOxpMqA3sM=;
        b=ACtZ0/yZHZxKrRJH3Uw7lawxCXdYbdMklst+blN1kSOP5sGLzofncUBawDOfvY4aFj
         /17be3jrxkUBuykvhR1Kux6uoTozJxVGksWIQzziyQR2rtDNC3QbYPg7M49QNlIoBYYh
         XaJuAAPbdNEgXZKoIRvKQfLGC1fpvyyjbszvsxHnCEAFE7YyzXkH5ehH7/iCTG2o3yti
         wqhpw0ooMPTxoeB1is6WeVCKvGIowLWh7bmhpXXzpObhILvRprSA4SUP2MHnN3+iTfS6
         UXvSQuyhEy4536oayCK5z1bGPYL4yLsejDm5Smaci+X9gTegy8Z1ERQSOj/LZloujDX3
         t/Hg==
X-Forwarded-Encrypted: i=1; AHgh+RrF3NRl+LWntEPkXDwAwY6lda3IpLtNugNfi/aSyOg15Ad7iaJpzkJmbMvBUCbyTAiOUJIWY1MkMQ==@kvack.org
X-Gm-Message-State: AOJu0YyqEhleqhsVtngVrgH22r8uE33GeCb8dAsrnq687Q9dhmK9pGIf
	UHpVtHwiDU5NVH7SWizF7zTKw3XNRs0wZlwyv8gF60oeL++YaTBW+L/XxeXjvxigAQ==
X-Gm-Gg: AfdE7clOhV/6eWQ0/ssJH1TYtSYi9JDjZnjQ3hQxj6IHQn3NGqopYsvcs9ygU1p4A4w
	C03jwJk41jygRe/8HMjA2mi062ey/irrwd2Y9mqj92ZFMHxRnB8tySzd3x1ZqcDKvpsI44KDzzP
	JqjO1pDmfCRoCN9FSPBlcADaQFbdlV9FyGB9G9L3dw5NSjaA0FY9mFIKpqjqTbVCW6Y+b+Sz3jT
	8wnNkPMJ9nxxLjDjmWeuci/ZI4jFDEA+0j1cGf8LkcfuP2tMtbgWP4NewTcpuST4x3IL/A9j5LU
	SgiuIg6SewnSSh6Gda2UMXfij/CVZICwp/J5TeJH3Uwxnma1zAVtt6bVJpQgM2ah+MliFN6mj0w
	AJKGdCfyLK4t+eHsERElWgIq7RaDxK1u/U/cLmdGnpGUH32QT8KnWMQ8OOW5oJ8++r4wIK3NNH3
	chrtWkaWczXCZvnhDawdVcybv15zErsEBdQ5sQMufUXvVWBlx/zwQqkzcTJFcjidYb8eAv9747i
	V/mkjiY
X-Received: by 2002:a17:902:c404:b0:2bf:749:55c with SMTP id d9443c01a7336-2c7c711c2f1mr2378745ad.21.1782234370647;
        Tue, 23 Jun 2026 10:06:10 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af54dsm113990285ad.11.2026.06.23.10.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 10:06:10 -0700 (PDT)
Date: Tue, 23 Jun 2026 17:06:07 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 05/12] PCI: liveupdate: Keep bus numbers constant
 during Live Update
Message-ID: <ajq852qLegjfkP4d@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-6-dmatlack@google.com>
X-HE-Tag: 1782234372-467557
X-HE-Meta: U2FsdGVkX1/7mdV2u/Ow0Atlx1H+Wyy9odvWwXjF5xIwPZFfTL5/mO1eSxXT31CatYbbB4hho8TVdNRqTyHvf2JV4iVlTiCzE0949o/yzxg+OThZEbLjBLZw+q8Gn26xPtovImHrwO5ZYGXtXBmYmKrXKc7PiBAFjbpnx/6NjjolRXOFxP79bzxb+k4gDTQEDEYBPlk9X8lrc/A+nhv3sLu4O/ws9bxQ52l0Le65CtTdxL3By34fx3MysezzDlBQ+Y6MmciOj8+pN5AhDDtIKDRI85P1PBGq8yIDowFOOvxFhFv0H0eXrrbioZT2YyRInIva9d+VGFXz8gcsHdnYB44Ie/5zGpH6I9t/pZY7gYVQ8W9ImfHYLPgYHA/htAEjoHgNsQ/Iut+h5oYNVc7MNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:03PM +0000, David Matlack wrote:
>During a Live Update, preserved devices must be allowed to continue
>performing memory transactions so the kernel cannot change the fabric
>topology, including bus numbers, since that would require disabling
>and flushing any memory transactions first.
>
>To keep bus numbers constant, always inherit the secondary and
>subordinate bus numbers assigned to bridges during scanning, instead of
>assigning new ones, if any PCI devices are being preserved. Note that
>the kernel inherits bus numbers even on bridges without any downstream
>endpoints that were preserved. This avoids accidentally assigning a
>bridge a new window that overlaps with a preserved device that is
>downstream of a different bridge.
>
>If a bridge is scanned with a broken topology or has no bus numbers
>set during a Live Update, refuse to assign it new bus numbers and refuse
>to enumerate devices below it until the Live Update is finished. This is
>a safety measure to prevent topology conflicts.
>
>Require that CONFIG_CARDBUS is not enabled to enable
>CONFIG_PCI_LIVEUPDATE since inheriting bus numbers on PCI-to-CardBus
>bridges requires additional work but is not a priority at the moment.
>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> .../admin-guide/kernel-parameters.txt         |  6 +-
> drivers/pci/Kconfig                           |  2 +-
> drivers/pci/liveupdate.c                      | 83 ++++++++++++++++++-
> drivers/pci/liveupdate.h                      | 14 ++++
> drivers/pci/probe.c                           | 17 +++-
> include/linux/pci_liveupdate.h                |  4 +
> 6 files changed, 119 insertions(+), 7 deletions(-)
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

