Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 078F8C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B80716B00B6; Tue, 30 Jun 2026 11:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B589E6B00B7; Tue, 30 Jun 2026 11:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49946B00B9; Tue, 30 Jun 2026 11:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 780D66B00B6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:46:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0725A0589
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:46:54 +0000 (UTC)
X-FDA: 84937007148.24.D504076
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2CCDA8000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:46:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SvcqhpAR;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782834413;
	b=k3Vyc0yYHyak5aWHqXumwhxWXXVPLQ+VooFUjtMqBaLxp0fWJYK6THy40lEWCHVFszicMB
	D+a/8Dp/VLQ/jxn8KZyUEDIhgrIkf+nV6e767ujHEMbrCtYv0z0XL9LAVYbS0TbUeymRBb
	TvqCULx4T+2coF7sdaWLXOHj3aEv+/w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782834413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3V1BQpPjw58FUuLj010lwChkcBGTpKii5KT4CVPULY=;
	b=ePQ5gE9iap5fi4I5vr7AcAHezjtmdZX6Yxa4jf4D6Bn1ve8aahGetVXaG2LsiKsam0VSUk
	y7wEgu4o51jdy6ltsgMW9JgozAqT16V/u1ugySVJXuTaMCRWRa5xRya2nIwWvV+ixVfFsy
	VEeU13dQt9XEl7fQH8VPqkvO8nnCz/o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SvcqhpAR;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e65e18969so87969085a.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782834412; x=1783439212; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z3V1BQpPjw58FUuLj010lwChkcBGTpKii5KT4CVPULY=;
        b=SvcqhpARs92XKOOdnXb1/DMsRq7PbRK3qEKkTcOQJsH8Dh085NadQBcm4j4RfQJIEa
         LB05T6cLSK5SyJ6JTxdVYuQQ2ac9QYTqFkbcryVGMrEizy5FKirysK4HszJPFe2O/or0
         +69I34kcHYjmjmZ36nFsUlToXj44yRE9YO9rmAnA+5sgQ5R0jH1ShSLqSqobyarIEakA
         2zGj5apX2/giWopjfBnD0rTwRGYI/OSRD03Q278fEA5IAO9IOrAsFdfIB6ooDEKzDIJE
         x3Q1RejvrkDkrCQryqqSxJtQRHOGwqwDMAVqlZ7iCCAr7loCnur0Zf/CmYIC7Rczkzf1
         P3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782834412; x=1783439212;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z3V1BQpPjw58FUuLj010lwChkcBGTpKii5KT4CVPULY=;
        b=nJ0eTtN4cSOGqCnxA1lBQTlmeKwJ1K6Kxpa7wvB5Z27bcOzS8ocgKbW5/AhX7NXBb9
         bDzbQZ2x1zhFyXTbcMMuBRRHbwE6GsE0j9r4+JXNWulFkYL+l2s+4Oz/l3dyncR7a4d2
         lSoSV1yoWJNf60TMp/cTlhmqFGo+1ugI1L2EdP0JzcTOQWfz8OjLF2GjatHmpypmbSDt
         metraRho11f+hPsqVNnFer2IgU8U7opILIyf5kp8w59ODanmGjUNu0+DT/3biFPuS2CT
         Qv0WMA/pqYbehSJe2KCGtGQUo4EbNQthy/XGOtmG/YE9YGjqe+qcwv/LDe60W4vlO+GS
         GJfg==
X-Forwarded-Encrypted: i=1; AFNElJ8AV1EqNkf2vfZD8VUJb00fOhO0oPcQXDDueJg1O+3e5LUxDOODL3YAYKJbjL+YZoB0k1X7NjckaA==@kvack.org
X-Gm-Message-State: AOJu0Yxe3qjWsi6+DyS9mBHmN9MOsW/IHqLiFG0/MWyslak8XyxpwJM9
	Wz8fQ8/K7YL0JGx6gZQO/wi7bBJOcDIyvXfDAIGqlNMYekyZLICaJz099nwxWWlzLIo=
X-Gm-Gg: AfdE7cn/hlwcJWROQGpXrckpC7VNe6UVbXb1dWtUUd+R1zUmOYAxpvNcPDHERP2rip0
	vTHukpjsQKtlhjMC6YI/O7/jrt5W73bm/s61RDomqNWGWmDVOxQ36CbBDY+JEVEQ2NA6KYh6CAg
	8ABro4Kvz7G9vJ6M7beq21vsw8Fad5Hw21bXpVVe58kO9Q1yg6K2zOxkWCIKPC9DHvwyvNtKIAr
	91/5dio+BttnMeH6eWHL8ihX015TNdZbKkMzmXLN88ea/9K7eBnxZjOIQpgQyQIz6vjJzvdqic+
	vGUVycDzl3Ps51EVT2iPpaEyQvZhEUJ5V/IrMfaSgsyjKm1GGqsT/n6aCdrJaKiSAimKUBs225W
	CNzt5T9mFiXoiWpNXMfZoke0MnyYWNmdw2/w3C8lBuIx2bVer0j/Q59IUgNgZgLZt5s4dt7vm/n
	U/VzgTRlwJnaytVslzYGA6iohctJDX05Cj6nHNWdUuqELrfiZOh+jVEP5PUQBGRaEy6KVX
X-Received: by 2002:a05:620a:2913:b0:915:a47c:f721 with SMTP id af79cd13be357-92e6974d636mr316697685a.21.1782834412151;
        Tue, 30 Jun 2026 08:46:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e6233a5acsm267797785a.35.2026.06.30.08.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:46:51 -0700 (PDT)
Date: Tue, 30 Jun 2026 11:46:46 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 09/30] mm/rmap: parameterise anon_vma_interval_tree_*()
 by anon_vma
Message-ID: <akPk5o_gHD1SxX_0@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2CCDA8000D
X-Rspam-User: 
X-Stat-Signature: jmrbqo73uyrt5ijzzjuzkfdynjt6mujm
X-HE-Tag: 1782834412-364856
X-HE-Meta: U2FsdGVkX1+OMTXTxvWe1d4RGd70bPaB+vjqlAy2QerAE8Wn0ZaG6Q0A6bMqG3NsNOGn2AncbOEweKlYFwN3ar3QYcSfWkH+BbX0QD7WZWjWs+EsbL2mIXDtd0qb6EJpR6CxOv7/9EaJ61ug3hlc8KpuUibzCblurM4CxfLRQq+6weQ296Al47zwTuDbygxNjGbkGI2Aouz2RIA1p+SyVXaKhbKCgAI7IVarWlvdBVcUL4pYUtfTOyPmJs5Tsl+N8nAMWD0LVs9k/LMEUVpZ09O6wrAclJL+d34qa0ROMzAa0NGg2YFbr9JadFDtl7QwwSQjslh8SjTzyN8wD/h1tSb6qP7NvDWrKdwtl8+I0cGevzcDl+ReCDWDnyP+lH31yQYfbvl0l7fl/djES4UyrQnqctN6O5nV33eGCfADQZb5/0IiWzHk+A//1pL03Cxl5t+8nEvii/Aj7NG5QplM6/Mof7iXNzbs+UplIgcKFS2P85T5bw8o2xmgmUAElL+sqxMdCnutkCw6jYTZzAr+GCv+ZDMBuIt824QOKGYJke1ncvQp2fdc0Hju7V98UddwtCANjcTBOHvTHn4/+0AeL1RUnmpaIpPxgjjF3ZswzSm62qFaQLqFB+jjZKsKN4lywwqUhsvCbqSan+KmW7BhUuxLIbPWBswqam8Ms4fDEtOgmFSurPymCIcVLc3TiHWMCB97I3LZbfqKsFBnz9lp1cTp0slyNdKPEpyTliaxdd5t2a756CzPqFAcfelDIUOlfrhfIo6uZYnaVA7PHa1Y2QW+ZO21F+TFV5BICn4g0AmmCQzit/91auRw25/5KVPy74f2Y0mIZiyHkDxy7qAhWtgPeqe7AVmAnRpe3CnrPGqIUzkDVyYz1zLCEul6uVmEyn3I9wksYBCYj2b4FTbGvP0rjjQ6KrV9ad3XUgUNAOdwAbs/X/MHVcG07GPg0iz+kB1o6mDKwgQkevC5/sa
 S/n6FwCI
 jrGOl/kvwMyyxgthFSlifD854/Fa+osqkMn+ieB69SpRPuEv9bVfi6L7jFzmIgwdTHCfJre5OogVgNNVtgiPsuYNBabM5d1H7PoNZ27mNX0kUm0l7DepJluPHli70euZwrbLdIj878jxU9KAvradlhBzvhzt6gvNY1jwW5LVBkP3unfTKiy5hCnOiqHmuh27/e3uJEFYA8J14anvhC/JrtHi3vVZKHF98HGq8HEQPWIpap7Pbm6tlggykSbQvZaXXyhww0B/+jQ3TlqsNLTK/0b2p/uUX8tSIcLsJMyAOs2QaJiAflkWelzpVxfsya2LAet7cvBnnOJJIbxZmvzMGC5Nv9bGquoLxFxAoNG+SKfou2o33SVVseaI+lOJjJfXI66kYol92jmx1JsOoTSuWObRJG2+CXgCd1/+DQ1Z/8w5+W/AhNH8eCAPKhtSH2fnNO6ckWa7OOi0Gju0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:20PM +0100, Lorenzo Stoakes wrote:
> Similar to what we did with mapping_interval_tree*(), let's declare
> anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> 
> In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> anon_vma and the functions can figure this out themselves.
> 
> Additionally, rename 'node' to 'avc', 'index' to 'pgoff_start', and 'last'
> to 'pgoff_last' to make clear what is being passed.
>

would it be possible to split the pure rename changes out from the
changed function declarations?  It's hard to pick out this as something
that needs to be looked at as more than just a %s/x/y/

> +void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
> +				   struct anon_vma *anon_vma)
...
> -	__anon_vma_interval_tree_insert(node, root);
> +	__anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);

an annoying request, sorry

~Gregory

