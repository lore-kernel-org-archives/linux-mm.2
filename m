Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 488DDCCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8886C6B0095; Thu, 30 Apr 2026 16:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838956B00C3; Thu, 30 Apr 2026 16:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727196B00D4; Thu, 30 Apr 2026 16:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6435F6B0095
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:49:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 095821401F1
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:49:31 +0000 (UTC)
X-FDA: 84716412942.10.BA4FD55
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 05B1A14000F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:49:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J5wLcuue;
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777582169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hkx4tLK7DpveuSLFftKdSSEC4NdhOfO2fjr8Ook6ULw=;
	b=1fJ3oH+4Q75posjxUbFeofOrrbqmn/OqWXFscA+uhLQ3OmIqnZ4QqF2qRCfoMhsmj6m7Y0
	X2UiDuFz+InizDbNT8WjqNSODkfrLr4h6W1hzTiHps6//H725L7pz8u+QjL9oFUfDhh+5m
	tiMfUBk7L+iCF3uogclaBVMebyCi9ms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777582169; a=rsa-sha256;
	cv=none;
	b=YKgT8h83FXYvAaI4UzPobfb+1rAF6F6IcO9jfYUta07sCSSeoDDjVlhcE1taPY+uM47xPE
	5rxorv7TufuEpM8HG9+GVkQbigsKnGMczqRgFoALqXisbfVhh0ul4uo8gqWkKlh5tvn557
	qjAE+AdVQBXcWFcop1qgNWIp8zuG9SI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J5wLcuue;
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-362bb3260f1so991828a91.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777582168; x=1778186968; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hkx4tLK7DpveuSLFftKdSSEC4NdhOfO2fjr8Ook6ULw=;
        b=J5wLcuueI60CoyvKEhl6f5xTjNUS9M+Trnh2cYR2szEWDC02dj0awf/j+shUR7hwSJ
         fQ31AdzFDijp9gbZq/SUFEGCCEJooVQEqBfQghQWxHR3/HOk6xouHG/y/3BudpVxP4Rv
         cPrH/0bMkd7ZRQ17KzkJbncX0MHEf8gXw/x5f+kVqDQQgeTrmtRiznDT7PBIzq+eYotE
         PxfHvVRi6anyz1qw6newBQl9ljTIEP4C7UFILvEzOC5KVJ+GICtGk7pW4Ae+pc0KcBBZ
         d7rWuwJQaOp9dupmMGHrR2BHM+TRiJlkjJ056SN5sGBczD3t7boB97UWDAuqcmsSG3SJ
         tyVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777582168; x=1778186968;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hkx4tLK7DpveuSLFftKdSSEC4NdhOfO2fjr8Ook6ULw=;
        b=XeYW960Y1Nrf+nibrJNtt4sb7mEi3Jk3Vw3xdoucBW9s8F2HphMpRtOqcbMZp/swW0
         cXAdB3XmyXPTwrvu3N5XA7S7UMyedlMKf+I9f12h3VvMaRjjXdSMPhBxXuqtwxthMDXD
         DOOGfmyPjbomjmZe70g03A0V1SzcdclLmhp9yI7UEZ4IQFkFWcNP38ja2AGsOrMvFCtV
         7Nbe3fD+ESngPHRxh03WjTfEsCeSxHwK/WGJnz/sMU4bSprs5rgalAvL7/x1dVVShRuS
         Ox+j2pYzBr9hc9vwulnQ26tfqVdi6vT4Nuj97gusoCVW7apRQ8z8oYGfh1AMzr1wY7xv
         OTQw==
X-Forwarded-Encrypted: i=1; AFNElJ/UCHmvJfUyRzqcOZwO8FPY/qvbUxcxgRDk4UlexnyXJkSdu1SqSsfTPxXg6gkDlluJp0ctSowaFQ==@kvack.org
X-Gm-Message-State: AOJu0Ywna2PCvCI0yNub+B0wSjLMSWHsEA4lzvVL3TD9uls2+CyFF7Or
	bRUKhD1vIGwzTeczfiyzz1dLIiQN4CvwXie9C9AP9h38tbd2Qhu4VLfVVAlXTzo28w==
X-Gm-Gg: AeBDieuPpPJyq8acOVxUKzMf1c3CC9/NIXtE/a2ccu4ibmqLrRnwUJiLt76dnRmvyY8
	Mo6vM16WR0MH76suJBUlzZ0lrAf0IwaiO+ags5h52vX4L5aF8Kc0/IumTxqR//cyBSpCtGtRuoa
	cSCX0PydVDzfKTa+fessNMXXVkIktgspalkD5vU+muFUq6rHNB/6xk/6Z1XcVdkrdw6i8sT8P/F
	xLoz51Th/q5+/lv20KV3ZS0MNGeDrEwQEq1IykPSu+Ym+oXlENf/QRQ+yfzoQ/bj0Sx1yuRLmLO
	3R9e1BwjPHlB9T6PxtMdNbTn9nXfDUOrtKg+3sIfo7k2622gk+u5UOrCvqV3oVAAkhPJYhmxtJH
	dW+P36Z11ZjcuVnaVVPsinEIgRGWyZIp1szA9g0/2vd/mmeNCB2T6HRXGuV1SSFPrLYh81JBUs8
	rLwVO8T5Y97RYVUxTG2I0Y7dkbsO8n/jwMRjtd35jSUoAb0xR78ARz4W1bOefVwpG0wjTugfAVn
	DZOEg==
X-Received: by 2002:a17:90b:3e4f:b0:35f:b288:8e4c with SMTP id 98e67ed59e1d1-364c30cb4f7mr4328476a91.15.1777582167388;
        Thu, 30 Apr 2026 13:49:27 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364ec00b094sm307888a91.9.2026.04.30.13.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 13:49:26 -0700 (PDT)
Date: Thu, 30 Apr 2026 20:49:22 +0000
From: David Matlack <dmatlack@google.com>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 08/11] PCI: liveupdate: Require preserved devices are
 in immutable singleton IOMMU groups
Message-ID: <afPAUiHoqoZl1-4I@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-9-dmatlack@google.com>
 <20260427135625.0000413e@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427135625.0000413e@linux.microsoft.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 05B1A14000F
X-Stat-Signature: sduq8dkncgtez37e8d7rqxarsfy4j99c
X-Rspam-User: 
X-HE-Tag: 1777582168-900627
X-HE-Meta: U2FsdGVkX19QO8aIXcki1VFPmVSZvmm3ozxvDIlXvkFDrFNi7gLNyPEEF68gwaKra7DpcAGdWfzqFRcFiwkcvGl5+f1RFv/0gOUPDydP7UHwjvcHGKRJO5p2+LN5La8hbThlsqwQVRX/c/nBCJEPFM52pBi+C/clK924bQlaulM1AheXVCoggt26xOaFeobcdzbti3LHMgkIOQ6cn2uI61rj7JtMtchGbJVQBQ9RedqTui2PU8iDSzdKjF+hpPYkVeJprPGUbiigXPDboYuDotohRNUn+Iop03GPLHTvf0xm+fB9mMZtx96clR5Qi+FFsoEWnXQn3cs3xjagCn+qhTbyBfezemYtbCY0zm+QRJID4GF7WQkErobgxOD/cxUQdTKHOJVbTBIg0oakdgXovAckT1yte7QQW/74gzSzpW0IsIkCGS0tYaDiYEfLI7t5S9Pq8n7D8/ktdRrAVGQQh4leASUKN3eT2UXhYkDZlYtSkUOQ/Txkyy6fjlTJwDfjbG0dRaGhxfv0EOyB1HNFB+encU9Ip+JKkANwoDnmtV7xdL9Sb5aIfgistNzRjALhVB5beDLFle8euL2ytodn76Mq+w0hxWAsge3iTg0oA1GELP9JrOxX3EZ2aDZe34UMEOGHUPpv1+h7SGyvDHSFlWEuY6Qr9boBglI4WPDYLqrOzschztfBqofmqxqw9jx0xdQHJ9pTidnUPnbrtjOKkQmmJ6Wmuyk8kyq16swnxrf+y5+mR/N4znrDO+yenxGQtj73R0qbmyeZqDCVEZfDqY0tRaU7FUcECEbLzpaNa8KEB9w4Jvo49GfFL3IQpuSt4u/PWNMXJwI4GIoApDoN6d9sXfdSLIKDv7dsf3PPDw8KP6rEHdJ6hwuGPTYWUkRKbzH28pk3ireGE9qPjuSCaabldnriqP6QJzwH1CMYE0E63cBwLVCaJWg8pRZVFRG+x897v9oP5mbpyvNqd0G
 VTk0cutd
 pCBUoj5MdA8VLFGqekbfsRwtJfdkfBrezEqKsr22tVg81+oi1QzfT0hxB1DncFKhPsf3AKV5MX0YzXYLeHUpGCvZtfam1czvzyEPnnjtBlDaPo/sOVVVpsVH2YVQRfpPLfFstRkNFeDKGKa4hLFVuHJKjgsjt9MYve3infXCs5BL9f3+U+qDiXWep4L9H71tj/FNUdMiiW0xJcH//QVXcte7vUGJePp/yeRgqxYMosUUkNayfFuXHaMmzMwIQs1Z/eq95RzB705vQusMRQv8teEHFs3Tv9XJu5p23i3M2/664wEk0oDRarDjv17tQuO7rlY64TmFNEgsvOChrW5LUOl29u10dnwgQcTcwOl5sqTwR3X0iG1/H9x90pgzZ4GS9YhCnBAo1HYUXnlN8fCUd6Vgi2qCWhc1hwF/Mk/pYFSlyWUtoowvOhTPtDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-27 01:56 PM, Jacob Pan wrote:
> On Thu, 23 Apr 2026 21:23:12 +0000
> David Matlack <dmatlack@google.com> wrote:

> > +bool pci_device_group_immutable_singleton(struct pci_dev *dev)
> > +{
> > +	struct iommu_group *group;
> > +	struct group_device *d;
> > +	struct pci_bus *bus;
> > +	int nr_devices = 0;
> > +
> > +	group = iommu_group_get(&dev->dev);
> > +	if (!group)
> > +		return false;
> This may not work for noiommu mode where we could have a null group.
> Maybe I can add special case later?

Yeah depending which series goes in first. But based on the other thread
I am going to drop this patch from v5.


