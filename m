Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E826FCD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 13:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87DF6B0088; Fri, 29 May 2026 09:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38FE6B008C; Fri, 29 May 2026 09:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4EC66B0092; Fri, 29 May 2026 09:28:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9665C6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:28:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 240FD1C02E8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:28:31 +0000 (UTC)
X-FDA: 84820536822.12.695A345
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7C32240009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:28:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXyW0W5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780061309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/54XJZUNKpM396oZp/2xzG+YBPtmgGgSlVSoaMI+3I=;
	b=KqrwkYCp4CP7t9aDMixaEry38XUdQspuMU4YJRAmbur7IptUTn5JYOY2wmmaH8RPGMtui/
	DXr5n3fbt4gIHZ+flttEbLLW+q7/v1EvGoGY6qij9+Pfoc6ijSDyTAwySCDvxOD0hfSi6B
	t/QbJhO8Ei8fcpErmPJvPxjLtDPb+Dg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXyW0W5P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780061309; a=rsa-sha256;
	cv=none;
	b=FXo0ebWQPG6Yf54/VYnk/qOdB7LsFEowaXPyUMvGc9NdfRZ3Ba7BQyrAhNj4ic5hw6wb/J
	K09lFKUCvB4p7k0cNHBh9tfLsJokIas1gLmjN95PgpopPWQ6uTJL5rWB+kQJBcyn7uGOai
	XI+GGfmh+yyAYeZ7qqrTOP8wkjYA6yM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 462DC44626;
	Fri, 29 May 2026 13:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEE41F00898;
	Fri, 29 May 2026 13:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780061308;
	bh=U/54XJZUNKpM396oZp/2xzG+YBPtmgGgSlVSoaMI+3I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=EXyW0W5PMa5BRrgRDYCASb7qJXDA8iF2eo0VA18rJUtom7RcUwgN2hl9eue2azE7r
	 G6qft75WExqQ9KIVL0oZBtU7P2hJUHeaNH9jMFK2p+yVG3BB1SfkW6Eo8lz+UA2pog
	 JOwWXn4fHcy3BHNXjB/TUJZiLOdttS3uyEO5p4nWBw31FVI6WxW0djIu++wLYhqfs8
	 xQjFHXS1zP4IWkqXgYPv5W2UGx+WGTKJzCEzzuOifNl0bGfiiL8u/5aytDWnbAswvo
	 NR+ZkkIqQJi+TTt5oy5pjjEhfGXcNIElC+vaMe+OasJ7CfpovHSBJcKIeEzRp56yRy
	 BbVB8vRlu8ljQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Daniel Verkamp <dverkamp@chromium.org>,  Jeff Xu
 <jeffxu@google.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Baolin
 Wang <baolin.wang@linux.alibaba.com>,  Hugh Dickins <hughd@google.com>,
  linux-man@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH] man/man2const/F_{ADD,GET}_SEALS.2const: document
 F_SEAL_EXEC
In-Reply-To: <ahmPrpekhMwD-8fD@devuan> (Alejandro Colomar's message of "Fri,
	29 May 2026 15:12:39 +0200")
References: <20260529124047.1483026-1-pratyush@kernel.org>
	<ahmPrpekhMwD-8fD@devuan>
Date: Fri, 29 May 2026 15:28:25 +0200
Message-ID: <2vxzjysm2vly.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7C32240009
X-Stat-Signature: qxh1nr3cpr9iu76fp6otmu9am14afdew
X-Rspam-User: 
X-HE-Tag: 1780061309-393418
X-HE-Meta: U2FsdGVkX1/6YeLczKAdV6pftCI4ucFz9CR3w3bk8PeLKt90UWqoG//9UNd86+LTuY+DeK+hvXzR+oRwlFvyEKXUhTPZkvVYrrFijCsg4dgwtqlcurr7z9aMLpybLg3UfyNBK8HuTZ9DzAVcSVOv63B6EVri0T7+qFA2czD8ILbgIinO5L1B8L6tleR5JT+lWV2fXT8pJO2QvPwltV/BwoyNjTtmqASVZOYqok7jt2Ubgcgq3Vg4wXRMDXnqVcxsW0W9uuhGUniWBGfDwCMYoQkEEeEPJ6yR3TqiwnxcpBOMDw9qBn24vFLT3SUvLopp81Pr/uxLV+FrpZfR9m3VrrEbVZwX2VnMvKM4mWa2nQIC5pZDI+4RnLVKMEUPwBoAfUF7r6YvSkxgS+XBvt7NaJSqnl/ts2hV3RQlaIpzuQwpVQGhZC2npf/Z6je/hSEJcb10Fat5zZDvw7t3jz+gqeM9pQ4KKWSgqRAsemi5Bs87JLzT7wCjScKgm5alEVHPhftXe3MppAIY0FHcjNbeSojEJjPS0s4pfvC/MCfJYQU86M6k4PagyO6vz7tWP4HOQ8E9DdUbEs87764tLlUkx1OcXum8ijTCq2daEJ8KBqkHXvZC6crhOrPqlIbX+tY3zaixhUrCwhRKxJEAVCbmQVe3uM9Dox9ccEEA2E848ok9Alyui/nMjUuHbzF68bMydJOddEn/MvbEgRtfKId2qTlIjLkSGavnd5NqEhjufgqJAqonBhc2rHWcBINIouZK7bZlbym13+AWEfh2Un1331I316ir2CWpM/o4ttcsH/6M809x68QaCfoQwb8qFeUoQMi6NDJXWmdOKgyNr2SqVEjKxr5TwjtRFX1nM6iAttr3mDFi0Gk88AOcyr9hCEjn8mDrj9pbbv4gCQEnaRL2tYJvDzzyV2QsEfBirnpOgDslM5P44tEVjrcg3lBlyw+pavPXdz/7A8sI2iLwCcz
 6cWmc+rK
 5/Op5llI+W6Tci8KTiCq/vhrYGIYf7h3EiFU2v8/Y3F1EBLasO8ffsQIXq+Ip1v3JVKB2K2zgNMFsNcyqUYX7I5H7w44EoGcyD8etkAMM2FvpoCpFdpv+vt9HyNagsM61uJ5eC6RSdBYVdFB0CIkUViZ786tGMjmfcJ//oRVr0V4IpNLGh6/SdIQY06C1SyVPhq1s1e5tq9HtKxyo61PaHTN9WmcnWWHeuuapNA2WQLbhSqawxapkOmBA6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29 2026, Alejandro Colomar wrote:

> Hi Pratyush,
>
> On 2026-05-29T14:40:44+0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> F_SEAL_EXEC was added in Linux v6.3. It seals the exec bits of the
>> memfd. Document it.
>> 
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>> 
>> Notes:
>>     I discovered this was missing when working on [0]. I had to look at the
>>     code to figure out how it was supposed to behave.
>>     
>>     Disclaimer: I used help from Gemini to write this patch, mainly because
>>     I don't know the man page syntax. If the man-pages project also uses the
>>     AI-assisted tags as Linux, feel free to add:
>>     
>>     Assisted-by: Gemini:gemini-3.1-pro
>
> 	$ head -n13 CONTRIBUTING.d/ai 
> 	Name
> 		AI - artificial intelligence policy
>
> 	Description
> 		It is expressly forbidden to contribute to this project any
> 		content that has been created or derived with the assistance of
> 		AI tools.
>
> 		This includes AI assistive tools used in the contributing
> 		process, even if such tools do not directly generate the
> 		contributed code but are used to derive the contribution.  For
> 		example, AI linters, AI static analyzers, and AI tools that
> 		summarize input are forbidden.

Oh, well, that's a bummer :-(. I do understand the concerns, especially
the copyright one, but unfortunately I'm bummed about redoing an
otherwise perfectly good patch. These AI tools do make this sort of
stuff a tad bit easier.

Anyway, as you say, the amount of text is relatively small so I can redo
it by hand.

>
> If you only used it for formatting, and the text is entirely yours, I
> guess you'll be able to write it again from scratch easily (it's not
> a lot of text, anyway).
>
> To proceed clean, you should remove the patch entirely, and write it
> again from scratch, only looking at surrounding code and other pages,
> but not looking at the contaminated patch.
>
> If you have any doubts about the man(7) language, I can help, or even
> fix things for you (as long as it's reasonably easy to do so).
>
> Thanks!
>
>
> Have a lovely day!
> Alex

-- 
Regards,
Pratyush Yadav

