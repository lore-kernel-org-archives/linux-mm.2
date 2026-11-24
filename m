Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 660B8606A333
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 02:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tfdPqlaX
Received: by kanga.kvack.org (Postfix)
	id 33D9E6B05BE; Mon, 23 Nov 2026 21:19:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7656B05BF; Mon, 23 Nov 2026 21:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1904E6B05C0; Mon, 23 Nov 2026 21:19:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA0A16B05BE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:19:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27FAFA85B3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:19:49 +0000 (UTC)
X-FDA: 85468406898.02.97F1C31
Received: from mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
	by imf01.hostedemail.com (Postfix) with ESMTP id F2DB040002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:19:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tfdPqlaX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795486787;
	b=Qf4ewuAUQ1oUnPCVxAS6RCuW8KPoTR9B7zpVofDxdyt67SCFH6Rz0EA4O109O36P5X5J3l
	gw8UVdLmeM8jCAOC3KTUixDshl/uMZBrnvkOmIDm+gGKMJqiuvzduCaKXG7xeWjAJBQZbE
	0dOQ0J4opQl5Snyc69Q6rgCECA4sOJo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795486787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBx0Oc8DjrG47WqcvxRyI0jpjHXnJ50q9VSIVqYcYcc=;
	b=TqK2871XHNiylrHbcsgbBz9+snosjgpqZ8PqTR7GHheBzcvIRJGgJTdtbn4Fr+4Av07t0Z
	3EsF67gz5R1cIhXyZRw1LT3VDGuOeTkWdVaum306m+cIjGU83GAXSdJQIirTpZDJyvz19z
	4V1iNIX7il8v/YmUkZEMrVFYStH8GqQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tfdPqlaX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NKu5Xiz7C3AzZvOFUD8J7Uu+4Usuf9/OFAgGNS+u1B8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795486785; v=1; x=1796091585;
 b=tfdPqlaXx7ouiMzM9VnpBDU12hviUPVADC8rjidEa2X0YIuG58aVuGQeLgwnEXzJE2iLK9us
 wlfRVIxp4giQM6RdsEXpLBPUE82ObXd1ixtHb599E5onMs4jRop46ltQgsHq0AM920I5NtrXc/s
 5DqtfTfoVTqJhutPgv9uniro=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id db7b533f27c72b2d;
	Tue, 24 Nov 2026 02:19:45 +0000
X-Mizu-Trace-ID: db7b533f27c72b2d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] memcg: warn when memory cgroup IDs run out
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261124020800.2313930-1-shakeel.butt@linux.dev>
Date: Tue, 24 Nov 2026 10:19:26 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutny <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <5BB43F38-F97D-413F-B1E6-0EEB6302FE6F@linux.dev>
References: <20261124020800.2313930-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: myutkma1wnp47djgqd8bn15qxzuhy3d1
X-Rspamd-Queue-Id: F2DB040002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795486786-294923
X-HE-Meta: U2FsdGVkX18qBdH2D7ccPw/9/rBGnoN3rES9UEK1ceah7IgLyIEXi6P0XZQZ83n061hbAAl+rTPlzmTtNH0K5TSXtwAa0vQ82J0GHVwe6CZVVcWgl5wDeFQLdbmBEFLdfXe79Uim/zmCukB8kYzFfEwGlP0hppghmlrVl41FnEyIeA/D5PJ/QTSg2SX143i4TbT8oO/XE0VQ9mdBZ9sgYOmavW26narHEyg2yLotcwJ/ePZdWeT4cXwJarFl8lUsqHKBikLyWyOlzvqCQ/zX6Rue0KfovuHt1OW2N/0AFRqxS7oJhoH4MFFSzqfQ4/tWOr+kUqKictsAsHsHJ9E6SgEGbkxmva74Ddd1S23w4Hf4OcKEUaus8jn2VX4Z60N+6LgIiR2GvKIdpa6UuEIfzYyXiRYJpeffYCgcpJQQfaVom0SGLuNbulXKktLJ1tShJdxmQZYi7cWStdCcOogC7qXcJ85u80aC3aN9gUgnKu3vmUb/Qs++judoMnL3ZQNant0HVrUzbzlsC8E7e8X+aJgvTKbRVk0ouCoY+Sca5yRd0qJLEW5xHqHLRZ3Iz/Ex+GWUQ4yJYcnZMjh1eFKcVCTEs/kCEwx02rQukR52sMW4+42VWftay2S9kSexaHz3kkR2WG+3irEdTdBByW7O6XlFcOGHDneffc4SaRZJsHfH1OggQ2ifl58DCd+lnUo4/6PU7ssqqT9iEZ8VbJDM9DzwJNHEdeED58EwKcOvkA2Qi6DKUw0OjbYV2k0IuFDhDT8kKju/O8PrLKvQo+ChydDs80jTIOfzTxU5zW7wNQnkXliZnrRf2vlr+hnhhsNi5dJs6VFcLQsCcmHNtOZDVNylF800SC7LQ1e51XcH+/R4d+GMZmv3nNSoX8ygU/uVpIPms3Y1xn8ESDUEqjqa/Db/yAJkEB7LQgSD3oX0fthBGZbiuKIaciDYOV8Xez3awlJGKCbS6PPd0cyYLrY
 kpGxXwy0
 0LZKqBw0ENQjUEbxArgmV2p+ZIEau2l8HELn6tnbiI+Lco+LaJ8JX+r0rtvugfEkar5E+BhPsY2kqQv08Ka6+l5QpQrcgfIKVzNdgRlJ3bK30v2sEShQmMFB7bAUTjrLdFt6CYY5jj1TFeDX+g9ckAXUyOJ02u/etugSdEFhkKbimQ2YPMac0v5pExMvT1YxmQzsCUzXWMPE0tVDUTpq8gC+xGTN7oEslgbMQdEHTSQlmXctkr4cvBN3GkMF69dAO+tVeyGVfu23ZyKdX9RUKAkN36klwsXJrCdHJyNxC3ATfueWGC7o2dXqKs0vr7cD3qOaDH/m3uM8cymBgW+sN5+/eny3zJsadDew20hWiTpeoIOGeXXEJWh0c+ZGBOsvIh1Qo88TuWDNjxC0MwWVlMVza2bpAhswEDEseIfDwiGl5r7LdKOnHVn62SXvArMUrrYxOAbQWeXPbhDsC+WP1coOGNz67mbh2efGE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 24, 2026, at 10:08, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> Every memory cgroup gets a 16-bit private ID, so a host can have at most
> 65,535 of them at a time, counting dead ones. A dead memcg keeps its ID
> as long as any swap slot still records it. On Meta hosts that create
> many short-lived cgroups, dead cgroups held this way filled the whole ID
> space. After that, every mkdir of a cgroup with the memory controller
> failed with -EBUSY: systemd could not start units, and container setup
> failed.
> 
> This was hard to see:
> 
> - Nothing is logged when the ID allocation fails. The only sign is
>  -EBUSY from mkdir.
> - Since commit 8290f45995f5 ("memcg: move memcg private ID refcount to
>  objcg"), a dead memcg is freed even while swap still holds its ID. So
>  nr_dying_subsys_memory in cgroup.stat can be 0 while the IDs run out.
> 
> Print a rate limited warning when the ID allocation fails because all
> IDs are in use.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.


