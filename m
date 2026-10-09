Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B281CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 23:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C091B6B008A; Fri,  9 Oct 2026 19:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA006B008C; Fri,  9 Oct 2026 19:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8026B0095; Fri,  9 Oct 2026 19:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CFCA6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 19:28:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F29EA1A055C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 23:28:57 +0000 (UTC)
X-FDA: 85304680314.24.9E5CEDD
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 264F41A0007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 23:28:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Y80VY/wO";
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791588536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8fGiA3xoaDWPU6XKjh9IcWOAynrlR15W4KHQ08CPA0=;
	b=TC6rFciLhS1Etd1duR+XnnVWcahs1GzTZSnzxj1oKC0oaPU2woZzbemJldTuMBcNiUnWwO
	8G8d+GHHp/MKScytCiH3T7S2zvb+Ku1pR4pjWN8BekqH24+eWgbfV4siCWhQlZFK2D3/iZ
	NAcR+Aj4tSuySZNNMyzLhV5aWl/xGi8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791588536;
	b=0Pc9/03Sn/sosVh3V0+DSBLiNAsRp9f+Ir1aMAKD4+D03Z687D7P0qsOu+DIYqYxcJA1YF
	++IFqeeba/OsJORty7mEsdNS9fFGfWPHKYO7XYiOvWZOW7nPTgL4w3eFzVF+Q8oydjRPSl
	nw3S2vWUabOGJ6hg90BArVk1DZTNDZY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Y80VY/wO";
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93e4c00d71aso14676285a.3
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 16:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791588535; x=1792193335; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i8fGiA3xoaDWPU6XKjh9IcWOAynrlR15W4KHQ08CPA0=;
        b=Y80VY/wOL6IVU5Fn5wwn3ARDAL/aNfXZl7aTb87jsKC1ZkF+nism2Fnc2NhD2aAXGz
         wX0Wm55wuu8S/MotXlWItZJyUf3dnMcEyNu9+llC9C2ftS6Eog36WHw7w7KuShQbnaL1
         nHL6Mh4ZzWsqK/eGYAsurEdTuUz0uL7QdD4AT6MUsSmgcCCe4kwUlWoDqcXD/chnwIsG
         JzRqlXXNjwuLJV1UbNBD4RAd8TICz+jbbuFKSuw8IK8KaTtrCbboQgdGqNVXwFuzA7Xb
         dcfU3GvDqJ+dnfNb5ixSELznbVWh4Z2isalcAnH/M3u14HbEVRqYUq8uf+0vaa2adE8s
         p1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791588535; x=1792193335;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i8fGiA3xoaDWPU6XKjh9IcWOAynrlR15W4KHQ08CPA0=;
        b=OXlUj+E5ucF/CFW9nZftXjwwy1cdBHu32hX+0GiYoM9ZhFx8DDY5lHQpoxej+9KQ/k
         cBo45wiZ2m05qVQvsk2JqOY/P1MkTEb/v9Q0G8c1WJlHZh3as3VnMbW1r8i8KO0WCtK6
         xZ+36ljJ75iHfKnqORDoSZojIk0VS/W4M2QFPA8bt+06E98JjZs0NDWKeqHt5kSTbKUw
         qbRGn7/ZrFggZzoWtu4gv3DHmR11wKUGP1g7ZMLAvcryaVVtDirh9OIvwjxcO7vNkZJw
         5ojnEWxb7zj9fI8y+XcDitFEnwzULTkdtQWU/PMOwiizjHLD9j7eZrqpwCdv21m1+XjP
         bZrg==
X-Gm-Message-State: AFq9FYI8YCfws7mYVqb2UGz8M5yHJFLBMMq6kvydlD9py4edaZd5I54D
	ZBB2NpOXJwExr8KyVZL44PvYrcsDFTWgcIseedngW98x7L3TTGALXN/9yozSbb5VG7I=
X-Gm-Gg: AYBFou14G1NMUtaEv/ZXV1a4QK2yfuKzP8hFfu0qe7u5U9wFRfJI28/HJ5noF9ogj37
	OVkvO+8S8BuI04HEFtialTIl6m95ezIX0MENJSBtm6ZL+vgg2e79uk/QakRVuAyc41jmLniOuOe
	lbbs294kRBRWW3IZCGsS4tdU+L26QktrDBTEOPDabzoU4oqOXeZ6RezJos2020NVN3LkoJOhozy
	fKm4NLpaBRj2XpFd2DuwCf4r5L6QuxFLXz0Im0vYnFx3IbyO5Gt0FbK6VXuI/7OKaiUvfkuRQZg
	t0x/kwKu1BvpRs8N2uLmImJykFSFUjgyeaesMY7lmGox21/Q4Rm4ebMDgI5UTjDI5cH9aH5uy6v
	SHo1ho6g+4JTJ3XGgZZA7VqR8Pv0W02NP9zRAWs/nRHPvacODzUsQulSeEUCDqBIkqPNTiV+kcs
	IYujMeLXPSbniYsW80gfY9yp7Bxqgl/cFAWoq4scfI4L5SoTrsWavPeHZ2wS3Gzf43J9x1fomVP
	1o4cV2iIfq9+uGXnJBpefssh1fLqxbeReL3+BNEAabHGkAWmtNq4xI=
X-Received: by 2002:a05:620a:1a1c:b0:93b:d7a0:d9e4 with SMTP id af79cd13be357-93ebd263d45mr580212785a.62.1791588535148;
        Fri, 09 Oct 2026 16:28:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93eb984889fsm301000185a.13.2026.10.09.16.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 16:28:54 -0700 (PDT)
Date: Fri, 9 Oct 2026 19:28:52 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, willy@infradead.org, vbabka@kernel.org, 
	brendan.jackman@linux.dev, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@meta.com, jack@suse.cz, akpm@linux-foundation.org, ziy@nvidia.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, 
	surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org
Subject: Re: [RFC PATCH 0/6] mm: pass alloc_flags through folio, filemap, and
 bulk allocators
Message-ID: <asloWFM96BATH8SB@gourry-fedora-PF4VCD3F>
References: <20260923211041.3127588-1-gourry@gourry.net>
 <asdTptfeLkuypU8t@gourry-fedora-PF4VCD3F>
 <df588805-6f97-4ef6-a64f-39222669bf3a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df588805-6f97-4ef6-a64f-39222669bf3a@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 264F41A0007
X-Rspam-User: 
X-Stat-Signature: cxpj1m4tr3oryb4onx1w7auwwjitofp3
X-HE-Tag: 1791588536-371625
X-HE-Meta: U2FsdGVkX1+C7cG+ANQqnqp0zUqPE/XGVZTOEIUdRTIbez+kRnmDxJTbI2uTPg5wQ1JwKmQVeYj+Mp5uK3NS1CFdin/XvAVAmt+1iT2mCKV4XDuIfn0Y/hEy+NxH050mmNN1xoEUGcjXcOQ2sUc6lXdQnDXUZ0qCyhurUNRxfa9/fKDeNscMoJrhwmUzE5gwTCoWDibTSNdPNg2G1U1tuJFisBf9dB7xCvfjHDSdFJs7yniTVXCRqjVaz8xJfEGz9XaH/bgkfqiSEl/ivVyhnfMxR6UwRluEZXpuKcm/33y4v+pl/zs8aQu9RY/gTP6DHZ+zDD8dWszP9IwkY5NJyus5WO1qYpfL4btoRx0dqMYluHnPptVaHQS0idp0Z/yLW3XxBJMXCAiukZ+Q2xjreS+OaAM1h3o6lPnb8DYueX+hogbLBUNQ74EJinhTfxwUiVljWkJbKo1Te0uH6LOE8+SjKqGoRZKfPlAES7NsYU2MfE3FM8PuxoPftwlbgvcYQFfDPCpLNAcTDfcq0Otma47fBjfU52hC2qHloF6Z46LF3VYs9kS7co7uxCEA9/3ogoqfKDN6LEK8BT9VProGwBsZAYk6lt7AnlxzWjMh5bpPRvQ39xDFtssHflWkZzQuldBpH+9+ZAOezenRHICGFU4R8FMfVgiZK3KId67q7GgrtEcDWxwK4LSWPWSvt4mK7PDidtV9aVtN/B0QabuiSh+vZRpBeOZwMFaDwdhvPaMYGfvx1Rf4gIBA1TzWqW8z59Z/8vlbpRPvf7ZANFKn8a5CkhXyJjj8QdLnymH05du6p+xINTIxpq7tkVmJdEknYGXcLidjypHr38hArK3fbyvUR4NTC8n2YIg/VPUQsQbnYgqw1A+aUaXIYS0i4ja9lC3HBz++bGVQ6Uy6mZaUN2kOKqZ5+M23OKIp20ewcxRRnl015xCjOddpmOYZNIZNS6yGtRyn7SEnVZU7Cgv
 +ajZqrB1
 xnkqsdz+Avb0Pj82Pr70E1r3VeNxJzObGAf+Svbl7Wvi5VqxLYFyS7xDECp2brQfsu46Q+9/8NkUBichCCZHzhGkEHRXeU0mI9W07cyn0t4SYLD8lmGBIlx7rTxog43EoBi7QIlmrqK3m9yvvvEVGmkKwHrTGvgydPf2syUZyr0c9rQNbHqVrOyDW90skoLllj+7ehUL//EpiW5Bo8VehfLrBgOCTbxKSqFaPajAYl1ukGCXzWa1PK5NzhOqQoGHnicuPP4s/HDLZujQFwgzdfh43nb1OA4eEW3YvgJz2TnaQ4xX+9WbrrACK0qNcCfwgkap+fAdeqNN1jJ6A942WfO/beabxZ6pYBUdL5d1wOv6pjY0fUASoUYKUfLtbE/fLNA4C/8SOxrty0trftVVDQQ9IyVlhYiBdEeKMsvFf+A3jA1Wt3zmuoAM8LkzVTnx9gOlaZVJ787zQVV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 10:55:05PM +0200, David Hildenbrand (Arm) wrote:
> I do agree that two sets of flags is suboptimal, but likely more flexible. I
> guess an alloc_flags only interface is not easily possible ...
> 
> I do wonder whether it should be:
> 
> 	typedef int __bitwise alloc_flags_t;
> 
> instead of "unsigned int alloc_flags".
> 
> ... while at it

Does it make sense to leave alloc_flags to internal-only state
and just implement a new flag field?

gfp_t       -> describe the page (fully public)
req_t       -> describe the allocator behavior (mm-internal only)
alloc_flags -> internal allocator state only

typedef int __bitwise pa_req_t; /* Page Allocator Request Flags */

#define PA_REQ_DEFAULT        0
#define PA_REQ_NOLOCK         BIT(0) /* from ALLOC_NOLOCK */
#define PA_REQ_NO_CODETAG     BIT(1) /* from ALLOC_NO_CODETAG */
#define PA_REQ_SPREAD_DIRTY   BIT(2) /* from __GFP_WRITE */
#define PA_REQ_DEFER_INIT     BIT(3) /* from __GFP_SKIP_ZERO */
#define PA_REQ_ZERO_TAGS      BIT(4) /* from __GFP_ZERO_TAGS */
#define PA_REQ_NO_FALLBACK    BIT(5) /* select no fallback list */
#define PA_REQ_NO_OOM         BIT(6) /* do not oom */

Off the bat we recover 2 ALLOC flags and 3 GFP flags. Possibly more with
a bit more work.

Then we get:

#define PA_REQ_PRIVATE        BIT(7) /* allow private node allocation */
#define PA_REQ_UNMAPPED       BIT(8) /* page must be unmapped */

And we might not even need a new zonelist for private nodes in this case
as long as we require internal users to pass PA_REQ_PRIVATE and add a
function like

folio_alloc_private(void *owner, ...) {
   /* validate (pgdat->owner == owner) before allowing allocation */
   __folio_alloc(..., req | PA_REQ_PRIVATE | PA_REQ_NOFALLBACK, ...);
}

User still has the option to request NO_OOM via __GFP_THISNODE :]

~Gregory

