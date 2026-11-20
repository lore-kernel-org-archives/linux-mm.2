Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11BC606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IN7xfZxY
Received: by kanga.kvack.org (Postfix)
	id C53FC6B05E9; Fri, 20 Nov 2026 03:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2BBC6B05EB; Fri, 20 Nov 2026 03:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4FF6B05EC; Fri, 20 Nov 2026 03:38:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD416B05E9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:38:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23A6F160E29
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:38:46 +0000 (UTC)
X-FDA: 85454846652.02.0013A02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 44314A0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:38:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IN7xfZxY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795163924;
	b=ym23VWjwerCAHOihy4sf0mM6yTdNUOihg5e1YF5nl2zuqlz8kSb7E8bRCnYuktv7Eg5MlM
	1csGU6QMA/uWGE1UFtg1KC5oIuIN/gR+6oWF87jwu0bWFn1mYGmzBTXU4OOGrib9pe4nck
	z24pf7WKnjOT2u1LxnDS/qX4I5ET8HA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795163924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/gr63NDQYXLIZ+49BGD0eSjl21BN1D6Jr2bHaDtoZE=;
	b=Z/p4fRq+LDUUwTa9suG/XCuVzFOgg7eKRM+KDIiGlSlKhKFU/qRWVsnu9tJcJQrZxynz2k
	jAXVKckvOM5mzCsrdtTQxDlNfDMTHpS0rfohtVK1fYAarJRI5mDzN2r+Ja8iXYeiInVSOo
	C8VUHKJO0AGcL8e/2W7nbyv6avthDH8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IN7xfZxY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3956345EC8;
	Fri, 20 Nov 2026 08:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF6B1F000C6;
	Fri, 20 Nov 2026 08:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795163923;
	bh=h/gr63NDQYXLIZ+49BGD0eSjl21BN1D6Jr2bHaDtoZE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IN7xfZxYM7VZTd63vDaEyaPde1kWVU9sZKvRx6OcYGVAS2uqsLW/DHVo5hiwihqHc
	 MyCPWPo37Aqbk8VbruxIijn8QZa9N/VsSIbHaSL1vVWDs/Ldhzec6eSilUvOH+hnmq
	 OD54nyqcUMmvOFcWm+Px42z/wy03wFGwTuC2zcKJyTMGiBluN6ofFfJgh/O/zMxVM6
	 X0mKexouooArQNuFO3X5DqQu7V4z05HjCU1gccjEmrI1N2IWLmO+zasiv4bBQTpgMG
	 lK4s/q52tmMA6YbsK+f9wzwZXehUK9zepDkOI0i/Tykx8GxFlmcIy+A7CEZFEl0ukt
	 GvFl4kGVIXOug==
Message-ID: <da01ae71-8b99-42b3-9a46-d7e39c1eb981@kernel.org>
Date: Fri, 20 Nov 2026 09:38:36 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: skip temporary folio allocation for anonymous UFFD
 missing faults
To: Avi <thnkslprpt@gmail.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, akpm@linux-foundation.org,
 rppt@kernel.org, peterx@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, liam@infradead.org, mhocko@suse.com,
 surenb@google.com, vbabka@kernel.org
References: <20261119180015.933433-1-thnkslprpt@gmail.com>
 <av88TW3GQRvXJDwA@gremlin>
 <CA+jvY9E3XD5mJZ7V-+6HFxEkY1FHNGom42F-nxMZNGtOy9POqA@mail.gmail.com>
 <8e56f690-7031-4a57-abdd-a02c1c94782a@kernel.org>
 <CA+jvY9HQp6iDPGDTuVqrQNnw0ENDDq46_AwZqzcjXNcyFWqPsA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+jvY9HQp6iDPGDTuVqrQNnw0ENDDq46_AwZqzcjXNcyFWqPsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44314A0003
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: tosx38aj8ut8wyxppcdjy95z799apown
X-Rspam-User:
X-HE-Tag: 1795163924-877501
X-HE-Meta: U2FsdGVkX1817goGFONoBP+ZkquMMrVJC3YidsVXOjDexgXDPV4KyFbkStCby3l37niJwTp7N9LbjcBnM/1g55RBQlCkel0n4IiWdosnGzzgg61WOTCsC0DA5xe/0CsYM63G2YaHhwQwxpsz2NiBoZLv55ZOBOW9w0U/1WwYtr/PU0MXyYf+hQpKfcOA3vsZ4JuuaHir7QUJwECx+SAfWmbKTvzAOadNiX0/kz4cixTgg3wVJ0Rudinj7Tq5knKQZitArLbYQd2zis2dxjkuHJfPf8qglCxIkrICVsB+3ZRCtO3m3+VJPW4UWxIGLtl+k3AoAfhR8lUyZpXa4YjhgkAX8kdlcwdTqShbPEMKDtpp2YDzxrKu+rrlTTa9SlGNK8qO02AWQeZrh8yCJmOG+NyrUwTbcehqGoUGY5X3eqTw7XCYBSglzsh51xMqeRlyp8snFpYThCq7sniVPkv5C6RFJ8qqw6ANk0mUZdMzYd84+u4M+pwyDuiYI4fzdvS9EX/UdwJ+OBFOD9Zu2QAXNpFddEEbdnGQCZvEmr745L5uDAUzgZ7bXdg3dfu7MunTfWhygL9Aymcjpl0EU8YvJwYQTBP6Wuzs/IjdwZKXX75eEbRTRzZWxjn79XO6bCBV9Y/4PkcPwDo4HGl2HEnMWnI5uKk96/L5TbKKDJ57oKou9OvBLpBTiZl6gaJsl/U/frU4PnATXgn5IWAbGR1iHgFjrCxsl5fHUhZEBLA/rgzpYi+a/ZN4NbNvt5oiL27Tzts47RTg1xw6DCJ91JIclYR4TaQrA6hiqjAXaq0jRIGEtWZGLqoaQf9kROdvFYEIX4RKBV1SYIDEDAJSCgnO5kQI5FP0dHHCisUAvdo0+ZaCFhIU0pSk2hgAI13EPRkgrzqWsEuQd9cOTxxeWbT9uWREigzzFARCezwFh8N6H9v2r5v8YZThylujo8VPoRZHjXhLqTMXOjUtRpeJwfD
 fLnWwLqu
 8l9PvtMOZAmfkEYMaEOcbwK0BtVcCce97pTRk+XIpFQz/iIuzu4FIwxDcCHeU07pYjV86Ve4NEfjii6m7eBGFHSSTIGaDHOMHE+hzFetoGIu4iISdwXKfdk9EUe+dK1h5FQS/nwvwpWUg/hyexmbUpARLwJdrzeEQuomMYwQs7P6sUOvSGh72wdj95JI0ANmhRbFw2WPe3PjkAewKg2aQ+m9Rov6dW0Q7kLIXrGvayl4glcO503zW+BROR2/Or1V7u18NRjgXvHfkcB7LRNgmfGQM2TGrMvQs0QQH611M8IoaFbiQtE0rpqDqnXZndnhGYZUcwqSVjtrnBB5agLpphsuqo65Jv+0JkROB23avsFR9XKh5ci6u5fWWHH1XjRjLLaRXhXO4TaQeZQ1wPiNt3BFPqQdOu1CuFfiAtiBM6vfGO/YvvEkz3ThGq2Vq4P++VU6o9gUWMQZzR4Q+3IvLung9b6pBGMfvwTvslR79h37FKwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 05:20, Avi wrote:
> Hi David - the real motivation is very simple - avoiding the wasted
> allocation (if possible).
> That's it.

Just to clarify: we are all right now completely under water with fixes.

Optimizations "because we can" are not heplful. They cause more stress on
maintainers and reviewers without possibly benefiting anybody in practice.

But that's nothing new: we always required a good motivation in order to spend
our precious time on proposed changes. Because maintainer+reviewer time was
always a limiting factor.

While your changes might optimize some uffd workloads, they make the kernel code
more complicated.

"Because we can" is not sufficient motivation to do that.

IOW, if you don't actively run into a problem, there is not actually something
broken, or you have a real use case that needs solving in core-kernel code,
changes are high that your submissions will be dismissed.

Because we simply don't have the capacity to engage with that, sorry.

-- 
Cheers,

David

