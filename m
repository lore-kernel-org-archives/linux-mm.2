Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92823CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 07:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EFC26B0095; Fri, 16 Oct 2026 03:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6FB6B0096; Fri, 16 Oct 2026 03:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD806B0098; Fri, 16 Oct 2026 03:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B24F6B0095
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:18:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77B4CA0275
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:18:43 +0000 (UTC)
X-FDA: 85327636926.11.6B033A1
Received: from mta0.migadu.com (out-50.mta0.migadu.com [91.218.175.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 02AEB80007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:18:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FWur2hR/";
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.50 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792135121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6EH9Q+NY8085/trt7WRYQhIUKmAyNfguuH/JmIdbxLM=;
	b=Jn2aemO+U19EcWyW/ivf6WAhkf9QMH1Nc29lNQk15Eq/Yc814NDDeDcT+EMZhz2p5V9fqy
	Xi/bbQ9g18TYDzWCTjI6IZmpLwrbDqznkJWZ5G3xfcu/3ioECsj0kIV7AeBpa/X7ZOnL4w
	putHU6moJy6zVtlq1vREUAvWxKazFOU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FWur2hR/";
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.50 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792135121;
	b=I1AiQI4mI0kl15MMeddL4V1SLRInPmNFk+jy2PDIw404oBCmYJQAbJsf/i68Yx6hS7fdO1
	3a8+9gCW9CtKcxj3g8Nw+aSGVxIy3ZajoKWZRS2kRF5YOODkhMmri53j39YjrI3qnfZTIl
	w0zgKOVy/bTqdRPdRgkgKOEX7kIxn/8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6EH9Q+NY8085/trt7WRYQhIUKmAyNfguuH/JmIdbxLM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792135119; v=1; x=1792739919;
 b=FWur2hR/Sys1Ij2jDNya4lxwxZ1f1O9AxnsY8LPGpQVE8/op5gein9OQzniCYz+dC79eBW+L
 QpmBSECh8CbYjG8MOSezh8rmET8Zu37vgS3qrLllzK5xya/XkZrb7MK7HTXiZEhZmB4YSnmy5Fd
 0Avx6K3H8UJ8p8Kp201mtP2k=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 986970ad1353ee4d;
	Fri, 16 Oct 2026 07:18:39 +0000
X-Mizu-Trace-ID: 986970ad1353ee4d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 03/10] mm/hugetlb: fix use-after-free in
 hugetlb_mfill_atomic_pte()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261015-urgent_fixes-v1-3-42796911043b@kernel.org>
Date: Fri, 16 Oct 2026 15:18:21 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Adam Litke <agl@us.ibm.com>,
 Mel Gorman <mel@csn.ul.ie>,
 Rik van Riel <riel@surriel.com>,
 Peter Xu <peterx@redhat.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <921D5002-91A9-4FA1-83DD-A7D2D061628C@linux.dev>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-3-42796911043b@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 02AEB80007
X-Rspam-User: 
X-Stat-Signature: ztypo8now1x36w43iijp6o4635gwp5ta
X-HE-Tag: 1792135120-256821
X-HE-Meta: U2FsdGVkX1/E83ovMw7/JkrbdjG5X3wg5yPJCtn/e8Cv7jKAQ/JKD2jwh8VAnHLquILHAn4LpF7CkrgMC9asadq+ptGJEv/g78tCLi4rC0Sy2AZOhL8m+MJvVfplDg6C42rvEqfflKnpHBcczbQ45cuskdVRc8sFTBLQ/oVBIEMs5gvo+9fbZbd8+9sy3HvCZAOlCt434mUdQ+wAZabbFUUxxDydi/KXIkPdN1iLV8wxwtcadRYKLUgyIKj+0qEINtyHv095HxdySmRycqp8X3UAbLwKQ82PSrinG51bc8UyBgsS5YtxT3Q3T7iERdZXnNWc3otpjsfu4MRgUPlJBnwTkVnygRCc60/qN8v8St9ocewvRTfVrsgLC3rQ5mOL7n3kt61eSNHToRSLyVrWWG0PI/++JRDwe7i7QzYCtFums2vvbPYy3t7kjX3vrUKjkytiUhFv7WmLJmZz5WQdZ38quhnqOxTUohW40DTS2M8fCUdQs+gtMpWZ8UkLxEIjzoaJV0appsdh5TZXWOPhbv6Jm+4gyC9hgEa1KSERPcKP7NFEOsqP/hZRqHQqUBQ4JIxX/hoE8QtTBuKxSrhOT1Mnoo9pZ+qXeVnriTFb9FtV/IyHDQfjOsCJUdpUIhDwEHb8XjzAqeOXoVlj8gJ3VQjOecCP4Y0PStm/ZHzM2QqPTLkTanGvzvu7O29cSTufSAya6blexCS6ne+cR8xnv5eWoejFlmrtArO6pAgECejJsj63X50VHfQP+Ax/dvxlxNAnzcX6pZ2Q5lFcU6LAxRhC1u3yF+jXtSrF5dbtksNQjC52V8umxh6WmZFqY9ZUcEpG1yw3+VCA4952W9MNFNVdj8t3bMKg4MwldSsiOsAd/WKVCOoByuluRoqeQCGw0PQhI3VtvGVQGjzpodV7XDUpvfvOCRb5XHCg2ny0hWp7QbBvB10xexoh/Pec9tlQfS5ji8FTMYf+gKYSb+1
 glc5hyAt
 JRck6xZvlrscAyI6xPbuE5H09lSIjlJehfXP1h9v5TJwx7iyxVhRpPy94RZC8BfWuSvWe7lNjJiuujtfSFJ70ZF2Qv0iNbjjUF1eC5Ix70zhYKilKaQplemYhvu/nWmJYAVowlie2+0X8HwttEGE6PrKER3yiP5LYLjLoX83M10wKK78rGeqROgVYCJKnyrc6AQk1MSAk4YzHGKw2W1N9KTBlAGPd4kobNSbmofwCamSv5LkGivSSlY5+XOa2AGii0q2gGLwiEjkehl/FELUS10ZpeN+6HNKVPvEn5XNUUKYQBqkA0UzQbfXmquGmymMnnBRkGtDxjRWxQgI8RFf1Xyc8yiSnFf82dN6K5yXogMArrJ3jwe/7fX94y2+NHKH5xdiAC2pfoAq+nQ67Bd1eT5fZrkIGYe15pSzgUdect61nSSzc4SvdDkn+audyivhJ80SF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 16, 2026, at 00:07, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> Let's fix another instance where we use a folio after dropping the =
PTL,
> where someone else could e.g., MADV_DONTNEED it once we drop the PTL,
> making us trigger a use-after-free on the folio.
>=20
> Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during =
migration")
> Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support =
for shared mappings")
> Cc: stable@vger.kernel.org
> Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


