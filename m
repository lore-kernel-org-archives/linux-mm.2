Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20017C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B216B00A1; Sat, 25 Jul 2026 17:02:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4CC6B00A3; Sat, 25 Jul 2026 17:02:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB106B00A4; Sat, 25 Jul 2026 17:02:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2FC6B00A1
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E95681C04B4
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:41 +0000 (UTC)
X-FDA: 85028522922.02.D98C220
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 737E8C0002
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nrw9fpOj;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DL5R4ny6wLlfbUwSF8IPEKmxBCfPJcB+Bwsr8pb15YA=;
	b=K0g5YB0gnXJVIkwadxd0JDPD7+tvIwsaWskTjPUjIpyB+uRf0bzBENTRIrNOu54kNlcNbV
	cGsts+o/1wZIbvelYbmq7mFVAixGr76+FXVMo+1c/Rb7IT72l0AzkuIYLucnxK+H0FTDTs
	p7RD2SjReeYKkm9a64RdTHTxr2L9ag4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013360;
	b=ykS8TaNOlpnyoJDqv9dK6DrgkvJaPy/ojh1DRzQiQgZ9CyTGIvGQyb9pmF6QNYuzsWgt97
	6xJYs07X2MTmOTtz+nZ4USoq/mnp0DeFlk09oSlzd3mPg8UVpWOj9T/aUr+rVbsB/efWXF
	3/VxHtH7fzboxqefIu9m4GuPn7yxuFY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nrw9fpOj;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47E9C60A95;
	Sat, 25 Jul 2026 21:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2DD1F00A3F;
	Sat, 25 Jul 2026 21:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013360;
	bh=DL5R4ny6wLlfbUwSF8IPEKmxBCfPJcB+Bwsr8pb15YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrw9fpOjsyc5AXWhE81QJBrNDwn5daxC2nF65w3wDf8NRQdPlkuA9YG02kY3Btn6j
	 hoAMufMpKL5uR6C9fraSoSoG3Mox9OcYEdtnEFQB74JqH2PHtBR7d2Tjf50l8p45d8
	 UspB28jK44t/VoZVWScHe/jenTgRdI/2rdCyL7o6zT0MlW6ft3124sfKfHkCJtapE1
	 9YNLwWMhgKbbxBChIJyXLYNi/usVcnteqo0xNGoJmHolF+ppydh3P2RifoAf5NlNVl
	 KLB0cPx/ycRiRNULQ0C0Wh257Rp1mAie+9AEHzEG4fDG4POuDTyr9uVai09VdGD8nN
	 1pM2DG2Ap4LZw==
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 15/17] Docs/mm/damon/design: document probe preps
Date: Sat, 25 Jul 2026 14:02:19 -0700
Message-ID: <20260725210225.129944-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jp1gbg85oo3uhtnikcyig9kqakmgacx7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 737E8C0002
X-HE-Tag: 1785013360-763503
X-HE-Meta: U2FsdGVkX18kS/5+E3UVq9OnGeaZ5Zr1bx7nO3TnTSrKvyFZ/EckYjU+QamR7e0Z6gnULfoEo9auKW2ISAk8NV0iXx5vCMCTqBuZlaUftDFPTsf/dmz0PbQ4bvcqYCK/ZvYLtEgvX+a04PZbTHpORR8tLQRk+jZcdsLXb2W5HIvFmhtDmZIIP96hsPuV/GpatUoGfiVwbX2OLhQNv9QM7EnGrg7G6BgVz49e+iANq1JHLqzXS/yQhQvpx7nlwKo0bXhqzVRbeTBl2QxNaxjlnZaI96lUheeiRvBSjquKAd6bBpyOeLvrEse25gncdzsatE5rqe/+L5/0oRpjKiB+r/Vl9Uplxc98ZEh1AZ+KSM2d0TqY/wkTrKnfPcecPT50Imiq3KivbqHFSQqIhp6w/YvwWAHyYKNTjWsNhze5xSGauw5zL9uLwY9BYAMePopewQqFiUTlIHGfxDYTv61riCSMqxg/nQb0tzrWR44RHvMdjOpL7C6Ozb9lpugCydj3+CEaNYg9jCxrBcgKr9witd0M6Rje9vOAFwdj14h8RcYN3zI9CyA6x58xZfLiusBFeAq21TTaI4Wva26BbEBIFvD6n7kb/8bjQd0XhXcHbbKYNljE1YgCJ7z7GOspYE3EbcNJqlSHwHb4GzpZA7RkTSeu7F8kr1jniWF6cV416vQbKiouFMLtEpzx5eb5YtMDQkRkmrBqMO68VCXoi1FF62HuYDzamxZ9Kba8CuXUz/pn3cxjEecW5Su5Bhym5v5hZOMkYtTvoNhDBwtQRoNfdqF97fOqfWVzfs8jwMTThf10qUv+Wv83PpnRIkeZE/CkXo5kaAfyN51eohM661miJiW9VP0OLKRMurwzr/C04QGJ7kCVasKhRSmL++FDBTsIPHEROGdaYVme0z43sRgO+7X16JEB2XYSbGnqAAMNosQQPkpoJaBaWCVDzsOjooCkj+XB9yQI+Dw8IICCWg7
 RZsXSpNP
 2sdfMjHYi+NQlkdIXZQRuwFf//M53BaS8q0T5kPONtEXbk3F7WcuyffKH3q0NhI/w6f25aB5fn2nErASC3S1aokbUP+UnlOswtwGGgPl87CDbQNyzzzAbsMCwPDSNYq75CNgX18fv8LSlyFPJf74toJ9DVApur872TNpoCQz4BsPHyIu5zJ1tL9LYvpOEhDn63yRfsfclB37GxKhnabrBUX2RiEXM2Vn67es/ab1zHjgnY/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added DAMN probe preps
feature.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 12a2c3f81a262..5ce777c6b3f30 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -311,6 +311,13 @@ Users can therefore know how much of a given DAMON region has a specific data
 attribute by reading the per-region per-probe probe hits counter after each
 aggregation interval.
 
+Users can optionally register probing preparation actions per probe.  If such
+actions are registered, DAMON applies the actions to each region's sampling
+memory before starting the next sampling interval.  Currently only one action,
+``set_pgidle`` is supported.  The action marks the page for the probing target
+memory as access-idle.  This can be useful to be used together with
+``pgidle_unset`` probe filter.
+
 This is a sampling based mechanism.  Hence, it is lightweight but the output
 may include some measurement errors.  The output should be used with good
 understanding of statistics.
-- 
2.47.3

