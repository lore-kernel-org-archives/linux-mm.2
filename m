Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C53BCCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28BF6B00A3; Thu, 30 Apr 2026 16:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9506B00B1; Thu, 30 Apr 2026 16:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC74B6B00D3; Thu, 30 Apr 2026 16:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6766B00A3
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:42:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 583D087456
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:42:39 +0000 (UTC)
X-FDA: 84716395638.07.B234FAF
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 74BD1100003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:42:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="emDT/xt7";
	spf=pass (imf14.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777581757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vbJaL0qvtGk1NC0ztOfHKQqU3avaZZm4uoH47YILVE=;
	b=q7vX6QjZf/RLWb2HKBfyTlYvHvijie4FaVAv9FEBiSNJMQ3ufOvYNNgxC0WsQSD4mzfvMz
	fTGy2IITGWuBbjqUgH9HdhG36jvF6vihyFAvuOfYkgi8zNV8MRO4x9LyciGQtZ0GPRAxCD
	T3osYU89JkM9X2QVhXOGZ9sJ7OWSDlM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="emDT/xt7";
	spf=pass (imf14.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777581757; a=rsa-sha256;
	cv=none;
	b=fEoB74voPKfWrheFdGGgeY7DHkfiO5HzxVOU2sw6WA6f4Bbt/GPzW0q3xe2I/BK00kM+yt
	MYhC65qQpQMKz8NFzb8/t5rl5sbjCujhYaBBINmj+GJDzCfkpdvOTJEqMc1zDBmcTK82zN
	LTHGmiFKFo7nQF2fvzTsYSwl89dJD+Q=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b2591757fbso33875ad.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777581756; x=1778186556; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3vbJaL0qvtGk1NC0ztOfHKQqU3avaZZm4uoH47YILVE=;
        b=emDT/xt7+Ev4dXZeeD81mCRCJm6JAsUjirPCLXdUsVK+XaEC+3qaFyKN84f67UypE1
         r4n9Eu3onKmcsAeHLobeY0nMXZCTriQpO954SFOs0dV5tRvOrpqUKqBBuvAdh5F4ygEw
         QfDnWRRHTf6CHYKDiQ/11LIJlTQSmKnKKAVabyfcBBa5APe5nwe0cjysOnBmzKbb9vJ1
         EedFsyrg9R9/t+tpzl0yYvYDEZkhxglsP2yxERPST750uzWzajQNLSGsCCee0b7wGeY7
         q0AnIwndgAgNS4MSPFGJ0yIq+D77FFeBK+4F3ZN2bcGhwqp0wAjoNUJn6bFdczj8brf7
         7FnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777581756; x=1778186556;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3vbJaL0qvtGk1NC0ztOfHKQqU3avaZZm4uoH47YILVE=;
        b=o46za4o02j9KOTRFxqgMtbOWyeSSUWwhyXaGoce3NHVlXB7wTPm84tBInQivatNeMF
         DRtQiQd+Gwf7VNCdqEtNb58N+g+dThISgukwcbe/CjlVr0CmJMiH6XnbBe7anFL97lQP
         YmzE8SysxnsTu0I62FpXD75KCWa7VeBT/ljvaY4zZW/CpfXTWHcD9Hn3iDRxjXI9dTWL
         hiPRAP+qh+SP7o/esOI3zez113NvdMgXcZEPDn3ziyV8O0A58wPIumoB4rgdQAfegO+G
         3uhqjGaUMFb4qXagRzAZBUrqOqSofPqQNYBku0buZ5EkW+1qVX/lzaCeOqycsQOHD4Ok
         4Tgw==
X-Forwarded-Encrypted: i=1; AFNElJ+6xPzZxcqujZWro0lmts9imsYv8+oRjyhgI9jfJpu+DXFX1Sfu88WWfrJvGn8gP9A7WmdW8BI9UA==@kvack.org
X-Gm-Message-State: AOJu0Yw+ohazwmoFY61+7P6ZBD+vOmmU/JdsCi2uQ5qFmBMMeLdjHwUo
	5wI/lV2zxmLfH0DOBycTTdA+6qEwofRm9TvZNb+qBBSoE1a/BXqMUNtiFbGXcmU4Ew==
X-Gm-Gg: AeBDievYc6cC6TOHm8ySMtG0Scuf5/28dChdD5iydkCSLD8ZJDZoPAmbaVtHS54nknt
	VjOD1EaF0Idi/jDAmqyVPCU8juvSAEI9USr16BjcoKkj6ykn0ZCcu2i7PopFUeeIPrZfBIcc1Xr
	kLGrOeT42EbHRFkQXo+VoV3+njkfGkMJe0L2U0e1oy3CLqQe0pVvmHO8XTdNHJk8hfszaJ4I4TL
	MyG+3EMeEve0oe6pB4OFQMCcAgKVe17gOxs/PNfUptWB1dP9d0k5tblY0K2+ETiR+elSuS08ZZt
	G5KpUDqmDXrMMEz0WDqHeMTLZLdP8L3rIKsXe1KzGR00S7cz3UHpEakZjQAkWzaFFFy8XWIo1Tb
	ieuTCM5iXtFDQBYrBc5gBNVlU84L2ejy99pXjLMrinLZXyle1AG2qWwYkXLqa+Ex7oEAfy9L8AL
	JL1sMkSpHA+QgcDkSGisOjvMplhTAiqYnD1lliPBrRn2LZSMoMylvKu07c/8pOZMGYa4SyOTFNO
	eitMAxB9Q==
X-Received: by 2002:a17:902:efd3:b0:2ae:575f:3755 with SMTP id d9443c01a7336-2b9cde4ae98mr575255ad.20.1777581755636;
        Thu, 30 Apr 2026 13:42:35 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9cae55612sm4897165ad.73.2026.04.30.13.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 13:42:35 -0700 (PDT)
Date: Thu, 30 Apr 2026 13:42:31 -0700
From: Vipin Sharma <vipinsh@google.com>
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
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <20260430204009.GB22297.vipinsh@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-3-dmatlack@google.com>
 <20260428201231.GA3885809.vipinsh@google.com>
 <CALzav=dfLtdrPhkBkGwHpDAWUBMHnbGPccwhy1__doziNVZQJQ@mail.gmail.com>
 <20260430175916.GA13902.vipinsh@google.com>
 <afO9VOckgyiiokw8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afO9VOckgyiiokw8@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 74BD1100003
X-Stat-Signature: uur8ufqk5x9dpb118sgcwtqnwy56smjm
X-HE-Tag: 1777581757-206185
X-HE-Meta: U2FsdGVkX18btaRzOV/nwP+GFPIT+U7JoK4f1uhcAzL+4W80SKJUIPnnsFKUdwF+86Ed1n8HD45aGJ0GniFfpNG1lVYz4ce4dOf9lxiHe7N7QwMzWFwWvbDRvr1xTIkZRLNffylJP7UjrH6LRB9/uQeGC03JRXno0rKd1M7kpFZ02YEhCh8dS9NKgGmHRAkhb8+kFEO46DpVvRYQyEZAAPFSPUZjK+eVH1wU/M9tlzNFr95KoF+4YcIKaRyP6Uc6WYM55XPUoHSaIvoR5Y6Nchpd7zr9TBQ+L/JKp6LX8Bde0O3joHNUAEMqMXrtiwf+r0IRVWbhyXkrxYAY9BJTzaGcrs/HZLA30/m51G16sYdmACq3C5C7nHZY5JPe2er2f3phlHA/OVT7l0XHhPZmqME73eSqn39MSrDanMry6Y+s3MYAUtSXbYp9CxTy+ekbiqkS8ya9dOrBCZMRIf6U0SoFRevYi7GD5cLNifuL3w7aKZ3FrslZu6kJxV2cpPGCfCwjj4NPN+iRvD7nLiRmJPwtCriT1+jDpnWl3eTmtYlDx2KFElbJS5dDudNHToedCTVKUFvygtZpStkJoJyPkJybfsTP7Aavm2JZ5tajHFY5Sadh56RCBSZ7+biQBj5AywsCXdorNrrVPxPKaGAuagmTrGA7uRzOufDUSkkjWqxWAifMEV5X0oruWwmnyIT43cpm2c+RN+jRMAhLAwmCh9pZ60Efl6k03aeCgCboP/ZE04UHSnKj+VxzqrQTGs8AOFgY+J93P77dVJlO5njzwWCsxTLKqwnOe6CXXgVGSt7ZlVtvY+RMh/1T5W8mUSZS0ZD4NzMTzQJlnpRPnErGivh74VRz+4Agsf9XD7xibjNn3ckEDqc2bDN99WSm5L0698qYhaAkLCTNbYfPD7PJyAkEYY7GwMxePUISSWhm5nls+u8N5usYgqbMpm61FApYHe9bqgc4HgReI6jfvJ3
 2fCI0ubY
 pLTMqt/SHiE/riHQfwddy7K44OCup/qHhX0baXHV3ZQA/r7hn+r8wqYZI9SaaUM6KdX3jxDwbpe9G0qPou7lCoZiOWpNVT+vFlvvISgzBWl5mEyqpytO9nksa6HcdMJKFxzTMEmWeD8oS0aXHe5SjyuFM+jVP6HIaeppwhDGVGLzdtcWP+BRXgrbYRfGvPv/EzkBHVk0tIwhwvVolyerMaFrDkWmJI4umAaQPTyLRXH+97qDBvomDf41rrw5JBzTL5rJUVzRFo91t1NDzTxL3leJsMdQ370silcre0MClhvesaBc+HgdBW7SpA31S4tsTJe27rfvMZUBMBGCryJAPTTxYkU1L0Eh2RdxxcYcyZL3pRAN4oFAUsfg0Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 08:36:36PM +0000, David Matlack wrote:
> On 2026-04-30 11:25 AM, Vipin Sharma wrote:
> > On Tue, Apr 28, 2026 at 02:12:13PM -0700, David Matlack wrote:
> > > On Tue, Apr 28, 2026 at 1:20 PM Vipin Sharma <vipinsh@google.com> wrote:
> > > >
> > > > On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:
> > > > > +int pci_liveupdate_preserve(struct pci_dev *dev)
> > > > > +{
> 
> > > > > +     if (ser->nr_devices == ser->max_nr_devices)
> > > > > +             return -ENOSPC;
> > > > > +
> > > > > +     for (i = 0; i < ser->max_nr_devices; i++) {
> > > > > +             /*
> > > > > +              * Start searching at index ser->nr_devices. This should result
> > > > > +              * in a constant time search under expected conditions (devices
> > > > > +              * are not getting unpreserved).
> > > > > +              */
> > > > > +             int index = (ser->nr_devices + i) % ser->max_nr_devices;
> > > > > +             struct pci_dev_ser *dev_ser = &ser->devices[index];
> > > > > +
> > > > > +             if (dev_ser->refcount)
> > > > > +                     continue;
> > > > > +
> > > > > +             pci_info(dev, "Device will be preserved across next Live Update\n");
> > > > > +             ser->nr_devices++;
> > > > > +
> > > > > +             dev_ser->domain = pci_domain_nr(dev->bus);
> > > > > +             dev_ser->bdf = pci_dev_id(dev);
> > > > > +             dev_ser->refcount = 1;
> > > > > +
> > > > > +             dev->liveupdate_outgoing = dev_ser;
> > > > > +             return 0;
> > > > > +     }
> > > > > +
> > > > > +     return -ENOSPC;
> > > >
> > > > Since it is executing under a mutex, and we already failed
> > > > 'if (ser->nr_devices == ser->max_nr_devices) check above, will we ever reach
> > > > here and return -ENOSPC?
> > > 
> > > Yeah I wouldn't expect to ever reach here.
> > 
> > Will you be removing it or want to keep it just in case scenario?
> 
> I'm not sure how I would remove it. The code doesn't not compile without
> a return.

Oh, I meant, inside loop a break and outside just return 0, that way it
won't be a dead code.

