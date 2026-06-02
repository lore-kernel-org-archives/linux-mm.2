Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 490F8C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 05:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BBF06B043E; Tue,  2 Jun 2026 01:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46BEF6B043F; Tue,  2 Jun 2026 01:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381CA6B0440; Tue,  2 Jun 2026 01:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 224C86B043E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:47:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5D8C1C0E2D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:47:50 +0000 (UTC)
X-FDA: 84833891100.19.B078635
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf02.hostedemail.com (Postfix) with ESMTP id EBB6680008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:47:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780379269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7TPRHESZlxlZg22GkzDpPTyoqpIK3xi9ZZUMNwm4+bk=;
	b=7+b8ZAXlJzzD20uK9WlH5YF0g+SlGIyXbXtyiPiS+vOQ2HhoQ7ub8ByEDROpWLAxmcCqfA
	pP4ZMzOYPX4XIYWDSC5GvwWkZIC8WcuLMMRhpGCc7ygmE5QCEC3NSmo0NrjEfwF8Q86PsX
	A/aqct/JLPT5WEHSLId4X7jEXk5iWL4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780379269;
	b=zJFE26J8w0MGcCHjKcqFaIp8saz4qGEEiD19lGuRp/imvmAK+Qog1r39vJTHQvqnRR9RCU
	jCzT6VTiE2+SeD2xNv0oXdyFyAwSbE3bEtVcFG6+zzIv1QFeMNG05HzqPJfjQJkspj1bG0
	8H5m9GcGBlqXY5H/4uRyELTd//61ASw=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5ACDD68B05; Tue,  2 Jun 2026 07:47:43 +0200 (CEST)
Date: Tue, 2 Jun 2026 07:47:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, jack@suse.cz,
	Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
	p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	pankaj.raghav@linux.dev, Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap
 & xfs
Message-ID: <20260602054743.GA32657@lst.de>
References: <cover.1775658795.git.ojaswin@linux.ibm.com> <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org> <agQPtTx2EXHr10Nn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com> <ah24DlQobLjjDTGt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah24DlQobLjjDTGt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBB6680008
X-Stat-Signature: nw4otuurqe7u4kaawaumhrpzpqd1mdu8
X-Rspam-User: 
X-HE-Tag: 1780379268-252666
X-HE-Meta: U2FsdGVkX18hD+avi+jkj7EVlqnc4CEmr0ZCUA5pUhhTxxDuz6SH9EfzZEhhy8VaIwyWW3rVs1M95SIxZzBTCweeG9Vnh06ca8KjTpfJT+ZhswX/fP3i6icjKCmvoIUNhR1cspTyY+1VqiLcVLzW1KGSyR2JXzfvfwlDEUmDfdvhPP96HxrFBPsKcPYrOds9jCUSIQ47fVioQqqG+nz5oqqntURqTWoYrGZo+73B+MYuAqDZTbE3WW4+tOvfF9bjpNxYTrglal1pvyidMYBIAjdIeJh+TT+EQ5sAAMHPbn41tApEL660j5hKCSPgO+Y53typLRAJ2nMkaHXHrr7/n4DuGRfqpASzATOqmyKe7hxFEpRgSO4bllb2227qxs6UlDRG3MkdHWyiEvVOdOyH6SOufuv/RByKBZpGA/Ka4QvN0pBMcHzj7AjsvzdEBv+n/N9XoM+Wff5JA3fxj6Dy5q4zvN3sKvEspnwd1c5s+SMzzID9DcTXbV3T2L+DN/N/ZZgVNE9119zbBIV9Sk8ZQfaFlpxATz7u0ox99PSLCuccoAgHSPOUyGaYwxuCmbnpi4koShz/xZ4eXysc7CPe1avIZXuDJqvAZSN5Z7+URs6xh5ITsVNeJlbY3l1kocGkX/zYaVPXZL2xNNvNPpCdjgs51vbqwcFvwvbr3rbtj2wfN13Xs3ohMaZCR8txrrKMZaHA89+/dMDjeOb97CWJUOIYK6ITcB9NKlxQzEQjbX1fm3dgHJhXqkZz1aZLkKFmREvFeQVoQexriw+OaJ7PoNyzXQdIG6e9JlgNyiCvMfkmIaVpjSNc8+tWF3zRuzKUcwJ+2HuYYwla5ZT6TJkFHrtt+6+jS4MOqEMO3zT/IHKO5pnvWk9YfmxZRz9E7oPs2c3HKMTZbT1NIv0hY3T/X8HNL9yp0ykd9DHlteb/vU5b0wwYIM7A3eTeKTcAST0fM0pPoYo1G54r8k7xYh4
 E03eaeOG
 rXB/DUV5UHie5P0Jf6RThc6ZLq4Xr2dlyd9afiCAbTSXSHynOEtIdLWoOiHFM5QpseFnD4tHn15qv9JYuKxxq7xQVG8P0Mbm2ORsFw0Z8Y7eDhXqBK1MljgEHJtgzqf9FsVEiT6tKVkVPg1tM7mjjtfUFaoSQcvI4fvVXVG3ipIn0KdsPaX12+cxBFC250zoczFTi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 10:19:18PM +0530, Ojaswin Mujoo wrote:
> 
> So this week I spent some time looking into the failure of g/457. 
> I was able to replicate it in my setup and after analysing it, this is
> actually an issue in my xfstests patch. The issue is that to verify
> RWF_WRITETHROUGH support I do a 4kb write on the fd during the test prep
> phase. However "out-of-band" write makes the actual contents of the file
> different from what fsx expected (It reads it in before the problematic
> write), causing the test failure. 

Why does this get out of sync?  One of the arguments for RWF_WRITETHROUGH
vs direct I/O was that it avoids the content getting out of sync.


