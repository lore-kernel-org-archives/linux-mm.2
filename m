Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 601EFC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699BC6B00B0; Thu, 10 Sep 2026 10:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64AAB6B00B1; Thu, 10 Sep 2026 10:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB846B00B4; Thu, 10 Sep 2026 10:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25E036B00B0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:22:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5722414052C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:22:45 +0000 (UTC)
X-FDA: 85198068690.11.C77E700
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C4E29C0003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:22:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PHd53DEN;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789050163;
	b=MiU3S+zDoOcMu9/AmJg3cF7FfIqqQFxM3O/RebAD4gwbeZN26R0nQwbOZmhUik85zHuA5v
	5fFdf/PtsXoEwV4Kk1jjpeUYcjkrBLS9RalOP4YJPuT5BEibgszsGy93LuMXG72zsXmngI
	dDLeT/PSuWeqTYaiiZEFRnRaFnv2fUo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PHd53DEN;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGHkp73SOXJ8OAqpC14uJPbey8Nk7EBIVu4GrdElavM=;
	b=YrVPC+Z6LYYqoEJ48xlmVugX6/177OBar7z1OrZaXwUOD6aGQ1mS7sbPvxpPGEYKBb/tu5
	sJmKBHrJirKimmliFcJ/sPO1o9A0/xTkF26/VKqI92t6g8KCWvIt0G/Ule7vLG7YCFhQoV
	w36dkfCgtR6naTg/S11vMHv8enCJi90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CCED60211;
	Thu, 10 Sep 2026 14:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7331F00899;
	Thu, 10 Sep 2026 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050163;
	bh=YGHkp73SOXJ8OAqpC14uJPbey8Nk7EBIVu4GrdElavM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHd53DENUTYY7vRprpcZNyTffPeiy3FX1l+LpLOaJ55At22n08OvMdQCJlAXl8F+8
	 LALmvYW7gCkPjpkRQtX2T3Mcw5W0WpjIvwQA8LRu3yys4AbCX1J4ynA71Up27O4MA0
	 6Xw22Nyq8cuPVGOBdaePl/56vY0RLZcutZTcebwJvt7tpQUnUmhjIJ3JOixbHVP5aH
	 Nhghcv3il2U11FMStdmxyP+q2rDqXcAaeiK7Dv7ghzuCS+hEdUboEgtMUvzhoji3/m
	 9OU/JJe4K8worscSK8pkDxyxuV4LQZYh9+qtGmqHrJgASDlrAQhY2AY3Wf5aTfAViI
	 +e+co2v/riEmA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 5/5] Docs/mm/damon/design: update for pgidle_set probe filter
Date: Thu, 10 Sep 2026 07:22:32 -0700
Message-ID: <20260910142234.171562-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910142234.171562-1-sj@kernel.org>
References: <20260910142234.171562-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C4E29C0003
X-Stat-Signature: 5u1zxom3wr7ao3z745mjr4uuombdfw7o
X-HE-Tag: 1789050163-24603
X-HE-Meta: U2FsdGVkX1+W00Q0hfQ/8eUoHRW4uWlCxiLhw5KGsdf1Pumy40MPal++rmvtuu0QXWesAdNaHpbeaQ00KIIcFhz//0tdD54k5IptQKpX9KvZXaXtjRx8Ffs0+vKs0EyVdGt35aDBcy2NSJ7TEQjylehS/5Vw1XqxE2+nnv+R48ZMedBamJcR2L1ZTRCtguqooqNe/uPd3GIx5+2q1EGX3Ib6Xudc+nS6Gt1yGy6VV9m2SGqR7zqS+K9hKPNjqlaMCHc744DDhSxsxOxz98Zss57iQviAey0d6BsssFlgiby4FfW0J8o8Yi30i6uXqo0uWnUq+9G7/PVTTILVFzTKNMdLjdqlAFgIfbT/WjFnajKMhA92EX5ZgBEljJYJDamczaPvAYIe/r51hWzLyNwe57WuiVDm90lsbWO9fLq/ikHxzj9YLjtUBA+PdSrOMzG2gAIKaPwisSG3ZV0oV+wEvACrjKpIsNo+Xdg9ktRoozGzozedrkn+u/55IOluvTUr87eAu8zYRwNc73VW+MAvnXSH/Zj0hdJnOShYn1cDqrEDLq6pVY6shtLmLgsyJF5M46IH2GLISD8eTVvKtqC1M5c2Ul1cMNDBhiFvkWWZZzY5/SVujV9CX3hAOa0RQhMSgHSUsc2fUuctybnWXXTQcQYq4ty8Z2PZ9CVa3H+1nGNLo5pMzSPRmB1S3taMLWML8sVJuUNX6sGqiy8hRpl3VOX9DKlltPakwbAzH0JlNJ7zHD/yjBMwCHyaE/Ig8TKSEIF49zxedwmw3R0Yhi9dlGK6y+Rqf6XdqJIRA2Bk1eMg4agdo8xUSMu4X8w3rJWDFjBjNycdUqT6liWipiL3b2D8R7S6qJdGF2oA+bm4kCeeZm1PUTow8GrkSvntdVJLUR72TQIa5BMBElmAHVewh1UbvwnqeiqdlQt0NdMpa0EdOpFQbzhu89ArnWFSlQsahJvs3tH6vo7pLhIgGRk
 8CwofJq0
 ++ffgW9bftZh7iTaqjTlTrBm5P+75k8cTjUP1P77h+MEjr6zZ8wN9WqtkSx2hZ9KzRnek6Ez3Egju2/qcLlXWhiO/KwPsZQ+DLg7pxLPjUbr8S5t0gtz5mrF4wurZjOyMLldyxG0aFGjCclmSh9FcfRCk/QZzRTmPI43gMmYqSU8ucdfzw++XfscO+7bTcPUBTVZUMZQB5KtL0D9xkipR/cWr6c+zN/1LcpPIaZJyHcGYq2Tm6mDNF/MZh3tD2TrxJRZrJy7+1VTy5qrgmqnEy229XQ==
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
index 8e980dde362de..cb116a82ff20b 100644
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

