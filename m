Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33758D3B9B7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 01:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16846B0005; Tue,  9 Dec 2025 20:30:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9EF66B0007; Tue,  9 Dec 2025 20:30:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67686B0008; Tue,  9 Dec 2025 20:30:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0E746B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 20:30:26 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 787DC1DC767
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 01:30:26 +0000 (UTC)
X-FDA: 84201831252.06.9458940
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id A5D26C0013
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 01:30:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dt34hVhE;
	spf=pass (imf10.hostedemail.com: domain of 3L804aQYKCPwwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3L804aQYKCPwwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765330224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzYVdiyOUB89PcTxYLbA315w77wh23i5yN1FuYvCu0c=;
	b=6aHA+iEj9dygwDxjPGHh1xvfTo3I2cdB20Yfsazm7GN/5z7yFUMeyLeJ0Ow4F4RZM0ZtVs
	2x3tx8ex8NPq0u189FZtTE8e3exJBnBcNOZHPRExApjuXgN4R2PUlJSlSyYLgTnTw1Xr0N
	o1EdGQweFNQSDfUw4UOlq3NX8YXnDhg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dt34hVhE;
	spf=pass (imf10.hostedemail.com: domain of 3L804aQYKCPwwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3L804aQYKCPwwierngksskpi.gsqpmry1-qqozego.svk@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765330224; a=rsa-sha256;
	cv=none;
	b=iH75ODZBZXYcmwLcibhteFU9n4h2e/8m9ysHfofer0F3IihgcNy19wTKIESmHX/uFd7+JT
	pPBlPswQLl7ZZuPz8hulk/64WodicGcK/oxPAZuTOClOoWpufqEljD3oaGvtL6k/75aAe6
	3vy+ObcFW5+9rn7FLIb1Js0QJXBghXg=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343bf6ded5cso11477415a91.0
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 17:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765330223; x=1765935023; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bzYVdiyOUB89PcTxYLbA315w77wh23i5yN1FuYvCu0c=;
        b=dt34hVhEXsMeHg+riTnZi8fN5O36/qGTk7eCt6ZdL03q4B3SNKlMGx5GtPjZC6QYQD
         VKjxzt/5vaxQUFouQir7qmqLh+tzZKp+YJ0IncmplbTHT6kSex/cNCjHKks/Y7+f16Tl
         g/uRZqhU+ydpiZ9YOnFUlYdtGJK1z6vSGG3/Fl5CNNz+xkqQyjPAgT49/rYZGmZktkbG
         gH+kGIZh062jWaTMyoNoFgKgqy8S9GAArnyxps30kkz/P3jdUnCFBNnhEsLLkxJyWNhx
         WjMvp49CEHkjZxffPMvuvlovji2Ck2fyBdcmUOQQWd9jc1G6a4zlwlcSjjRQG0hFDVvW
         ibCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765330223; x=1765935023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bzYVdiyOUB89PcTxYLbA315w77wh23i5yN1FuYvCu0c=;
        b=gqqNrEhWRvXf5CkCqK0fjEmg+9mk9q4ZnfCR8duta5Zbvc+IANqPgpU/bvbwJLWKI8
         PHHQbMtJv9xIdXONOaowdfOhrzlnbHme/vjbpPpGKIm1hCKTpLRFg9eYogAIh7FWnTPM
         7D2MFPYaMZefFIB2uolH0JXG+D2H7C3PJzJBSWhgdiKMhbZvVSxM0S680vezrsykTmiE
         ReL1McSsAdhXluxKRJ5g2zY8HnCq+GlxLnBWzPlpbckFwxkfuC16wjccfhAegjlQBExC
         Jtii2M9rDkzBDKH0wsBbF9VUBBFRD9e/ZFX0Vp8SHm/8C2nDL0AtqjpoGpFIhpNsgdxL
         uYtw==
X-Forwarded-Encrypted: i=1; AJvYcCWgqTcATTfEVvtlrNU6660sme6idmh1GkkQC1lWnojKeBV2pM4OuxJ6Oie9FLJdGUEyn203AX5AZg==@kvack.org
X-Gm-Message-State: AOJu0Yz3scufyE5MKwLcljuvr0MPUxuL3JkTR7xFkgiWvHFkuCepEStl
	rkWA6D935nHFqISuWa98RMJcmum+oLgDaHQszCR2mvV6stG6T5/CFefsWxZ4TnjgmOS2NtebDb5
	9Mj0MTQ==
X-Google-Smtp-Source: AGHT+IHCoAoYGyPw5j9JBku0hHTxP/A4fWJZOerFAj0Mbk5JHgReKtVWkoA09cZ+6DnOUbpNy+4DPxRjdBM=
X-Received: from pjtd13.prod.google.com ([2002:a17:90b:4d:b0:349:d3b1:8ea4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3394:b0:35e:2a82:fdf4
 with SMTP id adf61e73a8af0-366e2fb7523mr592380637.59.1765330223201; Tue, 09
 Dec 2025 17:30:23 -0800 (PST)
Date: Tue, 9 Dec 2025 17:30:21 -0800
In-Reply-To: <5649e224-bb6a-4b63-bb27-5541216df0b6@suse.cz>
Mime-Version: 1.0
References: <20251203142648.trx6sslxvxr26yzd@amd.com> <20251203205910.1137445-1-vannapurve@google.com>
 <20251203231208.vsoibqhlosy2cjxs@amd.com> <5649e224-bb6a-4b63-bb27-5541216df0b6@suse.cz>
Message-ID: <aTjNLdxvmAMuo7VG@google.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
From: Sean Christopherson <seanjc@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Michael Roth <michael.roth@amd.com>, FirstName LastName <vannapurve@google.com>, ackerleytng@google.com, 
	aik@amd.com, ashish.kalra@amd.com, david@redhat.com, ira.weiny@intel.com, 
	kvm@vger.kernel.org, liam.merwick@oracle.com, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	thomas.lendacky@amd.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: oq4opjf8ex16inqqt3o646gitq3ufmbi
X-Rspamd-Queue-Id: A5D26C0013
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765330224-241538
X-HE-Meta: U2FsdGVkX19KCqOf+5URxmwAZ87Vi+hPb4V1jo01dfDgPfJFY4T9qbdrozTIaZOWm1a87d1/A5fi94r+BhkRpk9BwPbBFMzoRMfCYQKT2DrvO59HO0P6DdYiNisOQb4vBZdZZbj5R76uLbLQ5minjOZdECscWuIBsZ6g/jaMcJKkWB8VdviE9ASlOPP8Gm2Ih4/OMPfvKNHCdM48+gnt4oWC7zkKCxnynjrRWPOct5JSsUJLuhWsZ8Y+tI5N82lOjEJZw7AIRHuAcZD38Uu01rsB9jP2sbnFeUAimdGdKk9hnQ1vngEuB8o5Fn8uYpn3BBQ4t3OEmKSYw9LN76DYsIhasOOMSg7GK9Dz6hpeRJSIXWBf3APSnrozWoxl3BUEU93EFIEtr75/OsgChWSRE4GoehVxR8/FqFfb/j7qvVxr237jV6/hMlR4XvIIFSoLEPr7kHlrOLpnXE9R243DWw0Z57NtnkBKc+dsjeGNpwPotThRnZm+OASwoQp1nUpeKszOo7q7Z17KClkFP1Uo3JlANO/gsUefU3jslbfY5MAHaZuMNfQmOm3E6jjZUrDn2yHjpiwYinuTieCUdXTGxopc3f94SPE4475pi5w1gjIf6HTkNwGddWN8AJCGDc2+tS2RqwPNBBU3OjJqpZveve2cSQIBVvtU42SM9HOQsEf80Y4wXzdWx6YkP4WSMXqBNZqrGgLUUmHhV27r2bTJ8rM2dqVx3fi1TEbb0HyP6bVKvu+h0vSaSJpFLeDi+mEtnkkZiZpLVxk3+LGDqNo++ueYfWAP2lpfdKDVsYYO+0RTjxAJ3PPp5ZZySeSz7CT/uE6xgZFOxGBffNsWqEnnevs3JdHWtBu8loJZz2msWmjshTxZLmUNqzdMhpfnTFMeCe3bqYD2oueYJ4Gktp2D81LXQ9NWWWDvxOlMHZdQOXFpeFuYzALZkmDkoEmrIbUqjsimjr2USrLPXlPbl/g
 tBP0genk
 LA8IgCjWWojqzJYYa3D7BZ0LBxOeSBCIGTiInSd0GntaNj+KBTRDJAHCdLeiDNUPJe8He71xSEeHlulFLpB7LizvB2+gjeo93lvn5QSAelVXMZVGbVFZ/YSkNQJ+S8qNeS/HhnnKApwE5B978A4GbF2kMtVgq+ZhkUttjnoRGfqQRteYnyGOweYjJEmNXIqtst9gMAJ6gZCZi8yNgMpCyD7bTq4jFD2vlj7luKoAZ214S3g+ITs2s6PuWl/xfzP9f7ije0RdctOZ2JFqGGlFXXGCUsS66i7doUGYi3uOlNW1TXZbPKpBl7euoNABQNkVXFOo//gOjIvolpdBVTBWRYV3jt+qqa7sFG+yTucN5wOpINwpqKpmbty6x2GvBhUuI6DAsS4/oxs/KO7t6VIK94DJuPvC+qOnKUHLKwK6y6leXKGsbNhgX0TggUCNstx2h6iMd+j1yaAaiZksIcWD9V2c2W4q/RJQ5y6lCCAUiAztxrxq3YzWjzGVyxsgKdJpgLKyZWzoz0b2tjln5AMn6CJzFHeTJwYVCSUiTwwY7f9UD1H32uxXSnhburU41iD0RCp2tIR8Qgt03JNIop3ioxttP5Spobau0tPG5UAHI6IF0nW1jMjo37Bqjh94aqVI90jNb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025, Vlastimil Babka wrote:
> On 12/4/25 00:12, Michael Roth wrote:
> > On Wed, Dec 03, 2025 at 08:59:10PM +0000, FirstName LastName wrote:
> >> 
> >> e.g. 4K page based population logic will keep things simple and can be
> >> further simplified if we can add PAGE_ALIGNED(params.uaddr) restriction.
> > 
> > I'm still hesitant to pull the trigger on retroactively enforcing
> > page-aligned uaddr for SNP, but if the maintainers are good with it then
> > no objection from me.
> 
> IMHO it would be for the best. If there are no known users that would break,
> it's worth trying. The "do not break userspace" rule isn't about eliminating
> any theoretical possibility, but indeed about known breakages (and reacting
> appropriately to reports about previously unknown breakages). Perhaps any
> such users would be also willing to adjust and not demand a revert.

+1.  This code is already crazy complex, we should jump at any simplification
possible.  Especially since we expect in-place conversion to dominate usage in
the future, and in-place conversion is incompatible with an unaligned source.

