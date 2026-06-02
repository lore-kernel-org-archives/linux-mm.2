Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E862CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310DC6B03CD; Tue,  2 Jun 2026 07:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29AC56B03CE; Tue,  2 Jun 2026 07:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162116B03CF; Tue,  2 Jun 2026 07:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 040F66B03CD
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:27:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95556C2B60
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:27:12 +0000 (UTC)
X-FDA: 84834746304.14.39D6C13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf28.hostedemail.com (Postfix) with ESMTP id B77D9C0003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:27:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OpuvB+TC;
	spf=pass (imf28.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780399630;
	b=6K9M6iCX3QyjSf0IU724MbjIScnRAZvqmptHVlWdCbXIFbQ+PpyDvbQOs+POHeypMLbxCK
	HGxIwf53qzKklIdFOEVrordnY9HPvsAuOy3BkDDxKyVCYf2e7zHu/Umnazii4tJpRtcR7L
	g5APXXm2JjYqKRdlTeJFfvddMqJLPVg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OpuvB+TC;
	spf=pass (imf28.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780399630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CP93nlQssNvYpFC8rnfGZuXcUdBpP5yef/5fnF6hzcI=;
	b=PcCyeCtP06qxR0A8r+t/w+BvxQsso3OKNY26Rp2vYaexP5LmvuTiAGZgynmLKmWyktcFqg
	y4Ty9B6E9D3J5j/tS4WkBWDom0dptFeQwRVLPok25hV3BwxblKsDPq90stJb0tRJqyP8X5
	Lkcw8kfi0GOliEQSJHwhl93tdnecvZE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780399630; x=1811935630;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vFe0YHJbZeLES+sUauMUh5hZ46dD8ew9Ej6lDFLoT9Q=;
  b=OpuvB+TCFOlrTj1dTsQq4IO6bT0RYvhdqKiNi7guAfItcI40qmxJuR+2
   JxfSI7H8Vs0pb6lSzui2MNNzEWzxhK2dqWRYpbiEiVo05UowkhP/brLIc
   ZVeqrXsY/GHqe3VM+ZWp1v4ClJFL3WOZdAoNffJszSxQymB3W2SmL0kdn
   EoTQOQCHyRV6IH4CmL1hEzveBQPF06YlAMtiXnjfxI7VYYLoSP3+xGnlr
   LFm/IXvUvXoEkVqVbja68afnmQGU98K68zOP52EZcPPPHvMGyw+ljzTra
   1vViH6ezFD00NvPoMZN+e9EIaC8+Q8JOgg1j4bdpBSO6q8EyVZiF5BWXP
   A==;
X-CSE-ConnectionGUID: exe2E/HDSMGWalOtmiKhOQ==
X-CSE-MsgGUID: MDo+SSU1RLq51iIrkyY4Ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="84805000"
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="84805000"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 04:27:08 -0700
X-CSE-ConnectionGUID: 57WJuzJhQk+bJIT4F8AZnw==
X-CSE-MsgGUID: InV+5AxmRSKrEz4WoNh7bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="240879149"
Received: from mkosciow-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.229])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 04:26:48 -0700
Date: Tue, 2 Jun 2026 14:26:46 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kees Cook <kees@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
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
Message-ID: <ah699hwLxIIOZ0-7@ashevche-desk.local>
References: <20260521133315.work.845-kees@kernel.org>
 <20260521133326.2465264-1-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521133326.2465264-1-kees@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B77D9C0003
X-Rspam-User: 
X-Stat-Signature: b4mbfhw7r9oaw87iii1hykhgyt4tk3gp
X-HE-Tag: 1780399629-469611
X-HE-Meta: U2FsdGVkX1/vV2sSNUqqxEPpqnJ4E7LjGO12w97fvG1clnZEvReVGt0s9Rc5HDx+Ak2M3E/MYoW1E3hRjt86SyC4nuLJjaMDGXAGh3MIUrrvVvXY+EjNL0R9rWwRY3W2B3aqhDB4kEOJD/JG2sxXRgvRlyLqcOJr2gGyDLXQbKmaDPMGGArvAyGaSRvr6FRnjr46B153itWGgmCQWNFCAocJuNSs25A4cY+MkfKILjrIA1S0+WDs+yuAaEsKQiNK4zywWc07QQkdv5um0so0rKoJO+i4W19IS1Olrm+bmDcd3a3WaRG8gKE3EY9vGHN8X7vCoNQBtyOaHZa1dZQCfbXQVD4dKngZ187sSepjfshGc7kmTeqxcsTPOhneVN0WKCkMvpxPugNeGe6K5m3gePCEsd2BXyJ9koxUQDE28c5JmlZz3RUY3Smm0VdcV61wGjilKHD6QZN4gQv40KMbb3z4SGr7Eg3N80ohuEjMn9ENA907mTMiJ9ABW0/TNXphSDvDn8H7r8Y2gcbe2qJO/UnxFUCmGjuhwE7JIbBqT/e5D7l5XXvUjrtM1n9zpsh3/NyQrdmwH+JqFvwp4Lhes0bbVQ2Jak5vICOusuTsRP9LSs2tv/xymtNnV6sQas+dKpqH/7XvMbFNPfVYs75FL0sZOLoWyemIe7MdMej4+vg15tFkIwUipmcEI0fGigKE9hrNZwQkMilBwiHaKUaf8K8NOCbtY5NBYwUQOnPneqeHwHQ/uBDvTt5QjdalGE2bxm7d8BV0p+0HB8kCCRKE+BjU1qNK2Rsw273PVb6aRGkFdE3XLwzkeiU9aizi47SPUuS3+b5qhX8nGCsMUjei0fqo66cWiBlwCkhPCGc7obS2LT7RCWrXj3WvHEfhBerM6OWRYsgInZPvzHoFYC+WqdMxH1S6AdR3ZaqjcFuSrWONmPwM149DgC66250AC/LZXzImr/7UjrxUcM1S6DQ
 7u5Vj7YE
 hqBJ/QuoGRlLXGdrpcVU9lQSmyZwiNFTz9qyhfsNmq03Pvq21ZjlEiV+qtM+u+MIBXSt9CQWIzXxdMbilAp76yipvGtN+si0E+lnSxJiGs4U+W1aiEosI/l4zkSDGhkvvKftbJ2jC91dHHewuUEF27/ZeM/iyRi7dfJNjjaQSBoWyDAtHOVnHGp7w3prPWVuyNFx4Sj77HMNW50uHPcXi71tJ+qXAO/kCQR5dOWucPchLCGvrQnosS20stFAwEcdUx4oomPdR/cEHFCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 06:33:14AM -0700, Kees Cook wrote:
> 
> param_array_get() appends each element's string representation into the
> shared sysfs page buffer by passing buffer + off to the element getter.
> 
> That works for getters that only write a small bounded string, but
> param_get_charp() and similar helpers format against PAGE_SIZE from the
> pointer they receive. Once off is non-zero, an element getter can
> therefore write past the end of the original sysfs page buffer.
> 
> Collect each element into a temporary PAGE_SIZE buffer first and then
> copy only the remaining space into the caller's page buffer.

...

> +	elem_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);

get_free_page() (or how it is called)?

> +	if (!elem_buf)
> +		return -ENOMEM;
> +
>  	for (i = off = 0; i < (arr->num ? *arr->num : arr->max); i++) {
> -		/* Replace \n with comma */
> -		if (i)
> -			buffer[off - 1] = ',';
>  		p.arg = arr->elem + arr->elemsize * i;
>  		check_kparam_locked(p.mod);
> -		ret = arr->ops->get(buffer + off, &p);
> +		ret = arr->ops->get(elem_buf, &p);
>  		if (ret < 0)
> -			return ret;
> +			goto out;
> +		ret = min(ret, (int)(PAGE_SIZE - 1 - off));

It's usually discouraged to use castings in min/max/clamp. Can we make ret long
or do something different here?

> +		if (!ret)
> +			break;

> +		/* Replace the previous element's trailing newline with a comma. */
> +		if (i)
> +			buffer[off - 1] = ',';

Can't we do this after with help of strreplace()?

> +		memcpy(buffer + off, elem_buf, ret);
>  		off += ret;
> +		if (off == PAGE_SIZE - 1)
> +			break;
>  	}
>  	buffer[off] = '\0';
> -	return off;
> +	ret = off;
> +out:
> +	kfree(elem_buf);
> +	return ret;

-- 
With Best Regards,
Andy Shevchenko



