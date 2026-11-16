Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B43606A337
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=oo2QFffv
Received: by kanga.kvack.org (Postfix)
	id 60E636B05B0; Mon, 16 Nov 2026 16:31:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF5A6B05B1; Mon, 16 Nov 2026 16:31:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D57E6B05B2; Mon, 16 Nov 2026 16:31:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23A676B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:31:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84C11140216
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:31:56 +0000 (UTC)
X-FDA: 85442279832.13.3206909
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 82744C0007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:31:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=oo2QFffv;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf10.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.51 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794864714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7EfRJISn/BExC2Uyfk6fqc34lLJlumeRMbZF5bLNv18=;
	b=BA/uA4iiwmbzbL6VU/gvOfFDW2ZKCUEM2DwhEa4GkJbnEWQpWUDME/VCe+TxbtzTAnipRb
	ILOgwotpXzX+FHZTPHi1wrM6xeQmY0kbhkwABC2pvZNubrOvavP85eq57+QeD6kPfckDze
	+W7zhhL1cQjd6+Tv3ba4J3jYCTOjq88=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=oo2QFffv;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf10.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.51 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794864714;
	b=qSlHnD7/vL5vjolYidpFXrVXAFrrztcxPzROflArdm8KY4bIq+fUX3MXUDNpcuGF3LLI0V
	4dVwHOYYmdqYrRG4KGxyZo+34TDm4n30ADEVjFawhyv75eJ422XEGez2r214qC7eDeTdQY
	4UD+FWRwqCU0l0/rQV0s2Nl6VxlOisI=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1a3c08d6928so5509668c88.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794864713; x=1795469513; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7EfRJISn/BExC2Uyfk6fqc34lLJlumeRMbZF5bLNv18=;
        b=oo2QFffvNrEgIgJ67rDzz4TaT79VyUIieATYRWlQpMza6lD2Iq7guSE619BRTFEXSI
         CrwCxEX/E8mejCAomWSvfHN/q7ml6+zSev2n1ZUkogW8igQqB3j810ud3mbP1W0o+afq
         E2TKz0xsqW+6uqpF7tTV76NLw9JV5CmIFlWNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864713; x=1795469513;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7EfRJISn/BExC2Uyfk6fqc34lLJlumeRMbZF5bLNv18=;
        b=vmTu+37Y2hDtV1yEcs/atOPAph3ztwvYD+cLmipP5JHW4uLqquzSizDgzGOiS0Dput
         zvwIl2XC5Dx0IohENCg0UmCqeHbo2eoNbMaIPT0XeMWiGCzurSjHj+g4E1JUP62xYnxQ
         /B+0nbi261KEbWfU6AEZw9L8fVJv3TElRwPF2jNrQsjnBLCaAqY8s5AlZTH0Rc1QdSoY
         rtHlRMlzz+2BqgvT8T8WCYYEMIScZvRtqsDk/H8ihFQTNDunlV8GFsqP93plVc7H3q3D
         Cc8uYdwibn19fmWW4m+1+3gjlao2lt7rYioYm47hG7RgwiYg9uw6ngP1fLU3CJmCNKrY
         pqsA==
X-Forwarded-Encrypted: i=1; AL+hErGNLaC+/TvLiWexQabrnxPtyFRvGCt5bZe9z3uE07oqf2KdCUlaGCmW17wMi8nwmE1UMYpy9T+bfQ==@kvack.org
X-Gm-Message-State: APuU4Z+F37gb/gVe1QhIX0GwyvvPqFck1Va2GTWg2B4S/dyR2SvRWSGu
	7UwmmLUVpGIKp/vov9/UmcNtEc4gMFIXTaqQULAhRq4+sZs34kTT8v4gK2UTPD520PA=
X-Gm-Gg: AYBFou0y+kMLZQBCRsuAjVcRtrIBivy/b54iZwx3G07q7ChFZ3Y3ZhY42/EJUYPjf7J
	6oO03BKGy7ujF+JrYMHpn/VwyPoZ5DzIhGsKLEsG12fa7ghXxKQ7+uFQWyZ/u1dOI9t6hoYfnWC
	2m6Xt4b0X/rYOQMZ/MjZPlyNL1fMyAKy570o+o2lSMybMhMC7bJWcxxJsbbqCu7HL9X9HFLr0q1
	bwg2elCAc/StaZeEeEEcB+lFHWKtLQ4c22TFo/OQAeJM3dzoTZ4dJ3/L5AA5B5tx8YnuHALmKAw
	zq5jSgNcYWSCEZ10J3XQAJTTP0jCe+xoM98fVIwW6grqkzEzB6HGWJ+vriIDzNljazt0Sf+AB0p
	pfmvVwcWHiWiEpTvQ5NgYCmhngwQvAlsEfxxWnUYovgtMo4LFWhTtEz/z7d/+XjEM0DmjZX/+0g
	5gNPAmpuITlsUvnVyKeoAd9OTe71vC8mb5CwngnZdw3/R/Ht8nErtZhCjcFd6LXrj7uueDOBG0Y
	QtW3GrwLjorJYe539ZLlcpWSsHrZCBdbm4XXzzA3MJ8Tqf7Z1FFaJSPZftVrPbaCQyGEFW0zDJ0
	T1Da/5qaH6b7rKE5Y+YOxfk3ec/S94LclDIvTFT4l7QuNlt2ZdHwffpLEpYH5MgqHuk1eDAeAtP
	JhDz8YZQR8TdjNY9Wlh+Ko5l9x3VHjBJjDLu7HpSlnrj7+MgyAH4QMizOa5RETTJrZlCb0CcY7U
	BLQ+JmUlLICyQUZwpEdxFHjkukkuhfG1gQmIw7+iOGFra0Gb3Gy/dvlgn3tgee5zR5Uw==
X-Received: by 2002:a05:701b:4508:20b0:149:1b5b:1f25 with SMTP id a92af1059eb24-1b50309fa41mr11275170c88.15.1794864713351;
        Mon, 16 Nov 2026 13:31:53 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38116afd7f7sm1285217eec.17.2026.11.16.13.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:31:52 -0800 (PST)
Date: Mon, 16 Nov 2026 13:31:50 -0800
From: Chris Down <chris@chrisdown.name>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/3] mm/page_alloc: move the kswapd node skip check into a
	helper
In-Reply-To: <20261113235238.3595412-3-joshua.hahnjy@gmail.com>
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
	<20261113235238.3595412-3-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avt2RrtFc-G04JiJ@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: otm6rg48r7wfq14quyk3krni5q1axptb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 82744C0007
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794864714-912428
X-HE-Meta: U2FsdGVkX1/0WlzpgDP01QamIGnEk0q10od/HcAg+7daDaeLn6ZyPv4+554gqQOqajbqKvGS5B9leF3+ByjT2H9Iw3nL1lP04lnn+NAa0DKIIHe9sql/1yoh1IQLC7eZbgOWynarcrRZj3JJg3MEWBd38fb3/AQ/iJOr4Tt697+simahQNcKfhLrupf0b7znBWgI3yamOcbrm0DOTz+ap5htieudkT5sRGrJINcjb3wSNRvA65N6b7gF1HBAXiLIBbkiKfmCFwc2Qd54LbGfm71S043DA/mCNXV5oFraOKpUn8ko/z2jhIuKI95Zn4KWqyG9uGTQk+v3kJoCbRG5B2zIBczeM0VpmuF4DxT1IGysTV4bWiNJXVlhQXZ0R/CoD2PHahceQQ3KA47O2jv2BuS0wcSXaBgjmT+2en8IyqmG6CH10ZJ2BUF7ghF7xhNK6FPj2bF6Ez9pLqFrjr1cOMi9GZ5yXqzZCqJvb253LcsuU9oUwSCGJSV7a2wxu5+Z3+7v9rKAMzSio/nECNmJb4iEgy0mPJcKn8GWfsOxGnlSMqtNrhPP9j2Q9I5KvDIwS5NTZgHfKn9L8k7WI+yHWFldbpVflcF4aL96xB848nS0D4MKjztnaU2XAvRfEY4IOB8n4lqHxcAaZtMB4oieViJfsaNXmAnz8Nq8C4lCNtam1bAEbzuPxLAScRXPuj8GI7T5mQBvttSPNt8l9D6GYsqyaxSn6nFhmUd0ePoryl2c6q/wviS/zVOZlgXwB5rMo7821uBu161saIeyYqLdj2wWuF1x0OXHVq/FklfQ6SYlIeFooSJHaeuq+YehrDTAz8B2T5uCRfjwKSQvP5HmjO0Ev7L+rQ8Yj85PcAzJOIZk+389ACbKBEJE/64rbmGm1lOuiVN/139VxdAO0N299EIqcCStWO5FpqoBEJywDj1raSip1NUXdClTAqWfJ0vcBig4uQFTtpry+ohqJz/
 rNxPAEl1
 pPITLmDyY2cf5E3tGfmZJpDMqpzHpBYrWmY7ud4WU7teJJx+FXw3kRiqiC7pDq2w3mw/yLmWr89Azs8cUoSxgBB24YhvztJ/FfNKKCib5FUnqzLjXr68hFlwAwQ/FTPLdyEES2UHF0ddufIvX2airXjkJDwxHPnq+EqIIvC6lq3M68XT4Ys6Ef/dpvOZoUK//pDgzYswFYwfZ0+jBidMwmGfbl3P25MED6RqQQGqaiQmurKNBSJTsB6HCmOIdcp9jugNmQu+CBRMFZl5t0ka0kzbx7O0tF8MJt3Co/uOb/ikrLv0tVJthYwA+7mNtMCKrOzHo1bRbmXD6f8/hxur3H1/WzwqdVCK+0V22EQcmnsgPgrQOClJQSCgmS/R193G6WZrtbqju7ZxvveX0zxH94sLO9YZB487e1fltlUxALmBlR+K5fdCKMYbwhkgqsXCpuA4wejlsQ4oYLShfD9fCg3mZf7avIclwg8Jp4WasJDBR1PeH+dE77JNkbzUSNXUCjrsnrDQ7fSDcFGe5foDawLd0CGnqT9LjdaPuJ/uMT9hU83X4AOu3kfGsEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Joshua,

Joshua Hahn writes:
>+	/* Lockless check, a stale result only affects zone selection */
>+	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
>+		return false;

Not a big deal, but now that the test is the other way round, this reads
backwards against "If kswapd is already active on a node" in the comment
above the function, because waitqueue_active() being true here means
kswapd is asleep on kswapd_wait. Maybe say something like that
kswapd is asleep, so nothing is reclaiming this? It needn't hold the patch
up though.

I've tested that this works well, so either way please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris

