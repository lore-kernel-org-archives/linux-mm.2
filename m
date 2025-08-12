Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38538C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 06:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B738F8E00BE; Tue, 12 Aug 2025 02:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24608E00E4; Tue, 12 Aug 2025 02:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12AD8E00E5; Tue, 12 Aug 2025 02:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5868E00E4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:33:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A53656424
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 06:33:03 +0000 (UTC)
X-FDA: 83767137846.22.BF839C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 28D8720006;
	Tue, 12 Aug 2025 06:33:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=o3Zdl07+;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754980381; a=rsa-sha256;
	cv=none;
	b=LwCcYP6ONsoQ9fF4q4tLixXGUMxac2sptAVvH+s9dgyAp+waJf/K9SrB2u0zUs8hVilkVp
	IweSEAuvRwYF40tlCubt/Rx4Ikm3Ob8rlzuqiEw0yFpXhQPz2e9i0Si7RvRFP4ppEGL54N
	QyFDkCKbDfqKNwxPMKuJ0JUjJOd/qh4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=o3Zdl07+;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf13.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754980381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80CcYUyhFS51zi8RkV5UHs4TwEeN2kI+C7wf490nVe0=;
	b=prBvPVT8ypTcCuBNvXEOejQCnNpmlaI+7BZwMoiuIdKb0FgVjuxSyvsfac46w6C7dW7uAV
	CIBlYJaCeW290St89+LZEm0dX6YRYb0H1oapuM3JtCBQQjxlKJ80Wftg6rkLxrbNcG1C1p
	zh7Mikr+O/GgT/FED7QcQrm0lyTYrxo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 53FB361138;
	Tue, 12 Aug 2025 06:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5D8C4CEF0;
	Tue, 12 Aug 2025 06:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1754980380;
	bh=L+sX4qQqPbDUBLkuV1Ks7WnwsWzP4JYCHfnG9R60EsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o3Zdl07+nWJldBMbMVuKTfEaKA02+JJIAzDpjCNhxFWBMLdaRJJhBmPRrgtO3jhOn
	 3DLPc/DlinkClYmp8AGn0qc5ZzONh5I+O4JSq3yBXwTxghSqeequDUZMB4Ps5ZU4fP
	 axmDeKecaYk3Uif6H2WsVrS0XFX4G8URQzeK1yi8=
Date: Tue, 12 Aug 2025 08:32:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Benjamin LaHaise <bcrl@kvack.org>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v1 2/2] treewide: remove MIGRATEPAGE_SUCCESS
Message-ID: <2025081248-frisbee-empathic-1815@gregkh>
References: <20250811143949.1117439-1-david@redhat.com>
 <20250811143949.1117439-3-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811143949.1117439-3-david@redhat.com>
X-Stat-Signature: noh65f9fbiu9fijtfcczu57eo4pjf6wf
X-Rspam-User: 
X-Rspamd-Queue-Id: 28D8720006
X-Rspamd-Server: rspam02
X-HE-Tag: 1754980381-510299
X-HE-Meta: U2FsdGVkX1/6yoHl4BpJ5R1JgW2kC4LwFEOpd/sAF0Ujedoo6XE3QGIF5cqwAC3sKsssHj9hSxK3uPC7dP8hz9/V1lZwbFJgVpMU55d/9g5JamBEstHBH0N0L8D/S0NekWZ/2k+Z102Dqwlqmx5s+9bG+8FA3s/fMlBykombdZdahmhCyjrGRMdDKgANbyKi1bXT1oHTHiMaAs+twP+BG8aVEkIOl0pS9W0XITgDQgqmwZaj2tMnXewl974jGY6qzIAC6hHIjMX7QYeJ0fXeiyHNDqLrjpk5yhpfyv2ycFUoVSybx+Iu+T6bML0RsndIrWe6jt2yXp4/tYVUCBXjaqo9tEiQiM9MQ8sv8pl6LyDhWuhgnwONMA2LIdUoP6n0bzo9Ch8NhHFGJK68sjTAbivNu+pJAFfgwXXAurlJu7xJPNpLMDn7zNopY38Qj2GCjFnHcbVjRMucq0agqHltWTeXDu+adV2jNQ0d5NGyhr+KRaT14TeET0s11Cb2sXCR8MdzPzrVKDTRKypOiWfZqf0K3Wy1ozHy/g1C1yxGIxefg9lHbnNm6AR1FAiIPtM+97bqrDXxThY4N4fBTcbl8YziblH6jo/tQcsTFGNyAMTZx/+txgck6eCIwvR/Lzyvty8yVy80MKmNtkXFhkS3OSB52Q9yqd36sMjwjWnuzqCVy3TX5p0zAOEr9oCBJY0U9GSl7garNkFmPRLZUwHq5HmvhIaoacaur4WnBrz4b/cfxNwAihYMkShqYSBmv5xNIJjs/bp2MzdNS6cPhKdoH8GDVMIVXxw30OqVeqABj0DGdf2emX76XlW0ilPjwEfzCynOT/pMOpKpKX9b6GMYPNzQQtQeSxicbmexAEr12lXZ1b2wkE9oI/0byXWtStqvigwzSzIPS7UmFxcXvAz/nvTZkCSBt9k94KHIX1i3uKfKj1EauidZXHKtwC9Fg1/xs60eMOvJO5cxw2oAHx7
 9M2g1GRz
 Bz7YXV2FDkCk9+Na1cYhkYr49uMLvrO+dSaZ/W4FwNMYZ1vroz2wTpqrDiOqWDG5/rc0Sbk80NpTm4tu/lIalEzfIfem/oHuSPDg6EhTVBgkpXkD02cwe6xL7UyDbFFqNAFp4pyoSGnljqtmmQl1WNL7yjymGCpz/iVQ+G0e6o9UoF8TxgZrvPzzyCFp+ub20iBlQc6r4M0YxY245YdrL7R6PF1WRxIjOCRt08jXhgsuHfSBt4dEM0uKQOQZjmLO3fLBdpmeN6mQ4c+lf5vFXKhstOzLfALuAUwGW3ibaRXnHaH/djpdnLd8puqtSGRUGYziMPBnwjyhohrEQ7jr/PYZwA/QnQvYrzE73XljCPFAtbSCJt7ESTlhpklIDtwRPp07xgbJDfVFHRlDY81c04XJ6PKOi9xZnYgskD6lQkgoYiBvgEPKRhR08u6juFpNhnUpfRo1y+WLyRAMSC4V1O6RaWCI8lH0JhOhDPuGpQ1SfG02ueUNEuGP+krqoYOoMmYY8v6aNyYT0ibY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 04:39:48PM +0200, David Hildenbrand wrote:
> At this point MIGRATEPAGE_SUCCESS is misnamed for all folio users,
> and now that we remove MIGRATEPAGE_UNMAP, it's really the only "success"
> return value that the code uses and expects.
> 
> Let's just get rid of MIGRATEPAGE_SUCCESS completely and just use "0"
> for success.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/powerpc/platforms/pseries/cmm.c |  2 +-
>  drivers/misc/vmw_balloon.c           |  4 +--
>  drivers/virtio/virtio_balloon.c      |  2 +-
>  fs/aio.c                             |  2 +-
>  fs/btrfs/inode.c                     |  4 +--
>  fs/hugetlbfs/inode.c                 |  4 +--
>  fs/jfs/jfs_metapage.c                |  8 +++---
>  include/linux/migrate.h              | 10 +------
>  mm/migrate.c                         | 40 +++++++++++++---------------
>  mm/migrate_device.c                  |  2 +-
>  mm/zsmalloc.c                        |  4 +--
>  11 files changed, 36 insertions(+), 46 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

