Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B13BFED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30056B00A8; Fri, 24 Apr 2026 10:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B96E6B00AB; Fri, 24 Apr 2026 10:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8810D6B00AC; Fri, 24 Apr 2026 10:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 715D86B00A8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:36:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 165318788A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:36:21 +0000 (UTC)
X-FDA: 84693699762.23.287B145
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 44A1D100014
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:36:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=uS7k5z64;
	spf=none (imf14.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777041379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rGmnz578Am/EljZenrf+7J6ZrtzAwbZgPZsP3LVCvBI=;
	b=gDyVUJXEO1WsjcfFaLJnTToD/4mGaT15z2Ck4ALENYvcKHQQZP7Ky4T3X2CHNP61bEjZuu
	I6bfQ85dpvKUNR6sZ0X2sM+tqOqizG0qv4R2JHvcBBCtsbnqA3MiOY8Q1nMp/S+svp3Wum
	/hTmAqXZuZMsQN1/UMkZ6gcpvZOKFyQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=uS7k5z64;
	spf=none (imf14.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777041379; a=rsa-sha256;
	cv=none;
	b=fcoRxYGOdufQblSeYgyK3dRRi9Tk4XRA8FuJWxhnVcWrSXta68T8zGXOZxP+3nNgs8ZVIT
	an37x5F0GYJlF8/q7qdzOaVyP0hXxz66mWfIWo8X5WCXqRa9YAAfokFUzd6nShZrAIfo50
	TPzJknrpjbf9DbpnkX8x3q9pLJAruYw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=rGmnz578Am/EljZenrf+7J6ZrtzAwbZgPZsP3LVCvBI=; b=uS7k5z64BLNXXKkJZk1AJgoa+N
	XlWAYm9riEmlvDyWMw+NkRQy4utmzYV2Zk17yRxY023jQugDaQqwlq7bSXa0UUzqsIxM1O7P4xaZ5
	6BCfsug5iQJW/l6e0Z/iD0OEykAtnsfAoWXCdyel2wqVB1EiDk18gFd/NGw/6CWXD6LMbRHjVI8il
	aRo69/FLW1MKYPXaSPthOajqeUXpP+hRc2D2u6Gq/f7e1e61vekr9nhhJDo5m7qjHaVhYVRChbh2+
	qJpQeLU/+d+HGs7u48rK2qGValkQj6NfHErJS07qQIVIJCuCaI1Hx5ixFFEzsmK5r5LEhQ9VRjq8Y
	yQGnPNhg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGHdY-003Eu9-0f;
	Fri, 24 Apr 2026 14:36:08 +0000
Date: Fri, 24 Apr 2026 07:36:02 -0700
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/2] mm/kmemleak: dedupe verbose scan output
Message-ID: <aet-vYNQr_5tF_hy@gmail.com>
References: <20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org>
 <20260424065325.d9643671feedb0f27297cc94@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260424065325.d9643671feedb0f27297cc94@linux-foundation.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44A1D100014
X-Stat-Signature: aj18a69twn17ffwd1x4fufkirio7zoqa
X-Rspam-User: 
X-HE-Tag: 1777041378-219913
X-HE-Meta: U2FsdGVkX18dN5HulnX0xu34Ukv6qya1+hKsSpk5gZx7bWmnZInKTrj3SCjyUz6bgb1yFW3Vg/5zgGmc0v9HcDG4X4rQqV2GIdNf0BrvNNVXPz6wrTPceUHKs9meT0d11LknWDl5krzpP7Xxpo+Gcqua9yGy3YjMO1W9FREKTb4TNN4Rvhe3xLUlv/ZZsvWK1LQBu5iNz8B86j74X0ZRPJGeKXwGY2obaEicGgDbPcZFhDzWLbFCvfecqkZWbzll6ncjJLTTKnzA7fTQfabES3vOnJz/99t/fTfq3d3q/uUFfxiiNJocjuGUUAVUHieh2sAkcLI8yTBER6nYTtICzlqyvwjcH94NjpGmkOTnS/2yzi0yLVztF2mi5wemDhoJmgXSdmZOT/1nJvPGeZa4KVG1eabjYecdX0Nbm3v/k3MjW8drufB4w/RIw5yP6l2VNXmN+tgfcWaEACkXxNMorAM3VHkmsiRxbe+v5dc+yudzAKxY15UAXnv1rbCMVOUQZd4qun4KUcQCERmlznf1psWWJ0ggp2RxA0Rwx5KyN9QEy4KwD1/Hj2zoZy5aAJfksdqyPAX7msD5i9cevgSPYsiOtfYVpE/sGwlj4dUWxBJ/jZ6i2Yam8wNGC+lYEbyOh1KWoaHoOfzL4u8retahQnqwbDr9P84TMz9Wwz7X8UUYaXlgTOToUCMmN8xcgHGdT4L4XeHyPeXdWzSXzcaqiRD6W0QZrFePbWKUhFHrAUMSSa7xOy9l0mH893LvXvJlWSSGjLAmdc6UrtqOUyLKbp2N1YbOZzWYJfLYKuBPq0DeQAJH3JoQz3I8t1GjKROXRkYiJAvIx61fJqFe7DVjhIrapj7g6/mfiMRI1QIn4F2xBtvUvpwJnNx1wJ49X7mxQLgKNOF/botUCzSn+Sw13YtwaCvEK/9Skty73Re5QLo/F8NOri9xvt2VUFJBTo25dmBK3MVRyacDcO3Zr8t
 OcZ4gjlu
 H2GQWto3NOcyVx8M3Qou53Yy6tjNTBk3vjdiiQFsdn0KSEnJNkO2bxXzB+SFakpRWI+JiucgCszL7/89QBOBts5XGi6aNSV9pM8miTJnHnsh6Qhqul2nL5D9VlVmJ2MiCevKvlWBViQlC1ATmeJdi7FzI8cHKImSHInzt4hfP/+7BoocXQ2v3YzMOtYoVFYKV54g1mhj3O2BIvAO9mpyrh5PaLPTNnbRh7KEtJ9vdUrDdXSoC934D40dskulTPrS0veDATC44TNUJ+HUqVuYUZqPA7DnpHGa+JmeqBTy4soLZr0boiplq8jBxwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Andrew,

On Fri, Apr 24, 2026 at 06:53:25AM -0700, Andrew Morton wrote:
> On Tue, 21 Apr 2026 06:45:03 -0700 Breno Leitao <leitao@debian.org> wrote:
> 
> > I am starting to run with kmemleak in verbose enabled in some "probe
> > points" across the my employers fleet so that suspected leaks land in
> > dmesg without needing a separate read of /sys/kernel/debug/kmemleak.
> > 
> > The downside is that workloads which leak many objects from a single
> > allocation site flood the console with byte-for-byte identical
> > backtraces. Hundreds of duplicates per scan are common, drowning out
> > distinct leaks and unrelated kernel messages, while adding no signal
> > beyond the first occurrence.
> > 
> > This series collapses those duplicates inside kmemleak itself. Each
> > unique stackdepot trace_handle prints once per scan, followed by a
> > short summary line when more than one object shares it:
> 
> AI review:
> 	https://sashiko.dev/#/patchset/20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org

V2 will have them addressed. Here are some of the answers for the question
raised by Sashiko.

> Can print_unreferenced() access freed memory here and in the fallback
> path above? Since the lock is dropped and reacquired, do we need to
> re-check object->flags & OBJECT_ALLOCATED before printing?

v2 introduces print_leak_locked(), which re-acquires object->lock and gates the
hex dump on OBJECT_ALLOCATED:

	static void print_leak_locked(struct kmemleak_object *object, bool hex_dump)
	{
		raw_spin_lock_irq(&object->lock);
		__print_unreferenced(NULL, object,
					hex_dump && (object->flags & OBJECT_ALLOCATED));
		raw_spin_unlock_irq(&object->lock);
	}

hex_dump_object() is the only path that reads object->pointer's user memory;
the rest of the report (backtrace, comm/pid/jiffies, checksum) lives in the
kmemleak_object metadata, which get_object() keeps alive. __delete_object()
clears OBJECT_ALLOCATED under object->lock before the user memory goes away, so
the recheck is sufficient.

> If get_object(object) failed, it means the object's reference count is
> already 0 and it is actively being deleted. Unconditionally locking and
> dumping it there seems like it will read freed memory.

Fixed in v2 by reordering: get_object() is now attempted before xa_store(), and
on failure we simply skip the object — the leak count was already incremented,
and the memory has been freed concurrently so it's no longer a leak. 

> What happens to valid memory leaks that failed to record a stack trace (e.g.
> due to memory pressure or context limits)? Will these leaks also be
> permanently ignored in all future scans?

Also fixed in v2. dedup_record() now starts with:

	if (!trace_handle) {
		print_leak_locked(object, true);
		return;
	}

so leaks with trace_handle == NULL (early-boot allocations tracked before
kmemleak_init() set up object_cache, or stack_depot_save() failures under
memory pressure) are printed inline through the same locked.

