Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207FDFD375D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 06:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31B3E6B008A; Thu, 26 Feb 2026 01:42:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C59B6B008C; Thu, 26 Feb 2026 01:42:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D56A6B0092; Thu, 26 Feb 2026 01:42:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 070FB6B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:42:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 964521409E1
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:41:59 +0000 (UTC)
X-FDA: 84485662758.07.69AC68E
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf14.hostedemail.com (Postfix) with ESMTP id B4C17100004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:41:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GH10D8cg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772088118; a=rsa-sha256;
	cv=none;
	b=B/+Uo16ShUL/POmdpO6QmDwjRJJlDenoI1iGQF+Kx26lfOgSouEf0wArJim9CWjieIYmtd
	OND2lvpBJqaAaDfvKD1FG1hilIrLKbRoatwsUZwkTl8JXY3GEHrSrish36nwy/FbOYdr+G
	uQ6QurJe765r8qpmr/vpYxcQtTsOUm8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GH10D8cg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772088118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsoNYUIXRY4czYRyOTo1YFJNlOMgkydQUEar5VWPZRg=;
	b=vaRPzC+w5+c81BwDTmzR/DBcy9ktTyRcI2iGEc/0MsggbHMdZPzEa6fr1gS29AYsnmoGDQ
	ge4seTGGRMhaXMcg5STDuPwGsUaewwRNEppQ4zpaRTapDKEljZod0kPfwIfP62Lqz3lK/A
	PDCP2n9Uus/9G4L69cZFHGJQCs3P6N0=
Message-ID: <d89afd07-edd0-465c-855a-935b9b55e93a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772088115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tsoNYUIXRY4czYRyOTo1YFJNlOMgkydQUEar5VWPZRg=;
	b=GH10D8cgG00SB31h6Il+LdJp6YDEXP7iGFxM0pnb/8gXr2wwfPQG+sYIw33iop0X5PIo1B
	+hcfWVme3JF8m61wizbiW6H/yAozr3BC0XTEKplh1nqIa774Bm7MRC6WZWnzjY3WhrTvAq
	i8y+roUbkTymN3mBUEnaPjT+YBppHeA=
Date: Thu, 26 Feb 2026 14:41:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
 usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: y384kxqh1bfjghqzo74himx4m1f4dehj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4C17100004
X-HE-Tag: 1772088117-882609
X-HE-Meta: U2FsdGVkX1+RcegqpkoXz8adNtoZ3m5CZnBTFPuBBbVzr7RBBQy+8ERge7soJvgtE3luFZQK4G1XJvVdGPv73dYplvuPsRmrNpIBMLXYujDaVBJitJO92UR1A6oxYASlUYwXQnLaxA0kc8Aw/hL0a3PgHBPX0B4S3KVXOVlT68Yo3phJ62GsQivV4et6ssCy2qy6tAYpKsUKlNYvl5EKBe8Gs+6VALFMhell/w2Xrdul/kiITrC62+dGRA2GxT8a0J5BhUobbeI2YSn2qnJ3CBwJLogskNK8SsWmxJ+eTzVluxDXRmjsaxcaGDB5VUdZ97KJ7k65tUmvVub9ZUGigag2A4hR0oh+uxqmPhTyodrmO2cfC0suZlYvieZFSroDHREy1fWWj9o+Kw4em5bfVFfhgq9Pbj489xtiOCFqUh0Ry9WapKd/gwH6XC+h7a8FT/Y88l9RRdSfwXa6E6HcWmxjvbFBwJ2y0spLOzfVaRfh1K91+OsAOHcOa8jmFJ9jO4Bb6j8swnwhvzQ3YCEBBINZ8H3/6LKS6o9t4mlvJ35sJa0Y8ngxh6JZAPxtcH9vOn/FJYAukdd7eOAfaHmOUV4lHg0GQI9B/JV0r++f7PCj2hdb1PnJ//22lWHsBf3ooVOwO4X7rvHCYEGARluJ4UmvWGxTWicHTOIFrvhDIwqeenSoksq166K5Rwyu0efI2AIjkgp5aZYVGgYE+seTta71LXwzA07oNC8saCBScREhRGEdKP31iNBWbTrupKdLWKpAEFdKVn/2IiP16oR+lXWOkO5FIZ/qQ41DhDPmGD6bkVWQE2LkCuT/9DoDmuCAFCMx/jNqIVvtLACva2EQA+yaGTRNyz0nZ4QkGaUVfc1fJp+E8hCdJBTnXkUMNEgKK36qOR+h0tU233p/OvtqULzAOe/lsbOSrv1EhSSsrXs1+673SGaWaq+3dCuk16Ef+Gw/HlWjbmZ5VJKjjzl
 LdSaIf15
 LKqVTBN5ymbJtlX6XSOBk5u0rTO3GszTuoR8s/Z8BEP6dKpYSMal0nSCoukDa2eJk5pH1pRMTjFEArCHNGucTU/OYzJruvgWbsYfWua0gwK6RD59h9xpCET/z9EsKsx/AqVOlRP4HO+brWZVVNpN5m9WmPS5wXgN+LXSsYVK3yDQNy/GfrJhPEC4c7EngfD5RzEF8+uxe3oS161hHEOqf73FdeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yosry,

On 2/25/26 10:58 PM, Yosry Ahmed wrote:
>> @@ -473,6 +493,29 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>          return x;
>>   }
>>
>> +#ifdef CONFIG_MEMCG_V1
>> +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>> +                                      struct mem_cgroup *parent, int idx)
>> +{
>> +       int i = memcg_stats_index(idx);
>> +       int nid;
>> +
>> +       if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
>> +               return;
>> +
>> +       for_each_node(nid) {
>> +               struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
>> +               struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
>> +               struct mem_cgroup_per_node *parent_pn;
>> +               unsigned long value = lruvec_page_state_local(child_lruvec, idx);
>> +
>> +               parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
>> +
>> +               atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
>> +       }
>> +}
> 
> Did you measure the impact of making state_local atomic on the flush

No, because this is not a performance-critical path, I did not perform
performance testing. :(

> path? It's a slow path but we've seen pain from it being too slow
> before, because it extends the critical section of the rstat flush
> lock.

Got it. Do you have any test cases that previously identified this
problem?

> 
> Can we keep this non-atomic and use mod_memcg_lruvec_state() here? It
> will update the stat on the local counter and it will be added to
> state_local in the flush path when needed. We can even force another
> flush in reparent_state_local () after reparenting is completed, if we
> want to avoid leaving a potentially large stat update pending, as it
> can be missed by mem_cgroup_flush_stats_ratelimited().
> 
> Same for reparent_memcg_state_local(), we can probably use mod_memcg_state()?

Thank you for providing optimization ideas; I will take a closer look.



