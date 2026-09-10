Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6005EC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980536B0098; Thu, 10 Sep 2026 10:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9033C6B00A6; Thu, 10 Sep 2026 10:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4C96B00AA; Thu, 10 Sep 2026 10:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1BE6B00A6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:19:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B9E516054A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:05 +0000 (UTC)
X-FDA: 85198059450.28.BFE0457
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 046FA20013
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KT24Wx/z";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/q3LnB7iB4S2lxLwjnJON3GEVnAZWX6/MrZWM0ze7E=;
	b=U6dLyRGF8g8U9Jj+cGPSq5rkWZ0h4QxsQqF9ic/lVnM89uC2D76DeTUHIo3mVHv4xn86ov
	NE0Dr/zWkxLV5LXBNtT/ybUbOJI9qoWuKqsJAksiKagFIA71sVgIEqB2mHwxvYAZRnG61O
	ftE2jy4dECGCklUTaknaw5SObmR7ohY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049944;
	b=FOcuYVsP0oB/0p8Ki4fdZPJa47xIJh76EuC8IkkhziEx34g8mpbTG5CZ68G4yOJMuv+b1f
	mrsMQg8tAN2fRnZur885svS5LNI1anZTG3WQCnvn8dJsLKGVco9zKEhCKaOlyJNLcIJF5e
	E/7YzeEsdgKINL8Zq/IUn/dAuzz/9vY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KT24Wx/z";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 985826022B;
	Thu, 10 Sep 2026 14:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE11C1F000FF;
	Thu, 10 Sep 2026 14:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049943;
	bh=0/q3LnB7iB4S2lxLwjnJON3GEVnAZWX6/MrZWM0ze7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KT24Wx/zHt2KCL2t7/AphHRLxDXprk+KpuhKw1yNSo9OdTsGIIMk1WtNUmUWlwR0f
	 GacOiCngAcMIgaKeDB/qNqj3tZTH/K+Woh5Au4GBQ1wNRwcPZytiIJbVjIeeYIxyCo
	 urlLW+6LXMl3YBtWR346gp7eHmaicWljoxGe32xcVjXCZJ8x1QJ5CKq2RbpPO3Kxl3
	 +3X/Wei40ySnfRQchli+P2grfWt2WPidyvt3qAmHPGjk5hNZmeNX307NElw3nGYmST
	 KxTbICMQEWWXdD6gIYqL16ZApTgwvfG+OM45Fro59rmCDykXlgwcT86TMrvrkjlxjJ
	 SiJfVGHwd9Z8w==
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
Subject: [PATCH 7/7] Docs/admin-guide/mm/damon/usage: update for probe_hits_wsum DAMOS filter
Date: Thu, 10 Sep 2026 07:18:47 -0700
Message-ID: <20260910141849.170896-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910141849.170896-1-sj@kernel.org>
References: <20260910141849.170896-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pc6okshkx5d8uxbcjb33d14xo7pgz4db
X-Rspam-User: 
X-Rspamd-Queue-Id: 046FA20013
X-Rspamd-Server: rspam03
X-HE-Tag: 1789049943-370804
X-HE-Meta: U2FsdGVkX1+9Y2aiNAD771Cgu6U2+4MQJtEkOss0YMX1ZmpdaLUeEUBbigvA/6syHbzcPycLj0uMLmRYD1hkz2zl1srLbb2WODhowuAGW2T8FfsnNfhxC84d40yKWWdr4CAthOG9whoASr+ZPFkyu6oh4Vct78x0zLLrJO5a2xyIi5jRIHTuWxMj6VOT3JWqez+fHY5PXm2zAOPC3fjI0WrpjwygnLTdYwJzEpJXdjuh2nm/j91LRxOZAikkyUqzP0vFd8YBl/zRHm3AhGvwPhj8LpoZfU0AQ3/u3ZY/XTuOmIT/53mcDaSitmIhZJk0ovrEPtcaeIUlh62NXmYYyNpVe/5ci/UabszW1AcFIw9lJyD3Hl/ZfFzeutfBZJ278DG9eaUxdx+RuFN2SZksAPUyncPKYJGl/xqx/fSI+V4a2AiDPHzQPy2cpPH5kBlWlvKBX/3Yf/oipW0ILkDHUTNWs5cy7zix82MCcpVHpF6FbzXUVe3vWBj5QNZOKBrHn7g6Ylb5JCJ1HsauZcOw0WPq62QzyzUFTe6YWuEx70WRRnlxMHccHpsUdC0APRgMVkPS61RBvjeyAYOIDKnELfvESlouQIbj85iKVfJ9j8EaPVeWamahiZjcaJudX2IbTibgUnT4gQht6J+/nyKMvZxZcGSCdQshmJflpXn9A4NzGrfZD5SOi+bPg6tcx3NsaAWE3SbPGA1GpvYGGYcpgQVF6dmfVMs6Ot4rUnIDDm5toG/BNbaTjq0QT/Enl2wIngH59qp6a7ANWmb4cF3B/2jNZPu6500JA7abLPGu6Eylnm4kobyevZ+ewybRH1Q9VB8kKTBbqiB4niTVtCaS4DHbTIhCGTyJ27o7C/lDWcbmQLvl2h6+IFB3SZTROJEm4h1GIffgaUQ/ThI41SyMbN34XkeVN53TLLheriOU0xDSnOV9cZXhorEAbporawjNMGllH0u3UVaMn4OnZEK
 CAt39Ro8
 /n2oOSSb4OAi7gNZSk4zpWH8ChaP4/CfJIqj+QwmEzLNC+UlSPmM4rvgjMCU7ZSviP26td0ui1GPxbf25QALa56nmDauFiS8ui4MJiXPc1jKjvjdnbj4awiZ7TzzyzAzG62C48znvuVHltu2OqZcIetLP3FKuHAtTn8bOuQ6PTVpfomDYHfneUnD9mV85xiagoHXvHZ6944qpVmpzXqBql910M2rOllgkhGGeXkvzKfqc0KuxND5pylsTVFDaMEUIvyzuf+YtBY7S3fVKEf7DOE2q8KpPpTsjOs/Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added probe hits weighted sum
based DAMOS core filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 023c6334024f8..d3e37400367bd 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -551,6 +551,10 @@ and ``damon_target_idx``.  To ``type`` file, you can write the type of the
 filter.  Refer to :ref:`the design doc <damon_design_damos_filters>` for
 available type names, their meaning and on what layer those are handled.
 
+For ``probe_hits_wsum`` type, you can specify the minimum and maximum probe
+hits weighted sum value for the filter to ``min`` and ``max`` files,
+respectively.
+
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
 ``memcg_path`` file.  For ``addr`` type, you can specify the start and end
-- 
2.47.3

