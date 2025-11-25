Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ACA1D0E6E1
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 13:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33306B0032; Tue, 25 Nov 2025 08:29:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3A56B0092; Tue, 25 Nov 2025 08:29:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20C86B0093; Tue, 25 Nov 2025 08:29:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2E016B0032
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:29:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44DA91DDDAC
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:29:18 +0000 (UTC)
X-FDA: 84149210796.13.A214BB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id D4D6F80013
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:29:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FE23xHAF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764077356; a=rsa-sha256;
	cv=none;
	b=F1yJOAfeiosm6PqRrriX5gFaAxViqYpqQEIpNwAl+BaJWijFum6Q1aU4mNpDffZXXCtaRc
	ILEgzX1tbZKVnzs9RkN8gNBwBSy0j7gw2g3Dzdn0Bmu+HnydMRASwYYrecGDZtDBYuIPD7
	l6xFSM3wgTM9bAVM/Gq7iiUsNcTx8Ho=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FE23xHAF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764077356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=248pB9oSjGoJMs0TETUK3wnOAlH/yVxxXOWTubxAXqA=;
	b=JG6ZLHoUhQKluzrcct5Vl2MThQex8CFKjrzjPAwk+FD6hVO4bW/qz7bpa9iAOeqiL3XaKm
	bLZDSSbgH5IU3OtxbbFBDCGubKllJkzjOQCzo+oiC9qkYM4Gi6IAZALSN61zqevNYICM4I
	bXdOG7TZtngCa58/eQigvxZ+gohjO3M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 56B45601A4;
	Tue, 25 Nov 2025 13:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359F1C4CEF1;
	Tue, 25 Nov 2025 13:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764077356;
	bh=UntBK98//PKkOeKAApg64rZD7PUsRGdGrFly0+EWYhA=;
	h=From:To:Cc:Subject:Date:From;
	b=FE23xHAFYHzraqDN8Ce+St3kZhRb20vLTCt0gKFmOW4horFDP7MjQBsi2QH36JBj3
	 whG+9U0twMJ5T29hRmBGyl1/hRmoSkKK18W0nOToADXEQEwfi40hGJYlAd1vGDIQ+N
	 hmIllHEJtlVsbO2pQGM55/mCtLfuDdNO9eQt1ZPex0PpEMvys3YZGESj+9UxQG3y1a
	 +zNN/6XehNpKTaImraf8cj7jN5/OiU43FzCzwdVuV0snVjp4pP8Ig5tW0zE9Zg+mxy
	 InbsDyqc6I45ZeQqWoV7DzarawdQw6eZMK4u7sEmEz2zKpZqbfV7nev8/BRBmg0aqm
	 7/XyowQZEPq7g==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] MAINTAINERS: add Mike Rapoport as maintainer for userfaultfd
Date: Tue, 25 Nov 2025 15:29:08 +0200
Message-ID: <20251125132908.847055-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D4D6F80013
X-Stat-Signature: wkeo4tfbzfcptr4yfsu33redrfw6z51h
X-Rspam-User: 
X-HE-Tag: 1764077356-441763
X-HE-Meta: U2FsdGVkX19vF9kFjj9WOi3tniH2mCGp9cchkNd0b3ApCcyrmBjHk2MfZrhyiqYoJHUYDU6jEz55KcvsCb5WnfWXbJEIikNtucWDHuCw8aXTg4jbM9yCgc9paONMzTUjcq9ffBODG99nq+e9h/IJhkTumQbs1c3kN+KvLqUqXwQi53XJaL0fDKhE27JZ6qXYVC+R952MGqtjjL9HjF139HoVTD8LMG2bJiysDcoq01yfGUaZ9J2FKG+OwxQNLxvUErnIs9Jjj4r9yigrUgLIxjmda36+Qpj3xyFhlRiJ6rQ5O1Z3cCjwkn4DHIkwSAGSyAc/dC1UYK3eF+H15YRJVra33IlJ5SLrkO9M+ZANslc7xetLwtq0VnQ/KP3n46+hl91DDIT7b7+XxO+NPD2YzqFZU6ssi7VH0JAdKg3rqj0zrEuCwjkRakFSwVRLPXSOyNFdF767ZkHn0kyaOcvwJ7UoE2FfqEcFeGBjuqxzvgAkqmVn+toVJS3e5cZelSTATrrx9nwY0dQmXbZH9I28ztqsccMByOF8rNLN+LZmP4F8PqIavla869QNUDlaVTwOM9vd/DSxycDcYK94T61wLHxLumwt6EKkNS20JRbEsEe+fDgbgnN8LIR11uJG8uOAhMeDLfaP9IRRIV1YXnJRdqL3p8U64bU/yic4/9tY6AENVx1fPP9M0LodE5MC+VKbADEJKY6yR3+btMrZwoXkgr5gssz7xbYiENYB2NJlIVOcS05ne0SIFALrcIFp10Zt9lIqnbRZnn5opQy5NqtlTBsuBY4UtDhnepDUL8dVYcnIfeCWHdjOHOUQcpETtNz+PUDNzxA5Oa2k/cizC9Zqrq41RbeaNMI6RnoVF7LS3mhsKHwKrmBBTwLxJTHmtwqp6gDF2Fxag+1Y6MDAogaqyDroKEfPBoymzw5BrGTsAamdar3gCINcm6VThN7EpvW97ijecet5u1EZ6cAyzIY
 hnLz1DXe
 vPDkQyVOQl1T+S1ybImjIY+nZhskeG7kVNiIYyF8OfOp3DCBOeZuijyOzltU1ytsPCGFOnkmech7K5XpvWUzw2v1RBno6A/fUfF27KYlM5HEv/qQEScaBKyMFJqjCMG6IKz1iKi+Qm+gsAcOU9++UaKRt4dWOjlSJqvbqE2kJ1PvfHIGl+QsQnRWc3Lkc3TFXS1o5Jg1IG7nMBkfnp42u7ySYa1swDVr47zt2ClEy+Jg1fI9yhvsvsmEXaOOHKmDCxiHIM3BpYsHaiZqC+VbUFRMJ3iNpJIqJ5a//zWQyESgaB8UwPlSk0wz5LtjRCLrpViRxIfdrQ6lFL1uqCZhP1QwiMu9Zyz2DlQeyDkIRlAMlinlJ+YUddCleZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6df89b14b521..5243fd0eca74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16547,6 +16547,7 @@ F:	tools/testing/selftests/mm/transhuge-stress.c
 
 MEMORY MANAGEMENT - USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Mike Rapoport <rppt@kernel.org>
 R:	Peter Xu <peterx@redhat.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-- 
2.50.1


