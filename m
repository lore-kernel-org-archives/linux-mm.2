Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18E01CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4856B0107; Wed, 27 May 2026 10:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796006B0108; Wed, 27 May 2026 10:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D22D6B0109; Wed, 27 May 2026 10:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4DB6B0107
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:38:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25C1A1A0608
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:38:03 +0000 (UTC)
X-FDA: 84813454446.22.12E3AE3
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0676080014
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:38:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=dqNRNBGz;
	spf=pass (imf30.hostedemail.com: domain of axboe@kernel.dk designates 209.85.160.53 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779892681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zecYAQBk+wDedXs6mOLsZBG4IOTyDnusWVeZnPoBgS8=;
	b=IEhNP4tamETS+MB6okVRrI85AV0g3m8kg3Ly1NvVNOFa5aDTgSDj9D78W40BbS90vWblq6
	YR/+ikRYhRHLN6Rxrs9yqOTkDOQvYjm6+YQ4zdK5KXpmYiJSSnO8GSCiE7rQoFqmdF/fLS
	FdtvCmt2kHWw+llHxvvgxVnJklA58Uc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779892681; a=rsa-sha256;
	cv=none;
	b=gDLtIPeiVns+BAwwx929Fi9EK8iUv6NTdJqjJsB2IpYdJTNn8RZzAz4c1BS9tw++zWnbJ+
	2IAYOhOJIPx5mhBwPfFZAXL1nMgRYjfk7n4hgp3tiFcv0AMke6pjsbO2K8whG8/Xr7zv7W
	2p8lhtoboq5Aq6/7jjSGMVXAODiPNz4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=dqNRNBGz;
	spf=pass (imf30.hostedemail.com: domain of axboe@kernel.dk designates 209.85.160.53 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-43b4dad80a5so4033814fac.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779892680; x=1780497480; darn=kvack.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zecYAQBk+wDedXs6mOLsZBG4IOTyDnusWVeZnPoBgS8=;
        b=dqNRNBGz9hYjD1BJAWucTLXNG4Yuy30uzPsgT2cJCkzal/nTmuzgXs4QnKdLuHttJa
         UxieA4tubzbmvLBgLCuDGCYqwaYtaZN/5gRaRtggGganCXex4JfL3hbLK5COyk1u8HJy
         oiaGLzvaV1UB+OtzqC0UZjgAfywWPjBI6ES0ajfFS5s/UHKl15qYU2lOGl9jo6kQsnjU
         Sgi/HU1qhDXPz9+0HPZ0lMvDyOsyQUTgF81Nzd3toRujvp9iaToniTgPKTq0NsZOM5jl
         2xjQvvzIeXyTm3bZHf5Gz+24/04anQ1TuOChaIZkOXvPzw4TVuNA8JfWbnRQkGtVxI2o
         aE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779892680; x=1780497480;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zecYAQBk+wDedXs6mOLsZBG4IOTyDnusWVeZnPoBgS8=;
        b=KDrkRO7LS63H/wubxNO1NcHvgyc0pS0y5wzY6dYYKHulF7VLDBY6H9MpyrYbnXFrta
         blYM48qxFZHr/eXWvmHlKr+HeZyHAlWRnBHkM46r4TO5XllgMMOb0TXuprHjJ1IdzayL
         ojSXNo3tUxQmedEVBzjbEeXXTZBrFHfL/WmWqX9PVwlqoZh32Hl3UMJwCRKMmcXf8tk0
         PBNCYF2JGjxAVAdGG/FFrIxNagnJp6R7iUnNSJ7I3OqkxtlDa1CMXLoKA/ohAm4EX8Ce
         qqaMOzgHnxncZN7fymT//b8Be7L6ISPfDbSBIFrQQ/WKGc9GKEQTRx35hPHZ7q5rgH8K
         3YRA==
X-Forwarded-Encrypted: i=1; AFNElJ/Q9FC0WwgchjB/eC+poVtEF++NhwIm98KG2t7oYBYUDW832ulgpdpqPihkqKO0+XoD1uZsHS+HAw==@kvack.org
X-Gm-Message-State: AOJu0YwUBEN1e+JnoO/dok4ghouE/4a9ZiozYMtVfW/0n6/YY/NqIcYT
	m4/ikloPC9AsR/eAJZOj0n66+B22lh3sIHRh+Ls7gVI4Md3b0W0JckBxULH6LWgJnlg=
X-Gm-Gg: Acq92OHXezMgrGYEKbYz0vq+M6Jdvhnn9y/lIl/aP9i7aZrCavNXXhy0vGw0+KNSvYg
	BhqKSDV6Jq0LOmHOIgNljA9tzGuMAokiXcnnkq9dbQ0382ygupxJFU799xOtpG7hoOIEz1AsPpP
	gE1a4yLUNtdS6zmKKQVzB30b4gKtb7v93ITEoyYRmn3DoOPsshviGNZCahBK3RWSOPeFGy8N+aF
	FFbHcj+3si0A4Z3EcZ8JWKVedxnFa6nX3b9gFLUdAUcA0JKxZvJR0R3/BGX0/oQcisKRtwlx6pc
	6Nu79gNWmdCjqI2XAsU+gVMF0IzU1tD7gHFM+Xep0JXrQkfEGJUQ81S0YyFPLmF6dtLvsLZ//0B
	zftmsuaaEwFF6iRsJxlxFDSw6Jxu1OB0W7L1Um7GaUewjF6rd0TQpQ9UUMmWmGPNZ2KGlkjvhs+
	bNj0q79kntVcHUZbsuLicYOepqPCz9AepvfsCmySk9ZcQRuRwv1HiNebm5379iZuiJkhzFjEqqD
	WB0AGx9Vg195A==
X-Received: by 2002:a05:6870:2b08:b0:41b:edc8:7b93 with SMTP id 586e51a60fabf-43b5a576a3fmr14403973fac.0.1779892679801;
        Wed, 27 May 2026 07:37:59 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b6351a772sm16950878fac.3.2026.05.27.07.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:37:58 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, 
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.com>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20260527-block-v2-1-8e06f914c484@kernel.org>
References: <20260527-block-v2-1-8e06f914c484@kernel.org>
Subject: Re: [PATCH v2] block: partitions: replace __get_free_page() with
 kmalloc()
Message-Id: <177989267830.742656.16328543608099641872.b4-ty@b4>
Date: Wed, 27 May 2026 08:37:58 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Stat-Signature: i3staxgwc7jtgkx754pqi7tobjgh6tbj
X-Rspamd-Queue-Id: 0676080014
X-Rspam-User: 
X-HE-Tag: 1779892680-440465
X-HE-Meta: U2FsdGVkX1/Ai4ntfY6a1wOxrgbLpKMIc2nYhSFDwQaBP8nqBlEbzAU46tKk0EO1+W7n0uv7Z4i92OaaGxfcnmjijrm4QieQ5sYcLoQdn5kR1W7gD6YD1uS3/PrkJHW2rnIrz5QbY82zBXtrpHrKvDIA9+zLvJnoFEj1dNY1Fzyekais2esk84uOOERzKig5pTTaZGPSQf7trpzVi4fl/1chfHnvn/SZndn9LvS5V+XinSSs8LKrX+dA3rbhvaBGeynZRi2sMml6PPvigTvtt4Kl2RvRucVyeqWOXBKoO8OyA20yi4TzwG9ClkDVVbMaXkc9NTtnUXVALwxGzTwex1YY1vSKa5mWjRAwLvP6trB5Tn862UaaHBipfTidbYyhjZAxUiGDKa9BMj5OCqgkYqnyPdWE0cLbWW1puibFSC+0QYH87qM+jdNRsTR4oD6EkVvVbLTxfur0L8B+hA9Q7GBFHAC9kxhKxpYy5d2yd0AJdhnWdEfncAWWNW8djpCQhHCtzaltetH0O7MeklfA10Q9cpHoWMQ45w6udX24KTUg1SD+FntovgzjUW5YW/fiNG9EtccXa///rCnbZrsHx9IJk1tUYLzU9J5+1Os1l6GsKCf30mUEC3kaSoEgioNBjiLaH838XeFCnOrpMzTS2Jce2DIVknCMt6LvjPNalftYbFtkW5gIYiJTyE66RuRhm4IIGf97kZtsXNikEiibrUNIELtb8ye3M8W2LAkSD53Z3bL8EGKE0Q4HhLtN+onxE0hb78lnO1EaVKc8zLig5aej6XGe3MNLr/v1pDByu+sCPVvNNhSIqQwqZbrdGd9jdHA38nfB6bkp1398wNCVdb3JGA469TROHWTZ5Lyku7c3fIVHYwZlGhiVhLDXENPBlPhmvSwzOE5w1ZR0qnTBZBuYSDLtjTwJXHjFlnkR9s//1Msh4KEMx8NfMzTWdU21gg7Q7Ysf0GKyvxKfqQJ
 GW9UlhW3
 wzUMxuiYdIpux4/UtpJpNFfRK8n2fMTSzuJk+vfDdeAFSLui1lEKJEc08VuJsDuKZm6NMnNy/09D22Rf8o/uN5vmexvZGVWgj1dQp8/5leYAgVPbEjNqyNS8B0+HQtT4HoCkPAgPuHLVnGDDp14kuyilBzSxRqsOWSYy6uIERbxhO65jToXN+kF0jITWT/TxVnjWlSqZ7r8Qbux+9jWwznxp7Y83YM+yeu4sHLwjrKTtkD8jXI1dhe8w8OXoC99GzpH0Y6sjQ0VdA5Uu9bSbjnVzy4jIczMGMgE6GpN5zJCVvvMmHu+JRfLNvOpXqsy73S5/5PIcQj0b8S+T9h6pCqFkq+ExY8/slhVqkyWsjLN8uJAleIbmbRIgWcupUrXhHz98hkDIUYyamlAt7j1AcGtqLla2AbsUjo7rjl/kLNka+z7bX0o2MjBZs2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, 27 May 2026 17:33:28 +0300, Mike Rapoport (Microsoft) wrote:
> check_partition() allocates a buffer to use as backing memory for
> seq_buf.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> [...]

Applied, thanks!

[1/1] block: partitions: replace __get_free_page() with kmalloc()
      commit: 17d7492a50251d913ae7101f898cf30ede856cde

Best regards,
-- 
Jens Axboe




