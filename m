Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F31BFC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 19:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB206B0118; Mon, 29 Jun 2026 15:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C266B0119; Mon, 29 Jun 2026 15:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B326B011D; Mon, 29 Jun 2026 15:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70E456B0118
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:53:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B56161C130F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:53:11 +0000 (UTC)
X-FDA: 84933998982.15.9682085
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id E44632000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:53:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=arGrTuiI;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782762790;
	b=2Fh1xBwDv3VxTH8+8RIsQCCIhUWNj7NAhkBDOj5OYOqD4knLog0YUeL44jRmv4Ig7x/Tap
	gVR0nVzaWpP6Epck2lFbnPPThnf1Fo94UpQm+lKT5RK1CAjRSfMxIRVJe9b80J9Rno6s7X
	avBafDYXcAeKInH2uWEHNIajWb1acik=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782762790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNyPam/FsnkzGAwne7t+tXMAiXG74erD3skBxsmre2o=;
	b=zBWYGjceBG6qQkovwtN7GtSkJ6Le08jp8jl92zo3m6/a5Xk2QLcC4RFv+W1nMgmqUnf73m
	1+AIRsvfkmtsk6FVBX8B3vhOV2JtppdnxUGNR15CwIfI++w2kToSsLgnKH7aEFjn3Hi2JG
	hbT58EbaxPVKINIp0jMUOzWszXJz+r4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=arGrTuiI;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 29 Jun 2026 12:52:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782762782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eNyPam/FsnkzGAwne7t+tXMAiXG74erD3skBxsmre2o=;
	b=arGrTuiIVCZPpfVOVWxqJXYrvPgtzqxDl2sH0/LDKUUHDu8YyRFkAO04t5PQRnBTwHWPgv
	wGsLDBkXPkqwXmZfklhBidCtnzSwhuCirgEqFtEviEIzVWX9v4143rT3FCUnXZCm3coXQu
	ifUIbT3h5J+yGW/qW6vrAkGfBtqNZAU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry@kernel.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
Message-ID: <akLHy58hrzAC2UIw@linux.dev>
References: <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
 <akCJRTnmA2um3CIy@linux.dev>
 <akCSftF6mrsKsz1V@linux.dev>
 <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
 <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org>
 <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: p6knh675ebqp3b6i3ycuk6cby98et6rh
X-Rspamd-Queue-Id: E44632000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1782762787-515508
X-HE-Meta: U2FsdGVkX1+QSqa9/++Yzu3ZtucWBuu3jK/qnHQLNivywGgsw3tPZjPq/TJUs9GZDZZf2PIK7OikzTStvA0ScNq5tMp6tLA15nxP4Ex2lIwC+lub7zPMTGEtSy6tvrW13xP4V/SKRDg9Ij02u5DngQEWZl1jlIrdAR72xb8kUBpJhlqhTFr+HfR5ivX9h2ykYlXj7xKQ4DKWkAfdiCPmBftF7oBQNKrjNXiUHivwk5JQikPE6nXxmONv3ysZqDGAx4nJaeHoyeXS8EllUvLRCrW8bq5hcJ3nh7H1zTobOHHogqPx1C+tznnWq2urjZQbJ7Jj1OzSM46UkBpTCEJyq6FRBPFf7Q6yGOOgVmhk0zxcbfYVbwR5ZD2d3+kdRS7VGh/3uAaOhIXOBIJWAmFX7JVK0JRgihBd2RRNwLon2n8hdd4ZvMcMFyVNg+nBR/mg/pweW+ixppKbebxNkI9Vn4iz2NZ5gBgsZGtvs8ptz7khgXKCYKrF1t7NK2wNLH7jrkDNJJS2Kf81PdAOWFN1SoemKNxDh1BRcHgNDH/sCJXUZ8ABpeVlMn5Tg9BjWWSeO1jV5bqC8mSiKT3ZvlnF1uT5GpY/wxXe/hu2EW7BfaFeQsA2LkamYea8jxnuM0hBU7U9WICtbHEsBgA2e1DwCgvBscupH1LmnVpFzs18xBUBTfGgwIqznbq2g9Dgv+RsRWwRqPH0AUN0F58xq5mjQ5DLX4z8CupDmIsP1O0B+k2MdnA+A5kdSdiyqwlQSs7Yqqi97yFZItbugIbiq6Ze/2eQSEvSAi9n7Un+RH20gGvt0paospTqo28p2JCAnVZNI8p61hhwe9ei9hj8bLxvW4Y9wiN9EbWKpEY78wB7acsllcjVy5rBV1dp+SLPe3kYfjSSAVBITcWvNkZKYzAiIJH/lgBstzRHwWnvB9VVE4iRY8jyXQdSyR73uYsuNAKQLGdh7c8FgkTZLSUvNPX
 EP5O7uqn
 Ob/qtAKFJIQ0gdbfW/tn6zyxemPn1ciEQ002cIbdHKP4l7BfwGLzCzOlj7iRAPNT0dWYc7ij6oKZzFv9Fc0g2zEKKnSdOjKOYYKs3cZTV054Lhw8oH6nW8Fg1siP5juTD5xL/ceywgX8yPJuD9OWIIL0dSM+DhKOf+CDrotqOwDAaCvbj2BsKtDwFCedXcdrHxB5YtMhdsJB3ZG5bQ90JxM3aSi7RXuV2R2KJdY5lG6tDWa/AdddarhllVgwzMsMbwgMEXJcGkQZ4TmH1WacFWrzA5vOVXtf5zT1aN5hvosrmzgCgInGh7XRRsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 28, 2026 at 09:28:51PM -0700, Suren Baghdasaryan wrote:
> On Sun, Jun 28, 2026 at 8:57 PM Harry Yoo <harry@kernel.org> wrote:
> >
> >

[...]

Thanks all for great discussion. Let me summarize the conclusion and please
correct me if I missed something.

Let's keep the original one-line fix (serve the obj_exts array from a
strictly larger cache, making the relation a DAG). We will NOT gate it on
mem_alloc_profiling_enabled() as I floated earlier -- per Harry,
is_kmalloc_normal(s) is already the right condition, and gating on
profiling would miss the SLUB_TINY + __GFP_RECLAIMABLE|__GFP_ACCOUNT memcg
case. So the bump stays unconditional for is_kmalloc_normal() caches.

This over-allocates the array for larger caches, but only for profiling and
SLUB_TINY+MEMCG users (the latter unrealistic). Acceptable for a small,
backportable fix.

thanks,
Shakeel

