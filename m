Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD52CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C076B00A9; Wed, 27 May 2026 10:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432A66B00AA; Wed, 27 May 2026 10:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FAC6B00AB; Wed, 27 May 2026 10:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 250D46B00A9
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:33:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B52C6405F6
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:33:37 +0000 (UTC)
X-FDA: 84813443274.19.7FC4506
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 04E56180009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:33:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RtNMt3L4;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779892416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CCH92GDP8tW9/dATbIA2UouNp8bD0Ru0vl6CDadR+hw=;
	b=AmiVmTgY9hBvgnaPa3lJ3vdNa7U+vj50FCgkurH6OQXjBlH5HGXNXb8aUrvpBpGE1TlGAh
	0G07n2Y1Wp3XQ2TYgwfhtoYIRiFTTbqSbGxKvgYTVj4380yYc30NcZk7/kcK1wVttsj9u/
	fnToJuRlcgeYDYGs8C0RfFTv8ypMMSQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RtNMt3L4;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779892416; a=rsa-sha256;
	cv=none;
	b=qP3SKKkl+GMq+edW5tJXuceaRAX5wa716AIWCFYXZp/IpAzM5bQB5b421HnZF4l5W65W6N
	tCAfRFj1EBZ075OhRpcYHNJ5qS4ouEFHP2KGcVSjkx9QsAhmtGQl2x3uM5mw2xovLcUnpC
	Zdf9FhXIheqmKgBmfrtKRIzim/Rjm4Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AB7D601E6;
	Wed, 27 May 2026 14:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D971F000E9;
	Wed, 27 May 2026 14:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779892415;
	bh=CCH92GDP8tW9/dATbIA2UouNp8bD0Ru0vl6CDadR+hw=;
	h=From:Date:Subject:To:Cc;
	b=RtNMt3L4OFETW8wZlDN0SQm263L9NzzgCNdvcUixzAdZDWmHLZjfaBAPVZYVWHZXi
	 y7BoY1Tw219sWyznVGwvws+pR6LlTmnIAg8IUqsm3QwPpPM4jU8RkQ4Do8kX6eVEnp
	 KTwJTWYZpTSRm1/3TgT6Mu1M5wr5ADIBsFp+8SD4iCY6AN8irero+AZCZEidSbqGtc
	 Irq22SF3xjwDmQqXuIj7pih9JsX7pl5MBpj1OkHauz+6j5+ysgxEPUP6NGCsTaEhcz
	 +dc/YwWqVnEHBEM4vdh7a4K68jij0T1Lp3dUO6tjVM8ngrXE2mt71eZpB8UDp8bQeN
	 3KKud0FF7fubg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 27 May 2026 17:33:28 +0300
Subject: [PATCH v2] block: partitions: replace __get_free_page() with
 kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260527-block-v2-1-8e06f914c484@kernel.org>
X-B4-Tracking: v=1; b=H4sIALcAF2oC/12OwQ6CMAxAf4XsbHUUhsaT/2E4bKPABDeyIdEQ/
 t0Nbx5f8/ralQXyhgK7ZivztJhgnI2Ah4zpXtqOwDSRGXKsuEAOanR6ABTigmdRtE1xYdGdPLX
 mvXfu9Y/DSz1Iz2k5GUoGAuWl1X0ade0Es4PhKccYPO3VpPUmzM5/9n+WPOX+Ty855FCVVdFo1
 C0v8TaQtzQene9YvW3bFyGCHITUAAAA
X-Change-ID: 20260520-block-25582753fd38
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, 
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@suse.com>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.15.2
X-Stat-Signature: 5ht3997komd8hiioc5s77g7hfpbkkon3
X-Rspamd-Queue-Id: 04E56180009
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779892415-232600
X-HE-Meta: U2FsdGVkX19A33zPPLNzxcDAiSE7QKBkNC/VBQ2ViRpAb62vitWuFA/diD92IRNjkZF1U0XVMTAFav8CSxnpOodk6/tOotOtWlOql+TqWmYQA0+F7glr4VZsT4aHPKTsHFwvKJ3xdlFtU8u4sJQOvzaB4vPLWyc1OO0Nr0MAqXOsC4I/vjnqj8Qd1GnD/wys1rfHELjlJFh4L+iVXri0mUY+20TfkpoCueJasVRXIivD7xdjilBy/NJA/MhgcFcF65QQITuUI9+0XjyisIzFyCEULFBVBeMM5HGSiwniAh0TNhb/9GliS/b1uNuGSuE7smZbBl36YN9Q3PGePZyfGNGUQ0g7PO4qU2VTPRQtOhP1VO0BqI+P5LPZOGEgtyBgJ020Z63gBsOeoLEneLr1f8Ga70hH8dSKM23VFczhuEkksrWdQQxSsR/l3q0yR7L119nuC4Albxh2bLFdLYbEpe12U9lh/Tp+OTgBq5qNweOTK8TcgUIyhqzu8na+6iFZIPvnJdzHI2s4bp6rMyJ1YyNyNkwc3581Ncp+g5Cxy0bdpH7c2q6CVPUKCELYf/kKPDXggaroY38MVXSBDvKn3ZA0g93g+5MR+0iMASAreKlCxlVpbcetmTo0thAV5DDmhJR2yxvzmnoZrmgQlJOHY2KacZD/74eVZdqN+cGDXX7WUWt3n0uM7+HttP5fr/kTCKz2nVg9h/yhxrsGvgP1UEjm05LwZY0KypAdi+cmoqYjnS5GqaS6B+hlpH29bunv5tlC0Bk3f2HThplcHOdxiamul9QRIAYwYXQf69Z9vcETNGWZBUWguisTX4dIiMKbMwT4aERIv3oFWxoRbG2PRhNBLk3UpvwMuAoVCUg9h2+uE5aCAnEcUB9YANaOrRtVLQIEGVaJ2584cvsB5pwpPPlMo16Bhz/ZtKrk7+nSE9UDP0/O0nxX1Y2zLl04gXfyBSSppOQ1x0shHCdfXPn
 vWr5x1Pw
 ypT0IDy5Fzy6LmIPq2G1+R9UTvdz1HnnPT+Qdf8DGBzOCzNNmgWiL7UYsQU91s+mqH9ZOauvZrfODBB+EmJ116Q4nVjRl3vJVbrUZf5Cos1LXwvjCq05TfpF7XZ25s8PHYc50I6TJ/RylOgOmCktJIXMtj8Jms9YvBJ05se8vrEQRfjat5yqqUzjZ3sWhKIpLEQoLL98gRFStRZLra+5hGtogsRDIxMWZ2L80avY8wO9cDFlVypQjZGwd72Pa7repPz4avxjyxkyZUTjnUQ0idop3h4imXUKMK+6+iNkS7WxmQB1fgo4pX9Zt2JlL2GTdukO5EqdfpMSHN1Z/ktB2dmDp8i58v1UwgLf2lMjefy+DjAadpIK9hDpmxClflhGcHcuIt7Jf6J77jaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_partition() allocates a buffer to use as backing memory for
seq_buf.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

For a single allocation on the cold path the performance difference between
kmalloc() and __get_free_pages() is not measurable as both allocators take
an object/page from a per-CPU list for fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
This is a (tiny) part of larger work of replacing page allocator calls
with kmalloc:

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/block

Signed-off-by: Mike Rapoport <rppt@kernel.org>
---
v2 changes:
* reword changelog

To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
v1: https://patch.msgid.link/20260520-block-v1-1-6463dc2cf042@kernel.org
---
 block/partitions/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/partitions/core.c b/block/partitions/core.c
index 5d5332ce586b..b5c59b79ca7c 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -124,7 +124,7 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
 	state = allocate_partitions(hd);
 	if (!state)
 		return NULL;
-	state->pp_buf.buffer = (char *)__get_free_page(GFP_KERNEL);
+	state->pp_buf.buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!state->pp_buf.buffer) {
 		free_partitions(state);
 		return NULL;
@@ -154,7 +154,7 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
 	if (res > 0) {
 		printk(KERN_INFO "%s", seq_buf_str(&state->pp_buf));
 
-		free_page((unsigned long)state->pp_buf.buffer);
+		kfree(state->pp_buf.buffer);
 		return state;
 	}
 	if (state->access_beyond_eod)
@@ -170,7 +170,7 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
 		printk(KERN_INFO "%s", seq_buf_str(&state->pp_buf));
 	}
 
-	free_page((unsigned long)state->pp_buf.buffer);
+	kfree(state->pp_buf.buffer);
 	free_partitions(state);
 	return ERR_PTR(res);
 }

---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260520-block-25582753fd38

Best regards,
--  
Sincerely yours,
Mike.


