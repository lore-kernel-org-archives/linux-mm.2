Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED4F10F92EC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 01:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0626A6B0092; Tue, 31 Mar 2026 21:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0398C6B0095; Tue, 31 Mar 2026 21:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6AAF6B0096; Tue, 31 Mar 2026 21:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2E1B6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:22:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F2428BB44
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:22:00 +0000 (UTC)
X-FDA: 84608235600.28.A4CCF73
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4EE248000C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:21:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i0C9hskY;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775006518;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bmhnUFXqeLwqLZtF5KspnNYogJH1UNf/6F3rO1eHco=;
	b=qqfwC6BB/1AQgB1jFeET32zYu+ORz/tUUnrveNy+sCIvP52K3pfy80VN5Ahce9R4HM66vq
	+t4uLL3gdlyPpp2gozZLa21gf0rH3oCu9Qy1vr6VjmHhX5bYmTgN04lI4U8NcfBvP6IbSO
	suvWYPHEPXHUftgVY+B6rdASbpKOwQc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i0C9hskY;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775006518; a=rsa-sha256;
	cv=none;
	b=HCIwtoONCfveIn0Ul+BlNjTFOR+bSxVmCbhHAZLWC1GdEWM0s7N5c8kZtj4vqng3tav8/8
	ACMa7Mv2+gqronpgnmhbdg8lDVBy1WN22jgR5gTwE0Dav864xQNSQz4yT6pwciqJ8U7gCA
	sRMnZUWGx0pTmAjORd4rH/t2e0rhBcc=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9bfcbaa81eso183446166b.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775006517; x=1775611317; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bmhnUFXqeLwqLZtF5KspnNYogJH1UNf/6F3rO1eHco=;
        b=i0C9hskYxn3B0hD/bM3T9pCT85Oke8wRNZtJ/TKg/xjyXxy20ijhTbfAfLE6kr69PE
         K74J3cz7Gd0qfVjfBOWxvnASwK6GajNdncOp6ALqTEScCKZp6tl9shrqgdem6kUfw/mv
         FwIh3oef1O3ZXvdlPhGVGH01DX6gbVyQOLvu7kUvId/hMoJbyVNro+LP4mSaMEQc6f9I
         +pGNvkAblcCDLGGkJtHsQ7O0e1cAX46sSL4x/s5ku5LhwtLF1tBxl2JwdEbT8OwYtdgm
         l3TtgZE8tAQ4euZRsHsDT6IdvM2ka6bb2PyWm+Ck71GJC8eitgufZkMa3YCWE4shaYlS
         aWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775006517; x=1775611317;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5bmhnUFXqeLwqLZtF5KspnNYogJH1UNf/6F3rO1eHco=;
        b=QTgU4JSyQhfJnHkR6CGWadXM+sjRnlGjUXEIhHsLfVE7rKyf8JmefM73t1Z/UrDTMD
         XVEyh/QM/CtSJgZaGo0EVwPnTxx+5w15i4lPNQryqWGs8bKaZ9ZJqd4s8IR77FuKqCux
         dB4FqJiS1x/q2ejDmBwK6mAVHvtrHliDUg+ZXiyIvgNRZKyYRCiXcUb/6a7PqjvOeg2b
         jQ7NFlE2z4D3PjO5LRxqVSFRzo5AwG8XNtNXgCtUqqrcF5tNl4TRXG8KNebFOPIT0X5D
         M6GN5BIUFzJedGmyBFbcUtPmyqg0yHxjZn7EhXyaprzvyWKWcyfr2ixMeR8DbPgoDakX
         0VBA==
X-Forwarded-Encrypted: i=1; AJvYcCVNDFI1OupOU6sGB7pHeDejR2VCQiTCBpsMBJCIABUWLis5Nw0NaRJ8zNPGukpBD2aZGdb1chz3hA==@kvack.org
X-Gm-Message-State: AOJu0YyfvRqxbRnq2pwTragpGkan0VUoK1D0j2+CcJRSUAkL2fFxtOic
	CbaIvT5PsFgXkZoH7M0alRuJvNDmzfwKxCxMsZj/j6Iskhou7nsANUWD
X-Gm-Gg: ATEYQzzTks5cFMdBWu603WXbE9De8/ohTUIxeCtOZ9GMIi8ugnR8156rzJ4CL2Nc0QH
	M+vMOG1YUFT/Gx3fSTXtFs6pZwMyFMuqj8JNQHwtyqkN4ALJfTzxOmHkZq/uJxrgu3GzvfEKRID
	kLls9YWUSXrVBuB502b9dZpbqmqa0sE1OWMBu/8k1XMK1x9rcHskbs1r1n2NHoPD2Nt/fHMNRKB
	cRTKn3OO9XvBj09nN3QKKnLyvBn+FHmcrVcQ0Yf4JIkVU5teQfMkO4q5Ofqx3sKJxiGN1b0MsIz
	9EjjUOhgXEkETKRdRodXxMyd/ac2HN/zuBhHMuQjXO3Unyy6n+sfIITZ7Smpn2exiA1R5Bcw3Ws
	qJiWU68OHYJXskkc1eH73JrmSgk/+0yVW2hHt+frIaHZlZJlg3F3/HrNrtcUVW37WnXsG0GXcKj
	CFp3rS03CG8LL5Fr5fqbKWX5peeQfo6vzD
X-Received: by 2002:a17:907:a688:b0:b98:549d:8367 with SMTP id a640c23a62f3a-b9c13902737mr106157066b.17.1775006516238;
        Tue, 31 Mar 2026 18:21:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9b7b225193sm464786366b.57.2026.03.31.18.21.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 31 Mar 2026 18:21:55 -0700 (PDT)
Date: Wed, 1 Apr 2026 01:21:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>, willy@infradead.org,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	michael.roth@amd.com, dev.jain@arm.com, vannapurve@google.com,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [RFC PATCH v3 0/2] Fix storing in XArray check_split tests
Message-ID: <20260401012153.leisn7umca64ltce@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <cover.1771831836.git.ackerleytng@google.com>
 <6ada27e1-8f85-4b85-8c25-bc9207b2624d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ada27e1-8f85-4b85-8c25-bc9207b2624d@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 4EE248000C
X-Stat-Signature: 55zj8eh8aqntetuiwwc4q8zhxf3qdzuh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775006518-946668
X-HE-Meta: U2FsdGVkX18pT5KxzdD/O8SLFBr4wsMI0w+17OAmTrhKL2qzzwXu6A10vRtnarY9vZhKBibV08Yc5JwOPuaSzMZe6js2XxYDyj+MZnaceKdxRXXYtwX7uweo6XUw7SyHi0DC9gYOyM+VNaLbfg9xRCJnMfuU2nIIp08KeQCZQ1iv0pEYQewSJb+BSpw89/Ro6CzqFQqZfOoRDb5XAnW7sOusaVpiDVDDGcfx8EmdKzw8saynwK+C0ITlRvUja7t90FzATs/Ht0LiSO7jI+Ag3s0S/EZV+ueSQdPtoImRwAPaswpbZ5HNSpYG3NB1NMoo8Rxe/B/mBkr1XIZI+DNhwRa/zZtt/q6hdouLYYCKr2yJGEST29Cqz07aCoAoPek0ysGyeU4kyD2L8VYzmPKDo02iJpPKO6mDDHj/3rgDuyq5RF7Pykj9PuWWVpIz20VH3+5m3G07gew0VbZUrSO4dczgE+tqAnIK/HWc1GlEoxjsxVQcRewSdHe5S9VF8VKS6BUigC8wu8yVZIfodx8RiDBQdoSt7I0SbLiVT3AYJ9AkP2eW3otfbHNLsQJp8OhWC0lrBk6gwcvBBAZ24Emhrtn09c6UA6Emh9fiIrmrQfar5JyuuNoDIJtVcP7oFgDnXxNGvYGUYjDspuJPeiQsj3O/o5RU5YReGfdWHFypvpoEHFi2vP7hvvqxWwmUOiE1gcRyWrlnZf9S0PQ+YpMJBnpVymPUx2sGtY6f+39mHgV08sBAJlOWknrfwvPUTcwEjQnZGQs7YZPeNKJPURM4LbbnCzlTM6bdeF0iAmomz0oBfdmVVPYs8bsxqDevg1Tahn+Z+UNUDAb+I3cLhSgD5cYW6CzGCq9YZNvWvC0/ttaTRf/5iO3zcvk4bZhRjSaG03hnLVuxLYKfeZU8EB5/Dv3Qmmdaku9Np7lXh/SqF693PSP9dYbcJxX9Cd1MaQXbZpeVKdpvmQ7nYLoVSeJ
 hLRajKu7
 9L4Vt97sX6yiXqVFK82mUrCsmIUZsglGL6yAuH/QHU2JadepAe8FBKbVoYTcgdqaQXdjTYa5IsLYUUA8Wx71SDNoAwUT9Tu6olZFtabQffHUYw/NNZWa9epKmrht+4dFld9VjmoK5I3cY/8sXxcCKY1AqCpeqzyUCXt0JIkfsQTIjSYxW1f1Tvdqf7j6oUxz2nu91gfkNA1f3SP8aZ95eHrKs7hnrNYtEFPqJazwbKv7vq4Oa8RSXFoz6I5RuGW3SJw/zckDapxVnmMKGZM5LjwYjZ9j9wmA255VyPNVH5mgmqwPgZXlfkfEF/cMhVU2uVI6gweMm9jtWg1XWnKyCFZDU+0qtztaDMz8o9hQjAmkjlLRZTDsd+/YXjjfWFxYjz/7g3Ikc3kiuWWg7USZgNKxQ2VzV2yjEZ7d1/5KxpTj09auC1DIkmvOSoV7P8r1LiqXuhog6svg0OHtPe+5VlKp0gx79E8z9nvAPSaqKs33utZo665IeFDCzgcoOhX/o3+YI4MxXWZtF0QDXwO/l8FoK60BidOtRauN5UT84yyxmbslNB1yGg6/3+n6YvU0cgrrXQJ6Tr7psJckfB9tc/E6BC8uzLCQGCLP7IkVqPd+ChzBDnoXfH8UrRVgtWqeNzs7dieHBSu98NLJO3qS2B+m6ANSgKQ7rMUjV2n1IQ5ZoBm0MNJECatdMJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 05:23:17PM +0100, David Hildenbrand (Arm) wrote:
>On 2/23/26 08:34, Ackerley Tng wrote:
>> Hi,
>> 

Hi,

Hope I can help here.

>> I hit an assertion while making some modifications to
>> lib/test_xarray.c [1] and I believe this is the fix.
>> 
>> In check_split, the tests split the XArray node and then store values
>> after the split to verify that splitting worked. While storing and
>> retrieval works as expected, the node's metadata, specifically
>> node->nr_values, is not updated correctly.
>> 
>> This led to the assertion being hit in [1], since the storing process
>> did not increment node->nr_values sufficiently, while the erasing
>> process assumed the fully-incremented node->nr_values state.
>> 
>> Would like to check my understanding on these:
>> 
>> 1. In the multi-index xarray world, is node->nr_values definitely the
>>    total number of values *and siblings* in the node?
>> 

I think so.

As the comment of struct xa_node says:

 * @nr_values is the count of every element in ->slots which is
 * either a value entry or a sibling of a value entry.

And I play with xas_store() and xas_split(), then dump the xarray, which shows
nr_values counts value and its siblings.

>> 2. IIUC xas_store() has significantly different behavior when entry is
>>    NULL vs non-NULL: when entry is NULL, xas_store() does not make
>>    assumptions on the number of siblings and erases all the way till
>>    the next non-sibling entry. This sounds fair to me, but it's also
>>    kind of surprising that it is differently handled when entry is
>>    non-NULL, where xas_store() respects xas->xa_sibs.
>> 

Agree with your.

	max = xas->xa_offset + xas->xa_sibs;

	if (entry) {                          // non-NULL entry
		if (offset == max)            // respect xa_sibs
			break;
		if (!xa_is_sibling(entry))
			entry = xa_mk_sibling(xas->xa_offset);
	} else {
		if (offset == XA_CHUNK_MASK)  // NULL entry, run all way down..
			break;
	}
	next = xa_entry_locked(xas->xa, node, ++offset);
	if (!xa_is_sibling(next)) {           // .. until a non-sibling entry
		if (!entry && (offset > max)) // then respect xa_sibs
			break;
		first = next;
	}

This does has difference.  Confused a little.

This is the reason why we see the nr_values is not updated as expected. When
xas_store() an order 0 non-NULL entry, it just iterate once. Then count the
difference as 1 instead of total counts it represents.

>> 3. If xas_store() is dependent on its caller to set up xas correctly
>>    (also sounds fair), then there are places where xas_store() is
>>    used, like replace_page_cache_folio() or
>>    migrate_huge_page_move_mapping(), where xas is set up assuming 0
>>    order pages. Are those buggy?

This is a good question.

When I look into these two places, I noticed the purpose here is to replace an
existing folio in pagecache with another folio. This means the old data and
new data are neither "value". So we don't expect nr_values would change.

One place we would store "value" into pagecache is swap, IIUC. Maybe we need
to take a look into that place.

The rule seems to be not mixture store "value" and "non-value" into xarray, it
is safe.

>
>Zi, do you have any familiarity with that code and could help?
>
>Thanks!
>
>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

