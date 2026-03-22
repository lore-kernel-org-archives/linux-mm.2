Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64278109448C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 02:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A3B6B00AE; Sat, 21 Mar 2026 22:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3EC6B00B0; Sat, 21 Mar 2026 22:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2E46B00B1; Sat, 21 Mar 2026 22:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0AC666B00AE
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 22:12:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 423948C2D8
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 02:12:25 +0000 (UTC)
X-FDA: 84572074650.29.6988C6A
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 514E840009
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 02:12:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bIlwVrpZ;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774145543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HwOS5UWtX1uofgITxSgtXLu1Y+5Vb3l6nTgVjZoF7o=;
	b=aOnDnx4CWl/74Ev4GhlSBEo76towy4BM+MbxcTSYVH03/FAeWNzrgfPRqIYUrYO5CuotdC
	tqHK/q90BYbQjdf4fmYH79DHRdhraLrG4GED2XORbH9B14Zm7zN5WVp/iJCLZJSFXLkduY
	hKQgnvhRnlrP/ihzvYQHHkRhUJpOF/0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bIlwVrpZ;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774145543; a=rsa-sha256;
	cv=none;
	b=x3zOA5FijQ+wLoBPoL+kAHBrPYPL/9pq/6DCg+4h+0ePZOVGYN0vMkXDkD1xG96RD+PWQ0
	shbywF0mDva05IMjwucFrNQVJ1orS6FWAcqyFVoi+q65i6lb8uFhYo+9s+4bBSxgistWKU
	PtpyAb8Lf1pUypuGno/TsAC/mASxBbk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774145540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5HwOS5UWtX1uofgITxSgtXLu1Y+5Vb3l6nTgVjZoF7o=;
	b=bIlwVrpZgwKTjX1twNUexAN00+lD3J1Z+rL7CGbyF7NulKDtEJyGU+BdSPGzD99QJmU8Q5
	u8y847Qkh95VnhrO9p4VD0/vhn2VHTMOAT/y/26Xne/n8QAqbglIvianiZgEhIi6dbNT5l
	yV/rGi5pzFiPC9d4XvkIy6/KGCvx7ic=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  "Liam R . Howlett"
 <Liam.Howlett@oracle.com>,  Nico Pache <npache@redhat.com>,  Ryan Roberts
 <ryan.roberts@arm.com>,  Dev Jain <dev.jain@arm.com>,  Barry Song
 <baohua@kernel.org>,  Lance Yang <lance.yang@linux.dev>,  Vlastimil Babka
 <vbabka@kernel.org>,  Mike Rapoport <rppt@kernel.org>,  Suren Baghdasaryan
 <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
In-Reply-To: <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
	(Andrew Morton's message of "Sat, 21 Mar 2026 17:15:30 -0700")
References: <cover.1773924928.git.ljs@kernel.org>
	<20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
	<87tsu9kgv3.fsf@linux.dev>
	<20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
	<20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
Date: Sat, 21 Mar 2026 19:12:13 -0700
Message-ID: <877br4k3ya.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 514E840009
X-Stat-Signature: 93ao8mrxbnz6cy34u6tngjm58gqdhsc8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774145543-75878
X-HE-Meta: U2FsdGVkX1/1X9aUOZjnE3JLyq8vOFqj5/4uTdMP9nD6jv9hFNtSj6Dyd6pzLOfRxAvUVEaG/HUAzduAVpAo+Fibs5OSw4L1iij7sAqyOOqxorRUbG86/FC4jhPLzhC4Xsaz6A4zbonmPEi+OW0aMp22JVrTHOR1OQqKh5e24yFiYpwnoOL9E35PfnKDj4e+GWqOdPkSBJcjgwnYGI0edN1ipa1UaWRuFZ0ISzYLj/SyA0fbqjjxsrtj2ImIcOw7SJDiWfbctpBE5KrqKhRcvVBwkbl9S9uKBJLLKf0rSgNeYQG+vQbMJawPmHctOOFk9W0yyo9NOY9mMhDpZMdxS9hM46Zsv5Pbectba5Yrx/t97oD4jbJ1ZWejTydJUTwFmquvynli5QZAvV2QFjM2vMhsNeR5jlKfxPrmsX127q8/aWeBrsv9ATCyAvvXLNp6IU5kQqQ0FM8evXwtSbmhieXz63aYyvBUsXcc8O/zt5PQ1723tCum3+zG7zOViUlzc3LnvRsp1pXYzlSn9GH8aBeK7GPSnoePuID9sRiJKLUPu+e55csDzIwvw1lb/7dTh8eWVC8rxIY/NxGCvAaSz93A/onvZX8fnBUnYEf1+kmhc8C+X5NSemrHWHZxx3XwxTwEv886Q2v0m3/HR4ER2Zotls3ZKFLdegF1Ea1VMjG0WfDR12a0rBImfR1PdPn1w5q/ykIamaPp6n9JFWPoIiqmdlppKbYrwDrG5d/pcReQC9HOyeZ0CAh0Mp60ePi4MTOLQ1i7mItTMdjJtr5clNyTLLjK649LymZxfwDVhXlRvl9hsF88GMaOWu6Iv/bL7hRFl6Rzj3mXuvwfj8wcJp+4BZzOGViksyfiIIVnygiYP1bIBapTvleL8wPve7/uTemQtre8JQw39RtV2GsOLwH0/8AAMPFzVY8maWNywe8YsiQ72ONI7N4Bx7vFRsWCv5xd4HNBJDsmDytVBOb
 i4LvXaAT
 JuBB0Pav0Nnk1gnkMVA1cKMl/n6GiuqKag47054gono+JgdhMFPWcCSqk7e3V/kKPK0RD6Yp3eS2FNV/+28LEunj3Sbyr7KmGHfhHG/iPU+Pgd0fR8R+/RHRyoks0LoBtuRK9jieIt0Th/Vgkw7uGQZNp/iB4YBPvv/NTdsLxzlyqzZSpE1aAZqBKzvUoOfNl/B7+DQIZTNKsF7gGN48dGVZ37U5XCvQ81ximDDLgQ4FsfLvYR4WNmS85FVCM4CQsFm2pXYQXneWABMY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 20 Mar 2026 20:33:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> A lot of patchsets are "failed to apply".  What is Sashiko trying to
>> apply MM patches to?  It would take some smarts to apply the v2
>> patchset when v1 is presently in mm.git?
>
> ?

It's displayed in the Baseline section for every patchset.

For mm patchsets if the base commit is not specified it's mm-new then
mm-unstable then mm-stable then linux-next/HEAD and then linus/HEAD
(and now I think that it should not only show HEAD, but the actual sha).

I don't have yet support for "previous version is applied, let's revert
it and try the new one" case. Something to add later.

> The way things are going at present, I'm just not going to apply a
> series which Sashiko "failed to apply".  And that's cool, I'll just
> wait for a version which Sashiko was able to apply.  And then not
> apply unless all Sashiko questions are resolved or convincingly refuted.
>
> Question please: if Sashiko finds an "issue" in v3 and then v4 comes
> out with changelog words which justifies the questionable alteration, can
> Sashiko parse that changelog justification and think "OK, never mind"?

Yes, I'm planning to add it. Sashiko will have an access to previous
versions of the patchset and the whole discussion thread and take it
into the account.

Thanks!

