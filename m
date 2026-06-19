Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58A3FCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 16:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7DA6B0088; Fri, 19 Jun 2026 12:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380726B008A; Fri, 19 Jun 2026 12:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 271126B008C; Fri, 19 Jun 2026 12:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 038566B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:32:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E15C1666CF
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:32:06 +0000 (UTC)
X-FDA: 84897204252.06.84FBF56
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 78D86C0002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:32:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k1DQGOE0;
	spf=pass (imf22.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781886724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AHBHs2KQRuZ/6gKMmOH77blzB7j8lafnQhny7MmeJJ4=;
	b=sirN0Ec/e1zazVb7L5leJQf+oBlDNkLK8OnCkhP7Wdcu+VLx4ZIoalr8v9fDWe+TArnhce
	rfBnFcp9JwX7jBfnzI3V4ZKSpIwnjZ7/hy1EPsMMCJh+eBj3b4AWwX8M/kcU4NKvLthK7t
	g6rdVPuxFK6jVBqIkj3i+VjERP3sAmE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k1DQGOE0;
	spf=pass (imf22.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781886724;
	b=yy3LMM3s1aj5R40IZwQOkHS7JTxpE8J1y20YzahyKqf0SUT2B06Dplaf5tdAvsK9BM2vmF
	QBwFXnU/lmDAUmU/wkAtp7ZZF4gDO8F9C6egPPQqzgFBaspZzTeiBCQmwO+NKsiQ5W06tZ
	X+e42eHnT8DTHoLUNhHuHPr/cUFdIwQ=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490c1915793so18508705e9.2
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781886723; x=1782491523; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AHBHs2KQRuZ/6gKMmOH77blzB7j8lafnQhny7MmeJJ4=;
        b=k1DQGOE0HC1yW2ITM03V9xk1AjPWISybhA4lxIHHfGtKZTQUNz2VI831+B2IRAraUQ
         gZKhZUFoMIeqf2aTkBuQ2ZPbPLh7RbI2of6djWgjRF2cB3htE8nR7EJcVRq3VpH6H9x6
         f35JdT15b5zYkIrGtL107jXkZQSrlalXIczrQnFLISmijg833TimBpZ6jbGw40EvwY/5
         uv2x4IPZVZdis04mJ3THGW97zuDyNLnuIjcz1FZ6Dcl/kNeX+GU9yAXDxg/E+F4AmcQo
         7fP5H24RYIdFyzHZmAblNcG4jLWfUCgsEzyPkhi9s1cj4ls2hNV4x71jGvNOp/Djnr6S
         uTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781886723; x=1782491523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AHBHs2KQRuZ/6gKMmOH77blzB7j8lafnQhny7MmeJJ4=;
        b=An5wh1hndV2u1pm8zIp6xSalnnMT/GR0eCxQRKYEPUJFB7dbVNYBsRtiZZCLX8hi7P
         Kkb/GSgkZX0xEWHQqM7ffBaa9oNbIhi/I6gCbs2l4wyEuuoGuUmgD+tUPt88ofL22vFW
         PZ82nXCxTjDIgzeMzf9JXDoobN/W/Tc5G5V/07x/yOOtGhvkFRLqxWEfYt9zRdtkZT5T
         RbtdURv06LprztBrG/9xUtsYxteqJiYhQ17SKF4eJGCPt4A2dPs+LmM4Ds2SKSg1XaVT
         clqS+ZVmmWRa9mpCAWJc5kDR3+Vu1qj4RLVE0VHUHTsh3LVmSD7nKwit6nJA9hWSvfS3
         3gBQ==
X-Forwarded-Encrypted: i=1; AFNElJ+HVdgMOsnxDqAFJ98inReZimeqJVaW52XYwAEb6lw8w4sVvntprTPYzPD+lWuT4VqpfRoxAgMepQ==@kvack.org
X-Gm-Message-State: AOJu0Yz9hUwNEYNXvwWsaajn99dKIhkOo+BCoiMKaBzmo2G8ZBRfrich
	4VSrSlalzWXHU3jLmuDak81j7Yo78lUtCAHWTgtctcsdnNCFI9XYNmOq
X-Gm-Gg: AfdE7cl+5BE2Z5B4N3p8yx04aIMBB6R4OksvHC1vNeUdfKki0Q9wwWEnYFgBChc36+5
	K+5qLzU5FcJKg/8x7df4csGhapI5bqtBhNA2h/ITI7NBAdlBfqdfx8LlEWhYRJU987uJWOrqmy9
	T5UpP6z8AR3/2blrUCSWPe7MUAascbz0Gll7lMM+J2Pw8QS2ZENogOtShAdDbKHMS+Q6Esn/InS
	ngh4wFdiaopdmOCOBbDNLB2SXhhSTYXCikpVB8/nz5nLBg9Nd4jx9r5DAw0DrjU1K0ELXmuCIlG
	tzoDsPsMhcfTQg/gOGZ5XsWkuf+Sr4ilS8S3LDT83KiUTLpRAekxR5D9la5hdAx8pRCJ/cmXAnu
	sLwSxILOqUDGFSr1RfqbSH3pmdfG7NcMIV07pkV5UWL6sBqWXVCldqgKn57V1Fc5XEk47EfEolg
	uOLQ8nfrjZREsGQr5lmLj4wen/6HntvfUOZEIc1EiSj7CSc0MehDeslq0ksZxE0JjsskrTtxybC
	mOl6BTn5JMCRUk=
X-Received: by 2002:a05:600d:8653:20b0:492:488c:f627 with SMTP id 5b1f17b1804b1-492488cf6c8mr4844785e9.11.1781886722745;
        Fri, 19 Jun 2026 09:32:02 -0700 (PDT)
Received: from localhost (pat-125-253.wlan.net.ed.ac.uk. [192.41.125.253])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fc47b48sm82606645e9.0.2026.06.19.09.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 09:32:02 -0700 (PDT)
Date: Fri, 19 Jun 2026 17:32:01 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Shivank Garg <shivankg@amd.com>
Cc: akpm@linux-foundation.org, david@kernel.org, kinseyho@google.com,
	weixugc@google.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, willy@infradead.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
	rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
	rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
	peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
	stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com,
	jic23@kernel.org, aneesh.kumar@kernel.org, nathan.lynch@amd.com,
	Frank.li@nxp.com, djbw@kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6/7] drivers/migrate_offload: add DMA batch copy driver
 (dcbm)
Message-ID: <20260619163201.ldbjaqcphke3fcvg@wrangler>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-14-shivankg@amd.com>
 <20260619160725.lfcxrbj5go67qy6u@wrangler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619160725.lfcxrbj5go67qy6u@wrangler>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 78D86C0002
X-Stat-Signature: 9h3gzgjj7go88n5r6u1o3q3sf8sg3o57
X-Rspam-User: 
X-HE-Tag: 1781886724-657942
X-HE-Meta: U2FsdGVkX18LzFKKE2iCqlU6HCZn2GXI5bunSU7ZTrEFmocVKn7KYCREPBJdu6A0EfPQ5DtEonk4LGCWrM9jEcS/ul7QDLf/G3KeYMHf/TaTe13nVnn3TITKCGCRqKBytV6rLrnzGUnsfkXnhCR3vETVapaVI1yTyFEJ/33F6NUv+J+9ua5On47E5M9PePDtm4fgT5T13tbKOQ5bGnSLa2Jxi7g3VLbPyr79s+9omqWZ9Ut/vkvG8HY2I/juBfOrD8hC5X9kvaq0dPpMNEnW2aOnV5FiNwVba4kTza7dcnBI0Az/L9ofgFh9Ivj7PX6alr+GgJWsi4kI5mQL+f2ZFypY5Qx9vAKHMO7NOz1H5Jq1SJn6SFv+Ly2J128xomcJ6q0UAhEBrLtvSCfeKQCqXCqWqfL5ekwQb6xQ3dW4z0oS2HRKRMF6p6xY9V96RHPO2aoOHvJA2s7bMqTzaj5qmuB1Sz5NJYuW7BpHi6nqBhrIURimu6RDcY7VVz32wLoFYEGkRw9qF9vNBS3f5HNA0LRRbkSgIKixo4ZGGf6gBfBo6jDMlU2mtV8PD0T+MPH2esjP7epuGzHLHr9Gg9aHCpWrJ5o3tJz0/EqpNX8Gd5GMv1atROhn5S3kSU6NZ8jlB/KnNWDwv3eq4qWL5epWXF28V2ZuDKxouGCSSU9L4DLndCPdPOxwY2LO24O3YgJSUdKGlhL5HpAU09Dm7V3mF94wKdt8bQph76Kzt8J/5g7gwW5ycdsTJ0BqmeM+T/VvaT6+m9+tdrHUrS0KO5oJvIa7yWzx+w950TDpu2+ElvnHHwm+gdl1lhyE4Nt3EVQpPcudSUgJMufjZzqC70y0XoW0YAkwx+LII2m31oWRPnMhWmEDi9v0JK7o8IuWXlsxSq/vabhMDyTyoZJtweMglq1onOpdOPHXMyv/cw6LPxS3V+m3nQ2R0BhPr3YWrihOofHoARW1p46x367wUaN
 +nMVrwSJ
 rnolII2fts6dBnZjsMoFhF2FiAC7nlyMlbOcLw2+jJ3mUE3lLwYunFU22EcFK0JkjpWj9efeqSluDRZaOiqqvDy2NXlna8l+dp9QDwGw21Gx/u+e7zYXDejxODEt/+3zxGoLu8BV0R9xjmjjQOH5qITtL5ZAk0y02eJFcKECLXuBy2x1scAEcENJjQhekUeXmltBaj8MhIOQWPhfCMukUE9gTev5vFnR5pohov7hQYOS9o10UOd/j2JgrQv3UVZQC8s/tBVGmJBLOqTU5wo/yjikMwRfK6/VdOCa7T9kLxcOrDwISouHz4RiOJ2rfea13kar1GFI+PibNZFYOrUcqW3E0lw2nUHrnBmCl2nx4uKX2VpCYyQUcErJ1MejqCN0H1BwQaS9460t5Pd8/fLhDJ0gkK0oTWCKn/oY2p7hfL/oriwzbxU2/AmUessm9hCRkNPQ0uPRQnSyfANXsdYCK1Ll8phWh6BLL2ybSdZS63q2oNpo1LZ4w/3/b0fUjQzP/5CPbeeyuer0cJRc/n1wa1s3Y/Qu5kU4SZ+wTHrka+ua3h+06gCQgG5ZDQgsHm9mRkpBEA0Z7WgBVwyofLa3SqXKEzbWquSJsfyQdljqFebYs86B8O7JwUTA6UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 05:07:25PM +0100, Karim Manaouil wrote:

> Btw, waiting for an interrupt adds massive scheduling overhead. If we
> also add the logic above, it'll get even worse. In my measurements, this
> can easily add up to 6ms, by which CPU page copy have easily completed
> the entire copy, which again adds to the list of latency concerns I
> raised in my other reply.

Sorry, I meant 6us.

-- 
~karim

