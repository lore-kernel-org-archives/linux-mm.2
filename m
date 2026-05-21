Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7BE7CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CDDF6B0092; Thu, 21 May 2026 09:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E356B0093; Thu, 21 May 2026 09:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D546B009E; Thu, 21 May 2026 09:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA03D6B0092
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:45:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D5B01405A4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:45:08 +0000 (UTC)
X-FDA: 84791548296.13.0F40671
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0626A0005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:45:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L5ntPRqk;
	spf=pass (imf15.hostedemail.com: domain of 3YAwPagYKCA05rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3YAwPagYKCA05rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779371106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dnh9Qdh/Ek2SFmUD3YQQhAJ1lm8lFb5yTi3rkZyIV7s=;
	b=jn8Vad8vDAbsCMBanBKU7OVxobJBfG9zRS6TIx9WHY0ZpZuMeoGU06DSaPWq70Bm4pf8ZT
	+FBV5qQPYWj0/2oVrFyz4HYF+mOpmSA/Uzd7NbIBswswSnDmfW74x7rkgKwmsMrOnAWz9Y
	/Aj1gLZ7Z0oP+4SsVx+F7EuGUJ4up4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779371106; a=rsa-sha256;
	cv=none;
	b=1HGNzSqslQm2mwH4MK35ipF8iJjxBZ9X0uu5Oo/BB6jDL//fiwpUIpiLCRmxY1f6wJArMd
	elF2M2mOjhChDgquUHobJt8OiqTIlOl6BaTjkrQag2M2uh5QCT3jIqyW69dH66osSsUhXP
	x/hn24sB2kmFItHD5jfhX2dL7Dpv3dA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L5ntPRqk;
	spf=pass (imf15.hostedemail.com: domain of 3YAwPagYKCA05rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3YAwPagYKCA05rn0wpt11tyr.p1zyv07A-zzx8npx.14t@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c829586e894so3199287a12.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 06:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779371105; x=1779975905; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dnh9Qdh/Ek2SFmUD3YQQhAJ1lm8lFb5yTi3rkZyIV7s=;
        b=L5ntPRqkhOI/+j4JRKj9Hv4V6bGad1JIj/5hre3f0B5HmDN77bQr5ZdhHnaC5QI4fa
         Zd/hFYMfCJdeDYCbp6Vw19uMFp0KHTl595z5eBjxGgOR/5DTHCy2kwV5YCqhakBgUyuH
         g0igJiA6q4f24ERWIb3u7pHjWNwtC2Pe6wmssGWGXK/EskxgCxhUQFnFy1jd9TLxe+VY
         1vp18oM1gp3ZQQGlMQQMnj5tR5aOnPywKplH8/OyGV1KF7aTwPkh6r5KwH1xeJOSiOps
         ebP3Mliru4Wjf4VzuQdVT58bKSyW5gzjDBgvOzqdkd5gUES4uYpeo7ev3YvCPw/fcFFZ
         GxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779371105; x=1779975905;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dnh9Qdh/Ek2SFmUD3YQQhAJ1lm8lFb5yTi3rkZyIV7s=;
        b=ix9mV53k1Crk5VVbFomdaYCtVhPxxD8E5focvk26F/mA/oay9szojLKtXaOcIScjkW
         5khEwb6yFEYMuy9+6aDqWIifOw451VhnaNv72ht3n+TDLShN+nCjJdfmyHN8oNU8uXIl
         iu+Y4ELV2yhbPQHrN4M4VUWgAfsIPEAPQP1TdgTCuoazwpNcrMXmyBdym2AWQoUonSHM
         Vyjc3lSqSGRrb2okIaFzoIeHCExvxiIB7Q0IihcwbXxqUpHO3wXsZ5Qfg0rQDDimAH4Z
         dPapxlGxmKZBJxBH09GZxfOsqYLx0S0AdZYrMBoMuW85nzWQRnTquJ30KG6rprOzNBb4
         d1Tw==
X-Forwarded-Encrypted: i=1; AFNElJ8C4OB/WS7PZzgzhW595m/CGE8oEqettzLVdaeapKoHp4//SSxZI4W4XM4u1zaa1Az3UZ+wKKSn0A==@kvack.org
X-Gm-Message-State: AOJu0YxGGinZOO2U5cGfH3yXjF4yKLt5EIKs+3woy1nFHgyd//IivL2P
	tmmSjn0AD3JsuA+R5uYI9Wd8aTpG7mZZ5jMuTR3/XpOZZM/81lZpnccFKaUP0ddUmI2pZUeY5FD
	Q8bHeDA==
X-Received: from pgvm13.prod.google.com ([2002:a65:62cd:0:b0:c85:1159:ffbd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7491:b0:3a0:bc61:62e5
 with SMTP id adf61e73a8af0-3b30883a17bmr3700528637.44.1779371104725; Thu, 21
 May 2026 06:45:04 -0700 (PDT)
Date: Thu, 21 May 2026 06:45:04 -0700
In-Reply-To: <20260521133326.2465264-9-kees@kernel.org>
Mime-Version: 1.0
References: <20260521133315.work.845-kees@kernel.org> <20260521133326.2465264-9-kees@kernel.org>
Message-ID: <ag8MYC6pOZvvYHMp@google.com>
Subject: Re: [PATCH 09/11] treewide: Convert custom kernel_param_ops .get
 callbacks to seq_buf via cocci
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D0626A0005
X-Rspam-User: 
X-Stat-Signature: 8gfte58ii81wtig4myc7g6a6kswxj8io
X-HE-Tag: 1779371106-641604
X-HE-Meta: U2FsdGVkX19IoemOCHqYP4T90+nFU9NTJKxojgk6OVFtMrzp8fX6KtYpIb02wRk/fzChHla0W2m91LShFM+pO9uzWe11vlmwcJrD6qusYwTbsPQBUJHV7OQr71BR3dE//ivQTqyCgiUCfpkEhRipLiErWRuJIwL5pef8BVv479c46nOYjwqemEjOw3hD5OJfFM7HqPbYB6bMenaODAvqdvyBinvOVlWSD44Og9cZTy1YAHJU1O5dXAyaRVMvRkkvh8ia9/RNe/MNLSbeQKEYEo/lHTAP7uQsu3nmbsSDm2A1RqPToKTOFOgDoN6OiZoDLJn5oKuiPfpDZaPi/h1uc5SezZmWbwRBlgLMGtCUyturJ5Ad8C4kDJEl9IwF35/k3OAUtN36Qej0wFylOkH9Zrdjd3taUxyd+Aq2Bl/7b5WpT8zhPW0YZuK+6OuCbRBp+SkVm/iruoewLZK8SRx0cjPk1SgAbUIODupLVH6fQeXYqRxi8kwaf79WljQDOLaUMdd7Rk5sgQ+oY7J8kO+TwSx35S6GTw7RmKexnPVooGeKsvCWF900BoPiCu4X71qPXpOwaUDEgBKyvEG15rx8kettQ5KRySKXQkrt4NIpq1ND/MLMa9RztJoa44JnW2h5/JvP9m1AX4XO/mVT1C3g0cIgt6FIwEFl7D69T8MXsb3fnN7xdadIuGirQvRvq48JY+IMNzlQNqNfcUeA7PJaPRWUv+VEa3ggi9Wr45c8RPRYdHFfqRtK5TPlEsyzlueH13OvvbMij8vL/hxpDjyt49+1eU2GreltbCSeBlonheGQZSrBk5FKZUkRa/lPSfZN4worq/qOvaLp8KqW7KYVwwpvqrMFayEDr1KWlYb1jrwV/XHc/tsi9YztfbYNBjFUEfA3XIZWBtp6JGXOdNG5gAIIrKQRWNBtuwHWocZD5Q5IBRp85UHGqEpvFrIw/HB8nPjAmuFlismSCJNViba
 8LRVATMH
 tvQe734GM33EmeWYx7Ct8LwVOYuMbPkUb06DNAXvUcgJqA04jcRNaNvzKYWiOziPy7qmBmR147Op63aSl4//G9TV2J774Xe4fXAbhaLUakIon8Nu6vZ5dtZ4pdBLdqNPq3PW/LKGNU+kA+JJbVkKXATP0QGCDJ8ghAafgPy8soevbsHG4cXb64J0RLW0tS2hyT39EtuU/0s9XVpsaULyQW5uY3YQ/LgApdvLd0mXF+FlkHlix070ouJFayxAl2m/LBNfDlZcv7T9GzVhDU/1hHTp0dyHSpVBbLTqO1H1LyIKgacRvDCshyRn3GmGrPvWQjcvQPurPJTxNAIsjxId4jEiStsl6ej7Ycit+b+togFfHwyqtFAjQLWH5vikY5bwtj2TfMga8fuuU8KaH17lCP8LGw6pKhXgCY+Oi8DFme+qjB/AJiFjpBYEQkHKKCV+5ZT9REmY3TfRV9dbk+uaSYcPXCFtlWFF021Z2K6jBxIj63OoRMTCJuFB/0IdJMcRAKNkuOXc1pQNOf4SlQ6XhXvr1hYK1BBQFhY8PKo2RqxmXrFk+2NV44VoBi4HpZNX63olQBSoxAdruVXH50WvCIW7s8JIczz/ZZk6TOzhQHYLZceOE5ZhlmKyNGt3dTEy8cdM//8v0WfwVwG07NMkHwVKbv34SslrWH27gfcU5PZ25gxleMqZHCNQHzQJMNnkXHSYrLPe94hs01QdeZx3E5rD0T8q3RdpN2jUxZhjrWF9VCvcadFu7U2ZcUo92LYVlMJg2xoxBP5v9GI0ndDmblZrspNlL2nYNu9jP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026, Kees Cook wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 07f4c7209ac0..00317774a90b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -368,12 +368,16 @@ static int vmentry_l1d_flush_set(const char *s, const struct kernel_param *kp)
>  	return ret;
>  }
>  
> -static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
> +static int vmentry_l1d_flush_get(struct seq_buf *s,
> +				 const struct kernel_param *kp)
>  {
> -	if (WARN_ON_ONCE(l1tf_vmx_mitigation >= ARRAY_SIZE(vmentry_l1d_param)))
> -		return sysfs_emit(s, "???\n");
> +	if (WARN_ON_ONCE(l1tf_vmx_mitigation >= ARRAY_SIZE(vmentry_l1d_param))) {
> +		seq_buf_printf(s, "???\n");
> +		return 0;
> +	}
>  
> -	return sysfs_emit(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
> +	seq_buf_printf(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
> +	return 0;

For this one, can you manually change it to this?

	if (WARN_ON_ONCE(l1tf_vmx_mitigation >= ARRAY_SIZE(vmentry_l1d_param)))
		seq_buf_printf(s, "???\n");
	else
		seq_buf_printf(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
	return 0;

>  }
>  
>  /*
> @@ -459,9 +463,11 @@ static int vmentry_l1d_flush_set(const char *s, const struct kernel_param *kp)
>  	pr_warn_once("Kernel compiled without mitigations, ignoring vmentry_l1d_flush\n");
>  	return 0;
>  }
> -static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
> +static int vmentry_l1d_flush_get(struct seq_buf *s,
> +				 const struct kernel_param *kp)
>  {
> -	return sysfs_emit(s, "never\n");
> +	seq_buf_printf(s, "never\n");
> +	return 0;
>  }
>  #endif

