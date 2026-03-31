Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 905B510F92E3
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 17:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E1A6B008C; Tue, 31 Mar 2026 13:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80F276B0095; Tue, 31 Mar 2026 13:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724686B0096; Tue, 31 Mar 2026 13:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD0B6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:16:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32308140308
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:16:01 +0000 (UTC)
X-FDA: 84607010922.10.AF6F5CD
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf27.hostedemail.com (Postfix) with ESMTP id 77B6C4000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:15:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=g0cZuL0i;
	spf=pass (imf27.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774977359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDb0j1j6pl/BPw01LZw1BJOJpwzzIFHeCdlmZQJ0cfI=;
	b=3RS5tEA4yce9GUDfqPzBbMJ01pchHAr5oJ0F6XyrCeYglInix1beK0V48Tm3Yh4MmorgfH
	Ww/yw8XchOaZPtG1UAdDMrgkeuRxIwD3PStuQ8ecN0ww+tWvwZamhrBbHe/yax5CRiPl1z
	+/LUKKOOJe7QulpWS+/IGP8VOrP6VaU=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=g0cZuL0i;
	spf=pass (imf27.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774977359; a=rsa-sha256;
	cv=pass;
	b=gwKSrB730fn5lD5BLpa79zAjj2bPTVTMg87AbJZzxFUCdlIZmNfmr9DcyH0Ox1zgMUGDm3
	hsktxSh1a/yu6h/CPhkv9Y4VkAAIG+7maEd0wKAIy6IUkGklZ8+/UJnBSSxle9ujgWjqaT
	i479oWa5QPu9jhgfH5nWLK4RFgf3Wdg=
ARC-Seal: i=1; a=rsa-sha256; t=1774977340; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=UFXNyx8LfCt+g2idEmI2a8vyd9MY5oc9AI9evRlA2bFVUYGM5X9VN9OeqC6bNeh+/ahvn2ls0/+/RX3vSjVL5rd4hjNBn8a6nzaAL4j8ZpnATFQgrCqaMQaRA5FAOqerpBWPmadGOzIZSE6X1dGvrofz2ZnHNHaLSX4i3CMczBk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1774977340; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=EDb0j1j6pl/BPw01LZw1BJOJpwzzIFHeCdlmZQJ0cfI=; 
	b=EUzL5K4jDXQ+3Nm8WbUoq0lVtWtsSq4s5QYn8XdHZ+B9mgjLtGwxYHPA+5vddyOcHYmUde3m57/zcqP3ZpnQKkUwq0e/ZZVY6+GdjMWzxppTsyUhc9gQRSjjDx26YjfAlz5dosOsz/ZQnO2g7W+9v15h1WEpsKkmK6NiqN7f7Vg=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774977340;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=EDb0j1j6pl/BPw01LZw1BJOJpwzzIFHeCdlmZQJ0cfI=;
	b=g0cZuL0i3GRYNpw6saf81ILOt9/xYbmorzEV2S3ktwq93fHtv+UH6nrRO24eUnRx
	B5peahtlH5LQQDIKu5v/pWkTdDUYbqGIt9U0mwFkHPpTet2hQqNeiCWm1+hiZyJ2f7i
	eCeXfb1ucxow/RQmQ4IWLP587IMUC7qaRimz4FaQ=
Received: by mx.zoho.in with SMTPS id 1774977339575965.6824177430996;
	Tue, 31 Mar 2026 22:45:39 +0530 (IST)
Message-ID: <f6f04017-3dcc-49af-b875-05a9ed4f4dfc@zohomail.in>
Date: Tue, 31 Mar 2026 22:45:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/6] mm/vmalloc: free unused pages on vrealloc() shrink
To: Uladzislau Rezki <urezki@gmail.com>, Alice Ryhl <aliceryhl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danilo Krummrich <dakr@kernel.org>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
 <20260327113758.75f04588310a707b4d4b1aac@linux-foundation.org>
 <acou2CsZOUQPx5nW@google.com> <acpsKv-GmaYj2Bmx@milan>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <acpsKv-GmaYj2Bmx@milan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 77B6C4000B
X-Stat-Signature: abginm3w84jzytbuh458mzsip1cgjd48
X-Rspamd-Server: rspam06
X-HE-Tag: 1774977358-487425
X-HE-Meta: U2FsdGVkX1+sstBgxNctGOwikbwEfxvDTZRLGfK5EjEp1igM3GLEbsAqhGKemb9RzEw+JrfVJkoIZKB2aH1OCYJbyw0cqL70Xb+N5eNN37yE5SuBSn0yZCi/5LH7CdXNNszn1vdAeYl5ciykyRXbaS+gg27zfVjrx2kVfVUMXcYYB+5FKprQkbAsqAaJ9SObEx+Ftcchn80BRr2Sx3jd4mtH6U/pwuDhiQYm7O2Z9T6aDraWdFA8QR59YWUPcIrlOQRYVY/Z0KP72j16w8Ao9ckO18EWvh3xerG0cVZ18UUSqKz9UtQggdbfXRndXwd9EopROySSQuSlUI0IIx7JSytwdHGeyZyWSvZ24AfSjhc4VyK+svvqnXEkgsWf6TMeYXC9OK84tMsaeoNInMcU4ddyyYaYz4R7FytV7VvZzaXqL2PcrNlO79hWKnkp4vmPWu4WCnPV/peOoE8joHWWn7daHbwwSVZWcpBRqFdMQuSi/NRuGOauDxPmCnBOU7+G0ULZvVKNelnFcHdP/NHkpjb3TU45lqOrSOd3WPKOZrNp9FYHhywgzoQg2Yrd1X5JtdsuAEKaVD5m6iORHDU/7eChgnTrvRDfnGDFpb13I79sMV5PjKxBav3ge5zZMNZsyMNPsAMFPubgkU6QpAfbhGXQ7pWeSN2PGPftWi+fBEkTyeTTA8XP6T1bYhiUd6ldmqy0r5SA6Kbvn5gwlEa+U2dCVDRi0idr1EWfIRvCrdcnLQRS6ccjCPlSP+oX/kFh3jmHzrMRfa5VthLtmi0Y/2D52Oxhxnw7NiuOrSoKwuQcV87kVyStpbaXSnxS23WYO0fZeNk/Wj5Pkq3mR1HA26x2rOQL10HyLqZK5ijpny5d9UKs34oPrxjuNw0SDAnwBMkPFEUHhAUUP1WzWo9APiBDLuDFEbg/2Cyyx13vPOtFOltXPR7XQ7DXeYfSxZSjeTGdyTXuBRyNB7TcgAy
 4ZdyCT0n
 WY4W5hczbOeB/QRB1RSqTlL1/2uAf1wnrw8kua64iR+UvnZVG6aZ7zmTZi+ptCGSJPGBdb07MH7Jh+NSjVcbtjTL4hGlDwVy9buMbnV8HIuuxugKuj8Ty0yUxkmRPYO/ctcx0ZXFarcoB1d+DRxN7JbvxQh44br0ayZKcSR/RHcagD4ogk1RtAeyakR3odC5ztsd1gAAUFbgb42hgkji2dOm0FBAiXbE8oCcCU0yXQP2ATi0kk1oYeXwVQ6wN7sRCe+C3Ez5N1iY5mjwwzHgmQjskfFaxx9fpowWOTTlBTMJ2oZXfq9QOY7G9t0DbeZ+1BOLDzaqsiDgTXTJBWaf9KXeMf32vuaiRpJa0h6oZdNwEJyW8zb32lYg5ZzusNqrmYuWY3oQP7Zg8je0ANa7FKBu5R19aNIAosaIyr1yD9s9EsIH3duUoE1Y289OJXlvv4jcTp5h6aOc1plJuGqv7os61+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/03/26 17:57, Uladzislau Rezki wrote:
> Agree, let's postpone this, so i have a chance to check it one more
> time even though it seems ready.
Hey Uladzislau

I missed rephrasing the commit message pointed out by Alice in v7.
If you want that changed or any other assistance from my end,
let me know.

Shivam

