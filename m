Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65311CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 02:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A8F6B02EA; Fri,  8 May 2026 22:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB586B02EB; Fri,  8 May 2026 22:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA4C6B02EC; Fri,  8 May 2026 22:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76F0A6B02EA
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:18:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2D1412047C
	for <linux-mm@kvack.org>; Sat,  9 May 2026 02:18:29 +0000 (UTC)
X-FDA: 84746272338.26.E62246F
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 107B01A0012
	for <linux-mm@kvack.org>; Sat,  9 May 2026 02:18:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=en4h6dQq;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778293108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTwvstf0xm7AuzRsUone+BxfsctoSovje/yCegOz74I=;
	b=ZGMrlR2JIyUHtcry7NG9GVB08lGYKq++eLrkHLbPK0RQtETVCJA5I1MqIfBo47208iZLm0
	D+SMjCWUYGGfqLn6Dug2opKQ9RQtp64Ilh884FIACOev/ZEfmfjETfDgAJ6noKV7Q8nWBV
	1HaoxAaranhwGrejQJmsaVnkl+ohxFA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=en4h6dQq;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778293108; a=rsa-sha256;
	cv=none;
	b=ctGjHmKs8Y2XDukio36gxd5eW9yxs5MdD0LxwrPokfhPIfHBquY3r0WQ9YpV7tCmN7k2pc
	3EPhAwhQFdh9TKqSajfqUOsSYizid3kY1l6Vy3yT1dN+nZ0GcrCwY645V4ku3oSTPo1IK+
	77B/Toz4w7QgsC2YRMfG+1OTfM5PSm4=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c80291e6237so1755685a12.0
        for <linux-mm@kvack.org>; Fri, 08 May 2026 19:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1778293107; x=1778897907; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PTwvstf0xm7AuzRsUone+BxfsctoSovje/yCegOz74I=;
        b=en4h6dQq0sFRxZkOy6mcIIpua52jqCcogbsYANItcJbrgQgmbMFcFO2tssD6gyJ8VZ
         gPEA5kS3JsSP7fwXdXe6Op8zfqW1yiZ+Yw9WgZkRR6MdaZ6rNFi0LaasrfxmK4RvB0QR
         AxL6b2YbkNp6Z6Zh7UsnmAy5OMS1hiXlt7I/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778293107; x=1778897907;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PTwvstf0xm7AuzRsUone+BxfsctoSovje/yCegOz74I=;
        b=idrYsjLT7ykJQUkmJZv3QQH+9nIc9zM1cCCYWdHmP5TBbhJU5XVyo4A/R67XZrF12p
         7y72EB4sc7jGVYwaHmdpGPrZ2MPdvBMnUyoVQUHExTCkhV3u/UWIfdLXTharv9PALilg
         bC/dbNvLO3Q5CoYX3mBeLoPmAMj3gaLILVTBH5xcjVNWkfNiJqzV5jVlK92X5OqUzdFA
         KOAGIMjLCCNslZwOJAZQXv6DnWkO24tZVMq3rjbgsA6Y41t3YfElAUY/kAqfroZCLgIY
         fV3e1QWyk+9xx1IduuYBFiimONckMmnkTCZwLwsSW1CxMYxra/1u2PaUJ4+DTV+Pykzk
         kdDw==
X-Forwarded-Encrypted: i=1; AFNElJ/TtDTTjsHX2U7SnstjzuzuPwhvwN+TZSzFc09Ln8JnQWpGxaPv6MTjKopQZ6Iudm8oB6Z4w9iWDA==@kvack.org
X-Gm-Message-State: AOJu0YzMVv/IZCGD0eZ3bbrJN8YLzWxXLwJ+9rz/F4oPM260UHg8bFTW
	anFO6lH+1wVpHTsM3Y1eB5dxFtqNGgyuKXgFY58qiq6FiSt5BusZp42+/XWlqkcf5g==
X-Gm-Gg: AeBDiet/Ix/A0i2RGYrViZY7eOEi2S4jQo87Sv+NUnlZUewsUuVHrYrIbXqlzZUVtxl
	CzJkxKpAhUEJHrAw1wSTNNHtd5yZsGx1XJIzxCtDeARfN/5qh+wD2Vhld2gMPDwm4uqIk8XAvtf
	1K1LgXnUiPpBTam7vj1KHdwTSSTQ7i2GsQ41mUTEqsKl+RjC3oid7LX6vtyrXkXQsHxK5DlxYOE
	QMbX0aO2mtMRkMb1457VfWM/q4eyBQNgPWkNVyOTPqU42iNdNh6piajzKxKms1fmSjj0IdDAYAK
	N98Mw8uP+CJpJYo3SPF8TVcu1y8zr31m1BNMV9FEKIoptfTkUmVQNLa9XAUXD3YyM5hnnst95uf
	f9ziFWdvunAbJrzb5GYpLF5tpGEJJq/Gc/ryipadg28YzeZ0TGUV92LtCQ+el29tbQkPZ0rfveG
	6Z6JARJBQdySWlDl8URiXTqqe6BJp0Rnm7TNwsn6PpcNA3gT1LDnmQ5ELMbduxEFg=
X-Received: by 2002:a05:6a20:4322:b0:3a3:1164:c7a6 with SMTP id adf61e73a8af0-3aa5a8fba0bmr16369167637.14.1778293106865;
        Fri, 08 May 2026 19:18:26 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:96eb:c157:3755:4e22])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8267689d76sm3059171a12.11.2026.05.08.19.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 19:18:26 -0700 (PDT)
Date: Sat, 9 May 2026 11:18:22 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Richard Chang <richardycc@google.com>
Cc: Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
	Andrew Morton <akpm@linux-foundation.org>, bgeffon@google.com, liumartin@google.com, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] zram: fix use-after-free in zram_writeback_endio
Message-ID: <af6ZT9oR7GGmMFSC@google.com>
References: <af1BNwmyHK6aU_uT@google.com>
 <20260508084933.3730661-1-richardycc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508084933.3730661-1-richardycc@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 107B01A0012
X-Stat-Signature: a9s1abpp9cqojj76ces91p1kkrd8c4qb
X-HE-Tag: 1778293107-351035
X-HE-Meta: U2FsdGVkX1+Jh+GaQcdfyO1saMaKuhZEt7vefGjVURSfKsIZniHEm+aSoNq8JEIru80K7DqT2cOSgGrk4DGZEsk+8FYY4f00XYu2V8Y6t9k7etNnhLl4ZcN4jpBu2q4PKQCNbH4SKeQJVb+R75bYZ81oYtPJpF8YqzFZncpRy5jqst14BLkQWDKODsgj+glhv+YdiRY5DachX61aJ6R/YRlBZkHcwdtUGBgd11T0EIaMkSZfJkDuYMwkwqK8VUy6D++cY3O21jIUhmnTSB10PO5eGkNIuGBt7Ba3m+RjCIf3DDyOYspwjjF4SbWwezesrIS7zTwWQje3hAD6wpGt6KuDUMKj3Qq2Q7Ev11o7rENr2T3UDKfdZq4whMerqbSBweG2jyyl67+a6g6F3cZW4zm7f8RGyAc52R4w8S+BWQb3Uoplh9vz6n/fBRtU2UmJXqft6xfdFQW7F1MTzcgfozZcqA3MsCrm01UgRkLJcdqAmfvSJh+FS+WhZFz2N7pMG2tE5NKkoRPzHBHcnhESbtlJBIvjO/fhAqiSE+k2qFuZAlQfENHFUIw3w5dXHdPsiAj1vOxZwYfOstJbfJpY9eKKZa/FoemL25yZt38uC6e51U+VZ/W7OekM7n+pimYKXQfp2QMsWOhGUjW6xxQuBeaKVrIdNLvxC3E04Oxx5T1I0ewsA1785o0psyIQvEdUmyt1JbdQBtGR6otwXxaHGFCMb9yyhilfWEATuTxCo0EOm6ia9vplb4wdHMK0jSyePmj/ml4rHWOwi9Py/YXwwPRAAZS7MU7P1idx0Zp91dIavVPoUUF6x+c15mQ7/4AcsMc+YML4IAYZyfme/zeUh5lyi175X5fIWOjHWhtR/H0jS4H4q23JZlGoJHrokEL3adcD0b1OL8i224E23wnlWF4MAJ2lPR111x92oVcg0BWbb6X1TaTfZnoIkOkhHPMwAEBczQzXg3uWMkWnd9k
 HPaGbii4
 jAGWTxYnPmA3gM0Vd7FenBYvSyo4JmKkFUeFS1mUE4GojBjAQYhJoBujUlzO73EsxIPmiVTgTc6Ycz+3PCPSPddXXavcGZ5bS6V+tvkoXQgFlqzSfPJDJ8jLIInyFhgMqKZIzAN2bVv1bRXg+2qWVktxIkvgLr27MtZbea7Aw5tf/YqA5DR3B6RYx7ga1dqcryCRRbWjnG8khiflCX4q3Rontir46JR5P7TSlkcqpafknnJeupo/2TRLaqXzjqeHIAEiATf10Up0apOPfWj5bsXnzgT6FpO8NPF1hI7AI7ptdddqD8C036GE+HJDmzjtMx4w+IFpr46LSNIVnyuuNnH+py6rPMNScfXFHah25qJmdx9wU8o3R+ZyMzm3XJOAqrkic4HIT2WITQDWPeVJrsHhtaneyisTY1mseIDiJPxjfo49f4mtonQI1cSzDpYPDqi3k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/05/08 08:49), Richard Chang wrote:
> A crash was observed in zram_writeback_endio due to a NULL pointer
> dereference in wake_up. The root cause is a race condition between the
> bio completion handler (zram_writeback_endio) and the writeback task.
> 
> In zram_writeback_endio, wake_up() is called on &wb_ctl->done_wait after
> releasing wb_ctl->done_lock. This creates a race window where the
> writeback task can see num_inflight become 0, return, and free wb_ctl
> before zram_writeback_endio calls wake_up().
> 
> CPU 0 (zram_writeback_endio)     CPU 1 (writeback_store)
> ============================     ============================
>                                  zram_writeback_slots
>                                    zram_submit_wb_request
>                                    zram_submit_wb_request
>                                    wait_event(wb_ctl->done_wait)
> spin_lock(&wb_ctl->done_lock);
> list_add(&req->entry, &wb_ctl->done_reqs);
> spin_unlock(&wb_ctl->done_lock);
> wake_up(&wb_ctl->done_wait);
>                                    zram_complete_done_reqs
> spin_lock(&wb_ctl->done_lock);
> list_add(&req->entry, &wb_ctl->done_reqs);
> spin_unlock(&wb_ctl->done_lock);
>                                    while (num_inflight) > 0)
>                                      spin_lock(&wb_ctl->done_lock);
>                                      list_del(&req->entry);
>                                      spin_unlock(&wb_ctl->done_lock);
>                                      // num_inflight becomes 0
>                                      atomic_dec(num_inflight);
> 
>                                  // Leave zram_writeback_slots
>                                  // Free wb_ctl
>                                  release_wb_ctl(wb_ctl);
> // UAF crash!
> wake_up(&wb_ctl->done_wait);
> 
> This patch fixes this race by using RCU. By protecting wb_ctl with
> rcu_read_lock() in zram_writeback_endio and using kfree_rcu() to free
> it, we ensure that wb_ctl remains valid during the execution of
> zram_writeback_endio.
> 
> Fixes: f405066a1f0d ("zram: introduce writeback bio batching")
> Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Suggested-by: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Richard Chang <richardycc@google.com>

Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>

