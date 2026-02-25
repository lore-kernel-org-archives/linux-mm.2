Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D1E0FD45FA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A936B0088; Wed, 25 Feb 2026 18:19:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00EBE6B0089; Wed, 25 Feb 2026 18:19:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5CBF6B008A; Wed, 25 Feb 2026 18:19:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D04386B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:19:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7AFC71C284
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:19:39 +0000 (UTC)
X-FDA: 84484548078.12.6014062
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id B552B1A0004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:19:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jQ3jm8xq;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772061577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=O+2WI8+WHGSxzDMypeTIG34AW2gR4WaqyLGDfPVODdo=;
	b=W5C7bo8R8DyZcsXHLkMt/e7QKhvN+VdT3rOxT8NF56KyYAxY0r+pyHdjDnVQ4oqk4d2Z+M
	wKdGjXYOa1a1+u7RP++caa5q44/4PHtKX9MC3ebs4L5Pk/nCmlIbt6fBJdEYXDV2M4klwh
	44FVO6etvNW1GzTgINxrDJEZpF6fvH8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jQ3jm8xq;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772061577; a=rsa-sha256;
	cv=none;
	b=gJkUJoPHrbypNFz2k4rqekC9WMIuxhHf3nQZyyquTi7A31K5ji4bQrVU6ZZr7h76V9SL0t
	dPDblIjFFNoP3bX/XMTBs4BOfGMPn61yDiT4bdYH+VqLI+/djmG2PBRAKfq5pIa7Mwhrkh
	356/e2BvB4N5xDyRftHUnKGchyHbPpE=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d4bd4db87aso73443a34.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772061577; x=1772666377; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O+2WI8+WHGSxzDMypeTIG34AW2gR4WaqyLGDfPVODdo=;
        b=jQ3jm8xq7uJYGUDicq0oaWzKZMdnxu1icGDoiOwpkGxRaC7p7WQNMBeB0+5a4vioIV
         RLzL8YAcXSOLKXIc33SqchK41BXcxHjzqk66tAmpjRDuGu2gkmiKIpzyhoUgZTBpdFZM
         buPyTtVaiY/3htyh3bTXp7pQnYgtFBAHSOkZu60CJydE7n9ffzbVuG1WgFwxDkZnsHyh
         ugn5aF1LrN0fb2fik3zaeFbf2DEbQgBwab8TY3+jr0VY+9pTTMLmmAw9Np1fBWomIFLX
         9sq4ZvuIR1c5pklkLQl9WJ7XOG04eKiflm2yTp52Lwzj5a+h/Zlg/u8zd03u1kFLlsTg
         qkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772061577; x=1772666377;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O+2WI8+WHGSxzDMypeTIG34AW2gR4WaqyLGDfPVODdo=;
        b=s+8KDaCBDdWJIDNY3KzXfaXjbQaJwoJslUjQ2YJzXBv+C0y+XDzKfMWhmIU+/iC18/
         1NW0uksXngoBIANg+uVRnJkWPGbZRvLSiyYyHyyT25ERvNe+hI4tDTlPoR3ryvaXC0xY
         JjINPBKZZ9sYM/ATYpzhSEa8nAqeRGn16ZNDCEWpufG0kItNhVk8ExuXwVQbe1TZ5lcH
         Tq00GQEynGa6V9L7wHUnYITIA9DLSPnXWKKYGZs6EluIEy7vrJi99Ccpnu+wYsUfpntB
         XKIyF9XZMW4quhaPNEug2iF+SgJgDNvAOF+DJ2IlO+U4flg+gOKhqFtcLFT9ENg+kNNG
         xiFA==
X-Forwarded-Encrypted: i=1; AJvYcCXP4wd6Lt1nUwyixQdm+j/IMd6VweDiLZSBDeqSnK+gJIH0oiDCyM+hYJxx2UouB7PCcO60a4sD3g==@kvack.org
X-Gm-Message-State: AOJu0Yzppc6ItwqwgRO7+UgwebD55h27Hdp1llOB3Xn1WaSMP3T0xkz1
	bJTIbUnGfZl+/AMlTLx6NjAYkHym+0GeAbfbnxEUtrZVgUytZUY5+Wdg
X-Gm-Gg: ATEYQzxV1oSxhH0YjmrprWM8zOF0GDyEqRsSE/xqkyaBfN2Ngv4o7z4zf9UokWjiV92
	HQ+wbILfIdDz/wY9tt2i7kDYTTJu/DjIPeuoIVPUqygws4BjzyIGrd5zGFjn7haDJeTaXgN8ev0
	kb43N0BKvSXC2IRbJF+8dscCFXzQx/oDhr6C5ONq5WVqLTNAwQo1r5GByzd894edK4zmgsvSUve
	4GvP676cGzqYuxIu6n/4Fq17lv+58FLG52BbB3HOyJNa0nm6dYkpN8kjwTIAx2tpLb4dxaCaEYi
	TAkYfeu3sjMHFAxIe6mUsqPPI8xx6Az2YROMiOodGDbahiNUlRrFXg7ihk6BprHwnaCobqhOQTN
	qry7HyF5PVA4vV57DY4iw5xo9u0JwzQRG3VzF+o7a4+fv9asYXqyKiFxP8o3JmK3Sh34Ok7zLSS
	xFvRbNtiWDX8eBm+hz3amqKrs5JXvVplvc3YLDLg==
X-Received: by 2002:a05:6830:81cb:b0:7d0:3a38:8fa2 with SMTP id 46e09a7af769-7d586f975cbmr114505a34.36.1772061576707;
        Wed, 25 Feb 2026 15:19:36 -0800 (PST)
Received: from fedora ([2603:8080:10f0:ab80::1382])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d58644dd17sm332465a34.5.2026.02.25.15.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:19:36 -0800 (PST)
Date: Wed, 25 Feb 2026 15:19:33 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>
Subject: [LSF/MM/BPF TOPIC] Separately allocating memdescs from struct page
Message-ID: <aZ-DhWZbTnTnBh-D@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: B552B1A0004
X-Rspamd-Server: rspam02
X-Stat-Signature: 3q4kmsixy3cou7pqwbi96g5pxw4n13gn
X-HE-Tag: 1772061577-143264
X-HE-Meta: U2FsdGVkX18ykp947XL5Qzt9TzdqLsg+Cug+XabqjxqvajkSyXoVTJ+0Fg5o2Os2Spx1wL1Dgnkvvdt7XJtgeUO90L1wBgg4LohTyc+eXHHuiWbnLEBihlqqXTJJEbjvE62wnNIt3T37lqmvHxQ2IbawZa+FRoGaBMCNWdvjD7TNr56FxC/jaJEs0e7/N0H43wYvGmzcN/DoB5TDij4qTRja1L1lcKbPjOon6ZEZaD/6SA2XbVTnJs0oO8851jWMii/MX72WOdaI1nqcBigEIxbMDHkrgV0laeSfnd8+QiAWpkzdvLMoz5PzgYm//JxsnZuuMtb034aQ/xgVsFwca8RyWV/+wM3emD+avZJMjHjk22l5OCrHxXjR978+PQA1vKkQbO/ACjmWJprRbSSnwaKErkts+bqg88sD5o2raf35R5HeAnyL1sMvRtBcHFYrLmni8cGmrtShv5G8UVBrGAmgRGt+AmDodCsYFE75bJ9/w3MIcCkHMBPhsHMzvwkbVbNunYFm03UTO7Vwu1LFj2htY8qF2/6hNtf9Yh5MLpCW66rq5ZUgM8HTUJhiv+BYGzRF5F/8JbcRvrqfoMeKaDQu4QXMeiCGwoep+M1kpEl9rpHZZGM83gbjUf5dCGlhG0NFDBWBCKKInm8fGia90hjHet5cEI84C5yRhIm3YbViKQDqZ3bF4C8qjD0EM1Bne1rTLJd92peG5NiCxciF4UMy14mXwPILKYqQOozJ2xc1LEr7Grh6kJq9jjbyTcXWr1s/6BxEtPVBg6hil69R7EcSlwtFfyrlJ7/26g+fEehfAGj9UUr5YiZos4rdyknSljC4GI2rFMkMY1v9hiFG3cMssQS39yk9mLu92ZBZgZc/q9ZGEXQ0HI3dIbebM5I2sRPokF/d0yHfSte6V+U6S1FlwTV+mcOwWYpkm5Nt9VVv+dBIaJcZQ4NZsMZlVUnrMIupVw3W5A51M+fK8N0
 1mB0D3L5
 GzXXIuKm4pl1bOnWjW6MU9MVffMnh4LZYp0712TYbFugnSOmGlr+jpqRtwHWk4ZzVEJUZzxywdjV22Qn04dyC+0XEP23yRZW60oBZnFvig6vYwZi3OUx32/sVoXAn8Fgn+L9K8BQyWJmNJl2VNDkE8aJV1q0IF5rEU/5I+slWvOeNjRhrlK4tf08p0JQLRxM111JccHmeinbYUcbC9cJho2P9UO7aUsULKF654TLNps3xuOd5AwsGFzbUEkId6bcPBiaC5BCECD/+wnO98cTEz3ElI1SVWbi2GsKp3jYwzgFb7hcOpMYaVnPLlEWOpiwzdsSqZVQCMDjbtKIilxEB2Oxbeb4M85+ESlKotPHvJC4LMmJAkIosPU4BhD87na1pgApOooZfCKRmSAhCPTJPfnjEfZgPLkOgzb6nKVKL1U+Ni3UwRbsc1iQVqxxM0onSptz6HIzkBPV021zf1wex1gN1pAxdapw7RJYVkRQXHGG0zKlu9+iifC3va2go41dWKod5Fp60gzv+MH1X/EwsHf5rDR5DhWvuUD5AM5TYwI3bnZVVAw3Eva17l2vUGiOQUnBiwQU6AvKF0eLYxfppmvo3zu3GbRsxkLOphoE0XLi5KgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the overarching project to shrink struct page, we've been
creating memdescs that currently function as wrappers around it[1].
Until we separately allocate memdescs, we won't be able to shrink the
page.

We're getting close to being able to allocate memdescs separately from
struct page, and I'd like to propose the topic to discuss how we want
to go about it. We already have Matthew's PoC for ptdescs[2]. I've taken
that on, but we're still running into issues for now...

Heres a non-exhaustive list of things I'd like to discuss:
- What memdescs to separate allocate for shrinking the page right now
- What are the implications of separate allocations
- Should we separately allocate one at a time, or all at once
- How the APIs would look
- Are there other generic fields to be cautious about (i.e. memcg)

I imagine Matthew might have a broader State of the Page talk too, so
this would be more in-depth. Possibly focused on ptdesc & slab (as the
two we're actively looking at right now).

[1] https://kernelnewbies.org/MatthewWilcox/Memdescs
[2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/

