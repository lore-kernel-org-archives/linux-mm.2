Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C00C5FEEF31
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240C36B008A; Tue,  7 Apr 2026 08:51:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1C16B0095; Tue,  7 Apr 2026 08:51:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107E26B0096; Tue,  7 Apr 2026 08:51:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F2FD36B008A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:51:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A8F059AF5
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:51:48 +0000 (UTC)
X-FDA: 84631746696.04.AE8A22F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 998DE20006
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:51:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ll/knAHH";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775566307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=srvQp0TSrkfJCFbzBsVmE/zCG1IKf74GBNaGV5g8G7o=;
	b=YL7O7ejjFKMshyd03xsfqzzNP3o5FNSPK5UMlR5z/QbSibmH97k+Vews+z8jYQCi8/i5b/
	f4u3Y0Mao4UOZQGyTMnDcvvbXlHKKdgH9IVKLqKXarpkCBQcrs550auDSKfJ2Ree8Fvy9E
	oJkg1rFCRXZ4agg0yWeFsmEQXH2O978=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775566307; a=rsa-sha256;
	cv=none;
	b=J3Zgr5jtFsRnpnOxOgsocu98T9mqPQj0KnAM0EYAXKvzRLciJGJY2uPh/y6nZ7GUoVnQwe
	5NiDPUBOBXj2Wo8o6DLCk8a7jWVTrrxxkGZDZhsK/I8q4c+23DOezafG+XXVBDXQMGzLr8
	QCx1AcD20+IgpYEOWUu5/Nd2xmylus0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ll/knAHH";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96F2416F2;
	Tue,  7 Apr 2026 05:51:39 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C6293F641;
	Tue,  7 Apr 2026 05:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775566305; bh=D2+nsTltKeS2aJLcGja+dPxP3RoXO2zx1ST6wD8RCd4=;
	h=From:To:Cc:Subject:Date:From;
	b=ll/knAHHYoPZlwA2ugGWrzWF1qaS2kVj8w+KKn0Te59tEeWqEdgwWxsCKdOrq6xuB
	 lU6qMnNKqkWoJmh3WsG38+u5IU4EDX8OliCDKaShtoTYq5pU/IvOOSVcU247YsIogk
	 OazkLjcdkLa9AptLNm8U9gNqi+i5P8sjEuGvQ3gk=
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yury Khrustalev <yury.khrustalev@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] docs: proc: document ProtectionKey in smaps
Date: Tue,  7 Apr 2026 13:51:33 +0100
Message-ID: <20260407125133.564182-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 998DE20006
X-Stat-Signature: oqpnewgmz1rcb9qgsthr5jzd4iq6o5f3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775566306-321046
X-HE-Meta: U2FsdGVkX18KgVKwcuvcSSIxSoSrXpRQRPjXYxsKJpI1TE1srmRxHIY0qCgALBRf1wIzsaIf6DyOCbKXzdzIe5ifPzNTlqrhxmHbZZ6xHoe2oNYNXgkaPjtynFC9zSKCl3m3GRLDLptOkKM9a4Ha/xXHcUSuwn1FExL0q7s2JcQGt5GhqvtcqeAP18nYf+LcsUnedi0+32m6ettYj411WRhTRsDfELS0uDNmFqYD2T06o+w9xBH2nTDfgLoO6lLHnUSdahBSJC8S423cyECDtLLGlZr2YAVTCHcedMb4Y4Y2R84IRhpzBqk8cBtTiXJ/NeTAEWohYUlS+fhLxCnquH3kM9icr7M5epI41EiqYYuRI5CaUrl7Tio1jcpaxe1jrU2ylnWg4rbs3PjUhcIBy3bAZqLaceEK8A9IFLtAQBqeMW1XLkso6JlOHEB1alRWLhG5LwN0auQ6MwJdXZ/6wKE4sOpJEh953l6cQzAdZeD8TS5rUxEjKXGt9AyPbai0Y3ZxTyUdaTOo6tbAcB3nuG0R4YCto77zGNvYWaVmflD9iAAzGETdCkNhuRKFkdg1bKfcxDThaR1DTilvnygD1vdTP/3O6VNK1kW8UncYClK+V9eWOHhDVnzWVKy0YwqPs3iu4u24xMckBWIJQv2Ph88lVWNWvYzh9fcJCc+aAuMYImytLF0ba30BzdjofxyPxW6j/j9+VsldE7fdN5S7T+iBu1QP8Ryg9LJHPYLHvEAJgBESBhnBcQlGdkCvpkyu9Eh9+UYFgksLu2Vtl98tLnQko3hnenMp88Z59y0FxfaO5ZUiPYMqFbYddPn9CakWCw01ctH3HWT//5UuTeYuijSgRdGqJ7+Gwof9s5uxwg+MZNhfKtFyOQO6BfJWROXG3wTNsi5KJRkPsnsHy1iaU9072eg/EqCPyurromRLNwwaMkN+m8LfqBUIK42ZDy8H0iLrNkoaT7ON9L1x//0
 /rrzNR2c
 unIdDvQx4feb3yRlwsxd2266qc8jgNHN1/kvCPmhInSjtxcCWhLZ/cgiwdopdLN2F/r0O9uAmZTvF7eH2uYoUFAZFP8a4zKg7yMUnrUZqF9U1lvAmpirUU+d1P7saZFXkNImV+xFx0OmCzh9w/O7myLCTDftntEnBWSwb3N1VdnCZodZx+ruryW14HD83mWbWEKcdYvlVfncSpQg61HcFu5FDPxMe6rSEd1mucqFVi+WqDO1pPzO35ujZZ3Doj4j8Ldw+1/Bf+AeOh6OSLdr3LmDpZH7UA7yV8IXi7XDHrv/vNmA3/TNZGMREJX6sjrsSfu3+dngY3d/LIV0m0Q22BpOLB5dTAdMFMww2/eQ2xosEkO7JDPjBqWckH0pf+oulwtgejCPDYyA+s8U/3mpUGS3CmuzYFe/HUDvL0eqF11LGmjLCobxCPV2IAd6znVOLIO9+Xb9Ynya2e9DRVg2FePmBKW16iusIQtPLvmjGnJ+JGem/qv3/U7WEiF9TrJCFiccENgAfnRfZZJ2BBl3kHuB5WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ProtectionKey entry was added in v4.9; back then it was
x86-specific, but it now lives in generic code and applies to all
architectures supporting pkeys (currently x86, power, arm64).

Time to document it: add a paragraph to proc.rst about the
ProtectionKey entry.

Reported-by: Yury Khrustalev <yury.khrustalev@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 Documentation/filesystems/proc.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index b0c0d1b45b99..d673cad7dbe4 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -549,6 +549,10 @@ does not take into account swapped out page of underlying shmem objects.
 naturally aligned THP pages of any currently enabled size. 1 if true, 0
 otherwise.
 
+If both the kernel and the system support protection keys (pkeys),
+"ProtectionKey" indicates the memory protection key associated with the
+virtual memory area.
+
 "VmFlags" field deserves a separate description. This member represents the
 kernel flags associated with the particular virtual memory area in two letter
 encoded manner. The codes are the following:
-- 
2.51.2


