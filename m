Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A25606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 12:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JAIbLE0S
Received: by kanga.kvack.org (Postfix)
	id EA4766B05B8; Fri, 20 Nov 2026 07:03:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55826B05B9; Fri, 20 Nov 2026 07:03:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6B3A6B05BA; Fri, 20 Nov 2026 07:03:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B1D036B05B8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:03:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3881120EB2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:03:35 +0000 (UTC)
X-FDA: 85455362790.02.8D79FB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 08356180007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:03:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JAIbLE0S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795176214;
	b=6peDb9ryUjvg44g/1Uw5OYHSvF3/5p51oQEh1pD9nZb3OmjEsm67+Aevit5fxA3n9gH0fa
	lv402lXDfLlq9gU6DnEljN7Bep1u9H2kGZp1JqOCe49iFci8ql0cJ4aog8WkYzCc5BggiO
	rKsmJPdd2xqCWVSAvKYKVHw39n5ViJE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795176214;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsgHV0quLYYKk4mxB/bu1tZX7bUFJNZxSMDfjRQjlJA=;
	b=HDMgmnr4sr63oo11j4na7M6z8dEIJZYG7OV3Z+GPCIJnPELkge0Xlbh1KISWpCZ/tz9l+H
	krnDHnxLFDpl+Otzk0imw9FH4Gqe15dMDUZirGUUv7eVg8W4XREeuI5eGEBesyQycLwCBw
	sUiOSQQHxopxzzeFSoq13YaAdpL6snc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JAIbLE0S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0ECE6267A;
	Fri, 20 Nov 2026 12:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304451F000D0;
	Fri, 20 Nov 2026 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795176213;
	bh=HsgHV0quLYYKk4mxB/bu1tZX7bUFJNZxSMDfjRQjlJA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JAIbLE0SH66We0axqp5/5KdlL4zj67ge49JQ2cCV9dAz/iTIwzwB1SRZPYmdXduU3
	 EwcST2h/+/KodO8RL8AG0apwubEEUVrFqF8j0kW//ZNishM9rVOOFt82L307NJL8pO
	 DbYjVJ1nseWtSoajx3IAJAeNE87VcC/z36Ujzx0HRFpQg1AOzB1wX91VprScfL3KZo
	 q10aRKZDEY6WcjRaayp0kLp+lOTUsEum1g1C6jfZvMrUe0ICOz8u1on8flgB+nKpZ/
	 N4eygASNQ2HAXbIdEnRREuF/O2UWfIGrkWPY6oL3vMdCM7mW83e0COyYtE1JCuK6Ol
	 1zf9qnS+uszaQ==
Message-ID: <sashiko-outbox-225116@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 7/7] mm: page_reporting: add flush parameter with
 page budget
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Brendan Jackman" <jackmanb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Suren Baghdasaryan" <surenb@google.com>, "Jason
 Wang" <jasowang@redhat.com>, "Andrea Arcangeli" <aarcange@redhat.com>, "Dev
 Jain" <dev.jain@arm.com>, "Geert Uytterhoeven" <geert@linux-m68k.org>, "Greg
 Ungerer" <gerg@linux-m68k.org>, "Gregory Price" <gourry@gourry.net>,
 =?utf-8?b?SHVhbmcsIFlpbmc=?= <ying.huang@linux.alibaba.com>, "Lance Yang" <lance.yang@linux.dev>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Magnus Lindholm" <linmag7@gmail.com>, "Matthew
 Wilcox" <willy@infradead.org>, "Miaohe Lin" <linmiaohe@huawei.com>, "Zi Yan" <ziy@nvidia.com>, linux-mm@kvack.org, virtualization@lists.linux.dev, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Eugenio
 Perez" <eperezma@redhat.com>
In-Reply-To: <2d518dd7b8f7be147b9a957ad94f6c6641e4b5ef.1795089715.git.mst@redhat.com>
References: <cover.1795089715.git.mst@redhat.com>
 <2d518dd7b8f7be147b9a957ad94f6c6641e4b5ef.1795089715.git.mst@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 12:03:31 +0000
X-Rspamd-Queue-Id: 08356180007
X-Stat-Signature: rndd718x6yke7kgo1ncimrgnkammo4kr
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795176213-741118
X-HE-Meta: U2FsdGVkX1+53xgMnOrKCcxmVfVJ2GsG/KPELQO/qd4/ObuU4nJmXGVHBwLPcT6ETLXBVHDK6QNubiGX7HYpIwBFCMaYdBpET8s2fFkUdUstGqsGVxEX3GuJ0OjIHg+g0mI1PXQAmVJIrf+0+UbAlDn22k16xxrfA9SXfj+kFJGAJs69NUv+1SIYoG+E6xz1d2E1eshXmsaD0V2vp1cpLPh9hF368vH3J0ff01gGNoLJIVPy1br5EpRhSzFx5iYBnD3+7gm5A/RUamdJjpuefrC3SxkdVReXQ/7BODzKavTSXRYbRM6JufeMGmIrnEKzEekz3fw8NIaPlhho+fO5Bnm9E0U8dI8fsGtIPVPK/y/CM4CYmn+EjeQzFiyaK+q50fzorWfCOkeEXiUw1qLyGng40AkTK748uTKwxO592VHE3+ilQXcQaXZ/dnoqA6SRHlFGbnXDvD90vu5OI0Ee9UAEtctFCz2ekdxV/fU4S22nwZ83BM90GcokgLc6wRWBqzv6YBh1uBpjihchAV77CxAcoOU7m5b1wj5h0WIDfgkynC5Po7Wx8nCOBWriKrEafvwyZcxrGz+juCo7unBePvh6T34FIUQWc+2fscVugII9N2vUu5C3me+BS09vsAZQQfI77iRsKt9Cp7zoCrFRy0p+rKW+gC7puA84jO7uJP1RpbZERWvUOa7rRTCnU50/y6s4dJAkIRrHcUlqyWpRvXJp+FxbSHQkJmG6AoUMgn/D0yvRjSiv2M7afqOi1qRnnbsc0j7Gy/2af6NWjqKlk4YVYyLCvZk1BsIg+9FdIvVNu104wSxJSTtDRWTn+nfZtprlcz5LoDSjaHY8JUBxY6Sc+UTFEubKCql0RTlAXucBuh8VDIpnqITSVKS3KPLBmHYB4zkcR3gg4i1WAl8JYTwAQlXZCNmHGlrVNxZ6TcLydAbR0cY1NiuDWhBeI5dLZcBpTuqx4FghgqqPeTz
 AFz9tZmh
 siKtZ3J+nom5229v7qqpBc6YKIXU90nibMSUOeUEFOSTEbsB2LvrxRIqPnxyAM/gZ1j92OplU8jKE9EIcssUfQBa5urEdrbLl82zPHXI5NEQKqUOFX28CXs21wZMK9jw0EgGzSJkVlwJvzBSLCZPYawFmpSEOOmzWv2LJ5GnCBYdbv3eOahYYLBFoUXzynKblzVxYNorxvWDAE4g1UyI2lmjPeqget/86klWYbvqRoBJxjIO/EJOEz2QSFsPbO2K98MXJcIaTCWnZMOtphLtd9z5TEdqHVe/12kIrnTkSwItRTtPzsDOqPLkQbkdrJaxDeLAv9TwiP+tFz/q8ykOx8eSws7Q7OT+XBG0GMhTLszy9YpajhMjOIeoEU7xsn0YJ0/o40S5NNvYvdCRKA0TLH593x/Y+qqFQ3xV/L3t7mGzG5vIgWhlQTAcEXxiaQ13EZ4ICQCvUr7VwJBO7O7Iop+XUFsC8cAv6LEFuqvrxhwpr41EoCfPiG7tQJuTwKKDs1OzFdl3DaHMOaLQwxyLCTb9jjKAtKHOmzO7SRvT2nagQ086J6wz224IdUiBXRfzRyFISxafOS+mDPCByC6QPGqtES0uHSt8e0BjVzprY54WjBMUIfqAlOQ6nxXpyI6M1fo232dgdpUkI9Ej0qQWTrLMzWMphxABbgLKo7JHKWzWJseu6voBxu5bNxT7xJ7Atf1JlsC2GswoJOizErjWD75eWmqY0BN59G1mEsxVIKN7s8BovQxkOhzx5Pp+e6akSFdFL/3W+VkewnMQI00dRHQlsaB07EDshWuhxRmlQluy+7qROzncNH4/nQPBsLNcoztfGVt2+8qHPEUcHXYWCQPD3hY14ENPFAgiVc3l51a73Dgeq3WekyJtsNyrw5wvq4FbhcnDtNFU8EyS3Jj8pk9CfpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm: page_reporting: redundant work flush in
  page_reporting_flush_set()
- [Medium] mm: page_reporting: hardcoded capacity in
  page_reporting_flush_set()
- [Low] mm: page_reporting: unused variable and get op for write-only
  flush param
--

commit 18e2a422153fdecadcaa01e59911f68043266f81
Author: Michael S. Tsirkin <mst@redhat.com>

mm: page_reporting: add flush parameter with page budget

This commit adds a write-only "flush" module parameter to trigger
immediate page reporting up to an approximate page budget.

> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> index 841dcd64777d1..74c03844fc3e9 100644
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -360,6 +360,46 @@ static void page_reporting_process(struct work_struc=
t *work)
>  static DEFINE_MUTEX(page_reporting_mutex);
>  DEFINE_STATIC_KEY_FALSE(page_reporting_enabled);
> =20
> +static int page_reporting_flush_set(const char *val,
> +				    const struct kernel_param *kp)
> +{
> +	struct page_reporting_dev_info *prdev;
> +	unsigned int budget;
> +	int err;
> +
> +	err =3D kstrtouint(val, 0, &budget);
> +	if (err)
> +		return err;
> +	if (!budget)
> +		return 0;
> +
> +	mutex_lock(&page_reporting_mutex);
> +	prdev =3D rcu_dereference_protected(pr_dev_info,
> +				lockdep_is_held(&page_reporting_mutex));
> +	if (prdev) {
> +		while (budget) {
> +			budget -=3D min(budget, PAGE_REPORTING_CAPACITY);

[Severity: Medium]
Should this decrement budget by prdev->capacity instead of
PAGE_REPORTING_CAPACITY?  A driver can register with a smaller
prdev->capacity than PAGE_REPORTING_CAPACITY, which is what
page_reporting_process() uses to size each batch, so using
PAGE_REPORTING_CAPACITY exhausts the requested budget too early.

> +			flush_delayed_work(&prdev->work);
> +			__page_reporting_request(prdev);
> +			flush_delayed_work(&prdev->work);
> +			if (atomic_read(&prdev->state) =3D=3D PAGE_REPORTING_IDLE)
> +				break;

[Severity: Medium]
Does calling flush_delayed_work(&prdev->work) both before and after
__page_reporting_request(prdev) inside the loop run two reporting passes
per iteration and an extra pass after all pages are reported?

When page_reporting_process() finishes a pass with more pages left to
report, it already re-schedules prdev->work before returning:

mm/page_reporting.c:page_reporting_process() {
    ...
	state =3D atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
	if (state =3D=3D PAGE_REPORTING_REQUESTED)
		page_reporting_schedule_work(prdev);
}

Whenever prdev->work is already queued (including every iteration after
the first), the first flush_delayed_work() runs a full reporting pass.  If
that pass finishes all remaining pages and sets prdev->state to
PAGE_REPORTING_IDLE, __page_reporting_request() immediately transitions
prdev->state back to PAGE_REPORTING_REQUESTED and queues another pass that
the second flush_delayed_work() executes across all zones.  If unreported
pages remain after the first flush, page_reporting_process() has already
queued prdev->work again, so the second flush_delayed_work() runs a second
full pass in the same iteration while only decrementing budget once.

> +			if (signal_pending(current))
> +				break;
> +		}
> +	}
> +	mutex_unlock(&page_reporting_mutex);
> +	return 0;
> +}
> +
> +static const struct kernel_param_ops flush_ops =3D {
> +	.set =3D page_reporting_flush_set,
> +	.get =3D param_get_uint,
> +};
> +static unsigned int page_reporting_flush;
> +module_param_cb(flush, &flush_ops, &page_reporting_flush, 0200);

[Severity: Low]
Since flush is a write-only parameter and page_reporting_flush_set() never
touches page_reporting_flush, should flush_ops.get and
page_reporting_flush be dropped (passing NULL to module_param_cb()) so
param_attr_show() returns -EPERM if the sysfs mode is changed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795089715.gi=
t.mst@redhat.com?part=3D7

