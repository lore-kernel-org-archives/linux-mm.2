Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B914CD5BD2
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 13:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53B366B0005; Mon, 25 May 2026 09:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EBA66B0088; Mon, 25 May 2026 09:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3426B008A; Mon, 25 May 2026 09:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A61D6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:27:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C82D6160144
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:27:20 +0000 (UTC)
X-FDA: 84806018640.11.FD9C4EE
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id BE20B100005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:27:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eRHdnozw;
	spf=pass (imf05.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779715638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ij+l12dR+ISDUAaA9eJOw0SDQ47xwS4UQDqlRXMB76c=;
	b=jE+fp/LIe0Wyr6g6qOXS7RZp/EYHWC9qrAae7xiV0guDZHsuEO995IKadzOBmkdA+h6kgb
	1Evv+c4oXTqfQuLEGx60++06jOT5ULe96svsBqNyOLt07JGY6JQdsELccmUW4OYWXhM4q/
	BylFz9FRPEtTMlROaDgZcn6O3AMFObg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eRHdnozw;
	spf=pass (imf05.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779715638; a=rsa-sha256;
	cv=none;
	b=NLkOad1xL21B/DLWygI6wvcF7A1pYQxeGYrYNjr7XPQNzRiUDht7/WWlzQzsRMbXdz5UV2
	SzafvAfuaccQAgyjA9utziwMGLfwkq9WkKR5iLibrAll+0qHWR9KAeGyDwfNPgVD2wYud/
	vf9VCJlZXZqDPnO6QnWzGM2uFAUP/TU=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49050bfe053so23454035e9.3
        for <linux-mm@kvack.org>; Mon, 25 May 2026 06:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779715637; x=1780320437; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ij+l12dR+ISDUAaA9eJOw0SDQ47xwS4UQDqlRXMB76c=;
        b=eRHdnozw46sEE0vLyht5IdXMREP/ftbftwN+uJMga4VeasPrcv2VE39mqE36EoXZs4
         4IAvhOroYL7PVHdfdMHIWn2TwSs9CGsHN3svhYZrXqfQPshNzsqyWW08pYV4neZmvrMv
         3f+qujyT+dL7qJoaTT3WCTHNTTxHn4b+Nu9c987NIwQF+ePaFoCYSF7aA1iQDp6y1+GE
         2kdINYBH0WRwVE2U+qDNFm3Sd9qJSWdUhArd62/gIxxkGFiCNYQMIq5Tn6IAeZjBG2co
         IE5wotUAjat0U6EnBrUt4/hhsmAeP6cs7fR9iFB50xd90NBggl37IlidD0BkQcYQ0Qwo
         HZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779715637; x=1780320437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ij+l12dR+ISDUAaA9eJOw0SDQ47xwS4UQDqlRXMB76c=;
        b=IrgCY1D5/h/+WzgzGKWg56YyNxAPldvlJo6Na/VenxRHqLFvs/RVzjzY0f25DjcZ7K
         gDccbeEaSdPy3wghQXjMUJTaWO9MDS73DeX+OuwOSdHq19CAM+Fa0uWwhMBQkxQTTGKd
         igE1D82cGGt5EcwN7EL8gao6cN4kRt1qWb6CxH8bWCa3IFOxg/E4c7+fJU8/pRzJ6y7o
         B7sDp7cBOIveM2JUJwid39xgdO+WJS0pBLf6F8JOmNnF1AmSDYfaEMYNFwmfEh7emCq6
         o6shk5QzehzWTneG/dsBjEYlk4poSVOCXZY+O9DSa40RQZuIw0wY4Wo24dPO5niFBRVE
         iKJg==
X-Forwarded-Encrypted: i=1; AFNElJ/C3EVxv1eIV/ivckx/2TzPdY7YssBA5ih/5E/SgENhtS3fBrRa6A7Ebu2foBKHx8mL+TmVSH+/2w==@kvack.org
X-Gm-Message-State: AOJu0YzkNDPnfcD4nyZAjDdn9uh36qEPNXO1MBTtzatioUgxXF2pvt/Q
	sF9iUiFZQcIoeTIkxTsw+N8nMCWGEoqIXOCew6GZLTvnZrU4e9F4ncgsJNBxGE3/Pf8=
X-Gm-Gg: Acq92OHkUgbHHzx9V+wPs4wCvwMKZD98KzkH6stTd9pftbmfXG3NZ3ev5cD2Xy6YbKq
	WqLduDcFqvpz2tGEOLL4VZEPzfQeKjL/Xygm1jXEEpPE74KROJPNYp2WgHPyBFva5LOmerrEF5P
	smdSBsqiZVSlTvsMOXHe30U7w9tqz7qEmwG69WvecRvNDomer9PV/4YH1Lal7cVXGX/vluXhacE
	vIkDlPsUl7RvSqkjPQxU2q/PCYnx6DFcvVYZCvENmy2ZpLM4CVlJ5gcJQzAZ2aNp8qP5m65WdM8
	bX3Oj2+CdI/yOSuvUtWUSQLTp1cmFpYJkOqqvqTkkt2zgU7+uCnYSoetCwWCat++BDuceggf0Pb
	iPVW8eXdKIe9HQymUMM90Hjm1AhMSnen2K7DXYsliePDD5gLmYyrnbysMxWSzjmRtVVFEjN6aPK
	wyxDc0Yd0d77USOdcIx8x9Qwy5GphzU8AlD/28Ijo8gH2hggetJSFAOFvUfleCkSgXjVa+Et1wo
	iD5fIgzTHXKRpTyXEVpSS+Ye2hD5sT5lmEs/Yenwv0ulw4PM9gqZQc27CnTQSTyoLDOV8OZbYw9
	b4sx
X-Received: by 2002:a05:600c:3b02:b0:48f:e1ac:c94f with SMTP id 5b1f17b1804b1-490424b3938mr247672645e9.10.1779715636631;
        Mon, 25 May 2026 06:27:16 -0700 (PDT)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454b1ab3sm284841905e9.14.2026.05.25.06.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 06:27:16 -0700 (PDT)
Message-ID: <1c21f66f-0d0f-4a8b-835b-23408242cff1@suse.com>
Date: Mon, 25 May 2026 15:27:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] moduleparam: Add DEFINE_KERNEL_PARAM_OPS macro
 family
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
 <20260521133326.2465264-3-kees@kernel.org>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260521133326.2465264-3-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BE20B100005
X-Stat-Signature: 3bjjmtirf469umwn11bmu1h8p4oudeqd
X-HE-Tag: 1779715638-586425
X-HE-Meta: U2FsdGVkX19NW5jEEYnqtUuwGUrjZATuDuHrOK3YRI1WFAMQ7tP9HfpTjLS04/cGT+WD2cLXBVxxGNba7FLoQDhAVFSG1/1nsTteLPxHax9LepDaJ0JxzKiEZCW/h6jRhm+rHPvOS2DSTr2WwpDudWVziX8/LNa22aUIiYSeSCD0NRN2Mq/EOhoUnI8BrzhFx8S7+gXKnbaJmYKbrI8AI+i/mnKpSFfJfyBnsevd7qm6ymuNSGkcvXWTAw32K828T/3n1rOGtcIEXZ6EeYf7W6K6UKzEdM/ATIQZly16RcKDOAFPNzDP0KIK+YzR62RFzp4HgLjy8D6MkkEl4FVO+04PR+mAd3GV5h5G0H4k/SNPXci9ilpDdW9Tk9xectDGhjrl6iZs4w8lg/YrZKkkA4is1vzypliuFCOQhernGm7I0k0isMuq76AI3nvnVT48Z916B1C/AsA7MC8twlZ9rr85Aj77B87UMOkqxh4kmpgmWXWwKSgTe/a2MtPqgz6u2w7ItXgmuWAhOred9Vkk7DG2p6lfWw22q5LK9OxdC0erZ7pG3ab7blXhKH26PUJea9SZspPUKcyhBZCl35PhzMtVaCp3Uojh1sGwOMMciIwRmOYTIAG/2saZcCdYczlS1TrhzPwmWwSjU49E7iZbJehkDeGogT/hM4nwebVpb1PymTk0fCT3ZjELLRPVHafcPAH3GmNzgc1ijAuG4lgypK/EjoU1WPhFKXCpVz6CXHccxFEEz9JeokhYCwns1pHlD1LV9QUKHovSLG5dac38SFJi+Yvz/OhPVQLsHKRVY+ho16xu5WeUYoPRk+5cZ/O2BN8e1H/z2X9GLGGOTLcKTodhWmri/PJ/AGoqJZjDgcA6Th7M7kWMNTZ0cMiQFhVHuxjEYO0uSHnOKb8SA6EhnGl6lj1h7HuD6yZi8PFhg6/74y+ErNXABuMRFQY790Y7oJZLJhG2OQHQV9NJqxw
 1nUTuclC
 9JCpHVuAN1pVOScqh/4Yc3M+NGegIC7UJsz23CYtOFJsAdFuRFQ82qqJc4uSOR1cY/Up9mwcrt3lQukBFwy6JXj3iAxbVxbOedA2lpwNZpN8bWF3am491/MVn2wPAPVy36tvyl4cZRBTczKwgb4kYdzUUllj2YWoRoHGOkn4//jCBBmzejLBasDMUzMlEkhekAZA74pPINUMm93mu19A92y9wz1Up2Td9+XYPMG9YtBBhdJ7glxUd4AVZ5Dx6DKE89Oi4yCB3M6yd8w78SWx4ImJk0HXoVk2HW1BpGkEDe93YEPd869VWWiSl5yJt2AN+cgMJDULCkVB4yGuQWfyPDMNj7mHB1JWXOpJC2vnr8PBOdGIFnqRK0G0YCej2hVxTpnvCD3R2tX8CyXF0jeKi0fGS9EeDIR7Lwf5gv/YV97A8p+weJCPeO6ihIljZq8aWkt08FvRlOLIgtH4K1BNtiTg09IPUAZAWN1LxnemYu3Iu1s937trncNJehQAeVEArrKRaBnMCBIZNM1lJKoQw22tv8E5PcOVvpxhoU2Y0zapNDxvO0CgQ1xxmj9vSbw9Ti7r5TXzaL4CMgxE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/21/26 3:33 PM, Kees Cook wrote:
> Add macros that define a struct kernel_param_ops initializer through a
> macro so the underlying field layout can evolve without touching every
> call site. Three variants cover the three cases:
> 
>  DEFINE_KERNEL_PARAM_OPS(name, set, get) // basic
>  DEFINE_KERNEL_PARAM_OPS_NOARG(name, set, get) // set KERNEL_PARAM_OPS_FL_NOARG
>  DEFINE_KERNEL_PARAM_OPS_FREE(name, set, get, free) // also set .free
> 
> Callers prefix their own visibility qualifiers, e.g.:
> 
>   static DEFINE_KERNEL_PARAM_OPS(my_ops, my_set, my_get);
> 
> Also update module_param_call() and STANDARD_PARAM_DEF() to use
> DEFINE_KERNEL_PARAM_OPS internally so the generated ops table will go
> through the same macro as everything else.
> 
> Subsequent commits convert all open-coded struct kernel_param_ops
> definitions to use these macros, in preparation for migrating to a
> seq_buf .get API.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
>  include/linux/moduleparam.h | 36 ++++++++++++++++++++++++++++++++++--
>  kernel/params.c             |  6 ++----
>  2 files changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 075f28585074..26bf45b36d02 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -68,6 +68,39 @@ struct kernel_param_ops {
>  	void (*free)(void *arg);
>  };
>  
> +/*
> + * Define a const struct kernel_param_ops initializer. Callers prefix with
> + * any required visibility qualifiers (typically "static"):
> + *
> + *   static DEFINE_KERNEL_PARAM_OPS(my_ops, my_set, my_get);
> + *
> + * Routing the @_set and @_get function pointers through the macro
> + * (rather than naming the struct fields at every call site) lets the
> + * field layout change in one place when callbacks are migrated to a
> + * new signature.
> + */

Nit: The newly introduced DEFINE_KERNEL_PARAM_OPS*() macros remain in
place at the end of the series after the migration is complete and this
comment is removed in patch 7. It would be helpful to describe in the
commit message why these macros are generally preferable to defining
kernel_param_ops instances directly.

I assume the motivation is that the structure is simple enough and using
macros then makes defining kernel_param_ops instances a bit more
concise. A minor disadvantage is that some analysis tools, such as
ctags, may no longer see the generated definition, but that is also the
case for DEFINE_MUTEX() and other similar macros.

-- 
Thanks,
Petr

