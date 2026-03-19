Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE4C0109190D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 167C46B009B; Thu, 19 Mar 2026 14:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13E696B009E; Thu, 19 Mar 2026 14:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02CE66B009F; Thu, 19 Mar 2026 14:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2B5A6B009B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:31:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90D6A1B8418
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:31:32 +0000 (UTC)
X-FDA: 84563655624.02.A8707B5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 498711C000F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:31:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MkMaqk2K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OoND9t8j;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MkMaqk2K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OoND9t8j;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773945090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7+HaQn1tFTlja+mVBj2e/YdRVEWULIlPF/DzJbJkoU=;
	b=CiL1ci8OUokerhKCNgPiNjDZChbuyMbjOjxrAfgvgCWrZYUcICF86H559/sAXv6K8C81Qn
	dyfKo1yUVkzJGkD6+wY2xt7xV4r6rKM1cPJtlM62grevN8LvXilSyr3pgbSDQmpiZIlgYk
	wMWxPdZsOorK/ODoKbqxuhPduSTdaKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773945090; a=rsa-sha256;
	cv=none;
	b=Xhe5ptw5OWxmB23rbsy83j9tmV+QPPm8RXnHjfMrvSUFhZ0fBOC58IpKzut26hfQkLuWFn
	tI3F2/q/j4EdTKCs3+sOqBays8N3yUZDThFHyR9cz2WhIl19TaCbnFQ4J2e6B1KRxD5C38
	BdPpWdpUW1zD1rf0+V3831ao/NLr1IQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MkMaqk2K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OoND9t8j;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MkMaqk2K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OoND9t8j;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D3A534D214;
	Thu, 19 Mar 2026 18:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773945086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f7+HaQn1tFTlja+mVBj2e/YdRVEWULIlPF/DzJbJkoU=;
	b=MkMaqk2KTqR8SvmqBvG9RUGNCDkYTKiMQOfjr0/hHXbKyyzmarFzba+oTmNtzfU3vbH7Yb
	EAvlTi2UF8UqYrwf7cUZmvRmJDvUZJ8JA3DLy9yUfr8X7+OiVkTR/8iR0KamG9BHSlEqV/
	jGY5C2crNdpW4i3qKkbYoXAXMSipEbk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773945086;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f7+HaQn1tFTlja+mVBj2e/YdRVEWULIlPF/DzJbJkoU=;
	b=OoND9t8jg6pUIN9evDAux+9Q/DfaX6M3v2neguvPFSmQiGQHLbxW/U9fDlH+jPxBNmOnlo
	LDpJ+YtaRhfDp7AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773945086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f7+HaQn1tFTlja+mVBj2e/YdRVEWULIlPF/DzJbJkoU=;
	b=MkMaqk2KTqR8SvmqBvG9RUGNCDkYTKiMQOfjr0/hHXbKyyzmarFzba+oTmNtzfU3vbH7Yb
	EAvlTi2UF8UqYrwf7cUZmvRmJDvUZJ8JA3DLy9yUfr8X7+OiVkTR/8iR0KamG9BHSlEqV/
	jGY5C2crNdpW4i3qKkbYoXAXMSipEbk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773945086;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f7+HaQn1tFTlja+mVBj2e/YdRVEWULIlPF/DzJbJkoU=;
	b=OoND9t8jg6pUIN9evDAux+9Q/DfaX6M3v2neguvPFSmQiGQHLbxW/U9fDlH+jPxBNmOnlo
	LDpJ+YtaRhfDp7AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 041D54273B;
	Thu, 19 Mar 2026 18:31:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2PsGOf1AvGmbdgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 19 Mar 2026 18:31:25 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Luke Yang <luyang@redhat.com>,
	jhladky@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] mm/mprotect: special-case small folios when applying write permissions
Date: Thu, 19 Mar 2026 18:31:08 +0000
Message-ID: <20260319183108.1105090-5-pfalcato@suse.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319183108.1105090-1-pfalcato@suse.de>
References: <20260319183108.1105090-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 498711C000F
X-Stat-Signature: ynbp4whboaebqp36k6kea53d9d8h9zbz
X-Rspam-User: 
X-HE-Tag: 1773945090-623881
X-HE-Meta: U2FsdGVkX18X0Sqf5ePkVGFKzuAdPn44hijqQcNdGnf/0aWmg/dpsu5iQsG3s8LHeXsOdRlQ+uPS4cnQPw1LNB8Ws1ir7h7zdCuDsJGUtlT90n2+1rteOZg8LHqIwUi1KldZr70b+H8m7hWdlWVrlGUGMORHXYMaM/LJBQFMHuxW7fYn5HldYfZwxhScEoDmlmy+m8v18jKA7Kh3t1VS7cLT0Emcm1OQZcrHuhXSD8fU3F3QpDmbtJ3dn9fZMvaLvL08mVaz1UqbNKTVK2uv3veifNPCeHCHJFXqUfnolHj9jCHSzh+gZVVyqokQJsxZaO/SDObw4Cv59XBDPjhPpNUvIMnNRGMj0lzY/rtFaz5WZuukDjkArvmSi1p9b0uNe9UqhAa6fp6OvC74IouAunPl7MNwi1H3bgI/oyYAvcPUiSL8uC+Bl6E6MHGe0EJrbJD/2SAfyEJtUUq7OFV+gSP6ezGGcCQSB9wotCycLW26FxQOmB7I62gxJRHOf/aspGbrXtDxYpkOxAoyQgRd2KPdQPiv4eEiJHg29esrXlp36DZyToe45srn0ATLT2UbrCY8y0WYWv9YqPKyFI6Hcu7sjjtYDe22f7T5EOYM4wbX8rwDURqMIKoxvH0CtWc6gyf7Voz/N6MCDsHxPkbczfCCdQ+q78AKWMIazr/D2H56KVnl5BWJ5L/JDKdF+FuJztJgAecVqIYpiC62fuLqOX/WWnecBGxvrzZBGclaS1QsuDIx8Xps6IjeOU8B5IzOSWVi52wwx2n1KSl8aAqcgbZ5+trcW9b/owj0uqaq8TFN3l+KtXIXZg2+kxnt3yIvxVZXEjodvkY3Sfr6F2H1m3kRY3LDWlDvKgYVj/NJn26Iiu+4cv4aXkxyLOyAxx436dgg34n+BTQrsK5h4thUlpOBT8tC2tVD23awdWBcsj2RVdjRVsEBI28aMcR85L7ufPHyNLil3Lz+h9+A2xj
 g76i5N8I
 GdL5J8VO/+H59NFhm0pQ81krfxJR3ojKrIGLNSJX3w21B9hAmw0ZWoc9XMyIkjn+C0VHFn1pA4GmcrrxLmUN7ZSOrI+BYA35oy7TgUzpzIKpaeCzrC3C5UaOgQLay9WTyH1I18iHc4uSSWQTJ4mLO7N8uBUP5vFLzSuzn88/Bgh/o3wcqhFsjJQa4hYzom8G3fuMzEUcVIQsl3p2Lt8fnhWHvNp1wFdSufKl7BXiiPyLP8We/ShMXgWl6+pfNeMFdYEx/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The common order-0 case is important enough to want its own branch, and
avoids the hairy, large loop logic that the CPU does not seem to handle
particularly well.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/mprotect.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index aa845f5bf14d..23a741f9a4c8 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -170,6 +170,13 @@ static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
 	int sub_batch_idx = 0;
 	int len;
 
+	/* Optimize for the common order-0 case. */
+	if (likely(nr_ptes == 1)) {
+		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, 1,
+				       0, PageAnonExclusive(first_page), tlb);
+		return;
+	}
+
 	while (nr_ptes) {
 		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
 		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
-- 
2.53.0


