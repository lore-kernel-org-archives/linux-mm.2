Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B35E7CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 21:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7D26B0005; Wed, 10 Jun 2026 17:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090886B0088; Wed, 10 Jun 2026 17:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE73F6B008C; Wed, 10 Jun 2026 17:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDE696B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:06:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 616E31402DB
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:06:32 +0000 (UTC)
X-FDA: 84865236624.17.1E61D01
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 62A3820007
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:06:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IzsUM7vR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of jim.cromie@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=jim.cromie@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781125590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96czj6yri6D29TEjjpnrX0Ms962E0G1MVyGNh2o55HQ=;
	b=r7ebqMdIfxwYWnIyDFu6OUSxX+pjy/GJg0K8QCdXO8iV67QsVHJZNpjaOSY7ObrpvuU8HS
	0hdhcTjLysTzdeo/OznzX3dnsYr/wr1guCOn49q8NnMeEXjx1wQb8uvRlXYvaM1IlLXvfK
	hN/GKAyhS8bB68mcBSvjvY7qf1Xv+kw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IzsUM7vR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of jim.cromie@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=jim.cromie@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781125590;
	b=DsP3bri2VzHNsiWObvN0l+ZFewt0Ci1kaU7FGG+4fpPsNLcez2Iq/AZ6XuJceQXlOd/DxE
	FFKmZhzrpPPSIxLeI5M+vwlBLTgSZcSD2Mv0qjRPfasKiUbOrIHGHu0PcYqcBvGsiAbmVc
	2Us0L40xZBU+AE+NvQh8bzDnuRZi9Dc=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7ea16f090b4so91568537b3.2
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:06:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781125589; cv=none;
        d=google.com; s=arc-20240605;
        b=KLtYPUl3UhAGqvDdABke5t1BYKXbITiGJquk6eH88YT9lkL3C9aswUqYMhldo471Lx
         3nzC9P8AJTTlgxBKFoQjpCgbmrmeGKhlTb2zYPVlbJrNDoG5R5QxbBuJjY66uPHyC/sq
         q210BBXSY3nIRm6U4nWFOd6b1hcrWvnuZFPITTWaoATI4dabsxLCJSjVKKyFmNgBbUEQ
         jsnMfbv5NeRNqu2ZEO4Z0VQaxifSkTKuDq/KEOBilL7OVCPERYwxD6DOkoHRmJX5ngN/
         8Kij1s6uK6M3YFPmosiSbZAqwEtQtkF+xKkW75kn2z3uIxgiT4hE8uQ3oLmI5BjfrY0p
         NMog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=96czj6yri6D29TEjjpnrX0Ms962E0G1MVyGNh2o55HQ=;
        fh=CWBPCQEk9OEcn7VqydMQscwFRZF3lnu/t0qpg/5d/mE=;
        b=AFTHqmLx3T9nT/REcEuc8OpXEBgYyVcxA5WQ264BBHBsdGIU0IklSo+FQ1MoWeijtH
         g/DMOHbKcxty8ybQ3M/SO00R/3IPcKE2kso0q+69iOMEuWU5TbSyK4ChZuVl0xXGjIcH
         MHkrQuW+zFHvok9CAnwvwLPbN0ZVC+jIXiOM6wkUm2Fr7bNoIycpTLEyVpRYIh/VLETS
         1BbgTkcTbv4KvsgQCkmwSK/yA/+WXNY9iRC3N5TLL4o6G8JrYZMGrlZyteL7dJ1sWeiD
         kF/SviZnW6uy69AFEH54PRBIgnYBbokmzMFJHvZXfT2v99D3+oN6OcehLm+qPPCVATsq
         t/Kw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781125589; x=1781730389; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=96czj6yri6D29TEjjpnrX0Ms962E0G1MVyGNh2o55HQ=;
        b=IzsUM7vRiQrluxoQ1zR3vzyOarqVgikG/2/Q6gwkSDAaXT4Gf+t0yPr+CLEPuQy24g
         XF9NE+UOnB17u1Tt1tb2oMV28DMcDDX2bFXek2yYrzy42pn16lpSroS4Fwy6i7RFRLiy
         iKbtx60EULgvuth8XCF1Gp8IaqvSrs157F8jYjWGn4kubZQzrXO4o5j2EYUSxFV6VoR1
         cTVTyk3BXI+ha5jvfFI1Ei/8ZoTmCWxUgarpn4AtGq3MXz5h+3IzSV+8qdk9UR8790JN
         Xe0mv72chkYC2ZEBYTUiNGAHTDAd4VL/2G5fMJ7nwK/YUUW49cRM10RTkvR+sv5zpQUT
         dOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781125589; x=1781730389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=96czj6yri6D29TEjjpnrX0Ms962E0G1MVyGNh2o55HQ=;
        b=AmsdQ93JHpB5bC2N8y8iK6/xwWOVyX9Nsi4DtR/CcMIBcZQkT0yDB1BSwZpCxGLh3y
         rbsVbgWL+MBU8cULmOwI/q5CRRieRFKccJf4U6WQXHlIJosNc1kTqs6qB/bVTBOPySPH
         D51XJ+KIaPoa+I48MzzcamqD5GYzJA0gUw7bFeYh4+wmVgnaXdvz1Tqk1Ch4Ai62dXOw
         vCMZeZMULkOfmyufYfMsxVlzRuldYpl17Lwyj1yHdMLxgbVm5ZCsugSe7/LJjhF1wlvh
         cS6KPU+tg33unixcpLW1vctmx2DjlhQU7gnT4F3PVdHD+6uShflzSAO6eD41s53T9bpp
         4TbQ==
X-Forwarded-Encrypted: i=1; AFNElJ/NY/95jVZqs/G1zI4F7yia2DGW5KQ9HFnu9kPCngwfbpbqUaP5bf5SG4netKB478hxe/vxVGTeHQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3SD4M919cznfHQaoRkF9O1W2M8oI4uCKixfEu4ZTfTy55T4o6
	f+IST4i/Zuc/KmX0+wolUgJsOSILDudQVvlGxjawUo+cjcqDwj06jYYqKxnxYpAcPnga8TLc6dy
	IgfuG4tXJBBNMCy7d81+X/j3Lzg85UNI=
X-Gm-Gg: Acq92OGB5NCI1QBYLySU/NLDhQnRiFnrVvxwk4JI36JE6atw1rD7rlRVEIk5U3RPGtc
	p3a+vZk9/Ehw6FcGYpEhv+5Fd8IHvmfrvlTe+1jDSQA60LypcDf6DyYm2E53xBH53nOWvmTGl0h
	ppPrFdk8s+ip7ov4v7yf4JwNrVzdZwQgv3xJJcIok6prQOkexeStpS7nognHE7MB1/JPp9+IJdM
	DyttgA7giUxudm6r8I/KN54NzOI3N/R9/F4tlm0TM0OtcLT6PJMYpMOPMTXC0o5t4HOorDyLWuS
	8PYh0+PwSMJ3OkVTFV6+Qb+25Q==
X-Received: by 2002:a05:690c:45c5:b0:7e9:ab56:3c99 with SMTP id
 00721157ae682-7ed0adbb616mr276188567b3.6.1781125589039; Wed, 10 Jun 2026
 14:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260521133315.work.845-kees@kernel.org> <20260521133326.2465264-4-kees@kernel.org>
 <da358ae1-91b4-4a16-ac76-ffab99c230b9@suse.com>
In-Reply-To: <da358ae1-91b4-4a16-ac76-ffab99c230b9@suse.com>
From: jim.cromie@gmail.com
Date: Wed, 10 Jun 2026 15:06:02 -0600
X-Gm-Features: AVVi8CcLXClq9Fijm8VjZF47hQWmos5q_iXrehNZDw9kSOby-E_cMxEQI0SK-hU
Message-ID: <CAJfuBxwRuT1K=rjPX+sdNyYurEJ=OjqbJaSa_S6JnY6yzTwTvQ@mail.gmail.com>
Subject: Re: [PATCH 04/11] treewide: Convert struct kernel_param_ops
 initializers to DEFINE_KERNEL_PARAM_OPS
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Pengpeng Hou <pengpeng@iscas.ac.cn>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, Corey Minyard <corey@minyard.net>, 
	Gabriel Somlo <somlo@cmu.edu>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
	Hans de Goede <hansg@kernel.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Daniel Lezcano <daniel.lezcano@kernel.org>, 
	Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Alan Stern <stern@rowland.harvard.edu>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Jason Baron <jbaron@akamai.com>, Tiwei Bie <tiwei.btw@antgroup.com>, 
	Benjamin Berg <benjamin.berg@intel.com>, =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, 
	"David E. Box" <david.e.box@linux.intel.com>, "Maciej W. Rozycki" <macro@orcam.me.uk>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	John Johansen <john.johansen@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, kvm@vger.kernel.org, 
	dmaengine@vger.kernel.org, linux-modules@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-um@lists.infradead.org, 
	linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net, 
	qemu-devel@nongnu.org, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-serial@vger.kernel.org, 
	linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, netdev@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: apqend74dc3ky54zaaq199yt4sh3w5au
X-Rspamd-Queue-Id: 62A3820007
X-HE-Tag: 1781125590-549807
X-HE-Meta: U2FsdGVkX1/jvx3vN4a+2EimEY6okiM09QdBZfKF8rIWP/uCzTkV16x4NUkkqUa9G3TTkK/HctGUYPyLrNS78MiDhC1+t8HWgd7t/HPuRbAN8c/T4aHNON9uB2NJ+O2eFxLAXlcTL3foERusYiKdFtDChzITrCFMxl5QqL8x39Qok/IShcNKw/mRpc7tY/Fpo1D7yzt45JE9cdEXHaBEUNnnLTTJSppiaY0qfg/8NeStYnKgFy232PSGDlit4vR2cTgLuqeiv97BetxSlKl2bG7r/tu9YIj8YjyzqV39efCRWsr0whbTS3K1zDjsdK3Nu0cNor2E0totJu536SlNd3tawd0qkHiBPTvYlmrSAJlelyTe5Kzke2MNB71dl+yjTdI5dLGpzUxDQTGkvE1lyho4VWBOLKBM+1gnIs2XyGF35/P8WdLB8STF/1FCn41Xz80yVF6ADjMpGZoJg4V8sqPQbtlqv1lUTTJV1KEoBOx70r/A8KUCRfnji7iFoqI6hIRqnjf1QpKQKd7D57Z9BYXujm8vHrv26pKwXxXWuPQe4F9+bHoaj4z+EyyqfKyV50MYmmByD/QfVCyYU+hFPgBYGc/eVNjlJQYCsa7yb4awfBNJSKhfHCLERuUx8suVr9Yz280cZqDENNgx+TKHCAoKZOlOrLibQMusFHWKLSojm5BwxJDLy22FYed4PD7KJawxf/Txd+XNivnak429TPJ1KVTm0QwieRSiXMPcz12UjBWVQSLy16ZxupuAluVNj+Zzr8IEVvN/6Su7ZU0OSxXZbxthqqN0J5TlSyjmXzWTH0m4oyh6ij0ynFxBqza1RJLYP3yOiwgbEE7e+wyeAGgWnVVfaEuaWZ0DYFguXDcLexOUZI4pZ2+p6b/Db34ZBjj426ezktUCBMeSRvVjq/bgj5koAJEqybg2KcqAJEfZP+D+ZaDQuFqRGg++taW005KlemBkBNXOm/CELIN
 ic0zvD4B
 kUOPpiERw23fwgIBkSwWFChnSkz2Ol8B5woKRRJcj5J7ciYpHhwshmxb4MaL8Ui2Mjlh3dPP0XYf2/O5Y1vehabTVFgODJnTKvH65CnZRfTmj7MwVWzhFIMIPW2OebsIfzwYUk3z1zK6AN11qV++XAqN3jiramvXesYi3Xjdt7mAYpqk9ahIJVl+JxNijoKuqh/QB1wvcMzaDzmjF+d3hElmU4O0V/iS+0tFcTvIah3N4wF0JhdkiK0KjbIaTTzkwonVwzvcfDShSFfbLgAStpuRdGnhU9hywf1cAxqT7i3h/v5Y9JxUp8jDT4azkiERUA2L84uBOERlon00jqgLqgyxduqXduxnrgs6hSJF4srpM53JB9SuG6FM6AEAwploCb22Mr1qjhfr4awYoKa+d1EtAuzsQAQaIhJls3BsfauSBC/PFetgx/tCT1a7RdkFCzkbRvlSQUhj9RBUR4JQcl6NzRJFETl5w9yBktzu/WcwKJvyDVClvePxeBUjn5aEkLaHkEQ0vlnFusJvgNw7n+wc6aL/Whcu/8BAlF8985boeFXWGmIqHTmN+1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 7:35=E2=80=AFAM Petr Pavlu <petr.pavlu@suse.com> wr=
ote:
>
> On 5/21/26 3:33 PM, Kees Cook wrote:
> > Using Coccinelle, rewrite every struct kernel_param_ops initializer tha=
t
> > sets .get into a DEFINE_KERNEL_PARAM_OPS-family macro invocation,
> > for example:
> >
> > @@
> > declarer name DEFINE_KERNEL_PARAM_OPS;
> > identifier OPS;
> > expression SET, GET;
> > @@
> > - const struct kernel_param_ops OPS =3D {
> > -       .set =3D SET,
> > -       .get =3D GET,
> > - };
> > + DEFINE_KERNEL_PARAM_OPS(OPS, SET, GET);
> >
> > Using the macro for initialization means future changes can manipulate
> > the struct layout and callback prototypes without having to change ever=
y
> > initializer.
>
> Nit: For consistency, I suggest also converting the few remaining
> kernel_param_ops instances that specify only .set and no .get, such as
> simdisk_param_ops_filename.
>
> --
> Thanks,
> Petr

for the dynamic-debug changes

Reviewed-by: Jim Cromie <jim.cromie@gmail.com>

