Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B433CCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 04:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926178E0005; Sun,  9 Nov 2025 23:49:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D88C8E0002; Sun,  9 Nov 2025 23:49:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ECD98E0005; Sun,  9 Nov 2025 23:49:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8AB8E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 23:49:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 096665CC24
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:49:35 +0000 (UTC)
X-FDA: 84093469110.03.95310BE
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 278E2C0006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:49:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CXduSTLn;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762750173; a=rsa-sha256;
	cv=none;
	b=PnuQjobpiTyt6CwsW0IXjjFM+q+TZlEch+svR4Slg8xAaVIvIHmQd/tQADAvPrnhtnG4nd
	4z9OXXyevJDc9YLZfyTrtMnaXgZbBcGs4rW8iKGrypmDyD7H3ndEqnXFrChZfBsh9cLgb+
	LiXk5i0jN4p7WaQdCfDrbWQYOqsukz8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CXduSTLn;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762750173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJrfHDLE5lDw8HoUWCOGU+LDxN6zZNc3/zArvkGfYpA=;
	b=KagXidb+/6RIw3ds1dd1UrTTdn8Af8AXJ0YCP26iC+jua4zuscKXdtX//KUgxS0J6ogXb8
	NADJoto5H8nwGSNHZdSoKrakGAJAy1xq8P91Tx6A6ztQ9LAitbfB6Qlz0KDVaLl/118vIz
	HI7tpXMHAKdI/JuIMWOVsjqI5wGetq0=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3436d6bdce8so1784316a91.3
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 20:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1762750172; x=1763354972; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JJrfHDLE5lDw8HoUWCOGU+LDxN6zZNc3/zArvkGfYpA=;
        b=CXduSTLn/x6H6QA8YfQsHtQ3Ae2LqwWL2p8+p3NJ/HCfwjE646+DBtkl+GQ14YjF67
         PdHgzxRwCOYxNZo2+vt/JPo8moGnLzRW68Zlu8u0KxwQtAq8xHQRpf/ovEuEJRXKPDsV
         EmHU1E+RhbkJczeuuNXVNi6F07L4wpdquyeeM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762750172; x=1763354972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JJrfHDLE5lDw8HoUWCOGU+LDxN6zZNc3/zArvkGfYpA=;
        b=IXv3N0+DPQEwj6vgarkj0DYwY8h7sCrylyMddYFAavo1o35qAev9hhK5vJMtg0EjFu
         Rg5gRiRMVei+Gyro0qnLbYacqHyPgCvhAS7JOysoZnmiA0yUMmAM6fKFdTV2m9eadmjI
         Ep0foum2Rgph9xG+9cLl4WuL9kV0ls4mJpx/ZQNs9zBumFiFp+EPuHtHRKPaXHuVxhyF
         X/wUYCIKn0xeOFgEO6jARveI7pTGEutWSN5EqA1LzZ5vrkBhLg4cz1QdFHUoj3MyC4CP
         y+9eH3GYgqiebonVOJODL96BztuSN9jmHum22yucqsT/AQYVniT2XCvbHrkBpzxOpLgL
         p8HQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfWTThAbO6p9QvZdWUWZxuSGEeSzDfX67vgNpnbt1h+Xsrq/r2Cwr4y0Wa+CmYG1kx+etB1uAoOA==@kvack.org
X-Gm-Message-State: AOJu0YzYpCs7/YXE3bpRaquyR+xHlLgBwuASGnQ5aTjxX1jUJHnk3Gfp
	D/ItUgmWm7k65GMWKWJU9uoINNnh2ijDM71fKjCHxY1BCADreRN3PuwMV4aFIUWFkw==
X-Gm-Gg: ASbGncsoZbPGi5Fun42Xf8rVZgyKU2XEkMJVStQS9Ej4lRGc3ufP0dL+7UGCxUwAADL
	l27xgs7bQ6B6rF5qfCMD7ffQ9rdgSlvigzk0sbocSA4CXyD7VAd96rdE01FCl28KCa+ByooeDTa
	tWmNgmisEoBQUB4w2+2bzJM265wrs25u934Yal/bj+syOP1eJgdm4S48VO0xE5KqjzHxlUl4V0O
	57zCe4ZNcT8pF72qU1SosV72zCyrQj4Y1kikGlVXS+6LvNpKlrjebZkjVEfsn4sprMWpmgLrh9r
	IzHEmF6MfHWtHixmB2ayjUQteKHAHrJpsB5SmpHVKhmimvrMrUJ9L3a0n3khhyC1T4xI3UhBc3v
	X2TR4lbD7u3PsNZWHD8kWadksYanI2XybbjiHPo+ex+xKNSXQhRx9uusC3ycye/gFkGMggeFVKh
	6++1MzdLnnPZYYv2I=
X-Google-Smtp-Source: AGHT+IFU2CaJomS2LyBwnHV14ftccCZxEQuCF/t81lUe+RkW65j+E/MggTuG8Flk2e7EBPHiXfOouw==
X-Received: by 2002:a17:90b:2d81:b0:340:c4dc:4b70 with SMTP id 98e67ed59e1d1-3436cb7d916mr10393716a91.6.1762750172021;
        Sun, 09 Nov 2025 20:49:32 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:f189:dea3:4254:ff1e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc17ad4asm10139624b3a.37.2025.11.09.20.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 20:49:31 -0800 (PST)
Date: Mon, 10 Nov 2025 13:49:26 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, bgeffon@google.com, 
	licayy@outlook.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liumartin@google.com, minchan@kernel.org, richardycc@google.com, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Message-ID: <yv2ktkwwu3hadzkw6wb4inqzihndfpwb42svuu25ngmn6eb7c4@hclvcrnsmvvk>
References: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
 <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 278E2C0006
X-Stat-Signature: kw5jy18hywmos3gw8q5g9bju8tiybt5p
X-Rspam-User: 
X-HE-Tag: 1762750172-959491
X-HE-Meta: U2FsdGVkX18Y2u8gPwEFuFSPaVLz/8ZjXIa2FtcRZRWdQmADEJORsKSrkhEMewpsee2e5GcRBEiaqD3v3pe1rUWZtsLL0PCcT5MuME3BtfpcvXkHFiTsb8Mdk8pVSgO1/9Q6DxtLWQaYSQGrRvUCHMhCkKXH+LJMcNaCA7Sszan0Y4Y0sbgNqfr7I5XsGRqQF206dKrLr6cCMEbGQ1jXn46XMYnRMT44NZq2/adKHqV95sudi4TBjLtCaMmc2KcbKKpj6EnBz41qFlXUy8OUYOmzAvJObgWYz1KNzIyFlbUsZZGKPUZK50+sVfEJgJft7jquG55Ph8s6QrzXfzXby7rZa9Uzs6wlDJ8h7uekLXGA/5C3Gr5kX9yxi97BX4L/FAGT6CqWv576YYVax7ajUuVddYFJkLSiev6hwP+g90wwhA+YF8IHkfZQsLv0U8iIhDgvPUt/qW1Up+F+Amdfm6TA0mAOsFF4mg1ccSOa6nQUS6S7YQ4+1+v7wKMzq7XWn39YR+BS3ssUM9ECT6hOfrvz+GadsyU7tUzQSsnHo73VijyNhRpgcRZWDo1atqdbI5IkBPihQDnQoreJzEGIUOTe+ylYJZecZbn35wStMnj+RaiShqii4hjSBO8Ai8TSqDy36giXmuRCu44BkUBNZgsOr10lAs5twAP8CP81L45xu5wpmMAphXFFBYHuxAHviNbirfygrBzloBLl0Nx8B+kYj7KBvh5BWBjjFc718f0fNWfdhsWthPdwKg6reE7PHnmxiUolxu7D2KiJol2s5+mp0W0pxb6/C51K3mwKYA1N2Mid5frDO53YyBtki/HGRXWDoa7X/iNAjrJ3gbKLyvOqNz27ZBQ96ZUiaH0/xaWv495LmJ/j2i5X7chySg088maJ+pFr71HdGGD221MmPD7brhGf1QaxJspFkOO/Ah+gNQ4hgB//935zvOkmlRcsisQDjyekHfYTdJWO5LX
 O5QG6yyB
 xIx9uUpixU718EwP9kNCv2E7vmjH22guAnV6PRBX2dqleU7iZISQreX5Ow/QIOH6GiQ02nrF4xZh71lFPUBazm+dADiIWaaD9uX1M9qA+zo+KxL+rhtXBmHbkaS4iXImkEajGbS6pBLxXpxjOkSDV1Re8HGxl7RYAO2NluuA97A/M6MLnSCjO0w+D49cK3Wr78nA+cql0o4tLrRmpyVaLa4lQPMwX/VU/9iUaaUFgFXl5eoOBDVHmYdAqpT02h/Je5p+EHJZ7vZemInSMFdkxzuIsjiZgHOut6SI+9dNyEllI+lfecCjS+IQXYE/ng0I8ZgsYfIQSWoNxzYHIa/HE3tVpnE4QkDkL/OoFR6inZJW3wdc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/06 09:49), Yuwen Chen wrote:
> For block devices, sequential write performance is significantly
> better than random write. Currently, zram's write-back function
> only supports single-page operations, which fails to leverage
> the sequential write advantage and leads to suboptimal performance.

As a side note:
You almost never do sequential writes to the backing device. The
thing is, e.g. when zram is used as swap, page faults happen randomly
and free up (slot-free) random page-size chunks (so random bits in
zram->bitmap become clear), which then get overwritten (zram simply
picks the first available bit from zram->bitmap) during next writeback.
There is nothing sequential about that, in systems with sufficiently
large uptime and sufficiently frequent writeback/readback events
writeback bitmap becomes sparse, which results in random IO, so your
test tests an ideal case that almost never happens in practice.

