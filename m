Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1693606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oSZeaabF
Received: by kanga.kvack.org (Postfix)
	id 974626B05B2; Mon, 16 Nov 2026 21:31:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9260F6B05B3; Mon, 16 Nov 2026 21:31:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8638B6B05B4; Mon, 16 Nov 2026 21:31:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66CF86B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:31:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3898160300
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:31:30 +0000 (UTC)
X-FDA: 85443034740.28.BC57B50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 403AC120006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:31:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSZeaabF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794882689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCI0ZTIYgpjkp1xihqDqQLBdIOvJgrIfJxEzga5fc10=;
	b=Pf7d7E55RygUfik6HjaAYTLg1LWH0mgT359w/CmaqGNDMw8WVEa1g/N6akKwqg+PpPa/Rs
	GWGsR1EuKmMXg5YooXrE1KZLXTrgW5bql8CgnHQoIdIrnf5nj0mC1S/1B2iPSagoY9dewZ
	MO6rdssXXiZKKjPybVoyt7zEL+AQyGw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794882689;
	b=zYGAjCqEoHi0t2qNGb10/1BtCptNdWtkmjihscunWyAtri1vpe8t10WLA0YpUVveh8m8EF
	srgrTe3Jcoe7wW27jqhkovwWDOTHdN1/2ZMBPFfdHzopqf3vvovhXAENktaple3JPNIrZT
	LiRLNr3HT5nIm42w9FZPj8X9K53EK5A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSZeaabF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8BDC62741;
	Tue, 17 Nov 2026 02:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F5E1F000C4;
	Tue, 17 Nov 2026 02:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794882688;
	bh=FCI0ZTIYgpjkp1xihqDqQLBdIOvJgrIfJxEzga5fc10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSZeaabFsDqhBvaA9sMQ/mElCYGAuc3fuLIcmD7BCB4z+p1LH1kkTDxvDGmli2Ina
	 ea6wR8P8TSN1aOdx9FSS2aSJO9pTR5E16+isUsM1sDxpwlzou2r+k0aQQC9qHSC8Af
	 C4QUQGA9u7GLMnh2p44/lE4MIsTMyMPQ8JtV7UKKGwRGtwoM7oYpK+r5r5jRtyQ5H6
	 V4cqTLBXVHAnXzBjPxedsz/TlF37LElNj4x5NrUF3+CmeUM3WWK+KDdbwbkdDX5apT
	 lF8zHCu4tdVfkl/QtfFw7e0/l0B9eCJMawvL4Qz3y1VXsZZCT6wp3FPbxJiTwzfUAd
	 zezyEhhrbWYYw==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH 6/6] Docs/ABI/damon: update for sz_ops_filter_passed_last
Date: Mon, 16 Nov 2026 18:31:20 -0800
Message-ID: <20261117023121.110826-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116-damon-sz-ops-b4-v1-6-1cffe7227e6d@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 403AC120006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3z4ayipxw91i9qmny1faa1c63cr1r857
X-Rspam-User: 
X-HE-Tag: 1794882689-606723
X-HE-Meta: U2FsdGVkX1/1QGxkgdbP304ko5ra+5GWfwy+EJqmUAvyZolxdeRq0sj9O46WMO/OviZF08lhsEcq1+dIXAx9a+SQvW798vkxxmLUOUjmct0ogPTa9zbCuqT7MyXrBPdQ+LwW6NsXohgcRzq1AczHD/Ic+FhJY1TS0ylLyOI80RpJMuKt+6n9dH/nvqZJJmM46KGGrI5RRCtl7DkupYC1scjiZ2IYm4tfu3Ea6FJiAQFI0gjJ8Z/ADPtBsgE2zW3YZgI79Ajwq2J+yHtI1PugtIc/A1ywpTZzcwegKJc3VZKmtFTx3rBIqyd/I6laYwP+/H/uKvI9s7I+r0ztFJ/AJw94B5pH27J6sI8NbZYncLs+asNgfnW+B9Vu9ittDs0Vo9Xwg0NyMqDt5yUV+o6l8480hirfVayoL8nRZYYh590RMr0fuYzcXf1pQQqXn8Uklh1riTpvViMgNTR3zATTIzMREMuoo3Q+l2MeI7YGin3d12dU6NRF+9hYJBYvKhTqTVsmHssPTMmg3noriZT1RtsIel6Bsmmt/PVA2maVJHiA3mooAaf61L+m7I+roC84W68pYBlvrXNgkh+EshsRlG0nl4seXtihsCc/ErXP3YJK3TUNkn1vDa7XOFUFHkeCMVktGl2CPRnx+VevJzHE+TWJ87eTpwbCTCsiU54ch7mdTtGVwlwGcAq92Efe5rpJZ7th8u0pbPW6omwIPn8f4CUW7fMg8u4ULpO1R3Uaet7Nbwdi4kfyiri4WTBZWBGLMc98eCXeBoDkcuA676RJPlh+0q1DFq52CSWOaAwKWtHRarCzxER0HqQq3XkqMMMJdX1eGAXPbfaYfLKGvzuObXlaFn309TtRGOFgsiUe/MEMR9nSdUK7gezM7aZT5bXnbInDITlnquGI2CYXEJZT0SuKD1d6ZRVOTE2hMvInDTOOmJoyGGOtNWNrVMTAhXoSh9/bosTbB84sJ2MJHSY
 FNWgRuF/
 DUSms8cUD57dv/oUN00wG7edTUrRA9zhCNgNAlvlYPQKH9CXDa9Et10zLClWrrsQCBiBfhgnxDMUxeaV9o+AzyDTIpWjQa3txdE0v+p9150H7j925P8rCar1uUWQMV1JmHDhDY/6BdyhfuJB03n/XRS4fqjdD2WH2rUXA9bKEK7d3Frkk52peAgjBNcWBqXJSUPKV0VjBriaET2nsSxuDXi9XqsxygOTFkuaTW1Oi8/AnmpYwteZNHB3XHwDnhGfNvSRjD5VwM7U6QookNm5dHoiV5Girz1HpjK6Rqfgc6o3oLUbgz4Ax+12gdFU+6zvWw3HkRTNpHBtkeKLLLRC76buBCpC/g/+feQSqQhmPZPqG83hPpN9352dVZ6gruaSzIpL5BIhWSNmKP2w3aif7tT/5b3Xq+KRT2Ha1EbdnlcU/eKzCt2KbBtfqgxvLZhPNd+83
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 19:10:09 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> From: Mattathias Pinchover <mattathias.pinchover@uber.com>
> 
> Update DAMON ABI document for the newly added DAMOS stat file,
> sz_ops_filter_passed_last.
> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

