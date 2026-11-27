Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECBF6606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 18:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KCw/DWx1
Received: by kanga.kvack.org (Postfix)
	id DC10E6B05B0; Fri, 27 Nov 2026 13:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70E96B05B1; Fri, 27 Nov 2026 13:48:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60366B05B2; Fri, 27 Nov 2026 13:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8A096B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:48:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30A7C80458
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:48:05 +0000 (UTC)
X-FDA: 85481783730.09.D03FFC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8F2688000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:48:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KCw/DWx1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795805283;
	b=3wp8IyQZilBRLuJ7sm+3UXDteMQmWZYkL3G5fAEwzh83XU353vs+VYEzhLexElmxf0itQo
	CfotsdV+eI40g9ymiVeDgjBr5FOvobMwBU10vH14WeUkdUR1C4hjwYAgxCdPqwJLULAn8+
	fNh6bPJJTAjqfJYyjFixdBnZIezb9T4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795805283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgphAMbCsj6BZBr1UDrXHUrDuxHDUOnRdeoRJ0I336E=;
	b=nhjFCPTBuebpwDNSXNNR4wqIR8kw8mvGDnXPRTncuKmT87bWRtkoXz9Qd33ygJBNmL5IKQ
	sb5xtYvs8qg1k1kcGc51lwQB57msdCRGqTMg7m/nxdF3iKkbhBQWd/lUI5k53WQfPMWMBC
	v4noluA5LBzQMcb/A2rXMdOBTpFfGzI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KCw/DWx1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE8DD611D2;
	Fri, 27 Nov 2026 18:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD741F00893;
	Fri, 27 Nov 2026 18:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795805282;
	bh=bgphAMbCsj6BZBr1UDrXHUrDuxHDUOnRdeoRJ0I336E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCw/DWx1k3s/X2jV524RlXffZmDM5aGw4E4cPZtaD3dvWlsVGFRM6CYzY1RYdSCG7
	 JQfTlpmDZAch5TrnNmf1liMQ3k8Wl/QQTjfcf/Ai38KdsBVJtDVpGAppF0P3Y3hBVj
	 7H7MSge4qXI3gNhf4C+Jff/QoJcu9b5VBKobGCFBKD/rgDpucpP471nC64OD5eoRDm
	 QXT9J1laLK0JfsVxAjYfqOThRi54OomVbVh77a6pju0uDSa0/ntS0hr737wOYnQYWJ
	 kJBphqhzMIU72VpHyC9BUZrCFoZWA0uW007uEq+C147MCIvxtvEo6/6N49bGs/S4eh
	 w2BK3E2gc95Iw==
From: SJ Park <sj@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/mempolicy: remove unused mm argument in lookup_node()
Date: Fri, 27 Nov 2026 10:47:54 -0800
Message-ID: <20261127184755.87615-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127-for-mempolicy-arg-v1-1-525295a1b31a@kylinos.cn>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rarsenrabbgmb3jzcf334kz5tkk3onxx
X-Rspamd-Queue-Id: 8F2688000C
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795805283-372017
X-HE-Meta: U2FsdGVkX18geXmzkR/yP/XZOcBMoC56KaT+O8QPLATXLuRlgUpxkJ0imS0/3h66a4sVCmklZYT+p47SJq1jA74gsPfPnvsg3+9EjPkPGPmopHtfFVpvPgu6MI9tkCbwVCcXdM+APyPa7aO/2fpQL1301R1bNTDCrlr4dQBKTnQH4ZKoEcVH2dsuXFLkZxubJiYl1vOnkiDYq8PywZl0YhVdq9GMgcMxiOX8z1o+LLhAJHoN83s+dTemlaSPAI3Pa08ptj1tw/Jp4jzoSSFpEi/rWSGhD8A3Jl4nQFS26DvZIonF5aQdnTVQ93i5acouAMf76ZyBPMX5viZ5spduak5bBuDxyUin6ZnLFJh+VJkxSE8+yOX5TtcYePusXZ+qhjoDXVXhgoSCJSfbtwAEwe5dBFRtvu2+AT6a69kfdNeaMtRaJgXB4cOOZbdzXycCbLq4yR1ff4XbcX+VhzyEgg5YDN78aEp9pH/kZRaLigIjVc6M7Y3NVjtdbmlFieB/0leSRSzq1QwWRnf/4tSaT5uU/AjElUKlVebPidBPMFpTlI8Hucav4TlGDQ8Ugz+oKg0nMGlEpJL60RfhPNB5yCLBWB0Z2PpmY1IHxSgc/ckKlzKj455n+xZ0IjWhWxlt5ZM6ttYZBecBMRm2e2O86HCpD0gQlwDXqpAvh4M0AIVEwdYxCs8hoJRbuRKCSPgX3cWGmU+xGpJHw7Kg/E8sx1BBpxmc1tCHXWQrOIUE3Fs0s+APKZ7yUICT7nFZGoYCIlm1aaronAFb7nCGkMcfthEVYun7aEOw5OQO+eTpCPeEWOrvoYbUodkpydog64RmZUw7XtxK0lIVWR62cTgrAN6c2jFJ69FmiHvwb6WB4rWi6bDoQeH+1SoDTQSGEC26wnMKnGrRTbgtTMTOzHR5MBqZjgFIaflzcJEr/SAn+XuqVbgALC0Nf6KaHG2Sep8J0vd/4uG6r6bsf+q40P1
 egj45iLn
 fInsTSeZGFoXpbqgEgEUxPOlWYflr2loiwJul+U2yUVipCZLXTr1POphGf2aqqYTSuZq+h7iA7BW6p9E5CSo63j3Dja325LYDjLWw97i7KcbvFUdWd5Lka116ImJ8QGV+s/sFujcw++sy9OvctFGDHUQaxMNhQNowA7pvWKwzOABYw5xt0xUlVl3a7ffa3ukj4wYLvOLJYx2tj4x10dn1dH/Wz3vkSidB2wx/rjIisTjueO72BDYI5OUYigG5N9Z5qi9QkgEpeLJ7zX9OfUK/jpf4SI1XzwW6VrsOmSGVDDdZnRe1cLAzgTN8zg9u/LXxCf21HSTvgljs0Eh8EOMQMbzKjty0Mmpb9jBSEb6kDyxZVQIncOPE2okLvA3QCmw650YtHLyD9dQYdRtl9x3ot17HmHaZf3FlEtuZeSuCPZfTowMH+u6UjGq/ZbuS9PFBS5y3+xSSd2dQfRL23yC2ElkczvcuoNpQvR/3yq4buG89nm5fdOJRCBGmACwaPWKbYi+DR3Z+Pia1ElXMwsxOe6Yqcoqu7BHgmVot5PTJSiP/YmZexmOCzzprQGpQDQWeZwuK5UNCuJL5o+fxhN3Tmx0dMsDWSuv44xr/Uz3JIXjdgLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 27 Nov 2026 18:35:46 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The mm argument of lookup_node() has been unused since commit
> f728b9c48d56 ("mm: change lookup_node() to use get_user_pages_fast()"),
> which replaced get_user_pages_locked() with get_user_pages_fast() and
> dropped the mmap_read_unlock(mm) that was the only user of the argument.
> 
> Drop the parameter and update the call site in do_get_mempolicy().
> No functional change.

Looks good to me.

> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

