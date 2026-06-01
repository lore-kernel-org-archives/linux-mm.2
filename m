Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A0CECD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C9716B03F7; Mon,  1 Jun 2026 10:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1636B03F9; Mon,  1 Jun 2026 10:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6B86B03FA; Mon,  1 Jun 2026 10:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 592336B03F7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:59:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BB6F1A01F4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:59:48 +0000 (UTC)
X-FDA: 84831653256.28.2E0D131
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id AE4DC1C000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:59:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cosvmb8g;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780325985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kzh5a0tVq5+/8roSGK1F3W4YTaJGCvorVh1SK1J8QJA=;
	b=Rf3pWORpMT+cdIQF5juPGnkki59JjUPCQlPjmfnWbxEyjLsEfWfpzNFO6XZyZpjeCzBodS
	B2gAjyDK0IfE5csNYNCm9iZZVxu70npj8mk8i94x07RLd6JmasIpaGk0SKC4EygXKcZDdv
	VGLh5qg7wQDCouZex31zz2ebAkX6dqI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780325985;
	b=IZB+o9jJqa5jGtgqR94xNQY783A4gfnUDlhSbuwqqsZDZEDeUGZe0JSJ8nWj/D4G92wIlB
	YcvmQhRvOn9xFdHThgOVyY4r4iHl4g2zeqCuvQKZ2C4sWW9J7zNEXQHuO/wvnAxqZ2uV1B
	hO6/bwGfNcdheJXLrcGufVsUPz+/5j4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cosvmb8g;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780325985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kzh5a0tVq5+/8roSGK1F3W4YTaJGCvorVh1SK1J8QJA=;
	b=cosvmb8gNFWJk4+HEo2W9HkjhhyD2zY3JbmR+gTgPQRL5qfDIKSBdRSRBKC7Is2ypVxJoj
	jJ1oisarcUQUO2xEPXw1WnR5Fg8Lpjf0To7VfZp0jr9tC2mo1TZw24KivF8jxc41DRWWIj
	9TwZDTLm1Wgij+DkJBqI7AeKYb2NbK4=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-aGjXXceuNliztKJt64tnmQ-1; Mon, 01 Jun 2026 10:59:44 -0400
X-MC-Unique: aGjXXceuNliztKJt64tnmQ-1
X-Mimecast-MFC-AGG-ID: aGjXXceuNliztKJt64tnmQ_1780325983
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-66032d92cdeso4375720d50.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 07:59:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780325983; x=1780930783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kzh5a0tVq5+/8roSGK1F3W4YTaJGCvorVh1SK1J8QJA=;
        b=WmWrQdJc3L+84Sl+O9CJmXAbzf0TMLclwwutMDeHeqQi6dkpoGlO5gqnA6Eb2XSWID
         zj+WNiUf6frlTLkiAyYQ5VL4k73k3ztEVbI+3N4Npi73TWez53nJOAUGGYDh4lsfFujw
         s5qINTWRYt20id/7Oo5opiHqQxyg5stq+mxceBTU6yg3Me5b/SnLq2jMK2PtxAxEzey9
         rzr3WL/b4oNVmVLzeK/tDyESwY5HYYzrkAPCZeeI+2xR0+h5utxO4n5NRKCvgfppcaG2
         T91YQ6hEN84xEGVFuW6jk+yBzzAXVU0Ga1MC2W4ZuRPNivT1P6jms5RaceJ4zfw9DJxB
         vWWg==
X-Forwarded-Encrypted: i=1; AFNElJ9ESo71W1XQI2K93Ev/+GhLwd4+ja2Ow4db7asyVmptdZO4lx6Vc3RWbRaIyU48tXLT44Q0IepOhQ==@kvack.org
X-Gm-Message-State: AOJu0Yz1kovdQE/yvCyZ5fk9ZrXzut8vPAdP9QLycqDO6o2oBpN98sPF
	AQEDGmkxZWeZAOWugT6ADYZ/mwHFF0280ftUH2AXMyY/ZOqTabuKhJX7rOpy2g5kQetjUCEUTz7
	2bFKNqdf7MFIJCYV+aTFwtwXajRcRg5mzw7tWpbcVK0gLFX0ldxjrZsirLHhGr4937XXIYOe1ax
	4PQa9Zq5cOwNbgLGb4AViRRUY3AlA=
X-Gm-Gg: Acq92OFZpLAdD5FRJTjGJFm7B6iD+klCXAkCPNs9sUR7hv7YbYPhi0l0Wq0nggkJ3e0
	BBXwypKkAfp2akcOPgCRzQxN0XEFRQCU+lkq9OEu1JeG42VHiotOKP7woUg2SJ9I/XxeIKXk/qL
	8XtYp59M/lnV+QNV3dQi/dX/1G0J8k0BEe9rEu1Ah2REHrk59+0ELBiFdaHBT+g5EkL/gxVR8Te
	4UIL5unrEyhrht0Og==
X-Received: by 2002:a05:690e:1593:10b0:65e:43a2:82a5 with SMTP id 956f58d0204a3-6605f9416camr7354327d50.55.1780325983505;
        Mon, 01 Jun 2026 07:59:43 -0700 (PDT)
X-Received: by 2002:a05:690e:1593:10b0:65e:43a2:82a5 with SMTP id
 956f58d0204a3-6605f9416camr7354269d50.55.1780325983033; Mon, 01 Jun 2026
 07:59:43 -0700 (PDT)
MIME-Version: 1.0
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev> <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev> <6b11bf0a-769c-4ef2-ac6f-2af38200a6bc@kernel.org>
 <baa0a462-46e0-44ab-b583-c722ad253afe@linux.dev> <06d9b665-945f-4967-9ed9-b06514478996@kernel.org>
In-Reply-To: <06d9b665-945f-4967-9ed9-b06514478996@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Mon, 1 Jun 2026 09:00:22 -0600
X-Gm-Features: AVHnY4L3QcDds9Bx9nzJC4wMJL4H0KRuHxJDPSKQUpwkRBzl7EaLMR0JWfpdnXo
Message-ID: <CAA1CXcAeEGOsqp-ywAQ7GMYQzXEeco-rUxUkk2hEF69HybC4=w@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com, usama.arif@linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w6snTZALNIhtZZc2T2e4zGdZj6GniABe5oEtPgmxxvc_1780325983
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE4DC1C000D
X-Stat-Signature: p48tcsfgcqg8gomyb8btgjznmqw1wdsr
X-HE-Tag: 1780325985-750950
X-HE-Meta: U2FsdGVkX191mueVAHI+I2VPzhfpilFfUXC73J9nyzjGolR65JzU1yP0QfjyRDU97n03/93bZzwFyNp85nUN+r40OPdjnWRzidK1o7muAG6DfpXxo77S4bI3FY9sy/3xC4mCBYmb/u0NBJGQf1RDivql7+d8VKZMWA+gM47HmR+CFeukv1skt63p/SfKPsCTklakpczCwS2VTnkqdOHUx10DiMrChegNB00G9nQAWkuvEvvyCPnSJtp36CsZqAI4qcv6VyeyktPto86u0dwEZNgwaIjd2AgQMfFZAjry+zFqR1EQ9pddZlAqFsPrlZOwtaSY4CqNsdslp2LcryyAFN0p9YA7HWlaY9UsTv+wnmiGyIkWiFNylcVcIFJlpFmqoGb2DEiD8h4XFx6WOL7eJfghTKxxpLDUfkDSV2xOOSORNatRFbYFMjPxgcUZetzrtsE0B1oUEIk1+QVngnDyfSh8YYz5zhMLh9DqHqiahgy+e6Z/jJF4UaxXsG4ZSFyt/yJqyg5qIxDhFPVQ6pS3CyNvr/BwCbIF/RlFTcwuS51Gc2fVyRrLjvIYGTy+tDEJ1mf/ax98ZPCiKuQkHzdVtw2IcqVkKhOCBF0Lf1Y6IhSsXn0ialWqjPpdBTm730y0gIGwjtwDWFAldZ6JL1eqlGe7MYlyatNmCdXHUgTfFxPztbk5RlwpSvk72APSldm7FUpoeZ4RRr3GdgfeMu53WJgqisFaL7fW4/5mH25OGGz0EdBSaDV1IdPQu9YOvfoN2kBIukxdaxKqIcyTXYhVtm+oCTO+udNA/DY/9GXx5mm+96kHXG4lYPwYYP1eifpEIp3dT5tBGRGlbbCBYFNDB7Uj9qjhfFbQoS3aJPENjWhYj9bNdYVjTaaDIUzLTVdlanSXGxgOxANMz8U6yCcaoVhKSt9ZVs47oETO6/awwGMub6IAooExCy2ropcySmazPAKRNbvqE7ZmMckCKWF
 PoVJHQ02
 /Lyn1/nzLPwnpU4jTbSUInSHgPHX+b/N+uk26Bd3e1mk6/vWTfdBAcz74Huw1cW870qNegys2QxQsIpva7FqqJNoSNhVyimxBfOyHk6/eXmpiAAdYEHH4icpQd38Os2wd4njSgiBDY7c0RFGxa/nXD74aVy8jlL2wOe5DG4aHHrcaCPyKZFG30v8rL/84hvbL7R4y2eQHNEmsWuV2X31P/I3NhC++vQesPJTrKRYlN3HdtnmGb0TTpA3H3q/BJN6/0upbwxX0ohCea2QaFLn1U3ytVYLW0CqFgd0mvfOA3fO8kyfXeUOV655wLkcmzQ1nnxPjpSUuD72X+Dl0ark3bQb8h7ji9EelnlGwcG8F76WLtgNN0lV+IuLlscvknaPJh3HgiMeyiBCHUOijgFwptjWHKFBcWMYWdXA0nQaxsgROCgzN9Ncgw5t+BuxFGXdrlqRM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 5:14=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 6/1/26 12:47, Lance Yang wrote:
> >
> >
> > On 2026/6/1 18:23, David Hildenbrand (Arm) wrote:
> >> On 6/1/26 11:08, Lance Yang wrote:
> >>>
> >>>
> >>>
> >>> One small thing, I think we should probably keep the smp_wmb(), and j=
ust
> >>> move it before the earlier pmd_populate().
> >>>
> >>> IIUC, the ordering we want is still:
> >>>
> >>>    clear old PTEs
> >>>    smp_wmb()
> >>>    pmd_populate()
> >>>
> >>> so another CPU cannot walk through the re-installed PMD and still obs=
erve
> >>> the old PTEs, right?
> >>
> >> There is a smp_wmb() in __folio_mark_uptodate(), that should be suffic=
ient?
> >
> > Ah, cool! __folio_mark_uptodate() already does the job :P
> >
> > So yeah, no extra smp_wmb() needed here!
>
> Yeah. BTW, I think we'd need a spin_lock_nested(), so @Nico, treat my cod=
e as a
> draft.

Okay, I read the above and did some investigating.

I will try to implement and verify the changes you suggested :)

Or an even crazier idea... what if we ensure MIPS checks for PMD_none
before walking a PTE table?

-- Nico

>
> --
> Cheers,
>
> David
>


