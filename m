Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04435CA0EE4
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 03:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5F56B03D4; Sat, 16 Aug 2025 23:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4F06B03D5; Sat, 16 Aug 2025 23:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0BA86B03D2; Sat, 16 Aug 2025 23:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA3A6B03CD
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 23:27:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5005716034B
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 03:27:14 +0000 (UTC)
X-FDA: 83784813588.21.322AE04
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3701A0006
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 03:27:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cNWCGX4G;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755401232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=V1BtoQA/QkZ6I6pbCFHA5NhFfEEg4VOTrg4sxiNV2KI=;
	b=RA3U+hqaltPkTIMZxwUiGnEohqVM33bo0T5I7aWEgV8MNeHaiz8+E0IZ+bGzq4tOGCZ/5g
	hhbc6Iy2b9MjRHoByO8IckhRYbYUO3+FfRV2F6CrkLVC8B0WnjmhbBpVbXhzP9Pqt0R6zT
	z2BirE5ADVB6ss9g/FwNVZg6CHA4qIE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cNWCGX4G;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755401232; a=rsa-sha256;
	cv=none;
	b=na7AdXFqAhhJeo569rFa2BPsZmwklC0aoRcrHc98itIdcCAR63ewGb2IK0R7hRjd3yqP4C
	27/TpwBzVbimo0UWHs304hl3aoxHBTK+aJ4HKm+hgLNphLix7TAkWGMMBWtRvZxr9Pgk03
	zmlKfcMKEZ4FxRXWmuTsNo0l0hIseBE=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb6856dfbso549178466b.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 20:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755401231; x=1756006031; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=V1BtoQA/QkZ6I6pbCFHA5NhFfEEg4VOTrg4sxiNV2KI=;
        b=cNWCGX4G3Dort22GNWT4f+cruWYsxbIgk31w3dPXFfJbnvAS8+AEc9gRaOtE6TgNBV
         2xgMWQn1nrr6C01P8u14Y4684Uzcyk9PMpd7v4/cw5Pn5Q5GIFKzzmMdRzuR69pZBZsU
         rzpnkwUaJQ7Skl2b0gL3/1alytDHYua6ZwEgFnFCUYIZcwl1bbRlmiEso3pxNEKjOoD2
         avcpoMFArBM0vq84facyeutZ8JMkMB4kN9SC1KJudZubHdyXcwi7UimssR8tCAMuQZj5
         bNmTiENmQsdguzibhHgYjkHkMnpCwWB+OEhY5hAsJJ4NqJGIc/MCvnI7o1oGwhdMjtAC
         MwyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755401231; x=1756006031;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V1BtoQA/QkZ6I6pbCFHA5NhFfEEg4VOTrg4sxiNV2KI=;
        b=IjkK3KLZBGAW/XmUFHql2h6O3nhmAVRXy38QCweYW9Ofltwm1xAJ6hzJBEpA3YeM90
         wp/GmpUlUlpWvkNI3DpfJuDjexNQeBhID8pOXnZtG/aWciwAIqbZQ3AqTgo0YPOLrTRX
         yhucHzsXNTK6flqoHKn5QuQzyJx469H6GXKIak3orGjx5rLaNsgXp+/UhaIy84nfdQsm
         i9qmZYiBxAkL/cBW5VPeK1MaoPrQZSINQm002sGxvM0Mlkkf8Du+9Q0BthjXZLlBg/Dd
         mTiBiN/HTGsf3Ds0AbBp9eOJDFE4W7n9xFr1Cs0rc1Lhe2Hh9pe1WnJ/1hz+CCObbQxz
         dU1g==
X-Gm-Message-State: AOJu0YxDJm9yGD3jJUmKmNN04aDaJ2rG078gLINKzaO6cZehxmcBKhj/
	BC9RBPeCL0qX3zP2ozRpUDu3bvHr8XMbc6pxmjqCpcCzY5FXitb2a0xJ
X-Gm-Gg: ASbGnct62Js7AaApTL7haEHEbl719REgi9JzPxrkxc59wXESrpN6FJxw5UgxlisultQ
	KJkDbhDcGnh+jOso6mPPOUKyVkKyTK6/0VqMyFoxsI20M31gDuvkmBdRzzv93KnHDHZhslT+ITB
	8lbHzIoEuxsujI0ZBausCR0dB98WRxh8ejTA+gPqzgpV82+o0JbRzNNN0uQaWr+zHahDdiA5aY8
	CUZzxTLhLzwwtHEyC7IpXwmJoKfQEad0+/U6m0otYlh2ByfH9pZ25/l++B669G3N1O0drRpq+G9
	Kg21+JGj2Xk1WSX0gIaMQQE1RXny2XWOpXRtmvRpCWldzBdz+Q/+C6jfK5eVmfYZiNq2JD9CddI
	vFCc1VOX7+pKwZYSbGZ2+r0ykoyg/1CIH
X-Google-Smtp-Source: AGHT+IGaT3EHimg1DgQp2p5EYBU7LKzQaje0JR+nPkMEkKMxgfOgiZVN89kRm+wFCU8JIyHwE1WNGw==
X-Received: by 2002:a17:906:cc10:b0:af9:9e50:470 with SMTP id a640c23a62f3a-afcdb2dc6afmr660361666b.28.1755401231084;
        Sat, 16 Aug 2025 20:27:11 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdce53e52sm497015166b.25.2025.08.16.20.27.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 20:27:10 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 2/2] mm/rmap: use folio_large_nr_pages() when we are sure it is a large folio
Date: Sun, 17 Aug 2025 03:26:47 +0000
Message-Id: <20250817032647.29147-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250817032647.29147-1-richard.weiyang@gmail.com>
References: <20250817032647.29147-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B3701A0006
X-Stat-Signature: 8ghgwf6sjgkdc95q7srmgufwhknc5sj1
X-Rspam-User: 
X-HE-Tag: 1755401232-464220
X-HE-Meta: U2FsdGVkX18RRQbaAJODtM/z+hFwD3FGB8Jh5Lbo1qrkq+o5nOmxgkO5NtWyoDjhIK39IPkoxt+/A3ZcDUNHFTaaVCWg3Ym6b07ki38NEp0eU5UrqaF2n0REoi3677BK+arfjFbXFuaZocciYI8ZMULucIJLpXtqjrnRoQS34MCNKtZCK4vYmk1MCluzjiu9Vtya/oe9u1K5G34KWcEAYyZxPlgsKJUtp7Wn7/ecqikwA8bhYBbvDjXV8zd+IJ4/1QTL5M2kcUrjlIY8re10cII0W5g1u6zZe7AakQlgdNmY1/VNYj4ClWI8Z5d+gcLNAfHtiWYizM6Oe7tocVi1PqQzKLs/El0aGuLV7XZy33GMxZqqxfTCkUXZUbCmNGuB/RO2ReGniyeNkh29G/SdnVjFNDC2kns3FpxojGDyMoKbguBemyDZ/3wHhQUR+1g4jks+WPyq/4vuJ4R3hjZBO5FyCO29JTJ/Y6Td8fhcuJFp6HTyCjABg5rYWBqhpTw+fkKbuxo8vWAep5gEzbCwQV20aEIg9V0Vo6Opyj6nuLhp6j/J1RZGqbV2g+oXaKrnSJspejrmtZTWqKN8qv3pQm43+zKUeBqjOO0zpwPvCbHIuQAT2tUpF9ngCIt0/wiaotg3VgpkTdjggeLLO8fnt07gNxZMByYhMKaQzPDqY9LoivYafJRkS3eulqMWydWuIcEG9GYBMU4f1ytclMhFRQWPiZIX01yPLzPQLo43C87RjfNIKROPqK6QNtvpU1yKBpfhKnlV6rrLiAgh2Ah7N8Oeb0hWPIjYFWx/RaQ3iLDUdnYKmwp9H/0qS4pSPFn/T2g10mT8LcMNUIVF+fjafOHOAdDnY2mmr6yFqud3cwBlqWajcIE30ET5oAuDWNlcCOOYLsfwhw3XxZN3j2t6jV/lvR7dPnh60/z3zRNkW1wTlQV8BKwKovnPmntXNpAiqwnXqz6j5aNpvbMgAfm
 K2cYnRWQ
 oL298nDkf8Mnv5PvOzfxanQQE7UNIsp52bvCN3YNHng1fzEzwiIgLdWr1Ai/ZnwDw2BX2PQ7v+ye30UFQno6Jw10OwW3YGYE/ypDGRnBn5VrAA6mxktz3qNN54YBJ401p42JxhFrsXHUNPjCtPpnSjx2Q/mkVsuRIRiBB78R+rCvyhLTItMOCpmkmmBy4OIBV/3nSN/Xtjl8kDPimZXY3j4eefiNgcAmjSREp7jcHrbcr2GJ0QUHoGmRC5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Non-large folio is handled at the beginning, so it is a large folio for
sure.

Use folio_large_nr_pages() here like elsewhere.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index a927437a56c2..14cf3b24ae50 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1703,7 +1703,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 			nr = folio_sub_return_large_mapcount(folio, nr_pages, vma);
 			if (!nr) {
 				/* Now completely unmapped. */
-				nr = folio_nr_pages(folio);
+				nr = folio_large_nr_pages(folio);
 			} else {
 				partially_mapped = nr < folio_large_nr_pages(folio) &&
 						   !folio_entire_mapcount(folio);
-- 
2.34.1


