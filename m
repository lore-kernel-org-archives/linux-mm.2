Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BF58606A8A1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2A86B05B3; Wed, 11 Nov 2026 10:04:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B93F6B05B8; Wed, 11 Nov 2026 10:04:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71EBD6B05B9; Wed, 11 Nov 2026 10:04:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53E866B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:04:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE72240321
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:04:26 +0000 (UTC)
X-FDA: 85423159332.09.3040F4A
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf01.hostedemail.com (Postfix) with ESMTP id 495C64000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:04:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794409465;
	b=5sNnZNDOOfG+zkyxio8OgkjMUrSKJ+69VQJKcVrXb9s2gmG9PnEeCb245pWBBeV0S9gY8H
	I27OIMYZdsaBCgYooDhQg7z/qenefieBtThkvcBJqwQSOcaEn23Hh5Grg+xeAJSYjTRewS
	lqmOFVr2utC5a8FjKqperSufkLJAZBg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794409465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=QYHjj1oXEzUObpvtajIuimLtb9ajVG9hYyG2wGWsrsX/Sr/zRu+ttDWZ2kBcMxMnzt1HmW
	mldNIe+5MceBOE/G0I73K5lx0PUPpP/DFUqsrjyHM3bI1DohNbh7+aKodenAtkaY/HED6n
	PT1jLoNnIcwA/GlLqPp6VnNK7xKN6rg=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9B6F068D0A; Wed, 11 Nov 2026 16:04:20 +0100 (CET)
Date: Wed, 11 Nov 2026 16:04:19 +0100
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
Subject: Re: [PATCH RFC 04/41] fs: add SB_I_PSEUDO
Message-ID: <20261111150419.GA10644@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: o1azxfgzc8ekknpxdnrpt945xgk4x838
X-Rspamd-Queue-Id: 495C64000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794409465-939334
X-HE-Meta: U2FsdGVkX19Vtuz7aI0WVtJCRKIuc4jXbB3Kzp0jONe1KvwQWpN9NP+WPqGX1Si86Vj0nvnLO6yzNz+5ExLFhTJzcrjXb9MEqCrFnwttLuoZ91gVzNdOGiNESgcHLEAA+NCp1Gq+MWsgmuy/sk9cEJIG3p8DueWABNoInZOdRtovAgO+EIw+rX3+Qil32AWn1cyH+jZ6FhoYs+Qa1sr7oytsdjdMsqrSEzyvbhknoUUTs24dwytkTjGu+KRGa/JWpRMD2eH5nppR/aEODsoUY1GCtcHHbMMLWcqhUC+7fs6Oh0x9MgMROCc7G5gKTAt22P3bJB3B3WOMCmE/EzMAyl0qOeFyiu8qEt2jcazq6okNGcbpmPq9tg77l0Pv64VIKTQK4IHEVJ9MOLMB72UrB0JSy6SxMXiuBCTxC5fh2DWJlkFHbdTLFPtyQbyHNGsYBOFbym1Jdww/LgBvE6ujUtpq9setpucyxiFi1GAbeNJBo7qyG945a+C0V6uBhs6DqcfECJC0ZHxhfB3Ngekfj1fIVaxSm1TOAAyIWaFFZT6KaxDRSrYmakGcz39xQlh1zk6SOW2Op4mSxM9FfTUqgqj8g6Qy3G6L6zS3bQOKihptKze9qJj1/tRqvKZ1qBWs7DUxTdXs22Xl1YhIUn1/1r0JtpYzLp5Iv54h6sTU805K4Y3VdMFiTM7i52Q6Wu4HLV3TMfaJfHzZ7IsP0FoUhZabMOzndEzqtTaI0asDKXXLgEiM6vneIvHvBtAPf+MJO/KE09IVxw38CjtN6rXBiY9pYoF2Qz6gFMgrIgsmdKdymv39bIjHkDvb9UJR044STzZUTh/lKrjqrwnvYNNcMTHTPcsv7VUfOE865mbQd9ScODXfwXFVqFeVkLNCSGPxTLnMy95XKMSLno/jHJul3P2YvAxjZoEk+DqvZuPYpW5IDcWoYJAasOel0vQcTCyONYNJCqTYFSKtfHL1w1Q
 /tZ3SK2I
 1GXRUN30/PmBah3hLLPJqwlOBZUAn3ISGjLJaMhLPwugsqZrR3rcKwFpDVXURb1JFP0dSJyfm4IitIH4biYJ2iqQAM892aRYe95TrznX0zBngyKDqyeQlNRMSNsUIPtKESFLVZPeovNO3CnW556pqPVsaIVVVnX1vjsX6T4H6eRkS4uoCGh7FzJFxNK425Ma1OgQzzbSk/v2M1+CcCX1/HHYeqsnscXBPlX2z7FAF+BgOIY/R9EIqYyE0Ib6MkT7kY/d9lIddAUoZ3D8rLW84daULs/aLonI4dpOJSlVsumZQO4R5f5hSNXkwdXZSxOvKBKS/wlgNxGR1gwhDSxIhMaukVWPBcLniiUK2ZWEVnVWirYBHh75ivrkojg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


