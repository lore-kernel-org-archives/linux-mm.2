Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4034D30CF0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 22:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE676B0088; Tue, 13 Jan 2026 17:59:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869226B0089; Tue, 13 Jan 2026 17:59:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76AE66B008A; Tue, 13 Jan 2026 17:59:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 67EE96B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:59:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFB3D13A732
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:59:14 +0000 (UTC)
X-FDA: 84328458228.01.A14AADB
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0A8D140002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:59:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=IZBFjmUk;
	spf=pass (imf27.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768345152; a=rsa-sha256;
	cv=none;
	b=X4LG1sgzzIQRjZraZmwiF7LBIZi0w97laUxOSL8WY96G3SZN3q3p6+UslHjVUEN6BCs25j
	hKOY4dRdbVwNna/ZJXuAwg4pQ/RyZHeVl4gJOs84+H0tGwV6PbW1NBdZ0pshfBem/YT5yk
	/l5Uj4gR576pkCBcvREWZWMHl4SkGFk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=IZBFjmUk;
	spf=pass (imf27.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768345152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKj8OFgIWZYaPjLOGY0Hru5SNu94TWYuwIW6GtEw+PU=;
	b=XXoO9R45MBl8Fm+dHdNXCZrYUnkTPOil7bPqF3owDhLpQe3ioPyP2X6t4CkrHZQH22/AVa
	fYW/zputXHrYe5G1LbnuHGPMQjKli7EWTbCca8IJ/q8WoF0zyyyeHoI8LU4jxegEayGpFu
	Gv1lzyXwD3WK+jN49SEu+fo3Ui+2v9g=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260113225909euoutp016819524c50204ddbe0fec4d929ca454b~KbItkGq9z1847918479euoutp01Y
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:59:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260113225909euoutp016819524c50204ddbe0fec4d929ca454b~KbItkGq9z1847918479euoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768345149;
	bh=pKj8OFgIWZYaPjLOGY0Hru5SNu94TWYuwIW6GtEw+PU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=IZBFjmUkin+XtXk9bQ9fIqYSTGm8Btqh+QIviHYKjDKoKYs57o3MoqaB+PEFgorjj
	 eCm+dFMWXmVaT8evuSaB4/ca9D9jHtHw8/1mnYYoOQSifc8CLrF3ePufVr1/OvKo5A
	 dH1gkUg1/DWWCaF9qsmP0zhfIrSIXG8YZ5nd9b3Y=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260113225908eucas1p20120cc4c7ab2c17932dfb40d9f02c83a~KbIsqiN7i1638616386eucas1p2o;
	Tue, 13 Jan 2026 22:59:08 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260113225906eusmtip2be65a6cf8cc51f597c2f777164fd7547~KbIq5jSm91614816148eusmtip2I;
	Tue, 13 Jan 2026 22:59:06 +0000 (GMT)
Message-ID: <643b75da-d673-4106-888f-7fe232dccf7b@samsung.com>
Date: Tue, 13 Jan 2026 23:59:05 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 0/3] dma-mapping: Improve atomic pool behaviour
To: Robin Murphy <robin.murphy@arm.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, david@kernel.org
Cc: bhe@redhat.com, iommu@lists.linux-foundation.org, linux-mm@kvack.org,
	vladimir.kondratiev@mobileye.com, s-adivi@ti.com,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <cover.1768230104.git.robin.murphy@arm.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260113225908eucas1p20120cc4c7ab2c17932dfb40d9f02c83a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260112154649eucas1p265e59d616343bb4c2ce80128c393f56b
X-EPHeader: CA
X-CMS-RootMailID: 20260112154649eucas1p265e59d616343bb4c2ce80128c393f56b
References: <CGME20260112154649eucas1p265e59d616343bb4c2ce80128c393f56b@eucas1p2.samsung.com>
	<cover.1768230104.git.robin.murphy@arm.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0A8D140002
X-Stat-Signature: 7cu14k9tdwrbn7yakuxpczkjbfp87tt1
X-Rspam-User: 
X-HE-Tag: 1768345151-198554
X-HE-Meta: U2FsdGVkX1+yXOyyS2mYn5Qs+SyKOBL+4H4CJBsYE0A4cR7+rsbR7Dcn06SEk7phOOtwNzuLHmtfRToWWX2XiD4vszlOkVck3rGAn66KhZioKeIRB3YMsdQkkUEGBGqv1/m/Y+IEbboYor1mWWOH/FkWY3dm1pMo0ZnSeLxWu7q/OMoie3l/fxy43NK7gKUg4KTB5dw+NRxvjmy881sx2g2nrMpf3VELvYfLvaBx6wYOpEyBLMVTsxm/dUBKOOj4kwS13v6QeZPmxXYbgQxJ0zvQ5R4wOK+ZvHjKyDUBIGRO+QsVXmlDGTtZlrFhK4Nwr8RctF+ShtCEN5YqNmF6GIf5R+h51HoJw9yIrTMNOzyp0FIi4no8SdO9V0WzIZpVSjNT+i4o4bOiuASzw3beYYjqJf9TYTvD6VBPoMhIa4SV0EAYvgusFSglT/Uk6QRYAxa0Sms8F4g6lKoXQGlKfS48qp9h21/+fdA/lC4Z/PnO4TdSZ+LBfIqD85D4sfiDJ2Zx9oP+JQmMr4LyDWxhL6BR3evNIC/FhNlwuGB4etWDbbyP+v19IAqQL7GNZ3IgngQ9mXsL/RzY75V6rPgSLsijr5uvvuSzcvTqOgLto2DfLeTFa3XkAuF9FWv+mqmEPVH4VOgQz1TUxZ9ZQrR0FxuYoVGTBSy5EQ8mLU+V1XSgD+AEt7akd6e/Oett9uCOAR+8Z1dn6TVMoPB0yaaIUUqAi6luXpZJI/H7rzrU02j0hlVe5MYEtp/s3mh7aVuoSwNrySERbS2gtYsYhEau2PGdIodhnBAC6hQBY7rz+MSXPzcY7JDEow0suCx8MQ+ivSKDQdU1JbuDb9gm9QH3qkDLV+ehjOKtwzZKmjMF/3S8Qa6qMUebbZwGLNgYu5rLZd3OKpITb8dM/tRoOU1+QEu1mVRbKiPoa9FsqGzgl4xabSiK1b/ETBeWqiQkSyL7tYmLcCEpQtUFIWnBuNH
 twYUKoM7
 STPQMEEhLDUVWZilorCtXuGnjfNBATTWJ4hP/M3W1yYE5XADh4qENdCVvwqmzRdAbnjBMxrGTlDxtnG5mNuG/04OuG2jF0ZJD6Rv2ul1iqPuHcdkEpsJUOfQpbSHRoX4vS1YJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.01.2026 16:46, Robin Murphy wrote:
> These days we have somewhat of a matrix of mm zones that may or may not
> exist and may or may not be empty, which the per-zone atomic pool logic
> doesn't actually handle all that well. It's not all that difficult to
> improve robustness and reduce redundancy, so that's what this series
> aims for.
>
> I initially wrote this just because I happened to be looking through the
> boot log of one of my boards and had one of those out-of-the-blue
> realisations of "hang on, why *is* it allocating pools for zones it
> doesn't even have memory in?", but coincidentally, it seems that others
> happened to notice related aspects around the same time[1][2]. This is
> my attempt to sort it all out properly.
>
> I guess this could go via either the dma-mapping or mm tree, whichever
> maintainers prefer.

I will take this patchset to dma-mapping-fixes branch, thanks!

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


