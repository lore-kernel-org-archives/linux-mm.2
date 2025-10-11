Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96ECCCCD184
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 18:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF64D8E000E; Sat, 11 Oct 2025 14:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA6F68E0002; Sat, 11 Oct 2025 14:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBCE18E000E; Sat, 11 Oct 2025 14:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB64F8E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 14:44:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BD2D1606CD
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:44:30 +0000 (UTC)
X-FDA: 83986709100.01.F51BB04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8DADC0003
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:44:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zFYmH1VC;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760208268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyKmG2NMZIp8tNU47MlQsA0tLkXuXLPU3556mToeZ6o=;
	b=hSDos5Q0umQUkSdZYCjRB/CyPzNn7bcvDoyx5HE/Hdv9F0JuT+Ztp1R4JSP17ab+7A9rJK
	vJCs2fsB8r9nEg53ud6z6d6mmCEKT/bCdHDPYnG5/UWffJNuewi+AJZXoTjx++iJVzkkb2
	aw+esYwwpkmywIUGjevlvGG1dV7ARv4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zFYmH1VC;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760208268; a=rsa-sha256;
	cv=none;
	b=CQcmOHzsH0hHUzngfNv27yH/AwncR4RpLFOmBqT+9DhO7xhS/n9+XxeK6uf2rvJDvaFMV3
	Stqll0quS8VwmDZ435g1afhUaOF8chq3xOP5RrWsSuk+5GPA8aMDzvjGDPzb9K+YyHu9fI
	M/i8ItkhKSVJd8gHcxrM5Xf7M4Sr9hk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B54E4191E;
	Sat, 11 Oct 2025 18:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23738C4CEF4;
	Sat, 11 Oct 2025 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760208267;
	bh=1p8xeKkByaFAhzoZotQIc5TBKhsxRGdNh53mRIgRCcY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zFYmH1VCQ/IBqhPNUa6SXH6vlSm9qm7zALTXxZycHwKXH8zMFEqqzNZsDPcJlBmIo
	 36bmMJbb6vw6mmTeR/OIryN3IU5jInqbZQWf9gEp3myog6tlv+X2nAu4zkPAVOgxCX
	 yqN2HWe7/17Of/QgMGb0aprUKGer7RSAQeurSMWA=
Date: Sat, 11 Oct 2025 11:44:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-s390
 <linux-s390@vger.kernel.org>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH v3 0/4] Support dynamic (de)configuration of memory
Message-Id: <20251011114426.5313b7cb6951618c20ab62ca@linux-foundation.org>
In-Reply-To: <20251010085147.2175918-1-sumanthk@linux.ibm.com>
References: <20251010085147.2175918-1-sumanthk@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nh3siqtcxcgm1axhkccp1bosxkro4y1a
X-Rspamd-Queue-Id: B8DADC0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760208268-285903
X-HE-Meta: U2FsdGVkX18miHuZxWF3U4pfTTjjhIzpmnY+MQLRWPFddpvFFMTRGbmVrbTH25fGrkMMed2lpbzHkFJactYn+PJ8w6SfgIoM5L4Zp8Rpdv+Iz8elSKMis+9DGfbMbWVjeMGcVGJPu6QgXKttC3fjNGeng/uoullRGALzo3J9xHDIZmP+/Ss//PXZTATfNpIcOIRp+OE3yB0/L6gDQfifHcTq7aedf+L/vnll9w3sbcw/rZetDV6aaJISiZvvp3TOyCdM16kRPBYhhGf0BIduhn0wB6xWZfVwXIdbJTo4aVh2HT6MJjuPNzOWB0/HDET2IKU6KyWX61Cd2v8sXaavc2g/wBg0EJZ7gcDdc8QfHEJz6adsF8euBRcIvnJmVZcnWRM0BDSa/ys1YGgrkIKH3I5UJRf3VMP/AaYDamHQ4yN6XXcsEaP9b0fbD2y5cazYaEUDCw0c5EOBvib+UwRCasYnsvFA2+9eFol8MR2RWRCvafLNGgsb0RO4BHzAAo0oTxlNjoKgk4uiEyifbq4aiA80joXBc+ABA5MbkIWyudE0FmWsPOc4+Zwo6e6rksYkitS3pp6zCJdmFJyGroUmbVdpgoPujcWAW67U0MEOwVRO1bfIA+ZNjaQFsg80A3wp6GKRzs3Jd/Nu6+rpr1Pj4656bhmb7y5ZHHM38EZY2jB2vsBg2xQzQ+ZIO8krZcmHUjuOKmttc13O5zVoYkqSrHx/lnkSqUq9Ds3NmXNRzeLghxFGVZMF2vdEm3NlOT8yrnwgJAjTVykSznchvAVIJe3IdFd2Qlz2OtbgP3W/jv/vehVbyWHuYByUKR9SEE9Vl8hsYg5/1GZjIqNu8LKcEVdoQvXHGMrrNG2YxsKh9rrSAhP5YOknlcHNLzneloMOleWidT88K2ErlnUx5IKgGCpWLk7nuEBSa47Dzfh1kaupmK0eE5CcOYX35GDNqVOMwkTNZLjQOm1FMjcQjJZ
 Eq7BPZxP
 /M9R6tloSSFIbfNatrWHwEzGvZxZUYWrw+TZkkoV4lZIzS4S8d8dgr+Qn+OBEJdvRU2r1Npy/BVk3Sd+X3LTrTITAWP+/JATZRW9IC8vzCnr7XtRS2xWrERDM2sSr5Von8oVAaosjO8wUWVFuVIZug8OTiW3Vko8rbBENYV9DEXFRj/BZoL9CYsd21YHzb6hVjbk4XGjEtGSd3/juP4te98QmCjq5hT75l6ylYvuuDsLgjRU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Oct 2025 10:51:43 +0200 Sumanth Korikkar <sumanthk@linux.ibm.com> wrote:

> Hi,
> 
> Patchset provides a new interface for dynamic configuration and
> deconfiguration of hotplug memory on s390, allowing with/without
> memmap_on_memory support. It is a follow up on the discussion with David
> when introducing memmap_on_memory support for s390 and support dynamic
> (de)configuration of memory:
> 
> ...
>
>  arch/s390/mm/pgalloc.c         |   2 +
>  arch/s390/mm/vmem.c            |  21 +--
>  drivers/base/memory.c          |  23 +--
>  drivers/s390/char/sclp_mem.c   | 288 +++++++++++++++++++++++----------
>  include/linux/memory.h         |   9 --
>  include/linux/memory_hotplug.h |  18 +--
>  include/linux/memremap.h       |   1 -
>  mm/memory_hotplug.c            |  17 +-
>  mm/sparse.c                    |   3 +-
>  9 files changed, 225 insertions(+), 157 deletions(-)

I can add this to mm.git in the usual fashion, but the s390 tree would
be a better place from a testing point of view?

