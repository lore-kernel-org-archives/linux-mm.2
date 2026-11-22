Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8AE606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aw57fiLl
Received: by kanga.kvack.org (Postfix)
	id 267176B05B3; Sun, 22 Nov 2026 14:01:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0F36B05B6; Sun, 22 Nov 2026 14:01:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8E56B05B8; Sun, 22 Nov 2026 14:01:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0FB46B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:01:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D70C140735
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:01:48 +0000 (UTC)
X-FDA: 85463674296.08.2364096
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A1F43120005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:01:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aw57fiLl;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795374106;
	b=cE1k7d9ui1xztkyjBGX/DasKNn4r8+DmaAvKTw8MwcnfZ0bxs6/fwNPZGQQFlodqO6Vegf
	+H+Kklolyg26gQIeH1JtQa/7lTvaFyC/ER7wjxv7+i//W4a0BcFsyQq63XLd+LdDUVEji/
	UTxkA9zwvA87ZmaucnTmR8IZMAbLzuM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795374106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6mwbGEwXXyN/dQg6IT9GL9GhF/RQ4pE1okmkcy0H1E=;
	b=CDsH6GpLMHQayujWNplCmaPVuSzoBk0bvB8EI87STIWQo1a7BU29xIIgptOv7kPd3p9r+B
	UYvttwrS3s9X9X9q9IfLbtA6Lu50QvJq/5v6/92jILaU5h4dy2GqCz1Cb7zf0TfhJCBnpc
	gc8UdJRZ0zP5jBFadFz+2t6cZlblKvs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Aw57fiLl;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CC796119D;
	Sun, 22 Nov 2026 19:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14DC1F000C6;
	Sun, 22 Nov 2026 19:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795374105;
	bh=B6mwbGEwXXyN/dQg6IT9GL9GhF/RQ4pE1okmkcy0H1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Aw57fiLlOdjsVTYIZFMlxwDLh70RitKlffVInmvxcubv4LFp1DgMKx88dfL4Oz5s7
	 EuArjJV8DAOZaDwiRyCg5bdtw+mmL3w2rmGAqQxDlZtXzoWgyxOCscF5MwhjKKvoJd
	 ODi5/RwHTZL+oelPnNFkLmAc1y/3/F96sYbkDOaQ1EeepyY6uDGIPSDrCYIiE3ZEae
	 bPcWD4VDrpXN3mPhnr2qlAGjXEc1wphq4jh809GmyZT9rHBfZPzXsSEkGsuK7sxT72
	 o7GLifC78Evnwc/neJnK69Bj0oVPlhU80m6PPGAgldGylk5quxc3SJX3NDDARXI9Jo
	 9xhUxFfSJ+fBQ==
Message-ID: <c7a2b0d5-352f-4106-bb86-f1629bf2a264@kernel.org>
Date: Sun, 22 Nov 2026 20:01:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 0/2] mm: kunit: complete the 2009 mm test suite trifecta
To: David Rientjes <rientjes@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Sarthak Sharma <sarthak.sharma@arm.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <0cf294b9-0ce1-dc6f-7cac-b589c9060271@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <0cf294b9-0ce1-dc6f-7cac-b589c9060271@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A1F43120005
X-Stat-Signature: 8umox4uw7k8jwaw9r4h5d85gmn4t5ixo
X-Rspam-User:
X-HE-Tag: 1795374106-445423
X-HE-Meta: U2FsdGVkX184R957PQTkjoODz/2917u20Rc/4t3Qt+Zvo70FE7RCdf2MELXZCgtjkZVdcn8WcGerpS8MFb4x7iOzSdDZKQzVe1qLxKWfjm4XPl9/B91DXgrW5lWjaxURnCvNd4SbvP3deE9O6ogVxmmSoQmu7k/WdqQou35ARTY1fX+1ZvV/0dm9rveDYncsHY8uc0vMQ0NuU9Mx4A0G5hmKgxoxiFNqxiTFp64/jHmZJEoSmHlwkv0BIiIVjcTX9HybcN/8cRlyisrOU1BESzsnAAcpsZJetRj3kCncSxMvZ4iAm0tJlADji7Tyfg6fUAUFcZ0R2PImmNuTmKU3KNrKmOiWjWI3T4QYWklH6tgRsfAZGGCX5br1U4QjrRzaANWrusMxON+51VIkfQmciCb0CJhoMhkBG2c7JZpn/VeiI2QsZ19m3AjvbrGDoEByHrnFwOPkF3udY6bcsd61VyFTxSNPdOF6fAFkyb6D1emeEpypaasVT959/x1/dImGnjkDM/2zIcTOjZToD4C4TMFXJO9PFnOhpFJxSdq0IOSr0iQOrF9xFGt4gDYudMF1wCDUt9Aw2WnUxuB+T1tG5jkRXsef9juV4HC52L8RQw1g+1b19sKg6cQUaGHaEhQ4FnZk+kkzhuNBV1ejf69dWmtYi6AlzlqX+wGhjMWp5ppFyzRxbndT9QVrICcgFdmA/gQzr0C86tFAW5g6JGbBxsXnYA1Uyep0Ho0ET9LO5y4pCVkDph2C4Tp3mcGmWOv+sd8RuivJPyXVoE0llhm1foO6ZvUTQwFjDm/tf0mny+GlqqMnfvF536VX6CYCvGWeoFu1sLhvTwJ/mwnIhFOyY6fROYNKGp8bvrnQ7X06XNMHn8UjOoT2tBOmvY/CmjZ6HGJqy6Zd4d8YdF+4QXfmSaJoS7pE6r7j7H3CvigznoUl9eQl9sShA3aWFS89UaQhq6R6Umj8/DCFJrD15px
 6SQ/jlEZ
 04ovCSXFIIurr5i5aMRwzd5xnmaUT/TdobIFdf3qARq15f20wGgEBGS1A1BrNaSRaeMdHt/YxOIg27xDZ4DPZuSF7/KEWWnLTCgo0bsX4SAnaRpD4L6JsIn/iaNXmoCdJ/6SKiF92bxIctVWk70CuzlThPWmzdAml7hP8DmPIuygl9tHhKS1UFz3gDOYMpU1mXcyLL7EE8/7x0oMFp/dkSqjB4BfdaOGj7rWpFMd0i5RvaCVe102G7moLQvPLomqViGuf61zrmQtqewpe1ufJU30VxAux5bDO58b9Ui1KozTsNf2weqnLEwKNymYzPqVKUKY09yNTkrIGCCuUko2GzRPrxO05hjoWwdt7hCrZYv9q48et0qG5qlR4nyU8Qspv7iVxOeOwYe4lhK9L3VU8W2INno0oy/4hv8cVhdgSWsIMwd1rEkQXAPpUivb6sIRajfoi0s/4EO56YK6DWTxXsJ5sfIlQcRSU4hysIsjsNQZ5mv96e119xpoOtKoUeAFGRbWZAbNhr6jlxz0GGCGuBcqKnzyfP8e139XwbJHhYKu3xBLSHHPAAjcGU4Vtwp3xPrhx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 01:08, David Rientjes wrote:
> Follow-up to "mm: vmstat_kunit: add synthetic benchmark for mm stats"
> staged in mm-unstable.
> 
> These are two additional tests from 2009 that we've been carrying
> internally since then.  They were converted to use KUnit just like the
> vmstat variant.

Please send series in a way that patches have in-reply-to the cover letter
(git, b4 does it).

Is the slab one current? Christoph indicated in [1] he might have an evolved
version?

[1] https://lore.kernel.org/all/2e88a1d0-3a36-cfd5-3e4b-79cf4c8aae0b@gentwo.org/

> ---
>  MAINTAINERS                 |    2 
>  mm/Kconfig                  |   26 ++++++
>  mm/Makefile                 |    2 
>  mm/tests/page_alloc_kunit.c |  490 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/tests/slab_kunit.c       |  614 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 1134 insertions(+)


