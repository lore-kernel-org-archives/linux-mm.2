Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A29CC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C8B6B008C; Mon, 28 Sep 2026 04:54:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743D86B0092; Mon, 28 Sep 2026 04:54:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633A26B0095; Mon, 28 Sep 2026 04:54:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E15D6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:54:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F309C013E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:53:59 +0000 (UTC)
X-FDA: 85262558598.24.EC4235E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DD4E11C0002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:53:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Lc49o/Gj";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SoMUT2BwfJC5COzbHfnGci4NZdcVm+iQPUkVyhkFY0Y=;
	b=cXYo0veBw3ehotNqeZskzLoJAinEAcT2yIaYQycquX0bE6lhL6yQsJwJoT84RpaGXD704V
	Ysm8fJuU1EtUfdLBt2SG2ivqzP/gnchEg2s9r7qow3WRUNiwyIEchC6sgDT8viEvLvM5g+
	DKYX9bryqtVBFfIT/venA+S6P2opz5c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Lc49o/Gj";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585638;
	b=5SgHLrvmYr+sg8DZ/KINSJJVA3qkeEszm0LoRDhUhQ8nnk5vrSMPlPtLvgLwS4ZBazU57V
	L49B93VeTlG5EV/lsi0DzDqkTjgHF+YvkPN3v0lqqIciLUAFnXxsrB01tx4fNEnVNxqln1
	yLlq6lIiuod6iifsjrqvVI3eYVNrIt8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 38FD8406D7;
	Mon, 28 Sep 2026 08:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFC51F000FF;
	Mon, 28 Sep 2026 08:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585637;
	bh=SoMUT2BwfJC5COzbHfnGci4NZdcVm+iQPUkVyhkFY0Y=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=Lc49o/GjqegLQqj0XCZDeVz5FkD9g8IF9bKFYEUjp4Y3OB81Sw7NlOmJpVplTGR6e
	 YFgr6CsScU19Q6DXfkHkm5D3S+C7znPTicVnirUwx2eG02C13dY2Nr8/mj5mxN2ue3
	 BPlIybV2xEW0mqgJEyVuDpmtktYJ6wDfnObzWKEpyEQw+2hNjdkjHcZWO6hiE15GVx
	 b6dj/Qoc0EKruxMHbjx9xilKEBDJWVStMT2koRkSebYcosSpP7WMw0vs8kPjcxRD31
	 Z3rpvKi8lwtcxU3s/2WjY64ryo2hB91DOfvMq6GHoAM/DVawc1gIYfuFhAs+tfCdYM
	 UbcNStzifoHkQ==
Message-ID: <4facb8d8-2ccc-4337-bdbf-3e8c03351b7e@kernel.org>
Date: Mon, 28 Sep 2026 10:53:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] selftests/mm: add tests for UFFDIO_MOVE of a
 uffd-protected swap entry
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>, akpm@linux-foundation.org,
 rppt@kernel.org
Cc: peterx@redhat.com, surenb@google.com, aarcange@redhat.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, mhocko@suse.com,
 shuah@kernel.org, kirill@shutemov.name, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260926124145.2878520-1-donggeunyoo.kernel@gmail.com>
 <20260926124145.2878520-3-donggeunyoo.kernel@gmail.com>
 <4e4223f4-dfec-4e82-97fe-25ae3a3b0f73@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4e4223f4-dfec-4e82-97fe-25ae3a3b0f73@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD4E11C0002
X-Rspam-User: 
X-Stat-Signature: exwu8tpoknsnj77xe5augfjj6thrredi
X-HE-Tag: 1790585637-965886
X-HE-Meta: U2FsdGVkX1+cSj/O/dQGIh13TgF8nxyip9TDrR7LY+o8bxgtT7qGdgwG/XMWoyjKg3or5rqWvev870TFe2bazJMJ73UTtwrdMsF3ecVe992PFzXBD8xFu9/yaV3EE2PZ53V5jP3RYwzHP4kGqLK2taOaCebaD9Q/zxZUQVh+F0jXY4MS0n049H7dC4SNgW48phGo0gTr86586+2kzhOa51LzhFJwr8NbrA+on3KWHfDhu+VxtrOVCaCE5fa8yc6QnM6L6ErMMNVs+NdcBaJejJfO/UGdBV6SU89JK1/KWSMKbCceithCSlMpMMbiyGz/1ZN0VU9/1pOMrFJ7QzZSDjLv3kHTVzl0UlhmysWHAAg+DZCP5e87Hh47epoYN+J+LUZ1lLs3EYyAGJakvIAF0bR0+kGcKYGLfiP36WBs2LNzsulvTnlQes7cmss0jIhAGE84sm9X73e+i755LehlcShhkL5XU8ivjyccRzLhRpTU5wbcbL07ll9AS5qfcofo1J1KXsmy91hxaOM91LXkEiDRfCgT7Qd/0GFGzQ/C7B1PfXGrGyx3xOizQIczB6s+HDcXz0yqFx+cMmzFQemqE1dHh9TFWXlw3yhsvmvHVmkFWzTH4OAKws8X12KTHEXNVWlMk3k3ST8xT3WF7YHyipwlxwyQsgTyRgDoZmar8RhfRIHN9PcSGhlCL1My5wgLuPe5lO2VnkFHqdWo87cz7QcZl1FOyWdgnnrLPKWngc07ICxVF6CliBL53TMSIGMJVls1Lc8+hEkGhzViXAPBqLkLC7UnE1K5cXOhwQvUS08DWyas8ol+CczMMA+2ydDiDx0dPCgeu02M1YwIgwycgskWNrhC8HgJtRPhs4KEybn/yNWLjd6zbnCF6bP3jZVBI7PKEyRLwsE2atCNoeMnoN7By0pM2v88bzGoUmfp/X3GBOwMs9iTOpBl6dNJbjpGWs45zA+pIAA/iGAcCbm
 2xL4MZkP
 xpcjYzDIUe+JhhNc4KSCGmjEHrBBkuHsey1WXobyjlu9uCNiQ3bzs2IJoJEv+3ltI+Kya/ln21bZfU1KrYXmtQLH3DipnLyLBusKMzSrVt3ZSxuHH/MAMHAGRMIU4VdKbJ2D+vAupEncMtXxYHcKVSztMOzEFCxTmZNhvWAsunnBTxV8OP0zfAo5W4nCG8PWzeeJxvPbQApL1Bg1Yoq1/bNfWxPF/p8j8zeTyGnl8C/To0y3k168LbvVChdig2LPI6QJ/yTP9WlR+XBPEsC44txZcbkcGoHA4omizpd5QDg8k4mlBuMiCSxZNQVj55I9WpmemxSSfog62M82ZkHZrocJfHEcMCNi3XdbON6gwiGQkiJxJoWo1HLOe1izUToL11ZeKcwL/5gZcOAQJqPa3/N5hAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 10:53, David Hildenbrand (Arm) wrote:
> On 9/26/26 14:41, Donggeun Yoo wrote:
>> Move a swapped-out page out of a write-protected or RWP-protected area into
>> a destination registered for missing faults only, and read pagemap bit 57
>> at the destination.  The destination was never protected, so the bit must
>> be clear.
>>
>> Assisted-by: LLM
>> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
>> ---
>>  tools/testing/selftests/mm/uffd-unit-tests.c | 84 ++++++++++++++++++++
>>  1 file changed, 84 insertions(+)
>>
>> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
>> index ef9b3956bdcfd..580178630eded 100644
>> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
>> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
>> @@ -2037,6 +2037,75 @@ static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_a
>>  			      uffd_move_pmd_handle_fault);
>>  }
>>  
>> +/*
>> + * Moving a swapped-out page out of a write-protected or RWP-protected area
>> + * must not carry the uffd bit into a destination registered for missing
>> + * faults only: such a bit is never cleared afterwards, so pagemap keeps
>> + * reporting the page as uffd-tracked.
>> + *
>> + * Needs a swap device; skipped if MADV_PAGEOUT cannot evict the page.
>> + */
>> +static void uffd_move_swap_test_common(uffd_global_test_opts_t *gopts,
>> +				       bool rwp)
>> +{
>> +	unsigned long page_size = gopts->page_size;
>> +	struct uffdio_move move = { };
>> +	int pagemap_fd;
>> +
>> +	if (rwp) {
>> +		if (uffd_register_rwp(gopts->uffd, gopts->area_src, page_size))
>> +			err("register src failure");
>> +	} else if (uffd_register(gopts->uffd, gopts->area_src, page_size,
>> +				 false, true, false)) {
>> +		err("register src failure");
>> +	}
> 
> if ()

Clicked sent by accident ... let me reply once more.

-- 
Cheers,

David

