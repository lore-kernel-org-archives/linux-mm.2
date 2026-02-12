Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A9AEDF04C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 07:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 658506B0096; Thu, 12 Feb 2026 02:29:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F546B0098; Thu, 12 Feb 2026 02:29:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C3F6B0099; Thu, 12 Feb 2026 02:29:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44CC16B0096
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:29:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEDFB8C39A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:29:57 +0000 (UTC)
X-FDA: 84434980434.27.5DB60E0
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1161E20005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:29:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=H1bQsjkW;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770881396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2O6Sm0cEIfahlqGv931PH2G0tMd8cyKa75kNbunAo0=;
	b=RU68ulkoSXDOYvWueVHgSXlv+RVdOr1aJpPbSkwfoVpUUmqf3PhM6f4WCqoj1OtxfthIDF
	SOLOcj6Hn4pVIPnNEiuR2yLunuhCn6CvrYRak4XXGZfeoqEmPN//qbuPMn4n9iSM4rYOrU
	cbDmeSaXnzlhC4HKHPmHo76CdQq/kPM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=H1bQsjkW;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770881396; a=rsa-sha256;
	cv=none;
	b=Sl26/KympnbJKV7J4cwhBS/s4EOgZX+V0PalhbDT++HKVQgh3ULi7eMMYtUQEs0gzNsVHo
	BpFRFzGzJN/SSHvmHeDKPmYmwhCU62FjipAHiOhv7EnNbOMYoYT05iQmg1AbEJ+IZn+Akq
	ZGfGmec558Op7DBWI4UWviuaW8888k4=
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-4801c2fae63so62393935e9.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770881394; x=1771486194; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J2O6Sm0cEIfahlqGv931PH2G0tMd8cyKa75kNbunAo0=;
        b=H1bQsjkWfgp9ltSVgIAoQOwCBH+daNEEtxbW/Jw692LiGk6t5ivJFYS2zxZXjIW3Ea
         FL9o6C2jjNK/peF49ofPFoMR5x/w8xs88GbIJ7hRxtISAaAniQ55h9HuLNrR98nVfOaH
         Jo9SG1p4XIGo5R5XU0gusIIS1dV98HqzBRyolhbbnL0o5hI1qqQLZBvxqrBBGHHEYgOn
         vbd0s+SCBYVu633dBVW24PJVskU6V9s1ZS9kwity0qQABNYPvSqToaTu3zOSuwjVsyvM
         3rou7R1+xSpu5eh/gAt2sdpyLTk7AfvdV1rQGmxdy3xn7vAOw/BI2afYFvjqx98ccctw
         9GOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770881394; x=1771486194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J2O6Sm0cEIfahlqGv931PH2G0tMd8cyKa75kNbunAo0=;
        b=Ep8Wown34nm+YI3hhO7Ml0GcS8AjBlbBqsYq4LAPzdgH9vFYSD/W8cNEsM1CVxOOC+
         Wf13X2m5N4wdJudMgAZfs/u18hEF/I/ZPO963rv7/6uCtMnXQS0bjUZyIpaWVIkFM7bY
         8U3vVMe/PXk1vl8yyxRBifBcUFMODNKwU6Z/oIaPF0PCkjBAcBkre+heGvp8kARJOMta
         7wdiQsRSjKyhZAEQurfYFPnJgjgcMKfyXHB0B7rBF0RwWKw9LoCUwFSoQc+tw8Fjz2r2
         B6YWE9ioJ1/JbEiVhBxgLxIFKEuKL38qR0yPGILTdqs3kTYflmEoLMADhtav2D4Q07Xi
         hhUw==
X-Gm-Message-State: AOJu0YxI+fzVfGjW4twIdvKpUVojwwZVS5y2V8/A12vKL3wYLzkWJE/6
	KkCOzaTeAVzPq/fS5B9zfGlxayp2pJwN11eP326ws+Iv0EKGblUK9s3j1XO4PINglL0=
X-Gm-Gg: AZuq6aI5XjGVnlNJtehvnC7VfbMO83bzp8d20h7cYmpBSTr8DsPVX+4Npjwa1Qe1Sa5
	C7T9Ys5qndFqipB33Np04AiUlO93Yzb7XlZp376goXm0TzrnNkjOVXKYLTU5wTXqkWSiPENdGVr
	xKedVSI5+jM6cDclVgYplkcwLQJxlbBS76/mi+bQp3wz8qLWYt8Hl6hGPF0LTgoBKyQKltUYNlw
	rX2V15EaE6m9D6UBg/lSMOaQyFha37OOL8QyqbdmHSDznaJXamc4pbNwqryddOFi7TtC1EDIV5P
	ySHyVeRkAtLoG/zwpaNxYgcVWKfsd6AI+2QZjqtMLOtlTNcVGBA8prp666GP6sg8tREZzaeUPtJ
	GxOCP1B4dq2pNeszPOk9BjUivGyknQHrBMfRdEo7dQ/i7HKnzfK6VMSxLpmm5PwQHMQUQAeKmiN
	11R8OJWeMbWt8bxPbqimysuNmyMCZFaoKz22nU
X-Received: by 2002:a05:600c:3b1f:b0:480:3bba:1cac with SMTP id 5b1f17b1804b1-483656ae4a3mr22015335e9.6.1770881394566;
        Wed, 11 Feb 2026 23:29:54 -0800 (PST)
Received: from localhost (109-81-87-131.rct.o2.cz. [109.81.87.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d5e0ed5sm164667535e9.5.2026.02.11.23.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 23:29:54 -0800 (PST)
Date: Thu, 12 Feb 2026 08:29:52 +0100
From: Michal Hocko <mhocko@suse.com>
To: JP Kobryn <inwardvessel@gmail.com>
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
Message-ID: <aY2BcIHIARSwwQpo@tiehlicka>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212045109.255391-2-inwardvessel@gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1161E20005
X-Stat-Signature: b1u7oeqn9b3c9yoxqcg9js4mc6dq1y5k
X-Rspam-User: 
X-HE-Tag: 1770881395-340637
X-HE-Meta: U2FsdGVkX18d01BGLnY3EJlVoOVqPiVs0oS/fUiTKNsInOh76yA1bbJXpto238iWuR1oxf5kyB32UA8q26rzwNVRuCj9QE85J7qi9MXLWz2XVFpLNhyxcCve28elU5mgtarHrFUJfHnjWYGAUDe1c/pQIVj42yfpOHuDd5Pn/a4VlKDsmDmtQATEj9/SB3FLquogdSUYvz97Ua9HUhHwdzKQspAGx8/H/Ht1cvnLEiElHeQk5qEGrJX+0ZJZ+txEcQqpjFjz3dRnxDlSEcwiNb2YGUMcC9DoAmxoPgqFdUC5FPbMm3pAZ0JqDIhCOYJPEOxvFwI25ly6Dby0SnBJNC67qxM31BjJoYmHwKfMF1E13v6k4Sb+kKWL+oj1OB2FVDqntiScaFOsx9c7AmSSVKi6mbDkoDmgPOYOZcKzVYfj33WFpVvMpj33h5ofThIu5HlWcupP4LORFJE/BBWum9k2udprUlM5cCLWEg5i17lMgZd33ifDLNOTrOeyQ95fuijrChpqK/u+hAWyoB+4wv8jx50OB0n5pBoK/aI9tyu9Dwc4XLsu/DKNdQlDLJ1Zp9Stu2ybgvAfLsMT8H6aZEJWkvnxTVuPnMI4PwwNMsVjzl9kyuU8WTd1fT3IRRQmlyyTjr78500U+A6vbZCQbkV37gDm6zThn+5K7iCXcRRxqtWxpQAVq0yySsFqvVuULxKBROUhIy2jMan84roahbVbKE5neXgStzuzAhePKs0k+oniJlfnzFkNHU63dL6W0IrzH78mt92hsDZGX9cxIp7sFIlqCIMHVZjzOvqF57lRvcGNinTMTtBEbN2BhcF2rFrmcSLsU0d/Foj9pjQf5kgIuygt+J8AKbqPVIMJg0cbtCb2Tj5vE4D4i8kWm5u3HpE9WhgCkqjyDBiXzQ6WckL1f5VYAkYjDYOIaGDf1ms3dTBUpqjBQtnMxH9/2SqhQKbg4l/z3FiyWwn3OCk
 +PrD6IKa
 ANFtVzKvQha1EXJCU7JeBg93Vy3+2+cjRPBrp0+zrQUGROH/8y20jusnnoDlY4K2c4TTLRjOJBrMcKMd87VF/NwqYZ+hWUbSuNqdtmVJpkOYhLd6I99DcN7OVxOcWVpLt4/dfjW7XJd2xtXJ7AX2JJNvbBhiXt3/2jywNqobNGBe+ICcFPdoa3kBKLm0+HS4qL1vGskMtbjkFRvF8XJXX2xFVL5XhhhzOgKmn0dZoDvlS2CC2Xzsv8wFl6F/VNx8iYujlzl5HI7zMU2IpqTcrPIcfupA1tTu+kV/OWGyUrt6APhkkQf1NMiKIScV3HobV0D5NdFdX+hPOXflgOOX3QYCB32CylPUBPOk+z6A3idvdC4DtswxktD/8YRHbm3lBO1e3O0aJZm+KfWOt37tH141aSyXPpQq53C90jiLr9ClcuwE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 11-02-26 20:51:08, JP Kobryn wrote:
> It would be useful to see a breakdown of allocations to understand which
> NUMA policies are driving them. For example, when investigating memory
> pressure, having policy-specific counts could show that allocations were
> bound to the affected node (via MPOL_BIND).
> 
> Add per-policy page allocation counters as new node stat items. These
> counters can provide correlation between a mempolicy and pressure on a
> given node.

Could you be more specific how exactly do you plan to use those
counters?

-- 
Michal Hocko
SUSE Labs

