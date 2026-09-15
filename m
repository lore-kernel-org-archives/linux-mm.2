Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE897C88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 16:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921666B008C; Tue, 15 Sep 2026 12:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D39A6B0092; Tue, 15 Sep 2026 12:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C1B6B0093; Tue, 15 Sep 2026 12:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 524B26B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:02:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DAB3BC04B4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:02:14 +0000 (UTC)
X-FDA: 85216463388.09.EA50564
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 93DB8140017
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:02:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b="p/aBoMg2";
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf23.hostedemail.com: domain of "prvs=7114569a0=dipiets@amazon.it" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=7114569a0=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789488132;
	b=Su6yb2baWNOymPIU8Xao+dXnZ1z4OYXRKDEwdxJY1XL7LCZ6sdt42ryx/xmc6FH+QSKouN
	7U0t+0jtV3wsZCNJhxxlPiLbVjSkW2e+0G5B0bjfC44ZTELxJfqGGiymlHvmu3j617ZtsM
	MhTAc4wawwz/Mh2FnIV8/s2ZJbolq2w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b="p/aBoMg2";
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf23.hostedemail.com: domain of "prvs=7114569a0=dipiets@amazon.it" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=7114569a0=dipiets@amazon.it"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789488132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zH2AffRhpysneQJNXQPa9UtiFiIZCjOUG9PhR8vSPsI=;
	b=mG7luStAxVF322I56SuQP8qqVJjjauFZcUPMOSYHSj37WYd4ZcWgdCxfz8Bm1D+xm5P8tt
	Q0PiJ+q7nD2qjpu2NuEk4Qa7PcN0zE6Aan0+sMtVXIu1obuTDtvICfksqRwClA6SXUx08p
	MMvP4y+uwJw7w1GCE3L2+aqqr21swbU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1789488132; x=1821024132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zH2AffRhpysneQJNXQPa9UtiFiIZCjOUG9PhR8vSPsI=;
  b=p/aBoMg2NvXzVu/2njR1un3ma7x6p+qAmz1nEk0jJwcL3NqQ2L+RWb7G
   VEfSz/Elhh04xZeSmnnF+YfyHSmbwcbhOKDH/muj/xD+cjNeQkfZDYng2
   yP7BRZyISOKFKasCAbUxTn/IiJQV41rDwFCiZSnVO3C6W/+SigctTfNLe
   Rc2wRWJivLIbDuUGQSirtPGtSLFsen4S6WuShKxA9f9b59ZbVYxdRbsw5
   LXuWZDvr2gUr58CQB7TSjsxxo9n5vWkP8515PacffqsSn5GwbiUAaU2Ck
   zjtTZ28C/MqriTn5+gWLyVtEY+tHcJbnNkTaN0GIDoEJI9O7Gqru8V/uI
   g==;
X-CSE-ConnectionGUID: u92piRZrSFapAw+TyK//UQ==
X-CSE-MsgGUID: YKI+s6tzTVW5liA/y0xZ6g==
X-IronPort-AV: E=Sophos;i="6.27,103,1787011200"; 
   d="scan'208";a="28716152"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 16:02:08 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:27276]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.19.159:2525] with esmtp (Farcaster)
 id 15f7d0fc-d5b9-43a9-b411-4c5574972f7d; Tue, 15 Sep 2026 16:02:08 +0000 (UTC)
X-Farcaster-Flow-ID: 15f7d0fc-d5b9-43a9-b411-4c5574972f7d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Tue, 15 Sep 2026 16:02:08 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Tue, 15 Sep 2026
 16:02:03 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>
CC: <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<brauner@kernel.org>, <brendan.jackman@linux.dev>, <david@redhat.com>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hch@infradead.org>, <hch@lst.de>,
	<jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <vbabka@suse.cz>, <willy@infradead.org>,
	<ziy@nvidia.com>
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Tue, 15 Sep 2026 16:00:42 +0000
Message-ID: <20260915160042.1265958-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260911093209.d9181d5950778897935f6bcb@linux-foundation.org>
References: <20260911093209.d9181d5950778897935f6bcb@linux-foundation.org>
MIME-Version: 1.0
X-Originating-IP: [10.253.66.177]
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93DB8140017
X-Stat-Signature: aezk31cc6oekzktpmrnxhbp7eed3ihhu
X-HE-Tag: 1789488132-247659
X-HE-Meta: U2FsdGVkX19lFYSvKZLtMOZMyp/PFinKCxFdLJ/QdAMcRh9/bCmawP7kwrto13mrECFo+Zevu14URljohLeVI4pXuN1oVlW74zYMDlqyGRjSmSp4Y2kaG6wFnc87EPTi5LOtBWahNQO1gTyPnb9joAQxKWcD9BfwKumt7FxothxJRM3WGuaz/IqQRH/xlC9zgE1qeWY54lY46UNQImMQYYMghBMj07GUFW0JsK5sohrU4AmCh/4N2TrRPxmprm3PdqKvGqHbrPy8FJ4ZuiAPWfc6ey7+NTiNbOXDsFsuJzuIRDwtpPAN/KsriPmFpJkV1/c1vegnbTYImE+XMux25kDqO/KocwCkAP0Z8sACx8SdZ5GfMG6djMRZQEDpBmQJYylTJJ7HFSz+vbjL9vLs0cCQRIJqCsrjznzh5zWVsSLY9rAHUIRYpmX77Lfjpb9g97NII6Rzi/j557gVe0woce3SlkNO4YYZHHfhxMdWkKfywe1bAOBxbd/2lzNzVi6190wZShokbjPQRGFfeqV/1uvys7yaoEXuNPPfz7h3ANYF6H4+Ein1tU2cKLpZstspexEDFjrpNRMETCbMIPsOZJ0xJsy7fxVCZ4cQNFEP5rro+1sM8qdhX/t+TC56epGbBpYseTKCJLqio+n5Zm9o/cLbDsSx7XgWBpn2hAOiosRjrEgYa0VQFHRNRPc98t0mUTbxrczvadwlKzoafwAiS4uCCM8YbUXU9uoXhE4VMcK8+z4uVA9W4xB9v1VTVyUQJP6CPOMlRzYsmCPP0zqEhyuvfGpxr/BeU97jNlm3mWMkzUuV0fpd0EuJNSMG7HxFs5hxmQ+gTAdvlHiTdi83zpZa133VKpcb/QQk3HEAiV2APMAthngtsi1WJjf/vyWS1njglD1ceXuY0z2wOVaqLmpI3T8w0CPc+ovs0m0kj7Ehomc4lq9cgNVv4bKTYysLkAWyPX3uLA0Z2wAr7ge
 BmgupKea
 OMmPGcbv9oeZMHeT/TRzyNKJqTINOeMwbpMYww+6WtYAItERP/pIMvaUE3IHtzZVHV66JBNlxt402IGXjOoNaixhxXrx+LVao09+bWIA59Guhi2pO/yn5CgnRqDWSaTX37zRN64tVPtSJ2oGk8E3ndDQQyD85x9/9iskoVUXoKr/hDMkpN1Pj6Z8zplJH+bHG/wSc3zoxDIZoPVC7FIDCzkpHNHr7pd3TqACqcEpil3DPDvJs35FyEWmbcasWPIhe3vRYruXVxIwV6PVezarz7iXgWYmJAqgmKfmZKJ/3kTqkNDDdVEf7yC09RX2xFaH07f/9pDZiGpGVc+rQ4Y976r4dM8wolS8lG2J1zZjneJYPv/guraDqDfXQYQ6FnlI7CPh1zsOMnkXNL7vA5pxCg8FHjupm7n2NcCB2wAZrss3Oza5WLp04sciAHzeb+0RiangS25+BjB9zWcxoMWKTPnbnOsEPIXGvdrIpwx3sacSsQRJFYHQc7Nnq7rmEbFlkqMVxAv0+rl2iuQ/Q3D7ETkz87ZoaK6GDzXflypgoAM6DxS33O5fCZyv9gDnaKh99if/f2nm9nxxlaKWGqNLs/YMd68c4RTrL8lA+oEtRJcDHYfhwNi1OtJjgsdPOzxvOO8xarSQ6vzXH0tZGA2IY9fRdrr3UNMWFerSUp9QNZRrHLIltN7PfNUfj8V5CDI4AC1XINgHUZ6mSwfWFlfZT97a/YIWemI5Zwepi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 11 Sep 2026 09:32:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> does any of this look real?

The mechanism seems real, but it only shows up with vm.defrag_mode=1,
which is off by default.

With defrag_mode=1, a costly __GFP_NORETRY allocation that used to fail
cleanly can now succeed by fragmenting another migratetype's pageblock,
which seems like the wrong trade for a caller whose premise is a cheap
lower-order fallback. Johannes, do we want to keep it strict?
If so, we could add a condition like below. It is equally
applicable to v4 and v5. Happy to send it separately or in v6.

	/*
	 * Reclaim/compaction cannot run, so defrag_mode's strategy
	 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
	 * fallbacks rather than failing the allocation outright.
	 * Not for costly __GFP_NORETRY: those have a cheap lower
	 * order fallback, so failing beats fragmenting.
	 */
	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
	    !(costly_order && (gfp_mask & __GFP_NORETRY)) &&
	    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
		alloc_flags &= ~ALLOC_NOFRAGMENT;
		goto retry;
	}


Salvatore





AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




