Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E497BFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 10:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365876B008A; Tue,  5 May 2026 06:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316B86B008C; Tue,  5 May 2026 06:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B216B0092; Tue,  5 May 2026 06:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 172226B008A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:47:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE39FC1CA2
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:47:51 +0000 (UTC)
X-FDA: 84733040742.02.0CD195A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2555E80002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 10:47:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mwTJ2AOq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777978070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lz4TiR55CeujsaSMEwx1UucYlqO7h8RCbFEn6Yetlzw=;
	b=BJy8yIVpJEL9kaNttwiJtAPmbgiQAKBnWyFvnPmvhEHgWFC/2FsHPSWQbNOfbFnbaeJtdr
	mpM1E9RQDA7V/wW6cHfsktbUiBjfH8CcABmVmwY5R5HmnBBUazZMM3JGVyyyFPoF2qDnbf
	aHdu18BiZARD4GPYoplx/EFG82okzZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777978070; a=rsa-sha256;
	cv=none;
	b=njHB/7J26Ffcyagg1UQbJa3U8HFhYlOY66hnAgySvuVqQAG/RETDhkeYERfgUIoEheSxR6
	peIcFFicvs3FbC085fc+xt9Jw06vaz7ibdlTh0VzyBKJVYqomVn7Z0sNoSfsA7BzYczbZC
	guZWgcnpMGQ9H1vgIva/amu/c/X/Bwc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mwTJ2AOq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DABA6012B;
	Tue,  5 May 2026 10:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1808C2BCB4;
	Tue,  5 May 2026 10:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777978069;
	bh=lz4TiR55CeujsaSMEwx1UucYlqO7h8RCbFEn6Yetlzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mwTJ2AOqD4IeS47XQgik6xcmIlQdEpT3gqa5Gny7RQGh6xlQba1AMot04Gp60fKoR
	 wVRcWwCODPAqBNaRxlItRmxptZhlHV0c7rT/zgsVKfKbFjnKDzPpHka+mPZq35khxh
	 PO/AOGhZOpQ3/uGqn2eksX5/wQryCIRfSUfaiQ4XE7jePdo3TFVgKTQe9WTNPZHx0L
	 Tw3lxWNtd15S6Grn5QwyDruh8S4PafzstZf5TMmlGYLqs0BLsi6cqcoFiCQbOzXZ3f
	 OSy0lYErb11yACsWgLKKx1Jt0DNZ5fQ7sWbIgakYU4pDHjJbHqt2TccoT9skGmoZQ1
	 Gnp32gqkjARgg==
Date: Tue, 5 May 2026 11:47:45 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, willy@infradead.org, 
	ziy@nvidia.com, david@kernel.org, lance.yang@linux.dev, 
	wangkefeng.wang@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "tmpfs: don't enable large folios if not
 supported"
Message-ID: <afnKpTo4cwh9LtPU@lucifer>
References: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
 <afnKLEIaUd5A22ls@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afnKLEIaUd5A22ls@lucifer>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2555E80002
X-Stat-Signature: 3sxsqqdsgq4cy4thtuaxqigbxo77zk7p
X-Rspam-User: 
X-HE-Tag: 1777978069-864111
X-HE-Meta: U2FsdGVkX18aL/MG8McGvHcTDy+sanJl4AYeLv8sBijQDPlJzQQ7GFg+t7lfkd5APg1QMm1S5k3UNdDZA1HC/BANGOHu4FA+v4lMs5x20QH2FcfVIhPkDN29zCDKkcOXCkdMSgR33/2NFg1eEFZPtlhlxfbZVsRyQGRIYPu3oezBjk+c2UrOz3UjEqDTkrlVN/wHdxu6/XDQRJzVJBXZf/sW9zkkBYiXtRgz9D9/RZERQxfCbusfv4GGak9Qtpz8YJp23PZmSDY8XM7wY1MWwTCNvuud7EGjj6kqeeRnGrNvve8cZB+uatOBlKEZPeoYU/7QhR1JQj5xdH740rCebVJEi9/l2Hroj2wYAxNxK02WBM7hp1j8ThZUDB/Apn84oXSZO2f5SlnmXKUBF0fQztc5EWIK4y7aCVcx6eYEmdmwamgQ6ruZ3nNKGz//x8V1CDYG0XWHIFW87J3eOrItbJTZUHXZUV1ezkcYRAXIbWdd9/v3OWDuxfwLj8pRLGblFxDdWKGUkM6bBYVsDlFPZ2FlljgWHyGk0DNiyxoHnB2/TfZlVgC57wqinJGAPeC6EmPlvhMPcsHBgNjMV0bs2JUukmhRp9191Yk0A5H+N0MdeAStYGXuI1u8/tLVHAZ6zqFOrtBWTkxZ0Mb4X6M7QG1/QlMTYX0VSrFWh0p345PG4o+Wk1BABaHhRd/PO0QsLz2ofGe65T43/pq9/+EqH2EkLD5zJbo13nDuIVQ63vwpFr+jatV98Knb1j4yTZdT6u9DShasZh16x2HqbWvWtGdS/bwh7gDlag6aMsC6AhQO6+f3d6+Pwk/osBwCBFVR8MXTFqEhnTkoGwI0jPAfBiyjkPTR8j/c0LeguKiM8oq0+Aah+ZdOVCLBmznn1wbAzS668GcjdiSzf91OPHkVkFmXVsHPEtEsaCAbSXT4WduNEJrV57ajTVc9J8DI6anvke1Okg/cmOIpwb2PHvW
 2eBZWHGG
 8WAtioO3NtWBZw2IRokyWZlPQlgvYFTszj7+r9omhFylCrUgqMmmnuNLranW+LV7vxbKEETDsk3IJhlQ58d0vKFmjs505q25RnvA3GiF6Ne6mRLRBl2R5x3s1j0wY5Xgwlt9bfKETuWFD8YTBqcykyDwDpzO+y/RSrVejNOnLG2SIZdkjWYwo1v3DEeN6+0P74dcBAowkbLcMyXxDeHDcD/Amkyy9KHaY3Fwc6XhlaHH5WYpPXfVyHd8dGMLtwsxLa198wftnLMkgS4sVKnztAnfU6QWcplnRTm32SI+ncbvm230=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 11:46:11AM +0100, Lorenzo Stoakes wrote:
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
>
> As David asked, should we have a Fixes tag? What about cc: stable?

Oh he mentioned link :P yes that too ;)

>
> Cheers, Lorenzo
>

