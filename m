Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92330D68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 04:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04AA56B0092; Sat, 20 Dec 2025 23:01:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F826B0093; Sat, 20 Dec 2025 23:01:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6DD06B0095; Sat, 20 Dec 2025 23:01:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D6B136B0092
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 23:01:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 672B6160729
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:01:10 +0000 (UTC)
X-FDA: 84242127900.18.1FF8AAB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id A769820010
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:01:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bicTWCw3;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766289668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c5NL9N/IUDBs7/Z6XlfTuHg0dH+EQZ0MpUNMh8FEJWo=;
	b=YZIO+B0MeoMiYKEHDK39Q3kDoyW/LaIWSy2ZrOdLKt7V8CMhVFT/3lh49d1yFegn0a7V8C
	BEaQlCDATuJ4jnBW43Q2zThnaANYgjuaVV51A26ROVaOxVoSrS4GLY2oQUnq9tvcMJis8m
	87QV+HBtrUQmgJGR+IbbzQWsYp9EBPQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bicTWCw3;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766289668; a=rsa-sha256;
	cv=none;
	b=T0X3acVhT/a1DrJrBHdUL77HJRA9QcC4x06LhfCgpw7V+FDpi/5XVlVIPwTUxDG5p+yGJv
	GO52G6XDLRPWv2O26WXWLPi6dXD4L4sG4pUfZ/uw0eScs5n0PB4MO/FXqSFJIVMUyR7oh5
	KzRrmD76ebnh4nz67khQp1hQrEfPxOs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766289668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c5NL9N/IUDBs7/Z6XlfTuHg0dH+EQZ0MpUNMh8FEJWo=;
	b=bicTWCw3C5yKH+YR1C5S/1MZfpsGin3qS/NSMhjAftyFqpJzlQRYrN+IPe1ofOpMUmwO+P
	S2j+pXfG1SNxn/JDEnrpMJZ/wG590pWO+3D1x/ZQqqm93qtKSB8qn4YzaTHGVYVAyMfec0
	TtJOY/B4c0Tu3cxde2fqiOKtTw7DZ7M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-403-5wP8BfWWPlORz9ZR1kdH1Q-1; Sat,
 20 Dec 2025 23:01:04 -0500
X-MC-Unique: 5wP8BfWWPlORz9ZR1kdH1Q-1
X-Mimecast-MFC-AGG-ID: 5wP8BfWWPlORz9ZR1kdH1Q_1766289662
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76A311956095;
	Sun, 21 Dec 2025 04:01:02 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB04D1953984;
	Sun, 21 Dec 2025 04:00:56 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chuhu@redhat.com,
	Luiz Capitulino <luizcap@redhat.com>
Subject: [PATCH v2 5/5] selftests/mm: fix comment for check_test_requirements
Date: Sun, 21 Dec 2025 12:00:25 +0800
Message-ID: <20251221040025.3159990-5-chuhu@redhat.com>
In-Reply-To: <20251221040025.3159990-4-chuhu@redhat.com>
References: <20251221040025.3159990-1-chuhu@redhat.com>
 <20251221040025.3159990-2-chuhu@redhat.com>
 <20251221040025.3159990-3-chuhu@redhat.com>
 <20251221040025.3159990-4-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A769820010
X-Stat-Signature: zscqym9f87jywcoise1gzqw679hbsc6c
X-Rspam-User: 
X-HE-Tag: 1766289668-369906
X-HE-Meta: U2FsdGVkX19xrKEPHrprWARb04W9B7tem6NF2gIF5IEADQfeSMzB1yznLg7S8xvd8PnlzFn8DT+r3EdFnLM5uLP1GKu3yU0Rto1oB+iF6eh3FjudZAJA2bKs52vKbE+KAgQzyUoVpRdKsxxOF6Rd/f75vTzNlktu7hlRSiR2HLOli/bYgZR6hkOo/9bBK8GZS/erXyjCJn33d4UAZhbFQ8pJIJxV+ElZYM3V2nYyQrBqvKtLfYU6XP0nLt6OdqSclFm3oSpsbxuuNudECWDyMDs0P8OnI9BiOQfEf2rYdyitYMgN/HyHybzlOh1YItCGouke0pbHN3Fhfv6PzE+q0z06BsVnhEjFp/KxKfBDEv4aKB/EOuG1d6n7MleF3x7qse321hPfeOfMjGsQXM+BvILjLQJ0xxaRho3apbWzHVmE1mAmoAroCVmgAySRrFrHQcy6hLE1CDHWmsvOzoi2LuN+4kwSl1T2kgIFH3faa33rhL2dYTZHjLDkKzIbH2SMClQ3hLJ+ls8cux0LpQLQ5LzOA9VXBWNPekYR+/rt9EmttKlUWx/jPlFA5P5gKAXo5/mPvN3osoWCZvfLqD0dyGci2PYrz+Wwz2ogL3vR7sSbRl0JdeIdrVPh1UFZJIhrgmFBR77fou9O81YbsfT6S+OeqrztGZtBoTvmFB7pqRL2XA8Jd1wX/MN2K5/B6WCV9FMdWw81ri3xEAOwc9S1FeMZqzKRB4RUmMxS6FNuUm4ncZz5PsVrrNDD6wHuzFaxVl0/enYpZb84zaZWrFP61AWtL1T8Ca7Kkik5+Peb2lp5R2AndnVbpUpIehPV+VXc3nwOy1IEuy6zCpZ9aM1wwiIWkeCWN2glq3zlOU+kFlLT7nrjxClSBEFJxtJjdwLg88g1sSFyUgs9uCCKACakaSBJCJcs4Wqdb/3I3ARLSOL8+EXM3EFxNEVtxBpr1+emaY7iVIksrCB+ZCLvi0I
 mWPDQgeq
 5kw5nXRYXQISjcHo7ayn/0YPx/hZxI67c8Yg3qv8m8uViUZECy+ibswiS7N6zvJVAcgIhDDF5/yF2rNYTZ+dBmehsCmeVullhYsIPx1GgkxVoASNjnP4zbb5UJgZ9gR+kwOJ2U5d+2xjtfFlEjMpjYZzd5qiBBUJYtO+y9AGkRapaKpXVunjaNNWbHYWASkssvs4NwzV7Sz/AEnSRak0piNs74gsgaHcXp6PdT6635esd3Y9SYFT6pXuxLm9BJHpPmekqsR8f0YGPL1q3aCwr/JxHcx9oToubfrMvZFNAx1P+KtEKoyv1+4f2qxBQf4fFcKZV90BWE/DlVy/25YnsTCeccqY9fXf7SA6ZtwJ6TOt05ZMxgst4BS17rFear718ANKG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test supports arm64 as well so the comment is incorrect. And there's
a check for arm64 in va_high_addr_switch.c.

CC: Luiz Capitulino <luizcap@redhat.com>
Fixes: 983e760bcdb6 ("selftest/mm: va_high_addr_switch: add ppc64 support check")
Fixes: f556acc2facd ("selftests/mm: skip test for non-LPA2 and non-LVA systems")
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 tools/testing/selftests/mm/va_high_addr_switch.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
index a0c93d348b11..9492c2d72634 100755
--- a/tools/testing/selftests/mm/va_high_addr_switch.sh
+++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -61,9 +61,9 @@ check_supported_ppc64()
 
 check_test_requirements()
 {
-	# The test supports x86_64 and powerpc64. We currently have no useful
-	# eligibility check for powerpc64, and the test itself will reject other
-	# architectures.
+	# The test supports x86_64, powerpc64 and arm64. There's check for arm64
+	# in va_high_addr_switch.c. The test itself will reject other architectures.
+
 	case `uname -m` in
 		"x86_64")
 			check_supported_x86_64
-- 
2.49.0


