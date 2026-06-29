Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCCB2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04066B012B; Mon, 29 Jun 2026 11:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4A56B012C; Mon, 29 Jun 2026 11:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07056B012D; Mon, 29 Jun 2026 11:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E40B6B012B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:04:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0EBB48B4F6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:19 +0000 (UTC)
X-FDA: 84933271038.10.AF57073
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 470BE1A0008
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NrjLMQaj;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf19.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745457;
	b=ZX63M+7htNnq6wboLnHJ9qQNtw6Bw9C01iLcyi285ckStS1bZpSjMkYFOEJ+P9fZTwsHUX
	YSdJmbku+K6w9xMyvjpdvwYR9ZPb5UKv2xbNUor82fd8rvbpmd6/TORQXcSR2kKZ3fjWMe
	7pEhuraabxQ22m5DadK7mObuWhG2bfk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEb92y0OFGIGp8KnpPMEgpAgd9nDvKCXKevm98JSiJQ=;
	b=bmDnoOPqffpgAqTj4DNrYJ3WwpcIszwNTE6JTCaW7O65vrrL01tT3k1CxNjc8KbwX1Kjgd
	c4ygClniHmg6EEMojTMWPvr2HIXSGdVmOxrq1HiJKWisSEIq43qhgZwm4gCf69F6agA/8v
	ETKFc8VHZ6sXHkweSeu36TTrNAJFBq0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NrjLMQaj;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf19.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dEb92y0OFGIGp8KnpPMEgpAgd9nDvKCXKevm98JSiJQ=; b=NrjLMQajpvZXD1yyxNAvJ1jscE
	97XdhEoLTPS6H7OBeMBZSbkEHQs8jkRA3770e/B4r+saexCKqU0v3pn8Zsa7IqngTkvN3Vo015skc
	fgMGIHkx2V6J5cwnKNQ/pZ64lYUG7j59X/HMntEsSNGL5X1hop1rJQqAad1RRJIPfWgLtuGcu5Ou2
	EtTEhquWrFIj82Gr/J69r0bKy60kZBYFVIdNwUJ2s8zPEpwRtfGxVp0/5PKbE+c5iMAhqPy4dtBxS
	h4TbN3pOGR+OtYpWCEZD7ukb+Xu3EPwPtbEocfx50ldGO+gYEk/tEn7qwH+zvrpzPHuW+vaTC9QrP
	cQfacSAg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDWy-0000000F0MM-0i7T;
	Mon, 29 Jun 2026 15:04:16 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH fixup] maple_tree: Static define mas_lockdep_map()
Date: Mon, 29 Jun 2026 11:03:12 -0400
Message-ID: <20260629150312.1597380-1-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-4-liam@infradead.org>
References: <20260629144145.1572283-4-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 470BE1A0008
X-Stat-Signature: qrbteuso49fu95w34in8x89reri7umb1
X-HE-Tag: 1782745457-851755
X-HE-Meta: U2FsdGVkX1+6Et7WZzTFC0qVDrePSIQVzrx4rHszG+pCX1egWw3k0HVNkqnTBOC3Q/Nkm4byCjr8yyNt0cBvRxWq/xo/9JrNv8odP7pCOaRTQM+Kpjm2f04UCGw5R5soaCUMrOkQWKjEAAOWQMrkSi25ju8SHFWsZRtj6bGwnzgRLvHZZ8qNPL6v+NlAkbEuLcJYtiqKAeYNC8jwVUUFEDwg92RyxjTZXQdoV7Fv2dJcphwf5+bjXGVrzWgUEHhMoXX7eT5MvlXM7T/K7BW1FgDLnqen/sFo3AxkBRCvhv8HBdaa0lY1xXSpaCvP8iLA1DRulRDGhIFXAJG5Z825fxAylbJ/gogxdtEtCooD5Ribh0Cp8NUR/VM7j9qj3YTG+wR783Xe0vfGO3N7q2PEo59qVgi2jMAc+mXh+jRLAElCWCeAYQ0nNGCkYCYr1+NI2QRGG6zNomi5UuN8bQ9iWS2caIEp3AtCW7LobVkAgZb1AjVJsDKbFN5y70IpUVTYWdFp8qWaYN1rYOQhPlsUcow2IJdsMcyW6Or9tbjMLvRcoqmWxvuru7Uifp63Q0WS1IzuTe49feIzPLe2qXmY6xO5UNB55iWgLzO/Puuiwut2/R3iD0SbaE7JjVI1v+UOptPOkkx9rWZk/CUwSMIupZIeu427kZNUWQf3GQ5ntK4gntFPJOryBpLcE79IxFYvyZx/VsFY4XcNcUi6Z9C+tWH2gPc715t5DkK3zwXHqxlw7fNbVompC6FS0nJNMG7etlBVEI4A5RL5MYhViHYKhEnW/PsDBtyh9glz2Np8cL7ALePhCHutXxr8orncykLd2zg+/kEMra96nG9Is/7DJvRL10s8/eQrkDlCYh95rdoQQnB+4w25IFVnw//7ehHLgnDqLi205SlJjsXb1m8fMipnYpjHLCvvFlt348ED+BsacBPvB1ZmcYQDhkvYTa4KmUov9KoGcNVAjT1GyEL
 kzpHIpRi
 wBN5SUKQdNja/zKwtoDWsZvv/GS3Hi2Kr01bx/ojp6lTfl5nB4uYF5urab8KaRY0UQ14ArEDatct0jtHtteKycsMpUBrUdnHPEOipYcqjH6qv0BGJt5WJD5QsTvrTjQG09pa6fBxifbKeAzY62ViIlVULpLl1/9SFMUl9RyMDbb0G9+NkXxIGIy1fn6+a3MneSbOuGRXX1ETbgbCbYxTpYHI6SksqQycjcbmciVpNbiFZe2ReodoBoidjk4xc8gVHRCsQ+9d4i3xG+ApTl7Lfr2EYTzzLBfpt7fVBQp3GIudNaITtmZkiMlQ82jibBavi0KWOHMOa3KKn4/weyXlrSUjTimZiMzR9pDqUi/v3KGrCrFkSknaYFigHXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mas_lockdep_map() is only used internally and without static define,
there is a build warning.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Andrew,

Please apply this fixup to [PATCH 03/18] maple_tree: Add write lock
checking with lockdep sequence numbers

Thanks,
Liam

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1b2713190675d..c25ee19584d17 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1155,7 +1155,7 @@ static inline void mas_free(struct ma_state *mas, struct maple_enode *used)
 
 
 #ifdef CONFIG_LOCKDEP
-struct lockdep_map *mas_lockdep_map(struct ma_state *mas)
+static struct lockdep_map *mas_lockdep_map(struct ma_state *mas)
 {
 	struct maple_tree *mt = mas->tree;
 
-- 
2.47.3


