Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A749C88E58
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992BC6B00A6; Fri, 11 Sep 2026 11:06:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943726B00A7; Fri, 11 Sep 2026 11:06:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D396B00A9; Fri, 11 Sep 2026 11:06:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5406B00A6
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:06:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87C2F14025F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:06:16 +0000 (UTC)
X-FDA: 85201807152.04.2B4924E
Received: from mail-oo2-f43.google.com (mail-oo2-f43.google.com [74.125.231.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 94AC81C000E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:06:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JoIvWrEn;
	spf=pass (imf20.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 74.125.231.171 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789139174;
	b=MRG/7X8tdt8ldAUM3KKS8nQUJgT2M4CPYPkJJFAwyywJ21my/9gUw1duL9wmJhYD2fm6M9
	5YD9upFsol2GCTtfqTt0NfTXMa7mtZ+dAdz0Kn/6vDvrdC6Kugt0QPMBltq4zrjfKCbnmw
	hDWNkjWjIMlW0KzjMcN4jUJlD6/dG14=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JoIvWrEn;
	spf=pass (imf20.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 74.125.231.171 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789139174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31WGPI9CsS8AEb1QmZigfY8oBbhGb6+EPuGPGJKusUg=;
	b=Yw+lIXAPGrNLvMDjqfhUwTmWoSdVqeaDcpyTGZptsdGW+S3n2zd+y+emg76wTFgC96vuNC
	4cldUnL321gFZ0tIzgBRI94nr/yAVB2g0L1HOo4Mvxp5td8A87M3Hr8RcbbynG+tOfjHZ5
	Wx0wV7Z/4zoO6ttGA1VeSGzgcIHo2as=
Received: by mail-oo2-f43.google.com with SMTP id 46e09a7af769-7fccd4c3f36so880891a34.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:06:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789139173; cv=none;
        d=google.com; s=arc-20260327;
        b=kXrOfrS/qpuG3+IwLVcfpM5tNHwNaxhE4WzlgQ8BYjrTrM2f8JA/zvX2p3tNB9Vnj9
         rhpWzsXUuXhTL/OOm12jrXlynZkdq6d/wt85cWriPK8sYylGJ9CRr0cGTWCQtXUeW0R0
         5SUzIyRAXTpdDG6uADjsnFdPvufHR18CxCK0tYYWHozbVhUW2OHoK33Ynf3A3Cmoq+2C
         TK9KM5LBPHjcR378J5XfDua6q1uaUWfmmNlBmfAs8wFlWpWTCjMSelyVPDT1O4j+88mO
         hCw0jsQT6fT/A4XagWvoflLqMIfxjwI48+vpiQWVkbwcUVOvDupefWpx1Hx0Qd2kTdRO
         cFjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=31WGPI9CsS8AEb1QmZigfY8oBbhGb6+EPuGPGJKusUg=;
        fh=Tp0/U/dwT3TrQz/xPw8FvnuZ4mE39bEd7vsJxB1txvs=;
        b=a6GtL3EIHyz2zpl+gJnFdpVMptKE/SCzGeGS2KpsnP3bSkwADhHFLnY9955XsD55nL
         ghXVFYTdrlq2RXTi4VYdG+OcglCrLfapy+6jQm1KERSLt6Em/0WC0AUbvG4F/EAWFMlj
         KwLbqVwikrPZkOme8zoTsKO48VY2lOUgmFHTmE2+qck2x1fPZ0thsQzPPWM97ZS18tPH
         cXN8IpmyDHMeumcC/fa7JDuOOit/Vi45b3hF20vSZgv5vCPSXWehqg1W+EB/rgtNKnZh
         ggTQbyBQUL8oBod0oj1e0Ch035oMcPkvOOvNURQEMDsyXwac/1WdOBkTMmu02Im8/Qwf
         pTFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789139173; x=1789743973; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=31WGPI9CsS8AEb1QmZigfY8oBbhGb6+EPuGPGJKusUg=;
        b=JoIvWrEnc/5OClGLlDUI31q+T7zpOSUMsUiFSgQ9WChjGqsF8/FPL9ZMdBKrZG4U34
         J8dedhsUlEXVKdNtKHodtNCzu0SX0AsUpC7br5i4T4q2x+opIjrtGHZ2v9SKaNkZ6Gq6
         Km4PRnhKRp2cNfV0aSsYGJBHCZSHKJAzMtRNp2kS6plHrBvTbyFTVlcbw8dgdHWvjtuM
         bFX27uJMnWVwWqM2DvZye7HiUQ65xAwsZM8PuBSnqwXU5fJ5y1S47XO6WghRt8t00CWD
         +tq1gq9Aj96ve/4T0LHM5iA5y7A8cMmrIMPDees2OyozMC9Yoz3bvruV/pjmbPOzh9CD
         VUYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789139173; x=1789743973;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=31WGPI9CsS8AEb1QmZigfY8oBbhGb6+EPuGPGJKusUg=;
        b=FI2rvGhfCuLBCvwphynCAjmW7mkUefHKEVPinBYgrMi1pS9EvFYIU1X2P4JZbXtCAu
         aq8/4ZIs24heSP1sHpMRoCO06RHaHZ7oRFkM+N5IFih7MchV6BJz/Ldp4LSGMcBZ+vxR
         IMznn7viUnbczYGCx3zmxCcLMxy5mzknFVS+jgcUrML7FY1aQ3j/mu8Kv6Pk/rKXFDyQ
         Zg9dqqprkEqJs4IohAVKeFkW1z4p4TQo6CIlXO2UNwulmtuItsC27rQdyzgXEQBzCCdu
         eFPHZxcQZC16wHunX7+DzqALW9iQZr4+xgHH+dvfSthPoUtb41cZmZz3p9AOYCj+6//u
         7gJA==
X-Forwarded-Encrypted: i=1; AKwUvByP8etHDOXEnbq4eW/FPDVaMlAXT0QY3qWNLuw9Sv6F4ZEfM1YilpjifqY9a1YnsNN9lTeAtbCX/w==@kvack.org
X-Gm-Message-State: AFuF++mwDCUHLVM7aGC3jOwdB0xxf1Gv5qzW/xnIJw0gFUq/ZpjkOBdq
	Qa+6MUrYxDJwQsozFi9y3db6Oc31uKUHVIEWAIQofUBZdqdhqcrZNBV252Bl6doBl8Cs+xlVOsx
	CgfqZMQY95uEjFsB23qvTyjbUym+Nn0E=
X-Gm-Gg: AYBFou0/u1zSw5a6ocwdh6MShVISX/fU3/aNycQeBWwxi85bG+QIDVlNDCfjHFP6LDR
	EZuCpr9MwYgCQTMwUchgJKuzs9h/hB+457McbZlnPB1QDpw2yE+2/9OIHUdIw+KdS5muFRpFVpy
	FMuOVfSNjpsnb+U6hs9w+fsXwBl7pWYtyZwxqBPk3Qg2y4a7VuPHAg5KX3qiRe32wtTkSlWThe8
	8MhC7uKiu60vbnCF3zEVuyJqEe7rPN8tdusiGv8V8/mfwBk89vpZlcwBBihYmfJx9ooBxTA3z4G
	HlwFynM1qQLz6lguvY8AcrcU0X/ZcNxc6uSXP1I1OayIkma4ztPHk8g=
X-Received: by 2002:a05:6820:8585:20b0:6b1:be9f:ce6c with SMTP id
 006d021491bc7-6c0b9d4e35dmr4967721eaf.4.1789139168581; Fri, 11 Sep 2026
 08:06:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-11-dacf19cce22b@kernel.org>
 <CAEjxPJ7hXSi=oLtQPV+7GEvN+txfYwZ-u-v_EysNHM0gSGNrCw@mail.gmail.com> <aqPUqU3eZeFrykj3@gremlin>
In-Reply-To: <aqPUqU3eZeFrykj3@gremlin>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Fri, 11 Sep 2026 11:05:57 -0400
X-Gm-Features: AcwNN1UL9TCHStClpz4OqpdpVCOHFGRlTtL1ELl-GfcxGBMtPjfBSuHNlaSY27Y
Message-ID: <CAEjxPJ6P19eKF-c+mm2BSr5_WpmhMTZjjUfSamv3SfOPO4SGVw@mail.gmail.com>
Subject: Re: [PATCH 11/39] selinux: reject writable opens of policy file, drop
 mmap shared/write check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>, Simona Vetter <simona@ffwll.ch>, 
	Helge Deller <deller@gmx.de>, Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, 
	linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	fuse-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 94AC81C000E
X-Stat-Signature: 73rjtryim9ugnwfyg99podxw6e9a5fj8
X-HE-Tag: 1789139174-766118
X-HE-Meta: U2FsdGVkX1/DN5FVqHg2ukSHJwciNNoOLKuuQbBQ4SkXzpwzUsw3XJm65kT5XAlNEvno5s9u5nZ35YqVta9EXAZhfhML0GFQyBQF3h0Rji73u96S3j1yzYB6Sqg/YgyRgAEMmbqfI7bi2CLAjZm55CzstvN8ZGkl+8GZQewo/gxsgATaNbB1Yi631yZpXgq1SgW+kZvCXzNObU4FjmRlMrvak3qYdJnzaBDBZOYJOZy0sr2P3aGOTD7YxAOiTxYs3e/75Wq38cAd60aHPD5Wr38lAOqW5MufPSXB19IrHB2H/vpBIN3GqQiU+334dBUWsZudeY1BOs58DUE4v6+1S0JO5XVk85XAnr+8buE4UmltbUPeiCuqDFmyjnN2Be+9VaASX42kU1gf3Cw7nOnby4/bFhsYnikK6Ab+fwWQDuDkBD7mqCYVpAnq/lbg18PL3mVtEqo3lK8e2Koc5cGBfjlUwGXYWLW1zKOI+vmlG+LNWdPeRcmkKTB2qTmGVmwNHI8P+OweXG96i9u2Fz3VR5QVE+uMrTxcolzYfWGze1JtJcUdPVjz0zL589LKvjcHKtwdu/cfhLH5fbPv0JNiT0qNlibvV9T9diq5oSbA/vDvKrB2cOpK4yipHRgUHU70neCxZ4PGEoKlVK8UJpQEny7CY9P+5RwuZsqqKRUIVrCbqVQsJ1ulZm0U2Edle5dWkUZJb44PshJeCGhfJRAvJoe0FPOsKg2O2MX+3GfhUlD7SsLNVItVhSTCW5We+4aLAN6HdnX/eHhvjBX5g3SqOp4ityNPMdfefOTcZS3dtyjlww+AGf6gMVCebHdUh6AuHXtkoVFasaMnKcvIiTzxe9T7ZOPqRGYBaFUY6bk1qFVk5xbmOZwK/GqfOsZ7TZJr1IKK53hdD3VU2/yhSENsYIarn+EQ28lVGLo+EV+KrJuTBsB+gcvqSb06mYrzNQ6LOkQQZVVP/JVhI+GS2Tm
 p+bMM/mc
 xcUGDFepmGWnBukBr/Gs4ru8GVcbbkQJg9H7UlMgiqaOfhVAQEOqNpDUbAGtXCHc95yCx6Msg5ZqjrR/yQYA1q2hiG+1JNFzRwTkVm/pUHFbOF+K8xTgKERYIkGldVxKrxRAjOo/GjOCZQUb3Uq/3ebpX6r9aHWueZMgS+Kcsl8GkI6OeHe9VP8lHqQGr3+mSZoQY7ZmPblLjDJ4362jO0apN4pHRr3toV80fmQiY84K0Ze5uW/gCCtHa1EmHpUJZGnk3L/jRlCriKbG/NqmXMV5O8R04hgax2zqBGEPfmT4UT7HrWxcID+LQ3erGgtnGYDLtzFvuVxgGYo0C61aEh2J6gkFvVZkHvnD5oV6zH4fL9o+3iaP82FZ5dLHcDl6IF7SYgGkMgrd0jsIOl4VHQm1t598oODW+uIREk/+LmB8mvAbDOIPk4CYDlPvEUBekpc5/KR9p5jCVqHueskv7cl8wi5ARrloDDtnGkoN1n/NZ90dPYcqJxDD8TG60eqfzU1sDTcXV4L8RsDjKENgQEr+G33mxMyhPT7vfnyHe7/Pqz861TuegnfKP9izZn7byWIb/DmiKn6aGi5WmT2UzwvJhnGmKLbpeVF2Bmbbyne2EjMiOcMUetsBDRuq9h6TlZzUtaYp/VgPv22O774k++enHsbwfb/Z7RVmeFs7B/GkDc1yNIvF9hiBGjRcv7bxtTvav9of4WOnF70xe9E7UIADfNOSHm4B5g667ZsyLel2le23UtvUOxzFaKwikNMskBt4OZSI48b4a8yPhZ+29iqos6DJPPu3rCJ/bgRJ9QWQ5vuPxLgd06LvLrIbNN46703KssnJqL5SQ/3b1b9WEOCoC8YvdNg6nfNpLzceJ389NIY4ZRrVjL64Ar34Qmgw1pJJPXrTD53h9DBgRGo3UZH0H+9156uHamrGvwSXt5d4757N7Q7wYcZfnEN/6E4PUXSHy59MgWYYqJ+ox1ETSI7EC1f2F
 6/vnzDyR
 2JkBZeXhN7nheMLrL6Sf7hMHfoTNuQCxRkRB5H0pTHnJS/P++Fvkkbszrf//yWh4226EODP+8/tFamcTi9IpKQUCXz8Y+pp+MdM51bupXPttEVNVKop9Pe86+pziaxXgXgBZbp/jkc6PH6NuqK77tIRIuZEhBrWwVHWCAx3x4CGYqjvuHRBIi5xCXLHOYio8xPoNLCKy00Xd67Q5IIpbgXyoO9XuyrqgUoHCz4mcSYpraqq3AEb3KnTegdhFxB5kBwV9jD6IKRdKKiMylf4WRoGOmmjj15oU3oHLEytvd0sl5kDhiy2ymn3PehC6CV4M12SB1uQ8ZL9FuDugLFLiY09yuoKsd65HpCkD3YkS7HM+wSJYTF8Ti4TijamNk/YEUv8vTl5YjC/9/At5LxCGK75EmoUvbNrlkZxN4U9SjG6yGMjb2YaORCyDcd0eSNU38sxm82RvmDDsPo1lH0GLGeRwtVtleV5iPzCWOIsGn20kXIM2JG7yCFTwZR4/BRA1qagjk4sQxRd2m5g9iZT+rLXhxK7gbLRsJzm47jnLY7YHVm3dpp0VlN/wy0O20F+CP7aIhbdVWGixauKOuEDjgXlLpkj3pFxaVOsFS7qEvserM+6qdMCZCFb61V6OjSpXCkX4wGCtg50CZXkjDWakyYqq7zQrtiY8Ip6U2eCDYTtSEpT6uTSkPYHeOHaUUqtX5Blj+MkIQ7I3os4TF1PQFM+PuUPIFSVlUM896yN3FFeEaR0jHMWdG5hrmEMyzXkYgtoaEL+F3qkHTLn5FPZfolxY8d9/b9o1Aqj7m3wT4q09OhgmRNjzbw5c5+YxyfY/u/U3B4RGAVKCew35e0mVccvwyBFqTTatQGm5HHR/onsHZ22DhFz67BPhlTWQnvN+hI22k4rPLRiY37KkhElrauvj3kjGJaRXUze4FWrm/QlD8mrC+LVN8bGa3NUq9Kns7Yy7GB+h+/CpX/qRwg2XwpshLAaY3
 2vvoito8
 NV3b1+gShmEWjp8Kt3hjwBoUB87Gfl5A1JRXw/wLtnENrMyH46xzWhyuGf65MGOl0xVQS2ThnoQBmOMxrosM0ZgcG0/FGomH97FsyiViLbfI7Xh61ar4S1RnhpqvB2fx2/yOJe+jwWs9OXN2/XzQgCbJcBUUuHOUVDeEl2AIcagRes41q5DagqH0SbXEkCxa/12Gwgf3PM6g0y/0f2ayfPst/uZeCehfixzq57DOk6OdIrShKpOtDEA/F+UhBmGrX5+HG1cBkEYo7Igmts0CFaz4qOfIfiuouz8emaKhlAnzx/MN5glhFXDwZqIIpYlTWvDILDXXn8VgLlExEFhUfdm2mAUIUXoIsZUsyyfROiYU20GG3dXPXZMWcmWU9zAKVa5uspGEq4bOEzJZMufwldod8gqpMEaB62eB7bpfjzz6aaEvDAbJESuYpbQZORMKnR+LrTHjpWocIIenlV93bJ1F2JwQ5VDGJvuifXGHmS0pqBweq2+xA4Kx4rdnDaYSIWtC/BkahCT3sJToVVXSVuX4YgbfU1cX/EMqaFZQLCN0ADAligLbttzI/mtL9fmm6WeSmPtJ+ua7ksp4KwTSWYY9xmUQSGjUzRVB7q39Rfc1SDh280VtZx2oItkiTtdxAnBN6ADH3a7Pr0E3wvhIw3S34sL41ghDW9f5YSeG7u6U286FolP2CC+0QfvUjiXL+Aqds4a+ih7W6Rei700SnU+647UCKFpSId1zZoDgHnsu7SZMyBHspZcwC2Ehpfuokz/XRrON1+VRuO+WBGyzUcKjzNruc0ZTE7C+PHJvATctJUW5DeFaxXbfcjqfRuk50f3AtJBLoV0z9cm5H3oksyARu9XzQSu+/CuW4Ptk/5hYdT7/oPCsljVPorHgGPNkqLHSdu+6CqF6jtsCgNdg/hRHutN1RFhas3OstyBc01lbR20AYJPQbMRBJGpy57C7deSM4KB4YCFrsChaoxljvYGSdF2kw
 RV8006xK
 /edNdvpp6EY3Q9NP9B+BVJQ1uAw1lOP3EXX1ZXhpR0m5EOZ+06U7wOcB0T+Af0PD/rIkGgrgv7MzvJoSFdPSU7iMPKW8bVFXIHUNUwwp3AAgfDEOMchwzcPNqdVREBzFEuueLV14pfrOOV2W8D100w+M96PnBmfPsqzI1vfQIy6NxEk26s8XRm/bE+LyU7N//AE3c5ChWAnEYJceKGTZTJCmhWbos5jatd8Ax+SRwy8wjvCs9//QfAS8IxTE27pgjQClKllwtUY9S8LOtMKt8tvD/o+Hl8FNnY0rJxVR8KDdFxO7vhIHixsdnn/FlY1pG58Q/HE6iEDMhwObwbllNWoiMfl/fUuzZn1lUGhPzha36Je2D5UGFdUZNZCpYTOciSn7dQsUWUFIkYh9F68IW9F96TLWPwtM7nPRDKvUd8/79uXTyFIcDqB+rK6iW1CzTzUOYWq/gAM5W9tEf6SFhA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 6:16=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Thu, Sep 10, 2026 at 02:11:18PM -0400, Stephen Smalley wrote:
> > On Tue, Sep 8, 2026 at 4:07=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kerne=
l.org> wrote:
> > >
> > > The policy file has no write method and is exposed read-only (S_IRUGO=
 in
> > > selinux_files[]), yet sel_open_policy() performs no open mode check, =
so a
> > > CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at ope=
n, as
> > > kernfs does.
> > >
> > > The file can then never be mapped with FMODE_WRITE, so do_mmap() alwa=
ys
> > > clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_S=
HARED
> > > check in sel_mmap_policy() cannot be reached. Remove it.
> > >
> > > This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping t=
hat is
> > > neither a PFN map nor a mixed map, ahead of the core enforcing that o=
nly
> > > such mappings may do so.
> > >
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > We should likely do something similar for the other sel_open_*() and
> > sel_mmap_*() functions too.
> > In particular, truncation of the status file can bring down systemd
> > since it is mapped by libselinux.
>
> Yeah I think there's definitely more that can be done there.
>
> Though I think obviously that kind of stuff is better as a follow up as t=
his
> patch is focused on eliminating a case where VMA_MAYWRITE_BIT is cleared
> incorrectly.

Agreed, posted one for the status handlers at:
https://lore.kernel.org/selinux/20260911145840.19039-2-stephen.smalley.work=
@gmail.com/

