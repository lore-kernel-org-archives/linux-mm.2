Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4008810F6FB7
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914A56B0005; Wed,  1 Apr 2026 10:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5576B0088; Wed,  1 Apr 2026 10:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB1D6B0093; Wed,  1 Apr 2026 10:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2E76B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:47:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 171E11B88DE
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:47:34 +0000 (UTC)
X-FDA: 84610265628.03.8D8553D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E85D1C000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:47:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fVUZv9jc
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775054852; a=rsa-sha256;
	cv=none;
	b=cTfQx6HZPUBD/a6/Q+EfzS3cu9JoSwnATI23W85wRFKKgQ7pJ3Mieh9ZwdqVMqjxMFvU4a
	MV1J10E/6g0/seJeVhCUeDLroNAe1WmKk9Cn48aT9bt10SWkkQt2LqPPyK/mhVR9efSfUI
	S48s44as/Zz+RBNLWoO/QqD8oTvaLMc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775054852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnSPjif5Uaj42mJ9z9PRSlAuR5srdE7KzJ1Mpd5Z4zI=;
	b=ZMjiJF8ca5mDE1nved9s7oVUiCbh54uKblbIWP6Fytx7zVUx919Agbv+fr4cAcYia+fvC9
	hh4Z/H5oi91wkz/7D0Xfarrf0Xvju+MbvgqNddlHvANoZNTclUvl8oJDyFYfj3CnCUcJ7J
	lnyKZzLIMuSW+10t8NRku9wYV9k1nb8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fVUZv9jc;
	spf=none (imf20.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JnSPjif5Uaj42mJ9z9PRSlAuR5srdE7KzJ1Mpd5Z4zI=; b=fVUZv9jcUfB/+Op9gRasnSrFPu
	6a55c6PQIdS4o+sRVJ44OSIe6NEBgl2Dxj212AginiEqdcHZl1MUBwBU3dp4ihAqiZ5eKYISW2P6K
	rdLdgS9PxeQmrrtHBsmT6X+nZSgPYzJO7XwbZIixn/t822yrTmejacHJgqx1eKrOAkSNOdJPQT57W
	SNrAWjQ96b05a05NWrM+UtkvE1sJvNPFbap13V0thSO2/GKzgziT0GlJ3Xd8ycNFGUNR7Ce0CY5MH
	CI6/2U9WfkXRFvRLXKOI8En37s4QBbs+lVECDXvpbUPf/lneU6DiWjiaeWiOb5ZhE6zq6bCGCaezZ
	CDjjEfOg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7wqs-0033kT-23;
	Wed, 01 Apr 2026 14:47:25 +0000
Date: Wed, 1 Apr 2026 07:47:19 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org, 
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <ac0vfEGS6GrdHH8r@gmail.com>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E85D1C000A
X-Stat-Signature: hgeoxfxfufnzfh6nj3bbynzsu3wiap7e
X-HE-Tag: 1775054852-819145
X-HE-Meta: U2FsdGVkX1/4sSBJ28AQfBa18Oadw/PqnAPEev4RXqVxo9lQRcPSd6jvfFpUDabCI94MhEcCuPNHtoX/fbkHL+Mb8Hm/PQS0mnC5moII98S/4iTIV/Ppv3BjL5bmMIfFW5BtTib9tm3pQnfKV95ti9KZjtP3LbRVKkfjLC0s3kopInXfQCXN3SNpDwFEWXm0qdRCbMmmgyJfMfzpqtFweRYU/6qzadieDrR45w7K/Yw4ls2nidLPAULoJNhHuO+DvG471b2obpwp6d+v9HJPaI/GRkafugMIwLJ4CsuP92kzcI2IIGabEAqPniJ3Dfya2i8pzhMthGYmv1y6Gd6nLGkCs0tPB7Cb/5TFi/94QMg7Qiv5dg96LmzYqWKCUi43G5MbDh+xUEklPpWPisxan3pGQzIsyqdadjTxcBzZqyBuqLwBTdXEbJQKbHu1ljwGoU0iisr4YWhhRbRoPXJ6XWt9s53CqhE36+oZ8Ur3Y7D+H+7aZ+Nm5pe3ys3ntbGdmoPJNjwb6PFsl3Ps1gR/JBiiXw/WoLg2+XmOsp0jllqSCYHwdyK4yhsW93HT8DV+182jj1OWTdCwj+LqdMaZtUmE6iVv4H0TReft/TsjUXmmYCN4G8cyYJOxnE1EOu3mWbd9GxJliiUyYdhXPTs1/LCm3B5wlwhdiRUVdGnWx+rPpV8kPkZr65fJniy1w3yDVdFunVHXao3qnHgTvXLxBF3in6dYH+cYDd2x1F6FzYFc/WC9xWdtClBd7czvNVEnRDwQ281C3hzLEwPyLAVNIO0rhesnEpOsl83u4Rs1M9/9cGLIzBVOV4AKvELyP36eJ6m721RCW/l6Jw6HpAobHsomU8J610Xi++AnCzj3VTG0Pw3r/f3h+O4x5Ep8IKmsFgnz2E+XRC/2qpd+xZPB7/Xq+3hCMsC5hgkGTAyqf5cYOk7ZqeDZ97OXldD3MP9hL0sqJH99sQVBKSANcEQ
 FMu8mTYQ
 oEujaXcINbdePZdrJyCIE6e6xYwHLftvdyFdH6cSjpLM5tmTEda9V9gGY51LWxcpnVDVkLlGKISjuuXv7hzj2xAGIPiPBEqqQq+b6POvThQgD1Z3dSrFu5HAVsiDYeIlGzJdLs7R1QOBx/NWH6gv3eYyQXaoIF8/RsSYnKua3Q2Uv9a3sEdavgv+kaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 06:57:50AM -0700, Breno Leitao wrote:
>   free_pcppages_bulk contention (KASAN):
>   +--------------+----------+----------+
>   | Metric       | No fix   | With fix |
>   +--------------+----------+----------+
>   | Contentions  |      872 |      117 |
>   | Total wait   | 199.43ms | 80.76ms  |
>   | Max wait     |   4.19ms | 35.76ms  |
>   +--------------+----------+----------+
> 
> Results without KASAN:
> 
>   free_pcppages_bulk contention (no KASAN):
>   +--------------+----------+----------+
>   | Metric       | No fix   | With fix |
>   +--------------+----------+----------+
>   | Contentions  |      240 |      133 |
>   | Total wait   |  34.01ms | 24.61ms  |
>   | Max wait     |   965us  |  1.35ms  |
>   +--------------+----------+----------+

Sorry, the Max wait time is inverted on both cases.

  free_pcppages_bulk contention (KASAN):
  +--------------+----------+----------+
  | Metric       | No fix   | With fix |
  +--------------+----------+----------+
  | Contentions  |      872 |      117 |
  | Total wait   | 199.43ms | 80.76ms  |
  | Max wait     |  35.76ms | 4.19ms   |
  +--------------+----------+----------+

Results without KASAN:

  free_pcppages_bulk contention (no KASAN):
  +--------------+----------+----------+
  | Metric       | No fix   | With fix |
  +--------------+----------+----------+
  | Contentions  |      240 |      133 |
  | Total wait   |  34.01ms | 24.61ms  |
  | Max wait     |   1.35ms |   965us  |
  +--------------+----------+----------+

