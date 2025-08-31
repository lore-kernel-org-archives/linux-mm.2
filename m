Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E118CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216958E000E; Sun, 31 Aug 2025 05:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12BDA8E0001; Sun, 31 Aug 2025 05:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97B78E000E; Sun, 31 Aug 2025 05:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB8098E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:39:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91DE81A03CF
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:47 +0000 (UTC)
X-FDA: 83836555614.14.DA8A6B1
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id A7A25160004
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="U1/FzMZ4";
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf08.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756633185; a=rsa-sha256;
	cv=none;
	b=6xycimmIq8PNNwrflOqO9DtyzBGpCRB29hZTH2lYZruCS5WklPy4APhzsGj8Tkbp1DmQRh
	tBEbyq31PxWwOzXaTnKvrRA5z4VzDqzGvWrnrT9zK+EbIRM7tzUnBhfFfmnOIrM4TMqNcN
	7JeBAPCZgVO6Xe0R+pP4O84skEDg5hA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="U1/FzMZ4";
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf08.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756633185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbQrHBJ8z81uwew1vi+7yRgIBMEBSVZY4WcnSS+Eg3g=;
	b=FLe1NDf94QoiovSALdYxWrLtBVeCoXfEzmZBnmnU8xZuh7ntZo9dUDAxWk2s8vSLpd+ZVI
	8ETkyqNawuYy51EuRjGgC4SmLq6y5pHNlLfUiauwYk+yVyv90d1aJFiGM3f0h/GDuGo6Ms
	heXoSoKjiJQL/xIIt7GA4RkJivz154k=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b040df389easo124548866b.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756633184; x=1757237984; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EbQrHBJ8z81uwew1vi+7yRgIBMEBSVZY4WcnSS+Eg3g=;
        b=U1/FzMZ4/3E4HAMZhkTtdXtDwjnYbBirvKFJ2jAd3VE+9v6O1N9uzD4Q7WjOc4VQBT
         4jexS2MH+nDJ2h9yzifCAy56Bv78q4nbiQiepJWokLdCDj3XI8eHqHzJe4kLWua6l9RV
         FrTzd3ZZEVplMZSCwzi2hpe572MAl8WaUnY2/1bJbUgQBgt1cHGlCsIN8MRthd8bwZLv
         b+zi50Benhos78DdgWAvVctOrqOGr+BHtDSQQ71EnYUYWOeGEvZiOw4KbN1RTqCy/xrR
         HQj6SXQIGFIx0DVR3s7KsC6osvfgmrQvTrKv3cOYJEopxdx/rvLNVEC1P8tS2MoAgN9n
         p4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756633184; x=1757237984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EbQrHBJ8z81uwew1vi+7yRgIBMEBSVZY4WcnSS+Eg3g=;
        b=uben4tLj15jyIm8UbQwCAMlwehxdwYW8T1EukM8DjOe89JIh263KJB+SQbqn5lx8Ko
         s4WuWbsJOJh7rfmhLE3j0CRmHiEUQRBHZp1OstazFSryi+wmtNbdlZOy8s2HxarlXQF6
         SYTa9wOwzIZtqjhAFKaBJZcFHYGhhPkaoPu9oW3d20+WdINOchOKLSJwKBBnwFlrVT8I
         9jpO3ro8T5IcNOl1RTAsGPhUb5yAC5Jb7aylXIjunUEz4bvKlSnTawhWrjF9Aai9my1t
         E1DjeO/wbrlQfDIpGuCm6P58oVuQXXyKuxWw5zerVoqn4TpWsQuXETcbdM4y/ul81dMC
         yV2Q==
X-Forwarded-Encrypted: i=1; AJvYcCX8ltEecbVGPOr9rnHlQoyetL3n0beVpDZguaBdSkyIwly28lzgFPZLDi9t8ojPfdNHGWERCqGiBw==@kvack.org
X-Gm-Message-State: AOJu0YxLS4WAAyPiBBmudBEvvLbwM39mFouKfuijvevc2V3nLiVdACl9
	heMD9Ryn8B/qkytjqmX/TvaD2WYg7eFzgPiUJs0Yts/0Uzu7mnBGDXJXZd88TDa1SxM=
X-Gm-Gg: ASbGncu/wPTRFEwmLTx57tNUl66atm7cOAI9kdHbZ8l54dw8+7FDT+gLgVaBW+WEfvM
	27ky307BHbuetnA4KcrIEjgxm8dq/fxG638Xrzn/XJ7OPmcWzZKZCZBUnvBoWdM5j+PLbY1pkXn
	/rNwLjg7a6Uj7OuwyRwyaANtOQzQesCSa0SfF2lNsc1e7nPBycUzfnPtW7QWCP3UndZ15bzg/Aw
	e/8bRBkMAvhoSy0muDnaLmVOUJxc5CwDzfRCF+LUCrd9ot1DsBQu/v8/7lLxxgpMsav/alw01pu
	DSTNKNxH3/JrjTvhD7nZKsXYKEqegwX/P0pRQ0mWw5wL1JNO3AniAJABElSJcYokdEe+tqG5C6+
	y7kFTkxwHON9MJa4qySW3gKDDjpq5Wl00jryJOnYWfzi2CGEmWQXH+T5/yeNwPf5P2YWKtKi2h2
	IrFsAYy825zGi0cLJOdO6P/rTWlBNxhBMj
X-Google-Smtp-Source: AGHT+IFxQDWLhxFg2jVKkWwDC8C9a2hu8u5iRtfwJyK9WMd0nF5snRkYBzKz4RD+jCsXIVYHRgz3VA==
X-Received: by 2002:a17:907:ec16:b0:afe:c2e7:3705 with SMTP id a640c23a62f3a-b01d8c74961mr360813566b.22.1756633184278;
        Sun, 31 Aug 2025 02:39:44 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd8656sm597512566b.56.2025.08.31.02.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:39:43 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2 09/12] include/mm_types.h: add `const` to several pointer parameters
Date: Sun, 31 Aug 2025 11:39:15 +0200
Message-ID: <20250831093918.2815332-10-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250831093918.2815332-1-max.kellermann@ionos.com>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A7A25160004
X-Stat-Signature: 9nmtchk9d53szcpeekyqojedufeb94pf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756633185-890382
X-HE-Meta: U2FsdGVkX1+Iwd8QLZsCGx4+RNuv69l/FXcnYjTAD+7Tc/TbGYMnPuUMLdzO7F3ZU5kG8dZzg2dESta9oU1ZMYH5jF6eUdc3worE91wCqFqHzTPV0e0LyWjtawcOeTXhhbZ2bF6bcJ6912VdDMrYVSuYzqJ8Al/KsmPbde67eVrkjiOEtZ0jlmfVmPQ6BbrrnXgWAdyurNHx/Nj+hzYIRvfdLb3Q9WtLsJJQuhXO71X2F8RgIlVCgDHbC31OCzmRmyiuWd+D07iiU4TiDYGD91Afyr796kjSftrX+yswVsgUSz7ouxbH6xb1Sgl6WzBdGrbeEEpXzxRHlrYn1vLUA3eEpYSK/RiYNoODcVaIrNkGRTE4RqzoAXU7Tzk45BK7hvQMlYPK7HBuJ8v/gcGJ6lStF7lRDJqoXlCdqHNU5moEas2atqZ4A2p8W3bZ/D3J4NCqZievcd4bRo4EPtHrN/qpuoMo91KZb8N3fVixb3UTxJurEQrdaxNONIe1qzXM9598GJp36/a6d4X6o4BoWfQJfOgReYg4yZZXwnWLf8V/eraKqqaR5rnO6lRWyiFtm61nDNGBnlxtKhwopYTQgEOOKXjweDQm9+7DBQA4o6LvwE0MwhmXUMga3lVYX8kv9eXpMciszl+ir9+W8swazlFxFV4fcUOubkaH0iP6CiShURs6mZBMB8NDI/m43Wsf2A0J4lX40h2MZ//TAoEi8FrnIRnrDmCK4R3CNIuGKb03Rux3XAQ8wEwzsA/b3/GpJTO8lNj1RemgiT5o9jJJxh5MnWArmOZoqtzkRjskYt6RpGCdEVtmIgG+PGZ3RQcDr9VcDh3KzDSi3RKvftX31cfSJHJtMswsPcy38hdOFLF8cpwRA1NC2a34Vk6maFAfo31pjoq7a7n4HEssSDcTEYOMoKcEm7r2WdEnoBUuYseoMSksiIyH1I356WXPCnPlY4zTxPWvFYZwLUtjOYE
 CEJ3I7dE
 dZok7n89r8/TBDIYY9JlBQ0idfYhpVmUqqfHog19/pxZ7w0Qk5bMOBF03oFpFhrKVJcs4mx0YorvRBfZyXucNBEeAOb8DaEkp/hynztqwQ+mLqifn4PHEWYOFyYgR8Q+VTkPFC1Fm0ojuoPE2usB1vjSdFFW2AiIhcdTt+SrLLb1SuQcCTMZo8WFqcmzr9emRp5OkWLBbDDiUExIiYy+2uXqmVYEZSe+14P0loUhmAmeJx/D9FY68I1jcj/KD8zZ4iS7ToG3EBtz3z37rv4Gs9pSv2wPgIc5oilvrdqldBtmLw6ybjFuSXvPf3NVVD7YKZMpUt9XwalH26z/CzHzpZMw5L09wvKdgGBB6oidDaS1nQdpnTwALoDSoqVOIk6acj4dJfNT6Srfbpt2b7wOoqXz+frxfGHvma71LXvZ7zretMoqZMAkKsD6kg9VoP1U362SvkiMG/FRXQ9fVnXUU/yK0P0c7ssudqqdwQq0q6vhNKWcdx6OZ4BjUNk152OHcKRg3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mm_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d934a3a5b443..46e27ee14bcf 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -632,7 +632,7 @@ static inline void ptdesc_pmd_pts_dec(struct ptdesc *ptdesc)
 	atomic_dec(&ptdesc->pt_share_count);
 }
 
-static inline int ptdesc_pmd_pts_count(struct ptdesc *ptdesc)
+static inline int ptdesc_pmd_pts_count(const struct ptdesc *const ptdesc)
 {
 	return atomic_read(&ptdesc->pt_share_count);
 }
@@ -660,7 +660,7 @@ static inline void set_page_private(struct page *page, unsigned long private)
 	page->private = private;
 }
 
-static inline void *folio_get_private(struct folio *folio)
+static inline void *folio_get_private(const struct folio *const folio)
 {
 	return folio->private;
 }
-- 
2.47.2


