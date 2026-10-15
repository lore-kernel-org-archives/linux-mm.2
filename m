Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87A36CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597556B0088; Thu, 15 Oct 2026 07:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5499B6B008A; Thu, 15 Oct 2026 07:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4369E6B008C; Thu, 15 Oct 2026 07:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE8F6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:22:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86423C0983
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:22:42 +0000 (UTC)
X-FDA: 85324622964.04.CF1C1A8
Received: from mail-oi2-f10.google.com (mail-oi2-f10.google.com [74.125.231.202])
	by imf27.hostedemail.com (Postfix) with ESMTP id C156440002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:22:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lkIf1s/8";
	spf=pass (imf27.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.202 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792063359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+KhDh+DCKXNAlBFw3mfZ5XMbYKVN/XAmTIjiDnW60pk=;
	b=2Hu3JlYbwJLIra0YNfLSU88XvxJ3lGyK8OUYlIEBFgX2qXKpOnqfH9FxWG35qvB87ilLcE
	jSVZ1NoYLfYbGtY6Mt8OWbCE3rZuoBf6XVReMs++007C0Th4sYXHTkh3h6ifn6pY7U9hnT
	FJbcdPJcsg3a8nq8K0pFPkG5doLjZj8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792063359;
	b=pDBVVGUwG6a2zCv4+WPk5JrPzgp4aWZ0v08tGJmOL/xv90bSp4dyLKc3mMnn03eA5uISHc
	O7TO7LQu3nPiHuGTot0SItRbOwZ4iaBx6JqeaHDsIbojZXZPg2W24b/Nm4Hh2ErLAVDjPP
	hc4awd300TANWTwhuYhRea0jhE1YIio=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="lkIf1s/8";
	spf=pass (imf27.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.202 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oi2-f10.google.com with SMTP id 5614622812f47-4c3bb46aaf0so1893138b6e.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:22:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792063358; cv=none;
        d=google.com; s=arc-20260327;
        b=J/szzQCG4gfOmY2GDIdFoeqZDMI5w3qsuyDDnoyAMxH2LLxg8AbUqWZWeygana+KnX
         j4eB9YH/9ZdjnT0ACAEnEHMFDWUuGH2eMUu90PhZ4RwC2mxdX6xJqLvC9DNV0VhJ9owb
         V7gDyhBMAAd/aq4YiIlcE6q953rx/M5APQPR54MNyRbhkwpDBlybNnlxydK2VYcnUU5s
         zvjAKZ1P/WvKehPn41xfvnduZY2EqToVwe59Htcl1xrBgtPOgUw+FitMR93rRTHe92pi
         nHpmH6/bR3PpfdmdgMiHY8Thrhun7qJSECKQIkmI5qhau8K3FBNPvVdNBC7QNXntzaYO
         nchA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=+KhDh+DCKXNAlBFw3mfZ5XMbYKVN/XAmTIjiDnW60pk=;
        fh=dmrtaCCi4xLQTpeHUH2A3aER8ICmLRn6rcoHjQVifbs=;
        b=avpoH8Pw3dj/rSTqCT3PI0WmYfa9LF0ICCoED8Pt5ohA0WdgZlVOiekC2CWe87INAw
         q7nST//De0OvcrcqtRNLp/yM/hh9iwmy1sjwoOJc7kYE7oWbFFmi1g0aAtVimWXKdPC2
         GVZbTcrHgdK8Jf1P51y9wfd12lnbrTl4duww6Vm9luZyGcU1c1YWmpqK1qC6iXrVEZmb
         SRt2UmZQyAxu8094DcgVSnGHbBXL7zfFnqk4j6F8N4KljFmVIPgn7Kecv6+4KfMhIvFe
         OomQ/hgXiYBMIpGi+GptSU3lav4ZmFAxYuvBYTdKJognt7S+dVc840ZhVo/I5q90yx5d
         3NMg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792063358; x=1792668158; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+KhDh+DCKXNAlBFw3mfZ5XMbYKVN/XAmTIjiDnW60pk=;
        b=lkIf1s/8/jGblbIH6DNofCwLYnQx3l3lzq4wR+KLmjEFaWdNvDNzlxjnrTagK1ZbaT
         NdDO7FFxryvijnKDT9WkeAGvD36pGXGJA7jUXn8bMU93/rJtLvrgHyGMG7bxhIPmjtEf
         hq5C19E6IoRoFnC/aUJ73zk0jHuG+1DukOVUsSBjyA+4AozPcaHtZgjfwDB502/Z5RY7
         GxMDMAffqlxvuiMAzlwMfZsNQJUBjdw4vVxlCjRoI6rbZxVlSndTXcw5ckH0obUnyoDb
         i3Egetz9a9rQCdMBiKEqXljj7T4t5xUQTy6OOqxEcWht68LOfu9xM5Z3tN1hBPWjD/Bs
         aIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792063358; x=1792668158;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+KhDh+DCKXNAlBFw3mfZ5XMbYKVN/XAmTIjiDnW60pk=;
        b=shsRS7WH8f1ok91qG/oOiACqq58jboR44roHOF//Uw9YBG0fqE6/iEs9IiFtGSsMyn
         nOSv9QlXlhphCjukMu6rk5LZY+/6dxaaogwzHG8vLNG5xMpDIeMQBMUaSuVYoK0Z2mjY
         KWKxbTnjaZAdxtIvQP+MFktBDsldBs+f/op98v7lAUncMlXyHTykJivWl5JYHw8dEUJw
         qGvuzHx0fG2CLrV49hjyaUG7aLejxz16ACoZcu6GudlRzq+oazoOru+809Oy6XRoIkIN
         Il7/foPJoDShWXP2ve9N6bn1W9/1DlDk/7AnGXdY9G6xp3s6EkhoMb1bv3+NN5v3AlS9
         g+UA==
X-Forwarded-Encrypted: i=1; AKwUvBxdPJimcw1rO/Zq1ffIS72DbGvJqpDEo0laTpmHK+rDn8V8JoP+aGUiHcIlX4FBG/XYSvk6iJQKDQ==@kvack.org
X-Gm-Message-State: AFq9FYIciR+3rwEe6x90R3DZ8CFEfeDtLqQ1yYF1gSdAPRzpRay30TFi
	bKulk3PDEP1B7VXqZ15Jr1hzuTSzj7SVydaOJhHrBUMeZwS3J+9GUFE2KqAK92wm4HFVekYeZsx
	CfD6rqRaOKYuWuHK9GKK+Ib39eTf6vLk=
X-Gm-Gg: AYBFou36yigyLoXp3hxCu+9qRIu6akdBUjpoRQeBJwkm5nGIqS48GMPwsLSo8WEgydV
	KlOAGDe4WtEA6b93CO8JhcREJHZA2/cB3x1VbUtty9qA4BLEHzriUJGKmb+39KLNXVNmSmUO6xJ
	a9qWyVmDU9CGYWc0iOsJOngkX8tJHV55G+grCEuOmEQVMGX+q/aTerUdf+/har0KeBo2qLw93JV
	yNGWZUk9XEELnnmUlHGnLbrC+O31p5vw7bWlxvJX5Mkgn6YTfYhVoCgecxRZz5gYzAJtHBUcyZB
	U2t7eJQ891iND8SojW/D9tK+2foYQ2G81+GbiZkjaZev5aYQh8abFjMFfCx/qSB9kUjRRhLFAiI
	tYxivon8dVA==
X-Received: by 2002:a05:6808:5028:b0:4bd:c8be:1e00 with SMTP id
 5614622812f47-50c532f8a99mr18667751b6e.13.1792063358543; Thu, 15 Oct 2026
 04:22:38 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 07:22:38 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Thu, 15 Oct 2026 06:06:11 -0500
MIME-Version: 1.0
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 15 Oct 2026 07:22:38 -0400
X-Gm-Features: AclHuK8pqRoiNT7w7U-dNf7fj0OwyC4V2V6EvhaoiQUtuVnZ8GqlxF2C2ivtqcY
Message-ID: <CANOyQmHo94dwHVMWeUfQsks0b30uZT0wuV8mDQ9MjB-HL0yVnA@mail.gmail.com>
Subject: [BUG] DAMON sysfs: failed update clears tried_regions snapshot
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C156440002
X-Rspam-User: 
X-Stat-Signature: 8ptnbokqg3a6bj9aodes5wz751axxzxu
X-HE-Tag: 1792063359-100457
X-HE-Meta: U2FsdGVkX1/0JgSz2Qg9Xl62tGyfiLkqRFd9+hdTwz3tSqCh4tzqMeexTdkvCcOB4DgTDP+I3MK8Nmg9SGIsWiJS8RFLBC2gCHHfG/N6f/6a5rHPf2RnYQJhlLDS6aLi3DVU41TJ107R2SWZDS/RKBNXQwETsxMGC6NDVcvJHJW+zWnD89dgzo7lbgVK49BdFydYe2q1Ohpp7hC4eoG7TScXs19NCMrDsfmXMQy3MqTvUa4lggI4RFqt/T1WaIYqBL5haEhGnznDbAr2m/bSU/7D7hAXB5Kc9p33aZBywy+pDgmbryJYD38bPN53sGDXPzvwCPrcQhMaxEh4FF/8C2jgR3ruQvW5xUWTLTGFJN2hpjxUksbKA49HzV940OqoyyFCBv3FlFnu692Q9gdryRCdWJWkdeGkpoYHofruP3f6Eed39z0vpJxFX3NXsMFL8RM7rHOsQp0TgzQcgoIlDLs/JudJafuGGtUtTjYL4YEy8b0wPqCCoWlEil9yv9HKn2/T+/um/b5SoUzlKc0V84b2oERaKb2H8H/fZAAHG/LgW4gZvHhsKFaoCHb4o1sj4udqS0IETs3Dt8IHoFbz1Y7ntMs0uWUocwSrKNh9npf8RTGBCfm/5YS3p73G+c1g9rIBeR8EJT7byDYNNKvaoVGyDqSiFm2GUtnsx99fAdaelHjRt0nMV3VPaBWHbqc1D5GiySNvzOQ1LxmfLOUNLx1vazw7rPPn4f7WJAbzSBhL/FdivJnhxHBpo9ZE/osR6N/w0weOhwv/OQeDRJXkfLC3l8/e6k5QVrARpZ0weJ1YlD3KaNNhX8/VzENklH4FT3QndFVBfr+WocDm//ZUdwxe84kYpJHtBSF9lcF6LNMB8ukED07StwhlfAUyQxfjacxdyMW6tN/rGucskK+p9tQstdLwkc5IlxaRth/TqgGVzPNv3Bfi4QZDiOJQwc3S4L62bAT6qh0O+9a3uy2
 /zVANrLx
 AhHQvHRNXpHnBHy4upn4ELdaWkKQS4/qpGnkzOxkzseuZlrryGvr3hD4moWuItLeP1ztKqn3NlyjUQerwpED15BZmZIShFvz3xVNo395HKmFQ4lXSrVIKj5E7A6gOzK4MZ9gdwOGzSip8c8P0KpA4cpJBWMjS08aIsokjOaMdFTJ7DFIU8jABj+emFYBKYNq4LS5uQw0BetHinNp94PlWaV1Imq2xT2w4URNdNnuE1VqapFy+COMO+DtpFI8gve/L9nJC9JLjmsLaPBHqiTWnCFqJjD85al1V1NvL5pRTdC6N3BWCfW/QrW7zuz2IIoZMWfCXcq4ABQnv7tTAvPIa0+XIRAq/gX1GLRMlxbteFIk3pO25boUKHMttZIFk1sUXjjv873y8TWQ30j4/fpuTdmvJcwGiSIKzWBfxh3cNd04Q1nVx3NjHo+TbZl8sspuP76uq3SjXon0hmnj0CTw6q4w4MF/YXJElLJ6+C1U9pY4nOdcoXEjofs90HAetQsImPUBIhAPFJYRoJPD+j4TrOfGhLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On mm-new commit ad9f2d463666, requesting
update_schemes_tried_regions after stopping a kdamond returns
-ECANCELED and clears the previous tried_regions snapshot.  The final
result collected before "off" is then lost.

I reproduced this in an x86_64 QEMU guest running
7.3.0-rc5-1485016-gad9f2d463666.  It used one PADDR context over
[0x400000, 0x800000) and one default stat scheme.  The paths below are
relative to /sys/kernel/mm/damon/admin/kdamonds/0/:

  ../nr_kdamonds = 1
  contexts/nr_contexts = 1
  contexts/0/operations = paddr
  contexts/0/targets/nr_targets = 1
  contexts/0/targets/0/regions/nr_regions = 1
  contexts/0/targets/0/regions/0/start = 4194304
  contexts/0/targets/0/regions/0/end = 8388608
  contexts/0/schemes/nr_schemes = 1
  contexts/0/schemes/0/access_pattern/{sz,nr_accesses,age}/max =
      4294967295 for each file

The reproducer then:

  1. Wrote "on" and "update_schemes_tried_regions" to state.
  2. Read contexts/0/schemes/0/tried_regions/total_bytes and counted
     the region directories there.
  3. Wrote "off" to state, then requested
     "update_schemes_tried_regions" again and read the same results.

The guest output was:

  BEFORE_OFF bytes=4194304 dirs=10
  STATE_OFF bytes=4194304 dirs=10
  FAILED_UPDATE ret=-1 errno=125 bytes_after=0 dirs_after=0

errno 125 is ECANCELED.  The snapshot survives "off", but the failed
update removes all 10 directories and resets total_bytes.  There is a
separate clear_schemes_tried_regions command for clearing a snapshot;
a failed update should leave the last successful one available.

damon_sysfs_turn_damon_off() retains damon_ctx for final results.  But
damon_sysfs_update_schemes_tried_regions() calls
damon_sysfs_schemes_clear_regions() before damos_walk().  Once the
context is stopped, damos_walk() returns -ECANCELED because its walk
control is obsolete, leaving the sysfs results cleared.

The guest completed with RESULT exit=0.  Reproducer, kernel config,
serial log, and build/run steps:

  https://github.com/jm5905938/kernel-mail/tree/195d7017352a3d0f4a0475b98f3b03650f5c14ea/cases/2026/damon/2026-10-15-bug-reports/01-sysfs-tried-regions-snapshot

Thanks,
Aveline Noir

