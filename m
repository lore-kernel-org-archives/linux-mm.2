Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7420EDB7CC
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 08:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04E76B0088; Tue,  7 Apr 2026 04:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDBC66B0089; Tue,  7 Apr 2026 04:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18A16B008A; Tue,  7 Apr 2026 04:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C291C6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:06:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53204BA913
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:06:45 +0000 (UTC)
X-FDA: 84631028370.29.4283C6C
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91435A0008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:06:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=frNkA8O2;
	spf=pass (imf15.hostedemail.com: domain of 3EbvUaQkKCDAMXUOQdkTXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3EbvUaQkKCDAMXUOQdkTXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=frNkA8O2;
	spf=pass (imf15.hostedemail.com: domain of 3EbvUaQkKCDAMXUOQdkTXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3EbvUaQkKCDAMXUOQdkTXSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775549203; a=rsa-sha256;
	cv=none;
	b=E5ti2NM4TKxzJn2nE3nnl8aOctcJeEEvbbHQyMHPHNzKzcPu1d2wha2j6zli5tsM9kATXL
	meX3ubbXuQs9FCYmJ1OybWb5yuH9C7BbuCK7X+xub9aL3FUeC1uUyW6t3tPdMXhljlnEZc
	Y6XfM8szHJtf41Xxn0rW/HfHPGigzPY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775549203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZiARTJkG6bieAVjpVY1nM0z1Q63xfD5pEAGan5ewDbQ=;
	b=OyB77gDiMHNr/AGYd+ezhff7mknAG34rOQq2Se6lz8jlmGa1VaIQzCyU/yQxvGBb3vJrLU
	pQsCuTurmMIOXQW5dkLWJHV2TFrTaJdDy6/GXxx4cis+WP7Yg4pLpF3W1p4s1M8WOJMeQp
	iUnjcfjx8ybiCWVpRcE8+vDBrNL1nuw=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488c0120047so1523065e9.0
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 01:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775549202; x=1776154002; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiARTJkG6bieAVjpVY1nM0z1Q63xfD5pEAGan5ewDbQ=;
        b=frNkA8O2LZkUp/Daz6WG17UrLNLmYrqd015MKQc5/MffW3Z+pGY8vWnPEiX0l5YLsm
         Lhog0+u+014hxgEE2lL0Ab6Ic3oxIoo3dMrMdmxHhs0MNUTQp3yN1W8FoBtuGKHcRj2j
         ITECiX1VjVRtozpJCQ0msT0KbLRgnqUC3KWMeZAnKXd3Jr07osoMik3HfxL5aX/yfvB8
         tIn6L9zAtDNJ6LLVMMUiYoN6A4Yu7kez3hdRea2TS5iG68leBTW6Em5OJWXlgYHzAj2j
         WdVEXqa6R5jWx1Db0LG0Y9Lip1TeZ4xio5mavJB1w59SIDA1jfaxGRtvLdjCuIuHSnfv
         Smpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775549202; x=1776154002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiARTJkG6bieAVjpVY1nM0z1Q63xfD5pEAGan5ewDbQ=;
        b=eMwv/XZHpMMzQbisvsBsQGpRzcM5Mizi/m7CduGUAk086kA/JSxKRVGGM5YCLhCfVn
         XbuABa3HczbVHqAbwppxMJauyhN3itK8BpR1HlIySZ2kgt9y595ZbJeu15eX/Dvzw/k7
         R6K2KZ1kA5P05ffOIEAMCSKzC8YXdML5o6NF+OALc7DvRlaOhkPrBAyP0nId559Uq7hK
         kRsQjKGw65ckIkh81kud2Y3EG4WKpekvyh3Oa++HDQ6OrASs+f+u6Fnlqi6b9lt/lpgj
         2W2oijm1rG1OTC9N5vVV3WjGNGCexQnOYciD0e1m0Y1LeJig+XEKt+U2tQdU9CwkxPVc
         iypQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBRj6/IwvJ9S52NT/kExFm3vQh5MwwErWz1ZEDWfJ3MOpjZIu/93BLtRRWvmkBAeuoF17QQif+PQ==@kvack.org
X-Gm-Message-State: AOJu0YyaMyHYZKwpTPAFpdvh4iUinh6EXIzz3DbMSBIrB3ykyRE9L4rd
	C2UKAV/qqUJLR6PjcqPtcZLk12lih4FuIfaAv6hYLrH78eK8PXJaOJ7/+vKG4YlstTtbq6Q16rY
	MLzC/XRFFZ/wuhugXJQ==
X-Received: from wmp9.prod.google.com ([2002:a05:600c:2409:b0:487:37f2:47bf])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a10d:b0:488:be58:bb77 with SMTP id 5b1f17b1804b1-488be58c975mr15356465e9.30.1775549201757;
 Tue, 07 Apr 2026 01:06:41 -0700 (PDT)
Date: Tue, 7 Apr 2026 08:06:40 +0000
In-Reply-To: <31bb8a8e-2ca0-486b-888a-328e9b748ac4@zohomail.in>
Mime-Version: 1.0
References: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
 <20260401-vmalloc-shrink-v9-3-bf58dfb997d8@zohomail.in> <ac2L2VNExpp8t7oF@google.com>
 <7bc4bba9-24ed-4a69-b9bd-d45d647f48b7@zohomail.in> <31bb8a8e-2ca0-486b-888a-328e9b748ac4@zohomail.in>
Message-ID: <adS7EDLby-977BAZ@google.com>
Subject: Re: [PATCH v9 3/4] mm/vmalloc: free unused pages on vrealloc() shrink
From: Alice Ryhl <aliceryhl@google.com>
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 91435A0008
X-Stat-Signature: mmp7k8ejnmq3y3roe1ygixy4iqdjt9mg
X-Rspam-User: 
X-HE-Tag: 1775549203-145706
X-HE-Meta: U2FsdGVkX18Y3nRH3CRy820NYYiNyZDRwI7B06QGRBIGbvGFZ7VzZ/u2biFdoR616RgYVZlCktFeh7kn+YkDB+bNpBFoAx3aQ9LQsqytXO0cy1q46dDyl/MsD6dGZeEHukr4T7WMBGvkws+J1uvNMOLVrI17gBiL6nLTefKeuj+Vljg4ko3HXnM23ooCSr57vBYhShl1M9P7tnY2fceLoHI1E/LzCBL78XeagLoGlcu6IcCbkAKVWz8XcSpWpkIbEbm/EuLyLrN3Tej5iWD1XdRopJliOXchgfRcFlLHNOFz/KMLiG4jxYD/WkWwuHMpiUD9496H7C3kCMpN7SeTLQTHjbiyUmEyc0XDCoVS6p7/QfiJej6zbXq1WnKA3xKY3HzO0z2rOHYx4zF+I+WNNZEyxGL6x2/xZD6W3pFOXkqkiCkok568Yf8UYwDE+0ZNzQrWPPi4MOlNp2iqr2A+OMe1Hy21OAK6SKLEFLSqaMyDedOad7up2VUI9zMcSpe7deN9KkQzE4sZYV1gFWSO+FW3PsHM32oi+BheyhMO9Qq0HovPBzQNwnk1rHaiSlrM3OCDVURxRB2Irsa0/CKK2RCVZdtbATQ+E8N4g29tqzEIgnrxUVipuhVpcrpBu61qW9vKz7O+hXefbUjsungM/PzwSMJqWNfEdGiYDPYg4yAW9GvBISt1Na56A5TlLR+TPhk2o8NngnFvixvriASR330tx4ihwTVwpjxrF0r95XibzVHvJ5WmrADxkUhz7h/rH9FxLwzf71dGGZLA0UZXlxReVZdXtZCQscRx3cEmWikIu8C15d9wXTdktj3pOrlgVbAS2QD5luhnKP7z+WlNzCr7QneIsxFBiSiX0Ba1/fub9MjVmro1CrpnBArtWS0nJoFkhG8u8YP3psXZ5Esc8rO1bnYBFLx119DVXSpeQ3sUUY4kffymtHUtVN5gXdwNuSt5Hrw0djs7hOcHL8L
 1bR0G/PY
 aI99KyLtCg5PcyM9cTjP9q2nsSTFmg/2KTsINJ4TmRtcDEV5Sbm0g6V17NBrV4r9M0g+cYta8wK6ScTXOrCb+jQ5zdd79GFaod41Yr8hBjzmhmTZLmcpnmhS02h+jiBDqon/3pwtcooCEd1+J/01b4gfdCDRNxHZkG2NaMnzrzw9sakk6d8EIAfU5lRDOfA/8zBeZe+47Pz22nzaE4lsq9WOVwM0Nbt0LydxXpynUDeK8Mu0/0iN3V0nu/84ou+6ws0GrZiFxg7KLmx2VQnTjQRAGTTQQJ2TzUzIi24gFesGqp4SXr+tTWJBTQm1rzJqWc8BvKjJZ5YSJHlpzXwtKJVt1oWIpuu+X5gfjPWkkcz+fIuoJmpxBb9MP9BkA9HlM+3yNDbmVuGDqAkiyDMZdcdoV7zmHsvI7TEATrwENwQ9qniq/WTSxQeZUlBREiivTb9fOKfmlT+chEXSJDn/FUX4yJExhelmCsuvOFIT07e3uV1vMIFnDYavhm5oNYqDlzCs8E9ZGXkFiZbcnLkFfJH9gLFwByot8CA4tNbuZWYs/LaYuzs6w7ooE1xYKHXBAL3CtLCjoHmKByAyCiCrHfcCAFK2uL7PAbe3wzWwTnBXusRGLpHcLmy+LjjE6+PF2MWtIbulVLreoHHkMRFBXfv3jJt43f54eIXwAE87yVWbRpGCSLTY/Gv77o/bvhHYARoJ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 08:23:42AM +0530, Shivam Kalra wrote:
> On 02/04/26 07:31, Shivam Kalra wrote:
> > On 02/04/26 02:49, Alice Ryhl wrote:
> > Should we set nr_pages first? Right now, another thread may observe the
> > range being unmapped but still see the old nr_pages value.
> 
> Or is this what you mean?
> <snip>
> struct vmap_node *vn = addr_to_node(addr);
> /* Notify kmemleak of the reduced allocation size before unmapping. */
> kmemleak_free_part(...);
> 
> spin_lock(&vn->busy.lock);
> vm->nr_pages = new_nr_pages;
> spin_unlock(&vn->busy.lock);
> 
> vunmap_range(...);
> vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
> 
> <snip>
> If this is the case, then I agree this will be much cleaner.

Yes, I mean that you should change nr_pages first, before you calling
vunmap_range().

Alice

