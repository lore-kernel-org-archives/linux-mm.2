Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13530606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sj8B4eAd
Received: by kanga.kvack.org (Postfix)
	id 2C7836B05C5; Thu, 19 Nov 2026 03:26:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2774D6B05C6; Thu, 19 Nov 2026 03:26:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18CB46B05C7; Thu, 19 Nov 2026 03:26:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E44B66B05C5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:26:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 753E81209B8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:26:35 +0000 (UTC)
X-FDA: 85451187150.29.894FE40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id CAD72C0005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:26:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sj8B4eAd;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795076793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lD0avvf7a0W4YUjuR/w8gv8cSrs+orKdOF7+3MwyUNQ=;
	b=3KM8SiYWbk1GY3PAnOtfiHpJIXr1qw+63BlBkq/EiZbmKmCZvmUc7CBHAU0Zhfrtc1wkk2
	Ok4JZX6SqV0KwfhLRbIz2JHnPi7NUPU2TGogvohBE6xrhTaD36kU5QYzoTDTBYbza3/w0h
	qOZbI7lPI1wNV3wt9rtNl6FUrQG5jOU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sj8B4eAd;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795076793;
	b=aM1Y2oHK0lj77e9JBfsDYP2l/iv/gBiq2UWBmGjs4uAoU68+1pWgev94LlO+VCFl4cqdC3
	RW1prE914frVig3E8/V49aoYD10f/B7eB7xIlP+GQG0MpiTDSyOTGu6ADRsgKyr6HynOds
	kAugn1ozTikuAvRD8XmfsrG21uiVf4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F02FE477F6;
	Thu, 19 Nov 2026 08:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79641F000C7;
	Thu, 19 Nov 2026 08:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795076792;
	bh=lD0avvf7a0W4YUjuR/w8gv8cSrs+orKdOF7+3MwyUNQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Sj8B4eAdm1rPA9A9kvkOW8aa2I5KLj2Xu/ZsKGea/JgXDyGjOlLQUJtWAc0TAxLtg
	 eJ2tczDWSyNfNQwR4liU98aTbgD5uB3R7u42kznXNtoxXjknWDEOEPssSP/IP/eD2V
	 hllgA1tTb5DIeyTnCjLheGcOjcgekHLHkk8H+85MimiyKJ/LE6FvyQtLBUwE82qMIZ
	 e2y0muasl5jH+rFsYyYpQVYpUQItMrhoO4w+o4NMMFtJB5b6p1LMBxB9GA2D4qzdV5
	 J34lgUafiEKU5K/Km9nyJjLo7P7cuZ01M6BzfiCxMDeMxnmgxW1T+zdxRh2GyQoXJS
	 jg6Uopcz1f/0w==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/2] kho: drop the incoming sub-blob debugfs view
From: Mike Rapoport <rppt@kernel.org>
To: Long Wei <longwei27@huawei.com>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
 akpm@linux-foundation.org, graf@amazon.com, leitao@debian.org, 
 corbet@lwn.net, rdunlap@infradead.org, linux-mm@kvack.org, 
 kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, hewenliang4@huawei.com
In-Reply-To: <20261119063800.698863-1-longwei27@huawei.com>
References: <20261117092951.4017931-1-longwei27@huawei.com>
 <20261119063800.698863-1-longwei27@huawei.com>
Date: Thu, 19 Nov 2026 10:26:26 +0200
Message-Id: <179507678647.425130.13205346175314463200.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: fxxobbfmxaxmisubb8wiawyyyws9upzm
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CAD72C0005
X-HE-Tag: 1795076793-193034
X-HE-Meta: U2FsdGVkX19XuQHfHp6ObOd8MV5dVBAiXOjixhdeu8r9B7hbJBkKaq6h3kVwskD09cpGa1LNuP8UEI4uXee7NJAxUxsUPT4P0dAqRDlNnppp59z6tNGumPqNPFSwO96ud5JiEnzu7G+5x4+JrpbrDms25EB10t35Ek6thmXsFPHlRpPjC6GLgvthSx+g4SvsF/9iYMJid9mIIjI23w9XYy6qcawq7Y/HKasTN1peepM4Zxpy5dCrv/f1RYBb1zzCvdGy2hjm6RVIucKAmFXlBC9jWNcFZW54N5DzzUU9BLcDelZcWCf+Xx/Z+QzyoT2DK0QSV13BrssyEJL5nvNaN11BZiL6X90f7GqkrHeA7PLE01fx5K97DnjeuP4NVpjKE6eVSTCx7uQAKs+p2EARF5g6FZK0pYhvLJE3OTnZ87wkUVmiFjo+HHi3cJU/VC3rgH0NB2cbxz9gCF9vcVKJ+2OENjPTsmZd8NUF0xcUjhqSaRhbGFEaLkJOGxPxOpUAryEcHNJo+9UttbyS+hOy4GMmbvlOjvuKlu4GSsPeieCkH9j5S8RNt4VE45zvRCarzQR2JZLd7IUti8dhkuyPoRU3RQZOITmbtF5QstaKullfZRs4w3IF0vBr2R/ASsYMxqa7bV9FE7TIsoAnoeZSJ5S34wdU/CJfXOGShNGw3NfVG2kHtd1Z9Jm3T3O2VMMEO9wTdDFExDQTnRqvH5QQ7jEsg4/ESPV5PsGHjBrh16UVrQ5AGw0RjgHVf4+PymVsPIVKe6Gxk35BXEdtgUH1mEBRBIl9e6xjx0+VUDtKBIwn1R5FNCIXwqIZC82IoQOv3LrHJ/WaN1qgsYOi68i0kfxez2e2LUZZIVrAwhUA5zjkhlrhAvAzG5YuMQNc3BzMHkD/kVip/E+huaFiXlOG5DcC39bgOw3yES2DmfaFNyBRE08eA7RNY9SDJsWh5JtWU5g6qq6hPOSVYLmC3zm
 n+4tBZ6T
 L0zEMYwHwjtzWw6xOJRQNPXoEqAzic3bC/z8DuE0QeLIuOCww1E7V2svzkJBvR718tY6C1lseSpXfCxrXnrPqf11REmfTGSx3PWVHUP8fRGZERMYIq2G8KVZ9Ehb14SAv5mRsXMFvg+tCEGSoj/MZ7CT74ZTmD/jV+4qj/RLvyTIYwyA33a3JlMRKpV22/GvgAgRupVgw75JJwW9myvoHcM9/A1elY1trF+C2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Please don't send vN+1 as a reply to vN.

> kho/in/sub_fdts exposes the raw contents of the sub-blobs described by
> the incoming KHO FDT.  KHO does not own those pages: they belong to the
> producers' consumers and have independent lifetimes.  LUO, for example,
> restores and frees its state in early_initcall, before kho_init()
> (fs_initcall) creates the debugfs view, so the blobs point at pages that
> are already back in the buddy allocator.  Reading them triggers a KASAN
> use-after-free in _copy_to_user().
> 
> The same information is already available to user space from in/fdt,
> which KHO does own and which stays reserved.  Drop the directory rather
> than adding another interface to describe it, keeping the -rc fix small.
> 
> Patch 1 removes the interface, patch 2 drops its documentation.

Patch 2 is only four lines of documentation for the interface patch 1
removes. It could be folded into patch 1 so that a stable backport
removes the documentation together with the code.

-- 
Sincerely yours,
Mike.


