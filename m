Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70E1EC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 23:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523736B0088; Mon, 14 Sep 2026 19:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5FF6B008C; Mon, 14 Sep 2026 19:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5C56B0092; Mon, 14 Sep 2026 19:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2144E6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:43:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6CE871202A8
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:43:34 +0000 (UTC)
X-FDA: 85213997148.01.36EA955
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CB6A8100002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:43:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ist19+WF;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789429412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1xTm6AVOIfnX7bAFeKqrNGc9d6PmTF1RnXhgKSLcSJc=;
	b=tn+JxMPTsCDRmn4wf1Ecd5rJOELXmhMK9bv6arO9fm0/nfQzlx2xR2aPkWAQkFQip7vSr7
	7MuCRdZLNKSjzjJ6chddvlZ0Q9scZXJncRYZa2mL/IY3c2fU5oFeUWJoDZg+xXomBx8k27
	5y/FPT55Vgx2LY83v9t4gaT4GC3BEFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789429412;
	b=xnzFmZEIf6m+tSyN9wLkoYvTi7ENmQTruOUUShcQLKYfNTbjMM7l3le5ZNcyU0a4py+nca
	wNQJuNYhFaQJEsbrbfAVa6bLvPM0+zevBNi47PyjQAda3Oo457DWW3N5at/VwNeQq8WodY
	7JQ7qWNR8ShZVQZVL8Y+Ey8fkbPKShY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ist19+WF;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C3FC54085E;
	Mon, 14 Sep 2026 23:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5232F1F000FF;
	Mon, 14 Sep 2026 23:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789429411;
	bh=1xTm6AVOIfnX7bAFeKqrNGc9d6PmTF1RnXhgKSLcSJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ist19+WFhIzMzn5+dTfVRB2JDnLwCfciuducJZc6CTmfoKdL6plAT9Tj4Li6Uzz2g
	 cSIfZQEXVhuRqpx9J8fTvGoXNNWeDfRARjrps5X874sF2xG4karu0InDdM/SI/t/X0
	 CqobaAdoNIsyK1hnDB2USmE5veeSMXImjGPXuSBl/DHN8ahIBgjqrJ7KdaC9RPi70w
	 fj0DsTUCBHuaxl9mtvLWARQF9GSm6id0I2uzGCHFeO+CYiq4Mo9HIITqiTBNJJFljm
	 Uws+Oo9FnpBB+NCBav7CbNe/LCRqrFlIxw6qnALQ3dp/FpuuSWYBcjac4jY7ZQYdz5
	 P5DZQR74lci2g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/8] mm/damon: move damos filter range arguments validation to core
Date: Mon, 14 Sep 2026 16:43:23 -0700
Message-ID: <20260914234324.100142-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914142327.92510-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CB6A8100002
X-Stat-Signature: 1d3s8eh39cmaudx5t1geut8d89waotpu
X-Rspam-User: 
X-HE-Tag: 1789429412-272516
X-HE-Meta: U2FsdGVkX1+WNiYAc5gEJlUqjrYI8pKEIHAJELtX24ZBbTP+2s/8HpotetoPb4r9hwiwfjdUndO3jX/MB6VjuzXClQItNpOTgurGVaC6cV/lhXf38+UFFt5AkrXRzd6NHcLexlRZj6f2t4yBeNT4vb70gzIAlDNZc8gnz41p0i+Fjxe+fLJyKeDNj1CkW6Ip07tf9OVAdl6Y6BJo3IOMQ1gLZMibHDHUEtIewZyQzGc4vpLcu1sIvDVLEY3+2SypTHpeFtVzJZu6JlcCoVy09ofBbFi4tOD27sOazkSavihYaU1Aw33g+tkicgNta3SmL/nMCdMcnIgfsNYrQjL5LoiXcmVwZcx+/eduT+/9hum464jAJAuIGeOFER+g6VwiBknlkSJBSG900NIlZnC8Z3pq4WmwJCYiFWCKbFvBrckn2AwqXTOfbLPQt2VzNBvsGWiOKUm1Fim1eyDuh3s1dvx0bGDVrhla8pxePJ4neaFxVsXoGIaZMxd10UOAQ2IhNPAUhvhqrsVjqQDa+DRfaoYrwES2o4HGV42diSiV2lz+Trs9k2Ie9wSesHnFDrSIrmT4FEuzz7m9hpT3SfIsTgJeJ4stbK8/pXWp57mZWsqVSg+860hfeobXO9BVu1spbDDE5RK358cGclYQC9jRDFvUjnhvtp/7rocN8DwXmmPjqsuLVTjeQg7+LCs4UiBu0cDBvN2vrAbi8qALXeBfNyrZNa8qPitS+pfRnddhD4wTOHhRZxHBW0iNFIAL1nSlWOK9KZyfq9bb0tZl3yYgjfvXxCyb1G4m5VCJaJ3JOcBrq3TCB1vbRx2BT96NiylaPwgMEKYBfvOtIdhwQiN1kvX7sIJRX5jL0cLUAHZ+iWDJlmzv65JWn8G8U0ebVQbe6oW7bwWCNOWZetIaROEI2Wspk6VrdvjiQA2yZ4XKQYxQMVSIvELGnirHcsPIkmqPfq53/0Epx/gy9AqKB/5
 eutIAR7L
 OmZZd8qlsViE5v62JuioqIst63lN4SscL5xwNqRZKh0WMVT55T5V5DJKzOBs/nysr4we3ccpk+AAPTS6JG/j1AReNyloJJZbNnBBNT5B+wub+EirfxXEP5yp6ztWRjuY9wUwRNJ0wL0L/IbSw4Nu9Cgo5SocMz3qUZX76YLDxr0ZfonEwavBE8aj8kwNffNjisZgyQCl3ZZHkHrWtcORd1Pyd6mn7xdNvvRL49bfHGZThaHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 07:23:17 -0700 SJ Park <sj@kernel.org> wrote:

> DAMOS filter range arguments are being validated in the DAMON sysfs
> interface.  Some of those have minor time-of-check to time-of-use
> (TOCTOU) bugs.  In future, other callers might have duplicated
> validations with similar bugs.
> 
> Fix the bugs and further refactor the code to move the validation to the
> core layer.  Also add kunit test cases for the validations.

Sashiko found no blocker for this series.  Sashiko send its findings to damon@
mailing list [1], and I reply those if anything needs to be clarified.  Please
refer to those for details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

