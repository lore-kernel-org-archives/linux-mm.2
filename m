Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6689D6074A14
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB286B05B4; Tue,  3 Nov 2026 05:51:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2376B05B5; Tue,  3 Nov 2026 05:51:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837206B05B6; Tue,  3 Nov 2026 05:51:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5C66B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:51:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F17A0A7C8A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:51:39 +0000 (UTC)
X-FDA: 85393491918.20.22DAC4F
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf29.hostedemail.com (Postfix) with ESMTP id 430C7120002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:51:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793703098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tKZDWcIar/lAYH+ykSXDvWJWvnWut4DuuspliFjEz8c=;
	b=QybroAJ0jHk/ZgY0CcRXRx0atmrubfOiqufxaJ92nEWqgJP5Im37p4d2fM5h0Z2Qy37f2J
	60cdRzhfREE+rSpzf4B2+dHOBPtfGN08mcHgTxMNV1qEwxNKMiB7G9yM4IW9zKv+QhQpvU
	31rJ3zN154nWt48Ak6e5rRGPsTSyvgY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793703098;
	b=XKIv5oVjfDHgVleGo6Ro5cSPlFKVupT/pqQ65icuKQ3Nx2lss8ze7ZTc4Je3Y3vtcUF/vo
	rbHlGkSAwjuODVfNWkHXOsVh/CJ10wnlYOAyM3CaORb/UBXa1/7v00HZ4JAgpsKFER7mOq
	O8Xogk3e0u4wvPuWkgJL56PZJqA9xiM=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 46CA068BEB; Tue,  3 Nov 2026 11:51:34 +0100 (CET)
Date: Tue, 3 Nov 2026 11:51:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonathan Flynn <jonathan.flynn@hammerspace.com>
Subject: Re: [PATCH v9 6/6] NFSD: drop a shared boundary page only once
 both WRITEs have written it
Message-ID: <20261103105134.GC7296@lst.de>
References: <20261024221152.6965-1-snitzer@kernel.org> <20261024221152.6965-7-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261024221152.6965-7-snitzer@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: mficojk6s93aypiarap6msfz6ryt6sjd
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 430C7120002
X-HE-Tag: 1793703098-576124
X-HE-Meta: U2FsdGVkX1+zk7Bd8CYOSPcP+FD4jSukZXdnvu2IpF04Z2mG8fJ3V/pB4nEnYzH0Oxp5S7MMdxk0etr5omJrCOACIXRLh+IDRbMXKQbZvwHUfXb2p2xkg/zMES2tlHoP6j2UmUxcUenBbHguDxeZCXXDZlW7tAFETbNF2xHW9bWdyNR546PSDDMxRsNLdn0dUuLivC20wL7FzxennBmpgjw6FWjgWIujFm+Lc+0w0/PXJcUCzx58v8MXQY5uX4CJkPAy11Dpqc5st849v1dYkmtTgJc/W2FyTumeP+0PNEjPWsEj1UdLpycRC6d55vZt+Tqrd44a1es1Ht5G978k5iDC/EglL7UPAiLm68O6+q4B+UNzj/0qwhP/231VLE+Cz3QpQfrmsuH4EGHvQ8ugu0i2xhtKAxTUI8HRZ1E4LGJjP3hAfcAecvlILjJuh7Jl3pEIADtagnvVmLaW253N/UXkQSFXCbqvR8AM/QNuunJg+u6yEZgJgu8A+vxvnsEaJzV85gLavAyAB+YFM2ibnMd0aFjtMc4zP06X6X+iJlvZCyp3N7RVSVAZASFsnbvaD7KbSN8M0wkTa3Ousr6YdSQ/jjpbkhnSX51xjWejEQXCMMgibbpq2vsIxVpoY8dgEDXJOSjssKzIZyIicPFRu6td9QeuZs/iik+gzud7etGnPeT//gsIVBbWzZ1+h61bBGKuGtkCDcFe64t8jE6u5JO3QdtCmJfl3vcWd8DVm3KPtMokG1F8iWHoC1XaJTyX18WAn9QV5tfv2k7VlPQrDecCsO5p0vttfg/LXZmNkKtUzzJmJjGgk4KFnRcJtzMvVuFGIVF79naySljq8UUKBkgg7FsL17dG39raDad13FreP7tssDKdLCm3GzD02gG7m+i43KMAQFMWTzEXm5dtKCXshI3kyEHzGQRYe9gCLZ3fsjZS4LMbE5GPA2+rBvosl75h6fRbxtJaWomihbV
 kp/l3yaG
 Rni9jTzakO56wZmJ/jk1Gy81pJnKak8QHZ/NXx6q+rrT0+dVR1OWn0IqO2PBmajXnYnH6FDINsLBxKAlYUIKNbWO8jMIVxEXzDz86KgXN75PQDK9M0U2eTdlMWMqC5AHW6tJAgR6+1peVy1kyB0TdprOiQ4QAelNZtl29QugYdeb4EoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

FYI, this doesn't apply to mainline.  Together with the complete
garbage commit logs this doesn't really leave much to review
unfortunately.


