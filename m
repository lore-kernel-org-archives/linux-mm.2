Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C188FC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C891E6B02EE; Fri, 14 Aug 2026 03:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68C86B02F4; Fri, 14 Aug 2026 03:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50866B02F5; Fri, 14 Aug 2026 03:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CDAA6B02EE
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:54:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 05B20A29CD
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:54:02 +0000 (UTC)
X-FDA: 85099111524.08.4438EDD
Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8F742100004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:53:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=C+kIyFuY;
	spf=pass (imf14.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.42 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786694040;
	b=5Jq2xBTjJhBizwq8dvT7Xv2X+BTunY2jsz+lA9w/TNtFnLm+NbvHgAbXZ30Egx1gFun1Hv
	jzjIXIHPvUIGUoF4QktAGBmmz+5B+SDXowk/St4QorTYB3h1iTvk3qKy85CwMwEi38F+ly
	O08cKUkg7k93zgWi3zEdrqTYPdP+kr8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b=C+kIyFuY;
	spf=pass (imf14.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.42 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786694040;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5X4CvU+1L3LRx9eYxrJOuZyHPoADtah9tMj/5sRYWk=;
	b=CzhfPViGDL/ImLHbLQe+clUuO4Q38ltfKe+rb9c+5XGGyn6Ls/Jf6QD44hBlEmqNKVm3dc
	WsvyJOMpq465KhSturvq9yM52Ndjv1W2HHN3s5iwt7SnCGs483MrxCsdzmDF2nGtNEpEaL
	fCFvY+EGjvNYuNTYXpe2hW61cHD+Sbg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1786694034;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=d5X4CvU+1L3LRx9eYxrJOuZyHPoADtah9tMj/5sRYWk=;
 b=C+kIyFuY5Y/bvPNvTJ+xbcMYIkxz55i1ZKwol98/UpscSvJuvFaVOSKqHv6Bnold2SAj7X
 wEvEvfW0Hs+HAvFSWDsyJXULpaid0K9t7Ln9ef3ZjBshUJGFAVdonZa07Wsx4zqeG0ngSv
 xwJ2FuAdRcwP1MzmFBS/6kIxqx2QTVsZie8qipkEwVP2cy1qFIPjWfcNphITqAX8+2jExW
 FU9IrXGFjOYNQYAu71ij7jqcgFhtWP/vFDy7Izw9T6fEfMLKcg06WmxvfqdLVbw4jNeukq
 lTbMvfW4AQWdp5XD5KwG4wqN1MG7GV8FUb4rUe9QTYJlo4oPqZIZQ219AXkxsg==
Message-Id: <d1d47b32-b746-42d1-a391-5e37d4e373fb@fygo.io>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
Cc: "Jens Axboe" <axboe@kernel.dk>, "Tejun Heo" <tj@kernel.org>, 
	"Josef Bacik" <josef@toxicpanda.com>, 
	"Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Yu Kuai" <yukuai@fygo.io>, "Tao Cui" <cui.tao@linux.dev>, 
	"Jan Kara" <jack@suse.cz>, "Ming Lei" <ming.lei@redhat.com>, 
	"Jonathan Corbet" <corbet@lwn.net>, 
	"Shuah Khan" <skhan@linuxfoundation.org>, "Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Pankaj Gupta" <pankaj.gupta.linux@gmail.com>, 
	"Dan Williams" <djbw@kernel.org>, 
	"Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dave Jiang" <dave.jiang@intel.com>, 
	"Alison Schofield" <alison.schofield@intel.com>, 
	"Ira Weiny" <iweiny@kernel.org>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Matthew Wilcox" <willy@infradead.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Kemeng Shi" <shikemeng@huaweicloud.com>, 
	"Nhat Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, 
	"Barry Song" <baohua@kernel.org>, 
	"Youngjun Park" <youngjun.park@lge.com>, <cgroups@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>, 
	<dm-devel@lists.linux.dev>, <linux-raid@vger.kernel.org>, 
	<nvdimm@lists.linux.dev>, <virtualization@lists.linux.dev>, 
	<gfs2@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>, 
	<linux-mm@kvack.org>
In-Reply-To: <20260814064537.GA9355@lst.de>
Date: Fri, 14 Aug 2026 15:53:44 +0800
X-Lms-Return-Path: <lba+26a7ec991+e92d19+kvack.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.156]) by smtp.larksuite.com with ESMTPS; Fri, 14 Aug 2026 07:53:53 +0000
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v2 0/4] blk-cgroup: store blkcg in bio before blkcg_mutex conversion
Content-Type: text/plain; charset=UTF-8
References: <20260811064744.1139446-1-yukuai@kernel.org> <20260814064537.GA9355@lst.de>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8F742100004
X-Stat-Signature: er3z7mynuepxd4n6qdj1fuymbhw9e38z
X-HE-Tag: 1786694039-324276
X-HE-Meta: U2FsdGVkX19OmcEnhW370Otrgh0pHvoWAfBA1K2YQjWRTNMiVKiQUuGrlFrE7AZGCVTT8sjQzKXNaAv0J8bRj8CgR6tat+t234DxWfQe6yCufy44sviKQPTNRkuNG2lFlYEmaSwGOr39/XR2rX6k8/lwxqnbsfv4f6ObQ9p/ckifFHF8eAcZHZLZGEek25KG0oGGOBGgWtPE2CWvfrcS/9U8PC+TIGqZi5qf89eBzBBA/wnfawvaX5un+75UgBIDcJddW9Gia/cC8a9jkOfDJSbmDMljWbtwlblyNgv3WuAOpEL6xyxVIhm4YHSCUQ54IHvUsHxFUHyaqqEWTUQBdt1/hGxda5JP53hFL1UR95JlZ/MeBPAD+GjVg1TCtvuMcSp+bkEgZGQmuOSp4GPfzGNTlPV34AAI8ED2GSnHq06nK2qw+E75m9ooQjCgwVIs7Ds8sHVmOPEmDuia7aDOVR6aWJJBhnWbatGz+mB/JD76k9Vwk+hTyjlcmrgochMMCwF/bLVuNSGqxZucqYW/8K+csd9iOBEdTen+aWlKXW4hallHr5POgx9Y/5caoQeZQARcTYi3hO4/cWtQnKUWuvl5RODs+T/0+So3ZnhYuJ2WvnpDoM45Kq+WLweZFleY8ByTHNDAAxuHBnZnUibeJ27XcluwJtsl2OorCRMTbuGdsh4PiRnpkqudAHwxg2Wxx1ElQxpIW63zFlFNiNJuCYmmJByUsM8mqcEGcyB+qAfcAQCI8X1DCXauq6/JuplngS/cn73Ar3KC5Z1CoJY34r/jijUxXBv9pg4Y8K/gDKuQX4K6oEd7IjmnDtoeKO/HDVshgVoMj4t+WDAUkLZtrAAugZYvjhQcagSrlINZwwHTi+e8xkDUf+mXcy6KH6oXXwVXDqD4wwOXK+F2pq/uWCNw/BSUPjWdm3h3XJg3sXNw8IiCyLQ/knNo3DR3MtFH0+2kFAii7RZSt72PrxQ
 bvLvDxkb
 T70C2XcwFeExh6SX/kjJuRiI0vQiqunLS7Rj3HBXEJ3oO/+TIw/CvX6I6MbbUB0qITG/dh85hOfKC0Sv9g/HdebRW4+FDNWxmfLcY+BxKoHQq9Y4BqkE1ue14HYHCiSgpKJOFNqWPaEPDj7of0GGC/qHWe+eUODdpwCOz7eJLtLZRR2DetpAp2q2jb1Nyf7lb1MNZlnT3XrUNUIrkEu6fvL5pZNAHmdjQo3cTTvEaIU/9FhVkiVB+pW/LqH/5ehVy5SsRjMVOz9gCm8y9hgjGFcaQTk0FNzJ23u4s8MybOO/XLmOzJzlpq1qhxooZiPSIxYTsS0CjHWbhwGN31aEiuTtUfov1vFSa7tnlegzqFt8X58k/PIV1kz5fDErxi8+Wd1gZYa81GGDAV/KVH9h3BSsSnjh93wfrTEW9uQJO46xtIaz6tQO6c3zCpCny8j3FX+VA0gqhCTi0yW5uS7KUcgsbeGzcWO38zlVKLZWhywzWTwn4sdcKH7LOmzA2uXNnsbYw0Nlgt+ElM1RLN+cHPWPIKGtOm2wrTDt7KDdxfCfSrn/IMwMLLrREcIkyKfnxdPF28/fY61sk/4XCJxz+UUdTP4r5Ta8nu1uy1sRZNKWLwnwQEZFsKkvv0yJeCGdp5fvf1hzPkRSbjcf/8bumzij6pnMiS0p0VRZtb7GuTGBgbiDwJJn43R5ghpSCkkAt8VQOyOF1pMRriqNrnWYjifym2AFTwai6qCLU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2026/8/14 14:45, Christoph Hellwig =E5=86=99=E9=81=93:
> What tree does this apply to?  I get failures both for Jens'
> for-7.3/block and for-next trees in bfq-cgroups.c and bio.c

Oh, just realize this set is cooked based on Jens' initial for-7.3/block
branch. With the other set that is already applied:

30d0c34b72f8 (HEAD -> block-7.3-blkg_list-rhashtable) blk-cgroup: move asyn=
c bio punt state to blkcg
1aa13cdcc027 blk-cgroup: store blkcg in bio instead of blkg
058ff5f9c8ac blk-cgroup: use a request_queue rhashtable for blkg lookup
fefb6604e496 blk-cgroup: wait for old blkgs to leave queue before disk rebi=
nd
f2690679ecf3 (for-7.3/block) blk-cgroup: factor policy pd teardown loop int=
o helper
ed3105cce735 blk-cgroup: skip dying blkg in blkcg_activate_policy()
415bd622f1a3 blk-cgroup: fix race between policy activation and blkg destru=
ction
4cc0299aea5d blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all=
() with blkcg_mutex
f5098b6bae76 (tag: v7.2-rc5, block-7.2) Linux 7.2-rc5

I'll rebase to the latest for-7.3/block branch in the next version.

>
> On Tue, Aug 11, 2026 at 02:47:40PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai@fygo.io>
>>
>> This RFC remains a preparatory series for the blkcg_mutex conversion
>> proposed in the related blkcg_mutex RFC v2 series [1].  That conversion
>> moves queue-local blkg topology synchronization from q->queue_lock to
>> q->blkcg_mutex, which is awkward while bios directly store queue-local
>> blkg references.
>>
>> v1 made the stored bio association queue-independent by replacing bi_blk=
g
>> with bi_blkcg, but a bio-owned blkg reference still had to be recovered =
by
>> looking up the bio's blkcg and current request_queue.  Tao Cui reported =
that
>> cgroup removal deletes a dying blkg from the per-blkcg radix tree before=
 a
>> throttled bio drops its reference.  A later lookup for that pinned blkg =
then
>> fails, triggers the warning in bio_pinned_blkg(), and leaks the referenc=
e.
>>
>> v2 makes request_queue the authoritative lookup owner before converting =
the
>> bio association.  A queue-owned rhashtable, keyed by the blkcg CSS ID, k=
eeps
>> dying blkgs discoverable until their references drain while q->blkg_list
>> remains available for ordered walks.  The bio conversion then stores and
>> pins the blkcg CSS, lazily creates a blkg only for users which need one,=
 and
>> uses lookup-only access for completion and accounting paths which alread=
y
>> own a blkg reference.  Async bio punt state is finally moved from blkg t=
o
>> blkcg so punting alone does not instantiate a queue-local blkg.
>>
>> Changes since v1:
>>
>>    - Add patch 1 to wait for every old blkg to leave q->blkg_list before=
 a
>>      shared request_queue is rebound, instead of treating root_blkg =3D=
=3D NULL
>>      as completion of asynchronous blkg teardown.
>>    - Add patch 2 to replace the per-blkcg radix tree and lookup hint wit=
h a
>>      request_queue rhashtable keyed by blkcg->css.id, as suggested by
>>      Christoph Hellwig.  Keep dying pinned blkgs in the hash until
>>      blkg_release() so bio-owned references remain discoverable.
>>    - Fold the v1 helper-only patch into patch 3, as suggested by Jan Kar=
a and
>>      Christoph Hellwig, and make bio_blkcg() naturally return NULL for a=
n
>>      unassociated bio.
>>    - Rework patch 3 so blkg_lookup_create() acquires the bio-owned refer=
ence,
>>      falls back to a live parent when creation or tryget fails, and upda=
tes
>>      bi_blkcg when the returned blkg belongs to an ancestor.
>>    - Make bio_blkg_lookup() lookup-only: it returns NULL unless BIO_BLKG=
_REF
>>      is already set.  Use bio_blkg() in the BFQ and IOCOST merge paths w=
hich
>>      may need to create a blkg, while keeping blk_cgroup_bio_start() and
>>      completion paths lookup-only.
>>    - Move CSS online-reference handling into
>>      bio_associate_blkcg_from_css(), including fallback to the root blkc=
g, so
>>      bio_associate_blkcg() does not take a redundant reference.
>>    - Keep the v1 async bio punt conversion as patch 4 and document that
>>      async_bio_lock protects async_bios.
>>
>> Previous versions:
>>    v1: https://lore.kernel.org/r/20260804065313.2092022-1-yukuai@kernel.=
org
>>
>> Related series:
>>    [1] RFC v2 blk-cgroup: protect blkgs with blkcg_mutex
>>        https://lore.kernel.org/r/20260724123037.3004560-1-yukuai@kernel.=
org
>>
>> Yu Kuai (4):
>>    blk-cgroup: wait for old blkgs to leave queue before disk rebind
>>    blk-cgroup: use a request_queue rhashtable for blkg lookup
>>    blk-cgroup: store blkcg in bio instead of blkg
>>    blk-cgroup: move async bio punt state to blkcg
>>
>>   Documentation/admin-guide/cgroup-v2.rst |   2 +-
>>   block/bfq-cgroup.c                      |  16 +-
>>   block/bfq-iosched.c                     |  19 +-
>>   block/bio.c                             |  22 +-
>>   block/blk-cgroup-fc-appid.c             |  10 +-
>>   block/blk-cgroup.c                      | 348 ++++++++++++++----------
>>   block/blk-cgroup.h                      |  82 ++++--
>>   block/blk-core.c                        |   9 +-
>>   block/blk-crypto-fallback.c             |   2 +-
>>   block/blk-iocost.c                      |  12 +-
>>   block/blk-iolatency.c                   |  11 +-
>>   block/blk-ioprio.c                      |   2 +-
>>   block/blk-throttle.c                    |   2 +-
>>   block/blk-throttle.h                    |   2 +-
>>   drivers/md/bcache/request.c             |   2 +-
>>   drivers/md/dm.c                         |   2 +-
>>   drivers/md/md.c                         |   2 +-
>>   drivers/nvdimm/nd_virtio.c              |   2 +-
>>   fs/gfs2/lops.c                          |   3 +-
>>   include/linux/bio.h                     |  26 +-
>>   include/linux/blk_types.h               |   9 +-
>>   include/linux/blkdev.h                  |   2 +
>>   include/linux/writeback.h               |   2 +-
>>   mm/page_io.c                            |  13 +-
>>   24 files changed, 357 insertions(+), 245 deletions(-)
>>
>>
>> base-commit: f2690679ecf3a3151688ebef766dd2512ff95854
>> --=20
>> 2.51.0
> ---end quoted text---
>
--=20
Thanks,
Kuai

