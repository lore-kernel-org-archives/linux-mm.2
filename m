Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED4BCC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 02:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D946B00B5; Mon, 29 Jun 2026 22:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D347C6B00B6; Mon, 29 Jun 2026 22:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C25EC6B00B7; Mon, 29 Jun 2026 22:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 987556B00B5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:03:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 190BB8D22F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:03:18 +0000 (UTC)
X-FDA: 84934931676.24.CD878B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 70194100002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:03:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JB67cFz1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782784996;
	b=0Kty3BaI0e5qALEVMDZXP0jB9N4jHIqIceheFQe/uo7y5IvHfA4Bz9DzVq7SLBVlaoz+vr
	wR7138k8ltO7LIVrQpTVmWzyBQqNtZG7R/M64OJXktphlRlAYkgdzXG7dd2FVoU/k2AFSU
	2LrWwJQXj6XvkE1ChTW4zMK2mTlHV/w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mh7wOyZn2mNMutLQV04yehx/G0sNH7B0Hew764ZGcLo=;
	b=dG6MeCB/AlHBOT1LszKb+gegwlzfvbBhIr9i8lzILcbpRY60eEhwKCKjH3knPlKvEfgRLN
	wmtLha0VBG/04VOskdTzexoSgcy1ulDew5XnwQNrGQ0YX4xbXHitePihqQ8kQX0Flf+av1
	vve17L6bTCnr507Zx4aMGTxiRyWMPUQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JB67cFz1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD17F600BB;
	Tue, 30 Jun 2026 02:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18461F000E9;
	Tue, 30 Jun 2026 02:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782784995;
	bh=Mh7wOyZn2mNMutLQV04yehx/G0sNH7B0Hew764ZGcLo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JB67cFz1Eh2BdtYGo48IZqLlyadmM5XzhgRACvMfyawWgPNoYxUHyrZy5U9qvgJWi
	 JDCxVqtXhhj/3rGgcWOlYxodxD/oGy9i/fHg6legClp2Ygb7fjhz+l84Ecz0/Sc3MX
	 dvocMWlQ3yLz6SWHtuNDCH9d7zateJBMlxyccULPWLKp0unyu5DGjtsY7kDyk9Fx8Q
	 ql36xS8xTsif8z3MUyDP9o5J3ClXX31dGr2CYylHkVO8n3V1jRSpCfLNhIntXt3TLY
	 HHTzBoPCTak0Ohj39z4YgccsnA/nZpskQIWEHaxCb/4C/cVG2Pq//iUkYMoazNaRX1
	 MEe4aRGsAkfqA==
Message-ID: <393141e3-589d-46d0-90a6-88b9129ae67e@kernel.org>
Date: Tue, 30 Jun 2026 11:03:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
References: <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
 <akCJRTnmA2um3CIy@linux.dev> <akCSftF6mrsKsz1V@linux.dev>
 <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
 <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org>
 <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <akLHy58hrzAC2UIw@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <akLHy58hrzAC2UIw@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70194100002
X-Rspam-User: 
X-Stat-Signature: jjszunjte3tr39g7taid3nfk8gg546in
X-HE-Tag: 1782784996-204868
X-HE-Meta: U2FsdGVkX18xpzeQ2ZACMaiHpoF7oC7A4BfIjwV/yrohCiQynECtn1AEURxexHzSPGExZSE1pCJnwb2x21r6HHjxlprB3uvcygSUNM4Lprjm+w2RNBQKUy0KbWoqAPO1YRBiIRcVS7pUKIGq/mqiEK5sTr03ltAZIRdUtVmCWFjjHbERIEKdPOMex9GoCC9xU0PRanNVfvG53zjuTcUXSCG81pj+dNPNjqx9odM3+oD76eWNvrAZ/N1MOB6tJjcb0WVecLUIPNv4lMhHe25POOZ7MnPdyr2XQcO0VlOVzXpTNBHd1sKrPAaObmSBUkPennVDNPf0Y9H/5k9oqQd5VwLc4oXP4+VKUPL1FkfqorQ1xxmQMys3JUiwOnCRTc1nfNu+xZxs06fEeDoquqFPp5SX7Z1bLA9XKpy7YwjDlB68d/1F+NpO103g6XUud1JWduiT0lCIT2yTHMVYi9au5rC9EuwfkRYkY+Q996pHG+dF4G+CyYuEvUaPizRKs2Sowvi1K6/ZkImauOIbxycVTN6xnP+5tPWhXHDHbmKeBJWu7bmGPQfcHrRXXEsxaR0/MBgW0rbYA3nK7EscHpeUFGb+d62clpe9F4d8kecgwDsWwJtLM5Lrtl7ercNtIFaAzLg2cy1Cv5lliThAFRI1SvE4lCbdDso8fItRRjghtXV9CutOwNGtSNkSPByqdx5uE07Ye+eMDpIsLrIpnfO/MzLCu0znkB+RXTaJ62IlioIULBtQYisqYXp/WDvUp5GQ7iJGS1TXyDcHqzt6ixsXKyYFd9Cmvw+QaAMrNGblXzvKJQqg2G+9l9mwE/iaJGblnU/zd5eIgfhblRWCOlBC7HqcSxJoRLgNBd1g8tZXuBVT4DP0p4Ybpe1lXaGEjaNmJRvZ0VpHTWuTM1yCWHhJBodToMEaAW0MQT/yDWAWR8WK6qxgtS+PGaUQA+5pYQQxm5sqvztmain6aBM1vlq
 dUVaQl5+
 /IdTvJ3Xd8RXgnV08wv+29s9xSXL6Lfe6AubJMdjoVYW8G7cA8mdWfSTBc8lEGuRUOzUxPn5n7sKKcXKj8oWk5m87aVNyh60BrRGKxhDRmeSzRT+FSMB8wxEv8R555DFkTNIsYSfh8JxQTMazI31Xtgv4awsf1iZmn15nxi2CUeA0BwsQaTtQmzCC1SsfqCYGUPoUHg1x3gzbi2zZz6KE6sP0gn7B72P7p+2/6tnNJI2besYcipPObyz0TL6njDnAGKADadtQxG1U8drxT6dO7qFoItgTjXtVMYD/cffv21ujCgbuQOT3d45z3yzjlCh3O6ufwTOF2+xgSDuNe0V8E6GG97LYVxyHdFX7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/26 4:52 AM, Shakeel Butt wrote:
> On Sun, Jun 28, 2026 at 09:28:51PM -0700, Suren Baghdasaryan wrote:
>> On Sun, Jun 28, 2026 at 8:57 PM Harry Yoo <harry@kernel.org> wrote:
>>>
>>>
> 
> [...]
> 
> Thanks all for great discussion. Let me summarize the conclusion and please
> correct me if I missed something.

I think you didn't miss anything.
> Let's keep the original one-line fix (serve the obj_exts array from a
> strictly larger cache, making the relation a DAG).

Right.

 > We will NOT gate it on> mem_alloc_profiling_enabled() as I floated 
earlier

Right.
> -- per Harry, is_kmalloc_normal(s) is already the right condition,

Right.

 > and gating on> profiling would miss the SLUB_TINY + 
__GFP_RECLAIMABLE|__GFP_ACCOUNT memcg
> case.

Right.

 > So the bump stays unconditional for is_kmalloc_normal() caches.

Right.

> This over-allocates the array for larger caches, but only for profiling and
> SLUB_TINY+MEMCG users (the latter unrealistic). Acceptable for a small,
> backportable fix.

Yes.

Thanks!

-- 
Cheers,
Harry / Hyeonggon


