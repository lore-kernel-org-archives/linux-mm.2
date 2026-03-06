Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC40BFCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340B06B0089; Fri,  6 Mar 2026 11:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EAEA6B0095; Fri,  6 Mar 2026 11:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217F16B00A0; Fri,  6 Mar 2026 11:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E89C6B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:10:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB0071B84EA
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:10:17 +0000 (UTC)
X-FDA: 84516125274.24.FF8E048
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf23.hostedemail.com (Postfix) with ESMTP id EF9D8140010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:10:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aCmT1+7gKQpDoRAl7b3WD5HZ5jyGnUSm2p2ktLfkyQc=;
	b=e73p37gwEYU35dhrwjWmCAPCfR2AYneQyRY1xi2dxSDpfDYaYKygw8xHARGSUMRTnInszM
	uDZMR6pvuQ4nODsI5jlO1n+pQbaSvPC9rayFcVJVjUwHsT0rVsqnYWCLazzA5y+HFr4TNP
	FUCPA5IYzQxNr0jeD8/j/SgiR1kVaaE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813415; a=rsa-sha256;
	cv=none;
	b=foh36blvyWTrcT3CzEKNVZz22CP2aeO1HgpRebyOmMGaj6wCZwkZLouudVP3lY3sDV55bQ
	Joi+3fxx3wMOFIU/p3Atzo2MBuN3hrHMxwXZy4Acro9YXZtibntgr+OJPqnEDqrb8CNNGu
	pO41jDiZcl5ilYUrKJcURjXOI47J1Dc=
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F379BA421;
	Fri,  6 Mar 2026 16:10:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 4E1E23D;
	Fri,  6 Mar 2026 16:10:11 +0000 (UTC)
Date: Fri, 6 Mar 2026 11:10:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 3/8] mm: use zone lock guard in
 unreserve_highatomic_pageblock()
Message-ID: <20260306111011.0937e8e3@gandalf.local.home>
In-Reply-To: <f795893125583cb4c83ddcf457a0361c6632716e.1772811429.git.d@ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
	<f795893125583cb4c83ddcf457a0361c6632716e.1772811429.git.d@ilvokhin.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19gPSG8fs7ZN1U5TP/1KHFkBxHtG/9u6bY=
X-HE-Meta: U2FsdGVkX18Keem/tAInRp2nJQnj06uGxNI6gkshzjgpENP8y9M5JhWk2zuwWTYwWUpI6skfuFdXWBBEpYiWguRWXpLfla1pkwMZ//91BNrYs1UyRMYsVvZaeTSks4+6mu2J4W25UKARajxynEPP9U9OUTFmnhiSMTYtoOCIteYeMFAf8ktqeORAmpaJh57BG971kvSuP2sCynFXGtclg4QJ1ZhyHsPduynISxk7EjHPaP7Aly3GYbLVgQxjIJfGRciKD0KtmBKGSM8dUxxTEeJ4K7HzsfYmded4rZZPypYZGo1W7nCzMJFNLPU6WPaRLcQfjnKMvXJpa9i8RNEpAdqwPmZkBAnDVDgT+miAu8I6tyJXpyBRWhgrrBV2rwRH
X-Rspam-User: 
X-HE-Tag-Orig: 1772813411-614046
X-Rspamd-Queue-Id: EF9D8140010
X-Rspamd-Server: rspam08
X-Stat-Signature: bd7jp91hsr83ibmxmfgga1tojtnxqaes
X-HE-Tag: 1772813415-334359
X-HE-Meta: U2FsdGVkX19gWTU10x6jsYcdBlDmcFo/tez5mpn3ILAW/SagJAsGJzPhIZ6H6qIX8d+hdBw50LPvJvI4clEQQr1TFJxPtTEnvxbVgdSvSjdA0riOIOoX1SwvR3pOQ+zqwESrTYFmFMBDunqMSZ0ny/rm64FjSGRSb7pQUYL0wqhqS2xxhm14KJffQk/Ab7/5JmaUsvgJIrJHU7+4m0K7320H8cQG4YLa42I+ArIZcNwLlZVHFflTj76sEYCSQCTrYlEQqK4p2PRUNbsfBgI/MWqFLtZIAB2ZYFcCUq5PywOKQRZCclOC7Pgdz8Vhy5Fyw+LKG6+RcYpuncp1UaKDMxtJzInUaAzhPiQiCl30unifEkhjAoud7hvFl6iyMuz8PaQ8AMWtHbrnDPMWhZhdd65jqYJ3xdqjDUskKXaWLtAkqBhdYSJE1s31IgJ10paT8SNjL4xk/slOwc/KLTbIErxYQzu5LukYpNNNu8o7chozjLrSYIQ6O5uKlhOEVm24sTV4bt9suVZcFwp6Y+Kji2PcqJQRXgeu5DNYmkrWdvXr6ONgH4RYTtIDh3u0I7rCycUPerAPsVeCPTofOqxR3QHLv7X1INM3FEhKGh8SaRbCLUR8+lW9TeUocuV1FdofK8hi83fjJ3wnn4ZtFXZOYHyLTym0KrQl1d+2P6vJJbSEU63rFpZ9YcvILJtgAbzJ8UlXGf3sZW7CHY0Gn6SWS9ntvqlb6XwXIgRbG949l8IFMays6L6ifFhWj7J/mmOFvpnWWKOy6gP+ALp9/cr5mWRjvBPJyMnQBZRHh0vTuzn5rrahg0F7AhRAUNlxkBhtMExHQ8U7AyfyqSLfiQXqwi0DAqTMk6R+xK/ERhiVtLnAODCnCNCz7VYL5PNROIy8F1zzxvAYHt/0/XTUouuEkMe086ki3ClvveM//seB8msTKxHngNLatENSWTTJZhDnFsnXTw3sidKaOzoGYIK
 YqcPlxNm
 sUwRD1z4dZdpI3JFaZpcnq86fmTLyLe3oR4eHwo2IbAml1bk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  6 Mar 2026 16:05:37 +0000
Dmitry Ilvokhin <d@ilvokhin.com> wrote:

>  			 */
>  			WARN_ON_ONCE(ret == -1);
>  			if (ret > 0) {
> -				zone_unlock_irqrestore(zone, flags);
>  				return ret;
>  			}

You can lose the braces here too:

			if (ret > 0)
				return ret;

-- Steve

>  		}
> -		zone_unlock_irqrestore(zone, flags);
>  	}
>  

