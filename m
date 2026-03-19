Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775F8109192A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 22:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49206B04E1; Thu, 19 Mar 2026 18:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FAB86B04E3; Thu, 19 Mar 2026 18:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E89A6B04E5; Thu, 19 Mar 2026 18:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4046B04E1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:07:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EAB21DF0A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:07:30 +0000 (UTC)
X-FDA: 84564199860.27.C506783
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3FB551C0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:07:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CQdW4wyt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773958048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTwIvsxB3hF/gGL8qt+NgFzhjgTU5+R/E6ggnSKNM/E=;
	b=wlIuWv+jvr42tfQuTYwKg45wWHHLW5+6herrsLXuGfTIK8iZ2/G987im8h2gSsGcHv5K5E
	UgpocE8YHXsnlkcxzCcbWrfUb263ap+wnUOOigIox7OLSGvCgwx7V+rJpkX51uVrrw58ib
	TO/i6Eq3j3t5YGmxExkO5QjE+RYM7Zo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CQdW4wyt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773958048; a=rsa-sha256;
	cv=none;
	b=Gj6Jhw9jB0wCO4m3oO8KZxDNzWvrNTZirXTsy5yVC2grruP40G6KF7dIB+9FlHu9Ev3rUR
	65i9mtuijCPDVbq44PRPLxjxC+kXElsCezL/jhQmJX61fCMqUn/enLvZ2bxJ27ySDgESMC
	RlAGXBG6rrJtK8ZME/62IdKiE5ywnQ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4AC6E43910;
	Thu, 19 Mar 2026 22:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF18C19424;
	Thu, 19 Mar 2026 22:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773958047;
	bh=VLpw6vvbor7XAeOFDdqvHgoXswBR5eeaW49UmB+ssYM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CQdW4wytk+lGyn8N9QzpKaN9ySpRGKvktM8wkV+MXqZOeg5E/YRIXYlzvdNHfo4vU
	 xvtC/mwcPwkPlMwZU7vd0aIcSsZ8PO8LgNMSLunwLJu9JlKHiX8nB2H4+mn1bCA5CK
	 wNnrA8uVrTKrEOvk1+G8daOfHzfce1cv9jtEPr463w0zNT+pg9wJpkoJ4OAij+mkPN
	 I/Hlth1o6Vf+sJ4tRFnJbHtYmLkaUFAmqXrBY7N8u6nTAS9BCOvPMJdXZ7Dy9pwbOw
	 +iBpWwPJm03250dl1+qexxykxNIkRJg/yr9RgoTD6mKPfW6a4iPirQBsXBJWXl+8mz
	 P1omaz+K2cb1g==
Message-ID: <54364b65-ffeb-4d91-918a-c1e4b0c92816@kernel.org>
Date: Thu, 19 Mar 2026 23:07:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/page_alloc: Optimize free_contig_range()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, Ryan.Roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, david.hildenbrand@arm.com
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-2-usama.anjum@arm.com>
 <220e97f0-dc82-4f37-b833-7160aee46cea@suse.cz>
 <703BB8CD-23D9-4012-8333-366837D7E95A@nvidia.com>
 <fde63978-d632-4196-b032-4cc20041fd90@kernel.org>
 <2AE5B748-C57B-4BC1-BF9E-6299CCBF295B@nvidia.com>
 <3883abcd-426d-4211-ae76-b5601ee728de@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3883abcd-426d-4211-ae76-b5601ee728de@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3FB551C0005
X-Stat-Signature: o8i7ur3d3j4qwnj9q7cmda9s4g1sxz1r
X-Rspam-User: 
X-HE-Tag: 1773958048-346368
X-HE-Meta: U2FsdGVkX19WQPUWU4LSM4a9aoKYjsKzFED/zXTJKJ0inA7uaRnkDMvwY+kO1uRkXYvcnIe57sleIvxjTI+1oYbueYVhlv+bWqBvE9BozG22+fCSDFjz4c7qon5yQwGLj/EXvIF6Iv6cIrHChuYWT2WIigSXTnmQpKWnK92SI8qr46FqujqAU0eLKGWx24o4TNAdED+JXVh0SHhKmkntSKMFjjHXNcYGIo1DJYlXmuX2Eb8WVHwjuTeVpyJHLWVagwlHTWqWiqtgTgS1CzirXU+BXgz1Fsc8z3DkCiYQxdQg0OATY/ne/EKNYLN/qkJTqtI2JchTAsyspUCRDMQz4vh38wA4WS5DCNHgnvzC7ZYOpxqCzsBPmszNqj5hzVTCWia46ScALrU/bLlZsbLWOtco288U3QQJpo0z0oyD4GQe+3Khozn6MNWt+JKY1O26Nwwcz9e8I7iUdeAyIrZ1Cspc8rOLL6rliHRZdTQsACDldkWP9SvjCuH++DHQxpzdx8zE1jv571ldYg/KTPSZGLFLnU/KbhugSKLzp3Yird254qDoJJb/9wEgDjfj2JSDzoqU0LUfaxl176qGLJESzSDioTzoR/5qwaaYYUGgHLkXayytVXkh8z/Tx5FFZ26Kmto/WfdLdi8UHbvryeAHqanFGIMhV7eRcg165iPuThHv49Iv5zFGqJPMMF6Nvwi8gXk+9dfo4uIuimDNAKJouolQ56FIHXold/BnLZUtpEkW2ZlCcM4zTSeYvwWO561g4E7ttmIB/VqsvylRsfhh3UIAOZfhq79BmEvyuSceB5dcq86swDLRqP6K3wW59w/Q1PQiCy6BA/UGMRvg4RRawX3ZoS7BeNlVfEVlZQcCO7TDKii2CK+l9DQOZ8NXhE761t/ZpB4cWRikU/6YmIQPb5oP3GruWUVFy67Su2AOoSVsOzNnfJ24iBuAO+CW9wLAT6rpQPc5ZKfs+JBrUvz
 soHd8lr+
 vGcJ55rKsHKUCJdEQQsasrgLFaNVAXm4emcep6fZdQee0nWckD2dnFe3uKinL6/2zUDGnI7ghOEUpalQjkn0ebOBF2y0D6dmKja1CMyYfy5gI2REKC+pPwDgnXliePNdTfxvcvDILjiAkZubOK4uZpzUoOoo3R2iUPTAkRrRw/Gy8q49L74doSnR5/Zty7x+Pj0v6Dv8vy8FDg5R9pKaMYjhDWFKi9Gu8KXBykBXSK39GOb8pTQfzaAJIqZM8mqGhu646wlG7AUqrHdN/WwWdTYWdDU7AO7KENCi0Ud27eozxA5NxSgcZ2YHgN+fnLJcNYvOBWVwfQICSYb0rhIFXCBFUa313R3cv5h0L2+hgiS4pcccSgE0nQtRHghVTs9LWaXBn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> the allocation of non-compound order>0, like you suggested in 3, we basically
> 
> I suggested we'd take it away in the sense of not producing order>0 where
> head is refcounted, tails are not, and it's not a compound page. I'd rather
> have an API that applies split_page() before and returns it as order-0
> refcounted pages, but not the intermediate order>0 non-compound anymore.

Are you talking about external API or internal API?

Regarding external interface: I think the crucial part is that an
external interface (free_contig_range) should always get a range of
individual order-0 pages: neither compound nor non-compound order > 0.

The individual order-0 pages can either be frozen or refcounted
(depending on the interface).


Regarding internal interface: To me that implies that FPI_PREPARED will
never ever have to do any kind of "subpage" (page) free_pages_prepare()
checks. It must already have been performed on all order-0 pages.

So the TODO should indeed be dropped.

I'm not sure I understood whether you think using the
__free_frozen_pages() with order > 0 is okay, or whether we need a
different (internal) interface.


-- 
Cheers,

David

