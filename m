Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 371CDC88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926B16B0093; Mon, 14 Sep 2026 22:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D66E6B009D; Mon, 14 Sep 2026 22:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C45A6B009E; Mon, 14 Sep 2026 22:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59E366B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:09:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAB89A02D9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:43 +0000 (UTC)
X-FDA: 85214365446.30.41D7EEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 27E221A0007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gor0uewm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789438182;
	b=s5O+5etWxef2RVWR2S3Xm6Qw05I4XYI8qHt2uqg3bWcXyCIJMM6PTaJy+DUuwfiNHzThls
	MSguQawE2H0+EUK9X160pufdnF6MixfTh6fWC0Xxti8sUby9maoH6W2qb6aAWgFLHflL4N
	fzf22FovGIRNt4QUeqgGpKP+MJlMr80=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gor0uewm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789438182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PbkWTjWrdG2mF2OjLqwQA4JbmDDau4Exk+WU0SHNwM=;
	b=bMiCtfesyFTYjJ4436gHcxocwjFGcP9cHMObiovvFH49ke5WUmoo1JHMFNO87M1Tus4T8o
	8kHwUN9L+y45PMjaiQKujqRQO+sjM51WNuCznvV+UoQA6jSL6aSImgGKBtSvTLOtRnPUZZ
	8Wuf/Xa59oF+/0Nn2yE8NhDpoxwNFRM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67BDC43FF1;
	Tue, 15 Sep 2026 02:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83321F000FF;
	Tue, 15 Sep 2026 02:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789438181;
	bh=9PbkWTjWrdG2mF2OjLqwQA4JbmDDau4Exk+WU0SHNwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gor0uewmTRfc3cvfLmDyqdWVOoPcV/4doLAphen0FnleAlC2SXoRKMtQqgoYXwxln
	 OjI9BPJliXzws9kCgEhhS9nDwzWma8mNCkL3EoZe25xQcV2Rjw0Bz5g3mAlFdVlNVP
	 Fx9O57ZD7LcOGS+nVDHQrADo6OXmwYTETz0ICpuayv4ecgp+EknuuuxMB1P+CAhBCK
	 OU9tGOwEo2KiRvYfLx19WSHah7SYem9pI7+3SJ7NC4fWae262G5wJmFkPOjMBMpUq4
	 kTPVUwjvS2+IReOMN4t33Wxxdm3heXYycEUem3W2SRBq4QmY0UXbCCnHY16jQ6hS20
	 oxLAIWsKJYRfA==
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
Subject: [RFC PATCH v3 7/8] Docs/admin-guide/mm/damon/usage: update for hugepage_size
Date: Mon, 14 Sep 2026 19:09:26 -0700
Message-ID: <20260915020929.102953-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915020929.102953-1-sj@kernel.org>
References: <20260915020929.102953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 27E221A0007
X-Stat-Signature: yuswdnjgp7fb99baw1z5k6qzbrt3ixj3
X-HE-Tag: 1789438182-768239
X-HE-Meta: U2FsdGVkX1/gHhQCoJHhSFkZL6CqXuGvPwrf2FqSkTj5uL1WLjPLWWXlIaez7CbYIJBiXKzGH7NfboLbPGV9JjiKz/VAJ55jzQpwjl8j9B7yGZPaDJKWLqfy2c6hnruykbIfkQCs1suddsRLiVRzo+dDEBm/qSCAJngqT2P78rHWsbPS5GaNK5INQrKmr+nX5zzGjyzat92rVIoDErwzZEqyQ8f8rJWxgqxXkR8hgt06cXgI6dEUHR+IIHb43TFibSdC+WgAGqsnNOnQSnq8wsg3WWmF1Oo5D4VRcGA227fOT5W7Ni9kTU9QQcHmujiVjCn3mzKDjHEuy36x4gnJiiyL4u2eYqo2jArKEoYsVt6hfXQyE+O4iU/Fwaq+m4bIvP8WHfJE6Q8cKhXzaxfJcAI2RioC8TT9UGXr6n6ITuZTl+SQXrNd4V/iIXGa0fZ1BgYPBpdIF60AYiO7HzyUme0td0YohLOduwDPGbeTnE6sUKnu/GFm413qfVGMkZAzUgy8Yq2gKdI+lCDStXIrjk4cf6/5rHTBOOxcdxjpIW+d1YRwbvaMnDkb2Ev1Z6a3k5nEySnzy17qCtOeHtK4lJcOJKM/95htKB7EVNKmMYPyz3AAl97T/YF296APio54L+v6EWShURYffagQfCU4Zjthb2YTkjtiI7NoJqqc3TDIsPA6m06RwjZ/RmOyXI7DHx35g/64Hrm3u37f7hunYbiFBnSsO2BXbPwsCU0YfiPsHsVoFIGm9vPe5zgHj0sJiaklGSVveU/O+jHP8tGuTTRBJ9J5m2f0BzVDgdhGNQ854o/8NuDoVipGMO50jxnFaTfez7c2Sk3/wzZXE3exj99UCXpEgeBqkCmRJhGLKLHdgm1ETq3wCH8SMhWNzlQvJhxysglbugvVGVtzmCD3Rf/vyOVS1db196oNyQsuXEkvXn4eqvjr4TVvYIZsn3fylu74R2+h9KKPHVmgtAX
 PWFzvrBP
 xRmx8tz+kZlBqRT5GNu9H8e2tXPONVIxiTYybe8X2iX6Ye8C+ovxMlp5242ILLnEhCRTld3O2altNOdemsoSl7QLLnkXCI98oITex4zHTQjTgs1cEfACGvFJLA2y3hu6coKhZzSzaGbShwxZ73NrUGINmMN+7oItefcxmUwTJU+UMoEnVneNKIZQlGqr/p0lvZPrPFZ1pI8Qe4uJHrw0qCHtKT1bBb+8k9WbdlcbNGxHJApNf/lwcUy6P4/LFeu0W5M1Ezsc3zATcBjG1SzH3EhwH46TUj1eQF4Vil53hmWjtndXfbR7zcm+Re23gkMrwEHhtKut2A9v9igK7RHLE/u0tM8NDt6Yhwoek
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added hugepage_size data
attribute filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index d3e37400367bd..6b80bce5d678d 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -78,7 +78,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/prep_action
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
-    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -308,6 +308,8 @@ Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and works in a
 way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
 ``type`` is ``memcg``, ``path`` file acts as ``memcg_path`` for :ref:`DAMOS
+filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
+``min`` and ``max`` files acts as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
 .. _sysfs_targets:
-- 
2.47.3

