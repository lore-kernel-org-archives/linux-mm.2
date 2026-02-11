Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17011EA8125
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 10:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7916B0098; Wed, 11 Feb 2026 05:33:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06CA36B009B; Wed, 11 Feb 2026 05:33:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB386B009D; Wed, 11 Feb 2026 05:33:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7F906B0098
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:33:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B563FB7F98
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:33:33 +0000 (UTC)
X-FDA: 84431814306.28.5E0B4AF
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8908420007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:33:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770806012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=rUoVuIjL6bnNfBAwuQI5eiV+BixqIo1kLp0P2BdWDas=;
	b=aRT3JWqqZt9mA2ujuFZQomcdTt68qw+6fyO0lw/DEdK7aMjG3aNjRSVTlMRrZn6qbFXXZB
	9weI0yce8h/4DOEotx5/X00/vKETnWPA/sLLS6HZ+z0YRztCqjFGdohXEqu/Kk80RTk+Kq
	cjRZHojToEbzeAvA2luLBUFiXiG2NZw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770806012; a=rsa-sha256;
	cv=none;
	b=shGb1Hvwc95V8L8DqY1AxXrNfO2G6TXwKsu9Z2NcQa4bNyFULDtxk0Nk0arydRy4STJAAP
	8I45BvoVYfUhihemVGpI+dWX0tlVzQM9z9sPtQ72OQ9WpA++2CZq1yts8/c5Qt2ax0v6AS
	Y58kCUseMQXveVSqF05UQTynnsu1XSc=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with SMTP id AQAAfwCXnmL2WoxpgeYHBw--.310S2;
	Wed, 11 Feb 2026 18:33:26 +0800 (CST)
Received: from localhost.localdomain (unknown [218.76.62.144])
	by mail (Coremail) with SMTP id AQAAfwDXMO7yWoxptIgaAA--.31566S2;
	Wed, 11 Feb 2026 18:33:22 +0800 (CST)
From: Cui Chao <cuichao1753@phytium.com.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mike Rapoport <rppt@kernel.org>,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	dan.j.williams@intel.com,
	Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>,
	Gregory Price <gourry@gourry.net>,
	David Hildenbrand <david@kernel.org>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	qemu-devel@nongnu.org
Subject: [PATCH v3 0/1] Identify the accurate NUMA ID of CFMW
Date: Wed, 11 Feb 2026 18:33:19 +0800
Message-Id: <20260211103320.2064211-1-cuichao1753@phytium.com.cn>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwDXMO7yWoxptIgaAA--.31566S2
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQADAGmLkQQCTwADs7
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU8nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: rspam11
X-Stat-Signature: igaceweagrcxtfsi89yteypho9fi7p4g
X-Rspam-User: 
X-Rspamd-Queue-Id: 8908420007
X-HE-Tag: 1770806009-395562
X-HE-Meta: U2FsdGVkX19HxCasm0aU0UQgcnDy4DvTzoFcD05nxvm1+NQrugIDkdJUfPG7wiVaXmf45E32a+OVL8hWFSGqYUMaKnKHDMLSnjdfPixwLKU86pRksdSZdYPvlMpjiq0OHZ6usSghCL632TKUqdZGAOz3nwncmy6NBLrtdIk74Vi2u6ap4NcfCyBMY+mmtn92LH/jDX4XFXVX/skKooAXtfK9fNnrPkQIY04kK/+rn61sQ23Au6NiWyD5Zos7Pra1R/uw+d2JToQW5iVYiHGx0DplweKRCIMjhgOfFnyH6lQXxiTBehhhZm8ZgwuoYW4FLdGQdu17A/DwG25yucgJd7/T7czblO5r4+GttZW52uOq6vVkHMz+uFd1ToCVrlY3cyxBXV8aKiXocjDziC3gNXD4Xvtmk4hHzW7jciSefqg06Z1sX+gaqMwrZRUGqu5ZHz7OGAjbcdz5zzNY3qhdEU+d+ht1cJAl/CauIkZoNz8tU15u1Mxv1Eb40ujZxn9/bYrsgmBHg8QAyB20E3hhZ/0ZfpOKWXkVeh5X3hli/XPuIYJTUXafCUeFPAD53G2FMK/m+GR0/eQ1gpgsCAQTfgX24BdINLD+cWMoo3NvRrDeioQTaIVXcvI5gBrPYddhCQ1SifKz62NBkUVJUfrH84aRKvx0ppLSpbzneycw6KbAMi4tVAPAVkLMe+//6DH+eDh8f2t9bBkBEMjM+lP8m+faJEoGDzip9qXos+Uqli7EexjvLO67/oUaiDErj2x5r3d34X9VSk+AbjCXF7GUS+1AyTMHm+hz8o4fbrgOR1zGp/U9bpItbbNtdZ5q046N+kHVTwqiOl80c8ca9n85z1sBUhF4YmwqyN4jVaV8Mm4yA/do/4dGQ/SgADUTBnfd5rq9Mx6dpnx/fkq10c2l2ioTZSE9ll8Q1pNVO56vLj0HWqL3urdUxjDAea2+SU7vvdyQ3t5Fj+jkfGbcgmn
 FMCcePML
 GJ+gG6nDO6J+WpFM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v3:
- Clearly state that this issue was discovered in QEMU emulation.
  While it may theoretically occur on hardware, no such case has
  been observed so far.
- Describe the runtime effects in the changelog.
- Add the Fixes: tag information in the changelog.
- Update the comments to clarify the selection logic between
  numa_meminfo and numa_reserved_meminfo.
- Add Jonathan's Reviewed-by tag.

Cui Chao (1):
  mm: numa_memblks: Identify the accurate NUMA ID of CFMW

 mm/numa_memblks.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.33.0


