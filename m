Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9944C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 02:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DB3D6B00AB; Mon, 29 Jun 2026 22:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98B6C6B00CB; Mon, 29 Jun 2026 22:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853BC6B00CC; Mon, 29 Jun 2026 22:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4F16B00AB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:50:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C210A402F8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:50:28 +0000 (UTC)
X-FDA: 84935050536.10.0B8289E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2455BC0004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:50:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NCFL8Snk;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782787827;
	b=4AQG3fiI1GCmIE5t/WO0l0H/5435ZtZ4W1os/VP72Atw7TQz6MLnhCRzS6+MNL97csCWkd
	UqcY3fAAXIZ7aKK1h2bp5L5/lwPPCtocGf6kdvBOfUnsfWNAXuN+sdCCc3JRLyu5aySTV5
	2fwLfgARO+tPREle2kqgIly1Rekpcu4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782787827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRQY4R85CQV6CHcgnQiXFWcOY+A+FDGHfy/QBTilh3U=;
	b=338f8wbZoh3ismFtf3gcSH1WheksXJp5/izKIQXvQv1jdV9Vh8W8zLgCwBu2XUVQBcpEhC
	SXtLlTstlzhWJMFofRqm2JEzlsybvMiqI2I9945d7mhZqBCKugU2nWN/KEeVtUR3Frg2gt
	2YzLejnYgcOrth75m6dLxTKClQEjEGQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NCFL8Snk;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FC57600BB;
	Tue, 30 Jun 2026 02:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03FE1F000E9;
	Tue, 30 Jun 2026 02:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782787826;
	bh=yRQY4R85CQV6CHcgnQiXFWcOY+A+FDGHfy/QBTilh3U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NCFL8SnkgYr3rOPqNRDdqRsDtJs0HVXR4V2GiDaujiPLLtRT+vNs3SWWM8uReE8En
	 ZR5ZVLEm+hpN6LDO1aYRB08a2NikV5WsdHzU4E0xEcYtQ1l3zs8pnEHcearvMjcFU+
	 AkSftbk8nSaAguEWAoTZGolT1bZDn1jb3QANc1OU=
Date: Mon, 29 Jun 2026 19:50:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Minchan Kim
 <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Nhat
 Pham <nphamcs@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Barry Song
 <baohua@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Subject: Re: [PATCH v6 2/4] mm/zsmalloc: drop pool->lock from zs_free on
 64-bit systems
Message-Id: <20260629195025.0bbad03ddb714f72615cab53@linux-foundation.org>
In-Reply-To: <20260626015003.2965881-3-haowenchao22@gmail.com>
References: <20260626015003.2965881-1-haowenchao22@gmail.com>
	<20260626015003.2965881-3-haowenchao22@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xgqc3rjbgedymc6xfxyuka837di4geix
X-Rspamd-Queue-Id: 2455BC0004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782787827-659590
X-HE-Meta: U2FsdGVkX1/mdUIvb6aLtQ5IL2fPP4KQLpUc7e1nSs8cHcv1hMSC1/6+KfNjQo+Yfqb6oQwJUOYgZcZC6Bw7Q+g7O4Yh3OzzaG5wIKYrw8RLD6bdOiLXvztY3I3zOAh9ryGBowwZ/Z21S2KnCyykrfExUo8gwlGRqC3lf/CC21upBYBuxcEWgaTMaX08ALYZZw89+qf5L2CUcIewVwt05gCe/sK0cdmMRz8YLbXj8aLW9LUc7Sbg+3MJE1vs+1GWmqJTFuldSFGK+otbEHimrAfenK1xN+oKUTUBe7WVej9J4UmFstfo+EpRojFuy5uD2y3i2FHxV1Z9hnxzJLdQ37SqajceyM28dIxHB6ax7/w91TvqXdGz7G5hpX8CFCS4cpBpn5O9EL83TiNjrpp+8ZFpwImMOMt7KDFPcumM0gSXAkbcnblxWbhkJSDdzWF3oqCPdugOAUtf3chcDRNQnSDecZ3SZdJAaqiv+zKHtBEpPu1kSgD31QglLNLHSXpxhQVhhlwZpt7hMb4Gt/QXhmGKAU1/Z3yjH23g8Ur8Vlg10LunwBugf0bNWxKHfVpNJak+3myjQDNYoRgc513nL2/42Oc7Pta5HgTa7J/jVYt6vwgkDIvWCdlCfgadY9S8Ey4ab/GP4eDs16tk3wrey0CTOLV01hs7lLukwIqsFK8Ds6EEC/Y3qDBeX1sEoRxgS5CtZoBIyPn09NqBXqp2pr2csAGHurSnOH77+58DpCBNIOqnD7zDYJYWvG9gAX4qqsLh960j8WvbhkZPObqU1f5eMcROJtoZHHkLtlM9RGa1DABWTjT5K1iHSwQQ9vMdF5FYTrZsJAUtuq+WY6Li84SbYxmtdS+7IvL57oVWvjQEBG9cD/efTRPzeR8J2upVtxI9Q2sernxbnZiNJh3VDfgutiJp+BpGcPRuTg1xSZr7COI+BOOAwYgL1Hmty8HI0D+OdMA3xd7QJ9H5k74
 Rw90UZvX
 xC69riGdfBQXDbfEhRwy8qi498sOwPCULTZvpYTjIL5IrXEdwkkxzvVIE1ERO2TMVCNob3nt9WKgDOeIJ6uedVVwbyo3xDK70jGkE73o7spl2VONXYgp3cmvkkXEQV/dfJUe5i1hkI5gH0QLzgcAo1CLR5rxyo4qJa8fsPlPpr7WLssDUwQWixF+wnKwGfyC24WOBbYt2F9kx/YWRvl0BGYRehHEeFX370P4hu0Oye17Pi558ZriSzJ8SyKwkfRF9VzVa+G6AbaCF0KLNSbpVnji7dj/xZER2LG82Unm8XN4FBfoZapc5ZMX1ngu4e9D6UAMvZgZj5CU1Sjsf3P9l+14qw0Cs0Pwzgapop2Uh4d++hh35np0eT0hPPr/KIcjeIeqYHV99kJ4hkJA0ORmGoZMClBe2VXy+ln8jRirI2uEYB6V4EhATTwaZYIcTrcOC1Fp9e6N2xLJuO27ftN0TeyKRXriIX0rMu2Vi/+zJlzs/BhIpAanHWVtdYYCNwYF5Y1mluHfpwLycpsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 09:50:01 +0800 Wenchao Hao <haowenchao22@gmail.com> wrote:

> With class_idx encoded in obj, zs_free() can locate the size_class
> without holding pool->lock on 64-bit systems.  Page migration also
> takes class->lock and only rewrites the PFN field of obj, so:
> 
>   1. read obj locklessly,
>   2. lock the size_class derived from obj's class_idx,
>   3. re-read obj under class->lock to get a stable PFN.
> 
> This eliminates the rwlock read-side cacheline bouncing between
> zs_free() and migration/compaction on multi-core systems.
> 
> Annotate handle_to_obj()/record_obj() with READ_ONCE()/WRITE_ONCE() to
> prevent load/store tearing on the lockless read path and silence KCSAN
> data race reports.
> 
> When ZS_OBJ_CLASS_BITS == 0 (32-bit, or 64-bit with obj too narrow to
> hold class_idx), zs_free() keeps pool->lock.

This thing is still causing problems.  How about this?

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix
Date: Mon Jun 29 07:48:04 PM PDT 2026

build fix

mm/zsmalloc.c: In function 'obj_class_get_and_lock':
mm/zsmalloc.c:1481:36: error: implicit declaration of function 'obj_to_class_idx' [-Wimplicit-function-declaration]
 1481 |         *classp = pool->size_class[obj_to_class_idx(obj)];
      |                                    ^~~~~~~~~~~~~~~~

Cc: Barry Song <baohua@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wenchao Hao <haowenchao@xiaomi.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix
+++ a/mm/zsmalloc.c
@@ -1457,6 +1457,12 @@ static void obj_free(int class_size, uns
 	mod_zspage_inuse(zspage, -1);
 }
 
+/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
+static unsigned int obj_to_class_idx(unsigned long obj)
+{
+	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
+}
+
 /*
  * Resolve @handle to its zspage / size_class and acquire class->lock.
  *
@@ -1759,12 +1765,6 @@ static void lock_zspage(struct zspage *z
 	zspage_read_unlock(zspage);
 }
 
-/* Folds to 0 when ZS_OBJ_CLASS_BITS == 0; no ifdef needed at callers. */
-static unsigned int obj_to_class_idx(unsigned long obj)
-{
-	return (obj >> ZS_OBJ_IDX_BITS) & ZS_OBJ_CLASS_MASK;
-}
-
 static void replace_sub_page(struct size_class *class, struct zspage *zspage,
 				struct zpdesc *newzpdesc, struct zpdesc *oldzpdesc)
 {
_


