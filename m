Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D858C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26ACD6B0100; Tue, 30 Jun 2026 08:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21BCE6B0101; Tue, 30 Jun 2026 08:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10AE36B0102; Tue, 30 Jun 2026 08:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDE1D6B0100
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:28:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49AE08DF0F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:28:05 +0000 (UTC)
X-FDA: 84936506130.22.43019A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 807AE180007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:28:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BNwV8HFm;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782822483;
	b=JaLFRqJDReHDGigCyRBrLxCz0uREzuLoTIcS41ElnddATqEv3vNp7/tyK4dny5hoL+R0Ex
	dSbHC+YuSCh08AQfK63iTRKTK92O3guj7YyU+UN3xHAqeRnwi4vZ5ypthg5wXxAhrgNki8
	0PZ9oI+2RBjGvAvQaFYLikYEGa5YAEc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782822483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIGB1rJOCZO/oJ70bNZ8JWihrkKz/XdZhvsbS/SGNYk=;
	b=03GxQ3o8GuHnENDZgYQFmjBt3JsjJjqpUXT4rBXQDnNqkCvEBN9+F9O8/Lt95dpMvJ6nxI
	OFHhfrDUKFeCGqFLxMwm8Wan5BxGhZh5NxnKiYbuQ6ZYCIj2PVGNobFHG5J5hXy3IljhXu
	hckMSvJ9s3b/Qv6cXKG4x6bvwL/C/Xk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BNwV8HFm;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF05D600C3;
	Tue, 30 Jun 2026 12:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8A81F000E9;
	Tue, 30 Jun 2026 12:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782822482;
	bh=NIGB1rJOCZO/oJ70bNZ8JWihrkKz/XdZhvsbS/SGNYk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BNwV8HFmVbRpnN67ZOGxIRi3Wk0MqvEDbhpwZzG+RqZPg1J9NWypCBYpTnx3uIkgB
	 jdXVZSTXX6J2SX4ajP6WufCk5WOshSUjKNeVt2RJvavHy5/nRpaoRzdfPH2BtQgCsX
	 faTrDO/fOQSpCxh/vCw6/mXoLLI24VNuMvOODskEH5acusTG/h8HkPHoueWFyIdye5
	 4FBvu8q2wyHpbEzfKfjyE9J6T2MlJb6VoWfiTa91yEZjlbIYUiNd2tm4CU2xBZm71n
	 vKwnieSiu+IVBTfYEd7QSJPjDkuApTTEm5IGQlEUCGeJ7QIQ2WM3LZAbQ4ek4bxT7U
	 IYR3GetozsN7Q==
Message-ID: <2ace7cea-ebe3-46bf-822e-ec30c15066d5@kernel.org>
Date: Tue, 30 Jun 2026 14:27:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/16] mm/page_alloc: rename ALLOC_TRYLOCK ->
 ALLOC_NOLOCK
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-1-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629-alloc-trylock-v3-1-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b6swypoeg4qjcun7b65n196onxqqx46m
X-Rspamd-Queue-Id: 807AE180007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782822483-348061
X-HE-Meta: U2FsdGVkX1/AmLO46ACAHJBOG2Q4DCvrAFmJ3G63Z9vWlzjrIjydAAdbkXWTv8/biOHEdTxIR5AHIqNFOJNbJ2DSf6H/3x/v/4vQNGhGJjZIsZwOrlwW3s8SepafPusxW8paORSCZKKnvDhFPjaqoMLeXDwXCKtQj1FZvoq9jkmc2EY5WeP7LFk9DPluWCXSau7iBr71LDYTwuBHuz4e+r76xBfOBlWmgeqYQOKklR+Q81ulCVtM7HzpL7z2r6q3/d7lHH2FY2+ITqCRHfES75VywRwSQr7fKHaI9cWaN9HfEG4BTRkBxRRJ1/DijBQR/s/RmuJVU/KjopEFTKfGlpOs12LrGyN/XswidJFFnley5IEDMBGHxzQ5fsJisyPuwUlyrz8VBHGRBVGmESATqUyAQ4tAotQj1bhNmZX5XVtCJBVl39cvfL8eE5h0Qk3j2nKVaFs9suMxmxoklY1/Ot+0Hxc88i1pdqpWPqjeMGyYgN5AKSPoBEiN0jd8/7Zjvo0o9Cl8KOAQiCIRcCdBjFQqXRFc3dUs3zW92nVOLW4CPOYVuHbBj0WHyevx9tLaw1Tik+OwImueREvsdD2p5sQF2LkaSjmtd8tLRZ6w0/h8qrYMy/CSlfD7HKSC4GMq2PI8soADSR/9sqOCSLdS3PRXjVYQBLlKduAvp+BYzkp/gz6+PkOSI6O41BWE7Eicjh9LnNEInqmHLB3NZ9cmvpNejJ19vm957p2nDGmAyxWAgtPLyG1+sBFRNN0owwWaW79gLekVJ9cBvMMdqRMyBmkJAw1vJpf1wqDXVzk4y6xmAP/XHpPoC621ZsM9c7WjsB1xUEgX6Umj2Ot8jjg2VCE+mHORaFuZtjHrA1Yy5gHd4+n9SWjlR+hPXSBYsPlTYOcvL7+7niIcI9jhG1c9rukWOyU5tNHh23+7gHyf0mb1G2MOLqaOFMIOrhIrQRgkWNdNM5qtGPGMUUBktC1
 FPMq0n3o
 dOER7Podx0NlLDkNs6RR7WkQPXwzmM7h0cnTuYZlgPqaJkzyPKU51qY8FIxJ1LPGmoaRSZt2TGSgK0je2ID5KnQt6wC8G1qcbjfvRPuMBZhL+1klBPP9Qxq0FgXkvI5cOo/WLleRN/Go1BgU5YuHWO2HfavW/u0a2xAWCjXHISnEjo2/APHsWwqEi6/EjLl9ItRVVIAsNJIE9G5yo2xNkMnD+aSenUtadGwx02x0cZ5Spv3aaSIvyyvkBbUmpRZynFcS2+/w49d1C3VtrVi9LNJwzi98C1AerEY8sG6HLxPSrKEE4B2yukGuL1wXBKryVBnyPK7eUTk0F60S1H9CttkB8cMfZHnC4q4nLgCNGvivrfkwY+kdRYyqjEN5WIQiDJ1drHlHULgbz1oWBs3XSxlpziXv352/Yz8q/73V2zwKwsic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:11, Brendan Jackman wrote:
> It's confusing that the function is called "nolock" but the flag is
> called "trylock", align them.
> 
> The function's terminology is more visible and has more mindshare so use that.
> 
> Suggested-by: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Link: https://lore.kernel.org/linux-mm/2399b3ad-4eac-4a14-94c3-27e9f07972a1@kernel.org/
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


