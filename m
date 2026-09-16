Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 409D1C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:08:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D89D6B0092; Wed, 16 Sep 2026 05:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4895B6B0093; Wed, 16 Sep 2026 05:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39F466B0095; Wed, 16 Sep 2026 05:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 143DD6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:08:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1496CA5D00
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:08:17 +0000 (UTC)
X-FDA: 85219049034.30.106557A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 23166180002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:08:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=DbjJMDJo;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789549695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1c5BkG1XwUGSYihHgqGld4BqIOfDyTeiCgVyGKTLkns=;
	b=S65EtVP9cc7K3JCm4V9YKZrR72F5KYKGjrw/X9rYqK7nQsGOSZjQbEbhG/N6vzrLkCZpsm
	JDA1oL9DykkzctTiQbxeZgCk846Q84zcdgnzI5vj/NkGqOrUUXkl3T7c4aMgcr2cAGB5yO
	eSUT7WB4gztCW8vV6D2JIK0oDGF9Tnw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789549695;
	b=RtcZFihcPPgp4By+SPqf8FQFYgA9dXYOfBeyA4lkBoa4hmQxoQIhzFy1C526Xq+XA51ME0
	9vSxPNCGDFCMOWOZeRjI9UPe5pYVh1isI0FTS2XN6L+7XbqG08M70nUBwCHwqCVehZ890d
	lwQkmZIZvbTmncbE+UrzvCTIOA8taRA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=DbjJMDJo;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97D8241927;
	Wed, 16 Sep 2026 09:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11701F000FF;
	Wed, 16 Sep 2026 09:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789549693;
	bh=1c5BkG1XwUGSYihHgqGld4BqIOfDyTeiCgVyGKTLkns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DbjJMDJogC8wmX9uIsrav3Iwtmpm7VdSW6iGJVYfuqGtqfOxKJyjAsJciaS7cCIJj
	 5MBV82FutMYTWXCkoB4pdHCAGx+1QxfOEXi6lnAJXJD4VbqptsKZlj/Xsr0nhtlOXb
	 +P586OykuvYqikYSGWTjMD332werjohzIpCI0jpI=
Date: Wed, 16 Sep 2026 10:06:19 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com,
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org,
	jannh@google.com, aliceryhl@google.com, arve@android.com,
	cmllamas@google.com, christian@brauner.io, tkjos@android.com,
	dsahern@kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v7 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <2026091635-steadfast-widely-7753@gregkh>
References: <20260831203056.838265-1-surenb@google.com>
 <20260831203056.838265-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260831203056.838265-3-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 23166180002
X-Stat-Signature: febo8bd9x3o3behgorta6otjrte4xzjp
X-HE-Tag: 1789549694-220666
X-HE-Meta: U2FsdGVkX1/4l4tcH0p4sZl4hTZM63XqZYGFeYYBmyW7WP0Fz92tctSnkl2GREY+g25OvwiNt2ePuvI0vlCO9HAmNo8wW/ungj/u+3p9cYzFAvhV+o43ZFo4Z3iRvu8yyqwOumNLkRI3KWj26iaB+GSDBRcWIXg0VyCyq8q04FOzfwvP4/Hqzg870rbpMRec3SkOBcmydshsIY58Tbu82i506v9bXwhg+LuqhZ4JwzuNJpgOwmJqcEhQlY6nEQAdYSCmx50J9dOTe73d9LpR2L6OOT9uQ+RZ9YYnmrGmxyoImVUdC2Z7cYswv7JmaF8Na0HEHQjZfYdUG7licZnZ0/okVPxW0/iCZZXL+IDFj4QSHvCgeKsDYIXAnkBEYRJsqi4618G2C6jywPITQm1ejKPm4oCfDTUooIJC6rBwS1lQ1wi84s0/5hPwhXAdYy8xZtnMc3ZFU/rKUmlfPbKDVRk9gZeeni5w2VU0++X2ZhqDNd0vFAvBI0bsx1NZ/K6BlImhTwezd3nUDzghHJytSATzbjCNWbRX7qANdrmjMAG5R9ax1T7Q8exdGcR1mGQP9jd5xVkHghy1o1uZSZQ1uaQ82W9BcW4OpwGSE0zH9/TVCEfH5lEs/gbvTLbUfoIxh2mMLaNaonmKe1NKzfGCDz8kfRwj+bFM1GQFSgl1L9ZgDOW2YPNwGsFQ+B3Kze7AkuRnvTY0yKpcREaiNKGGDiZCiQTshbbaH8iIYkGSzSlkIHAN+1IroKBIFVHiPKOpRyY3Hh7FudHZsX1DEYsz022EFeLf75MIFY6uENHfACgspIwXxwZPYG8DmbHQF7mj+7nmUvPWXfDtKtv/Hl8rG3MttCVKB4eF+G4b+HbCaxzT3BeHf6xW6Y9u09uXqhQB5saomziKbC9XvvZg/Qvf4D7uEdUuLb/Wwa7zbIcgk0fa7Mzs9IJY2m7rhvnRCePBcdgAvDc1+aA9EnnK7n5
 gQnQKDtc
 QrhwsaTU+3v3ZsPCe+k9rsBBN9swD1CQXwl8/3qnHjFKBQcb9u8Y2eLBKR8j4iyeTg7WkBULq56wa0vds64lilLEznml3ANPeTj3AUp6TUv7VKeOxTwiNulq3dnfW1iXTDVOkYnfTqinco72RrX/8yEmGYlt2nwFrp/q4b7yNjkfljfhaN7+MFeTWSfkjU8oy+DuPXzdLt90gm8GsB7fDS2owu/IXaltdCMqCr0SFRo4f86Hpz3lQSDTsy04AxTQ0f6wdra6oyS3I7rI7Kx6VMCDbeEingqNYtnPtsK78Gibe9AYaC0VA7W5ph1r7I9QA6NU2mX+HhHcVIrRUg/QNYZg29Rasrc1ze/HiDtGjajGEga/gB25vM2mRG7kSgAWasEi6BXtFdRhSedpS83N8Otvhw+TJdZLu0bTEz65uffzov9cdFf/YDLQRHv+lM2lvcFD26+G0lS0ZoAznq1mj+XfT4zimHrgwRwh+utxdFc5hqy42OaOnxlSnA2vLPjty9tVSue1ncA3AAA8CnFlTgyZwUUhvNF0QPCbRiBBJOyOMiBAxqwsPmcqnCB4lzp83KXY0s7hOa7p7CL624GNQqc2oyxLnFK5kOvcen/fxAnD2MFv7M0krR7b9xAWnzlT7ajpZEhOqUHFI5He1KUKq3MlhEHOoRp0VBe/pRBotLTb60te4V6ryUTqonAfPJOCxo9IWuhQLJ5j6yfL9P8uXIF9ivv0ij48WkZvUsUKSvvFeUpFoYvz2I+8/OYK1XTwEB9WohydBy7h8zMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 01:30:53PM -0700, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> it and mmap_read_trylock().
> 
> Long Version:
> 
> == Background ==
> 
> Historically, binder used an mmap_read_trylock() in its shrinker code.
> This ensures that reclaim is not blocked on an mmap_lock. Commit
> 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> support for the per-VMA lock, but left mmap_read_trylock() as a
> fallback.
> 
> This was presumably because the per-VMA locking can fail for several
> reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> to mmap_read_trylock().
> 
> == Problem ==
> 
> The fallback is not worth the complexity here. lock_vma_under_rcu() is
> essentially already a non-blocking trylock. The main reason it fails
> is also the reason mmap_read_trylock() fails: something is holding
> mmap_write_lock().
> 
> The only remedy for a collision with mmap_write_lock() is to wait,
> which this code can not do. So the "fallback" after
> lock_vma_under_rcu() failure is not really a fallback: it is really
> likely to just be retrying in vain. That retry in an of itself isn't
> horrible. But it adds complexity.
> 
> == Solution ==
> 
> Now that per-VMA locks are universally available, lock_vma_under_rcu()
> will not persistently fail. Rely on it alone and simplify the code.
> The removal of the fallback does not affect NOMMU case because binder
> driver depends on CONFIG_MMU.
> 
> While at it we also make the handling of the cases where the original
> binder VMA is gone consistent. There are two cases to consider when
> Binder VMA is gone:
> 1. there is no VMA at that location anymore.
> 2. there is now another unrelated VMA at that location.
> 
> Before this change we handle case 1 by having the shrinker proceed to
> free the page, and just skip the zap_vma_range() call. And we handle
> case 2 by having the shrinker return LRU_SKIP. While either behavior
> is acceptable, we need to handle them in a consistent way. Handle both
> cases by freeing the page without touching the VMA (skipping the
> zap_vma_range()).
> 
> Full disclosure: I originally tried to do this with
> lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> trylock semantics. Claude caught this in a review and suggested the
> approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> I guess.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: Carlos Llamas <cmllamas@google.com>
> ---
>  drivers/android/binder_alloc.c | 46 ++++++++++++++++------------------

This file will be going away (along with the other binder .c files) for
7.4-rc1, so I don't object to this getting into other trees now, just
note that it will not be needed if you wait a release cycle :)

thanks,

greg k-h

