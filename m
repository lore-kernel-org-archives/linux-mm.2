Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC32CD5BB4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53EF06B008A; Thu, 21 May 2026 09:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EFA36B0092; Thu, 21 May 2026 09:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3900C6B0093; Thu, 21 May 2026 09:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 291FE6B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:59:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8B9E14065A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:59:37 +0000 (UTC)
X-FDA: 84791584794.24.11B4CEA
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 263C8120006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:59:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h4lYce5j;
	spf=pass (imf29.hostedemail.com: domain of 3xQ8PagYKCHgoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3xQ8PagYKCHgoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779371976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqeEG6FXEKElqAGUt/Z2qfbIbuB++N7b4Fh1Zt6D5dk=;
	b=knktPfoKzCG7urkZ+mSGSCPawXAXVkKDUNB64f81ErZ9HVEQ8Pma0SFxJ5/N4P3d8fItPU
	nDvH+TYJpv9C9iHq/d462F7xkkA2PmrtoUmQkwbfhDiPjhphq/yj07yfb40uAOUDv+qaP7
	y3fNunzOS9+2+XaKNUfjE72l0HyvOLQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h4lYce5j;
	spf=pass (imf29.hostedemail.com: domain of 3xQ8PagYKCHgoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3xQ8PagYKCHgoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779371976; a=rsa-sha256;
	cv=none;
	b=1RGGK/2Pd/IK4S+RqIsgtd6VFVE1c8snN+bbwD55LqHtBdmpgJFG3lq2lW2FvJBPeI7qXC
	ZE1WvsiOgfZrWgy0JBpZ9xv7T4Kuz2wU6ODYpnyc+SWyXuPWAS2oiY4gP4Hvpe60oLAI6M
	OZUxecpOxqe5ZTMjDqNP4M6KyuFL6Ho=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c709551ec08so9438513a12.3
        for <linux-mm@kvack.org>; Thu, 21 May 2026 06:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779371975; x=1779976775; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tqeEG6FXEKElqAGUt/Z2qfbIbuB++N7b4Fh1Zt6D5dk=;
        b=h4lYce5jFiogLWW9+fiCWBswizHTROT32in8AlkYkzFms7fua8mWq0TWoy50YB5/yw
         KpNpfQ9cT3LxnrZbW5PLSJOHjG6ydXLLpmch2XnAbkp0y99ytJ3WQ1TH6d+2x0FK02To
         5qKEXlqTGE3nthGkPs4CUjumWP1qfRXI0SqEzu1e5+rXzZ9u6RfUCA5aKD7ju4gAznKr
         /JE037sjfPQSiZneBml2dAecL0W1XRU2EhPol/QprZ2aPGlrqst3Lhd40wo+7kwLk2uM
         eNw2qr45m0RYV8G37dte28z3VAUh8e6ShGfv4a1DAxWZiEs+s3qF/DtgIKO075vLyIRe
         CYxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779371975; x=1779976775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tqeEG6FXEKElqAGUt/Z2qfbIbuB++N7b4Fh1Zt6D5dk=;
        b=Z7poBLO5M3vf6T82GcdQ8qdY/QL/MO40+B5p6mKOEGP78rbvCB5VxQQ7bB+w0BHtHF
         NY2tgf178lrv9QqcAJbNFOK1xd/Ksl7ne447oLgQzXeaZD3dHf6fr5e9PRL+9O5RAfl5
         BWnghaw7xC756Abdn3DzsL6RAr4OHoTMBEVgSDIr56h/HJExF+LTo81Qe1k3gDCZuSfn
         010h5+avvDM6lNAGu3Z2zZJtkf0qYKE7M0lQtXV2vD/yKiZis7TlsLwykO1hqQ6uX2rd
         duwX2fXZUSWWW8hho/AfmwhURvDxeDJIkUkXu6lsclOGPsUSU3ww55ixJjBwIUDrW6Zw
         QJYw==
X-Forwarded-Encrypted: i=1; AFNElJ+p37Ds76GnidcZ6aQyU/XO/WgRhCdUHg5jgypPMLkDRTG3KliDwBuLehXnV3ZafM1J/SyMfvrB+w==@kvack.org
X-Gm-Message-State: AOJu0Yz/poG8MBXThiUvQ22lzul6tVst91hQ654P0EXuPnLitWC4c15B
	bALCCt0J6nyNJAXJo3EFThkbQK+Wwsx1W8QUXzQzLQ7kPj1hZxIJL0gem8likkvU2qZxQ2WRleL
	y93PoDQ==
X-Received: from pge1.prod.google.com ([2002:a05:6a02:2d01:b0:c79:83b3:cdf8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:431a:b0:39c:a78e:dba9
 with SMTP id adf61e73a8af0-3b308ac1b14mr3725831637.40.1779371973881; Thu, 21
 May 2026 06:59:33 -0700 (PDT)
Date: Thu, 21 May 2026 06:59:33 -0700
In-Reply-To: <20260521133326.2465264-4-kees@kernel.org>
Mime-Version: 1.0
References: <20260521133315.work.845-kees@kernel.org> <20260521133326.2465264-4-kees@kernel.org>
Message-ID: <ag8PxTTi5NxT51EW@google.com>
Subject: Re: [PATCH 04/11] treewide: Convert struct kernel_param_ops
 initializers to DEFINE_KERNEL_PARAM_OPS
From: Sean Christopherson <seanjc@google.com>
To: Kees Cook <kees@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Pengpeng Hou <pengpeng@iscas.ac.cn>, 
	Petr Pavlu <petr.pavlu@suse.com>, Richard Weinberger <richard@nod.at>, 
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
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"Eugenio =?utf-8?B?UMOpcmV6?=" <eperezma@redhat.com>, Jason Baron <jbaron@akamai.com>, 
	Jim Cromie <jim.cromie@gmail.com>, Tiwei Bie <tiwei.btw@antgroup.com>, 
	Benjamin Berg <benjamin.berg@intel.com>, 
	"Ilpo =?utf-8?B?SsOkcnZpbmVu?=" <ilpo.jarvinen@linux.intel.com>, 
	"David E. Box" <david.e.box@linux.intel.com>, "Maciej W. Rozycki" <macro@orcam.me.uk>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: tou5uxna1wgpuoxp6ckxjrxiyss1nu9m
X-Rspamd-Queue-Id: 263C8120006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779371975-977690
X-HE-Meta: U2FsdGVkX1+kKEJijAFhUSgrL8q3hXrIwi7NXRyQhIF/qmPQqm28mw0hpoTOl4UjTMznbI575UAnJrW2oJCnx+SgelXFGGYcVu4PzA/51p5YR97/bBe8JTydJTkrdzoa+UKApa3vNYoByFp0u5ah7edcKJGWQAlNK9+TSyqRqXE1y3+nbh+Um2G4g8sOqSauE6aFTHIRPPHg+gEzKXdv/js8nMou0ZA8qyA1C1IdT+y+9RFgCoLWSCJfvi7vCkOAWLTuKbksM/8JIs8NTVpL/rvxErlkTUAa1sag2vrvRkUv6RwJbGj0IJd6ZoMU2KC/FXqQyrtay3+L/fiLQldIOlEyBYG1IGRYfIRczMK5pdlN8AapAUBGipuXDCMUGrOkzBELwhWnpdewXtHe05Kfvgq1dRl8K04PwVvqolnEetPZAJDkR32uQLWyS3Wf7+vKh4MwhzpK271Dd8EfflD8izyf/FAvWP7sKSfhyvtNDGmMNMp/2ijBodyUmcAeCzwiR1DMCiNukLc1Mdex4NxU4ugPdGPaWtQ1HtvmgB9HEd1GwCsw6ZnuMxPypRoSJNHxI+O6AID9BxhyfCKubDCcsAVfoWhHwA32RIWfZ0gjod1i0xQcPVdXGduBCQHEgMXIXA7u4Io40bamMx7EXgxp/8U5btPX1PzbMWkTGL+MvDBCL/Q+CNsxSwT8XaOQigOCuDj90/ZgDqdpxmD1Oxh09WaAx7RiMdgyL5TRILgWrp36KTYeJdqa1LPxBXI32vzvlmefesuai1DCKHVpfKg0u1gCyxZXjTrFzYwb7gIVrxDQZ7T0XKLoTj0zmGZGItqn87X7xxUbsBx98C0yJFO2NUPrhtSFddBIK6/la2w/nUwP6zzj2w7fBdA/qe3AB+wLEqZKjUlrK71LuPSJ1vbtDqH9cc10mrey1FqW5++bCxvVg7w/dLaLf2MfcxpvPLGkFztzVDz9hc1Eqbo/bvG
 r10fjqU1
 4u9vjmOb6+zfOGAKAY3CTbTEr1ZRC4kMo7iUZEOtCSwL6+W4qJLrOr/rHLVkFG6823L9/ilZ2BUeE6Gli/Uzs5qSk5hi0ZpXwdhIxMAhRwnxrComcsA2QWPsCGogKTFV97Zk1unepsowYDhOonjoCQjckVl4X0+N6zxlJpzfvPDIt7flaaTf8OWyZbz2pmRxNG4mgMZKpOoOdDM3Mr2OqpLuBI69ebFi3JCcVCdMpklbl4OuaOTul5bxeeWo4hLsbnZVrJTmPgKSTwLrLWHxn8UBMjpABIY3S2P9pyLj+0lPdWVeWIvvLpbs1eVUNOgLjGYd1kFzsWg2aiyTVM1cUePppAachv91OaUCwlPTZBJ6ol4Ucd9kQrFVSd63AqNq80mAI9iRURfZuK5WrY0HYJ7y8muz+3rx4VOyMj8cji1MLME42cLaqeiVZTNJ8QNo5Op6KfvZ9gba3ZJzf+chPBdeQ7hH5YAJTkpT3LiKxSHS4q4Z1E+okkUs/huolgm2ormBYpbl0JirMePthYZDMFnrt0lPRIW0fB3I77khQO5Ho/A8BPYaaqCBxuh5Dk2wQqlvRCmjbb3jjAy5/MA1WVdWQ4BoFFshcig7nFetdGlJbp91EIRhsuPmhu9qSTmpcQbclvOaGGN22Xw/Y98vRxBF/H7VWGh2iruQN99kyh4uBTJ6r2ibRYhddxFKs4Z1zVjmOJqic7xSeS/qDJnbJPGKHxkMwMuxg9YBUdc6FyipTotrwyvbMe00HIwU4g2hoZMRnsu6BNLaL8HoUFFqHhKGERCfC2+/NpacG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026, Kees Cook wrote:
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

IMO, "OPS, GET, SET" is more intuitive, especially since that's the order used
by DEFINE_SIMPLE_ATTRIBUTE and DEFINE_DEBUGFS_ATTRIBUTE.

