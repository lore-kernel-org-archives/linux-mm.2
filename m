Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D236660A3830
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 00:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HsoiCMN/
Received: by kanga.kvack.org (Postfix)
	id B697A6B05B0; Sun,  8 Nov 2026 19:34:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B20116B05B3; Sun,  8 Nov 2026 19:34:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2FC56B05B2; Sun,  8 Nov 2026 19:34:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75B9A6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:34:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D33881A059A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:34:51 +0000 (UTC)
X-FDA: 85413710382.28.0D54E63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4509E80003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:34:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HsoiCMN/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794184490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUntpAonRvcpcVPcOCScwRYJccNQJLCTw+ohkdvE5wU=;
	b=jdhGw7L3TFBiIiTmwqHGi/GrsSiQfv0LPAfArqXya/DOe3qTKJ92M8UfJQ/7+IeFpL/21R
	Q1xoXOSlT5Vu1bT1aUBxS5cLa34PcK9fBWCWyhpMOUTlku3nkeQnfXG6TSpO1UZMm1ylt9
	KPDwqLQFjrcNb8YnSJSzdbtJKzsqW94=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HsoiCMN/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794184490;
	b=eVXRvnFU86vltf+MTGoFRDQ28hZGqQ+Zx9YjhHVenT3HejT6g3mdiVtabqPww9RROInr83
	g7lubtA1a92FvtoYiKbORzdIVTrawoU7blaEuyAESGcPHwZGvFh3XlD4bXbhZViOXViQAD
	w3+rZYCwRtrQhnkee8Lcp22MpRz+/IY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46F0361EC9;
	Mon,  9 Nov 2026 00:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18621F0093B;
	Mon,  9 Nov 2026 00:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794184489;
	bh=NUntpAonRvcpcVPcOCScwRYJccNQJLCTw+ohkdvE5wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HsoiCMN/4vqUknHAbeJQ8zWnIsiA9cwyA3KShKP29a1IqYoriiozg1xuzrT2FSfEF
	 TBpJ5a6+jCakiPJ2YzOBamupAt/vPeQqRIsk2yaHZpDXRnD3jxJTZOAxLFFbr4pJbz
	 bw57LH3+F3BtOtT6qgRkdD/n5lWDWs73CXMG2dCk0Dku26ghf3F7NVA7Ck9F+BIxXH
	 oN8m6r9wI8q0N0+pafyoBdQnfh67gqGU+3b3Cu4f6hgdZh6SPNNpRXsCPgCc2Kmmcc
	 XQNUMw2LQLCpZ3JitexPn73wa00owe7BIwjDhfWigaABg/zMzYCzIa1hiTHibWvruc
	 qPJGwYQbseVFg==
From: Sasha Levin <sashal@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.18.y 3/5] mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Sun,  8 Nov 2026 19:34:34 -0500
Message-ID: <2026-11-08-1-daily-reply-0006-damon-6-18-sysfs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261107201001.206120-4-sj@kernel.org>
References: <20261107201001.206120-4-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4509E80003
X-Stat-Signature: 18g4qnrpwoqfnkzsitugu1qi9kqfxnjj
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794184490-503421
X-HE-Meta: U2FsdGVkX1+M6jeDVxNUYktKDHqi2tDqW8D4NGWBm/tWhUrKnOCUGZpKzpauqFz4wEtLN5n+DuN9tXm21ZxdSKVH+167GcKK30mHZBT2cYpDdYpbR8MizjZ6RmMzVABuhY+RVSq9ZeJ+JXeJuNQuFwcLEZKkzR6VBYoNmGUH8o5SMM0YdcsNfj8ouNVp+7yB1Nm6cNCn4X13/dcCasDs04lenzHYEEkpV2BTu8xg+cF+MZ8PTKaXlQQniUJT4mE7ONatfFXCVkdlcrKlKCf3azb8Y8FchvccfQYta9PAB/4BziZ7Q4uSaqLXG3ngDdR0A+LaoRQXht0DqgB6E616Vc+FzRAvGiOzy2rXYXh7IlqANUmIYrj2IFedFvo7vrnTzyiCzJRKP6sjaOTbH3e3LJRVMHCCucKySU2ku4Yc4E+ZIjSiMvW/QynxrFcRWhcqUhGryyFZzSs5hA/SwQ/aurbBIsdIqIcmNqLU/VmX7iI0p7Y175NHwVjFNz7RcVouABy12T1STUPm+Hnj5CK+YByTlNaX/5IBq1HqblEix6NcTlVptSOQ02tK2h0TGixCZSEYTs+Z1XTh/eNrUayM+tMsi9YN7s+vweyzwQXKktbxpHhViWHfhlDvM+VRPT6XkXqlReSlmbrmwO+U2eiQ0XBouDOY/doZyenzHa+SuyuUDuRSG+/g3fnQJjASpwI0VrAYOpP/VP3EBxFApVjFQnkQ57lHsScMMGkEf8xu0ubOzlRn8+pGUKlB2iINvyko3gY4x2y6xGhoRq3JBWBQrAPHvfpRWNlIHOR+hjGUq1spH32OvgAu4E2BstgR1Zl3IXRLtqCGkNELlSzV3TA05+i0NrR4Oj4f3es/oZ2EeWD58zO1vqzyBGH+qb6cNzCpvvTOBeaVbr4pfAPtljUY0PsYHlm4t0im6AmPdY/Pe+4XpgdguVn/admHiYJw2KHO/92Kv2RCb0+ebj8dBsj
 H9EKYyMO
 Z3eB/1VbSpkwuVfB1KB0y1pdwNoi1ncEvvYOXLbp2iLibXoZReJqA0qjZvLl8KJT2W7kpF3xDdOIM+1A1x6rLKBE6JHAC+ACWtCCP+kqxvfx0G497LWjhlzluF514jKqEsCLrfM6chxihMPIpeoLYe1FS+iRSD04b9KclsFIpXcYRaYgGtB/DOdav97MWaIxTaKsd/C+ZknxfAjmBX7KMSEUnKl6MMOihWcPHhs5cjM5SjaHoyBcH8NIhfsENM3rMCT2v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> DAMON sysfs interface reads the user-provided size range arguments for
> hugepage_size type DAMOS filter twice.

Patches 1, 2, 4 and 5 are queued for 6.18.

For this one, af19aff38d6f ("mm/damon/sysfs-schemes: read
sysfs_filter->sz_range only once") is also missing from 7.3 and doesn't
cherry-pick there. Could you send the 7.3.y port first? I'll take it for 6.18
once 7.3 has it.

-- 
Thanks,
Sasha

