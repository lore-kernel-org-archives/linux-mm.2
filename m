Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B973CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 167028E013A; Tue, 14 Oct 2025 10:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2598E010A; Tue, 14 Oct 2025 10:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB148E013A; Tue, 14 Oct 2025 10:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0AD68E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:50:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92C7D14099A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:50:17 +0000 (UTC)
X-FDA: 83997005274.21.4166581
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id B355310000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:50:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gPhOUMDg;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760453415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4PWcq4M+uwGRj6srPkRX14QChgWCsKUHbcguMBrius=;
	b=KI1CphC2eqAJ3ZXe9/N0zJC67UZmRmdv4lWU8oNfDEsI9ILpVlAuftHTQUOiUXghj4dM8O
	XiVZi+GVB8rB+8kCbS9Y25BL97TMXfX8oO9Fab73vQMeMpEOA43z2OW7xLcQDrTXqRrZtz
	ZyZxN1tHLd1SF6LEKU9he7hUr3HHcdc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gPhOUMDg;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760453415; a=rsa-sha256;
	cv=none;
	b=sfmn35FUzyZ4Z2JNO5WW6O4szTdWuetgmbKcOndlPES60LDBNxmVa89SNSeeQMAbtGriur
	lHNQxqep9NgHU0c4D3V5hp3T/NPFpPRn+H5rC27gXfZvx7kb0c34OuUBs+yT6XIXAU+Sed
	zRwKTuKg5ttALAIyOi6OR27J7s/S14c=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-63bc1aeb427so5549369d50.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760453415; x=1761058215; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4PWcq4M+uwGRj6srPkRX14QChgWCsKUHbcguMBrius=;
        b=gPhOUMDgbTl1oppv4nosX21N/C+rVfnSI6w+yQbCZ6AFl6JVgaKiVQJgpdvf/TTP7u
         fORmefS/kDocUQiRwVTtg0M4eUJppWKAbWqXfkXFobfUqDoMgPVTfnvrg4bTxZZKdhiP
         RHvdl097OrqMlQWKefjhlYW1ChpyfcUJBAJIeMoSfkoV6uyZ63VwY08NyfM1vNK0v5lT
         EvTS5sUqZUp/bwyvYgzZdr9vTl5vp1s7eEJl8Z6jKdSnlq/i+YIgkR6DIIFSDOvoyNMI
         9tDKeRbmVpC7jcT00fKrKEAGw9R6vGoFtxzBTU1Il4zFTPPXuCdp47guUOReiWKeDeLI
         1Frw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760453415; x=1761058215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G4PWcq4M+uwGRj6srPkRX14QChgWCsKUHbcguMBrius=;
        b=qPjop87QhbN2zZ5aF/nZMI/xi5zIjfyImy254IfulzL7Z8QD4+exFS4p92ii9zaJuV
         d8iR3auQvIK7NXwwCEenbOH9AFp6vLwDwocxoO+bMUvvBz4sTKC/mIRdXc3pGAZ3Ka4U
         nZRCEaULfyvDCVNWXTPSxw6HlfoswVWgVsEUdgjCKYceTUyJeyqdnH7UJEBXG6zhUkLj
         ex5TrI4dhY5JTPJNQUiau0NjlW/cO4OMpaGMUCtl3a+4zlTq+KH+6ies55FjwtY7MfM5
         5LUEePYu4mEAKQ29c8U3XkKcsZ2LYSKweUpvfNt3yvb+lo0IM0xq7EBhcxF53oAEtsqm
         v30w==
X-Forwarded-Encrypted: i=1; AJvYcCXsAIXK/DZqGfxuo5W6mauI3si8q21kWHplcnjy+SIsYaGKv50y/2G+c/OyLNqYXmSxPEWbQkeXBA==@kvack.org
X-Gm-Message-State: AOJu0Yxfn7bgxfo5OyDHPuo6ZlFyIf2kSRJAvlILkawaLCd6+UGllOgl
	NYA5RxStTpvF5N1+fDeBU9S9ryAEkucOnPZMo6V3rnlSD22YIOIpoyy+
X-Gm-Gg: ASbGncvFNWLx0/f8SNXWmsaGpB3u7Wuqfpr/7YARHpIAG/tIK33FIA3CvAaqrUO+9D0
	IKkzqnz+eZAbU/OY8kWHxBgxXRRg4mClovSH/53eswf9YpN6668Dt2FQJAXbUW/fMrer+uMmd84
	fQnFJer/kgbHuG9PJuLJd6xxNGpQdx5T9qOOJErrmsMKO3FRYYGrxosyl7fUaTXl5HcC15Nvpl8
	filhq/PNpx3pj8lA/239cqZMXdc4XwL/Ank75Ur88yLx0+rWklacSolMhfc0N6JiWkQvUyhcTaf
	sVWsITP36GQ8y8lXVbloMPmzf60dJFwgZ97zrBeAALkPrXwL5C+JgsRueHXqcbkXh3X6uWslnt7
	Ak9Mvpjw/KvQgwdfqLdJJKIdx+RIwisXBQd4isNoChbGbs5erI2Kr2x8NAAKndRvJ1wrXmV4tqX
	XVO+URKHYLAh8YKwsT9Q==
X-Google-Smtp-Source: AGHT+IHvXFVB71mxsQWd49tPQxNk+oc1NWjBVBlPVRmPisF0KBHXyTAe+jCzazw9vyGeZFp4wLQqaw==
X-Received: by 2002:a53:bf05:0:b0:63b:8e0b:fc9e with SMTP id 956f58d0204a3-63ccb8dc10dmr17448464d50.25.1760453414759;
        Tue, 14 Oct 2025 07:50:14 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-781072f75c4sm33746987b3.64.2025.10.14.07.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 07:50:14 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v5 2/3] mm/page_alloc: Batch page freeing in decay_pcp_high
Date: Tue, 14 Oct 2025 07:50:09 -0700
Message-ID: <20251014145011.3427205-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251014145011.3427205-1-joshua.hahnjy@gmail.com>
References: <20251014145011.3427205-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B355310000C
X-Stat-Signature: zq37ckpc1j1e7u1ezc4p6sy4x7667hxj
X-Rspam-User: 
X-HE-Tag: 1760453415-826039
X-HE-Meta: U2FsdGVkX18fWKqjJxkDWG4RatxSPDDYDKSdbHhymjntU2rdgjU7BcHf1a1AyPA7mHZiGIOpBooep/oTKrVJIWTuUf8rq7xaPiyOKeNXcbX7in9UZopUguwn/HfNiG+0UFedZIV2zy52T9oA1AbvnGp/bOhTpSUUL2Faak3XaxAckCcPfYbm79ZjH7qJ34Vz2lvdUxCbu6/MaRCewKiic2ozBbJjqlUfu+FALzaZstN1Vn9mnfCNc1VKcOoc1TOw+HoRIy+XugNTIP8mLaRinnjpd8A0fhKpJ/HCSAoqHYaNZBJuwhPqIqWOQMZQ7f+4afnWrpTJJ7IsQWkzZQFiqQ3Qu8aURk51jky6Mjglg6U8a062guPliUTuHMD8761aqKl/PB+CeA6NWKkZvX2K0hn2pPXzdqjm9F/mBFao069Jk5j+swdXTJtpk5MxOeYf7ncy445l72cMVNIrX5RbBriXgHVxNrsU62bxWcgeIICiXCWm/5c/c0gDlka6qaE5mYWLWBBdZxPVyqvCHDiDwA2cXnOjcmnxcqx4+zT/t7/czazuchb0dSP7w/HS75TkVPbmRL9BonUjVudhKlynVVZTYA9GDt6ZJXVC5H2DSfbfzyaK96LBFmnhBdtvOdjR42xIcbOC0qmTXhW2APchNVwdrqFn3tXBubIlVVw9K1xRq6BT+OgNoSzdtua8flLO24Ano/53YSaeCBS29Xr1mI2t3h8/8Rmt7QtFqwsy62kmYtv8OKdPXKyFyLUU5JljAAohgLcYpkcVU43FH7bCsx9J6dogzHvnTQ7KyQ91G80N7IitveKVV46bcoZWvKmrE1L0QKrHKxECoyWfK8SoRn3H2p/Uy+6DFhsdXaBxZl/v3d0i/KXIjBXDXfZ2CD0RaJo53aaeIonYH7+XgugmOHvfnyXWgBS09xZgzNA3rW1YqK5RI8AAJsISm3c9snmfIoyZw+lhFWwKuDmijN1
 FACIqXbR
 0X0n4r216EA/byxQ2OEB5VOOEiT2UDmd67s0s9QiNrXBt9IXUz715SKEeEOCJcQeL1yh1hAfteSeS/2/FrL2N2twSJptYDxyLhTEmQ9wZ39TchXpAyfbx9UH+8O4+SNgBAQ9qFivqoocK1RtU6RS0NdydITvJ9Z4Z7CeVw+bUHhEhzc5MsYCCRiTunEeeSUPKmBv4VOMj7nuxrnr2npeDsQJyXFt7wt8Nf2hqgh+2pUeFO5NVx3Lg1dE3+Y6prqUz7XWOQH0nQQbR5R1N5g0BdWHFHtA18TADeqDYrGRz17u10KY1CAquewrLukN49r4bATBqlawS5+RYHH/9pMhKb/qaxw86mBe9po6zVOuNGU0W07Yb92x/aZw+ApJCvWclYgIunTRgDCspot9sNwobNGqnj+x3t+HhV9hUNWqFq8XLSC/L28iGHb1Tk7fdY8ACGYiTorTHWF6kSCNSVautkaWJ9JIzLxqcdvrwns2WekcuFrJ5uCG6LutLejp07oM3rWASIo8kkpXm1i7kpu+WITQqQ88acOQGx79pFOKSaTtdDu3g9dfhUm/Z5i9KrSmhFrOx0dkeRLKop+b7cABPCtWbEl5pNiLufTEWXL5SotsJjRMe6oSeuOgigvj2JtW0N2HZ8Ktj99pVr5SMGG0HGn2zghJRr2dVJA63DWkCqd06NSi5a9ajNLMfXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible for pcp->count - pcp->high to exceed pcp->batch by a lot.
When this happens, we should perform batching to ensure that
free_pcppages_bulk isn't called with too many pages to free at once and
starve out other threads that need the pcp or zone lock.

Since we are still only freeing the difference between the initial
pcp->count and pcp->high values, there should be no change to how many
pages are freed.

Suggested-by: Chris Mason <clm@fb.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bbc3282fdffc..8ecd48be8bdd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2559,7 +2559,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
  */
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	int high_min, to_drain, batch;
+	int high_min, to_drain, to_drain_batched, batch;
 	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2577,11 +2577,14 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	}
 
 	to_drain = pcp->count - pcp->high;
-	if (to_drain > 0) {
+	while (to_drain > 0) {
+		to_drain_batched = min(to_drain, batch);
 		spin_lock(&pcp->lock);
-		free_pcppages_bulk(zone, to_drain, pcp, 0);
+		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
 		spin_unlock(&pcp->lock);
 		todo = true;
+
+		to_drain -= to_drain_batched;
 	}
 
 	return todo;
-- 
2.47.3

