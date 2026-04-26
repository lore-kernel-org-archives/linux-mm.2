Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31986FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447286B008A; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8546B0005; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E68B6B0092; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BAC76B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B47A289AA7
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:37 +0000 (UTC)
X-FDA: 84701905554.24.E594F53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 19499120007
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y3D5pfiu;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuMSPfqtflAuoVwUUmhn/Jz2bvyCmQccxDeLTUDXZFY=;
	b=jxYYvQ3wW3y6kw2NxeHZbcRYgbbVeuD8trsAy5MROKogZqy5c0Dv7rW2L12BhOF0+UByg2
	hk5BHwFrLwITeL3mlqAeOR4faic4s1cwXXwfKn0EejlfCEgX33E/f7g9oqtvU60lJNueFl
	Q6IX/6NExXMBDndj+c57XxKP3L4fPvU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236756; a=rsa-sha256;
	cv=none;
	b=uyHC8wlbBMLH3xNCB9zrZbyhBi8y+b5MnXgGkIZyxQeNdjEyHN4sMoQENwJfuW5LAEjvEp
	NB57bh/ECczSsVQX2cB7+nXzoSNzFs61f2rKNmen7XDKbCgI8WfeYXrDfr62rte58LF8GY
	BU1rQEkztmCVEZ0JbAwzg8E0jsKrEDc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y3D5pfiu;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 32AF044409
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C4FC2BCC6;
	Sun, 26 Apr 2026 20:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236755;
	bh=1QadOMZa6i8GGLgIPAt5QhHokee8K5qEtWxld82M5Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3D5pfiuhVeOi1wvnghj0VOW2j7fSBJtl6ggiQ/1yfV7+xkW46C3RLmgV6u25eDYQ
	 91CwAItN3QN/RDzy822cJJwXzvE5GOOKoT9gJ3d7BuJMZhTcja8z3GAQdjBXTnx15C
	 bDPq9to9W+sxbOHVJyeERJjT6D+6p/Uf+PTZJ7I9q+jyUKtgX2lTzAfSUHPRzuTqGL
	 UWhNpOO/hAPJ2mYL1Wskclhn9bmpCVVB5CM+w3T6PEsSvqu8IR/yq3cL1Bvn/jPw/C
	 4qnUJy8WC17BSO6uqXCxLFj32UFaRx5y0dNPJ6jcRkE5HOrY/JEd2WT9WmtS4xrweM
	 1SAj2DZPsBGxw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 01/19] mm/damon/core: introduce struct damon_probe
Date: Sun, 26 Apr 2026 13:52:02 -0700
Message-ID: <20260426205222.93895-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 19499120007
X-Stat-Signature: 7i941zers1p6of7kghgbw88gb63zepfa
X-Rspam-User: 
X-HE-Tag: 1777236755-686619
X-HE-Meta: U2FsdGVkX1+u6rAvWV2b1jwipBRP+4e8JGALLRGMHDnWtEcMTTAHeXMmqhMSQKhoqbuQ7QzIoQMnxC8hy75ZHJ5JiGgBcVxzHMihKvcWkxodv3oeOAW4W8rO+8rzF93cOFpeb+LbUcAouufDbu30+Y+sg4bHnzm/M1DOxNoHfcFbF8AOSVTFBpMJRN+znzJ6lALvZrRMEVFdWCOyaHLep9ApLZYs96uprFV5RSb6qh9Ncnq+jNxxUgJKCr5F83ictR34mtTDLzzvHbgBgjBb8ki/7J2GiNPb8WnLSFh3u2zO2pGfXZ/YDYX+YB9l0yLtZfUqmDGkPV4qhNJPTe4IrOXX6XH/CzCJ0CplxV3C9iMz2A889xAy4KG0L5KPJW3Il0itpxr7q728/8N98pf7m6ZZc2JHSNWa1H/nInz3r5u7e5ZEj/+Hrf1aMH9vqk8a/7fb6QvsXgNDTbkwd+UF7cPXrR3YEFPBQ2lEKyMdDfDuRWxkaqeVa3Yv0IppZvGAFKntMNyq9iqPAa6hlYWr0Hpg2O0dwaHelJr3CS1FvESGnaNmclfAOPNtIQptPz9/kDaCqfBxXiMnsz1Kl0rUtG9H5IBzZGu3uvvPiuM/avzst5XXD/+jwrP4rs0lw+30BoRrikyEP4+G8Hp8EzdtUlz/JHP5tL5X54h2hbyaaa7Dzbe7fX78ai4YlTj/ka0y6ybIaVNe7xUqQs/V9jnK+deUzd5HDOpd9SQBi+T6YujOMXaYvacYX9jYoED0TPnNMj/vr4jlEe6kUITVhiZQTp198S4fNUnGXMZq4InqeFX0dHE0dB3eaM/c6pomzU1O6LtR4ffVOhNEsvmYUDtcSnr0sbfPRmSIcBcWeVOOn9HdcTZZ+xVJ+NW/0/PCINOeQtQoOA/8pLYlFlNKPcosJ+8zRKdAbPcarMlhSA/xnEKDiVmlJZVxEgEZyO07zl8+m+g5HRA0lhIpJXRcLNz
 3DEPO1Ct
 aJlx1wrn07sNl2QyDNpoIyur1XHbArN1NA5MsspExM0ErfcHcrlQA+tvClwYPwWdgLAu3ctV74LCblH8bpapefZdWcYg4eZNRhZ7M22scKL5R40BHbOlgfjz8kZabGS3H2YMCtEVQ/Ej795TJ+8vxUKkVvh0ITRqh0bhXJrO3yl8uOvpfHu34547P4WjOxiL4iC8l5dhUECOsf2GrCJanVl6c3lJ+PT5KbXJa/GaOtB7dGKTU7NeDe4iRk02WzRM80DsjiSUaEDywIBtQnCD4Blq3s9uVj/P8BVxAiClU9U4wKa5VrIZsLqQXXGs25o7v7qB/oRXIXv1rkgKdm8E8wNYzThEZ2/MMiHJ3D0vUvGoTUGCX1TQPvZvqOcusmYCb8yKz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a data structure for data attribute probe.  It is just a
linked list header at this step.  It will be extended in a way that it
can determine if a given memory has a specific data attribute.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 7314fd9ff0d9b..da2f026eac725 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -732,6 +732,15 @@ struct damon_intervals_goal {
 	unsigned long max_sample_us;
 };
 
+/**
+ * struct damon_probe - Data region attribute probe.
+ *
+ * @list:	Siblings list.
+ */
+struct damon_probe {
+	struct list_head list;
+};
+
 /**
  * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
-- 
2.47.3

