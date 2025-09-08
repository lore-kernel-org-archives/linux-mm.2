Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46F61CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A27608E000C; Mon,  8 Sep 2025 16:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8408E0001; Mon,  8 Sep 2025 16:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1278E000C; Mon,  8 Sep 2025 16:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 767F78E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:59:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09BBE84FC7
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:59:49 +0000 (UTC)
X-FDA: 83867299698.29.5748A36
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1AF9340002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:59:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Z+xd2Nic
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757365186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8W7OV22si8PaHmNjeiI92VUYfmd2gxuh+1FV7aVnSGk=;
	b=1z6UfkhNq9xE4CNLPGamfKsUxt3QwIOs4COKbc57xlehiIGM4h6PpSTJYEwgf1s115DaOx
	Hqs0P5kS+LaZxM9A7QPVamb1ILmPl3GUR2187r01c1U1pVJ9T7v0W5EN59bo7u6MRK5qv7
	Ggu8k1f+PY3SAUqIK0z2k7ZTBiwzjyc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Z+xd2Nic;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757365187; a=rsa-sha256;
	cv=none;
	b=TkVP4M8AG1ETZZ7vp2pLmGAwboiA3KnRF5f0cS26iDcrXiDe2Ou8f/MmNgrbDA3YC1OFGU
	3EFsc2FcWZmpab/Y7QxEmyATmeESPjk3oBkLZO/Pm6x0d2iOsjX7wTWRomlHzcfFKCvkBO
	A6DPfE3oavCMo7TcBQlm2X+8+NMyOnM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8W7OV22si8PaHmNjeiI92VUYfmd2gxuh+1FV7aVnSGk=; b=Z+xd2NicQ2DByD7bGMjprgGPMX
	SKT2BJDH/LasgqPAOPXPqwPpYDmgPDz0eSB7nN/nKHhP+QH+uH3zWsG3PK4s+RWMFPr2OTUSIRuEm
	zCqEzsWGaYPi5Rm+rKou+Jh5MkQ4Ho3NWZ6xY5e9iDI36U0UmdJy984A/oQXMN4WL9iMkNRNpJPIv
	xAicaKFMDQD9saIZpslJaMtrc6QlDwPyxZmnMzdYJ5+3CwenizlADAySpEff6iW0tId6T+Ow7pJcd
	ltrpwoNZU4Qoqs4i+XtHIkUIqseck3yVgCm6PkV0Kj7/qxFrBVgKHfFekOytv5KytQYDVNIZaRJBh
	VDkcu66g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvixU-0000000Cyxf-2WaL;
	Mon, 08 Sep 2025 20:59:29 +0000
Date: Mon, 8 Sep 2025 21:59:28 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Hildenbrand <david@redhat.com>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org,
	akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
	bp@alien8.de, brauner@kernel.org, bsegall@google.com,
	corbet@lwn.net, dave.hansen@linux.intel.com,
	dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com,
	jakub.wartak@mailbox.org, jannh@google.com, juri.lelli@redhat.com,
	khalid@kernel.org, liam.howlett@oracle.com,
	linyongting@bytedance.com, lorenzo.stoakes@oracle.com,
	luto@kernel.org, markhemm@googlemail.com, maz@kernel.org,
	mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
	mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de,
	osalvador@suse.de, pcc@google.com, peterz@infradead.org,
	pfalcato@suse.de, rostedt@goodmis.org, rppt@kernel.org,
	shakeel.butt@linux.dev, surenb@google.com, tglx@linutronix.de,
	vasily.averin@linux.dev, vbabka@suse.cz, vincent.guittot@linaro.org,
	viro@zeniv.linux.org.uk, vschneid@redhat.com, x86@kernel.org,
	xhao@linux.alibaba.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 00/22] Add support for shared PTEs across processes
Message-ID: <aL9DsGR8KimEQ44H@casper.infradead.org>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <5b7e71e8-4e31-4699-b656-c35dce678a80@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b7e71e8-4e31-4699-b656-c35dce678a80@redhat.com>
X-Stat-Signature: jwninj6winwgd3yjqxad48hyftf3sb4s
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AF9340002
X-Rspamd-Server: rspam04
X-HE-Tag: 1757365185-53786
X-HE-Meta: U2FsdGVkX18dtkuJOdnstrb2sq58WEDytjx5qup7H/xPPq0e2ZeyknoCvOTmXczK5COrKIfFeZT+uBqYfFtoMajH0hM4mRJZZtRXBHYgVeWUmSlgySwQ7nJgEjtbqjDIPJTltcUaNqnbFfCAOoUVGhNPoBzWq60sljAm4QqI4EZc9A4QiV3NbxBqZ5tEUPpBROOXu6n28NLW1DS/xHqK0s9tmjeibSsvW7MpqDcTR0BiEZS4VKbo99Gteh7/dzTIVFRVq+Z/uINxP7740SSkFVCX6sIfKSJgwCVF26TYJoVXKpUwk4KtoUdsov5f2tk5Mry0l08EHJZZQTPGWgnVU0SX7ZbpZW5QsimKj6DXZtZqmOj0BY1iTIzOazcPKepxRitLvEwqRqZ48Ql9DSwu/nmyV3pQG2xlUHZfZNRlpd0/m0m8qAKSr5N9M9iVu/3Hxj0K3ZEB+Gx1+JZEJ3XlYBPxeUhy/RcId5vnedctSDOA25/O2Ste3ldXd+qK5/YIdGKMyFVrXoXIzZ4DA1I2GsO8g80uR5kVkBbAW8qquubviFtTJ6NaNja7K2Bd65XztpU/Uv4nSwtDlkW1NKOtXuNjaqyJsNIoLNYPqRVTU0MtZKSSlacB6LDty1nrQOsIB2YMEEq/MYtFm9TORFRWZDF9+ee6Xnlqlw7kRyEgSgXDE2kU/V0HjrVVWm0PhdnzAjta6tTT67KtjmWaDY7I8V7/+v38sb/+ja+Ft/Fyj2RtfDohHiDIqfMnGKH2OWZBczZHz9qGHzC3hEJURPiqJu9jtwxbWuAOdvQgIQC4xDbFSF6aoosbKTRdG47iRhxy9Z6LSsodQMTsPcIOXMmX02w26oBXofE3fYWnbwMcwHp0VQJzGjpqEq7hek2PKipSe7DVfQhkG7sJIukrdzHj/7Nie58OE1lbRemKnD8cQxe/EJZakh6yo7zHTq/x0Gvqpw8j6xCUf8vd8otbH+B
 IwXfB/p4
 b2h9LvIe6DOhqrFzFm492rYTd8TqNMiDQRGz0Kqy8sTss4kXot5czfoKbvnKmgtbnVZWzUgL5MBRuRzDeJJk/2KBvgwY85WU6ZGN0NnRh35oyDtXFhs5YYJxIPR678xcOdMI2ugWxmpMu8FgFHgqInSSwd+ytaI3adrZimDvMLRgat7/G9uFsMHDwj3VxioGz8aImZ9YieoO6d2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 10:32:22PM +0200, David Hildenbrand wrote:
> In the context of this series, how do we handle VMA-modifying functions like
> mprotect/some madvise/mlock/mempolicy/...? Are they currently blocked when
> applied to a mshare VMA?

I haven't been following this series recently, so I'm not sure what
Anthony will say.  My expectation is that the shared VMA is somewhat
transparent to these operations; that is they are faulty if they span
the boundary of the mshare VMA, but otherwise they pass through and
affect the shared VMAs.

That does raise the interesting question of how mlockall() affects
an mshare VMA.  I'm tempted to say that it should affect the shared
VMA, but reasonable people might well disagree with me and have
excellent arguments.

> And how are we handling other page table walkers that don't modify VMAs like
> MADV_DONTNEED, smaps, migrate_pages, ... etc?

I'd expect those to walk into the shared region too.

