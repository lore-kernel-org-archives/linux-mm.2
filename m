Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A33CE107761B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 21:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A6B76B0337; Wed, 18 Mar 2026 17:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0304F6B0338; Wed, 18 Mar 2026 17:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60EC6B0339; Wed, 18 Mar 2026 17:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0E6D6B0337
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:01:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E81756B75
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:01:02 +0000 (UTC)
X-FDA: 84560403564.15.82FA470
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id BA192100010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:01:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XnG8RSXJ;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773867660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDNSzQK4DuyW7llVyriIQHBv3g+jfE0tBybPwJp6L7Y=;
	b=z78IYZ95Xa93tBECMb6ElQCPvXecy/6fVOZrTHPrB/oiRl9ZVEJ4dqP4oI4YAavJBowUkC
	C0zYYIhoaKBqMY62tyxDNPMBqHSjMGF2gsW6Slm55dZxhR5sZ3TxLAqoZch5/v1SWt5Ng7
	8N4DeVTtQ5StwJ+W6syVZ/6aFswZ848=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XnG8RSXJ;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773867660; a=rsa-sha256;
	cv=none;
	b=ZidUe+EgPfIE4Vj54xBBbd3KdRPM29UGf8KdKlJGi19ME9iK+7Hx7f+Kkf94X0hVERZAfz
	lTkRbNVSoANZUbpsh4d/iAi3xLw8XJa1aCdIfwEIdvkS0c6Lv67ymbtE/t6AtOyPmoE+R2
	9+K/Tin+68jl9yXs4HIJ+Xqxijfbkvs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21A9960121;
	Wed, 18 Mar 2026 21:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AB9C19421;
	Wed, 18 Mar 2026 21:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773867659;
	bh=t2u/NnQgkVtNG7BfbPf/TNx+7WNl3R3jdzkDm5jRCao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XnG8RSXJ6zH8fh0H/wNcde4MurnuGyvetEucoOmX2ytbL2vrnFcoA9aOZghTaO7Ws
	 +sUccvmCrPh7LWgo5iiCpKdXulIwuBzAApI6BBon2O4EYIOC9RF/VmWVEbzCXX8pgu
	 OeesZtZGHYJIgZGfkT/2XcaWMCYW6E5tw/CL+8D/nJ6QumME8YFZyP9Pw1FHHq5q/P
	 fSq6ptmb4YXz/wmLRznCkUsnPAo7XBCgKfD4C1YrFYFL7WHCY7ugoD61tZfGJf2yIH
	 fJRtzhtsoDnvz279bnSisBxD+YXI4Es1I/YWyhpO9Xlc3YmlTaRR0Owkd2WllIpPRG
	 3SGDBtbU5n9/w==
Date: Wed, 18 Mar 2026 21:00:57 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] mm: switch THP shrinker to list_lru
Message-ID: <dc95cd21-8e7e-4903-b337-03f2a39e256e@lucifer.local>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-1-hannes@cmpxchg.org>
X-Rspamd-Queue-Id: BA192100010
X-Rspamd-Server: rspam07
X-Stat-Signature: 9fa1cfxk9891idswqrk6sq3yts9n3hbe
X-Rspam-User: 
X-HE-Tag: 1773867660-342868
X-HE-Meta: U2FsdGVkX1/gy6Blnsngmx7u81EMPmVITIT7QFw42lUZlJGSFCTP5ftkAw04dYVw7m01UCjHJBuheBs3SPGiKXzE4SEXM1ShAZqUY7Eap/ar/V4H6EtAcCq1Y8IGdFlgziBlJ9b7HhYcgGYD6JWswOe8JLeihZR9hgp6ZRUPRJ2mYDHs0Rw/p5WBtIhWq8ahSZaPrM5JUwNbPgEwP0srWzHofe3L6a2r0tuoUFKfFTLAhGKNv99vP5FvEpXNIyaUe+Re2ij7UiarKgVerovd9T1ZX1fEdfj0R8IIUMgYVdiDBk33fpoHctkFz0nb13BCIhpJwSLnTRbYrlV3zX5rqjbkcoOTJP473O0TKGTVPX7BJHD/RcU500YSQ+sQ7Ij3efUx0mZlx8JO5Tt3jg9GKoN02CZOsdF7w/GhLL4E6W+CjGm0ec6849OTTgFoSQFgp328faWjKo/EY1sTsMI/EHqbkdpYvqGpEqoZVUfQUEiMNg7HdgAxEjbpWQ0tOov2zTYMrDxycRchknBe5Qmj487rf/F4qgPGzRLOzjEj0vlZ4d3Aev/VpDoERIcB3DxDXrktXkk11L+c/jHuq0m+V4yvgz7aoSDYWz1NCTnTtVfLhCQiILtkbTSICTJsbujrNByQxCwS4Od2c7stc1oZoIXflt92YCwSMEVrGlwqGo/7JdYPvka7kir54FnsGlaYYyuaHpUhqnkBCG4pXUV+KLIbEhmVYPWPOdETjCbf1DXhlu8zs2TspeSIbrLFNRCuUjqAy6z+qKvfVbogSqngDh1BJHLlzsVN0tj3wnbceW8IlRvfS/aXAIVPEOvzlgmWocEGE2KbCqvKHv0x/C0c6Dr1lQCiIC8GCG+73Zplb+theFQv52TWY/pkchiL2EQis6domk27y7FnJui+iKoIzyVIiTL8e7MTu0tN55sCk0OxJsU8ua0uYy9d0AK8B+h1pTkJ+ynVnyd79ZRdNe+
 bNZgULoi
 ppRLJO0/p/FU4jKST84q2A7i7z+ghpm7j9VTawf1RHXTZJPcarkSL39fv25fIBQVd+Db/y+qRVaD1kO7KikR9jAIc+oPS77mGmPyNK6vTvsxx/jYBMoM0ryUU1Ont3ofrNZL1QrN2osd0ePGVxdpg5/+dtfF6rQ5ukPinno0Il3I/rpJPgNeE5NpZm5j4qM3qOzH6HtgMIg3TZ3/YOVkB7iBXwyXDEy6DNMmOyD3Apes8dEADW1LDsTZJjiohvdTzG5ZtFo8Yicht4KQZD3cV0rTEnbTxapV6o6Aw2ewDoj9MQrltANnMT27WG/0s055LPvzbSQHBqioOmQsgBIXwck9IhIFsB7cmDlRr7Zi/bBUwMe6E0ZOx/d3Po2zmZ4Tkx9dqsNB2dfE0K/wdPTFYjBlrqZImfRxwLwJ/draKwxMQ+bbkfIHB9pRmz4012xRI5pTJ5o5aMz/a8HARQ2wWHAVAgAEChvydnbD/vwUKjAOf2rXXPO+USP7OUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joannes,

This is at v3 and you've not cc'd the majority of THP people:

MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
M:	Andrew Morton <akpm@linux-foundation.org>
M:	David Hildenbrand <david@kernel.org>
M:	Lorenzo Stoakes <ljs@kernel.org>            <--- (!)
R:	Zi Yan <ziy@nvidia.com>
R:	Baolin Wang <baolin.wang@linux.alibaba.com> <---
R:	Liam R. Howlett <Liam.Howlett@oracle.com>
R:	Nico Pache <npache@redhat.com>              <---
R:	Ryan Roberts <ryan.roberts@arm.com>         <---
R:	Dev Jain <dev.jain@arm.com>                 <---
R:	Barry Song <baohua@kernel.org>              <---
R:	Lance Yang <lance.yang@linux.dev>           <---

I'd assume it was an oversight but you're an mm sub-maintainer yourself so
I'm a little surprised...

Anyway could you please make sure to do that going forward?

I'd like to rely on lei's file-tracking stuff to catch cases like this, but
I just haven't got new mail tracking working properly in that environment
and it's really too slow.

It sucks to rely on people cc-ing but email development is what it is :)

Thanks, Lorenzo

