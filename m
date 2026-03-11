Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5553BFD88DF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 03:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FEB56B0098; Tue, 10 Mar 2026 23:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1F66B0099; Tue, 10 Mar 2026 23:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A82C6B009D; Tue, 10 Mar 2026 23:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45DAC6B0098
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 23:06:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C20EE59485
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:06:27 +0000 (UTC)
X-FDA: 84532294014.03.B54EF1E
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id DF4A940006
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:06:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dAvyt5ry;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773198386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kYOYGnrkLB9Ow4Bw65owtN+BtAuCoQOFqB6t3I3SeU=;
	b=p13JPqdd/J3nsb2cm1nCffOKyxrb1v+k0FjSdkakGKPtSdVdvyAwTzqona2Jw6SUog/ANV
	SK4sueUYGncOlIpprUKbHBsIg/dnGzUD4LL6hXPIrM2/WVpcrqPwHomC32oNg8dDSla6ie
	OA6DQo+WuimFDH6tx2VJ7KzUUDd6EXo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dAvyt5ry;
	spf=pass (imf27.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773198386; a=rsa-sha256;
	cv=none;
	b=fs6Du/aY4yZNmMzhj3jO9AJTStRsmfNjX6fHJkrk3tku/VF3blqyt6zFhc5SfYnS5lv39v
	kOvO9cHT7G/1vNCN9RxO2u1Q+841JyWiTJ4B9DyzPKARdU0nSo95kxs3vnuy4aPALM7BwZ
	HJ8mxl3Q7gt4a3jIhYPPYo4MDVq8yu8=
Date: Wed, 11 Mar 2026 11:06:10 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773198383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1kYOYGnrkLB9Ow4Bw65owtN+BtAuCoQOFqB6t3I3SeU=;
	b=dAvyt5ry8mq2RbaSF6G1SFClTulZETLboPrAdgs6rTl3hPpd51q5Y8ivfi5YeZX2Y/YfRs
	Y/7MJMuRB5Zcd2okhZTHVW4/AAtIwwQlk5N+orbzK4lGc7j6yLQl4OPbkJe+DY5oI7oebE
	q/NDsp22PeOcrOI7CjDzWE8E41emAGU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: ranxiaokai627@163.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	akpm@linux-foundation.org, vbabka@kernel.org, cl@gentwo.org, rientjes@google.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ran.xiaokai@zte.com.cn
Subject: Re: [PATCH 0/2] fix kmem over-charging for embedded obj_exts array
Message-ID: <exe5r2q526ym5qcypup73yltv3jqnplwhybr3zwxgcs5vfgoin@t6yj2ntfs7jk>
References: <20260310113804.245647-1-ranxiaokai627@163.com>
 <abDPvjUld-2BTpRa@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abDPvjUld-2BTpRa@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DF4A940006
X-Stat-Signature: g8ea4mdpi7yq6htzbym75ocnifkmr6ia
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773198385-586736
X-HE-Meta: U2FsdGVkX19ej2rn2ZHfjz5HIK5jEU0Uh3OHo5vWmOYa+R8MPzokURxsd8DzYwzNhVDvmNd7GQwGrhVp5PAO+pTt+6Zxvwuv8Zflt8bOqHDTzxZ2WAcat3x2zRgy1Uz40aFRbecSBYuykR0kwzBTQ7WLsWfJUW6lE6dUfRL1QNLRHYFtgWFLYaWO7d2gaMSnY90jdxcm07QoKL+3Sy/Y0zI9KSywQvEjNeQXSiXCgNXfSKQaHzKYbotZEKZrZLaJ6VvLo4SCIdr7rREUGiQOjFz+W2DY1jJApRXhy6JM2GzLxDw2msdUyl4E2LF7blDtk29glULsq8r296L1GHGB69L8icxlUuhGcjZ7reC+NyPpJAPzWZDgmjxGa8kJcWhHqTuxfLsQb+sT5LxImABmKQ6pm7CiAoIptLgYpboAa3dVXVNjkPg9FkJeze2dUh39lzYEZvZePS7b+3cCVohUFiW8weNdzJagw4fg5vW7lcDLIiL1hLT+Aye6uULJzAZAYmtgOCSd1JhY3isMU76FyudJgQWxa8jVzw2+Sy2e7Zv6LPFYSFbEGitk+XtCwLmq8lomR9B/gTlPSz8WVQXiMl2ZQk1DdPi4JFDWp4LPAOOG9f+CH0q6v3zHBpnefMLH9uBU/EWdt1rZ+W4yFu6I2zz4s0bYICvhpBXk0eQ6mr0S5NLYGRengUjHxqb+kJT8GR5m9g9fzinRFKN1Bx4iJDzxHWvw07wuKkvQPb9KA4nkapU3TwUjoISfUYmv72Kqeqpl3dPEbuesuXIgP4LH7icdBaUoYG2CF7ShI23ZqdC2uW6bYhXng6NN0JXiGHfyAe1HIDZpcCFf8y6XupgiIblIM64NbacFZM5UGbX0b2Dg/wU1LbI7wbWiqBMj1qBP3YyQ8yaLn3BpqcGIv2lcPuj+L3bZ1m3/oDnvuBrhTSgdsJovfIyR3yRpHWyypKyJh2d6ILh7jqrYxyqJCqG
 abgKNf3N
 MPYKWk+qZesDaQnEzqtx6KFrlWXFmQpR5/rKXbqw1sM0sLH4AEQyy3UcVlIcGtKlnYApaGGEYwgJSEyLieEtNIUPNZ354jrN91LUMR0NZwGfJ4URQG41w0l0yKHDdmPYnm30mX0MLsOUZDmm0nMWKTJQ1g8bjWPrmzIZFnVEp/+WIFxTbHnjKc/IskpIK0jLg5kWnItqMFGqjqFYBPwz3ItkzquzczPXYPrpBUOlDzulnaWmAp5xrubyWL35OEFbyqE5fkRgWFOuT9+mw896I8tVwicI3CPtRX3awhv2xebagEkTJX5+gNkMxXtM1gmsmIUU/7TnytIJeUPTeNGz0tc1mGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 11:13:18AM +0900, Harry Yoo wrote:
> On Tue, Mar 10, 2026 at 11:38:02AM +0000, ranxiaokai627@163.com wrote:
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > 
> > Since commit a77d6d338685 ("mm/slab: place slabobj_ext metadata
> > in unused space within s->size"), the struct slabobj_ext array can
> > use slab leftover space or be embedded into the slub object to save
> > memory. In these cases, no extra kmalloc space is allocated for the
> > obj_exts array.
> > 
> > However, obj_full_size() always returns extra sizeof(struct obj_cgroup *)
> > bytes for every object, which leads to over-charging for slabs with
> > embedded obj_exts.
> > 
> > This series optimizes obj_full_size() to check whether obj_exts uses
> > slab leftover space or is embedded in the object. If so, only the object
> > size is charged. Otherwise, the extra obj_cgroup pointer space is also
> > charged.
> 
> Hi Ran,
> 
> At first look, I'm not sure if it's a good idea - although it's
> allocated from wasted space, it's still memory that's needed to
> charge objects.

Yes, I've been thinking about this as well.

For slabobj_ext that lives at the end of the whole slab, it seems reasonable to
charge it to the cgroup.

> 
> But for "embedded into the slub object" case, yeah,
> the metadata is charged twice, as it's already included in s->size.

While reading patch 2, I was also thinking about whether it would make sense to
call obj_exts_in_slab() on every object allocation and free for this case...

I wonder if we could use objext_flags to carry a bit of information about where
slabobj_ext is located.

-- 
Thanks,
Hao

