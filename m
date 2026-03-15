Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A787DF30283
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 21:00:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D846B00AA; Sun, 15 Mar 2026 17:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B2C6B00CF; Sun, 15 Mar 2026 17:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22A9B6B00D2; Sun, 15 Mar 2026 17:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 118006B00AA
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:00:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C61151B8F92
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:26 +0000 (UTC)
X-FDA: 84549515652.10.9CB9F14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1A4038001E
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TztPq/Xd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773608425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEsqF4dR1BQDXQx6Uv8Arh3qL5nC5nHhRGIBa/YV798=;
	b=8lSO2muhv2oWDgP9sfs+XWfEn2mOP5k+RDAnuhW3oJa2XbmB1LZTp+O5K0pJl7Sonux0vG
	6BpBHUxyzrLKGEH/YJZHfoenv1AmAhKqF7GTFHL/WcUdinjRQesNkU3R7aEpNCqc0UElFK
	9cMZpGgHiRD5rt2X+jKtsWTbHF4vwXU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773608425; a=rsa-sha256;
	cv=none;
	b=lu1O+8K9kx4gLIXpcPaVHy1mVGHWi8dqPq6Nb4J33QdoJe4hc4xIHcRVQwlnQIREBHjEUH
	yl3enL4UyWRJMEttElInx0oCDLFJrKYIDxeC9oVDW3WQ7d5zbmJnGTg6abMKsLGr1R7ZYw
	WnXtJxhFh+td3wFTA0UxVZvjYqFaOUs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TztPq/Xd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CE7C43DED;
	Sun, 15 Mar 2026 21:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994FCC2BCB0;
	Sun, 15 Mar 2026 21:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773608423;
	bh=ZFcnqfyAW4BGE18Wt14ay/AwA/gxtaEmh1rLITl8M3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TztPq/XdarWP317/J+QUEhiIvSmkoULqcTmaP7DcnRcmKg1qhTO1AVyUMzPGaBDj1
	 tbMOTnARI7GPnhOEOdNV5Mb+fZhuYVsAp69dg5RXpR09GNmgcfIVlmoA1NAkc2af+b
	 w58LkdXXf7h9DDs4NbZP6ldKGXv5TLhnRnfMM01y+D7JmZDPOMdT9DysTX4vWxFnfI
	 n46QpEnYCcYS3x5s8ObGh2QVXh9Pvc5pv4U23/1KY/rOLKbJ0Ls7EdqrzQJ6SfV8VU
	 4XE9c5CNufrkLCw5tgqtLZ1w/gclkzkMzLFuyGR3rBCgdbtITIELa7VJ677RIkIysj
	 U9Cp5X9uMmR2g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 03/10] Docs/mm/damon/design: update for context pause/resume feature
Date: Sun, 15 Mar 2026 14:00:02 -0700
Message-ID: <20260315210012.94846-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-1-sj@kernel.org>
References: <20260315210012.94846-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1A4038001E
X-Stat-Signature: 4te3aujmexn91zhgh9ygkchmdqahcjaw
X-Rspam-User: 
X-HE-Tag: 1773608424-337756
X-HE-Meta: U2FsdGVkX1923ouiDr80wHRhB/QwluKqc8gbcviKIdRCCNiNLC+rSSNdTfscLnYwZ6cfn8M21t6sF1ZY2XL15u5oOqVjOUlUoOsSeleuJv8pvtQWImGYQZ25cYC2CnpHxkq3yYgxDC+A66aIW+os6pIG3cZstyhZCqZ4vCEA98FBe67gcUHktBzkHSCKHnrfYgK7aGvmAREBiX0wlVIhQlTk0mdNJjQ6PMpbIkYubwqGinZ7iRzWUdL8yQqeTzDjDdVqPuxShl/1KV8ZKmHfHMoFB6LrlC6IC9Ci4+Qc2eHz46/8CSkUkinXN1o1hO9fno9rAUEgkE83g6h8ZLjIxCnm9Ii/rW8bPtFuH60DGiQHXNaa7kCMHEqnQd6bwwDI5SEUA9knFWBn/SLhsan8O5zrqQ/d29Tm5GsTUfJY1IEerWGNBU5yuUz4PJ++5DDXC/sn9f/3ZFw1l33OOTbhFFzAqmUCbzTkUErOGw726OQndZXX6VgTFJBIuyl+StZxV5WV6b3Bp0YJMyIE01gYVCxnFN5oQqJNy7kbrMPp5ZfICKV8UWUZlJwWywovNM0BIziJrR59IhdSKfqskRIvMPLGcDOCXCBgIUJyIa6GoLQZkyszdxiXJrQXaJSAUgj1fYyB0aCIeNV2sQF3pELW2iyYPrHhNeNI608cd+KT1icsH5laoOOoQKhBJZM2Y5dGoLP/9BbQ9CHXV2i3+YM9eaDt9OTB6WU/Jdg0D/0FE/hgWh0vRW2IXRcisZsKPAtV5yYKAnLEjrVuf/P7Jwk+zE60V1BUQdkU2W9TQH2tqbsoUjEjnF//Hpa4wJmBbRimx/P9KoQroiIk3kWvV/2B2jhgaoapcKaqAX0VEmqNqBpYxjlcHSYLinI0G1E8lCq4/Bs4FRmIhpHE3dwzcZywFUcamVONhYTK8KJx6KTXWAWsV9Pqn8UTlrI/9yMsHc1s/1iZPrpJY+sgOiVilMX
 e7rZMOLP
 8qMYbpeJL6r/DbDWYVAjkW72iVem2kKwerudT0uMh+W2CfTdhJL3ZXlImZKFhpIQt9mS2Kj+atKmMmMa93XWf0zUmeaj2V3zCW8mLzxWey1BGhTgLDBn5jufZW7KdIh6HbAB1MKiHM8a6DIK/raRK5Njsge0i9/WrzMJtWQfXv1e72bAjofE0pG9AeOzk6vR0dDqr2KvsQAdnzKhZrVuHX8Cw/LcO/MqI5RmGXq2k5ogfNDg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index dc37402c0fee9..5723ffe8b51be 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -19,6 +19,13 @@ types of monitoring.
 To know how user-space can do the configurations and start/stop DAMON, refer to
 :ref:`DAMON sysfs interface <sysfs_interface>` documentation.
 
+Users can also request each context execution to be paused and resumed.  When
+it is paused, the kdamond does nothing but only online parameters updates
+including resume request handling.
+
+To know how user-space can pause/resume each context, refer to :ref:`DAMON
+sysfs context <sysfs_context>` usage documentation.
+
 
 Overall Architecture
 ====================
-- 
2.47.3

