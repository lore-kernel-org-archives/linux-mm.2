Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E4F0CCFA1E
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 00:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDFEF8E0011; Tue, 11 Nov 2025 19:24:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB75C8E0002; Tue, 11 Nov 2025 19:24:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF3BE8E0011; Tue, 11 Nov 2025 19:24:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D55C8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:24:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44D59B7A9B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:24:07 +0000 (UTC)
X-FDA: 84100057734.30.4657D94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9C793120004
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:24:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aCl3JADm;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762907045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7itnCPVXYlj6WLG6JHrA2fYQv/gtb6oKie/sggbhSE=;
	b=Yp/DRwn9hPTFmDHkgN05x1pJu0ARM4+ehbYkoK8773Vx0G0xxCdB9AvlPRGFP9adFMZjJK
	BcZe9oQu6OwJ6WTx6RFIS3I34H1DfAuRbp7UjtG3W6CBxLeOwPyRtWSd8OLIa+1x2APjUn
	vBA122F5OZQUnQkEaHXON084Bah5i98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762907045; a=rsa-sha256;
	cv=none;
	b=SDMk8d42HPcqdxHuj1EeoGWB+k/1OQYQZbE8rhFF9w8kEMgidIHL+EojkcV041Vm1EjhkN
	CRbZREbhdBn9DeRiWnZ75ooRc7gtI2UbfC0SdPdUrjSEmVo8rCCCWzYVqfTt4tVg6nWW1W
	E2XdzKWyd7X2XxvPBGhI3lOonK7ocd0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aCl3JADm;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0964D60202;
	Wed, 12 Nov 2025 00:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55E0C16AAE;
	Wed, 12 Nov 2025 00:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762907044;
	bh=SHwmfGeuGTjCUqCzSp5HwAAZr/itWc/JkKrfpclEo40=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aCl3JADmSiSYrQdxI6LUzS6jyRDkraXKUYntUlJPwUFYa2P+RhU8DMwHIHx+t45yP
	 +yDYuI/RUCe5K1vYGZfphEVAMJd+hTGzRYC61rQOdjWrosqxViCOddNINFluErlfEj
	 8VlvR09zzuLOqrClaxzL69YE/LcNqQC2QlS1sSDM=
Date: Tue, 11 Nov 2025 16:24:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org, David Hildenbrand
 <david@redhat.com>, Zi Yan <ziy@nvidia.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Oscar
 Salvador <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich
 <dakr@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>, Mika
 =?ISO-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>, Francois Dugast
 <francois.dugast@intel.com>
Subject: Re: [v7 00/16] mm: support device-private THP
Message-Id: <20251111162403.709f37d86b67254765c7846b@linux-foundation.org>
In-Reply-To: <7a0f2704-80b5-4cbd-8f3b-ac03692eefd3@nvidia.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
	<20251008201740.d9507f4807a73058d4da23a8@linux-foundation.org>
	<a5992f11-5841-4bbf-b190-b5df41b68b0c@nvidia.com>
	<aOePfeoDuRW+prFq@lstrano-desk.jf.intel.com>
	<20251111154326.bc48466a6962fbbffd8ebdd0@linux-foundation.org>
	<7a0f2704-80b5-4cbd-8f3b-ac03692eefd3@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9C793120004
X-Stat-Signature: 6caj5pf1o9h9466yrw5kni3qii6m3nko
X-Rspam-User: 
X-HE-Tag: 1762907045-953657
X-HE-Meta: U2FsdGVkX1/sX46uODhhx+Vob91sWHTbXdc7x0wUAYoAwFXpdsp1VEqFAKBf2zCiRZ1yp/3xADQkHs2Dn1TeWgRZdZXMd0CkG03HcpqJZTUfMBX6+GHKpVHgTK1ylrQRZXgiX3VHn2G6RILhNY7RaK/ntfDmhwfld0SLIboBawhUtkBnDWzaoOR0fJO2Dnka7Bf2+QjhuD5wsXKfEvjRBLgwdqRT5drEkKKEbidKMb+A8Ct9qHjU0BBF0WxbSseYEtzdDchBVE92DNhhhO1HgOlAIWBx0qCiKx5TVkTQaFltNcLs0Q36z6xFEFpv4DpNNU0ecvNf8LRYWi50q51O4eb4LUfBoLl2HXk6PvKsVSjHkaqiCkKEfrI9cnAy/+VQPrZKZb5+8Xzykw6VaESObHEC+AwftswEbi8nei2g63hNhc+oNVJaJ0o7Yzx2+eta+0Y/hZE64fmTduXA23HRcdQrlBFEHJZDYYX2ThCyjT6gVARufJnapeFi9v9HPm0EcS69CD0KtXXntwWwuGHS7h/KsaTOSwroSXbcR6uzmq9LUx0UpQmYzzY3kR1omhCY5iaCEPS1BCTQjtGn9BLixQ1WkofKCyHMcnGYABQA1YCSCFo+4QW+ly7gHFkYRf/DO+iQ2gWfyiNA/TZfNPHoEtbhx0YlsaZ0WwnZDh+5yYW8z3b09ha4Qz9qOOrLmKA22vUM06ZgAitmfZ9bwnatAtYSllt6d2FlomZeVcqLXuM+2a32vxUoBPr+STxlf2Z4l5e2XHdE96jT1dsXPrnLXEWkZYUhHRdWGLQTeZpm2RxWPVMMIpjxi47VUCcjG6UouuU1hv5Bk9ejOMQ8rqksrxqTRRi2NKIctJMS0vB9TBz9Dv7y7KBGZUW2WC8Z5cHMw33evvwUmTQsz9eBA+/gKC0PjR3v2CCmEwk0mB4uX1knwhj8VgJL0tif8WIhlFAfAmbKow0l8+S8J+X3Lxi
 vFkFTOl8
 XdtNuylwpSNWcfB/74EZru+rWt0EuG52SeBv+qpeiX+0ghvfNRKNBsNSlGIwu/R9moekGbHvV2pB310axxZPDFF1TBqDSxmZeLQjjC6y8tB2g2Gk5hj2JeDQtkkEHvL1EpQiUdKK81XHw6hv1zwGPEPCFTe2ChHmGrMN7lbeDPDrEfuX/eA3xQWZIrXcqYBe/kWxLl7yvrFVu0ulGLtgfXvnpgaax8WaugsmWZP0LD5aNxNO3WR7DMIVzAUrikdsn2H9jDf+/cErDGsRsPidid67aSB0T9mHvzKRBflxNTIXWqQkwfyZ+yRLb5cF2k46MbQyzDQLkaDIpVyhMNPTv934nDBI4PrOl/EhfT+HLV4Cnl+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Nov 2025 10:52:43 +1100 Balbir Singh <balbirs@nvidia.com> wrote:

> > https://lkml.kernel.org/r/62073ca1-5bb6-49e8-b8d4-447c5e0e582e@
> > 
> 
> I can't seem to open this

https://lore.kernel.org/all/62073ca1-5bb6-49e8-b8d4-447c5e0e582e@nvidia.com/T/#u

> > plus a general re-read of the
> > mm-migrate_device-add-thp-splitting-during-migration.patch review
> > discussion.
> > 
> That's the patch I have
> 

What I meant was - please re-read the review against that patch (it was
fairly long) and double-check that everything was addressed.


