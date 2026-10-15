Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89DF7CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 13:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632706B0088; Thu, 15 Oct 2026 09:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E43B6B008A; Thu, 15 Oct 2026 09:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2AB6B008C; Thu, 15 Oct 2026 09:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23FE66B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:48:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B4AA21A0A5B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:48:15 +0000 (UTC)
X-FDA: 85324989750.23.F025724
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id D41A820008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:48:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="gcob/8Ef";
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792072093;
	b=YsZhP39zju/SnqofENHHwgm6KN62vLDxNaKPo8QXxkrdaVo2BSM662VijKDDJD3/L83QIj
	hE5psTrK69YXI1b0ewNcGSPR2JLiESl3QFUfrnRNQ3Ok21CqDaLoS7J6uLdbLu1uPRGka7
	OX0tYL9Tc2Rimjr6Dx/d2m97T5BTOxM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="gcob/8Ef";
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792072093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TxnvmrOxX1kKFV6pDOanox6haeqxL61LHWivdGG7JgE=;
	b=ILTyEesh0nvOIun/Ah9zuRdQnmugYWVLm7IgV20GEXCAkQL1TauaVWExg0rvHHK2/+BiBO
	z0U7vbdG35lV+hJkb78aOBaAg31BsN4zBOV3RUhCJiZlWds5TFQUTeON4WPOr5rs6QjhSL
	Xpg5iAW8mVs42VP4kktQB2mqpQO+avQ=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-917a04338c1so56859646d6.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792072093; x=1792676893; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TxnvmrOxX1kKFV6pDOanox6haeqxL61LHWivdGG7JgE=;
        b=gcob/8EfcYiqHA9Ih2evqGkEh+pZpn0oHambrOeR2YuSQsNoBSosIlCx8WnmQopcw3
         B7b137BwtpROqsufMOhfmZcEqruQyQaDKERCzdmGV3queG/RAzFEgL28lRYBbCe1Q6QJ
         NDNmRKJi1wtyq4S/ED298xTEdliIj8rWHZ2HusC7sjTTJyc/3JtMyfXdaDBUagogYMaX
         y2QVXoaVqHIzrToLQGZI6iF0SvBXLqFisNvkq3x5J0ZpPM1e8F4jXNT+mts/jtxGD1JM
         FT2Lxu5FVZNzVGlljHiCvPyn4Z3Rf0DrNjUu6W7/R90ZyJNN19e5KFeShZY0CAlzehVJ
         fcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792072093; x=1792676893;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TxnvmrOxX1kKFV6pDOanox6haeqxL61LHWivdGG7JgE=;
        b=kSM1cC5z77JQhryv0ISZdHEHAITOLq93AW6vCVfi/mnwVXbhh2bz0yTJc22lOxHlZk
         AxkzGo0JF6r6iD9Dm1oD6ftZv1fmMeFe6kLVGoOnREp9lzEU65xhIkDMdcSU493AlPM1
         WRd8F3EQHg9rpCxRJ2sAAGuZ6DTSScMGXTUsp8Aswe6dm23xzGXa/M6uOazsp9e76+um
         fDpLOJdKrjn8qdga5FG0yjqfrJeY0uEA4UsXU7h1S9DpHPyJ9buJX0KznZsKcTb2lXY7
         nC9W+qsTmCN4OX3NlX1+YkJTeIr7TEuH8YITDnB6iJ4zdla0N5mWYJAFUh1YxACz2dDF
         EqUA==
X-Forwarded-Encrypted: i=1; AKwUvBxn0PrIUz/S+Hro1Ty2nkYHk0h3fJxwJ6MPBoeqxGri4Whp0by0xmafSDSEvAJKrZZygDmEF2lKgQ==@kvack.org
X-Gm-Message-State: AFq9FYIp4k+HJCFgvZoD8cAkCnfZl0B6x/dfB35C3IYKJ7QqTYwkl5fM
	Q654HNaENPdwjPMEYpOe8eS3LWQbkCfuNSudYpfnfgDQcmaegFUXMEF8uvUa4zsfMGw=
X-Gm-Gg: AYBFou2jimCnGeb7Rw/B6D7Uw3LRjGnUCxmCdlqE59R6+kDaoGYnmuryOEmqz1xNpPI
	igTHjPS3moSvvQ7SvYZD96cq+JyaLq9RX47fmb+x+lXR/cZDPblfMer77cqm7TTYhD+obxYVb+j
	6EXMtXNOSVc/hgGKY0UAs9vQV9/rCjqo9443K/fiaDv0WXx9hUs2X1y3Q2T5b/9K5MuFerMukDK
	oCmxma0ufU9IwjIGNTXLwexukRruqF548XLuvfepzU+wRiX1UMQdHw0fayNxxC8nhcwNQNyghtw
	6uC0sqGfAumQgLiMdipXemwtOPjlCAha4LJ+nRZFc99OVWOljfBG5mLb0mJrofkQ5R1m72E7Z+1
	RTBPSBF4+yI9Ily8OBJauiQAApmdHVBujGTTtqJLCH0R6/K6ahWfxotLDwWvTNNPnFQj0kIZzIW
	sxY0YDiZCfdVsqfdyYOFu/aH9Nn7ScLjhs31uAQjSiusze61oc/0UFNAVaukQd2cqobs+fjImVo
	xbZB1bpYM1qwpmkiEoG5i8cv9p/IyK8dljvUpRZeGxCRc9akgpFpM4=
X-Received: by 2002:a05:620a:4606:b0:93e:c12c:f12d with SMTP id af79cd13be357-93ec12d0608mr3020561585a.72.1792072092737;
        Thu, 15 Oct 2026 06:48:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef50b6c4fsm760019685a.47.2026.10.15.06.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 06:48:12 -0700 (PDT)
Date: Thu, 15 Oct 2026 09:48:10 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	willy@infradead.org, brendan.jackman@linux.dev, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com, jack@suse.cz, akpm@linux-foundation.org, 
	ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org
Subject: Re: [RFC PATCH 0/6] mm: pass alloc_flags through folio, filemap, and
 bulk allocators
Message-ID: <atDYiLYjF_Phxy-h@gourry-fedora-PF4VCD3F>
References: <20260923211041.3127588-1-gourry@gourry.net>
 <asdTptfeLkuypU8t@gourry-fedora-PF4VCD3F>
 <df588805-6f97-4ef6-a64f-39222669bf3a@kernel.org>
 <asloWFM96BATH8SB@gourry-fedora-PF4VCD3F>
 <1f36992d-00c1-4f74-9947-b543ed794cf0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f36992d-00c1-4f74-9947-b543ed794cf0@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D41A820008
X-Rspam-User: 
X-Stat-Signature: kmxo7ktb4exafxqxwmibx9e8wf5qhzec
X-HE-Tag: 1792072093-611077
X-HE-Meta: U2FsdGVkX19HUevlb4e55RCE5dkcxA4UFrbmJ6VzhVC6a/NeCgPz5+MPHVdEicmWfwh2xJc0XUhSmn98P0QZ4o8xqOVXaiCPPirSpJmeXupkA4rhb4qMqTSTg/DU2zALVs5ONI/9to6nB+6ZIv4hXR3dhhANOh/nCBup8s9kufVC+g4vJ5HKeo0cDgzybxOLblZV2hqh5x+lp1+8Yaj11MphHTamBQChHY8flu6uYEWw1kvB/YsyAGZv0vHE74yxobWxeW1amPbSRut1kANwNtfWunGS3WrUpNgs7deQuh1aa3hpdZrozPyM8Fg7cQKYs+/Yz3xsYRaGUfIukSPZOT1oXynpELlyjbrV5IfTF70pKP4LBPLtaVchlf/dbWxmzCLNnmL7nwYBPlsLw25n70mBD70/ICu3iGtZS8jmeLnWFf6owb31wtPUlH0EY2uvxoXdde7GOxasG0zl4EjOSJ3ieMYdCRIG1572GNxUvTOa4UVkHSPK4aYsTWThcpTefdOjgCU0nAt2ExZocOKdbpfc4GHDb367KqlUzcC9oJS8m7WXkfttphLpR8wYk3YUNa1sYTj4mfLqdFaeIEHgsmjrtwgdBMP8TnJ007aI8XuriqEO7aGq7u9XMDAcPjXq55IQc7VJ5kKuoBCLcmjZpCIAYcxiui4YfdalkbgtKxfhCLmKJBCFlTW3zxxABQHElqhz3Im8QkfQvyeMmdb0YXQJb/jb1fhM5NvfQ7kkmos6ElAKlpKr7AOYR+FhevIGcxiC/d2hu/F/ELam1CkqRlFyImhagsVnSfcPdj0hdfreMIXhzKtyb7v1O9WpV4LUsatdIf4eBHs7A4Vhnx1kSTWhDY2LJqGuInZBhriuyLCm6Nvt1M62U6GMOAlTQ5FD5CwQJrics8DcVqH7WgRNMBW1WTLHwoZs/MSmFBECOAdwSuBZ5T0jlqs6LQy6sAXBe314vntnhTn0rKw+cFi
 d1fxP37o
 XP72fYjToOrhAE0X9N80CTkHI4jjNXnE0E2j8qAnD9OBgqxvx/xIUWJJ/ZBp6ywWM4Iou9dToC71vPaCoXJv/O+378LfU9EjZBxQWiHdQWpNqPdrQbe+oLdFrc9MDWO/RUf6ew3GusAm5vk0FURUoDIQ0b+acF6l+ItWjkbx5lRoaiQu/iOpYo+Q+1K5U0RprlrZrtJgvg+WnFapb+bYjLWGqvaUV+jp+9g8idm9wWgvJjjqthzZg1/Ph0fFeLidDbYeq5+q73e7abXkW11J2PKWDElESgXY4wbABXpUzAwjqquQARlhoLhtV2lPakJDhz528Uj242IGtsO34hSuXeI6RN/KdnO8pVkf0X9hB0QGJttlafODzSdODSfSCoJ8uOaoEJfv8OKlkIkNWI20ytw0J2Fy5HWrWtlGWNA5dYSgigXUxVP34i5LlC253//0pDpBvctayGgOqQ7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 12:02:06PM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/10/26 01:28, Gregory Price wrote:
> > On Fri, Oct 09, 2026 at 10:55:05PM +0200, David Hildenbrand (Arm) wrote:
> >> I do agree that two sets of flags is suboptimal, but likely more flexible. I
> >> guess an alloc_flags only interface is not easily possible ...
> 
> Agree with the alloc_flags option of all the other options.
> 
> >> I do wonder whether it should be:
> >> 
> >> 	typedef int __bitwise alloc_flags_t;
> >> 
> >> instead of "unsigned int alloc_flags".
> >> 
> >> ... while at it
> 
> Can't hurt, but given how it's internal only it didn't seem that urgent as
> for gfp.
> 
> > Does it make sense to leave alloc_flags to internal-only state
> > and just implement a new flag field?
> > 
> > gfp_t       -> describe the page (fully public)
> > req_t       -> describe the allocator behavior (mm-internal only)
> > alloc_flags -> internal allocator state only
> 
> Maybe in that case the remaining alloc_flags should just become 1-bit fields
> directly in struct alloc_context so we don't manage 3 separate bitwise
> types. Or more bits in case of ALLOC_WMARK?
> 

I think that would be much less disruptive.

> Depends on how much work this would be (and if you want to do it) and how
> the result would like.

I took a short look at converting __GFP_SKIP_ZERO and the change has
bigger than i thought it would be.

Yosry recently said ALLOC_UNMAPPED was being put on hold, and for my
base private node series it seems I will only need to extend folio_alloc
with with alloc flags - so i will probably try to split these efforts up
and carry the minimal folio_alloc patch separately.

Otherwise i'll look at whether we can move some alloc_flags into
alloc_context bit fields somewhat cleanly as a first step.

~Gregory

