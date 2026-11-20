Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 635DF606A338
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=uuc2RYGJ
Received: by kanga.kvack.org (Postfix)
	id 818156B05B3; Fri, 20 Nov 2026 13:42:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F0016B05B4; Fri, 20 Nov 2026 13:42:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DEBC6B05C2; Fri, 20 Nov 2026 13:42:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0ED6B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:42:00 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8672A015A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:41:59 +0000 (UTC)
X-FDA: 85456366758.30.6687024
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 02CF2180006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:41:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uuc2RYGJ;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795200118;
	b=tKVyXhMUQEdPdErssf2yqdP1vEUGZKTgmh7e3DGHoMuKLz6Z2FrsTC6dI8z/qpaqeIihIv
	j57G/Ruuwr8HE2FHK3DwGdbZ86BBmsF1nIZzEfEOjhGHdUsvvECoe/SK+dMQehL8f4nh+L
	CXTznrPp4lvUwGMcfKqRvcLplAuHW80=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795200118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZVKFrUy8TyPqGvyWghVYdubKdFhARMdxJahZ4dEGHE=;
	b=hf5n4mQOai/YH4bq03sVXYC+LYBVYyv9+cJOgtxi8IEO/e0ZIK43dRr4PMq6oWFUU/cK4M
	pod8zRz7iuHRi79+lPzQQHEFZmEziUR1t0sfQ/bnCf0jXWMcoO1JVOSIyvVg2TsFiDXqmw
	rs4ic+RGBmXVgZwbNrwy31PqvO7Rkok=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uuc2RYGJ;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-9211bbce3abso9725756d6.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795200117; x=1795804917; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZZVKFrUy8TyPqGvyWghVYdubKdFhARMdxJahZ4dEGHE=;
        b=uuc2RYGJUNB42Hxs1fsP7pRzmBgEaB0MamHm7sS5Oq+LI8Wtj0+W6JUT/9w/rwz9yg
         DSBK5jwzvnH/S5jmVMuC2szm4mGvM+SerVPG6ezXYORsZjQc45hWlXmC/WCd24NCHJ/A
         4hf+7GVdG/eXsnzqjJOj2bj09M6np99P0ZvxdkXRMaRSafUiHmstwXWmkyD/dP4qeP7f
         OleA/DgrUT7j+YbdPUiCnrAXX5bJ/BsfVKkAQA0KmRSAWrJzOgf7EQGBQFTY7gc1tAA4
         IA30u/WgaxzsFtyZw3B5XfhBfb8YHi9gMveiBhYcVEFOWdeKKw/u3+VhJs7eWp6bUNxW
         TmYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795200117; x=1795804917;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZZVKFrUy8TyPqGvyWghVYdubKdFhARMdxJahZ4dEGHE=;
        b=nR/dSpJGWOL1+nIAfNl6fYPkfAHj0LBY1wqDzPnlgc2c6zSpGOd9KPaR8J7flKTM/Q
         ZtWrJ6xhIytJWHuHl6iy2YMZd78YnMQBT8PdGtSoKkW/tFIUw5SHlfG5tQb1fIhds7/6
         Oi8eu0LEFhFe+tjoPcwYSIQyKRaYGgIwTcQ5He88ph8fp2m7LftGuR0Ytj31X3pewyom
         nbPKGPf39oJD+WnhcffcZdKZg1lgg5TGQvF6wiMSvRG1zFyhFS+M2r0wPTxiKH/b5P3o
         VESouJT2Kwcp7umO7heZ+b2L0wSV/CwdRILUw4XaR6GcQKnM+/nwiXWJ7eiaW+/U+Zkn
         NW3Q==
X-Forwarded-Encrypted: i=1; AL+hErEhlEgMuZOy2kAJndkkw54Gzjqq/YZ212RuGwFOMpAs1yVmY2SYcUa72BueoeLpsM2jTJffY7Kf2g==@kvack.org
X-Gm-Message-State: APuU4Z++G9xLra4y+PgB/NkAo0FOyvEMOqEVkjiOPnQTnHTR2XNCBC2l
	OUqVX7Uw1eZqFL5BGJiQd1cp4KwUcWcFVCKk5CYIEgi/MmjVZ06K8rbPr2YeVUIitrU=
X-Gm-Gg: AZFdTZfUtjeTUf7qIZn9QQZ7LMj5Z4xCmWeV208KOcRIqdQz7VasoYhe+KcLCurbDKi
	WM8Z/6ZS8rU/cpU2hplvjmoFkznhshaDSy2j5y4BmV+DmEFgfjp7YGO9ddRs8XPGjouUVxfz1tO
	MvVOiHo2Gwa6IUkjSNH4EzKQT5GYwHg9iJ6woElhZa1bqTmMyT4EZfizfQQmFS2yUgptw5+l22+
	8F7c1pQObQmrYwlgfE4pBNTT9OlAAyi+WiU+OBXewbA5tfrS3aFdcvyRwHyI5l/micm077YxMWc
	cLlovp6eadoHV8sFlottjXYd8wl6MoOfHjSCYvBx1fcc+ZSoN/ZehQ3W1e4nA5OGCUUoy24hHb9
	1ftV9qPIl5Vy5kEoMrbE7qA2aczYQK3o2nFsKO6Z1bpmtAltgy1EVBFiAPu4dtvq5q601InycRW
	3lWpk062YapgnNbgWXa6c2IyypqGBmhKwg2hWkbnZ9W/GMMhNk+A2strb8KZ381/yPeGvUPdNwh
	xcPHzDykWRMYdoQvdqx36D5luntGSjUtxPQRFzNxA7VsrrIHFVxSCkDlpIZKCbR1oxyiIto5Mml
	VRySTjrZHwl3xyznNBomPmdqHI0nZhNqEWh1O8vFu8AsUITAhpZCbn2CSZIbdftJbHNAhtZcn4H
	AXPLKke+eMezG2wbcyPLPWakF3qJo
X-Received: by 2002:a05:6214:8207:20b0:921:33f6:8a51 with SMTP id 6a1803df08f44-92134b3e14cmr55307796d6.49.1795200116964;
        Fri, 20 Nov 2026 10:41:56 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349d14d1sm33275916d6.18.2026.11.20.10.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 10:41:56 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 47/60] mm/vmscan: restrict reclaim to N_MEMORY_RECLAIM
 instead of N_MEMORY_COMMON
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: sashiko-reviews@lists.linux.dev
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, 
 Yury Norov <yury.norov@gmail.com>, 
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
 Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, damon@lists.linux.dev, nvdimm@lists.linux.dev
In-Reply-To: <sashiko-outbox-225854@kernel.org>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-47-74f5f9a115c2@gourry.net>
 <sashiko-outbox-225854@kernel.org>
Date: Fri, 20 Nov 2026 13:41:54 -0500
Message-Id: <179520011480.412063.14337787866519317378.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 02CF2180006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: twgp7bnu795m4tky46y588n4ide7g3oa
X-HE-Tag: 1795200117-159126
X-HE-Meta: U2FsdGVkX1+S9WY4Ierrg8RbUJHKJ0rDKG8kN5TteigwT4Sj3VqZjc9JiyEpHjtFjbTGR5dh3zZMWZPt9M3IB5HTaSkGCFX9mxhYa8pmZtyXr6tORH31x9RYiybfFTaKFqOPUWsRfQbeZ3UsMIiM4dAtqtKTkfjuvpEHR9Vv2sIHCUDjSF+tfGR1f16/n1LQ1TynHbkxbZz8dPgpOU65YRHGTHF5HI5XShkeiBV3HGguQp/mxcd2ZDJ1oVg1I2mD6+yMGLBjlormFHwhFCS4l+xtLkCenhHmh2Lk0fHPo35faefvforyihKiYJLpq9J/SaiDeuPfepjxWdOViVyNbq8FJ1Z7Dr0MPoaSolBL+vSdAi4W1nfDvzV5zx9Cp+1uIWVFRMZrLv+E54R8PoVgHEsLjbrdwVJoUwsNAmSGLrAxIbVl2XpIGngRdEDf2ydvUSExnps4fjsql5mxVd3LCbpRm6v9dXJaWKIMTw9acq4uqV+vRcjfxRPlrezwulYuk1Q/cX56RppS6o9kVKrOwt7txtk3C9Qt4Jam4HeNaIYt9iwaHv1zP4udOikwZr6BXT5NjtZTGIFNJ79LDaB/Xhbt/fJDUT3ZWtra9ZOvdBASd6y+7ZiCOOyFmGuF1YgQ82oYQbenvlMOtaN4oFlWu5l9d8obkhK5J+XCz4ftlZHCf708q/4Dupjtlx2BV3ixoUrE7u1Y6m1dTyOreLdqXR36XgIxXMsPHYWPqjn8mxwks0i/0tiMTKWYgJ0g6T7q9n1HO44NAlyzDVhzo4KOAA5S6xB7S4/iHJS+0Gc1LBj/Zfwvyww+HdS8Oohk+KAk7FhGyODGgUAS+d7IdWCRhW83V6nR0pw+RX2oa9K3OZ9rol1/XAJ1LDO9ULERoH+IOHkgOvevCWem7ycg9MikRRFCUHp4LYvTh3iSvGNJECGlHyAbmEdmUAQETKy3+tpC7Oh2QosKmBONSeHKkcJ
 OpiKeIGd
 3qlzgR09/y5isJ8LL4ijrxVruNK55WB4NqGaNKyj6o+GF22aHPKY9AQjJYf+qFPaip5U3vkQxMaoccsgNI4Iv3OWSYjoMV47bUFxkxsmCnceMtSW7WQ7+oE3FatO/bSnET/CzqgVDTMnQuIpdBiwRoPBgZsB5RxMRQZPxDns94f7sfUyYu5IUxgu8kIYZDznsBY1fv6eqRRT0he9x++S17E5AAsX3c5dwDKFa+5tBuBszOY93d0dGd0PBTkp/+vBWPurxezOisY69baQmubh3y3mr15BQRYNpYtIxOx07/3/VqvWdiwYZu37GPd2r+trjW4EHzEZa2O67n+qtXU4fMbHVsEb+cRWPZwpVJnJ/Oen39nrNhprEaDpDQNlLGYGg86F/hzcvw9AEALlLvGs3gEvJETNBUwjEqKQeIwKhDALDPHtnkZ7/itThS0nDqTtgbhAczc/botz6hFfOS7HQkgHvtmvFR3rh1B00jkdmX/2sUccRFEKMYD+pYI2W0FKfx6Dyv3UstagMbqynyDoYJiN7RUynzJxeVNaYuLp7gw/5yQXew4TV2oX8srabzMluC2ZDCbSkn2EQfW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-20 18:38 +0000, sashiko-bot@kernel.org wrote:
> > @@ -7907,7 +7907,7 @@ static int __init kswapd_init(void)
> >  {
> >  	int nid;
> >  
> > -	for_each_node_state(nid, N_MEMORY_COMMON)
> > +	for_each_node_state(nid, N_MEMORY_RECLAIM)
> >   		kswapd_run(nid);
> >  	register_sysctl_init("vm", vmscan_sysctl_table);
> >  	return 0;
> 
> [Severity: High]
> Can starting kswapd on a private N_MEMORY_RECLAIM node trigger a global
> OOM kill when MGLRU min_ttl_ms is set?
> 
> When kswapd runs balance_pgdat() -> kswapd_age_node() ->
> lru_gen_age_node() and every generation on the private node is younger
> than lru_gen_min_ttl (or all lruvecs on the node are too small or below
> memory.min), lru_gen_age_node() invokes out_of_memory() with an
> unconstrained oom_control:
> 
> mm/vmscan.c:lru_gen_age_node() {
> 	...
> 	if (!reclaimable && mutex_trylock(&oom_lock)) {
> 		struct oom_control oc = {
> 			.gfp_mask = sc->gfp_mask,
> 		};
> 
> 		out_of_memory(&oc);
> 
> 		mutex_unlock(&oom_lock);
> 	}
> }
> 
> Because oc.zonelist and oc.nodemask are NULL, out_of_memory() selects the
> highest-scoring process across the entire system, even if that process
> only uses common memory and holds no pages on the private node.  Should
> the out_of_memory() block in lru_gen_age_node() be restricted to
> N_MEMORY_COMMON nodes?
>

I haven't been able to generate this condition, but I can adjust the oom
control here accordingly.  This should be trivial to adjust.

-- 
~Gregory


