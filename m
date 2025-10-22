Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19B99CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BE148E0003; Wed, 22 Oct 2025 10:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1954F8E0002; Wed, 22 Oct 2025 10:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 084308E0003; Wed, 22 Oct 2025 10:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EBC3B8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:26:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 863B513BD66
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:26:57 +0000 (UTC)
X-FDA: 84025976874.17.66D0B79
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C826A000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:26:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kroah.com header.s=fm2 header.b=XBtN2lNj;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="w i8ZyAI";
	spf=pass (imf25.hostedemail.com: domain of greg@kroah.com designates 202.12.124.156 as permitted sender) smtp.mailfrom=greg@kroah.com;
	dmarc=pass (policy=none) header.from=kroah.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761143215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOvRrxLI/PxVSWmhxM2KgyJk/X+u6+/Vmaw9PuxY40k=;
	b=3j0BGGjBLyt1H40VxO79K67SFceZ6GCAuxLFbSuxeoTdol1z+FQ8yKYgx12amRJYVlROU4
	BYSprrUth8dzn4N5cOvyQMbARfKEaLvFDxH8Trj5tm/x+tii7QPXv0QHzID00McpH+GVq5
	71KfBfpwueDSst2/zk98Pjxh0in7ubg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kroah.com header.s=fm2 header.b=XBtN2lNj;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="w i8ZyAI";
	spf=pass (imf25.hostedemail.com: domain of greg@kroah.com designates 202.12.124.156 as permitted sender) smtp.mailfrom=greg@kroah.com;
	dmarc=pass (policy=none) header.from=kroah.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761143215; a=rsa-sha256;
	cv=none;
	b=ClP7OO5+b9feNGH1Z8ph/YWldDMu1KkCWCzAqzB8yJVrTpe9GlnM1+p3QIp2Vaw89nCLXl
	swzWL1hV7/aY9gvhs5KVdZzE4ohC5qC4hEZNPqym7cJE0r11oxpNIRTwy4YF5zTB7lu6zj
	jT7NHDiVAir/ks1b60xTkf/2ZHQlpOo=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 400357A00B5;
	Wed, 22 Oct 2025 10:26:53 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 22 Oct 2025 10:26:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1761143213;
	 x=1761229613; bh=jOvRrxLI/PxVSWmhxM2KgyJk/X+u6+/Vmaw9PuxY40k=; b=
	XBtN2lNjCSSfXGaqXi0gx/hlO8WnexR6tUKWFw0W+Esl1w0VoLdaeTBIpl3+3SRt
	8k0rusGVLaZzq6WMIbQuyM0WTeGOvKbmHJjwdrvEfb9GrR896b9a+9tEVP/3sdpf
	paxsxPUnRdTFFnAtOtM07XbRfRVrG5HBEzRZC5uKdExsyRB/Bzp5lpOMbS7BkPih
	KmI1toWj9g8kClgqlGVd7rtTlylfX4nulaysdLtdZfm6WvkOnT4eDZOEZObwlbIe
	XvmLXVmfvHix8i5HNxPGoT1+fXs0nagnK9AITqKPBowKP+EmQHFKGhEf++nGCMZe
	YxA9ggHBJsJm8bv/iF/7zA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1761143213; x=
	1761229613; bh=jOvRrxLI/PxVSWmhxM2KgyJk/X+u6+/Vmaw9PuxY40k=; b=w
	i8ZyAIsZtLOryR2GGVNqeGZtf8OTyPOHf6pua9/Bnpk4edYPEghboe7XrCsnRwis
	WBKNNK16wl9riG2ABWUcXXmkWKAM1IVvWIdcAv7TTPWO+dumAHiiNHlmQnNI1YKU
	DrtJyS7tlvRrHh0MzxA3OGVC1hODIFU6Vuvuj1ilxlG9EMHHWOVZKI2iojCk4VWJ
	TG3TEuoKd1Iytp3ITeBTdouGLMRhifNM27Ck0KHTFXWf2Xmm+dlkq+dxEeUJ+jRh
	8OWM26Faoey1nPrM5mbxb0xSgnGKfPzk1lS/4MV0eBfqNl4q02z1X8mlKKLvd3yf
	2xr2nypxaOlNK4P7Xi2AA==
X-ME-Sender: <xms:rOn4aFjhzhWf5UKFXIQngaoA8wC5xpsjfdgvdKyzQz3Uj3wIGjqYUA>
    <xme:rOn4aCye09H1Qqwat59MyRiZ4WtcMmBzXAYGpX5Dv_8ePeV4HZsSBFpgnQhSeQNHN
    3hVy940u5n_SnfyubajrMH9x33xXWTfWkjLF6aOEp0l3DasAQ>
X-ME-Received: <xmr:rOn4aDwAZbrOopB1xYax-VhcTT1OpzDw9qNkcnPY-NQn_rQEMd01G0at>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeefkedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefgkeffie
    efieevkeelteejvdetvddtledugfdvhfetjeejieduledtfefffedvieenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomhdpnhgspghrtghpthhtohepudekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehlvghonhdrhhifrghngheslhhinhhugidruggvvhdprhgtphhtthhopehsthgrsg
    hlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhu
    gidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrg
    htrdgtohhmpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgv
    rdgtohhmpdhrtghpthhtohepshhhuhgrhheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgv
    rhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhgrnhgtvgdrhi
    grnhhgsehlihhnuhigrdguvghv
X-ME-Proxy: <xmx:rOn4aMqYobzJeKegfjkTb2Jig2imGUptMSQ-WOJVeXy52dqRTzyJLQ>
    <xmx:rOn4aGlJAiIhljC8Jzc8Rlme4sPAFf5x2PVyh9nJ_wFCv19LEn15gw>
    <xmx:rOn4aFxOsEdEjF2cBNW6DFm5xJ1ZddlhJYnaYAxsI3aZNGWcNn7iMw>
    <xmx:rOn4aL0O7gaLZH54F7WEnqsoInBzvSTsUEWRZEg_V-XeXCFJ2g7Eog>
    <xmx:ren4aATnIlNrUwkxxcWac1tUEZMNUOouhUXC6W31CVSQFSaRLN_PrAxB>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Oct 2025 10:26:52 -0400 (EDT)
Date: Wed, 22 Oct 2025 16:26:50 +0200
From: Greg KH <greg@kroah.com>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 6.1.y] selftests/mm: Move default_huge_page_size to
 vm_util.c
Message-ID: <2025102241-clubbed-smirk-8819@gregkh>
References: <20251022055138.375042-1-leon.hwang@linux.dev>
 <2025102230-scoured-levitator-a530@gregkh>
 <ff0b2bd4-2bb0-4d0b-8a9e-4a712c419331@linux.dev>
 <2025102210-detection-blurred-8332@gregkh>
 <70f8c6a1-cbb5-4a62-99aa-69b2f06bece2@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70f8c6a1-cbb5-4a62-99aa-69b2f06bece2@linux.dev>
X-Rspamd-Queue-Id: 6C826A000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9mq5sg1xauqcpxgnu8phc56dji61boup
X-HE-Tag: 1761143214-430216
X-HE-Meta: U2FsdGVkX1+f65kRSm/wuW+rLGsJlS7dyxa6ZTLhOwKhV05Qby8XPmsMmSN3uRKhVksxhXo80N9cWfgt6PZUlsaAaQ4wGsencn71g2DMEfQGYxSC7eE5nOYLopzvq2RP0aYyIqeDlaCed5WgEpTNHM5Y8qCj44wZnOAoe+RwrLo4mrkQm41EU8yq2q0d2MkjcvFm2JCc34352oUGPFf2MeUX6rQNHhuxwwjuSA0H7D1hYjgSbQBS+Gjt9Gz0GJUGZHRyNDIYzvncj4oOskvAqfMpNkoDb6Jwar7HieWOnmWdA0Euib5DOL4QGdmP4nUKCqUARMXwqiv/tuUyD51UhcgNlkM+PTYk1JoY2wjDJ3J1O+Yt5XmXNOjHh+JasAWq6nUTuyy3qMahMRAYZ65D9qcRyXg47A9QI9yKlCH7p2oYgAfrPb1nFgtbHmMKgoo0hQbqd0w71OggoNTs8fF95oZqciPtgmSyFKdSngT8JZDQ1lzSgeeTyu+7Mr9y8zlHHxZMxawJ6lg6+ChOCqUDwmBY3p3WFWBKHNrl+Ws6Pt6RkG27TUQvgUUT1PUCWY8AAL3t10BMC8XTumLPMVh/Lq9v92pTHvgsfuuYxCPMy7wrupisesN+Ifnzw6Airk9m43l1th8ScLq+5ppzdkzclLjrNUQ3441VpqqaO3P4KZesYySGWJIZ/S5jCutYU8SX3g3EbnjLkzOzwLYOj7sy4be7C8gJi3uMUQ40eC3VQO8gxGymgCz+jvfTUigqSWNeIo8qu+8p1vVCspp7sm3D3robovkB/GZPzW0OnTdsF12HBoTlNdepbJZ7yaeeuyv/vMd9nPYogXqlC+58EhEpbW2m/blbyT9l2z4aOAF5DAy4dhm99tV9ZtYWFQJALjlook88xNL2h1+6Pp7WGIe/50xiuybH+88NEtvi7HlNMXY2/piOQxr0jxxsnNBoIXXDe0zRPpWEX63s+vs7iCs
 at6wB5MQ
 Q7LN7w63Y/JmtuGfxoQrnsVXWMM5UXyB5WV/sNW9QAV48C4Aacu4MLXXN9njHpEM3fYuKZSCsuDNd87e4KzROyurd1OdMuJvuWsWDknylI/cm7XQhMkwWiboMq/d5oN/QQ3N7Mxr5XReTy3i///4qOkvlgkSOrVbckxP8pReLqJAZytB1VVwlAwR+uEpNb/YQUIPJEuyQNu1QHcphevj/oh8vNriYXgrcAFN5iylS5E+06dSGsCnhorqEUMvEkhO73bXNaxoCRTUiQ8uW4DnCasUlgxdlC19naj6IbJIlDRJsjst9BFZiU4ZooGC4U5BHrVP6kE4IZk1tlOhdY/N/u5/RGTSUg/gSV+34VqwRwaMnyzeYIqa/qHXfhYtx1QOh3hLMXO5vMqW+xuxRWKVCE8lI4+6D9eiv/UbSX51uVOvVIm4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 09:34:52PM +0800, Leon Hwang wrote:
> 
> 
> On 2025/10/22 16:20, Greg KH wrote:
> > On Wed, Oct 22, 2025 at 04:08:45PM +0800, Leon Hwang wrote:
> >>
> >>
> >> On 22/10/25 15:40, Greg KH wrote:
> >>> On Wed, Oct 22, 2025 at 01:51:38PM +0800, Leon Hwang wrote:
> >>>> Fix the build error:
> >>>>
> >>>> map_hugetlb.c: In function 'main':
> >>>> map_hugetlb.c:79:25: warning: implicit declaration of function 'default_huge_page_size' [-Wimplicit-function-declaration]
> >>>>    79 |         hugepage_size = default_huge_page_size();
> >>>>       |                         ^~~~~~~~~~~~~~~~~~~~~~
> >>>> /usr/bin/ld: /tmp/ccYOogvJ.o: in function 'main':
> >>>> map_hugetlb.c:(.text+0x114): undefined reference to 'default_huge_page_size'
> >>>>
> >>>> According to the latest selftests, 'default_huge_page_size' has been
> >>>> moved to 'vm_util.c'. So fix the error by the same way.
> >>>>
> >>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> >>>> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> >>>> ---
> >>>>  tools/testing/selftests/vm/Makefile      |  1 +
> >>>>  tools/testing/selftests/vm/userfaultfd.c | 24 ------------------------
> >>>>  tools/testing/selftests/vm/vm_util.c     | 21 +++++++++++++++++++++
> >>>>  tools/testing/selftests/vm/vm_util.h     |  1 +
> >>>>  4 files changed, 23 insertions(+), 24 deletions(-)
> >>>
> >>>
> >>> What commit id does this fix?  And again, why not just take the original
> >>
> >> Let me check which commit introduced the fix.
> >>
> >>> commits instead?
> >>
> >> I agree that taking the original commits would be preferable.
> >>
> >> However, it might involve quite a few patches to backport, which could
> >> be a bit of work.
> >
> > We can easily take lots of patches, don't worry about the quantity.  But
> > it would be good to figure out what caused this to break here, and not
> > in other branches.
> >
> 
> Hi Greg,
> 
> After checking with 'git blame map_hugetlb.c', the issue was introduced
> by commit a584c7734a4d (“selftests: mm: fix map_hugetlb failure on 64K
> page size systems”), which corresponds to upstream commit 91b80cc5b39f.
> This change appears to have caused the build error in the 6.1.y tree.
> 
> Comparing several stable trees shows the following:
> 
> - 6.0.y: not backported*
> - 6.1.y: backported
> - 6.2.y: not backported*
> - 6.3.y: not backported*
> - 6.4.y: not backported*
> - 6.5.y: not backported*
> - 6.6.y: backported
> - 6.7.y: backported
> 
> Given this, it might be preferable to revert a584c7734a4d in 6.1.y for
> consistency with the other stable trees (6.0.y, 6.2–6.5.y).

Ah, yeah, it looks like this commit was reverted from other stable
releases, as it shows up in the following releases:

	4.19.310 4.19.315 5.4.272 5.4.277 5.10.213 5.10.218 5.15.152 5.15.160 6.1.82 6.6.18 6.7.6

So a revert would be fine, want to submit it?

thanks,

greg k-h

