Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704D560A261E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944326B05C3; Wed, 11 Nov 2026 10:05:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F45C6B05C4; Wed, 11 Nov 2026 10:05:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4956B05C5; Wed, 11 Nov 2026 10:05:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53CE16B05C3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:05:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53A1740333
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:05:42 +0000 (UTC)
X-FDA: 85423162524.11.DFC4E35
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf22.hostedemail.com (Postfix) with ESMTP id A854EC0012
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:05:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794409540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3eXaujzWsI4QrtOtWgTNBZbBC275dnsr/pB67SZEqiA=;
	b=EFYRPSmaL/qH2w9dh7ldySNJtBrbtg8ql9vacoGYAnuTUIRmReybDex6HpB/UvYIkyPfWB
	Kfeso7VQ/pYGbPs3x1PxAqSaujh2JzvG7OSDurJgVbG3/KKG3fEnPUJL/ZPYOGg1aA+R3w
	vde/4dKoZb0tyPqwqrszyW7XKmHhh8E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794409540;
	b=kid2PNaNFpJDUqRWR0w1mZtKdYpw5SW2X0f3XiQGua+culLWFIdOhfX4vHfR7a1Tcxusjp
	CrW67E3Ry0RxSaCAf2uxJIE87eS3w0XvWWuNTmSsK0ZpRlulUoNJPGUFnESjJ7I0A996Ei
	ZuJmJBYbgwdBwCFhzYvhmk5+WOAEOCY=
Received: by verein.lst.de (Postfix, from userid 2407)
	id D9F2668D0D; Wed, 11 Nov 2026 16:05:36 +0100 (CET)
Date: Wed, 11 Nov 2026 16:05:36 +0100
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
Subject: Re: [PATCH RFC 10/41] nullfs: use fc_init_pseudo()
Message-ID: <20261111150536.GF10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A854EC0012
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: z4cxad4zpzd8wujy5cj5upqcujkorh3x
X-HE-Tag: 1794409540-211777
X-HE-Meta: U2FsdGVkX19DC3mdde0RTHcesqh+R4ShCZwhkttkrddrhPip0ixBaB69DW30mLzdV7twqJ5WFgEezzCZGOsXpluRwHG0hp8RLY10aTGIIugBFmr3JbOxCI8jJaP3wg5Um4e1NTC932AyPXvTNq7sPbHMnFw3ixJ5TjnLzLgXwmhZdCIAr9ZQBgdsGhHZF9K+5oB1Ph4qfIbOjywN9DsGhTiTnfED8J/Kg+GcNoblyqlAvHe0L6RLOUXCbjTfVK9BWQeBNovLAkXBUQBZ58IEIRq4cNz0IhhsFwZoczH0qXh5M4hiE5kNBBH78Y0ywgYex+G8kP6BYyekZdC+gq3jg6LcNF6LTDG6eX38Cg0OgClewp5XuxPGJ+BmhVJ5TJeeS+6POmAALOFtj9cubEP/CvDbJFmlhjA6V04jqosfWcaYpLHHWVNwqeN/Ka6oXbo0ErgoZY7/g0NTQ3pOxdD2Ae5x3H0FlNtQblSNmsjPyu00cSs+OyPC6DHxo9MaK4qJbKPWLFJbe/MlhwCgdhzudXzk92IPnebLi8bB/RQYbqnSxMwgHXtyiLyarHIXM/goh7/QL27BQI9Mao65G5hN2fnINN0fvBHLmPEOaHMzs/9UTgh6ASusCxUZJ71IdKkaRVrIFAhn3tQwKjz9vGrJKIQRdbTnHmyFdrEj44yId54iu4dX/MhnAOTMHAufuDxeGOfHRRMtzfsR0wvUe71Zx4Wie/3LEzDu3MyAmo6FqB7rdEZ/SxFk1pvzu1zxyGK0yMz82zQ92KBc+1kKHuvHIEDnXjVMQ0TIk7Ts7gVtij0PXPrzVvA4ZGir9JWbbsU/uFNk5N+yefS/Ah3dKa2FEkVqB7Y9Q+GrCfOOfHli3CmogivQGKeBRbWQ3ZQ3puY6CX71kuA2VFqO3cYbYtQop2PL0PyFXpkj2aOt8c/CvL4TDWNkph6qovWi26oOEo5B7lob8/+UyLiNHL4f0eW
 XcV2Q3uF
 efXBqKGMhXtVCEcb/bTPfg2MvpLfhhEfRYNNjXDIK193QEMQy5nudtsbpzy4gFcPr/3xN5gw8MDdHN/BLwUJdWnRe59jWkbscZWQppEzB2d2NFLSspg/0ghPJbuqvhD1SSOTuciBPfRH6KoiEZH0k+wQuDwK8iMRr1T8SUhhRyxT0IIVFa+zn0SRTdW7Db740yBsj2FjAbEd92pY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

>  #include <linux/uio.h>

