Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC9FCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB8DB6B03BB; Tue,  2 Jun 2026 09:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90146B03BC; Tue,  2 Jun 2026 09:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5DA6B03BD; Tue,  2 Jun 2026 09:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6AE6B03BB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:04:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 519AE1C0FBF
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:04:59 +0000 (UTC)
X-FDA: 84834992718.30.02E91A6
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4BA2080019
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:04:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WJsb6lQD;
	spf=pass (imf02.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780405497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/8nMdqnIqVIuE86ZCCEmz0EQ1iXOszPXfKX9VZoGH4=;
	b=QP4PWok5b27Ru+QbTgQsSzjK64kDooE9zCb2JS7UXYAvdhL1AXGn3QXvIZyt08C0lJ9PQw
	BFFwBr5HrfxkKAaQekpvLk0z3rj1qwLt8qspaqe4bx5j4j7UXRq/C74xNVlhMbL6HxdC+5
	F07BKjE5jg6yvdSxNOHqpVqQxlqqTUo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780405497;
	b=KBFxJlhcOEsRxc2NfkrH/yzbUypfylRu7Dq3dDijGA+kHovXNamFMp6dBxhA4K3tLFWNds
	bnKLFol7+CO834hBwDS/5jfAH6ixk+iwBwK5xfjKo+SCUnKZ9yp4E2fg/uaFSEDszhHAq/
	qYE53k61cJ+b3RpMgqfOzkpbbPSBym0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WJsb6lQD;
	spf=pass (imf02.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4906238c62eso93031365e9.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 06:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780405496; x=1781010296; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/8nMdqnIqVIuE86ZCCEmz0EQ1iXOszPXfKX9VZoGH4=;
        b=WJsb6lQDnHNKjbfPZ7Gt2D8NeefYSBiNTfdj4T3ExagTULzVm74FsHRJGaR/50aYjh
         EF4p+GeJ43LnE9iVS32RITYHvj+qzzXafO4TaO921shXnnN2BX9gy09GXYAL1NJ+ZAxG
         5wejeU4++bw0rweJVduNuluw2ALqSum6OXfvYZOGeVwS3iP5VEs5G7ZYtzKPofFiywuQ
         9QVWIcF9HGlH5DQmTLij/RS7cMJyVFjUjnxxfolXV12dY95blvPyLvRWjBFW3FwVbiRV
         wiV4VbeTqmXAq48I5uf5tftBTUOF78nNfeGQHV9sEtadtTWS1FAHu/ZdqZguq7Y0TpUT
         QG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780405496; x=1781010296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H/8nMdqnIqVIuE86ZCCEmz0EQ1iXOszPXfKX9VZoGH4=;
        b=B86evE02Ed1j006o+7d6OY5og1ntF6KA93rvIA7P9+CRktiv1Izp0vSYuK6iWLBXm3
         YmNmxfgBdGregH5wY/ekHhVy3+kJCPM3SbM3S9gTKciZXns/ChfV6FmFRWerEkyLy+2I
         AweIY4XmCE9m5wxeOGS9048BO+xNs+a2jE+GwZHfdwdIoTIM736nUUBGnXzWeivGVGj7
         trJFOq+EgNCrC2q9PHM7WnAW+sW0ltxx9SEmwAwfgtr95uPPaU4oiCyZD/LYfvva2QAq
         C4ZrKbAF0T9qST7HIXR12Nr4uO2uv8hUGg6SLI5eszCMRAdYYjaaZh3OyhrWEXqKnoMJ
         HPLA==
X-Forwarded-Encrypted: i=1; AFNElJ/wLt4DuM2oo3k5MLqrKisbQC8kSKtvwdlqJqj6UpEHSevS+oAlBX0jmw9lV+OQErQamiR/cfRDJg==@kvack.org
X-Gm-Message-State: AOJu0YxdD7AfWcxFO4fq/LPXqXy6DGMpnTQXw7J6JAauFIcPrRpubXec
	o2TC8chLpydl3P28wGZalW9tN9xZ+5Ay/aRhQgXRu3JZXPvKzfzK2Njb
X-Gm-Gg: Acq92OFoYC3ck8pnO6B6K0CIRpGo56yFJ9SLFn9TBwc9kHUl5vu8bQvu7y6o7RHp0Wi
	ITJijQSTlvIXcIBCj+wJn1m96TUw7Xc3Zhzs4nDszb61YnjnORklvL9xtGfusp1HbLf2NXUKk5o
	CD+Tf9HMO53l4ElfXXOCwTXGfTSwJUjEQruU2zmeGRAXd8Sw2AkDmpY0eWw3kzycjsjjfiuHfpH
	3zisPfnHviCAH8LZBhgcJqh5GiYreI/6d5w4xEjPcYb6zS8YerKOZht3qO47f2AmbQ0yj0at5R5
	jWN6Mjosf3ibeK0fgeGTZtEfQ+n6QRileXQ3eg3LBMYWuJGMsYlmsd5IUtXEiX4JPBbZ19u2/l4
	9d6udfG27KrOKyYHM7419wTy94BcJoyAokNU05oB6wPo4SvRB0FvRu9k2mA+NjcFUM7eA8T2oTS
	DNA+pcsHiTfnhEhULc9kI2FTsbzkcEwxK/ehtpuhq8fF41MmsBN44XSzzVt5loYL5H/2XSRQYSs
	pLPpwAY3A==
X-Received: by 2002:a05:600c:8105:b0:490:b072:1be6 with SMTP id 5b1f17b1804b1-490b0721e0amr76565325e9.25.1780405495119;
        Tue, 02 Jun 2026 06:04:55 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34b834esm33184301f8f.11.2026.06.02.06.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 06:04:54 -0700 (PDT)
Date: Tue, 2 Jun 2026 14:04:51 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
 Pengpeng Hou <pengpeng@iscas.ac.cn>, stable@vger.kernel.org, Petr Pavlu
 <petr.pavlu@suse.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, "Rafael J. Wysocki" <rafael@kernel.org>, Len
 Brown <lenb@kernel.org>, Corey Minyard <corey@minyard.net>, Gabriel Somlo
 <somlo@cmu.edu>, "Michael S. Tsirkin" <mst@redhat.com>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Bart Van Assche <bvanassche@acm.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Laurent
 Pinchart <laurent.pinchart@ideasonboard.com>, Hans de Goede
 <hansg@kernel.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Bjorn
 Helgaas <bhelgaas@google.com>, Hannes Reinecke <hare@suse.de>, "James E.J.
 Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Daniel Lezcano <daniel.lezcano@kernel.org>,
 Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby
 <jirislaby@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Jason Wang
 <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio
 =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, Jason Baron
 <jbaron@akamai.com>, Jim Cromie <jim.cromie@gmail.com>, Tiwei Bie
 <tiwei.btw@antgroup.com>, Benjamin Berg <benjamin.berg@intel.com>, Ilpo
 =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, "David E. Box"
 <david.e.box@linux.intel.com>, "Maciej W. Rozycki" <macro@orcam.me.uk>,
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Peter Zijlstra
 <peterz@infradead.org>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Vinod Koul <vkoul@kernel.org>, Frank Li
 <Frank.Li@kernel.org>, Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen
 <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, Alexander
 Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry
 Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 John Johansen <john.johansen@canonical.com>, Paul Moore
 <paul@paul-moore.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn"
 <serge@hallyn.com>, Georgia Garcia <georgia.garcia@canonical.com>,
 kvm@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-modules@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, apparmor@lists.ubuntu.com,
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
Subject: Re: [PATCH 01/11] params: bound array element output to the
 caller's page buffer
Message-ID: <20260602140451.2e3e6622@pumpkin>
In-Reply-To: <ah699hwLxIIOZ0-7@ashevche-desk.local>
References: <20260521133315.work.845-kees@kernel.org>
	<20260521133326.2465264-1-kees@kernel.org>
	<ah699hwLxIIOZ0-7@ashevche-desk.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4BA2080019
X-Rspam-User: 
X-Stat-Signature: zbgjp1t5cs8yq1uowt9pohq9wdwcya11
X-Rspamd-Server: rspam08
X-HE-Tag: 1780405497-967417
X-HE-Meta: U2FsdGVkX1+2oDyLfL1EF463Itznrhn/j5Eh72AjAqQaD3A9RiOcGy6Yv8GOLV/lhxEyGIE5UFq2L1RKgxvDh0F2fyzmD3rp5hQPDAsZpJk7Tvjionvm8Z48J+t6TFY4YtjjcaI9Ivd0VQMEWCtIqdVZARHxgSTlFgqbAzpNZO0ZVhowSPrlGIatKt4x7KpwdAT2rIZKUzA/r5ycNn6fgI9FGHD3ZxN0sAjnLl7lb6pNSpwC2xzxa2vT/r4kuXzXvHbnTbbFmJSFN+mjvTRKVnL0kAz0OzAYCu5NciAEOPHfbBazrLeQ18CLkfB1WexIN93/NI5ZPp4+g2+UJ1i8nwCEWD3v4EjMA9fhPjKpNK7yQRIqLbB7IeD+1KQgEtNfP9EL2AQ9fHP49z1YIRuwvHQdCOttX3Q85piqaxOspBhz4nYfIQ0wVGFfRJDE4Elr0OaoypDSQ2NyBQ4dMaWoeKnWhcjVLcIHbnUVL6EfJNmW8kD1PJGrlDEW0OM8bAyz90gCV0Xfo3OE7eLRyE7FIvMiL2aQ9yzzEMI2WgkT7brdqjEuD20h1NeiIZnt8GPzQO2U0nZc+9j2Ijfkw/WqHXDq+BRisnjXShcKIOwouXskXKNnUlNmnkENFeYMdahBH4zBMmaX2Ulv8drebjpCLccW0+X4AI16GEl3oJ3CIGfoyFHLMOBig0R3XPYmbmfp45Hd6DIUTpL7Vv0cdqajy4GpEECHb0s3eFIkeI3jUTEv++8tL/Q2xNJiXY5CDW2R1KLP5fuiGDGKA8kLQclq2lCxHiN3M0w2KlkMyfvhGKP28jNYpzNJ1dV6OQ0w+1pQa2PcVWxIMXmHwlJFK6U9cJsud6Z9gCHcscnYj+ngHPauJ/ObQlLBiiRl7j0X5RS10d7jem0z3xx2BxzZgq/QSKNRZTTQFfrGxDswhG5HUN3U+lCgO645XeFzk19gJd6TgidhIi1fzOePhVhe37u
 wWw/UUEc
 76vjxBndWRh0BYPG464m5C9VMXFAPFaFNw/TzUih4TYi4aitudFZGS2no8rcknKSgFBQ3lKy+2bNMjPhm+HggeRFDOqiM6N2QV/tcUClKPW68G31DPFPxDMyczp698cC+PNWHewdSQYWl/I8gKrRqR/bG1IvFB2qoPFcdoLJbBWim7hbsdf8eHUxk0kgdxsztLVTE6hHKgOs3ZZBAaxwffMBozOIbRwEF6bvPNi3L6TstOlrYAdxtYO3iKJHS6cwi/6M9X4l/gyD2x9yIbmZrJ0mMOTaGpzjb2OabhkXs7YDoTwJqxmAuXfI5LGtV+EObhfvbc16giAhM4zX73NvXcpoBmWoJNPQDX1WuavapmYe3c+QdmQBLLxdBewK0OgdBVKZtB9quYX0nsGVo3GZlQFDkcKJ500/TLsBEzt8cZlsUOqIXhzEDJGbj77C6KMDYvIN4fKxlMNHUoee4RuBvaMfAwuVi9PBhB81fjMgSc0DpOaqlw7ZqO/noMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Jun 2026 14:26:46 +0300
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

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

The kmalloc() should be faster and I think has to be aligned.
There is another patch set to replace get_free_pages() with kmalloc().

Although all these 'show' functions should really head to using a safer
interface.
Although, at the moment, it is really difficult to find the ones that
are guaranteed to be passed a page aligned buffer.

-- David

> 
> > +	if (!elem_buf)
> > +		return -ENOMEM;
> > +
> >  	for (i = off = 0; i < (arr->num ? *arr->num : arr->max); i++) {
> > -		/* Replace \n with comma */
> > -		if (i)
> > -			buffer[off - 1] = ',';
> >  		p.arg = arr->elem + arr->elemsize * i;
> >  		check_kparam_locked(p.mod);
> > -		ret = arr->ops->get(buffer + off, &p);
> > +		ret = arr->ops->get(elem_buf, &p);
> >  		if (ret < 0)
> > -			return ret;
> > +			goto out;
> > +		ret = min(ret, (int)(PAGE_SIZE - 1 - off));  
> 
> It's usually discouraged to use castings in min/max/clamp. Can we make ret long
> or do something different here?
> 
> > +		if (!ret)
> > +			break;  
> 
> > +		/* Replace the previous element's trailing newline with a comma. */
> > +		if (i)
> > +			buffer[off - 1] = ',';  
> 
> Can't we do this after with help of strreplace()?
> 
> > +		memcpy(buffer + off, elem_buf, ret);
> >  		off += ret;
> > +		if (off == PAGE_SIZE - 1)
> > +			break;
> >  	}
> >  	buffer[off] = '\0';
> > -	return off;
> > +	ret = off;
> > +out:
> > +	kfree(elem_buf);
> > +	return ret;  
> 


