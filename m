Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97FBFC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F5A06B0093; Wed,  9 Sep 2026 09:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980316B0095; Wed,  9 Sep 2026 09:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8965A6B0096; Wed,  9 Sep 2026 09:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68B6C6B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:02:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84F431401F4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:02:38 +0000 (UTC)
X-FDA: 85194237996.18.33BD33F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C693540004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:02:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pd31kYr0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pd31kYr0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788958956;
	b=5TbgLtK2XaI7gz6HL7dUl90PHd10jhpOc3fwt14Gmeg1kcaTtN15QOm6ODZkmHzc0BqURW
	qZGADM5Zbex7A/Y+ZgCRCahGEIneosb1yxPtST59wcn4XZWJJz+0jbrIu6zDy46lPpA8t5
	V9ptxLOJMq+sf5K9AVSybeBl2yN8I0E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788958956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAy/mkbUGJKMDjd8R3bx0JO7rOlpjc9D+pq6To0oPS0=;
	b=vYSsuLOK4Anb4shpYnDntcBw6J4StuhoiIC9Vde/E9lD6XdGrCWsf5OVOsJXqROYJLsOFF
	l+bc9vBJ4f1lpwRKjTxCgocsN14vIDocrXzw14M9viciLSdGztJ6+YekA4yUeFvGycNHVg
	4LD8lr19VSm7VzFfFD1r7HniB5Gtaek=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10C784148C;
	Wed,  9 Sep 2026 13:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECE81F00A3A;
	Wed,  9 Sep 2026 13:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788958954;
	bh=EAy/mkbUGJKMDjd8R3bx0JO7rOlpjc9D+pq6To0oPS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pd31kYr0PkqflrEwx/4JHgC4MY82oX+TIF43RfbJonEJVafvRH82alDM1r9w7pU/k
	 6OB4w8/uXGGUZ4vfVdwDstAsYSm8FdbyeQGD/ekrdhto3opoeZTAFo0NbqY1OPwBIV
	 Fjv5r/uLmTfg4ARWJQTPDOqy6ZAPpplAHAQ4fJl9ldeCIBF+3Vqky1Em8n4b1R+FQK
	 CWLoNjMhJJIthFcrLL3KLuhWqpwk7kGCx1P2DpPZwzN823CY1z23V64KUCj719ci1j
	 1LCBQNkWn+oN41rxCbY8lBGOM7RSMOv8kz02q4a7vx7VuNTIhnT2oH7QhSLQYksnCX
	 FnbnzO2Aw0sQQ==
Date: Wed, 9 Sep 2026 14:02:32 +0100
From: Harry Yoo <harry@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 1/3] mm: make mempool_alloc_from_pool() return bool
Message-ID: <aqFXHT546O-ay4W6@thinkstation>
References: <20260806221031.79050-1-ebiggers@kernel.org>
 <20260806221031.79050-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806221031.79050-2-ebiggers@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: C693540004
X-Stat-Signature: 9mw9rj1znwasszn7jud5ctenr8shjoej
X-Rspamd-Server: rspam01
X-HE-Tag: 1788958956-945158
X-HE-Meta: U2FsdGVkX1+uz50wQn8YMQaG4JcR5qwG772D3bCTa2bstTAGkwsaJBGatUmS+ZJTXtncxfaHxbpb/2KK3k021tjbq13Q13dqqnqCGPAXPU+VL29ZLW+6olpAB9MseV33dM4PSoAc7TjsxebpKohYN4QSYzqc8GKLyTK8i11jlGW+q1mT3n/Wd51qQG8HrOWDcGQ9PzvW49pm7I8cpSfuU6EEbY7MtkEUrk7OsI4BADqRJ5SXbNBRY5x6dtL3XYbK8Vc+G+OyAwPyhl9O8wB47lzA85PcSW2TqFJ9iQLFa3NUg0GEvhXhA6VcMYdBhLOEbmat2ZOQJQ33KxB7VNIS6l+p2lbnr9ePaze2/GK9Rplfl7whrx+9fsoLhR6tvjKNZN4lF/yG8UDSIui2S2yTIxa1y05PlwHQZSdFv3IMx8LueeNivGpMfrRHQOThgJuDqMEZ/NkmCNOSTG2QMK2bpbhO3lUIAa83N9bxj/Yl8lpc07SdEpvqeqdIS/sEsBdBWozSWkjEWITPGVZYP5q6sUGTfNUDuPYR2VfU4UvxGJsGDDPngwxOBeC1HzRZgL5RlwOj9o+d2n8i/E29eOVg8zTx+KD0gQtlcthtR30l6YQoQqmskzdzmEToHEWsfHqx0LTNma7geQyLFS/r4/HPt0aV2pcHHPtzIV9PvsuiNz1zyUDmgJlV3DrEiq/2pojqERYt691cVH7/skd2AM3kZMoxREeDhAZBrjomFmIKKB3TpB9DnJI3dwhGwMat4UMkZG+fAyNjC8iAdY1l9mhSFZTD8qFp+yMjyb93Jk8vOjRBdj5DGPhYwRxJdjJNaBCGE5dtv+ZcHhwDgAnqt1K7wtQPiC8v99NroBY9L+V7P9o7BZeCMMdt7uPRZ9F0qt84q5DbOoKrKHhPXjQU5lQaJO/MSMGv92gEkds21hJqQF1Wbv9MibNvDzY6NwbvitT0f/GZPNUZS+PUBOSL2m6
 ZlMpG7vR
 aRw9NOyJYx2p+jnFN3RCN86uo2b+VrFwhtvQ9Vhb8VLdkd+cGga5O/JhrY8WGtPpVwQpR1CXhqA1h3sW1rb4fI4JqEFNkbwe4TmDn++Q2YS0m/TADtbf0q4fW+GWhESw/6NdD1WE7OfhD2rYWFj0V4lfarWeaHKpk4XncvSF0xiIYjFE0/lMfMbDfyfvBnXHcj9Ln3f3ok51I+yEe7rYQW5kd9nn+SdozgTsplWt4/HbmM/01gGb6ncIRDMi5gbRwKUUZrxF2wiqHuRpcYEfeDvUM7ihoqwXXZIXiQ5gZp09QzPa7adfxA48LmHzTUGBpa/W2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 03:10:29PM -0700, Eric Biggers wrote:
> mempool_alloc_from_pool() is intentionally all-or-nothing, so make it
> return a bool rather than the number of elements allocated.
> 
> Then make mempool_alloc_bulk() return right away if
> mempool_alloc_from_pool() succeeds, rather than jumping back to the
> retry_alloc label to allocate nothing and then returning.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

