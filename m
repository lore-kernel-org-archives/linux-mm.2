Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ADC3E6B272
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 12:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6846B0005; Tue, 23 Dec 2025 07:11:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9947C6B0089; Tue, 23 Dec 2025 07:11:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876276B008A; Tue, 23 Dec 2025 07:11:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 765486B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 07:11:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24513B6C44
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:11:10 +0000 (UTC)
X-FDA: 84250620300.28.F003EA8
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf09.hostedemail.com (Postfix) with ESMTP id 29D81140011
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:11:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mpu314X8;
	spf=pass (imf09.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766491868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/wET59k4s2dAKSrBriEQvD/zKuN/8Hb0OllkRrq6ng=;
	b=UFH8OsIevCTjsQSror7MbntzLi78Xh9Xz4tiKueTDrYAeSRcMkC1rmd6LiBidEkcRZeWcu
	Y2jnN/Bo3nI/UuOdLqktAtSaHT55Xt5MNLAZ+Lw/e/sxcmtVr6V0or4SeN9rz8YtoFPfTT
	wFRQkWs3mFVb6DbWWuzXCm07ws9gwvw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mpu314X8;
	spf=pass (imf09.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766491868; a=rsa-sha256;
	cv=none;
	b=z3PucGsQCLpdhMrGwraaIGZ3kWY16gdPsAYy0bb+HB0msbehebUzogt8QoV9YoPAks19wF
	CwMQVvhCqgx9Bium9MnuurA4T+8D0HywIMlFzE5GIh+FXI7yzD53gnQQRmm04Hxgdn6iRe
	xVaZ/u8bLaYR8hISeCjYoIA1xhpmujI=
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-47755de027eso28813635e9.0
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766491867; x=1767096667; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/wET59k4s2dAKSrBriEQvD/zKuN/8Hb0OllkRrq6ng=;
        b=Mpu314X81f7H2gXSveZ+NngEGEqlkLBNkxXM689KYsci+h3udUSJuY/8zfZMS7b3rK
         cJbWfF4uGm5wZGQtUqQ3Ehpv8eY1KB1WnUCNdho30UJSPOFUQcR/ItaPQmiNvihY3R2v
         0saqoOoW7OuJgITRUAMVscTGxzJ7idEloHQNl/d4JgUK40s0oTCzptu0yP4WZMXKUlji
         8mfuFhaueUpVHp9ruIo18LyrlDIhArCDM8NOQjkl9t5cunOMOz1NK8/59XHeN01lnB5P
         GbeSNh6BYqUw1aVFLqItXkPaaoW7+9qyrE0r278dP07xZQemRoU9xWK+STH0q2nrd5tX
         D3JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766491867; x=1767096667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u/wET59k4s2dAKSrBriEQvD/zKuN/8Hb0OllkRrq6ng=;
        b=JMAEr8wjMy+MEWKibKix4rpDwXJdL4nQsGqVYvMEU+U8m0OdV+eiFxiuaitwXYvsSm
         HVSUKNTKKjToCmjOrj5wLE8iwrCUaHQHGBF6zBN2PaeREDfFtYrtUVsv+ixu4z4aTmDO
         BsRRXm8qmFxIMt80cRgWTdusgvaq1w4PhpQgY/Z/8T0usHTYaO3aAxNoLdSf+71CdMtH
         DAJJoNYV+PDduI10JxFuhg87LLZbFqw+hd5CbF6dFJZ7HOU+EIYuqRl+nvvW1dU4KIQc
         4ohMAa2n6Et/tTFqshl2+qqF38QlWXA612Vhvfj0wWhxFSkQJm4xHOud0DedV/IoHCf3
         Jymw==
X-Forwarded-Encrypted: i=1; AJvYcCW14jS+FnMhTmX9PgKG60xJZQAZc/6FMXhqBI8JPcaSqV+NA/l63anp11aCB/5CzXq6iSb6yDUKtg==@kvack.org
X-Gm-Message-State: AOJu0Yxp1Tr31b4AbZrtZJFGy8Ctzhh1LUlLpDIF3N6e26H+1ck4TIwl
	Zg25CCccA7EY6zLiO56VL+KsStPWoCUdFw2vtWkx/Fa6hIIEsHKHHqwo
X-Gm-Gg: AY/fxX7fJz5/Sb5eyt253YGfUzqp3DwX2/gU16vm237lGJMtcw5JjHo/8w0stvz5Zfg
	lhyHBSnojkiE0lZ7lBZ2cpJfpiZfWJLIEDd4ZDNDHp+HL5lgNb0XV8D8C3OON8lEvCbaiYMC9Oh
	Zc8U2bMq2H8aKW7DIu6qVuhhA9azqcv1Nm+diQ7mRbx5ZtUjSbwnXkMqu/Bm0RPwpsBb8be+5C1
	zwnydyqCSO6QzpT8rlI7/adfZ3nD9mNMis3j4ToyyDy4z7QMv12hCZyGW5LjT4HQETzjWVdlxtd
	GxTW2haiKYUzC04Ne2mgiGwBmOUFeGcwfBmisSaGLo69ZvyBwfDoxOoJG/D51JuM0bsZiNxB82B
	7qMn98zVfjlmMTDiOiX7nsi5qVtnWhcT3flqWsn+dW+Qn5cqJ+XR2xxEnhD2r3sn2HlrjcCRcAd
	5jX2D+TBRWuKn/e7Z+I++96fZYcdPYee9p7bLRlR/nz6N01ura7Fc=
X-Google-Smtp-Source: AGHT+IFpoVFVoGdds3xWS4nCVuXAsQ9kuPwMMvakRoZvNm0Y5y6VuK7Us5eEf+GT7UsIy7axfy9yIg==
X-Received: by 2002:a05:600c:4e49:b0:471:13dd:bae7 with SMTP id 5b1f17b1804b1-47d195911b8mr125877655e9.30.1766491866369;
        Tue, 23 Dec 2025 04:11:06 -0800 (PST)
Received: from pumpkin (host-2-103-239-165.as13285.net. [2.103.239.165])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193e329asm239696985e9.15.2025.12.23.04.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 04:11:05 -0800 (PST)
Date: Tue, 23 Dec 2025 12:11:04 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Li Wang <liwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>, Waiman Long
 <longman@redhat.com>
Subject: Re: [PATCH v3 1/3] selftests/mm/write_to_hugetlbfs: parse -s as
 size_t
Message-ID: <20251223121104.6614c1e3@pumpkin>
In-Reply-To: <CAEemH2e3C_oor-CK3_35m-gAp6uU5+75up7sL0wfX1MZdh3+jQ@mail.gmail.com>
References: <20251221122639.3168038-1-liwang@redhat.com>
	<20251221122639.3168038-2-liwang@redhat.com>
	<20251221221052.3b769fc2@pumpkin>
	<CAEemH2f40t+4SsjL3Y=8Gid-CBMtf3eL1egsPKT1J_7LDbdWPQ@mail.gmail.com>
	<20251222094828.2783d9e5@pumpkin>
	<CAEemH2fsAmhAkGAQb9rtD2WLUc7QMb9Q5dusG3S8LsJbNKsO_Q@mail.gmail.com>
	<20251222180509.b12684e112195ac3f7ee9389@linux-foundation.org>
	<CAEemH2dZ3DxDPWuV1Uze213CqoFHec9kK+MeteigGANYTUzbqA@mail.gmail.com>
	<20251223084035.67ba1b76@pumpkin>
	<CAEemH2e3C_oor-CK3_35m-gAp6uU5+75up7sL0wfX1MZdh3+jQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 29D81140011
X-Stat-Signature: rj65o63eyuna56b5rfxjh1fuf5t931z9
X-Rspam-User: 
X-HE-Tag: 1766491867-890003
X-HE-Meta: U2FsdGVkX19R+qtVFDEctOE/NUluCTwwGgM9gBSJL+0EECec7++SZ9lvdeQ18D1Synvw6AzlEjLro9fAlZxs3ETmkBj7sS/VzzlDXtDMseK5hXu/d/Yg8JmY6jeSK2dBlj6esjSn7dLcchBGuL/EM7w8DrAG7M721QGdxR+EJcX4ziX+bxlhoDxg6vfO9x2P3obbVegw+KMh45EMyy6POK+3WRNbFPlgaFTP56XMCnSamkHPKoPcqDzlvsPRZrfpl1uQF7FREbrkn76C8Pp1I/l4qDKxkNYLp6ARtr7DmfGeNi+oZHZhJVTBn39AChr5UHxVI+EMW8/ILTVLTq3zhb4dFc0duWFIyS5laTlO58Vja1eDAYS2XdEVLFRciPvXigffLvFOMnbmNsqoiG2vaClc8jGaoAodoUt0Mwz3Vws1JyemwVhm9zJHYkDIfegMCtZ4vw7mIfgs6yiXEfgnUga33xc/iZOGXt/f4PyyjXSIxBi6dphmSjpvIl9odjxb8ueUZxJUNhJAlw/Dq3WiCDG8NxkTaTWTnYw5fgXr9+Gu8uByv1SyLh7nxvzy1paGuwkmw8BVnM9Vw5NKvIQ59Ne7i4zof0KimQ+oYlUuOm8F3Wixe8vDBW+wnZs8rqD4JEDWmpxNJkEy9qp0k8N+uQ1Re0AP9znpIkkq2S9Tv9unOwKASHoNMOo4Thz7N4JQyvn+yfgZXLp9Erqp1s54Lij7ELVkGvoFyR5/GJszWHDGzRcqJBF8uh+5h539G4VVZQpRJJrAvWt6rI7ByrFTJz+lqb52PuXqNWfp91WT2UGquqVCuvs825TJbPHRnv0l4Gc8uZw5mVUoo2Vl7QBorNTYt7DzMUJuXicFhgQVDuq1Y1QIET0ZJ+MJMkgcwh5qAcaBVo0d3sjFcYikp/LCcgxw6luyRZWnS+a/GrPoarHHPn9WxyvcfLvLrXL3Bm6gmVseJPWcnTfpQ2mDHUj
 D6ft3gCM
 +lVgXqkTQyMo0r/68SbbcV0gR3cHVUxQor3RHpGHvYnKvvopKlLvwpLO6aZLsCMxjUsX0kSAMe+kVVWH+mWSedpUv6hEMUJXmz1FVDQ9By3Yajj8R/wgLuKX1/QqoXGJQg+aFOwACR2vhd/yt+tEj4sZB06Ui0jZ8rptAtQOPBf0Wux9sfvcVQBk64zohBbk6CtMU6D4Y2SaChNJkW5N5pm3007P0HVl9hre0E8NjoQC0VhY1zln/nffv+0c5faS/FAuCrZIl42Q5X7K//IJ3z4SnroSiGH8qlL4KdW0DVMKwBkE4lmXwhxV6sQymKVvR2SeZwTZP1SU6ZAHoYSJenjZp77+6fZ9ch80QI1qzR+lP55QCzABOujg01g1VL5sIq5SM5+BqJ48w1+qiD93b0z3vj/HVNaeF+EdombmxiFowTh2EywIwUDnnDGwVwQICtm8xKfjSZlZVxtWTSOrc9fNC7zdTd66j2Cdb8fCmYXSNQndgbt9WLj5ZrZ011NbayM3sl+j8WkH8IwZdG5nuNqQFUpKbiCdr/m+NZv7QEDWYDWeF8AD8fGVPRnNeNUP3ieuZ/jzh22SyErGBAgToQ/XHjcjkp0wGyYH+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000055, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Dec 2025 17:29:38 +0800
Li Wang <liwang@redhat.com> wrote:

> David Laight <david.laight.linux@gmail.com> wrote:
> 

> > What was wrong with atoi() ?  
> 
> As the patch summary described, write_to_hugetlbfs previously parsed -s via
> atoi() into an int, which can overflow and print negative sizes. This
> problem was
> found on our kernel-64k platform and
> 
>  #./charge_reserved_hugetlb.sh -cgroup-v2
>  # -----------------------------------------
>  ...
>  # nr hugepages = 10
>  # writing cgroup limit: 5368709120
>  # writing reseravation limit: 5368709120
>  ...
>  # Writing to this path: /mnt/huge/test
>  # Writing this size: -1610612736        <--------

So the problem was that atoi() doesn't let you specify valid values
over 2GB.
That isn't how I read the patch summary.
It read as though you were worried about detecting invalid input.

	David

