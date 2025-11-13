Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F4BCCCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6308E0007; Thu, 13 Nov 2025 02:55:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6EF68E0003; Thu, 13 Nov 2025 02:55:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B10268E0007; Thu, 13 Nov 2025 02:55:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C80A8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:55:50 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34861BBCD4
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:55:50 +0000 (UTC)
X-FDA: 84104824860.12.FE46C68
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 55B82180005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:55:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hkEG9olc;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763020548; a=rsa-sha256;
	cv=none;
	b=nCSy+5N3Vuzz7SYDZ2f4CD6LxW+egqo7O2S3Sff0iOKq5D6NW9YmzLKWxTXjdfE+O3KIx9
	KgdrazS1o/Uzi9UKCJIJXkt6sv6RvtzXWwR1wx+mWD9kfrl+b+xrGvY042h8YD+4+48heL
	L7KeUUKjuYq6AZRvPPn1DVo/aDvwB+0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=hkEG9olc;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763020548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqOCdzG8TVwmmpstxldCFsocgLp9/QVeRrpBCk4yxaQ=;
	b=aU1GLtBIh4STWQ1MPpd20ot3ifuTwa4lL4rvf+TsiNvY7dPNFbbj2wDWtUJu/7WOn43del
	ZvQA3uTACUpgnBYh8a0OwgYcU2xkQWpvjMCRMCT8F4qtK8K37Q57oovRqw/r85cLFMpxkj
	8W5T4E2+W1BsMzdtG5B+6XrJ2cpKc+M=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b55517e74e3so446203a12.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 23:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763020547; x=1763625347; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BqOCdzG8TVwmmpstxldCFsocgLp9/QVeRrpBCk4yxaQ=;
        b=hkEG9olc9RTZaWadI7FuaBcvMjcZQvqYQ2ZypKiZZRpBnluckfxa6u7ex8SxCQDsPZ
         0ynsgf5fYPO6bD4tAqw8zUJoHbekMqUY0ObMs2hX4ZNS52P2vBSx8jB9GhPS0CUVAbuk
         lX911HAVwZBvDNUMxwX+8h7LVx6WSv/fJK9PA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763020547; x=1763625347;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqOCdzG8TVwmmpstxldCFsocgLp9/QVeRrpBCk4yxaQ=;
        b=XT+y0+WgoeJCJ+/Sp6bdAt9c0p2oJcU6RmqNYKYNgG6b0kpZ12pfwv2JmmXSWF5yG6
         PSslPeuxQnGNCgpWqpOTWl7iL72PXfY3pbzuYg/v81xW2Z3tstxqyd4dcpyZ2wlKtELZ
         G0hvqotjTNcQqUHNE3e6QpaGcWYnrfs0yPw0PBk5tZU4vnyQ9OgiYppOCyf6NWqzR08W
         vsyBYrJ3rHn9gNeKTX5xOmIv4Bk8hppkEUfBiMtzk6Js1b1uz4if8cNCLW66ea1ty3u3
         +qykj22A+Ghcg0MtxOHvMKYTbGmOVHgHTJjOByBbFoWXxhFOEOB76snwm0Fnsp5MOBgs
         opKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUzmsmjC3ypX+vG8EPODjOE33+otaB06g/1x1SLHRCJlmtf5hFCPlQ51Ps389lsF8uouaiuPEBxg==@kvack.org
X-Gm-Message-State: AOJu0Yy9HJercxm4tEHcqFWVpLP9Kyf3hE4d02RTl2WQX5xiFMqqzxpR
	TaE9Jij1AbyzKbQTytLb5F5fxwwlR0zvjR9ABnsuSj4TaCvpaa5C55P3iVR6DdUtcw==
X-Gm-Gg: ASbGncvBBNqxm1r103MUhGt6Jtk9DNeMlYgpHmwOjAr+VpjtK/GVzR8CemZaqfvYut8
	wcnCEV+SMx7cBAwuzxtWFWcdF+ljsCkuQHXepwpwaL+iKivzVewOzhhZFTqBQHnCvOT6GRYihbI
	8Zp6rF6H37T/7J2siHOwbNJuPWaML/0fm73zzB6yVbSVWKGu+UmkAkPRZEG6vuq36d38yqBox+o
	J9ejCkHMhjOf4xC7Qaqjsw71Pu+8l7XP0aHWx4zrywfRgy0wPIz4/jtSbDxdJxlGkZzM+A9Rwww
	wvbjSpwzgE1xE75zh2w+shByLEETdoeVhBfgNDLknnkEQwM0k3dr+uhFVr+SsAWv9ZUjOUn/D19
	CKp9fEUwWTSVnJWKS1YDl7QCl+R9//sDHhWlCq6FTo2sf2nyh1fx6xs0idwtLzGGqojsYbua6gx
	pIkXaM
X-Google-Smtp-Source: AGHT+IFeFnwmYEOF77S5xrw0OtwdfxalTIPfjFUnxj2d/tiwYlK6zp64b1GatmlTBDH62gN5nOONJA==
X-Received: by 2002:a17:902:d54e:b0:297:dabf:98f9 with SMTP id d9443c01a7336-2984ec8e279mr73263485ad.0.1763020547289;
        Wed, 12 Nov 2025 23:55:47 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0c4bsm15357275ad.62.2025.11.12.23.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 23:55:46 -0800 (PST)
Date: Thu, 13 Nov 2025 16:55:41 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, bgeffon@google.com, 
	licayy@outlook.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liumartin@google.com, minchan@kernel.org, richardycc@google.com, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Message-ID: <ob2qytrsog2ydftywgdxdis25c2ygboqqltbwcfuaks4iaxzct@lwx7xyklzdde>
References: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
 <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 55B82180005
X-Stat-Signature: yw19hagf3n4891b5hh1pqoteo3jm8ru4
X-Rspam-User: 
X-HE-Tag: 1763020548-915417
X-HE-Meta: U2FsdGVkX192etbm/ieNBy4FZTO+zcqJCxSVHZ4+cOXjDaijpSrB5tFHacdfB1v7MFXTSMIL2/qw8nOYVlWuZjr/QTnK9QlMwRVQVr/EEv2Bqdy9z04b4QAedcY4zI1y4l9mc+1/dsM1xx5VeIvgnZWbosT+mMf4L1Rd33O05ut+bsV3V8k1QTehgQCUvGXgoNA29kPj3J1pi7AnM+w1QBtC4ylxmGcA6rTIl8P1Ot/2aONkSVdU9GbzFDbzMaU66NraWNFCiHYiWfU0cqbrhWXnCDb3B6GGp9bmoTUcPLvKKToWG6F+ruK3PFYk3UejwuC2u0a8NT7NyVKzEIfTdCR5lcHYFrce5kjpsdy5qvnnNiwzuDYjoV5zy3dqTPKVhI88s5GfcyKPHqe1qlTgFRFMrx/cY4jBOhMVLyrwBNQCF5jmjoh0DAUwFJSsByG5hGzHPA3MizhKq0h/mSmac79iD7ty9yWBMqLBvtAVeEbz6r+DDLUyXMJgiUu3IKbBr629PxOf2FeafW5X+q2EXRHuGJA+StymEZooV7TpLUB2a+LBQZOA3O4dLNGZXRJ8XhcERN/zDdK2ae41IcrYb8GnXKGfO+F3qD+yuuA1zDGHseeoTb63qBr9ZlTHwSlxML62XbDPpNP1AY3voDB+oxiekCnr7/WKRTpkwzmskSF9K1DgaVmooIvcQWnJK5oNqrxL7ERr24GyVcxlRx13YX+UpywzV0UKs93UR1fhmrMhrGrSu0ItjaeRqMYf0RkEOheVWAaUMGFtN9wqfrZXYLO9js97pcudpsu9QT6tzKsTEUZb/O0rTe6gfBqrVhdub2ikXpeJFV3Oxk6N7WJWEWi/rulfHEUZgP5xP+LW3VEak91UJ7zUHsqFpHF7fL1Y7dqS0Lh9UV2fR2f2vofapfMBZu1VXYsYYdRCLgcd8dAnJo0yk0Xz5jaGlzrmJlueeDSCSe0PLCEuceLUP7o
 8Hrob27h
 lWk1nX0i5oCAu7nU15bLTNEdbpvDKcolDq3GUXJ9e/33nOTnzICGangMYsI4fxrdII734Z6PoE89D0cNE2NExlzrnZfT5L7wb514HO6PM2lbc2EWwAPiZ6sie6VdcuoNoWDIXM7YrrbzF8FcYHwAIx8zNXgd/P2VJWFwMEH7KJPyzKQquHpxzdiW/4FM0erT3a9m7Vvyd29H/eJTddvX1BPM+aX3M5iMWzRnm4nEL6bVt7zCZtko5t5w90sEi+S3IGFkZbUyXo9F+OjLWtFm7mPN6kr6proIrXprKGuMVtgGVzDERl7m3l0HdFL+DKCgWafLgchXCecBUZhJH9rsaz9WRfP6P2meVO2qKtDZYh9SozrHHMtKw+2E65cV6ODqjuP9v2rFhj1KDDkG1SCSHGjUr24GQR3bMkkm1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just a minor side not:

> +
> +static struct zram_wb_request *zram_writeback_next_request(struct zram_wb_request *pool,
> +	int pool_cnt, int *cnt_off)
> +{

This is not in accordance with the kernel coding style.

If you use the best code editor (vim/nvim) then I'd highly
recommend the linuxsty plugin [1]

[1] https://github.com/gregkh/kernel-coding-style

