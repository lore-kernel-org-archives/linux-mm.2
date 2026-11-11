Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43B9606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031C86B05B2; Wed, 11 Nov 2026 09:56:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008C46B05B4; Wed, 11 Nov 2026 09:56:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E617A6B05B5; Wed, 11 Nov 2026 09:56:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C41526B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:56:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53EEBA02EC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:56:04 +0000 (UTC)
X-FDA: 85423138248.29.8C53787
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7579FC0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:56:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794408962;
	b=xLbqmzkluuIIf2ok/42hoNwA7mZvGBRYZ/IYjLvSEsv0sUYof5UIiER2cdAEVq7wvFyWIo
	r2MySFulDqZH7FEdxLRdwpOVNCqZEQ/dbr9G2ZpeqPhCuGcai50NnEB/GdhcHojjDrFztX
	ATHzownf9tLmoi6soQ8AZEqj9yYT+Wg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794408962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GonZG2wwIvN+gNPTSiAAkhawJ65Nfia9tR3JjSU8YK0=;
	b=rpo5xALXw3ebQ/hDZIhyGy5GpsItAzBRz6HuQ9ln5fs9uAmNj7hYP958nV+nywc+qWdwRi
	uKVa7XwGUUjxtLIUcgvroipPwKCN4or4i7UD1URxX7zSB03QL5Nf21abWay4EFN7qwnslz
	bJ3aMQ+VMD+MAUjkh7bWiCVz4dYnNK8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4C15C68B05; Wed, 11 Nov 2026 15:55:56 +0100 (CET)
Date: Wed, 11 Nov 2026 15:55:55 +0100
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
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH RFC 01/41] loop: refuse backing files that aren't open
 for reading
Message-ID: <20261111145555.GA9996@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org> <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 7579FC0006
X-Rspamd-Server: rspam12
X-Stat-Signature: 9z7pu6tssou6c8kyqbnozoohtxb47jds
X-Rspam-User:
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794408962-776959
X-HE-Meta: U2FsdGVkX19PO/trg3Q0RPLGjVxox/spgIXZ8Xop2ChaVFvJRpa+uZooe0EMaPyN2h14+DgyH1pQAuFM4A9qmx6uOR4DwGkh2EpeE4FKoMFjsVdxqe8+t6Yjf4m7cCuO6Xr8oPW/VamN8yDywA+i3Er1aQLBJs+ah64IiEMuAicz+r6K0/FiDKiPnCP2CnNRv+g24gmproQaTJKOZfng5vaj7zkfFt4WoDAOTc3V2j+Uyxj21zjEQv1YKg/9qxPxFf/RFU46LBq3vcQr5sz5nKgibL+7sEA0QeiY87sr32pU6TliTSNntcUaugknaxi3/qzCpAQtqEUaFRiZn9uUcZAU8AAiI2bzcL429Sj7E5APn5NkNIy81MvMJ0AMtTkQIpGGQfMAnC4Oz9YT0W6sAe1z1y8yDu9oxtFR0CM2SuBf9qXSris3Sf3nTeRgEy3pgzR/VC4EjKu+TeYnbhgRe5GTSd8V+KV/oILvMOzke59UqqofrGyLhhoFCMeaIsjwCcKAKXJ5eqkPfFfsXIxESj7G1hzyoZoKk7bubcv0uS9Y8YTPD8tlf/vUIIJUVBNmZtysIc37q8OaGSIT2R14LHXoihqSqNS6IKLAfrbebbxm4VbTaIYHEA6nBWjWOkehlE/6/De/J1GjkSU30IamPSGxUmeO8ZALHbP10eM7qWr2Vt8fkGzxJJnVqrBIA0tbnwEX9TC6iz9xBC+nOYHK9biGwW+3cNmPVqgvCxbLaSKK3p620AZIEUjQ7K+7aIDitVp0JbmOjDdE4HgTforWoqIqmytl6nSOxJmysCBA3vfNESBYDtJLQNH+AxxFTkrksfj/0u36lJvwYDj3llK+1ERt4WCOxF07TQyuDEJcKZdC+i5q7Nwq/9q7AYK9M1CTXfD0ccR02e29aUyKtMnY00ornJGIGVV4dRm9z0q4qrO4k8/sAl/l87c49WtHqxiBozFw29IxfdmS/Hclose
 WvhYFUu0
 CBN8IsludRKUMrj6v55RzjUr0OPovI/tiZzZUAs56ja4anX7IszaMEXzRNM6L1Uaqn3TCqu/X2r9XsABV+JFzXGPXLYUWnnqSI0gxSOkQNZQ5wHBow7i4wfxvjlCNu5LikshrWvgks9Z//cdD0wOzooypdJFF7UK0pFpm5Pb78Y8iQ6VL8qhGK+/5CUo9k2ih5RZPwjdf64g1iauEZO/g7J+iusgu3VQ5TBgQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The fix itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But i wonder if we want a thin wrapper around ->read_iter/_write_iter
to do this check so that it matches the normal read/write path?


