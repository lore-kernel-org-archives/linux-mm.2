Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23800D47CAA
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 00:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F706B0095; Thu, 15 Jan 2026 19:00:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809B76B0096; Thu, 15 Jan 2026 19:00:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736616B0098; Thu, 15 Jan 2026 19:00:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62B9B6B0095
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:00:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A69F1A04BA
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:00:16 +0000 (UTC)
X-FDA: 84335869632.17.8F7175E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8663914000B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:00:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AKrPb8qY;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768521614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLxOPoNZbVhb+vRNC7irrXeYXKtYaIXi9QgiQJXGT/s=;
	b=tf+LVzeImsSH86dvQkqZa0wC3bFyUbBxJjYpXI5EMpJ7XMlEcHlteULpLsIjzGGkLvBSZF
	TFK0D8Y7sW0UfOGmnlp0LX9DTysCr/IDF6qOBa9ON67F/bo+KIgTezBNVhFRY9POQ+EzTW
	KxYeXsb3ddmQZoK0YD8ydpyqMePsfqY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AKrPb8qY;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768521614; a=rsa-sha256;
	cv=none;
	b=U+3eOsoCq1TKqhoMeelU7WmUsWOLUBJZVSlgkhZ/B/PmEsX9O5cKS5HBGcO0UCkNMmUgU7
	CGOLrpA5Ld7BH6iGJg7b3TRJqYj7zrkEAk0UySAGR0UoTDOwetKgwuxJdLwbor0yixL18Q
	ONZuiNwK1kK2y0a93yjJ9qNJesHqMnA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19DD843E9F;
	Fri, 16 Jan 2026 00:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEC7C116D0;
	Fri, 16 Jan 2026 00:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768521613;
	bh=zld3AdtUOIHhx3f8LkbO7KV0NONlEXy9qHMcSpdYqO0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AKrPb8qYK/xcbXFwX1jqFte9UFIUe7ItN3F820LjpAnZcPr4OhV1l+frX+3Fmrg7T
	 M/E0SplVJYcCG28K4uWynEPDmff+4lrdO0RzdcQERONJsKRGOxxEOYrCCPOFf8WdUU
	 X430A6O+GdXvOHEnNaip3Z88ofPFmB23pnBaGf9g=
Date: Thu, 15 Jan 2026 16:00:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bing Jiao <bingjiao@google.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng
 <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 muchun.song@linux.dev, roman.gushchin@linux.dev, tj@kernel.org,
 longman@redhat.com, chenridong@huaweicloud.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v9 0/2] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-Id: <20260115160011.29dca1c262ab1fb887857508@linux-foundation.org>
In-Reply-To: <20260114205305.2869796-1-bingjiao@google.com>
References: <20260114070053.2446770-1-bingjiao@google.com>
	<20260114205305.2869796-1-bingjiao@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8663914000B
X-Stat-Signature: hr88i89zsft9cpkrpurdb4e7msedq4fu
X-HE-Tag: 1768521614-706518
X-HE-Meta: U2FsdGVkX18DSnNifz5BUe8sBCiSRN45ahJXPkCWUoxzgSoXukT2HCzZaqkrbRXh0NuOeTu5XVttAG7iwmUTadeD6Ob4CY3RfDxCHJnEwKZYeyKugyPFdPannuLIZ2NzPR85epLLVpBMMOJETcb1/QkKGXKUfeMkMj8rX8J52R53vBU8SgwZ6ZXqTGqKaVEVweLS8+uS6aZae5MFPUSzdcnwNNDi9VzaOJdOD5EheaabbIdbnDgeJ2LOI7H1/v1P1VQPDNz0tHvGPSDdPvknOu3NSjaOs132QJu6up3P6wYY8lPvWQt4m0yNy03sbP20x5CWpKjApnHTyqMjlCAgRL132e1jS9rdw075rxxqeHhxkqHNKRXKsKkOLW3MA7O8iU1T8gMMzcf0sbtz8CO9zv3VUV+MO1oQoyVM69hq6onnm9MgwQL9wfQLh40T5bVIv6xkaIOs68ap5bYr2Am7qxE6u05eKTdcbRPlR+OzrsRPOnA85v1KiWgVPSXep57LpMfybhmwfNe8EWIL8YMC8+4KhE8cmMnYOZPDpNIpnGj5zQmnqCvcodXf+A26tixhxvSbxELBRGF7asi15q1w/O7Ab/eZX5YKhqDqm8hENQz1FAl9MdjZPov4LfMiHE4TeGXGc5lsGeUXHIawyQd5zt4D44htj8UCHkiNtkLrwhLTna2TjAikwcqsJoTDAyl/+URsQ6YYp7vI30vr75gZX6UqJbZ3HhIXJQB9FBLtAXAs+dENvnltFtDk0JA3k5IJjIiX3atciraPVvximc8sGpTMTGV8Ky2ZUuJciwcf91Cbx5225pPjE+4hw022FBO0EDfysII3o1WB8OvQXq6fQqNw72N9c04TgxBvLC+e9LyWEOKYF8mDCF+rS96QZTK57vqVQzWKqt03frd8UdbEmbFZr7t+VqGsCioQOVcXnUi4w84pFtXVjqWkMJtGVClMTfwfxJb5cVbxSUeD0CG
 0o/J67wv
 HDwB4Y/mDV+v09e7QzKFZbmUslQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 20:53:01 +0000 Bing Jiao <bingjiao@google.com> wrote:

> I’m resubmitting the full refreshed patch series together this time.
> I just realized it is better to include the unmodified patches alongside
> the modified ones to ensure compatibility with upstream automated tools
> and to simplify your review process.

No probs.

[1/2] is cc:stable whereas [2/2] is not.  Ordinarily that means I must
split the series apart (they take different routes) and often discard
the [0/n].

In this case I think I'll leave things as-is, so [1/2]'s entry into the
-stable pipeline will occur a few weeks later.  I don't think the
problem is serious enough to need super-fast-tracking?  

Hopefully this approach means we'll get some Reviewed-bys ;)

