Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B8E60A5BD2
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=YHoBrcVm
Received: by kanga.kvack.org (Postfix)
	id A45506B05BF; Sat, 14 Nov 2026 14:57:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1DCD6B05C0; Sat, 14 Nov 2026 14:57:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90CA26B05C1; Sat, 14 Nov 2026 14:57:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5188E6B05BF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:57:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88E00C0474
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:08 +0000 (UTC)
X-FDA: 85434783336.24.5D0544A
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE4EF40007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=YHoBrcVm;
	spf=pass (imf27.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.43 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OCVS5zlhrjN9ps/q5PiJQ1tTNBzYlAwbpXMt2B00TDw=;
	b=JdK2H9wneMltvuDmgm+tQuMux7Kh6+4IhvfFiXgygNehHvEsx0NumIkoVVW6FFXOnKLjKD
	UL2uAz8Y3y9S02WNcyTAeaTmY/5s5prV1IqGB2JqyFdbSRqAWgn56lybdEVi0vFWxlBlod
	4YMPPeC0cbtobKeKf32wHp2ynOCNlf0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686226;
	b=ERuSpQwQXTIjJRbkAxlrnObg9g40D4EDuYismn6lLDBZaIypTmU1CZ8Tu80qLnekZaLHiz
	fDw9u5L3lDJnEpQhNiUfsP7w2dD34gmy00xMV9ozfVwHtSXN6FotXUzVQRYlsN5xx0zx36
	AUGP6g/qzwARPrsyqvIrWx5f+NQ2NA8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=YHoBrcVm;
	spf=pass (imf27.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.43 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b08cf16decso1174523a91.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686225; x=1795291025; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OCVS5zlhrjN9ps/q5PiJQ1tTNBzYlAwbpXMt2B00TDw=;
        b=YHoBrcVmln1WV4wDysH1tIw5JkU2O3kpRJe4ZXT6ijQhZsi/bH7LFTSlCEFmhgngi8
         tezYrVwxtWQG0z0VzQ7r9D1HlfgFoVDoSHfi7IZxfRMoj4MPyhPEWOImhW08pPBYMrDJ
         gBp/GlmcLHGg1NPzP2kXG++HeLtPSiABC2tJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686225; x=1795291025;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OCVS5zlhrjN9ps/q5PiJQ1tTNBzYlAwbpXMt2B00TDw=;
        b=ghUjlKBVILF67kffIT6sisFtKN12OKGg4CkaAz7WQjNurMdtcy1S4eYC90XNOupZcI
         lwdNJvMH6n3IQbX2nhFWnrqi+qdM2yYmwBBZVc3wOkeEYlXJLZeIXQwikUgM+FTE1qQr
         bTdWJQUy5w2hPkSGGjTCmq5DICrEtruLbh34pmRq93/eRrCOKsh3CgxcwojYgkMH/bJz
         3V7NW3Vux/LG+3zGlwD1zWxyJ6G9h859QDQkrGjR98tdW8n5f1TXRIjGxxrX8CgMarMj
         cwKlfmfLMA8ID68QLEOTP2kYnSV1jpoKIbPzo8M2nOEDpsWQB5GMTt8n9z0nYsLhwO4x
         +9OA==
X-Forwarded-Encrypted: i=1; AL+hErFyWbzFsXaKlnWJhFIRW1/RDi4xji8OM0JpvEX7mJSFFcLQhIvuk0V7Iy03zkEonhysPvbTQpW0BA==@kvack.org
X-Gm-Message-State: APuU4Z8Y86rnVGxuX6kaUYQdzCygMhPYuNHK4YPEnIHqgXzn73YWEzeW
	E+y7lNN3AlkQaMKnhXOoFnDQQNs5+TghxjXujw0IJP+Q1Mgkg+Xp9LVB4RLpXjaPvts=
X-Gm-Gg: AYBFou1B35kn7cTeXC8v9B/KWFxt+2HKTqU7cy8f1gTuS47eswjwlC6L5fiB/xlUYba
	KQSM2U4kZweatFB1H/3jfxfDGLysdM5F3hXqHCKGQVgJAtyHtFKAkDIAYNJ1SHI9X9pcRYNBWK1
	xk52tCACxbYXIud6tJakD2NnpfYdZKHJbjNuf7ipRGgCmmQT9tMLcR4QkXQTMDTBzbhReZJqw3X
	QGmc1UWjSNC2tKR5zdZGq2TGvDTF3B7WBDrc0UjLPHrz6YTV35Jv+0XO1c2ArpF+ZyuPRaUc46C
	T2VKxusZZaDXVabXfN43jkIVimCPcYYrW/UNRDwgLfOLsQ/5KfkXCy8UVbyse5eHDXHDUfJkOTt
	W3/N3Xd7Gs1GHq8HkxPNuHVpGptkhJrHfl6xe+pzRr0iKyeORMs/T6fMWt3JjGzao5OuKNBpk+g
	/gDanGXO2CCuuls8YvBGZsWqOGFdvf9lPjV5mQsUIgKOrZm9OPMj0zjxhRPHd2rpdX+LngLdCkm
	MTEJkVmr3GmRCDIZ+cIG0DubwQw6UHdD0a6qV0UMoFqH02DNo2l3Yezc/X4GrhgNIvmRGEcsuVI
	2C0HoPTxUry1RrYfLytADh5vlYtYP032JCtL7WpW6c6ldCeFQj5ycn/hI4L4SZK82BwyyhwHI3B
	8EJQOWfxJCaPLiaWTabIaHXIfq3gcKR0kWVdfJZhPPLw9lFT2J25U4Uu7spEJw/Kfvv6KsH8Dci
	WMvg1iMD+DWhajhT9huEqE0CxEXwgO7rLIjmkXQBe+iwD00L1PfEb3GTs=
X-Received: by 2002:a17:90b:4c8f:b0:3a5:133:ca5f with SMTP id 98e67ed59e1d1-3b1b0b983efmr6301490a91.46.1794686225426;
        Sat, 14 Nov 2026 11:57:05 -0800 (PST)
Received: from [172.22.0.2] ([4.16.0.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aec43699sm9589262a91.10.2026.11.14.11.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:57:03 -0800 (PST)
Date: Sat, 14 Nov 2026 11:57:01 -0800
From: Chris Down <chris@chrisdown.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
	=?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 09/13] mm/migrate_device: fix use-after-free of the
	anon rmap
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-9-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-9-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115701.3a5f64e24081d09f@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ennbjkw4yjpxejbjeqrmhuurduq5ig5x
X-Rspamd-Queue-Id: AE4EF40007
X-Rspam-User: 
X-HE-Tag: 1794686226-48876
X-HE-Meta: U2FsdGVkX195krgwO+Xp2C5Jeh5VnDIqrlG4haXOS5P4EC3I5UJlBQizkzf9kJHtWtM5FVaU62/OGo+jZ7NE4oafrWXCKLgDSTXqesCTLmcTCSHi9mCQkxgMPlwQROIZwSKzG0Uid+Om/E0Mni11wS3heH4jT0BCiXFPJyf/u1NstwApU5noksErWeTMhLgmDAzH1duCvfCXxRXZECtdRkEwU1LPJJzmrUogZrF+z4DFsXULhpj3Tqg8MCUhUP9WpRQucC2EEGMB3sZX7d3l1ha9PsM7jjjSzjn6lBsEuWPuj2cZbc8KdNUgW7DnO+qzeaTeip5ZZmwf1UDzXLONuUFyz82EOJ/IFAH8lagGb0Zv/7qyjYs+3oSvnZHsFRPC4OKC5o1aFWwLE/2QQAPK9vrME0/2yMSCMrpRYGfWQPE5zJ0YEUDDboKub4IXtuy5jzGWAFQFaVgmK6UQ+nAy60GF03ucl7a7DZefVhqLI5MT3z2mBX8D8IBGGGz3Q5Yh6g0IJPqnttHjZTvrdmxPDfk4RwLE+54tmAm7p9sV0IKVD03EXMXftnxjwU/Bb1rBss17QjxNhi5YkzxS56ipj3tKPeNxRibsS6QsUD8SjJUbP6XN6Obmv9YdzgdjYd4gLqOcvTiDUqGKj7ZrdYQO3hylo8ylnH96UTuHepVjoCtknSVeU7sJir+Y1hGo+5qw4fEXQ1EjbRw7BDDlvCACKaTw3kUhVwnn+BUahXHJCpp380buVlQTuXv6RRI36nZjVc784gJuFPo7/U0TskFXxMpj1VEILcb7Y2Z/D7NthD6x/TUtR9L5depXkwYkT+pCMGcWoMi6TEcqWb1DhTCU49EOqa+7H5bFEEbWK5TyZcV6+MiaDtmeD9tlhvfUYuLRZgeI5k0sI4sSnc+kh6Gm8Ef+X+seywKl82MU8S8jtnprOdOI/HIkIXQwDfm/tDODxWI3u4QGQPOqNJmHR4a
 tnW8Isjo
 gPsdztkKU9bXMWQbaZmXfvXfY83clIJrvcaFh8QdpQ9zTUPn1bu6inH5J3QwYdESKQB+hPtVmv02Lp26w/zLyPgT53DseMe4TXPqMCT1PmwlL61MXh3qJVnupTmKPWDuMVTROjplOc/rtPctJ15yKUmKJrkwciFWkt6SEdtTTECjygyrKB0cPz2HcobqirdWOp58wv9y9iFM1Fcjnm6BU4e7Ds2xFXumFPxM/3acdPe8tUbzWdUZ2tAT4MiyxZyK+WytRLQ5kK05IUuQhEGizcBGqRDZL18ijzm1r0zj45ppPCpnX55UJvMsEAhNmB9JP2SL5FCJtr5djac5wDNBYSWaRDNU82B+zHb6vRs80DCQDVMGHkDQrZqQ3736PbWYRM4uM6Hjk8SebKG4Umjarn4NAnbfCr77UiX6uqjBFcZiBpEvezgAPMpHBZYAxBBrYWyo9qwf3Dlr1Z4n7w1ioJBuUwDLY9ZCAC3NeLS4FqDpGnnXPiChza5ju/e3o8W+cX3C4EK9ivl/lFEWWNBQmK8TcM0MZWmoTvZSvBIjWjeY6k/ssgUvfsgAFHR/XGGRuvioCn7paAfkt5Fo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

Thanks! I've tested this with test_hmm evicting its device memory while
the pages are being unmapped, and with this applied KASAN is quiet
again.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris

