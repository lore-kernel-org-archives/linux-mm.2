Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04310EDEC16
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 06:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCBB46B0088; Wed,  4 Mar 2026 01:57:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79856B0089; Wed,  4 Mar 2026 01:57:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C855E6B008A; Wed,  4 Mar 2026 01:57:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B8C456B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:57:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30F7A13B01C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:57:10 +0000 (UTC)
X-FDA: 84507473820.10.FEBA10E
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7C6CD180005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:57:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=fxlbV3kq;
	spf=pass (imf24.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772607428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+EnodLK0qo4vNFhzJGniE+KK/MTe7ewq/aS9nxSw7w=;
	b=jQD7lRTe+jkh/ZRkzpYARHxp2iCxtYIbVDc5tAUGn56ScLqwH2bBkZ2THB/ayDyH+wpkyk
	wr+H+PP7OfPPd4IiEMJQDsTxNhuQ1tLdoHa8sFhK26ijR3YIw8PxOpkzCqJI4bEUMuUJsI
	XlpJuaKeR8k0YieYczjJ7G8pUnyGsOM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=fxlbV3kq;
	spf=pass (imf24.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772607428; a=rsa-sha256;
	cv=none;
	b=LQmAONYOS+lbr73Xgq7jZNFx6nk8MS3Uqj9GsByrgV3mpmnPoLco6Oe3JuE5gtzmhd+GZR
	Ok3pPkZHb7RrykOIZAJ40DQ5wKijSxautK43N04+XjRlYpxkHymWRXCffT5gcqBN3C0Hvg
	APN2SlayLAG+E+vsM9VN+JDQDDi7B3Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=3+EnodLK0qo4vNFhzJGniE+KK/MTe7ewq/aS9nxSw7w=;
	t=1772607428; x=1773817028; b=fxlbV3kqulTibsTyIna5X/vnJYrZCdvAt7iIWfJF63v4Tfx
	rN4q7Cl4PaFUs+5ptlbYBWNYQ27EdlJ5mzyEGCwlPOFxBBRYVjX3GkXwqFkR2zsBVZ8AZbXR11W6/
	0uW7FSjg3y4k2m6THkTAAQjs1OvmuhjK+ZzJuMMN1bkdpyY3q5OUmYF8KiABUfS7EiKrPYXZxIAbQ
	12Rs9ds4MBpmNKSJT1t0sHmgIIA0FX0VHIf+wu3SZKLJCaS0uk0Ucc5OS51Qea0lUQ6dj/H3/NRfB
	KV9p1Oo4ksvnWM53waajRNyqBsCO+wHbqm5/RYET4B2hK2joiCUW8Cs1Sz+BxrcA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vxgAI-00000007vRb-0A7m;
	Wed, 04 Mar 2026 07:57:02 +0100
Message-ID: <4b5584f3277d667bead0b851c5bdc5cc07e80183.camel@sipsolutions.net>
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
From: Johannes Berg <johannes@sipsolutions.net>
To: Hillf Danton <hdanton@sina.com>
Cc: Ben Greear <greearb@candelatech.com>, linux-wireless	
 <linux-wireless@vger.kernel.org>, "Korenblit, Miriam Rachel"	
 <miriam.rachel.korenblit@intel.com>, linux-mm@kvack.org, Tejun Heo
 <tj@kernel.org>, 	linux-kernel@vger.kernel.org
Date: Wed, 04 Mar 2026 07:57:01 +0100
In-Reply-To: <20260304030835.610-1-hdanton@sina.com>
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
	 <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
	 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
	 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
	 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
	 <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
	 <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
	 <20260304030835.610-1-hdanton@sina.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Stat-Signature: 8erc71hckocthfcem8hw37biig35eunn
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C6CD180005
X-HE-Tag: 1772607428-83526
X-HE-Meta: U2FsdGVkX1/By0rcj/F7ucniDvPyRXAHmmQdNMrx6dpXD9oOQp4K0bFVkzo3xa2vGYQlzV18jpkdwe+XgCIp9rd07MyvGSXYKv5gYN2AXNchmn5M2yilnPFlYGJdNyujAUCqTgPdiq5Ecm2kINUwxpAQCf6j0BKck6rRqnlzxWCHsyV2OmN/49mdQpaz/2r+DkjnS9gIOd5WOGl+TQUDeDbKooxsR1xSpV1nnThnY6H0UiwVRk3vgjP3u1Yee3zuzfNjD2DnbiNhHRGQ3FAYVv8WBuSwR9vbNVkMjkVvH/IRjd6kJqOnXTPcsbjfPwD1CAdPRwxFlc6+SG2RfWIzYxHsZmQ1njGjZ3BZRkTP2RjycO1Lm42S+D47wFSFeXO9sB+QsRJh2mb2RM6QcLtc2ezxkADhG1ppq04ec0SA6IgfHRSaU67k+PZLLpQDJWyWHw8SH6nYaFaBHaoYER2spLS1KXVqzOj/oHSwhw36bfFI4DDzYfD2OnAlhO8VkDxcfqwOsK++PPQYdAX08uw8SgnOhV3Jzuxn0ed0EvPR6uO++fLWiIXjynKN9pONYBx5ILVS0B9A83Si0OfTHFYWUxTNUiemkQEfDnY7BKEHAheKzu779zczmf9Fsa/UGCSY07K9wsN9Rwc4Zu4DPT+PzR3XQvCi9qXS9yzQxjfqcM8wDMkdTWwMobJWRVFZ7l82okrPmaXiCefBsYV5gqy4NkaQ8FjD3njRJbvynRq8kFd9HPgSLPhdjvwT6tAISjjyyuEDftOz+ANr+fThSnNNxYz6kN1ZmJHTqShyXW4NbFzrZ4sFepk7fTtOBUNxNOZ7TF53vR2bMIAHuzLSJ0WgXoqiZR2nEEhO1pWQCbwHapWTfKDTsjHSxS+u5WfqWRgQz6+9VRxkQcCm0Ddli/THaAEenaLy2Y8R3lX2sLdO9U5ugiVK45LpCbjQ6skWMdzXPjsges5UDybti/gmN8q
 xd5I1plc
 WvlTibZCFiP+0W2ol7Lxp62NDWYPeCnEjA3Z8Va/3+DegsrH8zTbE3gLCWRlyb7Hrrogz82UZXtEPNgVKQ9tfsGV7PPXUstAN4E1f6BvUMp3H1nwQ6oSH5tkzFC1p4i4QrDHyvA+2w7H0F23veoyEbJx/+UlGnnQOGM1cVcsB/31xtVYXaeVpM6CFEeX1YIVNJzaEUAQDlkeaXA6yE/PoZIZldfL7KCZVjFhfuL3sPkhVeR2r1SRFxlbtqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-03-04 at 11:08 +0800, Hillf Danton wrote:
> >=20
> > Fair. I don't know, I don't think there's anything that even shows that
> > there's a dependency between the two workqueues and the
> > "((wq_completion)events_unbound)" and "((wq_completion)events)", and
> > there would have to be for it to deadlock this way because of that?
> >=20
> Given the locks held [1],
>=20
> 	kworker/1:0/39480	kworker/u32:11/34989
> 	rtnl_mutex
> 				&rdev->wiphy.mtx
> 				__lru_add_drain_all
> 				  flush_work(&per_cpu(lru_add_drain_work, cpu))
> 	&rdev->wiphy.mtx
>=20
> __if__ there is one work item queued __before__ one of the flush targets =
on
> workqueue and it acquires the rtnl mutex, then no deadlock can rise,
> because worker-xyz gets off CPU due to failing to take the rtnl lock then
> worker-xyz+1 dequeus the flush target and completes it due to nothing
> with rtnl. Same applies to the wiphy lock.

Right.

> BTW any chance for queuing work that acquires rtnl lock on mm_percpu_wq?

There really is only the work I was describing and vmstat_work (calling
vmstat_update) on that workqueue, afaict.

johannes

