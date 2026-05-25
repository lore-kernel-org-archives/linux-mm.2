Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E1E6CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF236B0096; Mon, 25 May 2026 12:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86706B0098; Mon, 25 May 2026 12:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75BD6B0099; Mon, 25 May 2026 12:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A596F6B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:24:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67C11C04E6
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:24:14 +0000 (UTC)
X-FDA: 84806464428.02.955A031
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C60080009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:24:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bULtltVG;
	spf=pass (imf02.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779726252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WThGrJlj0+d9TTzzXLAp8aZigkvM5HszOOE/MfwSIgg=;
	b=d0wWKx9OoIwS6QSiuD3NBZed9/I/Me+7oS3rvKUXinm1MDhEHP8QPI7bQRyuTG/C4wMMh1
	yprxHQNFRTulNQdjmKb6gGaGFKwkZi3wRVfVQcdDDfAGqlko+E3fXfTldkriB2p+zjfZuv
	MoX2RsczTbTJxJeHfj+Wxt3B7sAjD84=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bULtltVG;
	spf=pass (imf02.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779726252; a=rsa-sha256;
	cv=none;
	b=luNqWtfsHiMAmZ/i6bgd1E2/lyL7vroughIWVdaz5wjjGlBibxFXYtgrQpnuNd2MdCdV/j
	zoNNg7eEuMzMrBQwlIKtlSEJ0AzODCIL5lr907XMXHcGsbb9Hpkw1oa8sgd4bw67fwXhBO
	gEzrmE9SMB6cwby2fcawz8l0O36r7a0=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-44a14580111so7325113f8f.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 09:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779726251; x=1780331051; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WThGrJlj0+d9TTzzXLAp8aZigkvM5HszOOE/MfwSIgg=;
        b=bULtltVGS81Qs+vl+ZkixVIslCmoZtn94yjlwScFQDZLRHcov16W7TxpZEayQdTgXl
         VZJnOzqzOP3I4SdYnGwfdPny902rPRr89IOuvcLsaskzGYI/CLbbtvzw5es7hMF/wAiT
         jgLbx28J0Jshyukzlj4hcUqayCoTWtyMk2bJkjABrl6vwvihIyFRgNOs19NCsusvQkjx
         FJM8Vv0Z05OgLEoV6B0mKfrdeu10leKGvNQc0pKvbPMuHpEbPlj3WKGommaFIRNpbzsu
         izwaMyRN+Q/VkLT3g3QOc+kjx6Q4LbFQz5Oo40X8w8QSPT7veRQR496NXMnJroprXG6a
         dZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779726251; x=1780331051;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WThGrJlj0+d9TTzzXLAp8aZigkvM5HszOOE/MfwSIgg=;
        b=b6QJNqzjZi2/au+/LwbnwaRp69ssNmrQx+6KS7o4U2gQYxl0Q88/e1BnA0QYz9u38E
         hvCYXW46CJdYYaWtBwThKFr+izoxC7BNvLbg6WKL2qC2HN2jG70dQlFXV1Nak8LZNPb6
         NnJXbnt5DXvlH5j+/FKiFybH2L1KEsglPDmI0aHDAVqjym5trgNbmCNBTLNUDXwwsZhE
         E0sXNSSohvECMNrsEJor8Qq5zUFM/w+x1Yd1aYuzoWQcwQjgYgu/xSeE52wUPHRp6ksu
         VHrjrxfb7f8uqMFO42aE8e3a4T6eY9oUpAD1uwUnQaxSl52R0vJllqZtVFaXDmIBSZnP
         qZ/Q==
X-Forwarded-Encrypted: i=1; AFNElJ9VWZGPZqUsar/Ixb21XZT4g/bagxuu1uEcNHZ45BlN5RJ/kkk4twvvCIrrzO9RNRZEuApWpOYiAg==@kvack.org
X-Gm-Message-State: AOJu0YwD1xDJD3M294jiM/FO8zWI33WU3K8U6liuQevwdGFWLzYmMfvq
	paXo96XN08dRlX36SybW0vSznzUSGDbKbGFUEX2ZAT+E2fT2JNlG9GlSetcJnejLQ48=
X-Gm-Gg: Acq92OGYfq4sLOPSGKGBMSGDWlM1FYZPwbN0GMWfAWpGvVW4LPv2F80rOAdmy9x+gVv
	gAeHaLslAc/2nsFgA8aL3z/+yToZIEyZhRcPIzNUAMZFRgFBjJqZ7cZh88DgWioXldcG8qYP2nF
	oUr+HiQmzSHwNmYeIUF6JyxUHZkOQNbCcjwJrU4ICU2KqxnikWf7qSjh6jQqmFTT1wKU3gOJ8iH
	m+MFEqRCk7/2HX36rrKT41aDRA+Zp3G8jN3g7MkVWoJavjXQAaI226SC1twqjfw5HHDh5DC0sF9
	wwYCl79JbO9hFPtZOZoejd4OEADhmgeNzj+C9DeL5kmlualZDoDdOsf3teshrTGmwAadU1oak9a
	13cEyHa9HsyJpYCM5N+YCXrEG1ATfheKTJ1XHlvSUuZoHm5qvH2hJBiFvft/rka+nQoVL8hVUws
	ncKtKTBP44oIwd20UcRHomR2p2txgYXdhAQp26l2lGCx1RRufFTZeYr9Wri69KuURcPnH3l68uH
	ZGhLrja33ptsWU6frqctoVugdFJ9GBFNNrMdB/aqBKUeE4fTWuodJUdzhwnVvxV3dN4gA==
X-Received: by 2002:a05:6000:26cf:b0:45e:b215:12e9 with SMTP id ffacd0b85a97d-45eb368903emr24724531f8f.6.1779726250728;
        Mon, 25 May 2026 09:24:10 -0700 (PDT)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d47b82sm28202483f8f.19.2026.05.25.09.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 09:24:10 -0700 (PDT)
Message-ID: <4e54ae4a-4f7b-451d-9b37-97f30b8fefba@suse.com>
Date: Mon, 25 May 2026 18:24:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] moduleparam: Route DEFINE_KERNEL_PARAM_OPS get
 pointer via _Generic
To: Kees Cook <kees@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Pengpeng Hou
 <pengpeng@iscas.ac.cn>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Corey Minyard <corey@minyard.net>, Gabriel Somlo <somlo@cmu.edu>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Bart Van Assche <bvanassche@acm.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 Hans de Goede <hansg@kernel.org>, Mauro Carvalho Chehab
 <mchehab@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
 Lukasz Luba <lukasz.luba@arm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jiri Slaby <jirislaby@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Jason Baron <jbaron@akamai.com>, Jim Cromie <jim.cromie@gmail.com>,
 Tiwei Bie <tiwei.btw@antgroup.com>, Benjamin Berg <benjamin.berg@intel.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 "David E. Box" <david.e.box@linux.intel.com>,
 "Maciej W. Rozycki" <macro@orcam.me.uk>,
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Vinod Koul <vkoul@kernel.org>,
 Frank Li <Frank.Li@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, John Johansen <john.johansen@canonical.com>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
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
References: <20260521133315.work.845-kees@kernel.org>
 <20260521133326.2465264-7-kees@kernel.org>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260521133326.2465264-7-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C60080009
X-Stat-Signature: dpfbpcd98u6k55sryst85xhs7j6rqe5g
X-HE-Tag: 1779726252-427743
X-HE-Meta: U2FsdGVkX19ygjxmr5AMJjThJF/X/nCInyZpgJMj7D3wrkecXRXOq7VAXHn2Q6NqWgnv11gkbvOUmz2pQ52NBF53FQ2B1SlJjgXbnT+1AWcmjtZSvartSJcPrfWCA0x4jgbCLOk0aIOV+qGSzTTiasQp2Uc57XRxoZ+3wMm8uR/J4aH1fRZdxvK4bxdRiD2vmWFPktMy1LYfIKSMxZJ2Vw0OhWw++jtC173pILsQyP+q5dJvS8mGr+XHqbj6KUygKSL/T60awuikS66XqSpc/sYtLr3zJ6Sa+0FOtpN4JRO/qtfVRJ8GyuTLOqgisTD1RHl2JsegU/SeNEox9p5Gm0QeT61c2zVyIOMPJiGdy5nHXueXFI5A2ak+y68WHeHwuWZ1+PK21upgOWxSSCRxxM7WchbB8ZzS/6vpmfgv2YeCFyEiuBxQJa6rMbMJdlzhHl21ETFyzPphbGjnN/MVMmUpZIwqjK+Rq9mzAVZtSv6ow62x6U97Y3DFVKHeF4dK3p445i+BDfpIn+awbSRgFIsLy6jyGeQLWDChlbVCUjBDifksYwwR6BI+3FcNfjzdYEqID+b2Ey5f8xoKKs82+lNi8c3DzV714tQkW8jGgLbbWSpJYWs6As/NIagPw0SPnDfQ84oNpVu4fqNMzOfH75ey3PJR9bDxPIcq5hj7lCy3Sd4kXu3RBVD/mtkWPpFo7GnC1guUVhrPHsNklLLEvbd+NhUW8RQzoQJQziI2GqtX/vp8VJLX9+NEQNZ0wOYPP4sfq61B+11LIgF2m2zVJX3/uMnq3+b3P9fvx3/fdQAycaFTioC70CrrgOIW2etZdPSBuamG8oHhY1ipW1mqUofDRLRgeeeTjBIK5PVG9crY4lsS4XKO3MW9ldqc7rXBARFlZWOFTfYm2T4LDVrpA2kZuap7Rk3P8wLsa7l8ylO/6v30K+2aJMS7UN4CFmY0fwICuU/mBDVlkAie3G7
 7h4zFreh
 4Rh3z8HDCMbYuc1PTx6OqSOyVkqffg0+XDaUX0n+9a0hi3qO6XW7LeyzI1mQUDmk0MmlfMkI/0yCLm8e+EMjrtaUgKSqoYaDAMgRSK64Hjhg1W5E+BlRHyF8z5eWEqpEzY/Bt4V/bKcKa3rZTKO4vaO8WdPvzT/In58MMU4jtUOgH8EVsQzk5j9H+Q8QFWqZ8YkNQTI8Chx115Q3Bmm3IXooh/73wgv/Gcj6W5ttm6dDCUKyGM2wXwWEtA280iDz46O1bJsQtMbl/bm17hyuB7hyXxvQQ69riFGLgfRlF6F6XWhLFxpCdpdf+9uLanRB+k/0oIvafMJwGe8lL5MyOUMlZ3YM/MUU3FCcsNeyu+saest65IDjNWR6CSu3mQKi1Y9XJKxvllDX++wc0iEqkNOsDjPhlCsQADQnUf/AaiD8gvWVvSOuf4lyy/79BbrYv3sAp8D/wT20J1jLVOgkxOUuWOO5EZsFtq3rKrMF5GbnR6h9Fwo1qc+iDHQzBly5GPWCZjkwE2aZ3LfZTUdoCG0zr6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/21/26 3:33 PM, Kees Cook wrote:
> Make the DEFINE_KERNEL_PARAM_OPS family route their _get argument to
> either .get (struct seq_buf *) or .get_str (char *) at compile time
> based on the pointer's actual function signature. Two helper macros
> do the routing:
> 
>   _KERNEL_PARAM_OPS_GET     - return the pointer if it has the seq_buf
>                               signature, otherwise NULL of that type
>   _KERNEL_PARAM_OPS_GET_STR - mirror image for the char * signature
> 
> Both use _Generic; only the two valid function-pointer types are
> listed, so any third-party type is a compile error rather than
> silently falling through.
> 
> Now a callback whose body has been migrated from char * to struct
> seq_buf * needs no change at its kernel_param_ops initialization site,
> because the macro picks up the new type automatically and assigns to
> the correct field.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
>  include/linux/moduleparam.h | 33 ++++++++++++++++++++++++++-------
>  1 file changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index c52120f6ac28..795bc7c654ef 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -85,15 +85,32 @@ struct kernel_param_ops {
>   *
>   *   static DEFINE_KERNEL_PARAM_OPS(my_ops, my_set, my_get);
>   *
> - * Routing the @_set and @_get function pointers through the macro
> - * (rather than naming the struct fields at every call site) lets the
> - * field layout change in one place when callbacks are migrated to a
> - * new signature.
> + * @_get may be either of:
> + *   int (*)(struct seq_buf *, const struct kernel_param *) (seq_buf)
> + *   int (*)(char *, const struct kernel_param *)           (legacy)
> + *
> + * The macro uses _Generic to route the function pointer to the
> + * matching field (.get or .get_str) at compile time, leaving the
> + * other field NULL. Each helper matches the wrong prototype signature
> + * and returns NULL, falling through to the default branch otherwise;
> + * if @_get has neither expected signature the assignment to the
> + * fields gets a normal compile-time type-mismatch error.
>   */
> +#define _KERNEL_PARAM_OPS_GET(_get)					\
> +	_Generic((_get),						\
> +	    int (*)(char *, const struct kernel_param *): NULL,		\
> +	    default: (_get))
> +
> +#define _KERNEL_PARAM_OPS_GET_STR(_get)					\
> +	_Generic((_get),						\
> +	    int (*)(struct seq_buf *, const struct kernel_param *): NULL, \
> +	    default: (_get))
> +
>  #define DEFINE_KERNEL_PARAM_OPS(_name, _set, _get)			\
>  	const struct kernel_param_ops _name = {				\
>  		.set = (_set),						\
> -		.get_str = (_get),					\
> +		.get = _KERNEL_PARAM_OPS_GET(_get),			\
> +		.get_str = _KERNEL_PARAM_OPS_GET_STR(_get),		\
>  	}
>  
>  /* As DEFINE_KERNEL_PARAM_OPS, with KERNEL_PARAM_OPS_FL_NOARG set. */
> @@ -101,14 +118,16 @@ struct kernel_param_ops {
>  	const struct kernel_param_ops _name = {				\
>  		.flags = KERNEL_PARAM_OPS_FL_NOARG,			\
>  		.set = (_set),						\
> -		.get_str = (_get),					\
> +		.get = _KERNEL_PARAM_OPS_GET(_get),			\
> +		.get_str = _KERNEL_PARAM_OPS_GET_STR(_get),		\
>  	}
>  
>  /* As DEFINE_KERNEL_PARAM_OPS, with an additional .free callback. */
>  #define DEFINE_KERNEL_PARAM_OPS_FREE(_name, _set, _get, _free)		\
>  	const struct kernel_param_ops _name = {				\
>  		.set = (_set),						\
> -		.get_str = (_get),					\
> +		.get = _KERNEL_PARAM_OPS_GET(_get),			\
> +		.get_str = _KERNEL_PARAM_OPS_GET_STR(_get),		\
>  		.free = (_free),					\
>  	}
>  

Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>

-- Petr

