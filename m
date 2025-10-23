Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8920ECCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 08:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6E1B8E0009; Thu, 23 Oct 2025 04:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E7D8E0002; Thu, 23 Oct 2025 04:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C308E0009; Thu, 23 Oct 2025 04:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C16CC8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:09:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EB931A0A6F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:09:33 +0000 (UTC)
X-FDA: 84028654626.19.B28EF23
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id E3EB71C0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:09:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Xlp3eQ6q;
	spf=none (imf21.hostedemail.com: domain of BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761206972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=X5Z35GBvuU1/F8eoNN2dfHt9OmH4uDnc9uf4te8p8NI=;
	b=Kyxo119V1sug3K0Z2jdtJs9eqoqgm1xdcQ8aVkVAEBDMghq5hfHiiLjMDPZeH39+OPiSEO
	xTdSNnaSDjIAaGrVzGD7Nx4rj/y5ZSEYe3tcId6NPZXYx8nUS8Gr62qwCDiUlsO9xzmZXB
	JA9rqq59uz68ZjaWTd/zuCt4kyLoq5s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761206972; a=rsa-sha256;
	cv=none;
	b=N8JYTFyG5PCuMuuyMT+SQJOnLxoCa+IC+sdbdmQrhvx17i8g/ewKgsv3vABrszHWa40ZfC
	pHvO9zQ7nQDbF17we8i/+kV3+brV1g86us11NFBeeWpWJJJF+TEY0GOOXvn5k3ycZvSQPT
	77XddlD5pgqZFM5iHgyLZm3YnhyQLQY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Xlp3eQ6q;
	spf=none (imf21.hostedemail.com: domain of BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=X5Z35GBvuU1/F8eoNN2dfHt9OmH4uDnc9uf4te8p8NI=; b=Xlp3eQ6qwkzZxpgVYyoufjPeA7
	aBIgLzxe5e6fMa+PR3PctfItwwQ6TERgjvk/jP1Wyg81StojqPOKhkad1XdpVlrsBqVX3G3Gpp93Y
	qjOwoySNY+GD3h/AapW59wwM0INX2TBJRlkpwlT8kSeXLqwXCyPyZ6VcYxy1oTDhkIp3SwqnSxZ1J
	rJ59Ownx5zfQQTkGgUj6aMliCht08IvvOeIvAEj80E0QfQDzAG334L61xXvYu4c+fhsQL3nGEFxbS
	1AScHiEyodbUyLGjMMqAq3m8Fiz0WFSLJe1NPMHOzJ1Yx3s9muW1rrjFleA9ux7RX/sfSVwgFseug
	5gAwVWcQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBqNx-00000005TlH-0pvY;
	Thu, 23 Oct 2025 08:09:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: make block layer auto-PI deadlock safe
Date: Thu, 23 Oct 2025 10:08:53 +0200
Message-ID: <20251023080919.9209-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Stat-Signature: rjpofsn478pg91p4z6n79gpkkhan5e1o
X-Rspam-User: 
X-Rspamd-Queue-Id: E3EB71C0007
X-HE-Tag: 1761206970-910396
X-HE-Meta: U2FsdGVkX1+0hESF3J8XjJy+5V3TgJvg0oyeO+QXyDrFqU49Vl0Qyy5BMryvrjaRu1cb6tdAOvVNbLOW7WX0M/SWbTyRYIaMSrRZxAIKZXaIpHG0EBKW8LIwb3zCoyytS5sBMeMtGue7OUzjJIqaooswxGk++l4ySlSiZDXLF4UxzeTZh3J2tbiaUFk+LsaqHdGCzGBlHE6zaiyetBdQjcdu+aHOt9rYfKQ7kDP0oAeRQoHBpwvOFRTqfrCreMHQgLF/QL/XWGGAF2K3r4ENkVH9n9SdhWK1hdY85hdxncYujAiumjcQJM2PonAbh4H32FdGdLzpsHAik9w992j7OYugn7o23ntbVOu6H64DzfihNwJL4aOHRaHGoY7Qh/IeGdpijhUgvIfVw/HtK7hZY1Bx9AjRgsqjfSi0yTC4Zt24iSFNCl32LGZuBt7wcQuB/lV6k/n8Sb316RlzU4Ix9VWr02zSzJcMIcqGx0XPH0Oz5u3feKialwSXgqj3S6B7b5ACdZjSiL3yhk/2xsg6V4urlACPj7y3Quo9zidxb2zw2YJTe5dTqdKZ+o18WU18w+SA1yOnGPBw1qcWHpAtQ00nAMF5wWKM/GBc2wInx4n0raRfpNpfAyeYZ3kqpwtYlyds/O4DdGfFByVU1C6qJW+H6W/etRHMtoko2l4uHAFs/Ci1AbH3mZRDApyN2tJbRgJBujjwLs9McEHp0y034WzcvlTMboBkqUqtOIFXGZC/MOWMfD/laRA/4gYHx+1C3sw4hhQCPm9qbmaYqjkahKmjmmF1w7awZLb5S78EgjGR6NvO9hHeFc9jVwPjcyatNBFELkxRt4FeBQM1v2cBHZdI1ovDRboTyoAhnQpiqEQqd+6H89kHXtNF0UYLkEWtVLmsaGJ9B2jljjp08rEJTh1D7cbhTtuBr7zpqla2lXWWGDyJfqw2HK6UE+CBk3g+nTexkGbAFojKy1hmJWe
 4fITMjJ0
 MOB8vSxlJiya4lz8vEB7bF9Ahz4uQcwo7HbwWafVYNtVyVvzon9vFAm2db/LDPOF+1nCfr04aMHsX0Yfvh00a7Yw/+JEuGHkTKN+7fgDV0XZhftiRMBIAh3+k2xNWh4YtzVpR5zVgdk9VafLEShWY+lerK8sPfkeiPci31iQa2CkLKyzeXzu7DZRyb3JdBSMyXkqIbVlh5ADaRjzKQ1RobcPVm4xQenP9pnCLp8/mxO7I5r28JIPIn729e8M+gZhmylhxr0xQA7ZgxDH/z93itdRzj7C1ep18tV3SK9MQbukVcNSjyIgks/CW0j+4Rqm+R0S38ZydgpwzUnqGXIkbVUGmY//0xLnjrNFBW6b19ei28GiWLplUoZKTv+t/4LLb+3KYJEdK++Pxtok+Tqw9lE6/3aXtWh4SzUg2fu4GvyufG3C89mdsKQhB3qQsqlQAOma2+hTrAta3xOI6NCR58eGYnFzusQHe+li+XNQEoTD7sn9PReOqoARvt6/jm2zZjFkoTRGyHJ7GExlofhbGDdXkLufjmNmhDNousMl2y12AsZ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

currently the automatic block layer PI generation allocates the integrity
buffer using kmalloc, and thus could deadlock, or fail I/O request due
to memory pressure.

Fix this by adding a mempool, and capping the maximum I/O size on PI
capable devices to not exceed the allocation size of the mempool.

This is against the block-6.18 branch as it has a contextual dependency
on the PI fix merged there yesterday.

Diffstat:
 block/bio-integrity-auto.c    |   26 ++---------------------
 block/bio-integrity.c         |   47 ++++++++++++++++++++++++++++++++++++++++++
 block/bio.c                   |   13 +----------
 block/blk-settings.c          |   11 +++++++++
 include/linux/bio-integrity.h |    6 +++++
 include/linux/blk-integrity.h |    5 ++++
 include/linux/slab.h          |   10 ++++++++
 7 files changed, 84 insertions(+), 34 deletions(-)

