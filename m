Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DCCC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3156B009E; Thu, 10 Sep 2026 03:42:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB126B009F; Thu, 10 Sep 2026 03:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAC06B00A0; Thu, 10 Sep 2026 03:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEE206B009F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:41:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2315D160461
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:41:59 +0000 (UTC)
X-FDA: 85197058758.15.5C2008B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 92B51160002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:41:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QIOYMzTo;
	spf=pass (imf08.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TbT7FCDQfHZUY/cOHp/j6zzLnPdFInAU5COruL2Igso=;
	b=6qHKHnLNrQgQfiRV1mIZPHfcpotxH51og1LqdIPbl8dA5xKyxwoejr5LLHFnUE760sZaAB
	pHRBRb27t17IwAWUH14dvnUwCZGJQUiRaWxsueZpSsnm6HE07EPlkH5GiWHgWyZr9ONzjn
	w96yqYTtazL7Z3e684oNxMqcZYybS3Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QIOYMzTo;
	spf=pass (imf08.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789026117;
	b=w+++lEtvOvGI6PFQD8+edE1IYki052ITEhpGEAos3duX/TpcfawN8iR/jO3zu962avoe4c
	6WhX94gqZLpNqbTsnnOAqtsP10t5/gapYZkm5SgyIqpcXOpm/vjUdjOnH/SfnMUE3UXuhr
	EosDNMG+6W0izCJcdbzZ2tJVc2NQQFs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 20E496020A;
	Thu, 10 Sep 2026 07:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C051F000FF;
	Thu, 10 Sep 2026 07:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789026116;
	bh=TbT7FCDQfHZUY/cOHp/j6zzLnPdFInAU5COruL2Igso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QIOYMzToUH9Eo1pbBtMqUelPOTTMjxTyDDzKIPPhuOQWhJEpnHinpGRkvsbbmFzC5
	 T04EinRrba8zrJVSMt12llesgPIZLMUIJjGGGRAmj+klX3RqlCBonljOVbRisDbgjR
	 NuoPsrnqvoSj/k94JpbGGbrvhigd6cYfRGzH+wZYs7t1C9B1QuTDehxo8AnsY6JWrF
	 TMswqFv9OCDVEaJxVEzsxMq0hZQqAtMJ9o1GYkklp/aYggTa0B07H7Uf61GJU6isBJ
	 VbR0zkau5VPRH/2Wyrbh20SVH/lOsy54gDsp1QyLrGdYr1B7fesUujY4ROCjlYAt07
	 XLl7v4cYQfJwQ==
Date: Thu, 10 Sep 2026 09:41:46 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/12] mm/sparse: rename and cleanup sparse_init_nid()
Message-ID: <aqJfOuoUBQ47L7aD@localhost.localdomain>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-4-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-4-008fc8d579fe@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 92B51160002
X-Stat-Signature: dnd4qhjdsqmgh9te3dqqsb4pnqwnpkd8
X-Rspam-User: 
X-HE-Tag: 1789026117-338608
X-HE-Meta: U2FsdGVkX1/wlYErZLx2BKl4BTiOqIOjv9I5vExADDd3tWS3NDVM6ZyWpiJpUzkrG3agvfsTb7cUFk9FkGZc/9k8zzJg4ZwGUSi+LnD8DTeEVDgJdX5syDSH6ZGRFXch9tHtpX2NrRXw8cry2Ya8crIoO3HlU0TLqP4G4YMn8hcndth9xN2IMUrh8f2NKUQ2DzUUEDygNnX3fyizkdSCoIIhrz3dM2PYl7fJk6A+cIoHMzvRTjfEz+qQBbXDHMHbnD1Y5GhifbX3syqNVBRM4VzQed9SWxu4fPdDn640PJ+ddiX1miXGe+OYN4RkDVV7F6um4RzELiarTXbuHNmbYTlxW0sIYow+tEU55hNSDc4MlhLhFClzZgRB79qgleBKDa8Gpeg8NjNnIqwiZYyZIrjf+yygb19wjwCDbOUo3MadxCLDeFRvhKb++psV+TLEXO4U25NbCv1s0spgVbMaIShN2vtnP3vceDyCxJBGBY8wEA4C37xKxsnhCyK8dHQqsLYT0Bu3KidhvIp91HQjQoDHh1U3ga6E+CL0BBuONeyTb5/eJGo3NEX2ofBA//HRo6QN6zDexEV0MDom4sAVxLMaKdmBEV3dtHSCZIFxZzwemtcPmvpBJvPjjNSqqAJFNhYA3c45VxqeCbaTFqwnz89lYcdL9YZ0RforQdkzCCXD44eZaNzE5wD2XA50UXK2X8VKL1/G+X6PtkQQdzo7OI35PcHuJTslHgJ1CtL1InHzqVighUtBh1gTt9lT2jWJNuMNbVRgI9ALp6Zy22I3uWXhBKpAkWLJR7IBaxy9cEfiiL53eBmR+hw3IoI8wP4Ku37Lcivd6mTp/C6Dq0oi0BQ3eTqkVwSguVOy+6es4spl7USoErASux+Zm9IUHelrDtU0d84SzEEEFj5Pm8Yz3LL6bitmBzit9SNkmYuG89NMNZ+pXiZ9DO0u/Yz1cyMQZ4YMP8Ryk9CgXpUvz+m
 QCviX7hH
 piiDxWDzHb8W0H86AuKCnwPf0owEtogt70Kd8zwZxdyt+7J3qgcLKmGaXVSWy0FmZXI4x8Se4CePruwZll76WpOx9LsLRcmibx+dJVTzoYZ0coMZEYWyQne6QOK0klEPRr5KWO9QFL3aSLUQqMKgJ11sML3nmemOZ4ZbJPmRTqkioHmWU0SUvUwrXgHX+JDkuBfpQ3qPTax3iZDeLGb5RV45KGmth/FmYqoWWBvS+X5txcloRUcEoX2NiD1RV7F1/mcHBPSzvvtgXsDbAP8YpzPC2ZZ+8vnlPbvn0lPxZTW/hdpr0VvBsr7JAZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:32:57PM +0200, David Hildenbrand (Arm) wrote:
> Let's rename it to "sparse_metadata_init_nid", avoid the "pnum" terminology
> and drop the function comment. Further, rename the "map" variable to
> "mem_map" for consistency with other functions.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Yap, solid cleanup. I cannot remember what pnum was meant to be.

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

