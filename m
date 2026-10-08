Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7421BCA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 13:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F197F6B008A; Thu,  8 Oct 2026 09:07:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA276B008C; Thu,  8 Oct 2026 09:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDFB36B0092; Thu,  8 Oct 2026 09:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE0606B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:07:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54FAA4011E
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 13:07:24 +0000 (UTC)
X-FDA: 85299485208.25.C9A9F76
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7F99D40007
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 13:07:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=S97XhocT;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791464842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7t6+pTQP1CQbEVM19QS/h21zu8MNABf/SgAoLNSosdM=;
	b=kWiG6TFGQa6byZmtltP6UKRKdwj/Mu03qdf+CCcKrMuKNLC0/En3PJEc5f7YDjT4qkhhgh
	n4VNmFICmFrCYb6JLoGCY62Xn0CDLg1b9t1Hh7K7IQh9iEvSicy6/UP6Y/mANJGu3U2nqT
	9SkuuAKe0HtA4Di0yCoxi5a71HWWHMc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791464842;
	b=iYoi1B/kLqjOHu3MCeg903QvLiofD7yBgBpxrFtarlGkEuVOjLRWTVnl26XLYdzvZrHYDv
	6VpdYhr3LH5buXeQ8HqtzMgraN2iw/GAooensJKpTn1N34dWdl/AxMy6UEEtEBQ/zaXV+a
	UxoKWQJFRFFlox+Dg1NQroktOmnUCgk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=S97XhocT;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48c6955a7c3so895851f8f.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 06:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791464841; x=1792069641; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7t6+pTQP1CQbEVM19QS/h21zu8MNABf/SgAoLNSosdM=;
        b=S97XhocTy1N6zZkqsph5nmtOwbHhTjpDMrk2mO434/9TZYBh0Slix7K+EbW7QS6pAl
         dptQqKCccGyGk26HN8BMrhYkYUSeclQcbrTa8PGmrtGerTMR+yVKx2vc68uFmI9XGNXa
         5z3Dfm5fj09889Lfvju8o2D6nGF+CRuzxIjd8XyGgAcAh3EqGg84AkIAcp6CzBtEXjSc
         LnRgIv91vb9xBGWBu52ZRqZNNFK2Y9F0xKnUWiIoWKIYTU5C4TUjMctOVsp5brTFToBG
         0ki48/A4RsCxrM+J6VX50LBl4HS7DrD6euv36+eOi6eSAHaHCsPGSUMbK6uY+XzFKavZ
         nMQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791464841; x=1792069641;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7t6+pTQP1CQbEVM19QS/h21zu8MNABf/SgAoLNSosdM=;
        b=GwWFFvl4kfpZtB1NJKzHIxw9RfQOcPhmvZot3m/7TSPNuGto/mnmMmiYcAbytN72Sl
         e6dCZy3qLKZHwkX0HQUqPUgioTxYF/X/Fy610C3XcEWx0eVrPnLeUgxnwO/iDCjAJK3g
         whSLXimWVcVIx1gQ7oF+bBGqmaBB79EFAgXzRmukgXySCcR350YU3XwQp+K9qmZIQRL8
         oF8HlHtpUF/kA7m0dqLNdPA/0GKJVBXg3IYTedjb/vdQrGQaB5WQlUkfZT/EdC0RqqMV
         RI+oi1TBOaTXuZjd9FUXlWlV1OCMB0QWJzHCTLfhaXRhUU5LJE/UwZTc/6OU8cNswlUw
         kc5A==
X-Forwarded-Encrypted: i=1; AKwUvByFiGJx6y43RIJk5dmyXZzrz/KcSc4Sj/+t59/ko0s3Xxg58LYudpGv9h2W+A9jLIa9jGBdyMAMtg==@kvack.org
X-Gm-Message-State: AFq9FYIw+KoWFsYGMBkY4RXOWwTbEN9iQ/XHQ5EfaIS7TjyuMVB1akGt
	mzUwCBIMplU8DhHpFPyhopdme7ykgDxgGnBR6jL1CM2gtx+JYApIViU2NCxcCnKtoGw=
X-Gm-Gg: AYBFou091E1/EoV9QphKXyV2BIVffxPOE6Ic2WIkrgqbt2pMloQgwxoQcj2oQNjqI8Z
	q/ZFVsb6r06a4DC7p2njtgE23ibj4W8Zaf0YK74I5Shhy+DmRV5kyzKKgibtpLp84oLjzigxS0B
	dv7OysQWaYXdC9Pev2LaXlQSX0dvwq9QBNweDBKOwkeeaYAeafsdr2GmBHorPTWvXueB6lqFIYS
	zRif//pHhULf5CKNoOyiz/Lwn49Cnb9AiUyfiDLBdMxt6LOKIau1eWyW7l9w/rTJ7L/OJLGWFXl
	EVVrhcZ8LygTQ1XBqOWrNjGQBLXdT5xwyL977PvTWr3ZAPe6HoVE0lzPW2H0kBc7seu+Ym/N6ee
	0IPWBcH+KRmkS6Gx3aqygdUONdpCkrzftR0YEvXMXJVAUouYMNRO/SY5j7DzIMHCv5CrHLYfmZX
	givOZXVHOoLE6aK0F77dYMlaY8lOgfERhwAlnfvwKKdVwlYBBDrGtTvfIBtwDVQfqIte0am90m7
	V3fF0BnrA==
X-Received: by 2002:a5d:64c8:0:b0:48c:43a3:6a74 with SMTP id ffacd0b85a97d-48c7277152bmr11130200f8f.12.1791464840586;
        Thu, 08 Oct 2026 06:07:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([185.194.184.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c724b660fsm10757165f8f.18.2026.10.08.06.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 06:07:20 -0700 (PDT)
Date: Thu, 8 Oct 2026 09:07:17 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ayush Ranjan <ayushr@modal.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
Message-ID: <aseVAm3vczSTvBwN@gourry-fedora-PF4VCD3F>
References: <20260924061708.1645968-1-ayushr@modal.com>
 <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
 <20260925053027.1998394-1-ayushr@modal.com>
 <20260925065013.3682431-1-ayushr@modal.com>
 <20261003033107.1488699-1-ayushr@modal.com>
 <20261004222831.bdd648a2b406f02747dd9e40@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004222831.bdd648a2b406f02747dd9e40@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7F99D40007
X-Stat-Signature: 4wg7yek8q7usdc1amb19pe8xcdiy7jdd
X-HE-Tag: 1791464842-426940
X-HE-Meta: U2FsdGVkX1/pnVVVTr0Vu5AaxEdmJKYX47m4pQjlol7gzbdl612DUBeZLWdcZJJzuTx7XQnNXEqhLXZ2LNyqEuXI3s31VO5FlXU7C4KlzqOYqFlkbnOEB6D1dKTVeKdoWuUAq3KbwY44FLo68kVu7qb8+g0WgQxUHatncbfMmbjTn8PFdrpik8JqyrdC7vi6wXtnIIY1RGdxWCKpbUemGdWdH/lTvhduRnv6MdBaCcL4NUXWt6jZyHSryrZftDpKm4KaetiOyzyLiRJWBjZOsyHk+fykEsaVcXm9nkfc50cZfN1AQBSYPi4zO4kANmFK3vda2GeS34/XF9fj+MUHX4CPajcQb4WSGej8F/1Qv1qiQmVuiaB4A6qYoHcGOMoqAGRoLz6FUUr60FhLWMKwaz02suf7lU2x0BQlf/M8bx/R60GoGlfaVgq+RcWhQG3SVarg1kRVMXWMrIWjDrtDrVDtpc7RwcM/Gp0pWyomeSmW1FmHdlSHNFihbBO4UG77cVI/Mu8LlGZr3XQ1W6dQIGkfb0twTT9dNgejDpBDjH7Bw2sDAQaXunLhN3RkhafF2se6LDUzx9DGC/8d3NE3gjxiVYK1awbx9pBdVrEnOSIBVvm/DFb/sxwrE79aN/36fEHH+icnDRM3+YXku/ukPAkb9NnXI5OzemeTq5ZnrcS/OzgREEy9GnASF+c0qt2WFstYgIqF8gjwZFMHYvDrY8UOydzYgd1RC/kY89Fuw/AjHVQr3Hp6bA745TNdCtgGZADQE40hTzInY05HX2rgw8aurcOjOmJMQfdzZS2+gWVHx0WGzP3lVC7yuM2RVyiE/sokhhHdl0H+f4JbFT7jhUc9960wVOi4cGR0vqlWt+YroiBkXDJ2DkSfuKcqkql8kbDsJK6YvD6McXAiIZKhNKOEyvqIwzGu/BBMOWTCA8Iu8oO+x3S3KcwvpyPsgWfadRmMQ1xq4ZHPHB/H0IJ
 PHV429Vo
 XnL4WNlzJEw9OLGFEMdS0tFomY26hK3CaNmBnO818vlEOzTTJPYekec0O4S4dzLFvqYfD+HuWy6tepJtW62f0aTil6PO6p59pSvC+PNxJqGFXhQCPAYEbo3wiZ3lU7fJ5jSmMu3CK65t4RtFZuk1kHPJfU6p8R9NasCjKUOeyasyzHy3FLJXcYrDb2IjYEZRjp2Hk4dlvr2AriaGW92fiIwP/jzlxOPTQio0MbXgmHgJGCh5gIrGvPOTy750dWMKiyJH+3QJJPz7pRMjlO0N1TJHSvo6aB2VVjQFcJHWGOEFeQ6NAEvyJ/jYbw0HMOufCQNW0PoCz30KXGRigK0zSx109a+Ij4L4PqZRVvX/YPO5Ib8jiLUUPUZKHOzXm0o1C7HlBvSBF/EZorc/5RDmwiwHV8nbf31hVAkbtR5Y4rgKjrWSGTZPJo4GU3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 04, 2026 at 10:28:31PM -0700, Andrew Morton wrote:
> fwiw I made gpt and gemini argue about this for a while and ended up
> with the below.
>

I thought this was resolved by Zi Yan's patches, but it seems they just
made it harder to hit.  This version looks better than what i'd
originally conjurred up, so if you end up taking it:

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

~Gregory

