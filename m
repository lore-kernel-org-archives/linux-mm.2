Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65F8606A332
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=blm3Fzks
Received: by kanga.kvack.org (Postfix)
	id DF8B16B05BA; Wed,  4 Nov 2026 04:25:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA90E6B05BB; Wed,  4 Nov 2026 04:25:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4AD66B05BD; Wed,  4 Nov 2026 04:25:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9EC6B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:25:37 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F22741C3F0F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:25:36 +0000 (UTC)
X-FDA: 85396903872.22.19D599C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 64C98120004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:25:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=blm3Fzks;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6y/QB0A+W+6N3jiXZRGNY1xzzbI4566zJ/BaiNow5YE=;
	b=KL3VMRocrriwRWipN3eVApl4QFLOmkTOvSA+usI+q8WSW+08mALJAm5U/zfvEggFXsg6kC
	9Ql8T86Atp8ZvrloSb7LKRcovx4jXBLchZrGi9r8xaCbQ6naDasoWZrv1CCfsesQlpkDBv
	giMLjgKfHgfLkBz0l6KgYT/3hSl+BtM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=blm3Fzks;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784335;
	b=YnPGyTZKYa1h8ixlZ2xDa4AOBmN33wQSf/KbycRdKDrelMbh+Cqx3LeTB+C77/nz7ejZpP
	xuaXIWCDs//zdHjCgJ6BDWoxdybDNVsyFRdRCWXUovxtgRaJKHlZenNCxQXgwbTyQ+m8lW
	/cFAFa4AiwTtNyyTxyDWBc7zKHMh72s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9243240257;
	Wed,  4 Nov 2026 09:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF441F00A15;
	Wed,  4 Nov 2026 09:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784334;
	bh=6y/QB0A+W+6N3jiXZRGNY1xzzbI4566zJ/BaiNow5YE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=blm3FzksIwmy/gfP+m6bQ3l19t8u+6D7VnMjx0mDrwJfI9yqkrKHuitgS+09MOaFB
	 5IAfK41yIRysnuekyE6n0MoqHw1erKQfYIHd4bcxX9IzwZZwgAZVYki7z4Cj5AIA7/
	 ZPGTgJBvsmIssHVAjO0+bxwX4CubbRT4ywfOYmYyDPmpCbFuRzICtnH6f+UaysQImg
	 q7wpeNs4gNICgefy3SKpkaeX4BbxjIfO+vSSQmRySEd1imrt/h87R+LlDv4MuyR4ux
	 lqn+1ClVwhwp9e3GHxStc7SnGYtfRsRPS5FsY3RelvLgIwBZIwrO2g2A54DZvsL3tG
	 vhwB9M0WME18g==
Date: Wed, 4 Nov 2026 10:25:21 +0100
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
Subject: Re: [PATCH RFC 11/16] proc: let procfs copy in writes before pinning
 the entry
Message-ID: <20261104-ankurbeln-gepflanzt-elegant-896e9dc995a2@brauner>
References: <20261102-work-procfs-core-v1-0-75df35e4f8b8@kernel.org>
 <20261102-work-procfs-core-v1-11-75df35e4f8b8@kernel.org>
 <sashiko-outbox-195538@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-195538@kernel.org>
X-Stat-Signature: nat5yefbaazy3yepjakhmsmri4a7tqj5
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 64C98120004
X-HE-Tag: 1793784335-933627
X-HE-Meta: U2FsdGVkX18VlD7P0eN2JM5wI/SRza+R0mh3KlB65NTfbaQ7xCR5MDwYyP9b09MxkWgR/RiL/nLo04Lr9VEtRKmWRKvsfi7OEJXLyHrYWBf6W7L1+rPfbcaOfncpU56oxJy8sxMm0HyaSVFYEp4HLMjorJ2OU7yL1pNq7ZPpJPJgWPyrqR4avSKxilaiKxd5TiRnle7FuwI8ic9cDkJeQ8sJXq7UjB7fA1dSleMJAZx5Mkmv/46NvxHwyFp8h3cS8coqUhH8Zh6ZxZTSo7iihWZASWtiTEvDCgi4gPQ5jhbQZwNaMZAxTlV5wLlfMDCqCOGj43tUllaT0qn/wE/EtHUM6CLM3AGY2C4i8bhfn65gGBLJFcbTzgz66CBeZHkr8JwzsBQz2IwhgvCAOF3PT0A7Heu2umKO0UGTsVhLRgf0gbBT+jKe9thBiVxJI/dfMxW+FsDEuOIWokUIc2eGYci2kix/6AH5VGAEXLqTVjvBCg5imYvsnfZygvhqZ5L8uuOUuLAK+1nC7n9ktfmPYPgU55I1T5wh28L/YG4zfhV/6yPpWvNMQyPRoFnGK+WQykZ++36IZiFxopZQmbs4ZN6Gm6G5inlVwRW5med+cabGyRv/AonpA3m0UDIHvA/7tHSy0xfkACHPSevAWRLgkOSOq7UgYXjB/6qvdNJe14W2aWr+6Mb6Ru2y+l40HmI24tvoipjSKqpPSWBjQxJjDBAn6veXtfoOCRCmAJbpL4NC5z60QkHwIzmfxHPfPm0rbWMGj9d5FUs/bE9An4M9S8ZqWslOhgIrmuh11P47X5ISYmPemYQoTE2QC/tPiLhTvcZFrMDUNTdbTt/Ws8vwb6B+7yzxScoj8XPuFUfpbdNn6z4iA+eC75QvozOKRT801wbXI0/sFZrvuci3s2d56xm11bI1WLx2XAY5LJachoEbcSfvZ4MAGpQ3Nqb+zXIjzzboVDkOlfVetEmjYkq
 AYLumqTq
 n7TUZeDtiHvDNsr/7yveZRvSyh6J26EXTfAmjwdxV4nXEk0jMTQ2jTG3WIgN0WkoA3id9anHtaHnOqEwiV7vfj6TNHMrzDO9HnG6PuEsn+OVlrVqwnB/Pg8IJYj74fY10Xe33dydvikQlhS+fKCGAKOHw07lbqh6XxCDgovS3MFXhqZU4W5EK3pDY9C4MCfTkA2I+HFMXm6Fb+YXI1Ctm62LnJLvRjwAGDI5Sz5NJnjEuMnaVqhtFx/c2DrJ8Hu2UokSbQZA5TlFIjEs34l0/MNf4KVWDv1bCW2+BU9CoAxRh/gR5ny38Sa9EOL+CFAovF+yOzIggw0NZssQSIhoS7rVl4nEulk1QByWk6sWKhH1A40dPSaFOLaY2tm0uaobzEtGWM4w9zoIlHZV/6OkwlhSg0gx0BPbamBMYqzx7eODgBWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 03:01:26PM +0000, sashiko-bot@kernel.org wrote:
> - [Low] proc: split __free(kvfree) declaration and initialization in pde_write_buf()

Intentional.

