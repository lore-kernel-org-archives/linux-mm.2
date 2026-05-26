Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4089BCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB5B6B00BC; Tue, 26 May 2026 08:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77CAB6B00BE; Tue, 26 May 2026 08:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B7A6B00C1; Tue, 26 May 2026 08:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 556306B00BC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:47:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1BD38E1AD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:47:52 +0000 (UTC)
X-FDA: 84809547984.29.2D3DD95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3B797C000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:47:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=br8csux6;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779799671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6lI8ao7NoKOpusEhkBG99iYjPGXj3aoHvCYfGFjoPs=;
	b=XzXow/40QQGh2U5VyghM58DqoqLU5rd/3c+oh7lNXkrWwWh1pCsJe+adtIXekayq0iIPie
	wmr9uDO2vuiNQkSX6aCV6lm4e92wZ6mtP6OMkma7hK4HbCM5kuVAjjcziGj3BWnulmZXM+
	RqXhsLu81esJSfhXF9sDPIJIck74eMA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=br8csux6;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779799671; a=rsa-sha256;
	cv=none;
	b=FWS/iDKXQTMg0Z2stOYvsAcD359ZpHPkwe4Fc1b5pLUhTRBoP+1bW74emvF/735O834qc3
	3u456VdeaJxCjE1871X+28oRQCAdygJUOXe/8AJ7T9PqImZKK0/ufrVL4qkE2ZkusrZS0a
	DCwYQquYuUgdFXI13GQEiB/MyLhAxcE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1D2D600CB;
	Tue, 26 May 2026 12:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3659B1F00A3A;
	Tue, 26 May 2026 12:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779799670;
	bh=H6lI8ao7NoKOpusEhkBG99iYjPGXj3aoHvCYfGFjoPs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=br8csux62D+T7DakZoYjTqE8MjYOb6n82fQ0E9axrqgOQ0/MKpBH9DTfjFT7wQsov
	 bG7dxU/FlyjwWjOo38YhNZF0mGf0YygOypM8faKF+LoqxXGNzM8kR0dHUhpr3YF8fp
	 ZA1ErMJTmx909TwvS8o1g2gxrm5QPjFW3DKZq/n7MKnL2TjOyZcUBBrIuVutNirDj2
	 j7j2Q4H7H8bcbCYEFiWPDuEdQCfB5W26z9RtVxKybL6X45KbWmKUfZyq/RRLQkFHUX
	 FGJ7a23aPiwnzYL4BqKrCJpDUOXFye9mr+oo943uXuo6lYc2gfXxZg46QOt36klB03
	 i+6g6c8pp8qfg==
Message-ID: <855a00a7-c1f4-4c6d-bd4a-f3ccb0eb1eab@kernel.org>
Date: Tue, 26 May 2026 14:47:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across UFFDIO_COPY
 retry
To: "Liam R. Howlett" <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Carlier <devnexen@gmail.com>,
 Heechan Kang <gganji11@naver.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu
 <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260519052516.3315196-1-rppt@kernel.org>
 <a4e9fac5-e674-4528-9815-d588a35fedec@kernel.org>
 <ag2uzVgx2Xl7zi58@kernel.org>
 <e0412898-913e-4a28-b264-36438231d0ec@kernel.org>
 <ag3BNLU1b6p9u_6K@kernel.org>
 <d48f558c-1bed-44d5-bbf6-34782ebf18f2@kernel.org>
 <z6t4kefzgrdiu4zurxt63f3qdyjbjsvgyjnpxjkufj546huf2s@hq6xghp5w4ns>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <z6t4kefzgrdiu4zurxt63f3qdyjbjsvgyjnpxjkufj546huf2s@hq6xghp5w4ns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: epm8kbgzwgrrgam9f7f8ooj57gsbkuz6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3B797C000F
X-HE-Tag: 1779799671-781699
X-HE-Meta: U2FsdGVkX19kpR0Kqb8eRtR3xbc1KDWh/2G1RQXC53pyjKsf7KB5LlRp97BgwIoUlFGD9G7+/+CsuK5w2HuzVU79tLLNYC9nPcj5ZQN9g+aoSKmOzVbMbKnWcttZsmB+naZdFzhdGqyXGw0DV2rUBrfN+eJOLSktl6kvY4YTCFvzcL9zCedA9gVMsksff5VCnYjeTIvmt3IGM7OLiDR0nXX2VHj1fyoqKxqSK3vKHBI7kWfO8BtPGcFuSqsbE2BSVJeCPsaT+EDoFd8a8+fpJI3Fn26RbbiVK2xXJSJ62X2XQgmrrqkinGwHaqrJm3h42j4lxGwzaEtjv7lhyflkG4fryORt1iGqx0Uiip/AgbUaLQorCWXFOv//qzcU8aOKE8yffFJmvwciRFRl54ilfns6ooRu+zqPrKCWqY2H58D+Df9nroXAIFHZv5/+fAQ5yLaq+ecmoFbYWGkzGjdRBs21XTisKvMhaoouM3SfyYtAM6x44p95YNmMSCmW4dcjlP6jMPu4fthCqpqWoJowo3ccltmNjbQwAvSjJQO/l/5rQSkmO0mXCOHikRzfkqTJdMJSO1KOa0SlO2t51KemaizqW+r6jN8XHZS8NpW2U6bVYXpG7tFxU7p+8W5nGDciSYWDCq1LjwERFFo6PGHZrUvqWNaeT0s9wOHJD46bTqrf9MXwePAsUHKrNcYLFuWfd0JaBt4zzKeB9UZVG1ZuXRE+lD7u8iPCDJUmgsGos2/zAdwW9H8c9DvjvwFwVXVm/w0WILD0OB8Yu6yLkltY0t9CxizaLNXtAaYim3LsM2mSIU6hBIlXccCaaODH/jZrdixkeJpmkl5DpHl5HKNi6cdNIX0ygphcw5+Mf3JUPqU6xKJNBjvTsNAJ3qqt1Oo0d/vXleBOKWqsu3+r47x5MOHdEIAdd0JRZnHGcEOlaAZO2SdcLqOY0DUCxLvBfbhIPIv6z3Xcp5XRm3kx3Ug
 f6IJd1Pp
 iqycwEUBnx/3tEjmWwk94COUoLWYbvnRJW3Y6CklCngAj6bnz7emkNazBdnEZVK7OOnkx64vE/Yw57NybbCeRLl+gXAuTfV/tesFuQ4tD0WQ+Xd9Kise+5dTZj+tlft4tdZKFbosKmhKBhAyZr20vzdJ5UwaZDq7FhxJtFv9+Mcd0vxE96lw1mcWBchsMg+WXcy1nEv2LOZrKJYqFiKOicyaoWPpFDnnRbBMWvqZ30+6a3vREuEZwOT5ioHSg1vHEppKKIOYuf05AZNm+skEueknPYWKEDxv+6Yr8fwNms8EuDE9P7AqvZC7PYE2H6d3MEEY1Dzk55tH2FK20LoA6fEz/3nNwyUunLo1ULH4v3MyWOppRKnYQ35C8HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 19:12, Liam R. Howlett wrote:
> On 26/05/20 04:38PM, David Hildenbrand (Arm) wrote:
>> On 5/20/26 16:12, Mike Rapoport wrote:
>>>
>>> Let me reiterate:
>>>
>>> A thread doing UFFDIO_COPY releases the VMA in mfill_copy_folio_retry(),
>>> re-gets the VMA and checks if the per-MM counter stayed the same.
>>>
>>> If another thread makes any change to VMA while mfill_copy_folio_retry()
>>> waits to re-get the VMA, the counter would be incremented by another
>>> thread. mfill_copy_folio_retry() will see the change after mfill_get_vma()
>>> and will bail out with -EAGAIN.
>>>
>>
>> Yeah.
> 
> This isn't bulletproof anyways.  The sequence count can wrap.  So, if
> someone can replace the vma then cause the sequence counter wrap, then
> you can be fooled into thinking it's okay (we had this problem years ago
> with the vmacache using a 32 bit counter, iirc).

If you can get it to wrap for such short durations, then how would sequence
counters possibly work in any reasonable context?

-- 
Cheers,

David

