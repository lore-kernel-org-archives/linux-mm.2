Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C7EC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912C06B0088; Wed, 23 Sep 2026 11:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89C2B6B008A; Wed, 23 Sep 2026 11:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763E66B0092; Wed, 23 Sep 2026 11:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD9A6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:38:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0A8BA01CC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:38:41 +0000 (UTC)
X-FDA: 85245434442.26.3C81397
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2F20A40010
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:38:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIAz+p+G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790177920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBvzheVxpsN1KuGNPAJdA0qsktLApMfKzycXl7Y5NAE=;
	b=iD7ct4JZWRAnHUlPt9TnpEbHKe9AvuHCp4jlHp7N4MqfU2Yxtd6MxI6SW4irdcWTTH0HLM
	Mw1FRJ0lF7fk0BNS1pLoHrrLwKMW3woAOPJQB9p/XeediIbgfWy7J8vjPDjMdHX3tnL3Lg
	DJdOin8BPtRVBAtG/Cchl5iQkCnxp2A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZIAz+p+G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790177920;
	b=1ZN9rm46o5CRVqN+l95KT8e79bzNR/vfftCujCi84MMMwBybVvEnUpcsxSbEFOhyQZcoP7
	yiG3YNvk5u6mlDcV5YX7KIHUnoNksANFEKW7UrlPWvRjq/FXzSK/BIWQxLP0/jfr/oOLl3
	AXKKqcs4vmagSp5Z+cIvizIwG5Hd46Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DD47600AA;
	Wed, 23 Sep 2026 15:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B381F000FF;
	Wed, 23 Sep 2026 15:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790177918;
	bh=WBvzheVxpsN1KuGNPAJdA0qsktLApMfKzycXl7Y5NAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZIAz+p+GcBovjWK/gG9i/D/MOXQ6OZFqKjDxy3MduFYI8wZ+szwC/H9/Z8emkXg4g
	 X+hanW4zo94iLmVClDyVPrxvOFngm6qm0TMVLJO6VA0DplqL1GsgHMUrgA48FverBk
	 3P0RJT7+fDPZFCKVGPMWQy3ILRtoC6Y1aAEBIDMBywNZ0fo6glmzFuzHCsTXVhnmhC
	 QjszwSyRaPkJkdm0ZxQqZIz2RqfYYb6/EkJJjXrCBTUN/HsmXeoZ+UeuZj+ziA7uSa
	 Vo8KDnAzq2ub3A0itwuFcxN+xydMHSeMo9ywhOlg/C4o2hQ5RPo28PPDOD+P8f+l7n
	 FIRYA5V3Ikouw==
Date: Wed, 23 Sep 2026 18:38:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/5] hibernation: ensure secretmem pages don't reach a
 snapshot
Message-ID: <arPyeNHUkthT4Rlv@kernel.org>
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-2-7f7dfae3dbe0@kernel.org>
 <4ed926ae-9e9b-45d7-9ba3-a24431522bb2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ed926ae-9e9b-45d7-9ba3-a24431522bb2@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 1m6qpsp4ppncj7q1b3crh9ntu35344e7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F20A40010
X-HE-Tag: 1790177920-997028
X-HE-Meta: U2FsdGVkX1+ht/wPTe37Myct2SEbpciTMjaV2qaO94MF4BQicIxk+wX/cwkI4KzYRe6T87VEbVxSbWEpimYyvgHxUUxarWcM2YvZycCUvEesc6xW13aBxe7enn/GwfO+m0fSpoIlQt3yh8uyWZiUVisTVT2tdatB9t+LpskAf/X7PxsiCjr3MytApjApppAuOsOhxhBSPoD5xQ3Yirl/XswaFToPGBJEW5WtBxKqnfuyGlqwGloW3tMrZLzeod16Hlb2rljqaMWFpvDtMHxjVgdc20fisstADPpEfD6uQHp45UQvahh5zcgV6ciOYxI6SXqavCxOpB/b5YKvyBssitw3/AoiIxJzzdsghOqcnRiad64a1we6635snCYDBHrDbFNrckkrK1CRgSDcK5iaPk8hEa9At/eoOHDJgFtzP0XDVet7rSAvejY73N9xCmbgGWI2yB4zdHfMadOoRTVGLr8tbbHahKQa78Q/yChv+I/dm2cvbD/UsVR+hbHdUKKS4D6u3bMUXZVPwZ9JmwqiYorIKp2vDjGB7vwbYotRVRwP6y4mg9kqMt7ullxHeriARWYiOxQDMlgB39/6LsWWjdOYvVArxCozUj4I/ycfMFkfshAm8//jyj6YdhqgBe62vwvGiVd0avvlXyVW2gEbV0J8FDxnYFrfB/bEIWqxsarzcxTLb1cPB9cpl0jK6QtNQTK8HD8Ce6G14V1nc7fJ5MnwFzJUS7+4VYsxmT/hdR7DhX1vkekhzlGNVke/2FrFuck/MNlLp9kQtdwNXwZ4hN3++e9R7oo4tqbNU6P4lxzzQ9GlZhDotMb9w0wQxwWdjJWYQBTQvICP61kxZRGaN+pVG0v///HOsQ+U40+BS6sVsOUMgEJXNu+E5Dxf/dcdMfxY0RsroIq/yEBf6kEp8mXMZysN0mGqGfwWeAvOwXllGcJEaxVSKoAdO2adrnabTP7WyscxfrnDfEtih+7
 rnVu5RH3
 LQiXTfCXIXD43bFImdPxWBjFaQb2igmj5l3owMcdv3nqWA0KhrQhu51ef0tiIvbMQt6hINiB8uKlNfArDIBMKHrZt47LKo8YtnOMjA9DF8xHBhOW7fkpSDVQkeTDsaNU4SCIieK/86LBFLEYbBIMeycUM2K1BYnoAnK/YbFMWOms6PTDFHcS7/sm6fvBSgbVxg02lTdYebLbqs/PPa+KcuFBTECD3MlnSepUSyHTSXXi7mS6Jd2G/g+raCzBJ5IX9s8tKjvTCm4jR87ARtz2sjNQDAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 12:10:52PM +0200, David Hildenbrand (Arm) wrote:
> On 9/17/26 08:07, Mike Rapoport (Microsoft) wrote:
> > hibernation_available() checks for active secretmem users, but a secretmem
> > file can be created after this check and its pages may get into the
> > hibernation snapshot although they should not.
> > 
> > Recheck secretmem state after userspace is frozen and abort hibernation if
> > secretmem is active.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  kernel/power/hibernate.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> > index d2479c69d71a4..281ad49411481 100644
> > --- a/kernel/power/hibernate.c
> > +++ b/kernel/power/hibernate.c
> > @@ -412,6 +412,11 @@ int hibernation_snapshot(int platform_mode)
> >  	if (error)
> >  		goto Close;
> >  
> > +	if (secretmem_active()) {
> > +		error = -EBUSY;
> > +		goto Thaw;
> > +	}
> > +
> 
> Should we instead recheck hibernation_available() like we do at the beginning of
> hibernate() before freezing?

I'm not sure it's possible to hotplug cxl at that tiny window, but yeah,
checking hibernation_available() is cleaner.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

