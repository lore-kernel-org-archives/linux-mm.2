Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FE61C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92156B008C; Tue, 28 Jul 2026 00:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62B16B0099; Tue, 28 Jul 2026 00:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951936B0098; Tue, 28 Jul 2026 00:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E59F6B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D56AB140202
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:54 +0000 (UTC)
X-FDA: 85036864668.13.322FDFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3A28C20007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BU7cvj7f;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211973;
	b=6MmgwR792XbvSrQ6RIM4sMDggqY/u6YkvH0KXrTVfhAJgFTAZnx3qRaqBybaQuFdPAFYnw
	/NFyzx2Ie8hOuGKobWu6SXFA9za2x/2A083m2A4yrx//xNZWRBV9hG0tkOA0cPCP03a7Ne
	bHQaxnj9ozaVybNlAFyYBgBdBXywrtc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BU7cvj7f;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9G+NjVl63rSPH9VnWm2f5oghlS13iCb5rZjc3IcuDc=;
	b=KWgWS6CBHzfQqFYquhjHx+RT/lMpiHttf00tiVVzLCyd932CnwyGE2SMQQrbpFA0mjNO08
	B20Vq06Fw6UPE9n6+xV3MRMLfkpgAoTHGVSeM5tLbdwx/5baAgyq1WPzjkBBzQ6m8Iv7l9
	G6iGrKvb3EfK2V1ZBoSnas+cWWw2J24=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87C6843214;
	Tue, 28 Jul 2026 04:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C831F00A3A;
	Tue, 28 Jul 2026 04:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211972;
	bh=g9G+NjVl63rSPH9VnWm2f5oghlS13iCb5rZjc3IcuDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BU7cvj7fItepfo7P2H5V6mbK+RlllHjNhRlbYmlE8x3f5l8wkYHZvT6OP2OEuxajd
	 7bveIAFbpH+NxUTv3jAxiqTcOrZ+NI9THdXyEyDMHUpu5+MmAlbLQKWbBL3U0uCP/Z
	 2XQ5fLsNjbqzpdZkkL7dIO7Dd9/lM6KqyEkp39x05a7ecpfkzqUImVIaVpjbB5SQKv
	 niu3J7WSSKaGOUz/awPMx+3vBCQySEbITp5vEBhL2PcUr9shCmQcO4fslmFaMx6erz
	 nLkWoVjIAnEpDid3DogN4rYOOIoV/n4wjTgQucrdgWt0Z9l+54MQZTEUr90aOO2dGw
	 oyaggPaJIWtRQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 02/17] mm/damon/paddr: support PGIDLE_UNSET probe filter type
Date: Mon, 27 Jul 2026 21:12:23 -0700
Message-ID: <20260728041242.187380-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A28C20007
X-Stat-Signature: kdycrtaobzxgf9msogeqnqzc1w66csax
X-Rspam-User: 
X-HE-Tag: 1785211973-859633
X-HE-Meta: U2FsdGVkX1/6uuw6ERXXAZ77xNm8gygq47ELQqtNHabqRFwH0vPiGz4VirjtgwPFOrgFrI54BuXsw0uhH1YrDWTUPs1tin51kjUza/3G+eDpuRWuuR0HzDorpJcexo68XfhfakHVskRTL9UDPugK2wReyFsR4nXjA8AnllpnddUej1woHFBbaHUpAcwOzF7ZanxZiwlB8PjZE4LLGl8aqlSjGcQWkzZlErsrm5PXJMqNpFet0jF3UVS1CPdlQ0zR4oL49kiY5l84z1Lv6gL6O/GJTF6j/x9rwWBdDrlsudnr/hyhjFcQdrpZBnvtGsZTZFunRnoqp7AlpRHbIJ4u85WMbCfBiFm8HLHbI9UQiHlYkFQZ+TvteK6dTucLj5hS2zNn165oFYPtjpOW5ROUlRuAQg1oK6qx86EJI5JrTOEIYYzJH+uAE//efcw6NZlIBUlzQpPfPj6a8FyDRqEHy55+2Wt2PRpDh13U2MrFVkAbcGZRtmddOF+CeYJ+Chb+epvbQXU3wFn7Nt9oqAdEKd0s6T4/nBfWRrd+BBGZ9MEsa4ckvGJ4wS8APk8kKBlu71mJdPVjNksk04ePqIZTY1qKPF0eDkmqYM8UDoHSUmxr2u09PzZrDwHxmJAKd9KxTxlidGzmVw28isxTywr2e2lkZjdvSZ7o8dvtCzsiCwlx/a5x3ryqRQq8fX6R0mPDhHij3lVyjOC6xxluWKSzn+HWmANHOSvHabB6+Sn54tF6RkVYDhcTkaPNqO2/Brv6SfMk20+OJDQ7fXUYf4kbFHKQD8Xz3BSGHBzjHnQaP5Py1qne+zxfwXJghCN0GpWQIk5QIqn0mQC7WEgDcycxv+L8UGd0Bcp0LSibpMXb3UiIx9PkXWJbJ3R0CUft56MvIhfuAKM66Byobo10zylb0aBOoVxMGiORgNF/cqIkXxu9EUswnp6mUlu4MeLlf2JM5k5VpMzYaNnjaQOG7pL
 miKB21xO
 aNbJMDi8te48Mstb1s8C/EhGArVDjubNIjWb1XpPYyqWnu/7oP0ZUcwLs8ES8ZczH74FvrAuwZYEgrIyeXyhIp5K5QAKCCbO8IEgYzN1Sl3GzdlNc+g6pImYJVlcHqnv5VIOXzcFkW06lW0cCk/XShlx8Ag+799K66oDIoddZ/zooYTBJPqrOopt/eM350gn4yne56heMW/l27QKXl4AzsD3XKT/+S2573NcWXfRD8zPjSnpL6Wy3LdqTj/tMGRtTW8BlQTm8g+wgQceYdh4Kx44uBNqpvCfPsSsEFmAZN2LMrHQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement support of DAMON_FILTER_TYPE_PGIDLE_UNSET in the physical
address space DAMON operations set.  It reuses damon_folio_young(),
which was being used for access monitoring.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5c6c3a597fd0b..5b307dcbb2a50 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -132,6 +132,12 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
+	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
+		if (!folio)
+			matched = false;
+		else
+			matched = damon_folio_young(folio);
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

