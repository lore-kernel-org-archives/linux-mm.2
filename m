Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6496C47BE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A739E6B008A; Tue,  6 Jan 2026 06:34:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33D76B0093; Tue,  6 Jan 2026 06:34:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A196B0095; Tue,  6 Jan 2026 06:34:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82C5C6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:34:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C9381AA3AA
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:34:36 +0000 (UTC)
X-FDA: 84301331352.26.40FC415
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2E93440014
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:34:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bl0XiXAu;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767699274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KoUoIpbxATSqLMzgG8ilQMkf+g6gJyxFiLa7FEkFkG4=;
	b=xSyg4FAFAxBtpEKP8zkwMMIfql+NU31b9brokXA/IMoNZMU+zUEPoAgksZJeYhMmVBP1V3
	ja+xFp8Vr4ISDyg59vrLutlwDlgNf6KNcU1eEdZQAZtvVHrv0548gDZHW3H5D6PQxmS9rI
	MB5MIV11BQHcVnN6NWChaB7n4ij/34A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bl0XiXAu;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767699274; a=rsa-sha256;
	cv=none;
	b=60zYYmST5JQwJ86J7VCAWelBKH05LW3APdcRyuSvJy5UjO4gPmfTjqEQIHdtaHoblIF5bF
	NRZIUJ7gaE74sMDgGz4l/cwpkHYTxRFkI+Deke95ywXipC2bWGWhV/+ugA8D3joEMz+RpW
	l5K7ZXlT9euMPKWRKhQO4XGBq37BCWw=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59583505988so1371285e87.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 03:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767699272; x=1768304072; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KoUoIpbxATSqLMzgG8ilQMkf+g6gJyxFiLa7FEkFkG4=;
        b=Bl0XiXAuAi+ihe3pxqyfVEgrVBsVPnbpxX+9RhLz1S/cWWc4OEYvq2EZQdRvluV8HG
         ZCsNgiO3nZKpmRTW+Swmi2gS6ROkUsATIrgA7gWbtu+HeKeuGeIwoNw5hGFu2ZxScbpx
         HG8nEGotD4jev6D6i0uQutJCESSUqRhMdcstP9tY1apUBRyCxYmGdZgKbt3ji1KK8ejS
         j2CWgDwYFKM3m45JYkNZFs80YYaBuGBrHEQYKcjo+cw4bubYtYomg1F5JnMRwjt8TnnY
         2e8yMhVxiTYXAgay12q5QGwgxiIeZMPq1mQkyK2drEkz5VPf/qBw8y6kiUOQspEkJQm/
         5KXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767699272; x=1768304072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KoUoIpbxATSqLMzgG8ilQMkf+g6gJyxFiLa7FEkFkG4=;
        b=M7DEHWyeGgcFvWNavLTqZx9EMScIGtE3BvXOw5JKbBbtakD+2EK6zBfiVoP5V/rWeR
         giaD2DRYXADqiuyzKdKYorwBPXxw2TINez7waKs/tdPIIV0hR6e1lxF3p0XihN5QKodN
         a6Wy7fQuFfs+SBtzC1oqFCaGfejXnw9iIpOG5pWAmJ7hokm2Y+DeW3lM5cBffeEVkjG5
         fqMJHz/Y4OJqQkhLl0tjsN5NgnT0J1E9xUz4lnpU+Dia9jmpy5sOUmKPj8NPY+YxmVJ/
         aB7LTu0hwH7djpHgD/6KypQ7XNeWIwajHEnJBHrwFFh9/l408sdxsstCbVEIHaZv1beH
         kIjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWl/UiHHJRMJPlCGdttuSmJqojKQaplNWUG9WiPT8iOR44t1PYN3+9zqZ33ZmG1iSD9Qny/0ydAVg==@kvack.org
X-Gm-Message-State: AOJu0YxzaS1cyV/3ohfk4Hmd8PbOxhuzTS1i2dUJCxnwo4mODWKYEWRA
	BZHh6wwyS3KN5eulRAf8edmEcyJNskZi9rv8iC1Dh0szSC0pRFE83acO
X-Gm-Gg: AY/fxX7CMV8JAPln33UAY2Nwe+9yMo5efk70tr1Bi0ppGK7iOIoocnZF9djpO1lUxzp
	kXXq9sNaftfoI4VnNBznD3HUtk5YXT/qYmDN/YfxWlCe4d/qtkiHBGlxJE3VfGuCAAH8g2Q9Ihn
	Oy/Foz4aSXT7XvFmGi+kUUunAYtH4WGZp5+9yy5UR6Gsy+PRP64oCvCVGr1lknqJqy3M3+cukNw
	TU5HppLs+A/PKNfmX/tyoM/S9BOpfhuFo+sresGW/+9tV20HSBci3OEjCfZojPSJSh+cReIBMn8
	pwSA9iiucUXvJwtJODJOQDvf25vHzVwGGt8+q1e92Py6ZYNfak1hbLKqrSO4jp4Z4iED+nNQqwD
	V4+aszNK6ejgbk7eqzr2p4Mx04Jvlnm0TjJcAIkgp1TyX1rKdFrk=
X-Google-Smtp-Source: AGHT+IE+lB9eendcALR/ULoAEQJKIfgtjYi2OGAI/Wqdno2jUmDLBw3R96c+3XtiVW2SaiRPDwGHFQ==
X-Received: by 2002:a05:6512:3ca6:b0:598:f35d:952e with SMTP id 2adb3069b0e04-59b65a939bbmr793660e87.25.1767699271961;
        Tue, 06 Jan 2026 03:34:31 -0800 (PST)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b65d5dc74sm517522e87.54.2026.01.06.03.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 03:34:31 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 6 Jan 2026 12:34:29 +0100
To: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] Free contiguous order-0 pages efficiently
Message-ID: <aVzzRU-VkHpJlpps@pc636>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
 <aVyRz62kQbPe5HbI@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVyRz62kQbPe5HbI@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2E93440014
X-Stat-Signature: p81nphi6u1kiwmkcwzdw973dh9rnzuum
X-HE-Tag: 1767699273-263210
X-HE-Meta: U2FsdGVkX18khvZPhSJceGuNKuHu/XZooL0T0nXT7oe5cStdqpaWwLdDEsUlrM8ejdbwwPG9q0n7PCFdvt/LjyL42gyx2cHU1IHSzYs/VSHx2EeOaYigHnpDa5wt4DwTPAfxB7ftmYeoMbHEgoGVGp1WaeKfWBG+UFX6ziuGELXTPIr0eH0UF99uNn0//lxCdywvd5BbHz9yAwcvzidyplnPMDhJBAEkF4cjAfHupuN8E9H3UiIB77RQA0lj1Mg4h8Hw5Oiej6eGByP+d0zm6fx/czm+sMH+77AuKYCiPz+m+3i7/evs2SHA3IZ9Jo6SvVp4XRELlSV8NdZowpLrPX0Q10RlO9TkvGHyvzbN/gq4CceQXsYUjb/9qJzhBSTn9hbNs4wINe4eXlvcRwf3EzBgS5BVSef0MGmGubecU85N64tzN1Zx9aqL64zygFXaL1gj3YamSmQPpqfAQ00Gqp+cwLwmzqyavahT8eAUuJStJ2DNYDcO4P1OIXh6wRsxyuFd1DYZpccYOnLGkzqeKNIiK0LQAb/h925JUleiDrbpaSOVAmhqK1ypG2OAD0ZVCJDSGVYtsjsebXoHGmC/gnfD9+ezJG88+hgzi5BKLESJb9WP3SnMfI/bQKVS+LWgdmvwZuzFBIsf8OY6U0mSYPghPYHo9uqkIUv3mx0Lm0p1/KbH/YS7Yzgb4fWDSpViBqN2LHYgtNPREhGuEdbTItV6zHnMCSzk5JojVx0THJTEkiVaAm713dI8kvnGxg1XBuW9V+uP65nIkThk2IWZdpL7OIFypxOn+8/6MSVWEHIz6wCKiiVQMs/dqhqMEgKcNhg4NWsRlkhukF4aykP/o2pg/QbOZQlduPITQQK/wzC3Voni0pMMhKzwFdYBe0txGEbckyl3Cz1Pnytl3cbvacEjRA21ldcg8zJ9yZiKYr3Od54ZQWLs/hemy386OUXUt5F0z2dKz6gNnInUH2A
 RyEn9DHh
 M0u+c8lruHXSjoQ9AJHbllB6B67FfbCzodVCg3XJzyneLHUGyZ/dZrHuWuqamN5LphqXrojTyMJXFbEqv4mZ2WIta4bHCqK5cLddSkrksBE3C3YN5KtZzEqmt2u10DC5Mn0Uf9HOq8ipPoh8nWtx/z7VEEMPpfubh+5D312O69xsJPwFZY+EZmAIitHKSC1R4m24HCwdbT7TPlkndTPOBz7gQo75+OYvHaKu5Jz+WhyZoaKkApXuYO9t/ItlSZ56KSlhJTXkeekvm+ln0fTYM7+u9trJy6WOFs8OKoe0IAmkYat5EFXzTeBVzbkh0Kg0pfGz51j+V68nvyfXh5RPj8hrZPqAsetnqsVTTwISDarc++xUz8VntOXyMWKhQsOzDvbOeyvEmnbreGgVbjHhivvWxF86DaoGN3Y18ERwTmJzNOUcx3Q8xykv2/ca/GPPeDiW7Z2AHv4TpO3+QT4L0NaPQEt/RlGMS76qSDSrScpznpmJbmjikptB2/KbJDJ6l1Ud5SO45XKKez8VXHGDh1DsLhthr+bbnTY98SFPeEjrUbo8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 04:38:39AM +0000, Matthew Wilcox wrote:
> On Mon, Jan 05, 2026 at 04:17:36PM +0000, Ryan Roberts wrote:
> > Hi All,
> > 
> > A recent change to vmalloc caused some performance benchmark regressions (see
> > [1]). I'm attempting to fix that (and at the same time signficantly improve
> 
> Unfortunately, there was no [1] ... I'm not sure this benchmark is
> really doing anything representative.  But the performance improvement
> is certainly welcome; we'd deferred work on that for later.
>
When discussed the high-order preference allocation patch, i noticed
a difference in behaviour right away. Further investigation showed that
the free path also needs to be improved to fully benefit from that change.

I can document the test-cases in the test_vmalloc.c if it helps. Also
i can add more focused benchmarks for allocation and free paths.

--
Uladzislau Rezki

