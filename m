Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3FBACCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 09:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE8A48E000B; Wed, 22 Oct 2025 05:10:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1048E0002; Wed, 22 Oct 2025 05:10:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC228E000B; Wed, 22 Oct 2025 05:10:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8A918E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:10:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 775D2140745
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:10:03 +0000 (UTC)
X-FDA: 84025178286.14.A9425AD
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id 44DE94000B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:10:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761124201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DTRZ02DIwI4TdgxwUadA9Ru9nAJnmTmLeHXz5DzmXmY=;
	b=1UFXyMIPlgrNhw8lvjEuglcAkC90jcF0ejI4G2Sb+VKyEs4iWKtIwwMN4nLhUPi0QXx+EE
	M27fCeWC3DVrwOBg056VSakHKIfXUHBMobfDGaHyXrVHi8eLsNwgb+JJBTw7jm4Q+BsmVu
	/sJXdqddd9lqy3fwGCHrf7p+AySJPpQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761124201; a=rsa-sha256;
	cv=none;
	b=4KFpK7TcIwCGzPstGeNyI7ExQO1KfjLnqEjg2MBInrH47FcE1NsnrRIuG+HiOUsxJXW5DB
	kYLriOGeG0r/bsJKRJ3mUj2Ah03WjINQx9RhuaEuFOBEmY/HkVQ5QG0Z6ZLkdDGY5nUpWd
	7sm6/CV2yHttHxfdrMsU7tEcBcqJ6Dw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cs3HP4d4Dz6K6HJ;
	Wed, 22 Oct 2025 17:08:33 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 84AB21400C8;
	Wed, 22 Oct 2025 17:09:57 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 22 Oct
 2025 10:09:56 +0100
Date: Wed, 22 Oct 2025 10:09:50 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>, <hannes@cmpxchg.org>
CC: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, Wei Xu
	<weixugc@google.com>, David Rientjes <rientjes@google.com>, Matthew Wilcox
	<willy@infradead.org>, Bharata B Rao <bharata@amd.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<sj@kernel.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>, <yiannis@zptcorp.com>, Adam
 Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <20251022100950.00002785@huawei.com>
In-Reply-To: <aPfXloRQgplusnce@gourry-fedora-PF4VCD3F>
References: <aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
	<20250925182308.00001be4@huawei.com>
	<aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
	<aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F>
	<CAOi6=wTsY=EWt=yQ_7QJONsJpTM_3HKp0c42FKaJ8iJ2q8-n+w@mail.gmail.com>
	<aPJPnZ01Gzi533v4@gourry-fedora-PF4VCD3F>
	<20251017153613.00004940@huawei.com>
	<aPJZtQS4wJ1fkJq-@gourry-fedora-PF4VCD3F>
	<20251020150526.000078b6@huawei.com>
	<aPfWePBq8d3v979f@gourry-fedora-PF4VCD3F>
	<aPfXloRQgplusnce@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam05
X-Stat-Signature: fp8w6gmzxsgeyhy6gym3kokwhpq8kseg
X-Rspam-User: 
X-Rspamd-Queue-Id: 44DE94000B
X-HE-Tag: 1761124201-478919
X-HE-Meta: U2FsdGVkX1+RDuZnZ8KRHC8NPdrACAEPTR4pOqgIBEMX5cY83i3XL9hK5BEsd7BG0AUub0fsFo0TD4NcApj2JDDrbVcPEZDkHaBgmIWd7r9qN6yB0IMPNcN+83uTyzfz9FdXjiV9krK2Oz5JY++yDw8VxFw0ptx0vq6Axeh48MS/CNxrrtfbeHuBpJ+tHA9wSTr8GI1r6IuBMzQBKQXfe5D6ucJAjPs6ZcGDcIuoD6xRVQ73jgOZ5v/Duu/ofJeq/bkIHQfDOfmmkIKuLWq5jaBMYBxB36I+rXYPfuVi+dGSshwILkOdVagsyG7mYssEDEZdPw2gYp8mK3RrfQhiSDq541iJupe3f4L8EfGyBCVxKQ5Q1DHSS/y45hmecOPOooJTMZ8L8SbFWYP9m/QNVhh1EdigeSQ7El3J5TVKJdJB+AeX0EoM/E8mRfV2d/9BsXg84VEwKeKhbKeBUe8M92ak8CzUZRHCborgCQzsGN//JRdF9M8OT1Hr/jqOgqFoxwubnDRnxzeEI93yu5ko2ViAUEb2kKJoEYGW92PWlfdVfoElOnwlTqKsXauToV5Svu6A5E6EM3yTpaMGqaL3fBd67xkaktuUkoBJrYyjaVr3oEaj4CCrXNg2mHNLc3a+YAZbS/VjFvNhjRdDaJ7VEN32SZVRHEqtX8ub/PVaEvO46szyrIXnsajF+KK6JH8jxkVaebS8GJg9vY8lvRkKZRKA3GlfxO9tjmwrOu/pKcS2+8Hg8oI64gHCo33L/rXe1Kws9SSmhAwvaJxCanmdag74iq2ZG73c7PSdOVfsyO8udvkxMQKxU3bhYvKsqJtQ4aQHzvr7dq6v9NKzuNStqOhJ3dL2oOyifbwQ8GdzOIErrFl1n9KZkhbwLKSjOwogptRADE48OlkI2XL8zp6cyXgYgs7aGWf58gEcbGee/m7EHD+hHZB0BeoeppbvHUhWSKG9BKqeD6PtEBTkuBx
 54WtiXtw
 b27mqYisf2WSVLO+WD1uNq2INL2/0gCIJ6DYxOA+PZGrGXCKOLHLiL+U91kNaGE/UvXWMXFERSRJpRfqvrwUMc/gN2DTU9xkjTRRUfbs+8RyVXBJJyeFeoltBzxVQRiAhT8khM6N5csBCDAzQgpDa2zi5OQU4DAFLZe+lWH4d6OuqoN7hvRxk0zQwO67O8K2IGl0v1Ro7cPPJM9kZG9iMB/44l8mvSvvPhWn+0JyTwrIJIPS9ixZ+B1FXs35qhAw7n3qhDPHrF2vOk8VPrD2Cv3yasavFMvi3YfnqQd4c0bEOF3woD/fn0eyWj/hJ7v3NogXIEsb+SHTuVUIgHx7PYf8Nd1XyaDQ5lDnR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 14:57:26 -0400
Gregory Price <gourry@gourry.net> wrote:

> On Tue, Oct 21, 2025 at 02:52:40PM -0400, Gregory Price wrote:
> > I would prefer the former, since this is already what's done for
> > hostbridge interleave vs non-interleave setups, where the host may
> > expose multiple CFMW for the same devices depending on how the OS.  
> 
> bah, got distracted
> 
> "Depending on how the OS may choose to configure things at some unknown
> point in the future"

My gut feeling is the need to do dynamic NUMA nodes will not be driven
but this but more by large scale fabrics (if that ever happens)
and trade offs of host PA space vs QoS in the hardware.  Those
trade offs might put memory with very different performance
characteristics behind one window.

Maybe it'll become a thing that can be used for compression.
Otherwise compression from host hardware point of view might be
like the question of share or separate fixed memory windows for
persistent / volatile. Ideally they'd be separate but if Host PA space
is limited, someone might build a system where a single fixed memory
window is used to support both.

Possible virtualization of some of this stuff will make it more complex
again.  Any crazy mess can share a fake fixed memory window as the QoS is
all behind some page tables.

Meh. Let's suggest people burn host PA space for now.  If anyone hits
that limit they can solve it (crosses fingers it's not my lot :)

Jonathan


> 
> 
> ~Gregory


