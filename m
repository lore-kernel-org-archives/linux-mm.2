Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79358EB594D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 02:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83B6F6B0005; Tue, 10 Feb 2026 21:28:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF2E6B0089; Tue, 10 Feb 2026 21:28:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BDE66B008A; Tue, 10 Feb 2026 21:28:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9286B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:28:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB69256081
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 02:28:58 +0000 (UTC)
X-FDA: 84430593156.27.2DCDF21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4986540004
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 02:28:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ouk8yobR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770776937; a=rsa-sha256;
	cv=none;
	b=gfaORy36FXZCOAtxmsw3GZ17FBheU0OfZQg/vxsnl7SggzPCL/ePLUaCL132Wk21PRReEZ
	0lLuafzXDA5oXXc7sz95HjoAz2xQ+NWlK3sx4ETTtbig/64cAgI6EYkEaxOMd1KjEuFwUu
	7yMfzAV5W2vHEdNw85kStcKpFfXmz9k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ouk8yobR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770776937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=REUc3ycm/2J94lvYlIOYdAP9RlvoUpdZy0+jUXeGGlI=;
	b=vIbMEXnoZAC5GmY5J34QJlVNOoHdXbw1KokRSmu1KulFlxl4oBx0eST3kxIb6boUYOyiBs
	UdNm2IYNXhVQI4g0tX404U7lwQ6IW2SvgPHlyKG613qtnaAKVH2L73yvfe2GlBiDv3EufP
	/Z8JykByhqq2YW7rgXa8iYp4L1eqveI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0115941566;
	Wed, 11 Feb 2026 02:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EC6C116C6;
	Wed, 11 Feb 2026 02:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770776935;
	bh=SsgcuXAQKqm2BXmGf/F2JxUmBpEFfmnsGoriYAnvvZk=;
	h=From:To:Cc:Subject:Date:From;
	b=Ouk8yobRovHBzfqw+4bDzZ0Rhr3etmVtdBDkrHsRLF3dcaQmh0QMsGlzpnxtroxNg
	 e+RA/El4ccS/i/Svtl1On7FTy74hlaLTI2dMd6fTQmFgIbIXeoG0GYp+ytr6n/8gPH
	 K+nuuBpV682+KC/XTqwmEqacnfCz9JuTJ7VNmDGO0EfOa3TjsyVsGcLO0f4sp1TF5e
	 F7Xe43mhrB5/eIktpgll+SHwiQbm0MXNjqNHfpHYJNm7lTJlUzGKmjkXBf9r28aqjz
	 J4n/lXa/mJISNngYCyn/f4MMkTm529F9OBWaYoHhcGzZbdqL1VXRGD5zXABqrytje/
	 LhInRiBUH7ldg==
From: SeongJae Park <sj@kernel.org>
To: linux-mm@kvack.org
Cc: SeongJae Park <sj@kernel.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Subject: [LSF/MM/BPF TOPIC] Data Access-aware Transparent Hugepages
Date: Tue, 10 Feb 2026 18:28:44 -0800
Message-ID: <20260211022845.68865-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4986540004
X-Stat-Signature: fwfh8tb9mupqsqafnjbut5mtdoyshxsk
X-HE-Tag: 1770776937-696302
X-HE-Meta: U2FsdGVkX1+l7v3YV2lIFXdqsJOVfzqCisYf03u1wFysiKQVkun/nhzh4KPI8s5d9UcULdvpR2tcBy1VTfs5U2y1S0ZKj/B2ZpqiqZJe4DtlD72MlOGqsP5Z8uKCTu4fda0xDI4El+j4i4ePBnPWdVJqIAnn8anApC+94CcxfOXsDfeFSUJN/HjvzMo62/ZhNFblYJc4p/9Zn67+i3tC1OiLsOGtG4ytcZ1p50PK2Tesax3SNatfTmJJEE6pOdgvzxo+HCv/X6mV4wkLwBTdQTW8UXWV/GWu1ZLyKUkkGXOrQth0jZqlm6UIor8EnoGYTjLzGQEKSS1SLZ84gM+5LwFpW7lSGZMDRO/115meCCzqPHYxy6BqCAN+GrbVuhpG78/MdaEezHNo/e029fg2nJAem0IyI3+I9PKqtV1+qpE7H6mTdPAsqK/RVpttEluB8kUB4BXwgVKpkJ7tRSvjC51BUGo/PaUraXiUqSF8mQwXNuK5nH/NKP7jfeY3k0JOc0XXILNlnYYMTPjCUS79qHfA4wxNT7uz9SBlZNnhNGDJNtiU7BZ8p2yohb897/PKJvEgEI10sj4e+EzLXNOaWQsQiFjARo67imCfg5I0rLC89yp8zT/vDYCWvAbtkvU+oxSop8BRzC4GBftmj42dZ4uhiB0cD8OUcDpJwjI9AynW4QhJbvdU6cCago/4LgUQxdiOUHGMyAUs9pZiRT4qM7FQZ2y3nL59vveVGZflDFeTqW7/0m5dgJAiX7Jz2VfbKxN8ivq55tBXOnhsulWLh5sQENoj9qucQfxlCDJW+Tdbvxbt/hIPWnQdIf/3YouLzduRNV3/WzuzXvSU3dIA0G2I/Ig41FRD4iuqtXKSck71hEcduZ3Qmn43n/TtXGQErtfC6f97AvKj0KDH1eXz94LBWTfwEXqNIvlzZ7tA5l/SnUgaBWU4Dekv8rkhf1p7/LV2GxrHyyu9CvLyUPD
 Z8B0/SCK
 ty7Ng7wINNFQUzYd/rindipcEG26BS+T6yzniJZD0aVBWA0321Bmz//QAgEWYSnwzOAvdBuxas2NCEWISub4NOwxnyUMgXuc/uWWv7lmTNrnLUAr80yTIU0IQ00t25GFFEleGvlH7zoPplkvwphEuUvxbf+AwnuTOVX5SFYJEGAPOzCKtDSjXOE1/UGvKCqaNyJSymsN9koao8yzlcogDVyKFyPrbwbu7uvXs//YSk8cLO3TCPo0KCJwuQX60BdwfTjBEk524/qFX/Lf0EbMDGqt1tFhmBZ5/Rf3kCPIU1RTzmCirUam883YjO4KeNoXFTOwPOOShOnfGCC4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


Transparent Huge Pages (THP) could be more efficient if those are used only for
frequently accessed data.  DAMON is one of the ways for fidning such hot data,
and hence there were interests in utilizing DAMON for access-aware THP.  A
simple experiment leveraging MADV_[NO]HUGEPAGE based on DAMON-identifed hot and
cold memory regions was conducted as a proof of the concept.  The experiment
demonstrated [1] an 80% reduction in memory overhead while retaining 46% of THP
performance gains.

Multiple discussions for further developing production level access-aware THP
solutions have followed.  Most of the discussions were made in private, though
Asier recently proposed yet another approach [2] on the mailing list.  As a
result, we collected interesting challenges and ideas for the production level
data access-aware THP.  Some of the ideas are not yet public, could be
controversial, and missing important things that more eyeballs can find.  I
want to discuss those in LSF/MM/BPF to get more ideas and make high level
community alignments for next steps.

[1] https://assets.amazon.science/b7/2b/ce53222247739b174f2b54498d1a/daos-data-access-aware-operating-system.pdf
[2] https://lore.kernel.org/20260202145650.1795854-1-gutierrez.asier@huawei-partners.com


Thanks,
SJ

