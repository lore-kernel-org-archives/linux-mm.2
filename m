Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55AB1FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 14:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B126B0088; Tue, 28 Apr 2026 10:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5016B008A; Tue, 28 Apr 2026 10:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56C2A6B008C; Tue, 28 Apr 2026 10:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 400946B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:48:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BC76A02EF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:48:41 +0000 (UTC)
X-FDA: 84708246042.06.D9158AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B2BD240006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:48:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="HNS7/b+X";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777387719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FAcLhmwdtXq9Ax7hxdP2rGfLhuvDVkoYKvcmcZ6XxP4=;
	b=k9zznOaPHanPtiBxJp3wiqt2U841R/wekTdutuW6WJOuQ2hVPaCi/J7maZYl9Vf168jGTe
	UP/UvtYL2XQJWdMcNyk9oeBLZmexfdsTBixexej5m1EV+hH/zDbdKUgHnNoDQDAwvf2cIq
	dffc7Qmtd2AgiAg7qaf9dkkl8mO++98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777387719; a=rsa-sha256;
	cv=none;
	b=sbPdYRmgoyrLhbIzYyLvE54jcG32J9oa0X/z08u6PujZU7ieEm8krPM9V7dTIO1u0Y/GfQ
	NaB9BTxOheHD9XCPxNhzybyRLZwhA7aB9UpylFdpDs+JWWgJashldYbrkf34og2dgEaWaJ
	vrlUJo7YzIVL2FZMi+/GBmY4mP0/rVQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="HNS7/b+X";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FE6B43EA0;
	Tue, 28 Apr 2026 14:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97411C2BCAF;
	Tue, 28 Apr 2026 14:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777387718;
	bh=fl4uPnTzPtt7hgrrDvSXu3usBjSgMiPtMXIsK626XNs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HNS7/b+XCNrPLUcOE8F74Z3u6L0t/ABy5MsW/bWl3De+y631/5mG2Sr9RMq2naZ4Q
	 oezo2lNAPYgOn2Mi/NyKyuwdvSz+Y4tvLNY1XWpcgTDooYql4J/q5E471TYxLxfrrG
	 i7HzdoUPkZkRE8WjK24HiUoR2P0eORdhoZerDlzc=
Date: Tue, 28 Apr 2026 07:48:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Brendan Higgins
 <brendan.higgins@linux.dev>, David Gow <davidgow@davidgow.net>, David
 Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Lorenzo
 Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Shuah Khan <shuah@kernel.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, damon@lists.linux.dev,
 kunit-dev@googlegroups.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 00/11] mm/damon: introduce DAMOS failed region quota
 charge ratio
Message-Id: <20260428074837.5fb02e0210ebabf160506a80@linux-foundation.org>
In-Reply-To: <20260428013402.115171-1-sj@kernel.org>
References: <20260428013402.115171-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B2BD240006
X-Rspamd-Server: rspam04
X-Stat-Signature: naughfs9ryfkq13dyoh66cqudxdy3npf
X-HE-Tag: 1777387719-661568
X-HE-Meta: U2FsdGVkX19/gR5hb+iQ+uDbAg52kzrfNVxU92DwSe4eKSVrSDAgwby+7kkcx1Vrl7/L8elQ7gZLXxQWcULAC2FejuYZ3525psjz1Zh8OK79DQ8sXmMSlrI6faR2e6ZOxI9zXi0KUJ83fzeW6Qq0rY/WPOLi3NGrukRUFAPNpANSiwyewzFOMMSQByuYD4r8kWGGxdixfHZnkYVlUlGqyMhJvikDabBVuCNj1X7WQSnkAduBAujDGqGhTF1psnW4dQJ1QLqa2OyTg8KBrUooRlcFGeZlluCNaF4TVNciQ7ENogs6Al+Bl44fgQRJGY2+95PnYGYq18k4ssPpduT82XHCs4UTtscgPxFO/Hw4AVfVl6M0Ogumv4/XhKPmYcu8VCoa9AkGNl+NEEQjylgx2ynYr3oPBXYtw4Cl6SLTNvPVAPVYWC5r8D/Fdn9ilCNYRcGzyMDu9SXYMorFqU/BGMFHykHn5hTCeLPB2fCsgOnDLFib05vgzIV2OcESOCjRw/M/MMaQMKz3de7wcZQ3ZAbmGlS6pvfl4fUJ+YGmocwwiSd+saTbIYprbBC+nsbbjG+yJQLObrnqLlt6ZmFlTghlR00STPp8vdwTfiWYKy1Rq66jtMYm9OWLpkJ0lzvvRw55g+OF+1GB1O+1eWDtU9rfw1fyDj6U8hyIHtz0DKchuEW1GuyDA6IzoxOCN2hBIbNkQqifxdji5FlHSbAUvgVi2pD4/kRV/3ucrK479a20SfuNOrmsGt7eLIKvG33z0O82TVnlRYuFa5q1qAf0Iue8DbRYWo4LDa2Fv5+XVRjcie84PZ5sPxCinmgitihqSMzby7mpw+0RFX2O+Pq4al5ihlx2NXRkHR17bGg6orRG3oP6h2XcN06fLNvZEg6FNhK1eO3FF+2Xgg40T9v9mSGx8giHN4B0cd54hj9ZZDsYEnB5OvbvqLr84OxWzCng9mtwpUj6N/bScrQFjkG
 qbgkCuM1
 BzSi4oiwyV8TCRK6Z1jypK2jRTTMNoHo7jS42CYpV+wEUIvbt5Sl/RjKZ0LT+WtheJIVTdG6s3Zk2ceni39vdw4RqQzhbeM7ioGykO1kL0e12dp8D949zpuYxKjovEdikULD/Ro+eHubAxeCVeGhMqjzytvZ7zEvfANAhubcFnK/QUJSLF9SvlB2J8n9OO+j/WbRkXuicjm+9v/+dlH0wpr4M8lpAZ5jNTqoZDsn14nLrH0LHbJJ24288PehC13NKoByGhx4tauWh0nslJrdTdqida72tYrTeQBAtO7Rxe9t3uUAxR4CVHC+hsXIHmarIJNAZah1rNQfbJXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 18:33:49 -0700 SeongJae Park <sj@kernel.org> wrote:

> TL; DR: Let users set different DAMOS quota charge ratios for DAMOS
> action failed regions, for deterministic and consistent DAMOS action
> progress.

Add, thanks.

As mentioned provately, Sashiko claims to have found things which it
didn't see in the RFC.

	https://sashiko.dev/#/patchset/20260428013402.115171-1-sj@kernel.org

