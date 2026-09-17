Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B431C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8096B0098; Thu, 17 Sep 2026 02:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFA26B009B; Thu, 17 Sep 2026 02:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A0556B009D; Thu, 17 Sep 2026 02:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 545DF6B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:07:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8B63160254
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:07:24 +0000 (UTC)
X-FDA: 85222222008.23.4C3A058
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4CD9620004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:07:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U4+1CR8L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789625243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGGbnh7nf3PeA0Yo51x/8OYia2ASfwXMoEdA72QHwpc=;
	b=FuEU/jyoI3ra/RLOV4w2KheIchUHjAd1pOJTIUEqD1+hvpwtRJFj2x9iVpQ4AZQvzQ/6Bb
	NpY5IprSHtGCCeyBAqkg6GGKX4VpNkqMR3PVDv3KM/u/W1xAN9aL+dFxIYn2F3Bdgh45Lb
	PeglwfMT7f7grHLXqA1DfdURjTaj45A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789625243;
	b=nFC1v3wt25QHWrkuZcXoCyYCp2CF/2Tx/0fO6FHnOC80Rdh7eUjCn3hyvw1ju+x+ENVHj0
	N/I1X9+fJmu/5QYlHibABCFLHrUlwFavocLzRYvi6dn3ho9AnHIUYq0NxUaLIF1pQJFKXp
	xuJouQxFoi4t8ANCxjS1Sr3ii6bXkYM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U4+1CR8L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA05460A59;
	Thu, 17 Sep 2026 06:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9739B1F000FF;
	Thu, 17 Sep 2026 06:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789625242;
	bh=YGGbnh7nf3PeA0Yo51x/8OYia2ASfwXMoEdA72QHwpc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=U4+1CR8L3NtdMnHUbE4+EILa18NfHZ3q/XTfVOFCFxoXQs03gVYgWeMceSE6H+nK3
	 BidirIiFi1yF8XDLY5G0JngHcZ2UmwnNFe7iEo/TS1AP5gPWu0GoyDgDz6xOqYkxwI
	 DHZVBGf9mD/vD5D0/ll1NFnd/9YIhQtgUXOmLJO1FZ8E2Ak5fbmNui7WllDKTApIGh
	 S3HOpmbIoElc5YmVvv7zsbl9WaTvLnXMqaBQuxfyzxOtbPdS3J866XeyPG99wtJ897
	 VRwfpD4hxQUxSshprfkFx9AHYzEbHM31IL+nkr/iDRXwdzMOmU1eOX37AND2WdIASA
	 KNkXms2omVOqw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 17 Sep 2026 09:07:04 +0300
Subject: [PATCH 2/5] hibernation: ensure secretmem pages don't reach a
 snapshot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-hibernation-v1-2-7f7dfae3dbe0@kernel.org>
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
In-Reply-To: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Potapenko <glider@google.com>, 
 David Hildenbrand <david@kernel.org>, Marco Elver <elver@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4CD9620004
X-Stat-Signature: q59sadxeswqyz9iwmjbytyc4ywjf8ma7
X-HE-Tag: 1789625243-560052
X-HE-Meta: U2FsdGVkX1+2ocicCc+oS3Scck4me+vyta6Y1p/4CSEIDyhpRW43CrwtvmpeE4xgym3teV0NYRjfU+iX9G4pfMdkhogcq48TknYpolnP/JtpEylP0IVL9WXQsTEXUURN6P6YxUj4yDblDHbgvzixez3VzdKRcl1KmlR4Igd+mk0RjiEYwpunCi577oKHa8nAbG5C2Qa6gHJUsNoiKr69NgLM8eVe+B2ZYBWTIPAxHc5YpXggb0QNoyrDMIMkqtosT/JLjYmENXT4ml6vKvQqm7D3ryUXHLyvmSegjlr+OqyvIdygHsw3xZQav2YpIBya9Rh7FppYQkyU1TqIrFap4xe8/wqze16Ax04OaR0lbRBXLqUI9C9nVdiDGcOs1QvnHAR9o78/5hHuG0vE9tx9WwH0kOUez65Fd3f0eCG25HRF7Y7uY7doQC+CZgLe54JHeuY/YoQHQIjLmiTKQaV/0TB07dQIaV2SJ8tchW+Evo5QUkfE0FpO7GnslN3MBG3QhPNaTwmnzzFs/x1xye4FrtlcaRuNd0GCO1Q/1EA3GT/Csfvlb+lTjdBDSN3Kn/XJJp0Sj7L+PRPIEhz8QL4b1HKi+ItH2AXMozviiMChur5q5Z44ZSyyzPaNS1VCgUTF3ylrSS2ExveP1hFAQCtmgwo0KVkMcmjPFHxuiz9rRftuNWQrZdEfLeDHHoGZ6zf5M2ZrOGb98ssrWNFD+CrQxGzz0ci1ULy8MYvbDPlBUWjESa+CfpvyPFzs3kKMSDJgMpL1HmMIAVFbHLsHbMj2gex9QFx15LLW2V5sL46MR7uPLDaw2REZIGP/51wDsKqiy/jQAvEOUvyeIl0TVMjWt2Ob6hRgE9/roHadX+tbanqFwCj1GCF8S4aw2AsGEMOgQMIYz2qncNW2/bJ3EFDr0Ed6SYk9nDA4PhLWASJIbki1Ts6Rz68gYTJPR1Qpt3sjeeBjjKIxkPgljXUsECF
 o+D4GW2c
 qT7Dy0x/yJCWobAIr0wNLnA5WztpcIbZy+E2+42O2GzWszn7XVXz6WY523DLNArMRFOufl+YILcVkBFVbheiMVxD9uFU/koiPiQ6rUKHIXkC6pyvA7U3Hwm4F7OACOagmCB/JnmhskLQOhr4N+Dkc3JCyD5vsdmDM6rcaWgo1JBtdV0beM7bEmjA07FWAi3nipKtYyHvyCm0h0PmHpdUyy9gh/TDQ7bQp8ZqJ9zfQTPPvRpPp6kjTgjx+zA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hibernation_available() checks for active secretmem users, but a secretmem
file can be created after this check and its pages may get into the
hibernation snapshot although they should not.

Recheck secretmem state after userspace is frozen and abort hibernation if
secretmem is active.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/power/hibernate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index d2479c69d71a4..281ad49411481 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -412,6 +412,11 @@ int hibernation_snapshot(int platform_mode)
 	if (error)
 		goto Close;
 
+	if (secretmem_active()) {
+		error = -EBUSY;
+		goto Thaw;
+	}
+
 	if (hibernation_test(TEST_FREEZER)) {
 
 		/*

-- 
2.53.0


