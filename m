Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4069CC79F8C
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 17:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A94D6B0095; Sun,  6 Sep 2026 13:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6746B0092; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F2C6B0096; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9915F6B0092
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 340781C23A8
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:21 +0000 (UTC)
X-FDA: 85184076642.16.29BCEF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A009B20002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJvljSHw;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788717019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nO6vnuxi6J2KrNlifTLU/7q+ZvNIHG45rulFRzj97d4=;
	b=B5cTslhw6bTuR0pUF1mz3MdVcNmEYDzSpgvfuM/SMUQjU/vLv/WxPxcpAfaJXkkvnm8ath
	h3D71K693x+T2MO5Z+Iy7/q8nm8Ht2sxXoeWaEaoKmkJwOq7ZRmkRnf9SiRPhje535g8fV
	kgmMw/ethllYHedtKjJbtsmZKioLgxU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788717019;
	b=ekzUFdv37R84bVJZZuhN/kKNmqxQ9qaPI6LvqnLMluaEEO3iubnfOistu5ZZycfuUnIZpJ
	5Mx++vpi6OltGRCK3RgOsXG5JC67mFs2iO6/mu4sPdB1wRHyLHNCo3QsDn58IlBD3bMm/y
	oEHw/h6M4DBKQbIBHRpTDchTG55OEkM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJvljSHw;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F367E4348A;
	Sun,  6 Sep 2026 17:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EED81F00A3F;
	Sun,  6 Sep 2026 17:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788717018;
	bh=nO6vnuxi6J2KrNlifTLU/7q+ZvNIHG45rulFRzj97d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJvljSHw8101nwn1KyGpg27PWjkZXnR/Yeb7FxtPCgJ88B1jNoX4zs34vr1eGu53/
	 bjhkjc+JDQuHyKScBjQoQ4RnmMxlaGsrASnJ+HNwsU4qF/5p2H2H8B5k+R2qM9EqzD
	 9Qc6n58PH935cd9jISrtcW6kGCLt3VYrNq8nbbQc6OBsRnAquOFb5nSGDmNNvseP7U
	 r2XXsL6a9IelMAo5QvrBkcQeJ1/ubw1DmSpQNNwF7tSrFHvthCA6FXdgdIVHObRhs/
	 xkXBjOylJSdkBtSKWLYxjO9KJevPobziew6UR6WxYfXFajnHC0MA2i7gSLFCLJtTzF
	 3h2Vym9oFP5MA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/5] Docs/mm/damon/design: update for pgidle_set probe filter
Date: Sun,  6 Sep 2026 10:50:07 -0700
Message-ID: <20260906175009.93471-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906175009.93471-1-sj@kernel.org>
References: <20260906175009.93471-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A009B20002
X-Stat-Signature: ynhrhtxe8rx5qjtqpqkmfqnpg1tai36w
X-HE-Tag: 1788717019-900974
X-HE-Meta: U2FsdGVkX19VPS9IbjECl532ZJRyGKJKBus1B+/fwpGWVBbOS86cIp251t9zvGwXZYAo/B1UTzDUrPb7JyVCTJSzPi7Syim/R429+IUgm5UNiu430LUEQyNOydVuZ0OdgASJkaU5Hjv96Q2OzZ8ujPCmBXSbBwyMhyvgW7BG0knuxsrgD/OiMvUQDFleY9+Zd9snZ2+PoM2aRMTb+20DPgD8cwRArExT04cCHKgYgQy+Tym9M5TaAm7euraG7qhVJmZsemDKNejItjBPh5Hm3An+Q20TfdUAUMYgADL8D1COxwbUuJPAL3ifQIREMTfm3YXpeCxI3cqBDuNunv/mZl3uWZgUdJiiN7QYMDw8/Ch3X8HPAj1q9zWbqLPAtWdkPyKkEe7q7IFZk0u6cQ+tY+sWQ37zISC7G5vOU32FtEql8VPAgPFaN0ood1ee+ubW4xeKmC6WQ7DJXHDepcx9RqNokD6ybK+z2YGOGmah1RGX8dMdj2QkWYmM6XNyFZTjfyRuXBdWS3TdBOtP5ijZZ/USLBMzRnNeypVS+evfOR41AyaFBTnu/sq/yhE4TptyXTS/zGX9APTKmbyI16CPIaPrN0IWvzNYIj/g603BKkoyyravEFWwlvdKZ/U52ZeWVMckMOx+joGweI5LpXn+UuDrtyJTS6PZdr6w8oWLbK6JauFMPjtS9+BnnvbdgPz3kI6WceCJNY7kaK2KzRDm3URq6mgdp/owzv7iFq+NFg05oE/1e3XjtCR3TJM/jsMFH4Eo52STs+uoZ+cDGrfFOvgzmfek09XlMOlYtoRuF8Fv4n9JXWGF1vOVYNTrr7tyIS0qUMbzvX8hsvFGKeBklCba/L9gvwLxtNjwU3g2WojV07+ahD/BpE2j+hmCCnBx149jfgbTo9jwZAqIc9pXvos1xBOv/7OAjYBd1y+jWTyjm16U61ilA32Vfo/NuB87reb5CO+VMsa+6Fjks4e
 Ia0dJf1Q
 dA9G/NWjeho0ZepeJF58Hxx2eyXXiDFOHRAtnec00y/7I/nFXNRuwEJccZYDOH+K0WThMJ70IhJ2rlI482pqrKuMKR0X4+ITyRgGbp0JFAS7itr0Bdr/rN3mmwQ1UizZrP+dlEH+MAMnJgqQ6N/RocSCfepYP1z8bzXXWk+GftQz2SZFKjeBljD8OIMia2kQoHSGr0whlWiXI9AiIkYc/ZyAdUqCNrxLCGMjGCNYUDd79kUtxKLS9vFGPDiolCoFPAaPQv6395+rLiyczGGS6np6kZQpc1cR2TwJs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added pgidle_set probe filter
type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aac84de261aa8..22b785cd11dfe 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -299,6 +299,7 @@ filter types.  Currently below filter types are supported.
 - ``memcg``: Same to that for DAMOS filters.
 - ``pgidle_unset``: Matches if the page for the memory is marked as not
   access-idle.
+- ``pgidle_set``: Matches if the page for the memory is marked as access-idle.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
@@ -314,7 +315,7 @@ actions are registered, DAMON applies the actions to each region's sampling
 memory before starting the next sampling interval.  Currently only one action,
 ``set_pgidle`` is supported.  The action marks the page for the probing target
 memory as access-idle.  This can be useful to be used together with
-``pgidle_unset`` probe filter.
+``pgidle_unset`` or ``pgidle_set`` probe filter.
 
 This is a sampling based mechanism.  Hence, it is lightweight but the output
 may include some measurement errors.  The output should be used with good
-- 
2.47.3

