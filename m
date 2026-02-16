Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16719E83838
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 21:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 678AA6B0088; Mon, 16 Feb 2026 16:07:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6260E6B0089; Mon, 16 Feb 2026 16:07:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5253E6B008A; Mon, 16 Feb 2026 16:07:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38D7E6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:07:51 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4FBFC4060
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:07:50 +0000 (UTC)
X-FDA: 84451556700.09.3219495
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf24.hostedemail.com (Postfix) with ESMTP id B930B180011
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:07:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OwhlbrUM;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771276068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HpRBCfCaKwzFeCSlkRPtiCqwRuCq3qQsbgDvpARfGfQ=;
	b=4mzGoGYJ6TkGB6JTrQ8UahpQn7X52UISQJuc5oJh4DYbvT0vI03BdZermm2HpIa1e+mzyP
	72nLSSWwT94fI7Sfi5CbrT0vxuo3jFMcqJRdskX2/nXZHp9xvD3FbW6xzHJagkQL8TesMN
	tYWr5gD95yBGoiOsTARNQQtYD2Xk9iM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OwhlbrUM;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771276068; a=rsa-sha256;
	cv=none;
	b=tt31xVIC7UiWOQhvsxDdfx+cAn1uLvTeAa+mYamNt6h0kkw2pdjcFOkXbyaQ+i80RrE75Y
	MRxSOoE2X0NGv7cP8yKJTj/iRPONTNiwBVm73RI5/LuQ7wuPhnHrG5KBcnlL6wsYPyFuBa
	6V2wdwUwdNTizwzLhu+oVQFMZY2a3A8=
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-48068127f00so38077415e9.3
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771276067; x=1771880867; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HpRBCfCaKwzFeCSlkRPtiCqwRuCq3qQsbgDvpARfGfQ=;
        b=OwhlbrUMXbOy25JBY4Wu2MXK/H9Vtehm6ol96IX+cCNXcNSdLpl+Tg4/TjXuvqJM6u
         kHwFCZCCiQiioGWOD1jw81y7VFP0gpjMQWQYPZPCsuxWXrHU4ulbyZVPpNgPf6jBANA6
         aSuwWbHdukdeQ39OKbjV9cJYD7zQy8YZK2vpDfWY7RLMCjO65cYaSpAuFzWlUrZUZjm2
         nGDz2gyY37cI5Z/Bf8apdNbwfWkPx1UH17BYGJkHr+pwkHvHjVngXCJfkOxrpgtOho79
         uNBaIqcrpJQQYZlW68dwcB/U4Eu1ZImPAXeoZRWW2jqM4hpCoD6xA6FLItx4PcRqEbGA
         GLpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771276067; x=1771880867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HpRBCfCaKwzFeCSlkRPtiCqwRuCq3qQsbgDvpARfGfQ=;
        b=cLUyZHmd+G57gGCsvcwGGs/4H9JXXX8l9HOOT74DDdDArF5yFcFBZS0Ia9ktxrhb2A
         paVJWscL285twVpi9mGOe3heKUAMxiRXN7krfRfdFsua3OhNAxksVFuda5Wp92kPS+yn
         Wzci0eBRL4rq9wY2+kSW9t3TT5wOxOYTbmSOAFH2aO8W2f8r2Na6L7t2S70NFzCHZIWj
         MUhERxutFcVTYM7r+eozH7AX1zUQBhj04wFnv2Lq5jUXGiPlhHyXTqIpvufpA7HInVYy
         FYxVgCVdQbarqv4qJZIfXFVmWlOwkM4RssTEWyRdq7Mf9qzoDFkllo9h4ZyUcSj1Dk2M
         avSw==
X-Gm-Message-State: AOJu0Yw1OfDkGxJzBAaIvT8CKwIb/pdpzhnOhONcP6DNQMAz8lyXJ++/
	H9kQzHW0hWnJm+hTk0akmTORA7cyxZwcW5JqKTVStWaZRLFdCDuaz+pCKymrg2JkyvQ=
X-Gm-Gg: AZuq6aL5YXOeP3KyhbVyyw3X5T/+YqMcCt2yb20/r9AxeI+2+bDd5eY+Wlb25Qqe64T
	/5u/3kSs9Qdr4BHT+qo4UT2QdIeDqLoVFxyxrtD6ZQIg+KWFnvR/YAHBBE5VbPjFMtOmRqr1w2R
	VNbRoG6zjBz31bkyBeXKbXMC2lePTEbl1EVbg7TAsWQ0DQMFDtsmFZr4SvpisTVGw4R7EkOwtRg
	vaMFhds1XLYv3lHj+ABt0Gx8tB0fsi8GiT7j+gyQvzG0RnT3pI9vuHZLq6ZXP/JXQQWk+T8py8j
	QZWhOFhSYEGKO5cPoaglHLumT4UgroSrxhdVhMrZQcFqzHjo7CvUXGQ9d5EHZ39BLpBfn2mxudW
	HdWMNjoqhunOriaHBSXf/HN2e7f4pW3Y0px6aT3T2CGArZxRQt89rA3Fi5j3ijqErAKxJbs6Uqe
	ipXP5zRh6Fif6RhQ/PKXVIWhEFobskHW9xIiOR
X-Received: by 2002:a05:600c:19cc:b0:47e:e2ec:995b with SMTP id 5b1f17b1804b1-48373a1271emr193576735e9.9.1771276067044;
        Mon, 16 Feb 2026 13:07:47 -0800 (PST)
Received: from localhost (109-81-87-131.rct.o2.cz. [109.81.87.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d5d77b3sm519573895e9.2.2026.02.16.13.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 13:07:46 -0800 (PST)
Date: Mon, 16 Feb 2026 22:07:45 +0100
From: Michal Hocko <mhocko@suse.com>
To: "JP Kobryn (Meta)" <inwardvessel@gmail.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <aZOHIQj3pJ-9dW_0@tiehlicka>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com>
 <aY2BcIHIARSwwQpo@tiehlicka>
 <eca7a8f9-173d-4cb0-93b3-df082b8d0c08@gmail.com>
 <aZLUm95Y-dKkdBWI@tiehlicka>
 <3fe7c5dd-b184-4421-a21c-bafce6aa7b09@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fe7c5dd-b184-4421-a21c-bafce6aa7b09@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B930B180011
X-Stat-Signature: bucq68taa46oz9jq6ub3qc5ucbcsx6tm
X-Rspam-User: 
X-HE-Tag: 1771276068-82595
X-HE-Meta: U2FsdGVkX1+mbyCLjLHvImL8PWKfDJD+T1t0z722x1cXMKR8o75aSgObCcmRKzaun80SV5gDo+Mpf/OSZFT+zkisfKUt7jiDwgs0Ow64XLPTGbCvT/EjOQPPPIh6E+6jcY4lDzUpoDGehAPRsXsvJgAGrUicQrjC9eHXJsTU6MTxHkcgaTB9zlBwODDcDpkR7nkjauN4HOPLvXAsiyiduaE2Yzyuuah+nqDWbhLkGehkC6j5e/iKe0gqWc8oR8ltlrPS2hlW/aOjWfjQfIy/nUC5blW+toz8DnuHn16fSia/m68D+CJf1c6DGNweMew51TdostRYwyS3opNlzhhOTDYvQFG+MJuACpH+LMge9Ro/FxkPDJm+YJcjCzYzddSKFgvPs8pDhnlR3Xh95PVqgsStWmZm0XxkX0N3JJpRA4rPbCfRPGo/o/6PCk8GK8BahbsIGEUop3CkgJGBVhjMn9e9Fp55Skx5Oumy4jsy4GiDhenAJMVa9Dchq4yK+VY7mUQ/vY31Kn4ylsETZ5r2iVKE1UDMhwLuRog7ABCg+GzKOIDKRDd4NAJ/BVW1W02Jd7CRitGHTIDVZKSzizAF5hP8UowUKwfezTWE1X7K3MJFrIfb5uWW1jhMrLbndDzUBVLqvpdlNmQplRR1wdOnjHYIKG960JihoPgG3axDdo6Gy/pPN5vVxgvA/l49nq5JBKcX6T2nS/np4qaHAQjg0ZqfR/1SKpc5gG8LLaw1/cToqJH3RPLdfv5I+PjU6NK4oqvA+jVgJPd6PQLfgfQVSCAl445RS8Yo1S+WhhCmiGwqu0LM0/co0sa4AcwO213G+FXEeE2RCjTww0dreLzOepZhxI//TfIn15CM07ngrtNFTNHdbjGoqiBiimkGYFaKqBMnXfWrMbkxd3RU4Se+aWYJo2J29tmiqzLpWjCRPdgXRdikBgOTAxeMwJPC0evDgnbVzGWsA9XRsAISUX6
 LEm6Bi1Y
 xnORp9/poL//FRXZekjlJiVg6+mgQZpycJQPZHuZV3NqC/wU9OrOg6GnjgIdNF6k4RJdeBsB0KnvwbAbJsBoKUjJdkv+W84A83lhggd6FPq/ae+ffopIRYK4WToj14jirSYddG5sMiezqYi7y/l6oh/MOEQfBfBjXBsWIrs6XjM7aiAsnb4PHz9jK5MfpQnDn7rPoR+7UMvp0oo7L/uzWaPINX0G/+fMDfsRjtuRqJo6bb1TcQNfccoX0OQs9uax1u+CWpYk4e1pokSndqJl8JDPtL7nL9ulhaNWU7PK28Swn7wjNeIVv+4NhGo9cjvth7ft+twQx3JOU07gPUNDksEJLtBxOyW1f3aU9OI6vu/+4tG7BXL7GRmE8wX2pCDWaiuoMqDd76I/Y7UlfzuLAbaGRct2Q8GhKfEyYrt+9vbOxs/8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 09:50:26, JP Kobryn (Meta) wrote:
> On 2/16/26 12:26 AM, Michal Hocko wrote:
> > On Thu 12-02-26 13:22:56, JP Kobryn wrote:
> > > On 2/11/26 11:29 PM, Michal Hocko wrote:
> > > > On Wed 11-02-26 20:51:08, JP Kobryn wrote:
> > > > > It would be useful to see a breakdown of allocations to understand which
> > > > > NUMA policies are driving them. For example, when investigating memory
> > > > > pressure, having policy-specific counts could show that allocations were
> > > > > bound to the affected node (via MPOL_BIND).
> > > > > 
> > > > > Add per-policy page allocation counters as new node stat items. These
> > > > > counters can provide correlation between a mempolicy and pressure on a
> > > > > given node.
> > > > 
> > > > Could you be more specific how exactly do you plan to use those
> > > > counters?
> > > 
> > > Yes. Patch 2 allows us to find which nodes are undergoing reclaim. Once
> > > we identify the affected node(s), the new mpol counters (this patch)
> > > allow us correlate the pressure to the mempolicy driving it.
> > 
> > I would appreciate somehow more specificity. You are adding counters
> > that are not really easy to drop once they are in. Sure we have
> > precedence of dropping some counters in the past so this is not as hard
> > as usual userspace APIs but still...
> > 
> > How exactly do you tolerate mempolicy allocations to specific nodes?
> > While MPOL_MBIND is quite straightforward others are less so.
> 
> The design does account for this regardless of the policy. In the call
> to __mod_node_page_state(), I'm using page_pgdat(page) so the stat is
> attributed to the node where the page actually landed.

That much is clear[*]. The consumer side of things is not really clear to
me. How do you know which policy or part of the nodemask of that policy
is the source of the memory pressure on a particular node? In other
words how much is the data actually useful except for a single node
mempolicy (i.e. MBIND).

[*] btw. I believe you misaccount MPOL_LOCAL because you attribute the
target node even when the allocation is from a remote node from the
"local" POV.
-- 
Michal Hocko
SUSE Labs

