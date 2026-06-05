Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08974CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 10:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FED96B0088; Fri,  5 Jun 2026 06:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AFE96B008A; Fri,  5 Jun 2026 06:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5DB6B008C; Fri,  5 Jun 2026 06:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2786B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 06:58:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C60C21405E2
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:58:38 +0000 (UTC)
X-FDA: 84845560716.02.2847C2F
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8546620003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 10:58:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b="YLGabnD/";
	spf=pass (imf13.hostedemail.com: domain of "prvs=609c00c84=dipiets@amazon.it" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=609c00c84=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780657116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQWB1MRHO0Oh1cerb+7kF6+zS8TJPeY9gp4o8uPVemk=;
	b=nM15iauEobBnUEPT7dUW+mHNMaUclPNzNShWFHlGDkuFh5FUFEA5uAC01BOPv0lNc0CHQw
	zTIFOqn0OccGrCB+Q8wdntsHLE7dwlvCajp/m16F07AuZwp01AN9oW9wEr931AUfEI28+Y
	F2cKlybaYI7Spc5t5WnZHwXTQyp6jVY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780657116;
	b=SzFEOKyVHAxUFNtCsXn2UwQj85yCLFbvuJIJFpdJ+NhT+1rGCrhFkt7JO6IHMVboCESxZw
	q7ia3B3yUtbCBe66D/pjckhggw7+Kg6o4oIGTvHyzeW/wSIEScZCrsx8k83NBMFzI7rVAz
	xO2yKiPUbHZAqobfvdMODwXXD9QfI1g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b="YLGabnD/";
	spf=pass (imf13.hostedemail.com: domain of "prvs=609c00c84=dipiets@amazon.it" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=609c00c84=dipiets@amazon.it";
	dmarc=pass (policy=quarantine) header.from=amazon.it
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1780657116; x=1812193116;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LQWB1MRHO0Oh1cerb+7kF6+zS8TJPeY9gp4o8uPVemk=;
  b=YLGabnD/qeyc1pCaRbNzb5j8umcm34WHSG32EUUTKXILByjco/lAljwc
   rj+zXtriMQHTlZ4lb3tMUr7/IEZwBUzEGgeyHwEyAF8ISQqTrTqnMDUxq
   W9C+LBvnu3YpNmVXro8szj91JMU4SW/jC4hfYh1ejvNid6iEfD7vFdXrM
   cfrUSFYKTOgbCr1zs8jlgie6bu2iL50/jnURsWpnEjif5f2U2DScv88vI
   qyr9t9XbKmdma5IbGcnorMV6er4YMwHDcv/ucv/tGTwgULpHJcf6l2uop
   DunVY2Uyuxq1sdP6kw+PE0dNIwwVA3uiGpp+wP0iGOeskIPJRZYIqvK0D
   w==;
X-CSE-ConnectionGUID: otzO6A7JQ9m3VqZ7jJM4YA==
X-CSE-MsgGUID: YbolRiWaRlWuZk/E8m1fAw==
X-IronPort-AV: E=Sophos;i="6.24,188,1774310400"; 
   d="scan'208";a="21175211"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2026 10:58:31 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:23098]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.63.253:2525] with esmtp (Farcaster)
 id 78f04fa3-8d95-440e-8f7c-1128dfcf6f2a; Fri, 5 Jun 2026 10:58:31 +0000 (UTC)
X-Farcaster-Flow-ID: 78f04fa3-8d95-440e-8f7c-1128dfcf6f2a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 5 Jun 2026 10:58:30 +0000
Received: from cdd-dev.amazon.com (172.22.139.101) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 5 Jun 2026 10:58:30 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <kmanaouil.dev@gmail.com>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dipietro.salvatore@gmail.com>,
	<dipiets@amazon.it>, <djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <ritesh.list@gmail.com>,
	<stable@vger.kernel.org>, <vbabka@suse.com>, <willy@infradead.org>
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
Date: Fri, 5 Jun 2026 10:58:26 +0000
Message-ID: <20260605105826.3337-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531232929.mn6f76yrnc6e4cpf@wrangler>
References: <20260531232929.mn6f76yrnc6e4cpf@wrangler>
MIME-Version: 1.0
X-Originating-IP: [172.22.139.101]
X-ClientProxiedBy: EX19D043UWA004.ant.amazon.com (10.13.139.41) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8546620003
X-Rspam-User: 
X-Stat-Signature: jsxfn9gyyxi355p6i1475d9rt9dczjgg
X-Rspamd-Server: rspam08
X-HE-Tag: 1780657116-524194
X-HE-Meta: U2FsdGVkX1/a7sYJiwbm9rvUd4ciLKCUaKu+6PAliZvSrerNQ9OKaKb7AyHa4jYSXSCsxWJKPX22qXdQUs8xAYdxhGg0ul15x/NRUj2nJHqwymRsYz+RSkaOFpM/gG+8WrhvPkaN22b2WGU1/A5awQ5tA0OuIOHZEbzgevqy4jS/OIcVHeyJLeqRC+Ygq5P+rCsenFD9Or1aMj0732agzbiH9mc3fxpuSHxEYL3ZT7uAltiCk5Ii0rVSbJvPORYA1xstWKwQi7ocKDVDKfdO2EPZx2c+LexbSveVzSQ2k8TBnVl0pVvxNmBpmLFkbEtJF3wk+iBkh2JqsqBfxWA/JuhqJXE9N2oWo3Cn7yxDU2sOLV8PDcJoDv3CMdhBsEEs1EqR8Q9IH7QSrA16SqWuuAT9dSSqCiymC8sdr3mrGKHxn2P72MVknVnhUj/wHnE9Epuq8evvT5SJWYrV8tVBMGpNAaKtiJHRv1n73Sr+vt3cmcrlcaqXgM0xua8WXH2vptWKMSLj1/tn8JJefNfVFu1AFiiKCA0a1B10KOTPQYN7WQvoN93fGoL6N+AaEiurqdYJSPsMsn/juNxcMzoR0biNUn9mrnV4//qLMOBKlfCT/yb+M28mqCL7TM4wlYON78+hj7Z2Tt1rjKbNTin0SM1dBtMAnjNg1CVk8/VYNAsSbdKcoXmPMrC5YnaKMMh0gF/EaRAuPgfdKH0xjm/k1J2GA791Xj+TaIR6XN/ijR1/obbdCuWEdVK6ln57tA3DwCPfJLqAaFBcMoCRePx4CPjiOeGKUeO7Y/CuDP+MwasgnVRWlnWRwy7PZzVzJBJyD5ImfvNFuM7HvteW2xkpI1v9tEAM2JLFLlTgqprdQM4wCnQOSlHcGvdM3raN37REMQGBF8r+IvC2x2B9vpvqC+L+HOWJ0aAWGUrloEGIg7AbD2KR/ocxd7vrO0EDQS4WrL14RhF0VW2GpXCNRpw
 UHFoBekN
 YZYTzSGdQRM8uJcTxUqrjkGklGKtsNaKSJBXBRTkNtZlWlU0L73aF4occ5UKRl7ex/9lDDA3MmZqEeasd+Z86WisJ4gUwprStAUinS3dfeN8h2tHwG99N+AudF18JbqQbQO4T1w40iSjchuNFDZHoE/s8x35fr1SmihBM44UmiRb7uIel+d+5So7/VxhYD0DXPLEh4r1KmnNNG1+IbhWI2yybgp80ef8u704rTW3MrmOAwEmGL/xtTCO6MqgnR9Dd6aWlIf/NQky+iUVIUKOy7iW6/St+NHE1jZ4o/SDSqAUEjj6NIrwJHp4Zp+91dabwxBtUVEM3n7opKxZDkiMa4CnStYMmBzoHW3GRuF+UvzHn/+vf5lSj+hHU+CRtnlaxWt9+3Cl5WfTfx9RvPOFoaBrHi9nz/4aE6rDtj271EK3EMeq5yWjeYLwaoxTPwqxwvm6GWWzBDec4TNk4Ul9VMVUbsnq2feP2o5eXabsQv4wpxNateEeaaJq49lWcDhr1n9aYVVQvL9bGMlcsqUy1/bjqpTfFtb7LqjmsL2Tm2Et5W7VnrfarlFBeIqRzSERCxOFMBamgXxR83MeSwbPP0EfrzEfIIarIl8rQS2Gcfl+RD4KdF4l2SO1x2EjHVHTstdnTTAOWSAGznp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, May 31, 2026 at 11:29:00PM +0000, Karim Manaouil wrote:
> I am not very familiar with THPs in the page cache, but for anonymous
> memory, we have /sys/kernel/mm/transparent_hugepages/defrag which
> decides what to do in the event of a THP allocation failure, whether to
> enter a synchronous compaction or wake up kcompactd.

Thanks Karim for the suggestions. To clarify, THPs are not used and do not 
have any performance change on this workload as reported in [1]. 
The failing allocations are for high order file-backed folios in the 
iomap buffered write path.

> I am just trying to think loudly here and address the root cause. The
> real problem here is fragmentation due to unmovable pages, probably in
> your case the page tables. We should work more on reducing pageblock
> type mixing. Also page tables can actually be made movable so that
> compaction can treat them as movable pages.

I agree that making PTEs movable could potentially resolve the
fragmentation at its root, since page table pages are indeed the primary
source of unmovable fragmentation in this workload. However, making page 
tables movable has much broader implications.


[1] https://lore.kernel.org/all/20260428150240.3009-1-dipiets@amazon.it/

--
Salvatore





AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




