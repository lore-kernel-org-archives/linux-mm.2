Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AE20CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6768E0011; Tue, 21 Oct 2025 03:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968D98E0002; Tue, 21 Oct 2025 03:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D3D8E0011; Tue, 21 Oct 2025 03:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 73FF48E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:16:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4562E1403AC
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:16:31 +0000 (UTC)
X-FDA: 84021263382.14.24354F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7910220006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:16:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=DB6GdZnb;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761030989; a=rsa-sha256;
	cv=none;
	b=oI9nKWlEIKx+kmGeElZJ3TLC5MrT3WDR/l3PNHY2CtIlTJEUuJAHnxQ+24dU3wjBhgBfDl
	/M7XYG0f6YQI9WJx0b5ltFrgfHjVYpGcGR3SYrArEkuwOUo+BBXArxBj/m7hqybJduj0/T
	2X6HdndEN9kjGyEc1/oyW4q6C5+Vhkk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=DB6GdZnb;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761030989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IuZy3bORYmWM3ATciEuz7ss8Rod/eltFRSKz+TLyRDk=;
	b=MP5tn7Udyc7yothw6WolQb4SoVUcJPktMIADtOx2W5AlNf59jgTzy1mZ+0yrk2rFpP/cMp
	TZBqeA9TPF4GL9v/nI48B5/hODSXIOJWB+7/9uij7fY9rHG7yZMRzA5u9AeEdmcROsLzBP
	/xtjfZnSgWzlv7yY/6U0a7+j9Jm2YPU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A5C745275;
	Tue, 21 Oct 2025 07:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0037C4CEF1;
	Tue, 21 Oct 2025 07:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761030987;
	bh=IuZy3bORYmWM3ATciEuz7ss8Rod/eltFRSKz+TLyRDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DB6GdZnbFbPZH7ONQh9UuBnxV4yyVPct2UBrbOx+acy6LJD3IJJ4TqeBWOFuTnxob
	 yQcTMlx/xjhair43mI2kcAlGLlKR8ps3Y7a+miuwU084wFYaZ7cl83CGA5idAHpn4z
	 C7ARslXbVSJo2wbFcP/tFMYJ6I8A0Sh0OKg8AlhA=
Date: Tue, 21 Oct 2025 09:16:18 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Mahmoud Adam <mngyadam@amazon.de>
Cc: stable@vger.kernel.org, nagy@khwaternagy.com,
	Jens Axboe <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hannes Reinecke <hare@suse.de>, Damien Le Moal <dlemoal@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.1 0/8] Backporting CVE-2025-38073 fix patch
Message-ID: <2025102128-agent-handheld-30a6@gregkh>
References: <20251021070353.96705-2-mngyadam@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021070353.96705-2-mngyadam@amazon.de>
X-Stat-Signature: w5hx5c7g9czt7hpf3zxim8x3gbpegcex
X-Rspamd-Queue-Id: 7910220006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761030989-345353
X-HE-Meta: U2FsdGVkX1/AXKvWkPLAtC6w8xahF4V/QuDuuMzlxXIoMnhupRjF4Di8igBcXSxSanc21pMffbhhuRuJC99XAyQJIlMLFLewKSDrzjYcmomBT35HWm77r3sWzppBN3a/4FiUyWcmDJFLR+XCyPh/Wh5A6rqnXbrnv+yet5ZYGzcX9MA1NfeSGxDZg4kEruumYVCqorftZDtazW12NhXjKSjcJlBaAE0iTH6eojqVMW8HEX4uMx3M8WogJnF4dGWsnomhu6TUXVhKeUG2ERlMrwHkaWFf/f1WcnOGNJ7I9FKXRa17E2pkN20+DNg63bmbZ5YcYcjYZ+txkMcoo5dWPy1xwOC+ekSxVdefaUoFZUTcoyQMfNxMOyXbL2ZtUbrbQ86tzS2/M6w1sAWBR4bNU69gpyS/OAhLCU3hUo7UhQz3MvrqtqLi+8PmbgsGeg3w62lnVwD6Cs/cS5w+faS2S2SNkXqzVIbXof3m5RF7EmdgrxrCGRfxSIPCwwnKq2p7/Mhyun0LqwuU1LNBvD6FOtWQGj8rErjrJrDYdrNg/8YmXjg2WWgQ3MNhpVsSMLp4lJC1HNRO0W/5/s+gGn5yo2Y1QbBiBFHVMeyY3YNzihi/q3W/d5hB+xxrdelvonFjku7BIzzBYcls4kxzbCCBr+koAvjPbBd7KeUHZ+WSU68M5mpDWGhHeHp8aM+kCHc0ttwN86wbLEEYdN42IwhW8McL2wVJOAYjl+ymYWGopJcVtGp9JCLusnZqIUAFadTpy7uTx8vctxN3wAoqAAgyxlT/k2yVzSwXQnuvKNrC0Pva4m9ZASM3x1Sse3tHIzxOuVISZYRQo6O7xaEJG1xaDHneudL5KSsJukniVHqvgRjQq4iD8LcW6wNh5vzIDv7g2SFbGMi5HuC2AT6RPbk5QLR6Jace4iVMstk+rVcVpgyXALkl/ffI6R/I1nqE+XPvKYTLd863cXqSvj7cOqV
 BWLxJllb
 8ty6W5hgC5ZOIrcmVDVe2RTo9dgJHMumPsV1IPnf22Ie70QvVcl0XTsDUO2xyndULbvnHvlwChSLum6zwCICDpxeErkFrqWKrhjlEQv5W9RZAS10OUaEuD86Gl6UXAAACf8UkuTst1n0uF9oHlowCtIGBNC99gqH1mbP3VawUMhDBZWTeH4Ybs+cWHE3pWaYqRD0KQ9pubqh+nG66/4WwwIykmEf2XfpipUDP4k/Qxm/iaVV64Q9t/ImQbHZOtWATl2/pU97pzd30/ZYbBKuWSWn3lHJxjpyltst3xMbNjIewNEMcTHCLhBfnRgoryYq1NmwbnHsCDhp7NBwa5/tCNhwl4buTAHHy18WJnTS2Fr/f/sa0F74MQMDORlpvYeecJS6Fsv2/WG5Le4w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 09:03:35AM +0200, Mahmoud Adam wrote:
> This series aims to fix the CVE-2025-38073 for 6.1 LTS.

That's not going to work until there is a fix in the 6.6.y tree first.
You all know this quite well :(

Please work on that tree first, and then move to older ones.

thanks,

greg k-h

