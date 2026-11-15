Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F87606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 01:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=I7+2eveW
Received: by kanga.kvack.org (Postfix)
	id 5C8496B05B1; Sat, 14 Nov 2026 20:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5791C6B05B2; Sat, 14 Nov 2026 20:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4416F6B05B3; Sat, 14 Nov 2026 20:01:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD6C6B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:01:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5818D140497
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:01:32 +0000 (UTC)
X-FDA: 85435550424.29.846DFD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 89119A000D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:01:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I7+2eveW;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794704490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z++RwfSOpv1D+is69MtrAgce33j60bZ7b/lnmHz+62o=;
	b=mLyfWz5qMusqDOcYxoG15LMa5NC+slMNwOe0wJTg9M3NI2SCKlTCd1nm/OUlUufl8XAWw6
	lO5ByEKDvkEM5doDmjMWfB/8EhP45OKhGojDQUR25iRqO+0E7AnM0fqkVTV2BqkEGzf3r5
	1MSC2Geui7OpKuD0xC+P1FH3NA8dHIs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794704490;
	b=NP0/29F5wTrRDb26NinCJL/p46wgmxNCWBuiVB+FVV7jlp/eG9zI1lHdhqpQoHDv7H0Rmu
	9bEr+kg1pN42+sHPDUdACISudfiHPg8EtkbluEJ9vSIeJYZOvQO2sNrmdfSF8XqzwJljXX
	PejFeKP6q7HEMuoHWDF2huJqnRoBGcs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I7+2eveW;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB42C430B3;
	Sun, 15 Nov 2026 01:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4311F000C4;
	Sun, 15 Nov 2026 01:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794704488;
	bh=Z++RwfSOpv1D+is69MtrAgce33j60bZ7b/lnmHz+62o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=I7+2eveWTbz5QA7n3oa8l8UmABOwqAo93YJY58ad7Gq6lfHtbMMao8yrMvSF0oQFl
	 bs0og4THi0b6or62hMXyuP3E44tyHUBRRSFtJmeJ9sRzGhlw+zKU2cPo/7r2WKpkkb
	 ais8kbBlQ7TTTwDgzm1xVCf3jK/9uNsoJydOuLGI=
Date: Sat, 14 Nov 2026 17:01:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, leon@kernel.org,
 david@kernel.org, kas@kernel.org, dave.hansen@linux.intel.com,
 bp@alien8.de, rppt@kernel.org, stable@vger.kernel.org,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
Message-Id: <20261114170127.3d29199864eb352d9045eaba@linux-foundation.org>
In-Reply-To: <20261115000005.GG3706007@nvidia.com>
References: <20261113195536.2660763-1-gourry@gourry.net>
	<20261113200303.GA395967@nvidia.com>
	<179460249376.482102.14669935557901467762.b4-reply@b4>
	<20261114002027.GE3706007@nvidia.com>
	<20261113181025.6e8b9475b29c13d29f59e02e@linux-foundation.org>
	<20261115000005.GG3706007@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1sf1njknuqjmx39ekcq9h8t584pc4hmk
X-Rspam-User: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89119A000D
X-HE-Tag: 1794704490-767384
X-HE-Meta: U2FsdGVkX19mz0WmHTZXgi126on5IOp5o0lD7L82GecJSYj5uF8bRkqOJ9QyTJ2rCfRXDwUobT1TFtafmXQMI1bPoVLv+utp+5V+cOXi7gfmVUx6qi9hrSadV46lKguCcStlKIOM+nqUVtXHWds7X3G2yTu1Ajrsn7SQiWQ4Jx9oC3BXyMCm7IeVX/gA9xyDC9ChpiQEh+4gBlP0GMIuZK1/wmDtOTgXhv+++4X4HwBFGGw9W85SbJ+SkwCnYl6mGdnN1XCQlyBf/MrHcGP7NQpoi0f2bYc5yem5Xf/9Pc/fg9p3KpXn7lKK7xOcgA+B5eKVWRaUwRGiD08uwxeaZj4oOmJc4jwtBetqDd99Q4r7ohiWS8X+r0CWBiU0Dhk8H2EzHbH++MLvkWJZzju1plXD/bN9KXo1gV3d81QQHW+x0plh7B5LnoqmXXSFCiNMypL7QsWhvqBc7sWlAVDruVb0swpIu2TOD+Rvef8J61whrV8pdnjMsoTBTKiqYKflnJ7PcVA1ziwvAi/erXsMnaLHLOkCeyV6yAlvPvkvLbQznCHw75hfVGbSIiQjBeriJvIjeY1A3Sj1wwgev9jpkBbDvARbaCaRXV4PHN397e0ilqRTs7+KUqnMqLk1DdnE3Rat3lO556kg7Yn+7xkxE+q9GMQotpGHCXHMWgr+PoP7Gl2cvkV0XAdF7m1zRRufNyK6Unt7tztE6aG3Pez4QuCzhznfshwD26rW+oZGZ4yHjKWTzunt7hrfDNKcK+elKhQmNXJeKttkCjVRPnqF2GOBHtFuGSdzQqRzphJTdcMUh7b1RTlwpwznLzGAyPVUG3Lz7hdggGiJCjWckDxJbdVe4uWCmIhaZLglZCENnIaOe960SJiJ/jr+XFiX5kpKA0hLgk6WQ7bD/h0cRwR23yrJLA+gH9QJkNCnUrgFgmvSF9zPhiF3jdy2pDBFbUGLKdY7jPpKthAKyianUyW
 uw4wUAnB
 l5RWekEbOSK+uggKkspIMlHqQjVJkUQbL2oOdAa/Qcld2f/buAkfgpZJxdEuEwZOx0LMxMzC+cjdJ34W4RfCMv5phVXL3RV3F2kY+aFrXT+7lzKX7QNCPQ6Foi92XLCilHBWb/9K5wpsc07oMfIUWSq1AiQUvM0h/cmN2CM7sHRCKGA1F1m8qymKFLnUheUt3WJH3uvD3h09E3eyzRofUL/csP3lkjcDWgYhmxOqpvYuWbdm+s8HZUVtvGo//VetsKlvjPb7hyV/ddFjj4zEESZRHKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 14 Nov 2026 20:00:05 -0400 Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Nov 13, 2026 at 06:10:25PM -0800, Andrew Morton wrote:
> 
> > How does this look for an altered changelog?
> > 
> > : On x86, a shadow-stack PTE has its ordinary write bit clear.  The CPU
> > : rejects ordinary stores to it, but pte_write() reports it writable because
> > : shadow-stack instructions can write it.  HMM consequently sets
> > : HMM_PFN_WRITE, which Nouveau turns into ordinary GPU write permission.  A
> > : process with GPU access can then overwrite its own shadow stack,
> > : potentially corrupting return addresses or bypassing that protection.
> > : 
> > : Reject shadow-stack VMAs in hmm_vma_walk_test(), including read access.  A
> > : requested fault returns -EFAULT; a snapshot records HMM_PFN_ERROR.
> 
> Yes, but it is not just nouveau, RDMA user can do this too and
> that is far more common..

Thanks.  This?

On x86, a shadow-stack PTE has its ordinary write bit clear.  The CPU
rejects ordinary stores, but pte_write() reports it writable because
shadow-stack instructions can write it.  HMM consequently sets
HMM_PFN_WRITE.  Nouveau uses that flag for GPU write permission, and
RDMA on-demand paging can use it to grant device write permission to a
registered memory region.  A device, or an RDMA peer with write access
to that region, can then overwrite the process's shadow stack,
potentially corrupting return addresses or bypassing that protection.

Reject shadow-stack VMAs in hmm_vma_walk_test(), including read access.
A requested fault returns -EFAULT; a snapshot records HMM_PFN_ERROR.


