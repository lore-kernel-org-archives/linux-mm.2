Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6FA2C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 13:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7697A6B030F; Fri, 14 Aug 2026 09:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71A3C6B0311; Fri, 14 Aug 2026 09:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633376B0312; Fri, 14 Aug 2026 09:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1626B030F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:38:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BAEF40116
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:38:01 +0000 (UTC)
X-FDA: 85099978362.23.9D19AF0
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 67D1A1C000C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:37:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NiHEMu9c;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786714679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+jZipYomFNq1ZNPXEgD+V5nuC/+To5Fym+fI9aZhyXI=;
	b=7RGkk2E1NLBijdMTCGkB2OsWR9EUnILUBc5p5RhshP1r3XIkDvjRqQxSgCHNyHeFL7yRB9
	f0ee5CbbeFyKFlkRU/w6vyZx8GZ+v5rOPaLcC/I/d6hHbZGDKfYlV/8u14prw+B1hJ0dwo
	CnRlD10I8KViq1oRYZ+xWxznxIckUTg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NiHEMu9c;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786714679;
	b=iwnXndnqu5JFb6Y5IFQrgbeIAbYGiYnqlB/GrKj35Hn9h/l03tC5MNPerdGXZJDGVD13cX
	RhEBOMDy+nkIoUpS1s50H4H/hudLdwukzetb50M9bQ9eT3k2xC4+T9Yckcl0hQxUTRYksr
	xfwJxIgOJ+Li7S4EnCUBMb5MO/TYdm0=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2caea3f742bso18112425ad.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786714678; x=1787319478; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+jZipYomFNq1ZNPXEgD+V5nuC/+To5Fym+fI9aZhyXI=;
        b=NiHEMu9c2x8VKlJJI3Ho0SL+oHMdgYoxn1G90JvD3FueGxr8YPEsZ3gGxa2wviOb43
         3eq1wwzPtN7TxqfvWaBox4DSedKXDEwT5TjGNqodNiUjRLJeMp2bkKt37jMDR3Rhj85+
         MA83a1u0sg7CoABFbuKmA41JskquQ4Af6OwPwUT+IaMnphaMpCRbF4pwUo+1HgkWj7KI
         BxN+S3F2m4zs4SPY9yyJuio/DEuYbdY2SadUMPS9UlSNw/DNJTkJHni3ayUSGjipXkkN
         ZCna+Fxvmgf+7wMQZYa319LSueDtL7HhpR+DZ8XiVM2akGGmLB4+mdG3yMNteCWW8KEY
         AiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786714678; x=1787319478;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+jZipYomFNq1ZNPXEgD+V5nuC/+To5Fym+fI9aZhyXI=;
        b=Viic0TFX9V+yAtia/a5RzFWjYqS2QNVWErY8gUT6KJdxj/xQV15mpBQg3W1jgyoWBf
         mayCg92KXOZYzrqwcB6fa1aepCIGiQbcze502OFISorInf5mpi12i7cyX5514qWAUTuW
         pwEomZltqZPajs5S6xdjPFtkVTSYBjTMUAnOvlM+sr5o+fEyybfZ6zMq6tZ7GRL1/REc
         ex9g5SpDKbg7ZiLDq3cj4uI8QQPxUnRR10b8o1mmGVqpxMynbCAMZKOw1yVjjlv4VrFn
         uYyEjOrsrNpOJsKBBmgNK3+8CB2qpbwnlydHLqYgyU3Er6r+bSfvfUnZBCb5HGn2YGGS
         a5gQ==
X-Forwarded-Encrypted: i=1; AHgh+RrXqqUew8po7D6EY/vTRgZitPuOB2bJUuZrsrVWroKrIwEfmFQcms8ZYuk/bLgt0rRwdJ/S3bJ+9w==@kvack.org
X-Gm-Message-State: AOJu0Yx/JivoZswYVKoxl0iXn3uaFOK3CYleyfPiPTGlBUy9feSBQJik
	XFE5daYAJ1AeGI8Sdw4zMcnphHTr1e34V7Wi2bs88x4D0Bqz23x/UiFl
X-Gm-Gg: AR+sD10r2qr/Yl/U0NM3E16H5IvO0jtYX10GAuwrMTxJYTUF/I55lWdqmWrDhps0gN3
	YqlpsnBPvDpKd0ERsK4Ircf+RxJwsbGf1fgQPdnEhQY+zE6HCOsBOM4suyTo4euDypfGh2DNc5N
	vOiInnnXcNBH6CgIVVdtlTeI4iHyZtDBU68e8JKXcGJUzQTOMQBM1E1nOQx49XSaGspbtssC24U
	WBSEAVz1Vo4eNUAR6+ss8Dge7bQ6RBdtJ0Y1CiigAq1IriwFwhKy8k+67W5rBf/kFtAZcQVOOE6
	r5J175WviHLf2fh8yTWwsW0zcCMWcQ1p2/KWXa1npx5Fr1BryjaMBw8wc5uoKuxvwr31po3wPmq
	PULSgpnZUfbKye4nQw55vGRDIu8DMeDpAHfWAqoj0bRfe/HREki+7uJGar2aZzdsUHm5+8q+riA
	Rbyi6f5LN/JN3lo4DcgKtQYrlNY9dLyq1ScV0xp/ENLT+ynpHREk3tDls=
X-Received: by 2002:a17:903:37c8:b0:2d0:3412:a3f0 with SMTP id d9443c01a7336-2d3b0c88c2fmr67984505ad.19.1786714677973;
        Fri, 14 Aug 2026 06:37:57 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3ae79f0cesm10029415ad.18.2026.08.14.06.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 06:37:56 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/2] mm/mm_init: simplify zone_spanned_pages_in_node()
Date: Fri, 14 Aug 2026 22:37:37 +0900
Message-ID: <20260814133744.2746782-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 67D1A1C000C
X-Rspamd-Server: rspam07
X-Stat-Signature: wmk5w9skmgnky4gs4iofx1hdcyqx77da
X-HE-Tag: 1786714679-606207
X-HE-Meta: U2FsdGVkX19cPM1njksc7+TyTe9WhRXIZI8odW5QqAAUuISLd3U2xHxPnbcJYWawccyyCMnkcfsuWB38Y0QxyWE+48bq2wzsZ5SvaOKda0B+YZfeO2VpeZaYI5aflwY7cAIMolSyQdArrMiovzM9scZtXNWtl/OyzLRNepwybn/GbvLqBa+3kmejTf7EvGA6CfqTCkDctCHqDeT97tdkG7PZJeXRXZf8Yc0O/8+6t7zOsuYRQPGbzUtvzzwTySjo2/Vf6PTaIyPMFgAiFBu2KAPyd/M88sdi/lfG70bSxmYQHDviIPMw8i9tH435nrDkjj7SKralhVx/vuw6ll8BAPdGIXw6jqFXToj8BEzn66ACnBPfl8qCB8n3owi/0Va05ar9T5IxXzCO1/93gVHdKxWScL3vk5ub5gkufuAwylBbQmAVWGWlbwz9JlPJK+KRp1OZIdi6DEUpdecg6lnUklDOG0VB6jxrJEM02FlTMaUFjUNl5t5Q6TjeT1fcTx6xlp32ns+As4c+z64tu9HkSZY0OpGeV8RiOlQKSp0IjynjOe8sjXWNdsc8C6pIQFj9cjNZvESGwoA8wbfGulwbloJHyzxgPvjT60PbaaNlhie+WxUKl5GyqU1NsxB2pkvghuTElu4JLjwgkAH554g7USm9HpM7SfwYMkmEZnaU/TkjSBp7VoZpHnJHT+xtHYaFSZMhakRB9bf0yic8xqhJMjyqGzbH+3zdPIkufpjDPSXibkSSkR3/P0OJljECu6RksGuONk16t5gq8yHZCcX9QUkKWM2jAazmIzvZ0ot910en4v1W6A0gusuVNn6oBpPxnjlYC8svjYUWRI9wdBvh+7IjFSjyDbaLOiJ/NS0cYqV+bLdXh/qPTozCP0PER1ziaalVtXodwVv03RGf4RiXfNVw1qZaqdIFNTRwc8Ws39soWZ1ZWfyNn1xrFCIaDP7n6D7O3z4C5oPIpXJ7XNz
 zrh6WhHS
 BcOccNTnyVIddXsr2ghaGKIui3Rq4dI+VDtHtK2MNa7vtFoCCw95XZ62VbL/87iLIDo7MTA+zPk+Poqadyg6dBoCVOJBZ/luhvoE0AjdQYF2kR7LdsYmWdiUxC1QHqyGsrG4IAnKTN8aDMwaogfqoMoNP53RTcm7V9fxtX7/9YI4s+YDSCANNf32vUGe1kGbX/K3xu9Xc+2bAcpAAGXSCFmCN0Z7a0IQn2rUucfTHeIzs+tdSiukfhwZXaz5L4bf7QfAZeo+TpxkhYFoDfI859Fh/TRcmfB3paBWMKd6aicknZpOejZVBXCbOUZipxP38UfeTT3G1l6UeLB9brmvp7ufi2Q9PFtQOh22JMlBCyIfVCLWi07UL7VBf/Xkj7VIEyvc+0d0wzGWpOpL4OgWAuuGFJUhuSPjZKPoRY/UmHXnmsDVaLKVXYrE11Pz+cITZmfQMkZ8ids1O2iTcUhfYt48kmjyqwyzcwIGl4QHLBN1sTss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This series simplifies zone_spanned_pages_in_node(), which adjusts
*zone_start_pfn and *zone_end_pfn before and after calling
adjust_zone_range_for_zone_movable(). The helper adjusts the same two
values, which makes the code harder to follow.

Patch 1 folds adjust_zone_range_for_zone_movable() into the caller,
extracts zone_movable_pfn[nid] into a local variable, and reduces the
indentation level.

Patch 2 removes the clamping to node_end_pfn and moves the check and
the clamping to node_start_pfn into the ZONE_MOVABLE branch, which is
the only place they have an effect. It also merges the two branches
that adjust for zone_movable_pfn[nid].

No functional change.

---
Changes from v2 [2]
- Squash patches 2 to 4 into one and fold patch 5 into patch 1, as Mike suggested

Changes from v1 [1]
- Change base to memblock/for-next
- Add patch 4 to merge the two branches
- Update comment

[1] https://lore.kernel.org/all/20260804144803.3290255-1-ekffu200098@gmail.com/
[2] https://lore.kernel.org/all/20260806162100.313965-1-ekffu200098@gmail.com/
---

Sang-Heon Jeon (2):
  mm/mm_init: fold adjust_zone_range_for_zone_movable() into its only
    caller
  mm/mm_init: simplify ZONE_MOVABLE branch in
    zone_spanned_pages_in_node()

 mm/mm_init.c | 79 ++++++++++++++++++++++++----------------------------
 1 file changed, 36 insertions(+), 43 deletions(-)

-- 
2.43.0


