Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B05CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4975C6B00A2; Mon,  5 Oct 2026 04:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422946B00A3; Mon,  5 Oct 2026 04:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9D96B00A4; Mon,  5 Oct 2026 04:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 026436B00A2
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:47:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7AF121C1AB1
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:47:20 +0000 (UTC)
X-FDA: 85287943440.06.9E5FA37
Received: from mail-yx2-f5.google.com (mail-yx2-f5.google.com [74.125.224.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id A7034140003
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:47:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mzkrfXiK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.133 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791190038;
	b=f2JofmdnwkU42ngfe/6TlhuEv+7HefVWRSHZS0kI7/ho5DXLjQzFos+N2YbDatv6x8GVb4
	/jAkorSTs5JROyEqCNDrUVBWYqMx1GoOQZFKK1hMNwLwTgSe6HUrWoWKH7lrdjD0jhyjcm
	dCF5BH7QGVrOXCry0hIzbyO3hXY4d7M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mzkrfXiK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.133 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791190038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNNeYfS92dPvp0CaRE/I5c5+qwjZ49qCZegwTjKDnBY=;
	b=0SbdMe3m5WHBRKxUDnyXxhogGWF6cUz3R6qP+5rT6Kq0RjuoVEKoz7huUButH1LAQPjTOz
	Od7MA6V38MVS8jRl7rM7pTWG8AMBC4qM7P2xxXoQfE22myEexqZ+NvjyJG8BiXSDYYWXZW
	9AFSbT9YHPcKnSBk2w95/TClqDoqEh4=
Received: by mail-yx2-f5.google.com with SMTP id 956f58d0204a3-677bd24a602so634205d50.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 01:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791190038; x=1791794838; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yNNeYfS92dPvp0CaRE/I5c5+qwjZ49qCZegwTjKDnBY=;
        b=mzkrfXiKmtzq+ANJCw0paRhIdmyAEdJz4eoQ0Z+nXf2ByzdqGlWpFrvf4gIA7WsBs1
         jtez9dhn3c+qGxwQ07yFfzRTpgP8qskDJ2IMQZ3Rv672/PTp8+40r+kBLqBPS/qEEDoQ
         fYN07XoSp8YcA3YrUHwGmPuUVid2jvHS8NTnBC9lf+PLcePgtIrEkvgnC+lrCKp7vvdv
         YSoRlmus4sN/FU6dAcQGZqb2dAbaCp1P5XzZxXA1gF/sqbFsSkSew34ijOMRXO019OFx
         eGJf/nSIQh0FiDn9VWvXxjCdK7Sb+ouoZ67YofdnpX6uRgfcPocdoVjoBiOy13v+HifH
         mRmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791190038; x=1791794838;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yNNeYfS92dPvp0CaRE/I5c5+qwjZ49qCZegwTjKDnBY=;
        b=CAvDnf6UGdrRrq6QBq8pRLL/aBgKHNoMhQDaOfxCtz+53Uhgw4Odb6XwLlooKQQ3ir
         C5O3WZoxsaL3ZL/C7DgymGL/poRWMLloKRuAExRTR9ot5K0GNyXqAohf4vJnBilazwQ0
         WJaylLtNRRb2fivtszsQT39exFbqKibGf7LqwLCygBqrY9MU4GTrvmjFoOrGFW5LjCUp
         TCScVsVhxh3sH2lJFB4EaoFBWDiEEDFfEWTYy0s+3QsVOCbM9y4mhCcoDPump/Cg5wVZ
         fPseKN736inm12KnJhODZ7z2w1LO+HB2/Vr5pnK/YKj02qQ1fKjtsKJft5rjxlR0eKUl
         6Vsg==
X-Forwarded-Encrypted: i=1; AKwUvByHlzHt8KzMx8hJBKYJgXmHjzHd864B+mkdU9Mw4YZEwibslUK5En6uJ7olJvZRiqIuptiMytzJuQ==@kvack.org
X-Gm-Message-State: AFq9FYLXsc+fOJAfpQlUpcXNL1B4wY33+vMDqS7/uk+540vMrx20NxXL
	C0coW1yyI/x0DTRVwu8khABcdo0aGEVyArq6Id6KjUGh4Vd+pjTU48A=
X-Gm-Gg: AYBFou29cB7HrnSiO6DX8Ib3zQeKY+47yJmn4S9gFvozt54D2U0W7+/gvM2+gEdbgFs
	F0nIhXuZ1X1hmWgb6UzQfAUTfuBtgOvso50hD01sRRJ2T4l27A3CrgqqeAgkblDcUSKmjoVdzog
	K7+1ZL10CEfMctjF8YOUuCw1OApmZPSMUsxQlR/Xhccrz+3t53F7dIdseLWnc/oqYeC4wWsDj86
	AFpcLDgqOaEyMZ71HwsdCwH4qHkzb0ZCWiDh24xmPXcR/CgnfQqCFVWIbkMoeJ5RKHPc3dn/w1O
	bJ1NddbU/4oAm7SI/9snfb9ncAtiVGa7op019xNXrCFj/UzJY3dFLrDXIkfni2HCNcTiTaardLe
	WBL8wHxHyF/LnHR6UjU0dccqC271kYCM/5UiapQae8uQ23zGo7/DUYn00/iuKXMrNpwop4LR6ps
	EfoYzbxRxxZx1h9Y1zpQbBJhjy8aHdAQ35gj51HPjftS4/Zt+dC0t1Llris1otcD5ZnPCrtw6gH
	q6fuoHr488Rm8Oy53fdg2rGDyVDSXRkOp9rC0afamm4aBu7j2uoKEFWsqvM0Th7x36hvU5QWRbp
	5jSzzS3JvGMvczvCGqr8p2yQVcwY+azxNv4=
X-Received: by 2002:a53:c60d:0:b0:675:6161:4171 with SMTP id 956f58d0204a3-677ac159e1emr2637240d50.108.1791190037814;
        Mon, 05 Oct 2026 01:47:17 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:1149:2fcd:c86b:8747])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-677c1b9c895sm2346306d50.13.2026.10.05.01.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 01:47:16 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Mon, 05 Oct 2026 01:46:53 -0700
Subject: [RFC PATCH v4 9/9] mm/damon/core: apply probe_hits_wsum filters to
 node_eligible_mem_bp
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-9-b03452e137f3@gmail.com>
References: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
In-Reply-To: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, 
 Wei Xu <weixugc@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
 Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
 Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
 Kunwu Chan <kunwu.chan@linux.dev>, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Stat-Signature: rhgs3hu64rhqwgypjffz5iyypnkk5zmr
X-Rspam-User: 
X-Rspamd-Queue-Id: A7034140003
X-HE-Tag: 1791190038-494624
X-HE-Meta: U2FsdGVkX1+PFrjXwfPhna1wDnjbPEZLLLDg1QnmXVWGl30skKDN/uTTenlELvP80kDREChgb6UscauU4SU9x4C3UFwWHsSNILVwrNOGSW87Kk/mHz6nQLEIlbOJjHJrCM40gezoXyn7dnpA9TdpJP58hPBMi08VZR6DWV3NAs0vbDIz5wbq6KD4R5GSgs0hk5bHln+CRCbPXXkjTDD0bElzQQcP+sy1+X0eyPuS34owZfP2hUzSqr3fxUTmKbmJeZx3aQ2gXxPoU0Pzz/L2TNxjV6ZbOSVuEabhwMtdOdBcUZDu4jlZMWTmu2KuUotSy1k3lpt69IzK+dGAEE0dG99NXz6n9BOd7+hdr+viaNYD54tqRSoz/OObxKi8TpDXEmLFua6cKTSOLltT5PN57ciyzyMg/RwW8LatPO0J9PmXnahrPD7JOWjGN5Lns+/Jh0g9Mg2zqFz5xvJbtofOuO1aqN3iCZ9OX03HAvxMX0erh8LW5nad4uya0uBoS4p4RJCukGit2zAS51m4SNNXzKlyuefoKCw+wHM2nNczoAOy72kOp/pwJUROV31wCn3T2oUzyrEeCqLJBD2fiLosMlBkWP4PZ+r1F53h0ofXcFz23z/jecMjiGXaRYxzi/qbnilV6y6IImKUtkwdY0qov1IYjGBtq155bXpEUxb4zYlV4Kyr7T4Xp8YzEJJqpZPF4+TdMSTQnWxtEZE0sK0gTMOo20nRRBmkBgWvGlQTx5RFCEE9NxP7AReNHEVD/V1s/7KjxIaIfNtgVBnD8heqUyn564LR5JSoJD8GWl+GQwQWEpEeQV5Bwghiaa20tGxtywkL0IfdWVTebcgeLfGaz5GVZYFFgIxG0bIYhrflHcKvsf4pOmZamJwlBycS6fgTnlL8AuaKE89O7ZXODm3Sv8ULr1ON1WJT5ovTMv39ISeF2C6wa42c2GYmQNjc4fI9pG0g80PW9ASU9iLdR9P
 71xcFIbA
 XBtAbDPp59FpgtGcIUxka98fY5GM0VlOIBjCQEUBIqu/MTzTIi5ULlvwgI8LZlniPlTwhpVW2xfXntzjXiKuPT9AD5C2npkIcEUJ+5BPWPts6YVmEEb48GWguo0Sqb2rpkHElrBcQD5HRlXRoVQfruowq7lTxYjnYGxkAarKxrbirT/TSE7rkBH3eQ4OTnI8STwyXNFWfKkswGafLl/8cQgw0DN+EnordlEXW2WHW9vppuvZKmPYHbD1PyAZe1lD3vjzJIXI/sFDdcVmAttf5MBoifKdXuVfnuVuCa+2XzSmtuQ/U2OSKVhFOTYtiY6RXSsOORZ0MqmXlBPUS1aNUHY1jTTTsXRK25YkgTqF0H+nsiytqE82FAmGZfHy3PbpcdQBkpgv3b9atao6cWH4OLcMQkHZ2GNfNJrYO3lA/No14rHaHgfn1JPmbxC9YV7w3xUW5AB7I5kcY2ksKkmtrjPOpi/MdSM++okux6z5JzwKOjnX5UsIuGdQ6Pp3zl1IfyuYqcMVhzLzjTSWKjOYroWfQNn5/3xT/JLcyfjjT/dNWyrs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

node_eligible_mem_bp is the share of a scheme's eligible memory that is
on a given node, and memory is eligible when its region matches the
scheme's access pattern.  In data attributes-only monitoring nr_accesses
is not updated, so the access pattern cannot tell which regions the
scheme is for; its probe_hits_wsum filters do.

Count a region as eligible only if it also passes the scheme's
probe_hits_wsum filters, decided as the scheme's core filters are: the
first matching one decides, and if none matches, the region passes
unless the last of them is an allow filter and the scheme has no ops
filters.  The address and target filters stay out of the metric, as
before, since they scope where the scheme acts rather than which memory
it is for.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7c0df07f0a90..bae4569f0ab3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3609,6 +3609,31 @@ static unsigned long damos_get_node_memcg_used_bp(
 }
 
 #ifdef CONFIG_DAMON_PADDR
+/*
+ * Whether @r passes the probe_hits_wsum filters of @s, decided as the core
+ * filters of a scheme are, with the other filter types left out: the first
+ * matching filter decides, and if none matches, @r passes unless the last of
+ * them is an allow filter and @s has no ops filters.  These filters select
+ * regions by their data attributes, so they are part of what makes memory
+ * eligible for the scheme, unlike its address and target filters.
+ */
+static bool damos_probe_filters_pass(struct damon_ctx *c,
+		struct damon_target *t, struct damon_region *r, struct damos *s)
+{
+	struct damos_filter *filter;
+	bool pass = true;
+
+	damos_for_each_core_filter(filter, s) {
+		if (filter->type != DAMOS_FILTER_TYPE_PROBE_HITS_WSUM)
+			continue;
+		if (damos_filter_match(c, t, r, filter, c->min_region_sz))
+			return filter->allow;
+		pass = !filter->allow;
+	}
+	/* as damos_set_filters_default_reject(): ops filters decide the rest */
+	return pass || !list_empty(&s->ops_filters);
+}
+
 /*
  * damos_calc_eligible_bytes() - Calculate raw eligible bytes per node.
  * @c:		The DAMON context.
@@ -3616,9 +3641,10 @@ static unsigned long damos_get_node_memcg_used_bp(
  * @nid:	The target NUMA node id.
  * @total:	Output for total eligible bytes across all nodes.
  *
- * Iterates through each folio in eligible regions to accurately determine
- * which node the memory resides on. Returns eligible bytes on the specified
- * node and sets *total to the sum across all nodes.
+ * A region is eligible if it matches the access pattern of @s and passes its
+ * probe_hits_wsum filters.  Iterates through each folio in eligible regions to
+ * accurately determine which node the memory resides on. Returns eligible bytes
+ * on the specified node and sets *total to the sum across all nodes.
  *
  * Note: This function requires damon_get_folio() from ops-common.c, which is
  * only available when CONFIG_DAMON_PADDR is enabled. It also requires the
@@ -3638,6 +3664,8 @@ static phys_addr_t damos_calc_eligible_bytes(struct damon_ctx *c,
 
 			if (!__damos_valid_target(r, s, c))
 				continue;
+			if (!damos_probe_filters_pass(c, t, r, s))
+				continue;
 
 			/* Convert from core address units to physical bytes */
 			addr = (phys_addr_t)r->ar.start * c->addr_unit;

-- 
Git-157)


