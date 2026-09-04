Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71190C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 06:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7516B0088; Fri,  4 Sep 2026 02:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E783A6B008A; Fri,  4 Sep 2026 02:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E076B008C; Fri,  4 Sep 2026 02:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B76376B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:07:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5857840736
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:07:56 +0000 (UTC)
X-FDA: 85175048952.10.156FA15
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2735520002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:07:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788502074;
	b=pLitD6+8veAg7OLCpJaNHCfJ5XtHJDVJI4leHhFEWmrjkObsQ8nYCwt5QO6rqpMSikXr/B
	0l+aRVPW1yPqLuBd8jlYykhWOAHM5YNVgv6bJDSwy43w7Qr8KcAqU3jkeA54ADow66e/ZK
	gcITIb07pFTYfeNV4v3tz84RFZmVBho=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788502074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vUJvrasfqih2RqWrrQHenGCjo8FjvVbZNkjFbbTtDcQ=;
	b=laOVJ/s5lwUuQ8MAZX0XvPzWJ60hIm4DEkGte6K7fqRNKgxdNJZJ3UvrnuI7zHZ6WKdR/b
	BRCzOVGtstJSRDW2m7lbbFBXZm3Pd4r1NJlUnBusF1pcJKffBrl/wfhA3HJGqQ6pwFJfzr
	d+QaRynB3zkvSU4DtKlY6yAPfIJwGQg=
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.52 with ESMTP; 4 Sep 2026 15:07:46 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 4 Sep 2026 15:07:46 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 4 Sep 2026 15:07:46 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: gaoguixing <gaoguixing@uniontech.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, chrisl@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org
Subject: Re: [RFC PATCH] mm/swap: fix swap table count encoding for empty
 slots
Message-ID: <appgMkDEZkgKID48@yjaykim-PowerEdge-T330>
References: <2FDEE109C6578F17+20260904025411.106943-1-gaoguixing@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2FDEE109C6578F17+20260904025411.106943-1-gaoguixing@uniontech.com>
X-Rspam-User: 
X-Stat-Signature: z7t4cwt3oein98ra6tcg1ya1ycnubwze
X-Rspamd-Queue-Id: 2735520002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788502071-924581
X-HE-Meta: U2FsdGVkX1/WvdiZ+TxQuFYfFyPCzMVN2GItJwDD8i3TrqUuCKKkRwGI20yuiHxRNj0kbHpQ6TnYjI5bYx2BC0IKAsMK+QoSC7H3C2LRhHy1sazYZn7udUdGGIUZcSTti1XTGDKd8ndrQ4vX3JwSs4ITqlJgxJSXPr6MwJqDNqUSl5CrrcDnYZ8eBZpHcSvMO5oOVP3j8ujz1CHWmdomnwAlckMPHzNpyTZb7Hng0XCZlOayhG1X8jJzJ/+SPNwKsDToQQY0bx0MZHBnGmuHi3n0OfMxz1XzixYxRPfNJdvJlLbWaYMMvPVVOJ7KIdrVXt6dwAhc7KyJ5AuJWtOT9X1vJHuBz9Mz7Coo15h1Wn+TGRqu4amEkm+js632TTBQWHDjiE6qXpumuRAA/diaFrL4CcGh8QovbViswRy+HAD1+X5dn5yZmBc7hYMxvkiZ9/KYL2oqABD/KUUkzY8u3GLOuJXCWFSLwPir6MVCaWwW+o6EDBWt7ofIEamOjDHJxTL+QaEsxiRX4s/BGJh2MDah+6qQfxhP/twUhAnDhAm/f8D9jzWylBJ+nqfhP2loI5VGa7DorP1LViC80kA6zMuX97lxSyOGEKHIQidg6up76nyiPoFWvDrwkSbzFFE+L/5d11+pQXpf0GE08YvF2HzVQQ8mKEkVL54q7ESu6fiLfqH1ojzvvTfTeKsLBgLhMQ0bX6Qjbasyr5wzKsV26u0CeaO3E+hwYM7GTXEmMpmm34UAWxA57QXR7XvZSciXjAeA/gr8BgjN0a+tkhMDqeGjzmNmod0tTtuycdGK8Jd5hL3ElW5rb8Ue1dKHY5jAyjoNjQ5CQBQ/mSZta1nmZonODzkISzXqKarKDAPIMEu9I2tc0sGOP9o8EEfrCybegYrwKXqG6+iDxpcEWUbwuzmXFS6cLAYLiHWvJ2bwWEAMuWI5AcHQe/i+iQdsSPtrqa87+EuuXkncZo+MdWk
 bvNxSBGc
 hVwYMWJqAUllNSFcO6Fqi1c93ajHS3a8WPeXE9kPWjUpWJKH6vOUEiNSDkBEwaBdm5NVbocY7ciNBI5gk8EsnPS9RneXZP+e7+Ps6UCkLF82RCpwDBqgNa8XrEy3IxrmJrIBKFNvQcjTjZEng14P/P6JriTpuBRffBa7mkYURVb7QVLPjxaDI/7szJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 10:54:11AM +0800, gaoguixing wrote:
....
>  mm/swapfile.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d6c5c25755be..02fd5ad94185 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -163,16 +163,16 @@ static void __swap_table_update_count(struct swap_cluster_info *ci,
>  				      unsigned char count)
>  {
>  	unsigned long swp_tb = __swap_table_get(ci, ci_off);
> -	unsigned char flags = swap_table_count(count);
> +	unsigned char tb_count = swap_table_count(count);
>  
>  	if (WARN_ON_ONCE(swp_tb_is_bad(swp_tb)))
>  		return;
> -	if (!flags && swp_tb_is_null(swp_tb))
> +	if (!tb_count && swp_tb_is_null(swp_tb))
>  		return;
> -	if (flags && swp_tb_is_null(swp_tb))
> -		swp_tb = shadow_to_swp_tb(NULL, flags);
> -	else
> -		swp_tb = __swp_tb_mk_count(swp_tb, flags);
> +	if (tb_count && swp_tb_is_null(swp_tb))
> +		swp_tb = shadow_to_swp_tb(NULL, 0);
> +
> +	swp_tb = __swp_tb_mk_count(swp_tb, tb_count);
>  	__swap_table_set(ci, ci_off, swp_tb);
>  }
>
Hello,

If I understand correctly, this function was added during a custom
kernel adaptation, and since the flags field mixes the count and the
Z flag, you'd like to split out a dedicated helper for updating the
swap count?

To me the layout and helpers in swap_table.h and swapfile.c already
read well enough. A mistake is possible, but following how the flags
field is used across swap_table.h and its callers was not hard.

I can't quite see where this would apply or what it buys us from this
diff alone. Could you progress & share the rationale and an actual patch on top
of the upstream series?

Thanks,
Youngjun
 

