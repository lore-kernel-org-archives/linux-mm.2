Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7453ACCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 02:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F14726B00E1; Sun, 18 Oct 2026 22:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC8A6B00E2; Sun, 18 Oct 2026 22:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2A4A6B00E3; Sun, 18 Oct 2026 22:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBFF26B00E1
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:08:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42566405C1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:08:21 +0000 (UTC)
X-FDA: 85337741202.03.957EC8F
Received: from mta0.migadu.com (out-104.mta0.migadu.com [91.218.175.104])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31B69C0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:08:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pLDQIBFL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AapkH9Re9c1pnNZGrR/Nofsi9bNRtMJZBUYf8hABUds=;
	b=2qOIQRnYk4C1+jNDgOfIrBvqIA2P8x37vAJvZ7KBC6rda8hSDHxN4O0ZfqEXmWjAqeswP8
	mdbgmw1iB8mKfUxmMOIrO+8LZ0ON0Jxe2KfLbRT7BxXf46+bXo4JaxH37BvYfhGoCsEeUg
	wkhejySS9dPz5WhhUWSvJoxcFlwpAlk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pLDQIBFL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.104 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375699;
	b=7i8OC/U/fcW8wADdv4J+LgjdKFeTfRUC3dAuxmFNwEtD525e12pGaH7oQ6wy9m3+5ptIji
	ga+qXSVgRFPEOTTqe5bwQccnoo8f4KN/jbHPD3jvbPsyuf7lJEvk2I2gQw3/8t2N1h9Idn
	hcPxOd7dXwU4YFDQMgU929PuTjB7nBg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TGx+L/6tf3P9BlQx79oc67eTtWqhL3dBGQ6vFXfCt04=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792375696; v=1; x=1792980496;
 b=pLDQIBFLOfInEnDPpokkie/UA47oQoauG108QTVlqIktQGJX/n0lLXVZDZOWuKXtaxIxI9+e
 t7N7EyMYplvk2oLpYy6jiHX78FTPXwHt879aOOfRWf5MInsqfJa4L8qEadLpw+IAfh1psjwIs3y
 O71dUGLPE50XIzWLy1W08gMM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0856886304343c3d;
	Mon, 19 Oct 2026 02:08:16 +0000
X-Mizu-Trace-ID: 0856886304343c3d
X-Migadu-Flow: FLOW_OUT
Message-ID: <e2ea8e4f-152a-4695-bc25-1712e385d8a2@linux.dev>
Date: Mon, 19 Oct 2026 10:07:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/ksm: keep soft-dirty and uffd-wp when merging a
 page
To: Samarth Narang <samarth.colleges@gmail.com>
Cc: Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20261019010934.697895-1-samarth.colleges@gmail.com>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20261019010934.697895-1-samarth.colleges@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 31B69C0003
X-Stat-Signature: 9eyrd7s5pihrjyqzdw7hpzekxfroud7e
X-Rspam-User: 
X-HE-Tag: 1792375697-698948
X-HE-Meta: U2FsdGVkX19ggI2tKQWh9JiYqz541y3CrRizhIBFxXxJQpE06HoIKr+knkJOK2ZYL6GqJwxwtJsrvEFVrc53yZ/d7t+h/dOCJJlCg5TUZ8WyEpoOZ7U4c2QieToEOP0xLtQznM8/rfekJ8UEVmSeW+x7yHRStgZ+27+s3yQSy18mHjefnZu2OnD9hc7oaXB4oO73dK5oBl8tpDpsNIp9HxdXwuGy0J8x8LFYHJPAPqkpfIQX7DU9OGOOLL+n5aI8fPImzPpwNuNZSv/w1yg6hyBmvN47No4QR0kiCwB23ckE6SmOkohOWGijfEK5WEElWvis4aqXuL1boZ4aXvTodO60aZA3fHzXJT+17gTwA/EI/3CZRP1rMVEnVx4cwONPlBncxWYQ3Ycc3EDrrhygcvq9ktIZmqDkcNYgB9VXf2i3u5j5iL21Cu1Aoov9JUxbotNqnkroGRlQyiZ5t1ofrrUnPYAFWWWWRrti86zLLyrDY9uoRaJNndkbGkbHk9oB4Wgfpi5J3yiCmbT5K4xF9kcLQzngEi6tEc3QI185ZSH5X0grOol5ycaPuSafSaMki9FkM4VCuQ6XL8UdbPBQZIV3Q7rpAqVQhl2qlWzZA5jAhI9W6yHkrkZ6z+hFdg7GFrtCSFzXL4Ec7nd1cc1zanhQYVCg5bM9lxGf4HqJHpoyUgtjtHZQ/fhTD9LJakAD1ZllqClegkDAtl/Ur/RiMcLxSsRaeZsUjlfzzvqJ1hs09Ysw41A1jS/vsTd/c/bTTtYkyWIWvU0lUCGyjJfNFuBZZspFFPXHEYfvGdTtnvSND+6k1F0W9wIPUO1gJqcSW0eIU1Co+39FFWviRLL1iYZnPNUemIj9Ri/6+W8ttLlk3jy6UI2FMk5+9Eg0d+CHv+buNd4l6rNpumjon3HHliUldg6ToaD+Sg02I+v3BvV0uF3acKs45x5HFndRyvmEMqYP8wzFz1fviw7jWrS
 vJ+WKnoc
 Yd3fFRCLiQ+N63WE9yKrc6J2J1o67KZj+qPN0xXCO7lsVNwf82O0k8/QniexfC72BYPlUHdrtLH8fKYabHWCBPPT3b+rBQ1+8bVPGDYmu7trskkybqDnHG5zuncEfvB5JhvYSxHEXLagAx0dzxFQh61KXcHZhUb5tmNGy2ZG/wyeOfwxiuhhnFSHDIO+t3eIzbs2pi+7zhHBrcsqgGYJbI+8XQNKtV+zfqUZvI6F0kHO2MM6q/Nu7dzB9SjyoFLvRGc216XnIH4cbowsxsl66OQmEfvA7QxRY5WaEjIWJhYGEp8RsYWb8AD7XKhXKFCdLHnvaIHPG+Ojv+K0SUikrQlSzKbQeM537aaZVKPJBl/ZGPRFJrYEd/SCVYj3wn10usYg0EmI8djboLBFRMqjzBH5cIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/19 09:09, Samarth Narang wrote:
> replace_page() maps the KSM page with a PTE built from scratch, so the
> soft-dirty and uffd bits of the PTE it replaces are lost. Due to this, a
> write before the merge no longer shows as soft-dirty, the next write to
> a uffd-wp page raises no write-protect fault, and because the page is
> mapped with the VMA's normal permissions, on a uffd-rwp VMA the next
> access raises no RWP fault.
> 
> Copy the soft-dirty and uffd bits from the original PTE to the new PTE,
> and restore PAGE_NONE for RWP VMAs, as try_to_map_unused_to_zeropage()
> does.
> 
> Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
> Cc: stable@vger.kernel.org
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Assisted-by: LLM
> Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
> ---
> 
> Notes:
>      v1: https://lore.kernel.org/all/20261018122957.526467-1-samarth.colleges@gmail.com/
>      
>      Changes since v1 (thanks, Lance):
>      - Fixes: point the uffd-wp and RWP tags at the commits that make the
>        registration modes reachable (63b2d4174c4a, 2d427bb01639).
>      - Shorten the comment; the uffd bit carries RWP state too.
>      - Add Lance's Tested-by.

Generally, no need to rush the next version out, please. Let it soak for a
few days so folks have time to review properly, instead of making everyone
start over every time. Just saying :)

Cheers, Lance

