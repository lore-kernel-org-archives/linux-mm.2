Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B527E7E0DA
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFDF56B008A; Mon,  9 Feb 2026 14:36:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CABB86B009E; Mon,  9 Feb 2026 14:36:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1B06B00A2; Mon,  9 Feb 2026 14:36:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8FA26B008A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:36:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B25FC15DB
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:36:30 +0000 (UTC)
X-FDA: 84425924940.13.D8B5601
Received: from mail-yx1-f97.google.com (mail-yx1-f97.google.com [74.125.224.97])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7AC6D1A0013
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:36:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of postmaster@windowsforum.com designates 74.125.224.97 as permitted sender) smtp.mailfrom=postmaster@windowsforum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770665788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=0sq/5z8N2ft1xcm3cuopTwCMdowyLeWdG7JWXwBlvJo=;
	b=2bSvu3jtrr6nYGCcephX1KkGpqqED3Gc/+frttFB+Dk/EIiJR6VAlqj32egoP/7oBEWDQU
	dqtq9T5td1WCpZ8I+2nwlwNahWOq9Y26cr0twHjMO4q4wIlYgfdQvpHrTVZbUtXnpGUy42
	/pHMeSXxvbwhNI6b3PrOrADNfTtAQw4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of postmaster@windowsforum.com designates 74.125.224.97 as permitted sender) smtp.mailfrom=postmaster@windowsforum.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770665788; a=rsa-sha256;
	cv=none;
	b=xSABju77+9CTZJbJxgob5GpoCclK2faY2/Sb76Xxpz+DvmFDmkiJIpvdh6dSOGH53tue3a
	njV1FBv8qxJX1mKqYYPPME7B6q1JNEAXf6lsW+mqO9FX8vJaosv3OrRdSv8q/ppuSRN/oi
	2o9B7pxf3WVm/k+wiFCeQTaDhSxWPP0=
Received: by mail-yx1-f97.google.com with SMTP id 956f58d0204a3-649c070ef3bso4542167d50.3
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 11:36:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770665787; x=1771270587;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sq/5z8N2ft1xcm3cuopTwCMdowyLeWdG7JWXwBlvJo=;
        b=K+iTv2Z++4lx19nNcmRE8le4N9DgOhJl/uLsubjNSceggscGcR8kVi8NOO8MEUhsRF
         Qm/PW2lMATILjbjKonse01dqe0bqGW/MiCMli2G2EdHH0/wSgSazlNlvGBYrSzLNbc42
         gIzju1kmzdH54BRqD4/YVkvPcumZI4PUY3l5NH038YjoKkrNUmmR0JBqwAGZGZmWH4im
         BYphE9SDal9x8DqHBi9nehWQlRh0E4TLMhOu2sYxs4IPccdDCi9TpysLbSNNbLI9h70X
         7EcJj5ln5NKUvPd1LMBCPhb0WJGCuJCG95vwGey1P7PRcS3sU+e9UTJRCpCyKIwK+k9M
         OgGw==
X-Gm-Message-State: AOJu0Yy4/7Gyz0GyF6U/pY6XNvQjOUAaAmeKHS7DoxzX5zZ4bNNweTAk
	lVJl9G+pRjRajAc2gooWU8f6kTSwC5VMhUcXLi9z9gtk0kBitKi12X4T6iOe+Mt6Hyl7DV1ffP0
	wvrz3cjNeXVycE3pJE8w9rg6IcCiqwbZBPga8
X-Gm-Gg: AZuq6aI69BkXmR26IZ4F9PKvjP6QUN7gn0Iu5EgUVPtfBsX+5tin9uecIkj6OdlmXSV
	rn3R43vWsQTKvBAg05A81rCnHITNOvoqtI51gnC3JBNhYMrbq9sEGWodG4Ja5bz3X/d3isDRiu5
	4Ogkpp/3WUgxUGmX2jJWZz9wFDL2XMqnGmcL9yVWNU5CZ4/QiYeorWgA7er4L2/riLrPRZiBcUZ
	0zo5iYwsDZrv6fTq9TFLZLfe4nklo2fjF0KecWHLCh8hnxgeL+axB05qk70jANdZsZr+od0aVUP
	0y+ug5xx3U5dOLM+xXAylvk9449QdbGu+pm3YP34q4id6Rdeu54i487EYjH/dFOzFkm7ywoEqwd
	C+jUsoohmrQdx9E0Ii8hKqqZi7gwubtdOfw9EgEMHvt4=
X-Received: by 2002:a05:690e:23c8:b0:646:5127:ad55 with SMTP id 956f58d0204a3-649f21c2cd9mr7136866d50.95.1770665787205;
        Mon, 09 Feb 2026 11:36:27 -0800 (PST)
Received: from windowsforum.com (116.9.196.104.bc.googleusercontent.com. [104.196.9.116])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-649f249e35dsm1086650d50.7.2026.02.09.11.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 11:36:27 -0800 (PST)
X-Relaying-Domain: windowsforum.com
Received: by windowsforum.com (Postfix, from userid 0)
	id 177DA2A1C1C; Mon, 09 Feb 2026 19:36:01 +0000 (UTC)
From: Michael Fara <windowsforum.com@com.kvack.org>
To: senozhatsky@chromium.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	mjfara@gmail.com
Subject: [PATCH] mm/zsmalloc: fix NULL pointer dereference in get_next_zpdesc
Date: Mon,  9 Feb 2026 19:36:01 +0000
Message-ID: <20260209193601.64662-1-mjfara@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: dc3mx6wbeymwssa5gfys5bm5ukp3fcm7
X-Rspamd-Queue-Id: 7AC6D1A0013
X-Rspam-User: 
X-HE-Tag: 1770665788-98234
X-HE-Meta: U2FsdGVkX19XqdqY5dHddl6trWoW5bosACPEiMTichvLyYepUzMFSrtS9Oqhb9LgG1e1TtEyIuMsd2Ll0XzFfRUcVEccxdzXYBumLILGAs3W+zIXT8WMrRwZh9wU1/XgOmscyjQRw4mtS7Z/uUljK+0o2+8znRhZ7S2pM7nwBT6hkrXjCPARPzcSJzJ6iX4d1JfUfakW9pzJe9yhxZzN7rfQhpZQQL3zJ+jIAccvQi0tw7wURuRXuRTL0rQ19IhReEqcsGleaEKUdmO5+SQviw81d6qqL0RVssYchBNuZpvq92qrlonO+YFjX5i4jTpoTat2RuFwK8cMMRWDnPtIZoaHr0DsjdZyyHHSqEyV08kr7XGqbwxi9Ez0eHELhtHwx0Au7UAS2r/J/DmIT94eSDKugcmZhZYqEatPseXtsyp4gQZbdk5OcgNpPta+2izRew72rPh12RfnoyMxD7jFfxwVaS4tLM3qkxdP2AP5QpwqnpGERnclPOr59NMsmpM0xv+p/7QhT8y+CGrSvdKYAPbPgHkVwA1CaFu40p3iM/uviEd6dSpbJHQ37WV6ge7Z/O7AqQrqIJOoAg8ADemvgzvyyq+SXPDoWNu2lcax5GmE1lxvBX3phKquneiJ2hlzGZx8NoDprKzRHI32JYoKjYZy23hrlz5KsjAC2+tKBv4i4UhDj6hK1qoVrDExv67xo/F59dyK82CxeqOWuv9P3Y40T3YU6tbgQQtIhKBwRpJifR5udACb0d952mKNNxELUrwP2qvD8F9xqgvcubuDiYVu5UMbiQTalRY2srfpLlA5UDS8iR/gppXom9xihjYdWpp9LSs1arBbo1+VB5itsfHwtVDuyG12pmivGg8rg+DsAdeU2Yky2te5WDPPphbMU6BcMWAXmMv15VUGyWuyGnS4QwQIJsQD+PY+Dqn78+nyaQhqUW/4o6qXgB/jqM+UaeW/4jRdei6/PzXDUS9
 vPb4ra47
 WwiocjgINDQeTegY2zFsKgDCzYRkf+yF0psh3nan8nstGGQZc9bDbaALASpXEFC5HlfGu6DygVGToEgXyXg7Qp0F37MFiy0IFdCZH3dezNs3nYIN8BuotDnLNailiSWcwQ5YKDg2rmvla2Xi0eFXdcTxx9drunJ//4mXsw/tYU2YyONPhEd2DOji1YMCVQlzVk9z5DBbs69C5CE7Is/sqfWJOhgamfQHyfIIoYbIuc3gzlIrsyx0EZOBpZ84bpxrXzEYS6Vks3Sl42Cg3V1mX5c/j5d4oTYXckgOK5mx13AoFj/Sy1OILkzosKIYX7ORRyrdsP5ha1mGjdXQbvHXM7/Gi1LZkiVBeLxkr2pMjtF4F+a2ZIGpcSMwWN8AWLhmqYzVtAonBzpWENSNym+skdRYtqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_next_zpdesc() calls get_zspage() which unconditionally dereferences
zpdesc->zspage without a NULL check. This causes a kernel oops when
zpdesc->zspage has been set to NULL by reset_zpdesc() during a race
between zspage destruction and page compaction/migration.

The race window is documented in a TODO comment in zs_page_migrate():

    "nothing prevents a zspage from getting destroyed while it is
    isolated for migration, as the page lock is temporarily dropped
    after zs_page_isolate() succeeded"

The sequence is:
  1. Compaction calls zs_page_isolate() on a zpdesc, then drops its
     page lock.
  2. Concurrently, async_free_zspage() or free_zspage() destroys the
     zspage, calling reset_zpdesc() which sets zpdesc->zspage = NULL.
  3. A subsequent zs_free() path calls trylock_zspage(), which iterates
     zpdescs via get_next_zpdesc(). get_zspage() dereferences the now-
     NULL backpointer, causing:

       BUG: kernel NULL pointer dereference, address: 0000000000000000
       RIP: 0010:free_zspage+0x26/0x100
       Call Trace:
        zs_free+0xf4/0x110
        zswap_entry_free+0x7e/0x160

The migration side already has a NULL guard (zs_page_migrate line 1675:
"if (!zpdesc->zspage) return 0;"), but get_next_zpdesc() lacks the same
protection.

Fix this by reading zpdesc->zspage directly in get_next_zpdesc()
instead of going through get_zspage(), and returning NULL when the
backpointer is NULL. This stops iteration safely — the caller treats
it as the end of the page chain.

Signed-off-by: Michael Fara <mjfara@gmail.com>
---
 mm/zsmalloc.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -735,7 +735,19 @@ static struct zspage *get_zspage(struct zpdesc *zpdesc)

 static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
 {
-	struct zspage *zspage = get_zspage(zpdesc);
+	struct zspage *zspage = zpdesc->zspage;
+
+	/*
+	 * If the backpointer is NULL, this zpdesc was already freed via
+	 * reset_zpdesc() by a racing async_free_zspage() while isolated
+	 * for compaction. See the TODO comment in zs_page_migrate().
+	 */
+	if (unlikely(!zspage)) {
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
+	BUG_ON(zspage->magic != ZSPAGE_MAGIC);

 	if (unlikely(ZsHugePage(zspage)))
 		return NULL;
--
2.39.0

