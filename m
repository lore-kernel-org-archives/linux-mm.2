Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C1C606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=iigAHTvO
Received: by kanga.kvack.org (Postfix)
	id C9B836B05D0; Mon, 23 Nov 2026 09:01:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4B586B05D1; Mon, 23 Nov 2026 09:01:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13F06B05D2; Mon, 23 Nov 2026 09:01:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 841926B05D0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:01:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3CB41208CD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:01:29 +0000 (UTC)
X-FDA: 85466546298.03.37D08AA
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id C5EAB2000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:01:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iigAHTvO;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795442485;
	b=a5oPG9uKcaMjH0d8x200uz5fHyekRcOxfDlZWFc2C2/XxKzB42Du48E7H/YBGhPCJwnqMl
	6ZBzGP3DIkBJlzChUjLYY0LyatSvdwirE6dsqRlzIAAB2BdCt+DoXa54ExvGRh+dYLs8ux
	35liOoCrJL96V0W9Ppuhq3J5LmZNB0c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795442485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vG8DGIHiY7DMGeo+eA0u14jrv8r12vq2uH5/qp0e+4w=;
	b=TqbxiWR3ETdft9ATALxW76enfe1teUVDW0+nwkab73zKbVCdgTE9KdCExnvk7CUwRwLM+9
	hBHAo9s+yKbwd7WWqEPU7dKkiUO8aXFPAznHJHfStmwhf2F8vOtkjuCFCmNEtgwT2WwZ/l
	T2Aa/dXYCm/F8dMvjFoKq3HB2O2nUlY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iigAHTvO;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5361e313e63so46370071cf.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795442485; x=1796047285; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vG8DGIHiY7DMGeo+eA0u14jrv8r12vq2uH5/qp0e+4w=;
        b=iigAHTvOlBhJjC7uFQCJ7dzr4VTNwvq5FdiyEOeNcZnodMFAAcIKebYkTmmDol334B
         TR2DqEx3zAEp+92belHFwF/3hfjDaz38Ysf1LAYel83sTOxAEkmm+lhxLUu+htAWwn5p
         KbfGTM7sIVi1dqQIHddn1pexUoDlCSMCw2xUxX+/jw1jgz0XVWX1RdZ5/GqINj4TkLff
         HuMzc+QEAFSaUL/mAUJOKc9+YpbZLKXALmT3D60QTY1/Y4fi89efDucdTRZrmrAbyAUy
         dXThQV7Ql9yKts23FOKT1xnein/WPTCV293XemJ0B52WVNZRf1vHs5Shpf68sGUakwF0
         CY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795442485; x=1796047285;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vG8DGIHiY7DMGeo+eA0u14jrv8r12vq2uH5/qp0e+4w=;
        b=T/FoDO8HHrlSae1q7TYmTlx3o+bBTGQ7EkpCHeMXddQkbYYhNVYM4/mPV+hBBx+p7b
         Nd3Xrx9igO73fWHDLvBKHDTOoz2/r/GowrovgWHGE3quk399G72FsspmCGUPaWXFS/A0
         Kr7RvOUPGj03nHzPP0m3E5YR/JBCt9j9fBzAozKUfQgEY7wa4xjOgD2sgTG7BilOiKx1
         3zssTWpwLzIM+ub7coNwviJH6CEkbhyM6BbhS8QtsPOLZKd5S/3NjoEUmMy8ZEa6+GRn
         X2phAsCYTpLQzdE+b7DhlepX9+XnUei3dMfOHh2aPq/SR2wbQcKxyYP55QUM99f/11G/
         KfRw==
X-Forwarded-Encrypted: i=1; AL+hErHcJ40uK0Sqm8dN7p9AoLVIugEVfTouxv5e1O19LzvhTWJVdbbrsp6EQg2gN4qPgpsojJ7X4Mapuw==@kvack.org
X-Gm-Message-State: APuU4Z9k+Y82i8iIxmstmVJiHvrZixpl5GtqPcdSpWzO9SpEQbM3TK/3
	hMB9Rpw1Y7DZoKwAcnfQcNVrQzQoylo0y6E5kGhFyUeuXzg1AdPJdMA1UMLbXAPc/m0=
X-Gm-Gg: AZFdTZcREqkZmykkvCRetGEngYQvjHleC3hH8ukINKTs3azCBw2YjcPDOoUgp5QxUyM
	L8c+BmvJ6QYPf00Uj3scQDqSCmfQMh9pOGRgAFz0HIsnWFqgN8v0P8P3/wDRKGXRykwQKF/lhly
	zf6IbScURD05QAdaMeSPn8YO55yc/WlEx8OyH09+elWOwwaGDuJQP8JF6US6JHvStlJZOSlUJTc
	WTJV6byGzg/YHdqsl69gBgc7ZWpIuTB0aNP8vXt8FbeyFlx4GyHt+T8XgHmlBQbhGDW+uGpW1cN
	QVD3E+i6EO0Pv2Uo59E1+tIbyT7VTBHRxhmTiPRh3wFeP9Z23OMbm4kud+4VkaTEJSnwcR1mRdY
	AGosNmTFe5sDoRg/qB3MvzTWvEletAPLhblu9RDQhtd2PxNOvvRPcFoZzlj+Kc+3SPeXouCYt7u
	bGhrnOrxwc5QNDZj0QLx81y3K/G0o2U941fQKkk2A8UdxDTb/5Qk/KOEaskaTweemArXzrvMfc5
	hSQRz22Af0f08NrfoQs8Bcxph8KWn4hoqqQ60b9BJe1OlZcnlyXJ1gV0MMEkZkM/DBTrmKU8DLk
	EpBG/XrKIDxLpJGuhXn2PXB/5wDp18ZnIsmoHPldnPk1+ux4iZ/1HOJ/7HOhpMCR4NFVkTUr7Of
	D8n2gNTw=
X-Received: by 2002:a05:622a:8413:10b0:55d:8475:aafb with SMTP id d75a77b69052e-55d8475ad43mr113506371cf.71.1795442484804;
        Mon, 23 Nov 2026 06:01:24 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d788074desm99999281cf.7.2026.11.23.06.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:01:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/60] nodemask: add node-state iterators
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
In-Reply-To: <awMK9V6TbU9Xtzn9@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-1-74f5f9a115c2@gourry.net>
 <awMK9V6TbU9Xtzn9@yury>
Date: Mon, 23 Nov 2026 09:01:22 -0500
Message-Id: <179544248227.412063.16491857533875192357.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C5EAB2000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gw3w6xxzhdjuzew14xjx9f1d76k8b5od
X-HE-Tag: 1795442485-524407
X-HE-Meta: U2FsdGVkX1/q6YrkR4P5GZFQ6/mbE1DnhQ09EUTlWdrVVOKjt+koG+22NRN+XaB07MK1zJ3HuI1C47mpy6l1tMx4Dxr9lIfUVZWad8MfoIxgSBeBZkYcX3TTFabDYrvBS3LR2hA4do+9GptMRhbLWaTY0FTD8m57tKTFMsIOUxoS+82DRInJI0HLo90y+auf7zVU1/kIgz6KMfInxugFlO2Hx5LC1iPp4Xt+A3c2SxC/gHJY4CxFaPxqDP9sAAe9TaIpAIC4FX15gUU4ZvgFw9u8a3xZ7Fn1w7fclPYQMzKE6f+LWg+1lfh7izdYt6GzdqnRqMX25Q56/VsF1/UUtDcxj22vUMKr0AzCmQkmmsSy9GycIDncyNH/XMkgrjeIypOTLV67hFl7rSacp2HD3fh1/5MJX2tH5rtw0YIANgxPDgz/2LuLSl5auZlwVFgYqb+cw9XOT9M2aA+3nyN3boNFcQxkeDf0QXDgg8haTqxDhuAF/3PsKGNwMrGr8gzUA/Nz9E357kaeukIzUVq9vEV9xHygUXR4rzkhvfjrDuF3baY7ZYzpyWYsGxlXXChqZP+17j6wmr9A6HRTbvIdTclman6gjbeLUVBofXUzN9IKDrBUCa4QTblGQ1ACvMFTdDx+WNGnNFbWHNvg7oNeJehakJU1Uo0cKvW5+5jsSgqlgeLkMWZ8asNtZfOid+gOY9mOEVS+C5ZIky4tTfjEvtX9buvLcMrUPw1Ex8JdofVRZEJVyHnqAnsResoGmgKNfzZ+cKLYBpHgftSUg7zMzE7epEesAmaGbIgugOM6GaQngu3jf1qJCOPYo46lf+CjpYPZPBAg8YULvZz0224ZLSXOkc1HjtuqARX+FmfPQacRYs6KuQdckSqFe0rAJzSWVDxRMCTa2NjOMNObZ+h92LJo02SLrVDUtzUXj9lKfshC/fdiTRODhyGrpYxxi9WFzXNerWTM4Nxg7jujKZr
 bUz3Lpes
 x6VmchnxU9KzgxJzn/tzxQVnoVRdyg3az+bTl1j3oUb2wg+lVrclb5+AGmuTpUF4Uzt+Q2sEfjGa6QDNwOhPErfmFV3lnWgDko1wsky4fbfLNo82lq+z3wZv3r+5l2wr5VuSMVjfAqvkHoRmLFclS0Ft7gOHXoqLcj6jQchyBQ1C1ZPZkbkzQn6QY08XNjI2xKhuk8oYb6Om5R5FinL1jd53Xt/AjkbBDTpPCt4NclwGMxTGQsCo+HChyUMXFyFvjcT0aU5zPz+yKLLxMAhyUCKDj7OILz4TMh5VJF/46AluhPWZ3UTnzIV2rGkLTnS/Hs/AY8RaT4zWtyreH7znkvxypKNgMC+/L1uwVT+vkztvHe7T/prQ8xolJ9ReAwr9QQX2kK9XjSmj1LD2pn1OrjdynuXaDbUxT4+3GkBMGaAAWg2nFOl3cXJiTJi9D2u1mtm5TlOM5cR6MA4p2fneczPOrD/XhkpwIkqAQIoabVtdD749MRAkySwJMp0CwscTvza5Y3HNh+9Igcpy8FwrWv981bP1rC1vjJL7DVuKNmIYYT2anGv7txWDB+QKULCuq3+Js
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-22 10:32 -0500, Yury Norov wrote:
> On Fri, Nov 20, 2026 at 01:08:52PM -0500, Gregory Price via B4 Relay wrote:
> > From: "Gregory Price (Meta)" <gourry@gourry.net>
> > 
> > Add first_node_state() and next_node_state(), so callers can walk any
> > node state the way first_memory_node and next_memory_node walk N_MEMORY.
> > 
> > Add for_each_node_mask_state(), which iterates a nodemask intersected
> > with a node state using the bitmap intersection helpers, without a
> > temporary nodemask.
> > 
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > ---
> >  include/linux/nodemask.h | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> > index 607373bd83ee..90bdcffa42ea 100644
> > --- a/include/linux/nodemask.h
> > +++ b/include/linux/nodemask.h
> > @@ -411,6 +411,11 @@ enum node_states {
> >  
> >  extern nodemask_t node_states[NR_NODE_STATES];
> >  
> > +/* Iterate the nodes in a mask that also belong to the specified state. */
> > +#define for_each_node_mask_state(node, mask, state)			\
> 
> for_each_node_state_and? We've got for_each_node(), and we've got
> for_each_node_state(), so let's figure out consistent naming.
> 
> Did you check the codebase for exsisting candidates for this helper?
> 

for_each_node_mask_and() would be more consistent, change just requires
passing node_state[N_MEMORY_X] instead of just the node state bit.

> > +	for_each_and_bit(node, nodes_addr(mask),			\
> > +			 nodes_addr(node_states[state]), MAX_NUMNODES)
> > +
> 
> Please use nr_node_ids instead of MAX_NUMNODES.
> 

I followed for_each_node_mask() which uses MAX_NUMANODES but let me
look.

> >  #if MAX_NUMNODES > 1
> >  static __always_inline int node_state(int node, enum node_states state)
> >  {
> > @@ -435,6 +440,12 @@ static __always_inline int num_node_state(enum node_states state)
> >  #define for_each_node_state(__node, __state) \
> >  	for_each_node_mask((__node), node_states[__state])
> >  
> > +#define first_node_state(state)	first_node(node_states[state])
> > +static __always_inline unsigned int next_node_state(int nid, enum node_states state)
> > +{
> > +	return next_node(nid, node_states[state]);
> > +}
> 
> At least the following {first,next}_{online,memory}_node must be
> switched to the new helpers. Can you check through the rest of the
> kernel to make sure all candidates of the proposed helpers are
> converted?
> 

I originally intended to delete first/next_memory_node, to make
usage of N_MEMORY a bit more obviously, but dropped it to save an
extra patch or two.  I will probably add that back in.

But yeah i can update these otherwise.

-- 
~Gregory


