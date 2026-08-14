Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F9DEC5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4455A6B02ED; Fri, 14 Aug 2026 03:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4242B6B02F2; Fri, 14 Aug 2026 03:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359D86B02F4; Fri, 14 Aug 2026 03:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05D616B02ED
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:50:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E67D6403B8
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:50:18 +0000 (UTC)
X-FDA: 85099102116.11.A02B388
Received: from va-2-18.ptr.blmpb.com (va-2-18.ptr.blmpb.com [209.127.231.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0DE0E1C0002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:50:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=fnnas-com.20200927.dkim.feishu.cn header.s=s1 header.b=tMicTUuO;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of yukuai@fnnas.com designates 209.127.231.18 as permitted sender) smtp.mailfrom=yukuai@fnnas.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786693817;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbnLgklqOUcOfZtgfE8qoZAa4WQi1t4pHM8VNSJ95PY=;
	b=AXY7mjAvCEFasOfdPpZxmTGyz1UJJsQPRd9frFRW9hbOqLcPyyBNJ4B0/E4Q3N6posqhS6
	qRbQ3/t7uz1Rhgyyy4uR4AtgKA4ArQQ1AoJbBlEj6ddZaOfYMb4qT2BfGmdMETFWBaev8v
	aNQnzi4kU+rOBTTULWSAz005C25+YuA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=fnnas-com.20200927.dkim.feishu.cn header.s=s1 header.b=tMicTUuO;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of yukuai@fnnas.com designates 209.127.231.18 as permitted sender) smtp.mailfrom=yukuai@fnnas.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786693817;
	b=xHeS2m+YGCsf91gNtHmKY8cFomeHrgGwoCI2NnzNdP+tgzyra2jSKBVG8ZdVb3xZ0Ov7AU
	Y/mv0CgYp3c3lpQv9bMVNpI4/nyDOKNhvkKvqHYcaHMJ2WvZTphdYcuk5S1Bwu35EP+c3Z
	ZxMSU4kIsb1HlWgQOg2USvBZ3AQ1bTA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1786693810;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JbnLgklqOUcOfZtgfE8qoZAa4WQi1t4pHM8VNSJ95PY=;
 b=tMicTUuOiAnfACj5gsLu2EuwligrANMVk06bL6KP2qysffPuym9ME8OeJa9s1ryfyvmDGz
 VbmjVCDrQ3uRh27kSYaMU44CusVoENs9K6NgPFUy0AAcxcdVvfbsDixLuOKbWeqT16/Usg
 hRg+WK8ne+oUiKyVqHULQ154YZzQIemikjiv2PLp2dA3Btk0BiOAGf9/YwxOfqE1dbCD4Z
 4PCVF+zpQPVGPIU+I+rd6ImD0UtsTq9NQvK+7YGbloS6RExH3e0ZiynKp60W3taB97+b1L
 h0PAPy9+eZKu/lQbLDZ6dya3I6HsoA9pRMSZFbH43aHO2A24LWWgj/XSp2BKLQ==
Content-Transfer-Encoding: quoted-printable
From: "Yu Kuai" <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260814071232.GA9784@lst.de>
References: <20260811064744.1139446-1-yukuai@kernel.org> <20260811064744.1139446-3-yukuai@kernel.org> <20260814071232.GA9784@lst.de>
Content-Type: text/plain; charset=UTF-8
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
Subject: Re: [RFC PATCH v2 2/4] blk-cgroup: use a request_queue rhashtable for blkg lookup
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+26a7ec8b1+a57c7e+kvack.org+yukuai@fnnas.com>
Reply-To: yukuai@fygo.io
Date: Fri, 14 Aug 2026 15:50:04 +0800
Mime-Version: 1.0
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
Message-Id: <f7350050-062a-4ced-9396-05ac33ac3e60@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.156]) by smtp.feishu.cn with ESMTPS; Fri, 14 Aug 2026 15:50:07 +0800
X-Rspam-User: 
X-Stat-Signature: tjm83wao5dwz1hosmn7eeinmiya1brhm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0DE0E1C0002
X-HE-Tag: 1786693815-966643
X-HE-Meta: U2FsdGVkX1+7I776kIYFU7pwO7oyrC4spooH7cvTlZpXBD5J53O22oUGtlZ1fszmlBAZbYhYYHTl2a1/xnasQpoYT661JTGbfr5LxTxUrEZwN4wkTFFN2L2/h2rcNWAn5mfz31/DO4JbYBQuMB500Ewog2AULwsf5Xu9LX2EGaz7lO/9EdArooumrCA0LVCoVOWjudq+7WWq0wgU66+V2d+lMsVwpeoOnuJaZHMp+kx5mhTB2wYwE3kc9HwxHieRGVwVWr96GtPW3ZFfQ0+pMTrPO/EFWAAKo2EaWuZGMBHng52zjrKJ8UEJaMRS4l7je5TIUurjhnPAeBGa8+ZWT8GqTFnXywJO/l3FBMsYLy19A9lBcjvKVDmirMaBOTqPGcg1ScM4nHPneMl/tfFLkXNObJgmiVIiWd8/kybFP6PZKeBO14x3GQOD/KxnrOajk0Qb8/a9YRFx26GKhLxAfkOtxnGvlD05ty5aulSl7ac/Vj6ZQoKNnBzAcLUEco1s0i3mXC1f2gN8VOpqvA3P00CiTlwoxKE3AmPO99+6l5zH/2BNtNWbpm6IskNp6n2JROwHW4Rqja6I9s2Wkw1fr9xILZ8vSX/JXpbVBigps54m9knKNwKEPl3naVYzMlpvrMottROnGswgGiuO6TdoCThjfmYtO3DmrSFuBOZlBJdX1jKu5GoFZZwqbb/+sKYf9ALWFzM3SLQbq+g7WsjOiM0TVf7wallyeHLhXWCXZbDuSAySqaT806sk4MPG2ZZERYrfiDmbLYMn2MKx/G+2MIZO4WrQG74TjzXvuDzfw2d7qJt/07MJYl0boNBHSmNqR+Wm8PXNwjkcQn1TVYG110YZYtij6RC6EfYUG30jd1TtQq+hUATrovs9eqkAW+tjziRJb4SCT4/oXdU5Su/JkO9kmVryqEwN4PFqgV0prgVUKnYSxizryB0cazy5PsdYnqcQnrs/Oblmhf0k/YW
 GldOfor+
 6MacpdSOzKRJJhdGhZ0G1tBWc570t2D/7QR3D6sOQm2lAb0EqITXoCe6EWvw8oG1ApxFBC6DmOn5KBfRFM21jErowZfC2vpx+jH4FgtQqcm5R6EDSyMSHddRm/zwipDEVoCubw+brwekB4bnO2I76k3qILr0k3x5HTeOrNxLR3HMtjor6aKpep/biSa53FAlTKHGshnFtMk+u5HapeLr1xLZUBMS1t80iaFwQsl4Uy/Nx6hxA/2pB8yZPcjnKNW2uiBMc68htsx1tipQdNu8ITuftqFwODJcvjtE6HzkXvIw9FXQnNi1lCNwphyOY6IqO7ywF/JfTBFXMX/Th0bRzJtzLQp+Nq0rr2WDPc5PLCLANp17sWP6Q4TACSrpgpF5o4KdGB6vA4B419YfpKNxjrKZ8V6XhoyffW1mGG4dBGQYFuWV9lZiguilR9bn/piveERa9RtSS+KxNWgL/6XfGCGTGyNjLR5FgaPVHpZO/nczfGhDZf8Sf/dCwBYpzOMalleR/PhOlEE28S8w9oGQBonx38/5e+U6nm/ExVYng14T/Ho1SpXiMRTIpDRkKq7IZ13wgAwGd8X7HyX/9geRFNNsJrnGm3WaLF+QsfIR9RcLB2EFZbw0vAdCX8bCa2kVF9N80HDDMCTY7MNjfYlOfGaonjLbPegz9P9OcppVnxFQdIMX13x3m1moUA5CjbZTyicFbP6uwAUJbaXdse06kBg7S+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi=EF=BC=8C

=E5=9C=A8 2026/8/14 15:12, Christoph Hellwig =E5=86=99=E9=81=93:
> On Tue, Aug 11, 2026 at 02:47:42PM +0800, Yu Kuai wrote:
>> Keep q->blkg_list for ordered policy and scheduler walks. Initialize and
>> destroy the hash with request_queue, and remove the radix-tree preload
>> paths which are no longer needed.
> Are these fast path operations?  Otherwise we can walk all rhashtable
> entries without an extra list, but it might be slower.

All users are from sysfs/cgroupfs API, I think they can be considered slow =
path,
however currently spinlock is held in these procedures, I think it's better=
 to
convert them to blkg_lookup based iterate after spinlock is converted to th=
e
blkcg_mutex.

>
>> @@ -191,10 +198,15 @@ static void blkg_release(struct percpu_ref *ref)
>>   {
>>   	struct blkcg_gq *blkg =3D container_of(ref, struct blkcg_gq, refcnt);
>>   	struct blkcg *blkcg =3D blkg->blkcg;
>>   	int cpu;
>>  =20
>> +	if (!list_empty(&blkg->q_node))
>> +		WARN_ON_ONCE(rhashtable_remove_fast(&blkg->q->blkg_hash,
>> +						    &blkg->q_hash_node,
>> +						    blkg_hash_params));
>> +
> The list_empty case is for initialization failure?  Or can we end up
> with that by other means?

Yes, this is for initialization failure, blkg_alloc() failure after percpu_=
ref_init(),
or blkg_create() failure before rhashtable_insert succeed.

>
>> + * Lookup a blkg for the @blkcg - @q pair, whether it is online or dyin=
g.
>> + *
>> + * Must be called in a RCU critical section.
>> + */
> Please add must_hold and/or lockdep annotations for this instead of just
> a comment.
>
> Also maybe mention that this does not acquire a reference and the caller
> must already hold one?

Perhaps it's more accurate that the blkg is pinned by IO or caller already
hold one?

>
>
--=20
Thanks,
Kuai

