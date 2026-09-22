Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18275C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0D66B009B; Tue, 22 Sep 2026 06:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771936B009D; Tue, 22 Sep 2026 06:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660706B009E; Tue, 22 Sep 2026 06:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D0E36B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:33:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2E8D1C284E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:33:30 +0000 (UTC)
X-FDA: 85241036580.17.2468B68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A773A100002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:33:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NjC7wRXt;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790073208;
	b=Oz3El0GTLJkTtOKZUatxr6AlznCcjte1ydKn4jpRcr/6nV9VgCG6fD3Sb22OFp3i2KVOmw
	cklBhW9gIV776EdV/3PLIJh7LuExPmCDvjhDxv2GIumNAqeAzy0XaVcOSfzA4AADyYtwIE
	JFlUffLh8Qo1IlYHxA8fH/Gt+yEiQAQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NjC7wRXt;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790073208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=joy7XZGpU3JK0Er98HhLBWvNzbtQhsZ3RLOiBMNo+/g=;
	b=QCp3+mQpL8zdVIt75C8DBfWEshIxMHYG2QITucA3HVSTr6czxITQddyA0dPxZ/Yz6fhio9
	H8YFnEgmN2B8hOgKY9O9RATb8WtXhZkbcYlq39KUQaqxq1DzdrhKpPdPUM1w9705CFNRvj
	5NcsLHqAwJiSAStFjAZhHBdzSZSDsKY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6C6F43595;
	Tue, 22 Sep 2026 10:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD5D1F00899;
	Tue, 22 Sep 2026 10:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790073207;
	bh=joy7XZGpU3JK0Er98HhLBWvNzbtQhsZ3RLOiBMNo+/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NjC7wRXtYXK9eb3E8SDN7TCauP48Vz96jEDY6x/kgu8OcMvjbwmHAsNLUlO+8UW0H
	 WZE8tMNx8WhrBiKNmEsLy0BrBO5Svv5PptJGphgY4ha6Dh4cJM4Js9FYFcG6tiV/Nu
	 MkEnysTZfUGHtxBCJQ+IhH/0DzuZZK6xWypEV9MIaWjiJd+aAnIO1o3GgEMgOf+BIK
	 OOQ3p9DXsFnf0reyUlQ33DC1OuliPCqX7pwi1IQ2LnBEXleA0+5bf3lmsGjoz8KiCR
	 f+D3zfOTRKLri/92Gd9ngoExdpc6OYbEioHCJ7oqcS+uL4NnjT3884u8utdsMRQrQG
	 JqoO2DUQ67EUA==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.ams.internal (Postfix) with ESMTP id 43D27198005A;
	Tue, 22 Sep 2026 06:33:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Tue, 22 Sep 2026 06:33:24 -0400
X-ME-Sender: <xms:cFmyagpMMLe_ICyPiVvgiUtnVGfrmSzo-saP47f87laVTO7c4G1KGA>
    <xme:cFmyasw_pCbeJEr-k6fCDAkHmdzDpS59V6zeQztoaa9jbH6vmciYVlJrzusBySYMI
    5H0iV1JMrYyzGoKyOH5TaSC-ZzajfuiQGzTjThLFfpvrye9EsHqeNU7ow>
X-ME-Received: <xmr:cFmyarsjgofOSvF0bX6A-tLuQTOxMqkxOeipPgJ67Bv7sU_r8NfqBEAHU4U>
X-ME-Proxy-Cause: dmFkZTGWslX1iI8K31kAWiLhNqfdZw1k2m3hFtLnCpE5gp5gjzZmB4jHKzraNGfiEoisZq
    Q3GvO5gsS6JZ6hUyZMY3//LgjdYOd9UIjepl6tkPIW265Ceo7gMqUZsChUYgkDbOAnYOP8
    5PwrMp/PMZ013Bq2AtkSuU2b2yepxc+wVzVqWpawNt4uLyOh+S+c98K+8DBgnOT5rdGqKs
    ulQoslXHfz6GXrQw6QlIVRcuZ1TYzWPF401kdG3H5d4N91lw0mU/TPGH0L0Fqa2umH2OqC
    el9SPxehl/sAv8dXAeAtHsJLPC4yD7bLXdjaaM/lgOwNs39/ZfsW3qLYofHqLbz2hWGPRk
    LjWt3gVIz4EnRqPH96bGLtM9vcjLG2i1rjsftJ3SNimlS6AqJf9rIO4yBjGZUvyj2zEtvv
    UNPU8IUsEgOSqBxsMrezHA3ZGz8opz8mwmt7HV0p8Al3G3/chmmDFrv70QtLXpgk8sA+SA
    CPNhI2yYA4uIt62aHMCtahfkmchFJtC0PRtq3+ykeYfiimtjfjvhyoEDt4EE/j9jIjJth6
    xDOJ2rH09JE4ygm4J+IqaS4Aupl5GM5aU1ziN/vc+kkEG4kSMLPcLHt1Nyr9gDTvzGwDKH
    /NMvkW81VrOib9ZTSxPfGjYvvEmr+XG/GWeHRvkdmLUZXux/PxEnG4BTK7kA
X-ME-Proxy: <xmx:cFmyah7Of4meK8Ga9wFXmdAFc9WpbIKqAoKisDqb9ACG3TZOynY6oA>
    <xmx:cFmyajjWSDn1gusA-akVNlSrDiZp95X7Gue9XtKa0RZXyx2Cj2epEg>
    <xmx:cFmyarLujCRg7Yz5__GslZKKhqKJAywF9yOfNM8t2Wjp2jN0Jv3NwQ>
    <xmx:cFmyapc0Oylea0jh1MMTHRh_XaTAbQcjMwUizde3XHCzvHX0vkFoNg>
    <xmx:cFmyarP-O29BJ6KqYLATFVHjw5GKIflkshgv_k5Li5_aYtOFAFO021TC>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Sep 2026 06:33:19 -0400 (EDT)
Date: Tue, 22 Sep 2026 11:33:18 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Lance Yang <lance.yang@linux.dev>, joannelkoong@gmail.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, hannes@cmpxchg.org, 
	baohua@kernel.org, alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
Message-ID: <arJY3CHthp8W3sNm@thinkstation>
References: <20260920162014.4479-1-lance.yang@linux.dev>
 <20260921100852.2236761-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921100852.2236761-1-usama.arif@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A773A100002
X-Rspam-User: 
X-Stat-Signature: up9zp9s3zhxdszgham6bejgeu8zja48e
X-HE-Tag: 1790073208-779052
X-HE-Meta: U2FsdGVkX18y/jQY3JGgbJt/3FpbxE1Sonj2wZZtoaSd0RN+ilpZmpVrymiX8VQsWcbpERCKIf28VuE232MM4ecNHzp154yDkndBJHkLyZMlHRQ5HJkzTQksGR6Yoj/ulPeZOGKzLS44KV1UntEpzy4zb17D00vDHEM9cRFhgwOLOVGwKvQOX6ShhvOjwT93LfnigaYlS8wA6oXlPXBDc7tDwusbB+W/NiM652Ba7njioI53ZEjlVMpNoh99bm27KMahHspUmmriTTpmcMB/DwO2FPYvGEB08vDCfXySHjSw6vixe3iTBPY6bTRjzDGOYaVJIaloRCrYutXbcLrt13BacWm/FZpt/7dUqhMczhaoTzOFVz1LQVxfIMQyxHc3qaD8tZlpvHInHvDfvYD95VvkB/dYy6CJrz95EGxpZhDkltTIg+SyTEsQepASROaZuKxAN9tN0uWhlLeSe3BB9FMFUOKbglWumP2MBUORuhcjBWMWOHn4L/ljWKvYWfqTkPv7CAlKtuAt/IkJzHW6znUOjXuyHjGYS9eUfq25eZRa1S+V8+fbpHhcUFhujBzfBMMMWo9QCIctN+GFlQa+pCi376kUcge77y3NDoTsz9gOWoKOdldxV5DJOq3qIiWXW7xrjYcmPmdNcPmW2zgZ3mk0JHKVUflYuin61+ZQZONfCa5PqCdbvsokrJ4Arwtldbe3WirHcBw5rXSgPeSGU4TxUQBFWx67MwLsc1933OpPjc1DkiiWFjh1jcTqKGR2YURKJJngYFNg1Ew0KlhgylTMrst+hoNiTANfuLcq051RiAgAxRcv67Zl6I4DsteslFHwqJNZjZ5MAeVfUPJmg9k4t7b8mEjRVuCwJbqKkcjFaClEJ7v/plaXnVVNpoHmDOAvmIYOAZhYb3jH0SvdoODU74N9Akm1HKsFXxV0acpQRE6gTRhAseO8mVE3tuwEIu46Pwj2XkEYDgXQDGg
 JwNlif+q
 TVo1xquKb5jO6dhTUR4Yp1kSC2kSKon7rKssbDYczs/sNWkuJ2JfPrGpwLw1k6Rqb6S6FOsE4/4quXG3HU3igouab67yy5LoC6KnPmd2LgzN2Iaa/eIuU2T4eeAmONXGWVJlZ0REvavAnjSabUs+7jYgWGIpso8QfmYI+MJMhK+/JdAX8NHhWMHWDaeBIMDsmlh0fEWgGcqYMomDKEhhLnMQ8Cp+Bj2NssJs0o+R+deyoVyeaOJVfNHQ0B0WWAzlSqTD4/XUsXvKkzpDcJiFfbOtvxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 03:08:49AM -0700, Usama Arif wrote:
> On Mon, 21 Sep 2026 00:20:14 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> 
> 
> 
> +Kiryl who is working on khugepaged rework
> 
> > 
> > On Wed, Sep 16, 2026 at 03:44:34PM -0700, Joanne Koong wrote:
> > >PMD-sized THPs that are mostly zero-filled are reclaimed under memory
> > >pressure by the deferred split shrinker, but this is not done for mTHP
> > >folios. At Meta we would like to deploy 2M THP=always on arm64 with 64k
> > >base pages, as 2M provides the contpte benefits while the PMD size there
> > >(512M) is too big to use. However, 2M THP=always causes memory regressions
> > >unless the unused portions of those folios can be broken down and
> > >reclaimed.
> > >
> > >v1 did two things. It scaled khugepaged_max_ptes_none down per folio order and
> > >it queued every anonymous mTHP folio. David objected to the scaling since
> > >collapse had already rejected proportional scaling as either letting the memory
> > >footprint creep or being confusing to reason about. David and Barry separately
> > >objected to the queuing, which adds list_lru lock contention on every anonymous
> > >fault, and hurts lower-order use cases such as Android's order-2-only
> > >configuration. Johannes suggested keeping khugepaged_max_ptes_none absolute and
> > >simply not queuing folios that could never exceed it, which addresses both.
> > >
> > >Read as an absolute count, khugepaged_max_ptes_none also implies the
> > >smallest folio that takes part in underused splitting. A 2M folio on 64k
> > >base pages is 32 pages, so the knob has to be set below 32 for those to
> > >be queued at all, and any folio with no more pages than the value stays off
> > >the queue entirely.
> > 
> > Em ... I'm not sure max_ptes_none should also become the mTHP underused
> > threshold ...
> > 
> > Say we're on arm64 with 64K pages and set it to 16. Khugepaged PMD
> > collapse uses 16, while mTHP collapse turns the same value into 0. With
> > this series, an order-5 (2 MiB) mTHP enters the deferred split queue
> > because it has 32 pages, and is considered underused once more than 16
> > pages are zero-filled. So the same knob means 16, 0, and 16 depending on
> > where it is used ... That's a bit odd ... no?
> > 
> 
> I feel like the odd part of it is the 0 in the middle used by mTHP collapse,
> not the 16 for checking zero-filled pages?
> 
> Kiryl, would your rework allow all values for mTHP collapse or would
> it stil only allow HPAGE_PMD_NR = 1 and 0?

I didn't change the policy here.

What I considered doing it allow proportional treatment of max_ptes_none
for terminal mTHP size -- when there's no larger mTHP or PMD THP allowed
on the system. It can be helpful for 2M mTHPs on ARM machines with 64K
base page size and 512M PMDs.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

