Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC4AFCD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 03:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6E956B0096; Thu, 21 May 2026 23:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45CE6B0098; Thu, 21 May 2026 23:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D839B6B0099; Thu, 21 May 2026 23:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8C516B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:59:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A3BE409CC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:59:50 +0000 (UTC)
X-FDA: 84793702140.16.F57CF75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id BBBC7C0007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:59:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TY0ImQzy;
	spf=pass (imf10.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779422388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/gaClVuyqlkbt2yK/hC2NqGH4xbGZ4Tk12L6ljTkqY=;
	b=0H8axMvBjabC3ZwpE3RL7GSSVcXEmwFoYLwXwz7SgSSY9ir7Jp/cghrEmxGd+KYFUbb+s0
	/LEhNm2Rg6EBtSXKWMWtUJLPcAXlO74cPWLNuLI4s0nv5zF9u97DJvNt/kyo3G0j3HO3M8
	dgu18P4MKejDFkr8qsiVhIaku3J20Hc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TY0ImQzy;
	spf=pass (imf10.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779422388; a=rsa-sha256;
	cv=none;
	b=x3p0Kqco3vmmpyOJVhTZjQlSs0PQbUUj+VoW0T/C3BG2tT8/wzqreEJUK+4dKuL1qz1Tsc
	ohsDW3GpJ3Igc44A8VpNH7VhzbioOSMLyagCBgSB6R9/RrKJYddHxWp0edKdQY6t/1oh5P
	/5KB62ZpVrRUULGnpp7r9MPiRLEd18c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E111E41AE6;
	Fri, 22 May 2026 03:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D00C1F000E9;
	Fri, 22 May 2026 03:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779422387;
	bh=H/gaClVuyqlkbt2yK/hC2NqGH4xbGZ4Tk12L6ljTkqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TY0ImQzydhJitS5Ddrvd57wmJkpFKQRHHejclNNLrSp/Pt3ZjbuAZXZ6t/deQEjPo
	 B6RG70234GDvgoN2I1JfdyuZjEp7N7PcfGq56V+OZOfrgX/Kj3BGrDRD6gMp7QdGaZ
	 3XwaJGMmhDnnGJ9avnNUQFntrpWJ2DEMUmgcarvpvvrVDL+W/u+6c95VquTHO8Ly9L
	 YhjfG/p75Pd4tjFa4tixP2g+M6KlXSRuVMElS1m+U1YdvCaX4tSQDzEzY1TnKgRNIH
	 2N5F82yOOXvzqrpGDeJFwkB/Mn2fFSJD/5ZgU9X/duY2SuPkz1gG+tRoDpon4nQWBc
	 dSLeX2oApTWMQ==
Date: Fri, 22 May 2026 03:59:45 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <ag_UsW_OrlXD9dWX@google.com>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag9D6_7dttbDGHZ6@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag9D6_7dttbDGHZ6@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BBBC7C0007
X-Stat-Signature: bsc3itgeq66n9tut78c4mrfgbhkir1pn
X-HE-Tag: 1779422388-662269
X-HE-Meta: U2FsdGVkX1+1xCrNtzf+9sAGKyI4qXNSvW0A98VYNoC7/nPP2xotCXKLwkz/p7r4tZC2UMA7bMGT5aZzSYG94Zn52/rPC4IsOixbuITcaD+gQ9bNUBnGeoy54O9DK2KsVpk5HeXap+YxLHjK8hVW335p/IfBSDnpgHttQP+RSnFRAkafHelh3gelNWoVfEczjn5f0OZdcTBcl/AXI+0E4adPOtjHDlDYb+GYO3q9PuOVPoVMOKBRuG4JyCQGh6dPA3WjNsVLzW+mGsKz+F2Dfz3CCTcgTxu397VlIA0Weg1vNQwaXpQ/SCmp9V0RVHIJvXBcOELMViOYt/V02ETdqY10JsQrBMW66LZJ+J7oY1v6902jQqln9gkiQe5Eo1VPViCo3yuRE6U/iyOten7aBvCFRsnOjCffeETllbt5iYLsb24BfurfemPaxbZCy9o2krNpmFqNPFRHDs50FY046oIzHcL+RawNUS9EAYNtfpxaXHSnpoBegEXiDZpatIxm9MwVEPx+wlaoe7ap4ohMrMM5ssDvaQDTjkPSxjK0w1BcxpJD159VbNs92IbisjCZprNrZP13zQtRk4Ngu/rs707Lv1F/sDWIYq9nGbbdcUZF2L+G0Ja/VdYnwSW0s1qWy4Pv8J0srrAspk5rLIh18snOZ/PuQDplQbLHzcrn8OGm/MnUwNHHdX4+fnhSGbNvZqMHkbaVgOmWfrB/dT1TlBdIk2tNR9jzpEOJ04UABX8okgny97Qjsf/DuFQsB7hJFxm5u1sZM8C/Z0wUgq8mT+2ysaChlCw5ZBgzuF0hcFKs47lisN6Wh3os6fL5MmjhHij+8rjGfhBlFTxPFlJEekPBaiBgUkcDtb4pB8UqHcjCo96jrYLkMXiEIyxLZXi7kqo15/jziiwJjYkhANFvN5GJR+UcW2RvFdShYyG+m538LCM/EvVUooJipj3yO5vV4qV/5dCXf6NIcE9miUj
 Wjl3ikUn
 un+MRQfrHDicE7i/weS4tLbKQbodWj2vDw0sfoAkp7getkjiFJNdxcfhmhswjKv+hyw0PHEQRMfZH4N2C6OCFDPzZmdLXb2eHcwYN29n3DYKeSVB6sQD0QT5sTT2etyluoHjPUg0nx3r8A3ZRmN2it8qPxaTh71Vl5+1Q5FCx5o+T/ya0O4xObtH+LwZQluA09FU3Yuj7ZwNVL31NCJySyqGQOuXLWnuMrl2u2+ohErp9doMExmmvG956hbwAR27QaWQ73t3TqzSDSykgphDgk8nPdh0xoVdbBO+P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/21, Matthew Wilcox wrote:
> On Thu, May 21, 2026 at 11:57:48AM -0400, Theodore Tso wrote:
> > So let me get this straight.  This is a magic xattr interface which is
> > not even persisted in the file system, but instead sets a 32-bit
> > bitmask in the struct inode which disappears once the inode gets
> > flushed from the inode stack.  And it uses a generic xattr name,
> > "user.fadvise".
> > 
> > There's no way in *hell* any other file system is likely to adopt such
> > a broken interface, so why didn't you just use an ioctl to set this
> > magic f2fs-specific flag?
> 
> I mean, yes, this API is horrendous.  But it's just another example of
> f2fs thinking it's somehow special and not just enabling large folios
> like other filesystems do.  This hurts everyone, not just people who use
> f2fs.

From the production viewpoint, I raised a concern on setting large folio by
default, since that exhausts lots of high-order pages, which were needed for
essential system services and critical apps.

