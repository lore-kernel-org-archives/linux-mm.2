Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A570C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09E66B00AE; Sun,  5 Jul 2026 16:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98D76B00AF; Sun,  5 Jul 2026 16:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCFA16B00B0; Sun,  5 Jul 2026 16:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6D96B00AE
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:58:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDFF21201E7
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:58:01 +0000 (UTC)
X-FDA: 84955935162.03.DDC41A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49337180004
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:58:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQIpDVAZ;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+H7iz0ORQgX6Mh2N/AhYCgCoxwIP8JacfdhyDalugg=;
	b=JsEmtcGQE4+Fc1qpg8WJC364gFinYX0iDQrJOY0fnEsOlCHy7Oe8uOayKTE9cU+PVT4ODV
	1W1dvWAHyTlrWP1a4m+mNhXeLWf/NgXuxZSvJQiZIq6O0x1kEDDDGtdJz4Y563XLW06Ccp
	6kR1oNl4J+2le4CGUjucIj+sXVlFvV8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQIpDVAZ;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285080;
	b=LuuMQMFh+l80ydUyQ8v6GL3SJFQcSY9cftNRa2hh+eapfIItFXFRFtIcm+OOPBNI2ijEnt
	HFr0korwhGucXltOoibr/nlHCtEdcL2T3rG3Fc3kffMj0sUrP8gH6o04eTK1h7uISMA2nK
	Zr9qa/to59jekZLgyuAUWonRWm/35mY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2075C43C64;
	Sun,  5 Jul 2026 20:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBBE1F00A3F;
	Sun,  5 Jul 2026 20:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285080;
	bh=b+H7iz0ORQgX6Mh2N/AhYCgCoxwIP8JacfdhyDalugg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQIpDVAZOr5y39SRg78850Pm0m+6gQDt7UrodKsXDLyGFJKKuEP52hykCktmgxEFc
	 LR3BsPDOs/i9Gh76p/1Ycaw3HERNHMdUYdhBqB/e6d3jf5++eeilcCvJFT1vGHo3ZS
	 IcIAIICN4TNNRz5EHswhbYIEG8hDM8Wn/TG82tt+/bqqRhaKc6shiRy5Kry5N3P2uz
	 bg5iIheASwQ/TIftep1MmcRIcyedcbtVSWEjUXYxeARCBJ8WEuE3VyV3+UHq+kgtOp
	 tfwAzRf6HT0rvNzFUbfqK7OlcLqtmo2MqD8c9JBrkW7UBwIZQp3CNeKz5gtjmUKocy
	 COnJpjpBDd/bQ==
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
Subject: [RFC PATCH 14/16] Docs/mm/damon/design: document attrs-only monitoring
Date: Sun,  5 Jul 2026 13:57:36 -0700
Message-ID: <20260705205743.98656-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49337180004
X-Stat-Signature: ibkdzhotdkfnfegx84u8e9qp6fgbtzoj
X-HE-Tag: 1783285080-332339
X-HE-Meta: U2FsdGVkX1/N+ViHNIGypyT2BtWXRWaNEX2ygcZNK3B1bfEl5nj38OIRkdXfMWDpcyO5h1RB3asOWkTW8LnlQsqLPaGRC3vJcerzf8k/F2e8D/eccTrN5p+we48iwQWgXhHSAJ3tcH6XDS/fjucu4AFxuO+N54qVhl7bTvhqOINKLKsEU/AD6R4ehK3Wo7w0hjpyt4pjMNpPvT9FEj6OQkiXiMN9RHP93/moFTQrDQXGmxxYOURLnOzNqkWOpu9q7epC2kXTRFSctqZwugnf1Y9JZyQCnQ+jJM/DXaHdjUtq5q+fKkxnHGnNnsp2oSla6UX/9tDFUbrFTN7baoa7V/LtYEUuJjss86xXB8RbAECPVwMqbpBQH0rJpl3Ji6rkOmw1SaAnLE6E/vKO2h4ztoPJXYFpIE5jdiQL0FOsMxgiExFsTnL2/4yhiHwCgrmonsVteICm34CYF9bnXaHzXODnJmGuxPQKHVobbNRIaiGf812ZMe6435WzMdbd7lsniK2zWp+Kg7qGkNGwxNGU/LOWRQtZMO/iPsJyIVl1RS9kyhESdYCKFuY8YXiHvItLmDph+wfLFR0CqzO3X6dvQh8R1Frm+9gRptjexJCr5CQxK76kS1xgOHC/FGFv7V5OLYGmONgccnQtJtbIlc2ODQSs2rHCVkoBxxN9onRClB4S9dNki3Ei3wUNjJHGGrU7U9s+tUOnyE0ffBzX8KARRS4Qo1HaYCgguNLv6QwE3f4/nJVAkn0UCkTkOijnmVXPcxvMv1U8g3CkmTyVO6F2xC43OkIl8HwhfV9WbfgOdb/tS6TYq5upwo1wTKDGt135SpOqM++PB3Wqdqqur/jX7+dGNk6gkZBXg6cslM8m9wvRJfuarYXWyXmP6rUJ1UvHo4sX7NoAWOWMjzow/9Whgt3MQSBPfrcsQCaH9Nk/82ut3538vgLdDIiMZukuRlq5iqJusB09AcJgLcYzzum
 HwtLU2+l
 w+YMoizOsqzMs8bTaiMxxNlFVsCaJgdpTfPkXMQ5Obq6SGmHY6yCuByFyAk5vnIASlxho2efN+Iy1GMEZPJbJ1qVleENUPxwQBn0tZ72ME5bGFJdIVHW/+M7TCeThHZp9OeC5qHlbO5fdEd+TBnrRih18a9E+gpvzu63WXs0p4JGm/N5Kf5pNdhnEgvkl9ljYRsfO20fyD62immRWZc8NjhiPSAbKpnfBcE5ttEwNNGaC4wxxzJtRPmtQthJHpkRZI01Outho2X5toYg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the attributes only monitoring mode.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 457d6e8bc7878..67398e2133036 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -316,6 +316,26 @@ Another way to do this for higher accuracy is using :ref:`DAMOS filter
 information in page level.  But, because it is operated in page level, the
 overhead is proportional to the size of the memory.
 
+Data Attributes-only Monitoring
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Data access is the primary monitoring information for DAMON.  Hence it
+:ref:`adjusts <damon_design_data_attrs_monitoring>` regions using the access
+:ref:`counter <damon_design_region_based_sampling>` (``nr_accesses``).  In some
+use cases, however, users may want some of :ref:`attributes
+<damon_design_data_attrs_monitoring>` to be the primary information.
+
+Data attributes-only monitoring mode supports this use case.  For the mode,
+each attribute probe has their priority weight value.  Users can describe by
+what combination of the attributes the primary information is deeecided, by
+setting the priority weight value.  If the total sum of the weights is not
+zero, the mode is enabled.  The regions adjustment mechaanism uses the weighted
+sum of the :ref:`probe hit counts <damon_design_data_attrs_monitoring>` instead
+of ``nr_accesses`` in the case.  When the mode is enabled, access monitoring is
+automatically turned off.  The access counter (``nr_accesses``) will always be
+zero and not updated.  Hence the mode is called Data Attributes "only"
+monitoring.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

