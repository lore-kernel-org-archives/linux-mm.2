Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD19FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 23:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67DC16B00A6; Tue, 30 Jun 2026 19:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655D36B00A8; Tue, 30 Jun 2026 19:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5931F6B00A9; Tue, 30 Jun 2026 19:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 327C66B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:27:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A029D120162
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:27:56 +0000 (UTC)
X-FDA: 84938168952.12.FE4663B
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id DE688C0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:27:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eX7+jKaF;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782862074;
	b=8qYd5H97/WI9I5G6VKRRnGU2j3Bw9BP3UviXK1W1/ZGyjnKC+n8YGJZ1AbnPHEbedLrx/7
	D3S37FEyxsbxe/BeI9R8tVYWtZIW8RHByKD5r/NAhZlE3C9/a8DRWai/g0v3AAoDaDNjbw
	f7XKsn+MyxnVfjE5QnxaUWD5t1+5/vs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782862074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8VxY8AgSRitjH8l91RmH5GEBz/bwewUsAZtM00QZ6k=;
	b=gA35CVpSbdp/6qcNyyKCDn6njS0BId0Z5tUmHmI3ed115xClr+ig4Xo1sNta3pbIJWAZ9+
	TyuRTbuKsVO9vAZCsYTmwsfEJfUL6CX14e8Xxh1GXRmFjMxb/g9ZzhZDAMrPd3xhGkhhFN
	IW0ZGCKVriMU0znoZ+zKBH9L20Sffbk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eX7+jKaF;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c0c68aa31so59651cf.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782862074; x=1783466874; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z8VxY8AgSRitjH8l91RmH5GEBz/bwewUsAZtM00QZ6k=;
        b=eX7+jKaFUDHoZZr5WgELmeEitKSbl7ig/4QZhRO0r3ItGM5VLuVl4BL5raVY6szoZc
         F1Q0L67cEoHMHdLGNXarBLr8OL8w4d5IMFEaOSt2dGywwPIn5312Ysxxncd1FArp8VcU
         91A6kG3HROs13MCqKWnRYZHrk6shzkN+oresV5DpnBNSMIjF3H5WG3gkCNDSTnYpiw/n
         R/JBRJfoyZPaLqA9LlF6HZnr86OXxdeTRBOymevOfS6lgIPHEfgMB8AUMa73xkqrV9mD
         01wcYXX7VYDZf6FSkzvyQbz2ATCKay5ZtrCPHp1EAIbPfml+4b70BXxzMD/3aneOFUFg
         m0+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782862074; x=1783466874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z8VxY8AgSRitjH8l91RmH5GEBz/bwewUsAZtM00QZ6k=;
        b=KzgIuGYyCcJr6NLUxu031YwQBV3WwlSinGopOp9x43tdQuBdsgWSETlwSv9IRyTKp7
         /IYAFWvFE/P41tjJUSPx2gMFi6zKqv8TUVfv2UjPa1pQBwI4O8Q0Ps4Kxv4U1aHqXcvO
         XVXYWfoD4WTqjumFeivXGhehYgq/NkIGnkZjv/ht2C9JKchTvxniGjpYz5qXbU+UrjPv
         mEr21Aekw0kFzb3pyu+czl7RfURWlymCcmN81idBoicLnCL/yE04iXkp6rKlpWlGubsz
         obHtnfcPTeUZrfTRsKNGkeIh7EG7gVQ0L4X+J5zzmAjf9GHXihNxa1Wo13RinFZ+HJOU
         EKuw==
X-Gm-Message-State: AOJu0YzccgThcaznuFWwZPZ9YFGypp2CbEGsPsSoBNCN5HM8y+Uca3yg
	9IfXovA1QetNXMIq/PFC59sPXk0AedB/je6AZEUdWCEW4Qoos76gts8S4Gicuul0qoI=
X-Gm-Gg: AfdE7ckCkMyEJ/1N9HT7Bdrxdp9ioeN+nRLp0DO77kfmrjXHfE+Zso3ZqpFaXosCKT2
	8xGbfu5Dz7g1awdjQ607egdYUJb2y5FJnFsgQkvkTz5OEeCeHvisLZKIhRNoleen+QupTCm+ntd
	P3i01rzQfMQs/7gAgFmWNOC3SPPbKCd1r99J61jCCUCbYl8+hwkubBNrZFr3LSCnAlF/j9Syc3i
	ArtS6We2neApmnMLfm+wiWuARHM91PdVhIxnVz/yxsTZacSpPS5wDhebf9JDWlXe9lQXJfEK+r6
	3KEQsqCAA/eq1wl+c8GjV5gXfDA0wFE6I9b1NVCFqX2m1aYy03EeV1/HYCDJsUzVvAD9rOrYXZ9
	1XmmJCzLwplJw/fV+pQcLaTV5F+MBMpvR+Q4Sy3GFPjyPAjc86+P/2mNSRzc3fTxtZEbnnBsBY/
	YvnQC1LiL0+Z6nHVB0jZ7rUBR4fauaB5aUlC9Wxjwarrw8Vl4Q9G2DmAHpIr4GZeaGJx+E
X-Received: by 2002:a05:622a:349:b0:51a:84b8:df75 with SMTP id d75a77b69052e-51c108a0f92mr82576621cf.50.1782862073978;
        Tue, 30 Jun 2026 16:27:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f3618b6b13sm2985436d6.34.2026.06.30.16.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 16:27:53 -0700 (PDT)
Date: Tue, 30 Jun 2026 19:27:48 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	rppt@kernel.org, vbabka@kernel.org, mgorman@techsingularity.net,
	hannes@cmpxchg.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmstat: fold stranded per-cpu node stats when a
 node comes online
Message-ID: <akRQ9KB6-HzLwqwC@gourry-fedora-PF4VCD3F>
References: <20260627202243.758289-1-gourry@gourry.net>
 <20260627161007.81e4533ce561c2951a69f927@linux-foundation.org>
 <akQtx7zhP7pxNCiy@gourry-fedora-PF4VCD3F>
 <20260630155517.38a99de9f32d20abcbf9440b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630155517.38a99de9f32d20abcbf9440b@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: j36jysfsgyb7bzggcai1a591e6gxqaew
X-Rspamd-Queue-Id: DE688C0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782862074-496798
X-HE-Meta: U2FsdGVkX1/n6nCMKuniL4EqNG9fmJ7flXRNON0N8e7r6fQAFsxKqf1sIxsXXkiPIaiuHYhKPc0TfhH+Pe4MvQZxLNVbbKhB/EaEuSZu8IIEAkRBp/cIdhKoRmqWUe8qL3iri8G9H1j0o46AAwYuTckk4MFQp/aYFfpq1S8Xx/ZTT3sHKc66hRZBWWGn9EnCHRxqtJMTZpzjDs++FhFVZl5UXFdmJs1iJ07Drwyj4APTHvVriiwpPwdGMIXBiRWcSoPbjB2rOqDpnouz2JtTKEOJ4gNDD38Ir8ODCjeHEa33UdXXyW2mBxDsOJg9DZmVZQoZGifOqfcIqF3c4LT+8Bi6iVW+OcRLkT6gCGT8vm1w9FtK0EeiHpfHpgYRwinQ69fERhDhqwEF0HDTPPfRXPca3NsdQ+Wm2khGeTLieOqO6CAoywkX/3mRuKJkgIbY/3swBx56N5MtycG8usmrREUdZ12WtuI3RsO7kgRENRKZwg5YnA7OKgskneERDOdl8m8BHsNyEmjsPQP1t8e6yH9I3B8uv4/Bj29er8N2AFCooCRL6u70+mZHncKwy8rHdn8SbuxzUTnWS5BC63EKSsUrboJya2a1gph9j6F6u7wCYjr3Uys1lqgysO0qt6VU7H4rPJjMxtUgC+/d9PMNgp82rcA54Jus30uN3TqGxcAlcMiN5SU4YupZlIf+8oH1LQ/DeL9/CI+MXuvf9eTH/zjunHAfgmV4yT6+0hilo2llxYnKHewxtvqZPbHpWcxWs5WLIwY6w2FurljQOcRtnbFqOPt0yOkxcrL6pxiV8jrPVLHNs9XHsV8f2Rr1EublzXpSGpuIkDKVMwvgBU6ZRz+3bXHpZjwN9oAHRrF/jmi+c0W62s+SyzfA+1P6wgInIT6Num6YzuRU/xFhCWH2tc9xWbyfy8AvruaditGwzaB82s4my9Qf3hCRLOBNchYblVe2sFC6ZEa3y11x2cT
 wEy3DJ1F
 LOL7I/rfp1Bfj/1fOJpMUvPbIC9s38f5cP40zX7FTVAV5u6BwlaB7G61w7dIg0DvmvBOwh39J5Dlq7Eonjf0nJqmq0/TwZgEoIqpabX+slgroW89T4P8BERIXGiMaPAlQTUerMmUeoNBuGIIITKMc408Ag6S8nXfwAMB+GYALxk00NOcHNOhdatEIGnVZQIspVaRm6U8NFFYtfW4TlQg38nlqYWyImdpwLdjVIYkic7mzt0q8RpncSNpbtygvhJt0/VqikzEI4shjZFZ9Uv3Wd51iqQHqx9reFAd/oiK5QeWALaQYl3xm5dpGAG0Ou59KnUb/aLzXw+jdOqNZYquko4kKBE03F4b3paHzMtvaB82o1yK5W31jQ7GAG8cgiEsDOZmkt+6hOCPr+tWosjJZ3fk9MlWKF9SuoVQtV0CcJaFHJNxFfrZ3gbmo/ECjqS585lb1LahaX3dBxJXXjpVC2XOQFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 03:55:17PM -0700, Andrew Morton wrote:
> On Tue, 30 Jun 2026 16:57:43 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > On Sat, Jun 27, 2026 at 04:10:07PM -0700, Andrew Morton wrote:
> > > On Sat, 27 Jun 2026 16:22:43 -0400 Gregory Price <gourry@gourry.net> wrote:
> > > 
> > > > +		struct per_cpu_nodestat *p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
> > > >  
> > > > -		p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
> > > > +		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
> > > 
> > > and that's a lot of items.
> > > 
> > > I guess the overall loop count won't be large enough to cause issues,
> > > but it's large!
> > > 
> > > Perhaps there's some simple test we can do on the per_cpu_nodestat to
> > > avoid the inner loop?  Perhaps might need to add a field for this?
> > >
> > 
> > I took a look, but that would involve adding another per-cpu field and
> > then making sure all the races on that field are respected as well.
> > 
> > Not sure it's worth it for such an extremely rare event.
> > 
> > I can try to get clever on the folding logic if you'd like, let me know.
> > 
> > > btw, "for(int i..." is allowed nowadays.  It'll make this code nicer, IMO.
> > > 
> > 
> > Otherwise i can send you a respin for this.
> 
> Is OK, we could make this change in a million other places.
> 
> > > And... Sashiko seems to have found a pre-existing issue:
> > > 	https://sashiko.dev/#/patchset/20260627202243.758289-1-gourry@gourry.net
> > > 
> > 
> > Incoming patch for this shortly.  Pretty trivial.
> 
> Cool, what was the Subject?
>

[PATCH] mm/mm_init: handle alloc_percpu failure in free_area_init_core_hotplug

https://lore.kernel.org/linux-mm/20260630214039.2263562-1-gourry@gourry.net/T/#u

I didn't bother with Cc:stable because it's also 10 years old and
doesn't seem likely to actually get hit, but if you think it should be
stable let me know.

> 
> I'll queue this patch in mm-hotfixes for some testing while we await
> further review (please).
>

Thank you!

~Gregory

