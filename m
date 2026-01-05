Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CDB5C2A07A
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 09:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85B56B011A; Mon,  5 Jan 2026 04:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5DC06B011B; Mon,  5 Jan 2026 04:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89FA6B011C; Mon,  5 Jan 2026 04:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B61C96B011A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:59:09 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6713E5CA42
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:59:09 +0000 (UTC)
X-FDA: 84297462018.17.3DBBD5F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id AFB0EA000A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:59:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767607147; a=rsa-sha256;
	cv=none;
	b=I+ZMGBEsMY7hfK2/JiP6JmtaInTKmudkKs6W8q3ctMjbYyUT0dxehEiQysmIOMACEeoNXB
	X0+eAVro3dyH/nvcrt+AmQO/lpdG62e4N6kTDUY+lfekAzaZQVpSBoOSoRs3GF23Lvug7P
	Nt+JlaHC/6OfUtgjxdz6qpFuGfgn5nw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767607147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u0jXSpEkg4bxoAUy48cRSQIRJYWNFdP0a5jL25USTiY=;
	b=0Xsbcb+pVKjrY9oaUv8KCBtlowxZu6OP1ow8dYiYEmFMcN/eEGKGbSRIhqQWe5D3W4By0t
	exGXKkXdDCwHWj0P2yVM3z+aZaxNX+e/yZF58zWINKT4P45rOccfSBc3zFPwKlVlpo/fzP
	g9Jg/2hbdOxJUmRuYa2v59kaIflYiSI=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dl8qv0L4MzJ46DM;
	Mon,  5 Jan 2026 17:58:03 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A06940569;
	Mon,  5 Jan 2026 17:59:03 +0800 (CST)
Received: from localhost (10.48.146.88) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 5 Jan
 2026 09:59:02 +0000
Date: Mon, 5 Jan 2026 09:59:00 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Mike Rapoport <rppt@kernel.org>
CC: Cui Chao <cuichao1753@phytium.com.cn>, Andrew Morton
	<akpm@linux-foundation.org>, <wangyinfeng@phytium.com.cn>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: numa_memblks: Identify the accurate NUMA ID of CFMW
Message-ID: <20260105095900.00005c09@huawei.com>
In-Reply-To: <aVuFv7P6og6pY2lj@kernel.org>
References: <20251230092750.856060-1-cuichao1753@phytium.com.cn>
	<aVPtSNKRnnI88Euk@kernel.org>
	<dac83ef4-6e4d-421b-bd54-7090d2f963d9@phytium.com.cn>
	<aVuFv7P6og6pY2lj@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.48.146.88]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AFB0EA000A
X-Stat-Signature: aewq1ap6cwhfz3opc5asytf6oc3yfke1
X-Rspam-User: 
X-HE-Tag: 1767607146-530989
X-HE-Meta: U2FsdGVkX1/pbg+tOTlz9v8XZpL0avoTSfUBHURGx+XMYB+NLGyGxoRbyjk+msB7bUZmLSCVh2TcO2ISYApLNxF9RZbKFZk1rvXv0YAIRMPgCW4mENyFCtyUdTMAygEx8pPR5q3ckcvtvl4TolrFz19M4V6d+/2pv9CENnLfOPPlPuYRixmeNdaehp93OZS/MaBWrdRm/9hYAUDOSj7jN7wK2XS3JBA4XeqLOIhIq80GE+W7Ehx+K0gdv+ke6Agis2gdiI8fxQ8A4dItiw7Dbn1PMW2ARW9IbOHfeWw6amymF4F/evlQXk84I+F20qhuRKWvV/VnDSfSbYGPY3oTA7PsfgiJJzfmFwO3jAYhFRivSU3fW8NUPZu4m6oyPc1GJj0hFaLOQQHilz1TCP2oJrYja3C+Kq9R0w/u7+bsCwY1rTvptH2cQYE5A0b7tjFtgjq5FNbQgUDoghuSuBZW5W6fUpQI+xt0u9+uOjrfa4lzEfCAdcNXl4ERxrP+FD8b/BQw4SXxsikF533TQC9F+jW2ajpsZG7b+ish1q95XAduz7DwJC99vHq69QfqruuSd+KWdfRDLt7MDNoSj9x9KBJukmsyTVE0HluOwrR7z1AhqHTtASBJopZaUa09/7JGwunfb7kTsV3g4pMPrxc2vRIwJ7quOsNnz7JEc34QZygqhgl3qzA2/pAr5ZM+WafLG6qrLL9DafVW/mal6LdIdTeEUiiGenb+rYsrpxetB4U3Afi45iTTDPfbP7n6Qzu79ARGRTQ6nvW+hIWvJsN76yt57uN4Wqiql0jzplRShESnfZk79MqKZpw4StfvErE5PZUxKUnDqqltxrFVQDRr8HNGGQTBiHj8f0ORHe/rHopKFxW7E2ZY88Cn7sUwRFMdzP8NbY5yRQ9EdddsHq3KlIGu6IYYI2sndEzgAnGsEs255vZB2vDuTOwaXYHWT7YvkCunfYxhXwDOg2gtr1B
 7VKVnQFl
 G9WgfaJmzcQ6qicYJuTVdMmPcvodV9AdHug5vz2neUMAI8sXd8MQKrWSCRaxpODan6/h5Np4RbOxEBbJm0omk1cckxBMW+UdpAfglDDbRB2uz6MrLp+6+yknG2hQ3e4F5L1G/e8yCjkoEXZW+jVq9OnVA/sTEBX/22eryZ/Be/TKATd/NTuu+xHqGhppA3LfDSS0mUZwXKP7A619j/eiL8vjmguwA7WsIR5cCG5nWUCNzIaJaeFXRA/YvbfTAwulPjCFmZbVcQgMJdVN2Bbgl/2BgFFPptpsUCHPjZCduXGc6Usxf89PT92NhOutEVFEgnEYtNKNBNqmy8tRQ3tTGT9BTRn9kh5lx/GK3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 5 Jan 2026 11:34:55 +0200
Mike Rapoport <rppt@kernel.org> wrote:

> On Mon, Jan 05, 2026 at 10:38:30AM +0800, Cui Chao wrote:
> > Hi,
> >=20
> > Thank you for your review.
> >=20
> > On 12/30/2025 11:18 PM, Mike Rapoport wrote: =20
> > > Hi,
> > >=20
> > > On Tue, Dec 30, 2025 at 05:27:50PM +0800, Cui Chao wrote: =20
> > > > In some physical memory layout designs, the address space of CFMW
> > > > resides between multiple segments of system memory belonging to
> > > > the same NUMA node. In numa_cleanup_meminfo, these multiple segments
> > > > of system memory are merged into a larger numa_memblk. When
> > > > identifying which NUMA node the CFMW belongs to, it may be incorrec=
tly
> > > > assigned to the NUMA node of the merged system memory. To address t=
his =20
> > > Can you please provide an example of such memory layout? =20
> >=20
> > Example memory layout:
> >=20
> > Physical address space:
> > =A0 =A0 0x00000000 - 0x1FFFFFFF=A0 System RAM (node0)
> > =A0 =A0 0x20000000 - 0x2FFFFFFF=A0 CXL CFMW (node2)
> > =A0 =A0 0x40000000 - 0x5FFFFFFF=A0 System RAM (node0)
> > =A0 =A0 0x60000000 - 0x7FFFFFFF=A0 System RAM (node1)
> >=20
> > After numa_cleanup_meminfo, the two node0 segments are merged into one:
> > =A0 =A0 0x00000000 - 0x5FFFFFFF=A0 System RAM (node0)=A0 // CFMW is ins=
ide this
> > range
> > =A0 =A0 0x60000000 - 0x7FFFFFFF=A0 System RAM (node1)
> >=20
> > So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to nod=
e0. =20
>=20
> Can you please add this example to the changelog? #
Also, please +CC linux-cxl@vger.kernel.org given this is all about how
we handle the CXL fixed memory windows.

> =20
> > > > scenario, accurately identifying the correct NUMA node can be achie=
ved
> > > > by checking whether the region belongs to both numa_meminfo and
> > > > numa_reserved_meminfo.
> > > >=20
> > > > Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn> =20
>=20


