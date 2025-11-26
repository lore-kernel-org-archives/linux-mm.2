Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC5D3D1118E
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CE0A6B00AD; Wed, 26 Nov 2025 13:55:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5946B00AE; Wed, 26 Nov 2025 13:55:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2FB6B00AF; Wed, 26 Nov 2025 13:55:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1ECB6B00AD
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:55:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A3345A0F6
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:55:46 +0000 (UTC)
X-FDA: 84153662292.11.BDC7673
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0B1B1A0003
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:55:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=g3nS6R4b;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764183345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLgia25EvIAIBo0VY2I6S9Dk4/MSQiPdMJldJvpcdsU=;
	b=cxd3KdfND6eF+nEQABKokpdZ6cdQk2bxcW1zwiYSuzVyzqm5lRhEn5XzlYWOlIb4wMLaUm
	NnqLYeWBL0gA8Bitg/BlHA+ERilFFfM9RZsQlukUNLQKVR5xN1dfH2/Wx6LoWKGXNod22Q
	QQYMnflqYXL2MHE2fcIcJZpn+YC5oks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764183345; a=rsa-sha256;
	cv=none;
	b=n99YRLdit9Ez3RmeOOmP+iWmOsW/dbAVlNTbD0AiyAfVndPHrVTY61fSqNTdbe0B1DCj5l
	7F7dwKUmpuUU4Tq346EsWLyKALccS8Rs/dfViXu3addbtlrsboz6ad3sh//GhL9ls6iiHD
	9TjPjj5zl8p1Yqy/GFfQMP7FqOE9R7E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=g3nS6R4b;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MLgia25EvIAIBo0VY2I6S9Dk4/MSQiPdMJldJvpcdsU=; b=g3nS6R4bW6uQlx6Je24W9afEMH
	Em5LKt9oz497k9Gfvq/XJ6/fvEKedQW3YCWBUH4PKFDdicr4JXoufcWgeWK7ZSKU746ud4sumvmfV
	YFNnq6xLzJPiACvsBcuyfVcSUnV3OpxMuva5TL3RuNuU+TffZJW9CUynU/dVu/G8lWvJ3b7YIKkhz
	9yZ6mCKUXqeuIpWgtJErxKkaN0GEn3IPqwa/y96rIxsDaXZooIrwB2XiggY7muOwYj/KzbZGUgbxZ
	SF/CXLaEIOq6KfcuVZfyq7VCgkA0OMCSds/ICAlTsKJdpjSM1Wvsnw4PrjBCCA8I8x400e1Wrl1WS
	zsOaQ43Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vOKg5-000000007j8-2ErT;
	Wed, 26 Nov 2025 18:55:45 +0000
Date: Wed, 26 Nov 2025 18:55:45 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: jack@suse.com, brauner@kernel.org, hch@lst.de,
	akpm@linux-foundation.org, linux@armlinux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	wozizhi@huawei.com, yangerkun@huawei.com,
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com,
	xieyuanbin1@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <20251126185545.GC3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
X-Rspamd-Queue-Id: 0B1B1A0003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: uijninxca35tpm4hoga59o4py8zmo79p
X-HE-Tag: 1764183344-508812
X-HE-Meta: U2FsdGVkX191gig0Iw/9xf0qi8SBmXRKc3ZxgMva4PNgIbLZPFerzaYGNi3LskRMzYzB3zeJXq9at6U8JZxYg8WgOJfNd8WLACPIHqlJg5ICLt0WFb7mYIy61F4qpIYpGFxnYb8vrDGWkgALb3FHo2PyuFDpKrrrcleBMFbOChRST8nwcw5oN8jkfMAryl2fN3dQdxkZLVPZForfe888ezNEpRWDFG3OD03PhXxtDgoOxUDgG5v0s1uvMfXIUvtHU8qhjxGTLuU1af4KWSRSAaovzbW/PrZPlrZ0jy2eQuBMzGw/WYIkDZzksMgk3pM2HC7VJciikhhL1LLoP03OoEpY52SEIZRyccO/DTq2WjQ0Or/W5AQvhil7eZ2PA7tFj7InCkkNoWRnDSDqZYFFVeX1q2aeq/6SAwi5mFYL2c+dvmlV9UfZuufvG2ITNJK524BcvjAn7dI9uS1p8MRu66a7c4syzxY7YnmDAGn+JeY97hRgp1saBlXOtkVySgQCgLaIrUXwF6VdM4aegzwroCMQd0aVpV0OEcUuPFxznUnKNbYdB6k7jkB18dXsn2NAPaQ4hNqX77JVTReMAIIHdoq9Arcz1cFcWx8l8xe5gNq5tCAzuFzAONTUJGOpSuVRaYBjZzRLLYCatw3OGTSG2L01/463VAlBnVJvNc3RlTZV3tInLNOqiDXFfIgwuIr9rqqd6Djjhm2oLoq8jhcTx7kqyC3TIwSE5KykKM8VFm6RRF/0BPcw48bemdUElRB54cCJq0TmnCjPISo2ZVg8q4GCAMXr4ZUEd4WnqO86B9RgZdzvzGtNuyuVu0Ix9dKN4rQJ2878Qpahv7e5gxsweeCnVD+2A6/tVUKYeQMxcfkcjpNpXnNp4EjaItqKgLJBGGQWEieJ95VAgBHQMbdkccxUe2iyYsuIGVG8+o1jKUiE2sh3JpyRVeGfcO5Zu8GYHt04I/W7QGO9uYb2eDl
 CiIfmM30
 fsdsYE4GUXKo7nU9Yln2zuMNvI2DuEWAT+gwKeYR3d4x61XfMz0xg1l4lP2Crh7r+hKhfEP5bGidZhR3ZAv110v9xo2jYdtazfE9+MvyDqhqtct2K4bd0ZIvgtMfnO6VRJNKPCVhME316/lIO8TG6Iu95H1avfDw6ek/BV2P5+U5ks8MjhFOOAcaeb7PbNN/qHUJx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 05:05:05PM +0800, Zizhi Wo wrote:

> under an RCU read-side critical section. In linux-mainline, arm/arm64
> do_page_fault() still has this problem:
> 
> lock_mm_and_find_vma->get_mmap_lock_carefully->mmap_read_lock_killable.

	arm64 shouldn't hit do_page_fault() in the first place, and
do_translation_fault() there will see that address is beyond TASK_SIZE
and go straight to do_bad_area() -> __do_kernel_fault() -> fixup_exception(),
with no messing with mmap_lock.

	Can anybody confirm that problem exists on arm64 (ideally - with
reproducer)?

