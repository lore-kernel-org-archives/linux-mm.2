Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0A2CD5BCF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26C7C6B009B; Mon, 25 May 2026 13:10:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21CE16B009E; Mon, 25 May 2026 13:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4C16B009F; Mon, 25 May 2026 13:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F17706B009B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:10:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97F7C14019B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:10:10 +0000 (UTC)
X-FDA: 84806580180.22.97BB62A
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 62CA81C000B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:10:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="D9y/Hg6V";
	spf=pass (imf20.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779729008; a=rsa-sha256;
	cv=none;
	b=efAOKSMeu9uykO8TRyDr9T8jSv1tIeHtAtUSpUrnUBNItoSoH6yVUMvjKVtBQJ7PjdNuKo
	WQzbVrgpvX/Ovy6YkTE4WoLoWUXxnYceQlIPl00gsWUvsrg1Xy3+x6VMj0klGZK8FQ1h8B
	0JKaG9bLgbPvbGUa+UU7Mb6Mzac1wIA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="D9y/Hg6V";
	spf=pass (imf20.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779729008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izugkSqOYsBmSyQ8jfD9m1SVj73YG14U78pRBc6Lai0=;
	b=eL2pc0y13S6JhVGqP198i+jtCzfQXLLBCq6W0Ia1HybbqAljOLflbMGk8fR6vWp63Ilw3m
	om39s6y6CufxKgzkWlz9fGLT/S45MkIBlVCfhNVJjCtlA/B1wdGs1b8c2PcKd+aARBI26S
	L9XP+9MZJuFtc8CxAHcc7/UHH2dYJWw=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4903997fcb5so40910675e9.2
        for <linux-mm@kvack.org>; Mon, 25 May 2026 10:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779729007; x=1780333807; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=izugkSqOYsBmSyQ8jfD9m1SVj73YG14U78pRBc6Lai0=;
        b=D9y/Hg6VTGCtaGT9jeMZ+xn71BkOdN8Ho8YshJSTnnJzTCLn3h2wEOhDcmSKxnn7Cs
         xcEV0ubwQFckh1XEZBJ3jjt6u9W9URRb7KeqFHQTr8KDPWDfQ2rnK9dsc6zV2dD9U5Kk
         QxU3/HX19GNCsxl7kAsmVXGvsfP6i4wI5ewlYVA9BPVXg5u+4e8izPZbov1ZUsLoHiqT
         BWR0yVQZiIy+36NVw72fdflG88mHyM3JS30ptc7Ig5yAmknr5iVJ1RtVbmuHOs03LMAY
         QYy4YszW1OMaD+B9lYVV1frb7k9KSuNyH/tDMIdpK9pT28YJMStM+DNm6oKKS00C6eW7
         OOGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779729007; x=1780333807;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=izugkSqOYsBmSyQ8jfD9m1SVj73YG14U78pRBc6Lai0=;
        b=sBrO0VvbyF2bP6bTReOm6QXMGsJMTc2fAVoWdvA2SmNoQ183bj2HCV8FLYlv9orSHM
         Z1CXEFXi2Bfi0Fg5LCrbJ9GDL5XpgxBz52UI1qKNFHExC2UNU07c7idKO6+dLZguqi1c
         BftrTuO4Tx1juXokyVf5qTti1LgfueYExaiTkZ8nsA5Ys5mFTZfk5PMBYLWf7m95ILxE
         bfs9YWGVmE6UzSgli+vXI78FvWVAUV5aSyvssd/aGz6uG7OXd1yqyIkS0gM5sapDnnsX
         4kXpkBBEBfQGNk1ggwWp9Cnjy1GqwjmUfyJDuBmN4kxTnFtu5scySO26ghXYWH/an4gW
         9/rg==
X-Forwarded-Encrypted: i=1; AFNElJ9CQa5iGRTgyWVRSXAaaEATyNVAy9y1OPpgMUMm26P+sT/TFXCDXsZ9GXtaZgmqJZS7ypz1kUkIIw==@kvack.org
X-Gm-Message-State: AOJu0YxRnCQqTxDIGIMejj8UNVfu20Jk3dAUAAZrdU/2me6WGlGm8UVf
	/KLc+mtplxPLdrdD7pKYbKDcltEvuh49vC83zNtrclq2BfbRdnrKipSmb6FD9+D9VFk=
X-Gm-Gg: Acq92OHJ/Payt/NIl6NgFOy7wDsbavFDfa4Ms9xec3iFwXJVGj1xjBYQ6fKFIMTpXpE
	E7V3zRVJ9sWGEOWPVsF5gBJUtPhBqrWALURV6CZhA133WJyueijlfz1pxHhOxOFlM+ffOZ733ES
	WNRk0SFSnDUsRpgYntruBuiaa0NPdiYzUXoBKSdsPce9sEDsFBCDOL393RjHAHoXm31YhmERhpt
	9EU8aQgFle4DybWWWcryfBDDcO56Qsc88g1q6FWBBdbQ9ylNA6IK8AMHENFn4F6drW2ZuUyJdGD
	8x0djvfxXAj5FvYC8ZstGwwlRMd3kEUz64+ZeoTb6pUBp3/Awh017TcffSy7yepT6dAzkS6s8Dm
	L08qjViYGzK376025jQYfuQfTuMvOoCYT2HH0DKfuxNREt96mVKUKsyt8INs0yki58KSV+LuNMS
	2I/vOuzzCJ+nVoBjy/NpYC+KLlhldfaMr4KfD0Zmkla9uIAgj871XHvwnqSmNFJ19TCKb65W7Bq
	RGw5h+hptNWeM/KHzD08ZnTkA/vK/WC4phUdfSaZbcBqoVZayzpwTtlYSD446c0+qCr99dGQqqd
	y7rUggKF5b0eKds=
X-Received: by 2002:a05:600c:35cf:b0:490:44eb:c1e5 with SMTP id 5b1f17b1804b1-49044ebc257mr277307095e9.31.1779729006482;
        Mon, 25 May 2026 10:10:06 -0700 (PDT)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904526c926sm456877405e9.1.2026.05.25.10.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 10:10:06 -0700 (PDT)
Message-ID: <a192eb5c-5d16-483d-862e-d937fa1b8269@suse.com>
Date: Mon, 25 May 2026 19:10:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] params: Convert generic kernel_param_ops .get
 helpers to seq_buf
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
 <20260521133326.2465264-8-kees@kernel.org>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260521133326.2465264-8-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 62CA81C000B
X-Rspamd-Server: rspam03
X-Stat-Signature: xghx96pk35fmd3zo36rb93pt94zp6fte
X-HE-Tag: 1779729008-871413
X-HE-Meta: U2FsdGVkX18NhTWLqL8SYQKiuP6twz3IcIQVrJqcDYF4LFB3rxmGCQlbF5FLUH7JmHdZiaK1bTj25AZitRfivnvIHsVNUHghT19GM+9LVaXeWYfXgSjTYQsajSqT2XCeBjlEKAmyUrkm/eLVst4gXlXPDvR0wwjB25VHsFm8Q/TI6L46nakl5r8jy0VEqda2NxO1hs9BJ3Ff85LXz0CSUVcsl4fPjGsekWWPmvVYpt5KyA9oW49mloMmnXBJaAYtIVXp7Fn9Kmrljv8lbZs1En8757RIsc+edk1Up/ZkS21wb9qpEEcR5dmDTHUCPNhAVKtYi6prtrod4gq29beYz8MN5ibbYKSIGoKCy+8kt4LjwnTD44MKMwC01Y2evBhP1Bjq0ynpzMghwjeiPKQKEMNeP3znhma9d/+yNP3JxDiLCnPf8O/45vWKZXy7392FVWP2K/mP7TxKDRFeSsxSvsRG1pnQIhxfeJLpWbSzvaLXHB9sTy1SQUSLqSppcGyVI7JyeBuSaQxNXEWMnQnhKBhT2juffyvWqGy23qsBYmFu1/u65UaxB9gmM4x3zHgFx6nZg/W1Dqb8lAPJad7Lo6wPCQ2+DCrGSUfxRbDk5enqy+jaW0NGRDOHnqfW3gQZXacTLMPdWMHIX/+N5Wy7JJn16mLLQCFtNBin7Ti8FY/fP9gvZltyrDBQV9Yi3TpB+LDZjKpB9780qCoSy9tB6lMXweEeqIb4r6a9Yt6JBzfOgh2MhMzR9H2N2ICunGI+aWpbhduNGrIGZBQJZGAF7uayA2HGc/taG7LtWbEHdp5AXMax8l9vLdLaoYVXTxtpAKbALEAlaN2XrVR3iSubTKI1bj8fXTozQdo1c8H4164PrYNcPbBhsavwEx0FgUtXSqZs4WxWEOQZSWRqvEiqMMhS9VeZVHeSXGXOT6PgUUij+3WBXue6QP6MA0j8AnGyQjxYc905oNkS6bAtp2z
 yRCwc8fN
 Q+yxUQFTlqL/p686iKeECeFITTJmWj9jqDFAp7zSfwYUV77XfWtV1jrggCYeILb57h8kjAoJw23bSf9i+lmfjLcjbUdnHYqQqmWXfdY8Ho8Z0GRncgTFl4QCm6it2XCHi8z55Zp6KQFkVhvdFINaeksAT2MIabkrKGPD0jqyoVAWTS/to3VWMbi9Feds3HN6O2+mI4uu2pRdQKdt0UzEMjuNEDQajMgeLtxxfMra0rhegO9uElzUBlRjXGESIdYkfASTZdLZEBxfo3NHaWMOQBap9S35qYBABTUd2FVPAmhqP2m7To8VW5n5pQrPgfgzJRMLb20JC2pOhwFrMDNg7G5WWeGNwvpTik4JE2XY2URESKGZoTsl8FaTGrrYM/PygOc/ahzGwuYQ5R1PAXNYeJ+32Qg2K4rd4PbbmuRPkHHCszYWSlFxK5BuDMni0amgYoGbs1rV239+vn3NkSq43YkaSlodln0vTaGUQ/HWXmtgAhb6OIQtRvbSViXFylnZCgbu6TWjNSrQycfnVgffwW5y3COatTTLCtl8Fr1czUhNtUzhcRLmu87xmGgykBSmOZMbytpLi0P5TEg5DRTugGlTTpVB8eHoxaQW7qYxYBijd5bk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/21/26 3:33 PM, Kees Cook wrote:
> Convert the generic struct kernel_param_ops .get helpers in
> kernel/params.c directly to the seq_buf signature, drop their legacy
> "char *" form, and refresh prototypes in <linux/moduleparam.h>:
> 
>   param_get_byte/short/ushort/int/uint/long/ulong/ullong/hexint
>   param_get_charp/bool/invbool/string
>   param_array_get
> 
> The STANDARD_PARAM_DEF() macro expands to a seq_buf body for every
> numeric helper. param_array_get() now writes element output directly
> into the parent seq_buf when the element ops provide .get; it only
> allocates the per-call PAGE_SIZE bounce buffer when the element ops
> still use the legacy .get_str path. The common "rewrite the prior
> element's trailing newline as a comma" step lives outside both
> branches so the two paths share it.
> 
> The non-core changes in this commit (arch/x86/kvm, mm/kfence,
> drivers/dma/dmatest, security/apparmor) are the small set of callers that
> directly invoke one of the converted generic helpers from their own .get
> callback (e.g. an apparmor wrapper that adds a capability check and then
> delegates to param_get_bool()). Because the helpers' signature changes
> here, these wrappers must move in lockstep. Each of them is updated
> to take "struct seq_buf *" and pass it through; param_get_debug() in
> apparmor also pulls aa_print_debug_params() (and its val_mask_to_str()
> helper, in security/apparmor/lib.c) over to seq_buf, since that is the
> only consumer. No other behavioural change is intended.
> 
> Custom .get callbacks that do not delegate to a generic helper (and
> therefore still match the .get_str signature) are routed automatically
> to the .get_str field by the DEFINE_KERNEL_PARAM_OPS _Generic dispatcher
> and are deliberately left alone here, to be changed separately within
> their respective subsystems.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> [...]
> @@ -453,36 +457,46 @@ static int param_array_set(const char *val, const struct kernel_param *kp)
>  			   arr->num ?: &temp_num);
>  }
>  
> -static int param_array_get(char *buffer, const struct kernel_param *kp)
> +static int param_array_get(struct seq_buf *s, const struct kernel_param *kp)
>  {
> -	int i, off, ret;
> -	char *elem_buf;
>  	const struct kparam_array *arr = kp->arr;
>  	struct kernel_param p = *kp;
> +	char *elem_buf = NULL;
> +	int i, ret = 0;
>  
> -	elem_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> -	if (!elem_buf)
> -		return -ENOMEM;
> +	for (i = 0; i < (arr->num ? *arr->num : arr->max); i++) {
> +		size_t before = s->len;
>  
> -	for (i = off = 0; i < (arr->num ? *arr->num : arr->max); i++) {
>  		p.arg = arr->elem + arr->elemsize * i;
>  		check_kparam_locked(p.mod);
> -		ret = arr->ops->get_str(elem_buf, &p);
> -		if (ret < 0)
> -			goto out;
> -		ret = min(ret, (int)(PAGE_SIZE - 1 - off));
> -		if (!ret)
> +
> +		if (arr->ops->get) {
> +			ret = arr->ops->get(s, &p);
> +			if (ret < 0)
> +				goto out;
> +		} else {
> +			if (!elem_buf) {
> +				elem_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +				if (!elem_buf) {
> +					ret = -ENOMEM;
> +					goto out;
> +				}
> +			}
> +			ret = arr->ops->get_str(elem_buf, &p);
> +			if (ret < 0)
> +				goto out;
> +			seq_buf_putmem(s, elem_buf, ret);
> +		}
> +
> +		/* Nothing got written (e.g. overflow) — stop. */
> +		if (s->len == before)
>  			break;
> +
>  		/* Replace the previous element's trailing newline with a comma. */
> -		if (i)
> -			buffer[off - 1] = ',';
> -		memcpy(buffer + off, elem_buf, ret);
> -		off += ret;
> -		if (off == PAGE_SIZE - 1)
> -			break;
> +		if (i && s->buffer[before - 1] == '\n')
> +			s->buffer[before - 1] = ',';
>  	}
> -	buffer[off] = '\0';
> -	ret = off;
> +	ret = 0;
>  out:
>  	kfree(elem_buf);
>  	return ret;

Since you're almost completely rewriting the logic in param_array_get(),
I suggest tightening it up a bit. The function could warn or return an
error when a kernel_param_ops::get/get_str() call adds a string that
doesn't terminate with '\n', specifically, when the call adds either
a zero-length string or a non-zero-length string that ends with
a different character (unless an overflow occurred).

The updated code silently stops the loop when a get call returns
a zero-length string. Similarly, handling of a string not terminated by
'\n' is halfway there because of the added check
"s->buffer[before - 1] == '\n'".

-- 
Thanks,
Petr

