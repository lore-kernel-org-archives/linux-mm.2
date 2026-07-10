Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A66C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616D36B00DA; Fri, 10 Jul 2026 17:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5790C6B00DB; Fri, 10 Jul 2026 17:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48EB56B00DC; Fri, 10 Jul 2026 17:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1433D6B00DA
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:27:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 870A08CD36
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:27:08 +0000 (UTC)
X-FDA: 84974152536.26.3BFD42C
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id B97A4120006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:27:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QKbOAcAN;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718826;
	b=Tn2RaOrsdYRfumeXf9FGXJNrhiryCbvpmz7roWZl1v+KY9MQcpZxuiP2ckO/bOC0C+W1Fj
	VMFD75lAGV2WgiITnOGsLxHpJ3qGhNKRzrFt4F37c6jWlFK0WsGsjngb4SmW9qg1p+fpoo
	1YdaP1CFTQRWtzPrO5MdHiby7YbJG3s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QKbOAcAN;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXHpiDgBaIEeQKnuJdWSZ8rFz2G2XIdWbRFpuwAJIiw=;
	b=A1OaqEbaQKHwDGgMUkgO0NK6hxcaKiDXBNYHNltngKCWTH2IvqOnCQDcHItaBUdVoaq7Rk
	q4NUUGioE0DK7MG4aQMJD74JhcH0fbfR277rR337WiraSuiLdVK6r7NkMUmiRjJ4oWuWrA
	4qBJBTq7RZc1AcpHt82BndkYVnjakd0=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92ed19f4d60so89286385a.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783718826; x=1784323626; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oXHpiDgBaIEeQKnuJdWSZ8rFz2G2XIdWbRFpuwAJIiw=;
        b=QKbOAcANRbC2i1KpK72f2moWm58fOTCnUxONJgObZIMSlcar+vkwmuLY4cBiya394b
         fbnXK4cnONUsvbFo9iDUd3U1oDad+od6+apau+vmUzWijNUfcy182NRfb/M4yWc4vhOs
         JWTg52FXVLgImHCJ1hSQue35slqeavdpCKCNGKbkkLqXC7JCnwmVSfQcqzPZMwb4ZCJ0
         hk+1qaRL3B0Hl7gvxHVszChC5khNoXwCL9LkZjClRNrD1P+Yf53AWbxoKFCBNSbAiiZN
         PJUBuwSuxfZS6bvIgpHxbGjqTk+NtEVOSKRrIWYK1RL8j0nWbX/5wzwfCs4eFTabQTNP
         Qm4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718826; x=1784323626;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oXHpiDgBaIEeQKnuJdWSZ8rFz2G2XIdWbRFpuwAJIiw=;
        b=fPrSk/5lT7rIQz3tXfLykkaA5GjUPe5hi9lBoxUZW1bZ5B8WPasa1lPTPGRuFdGXZa
         IF4KcPNcnsi8J24dMoefYcwSlfUSneUmB4831g4liBpftXz70icPIpjN7zJD0L+8Lvae
         1DcyQWlYjXRivI6hM6qieQb7DbcJzMftdUx4gvrCl95IeKyPx+yHsPt40SW4yaOWuqH8
         0tjg1rPeutPA5TzcjKgmUKSyWt2SZb9vSCmEr/ECctkx+U4ru+qAELMXDIcrbtRkENDk
         c5gIepLr26d7ctbvmpD5B+8ZOb0Y0IflGmzXvM9F11l49PrtrOlfOlT2NMufKTHgsV+6
         YbXg==
X-Forwarded-Encrypted: i=1; AHgh+RrXtLMKYSxVfZAv5lZxu/p4DBoG7Uv6Y6LlPfVqWjy87LxXRNp1XosdqtTa/3qFszR4M34Y/DxmJg==@kvack.org
X-Gm-Message-State: AOJu0YxIufm0tdjAxP2LTNGCavtPJIc7yEs1iVDM4JQPkZFhaUyXB/nD
	DF0zd/b6Snx5VBHBbdtd4I91CCRf2HypUQn/IWU0PBBXdKS9H80myU8t8iC9QLySZR8=
X-Gm-Gg: AfdE7cmBG5T6wsnN21uehxmvBiv0geBknPDCvtHe5lNky9NlPdHBfj1oihBuNPoG9Gc
	/0HE+h2k35KpBDsjBAaoW7TE8Y2yMES9xPlJvr54VjJAqZB91pJOnL4V2xGWtVaAz1Y1c1g3wHX
	ZgNe2RNcQw8tkd2vUzrBFoUOHHg33gf8vJPaiwM+RypJG+lLc1phUIQMxNFATOEInvARZ/TA8UX
	JfTg+HQFvUHrJL92/OqPP5QoP3k1KxAdTB7np9cXSXZZHGnHd8WcEx/Ldmh8SvN0NFB06D0osCP
	6YBftoB13ShWh3SoZfzjfaqvxUoJBNkqwk297jE0ugeJ9cxbMdPAQZ6OnJn8/EfK6aVL3Cc3DOr
	Lg7l9lUxVlFrTb8vIF7WJX180UXqmswagYx8dJnzRwKtpafQJNsBGqVnezxtlff9yHfYR6h75fG
	CMgrI8Lw5pIPsuGtMU2tzmwwdFoIPxLv8JIYXVyllPheol7kMLm8ACVzlOozQ90RjZOxsZ
X-Received: by 2002:a05:620a:4008:b0:92b:856f:3c14 with SMTP id af79cd13be357-92ef3d1792cmr55468485a.11.1783718825767;
        Fri, 10 Jul 2026 14:27:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d2d68bsm289148485a.33.2026.07.10.14.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:27:04 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:26:59 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	iommu@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 29/33] mm/vma: introduce and use vma_set_pgoff()
Message-ID: <alFjoytGnkjJs7zR@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-29-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-29-2a5aa403d977@kernel.org>
X-Rspamd-Queue-Id: B97A4120006
X-Rspam-User: 
X-Stat-Signature: a1kjdsdwdmcu7d69yj4jo1646tcafqpc
X-Rspamd-Server: rspam03
X-HE-Tag: 1783718826-458536
X-HE-Meta: U2FsdGVkX18RIsP8dIYhAfzrFTJk+WHnzmYDv09clRS/V/NeTRlCiClj/pMM3oMmC0HuZ1DRV710zzflfWepruQXIFlsJWZK1zC1fNebSjXZrIXX3ufukyXnuq1cdwl0L8F7NoPEavzoQF9T+weORvqMM2WrrprlH/qSYEBjGcw4aWhDZTVqFHTsQT3/Uc4fyAe7xdFxvUD2hdyRre7Diq7tHsGYb8+qSiphYEP/DZfQNJMmNouCxqB+6bz0jYb9qhgGwrfdr19//ImnmMQgpBQPk04XIvDsQZjwBPISLd/2lLQgxsZla3sXs4piqD5oNqePxLgmkiD3bkCAZxkuy7Of3xldXUdHvvVsVHlsnG+PGpZboXMZK1MDOObfBHcEWSwKQlxuu0zuGKvfRZmPXIY7XWWeg0f9INtkg5msanKvQpl5oUecBZEHPl5Y/+OrWws58efrieMi/96YAaw5StuPID1kFIVnRTE6sylPslZ88opmZTiMkUp3G0VhJxqca4vhM5+hPYfX1EfFEpBNg0W1Sk2mxIzsWhPn/UtxF/W40uC0PP+oHHfb8YgMcPdSr6DHnDfrHcbNm0tYQrHqg4YCt2nIuq9EZNqTW97/+Yi4SWJZYsBKBJ7IVevjL6gcpW08Is3fP24sS0DwoZ2nHuyPqoVEdRDJBwRuk+OkpnCOV6hvAhuQTZrdsyND6pyymp7pRQ/qciC0JCiBVm1LhlrOxqbszmWAUsy+5WE72PPl6hLMXKja1TCMU3bWEqTE05ejNBznNtuQomOc58piI7Z84o8HDwauOx106XP+5H+WMVIncv93/tzyPOX4VCGZcnpa1yrbAg9PZUCnS6d0ioJIti3MHDVlf9IBThkzfGh93ToynodgJlbEYOPTkxrxe0MWPxx4NVZS5a2izmqlsJYFfARz9QBy4BLuyi9IaKSKGkCH+45iIJwmHq1V3LaGur0GzN6sI1G3cszZ09e
 uHGhFYrz
 Ho3eh/pUZ2wY8BHdJVFNW1XTjTcFydqRbtZwL1iJg3RptrD6czXAF1JfL7qOdz1w8UhryZGT/D5+Pqgxxz1uB3qv4ITCrv1a8z8amwfcHGD7GXdGfZiiuzAiqTP4/1mVJzKAP2gC+NmPf6N6bg/sIuDVOxGx/xprv45w5Z1Un7LDLJBdmXcJy1ebb318fe8AZLsXknPI6Govl+MKvsgW/2NaOEkm35pDSHo79UzVXtBQMsohYo3t8a+0u9daROz+SFHKU3xeISBYYyl0kdeFmCBajsVENrefAADm52fUoBNlBD2aFM1JRnyta1r9taIT1iAh40aKVGxOwgNalmzAmWIFXM/MwmLkguMWI+epcquF4T/Pn/VyRTiHHyslvnptr6/RJDBGLkX+R0dbUa4iDTjTWtJg1LVfgb3B+H+Z+qyozHcb8DiE5IZ52IsYXoNVCcKP93THSROvlP3NExhRTkdOoZSgWdkTPy4HJjgq9O14TpxUkYTD3irHgN0ZlWofAS/phX5c+ouFe665mEcqzjkncq6uP2YPWyv4kKOAgt6tIXPiU67gxZ/VV85MpUYRwzxKb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:17:10PM +0100, Lorenzo Stoakes wrote:
> In order to lay the foundation for work that permits us to track the
> virtual page offset of MAP_PRIVATE file-backed mappings, we abstract the
> assignment of vma->vm_pgoff to vma_set_pgoff().
> 
> We additionally add a lock check here using the newly introduced
> vma_assert_can_modify(). This asserts the VMA write lock if the VMA is
> attached.
> 
> We also assert that, if this is an anonymous VMA and unfaulted, that its
> (virtual) page offset is equal to the page offset of the VMA's address.
> 
> We must be careful about MAP_PRIVATE-/dev/zero which violates fundamental
> assumptions about anonymous memory, so we check for !vma->vm_file after
> using vma_is_anonymous() which these mappings satisfy.
> 
> Additionally, we only perform the assert if CONFIG_MMU is defined, as nommu
> does not set vma->vm_pgoff = addr >> PAGE_SHIFT. This isn't really relevant
> to rmap as it has no anon rmap (nor needs it), but we must avoid it
> asserting falsely.
> 
> All of this logic is kept in assert_sane_pgoff() to keep things clear.
> 
> In order to maintain correctness given this assert, we also update
> __install_special_mapping() to invoke vma_set_range() after it's set
> vma->vm_ops (which determine whether the VMA is anonymous or not).
> 
> We do not use vma_set_pgoff() in vm_area_init_from(), as at the point of
> forking, we don't necessarily have correct locking state.
> 
> Updating vma_set_range() covers most cases, but in addition to this we also
> update insert_vm_struct(), compat_set_vma_from_desc() and nommu callers.
> 
> We also update vma_add_pgoff() and vma_sub_pgoff() to use vma_set_pgoff().
> 
> While we're here, we drop a BUG_ON() and update insert_vm_struct()'s
> comment to reflect the fact anonymous mappings can be added here.
> 
> Finally, we update the CONFIG_MMU, CONFIG_PER_VMA_LOCK defines in the VMA
> userland tests so IS_ENABLED() will work correctly with them.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

carry-over from v1

Reviewed-by: Gregory Price <gourry@gourry.net>

