Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAA1BFD45FC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CACB6B0088; Wed, 25 Feb 2026 19:25:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278416B0089; Wed, 25 Feb 2026 19:25:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A586B008A; Wed, 25 Feb 2026 19:25:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 035E36B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:25:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C120DB809B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:25:44 +0000 (UTC)
X-FDA: 84484714608.17.D990A9D
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id 68EEF180002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:25:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ey+g63E7;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772065543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxPqJ6E7xvNtCuOu5zbMYJVgjaGYkAlt6qTcXlH4PpM=;
	b=wFdoaGqjAVO9N03lYiYeLSLpEtU5kg8ydaVbRXNbmNT1I4rZuRB7l7Y1O1mKeRpfNGu1JQ
	68Om4u//3csFRPdFWm24frdnNV6r7jWYpBNJXL3BeH2EZPl0jQ4BFxZsSUSWSULtaWLCJm
	0FdxXJ3uKJ44OzAx+qu6J0xDR4YkgYQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ey+g63E7;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772065543; a=rsa-sha256;
	cv=none;
	b=1mrVIiZbFThgIbFdq8KPRXvXpjK9XpbCE95mA8QPLj8XgR+V7HcEBfV8kheEc/l3FNuTom
	yR7Bze5jcvFBSD63kpANf9v+OK6GOqdoE3WGLGH7swZk1f2iNxib6zD1eYA0wI00eyA3kH
	xeLftw3r6/1pa3cwOP4fnGdSdecSiTg=
Date: Wed, 25 Feb 2026 16:25:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772065537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yxPqJ6E7xvNtCuOu5zbMYJVgjaGYkAlt6qTcXlH4PpM=;
	b=ey+g63E7MYcvKk29/8ZzUc3pXSq1elfr4bhlsqngJRjogeai6DH6S2T7UWhCrTJSC1+Bdt
	nyff4LdW470iaVY2rFfXfbEfQtnqRAZ/jH/mY6iGY/XJn1ZQO7iPw3GVDrGvpWDUTW+q5y
	4uMIS9FVfmAwC2lXFCseF48lDsZ7Cy4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, 
	usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <aZ-R87JfacQ2gGq1@linux.dev>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 68EEF180002
X-Rspamd-Server: rspam02
X-Stat-Signature: hzupuaoea93mtr6wfdq5hiq8wpxmgktu
X-HE-Tag: 1772065541-532296
X-HE-Meta: U2FsdGVkX1+4ZBHJhNHZfTruAcPpkfsp0rv7gx+4BPoafsOOwyI0VwXZU9VXvanH4oFDauqBLjM3gliXAakQCOIGsBGKKBbmBvDoHLUYuszAlVxjVWyGSr2/Sy/Hu0VzoA51pfZ8NsCz4N1v81q/9QDP9gNu1k9gpMHYiB71EYG9SQPeEFVbFSDLE/Hv3fOGPkhy1m3/MZutqF4ioTQcYFY6WVAWAAojG41bhD1BYUp3cIpZxfYqU/+3dSX4I53uZ90xcfMK0w31NOVXhMgjvC8G9yhz28OAuEmJks2PV8FOwb+FbFgYRPPcnfeAzm2UKNVIMUraGcCwRNHvVzLFNI0AmvOoi1dmWKjw+5VO4/SKAxRfImUANg/DLuUqZrqfY5MZ3sTd8FySxYgsaweDNtIKvKTxYO5GZLvJSPVS3ffkM3RYk6LB/CpUXXtBzh1JH9mlhsvh5ifhBjVHpHVzSreUvIzT4hgOnBsCEWrfQssT9/2q2eaxJRxmQbMY12Jf8fZS85Q37uJN3K9Wvr4ESfw2KXaDMRdUAZPC2ySBo3sUgFbBEi0rcmLLHgiMXZdbKqSGCDvLIDfQO6eKGN88JrS+ZAZ00amS28AqyYYghMeRQDWqg/0RGBZxvy+lDLL/XKkSrMw2bujARYTPAfmFzH2aO3vWQWcL8xbTdDOda4Aj7osT3SNYDi8AAl6jfYip7BFGKO5frk2vSSLV8sOLmzIjljBqZ9zZheehFdHzxw6VfP6P6/iTQUpvc1NvBhXRogixKF1dRrRtkCPirNjOGzO1UrlCKv+N84omoC40JF8NmjId/zaJCjOvg6nIghnUJ3TkAIK3Z6+RuQxBW2Cf2ZOCPgNDpkRUr9BBI/2AezDO/oWGXEWnA0QIs8HPPu6C4g7zfexTnoos+Xw+yX7TXAbkjIwvPRnYibXWHRUipIoSDLd2f4I+wCF3wUtZ+vBxbKW6J+OlHgqshgw2Voq
 xg2sPGiX
 Dl543rzPwCfHHNOzml1+n5DeqSaXJPDCECP451GVx5w9Wg53iGsVzvFoXLnGPk6AH12pqrimfGrC0j/IKhk2mnGSIN9tU/K4vNVJdW7b2qBp27Kl/ART/ot2Q1fBMvQuGnvsg29Y4v2XKXE5oPDo24PRKUmREtv39Jm4YpiTwbuQvoRh+EKWxb+bboc9NL/NhcCuBQ5NNZWVIOa+bhZLeIliNvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 06:58:59AM -0800, Yosry Ahmed wrote:
> > @@ -473,6 +493,29 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> >         return x;
> >  }
> >
> > +#ifdef CONFIG_MEMCG_V1
> > +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> > +                                      struct mem_cgroup *parent, int idx)
> > +{
> > +       int i = memcg_stats_index(idx);
> > +       int nid;
> > +
> > +       if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
> > +               return;
> > +
> > +       for_each_node(nid) {
> > +               struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> > +               struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
> > +               struct mem_cgroup_per_node *parent_pn;
> > +               unsigned long value = lruvec_page_state_local(child_lruvec, idx);
> > +
> > +               parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
> > +
> > +               atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
> > +       }
> > +}
> 
> Did you measure the impact of making state_local atomic on the flush
> path? It's a slow path but we've seen pain from it being too slow
> before, because it extends the critical section of the rstat flush
> lock.

Qi, please measure the impact on flushing and if no impact then no need to do
anything as I don't want anymore churn in this series.

> 
> Can we keep this non-atomic and use mod_memcg_lruvec_state() here? It
> will update the stat on the local counter and it will be added to
> state_local in the flush path when needed. We can even force another
> flush in reparent_state_local () after reparenting is completed, if we
> want to avoid leaving a potentially large stat update pending, as it
> can be missed by mem_cgroup_flush_stats_ratelimited().
> 
> Same for reparent_memcg_state_local(), we can probably use mod_memcg_state()?

Yosry, do you mind sending the patch you are thinking about over this series?

