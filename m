Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35590CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F58E8E0074; Mon, 13 Oct 2025 16:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4C38E0036; Mon, 13 Oct 2025 16:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A318E0074; Mon, 13 Oct 2025 16:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 534AA8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:33:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B2811A05C3
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:12 +0000 (UTC)
X-FDA: 83994240624.04.C281B8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6CAF316000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mvk2TRk/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387590; a=rsa-sha256;
	cv=none;
	b=058cwslO6Ozj8lB1aW0syP2o8mz0oWJy7sp1vbYtQG/XQXcwGLHxB1U+fsra3kbYSUD2WI
	05vDo+obTMDbvGoo3dUFQmw1eU4ChAvDR28YTetFr516G7GAf5yQwaeT/fsGzGSNBfCpiC
	Ea/MkOFbamvgDidCYEusf7Xwa1ZsPKg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mvk2TRk/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmTLjYQQ/0CqCN2dhlGd8rUyrWWTxzH6CtDl8ZrWugY=;
	b=xPVDntnHGsfEyrPtjiDQOSVOFBdgog9u0N3W6YliQGur7kAfQOndIxm/JFm34t3qOCtgk3
	4tF383F85yhvOf6nBhBoWBqVrDZbRFDoobHiOOZZfNDLNAtGqWjJubSNg33XpzYc4SWtKP
	TxqklUtldUW2IKvY8fz0jeM3jrLbX88=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8066F437C9;
	Mon, 13 Oct 2025 20:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB19C4CEF8;
	Mon, 13 Oct 2025 20:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387589;
	bh=Zhiq4FAEYOOXwB2NcOIuEEVkIt25SGkU6jm55H4Ks4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvk2TRk/bZZDmvYyXjSpYAxJwwi/0/BeNYW/oH0NNdambWd5E4WhkKaxkC2XnXaxW
	 cvQI6mZnNElgP3DiWGIvqFiUh2qwNYR6She+AIEB+7ET2ACWDZyMf0gvEyfqLjrTN7
	 n9uGzm5WcL0neq9dB3jTkqBbPEaZdFex/CXOy5wSF1uPegIF6Nn7fC9N7IMrOXHHrJ
	 IOmF8CKgE9m1c5Uytlqa0/dxqolwmLTHo78Mr6tbW7UxWY3enyTlF/w25fPF2m15t6
	 EALCRcJz4/b6qwAHy1Fzt+Og3PkSds+SA+Q6/y0JeMPEINCV8R9rLAu+IkUCCjSKIJ
	 UflEVdcEI22cg==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 09/33] block: Protect against concurrent isolated cpuset change
Date: Mon, 13 Oct 2025 22:31:22 +0200
Message-ID: <20251013203146.10162-10-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8or88spd9pbkbuo33wfwzsaw84mtf1sb
X-Rspamd-Queue-Id: 6CAF316000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760387590-733794
X-HE-Meta: U2FsdGVkX19qzsGD1MgKY4ueYD+kHSUsztEf1dXgO5o5yg++pNgw5f8XLNrNeVABA7WZBDC3ol3h0hdQl/FYZr+Vw/pHRFT+X5VsvFoMD7tNAywMd5Z00cpEYloAQbO8bjuNShWQtz1YVEm/RgDKJiwQvtjq1OquPHl4JWiMBZCTbvW4gnv0EyPPTMuJDkRGeVJ+Zm0B3MrYrDHWCBv146MDUZbwHGdZRm3WBkxkCkCAD6URokQBokN9FtLF5zOoOV2j4bgbxm02rQQUIHraHgvz6RDssrJvpyBbTuOAWtN2AkyErMTvhpEENfhvwqHOAq+VOgIVOOt3EswbXSq+wEkTFAMVXdg0NZj7AzoPiozEVtmLpQQZoMBIN/x9iYHt67Eh2eD3bvLCgFA5d45aRi3BwD5bDRSgIu5ZnD+GNLHQNDaAf5m5DrKkkxtOln575p0513UEFx1d+tkBDIWzBzEElV+dJDh4jt8RXleL8WWCs3fTuSfInb1uEQbrymf+gwBOuq+4aZYjA/cydIiEQBxHUj2FwHX27tyqZFxDECXGO8iRtJ4HpiaB7+Q2fY9q653dBq86giKxcuVY6zrvjP2OiJb3CfIjP9GWhW+PT7NIFNgTrwpYcgOirsSnqRsYC//mKnbOLPu5Ih04A8fUPQ/BxsJCX9xX8R/WFwhUGb+I2UeTuhcaWlWejR+jePZZZVB38mtBEZUnCf7/xgLZLxMM3lARCz8VEMLkMUpiJl51wG+Xdtu9XRam/TK9kCiUe+kHwHFcydke2uvDxoB/KoJ2VQS2tPaymD90tLSerVcnWrvt8Cv7MrfR/qPHgfHr5AYtYN8PRjMiJqql4WfSSCvFyM5eCVmIu6eXYYqE+KQfjzVhECTbbsT3XPLy4AstMSacB2Vq324w1S64jwyeBMldIbV/v9GA47qarimIvZNAppzNQ1KeZuu8PvjIeIoHKIViyEIBdsA6WgP2HJc
 oRceE6FE
 2eehy8s+P32l+6zBuIp1Lnz5fB4CQaQgChpeAEqloVqDJoH2i3B1jRnX/iVQKF6lTYB2lV6sIiq2liKkeSWtc3b73cltS3DtCvKs0jhxMTJmV084izKONZXHZ9I8FCXM436dIW7dE5kyMqYV94KzhhoQLD80+w5cT5+yDNMshsvKe/4gNhUGyjIfWReBs3KAAYisSAB5h4NM94zGvguIdQPo+BLvQTJXMaFnmRmZg/e+HlFQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The block subsystem prevents running the workqueue to isolated CPUs,
including those defined by cpuset isolated partitions. Since
HK_TYPE_DOMAIN will soon contain both and be subject to runtime
modifications, synchronize against housekeeping using the relevant lock.

For full support of cpuset changes, the block subsystem may need to
propagate changes to isolated cpumask through the workqueue in the
future.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 block/blk-mq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 09f579414161..ed1b8b149a8f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4240,12 +4240,16 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 
 		/*
 		 * Rule out isolated CPUs from hctx->cpumask to avoid
-		 * running block kworker on isolated CPUs
+		 * running block kworker on isolated CPUs.
+		 * FIXME: cpuset should propagate further changes to isolated CPUs
+		 * here.
 		 */
+		rcu_read_lock();
 		for_each_cpu(cpu, hctx->cpumask) {
 			if (cpu_is_isolated(cpu))
 				cpumask_clear_cpu(cpu, hctx->cpumask);
 		}
+		rcu_read_unlock();
 
 		/*
 		 * Initialize batch roundrobin counts
-- 
2.51.0


