Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 301A1C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B7D6B00F1; Tue,  4 Aug 2026 10:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542996B00F2; Tue,  4 Aug 2026 10:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457B16B00F3; Tue,  4 Aug 2026 10:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB576B00F1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:17:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1047A1A017B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:00:43 +0000 (UTC)
X-FDA: 85063596366.05.36FBBA4
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id E14574001B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:00:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=itc4BBKJ;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of axboe@kernel.dk designates 209.85.161.53 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785848441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CD2iqK/EPaClCBXLVXSOQDWirgcUGjlrzZ6ba7dIsAs=;
	b=yfru3DzcNaZ2H6BvH8WkDWB2RtqqDMWiLDyg8Q0zSAcXwwcuKvo6irFkM4CsiXR5t4tnmE
	F6lGqbFbkDdg65L80wcl17l3n/bY1rh9eqVMUaYSi4zaDFuBfIVBuvWEWg/v0OAXNhPSs5
	T1jEmCz5Xn7Stcn7jGQaoQxuMkNvUeM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=itc4BBKJ;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of axboe@kernel.dk designates 209.85.161.53 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785848441;
	b=g17S1V/xKJJ3SWrgnKBHo4q3I1U55pSf9kAXX6+ZV/jJkybKhSYJzW1MyaI2yjtUR4x2FD
	xCxxywle/VOspKg9tARWvDe6sD8zTfAVJRl6t2b5wVmZvcWARQxvE23Dz3Rtjiv0GBlEvY
	diB4DOHlyy2tH94XbTv4pXOjVxwW7Dw=
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6acb63301acso692971eaf.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 06:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785848440; x=1786453240; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CD2iqK/EPaClCBXLVXSOQDWirgcUGjlrzZ6ba7dIsAs=;
        b=itc4BBKJyqv5UnEpvkWGVJcrpjabqjCsC1dl2ko8cXfL+lx2g+02exKE3jNytAv1Lh
         mKvyNbrl2JDovEzWo0RDShYrq//8vFVDZcIIHTjKwzv+URZRthC5Ii8nDJrJLEQBpD73
         VfQfZ4FMjQSfS7lBEbxReBDzXw5fnDivZqFbEAGxvD8iswmNPD0ZBwuPu4Z63m4kB+FV
         Q/6UfqobpkFXEWmbtlYGCwCLw0dKNx5lgxEI/FTPdlovBMeSDDqDKqJIYF7npTP1mMnQ
         h2OZz+YtqEp6G1X6C9JWKzkZnLPMMlzJhCrqlbhjmcBroyKFKJ4uKZntFMgp0JLwXS66
         P0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785848440; x=1786453240;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CD2iqK/EPaClCBXLVXSOQDWirgcUGjlrzZ6ba7dIsAs=;
        b=DqqDh2VqePObT8saxiiSRgBJH7XU1G2h+SP/ZL1UJAarbdnHrDMU2UAZjpZE8egtLI
         eIn3/eZe/O04iMj/o7fG/o73dGwPf3NwvhZCtyPksG0NUAIfKPV279DlMe/b9vufhHEX
         99Ze1bUTWmJoifSLm4W+Hh0wWj8i1Xey0+k2Hnznp4Zv4yaTKBPYGTzrHuVllOEj+xdc
         wTg7prKPSP2EP/yLHaCKgdh0n2A5G9UGn/XebfJtBN4QfV27mDIT8LwQ5D8gFpFvCyBV
         jc2gBs9w7nXqmFY8dYdTcW8hCXrXdB0GTOkWuYkbuq6Uu7kAIB2Cnirj8KSmfkayhG3e
         O6hA==
X-Forwarded-Encrypted: i=1; AHgh+RqiJgcp5SAJCdB6hZDoKYby4umdpRGegQs79Hka0S2quyWUaU2UFzOaaAB5sMmPqt5IQQUMhlDIgw==@kvack.org
X-Gm-Message-State: AOJu0Yy90FIEABMS2gp+32TCIahsWkLlE5UgXBEc4Mfl20S0fLTRTONo
	K8KYwFhZa1CL5aO0LKAeJro8rHS7JJJnCtMh7YKlNVtwVve6ZRSn6LJIU6/vD+2v+kE=
X-Gm-Gg: AR+sD13l9+tVOWuS3N7cKKklbLzhPIG8GIjBEbZdolsK/Vck3nBqSDgW6HP6RNWZma5
	SMbonsGIGV4klolFEPtWDZlURIlHzsQlqeICcVzsouJqOu8DzJWBfOYNfZlOJz34IrZG3/p8+9F
	LNPkwn9n1i1oB/MpIG4xD2hmaifUavAEaPs0sAd5msRC1gSzzgwWtWBC8li1aWvsNhXtf5ZVU6y
	zw9QLzzLiMiJRGWxABdKWLZaU+u8hpygMNmb7yX6bKPY3YiBouswiJvy1Agui6LE+kQVZnFq/WL
	Q7fg9mXaMx4fS1N1nFYQPhHRb8L0l6Kv1TQZvDMoZxXKEUToO+tviqXCXzdsLDkfVo5+8gdI8pY
	PvsVrwJ+n8Se/19OS82BvFZ2ZY++tmm3/J9by5153DNHtqo2AJU0foAwp13UjkhIKH5DnZeQOmW
	hoU8heAUV/IXiLKJzfnuY02xOwchuXFyC99rQ+LjbsnQsRYKq2odecu4QplorW0Td2lmA+qswM5
	eYlbBRAifNVVQT/3SeZbcRBY0cweoLNR+gVaWUwirBfWNxFCfA3
X-Received: by 2002:a05:6820:4de4:b0:6aa:e7f9:fa68 with SMTP id 006d021491bc7-6ae828b8bfdmr4365672eaf.11.1785848439805;
        Tue, 04 Aug 2026 06:00:39 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6ae93d61482sm61530eaf.7.2026.08.04.06.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 06:00:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-aio@kvack.org, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260804125524.740996-1-hch@lst.de>
References: <20260804125524.740996-1-hch@lst.de>
Subject: Re: [PATCH v2] block: split out a new blk_plug.h header
Message-Id: <178584843869.926496.8137441533296046276.b4-ty@b4>
Date: Tue, 04 Aug 2026 07:00:38 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Stat-Signature: ohcspunae695x1t8q3am474i9namagd7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E14574001B
X-Rspam-User: 
X-HE-Tag: 1785848440-119219
X-HE-Meta: U2FsdGVkX1/Bg1XSaiv7Tsyi0+rG9II4S8HFVt5obI4gtHVJxmZ5IBHAbeVxBehs6JCEcYzINHCFdd339W7qiF1WfHC1k/v7PDQaPWCphGxcxIRgdt94a6ly7Xp1ox/w1MltafVYkaQtvPDLtyAcvVPFIjzYhSce9ZdCKH3WLws9w/bfVdDwvyHul2ToDddchJ9LPj7tDXVp3wK3up9st7Pm2iggtjtLj8fwKFrpm2s8hKh4dgtY+H+P5GXQI095xVAoA82JPFKXtNtH5AdHrS7qoDB5tBYBCWtI0lH24cC4keeFXgiYbbMI5/REqU16hUcwtcGR7RFE2xX4G3t7eH4E3vde/c4xspIHYHmK9hXp5Xf54KzXogtg8OhGkC3ZUV6DsAQkcowO6USq7qMnq/rcPGpUsdEZpZvhbtTsTBcT7sA7UTI4Ap5IBmkNvz8grHUu4ziNDcS0s5ezX4sMmOCxdXUY1LK4+INepvKVCj80DRBkbv8ZsGenpDJfvGI04+APiMhFD7YGt8Mkfl4yRqQlivQpjtsd7+LkzbctGcNnOrgfw2uvLxmNMOo0JH+bK9IUJ4YOafJTWqoxhD6xNTzwfdsHAThtTe743wW5k2cD1VjWA/AcAsglJj8OyKVhoM2ilWDVSbC1IJw7tBZTOswAow6TWQ9ddzWAFujB6OsG6R8wfLpg+/pp/HtTvduvY9Ia50ZSY9bkf43ZNPI375XYC5kwdt3o7dAGR+6I+waJ0wxcfVCScuCUGWdPuo8OetJN+XeIwW3tmdXNPvJ3RkcsF9etCFfx5iHD81w3ZAtQ0CeYoSBqrGp9oO5iNYTvt1BlFLbCa6xDpo4i/lig3hCjJyybfZEsMln1R0RxxLAHmIuQcrmTtTWO/YC729tvranoQqIBh2Bh16oeM+a4MRlROf/sxuh2YA8HsmSh4rV8HEjlVwYQuBBXYRsr+HEbzRMGtZYQo8w/BOMetuV
 tGHwLf+Q
 w4jnXL9sQ9sOO7qf+OXR2H+8VbKKMe88D0zeWsA5VOHlQYg99T/XhGZi+m9yrRh2fgWrmWYGGdjdc9CplA1jbAN/60GgB2Lp2isbvUpASB+LWWGVra03g3VFMX37OpyMP2ZkWbM9QJV9oH6umDtILZWUBUx10kLSy9f71TpXDvHx1Lk8h4jgUil6C+Xypt85r+w007m90mR7+IojQVjQvpMZEqrNo/AabpQFyE9DfcQu1Zvmk/TueD0l72jMc+CUV0QFXvF/19l1YhqHnIzHop8dVcgj+ixz1Gcf/LNHy9nbXaDtkMQld52otIdu0NwXwoKVCghFvXWCBKlVuhjjXWbQE0b8l2DMOitrRz9fIuCZw1PfLtA2Um2jT0xX0EdU+kCOzkFtW+oS8w2xeoY0MQuv1tHgRRh1LNnebX5hh3SQKBZ1O0DuXv9NmjOdn52gmY2so
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, 04 Aug 2026 05:55:10 -0700, Christoph Hellwig wrote:
> blkdev.h gets included in various places outside the block layer just
> for struct blk_plug and related plugging functions.
> 
> Split blk_plug into a separate helper to reduce the amount of code
> that needs to get rebuilt when blkdev.h changes and to slightly
> reduce compile times.
> 
> [...]

Applied, thanks!

[1/1] block: split out a new blk_plug.h header
      commit: 758b86f7bc8a2582d0783f3535854ea05d3ff97d

Best regards,
-- 
Jens Axboe




