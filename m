Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BED61099B35
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD4F6B012B; Fri, 20 Mar 2026 15:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4C76B012C; Fri, 20 Mar 2026 15:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9938A6B012D; Fri, 20 Mar 2026 15:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 881C76B012B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:34:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FB7A13A872
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:34:30 +0000 (UTC)
X-FDA: 84567443100.30.99D281E
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5B4231C0015
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:34:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R90bL5M+;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SPJ27qWkI5c96vhdp37WS6c9O6xFfPoS9NHL0cnjclQ=;
	b=IHiVSz5T50Zb89bW0mMs8lK5XXANFIT0geB2rjquHelnPxEgB/ashlR7a2JELzTMjzQ57b
	fqNUlohYxe8IDoxqVApijTYmQqEFxTJNCf9bhatT/Tma8gQbdSPe88aCv4hw6wJnxOSEws
	C8wHMri8YahIT2pV8Ap3fFvAr7nsqZw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=R90bL5M+;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035268; a=rsa-sha256;
	cv=none;
	b=vjbUU2YkYjVGJPv0A+b0Q1K0txP5+DQfi+iaHZCH1NPNqgDTSqYW1Z6e6guk7QkWZBZXst
	hEx7TX6kEmKyYM8gj5Qy+o1cREGuwGQmsOOewQWzOfSOafA+rvEtewQnRF0YfHTpAhLCWm
	DWAc8KtlVtbg7iltUxwSWRLQSS4kNOA=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50b351eaf81so8411761cf.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774035267; x=1774640067; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SPJ27qWkI5c96vhdp37WS6c9O6xFfPoS9NHL0cnjclQ=;
        b=R90bL5M+THg8/XVan2vvMVyDSTJ1hK3LHaBljU7N1bFkU1iJedKgVc+K21ojIXtKWQ
         5VVJ+y430krqx3njvuHS9lxgP2tquQmjbMJddpocVvv7NHm9aEZpP7Uy6ZDNDET3f5iO
         JFgwJpYWH9pu/JBvCOWOETUed+54kfAr6ilBV979ErVGgy/g2tGoggdt7d/qriy5TnI4
         vW+TRIed+hOx4UIPpvONvnwEYI41cvVrIrrF/l84mY4tpmJMGQsPU5lzyT07GGnz6leK
         6n9nohTVbxkmtSeOvbm/KugrbePJcn1OSaGijeTR3npAKqXMx0G7KB6ngzoLTVfCCKWp
         e6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774035267; x=1774640067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SPJ27qWkI5c96vhdp37WS6c9O6xFfPoS9NHL0cnjclQ=;
        b=nSllHG3jTucYm39Fpea1c7Df2H8ArVXCSGct9ZYoHvBcYQf6qhdkN8QESIhTUwNAEJ
         gzkmqBWvGEbMw60RJcdDaXMEx8Ab5BNxdZD9J8Q1/TmAjDWUdBALYhiyFVsiDeafzIxy
         7MA4AwczOUv0xsb7K4S/zpU8x0k8pwtIke05+ue0BIB563ykIvrL6R9PPeUHYoocmnc7
         juikgGJSlvNf6U0h+aGKkv+HWL0YzqaRvbYRtuoW2oYkTaqudMMGzrQJSY6hbjIxPKQJ
         ew+jfpu735uarhNkPRcYpmQyQldURjkJCcvMWbHGceoTv4dOw3Z6CDOD8wUjqNct4wej
         gRPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGlfn+KMBOiM1rEZbnh/EK73+RRbAlKUlK5mOkqvPoREn4q3NbLIGtFgMgZ/6qItRw7xO1m8iAHw==@kvack.org
X-Gm-Message-State: AOJu0YxWXEdpy8ZS1qcang7PYEI4zP2tl/6qzvIVhusfpZuOmnIQgGi6
	vbh3OgrlTB6a08u8E8hmVr/+Ah9T48fOaoXFctuq1+fAIihZl6z2zLk3xAjDGAt1anA=
X-Gm-Gg: ATEYQzwpGQYLnMuJ5NW4NH4k5XT9OiUEsM1M320c5HWV+yncNh2vYP8Nodmqz/dkVqQ
	KlXlb/gfm3ri3kLq5EDXsm6Yt3mUFuHHoRKhrqAI+B0JopwqmgTLYeYUYSWbMlOh5yga24pDFZb
	ps8BkZjRltDn+ALnTT3TChv8Y4kWkDdXG+hf6aZTnjAzpWuDpRWpOHoMal1YJsxbMW+FRMJbHr2
	x2EKqQCE3YFqNtlZuDkZ+OFJsUStk5zfXr7Kl/AwawIRzsQwyUXKmg0dJ05vH27REIwyum7S5/H
	e8FW/F4xUDdkdgzNcrz+6rDOoszzOyta/IKDtZHK3EdqkJHaM4aYMwXBC8OqP2IyAG1NT8Pz09S
	4phIdn1mAkpCm5Mp1Z+bITyjUHYFjVNbVrpt4v1ZfW5TtkGBr7vxsiLfwbwwyRL6ige0lWBYOpZ
	AzBs2119A860qKiPwCjoR5EaJCB+gF41OH3ZIGEElkEYcuhsb+8u986R8csyqsJmiHgmJVWHI0x
	ttKnb2bNKLLPL52sQmx
X-Received: by 2002:a05:622a:4512:b0:50b:36e4:a614 with SMTP id d75a77b69052e-50b373ea96dmr54489661cf.6.1774035267172;
        Fri, 20 Mar 2026 12:34:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b36d23237sm33063701cf.13.2026.03.20.12.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:34:26 -0700 (PDT)
Date: Fri, 20 Mar 2026 15:34:24 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
Message-ID: <ab2hQHsCs2MwZqj2@gourry-fedora-PF4VCD3F>
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
 <20260319-config_migration-v1-1-42270124966f@kernel.org>
 <abwVK8nLpSLVcT5G@gourry-fedora-PF4VCD3F>
 <8ebdbdba-d0b5-4887-98e5-bc45f4565d51@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ebdbdba-d0b5-4887-98e5-bc45f4565d51@lucifer.local>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B4231C0015
X-Stat-Signature: hrbhnagtz1frmfx4dph15pkwootib8bn
X-Rspam-User: 
X-HE-Tag: 1774035268-258444
X-HE-Meta: U2FsdGVkX19tef26Nn4+ZofeNKO5RVpcYk+e/OebfD21kM8BqoWmDHY9cbDXdgekJBNE1zDsMN7T2CCbS/S+JmOjeGthlSzQFTGQsNW6I3CO56z7Vm/NtKB+Hyo+o6PVxWig8Wyy1mlRQYJOD6e2HrEIWvGSihwLesvxNd9182ckIlDCDKzwAULtc21qyFOZiSYnDXB1/iVo5++eR1ZT5hPjj5eF4y57mNBt6jVczbbfhfWxg8vHqf1KT2H8cSD2wr7tnn/JpVD1XxF38s2N9qjnpU67r3c3LPaJUkBviNHedF6eOfhNicwQkRhUDCMxVBzHqUzWFN/4t9ecU7bKWYTBoNST+4GnfqfC8Cg5encDJCi3Z/uioBXPHO/eIJWyg16ogXIKeJy9yUOfm9rKJ81q7r8HvBWQLZLxRuJSzWVuO422WX9oRISZ3FBfJY9ZDucTR7Hi1csFnP5N2mWbZ6pFgwUUAupiA2hvgOFIHduhZNrFmQLmYSms0+j/bydC1OzzL7erXl6rDTed/6x341xZgelhIBch/8HVsVkZcqxu3EKjcDejPanGLNhG/JlobMjvwqoNhzstn9RAXRlGdcYiUMhKqIJjU2yTTmnyeV/z33cmy8XsxUNIvWiIptS+VJtDQBU9813XGVju9gXKvOrINOGzJRv/TT7NV4dmnY8t6Lo/+0cGlc6t430UJG9ksLgifX6tKrevDe/oDqoLsfQfeDuvXx58Kl4VisPIv3JilhWBLAnGdmP/VBsiUc41mtxgBtZnhho4vk3nwqOqRWFsBAEF8jm+j0dxs9KRAfvWiZPb/mWgToYquZCSiuLNGn7EFAxx/rHeMmDsP8f+wR1bSwq9eaUPVT9GsoD5O96s5AAWlDXg4ype9IT4JJKNbo+4smHB6nZoPlUYJoEkOy4CWIbudpDebf6FWq3NQAifTTWTfYmBBgVm6G/S5XuPxU63ockL5a7QSGqsasv
 PJYa0Ziw
 pMaq/JNmWO6znvlxU/Zj5awZlrQ5DCvgkkCMyKXM0Y/h8xrd3Q6/ETmu3ioUxZGOGwBTjF3rdOZRAs/rXJe/SijqFajjao5nZSy2EfRB4DQ1q72mfWA1+T08w7EFOgc0O7tKEssfskZ8rMPeeRkqQStAMHGL6GPIkBS52hXw0iy2R3R8Cmmh6ReaF38ja24T4Ysg5litlyM/dQjIUFhlgMuhqmaZ4LdWVekSeCcJ/xkEyPDFCKjhGXvDqOhITuON6vCjSXKqxqdrKEcPz/abNuQuHdY0QVvKiacZpRz+suxEngZtxLt9SVqmGQLFJPZPJRl+Zs64Rg6OUaImY8VhsdvykrFpJ+wmTuG09/SS/WryOCHjh9ah4inmmYl81jzVgDJ+tG5iyn2Naq8PPIToT5joHyANVUnfob8YE41pSWegwfFv0jw3HoUA3kKUG+ic/KHn7/3QRyU+8F+BD1OR08UhReQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 04:34:04PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 11:24:27AM -0400, Gregory Price wrote:
> > On Thu, Mar 19, 2026 at 09:19:40AM +0100, David Hildenbrand (Arm) wrote:
> > > All architectures that select CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE also
> > > select CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG. So we can just remove
> > > CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE.
> > >
> > > For CONFIG_MIGRATION, make it depend on CONFIG_MEMORY_HOTREMOVE instead,
> > > and make CONFIG_MEMORY_HOTREMOVE select CONFIG_MIGRATION (just like
> > > CONFIG_CMA and CONFIG_COMPACTION already do).
> > >
> > > We'll clean up CONFIG_MIGRATION next.
> > >
> > > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > HOTREMOVE has long been a thorn in my side, I appreciate you cleaning
> > this up.
> 
> That is quite the HOTTAKE young Gregory!
> 
> (It seems my pun crimes are continuing)
> 

:P - it's just more config cruft that always catches me cross-platform
when i poke around in dax and hotplug.  It'll be nice to get less
automated reports from CI lol

~Gregory

