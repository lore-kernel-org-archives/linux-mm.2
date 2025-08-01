Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E531FC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 15:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887FA6B007B; Fri,  1 Aug 2025 11:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85E376B0089; Fri,  1 Aug 2025 11:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774626B008A; Fri,  1 Aug 2025 11:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 669CB6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:33:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE515C0238
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:33:08 +0000 (UTC)
X-FDA: 83728582056.28.836BB43
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 08B0E10000A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:33:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I9fIku14;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754062387; a=rsa-sha256;
	cv=none;
	b=F3bK0Cm6zfF43t7hJHKDoG+Ugp9JUlCfzhNm3tYUFOjRk4S30vJPBY9dZTn6ngyR0Wl8uE
	wUq7CmCXF51Uuxmw6GAeSZOuAlwQ763ehgjs+9reIvqTSnBx62Z8otOHlCnDKzCqQ0ez39
	OWo07pLEgeTybq34A5bOPYyz6QzW2BY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I9fIku14;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754062387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8l68DoeiceI3IKbSzGhlcOAyQDPZ9AokScWPeUJfCvI=;
	b=ZIA3Y5S+pLo9gnOQWoZimya5WaPV85GxvRL1U4cHf+wR3hRaY6OsayILpH6MDtQoAORLje
	5rcgxHAeVpf7pMMNlDt21R8ZNpq50qAg505gfgvhTt5Gj0Nr0co/qmdx9R8cO92iZkv5z4
	EXOZQnabcBzHK52y3hmuv01rYkpvC5k=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-33250b6be11so3301741fa.1
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 08:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754062385; x=1754667185; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8l68DoeiceI3IKbSzGhlcOAyQDPZ9AokScWPeUJfCvI=;
        b=I9fIku14+cW9oPveUbLWP8cq9ov8/M3CTmY1PgamjdHKH2irV329qo/Mii/NshQylQ
         FOI30MM+FDF4YFxrbXw6nYUFyByPdlb7zhSX2bvqQmwz4mIvC3nKukX8BQ6PS2PfVu5l
         hYNM3Yc8QmhXqkqsyFCDlT8g/pYa7JMWcSa2Y3eeXSC9+eCDvX02MK/m2IyPZ/tFRN3p
         wBO3P1xVveBMxUw7RqDsGcNtVbxwSP+9tM/SSJlsxKyibgBtZ4TlrEcJWAdVIVywps1V
         RVyR7jNahDOAcf4kyhFYMbLPLvBr9DP2RkAYDy6aqpkAgMlT5A1YEVMn7nZbwHTg8mep
         fuww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754062385; x=1754667185;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8l68DoeiceI3IKbSzGhlcOAyQDPZ9AokScWPeUJfCvI=;
        b=EsJMzIkxpuiKo52kaBp7LJpT4Lsfq3jI2VVLhQB4/nB0xzCEJwnXnqhsFJSlmXkgRQ
         zgIx5FWHtZpyecbS2yLsKFui7QqtUKAF88txSc9ndc7ITNiX/ReCp+uup7diO5e7qgoo
         KACgtuMLkL5R2hQ8GQXSU8Kjjb0hvEKBNLzSc8O3KA2lQAylbKeA5exnbZ0HyapiHXjk
         3PqNpSvB+yNoPURRf715FTUECXafbaVUGMHRTN4yu9RAAeDVCCfFUeYDxJbkLo32swGQ
         YMR9lJ23eQcALI+svbMriqi9mkHgUcFqOywwdl/h9XqjPRR9sRJ1GFRlBCz8Y9MEFD7s
         /WoA==
X-Forwarded-Encrypted: i=1; AJvYcCVbjteR9oS04JEVqs71MT98A6LmleRyTSbncjaieWzpwuom7R9sU2l+9O4jxQ0EmybfWwEOFAsrLw==@kvack.org
X-Gm-Message-State: AOJu0YzMZ6aG5tJjBHZQr3PvQ/GZbT59XfYYtdy9pJZZKzxX5Z+nNFIJ
	LFWFbyoqucymeKD8yrwBZD92Iwh9MCh2/NkDyxOQQ2I2jrUlKkSn5naJdejIQ85KRAQu1eP8qs1
	7/ilDtImC1aJndhvlKzkUT6wqujnAdNJmm/gGeSWj
X-Gm-Gg: ASbGncuBMi3FUxWVRNJApyFUTEh8cnUNqYPDS3nIbmlxinVj8Bemk26kvaTokKQ2bvd
	a0U0M0xWysrGq5ijK1C3PZHAtZK0LZnQasETqbk/I5kYhLiIlkjtQiiBq7ldRpLa7IiBmpG49zN
	iF82qiBdSG4JfHm0EgNpfxiDYea22YV0YOgnfG90ktvXna5u639qMoTMITI3/04okaluQOWwQXD
	Cxh+6qZKS/X3IMuzA==
X-Google-Smtp-Source: AGHT+IElqGqJCtZOhO3R6EOALjhIxAosCdG4c6JAw0Ii5GIvvlZsjTd7NWmVyt9CTRdEgA600P6iKWvTGZcKiA6jmn0=
X-Received: by 2002:a05:651c:4117:b0:32e:aaa0:b06a with SMTP id
 38308e7fff4ca-33224a5e95emr27853181fa.8.1754062384765; Fri, 01 Aug 2025
 08:33:04 -0700 (PDT)
MIME-Version: 1.0
From: David Matlack <dmatlack@google.com>
Date: Fri, 1 Aug 2025 08:32:37 -0700
X-Gm-Features: Ac12FXzLKnSwpLBskXSaJfx0o2ePwkZV7fNIT0lZA44HGFkBJgr6jkivWR4r114
Message-ID: <CALzav=d_Bjfy=6if+rPmxgGJfUV8ijnQ5hf40HoH6Yozg_H6Ew@mail.gmail.com>
Subject: Live Update MC (LPC): Call for Presentations
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>, kexec@lists.infradead.org, 
	Linux MM Mailing List <linux-mm@kvack.org>, linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Cc: "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>, David Rientjes <rientjes@google.com>, 
	Chris Li <chriscli@google.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Josh Hilke <jrhilke@google.com>, Changyuan Lyu <changyuanl@google.com>, 
	"graf@amazon.com" <graf@amazon.com>, "dwmw2@infradead.org" <dwmw2@infradead.org>, 
	"jgowans@amazon.com" <jgowans@amazon.com>, "ptyadav@amazon.de" <ptyadav@amazon.de>, 
	"jgg@nvidia.com" <jgg@nvidia.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, William Tu US <witu@nvidia.com>, 
	"anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>, dave.hansen@intel.com, 
	David Hildenbrand <david@redhat.com>, Frank van der Linden <fvdl@google.com>, jork.loeser@microsoft.com, 
	Junaid Shahid <junaids@google.com>, pankaj.gupta.linux@gmail.com, 
	Pratyush Yadav <pratyush@kernel.org>, kpraveen.lkml@gmail.com, 
	Vishal Annapurve <vannapurve@google.com>, Steve Sistare <steven.sistare@oracle.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 08B0E10000A
X-Stat-Signature: u4cybdzm6jj4qwzxszpdq9aqz78tjozz
X-Rspam-User: 
X-HE-Tag: 1754062386-766778
X-HE-Meta: U2FsdGVkX18R/m8+4D87gD04ywx6HZmdzTlG8Bxe4DKf8Z4Tve+u7n/VaeGF78I0hjphsqWQa4gZObfcaoNQ8A8qeE0fox6QAnHYoRZlKW7l2LMJJ8RvR4knU5JdrnCtCvVUK5qR1rbejKe3VB4DwN8p0FPXfvdTHGv3GC8rJ0eo80PsutpnJbl7JCzvt4K+lqWnTkaMfrfEAhJOg12tkVoOBeqrhtPI8Cvt5noMcEm1Efaw3VuxfjB6eDornHXqurppQFT9KsCssk9ThdjIebsZhEd0xJF9lt5NnBlnjFO4NcTUbOGvCoACXfA8I2Gx0kD0f4Q3W495czQW0mUWxzhbQj3IY/vOrc8HT3Kys0aeMuKIxrGuhea0Erz7m3l820dGOPDGk01ut6WuwGl5Y2Hf5LhPg/sxwqREQFMvqjLZwG/lzWWFKNDNeG6RH5FyFZpzFSIBjdNtFHFrD2sYEF5lMDl4riLbjKNjVvWQ7cddiNi1V3oJiHzvlE4zuvRQaKduzQr3g/PLLKg4RTqza+Qth2cEL0TcRVvImYM8WaSrPbLbohMGQln5kQLcOF7vhpO4DpZoHz0zgmKEsVJF8ZVtCQZsMKSKJQHX+EWgLTkvpdW8XA4FqKHVmaHw6TDhm0uLiXxpDwFwAiZUONxBVpDQCAPaZXLYWTY1UIrh3//GT7707HjHkXDtDF9AeV4sqHdCtaI+o/aDodSyttyhpJfKRRGUQsELG/vnN5KWvdzbJd8MvbZCN7Jh7pjNsAVBMmEYX1gxsDTKAjWSv8HF9spXH9oRC4/hZTZeyibyU4KyYGarYgUaKUkvQL5qIjD/axcf5w9xwPAPeli38QYyAh2cm0h8mIxl3Yjp/mwfSic5vCHs1JHN1zp1+i9nU5QiCij98187mAPdti8/0Q2oIu2ZOUNM4VqbHp0or/N36twFwJ84DFPs4Ylu9OwJADW0jfRX9CALy27CHASRfFA
 2aDbo2AC
 T+xvKQ5Xe6XZr25XkQeinK0PR9KQJBMAC51DcdpDn6UYDEKezi4Nfk53/EWw3YzLAUPqQXoi/SgZ3E5fC9sVkU/vjG9fKXGxgVbcoVLr+7YMEM3zn+XQjBSwNMtNX9rkbcMRSqECBNmwpb4O2+vxX5n5y4jGmW1GkDDzJc1wvHX/N4rLmg3y6THWDG2sRFOKJ2oj1qkD5JUzZb1wkq2LCQ2NZ4vV/qC+aP4Io2hCLiZEWwrduxaC8wNMdj7XlpwQ13MfQcwehS6GFSMKzUx+MJfroot6X/M8dx6lCE6SZySMd+NhSw16jKC/+UNjB/PIxZ8yNBfNlQsD7W5/Ba3aBM5xgdM2NfRlVQOWeBVwoky4o/v8G+FFNT+ryatP27Fib3ExO3FqUjP2OmEk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are pleased to announce that there will be a Live Update Microconference at
Linux Plumbers 2025: https://lpc.events/event/19/contributions/2004/

This microconference aims to bring together developers from across the kernel
to discuss topics related to Live Update support in Linux. Live Update is a
specialized reboot process where selected devices are kept operational and
kernel state is preserved and recreated across a kexec. For devices, DMA and
interrupts may continue during the reboot.

The primary use-case of Live Update is to enable hypervisor updates in cloud
environments with minimal disruption to running virtual machines. During a Live
Update, a VM can pause and its state is stored to memory while the hypervisor
reboots. PCIe devices attached to those VMs (such as GPUs, NICs, and SSDs), are
kept running during the Live Update. After the reboot, VMs are recreated and
restored from memory, reattached to devices, and resumed. The disruption is
limited to the time it takes to complete this entire process.

With Live Update infrastructure in place, other use-cases may emerge, like for
example preserving the state of GPU doing LLM, freezing running containers with
CRIU, and preserving large in-memory databases.

Topics to be discussed at the microconference include:
  - Live Update Orchestrator (state machine, userspace API, implementation)
  - Generic infrastructure for preserving file descriptors across Live Updates
  - Live Update support for specific files (memfd, iommufd, VFIO cdev, etc.)
  - Integration of Live Update with the PCI subsystem and Linux device model
  - Integration of Live Update with IOMMU and Interrupt Remapping drivers
  - Serializing, deserializing, and versioning kernel state that is passed
    across Live Update
  - Persistence of movable memory
  - Leveraging suspend/resume functionality for device state preservation
  - Optimizing kernel shutdown and boot times
  - Support for Confidential VMs
  - Automated testing

Please submit your proposals at https://lpc.events/event/19/abstracts/ and
select "Live Update MC" as the track. Submissions are due on or before 11:59PM
UTC on Wednesday, September 10, 2025.

We look forward to seeing you at LPC!

