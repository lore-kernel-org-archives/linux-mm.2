Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88E43C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 12:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F9A6B032C; Sun, 16 Aug 2026 08:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250486B0350; Sun, 16 Aug 2026 08:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167A36B0354; Sun, 16 Aug 2026 08:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDBF66B032C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 08:54:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86F70A2EAC
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 12:54:16 +0000 (UTC)
X-FDA: 85107125712.10.6A316B1
Received: from mta1.migadu.com (out-70.mta1.migadu.com [95.215.58.70])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11F81A0008
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 12:54:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fFaDJhmz;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.70 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786884854;
	b=F/9T78OaArJGOSrnPdibUIv1IOuTXxEgS418k4uqZbcMGLCvlfnCcve3njYZdlkISZjdWY
	DwvhOtEpF7t31nvGj6+ME4Ml8fU49HimFTVxFGfu8lR3ZXOHdIMrosb1BK6tLM3I2TUWsp
	eX+hLj1xLpxh1N8tNx5UFW1MlzBniUc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fFaDJhmz;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.70 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786884854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0ecmulvwAW6hOU2et5uEcTBFNDH36ebOvhxW4X+wLk=;
	b=3u0jePSX1PjAXnRuYt/ymnO/5UXJndjvH+0ikIHGM2zledSS/moP9tvm48z9A5vWJ0arnX
	M7gPRl7hJHCAmwDEOFG2KdHe/g8Kp9P5o35n5EqkTmxHdcatm7hj0kXlvxUZu17h/tONuw
	hWzaxgP6h8hRCifpu9PKN88buxA81eQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=N0ecmulvwAW6hOU2et5uEcTBFNDH36ebOvhxW4X+wLk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786884848; v=1; x=1787489648;
 b=fFaDJhmznbsaa9bjEHdOnIgNxjs2SZ1wpgqDEv8w2UbO47RexC/nYXbdFJkh0lB8ZF9dbxxX
 VdlzpDuFVXySohE4yU3rkwxsr2gjB3Hf+dPJdyoWwBAuzAwsdADkSmtcFNHoR/uVv8nmFUwV6+O
 pLHvDJx0BV/TTl5aLQj++pDQ=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id f39b70a9d02f047e;
	Sun, 16 Aug 2026 12:53:58 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	yang.lee@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cuiyunhui@bytedance.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/gup_test: keep longterm pin state per file
Date: Sun, 16 Aug 2026 20:53:44 +0800
Message-Id: <20260816125344.9813-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260810-gup_test_data-v1-1-fb1d41be5bb4@kernel.org>
References: <20260810-gup_test_data-v1-1-fb1d41be5bb4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 11F81A0008
X-Stat-Signature: 73be3j9m9395mkfau4gwgd68bwdz6o7u
X-HE-Tag: 1786884852-52421
X-HE-Meta: U2FsdGVkX18YfyuWzHKwSnKx3QnELXDX01URJPp7r8BA0bnFMgWUZ2pYStVYtj34860G2qtMvg35nImGr6efpgsKMi4sHGZCCBl4s7qfAERjltNBdXfl9kVJAzaiWLTB5BSDdehdvWyqWcAaXR1GU8J/K/9IORk40utrYn92dMPkt7T3ArubPYHUjCo8VVH720qUAD+qwfviuUkNJetptWzKQ5mIWJdAUyID2HeBISxfRUtHUKk5WP4UTRfLX5mAN2Odjwzq8TFptOhFeh24atd2ii5xRuLP1Z0F7/tllRSxcD2tP6PXpM+QRstislwB31i/h0UG/9O0UlqRNMts7LBTl68QN5Ku5L8DWdjtB9jSdhhk6yLQDVHGrJMzI4YBln0LwcW6stcIb8cvh0wYaMWHXeTxfII1KtvaZU2bjyKoW+HhYB/0BSttYQx8Zb5/3Ak916SYM3iJnf4Y/btr7+vR0Aj9mRH6oC5LW/BfrRCEQoKH1Btvs7EM/RvBP83VKWPHGytqjlA+Ie2PxErrk4BaqyvWDOsZZEYlitcVtDEkQxOlKgxdYQ224bT+ew8VdWiWRxcJsF4ia1o/oNEODAFnm5qyENsozNPLOsy4l/iwbOjzTaIJ3jWIOsW0y2WKW9zgNV/+pzWOjPti+qr8N9XEDpDqy1f6XE8x+MUH8PiQI29RTIWGNaMHkGnqZ7naz3FLrXcvJdfe4OJiEJ9b/CW12KjCbi0pu1jqMiRxYFHQMakV4bz4SVs7W818YvwLAYzjf1EP/vy+GzMImgUBh+pxEnw/KZ442oaV0vnL7nUlx22BNBUaa6LQ9IRRx18tfc9gjrfaYIvVzJdr+BxlLJFHbczgGA5Gs8N0HgBO/FnQqX6ADE9xMZ+E7AJFsxerrtWq/Q+YCyB9ZYXN6i8IF9V+vx+XF9w7VQYwipjz/xpas1p7fTmNUunTu2DCScTUQf7/xrgmKsjMvIQv84u
 htxSZEz0
 OigI/r1A443f9ioU+W5GXa+MstJ+/6EOjuJKJLJheSnxgepQtfV3I0piYkNd7Ap0uOWm6v/ydrS1zFaRzaCPD3NM8uMRpvwgOONfjO+udgBoNtnijLAk1NzZVzMPOD+KN4Du3BA31zIxcoGI6KPJQIgvyUPir5SY3JAwfxKyX2D9gXEvM0R+8bxgp1C72vFPG8lAYhoUqzBtjYFlCcAWUhPKWd/tTgekubiAQGcnFXVfSILMzqmghQqrs0G3Jys89uMfWK8SxB6QitS2qwz8ind+iCSHI9166RAjbpJhWZuaaWJR+T+ZWAL9ANjZAafY+SMvyybvr8hLi5nPaG2uyp+AYyC0FsHXMWysrZ+Vxc4A91q0RnJxRfcEWmGjV+KrVERnK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Aug 10, 2026 at 01:31:14PM +0200, David Hildenbrand (Arm) wrote:
>The pin longterm test currently stores its data globally, shared among
>multiple concurrent users of the interface (multiple open file
>descriptors -> multiple "struct file"'s). That makes
>the gup_test interface problematic to use concurrently: two users, such
>as concurrent selftest runs, can interfere with the same longterm
>pin state.
>
>While this has not been observed as a problem so far in practice, let's
>just handle it cleanly. There could be a way to trigger selftest
>failures by e.g., running the cow.c and gup_longerm.c selftests
>concurrently, but we usually run them sequentially. Let's add a "Fixes"
>tag to be safe, but not need to CC stable.
>
>Fixes: c77369b437f9 ("mm/gup_test: start/stop/read functionality for PIN LONGTERM test")
>Reported-by: yunhui cui <cuiyunhui@bytedance.com>
>Closes: https://lore.kernel.org/r/20260608025043.88087-1-cuiyunhui@bytedance.com
>Tested-by: Yunhui Cui <cuiyunhui@bytedance.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Gave it a spin on x86_64 QEMU. All good, shared-state mess is gone :)

Tested-by: Lance Yang <lance.yang@linux.dev>

