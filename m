Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06DC1D29DDA
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 06:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F0D6B009E; Tue, 13 Jan 2026 01:40:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D156B009F; Tue, 13 Jan 2026 01:40:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B806B00A0; Tue, 13 Jan 2026 01:40:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 11BFB6B009E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:40:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7FB6C04E0
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:39:59 +0000 (UTC)
X-FDA: 84325990518.03.CA5A356
Received: from sg-1-103.ptr.blmpb.com (sg-1-103.ptr.blmpb.com [118.26.132.103])
	by imf12.hostedemail.com (Postfix) with ESMTP id 041C340008
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:39:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=j15ofVzV;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768286397; a=rsa-sha256;
	cv=none;
	b=wLGTYSKBZiU3bsuSRxagPfk4I861JD25TuOQBR3nw+fHSZnaLfVCwyVzSkwjnY+iKGjWjV
	zTOZpWPtyd5M+12XAbI5KGklpiP/5G4BdndLagoA2yDbJ8IIE8/jdwDJbrSxmAS9khLWsd
	+94bWZELNuv7Y134moYyuGLUuXANRQg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=j15ofVzV;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768286397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4s2hZ7l2JA0r7A000mHzPL8R+UEPg+VTa87KxzXQ3Tk=;
	b=xJf68wxve05YDcEUpaoHua6lpbfUj85e+PwgReHOeSQHgb4zs7zy4yYd+WQFwxyOIgE8re
	4pmgZRHszPsDMWiujrd2EFm7TENa1KdlkRZs+oWNTrgCM0Lk0o07e1oeIUAHXewv6ayibg
	A/rQSnA6ybYOsfl4rE5brHSn9zDimqk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1768286386; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=4s2hZ7l2JA0r7A000mHzPL8R+UEPg+VTa87KxzXQ3Tk=;
 b=j15ofVzV+OhgiZ17PpMtGWDrzueO42EkUxImm5gTu5wDImSFLMlPifJJOmxv2Y41Vr0Mqo
 DoNV3/mU05wyB90tTGkM3tEBw6hpryQ5sGlfS73QPkSA4bCZy6lKcbmSRcWjQUl9zR7WAN
 oVVOBU28ghZd94T3ByCBQ7e3dSJfpmBtsq7+7r1bFC349+k0i4u+pP67kNcNs0p8CMtpUp
 KI42I8ZSLAL0/VAqLTUop+efaCmEYtKnP3yzqPk0qSkzYokwaN0LfMDyzTKY75sdF9ybiJ
 QDkUJuMHi5CkKCkI8bhYHlW9czInE76amDFXteunVYJb1RLc2PK+Kih4UPqK0w==
To: <ankur.a.arora@oracle.com>
Mime-Version: 1.0
References: <87qzrujxu0.fsf@oracle.com>
Content-Transfer-Encoding: quoted-printable
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <fvdl@google.com>, 
	<joao.m.martins@oracle.com>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mhocko@suse.com>, 
	<mjguzik@gmail.com>, <muchun.song@linux.dev>, <osalvador@suse.de>, 
	<raghavendra.kt@amd.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Date: Tue, 13 Jan 2026 14:39:28 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26965e8b0+60420b+kvack.org+lizhe.67@bytedance.com>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Message-Id: <20260113063929.29767-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <87qzrujxu0.fsf@oracle.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 041C340008
X-Stat-Signature: a5mo3o7hqomz8wrwscdjpdyydss6bnqw
X-Rspam-User: 
X-HE-Tag: 1768286396-554471
X-HE-Meta: U2FsdGVkX1/GZApGWSSgbYFK83B2+bn46PjG6IZ78zvdgLVT1sX/3LZGvBIslrjLenViT9Z5i6gdXlXzZRcIrv0JIFbbgUbMvYitrAJw8ieD7PFJpfhP56U3uqbrHHQteE+nuSoYKigNnmoHWk1yTFUgZKkv7sij9g4GmkuBCo1DSpmd+Ilozrud9Niu0vyjJxSU2nYHB/wqtQx6futLFY7yCBO1UvDTSoOpjUg8D1P4N7RgN1vSny4jQIpnJNJYMz3F6zrXmKYfbb9qFOlRE6CpT2xI0tCju1ETas6m28YEes1MV3ZIVd7mzD9bHUQDGU7Wp7JLBSYl96LYr0NeN3z/H5I2aqn1jUEwjrez29urlvKfWQxWIkC5JWg//sUE+V9bShODec3zFGy1+/DzZGJXxkR3XBLPuxvgFynOpV4u++F97U/AVEXvEEIUHmHoLWiA0gAC223CNi7ZeQoYt7xvF5EIUu3LNiPrTeGejt6zejUbrtVRPdmiKo3jDy++NGslrWsWsyNwRqWZYG02gP19y+KyW0Zu3eXIdvvtwLferYKo6ixDccCkL3iZTkUbV+8Ty/zDsPpS8eM6sfDc1CafLKI3hspM7aTdxyPy/bqHilOYwwfOqot3QBztgv8pxzJaOlOMPGL8FsRG3GV2SM6nyqZay2PwcJYj26S/fxphjXWLV7gWu6hgBqQpbBxkkfEQmGinZHYgdi1uyW6CtLZwN0aafLvwnp5QMsAwDr9LtymKzDktEQtw+8vbsL6PL2v1JnPan+YEE7zogOCTfiY3z9yj30Vf3tC4q+UsyHq60A8hFzn8HyVYUIvJYGGphC8nHW/jAsLpdnOr/9BLs0A7Yv4CrzjtAqN8TbLcS0lSNj+BrQJbCjVffseYOnlJB305x0CFvUadPX5hi2PSpUDMS2znMJMpWiHbRMY6D+VW84q3/AjnVnApqmVItq0tbq2No3UtOwYvlwla0M+
 9CeayWGC
 yr3FVq2NgbH78jNtfrEe9Z6qsUYCryl2sAXWOA0Gv0U243Kj4Sb3kNzdWZ444lttcnLH5R9up8ea9Lsm0wndYIYong01K7YVUWO+VkZBvEpzhhy1Lb0JYbA5h/8wiGIZDHqv2Ib0LDjZdzjQ0kp0jqjbfJl8z+iXzM6UIIanxfE5mGXtbFPukN7Ek3jEnqeSxmDAXbV+ytQfSl//GWflP8OIGkcO02xG5Vc+cHcxRk0Ep6kNNECXb0dL26rEltzfugf/f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 14:00:23 -0800, ankur.a.arora@oracle.com wrote:

> > Regarding concern (3), I am aware that QEMU has implemented a parallel
> > page-touch mechanism, which does reduce VM creation time; nevertheless,
> > in our measurements it still consumes a non-trivial amount of time.
> > (According to feedback from QEMU colleagues, bringing up a 2 TB VM
> > still requires more than 40 seconds for zeroing)
> >
> >> > Fresh hugetlb pages are zeroed out when they are faulted in,
> >> > just like with all other page types. This can take up a good
> >> > amount of time for larger page sizes (e.g. around 250
> >> > milliseconds for a 1G page on a Skylake machine).
> >> >
> >> > This normally isn't a problem, since hugetlb pages are typically
> >> > mapped by the application for a long time, and the initial
> >> > delay when touching them isn't much of an issue.
> >> >
> >> > However, there are some use cases where a large number of hugetlb
> >> > pages are touched when an application starts (such as a VM backed
> >> > by these pages), rendering the launch noticeably slow.
> >> >
> >> > On an Skylake platform running v6.19-rc2, faulting in 64 =C3=97 1 GB=
 huge
> >> > pages takes about 16 seconds, roughly 250 ms per page. Even with
> >> > Ankur's optimizations[2], the time drops only to ~13 seconds,
> >> > ~200 ms per page, still a noticeable delay.
> >
> > As for concern (4), I believe it is orthogonal to this patchset, and
> > the cover letter already contains a performance comparison that
> > demonstrates the additional benefit.
>=20
> That comparison isn't quite apples to apples though. In the fault
> workoad above, you are looking at single threaded zeroing but
> realistically clearing pages at VM init is multi-threaded (QEMU does
> that as David describes).
>=20
> Also Skylake has probably one of the slowest REP; STOS implementations
> I've tried.

Hi ankur, thanks for your reply.

The test above merely offers a straightforward comparison of
page-clearing speeds. Its sole purpose is to demonstrate that the
current zeroing phase remains excessively time-consuming.

Even with multi-threaded clearing(QEMU caps the number of concurrent
zeroing threads at 16), booting a 2-TB VM still spends over 40 seconds
on zeroing. Based on the single-threaded test results, it can be
reasonably inferred that even after the clear_page optimization
patches are merged, a substantial amount of time will still be spent
on page zeroing when bringing up a large-scale VM.

Thanks,
Zhe

