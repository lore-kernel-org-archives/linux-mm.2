Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA251C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77D716B0095; Fri, 18 Sep 2026 17:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E356B0096; Fri, 18 Sep 2026 17:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644456B0098; Fri, 18 Sep 2026 17:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E26C6B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:58:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 838F3A0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:58:04 +0000 (UTC)
X-FDA: 85228246488.28.2647B3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A40B140009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:58:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EyUgiaVc;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789768682;
	b=LpyOGKP5gPvCPJ5JZdTRpkvxtFyWdGkY4TQFwqsov6kea+eJ6Bc/kUcGArAsZhU+oDJEd1
	JA7H3SYB/BKnsyVjZmU9AIZvOObFTrNYHA1r30TU5mw5ytGDYucUx9BCARgtbt6Fn5Leu4
	pMbGd9Y5a4hn0KrqiaJmG6ll70lDLIE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EyUgiaVc;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789768682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrXgvuK72kkC4qOs/j9NbCBUTy+PQyhZjK/d/IoGcU4=;
	b=eW4UgZ9iJTgvfIWaHs+ePnxO4qDc6tS2Qn3+UjjxVjy3L8PKeycGX77icEZdLROXdJyEAZ
	cSgRBIONIC0TlsKQsoio2XiY++TTrtyzyX0wMbZ/vqWSmaAt29w3OCgUVa3KkpM7RvEc9I
	DJkNSiRIOxuW1TEgl7ioOGOWrwOum9Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C3E94416E4;
	Fri, 18 Sep 2026 21:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55ABB1F000FF;
	Fri, 18 Sep 2026 21:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789768681;
	bh=mrXgvuK72kkC4qOs/j9NbCBUTy+PQyhZjK/d/IoGcU4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EyUgiaVcCHOdE23TBDEdYZwmBf64NvGoIJhDLN4URKlWu6Vk0WZNA+bAwCc07iYFx
	 oxwzsu+AJJsgzmWci36JOYR1XwuqoDUPocjC4VQ+wUwjdba8GibrddFemoq7mckE6X
	 Ik/1h+Cgg172Kb3rDU5OexBpf0IJIEcFf7pqLL+ftjmn3QiL5mKPP9/SP33r5xWf20
	 J9EYlvzkkskJUX231eLbqPMU+zSOh2Cv1X7F28EUoHw51qJUPOVO8/f0wyNby7p84T
	 00DLIH7XCP0euyjyCXHLMucbLUIznccPPhU619TCrVErmFp8bJkcOuknZnKI6NqEQ7
	 jFzBzNCKO549Q==
Message-ID: <b4266127-e781-41b0-9d51-d6a144ec19c4@kernel.org>
Date: Fri, 18 Sep 2026 23:57:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 09/29] mm/debug_vm_pgtable: test PMD swap-exclusive
 helpers
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-10-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914122950.3283997-10-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A40B140009
X-Stat-Signature: gd7b9nhyjqtg18y94gsfewedz6f8h9ns
X-HE-Tag: 1789768682-613287
X-HE-Meta: U2FsdGVkX19ZdG3QabzXLWnPGk4V1tk7ZvZYsSe7eUiysP/I+7jWyHJwzY3ZiDdO00S04hlRRa6k76b24wrdjvQjYTlUlzqXKe781Mxdhl5rsqZXQB8lb4WBFz9J8JK53AoeUpQ0ezMsn+N+v4LVcMTEwlSrq6oQl9eFigN8mDwuPErHIXYt9X5s8QvOerh9TxLW89Res7ahSTQ9u/1lrRKvmsXCfHVB11oz2eq9gd2UMbEw59B+hfDyDm+ye04PR4tPC2FiiFdnaRU6C8XytvfW/RVfj5+v6eKJN2axpxjr52PPvaHj8pgJnqvwXLRh9ozNjp6/ubkNQFMSO2OhZJ5r5SFe0NaOVX5/lgCyMBx9V669KKPsadqbNlnOZQOPu2Z0gUZdlCM1C8P0yuC4ReciXknH6gjruJe8im7qKilAwVNzGIigrzubAdRT9+9IjuKa1u6qhyB7gQG7GpK5iqDYQkEUcxsd3F52B4qdBd6k6ktudjUbmi7GNeOJJps4XlL/LViC05DdqO/ckzZtm5rIB1OCqZlWnl0Ev5ZXErtfP4q4qfnp5ayfr16ZpncTG52tZ2XtuoLIo8dfqilJpVk8RbhRr8/JsdTfBp8utvT3r/P7p7c0Em+Yj6gozbdDYQtiWii90LGdrnnzkHZcq8dRZoqaxiRcRCFkopAku1ABvNaOfMP9Zy4q+u88dtmOA5u6Ic2NwRFBz48sSr2AoKcnryO5rF1AwrtePHDJWWB8y6qUyIpZPEIE5ghovv3uq+4cK5Fyh5Cug1QO0u8OlDH4B4pl5vocVTYoRsqLnbtObggaqIvgIRuqClZ77xsu58rF7s8M9NVp2SIHq/AOlQbmW1TCNCTGwr/WrDlkhFk1hWTSM1d/xIk7/SPtlb1qF4nCWHMRCvb9Quc2EYZylEAGJLxJV7X4qGT0y2t92825g0iSLbP0SC/VtnfkzJWkrrP1KJ3x4L8ctYeXess
 ZbBVcm2O
 vB6HAERGjQ1x+LXKk2IpgOIjfJH2dwxS17r6kWbplJL57w34+i5tjbndCjcYoun/AT1gp02ipGEEFzTTS7Ld47SE6o3sbjOnQ068OZgJiWxVfvRsA0IYQiHhnMo2VCLdmRdjzsRkT8s5QfEfQdmqi63JZfYRjfhFGMSu/oAVRly/bSMaP2qgfTUkNmTialp2u6F6+Ts2tVy7H1O09lbhqswNBjLT2g9Mvdf5dDNcIfLEL8CJVqZ/+YLiSoE0+iHWhVvkhm8LH4kq6bMB4am5ELc45JYq0KyF5X9buGUWBAKg/W6mH0NziMTwOma6ac+gkO6oQbz7Y4Xd7JFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 14:27, Usama Arif wrote:
> An architecture that picked a PMD exclusive bit overlapping the swap type
> or offset field would otherwise only be caught by data corruption at
> runtime. Mirror pte_swap_exclusive_tests() at PMD level.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

