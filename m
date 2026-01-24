Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB857D715DC
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 09:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0437C6B059C; Sat, 24 Jan 2026 04:25:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B616B059E; Sat, 24 Jan 2026 04:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93696B059F; Sat, 24 Jan 2026 04:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D3A5E6B059C
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 04:25:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42EBC8A921
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 09:25:35 +0000 (UTC)
X-FDA: 84366324630.17.3FF0F94
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf27.hostedemail.com (Postfix) with ESMTP id E21854000E
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 09:25:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=C6DPt9Nd;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769246733; a=rsa-sha256;
	cv=none;
	b=kc8PE6m38n7TeEJF+zjILxdFKdnWr+/UqA0Id6I66DQNUeZchKoawaOjRo3T9R2Sp6mDpK
	7+zze/qPCaTiRpYanD2QqJm3JCurTrFHcAnoQVrwoOVgw8yyUWCf230dgATQDmx0EvIIIY
	C4GCOmcGkDJaso54B3qctF4+AhVV1jw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=C6DPt9Nd;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769246733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCoUJ1M29g2nJIrmBIjAZ34udgG8JTU6pQFm2HI3HyA=;
	b=rHBCJ4oEsF/C0fXhyccFNZPSMUgrLbiF183UUKiWCq2xwjULFE8V+D86v53OQFkGuq+FHp
	DT8juQ4VCvyN6vOIYN3+X012EOdy910VcNEGfO5jLLEiglAkHVg1S8x4XTSNhOt6gAJA5F
	gNgRWgzoedlWFYtzNSmTxM9eNgFS4AA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769246730; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=kCoUJ1M29g2nJIrmBIjAZ34udgG8JTU6pQFm2HI3HyA=;
	b=C6DPt9NdDIiu+Vzx1OjChL/IkoH+PW4bBgtK1m/va1XVYFMEKEQdaPZMBUVxcRYtIBtstpDW4NhIOe0EBJETyNLqu91hVBfN1Bp9SsYkWLoApOfWEsMfIVg4l7LVVUgsDZJNkLHWZ2J5FkVN7wojq1cX+UKgOR9DrxbblyILxaQ=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0WxiaRId_1769246728 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Jan 2026 17:25:28 +0800
Date: Sat, 24 Jan 2026 17:25:28 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Christoph Hellwig <hch@infradead.org>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 3/3] net/smc: optimize MTTE consumption for
 SMC-R buffers
Message-ID: <20260124092528.GB85316@j66a10360.sqa.eu95>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-4-alibuda@linux.alibaba.com>
 <aXOLR9GxwuNz3Ddc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXOLR9GxwuNz3Ddc@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E21854000E
X-Stat-Signature: zxm777sk34aeoh5he6yacyn9ymcz3ujz
X-HE-Tag: 1769246732-65351
X-HE-Meta: U2FsdGVkX18yFjsFpIiY+7/nhCHseEQ/ZK9ShkZyU0hvLoBqwNWw86Ug6uD8Tc9NIYuKp3zlqzzEMFPKj2ILnIc8lfYiVKfSfbDsDrZ8ctPwBxoL94soE60Ol3FrOi/UwIWBxLB+WznsBN9L7gKhkXx+Zo2LV6AaYJwjyeW4NU9DGvCCX8fVCoL9DOt3YvKEG+isEHvcg5iNUzG+3WuyUp9RdAQUwaKiL5AdmM2Rm9hoa7/tEF/ysKrhamEFd6XPSVeolh0YnTv1RuP9fkwUnCSDMkwIjdshtI304wW+WGqjcJkrrDMqMLigLkhP+gVo0sGyFLIfxFPj3QyqRA0yibUgAHEYo4xSzVVhOxHzlP3fi/hCfWuofWqYOmgpS//t6J3TU7Bh2d2wZogSsucGlynA196MVw7UCxJsw4Ubo1T7grmklP6oTpiJTfch+um9KE56n3gkyRb9BoOEOTYZNHDZaF5Kxf04ZD+bfwXuI6tc1ODmYjiYQLLPkk45QL8Tl0v6iyXUbr3tCRbk3XLgDXc+xb0YWLdpQdbnbAcoo20zxmLatGuADfyLryWZWFNZIwMkVSnY1+uoi80za2tt356VbdDiYLEiIigTOgr17972cagB7xMHd+2i2zKIaqIB0yfV+qe7Z0321K1aKrLY2Q4U36A3wq47tYzpvFhykqghvI3aWdGY5JcIygY+9rSUKjPxcOtSJhY1ZxvOevmYuoqDfmoAFsCrhT9bX+8cnF85xipd3Aj+sdmgach4at0+f19Su5GMJIG5NcH0AKxJciu0hhr1Y12VtNl0tWGytGHA7OPlKtPmnojHDXKilKplokKewO7HJUL/ZHmbFMYkFh0lsafO+/an4q8LjLkaCUli857b8wYNOpAp/H90vuSV35kvSOjpwzYeiEpg6wAHOF7jxF9ujROyBI7mlgFTLG7iIMyOFV1ImiAlcHxdOji90uH+BpP+8YA1731N0JI
 aMrnViLo
 aPcod3/6gsvrNPFymVx4i1CT4EJ3InR+8/Z7Qvy38pfu0xo3WZ2jZ7MFktTMcTwKKAnXkz+N5FhP8GOhs96KZucBEN5D5EV5WfZ4+MNhTD+CO4sz5qwPNMkXqys1FA1KBeLhTM3K5fgrjggZoho2mUDxLeX9wFVie+SGQcEGQDTvQRzmujALVN2VzQa3IponBUqg6ib7Ka034oXhksYBh2UT9tiy2/rhRvl1zNA1WLO0m/WY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 06:52:55AM -0800, Christoph Hellwig wrote:
> On Fri, Jan 23, 2026 at 04:23:49PM +0800, D. Wythe wrote:
> > +static inline int smc_buf_get_vm_page_order(struct smc_buf_desc *buf_slot)
> > +{
> > +#ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
> > +	struct vm_struct *vm;
> > +
> > +	vm = find_vm_area(buf_slot->cpu_addr);
> > +	return vm ? vm->page_order : 0;
> > +#else
> > +	return 0;
> > +#endif
> 
> You might want to encapsulate this logic in a vmalloc_order or similar
> helper in vmalloc.c.

Hi Christoph,

That's a great suggestion. Encapsulating this logic into a helper like
vmalloc_page_order() (or similar) within vmalloc.c is indeed much
cleaner than exporting find_vm_area().

I'll implement this helper in V2 and use it in the SMC code. Thanks for
pointing this out!

Thanks,
D. Wythe

