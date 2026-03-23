Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EAF2EC01A9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 614D36B0005; Mon, 23 Mar 2026 05:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5BC6B0088; Mon, 23 Mar 2026 05:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC036B0089; Mon, 23 Mar 2026 05:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CFA96B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:37:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DAD8BC334C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:37:41 +0000 (UTC)
X-FDA: 84576825522.08.F14E7AA
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 28CE940009
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:37:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="B/i8Yb2d";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774258660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11UIp8IxrCOZ4CscQC39RgQ7SkxaeS4ajtLQc+uqo3w=;
	b=36ty4O9LMNjTRmiECZYGV6IJehe9a7MhThGxDM+9+O7orTKIBKo6cnMRFroIlpHFcA6nQh
	EVymbMz9O+OFxZwSdFc3qc69UkbFMmuSMhjiwkU94XRJet6grIUTFNLcaf9vVbTJFEP6he
	CyEP/qCpSsi50ghQ/TtBJGzoq7z1n/s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774258660; a=rsa-sha256;
	cv=none;
	b=fdD0akD75uH92LQThOoj9k49LdP+gwAq0mq5EhzpF/bhhYZkIRAq4dw+X/R8HdCHiBxmRa
	1X1s7M0eYIN6raZMX4OPYHTtYMStG1bOBd925bKOUiwSUb3L3dLI6P+6r05Ky2lB/+Bc5q
	U57c4XlQIzSvs7QANkHrzDSPzCaL2EY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="B/i8Yb2d";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-79a74765703so22367267b3.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774258659; x=1774863459; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=11UIp8IxrCOZ4CscQC39RgQ7SkxaeS4ajtLQc+uqo3w=;
        b=B/i8Yb2dfzGp2vJkL+AuzxSEXlRtWO/2QysdawzvPtQH4dSJZ2I3RrBW7AcfJFcmCr
         fDERg2ZGwVrGb1pbq0QPgBsx8IydM2ewhIAy3vEOBtaQ7Zt0dMi2pPZ2oGFk8GTfNEB7
         /aq8hj1z8KYOgAVCWNoqWuxPGYbSf1N904gTxffGow1qUkYFOMRo8yga4RfOYaem+rdf
         f2sjbOn2DBQnAxaNrb1dtXkaaPmf8FuxqnrrPQ7zjly6S8c3DNVj4Ott5QExjyZaZA1u
         Jvrv1rZzI9skEjKMQxiDWYvWOckB+2NdDf6Ke629PKoqnYOpOcxeYCbhysJ2WfkmwNiG
         c9dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774258659; x=1774863459;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=11UIp8IxrCOZ4CscQC39RgQ7SkxaeS4ajtLQc+uqo3w=;
        b=C971aFIEzukLgOOW9PsIPfp7AH2ynon+HmOAhyTUrzaLo/2S7d527aUQ65yuj5nf+C
         tmBmmDYM0rGSgGk9nEPupIFwpgV85eTIgs6Vwy2bnYZDNfu5U/Dd5oB5gBbdAGOGke37
         0x01YtoYhNuDOkriQBMRXsqRPQnI33/dlCjpnnR4rKshvzSvFuesBA9sFA0SteCS5fS8
         8FjaxVv6iDa+6wY1PNlT/hcWpyBIq3x+Vbk2plrFM9wwhoOBQl4vExYVajKEGqqUsVEH
         B5uvBpOC/jQlfAJU98jpmPGBMdgtUiHpq+SPMUVC4e9RrfKz0Cc8bMKreUVxIIYjGgip
         fYmw==
X-Forwarded-Encrypted: i=1; AJvYcCVauaL/rpas3eKSHmP/nZB+q6O42FurfO+fxgbGxOdEdWsmnxOk4KNojO2dx7Myp/8LUrX1wJLGGg==@kvack.org
X-Gm-Message-State: AOJu0YxvRWi/Bf0FfvXLl/K8r3h7dZThlm0TPYYqZF583hD1KaTKQPIn
	mNhCuCZ6LVvU06iUvK+fujrPJGJoRdpzNLehU5xtnonLg8nY2mbCbq6hmtot5V62SQ==
X-Gm-Gg: ATEYQzxFn3H9Y+9062FXl8OMFZdS/3yyKl9pKNOla5qcA2NnjywnRsx5S1b5CEDWJIy
	D2Ph8bZwXQhmoXPrxjXvo1MHzwFHmt+MomaulM4buKy8RzcJHaiofi2x3StQ7ITVQUnBRQUFgYY
	PNTycN2FNrDYObXzzVsma3IOtaLyJ0hDuQnlzKXch5befyMK5TN2O/HOGItpZ+u8cjIeyebRHKz
	aTrCc437UVoXvs70eOm8Nwei+xXXqAJ2Wb19nWIHPVjKOziUspUwtlFIk0GPGRFlzo/0dB9iOjJ
	/NN02u892dRrLOGECI15r8DzVtbTOub5ZCzVCCxnetvuDi1rl4SxSpo6yZ7JX+3/G5PF86DS3VC
	N6Qi3E1vi1SL3CMLGRTBJoS0/SOXrWyWn0EtypA9MWOwSuaZVeCVEGLWU90h5+ukn5O36m5Q39w
	o1nS9LJ5LoiYCKGOyPT9svHs54BZkj680fQAaw0hW3c+eb36ecuf0vRsjR4zrwqQQqM9RCQi6OJ
	H6YPuMIh08=
X-Received: by 2002:a05:690c:6989:b0:798:3a6:3f4 with SMTP id 00721157ae682-79a90c0ea58mr109652647b3.43.1774258658763;
        Mon, 23 Mar 2026 02:37:38 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a905a2eb5sm54396627b3.42.2026.03.23.02.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:37:37 -0700 (PDT)
Date: Mon, 23 Mar 2026 02:37:35 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>, 
    Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
    David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>, 
    Greg Thelen <gthelen@google.com>, Guenter Roeck <groeck@google.com>, 
    Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
    Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
    Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH 6.12.y 2/4] mm: shmem: avoid unpaired folio_unlock() in
 shmem_swapin_folio()
In-Reply-To: <a07eace6-82f2-32a8-0cbc-85972d4b1eee@google.com>
Message-ID: <49bbe4fa-b678-1023-db47-99a730e2827f@google.com>
References: <a07eace6-82f2-32a8-0cbc-85972d4b1eee@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 28CE940009
X-Stat-Signature: r5axpt81i4kr7zk5mtaxmtdys8qztrao
X-Rspam-User: 
X-HE-Tag: 1774258659-727974
X-HE-Meta: U2FsdGVkX19b8p17wg70s6w7Wyk4sqw4FbX9ZXaReR/NA7RHM85p9gceBddrwNwrseO5AyuKPShlMUAH4C87n+pmKBlNTVXQK6X7uegwWV2gQJ8hsS7A+XG0g791AYPI7dhyEoT5EmEW8fgUuUaClT1xbjsMNFmekjTw1yD+KWJIUJKBD2S+8HkHx9BTcxhPsmTdauhR6hRLQCd9S8BAoBYyCJAEHzPh4yNKJ8TG4/sAQHXnIuaRxrD+zhg2kq/GQLKykVfHiUWQhgpmJKS2rIUwB9XNEyDVrDStSIno1fAjPpYSsNHy2lT8UX2wMiciaukEEO60PK8leEMPpvJ1yYUn0z2AhAMZosonYBvG4whGfTe6ZFcB0oK0CGGamCvMoC5iP+KsSALShTiQc0FI/yFp+zHWFz3KMjxUol+bKCD4vExv1pP7E/dFIj2xLsHjdMzY/Pyu+MNgfExVjt39DB+YoQGHGPKAsShmusSvGdCfm/AYsn0Qy/KShC1/NyWfj6Dwmag3thx4leHAJ2kS06ciNWwci7BcQTLAo93eD96O5h1y/IPnfuXvSNPRhZ+HxT4pBNVKDztani+GYOOh24lQK7gbD6YuRM+bPhDZAbrn+DVmLWOmJ6IXnU4TZClMc6rE08RILlONF9OJe5bnDqjjTwb/Hd4Mr4tEuNxH/AgfY9Y5GDynVs/ZKyfCQRdfKsVQnHXxhZKUDvsgmQ9UkjxIm8cuEcNJ1vW+bTpgMBTWJKJCC0LFqz7ALz8KZCfgymj0sU+l4mDpygGjRKZKrA8bAa0lCxNG4W8WFewTWWkLSkPYfClwOCq2fafBu9UkUdXV8lMQqRPoU116iBvHGo+MHOrNGjqAGlSYFTlRglv4x1HnqE+t7rSQ5FdOiWj+/bM2afLQ2Up3Irs1s6rsPxb6Fg4FxHoyINXzIP78mnYxBJMRvAf4/+XgX8f6FdmQjdM47HfscrpMRfgRjWw
 u0opA8yV
 h7zCy+UnhEEnjuUHwEdTtYUotrwKIwe/TbkE5nMwJTkQgbKwQPGNUwKYAzmylaZaY/ulQze671jYVYbNTz1fju3Nb0NSWitTT5M0d+Xq9RHMEFK7m5zqURWovA4pvILiqHXtaXeh3iWARMjMLYUcoecwvhvQxWEs75hH3A7ThUf+xq2bDFOkault650ig0AM02flFHeZ03Cy1umCHJ0O32MuVlTyPbDrwuw2t/jcFN5s3ISfUnC7DpNZ4N98tpLUQcIu59OZ5OoGHT+9QGEqN4xBetyKW97DXiYAHtkURbX+SaQYqv0ydzv1x/jjD4LIGkgmajgFxaB7X88L6mZ30ocvx6ugixqP5w8bLMjeCsj4tAO0LSuBVRAV8EeqcY82KJlxGxqUrkNF4QcjzeD61fHnAroidSfrUbHvW3dxFzIUoJy6aqCCjhTCIz617PkKP/y1SyufZzEvmEDaIsl5felcmKWYzMNpZjLuz9htODd675z7NhSSCLJxsHwZkYBMtOBTDbZB5JPhx1vpG4/wCmUi5wZQ5ikcFXoLK34mWcbbZV4RemG5uMbKuHl1grUr4yG8J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit e08d5f515613a9860bfee7312461a19f422adb5e upstream.

If we get a folio from swap_cache_get_folio() successfully but encounter a
failure before the folio is locked, we will unlock the folio which was not
previously locked.

Put the folio and set it to NULL when a failure occurs before the folio is
locked to fix the issue.

Link: https://lkml.kernel.org/r/20250516170939.965736-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250516170939.965736-2-shikemeng@huaweicloud.com
Fixes: 058313515d5a ("mm: shmem: fix potential data corruption during shmem swapin")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ hughd: removed series cover letter comments ]
Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 9105c732f341..9b7df8397efc 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2198,6 +2198,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		 */
 		split_order = shmem_split_large_entry(inode, index, swap, gfp);
 		if (split_order < 0) {
+			folio_put(folio);
+			folio = NULL;
 			error = split_order;
 			goto failed;
 		}

