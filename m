Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80711CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 15:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33FCD6B008A; Mon, 22 Jun 2026 11:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F09E6B008C; Mon, 22 Jun 2026 11:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E356B0093; Mon, 22 Jun 2026 11:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED7DB6B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:59:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51AD71C1234
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:59:36 +0000 (UTC)
X-FDA: 84908008752.14.35B21A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D0182100014
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:59:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H5SEbEqE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782143974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=t/E24CF4WEcGA/vJiJunBWw0I8+rDmkoJaQIXcj5tkg=;
	b=APd2RfyILGFldnL+YuF88PUi5VNudHQBfg7mTZ0JAwI0of22BAslWBduwNTcWJVyh5zKPR
	RGWqX0hrUQKzBe4VR/DH/8ooH0o5UFUfTfMZYRWVvY2TtEQg2/LbFE8I1Ows2JrJtmtBYp
	ZcJuGjswYeuaOvUZSV8jnSxe18TZoHI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782143974;
	b=yFgirZ4IVbXvYWAuhTGjakXE3jq9yJ4yYP0Qn1QibqeASJVz/gc0M6NMo1JC8KhgKnH+mV
	zzRotmGL+QL4A2A/aDgkBHdb3Svs8HoJI0wpsSPWpSzvojad5aVY0kmWEWlmoRhEoSaVkB
	xZ33NiChidD2zcgTDAZBYA4sup8RXDI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H5SEbEqE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43E95601F3;
	Mon, 22 Jun 2026 15:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFB61F00A3A;
	Mon, 22 Jun 2026 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782143974;
	bh=t/E24CF4WEcGA/vJiJunBWw0I8+rDmkoJaQIXcj5tkg=;
	h=From:To:Cc:Subject:Date;
	b=H5SEbEqEDK8uMLrSg2UxbS+RwARtyVPPMWP/SP7XTodOA7+OieSM3NM+XZOgQ92VM
	 IzgzJhB13e4Jasep/dfckoqMeISOkvJzRw0mnIfhM4kakXf1D7JYvo8Yrpw8HXCkys
	 JSLzMpEUyFdubtiuaA+n6NJEmI22qCo8x1hF36R4m45IfbEoh/GzQ+SbcAYSFtBnNQ
	 ljNRuCih89rema+6iDnYtmOMAAaDoVvghJhHSDaaDuqMaCPfnaMWpE/QLSQV2qmZrH
	 q6qaxIZQcu1eQsH19JK+1LirFfiWKmM+7so8G5oW7lyFR1ASNVOBdiu0bN+YMj70cF
	 zjH/A9R5SzCqQ==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Add Lance as an rmap reviewer
Date: Mon, 22 Jun 2026 16:59:13 +0100
Message-ID: <20260622155913.280355-1-ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: d4ttn3nrwbnsog8twwuqrucd8w8q5eq1
X-Rspamd-Queue-Id: D0182100014
X-Rspam-User: 
X-HE-Tag: 1782143974-337214
X-HE-Meta: U2FsdGVkX18oN5N3Ov1+Kto2mAwk4BUv26qoChTokORQrL6khqLnBTwiWEOnG9z+AHIh5NM9LCGxLOl0EK8cv5SYf73JW7ujb9sec9JxjU4qnLVYIvpeA4cQHIg8v07D5/dHTi3c9TGtAHRvjy+548rbZ1eI/PP5ib+gpTZX8KlfOPV2MQqYY9ZjQHXHO2L7qkCApZC0KKBygh5OpsAcVmo1NWtr03nmvDh52p/sWNJT5LO14KlmElMAs+EYYCM7N4GKXjRxjzmtdjj/arbDL7JCTNZJaEeespIQR2KEE4Yn6vK1r3UDwI+OH0hd/a/9lD5TCcmp8KYEtKEhpje5D0QCQqXaj6EzHK+q/UDhUZk7UoDvOfS7Y1nHCRO/vIayconln4IQefhbwDNNeECpMfq0XkjBe4vaDyN44YFRCGTFBhvmNYnQyWHgZm6J5ZsSdF8U5KgZ1klaVaAWNHSXcnp6SLn7bwMemoKIgUZitD8bO2pZ473XR/sAyw8iNVa932YTeEqJjyGAPVx7nBGr3IQ6kiOZIf1Heiql5oNdTfBBOcZGVnUeRtN3gAbLrgOlO4uoQjLEFBqMWFjU5fcJ2uN6oh4T55/bOHuAqp8uzBJQVHZ43s9zkm3SZieetnmgLJXDMhE6YHyBbvyQI302fKsG+J0eqRE7xLxI/IB9YWiGmlaN2UArIRKtTixHTWc58YHzy0+itE50S6OPYBys4rwccduqQlWlQefAj7bote4iBsQUx11h1h+g9BezAMfm1QIa08wciK0tiu2JhmCFSbG+7Gf9FfkC/bli6rJB5v3OR3y4nAkQSqLqZz7ajR3e9n9N0xVI2niIdOq/wo5A9RBNGlLutES6ncXulZefychcLZcnz+/rglAJFSE8t/RR0QVst6O4BRTveOE0/yLGqgmQZoiYvlJZpOGBIO3DGGwtkfxl8+YQi2Q7e0ZcO7Unz8l+Ejrn1z3d2DzBZzx
 hyWUBKDs
 wbyg8no+h0Iyn0mdLnZwf+FBNG7NCMhtOMRnf+48RiHDNVRhau3vgVrwh3RXHqlhykotnMBPexzNtYyjPdlXd8EDcO5rmbT/wtmqOzYWRTGfhiBdPwoQsy/sWykyaQ3s5Nvc8gMAu1UXR7v+/y5cL5ZcjebpNSkDp9MSfiaTGsvtLFTrsuDI2bVmFo2FoHGnFMJQnCxKE2Qfw+Vcg4zGkJAfZltPqwg2AYMbNoerpBmC6MjpT0/7TDqD6545DBQcIL16HHrt/IrqsxVgDZUyJAEbVnjVItHM69Fb0RHzxx/9iTXiN2bzseLqJjbnSlFm4xu/ml+aKb7reJnQcqqXI5wJZ/oTFlpMk1TZGa8tonNE4+GWv/oPqRYodCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lance has been doing excellent work reviewing rmap series and has proven
himself to be a great member of the community in general, so add him as an
rmap reviewer.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 65bd4328fe05..dd963b72c614 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17024,6 +17024,7 @@ R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
+R:	Lance Yang <lance.yang@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/rmap.h
-- 
2.54.0


