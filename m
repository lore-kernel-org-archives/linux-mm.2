Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3544BD4114C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700906B00BC; Thu, 15 Jan 2026 04:33:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0B56B00BD; Thu, 15 Jan 2026 04:33:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EA036B00BE; Thu, 15 Jan 2026 04:33:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8AC6B00BC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:33:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB73E139F7C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:33:10 +0000 (UTC)
X-FDA: 84333684540.30.CB465AD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id A8804A000F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:33:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HSBgWvLW;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768469588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3+emnN/FUkaljXR8TzqIDHk76UR0X2pbJSmye/ZyuY=;
	b=xqchL/bx0XFEk4Q4mo7hSPhATSxtE14M+JOLD1QSE78sSyJmeEXOJwq2dHdqEbRH6MX804
	YIFCHAYhW3T9ejICcDtBD6Dsfj+bDhUeW2ivtQWJnDhTF/dkd83p8YWGoSyHn1jYEl92En
	LpIPj5TArTCo8yzGWEoCtjbz6lm2B4g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HSBgWvLW;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768469588; a=rsa-sha256;
	cv=none;
	b=LfoQUFf/uTckz7fKPil3mgp1KI3aYo5t1TP1xj23T8EvOphM7O+PqMasLtgr1c9yoj3UeP
	eK8xwfSygzySmSpkyUeMu+fpIOSQBbdJJR9Aq6dydMToBgK3I3si/HVE9DsYBMOzJ6VSAJ
	dXTVsEy+WPNzXUpqtK+VEI9tvxKmifE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768469588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E3+emnN/FUkaljXR8TzqIDHk76UR0X2pbJSmye/ZyuY=;
	b=HSBgWvLWtGkJruNNadiirnaAIm/Z2d5KTpVcWAvnlmQGywfgQgxL481VDcOnc5e+UTEWxr
	08yRI0jlWH3NMxm8WZiHS7b5iN0zwUpPxq0FwyEFBwkbNShSKBnc3HH0nUDemHr44iuKv/
	vmMYZs1lP8YptQwz50+dgjmVQC90A9Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-6H718TuFPmSVhoLuz08HUw-1; Thu, 15 Jan 2026 04:33:04 -0500
X-MC-Unique: 6H718TuFPmSVhoLuz08HUw-1
X-Mimecast-MFC-AGG-ID: 6H718TuFPmSVhoLuz08HUw_1768469583
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47ee8808ffbso4334295e9.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:33:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768469583; x=1769074383;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E3+emnN/FUkaljXR8TzqIDHk76UR0X2pbJSmye/ZyuY=;
        b=CrdX41B4yUT0RCD1YuOtwMbBCjSyiouWLqoEGezJIzqLESEapQhhndcvuHwY15g2NC
         yfh9EOUO/4vF+/fvoSAsQRSS/pWWZGjDzOEmV3OZdrKACEjMmg7UbvgHmkpY5iPSKUoy
         kgQqs4Qo9yRTDtjvqyLyqHDfN9S+L1R4hGJcnmrI3JAaZouDZAeL8KyV0/nVpwtqzslU
         N2N3jYyuAhjtzp+ehpSnCSFDGs1FjbuxyhOqAUCaQntWwRCo34JtzgxvavzadMlmHGGV
         npw+Dg7KqZmTV12+zOpuDaM9kOtum5YNA3vEke6mhUpMImaJnW5UFIYMefVedOuzs1Ai
         d1Sw==
X-Forwarded-Encrypted: i=1; AJvYcCUYG5yBOAjfA0sJb7Wsms3svAMgg8dvRrMobPS56UkvHyjcq9Dud3dKyGhRydkKkjjCfBA6aamYXg==@kvack.org
X-Gm-Message-State: AOJu0YxEB/EojLQqL5vrI4xCBGBtZqUoHDCxjKC5/39xBA4EO4QRPRyl
	X3cd8QLoB8TzSGev9HqCN8ib3ujsEtyVxlvpsrnW+j8GuFmLUY0LwatzyHGeOa55KsQOzNBW3bB
	YH55Xn68fme5Q9gTkZo4L/WoHyoUozlmGoayTjZU/mgWgJoOCbpaT
X-Gm-Gg: AY/fxX6g7xmUxWx7TQ+O475T6q1mImG01bmFYgDNwnywGxCaEW6ZzJP+7qApnQH14o6
	8FiETUJ6pYgbNAGcAhlN7ctOaS00LD0H2x+ZXWPz6JJ6U+oix50DcvTIATGROBIGsorv+7uZTQc
	1K7o+kOyjozklYzi5UJT4uiaxxqx5+IizHja4HZAJeXXMtjU6mKrV7wkEzYI9WYEU8UtGcXquEZ
	EXicZPyUy6fVwWmG4Qtw314fWuzNdlBQbeGzGAlihixKlqWf3XLc+ont97uN9+D+Hrs5CeIRldN
	F3f824w130c2zutBDpRlucJhY3NqSGFKpJWcJ8c+d5b/cpHX3mtSZ1R1jjfEQAI2KgeLB7rp1JQ
	HqM4x7H+RaOwlOzMsy6/p7BIHE4YQdw==
X-Received: by 2002:a05:600c:6610:b0:477:b642:9dc9 with SMTP id 5b1f17b1804b1-47ee48271b8mr47954345e9.28.1768469583343;
        Thu, 15 Jan 2026 01:33:03 -0800 (PST)
X-Received: by 2002:a05:600c:6610:b0:477:b642:9dc9 with SMTP id 5b1f17b1804b1-47ee48271b8mr47953965e9.28.1768469582848;
        Thu, 15 Jan 2026 01:33:02 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ee97b2bebsm19745355e9.18.2026.01.15.01.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 01:33:02 -0800 (PST)
Date: Thu, 15 Jan 2026 04:32:58 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 00/23] mm: balloon infrastructure cleanups
Message-ID: <20260115043240-mutt-send-email-mst@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s42VSY0gRj_sd7IseY0hK1wj4Zqnvjek5NC26S3SmnY_1768469583
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A8804A000F
X-Stat-Signature: rk9p3wa4cmzibijufqun64y8exz5qscw
X-HE-Tag: 1768469588-302394
X-HE-Meta: U2FsdGVkX1/I5/76UZLk/jzXqR00IObjTcq/BNXZCJ0Bm5/JSfdCPwjOruo7J9LYOr05YCrhpEMuTBlJiM291xP8NV+bmb2DGNgG/9oItOvs//Ts42BCCYUwuNOeT0OtmwCpbvaa+Vyx6APbuiBH0hd2YuorpX5grt9DBuddI4P496GSd+Gav2CqXiETIBQfsQ685rX3wZpw7UONnnN8OAAxA5rByYPp+CBvbE5A4r5tNDb1ftT7vRxHJr+t46xEuZwgYtL3FcmQlpGRlO6pyCbmKJmKfRsISHZXCStAu/Zrc9ti2RvAvsZmPycqQ5g7XAsqhMK2uMQ1SuccR1LALDZHU7bMfSVQtvDKbwwng5JDxi3T/swpuDzEwee6Am2jlWZEeaNgow2yczDDWRPyf8pfJ+0IibWFo/I8Cgj1n+y/sgF+Xvpq3YsyKYuG363W+1yvXVlO1V0jtClT17VYp+/cvAh626rYZNsnuxiFoX3r9fxh19hhWjN5zFRJtGlZEfdpxeUOIRLnsMge6onBQJuH88hiqa40R/vaZg+NB0EdSEYXtiTHKYMJiRQMdG85gELF4vt3kRnBJmM70RmZukDPiBpHBiNWq4ZCt7g+aeRk3XQIn2wVuzu4yiHV5N6cOBtufO0EBSWUZlKLRzHxEG86Xsu1YLGDkdgxG1TGp+38g7uT6XGWs8EceGSLqeKuaVLykJpkfs+j2wiRngNPhRg2ZSAKRnJBKLONMaQz3uR4MwH3Wk9feoxDIOd3gB6Cz3MipYzRN6Xw4T4GoJqPZ4s39YWLSPV6mrIWmhw/miRWVk7w1zwcvvZYiQ8fCtZ/ITF0q4NVfWHEC4AZrkeBBJ3tTamhs2QzCD+Tvuhb2UFDKdAma9QBQcFD6HYtT/8TC6m+HH20witSs0y7cLccFIFYy1a+beom7elFyLQLBzF+Nw3Cz9iRue8bLYOQ0oavhYiEidJJ7w5mkFVqD/Y
 MzbE2hJE
 ui7iaTZtGJ1qp+cPv3JlT7WIvKHeRcnTOPR+5+RQSDxKyqhKP15VV9m+JF2CNarQZjvzbMvJ5LSWW9bYC7ANesGKrsx2xR5QQFCmAUztuVMbAdM+1PYiKqTACXp9e7XcvCucjGH3reHAeJgyNe3ifI0eB9oCvjgrZbFHgxDLvjwruhLIuJpV9NxcaFWShVDgRxSfwyXTE+rcWXJwsvNvmeTU8bT4ep3up1JK/3Xw3rWPYEoVmn7WoBx7bf/5qNSL7ilXpcKjVoR11u1L6f7VntbsqkLMLl/SZzTPzH7g4SBZyIJP7TERfVlIyWYL7Dzn2U7VxTE9cE1tg3gbuwonu27kCBXpfsrfJmsa2ds7Itjhsk7BCTmtERip2sk7GcA8QipIGRCiPW6KVbuQPkLPcCtwIMglREIL8X3k1CBHaH5YwzEU3orIUcoZN6Tz8Qlia61H2/dqdjmgLRZDbO93Shqity6rghYhLvfdr+OkTOrqUKNZLlvrolsrnXQwC7QMH7uFGlhp0w8qNzzkS/wxIx1BkS6j6NBiLOPDk/XwMOnktQ0Z21BNz+BQcrjPev0PA5vLEi+6hgvsm0I2olzqDww8m2Rg6aipD2xEuKVaF5ZWdZYyT3y5nIxLLaaDTG9W+HUcNCzj1dUnA2b5ktIESeiSk/9fSxFePpurX5fyhvpAJqju7H4fDozI1m4MtQyOKMdJXgSxvC1WOjQr9XqMdyYZV/d8YKmzeTXuv9HTlBEo+AxxsvTHUTFlfld40dqZeqPrryiAA4ip799oapHJUq0P9n0qRIY079LHhcC6VWJaiqkUpoBy+Mm+4GTyKhXZQRg4qE2QWR0Jq64oUDPmNNqQoFs1TKxp+pb9MEeVP4+1rwu4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 10:19:50AM +0100, David Hildenbrand (Red Hat) wrote:
> I started with wanting to remove the dependency of the balloon
> infrastructure on the page lock, but ended up performing various other
> cleanups, some of which I had on my todo list for years.
> 
> This series heavily cleans up and simplifies our balloon infrastructure,
> including our balloon page migration functionality.
> 
> With this series, we no longer make use of the page lock for PageOffline
> pages as part of the balloon infrastructure (preparing for memdescs
> where PageOffline pages won't have any such lock), and simplifies
> migration handling such that refcounting can more easily be adjusted
> later (long-term focus is for PageOffline pages to not have a refcount
> either).
> 
> Plenty of related cleanups.
> 
> Heavily compile-tested and heavily runtime-tested with virtio-balloon.
> PPC CMM and the VMware balloon are untested and I'd appreciate a helping
> hand from people that have suitable environments.
> 
> Not CCing maintainers for the vmscan.c and migrate.c change as they
> are rather trivial and I don't want to patchbomb them.

besides MAINTAINERS thing:

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> --
> 
> This is based on mm/mm-unstable.
> 
> v1 -> v2:
> * Rebased to latest mm/mm-unstable without any conflicts
> * Minor patch description/subject and comment fixups
> * Retested
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: "Eugenio Pérez" <eperezma@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> 
> David Hildenbrand (Red Hat) (23):
>   vmw_balloon: adjust BALLOON_DEFLATE when deflating while migrating
>   vmw_balloon: remove vmballoon_compaction_init()
>   powerpc/pseries/cmm: remove cmm_balloon_compaction_init()
>   mm/balloon_compaction: centralize basic page migration handling
>   mm/balloon_compaction: centralize adjust_managed_page_count() handling
>   vmw_balloon: stop using the balloon_dev_info lock
>   mm/balloon_compaction: use a device-independent balloon (list) lock
>   mm/balloon_compaction: remove dependency on page lock
>   mm/balloon_compaction: make balloon_mops static
>   mm/balloon_compaction: drop fs.h include from balloon_compaction.h
>   drivers/virtio/virtio_balloon: stop using balloon_page_push/pop()
>   mm/balloon_compaction: remove balloon_page_push/pop()
>   mm/balloon_compaction: fold balloon_mapping_gfp_mask() into
>     balloon_page_alloc()
>   mm/balloon_compaction: move internal helpers to balloon_compaction.c
>   mm/balloon_compaction: assert that the balloon_pages_lock is held
>   mm/balloon_compaction: mark remaining functions for having proper
>     kerneldoc
>   mm/balloon_compaction: remove "extern" from functions
>   mm/vmscan: drop inclusion of balloon_compaction.h
>   mm: rename balloon_compaction.(c|h) to balloon.(c|h)
>   mm/kconfig: make BALLOON_COMPACTION depend on MIGRATION
>   mm: rename CONFIG_BALLOON_COMPACTION to CONFIG_BALLOON_MIGRATION
>   mm: rename CONFIG_MEMORY_BALLOON -> CONFIG_BALLOON
>   MAINTAINERS: move memory balloon infrastructure to "MEMORY MANAGEMENT
>     - BALLOON"
> 
>  .../admin-guide/mm/memory-hotplug.rst         |   8 +-
>  Documentation/core-api/mm-api.rst             |   2 +-
>  MAINTAINERS                                   |  12 +-
>  arch/powerpc/platforms/pseries/Kconfig        |   2 +-
>  arch/powerpc/platforms/pseries/cmm.c          |  53 +----
>  drivers/misc/Kconfig                          |   2 +-
>  drivers/misc/vmw_balloon.c                    | 105 +++-------
>  drivers/virtio/Kconfig                        |   2 +-
>  drivers/virtio/virtio_balloon.c               |  64 ++----
>  include/linux/balloon.h                       |  77 +++++++
>  include/linux/balloon_compaction.h            | 160 ---------------
>  include/linux/vm_event_item.h                 |   8 +-
>  mm/Kconfig                                    |  23 +--
>  mm/Makefile                                   |   2 +-
>  mm/{balloon_compaction.c => balloon.c}        | 194 +++++++++++++-----
>  mm/memory_hotplug.c                           |   4 +-
>  mm/migrate.c                                  |   2 +-
>  mm/vmscan.c                                   |   1 -
>  mm/vmstat.c                                   |   8 +-
>  19 files changed, 314 insertions(+), 415 deletions(-)
>  create mode 100644 include/linux/balloon.h
>  delete mode 100644 include/linux/balloon_compaction.h
>  rename mm/{balloon_compaction.c => balloon.c} (59%)
> 
> 
> base-commit: f8ed52ac0cfbddff992bb9600941bfe51e1e385a
> -- 
> 2.52.0


