Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D71F01834
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 13:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5226B008A; Fri,  6 Mar 2026 08:16:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692906B008C; Fri,  6 Mar 2026 08:16:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C96F6B0092; Fri,  6 Mar 2026 08:16:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AB626B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:16:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7E2F160550
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:16:36 +0000 (UTC)
X-FDA: 84515687592.06.E9E021D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D13221C0010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:16:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MrcTWgIR;
	spf=pass (imf18.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772802995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3T/i6jWh9ZiyPn4U4gH8+TmIarrSmlqKMPAwjseiHoA=;
	b=ieA1aqZJsgiK125gcqQVOiqsgPRQ/aX/KECKqAkEFHEJ5Z4d+9TorV61/x+t1OGjz26xEj
	VmzGWcE++Vi+jgad2WbU3VoDbX4a9/Hnz4B7Q1fBB1h04uqGQiGCTN2DZjM0gYOThK6JW6
	K0Ca6efSkuY4tTDg7//O2eG7mal/Er0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MrcTWgIR;
	spf=pass (imf18.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772802995; a=rsa-sha256;
	cv=none;
	b=KAcnDjK387uMB1dD1oFnZKb8Dqx8+nQty8QDzKx8TI+nWMa8Y/rS8wLBfyrjrlwjZ7aAf5
	hoyw6lSwjv/T/6a+Tk89amxYPkAcVAmsryi7s3CTNPybzbXPj/jBsKV5e997JKQuF/LSFE
	icHNZySt8Ddou/0vf5glrPQfFWtKqf0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 55F2560018;
	Fri,  6 Mar 2026 13:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE97C4CEF7;
	Fri,  6 Mar 2026 13:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772802994;
	bh=QtYks9d9c3Dzk/Ze49i4PphQhSE2afw8TMhORKua34I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MrcTWgIRTCDg0jgsy3sFAb0dskTd0RRw8TSgKqws+p27rhJ49pZ7ajQpNPkl4hnrE
	 ps74kjPwOUBqEvOWuGMlwJqFJZsJFySXrXkAlJxkoUNbIsJQYdcdQVTFuIuFrIIncF
	 1g7nh0azVPk87heBLK2BfhJHfG6DF/2qwytFGJWHO5na7O1qnJNw17SgTAQgH2mcQW
	 NOrOJi2Foo7A7GUxfqI+8G63gi6AVuCxOKHunV6HElKgBBwBrxusGv6szlHmT8OXHm
	 clGrSOCCBc7IQaEsX78vR7ksW0EV9+tQINYc2L/ae4XzYewggkCEqoM5ZI8uXiQ/X9
	 iE8mXUcpFSoog==
Message-ID: <f861cc00-2b41-4112-bba4-810388a5747b@kernel.org>
Date: Fri, 6 Mar 2026 14:16:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fork: zero vmap stack using clear_pages() instead of
 memset()
To: Linus Walleij <linusw@kernel.org>, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Mateusz Guzik <mjguzik@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>
References: <20260224-mm-fork-clear-pages-v1-1-184c65a72d49@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260224-mm-fork-clear-pages-v1-1-184c65a72d49@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D13221C0010
X-Stat-Signature: 5chd1upbzauxzffxm5nqkigp9byddabj
X-Rspam-User: 
X-HE-Tag: 1772802994-457183
X-HE-Meta: U2FsdGVkX1/nPFJHJNc0YMbhC0J1dtk9TX+NDy/ttpliATYOQUlCsAG3ZTFORNKLp5E+6+PX1ASM8XQQ2pr2ALdo0su9ytzGiQE2HiPNN3Vrn2g6zbD+MxXVc7ANPvXsFd0J4akm+mLvndPPomQXEWFIdzNLFC+woYArpXJaGowZWvSItUoaBCamnEvA5T0n6i9Ln2r6B3y3dbq2Ld9mR0Tvq050gyoe9bKVnUEFWN6so/BqsZ6uE3O3eQ6ejWTWVStHSizUgdosHc1fHs3lN3kKBorGLRIZB9WEMENMmuhEsAlbAEcSWJS6EA9sCOp4muv3Xf2U75/CwctPNn+yhfLY+gr47DBoD9IZa6vZichbX/hZ3xdNQ8NPEsFU2h3Ucpn8e3xhlKPxKChTNkkv5FrD3AK5bO0/0BU5KXQ81zRAY8c7yEo2YdHTl3XAu+Hq+FmAFs9uCs3hLT3RWZB4ZmAgNGLEVcNfbxxEI1MwdF+38pBU7MS8tIpY4vHE4FLudecQbTwr57BPXmWtocKj/YajWRCUs4abEsZLTy8CF85+QzSXD2bV1nfBtXPWnE0/uRb5tSKraSCaOb/P4j/My8JKJ9BjwXn/r8ANJ5jV63uECmR5f7d4KbcWxo/+xBy+SPESG/Mh4Y09YOUeqbhXm4ykkf9vj9qaRS5iREGDf/yKmFIkTWOqojEAHz9QyJzrYrfWyr3Fu8YYOYLasQhCVVzbqIwyQ+Qed0eLLYPdP65lGFMviKbb85G5w9/1EkJcYvh8QIdhTFm3TdcQ4VgdTsKkEaVaiCQySyqS4Sp2LctaOz9J1sNU4nx6Za3tQIYSeEWzFzqUSlDRRoJb6pNTF7jApwfUix1B9RBoiF1XJVwSzYe6kDxeQMHoD8hm+8rKEpIfobcvk8SGlQLYear5ITR6iGTa7ss/3d9awejTl2G6zjyUjV+K2v1Ckq8Yp85Rqur147yyEvlvVrRoEFv
 t9yd/Jo8
 tVdgKTA2qLwkp2oS++eHOdFgZWBrwwauJkol0Lv2pzOBYOXmwKlEtXISZRbZxuS/WLNiGBhZPlAs7Ibnu52zk2b6DAUsmq/Ap4c0R+v8hpktkViFk80RzKCiz2XaY8bxmxH7bW6cEjT3aO0ZPsYWKN1UWfPW5nKzR9Ef3Iu81e5iwc1lxrS7LmR9WbfosRFhfGNojz7zVBSDxDYRljuHd40BsVmi2q8LBFbxORMN1oHAnNoNz0ncDE+SQ220KayyNkwJSDfLeaiXA7eQJW9S6UlhMUcJq3T4OGXU6Dg4hIt/LQYTi2yd8oXLrjA3+WocVGyQHEFb2W/jn++RtDx4lEO2q3+cMOvtCatxqbQoQbgIvN6uXu6FihHAXr21VPgR7cua2iZSvnhjIbaAzyeS4kpKdmbZZ3Hwz1ravJ8jyOvTKyPCjyOZRmuyYjy1PtFAxsLDzd0MrtM0D/5TJDTwHtp6cnCn6IShc3FX0UPe/lXWFogxlcJYHwZGlE1J2XgQstd9gXWNw8Rpa7hxnCFg8ldfk4Rn6hoOVBWcpg1DQYH+piVoLtKOefsJNs5Ag8oVw5w31
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 24/02/2026 à 11:26, Linus Walleij a écrit :
> After the introduction of clear_pages() we exploit the
> fact that the process vm_area is allocated in contiguous
> pages to just clear them all in one swift operation.
> 
> Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
> Link: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flinux-mm%2Fdpnwsp7dl4535rd7qmszanw6u5an2p74uxfex4dh53frpb7pu3%402bnjjavjrepe%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C5eca287345d5408b59ce08de738f41a2%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639075256284265137%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=PrUINapvx0%2BJH9Dl9%2F2bRfUJmrvPCxwk%2FxGll6rgle8%3D&reserved=0
> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Link: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2F20240311164638.2015063-7-pasha.tatashin%40soleen.com&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C5eca287345d5408b59ce08de738f41a2%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639075256284308057%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=J2HT3AP4aZTX0Va0XE0taOtnA9GsETKFY1mWhrHBQbg%3D&reserved=0
> Signed-off-by: Linus Walleij <linusw@kernel.org>
> ---
>   kernel/fork.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index e832da9d15a4..88d78ccef245 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -345,7 +345,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
>   		stack = kasan_reset_tag(vm_area->addr);
>   
>   		/* Clear stale pointers from reused stack. */
> -		memset(stack, 0, THREAD_SIZE);
> +		clear_pages(vm_area->addr, vm_area->nr_pages);

THREAD_SIZE can be smaller that PAGE_SIZE, how do you deal with that ?

For instance on powerpc/64 when PAGE_SIZE is 64k, while the default 
THREAD_SHIFT is 14, leading to THREAD_SIZE being 16k

Or on powerpc/32 when PAGE_SIZE is 16k, while the default THREAD_SHIFT 
is 13, leading to THREAD_SIZE being 8k.

Christophe



>   
>   		tsk->stack_vm_area = vm_area;
>   		tsk->stack = stack;
> 
> ---
> base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
> change-id: 20260224-mm-fork-clear-pages-ae7c52d12a93
> 
> Best regards,


