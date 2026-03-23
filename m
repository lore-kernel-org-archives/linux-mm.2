Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 907B4F483E1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7B0E6B0005; Mon, 23 Mar 2026 14:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C276B0088; Mon, 23 Mar 2026 14:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4396B008C; Mon, 23 Mar 2026 14:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A169A6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:46:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30EE25C7FB
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:46:07 +0000 (UTC)
X-FDA: 84578207574.06.CCAF14D
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 208DC40011
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:46:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aEq4DTjL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774291565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xr0QXHWwKEApSlK6QljqZmiVGPlsHc0lfppFGa1RJnk=;
	b=JD9QoPvSGlsgfYb4Mer6T806hZzpBdLy0lXw2+e4L+grukFOpFkaZo35KMwb0XtyFb3qFv
	/lwg5sCDTtNgY7NGjqmsbeOPz2MopNRLUn6BTXJX3BiEjpHDG/RxUQ7s6qbhZve6rgTdVf
	k0l6nq5mNhaYN3lnsz6vOTIsZuNtrtU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774291565; a=rsa-sha256;
	cv=pass;
	b=6AQhdGB0mMBkWZXzkUnAx8F4eRUAnN/15rVnE6E67Ly2IiGUIvvDRT7hIR/Mcahe8P6Mdk
	8zJZHJg7ZyQ/TK7UwdR/bdPHiUCk+unnllLF8SSn4AUXMDTaQMhd0lUVn/C36gARfMov8P
	lZuTmRl+lm5gIZmMlqt/xiqhK5KtHWI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aEq4DTjL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-5fff77ff719so327275137.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:46:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774291564; cv=none;
        d=google.com; s=arc-20240605;
        b=c6b0r+qvQ3/WD1/GV8v/20JtgDIAPzT7TOOktTHZnUO6MMIkaSzPPNbJ6jIVCEAVuJ
         Nhf5vx/rpJpGyNdhybq74O1m/Mkl5ZIiJBAH24EJMoqa0G0DGFoIPgbgVtgWlHSHsmK8
         AgTdQoiClaHu/OJuBazvjXPXcUyNT7GpRebPxwB0LcEDr6/eEHvrQELTnmQmutP1ZuFK
         03wWTuxTNohuGkHaaBOXbpFSZW3hxHDFWoCQX4cylJs5m5H/PEXznutPTwl/9FExtUg0
         gGS3ha41kcH7HXQOE7TjM0bFUeG4D6iZJ1mbW3jiqDqC+nsd5xyv5tikWyW1l3hPN86l
         J77Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=xr0QXHWwKEApSlK6QljqZmiVGPlsHc0lfppFGa1RJnk=;
        fh=kQAY6v1VdsfBqMXxxFmA70a6rSIiC3KV/WRVH9cOF3E=;
        b=H3uzZQ9E+wyJdcqUkTmGlrAi+FJKgaLoXW1BuxLpJN1J7PDbyjnVsmnq+JWGuXZbz5
         xRxTvjHpxeSeTKpMd0n5l6iNdwXVp4Mtgf6moATiDmWGswU88zuhQ2tEoQXBpohHXFbd
         4f+eFw/J0etjaU1dSgR+r+VZlrLAnncqYlTu/mFH6Az1jtKB/HJhoeA95oJub+Dg+rFg
         yaH3lgcbcTslwNtuVOIk/LWn0rrw+eql84e8B2kP3Xt6A7zR4mdritHEJFg8TUtL/20a
         M3tjTWO7o4FrnaVZamgBVggBUpuDpMEKtcTlV+Bb/ie/fguq9Y6g1OuMN6Z+KTmXyZbn
         PiCg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774291564; x=1774896364; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xr0QXHWwKEApSlK6QljqZmiVGPlsHc0lfppFGa1RJnk=;
        b=aEq4DTjLAZc2dmbyrSfW/sh0+Wg2MiONIPt+G6AJBj4Ggl78ygYdL2jNieIUaVqnXN
         AMSDkWpbRmaAIdw9BQsDbRre3iKqg/hZwB8vTCCB4D9qk2YNvIV0XYpqBE6VPJke9+I5
         YqxwW3D29xTenE140D09kdBOWYYP/tPq0M/LDQjUtmY6lDJJll3YjP8BSk/PBWcAQhlg
         jhRnkgF+s/SLaOrNX1/U9iSW1hsBBIAxTrTh/ZXygNLfsE7uv/F5gw5600Jt/YdQ6oe6
         QBACP9aEmzhglapj9hxnI5bjmUWPYVxLgHdU9Khq+Yn0xke2/f4frnkgxkWKPUT8j/a7
         iRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774291564; x=1774896364;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xr0QXHWwKEApSlK6QljqZmiVGPlsHc0lfppFGa1RJnk=;
        b=V9vrCQ36jycUqAg1scFvOEsj24wvU1RX2pw+X1uYtA+eucV/b3Mgpejm13q0fL90hj
         NgZxurWVpqvTsNY/K+jHFv+qRaROmAMxN76ux2C38fRvZz4pim0jEsAKnuvXi8SjAUbu
         JRLJenz6m7NxkWSO+EvAm3nF1ItTJwU6GbIT/rb21PCg0QIHIu9ltrMTvKcejEUI7pWv
         TjtV5immY2XmBH5+SmumomkcWC76KPJm4tzX1KhG47I6NGhPXOZYv77vU/7gi6BPDeFg
         6heqtptTTXpB5c6RZTb3JQ+YSxk4I1hZ2rMQ+lJ/u4gpxuKg2p0UMoZw0lgH6bNw4qp8
         73dw==
X-Forwarded-Encrypted: i=1; AJvYcCUlxu1KdY7TrDIR/CgCGVxqZUfn01p0kaVZnzPsQ9yj+drQDoY26I7qGv0y3iWzgC1rixoruy13Pg==@kvack.org
X-Gm-Message-State: AOJu0Ywo+6n69jlzaw/FBDfN94hqSDnDET5XZbsDA0h9lQiwIEulOTY4
	0tlqeoPJeuaDHvhb7iNc3YxCrZvgjn/FF3XxtyD3DBgNMK7mzujtz9oOWFLN6ybv7gSx6352Nj3
	gMU+889eq23yJUSQOlajkj96FpFzr1QxWGlc3EQtDcZ8iH46DlPWMkG9JNqE=
X-Gm-Gg: ATEYQzzZ59BWAoMcByUsVz+7H3k8qXwDtZwAKs6/SODA7TqEoKiZxg8Cvem5jYFuEnV
	yLX+pygh1D4Y7GrhLNAX2yDhwGjx21h6k/eDEb6H2BXbzwSxLHPpe85W7o026dEjrXr7oB6xgwQ
	77yqRx4H1ObOr7vuLlhFwJreIWL7s3KCxrSZpiy/k7S9w0J/mpwJopRCIK9e6Mm1iX9vHeZppjb
	ZO/57WCmJoR5C6a/YwZLcar3wMRZjNRJ3QhfEwtyEmrG9tVrbtaLvo9+nkuz0ETViIJigGUqXTB
	x4rTLlVXIdKwnZqybRcfuvuyFB+4BQOAAhp/zAf+mVrHjexz4ummEYoue/KA+INUfegDOA==
X-Received: by 2002:a05:6102:1610:b0:5ef:8ae:85a5 with SMTP id
 ada2fe7eead31-602aeb231f5mr7205779137.16.1774291563158; Mon, 23 Mar 2026
 11:46:03 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 11:46:02 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 11:46:02 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260317141031.514-4-kalyazin@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com> <20260317141031.514-4-kalyazin@amazon.com>
MIME-Version: 1.0
Date: Mon, 23 Mar 2026 11:46:02 -0700
X-Gm-Features: AQROBzCRQmL2CFh0hL8G9T_h4E5mqLNycY6Q5fv3k8u-7tLVQqZDWt6l_fOQ864
Message-ID: <CAEvNRgEBdi49ZkfGo0xmM+J1yzKOzfT2ThAXEN=S0j7vC7Fu3w@mail.gmail.com>
Subject: Re: [PATCH v11 03/16] mm/secretmem: make use of folio_{zap,restore}_direct_map
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com" <tabba@google.com>, 
	"prsampat@amd.com" <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>, 
	"osalvador@suse.de" <osalvador@suse.de>, "pavel@kernel.org" <pavel@kernel.org>, 
	"rafael@kernel.org" <rafael@kernel.org>, "vannapurve@google.com" <vannapurve@google.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 208DC40011
X-Stat-Signature: qd4nxsj79p4ou4cj7mo7mjxc5h5hb718
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774291565-482104
X-HE-Meta: U2FsdGVkX18GiyHhRMHJwkWRUjNuLTCd4mjctuX3e9NRWDl9txBvWdBRj3+z1FcxvbcGkrmwYv08QLw7zGsiljrgMB4yjU4LfTiZi2DsIDF1NGP4kE5JmZVeYDPuV7aPaNpd9OA4hAefRQwfJrB54PtO3OCA/wN10Z5Y8jrQXGON9GIq9AGkVO6mGo/vvIIjzbg3zyZhGzHZv1UUI/Fva4uL1P2dQuY0WJp13QdxjBGaZf+h8VT02YAivNodrTbTrjLaejp85UjsIlptG21MYZjgfuwQIKALHX2h8mbR7O5N4D1YWt9OgnJCBeBo8tJ4CxcdX72pMck5dMqca8qyy+sc8LuvRoxgkzRWMx/SldXIO5QTt5LpC8xpkxkFToNrkhYipm/l02smiRMuygw4xD61E1fy4c4nDAXTqBn21wSDIPryCiSwMbxXlBWkpmEDA9BPG2l5BlaqRbDkR2kua0kxNkGtXd9bAAI0HSHRMTT00u2oDGvKS14DgK1VaB4x4mCQFej8nKaxyVKT1cAp9y5kpwA0VDm5Ud14a0OD2MdoIaYJMwMUXzYBO8vIncIJWB79lsA2ELkNiUQdj21w/AlK3GVDNv9qWgRZx/7bmwJHn68HgabfVvcFcHrfRm74bCz3Xs0eb+Zkm+xcsLfLaKuyQKb7cXt/0a9mEgBV3Ub2Q3632BF/2HY3Uns54UUfWYwJ/0waADk7LwqS/iS9vxSRX71cH9uLfJzzSGBZerd4aNQDKR17fmVpxEfyUOBTLTQww3ZMkrNLSQ3C9ReCmCKPn4VceR4aSbo/0nj7Jt8UlVkDm8iBFLetcfcQjjAvpPz3qW6as+tolIBdzAfMMAh0vlnsQDHBCgNc5APW7WJlJjq0JpxsPQTD7n7YG29aeUGY4uDoHtD+wEiShiffDaajC1wBlea4tWCNKKBdFb9NxulN1xOydacOFzcN9ECSHc2kWJcMderfiK/Q3r9
 siHzCSjm
 J9uslptKDF/21UdDmvdiUALdstNprBhDqtu0s4jCExGXLUOTw5m0Tv18ty5OT6FTx5HreRan0ZpaSnXyy6qj+rHaPfnPWaQH/KdSjnggK/sKX6tKV+eZtPJder718UO81rZEhTjoDpxa3LBkjKFqjmVtSIsuC+iB+P3ns/mUa73RSDzG11h76uxAg+2K8EjBjN574e38EDsoVTuZtWpPLXDI0e6yXr1r1a7xC4JuyVah8UQUFRvtcFjCR8aT1dlBIBW0a60/vq4s2PnrjxMEZiHCIgawivkG2fYgmGkUjLKsYlw+NKgQtgrek4Ijg+4xxIgbr939FFb3dgWHiyqxqAk8q7fx5B67sBO2KsZcfcn5NQoGR1SL8uRTMkZ8UI/nvMT2aBhGycsZQCj66tIaVPfnMXiEjr5xzoNOHfxQl/jUeoAkf9PvP/AMSvCr/t8ALiIFuYfx1e164odfOI+EmvtQ8eQYr+0w3fGmsZQ0pystL/zsWkujog9WtjTcslw32azuOXXIIKAeAOZZ2um/yqf7/KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

> From: Nikita Kalyazin <kalyazin@amazon.com>
>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  mm/secretmem.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index fd29b33c6764..27b176af8fc4 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -53,7 +53,6 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	pgoff_t offset = vmf->pgoff;
>  	gfp_t gfp = vmf->gfp_mask;
> -	unsigned long addr;
>  	struct folio *folio;
>  	vm_fault_t ret;
>  	int err;
> @@ -72,7 +71,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  			goto out;
>  		}
>
> -		err = set_direct_map_invalid_noflush(folio_address(folio));
> +		err = folio_zap_direct_map(folio);
>  		if (err) {
>  			folio_put(folio);
>  			ret = vmf_error(err);
> @@ -87,7 +86,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  			 * already happened when we marked the page invalid
>  			 * which guarantees that this call won't fail
>  			 */
> -			set_direct_map_default_noflush(folio_address(folio));
> +			folio_restore_direct_map(folio);
>  			folio_put(folio);
>  			if (err == -EEXIST)
>  				goto retry;
> @@ -95,9 +94,6 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  			ret = vmf_error(err);
>  			goto out;
>  		}
> -
> -		addr = (unsigned long)folio_address(folio);
> -		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
>  	}
>
>  	vmf->page = folio_file_page(folio, vmf->pgoff);
> --
> 2.50.1

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

