Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EB25C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815C16B00D8; Tue, 25 Aug 2026 09:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6D66B00DA; Tue, 25 Aug 2026 09:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7041F6B00DB; Tue, 25 Aug 2026 09:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4545C6B00D8
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:54:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E26AD120408
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:54:46 +0000 (UTC)
X-FDA: 85139937372.28.86CE100
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 15CBF14000F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:54:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IZrlZfRB;
	spf=pass (imf09.hostedemail.com: domain of sef1548@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787666085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hJUjDtXJ/jwDQ43yJqCCQ+BzF83DPTYawiSXPF0jph4=;
	b=Teli3+wtjAQPi8/g+f1XEnlhT30Nr8CkcnotQYTRMuzqXeqXJX+gGaCvGalDnhdevNFZgp
	pvn5wznHb9ppJUG3OOeqzmp1pShY3TVBVV9Wl22JfGdrWSLi6sqU4zN5yZcb9wjDwT4Llo
	d+V1n5h/hcv9pVsgp7G5nGlj8kirAZ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787666085;
	b=i6YK9mh50IcdjdSqIxnus+uVix0Z1Rv2Ph8BL2MVDVVM+y8SxH1qe/Z6S7694fGBsTYrdr
	kD9PCJnC9BtkqlrSowbZJK+2Tcb856lbPQwhkCg587YYSLZiEhh9X5YcorhtkmGNeFDOa9
	6lYi728Mafx6y1atuen6rn+vSi353KE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IZrlZfRB;
	spf=pass (imf09.hostedemail.com: domain of sef1548@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a422090b14so6430588a12.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787666083; x=1788270883; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hJUjDtXJ/jwDQ43yJqCCQ+BzF83DPTYawiSXPF0jph4=;
        b=IZrlZfRBJg+FBcOOWfg0UutxrBfLaj3/VXtUYto3X3i1Au1kFU6+3L/QvGEH+rr39x
         dPoaPl1EkmYq72KyW2M4IxAjE7UkIN9BY4jcowNwWkpPsZgZ/lyiqzghMmCKMUL2biHD
         eTUhe3XXuxSIo4DUxsSXIusft4yta58mf9Bb5rKkMCkvKiyR8ua++c6NX9fE8ZWSk7Tw
         kTqCyGAWmtgSRVA0wvfs8MASgi0WqTW9DixGwuzf1A59mzu/dG2NUqep8wKLsu9hT7sU
         lO9cUUUZFlX4dXNZVwEqSwg4Tsyvyu/2W+Sz/fuJ1cwUS920jdZbeoN1aQmRTgDBIO2O
         7DTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787666083; x=1788270883;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hJUjDtXJ/jwDQ43yJqCCQ+BzF83DPTYawiSXPF0jph4=;
        b=qb1qWH5HaKRGFHuapsun3aI7wpXUxCAfCumqWWX4YlVKz5+1fCnOdPKYDqHUDwITEv
         a9Jqc+4yxQnMdIt4J21uzRnNMgr0wur7lebBHH0XTZd2zTeyB8IUe9AY/e+Z5pVPxWNi
         UKJpNBPv/eRA4IjpOUdvkmC3917B5rSMapR9/MEjrP6p7p+2NFOZybNA6iPTPwj1mQv3
         HvfM1OZtwE3XC9KQ3WSdexA5Adjngx4SO1TqItlYvKIe9ck7DoofTyoSfJRXGYSGMEda
         xlVeoHKrH9kpNhLxAakyEr46LVwbVo1iZ2bm1XBFcYPtNDYq8+zGU+FlJbn1zcseaGRl
         S9Rg==
X-Forwarded-Encrypted: i=1; AHgh+RplBwOO4R4og4CP04BmPDyG2Vx5w8pa63tWmzQtCuoRztFehXUzZrfiTlwV6JqHSUWj5dF941sJ6w==@kvack.org
X-Gm-Message-State: AFuF++luislpZq82bUmvge49FJXOQz3u/syUg4ndXxcjZyzlc0nThCUr
	hydDhVpV3OVCh+92HQgAqGBeFwX/Ase3hgy2j1G9NWPh2HQ+i/BL2E8v
X-Gm-Gg: AR+sD122HbSqCK05TmtOlF3FuQThuFc2wJKE00mAVQAWiJYOmGhz9y75H++mZqrqNWj
	KK2qoXVxZClrvo9Bte+6unJssRl1mb67ohvff3frHI2xajKp6TWh3PS4GaLE5swVPONo8+tpeY2
	cx8fC2vdPyjU3cmO9MZLXhrKtqPPoaL4Auh+bdUl3iJ6O9Pq5XKNFQ48Rrcft0yCrPk77KzMNLV
	2QweHQ1c2gXXW1n0+rZYuy4zETelPt8WGGnUHl70bKqfmx6WiW1EwW/EGpPEbKmbbSYXqCJ+UQn
	RXLcXl1K1YRkaPdTQgBoN5nPP4uhG3JGlxmagZJt7NcfVYL4GDNgsERBkSibv9PsFhCYmi01jMQ
	ndEvYPzHbF5M61oWznAKuidSEwfhVwVrXg++32TNdYQtg+qdKkM4SihXb2DlqazhOwCrmjaXkAI
	dxNislpAge/xGofXXbM6jygJF5zlEqpnDWoy8QBB/yV096Nz63nJcYnh2s4Xu1zmHXOMw7VEypI
	1ROkz1qmkK88NjUEQR0h64awm9g+A1cYxOln8RnE/opIg6k1nw4wdJNNlVXpA+ho8MqqLjEVOVs
	l8BZR5eGM6Q=
X-Received: by 2002:a17:906:478d:b0:c20:31d1:a89f with SMTP id a640c23a62f3a-c24921149camr2705228966b.24.1787666083234;
        Tue, 25 Aug 2026 06:54:43 -0700 (PDT)
Received: from nickhuang (2001-b400-e2d1-934f-70e0-d480-12a2-0163.emome-ip6.hinet.net. [2001:b400:e2d1:934f:70e0:d480:12a2:163])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606b5aasm1843939066b.4.2026.08.25.06.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 06:54:42 -0700 (PDT)
Date: Tue, 25 Aug 2026 13:54:33 +0000
From: Nick Huang <sef1548@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Zenghui Yu <zenghui.yu@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in
 shrinker_debugfs_count_show()
Message-ID: <ao2emWNMkthyVXn6@nickhuang>
References: <20260610232048.62930-1-shakeel.butt@linux.dev>
 <aoxKKXjs3o6jUanE@nickhuang>
 <041af2b5-9136-4027-b35a-72e5044c63ab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <041af2b5-9136-4027-b35a-72e5044c63ab@kernel.org>
X-Rspam-User: 
X-Stat-Signature: ok4nptyqb5djrxfqt5mdrkua74b4u851
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 15CBF14000F
X-HE-Tag: 1787666084-854143
X-HE-Meta: U2FsdGVkX1+xwWZOizrJKbNqLQ8vL4QzV10oJ5mRNie5GuqY3887W6T95tVh6VUQ1La2080V7YrSMpKzbfy0WqBQSWxzVhkBctExAJIHG8X5ECkYOiG1a+hSM76ruslfswJ28W3GwgzyIGY8A3rNaaXAmkz0vl7FX8NkpqzIc5qC9dwxGgPb1Al70B0oZ8pgLRVtSkAp1VN2F436+94du2+XFpsfvt4A5xF0vdnoTaIq0qMqapnY4kLKoHQNNRdQ4B/W9DdkRaH5wpnLTSdPizP+Z10zxWq6gxKoS12ufwNiKj60trvci7jwxILOciJeDOABRWH46P0BL3gTd1ZaCj1f9+cGqt1oVmwHs1R/WDqMxSlxrMouvv8hVOTR6abd5dpbA9LpYYvXKM9Nx6P/vUmplmZrzuAWcILLcRiU2d624WLSzcBCXcUAsHpkVPzUc4wgHTJ3XFOT/zurKRcQpSrZ2CQrue9lz1L6Lekhvb4hU07Jmi7rml9NNJz+3HA+WtFZjfmwDXyWXL/vANFBtetR/Vkg0SiqCK2vxXJ7KxsowooD9a3sb5cuDg51GPGyFknq61EV8v3vRIoGNR/TRDG9tFBWY6HsYnWWoigEc+FBuljwIdpqswQdrySZuaruXoRKQ+SOxhSMlKYwg5Ywhy0EbJFCT43GGl5YAbmv0XW+tkg/hJhxbJKSr5KLdP5sikFXbuummiWEz2hK8a5OU8mPDTGBSvX7iywDP9oxw7NxvBcoOJd5do/BGrcSaQCl6bR/mDW6hPoiqYooM1lzBxEIyOeKru4xHuE/ZxIR3e1WEXeaIYEicYgl76BoHbw4f8UKOP1QoEOrnitsutuvLjNkyhJh0LjHH5B7FVkEDi2dLqIWxBhCImm7ob8+U7z6SlldPNKDvJUUxGwCGPldsEkKKjn5U/8jaYPUD9cmDcic4YYzSMAZ7gHnV0QjnPYeEIV4kobnNfrKlH+5KA3
 1yHytgv6
 gyEzXEoMqfi/aipUbC152eLF/6sfCCNtgMsgjtuKVd2C8mvbDVW78F6t+cn7F4An3XO6GKbVILiNe73njl/MKOTBjvJxRZ9D4VCooDc6oRJElJz5DneK1P5gxbNgYTxxCYPtjXee+qBaP0buI4sSFG9m3iLph1P6H+53BzFx5NkVujsGMgWIH53T9GVutrDhYDqyX8yfCnjwHe5ohZeq24ekmQxOmtAmWM3yIIbo/babYoi4c3P8E4nlq9Ipx+uVFS1b//2TFeB5QzXqvRVBrch8t5Y1fcienOSS1M4oj/0Dk/xvjVjDKTrYh7ysrRyl0ZNOVB4Yju/ddKOpjqeRrSq5ZbA85KUsAGNZOwSQjxFTcWtGm4Um9ZoeWcoY8zqDldgGxlJqUzCvaF37+YIB/HDVz4/SIN0hmWUXb82/+l3pWpfPZw2E3VGC8VfqeKzEmcnoApDIL2Tv0TfPUy4vj/fsl61EbTLsWoaBOliVkMnX2V8rSPzpOTrGbAl7t/OgQWCAG+bkoGvv1vU+lnu0/q9uTXtEJQpO5lB3R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 08:12:09AM +0200, Krzysztof Kozlowski wrote:
> On 24/08/2026 15:42, Nick Huang wrote:
> > On Wed, Jun 10, 2026 at 04:20:48PM -0700, Shakeel Butt wrote:
> >> Reading the debugfs "count" file of a memcg-aware shrinker can sleep
> >> inside an RCU read-side critical section:
> >>
> >>   BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
> >>   RCU nest depth: 1, expected: 0
> >>    css_rstat_flush
> >>    mem_cgroup_flush_stats
> >>    zswap_shrinker_count
> >>    shrinker_debugfs_count_show
> >>
> >> shrinker_debugfs_count_show() invokes the ->count_objects() callback
> >> under rcu_read_lock(). The zswap callback flushes memcg stats via
> >> css_rstat_flush(), which may sleep, so it must not run under RCU.
> >>
> >> The RCU lock is not needed here. mem_cgroup_iter() takes RCU internally
> >> and returns a memcg holding a css reference (dropped on the next
> >> iteration or by mem_cgroup_iter_break()), so the memcg stays alive
> >> without it. The shrinker is kept alive by the open debugfs file:
> >> shrinker_free() removes the debugfs entries via
> >> debugfs_remove_recursive(), which waits for in-flight readers to drain,
> >> before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
> >> already invokes the sleeping ->scan_objects() callback with no RCU
> >> section.
> >>
> >> Drop the rcu_read_lock()/rcu_read_unlock().
> >>
> >> Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
> >> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> >> Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
> >> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> >> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> >> ---
> >>  mm/shrinker_debug.c | 4 ----
> >>  1 file changed, 4 deletions(-)
> >>
> >> diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
> >> index affa64437302..cda4e86428c8 100644
> >> --- a/mm/shrinker_debug.c
> >> +++ b/mm/shrinker_debug.c
> >> @@ -57,8 +57,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
> >>  	if (!count_per_node)
> >>  		return -ENOMEM;
> >>  
> >> -	rcu_read_lock();
> >> -
> >>  	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
> >>  
> >>  	memcg = mem_cgroup_iter(NULL, NULL, NULL);
> >> @@ -88,8 +86,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
> >>  		}
> >>  	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
> >>  
> >> -	rcu_read_unlock();
> >> -
> >>  	kfree(count_per_node);
> >>  	return ret;
> >>  }
> >> -- 
> >> 2.53.0-Meta
> >>
> > Reviewed-by: Nick Huang <sef1548@gmail.com>
> 
> Sorry, but what exactly did you review here? In the past you were
> sending AI slop:
> https://lore.kernel.org/all/aeNGbNyPxJssnkbO@lucifer/
> 
> Not even properly following the process.
> https://lore.kernel.org/all/20260724143408.175870-1-sef1548@gmail.com/
> 
> https://lore.kernel.org/all/?q=f%3Asef1548%40gmail.com
> 
> Why suddenly reviewing MM patches?
> 
> Best regards,
> Krzysztof

Hi Krzysztof

I saw this patch on the mailing list and was interested in the RCU issue, so I looked at the related code.
I checked that removing the outer RCU read-side critical section doesn't break the memcg lifetime, 
since mem_cgroup_iter() returns the memcg with a CSS reference held.
I should have explained what I checked instead of just adding a Reviewed-by.
Thanks for pointing that out.

Regards,
Nick Huang

