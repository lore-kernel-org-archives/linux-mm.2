Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46251C5AD2C
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 05:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3D06B010C; Sun,  9 Aug 2026 01:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54F16B010D; Sun,  9 Aug 2026 01:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A316B010E; Sun,  9 Aug 2026 01:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5A276B010C
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 01:51:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FE39804C8
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 05:51:41 +0000 (UTC)
X-FDA: 85080659202.28.3BF0145
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9913820005
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 05:51:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixEmCWHm;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786254699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3FGOkCsyAkRq/PlWdyqKgGv29697plosgcUL2pIKfU=;
	b=XCRXVXRG7hJGeGVE/L2bAKEtb5RGNNPRrGHry5MBpDDLVrIruNgj4bbF1JlX9HzBnpqi00
	doEyciakMStMrnosGSF5o76b9a5uPQep0Ub6uFCDCHqr0O1dPc/UfmYbyV1NrfjOPWHAyz
	pXKpqaZXFoJLk5zxlJtSe90vqD4sZV8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786254699;
	b=beg8VbBdTUAQA7bI6lTuinOydL6rMd4fwFESA5jyH6FzwBcbphOaV3jdHqRVnpagtaBOyl
	M5eXE/+DQu9cKKmBz4UOO/yxenllAIlHmhDBjFGVQYEqr+ZsuBWv5dVEil6xt2oQtBOENB
	xpZTZ1VIQNgMESt356u5CqRgjH469rE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixEmCWHm;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 38A4E42A4C;
	Sun,  9 Aug 2026 05:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD7B1F000E9;
	Sun,  9 Aug 2026 05:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786254698;
	bh=T3FGOkCsyAkRq/PlWdyqKgGv29697plosgcUL2pIKfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ixEmCWHm7ue2f00kzDVoGx2sOV1FXDu+EXAaI2iOwLz+GBiH4XdAsliF60VuH08RA
	 jkOi0P473ENk5+CmpbrxxClJp4qkn2H4Nyb2FfdYB8v5l8CkaCzShWTOZSPZSQRzoV
	 QOjH/ievlWfMSifDniCKcMkYCY0sLwmwzFxfd5LmZ13luZgo46vjrYdrXDIOmD3nWC
	 83ntAy9WSZ2tld1oz2tTUcvfRBnAuIt1DaUTfisZTNnClBNMtKESdsqoBYifeflv8p
	 MP4u3PP5BkcolJtsL9gGsB4bkhZ+7fCEPtMOxmXLP9AMMdrkxNsL6NRMWevPj3Q6Q1
	 PAmFJQztTL81g==
Date: Sun, 9 Aug 2026 08:51:29 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH] drivers/base, mm: move arch_numa.c to mm/
Message-ID: <angVYX5owaXkZ3sG@kernel.org>
References: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
 <20260806154842.9faab19cdfb7cf09799d8f79@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806154842.9faab19cdfb7cf09799d8f79@linux-foundation.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9913820005
X-Stat-Signature: 8soq1orsqa56kaimfyec3dtsjeowhxyb
X-Rspam-User: 
X-HE-Tag: 1786254699-280884
X-HE-Meta: U2FsdGVkX19TSZI+1j5Hb01j0j4xNev7Y0ncEit90ZvhDQc9Is6NK955/LwFtuB1AV9mEFseW5TgWtw/TO7e8hrzc5rk7hHdtaoBPsFbSP2KXLRpFHDITpCKVE0eQaPwQrzt8SCUmka/FQaY9gIO42IW75ZLYapyzp60AmNgozq++pdCxonDxvzQVVL62VQXJ3cZZW+pK02v1B6Kn2DJzc9ncW7ph2k+niaGjnieic7A6BllD7zg6QRTUCwxnrEy7ZjuyrEAJJHqqIT5twmhc2DlSRIB6KvdaKEUtDvq4IXOUziHMPU/ZeJV+eEV1ND0uO9JovYPghTDRjnROOev1H4gdu53b+ILQFY8ZqOhWTpqRRiQFe4odgMBTjzbrQmdDIKLE3ANO/QOd5BYTfEe8FbYBhT1wEoKAAGMTIG3eG9esromGWDH50jJQaUwEul6WNWPO8BW4HDNh7pseIvoBJStC45zzMXJ9RLAp4r8xq0oUYAsKZSGJBqdzE7C/qJEZCu1GAq98zFpunqZXZ0g2KyokQ0v21VfLOwFyAzq/WCzTTUIfMR7HQ/B/9krDy/8ywQsCEFRihy0j991+jL7f3EaUak51J/eGtK2+XiochjOrCgbRMagqONUMEQSiWcmf00Q1q+mobp+0bTDlTAq2vtGibMzcQq/yzozC5pDXq6RksrKwgnmbxjKb9skqLmMB5X/DYp8GJ0BIudrSf6lsNfcezMXgN3TMsIwQkb3nUqkgszw8lK+QeWFny8ZEI17wEXE624QkgAgP9+waUtZSgjnPn6ga3P7G5Acba0cywjFA+gtOccK0XoQtbPDF8LSIeC8b8u569DrYAOZHQaccIcEUIaDCPU1mLDCgPporLju4KkSV8CCdC6u/Q+M1QndLUUZVNYyjSEWjppq2NPEM4AqKsTxSJoCwC/uIJLnM+BG6Sc6FcB5RfFCX35xziaWqtwnvCOvmxEYiMCy30p
 GyMkQFsl
 x9yN94PseucjMYcnMQ7WmLkMU9aKHmFB8rxQCrYUu1hP5+18ThhNAlDDYvY8lOsEz3lf/q5oLTKqA4r6cvQsMzocGOWrllOOm/8evHu6B1DDHTMBCQZet6AU1RAyYSOlOAsPriV1XSwaa8afrEVFmSvQ6c6FUvad0SCHJmb42xtO+f072O4WwGCcvD4OGDxXrQv49WNIfB2hkfuZah/UG0eftMo26GwJA/yBYApDRRQO8NgP/ILzGSDX30lHK9VP6kL8W6xB5yVvWemhVQ9EmuNFDBcIfNVB6ODibztywh4GV2zVEMq58LNbb+x13G4WaZAf1uQAdip5QjZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 03:48:42PM -0700, Andrew Morton wrote:
> On Thu, 06 Aug 2026 09:58:38 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> 
> > arch_numa.c implements boot time discovery and initialization of NUMA
> > topology on architectures that select GENERIC_ARCH_NUMA (currently arm64
> > and riscv).
> > 
> > Since this is step in the initialization of the memory management
> > subsystem, it's logical to have arch_numa.c in mm/ alongside numa.c,
> > numa_memblks.c and numa_emulation.c.
> > 
> > Move arch_numa.c to mm/ and add its F: entry to "MEMBLOCK AND MEMORY
> > MANAGEMENT INITIALIZATION" in MAINTAINERS.
> 
> Unclear what tree this is targeted at.  I grabbed it.
 
Heh, it's muscle memory to send such patches to you :)
Let's keep this in your tree, thanks!
 
> mm-stable does have this change:
> 
> --- linux-7.2-rc5/drivers/base/arch_numa.c	2026-07-27 04:44:55.000000000 -0700
> +++ 25/drivers/base/arch_numa.c	2026-08-06 15:47:59.019918702 -0700
> @@ -231,10 +231,6 @@ static int __init numa_init(int (*init_f
>  {
>  	int ret;
>  
> -	nodes_clear(numa_nodes_parsed);
> -	nodes_clear(node_possible_map);
> -	nodes_clear(node_online_map);
> -
>  	ret = numa_memblks_init(init_func, /* memblock_force_top_down */ false);
>  	if (ret < 0)
>  		goto out_free_distance;
> 
> 
> which is easily handled either way.

-- 
Sincerely yours,
Mike.

