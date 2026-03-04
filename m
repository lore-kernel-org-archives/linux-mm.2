Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4260CEFCE47
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 21:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935786B0005; Wed,  4 Mar 2026 16:45:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3526B0088; Wed,  4 Mar 2026 16:45:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB386B0089; Wed,  4 Mar 2026 16:45:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 663856B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:45:04 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08D6713B61A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:45:04 +0000 (UTC)
X-FDA: 84509711328.24.E2A0C55
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2BB14140009
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:45:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4oI9c5KS;
	spf=pass (imf26.hostedemail.com: domain of 33KeoaQkKCCM9KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33KeoaQkKCCM9KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772660702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQJWEWEC3u4QRpXVmQh8ZOdiId8Pv3qkT2tXTUlQLLk=;
	b=nMdB/XdPTDqa3u6rUZibjzGgkUnKuhxCnJb5UjHwOGxamMhXxU2lyqa9Jpryo7U8PD+g83
	jgzDqWXC7ZHIeLCuXmDucKxgoIoA9Y3dNeX9574PcdbzJGAdnW+a7hqaJ+dQJGvdsZZSuS
	92xINd4XKk0SkZTS6GkyaBvevmmPB8U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4oI9c5KS;
	spf=pass (imf26.hostedemail.com: domain of 33KeoaQkKCCM9KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=33KeoaQkKCCM9KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772660702; a=rsa-sha256;
	cv=none;
	b=J1fKLuxOhK4AFZahqCHq+cm01sehd2sDziynzHORQQc2WbbwRV5Qc0oUmOjoIOEWk50GNc
	jXrH00GYoa8qI15FIC0DV7AblW9SR7D+wTneoBT2uCID0UAvfTlv/1wzd4psbZINl3Pcqm
	MoDjmMx0sXyDpmwCL91P38gmR4OJldA=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836bf1a920so79754365e9.3
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 13:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772660700; x=1773265500; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IQJWEWEC3u4QRpXVmQh8ZOdiId8Pv3qkT2tXTUlQLLk=;
        b=4oI9c5KSyP2Ed0KmO61wKfg9aPmjPSS3zys2Aa4N3uajyIgj7nL19/jS9vyBAfo07V
         MoyQ6YU2GJrOeZW2eFgxf0hzGwYnelujIiqbz7VbZy3uS9UOtG8AxdNExKU19OHg7wTg
         rhPArcwENM5IINpj396XhgdNEx+973ROI6NxOh0NksMFCzYXcDk83y0FOd4SGKvYlJE9
         kNsaTHuEVtiiB+RAOo9j+Q8rjf+aZrIuJzpiHvGsC3n8J8uG6g0zgXcSkgxIRAD3OwXz
         alQjRJ7ku/DCHggHc/yGdC3xx2PJW61u7JXHTHFD/bko93cp1MVpzz6HsNV5rD8n+mZO
         hTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772660700; x=1773265500;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQJWEWEC3u4QRpXVmQh8ZOdiId8Pv3qkT2tXTUlQLLk=;
        b=ofY9TgMVoHh7EOvyKxTzVS+KVyHoe1fFQWxcfkU2i2T0N0OJVpi8j9nOs+DkCQDA3n
         +ALuh5Oj2bz0FOgI6rnuq2gICb8tVJXsJDkO9N1GNofGOOnhWyRZGJg1PJOg8RNurl1q
         9zSigEDjtwMQL0iTQj8oNpcy+V2gI+jSEHP8ztnaKWIWzb8D2WxwaZL90RiTQpaX+j8L
         9BQ/AYh0T+vy986FAmS4kWdq7onIHFP5GkvN/zNUmEE1+pmMIyvYxthzZLjocFPd8g44
         LL53lpelTiKDt2kB9VcqRNmDnWTSaSMnDa92JsAz/rYeU+LG9BMMB0yjjhlhlNN7e9K7
         R8YA==
X-Forwarded-Encrypted: i=1; AJvYcCW1sdjvwaL5+qz8t4626bODbkiTzgGkz4xmFB5Lqeh4peO89NJicqbf1RGiEFbSs72D/kHHw5kw4Q==@kvack.org
X-Gm-Message-State: AOJu0Yx+OGXAzHdAeD1dYqVxwv96jjTynWV/FFT2op7pW+z7Gd05rJKY
	n57AHtD+nqSzP8xykIxKvgm74nsI9VMTXVFUSYs2y6N77nbwq5euGzAXrteZDYtBz6m8UoG9QNi
	PomN0b5NLS32k18C3tA==
X-Received: from wmbe26.prod.google.com ([2002:a05:600c:591a:b0:47e:ddf0:fd00])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b26:b0:485:17a7:ba18 with SMTP id 5b1f17b1804b1-485198a6fd6mr52484545e9.30.1772660700447;
 Wed, 04 Mar 2026 13:45:00 -0800 (PST)
Date: Wed, 4 Mar 2026 21:44:59 +0000
In-Reply-To: <20260304-vmalloc-shrink-v2-1-28c291d60100@zohomail.in>
Mime-Version: 1.0
References: <20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in> <20260304-vmalloc-shrink-v2-1-28c291d60100@zohomail.in>
Message-ID: <aain23Jm2EFsuqDN@google.com>
Subject: Re: [PATCH v2 1/2] mm/vmalloc: extract vmalloc_free_pages() helper
 from vfree()
From: Alice Ryhl <aliceryhl@google.com>
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 2BB14140009
X-Stat-Signature: 5m8rzfou3xun1q6fhj5jufrqj78nitb3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772660701-590781
X-HE-Meta: U2FsdGVkX1/7n+21wp5ZFMq76ZaEa0H82Z5guvjJeH9pgk3M0KQ9k66QHiGwpLLZgpXL1oo4U2/lDtUasRrT20jiemOeHD6U0eCuENk+OlNorZhFKiVYUE76HfJ8L/LaYoGFj/qeoNp3kq5m+rhR19gi0NUs+NqLS5qg73mv1Os8mC1fh/iYQWGA8e/twhd07Rd88/A+BxI057yhurHtSX1lyry2JZ5HkmospWoOYOEqg26edffQGaBcq5RWWQ+ursBtnbqTHYVFJhw/dKtRuZND8Q6oSq5uPpStGiyV1zuRK++1jahflzKbWqzLVaj22IE+82WrpMODB3Vqx7uPBhLU3p+bjByGd8tSRDwMqoFPret1FjnnHjhVi9+XpJAIEVZIWbaH5DjXsEzvMrZUXnzydG8l4PjMymDdCGXgshgzCciYpBKfZruW0Gq5D0z9o0PDAcFxSUb2kuAFDucva/nu7u09c/jz8T1T0L1XcwMeUeGlDR0LeyYJGoU2S82PH987Hl49ETGQ2ja/+CPJ37ttScVgKUo6qYMuHqb6JyM/PQrDh19BRnJfTbH02dvpw0XV7NGJzHs/C8cvkzpJlgbVU/SC/tcmrIPEm7gEqD0WQA76YQ8H1YbTb3CLOpvGRtkxyT+F20Ygzx3Kw2EB4ZbtOo44HXYEvWZEZAKSZ5cLeC90cC9OCNSSGd0xOyy/1GENOol3eZYt5Tw813otiiXO9oEup+/+8kqK0hwhQVK+yOs22MDlnqd5IZ8Qr5dvXkE62YxcUqJHcOr64BkXdP7qMeWgLXgxF0nXw3HKrHgDW+FVmT3EPWUfx+cz3iolVUMizRh3KWpeZ8OsBxICnAHmD/DQnjwAXJQl7pQEArnwO7NCcL9/ZjmeZjTK9D35rUzL+ooY4T0vg/oYfHuGD2FfPd63QcC8xVUD6Nh9V+RIAzIAh5EqYtaKZrbc5hOF4rKCIEoJsCjNtfZECx9
 dm24q4Jp
 myiHbmaFKevEyAUKStsrM63VPLQm8zd8AKCeEHqhi5XBNd+g1iG294SlFPu5ZHN7qrbrLzkXpGX7QrBVGM6+O+HLflbi8wssHKwWzvPK0hBIZ6YyoA3SBa7LNnviil8hlLZOkLhLL0Ms00q9f21BS9iziuzkibZSlNowrM0xh8bFxIw0uZEPHAK//EuW99Fb7l1NC9tu0sMsl+hyqPAcWrd7nq8XehX6UmJy5Tm16HN9IsN0ylrgq9TTPxm1H5wu0xG+9IwpvNhu+/bz3V8yVYA2/sCAIq17NZCbekRFSZvS2OHyg5Cr41UN4tyOW8sMZi4ODjyqbNQJp0pYDvGDnvL+/AAxvwviTYjdjfkP4vI5QWN83SDdOH2wZirVgJhI01832/hGd0gLVo+tyzRjitIWTjRDj3xvLU/juA5bLxtWpcb3InwGsOedwz4yBqXMnx2VuTcgyeFY/FG25aVfSZ0A7PBB6d+GV0L12LZyPacvYv2WsBvleJGQFymeN4qXVFu8aEV+F3/5rEWryTZhVZ+/ajAU+9u6MJiH1MPygO4r/7n+DdY0y0hGjqaTbhMnvUzMNbJvSxiGzEQvWHYMdHwg3ycfp88qDsm/Xm7zMTqZZ3GtPYBBZKd0JrIDbEVjRsUrGJZ20BQjz80jXGP8Njd/BBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 08:23:15PM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> Extract the page-freeing loop and NR_VMALLOC stat accounting from
> vfree() into a reusable vmalloc_free_pages() helper. The helper operates
> on a range [start, end) of pages from a vm_struct, making it suitable
> for both full free (vfree) and partial free (upcoming vrealloc shrink).
> 
> No functional change.
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>

> -		/*
> -		 * High-order allocs for huge vmallocs are split, so
> -		 * can be freed as an array of order-0 allocations
> -		 */
> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);

Any reason this comment was dropped?

Alice

