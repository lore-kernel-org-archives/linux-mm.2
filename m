Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31222F3026E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 19:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1839B6B0096; Sun, 15 Mar 2026 15:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131236B009D; Sun, 15 Mar 2026 15:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012B06B009F; Sun, 15 Mar 2026 15:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEBB26B0096
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 15:50:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71F8D8C865
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:50:11 +0000 (UTC)
X-FDA: 84549338622.12.8191461
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8A3BF1C0005
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:50:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhJL59x4;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773604209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFt3zgHFP0zs6vQN/2WUghL8ETzU9TF0gakDfB5J+Hs=;
	b=MZu8olJ6dmKjWVbaIkOyC2qr7H0nb5IKTUvvDPplGgdfCd6hFhdAHa7FvTYDrC44DfOeAR
	lDqquZ0x8DXcry1vbuXHSsBdiHWCbMZrn1mj5U3rGu7hGoHmJYes5o+NDhT1DlK+wX1CaJ
	6prF9B3KsbPw0l8c58z90zLiIhNQp3Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhJL59x4;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773604209; a=rsa-sha256;
	cv=none;
	b=uD5mwCAjv8+OqkrMltv0XtQbYUVMeHq5s7mbExvw2kaWpUtwAkt+R8z0iJwAolSuZ1MzH3
	4E6qYvGdgBSgMoFTcln05G/RbXcFchE7cDR4lRHCBCSv9idWMvalj7FE+FaevN8CQDTUiU
	Jr8wLSkXnP7auroOiCLx7whduWJdj44=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93419433CB;
	Sun, 15 Mar 2026 19:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEBCC4CEF7;
	Sun, 15 Mar 2026 19:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773604208;
	bh=6eoS3LFtJRFk6+XLO2xJAlzaUGhOphBXesP3fmCa+10=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LhJL59x4BiVtPgiSoehPCAbnyuJX/VHVBa2Lb4UR4KpKMyCGyAViGn6uZ3TcL29zZ
	 PVoN7rdeSkCAnsAxQAuzNUO0AfHeouM/piaplzeU+iACbVtymIxWZogCXHg/RHUhE+
	 ibYUfEr1ujq1QVY4wny4mN5MKnv+mZrx7Tn1ATYWJrlLxVlkWcDbOfdSP1TXHBonlx
	 njVP8q9t1HWFxwt5El0oirWIU2K6CWzWHa0Yiq9+OWkKltSmsH2aUMEA65ASEjqjMA
	 uk7qFS3HxCuewjKTjGIFTfd0nYXxdy+LdFaAhb/kNiXNvUUkmvVdmxxKKXpszFDFEo
	 gOvhXD8/tPYpA==
Message-ID: <09920346-0caf-466f-9c12-5f086d99411b@kernel.org>
Date: Sun, 15 Mar 2026 20:50:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Docs/mm: document Shared Memory Filesystem
To: Andrew Morton <akpm@linux-foundation.org>, Kit Dallege <xaum.io@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>
References: <20260314152538.100593-1-xaum.io@gmail.com>
 <87ms0ajtvy.fsf@trenco.lwn.net>
 <CAAZVx98Sz1MknCcMpQXxeGpUjXBDyz+0KyRuUiCXsM+3qzqpeA@mail.gmail.com>
 <20260314111757.2a17c3acce8c3a1eb68ed209@linux-foundation.org>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260314111757.2a17c3acce8c3a1eb68ed209@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8A3BF1C0005
X-Stat-Signature: nwxj9d8uossmjyag3coxbg77hb5sgjpr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773604209-84346
X-HE-Meta: U2FsdGVkX19V+mZiB+OE3YSl1wTlRq14e5QtD6HeTFYagYzoFTFub8FwovRhWztqWXiS1ZD+OI8/cY4hZgSMjeqZfzcVewV8SnQhiyV+Q7CLjAmmKFlang89MsCjDdNrfhGsdZAm8dtzFJeXnWHddDyfAhCYh4EIl5rAq4oGNdCfCa9omjG2pJOG54GNnwZBDBn3v1OjA3dLb4ZW26u1F+Xe9vfLArROWaTSSnVEwuFXT4EGMSd9Qc9Su8UdwNdFMWQfpDtKXkTbGzrx1MH66AoGkn6z8QaCzO9Th2Yilm+zR3+KOKx4axULvSFGFBT8CQV+dFHwMQsobvn6F4/oYXlLwUWVx7DdQ69X3JsutHtLbmBOD1le/AdZ3tJad2+YNrsJlxkQq5ZqURs9vsGp0JPmWXJ49b0mrI94f/3O2XMLyoQkRzMLuQjV8D5Y5Zkb9/ncoQ/N+K65BRq6iPWYu7ayngtYFphxxu+ba/F6pOi7Jt/gFA1gIPXSYvNjD/9EG4ZWVi9v136oAa6PHHkbNNslnViTES1hF3XhkeYNt6WmQ/afyb4avsgEninLVLq7REUKHHnsXd1AIddzU1ILo39OutCMp1BUt7KhVnRZxNs0jx50bhHasbdgsmZKCo073/IQey3vqaSTQFDUFcg6cKZy4rAOGIUs0WqGDl2HBVfjdFvc+kSq7tr/ESSlN7cx2frqsH/UhX6pQh06ZcYK1yQH/e7f1NdOg+8+EaEVswUXRCaK7DayMDSgvDZQ0KUTSVt8qasD0rz0RTU4XZ9i4SB6fxOj0T6elZo7D0oTIaCwxsuYVL/PhWxsAidfd5cUt5s3j8sZe0dzJ4kLTJ3mgyuwr//7RVaEWeYqft07S/f9hqC6STJDuO21QDxhIrg+e/0jPHQy7q5dZO50994zaVHKve55vatEagui5bE1N3+4vccH89Q/HDjmb4TC7IRP61RDDwei7jRz8JPKgiU
 bvAcWRl/
 zgHV7MbBUVnF5P9WbQaFliEbBuGMLc2KRLq6tnpYTKV2fVUE9uDdMm7MQ+BLqNiDEziTMvxcaalONZ9RZZ3vcuD2E0UNPsgdkOC9LgBaQoEnL8R8j3mtiGexz21eO6q/F2S1IqG/s5tEMcUkD7PeftuHyGqXYz5yAADwFZtd4LEAEvHYEZ5ILzZ+T+imhXnnxP2VnUeAW3tdCqHs+C+jL7uE8HuinS7Sushwz4J2FhA86zvOCIlgQvwA27Lhg7XP1fHAzlt8TTchXxoP9zTHk4dDZyYXsXkbHlebYpxDEiZeUqdFM92mKGJSR+blxNh8Uu4BiGbK3g4bgswkWE9Y5G7KylgUjnxMm5UL1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/14/26 19:17, Andrew Morton wrote:
> On Sat, 14 Mar 2026 17:02:47 +0100 Kit Dallege <xaum.io@gmail.com> wrote:
> 
>> Hi Jon,
>>
>> The material was written with AI assistance (Claude) and then verified
>> against the source code in mm/shmem.c. I read through the implementation,
>> the existing comments, and Mel Gorman's book outline to identify what
>> should be covered, then used AI to help draft the prose, which I reviewed
>> and edited.
> 
> OK, so you're saying that you created the content and used an LLM to
> assist in finishing it off?
> 
>> I'm happy to rework anything that's inaccurate or doesn't meet the bar.
>> Should I add an Assisted-by tag to the commit?
> 
> Yes, Assisted-by: is appropriate and useful here.
> 
>  From a quick scan, this material appears to be helpful and I think it
> would be good for us to get this into the tree in some fashion.  Which
> will involve asking the relevant MM developers to review each change.

So, someone with an LLM but no proven experience with the code produced 
some doc, and maintainers/developers should dedicate their precious time 
to do the hard work of checking everything?

I'm all for documenting stuff, especially if newcomers start exploring 
that space by contributing small, carefully crafted documentation updates.

It's then a good learning experience for someone that wants to work on 
the code to really have to understand the code in detail, and what is 
actually worth documenting (and what's an implementation detail).

I see 7 doc updates for 7 different MM subsystems in my inbox, including

So naturally, I get skeptical when it comes to "I read through the 
implementation, the existing comments".

-- 
Cheers,

David

