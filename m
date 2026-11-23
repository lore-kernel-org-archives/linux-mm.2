Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB73606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D266B05B4; Mon, 23 Nov 2026 03:55:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BE326B05B5; Mon, 23 Nov 2026 03:55:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4446B05B6; Mon, 23 Nov 2026 03:55:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41D816B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:55:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD59AA0874
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:55:41 +0000 (UTC)
X-FDA: 85465775682.09.D2C6821
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by imf19.hostedemail.com (Postfix) with ESMTP id DCCAF1A0008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:55:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795424140;
	b=3kpqMclytPzGzgSaA82CeGsP1LUd4TxYRQCmTei8DIJEPaub+2CyxgE3mN+ZzWuSNTOkw7
	sqfmckap9J2YseYhw14UMWLjZAwTwGGM0T2SW3L4xtGdEeLYvjEC2L0gZvCh0DxBV+/dK3
	/45H7RP1zlIO/L9DRKUdVdsqr15/gME=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795424140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZ8iY72BDIX7Lb6nq1K3Ub9imyQBaBRIv4gacmQR40U=;
	b=JZsGAx2vlwgfi8yOWthvc1DznvnJRsDQiakl+MjYtE3nJdi4gctdQnZpr5WVNMw5p5uwmk
	SMBvBei30ZHHv2E02jjyni4ybLr8mh+0UeovXfJJvMSjxnFikBJ3haXD/QGw+tbF34vtdi
	Gh4htOHfZnBG/Nrqa2605Ol7pARudpk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
Received: from 8bytes.org (p549216fa.dip0.t-ipconnect.de [84.146.22.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 4B87F2436B3;
	Mon, 23 Nov 2026 09:55:38 +0100 (CET)
Date: Mon, 23 Nov 2026 09:55:37 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Peizhe Liu <peizheliu@utexas.edu>
Cc: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Kevin Tian <kevin.tian@intel.com>, Jean-Philippe Brucker <jpb@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, iommu@lists.linux.dev, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/sva: Charge IOPF allocations to the faulting mm's
 memcg
Message-ID: <awP_epk66QlZF7rj@8bytes.org>
References: <20261012200823.699316-1-peizheliu@utexas.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012200823.699316-1-peizheliu@utexas.edu>
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DCCAF1A0008
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: p6uiza3mnxk586wypdaxmnq6ooj8pc1c
X-HE-Tag: 1795424139-240630
X-HE-Meta: U2FsdGVkX18jnCeHItiZ9dmXMbrWUe754919d+H7j4yjzGgpBewK2KRFgiCNTnpI8zdV/+PxMXxXULOcY8dXTiH7IsjKLJBpu6nTaEXH+Qrhi2Osf7MdgjZxdoufHyOP+y+XgoBdfZB9ixyIk5++4KcROosgTB1skB1+2cA5f6ruvCJ1odGMSWzUIoSgCHW0lcsG36TIt6D9GGN3r19p4mXdT8/xtsEmb520U6mKV++Gx2rVN5SptH2IQqHzlA0vYTt/oW3ZdsWA3brBpMJ+MZ6VfNWSzomZBrlYc9xbH2EMdJ+N7X2ULuaF1RmA44kjCtnCKEGtsEg/7O5f9TvoUTcsNSEb44kQBCYmAbSwAWrv2m0ROm45mJsu81t78uybYgYLGa7Bp87MH2vkiDaFrI4HA1u/nQA36Uc9h+b4UA23aZ68HHD4FMQbve+CA8sqUyDtIxj6AU394cvUNFasTEejg00v8Z7ZZL6sXp1PnA8Ej+EllJjwSeeFpf9k2gb6Fm1MC17Ig2EkrBMMWbOch7NEbfQFgtIGcJnN0djCxMiyJ233W8iirWlMAM3V2FUZSpN3gube9mIYQgcKUDGDicHBSuKoCDzKOyveYTw2hi/Mi6z4lh6E6LI6aGQSiWB5H6W3wEIXv3uKG3tb2Q7qcZ/c/+4orRSIuhPNhrE5kKPD0+g/3nrn1w+hTdPvByyr4pu+8EEbakkiI9fhM/PAxtpTr5naFgS7WCUJf4IMTKunSWdx77JNhwzn41O8mL6FQfgKk+YJ8udjYELssTP4lrJ26CaEWxTDTfQO8WICOiqxf5wxO7a51fZmiYqipVSOa2bmvOVHZeWxN1IU2ypqacIfY4kRTIrBJZzC9vIeCsL9Cnc/1cUiPLplDDiX8xGTViQTGlZCOOdlkT8e8FQe2uOBPYhClaNnlpeRDISuuaFhC8F9I8m24tKOleYXfEEjFMVsvOSB7xyNHOlVtHM
 MHHfH0WG
 I7SARrrYczPfei8DcmtzF1U8n4HIQoMiiSWpcE2bOkCgbfHNPhiVLmQVd1/f2opnKI4FZ0zmOCzPHeUJTkj0NN0GnwWoK9Eyig/yTwaU0hFJRt5zxd/0f2kii1kx6x28NN5Uu94cSQYXGC5W2w8gngMFe4ZY6WpdB1gAH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 12, 2026 at 03:08:23PM -0500, Peizhe Liu wrote:
>  drivers/iommu/iommu-sva.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Applied, thanks.

