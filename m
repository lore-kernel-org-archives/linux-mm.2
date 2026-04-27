Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5521FFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF4A36B0096; Mon, 27 Apr 2026 11:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA57A6B0098; Mon, 27 Apr 2026 11:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A943C6B0099; Mon, 27 Apr 2026 11:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 983976B0096
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:17:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D3451207A1
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:44 +0000 (UTC)
X-FDA: 84704677848.21.7112DDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D708E20003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=njaiG58w;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woFA4p+52OXntoat2gXdbfVc0/PbOSEWfXCOvvJ/2kE=;
	b=tlg0952ci30QaI4fQKx9OFYYKGlFK+vPpLyWXCzV2LtpkQ51G3aKtlGnqzFGWOsfFb6/SC
	jCP4w8IbU2wy06w482XhKfzCP/+fNtqXyq4sou4LM24yRAZCgQymjjVoASPiq5+RUF1L4R
	5YAWFbXTbhHGfx1qbevmOuSMuHJcdp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302763; a=rsa-sha256;
	cv=none;
	b=HhPgR5UDsNAabwgmV9w5pJmcbmjCpRENTb+yoPJuOav0tH6IXsAoK7ro/IweWIId/z/zZL
	B4m4UsRp3jMHhD+tf12XL0OB29NGmKYDa3Kk7CfmnRqLrSlz0wagRqlNCF7nFsO/AZEa51
	aJurCn2ywICPBIsRPS06866QANOMh4Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=njaiG58w;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 662C043358;
	Mon, 27 Apr 2026 15:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C19C19425;
	Mon, 27 Apr 2026 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302761;
	bh=cefZkLteoGUCWc4MRoifuuAEqrfO3tIQ452Q0kCEVdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=njaiG58wjsoDLEqvI2yOa/BxJ00RrwagWompIzbxHgrQ58S+/Bsnq2TIQK+l7yvjm
	 1iuSJc3qvdzX/n1j+GgrTOsHCUrlV8VhnNjgsojSBdOkg8jjbK2bSGYCtHgXOzSrI6
	 A0umOBQDdD/THIPDnwDAd5v4yh7TaR5S4AkibyBJ/kKWY71cFeD7DTfgnUNI4QxkRu
	 RY4JyOYgROABt/a8OU3yOKMocI/3TZHv8ZAsfyYys1SW1lrA3e9cXM1ezBnVvfmGsx
	 4Vr5PRf4PYjssXCFEkjOcgKTzKONXW8wgVv811rASHZlOjrTIWBuuVOUgpL+Sbq2c7
	 ZVKXX7m3WX56w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH v2 03/10] Docs/mm/damon/design: update for context pause/resume feature
Date: Mon, 27 Apr 2026 08:12:22 -0700
Message-ID: <20260427151231.113429-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427151231.113429-1-sj@kernel.org>
References: <20260427151231.113429-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D708E20003
X-Stat-Signature: qxyj965ewd8tne9bfhxdh58bdwgiusk3
X-Rspam-User: 
X-HE-Tag: 1777302762-298633
X-HE-Meta: U2FsdGVkX19ALScp2Y8/MifKCGv+NmBHmEGz8fBaUyaEy7LMenYGbg0ZVYTPSdMlKHJ4WonSDqsdfh+ZBMxwVF/Il+gUSZzxdBsLn7RStU5D9FQr/q3YYKjAEmi82hQUVlU8FcKZuQwpkJs/SQF52EOq5k/GQ87OJr0yApi/XbR05nkWLb2RKhGD+Ar1VC0sqC1YX5bWwIXQrOEYq8Js4MiZao8fzh0G8Nf/XCDlkhgUnMxPklBiZMcoi0ePat2zFetpvC6SsLPKVEmP8egsMvcmuYx5iLWGkGj3km74+lAW9hm8r1lHmWdz85UuUJHVso32Q6pqfdVbJnxbFvmtVQRiJLKVqgaZiygsYBXAXlrwJ20ewhVtAFHRqNhujFe5L/HM3YBji0Z6cjbx3otHRXYIFfZF2tdOE6pRqmntDjuLIBb/CjzRX4Tq+t9/MHZiJ0tYttcKl+59lE/Ts1FPelTeKxkK2Zc+bB5QEQbtedAmckAEd3lnnoes8deXKbWtZXRRGUkuxzn5Q4v99Ex/LzkqZvEQHZttIolSkLNX4qancQnXwjUCgKKEKHE4tvvhJjBS7gh8wHoR/LB6eTjzMj3nPF1pLfbofvS3a8yREZOpKd1c+/AkyYX9Ves6K0LdBbl03RDWj57BZjcBjDLJUMFSySJhmuyuxfVYdPpG1QWfvNJs5Qp+UFZKVlfD7d1psKZxZ9DECEagrws91Pwxvv5h7NNYyLiVeE2vGTPaes09NKmr4zsNPeBHTwVmIC4wc9A/LtEDoCBHqy1wlgHbsYr9ScKT5bzx3uiRytnK+ZaZcpKzN5vgjY1bHMMrLtHsy90k/5yt0ozsUnHW6zkStdYakQF0M0uhg3PGWSlAWRtcYYmplMI6IPCcGwTfVP6ECKdPRnoUaJl80panGVr+VucRA/8LUGM/m2m/n8sng+tralRbIRQQZIHL9aHw5mpvxgdRXpLGM2EqnPHtBBd
 JxbtAqOq
 QxSC98vMSD0eeOmpjbtdQmjg2bDB8CE98ysVa/35kBpQh25+aEgNzkV8dDYh6QuDSJBGlFA5OaCUAS1nLSYdWX4TSslzZEov4J6/fQfzHXqUbE9P85j9VvlD56lMMzKEMi8Ocu4H3by0ZdsSoFwd/34oUfitgdJueCd5l94i8aeeEHdopUTQJkYxdGXi2oJr1m6aVg1MdoiU8bSrOgxL4czS5MxAOORGbSNhxcPduVLu0K6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 365e068a8dbe4..622d24e35961e 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -19,6 +19,13 @@ types of monitoring.
 To know how user-space can do the configurations and start/stop DAMON, refer to
 :ref:`DAMON sysfs interface <sysfs_interface>` documentation.
 
+Users can also request each context execution to be paused and resumed.  When
+it is paused, the kdamond does nothing other than applying online parameter
+update.
+
+To know how user-space can pause/resume each context, refer to :ref:`DAMON
+sysfs context <sysfs_context>` usage documentation.
+
 
 Overall Architecture
 ====================
-- 
2.47.3

