Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F5BCCF9E9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 18:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132DD8E0177; Sun, 26 Oct 2025 14:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DCF88E0178; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88618E0177; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7AA88E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9922EB7F3F
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:26 +0000 (UTC)
X-FDA: 84041085492.09.BECC409
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F034D14000C
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rrUXWisV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761502945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLdoQZXG/X6XUj9yEShKkP7SJvznKr2Ggcw8RKW9U38=;
	b=dxoMWqLxGa+lCaU3c3pVvG11/MNf+GY41xz7KRN8l+F528HVCMeIk9pkwR8alvgwSnxnnO
	RWfCPW6DtK2YW7UK8ZWYjZcm/1GAbuZBSdR/zmdY+m+kJYP2vGaKP1s0wc9vboEjrEhoag
	SKLSQ4LOlc/WYr8MLVaAAeHpnVX5VZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761502945; a=rsa-sha256;
	cv=none;
	b=f5tN3fn5GCS2fpekUvANIGiZyb2M8lE+RANy4jCTvEikbgb6PlqwO01rzxNDmOqbRv9ilx
	F8uNBNl4adWJ0Sh+lCkv3swwhQCJkM3FQwjAqduKiuW/iexSAw0HrsHg/aKCG/dP0t1noW
	+kK7clbpLW3brdWHm/2y5fWN5H9nSmw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rrUXWisV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E747043878;
	Sun, 26 Oct 2025 18:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913E6C116D0;
	Sun, 26 Oct 2025 18:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761502943;
	bh=vR/jN1F5Lce+/wYJ3r7vPrVeoUjeNepMfhGqCYSRWqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrUXWisVTkQuT/o97FuvkpH48DZbMUE8mE2W8Umu5nU3QnHmLelcE5jBmq95VgdCr
	 pY/zhcBoT8GkIudvveTt1LFwjoCVwxxN58tWskdBWOJ/oadZBuZaTf9l499ApRhP+y
	 HYlXni3I9sVHVfTDml1uHzYVAxTRvsrBfbuTCCs81RZhz6a29HzIy0mOGp73H/lEDf
	 EesRjDcqND1pYBOzH7F9SFKGoUdGBZknts4E8rkxMqOhDQ1DXFTzbUs08qVOMlw4JS
	 +Bk5Womdr7dJUTyra0iV2Wvnrlg0W0qfP42AVCgCzLYoP78dpvJMA1MQboaEuCs/cG
	 DPdMcDpxOvNHg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/8] Docs/mm/damon/design: fix wrong link to intervals goal section
Date: Sun, 26 Oct 2025 11:22:07 -0700
Message-ID: <20251026182216.118200-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251026182216.118200-1-sj@kernel.org>
References: <20251026182216.118200-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F034D14000C
X-Rspamd-Server: rspam02
X-Stat-Signature: b46jgicfehcfgipbsw4qgxumt5ite1rw
X-HE-Tag: 1761502944-390734
X-HE-Meta: U2FsdGVkX1+BTjBCzW+PMs92gz9ETDk6yPY8+R4BnjtHcMeP6Z83BVKyr1uWWAArk+9I2PMZZ56Z7HLP99oBBhe8+Kbrl+5DHxDuzho73mhcdk4ncTd67Ba2B1jmv4QRBh1Z0E/JLDK0jSl+5tyu33ZiMsBmNFw2J4wVUq3ldpqP6aA0g9h2NcNP/1AMHa5fKMhPF1S2HQnmIcrb7bFJ1LTDFf+p1pi3dJvZKsN4o2vzxSNqljdRm0cU0HfWedgXwtVXy8zKaaTH5c7Cl6Yo5NrcM3xScRVH/0z+mqvwD3ilrst0dHZEsNL5yQSIaOCX5US/0MXKvdMikRaBjicSEceWg1TBk4JUh2oWp6EEwitQbVp2hQcuhj+C28SGQWzE/P3g1KEhGijEhfAGj3lUjQDyua69wm/0p8XT2JerVkQXj9nKnW2QdP6c3RUr++i3ebyEOYB6Rhc5mhFYWd+Hr/Lo6JKsTcGk4lMf0fk9D7czLtYcOziNUDni3InsjOTdh666DynZZgHsN5Ajto3510xAcZPwIOYfDHx06QIvt57bIRUjSdZahgKa9LaDsIOHPZRyFYaOsaWb2IiXOhtWS+r9AU5K1xmGVRvV0goQQGEZmzeGbpLtnZhEXYrdTklkSRq5qrbAbu8GJXi0iJ6COjPcE0idZ/RWURVeoKNWnJfiOI0BW9O2Vc5OI5DhA1ipLuiYUvswKrcPzK94Biux5RM/IoEpm0i0P1aBvf8r8eqvLKsHp/IsJKaBstjWoBaZxBb/l9u2YMjtvpq5W+1cDbR7jkN7GBQX9KIiyrvJ8q2DFyC1D7iADRgUiVf1QqVfacobl3vDRf+Z8PveLpvibVn3m5ONz8ULQAMQqRhK/Dx7dnjIE4hq8DJ6WEhbE3WpGnhBE0rNyWSLbjdbJFrDMAb2D4rIbw4L+RSO+kSB2tmA7X5dI2pwDQVK1hRKIE/+Fu0U4X1eOhN5PSjWpR1
 D6bmpnnf
 KyA3c8hb0ppCc2CV0l7VYZi/97v6jOMJjdOfKBM5+6UC7nZP/7sXAigPjgC3hXg6VmdViEtf0k6Z0PxOK6HU5UwKkQpPlbRE0a2yTlm8MYanLzoehMypmM/ZM7w5wSKZSJEjpBz4E88PnqnTODfDy5tUDBRxB6bk70mLwi3zEtvGRj9tEOnrzSqTjlU2OAEXHh60XudI7xgPV1yo7hq6hb7ljN/y5Zl/In2nvPtIlAbhUN9xc48E3TvpJg0E9wUNQsCcZgVYbpfJiqbU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit b243d666d107 ("Docs/admin-guide/mm/damon/usage: add
intervals_goal directory on the hierarchy") mistakenly added a wrong
reference for intervals goal usage documentation on the design document.
Fix it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index b54925ea78e9..2d8d8ca1e0a3 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -381,8 +381,8 @@ That is, assumes 4% (20% of 20%) DAMON-observed access events ratio (source)
 to capture 64% (80% multipled by 80%) real access events (outcomes).
 
 To know how user-space can use this feature via :ref:`DAMON sysfs interface
-<sysfs_interface>`, refer to :ref:`intervals_goal <sysfs_scheme>` part of
-the documentation.
+<sysfs_interface>`, refer to :ref:`intervals_goal
+<damon_usage_sysfs_monitoring_intervals_goal>` part of the documentation.
 
 
 .. _damon_design_damos:
-- 
2.47.3

