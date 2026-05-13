Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70565CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:49:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCBE96B008C; Wed, 13 May 2026 08:49:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D606B0092; Wed, 13 May 2026 08:49:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92256B0093; Wed, 13 May 2026 08:49:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9769C6B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:49:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32CA1C26F9
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:49:50 +0000 (UTC)
X-FDA: 84762378540.14.AA5BBA9
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 66AE78000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:49:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=CMZs4x4b;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778676588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CBk5DzwdzLt/Urbldt92PqU6c02fC0avSSxyBcUGUso=;
	b=5AIPZRMp1VttRr9bxw1Yn00gkDwBwvU07uXUCiwntvTILXsuoYBMq465Mx8p2bvG2hlPtd
	u6oK5OxIK7PSSN15UkPdBGYLnmPFa8V6B4Ts9XzBKiFvgycPOCdxb3PPyAnjZIbwsOAzjI
	dT2nm2s+oQ2VJOeGtLF7UBcs2kwmj3w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=CMZs4x4b;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778676588; a=rsa-sha256;
	cv=none;
	b=UjWloKB0nGHTig+94xxQtjzHqAmi/UWIQXZBasDf2BKMtKXc2ADd6Pih958LbIW9ywj78u
	MosDM3gLTd+dKgEs5Ulci1fKxlIfhmBYpaGH6LdyrXShBcU7Wk1YbLaCLrDedz9N6lafwl
	C7k4OdmZ14rM7vLapB5BgOmdaVo0sOc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CBk5DzwdzLt/Urbldt92PqU6c02fC0avSSxyBcUGUso=; b=CMZs4x4bpSIwqjodW45+vmq95g
	TlFJ1getpPHKzZigMPMUjLF3PSw3G7tnVJDJaYO/LL3dwCtbMujH/h93FsYwBrr6Kp9lM8dSeOpw2
	Dvz/KK+Az7Fz0JFbmEMIfocrVcB5HAEEhmDqRZmo16ZoDXwMaAYEnxtkHOv34BW2gYac6/dS2ZQLF
	ttBimzUXZHrfXYgWIHivSBfxFvfp3fkkzExSwNqZ9KQ9ric2IHlw7THm4PfRKihSUBHUt+83P3bIB
	c72KsofB0Miwm88XpdUxWJlpEBcM4gNciW/Q/SZ0DkrxhNi+ghlmE4/hKabRyreb6O+j+WhlycbPX
	MRJjDuMA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wN91w-003AhO-0a;
	Wed, 13 May 2026 12:49:40 +0000
Date: Wed, 13 May 2026 05:49:35 -0700
From: Breno Leitao <leitao@debian.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, swap: avoid leaving unused extend table after alloc
 race
Message-ID: <agRzO1RLpYH5RjDV@gmail.com>
References: <20260513-swap-extend-table-fix-v1-1-a71dea851fb3@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513-swap-extend-table-fix-v1-1-a71dea851fb3@tencent.com>
X-Debian-User: leitao
X-Stat-Signature: pg7pbmj5t6xgunguy5fygmq5nczrjqyo
X-Rspamd-Queue-Id: 66AE78000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778676588-758607
X-HE-Meta: U2FsdGVkX19f/xN/ZT8KAALVlIx2IGHtNkXypBSH1mYQq2Vdc0IOPbd6aMcdNa822qJqSbPlVxWxLQQaVonPg88RCn0LuflEKcwqy+RrYuc3MammlAyuDOCSycNRQ3p9Py4HCUCa5Rd+zIgDqhOfZfeESTgGg9Kaoqprqgb4XlGVGLvxVfkdnv8AUAd16zJq/YOrQMRCgJThTcwkWAkVZr9jSK38IqRXcmUTCILnnIIl1XOdQKbBTwIgpnVT/UsJ6dwUvYh39sR8MH7jQrlRKI7vg2t95CxA3dGUIZxtwv5Pae24xIj8AMpbean4TRpFvteBrS6uXyC2xPC41wrXoh3WAzhRQJDWnB1JuUN42T2aXxXYZa6YLfRaipyQKVNQtBzuGlxtEdArBJPKLEb4eKAQ/NeCBTX2tUBpuDUBCdkRi4HVDmc8ECg4+GcQw24yCh4o2mBrE4epIcMAp+Pp8TbgDoij7oWq1Ef10YmZSfOPyokxC269Inz+P8MVXifBccTfK1YLqA3EqS5BlZ/TWHvYo2U3Je6hNaRSJWDFQ1tIY2nWJFKcIGS3Vr4YXe3B3AVoNWvlz2r8HYvD6hvp9B+vM3Nuw0kyZeH5CQTbeQuJrYP0hVI4yMNAG+QpCBROiIIEXz0yZQLZhM1dDmzwk1xge92ikqkB2/wUYOB+1ygS+AhD8HZwg1iLirqrL4eLijjVXlTeL2eIBSIXzya3W/I15KqVL9Otw1/gXOiEARQrbMimjj5J7DFvAFOJnXVT74LVol6ohasxP2eDNimQ0CL4rw/4gOoADo9FLo5gjNnijdFfG31/GnfuREzLR0xzSZxELaaEiNtfVhn2GH7h0QPOojnqH5wVJDU3qRCWKFRGCsvEv6hQav5NDhIY7zmRRQMTQ78Ae96IqdZr6o9+sGRwTw+iZPPyt4sMfOk4qwI7XTUcETInWmONvTFjNacqdYC/ivun0uFrBT/arR+
 5U34EzXm
 sgJSrwzC4reOeZohmNNYVWOjKKc9zbkWCMyl/dF2PK3OTLZs5+Zq8VCH+kIQfHTQeypHRcIHJJmBnNzg7D7WSnctn028Q9ynKDz2S2EegprkZwoTxqLsIHkn5ztytig6aE+Dz83tU/yKmQO5e+kiy1pUL6yuIeKNKEQyDZcPKWRE/IohqxlusXmkBgqqbM5dH4gJ96gYgLyq1UvjdBl+mDUtq4dubCR+gyiHwhIzn1sQ+l+/UQQ9gL4MAl7nRHOiAsk93sm6HjM8IOSCjuYdTzWVsnH2Fc8/oXapOXg6vf68LLgv0bseG5i0j2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 05:21:11PM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Allocating an extend table requires dropping the ci lock first.
> While the lock is dropped, a concurrent put can decrease the slot's
> swap count to a value that is no longer maxed out, so the extend
> table is no longer required. The current allocation path still
> attach the new extend table to the cluster anyway, leaving it unused.
> 
> It's not really leaked, the next maxed out count on the same cluster
> reuses the table, and frees it properly. Swapoff will also clean it up.
> 
> The worst case is one unused page pinned per cluster until the next
> maxed-out allocation or swapoff. To eliminate the waste, re-check
> under the ci lock that the extend table is still needed before
> publishing it, and free the local allocation otherwise. The added
> overhead is ignorable.
> 
> Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
> Reported-by: Breno Leitao <leitao@debian.org>
> Closes: https://lore.kernel.org/linux-mm/agG6Dp0umhs6O1SY@gmail.com/
> Signed-off-by: Kairui Song <kasong@tencent.com>

Tested-by: Breno Leitao <leitao@debian.org>

Thanks for the fix,
--breno

