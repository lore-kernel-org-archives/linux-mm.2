Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F85C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 15:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25F96B00A5; Sun,  5 Jul 2026 11:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFDAB6B00A6; Sun,  5 Jul 2026 11:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEBED6B00A7; Sun,  5 Jul 2026 11:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9255D6B00A6
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 11:56:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0325E889DF
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:08 +0000 (UTC)
X-FDA: 84955174458.16.62D8493
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7426B1C0007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:56:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JRa4Actf;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783266967;
	b=hTu5JcbNQ1TKhhYnvGiETYTEFTrrrGvdCPQdddQsJ8qvsrZvYqYMboNQ5I6E0jauXk/pVb
	TlDL/1NowA7W1KDJ3XJWPFCdNgLuiE3F9bdDajH/HXaV0YLwi4auiNdZr9cEGVKOmHAUPF
	7F3jMKa5lnGWEy7lQF001VTcn3bUIJE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JRa4Actf;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783266967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91/eIt5/uTjkLlfjnN3QJGjfo7AqpmKw2P22J/q/8zc=;
	b=2xEtCj2gZfam0v/fNqsVcuBCNO41suAYTYXGhyu6IEroyXNwwY580yN08OjNJ3j3PQnyLx
	BmMK3WydzJpPF2loM1KeAywFjYRRcG4lHdcIqZ1J70JaNXlf4TW6aEcwhUmtUXZwDSU+Hm
	ZQcuJf2CW/6BROk6w/xVA971meDbuF8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F5376138C;
	Sun,  5 Jul 2026 15:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956D11F00A3D;
	Sun,  5 Jul 2026 15:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783266966;
	bh=91/eIt5/uTjkLlfjnN3QJGjfo7AqpmKw2P22J/q/8zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRa4ActfbfMHkbUNp4FEAJ/FNav6kc++orrBOsguqBkasjTIUbXkHWFo5igUcTE1F
	 gWwbODqrVP8SisRlTAVSpNlDXaGhfccoda36GVZ2kMrLSGQY45eEHr2rLD49fQHedc
	 bwqsoYO9Yo+mxHWdI/zBzuweJL5k71BCDidVeWC0+iNhGdsdoAwWj52hmQSazlsfOE
	 2FjEboTJWFyojIesTHk8EbekvCg7nBZZxYn7JiuWRIVfED1O2ZnX2AO40j9R15ViZX
	 y//7fT6pQ5ivJqk1WAMOSMP8gCURraSWf2d8iuhPSGIAZGMq4yci7QJ2Cb0kpOOQIY
	 yBBmaUR6boqtg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/8] mm/damon: document region size validation in damon_set_regions()
Date: Sun,  5 Jul 2026 08:55:57 -0700
Message-ID: <20260705155600.96555-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705155600.96555-1-sj@kernel.org>
References: <20260705155600.96555-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7426B1C0007
X-Stat-Signature: w4ao31ki9db5qba6657knx9fbdsash8k
X-HE-Tag: 1783266967-638805
X-HE-Meta: U2FsdGVkX1+HxbNIjm/P4vmqX4Niugxy9YNnPxB6JOpyEheBtOP6Rn4uWBvXqOFgrpdPHBX21Kq3YL5F9wItOVTUct/8cejavWp7Jta+eT7QqQpzNh7bnF7BJd5nf+WEAWoMbuRdXi1kioJLDEAivEWeUDfwo0pfJJGpy+qM1GfJRapjPaK8AalFa8gEUZ7dkZzgBN25g6ob1TP1mK2OADYyqo7eLfQVcPfKdUZ8C+cX+aHs0PR+Tf+s5qjm6bjIo/hbLIJV+iXnwPLwICZ1Frzp0iem6kz3GoXDV/EYTMKaYp/CFUy5lFpUuUvCl60YtN1td9mnrxK3ETx5poqMVsJ9E1aX7sAoMHO0Op07LYgStVLNKYDz8g57+jZpMfcKYOdEvjIWWw8X7dBZoeZv8P8ECUjiOvJuf+DSb56iL3mitZTChuruC58fNpXZJM0NDHgX6+E1ZCx5fgC1akKoOrEh/d3tfoT6MVgxXQmC67DMJClQfN2Eu4r9apXfv19BeK9vCZrfB/DG4W/uc+ACBGP9ovoL4RV6FBE8hkJRe5cCsZ/2hrjAl7AxPFrMsn+4YfqmkpT2XwGm2QLsOTTBgoB+BLUBW1nDsHp0LNF0tEzMHAwnfQ5fFNfTOQIUs6+Vqxmm80uRIsvj50NLHvmaMiDtqLWa/XbZq9So4No2yGWAcqom9hZ0MD3C4VgVhwoAENrCDHGEP2LKfDd2w9EnFRkajirXcoCBMHvSxvFmByCzfDqy7XLBn73J94oh6jtMd9yyYOyZ7QKAkrRlqUx9thp0Ytvc1mnwzvve068qc06TFHpDSdCEnLVH0Go54zVci20TTRE+AGi/ahLrh1wHRYt4JMws3rH+fbRaSL/4UapemoXj/nZAemizXmpD7iGDomGVh8esxXBcbsNFICMmrGzBwV7GMLHH5BZ7Wq7BxtBsgIafbIKHfVxlObzIpsy5KrkoAPaiasZHLsXfOML
 UdS6YQm7
 O0yjgrkvvXncCxFMZrMhNOKtWyIpvflw2UQ9efsllhhIh0RD54uaUU0P+fDWW5ls1d8xiuQnieBOZgX9Zrioj1OqRYu+h+R/Uh1fifk63iPkPdXf/ZidAZjv7Z8LNXlsDKllGckAk13BcK9OtIv+hPQ76QH+wbBkjhjSQ95d3NXtc8q5DlDwroyK5DhVjCvioe5uq0T/GcG04y1r/4xyrG5ff+XgYTNsqtt9NxJufmVoVVvGZg6KL/CFTkECHfPe8Jyhz3VM0N9D8IUmIMvPEYjgMyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel doc comment of damon_region clearly specifies every region
should have positive size.  But it is unclear who should verify it.
damon_set_regions() is the recommended DAMON core function for setting
regions from the callers, and has the verification.  Update the comment
to clarify the callers should be ok to pass any values for region
addresses, as long as they use damon_set_regions().

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 616bdf0954b52..2661231c0ae82 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -49,7 +49,8 @@ struct damon_size_range {
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
- * For any use case, @ar should be non-zero positive size.
+ * For any use case, @ar should be non-zero positive size.  damon_set_regions()
+ * does the validation.
  *
  * @nr_accesses is reset to zero for every &damon_attrs->aggr_interval and be
  * increased for every &damon_attrs->sample_interval if an access to the region
-- 
2.47.3

