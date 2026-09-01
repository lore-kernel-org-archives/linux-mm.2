Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 622CEC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 470F06B00E2; Tue,  1 Sep 2026 00:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 421936B00E3; Tue,  1 Sep 2026 00:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F826B00E7; Tue,  1 Sep 2026 00:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2C9E6B00E3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7685C402F3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:29 +0000 (UTC)
X-FDA: 85163927058.29.11416EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E0D57140007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SDvIeati;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237267;
	b=7gFV+tJTzQ9Mq16b+fQUtiv7zPtJjtxB3KpiGSkpUwxRaX9WsEU8FG0OvxlTTrvAYeaUbI
	0hrvkrSorp99iyFqK93R3W5e9RcIkcB38fMIfyhRHo0Gkc+ikmlsph21claJhBfcC95uWH
	6IZGQmLj0m1v7Yfk2XFOqugX6uUuCpE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SDvIeati;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vf/K9c9fWpOSUYmz+e9QIT0AziWQ1IhtxaGnZ535xtg=;
	b=4wnXjAOEy9xbRVQj6XbQk8Djqo0RzSomW68mqp8MwVcICQ7fZT8uFkIygZ7PAU324puVIv
	o02dsHhvVG2NXOhOMTH8YdSma8Nr0wm2QY9aIkpopNICIjuWOFu+ss6mkTlQPhQWV5dadW
	/XyXWRmUWx3QM0o3Sbp5TIH7po7M0/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 355BA4013B;
	Tue,  1 Sep 2026 04:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AFF1F00A3F;
	Tue,  1 Sep 2026 04:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237267;
	bh=vf/K9c9fWpOSUYmz+e9QIT0AziWQ1IhtxaGnZ535xtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDvIeatinPoWIpeGqt3q14CdDYcaOLS749sJnD0rX7wO4cectL9C4yehlVJMUHUBN
	 lKmNhV++GF4JSibAEbZp4fRHmvYC2KHHZ7kEPAODC+LQrKW7JW2Zkj45otANbRlgpG
	 icLgGmFhiMioBTVWiPWTzqxqi1I5bq71yTd/ZK3qdPKL0wiPusp047xGbk+Uo+EmOE
	 xBjJc9x1ZXal81uYnnJQxhND/oQbScxZz1osVNyJrqocxzimYVvi9cHRO8oaNqOJmd
	 pZlxJPGO1h8AzVrUgpTEaQPv9ofRDiQy2QJUU+MFsV+6CJkk2IJIjCDQlcksHZT3s4
	 ytk+n5n4ix2ZA==
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
Subject: [PATCH 04/17] Docs/mm/damon/design: document pgidle_unset probe filter type
Date: Mon, 31 Aug 2026 21:34:00 -0700
Message-ID: <20260901043417.2165-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 758u4edjekunehzzeh4knm6kfi4kck3z
X-Rspamd-Queue-Id: E0D57140007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788237267-732556
X-HE-Meta: U2FsdGVkX18LqtCE+j87QeE5QkMvMmhcdSD0tRWFtqDN9LmsYaVawQPFP1IWYEpoCOC1W8NNyp0HkQZsJSDFaxEsWlU9RPZofqWjNF6DrE+DkJtxtz8L/QZL5LTHoXArKOUIF/LvBNFPZNQ2RfKjJOLwJmbBc/bR/PPkJR0XGrGlaX10YlqLXb3HOYxkimhvMHSPFdxJWBggn3Gwb97RdNzfThdVM+RkMx6U8d+/0DyH+tlxZjS50FMLuyqh8BkRQuKRbKBD4xq7vB82tXBkkh3qypy/AobgwIAZBVzQxKH2EpW/oGGMMbBO3Vl3xEaLRBdNEO1I93982QEx+0hXBTPSsdS329WGUjwpiqMDKj+I7bb9YExnA/7lY1cKSPW9uvZSNiL6uXbnpCJ03HDBdBzmbifNP+MM+TR2dbn4ThcnrTDpD0iokaRxY5CCX+o/8sowWssQRcXy2D/eTJNdVY+NKKB0r5uT/hrKC+MVIMSBpG/cqG89QPNBr4ovsqCaGEsQftfL3Cp+ftHOhVQH15YM2+7Qn7kTo7Io6EM7VXUgAcndZqvrcDwXAkrHDHZOUb3czlM7pKQ1aoB+A2WRUjP7OnV9OKV9vnUIU1oD+zT5iu5ZjhjDSgUOCpxBV5jOqeu+EGgihzSnKOsqqISqLtMTUGHjjlyyCoTMxCGLQojCpXQ4hslGkqBziJErexIrp7nWnhgWyQoETJWi+kJgMdC3ePv3d+zMy20sSmzHelNVXt+ZXFEAjQBcG4OMcD3lvL8GhWolUIEeKwFRmIKHZZMVJaT9j+vWLVZGKYxBxGmxI17k1fFs+B/RZRWp5X+SjCxTuphFVUJY4plb7arR04sk16bESjrsUzZrJ75FJhjlCrQB9TvgiILOerl2hJFJY+QShg/xp0dRdhqzByqBlpMn2MNOeyKjW05emdZtAmJDMQ5xgljKt31ycSiwNbYsgwOUVjOwuAQnP4AtHp7
 OsM3Y8oO
 YAiHTek6Vey0YNkclqNkJgyIw8uttgbaCnS6S1ZhDvg591HNBxnJ4nd/wpCHW+om0CYBNdOGoU78mpzbdB5pIw6ddmQ+GP+Zy6LGaP2V7KGgBpC+Rh/PHksBvyjj+TeUlbp88BVjSSVK/GjNtTg/vNeXfigzmw5Y45oO98+x6F7BQifudF37Nkdg53tcb63JU2ze4hkrlw7S+QH79r74Y9Eys3yQv4gN2FT3oF7vbdX5Qv0utaF2xEVxfAvxLSIaCYPv4RwjIBscxenNSX2Rt8oZuFTbkPekqgoVb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added pgidle_unset probe
filter type.  Also use a list for the types, as it becomes not very easy
to read the whole types in a simple sentence.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 63cbb7b536da2..947d91ae24a39 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -293,8 +293,12 @@ registration is made by specifying a probe per attribute.  Each of the probe
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
 same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently only ``anon`` and ``memcg`` filter types are supported
-for data attributes monitoring.
+filter types.  Currently below filter types are supported.
+
+- ``anon``: Same to that for DAMOS filters.
+- ``memcg``: Same to that for DAMOS filters.
+- ``pgidle_unset``: Matches if the page for the memory is marked as not
+  access-idle.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

