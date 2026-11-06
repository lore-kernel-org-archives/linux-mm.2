Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF173606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A7E6B05B8; Fri,  6 Nov 2026 05:44:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0437E6B05B9; Fri,  6 Nov 2026 05:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3B46B05BA; Fri,  6 Nov 2026 05:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6B9D6B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:44:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 595EE80CEF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:44:10 +0000 (UTC)
X-FDA: 85404359460.06.5C4C3D3
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8A3B610000C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:44:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793961848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SyHLvzb6celL0jDL0tyCZxUmWdmbDgVpxG3dwtVayYo=;
	b=45KIpbccLcB/xzwMoZjjqoVvskgHM79BlB/Ki9srkf9FUwcpPCVJPcNeNgSRJ2NKWNYJHO
	Inq4hyc+V6wofeBB5vxSsma8HorXKiHVlM94eGlWs4jolA5jJcE84WRzNHeDXdd2VjZeOh
	xl0No3xvM+WhcuT8I29b7gGNxDlJh9w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793961848;
	b=FIu+ZoljH2vUT5ct1DCmhzIhKOMIh2TdHno5axNtzl0ROiDWv1Kw6o/MSzU/iU8aIocWhg
	FN+83V/NJWOdb7UWHAPipBpGzb5keEOx7LSX7yPMUmA8S0LlpMXA+oN2nS1W4aXW764r3A
	qKjS7lUP4sH2uc+KmRtpqqQs+lOQgGo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1CCC268BEB; Fri,  6 Nov 2026 11:44:04 +0100 (CET)
Date: Fri, 6 Nov 2026 11:44:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mengmeng Zhao <mengmeng.zhao@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, asml.silence@gmail.com,
	hch@lst.de, Anuj Gupta <anuj1072538@gmail.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, Li Wang <liwang@kylinos.cn>
Subject: Re: [RFC 5/6] iomap: refuse dmabuf iterators on contents-encrypted
 inodes
Message-ID: <20261106104403.GC5668@lst.de>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev> <20261105065847.196540-6-mengmeng.zhao@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105065847.196540-6-mengmeng.zhao@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8A3B610000C
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: 8addwamwm3ux878kin5b3joenfzww9yq
X-Rspam-User: 
X-HE-Tag: 1793961848-722879
X-HE-Meta: U2FsdGVkX18LSy/qJ005V5RiYV23tdUGtLpUp1q51I4cJ14MqTdIAX8JO/doZoeTvHgeiUzjkYiuT+Y8x0nSN8e7MX4/nsqhYlxDntE1uzuYDJOiCfQu6kADk5hJkchAOxC7GV2lHCWDgsuD3+YrWZ4UqFja99GArdWipLhKCW7On/sXD05AeqFdFw++zheecPCtLzIvKzwojie2QFvaTLzm6tAGyzfHdYC1ExAWjXeOwL7y3PJuiGa5BLQIMSLUk4VwD8xyAHlw3HlNvaMLLr2EcYWMemVj3curiAC1QfHyroluiUcRqcR9+vA2yacTrHB5+bmAsODaTfNynxWgBWx1DC5zF+M4LLg8JDe4lax3WBR7hsFq1ullU8t6AHrU6FlawpW3aBOYQamiwp5QnuTca/suzliU1naZe+rFgkBx1CnMdk6k0AniuJahbMwwPgFoHfdx6Pkj27ku1Dzi7vx68y5P1LE7ecyQcPnlSaMYYQwpwjTxDsRfjwuFtd+6Q8xF8CNEKdVPqc3zxdDoMRVScV8iDNvdLl8cHjRLIpTR2mWcdXW0oRFhwoiWdWfWsxY0kGOoQHXgwnIlffmCW99vLJQuRnAkAEvA8Mu5NL2Sx+JgNwZJtZ/QIvRrYW1oGghJF3deLMQJYt5FqaC/2RlJjn7V2MJZUjcj1I6+UmwHAYPYo8IPfAELs4EaJoKNVuPaMWwmMyeqkQs45OYC3vTn5zd8W8LduLQDvQN/52eukgxoKWEFLiduwS4xOwquW7HiP1QeeKWggEu5f2kK4Ia5GP6FuwXlx9EGJfOcQtrTDW9MWiXeuPWDJb3k8npGSEkLwIhooSf60P8hrJQrzU3IuLqKsnfbGggeqW+tHNA/rpX/Tx6QUDqkuNb8YgIk7oRNE80PDcjAfO+ynUBjccfIFnoIwzZAGBncdKoEsvIdi5P8XgnurMEtO3NYAObS8w4dccL+nbmEC8378Jq
 cU0P8Ge9
 S7rPUTcQlvkjgmo6P8FtL5KvUOIamPEhesH2sfsGJu2ZXxlf+OU7ojb7tz9Erf0SHy7TVHFhCUaEcrsyxhjo9+JeeCBwyBxIP7q1mUddwKk2Xye0ZPCTFGWp3ss4qK53TOhOdstxPpj2DD0DB2W6qpUxUDBjk362ZWLIdHlxfPMHHy9k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I think contents-encrypted should be content-encrypted.

But we really need to find a way to make these checks more
systematic instead of sprinkling them everywhere.  E.g. have a flag
in file->f_mode to allow it, which then only leaves the direct I/O
to buffered I/O fallback as a special case.


