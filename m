Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14BB7CD4F3D
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 21:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2D76B0088; Sat, 16 May 2026 17:04:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA806B008C; Sat, 16 May 2026 17:04:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0546B0092; Sat, 16 May 2026 17:04:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 411FD6B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:04:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6EEFC1BA1
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:04:06 +0000 (UTC)
X-FDA: 84774510492.02.59972BF
Received: from mail-yw1-f196.google.com (mail-yw1-f196.google.com [209.85.128.196])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1E083A0009
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:04:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bd7TLABI;
	spf=pass (imf25.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.196 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778965445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHb6DjRXqj9xDQrypI0jK8ctMTDK6O2uioTTtx6jNrM=;
	b=KfajPmkROQZMSIkCBBSnFq+D9IEJF9EszgN88kp1JTrSvmqbn6rgDdBQHxfTBL1mMLObBi
	AEROLnuqWZ8dRCymiMoqhzFg+PeZ0Ptnmj1o+iYpgmQBTHt7a8IdsaY3mORraNKXi0EtsR
	sWdQt2NmW7kTMyZBK32aQMHY04Tw4qs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bd7TLABI;
	spf=pass (imf25.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.196 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778965445; a=rsa-sha256;
	cv=none;
	b=6su4lE6S0h5r9iS6IsNCeSJvPeimnupxHsbmpccOushKFaxZq9FpQLXVbUs1UpnFsezBER
	v7ehb5fGEukom11hlKEcyN5bY+6OSVTr+Ek1xb1Hjfo/+FuFrQ4vVl6KXywJOHnyEQyYe5
	sRnPdYyKK2+K5Dwz69n+mqaTvWeKmA4=
Received: by mail-yw1-f196.google.com with SMTP id 00721157ae682-7b37d84a6b3so4609957b3.2
        for <linux-mm@kvack.org>; Sat, 16 May 2026 14:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778965444; x=1779570244; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHb6DjRXqj9xDQrypI0jK8ctMTDK6O2uioTTtx6jNrM=;
        b=bd7TLABIurjbFxCySB0B5Ojn18Eow9r398/FU8zYL6GwY6+zevkplqVbY47BeYntF6
         ZqmanLrDYiBpHdYONuIVA1Pglp6i2vRs5C1qI8Bmdt59Mv/22WOoqPfCv+QpAw4/1UUv
         VzRrUo/+zZvyvtBTXoyDiCSysnG/xDj+HtoUXxGN6mhCf/r0B9J3mAYlWDO3+oCnVlVY
         H0jqCsqN/Gzq0fDuXkpomU/iNfObPEGjxJeyCwjQWjpMmOZd/99/dNL04ikk5QQhZLK7
         IqfpxTxvaZO5n0oiVMGp9ARLwNSQMB5PCu1l5nKZeuqik1JyDn1bcBaoT7fgkG6zsWAF
         biDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778965444; x=1779570244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BHb6DjRXqj9xDQrypI0jK8ctMTDK6O2uioTTtx6jNrM=;
        b=NYbMHuaF5eEmqtj7hXY0Ct6wJRGjucyPFtQEfESLhhmxabdTooovrRHkr9OOd35Mrw
         2wnPFCbnrNElo+zZFpXqMdOBN3QmaaGSNXGRncsZWrwb84zvaYklG6XCDFSPBBk7XPe/
         COxHcAP8930WKaH/af3FWU+qq16OhYVw53sghCfOKikBtRMCu8UYeWs5Gm1cVFc0bB9f
         1q7np/FDHubRGbxbmeuPa3kKSZZV50VfIkLiK4qpj1flejHy+PnglUhofplyGnaMaH4z
         aS/wcFRPEhn4PVMQwy+n5b/L+0zGXo3SZdLuhesQjC5DsdDyjK84NS8sqfWdlRy62O0O
         U1QA==
X-Forwarded-Encrypted: i=1; AFNElJ9ER1AeaxAStr9l6syIiESroHW3cYTCyiXCLmkxYbhH9rLKfZbovfjygSpzQQHmh4W1QaywcwV8Jw==@kvack.org
X-Gm-Message-State: AOJu0Yw9/JVbR9JrF4LOhOF8MsT2fkacXziYJMgNr2GiXtHv4IO+S2kw
	IdIRYSM8LXQu/MrGn5qLrEu8RAeMIYW0tLs8FZLfq8LjMSKi0LjHW2M=
X-Gm-Gg: Acq92OG/ZfUKkqTRmg/FvMmpzvtNQeEOgtH6Vvt8dxA158j7+PwJJj3YLjf6jrfHi9j
	0+Q8kx3+kr8WqDF5dNtPRtS6YsPTTj+XOFfwWJTN/H69XghSwtQ98zoVMQJY2xmOjiGjfchj2S2
	0DKSYNPQOvWdle2BcZkp2GnqM8LnuQDECwKqH44IwfzHz7aRzoeIKWBLls32kELi9xgsBCPGGdv
	+ULxF/p8vCi4AaI9ovn595jvDNZBGHXL5LxIb7wJXHeu1zBdye0dNNgLsBwwPFKJSoHVzdlaoPD
	N1ENSTuZBJDd90eFAUby05aqEkR+aYde3gGm9iS+i+e/csOxNfCiE/bJ3MGLkRsgUwKG64K2RVE
	8zj/mHz4Osgdtd+WOGIHstIe7so4jNRYDPK+9KQ/pIypCyLdIogrLTL1w3c201mxldQYR6FiYYO
	xF8j3xjujBL5tKc4V2eaQTAGZUbjUdaTx7MYhew++K0675Abj/4UfEzcWis5WYIibKBq9iZiVID
	A==
X-Received: by 2002:a05:690c:c4fa:b0:7b8:1b67:2571 with SMTP id 00721157ae682-7c95d1da54fmr102587527b3.42.1778965444167;
        Sat, 16 May 2026 14:04:04 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f54c29ddsm48585327b3.34.2026.05.16.14.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 14:04:03 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com
Subject: [RFC PATCH 1/5] mm/damon/core: fix nr_accesses_bp underflow in damon_moving_sum
Date: Sat, 16 May 2026 14:03:53 -0700
Message-ID: <20260516210357.2247-2-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516210357.2247-1-ravis.opensrc@gmail.com>
References: <20260516210357.2247-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E083A0009
X-Rspamd-Server: rspam06
X-Stat-Signature: d3df99ti8ac49etfjwnhntpadgix9fxu
X-HE-Tag: 1778965444-409934
X-HE-Meta: U2FsdGVkX18P5rAtj2vBnB3KaIb00OivyQEieGH8k8f1uLsFLYU9UGEUw2H774laTGP0v6TaYc6FsyPCKh2aG4VlGdA3vY0fmZz55Wu0kbrlVmgWI2NXtZ1CYDrfUdoX7wqGy+iP7eUZZeEGIYQbDCc4PzKCAG+n5NmAalsKy+JuPQjb2tA/LdkcTmTQKHBJBjumoPIfsn0Zr3QMwThKng76pqSZtXv9sazg4Uzh8n7IR14MuWB3S9T/XVxVGMkisevXfGiLmpJMWPzsgszGaWRSgQ3tSfIrpteXhFS0lVk6Y/aCSACvDQDSMnWDKSFPqAfdtkxtEEuHHRIcnQcqB4yJ9Z6sOB6jeB2lwLG/C0URpvZLcccfFpaXs+6L4jjumhE1D9M1DwJcHaUbbLnVSBACrLAtijJjEG8iZekZTsIQyqh/wiALXdOkd9snhPtjRtpvHzfsxbBFF6/+mXatufUs0SlKE4evnNSkenDYvW3um/mVZ1ujKgDO/PL697GvkqIw5jP97XzxOtopoB8VI6T2++ZRl9Tf0skk+KbriG/9aVIXYizXVSrmkgnCdrxGJGCx3sXsQ+n+FC4QnYxpzWifBoXkVoyRUvsa72rYZ4o9+7k1vD5P2QRfeG8eoml3wtiVFvjB7NFbquLbQC1yH9RlwbhZBIJSZ5eB7wbnfgqdfwwMDpmZ7u/6qiu0ua30d/VuVdqoSoLHYIllMo26CT0j03EOGFfrynkegAr3D4iSCRcztfdfTXQQwqR8WoJGB4lcokVytKqTB99IGzSeS1lF43YEPoi6HdNSp3y+wfIHK+88KZ8uS+H1ea+rA28vsakF3KlF39YjDj5xIyzxqhDmRFLxqzSIOd8oxdvGb4mWi68MJgbgTRzMXdwOKB2Ku8/K+Gy3uZTp7ShUWSgDJlFcCHy5kQN5fMph4I8DjH6dHnAzno13t3zrGCso7TLV+JRiv5vUuGkMwZosczc
 T5LVbla0
 7OpQ05ZwU+5VT1+QRKsAVkbjYLYcjM4RyrVO3jWLXqpmWkwa9kqHiALqW2eDW+3VSRvwqCaDmXMWMqiA5Kx+ZGqWckOIJhQXAk7lXmtr3foYBVFGNeCYlFg7xGq6ydaSm4Iz3Yc6xGVkQnCoWA4RGRNIZs6tXNkfndF2tw1Uh/ZfN3wDmFZmNiz8egFy8BD+TlffoFHj07xrNFTVEzD9uMbQP84rRwi7aTb6+2XmQn44+TtM4Es3Bwib969HvjUsRZ2meLvvnx4PODRUrRif/hhx+pfvW+pBSwK0f9Jcx0b7Sstcfnuyte/82OWvYHkv49P4F/VF325SLnAW1U/bGMiqka12ABE65U0ajiX4PKeKhpzzv6ocLhEgZOBYFX32jlHOktVaVHtSFiZxIZTqg7T3IWJLXN22zQ8Z2/X1HDhqVyfDHVveLlkj9EXBXnRClCXUbUi4GYCoG+2DuGb+2vso/ZUndaiEMPb1S/971TlIv75+tmwl4t5/In2MZm3BeJ1hd7EEUlppD3xgNeeXYA4BNE7opVs/es3a519gh2ZhMzpTXM0aeMZ3Nm4+lVPqbo72rxtjkl+kCoL81t+DLAWe4XPwtWHMoXp7sRG/IiuLqmo/JtO3Jw51k4QRh78+4f8VJbcXgx1KlxubwghUETLM0ViIV5LnhuOAoB5zsPw/5bE8ZB8wyYoHGnEmRnlQs4YXU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Guard against unsigned integer underflow when nomvsum/len_window
exceeds mvsum.  When that subtraction wraps, the moving sum returns a
near-ULONG_MAX value and corrupts nr_accesses_bp.

If subtrahend > mvsum, return new_value: this clamps the moving-sum
estimate to the current observation rather than wrapping.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3a8725e400c6b..9975f3d9ebfe9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3449,7 +3449,11 @@ int damon_set_region_system_rams_default(struct damon_target *t,
 static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
 		unsigned int len_window, unsigned int new_value)
 {
-	return mvsum - nomvsum / len_window + new_value;
+	unsigned int subtrahend = nomvsum / len_window;
+
+	if (subtrahend > mvsum)
+		return new_value;
+	return mvsum - subtrahend + new_value;
 }
 
 /**
-- 
2.43.0


