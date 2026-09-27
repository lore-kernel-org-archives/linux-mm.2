Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B46AC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 20:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA3F6B0088; Sun, 27 Sep 2026 16:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AE96B008A; Sun, 27 Sep 2026 16:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89F26B008C; Sun, 27 Sep 2026 16:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB1776B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:26:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2EC0DC0A6B
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 20:26:34 +0000 (UTC)
X-FDA: 85260675108.28.0D9BB68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7402520002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 20:26:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fKhzG8Id;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790540792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wtc36Zd26DF0UV6qt4ILyxcIdl7ocFhXmsZv9Dy+w+Y=;
	b=SDfDxXwUioFiVyXiQOkwo4cvmJavwhoK6RQ++LfqtayJMCB/jMstJ12ZHu6PjEfsds9wDe
	wNENVgCst48u+wAzII0n7fjIYSk5GEIKAjYYi5DNNnV+j89ZhJyMeM24uYJeI5BVijKmNA
	QFSSiL+qalSVZ0MnjPjUgzTIhodezy4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fKhzG8Id;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790540792;
	b=sZVZ+dP1QM8z7FIKA/4LSHCp/w5DmgM9v7OVFkhq5Y+cMY7IYeQrYoTiBhcaDoiADuRA+1
	alRUZHCeBW265z1Yn1NDNVqNo/z2wFFZ4bmS+JNiX/5nTYVwdAEbKI9nCuvYdXwMh7VbV/
	kUm7CfO1XW9cHidDuYMM4CCCVYbF56c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4BEA60052;
	Sun, 27 Sep 2026 20:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D446D1F000FF;
	Sun, 27 Sep 2026 20:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790540791;
	bh=Wtc36Zd26DF0UV6qt4ILyxcIdl7ocFhXmsZv9Dy+w+Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fKhzG8IdBSyYx4WwzMQqnpwOPZCr3ooh55LHrwrwCvxbLPkvxBO5t+3+ccAfMHSzE
	 gjHo4hWgMwEazfMjspTgDHCK6Rt8WL8Jiop6CSr+TZqw73IJUiiQm93mcCE9E0f5Ei
	 a0w+rkZtrFS+ecXZrAa+HYyVW7xszMLOpwQAwMzE=
Date: Sun, 27 Sep 2026 13:26:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
 jack@suse.cz, tj@kernel.org
Subject: Re: [PATCH v8 0/3] memcg,writeback: flush foreign bdev mappings
 separately
Message-Id: <20260927132630.eef2d0f1704534c7bde8e538@linux-foundation.org>
In-Reply-To: <b5da5c30-7c8b-4c60-aa3b-d2e3603e82c1@bytedance.com>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
	<b5da5c30-7c8b-4c60-aa3b-d2e3603e82c1@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hfwcikzayhbqgpftg7jbeqiyaciodox5
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7402520002
X-HE-Tag: 1790540792-239539
X-HE-Meta: U2FsdGVkX181JiLRtMG1MngCA4iUiy3EVXpQQd+RNj7xb+J1zzJ525AEdvtNJW3/SJkR5+jh8hrOOAkLLWiDkHgIM+sC42CQajG68TxXl8V+GQw5P3ZegC5Xm8wfEZ8XSPbKzVYoTTaWZoddRPS8aeeFS1QlrhaM+FqiVf/jUzvcC/UbWZbBmZ0r620ePlbn+HnbSWt3EsqRgL9viewMPMJWy/p8o+rOnAQ6iWcNTa8wJSH3NtXAh8Ba/DjA/K5hmNCq99a2RVMRfpSHa4C690Xn+IgaZ+UTY5vnchYfqgmibGHZabLwoyyrbbAvj4DBQC1Yr8RZTJg8Vo0UJGYD5ErP8tFf0MLhtA7BQAXJGcpk1aVhdPTAkcSYqN10/OvjqnfaZcZV7ZdqvLe2aR2MdDlJ3ChGyng6GtHseRUfsN6/JBmp+mO7wHcEZyTO9/ZuN2kBb1ZKdSnQ/F5Kzz8uqysGLxXzCXsi5W3AWomllWH0MYNzcNZfGBYBMMuUJD+3jSivpTyWhzoUidYr+sb1ayVA/I2omI8XNH12UwjPzEPjH86EBXZ934Dh0nAQYrN4AGvvkkCQOmY0ut9FRkVCgNx/OzMPkCidftQO8Lqb5BYkiE1HdD3lv4Xhu7WWx/T7a5Iag1yIOWa5AQXqGWHnqyAouQCgMWKSi/FpYZytpfoQgyByZIysnIsr+1hOgRh+PICgCFqHIp12vmJ+Zf/T9KMPbBaPr5tQezRoUbEUBZAXM6j18BZfSLzdNI4/rFaHvMI/50MqKrj8nIbGDLhM8F6TGUpt8BG0pYnoQ6J9XjP13y3HM3R7uRuHPvYVeznuo80MIDHsTNMiGOREQ0rMWHXEkAWb+/tiLh8xhbPkwBUKiHqgfgA3mUSG2flx+p3LaMkL5q1hm8PFP61EHQX74ca7O30Gy1umbwfZ1LTgBgfCyDqbVDGTDWL1LfxHxkJs9TQS4c5GWFnBGPhFPcz
 hPEAekk2
 53/pdkzPaCUeVpwUJnjiQovuW/pR2F4FIK92d/iy6/jbbJc/DumBqpuSsMQeibUCHlkwHo45YyOav73t2jWAtAM5J9azWmTs4dPObUOSMgtU6+fH2fMbxPxFverpQWWaKYfrVGtGnei+H2kvG7ztRpvG5udTisDx4Iqmp/eMxukWjqo8zS3eMdn9ORdgptQzsI+rQ2gdFiBdORg95J+8nqdD23bkFGB+IN0SwKThTy4gRx+DWppSwmfpHiXIyTnCgNY3MiCs4UElZp+MrM9upRcB2UQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sep 2026 19:48:26 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:

> Do you have any further thoughts on this series?

I'd like to see some feedback from memcg maintainers, please.

> Should I rename bdev_flush_by_dev() to bdev_writeback_by_dev()
> and send the next revision?

Yes please.  "flush" is a pet peeve of mine.  It's used to mean either
"writeback" or "invalidate" in various places.  Or both.  Annoying!

Also, I agree with the "dont check alloc succeeded in __init code". 
Both places.  Maybe save this little cleanup for the next development
cycle.


