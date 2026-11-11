Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A67E606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=cmZW0raJ
Received: by kanga.kvack.org (Postfix)
	id 5405D6B05E1; Wed, 11 Nov 2026 04:47:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517FE6B05E4; Wed, 11 Nov 2026 04:47:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D516B05E5; Wed, 11 Nov 2026 04:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2566C6B05E1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:47:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6248C026C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:47:08 +0000 (UTC)
X-FDA: 85422359736.22.BB30E2F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9882A0009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:47:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cmZW0raJ;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794390427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4FJ8o8UQUtyD0eGI0sUCpicqPvdI4Vdc4LMM0bmn0w=;
	b=kZ2k98wmU5ZXA3HbY+zsIhZyIEKU312wn7B5CYeHm9Ml5vplxD9dAY9uly1daTmG6hWQdM
	GM1IM+p5asC5vvNVvFsvMZmRRgMpkWJLKamIgps4mFOZU91apyfFI3IM/Wf+b9aPL9BJb2
	JsWbqCEM2khqkZn/ORmK7IT8+H03A9A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cmZW0raJ;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf15.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794390427;
	b=uO9N6UgXuZXTWxjSpRXW4bT1HarA7xXgAlWA3o5rNyRwNSzzNC2GiW5CFoNkckagbUkbnc
	hK3lUvYas304e3mY1tr8zWBsxejM8kYk+OJPj2y9Lxb9q6Dh8sAB09A7nZpd6yn4nRLtHQ
	r3POQy/lBaA05zj6W08FnCDVJIE1Z5E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=g4FJ8o8UQUtyD0eGI0sUCpicqPvdI4Vdc4LMM0bmn0w=; b=cmZW0raJpZImC504fK0B0kMd2h
	XJQXfLj15TrbtRxuoXIll7+dYj88ZVAl2AayT9vhDBlAQ57+Eho/cFEk5It94wIbKS4EH4G+cdutI
	0K9jgabrgunrLX95HA3KOWeYRz+hLh5iGe5EyD3w5xx8w9MzCtlstOcNUcfrAtIPd3RxiWEjnELaD
	hbo41pU2e/eygmvhOngKp7971UVKKEY71/mIvuWf0WfaOur34IyUdpGFowB9/oVJFRm81ZxsZDxLw
	5M54Kif6OKPedXxyOCO9YpK4/4uqCIxZE2p81NHj3kV9mf9cnMGZSmbBCsLntHmPvgWT1OTOymjci
	CwvzesXA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xR4up-00D5nW-2D;
	Wed, 11 Nov 2026 09:46:51 +0000
Date: Wed, 11 Nov 2026 01:46:43 -0800
From: Breno Leitao <leitao@debian.org>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 16/41] configfs: use fc_init_pseudo()
Message-ID: <avQ5dv0747H-XKmD@gmail.com>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E9882A0009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pcartcc13ao17nwrou7g6wschda5fu1b
X-HE-Tag: 1794390426-109619
X-HE-Meta: U2FsdGVkX192Di+y7pUCHBBTVPy2wUPpPXiyNBwZ6pkymjL2kViY37wW7SpaR18L5xZBOB5Cy0jA+nTXPCBWqhvV2z3xhK8/oeomiZPVCz3UR11KMpQuKwUtq4KrmOd7YtWjLPWqpKEh6dGUHVJWdaqA2gCe77AOPwtrkELMpsIJB/82KSjhhgJLIah0zuIJbaIaL1ZM9ScVgzdVpxySzjuCkt0kP0jyie10a7xUTIGwmkJFba7jLXbM79sOU9AHJf0VRkPJMqhxLjVf0ncP70+YaOW4rtSyGGSnUlGcSV5oa5BfUGVu+q3BDaLOZ0E/oe/GWzfPsSAL5R1fobwrda4K3bTb/KG1TD94qlkpyYfpMyIbn408TLDaspUk4ks08gV1du6n2ymav32ASgvbX3wu7yqkOWI/23IZ+CDGmAEc5QrrtRnyJLELzfUshuV2TIDTCFCdDG0v63SBK1DLQpvcVpFQo+e/e/h0zFj0VaERrV/31TZkeX8T4Ch6F5o+vmG1+Ngd7KgQjuvJyA7haIyOxbDuSM/3IqdTGx+gHYYBjC4KKOR039pTIHUvQDLWDibtDGpubcwX2my+5cca9XoHv6piM7bSnt1d+kGIDgiXRKJQJo+Mh53j8QqQcxOlvf7+Fgu7dpZ5UH3QClRp5frHjcm9bJ+484HRvTPEwqRGnFRXS++rtQ3KHf4rG2IMNWEA3y6wclFq/xa69GIgT6cSoRvrTnWHLp0M+ERLa18DMuU9L653tffjh/NBAn3O6I0ts0yoP3p+Xm0EEz8WMN0zM+2EZa560bokwrkaUqfgxb11vdzK5zDqUQ1PBB2y2t2SlSOVigC2Feaag2FcU8PZlYN2oAF6kS4xTVtVsN7Ci8In2BNj3hlFYwJSqnPM2TvOUwbN75AzsdsR+4RSBiPSiSkZS7zf0Xc9vA9aquXalXPBzfRDBYmdw5gVR9ssqPqnw0/xPOkDT2kSF7x
 8clxh3La
 dGeILQ82ZyeS1gHzpOw9PslzWCYXluwciu4KSD4b+K6pMHm3+lJVyBSIpmg+QTGzLCjdNM52BcT2z/ra6biDOBcnKnNbqXKbAb3ypcZJRMtKEOsD+j5gz3jWkf3RVWJbJTccyAh2f0asn8PfsDdmoayGgUukPFC4qXfD8VhjJ4jaCkkrA2LC9A6OqtFpaPEAKJjDJCO3GwL6mSBgsYSQ8AQLTdENiY4nEgkKGgpaEMk2+jDpFvvlXmdn0gbfrl5kYgUR98dHGee1mlTaGqHA1/Sm+89d67HjYOzjFLeh38JvNyOKyR92nk8o8GmB7iJgHgk5Mj4t0J/Ae2a8tihKLm+ttYi8x7Smn6U9D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:14:32AM +0100, Christian Brauner wrote:
> Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
> device nodes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Breno Leitao <leitao@debian.org>

