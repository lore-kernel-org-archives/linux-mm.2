Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FFD7CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF49A6B0095; Tue, 26 May 2026 08:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC846B0098; Tue, 26 May 2026 08:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08446B0099; Tue, 26 May 2026 08:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE9C6B0095
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:54:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40DD01C022D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:54:08 +0000 (UTC)
X-FDA: 84809563776.25.B8C085E
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5C083C000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:54:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EKucJNjP;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NFmtjNVk6yqSf59PQPhoTYEdjcxCUFRSGiq2LjpJPU=;
	b=pzm4vWnokdIF3ttJ1hrBEHIwE7KJbfd5LGrpjIuWnWhxsli7JMYXb87YbWFA/dJV+XPJqM
	cRdUVxeJF5NJh8JGPkMVYWvzixegqzTc1N9K0Cy9NHs0ayXAAs2ZIqLHdCc21pg8cgzLrh
	kKIUTYCteNB1gI6TUCObH6aSmvAFAWY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EKucJNjP;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800046; a=rsa-sha256;
	cv=none;
	b=HJpLbTwHi5PYr+CjmeE8XLHAtZu3Lve3ZQ3TUtYFaCvRIUqHbvjTOCjM/AvVYEv08s2tMd
	/7yUI0wMxXuN7GrPBMO74N8/FPjhWtO/vO5nSvAMcGmtl/NB5dgWj6POqWaFU7vN5VckPI
	UtslViHc/9R8w65NHxLeOGNzVRKhE2o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779800044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8NFmtjNVk6yqSf59PQPhoTYEdjcxCUFRSGiq2LjpJPU=;
	b=EKucJNjPDOyhy/Ct1wzGkugYgHG38e4JHfUiB89+kwZuDSasTGZUEoc1YDrz5Tlx3cQgBS
	nbFBvy3MoCeQXc3AEh1D5EiRZA7JxcqK8wuhQb/KM8RElSncECRexNGouS6+eizOvOXxUG
	BRDHXzkKV0rGmVw5LE4kz+EpbfTed0o=
From: Lance Yang <lance.yang@linux.dev>
To: yintirui@huawei.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	djbw@kernel.org,
	apopple@nvidia.com,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: update file PUD counter before folio_put()
Date: Tue, 26 May 2026 20:53:51 +0800
Message-Id: <20260526125351.58831-1-lance.yang@linux.dev>
In-Reply-To: <20260526101355.1984244-1-yintirui@huawei.com>
References: <20260526101355.1984244-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mwpxqizr7o7unoedm19w7o76jx1bm7r6
X-Rspamd-Queue-Id: 5C083C000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779800046-526456
X-HE-Meta: U2FsdGVkX19sBw6KwkcD55xZE2HUHM+ygQLG+5sfJJ8ZmuecK0TI9NzYiazxtKyRGoaYxMTXMS1iffLWY2JzTUxhLqNtkRL8hGQsQ4SwKsA7OmmxBjDdt/jVM9ybFrdwTFhX2mU87zmwi8j0g1ccbetHHsDKBrQustoOtYzAYTHxjwcHiZoG/PijAXZrRdpCawJWJaogvaLTC36YUwQWkR5KfsO2jNgUJm8JLNurnBuBQkzu4zt4wQRHl+fAWoPYf3LXJkrRH15OazGsr8ocWSa4+M5vzwsdcA8TAxJ+NfRiYcif6ZWhtQg67czLZG41SpDrcjj84GYkMOkas0CoUXK36P+iAV5SqxXWlBNCvzoL8lmPehR6E76gALlPTwEPeYK8yaWh9NlARERK4PBkleiDQZiTfkDPmSCEsKTKVpQXa9kRtpUFnWLT2HHiLCK7PpLubFsEsVeEA/3Iaz2gmVNJBeL7oZ4/Fw75FvlyJ2lRu4oGmqNIT/rlbkGSV8PKif6K+NR+lQBYF/TNd2Z7Yl0dBdEJKgArTi0CYhECkiyk+bN4r5i3r1kByjs3G8nfs4kVTje8CVMeSz8s4bV+u0ivbVr6iO4gOwg453/jrtt8sqL9YMSB3jAY+NH+yWoToOfs4xmGAbkgbMTI96NHXFPnbmy3FTwDWi1VoBUCRS3cDg5HyztBgGBR79Qbf8RJkYiqs1e7k4LjNLgGScneQ7RVB7H+vZ1zSJwtCsjWfrJEVVdLxYFmdClNBB8YeZO4d8jepQJKTYIRa5H9JCC3jGvY6KTcatZw7T3zHAn1Pe48CK5s36ows+M79+B0wUS0DMmqkbCoYdfi/xzYEmcZ0qvNPEyCgM/SQeAmXtYP6TDEV2Nol1pl2huf/N2sU/X/wjAtNyaGdKFDdzlpPOIDmdXtKdM/tDZO1luQ0w+MxZXi+JWCLTdsJ3TelglWN3/JcInZm+80emGkKvU7SOH
 P4u9Mk9r
 oFC+LCAXiqO3yhZCyqFqgQF+ALRa8035I6/KqGaxz7OG8X8+Z2RREPvdH4cuUJV8vPYfzQK2HxpUoKohHqt7++KlUY/IwN3q21814+yufY41+OGBGUPdVwEfJj4YS1t5xHIgA9nw3pwtGo9GH2MRVqs0iO0gPpyLrBReL8UJ7PMBB9Z1v9zB6HVRyiXvFa6BCYzvsBYVlN8X0NZd9rk2GlZa4D6U2a1+XnKahCtoVC7BYw29z44KNF5yTeaeOhpjRebn29SOPjLME7FuRvoKduVJvx882oYpSFJCMEZ50hVAax/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, May 26, 2026 at 06:13:55PM +0800, Yin Tirui wrote:
>__split_huge_pud_locked() updates the file/shmem RSS counter after
>dropping the PUD mapping's folio reference. If folio_put() drops the
>last reference, mm_counter_file() can later read freed folio state via
>folio_test_swapbacked().
>
>Move the counter update before folio_put().
>
>Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Yin Tirui <yintirui@huawei.com>
>---

Thanks! Feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

