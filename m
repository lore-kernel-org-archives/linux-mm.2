Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5976E81A44
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 16:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178FF6B0088; Mon, 16 Feb 2026 11:54:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FCE76B0089; Mon, 16 Feb 2026 11:54:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21086B008A; Mon, 16 Feb 2026 11:54:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D95C56B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:54:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1E8F5D5E8
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:54:11 +0000 (UTC)
X-FDA: 84450917502.14.D3E440C
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7F91B18000E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:54:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=gLh+ibj2;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="l KisXEY";
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771260849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgcVi/rFDf4TxsQzdelMFD7oqZc+4jLKnia57UoynYg=;
	b=lpYgAl7PcngA1PEKSZqLhrsSCFC/RUZMxkY1afo0fTrKdPXM8H9HrpEun9QG+/4Z55ibg2
	6gH86nLZvw/mOcYcC2LI6o/VQRGkeiYjWRlOsHhIO1XAtFtDao5thTwquVgCKIsG+Gl6x6
	T2EM3SFmeFDY1Qlbq4MI7btfzQFTuM8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=gLh+ibj2;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="l KisXEY";
	spf=pass (imf24.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771260849; a=rsa-sha256;
	cv=none;
	b=sDZ7NCtTVFjhQrojQkxH50BQJlJ4yaPACT2Kj8ycsEUbOFKH9ZiOepfh3GhYq4ms67dr0Q
	iC0vWDpkNcBZ0XeP+Nq16Ejfr2gac57zz02Yg1QVS67+FUui9N7IsAT109xmiSzE11hIxX
	Gbm7w8eIycpgNPSYqGDLc+Uc88aWb5g=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id D7B4E1301155;
	Mon, 16 Feb 2026 11:54:07 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 16 Feb 2026 11:54:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1771260847; x=1771268047; bh=lgcVi/rFDf4TxsQzdelMFD7oqZc+4jLK
	nia57UoynYg=; b=gLh+ibj2a/9XhKLVwXuz0MYjgX1nwswsHVM0iGyARSCdYavE
	ehBnyPJPx72THvXREempnZYxbPx/xyu+tP+1hXHqGJWvkA2ebJVRpQETf3X9T5He
	YP41xSRq9ZekvhGOqXEdYbTLdeBFNFWg3qeKsWPfKvYafqe2J2RKKN4SR5ENM4Ls
	SW1KVXcNIp7AsZ/Ic0gw9KmGLFlxtUd59S6pPJcJVPSSUkG4xFoDuCE1z5hB/36Z
	3K6R/E9H6NczxIkeqQw6YXUaV5uODmEODhpFTZaH1jyBhfSefm2q1pCPtxcuChTl
	B6cH1vFvi/vbaxrPyqieOy0dxornv7TQ0GiKbg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1771260847; x=
	1771268047; bh=lgcVi/rFDf4TxsQzdelMFD7oqZc+4jLKnia57UoynYg=; b=l
	KisXEYnSRuXGKov/hsqgcdwWXakp1g+cq1/Pr/hiGMPZ88l7Sz7rEUL4jxuSu+8f
	PfnfVqs4mrguzhTFjKPRolIfvzQSaw5Ge2/Z2TZTTb2bjH8UryIBPLPk4N/RfmG6
	yzm7pacBmUXgJd6pqYisl+ehDmW3TQBSI7F8m/1mOOHvat1VahckduLeKzI3U5vz
	DrXAfT+I1HQCwd5hqyqOk0U35b3sFBsOOtxtKagx9KNSCm01gCIA+TFZRNZu7Wkt
	gv0HQzSCWYOmUXUH5i1YNgjZwNrqODAfquOqWX7D+bUuIzoqMD/LKYr0a79d/C+c
	e40rTf35EaVYvE4LyucMA==
X-ME-Sender: <xms:r0uTaU_8YM0z2UYGIuxW1AKxeXnjEE4xR-vGBwCQIzv-maF7DHrw4Q>
    <xme:r0uTaeAYoE2nqTuvRGmWNLHoqklu9ce47sNEqHFbSexYAe_SnxKRdTHcOmxt0TZwe
    6jrVGcoMRo5KMolGPMV-_YTlmtXmOmbKChHgs4b6XdfYphb0koYRGS9>
X-ME-Received: <xmr:r0uTaerbMq1lqvUaABkHeJ-Rh5Rm2EzURooqBC8gY8PIvOB91kI06DYegDHK-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudejgedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenuc
    ggtffrrghtthgvrhhnpeeltdefvedvteeuuefhvdeutdetheefueethefgheegteeihfev
    jefgvddujeeileenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohep
    vddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehhrghofigvnhgthhgrohdvvd
    esghhmrghilhdrtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtg
    hpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghp
    thhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhope
    hvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopehrphhptheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhope
    hmhhhotghkohesshhushgvrdgtohhm
X-ME-Proxy: <xmx:r0uTaXKGr8J6RD6Ue4xmAItbdq6nMjuJA2fJ70FuJv1nvxAkQGDafw>
    <xmx:r0uTaQJIxKq8xlQJEWVeqvXW4qh1mjSj4i4LNON-AwN1Hvkl5KXypw>
    <xmx:r0uTaQk8iUe8h6MQ9jVrLnERgZGbTd8P4TM_NOMhITNAIF4iUrRldg>
    <xmx:r0uTaWLpaLySDWmo00_LfTZt3sNy1rBfjxQeuDdnSxMoLdwZeTxvXA>
    <xmx:r0uTaeWM8nQLpXkQFNwyQMiY2avbSopPfogOhlrPrsWuOKHABgkfElUa>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Feb 2026 11:54:06 -0500 (EST)
Date: Mon, 16 Feb 2026 16:54:05 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
Message-ID: <aZNJZTiRt_vm7oKq@thinkstation>
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <aZMAVF1S1kP5Gny_@thinkstation>
 <ddb0d3f8-a617-49a2-8fb1-e6293f376030@kernel.org>
 <aZMEvl7WUKyxmgIh@thinkstation>
 <CAOptpSNMx7moZnLP1Q9xX_6zw2xJL4OV4N=f8rzyZBLuTMEJnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOptpSNMx7moZnLP1Q9xX_6zw2xJL4OV4N=f8rzyZBLuTMEJnQ@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F91B18000E
X-Stat-Signature: 1p4xuthkznyor6r6xr85dozdiudd9qai
X-Rspam-User: 
X-HE-Tag: 1771260849-589014
X-HE-Meta: U2FsdGVkX1/IK0jI8VBqgQGab1TKUrlPgtaXpimTDYi0W8V4NBjQOwgflWN6Y9ohADzJk3Yu2oXMMVzjOlLqGGE1G3+NFSDIXn/uldpaeiJK7Z2unhCdT06W2JSXduMThiOLm+AfhLy4rC36wf1Anj7d7pWcWJVqUDHaEE3IZi2qqSzTTR88BN6P0S5LRov6mtaH1/FSK0XqEJA8ZCpmSbgxF6Iv3NiCYWTIr/FnOG7Y7xVyejjVyMJ6ow4FdMvPA30bcLcl6EswCr88F1hrCvbMvxcld4zmHeaM4CtvmGwxiLKNLWHTT5/dqUCGt2i++3eD7VCTR0qxIaZDxB2H5sZh7qxUbwowL6DuYJnu+8plWhVqAIaoxpqVNoaREz0gMHkX4J3OmtQMvE21fA/U0hay4LOeGlb8nw4+I5hlrHV7dyk3NjTyqPtDNF0wVfGaRmNeNBYHkM/F1bOKJohiTflQvyz0Pzbfq7G4d/CxXSnHEOouLK90XS83ayt6Hj5xGNGjjSUDJgGjo/4itobFovTnTcXb/kJoYLKzMIvB6ryJ/kP7Iw7n7B6KsOklRUM2nlYFy1ctb3gLQCGIe+uB01DzGqH6chsGwVYDDtT+03AQ3W+QDeOQiW90CbNwyv9Ult7uLaegR7nrufgbkESjcPdemHb5Qt23hg1tY9z1920MqFOccaLVMUwNkWgBS13wNZ0ByAMjCCKs/OEta4ZbpxgqoRQVsoU/6Yt6JKcHdxKQibiW6nsTNEP+RfNLy21maRo52r0DsQrjzYmqTi9jrVFHSURPc4hfWZ9i1UQH9G98HTE7Pp/tc7eN6RkK0t8AwzZxq3VWWQkvORlQZJTbPwRZa0+O8U7LCxqUR2hou6ore5hWerKBd6WQQPj6XjQNIgpxVWoMuYyILMKC78LnriSBF6T4Er1eNkAiI5MoDt7Zw1qGA+9tth6h5NCIOQpVzWmtG2m7f45//ntYOtU
 2XgcxiEV
 bWJPuSLrAWuNLUYJ1jxNU4lbAowfz3P4Qypjagph2mG3RZ09hTu6qKN+qHSOYus+fvHnBJK0uWQo1ae5yr/j5GCQUJHp8dS+ku6FkMzIfYbfcbCFCAmVgmS6imTkIgKKHrdiZrI6CnlQS8Wj7vleM8JSoj+mnCo904agY3UrA/+TPx0+2Z6DOrq7j+BV3JIghfwugDx8s28MCazSWkLm6257RTJzweiKQ5OghD+ASX2SS5o4yalhIsRtI2+n0LuonWymPSmofcNVydKjej2uuCBXnIroCmjsKRhyZW54VNzfkYvv+nwwnNcrDzzCUpHP8iRPfbgbLlZVOgX+q40lL5QLCudjgop8dn4qZ9RiwCkonS/lekdfM+GjbFi4qW6wk6ZWDgkIo2zRxh2zKwQgWH7Z506BbTV2lFtVXJ3+2WmNJVN3cxPWM0aL3XxhbeB4mBN351qPMHLsh3SV5iHpo4l/DaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 11:59:50PM +0800, Wenchao Hao wrote:
> On Mon, Feb 16, 2026 at 7:58 PM Kiryl Shutsemau <kirill@shutemov.name> wrote:
> >
> > On Mon, Feb 16, 2026 at 12:45:13PM +0100, David Hildenbrand (Arm) wrote:
> > > On 2/16/26 12:34, Kiryl Shutsemau wrote:
> > > > On Sat, Feb 14, 2026 at 04:45:14PM +0800, Wenchao Hao wrote:
> > > > > Add kernel command line option "count_zero_page" to track anonymous pages
> > > > > have been allocated and mapped to userspace but zero-filled.
> > > > >
> > > > > This feature is mainly used to debug large folio mechanism, which
> > > > > pre-allocates and map more pages than actually needed, leading to memory
> > > > > waste from unaccessed pages.
> > > > >
> > > > > Export the result in /proc/pid/smaps as "AnonZero" field.
> > > >
> > > > I expect it to slowdown /proc/pid/smaps read substantially. I don't
> > > > think this line in smaps worth it.
> > > >
> > >
> > > That's why it's enabled through a command line parameter.
> >
> > One users want the stat and all users on the machine pay the price?
> > That's a poor trade off.
> >
> > In general, smaps scales poorly. It collects a lot of stats and most of
> > them are ignored by user. We need something like statx(2) where user can
> > declare what he is interested in, so kernel won't waste cycles.
> >
> 
> I initially considered two approaches:
> 
> First, exposing the needed information via smaps. This does incur some
> performance cost but is the simplest to implement. The new feature can be
> dynamically toggled via a command-line parameter. When disabled, the
> overhead is negligible—only a minor if check, which is insignificant compared
> to the full smaps cost.
> 
> Second, adding a new system call or extending madvise with a new command
> like MADV_GET_ZEROANON. Userspace tools can then use it to measure
> memory waste from zero-filled anonymous huge pages.
> 
> This is slightly more complex but minimizes system impact: environments that
> don’t care about zero-filled anonymous pages pay zero overhead when the
> command is not used.
> 
> The exact implementation approach can be discussed after we confirm whether
> the upstream kernel needs this debugging feature.

What I would like to see in the kernel is a syscall that return the
memory stats in binary form. Something like

size_t memstat(int pidfd, struct memstat memstatbuf[], size_t n,
		unsigned long flags, unsigned long start, unsigned long end);

The syscall will fill up to n memstatbufs, one per-VMA. What exactly
filled there defined by flags. The return value is how many memstatbuf
is populated. The caller can call it multiple times to walk address
space it is interested in.

We also can have a flag that mirrors smaps_rollup behaviour and collect
all the data into a single memstatbuf.

Internally, the kernel can use the infrastructure built for this syscall
to provide /proc/<PID>/{maps,smaps,smaps_rollup}. This way we will not
duplicate the code.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

