Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC02CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F82E6B00D6; Fri, 22 May 2026 20:38:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9466B00D7; Fri, 22 May 2026 20:38:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470E56B00DB; Fri, 22 May 2026 20:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 340566B00D6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:38:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4661140A23
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:38:11 +0000 (UTC)
X-FDA: 84796822782.09.2433049
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1F648180006
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:38:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/qwAMS1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779496690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ke0QgGP72oU1/KHDzVSs1lh/gkg7Mw8fFDTolKbzoHA=;
	b=e4yaDfMvounah/ISSRwGnyHJgQQPD2s4x4KQ5q2Xpy6NZdXB447y4n1V2XH7ENRBfakw2g
	hiMwajVBDmTIptBPG6hOIPR/O7SrhVtpzsagBJy5UgXX0Wn5w5dRibVCBxCXkY7VxNMmOv
	/3RaX4hMbmpk1iLIY69D4m3qv+d/vkM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/qwAMS1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779496690; a=rsa-sha256;
	cv=none;
	b=F0sacWWg5XWxflrfE8z1O2/pk+vVTB3aVuVvnIgZ30cG4m9KBOjhCGGoYnW7peyr7Cdzvw
	XYnYZz1SmNAN4pXQ71CIxA8ru6AUqpZQfKnZ61uGczxkofRlQZGt/34aWRvgd4CAZuK2p4
	rrclFpjausq9LX4Hqhmzby2Eox5KZRo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7697440390;
	Sat, 23 May 2026 00:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCE81F000E9;
	Sat, 23 May 2026 00:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779496688;
	bh=ke0QgGP72oU1/KHDzVSs1lh/gkg7Mw8fFDTolKbzoHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/qwAMS1ok+56HAwvYiYz0R5wmKsD0RscuUhy5BVEzThMnr+wQxbKIW0Yk+lqtg0R
	 dxN4FM+nLAHenqFi1JvSelOt20CYFnYpdSX3hvz5/mvzq/JXO7gcBTjSStG/A5FM8j
	 0Dk4RFZ90/nX0Xzby8V+5D3uQDTYP8o1bo3XSKlx4rKPB6vCO/Oui18woqanoP+n4U
	 enXhw+/EJeP6Kw2ZiII29eiMOdyHFC3VD0U1T97Mm+aD6rZa6A+hyeA7zcgLPdsptw
	 8LWGxoojes1mewesgkVxxy+dLIhtJlwu3XyRYodcKxBzIRSnWjQs++a/owD5p2CmBM
	 RNz3sazG7iMhQ==
From: SeongJae Park <sj@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Corey Minyard <corey@minyard.net>,
	Gabriel Somlo <somlo@cmu.edu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Baron <jbaron@akamai.com>,
	Jim Cromie <jim.cromie@gmail.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	kvm@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	qemu-devel@nongnu.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 04/11] treewide: Convert struct kernel_param_ops initializers to DEFINE_KERNEL_PARAM_OPS
Date: Fri, 22 May 2026 17:38:01 -0700
Message-ID: <20260523003801.86344-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521133326.2465264-4-kees@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bnwmhcj3sur7u3py63cyi5mrw6dzg3tp
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F648180006
X-Rspam-User: 
X-HE-Tag: 1779496689-227246
X-HE-Meta: U2FsdGVkX1/XCEKeOF0+s2eT6jbBvNYf1VEYhPtebzGj5GBWb81gGMaaxIZ4mT9/HznQ08Y2DLwBcerZgVh5mJ17SkA9SuzfxHmF/F4DxQgwe9mF+xnbWZ5wUllGpdfGC9phW8COnGfcVc9VT/qRBMPpxzpP5JROb/EcWjJN/oNf8YfN1CCoGnKVkT1FC4U2Qs9+0MgBjcCt1ligpwCWDCaARNeMuMIBq62KtM/YgZhW8WBWNBSJMoFo0nzgPE4LUvPzS+W/1GDoKKE/RBSn0k4az4jsJo7+qnGnW0JaBgpI5KyENJxUSy69AkMu3rfN9xoLHJ2fsYpXG9Pk3483OKGLhoXD3a99hdr0sK62nni3zCkk0JXwDPvjnnHxYUSgCD2v1w80m2isc+twopPR+m+1s+2Ro/qxmosz8cenMKy1GRiSDJMtqPuIUr4s3rAWrlqNVOztO+5RBb6mKT1+es22GKCJWFRstmsYvpPSG+bNjrH62oacQ6pgrDf1PDY4EjooWrld+Xo/AMbn+HjgQw3O/LpMNGgK/T0DJI/6HUdsP3CSDjhbyJg4cH16tB5HEJdt+z7P9P37nW2Clp4JvNQwFT4hv79gEOYIIEGSCOpsxP6uO40JPqGf3z1h/rUmamGdvy+nrGi2OM0ctuq6RmW7QA0EiQpA8XnQ8+SZh4ltZ1cKthZdyRoAZ4ekK4g2K8+lWz2PVZYOpfD+3hSR7vVES+5R4bYZWcdDikNdGtPSdRsg22Hi3lDh5p6EHF2ZrSFHm2fk5at1BZ8EFodCxr0jC/f8Bq3w8hKU3zksrcD15V+tz58/Wx0RfiOXGKM6fpiCwee+u2EUOt2ECMVrx0jRcCmChONwPW1bmMh3AETI4/R50jbdbQnmCdF4UcCj1zmZuxkg4fApNxHqhH1aQ3oJWt51FjgM9jACkVjTI0dmQ8CRwbbKUwOSO+IG7GrLYKm7N5DJzz/X/f1j9ni
 qxeT7cs1
 B7Nylvs+mJ23cn3vgdI8woEywE9rtbG7oIq8RzcsRlI6Vrh2nCQX2OfpdFJ2Yne7lpoobmVEjPRRlAOuOF6hHIJTTyPBlO1aMBWVaQoLmvLeA/xamPKCk7N1qPZy/LR0Am5geUZzkHfsZyGXX1pF0M/U5v2XbH7V9jXbqZra/n7wAKva3Wh/Y7Udb7jhhZnp18FJCCQV3UirSPkzp2pJK2Vrz26xoWhEN0S4VymgAarSduLLinfkktEUdC6QRW1t6XM/fy+6T2YbypUqDuKoN+O7p4Ijt+CmXDF7QJZmRLnTX6WlykzAuxBdJ0evHd1TPN+HdXdBHgr+nIemEW2XZRqetz1WBPOwDiaG1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 06:33:17 -0700 Kees Cook <kees@kernel.org> wrote:

> Using Coccinelle, rewrite every struct kernel_param_ops initializer that
> sets .get into a DEFINE_KERNEL_PARAM_OPS-family macro invocation,
> for example:
> 
> @@
> declarer name DEFINE_KERNEL_PARAM_OPS;
> identifier OPS;
> expression SET, GET;
> @@
> - const struct kernel_param_ops OPS = {
> -       .set = SET,
> -       .get = GET,
> - };
> + DEFINE_KERNEL_PARAM_OPS(OPS, SET, GET);
> 
> Using the macro for initialization means future changes can manipulate
> the struct layout and callback prototypes without having to change every
> initializer.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
[...]
>  mm/damon/lru_sort.c                           | 19 ++---
>  mm/damon/reclaim.c                            | 19 ++---
>  mm/damon/stat.c                               |  6 +-
[...]
>  samples/damon/mtier.c                         |  6 +-
>  samples/damon/prcl.c                          |  6 +-
>  samples/damon/wsse.c                          |  6 +-

For the above DAMON part changes,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

