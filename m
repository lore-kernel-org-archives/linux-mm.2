Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D75ECDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375266B00FD; Fri, 26 Jun 2026 06:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D016B00FE; Fri, 26 Jun 2026 06:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264476B00FF; Fri, 26 Jun 2026 06:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02C256B00FD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:23:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00E9C1A03F0
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:23:19 +0000 (UTC)
X-FDA: 84921676560.20.1F97257
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44E0D120005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:23:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782469398;
	b=L8KSgyy4TcTeInWvM1kuReg9VWNI0Qt5Krdmm6CQr7GYFovVtHlX+OWB4rhDs/d+4JJbNC
	5pYcQ9LW94P9zDi43L18yptQaRRV6QwLE90ISKv5oNJUO2nvYYrDfDR5Ox597Tzgxh3jc1
	R5rb7d7fGN1KaUi7pNCo0A+jrriqH7g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782469398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l0uWrMiI3M6zkcQea77+jqTJiqJE2gPQrXElfWsZdKA=;
	b=oVyYzpFLAunsCiFrOvvZ61qmAXXtU8fD4CuzbcV7CH8puTzhA7dfcTHI/1c77J6MINQaeu
	z8Wn7YDfqjqcW9e0tBQ8vCPZnlqKJnIa+KCjPJNcWA768sp41w1Dgyw6DS/okCGPCd6T9v
	dCStPAXMxJWvXxVW9t6rDAHf2o1Squc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	none
Received: from omf07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 357751C625E;
	Fri, 26 Jun 2026 10:23:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id AA7992002D;
	Fri, 26 Jun 2026 10:23:08 +0000 (UTC)
Date: Fri, 26 Jun 2026 06:23:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, "David Hildenbrand (Arm)"
 <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, linux-mm@kvack.org,
 willy@infradead.org, usama.arif@linux.dev, akpm@linux-foundation.org,
 mhocko@suse.com, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 kasong@tencent.com, qi.zheng@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/lruvec: trace LRU add drains and drain-all
 requests
Message-ID: <20260626062306.44f6de42@fedora>
In-Reply-To: <1136baf3-3967-4202-9eaa-5fd667c235cf@kernel.org>
References: <20260610195220.12403-1-jp.kobryn@linux.dev>
	<06122cae-e28b-4ded-a9dd-d380d31c5230@kernel.org>
	<ajK1YsIJmD2ImbAk@linux.dev>
	<1136baf3-3967-4202-9eaa-5fd667c235cf@kernel.org>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18i3ubSx5a0B1uVjoNYOjwVqf25DfQvgBI=
X-HE-Meta: U2FsdGVkX18dEIt/QbvxW1C1BDoR1JEG3lP5M8wHCqeCYL2cuvVnSTa+W0UiMILPlOZsA0zVyi/7ucWgezgIXkHfWj5C9FhlQKUWEZDdnmTE497HDjX4tAtMJ8Ep8WFLmwnMf8o9gu/8XDz4PQre1t+6+GtO24a3xEyPZ3UXIs3owq68uvXGRNQlHO0La0hdQkcu6ZsExDOlPsc3YJ+tvtnXqpKFdvt97Cwt04Sd46T7juRCDwPIw38cm7t+/glHmVjsUQxMU0Ba2p4ZzhWh2pcpBxJdq/tE9b0jeCPoNnwxMeTe1Z2N6NCpwN/tmRNSMC0zwPigPjULT6nkzV4jra5206sqnauchMLvU5pGTISuXyn4Iyswkg==
X-Stat-Signature: dbpwax3bwrjrccm9k1qybxf4ji8fp6zu
X-Rspam-User: 
X-Rspamd-Queue-Id: 44E0D120005
X-HE-Tag-Orig: 1782469388-195604
X-Rspamd-Server: rspam09
X-HE-Tag: 1782469398-824578
X-HE-Meta: U2FsdGVkX1/XVEVLVSlnSwnPZHL8m4Y9JvLVfiL9xx7+Xnd9PmwiFM6pdcxbf1Ed8eYZ86jExVRorsZCxia6T6XlzD84ES7T3yZRgpJYIhMzPjDG1z8ASUXBKQE9y5Fyonu/tQqNSwTCNnXxuychxKKPZCtMf6/tmPacz58byvKD+qDFkxGeTq35S4fvLbU4uYZkJjkmTNMi3AQ91VHHWp4CUr4Q0SsghUUFXw7cietgw5AdwlvknRlCrVEMPysB3umE5530WmwEa+rPYV18KYWFVsOjIAcBlu+QZbZfODpVCMuaxKppNrgLStEpAmhTgOew0bgTUR5/mI8DXvLiwYKycE7kWi8E/GbcbsYrQLUbiWbimw8qVlzs27n0s0i4dc8KKWGq00wV3oH4eOFaWm/FYa2taHmbiHIW4zGUuVUxPeSICF90xGV1oRtCa/shoxOkHIYiCAsubR9hejbCpTF4dsaZUQR7GZZzpIbZoJC11StqBBVyGLnArr89GLd5NTPGXMvtc+zGZ7L9+Oh2dl5bErHXQmDCicrktF8tFSZ3FSmxEKMcEtYMff2w7S7SkOsuSWM8MWE/fGoP0P53gUS7Y1wlHazlrBwmEAjk7BPjQ5NqIHFtjAzJ3+mPBhF45dRNmNSmFb2PVFl6JbuvYGgg4Dsfni66FbdItcgqp6pDyJqtb+q7pwPhHTE8BL0E6Bga7oINwPE8LadywvTtGa/TI5t+e+T+gKiFjBBloEQv6oX0LoC6Y4Rbm3dqZDrEYHBCsTQmW8/QA/C2k2etK0BQjDDrBz8I/K7k/5/o6TM341dSJ48aQHiFt6grV2eoFugJnMSKmifKVaI2MsbNiX6mWi39Pd/MeAkCCZxGLso2/tc/w2QdREmWrCC6+VCcWmjoJYVxRuPuQ7SzCCC5z33T/W86o7FYz6jWlKaiOxDYcJorGZtG6/jLjj8wTsw2mt5W9fXaZVwVPgbvCgy
 jibYQpC/
 6z3A2vj7BcnrKzmLCeQtsHQsrtY+xCzzoQ/AMjQB8Duxbcy5zrFvnXtohgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Jun 2026 20:18:57 +0200
"Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> Yeah and I don't recall ever that a change to a mm tracepoint would ever
> break someone who'd complain and we'd have to revert it. These are niche
> enough. So I think the risk is low.

Note, we have literally thousands of trace events already, so the
chances of one being required by an application is rather low.
Especially since access still requires root access, which limits it to
administration tooling.

That said, if you know of a tool that uses trace events, then those
that it is likely to use can become an ABI. For mm trace evnets,
rasdaemon is the tool to worry about.

-- Steve

