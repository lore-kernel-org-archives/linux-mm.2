Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70DC4CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B46F8E00CD; Tue, 14 Oct 2025 04:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03DFE8E00AB; Tue, 14 Oct 2025 04:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2EA8E00CD; Tue, 14 Oct 2025 04:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93B888E00CC
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:35:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5674E473AE
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:35:48 +0000 (UTC)
X-FDA: 83996061576.09.0545F24
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A651180008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:35:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=a4Y5H+f5;
	spf=pass (imf06.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760430946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jHNbOSkAKxEmrSis/ca++e1CL7eRGk9nY48IkitfWL0=;
	b=k7su3nWT/2co/oyaFc6XHVQyg+3x6YBZHQxO0M7geLsIX/q/MPhdaGkVgg1Fu5Q9jc3uOX
	f8TDEHA61U3JCjhq2DU04sLkSHRgBXRmm+sV41w0Sc0J/3imX0RhUNIEuq435NNsiVmxI5
	MVHjFy+7wMPpfwA115CUKDMWIMUi/Xk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=a4Y5H+f5;
	spf=pass (imf06.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760430946; a=rsa-sha256;
	cv=none;
	b=7OMyxIs4rLhh8oygvSHr17M/fH9xP/RPlSABqK2n8KcIpop5BilZdNiAWsE0ieP9nSfFFH
	MK4X/FbizyLcyNend9W1pyVNyDFJ/UqLCJqbsu+ng9d46h5zrKKG1E76o9ZttsUlcUR2jX
	DhlmbQqW5nFt9a3KRosIIU27G7He+jw=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 59E8WfXa085643;
	Tue, 14 Oct 2025 16:32:41 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4cm6pz4wdzz2Nc5jJ;
	Tue, 14 Oct 2025 16:30:19 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 14 Oct 2025 16:32:38 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand
	<david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman
	<mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Sumit Semwal
	<sumit.semwal@linaro.org>,
        Benjamin Gaignard
	<benjamin.gaignard@collabora.com>,
        Brian Starkey <Brian.Starkey@arm.com>,
        John Stultz <jstultz@google.com>,
        "T . J . Mercier" <tjmercier@google.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCH 0/2] optimization of dma-buf system_heap allocation
Date: Tue, 14 Oct 2025 16:32:28 +0800
Message-ID: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 59E8WfXa085643
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1760430772;
	bh=jHNbOSkAKxEmrSis/ca++e1CL7eRGk9nY48IkitfWL0=;
	h=From:To:Subject:Date;
	b=a4Y5H+f5gs9OCSDBq5C514+UWWtOCiAX3I0FjR3BiI8uaOItTC9h6bTMGdI6XPKWK
	 2E8qo7NI4ZSakzlCNUAGhcF707/K58wB9x5Fiej2In1Ifa922vtKbABLHqsDPdBTlg
	 +0DIqOHIdVDGSfhGpP3dUfOeaZHVKbS9BtL35hz6J3bl9/x5v78poNS84MfTlQNFpN
	 Eg3/cRlrBHyUeqTgzkbNsfcRAsDhhVVnscxN0X1NjeaQeQsIbeYV9BS+bbIUf39WBa
	 MkPVD6C+zFUFIqHCavBPmuwvwEmKmMzuihbIrySnlHvoYNTSt2yuvRuPM0ysqYM2SP
	 rDY6UoMvEygsw==
X-Rspamd-Queue-Id: 8A651180008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: nyptdtg1wgqzw1ssq9oezx184paoa5qc
X-HE-Tag: 1760430944-535157
X-HE-Meta: U2FsdGVkX1/KyWWn7R2KZOaMrr66oBorH45WczQ4M0wuK33nXLaq0VI/5RdwSlbW7McP2x4cMvdtunrglh6d+IA3p05TXZxnuVv1tEQh3vqdz5IiJU9nfCM0Edb7phhu4Jb8jeltmb84UDdAHBDR/1N6OLFJ+m4ApHcApbDKepXx0tCHQ3SfEeazHvpGkiIz+/NEIH6okOFWzeSIbVP4fIgNoEecc+f+dBSk4sL9e8JbmfpR+bAcMFBgNr1cWadmQ0cKP0EFUeSjj40QJQSWClW+a/pubgvdasmLN6NA4jy7jzbUEdw0RRSd8qGbXkAx/RiN0Uljkgg4gb7l90LkXXvn/7WKuESJyU6jGcI74c2fcgbFNK2ODYICVz820h4aMFsXHTj+B88mxnDJsOULDJv/hq4H0iXYiTRtMc9llgOBtGKVQq7P02EKJn/AnRRq93PH1a+X7jRQ/3pZqRTnFkSV4qjlpRXYVIjbQEUnsZKZnZ4JObQeL/hc5Kk+kIhm/+xy4TFlG/bZNp5vrcwIv/5amGApSwLZ9duO8LjBa9Z92w8uudbF1JMclNLUDKUqprUhciw2HOG7hqN4c1TzxQbMH6aNUvk5EN7D3gQn90YyNeBvDMQKrLy/mhM3u1i6E/DaOx1sKmtYhNh1noyqyMawLfNTQoof4lvje3ML9hXsJXEME8KnRreO6po1TX7k3r+JzorxRjSx6M708fTAN684LqEzPNqqQGbVv6pc6rLDIXMkMqY5+Vjw/HaAaSL1Bq22Bl6kn6eYeGFZGdXKfnj5ZLHetipa8c0VfAkhtID8PM7ibDUkHX76cKkt3BkLpPaSlO+regijsG7/1L7gDzR7cTsJj2SHa9yciJhcbR+Ew4XKWk4QzKJoI7ySPBvMmSIO32O+QSkYrI6BhCpPosTWmn9PoaKG9RZUVMgB8DVnPbeQO1y/Dz4AIFSRxW39mVuFgCT3dBGN8lVkwdg
 EhtOpXbJ
 L7KBk+oUr2xxtDr9PSP+Xr64yUlmfnThWKRoNw87RevUGHq4/jOgYF0EwAucs078JfEzNReqzmTHwcjaeEwn6InTYntmZGR9a4UT1SupXlXTs8DJgtnnea/Qf474Ic9AopxnuoP+ZA4i5AjQ+ch3zrOYYr6ov+Q/Mj3R5Xdpl+cmYr6sbxDj9P8I/Zy1J6M6It8WsGohnR7xRfDoMWi4qSsV0N+omyP03z4l4w2emvC+VkhwfZOskEuwDvN+uygBe9MlsmZy3HQkTYqjK7RGxVzIySRVq4OYNzWmxuLLv0vojHdfGmG0yg0ok1G8aFrqd6mqiFWpySV2bU1Rt2zHc0xbX+AufSfEx2v+pbnYe4dRt+MD+o2IqbLquJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

This series of patches would like to introduce alloc_pages_bulk_list in
dma-buf which need to call back the API for page allocation.

Zhaoyang Huang (2):
  mm: call back alloc_pages_bulk_list since it is useful
  driver: dma-buf: use alloc_pages_bulk_list for order-0 allocation

 drivers/dma-buf/heaps/system_heap.c | 33 +++++++++++++++---------
 include/linux/gfp.h                 |  9 +++++--
 mm/mempolicy.c                      | 14 +++++------
 mm/page_alloc.c                     | 39 ++++++++++++++++++++---------
 4 files changed, 62 insertions(+), 33 deletions(-)

-- 
2.25.1


