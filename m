Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB5A5CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDDE16B008A; Tue, 26 May 2026 02:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8CBD6B008C; Tue, 26 May 2026 02:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B544C6B0093; Tue, 26 May 2026 02:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A169B6B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:53:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 374FA1A02CD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:53:13 +0000 (UTC)
X-FDA: 84808654266.22.3F00DC7
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 30D814000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:53:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XnKH58sN;
	spf=pass (imf27.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779778391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXWASYjT/jE4WzpKhE8nVhHkzGwmPlTITkkcMF0D8BI=;
	b=cA0alqJXFhcqlIdeflyRgoS/Efte1ejjMGeOCkXuqPgBz0ZC7xAtzlpGJNayRyu1gXGsGL
	EDFEu9DdqYjhhz7UjVJijU3H+vZ9oxeeXcpxmyFy/IA+RcUWoipFnyVQR+7FfrGve1hsVI
	0i+NhfiwsyBwm1ze/u874TKg7S8zhj8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XnKH58sN;
	spf=pass (imf27.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779778391; a=rsa-sha256;
	cv=none;
	b=WxOUWnnu3OtW1FagCtcjhonmjE6pfSFmSFQcbZJRF8sPAwgAYLN1E4uRF7rN74R5ItlAWi
	BvtJ1x6nGeEowV4ZjC6VC8EIoFVrecKgYbO1jwB1KmYUmah3g0f+HjRda87iYHF9NhapkZ
	gohrr1G3WenoqkanDHojv2ea1qYZpH8=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43fe608cb92so6170172f8f.2
        for <linux-mm@kvack.org>; Mon, 25 May 2026 23:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779778389; x=1780383189; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yXWASYjT/jE4WzpKhE8nVhHkzGwmPlTITkkcMF0D8BI=;
        b=XnKH58sNJBChzqFZiKfgQtxsV34UoZob1zn+ZbwSqtsZ+a+4dkdORCDCpQXirvy5g+
         nSe00yR8yEYANU6t4otIKraOm1oczC5ma9nPwb+tdvKQl8fYMKU9dqqvBnolUYKkuiiW
         tNiG0eumdANgLUm3WEkCfNh/jFDw9QpdvJ6bGg0astJlz8QT+KHkx81KO+CBSujVRwAi
         1A5hEicX0gF1WcOVi+O1GmszZsIA8NoSF3qoYEgKcK7ZCPk12pfmfye7Kxd6gSu2nWXr
         zRRMSu+eeGN82G0cjTHc7K1taCijphYCcgoDa1dzeamuaZ/gwnxuwTC0l7w5mYxqPw/Y
         Ny5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779778389; x=1780383189;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yXWASYjT/jE4WzpKhE8nVhHkzGwmPlTITkkcMF0D8BI=;
        b=sc46y+wiY2TDGzjAIWhCB5UPUDu6IJawD65jo701zQ2VEWisiII60heQJ7edD0Ypay
         1KLI5USZB2NIxe6qRnLvYHb9XcILySVO5K5GJZG0XAGOdPea10aeRibAqIuSG2KoRD4J
         P+yER4lx7R/Dn9kL/4C65ttNfC4+7CWo+5vGWaJ2UNT7+pg+zVcqOfA8reeRIXvYQbEb
         ZYWz3WWr2wbE5Khnk3zXQEcNAPQQV7Os747E41JdQmOko3BGqF6gyXnv5CLLWMARJls8
         0vad5RyCBtNbGmDp2kpEvx0PMwiSVOqjQf8WMA8DAh8zv7/wwlN8EgRDQHrwvFHKqSDv
         xCVQ==
X-Forwarded-Encrypted: i=1; AFNElJ/hPW/JccmVSYPiT8+M+WQQzH7A9hTfpXFuvrlG2mUseWvvsSPfkuu8KupK1rBO9YTE9gD9B2i4jA==@kvack.org
X-Gm-Message-State: AOJu0YxLmeO90iqSXjs5toSLDPtdMbo7F86qDtodPyOTSlZiY0MLiN+U
	dQPWMU9WwQW6dvoKUXGBwaEb2hLYAMB206g2xfl6y4lGvYmjkKLL2GACvZP3ENSCIg8=
X-Gm-Gg: Acq92OE86O2AETawoE5jkF6o2sBS32e8C2goeMld0lANheWw+hzqQ1cZDWOrsUDc+ms
	XJBsAaeF09Kd10ZBUO/xCPVwQIiEo5VOpxO9V53bBCOV3BCtmNCdBTLJRpLx96DnpF0F/8uWX1l
	UYFCEuIirjitEHwZS50G/iJ7zHf/Ntw+Mag9yj9PNRyNDOL+li40hF/yPae4tBaYbRRlHMXOsAG
	k1EWpBvmBWRFhe/uzxJNkLaRVbNeIPSW127+SMpg/De9yfkS7+ykroI+wwoXnro7AApuGkhRFbC
	6umA1FuyLxH0FHGGcpfkm3utk01RpC97KZ7lcb9nOzkFVfkkNCDF3i8SIyDCjYIL+dlX0/hDvVO
	f3ZN6fpbd7CNwWFtvir+83+UXVmiahMEk7bAxwmeVklMV38r1XYkvOt/xnvFgww39/ugNZ0jsy1
	R2Me8KcA7aSS7bsVSLJ53uy1MrLvw0I3w+3V3gZEP385Y+H0WTfBmlULeR+hLZLKbemU0x0kk6u
	1YwXP9VRoTBKOdwQmkQ2rg1hbKyGe/62ZO5z5S94h9qawAsmmEWSXGdo3LN169AXlL/ZJoA2Cb4
	gLxC
X-Received: by 2002:a05:6000:2003:b0:43b:4136:1e6f with SMTP id ffacd0b85a97d-45eb38e4b46mr29516257f8f.38.1779778389230;
        Mon, 25 May 2026 23:53:09 -0700 (PDT)
Received: from ?IPV6:2a00:1028:838d:271e:8e3b:4aff:fe4c:a100? (dynamic-2a00-1028-838d-271e-8e3b-4aff-fe4c-a100.ipv6.o2.cz. [2a00:1028:838d:271e:8e3b:4aff:fe4c:a100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9ba2esm33848641f8f.8.2026.05.25.23.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 23:53:08 -0700 (PDT)
Message-ID: <88c5ca1d-eeda-4023-bc7a-397b92780db9@suse.com>
Date: Tue, 26 May 2026 08:53:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] Convert moduleparams to seq_buf
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
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260521133315.work.845-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 30D814000A
X-Stat-Signature: b1fa16geoo819wu7kb3ga945oi9n4hob
X-HE-Tag: 1779778390-16952
X-HE-Meta: U2FsdGVkX1+ec6ZFHyHKV+kg55WrZhwEeUtuXZ5XvbTt+dZJVE62pelcCCQSkOVHvHhW9NCJKb5F5zSOMeY2ZHyaHwosgQv1cQsQQFsm8B0xr1r7nSlENKN6ycYj/2XzrPxUzNFAj2uQgZBbigyHW+9iRboEs4TSCiDH6rDzX4+kVZJg8ihAETUKXUs5OztDTErov42pJuQrDcYeHFbXfJlr/0EBcTmxkYIpi4BoQV2a/GuaDdlxSrX1mMZmqN55kG1y44R06hY+gfAYHF3qtCckbPHspUn1xHWUwSUVCK8KgA87LI1OxebygTzHxicMjJMQHWIJqngtT9VhF3e+i7W01szjH+jKPL27fMUqjdtYGqh59rhxfeeq1Cf1k/Z+weGGVobWLbuqVK6hhBRotTSFgfeVwSESQbt7mH7r0xyrcKS8c+JawXrwdfG0NrNjtF9ZIUPe2FeNFljFuKmG8EFqH9qv6mswzLJmHt2A4FcoFlcfkVg4qKseMF3xJCNpLpZ5j3ndbcl2Pqq8pFu/VEjZJ/G26jtUi+nN7L4/EJMWGPds63vChuhdpSgbQRH6V3kn988i8uh9IiFdJKZ8ka5SDrKfj5DlczYduCnp9w7clYrtsr/G+RXwa2cCIaaN9cy16q5Wqp0YVV5y1p+gMhgsFh0F9oLGv23DNPNdmQq+85NUs0jWCDNhHaMcEgCMK0J2oDJj3GTX9lME/ZNsSaNrFXCTwkU8PsTN9ZWwL3Absb+HJxCVPYmrHuJU2hJcnk9KPDQ0jGkg7g+ZalUcjxpGraqMuaGkiSRcfD8uOTX5CsgNZdLdYGL3DKgstJqP+eTFeIaUg19yIbM6dfjpPxTbFm4nVserZej7G2yeCWrLVUDKkslguCfM40oIVjZFbnBVk7j0YdcX/U6mZKvNq48UzvABN/qJvOrt/kxp/pFEv4BsV21fA7v85YwesNOYaFqZLM2BmKejPGm4XAs
 U1PObTim
 /NbfhrmswCwPDb266Hy4c1+KZ1flBwkh5stNlq2MgKCIkm/Q7KRg5F/vky2+swRq863ak/X6dftwdQbSdn8P48cVKBpQy3lRBlTTFoYwjKAGB345sPr0qmp6wYBQtL/edBIHElP8o95uu6h3LwD052RqD2PQSfbxYdjJ50p+UjQ8Uu2tcn2kDcBmMdnDyMLEDLAPQZrMYgKoY4Ctk4NqcLe1yoMyQEzj175Rn1/n1j6ReLhE5tOLPxYa++FfhG2GoAd9QC7NVqvmtidTiU39o0c8jpyryYgDjSWQUyHb9T/h9LD7qSESt5XOfYUS8IrAreGE+7z3kNSWUF3uK21xY2R9gEyB5aWDRvOa4JbJadLL37vOsV37W7EfG3D7YabPzJTtUsout+DjLJ/WDOXjOhVKJ4MxC4w6bKg63UCMpUwUMc6vKQstyIetzZIA+BdCpPdyV5SdcmeVFSD4Pzn2C4umG5HkWRptvrXpc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/21/26 3:33 PM, Kees Cook wrote:
> Hi,
> 
> I tried to trim the CC list here, but it's still pretty huge...
> 
> We've had a long-standing issue with "write to a string pointer" callbacks
> that don't bounds check the destination (and for which the bounds is
> also not part of the callback prototype, even if it is "known" to be
> PAGE_SIZE, which sysfs_emit() depends on). Both moduleparams and sysfs
> use this pattern. As a first step, and to test the migration method,
> migrate moduleparams first.
> 
> There are 2 "mechanical" treewide patches that are handled by Coccinelle:
> - treewide: Convert struct kernel_param_ops initializers to DEFINE_KERNEL_PARAM_OPS
> - treewide: Convert custom kernel_param_ops .get callbacks to seq_buf via cocci
> 
> The last treewide patch is manual, and may need to be broken up into
> per-subsystem patches, though I'd prefer to avoid this, as it would
> extend the migration from 1 relase to at least 2 releases. (1 to
> release the migration infrastructure, then 1 release to collect all the
> subsystem changes, and possibly 1 more release to remove the migration
> infrastructure.)
> 
> Thoughts, questions?

This looks reasonable to me. I added a few minor comments on the patches
but they already look solid.

-- 
Thanks,
Petr

