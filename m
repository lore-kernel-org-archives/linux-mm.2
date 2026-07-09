Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2389C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55E96B0098; Thu,  9 Jul 2026 11:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D3D6B009B; Thu,  9 Jul 2026 11:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9216B009D; Thu,  9 Jul 2026 11:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67F656B0098
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:50:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE97512020E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:50:00 +0000 (UTC)
X-FDA: 84969674160.21.380DEE3
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2BB001C0009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:49:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VWvdEGWX;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783612199;
	b=wrgRm5LK0duLAJc6NM23fbhdxCQrtEfD6MsXkGAGPBBcOosD6f5z9PnhD/pGsoU0zMJljl
	tiK2oFQDXVxXkOxvg/ndZjs9gB99zfj8evaJGhn/XHEmZCQgFrmWHsXx3EcZju8UsG/qHg
	GXCM2WRestS9KlO/7/SErBDkZjCCC/w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VWvdEGWX;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783612199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHzvbYEg0XlBnUnrRe2UmAXaT3jquo9NtkCgPzQ6hGk=;
	b=OKN7T1odq1zixJcDMT1FZPSjzqBQWZj1YJ6UQ9IhVwonjaDpBWpN3ZB3KyJ2Qv6CncF1ls
	R4lmlVo18bEx5SZJIwCEhNIhdTnE8W16gsNixFMHRWDPQ4pbYNceU0jweENF8UJ+k9bJL3
	EFfrGDaa4R4Dkt1TEXtLXvh8FwBxK8w=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e55b62640so102985485a.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783612198; x=1784216998; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jHzvbYEg0XlBnUnrRe2UmAXaT3jquo9NtkCgPzQ6hGk=;
        b=VWvdEGWXZXP2dYkrWQHbCEaIxI5yk8cZtfKY9vRB2JElL9MKPCFbNsAc37iIv6/95p
         snc1emrktX56oOyP65EvsEoaoZemAKGKG9bY9p7fuBhbPUW1cgjIfaEXUhDTVtQG8zNg
         hLY2WPmB+/jz0LpbBA/Po3dChnYJgMrVGlQhbRks4l9iFQ1w354aRKDkV1UUQkqj1602
         Ib4T/e0mByWv0BiCBOUri+gLiMUC3emHZJuzR5D6RNFAbckdWAxWyC0R2/2gCtQXXo+c
         zfcd25LmhX5eFGaMiPTDPj+BJXYe1cVmFzsrxSoF4Ev2/SaMfyXrzERdGU2PQefjOh2R
         q0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783612198; x=1784216998;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jHzvbYEg0XlBnUnrRe2UmAXaT3jquo9NtkCgPzQ6hGk=;
        b=F327JT2YvWyE5XQYNcDVX0OQpDMCIaFwUCQme9o/kADDGnuKGSkqh0eNonyJOSQcAb
         LDUehYV/y0Q2uSIaf3j+3zm75JlAViQ9GI0SU1blmsI42TrcaqKl1MDEBYKZEo3LTqfj
         XnYZSInwUu921M4mbslq25n6I8qCHJr2tvhpQhYaSQM8ai1eSX/m2Qxq3te+mDkudEiR
         B+bcIwcHRryYzTMYndEAL7P3ZeEWBq2gZXmRBZO0w0v3HD0JC2I3o3P3Z0cwqPHFN0SO
         m1l3wiLl+cy7SfWFfP6p1Q7ISq5aahmqnG/AV3k7n6bOs++9gMrye+PuxKV/OdWODZqQ
         27TA==
X-Forwarded-Encrypted: i=1; AHgh+RpbpN6MmrF9EIxO8isNoFC0p3Wf2xDgFL8Z+0kk0e20uBO2c6XJsRKWMKtEFfyO9QG1YSDH28yhvw==@kvack.org
X-Gm-Message-State: AOJu0YxvCiAJCj7Fskg+SlM9DOnMCiOsB0ygoNZN8WGxzTnmSPXyJ87d
	JCQwbQ6FLXwGegmJ3ZVAAqDkvPNXv0iAQ4VwJiNm/7J3ybwDw8lWO75VDibEaYEWUTE=
X-Gm-Gg: AfdE7clpZY+bHR56f6XRqGWVKwU3uXYKzf/fZVxoUYs61360NkTVVX2iYgyxPW3qcr8
	kR13GkB52/Lbi3MwCI/OUgyF3iqLZYaQ8+2XAUnKspB6Oj8USEhGFr2fxxIOz+uxxHh512q8gJ0
	z8rgegiilBYJgVqARLl2IfQotso37PiJYz+3gMcm9gYcNfLJzwTCrq902L31ZriBJkKRSkTI56g
	F9PwtJKpUWOq+SVHdID4hwMbVHNzspAf27r5aHWVQ29lw9i68q7Ll2xiCsWiYT2QMR/drNC7i7b
	nb1vmT+HDgZqy8Q5XFWAp0A6I1pfI28Rxui4HnQTzFSZ9A/Sr53y93KusCH4NXjYhZj4BB8QZoy
	8L6vDJlXow8GIJnstrXF/y9fXXx5NJRRTAh/dCckSP/orqvv8u0/wzbIzEiPASX9W5oq5JZmQX0
	iOxQALL9BpqWGswe4bBX5gipbYjd1nCPTcHx98AITeYDALIf06TeiQ5p/+3329P7C9ELdM
X-Received: by 2002:a05:620a:8017:b0:92e:c116:bf0d with SMTP id af79cd13be357-92ecf95dd8dmr807949685a.86.1783612198042;
        Thu, 09 Jul 2026 08:49:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90cbe3e2sm1689967885a.35.2026.07.09.08.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:49:56 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:49:51 -0400
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
Subject: Re: [PATCH 17/30] mm: prefer vma_[start,end]_pgoff() to
 vma->vm_pgoff in kernel/
Message-ID: <ak_DHzxSA73zWkGN@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <ea87349d63205bf4c26ea79854f179a9bf8cfb0b.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea87349d63205bf4c26ea79854f179a9bf8cfb0b.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2BB001C0009
X-Stat-Signature: uctq91yoj1j57i54e3141ds3m1cha8d9
X-HE-Tag: 1783612199-647772
X-HE-Meta: U2FsdGVkX1/0/46Sy7Y8JupQfHmKmodhhXE7hqsrzhIc/lvCzW8uu3E0XGeJijykI6T0GUzh0XK4iNGGM0qCzZaFQcD4J7FTbO1cqLUZGxkQdb5jLBBMFaZIoPQ81G8qpA4nhUzRZ5/7souUoShDRx4+Vg5uFXj7Xthw3Kf3PLlWunWBbL7oeAs2PZhNggh+hyvcUsXO+1rN9h8a7WM80z3+YJzSRIw8KthNpoEfkEuRb+D357TrhP1dZP3lCDdFdOyFDaBToTIzs8ch/VbG+EK/hzL0+xrsDpklt3ZQV34j6SR7zeQpULhH6bk9UKtK29d6Dick9JFog2jEXo7gLbTJm3xzk/GBzEHmLI1kNsNannSBQk88czZQ8TVVe1k8AXpYQAEYfnief/8RSzybkzmsOUsYMkrpLS/Hsgxz5LZIPsT4UOPsewvO1I4SR8MMz+G2NJ3u7XMDNLnk1zjnsNgCHa5MTw+qr/zqbWLnsh7DkFDkxd87hGmxPaYJTZz984v59Njzvw01jZhEvPj2cxm+7YfNSHFWSS7gVvqqAWAK04yZz4rN9Tcx/HsWicsl/L6I4EcxMVoOHAVPHU4cUupCrxtXGNQW03/nIVPdHiKaRosckZUuAYR7JDC42VVfcA0o4qxFXH30tRRqT45n3Hrjk+a6ugb0Y2BSaxDxNQokZtGzUdEi+La2ie33cBRh1nrru3Ov9EAJ3206Dwn1/o/VO+en8hS6QfMfSd0lD7Z1qKKUcjophb0JrOw6dfcHnwZu0PElGpIJI+mkd2Zvo317cYvupQgz5yUJDtm7WoxjFlmSmT+t83Ga5EE6zAV4Zx/AJiRPgQtDmMPHpgQzdRAM4DtlH/tqcvC7bFsIEvLW+whnwdPXowE9alZ/Vt+7cP0CAIW9x3apGpL6pBq0eLpA7wn/c1W0QDMzJD4f141rf3ymBP+I6QG05mf/qsF9sKfUm+tUMPpkIlS3BRR
 m3lzlLMI
 OrJBgEuw3vcwbjyxWaiRq0tzyNN240ZuPYmmmKBiagkNWWaJQmfIQ2A3Rjk2cIO24eDih1up2Y5CtRmogNo3rIwvsSnUqaeP3kDCmFQkOr6nKOHDYWl8KY0EHau7a+P0Q7vW2LEOfcRl0QDHAEkZLYotsPRbTWMbnVoBS+GyS5VdnDE9n3eWklsV4uXnen6A33DIu3agxySScYmHCR8dGy05zlUuEGk2+KB4onJTC2t4hNneQfgRNDBC4NP71Jqe5ZD600lWfq8xo0spBAuUkKf8DPLLHy6Jall/6wjv2/rNkv9TpEZIvYAioVoVv21zje29B9tJhrgc9m+l92ZhiFwVR2DvDqugnt9hu0PcRBNw1Jw80Pz6XJBUuom7Tekw3TCa0x/F3P89QmrlfTcanb9DpMMmr/dwi31Ezxu1OoYyfWXrdX4HkTxrVq3B820Q/TXTa4fbE5sB8ngn2kqAXUjsWLlZ3r0Sr80CEB56U279/k2OkREMWGRxKTSBTCXTNrcnwVbKQwt9ZQMSvJMZvEo8DeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:28PM +0100, Lorenzo Stoakes wrote:
> Be consistent in using vma_start_pgoff() and vma_end_pgoff(), which clearly
> indicates which part of the VMA the page offset refers to and aids
> greppability.
> 
> This is part of a broader series laying the ground to provide a virtual
> page offset for MAP_PRIVATE-file backed anon folios.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


