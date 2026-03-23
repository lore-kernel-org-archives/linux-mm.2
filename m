Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47F91F46102
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A26426B0005; Mon, 23 Mar 2026 08:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD5E6B0088; Mon, 23 Mar 2026 08:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9138E6B0089; Mon, 23 Mar 2026 08:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 831A36B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:56:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57AE7160B76
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:56:34 +0000 (UTC)
X-FDA: 84577326708.08.B2F60E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9CB75A0006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:56:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tDXj1FN6;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774270592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2VqmexSmje78Ogjk21F1jytPI4L67wsdDZ8HkKVhygU=;
	b=X4MYRjI245DFwVLo1KMl9jHoBySiiCB2G6xa+DQjf90H8VvW7DdFV5cYL3/a5ctzIpY5nU
	lsP3ZBJTj7Hbz1XisJICd/qNOVYLpwo+Cd9uMrATwwDmfQSNec4Qkw3OdsiP3c3BE4yPRP
	JGGE1PMsLQFbGctLP2TtT939AitUPNM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tDXj1FN6;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774270592; a=rsa-sha256;
	cv=none;
	b=vqxkRJ5XD7s+0IiYsUMTr2yH79Ysft23l4vYHq1JmeD62pSrpvnAKcbbP9B0bKZCfBjrXQ
	4PDTJ2HcDE6zoc24U9X3MJfJ88OPGOLG4cNIUAyXwsEw54J9q0yhxZdvcRFVH6ZBVF9aH9
	1t+DFocQ9Md2KzpOG+95705Mevt+yp8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F38C2600AC;
	Mon, 23 Mar 2026 12:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61EDC4CEF7;
	Mon, 23 Mar 2026 12:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774270591;
	bh=56CvIhSJvJpbCTYN4/Ac/8swe6dujoF1iEBmLn1Suho=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tDXj1FN63tJSJrZckQn4KKWIfOSfqhJV5nlLOeyGyLaZyXXFMK9KcXhm8Ym2aYBE7
	 7JaqE0hzaqCqs30f52+MZiiBiwxSSejiUGMGLd59rDDbEIKFTn9xqMNx74L4iP5ksj
	 4+ZUcK4esFgzVBXGiI0ZarGayJpdIbHCAUTG4aYhu1edbEt190EUsX1JXpVx17Tyke
	 i1X7Mg9U3pRsl/ftGkzPCB8CeCPJ9DqkZUMXse5HrTKjeXUfaQRlk0oeP4Z5qF3VIp
	 dhUkRarIfTC8FBfUQ+BQtJbP/u0hLaWCP1gRzGLMh4POih+m8f2YVETHZuvyUC6rC5
	 DPE6D1Zmrhv+Q==
Message-ID: <d67764ea-e0d5-4b24-8356-0b20fa0b2075@kernel.org>
Date: Mon, 23 Mar 2026 13:56:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/mprotect: un-inline folio_pte_batch_flags()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-4-pfalcato@suse.de>
 <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
 <69382383-5f08-408f-8c13-d674e82c4dfd@kernel.org>
 <fcc2665f-014b-490f-8451-ca907730e60c@lucifer.local>
 <9b0aaa19-b839-4ebb-a312-097b869154c1@kernel.org>
 <11929205-d0dd-4e8f-8a99-2d0b02cfd5bd@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <11929205-d0dd-4e8f-8a99-2d0b02cfd5bd@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9CB75A0006
X-Stat-Signature: 4qccxji1ktzn9em6cj6kur5go78jdryo
X-Rspam-User: 
X-HE-Tag: 1774270592-820691
X-HE-Meta: U2FsdGVkX180XgzPWypYpAELB+wHdJPGSK9EjJBbprylMMncWNuxMsLLeoNsBD16eZfzTmW9gQyNgYVwJrZUzDbas3UccECmzJJmqLFj5NDx+lIitXnKhjfFS8GQvsKgBsjeZOXhUcKKEGS79Yz0ZuH0L0r/e0A7vhw7bH+w6BT6ALFf0QZB0cNRDgeddv4Bdg300JlOdiFf6eEjN8EGVmuPX9dXtllcZWLhEcPZe5XNzlQS4ONBVtdDkaUPRMVDJLmm8ljGqv65ppW5FNzts7rV4ZNcs9HLRSj1+FILKVMmwCI1D00xiEmGH0pztXdmq2TreLenWtN7EH+V7y0Nw7gQFZ/amsRnnttDbzSisPxRwZ8RAJCmt7WdY4F0vd5SxxbmicuKrcoHGM6cLA5H3KW4R1xJLrMrVfu4U67FkDYk5iJPx/GI8tmLAO2Pkn9uFw7ogW82QYthvhyZKR2kz/DVJdymN/UlF0FseO5pdb/SsMHSuOtTJj7xTMinsGzi3ujuaRugl9rP87u/DFPe+5LT/HiYQWiEi/xT1bbHisyq6x8BkEH8vs+qzsTYgtLfFAdXl9rPcDB0IN5M3Wa7JPJBkeSmgfXhZdUFe1vgjTb1VdZB4DcMqxHNpdl3Eb/BjwLQYScwwwCDLhoDcGAIhD+YXgzCdnbyd0vr8u1iQMzn7vtSwq7w3dM7cz+WOYyX4SKVLLd9/0xkuHQqVjFYiqWYpAYi1S3MntXjAc5loO5AtoZq9BpqhZ3VdPA+vQbkVlFcygTXqSz56XD33ss9xpHz6lhP9kqNTzRHwqJnyDs4UcbttQ+DKpE7HP40D5ICsYsfjytHRpckZj+kNhf5+o8lgw4Eist1xWnkW1PNrzV7kUC54CRmPKrvacHzUusQsKwCSLKqX9a2uvr2EOUpmq1S8Pxppzv/8sx13ok3iW+08awmpyvfwRN5EPft3VWIIwOn8bCHmZER2a1EQoQ
 yxIscYB/
 4dbPY5x+ifj4aNNSHsynVlk13tZXYWR3OKkWn8bWakowyMAaC1ISCZPbPycQxgVcC5t5cjKPBeH0Z6k19dQ4wKeV5z90wlwetaWR1J7Stf0X6+CGJF9wjCgcrXZMyzUOCspHWHT+qTZ/VFKneWz9FEJAH9RnhUBCiPxwsAmjutNbawZ2ZnZZ7Y1hS7PhN469iiKPjGZoICr7kJXIKvUs5P4CrqnVdfrUvSjchVtCwod7aJjLjVTleAisozpT77avVL2Y0PYqlkJGzohq/ljyk8bKTjP9sLJv2VrxsKhM1natBTN3V82KZGB3FXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> I mean yeah that's a terrible name so obviously it'd have to be something
>>> better.
>>>
>>> But again, this seems pretty stupid, now we're writing a bunch of duplicate
>>> per-case code to force noinline because we made the central function inline
>>> no?
>>>
>>> That's also super fragile, because an engineer might later decide that
>>> pattern is horrible and fix it, and we regress this.
>>>
>>> But I mean overall, is the perf here really all that important? Are people
>>> really that dependent on mprotect() et al. performing brilliantly fast?
>>
>> For basic primitives like mprotect/zap/fork I think yes. For other stuff
>> like rmap.c, maybe not.
> 
> Well on big ranges of mprotect() it could be, and I know often databases
> like to do this kind of thing potentially, so yeah sure.
> 
> But more so the microbenchmark stuff of *a million protect() invocations*
> is not something to optimise for so much.
> 
> Rather I'd say mprotect() over larger ranges is what we should look to.

I tend to agree (and I think I made a similar point in previous
discussions around mprotect() performance).

There is the use case for userspace jits etc to call mprotect() on
individual pages. I suspected that TLB flushing and syscall overhead
would overshadow most micro-optimizations. :)

[...]

> 
> As I've said to Pedro elsewhere here, I guess my concern is nuanced:
> 
> So if we introduce stuff like carefully chosen __always_inline or noinline
> or other things that have characteristics like:
> 
> - They're beneficial for the code AS-IS.
> - They're based on compiler codegen that can easily be altered by other
>   changes.
> - It is not obvious how other changes to the code might break them.
> 
> We are asking for trouble - because people WILL change that code and WILL
> break that, OR a possibly worse outcome - something like a noinline sticks
> around when it makes sense, but everybody's scared to remove it + _doesn't
> know why it's there_ - so it becomes a part of 'oh yeah we don't touch
> that' lore that exists for a lot of 'weird' stuff in the kernel.
> 
> Then it might end up actually _worsening_ the performance in future
> accidentally because nobody dare touch it.
> 
> Or another hellish future is one in which such things cause bot perf
> regression reports for otherwise fine series, on microoptimisations we're
> not even clear matter, and cause developers to have to spend hours figuring
> out how to avoid them, meanwhile potentially making it even more difficult
> to understand why the code is the way it is.
> 
> So what is the solution?
> 
> 1. Focus on the changes that are NOT brittle like this, e.g. special casing
>    order-0 is fine, adding profile/benchmark-proven likely()/unlikely(),
>    etc. - these are not things that have the above characteristics and are
>    just wins.

Agreed.

> 
> 2. For cases where things MIGHT have the characteristics listed above,
>    avoid the issue by abstracting it as much as possible, adding lengthily
>    comments and making it as hard as possible to screw it up/misunderstand
>    it.

Agreed.

> 
> 3. Often times perf issues coming up might be an indication that the
>    underlying mechanism is itself not well abstracted/already adding
>    unnecessary complexity that manifests in perf issues, so in that case -
>    rework first.
Agreed.


I think the usage of noinline for micro-performance optimization is
really questionable and should be avoided at all costs.

The folio_pte_patch() stuff likely really should just be a set of
mm/util.c helpers that specialize on the flags only to make the inner
loop as efficient as possible.

-- 
Cheers,

David

