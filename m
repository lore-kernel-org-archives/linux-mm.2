Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A071C98306
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 22:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D406B0005; Fri, 16 Jan 2026 17:34:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B0D6B0088; Fri, 16 Jan 2026 17:34:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CFB6B0089; Fri, 16 Jan 2026 17:34:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6286A6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:34:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E77261A0164
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:34:36 +0000 (UTC)
X-FDA: 84339282552.14.AEF5404
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 74C3918000A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:34:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NLUgKdV5;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768602875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lwkYngeioKbxDRwX4+wJC8A9juDqdXklK5QTVnHLsAE=;
	b=tLgEZn5StdaHK6XGv/fKqyXbwpNAMMe4tzS75u6qM5qpuvrBobrrkmn2DgnEW/lCFx5ytF
	AtuqK0jUID2HutewTVbSkubzJtuvIWNpAmEX2c9hAhffMfatdkBRuneo4JNBtLFJniAqDA
	nN72BH7KoJPCNeQ+bAr7INZqocK4FF8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NLUgKdV5;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768602875; a=rsa-sha256;
	cv=none;
	b=m0yz/apBdyTiHxSFa4LmyXNj8fT8MC+eHB1iuIoRROb2kVkD8MAot3ak0I2ih4JcmGvdHd
	Yqzx9ClGjS+MKN2Zf4MUgKvK5BRfXCimzFsyOw1wzGM0QkJaflZIR64e0VcZEdOjTIJgGy
	DVl5xMhJvP7d0PQJ7K4SS1//naHQ7Rc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9074D60169;
	Fri, 16 Jan 2026 22:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C71AC116C6;
	Fri, 16 Jan 2026 22:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768602874;
	bh=kVpnh95TVOJW8VAQPIPSr+AtflaSPXQdvwC6ha92XDY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NLUgKdV5rMmMraQ4VO7tdHdrJG5WmEsW2juttELKBYBSDejVV0hR/IQgTFpr6tYdn
	 f5JOdy9G2qNC3TIB3r9ZkeZQVi40l9CLIQGFYANM/qzbhKj84KDPLBY+TLopNEs9gP
	 AXuzcWaHlQVHSDIiihDEiNj6+9fQ5Vr/JnmhU0fs=
Date: Fri, 16 Jan 2026 14:34:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Francois Dugast <francois.dugast@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, Matthew
 Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>, Alistair Popple
 <apopple@nvidia.com>, adhavan Srinivasan <maddy@linux.ibm.com>, Nicholas
 Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Felix Kuehling
 <Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Balbir Singh
 <balbirs@nvidia.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-Id: <20260116143432.50b98d6dc965b94f3b915333@linux-foundation.org>
In-Reply-To: <20260116111325.1736137-2-francois.dugast@intel.com>
References: <20260116111325.1736137-1-francois.dugast@intel.com>
	<20260116111325.1736137-2-francois.dugast@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74C3918000A
X-Stat-Signature: ytbsz9qaae1bhmhjd8e55nxpgqaxeguu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768602875-725142
X-HE-Meta: U2FsdGVkX19GSqkAJ7tY2Um/+X6LLDZyH+AcDXU8PGk62bKGJzFD+5uCPgK5N9DoK3A2HIQndvwtQWEmQBXcDK6Gn8so20g7maTSiwDJDq4ZvYrWks6P3+i2sn2W+12yF4s/ZljFAxI53C3YmE8VXVtrwGf3tm29xL0RJYlWWJ8F+E6CqqiJAL4cIez1PFmFNKMCvbMLNPjdPkdImg+Rcy2DYNKyVaQ5k10VAH3SJXMtpeqjnXODglccFSxKXYmjFwSbaiVLRi4pLaPiRbxPNZlx159XZgyj/pHh+iGKdRu5rJO6Q1za3tKK5yD1+2ONHiLuZLWW7RVzT1RfgJkJbe3lWyGa5z6qFc/e6YJndyvna0pQwuX1RS1dKyD48obPb6iGAeFNFo/krvg/QpgeZY0Piu7BzVvUzhode4aaMAYWHuwMXtSqFkk0eJ7+FL/CtCOPoXMvE6ZPyFjFFVeFkBudreOW16R6BoFAx9jLLeWYQ8b0h2w/zJfr3QuV7DRxREVzTP4Walj+nkUibnOm+dCifDtwf9mS/zTcM/MVdOkkFDtoWRZfuPAaRJ9iV8GD7ppMFuqv6+BGydDYeVA2YY165h0B7uxw7yFG/qQgSztYonIYA5NMrR5mqrgw2xrEvsW9YddPe9ZEqJCtVAHmNivdY5Mr79XQkI/x9XEdjB0nVUyM0wnSU1M4/Lkvkh3vjmlu3RtGPZAvzsyeMQUUhho5FrNfQawi+4E2L4e7gipCuKqKRP9g6TcGQ9LhBTfBc45bujxbD86oMwi6PFIhOhfxctGF1aEzOnHdUGlFjPDNlsLtT+BaG2PJNQW5RxcxlZRUwuYGDx7Z65aRZ3ephESvrbp6qCJ0rrL8cSp2lcABqZCXxQ1Ze/I2OLz6C+XZjevb6rWi0bQazvH0Vx3+ebbGm4yfekFI9xy2OA6Ln+bZcSUvMTClNjE+214tvpM+jTUxKmaySSSVk99mLyc
 gBbI3Fmv
 hgVgl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 12:10:16 +0100 Francois Dugast <francois.dugast@intel.com> wrote:

> Reinitialize metadata for large zone device private folios in
> zone_device_page_init prior to creating a higher-order zone device
> private folio. This step is necessary when the folio’s order changes
> dynamically between zone_device_page_init calls to avoid building a
> corrupt folio. As part of the metadata reinitialization, the dev_pagemap
> must be passed in from the caller because the pgmap stored in the folio
> page may have been overwritten with a compound head.
> 
> Without this fix, individual pages could have invalid pgmap fields and
> flags (with PG_locked being notably problematic) due to prior different
> order allocations, which can, and will, result in kernel crashes.

Is it OK to leave 6.18.x without this fixed?

