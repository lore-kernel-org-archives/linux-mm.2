Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B58DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520E96B019E; Thu,  2 Jul 2026 21:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D1146B01AE; Thu,  2 Jul 2026 21:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E6A66B01B3; Thu,  2 Jul 2026 21:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 142966B019E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:23:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6954DC147C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:33:26 +0000 (UTC)
X-FDA: 84944986812.08.DFD96B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BC17940005
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:33:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AiN6AJmx;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783024404;
	b=Bmof89v7lG8FwSSKmT4D4TG7KY0/zU0o51DNSqcAy3p8NsrJeWA29G7k/YGN38/b13KC+4
	e4UOITu9W/FYikg7GDkk2CQA4FenBW9IcOE3mgTLi390vvgPfID+jMdgb0eqJ1zihBNc5W
	DCoTKx9qfV1UaM2aZAmI4cvc9OLPTXM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783024404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1FuIOV38cvMRmE+tzQFc7VuKDySWog66SgpIkMC7W3U=;
	b=fgMG7Ays6DBMQZXkJRQAp8KT+cyl/HfNTj6eX6Y5ZK4KOKrWGMlZwqYofiWIKA9baxDZuy
	8CDYt7fmiCwfgqckTpwptPPMyYHQsoz8ZdzlWUuPbKn2w9U/q2/QHUmLtG/lqkOIWzbc5T
	voSK54URDmItvwGeb6J4EA9YT/JGD1M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AiN6AJmx;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C46A040805;
	Thu,  2 Jul 2026 20:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911B41F000E9;
	Thu,  2 Jul 2026 20:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783024403;
	bh=1FuIOV38cvMRmE+tzQFc7VuKDySWog66SgpIkMC7W3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AiN6AJmxW3/s3cJU8IlsD4RhdhrIDtDb+v5KIm1E04CSrtWCpgSGJwoafB5YmVITl
	 ZMzezNtpvr+c9XC0WhaZ4g+ZGRe6/T3Ii5Uyw0T/CK3eORo9h08gTU7TtwhsSPsdWA
	 cZN6Wi/TPMklpIq+83PyZVUYrRiNMW2CV3OnYQrnTZ3e4gedS+XhkiQLSeqC/rSuSz
	 3K0fUSuQQSJQgNIfzhsbpYvj8FeYyIYIk3rSuFVXB4SUODfvwjaTZpI+lI+tUHvgJO
	 ls6yHIVeuGDGusv73x/wTZcKMXt5qlHE1d4bKjApPqui9KDUCH8W3stFLRsD/MWD27
	 2bCLvbnvz7Lig==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Lian Wang <lianux.mm@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	daichaobing@sangfor.com.cn,
	kunwu.chan@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND RFC PATCH v2 2/5] mm/khugepaged: add damon_collapse_folio_range() for external callers
Date: Thu,  2 Jul 2026 13:32:47 -0700
Message-ID: <20260702203248.92547-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702194353.91778-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qh7fxugsdmxorzi39caroyh3n6jq391f
X-Rspam-User: 
X-Rspamd-Queue-Id: BC17940005
X-Rspamd-Server: rspam05
X-HE-Tag: 1783024404-654236
X-HE-Meta: U2FsdGVkX1+DTkpkFcHu17qgmhbyWvYzh6YCI2tc4ZMfiCg8s6iTGEwK6JrTEqJmA2K6KZCAYxD1V0t3e/v3VmncpIXFG0iPd9QIa0YbBTOqGA7/zeTqyL5wKObv4WQ0EZwREjp42NpBdBNVK+jqEDrthkcNl1kqUqcVKETvbQwMOhOgKnfaUqqIBBT9vJYVOwVDArhDuKZgGsTtT0pvmVjCbyunJSQmcACs7dD5+UWh3dmaeO25Ck1W8+Dz+CaN+oDgJrqmIH4CV1oQCdYmqyQX6HVXZdgZ4LVCJwo6VTalcmoiUBJATZldgnkn3C5GaorDjqB0mQxKeuxjS/2gW0Ilir7cY+2Ff5Y6OCTgVfL8LTSQYy5++T+04PjoehnBvlB0nC774Bm6eN+yP/Ju+MqOEzD34hnFxJoXC9ctqf6MEgUCy+yIoK9g0bEseWhu2///sJAlagxPTm+lZ3YFn85A4TSHJIbbFccEFne7FG4mxaCms8mj/HIaJXjoXn7n3rP9BhMwTR00HXYVI9d0jeUW95cQ0FykJq0zKpUnFF9q1y38IT5QHrVOs64206FEDOmArr7t2GqtZ/NfqBqCn3+OJqU39ZKhQeWBiJaMdWGo3pnaJxdTVeXVTWpMYcbKq0hKrY4KJERNMmUOorI+MbaMIS6eUrV4vzOb/ayAjKopo7eVJ3dbqJhei6lVKyPjdm9NoVIu3LltDyaChYou6H6nINgF+jhgme6BFF+XB5VEcSHLBWU4lgvhXAZ6wvtx6LxDwd/3ALXUCF6Gmfk9d9imc9Xx+qLCgP17Y5SNerGjEYLPRxoQTWc956ZZVmOk2ZFuF0QHaiabwdsvWfsyd1UbAM2pL8NmOJBundywVkbk31FDofzMKQ4+r1UXLKh4bX0u7XuuwxM2sqlgGRC/TZFWMr+8fV3wHpmUIpBm77dzV6MJj1BgBDFVluUvK2zLIflk9j6UOGxyfitndYM
 z8NJ4F7/
 1xdA1SHDqxOaDM+9sKGwaxZ5X6Qx8zCI3/30b7Y1uFBYZE5XVzK8uMTekSjbh4rkZB+vhOzvjWx8ERRjvEjAU0n2NLisjn8iSTDyqyvKjfuAR+rslMxgrVzVHZJ2USOR2M/sFgQSBc5Yqo8XPaTXwgW2XRzIq516CRol1y1DzD463laahY8SEh6KcxZguaVh7f74HKtwbJiFtAVBscEMdsLFuN9PMWbDjqxrZrb6uU8aDE7hxeMW7RkF1IQqu+KKGExTCTXEo0Sw40+xrZvy8oio6SQk9/fykzuqIdwSE7vyDLk6OP4j0OCE5ZeyjD+LlbrM5sqSn3+6kg3Fmy3C3YvcBOO2Q1axBsEg8AYj4SfR2pIM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 02 Jul 2026 12:43:59 -0700 SJ Park <sj@kernel.org> wrote:

> On Thu, 2 Jul 2026 12:07:01 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
> 
> > (+cc missing people again)
> 
> Thank you for adding the recipients, and review, Lorenzo!
> 
> > 
> > Sorry but we're not going to accept anything that exports THP logic like this at
> > all.
> > 
> > And a damon wrapper in core mm code is just a non-starter, so you really need to
> > rethink your approach.
> > 
> > I think SJ already commented on this in your v1 from what I can see? I'd listen
> > to his advice on this :)
> 
> Lorenzo is right.  Not disrupting the world outside of mm/damon/ is the first
> principle of DAMON development.  Sometimes we may have to make some changes
> outside of mm/damon/, but we MUST make it not disruptive, small, and perfectly
> aligned with the developers of the area with respects.

The best option is just not doing this.  And that might be the case.

we already have pmd level DAMOS_COLLAPSE.  I find mTHP-supporting DAMOS_SPLIT
can be implemented without any changes on mm/damon/ external world.  If it is
true and there is no objection at doing that, mTHP collapse may not really
necessary.  That is, the users could collapse in pmd level first, and then
split in desired mTHP level to accomplish their goal.  I think that works for
common use cases, too.

It would be suboptimal to collapse in pmd level first and then split.  But the
efficiency is unclear.  I don't want to disrupt others for unclear gains.  We
can upstream split part first, measure the efficiency, and revisit mTHP
collapse if it turns out to be really needed.

What do you think, Lian?


Thanks,
SJ

[...]

