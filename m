Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE87CA0EFC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3046B009E; Thu, 21 Aug 2025 13:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5930F6B00A2; Thu, 21 Aug 2025 13:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A9618E0001; Thu, 21 Aug 2025 13:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 31A976B009E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:16:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB97C140470
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:16:54 +0000 (UTC)
X-FDA: 83801419548.01.13D3748
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E5A5980009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:16:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kbcc+nuU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755796612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NbhHCItr44zLy08tsKfvYB9GtznMmeZEmIatbZpwYQ=;
	b=IybcpE4yJ0Yk7o5+8Vy7VkdJCQEVw5rXWoAV2yENxfkwzSXoRRG1Vc8B7gIiZWRLJeKQcY
	vUsKapOKhXW6FGXpUATa/iHFD6jF7YGR50JANZVG3wRQSIA/8Ii/VL0JBZfJy2nacK1zJs
	6xTfRk6xWe4GFFELpmrKg822LKBUONg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kbcc+nuU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755796612; a=rsa-sha256;
	cv=none;
	b=tuTrVt+dX+N1jluDgaQlDIXjJvIfX25nttNpHhozgZeOFMkhlK7iQBvgjdiLKzn1GTHksg
	YQuG2gQsgUisAHIpYFbQkaqHmcmhGUePFpE/cgjFSxvj1Dn1JEYcsug+B/5wr8CeN85j1O
	pomx7gE8DN3eZsGiYXE46GoZ7Bv5r4M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 40682601F8;
	Thu, 21 Aug 2025 17:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A45C4CEEB;
	Thu, 21 Aug 2025 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755796611;
	bh=3T5rhpFWpP7D0v9Okb1ShoQaiWCVpNjwESTpoSd1OYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbcc+nuUOlC2C89O9MlccwmYw4h92fJxE9CwNdYca1iujvbhoITJVWJqK7zyxaiQ4
	 PlXlQzvhIBRepm0Znw2JcPZdpfzrRX7LAj07CvJ6mYfMplMdJ2YXHxnGx+PSYAhxxP
	 3qRumda8vnp52O3rlD1z+X5ifU3okfll4RsNR/8V3AvpQTbYRNE/WLoAFRnFMdx6oa
	 QWrtPG4YJ5Bbv/a4VWBfv9Tm+x8msW2r2rxkB1XjVrNtQ6aFZyEVmmkR2Yrj+nDmnt
	 N8riExVTzAZRzEP6NEXzdB8hzMtNtb9p4re4qV94bD7VyUqLBl51A/huYNLmGFc80k
	 2QDezaFIUORhw==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 04/11] mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
Date: Thu, 21 Aug 2025 10:16:49 -0700
Message-Id: <20250821171649.81870-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821105159.2503894-5-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E5A5980009
X-Stat-Signature: 8mcspqz4ctyhdpktncedx37hspa6cpxa
X-Rspam-User: 
X-HE-Tag: 1755796612-253799
X-HE-Meta: U2FsdGVkX19bhhVvID8Y3rpF1TVXr0aASWjq/KVhM2noqOw8sQa8Y3ABsht6T3EZ920spOAunuJLr/S67bnin+lsABOPSLJ1TJKcdM4beB3uzlf9x2Ndwe1sWFl+g89Yycl0DCSymD4N/7zaNhjMYpJvj/ktphAzg+zTNAyAwqmePD4ldb7h2XLl08SaREC7nrEH/N4jMsIKtN6+dZBdz0WVGNLLeZtQRAMLoIxCOGy/PYUPw+7ojAz8Lvxa6awy4jIvHjn4q+Edn59PDR3LbrTrGm3cS/07ChSyCUA40yGhxG/nihGvzipRUlRY/xz1q1xBPy7GqRCXZqFPdgH354B1MXbgLvSrazFqn9GdeFm2KhE199aRmel1A0RSWviMFiDDuXF9EjVBpkLqt86k7j3/yH+6VXvNL36oi5ppHwsfaA4KTMa9mbhXN0IZlT2QqPk+UepmCc8jFFb7jP0GmREqiwhuRdkRU3lqfpoM9iz1zX1g8GMVQI8CBHVtqxIk3zUYKop3Ak7Bks78jMI9GcNpzoUor6x/2X8pXkEqZEOl+uJNSREfoDpJEc1DoP0PoH3aELHjGFFRrxMDnN9yZBw1E/d3TfjGnCR8u8jVI20Ljy6YvZhBRtZ1aH1xApOhwbN5lBHW2aQsxlXH0OCWf+6ssgMlYyL9grXrd8C0s4nTmuuBAywFO+XJGJ/hXc1Sqz32Craety5VBrTauMh+2aoLwTqQG7yIvlaaK3d3aklnvA9HT6IC3flc2SCQw0lLlSKobzug13jb+rG/BdP1rLS0ONruFSN5PDRCkJi91d/DirIJ8gUbTVjzyDui+womwK4jh8VbY1xaN9Da7yW8B7KlNbMjorbWpyHqq7+ZqC9V3r1F2OiWCXzxXNnmNZbnsJij92l7AZ96dNwWX2TtxKUaY3pTbHBUF6Mctn1kR+m6H+drBrFGEMI9WBiguVD7HIOryEMyZJofkl+YQz2
 0coCJOSq
 BYWnSEeSfOw0muk+waZ0Bw8T09qOVb4sT+PNXhSwZ7yevrq1oXMuuo7SBRTgwZKXoxYW5eONiwS2FR6zeo7q1nAWHxclFvL4vIIVdMRNeLR9seKTo/etq6IiQC2CtqZ8/pEdYZP7avq0p6R+tpMymBB0u7nlQUmVCTdCpaacuUfYgy82XG18ynXBJqkJAfAcKgxyCyYD8ROtLUBNRy86lTggqicR2t6LjFFo3RMx1P9IQcHbXCtciB+w83oxZxstgsAVqVDQIcMMoasNOweZR54k8CNQLlGcHrHt5N6Xdnn0mpx5pYsF6n1AhP9zmhdJQf/+HcKIwx/nwzaE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 18:51:52 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add support of addr_unit for DAMOS_LRU_PRIO and DAMOS_LRU_DEPRIO action
> handling from the DAMOS operation implementation for the physical
> address space.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

