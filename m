Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A04AFE9D403
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 15:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E92736B0098; Wed,  4 Feb 2026 10:43:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66AC6B009E; Wed,  4 Feb 2026 10:43:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D692F6B00A0; Wed,  4 Feb 2026 10:43:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C29056B0098
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:43:32 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6368EC109F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:43:32 +0000 (UTC)
X-FDA: 84407193864.30.0BC3673
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C1556120014
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:43:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VPZZro8v;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770219810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/yWUHtkwLAsu+DnrU+gY101qDlmE6inMuHEbis68x/M=;
	b=FQtIP92uBmEbRJNgLlP34vfZ7ZMnZ+wROYIcSLyGEsbb/bcuGBGgK2Db8HvbghheWR9zsq
	d2hdjMFCc7ZOruZj7idzGR8ElhCfv4zd8Ek0yJS5Gt7QqsnmXNf8oILtQqY4c4ngn93rd5
	G9zZvZOo9vIF5jr/0ClCYVtqLGB1P+Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VPZZro8v;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770219810; a=rsa-sha256;
	cv=none;
	b=HnEBQIpo4Xz2z2Ot26b76Gqy07XkqjpxCSdzbuguZLEycIAQu4LfndXIh/6dlS1awhQxXa
	ikMcvSEud4N0aC74QirExcW5KB/3ud7LV1XT03MPVYX6ptkLyhzDwgZ+cwHAT2WKzyIjey
	mDFcvoFtGD3hvn9+OamhLccrgRaL97E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4167C60010;
	Wed,  4 Feb 2026 15:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FD5C4CEF7;
	Wed,  4 Feb 2026 15:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770219810;
	bh=Axbp5hUl8npKt0WGTCQFeaQ4EcYxU7hzPCvTCkrlP5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPZZro8vd+CEap7faYo2Y06FFlw4uMU4KKKzjvXbqO4QrDrZ9uZf0QZZIBCHhRAL8
	 ygnLnOXVGs7DShWU3aPAtMJfjEsdFZgCuoO4E/7kakEQ04lPFK6QNniPB9LZfPuRbo
	 1n9CFcr0Mh1DWN3krmPIusnsFdUZDlU5FchVmtLziuk1bpPVx+wjsGSxpYunEVKkcM
	 JyEUZ/WZDgCLzvwaYRnBVM4TVUxTOqUtWbBR0ryImVEY9cDtV+usw+L7y0s6Bj+oNV
	 DUpSM7LeN4YPT0b7FiJ0kKhAJbNWAJBYQojBPmodi/usMTUtgZlyFc3oIw4XCqqtRA
	 zY9Lr0s7xRFjA==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/4] mm/damon: Support hot application detections
Date: Wed,  4 Feb 2026 07:43:20 -0800
Message-ID: <20260204154321.18577-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <8b8e9dde-33ff-41f7-8563-d9aeaf5efeb5@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C1556120014
X-Rspamd-Server: rspam07
X-Stat-Signature: hy4ui98k93nkct6x3xyxnjjqy5u8mtqi
X-HE-Tag: 1770219810-787334
X-HE-Meta: U2FsdGVkX182a9jF6h6aCh5Xsz5d8F/7TaAknRTyBXrO6tbTFxw34bfhr6h3cAF7gG/XTpMAvML15MC4ElmSrhKSwHZwhU0HOsoV0ZzzBiMK0BrC5+yLQ7QoLkU7uCF4EvWeTTs8Vx3BLQppa0HNqyrkHnQ7NqCVNZT0aZjWv5bpmRK8Nhu4+VH8CrZ/RZsN8Mazip6fzfyfui4Yp3dn8ilVTrVYKz9borueMOBVeFVUOwzCg2p1SkCGloiT0xO8k9Zkcec/ByGCPYP+QENyqffh3wbBXt9YqaI4/7Jz0YEja8azJ7c7onCApOMdfGxMw8pFEX/vC3XSrXfU/aZxYznXMJzV2gNbR6a81Tng6jJh7mxDkFJ2GEB+v5JOMbCsOVMMOg0MG/TmpZVaITCJDC6kT/WhTHfydrIDUfaAF4ALWSPcpDnEyolteejbhpSPHB1+wY2o9rlFByVztFWj0ZdeqivYS0+v8xHsRVH85K/ZYKqpqvhFhPmJc2eRLEl0dO5z1nQ1d/UCr207F5B6I1YmSP+/vIEaK2VLoJEc7XFS1YlNSdPh7VU0DNwwZkvUhGrFPCqtsgPvYzuUf9SGBwc7vb52mrCFayEmajSc6RoqZDUcEcTYX3KSjic3CAXNdYC1ACtLogb+ZgPNWZgFhT26mkWtAzkZu0j5tauFDeBFOsJ5Hem+Fo1tugyhsYZvuSHu8uPXHGF4+uYe0NwaZdfWC1+HQIlUmN0Nk9Y85zu5UXGWFvWu4v9z6NZ54l82xXh9EcsZgb9awjAN3CCBeIfC4NOCjs3yDLkm0IsMcLQ3dsX2ZTYFFmw0m0aIIZPio3QOrmsixbuv6/bNJHsMiOm33n3NTriWPRYrsD7reZehyScVWJ+rPAlNPIrSmLWXdlrYfqh13pOhfcyhDr+MRp4D0gJiMz+5Kn8NsWdLNGdZJrTlb0GUPphWFFOtPVCpvuis21ZYHHwfseZcdlr
 +5i8uhYm
 w7hg2FJTZixZEndhbvnMblZ8poMCxwTfONDrqKv+7tt3b1O5sZmk+FCbLGXIVMOGz6Qz6M9T6Hpm1waJYc+bZrJxfqEm/P/65UxFQO54T5pXKo2LTUwmT6ppAEWK1leFPn/rs6vNJU8NzYtOEnGJvKryS10aQiMn617895Vbco3P0nxsue1rnpll0c8HPx95c4oTXVydKw8GCT0+RQEi1AenyY4Pj9DXXNP7mPeBzib2LXL4BXdBkoGIWh9nrUkcR8lifQo3rReOa3iBEizFEMp2G1WoFBzCiEwEoXH8Ex6/2RiUZyAY6i0v/WA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Feb 2026 16:07:40 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 2/4/2026 10:17 AM, SeongJae Park wrote:
> > On Tue, 3 Feb 2026 17:25:11 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> SeongJae,
> >>
> >> Thanks a lot for all the useful feedback.
> > 
> > The pleasure is mine! :)
> > 
> >>
> >> One thing that I was not sure about while working on this patch set
> >> is whether to have an external new module or adding the logic to 
> >> damon core. I mean, the hot application detecting can be useful for
> >> all other modules and can improve DAMON performance.
> > 
> > All exising non-sample DAMON modules are working for the physical address
> > space.  I hence finding no many opportunities to bring benefits of hot
> > application detection to those.
> > 
> > I agree the hot applications detection could be useful in general and creative
> > DAMON use cases for virtual address spaces.  Implementing the feature in DAMON
> > core layer and exposing it via DAMON sysfs interface will help such use cases.
> > But it seems not straightforward to imagine how the sysfs interface can be
> > extended for the feature.
> > 
> > So, I think it would better to be implemented inside the new module at the
> > moment.  Later, if we end up having more modules that use the feature, we could
> > move it to the modules-common or the core.  If we further find a good way to
> > integrate that with sysfs interface, definitely it could go to core.
> > 
> > From this point, however, I realize the feature can also be implemented in the
> > user sapce in a pretty straightforward way.  Have you considered that?
> 
> I though about it. However, accessing the task_struct directly and extracting
> the utime is much more efficient that getting the required info from the user
> space.
> 
> > 
> >> What do you think?
> >> My implementation was module based because I tried to avoid changes
> >> to DAMON core for the RFC.
> > 
> > If there is a good reason to implement that not in the user space but the
> > kernel space, as I mentioned above, it seems the module is the right place to
> > me.

I agree it would be much more efficient to do that in the kernel space.  But,
given existence of 'top' like user space programs that also does similar works
and heavily used, I'm not directly feeling how important the efficiency is in
the real life.

Meanwhile, doing it in the user space (DAMON user-space tool or your own one)
would be simpler and more flexible.  For example, you could simply use 'ps
--sort=%cpu', and make the sorting algorithm flexible (e.g., sorting by RSS or
using different sorting algorithms) without changing kernel.

So there are pros and cons, to my humble view.  Those may depend on the given
use case, and I want to focus on your planned or expected use case.  Could you
please clarify your planned or expected use case, and how important and trivial
the pros and cons of keeping the logic in kernel or user space would be on the
scenarios?


Thanks,
SJ

[...]

