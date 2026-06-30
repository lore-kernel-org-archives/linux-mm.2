Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87A96C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A556B0101; Tue, 30 Jun 2026 11:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6587E6B0106; Tue, 30 Jun 2026 11:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5195C6B0106; Tue, 30 Jun 2026 11:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 243E26B0101
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:31:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86053168213
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:31:03 +0000 (UTC)
X-FDA: 84936967206.18.6EF2CFC
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9494E20003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:31:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ImyD4fDt;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782833461;
	b=dLD2ACE2o0O4SA/NTp+Z9Z8hRSpGBN4MDS8LrPgSSJc8p9N5DLf8ogjhcfvb5zly7Ky0QD
	3v07ouIhbFNEDcxJatR+/ow7cSGOjPsghUNXv1Ov8PhRzgqZsPleC/6rSU6GtcPwaEXsM5
	os0q0fcWrwLu1Q5SBIvblXIK+FHPTr8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782833461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvVAmqyImW7TQjYTHR7q/vQBEUZYJ1tMtKhaki/MPes=;
	b=3IGUjg2CrsDWtLcrW/hAHL3SxLIQk5O4/klG0jdWXHA3yGRVA5JEm996oD1hJOn9MO+bAd
	nM24UL9HL2Gur84H43n5c3a5RkZjCfNXmKDFFOQIxxPjxvB7qN/IIyGRr6R9aezh3WQ/33
	zLC9YRYK6XLoWRg5WHEzL4Lu2+sdtGQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ImyD4fDt;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8051ad12d23so38112507b3.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782833460; x=1783438260; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vvVAmqyImW7TQjYTHR7q/vQBEUZYJ1tMtKhaki/MPes=;
        b=ImyD4fDtOkyvXnuVNLH1zQ2dQu2HTYCEil2gIKEKxPBLEquS/rveBGaKOdwYaxAa9O
         BNbdxu/6inHjcx5OaW1nBbdlFdhFMVJznsnlWSj0cyxRD3remI2Ny7OOv7/69nSaSlAS
         rlhK6hNbnIB26kFP3tZiog5nr3maPZ3iQ+ptRjlkgYX+QzTr29QZTWGwJoFv4pgOxch9
         cIxlqMwOqu81WRfCxAqSDIIokQsXQ8qcopefvA6HNeEMkOn30RfOs5nC83Bu+8PCkxsD
         mmL2XApMpTrwY8DNlbtXxy/6+gCaWw4L8KZXCRnJFSh4wHKFLFvECEhU47K3s2YEaW1b
         +b7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782833460; x=1783438260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vvVAmqyImW7TQjYTHR7q/vQBEUZYJ1tMtKhaki/MPes=;
        b=TTwpm9fnXEPcqneM1ZY5cYhkr4a0ZQRZMAcedLoxz72mb0gn/m9O/tUTzN6aRLtAGW
         SYnztl6CVJtwgaTPuCHq0FQk8WBdZbfjZ7K8hZO2IIfm+2JxdElLYi+zbP+gmyDu6GCi
         Sn8bJLHiQlS6WFw5IDu6hHRL5ON+qt31T9NrcMjSa7YWQVU1X/zCyLjxz+yauO/ksSqV
         TEwpTpLBDI33ryA1nSLkPgX/lT0eyZ1AOzre6ZpKc3gLhgNl30LCExTw8eiMqpq2tJ4I
         v8FfR4hRloWY2ErwtiIUcip1lg5AIPnBNQpwPIuXqdoZkkxGRpXJmPbsN90Fy5mcgM4s
         09QA==
X-Forwarded-Encrypted: i=1; AHgh+RpIR4s6IVBLhrVUhs+emCGgcKGupA11pa2ExOJOs4RVYFWxgstvFtnfDQUK02yWh4uCW7Aw0f9vZQ==@kvack.org
X-Gm-Message-State: AOJu0YwNhsbsVeQLNc3+8UM1HOjjpJD0zDe2mo0LYa2+Shu2ixfKFy4F
	MgTRItEZy7jYPjg1Rn79ox+5CN1T/CI77mrtJFPRjf5s6DUnN2K72YR5yH1ua0JXooA=
X-Gm-Gg: AfdE7ckxlQTWVsf/RdGM8PjbSfSrcCZNa46p+ctImLSF6pe9WWkpgc4u+aUAUy+RpCo
	wLqEr98d84CN45iHE4ruTiRIvXUwt8PoV9LtRGXyt33ldZL/0B/gV4nP9VCU1zQ2xJxe/X5XS5I
	MNjdTpDQWv8CPrrQw6ezsEXvY9R3OfRmxPa+kkUZyWZzXz+dqCXMuE4KjDn8VDP+v0QnwAyA4Wn
	SL4rVM0mXa/7CHdgavGrW98GAm3wyO8e/B3QpGjLbRFN6cQdhKKBXDMSlQrk0theJISOSCBBCaN
	rZYhdoeoneKWPofCGYEY7kEE+ouQkmoDZe0D9xK/Z5rE4q6xt95gpDiOzBTw/pR23ahclaU5UaA
	LHgtblUZBUGYC3VJLPi1Z5EwN5QipmTbfSnYtuCSg9x6r0xRoiuXEuofVUuyov+vxO9MC3fCyzT
	yxoIkjtWbY4WvPJvn7gc9Cly5pRi/ikXbRx6OM8XQq7f7TTkgBxJZxa1sAm6QiRSJarqAf
X-Received: by 2002:a05:690c:6112:b0:80e:bd63:1780 with SMTP id 00721157ae682-810d7eb0bd6mr46000317b3.2.1782833460437;
        Tue, 30 Jun 2026 08:31:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a783d9d7sm25574106d6.41.2026.06.30.08.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:30:59 -0700 (PDT)
Date: Tue, 30 Jun 2026 11:30:54 -0400
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
Subject: Re: [PATCH 07/30] mm/rmap: elide unnecessary static inline's in
 interval_tree.c
Message-ID: <akPhLlv66ZqQ-jrw@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <ed5fd5358382217a92f0a6afddcfaa030c933055.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed5fd5358382217a92f0a6afddcfaa030c933055.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 3yihi4d4jopjsygyuooiwssq654iakz5
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9494E20003
X-HE-Tag: 1782833461-50915
X-HE-Meta: U2FsdGVkX18rRh+HlmO33pPtQKPT85PQo4Ns0eZCzZd4czdVI6KnWj7qHLjxGYXbQyb6ARSks5MlPHbP2WU+N8EG/oRKYUTCp8/C8n+1Pxi+2big5lLZL9m3eA4FdoPrtNkzSsgKoK0BmIGOD8Ijp3viFzpJZMBtsvr9GxkotYH91dvk1nNoyhEDD2ERZfZjJfBPl7YavWPS0g2qEgbpz+nFvWo8ALx7gYtytD2ZYRxepZWLZdJu5hVbFYN3WhmpCfgWPM53J4E6HGRrKFyw1K7bmOklUreWckJRxlywSDmXPhmd7+mndDfv/0hoHM6yBZqVTZvfD65FJVDocXq1oLJ8NqoFnDplhnGVsTkVY/KV31odZurgCuTdU1khtyWVUGnYZex0/Ep8KEeRmjge+Vmh2N3rlVlZVQJ/iaD1Kcv0m6otaGrG2uAfZX5jSlJGpxOsyHrtd1gmIJod4B1KdJxEjlfvW6eW9UfUVZLAq9cMd2SerocaPxSz7H8irZ+lS112G1e/tKgrCgKUOZFZ2rPUrPuIfARUzsqlVKvpRguDPQVTd0ylucecwBXLwImAsipDtfMvOau0YGO2hgrYh9ek6o+ZGQ3dcMLjX7YO/RNKts0LoCGbyNH+QICsonMEvGpHwWNicrjEa9bnr8FSfcG5C9of/A8DKjMhViiem9gZ3NdN4/nPrSvK+bozBMmErO2uL0AWx7ThDTJV+fVXmRTN1mHYF4XfhQWA82tUnbm5WbCQ+gOhNQqxpc/+WQehP7nbkiDhkeMg6sq+j5Ymu2g+2V1eitNGa58Uxa7XKrRWQjik22OMjfcW2vVZ/k3ZRAz5rN/7YhqXdQDHXPdc9DNAi3GtYI5I79eZV7ZJupW4h98ScQJhwDhTegENtQdGzWOdEiBpXJknPA28ivrV6YDO88/D1U9zDyVtX83XM3POtA65nyIv9x9EVgalAPJGUdOUAXOtKWM4EjaphMx
 qmIE/YhI
 z4ZEnDxdrYzIh7hFrQSOHS342AGuocxg+42xVUJgyCWAeiKxTnWbwU89Zsw353QoELjw5XpT3AEnKp30NgcTTgA8F+whVywRvaH44ggJmlUT21h26/NLUANxbcNVf9k+8+P7DHHsWNcB7sQYSWDflvplRt2hJYWZjkSykgAjX51KpP4xsTBMblbDHE2ZJmlZMNlmzp3FOy5lg1ixPHhhAaM8pfl4Ncq9o4L2dkCTrGxaX30mtal8NgI3VP8umPCePehWg0vjxne9kVzHaTWfpc+vACqj65jKY6jDNUKOKWN5iDmjq6cpJhvjttzBaZy/AMbulwnBmiZA15BQ2HScBMm3+cwTqRTzyY7dtVPA6dV7WMFb1xMnpFl3mxKDp169DB22+7/xZtVd+9y6sDL5HRENfT4txySuUQa1eLnxTHbskCxJeERAs/nF82z7Azy1bZsMWRd4K07rVrbf0N6C+W596JgMkytUAN1LmHrZXFnvSotEAHNfjyBtT5jcYfHmN9q28Jld7rRpiY7N9GPMDvsir1Fo3ZhIBrJBX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:18PM +0100, Lorenzo Stoakes wrote:
> It's not necessary to declare these functions static inline as they are
> contained within a single compilation unit.
> 
> This makes the anonymous interval tree code consistent with the newly
> updated file-backed interval tree code.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


