Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59FC0CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C369E6B0092; Mon,  8 Jun 2026 08:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0DFE6B0093; Mon,  8 Jun 2026 08:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4B646B0095; Mon,  8 Jun 2026 08:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6B136B0092
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:50:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43FEF40AC3
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:50:49 +0000 (UTC)
X-FDA: 84856729818.05.240105F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id A299320004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:50:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ax2evEU/";
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780923047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFSoIlYiJRdf5MABSyRuyjOJ1eim/XMAOiAPmWPfi6Y=;
	b=nAngbToSoOGk6DjCMIdhGJEHZKXjcXMO7KPyqL/Gj5WlFJ4jmA397kRxF3sn819ZGc59p5
	LVvt/PbLBUbKGzljbC5nMmwIACtkGOIujU2yi4IBCJYRci0N9mwTNJNaYB41cgGmu+Z43m
	3JpPZKzgL7EdK2ulF0ONjmiC3N0wGk4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ax2evEU/";
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780923047;
	b=6gNQzWdGYtbljFemS52WbgyqUEMgI7z0g+4lJe0yUhzJrfsZUZEG9ouWu7judrK1gizsOk
	zXFo6NWgQ4B/QZrRCcw4lB72jkybhAhvdAGYEV6Gykb8ToYf2muPsNHVzYs2PgXKT7LMlz
	jw/vSBN9na9Agm3mqVkDzspdfXwFJA4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wFSoIlYiJRdf5MABSyRuyjOJ1eim/XMAOiAPmWPfi6Y=; b=ax2evEU/z8zku5iFN5ybCSrJOl
	f8RxcntFgAaTMGUM3dRw+l3qxIA6hLdGcaOwwO5imUanvWjSIX0kvB8DyTBu+4p5co5/gdlAI/fIb
	co37YsjfIqIRXNoRyJjIKvVJLy3R3asDr/62h/YXDHiw4fjcsItj5tTu5oTeKFLk9m8rEr/7SOe93
	n1L+hTszqKknmsEvzB4akay7IpElFQgBwmdPHNCMvZOk7StVD9dVCj8vEwahDSLj4TcTbzW/clg8f
	d5yNjjicKhRBpFQxuhjcjqc4mTv0/2V8YnIBzZviYWOD2NUTIrowev11AXRilq6h2tLZ1TSDamCtv
	HGZMc4VQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWZQZ-0000000DiTT-1d6G;
	Mon, 08 Jun 2026 12:50:03 +0000
Date: Mon, 8 Jun 2026 13:50:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 03/37] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <aia6e_i2usmEhBhF@casper.infradead.org>
References: <cover.1780906288.git.mst@redhat.com>
 <1a407d39a9ebd95e9de67e44f9ad2db37c9f31e9.1780906288.git.mst@redhat.com>
 <aiaPBRm0Mp_WDPFa@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiaPBRm0Mp_WDPFa@lucifer>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A299320004
X-Stat-Signature: a5koyao18q8px5wnsqou5bagycf5tu63
X-Rspam-User: 
X-HE-Tag: 1780923046-163501
X-HE-Meta: U2FsdGVkX1/WgCaHdRJhNrVbWhxGbfICGgTEtmmm2rh0gXHiPmUC5E7UF6I/O9SIc1THpd8I2KNOBe5zLfZdw9fhRG43vN73qG2NdfVM0FL6t68BewVx+pjLkJRMf7KOPGE50QZyzieNyk5Pd7Eod6zhK2Cr7L7rxl93yvyrz00p1GiuyVEkfkZFiktdqLsT5qAN88I7l63DrcvfXCF8pccJ+I42qvwcar+RabDOzYKzD8BlWkjkurpHX4A4MAu+yVvCZOn60KIXyRn2tA/iBALwqlNVLp6PJLhOeSgRWFiDJC1arm2Cn91EtUBv7iJ3TynbTT7NvRTQfSfzme5UEloimXZY5ciWUeAcPWxO32HjKQuy8GwyeWr7U1u2zhBI5jYJyAy1TdGoBDz+jBlUrtq/TZp4lFUEptUN+CJENkatx6xzTEW46mzoBta8uIi+lseASD6Q++jYKW6Y06qt9cOvTQZMsr2459RRwZZGZyc2nyHd7C/vB78MsFK4wsDJSP1rrq2WFOveW4As5MIwsl76t66lOIccsgsPIPUeFv2woAm8Wq6JPhkh1kvLOuQAIfGzAaEF3QK151K5y50Ngv/QZ96ytSihFacAyZyazhPZcGtWvRM82vI0rIo8NE6FaWcLVqIqna/tRU+hcyq1UWCtpF18Pq54Bhj9GMxKAt7PmPyqsiuTyXD+MzDqlRE212o7Ym7MG6zMjlFaKE3eJQv6ousSXje69HFrtyvQKbHisA2O0IleVwTJwRH5sfPHzRQ1On09dH6WP32WsiKVG2A9kA/PTSWry9rBRthE31j8yaW7NUfcor8P09gucP55soWz9mQ94rj/KBMMLhy278qehQ1R28xmlPs6QVg17EKMy+XN1jwmGGP27iMzIoRkNaobRGSD0KNJfBYG2Lv801s2Eo62rQfPYL8KmB/o3XwZBHpU/VZ3BFJPJkD5DOBVCzIQnAQLB6igmkR/ivn
 H/Vs0kqO
 pS/mCoaAQ8N1FKCnVlPMliA8Gp4d20PTKfW+EtD6Ol8FRoD60T4jIIq8sUv60yl2ISol8g9yGdzApRF5VZI5g9YMFDcQvyMaS6HH29+YGhu+GarDQJVsdS/5MynLrDvRmbrnHiBeauV6YIWN7bj9u9/0cNUXp2gdRCBioks4P/7/9C+BtPQhKbQxu4wFuPxRR+4uHSZ5Bq0WbGAGdjveEPnAIKNOCKasTmNn7BBigh5LXCqUrsuDHEiu3obTPzKcxjryKS2SBsME5nXwtA4r8MIRyoF1UuA8vj+Dc+x//aOGg0fXZ7UFWKIb4sII/5nqiAn6T4q1Hh/8alW4ugc7Tai3u47J/DYH/xxpL7KVTNrFjRfEi7vzJKFzv/xLlQ0XcQU4lhnB2ggqbp2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 10:52:28AM +0100, Lorenzo Stoakes wrote:
> > -			split_large_buddy(zone, p, page_to_pfn(p), p_order, fpi_flags);
> > +			split_large_buddy(zone, p, page_to_pfn(p), p_order,
> > +					  fpi_flags, false);
> 
> I don't love adding a mystery meat boolean parameter like this.

Particularly when we have the FPI flags already being passed.  Surely
this should just be another FPI flag?


