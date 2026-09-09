Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBF49C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0678E6B00AF; Wed,  9 Sep 2026 10:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F066B00B0; Wed,  9 Sep 2026 10:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73046B00B1; Wed,  9 Sep 2026 10:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C94876B00AF
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:09:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A6E712020B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:09:21 +0000 (UTC)
X-FDA: 85194406122.10.B57B201
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 64B6140004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:09:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DpsxHwVy;
	spf=pass (imf04.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1ST6aXUH4vLpGnMtkmVRunw3NWN0K0+mb6hBsdUCQI=;
	b=WbZ7uXarHl6uEejGoyjqkJtxcXt0Bv4vrz/i7onqjx+kuxRtGD9P1ELilkaxw8IY+Iwgxn
	vYKSQgTUE7ReLhiHt6ImE1kBVFCqyxMtP5uTKYpmWJflcOJ3wdoAj7TVIgku8xyxyZkzZo
	z6vd1xNQtASPwVHu5PPo+7YrONtgtkQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962959;
	b=VIbmmVEA0ui7rklxrnlEHcwMdpnQ608n7fCTvX9p3s/4K4CD0pIrqoKSy3aJRpoSSbhNC+
	omyemxyCjHqJDAn/nLuLbKLjnE58zBxw+6T9mGpnS1lpMJcoLZ7NSX5NCktWr3XhYpa/SB
	BR399eGgSSEyUl3lXP4nGb932O5PpGU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DpsxHwVy;
	spf=pass (imf04.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 42FBA40BBA;
	Wed,  9 Sep 2026 14:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AE61F00AC4;
	Wed,  9 Sep 2026 14:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962958;
	bh=O1ST6aXUH4vLpGnMtkmVRunw3NWN0K0+mb6hBsdUCQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DpsxHwVyJX+mrQa6mAky5OHHf6TFNA21E6ZCddduSrSRcT71dXX+HYOrNVCiH02lh
	 0epweTWOEemt3L0dqdvgVp6qEO9xKlgTASLFi5+Ge5GqannAwBDJ6JIQgsnh9vmmX5
	 0LD/ql5NK8av7/oJ/DIG2iW7PTrztIVCyd1JyMeniKbr6LmCan8I7BsDAsTXiamNbi
	 vDx3BbpxlyFntwBuYSHr50Bdq12mThCO9ojnYQkFCPesgUNK9O1sYznv3WoboWSSxV
	 hbPbUeLOMHIuF1GDyZWbgY3rR9lv8C+aW40dmHgEN2w10T7hwE10LEVo9Pr2AD5x84
	 OvExso9usG7FA==
Date: Wed, 9 Sep 2026 16:09:15 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Christian =?utf-8?B?S8O2bmln?= <ckoenig.leichtzumerken@gmail.com>
Cc: Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Sowjanya Komatineni <skomatineni@nvidia.com>, Luca Ceresoli <luca.ceresoli@bootlin.com>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Russell King <linux@armlinux.org.uk>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Chun Ng <chunn@nvidia.com>, 
	Mark Rutland <mark.rutland@arm.com>, Saravana Kannan <saravanak@kernel.org>, 
	Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH v6 08/12] dma-buf: heaps: Add debugfs support
Message-ID: <aqFnTYSaVfNrDzLN@orome>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
 <20260904-tegra-vpr-v6-8-79042cfa8de5@nvidia.com>
 <a77730b2-b5d6-49f9-a8ab-72eac4e241b6@amd.com>
 <2fd989b4-06ea-42e6-b18a-bc3ef2e069f5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3xrykvyn4aewo5kb"
Content-Disposition: inline
In-Reply-To: <2fd989b4-06ea-42e6-b18a-bc3ef2e069f5@gmail.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ed5bhqf99ht31htjf1wx6yyg7tk3mskh
X-Rspamd-Queue-Id: 64B6140004
X-HE-Tag: 1788962959-934447
X-HE-Meta: U2FsdGVkX19etVReh3AUY7oIVeqC2gny6NlrAGjzNd87qa7eiqedOt3cJjBG3Z7Hc7d+bcJHxDJ2J2WetM2h8HEUnJwG3NLu1+VCX1rSo344Ty6gzFDlMCrIiPnyI229JssEMtet12uSRyYlCoIaR/cGFKrE1Fjpp4sZi4qG60o2jPGeUg4f/h+mDzRbA9xbXBcW5/IGIzFsoHGK5O9v9SwLkeqtYcGG/l/lZGWq4ZPPRnoLs/CyNynx+MZWiTD/K+LyulyBa0GCOp9jeJf2SnKoo99WXMl75JwgWL36ib6JQiJBXszItSlPzeTAnlRjiOZ8EQywjsEbfpChN4T76MnLccLk43QMGnrqKSSEDgMidpN39sP6JRmndz1RAWMONr9DcuQ2OMBh5zMO3/7UVEVihfvXmnPye5IwwGE+nWkq+J28I55fX1AGwD7zq+Fcd7TUtlbEdu7rBQwKkpPPHV7BbFj4p0kM5QfHTQOGG8kpeOJFbT/Dg+OLM326o9hbpN4PEe2onBv3dneh3f6ouZQJsuz6HEMwIKh6m1923AjMZI+Kr/OceNpNcX1banbkj3B3txviQRGir94rziUziqHcBVlYc3IDoue6YNwtY7mQrM+hY8mO1/wJD9QH/+cfrvndHbCHES+r2ntljaQA5RWVnczy0NSU8dtPmurl2hVznXZGra2sN0Tek5HmfH/93baAKtDeGvJvF1CwKbxDCeqAgdsFvY0Csf+4WFZjAN8hCE+XGQggc2ifrv81wDzS+vFCI0cjmL2ZlXYGZFo9zJCLHwyQWlqWjEc3WCAV+ws8uEcHUXblN+thHfumJs4iIwGm/AEcrCJu337ee0Ujs/Q1p4+oIiJDR5JSkT8D49i7eawUYuui97hp7UEvFwA3XAXn8C/OgrPUgRuIEZCjmwJ5zjyow2SGtqisLwVIdb84wsuloQm8UQl1x4h1GhTtcLcIerwPnoPtD7+Os4+
 QnHYTDIv
 tB88aBS6H3DBMlLPBap7Kls3l6yqsbazvqnD/+kr0y+X7hIUfhM4CBHC7arBdq4g/7NG5+/Z0WQac186yPv2QDBwBgMRwTz+2Lau1MjxRSL5Z6fpnIRpagOkuMpPbBPjKQMZoUQLTD7W+00/4P6+f981ZbxyoA527d73d61LTaOaxDZH793vFxwUd9xcKpM1b8kyQHMo/ytHnTqKEWgc4jgzUu72GkqYp93RU1TMn6Dl/dU0T6+gK6QaxmUDyUQunBFXPRVjGW4TQzw9tBwxGd7qz7IiWry7BD5SZoe3rLEggPACMwCw4KK16TKVweAwwbLKvOakKqT/LYXmzZpLHsL/J7OZiX6N7bI0ipY0ylPBaUH69PWtSo3Y7CqfHjJBuwxp40zhsEHrLRh9jmSLDqwKxjhZeI+lTyV13nD4sunAlVraILexR7cctlFTqY/0PF2TF6MPYJ36MusHEvO5Jp1wW2fQW9qYoZxxFe0hSoaPdYm5fvdmKCUK1RZsRbcO636lXhwT8fU86Ft8LH2N5PH/MzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--3xrykvyn4aewo5kb
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v6 08/12] dma-buf: heaps: Add debugfs support
MIME-Version: 1.0

On Wed, Sep 09, 2026 at 01:04:03PM +0200, Christian K=C3=B6nig wrote:
> Since AMDs mail servers blocked me from sending this out, here once more =
=66rom my gmail account.
>=20
> Regards,
> Christian.
>=20
> On 9/4/26 15:00, Christian K=C3=B6nig wrote:
> > On 9/4/26 12:44, Thierry Reding wrote:
> >> From: Thierry Reding <treding@nvidia.com>
> >>
> >> Add a callback to struct dma_heap_ops that heap providers can implement
> >> to show information about the state of the heap in debugfs. A top-level
> >> directory named "dma_heap" is created in debugfs and individual files
> >> will be named after the heaps.
> >>
> >> Reviewed-by: Maxime Ripard <mripard@kernel.org>
> >> Signed-off-by: Thierry Reding <treding@nvidia.com>
> >=20
> > One minimal nit pick below, with that taken care of Reviewed-by: Christ=
ian K=C3=B6nig <christian.koenig@amd.com>.
> >=20
> >> ---
> >> Changes in v5:
> >> - fix failure handling during debugfs root directory creation
> >> - add more cleanup to the newly introduced dma_heap_exit()
> >> ---
> >>  drivers/dma-buf/dma-heap.c | 52 +++++++++++++++++++++++++++++++++++++=
+++++++++
> >>  include/linux/dma-heap.h   |  2 ++
> >>  2 files changed, 54 insertions(+)
> >>
> >> diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
> >> index 8a6c2b6e0cc6..65c80dac6500 100644
> >> --- a/drivers/dma-buf/dma-heap.c
> >> +++ b/drivers/dma-buf/dma-heap.c
> >> @@ -7,6 +7,7 @@
> >>   */
> >> =20
> >>  #include <linux/cdev.h>
> >> +#include <linux/debugfs.h>
> >>  #include <linux/device.h>
> >>  #include <linux/dma-buf.h>
> >>  #include <linux/dma-heap.h>
> >> @@ -225,6 +226,40 @@ const char *dma_heap_get_name(struct dma_heap *he=
ap)
> >>  }
> >>  EXPORT_SYMBOL_NS_GPL(dma_heap_get_name, "DMA_BUF_HEAP");
> >> =20
> >> +#ifdef CONFIG_DEBUG_FS
> >> +static int dma_heap_debug_show(struct seq_file *s, void *unused)
> >> +{
> >> +	struct dma_heap *heap =3D s->private;
> >> +	int err =3D 0;
> >> +
> >> +	if (heap->ops && heap->ops->show)
> >> +		err =3D heap->ops->show(s, heap);
> >> +
> >> +	return err;
> >> +}
> >> +DEFINE_SHOW_ATTRIBUTE(dma_heap_debug);
> >> +
> >> +static struct dentry *dma_heap_debugfs_dir;
> >> +
> >> +static void dma_heap_init_debugfs(void)
> >> +{
> >> +	dma_heap_debugfs_dir =3D debugfs_create_dir("dma_heap", NULL);
> >> +}
> >> +
> >> +static void dma_heap_exit_debugfs(void)
> >> +{
> >> +	debugfs_remove_recursive(dma_heap_debugfs_dir);
> >> +}
> >> +#else
> >> +static void dma_heap_init_debugfs(void)
> >> +{
> >> +}
> >> +
> >> +static void dma_heap_exit_debugfs(void)
> >> +{
> >> +}
> >> +#endif
> >> +
> >>  /**
> >>   * dma_heap_add - adds a heap to dmabuf heaps
> >>   * @exp_info: information needed to register this heap
> >> @@ -299,6 +334,13 @@ struct dma_heap *dma_heap_add(const struct dma_he=
ap_export_info *exp_info)
> >> =20
> >>  	/* Add heap to the list */
> >>  	list_add(&heap->list, &heap_list);
> >> +
> >> +#ifdef CONFIG_DEBUG_FS
> >> +	if (heap->ops && heap->ops->show)
> >> +		debugfs_create_file(heap->name, 0444, dma_heap_debugfs_dir,
> >> +				    heap, &dma_heap_debug_fops);
> >> +#endif
> >> +
> >>  	mutex_unlock(&heap_list_lock);
> >> =20
> >>  	return heap;
> >> @@ -335,6 +377,16 @@ static int dma_heap_init(void)
> >>  	}
> >>  	dma_heap_class->devnode =3D dma_heap_devnode;
> >> =20
> >> +	dma_heap_init_debugfs();
> >> +
> >>  	return 0;
> >>  }
> >>  subsys_initcall(dma_heap_init);
> >> +
> >> +static void __exit dma_heap_exit(void)
> >> +{
> >> +	dma_heap_exit_debugfs();
> >> +	class_destroy(dma_heap_class);
> >> +	unregister_chrdev_region(dma_heap_devt, NUM_HEAP_MINORS);
> >> +}
> >> +__exitcall(dma_heap_exit);
> >> diff --git a/include/linux/dma-heap.h b/include/linux/dma-heap.h
> >> index 648328a64b27..1c9bed1f4dde 100644
> >> --- a/include/linux/dma-heap.h
> >> +++ b/include/linux/dma-heap.h
> >> @@ -12,6 +12,7 @@
> >>  #include <linux/types.h>
> >> =20
> >>  struct dma_heap;
> >> +struct seq_file;
> >> =20
> >>  /**
> >>   * struct dma_heap_ops - ops to operate on a given heap
> >> @@ -24,6 +25,7 @@ struct dma_heap_ops {
> >>  				    unsigned long len,
> >>  				    u32 fd_flags,
> >>  				    u64 heap_flags);
> >> +	int (*show)(struct seq_file *s, struct dma_heap *heap);
> >=20
> > I found it good coding practice for objects ops pointer tables to have =
the object the function works with as first parameter.
> >=20
> > Absolutely not a must have, but just looks a little bit more consistent.

Agreed, I generally prefer that too. However, in this case I thought it
more important to model this after how pretty much every debugfs file
operation works, which is to take the seq_file as first parameter. It's
the same order as for the main dma_heap_debug_show() entry point that
this is called from, so it's consistent that way.

I guess an alternative way to think about it is that in this case the
object that we're really working with is the seq_file and the dma_heap
is what gets written to that seq_file.

Thierry

--3xrykvyn4aewo5kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmqhaIgACgkQ3SOs138+
s6HunhAAiN37Dd+TG+BFBCdSRmV2hMHjWc+FdBQaTN44THpv2z6VMPtar+lpEOnj
ebQ25tBFfYNr5t1GcY62OjCbvi/nUicdtL8MDwLDFBlN7Klb2heTA6ahS/DbqzaM
g35ClGbknLWH/2yEe3Wff2iduod4n7FhE5HM19ScvUcISiIhCVlHuki/axbv+c94
jHwJA3xCbYyCA22i6ss9TBlxL6V0eerGlHSsnuXwsfV/f9/SHw3MoH3LrA1nlS08
csdw+ZNM3zf8cE0jJll9c9NgdvTDzn00bilN8r8tt4tnKofQRJ03VhlBCvOtdzYl
7LFnV+2C3V7Go2x8cInDtWmz0Uatp9H7gCsZ/AofL8i+HoiOpfsqoHWZaoNxLPGv
Th28zBw41Il1iqyN4qN39Xir+SpyZrI4ltGF2+CHMBK+3/czC/UUhh3wev+fVdnR
JL9BfJo1SbiPT8mk/uyZziU+wXJz0HQ/MNwX1fZjNHcOKn+hfHnSnV36uqcVFxJ3
DcXi/LFGMKZ6M5pXSprA26JBc3wJZwMWBIR1ouZZxJLef0sZARBlRNjobVJ+9z6r
7Wu/0KnLumcEpKcvleRPffm/phk+cjMESwnvx7gq6Blmo/8weR179dWKjb1NhNkb
GyYJGi/bcNybqbqfqrn5F0FLm+a/1qG78dywKqc/4yrX6HWPnFA=
=gj3n
-----END PGP SIGNATURE-----

--3xrykvyn4aewo5kb--

