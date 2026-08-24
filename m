Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12857C5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF196B00A0; Mon, 24 Aug 2026 08:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD106B00A1; Mon, 24 Aug 2026 08:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C68D6B00A2; Mon, 24 Aug 2026 08:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED4636B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:28:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F330A065B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:28:52 +0000 (UTC)
X-FDA: 85136092104.08.718F603
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id ADDBA100004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:28:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YUIXwQPF;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787574530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNv7ijS+WXVt3LXvoJCY8yKw7rjzIvyfrsdNOo8RgCo=;
	b=ZzH7snjnD4SH2qa44yjj57z/Ca8BvV1WFz2AMU3QqUQiGufgf883MwG8vNuVBun5DJJkyO
	MUCJ+6sPiBWxK2xO6sClPzWxXTmpui+90KZR5EYlJDmWibAyBPfmzZOJKf/v3uXWAV9gmg
	PYMkayGfo6JTHzyl9YnyW09kXbXnNpo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787574530;
	b=LnFtALDps2YjXntDc5kk6j/CDxid0VgKuOXY58SSws9l6nCbmRuLRTCwwrLNrhZr9oTxVt
	gffIu/Jpevb1GPpi5j4V6yp2M1RwiQkcTfcqckIxyw30YOWQrIX3jYpSS77l7R0iQU/VaH
	7QMOULeM3W2kGHqdc3jZJmHxzesXT8w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YUIXwQPF;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D730D43B32;
	Mon, 24 Aug 2026 12:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C941F000E9;
	Mon, 24 Aug 2026 12:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787574529;
	bh=oNv7ijS+WXVt3LXvoJCY8yKw7rjzIvyfrsdNOo8RgCo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YUIXwQPFvhi9rTBqyyZKnxmp3a2AAz9PWJEcTYWWpuet1pTH/A6x1pvgG6luvAv/L
	 EQpbyg5R5WgffgowgYMBeTua3i4AEyYOelkU3zRASsazScmOOWLIqQ7awKjId8Zilk
	 Ab9psW+oMxa3lYtRkotonbX8QmYbTLfQ25ypscBvfQoPolne8tq4HgN1jMQl2+nbSc
	 JwhHrhDgO5lVYcPur2JmJJgdMb5VMbnkcvA18bhwyeEKiKxlo9uL821XNXgCNbB2J4
	 xplQOvfiL7+JVnpFAj4fGYlSco0kvy0UhbeRspvMixfdbyWAjmTgxshDDgQhJ3n/rR
	 /wk44OJuk3Qrg==
Message-ID: <e1c8c6f5-1b5a-4cad-a52a-f7eff00997c3@kernel.org>
Date: Mon, 24 Aug 2026 14:28:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 03/57] mm/collapse: add collapse.h for the shared
 collapse state
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
 usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 jannh@google.com, willy@infradead.org, pfalcato@suse.de,
 rostedt@goodmis.org, mhiramat@kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-4-kirill@shutemov.name>
 <3113ac8b-c1ce-4577-9e93-449b70818918@kernel.org>
 <aobglSY5L1KoIqxF@thinkstation>
 <65433d1e-95ca-4434-828e-8f381d3384b1@kernel.org>
 <aow0Z6mrG2esKpRZ@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aow0Z6mrG2esKpRZ@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 935j7wnsn15nn77budh5wadkccu168hz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ADDBA100004
X-HE-Tag: 1787574530-808181
X-HE-Meta: U2FsdGVkX19Yof1hnHBEqVknFNVOZaOTjiVhp9iOLFyuuXr5vpAF4K50ePcejinoRcaNWm7W6KNg9fOq/l+h+zGlZ3/jQwTaZ5SCe9lN2o9HhFnJzv/TgaIU1xk8kyhC94DpHYon7hZeLQgN/zXFu3b04mQvmorGfdCJ1oQapc95dH2cmMc7mxN0JgyzybPZIDQigWecvRksO6YiNGGmOQr+ZgCT1BUs+hklz+c6HY8eUoJaTn4zitzguG4XTbaLOJbJXZ3BiwHfKEVDA6eaUY0DtZYPQwxBLCS/kNY7h8qxA0sncEdy4TAJBHZIbH4eciFLZdw6JQG87j1QDUWSHLJyIb/fMhahloMHhzTvmut0AWestPqDPf5vIpkjHxzmGSjeZgcWrb+86wmfaTca3KCHfXInQJzA3ZxM4jvdRZ5G0pXvBHJ0fiFIyzcvo9eIR+CnQwsXucmxS29bRbVwTZs98c2niXD7oSk0NY7k58kmEAX1GFs3vZfnCee5hc2ei5sJXr/BnamkbYaJhJM74SADQOvDpXhlQz50hw0h4fIfBgabiUBTv7p7X6xTx9iEBMKpU0GFglTBMA2WzvzpxBEEfD31HMmI9h6YjBXMycpR1c5QZUF3ndWcp4Te+1rVUSkQY7xh0oKOFXD6IM4aCusqSlSD216XNd9g1NZDFAr3Goi0VLBPNtTbfxjzeaJJbfLROANC3egqyLO2nXBL3keJw1+nICPV4GDE4J4fIfMERiwJFptBZZbkzbnr0BRPwYgGDTzUWvTveuSZg+mnpDbztUKFF2BZ1jMJ45DH9Zk7JrAlYvl2hLAS+/4KiRvXnwuf8QR+N76tEvQYrjnt2I0LBypTVePt1zPQl1iGNPFB6uq3114ky/BuNB9hOtMlGdRpyso7rMxVTRd0EKdkcTdHw/mV5sRXF0+aGvVzIRVy2B99IqVqeNoBKJgJpBmeSZ0/jHP8QbrUN6NrLQr
 QPQbRlMO
 eoaD+vJPdWWukXM1E0lKxZNFADG5Y8dseQowx0Z9NFNyGjrNrqtFTTZxdnXaNytJih2zhDkEvGYA+OeG3J6UvbYsBPJ1XtVVdyjVz9gWRz912tdMXAHZETX9idqKqFOfz3UWaBtyEVmyulGDHA+TuFY2eOKDwMAPW4HF/KDFR3cx/mbFfx6CpM1Dy0VM8Y/n5iDgz8ymj2RlX/3OVB5pLWCATRTJT+ju6FmLmJwu4ritxGexc7mnDMbn2CcyyLNOJFmmrJO4CYFanFYqZDUgOHgV7UeIxDprCa2oy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 14:10, Kiryl Shutsemau wrote:
> On Mon, Aug 24, 2026 at 01:47:54PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/20/26 13:11, Kiryl Shutsemau wrote:
>>>
>>> I went for a clean collapse.c on purpose: the engine is new code, and a
>>> new file keeps it readable while both mechanisms are in the tree, with 28
>>> as a plain delete from khugepaged.c.
>>>
>>> Your shape is less churn, though, and it keeps blame: 29-35 move about
>>> 1700 lines as add-and-delete today, and most of that would stay put, with
>>> only the daemon -- mm_slot, the scan loop, sysfs -- extracted into a new
>>> khugepaged.c.
>>>
>>> If you prefer it that way, I can give it a try for v2.
>>>
>>> The rename has to open the series, so it will collide with anything in
>>> flight that touches khugepaged.c.
>>>
>>
>> Kiryl, I have to ask, are you using AI to write your replies?
> 
> Yes. I use it check my claims and fix my grammar.
> 
> Why?
> 

It doesn't read the way you would usually write. In a bad way.

E.g., "Your shape", "has to open the series"

Consider telling the LLM to not change your writing style and focus only on
fixing grammar.

Otherwise it will be very load bearing to read and we'll be sorry to have to
gently push back against that.


Imagine I would instead have written the following:

The text does not read the way you would normally write, and the difference is
noticeable in a way that makes it feel less natural.

For example, phrases such as “Your shape” and “has to open the series” do not
sound consistent with your usual writing style.

It may be worth instructing the LLM to preserve your original tone and phrasing
as much as possible, and to focus only on correcting grammar and obvious
language issues.

-- 
Cheers,

David

