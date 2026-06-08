Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD76CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BD8C6B00A0; Mon,  8 Jun 2026 07:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494C26B00A3; Mon,  8 Jun 2026 07:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2196B00A4; Mon,  8 Jun 2026 07:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9516B00A0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:07:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7C55C33F4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:07:38 +0000 (UTC)
X-FDA: 84856469796.08.F58F2E8
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3EC5614000A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:07:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=A0Mp30cD;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780916856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uG90aYSeh/H3DujcabP88VD34ebcZah8ySgmQg5FsGE=;
	b=vwsGvyKI+rUbcIOEzsVzUf/QBwW0ORQjXmeDGZJC54F7u660MsF+aBYGhSeSrIs6aeih5A
	a9Lz/WaJpCyVeTfLJLL7CbJXscGWb9n5Wz3HIXhs+NDe4Cvr6CgdGiFXg5Yb0JH3U8SJUu
	n+W/rFq71qzMgY+cnQSu0cE3ZuQtYCQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=A0Mp30cD;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780916857;
	b=QUUljFOpZ4TDdloLYvz2FgsQQ8ZZMg6BV/YOdbRSfltGdpqUgVsBnS7iPQJYrqPrVRxmC8
	n2TPXXutCvpq5mYhZHSe/871iiRYVKL6vVxAutnx+sEcua9hUDs3S0y5r+GpmYffJf47Aj
	/ToKZawLCVTOqtsQ+Ur4RDpWYOA3Fgc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uG90aYSeh/H3DujcabP88VD34ebcZah8ySgmQg5FsGE=;
	b=A0Mp30cDKgYORhoj7WPHdEiyd5t06YCo7QjLgjieghNgf4hjJ4R+gvmI8ZDNr+mR5uxHkl30+
	TB3ZO/E/Etxp8gAj47jCon49EPReSQybkAkwJD3rXIrt680l/IvYsCszZ8vWS7V16i2t3Ey/BDK
	WlvaQDJk4dONS98eA+OosIc=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gYpvs36QJzRhQx;
	Mon,  8 Jun 2026 18:59:37 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id 2425740561;
	Mon,  8 Jun 2026 19:07:30 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Jun 2026 19:07:29 +0800
Subject: Re: [PATCH 02/10] mm/damon/core: add damon_new_region() debug_sanity
 check
To: SeongJae Park <sj@kernel.org>
CC: Zenghui Yu <zenghui.yu@linux.dev>, Andrew Morton
	<akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260607165305.93321-1-sj@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <f8d25003-357d-cd65-dcf6-568dcbdc6412@huawei.com>
Date: Mon, 8 Jun 2026 19:07:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20260607165305.93321-1-sj@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.219]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200017.china.huawei.com (7.202.194.83)
X-Rspamd-Queue-Id: 3EC5614000A
X-Rspam-User: 
X-Stat-Signature: c36b7axpsaefk5xsmubz14qh1fyf9m9c
X-Rspamd-Server: rspam09
X-HE-Tag: 1780916854-897502
X-HE-Meta: U2FsdGVkX1+X8r6dGcKqvsW/mAtEeHP7Ljy3zyQjJmBAQ5UFrW52bA8WfJPQ1ylIQWb5QTC7T4tyI1aRZGRaui2RSM06Lu6mJpTOXHnSkxcBn+VdB6LbWENH76ycb/t+wOPYrspZwSh+AuHv7W1UY+aAYEj91coBYQmO2l/Iy+J+ghZjdwUtjj+bvH8BFLM+oX++U/wq+ydZLOX6q21e0w2vQcTn2PVgoc/qGhJnddA4Dca+PHef/9zMZ1QfdQ7uxEy3NXqhYxdqWMmbRiTJ7aC0R0cUD8xr10p6Ni6s7rbwliYX9CJGW56SJtZWchJQKGTKHNNitnGqWr9xfoPzx1Ag6vwqTonD3egogmVIVotHelQMDxa7CvqiBIpw+8KBEXjELUzr7VClY61hdRoPMF1NSJybaI0yU7VY4nOHK4y+XLfYYgKZJy10A/YU7uLX/3Qpzlirm1ZHlLGJZKvpr1r1D1GXH7xdTmNc5ESE/KtzU7Agwxq+UGjNmEIJZd/oVhrt9CGHluNVIsxc0IfvOLTfxdUsv6Z5w21a+maX1B1IvdTA0WLmf6Qlzn3HZ1/GC4oXtNz9uft5du3YGce/TsDfSdokUYd3Ri7i4pSHc9V4L2VALTQRN0VvFxrJMoDP2i80WhoaMsvT9qIyHBjax19A6zOLU0hvxHJaZVrh5d9n7MsbB9PD3EsH6+ICZGtL1P/bUe9CY5qoQ6utHEXOchZJXicvyd+P1Dhis78E6aci/MN3qFcur5ZUxxa5RdHSM8XHgSxD2dWf1Pb371VOx5ilb20N7G4qTbAym1DuedrmOIYjsd0nrlJsPKvT+RrtlrDXPyO4Oek0SCz54vplwoRqZWsokucA+JQJa+6jn3npDbsRCqigEL3Lvo23N/xcsriO9SQSuC8CaLelhQK37yHptrRUTt8r8n6Pfi/Fy1DOP/LkAsU6Hdesk9V90DlY02+Fyd89+erJaAMFgj4
 BXte2Vgd
 zCExP9KKVK4s6qCSrxiK7VoAWNTavpBy5mAaOdzTFKqjLsaEAh12y2jig2iWigAIRxNbGuj+J5Qx2G+IfQMdB17Wme9ZR5Z19igAM5ku0Er1R0kjfKO+Dmg/QExys2ofaMnyAVPy9by9AaLWAOOGFWgI+uSyVh/KKUIvzF8d5xc8shxRt9U6OarjEzXOvH9LjGcuX9VcME0qdCCzOJwAwDM9HCKkpAuyZlr3SkR8zNoz688ZYRtKoouJW03awU1/DKqIvnqY1NEXtHUjh5z/icfFN4WtciGuQovUsHEZZpkD9Df6SFmDhKg3Jtw6VAhIRmJ2GxxEPSqnJNmOHYq0gdZICXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/8 0:53, SeongJae Park wrote:
> Hello Zenghui,
> 
> On Sun, 7 Jun 2026 23:24:27 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:
> 
> > Hi SeongJae,
> >
> > On 3/6/26 11:29 PM, SeongJae Park wrote:
> > > damon_new_region() is supposed to be called with only valid address
> > > range arguments.  Do the check under DAMON_DEBUG_SANITY.
> > >
> > > Signed-off-by: SeongJae Park <sj@kernel.org>
> > > ---
> > >  mm/damon/core.c | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > index f1a97e85824ac..0c1353164ec81 100644
> > > --- a/mm/damon/core.c
> > > +++ b/mm/damon/core.c
> > > @@ -109,6 +109,17 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
> > >  	return err;
> > >  }
> > >  
> > > +#ifdef CONFIG_DAMON_DEBUG_SANITY
> > > +static void damon_verify_new_region(unsigned long start, unsigned long end)
> > > +{
> > > +	WARN_ONCE(start >= end, "start %lu >= end %lu\n", start, end);
> > > +}
> > > +#else
> > > +static void damon_verify_new_region(unsigned long start, unsigned long end)
> > > +{
> > > +}
> > > +#endif
> > > +
> > >  /*
> > >   * Construct a damon_region struct
> > >   *
> > > @@ -118,6 +129,7 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
> > >  {
> > >  	struct damon_region *region;
> > >  
> > > +	damon_verify_new_region(start, end);
> > >  	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
> > >  	if (!region)
> > >  		return NULL;
> >
> > This can be triggered with
> >
> > 	echo Y > /sys/module/damon_sample_mtier/parameters/enabled
> >
> > because both node{0,1}_{start,end}_addr are 0 if people forget to properly
> > initialize them.
> 
> Nice finding!
> 
> > This can be avoided by checking the parameters right
> > before damon_new_region(). But I'm not sure if this is the correct
> > solution.
> >
> > diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
> > index 775838a23d93..4a5d3fb12e1b 100644
> > --- a/samples/damon/mtier.c
> > +++ b/samples/damon/mtier.c
> > @@ -118,6 +118,9 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
> >  	} else {
> >  		addr.start = promote ? node1_start_addr : node0_start_addr;
> >  		addr.end = promote ? node1_end_addr : node0_end_addr;
> > +
> > +		if (addr.start >= addr.end)
> > +			goto free_out;
> >  	}
> >  
> >  	region = damon_new_region(addr.start, addr.end);
> 
> Because mtier is just a sample module, and this doesn't cause a catastrophic
> situation like system crash, I think this is very urgent.

I assume you meant "this is not very urgent" ;) .

> But, given the
> simplicity of the change, this looks good to me.  If you'd like to send a
> patch, please feel free to do.

Sure, I will send it out shortly.

> 
> The real problem in my perspective is, however, the fact that DAMON core is
> not providing a central parameters sanity check.  As a result, each DAMON core
> API callers are implementing their own validation that often and repeatedly
> turns out to be incomplete, like this.  I'm working on such central sanity
> check and further refactoring DAMON API.  Some of work in progress [1] is
> available at damon/next tree.  While the work is ongoing, adding this kind of
> additional check should also be fine.

I do agree with that!

Thanks,
Zenghui

