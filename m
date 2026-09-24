Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6040C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3D56B0096; Thu, 24 Sep 2026 03:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCBB96B009B; Thu, 24 Sep 2026 03:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B089A6B009D; Thu, 24 Sep 2026 03:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC3F6B0096
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:33:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2279BA0297
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:33:25 +0000 (UTC)
X-FDA: 85247840370.15.31DF0EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id AC8B51C0005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:33:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+dr+PLy;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790235203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EJpjMTknjAg8m6edUWX7pkcAao0lqt/jwCgbAjXhxuQ=;
	b=8mBRbTfmj188CFhYkfnfj7r/2pvBZqGYIfHQrVkVFQ3fEAz0Xbq3lfc5mdT9RsGTlYsnp0
	HSYa/nc8ScCea7OSM00gI0bQn77TuAgrHJlxXvHhCx61sffcRSdQTAPuWgDfk2VPUhi0rg
	pm+rhRBzZxR9BiafjYLIOAhbeVBFUUA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790235203;
	b=U75dPwc5qsp38bedaqJemS2kn5qaJ0lKa2vZ9OoAQfSaDmJED+Dc6bqg4wfCs81yeHa5ka
	r21t+03CIFtkGFToILESLMzvxpZSmsqBYGxEJ+JOVefwm9cBMSfGZbhi7AjRnu2zYNwIor
	lLDpHj4xTlSU9vXx6JGnPk9+zzE9DAs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+dr+PLy;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F76660232;
	Thu, 24 Sep 2026 07:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5FF1F000FF;
	Thu, 24 Sep 2026 07:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790235203;
	bh=EJpjMTknjAg8m6edUWX7pkcAao0lqt/jwCgbAjXhxuQ=;
	h=From:To:Cc:Subject:Date;
	b=m+dr+PLy9r9acw8UKcqnqXzdbz3e6yLclZOaNz7XkdkjSwCPOFJZXcDvP+iFKZyLF
	 wIihObsdCvYtN9Uwo5LEVTSg3/SIYkfaGSwAIOqFcxiBttzJtwAi7fW2Zmv2vBK2yr
	 BP01sa9zJMufH3Zc8YDHH+bzS7JwSCTHYbgSIes1zQmPqNJETpTL/DaAalemJWFSsv
	 +YkngtOmXhVhqI+GJbjAJ8b0TyQ0efnxr4zetLXQrwP3AzmjJMdwsKVUxbE0a9aVwo
	 pzwDDxEUG3ydgFVGWmtlhsHLQqkqU+3iojEM6u7iGzyZghpCxEyoWVnfaZEbgCXYXX
	 fO6EkZJGyg+nw==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] memblock: add missing HugeTLB flag name
Date: Thu, 24 Sep 2026 10:33:07 +0300
Message-ID: <20260924073316.2325178-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AC8B51C0005
X-Stat-Signature: bufqoyogy9iq1bxhc6j4mw996r3kacb5
X-HE-Tag: 1790235203-399536
X-HE-Meta: U2FsdGVkX18iNCFvoZhr8zDpAuAASJz232kf0KELPnzgfMBMjrTbWp7EG6wga0TjyAllqWroau7fDljJMhLcSngT5QEc0noc1PucVJvn1qUw0m6r11UjgxgMJdMVMVVCo3SixNEHeMVKlrt9ARdZieTMkLdHzvHNZpkpCetOYIvBgl/EKcgb66uvD/V7xYWaFp64hijlJT6ZbtlTG07boBKow1R2JkDLxR7OkRAh5zhZCdH3nWMlXo3wsq16xz+IBfbntPwjVzFogjzGuS0txGTBQhiWeO65mGOmn9yKgQtxjhw0cil9Ok1aGKL9/Wl5F6xIvPZKtb3cQvORSRV4RqfycBOVqC3rq7pj4LrcdsFPyI0GLR9YplshNx3tKpZHsAefdPdXdENdfKSg4cBQ4F719/UVhXkPrbzviJkAmzFa9AGpKIS+3RasCTWNws/Zbx1SLJ6almEZmQQmqYqYFIK8Jls+dHsacPCErDqkdmmxj/ErGl2lhZGZrOou5QHaKs7Wk6APo4bDKciya2/8GbZArcKwyjb4h2e9d7Epu9Th1mtmQx3fmR17If9ojP6ugYzYCE9oRHHZE04kkcUHBK9UV/CjiqnIh7Bd5dW7ozQj0zkBEQSeLNQNMpb1iJiLqabnKmBG4iQ5mWqBfVJGU44FVUWr0tAeka2Yd5ziT42kxmSnN5/txOuQDkMDsP7CB9OqZNBJQk65LPg1QwA9FN81RZXboGADgnUPDeKxpwOHoi5hBrtrp2ouFtvpotu3CCVArP2ikCKPimHNymdaOLuNDNmorVYLn0spb7gIailG8jidzXbfEMNzuF/voz9RrjkRjkWE6yxKZpzBzxbfLECeHL2SzKGi2M/TcNU8zzHf8UR/dJBYAobArSf4S7nW/87QTY/QYI8RtT4MWvY7BtBMAIE21eLjLQvvzzUzbGVkNIvkACP67qcCEArfYVLU6IhvRap8y7jQpSac5se
 d7OfLOXP
 fjcgopt0wj25Y2rUFWuJLt2ag9TpHdw11IBY8GRaBFdGOvwp8Z+pxD03Rz24PymvxdVc+3Df8FgJMYG7TYoGlNL0vUZB1nL6iI5btgdF17RGhG3KNGio7H/sgXa9FggHtMHkbxJJoanNEnBZCrywd0CBJiNIhtAnxMMohLfR0UImnhBIAoZJTJkC4WMWD2cnjTTAlF8uTjYQFhBtVQ+OtYqxU3WO/s6D4QX9qhY1YHyyu+jo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit 6e33dc90df108c76899dc544a42d17adcba61668:

  MAINTAINERS: update memblock tree URLs (2026-09-09 20:28:14 +0300)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git tags/fixes-2026-09-24

for you to fetch changes up to ba13f1f32d96d7ce9069ae4f32404ecde8da89c4:

  mm: memblock: add missing HugeTLB flag name (2026-09-15 15:54:35 +0300)

----------------------------------------------------------------
memblock: add missing HugeTLB flag name

Rework of HugeTLB bootmem allocation forgot to add the name for a new
RSV_HUGETLB flag for proper display in debugfs.

Add the flag name now.

----------------------------------------------------------------
Meijing Zhao (1):
      mm: memblock: add missing HugeTLB flag name

 mm/memblock.c | 1 +
 1 file changed, 1 insertion(+)

