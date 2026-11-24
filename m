Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A679606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 04:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r1e5CRtK
Received: by kanga.kvack.org (Postfix)
	id 229846B05ED; Mon, 23 Nov 2026 23:59:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DB486B05EF; Mon, 23 Nov 2026 23:59:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9906B05F0; Mon, 23 Nov 2026 23:59:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB3146B05ED
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:59:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B937C806F3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:53:04 +0000 (UTC)
X-FDA: 85468793088.20.5AB3341
Received: from mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFD08C0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:53:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r1e5CRtK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795495983;
	b=BdogRdpR+S6I/UB0rXObzjF3d1KaETx64nTUaIfu8CV11xpKfVE8myCc+zw2xQuOQ/4yX4
	C0cca2URg9rYq2CMbLrK3B+L/VrJLjjRkIJk1codM5pUdq9Iuc8zQvHG4f3lzMUxC7owNx
	BNa1gTAvqdRbKzkao5eQlX7wLAVdiww=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795495983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OiIzwEHdzzAJR7e70QGL0R+/3Yj1cTamKyRrwNi0fyg=;
	b=xrEh/Bssr23ot+UMMjnqet8Sq44i9vZnP9UbU2itXlnKVA7IzRqualIhheiprkZBioEMJf
	XvyoWsaVO/ucQXK3TBpQlxkamLbXC0JoxvcsPyRPHsvMZCaSDF72XBOvbdlrNNY3xQYOuj
	lvuIRegxLzyxvt/wNK1uNMnvbp5jJ/M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r1e5CRtK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=s/slY6o6wSEczfY7MjDTmcG9POL3RXKg4WQAsPd+j7A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795495980; v=1; x=1796100780;
 b=r1e5CRtKl/EPAtOKOj3DJ1DMGKukAqhyex1TbxxaiNzdZxxU3HVDvqqoFiclT7D+iEUsqXnj
 EDXH52TtiB9Ee+HL55KmQfuKvW4DRTnbU723G8Gedi++KFVbh1k1XlOcecSs/LLUm+OwiAKqArt
 ny/YDiRvcp1MtYCCbkCYJK60=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ca530465533cab93;
	Tue, 24 Nov 2026 04:53:00 +0000
X-Mizu-Trace-ID: ca530465533cab93
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <awUTKy9tx8nWJgXf@linux.dev>
Date: Tue, 24 Nov 2026 12:52:41 +0800
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
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <2FE2D209-FB57-4191-A324-F179B2394DB1@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
 <F39B4A81-BB17-4C5D-851E-2740EBBBBA8B@linux.dev> <awUTKy9tx8nWJgXf@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: rjmaxf95eaiaiusd1smwczepjf9njksp
X-Rspamd-Queue-Id: BFD08C0003
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795495982-36350
X-HE-Meta: U2FsdGVkX1+9/5eH8D4MaezmynZ3hNNWx4lr7e/GlfMtKbnlX55s1Y8d5pi8f3MqLMNOxpplVFwj9i/v1BuNRdqe1t//cV6XkAEwdAw/NEaS7ziJsEvLd+wvd4kGvsh5VtsFmxJKUVEq+3dFCFOQePyn3NsK9yqxSplJVAVgEh1bfjiu7830n5JD8mnEKKkJpXsJVpQrhD1dHNSYQVKu3y510yFnQzOyLkacOUF7d4q5NGXl3Pkljfw8Omf+SQ9d8sgcxKM5csIxuf3iqiy8RxxTXuTy9LpQb8cnf+Yfpneo8cRx0/gch+6/79oSLPP2VXZ6apVGIsX1Cf3XdkghsjZCQGUte8/cKe3vpJ6bsA3Hlpu4C1RZGuLzDtiyQM5kmn9le8heiSnxuclOyfz3Eww5nY3elocD0fwX7JXDFK08sSevvS5iyGl7uQEm/mB3XwM/iEBJ2SgI5OVzwxNLfTGCsToRXafG8/giWhejEK7ypcaJKwAz854qMoOnJ5rEJjgdLtRto1zaiKib5w2Sp8J372Wwulua4vFb51eDf689BSqs0H/CR7tMJtauDZ/LGfeX3vJBVrUyrulDl+F2hw7jC3X8BjOUGO3S6IqRvs9NVTVZe61CN0IEqmojkEVg5P0Ys6vE+UfqYx2exeDvVUcy1K7s+05I0ZApzgLbKlRDYGmhku4PdI5nwqboRu3Kj3of/dhaz2sHSYkG6cTW77k6XYKQ14EMT4DH3cPJ8On5HWFr1Tu0Yl3bavsyibi0mMOQX/qKUkOKia2S6sFqKCd3CpAD5zlVggS1sgJgZkogzalHthnvf3o9hw63er2sl4CEc7qQUB4Qv1b+m31X/TIWXagZKX4AjE1tdqVSBxwQPxSUYQpgk2HuU1gSJB0tMsgHSyN/qKGBrFAjO1+YGuKNsJgD822ZIG3vC3sppSmA9PzQTHI0m+X/rnEOYqFmqCyAz9jmV/vAyZnW9C/
 6xqgff1t
 5tjI8ZAjXQ79RuRLbDlNdNjrV5LeIqrfZ5XdWv5QCUIEIUry31/MlPDTw6xQ1SDHIc2M/ydr2pEDvphnGa4SmJxE63+OHY7NjrPj/Sb1AZDzGzeCAgKTNldNq3Uv4n1bOfKPn/feHYIegB9lJZWCEsZPdScUULF6kElHIKWQOUTlAr41P1AVXconkaHe7d+rRkf1k/zkX+0xCll8YS/rhiY00d0EOx5SBsmxoAWa2Q336vkCtPSudDnqzsWg3FH9byXBU2kizQv8hlRCFkE3YFERmfk1b96RDr3vGSUkhk7WgLdCCNGEhsn8DehMpPCJVjgqTh1dagTRQq5eZOlwQ9rdbeeoOqdpEqu2bo1cyi4bRxHDowJLoLvOiTVtJklp9GKkPpooamt8U6m23uZyKGwE9i/QC97JH3kW2k4x9oeIJCBuqrCiU6F2ef+tPT3Aj4frATi4s4EPdrwFCLM4HFSEClFkpFIkvGVaXRlXDb6icqlm/z/A+WbWI1MUeUVkvtIpv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 24, 2026, at 12:33, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> On Tue, Nov 24, 2026 at 10:50:00AM +0800, Muchun Song wrote:
>> 
>> 
>>> On Nov 24, 2026, at 08:04, Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>> 
> [...]
>> 
>> The leak analysis and the fix look correct to me. However, using
>> CSS_RELEASED here makes the private ID cleanup depend on a generic CSS
>> teardown state, and adds an accessor solely for this failure path.
>> 
>> The private ID is not needed until mem_cgroup_css_online(), so could we
>> instead reserve it at the beginning of that callback? Failures in
>> css_create() before ->css_online() would then never own a private ID,
>> while failures after the reservation would continue to use the existing
>> mem_cgroup_private_id_remove() cleanup.
>> 
>> This would also make the private ID lifecycle more explicit: reserve and
>> publish it during online, then drop the initial reference during offline.
>> It would avoid both the new css_is_released() helper and special handling
>> in mem_cgroup_css_free().
> 
> Thanks Muchun. Nothing needs the private ID before ->css_online(), so
> reserving it there would work. But it moves the out-of-IDs failure from
> ->css_alloc() to ->css_online(). By then css_create() has linked the
> css into the parent's children list and css_idr, so mem_cgroup_iter()
> can css_tryget() it and cache it in iter->position. A css that fails
> online is freed without ->css_released(), so
> invalidate_reclaim_iterators() never runs, and the free does not wait
> for those references. Today memcg's ->css_online() fails only when a
> small allocation fails. With the move, every mkdir on a system that is
> out of IDs would take that path. I would rather keep failing in
> ->css_alloc(), before anything is visible.
> 
> To drop the CSS_RELEASED dependency, I can test the ID's own state:
> !memcg->private_id_objcg means the ID was never published and the memcg
> still owns the reservation. Let me know if that works for you.

You're right. I missed that the css is visible to mem_cgroup_iter()
before ->css_online() completes. Using private_id_objcg to track whether
the reservation was published makes sense to me. Thanks Shakeel!


