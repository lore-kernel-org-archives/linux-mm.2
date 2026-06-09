Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1648CD8C9D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8A76B008A; Mon,  8 Jun 2026 20:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B03F6B008C; Mon,  8 Jun 2026 20:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED0F6B0092; Mon,  8 Jun 2026 20:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 110416B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:52:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD5851C2188
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:52:28 +0000 (UTC)
X-FDA: 84858548376.10.D68B066
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 08246140007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:52:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aTLCtw3r;
	spf=pass (imf09.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780966347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huvuw9ocJVMaJPY69c7Y/32YsqsUK8XeDkGkdakdgRE=;
	b=weXpOr3Mdg8HOjNe5kKxFwme9i6SVR9UoDOh7DBo8rEp1M+d5prMfZBQk7AIxXEWp0Aegt
	IEbnaKsNt85ttQmeCLl2nA4pe8QbOWNOsQhF+M+FeXJ2QHgqDSjdX4D5jya1BCQP1RZIKv
	kgX+rOobXq83alQqXNhFyECZCyLCblg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aTLCtw3r;
	spf=pass (imf09.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780966347;
	b=q4727nlDahBm3raT4zNJXIfQq8oiVhI/RNSGlxG0jfd7mj+xiijw3QJ2Falel1o/zfv6IW
	xLk7xcSvfj9jqcMwBzBzsMAmTjLXdQ/6lOJKXXJ0KL4zwkkZfX/i6JyYZqYBAefGMdIz4Z
	WjdHsVrFKQKRH48CtN0LBQ9x+Qa9AFM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB52341A46;
	Tue,  9 Jun 2026 00:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2B61F0089A;
	Tue,  9 Jun 2026 00:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780966345;
	bh=huvuw9ocJVMaJPY69c7Y/32YsqsUK8XeDkGkdakdgRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTLCtw3rpDDm7zkXqLgSU0rqtauNij+Z39bxQM16InMfMO8/XgdH+ZvQ4qtergGM3
	 lQZF5cp9zeYnHWI0y7HaSJDHon1xpD3oC1wPyCJ8XBA5+Av2Ic42XBhP29VlPPVY+l
	 JjAmDTJco/vLsm71tralhY/NdYJBhmvGtJSD1D5os8UuHUCl6Z/kl4FH/GwgoaaXHD
	 TGT6rMqX4mepsVQFEB5i/39RS4jYv0LyCf1IoA6aCiU0d5YYM8/z8oCk75x8oCC3Kk
	 vmwMrPSFSNbf5b8i6KkISi6eRTHxqr9ypkoQAcepKd8x0S1W/Y3aCH+EIxngHExHAX
	 b0HSFNm4cndbA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Alexandra Diupina <adiupina@astralinux.ru>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Zi Yan <ziy@nvidia.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Luis Chamberalin <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@kernel.org>,
	Pankaj Raghav <kernel@pankajraghav.com>
Subject: Re: [PATCH v2 6.1] mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range()
Date: Mon,  8 Jun 2026 20:52:00 -0400
Message-ID: <20260608-stable-reply-0015@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605190756.20413-1-adiupina@astralinux.ru>
References: <20260605190756.20413-1-adiupina@astralinux.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 08246140007
X-Stat-Signature: b8obdmf4e7rp8p1c9ki8ewnxcf6cxiag
X-Rspam-User: 
X-HE-Tag: 1780966346-439228
X-HE-Meta: U2FsdGVkX1+Qg1V175Z/PzUqFGPWt3rPsIgcg5woa2XTnRa7y/oxprpKt/bioWjMEPzmU033IugK3aHDx9G2ruI5oqS4y91LbednJ5o90Z2BYKQcLuNlgxrQC0BdBbEylU3wF/4AIgSiW24jQnN+s/4xdXB1JjP9f93maSLviTKRxP+h+gkNW+M0JlOEIs7cminJhA35VqQ6eC+0RKgIivVo7/7Y53SmSj+0Rfa6pLQ4M3jUbLl7VPOb8afUtYQCIFWiHv9sWbvKKfbzVZ4vdX4MgJEDNEMY8kKbkezAdjO2Aw8/5PXtmhKQJffz8rYNydhbPSWNoofOAm6cc7UyN5NUVZfelEM9fW7dmyS3uBl1WsNwTNw4U3EQU7X6VN2ajHLmg1/WqplkuDU7ysLny0oL9x1Apes3NcWkK6v3Hgu9VaBalS5LuGuaqYFgWXADib5Z6+xHKNO0a86LhS5U9c2dQ7feXBl56/gLzkc2dvtgkco+kGqJdHByLSzvoRXopZbLtYZc9jMrFLgQ3bGZXBqYuPOdD6iPjv7H63L7XuSqef5e4TgWv8GvdRmGjlxtZfwkeHn7N2Lb52wdmiARBGTiN2TCgh/NipEXXlHWdm4yJceGgo7qQPH12hU4lVkM3wpos9Y6xZqG9iXSqK3QxvCb0R3CELhyvkAUxcbuHZXY89+fhSmKBST+nH0Oj5Sz1WkZ60je3uRb1CmqujAocu2DFE8tyyZvwYyXWYr8lXqwaYc6+EYff97q5bV1yDTXppbioUnKE7756rbueeNrGmRRGMq7FDTfWHgpkbHGrb3LBh6p0dP2H72zhNhWQwzx0QKalpFtKaGiY51PuR01PeLL9MIM5uZ2qEyMdS6eibW3COUfjynqSPInMdooAdG93eYQYOjD5euDOu6zm3Tea1+Ah7898iosN3iYqdX3nyLhdSaM008qAn3mYujtCG5v9RqrFg1R3LcyBon2SCF
 /knlrzxF
 rLLWX440DEN5E2Isdid7JgW6g3WQoxoD8q8Lhb+nrHQBhokAvgSh5C5iw33cPVRR8sqVoRhLUTiyGvT/Wrn8kCq1xVPSvwREy3Yz1nOkCMrlPvcALWCzfTd3WJN32sFOf+yApEPmJG/8EJQI0eZfeSXmg/u9IcRe2jRMfF02hu0DE751cgg9iZPXIfLwuiWK/sqQFdNcCBeBG3HCULdemi+jh1UxlC5Nj9H6EuzstTHm3HFzruYHy3Xy7xyvl9BKgNCIs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> [PATCH v2 6.1] mm/memory_hotplug: fix hwpoisoned large folio handling in
> do_migrate_range()

This inverts the folio_isolate_lru() check on 6.1. In 6.1 folio_isolate_lru()
returns an int (0 on success), not a bool, so the "!folio_isolate_lru(folio)"
condition is backwards here and takes the wrong branch on a successful
isolation.

--
Thanks,
Sasha

