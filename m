Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0EFDC79F9D
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3146A6B015B; Mon,  5 Jan 2026 10:23:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBCB6B015C; Mon,  5 Jan 2026 10:23:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7736B015D; Mon,  5 Jan 2026 10:23:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6BD6B015B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:23:33 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA7271601CC
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:23:32 +0000 (UTC)
X-FDA: 84298279464.04.D7EB1CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 54EB214000F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:23:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bv2bf1Vd;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767626610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kvol/NELX0tPFUtDya+ReTe+UwusQer03cBYWzkJb5Y=;
	b=iFulo69kboT/go29pyAEhoMz3UKb9Q6/QBJwN2BmYNALXn8zPFQJSDqUaDx2qsCHLllKu+
	/ahG9swZgEowAtVSz8JmWkfBpNcaO/0Y5kVfbAhQCU4BiHxfMqYiaLm9SNxXmG+1ZphMtJ
	BEiDetpCbyXzWs4KtipmgpgoqbMGyLA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bv2bf1Vd;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767626610; a=rsa-sha256;
	cv=none;
	b=KFz9OrjIzpNmjaF7JBwkKTF4yJDs6aSRkJ71YN5VnzicVuI8a33z/uxdfA9YL0+iyrgrFU
	v4SQbroHKBmNtf27JLf0jkxgSFvc4o5SQLWZUGwcqwv/Fqok/Uktg0TZCBD/3CJ/NLmm5c
	TSKQaFfarrjgoKche9T8NgSsVp58a/8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C2A56011E;
	Mon,  5 Jan 2026 15:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF71C116D0;
	Mon,  5 Jan 2026 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767626609;
	bh=LtzYOHMdA/4Q15LdVlQqArb6eJ9bup1EzXK0sLlkQfU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bv2bf1VdVu+c6YEbDqrJiZHjMB/V32/DgX8KrjvK/WLsU1G8xPZvtRReUa6ttGJ+I
	 hJ1+fWP0CLOu67opvyIHrnk5qi1IYWWvyFHmuLYikwNaJ6NoYJxNQejB/+cUud841E
	 LMp6aw9cn9PJ46vINPSIO4SroKMHcd+206lD8gff8NRbW1ICA42E5Z+XSTemXpUQu0
	 GNYctpTJ5UfIdnL5Tv1lXjSDk6GPeec8vcHwDaZzYQhBtASDl2qXXmyhM/LZiewoLz
	 5IcgIOg7Od9G3GKt6csjo6W4ims4+OgonoRrS1DZp5VCGKO/kw7+2Q7BRvNj9FnE4j
	 F6Fov+xvjNlog==
Message-ID: <350310f2-8644-46c7-a29e-c977e76f0285@kernel.org>
Date: Mon, 5 Jan 2026 16:23:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/vmstat: remove unused node and zone state helpers
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, Joshua Hahn <joshua.hahnjy@gmail.com>
References: <20251225210213.2553-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251225210213.2553-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: rjabantew1anz7mrwoxaw3ape94gogtu
X-Rspam-User: 
X-Rspamd-Queue-Id: 54EB214000F
X-HE-Tag: 1767626610-355639
X-HE-Meta: U2FsdGVkX1+eBqoAa0/Gx/NKylqGd40XEQe3qmsFX04pHcxCem2IvZcf7O9roZHhf+xVegqICCqhqcGmKSTyooIQAImn2SMK+3z5W2a4FwM4O77YtByG1Tf2PyFnR70TY03NeYxQc92yrelLf1QztIWqBpt17++P+XE1j7aZEsrswly2VoYhNOxXksNIuuLifYQM6VUMp4tiy7zlab8KdHt3iO/vUbK/LhGMKyrRXczW39gEKEzwlZEyHvXy3PDe30HojskaDWgxMGED6uQ2iY9VzIGib1qkDlrz/pBp7IarHnNOx0zOCZTmzR71yIi8dSSgVqQbV5DVzaalqya8FxarUtW2aTX0KEbo0KWZl31eVskrWbijUz2KCOVOX3RjrkTIY2qW0IBEJHqqlDB7OCYoTtsdb0E+jeTdhKV69hntSZNP3/xFojhSpOGqi2zYUOrg4VaaPv2I/T3LiyDWoWvApJKyXYyb2ii9lNGMXa2f1vYHMaizL3i/RtfW2zXIkGcNkKhbJKQylK1ZzFTFYs1afNKyLttsAC1RWzfjKW8ZO5zeodSZps0t0rTZSXYeUZBlViwrzVVvu9mGaZ9i0ADqJpj8z/09bPV0SxBo7xeH4KwVybElFic5kgyct6pQUBpeQlrE9f0/xGgIQ/D66O0x6OGW7vyJtiRDxpMAYF+rwWwxIeyH27QKn+oG8qfpA68obry+CSaOEoFPQKjxq3r3zvqmHmHmuy5lA06TIaD+hrsvEyW2ek8CxdNR6MW9Hd89FeRCmF1k6ZDyMsF3nks6jQPK5WsClmDTlMDjyXXQ3BjOkwQRk+lYWHu6mJtAUNWEPb6vmNUSEzdDEz/BjqOJNVmLlWz5DErgU6LmeXbzs8cC5+aDVMLSULzPSUx+7vY8RRPyNecXovATqIrDinnQJaoRCINYJ4vzFwA4F5RyzHRR4dyUubV1JKCD6p/l1OyAtnQyeGMDD7NbgVQ
 BA67zZAQ
 8KnhwWmxL5T0F8Ik/IAfC1VY8xFUPA+9b40vP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/25/25 22:02, Wei Yang wrote:
> Several helper functions for managing node and zone states have become
> obsolete and no longer have any callers within the kernel.
> 
>    inc_node_state()
>    inc_zone_state()
>    dec_zone_state()
> 
> This commit removes the dead code.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---

Note: It's good practice to describe below the "--" what changed between 
v1 and v2, and to not drop RBs/Acks for minor stuff.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

