Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77734606A332
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=H7LzI0Oi
Received: by kanga.kvack.org (Postfix)
	id 6E4BE6B00EF; Sun, 22 Nov 2026 14:11:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BCD86B05B0; Sun, 22 Nov 2026 14:11:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AB9A6B05B1; Sun, 22 Nov 2026 14:11:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4A06B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:11:38 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 862731A017D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:11:37 +0000 (UTC)
X-FDA: 85463699034.26.B12B1CD
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id A29E6180007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:11:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H7LzI0Oi;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795374695;
	b=WIhDE1SbDCYxHHZ9URKuAkpWuEsPF/WmWTSsJ+RrM54jYhIUpjzDvlAvHoynrnayTi5XX7
	iB2UFIkmDRo8E2rlCSH1S7jL76rW84L9pkoz140le2gDJFE6rNn/oxjIXzVUqbo07Yz38Q
	UG8S3Z4x5YLrqoeDYNR5FWAMM71sINE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795374695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGsMa7wmHQHTRJX2QekmD3Y6Ja6uGmq6iEm7evLlQd4=;
	b=j5hEPi46eGa55zTl/Tbz34iQKA1EQPus6iYmD9R4mNd9D+nx62SKHx7SreI3TXjNZ5r4Ir
	3p7Y3htLXjCN7SS1EnrJQiL2Chf+xHzYe0Ic5qyIob3vGKcruPLVvD+clVU+XFHLNQNG+B
	gEByFvL2qsiwpKKbiuatlDiuyXRU/bc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H7LzI0Oi;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-94961d90b79so306566185a.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795374695; x=1795979495; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oGsMa7wmHQHTRJX2QekmD3Y6Ja6uGmq6iEm7evLlQd4=;
        b=H7LzI0OidVjbivhFM2eILESYNyAxcjCR7EX5vE4c/h6EIdHxLWVRBZQuaxtoyYMu/V
         fg5CV0tG5Aun3BJ7+BbV3WnB/+nBfJZ1wJgNO1vgNdmrjY/FWIH84OkScmThSpoYmOVf
         /cyx2QzDr/ccSxsqFLd396Wa5ewqwZCCkekIiUCFE5uX8QNz4oWhcb91JveorsnYg0Ar
         3yP2aFH4ibq/XjE/+lwDj3im5MHWLx2tgfxY0kJDZfGyRarDADaHgPSS/6fObRFK6QkT
         bhYqIKLm7944+4FftQtftNmQ5kM6RyA3HJCjJGxvFSG+1On/SLBijSvuM9ToVCe54cL1
         NQjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795374695; x=1795979495;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oGsMa7wmHQHTRJX2QekmD3Y6Ja6uGmq6iEm7evLlQd4=;
        b=PsCcnghPzBlueO+sSnJu+C7P4yK2UDKuLNBnEuRcYV1vEAO7jmbHF8kMnXzsFfQUyN
         9ZmWbQN1EtB0gIfdY9CE9i+bf3hqsKf9/M7GdciXdejf4wFjWXCgIReLlVScwcMy8+p2
         hOCPMMyK+hoc8VzsUFLrldccGFCiojbjBGtSlo7KhW2C+IlJrzxsrb6RoHMkp22cDZHD
         TBfl5BZBbSZtwD0/K+D+9nya/Iy5B/ItS/Ive+HS3O8aezQhvS7u0IUg/0uFoMVt/GwX
         86tq8U0BOKR8AipDiDC7ft5RAnK2oOiTR9S3nbRngEGGOAGV3tctTmoMJb8q2wXdEBJR
         r0ow==
X-Forwarded-Encrypted: i=1; AL+hErFozX8mEvolizs4vtDaYSTKpFdfV5xwEtq30o2go0/AP1qpnA/DkiQhCUmBlY/jM54OmdTREQ0rRw==@kvack.org
X-Gm-Message-State: APuU4Z/Vv45MATNXaP4NO5PIbJfIU6X9l0DoHOIKPk6d9m5rF7WwdHeE
	fZa/CmRtn0Mh82RWMGoCkqMGQ2etPIuQhg+mqTKTo4fW4v3QNNFbXC/6BUXW2XsMbns=
X-Gm-Gg: AZFdTZcuUTnHq0o5+Wnyt9iEYQx9EArj9QW9W+gAv29iUWdynJZZXoYGvq025k0hJlD
	j3sZCy0qHLbCkQz2bpRlErE5FpEiDwHF9+Tvvj9JsSlonj8dcitmOc84Uc06PpU3ANhLpQfCQtt
	k1RYneMMJQE3E1qHp6f0PdwM+s2mz0xx9X81paMPjnM33ysprmw4Y4t/yv1G2AQRgs0VOulFpkl
	mo3qsxnnyYdMwYpDl+eHKnm4YG7diANSXoc6sDMStqnkMhsaUJ1HBY76u8HqjZLFGvxc43q+KkV
	Mc54csfIZBkChTnXFNl0JiUePuIGMuhLQ/9onkdzh+QbhtONrTeWykb8aYypAmpWmFll5FLLE07
	ew7cdHyYKbDLGSc7PF7wZ57HKjIwwZRTWlNSQrEugxsnutAOIf63+INcE+/zhsfmuoceBECO7IL
	ynNShyt1eXWtGAC9am+JlrRYeXwzQUc2UEX04Jb0tDFOquCtF0X7VQPJEVXimRoRuv3I01Z3NWN
	ysc8tbxXQZNZJ8DwGfPvWm9HKKguAlXtGZKocA46+zlcQ8taS60orWMhbR7P9Ib0FpWPeFTV39x
	EFD8EvxSdLeWMMOrI3TJvrsS+kQ9JEAkCoeXvRNWOLsIrVZcUwMZPrc/aKo8N/MOzK9uTUZsVjV
	lhad8UVU=
X-Received: by 2002:a05:620a:4727:b0:949:326f:bd2b with SMTP id af79cd13be357-949ba9aa37amr1639379885a.43.1795374694656;
        Sun, 22 Nov 2026 11:11:34 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb38c903sm651828485a.19.2026.11.22.11.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 11:11:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 00/60] Private NUMA nodes
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yury Norov <ynorov@nvidia.com>
Cc: gourry@gourry.net, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org
In-Reply-To: <awMdeK8O-5mffg2m@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <awMdeK8O-5mffg2m@yury>
Date: Sun, 22 Nov 2026 14:11:31 -0500
Message-Id: <179537469194.412063.13456998694958645706.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A29E6180007
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: yb7bdbtz3du4et1548y9a15pcdzsm6m4
X-Rspam-User:
X-HE-Tag: 1795374695-42652
X-HE-Meta: U2FsdGVkX19sevANYvoq8ZhqlUv/KWJjjIYxaGV3SayN0wjpJnRkFmScmgNr/W2E5wMxgs+aJpsf5I+pSjimFHHclRp4LhFgSHAO5ddGAw10dAKxYnnA4DLuU0Jcp4DLqwQKbDORU/0GNex6p7oRVNmbEuwnEi5J3NK6UbFRiEcKQHCJml3maBANow/LdIflVZlzKU1t7ionQ6pErnKlnsCqW3dWmLzn7ALsUjweWQC8jsso1JapaVB0gY3gv28P/7iozvWJwaJ+RXuWb7SO4o+qF+ICddjh2Y/BRafn+e51gZeKE5Ve6GV39TAzymEpFQxH67WVQL6EMVr9oa54RGBJBQo54qo4tEu0RXsCPx5ImNkut+c/zaXq3nM2re5ifUfNdDbf33qCVMLRNo7+zYTw+EoV86Ph4/gxPdqz7lZMSdKy6YpjtK06oUGH2QbIu++Lo8b5KkTLxgrgLX1iCiR5n8FfFNNwkF83+Db9C93B1wB8ERj90ZHJf0w0M/voU9tByxkYVilK1vaKEVwoOKYDCarq5ZKZUrXXJOuC2TcjJWaV9QB9dll8ugw5XBs86qgbt9EUjnMKnsenXDt/rcXe73Edf3nNbgL+s361VG6/tZQJlPd7JO1SbS/SrfAZse6DWQNnb8JfB0XDwQNf2TRjqV7lnnC3toQLp2gn1RWUt8v5IO+ALSHDN5fxarIhJgJAUVlcqMkluOX40TuxbuGv3ctsfc4le5aKPHMJm3MB+a39pjUtI0PMx+d5zpkzhDHIIkh2W4l1eAQ8Fna9kQq5YdAjVfv4vlEIERTmriNocn8sSIk4Xk8F6GWAHl4TxRnP3i3JWKaEFJoW7QM2wYEc6UQh4rAc0h6nYO8f1W3OwepCg5p8VOL6gQuviBApt5SrOFkyDFlxJAPRag1VKOQ49m9roz9PwsqJ6AdmOrRoIYiJCzuY1FrCIeYIGw4qBVWOhMru+fx/iPrZI8d
 6oslP0vV
 i8hNRmkN8Bsr0AWjd4v7rrGQxBdtJg9Zw5DsoeG+2CA+e+JcsBC9N9wqtXwRg+u5qk5ULFq5iLPyyjs0Q/tbQ5JfoyS/kGxfJAYs0WSz6MdhFudQlFmzM9tCr4ks/nSRoC/efWEMyr/NVnUnedF5PUrrmyx8JY/lbKGe1J2eVKG6DM56uNWym2fM5EHkwcxCE+xawziF++hb8I6hDe/QJIt7wnsHYw63c1txpg3ySbdw46YAnOLAnTuWuIhnfeNJOTdUo+QtLViVE2eRSmhbAzKklktePaCuHqemYoAQuL0ukPlPD911FFUnsWcd4ZdejWDS05Y/q6qLG7nj9h+YdyvEYUsnnaryMTASj+OqcJkEXdN4vbolAA+JOgqme5DTOsIB18cqPJs9m+3tQ61LdifOeESjD1IpXkCdhn/5+gA9xVDbEDr8NFJHV9F6oboqrE3/DgEHhcxzy9ZPDRYrrCKSCUyxNFbbLCkjOiBTOSctRM4cwEE72i53LHWMLSzt7Xm5H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-22 11:51 -0500, Yury Norov wrote:
> On Fri, Nov 20, 2026 at 01:08:51PM -0500, Gregory Price via B4 Relay wrote:
> > This is v6 of the Private NUMA node series. The series falls into four
> > parts, each building on the one before:
> > 
> >    1-18  mm: introduce N_MEMORY_COMMON
> 
> I walked through this part, mostly. It looks like you can substantially
> decrease the patch count if you keep N_MEMORY meaning unchanged, and
> add another type, like N_MEMORY_NOALLOC.
> 

I don't see how this would reduce the patch count substatially, you
still need to convert existing N_MEMORY users and need to differentiate
between general purpose memory nodes and private memory nodes.

And N_MEMORY_NOALLOC is not a good name.

-- 
~Gregory


