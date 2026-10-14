Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD3DC3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8348F6B008C; Wed, 14 Oct 2026 14:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C8F6B0092; Wed, 14 Oct 2026 14:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749A56B0095; Wed, 14 Oct 2026 14:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2986B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:25:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBC371A0280
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:25:45 +0000 (UTC)
X-FDA: 85322060250.26.1430906
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	by imf31.hostedemail.com (Postfix) with ESMTP id B51AB20012
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:25:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=COUrGZPV;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsDWyvkEQDwDnexyTfMcAhDPYQBTnrRvGtO+n/9U+VY=;
	b=JZi2fOw17TCiN7leuUnGFohDlVTomb51bpN09uHJR5eQG/LTbwfKuvmzVCQTJ56LO89U1t
	U23PswwNJQlO15ZPF4UnP9Zote2zsO+hT4TiXj5hRCjGizamZqba0TRhYIx/Tbkwgsso+9
	HF3U1F61PPcy1xX3RXF6n2uwHmcFksg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002344;
	b=e53pTMJoJb4WPQJflqflpAgeM5UksRwtP18nm7hg1mveDXicTlGVH0IS+UWL+n8nQuvhMI
	5W0weP7cXp5xtPMNLt+EZu0r2kTAP4GVTLj69n8oEnx2SL06GXvUj762LYQ463EjvCNRcn
	khXmdguTj+/T+uHfiOBDRET9/i65Nf8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=COUrGZPV;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5UxX2FiFo5VA5ijcKXQz6fPD7Az4Sc58UOdLO4SLUNA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792002342; v=1; x=1792607142;
 b=COUrGZPVzyJPUy7oI668mCbm7HAtCt5fA1ZL1JwLDZfBO9NZjRaRbVC+VehuGZmq/NymELHH
 GkSJf4JjqBk+q2sLKHFI5GQEkW0weDF5AVYXg0yAsO4cp13FjuWFyP1J9eCuSmMp112Vl9ZHqs/
 +xOLP55AlT9quqo5PuPuatnI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 15e0d1628d62c846;
	Wed, 14 Oct 2026 18:25:42 +0000
X-Mizu-Trace-ID: 15e0d1628d62c846
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 11:25:41 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol: remove page_memcg_check()
Message-ID: <as_JE-NHoUr07Mgz@linux.dev>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-2-240b37c53831@columbia.edu>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B51AB20012
X-Rspam-User: 
X-Stat-Signature: xq5654yuyr5meyxjyr3qr45y7puc7fxq
X-HE-Tag: 1792002343-416247
X-HE-Meta: U2FsdGVkX1+rDbGV5nrnqy/oL75YHufSCJ3zxX+Om0Yq9BJhVC5Ce5BH4KnigqQm3Pw6gdXKKehUXdSrGakIfU2sCtaP37Jjkz9tfuuRXmRIumJ/eEIBgT0VmGP7QY7CwU6wP3+mwJe4ooNEDpsX2Fj4ivpiYeOh5Vx4oKN1dgsDs35SztvpQLDuCltlo7vo8NGTxc9meqAttsYscg4g7X3h1lSzA51W4OWNM84VK9tIVuEw9Ki0dIW23mlZSW31QdyRtX0XBqRrgzW2oWk/rSwEm5q/z7Iyfr5lmgwe/r1cT+wWclWzT+SOgJMilSZcg1HxsMyCxyq3s5YKkG9ralImrS27gIIK23FLVeE6/pf8y5xdLEPLm42MfgRjqvZPscFFdkcvHaFolWtlazriQAmjN+wf6nmdXsx3rGm6j/5prvjMFU80O7q9fEVeDrkwNHTy9cYn3pYRVtHllFXRRoQvFIFXvOKEZoHnkpaVC7IksTjN9Nxg/w5hBNLm80j/zn05XKUWoQTMRDdvQS+SCUFgJfw0woFOyP4Y1JRO9Od9+gATnF959hG0L8fepa0LKrRLq/GWI24N/Kk/NIeOrishFhnU1XmE1v32FD9f/HMBoUQncl0LrEzABn30sf34d52PV5r6PXTrOKNPmZP0xqWFvVL15/3lVr3c01h5GJjEb+P4TtYl2KDOAYOCJRF2RJHjY3C0NGI4ebtSpGrnwy51d1J6I6GEJSIdHsUopZ3au5LanX5pHVsosTVhbup7pDZJVO7u214oq/lxWXy/J8XOZWPEQWgmKGX1SsLCfnHAtkNlJc3mJl51C201xU2elfYS1As+OUgKrTZOk/Cs2fT1ak1BHUUfaCucAHPnVEsoHKHCx0G2aocyEqMD7D9cdYXbYeGobDHfgmwmeFaAJYQn9T9n2q4SJfdap/XbT0rCPfzFKdrAHlZn9dWHktm4RSD3TwMdDOWlHF5EmoE
 eri7CpzQ
 moDzmjnqgBCmGqk8xOly4HUmSjAmfr7+aZm/FzlpPLNfItz0i4SVxgGrsTR1Ry/OYawDbj0rjFecX8a4mj0ePYvKPjjMvrJzpmo43EYfowF9klyUZRh1zC1Nxy59lFJfteEwLCRTp/oK2DowTeNi0REYk5/S9Eu5/wS5HYk8d64+DGy3tOGW8vp2xSK4FKZksug/7D8wU4I60Uesfen2iqcWLqILWntmqcTcpxE93XtdX9XbZuyWJh3JhMHzMHyS9zoO4Z/mbgGXexZ2G05y0jDYD+sW7lcT1EHWUpLZaIiPEzCFOzaXE2Vnj9Lj1+nussE1Jh7mrDWt37rWueuqRo+DH5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 01:08:21PM -0400, Tal Zussman wrote:
> The last caller was removed in commit 90f095b816e2 ("mm/page_owner: use
> memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()").
> Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

