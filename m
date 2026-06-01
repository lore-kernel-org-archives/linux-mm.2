Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96898CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 19:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7F8C6B04B2; Mon,  1 Jun 2026 15:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D305C6B04B3; Mon,  1 Jun 2026 15:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F1F6B04B4; Mon,  1 Jun 2026 15:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0D516B04B2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:59:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17F2B1A0681
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:59:53 +0000 (UTC)
X-FDA: 84832409466.17.A531349
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 85C601C000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:59:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jPPf1HSE;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780343991;
	b=T/i0CQFRT17ILC5QtJTPV1UzZvGvAF8IvI0ErZfeywsiVr3GsB0/4VljwtC4LTRuoC3Aqn
	eJg/a6eJ8dbdjH7sK+pMHzz2Hh19fTny2Zce7E4Tj079tVyx9x0rBB9q7RGWXjSrVXEfPT
	lzKkGiY8x/m42FTy1yjlmXYm4TVgJOM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jPPf1HSE;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780343991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNCn/hiuq2TSQD0/7268qMBjDGPldqx55TcTTgULBQo=;
	b=YTsI0hwK2HCtEV/33aipSpnmT21/Z6qPFy9eKP/YaKjBkIWr9XywSczGXKmuQ60W7c9CXv
	bw62AnXVH49nwv5VoEmFXvJlL9PxWd7j7gjXQh+bgxng16jDFlaXqC3M64oAdwyRm5OnFk
	FfdzCT4Do9/lLWIEpnp/wTIV+OZja/g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D87C601E3;
	Mon,  1 Jun 2026 19:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A8A1F00898;
	Mon,  1 Jun 2026 19:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780343990;
	bh=XNCn/hiuq2TSQD0/7268qMBjDGPldqx55TcTTgULBQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jPPf1HSEtTmrOkKgXG7yZ4L4yWlXriv9f4UInH3EUjfr7uRqEixqsswHEVJD66e/i
	 UYMnZm3AwHRFYgRV2ih8KtH9UMVsaXegF2blXd/AV6FabDLb+h4l5NmMOw9ZVrD++N
	 KcX2jHWXOHM02LWFJzDj4MfNwHTR6omd404TzjNZvpI6ZIAf59Yvhv/clTseKbIOtO
	 ETM1funcq4ukCXv67pvcGJzgYBqL/gNfgi123wCjIaYqeaTkJBGmaBAvvqiI5vVIDR
	 F9G7b/Sg9jjyGT7K98XQKfJ06MeRLxen4rImVcQChLpFwv+lALs23w52eL46/a7lq6
	 WVHwgppy+tSkw==
Date: Mon, 1 Jun 2026 12:59:49 -0700
From: Kees Cook <kees@kernel.org>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, Corey Minyard <corey@minyard.net>,
	Gabriel Somlo <somlo@cmu.edu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Jason Baron <jbaron@akamai.com>, Jim Cromie <jim.cromie@gmail.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Vinod Koul <vkoul@kernel.org>,
	Frank Li <Frank.Li@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Georgia Garcia <georgia.garcia@canonical.com>, kvm@vger.kernel.org,
	dmaengine@vger.kernel.org, linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org, linux-acpi@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net, qemu-devel@nongnu.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-pm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, netdev@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 00/11] Convert moduleparams to seq_buf
Message-ID: <202606011259.CE6E74CE@keescook>
References: <20260521133315.work.845-kees@kernel.org>
 <88c5ca1d-eeda-4023-bc7a-397b92780db9@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88c5ca1d-eeda-4023-bc7a-397b92780db9@suse.com>
X-Rspamd-Queue-Id: 85C601C000E
X-Stat-Signature: bsonz54uae5pnpd1qn5nghrhccpm8ohu
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780343991-226626
X-HE-Meta: U2FsdGVkX193yoXfG0PL/O9x9Tk/RQY/CWLYsvGJOG3cvTbJrc29sJmJnsSSKNNMPN5mRcNemGh6AD4ApHNCy/zWNe6oHXMBnKiFZEtnaoWDmc5oomP1nkm9ed7ekwGNCJzyLxr6BPpxOMaUuc1S0r4uKW4ig8WRZ7wrckAgOxUbfC9JN/qPpAutMdEXW/b8dNzw+HaQAv8sGXTbo4r6VEZtRHLsIQFCIsr5fJ0tJm2Yt8z56nXjmiupvbiAd0LDpPYCqGc02k6sg7I4uk9P9qOAabafp4yyByjb5MGYEa5322R3QYe9TN7UVkkEGuMDh7yuBEnTo8ZEOODuSoPFJLbsFkZyGEnB9Yn8HYHN1Ra017IUqn2YtaNpHIY254TcEOG3AZvxX7YRBr7TdZgwlBjxyey05Jbcaw7S5LGK7chADcO/W2DRVmGOc957V/ZpG9sPlsaZvzI9EzssxGcF58XbPuB/1TstifeLOV9WMAPn7unGRwnf/ybf+UgKtTHm1mzTS24lkFf+5Zztjr7JKEPVSsvlkOAFlqoomLnPZ284g0HqaHzx5UerQ5nBcOIgAzLNk+yQ9JL2cEf5gQfnke1Ff7IBsgTue3Pw7xVYQPmWLvf5Nn4QC8iuiyOh1TUfyI0ZcGiV5XDjSHi5pTCvWf2zCdKWghjgVZm5eXRxl2KyGbmnWJ+8LYXlVk6QeCxj5bYLpDbC+KELZcaORlyRp4Ky/ggc+bUnPt2KGLOgZVmwTuPkEzX5t9bBb0aX74+0N1gMpnYmlcrdYDYBLkuod+xD89pT7JR5hsx9DmqhLtxwSpZqQ7rrzC/CkwxR9kCyrIzO/es0LA0i8VQ4JpUIA2GrobHEgRJ8IZfdognHPPN4mFm6BtqK8LDXrCxOvPuKoCDZM6ZKuUHw5uP6KTUrYPw/YOojs3fy4W2kmh14lgVnczCFFBkofRdkI50LQMJt1x6hOYhY6Q+eRDDcCWY
 7osa+r9p
 IHXpLHJMDe/0dYEe7svnqXQ9FtdIqOZQUfo0Avfejn/E94IDbZ+645FmrtlG7JRR3LL5LMaXVUaVXqGeqH2Oq3GzaFOpbX8FafiqCvJE+aK7a/idLIYizHCZqk25bPLoGe6GVI4KgxzIVoZ7tVpz17ixQvaEYEGI/NbRrg0wue8ZxEzkSgJPG3Ea81SAm2x4i2ZUKbYpUquDXA5ieXOq9OkJTp4x4Ib1UX8anxuCKCUpYfAUuD//nDTj907+KTthKiB4tLwF9SpVe8x+mOwAcl9hKUVLDrcXM+DmqfovZMOlZ4cXWVZtb++vs2MKclfI0faZwwfY9nJgeYnesDpZY6AByP4YDfTjVH4eJTqUN3DwjafFJKkqUY7Cr0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 08:53:06AM +0200, Petr Pavlu wrote:
> On 5/21/26 3:33 PM, Kees Cook wrote:
> > Hi,
> > 
> > I tried to trim the CC list here, but it's still pretty huge...
> > 
> > We've had a long-standing issue with "write to a string pointer" callbacks
> > that don't bounds check the destination (and for which the bounds is
> > also not part of the callback prototype, even if it is "known" to be
> > PAGE_SIZE, which sysfs_emit() depends on). Both moduleparams and sysfs
> > use this pattern. As a first step, and to test the migration method,
> > migrate moduleparams first.
> > 
> > There are 2 "mechanical" treewide patches that are handled by Coccinelle:
> > - treewide: Convert struct kernel_param_ops initializers to DEFINE_KERNEL_PARAM_OPS
> > - treewide: Convert custom kernel_param_ops .get callbacks to seq_buf via cocci
> > 
> > The last treewide patch is manual, and may need to be broken up into
> > per-subsystem patches, though I'd prefer to avoid this, as it would
> > extend the migration from 1 relase to at least 2 releases. (1 to
> > release the migration infrastructure, then 1 release to collect all the
> > subsystem changes, and possibly 1 more release to remove the migration
> > infrastructure.)
> > 
> > Thoughts, questions?
> 
> This looks reasonable to me. I added a few minor comments on the patches
> but they already look solid.

Thanks for the review! I'll get a v2 prepared with your notes addressed. :)

-Kees

-- 
Kees Cook

