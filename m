Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5FA2C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 22:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612E66B00A4; Mon, 21 Sep 2026 18:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C3926B00A5; Mon, 21 Sep 2026 18:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B466B00A6; Mon, 21 Sep 2026 18:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17E606B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:53:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A8E11202D3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:53:07 +0000 (UTC)
X-FDA: 85239271614.22.4BBD380
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C1E3FA0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:53:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YzqYCbK6;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790031185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vr/gx0Gk1vpjpHWM5sT+D++JQRExEkJQGlPWeyGVKCo=;
	b=cj433KWEH5Ehu5xhlagnQ+csNlSE3JFyiteIsdgO/SwcIOMRzdwJ05S8j50D66wikd6FlI
	Q2iqXTxTwhFNXU/FL9GijREE2BfS0KsapnUE7GDZ6eG0gd7Zgdl0xebAfQ4Xu1EjWD6nLo
	aToto9/nNxgA4uS0++Wl36ztvBNtGiw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YzqYCbK6;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790031185;
	b=mfOLnpWtPAvrH5IVY6NkW8TW1STfdTmquGIvaVlrJfMMN/yjB1M5+H3C59/1XfZbc8FOuO
	QSRn15oYPzIUACvxmi62p5OItV8/F+ioEQNlXnPU9tyyGg4IrwBxqcecEZ40HAWdYvi674
	kLHc19X34Pl61e5PZnU32K2cilCA/aI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D37D96057A;
	Mon, 21 Sep 2026 22:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90921F00893;
	Mon, 21 Sep 2026 22:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790031184;
	bh=vr/gx0Gk1vpjpHWM5sT+D++JQRExEkJQGlPWeyGVKCo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YzqYCbK6VIEv4Im4C6xgjIzbiK246j5gGNTbeA/gxJmKzhCvtWP2kvF+17L0uRaHe
	 9vPeZg02uN09f8r+AS+I/MvdRcZkvexqG2w4jVdQpqn3c32VGwxf7ayQ15zilHy7G1
	 chR39CDncH1ayD3EMiA0ehzS0yV4nyaQlejUFI2o=
Date: Mon, 21 Sep 2026 15:53:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He
 <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Jan Kiszka
 <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, Oscar
 Salvador <osalvador@suse.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, Seongjun Hong <hsj0512@snu.ac.kr>
Subject: Re: [PATCH v2 00/13] mm/sparse: remove SECTION_MARKED_PRESENT and
 further cleanups
Message-Id: <20260921155303.0ac97f17e4bda6140079dc9c@linux-foundation.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C1E3FA0005
X-Stat-Signature: hjihbo9qdco4fxzsba1j9d5p6q56yycs
X-Rspam-User: 
X-HE-Tag: 1790031185-102997
X-HE-Meta: U2FsdGVkX18ij/wMghYOaCzptxyeyD+liE1K0g/5XzEyOkRvbpV7K8MaMwgVzYsdoWBMV6qD0IbX7xUYVK0UPaf5nIP9uYCY2vSI1oA+NMMnXQCQhvX7HVxoFXXRvpOrDaVQ7go0Px/zyFzh4NQO9JQyfOfZFjILc7AXbHFsmTiUg+5bOr0N5xIo2jrPKtmeNSLdkkI6bqG5U5OMOfgJulLfpuJUAU8eCMirAiq6o+qEaenwEq7W41ebVZDTUPvuqNZCsshUB9JaytfsOpmUmcjTUvO+exv+r1B4sY1bRPjObus6jaBBfbBunSffbwxS2W379hYsYbl/PfPOJ607E6wqUpPHmHZwcvxrgjG9tWx1AStX3rpib2j3ZUDyo4ax0gt31lE5iv9iUFmJk9k+k8VZh7/n1o/Zm9Zzflx3m+y59rK4cQ1vRSEj/Usy5lGGKFzjtWPkR1vAkEBq2w3xscC32h/pNUapzEub23ZVN5j8EZZq6EQgMVAhKSBBDJ3DRarT2Gf7VeTQ/4CYyKeRQJtGIlgAS4JBAd5N1YOWvYEpC4b/23NFN14hnBRF9zMmQojO9qit/Sroi32j5VHqn26YzO6zy39MwI8mN/CG6bE8Z48jHe9Q3gOsSMu+NYtRYXD0yKTaM3ihWsFtypRACEbPsvlB5kfEaYq3QXQkyq+bJ21gxl2+jw51GDodBlahb9ScDGGl48S3P4Q2+SIWq99jlvey/le4JyBdwgOpPzTSIx28jwlyg7ZRP2LVkVi2zZlbBxZpFulpRhtGxbTPrls4S2oqB/5CNI9co79qKa/pBzqJ92d1oB/OVssZ//8wEivrNI9nv4mJ6baPgkLTQ2hX/Li4QK1GqqjtCt2AbnuxCR0Os5qLbCpmDQPA8yHY/fOeDbl6U6H0nNo/ejtRoUHs1ege/BI226IRUCropqKrb08s6u7ZmwiO/BioRih+UB6rIQwUjeT98HB4W82
 SXFoTDiB
 RXCqGpXhcGnp+gNj0sQZVWYKYbdkSOiC6TjvJRjuwePLbMueAXrksbmeBsvsbn1ABVCsLE742tal+xvmtkSTTCdfnhvl7Kjjz5671u5CBfRAj25NTl+Qvp9wIifsABuHgau+XV08QjVIVtem8wFdB7p9L23vjeCBy21qwTDei7djM+Zpa016dOy4MYimllHzj+h971a+hV5VjXkrgGKP73gwZpjz+1YPqzVn96PUO1wMMOEkOkr72MzdYnnH8s1bqYHP1P2RNlK8EJRYVZXfRnb65M34BB2zBuMiliRjuSUlaeDurNSVeoZ27ujNTqtSTfXei
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 21:58:52 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> SECTION_MARKED_PRESENT is really only needed during boot, where we
> can instead just rely on SECTION_IS_EARLY_BIT by setting that flag
> earlier.
> 
> Some preparations for doing that conversion and some cleanups in the same
> (sparse) area.

Added to mm-new, thanks.



