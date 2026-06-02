Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77890CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 12:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B91B6B03B6; Tue,  2 Jun 2026 08:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743126B03B8; Tue,  2 Jun 2026 08:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4216B03BA; Tue,  2 Jun 2026 08:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A45B6B03B6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:33:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6815408CE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:33:48 +0000 (UTC)
X-FDA: 84834914136.28.4A1EB4A
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7217A0006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:33:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=cyoGsgYy;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780403626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fuMy8ZTlB4sZmM4SRNfS45Rtpr0e2y/Uhs3uZMD108=;
	b=eXgNzr2MOkfHcDSIGr4SiAjmt8mWvvwSb9yeSaAlX1YA2Fv7jPjcouRVX9T1iamKh31KD4
	iVSE12NlVaphkb1sk9Zd6yMOLCC5ZaTPeXXYQ7cBW8TxTWOfHAa3jUMZangl2VbWXyz72q
	4ebcJTKZ+qnntDMyL3Y88AHXqIl1894=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=cyoGsgYy;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780403627;
	b=6yFiNCQXuRQzRlr21ze+3YSFKcE1rn1hBv1aURh5QMSSiUKoV2JLfPT17POF7hslAdPsPg
	BbTAd0ut0DovySIFfjh0tmw8nEt49I/+OVgNDXW+I+ze3L/uT0DM12F2QsmM4BWwWNC/cB
	yev3/zf20GZZaXRs5FYTmbsZlK1dimI=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5175b6c4e19so15977501cf.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 05:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1780403626; x=1781008426; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3fuMy8ZTlB4sZmM4SRNfS45Rtpr0e2y/Uhs3uZMD108=;
        b=cyoGsgYy2cPt70F3ydq+UshFeH8hNSubZMt1gLbUKFTF0o54td8n5ECxfj5vH21oHF
         GMqGZW2GM6nRn2eHEezYj4SSIPG6mDhPbxNB+i7k+fouGGzCWafwFpgexbfEnqhsKbWL
         l+UHZbSz37oXkDaqQDPDLFUTalcHT+2T6Rd0Jtu/lAoWItDgBT8nBxhziPzKteY2YEhS
         5utzVoqX0wQpSuo8AwZ/8z1mMRS9NUzvQsxZGC0sh+KtdgVcCmt2QGgmGu1QEZXPBQVZ
         1lNhlCnwTk02GHKYahmrkwRjvJUk+GK7VrSX22dW0+1mHjVHRyUCv9Tzj/UdYWlf7OyB
         BRfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780403626; x=1781008426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3fuMy8ZTlB4sZmM4SRNfS45Rtpr0e2y/Uhs3uZMD108=;
        b=b6ZNohgrCd+QYJxKKDvQJEAOrGNO9OlgrOFSvAUFSInfUkPM/8pIaARgePkFOgCbTd
         Ugp4PsHUPLBozwACJfOQRY/thkVq3zu4wq2Bez673pQgxfcMhlNNsyyR837YVzCAsZfj
         cFtfYiuwV1v7f/wA0CCAhi3TR5+bOnJnpLoPMV/FdtJ/Kps4sFHu8RcxVMymXw5G0BD/
         oKFCaZ7G9FTlEqOijZQYysWkqYwWMHoJ3bzH0BVZPaoG1Tek+05vhF0ery2YuM35X+tf
         0aPguc51gbfSQLNbowolf/jxaWnhDNPMZjemK42Tx9i/4yX5245ovR7Goynq2yrfYKnQ
         T2SQ==
X-Forwarded-Encrypted: i=1; AFNElJ92HRAJXCwiLrNCRv6jbezb5GrcG8QBoVTeCJwo0w0uz7DZ+lZFjW/b6Ob1nTmLrWAXTmS+1FvJxA==@kvack.org
X-Gm-Message-State: AOJu0Yza+giBI9CCYFthrLVgcRM3HyUx8LaQFnlN1M6f97ltPawDYbHx
	trLZKPhJPNIlwtOJv/h0PxYX35l2WJSr7HZFzHs8yHJZBpv0cSS3Mp8RJqkhBs7gv9Q=
X-Gm-Gg: Acq92OHUbcT4UtWpaY4a/5z0aEDDd81pz0vSmrFh8RA5WL7wHSGmJM8HAAl5I5x6wqu
	wiqTOHVR843DZMVVSN1v3+Yvs/xGEjyy3RWxZHriq0B8TSQBvmSNyQHQWjxg/fwktFZAlvQtCJL
	THS3S4WrEX9pC1inG8THkLHAgzdq8N3VXdt65ImbmoTHLuLn4Yq6hl1rqRtSBHULwsaTrLgn/+s
	FF3OgCXyKxQxLpiVjAhTkMYWLg1xcadPiVllyJggh1tZcKFCxC0RqGtu8HUou4jHm9zjyRgqLaD
	B3kNHdF/XotecAPy0jEbDOj6LzbILmMtfXLQ1NFAAkHbIX3Oh8vZH7C55R7CHF6d6NufmrJmM0g
	HDE1p34py/F/1jM3nfrBPyOq96XqLvUcuL+aguurXU1jepkPjxqCiDl0t9awhWskphWtYp5x4b/
	kjy8nULsmrkKClKn4PkFlO8kHTUnM6TtQ+IW/3NS0OLRjc8m8n6CixAsCt2phr7TMM5sjGdDsYF
	wk6CzKjlCKQh2W+
X-Received: by 2002:a05:622a:190a:b0:509:2527:d789 with SMTP id d75a77b69052e-5173a5c05ecmr228232631cf.6.1780403625864;
        Tue, 02 Jun 2026 05:33:45 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741d6a240sm78686221cf.18.2026.06.02.05.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 05:33:45 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wUOJU-00000003m5x-3DKO;
	Tue, 02 Jun 2026 09:33:44 -0300
Date: Tue, 2 Jun 2026 09:33:44 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
	Leon Romanovsky <leon@kernel.org>,
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
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Jason Baron <jbaron@akamai.com>, Jim Cromie <jim.cromie@gmail.com>,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
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
Message-ID: <20260602123344.GG2487554@ziepe.ca>
References: <20260521133315.work.845-kees@kernel.org>
 <20260521133326.2465264-1-kees@kernel.org>
 <ah699hwLxIIOZ0-7@ashevche-desk.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah699hwLxIIOZ0-7@ashevche-desk.local>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 65tcwdfr7rtdh1xiwhqjhsj6fauqt65u
X-Rspamd-Queue-Id: D7217A0006
X-HE-Tag: 1780403626-176816
X-HE-Meta: U2FsdGVkX18FFLyKgz8zq+oPp+sAOokjWXN8Qe0S6J4g9ce9zUKqz4Fvmc7eOhVl7dEv9aGAWPHL87MIl6i973Zi3/rX9XvcnCqDx2xAVjlWgMZE9F3KKN8DrFh1+eEekf3DXETGkPJ2RPVaE3YOa0ljAX/qJqh87XnbBreqp4AqGRt1wKHs/ybda+vbMg2G2E38BNAjd6TIU9d1WQXctspRml/5dP6mYqbX8vYfD2ViFC3E5ZCcuREt7tiHM+mcGyfj+EokrjSl4PvzPbpHqsbztLZtqzG2MygywC66RF1XmlcPQQ6MyrObm6CW/mwzoaBcBUajLoh3e4rGsZIV21JlWvVJGkZRrM6RxNv6nCNp+qmPmd+WTA+0xYgO7BACEqEcYzkWtEktbLaO/YCXTyWJX8dOvdFknOPE2u44ETA56MuLlrOti8r/3qWqb/6A7HBw9RRPgeJO78bQLfAtY3mIMwnukVmSKB/efUL6TPVld/Cqxvf13tMF/bZR7epcUlAW0MZMgz3N/ADX8pvbF0tTl+URa321C86h/jSM8kPBJOJfkv/ATxw6+NfXMecteFBLeWc5IPxeXJel+0/NqLHcvK8np+DLSiWYAGQhCOX+c612kSURmOszCDkeMGCRlzyIV/TqJj4FubVna4jmZRT578o18kVnuZ3Of+BsdaOlNLyHsvRnmJmt0u/rWK84Nhy9r1lAGIroyuvwT8GYpo5pug3EeqWoX59K1HWEhlRNGamvGKAM9GrJvKEK5ob0fzfS8ddFPMjTTb2Nk6nqCJIDlQJqiv4EtECjN3EFxocY0rL+eobjkrX6B6CIg6c8dFeQhINJSIYK6pfuzMSqpWz2NGjgfbvBk9VUQB+OdynmyF8qhQrCAiMcy1RX9MyZC6jn2ykIqxCJZkpEbCB/qAKG5lUP1dJBh8qHFosZw48S67HsYsgnf9qqebmZIWLHbNWZTiBqOnKOPqvvA2d
 BpwWYQ95
 yTmPLzmNyuiO0CrDmG9NnwHleW6qrjMs5brhgOUxiirYgK9pP8D9AJEFL6fpurno81HxwJ4B/c0llFmgLdpvfCMY2+A/bBZF4VhnAvuLvZnc847322CUkXoGcbmr4eSE5fo0WLmaM+fKn8vQeJoUHHfoVNtp/0muVQxkduYhAeSKO7yn/o/Pc/hasSQHo2JVld3OScQpJnHCgIXEiG2cSAVNhMuNLpdc7SNyREuAF2rGTYsCpGEFO9jA0Zj2v3v25C3yKmJMf9ZP/ZF0S1TAPCiz5dYU8YUE0u/muP2HQleon2k0fue8dLzbhow26GsjBmarS4SkyPHqAmML/v0n7WDkRXWRUkVwXA4kWZk/2vx3VJ5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 02:26:46PM +0300, Andy Shevchenko wrote:
> On Thu, May 21, 2026 at 06:33:14AM -0700, Kees Cook wrote:
> > 
> > param_array_get() appends each element's string representation into the
> > shared sysfs page buffer by passing buffer + off to the element getter.
> > 
> > That works for getters that only write a small bounded string, but
> > param_get_charp() and similar helpers format against PAGE_SIZE from the
> > pointer they receive. Once off is non-zero, an element getter can
> > therefore write past the end of the original sysfs page buffer.
> > 
> > Collect each element into a temporary PAGE_SIZE buffer first and then
> > copy only the remaining space into the caller's page buffer.
> 
> ...
> 
> > +	elem_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> 
> get_free_page() (or how it is called)?

I thought modern mm guidance was to use kmalloc whenever possible and
not use get_free_page() unless you intend to use the struct page bits?

Jason

