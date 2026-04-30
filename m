Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F411AFF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A966B008A; Thu, 30 Apr 2026 12:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62AD46B008C; Thu, 30 Apr 2026 12:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567436B0092; Thu, 30 Apr 2026 12:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 497786B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:42:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6B1CA1889
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:30:15 +0000 (UTC)
X-FDA: 84715759590.26.4594EB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C3B3180012
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:30:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W0b1vNQU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777566613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HusZZYGameQLkyaexG0kOeh4wxpEGTQwlJiByrJlkGw=;
	b=AQKxnEDQxROFwqFJPsdNFCqlZqDG6skpp66qZcVFmYgz8wiof8AY0HT9SZYszPlFTgD2hf
	dSuoPmcEcMmEpnXer1V0IibL173fgiqxGrfHtgApfKftD9ZU0QaOm9uOkDlbiug7qcverj
	/eRSXYgRk2ln/s3SDTtoGe8v+GY/A5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777566613; a=rsa-sha256;
	cv=none;
	b=TsNNNOVPl3dnJgMMwhH1l950X8KG+wAovAdLRQM8ICUczREoIpzDC/qRwrfEncpAWEPZFI
	P8CubtLJ3XCl6OHr44RvmPiI7gXsu68SdoeE2qzuDeVGc1aj7nybxBMd+wkygZFXZuFn7C
	kLeanrVYFpGtoGPIcGS+3qmSiUbzbRg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W0b1vNQU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C43CF43BDE;
	Thu, 30 Apr 2026 16:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E73C2BCB3;
	Thu, 30 Apr 2026 16:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777566612;
	bh=RMh9R5ZBw4gBqhQPnnUbGwPvxHi1lsGCDI4+n+Kx59M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W0b1vNQUtMVY37aC56FLy8Gp4xDFo41/dQaKFVjZf+/cBUmXAmQYYzwt1ipno+RxD
	 fn5plXbqswUPpep1ePy2yYFLxY3pzPQKLqhkI8zj19MfIna2O1pRrPL2ZwmXjsw2rn
	 dRqQPoumN5kMiqaROYfL9lxewyutX0ztEodllilnMtipWge7/KAMMOlwAh4gjje6g2
	 6HE2srRLC8YESseJ6RHruWczhwt4IXnrFcGxmd9Tf4k8Ws+OjtdpGZp+kts3lAXbkO
	 WHydLj4SdchYwmSY+q3cWMcdqT+4J49y95WiwZFbgl3UGx2bn+bFyELZzl2/m+l1pl
	 w/WKEqp6v/a2w==
Message-ID: <560c4a15-d333-41a7-b708-8a9324641870@kernel.org>
Date: Thu, 30 Apr 2026 18:30:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] mm/slub: defer freelist construction until after bulk
 allocation from a new slab
Content-Language: en-US
To: hu.shengming@zte.com.cn, harry@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, yang.tao172@zte.com.cn
References: <202604302204413066CxdJnJ3RAGH_7iE4EBIO@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <202604302204413066CxdJnJ3RAGH_7iE4EBIO@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C3B3180012
X-Rspamd-Server: rspam04
X-Stat-Signature: qsp4fw1saos14den6d5iy5rygz9tb5ri
X-HE-Tag: 1777566613-586991
X-HE-Meta: U2FsdGVkX1+60E8llTemElykI2o3DqvyzvDj9ftEsSz/1C50WT0/Vw0HuOMM6SEFHnlJjPs3jE85do3oCjyY1tWjB6PoSvRa3bxbldsDdtkCrIWpc1okRAQRBpLU67ivjhUdP30APM0ZuqyIK6Xs/oi8I44khv0qTiYfFEN3q8CM+GrSGdTY0miXZol0pGS1qHjb/3fJlERwfChMY8uQI/kRZNudGK3N/7xirk3Z0uV0562y+62pzZD46zM/wIs5fuRo6O9Im6s2hk1hewRiLx23MbiL/sDT3d6U44Nf+8sOTDNDxCR9ISMmPRIIaiHEm1sZsOAMGHB0LGE4dxH3USMAC3P7fk4cNiuveLFC4uUjmg0jShZNp5Jw6HByBu1EdlFUnEQm8pqbTtnnvwIRzR3Fb0rEL2unO/hTqhZgw2xI/lMeA0iq0Kn0BGoIO8sZus0MzMRDw7pV38lJ5dqShIGCtYFX7LNcvdqtGBWvO7vbIADDC/NL0ldC8GbN/stVNu3dC+WdXlne89TIoZUJ+L1E+nDBUh/JHIIauAc2y6bTV3w2QdjHE2w8iSLq58WuOrbq19dcahxDcP2E6OJHAbgBnwLIWTzvPhId5HUQfdMHmYvywG4YroWKfMuThSaoaCgWMkFOAmUeuRitGwZqd8lw7MpuOObcYIYDV8vxoRr+A7ivEsI54qICLGVKDkDG3OX5SUsLwhwx6DnixSuQ1jLns+EKe5FPaASFhUyw5rvXXZaXMnzpyuixbl8bOXSqipWqxgTGsfAQON5DmNJeRMJFR7uelRGLcWHLLCUxMllGmK50tDQyEm+bkpX7bukJU6gPHmUZBdVKLoxNKI++H8GsRcWEMHNgbu1F0f0LWACiCXbfVjL137SvkProh1fyY4WPYSM11hElAIEftFBLbypzKoAgIZQukpZxhPTQi+HlgkfJi4R/YlPYfGJtVisuGD/ZcAmRBZ2GVwWyxEU
 KvSRyg/u
 fNMQd2GTE2LUi3EqQ22vL1P1vKRfshq0Xf4T8kvbTNVdRdhNTEGQHBaBJySnaf58ykRbdY6Ysn4HQkn0FW1cvSTEQ9We0OWiF838MeO8r5J/IBLzmj6ZhQ7mgEa2dYZ+ITguH08dbKbuY8LheDWS9IICvEOmvi1MQafuHelzEuzdt25frbGZ3MRm3iX60RXzcbT6TfG0mI9c5Bbez6QZnJtsYr1qmcLa8pU7JL2v94MSubWjRONERu0aT8VNqGf7s2VJYyupSdME1rIKfksUJ7axgN0K9CAhBxMynqt+hoxxaE8FIFvEcBWiJHW8V3g9/MjBuY82zPXQnWJT9KnYy3b5sbbSdI3wakQuoP2ietkk1+ghxYIw07mJciQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 16:04, hu.shengming@zte.com.cn wrote:
> Changes in v8:
> - Initialize the selected object's freepointer before
>   alloc_debug_processing() in alloc_single_from_new_slab(). Deferred
>   freelist construction skips this object, while debug allocation still
>   expects a valid freepointer.
> - Add a Link to the 0-DAY CI Kernel Test report/discussion thread.
> - Link to v7: https://lore.kernel.org/all/20260415165255601BBSSoil3iPkco33RXFtU2@zte.com.cn/

Thanks, updated in slab/for-next

