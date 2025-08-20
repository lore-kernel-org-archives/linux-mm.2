Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FBBCA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 19:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464C96B0006; Wed, 20 Aug 2025 15:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C096B0008; Wed, 20 Aug 2025 15:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3796D6B0007; Wed, 20 Aug 2025 15:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2601A6B010B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:03:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6300116D6D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:03:15 +0000 (UTC)
X-FDA: 83798058750.02.BEF0779
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf18.hostedemail.com (Postfix) with ESMTP id 050641C0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:03:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G7m+UaI6;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755716594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhzGRBDX5Ee/XCrPKF8cKe/pIT82Tf6sC9Zyj17a6UU=;
	b=pTyuFltmyH8KjKM61dpGY/af/JDmR++30jYAMVOqo+8/nCmNlbF0n7qeE96fEOsWab/ne+
	lOkN7a7kn8biFAeFhpkb7551ezRnGXAUvESQj+btW8W+IIA0nGQGRcK0NIG7lp1MGHBL2Z
	6E2J6WvhSDLqtcBYUo2NccLwy0wzB0A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G7m+UaI6;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755716594; a=rsa-sha256;
	cv=none;
	b=31qMlPJ5d3LIIAet/6DYeagPaLRvKl5NnWdXJY2aHYkYTmsdpUtcjQOw06gpfqRiRl8XZU
	29Ut5ZFg98qhlp1r6OFTEHKA/7UNf0/zInali+xZWcQPgT5R/6mA+lw+Vb5nzsgHdCF6I2
	5EuIbWHvMHouk1dnpmpq02dPNwIlhTw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 043C45C6ADA;
	Wed, 20 Aug 2025 19:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1DFC4CEE7;
	Wed, 20 Aug 2025 19:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755716592;
	bh=odD/T6EvPgMd2KV47i6OxxVsN3PY9jzhXcMSyoj+vRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G7m+UaI6oQeP8JYab2Nf7jH0X0EUH+aTaZTSQYheGVQir/3UPwdBnPR0Bi2Od8h+B
	 GEiLUDa9C0mMvdd20fFORMnVJYc3IqniQscqwRZnbMJprKVo2wXyAOmQ3JJrxifxHI
	 O651V2hk5sXJvrbhwUnFoVkN+ayXQg3ayzhUOH4Bk+5VD+NMDf42qmOu13N1xQSUYr
	 nj8/BMtaEWq3vR3NmZ3ur5ybBoiWyT/MiW0IAULG0xgffiEWL/eKnQjJcK8kd2YJi4
	 IuW3P9pG58TpLKY9juUccPaAl5SByEag2HNibrU3+BAnnkiwbEcZfE4RfFhlkNTcvn
	 x0brddGhUzNig==
Date: Wed, 20 Aug 2025 09:03:11 -1000
From: Tejun Heo <tj@kernel.org>
To: Matyas Hurtik <matyas.hurtik@cdn77.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Daniel Sedlak <daniel.sedlak@cdn77.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	David Ahern <dsahern@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Message-ID: <aKYb7_xshbtFbXjb@slm.duckdns.org>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <aJeUNqwzRuc8N08y@slm.duckdns.org>
 <gqeq3trayjsylgylrl5wdcrrp7r5yorvfxc6puzuplzfvrqwjg@j4rr5vl5dnak>
 <aJzTeyRTu_sfm-9R@slm.duckdns.org>
 <e65222c1-83f9-4d23-b9af-16db7e6e8a42@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e65222c1-83f9-4d23-b9af-16db7e6e8a42@cdn77.com>
X-Rspamd-Queue-Id: 050641C0007
X-Rspam-User: 
X-Stat-Signature: jjfeew4pi4b117ds6og59ttkh4gfgd8r
X-Rspamd-Server: rspam09
X-HE-Tag: 1755716593-520565
X-HE-Meta: U2FsdGVkX1+JNeomTagg8JYWXt4Ngugu272Y6K2EqluypHHehSitC4dZmIvXjYvp1qdfPHT3mEWm8HB0UzPi0Xsnq8UaEQhF855dFPerVFwKbeGAayvtU93S3kDR26iLbbAbKiQz7o6QB7kDKPd/Eazq7M3vTlxHoHRjzImyyh+Zw6zxiIkTbB1nF1zVvgJtE4kZ6+wohbwC7l6qtKctY+vJ9uoaAdIvnISmM4Yy3Kcu1D2AogAu0GxIo1jnBpZRyiROtJ0dH2mGkC9qwlFCpGaRvugysCgI9LqN61hvQYWlHhNplfeD8Ftne3xf4YzKI5r6WnqVlrVBVEJG7nWKMAy8Yz2x1Ua7+09r2LYuCKxcoMWR2nwJ4W0cBPk5UAvgX2ZtyyLfX5cW1jpWvCP0lfHutmeyQa7gHrL+RI7XiV4HRn13OLcRzlH7gcJjLYP9Ehx6jNG7XSQ7ESBlvucpVSD+bRkdzOwuYJf0sDHlRIdI+bu8rPIuMTYdEpJDEDBDC3fYPkDUIeWsmGgtlk3VQL/po8ZFVRBtjQGb/+NL02RSrL6GCxx4e90+R/NdWZLHeo5G00fpHOCJOW+EBpiQwXJStLKoSv9fhHbI44qDRKV7zK9WBH9bb8GlJAdSgvyPR/+6vLB0WHwxoTmEojHgkaUqvYOWrnf40sT9HqugyW7FuWYr00ZllN8KUJXqxDbkjQ+n2k8NkpsgxAFT6bne4FV3P4JFtqpt9FjqpyfKs5/5JVATXzqc+QlrCzBo4893aGjz7vTCWVbX60tCPDYARYr65rWEbKT/CEhKwvkPpE1CMKIdxnlrxUNH1fsdKj5209zB0Qqr+jUDLni/2pwURgMmtYlFF4nBmV+LJnWBWRzLpYTEBLWrP/9jK9T/0ntYHM78sMSW4n4l8NS7uuqNWvwi3UF228XUjLvglP1T5btQlqdFMzwIGKNsV/qNZEJalpPqf+LCKbxSLuBF0bO
 oJ57NELf
 4hmVWpCpG4vhwPJNTMvDWID8FPrq3dN5bBV/TIFotA/nV297BWBDyopOFl1ASsFMZ6ewfEyCCAzPGzvY4umN2q3q9t/dPeVJLaD/TtsMhxxeajcX1CDdzMx7r0mOCCGyF0ADnNtHzCAyVIuw7G+CzF5vZPvoGwRc+IFah77d3bN4R8q4/77K/m1ELmvf3NdUJaXq/4DUnKavi1khfwnc+tSSlLRCQPAz0FL/TqG1PZQXAR8E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Aug 20, 2025 at 06:51:07PM +0200, Matyas Hurtik wrote:
...
> And the read side:
>   total_duration = 0;
>   for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
>     total_duration += atomic_long_read(&memcg->socket_pressure_duration);
> Would that work?

This doesn't make sense to me. Why would a child report the numbers from its
ancestors?

Thanks.

-- 
tejun

