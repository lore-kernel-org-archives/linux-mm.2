Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 898E4C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 22:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86FFD6B007B; Tue,  4 Aug 2026 18:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 820B16B0088; Tue,  4 Aug 2026 18:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736256B008A; Tue,  4 Aug 2026 18:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52E046B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:32:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C64A61A0332
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:32:36 +0000 (UTC)
X-FDA: 85065037512.26.FEA5732
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3EEC41C0008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:32:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=at2yiKLY;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf18.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785882755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4i1mGJ+FRQRfIxKQvXxnnfkifi+5HFhjIAJsj6nqa5k=;
	b=Dyb0yLhi6oQik/vp+AlfY/My4Bb8WYY7kui4h1IqA7eZihEDfuuo5f81lrdPQqnFOOreZ3
	Q62DTcoRRRMDzXv1dq0pxIXqykIwgVG9lCn+Fa857uRpYuskr0EgglQ7I7L83yGQQ33jEz
	HIwSjOUFkT9o2b8NuwbC7pss8KeljuE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=at2yiKLY;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf18.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785882755;
	b=bJDef/ka4GPLrcM/+CJfBaJtD4OccIXAMUrMDEyXt6czcD7zwzMDlF6t84wJ/3C8mphUf4
	gSmuTRhr2ZnuNK+4/P8jzLnmiOcfolax7g6+zC01HHzft6mJcba0suJKdBnVE/EIaIuq3C
	ly0+dRqQhRl7b3uaRnTCJI/TfUjaaBo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1785880881;
	bh=4i1mGJ+FRQRfIxKQvXxnnfkifi+5HFhjIAJsj6nqa5k=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=at2yiKLYfZC3fVakZoWLhCksz0PMrkI6/d0TYKBPoXpIGPtfNc7LU+ViWv+A6CxMf
	 GC7DQy0jW4XLySRIheErfnG9B0tvk7yE/mUQWds+3h9H8PtzC63PmrbXcK6D3O7ooq
	 2NcakzJJtfeuENJUfR891WT/5jvSHVkQBfAfP5dE=
Received: by gentwo.org (Postfix, from userid 1003)
	id 2788540E6B; Tue, 04 Aug 2026 15:01:21 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 264D540287;
	Tue, 04 Aug 2026 15:01:21 -0700 (PDT)
Date: Tue, 4 Aug 2026 15:01:21 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
    Mark Rutland <mark.rutland@arm.com>, 
    Yang Shi <yang@os.amperecomputing.com>, 
    Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, 
    urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
    akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com, 
    agordeev@linux.ibm.com, linux-mm@kvack.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
In-Reply-To: <ea268481-d584-4744-99d6-0b05aade7d5d@kernel.org>
Message-ID: <b4b79f6b-e09d-bbb1-2181-07e756e849bb@gentwo.org>
References: <20260715180455.515692-1-yang@os.amperecomputing.com> <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com> <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com> <amCPBrdltFSE_fEf@J2N7QTR9R3> <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer> <63ea8156-a109-b2a2-6d35-1c17ad7f1a9d@gentwo.org> <84b31836-1d10-4bec-a469-468b91fd4645@kernel.org> <9f146ce0-4adc-0c00-a2d8-c01b47edc9d1@gentwo.org>
 <ea268481-d584-4744-99d6-0b05aade7d5d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3EEC41C0008
X-Stat-Signature: jhztdzdkuf79j4pzqiykbuz8mhhdguqo
X-Rspam-User: 
X-HE-Tag: 1785882755-439456
X-HE-Meta: U2FsdGVkX18W7UsYgOEd4a0qWbo3aWn5A2XZh4abc2ffnSCJG1D6RsIHO+IkbBeWMPqcITQCACB6Fv8LzT/jx3cnbY8A23wi4UtLsMkGwFK7rFVrQHK4fb/ZqWjXaqzAgI4beu9IAgJ8DRrhsjtweWkGytY3WxACu5nvGag88EDjXcQy4A2qCOQNCKzbmmU4pOiobJ2NvnjWdChsfOD73S4//en3NlWIekk9g3PQ6VYIFusLR1oZXXkAzEo4dsZXINt35Cof2jY8ZMf0+/7j7lHt7IqwdWvhDmqTSvewmx36k2IQxcv7ObCOKU30XhO6gtbptykCWtD6szHxQGrHL1EK+/xj4UfrHDMk/LKRAcqZcQwAXpyXLRA9pRaWrL7hZ/T0kH3MhjwAtq2e/rs0LB7kngLqaGiJxr3aUdMkFTUZBXJ9L5rWWoolivxU4Ran2VcyVWfbctQO/ypF7BdLNH2MbxiHjzjF2Sm9xP/VmY7XH/rLj7Nq5L7j9KgK7IuX6/gdHXPjixNmf6KkjHcegm48IQQrAjAhE7Tp21kNN0MZUe57/ch1O7Sdn2A91LHEo4r51KTpCYw23G4skmSTCpNi5pqZFNNHBhj5/1zkJz9+4+2QHh579k+MF+AG2dwjRTkO9p0CBjp4YjK8cmh3bOxsYZIyTrY53W+b/nEATYBGsuYrhkBHUulzPIkpGQ98NZZtEjn1ArDG3jDh1tbc/+j5bC/+QLqE37MWecYMlmE+c+H9CPvpiDGCw30JJkuy4VEWZXBa+HjT6lniaQWD37Dj4Ip4Z5hYJVRHvfyhFlx0fIl6cYtQhgSccF26rMmNXcXF3PMBnWsKTYEQ0lkv0X7rTJxjDKSgAvg8bi7RrPO6D7escH+8wALf32+OktSQBn6iZHVhNt9+cnTvZhvqhKc3OB1OEYxEM6V21/BPDr+XebFbyCcMw7Tg85hfiWTx3nRmzA2jeeFpRYPRccs
 v8paXtBE
 QzE6YRuIfMYdKjKbDzDIM17JRDDwRt4J0GZvEdYu2yGAK0vX5bbbIKJnHt+4ez/VyT0xLGDG4XXvkJ0fVFdDl3Lu6uLkYaabOxT4jMubRl1gY4n5a2355bAWtFELbXj/tiK7sfLLfph2a2KBugz5p5gqzWaP5T20wP5CiYSwKDwO45iQbEQjmlNy9ikl04wzOdLm7DxOhIP4aYt0CP6tGcmBb2tyaW0RnDHznbV71WR5hlNeqrPNYPwUBQpXT9LSr5CcLhC60UgQxNUjWlBfHlJ+F1iAEuS6UWBPGIH7Z9wuacsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026, David Hildenbrand (Arm) wrote:

> >> If the proposed solution has a significant benefit over Mark's solution it could
> >> be discussed as a next step; and it must be backed with sufficient data to
> >> warrant all this complexity here.
> >
> > You cannot accept that one instruction is faster than the same
> > instruction prefixed with another and something else at its tail?
>
> I am pretty sure that you got exactly what I meant, you likely just don't have
> the data to back it up.
>
> Proof me wrong!

Well you seem to have alrady seen the benchmarks that we ran and are
running. So I had doubts on your sincerety with this comment. Seemes to be
be just there for effect.



