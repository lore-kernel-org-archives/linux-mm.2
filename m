Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68F30E83EF9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 13:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 875906B00B4; Wed,  4 Feb 2026 08:44:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8236A6B00B5; Wed,  4 Feb 2026 08:44:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721A96B00B6; Wed,  4 Feb 2026 08:44:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9206B00B4
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:44:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEC0EC0339
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:44:58 +0000 (UTC)
X-FDA: 84406895076.28.4FFA999
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id BD23D100016
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:44:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770212697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UCualjpzLBrdwCPJv0gUmlcf7nSDxWmIfVGRzvs7nek=;
	b=V+cCHiPAmVUemoRpz9P7dfAlwzpTY3ENTqqrQhuOZANeFGWI5OjDrdVzA/XB2o/nd3vuqK
	6znJPqumuyWH1tbAgWID6F3gJDwyouZxa8Gqt71BHO2uy9sG70/cY+lL4GoUt400OIuuu3
	BKjTmTSxmcuVA/LuNXIciBFlj3Egv1w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770212697; a=rsa-sha256;
	cv=none;
	b=mb8J9L1qtJagRYw+iWTGi6DefCg0GpB+GbyuHwaSlFrV8VzOz3YYlh4jRJwicYvAPMfBWi
	ZELViAjAJG6lOdDnr3SUTVlWAQD+1HP3xdeuENmORMwMUWNTGoFQbLYw/OD3asDw7FO9eP
	yuWRsK57jigPq8AelweCokCA8NMM6m8=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f5hQX5fT2zHnGkY;
	Wed,  4 Feb 2026 21:43:48 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 3273A40086;
	Wed,  4 Feb 2026 21:44:50 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 4 Feb
 2026 13:44:48 +0000
Date: Wed, 4 Feb 2026 13:44:47 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Linus Walleij <linusw@kernel.org>
CC: Yushan Wang <wangyushan12@huawei.com>, <alexandre.belloni@bootlin.com>,
	<arnd@arndb.de>, <fustini@kernel.org>, <krzk@kernel.org>,
	<linus.walleij@linaro.org>, <will@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<fanghao11@huawei.com>, <linuxarm@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<xuwei5@hisilicon.com>, SeongJae Park <sj@kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH 1/3] soc cache: L3 cache driver for HiSilicon SoC
Message-ID: <20260204134447.00000afd@huawei.com>
In-Reply-To: <20260204134020.00002393@huawei.com>
References: <20260203161843.649417-1-wangyushan12@huawei.com>
	<20260203161843.649417-2-wangyushan12@huawei.com>
	<CAD++jLn+TDfu-aQ+Kfm=unYp4Zjg=endP3GGzZcpuYFR=s1K1g@mail.gmail.com>
	<20260204134020.00002393@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Stat-Signature: qoumrb8nhiew9dxg86qw9hy9hmxpims1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD23D100016
X-HE-Tag: 1770212695-200926
X-HE-Meta: U2FsdGVkX194q3jdqoU/n8fndtphJCiZEWtd8Rrrtj67aqR/7aZelv8qs6y8whnFrpNXztm0ECsfdk9vH47fa7MhUGiJZP4vtfgGjTaxRTdb4pK2kNI2u7G1xe/+AZVHUQeYX4lQ91P9BS5mzc8ZYXQqL/Qr9kCaid8GWf3hHlz18ICAwn3jfahqd5pB7lRqAMAMtvttPvkAs+SK3I8fwiuWhgkASiENLkorphN12DsUn4xNO019Gs8kviNch1TW0GwgVfya5eSSfAd/iN4WmjAm3R8qfiOH4kCD8L6k4oOOd2bbP4xnNZ9b+WwpqsbbvtJrOalktA5byXiNCyu6OeRzvuvwR1ezF15bYfpTu1nvpjVnvcjzeXRjnVd6ag/u9pxS1+ciXhUUyK16mfkBzNBRIjS3isGVCQvvRdMP/7BROY3tCduh3ogDdI05phDKI2U6WcmJdrvtsTQMY9rAXfkqp4nh2zcq+b31OEUPvqxVqu4Cd9WB8Ncikp94LkUJ7bZ1RKXIuGuaVh/X1Yh7+gHFPrl6Cd3aiFY/ZruTxLRXq4sj1bkHWQcWSuA3at+pzADLqLP3XnxNSdcxY99PlHfR0z18/KS5M66djH0Wt9xY09+qd15CewT8tar82WFXCRJR94KZ6O/jid5n4HzD+ieGjvEDhHmiopgVstLILN56QTL73siGpweN7FFXRKR9Ewl0qBzqUvzk5yfFl8lRbbCQGfeCqsDhIVUccDprkDeF1P1fERNULajatV6j01r9Gc+4yk43msSVDVWLQ/BJyC7zQ1hS3zaTZUWS3LfVSHPrvDlO/MarC2rjhc4clQ13E4ELul7Mpq5EdM0sSRmLlzNKNqSZdwLhzT5HZiIijLiq6zpmHh8PRrBkHR/xTSGZ+gX3w34SSqGUifkwE96zuCq4joZ05zYzeO/UufHaPSqsS3qgam2vV4b9FXF2I11GFsauav0E8KFE5JXBPwy
 y+0Y6x6F
 o/FgGFVWAtkhyVwb82bycz/eD8XnGOtddrGukA/lJSeJT9wpDVlsgtJKxv5dxho6ExTTclOpJ3swGmgEs/BG3FYLFlmD0SkW4DXj24lP8WylS4dwuQO54jx88V5GqgLQJsK5XZCtYxiYFK9scFdJgbGYUqlE5zJlFYvwLHR3oq/glKmSSNRgug4XjUVWb8u0ZcBtbRS3A7svNXyIoH0ZsXn6IhGq2qrrLkkWDXPr/05D1joudAKCdIVx5ResbeL5C1xFu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Fixed linux-mm address that got added a few emails back.

On Wed, 4 Feb 2026 13:40:20 +0000
Jonathan Cameron <jonathan.cameron@huawei.com> wrote:

> On Wed, 4 Feb 2026 01:10:01 +0100
> Linus Walleij <linusw@kernel.org> wrote:
>=20
> > Hi Yushan,
> >=20
> > thanks for your patch!
> >=20
> > On Tue, Feb 3, 2026 at 5:18=E2=80=AFPM Yushan Wang <wangyushan12@huawei=
.com> wrote: =20
> > >
> > > The driver will create a file of `/dev/hisi_l3c` on init, mmap
> > > operations to it will allocate a memory region that is guaranteed to =
be
> > > placed in L3 cache.
> > >
> > > The driver also provides unmap() to deallocated the locked memory.
> > >
> > > The driver also provides an ioctl interface for user to get cache lock
> > > information, such as lock restrictions and locked sizes.
> > >
> > > Signed-off-by: Yushan Wang <wangyushan12@huawei.com>   =20
> >=20
> > The commit message does not say *why* you are doing this?
> >  =20
> > > +config HISI_SOC_L3C
> > > +       bool "HiSilicon L3 Cache device driver"
> > > +       depends on ACPI
> > > +       depends on ARM64 || COMPILE_TEST
> > > +       help
> > > +         This driver provides the functions to lock L3 cache entries=
 from
> > > +         being evicted for better performance.   =20
> >=20
> > Here is the reason though.
> >=20
> > Things like this need to be CC to linux-mm@vger.kernel.org.
> >=20
> > I don't see why userspace would be so well informed as to make decisions
> > about what should be locked in the L3 cache and not?
> >=20
> > I see the memory hierarchy as any other hardware: a resource that is
> > allocated and arbitrated by the kernel.
> >=20
> > The MM subsytem knows which memory is most cache hot.
> > Especially when you use DAMON DAMOS, which has the sole
> > purpose of executing actions like that. Here is a good YouTube.
> > https://www.youtube.com/watch?v=3DxKJO4kLTHOI =20
> Hi Linus,
>=20
> This typically isn't about cache hot.  It it were, the data would
> be in the cache without this. It's about ensuring something that would
> otherwise unlikely to be there is in the cache.
>=20
> Normally that's a latency critical region.  In general the kernel
> has no chance of figuring out what those are ahead of time, only
> userspace can know (based on profiling etc) that is per workload.
> The first hit matters in these use cases and it's not something
> the prefetchers can help with.
>=20
> The only thing we could do if this was in kernel would be to
> have userspace pass some hints and then let the kernel actually
> kick off the process. That just boils down to using a different
> interface to do what this driver is doing (and that's the conversaion
> this series is trying to get going)  It's a finite resource
> and you absolutely need userspace to be able to tell if it
> got what it asked for or not.
>=20
> Damon might be useful for that preanalysis though but it can't do
> anything for the infrequent extremely latency sensitive accesses.
> Normally this is fleet wide stuff based on intensive benchmarking
> of a few nodes.  Same sort of approach as the original warehouse
> scale computing paper on tuning zswap capacity across a fleet.
> Its an extreme form of profile guided optimization (and not
> currently automatic I think?). If we are putting code in this
> locked region, the program has been carefully recompiled / linked
> to group the critical parts so that we can use the minimum number
> of these locked regions. Data is a little simpler.
>=20
> It's kind of similar to resctl but at a sub process granularity.
>=20
> >=20
> > Shouldn't the MM subsystem be in charge of determining, locking
> > down and freeing up hot regions in L3 cache?
> >=20
> > This looks more like userspace is going to determine that but
> > how exactly? By running DAMON? Then it's better to keep the
> > whole mechanism in the kernel where it belongs and let the
> > MM subsystem adapt locked L3 cache to the usage patterns. =20
>=20
> I haven't yet come up with any plausible scheme by which the MM
> subsystem could do this.
>=20
> I think what we need here Yushan, is more detail on end to end
> use cases for this.  Some examples etc as clearer motivation.
>=20
> Jonathan
>=20
> >=20
> > Yours,
> > Linus Walleij
> >  =20
>=20


