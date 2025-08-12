Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D451CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 01:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91C158E00A8; Mon, 11 Aug 2025 21:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F548E0045; Mon, 11 Aug 2025 21:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CB208E00AA; Mon, 11 Aug 2025 21:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4EB058E00A8
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 21:30:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8661562CC
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:30:18 +0000 (UTC)
X-FDA: 83766374916.11.4BB753A
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2382E180009;
	Tue, 12 Aug 2025 01:30:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JMbfwpsR;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754962216; a=rsa-sha256;
	cv=none;
	b=XZI7n8DVjLbgOEKGm0Cs2GTgp8Wl+lDIHMD04oYfZ8NJt9X5aJWZJdyILLJqdr50FWzmS6
	nhwksaaJgvasWL9UDKnqS3VA7J9Y75RpOtrDgus+oKgoZiSXk89DBmUDJeEKi3uF0CRdWo
	TkStAl80MaqnHv/yljZQfeqgmxUOJo8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JMbfwpsR;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754962216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djZxdkbYS5ABjJh5vZ+OSyzqxKEA12clHOn12k1eFBw=;
	b=SJKuVO02NoQXZUtGdBM92TTLB2/95ZPV75VOkLQNJsu0QLgXAexMhWx3PEUQA2qETPNfgZ
	kIEMwHsm9fWFQCtDiNdQ6ea9wljHy/W64HlV3B/LzyX/ecMqY80WMnEjQhAdi8G9mYWGEZ
	tvpiekhjJr/nemEHv9Xbcz+paIVU4OQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754962210; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=djZxdkbYS5ABjJh5vZ+OSyzqxKEA12clHOn12k1eFBw=;
	b=JMbfwpsRNCi9vQ8K0CdPK0zFsmtjl1OT5ze7/nvcC9uy1+BBNgnJzrXzYo/jsMsVasDPYYjhUbEL4r0yaX89uL9z80p/b5ORZUZIyBKo2n7zC/7pwar7Es6i3EZ6u8anU7cbm5tcI49YJa+A9LIyWz09nPLOifv3+UzTQQDKM9s=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WlYvemQ_1754962181 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 Aug 2025 09:30:08 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linuxppc-dev@lists.ozlabs.org,  virtualization@lists.linux.dev,
  linux-fsdevel@vger.kernel.org,  linux-aio@kvack.org,
  linux-btrfs@vger.kernel.org,  jfs-discussion@lists.sourceforge.net,
  Andrew Morton <akpm@linux-foundation.org>,  Madhavan Srinivasan
 <maddy@linux.ibm.com>,  Michael Ellerman <mpe@ellerman.id.au>,  Nicholas
 Piggin <npiggin@gmail.com>,  Christophe Leroy
 <christophe.leroy@csgroup.eu>,  Jerrin Shaji George
 <jerrin.shaji-george@broadcom.com>,  Arnd Bergmann <arnd@arndb.de>,  Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,  "Michael S. Tsirkin"
 <mst@redhat.com>,  Jason Wang <jasowang@redhat.com>,  Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>,  Eugenio =?utf-8?Q?P=C3=A9rez?=
 <eperezma@redhat.com>,
  Alexander Viro <viro@zeniv.linux.org.uk>,  Christian Brauner
 <brauner@kernel.org>,  Jan Kara <jack@suse.cz>,  Benjamin LaHaise
 <bcrl@kvack.org>,  Chris Mason <clm@fb.com>,  Josef Bacik
 <josef@toxicpanda.com>,  David Sterba <dsterba@suse.com>,  Muchun Song
 <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  Dave
 Kleikamp <shaggy@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Rakie
 Kim <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  Alistair Popple <apopple@nvidia.com>,  Minchan Kim
 <minchan@kernel.org>,  Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v1 0/2] mm: remove MIGRATEPAGE_*
In-Reply-To: <20250811143949.1117439-1-david@redhat.com> (David Hildenbrand's
	message of "Mon, 11 Aug 2025 16:39:46 +0200")
References: <20250811143949.1117439-1-david@redhat.com>
Date: Tue, 12 Aug 2025 09:29:40 +0800
Message-ID: <87bjolgwe3.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 2382E180009
X-Stat-Signature: w97imuaennohb48a3i3in13t1f3ia676
X-HE-Tag: 1754962213-616428
X-HE-Meta: U2FsdGVkX1+rvhHEl4AdXkxkm/L0pqGTSvXVOrStddP1JLdoCg23eh3Bj+j8i4/w+RRbSn6wwVGYvvnn8FVRdjTT3kJgIVLNT/LnXIMxh7JDFnRYYS5WsC7vgVadMlj1suh47aDRl5hsCGU6O9nGJ/HRJkfGA/y0YcT10NZU6lZ/VC1MF1qff44lnUn2lw7wB9HMsggZXqE7XJp1vxx0FcOZh5HgseSR0IKSkVAezxk04w4Lni13fa6QYW2QVDQxGOC8PIrkJMAbpSpMD72x330GJUJmrQ1tgSnQksAsNJtxmE3WHirMDCaP+fEqBd85w+KPMY6wGtsf8zOKW05kcjetzPaoOUqC7Uvv3kgIdU9aaBXLceggWYzCdA/9rGHOrpF0u4O5QtiurgHDwM3UC/M0cxhWJKT41zF8m5Bd9GaZ97ZOE32+hsHf9d90roN9oVd2ScsY4z40a6W0vsgvgYRnBujnR3hh2EfA5HkWWUnBhlExXnVEK2T2FsCdLm9Tj5c880SGxHjNRPBVvPFpCisPX3gpwHuyLZ2I10r5M3aVyG9ZP4AMNFMU0rZFVoiyZDye4+w8KzHYcU/237owOgeCZ/63AI0GnVyIEu/XgZh0KB51VArzs2pAeZy4kgvk58yDOgeDddP7tOhZH09ZkoWPxyDHJpHJ5EmjUS23YCLVycLUmbBj/G4AlQgkL17ZA/hKdg7x+zeoQzFqdAJqfs2cyRamA833RrMHfDGViy/fX9jISP51VHlp/ECZpPCs83UiCzP7os50Y1ndq2TgMGpSeQ4nqdtx5HrIGTUU4Mlk9L+9J4oBoFybUiUmz9MEQrlI9tGlA1KTOuYDx+8fNRSSMArJ9PoUzQ96exwYQHfmBH9wwW0vbK5bm/dFb6FgV7nM67j0xdb7x/iNqffhNkqdVY2PCHm6xEynK2qptD047A43Bo6G8LClx/emwBBioZQOtHGyb+MS5rJWbBY
 oC7ggtqX
 tYaNBPvx4zQEVDq26De0zu+jlmBWHF5Q4yBeYABdzWJh11PkktH9Zs4WcmTw6m+n5YZ0N2Un+FuE/O8wiK7ld2vOuhlbF5bJa4HCbwl80D5ho0T27Shpvb9ZJqg51YvWLww5jpXHIET/XTqH0kv6TfHfRT2GMn9gO3DQrhIQOSyF4x9n5Hv496gSXkV0S8DnwA6Ihqzjc9uZIv590XK0rZ2drA5uq8cFSR442Ott/NVbc0WbOsc4/Ugnx4XyOpIi3uIy9DSxRz/M6MIIPTkjSNjQVW3Rb095dT7HNeMngfLrUYi9UqxvsE9EpfRNIk0MdLJhSRP5KfVOtBE4Xtxxz1++txMOsE4OKRnP+FNmkdnBJr7I8c0RYFLnpR1f4WonAb69PzOcn6LJO3w0aA5hHMs7qFKF19L2mD5iADXAwMAkAfLaUfMh3X0+2w/ItFTP6PrMYWPViVih3Mwq9UjdQjaSFTaxColOo0xVWoAtqmhm4QQ/Pt4BEcuth5jAqV+MQhINbtRlaT4HE9usFoYHNH5JxwZuGOzPIrP1IwI0qR35OfP9oe5OmYMh07TyuRMw1zipcrZdKXrzgMdZ37tA6JFPUbBW4jYIwpq8dPCUjtSb64LRVos34skAVk0fHYwrgKcncC8Qgfk8l2LpzpXgwjVheUfxE26y5wSbttTPyo1bwkJy7J+qnnQd0q939evL4eTZSycBB2W6v9E5Eu2TzbS9Yile2a9TDGEORqG9NRbc1CxY9KsOWAMe12buPwimmnQrSvvMXDyqN0oEPiT+MzjzntykhI5J3puyprgkkZCZI8N1bZTbaTpcoVPBQ7ID3UhZTQAXttXlk8B1AX95VPgSd89Xr6DaBkR82aufa3n5dxwbl/WkZvfhnvw4QJLwm9M4J5E0dd0fKq7ZB1HoUOR6Slf7bjPQ6WBKI/DqhngM+eIZdIeASE1xMDtfJmfy0zDr5cnP+2YRMPHSkPS4LjiNyKIPw
 q3X+fz2M
 kofSPuiC9EOA7p/OE9fs8p/90dy1akkC8sOVve6K2tan4pGOX2VXwbs5ANhHay7M/lNXqX3inTxmMGf19SoLjZhKy++UfklirBn1mRPUsRl2dFzQ0s6eAk2lvtVJsOsUb3Nnru72Lp0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, David,

David Hildenbrand <david@redhat.com> writes:

> This is against mm/mm-new.
>
> This series gets rid of MIGRATEPAGE_UNMAP, to then convert the remaining
> MIGRATEPAGE_SUCCESS usage to simply use 0 instead.
>
> Not sure if it makes sense to split the second patch up, a treewide
> cleanup felt more reasonable for this simple change in an area where
> I don't expect a lot of churn.
>
> Briefly tested with virtio-mem in a VM, making sure that basic
> page migration keeps working.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: "Eugenio P=C3=A9rez" <eperezma@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: David Sterba <dsterba@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dave Kleikamp <shaggy@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>
> David Hildenbrand (2):
>   mm/migrate: remove MIGRATEPAGE_UNMAP
>   treewide: remove MIGRATEPAGE_SUCCESS

LGTM.  Feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

for the whole series in the future versions.

>  arch/powerpc/platforms/pseries/cmm.c |  2 +-
>  drivers/misc/vmw_balloon.c           |  4 +-
>  drivers/virtio/virtio_balloon.c      |  2 +-
>  fs/aio.c                             |  2 +-
>  fs/btrfs/inode.c                     |  4 +-
>  fs/hugetlbfs/inode.c                 |  4 +-
>  fs/jfs/jfs_metapage.c                |  8 +--
>  include/linux/migrate.h              | 11 +---
>  mm/migrate.c                         | 80 ++++++++++++++--------------
>  mm/migrate_device.c                  |  2 +-
>  mm/zsmalloc.c                        |  4 +-
>  11 files changed, 56 insertions(+), 67 deletions(-)
>
>
> base-commit: 53c448023185717d0ed56b5546dc2be405da92ff

---
Best Regards,
Huang, Ying

