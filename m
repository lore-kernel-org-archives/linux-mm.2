Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA682CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 13:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7646B0005; Mon, 25 May 2026 09:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370D26B0088; Mon, 25 May 2026 09:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2116B6B008A; Mon, 25 May 2026 09:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09AC36B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:35:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FDCCC01D4
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:35:13 +0000 (UTC)
X-FDA: 84806038506.07.D2A6739
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 83219100006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:35:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LknAp5gG;
	spf=pass (imf05.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779716111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9XVHRPBSt9KXo5wrulw6nEDVPqzcFN/DF35DZwL4F0c=;
	b=GR7+eWQm8D2dTJEjl+Y0Vd+1dAeKh8DVT9W1xc60IiYNQEUJY/ImHajyOdTEjkg6kmWhKX
	71r4RZOoq5cF9FA3PpAeEZwaAaBjzyfKeccprraH3LiklPl7q1mnbz/R56puIcLurtJ0Mu
	+ua1x64zrbhM798TWrFRc44xbnU+u/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779716111; a=rsa-sha256;
	cv=none;
	b=MGUO3wAyyV/xAz9GErX9niu31sd95dK4dieAF1Wm6uprQwjXr+5qITKFmaqOZQ2bXREPBV
	88jrgMtTnTd8xqnbhyMbbBuP7K0f1OepPcGwGg8Kfo4kiYN6mnkwEiBbC/shzwgWzt/cFs
	UWkVmbY/mfAwedhEai6jWlyUx7R01+c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LknAp5gG;
	spf=pass (imf05.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43d734223e4so6077898f8f.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 06:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779716110; x=1780320910; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9XVHRPBSt9KXo5wrulw6nEDVPqzcFN/DF35DZwL4F0c=;
        b=LknAp5gGwaT2J6ZFWbBo34JpocT/NbLjRYjZ6ZNM7mDPtEk7dliC0rcoGKEejAxapo
         yEWqkMaPrj+7f4rBxIKYoMwl7sUWAfkcew9BYsdZFd41z1zM2RLaxExf1AtASklUZI0O
         G7OiaeQQEQuf9EwJ6wshiCl8zVu/YPDExrWVk800EPJna4gMgNiWu6KcKYY0z1fcyDBw
         B0bXQ4BziuVpQtqkLuJZzJ7JW8jBT3pEPm/Uq4c2Y5bjjLQqDbEhjHtikkWAJsrMqb5t
         fwqqJofOH7MKkxS87xgCU6VAufDM/t2VlbvEXrlAlb74LSl7J8Cita11FENkWiaNX0rG
         349g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779716110; x=1780320910;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9XVHRPBSt9KXo5wrulw6nEDVPqzcFN/DF35DZwL4F0c=;
        b=fAHa8cJdpBOrKjnfxLUCvFzAistCcabASz5J5sDOhYLNx/HoTLCNZpaf1hayCBUc+9
         pVXDmw00JZdKcUJvqjESR1/xsfUgASYDjWAU60tkBUafEjD/VHkZXnW88FhfKxtcmZzh
         tSsbGGrjdZW2Tirw7olqIoCK6doiyebbi+6b4ZZTzAfWO4NvE/mlQBdwyQvjZtr/08l5
         Q7arkCS1zeAOR5So4S67y0f6coS1J7qN3o6Gbms/hJ7qXh6/eAyGFFQinbu9EMYldyk+
         toeR4Yd8vucrtfzabWh8FVp3fTaU8lFVT2C4vfPMBfL1MxJEvvDItg0XrnMq8UUHHfGj
         2EAQ==
X-Forwarded-Encrypted: i=1; AFNElJ8It8Qx01UXyRtfMLxTkL9zMltVBtaWXHHcV375YrMlSejCXRfE8jqkymYMzfu9jgQFdSeO5XC5QA==@kvack.org
X-Gm-Message-State: AOJu0YypVg91DKqyso+DhIf0Sq0o4m8aHtCqwz4kz54cDag1mIwC9dT2
	Ee/7nubkPsB98BwA5zTHx7SfLomCefn2n5BlP5+3Z8ZpZLwE5FWVnwRGQ+CnOpPenLg=
X-Gm-Gg: Acq92OF7Sddn8dOqcT2aWoDFF1KUEvNqWZ5CmpRKlxwO8VDaZVMRLZa+LJCy7A5rkCL
	W8NLScRkWvqUEnLBdvmeZ4VZgp3kJTmcirmye9kKdENzZnKjs5zCj/orM6yaYa71M/t8uxK35lw
	Dxrp+qjCpjiPHTAKS6WXHiSYgg+ZJMvakv5mlkFEKDeN3gOwslqrG+bqD5suxqzqfUtRvQSFV+Z
	aJ+tvPfNg6j3D1G6pCOp46jjJe/suRuWIdjNaxfZel6jn8s6lgAdM0bMYOYQdsNResAxUXm+A4v
	VTyBToCvXN/y6cfg/spDWznL388f/Ib9R7/VxsQxpjXLJrmgxWV31D1teDrzWQ4pwcAF42OIK/e
	aFBeZGpBTbHnUMXB8bOa5vED7iqCXvO/A0PFvq4p0hooJlnwupayfoEiDBqXkXvj3hzkwootrjj
	FB9xEDWJUBUHY/gqhbzjWPjoihnnCSTDfwbIsTSbkqkHoVLcykqgvlbNZvydZyPE3bWE+P+BS9n
	9TUnpOVKhU6cygRk/LuzQswDKEsgzBQQuvMDpXXhYHmTouumamz4kvZGbZkN3snIeD0QQ==
X-Received: by 2002:a05:6000:2008:b0:45e:8cdc:4ee8 with SMTP id ffacd0b85a97d-45ea3128ccdmr31052715f8f.6.1779716109692;
        Mon, 25 May 2026 06:35:09 -0700 (PDT)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5cb9asm29456456f8f.27.2026.05.25.06.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 06:35:09 -0700 (PDT)
Message-ID: <da358ae1-91b4-4a16-ac76-ffab99c230b9@suse.com>
Date: Mon, 25 May 2026 15:35:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] treewide: Convert struct kernel_param_ops
 initializers to DEFINE_KERNEL_PARAM_OPS
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
 <20260521133326.2465264-4-kees@kernel.org>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260521133326.2465264-4-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 83219100006
X-Stat-Signature: 5ebxm94nyhq7icen5zxyi3frqcyo5sgp
X-Rspamd-Server: rspam06
X-HE-Tag: 1779716111-903454
X-HE-Meta: U2FsdGVkX1/KHO/jlyxFawtxa/v0EnWDOGIyUHYPGfElh1ay5kUzLpumx9PqK2ub3T/lf/UwILglQyn/SPq95N5E0k3mAAU2xjAHpdagbQLcBFhSOBLKZ86D7w6YwJUE3CgY7JnTPZQvP8DEyCa0CfUT0HqfTdQx3TKgvh1PDNM1tphCZJqTgIu/KtMce9Y9R4jrpNkqaPr2BZrpIzlQ2OUlzkAT2//G+uipPDQI9Oufstz0tH+LemrK9zHM6l72UydPJyIsI7zSgrjeNREguHVq7vzWV96XZLzRgkN7WhoeePc9cmQnoiIM4gphWdHyuxaSMq1rc3Gr2l/xR5OUecZ4fMpkzik46RWfz+tns3vsM3Z9y8z7HgXSeidpvYtxwckeEhXQNBa9m0l9gQYAokLY6hawX0M75QufCBou45U4zko0N6EDftj/kaRxK59jiRGa6IXoA+K4hYmNrzzbHImlCwv+02npfeOv8wYe0sxZpn9v5duzdWy+Z3nurJ/VWzvVfuEUC7jpTwiZ467KcMRX2JxRSdlPxEaxnIU1BI5gADa+2UJH0zy8xdRnvx9IhS1jT5/Q75v9ceh/F8rT8FS3pCk8J3oWOUtHF/GzOp/5zm73EwP7Y1RLiZVs4rBjPYOLLSJLSNV2WLavIJ/ElDD9XOW/lRdTb2QKJ18IkYwYpPSIcn84S4ulTpRxQ8gSXNGalEyJ5DgZG4HtewsUfQ635MzlfpgbzdgFs/ZWVkud2N1Qc4Hm8MV55idiQjChP5ll4G+tr42KLeb2RpN6XJDkdKMVIjAVmmLdcOsmRqjxkdWr8ZNbDCgJw++BNvIY749HgDlWffYPI8mxX38mhzjVEsDYEMxg4KS5wLVobinijWRK4WE4FZ7tuIYu1oA0eoOxr+mNgAL5u/vQz2u+4honyXqtxeUQGFIuDLCrYDewHwIRI9Ia/U5WlAWNcDdY0U/QWgHxMNSuMyBoZ4U
 ti6OAWO8
 tJx2bgVbS+7APqTuKdb6inM9W6S9H/oAJxN7RU+f8FI23wqYbHt7eUGkmjdnJX5CX+H0XRiutMEOk8voCXOQKM0XY0lJbm3jNbWIaBmycR4Xhu4d1RlGrcgGSyLaB/UmtCiDnBdfMPU7l1dsit25QO/QefrlSN8+533OA55asbenDLwUSTgzzrfbiW6Nki53LAAzYSz7gfQ8JKL1jM99IEyZJO6YWfA0kJWCIewRBb4iIhltNZ6dbjiIC1fyREiZ65y7wjk/qQHT1MhiQGJRsVmWDjrayXTqSIl8KayVLPDoRiSgZKQ7sXZrqTHJwwl2DkZpVCIUObtWVUeRzoB/vyYonSnUdOxytVgUf7ZL4kNAO6iBY65cgtsauOJyPVWdhCaHgl3JHN0PQ6jEirnKZxcSCxnp9BOZkeJcaS41mrbPpzawF8TWqnOFBHTbjEnjDJi99SMMD9/4MQ/uvIK1p77jcOZ/OT56JiecG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/21/26 3:33 PM, Kees Cook wrote:
> Using Coccinelle, rewrite every struct kernel_param_ops initializer that
> sets .get into a DEFINE_KERNEL_PARAM_OPS-family macro invocation,
> for example:
> 
> @@
> declarer name DEFINE_KERNEL_PARAM_OPS;
> identifier OPS;
> expression SET, GET;
> @@
> - const struct kernel_param_ops OPS = {
> -       .set = SET,
> -       .get = GET,
> - };
> + DEFINE_KERNEL_PARAM_OPS(OPS, SET, GET);
> 
> Using the macro for initialization means future changes can manipulate
> the struct layout and callback prototypes without having to change every
> initializer.

Nit: For consistency, I suggest also converting the few remaining
kernel_param_ops instances that specify only .set and no .get, such as
simdisk_param_ops_filename.

-- 
Thanks,
Petr

