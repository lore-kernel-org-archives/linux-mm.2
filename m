Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99714F459F7
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 16:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B7E6B0089; Fri, 10 Apr 2026 12:46:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1CA16B008A; Fri, 10 Apr 2026 12:46:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31E56B0092; Fri, 10 Apr 2026 12:46:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 946826B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:46:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2278614041C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:46:12 +0000 (UTC)
X-FDA: 84643223784.14.BEEF6DC
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3DC65A0018
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:46:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bwYDOHl2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775839570; a=rsa-sha256;
	cv=none;
	b=BIH0P2cKa0uXa1GdDU1wuAkKGur13p4wDHWE7560WigMmebN4+OghLC70EwfubNHbaRggS
	ddHJVg6QX2KRra4wHVeWt0W8hswoXVHgm8hFevyBllrebI5eMUive9bhUY11oWvUM6vLYU
	IILdoGnVoC/du1aK+kllF+dRkKHPhSc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bwYDOHl2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775839570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVGQnjFC3UmJlO8LzJSr9La5JYFfjcbaaKaPS+uHiy8=;
	b=KdOQfj2q4QlAubUbebYP2OJ1B/tocTrYG5jSOxt1DjdigfvPD+QWa+LWFdRxrPJSJujSQf
	rlu0w69EeiP6PTPzcHDJjzq4wCBEChDOzcsmEqoZvalLwYoo4+yx7B9QHxWI6z9wxGrIKB
	p8wnbV8Mw+FKh+82mmOL75rbmWU70zw=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b2d3a9e149so4954385ad.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775839569; x=1776444369; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVGQnjFC3UmJlO8LzJSr9La5JYFfjcbaaKaPS+uHiy8=;
        b=bwYDOHl2tRzT7ShnzREU09dQHLx+R5LGZbPD4WEaruwhM7AXp8+IYCZlqpZyYtV6a/
         1Jl6xMz0MqXsqGUZEmK/adTDDWW6vU/XfhC7yXwBhJc67LFwSih9z5zzm8lvDCaUbTjH
         BgFs1vhtmrKn3c7L5nNL4UjLkk494ak8262TxcbRWBeVZHvFRkHYQoQxWwgzHv5b/WJR
         gQsBCEDXXidzlx6kGbuaHZdKiUe6KG9TfxfRC+lCUGBc+Cp18VS8FZlVnwh2pl8++ozr
         xQIZsLTieAjwtofGzDAPifQvo/GOadRqhF3sWg/i5DGzr3bv8HPej5UflMW7EkhkLHbn
         Szkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775839569; x=1776444369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wVGQnjFC3UmJlO8LzJSr9La5JYFfjcbaaKaPS+uHiy8=;
        b=CVG+9sCZhchv/W3cYBw44feNLT8CdOxN6UQUarfXaev7zQw7hpAmOmM4N7ep9SBy89
         7nvXtlDYjI/HOAEm6KlrKai+zouXlGTEXP9Q5XoUVgiNZv6SHzznVj3C8QX2cpx8Axl8
         BN93yrR8tWVHNRXcMJFKLSXY80iUfjbXRUa+DfcSM14e0NXrhkckoxdek88X/x+n0O0Y
         oeCKau4mzuYNqd3ZZRm+sU++mxJSkOh7+WoEd0zAMozZhvm4LGaE9DNmFPAxxJtFEpEg
         Z8b4oxzuxWp73cg78dp6wA5NKYMy0/7NbqFHxxj2ALwI9zbVTgomCsI6A0wkUmdOa7Fc
         mdUw==
X-Forwarded-Encrypted: i=1; AJvYcCWto98atiE7RGRCdrGd77H9cxCVuJyYky+geM9YDyXCRNCYVvFpYkTaup4+Kpk68TvF2Mf9OUeK5A==@kvack.org
X-Gm-Message-State: AOJu0YyQ7IxumCopKcX7uL5V5aNmHYUNdQkKBZfsPcjDCgDfGfL+WCRQ
	HxPYMHdP8UNeGMCXHHHTUdZzN4GtVgIr+xsE9qxfyalxR7ZgI9K7c+Wa
X-Gm-Gg: AeBDieuteP8PzBzbyicvg6tjyst0T9Zl80XCtZvFT3f3gYxEzs7nMqW5huxZzKseHac
	yOUUIF4po52+++QfP+EyLu9909rhR54OgJFaLR7X4bZug71zkocK+cD2LcY2nKUY23lRpG3i+WZ
	0AuIUNvzULC+4K/3ndHNef+9Dva1WmSyWQXKlFpHKlL0oaSwsiICfVG1YxInZ6MsDi5deY87w/U
	SGCdoG0Zp19mmMPiEFocIdwbsgG7VB0Y1Q4Paoj65D0Ndh6QBoldqVJMVyi407zpvui0HCo2Kwx
	tE3ZOzg48Yn41FL/gbAaQaRFORJ1ZEk56NP+A2cW3BivshONuRFEKnXGudEimqssnF1jgfKeZTa
	4MGGfEhuyk80R1Dc2/XNO67wCwShrEh6S7Sn7Dpn2zR4xLgqwRd7B+R0kQdmumwLqm2GmfEMNAY
	zZgyGd9jj7jjwPYKi3PAXuveg6niGV72JO4+0wT4OCOXdgSUaGrkEy
X-Received: by 2002:a17:902:f64c:b0:2b2:5168:2f82 with SMTP id d9443c01a7336-2b2c7384dddmr73308085ad.24.1775839568869;
        Fri, 10 Apr 2026 09:46:08 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:88f:af89:dcc1:f22d:646b:4592])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4e15f71sm36613165ad.34.2026.04.10.09.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 09:46:08 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Sat, 11 Apr 2026 00:46:10 +0800
Message-ID: <20260410164610.6764-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410135500.81989-1-sj@kernel.org>
References: <20260410135500.81989-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jrzt6pqos3yx3g4qzoxerq5yywy9wjbk
X-Rspamd-Queue-Id: 3DC65A0018
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775839570-253521
X-HE-Meta: U2FsdGVkX1+CFcgYNtTw9ciKXasQCyYTL65+7DylFV+n3TFfmzQD466Usp65RlVirza4KWt0rWA4JilR6hxYcrAUY2HcdlXgJZc8bZ33+P/dRHfIkEMsJQe/IccL7zIU+5fJS0CgY0pWjsff7bJSzDc82LOt4eyDBy74wXgetopeUPy6dKZ128nm5KmjjGQ4k0ZhfiIYf/R1TXH4hYo4ikN/b2MtDMENVxp0VUVSfgqbbSBA7vGm1nZAeAxEAeBEKLlqALN70LennFyipWZj2Q/NUE5TL4pa2JWR9iGggQPGVxFS2riNYNiaJSGOV8E6iK4ZvJGqrOezOpJeSb2+2T7gvXg9FluV7AdUN2scfSENPuF6QFLyvFIdLC/ow7/lc9Exesuzkpzh2xtS1z9eiRUfpcUSBz9wsEE9e0hZCOoeNskD7URfP8bwrU00kM8k7gjTwv7v9I96H+t+T/0+HqhIZDSXpkzJZ5305HoMJIR8V+rd1SEWzJgXFaby1iKu0Ek08+9VllYzVCCM0zjui2yDaARurE7T8scY14ftEWHTzOnXo101IXOiuE9xGKr01XOKPpycnztIBBIThyX5lL4RmDFJPpStmXsndNSjxNbpKSyNHHttKIrN3lcLz4akphKg2sEqKvQwzq0CcoAZR9leI1Uc06DCGq9w+M07j6q0TZi5mymLiv79TFA9/oSQQUxLsx3Rpq9b4kPffz0K0IiOYFHm7rbYq0sjxD83JY8v0lTbBMM37iGx03fPZR2spU3v6E09brxmRnYOEsJ/Eqr1K0MskSMkej0qaSna+9/LY+qvRtqwrQ67dN83HsXIUVN37Awy026JrTmB7m4h5qdTpR03l9KvIgabW5Lc7yOOio/B/EJU4BNCkwgMi7pPv5rPmBJ7bfOjqTSTOycEq3xluLM9JkmRVNWh9axJ+KPjfcEzjJr1QfzUlmQyqBdZl0AHt/PsqCoYXpz7s90
 qMKUcc/6
 bpuSncjlw4Ln4C1AcZYe3YoEQE6UQhJvqsSUX80/3mXt9wcCr0ly2p94wz6tjktdSSXCCWG7zmv8pwQKl1fi79LDrMOYi09XA+Aei9pSbYVbf2YOCJ63WK0LUUh6PJbgSZiig34sZyKlTq8khch3txEcAeZRwlGy6hv0LdrqKLV2CXBHXxeEltbhmuaQ6s+L10FqFWav19ifDnXQgnRKLmOjKE4DDUY4VOkB0kH9UOkYnQVDtNM2w+IQw7vX05qG9MP+vE/URSgCQWGl5839TQqgeOhkQfKFCjFo4mqQCY10J7eTVhX+Z/zLhjKO2RoLBbbFnA9dtyGiCHnpJjGMwebCMgMdAX/jUwJKOux66HSs9T7y5wrYTpK/fOU+9TYIyUKAMSj3CaiPQ359w2pGo8roZISJScSF7JP2r86+1sZTIzOYa3oWjUm8hmXczUo0PV5UgPGTFoagqBrDjG2QC+lO/xuwvNDAecasJX+wsBN9+lMs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 06:55:00 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Fri, 10 Apr 2026 17:40:04 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Sashiko found some issues.
> 
> Clarifying what is the following action for the sashiko finding would be
> helpful.  For example, if you say "Sashiko found some issues, so I will post a
> new versiuon soon", and if I'm busy, I can save my time by saying "Ok, then I
> will skip or delaying review of this version and wait for your next review".

Okay, I will keep that in mind next time I foward a Sashiko's Review.
Thank you for you suggestion.

> [...]
> 
> Agreed.  This was unclear to me in previous disucssions, though.  I still agree
> it is out of the scope of this patch.  But now I think we need to let users
> force-restart.  Adding this to my todo list.

Just to make sure - is this the same issue that my recent RFC patch [1]
aims to address? I want to make sure we're not duplicating efforts.

I'm still actively working on that patch, and I plan to send the next
version next week. I've been holding off because I didn't want to send
multiple patches in parallel.

[1] https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com

Best regards,
Rui Yan

