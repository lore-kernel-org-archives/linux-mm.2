Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F65D3CC81
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 21:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480A56B0005; Wed, 14 Jan 2026 16:48:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451DF6B0089; Wed, 14 Jan 2026 16:48:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3555F6B008A; Wed, 14 Jan 2026 16:48:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 227AA6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:48:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD435136DF1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:48:29 +0000 (UTC)
X-FDA: 84331908738.18.8E49056
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0F69F1C0010
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:48:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=P6vtWoYC;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768427308; a=rsa-sha256;
	cv=none;
	b=UX2LM8LBRzod933A9PJB1OEDCkYx4rMSG2WAFYcVwWJK2xm5hev/8YxZhCA6KK9G+MdD6D
	Wl714cC8oe8i5xEcUuQY1WbDHygHA05h0ZZIgRX08pSHNWyXZAMubmVT+Zba35jV+1aOEw
	fALdfaZ0+zr6uwRgDmPbvdu304odcPU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=P6vtWoYC;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768427308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vs+/0N8xgH8/A9zak6RnbC/vymouvc1DzX8sAGTp+9k=;
	b=ZPR1nFZAA1bXMbnOQ1LEDSXxsaS8LIYrRSwmxI4HUEyCCYLIBauSkzSINukf0InJrUzzCQ
	A2BvwfA8/fyC8EKO7o9qcpYmAgtjcYHWB91RteAug1VTPELF9/rpfotc8AMDHRiG4HrpPu
	497XXW7vosX6woUOmKtmpH+R2CHqsJQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 105006001D;
	Wed, 14 Jan 2026 21:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94455C4CEF7;
	Wed, 14 Jan 2026 21:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768427306;
	bh=sVjE+SfQsdIUMHLLdK2WZZMe9meeOIqp+vLdzF39rao=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=P6vtWoYCIlr2XYuGHN8Ct1JWv57QVflPPPZ09aqbdSf6sWvv6Psm4BbFl9dEKxvME
	 9IiuEcpRE83qTyXp72NniYCaihdkRtUtnm5MV6es8ZMUNP2zri1F+QO+WeYttAzUaW
	 ul+FCK9Uuub6AWdHHLL0xvAdQEb3R2ZlrFvcN/18=
Date: Wed, 14 Jan 2026 13:48:25 -0800
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
Subject: Re: [PATCH v5 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-Id: <20260114134825.8bf1cb3e897c8e41c73dc8ae@linux-foundation.org>
In-Reply-To: <20260114192111.1267147-2-francois.dugast@intel.com>
References: <20260114192111.1267147-1-francois.dugast@intel.com>
	<20260114192111.1267147-2-francois.dugast@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F69F1C0010
X-Rspamd-Server: rspam06
X-Stat-Signature: xpqsba8x3y7gkazr6o5kqxra1pq7rkkn
X-Rspam-User: 
X-HE-Tag: 1768427307-148018
X-HE-Meta: U2FsdGVkX1/tAGx34XHemuS8wfq4iHbcG+ERzuYAkdSBwbAZ1vNEXmPsUtF1yyc5gVIFphrJSnZIJaRqJn6yPkqvppMIPvLs0n0Dh0uNRMtsMoknuJXIeETfj/3Hb/nZnzFwsIekgS+R2s4OpgK4dOLoHiwVdwFJfdiEok3LhFTtIzYYz8u5E0B+2NHlQmBvF0g3lBtRE+/ZtvYTpG+M9NRZmLRHPaY+4OW5bA43QvneoriLwrDC5SOvEhbtkpXVk7e3zO+doP5QTbuVjpmeePGBmuqjMBkE8s4c20fyxiVeHnm6DYHfyF3+wHDKVKBSFKL6w1BnmJ+cU0JE/R8uIrOfRjTNW2X376ruXEjUiv1rIQg6rnNhq7WTreg31OaKcCz8keCxqmDpt5O4aPfLa3dygB5sAjgt65wSS3CzZUFGyV77LTYZE9l6y8cEySoQJb8k0EVwCgrKOM7oTtGDTmu2GyDcbVIKMHYUsaHig9CT/TlohYnd1VH3w1KPxAPTu4N+PnEnY1oiThG2QrxhWss8M+5ewafFUACCP6P7FuIImzNyvohfruiALUvRsD5ytwVRXr4FuF100iN1rhfKXgwAHHf7hosEtmGko3sGClspjEy7mXCoDflpxTnk3InxbWvWhMpNUp4G16JtW8k1f3lIv+2TtcQoxJp3avcpBsDNbEcWGOQiYH1igsfkeocS4U3uuxpMmxYJHxQPksg7WBX48S1fGyAdfGILVsUL+VJS+Bavx0WRN/+q1pLjKG25QzaEvkLKafVCOwck6PuhLXoGGyKML6jzw198GFrATzbsmrB/STzMvCfEqzeVe1FJ10CCIyWiwW1uYMCFNqK04QEkwpuE+Mph3wKewWgr1Mm/ka5RvnTbjG0K+tDWBNh4bfaTD6Rxqc4LKIiiqJnWX3vmLY0ibojoYeYsNeYUp9OLy/j4WeCUp3yHqHRERWaCzGqskNFkS1hDMkEL4DC
 +CRZ/m5C
 BCME76XoXDOVqVhO6flk3Z8tZ/q+SWxgJxpJMBVtT3jTcesPXV3JeQ0j9okqIJg/kvrPc9VBhovG2ZN/FX8SkSYt/5F+14+r+wPxOWa8YWenEgHJc9a+7tZzOI8kOOWZj6bvG1cuCPuOKd5kRp6wPzWOO3bn5Gm54A8vqIZkehXISrrJO0JXCv+n4v5oZjdp5OzzV0i76nZR1RuEo81J9+PSBxm67megWF11xv5blC7G0bTqU18zsqjd2wxBWBTTZ0lF+KFjMNh++brCzo+gALMudI7XZytz6cjYRW3G8N2WEUDYL+2xhziPLSHC/bohttbUj7+5NDfXTRDNAIBRb93360W0+ae70Urc+TrFZqp54eXPLuZbAM/skAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 20:19:52 +0100 Francois Dugast <francois.dugast@intel.com> wrote:

> Reinitialize metadata for large zone device private folios in
> zone_device_page_init prior to creating a higher-order zone device
> private folio. This step is necessary when the folio’s order changes
> dynamically between zone_device_page_init calls to avoid building a
> corrupt folio. As part of the metadata reinitialization, the dev_pagemap
> must be passed in from the caller because the pgmap stored in the folio
> page may have been overwritten with a compound head.

Thanks.  What are the worst-case userspace-visible effects of the bug?

