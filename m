Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D39C606EE99
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kcCk3E9D
Received: by kanga.kvack.org (Postfix)
	id A12F26B05BD; Tue,  3 Nov 2026 11:40:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EA096B05BE; Tue,  3 Nov 2026 11:40:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927596B05BF; Tue,  3 Nov 2026 11:40:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 706096B05BD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:40:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1871AA04D3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:40:50 +0000 (UTC)
X-FDA: 85394371860.19.6FAA1DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 795DFC0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:40:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kcCk3E9D;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793724048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3/pwRZodtv5H9vRDvB09UF4TkDVIqcbW+/AB21sxSLI=;
	b=cgCZkjERhPbuc+VdhdlVN+1JiuFiVVKWXFiTwXkHJT0E4CgJ0ID3uhDkmPXfcd5PzTbOcG
	oY2xapFpU5USMJIwlqDKWPoUOETexRHVDJyICvWeSxzkePmhdRi1U3p/bb8+zv3r1pP6Mw
	kiK7rO62t1HzA2G1x4p8rPNJL0N3D6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793724048;
	b=FykYGLolWliR4im5+Zzg4egDrUKh3j1RdGlV/ZqhwK3hs/BuXt8MWyY3v+SWoK4K6Qqwto
	h218TZNKnXNcKwDwZeJa9hK1flYXlDQFz0eD1DH+Dw94kQaKdWLxuIlivNIinOUP9iqnlI
	lYT+jH3FnTYeNmI7AEJxpPgAKmN4vys=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kcCk3E9D;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFCE34400B;
	Tue,  3 Nov 2026 16:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE5F1F00919;
	Tue,  3 Nov 2026 16:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793724047;
	bh=3/pwRZodtv5H9vRDvB09UF4TkDVIqcbW+/AB21sxSLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kcCk3E9DDzqb581VxJ5reyHZgYV3mxqJrzazBrWKk/8awLxY14WY1qQjIrfNtyW9+
	 +fgInAFIOA8pbj4OnlZMuT+n3NlUcuq2yEYeXQNrWe8ebUqvrivCfRVtWDr/3yvXbz
	 /BWBSYNXk+FF83ZDTD4OKx7IKTkClzRWexwwPPed/RG1Xv+LYlKNqShYqAnmueVcHC
	 gTpUG+UUL6OOUv1NGnTCJgrYlEvrsdp0yuuXL06dDPAQlPxzRqYs0ah3iWC0gI9/Bt
	 TyO0WuPIBe1MXUewf/anvSyELn8SkDADqP4mdxifTwWZEneQ2Nc7h/8SBuhSMroZc5
	 ZN0fxv3D5A0Jw==
Date: Tue, 3 Nov 2026 17:40:36 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-serial@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, 
	linux-input@vger.kernel.org, linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-modules@vger.kernel.org, Chuck Lever <cel@kernel.org>, tytso@mit.edu, 
	dmitry.torokhov@gmail.com, Petr Pavlu <petr.pavlu@suse.com>, 
	Anna Schumaker <anna@kernel.org>, yukuai@fygo.io, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH RFC 32/38] selftests/proc: check a sysctl listing while
 entries come and go
Message-ID: <20261103-unwichtig-puten-tauglich-389f0d95257d@brauner>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-32-59422ed3e465@kernel.org>
 <sashiko-outbox-195504@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-195504@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: y6dwy8r5gxy1zoyu88sfgnjrc5dpyyfg
X-Rspamd-Queue-Id: 795DFC0005
X-Rspam-User: 
X-HE-Tag: 1793724048-633016
X-HE-Meta: U2FsdGVkX1/agm3ZRUYZd+1uRuxh2/HgAfJac5fRR9WYn1AQ6DaTcKiQDxgQlKcAmkEIFrDha+YbdGQZXpBTq3uCEbleO1hdqrEmec5/+sdTdgaaN4M/8T/vQJ6sE4anM1uP0odBUqZgPTJb96bgvSZL9FOTUJKAKbtOvW8CLcsXyXjWnht1F7kqDOJE71ZPzsHbpNVDMoHoPmyIJTOigufYodqTfCkpmv7o63bcNHw9Th3bWh6LdErlS92pGzS/XuRNURV3k/ddvJ1i2JNZK7GpQQ/hR8vnyEtqahE9L5wp4daJ9k5FWOGqkknodKiFjm7SpksI6yCIDl1fgXRglbnekNsUGjY5yqtLkyXOD9PqqdPaKIeN7KsTY4kyR+qcdC8+blYigFAiW3jsf1I6qi8b+4Cye8a9dpHFaUSYRMwJBBsMSC+Ko1pQENKnD/D3OwlZjqPVFlCESJ6vgBTpb0m1uphYpx/TAGiO6WMsTpSu+06XBGWQFv+c9fS3naL5FpwpTBdl4I922JVbfgLcLV6xjklleuLJPnKLCE3aKEdjWb/sgwB2gBrtySoenj8bM/vvUvjC4rtNLazf89s3s4aj4kGNfCx/pKd1lU+rMtWvCcYPl1VwVsqwvdfkNbr6BV8Oaltc6tG9Svw9etgAra2pXsahlyTJpqmtWKLC/HfDjcOKs0vrf9X+0EfNKSge4AGbLDT7n0V4GUNSfR86nPcbpjJuSLtawS5nN7O6Jx7GmCzuLjAvUujYz15DtfAT3RMm/8O0V+NOUCGwQ9alcRshe7nIlPzH8xRCI19aTJJrkePdOv7dxKck9TNDv2XFKQl1/66qb5o5GCC7wSIZXSiiftxG+pwZG5/D2XTxC+uUCWbIRoLR4txgozqAC3IxnEQ6VzHW7YqtwKHfLtHcwdhVE1/z7qa1MllsZHFtspkWeyQIc/cbpklJ4vUYRGBLd0Sk4tb2twqRC8PoQ6b
 xfMZjUz4
 eo0ABUo+zS46qpAt+ozCe2ThV2EmB0OeMyxDFyiaU9qypFBB7YdrYGgfdcyNo8cfpINk8iwfqLdsx5KsFPs68T+/qqh6aYF4mlRfIi/rrVgFbT584eK8g/rvEprIRkLp0/wY0Ji3CpddGLkBEpV0yfmFnSgzdN9hfTOTkGscyyy03rtaanZMLb6/4ESgjOhnlRFEc9cDSA8CcCIFDwh/L8eAxZHy+0j/dQxR/HVch6yMdhidC93bbU3isHOJqlzhQOo6omrBwHZFT0/po5mYfaUiEn2CWoZ70MidHRkyaaibPhzCFEPyUq013kN8yVVTxH70x+qjIiXtkzDwcUfgPLBDGMAzE9FaBazVhlzPzWVxVF4bqOp5MJnx2JR0VKFsI3gooDTNG4TtHH5hJQAWR4pOD8aDHk4n/vVbjqC0XWHPr+0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 02:48:31PM +0000, sashiko-bot@kernel.org wrote:
> - [Low] selftests/proc: proc-sysctl-readdir-churn duplicates proc-readdir-churn

My appetite for churn due to "low" issues in tests is low.

