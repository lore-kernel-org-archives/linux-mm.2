Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FCF8C5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145DB6B0095; Mon, 24 Aug 2026 09:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6AF6B0096; Mon, 24 Aug 2026 09:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00F86B0099; Mon, 24 Aug 2026 09:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6CFE6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:43:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7CFB816014D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:43:11 +0000 (UTC)
X-FDA: 85136279382.18.12B1F26
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA3994000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:43:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HiOCXhQH;
	spf=pass (imf07.hostedemail.com: domain of praan@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787578989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCw4dJI8ZifsRp4I78bl5/NA1XA7Yj79m2p41cLSM34=;
	b=ogPDBZVtjqB9Oa1Wlbhij2uQinjn7i6iLPj++GrjeH8A8XhQTgkfxoC81/smk+sBXdJ+2v
	FU8I2iqx4BOPN9Sc5aa+gpe5IjXEsnM5Mqs/McyxevI3Fj5wMTigPvdKSx1MmX/X32GYn0
	JdxR36YGingqJIx7fSn2LnoNzwJK3iY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787578989;
	b=K+O7CTUfMn5LBjEg4lsec6NyxlnhFs8m5eUrLF9V/p7d3lc/F4Qec9lUYzsndffET61HX2
	+B6Zddee3T+YGartPdKi0yoMoTxSCVuMW5dMigHwWr/aszWxM68GCGRIBKcDZefhNmvsoZ
	aUs4b+WNJ8W8OeNV9kCdiLyZ/MK3vF0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HiOCXhQH;
	spf=pass (imf07.hostedemail.com: domain of praan@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d3b445a84fso140625ad.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787578988; x=1788183788; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vCw4dJI8ZifsRp4I78bl5/NA1XA7Yj79m2p41cLSM34=;
        b=HiOCXhQHFSiLAOC47lFZj+huwbLYa+7l6H3j6AbEJcEGfpLt/IrxwrQklS9FigRM7w
         4uBV7qMS4QUBwATAbbm3UK2jzoxU7QE9LsdccZgPn68uwUofq8mwRfDT6+7MH7qdiEMl
         HyajBhlYuzFWMr9SPI/6/VVE9H5JTuq/WDZctu1yEGyZGpS3+rScJESB7GFHOKt6xCuz
         dvPRpjNMCBslD4M4bKH0K9pkuKM6nKC5gcML8acs0ZcbVsAscdeLEWVghYOVarQGVoOt
         sfAB8QexaC0TNvKHUp8dm5peN8Wy4Ml8JNjW3R7kWe2VCYzo38OsngcwUtePyNHroBsj
         3WeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787578988; x=1788183788;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vCw4dJI8ZifsRp4I78bl5/NA1XA7Yj79m2p41cLSM34=;
        b=rtzEQAFYbGmxJETn3gsZ1tnP4j+CQ6TS9MOwAkzRKtmP1BSi/HfEbFlCKcuwX1wHpv
         hJGm39wXKYj+4+BO1u24pd4EM9gNNOynXIfvRn22GZsKyboYEWGYCPStwicYCzsaqyKS
         YZ4ArC6dpBk+8242Dev5eoAuR2tVkGgyBbp0BOQjXkotoI83VU9p4lgxnqZuyvEj+F2R
         14cvMamwQYm1uH0XJ8//2giei2PtC3lIbkOx+MYMtqB60pJfiHQW4GOwxVZOUbVo9Mw+
         NuC1j+LbPfNXKrViLaJ2jSawEFQZzUL8rIS2ktx5nCfUb+5H7cnXFNuIVnD8gtObztxZ
         Ftfg==
X-Forwarded-Encrypted: i=1; AHgh+Rpf0EhN8GrGYo6dUXRNYK0HqBxPwxpqDxnjug1TwjvQtOLGGKUpOnmKu9xX5Rz1pOoyZm/p0f70Lw==@kvack.org
X-Gm-Message-State: AFuF++kBhyFRp1BrZuKj00/SKdOj1QerNZei3wjzo12qvejNBnUQJkEX
	voKrYYDejWXHlLbD7aovGXCxV4jC+lBmFCs20Ku3bxGwANumn3/6pHF5pBzYjk90Eg==
X-Gm-Gg: AR+sD100ibMLCzBoDhx1gwXYYoJ5Rq6B45Nyt68jcJgmTeYYHUf6PgOymgiE0iT8JpP
	AOhD5G0LhH0wjhMt8ToKpZcYo1Z4Sz0EkvYikC6RhlnPasD+dbDMbI6dYxnIZovcXaSS85TqGW+
	gGDhJfhhpvsoH0uBj9SyZrTtAcBaaxs0eQRgxmH2+64Qlg//pWc0imcAOx+IGS0EahxqDFfs2Kd
	VSK1x5yVZHyxrFozUSu/E0MzqHNpe/4fi03p0ok1xkOkk8jneZ3ZOcAegLK0B3fAHzPwqsROzC9
	Vyh+tsBiFemzGv4YgThzfru4QVkcuQNidG36AMDqioDPn93vbpeGncQ7M4SZ+TRh+Ew6N10cqI3
	UwtyUSjPZbCULAJVRIwIwsk1WVHkmcdLE5FXzJGZOzLAbKnninNBy9x6pmESrAf+zOrxmJG5F0S
	yFtYO8ouVAEsrjwwg1ikYnEaLeVrDP6bJjEGapaSzfZlkjD5oMdjHL30I/oCsf+Ab7vFx/uyNOR
	az+7OwxlK7kVn5ZIA9KPDi5yRdegqBduuRe
X-Received: by 2002:a17:903:2384:b0:2d5:db3d:1a44 with SMTP id d9443c01a7336-2d673bfffd2mr8845215ad.17.1787578987936;
        Mon, 24 Aug 2026 06:43:07 -0700 (PDT)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e4b2b97fsm10656102a91.16.2026.08.24.06.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 06:43:07 -0700 (PDT)
Date: Mon, 24 Aug 2026 13:42:58 +0000
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
Subject: Re: [PATCH v8 08/12] PCI: liveupdate: Adopt ACS controls in incoming
 preserved devices
Message-ID: <aoxKYg_9BXs3U6fN@google.com>
References: <20260728221007.2098560-1-dmatlack@google.com>
 <20260728221007.2098560-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-9-dmatlack@google.com>
X-Rspam-User: 
X-Stat-Signature: zsxaueo3ph79ezka9d6rzifpsz7s5z7o
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA3994000C
X-HE-Tag: 1787578989-380120
X-HE-Meta: U2FsdGVkX18ynF0caFanNOInQ1Q4P2fzID/Wr4yssuhMaGDSiqHdT89/5iZqOzEfOyzZ5NACQaEocJCrctJ2yBrTkvK6E7hxgFsIAmVW0AJpnYDUN49pSBrJsFkm5bOLf04eOZ+Xx3TIHPLffIbbrQ7WBpC7Z1BUMX1xWAGEaBmQFMJPrN5z/EY+Iy8g2HnHoAQnAeZorI1w/rv3bN6J14Esvk+8COMLSxMkAxjHWRdV4BtSxLOwCbOGG4lMTV0Ak0GTm4XdpBSB0HAJIBGVxNoFQnD5hyCLL6U4EZhre2r81eM3LWFPTLbqZI1d4kYqYgw6GztxjR4quk3ju/b8OzZ/ChjUpWvmX6Y+jsjaWYxyA1dMqaKiJxL0Tk60N+swJl+bzBx+HV9N7cMTWhE+lUgVdqnka3x4Sg/oUpEbjFdq8wmRh9KwwQEdJjKGKpb+DlUX5GkrOhTsomnIVqlyv1hcAk5Rv6cXE1+oJI3A2iKYlq+iQt7lu5b/8hmBozOK8W8swp7SyKv7s0uzEj0WHfoHCymlNwYX9ZCF47/TB/828oQweEPGdn9GCchrDd+tuwR78oPSxdI09j7DlH5lADjBg767IsZa6aMp0DpuabF/QrqIbJ62cxTOeW/L8j2/Nll4NZ+HdpUbxsn1iVPjwm4ELaxyMpcIRaq6cXMa2vwDGoVQGjcQWiKIi8WNRm8ehqTrYW/2vVpIicqUbYe+2MuGLei+HFtAFR7/sMDXcKXlwNZXGOztZa+Z9pMfqmTPS6wttIl7Fel5p6GUdFVsw7nYyXrJie3DOV16j1n5AZmWZKls2oYMis1t36wSUWZy8TPcDNf2YgbftcnnN9q1ec3pP2Q3hM1xaXx29spt+DCu/uTR0RjySgrNtlw6Oet6jSAJU3kgL0k0TymI8KBH9JyHSE6bja5c8LM9DcpbOUwa41g6f0q3cLt4ERDMwCEofVtmvGf7VhaY+SpFm2k
 YEBIik8y
 y4/5LjYZtmweT8Ch60Tg0ljuB9j5hsIam+Y8iAXkV3s526/HiVaroZklLVgwBq7nUrjpKBWdGlWwBOJjGikkRJ333vJqysxF6onfhfmI4Fu3BEQyXyytcH8g7twDXb/D99+rSwvv+Xi446bRg34gbFWHFeIpt7D7ww8Nio1ZVck4f1ptJNvN2r6e6dzvNDLXI2tbjrDSJadJJZRPpID0PUKmeBmrUp1hRugVO1fJ8V6tOIdl0I4l7iExugHzjYJXXUjMSeYYL42V4CSX0to8ooHyEzo1YqpVtb1nHenMC+HsNXJS6iA3HP6k1zSJMRRDOFVBl1EXT7IXp2Awz7usJ78BWWgD8IdEJ4M1lxgDeIUthADIX1b3Lwslo8ouvD5cirOWduizAV7aQGAxrtEJVQP6a+lNJdcx9mkcEpOCc+4s3d4a6uVJieBgSv5TjBpzm5VRVOYffo9jNBec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:02PM +0000, David Matlack wrote:
> Adopt Access Control Services (ACS) controls on all incoming preserved
> devices (endpoints and upstream bridges) during a Live Update.
> 
> Inheriting ACS flags avoids changing routing rules while memory
> transactions are in flight from preserved devices. This is also strictly
> necessary to ensure that IOMMU group assignments do not change during or
> after Live Update.
> 
> Cache the inherited ACS controls established by the previous kernel in
> struct pci_dev so that ACS controls do not change after a reset
> (pci_restore_state() calls pci_enable_acs()).
> 
> To simplify ACS inheritance, reject preserving any devices that require
> quirks to enable ACS as those quirks would also have to take Live Update
> into account.
> 
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

