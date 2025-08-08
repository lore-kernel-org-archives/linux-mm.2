Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E8FC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 03:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07D896B00AA; Thu,  7 Aug 2025 23:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007876B00AC; Thu,  7 Aug 2025 23:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8CDE6B00AF; Thu,  7 Aug 2025 23:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D97426B00AA
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 23:22:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 432351DE970
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:22:06 +0000 (UTC)
X-FDA: 83752141452.04.A5540F1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6F8401C0006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:22:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hBeUB1A8;
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754623324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9v/VfxV4WcSv8mLKBf97De83PUNubQY/hyRrkNkUdjA=;
	b=dwrQV88NP7fy+khFE3cZcHkQ345+7MxDgCGIYwRAF3TuqCR862glY18PVvGMrw+H8LclPG
	Sq29bMeCxgJ3vIoNSz3pVCl3zVnQT/AlVBZFcxVImJgnibDO7W0PMzsNCH/xdDFtHOB3Vz
	IEozWnxX2o2U/6Ri06SLdnatIwp6Ry8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754623324; a=rsa-sha256;
	cv=none;
	b=tW6KCNM0DIT8daw4/0acRPcA7tfpZNFKdcOa/1Vs2qCmKazB8IkX4NZzhLJhHDEh5eJb2v
	gHVD7rMvG+Pmvo20EshfR3Raxa23AoVGdD2mX+9eZs6HiKkfKQ0KeWbVpJ9/VXw+Os2kSf
	2Ndz5mtFxgIIB2SxEsw9EmPf9g9hbn8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hBeUB1A8;
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754623323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9v/VfxV4WcSv8mLKBf97De83PUNubQY/hyRrkNkUdjA=;
	b=hBeUB1A8AlxJwmV2IPATyHI+29DfY6PXbvZJsaaeJzbeNC1Sbq66WfL9KZ8St8NBccrDuC
	8VOc9JZxqenHYFXEPFTfO8/QFetaPF92+pa07t2hbSrhcrVAgYrDnylFe7DYn0vRppmYGP
	pG9XM+tcIbvWb8yZCsfzyMXJ3p+ubhA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-CQ50kHbEPO-N047aktSPjQ-1; Thu,
 07 Aug 2025 23:22:00 -0400
X-MC-Unique: CQ50kHbEPO-N047aktSPjQ-1
X-Mimecast-MFC-AGG-ID: CQ50kHbEPO-N047aktSPjQ_1754623318
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CBDA18004D4;
	Fri,  8 Aug 2025 03:21:57 +0000 (UTC)
Received: from localhost (unknown [10.72.112.126])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 699EB19560AD;
	Fri,  8 Aug 2025 03:21:55 +0000 (UTC)
Date: Fri, 8 Aug 2025 11:21:50 +0800
From: Baoquan He <bhe@redhat.com>
To: Marco Elver <elver@google.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] mm/kasan: make kasan=on|off work for all three modes
Message-ID: <aJVtTjRUXqWePva0@MiWiFi-R3L-srv>
References: <20250805062333.121553-1-bhe@redhat.com>
 <CANpmjNP-29cuk+MY0w9rvLNizO02yY_ZxP+T0cmCZBi+b5tDTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNP-29cuk+MY0w9rvLNizO02yY_ZxP+T0cmCZBi+b5tDTQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 6F8401C0006
X-Stat-Signature: yhd5rdm9nw4xwonsxxkoei5prtxhgmh9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754623324-67462
X-HE-Meta: U2FsdGVkX1+785gU/sdORtyPWkHUsJ3HPQZ2kM78HI6m4a+1Gm78PwEdeE01PJg8l0eppds7cPXeRsx6i8KSARpusdEqNc7U/3kxO+TfFu6Jwsw0CINL1Dv3d7L7IZYmPAh2KGgveyZrH4gy27Xzf1fX4KsmK2JsUM6CzB0mR9kDVoVb8Hpa4wNT62YFxH5/fyfSaxyO0H0ZRQydRI2EGHrzuHuYY5SwiFldIL2hviEyyhemryrxJhr0Zld4pUXA0TOhAgv00fydXFW+9e/icnNxc/cdUjbV36DsnTsNH9xXy0wEWk65wvS4W8Q1AdxMFVOJgW1etW5DwxejHRoqNY2kOLtvyTOIIWDBZfm5oGdOFRDPTF6e55VaRRRTG+mBWjnsUPxUQ7yYm0flB0EBQQlTaZF/VcF41Cxs8xtWcTp/oUkA+JrO+bfG3fgMMVK00O3h9pJrvXkSDupyAVWl9AYQYLNZkwgpTxWHbHTaRpO3+SRa4xcT+A31fuJzpoGbNqQXnIhPLnPl6E/LZ+jjtwYHZ/eHJl0iHa+kT8wW3JSbgx08kBJkE/FQW0KE25tCxOdLYM9y2A2RCtzQTaJE4jyRqDBYFQrzosGHr8FoDuSqSg7BlkpRbrLiD/fy43Xd0UFrXx53CARG4vy6pP1hyLC6zwPIOPyFUtyEBcKctZgexTs4E/u1kiGfFMHa8V6TJxxS9o0wXG6/SIA2sA6ZF6y6ksVlsNOgoAt8shp+IqTzqOcu8D5dRuwIExV30+UwFRbxICA45OYGlSYQr5RN71H3f0fxpn9ozI7wQJjrH8ffW3cu77oCQb+n+9n3XySEuKKd/4/N/n0V+N5FAJLZ6QFAtR16YtWSX5NKLAlIo2i0sS6kyjjeh+NuZmgA0hsJIKetmUTQopbzKdocgz0OYC7D3YLcAFWX8pvO7uw/1p91ZnQMtWGR6P047qv5/Fiv/gTAuaUufkSyr+2i6/z
 RG+IdHi7
 WQLOnVU5NeNUFQPPJ+fo877niHbX3w+3MEjkMDxXWh9mLScx8nl4Zu4O6+tP3ECiJjlz6HnfadhsH4k+bjumu08+p/8hp0Mvu+CHgG96enVEp4GGNKZlVmPFNoy7s010Zc8L+uTKizWlzGxMz60AwoS7SXlpdpmD6pld0bh8j0GERlDbCw6o/cyFrUtAQeXnYK3Z7wXBhRLDFsa6mMZgV9ZR07AXwpRZe3WCjMulvDIjicwZKG2WDXqLwK7gjm1mX2t9S8rqWWTMLkbQoYSinbyK/EbU/q7brbD/4DGY20tHauCgfLD6nGx8g+v8QfERO3t9U2I2z7BCpQmWd1WVXCcBElnZEzX814VHdNFJQgkaddp3Rg6uIG9mFh+DIoic96WG4sW9MfcDqt7tIWD198R+2/EIVpKc4Ctl9GLPy1rTIuCUN+xm2Ec/xgAm1XErSiyW2MiBAY6GhXemV3/78lUzRlkWe1AdPkWhYhxhVw12ANvr5DQc8RjS34mYWNRQyhvcKi7vqXR+/8l0NunnEol4ypT3MGLSG+Gffs5UPWGCdfThKtsbVL6YZ3V7PD9XOpFHx+CwMOgr6P3E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/06/25 at 09:16am, Marco Elver wrote:
> On Tue, 5 Aug 2025 at 08:23, 'Baoquan He' via kasan-dev
> <kasan-dev@googlegroups.com> wrote:
> >
> > Currently only hw_tags mode of kasan can be enabled or disabled with
> > kernel parameter kasan=on|off for built kernel. For kasan generic and
> > sw_tags mode, there's no way to disable them once kernel is built.
> > This is not convenient sometime, e.g in system kdump is configured.
> > When the 1st kernel has KASAN enabled and crash triggered to switch to
> > kdump kernel, the generic or sw_tags mode will cost much extra memory
> > for kasan shadow while in fact it's meaningless to have kasan in kdump
> > kernel.
> 
> Are you using KASAN generic or SW-tags is production?
> If in a test environment, is the overhead of the kdump kernel really
> unacceptable?

Thanks for checking this.

I don't use KASAN in production environment. But in Redhat, our CI will
run test cases on debug kernel with KASAN enabled by default. Then the
crashkernel setting will be uncertain. E.g usually crashkernel=256M is
enough for most of system. However, KASAN would make the crashkernel
reservation need to reach to 768M on one ampere arm64 system. This is
not the extra 1/8 of system ram as we expected because we have vmalloc
mapping to create shaddow too. In this case, QE or other kernel
developer who is not familiar with KASAN may need spend time to dig out
what's going on here. And they may need adjust crashkernel= value to get
an appropriate one to make system work. This is not good because we
don't need KASAN feature in kdump kernel at all while we need tackle the
unexpected crashkernel= setting.

This can be fixed with a very easy way, a knob to disable kasan in kdump
kernel can perfectly handle it.

> 
> > So this patchset moves the kasan=on|off out of hw_tags scope and into
> > common code to make it visible in generic and sw_tags mode too. Then we
> > can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
> > kasan.
> >
> > Test:
> > =====
> > I only took test on x86_64 for generic mode, and on arm64 for
> > generic, sw_tags and hw_tags mode. All of them works well.
> 
> Does it also work for CONFIG_KASAN_INLINE?

Yes, Andrey said in reply, I did investigation. You can see that
KASAN_INLINE will bloat vmlinux by ~30M. This is not a big problem of
kdump kernel.

CONFIG_KASAN_OUTLINE=y
[root@ampere-mtsnow-altra-08 linux]# ll vmlinux
-rwxr-xr-x. 1 root root 124859016 Aug  6 06:08 vmlinux
[root@ampere-mtsnow-altra-08 linux]# ll /boot/vmlinuz-*
-rwxr-xr-x. 1 root root 15938048 Aug  3 00:15 /boot/vmlinuz-0-rescue-f81ab6a509e444e3857153cfa3fc6497
-rwxr-xr-x. 1 root root 15938048 Jul 23 20:00 /boot/vmlinuz-6.15.8-200.fc42.aarch64
-rwxr-xr-x. 1 root root 20644352 Aug  6 06:11 /boot/vmlinuz-6.16.0+

CONFIG_KASAN_INLINE=y
[root@ampere-mtsnow-altra-08 linux]# ll vmlinux
-rwxr-xr-x. 1 root root 150483592 Aug  6 10:53 vmlinux
[root@ampere-mtsnow-altra-08 linux]# ll /boot/vmlinuz-* 
-rwxr-xr-x. 1 root root  15938048 Aug  3 00:15 /boot/vmlinuz-0-rescue-f81ab6a509e444e3857153cfa3fc6497
-rwxr-xr-x. 1 root root  15938048 Jul 23 20:00 /boot/vmlinuz-6.15.8-200.fc42.aarch64
-rwxr-xr-x. 1 root root  27779584 Aug  6 10:55 /boot/vmlinuz-6.16.0+

> 
> > However when I tested sw_tags on a HPE apollo arm64 machine, it always
> > breaks kernel with a KASAN bug. Even w/o this patchset applied, the bug
> > can always be seen too.
> >
> > "BUG: KASAN: invalid-access in pcpu_alloc_noprof+0x42c/0x9a8"
> >
> > I haven't got root cause of the bug, will report the bug later in
> > another thread.
> > ====
> >
> > Baoquan He (4):
> >   mm/kasan: add conditional checks in functions to return directly if
> >     kasan is disabled
> >   mm/kasan: move kasan= code to common place
> >   mm/kasan: don't initialize kasan if it's disabled
> >   mm/kasan: make kasan=on|off take effect for all three modes
> >
> >  arch/arm/mm/kasan_init.c               |  6 +++++
> >  arch/arm64/mm/kasan_init.c             |  7 ++++++
> >  arch/loongarch/mm/kasan_init.c         |  5 ++++
> >  arch/powerpc/mm/kasan/init_32.c        |  8 +++++-
> >  arch/powerpc/mm/kasan/init_book3e_64.c |  6 +++++
> >  arch/powerpc/mm/kasan/init_book3s_64.c |  6 +++++
> >  arch/riscv/mm/kasan_init.c             |  6 +++++
> >  arch/um/kernel/mem.c                   |  6 +++++
> >  arch/x86/mm/kasan_init_64.c            |  6 +++++
> >  arch/xtensa/mm/kasan_init.c            |  6 +++++
> >  include/linux/kasan-enabled.h          | 11 ++------
> >  mm/kasan/common.c                      | 27 ++++++++++++++++++++
> >  mm/kasan/generic.c                     | 20 +++++++++++++--
> >  mm/kasan/hw_tags.c                     | 35 ++------------------------
> >  mm/kasan/init.c                        |  6 +++++
> >  mm/kasan/quarantine.c                  |  3 +++
> >  mm/kasan/shadow.c                      | 23 ++++++++++++++++-
> >  mm/kasan/sw_tags.c                     |  9 +++++++
> >  18 files changed, 150 insertions(+), 46 deletions(-)
> >
> > --
> > 2.41.0
> >
> > --
> > You received this message because you are subscribed to the Google Groups "kasan-dev" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/kasan-dev/20250805062333.121553-1-bhe%40redhat.com.
> 


