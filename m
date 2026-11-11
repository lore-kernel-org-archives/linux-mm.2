Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC4B60A3833
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A25F6B05C0; Wed, 11 Nov 2026 10:05:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152DB6B05C1; Wed, 11 Nov 2026 10:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 069306B05C2; Wed, 11 Nov 2026 10:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D76156B05C0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:05:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 625D9C0341
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:05:20 +0000 (UTC)
X-FDA: 85423161600.24.DEA54F9
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9C42E10000E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:05:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794409518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=O3QDLqebdY0GJB+6s3dAY9CUuep0XI5C4OaztHRN+A/ngCUOIVbkYmJIBzHJc98bwFY1gp
	ihL+UT09L2tPGvhWgjgkvGelwLtE1mb75SabzrYhGhxtYxhBbW/21PXW6lTAgxWlf3BYRE
	PbcgPZqezJkHlWbCD7XPnaIp65lohhI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794409518;
	b=CMIdReWGQKuVofKqURBFKBTpKbyKKX6BZMz7AO12OWo36ahjbRZcXDT+FRs5zx2CoRUqHh
	8CZOr1kn6+cxgiZ9+8I9VDVvqfTbBRTEZhBL/Sl8BVTktFLn8vdxlwK5A+ijTycdZHPiFe
	GGxi86DeggZw3CzNHf5XBluZvmNqHjE=
Received: by verein.lst.de (Postfix, from userid 2407)
	id A94B668D0E; Wed, 11 Nov 2026 16:05:15 +0100 (CET)
Date: Wed, 11 Nov 2026 16:05:15 +0100
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
Subject: Re: [PATCH RFC 09/41] bpf: use fc_init_pseudo() for bpffs
Message-ID: <20261111150515.GE10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9C42E10000E
X-Stat-Signature: a385c4mois7x65cwssbi95ohtkqayxak
X-Rspam-User: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794409518-608714
X-HE-Meta: U2FsdGVkX18l2eM+4JeYd7H6KMHhMpolRaC6G3Fau1PqCDm8fjFZ3MS4TBs7d0ZeD0gy2/ErseI35ZeGGV3Fzsb9tYlffCSmL0E9BcPy+hGoVQ2ai4HmRY2gl1Bgt9QHw2zwplePIlc0QPMpkWkQyhrbjhaJHuKlCTxpR6WiFz0XAo7rGJloIdE5InugOcHxjk4v/GvraoCcr9r8beScloqshJINartypXnZtFKR+YUCkY1Cor2JIsJinYcgzZK38nR8jyTukyjXYYWA1lCg+XCokvB98GeXW/aF93V/+IWEe9G7gyi7cSc7xCgjFVoIm3eVG6o5Dj1/WXznGglLbLJUVaQ+VSE7VsHhy/Q3yf0ibHCMcJRw6+TVSDmWoy9292k4xEsC4wLnjJdImPfxVZj3kyO4v5Rj1EbC7w8WQuqwVEI88Y1NwvbV/xtRpOGPZXaNUpeqFrZ8y6LMkDkCl9fZy8JGgYclNczWbwFf4hbH0ROYyVwUi622bOYDOyDQYKsW8WZCT3YGYzQQfEjYSxPqcP8Op46DnpXbiFztSkg8exJfGK3K+Uwsh07nahYt1z026P6IfZX0hRbDzSWTIcWimbFxEwPSav9A7coi4xBzVQJmYyiUCxQZYYa2Dr1D5jOQaqk//ne6lvv5QPHBwLGTlCH0M+EmWAi/JihwhO1VI/A1UfBQecHwmCNhpZOsXZwO420NNZivWvELAO8oWkjPd1bHUxS/bHaYADRbfBwnCcUvMZWKVfodUu6cVEnG/46AAPAmEEUWW4gAnlM+ivB7Xyl2NeB1m9bR2nsEv9fZUUan1uSfYurSBiydU1KBOh64yL8VvJxNz6Fg0/XbNAaAstx10m1ZKSzCJBN795sxM+xIQxdcTvrrDvZT+IQ1x237wzdyEtcvirqaBQZ5pBwEoTt913ZhkzgI1uym442zbkcYdolsPBj9LwME6+Qd0fkM24iU6Lroc1Ex6qS
 jHKlz8oR
 vRogPazix0Q/z5scD8mV5Xlrn9qewBVR8LaapHNi4UR1zzna0TxDkNBfGT86Nmii0TBnF+arRqqwkEAXZCiWrZ3Uvd49f6QrUxYOp3AJNqlGRmirZnh0sOvXywP26hCx4K5PaLN9aQHziH7uvh4pIgikH34MtVXftDRXQw/dyrYt0FXuPprjt/OSdRMcoZcneUs3FkEFTYIApbjEeotZ4UGQNq67/TsPReQriTHZi66/Imyl8OxuB23aURfU3TMjBuIBdYQMOxm80vYRAFJdikI2motPAC8m7e1z8yfnIR807BjaLqfA4NlbsVa7Ezj70niqSokY/NyvNzn6UiYE93KvL+8IOPvpKu0lOjxdH4fAJfYkCCiWYOsf0ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


