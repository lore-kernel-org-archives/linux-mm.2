Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBDAEE66892
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC186B00A7; Fri, 19 Dec 2025 15:59:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6886B00A8; Fri, 19 Dec 2025 15:59:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497F46B00A9; Fri, 19 Dec 2025 15:59:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 378EB6B00A7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:59:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC1AE1363CD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:59:42 +0000 (UTC)
X-FDA: 84237437004.03.65217D4
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0DF34A0016
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:59:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=drwd8QVo;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766177981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adTHpWU6QNV63deZGh87BKlrZQhBd61B8Pt320imYrQ=;
	b=tVm/lMkdpCyY7xCpt8j/1dGCFpN/M3UuIQn7j7XdkS4L9I8XbdrEsGTmA8ogKiPwQKNQzj
	ZCjBAhxVj9b0ywdYpHGLCzETHwrXx46x/FBn7rfEwxhYZJ67UysHWC+pbTNcMgOD9XhCXK
	AHCVqV+FOJMZvrzh1zFyYF58oU91bPA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=drwd8QVo;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766177981; a=rsa-sha256;
	cv=none;
	b=N79qd/Wkv21Is1gyw72o9IuTWdbXXDYb6TTu5CXf9vWGnQrl7re6u+X5wgahmZv1QoT+6Q
	FtjimgC0xkoWIF81s6jXveT6wj6AtmeUUUlqep4JRQCrxdNVFeebZsd3FHQQm1GqlqQkA3
	p18Hi821eVf/GB0NlLtYMEeuUOM66lk=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4eda057f3c0so22594451cf.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766177980; x=1766782780; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=adTHpWU6QNV63deZGh87BKlrZQhBd61B8Pt320imYrQ=;
        b=drwd8QVog4hutYTFKAqKBiFoUuLXyZ0pqFp35YAUEynNCWCqBLZNZviW6I2srtBAlJ
         76Z1bo+QJ+fV8ObgEjQoRUA1xtkmOvyMBHKha527YB9luOWridbXhXNt6W0CNFkjPgQC
         DEFftA53VDOrS3ZhUjBVA6WRn+aaTHuKkThTpAwzKnQKOTMMH41YKyPQCaLBeBKCyMgK
         ZNGckYXUGjA/enzcZV4JDBiggcMaGhIOCJQ87cpyE0NRUnVJkVrmSUh4OH8HIDMfmOKh
         eGPEQTN6XjUCNVr6C1FY3JtSA+xdNUGMML6cZVarP+RYU0UZ8LILIjeFLIOEQRGxmOVR
         76qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766177980; x=1766782780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=adTHpWU6QNV63deZGh87BKlrZQhBd61B8Pt320imYrQ=;
        b=EdHD5cxumpQ1EECILNvAN6fEkDTqn0d7/aWLp3qrMKe0CgeRvULqTYTmx+m0hpDYb7
         rTs6bqvbV83HtmA3vFUxXZ8bG2RNqSaTJEDWQR5i0iWcLUg+iz8ZQH5Ak+qrIZHGovxA
         A9AtfsKQezracfENjCcGd/4iWIj/5Dv4aiwsusREh77jOy3bjissj0jlP+hvAdymRCpJ
         gU+P0tjkpDWd0f41hoB+T7mg5V2RmpdJFaoLgzjc4OfTmXEiexR6iFg89kv7XDHuYz0Z
         sQKd7lcEeEn5yJhKNLQmlbKOxaY1gIalONjqxxPIuTCddj0MyQcnALzMrlMhk/PecGB2
         ieGQ==
X-Gm-Message-State: AOJu0YznV4BIwRmZia0wh7ZtBoQqv+MJb8FOMMgEC/yHHMetdKaosVXP
	JODyWrgnq+hg4KQnHhS2DX27V7X4/xUKdturEcSHiMwA6E09b6x/C5XhXI0y6KINb3U=
X-Gm-Gg: AY/fxX4Sq6yp4bhK2Hg5cEcX0M6mRzwvvpErm4vAN2eLMooj4NMGqtWmcPeGcupQl7T
	2utckIhGd4z/6iqmL/GMy77KYbrJ4kdVFby+N9GMNlGBrRD+OxQiEmOtUSQcZh7N5pHo7tCXNEd
	OeemaLBdrlSRJv41eYJOw4M4fnHpittplycAHuQenPWROBx5ohFPh4Ot9zIurBExq+eiSaN2zl+
	w5rgOQddD9zGsUyw3B4NwVt2Xr4Xs8Eym0JFi/bV+saZWrA4ZDFnbnAcUecyP1Lb36e1eJX6u8+
	SYUOKuTkqsHSY1YnL/r2ga9psJXwNtfUOB63nYZapO51ZEFZt1c02MEo1viWpQNUIiLxV4Iayqu
	QusMCPpNtG5GsC6U9jtH6F0nzf1JEMPX19th+KFqV7WalaTfMO+myvxrajDXp04f0gIekif/Syc
	+GrA+WNGg8i6DnAy4enlKkp8rlTrXrxGzwXwhqn95tjVJlQkzgum061mA2syBwqzumsC0u61YAl
	4R56oWL
X-Google-Smtp-Source: AGHT+IGdjIBQjfoPLIzlJZUXRz25M9TeKiAKaKT62Kb77A1OxDeEodfvFIQzywYpMhAdgvBvyugk9w==
X-Received: by 2002:a05:622a:1314:b0:4f1:b742:9cd2 with SMTP id d75a77b69052e-4f4abd944femr65192851cf.57.1766177980102;
        Fri, 19 Dec 2025 12:59:40 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac531df9sm23918341cf.5.2025.12.19.12.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 12:59:39 -0800 (PST)
Date: Fri, 19 Dec 2025 15:59:02 -0500
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	richard.weiyang@gmail.com, osalvador@suse.de, rientjes@google.com,
	david@redhat.com, joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v6] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aUW8lsodni9C583j@gourry-fedora-PF4VCD3F>
References: <20251218233804.1395835-1-gourry@gourry.net>
 <1E3BF4A4-C8F5-4FB9-A658-9D40804CDAD6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1E3BF4A4-C8F5-4FB9-A658-9D40804CDAD6@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0DF34A0016
X-Stat-Signature: jw8j6jwgcispsuj7c39fjjhgm8dfef3t
X-Rspam-User: 
X-HE-Tag: 1766177980-435436
X-HE-Meta: U2FsdGVkX199ZYyQEE+Mg+J5Ji/gPHox0k2e1F+GlXL3nTwiUJHQkdY+HKKKmcJaqanIJr5gSghl6TqR4n+wloa6zYCwK1rmEL/RWwgAyuFxYadcD20uyK9SpEJ9uFURFnawEafsoZQ+9GpBWuW1AD/xDblfzHFkmBovyIAFx/mnSwLs59mM39LR3W2/BEyXsxdJwHlNndfN4Ut0wXlAm4Aq59fVb7XRUfWaxZs3f8OvCo21KBSs/FXpptQ0wltIlFOLBZKiDFHFbp5Y1ougEN1D3ABQ/SfO7aROVRfb78gdVWc+qTzNw1vh3+KeExsbSuqoqq7zPuHCkUnD6az/Klue7pQeCiMWThbRdn3nxGfFuk7ycrQODQQtPhganCTWwTTxr/q3k0ontdWhYpdbrZZgpxl4K51EKrRNYLosL/b41zS/3TNkgH6X+VR4BWjyxyf1oEAq2cqqvZHLJ/gp6eY2VoMBPteu+KsiSfy8Rf/jdb6o/gYS/ICHFWM1fGt9Vu2X6xztb77cvMIlPceFP+V47uCaVjAJu/9vfz+NSGRhWVUinv7Yk6lZPhpp6qkKpZv2zrf7MdU6JOsJNLo6X3ziRpSRRJ3tyuS5xVdWiX2o6l5PYqyXeliXVQNKZ9JLzrp3gBOTusqxrbZkTaWPB0j5RJjDDsx9c5ypIQsCc4Ya/f/HBlYPNF6eELCwF3oEm7zC2MBPLxH/sRgGZ6C/3o37A4m0Rd/69C960Kz7c73WgoETJVCvRxyKZ/1Z1dFTiZxXFZcv9RKe4ea5c76ZVJzTFczyWb2jpCr0QRxWtKq9zSTIriRRYSPuQViNeHGtZe6/YvmBnREAjmwsxxkkm3AspZRnRPANSfYfMRKEwvvyHQFlSE9B7tOnSO0RkQLZVG8f28Evvix3YRudkYDUaQ2YjIvkWUB1Zgwi5LGf2R9GYmkJ+Rdm+Zv2e6nfHcEueac0Hy9rjk6q5Rad2L9
 38XWJj1D
 4ZU65uPgMX7FOYY0m3tpmDGyjTj/ZVIOqhn3NhKpks50etIgLv764CzXG6PdmM0AhyKsDpB6guJBkyTK+f3wkc4MiezA572brRfmIOB28nfLqbG5gUJypskicAGLNB+LgdhFhhxn9YBopDwcTzXjl1Me2XsBfPaw98yaeXHa3remGiGdmZPuqkQofQKf8mLyKehHLuWRzuUDOLmmU/y1LfXfgPeC4KimtHuwWYQTbCbs+fT8BqC0Q+xpPzgiHy4PnekDg+MZHYBMj39FyzzKyMG9sTshuQm0+adg0OEMRYIXPc1qUZ3IgYJVTm0mbu4n8BdQu6R4jwVqRiTQ68nzyf++PH9AUYfruy5Zevlh1hnvCrYisNWIWQzzeTn5NSFX2zw3kW21BRU1KZ9xSHY2f8aGuEMcdjZXXXmO5vwQbdbwnzZMwBHWE5+deor66RQmrbrMSylnfUwJfr1j2kYEmsY+uoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 03:48:45PM -0500, Zi Yan wrote:
> On 18 Dec 2025, at 18:38, Gregory Price wrote:
> 
> > +		if (PageHuge(page)) {
> > +			unsigned int order;
> > +
> > +			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
> > +				return false;
> > +
> > +			if (skip_hugetlb) {
> > +				*skipped_hugetlb = true;
> 
> I do not know whether we should check if skipped_hugetlb is NULL or not,
> since pfn_range_valid_contig() is only called by alloc_contig_pages_noprof().
> I have no strong opinion on an additional skipped_hugetlb check.
>

I'm fine either way if folks have a preference.  Compiler might even
optimize it anyway after things get inlined.

> Otherwise, LGTM.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> 

Thanks again!
~Gregory

