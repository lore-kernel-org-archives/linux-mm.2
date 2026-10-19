Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B1CCCF2E3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4906B0204; Mon, 19 Oct 2026 08:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C536B0206; Mon, 19 Oct 2026 08:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1E56B0207; Mon, 19 Oct 2026 08:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6E96B0204
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:26:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27FA7C04DD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:26:36 +0000 (UTC)
X-FDA: 85339299192.10.E57AA12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 87229120006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:26:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hvnqJTJB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792412794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/7+EnVMoMIVI4b0VgEnU66uR84qKC0H5b2MnCMSI6k=;
	b=ajjLW3ErDs8q3iFXE3uaKuMWd9jDF3F6GA2qEIHfHCmgmBYpVFu9o+KjoIBd9idR8COhl3
	emIy6vNFehr0VnzTgb7GGwO2GUSbHn7dRcWpfFUsV/8mSqPFuhvOk/tcb4s4UeWoWNCxF7
	on6BK8Ozp0Qpquer75pBgXV2fxO6jlI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792412794;
	b=xNFsIb/7TmT///Vbmvmz3NpZd5OoAOvw5r6rzrsPGSZ3MPADEunRSVh6gF9/2OjdEQqNdG
	OXNGvSmOfClk8Y2S4vfDPkWjj5A+F+Xrzso/zsDZBikXSbzxzlpLNaQVHpmZ0BnRWYrmYI
	BAosTsTqPBauEUSkLgo2YYrWzRbJAEU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hvnqJTJB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1827C60142;
	Mon, 19 Oct 2026 12:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527B31F000C4;
	Mon, 19 Oct 2026 12:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792412793;
	bh=C/7+EnVMoMIVI4b0VgEnU66uR84qKC0H5b2MnCMSI6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hvnqJTJB79RHbvYOE0cp/r6HDMuJVdOI36LCOVp9LWG0oqwVsZkaXvtNY18DmaiIJ
	 fWM4jnzwOszqLWi86U8liOQflKX3rYyVnHQbaQIyhRHPpk3l3MGV/gHrZ+rGUEUzOW
	 avKNdqSHGW9nu15tDLC97uA2WCY09rge+7ueGRY9Ey/o9SiCniR3bC2Lc3riNpwXQW
	 lap6Avp1Zr0ziuuXUIBm9/nOVBh3wUghopIYcQyxo5illpFpMYVFbT+p4oPZuisisw
	 fTBRDNWXXYfaeW724i6owIPOVzQ5RY3mhOnPy1lX5v4pdJHq6XktH2Q41MD9AcjKG1
	 I+MZUmxK7AQ2A==
Date: Mon, 19 Oct 2026 13:26:31 +0100
From: Harry Yoo <harry@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: add an entry for MEMORY MANAGEMENT - MEMORY
 MAP
Message-ID: <atYMWiyCWqTG3WEW@thinkstation>
References: <20261019-memmap-maint-v1-1-80850871d0cc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019-memmap-maint-v1-1-80850871d0cc@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87229120006
X-Stat-Signature: 9o9xxiyuok67u5xq8opj4bosq6p8csyz
X-Rspam-User: 
X-HE-Tag: 1792412794-121554
X-HE-Meta: U2FsdGVkX1+XUozh0N7Ab3ovWlrpA7PAsLuvXS6loWo7GGfOSrgtUgKpUPoG9Hj3BcWODENgOSQqsWccKPvDDfLNjGzi/MPUWLddM5ocLAkDlqEnynC6BfnUzOFiPT9Yh7Dr9ASs4SJxDg2UcOZ1vlJtX2fvRQzAxUtVk011ojAWPssTF5BUurpRZtDLMH49izbsNZzKaumdlsDyo14gKjf7NrpL77wbnoXnXQaoQ6NHXPIHV5tWPLeSNQlXaz5YC2539SQIOlt22dXGDuK4cxTJEI3QF/xliEKM2D6FKP8p6V0Yy27TrtIhxKS12hjIgYvymDVmY1nQ0MUIKxgltyJkJIumHstnzgJrHer3uP2IWCKe/lZ8RSsp+VSj2Dv13vNA5xnbU1VBPx2ss5vI7cZISHnI8ppFJt5ZGScFeB4ugdMQBDg9UEj6LirCokJzF5VJjX0x7d9KYb1V1b3HKVY4zkFrUZ9XgmhpB7nVwSBXm7uZHlHxBYaqQFA6HaVDNDIN4DlglK/ml0yEReD9QljAE05ESz51Ct0qqUSgTxpWLgD1klbVP+034KRouDvpqTtQj6i9/VM5P0h1C+MEJvTMR2qefbqFp3zfxk3NycYW4s88oXRkUE8edwfGRHVdJtpl/UA9/p+cCMpezW3b9LsY2h9yA9q0PYotGJAGC8BYj6Pbmj6JcLOsdxK/SmTIA33Rq0kPrAoJfboa/W0mwhaQTQnTfvE1PTTNUS5K4uz+gSTZI4eXEEKQQgvLMDrsTwUB70OD6GZLDULH+HHiM6RORlVcEYABxd0VC6U/FYrCvq+dp5mnQ3eIpS6ujXD/8XP9ZkEFKR6AR33XruALMz5VMh+KYYzlPvIs8YRZIcGKABnZkxy+hLmdeRC/dYB/HJLC07y+tbSWqc5Ax/4D0c9o9zx6+4zpxLhy13zgLahEmY8kJlgI47/Y8EUVXQS8zK+BlTnED+chju8M3XX
 lJQtbBJx
 jE87ZwBqxAPtKWxO+n4SPHifU51TJzrXnmY3SAN5/qlDjtimT48c3zAJmawTlNv0Web6A3/E86DK8RDeIwiqAucH7oNf/kKUGisYSGhJeTJqYj5E7P9Jtp3yOZDSNzDINK5ly34CBM+nn8mfL9O0hRDnN/LtbLvkMTeczAJsjVkkiEB2aRtux7r7WoJt+rs1/qSAYtvPzMiXmW2NHHO0/ixhTztGJn5RvztqfxPU/+GvBBVmgnZGISjqJVkHM4rnqU2FANsA44TxU14SokpIduDpq1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 02:34:26PM +0300, Mike Rapoport (Microsoft) wrote:
> Split out files related to SPARSE and SPARSE_VMEMMAP management from
> MEMORY MANAGEMENT - CORE into a dedicated entry.
> 
> Also include architecture specific sparsemem.h headers, pfn_to_page() and
> page_to_pfn() conversions and Documentation/mm/memory-model.rst.
> 
> Muchun, who did a lot of work cleaning up SPARSE_VMEMMAP and extending
> vmemmap optimization, volunteered to help with the maintenance.
> 
> David and I will continue to look after that part of the mm subsystem.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Acked-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

