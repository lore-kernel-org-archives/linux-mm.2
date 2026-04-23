Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7180F589DB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4776B0092; Thu, 23 Apr 2026 10:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18BFB6B0093; Thu, 23 Apr 2026 10:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9D86B0095; Thu, 23 Apr 2026 10:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2CD26B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:29:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67A8CA01EC
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:29:21 +0000 (UTC)
X-FDA: 84690053322.21.FA79FCE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1FE764000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:29:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GjKOBwJ4;
	spf=pass (imf01.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776954559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+bSU3KhyXgRRqKpvQPA6IG7AvMBHFqkC4KMlP/4yrE=;
	b=sA12XAdV1Kr6hMun/kHzaRNgjGWNu2Tt2Z7HmOQ00+VLFh72r57z66xCtb/S5R74UT+6z4
	YHTVcfSKK2V5ITQBHfpjHZ5xsV3deVz5YUJTfcxIpXxMUrEQ2Cn1X4I1yApO6zBTeIucfl
	18UmqnaWI9XOfiFB+s6YCAwtCteM9mE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776954559; a=rsa-sha256;
	cv=none;
	b=52ogUuuFb/Niu72tzvtC/Aq9uf+ENCjIM7jUOpiFPCwNb/5NeJC4U4S1PatBZ4ubn7kYde
	8lkvM2pJ4dOR5Fv2BuBj2/8qRDq+Kr4HqyjwCV5y8cFz1JxeaQliWdQArN+peyR5sJuj9M
	ewZBOySZOj0Pe2fQNyvvCaYCCnPY+Gc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GjKOBwJ4;
	spf=pass (imf01.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39DEA1C0A;
	Thu, 23 Apr 2026 07:29:12 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 881CA3F641;
	Thu, 23 Apr 2026 07:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776954557; bh=1gkahLjaXHUIa8DvHyVWpXrUQMCiYSLHL3RwfePawRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GjKOBwJ4fvKcjJAZzuDdKnOsN0TMHub2fIJNKcOUzct1fX07mAYhd/vowncnSNL0m
	 KMoy2Xbotudp6egM6uTzDwdrAZA73XOG00/S5GrmGgOrCu6go8sfieie1kyGYT6mbM
	 b/IPKK6JNmYoMBa1uNq9s8rykokk0HORY0kvctb8=
Date: Thu, 23 Apr 2026 15:29:08 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/kmemleak: dedupe verbose scan output by
 allocation backtrace
Message-ID: <aeostKcaHzmVBFjb@arm.com>
References: <20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org>
 <20260421-kmemleak_dedup-v1-1-65e31c6cdf0c@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421-kmemleak_dedup-v1-1-65e31c6cdf0c@debian.org>
X-Stat-Signature: 95c78wwxoshhrki79kux5o1qkxjdfzaw
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1FE764000D
X-Rspam-User: 
X-HE-Tag: 1776954558-295540
X-HE-Meta: U2FsdGVkX18V3G2hHKfn3wdt1I4VoqkZujYSg4n1b13aBrd8Hm/4BtKHAKomtRIUhApDbbZdHZoK1WE7FQk8BaZ5Zif1jnSC3M1P3U6AWgnHohn0Li4ENZa3oY7hl6vXf5IaCG0kDptBbOYAeFJCj3tZzghYonJDHpqxX8IYZRM70bcY+Feit+X9k/lnvqZZ+EH/WprQ+DWKqO/Bi3BF3bAHRYse4qh4ekK/dbM4sm8qc0k36d53s+7RnTn3AqfS1Y/16VK2OAp7os+MUmNg0yJexpkumzDNICJB17pJRfnCwtnQSkq/v1mhiJEPP5dW8uFlE0KGgqmYZYUaLMfHWlLKq3ohON/EMCukHpJ79tA8hdvi5iFMkB2YfcaIRYPmsOFzlPKyYPX0lIi8Z9JVewoNAauutjd+POEnVKsOVH/c2LQIh8usJxvM1uAhiA3NdXS6yG32bu67jSxwfB6KjafCjLWZCFPKB8WTA1MxV2CVBi4nWouG16qiKYxuqhGUilgxtkqSkRtEUpiYuuO+bjK5wnDT7F1vBCQYviij9VwVMsIcYmM7oWi+Wctwnutu6jYRqnxv87NoD9lFjp0IpV2s3ubswSqCLx0XUdvE1QDl4QKK7l3zT3ZdIdr/qLWjwz5+7oQQWFpopPWAFkWUhDvDCk5leu6YQQYUS0T/4yoXzDfSbQQfqvGaSQdunaXgfQvntXybemJzJuSHIRXTVfAwqnNbea93fAlIPccCfPvci533g7yo3OF7Dn6dOfItSOvMWBEk+ObmYzy3VENnHQ9qISZamNxKPme1fp/Vzsw7KJgB1WE+o55i09BiTTmz6zol2uXugOwnB7n+VUIM7TRSFWKeJOiN9NZWrw3po1EcqY8wCZbPm31M79+iBw8L0IEzKm/LiGWzfqhMS6NeLbRHHraditErFQNfuOcoTaUysSZqec5cgZgNnVYR0lGd5/Y4N5F7hhBs9I8Sd8U
 ldZq9tjC
 T7MGffe6bqhp3u8s2SXBuQw8hcf/1BV0GB6NxqLSdOiOZqf8TClT1uOW+DHeExeEJBHlOjkdnih8DO65PavA/A5yFpf15XZwki7fdQK1ltys/4fgiV6s46DSHklc9KfpHiII42XA0PJXW1h+EIqAUUZayrEusfpIu4+miRbwZOErLke+BfedvHzjJG3Gt2dHtFIeKzSE3lniRQ5ADmDxna7GtohKCya7HQzY+DAkUJ65lwWX9OZaP7uKA0WD3en+OOnVKYEkJLvxuLyekfi5LosigHCNo5cFUYfooUycxxnW9MWsQauMWuSS6FsKSSrwEKwLV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 06:45:04AM -0700, Breno Leitao wrote:
> +/*
> + * Record a leaked object in the dedup table. The representative object's
> + * use_count is incremented so it can be safely dereferenced by dedup_flush()
> + * outside the RCU read section; dedup_flush() drops the reference. On
> + * allocation failure (or a concurrent insert) the object is printed
> + * immediately, preserving today's "always log every leak" guarantee.
> + * Caller must not hold object->lock and must hold rcu_read_lock().
> + */
> +static void dedup_record(struct xarray *dedup, struct kmemleak_object *object,
> +			 depot_stack_handle_t trace_handle)
> +{
> +	struct kmemleak_dedup_entry *entry;
> +
> +	entry = xa_load(dedup, trace_handle);
> +	if (entry) {
> +		/* This is a known beast, just increase the counter */
> +		entry->count++;
> +		return;
> +	}
> +
> +	/*
> +	 * A brand new report. Object will have object->use_count increased
> +	 * in here, and released put_object() at dedup_flush
> +	 */
> +	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);

Do we need to allocate a structure here? We could instead add a
dup_count member in the kmemleak_object and just link the object itself
into the xarray. Well, maybe the leak being a rare event is not that
bad.

> +	if (entry && get_object(object)) {
> +		if (xa_insert(dedup, trace_handle, entry, GFP_ATOMIC) == 0) {

I wonder if we need xa_insert() at all. Since it's indexed by
trace_handle, we could follow similar mechanism like stack_depot with a
large hash array, maybe gated by CONFIG_DEBUG_KMEMLEAK_VERBOSE.

> +			entry->object = object;
> +			entry->count = 1;
> +			return;
> +		}
> +		put_object(object);
> +	}
> +	kfree(entry);
> +
> +	/*
> +	 * Fallback for kmalloc/get_object(): Just print it straight away
> +	 */
> +	raw_spin_lock_irq(&object->lock);
> +	print_unreferenced(NULL, object);
> +	raw_spin_unlock_irq(&object->lock);
> +}
> +
> +/*
> + * Drain the dedup table: print one full record per unique backtrace,
> + * followed by a summary line whenever more than one object shared it.
> + * Releases the reference dedup_record() took on each representative object.
> + */
> +static void dedup_flush(struct xarray *dedup)
> +{
> +	struct kmemleak_dedup_entry *entry;
> +	unsigned long idx;
> +
> +	xa_for_each(dedup, idx, entry) {
> +		raw_spin_lock_irq(&entry->object->lock);
> +		print_unreferenced(NULL, entry->object);
> +		raw_spin_unlock_irq(&entry->object->lock);

Sashiko has a good point here - while the kmemleak metadata is still
around due to an earlier get_object(), the object itself may have been
freed and the hex dump in print_unreferenced() could fault (e.g.
vunmap'ed object). Same with the print_unreferenced() above. It's
probably not worth printing the first bytes of the content anyway when
we do coalescing, the content would differ anyway. Also it's possible
that the size differs even if the stack trace is the same but I guess we
can ignore this.

https://sashiko.dev/#/patchset/20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org

-- 
Catalin

