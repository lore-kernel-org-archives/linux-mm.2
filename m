Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58EC5C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 19:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A426B00D9; Fri, 17 Jul 2026 15:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341446B00E0; Fri, 17 Jul 2026 15:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27DCB6B00E1; Fri, 17 Jul 2026 15:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAEB06B00D9
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:41:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6376914015B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:41:03 +0000 (UTC)
X-FDA: 84999286806.29.0C61702
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9743A1A000F
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:41:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LYC+u9WQ;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784317261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cc8aVZtebMWgQf9o/5yCOKG8fzMb7f5xhxINPxPhrtE=;
	b=gHy5lz48VxdVl7QXz3kfedorLodiHMwcN8QiEmLo0veuMwf3eOVATpwkLP4Zy6O3kkLe0V
	7KF9+gfYCePjOGxUMdiG2fgqde+8UPa9YRkJhpkyofiQ88qeziHPb58TZkkF6nnR0sbVWD
	fTofvkldgTalGBtxgDvXYP11/MJW0kg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LYC+u9WQ;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784317261;
	b=R0mA76KKk+PF0E8PTyoffoYDCUcVv3btW3/JHMebb7vxsYtw/M5O8bSoDRh423XFsKAbZt
	2FmVB+vD3gafyT5Q9PGophN0Vp/T919z83LXg9z2vIMsnzF7OiUkoFd49kaZEL+SEqzj19
	jnyoxsrw39P3bFlIbQczbaAWYCQJnZU=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92ed3993c1eso310821685a.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784317261; x=1784922061; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Cc8aVZtebMWgQf9o/5yCOKG8fzMb7f5xhxINPxPhrtE=;
        b=LYC+u9WQTvaUL4iBt9k4wADz5MlStOD+raauTcSlfsHHAqwF4U4aF4T0M3lZb7fYjF
         1n1b9ZQvEqcRgy2eMRmq1JG3TfM2mZENXLk3f4GYNwo6cbOMtVbRQEadj/SpaXmAJKaG
         l3DUcYDlGVVaz2fbwGzPSgqeHyw4o11cPElPeQFaNPw9Ag1c1qGEC2QeHwIpOon6L5e2
         hy1xBUnOxIc/pXptdXPrPGibQE9oDSAVSLhAZgC73XncWyQGJ0oPbxN0uj70axmDOdRf
         4HE8ChpcoPLTXCLN0b/vKd5ohWQt4d8WNA4ci935TUyI79rw6Yyz3vkfOmmt9QLkEnVq
         pyWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784317261; x=1784922061;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cc8aVZtebMWgQf9o/5yCOKG8fzMb7f5xhxINPxPhrtE=;
        b=kX0O3z/W44ulsq+7gd6XtA29B1mbOKuF8PYbVnQsqonYSLgAlYEA8hyq3UMbbRvgGZ
         60ZAe6xvfuwd1rDy/Fg8i8YIBLgBOdbkJmbY69atXFtgerIMGIbnmKi9RlFry5FjVe14
         nR5Rg43bcXn30DGelUhYRhozGAwnE2BRE5WJD4lOu7YACrakzOQ/Rw7Hby2Ar/sCPrpv
         oTjGnMJpeIMN0MD59CqObZAyvpJWHj9KzDbXdycmofJR6mkpgsvcOcm0VOATS3Anqy++
         0cjhzKZbjUEkciYhirxXCFRuszJPhGWHfivCFIIm43ZFkNc+gtkkB8iPO2FrPlH/A/Te
         1DjA==
X-Forwarded-Encrypted: i=1; AHgh+RqK20jLXVywqZhqqxF3jMjOyVLMlSNRt184rR0lovy6cM/hIhbr0HBPtMDEMb0LD4a35LqNTFHTag==@kvack.org
X-Gm-Message-State: AOJu0YwZyz8Ab2qU8ORkSnroH0wgRMt9b/nVJ49nsjGDZmrEoO4E11qF
	qMCniUW6ye15miNXvK/Bl735UizJFbmpdGPNu6M3Mv8vK3Ns6fuc7RRjOJU6QtL4JJc=
X-Gm-Gg: AfdE7clYwHUndBiPW0HDRd6n7tFEIe08vSqJyC0yQp5GzSbIjjBQZDW07E1KtNKByAG
	TAbJmpEQP7LgGjQhWga4Yd4kKR3DXTsljsNI8w9Ok54XpGcmCDoew+/n5mcJDXT9jnAJexm6sZI
	rrqK06h8rzbcqwtYppDZutXUxJyUU4lTYsRHRdTVZpGGAYoCvM3wqXP532yWlEHf4dTKEG3QTWN
	7ByxT7WTVR+iSRGJ6gM3AOtEWNv/C9Vt80kbb/rcuhYCfe+Rayrysi8r3qZ9ItPzDEXUPc8eQMc
	z3HnWC3kb+1LciOBgDA/75RBKwWR+zT73wtJra6XD9KgoPbmpU/rgUitsOaWHkD707mKUhe+1Mf
	waC4iKL5fEbp6NEeuZIC24hrpyEfRbMjg9QxKVykJpym6GOJJYd1LgGilFXwHUzDOaqhzcbsRQu
	BpTMPrFoY8zACSQ2JrDfhhe+cKDM5oRw==
X-Received: by 2002:a05:620a:a197:20b0:92e:c116:bef7 with SMTP id af79cd13be357-930b4315f1cmr311099685a.84.1784317260004;
        Fri, 17 Jul 2026 12:41:00 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b52dff03sm230279385a.9.2026.07.17.12.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 12:40:59 -0700 (PDT)
Date: Fri, 17 Jul 2026 19:40:58 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v7 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <alqE_-OR-rB15Crx@plex>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-2-dmatlack@google.com>
 <178431652443.189683.17611165218179620081.b4-review@b4>
 <20260717193055.GD699082@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717193055.GD699082@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9743A1A000F
X-Stat-Signature: qstjj9wb7rbaopnjhfwkqhizhaii3xzf
X-HE-Tag: 1784317261-787526
X-HE-Meta: U2FsdGVkX18QK5ws8/a0pcc6IhRa2RrK7du9ZavSBCu69Sve+HIxLohkoEfw3hMgb+TrJWmGgX1obFhkhbYeQ1E8cnAX8qGhBO9qSwDTv+AYDHly+5fZnwC23wQU6bwQum9JjNCENIy2I44KNzgnQMJ09qo1evQgKFXJWUdiJEGSLk3AtiDtXjqsGn3ejp/s4+FqttpfwlGQ1fL4L8oV7N5y5jAhqdaBnH9PMGxzK2FmzMcyPZHQsMTnwjHe22FotK0B6bqLCxsb6H4eFZNqWL9uSQeTby3s+xvNxu29h/t4yFqLcHSOeAh3bWVER6Lhca6wLT/4lRtQ7VZB8FRQhwH6R1CerHeeNqxfnJw1CpqD1oXEx4NEroUI6tBWhquYJWiWaFuAbKoT9uie4uBEbKt4IqLA4evYEnb3AMqjqLTudpIiJ3EIZ+GrTSdfV50M44jdbwSSrtYT0a89lKgAfkzQd1FCxU+LTsBHSbrwc2WPY6A8psTPnMKf1BuzlWFvCeMoWoLE1hlTJcagk1W5ny9TnF0rcBftAqH49pNGGErJyuD4ZNgqx7R5znVvKp61UP8yw/ZzxsWulkSV/TIyxl970jRDTT6+AeR+g1yzF9Li96bZe/Nw5sTidFgran2hx889n4mDnFPGxRh+XDo8sJZR1T2nEKDHuodVW8+FSCkbDDO25ICl+UdNloLe11nJRBjzYdQ7J87mlFAYSg+FkLjz+VSAba31hXQ0owxmZIMRMC+RHlSk3jAiB7Qcf1sa+5rtrsCN4p2PpRId9i8AQDJy3uHZcrpJm9WrXW0Ylcig3gp83USE4I+xu91757v0FIzIC3GXkmc3RmeKRSZdXUEm/R0sx2uqlpQH5uPXPT9aVBXMhm903g/gj9aQjusstd4kLVJ1SvqU8GMQBXQla8D8DWxhdCPuh43bwpLkHAoRJRgnA0rZ+LM6Kpfn3UqF4vcQqKVVgu7v/ss9x9j
 E97FdXOC
 X+re9SM7YYgMqnuDRui6W5LfLtKjE/NhW//C3VpmdWgIF1hTtrgbinb6hqf8sEOruKuXF/YUrwxu14/b2SpRUvvGJOINrd5khogvCrhfNkwZtkOLbtAC4WZF43rhS+8iLN14pQGqWueZcds1C2/1Pmp6ZzdoOX6hOxUv1+gY8lTc3pteb5lnKhAkUIKVghUNjVaEqYbwqBgVqsfSn4ZkdESKMFP8oVOaGQn1ufqK6cVUMAMa5WrDVmz9pWRioUC0GXi6aVl4kwVeXdDu4buiydpoV6OFwBqjqKLnFYh2PuHXHdoRSHOtmbUKwaH9E6M3rrtXHhDyuPV9HKhKOd034M9im+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07-17 16:30, Jason Gunthorpe wrote:
> On Fri, Jul 17, 2026 at 07:28:44PM +0000, Pasha Tatashin wrote:
> > On Fri, 10 Jul 2026 21:26:04 +0000, David Matlack <dmatlack@google.com> wrote:
> > > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > > new file mode 100644
> > > index 000000000000..899758883dd5
> > > --- /dev/null
> > > +++ b/drivers/pci/liveupdate.c
> > > @@ -0,0 +1,155 @@
> > > [ ... skip 50 lines ... ]
> > > +#include <linux/slab.h>
> > > +
> > > +/**
> > > + * struct pci_flb_outgoing - Outgoing PCI FLB object
> > > + * @ser: Pointer to the preserved struct pci_ser.
> > > + * @block_set: The KHO block set holding the outgoing devices.
> > 
> > AFAIK, these should be aligned after column:
> > @ser:       Pointer to ...
> > @block_set: The KHO block ...
> 
> Gosh I hope not, I never do that. The horizontal alignment is such a
> PITA to maintain.

Agreed. I just see that everywhere, so I thought it was the rule. If 
not, that is great; I hate them myself.

> 
> Jason

