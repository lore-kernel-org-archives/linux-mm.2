Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1539D606A884
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365F06B05B5; Wed, 11 Nov 2026 09:56:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33E9C6B05B6; Wed, 11 Nov 2026 09:56:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254A26B05B7; Wed, 11 Nov 2026 09:56:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0608B6B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:56:37 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 941891C35A8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:56:37 +0000 (UTC)
X-FDA: 85423139634.16.7BAFF94
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf02.hostedemail.com (Postfix) with ESMTP id BB5CE80004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:56:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794408996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=sv8pZtwyfF33WMhoAzESK+gykFcChmKraVPjPufizF4fot69k9qJRt3vU3VHU/SWpw2waL
	ta7jF2XpcpfpgtqnxMEx4NEp6BO1D3FLqna2PyaK08+t1Pkbjn5yDMTZoS0gvSOQ9EgjZv
	vLNr8qjA/Deyk6fQ7pS0j1yJ9mGr1O0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794408996;
	b=8N/qM3hOxhZbTRaSLgb/1XFTcWJl5PJiAjBrhs3VwVQwGPepH8QgVWfVKKcVqJgTy3t5Wg
	OjlnTHgDwFj/i3Ryt2es/xOxyS/uO2CsbmDv+WMIPoXeBIqcqn7O2d//jeZXEWTPVJbHin
	Qm8CH0+gbQ4QSdPUpHHSEI/tZMeDjaw=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3FC4B68D05; Wed, 11 Nov 2026 15:56:31 +0100 (CET)
Date: Wed, 11 Nov 2026 15:56:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 02/41] nvmet: check that the file backend supports
 ->{read,write}_iter
Message-ID: <20261111145630.GB9996@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-2-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-2-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: andunzcag1gdee81ew8tj4gfk8atdwdn
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BB5CE80004
X-HE-Tag: 1794408995-912075
X-HE-Meta: U2FsdGVkX1/5FXd4F4qssW+rT1cJPI41eMysM2LPnRkCudeHouPI3XEMcuTaDxuRX1HCJpCl5Mm9XA5RcYXGnSDf82cs/VubXKZZTl4ImXRx4xq+xC4WLIiHJ6nER7Kwy4AYRav+iSJxAAf5nT81hkjTXNzHkexCJQFvStwilZp9pm6OFs8PaT9eoIfz2xKswKmdk9ljJmzAsbAUbMTbbPB0uLHNFjMMMgW6DZ9PuokArZXawHKVtJdrNc6ZiTe9IGlx4MP8cQsVIW3EY6CkF9L0EW5FnJEoNq791VI2ApDmkN8bk5zrRRYe93QqaQ+r6X0qkIA2J4LY7Wkecb/Q9ChQ8cqSzy5OCcbS/AtXMfVP3/L+/FDUXyDjgSsCkZeB5ZPab5CM9OMo4oUGadSQ8NQ2IHvd107AdjiP6Ux6/qCdXiWLbv9SlFnjMwcjUiIKmGZqnS5B+Y0LkLTw7BxqHhjUggFcPls2ff+V84E43hapDkrxXRDHvTe6siCv3R8mv/5tzFrr6gH9VbiYD+iM8WPkO8QBK89pqlt+KGHBRzuinMwt/FGTsHEAO1hE66XqeN98CCBBxgQgQhejXoZfFPXDhhORQpf1eZogbYpn3TIHfXjtUF29THBZhJg68cxla1kfO835QcNhzd0+xFnnRMOZneY9M1eaNiZl27boWSzrx5traxm+EI9PpJfYmuYLr83lk82M3SvXIZvb4G1PONc73PPuzCq+Yg+Fto6ptlGlUOCZWUirTwyy+9WlfHRwddjCbzQsKvxcvuBK/5LGVPp/0O1G96AEHmYS3U0vvftEuyZUTqGCx8Tc/oPqjzVRq0Zx8iU0x/2CkMaihviF3XLbNX14ixr30+hiLd3PkKs0+qlO/RmNlexozQJRbXfOfc2nYReBYuA98gv6SoUdDZH8/dcNNN1co+KRCIekO1A4E9QnoNC9V3aiNrjDxnkpxBbclSEEt8bleJMGf8v
 AcA9HHoj
 AxJ+mvNXLPquos5vnpWIWbGqoWFZ4PwPHBsmtGedqQjGZbqp2tIF0B6g52R89QvqxS6TT+DtA11XFX35/mRWNYR08hZiXw+WHVD6yupvUrnyG6wm3BaNoQ2AmoMf3934nGgL1ZQuItj1TZ+fd063+tccrbQOPmWQ6MZzQkt0D39FN4yRsRkKuTGV739LrupBYUARnZSv00PIRaExCy8LqN8ug8Wb/rxJS1xKJjeNLNtDIuXaejGsNtbeIsWoD4FzfGJlbZAYs8VfVd4Q2FhzDH1wD0aS1oNNu4ZackBY+l6ic+Fvi4cWOidfdvVidv9tcwJPTJ1y38tI8mnCe/h6m/UMyC6H+DAecjO+YwDixyL+VErVugribXKqulA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


