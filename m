Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66DD2C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6041F6B009F; Tue,  7 Jul 2026 06:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4616B00A0; Tue,  7 Jul 2026 06:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0BA6B00A1; Tue,  7 Jul 2026 06:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 313716B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:02:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B72041C7F5D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:02:45 +0000 (UTC)
X-FDA: 84961541490.29.B42C43D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id 215C2140008
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:02:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=nqshw3Dx;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="XKrdZ/r7";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf26.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783418564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLnZYm2b0ntHPhEsRf4aDVEoqK/6RFpbXWmxke0pf4Q=;
	b=mZfDTShfcDMd8BW+r3FOiD7OKFpfu9b2NKDzeh2VOpylm4iA3i2Dx+lhhXAg3HjRmfmFVw
	JJn/dnwO2rWwTztGjIG5aBB/IX2vg7ijLA3quIMDw38fjmYx7lo+LPhE/s9OzGZAG4Fz3U
	QozhvxFrZxRgFnL9AphDZSjmiAzHDMg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=nqshw3Dx;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="XKrdZ/r7";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf26.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783418564;
	b=noMN/KFdLLUMxw2jLVWSexb3gbA/69URfs1JlDCXFQg3NIOMuniTA2QoPuKMqU/QGzOlp+
	dlJBhMnoD5gILu9mhWoYIqkdT5SBSA5SZYPiq2Gadx8h/3yBAoFccIynrrhgna1Lq2rK3Z
	7iLspq15z9Bpk71a0+q++T+xs32cblA=
Date: Tue, 7 Jul 2026 12:02:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783418562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eLnZYm2b0ntHPhEsRf4aDVEoqK/6RFpbXWmxke0pf4Q=;
	b=nqshw3Dxt/ytbMPS3MetsC8efKCQPuPD6E3Bs7TTVRtmJhdXgjs9TdnNimjL8qiorBsyLq
	G4JLBm/TNC1LjqkmXt9qBTh44Ls5QkFRmX4gpOQLq1FQos/qyTZpzWP8UQDHdhbWjnMHnx
	5nP21hHsDIV7Qr9v1jlQ1EGU6w7vZ7WMRy2BTQFK++gtthyS60fk8DveGSm2s/kTO2la/E
	pe6SW19ggKm31D4NitoZB+/DZa//+p0ilRFXQo0E8fxS5xl6isgLTClNTHvzck4BX7lscX
	fg1NXfUXEPPa7mU07RH59mORIdL8nJbntnn0aZ/DP4bTVxO74jBzb+70hgGNjA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783418562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eLnZYm2b0ntHPhEsRf4aDVEoqK/6RFpbXWmxke0pf4Q=;
	b=XKrdZ/r7/GVcv5GlSjvYOZ0nr89L00AZwXLXl4UCkx+aQC+b5OTBuK2RoJ1prdSWPMRbA5
	tEQjnXJOCzUPBiAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Hillf Danton <hdanton@sina.com>, Kairui Song <ryncsn@gmail.com>,
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 01/19] zram: sleepable entry locking
Message-ID: <20260707100241.zaM2yrF5@linutronix.de>
References: <20250303022425.285971-1-senozhatsky@chromium.org>
 <20250303022425.285971-2-senozhatsky@chromium.org>
 <20260707064030.D843llKh@linutronix.de>
 <aky05GBxo4VKGD58@google.com>
 <20260707093024.DPG2lvt_@linutronix.de>
 <akzJlY53m3XBg9Is@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <akzJlY53m3XBg9Is@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 215C2140008
X-Stat-Signature: 5dxtdis8sd36h7hnqwutahuwr8yej1fg
X-HE-Tag: 1783418563-873995
X-HE-Meta: U2FsdGVkX1+SZiXshSfGEYWG2XRsiJBCX1hxUJsaAMgNl3eQJO7Cz4CnfvXHPC4/bOHLeQvynJ6vUmAQvQOULZMk+3NcVJ8dr5sBq0JOKhWHziCyMsCeRyv0ac7UcyucppJb3B2HRDY+rJkRWXTY9omPzNnhNG9r/EkQMPlo4GdH6V8jPf+8OxetU6Nxq5hEvG3qdO54EjsInxz/BjnsgHY9bMeSjAjk6y6NfOc03a2mPYUwrAV6Ea7oOPs1h/q5wOhFs+OW+mRJl42OB8z4YaRiDmwp2ZzBblFjQOYEbJlbUJYG/ykxinjY4IgZZv6iOwKODuJKMNWVx/V89aBGI1t/0snd+YRpK+IGN3gKoF9p7PGMlXRDp3tfRGtjhkBH7BgGGdYb9lKoU127vXNaGcNCmCT43pYd/1GB7mO93nnZFqQqn0kYiCTsru7T/N3tVg4ri/qrphw3jWi1udZW2k1RaVv4R4la7bTZpPZaYKHWb7H4goN0MxDb6bsbotdUoa+eckCTQYu9i5a1NcvXm5Yae9b1ez8n88zZeLNaGQXTSKUdT1mk4i9Qgzc0XsUj61hk70Hda+W5UDrQ8rh6z/xsOLn9xFnppIIj3bpV1wxuv5NqudbAUFLQdF9W58e1Ej1h+yuguyDyfHBSdPqiEma+xjiM21nGtIQKbmbUIl0c2qmqjT+gjQr4Y0KXsrk+ChOHQwuNkn8lxV0st7qhAoor5Vj3onCwB4PmfkuE6y4wsKJIKdSjt4YN/WT6CoLCp52+S4QPxaYJIocJmYwS8v/exFm5tzPQwYVcs4KAklkS8U3OASC5+L0P0zvpP06YnepnuGJHl1fVFoBQnGbR8OoSVfBvGZE8Hc8eatHIGOHa6uK2HY473gV+w+OHEHdQzaa9FbBsZ7JLkLEo7M2AjQ79ZnOuYBjQPIFU4CoHRnTTK4BzwrfBJ3hYmnMrmjgnlhchVNoF/oGhgdL8Cq4
 BrnkrnF5
 i8WZ2DQ2Vy10NHKODpFdfF7/5Qxb4ACdAS9DTq5czKFfOKhfBEaOEfsYLyZ85g9iHun3aQvtAbhxKK6gO9j6Nw/BsTwExMZVZJBPBdHLMKjdYeBEybGx696hKrevzDJmskmdOaOyeeuwoJWu9rz8z2EcS8EltyE6T03fqarhcw09T7wxhJEjIm133pthW1SjMj4q5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-07 18:42:50 [+0900], Sergey Senozhatsky wrote:
> On (26/07/07 11:30), Sebastian Andrzej Siewior wrote:
> > > > >  static void zram_slot_lock(struct zram *zram, u32 index)
> > > > >  {
> > > > > -	spin_lock(&zram->table[index].lock);
> > > > > +	unsigned long *lock = &zram->table[index].flags;
> > > > > +
> > > > > +	mutex_acquire(slot_dep_map(zram, index), 0, 0, _RET_IP_);
> > > > > +	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
> > > > > +	lock_acquired(slot_dep_map(zram, index), _RET_IP_);
> > > > >  }
> > > > 
> > > > Looking at this, is there a special need to have a lockdep map per
> > > > table? Wouldn't it be enough to have one per zram? Logically you use the
> > > > same __key so I don't think it makes much of a difference but you could
> > > > lower the memory usage a bit by having less of those structs per zram.
> > > 
> > > So the idea was to separate lockdep maps and keep them per-device
> > > because various zram devices can be on different IO paths with very
> > > different locking graphs.  E.g. zram0 can be a swap device with all
> > > the locks that swap layer has, while zram1 can be a "normal" block
> > > device mounted with ext4 with all the locks that ext4/vfs bring.
> > 
> > Ach so index will be 0 for zram0 and 1 for zram1? In that case it is
> > different from what I assumed. But you use the same key so I think it
> > will be the same lock from lockdep's point of view. Like it will
> > complain if you do
> > 	zram_slot_lock(zram, 0);
> > 	zram_slot_lock(zram, 1);
> 
> index is PAGE_SIZE granularity "block" of device that holds compressed
> data.  So they go from 0 to zram->disksize / PAGE_SIZE.  Should I use
> dedicated per device key as well?

So it was what I assumed. With that one static key it should be one
"lock-class" with several instances. So I don't think lockdep notices a
difference between index == 0 and index == 1.

If you have zram0 and zram1 and both have different lock chains which
could result in a deadlock from theoretical point of view but not in
reality because the zram0-swap never clash with zram1-ext4 then you
should have a dynamic key. That means add it struct zram and register
with lockdep_register_key() and assign with the lock as you did.

Sebastian

