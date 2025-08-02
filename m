Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD17C87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 16:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5FC46B0088; Sat,  2 Aug 2025 12:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10156B0089; Sat,  2 Aug 2025 12:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25A76B008A; Sat,  2 Aug 2025 12:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC126B0088
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 12:54:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3DCDC0495
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 16:54:30 +0000 (UTC)
X-FDA: 83732415900.13.C7651C9
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id 34B661C0006
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 16:54:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="iKQi/ImC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754153669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+GGQ5NGNQtRYekGdswvcZiYxvhKkqGKPYapabXTylk=;
	b=hH/6LbAWmuKWQo3D88fKyMZdjOU44aqj6uW1ELJbRNW2l5QN2o/WTwH2Clj8VJE3CVPSRt
	NhqEtWnKROGaCOwA3Qi7D5dwGWb9I+ilclNFBacTakfaDTCR0aig8n3lZQotZSTHN/HzDm
	uPIxjBEk+VDONp+6iDjQxDuiVP1zfUQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754153669; a=rsa-sha256;
	cv=none;
	b=NW6IdG4fn0RSLr9RU6BsNOy7WrKgyM5NmkyOb4FufuGNkkkivU5eOmXIbiLWhIWjsD+e7w
	3A0RFAgswjEWrSuCAdrNnGnbDNxkT065oCMXrd8m7nHL+fsfiChNIJ6PoZRxgFRLBuoT5b
	XqxDbTf8mlyRv2o31U4jhNrMuLNYGf8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="iKQi/ImC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 4E77C5C5B09;
	Sat,  2 Aug 2025 16:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949C4C4CEEF;
	Sat,  2 Aug 2025 16:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754153667;
	bh=AX85VyhxhnSPCKuS6eMk7UaT+Kv8vjrbD1Hos2IBnSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKQi/ImCONVsu2B6kD6dPYytCnW0ab+2A7M7ls7rcuQZRn0pqtqh/2OMBFixaGt20
	 MJey1bzkq+Kucqpmp9XBkHbmV0lR3eZTV8dwFbU2Sk6QIt3AjA6OxIxx86UtjY7cic
	 f2v4mI+wZRiWpTStpK62oviabjvBd986b5lhblgfZduzSoKMcr/eMSYkiKX/kC7wqd
	 6x9ZPoxiLiwcc0xH4X0kC2moSlE7cfifpVuTrM7OZ1gWuhvhel4mwNuICQ9mhvVwoN
	 ugnkKuWPOcmx8h0n0rFvMcLg1wj4VuAGWAEt//0Rif/Xdh8tHaMEXwSuyVMw6W/mPd
	 l9BnA5QabuikQ==
From: SeongJae Park <sj@kernel.org>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 1/2] mm/damon/paddr: move filters existence check function to ops-common
Date: Sat,  2 Aug 2025 09:54:25 -0700
Message-Id: <20250802165425.7088-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cbe01740f7ac5ac7c9fd1ca367d297c3d7f2a69d.1754135312.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m9akqey4yc9n453ayomw4e391xc1nzsm
X-Rspamd-Queue-Id: 34B661C0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754153668-924294
X-HE-Meta: U2FsdGVkX185mwFEEHFLjp8+JJDmN2e0Ik7VwmoXV7XlxSHlZlWuhVo1qE3YxVHL1RaY2yvFiPOsmE1GYdQyiFRfs1TMeMGz2n2WWhJ4mzBRKivcyOg347mqRJD5Id7E9V/MY/GWQCSgCoMfZH2KeNkqTQjgtmuHFS+Aa72KGikaz7EJu+hZRjSJoNoK7dtpZfbp/runfqrnfcAm6tg6ZA4HfMhEtxl1mLQt+SgqjCxF3uFtM5hz4uTuEAXLxtbQjflKb6O3pNvi7IBH1XoTVTcXTNilRqEebDZrG5z8zR170L/kalnchfXN/QaSfv5DqWYaNidmWHJXSPzRY7Uc9Gdiv8tCSU/eBBe2YeWNCHT60xDCOCA7Xn1Hru+krH5XkoUvds4A5+AhDGsVcD1wmY628qdO2tlsDf8BYW9CNpgzAo0Cyx2sVltLUv0So1lS8ES2C/YgrLGGCwQKctbYgKfYB1MD1ADai1ZRUk8UDE6f/UTgzOmyWPhhl8khGVsQfBrSkzRKMjWQVB+ZUAS+cevmRIZcTWGoxHvToXfdRZrLHUNHn9CfCNhSmcSw/ZPBYnfNd2z6CgOMApO2ID/AUOm2gwN1sioaDT6+9j/eqjagqdXhfOFXLSYA5ClDD0xmQWPmHm07ryXWQ9t05HpQaGm3IU7blx+54kC1IjmQyofrZF70oHeyMaBa7BmmHzuhIJxNIcbjrCNNztEn/sjE7RRbxOpaBt/F4h9zVDs9BYqQFG1A3nSMx3tD/W7ss7Kw7J8OBXm/4wBZeyYdowbgvGq9vYt3KHbaOVVOJOpaHYF9i4YYvNJI3LS7FP7w7nv3lSRY7hWoAwQi/VZP1oDIBUO0nui1uL4d7OSBFzArjmKztZH0WkS4NZ+wHlDTKv3FZKELtcB4gj1mQucVd2ckA9uHeCb7KmbYZQdQqm+O3S+8IAeRn4IY25K3kSvWyhRAcx0+cF/I1NOtsVKl/uE
 sp54TTQT
 +hOLvyKdvQk1vdN2qUEUM0e7bEUiVbiiWos7pXsaEaEJ15ZXYIjZXmpJEPhzrG+KdbbigknbWA9QUBQrUEDs+Jzu0Tn6eSv8HpU7cdKMLZlmeEQKHk4bnvjcPiD3fDWUxDkjnyuOebJBdNhf8px6T0LHPLqFF+GPTTMeDPkSgWiKW9ZhoZgIig4HywEROmdUUzuflEUbJzRMbbM+QqAhvKjsHovCrwGm+eeSmd2CZPuRcuYaEp+Rl2Bdg0Avn31I0JVB4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  2 Aug 2025 11:52:45 +0000 Yueyang Pan <pyyjason@gmail.com> wrote:

> This patch moves damon_pa_scheme_has_filter to ops-common. renaming
> to damos_ops_has_filter.
> Doing so allows us to reuse its logic in the vaddr version
> of DAMOS_STAT
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

