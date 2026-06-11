Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A0DCD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8956B009D; Thu, 11 Jun 2026 07:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380556B009E; Thu, 11 Jun 2026 07:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD566B009F; Thu, 11 Jun 2026 07:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1989A6B009D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:32:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7B7A1205D4
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:32:54 +0000 (UTC)
X-FDA: 84867419868.13.EAD50A6
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id C063E40007
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:32:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dYKASq8J;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781177573;
	b=sE2zUkZ4dFVVBmroupgrU6eInTO2C/TrToUvFLYbEajKuOANYuZIz596PEZyhpXD6MxO3V
	X/vQ65wQxenJSxJu4EvkILxg6PAHryePwFV+ymdRORDVy1DVH7IQYg9uvDg1PYIHUHCd+7
	pfDE6xsQmfW0MJBAYGDH0Whj1LHraIs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dYKASq8J;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781177573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugCqBgi0fBDRK6ivFN1godWvfJz2W8IYf84Kxeh0+zE=;
	b=8DggF8ltnQ8aCNFJQ6gCoqKwELrCxLmTniScRecjtFb7pl6n6meyrfHJIrOJGa5lhjsdP5
	Mf+DjefqCBmTgsMzhz/BONQnOuGttvvEfjQA6OXmh4eB047axDGN7opTEux2tomlpfpS89
	G6wR3p4rGH8K1KL7Q7rkH3igIwQIYfw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781177570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ugCqBgi0fBDRK6ivFN1godWvfJz2W8IYf84Kxeh0+zE=;
	b=dYKASq8JccqOc4OOo5oBF8n59LjVvj3IPVQq69yWCe5HhsnqzeUg29hv/PMuf2uac5X7Js
	7Q1Rf/Os9mLDKto0EEDHB4FNOFYMAR8ckq/O9AFshKdy0csWWQDzdK1ZUE5Qy9m4lec9GO
	jptWZJZSwgCFCesE8i+D0fwPOxQhqfg=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: sarthak.sharma@arm.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	Jason@zx2c4.com,
	anthony.yznaga@oracle.com,
	broonie@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aishwarya.TCV@arm.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
Date: Thu, 11 Jun 2026 19:32:37 +0800
Message-Id: <20260611113237.26621-1-lance.yang@linux.dev>
In-Reply-To: <b2e63557-a0fa-409f-8a75-12d43257efb5@kernel.org>
References: <b2e63557-a0fa-409f-8a75-12d43257efb5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C063E40007
X-Stat-Signature: bee8bdyae4nsdcakmb57gi7tx8d1kjnt
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781177572-462116
X-HE-Meta: U2FsdGVkX1+p1FOMsDqyqyr42pNaSoioEEyhqqQCtTkw7NQZvgKbHomNQyT/CMrm5OeESNKji4SnKJnA+VhZQqaHq3jjS8UpCGCFon0fugpmKFGtbBUAjTmi9WWxhQEIsVFpNagoOF7KyIeBMVxEwKGVacQX3CgqfCwQ8LeyucUDXHxR5W8ZnbZYQrTX4StufkxgadKkUomFVEil+78PRPFzP5L32uHoX5SajdLnLSoiQttbNuyoZ29Tk/r3Iwwk+CvrrO+j1o1mC2oi4gldWgO0CTj5PeGrtNNMNGuD/sSjUTmYudW6dMxpbKYaLTISB519A3ZlOZ9xF24yYfPOd5ckaub0UwGIJwbl9l6vGEmRVySIioMljZZqAgFCocQQe3SdrYyshaRmzDnCmYhyWSCMbWVYVDWglG7rtmYLfZnA/sWrUrnOz81I4Aup+6B2XYjrkfPO+ZKrbMoGyMlm1QG1Ol4crnvH1DTxc9FXowsOox+mv4NMFu9Z9Z4ZLkWTshq7NJi2Gjxp3spkE0WjCgBYYm3lUwFoN+2vcgsVDhE57yKT/CSHupfc9cSduuW2oeFme4LV1O9KwjPP5ZHfEPQPcqNdE2FIsXJHhQPOKv3BQAKEe6smyb2RM4BSIRlMR24SR9X25T11JZqhR8aEv6nJ8IIIcD/qIYlkRim4x42rve0t4oBfQlodTCYDMHxuw7tfMKqVwT4kzzdNX2rVU8Tq1kKmcvLqaU92ZNPCNFBzMvtUpNE0sCRcLdxSsrL+y93BJ732Vk+1Jfc8lLT0GpWAgXZSvZeZFYEXR99WnaF6W4drHIJqFj/B9uDFZrcIeUqZES2sfa15UOV6qB1JRe/j4+3QJhkP9yHnbq2i6UHWPcwrkjvAgcB92f3jm/JH3Kw5QhO++COzBlkljrsW1tcX0M8PrW59nH4oPtgmjQ1STCLw7BypyVokiPPArTvgQjhBFRFHd55UUK5jC3f
 2D50nW8Q
 3Pn/qlNOzuL2kkT3KnjrvtKQrZ5AecmjZF8PhrRRnjGr6UWfktuwDnjvGt/NY/m58swFspvFG94noxU+tuX9QhERgrl/VLvgpzqvpSJKYY1kQucXkgJRAJ7a8HCkKmw1w7N9uh3l8HHY3ASagAmfLnycCt8TMLSRB/yDjjboxKL6YZfiAmtn1dWlnuZAlyTiVoakZ6ZLTp24wzZuChg0d+pnuQbMeJwbLdMvCW0MnzzVtNLtgYOQkbqNAopjNiFiJf0vcflm8HJFfPT79nvz6T0sAZWsXQRrzF3tlh1ENPu9j0lg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Jun 11, 2026 at 01:26:57PM +0200, David Hildenbrand (Arm) wrote:
>On 6/11/26 13:07, Sarthak Sharma wrote:
>> 
>> 
>> On 6/11/26 3:31 PM, David Hildenbrand (Arm) wrote:
>>> The droppable test currently relies on creating memory pressure in a
>>> child process to trigger dropping the droppable pages.
>>>
>>> That not only takes a long time on some machines (allocating and filling
>>> all that memory), on large machines this will not work as we hardcode the
>>> area size to 134217728 bytes.
>>>
>>> ... further, we rely on timeouts to detect that memory was not dropped,
>>> which is really suboptimal.
>>>
>>> Instead, let's just use MADV_PAGEOUT on a 2 MiB region. MADV_PAGEOUT works
>>> with droppable memory even without swap.
>>>
>>> There is the low chance of MADV_PAGEOUT failing to drop a page because
>>> of speculative references. We'll wait 1s and retry 10 times to
>>> rule that unlikely case out as best as we can.
>>>
>>> On a machine without swap:
>>>
>>> 	$ ./droppable
>>> 	TAP version 13
>>> 	1..1
>>> 	ok 1 madvise(MADV_PAGEOUT) behavior
>>> 	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>>
>>> Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
>>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>> 
>> I ran this test before and after applying the patch and recorded the
>> execution time over 5 runs on an Orion O6 board.
>> 
>
>Thanks!
>
>> Before the patch, average execution time = 3.87 s
>
>Out of interest, how much memory did your machine have?
>
>I ran into this myself on a 200gig machine, and there was essentially no
>progress ...

Same here ... With the old test, I waited a quite a while and didn't see
any progress ...  on a 512 GiB machine.

