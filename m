Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A34C88E56
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 061786B0099; Fri, 11 Sep 2026 09:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038F56B009B; Fri, 11 Sep 2026 09:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91F36B009D; Fri, 11 Sep 2026 09:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4DC16B0099
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:35:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECFFCC023E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:35:53 +0000 (UTC)
X-FDA: 85201579386.29.363EBD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5EA6DA000E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:35:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WuqZzmWt;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789133752;
	b=DpELX08VDd+Q4rEEsKZSTuXKFypiGFVE9pMTgKBdT3GmZfCrIG/Gqx4DUHmVOFo7/r4TAi
	DwDcWmmfLOSdj1U+M55yEVYkL5LvtHCAP90UkDBBtNP7GGp7Y9WpKqp6ub6IQqGG9NAt0L
	5CBcqkqMoBlxB9/CS3q+jyKrfD3LeRI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WuqZzmWt;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789133752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GgGvB7wf3jMu2SKBD8yyeQabKZY9LxyLIN+L7CC9SH4=;
	b=FDp7CBFBrL25pYlvabz6fDXnJwujjnn4WOfASm07l90PYCXiEW+J/ur9K1tGY0ztDhMiIw
	vN8NOV/EwwK5dNw+VFYgUdWkUzglIyLAnE6uuakivkbziYCxwDRtF4FezWypw40aarOMYE
	RZQLDiZvkYzrwWDQg43MWYkVYZVqvdY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C49840400;
	Fri, 11 Sep 2026 13:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C101F00893;
	Fri, 11 Sep 2026 13:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789133751;
	bh=GgGvB7wf3jMu2SKBD8yyeQabKZY9LxyLIN+L7CC9SH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WuqZzmWte3bB8Ft6qad7MYpkg/9RfskcX7IDxobWRqOvNgeD8tGWhYXzdKo9PxsMr
	 2HyIUNat9KztrqS3dCQOoSOpdsB5Rx1ZI3NBkSn1PuY0xOOmngDOFnMfRIKJxRS/cH
	 gRTdgbrETaoPK+AXcXPXMo6N6EztBKkCVpEm97ajoz9nK8y/6sFJoAjL9rSFMM/1+d
	 iBy4MtTuRNUCjytG0kVee3MqTIx650ie7Jjsy5Snv6RbcptN9fgA/XNfOBb91k82B0
	 7PWQFpjtL+Q9xQlKIy1yzAYs7YGo5xFX1OXL603T8DXiBGmjneV4Y2z2Rb4e3Q1s+F
	 JdUS+KQBVXGWg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Docs/mm/damon/design: fix typos in temporal auto-tuning algorithm section
Date: Fri, 11 Sep 2026 06:35:43 -0700
Message-ID: <20260911133544.91871-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911093314.156875-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5EA6DA000E
X-Stat-Signature: tqca6dtkrxrg3peqqhn6oxw86yr8p7ba
X-HE-Tag: 1789133752-753987
X-HE-Meta: U2FsdGVkX1/IQkRlXBJJCZk0is2gkdezn4DfWkxKVRWFiD+0pTv2KnOIxE8CKVuv2c56CHhKrbb3IfA5KuK82dCUtSaXYA+iFfT/3bkuSovD1xe7BP+2ByV8nnPlhhJ6J8wtE7Rcnvwahn/suZhTA3RiqzEb7SRME15OpzcSEpoT0MIXqsHQ5FAzF+P3pPzM6arUFkTbdsCIPWMmW9KNLPfdjRkJ9myd5jmYAY3UyGCjUr1igVDzj9NVAAPIMnqhYdRvccRb9gf9+ZIbAtQEepEdGsKVw5WIGy3RrVTDgII90vGcbwTDB8ytULIGYGDcXuRpyXFTR0vy0Z6uuHrM9UMqUVfvowlMuUo7R5IfRJIlwkzXEbr8CVu6q7Vt1678bhgxV8QR6QVE2oIQrriPE4PfBy5AYJOgptmDduvpyoYHsg2zYv9ywFEvsrdHdILmIyoo0zKoe8NV2u103kJPEwQdVEUt9k1Vrkf+VD0laQ0x2xzQLA7pwjx0coDW3A1orRwVeEiHzoS8P4nhwN3wzzReuxaWQbz3lsE51ssNmcEJUzy0COZS7RpOQi9tv3zy5Od7YCo0j/IWs4OhX7EmKzseofGD30+1/iMoVJIWE7vAyzFoS75atq4D3AzFL+NspjCSkAp3wkAfDP1m3qZWFJRwN0vA25jKbaivczEZSYpRxzkg5cqHsSTL7nX0bSpJgM7dl5IFh3n4APdy6NIunBa6wf8baqfhg5RbleJ1rBnuIFG1gZu4pYllmJMjJzst6+PmxjErxzPOcHVCwsgVtGdiO4Ktn8ANNh5OPF8PcT9GSQsu2kjO5lgPLW3mA4q9b+lWtwNadHskSW27wLqJ11XVu7uruL0eraqp+YYKy5NVDAIiiKSRsfr8wQw3LgSDDlV2m0ReacxL90EaOjSdM/x5UerRbslhL/hAL8gZSCxe+PWbnBbpNf2U6aG/9U5UqAI6g8ewSzM9ox2k1z/
 k/PLmD3H
 iTEs7ehtyrF7DjMA0Dmq3MEsncArwYetghAMCLMaemPmFT2Bwva2/XHbFyo9usLfarjaaXsbdT6g7voF+hj5zRDklIjDq//rfeVpey5B60gVb5wRpJCFnHu9VaLdVbWZQyS17+j9XH0XL30OYtNxcPu9fzyhug2Y77EH2PsMb+uZIwOj+kmyvNz1025UNaj9PH46RsFTyTR2qEHbFY79U/LeBzdA/S2u9kxKQs306JBscV5KQt2mSc2bVcuB/ONHe2pKknJJarWT24NgZTFgoNP6zcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 17:32:58 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Correct incorrect references of "quota" to "goal" in the temporal
> auto-tuning algorithm description and fix the square bracket formatting.

Goot catch, thank you for finding and fixing this, Liew!

> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

