Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 832C2E7E0D5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66CE6B00A5; Mon,  9 Feb 2026 14:33:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15216B00A6; Mon,  9 Feb 2026 14:33:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4AE66B00A7; Mon,  9 Feb 2026 14:33:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADEDD6B00A5
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:33:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 844061BCC0
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:33:03 +0000 (UTC)
X-FDA: 84425916246.04.A216623
Received: from mail-dy1-f226.google.com (mail-dy1-f226.google.com [74.125.82.226])
	by imf15.hostedemail.com (Postfix) with ESMTP id A99EBA0003
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:33:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=gmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of postmaster@windowsforum.com designates 74.125.82.226 as permitted sender) smtp.mailfrom=postmaster@windowsforum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770665581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=0sq/5z8N2ft1xcm3cuopTwCMdowyLeWdG7JWXwBlvJo=;
	b=3kf96J3WkQjubLm+GF/DghNTwY1OrgZtVoi7eNwWJGzCwnyPEPGq68mUOb+CEM7mLRbn1k
	ElPQa5fICtSDJS4wpRIui0AQ8vvqFFe0ZVOpbRImKwUnn/Yj/jMbegrz4G80K9nmg5hV9T
	51CNthSE8dx+I/RD9hC5xnF6QfH1BJ0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=gmail.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of postmaster@windowsforum.com designates 74.125.82.226 as permitted sender) smtp.mailfrom=postmaster@windowsforum.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770665581; a=rsa-sha256;
	cv=none;
	b=RuieuU4sqApQpqOoATGR+HDWE52Fd+bwxBgFhq+cn5ILc4XAa2BNs9AMcjdelpvD5xMmyN
	A9q/dDXdEYtaq1y6kCurvWyjW0HI1Kdl1Hj6dC7BzzoT0NSYK417BXXTUxeITbaWqJptQP
	i78MM5EiPLTH+HvJScEiovP5ccu7TVY=
Received: by mail-dy1-f226.google.com with SMTP id 5a478bee46e88-2ba76579640so1103154eec.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 11:33:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770665580; x=1771270380;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sq/5z8N2ft1xcm3cuopTwCMdowyLeWdG7JWXwBlvJo=;
        b=wRu8nnEhFQhMfwl0V6ra7iViY5o22vGfzzkOqrg+LyG8HobnfSdPg35+Hxa1nGhtpO
         OzsheRqeyx5+PUNcLpL9HGGUPiYJF7xuYyrq+AQR269ODngRss4MlNsEzpj1UI7fK9p8
         0LKRKcdsAjezg+P+1SPUsI/8m0jXVos7i7ajf8/vXluAsqZnS+AMnx7hVDe6h/La0f67
         6KTPgYuRNJ8hQEGYbCHVyG7T4mcYCcSNveot79Z1vQaoyrfBr4sw3CVWNLeG4g9rIa2p
         K0BHyXEmPnByK5fp0VD1v04U1hxjxoNg4Z3g/ST+bmeukr3jAH/lWeraJuJHGsDarvpq
         lhTA==
X-Gm-Message-State: AOJu0Yy7VgyOVcEBW+wR+yNuYgxy1zWLyhD7MXO7IEeneaZu/RGyNy1P
	5klW9bHDNDcy0/IFpx5suBaCfwsYzCKKeYWre9Vjpzm9kLTzkUOHenVeyfYejqXb7y0STzdAxPT
	thKkTydRtUbmhmtYv2s/9LFELqjZFm1T6eDFh
X-Gm-Gg: AZuq6aI6oKF89tKM4Brq8JrlVPGABlL4u1y5NjPcJHU0iOyTk+n7nDhFpxVtv2LnFjN
	pBQwR/zMyIvuo9ihm8JW2EtKHIyK8pKCBiHngWFX8/StLydBESqErwRc/qG5T4t40cNxPq9jH3c
	tI7k1e4lNI0q04e6yjUTBdvRsMKsSurYNT/cMs06NQVQVOtjijlFmhi0J14hlhfuaafgZgc0R1J
	kzPwt4TnOSJIKO9RiQb2jElFyhZykTl7wQ1bWmIBHv0hj2TM96A2rlJzHFOVr0nu+Iu2xiokrg5
	OU2Tf03R9VEkTHWQAzR6YdSXEg9cWZsIL0juB7I4Hrl5RlZ0BJm0xIO78fMX0pYlDdPuor6Fesh
	70xxwnCCTO9N4IXRGdNVtZuyjQuc=
X-Received: by 2002:a05:7300:fb86:b0:2ba:7a5f:9e5b with SMTP id 5a478bee46e88-2ba7a5fa59bmr845438eec.35.1770665580381;
        Mon, 09 Feb 2026 11:33:00 -0800 (PST)
Received: from windowsforum.com (116.9.196.104.bc.googleusercontent.com. [104.196.9.116])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-2b855c8014fsm1831790eec.7.2026.02.09.11.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 11:33:00 -0800 (PST)
X-Relaying-Domain: windowsforum.com
Received: by windowsforum.com (Postfix, from userid 0)
	id AEB2D2A1C1F; Mon, 09 Feb 2026 19:32:57 +0000 (UTC)
From: Michael Fara <mjfara@gmail.com>
To: senozhatsky@chromium.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	mjfara@gmail.com
Subject: [PATCH] mm/zsmalloc: fix NULL pointer dereference in get_next_zpdesc
Date: Mon,  9 Feb 2026 19:32:57 +0000
Message-ID: <20260209193257.60393-1-mjfara@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A99EBA0003
X-Stat-Signature: c1t6zgdtqq6ao8fhu4f8gyhkomhjygyh
X-Rspam-User: 
X-HE-Tag: 1770665581-873612
X-HE-Meta: U2FsdGVkX1+QBTOnpskapIk+7nxl91DNOt+vOqvOzHkC7S3puypLEQKapFi/s3up4a9btadzSDyBjKvD1KNRQRqeUmtuBAwKvfxpUCRwblFP/NGLXFg2of2QZLt+DInIO8zdQK/BagduvLjCM1n+FY3vxhA44RdqagOoshdz+GTfGqls7wvXTEYFK4r9hgGdvbgzVPBK8yC++mOlWBQPQCwV+Fmd3GOigDA1ROWzVfbygMYCapt8nFYvZpPWCpySmrOcYQhvU9+GDpJr+n5TNh0ZlGcBu7g9e1Z3jX/YeftEHOwKobkcRrcdyu+H+TuSY9rxA+/iUiHJOLlTwq1DAozEyKRrNQZ0M7BLT7mT59bdoL+I6CZ2ZQKsY6kxm9x7iWnXQhYkxMfZ7urvAOM5gqiaju+C5/6THWR4I5wZffuMDq5pdqfLAbvu1DL9qm+IM2DNbqmS7CvGALKMtPoqb9hMSWNs4Z7MZ5Unx/6qLso0tONxem+ZZNJQp4cUE4dLiYU3fmo4mRn3p1mgdo+rv4smmlhPIruplsolYGxxN+EC4Rm9SJLlGYostJml4GVlOK6ISqHOYIKk2IWD5MYSljT7HvkiAAYEbMz5xngbiQCR96F1HYMIl9r4csFji+7hyphY3a9/D8vK55O5qggsbQoXQSHzY/r0ioY7LwLFavBN4iLrm6ugj+rEOcy8n+1M90VQHCIqHU4bhrp2if2XJQjFI/ckw9BN4UQZSbCEKua90mboNa0+32XrkXgGDGG1DP+Mm6H8hI2pekeeFA5dDuvrixHbIEMi0TcDSeu1Rj6K+8vtxKPXiPjBIRhs/TDYUQFCgmMk1trsNvJP3LPHvYnVown/zkODmtMzFbhOhZnRusNkjccysXTDBQ9YGJdhiYnbmAsulws0f0IFTyQHgybXv17QY1EVGWD/uJw6rGiWknYzoCnExeJkxn0oatg2vKZBS6wsXrChXyEW9al
 1/LYcAHn
 Wb1ikCaDAhqvBMfjmi0Z5DAzqx8BniVoXEOum3by6dUD+XbSaNmuRZqvaG5g4WylECjQkjqxvMEH6DIOChO5gn3/nhq4DidMrwxkn8ECbAEtpEoIejWHuBQr7khz4ipAtJVKKyuuFCzkaIkSsRdQiI9cl4YM6fi2j+u9XkbyYkqK7itD4AtUAdrjI9YDDISky/DqdtfklIQCTYeU/T1l7mt9pJYUlhZKkD/TmW9nqyhwZF5qM7y/HUgci3Uupyo7smqVz699VqExdo0p9VIC32cZt+hGk9C3wvDJU2qQKwbDXTkE/OBT0yU4au6NSHoyIDdMQtoYqoHNW/R/z76xakfOZpK6da61xV5EnC0r/gmLWlbY8G8KxRyKLEB35/wu5baGeGwr6EK29jiDm2QeP7GDekarwVHNvobb8dlbrKhWKsyQQIjHL8afSzsE67aE6lx6Mym3p/xy99Kja27tvGZrHs+hT9xL67QBzNoc0qPTWvlbsc41OSZF03VcWdT27Ov0apggEYpgTMLyfKoTqVqXU1BDB7BikAdEAq4ohAEFv/4j1MofFRNeV46ocKHOGKxTHhc1isx+KUNCHRYGi/63d43a4MzQsfW13e0Ab8+pLSw8Sd6njXqAIP2qkJ7THQwSQ
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

