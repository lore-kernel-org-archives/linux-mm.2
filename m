Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11D92FED3CB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CDB86B00A7; Fri, 24 Apr 2026 09:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F076B00AC; Fri, 24 Apr 2026 09:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66DDD6B00AD; Fri, 24 Apr 2026 09:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 543526B00A7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:29:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAB2B1C00DB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:29:30 +0000 (UTC)
X-FDA: 84693531300.08.1E674F2
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id C760080002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:29:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=h31gmUPv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777037368; a=rsa-sha256;
	cv=none;
	b=zWX11vcO7cDWAjankwtEPA5Xs7qeXFZzr6/+IvVQz9TbYrG1chHi1JUQNjF3g8ZeMA2+c8
	XCWnWeMpBwBbndUoNwCfYkBMp0AtoJVKw98/zXl+A6YWuEzxF1IKaqeTXtbkkEytfSLqA0
	3iR7Qe4uUkzQXAy1B10DhX34D632Fvw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=h31gmUPv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777037368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ezbOz+DNq/Ln5lGWJ2GbxuTePwedL+fzC5CYxvFRhc=;
	b=htumIBNYWLI9hc4+V4y3bjXfj06PWjz5+0TOuwIt3DeIxV/x4OrpuQ5b8VMf2cu1v3epDZ
	jJ4gsxMLTSIXyRIduhG5WFA4CvRn7zzAaEuOoaJzsGiCwXbkNOFkHJCReKbJ+0/ug18vF9
	FT1euznWdYRr56G1VRJd2Eqm6RBB20s=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50e5b55062fso51167231cf.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777037368; x=1777642168; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4ezbOz+DNq/Ln5lGWJ2GbxuTePwedL+fzC5CYxvFRhc=;
        b=h31gmUPvgdVAeY4qK62MV9LFGVpfY9pSJyUH3WPMnOXKzvNZGfjnS6rVR6vBvJwUyU
         6ENnFSlsZkWq6i996dECKNNp76WflOL4UQaFeYylTXKyGWWj0ZQy1eFhJpvMhpNlj5rJ
         xSRAozbn//d/IIIBcb2DPNXzEj8qN3Kb/TH8VhAg8PSiDOYYAl5rt+yaqvinf+20jaaS
         Sac07v1xVQckn99uI1qiqrj0vFY21neuxtNKwx2SdRzE2k/Xd3m+3vWvx29I/qbRNTUB
         +zJzTxtucO9h/VAA/h76Mme4Utiz7QTrWkAMUFmtLmawPkGp4cinQ+QYTj3g/LIAR1Sy
         PlPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777037368; x=1777642168;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ezbOz+DNq/Ln5lGWJ2GbxuTePwedL+fzC5CYxvFRhc=;
        b=DmrBVfywk76S//0hgyfX9JZxn/L2MLVCOCHwPBdUC9fjRKQXUR74W6oODYDOjRot15
         Rc/Ce/qEoFkG4zJxR09FY6YCytSYa8Iate9cYhmbxny+WFeoRIGtmuV5HteG48VZpTPz
         YoWA8Xjnt07VzT0Nq3RL4mvRkIeBHuv2/FgOwxfw0iBJ+znibutoqJGbZDNahf82UCc2
         1hfKgdl14+kXLJvpvryyjdgpdZ5L98/iHvCYwkMdC8PLxCPR/l5w6ualvIl2G96ZTmEI
         a863mj0WEmxqBwt+xEOXMtI6zwBwI95FtjtR0pu3dzjzF55oEADhRfN50xiTFFN+SP8b
         Q3Mw==
X-Forwarded-Encrypted: i=1; AFNElJ8KmKs7GH2qsr6EVogQ9rnaP3z/SP5TrVr3SgRnIRiXelToYTvzQWx4wUwpmWtHH6aE5AJTUUDNBg==@kvack.org
X-Gm-Message-State: AOJu0YzkLNSXXpuZUSNIqfU0jnFbcaxcwoIkIoLqpSlqq0G79x0W0jWf
	MEXZrj380TkIsgg2EhQHIixca9zgYnJ2olnZ0EybvZsTlVWMsaNKz8egxR+62YKf8pc=
X-Gm-Gg: AeBDiet1Eb7BcTMTJXNH/kOdekbaiaXKpHWApr7PtahP+w52vOHBQDJF7qO4c1qdKFe
	1S7pU6g4wYIucGQ5+XXgto6y/608V9ZtBb+q99BQ6swOpytSAhaLqiKv77jw93AEBXDH1KMd+0W
	frzhFiYA4ApbTFwh+sDC0SYj/dIiuvzcAsqDYF1knCnusao6qW/ckNdLa31l0ywe4sJcMCFDzH3
	FmhqHnuTLk6wxVmGyni+fQS8VBDYFxSa8Hk+fUHgLiH1IoZD3SBzHlVK7FokszApEFxWDsEaB5P
	qj9lhyK/2xIV09i9XCPyt098slDZ21VybHzFPFa3ZPAqrrCDJsC4LJmJASn+EovdI3mG1r7rD2L
	F4dL0KiE99i5mRtKpLWVswc2IkBNAltE2q+ZjhwPUWg+f3B2DQ4J7hI66oEsgbXoS1RWM69PRgm
	eAXPCTe5Rf0pG15clkbkAADIqRMikO1JDAWf9x7SucVklLn0KvbNHV0N9AboJAFA==
X-Received: by 2002:a05:622a:1f0d:b0:50f:c36a:381a with SMTP id d75a77b69052e-50fc36a3bd2mr157337571cf.55.1777037367645;
        Fri, 24 Apr 2026 06:29:27 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50fb5fc8e04sm101886121cf.13.2026.04.24.06.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 06:29:26 -0700 (PDT)
Date: Fri, 24 Apr 2026 13:29:24 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 01/11] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <aetvAkM0y45WAmfV@plex>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-2-dmatlack@google.com>
 <2vxzeck45yin.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzeck45yin.fsf@kernel.org>
X-Rspamd-Server: rspam10
X-Stat-Signature: w1eoc31emsnztcxhpcoebbbo36hnzgs9
X-Rspam-User: 
X-Rspamd-Queue-Id: C760080002
X-HE-Tag: 1777037368-423938
X-HE-Meta: U2FsdGVkX182PZl+I1f8FyLDwf+bhhxHZtnVqlOdpTE0DjsFZMN1mPZdigT/Sy3qz1FgbxRS2SryWBt+1EGMuZiLlUazA8GocgO+lANXQruFWQ0mF+gqw0g7aX2B3q+XYyzDfNy1e3itopTlIGSWDMgbkNJTigBimemhWhiS/hAb5/HED61oA+JPisjzHyiljrI4754f3eLpVObJ8qI6VePsxoYp5P7VRSPlxHUBHBTFSs3z5cQE7TlUFCGBoSfXJSAmfc5axjKsbQZRQjcJrEi8yaF1I/5IEFHMk0W1QSdgYWpYjncVzKX9qLpRqOWS5PHyBSbc6YAmi0M1IZ5kgAmvXzHH5tedO2/fV530y6hasbA5xZvkee4DDfvoqcOfazT5Ne7fcfjvln7Qq5Ik2VzJJh2o+GQycwkWoWH/6+Kgc+4xdq1l84OHnHMWnCDvz1TDlSmN7iQDA0DWvKH0QxfIzUr2INvGQetsIphqQ2Pv+4ZgUx3WFFP7keSvbJxNOrwJJ/eAbl8F2EgwwJJF0n+wq5IC36qENy101xDLZ34ir35CpL5EuT6/Nl8xtxexqcjOJUkn3yvKgKR3WKmgHgWhnbmASuBcCvEI3l3dxX8ctAdpW2jyoscWtnqJpdR2KIEKwzQfjTr5o7O6VzpmOmsVO5d9OAH87WKEghFBD/rIp6qkB80pFjqZCdyJGt+tAwG2zTj0XzLV77l9JD7nFNUK7kw6dVng94wwL4Xo6EGpEneYEDHXobSCqML/oQpV5QWZ7So2FLeQlh+eYUSGWuqxizjUhYDhkIffJ5YRF38Nz+h03/itLqloSKLBep+a1ovWGxxWmc58JmxrtHGgMeRCKfjOr1DU5RvIOplyn1d37RwT5X4bfWPDh4YdQRhXLVxqOHuX54GH1BMyUU0potcW+weCeaqBYIYnRuaduC4vuac5hTrwpWwHg8aXajRWUk3T5iUQUaB2y6pN2GT
 5aXBeUCg
 rHta/4bPm1CHVAejArqZLGltt8rBiqLIYid0c3uxHgZXyZnoucUSe3ss3As3Tk+Zls2SzKxeKLNEt5EJqabRJ/DHkL8/+Vwr5qcJ95RGIzBHc0AToXfoJberMbbc5i4o2PXVQTvi0JtiVbjGeN8ZYbVxkt1/We3EMcHVmIa8I4T7jLrPFsW6qt9FPMGf6hX1cHi9e0rbCFOhzR9FVxRuCO43EjLYX34/C6EJuExRwTrgs2LL218dCK0dlo/rz/esD8js7g0LL9MN0VKNfJWrIOSYBaVC7sOsbXMdnnwoBt7WQD4CoyDlSqNgcwkJPqRi7sKmHTlRgKEFvGwGml45f4aB7vHKhxILjk+KFoddYNtOuYfHVUeyKralmm+Rmt0JK5NU4Z9tROltj2DhQsgSMNtQQ5pplT8mEy3rc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-24 14:33, Pratyush Yadav wrote:
> Hi David,
> 
> On Thu, Apr 23 2026, David Matlack wrote:
> [...]
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index c9b7b6f9828e..94af31837375 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -20555,6 +20555,18 @@ L:	linux-pci@vger.kernel.org
> >  S:	Supported
> >  F:	Documentation/PCI/pci-error-recovery.rst
> >  
> > +PCI LIVE UPDATE
> > +M:	Bjorn Helgaas <bhelgaas@google.com>
> > +M:	David Matlack <dmatlack@google.com>
> > +L:	linux-pci@vger.kernel.org
> > +S:	Supported
> > +Q:	https://patchwork.kernel.org/project/linux-pci/list/
> > +B:	https://bugzilla.kernel.org
> > +C:	irc://irc.oftc.net/linux-pci
> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git
> > +F:	drivers/pci/liveupdate.c
> > +F:	include/linux/kho/abi/pci.h
> > +
> 
> Can we please also add these files under the "LIVE UPDATE" entry. The
> code here concerns both live update and PCI. We can figure out the
> maintenance details as we go along, but I think the live update
> maintainers should at least get all the patches for PCI live update.
> 
> Perhaps also add the kexec list here? We plan to use it to maintain the
> LUO patches, and adding it will make sure we get the patches in case
> someone updates the file list here but forgets to update it in the LIVE
> UPDATE entry.

+1

These files should also be added to the Live Update entry, and the kexec
mailing list should be included.

Changes specific to Live Update should be routed through the
liveupdate/linux.git tree, while generic PCI changes should go through
pci/pci.git. In either case, if liveupdate.c or abi/pci.h are modified,
acks are required from the Live Update group.

Pasha

