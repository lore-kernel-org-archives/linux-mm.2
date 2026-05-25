Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52015CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703686B008C; Mon, 25 May 2026 12:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3E16B0093; Mon, 25 May 2026 12:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B706B0095; Mon, 25 May 2026 12:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45CF16B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:19:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DCD8A8BF98
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:19:26 +0000 (UTC)
X-FDA: 84806452332.09.5594327
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id CFBF3140013
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:19:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=F28FeiLV;
	spf=pass (imf26.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779725965; a=rsa-sha256;
	cv=none;
	b=3rUWb6L+dDHjdyictzZpeAgrqVDq2F/q+chULoWmW3mqeSuHGXOWHpyZc7pg5HbzreembE
	lk+JDzK47hbSvu4dgpqL1n7+uW3TZLFDJRsXJY4eRT0yK9OVb5kdh3ssoedPCtlhwMz+1x
	q08C0YpBma5mZgavRthxdTcrFEqrRJw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=F28FeiLV;
	spf=pass (imf26.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779725965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YA+/JJXQ9abERc/NViF0XyaL5qdJ2pUb4chRkVwshY=;
	b=4bB7ovaSHdNsj2Y0HUNGWxtSG43d8I65l9W0VxxORThDQvocZfjwMfgn3y2MZmwUF8Kt8j
	fWBhN6gfOYPNipdO51ukInzF7DS4r+lz2Zvp6Pe+n3hbPdkitpKQnkXmMCpT82hSlOmznB
	vj86LmW8NeZX5BSv1giLlVxnB9/Sx2M=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48a3e9862f0so51631255e9.1
        for <linux-mm@kvack.org>; Mon, 25 May 2026 09:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779725963; x=1780330763; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6YA+/JJXQ9abERc/NViF0XyaL5qdJ2pUb4chRkVwshY=;
        b=F28FeiLVNUOx/IK1U/L2S9f/InRGSGaHRTf+8orWntErvmgJEbp/3f0sfPetdhO6Fh
         QAwKkduSKecMEfmS95JH9BW8LoPYOj3eCYrGCA6V3YftYRPS4B5sBM8XyzdtLXHl08tl
         H5WYzG4D+eRud5AG8Nxk2Mn5sIOGi1CQNjykG+vLDmKBmSocDY1h58HkB7gBNGxVTjeh
         tLMVqSaFR9jwf7MGZE4A+Lmq427KMKSF0bvhSnUkllFKE3bHOgAmsaxwGY03XzlL7pjT
         tS4bhzeHWHyTYtqPOO0iGkdQ9wB8jf7dkAJCv4AffxH6aQVD9Z/42LcpKNwtH2tfK0xw
         oblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779725963; x=1780330763;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6YA+/JJXQ9abERc/NViF0XyaL5qdJ2pUb4chRkVwshY=;
        b=WgTVuQtD0uG59s+IMspgEyEwxVT0Dv8316RWz2U2r3Hf42BQIPVvycK5FZ3po6AdTj
         vwCo8QclU/9BuXEcgWukErLJSU2e7UcnIiAdTh84dWUQCCts36Kd2RfiFI1IbAt1RXe+
         8I36Ihs5Ev2XqFk8UuqRDyf/7FV1JhsiQbKCc0U3+uO1Ulm4fcXoWBU1V2tlRvgQ2/5D
         AfxLIlmKK2j/QuPMp37tedGRA/bvsrvEjYBLsyNkQTgKLpmITOsYOmfjYOqd0lLc/EHi
         Gjvt/bKQIBI5qsqcYMRLSvKcJ/kvi9k83E9f0FvjF/e2PveIY1K3KJcAcWq2QiWFWXJO
         6Xow==
X-Forwarded-Encrypted: i=1; AFNElJ+VaSWMHEZFUBh9+A2s4yrx20mXsJ+tWk3P+JiP6FtLxQ35hfam/jGIndF9v7KgLvpZqGrOaQg+BQ==@kvack.org
X-Gm-Message-State: AOJu0YyWVavSxu3/kYTG4YIKXP2G/vSRPBqFJW+cbBOy3lUrDLUXyP+H
	mbQJ49ieqWPXhlf7B/+GwPiI+N9hyXO4rW+W9Li0LQs0ZjyZ+E6Wt121ai3rqCyR8kk=
X-Gm-Gg: Acq92OHkc/p+P/W5fTIlDhnYZnTrZepov+z+H6cYPN8D1lrTiX+aMLKS++GXu85+P+c
	+UibgH0FhJdS03OdyvjmPktCmIluoyfjDd5SORMKNERSboHAcVXPK4tKz3s0+qlc707wPEymKrk
	3vI0rBr/jVSU1GXxvtvmIh3kDINMmS1kTCjzm9ozEma3DgLsx+810JHUlZ0A0ORs2n04HVLT3X3
	rZFx4CMoKJTMP6W33OdWoMAOa19g8VVNtCVFzdtYZLQVij/BhmU/eiHSx2M26U1+AYZLyXbNW1X
	5gtV5AUpklmJ+6SJeLmSkBSXia5G939pbLpUMyWqqpfd9bt/wzRMd7Y7W4/mQA4Ag6r5lhJszJG
	BbpwnxwzqZyb2amTosG5x6EYEk9jdAtLDYjfFeAhYVqegPGl2WpC1uNOVqmxsk6CanHfcSIe2su
	61+IisR5V6t9SkmQOzxndx4WVfpu6DCD9UWdKt9/uO88jcxa+dbaA6z/Bz7jPT3zN+laTbiqob7
	LS3aFK/8wwd6PLvlkMdymGcySxsOKzs2GXMKarCL2kMUNaB16EAFqEOBgG6jO9VGtV3RQ==
X-Received: by 2002:a05:600c:3b07:b0:490:f7c:b19 with SMTP id 5b1f17b1804b1-490420f67f5mr197977845e9.0.1779725963153;
        Mon, 25 May 2026 09:19:23 -0700 (PDT)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49059cc9a91sm48939425e9.1.2026.05.25.09.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 09:19:22 -0700 (PDT)
Message-ID: <a4c7ccee-6189-4c74-bad8-57d1438c7d8d@suse.com>
Date: Mon, 25 May 2026 18:19:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] moduleparam: Add seq_buf-based .get callback
 alongside .get_str
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
 <20260521133326.2465264-6-kees@kernel.org>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260521133326.2465264-6-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CFBF3140013
X-Rspamd-Server: rspam03
X-Stat-Signature: w7itgoyp89muauhar4un478e3kesu39s
X-HE-Tag: 1779725964-715090
X-HE-Meta: U2FsdGVkX19eIB7p2LDZ8i5PabIygR2Zfo1uBEKcbns96XaG3VLcaiSm9xibW3LZDLMVi9S09UBJ7lQWQngo6TVmPm/ogNsmQwWAGzSIaRyiLrlNSXavIgksgTs9Z5uINAXplF9tDmPyjjm/rx821/i3ortLBE9SwmZwWYODWawIvJJTUGT9H/Ss2/PLhcm65zUuygJBzwCraLV7Hu0XItWawQupwpWRQqkLCGRL8WrnexJiXrtkgvjX3iKhBXWKCbN2+ebVBBQ+eAPrQZU7w5FRaWKJSeMu0qceBcenoupvE4C16PGSI3k9o24VocOYr1AYCcq9BQjfwd7ACBvrbOQDtrrNOEN4hI87h5CysbnPWiK2i432qoCs7lJwVQCv/qEKgFQyvy34f935NmLQVPuDp/n2a6MNbSkH7CT0Xb7rTywU1+yqjvGF+kwKXIR4K5Kg/H9WK9/9U2J16OBb8bUTd8OO7f93/LaLCUO9b83IvDqxRFtu+w5Ht2QM+7zsIvExA8koguX4xEJOgPdZ6bdBxMGYKq7yzqXcRFCcj2aGewqpKqYWbMmhOKgLl/qMA1sdkxH8EKEmSHzwLswk4vUNVv0YlLZXJ36c2dCYNvCxURiOMIk0Wk8yFSsMf9kW5hnb8+5YvrwkAIWo7e2Q0BzhYmYBbzWQJOPG1e5CDcJMuWFn7D7MU+apIpsCb8/clrsK0rPCut5nuX1dM1gFVaaLaw31ecKZN7KzoEuWqPDXspJfJvSlJF3QjY+s1u7noULY1eNVnYk6LaSw1o4RrwNGP1X8sTf1d2VyOz+PyYVZY1tZtsoxluvvz1p890w7I5L9aXIoivZGdABNkkNTSKkXO6M/MsXeofQZN1B+bQOxUi6jlCtOCEuSgNjiHSslxxulPuOZte4Nm10ZMs1eaXV/goKXejF28X/7C36ZKbGr17bCWW5AkppfABCcD71s3G0y5dG969fSCiNejGM
 GXDY+S8Z
 26Qy1f39mlS7emSgDXb15XY2yw1ArcLxPCIjSgUBvBW7nyA7xQI3/yqckI6+pnVjgYCbtZfTpwwQzwW0Tgc50RhmUvG1kONOe0klDDPfriohkKx/x5nDVGvkYfGylhmCBnj/LgHdtG5FooLAu2CfkFss2VdMLle36HpE1IThVkziezkBYCC7f1XfbmddJPiQZs+BultxjEQ75n8CzgnO91rmjk+WBrvma09EslKNCBbcJSMBeSBGH9tbH0sYVeDMV71toVqOPfhJyxaZ98VZSu1ekTXTAY3yZ/qOpkXZsWAo9mBZnDiLqPTDdTy4KoOhFntNBwZDaf81hGovp5Zo/PcporZdOEmo2TV3iVQWv7gVVGaTwwSSyr995yIw8Usr8n54xb3Uu34J4ZLwtobx5hGVgosKnYXPJFiQvm1nkFwaldPwMNGa4JJJY+QnEIpirPrxJSW0Q+u52p/yuqT3DxFVqdYCeE9uIBkqz+PFhq3kZ6J4AYwpH4ZCmZRupu/FCCTuQvHWMfWNJZ3vWIMuha03n2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/21/26 3:33 PM, Kees Cook wrote:
> Add a new struct kernel_param_ops::get callback whose signature
> takes a struct seq_buf instead of a raw char buffer:
> 
>   int (*get)(struct seq_buf *sb, const struct kernel_param *kp);
> 
> The previously-legacy .get field is now .get_str (char *buffer);
> .get is the new seq_buf-aware form.  param_attr_show() prefers .get
> when set, otherwise falls back to .get_str.  WARN_ON_ONCE() if both
> are set.  Return contract for .get:
> 
>   < 0 : errno propagated to userspace; seq_buf contents discarded
>   = 0 : success; length derived from seq_buf_used()
>   > 0 : forbidden; the dispatcher WARN_ON_ONCE()s and treats as 0
> 
> The default policy on seq_buf_has_overflowed() is silent truncation,
> matching scnprintf()/sysfs_emit() behaviour.  Callbacks that want a
> specific overflow errno can check seq_buf_has_overflowed() and
> return their preferred error.
> 
> No callbacks use .get yet; the legacy path is still the only one in use
> after this commit. A subsequent commit teaches DEFINE_KERNEL_PARAM_OPS
> to route initializers by type.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>

Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>

-- Petr

