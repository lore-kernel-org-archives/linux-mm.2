Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8AD3CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 17:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E338E00DA; Fri, 24 Oct 2025 13:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F688E00C9; Fri, 24 Oct 2025 13:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064B28E00DA; Fri, 24 Oct 2025 13:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E51B78E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:07:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E5A65DC6A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:07:06 +0000 (UTC)
X-FDA: 84033638052.20.44ED707
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id 83EF14000F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:07:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eoGk9c5m;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=ptesarik@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761325624; a=rsa-sha256;
	cv=none;
	b=Tg/LvPdAHFaoJ4vGGyULKNQDKrBiTGMgudGrcvEjWxJkPs1Qx6tuJkYiEFAAWVNGvNKHPT
	BdbDOzgyYGZX+lj6DNYAZPxoRNMlDDp6v1H32ON1J8s5KY4Ms1NTwjon2jzZjkw3GO/jQI
	7XLnBaMpP4yvTxkAwIyln3nidoXxh/U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eoGk9c5m;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=ptesarik@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761325624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=X7UV3etF9wjAI6A47jUoni1xrIP8wdMkkw9GdIsZjpk=;
	b=XeT3FbOwbcG94NBDC6L9vsywj8WqVgUb22T/cKkZztuf/KRs4afyu7zXYu9LQr3k19cJuV
	qD9i1FapNTZTfC3gRtbk2e7o8M4fbRxb/izzkrCGP75RSdD01U8QmlIDKSKKh2bb9tovvz
	Q6ozvYn9YQ3LczG1xDrS86QX9iA1Fjg=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47103531eeeso877175e9.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761325623; x=1761930423; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X7UV3etF9wjAI6A47jUoni1xrIP8wdMkkw9GdIsZjpk=;
        b=eoGk9c5mbROB1H4YEtw1+d8AlTYyudHVm0c2b9RYRiV5jP68AWJ5uZUSZx14fV2nV+
         X+2As0hHEmw/3Srjc1TNpOhHESQYFtucoG+wTXq+hOzhXonFSWl3kD+uOd+cOGnAmf2y
         p9N8IWTxQELwBPmq2TKje+ux8N1rPR8YwDbtxaH6ytgV78tBQ2LmdD3Eiwltn2wmDpos
         padVs8IIzc/9SS5AvQdoeOTLFfRsBqaIKlfnFyHzymRDi3xAYqVnBBiCaSZwctOXiJ4Q
         U+cSTNTxKmCNiZjWeiPc4JevCPj7AiG60VZhiQB1ureJiRhebGplqouwldCCMZbCa+Zz
         /6zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761325623; x=1761930423;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X7UV3etF9wjAI6A47jUoni1xrIP8wdMkkw9GdIsZjpk=;
        b=unTkodoOgZvSzQ+VMMF3A6fs72FJ/7tkrSoNF0zkqWhlX+dYPgoF5O8fZdMKEEPNus
         XHq47Jy0v8q361YOLGbBsXZjuad/g+Y7iDhPyYKxddsH5ocbhu3nTXBVVhGUqXU/rYEW
         MpAjYvWptesnGD2HPgLqnp8Rcel6Mn86Vpb58N7Q4felScP3Alaa//3XALZ06a12YyrV
         8vD1kGdq5fDj0aFymPCEnAsW2AahMjiuHd9IDGdH6YYmURLvX0c7RnpHlzdr3wC+ZwTj
         EKiB/J3Wuuq6kbQOxn26+3ys+jvRasNfqtbKjlfM2j1qGRklQp5c2afK0zN0sPnn7Vs/
         OmpQ==
X-Gm-Message-State: AOJu0YzOTqxJnI12lEVLsTuP+k0zqpAwGMEzYyjlKz4Xnlx7oAuCexT2
	cJlhNU9EjY0jBFP7gznZRu6OvZ6udlx2M6kCYIqLDCejVJcJdSCybBccdJPfRnuKRts=
X-Gm-Gg: ASbGnct7cD0z10IcNS6X3+vCC866ojKFitblCYZrEQekkG6JT5sGrGzu1rboZW0IPqt
	nuz8ukqGeq0lIOJ67XiRECe6hTQ95B2gRaRU0NzUUoVZPqHOVuAOPXLHj18ZP2wDl9ym8G/Yzxm
	leVIjkxiK2jihT5+uCorkvmD0j7J+Ufrbt5QtOhkNwNKa500m7UsPN8iwOYYzw8HaiV3NCTBLc5
	GvE6z1ho6Ot406/m7lox2nm/i6bh9Uz7c+vYMZhzcv59xFNOHZZnCXi5qDQN2c+Z6lf1qeBVqJS
	PGZLm+LeJM8/fgPmJAoVO02TLCgHp0eYZWOLgWkHQz86YlEKvT0DpRuykvgL1O6sQtS9C4Kj4Ow
	GyxKLjgTCNk5n8lTOH20tGnZB7tGPQ9+y2lsj6pv7RbXVvpPxFj+Djan6Rie9Uf+vuAoY3Ru5ad
	qbeM7RLay/CLxX/PInNP0FLRxsex9X+/SA+5xkdLfuLioASHLGCbiyAjaTC6wA04F7Tg8Koqosl
	9u9lg==
X-Google-Smtp-Source: AGHT+IHrQ5SsYuT3IiFX5jb0al/oludtwJa9eupe/AMuS0qb8s/e0+Ey2fu+7MGTVSShR/edgJxrjA==
X-Received: by 2002:a05:600c:350d:b0:46e:6778:c631 with SMTP id 5b1f17b1804b1-47494229fbbmr60195425e9.0.1761325622824;
        Fri, 24 Oct 2025 10:07:02 -0700 (PDT)
Received: from localhost (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-429898adc81sm10193839f8f.26.2025.10.24.10.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 10:07:02 -0700 (PDT)
From: Petr Tesarik <ptesarik@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH 0/3] slab: switch away from the legacy param parser
Date: Fri, 24 Oct 2025 19:06:51 +0200
Message-ID: <cover.1761324765.git.ptesarik@suse.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83EF14000F
X-Stat-Signature: a4o58d91g3kybb1f89c7wjgyo1oj8x96
X-HE-Tag: 1761325624-593022
X-HE-Meta: U2FsdGVkX18IIy3+95YhDNg95z/K8X9gaJELG8QsayjhEJ5BEJpfSjpIyfZVwf5B4/XaekbjPIB7J2ufjE1oqvGsbkfV0rIX1sDdr86qebrT+OU9L7NryvqFT/7fQb1c2Na8rFx2Nf6gknrYrJtfpeYFZ4snsHAifplwlOv8WNws4pGUso9FcA3RlrFIc5asqQdj1EJSDYeXq7j1kkE6eZiPr5rAE7EQg5d0zKa+37fwPCVP2KlAzYiryKrT1PB4YOGzlhRJvv4OfHwz1T8GoQyoDCScKCf775tlCY/cqK1SnQXEslWMi/nG72z6OXuk/N/HySm0NFXM1YesWopPfhEp1kQtMfeEisiHaRYD1Zov0yCvUl/7MAmHeBd76VY4XBrjVfmP1K4vbGTLarA7Qm2WmtSY9Yxajtp6FWm84QQatWyLeJ6dW49tn3kRD1lVzLttsMz6Lj2TVLcgGaXL3+OIHNud3/6LLQkf0E/3kYps58o/Rj27SiIGwdAkJMQmdQkGrdw9o2Z/1ByVVebG1JZzB8o7BwUAgp4wmUHdnMONa/oHnIe3X2SW+mhrCTXBfNob55plegQmabOSE12bCTIeo0mwWH15fNoxjCRfQAvz1vNLgHBSvbDyJGn/tpwXX3KmhkP6a/s/tkwokbeq/Y71BFb/8TonCBEqvzaTf1WsVldb0GKMGyCFzpIbG/kSGt8/WOVv2i1IOOJpXTJVVcOWhV+O1943VOYkDyjJ752D/gDbnhZLN6hG1VctwFTJ09T68baGjSfU6x5UPWl0Z2GtJzPjUeaFLCmAN61qg1ndnbKEDRvZiAhAxpdCfmiIQxPkwyZZWvaF8f1pmABFeT148k6sJbZ56CfMa0DXN8sLh5nihcz904BPmXkFISBz9qAH3lclDZkjunPEAVE6TqU6clBnzI44F7aLqF1+BVe71uj/cu3H1J9CjJ9NvkJAJXnrBb9BdVCCPZk7uJz
 pZ3xYnuX
 q0LDnvq3XDrvlcvMm98q+LqSVNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The handling of legacy __setup() parameters has some confusing quirks.
Instead of fixing them, convert the code to struct kerenel_param, which
is a saner API.

Note that parameters defined with core_param() and __core_param_cb() are
parsed early in start_kernel(). Do not confuse them with core_param_cb(),
which are processed at a later stage.

Petr Tesarik (3):
  slab: constify slab debug strings
  slab: convert setup_slub_debug() to use __core_param_cb()
  slab: use core_param for remaining command line parameters

 mm/slub.c | 87 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 51 insertions(+), 36 deletions(-)

-- 
2.51.0


