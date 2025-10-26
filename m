Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BAFBCCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 18:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D218E0178; Sun, 26 Oct 2025 14:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0808E0179; Sun, 26 Oct 2025 14:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25198E017A; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD2908E0178
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A3E31A02A5
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:26 +0000 (UTC)
X-FDA: 84041085492.12.CDAAD61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 157601A0009
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=huyxrle8;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761502945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iyUFmZfYvd7PlI3XW0pd92pZ7Oyu0EqJ41Gixt59Lsg=;
	b=TdPI0KS6jW/d+Jwg+ozkyyeyLnqmDTo7lFIbzmphzFss5tpSw1UoHlmEDDyypKCxwFkYuc
	PPRNy+czsE95A6nXmNYN7l7QttrGizWR3tBjSYaeHkucepwuqBv4NuAd2/bpM79ssDRKnw
	sHmgl5z6Pe+teGMMJKiOq9BYyXhEaDk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=huyxrle8;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761502945; a=rsa-sha256;
	cv=none;
	b=T+Cuy7XR4juc8LamvJwPWDQiYRcBy7ZT7Tkk/NlEJD/BTpYiHtsTBhABNpz3USoGBy9LaB
	NGNAKh4sPJhd1ocIpbX73/1XEtAtCQnZgep9MKjYVxO+LufkkWVOfNRypOukarT4hmXPpw
	TMoqdd6oQAMqoVuPffqNlzGfB8Hx4ro=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81F91602EA;
	Sun, 26 Oct 2025 18:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99EFC116C6;
	Sun, 26 Oct 2025 18:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761502944;
	bh=2OxNFKvhCT36RDHavLAyK2OGp+6UAUMynMMToyr3JtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huyxrle8m2VS/tPkSLY/a3secq5QD21olmVFnk+tEm911u4eZdB6SU7qaYj2eF0gK
	 gpWzMJYOt8vybSCS4Y9miij0pJiU5UalTlQqfGAMVtlAcvma8QfvcjkWr/CpoT1pJL
	 6Xm9qn/NvEhe80WGuKeg5NbqtDgkEyNnvWAQZZaXkWVpuDOjEK5lTOnWQ0uTp23eXX
	 JsYVdqymwjAyDGNJ18VbUseyhj/hR3ISscQ4nLD3WzVku3o6kRSfGTOrBJFl7y0tqM
	 6c/7uEB1MuqZyTgEm+H3vvedJgo39A9T8kMgVtllJ2+sBtpuV/N+8FH6lxT7DJwNM2
	 JfgJ5Skle1M3A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] Docs/admin-guide/mm/damon/stat: fix a typo: s/sampling events/sampling interval/
Date: Sun, 26 Oct 2025 11:22:08 -0700
Message-ID: <20251026182216.118200-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251026182216.118200-1-sj@kernel.org>
References: <20251026182216.118200-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z1ckouy1uz95zqkqby4563u5uf3tt7hq
X-Rspamd-Queue-Id: 157601A0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761502944-352659
X-HE-Meta: U2FsdGVkX1+OsG2tc1GTuGzIQFV8poxtS/Wb0S+yG4e56UXG2Sz3MDIHvi0zX/Gbi2CP5Sr6XVcAO5EWd8XHgXUcNAkDHsVWQHAwgl9LaN0Q7JC2KFCO9w4Aci2Ih/yTaGO1M0HifOojPUPT3MMwNawTQhq0YCtELo1Zg0ozdvbv5nWmJ1crfQqoYsIQbhvCcbj2aGpfC20JeTy3sLaeAkfccJkkPM333IkCQUZfOygsBc6oz31st7R8lskIp/cq9yZFfUXfc3VYpRp+zTzFj7zL9Nf5hBnPboHp6n7D0cIaoBLVLK245XbqOkKmW2mIVsfnhYGgOTULbpcP2j1c5LIC8urAyfEG3r34BpnHnZ1XtDpda6geYFDJdgJJKdqGtvTwQEdb6qvxIdFjnVFuHm3zJ/OkP/2CMmnDErLZiTnqlOTDIJhGjnz5wAL4WrEh2G/h0V59HeiKAC78VU6sb9sQXvYU4ntNugpuHiOZDnBuY7LBof656P1jcaOgrl5Kr2O5pZ79klZwEkHPkmV/1EBWsmT85ZxxkfkfCTjMC893EGjyS0QZ2iOzH+7VkGH6Vt+02VQsXyyxtDh69CTTk2eG7UYONacN8Dhy3BdEU2Kf93GWvsIQAj6RxqfOQvht4zJwrUqKeHX2uBVItAJunTQw1A4wN40at1vIe08j7q7c8y92iyB6Jd0cmYKuW4ZQECYMjduLEdbN7aLc/MXc9DkDDYpuSJfNOEqbr4tt4CQxj4lG1FXkHQq7Kiab8CRdIZHIqIYJrsKUo9twmDWCsM2ZCRSB0PTf3KUl8fUrR/m9qfsPQU3wdrsyy+8uUCiiwUskpTPmpe6ffmgsuTSNhC0mSkw818woTitoJkrTXm/rskYB8w9EQLRkDznwEicv8ea8E9oCujcTFNmeTcLPqPTGfYMaDoDjZS4sHr2hgSb55z78oohoP1o7+Bhi2jewWNXex084ohBMohguLXy
 BIJ4TElJ
 GLvFvfeP4Y5x2ZO2FNACgS/48QsuQXZdgA2Dv03raFHE1fbSbSCq1+TRmpeuOA2X8QyLL7W+ESxPiAahM/sBgQhwz/uATOHIhn0Dm9yxQCxcWkef7Olmcq7dsYevrntiutqBXHdJW/YF5ZWtkaT6ovcfoddRnZqItKg7yCSBMZbJYD1gVxBh5vHsbJcjGzkzmfVadTPd7gto50RncqEv0eOvwKxa0LbkxT5lt29no25K+waI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is a contextual typo.  Fix it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/stat.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index 4c517c2c219a..20f540a9d3d2 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -17,7 +17,7 @@ DAMON_STAT uses monitoring intervals :ref:`auto-tuning
 <damon_design_monitoring_intervals_autotuning>` to make its accuracy high and
 overhead minimum.  It auto-tunes the intervals aiming 4 % of observable access
 events to be captured in each snapshot, while limiting the resulting sampling
-events to be 5 milliseconds in minimum and 10 seconds in maximum.  On a few
+interval to be 5 milliseconds in minimum and 10 seconds in maximum.  On a few
 production server systems, it resulted in consuming only 0.x % single CPU time,
 while capturing reasonable quality of access patterns.
 
-- 
2.47.3

