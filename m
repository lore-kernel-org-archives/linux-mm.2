Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9806DC54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE2A6B0098; Thu, 30 Jul 2026 05:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48056B0099; Thu, 30 Jul 2026 05:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F316B009B; Thu, 30 Jul 2026 05:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88AB86B0098
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:06:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F8FD14094B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:55 +0000 (UTC)
X-FDA: 85044863190.11.FB84EDC
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5DC14180002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SSgnUZlB;
	spf=pass (imf24.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6CocFUoEfqFYcrJ0dBCPJIkk+HjBh479KEdCNfDi1g=;
	b=bEYXuZZh+cC65p9k1zbz6V/H+86TrbXqbsCpCT7+1s45Ec2dBwW17zxp4kOy7OMcK5zULT
	wA58/sHcIrKsC1/qOBBAiDMrtZtfUbfVq2hbkhBXiYcSHtRN6wHbttw6j4NjXJuLy4XrDz
	kLTsfsnZhv1godeVeeZJyf3xWBNHjqw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402413;
	b=VpNtCd1sUAKwiCGH8r5pryZVscoMgGBe0m1EqPnTb6yVSfe7N7GUnEVHZS25oGeQ3a8Fuv
	nuRMVCyFQ8/cYyKd3RYdGCjWXFuy4fQZj6dKzX4wakZSzYyN5bNoG2HCTj2c4zZBdoRjuh
	KQndff5qBWHtcmLlQ3vL/7jPcya1Oh4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SSgnUZlB;
	spf=pass (imf24.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-39c8dbf4f38so15267341fa.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785402412; x=1786007212; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/6CocFUoEfqFYcrJ0dBCPJIkk+HjBh479KEdCNfDi1g=;
        b=SSgnUZlBjJjkoKCHK//SOnx83JkRarddHwKQDEDv3iUMNYi0mKP05IbrzStqamSglw
         Ee9rNUEVZQI9+D8g1e0Qwv4SoK08mPndxeXeVOnFJdSLVWSHCbbj9ZgXn4zTu4DJyzuS
         xBw2OGMzf80LmgEHQQi1fGzA0+F+B6BjiQzpC8fApKnJTSrVZy8l24Pp4cbIi3FDgiOu
         exLct2zlzMrXPrA85Np+Hd/0ITeY8N5KbTi4u5UvPe/kHY2h8qSURxxM+qI5eEsi+4IM
         qg4CyU81O8pEXaJiFbQS34uSnudRPDg3lpBSqhTMJmPJ6BECytb0BkBhC3A6aNXeeN/u
         SITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785402412; x=1786007212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/6CocFUoEfqFYcrJ0dBCPJIkk+HjBh479KEdCNfDi1g=;
        b=davaU9gcVqxyqjJQE+bm5a2oJBesQwzs+JqMVkg/Wk6wmJ4b2NZbZ/q+5rH5SCVIoF
         oUNrro580AMo5NacpuOQ3/x0Bb4S7ouGh+XzKFrTBBRHALFD8oKV4kSqg6BzJqjEy7rC
         /Y9xOOVGFGll2q/jJFLtkqMgEDuwRjSXhhK5ruY+5H7kt5U+fPwXml2ic1Jb4GLp98Vg
         Lbc80m+tcI0maZhon5rdk9arzIV5lwy0Te29NYKmRsap3zyILypbTMy1TaMSsU7Y7Zva
         KppSIO/d09Ubblc2SF1NYk7VhAtpFXXrP3nIfF3aXsoURid0QBWS4+fzln+f7aqb0buu
         C5Ag==
X-Gm-Message-State: AOJu0Yzbdi4v2jqAbqDJhzhyPlv0Qq4XQfQ8a/rfBSTcjjyeSXLH9NAN
	TzyrZRCTxEx+G2O2yjDGFzb6k/CbUBuw2Z36BpEMPKoiGgbchZ5sA34Z9a+hfA==
X-Gm-Gg: AR+sD10VzN9kbAVSlmISRD9ZSdwyRltcDWgMGd+krViJ5/qFTuq0zVRIb7N2oTN4EYq
	OsJk+jxnw9OgUhFB6FGQg/NJijDsIRXzpj4UrFDmbX8HrHxnC2oFiJHFsgEtcBAL5k1xpZoZzgr
	VG1aAoSVl4Ei/ho2JHV+wqG40nvtvXTFc84fBedStQAbFlzymmVtcs0CdrmmcNUIA3DvLXLG1To
	ZwxcKxwLWbdrnH9A3POH/+1Da0Gq+8RDfNe4sWarrcwylJLrHPiFBl1EsFG2Hn6QzOSeqN0Qmw2
	USgCx828BfziEDaU84CIQawua9mPTMgzswtVZmpBI1UfLJcorJgK+YU++63HfFoUib4y9eaC5Rv
	5FNRDcu9AX1ibc4a8m3bRIo7UBRqVVkB5/cT4XeHGKednrb7uoRI0s9EzLYeHBHV3RT1YQ9Mk1o
	yQMGwtPJV18XnjTWtbyyxzcbCOAOvFP2ULST+YR4gBpjkbJ6l4iUbitnbc6c6ofb5OP5YV8OdbX
	JDDl58lTWgO5cPun5qMHnWdLBZ22S6bfEZVYqurhyGNlo2N0kfYyEJ9jA==
X-Received: by 2002:a05:651c:35c6:b0:39f:27a4:8043 with SMTP id 38308e7fff4ca-39f6d0bf78emr3208951fa.37.1785402411664;
        Thu, 30 Jul 2026 02:06:51 -0700 (PDT)
Received: from localhost.localdomain (46-138-176-102.dynamic.spd-mgts.ru. [46.138.176.102])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39f6ac80d6bsm1928641fa.29.2026.07.30.02.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 02:06:51 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	urezki@gmail.com,
	willy@infradead.org,
	shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] mm/vmalloc: fix 32-bit truncation in the vrealloc() grow-in-place check
Date: Thu, 30 Jul 2026 12:06:27 +0300
Message-ID: <20260730090628.65814-3-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729175708.7074-1-iprintercanon@gmail.com>
References: <20260729175708.7074-1-iprintercanon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5DC14180002
X-Stat-Signature: 3q5cino6yf33gddm9jm7ex4x348ayz7r
X-Rspam-User: 
X-HE-Tag: 1785402413-977045
X-HE-Meta: U2FsdGVkX1+F79O+5OPcRwW6CTb5C9AiX5nTSKpd6BuZeLodjtf6c3k+DHz28B/hiqP3nGWLX5XrORhG1bWVaKZ9roFiIkPtjAoAZevhfL9WlfDFA0fIpU2ry3cl+r0IKq9EpoZde3tC06GmjBgtS+EbA3CDkAoqE9k02d9LmdJ2eqO/9JDsLdnhKyXTswi0taJjBi8VaAXzDunnl8+Hkez1676Z03Yc+FC3u8ZPoreauc/ALObuWdDSTGZR5FuL2zdSj4MxEoIVQ5HHULsakbseIprJ0hF7VEhG4fQbUCDVzFwRYW/gKZmc5CUIMtQMR4jnMc/5SnMdy2EtrOGdzjlLEtjSvhBydL9R6jOxWLR1GudHseSSYT5m6aFi/6yoGZrrwd5INonDy+8nKsNpiQcLh5dBnMPFjKofmFFvfxem8tZ8gd3y3OrmtH6qN6ekNvd8TLvVbdPLwmZOxpec3lZ68JSPhsxdyxB2VodyOabDIv0C9kl56V8kw71GBo3rKxOkGjuKauMYXZqcZFP+isr9YTXC8rpYZqXcu80EBfrSjWZJnPcVvG0w/bulrW+ChdizrLkD9DPxtIcmbB56mwbn/M5RC/eZsfj71tyfFK4E48KRgry9/SdRZLKyVCg/mkVqT4eXpmb1KmgBoXz/dIOj1sr8VBvQ+LWhxJyWH2ayn/J+hHutATIyh8GvLm6uToNIYZgwUXAO7I10k8Yuz3zcJLsUvGUn1bhDOUcmceqPev4OsGHbXPtNeyp1jLJC7+yR54uYlgaas+u7Yv0ysdBQygs8mzMa89OrGknvxOdQi6pUCMzu7rk1WAncMnlbhk6VoB5meq6dHTQ+o8XHXjvOXkeY43kUfc2DWB8Zby2mbTW1BGg0qqf98PHjWNkKZ0ZjWNicWfKHeCqh1o1hPVbwC1kJ6HKonby0hs9zWXNC+1x4nvtGiFTgHGxuXny12GxW4wbzwGbTvD6le+F
 wPqa5fBq
 0EStwRs9tuDtfqAJEF9GX9ArMgx32Brf3VmEPcyCjHALWxnYy30i3uSP9HlwPTcLwZ8phEx9bCkiNZRE90edR7v4BgQNRjydsN2LKKW78XE35JJcWLffO/7UsqpS2pZdF9m81DybMI+bzj8J/Y8utPGWKdTrE5PoL2483yfFu0QvTjGQsix6V0Nu1DSp4D3GZT9YSqN7Kbw6MoB2rL8EES1Vx72WXLfhSwvnK0zzmxuVak78f8I1/niWHTP3YYJIsqlv8S3sln5j6561/6HA2EgJu5OOLjOjbUK4J+PK6ws1LeD81xaXWRadKhp8AwzKZwonzpExowUVmMi2G0RcFwQUjvB70wW6bY+1lzwQm0deZBlvXmXeqcwHPUQacsR4A/nLyamSPm0+h2gp9myrzxp5J5AQeo3dTVltyZYe/x4a5l+x2y5Pu/Nmgk3RRj6R+j6aM11VW1fLE1jyofCBqa/4arzH8AqNDHcLuXGSecaKG0R3+NLiLct/D6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit d57ac904ffdc ("mm/vmalloc: use physical page count for vrealloc()
grow-in-place check") introduced

	if (size <= vm->nr_pages << PAGE_SHIFT) {

in place of a comparison against a size_t. As vm->nr_pages is an
unsigned int and a shift is evaluated in the type of its promoted left
operand, the right hand side is computed in 32-bit arithmetic and wraps
for areas of 4 GiB or more. Twelve lines above, in the same function,
four expressions cast for exactly this reason:

	kmemleak_free_part((void *)addr + ((unsigned long)new_nr_pages
					   << PAGE_SHIFT), ...);

The consequence here is benign. Truncation only ever makes the right
hand side smaller than the real capacity, so the test can only fail when
it should have succeeded: vrealloc() then falls through to need_realloc,
allocates a new area, copies min(size, old_size) bytes and frees the old
one. That is correct, only wasteful, and no in-tree caller currently
grows an allocation past 4 GiB, so this is a latent fix rather than a
user-visible one.

Widen the shift to match the surrounding code. Note that comparing page
counts instead, as in PAGE_ALIGN(size) >> PAGE_SHIFT <= vm->nr_pages,
would avoid the cast but introduce a real bug: PAGE_ALIGN() wraps to 0
for sizes within a page of ULONG_MAX and the test would then wrongly
succeed.

Fixes: d57ac904ffdc ("mm/vmalloc: use physical page count for vrealloc() grow-in-place check")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Artem Lytkin <iprintercanon@gmail.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 34e10b825889a..bf9e32cf93fc9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4588,7 +4588,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= vm->nr_pages << PAGE_SHIFT) {
+	if (size <= (unsigned long)vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during
-- 
2.43.0


