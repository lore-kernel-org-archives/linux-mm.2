Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D16CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAEAE8E0007; Mon,  8 Sep 2025 22:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E728E0001; Mon,  8 Sep 2025 22:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926578E0007; Mon,  8 Sep 2025 22:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77E558E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:40:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B61AC025C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:40:35 +0000 (UTC)
X-FDA: 83868158430.10.7280BA3
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
	by imf15.hostedemail.com (Postfix) with ESMTP id D2549A000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:40:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of cuishw@inspur.com designates 210.51.61.248 as permitted sender) smtp.mailfrom=cuishw@inspur.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757385633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ux+fndt5Ei0pwdCscKFIKMuPoFbF/yVyCn8k2pc/0IU=;
	b=znDD93HV/OlLjQrRd4TBHUq70nMHpAOyZVTKuBzBnB3H2EWc4oAwx4hxdVzF3SeskaUaO0
	jAEXf/ya3UA3PBdbp5sAKBjWdMe4c5aTtC0z+c0SAbuNDkQn4Z/76iEgC+P+ioXgey6gUx
	qJvfBXX8KMfERqp8Pp7llACTUmiJ09Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757385633; a=rsa-sha256;
	cv=none;
	b=05EVFPSua0rc5zvcwvCGKi6BZ/5RvmNJTWCjLbBfXUAcyu0Kn9dzcEVQxcw0VqDDu0TTh5
	fVODAXYpy0Ng6Nxd1fZzn4iLUCvGljULkYpKWR4U1M28RCs1LxGXirCtqz95KHzEfhgJgb
	0pgnWdDn8tWROFUQddvLDVZ6pZaUKls=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of cuishw@inspur.com designates 210.51.61.248 as permitted sender) smtp.mailfrom=cuishw@inspur.com;
	dmarc=none
Received: from Jtjnmail201614.home.langchao.com
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id 202509091040251217;
        Tue, 09 Sep 2025 10:40:25 +0800
Received: from PC00024056.home.langchao.com (10.94.13.120) by
 Jtjnmail201614.home.langchao.com (10.100.2.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.57; Tue, 9 Sep 2025 10:40:26 +0800
From: cuishiwei <cuishw@inspur.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: cuishiwei <cuishw@inspur.com>, <axelrasmussen@google.com>,
	<yuanchu@google.com>, <hannes@cmpxchg.org>, <weixugc@google.com>,
	<david@redhat.com>, <zhengqi.arch@bytedance.com>, <shakeel.butt@linux.dev>,
	<lorenzo.stoakes@oracle.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] disable demotion during memory reclamation
Date: Tue, 9 Sep 2025 10:40:08 +0800
Message-ID: <20250909024022.2393-1-cuishw@inspur.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250908183649.da6b77d15c1076e5b69064af@linux-foundation.org>
References:
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.94.13.120]
X-ClientProxiedBy: Jtjnmail201618.home.langchao.com (10.100.2.18) To
 Jtjnmail201614.home.langchao.com (10.100.2.14)
tUid: 2025909104025b0b5c0a585e17b0e2198fc39453a626e
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D2549A000E
X-Stat-Signature: rhbtqmohx7dre6138w9x31zdhsxybxad
X-Rspam-User: 
X-HE-Tag: 1757385631-490332
X-HE-Meta: U2FsdGVkX1/hb6A//uYAPLB5Pt8NTiv13t3mXqtsIdCPCW5DYy4724yBHfjAVoFOyVwgq/bLu5cy8qtd5E5R6+MX0blvesQXZTPwpukwE0FlkTkpQ8aWagMu991Ny2GqmajRMpB31MS7dNSOfIQFkMZDYHkT2iLNfzkbMvaXg5Wlr3PtuKLARRx8bf7NInYDatMUc7Avx+bKpS+KnuEwzv/NZSNc3Z0W0Kr1SX4OVXJCYTnawsQdLPdmKSEyKZpkAcKuE8C72ZjMm3gv2Gnbz/pJPmGHvlWFmin2dxSfIL107hjo9GikrtPkF/0qqnf/q/u7+eZgAAmdcF/21HeFKPSHno/WvRFjHQfQ2QO+hfnHh5sC7N/eUb5u0yOFaF8DPz7D1YCNo80JDukZzSiZXEmG+jOOIZvqjzcYglU7TH5yaMMm0IX25B5s+tEwnxWYBC3XhyhEXVuWZ4BSaoIyvB1Vr0Llm0wUVbGUfev/d77mgKOc7jZokqgHjF6K+rLi5NhFTLjyLd8qL85mFxOhmAN3BnNSHXxPrOMpZGSa5O1a0ArZb3eN80Hq1ZZCAbiXrXOvki/6pWxjkyud8Tl68tnjAd/7CA5nTAdOfb84QzWsEHDH3AGKnPamcKr5uKJc8y4WsPWm51+SkZYlkezPNccE331eCctHBymNrPbiOD0dc/SD5nPC58+5jep2aLUs4W5ymgsW4+hwHZk2VYyPXUnnaOfLbH3Loo8LqooQUJjhZtXOk4HjLHNalsZu1PKjldWtl3qHVrPED0i/7qR5W6XyYzAvv6p2qdOhpbPLf/dV2BaZdQStvUxRGcAHL+9M2Q10MBgchgAgw2UOXiTOzaEDE9lUzRiqohmR+lF73BuWipyrXeluCJ9PO1+Ix9jZWcNYnvMuGFuNRe7WPrxerRKYt6hMLC0V0GM2p6CFOD+9Bu+4xjrZFPZP2m+QZHgfv7n780yQANaVamF0WF9
 75vZrkik
 p6tkvRkaw4EVs3jC7G4RVDtUgsH91m/4PDXD2N41wtbiU44KXlZ/KWbqfQvygxqiq1cB7mewt0lu23VmbmkKohha8mE+uqpOGCit8HtVEldsWQHYPPASwDhZEYtxnaL1XWna1GstdLOXbWHmzIFa/ub/vr313R8cSCHTKfoBKv8px1R/xldAnN7bNkCfixmhuDHinSbDPFyawUIu2y5B1OShLUoJSj4Gm9b8VBfMtNHjrcqDaqkKpaSXZjD+tJowOlaNJ+yEElf3PwQ/g2kZ5chE7zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Sep 2025 18:36:49 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 9 Sep 2025 09:21:41 +0800 cuishiwei <cuishw@inspur.com> wrote:
> 
> > When a memory cgroup exceeds its memory limit, the system reclaims
> > its cold memory.However, if /sys/kernel/mm/numa/demotion_enabled is
> > set to 1, memory on fast memory nodes will also be demoted to slow 
> > memory nodes.
> > 
> > This demotion contradicts the goal of reclaiming cold memory within
> > the memcg.At this point, demoting cold memory from fast to slow nodes
> > is pointless;it doesn't reduce the memcg's memory usage. Therefore, 
> > we should set no_demotion when reclaiming memory in a memcg.
> 
> Is this from code inspection?  Or is there some workload which benefits
> from this change?  If the latter, please tell us all about it.
Hello, I've found an issue while using CXL memory. My machine has one DRAM
NUMA node and one CXL NUMA node:
node 1 cpus: 96 97 98 99...	- dram Numa node
node 1 size: 772048 MB
node 1 free: 759737 MB
node 3 cpus:			- CXL memory Numa node
node 3 size: 524288 MB
node 3 free: 524287 MB
1.enable demotion
echo 1 > /sys/kernel/mm/numa/demotion_enabled
2.Execute a memory allocation program in a memcg
cgexec -g memory:test numactl -N 1 ./allocate_memory 20	- allocate 20G memory
numastat allocate_memory：
                           Node 0          Node 1          Node 3
                  --------------- --------------- ---------------
Huge                         0.00            0.00            0.00
Heap                         0.00            0.00            0.00
Stack                        0.00            0.01            0.00
Private                      0.05        20481.56            0.01
3.Setting the memory cgroup memory limit to be exceeded
echo 15G > /sys/fs/cgroup/test/memory.max
numastat allocate_memory：
                           Node 0          Node 1          Node 3
                  --------------- --------------- ---------------
Huge                         0.00            0.00            0.00
Heap                         0.00            0.00            0.00
Stack                        0.00            0.01            0.00
Private                      0.00         4011.54            10560.00

Based on what you can see, because demotion was enabled, 
when the memcg's memory limit was exceeded, memory from
the DRAM NUMA node was first migrated to the CXL NUMA node.
After that, a memory reclaim was performed, which was unnecessary.
> 
> >
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -6706,6 +6706,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >  		.may_unmap = 1,
> >  		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
> >  		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
> > +		.no_demotion = 1,
> >  	};
> >  	/*
> >  	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
> > -- 
> > 2.43.0

Sent using hkml (https://github.com/sjp38/hackermail)

