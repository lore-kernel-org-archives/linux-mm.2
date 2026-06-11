Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE230CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0286B0098; Thu, 11 Jun 2026 07:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090636B0099; Thu, 11 Jun 2026 07:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2646B009B; Thu, 11 Jun 2026 07:27:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCE846B0098
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:27:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FFB5C1FCC
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:27:07 +0000 (UTC)
X-FDA: 84867405294.05.B0D8769
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B0EB8100012
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:27:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mHELn24G;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781177225;
	b=MUezXNrF7Xwd5H0tjfErPPWYtQ/qewxgxlmvH08RSCWWy88wPv2NTyIFsj7bdRSZnJ3dCz
	ALRDaH9gdYo2bwCZ9e7tyYl3VQsKaWgSCREc2f2pa6edXb0BkXKhOq0yflzx2F5drDkbJ/
	GgRQ+R2YirWM5dIkGM+fjX9ZdJga4/0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mHELn24G;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781177225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYYnd4Zz9q84LFFeACONzdQ+ixiXpHspWS7cUg4EYiE=;
	b=Rl5LIs0jHrBA6TC8UCCi0+m2zDPZ3l76aCXSPDNvD+0afsswJUZwxCXAtUs6ATZzJdODaN
	ZWpWtYSRAsQhitZ0c4XsHGbx3KWmz6y4AbwsZkB3NEeiUEpGyBYksSXqbDUQ+31Q7XIHVc
	r5TMNfnwK/JraLIHhJHqcBYEdyag/qw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 14E3C60052;
	Thu, 11 Jun 2026 11:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F417B1F00893;
	Thu, 11 Jun 2026 11:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781177224;
	bh=WYYnd4Zz9q84LFFeACONzdQ+ixiXpHspWS7cUg4EYiE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mHELn24Ghek242AaTXZbG30vsyn9jDmkH/4NMRTti3KqfkLj3DGa2pKzVH4PgAG3l
	 4WZPsUXWERDGoLepQ6KpKiD2UA11nMo6VPcBQynsVw7Omhg73HEx8maS5mrrUzhoNu
	 gr3wqR/T62gnkpLcFx7JF/L/a2Fw7lZ0kYN+1oDYYL/h3NWrkkyAm+pRwLijpm+uHy
	 VBkojXh/ct5QEo81vqn+lbMpstNla8N+qYetTNnq0TSAL3BtuZ0ykvR1EdM6ZU7d5E
	 iEN04lHZxU8at85xyWHyvfzam69VH0TDekgmcjx42svs5P4G/wBrQwNRW1Glhsq/46
	 27W0P01CwkkVw==
Message-ID: <b2e63557-a0fa-409f-8a75-12d43257efb5@kernel.org>
Date: Thu, 11 Jun 2026 13:26:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Anthony Yznaga <anthony.yznaga@oracle.com>, Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Aishwarya TCV <Aishwarya.TCV@arm.com>
References: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
 <9afa4ff1-9749-4efa-8112-73fca1f25e8b@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9afa4ff1-9749-4efa-8112-73fca1f25e8b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B0EB8100012
X-Stat-Signature: kqfpq5dw5cuignrxjkyj7tkqk4s8pfir
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781177225-229968
X-HE-Meta: U2FsdGVkX19Y0GvLg1vNFO3xBgbH9T9AXsYdaxjDaCKxDyd8vlAYvMma0Sv0lWwAeaNbI0NFuL+KEjzoyLtX9+l/6Ps4+A5LVUPsZUhOC1PG4XOHyNPe80d56rQSk232fA8cPxmRUnHpPnEjyGLL0+YV3sl+AWljnFeDcIAklsbONMVuc4c+D77yrfSkXj74uYu3Xu7YJZ+RO/d0TTBmphm6LrYDlUXOIDiHNARJq0iJntuhUjCorVXDuPbtoHYJAmWWwp4sMsg/tlGJDet+iuubsJlGbrtIZVxKUoiyt8F9KAckZf/DsFX+zz77O5IBCvmyYaEbuB1448Wb4h9FJKOs7t7HzK9x+qOv0f7J0hNdO9iNdTtoSz8nDCcLd2fAyu5WKsakdrxO/DEkS1xn8cYb3ByrY/5iJhMu4Dxw9OCdNTjXcBXwGNLW1MatEMhi3sZHiZzj+rtT+oaXA+5z1Yp5969hT69LLX+CQ3sUpz2ZXuzCUJNZOCMa284ayu7K/pN/BoWKumshpHJfx2Cswc5LBUB3LFOMgmCjsaYSseaI/4hMhogOVcFxIKOquFdYt0lGDyhRX/g3bB4S+n+gEj7WTIe4m/ygGdNMuMkMWcqL2U/qcYzqfAPdBhoYz0ptu2mMLdZUA2U5fOTA80YjQhhbUgN6cytHNZNGGq3WgWb9nOIerBt6mhRaxxdWX3+SoFjGWDaYNVE5zEphtxzWyzJU2yZ3Q3gMsIfVKFPvXDk2WGD0zpTCwrQ5S+ZJRCR5G/SWaXC4G8AJKCFFhdmNZjiFtGyR5jXp9i3xjB8+Z6s+ckz761Lzq6H/i8L1Ithw/cgNyVzZ0iQ9R/Vq/aFvxfv7m0UWmygMb5Xj0zL4+6C8LhoNhd+I27kcaOqAe+pyZSh4155kp3xZK7+v9jR3ttgQnTDTxOKnJYkiywtSUlXVkTA3bTX7/Lk8G4rSuo4EjBubhDecVPLUPoPFeDs
 n1T2Rsy0
 AfngOOWKrkY5KDNAZGB4B7EZYA86dznsuRZhTk4rfgjD9m7DIoOJZtUNDau6nJznUhZr6dcmjAod/CZ2KzJvgNmk2Gk1I3koVvpQB4NVm3vlMUEthSFW4Gfr4iWJztXBJOVOq3/+BuJre3qyVYBpP2jKwrJ+PswA8Psn4hyE7soC6P5HFOHM8J7x7pl6V0/ksnAT9guAujIeB6+Qn0TkSaV6TWohYD+os4PHi7o1zEzFzw0Iolmi/cUs2JcjrJYyHIK4RJWZOgtHt518J0b6neu2/53yLSoMteF+mvhPZIwPcjHDjlXvgHksAOPLo/XaIzYWLCLxqarEaMXJSxqxszhtRsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 13:07, Sarthak Sharma wrote:
> 
> 
> On 6/11/26 3:31 PM, David Hildenbrand (Arm) wrote:
>> The droppable test currently relies on creating memory pressure in a
>> child process to trigger dropping the droppable pages.
>>
>> That not only takes a long time on some machines (allocating and filling
>> all that memory), on large machines this will not work as we hardcode the
>> area size to 134217728 bytes.
>>
>> ... further, we rely on timeouts to detect that memory was not dropped,
>> which is really suboptimal.
>>
>> Instead, let's just use MADV_PAGEOUT on a 2 MiB region. MADV_PAGEOUT works
>> with droppable memory even without swap.
>>
>> There is the low chance of MADV_PAGEOUT failing to drop a page because
>> of speculative references. We'll wait 1s and retry 10 times to
>> rule that unlikely case out as best as we can.
>>
>> On a machine without swap:
>>
>> 	$ ./droppable
>> 	TAP version 13
>> 	1..1
>> 	ok 1 madvise(MADV_PAGEOUT) behavior
>> 	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>
>> Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
> 
> I ran this test before and after applying the patch and recorded the
> execution time over 5 runs on an Orion O6 board.
> 

Thanks!

> Before the patch, average execution time = 3.87 s

Out of interest, how much memory did your machine have?

I ran into this myself on a 200gig machine, and there was essentially no
progress ...

-- 
Cheers,

David

