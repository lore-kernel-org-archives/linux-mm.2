Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28FCDCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 20:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5687C6B04C0; Mon,  1 Jun 2026 16:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540256B04C1; Mon,  1 Jun 2026 16:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456166B04C2; Mon,  1 Jun 2026 16:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3878C6B04C0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:24:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6D3C1A072D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:24:57 +0000 (UTC)
X-FDA: 84832472634.20.47BFEC8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id E5B1C120009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:24:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="JD/rgItE";
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780345495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/5W0G6Gs1Q9GB3IxcldPERQvThA7tz7U249bqa4a9U=;
	b=Wvyhev63nnWSgjiT0jIslbva6tDiPQtgpegkq2qOJ5Xg8F0qNpVHQ3Hon0eC/0JfGs1atz
	ElgR3L5m+lUtKx3JMzg1meS0/SzhdKEAsbH+s6kpiRWS7GIIX7BFnyUbxHLaT19kVANPFD
	V8k7uMpmbuqSH5K5CCNvQXIpSCN++80=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780345495;
	b=7WO058Gh5PvEONP2hppM7/g/tbQaAl57fs7yQNQDE79exLmww1RlZrBUyvxFEZgWtFBzh/
	Y0gjxq0GC5cjdbh+KaFrBVtYjQHLNwkXK1OzuzOpr2wafZtsa6PpZAV4Tx1V94yfAklwYu
	nCu3/xSrn8h5ta8a/qXPrfhCI+zVbDM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="JD/rgItE";
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6/5W0G6Gs1Q9GB3IxcldPERQvThA7tz7U249bqa4a9U=; b=JD/rgItEItTF3waKZU0fyhZfOO
	p6KhOF2dIKsWbBlXDH6Szda6v6pwxYE0KSLQ6p9Jvu4aC0kMd1Jp91bHbXXGW1JY4kLAuzDZFSXs9
	P7bQk5/xrqJRa6GrGWdxnMhnM9cOr/Mh7DhOreUlDgBnF2TcRdtGfQbRd9WsBVDwHFqfKKNmW2p+o
	Eq81r5ZCto6v0j62Ti/4LX0nmYsBAqhcbZ6JenvK3VL8pcuJJabuzAf2wJL1ohACsCSDs/sp5+nbD
	m2tuZulS6JhmLQAZ2oWemvoJrOfuaHp1Sctzmp2YTWfFeramTBO8sylg/IQVtL1hc2i3NQH4Kt9qQ
	+ovW+CfA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU9Av-00000000iHG-2DOC;
	Mon, 01 Jun 2026 20:23:53 +0000
Date: Mon, 1 Jun 2026 21:23:53 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>, stable@vger.kernel.org,
	Petr Pavlu <petr.pavlu@suse.com>,
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
Subject: Re: [PATCH 01/11] params: bound array element output to the caller's
 page buffer
Message-ID: <ah3qWZ4cqhrbHZcl@casper.infradead.org>
References: <20260521133315.work.845-kees@kernel.org>
 <20260521133326.2465264-1-kees@kernel.org>
 <20260521174631.71a06440@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521174631.71a06440@pumpkin>
X-Rspamd-Queue-Id: E5B1C120009
X-Rspam-User: 
X-Stat-Signature: oifah6z97grkk3up6k8799jx5kf4bzf8
X-Rspamd-Server: rspam08
X-HE-Tag: 1780345495-7262
X-HE-Meta: U2FsdGVkX18WwQTGoug+JaMx7sWWdJVs5vCceg+xlspJVMoVKBYeD+sdeqb9MwjBEhOzXlnpjfn9csqtmGA8B6AXhEmTm8xPdKTxKahtyDtXyxq8dkBzENDwAz5S5TRudtWp76XKvtxa97A7C1PrnagxT+iiAW7C8lXa0nBCrTZ5NA3RpZMA44IYYKN76WMQsQsnbs8D8/jBlM35Wg4uY7LRG6dtTE/RRTXvlhR7hTRPki1Nkfyj7HdQNtvwkNRAvpnKjGvH6ExSFxZTKQ3vdv5evi+jbwAFPvmtlAOJ1stblny0lqnI4dzYSyahKsWSiGjV/wAJDll/qjE5FSrp2IBTGnEY28xdKLXaUV3yptAo+YQpewrVdc33uFryIGWDIs6O0xVL5Y5ygwmn6/qH6SdFk0BS0tTwik9q/QTlCQnkV81ZHsozuec8YpRR7VwpPiKoAhYrVOu+/Bt3hKlSycwZnKm0IoVPHhz0WFqqVrsgvllpIbjcdUgjI0wx/v395hbOBI4ZiCZzg18+5Z4j/NB5Jxd+I2vmYLnDP8mr0vx+IYv+kvQBoVhPXhu7SPsmObogDO5kJWnA2fMe/w7O+uXmxF/qmV/+/ROKAdCEuQ0X3M+GMn68ROYmhDSHGpSWxumk/8EqfglU7WtIiziFn2sKwt9o1+MTRwE9bHCkAV6pxII27WGdv6WMIgxfEYj9QsAseQX6DYqhcvezHvc/vjb+KxSV5LyjNDXLh27XMS5YrYDL0zPKd2mHt/DokOD5AREEhNJdnC5Wci8pMgS6xe9yJlftPc4xiqU8w3Xh2P7CrPwN9HJfvohgdD0iY/dDSYjDZW53OJltqDaABZP8hIPusl9aMcuTPB9/3tgQ51POu0IdbXLJ0dx1CazhN3mI/jmlHxoUHmKOQrGi4Qr4ZT3vM6cRvfnz0wTfKTuMZL0vYHuaHiAu4ZRIETeTmrkwAhoPBYK+3m6XJ6dUqrV
 bUIiZhA2
 Yk58jBX6+Ke1ZCZCo/t3qW60akYn9n9TfaM67KceItPJVp9HoHXAUR89ACN1507O2QMBwIVxIIEogX0iGobFvFVoyYFZF3rhfwaZ63UkhNUTGcoulFYMbsxO/pBQyw5cb/+DhwuFExV+T62+oz1aTLb66Cpmi4TgnRJ1pLTCKEdC9Ikgh6OS9chx3ODYmHx5aUYZxh+dUxqAuJgVrCC2Oz0+GItzonUJXrpr/GMDd60Hpal8AgqEFKe1XQay7azBuvoXWPPk8ygaORWhj+vR0H6UKYfa/nqVa5A421++WHvz9AyYlKioY5xhxJonsO1YMVqWV7rDabL5QrHQ8eRoCYj/DQa7N30APlPu1+eTwJ5uaBi6Byl3UMoTqIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 05:46:31PM +0100, David Laight wrote:
> On Thu, 21 May 2026 06:33:14 -0700
> Kees Cook <kees@kernel.org> wrote:
> > Collect each element into a temporary PAGE_SIZE buffer first and then
> > copy only the remaining space into the caller's page buffer.
> 
> Should this be using a 4k buffer on all architectures?
> Initially perhaps just using a different name for the constant until
> all the associated PAGE_SIZE limits have been removed.

If we're acually going to think about this, even 4KiB is too big.
An 80x25 terminal is 2000 bytes (assuming no utf8), so 4KiB is two
entire screenfuls.  Limiting to 2048 would seem reasonable to me.

