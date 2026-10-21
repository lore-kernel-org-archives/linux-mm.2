Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C600606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Dsddr0WC
Received: by kanga.kvack.org (Postfix)
	id C8F0D6B05A1; Tue, 20 Oct 2026 22:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F336B05A2; Tue, 20 Oct 2026 22:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55076B05A3; Tue, 20 Oct 2026 22:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9218F6B05A1
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:20:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 26554120376
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:20:07 +0000 (UTC)
X-FDA: 85345028454.08.2C874B4
Received: from mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8A0FB180006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:20:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dsddr0WC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792549205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IS3HzQsVTkIeTc0iaBJwnuHykywhycd2wsPXhFDZrhY=;
	b=cRl9QRuGLIn5iIsHialKx7TLktb8/zdRv8hvNIgs9BijVFegyZYX40YmL7qSDPxndykqCj
	6k5yjwUDDzvT/9LpuM9izLIP0/WSYVQZBuALdC4k9K/WBHZZeXn3xrejiIzGxbRzzdwDzk
	pikpjd3xXP2A5i+1wL5x0ADSFlMzA34=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dsddr0WC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792549205;
	b=U32RtjXTlAItHcNfKVsOvF5MvHvZFYvaxBT0nq2Z8WYq7GtIcr4Lf/udWyO3qW7nZc5dud
	K9ZvM7i8SWUR0+m7bbwjvSibTnfCOoR+QEu/C1Uj45nkPw0XBAfh0Q0Dzhl8jU8FUGbnki
	wFDNmYhuzy7HY+Y39w8O3XibMRgkhJc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IS3HzQsVTkIeTc0iaBJwnuHykywhycd2wsPXhFDZrhY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792549199; v=1; x=1793153999;
 b=Dsddr0WC6NrWZroyal8c13ImJT0C4QFqGhnTphYltRlHAYpAvg0aQvw55cyTmWgaK+XaPyxH
 KXVFpHLM0lNzc+gdEZ0u1yXwiPvbrduxlfhtwi/cRc8m2gYNeV5Sxm5bAn6Xsdb1xOEDNTHOgn2
 Ropj/mBWKtrLtO53NrdOyXfY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id beee1f0f72299f54;
	Wed, 21 Oct 2026 02:19:59 +0000
X-Mizu-Trace-ID: beee1f0f72299f54
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2] mm/memcontrol: publish null pointer before dropping
 css reference
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261021010051.1529261-1-joshua.hahnjy@gmail.com>
Date: Wed, 21 Oct 2026 10:19:42 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <20A5D936-030D-4080-B585-1200BDE164A9@linux.dev>
References: <20261021010051.1529261-1-joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8A0FB180006
X-Stat-Signature: oi34p11u49wfgr6h87pka6u3pszogahr
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792549203-149110
X-HE-Meta: U2FsdGVkX19chTESCELDOOLqPCUPH+Ydu4cpJRw2awl+l1MZ54gQ15htGzJtPs7+Clk89GIQf0yCHXOKOXT2BM+VJ2XV1svDZkLjPq7c115n5Z28AXYNFWeV5xZTSS5h4KWz5qEkvyrl8TNatA5xkmYgGuKnsP6EvJOkQGLnJpam/OdfQt3Th4+T66s8jiCZYRVlCl3x2peDwiTqK+77xdrQRLROWKgqwIDAKmqLHHy3QjACPqVl5LOyAU98FcNbk94wIwYOuIFW3HFuuVCXicpsmvntp0fNcSz++9KM65S2TnNrXFc9eG+m0G6b9O/p7vciLfRnUlekzykAi1SFD379nZ41fhLtsTEV5O3Z0Jw83CfJJ9OBNKoOjCannNBih6fdv59ykBZCECygbtlV+9A7MlL1LvBy3b3BO9vcu8I+1hcTvlqjHJJ71voleZYsackntxAmqQtD7utySBVJ5ws+zDFZmPWABhzpV70Fvl2TaS8be4P+nB68kQJ4zMfkOUzEtdMH43r4KeORQ12KQF9M4ufebzxYBPzNz4nom7YlFINwHlhN/2gk0m5hnyvE3Xj7arRjgUtOj8MTfQcWq19Z2PcfY8FApNyJRGJGdvvfXeUIUwu//TupHgef+/s6ctyYSG1GZ3KNpMGuxX/FXkTHekPjvq07fTX7j5rAzKVA2MYQPNXL0rekwLbSUzwK07qZKW4IrjUfK0AngbffCOki0GxMiVbZVNZm9krSxI4RTNVM6HU/zE4GVJl5n4QKDxxzGRWNRrqYMzdOY7Mpr6puuK/fnwW7RxboSK8OkYKzuYEhM0kK4FW3xshs4iHwQ4yBYYm98CLav62pFx22ViMGrCuhyjYs6hKNCMBAr23Av/zsEusXA3cMn3GcVu47XxJWe8lGjqduqi6j3xd4aUKCorV6m9Xk44nX1kiupukBX7FT/s22fy+sQ8tZAaw1D6jWEEEuenjigOTPKun
 T/LrlTFd
 GdvI6M+lbKox88+Ml5amFFZGJ567jO02UwYR+Tz0F4A2lChAYPC6bwRo/phCNjHfHVVUgb7m5isqdRJ/sG3uPTrZPydzICo3a2UgTLKbodyXdZCy9XNyN/CvOuIOMlK0fMeNy/oSrA5/OYlFcaskeO69m/KIowSyTPK3ohwXgU0GDjkMtScBVt14Znr97kmhN8L8LXv5TztLELI+MWfkb9BDs6mouv4iRATh6/CfU0CmxijH1u0/e9dhfxbdn0wA9U1stL/sq0gFUbmnPHgZ2qViozBAxuxbCUP6VAoTpO+5/STGz/GnEkJeuLwMJON1NTCOZ6+nGMS8/U2v3u3a3iF2tBoBMThHEUbNv8AxGWVjK3F2kKbO69X4HuIpvRjboW541yrwMQaKS5oMlMkWgpk8j8G9XnD61TUaQJDq3Nu2X00nPqhZO47fiutB/efoGB+BU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 21, 2026, at 09:00, Joshua Hahn <joshua.hahnjy@gmail.com> =
wrote:
>=20
> struct memcg_stock_pcp hold references to cgroups that it tracks to =
make
> sure that the memcg never gets freed with unaccounted charges still
> living in the stock. When the cached stock goes to 0 for a memcg, its
> reference is dropped and the cached memcg pointer is set to NULL.
>=20
> If that was the last reference, the css_put would free the associated
> cgroup before publishing the NULL pointer, which can be racy on=20
> PREEMPT_RT. To summarize Shakeel Butt's analysis in [2],
>=20
> CPU 1 CPU 2
> local_trylock() takes a per-CPU
> spinlock, which is an rcu read
> lock along with migrate_disable
>=20
> drain_stock
> css_put drops the last reference
> release work is queued
>=20
> kworker runs css_release_work_fn()
> call_rcu() starts grace period G
> which waits for the refill task.
>=20
> <preempt>
> drain_all_stock
> is_memcg_drain_needed()
> enters rcu_read_lock(), but
> grace period G does not wait
> since it started after G did
>=20
> <prempt>
>=20
> stock->cached[i] is cleared and
> unlocks. Grace period G ends,
> old is freed
>=20
> mem_cgroup_is_descendant() reads
> old->css.cgroup which has just
> been freed.
>=20
> To close this gap on PREEMPT_RT, switch the order of the referene drop
> and the publishing so that we publish the NULL pointer before dropping
> the reference. Note that this can only happen from drain_stock who can
> hold the last reference, but not on consume_stock since another
> reference will always be held. But fix this in both sites to maintain
> consistency.=20
>=20
> This is based on a report from Sashiko, who found this pre-existing
> issue in my page_counter_stock series [1].
>=20
> [1] =
https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gm=
ail.com
> [2] https://lore.kernel.org/all/atfMngq7nyZpt4u-@linux.dev/
>=20
> Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in =
drain_all_stock()")
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


