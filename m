Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B6B8CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 16:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 747A26B00A7; Thu, 21 May 2026 12:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71EFB6B00A8; Thu, 21 May 2026 12:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634B86B00AB; Thu, 21 May 2026 12:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 525C56B00A7
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:46:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0022B1C0585
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:46:38 +0000 (UTC)
X-FDA: 84792005676.02.CD015C8
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id ED4CA20007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:46:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gExHvgla;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779381997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NA/nM16UoxaTsk3A7SWQL7q3HkgK647mNtY2rDcRyyc=;
	b=MZJZxT4IqKohS1HPKrQmFRcgmuTRo4qYWfcjPi5JeQTtQUhYIt6+srDe6mY/ImkllLkvN1
	McRO0orAKKj4lU1zmjaeyX1zVJn2VQpEaX67T9dQxmKxwWeb5X1t3oeVeIV3wSAAhsJdkR
	Usm6vPOOdwmh0COmbTdn0apDM3j7Eb8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gExHvgla;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779381997; a=rsa-sha256;
	cv=none;
	b=287jbzbxQ1zxO4PysXsRWHHw37fzkEDjxrgZzSGtc+jf6SXc8uaNTomIrnZJgGwe0Ih7Iv
	Mko62Dtcs9dpEzNBcySy39e8p964KThzUIUzhRwtvpu/RiLzuHdp7CEZstUwxMyylknKJj
	MGoi573VqHYqSmhj4lu5/v955UzR0F0=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48e8132c6d0so41746925e9.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 09:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779381995; x=1779986795; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NA/nM16UoxaTsk3A7SWQL7q3HkgK647mNtY2rDcRyyc=;
        b=gExHvgla77ltsUYHbm1OQLAoObNXIkLekJlSkd3n6dyGnx5ZNTXBbp6vwusWsCQPpL
         32la+70Uf8Nema9D1C9ZcqlOiBC4ENNpUr7tk30YCNq3drniA5nnM4VCMQqrJLE//Qrf
         Tx/wC8ZN36sygpYI6MY8U+Nct1hXdyTcNuSePYYvXXrKyAxER2iKVLwvBfDBKlUkW5m8
         tCXRof3SzmUfUWthwCnhb3ilE/1loySgehsMLiODD6cu36XPL5fc6N3yQXEfVI+rvsG9
         T/geQvTGA9taxKq2iLIslQ9S0buiJlF6Kyl8dFjMvYLHmQ+Pd2CGvzNOk5TggQurJXVz
         Hmww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779381995; x=1779986795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NA/nM16UoxaTsk3A7SWQL7q3HkgK647mNtY2rDcRyyc=;
        b=htWiCo11qYkgvus4Uid/OAaICp7JJRZroPpw/85/FtmXYfDE6VooF2m7PKQyn+bdoB
         XEMec0A+4lgGoWH3T1u2oSmXl5jUpKaCo/rp2F8hyRfsyvV7TSxRpVf/KAxlEBCN0QNw
         hNk30DlCme/ExWbr3mXgXWVu3sgsXuCpWM9B+fvgXWNaHHL99Ep/bAqP5KFLxN28ZAle
         3dFrAS/abZaKMO2MLKgBoc2Ov0NU1m6f6Mwji8fRcae+tpFjgXaGQ+L9f4NFz+TyRNRG
         7mvOXADkyrdc99oiNhnesvJw/JlRKSeMoyrC8HWnqoMDSQCxsAviY+lRlbs2otPGwjPH
         PNxw==
X-Forwarded-Encrypted: i=1; AFNElJ/0jWquxAP2PLELuLdPnbN6G+26fJqauJTYoQgeVpHaYuZmnD1srimSZd7sPToTJQKWsWRH+ARABA==@kvack.org
X-Gm-Message-State: AOJu0YxhEN3R+m2nT7ymnqn7415TFeLCnbY5Q+viZsLz1K46cbX0ADB+
	TjVL2ZoDp8y4K+sI5pRT20oUttTYiSKLpAUYEje8q/Q8MCMpazch4flW
X-Gm-Gg: Acq92OEwAvUJnEFoJ7Y+N4MS8kRbgeBKHmjCUKyz5ZJ6vnhxrXzbGnSI0SqdkGawkb7
	d1yb0d5Yd8ZO6So/XvXBukAu8UH90d3tXWIyZuEN1phFSbHsmhQhlNEFErhzHcEtanhrOQizu5u
	JxFaUayFmzeVTFbmy0GUCAkED8CpPG4WVpmGDdFNTxeql4Z3HKZODz3S3C9s/3nRqwHknh0v6Bb
	KIhJdz3hGoDxIeys9qPvMsORiksCwUZyFYb33Ws7LrY7neWFlIADLFSA2qGFru6XGtBz3+pDJ47
	p0blkrp/HMSuMEMJHlMyvTkgMBBuN/76MvXPsu6sOw1DfBzzkJaxuFBmlRuTZyWcruLQuddRNbs
	rz+0qjO4Tpva8eukegvBSkYYDNG6avrAAKQUgw7mC/6UuXw+RBT7XO2bEmL5ONySeYf4AOCYYxX
	ShWOrqtnHTof6YCBAf4qss1D7d5lMHwOt6grRL8QYT01JQumqdTfWqR8fDf3v2Tseb
X-Received: by 2002:a05:600c:45c6:b0:488:ac01:72de with SMTP id 5b1f17b1804b1-49036033502mr53623425e9.5.1779381994891;
        Thu, 21 May 2026 09:46:34 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49035ecac15sm31613075e9.6.2026.05.21.09.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 09:46:34 -0700 (PDT)
Date: Thu, 21 May 2026 17:46:31 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Kees Cook <kees@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Pengpeng Hou
 <pengpeng@iscas.ac.cn>, stable@vger.kernel.org, Petr Pavlu
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
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
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
 <serge@hallyn.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
Subject: Re: [PATCH 01/11] params: bound array element output to the
 caller's page buffer
Message-ID: <20260521174631.71a06440@pumpkin>
In-Reply-To: <20260521133326.2465264-1-kees@kernel.org>
References: <20260521133315.work.845-kees@kernel.org>
	<20260521133326.2465264-1-kees@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b4ojd9rcfqoc8iux1bzr378m8e9oru7y
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ED4CA20007
X-HE-Tag: 1779381996-223488
X-HE-Meta: U2FsdGVkX1+6gIZ48cxZ6ksb4TVu9iwxKsRso3mmxoSdVEMTIy2xocf0QgiiC6EHxngmhCmMxozQhGs9ZpxwO4I7MwoBg2sXpzvpKhvXW3b9BgUv4tPuSd7jgb1wafNaQbxACbf8oCarloBdR1/1aZrjmO8tApCQK52L/IAwirqGpdzadYA1VLqK3IxMGqeBDT0JCgL9+kO/1n6LeLlI7ATVItNKVvMXsAVpFyC1btAYyu6qUo8bc2KE8bT1m4RrGwYAPjAc1+MdcnNYfq/G2nsA86pCWzxKO7P/qFRENDG4p6/QdXPobQlo/7DMRwrNfQoIaydzE2SxXGT7YzpINNJeQ0aFvjaYq1U/71w4eSe0Lxzryg7GBKBMoW7hgFURJIfPUJyHc1BqaiAeilKsA5UKVOGPJAMcPovwBSnzUuZkk4TPq0CSQ2TxrdvBQYabqu7sQszL6cnyBb5xxP815rOxUO5Kz9Gqvyv5+W+sghyPZTf58qmAi4E5+S/YvliZ4rg2Hh4Y9AMNrpReSg3T3r88ZA5YqAmQtNh0rSjG93omQtU+cpKqWjyMlbtEUY1LSEYraWzE1FfktJbYkUN7Clch8y6O1Ym3CwWrNzuuuVBPXkasgIUPvftxR3xAzX+5v1pjgjtV/w2s4lLhbqW60YaMrS1Eq4pw6B7ezRirIMNiLV9ZWMta6ZMoCzY7RwfC9c8dHwt0v2ADSKwGaNdiBtMmCgATXXxJMs8ijvEYzg0qkG9LFUbrnAFgGa8HnxtVwanWBeQOrDOQyKOkM38n8pk/S898AXt0CleKoHC2mhMLK23D/N3aWOoXb1nKL4TjyJ1Sjt92PC4Y/c5nX6L0SdF8qmdi0xeSyHTfwXFBg85EFh6bleVFFUoGxO1d6GZMJnWr3aTygMzSw1IiOisxieTEgthM7aXd1cti3hmr1ns/R33yYYBydWQBXbYMCCgXwtte1rbmUsbk6CG4uEG
 kdhoHw8M
 0nOPVcQBDZ7Gf+dNiC9d9sC/PS6HZ7Y4kMBPCql/Rqky1ZdorZdCMVeDRdL5GJVnZLogWvAHfg709qimUUk2I4ZjXswTc/8TJp4/G5xCujyRc1OOrKI9FBzoEsqazY66yHsxsnrnqY2qoxb/akyDtH3eAxU/cyUI2y25SjosDhdnQfQS2OS1bWHO5SrRu7hW/m4j8XYV9HpUHM1MsN4g7CTRuNoPKtTwQThJ/0bAV/vW2XLIP7Wr+k1riO9AnKH8GB6GRYPmo6Jb8WvCEonKpLJLTaS/zFsB2pHZGYyxXEMnoQgBVyF5VTCEJ20Ol52BsW7TJCjRTc+o7M9nPzdXgWx5/jdJjvm8yttFNquBj3lyT3EZ5+FHrvLtMKgz4d2Q1bX0Wkit5ty41+Q9yQ00g8Xfi6pCTm7mOU7dn0mOpoOJ/PIulYTqcId+z4ARx9wH9w1Ri0IRurvJXuXs6lBhZzrLxfO5QbnEKCwd76frSDNJQX2MKnSYgFWKZMrq6ag0BaSk/huWsItCpX+Y55uGbxq/GkPn/hQtwnTuxvydfgpsdETP29OfwlEspol7BtPUHbG6TrdIjv7pqCkw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 06:33:14 -0700
Kees Cook <kees@kernel.org> wrote:

> From: Pengpeng Hou <pengpeng@iscas.ac.cn>
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

Should this be using a 4k buffer on all architectures?
Initially perhaps just using a different name for the constant until
all the associated PAGE_SIZE limits have been removed.

-- David

> 
> Cc: stable@vger.kernel.org
> Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
>  kernel/params.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/params.c b/kernel/params.c
> index 74d620bc2521..752721922a15 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -475,22 +475,36 @@ static int param_array_set(const char *val, const struct kernel_param *kp)
>  static int param_array_get(char *buffer, const struct kernel_param *kp)
>  {
>  	int i, off, ret;
> +	char *elem_buf;
>  	const struct kparam_array *arr = kp->arr;
>  	struct kernel_param p = *kp;
>  
> +	elem_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
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
> +		if (!ret)
> +			break;
> +		/* Replace the previous element's trailing newline with a comma. */
> +		if (i)
> +			buffer[off - 1] = ',';
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
>  }
>  
>  static void param_array_free(void *arg)


