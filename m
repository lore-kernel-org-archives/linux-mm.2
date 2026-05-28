Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DA5CCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 19:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47E2E6B0088; Thu, 28 May 2026 15:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455936B008A; Thu, 28 May 2026 15:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393056B008C; Thu, 28 May 2026 15:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9516B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:36:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D42E41408AE
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:36:45 +0000 (UTC)
X-FDA: 84817835970.19.BE2C4F7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id EEA0210000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:36:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JRYMFMMU;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779997004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8F0pWvXpBQ9tDTtRSJ6URm6g4dHDcnjjGX6VQLGXPyU=;
	b=kRZzQdKtZfx1ojpxvfH2GGn5TC5tEBNsC0LLUUH1xU93a4h3agJrHY4NBx+MQmpG/lbEMv
	SJHCQcfpQkYyNRcOfar/3FziBeNxDO7gBbGIWmFDLYiyULtvP5+jnBVpMuEkAWm1VTPGzG
	4XvTIlq5h3gJiXDTVjcV1BKeVcqO2qc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JRYMFMMU;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779997004; a=rsa-sha256;
	cv=none;
	b=yzNG7rvgga/dtQpdPbBrSZ0w2mr4wrSp9T+Jkq2EClNyncKhBnoiemyA0vHw3uJVgPJQ3p
	l4hiDtXMdeuV/E1JVICpT79jROT/dJ04rqlY014cjr8YD3paMBV4ymArNUtsToehNUHv1E
	+DSzc/moirpaI1mFNEZ5eE64UIde+fU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8F0pWvXpBQ9tDTtRSJ6URm6g4dHDcnjjGX6VQLGXPyU=; b=JRYMFMMUmIt+Ltyl9sQbvX97s0
	VD5j57l9FIq6bZcWQ1EA8YYtzEb8jUOSu/8fH/b3sQlj1QaB0x44GaBPtu54kC9Av3dPePcxl3D4A
	43FDUmdVszYklFreqEVlN0De8B1nujQTrH5y2ar8ZqhIAvN2glKhvMyMprIAhMZARkir6P/qjsSzQ
	kaolzBR1PT40+KzPSjEVD/X9dbuyi+JafqY19ukDe1QGkC4hrzlV9jG3iwc5T+1dn+z853w+1JN+o
	/5pkqxjkyy7sTDODIoKT/ekB1z/gUnyq3u1QWM2ZulCTjl3jenUMU9GTVLV/xfn5shjyAsEQBBx4l
	iwYCMWxQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSgX0-00000004mIh-1Q3T;
	Thu, 28 May 2026 19:36:38 +0000
Date: Thu, 28 May 2026 20:36:38 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahiZRpE593n4blxn@casper.infradead.org>
References: <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahTzHyHBL8t0iNBR@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EEA0210000A
X-Stat-Signature: s8mos68cipf8xkm6ayouy4r7mi7ue5po
X-HE-Tag: 1779997003-384094
X-HE-Meta: U2FsdGVkX19H7tKiFrwvfDDEqL7XTDBNy0Cyefx365LEBAxrW9tPeUSUyTExv2trsmGZ8f/ZFqnaNou85gelFFU7fjcNPlC1GBjJNl6hiyRdMhrScVgRP75SOHn0YKSPQizgJNvykuWPSo+v7sG/aZ0GGaIWyj+i9YbGJm20FDDWd/0bc3jleK03o49QnGpJXkmQWPv7BdCrIgzws+KaNTmgGvyug1CdrWbuJ+LwSzInE+2pyGgLH2m5e43jOPmyGjZ3mXfUMI58HQa9uF36VN/JkpNf/DFLMikO33DcsFUmaUqmkzCma91p0SU5W0OKWzPeDLNhXZcu0PDu37+ocAe6BStQyhRq4tTdIpQdLPlyM9+ENSHEeZrerS8hyHc6rZTGsnwHpX07AvoNabefQYYz/IbSyCfu+9u92D1E7JJOSelzBmotZgaN2G/G2BKou5L7KwIqmkud7j7dMKh7+76diGTgJdYTXn/QvCNZv2JwVMyzde+NZMxljh2Z+p9KbqwWrv0jEyUWZ0326m09IlEd3oNfmzYUi+8zcqeAZvWRmoFCy+ziqtnWTgg6qlErrdFTvJTWo1M+2vRufjSWGZAftUyDVtJXrMYhUHsu9evk4Pnsv52Wk+cjvpHzQZY+bGB97Oqopd2qv0Q/kzOtfQ77iFiCJczlPo35nBPQNs+AVE2xcjqmF647OhwT/aQiooMY/h21tM0JLIvMPACvFtDQy8T0o+HpF79y2PELxYQXJfzR6H9PyquB1a22BGWSw6WkIh7CUe0m0VCEEw6KgyARcIM+LILq+4SAT2nzr1+Jpfd1eRayhNCwbBDjh26UeE2Cu1wLF7zMFd7XuE8l8rx3O20vbHv59Dj3xtYGUw+nWL/qdOtSpOEUhFC5RAjo351G0b+Rz7+JfdJy41wdCwK1FRhY3f56/1bZIdkyVO6cLDCxV2ps5XJYJ24vgl2Yp1WGFhkat+DwQMPNgN8
 YmnWPIWl
 M6TY/+HeAA1A9Mkf09eVkW4YB0Eoh5mC/16cR8nxWqKpmOxl02AeGVETAX8U6LUmEssUMTuPWX2EpdzJKo7p/FPzhVYqXecQK2zn4UsLFgDr1zjenPTP2bto5ecdPafkamfciVsWOGFVmTh+NbqcBq9ATvIi7SAlOzlTmEk4nBIyEe6dVA6rdDcxxRZ27ThG1aNWhnSOXarbAMuDe2KP7Enr3Czj00yrhPBP+jku0FLc/SO00LW4L/BNPvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 01:10:55AM +0000, Jaegeuk Kim wrote:
> Background
> ----------
> The primary use case is accelerating AI model loading, which demands
> exceptionally high sequential read speeds. In our benchmarks on embedded
> systems:
>  - Using high-order page allocations allows the system to saturate the
>    Universal Flash Storage (UFS) bandwidth, reaching 4 GB/s even at
>    medium-to-low CPU frequencies.
>  - In contrast, standard small folios cap performance at 2 GB/s.
> 
> The performance doubling stems directly from reducing CPU cycle overhead during
> memory allocation.

When you say "AI model loading", are you mmap()ing the file of weights,
or are you calling read() to load the file into anonymous memory?

This matters because for the first operation, you need to allocate folios
of PMD size in order to make best use of TLB entries.  For the second
operation, it's more important to iterate through the file quickly,
freeing folios behind you after you access them so they're available
for the next batch.

