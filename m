Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B3C8CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8216B0096; Thu, 15 Oct 2026 10:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A90C6B0098; Thu, 15 Oct 2026 10:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8713C6B0099; Thu, 15 Oct 2026 10:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC606B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:45:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE959140A24
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:45:52 +0000 (UTC)
X-FDA: 85325134944.05.A7206D3
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf15.hostedemail.com (Postfix) with ESMTP id 60752A000E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:45:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=Kq6P2IHx;
	spf=pass (imf15.hostedemail.com: domain of "prvs=741bae1ce=fparola@amazon.de" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=741bae1ce=fparola@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792075550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T8axlsfso4k7syKxUcvyIg6Ym9y5kFkDYTWkZAR8ayk=;
	b=qQ8OoQELvV6NOew//ryYxzYWVM4v4zJyUPVjr9GZVcTyMM3mF3bq5rZiConUkVVRyAQ/LH
	GMq/PuUoou/wZof7EYseb1hu/Ong5yEjkqQpX+FJfIUITCOcZGLv5Qw7AZaSr6XMF77eg0
	rnJsqdjhGCnFuy37yrWQR1n9akmeLAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792075550;
	b=Srw3Xe7gJAZQKMqslEhhI6Msl4HR6k6C8fjYa6En3wmIGqLKx7Ma/XSSe2yo1aRrjnsISN
	+4/WYo7rjZ/tVuB/ZsQH/z1umixDPXeqlSc0OEM9q4+qp8BIP19msN2qmjWWfRgv2UTPj3
	TzctyL59s2rrsN4jtRLx80za61+Duno=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=Kq6P2IHx;
	spf=pass (imf15.hostedemail.com: domain of "prvs=741bae1ce=fparola@amazon.de" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=741bae1ce=fparola@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1792075550; x=1823611550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T8axlsfso4k7syKxUcvyIg6Ym9y5kFkDYTWkZAR8ayk=;
  b=Kq6P2IHx2qEWa6ykFXb/yITViCzJbDaq7IXYTXZOe7+8iZreIwHoAoDg
   gLOH1U2EOY4Qqj202bKKTRAJVFFbpIS9Gn5ik9PJUAY/bbAmprfOzgodu
   SEw85+o1FYYnvl6vT+uDymVf9E4qKgTUW0QAR0qf7/PiSk4Xj9e40F8zv
   3QUVZ57WAs8u8TlyxzU7yJRBf5DmoY6Vy0gBLwmQRkuon4yTBWKyLRQXT
   rxFFYW911LBKrIxwVf58DdQjsefDcNVE7Siqg5cyoLJfyrUOkdNYBDr5p
   lmX5UK+oVrlcm85eSCTST/9ukNxlgLmYdOzDhN9/mQ6e/tJc/hA8q84p+
   Q==;
X-CSE-ConnectionGUID: opeVRcGqQHGuOktxkplgOg==
X-CSE-MsgGUID: aF+8dlOhT5+24Ki2k86dnw==
X-IronPort-AV: E=Sophos;i="6.27,160,1787011200"; 
   d="scan'208";a="31124997"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 14:45:46 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:18197]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.19.38:2525] with esmtp (Farcaster)
 id f94577a4-6cf0-4788-b26f-4e1b3530fd63; Thu, 15 Oct 2026 14:45:46 +0000 (UTC)
X-Farcaster-Flow-ID: f94577a4-6cf0-4788-b26f-4e1b3530fd63
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 15 Oct 2026 14:45:44 +0000
Received: from dev-dsk-fparola-1b-85ea2014.eu-west-1.amazon.com
 (10.13.236.104) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.53; Thu, 15 Oct 2026
 14:45:43 +0000
From: Federico Parola <fparola@amazon.de>
To: <stable@vger.kernel.org>
CC: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<nh-open-source@amazon.com>
Subject: [PATCH 6.18.y 1/2] kho: free chunks using free_page() instead of kfree()
Date: Thu, 15 Oct 2026 14:45:28 +0000
Message-ID: <20261015144529.76911-2-fparola@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261015144529.76911-1-fparola@amazon.de>
References: <20261015144529.76911-1-fparola@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.236.104]
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 60752A000E
X-Stat-Signature: 7k4xt8si5417qaprdpn8msa6y747d8eu
X-HE-Tag: 1792075550-345337
X-HE-Meta: U2FsdGVkX1+gocrikPuQe1vpby5BhUCNgX7dPwr1WpWMxQyENaphclqIxnGf0X9Wg5wCmoCXoEQqr5Qi+7HdqRt7JZQ5m8x9DanmoeurtsCTnAjbj89+Rizo+/olVelOUiSxKp3MZFwIes87XySCvXJn9hRJ64Ck1wJvC1X8jBRGpw51o00FaTKzmVXio9NWvt7mf5w8xbQujr++mtsKJzPm7tuy/mFZQw6jXLGC3+EhMTUG8qmE6GkfW+HIVICKsgsSdwXEvJVLWJUQHYjq9+nRv2d9c871+WQ6JXFP41sKZ5OSjPzPtp8Y1OFxHHmUEyPKarW7GtHutz30KkN5qsi3iZzqKJm4fJehmCr2byIiTCJWox64/2kQOAT+kgq9cfIDIApWLanjF1N578IkPqO7EaHFXLYQ9Lm0XtxM18asq5k0DS1+UHPbtlURXUq8nFWm03tn1a+Kf2Mi6Ap9qmvInAOmK7HvinaLnhdNlCKwVc8tNOulHlJRqRMRdslc03QGNHa4xW49WK3zA2CledS7qPU1pl9pgkRUV3Xh3f2ly2qOySWjNJjahpL3yuSmMHxdHwmvb3cNaI1SmcYgbVfv30aOpdFZwt6fNm0ZFOouVU7HGidkXe63Rp3bEOCDsjAJ4SUbr8BkQl7g6ZLqzJSEN288VVLmEIvqaR4E5ojmqZjIwB5+Ipk1QAeAYVitM14sS4nzscT/60crX8lsQBUW81kY/PzuZN13nAU0oGmDy+fyiGw3CcWlMIXdBkwmggsFaFEYIchVWPp5+kNEZQ74MtjzmaQBUOqsDHbu5pjy0dVED/Ga9jSiOIXoy4Ryzxru3QomUIUdp5sPOYrILFUBi/+jEOIML26qGo/GqiLq81VcjQY2q6riVU37p+2ii5187Aiyt15q3AMFhs0FfZpmsc8TR7jmUQsPk7oNopgGLDooI+DbNPb7YrWobn4juQyQ6AZa3v0In+U+vBK
 tUyVKzkf
 YBymiJb7y3qUrmSN3Y6ri5LJ20LH/0dDhyu5YTjvfSJ6J+2+lsHSDtAtxLsWLoBk7r4ucjYzwu4tfdlfFzrMDMv6ys1YU64dtzQMx0Rw37GAntIV0cjJDvLXRtrtDQgFvZWEvY3viJHlyZaoKZa7pqXjTIeqG1+NJgDViKjqt1sAwS/eemVXvB3pLPMtM7J9bF37pxJb6foij64kQYHhIq9fQNKdRFhQ8jxaZdrnjT6ojfKpfD/OXDuwazJvK6x0EeOKCM8Y0UPJbZHWxb+adtcnOHAj/f9iej4ITJ2P0H/Y1Ry9or7k0MnFu3jNYhi5kqmxUhympTkAY/igPmFfHOHTIYBXojnEmwsWCqxP3KEARr4WMVoNhnuI3w62l4mY56+3YshfNzYQbWMqWxHg120ATB8pi1jQMsxB4chEXmUhrY8JC8pvfvYZOM25cu3JmVMV6lMh6+ud4an/HRx2ifVhA9bGh+J2qvU01jS2KRF9H3Oc7lPSDInQbrZa88uCMMpxmZTckZ00KUoo4iAFjL7mySVhpevPWHmHE4nj5kjQeSlWRPSgoU+MgNLWJQIdts9tIJet8WH8dWDSvSJDvzWSpMTLQVqSooKZjDAXHrllruBy6/N8+KH22E2mBODCi4Pf3CmldpL+veYFKgPNLBnN0kaClypWXuYpsIrHNRDHnsbIeFytwpPJq6iokQcu7tkQzXLazfEMkEK9d7aGjei9L/lK8mUuJESs6jC4QvC7sv0eJA9hYzT4EVu6TuyLDkK69KgHzgr/rEzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <pratyush@kernel.org>

[ Upstream commit b15515155af735a86e5bcd67ed739162f0de27f5 ]

Before commit fa759cd75bce5 ("kho: allocate metadata directly from the
buddy allocator"), the chunks were allocated from the slab allocator using
kzalloc().  Those were rightly freed using kfree().

When the commit switched to using the buddy allocator directly, it missed
updating kho_mem_ser_free() to use free_page() instead of kfree().

Link: https://lkml.kernel.org/r/20251118182218.63044-1-pratyush@kernel.org
Fixes: fa759cd75bce5 ("kho: allocate metadata directly from the buddy allocator")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Federico Parola <fparola@amazon.de>
---
 kernel/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index ac9fa7727b5ff..9fe5d14f1ec54 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -365,7 +365,7 @@ static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
 		struct khoser_mem_chunk *tmp = chunk;
 
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		kfree(tmp);
+		free_page((unsigned long)tmp);
 	}
 }
 
-- 
2.47.3


