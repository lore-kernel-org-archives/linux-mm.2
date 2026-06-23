Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1A68CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 12:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCCF16B0096; Tue, 23 Jun 2026 08:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E0C6B0098; Tue, 23 Jun 2026 08:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94B16B0099; Tue, 23 Jun 2026 08:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C72A6B0096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:59:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 151501665F0
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:59:21 +0000 (UTC)
X-FDA: 84911183322.23.B2A6361
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf14.hostedemail.com (Postfix) with ESMTP id 67EBF100003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:59:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=hkbgjibe;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf14.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782219559;
	b=JbZi0aVqD/+A7SF8iPNotIGfVwQs6bgrFo5tsWXqbtmy366Y5eMZM/A1sxIQx2WFedJnOS
	SAO/92RURZ33/WjK5U8eBpN2+LNL89H7KPUs7KN9WdD9Tv5l1F7ccrfUjP/GM/5/m/kHiU
	BwG4EjxdTpbXbOw07TQSEvh1JL5XqEQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782219559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jR+bgp1QNQwrtA8EnhSJtdkBX/6Uhu5H3x2EB5CaJSs=;
	b=jStGiHGyjkAY4XtfYE2n2rcAbWm4cKOMO6HasrGb+rwkg3SpfFiMpl+UGpYJxLyX9KZCok
	b+9qohgIW2z+TeSVKgmOWHLSrtSy7OLC/uSIddqcLjvcRc1BX7gg9A3Fm93YEoXKwHgVRm
	UXbb9p1+pLJ4RBEfYNVhPDQWzccWHVM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=hkbgjibe;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf14.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net B7A0D41591
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1782219557; bh=jR+bgp1QNQwrtA8EnhSJtdkBX/6Uhu5H3x2EB5CaJSs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=hkbgjibeCaMtqcYoWH7ujj+yPJPBBpkEV6GEDKVJMmBDahmE7VZHqcVbF8EWP1+9U
	 Jw+v6N4uXGXU58VqKkqYj6b4DIyPdcQLZrlupTioWMMQiY+OTX2cXCIJAIsoT8IAOp
	 OgfKTovKnFJ5a/6tf8qdZZcrp+r8hb+1S+rWDE94zVm4iXNIfQmL9BTDxF9iiaAFZo
	 9w+l2/fHHxzC/y69uqmZwfx+OLD5oCtHIcVZ2anBMnGnOYTpzK/YbabmyriPX0Xv06
	 x6ECIzzbyMucMIDdsvTzFezUZRZL7/gRd38XziB9aaZYokMi6KhYeLlny9gdgjvHKI
	 UToky2gVa+lJg==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id B7A0D41591;
	Tue, 23 Jun 2026 12:59:17 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <skhan@linuxfoundation.org>, Matthew Wilcox <willy@infradead.org>,
 Harry Yoo <harry@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs/mm: clarify that we are not looking for LLM
 generated content
In-Reply-To: <d421c081-8686-4d46-8452-e543401b0503@kernel.org>
References: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
 <d421c081-8686-4d46-8452-e543401b0503@kernel.org>
Date: Tue, 23 Jun 2026 06:59:16 -0600
Message-ID: <87wlvpct0b.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67EBF100003
X-Rspam-User: 
X-Stat-Signature: utc3gdasc6n35bdk6wt4gkqnaimjuy7t
X-HE-Tag: 1782219559-767872
X-HE-Meta: U2FsdGVkX1/AMUKZoKhEdyGhn4RPxt8Um3yrIehLbRvkX8ChdX5C4H9Qd1ZooEJSnv+7hzcRn6CBN24SGE3x3U3RXLW5qUFpU5fV6b+M2QwAFrJtNVfeBODzavsF1w6GK41g7bo+G5/SXheqHmtRbOraJ0jyyHAdWNlGLUbxK4PuCjUHaLV7uXFcScW6M0NGya3WvFrJlNLaBZJzfeyYuzUsyi0ArDhrBSdtM9CB2IsQB6617cQdLrXS90u2RXHxQ34rWgikRLGtJRzVQFCUSV/HYVV8PclymeJD6RcCzOSn4qJax8f0boYcke4uchbCEBrxCe1ZM95GFFHYVCPMqJbSorqFBWxRsrgUyA2QZOFxGllcK377Jo+0qh/DfIFrX4GFLXxbmfyYZYTDEQkzof8lsg2/gthgGInA680Z5VMCIAwOdHfPbJO9D5T99JJjmWB+PaXWnqKga31hEUoTK6tkxiljs+m+aFFlR8xzrhoxRjT2coHgSWw/conwwiHs70nMVX+LKrDXI6Bv1oOtRKgv+4SOILSehWhBzZGmZ/kahDrLo9DzD9D6KFWkVRMV0d/21xc4aMNI9qzYYe1r5XEsFeWxURcFwJoQBk6jz3ZJ4TdsBZKx6HgrXkjlOaCunWIuK5BYak9cN1s2QJ+WW02WVECfzuXFrUwCTeOiMS+qx6+5kXPX5kkNf2arldko2p6/7VA5vNroiTIL4aHF/0wNgiRNSpaqL6TKJUwDePJGFYY2QdkRJFOmVkTbwZqeF02Cgauegf29I+OY7I7ZedpMZQwgzLOQ8qQ01NPIic1t/WFnvf6ivZh7VSmVt4VmVfwrYUOKIcO3CuDoMwEiWtx+XmE+7lNO1obmo39KJr7pDugGJOs+cdw+Zx4oiCXv1dX493s25A6+UsMO7jOb9DKfRHdkHz8wrB7rkmQV2sw3R6hloUE9YbT0h4Mg5TuExBN4LHNLxc15faco8Vt
 FGxmpVo1
 sQjzgYnY/NHnwClYVO6HDYF3A57oVkWFDyMth9oqB8cxz3Qp9NW9Zoly6/xH8bDB5K8wk1FuQuK3s7rr9Zh7RPy4/lq+zDZDFzqk77ndkhvO/z2l0wa+e264/9hGvCTADtv3K9gqLZ4PTc6GzqsfO36RRBY3jez96ZUHG6HbTuTMF/sqiTWihXxjJocMjpsWH2JrFXTI0P35iapnJi1n+u8B9njkvUzcw83i8w7QUqtgOij6TrrZq+DqAXorjCu3IE0irvrxj+X5S+tQ5FN71yAmCYHFXFry8vawUfUYxQBsSrSs7aEr25eg28+x9qrZdoBA9bpWM7sa4C4Qdksy9VsXl95Ual6PNATkavX/MEwJcDH/Pnik1l/HkTgXbGX+UhHx+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 4/20/26 23:03, David Hildenbrand (Arm) wrote:
>> Let's make it clear that we are not looking for LLM generated content
>> from contributors not familiar with the details of MM, as it shifts the
>> real work onto reviewers.
>> 
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  Documentation/mm/index.rst | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>> 
>> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
>> index 7aa2a8886908..13a79f5d092c 100644
>> --- a/Documentation/mm/index.rst
>> +++ b/Documentation/mm/index.rst
>> @@ -7,6 +7,19 @@ of Linux.  If you are looking for advice on simply allocating memory,
>>  see the :ref:`memory_allocation`.  For controlling and tuning guides,
>>  see the :doc:`admin guide <../admin-guide/mm/index>`.
>>  
>> +.. note::
>> +
>> +  Unfortunately, parts of this guide are still incomplete or missing.
>> +  While we appreciate contributions, documentation in this area is hard
>> +  to get right and requires a lot of attention to detail.  New contributors
>> +  should reach out to the relevant maintainers early.
>> +
>> +  This guide is expected to reflect reality, which requires contributors
>> +  to have a detailed understanding.  Documentation generated with LLMs
>> +  by contributors unfamiliar with these details shifts the real work onto
>> +  reviewers, which is why such contributions will be rejected without
>> +  further comment.
>> +
>>  .. toctree::
>>     :maxdepth: 1
>>  
>> 
>> ---
>> base-commit: da6b5aae84beb0917ecb0c9fbc71169d145397ff
>> change-id: 20260420-llmdoc-21bf5fadbd6f
>> 
>> Best regards,
>
> I assume this was not picked up yet? (via documentation or mm tree?)

I had figured Andrew would grab it; I can certainly do so if you'd like.

jon

