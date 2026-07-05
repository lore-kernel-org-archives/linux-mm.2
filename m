Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F40C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 18:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F416B009E; Sun,  5 Jul 2026 14:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24FAB6B00A0; Sun,  5 Jul 2026 14:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165B26B00A1; Sun,  5 Jul 2026 14:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCD726B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:06:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 652DFA0182
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:06:53 +0000 (UTC)
X-FDA: 84955503906.10.710492F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7A2DB1C0003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:06:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="FrlFD/6u";
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783274811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnBHeOa2oVuO4jBRzty1pOjyZUlumlxkSr7f+Vy6VGw=;
	b=Syq8gBSJG5vck2QlQO6soPe6DXpSBZctBH6j0EzjgDmTrLDdF7NsjgEr7XOTZ2xPUDz/7B
	W5cVOHRMkKjZyOVT2/ss25qfXLXO73olstkLWjhd4z0HCkrXTtQGm6PU9HSGxUtAxg5Kr8
	UwbbOr5eoSdD772PEyVtZWjkGNnU/hw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="FrlFD/6u";
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783274811;
	b=fPZzk8ZEzug6B/amyguSP5koVnIYLKaclWzmsE5i3v8GtitnW9sSH5pjCrJYy8+ZcdVnHj
	0tBE4+JUP/64qvoDiEJMcLcMTZwR3NY0jxx05nzoTxFkiKd9ot/FQOpzKVZy1sJsSgaAKB
	xgRMvUlR8QSHrlHfwWmxyI1fnFjXh6Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 79E8260018;
	Sun,  5 Jul 2026 18:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E461F000E9;
	Sun,  5 Jul 2026 18:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783274810;
	bh=TnBHeOa2oVuO4jBRzty1pOjyZUlumlxkSr7f+Vy6VGw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FrlFD/6uFzd+WyOUFjPLviDQHunz6k5lN31su0IbN+E5iIpfhjbhW3mLexSzThiBy
	 H7rpiWp2v30ss1ayIT096OB+sik9Vims6OZ80m3uI9vfEFN5hYdyI4N/kRm6aCYHIp
	 C64Jy7Y8O1zFhVcDv50m2F+jFdeZrKmdLK2gKtVw=
Date: Sun, 5 Jul 2026 11:06:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)"
 <david@kernel.org>, Gregory Price <gourry@gourry.net>, Zi Yan
 <ziy@nvidia.com>, Pankaj Gupta <pankaj.gupta@amd.com>, Jason Wang
 <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio
 =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexander
 Duyck <alexander.h.duyck@linux.intel.com>, virtualization@lists.linux.dev,
 linux-mm@kvack.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v3] mm: page_reporting: allow driver to set batch
 capacity
Message-Id: <20260705110649.bd30f742c78801a76137c53b@linux-foundation.org>
In-Reply-To: <20260705050445-mutt-send-email-mst@kernel.org>
References: <444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com>
	<20260705011635.9974cac7f0defec9961e85c4@linux-foundation.org>
	<20260705042313-mutt-send-email-mst@kernel.org>
	<20260705013956.36f649b5cb13409d9088838a@linux-foundation.org>
	<20260705044139-mutt-send-email-mst@kernel.org>
	<20260705015116.bdf3335e9a955f057a6d9c5d@linux-foundation.org>
	<20260705050445-mutt-send-email-mst@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A2DB1C0003
X-Stat-Signature: hodx1gwuror1ra41fg89gu9e4wr14osw
X-HE-Tag: 1783274811-562214
X-HE-Meta: U2FsdGVkX19IsThvaJdaweoszlAeIBRPhnWjKaCCOCDhihbCVZU9BMX5NaQzoBgKIKLdpzWxz9ItWwN2zhImTG8eiE1CPftSBfAZLyNCu/xUPhLmxHaIihu62JqSxE/FQl2K0qi0fRVrS1W9WXtbShqfYlJ2IKkg/jNeDXT5qiHf1HDwxNmf/d+o9F7cJ0P9QRa+eySX6Xoagt9fWRdgEViFxKYloLhOzCjz/wAo0jv2R0TcEjD+v5uF9n0S4jPgSfQoq4lhvSL/OxBrz3sV+xOZ2RZuLQ3YdE4MCDAo3f7ltXP/Cqo2FeOSZk0TijBjtHyDw9DVhOShcXhzzaH0KSbPScQSCUD9u7wtBGYQkQsYM0y90wiR2wBdS498qemauAD+dKv0gnpHRVPlZM6nf8R9unZEz/U9iAfvuENOeFJoE+Pe+VFpVHWOObY04XxQXW0rAGayBGeKZKJtwA4xk4lBzddKoRCSMq14c2k4PcDL3Vj8ZyIXLKgYn3sa2StKEZ2/ZRhSNmv6WNTe0LPpBeqW6J403r054qh1xSr3u7CN0qhn//BaWV/aSnjvWIFQUfRrkTeFgfjtuAZynEZUfTNZpKmUOZhaksccMqnQRpHOeMkSxGo/bCBne4bXpR7QepTaJKw7X15X+3y48uMdGP+4iTJh4IVe3WWxuXm3rOk9vEatJU0gIRe2R5Am7CjRjEx+nUVMs61HBm9V8KHbTp9aqhuQ2nP/J7gzbfT4p9lI1TAKcO3T5Z6PGmFbSjL79EdPjUkF0CPwKBFXKPz3XHzChNrNz+XMpAaFL9YLIQHDuh+cDxv+sf0WmwGsIUZ+vSEee5RLEagV1StSsyCLxg1QJ/PG5wM7dDDVFn3J6T3tpsiQuL+yru77bdjlH7vVCeJojby9RQbkt4+OqPBJT/4ki3oPTmyXvcSvWomFEKQtm+2WRGi7brG6jcmdph/2mtn4sXNVO19xzmBQLvr
 K5Ie30JP
 NNsxaeaqCeeEENayq0L2/mSb2AU0vgQX2I38PFEGIA0z4qN7qyMCXAi8aUrNK8/Aim89H5otPVsBQTxm43HNPFkdAJRsqDgZo5mMYmrkKTl+KSYyHipLVGtoAY1hNRlCjUR7owmyLeAht3ZX+3CAmNtaRisiB3fk1345HpWO3d4Obu7ypHBzSUrw+lBRMbtV3pGAnphEL18j5zq1/2V+AaN1EJvor2n4OsAatfQLCAKsSeyei6VQVzNxyp5c1rBpBNbmw1OPsHkmUXqLOrde7FqAU2OIC1uKfzAiXzN3eHTcCv9WVX9d6D34X6NeOhcvqTgjr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 5 Jul 2026 05:06:27 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:

> > -stable maintainers have been asked not to do that - only backport
> > patches which have an explicit cc:stable.
> 
> Out of curiousity, is this specific to -mm?

Not sure.  I have vague memories of being told "we added MM to the
list", but perhaps I made that up.

Sasha, it MM the only subsystem which requires explicit cc:stable
for patches to be backported?

Thanks.

