Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE7AD4A60A
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 07:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A323F6B008A; Fri, 16 Jan 2026 02:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D62F6B008C; Fri, 16 Jan 2026 02:59:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EBD66B0092; Fri, 16 Jan 2026 02:59:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79CAA6B008A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:59:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16C1E59700
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:59:52 +0000 (UTC)
X-FDA: 84337078224.14.0349227
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 903DD1C0009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:59:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aESshZcc;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768550390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNpeiEfqfb5v+GFKM1ueZeBl9Z2KfHoMyNHf9Z49WOY=;
	b=SMyN0oj1ZE6h37XPczhzb54obIlgIFIccd68QQt4LN7XpV1EW6RFKYm0TQIzLvWdfCAVfi
	ASCRIr1xvD9hKzXDU8m5Spge39FuBEfriK2VVG/hut2fsIuVZlO+b/n5ygptK1VayuCR3U
	GN9u91eStp/ijwN2nWsFm0HR30NTPaE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768550390; a=rsa-sha256;
	cv=none;
	b=05AVNYDCJkfLrTPgU0A741JKiokaiwLGeVXQXHlWkEympQzt9b4zSD8kv5LBmyyGwLdznl
	uEcOmDsEh+X/EM1PR3Dm6lrFJJlWvtqjODwDjAacxThbm+W42Yckq5TwgPZ0z12PP02y0e
	YmFGLM1Juwz2JoxhXgAUW2i6WdhiFTg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aESshZcc;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB42360160;
	Fri, 16 Jan 2026 07:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA65C116C6;
	Fri, 16 Jan 2026 07:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768550389;
	bh=L+y6jRHplfRtYsjc5T172/xkJ1SxXn11VcmlD4pgIQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aESshZccndDY41NnlA9q5yPG4LaNj79dJ5mXbpEwuhodmzeq3bDfg7GI8WprivmzK
	 laWzczeVqszUUwgOvOxgp2c7e3OdoQupx5UoJ1ZrHXzS3fTu6uWWuri6XibM58ufnr
	 M3f3PNJ4/wOOkOtW7gfdaWVnBS+OQ4FUKCgV+VtGkTQEKBFNUr37k8xLrtVtMTF1JL
	 JLBe/CAvxw2IODrMj9Vrredzqvgt98Ni9Rt8T/gtf9COE/J5LGDrkuqfFS2Jqfd0jO
	 5193b9DhXQK6zgu1QnV3pv3AwlGc6Sf70Hnu512ygyWORyXdzbsRknIw9sVkhVpNK8
	 J2AFcbLnudAiA==
Date: Thu, 15 Jan 2026 21:59:48 -1000
From: Tejun Heo <tj@kernel.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Hocko <mhocko@suse.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cgroup: use nodes_and() output where appropriate
Message-ID: <aWnv9H2Vn6Gqmp5C@slm.duckdns.org>
References: <20260114172217.861204-1-ynorov@nvidia.com>
 <20260114172217.861204-4-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114172217.861204-4-ynorov@nvidia.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 903DD1C0009
X-Rspam-User: 
X-Stat-Signature: 8hhqrrpjgqjub77ueuqxkeyxzcbdnacp
X-HE-Tag: 1768550390-103208
X-HE-Meta: U2FsdGVkX18Z5opLe6h5BmsXDmOcAKaezs4SQSB7TD2i6iuovOxsgGnFWXyqwOEUqaxKnarLJmW+E08mhT2kfXZGODQZNLTaYh7MGmbiqSyWdp6+SDGE0FnzMROBsmrfs2mvJ38LjgsBgrTgOJdhkuUgQVks9yNK6sliyJEm7JF44HjTkWcTlwukL644ig9qO6lDDQ63D5sNaUP4AWqdNxJNjCOKTUPG0GRev5aLG/1lVqbnzFZdvICjIQHmu4CKdZ+DactqYH03qoBejFFqjdPuL/1L0sG4EPiPn4JqOnPNBdIDCwlBJ0c6VfcWBofk3h49lAK6pE46RYtWAK7fVpx7e9wG9yFGjqqF1ehcNCg22emerXSfHDhq1dDAijdQdJc3tgFTA0/nw+zXkwPKp+hR7WLal4tVLSWdnSQ8+xN5BuAP1sY3dOlQlzcPhxIAS8PIXnxEYBvQDXe98QWUbPqPjoh55IHHVWkW0z6Jd/ENHE2etXQoUIzINgUGaHVOuo5sUK88EAUuayrDEixh8cIjUnul0I3fXJLjcMXqdDcf34gdlKy8FOVvsz/qoIi79hZpsaVRyTqDqwi/JLgzS9yJT0LHzgSpd59f5udHBCL0cNDIYHFZ3xIcXCAbF7J9CoSrNg7OMTZ164feq15P0+EdOAUkAzl8lS2BVI8knjjJRhz1qc6O6ok46Wd0UD307VRrhHd4dVrgZ6qVsU9XwYJ+LlpnRPyauDgzePxDmLKkvI46a289CtF2y2zK5Vm1NRq23BlRxX7VTJMSPAfHgbTNMHkzHiRbp9SBK4vkjJb1Gq/XbflSVCcMiMrTJ7MFURhuC5LHmszoaSs4zrLlT0XNxlQwjgN+O35FOsLmFmMpWiSL5bUH5BHmluQB8OOhaRX77GZbfXoA7XmG4MuUkkzzfXGli4qbqXhdZfLRdeBwX1NYWexpgJjIG7yv5dQl16yRRhvricngdvX4FYs
 lYHsvnn0
 Y7vhQUVUJD0xVqZMkR3S8yyPqqS24oL2/MLNa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 12:22:15PM -0500, Yury Norov wrote:
> Now that nodes_and() returns true if the result nodemask is not empty,
> drop useless nodes_intersects() in guarantee_online_mems() and
> nodes_empty() in update_nodemasks_hier(), which both are O(N).
> 
> Signed-off-by: Yury Norov <ynorov@nvidia.com>

Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route together with the prerequisite patches.

Thanks.

-- 
tejun

