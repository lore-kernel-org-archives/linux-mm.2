Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF8EDE8FDA7
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 18:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC286B0005; Fri, 26 Dec 2025 13:48:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F666B0089; Fri, 26 Dec 2025 13:48:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52696B008A; Fri, 26 Dec 2025 13:48:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFFC46B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:48:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68882B6CE4
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:48:29 +0000 (UTC)
X-FDA: 84262507938.16.7EA27C1
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8E2DE4000A
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:48:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IEw4Wm7a;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766774907; a=rsa-sha256;
	cv=none;
	b=ILC+OZe6L2tgQKodQ5xm0BHFSO/1GGgTUgV9J+o8RMd1Sw1KRNWxn5fDU9wPbVTx+Rq7BI
	y3ezRUKlDrILVFitkZjCNtaN+49z84sKBBwBrifMyYnWhvqAqGoWIGQWRFZmmwHMJzZDAv
	9tAr3cCvygnuzukbx3kIdiZA3JtmTDU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IEw4Wm7a;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766774907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djYExfQ2m4DSgDlbkjbYXQXDI3fF2Fqxya+fA5npzyY=;
	b=1e8JCZxoOdhOwqxjEtr450GpTYwl67FsUVfPcGQFpS5HCmiI+DkmEVAs3VmxnzxFL08GUb
	mJvIGXLIA4yvCb4r8k7sM1XMvxF1uipynApK0d0SWEq9QB3KTePqWDoYnVPkVuj12IUJ5H
	l6F1H/48T2HMDx7YuM2vom5PVNyeusM=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a35ae38bdfso250145ad.1
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766774906; x=1767379706; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=djYExfQ2m4DSgDlbkjbYXQXDI3fF2Fqxya+fA5npzyY=;
        b=IEw4Wm7aQLay2IGdBbIiv4bOiqruAUw61lwsOw4mln6Itvh83NQv63hlEPBT3xnaK1
         9NrK087NKBl2xEoUdCDUbVHDNFYDXjHwH6efF6pfKwmdw4sp/hwn/KYQiX48XPh409eo
         +L1DTMFufCG6D9vUpB3NXEDrUs2cRBd/cPwO91CqIE8DM7RKGZiCvClbdx071U9ELVoH
         nDI3bxmS3GIFGp7/PTITkv6vCtsrST5qHBhfY+moS84kBPyNBv2okrVXP6uLuQ+OOeH7
         QwPuqun4shDzwgrqr5q4SWG5nSSsKEh2Y8NLO7kUly8q2GZGV+hZ8zpyv4izMkrN6PAB
         cZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766774906; x=1767379706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=djYExfQ2m4DSgDlbkjbYXQXDI3fF2Fqxya+fA5npzyY=;
        b=xATFj7PZ6EMkSxw42to2euVML/7vL/xDCfHMHcKRwAodvcryYEtJKbNTmUOnMLUUxq
         XhG0I9vOiXA9AyrXLfGr/338yHAtOWSTHfdPSJP6HW3ZmeIEJ9CefhTvGESnf9KZQyae
         JO8YgtEDIlyNq+smYPRfUkbyGAcTp0dPnzgUt2s1pSXjBARjTzozkE1I9waPwu+XcK27
         sBczpjyFb89pLzy6+j2i5yrlPNVc+ITUYhG6lkGEQKG9bwx9+eE1jmjLGlDIskxBvbYa
         3aKF9IS+Aum7sYSYNcY8pmRjBKk7QxVyrK/RzxVNvfX59h9ojTaPo7hVbp5NtC3QOsg/
         DLoA==
X-Gm-Message-State: AOJu0Ywpty2ZSv/pLA3EZW+g+YXIXJkMy/AymNLcvG9vm4XWj+5aoGRQ
	6Jx3M5Hsx/J1JaDcbg4LjJUzRu/sG57ZkR7d4g1SLh2HX3Tnow/lyjGrTr7THu4ixA==
X-Gm-Gg: AY/fxX4mN7jdgMXwfq1PfqgNQCbv3TSCN+XvpNQZgZZ+i9Csi2Y/Z2+3uV2t8EFWRXh
	+ksLd8TrOQS3s49wCr+HKVCAhSd15G9M7tpSVjeEoogvolzSzDbFnkGMZ7JP/WQ5KkMN6XiP2da
	cVqz5Q9sVGCjJ1Iy2rxscL7+adPyxvfY8L42dl4v9zeUcJXJW2DuMHK+h9hk0mXOxNfB9OY2g0t
	jFTK55v7MVgB2xSbhTuD/JQGcGygkTVU4qukxCR9OrwTHLj8MbOZiNEUXNRhAKtAC6ZI+//XHIW
	fnlzINYFjERagcLvgt4pGjiph+8XV7ulHASokE9ZrHQlQwVEu6t89T9UMx0KYVHGl69sWZruJaz
	csRPpRTcP+9LkOMStJUJcTeJzJt/cUvcR/qEiJZ4fXLnYVXrT4NOvpD7A6Kh1LWFREv2G2dmMX7
	wcD+wOmfaLTzn+jCva/Qs8rIVBXKPI8MEyJDlJCkOMno9r348Q1CfV9M9Qn/eMvsY=
X-Google-Smtp-Source: AGHT+IHmIPSPLMo1hA02PAzK6JQzto61+CEQElBIyOOAThagpL/yC/1XBoIoO0pQxTmfbDSihk3IEw==
X-Received: by 2002:a17:903:2a8e:b0:295:3f35:a315 with SMTP id d9443c01a7336-2a353a370demr3454615ad.5.1766774905999;
        Fri, 26 Dec 2025 10:48:25 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c828dbsm208456505ad.22.2025.12.26.10.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Dec 2025 10:48:25 -0800 (PST)
Date: Fri, 26 Dec 2025 18:48:20 +0000
From: Bing Jiao <bingjiao@google.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, longman@redhat.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aU7YSXnoBTFRy-KF@google.com>
References: <20251221233635.3761887-1-bingjiao@google.com>
 <20251223212032.665731-1-bingjiao@google.com>
 <aUs_pLTcsVK8zf0g@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUs_pLTcsVK8zf0g@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8E2DE4000A
X-Stat-Signature: kajacsz8asoof348jx6a35weh7khzzz6
X-Rspam-User: 
X-HE-Tag: 1766774907-987388
X-HE-Meta: U2FsdGVkX18Y0pV/AWX9sMn+xkWrFs7jrIwk6gN3/wouBf/Ee6qfpMNwz97Bpp4G5Tnm+VIysiXgodyPd+b9WYqFpJDyl46xmKno7zciwvu26gMyS5+heMjdjAT+e7mFb3HitQOjH+X2Xi17N+fgmDgF4GwBZ9FrgWiK6tAnquuqKIG62EpvGBHwueB/rK6Y4lVeR/r/fHTjqr1I9PBK/JeVlpKVQmUqzU7hxSRWkldnPXspSpfkbk1d+2IdE+c908bM3lL2G3YnnxMbOm8YkNGRPYuE/8c7+nRpr32pjnzGB7nIO6REJ3TNtb2YDEmuV9D9eCTG7Zc9u6WVcw9gHoHNSfs2ohw1Jjg6nxmKoxkyHO6Qevpqajne6SutxmuQkZs5zKm7qx4hB6QeolmhwWpw63xQVVSpSllSIsRoooZxkc6I0nr2ZkObnqCA8daPzWcD4a8R5AHktRssGXUSUrKQ3yRoh1qG+EaDZRlFePAKUsJZXCAno9iwgOGyvkOEJ0MdL1bKHlx8EpcmJGtyVE9JBekUTds1vGpJQR8c4cRhB+AKxRi2LV0HH0WVx9E9V5S7vjNRW8c3VyHyv7quGGP22nOIiO2YtLB/2F333jLmZAaprCnh1p8oyOdWH9IIi2GOAQBm2UJD+rjS2itJ3rxtq7hLVWT4SeFhVum2aaYwJEmezm3BqGOQxvWaUz/1GnxeKMlGCzItIk0v2TJ9h9OhXhdYxeH70abL9tavXXxtx0732z0hUB04R3TuQtyXFWLbrYcyrcUgY9cJhM6qUyfoOTSc6hlln6VaGSQdpn+prNGS6KH0qqsMbi6OcgIBcnEGl70o7XpbOLh+GLhd8m2XTvK1J7UE+rtDUBMq7e5KaYk5NXIwGhGd7TZSoISUCOytu6ngSc2ToBt0EBFDvu6vcS29FY6ExXnyZhpY3ic07qEkWY4EnZHe3/5cancq4EYKbd6YAv3VD2cUWYS
 2swie67y
 +MIMhNrDiRH2rc75Sx20GktD/+0UqCEiAUv8heWl1JuwZs51pyx9BDrjCM9M2AJbhiirRBQ62rgUZpmOdQbmG2vrJZ0T3vUimY7ZYjKya1rMfyXqOMvw5XlsrB3Gj4kwrcOPl67JQR1IlqatUqliao13yqJSvRVKeRyJmujDNLJJxGYGYgDS83mDHBuMXtq3cO+sfdjKzlh1fv1mIlOJ/WJmZWmab+o23C5Ahr5hOc/G4WTMlpXnOi9EV2DHJIsv8khNg3EoscwEZ5iFpDngu6FNMCgl0sme4qQ7zA2PZBoF3ZWE7wI89KmrLJg2y+2bzJF3cKMz4MKh5XSZXNumeax4hEU/iXCMF3cwF90/Ogre+mow=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 08:19:32PM -0500, Gregory Price wrote:
> On Tue, Dec 23, 2025 at 09:19:59PM +0000, Bing Jiao wrote:
> > -bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
> > +nodemask_t mem_cgroup_node_get_allowed(struct mem_cgroup *memcg)
> >  {
> > -	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
> > +	if (memcg)
> > +		return cpuset_node_get_allowed(memcg->css.cgroup);
> > +	return node_possible_map;
> >  }
>
>
> node_possible_map or node_states[N_MEMORY]?
>
> The latter seems more appropriate to me since node_possible_map will
> include offline nodes.

Yes, I agree that node_states[N_MEMORY] would be better.

> > -	allowed = node_isset(nid, cs->effective_mems);
> > +	nodes_copy(nodes, cs->effective_mems);
> >  	css_put(css);
> > -	return allowed;
> > +	return nodes;
> >  }
>
> I saw in vmscan you check for returning an empty nodemask, may want to
> at least add a comment to the function definition that says this needs
> to be checked.

Will add a comment to say that it may return an empty nodemask.

> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index a4b308a2f9ad..711a04baf258 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -345,18 +345,24 @@ static bool can_demote(int nid, struct scan_control *sc,
> >  		       struct mem_cgroup *memcg)
> >  {
> >  	int demotion_nid;
> > +	struct pglist_data *pgdat = NODE_DATA(nid);
> > +	nodemask_t allowed_mask, allowed_mems;
>
> Only other concern i have is the number of nodemasks being added to the
> stack.  Should be <512 bytes, but I've run into situations where builds
> have screamed at me for adding one nodemask to the stack, let alone 3+.

While having 3+ nodemasks presents a risk, utilizing two nodemasks
should be acceptable. Given that the maximum number of nodes is
1024 (2^10), two nodemasks would require 256 bytes, which should be okay.

Otherwise, we can keep to use mem_node_filter_allowed().
Only update it to return a nodemask when subsequent features need.

> Have you run this through klp?

I have not run it through klp. Will do it then.

Thanks,
Bing


