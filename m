Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DBFECCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AD2E6B0150; Mon, 19 Jan 2026 04:44:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881596B0151; Mon, 19 Jan 2026 04:44:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D146B0152; Mon, 19 Jan 2026 04:44:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 66BC26B0150
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:44:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAF0A1606AD
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:44:16 +0000 (UTC)
X-FDA: 84348227712.04.D395CDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id F23F9120002
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:44:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c42FYPnO;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768815855; a=rsa-sha256;
	cv=none;
	b=6CTfZ6ZlGsQj9If+rpnFLtCIB0M5MdSw4w6EB6/+WaZqSSqmGNHncmBIns/sOq8otVXdVO
	xc6KnnGtGtyQUca94hn+IfM+pm2Nq0ds1b5JrXTf06roTxJu0YSyZMxsWRAIZTQSS+C6Ld
	PY2DtmLPJeBgWdQI4NbDn/SgDKzI/58=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c42FYPnO;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768815855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNiQRuU19aPI/1q+KM89OLs3MZm4rzZrU1KQwNr0GCA=;
	b=PnfLynjT6CItumcXQkYhOpQaVWy9d26oY9KIHMUOnXNibUZpfTXH05c3rHDCdozNFfbujx
	JUMwGDYzGMZ2uRBaiiR3kT2ojl/uId/jT8gPm0TTs0B4F8NyYHdRSeIvnmYoghM2TU70y1
	K+xnTOUKPHBYQEm9VMHiL2m+9X8HDKo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BAEDE43925;
	Mon, 19 Jan 2026 09:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614B4C116C6;
	Mon, 19 Jan 2026 09:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768815853;
	bh=bY2K7YbaDGhdDEwxbSPSrK9Bho/NX+G/IaXsX/yc9gI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c42FYPnOn66T+MvVDZwzUa2uGFNSY3ixID2WNxvELuDe0qV7V34R3EvM7W5bMGkx+
	 F1KmCeVW+XFTlx5vWimNanbMg4ytF0kykZLrFCzceTykdIR7iV3I8PNyZCeEdX8kyx
	 HTdb5TmS3NP+Jkgi309jWE88kL2kmptAhOdtZdurNGE38b5S+aM86/d6/KjksfZIH9
	 wTMZ59EQ/VMbjvZq6+Ktx5pvax3rITnTIk95qAQ+f9cIl9apuBwYgw6z97iOlLninf
	 BZEE1NJqlspZX0l8P3kvMck3LPk+VXmCsVwJjjWwemXwr/AkxJyQcol9ylfHgN6hw/
	 qoFABtElBleKA==
Message-ID: <7b21ef98-e9f3-4e09-97ab-cf1ee9def41f@kernel.org>
Date: Mon, 19 Jan 2026 10:44:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
 Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
 athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, carnil@debian.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com>
 <ypyumqgv5p7dnxmq34q33keb6kzqnp66r33gtbm4pglgdmhma6@3oleltql2qgp>
 <616c2e51-ff69-4ef9-9637-41f3ff8691dd@kernel.org>
 <CAJfpeguBuHBGUq45bOFvypsyd8XXekLKycRBGO1eeqLxz3L0eA@mail.gmail.com>
 <238ef4ab-7ea3-442a-a344-a683dd64f818@kernel.org>
 <CAJfpegvUP5MK-xB2=djmGo4iYzmsn9LLWV3ZJXFbyyft_LsA_Q@mail.gmail.com>
 <c39232ea-8cf0-45e6-9a5a-e2abae60134c@kernel.org>
 <CAJfpegt0Bp5qNFPS0KsAZeU62vw4CqHv+1d53CmEOV45r-Rj0Q@mail.gmail.com>
 <01ebe0c6-6135-4937-a758-93a5fc78d7fe@kernel.org>
 <20260118164051.521de8ad2758376c3e1d2d81@linux-foundation.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260118164051.521de8ad2758376c3e1d2d81@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F23F9120002
X-Stat-Signature: 6mmdc1nfx5m9ktd7ksr5ibwmxqw8cwbt
X-Rspam-User: 
X-HE-Tag: 1768815854-238009
X-HE-Meta: U2FsdGVkX189UxXAJntuesB0n4KaHovsLaykMB54C2tjysQH800sqJEG4JXW7AAtpERlj9QzC4u7gYtcBMsydZCi42gLvsKiPkBWHrgW9vaQsAcx8pb7ZMZXjIYEfLLZyzgbpy4nM2CnDB6g4i1HPfafwB3hGjuBOQIncQ5DBmh2kys9j9AjC0IJhzoSmZBhn6b+Nr9xhFloAGEcbauBjf6Ff0qjVnPa7uAFikrOmRksrzGcdEDDwoNc5U6kgsuqST6hGIKLCygESO1Xk34XWNZqYB5+XGf+L8o3OfrY8Bm5SEFZVtvJ27bkJBM/a92eINEDuGe4pZQSCzNTMB2gMWKIJ/PC//piBKX0FlQ4UPuZqRs3C5wSRLRu9o2y5rUnxgkJ+FHc+blaaBXyKHxEShHIKz/x9eXHrw5r1ftruthBT4BoNx19QFC7/pEnGFrxhNCLcuQyrUaDi+s5qPpBGtNNS6EtjExUtgY/0WljBRBJOKzeeqFuN7GXWNES7tFGKG2yMlcqF2GaYpV3JRhMGMUa6LutWsBZ9bzCI117O4hHp/OqGMLWKjYVe+pzNyoIz2KSVCttTqz5LVtwUeD6UM85fanZdHlByCWQuPA1Dt2nHp/kboKy0mDnlrFNJAbrxTAJEWaBdeq4sLdpbe5LB0YFYh4dXppOShuD41YgtdDPs0sxnzYaVCxxospa7jjswEU4Hc60VVs9zUXbovNITi3UAHDkrgzxwEyxh5SV1vrnoixLo+etWy9mu5fnI0nf8tbIbm6w/nEjP/r3Ziv7MY8pAwuhiPhLe7gQIDZE09W9gWtzAZIFuyzSLhkSq+sKZ+oq55pjjAM8+Srs5Qadcx4KkvXXDu9gBBBxQVCZ/inKgQHA3sFHtMgs0gxebAG3SUqfB+iIDRaU9e9HnVQ7DqDoagMrPQKluYxwWJ1PnaEvcy45DSHyA31bxxkNCtSutSKajVHBHUcQdnVCykm
 s/pvb8UN
 6bwTZEv16yHbodocjTjqUEfu0HzG/FUKvBpguAVA7J6HjPfdV+L+yarvYXA89j7UekqIbHjukHqjEQs3ikRb9n1Xc9Mqx6BfzJSKakI/Zlw9HwQ8u2h39oouCa0Otc5X/YCdxQrnEGKawmL7xiNIAT/xy8oCjCLSK5J+AnaXpC1qvUq9Dbd4mR5bQZEnrPqoPDd4pQ78YiT3ENL7JkLvjL96LQHg9ebA2fLSfgoDwGVAFYanpb08kr6eaAYtYKskmWCXD7+i7SQQYyTCArJ6SBnF6nWQdlXq0+PY/dB7VfoviV7fPLqyASVaV4S2ZYFY6CJcQmRN8Z/Z6Isk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/19/26 01:40, Andrew Morton wrote:
> On Tue, 6 Jan 2026 18:54:47 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> 
>> On 1/6/26 17:05, Miklos Szeredi wrote:
>>> On Tue, 6 Jan 2026 at 16:41, David Hildenbrand (Red Hat)
>>> <david@kernel.org> wrote:
>>>
>>>> I assume the usual suspects, including mm/memory-failure.c.
>>>>
>>>> memory_failure() not only contains a folio_wait_writeback() but also a
>>>> folio_lock(), so twice the fun :)
>>>
>>> As long as it's run from a workqueue it shouldn't affect the rest of
>>> the system, right?  The wq thread will consume a nontrivial amount of
>>> resources, I suppose, so it would be better to implement those waits
>>> asynchronously.
>>
>> Good question. I know that memory_failure() can be triggered out of
>> various context, but I never traced it back to its origin.
> 
> I'm seeing unhappy okays from David and Jan, so I'll upstream this
> patch later in the week, unless someone stops me.

Just to clarify, I'm happy with this patch as is. The semantics make 
perfect sense.

-- 
Cheers

David

