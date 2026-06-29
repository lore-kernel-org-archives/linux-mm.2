Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F895C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 21:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE50B6B00D6; Mon, 29 Jun 2026 17:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBDFA6B00D9; Mon, 29 Jun 2026 17:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD41E6B00DB; Mon, 29 Jun 2026 17:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAD206B00D6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:39:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48E4B1C669A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:39:48 +0000 (UTC)
X-FDA: 84934267656.02.2D2526D
Received: from one.firstfloor.org (one.firstfloor.org [65.21.254.221])
	by imf25.hostedemail.com (Postfix) with ESMTP id 81523A0008
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:39:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=n7Bmh5y0;
	spf=pass (imf25.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782769186;
	b=zNVKUATWYEbypZfmHd+h05oj7etcdpAtpNwGeqsiD18xoSQqC0IjPoB1ZNMfyGUpdrZrI8
	8sQ5VU9ImQMe4WYSqXUTctKiirPC2FM/DUQvh/cKW5odGD8GGOqnYaPPgCmLXA9ixyROmJ
	lU0Wkd1z24ldL7dZM+vTgCRawSHcmzI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782769186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuD/79X0nu+YRen9n8+wn7LNbblRnFofv0JTsLWRR/A=;
	b=15lJyC29orBpFWPmtoZS543cqrGg+eTeKO2AQNFfWFIQgAFl3Ki3ijMDIUtLRyPT96UvBa
	u18F4qQpfKuXsQ4/wbSZpgaiY91FT+l6IA3+qViyp+eOMgoglSBjyf81OZxmybhZnmExER
	OVSnYzDqGIFM3F91/h9udDZacvm9/G8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=n7Bmh5y0;
	spf=pass (imf25.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
	s=mail; t=1782769184;
	bh=GuD/79X0nu+YRen9n8+wn7LNbblRnFofv0JTsLWRR/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n7Bmh5y0b+kjd2mujWpov7y2xuJ79H/44+QKszlr+nZr0pY1nfMZGPqsRbUenWECG
	 sbTrns9Ime6+53Yq/0+yDnD83ha/tpZd+MosNzgbW3VRHeT1wM3wDIIxCP3RJ9EYzi
	 ErmVboyVsPdisyNSLj57X6aRL8Q938T9S2jDkCYs=
Received: by one.firstfloor.org (Postfix, from userid 503)
	id 0D0455EAB0; Mon, 29 Jun 2026 23:39:44 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:39:44 -0700
From: Andi Kleen <andi@firstfloor.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <akLmILr-cbl8Eqq-@firstfloor.org>
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <akLb3WW1nJBaIBwc@firstfloor.org>
 <20260629171727-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629171727-mutt-send-email-mst@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 81523A0008
X-Stat-Signature: sfpooiazkbz8xex1pac11eegck5xahkn
X-HE-Tag: 1782769186-842708
X-HE-Meta: U2FsdGVkX19mfrNjMHOmlBBdn9fHvIW3s6R9fzuw3WPwblwm2RzgWfaBg1MX1M+GYIx6bOno6s6EFBajFh+seryofP8aLtVDoEPZpfaXtLN9RGOnsz6rcPFyjKyJ7pl2UrMyLWH3SwQ7mK1vTp23fzwj0FNFr7lgurKAtyc4fNchdgL2sFz4bjiYmk0BTNxG3L0CkwxHbYp9j3mA9KObb/CvcEnmVqM3JnmztYy6LktItIxaejQSKwRLKvXz3Zhokhgje3CrxuILYOJ0fmBWEeJoPX2FKV6+gNQlGFbmY5KPq7c3sZqaSXKn4YOT1C4tLiQW9WLXuaO5ekQVXsQJ7AZ5OmdCdvjSNLVwVXWpjn6m8D8DVgm+Ba7BOKdj+p4U7opEFyP4dNrLW4877W9OlZADieRAUcc2kcS8jvdKgYubY1+WgHpmKHyeSjJECbszVk+LrGQhAkA2SUlarNBRcz6mirQhj0U+7XwsyCTVgbZvWc7bYGUIj0HgythL0LQhbktjkA7bOvb2l70Z2Rq0QAfPOJxEg+Pb4Gt25N6EZadhDQkhwfePrrGd4HQnMT3YADrOhmlJTuYGDejnPzzi2taNPE1Hw7XgA/Uuxm+SeLowwnIU37pDvop8Qm8MhTDptFoYSsHZ9av52SHHwg9P8xwHNWZ37NaZMAngjsI7CqxL+EwzZW/NExiGT/F7KGux9+5tduRVmBCxnl9cIeWJCsT331k2uRN85KvrSLav6dRYEz//hbt2upy4RPSgGKBxcIQWDyNbEt/uwQ4l6fZAgH3tYUrBSFgfUzZaL1tzYTRqncTQKaC7ICnxK9JprVfcfOvIlbYDmgBZnUNkXjf98mxrh8KKzKkcsfw9TbcrhngDFZaWTYVdbckKKyTeaOZ2OJ2+k/NXSx9C4T4k4WIcDmpz7EhFWkalSWM137q/Y2QctxZngCa5OucSfHI0/T58iUZN6wDzE4La/JwxAjL
 SeW4zhSK
 IYErDVwUQFQcpKx7/Tr+q5GHrArSS8ahv/k3rt6BlYnIQBosiJNfzlxQJO61bq+pJBA8WOLRcjSdw69Vu7LNAY15JoQ1giFUMTX0daBecHoZN7AeJO1q2jcKgd88Ol4NswdK5sb4Z439b7NsxZG2SQC2oToATNBTyjW3nP2cQRRsM+lOARgc00JCGngLXgdvHauQw6fuPGM3HjKYyLysSNiCGonTx7cZpz2LopeUUI3yXlkylQnp6ymhtXgHs3zvpA+Vbpa9Ypq7vM9MGGtFc8+Av6PZxFL+OznII9KqUPsSW9Xewr61Tx/FLey6oqWBWrVsJS5YycvRiatU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> We can maybe batch a bunch of these, and do stop machine once?

If you add a long delay you increase the risk that the machine or
the critical process dies because there is an unrecoverable or
process killing AR access before the page can be off lined.

(BTW that's a problem even with the RCU approach, the cure might be
worse than the disease)

If you don't add a long delay you would do a lot of stop machines
on a flood, likely bringing it to a halt, even though other sockets etc.
might still be fine.

-Andi

