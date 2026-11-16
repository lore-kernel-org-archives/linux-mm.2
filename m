Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B80B606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BPegepsl
Received: by kanga.kvack.org (Postfix)
	id 43B9D6B05BA; Mon, 16 Nov 2026 11:00:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412FE6B05BC; Mon, 16 Nov 2026 11:00:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307A56B05BA; Mon, 16 Nov 2026 11:00:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1741D6B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:00:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB49F1C1F90
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:00:17 +0000 (UTC)
X-FDA: 85441444074.14.3DE4B9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id AA32920004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:00:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BPegepsl;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794844816;
	b=YhWt9UKKxoCk7rb8addoSs50eHSTVWTHzZxheGC1JA9BjAXuvqde8pfOdzMciv5dcmW4R/
	maahbF51SpEH/MGpYYKCoARkU9C8hO2oIXIu7OHVJUJrYiU+vT0AQjv1WeRIaWw0G6ziLD
	Z0Nql+La0/YcZrYH8nOMAosla1GUubc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BPegepsl;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794844816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FwU8er9jCeLmP2s1OrkSO00t5m4+Uddmg0A6k9pE18=;
	b=P3BaVDPQMeyEwvl5NJOWjUgaVYafOpnPnONiJO+gnxFEGyQt0V6JycdVtre9fEHnmV1JcJ
	QI9DpHRnP1BJdRIBs0kEbRyzBHV952QNJsj0zMUzO0nnzKuQjjCfUYRx5sNJtJ2xkbRSs2
	ajSM58P1L7NUnXxTI+1y4nNzJ1GYRYI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B78CA44E56;
	Mon, 16 Nov 2026 16:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E621F000C4;
	Mon, 16 Nov 2026 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794844814;
	bh=5FwU8er9jCeLmP2s1OrkSO00t5m4+Uddmg0A6k9pE18=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BPegepslNzGtyW1r/Rq123aCz2axqzJu12dxkG1nDchgLsphIUbg1Bfqs0vOTmzi1
	 rc/seV0/CbaEUvvVFZEpifVak1iXewOj2iUUC1KYi1zJZnav1XZIRe1Lm7BZgDhD2G
	 0DFtsqCaqCGn270wG1Wz5NkU7OmluEweJ+kDGlms=
Date: Mon, 16 Nov 2026 08:00:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yingjie Wang <x-professor@outlook.com>
Cc: "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 "manfred@colorfullife.com" <manfred@colorfullife.com>, "legion@kernel.org"
 <legion@kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>,
 "vasily.averin@linux.dev" <vasily.averin@linux.dev>, "hannes@cmpxchg.org"
 <hannes@cmpxchg.org>, "mkoutny@suse.com" <mkoutny@suse.com>,
 "mhocko@suse.com" <mhocko@suse.com>, "alx@kernel.org" <alx@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org"
 <cgroups@vger.kernel.org>, "linux-api@vger.kernel.org"
 <linux-api@vger.kernel.org>, "linux-man@vger.kernel.org"
 <linux-man@vger.kernel.org>, "linux-hardening@vger.kernel.org"
 <linux-hardening@vger.kernel.org>, "stable@vger.kernel.org"
 <stable@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] ipc/sem: account dynamically allocated sops
 arrays to memcg
Message-Id: <20261116080013.6a0e1f1a4d0421f432b39ec1@linux-foundation.org>
In-Reply-To: <179481695440.274194.11951572532773505066.semopm-shakeel@outlook.com>
References: <cover.1793250194.git.x-professor@outlook.com>
	<07d9034ec1fb5b6fd5eed2cf60ef3c84d5149e51.1793250194.git.x-professor@outlook.com>
	<avqD2Z3KJwPsCcVG@linux.dev>
	<179481695440.274194.11951572532773505066.semopm-shakeel@outlook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bcwq8i8i7b8gqgko73ut5gdiwrdboh47
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AA32920004
X-Rspam-User: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794844815-910985
X-HE-Meta: U2FsdGVkX195Tnd32BXeOMBrWzUpAYakPFBghfcOSJ5K5tQXuO7wQgEZpS1LLX2dsOLfwsGrUtsgDOprid/ml6KNEi+HLQtLoDnpoEfpQ0FL75VyguIFgpT0ghARlEc+jD2dZHvFS7SYO9aMj6SyUXm7a73iE+UcmigBzmp13WphlHdeyvnRIg+aWi8105spd+os7cMbw7SeR8WAJH46XoNSBxZ9idJld3ZrWce6GNJm8Q0YSrkM4fWnfZgrcA2uNBn1f0gRO698qtTNC2hU35ObQQ5BNAg7HvfsbxHxwGAmwkMRBbwBKLbV0Us9Hqa2ZngfolAttLeqSHEQgNzO/CpYhM1b/WX6KywQOKfM5+ajFgZZQQ50neFrGC11aaFi8tdeCsQe+oJ5GJpJPLnxydJKoyYDqgqeosbftI0fOkfil7U/GAUva95gD3zGhxxaJTM/1sDN1nw5kfV22zUSEE1ulPaEAZqeboYJn5iEwjji4mDDOg/1EG0q5b07vCVYgwPEHTU7s9Fk5BACF8A8xsYvrB9hM0kk6X6C/7sNGN6TuOFzAGeV+iZjchdCA8aYREwtjIVaKU8a/1waEmWpb7x32HVuZZofRsn7UI7gpiFTYAY8gBp9erijEP4LVdS8nXsNMj4uNy76NY0zulAMO9pTNLXuYID/5jgJTwFbi5R4MeJctLZM7mgwAncOECd/a/cKAWRgSskL3uH7M1WMvdJ3aZll2CmNZDskjivjIskC8y33/nOaX1ibo7HdCdCywd+VWwlEZwauMiHuocz2UZ3I05JD+JtPqAFG9dAWXyt/4r+mmEZiqXXeRQ8xWsFgI/LRqfF8N9IF7WZAodgMe+tomx5TV04oVe+Dgjbht4qnAEYZdYdLR34jLmpoAAc28AZnjgesyCfspxYBjpGcXn++REcD7WCQCLUO0fi6md2x1QFnBF7XMu5RjQDZiEZuFWBVdcYMMxwsxXXhcc1
 7TNnhzet
 GRJxOlLwt48gy1dO2t0lZ2cQLD98Q+qA0SRZBkaRlfTxDw644TuYb7cf4VhNQ3cGXPqGjUcfNgTWKYlf8ZI/X27F16KxQqx4h6ekglpyNNAxysfQxSxlDQhPmvM3WP8AxKx3ClWBDgp8YeE1RAFPZ+HzMFuIz0uzOSBHMPTtg68I24zRIuhZsOyOZqGOsJ2EKfodJEhG5VCb82I04X7GZ5Ts8xVN79wmWgEahjvZsqv1Q0ydu3AKxSXo+EITVfVxD71QouiEKU9dluD2qDpXusjyyqV0gCjGcg1lQ6gY7JfBD0UQTsUaacjhKClvvJfJnCWTU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 08:20:52 +0000 Yingjie Wang <x-professor@outlook.com> wrote:

> > There is no kmem accounting in root cgroup, do you know why there is an increase
> > of 2.3% there?
> 
> I think the 2.3% mainly reflects boot-to-boot variation. The unchanged
> 64-operation stack path also slowed down by 1.9%, even though it does
> not reach the changed allocation.
> 
> For successful calls, the per-boot medians were:
> 
>   nops  V4 boots (ns)           V5 boots (ns)
>   64    230.5 229.4 230.0       231.2 235.0 235.4
>   65    546.0 551.2 548.2       551.2 562.6 566.3
> 
> The first V5 boot was very close to the upper end of the V4 results at
> 65 operations, while the later two boots were slower at both sizes.
> That is why I interpret the increase mainly as boot-to-boot variation,
> rather than root-cgroup charging.
> 
> __GFP_ACCOUNT does still change the allocation path, including selecting
> the kmalloc-cg cache, so a small contribution from that is also possible.
> 
> Andrew, could we clarify the root-cgroup result in the [1/3] changelog?
> Please change
> 
>   and successful calls in the root cgroup by at most 2.3%.
> 
> to
> 
>   and successful calls in the root cgroup by at most 2.3%, which
>   appears to be mainly boot-to-boot variation.

Yes, I have made both requested edits.

