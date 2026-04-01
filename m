Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E6110F6FDC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 16:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC106B0005; Wed,  1 Apr 2026 12:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C36C6B0088; Wed,  1 Apr 2026 12:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9003A6B0089; Wed,  1 Apr 2026 12:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E77D6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:44:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B52691608DF
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:44:39 +0000 (UTC)
X-FDA: 84610560678.06.F599B21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 08C78160003
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:44:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t83NRmcz;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775061878; a=rsa-sha256;
	cv=none;
	b=3y0LlWtJ9a57SA3UMghK5vAj0h7z+hVIEBj72MEFQQIXDWK+CvZzIbETpZdG1fMbu+vKFu
	NKhJBogTBbSn1wT8L2DAZtwjuD+68sB4lQ3TRHCJAl0FTYfQ6wfhR3fqvthzoWl2Fef0r0
	3zX5QX7U0/cmSO7BEGRryjoDE48XP3I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t83NRmcz;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775061878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1Wu1pVXZAWbhwyJWgIGkYmjtqOotlc5ym/aFKDUEik=;
	b=R1zd0+DTDtJj07tZbc7bVTJDjt52AhtYaxjQodzEHi8d23jXc1an8n4+cj2IkDUF5HOBx5
	OhlaPguDrcmldOumk2EZW0B2QKpzgoIngi7DZFuJn1ugnX2DhPqmtEHgcaXk5/znYNcCIh
	khtnrWDOAmxP1RHYDPTHGkg7ID+uMrA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EF1D140B00;
	Wed,  1 Apr 2026 16:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBF4C4CEF7;
	Wed,  1 Apr 2026 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775061876;
	bh=iq//KXqZOjYC2twVYm1HleMs4iVAx+pB1nyZhEdk28c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t83NRmczOO0cMyNqAWnMMzAFCQWZ4uxYr9ha25Y06L/IB+bKIyE5VgtUFHeKgWg0J
	 qgpTX9DQySC96eevO0W7dcXR7oE4UuY60oAQUpUWXuES+wGN1Zc8e6zW5Qp/g45nWD
	 zWoR/9As7DMkw6JZzf2mUCoFRG8QYkkFzAu0+Vtw=
Date: Wed, 1 Apr 2026 09:44:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, David Hildenbrand
 <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko
 <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Harry Yoo <harry@kernel.org>, Alexander
 Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Muchun Song
 <muchun.song@linux.dev>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Jann Horn <jannh@google.com>, Matthew Wilcox
 <willy@infradead.org>, Petr Tesarik <ptesarik@suse.com>,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] slab: remove the SLUB_DEBUG functionality and config
 option
Message-Id: <20260401094435.cf1d3ad4bf473c3ddc00c434@linux-foundation.org>
In-Reply-To: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
References: <20260401-b4-are-you-serious-v1-1-dcacda70647d@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5976baifykqsrkm9imgtqdpxytqm39ni
X-Rspamd-Queue-Id: 08C78160003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775061877-583101
X-HE-Meta: U2FsdGVkX18FDKglhEPwkFTPsz8RsJV6VrVmjPZvucKp+/h2wt7IoReOETdk6fUwzdL6Bay1JqgKvpwat+37PCTFQ/zv6p2hB/p+Got3EWmqvCmcCeYWGhPRMFH+trHx/SCn6Li0r7llUMQoYUtZ8wx9DWTjh8Oq2Vrg2hNmdiMB8guakf129addsTw7Opb+SnxmongU5C0rFHbPLGd6LyCosik6nL6EafUqAzsQenIMyyYutq4Cxk1p6/2YWgpW0Yo3ZqtISi79cf+6lFUZt1d+cLOC61u+kCPf5/L2+6HuX01m6/EUvFYAx/UIIzrd6Oh0c8bsUAYY8AERkzSYvXxdEKjI4hqtiynYvzJU0oogkcJOik8rYMMTjKgNet7rA97WHJkpad4d2o9H82Oos1PbgLhBLTHOdvN36GXDrFf+Pnalc/IEqUI9JEwU2ju0ner/pbDgU+MtQSOGufeAlQz6pwYGwUvkYxepirBqdWv+BH/8XMghoSPU2VuBHroCZYUfOXYraUfTwxjGbWat6Y1JNeebx0Fr3Nf/YIb9ZDCwhdKu2jeGSCdY6iq5cgnvlNVIzWqbCDq54rYAZZ9cRr+s375dqsLwhU/4ik0H1FmZKmYIplz4t6+NaUHJ7FUKDjXMTAnB14q5Jl//3DLCgcGM73KnqkR/hLZYiFbpQDaG/HRhQd+qdv6UFEUlHoYz81LEhvyaB5/YmPc9UlA5en8gytYGgfSyft0RYIBUyy7YBYlvWLE55+AqHzm/LXT40Ex2wdYwQIQ6p4rq931xWBowm6pFDzV1QQypg04dBgFd6tLw6mSnx5HbISLSmGZn5xXSxO9fhOFARpwv4kHfw0s07njTyQIJuugpF1lZFs79ZqxwnpRza/RnsK7gShUq33ckLXofhKguPVvjd3W6WunXhOh2QX6bBWcT2xGhwqFLECmWJS/WIj4hm4hwtdVRZDLq77UInNEmf+vfP/B
 AGImfM6H
 JYrj/bwIgVHUZC+RoLYL3WZSVpx/qwm+uq4gS7rYpHIakKnekoTmOplaiZ/CPXG4qONnZuolCY/YTs9AARrLqMDPIkRuberEfENvmsNVGBOFm+DgCJY3EhDUyVQ9LNTlGQuCXcDNGVJq2pRB81oPJh1y03fZhaCdIPx6V67cJkOtVUa3iSt3ufdOxvQV1DYjJ07fWIqUd3pHs2W2AY/tqGjg/3bQlE6xSe98uVIwFZgU2Mshwm42kmFBgTgGwr/tfzLJ1yizBPzwaFx/1vRMFiyy5Cq60syD0pRXNK8PmruaM4pkN88QktUC1QihNASWyXfdZD+od+f6tNTav5k8c13zFZXLFjye9k4vmyCA8CU+gDfY/JgVHXyJHQc+kL8q8ZMULmhY5kVUsylU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 01 Apr 2026 12:59:29 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> Since the slub kunit test depends on SLUB_DEBUG, remove it too. It's not
> a big loss, see the first point above.
> 
> Singed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

I love this one!

hp2:/usr/src/25> grep Singed-off-by ../gitlog | wc -l
62

> ---
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

