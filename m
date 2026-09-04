Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A23C79F83
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 12:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3B46B0088; Fri,  4 Sep 2026 08:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784386B008A; Fri,  4 Sep 2026 08:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675616B008C; Fri,  4 Sep 2026 08:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4602A6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:08:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6DD0C114F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:08:50 +0000 (UTC)
X-FDA: 85175958420.19.ADACEBE
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7DCD0180003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:08:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=oBrjj3Ho;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf24.hostedemail.com: domain of "prvs=700cc9d1e=dipiets@amazon.it" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=700cc9d1e=dipiets@amazon.it"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788523728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yeQfZRe37uTQFMCzdgM6w8pnuJQjYBmF7q9HtXaNyyM=;
	b=OiTOewr44Av37Ps00BHGz5WdF5/m1YYPDGU1RZFAzmcS0AEGA9zstD9ssLTIzSedaZcUua
	7S5oCb9r8SgkWzIlB14u3STJVTLwhaSyXTIi6JrlS8kfot6UgOR4HKw71Wg+k127m3ClD3
	2t67SLkB+5h+wnz8pIgZNLj0w1K8nsA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.it header.s=amazoncorp2 header.b=oBrjj3Ho;
	dmarc=pass (policy=quarantine) header.from=amazon.it;
	spf=pass (imf24.hostedemail.com: domain of "prvs=700cc9d1e=dipiets@amazon.it" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=700cc9d1e=dipiets@amazon.it"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788523728;
	b=h9Gw/HmKe1tddc7LX6EYjvzRhkIbJ2ijGN8PBDHBVytBgUuNg+uEPnKvJF9QRTMtfR6DkA
	mLmQYYy3r/05TS5ISW3eGarB8pilxLGZ3wBdFCgf/DyeYFf5F6BJNpb79Ay8HwnC4goV9K
	qMmfJa37o6OiPT53coFOYtxdANl9h0E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1788523728; x=1820059728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yeQfZRe37uTQFMCzdgM6w8pnuJQjYBmF7q9HtXaNyyM=;
  b=oBrjj3Hoqv6iUcqEQA+FDdiACQn51TwG/R8m3hEpdUuX56LMVGZxJ786
   R6OKzfu7LmXN2MkD6W2oDs+Gpd1qFzRlhxNPm7y+ViFjLjH5PmSj8uh8A
   UiWe+7O5Iz95yfZ+PfJ7yzH9qukxNAC1xPy+MMPoR20ggG1N8ofwgO5A4
   3Mos95Upg8xG9XjwgbnXZRlSoTTrZaCYSO5C88bnoPctVsC7Pl/5A3Tzk
   bE2VZr/4sOPmGccVqBCFvZWC8Q+WIf429mXHeDWkU7pvZWcnULdvnyb1H
   b2J2ytqhv17g3ZBWOBfAqH/wof7LW0yDPokTNQ3DETrllqdU4RbfCY3iM
   Q==;
X-CSE-ConnectionGUID: d/CPTFUJSGSK9F4J3yp0GQ==
X-CSE-MsgGUID: aQlVFFEmSDOk9HvK8nEqgg==
X-IronPort-AV: E=Sophos;i="6.25,262,1779148800"; 
   d="scan'208";a="27848437"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 12:08:47 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:18188]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.14.124:2525] with esmtp (Farcaster)
 id e2747aa3-2a41-48cc-9cc9-c0602878100e; Fri, 4 Sep 2026 12:08:47 +0000 (UTC)
X-Farcaster-Flow-ID: e2747aa3-2a41-48cc-9cc9-c0602878100e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 4 Sep 2026 12:08:46 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Fri, 4 Sep 2026
 12:08:42 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <hch@infradead.org>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dgc@kernel.org>,
	<dipietro.salvatore@gmail.com>, <dipiets@amazon.it>, <djwong@kernel.org>,
	<hannes@cmpxchg.org>, <jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <willy@infradead.org>, <ziy@nvidia.com>
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Fri, 4 Sep 2026 12:08:28 +0000
Message-ID: <20260904120828.4022204-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <apf-wsCj_5QvAPcV@infradead.org>
References: <apf-wsCj_5QvAPcV@infradead.org>
MIME-Version: 1.0
X-Originating-IP: [10.253.66.177]
X-ClientProxiedBy: EX19D032UWA001.ant.amazon.com (10.13.139.62) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dh9im8y5owoskd58bxoriwd4y1w5amre
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7DCD0180003
X-Rspam-User: 
X-HE-Tag: 1788523728-822888
X-HE-Meta: U2FsdGVkX1/S1ZHlBiGGQU8xUITohbQc80Vp4GkU+ezvooG/S191RlJPg4il113v5cjZ1QfGO35YaP8lSQ/Gg3zisIPeVKHhHFXvOUmtTq6KQ+xhAapam0HiS7WGZVksZDCKnuqKqfvLT9Vvey7r14nZXx8w1TXJZTsFmepVF2fER+1+6XWVNYqy6WGujbok+IFdPbortnmr4RbgDRDAkPmTorF/uwicvfo0aIJSCFB8seLRlvIcbRcNh879r776ISX9ge2AfPe32B36DQrhG9BI2+UdoPeg9MUjJWVx4eCO3i84x0lvHt3lC8lo9bZC0+CXUUBVAtErBtO7Lf54X+FkcQPQqoGs8JCmlu3T6cF2VbsUI1UNvO/Ito40ajldPm83cOYqaBpeAo2Tgm+QWovnw+LQqzYTok95Zk7aSBFEVWJaNTTgbKaS76rYXtrET64MxlDVSUc8EsDgHuvgsNb4QbEGXVv7clmH57akbdeI/7T6ej3/RrwAe+p/tg+FtAgV1zEXkWMbrIjlTJ7wDLQp5VVZMh/eT5AryS1o7Yd3eWITapd2AjCyFrdLj6dinlWKDcOn+DE4EDR8oGSU97tiwlKX5vPyn4Gq/hbdtDn4Mvi/oPN76tXYhQdDD4YDWIen3n4eiWZY6+JH9oyM8JSm+TCoJ0e2xWDbgKHVZICXaqOOMdFdIvwXvvq+D6lxbGLOwHVupnyg3gTPnXJQRA+Ibo1iqU28hufqRvvJzHZ8htfVrMvGomEJ9o5QyYvPXwERyx4HTcy7g9OtNQLmmnk7KXNUGz7x4CMUyJp7vWnR1H4NiDiie3Kwhz/PusnT2mAcP4LAyGqSiDnZ7FKYDYiqowSUprjct17EbyooAimK9KlCncYcbcL0FeekL66z9hYUQ56g1vUPJPMeA1rbuUhOPZyimG+pUoUvGcK+nDebjh6G19Gv8ZCfC2m9R+MY/mL3CnpNRZQVkS2CEmf
 eOwCW2fo
 vo3QcEG1JxqL8q+2wKUoOS3gaURL6em5+p2Dm0VNSYsYTCeWgE+wIoI1c0O5gKmbHGkhxIOkKHsgri9Je88GCdVJmOfdJvc9n6i1UWz3yK0W31Z3qJGVLgOCMpPLVGJEMmu9rDgMZ0AkZxYay0/wmWCXMyMQgcxmum8mphhHca6dP+z6pWv8KEEEU0OQniJwTBKMt+Rwu59hp3hn6oj5ErS5Qd+jQ/NNG6sSfeDjJbxUuUcJ3MaS0mYg5yLDRFZnCPDaD1S5r4V4ZNcGDVluYEwJ1N8E3Of09OAUYPEx9fh66AxAq1Y7/5s2tSaESJcm4WpgKthN0ex205QQTy5KpaxkhUi8SmY4h13l9NDfTvWC+93iGLevXlvN1+gDJBKRiu9bUtmaquRsP0BCGYte7+Vy9A9kC92zbYZ/L1EO9WPQ88EIme+aUWvoBz4V7yI76STljSm1e8mTUg0buY2yRf1X4hu5DumwTlyzOPBHZZtT7k3+IW16vExgL/4YXduLKgJ5OQGzzQu4Bzg1uZavtMRyiSht+JtPXawbjvhOyw+DG6Z9nfxvYzUcbg32gbLkeNLETvIX6lCcW1UmpWamFp+jqyE1rM1x2qLWrktooCji48A0TQjvsHxN5mvDFDX+nYKOLS1LTF/QEjJxPyiEB9mmqE5qv6hbR5+qp3B7yqVcjkWbAK1fZhJamyTbqRlZ0LJrR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Christoph,

On Tue, Sep 02, 2026 at 10:47:00AM +0000, Christoph Hellwig wrote:
> This looks really nice. Can you turn this into a formal patch?

I've submitted it as a formal patch: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/

Salvatore



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico




