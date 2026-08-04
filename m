Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6552BC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F03B6B010A; Tue,  4 Aug 2026 11:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0D66B010C; Tue,  4 Aug 2026 11:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6296B010D; Tue,  4 Aug 2026 11:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 456AE6B010A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:31:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D30BB1C02F3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:31:28 +0000 (UTC)
X-FDA: 85063976256.05.1858252
Received: from va-2-52.ptr.blmpb.com (va-2-52.ptr.blmpb.com [209.127.231.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5327910000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:31:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b="Ugpcwxw/";
	spf=pass (imf05.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.52 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785857487;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LX/Wg0tks/cc/fTlAyp1t5QsfNTLQnLsZm1iWKs61Hs=;
	b=2TEw/qqYowSWLBNeC6VkWQ2KalLvskFbILnW0FARdGANqnLOBGz/46aHNFIp0TpAXFPxDx
	dYsLxVu2YE6Fj1FcB72zwBa+nPWBhWugFPOkcYFoJfTnT4rE4K0Wy2Ekw+jxokINQizhaM
	1nr0x9tmfa3pXXTRlhRzYGYQvW9Asrc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785857487;
	b=cxFDbIPmHtEy8XZzui8iwiVN+WleHQ6QEOrrn2xqvA/wVr1U0zHX6hJmztsdbomQgNn1PX
	Hx6ER+5+7/wQNC2isXAob7x+wC+4ytcLVdDnSmp+Nif/eACHkoTFF/OIbDnlCtlVJ9J5IH
	PXDlQ5RYyzmmnAzaxJSpzudm/XXzIR8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.s=s1 header.b="Ugpcwxw/";
	spf=pass (imf05.hostedemail.com: domain of yukuai@fygo.io designates 209.127.231.52 as permitted sender) smtp.mailfrom=yukuai@fygo.io;
	dmarc=pass (policy=quarantine) header.from=fygo.io
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785857476;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=LX/Wg0tks/cc/fTlAyp1t5QsfNTLQnLsZm1iWKs61Hs=;
 b=Ugpcwxw/MLB06WtiIAfB5P2nWUYcfZ1JBLSFiNEOIwJj4O/tQycy8y5B6ZDE2QFMTxHmCm
 y4+cZEryiYE6qw6X7oG7cJ+HuK1He/MbW1nTH3zQTSwXdgAT+1ob/SrYV0dRlVMu+LSOXb
 wqj0zE16Y99BiUMi6B3NO0wF5E5j8m9qu5+DO+OMFXILwfPJOOxy+Rxt+OI+Lev69zr87e
 y0UxF8Vd2Z6S/9Kg6Sc0mmHHafyf+VSlABinDkKjA95ySdsP6Y47IY8Guydj4lPB0FIo86
 o4tzkGCBQigUXRpCKnUoXciFpD3GFxlup0RSQy6jZiSqEOHNy9KyK0vVgofldw==
Date: Tue, 4 Aug 2026 23:30:55 +0800
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-3-yukuai@kernel.org> <a677f581-344b-4d99-846d-a00801e26033@linux.dev> <20260804133208.GB8078@lst.de>
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of blkg
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a7205b8+6b76ef+kvack.org+yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260804133208.GB8078@lst.de>
To: "Christoph Hellwig" <hch@lst.de>, "Tao Cui" <cui.tao@linux.dev>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Cc: "Yu Kuai" <yukuai@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, 
	"Tejun Heo" <tj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Jonathan Corbet" <corbet@lwn.net>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Dan Williams" <djbw@kernel.org>, 
	"Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dave Jiang" <dave.jiang@intel.com>, 
	"Alison Schofield" <alison.schofield@intel.com>, 
	"Pankaj Gupta" <pankaj.gupta.linux@gmail.com>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, <cgroups@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-bcache@vger.kernel.org>, 
	<dm-devel@lists.linux.dev>, <linux-raid@vger.kernel.org>, 
	<nvdimm@lists.linux.dev>, <virtualization@lists.linux.dev>, 
	<gfs2@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>, 
	<linux-mm@kvack.org>
Message-Id: <0fc5dd22-7a8d-43f0-8555-d2ca966efff6@fygo.io>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Tue, 04 Aug 2026 15:31:03 +0000
X-Rspamd-Queue-Id: 5327910000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: reurff3zk4mb181quzqauj8m1h6b3rw6
X-HE-Tag: 1785857486-153193
X-HE-Meta: U2FsdGVkX19+3hRXYavC9J3uM/1QJhCYl88FnSPxkViWzgC3ZhIdfU6km+tFsUV3VnnJqrlnubeNRvoqIuRpgIDCa+pRFOlk4XMTukO1LCnZjZEqqtkxLFC9z6hxfhszsC5wovYbwtLoNf7vOL/sIO6zQk+/DZxkOKkNaEaedS6LLjfXXiQGv5GP7RtbRX0RoMEJkPBoZYyTlBj8A3FIFr0CiSvOV+u1XLYTswULOYSRjoY26/GkPeWlyjgafPqenE9a+g6hLyxc73Kgz+EJT7FsncgswgKjPk13YL02XKWZz4SNJQAv+wjNAoyA92YCE6IoM4KiB1h/f4/DNAXoLFyk46LmLy80IYaAOEgJ1nfiWYSiFt0032n+4dx6gmB5mOcAkKBoeFz1XyOYjXkBv9IXfjZWQhM/8FDIlAOwOoetjCa0HINMDk9Uk3Jfdb9ABV3Oa17yksDqCfseyTfFRkXRxRFoyc0hXJ7HCLLjMjPnLkZrvtM5vOV+VNxlVYsRZ7YwoiesaJqc7LwncaJUvfV0BH2hCpOzLptcxClFaH4PA0qRE+eR7GRy5P8z/iWla103vzOYlvAagaq6c45xYFljj2Ud4EdwXQUzhkVIni8rVbieALK42hV6qSu7sYYGnjwOctmFUrHP5iHN0e23e0gXAtL4K6ZUfbtU12XIEvnMx29icINLCexBqMDWvCGdlMh+jq36wLKuLlmrnBtGNfmC1qJWwHeb70k/bhLnINU6wpurTGps01lxWV91GPLu4KWw/ScnA7EVWg/32ufE4H6esrw+TMs8m8CNQuQUI1W0gQR+jnCe/EqpUnnjhHQmeLlEdruDL5y1oDw7ol00vk3BinDVOXm0ZdYAt3n8x39Zga1G8nuKJS1U/e+8naD0y9r2t11SCcgYWtreMI3CewFLW3L6ilvXYV+hsB7u1M7SDZPnw1OhYTWk8EyQ96RfR2rt5shYylSBTorG9/z
 EnE41/RW
 9eSYVaT2K/OX2vIfJieYRClp3kpdlLjvwLhsTRybmTRTvKDAHLRqWaUt2FgCn3VspYym3mkLuIMFsv3+gWM0Qv/ZoapxvIkPM1qZrW8CTtJk8str4Y2karJua2Zuha8Eaf9q7VTQgS8k3zP6VGl8JXcOAb8Fmqlr/DK/OkP+XAPr8b3E/9D1sHmqS10gD7eOeDqy0BiOtpjM/dWSY3aAkdNFTty/kJtwQaLJXUntFE2Yu4kEivM3ltIzfSi9yM7+d8uPwUXZNpxohz0AnyFvWBDd+IbLwsKjS/XZC/yu1RwVn07Fbh0N5a9hG0igNdRLW4M5Jv0uK2UTeNjqvPHRy6YbTn5DEbinNpWiXcNGWd6Ej7ut/HwXZ3IkoBxpQXEMCYSRe9ieP9huVIw325Aa1mOIi6i8IM7Zqa8D+oeLzz5gz2YVipt/r+HNtPj2qAAIPnYY67Psosr/qelb5Yz4+3GR7p2fR//e6D8/yhxTv6tiHY9jlo9T62x47mxbNgg7kSDrTLn5ZgVlKIuv3lrM8ituvsI3nniN8Vf5iS2OZ90mshezGFT6500TQ8wWEDsZOHe8YY1GCXNeRACCcpY7eRHacKOlv94uUzHJK0ZvVJb5oYOej7POZTI8ErFhgoWTIMwkp2vyr5vdXA8U3clXTr6mjiKXvBZj02n/g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2026/8/4 21:32, Christoph Hellwig =E5=86=99=E9=81=93:
> On Tue, Aug 04, 2026 at 05:19:24PM +0800, Tao Cui wrote:
>> While reading 2/3, one spot in bio_pinned_blkg() made me wonder, so I
>> gave it a try =E2=80=94 and the WARN_ON_ONCE triggers every time for me.
>>
>> I may well be missing something, but my worry is that the bio's ref on
>> the blkg keeps the object alive, not its entry in the radix tree.
>> blkg_destroy() runs throtl_pd_offline (which only schedules an async
>> flush) before radix_tree_delete(), so the queued bio ends up dispatched
>> (blk_throtl_dispatch_work_fn -> blk_cgroup_bio_start ->
>> bio_pinned_blkg) after the blkg is already gone from the tree, and
>> blkg_lookup() returns NULL.
>>
>> I applied the series and wrote a small reproducer:
>>
>>    - null_blk, cgroup v2, a child cgroup with io.max rbps=3D4096;
>>    - a read issued in the child cgroup gets throttled and queued, pinnin=
g
>>      the blkg;
>>    - migrate the reader out and rmdir the cgroup; the queued bio is then
>>      flushed after the blkg has left the tree.
> Can you add this to blktests?
>
>> Maybe keeping the pinned blkg pointer in the bio would sidestep this, so
>> the lookup can't miss?

The problem here is that blkg_destroy can be called while blkg is still pin=
ned
by blkg_get, in this case remove the cgroup directly remove the blkg from r=
adix
tree, that's why blkg_lookup can't find this blkg anymore, and the extra bl=
kg ref
is leaked :(

> That would grow the bio, which we try hard to avoid.  I think the way to
> avoid this is to have active/passive refcounts on the blkg, where an
> active one keeps it in the radix tree, but a 0 passive one would prevent
> the caller from getting a new reference to it.  The users who rely on the
> pin for the I/O completion path would then just keep the active reference
> and use a pure lookup without getting a new passive reference in the
> completion path.  This would remove the need for BIO_BLKG_REF which
> feels a bit kludgy and eats up precious bio flag space.

The problem here is that remove a cgroup can also remove the blkg from radi=
x tree,
even through it still has active refcounts. I think this can be fixed by ch=
ecking
the cgroup online_pin first, if it's zero, we can search the blkg from the
request_queue blkg list, where blkg will not be removed until blkg_free_wor=
kfn().
What's better, if we can convert the blkg list to hash table with key as bl=
k-cgroup,
it will be much better as we can lookup from this table instead of blkcg ra=
dix tree.

>
--=20
Thanks,
Kuai

