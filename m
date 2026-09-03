Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99270C624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3986B00A7; Thu,  3 Sep 2026 06:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983B26B00AB; Thu,  3 Sep 2026 06:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8723E6B00AC; Thu,  3 Sep 2026 06:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 55C9D6B00A7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:10:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C807E120495
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:10:44 +0000 (UTC)
X-FDA: 85172032008.18.B6A60F8
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 07A9480004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:10:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vTWk+++r;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=vdonnefort@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788430243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+pGX1kR1YWXhGrmpKIk1Ega27SLYogpSDSn/oUaopE=;
	b=CpVkYoPb3uU2CnkJI9NjesUwQ/uSiA9JJVZxrsyfRS5BfvsQq9udlZKKz1QMd0OmvHAFII
	7Vskrtp8UclghsXGqBOq8YhA8RAZS92EPLF6s+TxXot5HY+TOxHTan0zIoFszTqg+6UwEp
	PYSllndiHTf3F6cKzi1EHp9CfJtD5/g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vTWk+++r;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=vdonnefort@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788430243;
	b=ffyLta//RxLA++x9hMuruIQTqwpSNcxwvRGKv+Y9NHMLFUlOjMk5ECr5/MgLlz8UzMDSCy
	rbiWraZFMujgUOZDlrVcLe2wmpB/fDHyKzVdxirLxOWMaZ7CdZCv0iLlljIv6AdEqSrZ/u
	pPNRRzvq+heFeyFc/QCLuK9ZQB6eWqs=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49ccfae359fso15627905e9.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 03:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788430241; x=1789035041; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v+pGX1kR1YWXhGrmpKIk1Ega27SLYogpSDSn/oUaopE=;
        b=vTWk+++rCdHLbtT2OdDLGygkl5i+bzoqR+voN55AdLsMfhKw0EuCtPU8TwsCRWrx2G
         fL89zVMWk6rR/wfBhPyxSUkEDEUJqqRXI6TyH0XVYVTtCYD58I5HEGJHXTBTawkiI+Kc
         o6h8BP9jUQmxSZ2w4JfF1ePCPvcm7vjA0cU3U5nM1tQacqvpyyAA0I4b0NKS+2Nioluv
         1KGMUhC4KBtLmKMUKX+mVRHlTZUsn1yMbIC4xrnJYO5zmZifxYEQ4LQ0on7oOp5wlnI/
         RXCOWMZxcVkUIYo+kwFpaB6v17GhpnOTRKyc4NvYfnN/6t0/CG1NyHpBrOMzLaB7sJWB
         IBRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788430241; x=1789035041;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v+pGX1kR1YWXhGrmpKIk1Ega27SLYogpSDSn/oUaopE=;
        b=kzctvU5je/hYo4r/ltRNgeWR6a01aU77CvFk9zQ/R14aH7KcaKEtG1XlxhYAUzLZGZ
         jXQTKwkNW8aCUJtvLlJM63bIDcSbjTGkqTb3ravsza6rd3Dpxyrups3URwbRLhiLHR9a
         HxA7pjCbskNy66FaUP2qb0TQgr5NMzuvmcfmLjDvrQDSRU9YnbGJgxw0sXQ8pe3oT9jC
         CaFr4a6p4/4kT5Y4xRxdErTS04Kl+jWndpQhzY73V4Ycd1A88q2ZL1X8IWX/JgCK60yx
         v6urPZI0CCyjhqWVHTIY36L2rbC4Pl24+XQKRbcCCQm7InBAeGlTk0Wbuw2epaxk8Z0Z
         r2KA==
X-Forwarded-Encrypted: i=1; AKwUvBxZAePaPUSB6ycqZKLenHKgqU0PjPlOD3ET6wQoMJQlWQVUnvUt3lJjqscVDL4X22C51882K8Vvyg==@kvack.org
X-Gm-Message-State: AFuF++mI5iU22QNOfggIMTx/WBbvz3NCPiKRYn1tjYbvSfa01HdnzGkY
	99b34+pf0VIE6hv24mL/xx+QUtctGYfmzWwCf6PjhBq0VPWPcdxtKzwANXHZPyAozQ==
X-Gm-Gg: AYBFou3CdVcLaA1Mo200CxwjJTMUZdp6yQaEIuSy/VL7FuT43fepZwRvaQ2sEOiwjt5
	hj5IohypqkdFBYRL7DgHXmA4/ip1M/wy6EuOSjMdDrNzND7wv8LkREB+XUHKNHpXO+6lquu96gt
	xN8z7rtPn/NiMBDAC6V8EE5GMFNE4tOvE+5OOWAJepPi32pNV7MmL1oHuAZhoAJruHzWsOFe4zk
	JV1ufaI7ISo/BknqjqLFX8lowa49xwjTVEIh6ikh3m1bPe+VTUau1Smb2VnSQjUAn6+xiwsK8cX
	WNdn1gXUfJ34ZpnefcI7myPgneM71/u/pr6AVn4HsotB2FjCssiqjz1hZ4461WKNE89b8FjISRx
	R5+4DV5uxvR3pyhVqIAG4oZ3+L9ii4PgSMQh8r2R7D/fik7mZ6SOBO/StQ75H/1W2tTnLqGi5lM
	EAoW+0vlImRW/LMtaT0Qs7mPQKvZnGKhwpZUHW7KWHjHIxNUjbZWnFYI/Byak05SeY5VRCWNCkS
	qSqglQv1tm3xQfo/CRp3tepuaR5cDq2XJaUVysi3jFzeg==
X-Received: by 2002:a05:600c:1906:b0:499:8b13:3a98 with SMTP id 5b1f17b1804b1-49ce57e7a9dmr190171115e9.4.1788430240105;
        Thu, 03 Sep 2026 03:10:40 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf2531232sm33980375e9.7.2026.09.03.03.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 03:10:39 -0700 (PDT)
Date: Thu, 3 Sep 2026 11:10:36 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Rob Herring <robh@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org,
	akpm@linux-foundation.org, sudeep.holla@kernel.org,
	jenswi@kernel.org, mark.rutland@arm.com, sumit.garg@kernel.org,
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org,
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, op-tee@lists.trustedfirmware.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 09/10] firmware: arm_ffa: Introduce ffa-lend-pool
Message-ID: <aplHnDS2e-Cd5yPC@google.com>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-10-vdonnefort@google.com>
 <20260902173826.GC1440252-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902173826.GC1440252-robh@kernel.org>
X-Stat-Signature: 889te5k9xk4jyhxtruyssssgmpubc49t
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 07A9480004
X-Rspam-User: 
X-HE-Tag: 1788430242-577303
X-HE-Meta: U2FsdGVkX1+C3ZTJJ7xnenQUcVFARzCB3fVNQwc9Zh6jz1FUEdxHVQQT6AJHnyJkhKCzAni3AjrJ1BVisix8SWqmC7wAhRBQlkQs7BDc5VXnspN8JdLTrGbYYqJGRz75I5A3KF5CfZzpNNvb9XHE00ihQyaB2uWk6wczinj+zwigIovCpsMko36ieFEL3jtFvmi+VvhC7gUZH7q//ek9envshB+7E1k6WUG26+rKTEE1ruekUkG5Midp41XaGeF65Yj9J4P7tJVU5gC1dDir6WmJnjy8XPzQ+QnKJ1IpupUcd1bs5y/Pz4O2Tw8JxATLkdK4k1ME2s75VfbZekkjYnVGk18IDi8uUxQx5oWhjgJCbRXN8s25mo2skNk5SPkn9woAlfkO7uGgZfg7L171QQ7n0UCSoc2KMrawjZq4G3I1IcWP4M1/MiC8Y/biP9CztdPTrPxMwTDWYmBqEMgKDr79d/2njGfJqfCY61/pZrdH2kRXFIaBbKSt8NETMF+b1BV1nA96CHYWdkj36QBr9Mcpu2phhQV8Qzj+jEa06imZhNnKyBBJbY2Qb/r/EbBjg6cp9tAkLWszNzoFpCBiNzAsz9DFtBTUHQ9zQe3CCjSqZ6UA4UKO92EFZjy4oKhJ9mgUPQREG9ayAcwYztOARGZ0pDQFGG7tEWPzNPeXuqqKrxiTBJN7b0ODpBmb2rKy5atqtDQZxbO1x2D6EMpQHdg5owE6RrLEK6INF93/TqzSxtZMPrrslhjRalVZRZG45dQIZmg6mqJesjj2OqGDv+nZRCuM8k3KBpurQx7/LTaRQB0pd/SiDelOR3qE69h2ENSBFa5UUEjpSPHoJDth6zlv4y3nSIh3b7My+4NKBWRo6o1S0zC/boCii8Tn8Vv7bmhMe27G0oGJLEkpdR3pyA1Bz/YmA8m3p1YK4VPrwi4ICq24qw1wOwwZssTj84gQuICHjVD0XI5+47Kuhmg
 e5/B1bkJ
 qBp6LJceTidz14eAQUNSrPtL/vTMV60RCXSFYyGdwB0+D9hBjC3Hd5aj53LeAzL9fDzZRCdfHJKxyrxNcrv7vIt+BzHwicIdllwwRgzRIShTRusM0A8CVVqwdmxThqFnWDAn4RNkGvsW7U+T15sAQ5vZCgbJF0NtvgNe8G7BTL/zkDdb5teb/dygpRbOdWfM0+iMykBd56K7ZCuYTM+r2hGGOTZVx689IItqif6LQvS/ZQDeXjNNrVIB4ltdPk2jAbEGH6tOAdv7ab0Qa2Qhf58ZfEh46Soq/FGD+F0iIOeSXUrgFxSMcc85jNPN9iN1oDOXWaxvzQNSRbJqnsj0JmI2/evQNiX9yleGrOBxg+ptSZDu/RtaE7uARRpA1CDqrzxaDWIIjuPyivePIhqNmrGnwdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 12:38:26PM -0500, Rob Herring wrote:
> On Wed, Sep 02, 2026 at 11:47:11AM +0100, Vincent Donnefort wrote:
> > When memory is lent to the Secure world via FF-A, fatal CPU speculative
> > reads from Non-Secure can still occur as long as it retains a cacheable
> > mapping to that memory. Introduce the "arm,ffa-lend-pool"
> > reserved-memory CMA driver to unmap pages before lending
> > (ffa_prepare_lend()) and restore them upon reclaim
> > (ffa_lend_reclaimed()). Devices bind to the pool via the "memory-region"
> > DT property or via ffa_lend_pool_attach().
> > 
> >   reserved-memory {
> >       #address-cells = <0x2>;
> >       #size-cells = <0x2>;
> >       ranges;
> > 
> >       ffa_lend: ffa-lend-pool {
> >           compatible = "arm,ffa-lend-pool";
> 
> Needs a binding schema...

Ack

> 
> >           reusable;
> >           ll-map;
> >           size = <0x0 0x4000000>;
> >       };
> >   };
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> [...]
> 
> > +static int __init ffa_lend_pool_setup(unsigned long node, struct reserved_mem *rmem)
> > +{
> > +	struct cma *cma;
> > +	int ret;
> > +
> > +	if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
> > +	    of_get_flat_dt_prop(node, "no-map", NULL)) {
> > +		pr_err("FF-A lend pool: node must be 'reusable' and not 'no-map'\n");
> > +		return -EINVAL;
> 
> Your schema should enforce/check this.
> 
> [...]
> 
> > +static const struct reserved_mem_ops ffa_lend_pool_ops = {
> > +	.node_init	= ffa_lend_pool_setup,
> > +	.device_init	= ffa_lend_pool_device_init,
> > +	.device_release = ffa_lend_pool_device_release,
> > +};
> > +RESERVEDMEM_OF_DECLARE(ffa_lend_pool, "arm,ffa-lend-pool", &ffa_lend_pool_ops);
> 
> Do you need this early? If not, you can create a platform driver for 
> "arm,ffa-lend-pool". ramoops is implemented that way for example.
> 
> Rob

Only memblock_mark_llmap() must be called very early.

The rest just need to be in place before the TEE driver probed. So a platform
driver should work.

Thanks!

-- 
Vincent

