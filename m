Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAA82CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:38:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F5E6B00B2; Tue, 12 May 2026 10:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9A8D6B00B3; Tue, 12 May 2026 10:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1C36B00B4; Tue, 12 May 2026 10:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B27E56B00B2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74DA81604B5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:10 +0000 (UTC)
X-FDA: 84759020220.27.7C7CDC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id CCBA618000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lySn+Q/V";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYvx1ZjdRykI9FzSdR0JUW82OieQVNXNXNQ31n/ZroE=;
	b=0SPyl+MczfQ2wB6bPZVvBBdWAAyBwUsTNEU5Eea8sa0VdisAxE9IRynDo1oL1wLyq6o8bc
	I+jbf9UnM9BNGADLZATdvDh0b8lVDitAhWZXoCCFNxTgL7OCjJfqf113LYI2ymM+Sg5su+
	JNsYB8DofcjP2BIOEQw3fS9un7WauEk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596628; a=rsa-sha256;
	cv=none;
	b=n9NwHkETpqn3vLuXb+GlofUWbCWHQK8sJRdXPBHnkLsONW22V76UNYZqEpRVS1M1PvqCqR
	G6g1aDKN4gjGgH0lLe0h7xwZXFWqjH0CGK0IMarV2/uaoYnhdEFeazdo7bHPdLFYP9oEub
	BtcZvjyaM3A4OQa1FGLp386fUpUF8tY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lySn+Q/V";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EEE244A96;
	Tue, 12 May 2026 14:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99C0C2BCB0;
	Tue, 12 May 2026 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596628;
	bh=rQroR8oz509qjIfFzIS58y8CMFJSjy+X56KqeqKaBmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lySn+Q/VESrFSVgvneHkZvPUuH0oeH/v5CsIOjbXjLI2XNO+e7aQmUL9DWTyON/wg
	 4BuEJ3UQVJZ6CEBMhjWjpSJBRG1GMK/c0uOdJc9p4jW92qpnEDuEVaYEptORPlsy1F
	 6k0Ixw/f6PHgVnoNEjFWfq95Q//ImBoYOUdk230L+6GvlyBsgrq1Hf/TFAPgKVF9yC
	 qOGAasX8/lFRurzkMad+W4/wTjoglvMGAyM0+Uf4gZkWaY0FlpGOLghX7KTkyVtXZX
	 8jgCxdDyv2zbJF3quNdJ9XzQYXeNyCZE8whcPa/COZzUPP2Dy6PWVmzLQhT/sYUR/t
	 384NfyjTILcsw==
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
Subject: [RFC PATCH v2 27/28] Docs/mm/damon/design: update for memcg damon filter
Date: Tue, 12 May 2026 07:36:42 -0700
Message-ID: <20260512143645.113201-28-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CCBA618000C
X-Stat-Signature: srwu56m31awsnad5nbrxartmd8qrk81f
X-Rspam-User: 
X-HE-Tag: 1778596628-581114
X-HE-Meta: U2FsdGVkX1/rPIrzp/7ag8Diuw4JxBvZtsiQdKaf8hCUaU7IXMJSa1cRK39MESAy3wS7lgbtiwosM8Gu3i23Xc7R1xzsNOqeV44cEzxLrtIpNDh7E8JZk5JaPzRSl7+LvbG4CYYGbgqFiYGm3weLRBLgconIUVF4rwmvcWDfpp/KLQGCN6JlLCRhFxhn2pe0LGSiYjFfp3TQG8vsFdogsgnUSDpB+pu71a+WxT0xAGg34Nc+t2F+Xyo+VH1LalIumXvsZGYKii0DAyl0ZueuZfyPp4bnpbBOV29tdORHCfE/0LoKHAsQby8fS2xsZ/q0lYJsNLUol6GPIDJnTsRS0q+Dt+BWmD0MWXZhDNTvhnogKZzcNbdPGru+fkacSECj5rGz9XRBGOJTLR2GxuJSetUMTjwcxZ/dOdtS8yIonp9BcTCGAYAstM7ZWUyg22xVnBJM5+OmlbOzbFKkU1eE9E6xuD4ukwEEhPrqM0cmQc3k1MPJbex3/0oGDWKNIJx3EqC1xz4pZsx2jIdCC38/9ljZyFYl9GCbVy9YFkZzGTFUsiTXTRdnvNhTAdoaV0X4L4tKvC2vxLWwnGHB/71fwjmRHv1ElluIohrrzsCEhDH3JUKl577gOBMamgglxojKcsRBWAw1OcdhNdde6OQzMGmBMme+gJ/qo7lYNl4xkhVkmUX4Wmtqgq8UKoBu+YVZcdF66UtcyD62kZE7zziUgo8L0ZTv0wikG+tq3vReXCuMQ3qHj8jlte3pWUgJ6t26ak87wIJB1R2bPUoJcCku0lOzbzuwWHcbSiacPGx7Hpvgn3x/5vZC9TgN3XdMcD2GEd9RJGwRUKZEnKGYhYJQ7nte16WzZzdcnnMTO1iD6kFpDCBU8ZzmS8tIu4OtFMh5nspxbh/ylDko02SqV1Dm/yyTYh7zOLJD2voB9wb7+wDWuUJDIff41NHp2wYGI09bRmYtuGnzRNXpXQLEqG5
 aMXBAVg0
 q4lsqEnSHi4wQe/1q/eQzv4aCUNNeE6+8Ygu5c659tbnGimJpept/Z0wUV61llXCwQQZAGSr+OVKv9N9B4EVF1ONVmZHG0iltm08oxuK48Zx1/BBgFZo+kMP2TBT7dPC2O7Ar1Rjk/Jl6ifl9kMkwB7WxVFyOfKPhdzndyDLOwnMKoh6MxvCovirzq6cs1igQbZtpKbzHzI8v+vf0vOIbuhYMjjsM74QLCYFD/IDFEI4aeCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added belonging memory cgroup
attribute monitoring feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 887b45cbeb716..a24f9f00d1837 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -293,8 +293,8 @@ registration is made by specifying a probe per attribute.  Each of the probe
 specifies a rule to determine if a given memory region has the related
 attribute.  The rule is constructed with multiple filters.  The filters work
 same to :ref:`DAMOS filters <damon_design_damos_filters>` except the supported
-filter types.  Currently only ``anon`` filter type is supported for data
-attributes monitoring.
+filter types.  Currently only ``anon`` and ``memcg`` filter types are supported
+for data attributes monitoring.
 
 If such probes are registered, DAMON executes the probes for each region's
 sampling memory when it does the access :ref:`sampling
-- 
2.47.3

