Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D67CEFD1D
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 23:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627916B008A; Tue,  6 Jan 2026 18:08:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE7D6B0092; Tue,  6 Jan 2026 18:08:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B236B0093; Tue,  6 Jan 2026 18:08:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0706B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:08:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91A60D0829
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 23:08:09 +0000 (UTC)
X-FDA: 84303079098.15.98A1BDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C004D180003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 23:08:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="FQ/27CFu";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767740887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDuBX9WZdlVIBzmlsH5YDcrcjR+LGXAblvqJtI5a+5I=;
	b=U3J81zJ3PYGkG8GbtPEaHmDH+xIjkpMgOXNjxrvmSQWyuNWdukeVKAt78jZnpAbF0br9FG
	3wbCLBZnJy7TOSRyDZvILa0lwZQaBsVJFLwUFZYEvn/4I5drQwBCe1BIqB7JVu8yB/20eT
	J9p65rtDx5wB63BRFtCcIprFMx06d74=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="FQ/27CFu";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767740887; a=rsa-sha256;
	cv=none;
	b=ZzesNN1YNfIhfEpZxdr7h0iX/y6m1JTzzLWYMqc/Zqa7urDpr8McCYTTmyaI77PW+Zlm9d
	oWZ5IY4PmbqmMbGIksoGQL1rhtoaJ1rJWb1UrGtSiyUthA4Xo53+obeLIg6auQPUhl+vZc
	QouOhxnttMRQAhbR+V6+wAq5/gHXTvQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 889ED418A7;
	Tue,  6 Jan 2026 23:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C41C116C6;
	Tue,  6 Jan 2026 23:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767740886;
	bh=UpFaUM4jGABoMXMwHeRvt6GlU/2g9tCAjLCANS36qrc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FQ/27CFu+SxaZlQPUTTaeH2uud12AM2F4tYnwm7yOF/x/uwf1b/tNG7FBlGvJIfH8
	 YgDKn4uZHAKFXmaqulu01Xy+t6+Y4CYFdXKOJZHKrb/SCXw3b5XDgb4BpMJKhRTfWM
	 +E0ZdFGmQPGI+rdlIZufrhh1VK7X/i/lrrGVVaR4=
Date: Tue, 6 Jan 2026 15:08:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sid Kumar <sidhartha.kumar@oracle.com>
Cc: kernel test robot <lkp@intel.com>, Thomas Ballasi
 <tballasi@linux.microsoft.com>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 224/226] include/trace/events/vmscan.h:238:68:
 error: invalid use of undefined type 'struct mem_cgroup'
Message-Id: <20260106150805.e85104680973b055f936b0fb@linux-foundation.org>
In-Reply-To: <5e7c57c3-f08a-4411-bd5f-588a4c548cdc@oracle.com>
References: <202601070540.h0lMglk1-lkp@intel.com>
	<5e7c57c3-f08a-4411-bd5f-588a4c548cdc@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C004D180003
X-Stat-Signature: 8rhtciqnp55xrwmyy7dqamizu1xax716
X-HE-Tag: 1767740887-444602
X-HE-Meta: U2FsdGVkX19C2+yQ25Q/xb9Mi4r49ovDrWFBuLbzpekmx58pKxsmuUB09GAAWzMFZ3Et3j2XMgWubkgAH2EVncKmcWsHZaQOmdA4YlTDymHGzhPxsx1QuzTHHVACT2YeZFGOokP/JNl2xBZypWIdS9UsuHIFsZWlQLHtxkbVWQRkxyUZS6oylJZBJ2s9/5LcggGvtKSFgGcMLn0UnHM9BlJh1DjAVc5s+dv/fYJpT9pCppV3AQB+dQo1mhI5p6tWjMuCL2odyu94/OnZvMLXSwG2R8N2TlHnb3ng8rCWl/DZ1Ulz3/7ufYxiyAbH5sPL67CE9Z7hx/ZZjbDdM5ilH0aVii7eo6nah2cBzyV1xflQRG9DN/xFE61cQ1Cv0j4RYxMzymtrUIRbWipEFfkly3DypTikNmtE7zlRFfuKBUygQCOjpYnVWbFpzKpt1fWxYFW6Q+yP13oTKh0OT8ELOdlqTziA9ojgiTwnkAto7u74JfQlCDlUvXVIlPNNYIUxeu/OyhFRI5VjusdokvwlbgOqVKyG/8z6OVIIpRN3JRvu2mqPxm0TxcgtzP1HABVxCiOkoxtVUY4R0CNhP5h+VxAsss580moVVbbvpRleZBlfpWsP6xtZkLzvLxS7umqhPRljbHMbhtK6LH0/sqeLBk9+YG8Sy1YQb9+Bz83Fn0i8SKvDtMa3rnDMWVPHtzdbgzyFTYnPTF4nVeeiJEOmmj2k53bchAq28JPkU5RiEGem1nC/oPmxLcu5OzR/hpB++bM0Nyj/dORXn1HDvaRbFA/LmOcAznGgp4wXizL/Exi2tVnQxaSNbuVGt7Zt9t6pT+MLDedyx+X4AsIxIXB8KYBncqyc6L6BTQBHlIjWvOwtWMUr+XlltdYuykVYtJNi8500ujQ65JYN9N9KAnUVlChPxfL75T5icEDrZvvqmN/XNvC4tKq2Ruk9xpBLX4wiPiiWyBAt8N20mUQcwsa
 JJrhue86
 DvIuXe1pBtZU3eZScP03HyikEhu0zzXoe0e4I6ba+GwI+mAeSh5Xkl+XTFhem9XAPcA3tS4NHCASa+bIoFAeJHjDBfxbPTAlJ2S949MwsptyvKlc7xwKJm9A6Sl7wBppsokXhFJIjTFBV/N+vTShqIhzwY0Rs1kVeF1p4NoO7+407oFjJQIO40ZwjgSUORxVWY9sXFQQfxkwHb/JKRnYq3FcTG9sFI/02yIr+85+9P0mCe7PAMKB8y9iYtLvQ+qmuVDkSev8BTQ5lQSNpwLOuFKbDcQzwFbhaC+IcKHCptvxkaAXoQQv2013f3JMXez5q3hCAq4AHI7i6FLEMCzcAoM9lnHbB0+EFmxbFj7a72tNy+fwZSyQWJudA/L6vc7XBjheneOzBDmG1r77qIYzi+FPMy/JPOitHFetmn+fyjPpEdwk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 15:52:09 -0600 Sid Kumar <sidhartha.kumar@oracle.com> wrote:

> On 1/6/26 3:41 PM, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   d51d3f6765d29ab5cdc6a59ad832017e660d5add
> > commit: b84bca52c8e661aa7da507a03cc3f6831fef2edf [224/226] mm: vmscan: add cgroup IDs to vmscan tracepoints
> > config: i386-randconfig-011-20260107 (https://download.01.org/0day-ci/archive/20260107/202601070540.h0lMglk1-lkp@intel.com/config)
> > compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260107/202601070540.h0lMglk1-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601070540.h0lMglk1-lkp@intel.com/
> >
> > All errors (new ones prefixed by >>):
> >
> >     In file included from include/trace/define_trace.h:132,
> >                      from include/trace/events/vmscan.h:554,
> >                      from mm/vmscan.c:73:
> >     include/trace/events/vmscan.h: In function 'do_trace_event_raw_event_mm_shrink_slab_start':
> >>> include/trace/events/vmscan.h:238:68: error: invalid use of undefined type 'struct mem_cgroup'
> >       238 |                 __entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
> 
> 
> I ran into the same issue when trying to build mm-new with # 
> CONFIG_MEMCG is not set
> 
> The below diff allowed me to build, but not sure if the correct fix:

Thanks.  The series seems to have a few issues so I'll drop it for now.

tracing-add-__event_in_irq-helpers.patch
mm-vmscan-add-cgroup-ids-to-vmscan-tracepoints.patch
mm-vmscan-add-pids-to-vmscan-tracepoints.patch


