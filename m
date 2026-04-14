Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E2F1ED7B93
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771186B0088; Tue, 14 Apr 2026 05:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7493E6B0092; Tue, 14 Apr 2026 05:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686E56B0093; Tue, 14 Apr 2026 05:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57CB06B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:47:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C5328BAE2
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:47:18 +0000 (UTC)
X-FDA: 84656683356.11.A4A86B2
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1D985180007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:47:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ib+MF5g6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776160036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4CBGPNUZVh6VtntpItYJ/x6BwDqFr0ckEOccx/tIqk=;
	b=L7CBo81JvyZ2vsGFx7wJPJlhPn/dMX8ZoYULxKAabXf3tiV35dXNogL7wkogElrGSd9WOV
	MqEZH7HYnDcMWQgNWJ3VP4esHZ6GdSD1u+Kdo3zvgt8L4b8CzTmXZJjWhJYcvExRn0Jxwi
	HWjTbaik61+YFktCmVaW7SsI/vhqkRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776160036; a=rsa-sha256;
	cv=none;
	b=uCURBknowJyCbbRLB6sgCXv8FY9tBvtr0PLYEZ+q3yc4CixGfkzpYsxx8nNVuunANROrJ9
	XTCbtkX4O379F3fD/yb1vG8+QeUhwpao1d/5dWUoHAvP90Jpx0/D63YtRxALxenC7kfPHT
	j/48a2UNqv+eYP8zYQXNjBe6PiB+7rE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ib+MF5g6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43d77f6092eso1429116f8f.2
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 02:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776160034; x=1776764834; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+4CBGPNUZVh6VtntpItYJ/x6BwDqFr0ckEOccx/tIqk=;
        b=ib+MF5g6+tTbERWaySvZ5BNlSL+zEajb4+M2HDme8tKhxz/7nxiosxz0iZoLN1eDOe
         tHN5+gctAWOqTbJNbwBDjtu4RFxCA5y1a+3fBMKEgcjSWKvwReFt+0rDF/wnYqVA4FTd
         pBkmUTsphjQJN6Ry1p4cDValnzYW5o5Y9YlEDGKCrGsr9UdmyvbYmlcX7hoKcDalACmq
         Xw83DeoRwm1/sslqYFUQcej5Z6FM+QrU+WMCMVahnUsju+7IfCh/N5ds+d9VMg/WbPvj
         kArEV0s5r9cuNEVU4mNwG+ZTmp4nxliLUahoUMQVHnJJjgE74SDZZDqaPVhGX5gxN4//
         g0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776160034; x=1776764834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+4CBGPNUZVh6VtntpItYJ/x6BwDqFr0ckEOccx/tIqk=;
        b=FJp+Tex9v4801+c3B4H1Edxa2lQBgd/evxqqyGgkHGNPZgaAibZaMn+UxQYh4Bkxeq
         VrGcpvxStQ6bwNheX/SNwL6W2ILrZVqsa1I2tw+JaFIaHDZ6q0NeVcn4VEUK1M7qMv9s
         fQiQ1I+C9FimJAvm/MkvkwrwrkF2YWLqMSw/Y0+LQwe9T/FGKKXsPTcCKM8GoqhT3xzb
         CVYzNYTkGX8L86xqYULvHstKOO4AXJpPSf7FNeUkWAufdx0mT+Z5lYeg+1emw+YNMbdD
         FEgBhA9KP4FOJDJbJKvpOuuxE/sfk7wNg7ZxsiFl4PX4XzJj1fMnL3RV/6cuJ6T3iP/Z
         MTnA==
X-Forwarded-Encrypted: i=1; AFNElJ+u1XXm2Ibxa3RdiEiQ7n9Ftsc/YsUcWpiWkQnFPieFgqZ07/xEN3m8ECq60kG3rclNbmDLuULeaQ==@kvack.org
X-Gm-Message-State: AOJu0YzLULe13h6tvXeXPOWWQlNw9i9++T7VwQDtH9i2Jlng+mNShrAH
	XFy7LBv+mQFjOfe9zJ1z4+ijPs9qJQdf7O0wdIUGwPr0wXAaMPVAIjaBk8N0v6Pk
X-Gm-Gg: AeBDievcu6rFcvT+VUFApYoCUmI0MTG0Hhhyx8wOnSq5XuGmS17HQy87eLEYjpbtjZa
	+WvT0LQ9loOvU8bUmqGmVZXstFAVars6nKYXkT7WOCEYLsCWlydJRWVQdCrPCY2VdhJ6cfNn4Tn
	OHMigivlmZh8KzR9t98a75/wPfhdO6boaK0dVwxvSEiI/qkGpd4OQI6/vrLlKmF+5PrJgJQtTKp
	ChfE+94CEOMJiwGULeB43QETl/SyV3fKQP0i49+AlgXKnTGeSlhlnE1Tdw0fr8OIrUUYyAOaa9V
	BoSISa1Bv/E+cBZhs8onwo7vX86Od5WqLNfGZOIY6TgL2Ndpvig+yPfYiX42Fjm7BFko77YU9mB
	SicHkEiGpMrSypKd7MJFPLPLyeOFqn7U8AAcZvwHQwuHxKGPFforT8UJMcqWGjs6WbfU00G5pYc
	+biQKscGinkr8uAZ7JIY8F9s6mjlEPahupq3BWlGCenD2XBQhsWlMxFHXpJPOKx3sd
X-Received: by 2002:a05:6000:268a:b0:43d:7403:4b60 with SMTP id ffacd0b85a97d-43d74034c72mr14460452f8f.3.1776160034363;
        Tue, 14 Apr 2026 02:47:14 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63de2e4csm40900179f8f.2.2026.04.14.02.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 02:47:14 -0700 (PDT)
Date: Tue, 14 Apr 2026 10:47:12 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 shuah@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH] selftests/mm: Simplify byte pattern checking in
 mremap_test
Message-ID: <20260414104712.2b634741@pumpkin>
In-Reply-To: <134c372e-5c9e-493d-b954-d9954546beaf@kernel.org>
References: <20260410143031.148173-1-dev.jain@arm.com>
	<5297e0da-d8ec-49df-9b32-0d9f907588d6@kernel.org>
	<8b5544eb-5ec0-4c85-a2da-7a454fa606dc@arm.com>
	<134c372e-5c9e-493d-b954-d9954546beaf@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1D985180007
X-Stat-Signature: 5hwich45qojo5e4p5yfb5zteknpmntky
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776160035-762426
X-HE-Meta: U2FsdGVkX19gTmcvooWDYq0/sxSWjMKtH9AjuKFCJbjD9ftYvvOecAwwIHa/ReDidLIowJSitNmbyue2cUUdDcGLk0X6zQwKkpJZDdXkYVjhf9N+MBSygtmP/GQzGbS/uFUVUorzQP+x+eFl9/EUbMc+yn67SOY0l2DqnDyVYEovCBvX0oHzZX0qx32OQ33slHtUcDfL7JgfFtFZyq7tpyZuiOTXBvHRTMbdaW2mJe5gD9U9BZHA7thuNGYnfoYGYzBLq0w2xB4yfwmXOHNkw2qiYPeRJQdGCHRpmRMEac/YTpJw2tbZZkGer5dRwo8AAOgqS3j1XJ/z4wJViLcGiydeGqZgwJT471PuLut3MnvPm80Ck3IW6bbZibhwZrJTT2FJcVYAGUFqTw/8RcsPtXQq/gH8S27gVAxHjztrP8VN/yEAnBcBZb+etq+hmKmuTnOv3r+/Q+b6YDeqZSVJ3rhSY1Ln1NXxwRSkKZ0LdzIvX3deI1941jOcdQLPF66VvJC/0GjHo96PlCkxcMzvbgFZ/3NqkJYWVVIKqmwBbVkBclSiQiikEWis2depC1UunpXgcBfVJNF70fe2Hcz8LWpyv/pPk/08+BeMCadLleq09EtjAa+NXts9dreBgAWKX2fkfLawPvHOyo1ylooKjLu19xheWikYPCC1UEDEnHx4qGF+gtIXJKltBlVfD88+5M6WXUBsAJPBr5BpdqNiY4OT0CufAIvh+bvZqQBSOQLFx2th4MdYORIVdGL76tfJ0a32ShE54aMuJ4pEuRjt464ZtgjYwVlVzd+YnD4COqqEjsLSu5Y74Wzgnms/E6DUSLdHMYnXMJxC1NmBA+/DYDfRDU8QREQ+JVL7FmNzMLJPZbY9PVirXuovl4EMxmejZxYsz6p/5HMDY04P3PAyVcO5GwRCfB3cVZ417wlKbzKkzgcVKAEIw7xjQTIF9JlG1HBG3hkgvPdSrKR259B
 f8PB+nEI
 Py+/pQU1ISdCixisekOoo5ECcZA6pZx24SULNJsCoDqkaiHFqzMf7UNlN0ZHWYp+4dbGh2e69R7h/KzBCqpPd/5IHUtnwREZ/NHJzzSMh1HkjdOGMUrTb0sECwlK1iv8upFpzbwuCYGpkUBsaB15Q9nTeEF3JSm7xgoCxI4zXM7Kxx86vS0nmEQaxTPRAsSWzH764njTWSn1lGMvcIHuyyBJcAwCbKVfMcci/QrOXi+mn/eYyZOJcaH+lN7ev9pieakyIxtxy5DrBslhzbd8I6aZq1sMui3NuqoXzr2ZX6E3sWYnwVfQcKWE+vX6K8oK/WAFl1mPQg4pjOzXnvCsGP9CWSGh5VkdWF8A0T5cEaOjrAc7km3ShCSq3s/Yduq1vZTKnratsHuXg692XsiY/kSG3eXWBIo4nuoCcANtQK9MOJ42l2Wsfx41PXypDQ6FI+oWEliBSgBoED0jWIcC7jFptteRDLFpSfxwRk25zmkr8kHoffqe1bPfDMCo7XwjdW9nMkk/CxvaYvc86lDkJgcswq8BpYUPV72S6+ihkMQbfbtmbiI9mt7yRXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Apr 2026 10:01:57 +0200
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 4/14/26 07:09, Dev Jain wrote:
> > 
> > 
> > On 14/04/26 12:57 am, David Hildenbrand (Arm) wrote:  
> >> On 4/10/26 16:30, Dev Jain wrote:  
> >>> The original version of mremap_test (7df666253f26: "kselftests: vm: add
> >>> mremap tests") validated remapped contents byte-by-byte and printed a
> >>> mismatch index in case the bytes streams are not equal. That made
> >>> validation expensive in both cases: for "no mismatch" (the common case when
> >>> mremap is not buggy), it still walked all bytes in C; for "mismatch", it
> >>> broke out of the loop after printing the mismatch index.
> >>>
> >>> Later, my commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
> >>> execution time from minutes to seconds using chunkwise memcmp") tried to
> >>> optimize both cases by using chunk-wise memcmp() and only scanning bytes
> >>> within a range which has been determined by memcmp as mismatching.
> >>>
> >>> But get_sqrt() in that commit is buggy: `high = mid - 1` is applied
> >>> unconditionally. This makes the speed of checking the mismatch index
> >>> suboptimal.  
> >>
> >> So is that the only problem with 7033c6cc9620: the speed?  
> > 
> > Yes.
> > 
> > I'll explain the algorithm in 7033c6cc9620.
> > 
> > The problem statement is: given two buffers of equal length n, find the
> > first mismatch index.
> > 
> > Algorithm: Divide the buffers into sqrt(n) chunks. Do a memcmp() over
> > each chunk. If all of them succeed, the buffers are equal, giving the
> > result in O(sqrt(n)) * t, where t = time taken by memcmp().
> > 
> > Otherwise, worst case is that we find the mismatch in the last chunk.
> > Now brute-force iterate this chunk to find the mismatch. Since chunk
> > size is sqrt(n), complexity is again
> > sqrt(n) * t + sqrt(n) = O(sqrt(n)) * t.
> > 
> > So if get_sqrt() computes a wrong square root, we lose this time
> > complexity.  
> 
> Ah, thanks for clarifying.
> 
> > 
> > Maybe there is an optimal value of x = #number of chunks of the buffer,
> > which may not be sqrt(n).
> > 
> > But given the information we have, a CS course on algorithms will
> > say this is one of the optimal ways to do it.
> >   
> >>  
> >>>
> >>> The mismatch index does not provide useful debugging value here: if
> >>> validation fails, we know mremap behavior is wrong, and the specific byte
> >>> offset does not make root-causing easier.  
> >>
> >> Fully agreed.
> >>  
> >>>
> >>> So instead of fixing get_sqrt(), bite the bullet, drop mismatch index
> >>> scanning and just compare the two byte streams with memcmp().  
> >>
> >> How does this affect the execution time of the test?  
> > 
> > I just checked with ./mremap_test -t 0, the variance is very high on my
> > system.
> > 
> > In the common case of the test passing:
> > 
> > before patch, there are multiple sub-length calls to memcmp.
> > after patch, there is a single full-length call to memcmp.
> > 
> > So the time should reduce but may not be very distinguishable.  
> 
> Okay, so doesn't matter. I agree that we should simplify all that.
> 
> The exact index is irrelevant. Whoever wants to debug the test failure
> could modify the test to find that out. It's one of the tests we don't
> really expect to fail (often).
> 
> >   
> >>  
> >>>
> >>> Reported-by: Sarthak Sharma <sarthak.sharma@arm.com>
> >>> Signed-off-by: Dev Jain <dev.jain@arm.com>  
> >>
> >> Fixes: 7033c6cc9620 ("selftests/mm: mremap_test: optimize execution time
> >> from minutes to seconds using chunkwise memcmp")
> >>
> >> ?  
> > 
> > Not needed. 7033c6cc9620 does not create any incorrectness in the checking
> > of mismatch index.  
> 
> Yes, agreed.
> 
> 
> I would suggest to rewrite/simplify/clarify the patch description, not
> talking about "buggy" etc, focusing on the simplification.
> 
> "
> The original version of mremap_test (7df666253f26: "kselftests: vm: add
> mremap tests") validated remapped contents byte-by-byte and printed a
> mismatch index in case the bytes streams didn't match. That was rather
> inefficient, especially also if the test passed.
> 
> Later, commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
> execution time from minutes to seconds using chunkwise memcmp") used
> memcmp() on bigger chunks, to fallback to byte-wise scanning to detect
> the problematic index only if it discovered a problem.
> 
> However, the implementation is overly complicated (e.g., get_sqrt() is
> currently not optimal) and we don't really have to report the exact
> index: whoever debugs the failing test can figure that out.
> 
> Let's simplify by just comparing both byte streams with memcmp() and not
> detecting the exact failed index.
> "

ISTM that if you get a failure it doesn't really matter how long a
second scan takes.
So a simple byte loop that reports the offset and data of the first
error and counts the number of errors is more than enough.

	David



