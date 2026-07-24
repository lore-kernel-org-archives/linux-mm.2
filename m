Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 631B3C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 21:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A2236B008A; Fri, 24 Jul 2026 17:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C376B008C; Fri, 24 Jul 2026 17:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11CA6B0092; Fri, 24 Jul 2026 17:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4E866B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 17:54:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 360801601A3
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 21:54:42 +0000 (UTC)
X-FDA: 85025025204.01.96A353F
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 48684140003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 21:54:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T+Q282iZ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784930080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/VuhMIt3y5/j6Le1Z4BNgwX3UBNQKNT5cbNU5pubERw=;
	b=gtEOWdxKOEhh7d73A3EK/uFfqPW/z0shzDwH4aL7j3XD5xNxZQ1uQEQZZbVWscniJXx6v9
	S8jqsd7f8kFqoIoDBjEHwWARfjnv9aEbBYbGJYyFabd7U2CZh+jfXwQBQAOjqDCbtnhUub
	ckpY2Jpc3zjfJ+lxRGxsQek6JncVp7E=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T+Q282iZ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784930080;
	b=v264pyi9C9Nym8c5/xAgUrkhI/TOkr8zE+3CgY6ahWgRvrlDEwhmolpSQlFvxP9/VONoVo
	PeGT18N4DV1sfevXw0QixJEXqFsxdm1/3K1scXrpIfoipLVO5iFq7mwxWu6d8TX/XKAJ1+
	xtA3Sl4Vs5c/dWKUssn/bgYz4il86TM=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38e58034d05so988158a91.2
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:54:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784930079; cv=none;
        d=google.com; s=arc-20260327;
        b=iZ68UJnKfe+lf0tORQTyZ2lWAoLkOSFGDUWfE5eijRYSunQjbMUg+AsdReEZFL1BgT
         xma7IFZaHY7RAoNZNKZ/YyBO1Fx1QMuBswWHCcmynWebdSDwcOjc8lVMsCS6t/2VrjGf
         WvXEcim8hCUfZ19up2/t7NylS1gzsXknlztIkK3bRdXl4XmylyCZd6CvoHADBFvfdKUc
         WFB7pSxFoYSAZuMe31P+1b9bFrgqU6GjzfX8cxVNWEujbu445xjKl1PQrNH/jm94a783
         wTOS6+7zMoBv1DzcGrMXWh5e0vFwSG2+k/jQqqLGCtuvYF07u9zVcszz/eoUwmCgDxkL
         t1SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/VuhMIt3y5/j6Le1Z4BNgwX3UBNQKNT5cbNU5pubERw=;
        fh=YLstPe3qywdtWK6U2GrScgnu05j4YWTGZjarg1jpfOg=;
        b=oXf8fnFnSz6UAEfzfRFpU4zvQd7EBWhXVOOKEylOQbmGEzosBIizpRlchvbzWHSUWF
         frBZMjAUR3Km4mVOoX7amYE8j9sti/aZQf/o7pgmNFyFzHdILBJz7JdwH9QQLe9ozuEE
         uzw4b6Ill0dRuVQoAAJDy8DzdxrPF1/vJUDybvE9OWcqsbW9X7BRhFGxzYI9N/Qhz+9I
         C4iJyKb/wafxAuGjo28+9VijSrkcjGKtsazWkSiDRTMq6GlcWFHxAwZ03eYu49y9woqw
         LDmIIlA7tpGEqs+UyK3pG+Q3lesKZ3xSZRqjZ1dsd3OuzRqdQd7qPIcgYQBujbDqO/7h
         /9Ow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784930079; x=1785534879; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/VuhMIt3y5/j6Le1Z4BNgwX3UBNQKNT5cbNU5pubERw=;
        b=T+Q282iZp5N9Ixa5kwLUglB+AzkP5Ws9gpyTni4vtHsqg7RZLU+z1/vEnR1iOooOVs
         J2gAMAKOxAF6hSOTi2u0Vn4qGi8+EeBr6nFSUCaubgmpTUrQ+NppD9D2LqnxvnGcaaQY
         KODGQ4AIfKR65RGapfxM46DDg+kOeDZo198xwhYBXe5449Mhi4Sniozt4sddARKIhRy2
         6Hqqt7HOE0ZCrugiJPpxf+CO38ecQ8Z8kJKK8isernu/Q7+RyWKnqoL/Bp8JNueFhIl9
         VcKodx+iRpzAoIIK+M/p/+PUhjTqBCb5O22StxCv89bx/vHsLuunWw4Bf9DtwI69NDQE
         nSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930079; x=1785534879;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/VuhMIt3y5/j6Le1Z4BNgwX3UBNQKNT5cbNU5pubERw=;
        b=MgY7eJ+0DjN4rRvIaTdoQAwofdypxDEMTcENpmG9iDucYbK5VQJvF/c3cNjjEQlB21
         kPQIWCAu7Hq0tD1feI/AwWvXjTELuS+xmXIx6O446c86dlbqITwqfgF8BeBEV6e9JnvX
         kKD81fgCNEbA6Zx/1sSkQwKY7WZogcLgmH/ohus+bKjDGOMiQec5BuEFNFhoTTloINQp
         XV1wcuXsamo+zmLpJPAVo/mavYeNzwgjeP7km5J7r1e55G2TXZBV14XRa9BAlDVLK7lc
         I6QKif5JMx6SSbiFA9CMo2AFASZ+2JSo6lfDLrb95QyN8AXRC5QVTTR5E/zdYfuT+P6G
         urYA==
X-Forwarded-Encrypted: i=1; AHgh+RrNa/EHxbURZEN/ogn187CqPrzjHJIBDF5Yg0jsObR4ytC2ra8isJjdXZk52esWpis2YXFReH+O8w==@kvack.org
X-Gm-Message-State: AOJu0Yy45eP+1cy1jd7f49IfDnpe5N4+/nEH+b90QUoEfOVLf6Z31SQe
	yjV5H7VD7mqIhRWMGGTNLNGqyYKREdEu66394WQ8bhPMpPXMV7Hl3dWTOSEE6+A3lj16PlOIhqB
	KUby7kIV6aoQGyn6qv1i9tr9hr9yWXf/Rf+lgTqWJ
X-Gm-Gg: AR+sD10tpFqb6vChhKTetvUUSLTZf7xQqnRo4Z9mdJkl685uYvPdBi1VNidyKpCB5yH
	GyasJlVeavqBxGk4sq8EF/zJFLVBQ+rjVxgbll55E3bxXKOlt2w/bSdvfMVW7ST8MLsP0hkIl7p
	lsvvbY+uWTJ0Hfbk+N/8pJiat9n5QhHyjOdn+D8lXrbZ7DptD1oRZErVrF+SusDPpLEozBlV5KI
	9gXWgAAprQAURNdmWB0LE84URYbkFVJILCjCzmIqUH97zawaNdIeu71ZLqPBQ==
X-Received: by 2002:a17:90b:3f0c:b0:387:e0bb:57f1 with SMTP id
 98e67ed59e1d1-38f2975d581mr178977a91.34.1784930078557; Fri, 24 Jul 2026
 14:54:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260710212616.1351130-7-dmatlack@google.com> <20260724205506.GA1012423@bhelgaas>
In-Reply-To: <20260724205506.GA1012423@bhelgaas>
From: David Matlack <dmatlack@google.com>
Date: Fri, 24 Jul 2026 14:54:11 -0700
X-Gm-Features: AUfX_myY_bxyw4-P1Rbrabgs4s-tLloBKDJhDTUU1nvReA0LfPMvmIQUGRTYqPg
Message-ID: <CALzav=c8amq1hTRCwHbQOZvhNKtissagzzXX+RGeRgUiKPOcbw@mail.gmail.com>
Subject: Re: [PATCH v7 06/12] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 48684140003
X-Rspamd-Server: rspam01
X-Stat-Signature: b91h7xuu6mnc4du1fb36w4ddzbnm7b5k
X-HE-Tag: 1784930080-265255
X-HE-Meta: U2FsdGVkX1+okmfP+hV+euKxPLehEGRZZaoECamsegQBzSf51iiy3FjAt/JiUxCLBW6ABic23oFJlY+TckJALW47kHsI2WXnjFQtXm2rD0UUKRz7qCoPTC+/cy2LX1+CIEoM2SAB2goedWUhqkQ8ya3Ff18qMu/7q0Up0yAa4yIS8QQMIbJ6U7j5ZJ+K+15rfb+1sgkfbAtgKYF08d6O2g1oZ118A92EyiVddXoeVKkOYQEOc7lIf7DTbi71ld4FfZiwhR8x1JImTgrfBksJmyUAOucYm55MSWoZZxfAAmbLxSbRz2tg4JnzA+RKUFitwjCG5UOGpJHDg1jaQQ5ykho9Z8CMp8j4xhRx23GyYGmYSp6N1pDhwmnU8luITr1zy4Y/xR0AGUCzxPb1seboPd8uFsws2GLue7tuk2R0EQz3MmnRIuMNaJeKfuEiEM3U9/GsT03NPAt2JXexRBjlMChjXCv36fyuBRcoi3Ec1LUYSwjZYMdXC3oBQexhgAbSrJnYmOI4hO9cB3dTQjfvm7xAow9UHQzOV43D4lMxgN333QAhMcQ34LUq4DxrgbZFBhjYTr3SUE+/8djprjRQopeMI6s7XeHdeFpe/1HuFgwxppvkW+Zw2sZ5US8VVWVLgUVhHbhnR86WD29aN0rdwcLSEw8rDcX71pSpcfUKRsd8u7FAY69vNKHOGkQCaxQx/B37UZGBkM4iWix8egrfG1Cdq6+bXfnXt2Iw/v3adXRqI/9muP8Iyac6+NrOI1IkFNQB/JtBjuzWuVRAIXkmU8iF9R8m4p6b0rO50eQePROl4jpXCYuwl4sI8P9/kJmBTzTAUBIicMQeLUXU+mVQyFvisJhGDwqualUC+xDEhz8mjFdW748ANK5KLR2Sg6NPCtSUHnq2TUA99WgxraEzddv/TjodfLSE/2uFpCsFkfLAK30qmJd1ofwQ7A6ytRYKkTlsgfHYU0hRTGs88u8
 PDdxZcYF
 zgS0e9XZiRxwW4mPA59N35ZLQA3cr5I2V8TdLjoSl685Ht5bVAtJBceatkwYskIJXp7We4+Axqllxn6V72Arwnc0jbP2PfJXs0TH7+ZP8LrH66mnHbUu9N9E/jVBLDEGgTgZVz0s7rCpGuSIZA/ZQmMJHd1leh88yhApZ6Ve0eEAbpDaGqqD1JRcOC4zx7YhGFllW0JvDx5VzwEQ4sBtwKnjzC+tYd3De7qgz7rJCW6Ux6gLPGIqp5M+Yzlc2EUbW4XIJkr3tUAVndiDVhRFxd0ZP+S6BGMarF+53KJaWNdbkV+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 1:55=E2=80=AFPM Bjorn Helgaas <helgaas@kernel.org> =
wrote:
>
> On Fri, Jul 10, 2026 at 09:26:09PM +0000, David Matlack wrote:

> > -static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *out=
going, struct pci_dev *dev)
> > +static int pci_liveupdate_preserve_device_again(struct pci_dev *dev)
>
> Could pci_liveupdate_preserve_device_again() be folded into
> pci_liveupdate_preserve_device()?  That's the only caller, and having
> so many *liveupdate_preserve*() functions gets to be a bit of a maze
> of small functions:
>
>   __pci_liveupdate_preserve_device
>   pci_liveupdate_preserve_device_again
>   pci_liveupdate_preserve_device
>   pci_liveupdate_preserve_path
>   pci_liveupdate_preserve
>
> Maybe even more could be squashed; pci_liveupdate_preserve() is the
> only caller of pci_liveupdate_preserve_path(), which is itself the
> only caller of pci_liveupdate_preserve_device().
>
> As a reader, I think there's some advantage in collecting the whole
> "preserve" flow in one place, but maybe nesting depth would be an
> issue, especially for the unpreserve cleanup in the failure path.
> Maybe a "goto" error path could mitigate part of that.
>
> If there's any squashing, I guess the place to start would be in
> earlier patches, e.g., "PCI: liveupdate: Track outgoing preserved PCI
> devices" and "PCI: liveupdate: Track incoming preserved PCI devices".

I'll see what I can do in v8 to avoid splitting the
preserve/unpreserve logic across so many functions. I suspect it can
go from 5 to 2-3 while still having a reasonable amount of nesting.

> > +#define for_each_pci_dev_in_path(_d, _start, _end) \
> > +     for ((_d) =3D (_start); (_d) !=3D (_end); (_d) =3D (_d)->bus->sel=
f)
>
> I think you might want pci_upstream_bridge() instead of (_d)->bus->self;
> see https://git.kernel.org/linus/c6bde215acfd ("PCI: Add
> pci_upstream_bridge()").  I think VFs are currently out of scope, but
> no harm in making this future-proof.

Yes in fact I noticed pci_upstream_bridge() while working on other
changes in v8 and already swapped to it :). It also makes the code
more readable.

> Other than "_end", this looks fairly generic and might be a candidate
> for putting in include/linux/pci.h.  I think there might be other
> potential users, e.g., calc_map_type_and_dist(),
> pci_enable_atomic_ops_to_root(), pcie_bandwidth_available(),
> get_upstream_port(), pcie_find_root_port(),
> pci_is_thunderbolt_attached().
>
> The "_end" termination case could perhaps be done in the body instead
> of the macro since it depends on the use case and several of the other
> loops that iterate over the path already include terminations in the
> body.

Sounds good. I'll move it to include/linux/pci.h and and handle _end
in the loop bodies. Then once this series lands I can send a follow up
to convert those users to use the new iterator.

