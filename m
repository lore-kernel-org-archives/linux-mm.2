Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C7AFF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 20:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55876B008C; Sat, 25 Apr 2026 16:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B908E6B0092; Sat, 25 Apr 2026 16:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A337F6B0093; Sat, 25 Apr 2026 16:33:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 89C9B6B008C
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 16:33:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 499FD120218
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:33:22 +0000 (UTC)
X-FDA: 84698228244.18.7634128
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9A53914000D
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 20:33:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WHKr7mAR;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777149200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DT7v+ZBeibD1+dU+3tKC5Zd3lQbqve/+9li1RJa/8A=;
	b=FuJlQpWOlcpmI0SJ407SbfBOzCYI0EVHM5dbllOhVOUBJOgzbbv2AFqbIaMU9iRLubMTvF
	vjTCWU9OUS8PG6IxMUbc+yJZ3Xiurff11aKfReO6DngvXe5PTCM8XXP3vV5G+cab2h+UbM
	pfZ/jMFyxgRCPy6UHYFK1BLHkXVtEo4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WHKr7mAR;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777149200; a=rsa-sha256;
	cv=none;
	b=Sdtiyjr5rOETktUVU48nCh6FJq0e1ep5a+5iSLVR+ojUT1CNHChMEuSgh0vTHuWMsONJMV
	gi5YvLRGkROwSdw/16bqixc50OXGhazt0Fh6qyXjD7jLyoGaY9a49hY7GqRBfqCepMedfy
	Z8X1Ij1NmFtVY8xCNo4d6JBqyIqdLxY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 87C8D44537;
	Sat, 25 Apr 2026 20:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E747EC2BCB3;
	Sat, 25 Apr 2026 20:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777149199;
	bh=Te4GL7YI2bga7ObPIqHKNdIOFUrcsNxgo3oTxgGUtEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHKr7mARiuCYpZMXucBM5HNsb0AisKL+SVs6qyMvTi07bf/1Ls7AO+MSs2jwnVry8
	 PxvVkBnwGZzLB3BufsHaU12SiWfMZF3UurrTQ70NvpfsaE0K871I9ic8sQTgJAPlSA
	 gdtnR8N2RBk/5N4Sv6kHerDJ5S0/otzhXyXEd8Ie/p2mzOiccsKp+JONLRlKEa3O3S
	 cdhVSIW+ai0g+R5kbiD4FHs4MJDoH69DeRLgL6wlVz+YBuMQeM97EcrALzkZM2Pmok
	 mStAcqhr5Q5n8hoK2lCMrgWxSypH7m+shHwp5MY5wtzRN5nwzUs1R7a/N1IqEe6SJB
	 0Wbuga3b/TQ2w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
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
Subject: [RFC PATCH v2 2/2] Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter
Date: Sat, 25 Apr 2026 13:33:07 -0700
Message-ID: <20260425203309.108879-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260425203309.108879-1-sj@kernel.org>
References: <20260425203309.108879-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sos5frdk6hj5xns6ayuodzntaxws1hjy
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9A53914000D
X-Rspam-User: 
X-HE-Tag: 1777149200-556045
X-HE-Meta: U2FsdGVkX1/TdpPrMnWfrHiCxruVIm+PvCzjTwDvgIIf8wpJ3Z6xmtRBOrcRMHNFPDNZBq26rXV4Dnmy+ex6+SxK4ac2AFXOCmBJChNTNmr0pNyVndWvu35FlCTR6vryAEJk2eFFamS2xSO49NQhTqB/xoLhqlYMlZ1ZqAH/SkHObU2tsurxSZW3IW9PbqHjiW6jM2+Ey7NfXkTutiKGqvLUlIO74RBQ5yr1nRxb07P08BzaUg3IbyFst2yVev5c+b0uK86z+42MXFMCV6PVoTGO+YjkMjnKt9oErOKM8qM86ls9pj1aI6Zuk1CYCze6t9dMdReomHqUZUqrX9tI5C2Zm3PZzSzn8g+rJL6Fsc/dNQ1fsZpAoC0pywxl1dH+sezBwLWK59dEGsyyXPgEIM125N/KulczUqCPo1o8hZIJ3LFgChOtGlJhRPrkF4gtZm4/AVgvdzqfSRuM5DNsY5Qgg55ZDmawIK0PNTRqQJrtOS88ZCZsMQ1VRwuxQjgwAma7t1yOdm6hS6FE2m12rVS1yPQP9qc+LPLwYi2TeOFA1VV8vWbW+kz0KFZcBKDSSYlWwbVP4FYfsrap6A+Ya2XiYwDlCBsr7QNGqXFWlRfqN8K9EO9fzb5+x23ZBZpJuVawSL63z9LjWanBnp6A1Iyxq7vwmjbKuBWknH2gA6iuaSY4o2GmCJUhjB4G2FTCfjPSzBkaCSat+k4B65vXVH5dItjIeFu70Qu1tOwr3TDKlD8Cx3kFQba+Tuohgsa+Np9La3JQJ7+0Bczn11oIXLE+r2O1UZ++vvgp3Rf/Asd12l82xcNcFIr3nYre93B9AsEdYcuPRcHy6kyde20HfrwKKwf8tyW5/vslFFfsjd14Yr+0fPkcaBoUxxrJRdCQ7FJCjgUYTLdC3WpZCXNn5yBpbhFMPqKZKi1cDzT7sKiiACF+QAXQCs/lh2OYFCuU5zhKeLde+wbWCi6s+NH
 LV8CSUkl
 hpMiFGLEsC/5EJRwGZAxZbnxHGFFU2m/jLG8zYqGsD49oXBsQkHYlec+hIPhM9A0vyyiMliAs0uPzUEHsNiw6GKAmqMNRMYu4TFq6v9BNnv/Rdja+onYq9Ze/z6rEekktrwbunYC/5B2RvTIg8vO/Yrkqt2wK5bDGv8Yo6VRTBfXKdtyIF7gHVTXgfQzUFrEItLMHenczKUWFf6QeNlJhqaYAHkOTMgcYt2nj27AUHuP6Jm7S/7ZhpllW/k1PYSj6YZ809/v6lm/XuNUDsFCN36fseG4V2gnlpy8v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON_STAT usage document for newly added kdamond_pid parameter.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/stat.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index c4b14daeb2dd6..46c5dd96aa2ed 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -89,3 +89,10 @@ percentiles of the idle time values via this read-only parameter.  Reading the
 parameter returns 101 idle time values in milliseconds, separated by comma.
 Each value represents 0-th, 1st, 2nd, 3rd, ..., 99th and 100th percentile idle
 times.
+
+kdamond_pid
+-----------
+
+PID of the DAMON thread.
+
+If DAMON_STAT is enabled, this becomes the PID of the worker thread.  Else, -1.
-- 
2.47.3

