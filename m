Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD5B5C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8A96B00CB; Mon, 21 Sep 2026 12:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCFA56B00CC; Mon, 21 Sep 2026 12:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0DC76B00CD; Mon, 21 Sep 2026 12:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 862336B00CB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:26:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18391C0211
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:26:28 +0000 (UTC)
X-FDA: 85238297256.18.0E08478
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7F9C21C0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:26:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KMpEFx7n;
	spf=pass (imf20.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790007986;
	b=SOBCFwLCG/jDdeptmMH9rNkzWFR99L/kpWaGRVbcLHFVVg4wD0gE3/NUW/zxV2Z4+I/IFX
	rVnRjOChLQhPdcfhtWSxr868Fz+E9wbaXEHolZ/BD108FmINZOTcfmiKTeqyS4D4eXvPH5
	XlqAg+vpbLl2HPTOZGkgPqbDYhYiGk0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KMpEFx7n;
	spf=pass (imf20.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790007986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zH3Q2mREGvyLKe944og/4X+d0yEqBXd09yVjVV2YKqU=;
	b=EmO1yd7KCgJnFBKDrzJK8yKuBmi20bEsb5rnMspYhjWlWM3xpfd9fx3PzCW6gATU4atV4A
	vfwiPnhMHBt6X4UThH+5Eaw6Fa5z+qdhhkRPmSDXdpzKGLoIk2ZTUBBCVA9aDWYGcm2WUt
	o+SYpbRjY1R3qAIv62tdZjiYSBgZ1Dk=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d3b445a84fso144795ad.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790007985; x=1790612785; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zH3Q2mREGvyLKe944og/4X+d0yEqBXd09yVjVV2YKqU=;
        b=KMpEFx7nZXne9Gt0fjD44Vxg6GJTnUp8/EZJ7if5eq8a++sUwdcmAnjuJ9den39Sic
         a4Wtvm9uCkL9WqaLcrwOdCocnv4oMP/8PvwXyWt4WWhRmR/YZ7LWXco5+6+9TY/u04Gz
         dmMy4gbfSK80CBN2oaLZadGA1nzzQqvKyza25KXOR1IgJQBUrLbLfqYWnWVgaOFa5/7f
         Wlif470Ov4Leqdegmg0OlVpLBxZMss9mV0HnlHYh8jCKWNHgff+gw5tQRPJAFT7mroZO
         GFrGXQtCd0MXCYU84rNrjZrSADP6JyFL5A6ILiUzJB2XYW74bI+afYwDl/QKm2FO9xIE
         gzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790007985; x=1790612785;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zH3Q2mREGvyLKe944og/4X+d0yEqBXd09yVjVV2YKqU=;
        b=J7PctQg/hPwf0aH8aZvfijjDf2NQicbJxH0H6DNj1ZGJHi+RVip8bM+o6jq+sv7VIU
         pQoAcIb0wY4chfP8j/UfkLRkSQ58SCt9Q3VHmDvx5VhDLVhEeKQVLwACGq8jxIfxDRCC
         D2m4NQqoEqAnGelnvuHRGYkTLEG4/wec3cjW2ikDvGmie+Tb4bXVJXHI1oIZe99+Sfoy
         lNjqvjpIcHq6L7lnEk6G+0hYqPHhkp+LhTw9/Pzuz3iE1dG6rUJcafuaN9eN1zlLIF1n
         C1nWUNFe+IztLJKr2WPJKCdpnftsDTtjBDBOkBnlZMSgPQIKpBcye/KJVXBhwNz55xKJ
         7elQ==
X-Gm-Message-State: AFuF++kVT8b7OIIAjf3WsF26w7n78SP/iq/AsGLs0mrV0aHP+HnLGCIH
	Cr5z4CTL6/VZaQuvHXnkGadmTTEUQIsTLpbHMTyVU3HG3IgVdURxQ8Lm93/oYiaHFQ==
X-Gm-Gg: AYBFou02abgx4amSnQxSaKU2537HKynFVRPWs0LJ+cm7EwVi/35vgERc24I5r1EBDIN
	A0McCq6ZuSjSCKnzjcfP82GwaGMcwGrDYMZLdgUT4O39DJoQ29+CF9SFjRtn0qVJqlyj6fCIhoH
	GX1Up+GI0onSuus0ZvNNLtAsn/oieKVgO1YkkjrO+ZYPU2f8ni5DOqYTEVpYD3jKPpjvXs7+3Rk
	3R3z59Wr9wgHeTK502EPlB3wM5w79kpR+DOFw6SQCMBwhz2TZtqM1npMEQOedLdJ1dC35a8fbKF
	syZyZQ8htbgYQPc9D0RTpEIeL48aV/wnlvwDl/lPqJGm5c65sKSl9ogayQHKNiMcRRvt/5OcoTT
	Z4GqdMN4pjU1yMC0wy2lyZXVefG9xC8fpvpxf9IKLHPxQmu2hEGlWJzknaEPOeb6QWMeD2dR5gG
	zQpzU5AwIsVhbbrw8u9W80/ifgO4nx3SPXSPV33Ab0di79BRCm6Li9zfIlA+IPbPyx/Fi4qCTpG
	yVeTGltaGLU3VMbhgssEY3aLTKgkDi13uD1ul2GDkm5iE8g0XflQiBEQL1Y46/JKpFcUBuzMpN5
	e95V85A8ZLBJgSyj2FDH3goWdEFwn52tTPN/70B6BjOowNrMUsbJtX9LtCmJnFZR9rCkA4XBAPn
	3+axybzbELNf56+pbhA==
X-Received: by 2002:a17:903:388b:b0:2c7:a13a:7fe6 with SMTP id d9443c01a7336-2ddc170537emr12714425ad.10.1790007984357;
        Mon, 21 Sep 2026 09:26:24 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:1c14:1756:9246:e839] ([2a00:79e0:2eb4:9:1c14:1756:9246:e839])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc17d7120sm37683065ad.63.2026.09.21.09.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 09:26:23 -0700 (PDT)
Date: Mon, 21 Sep 2026 09:26:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Amit Shah <amit@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
    Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>, 
    Christoph Lameter <christoph@gentwo.org>, 
    Dave Hansen <dave.hansen@intel.com>, David Hildenbrand <david@kernel.org>, 
    Davidlohr Bueso <dave@stgolabs.net>, Hugh Dickins <hughd@google.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
    Kirill Shutemov <k.shutemov@gmail.com>, 
    Matthew Wilcox <willy@infradead.org>, Mel Gorman <mel.gorman@gmail.com>, 
    Michal Hocko <mhocko@suse.com>, Mike Rapoport <mike.rapoport@gmail.com>, 
    Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Shakeel Butt <shakeel.butt@linux.dev>, Shivank Garg <shivankg@amd.com>, 
    Sterling Alexander <stalexan@redhat.com>, 
    Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
    Vlastimil Babka <vbabka@kernel.org>, Yang Shi <shy828301@gmail.com>, 
    Zi Yan <ziy@nvidia.com>, William Roche <william.roche@oracle.com>, 
    linmiaohe@huawei.com, ljs@kernel.org, osalvador@kernel.org, 
    harry.yoo@oracle.com, nao.horiguchi@gmail.com, tony.luck@intel.com, 
    wangkefeng.wang@huawei.com, jane.chu@oracle.com, muchun.song@linux.dev, 
    liam@infradead.org, shuah@kernel.org, boudewijn@delta-utec.com
cc: linux-mm@kvack.org
Subject: [Invitation] Linux MM Alignment Session on Hwpoison on Wednesday
Message-ID: <45af1b22-49d4-5d60-e7ad-14a1a33c8dc9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7F9C21C0005
X-Rspam-User: 
X-Stat-Signature: ipor6k3zmjxe19w4q6rq457rzsu7x4t5
X-HE-Tag: 1790007986-976073
X-HE-Meta: U2FsdGVkX1/O9fPMG7GF1YV3EVAxpUReonDqHELJlc5kFVa1KyNXUCemNAIgKC9dkTFKUBRrwk6JD3GmONa64LXuUycg9NynQGmBQ0hZjNjaiRsjT8pDAztBRJZgSU/kSnfPsH5vk4FK9r1K5yOSyOGf673TiYg7tVWz2qIB50wl8vNldP1L+kJN4k8UK7SOdtqTEDuIvqm9G+5xAxoltnpLisJNsxsTAA9Qi+NaVaIjSYQ8GjICxiDCj5CDhjminzLB7S/hTU35KXAOuXfNYBY/Jhj98m5haKXURc/Uupe/rMKovaAl6EmAQVvbhLNfslN22L+q0HlYq5R5giUijxM1BtyuF5rCayeoOLnfCA6uKRyHQnAPNX+h46GlOfkQAn02e+U1/5K2DGr1Yk/T9c4sxalayxlZbYYKnJq7ViZ340KfPPLyZ1YV+FzErf3r8K3wxXzUcu1cSlUU7VUeUKJXLbQ91O6T8KGyriMEOzMeTCCCKwD1AwtUVcGdF87fl2qqCdfuANsRaugoFzYDlUFcC7tlGGOkUzbMjEa0GXoiH+M4t2FkqlnnZGXBOGFsnmzWqDOcBmbTkm91uotM5Z4f34Xg/FRGVHojsKuw0N7U3LPsRpcvKySvgram9xVK+8Jd3RGEKjxBLAUsP/7peQWn+8OXAsrQWQlaQqpy7bojfhZAmH51eIkhIHDWl1EM+sbmX/jaiKgHzPjKxz1R+cQ6E7FIhqDjYxp+KmMt2f5qyU5zCIPRVLHSJeZdKcFI4Y2rCxT9E++FZcN9SjfpXyX+cpLPqXIDYByE+i3ZFi/laTBa9HVyr0rqX9LClYz8F4j5llsOHMX4FXwH8oJZBnmWHEt8Zkce7eAS2js8zf8MD0U5DLj+DAOufipbQP+wMyqCqVOSyTvEShp80zZd7iT6slhO1flqaLDYG+b2LnBxW9RCHOEWSni+PlT26syBlwQiChTM2DYYuF2+RXS
 bVg4ykbv
 9XLvoL8pQByy+7OP4igZlqvy7Rl27DzPD8Am4hFJn5l29pra4SF7NEjVoK46aNz3h/WCGorx9Xur563vsp3oMcK0mcBbldk3l1an+2b3ZpHcmsKJpqtViR25IilPxPu348662ZPqjEsgw/4WwZuPYU5+9hHIgDmwiB0/COvu+oGb6AvY/yWxD+jJKrQNEaN1TNafXT0d0HHqgARw7a3uxQB1Yfgmebkr7nYah9tKsmTTVOCFRcAJ7g2o2Kq8pPXyOAHQgfF8pY32ImYvnhoqKwf2GcNGGjawX8lN2mCQbaPXQ8cV+HBf4uSWqiP1eQCD64Z76gsLdPpVSzKsXP6xd6DlPF9qcVW7uNCQ275uM2GdfoE3liZ+NxfbTFWak5PFsQpx42ze2VuYW4mY0clp4OViKr29RKeW5cLch0mRUzR5RJM8HO5ljB8qOxln1VrNbxH1+tPFkDAjG0BzZitIDaI6Gsng6pagPQW4hbMGtFLwnz0S26ky/MkXbhbqf+rD8/17EsoqfkrF8U6XXqUeElPsc9tFjbG8ZhcwHe634O/osmD8jslzPIS174v1WyHri6Y0WKriQbjw/TfCH0EWaIEExk0/WJw0zZ2Th
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

We host a biweekly series, the Linux MM Alignment Session, on Wednesdays.
We'd like to invite MM developers to attend and will announce the topic
for the next instance on the Monday prior to the next meeting.

Our next Linux MM Alignment Session is scheduled for Wednesday.  The
details:

Wednesday, September 23 * 9:00 - 10:00am PDT (UTC-7)
https://meet.google.com/csb-wcds-xya
backup: https://tel.meet/csb-wcds-xya?pin=1301132214803
doc:
https://docs.google.com/document/d/1QQfZFPHa-pGEGf4A06cSqS0jdJwuZ8ro9JU5H0YSUQ0/view

This week's topic will be Hwpoison, see the discussion in 
https://marc.info/?l=linux-kernel&m=178796007385067&w=2

No specific agenda other than to gather core MM developers with hwpoison
developers and discuss:
 - where validation should live, esp with regard to the page allocator, or
   strict invariants in the page allocator
   + implications for the fastpath
 - handling for folios of arbitary orders
 - handling partial folio poisoning and split failures
 - race conditions between memory_failure() and concurrent
   alloc/free/compaction
 - soft offline for pages in the pcp lists

We might even want to be bold and discuss a holistic design overhaul if
it's warranted.

If anybody has ideas for future topics, please let me know and I'll try to 
organize them.  We'd love to have volunteers to lead future topics as well 
as requests for MM topics to be presented.

Looking forward to seeing all of you on Wednesday!

Time zones

PDT (UTC-7)		9:00am
MDT (UTC-6)		10:00am
CDT (UTC-5)		11:00am
EDT (UTC-4)		12:00pm
Rio de Janeiro (UTC-3)	1:00pm
London (UTC+1)		5:00pm
Berlin (UTC+2)		6:00pm
Moscow (UTC+3)		7:00pm
Dubai (UTC+4)		8:00pm
Mumbai (UTC+5:30)	9:30pm
Singapore (UTC+8)	12:00am Thursday
Beijing (UTC+8)		12:00am Thursday
Tokyo (UTC+9)		1:00am Thursday
Sydney (UTC+10)		2:00am Thursday
Auckland (UTC+12)	4:00am Thursday

