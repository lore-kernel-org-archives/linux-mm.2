Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F7ACD8C89
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 16:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56276B0088; Sun,  7 Jun 2026 12:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDF8C6B008A; Sun,  7 Jun 2026 12:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E4D6B008C; Sun,  7 Jun 2026 12:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB7FC6B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 12:53:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CD1F1407CF
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 16:53:17 +0000 (UTC)
X-FDA: 84853712034.27.FBBC176
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 92207120002
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 16:53:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TohwrbPs;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780851195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYvllh828OEo5YmAfffzBOwQRz1Nkklj1UYoBt49RSw=;
	b=PWLr9SlbwzMV8FguJj2+2cBYWBdYnrVrk7t1WbAIm6AappU3XoHkC+476Yoouf71xtL1vg
	SYtC9Hrr+rpXRaMoVKvgDGFPAloyZZy0tj39yh16ACXRxMNDR+sJslZ4ZqdMdlTMzMj7Oh
	RQIm1n7wPwfdYClI3EkrwYv81mHS1dQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780851195;
	b=rbwg26jDY6TarII49y7PAHFrUk+KwkH+o4mennLVKjcGOSeN4aAxf2r9Oh9G4xFwVkxBM2
	LcwNei3DykQw4UKh/gmOnPkeop+mOUe8ctroQK3co4hIl8Gm0GfHJdu2m4vM0B6LdJX+DU
	EtqSfGlk3o/4A3wwrjnmBsQlP9SIENg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TohwrbPs;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E05B060018;
	Sun,  7 Jun 2026 16:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CBE1F00893;
	Sun,  7 Jun 2026 16:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780851194;
	bh=BYvllh828OEo5YmAfffzBOwQRz1Nkklj1UYoBt49RSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TohwrbPsBtqeQhFfFgF52wyCgnviyVAWSuXKxFJHBiTIgWQQGzoK1EtNBoALbydkQ
	 51CGXRRReXS4xTJqnXXMvyegujt15YSLOGMhVPvbR/abYWVONUH4YMiN59qICa7la5
	 T7g7HmMt2xsWOjkir3BPTIRlPmC+pYIBgm33cY/Ea/w+sFfQuqI636qTXkpDBib2oO
	 9PfQC/cAyRa/0mBZ67r71ZUIL3gFbaniC8goOkJerlsN5H6FFLUw+5yO3TNd+vuSbD
	 uoFBJ2NPi143XzYeDWbA7cY3KDwX092Lbn620pfKDsNsLyhjTGIJ56aro2UdVhH0xk
	 E19kEcKLvnTsg==
From: SeongJae Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 02/10] mm/damon/core: add damon_new_region() debug_sanity check
Date: Sun,  7 Jun 2026 09:53:05 -0700
Message-ID: <20260607165305.93321-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <d057097f-2efc-4f27-861b-ac076b93e34f@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92207120002
X-Stat-Signature: 8ejy58ugr6dn6x886wb8d63gccwwm74s
X-HE-Tag: 1780851195-105189
X-HE-Meta: U2FsdGVkX19u64abEy3RACi1gKVZ9LkwVvIyjhrzPxAkaaSJQJgVIRYMhZ9Q9UFI6WijZxXFyWa2suFE9a3TF3pBeHpE156JotP5AJ7s3HIabSBn+BokJjrbPFNnPa/1Z7X1eeDjb0ljz/jRW3RewKhjbYEjyq5VP+VzrWcdWsjcUyqFrCxlfKvhQz0hjfZDf0nDum2lIBa3waHMxoXh53DSrjXQLsm+OJykfe+Hzw6Copo/H439cujdoid9aVHa/5GAHbfFZama53VXoSdGr7snWbQlJ+9oFJ+5Uhmeg0mI7myWFi2y2Rqk1ZkG0amFLoRp/dcgOHvfMudJ6G2fz8ZNT4wewYCK87CxSLq0CWGi/5mbxaY2AjlAJfajfG6N3YQO+P5ODgp84OEgRrqtP1LBWdvoO0j4Rjin1B4LdCwOrRYchB06w53F2VrUaZEWg7/gkQw0zBbl0XI0W2AQ2cRL0ZyZJeytfOJOJbbnuwxHsLJCi2AbOXG9CsnjoN3u/5MGlZZ4he1X2p2NFWZnYG06jgZ2uVRtO8ZYiruEGWFjzTTtT+imG+9VBOVLZGwaqjxKI40LgdRAKTLIB6SHEhhteGqjAuE0+8mZR2Zu8R4LJjFmlBCT/SyqZoqxyNDKO8ZsM2Q3U5sW9QB6mJ09puedpk+PQJ+IotL8Jp7/xDY+8tQ//BmS0kcufBW8waC8L2k41DdmVKn0klawNJH8HTm+bmsqxGnnmMvVaOh+PxPxDgSWoNjmo183qpwxGU+Wq3ohG80vQawbOyWn3DSvTKektyzYWSP+zA48m7d+z1YkYOx6Zr9Le8fZeX/tVgmFQ3ddkB75rcFXrO7ct/osxVMRhuVFdXlCiAlnyQYCA9OdLckAek0GkfiDx28wi6ftlGjBT3yyq51xhwq687mIrYoAPRi3Un4gl5eU7jJaaoteiLZb+Em+4kr1/Y8xpGN/47N/Z+NqbCSlZK4hTvz
 AOeVZDPz
 yr35OpqITNZtujuJ1RZZuuse+3feVkPm6nkqK+WSkaDPqgmGCJ8oIs0cnVX73bXeL8f7YgIsreoIT/UDgbSTv8tAH73sa0wl2lNyz126Wr+qouLA0z9Cd5x66+TlSqMSmfLOXkQ4ai60kXckSYqrXee86DeMY7vNJPZyNLImBVJegaVCnI+HgS9xVhuKAs3lXuRti361/qkSEVRrCnROgPWB+rQigUr3xGnPPUXIaDFWX+2MZgu7jkBykQ/gUbx+cq2yKATG1rP60ADcBLnGyMBQoHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Zenghui,

On Sun, 7 Jun 2026 23:24:27 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> Hi SeongJae,
> 
> On 3/6/26 11:29 PM, SeongJae Park wrote:
> > damon_new_region() is supposed to be called with only valid address
> > range arguments.  Do the check under DAMON_DEBUG_SANITY.
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  mm/damon/core.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index f1a97e85824ac..0c1353164ec81 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -109,6 +109,17 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
> >  	return err;
> >  }
> >  
> > +#ifdef CONFIG_DAMON_DEBUG_SANITY
> > +static void damon_verify_new_region(unsigned long start, unsigned long end)
> > +{
> > +	WARN_ONCE(start >= end, "start %lu >= end %lu\n", start, end);
> > +}
> > +#else
> > +static void damon_verify_new_region(unsigned long start, unsigned long end)
> > +{
> > +}
> > +#endif
> > +
> >  /*
> >   * Construct a damon_region struct
> >   *
> > @@ -118,6 +129,7 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
> >  {
> >  	struct damon_region *region;
> >  
> > +	damon_verify_new_region(start, end);
> >  	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
> >  	if (!region)
> >  		return NULL;
> 
> This can be triggered with
> 
> 	echo Y > /sys/module/damon_sample_mtier/parameters/enabled
> 
> because both node{0,1}_{start,end}_addr are 0 if people forget to properly
> initialize them.

Nice finding!

> This can be avoided by checking the parameters right
> before damon_new_region(). But I'm not sure if this is the correct
> solution.
> 
> diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
> index 775838a23d93..4a5d3fb12e1b 100644
> --- a/samples/damon/mtier.c
> +++ b/samples/damon/mtier.c
> @@ -118,6 +118,9 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
>  	} else {
>  		addr.start = promote ? node1_start_addr : node0_start_addr;
>  		addr.end = promote ? node1_end_addr : node0_end_addr;
> +
> +		if (addr.start >= addr.end)
> +			goto free_out;
>  	}
>  
>  	region = damon_new_region(addr.start, addr.end);

Because mtier is just a sample module, and this doesn't cause a catastrophic
situation like system crash, I think this is very urgent.  But, given the
simplicity of the change, this looks good to me.  If you'd like to send a
patch, please feel free to do.

The real problem in my perspective is, however, the fact that DAMON core is
not providing a central parameters sanity check.  As a result, each DAMON core
API callers are implementing their own validation that often and repeatedly
turns out to be incomplete, like this.  I'm working on such central sanity
check and further refactoring DAMON API.  Some of work in progress [1] is
available at damon/next tree.  While the work is ongoing, adding this kind of
additional check should also be fine.

[1] http://git.kernel.org/sj/c/16a0e8ecd699f86b


Thanks,
SJ

[...]

