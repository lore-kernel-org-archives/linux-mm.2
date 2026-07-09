Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF23BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C84E26B009E; Thu,  9 Jul 2026 11:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37DF6B00A2; Thu,  9 Jul 2026 11:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B000B6B00A3; Thu,  9 Jul 2026 11:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84D796B009E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:22:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14B5A1201F6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:22:57 +0000 (UTC)
X-FDA: 84969605994.26.8AEF838
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 230ADC0011
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:22:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ok8Be0hf;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783610575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8MCYdDNt+ln4FYDiI3hqZQpolLcmikZ66uE9gEYE70E=;
	b=6VzoaUsc2afkceB0pisMkU5U63qxlbxm7SxPK8e9QR9RyVJcJBFXDYCwUmfK0xnIoXPVsR
	6iLeqJvcsLL09orh2P6WS77/TVd0a5sF3SmIVRPGjenZQAtFR+NcrRgOxLGeDlkRpQuT6Q
	86TxcIfYpoKdNp2yqMvbDSn1vE2Pqp4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ok8Be0hf;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783610575;
	b=eaMP3pUukyxi0IBmwbmfPV8AVhUpXW09v3cZvdMERrMLQSgvNmnRhpxRLVaOVF2v/RErey
	S0xx0wpDkaTOQ0z4Z4d8sUDD/CIbTNOCGqnyYusszsA3jMuRYW3eEE+Q9csqDUBYM/MWV2
	gASjQqYeEIKVwaXnUYcsDleF/GHeY+I=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8eefd4a8057so447456d6.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783610574; x=1784215374; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8MCYdDNt+ln4FYDiI3hqZQpolLcmikZ66uE9gEYE70E=;
        b=ok8Be0hfT46r2Hbp4yJmdwo1Hi6tP6DLUdxLNryf9KkyGIlybJ4hVYGM/95m7/II4y
         PC9p/j2h4Yv6+Pk3AQuqV5Tvyp3AulCGOo1GfIe0RR24eqT+U7KFZrx3RTnB/Pd46wxf
         8sj9O37ofm/WImwutQQjAvSL6KKg5Z2nlVv4LTULmYrud+w4vYvFcQanNJA07LEqNWFc
         yVQGg5wGxGZNP8VjCfQOcf6SL5zvNUNbVWUDoBn5xpAvgQT99PDnx042dAY1qG8va7dn
         Sw/bU+vp1+M1XhxeuanN+vopTRRaevEdYcu/+mrKSmkAaqQyKBjwP6fOjJBSpwseUM8G
         +ArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783610574; x=1784215374;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8MCYdDNt+ln4FYDiI3hqZQpolLcmikZ66uE9gEYE70E=;
        b=RU5X+pFhxRp9UlugMn/22aQFwHY/KgHP2vL3TnG1BGiP5BpcIDskGmiJuFSqR+FxaV
         rwzfDBV2SY5lWweR9EyFeiQsLzG94+7A5W2euzUqSmwQtJpHCzLixMR67iX7FJEap+7f
         2DwafcRWvPlIGlWIJLbdd2lCdp5ZRjHMkMxiCcR9le9tWQv1OlnNZkrEAyb37wOHys58
         tActNWRnRDF/opyjLLU3jb0K4Gj+XTwvRkyuceCYPdjpbdCU4FLUMz4+X9na4Vm/vqtZ
         IWViOWRmzDfo4MVteuJcCJUeVpwRm6vLP7Fr6AVJmtC9hvWhk7USHmWRRbr7oykFW0Vy
         l9aQ==
X-Forwarded-Encrypted: i=1; AHgh+RpnnMDLX7WMlRzxUDzx3otU3btGQToyg4Mexlb/aVN/GsbIu0W5HaxVONudNRbaZJvE66sA2ITUKg==@kvack.org
X-Gm-Message-State: AOJu0YxgYkBmYNK+SrqFA7FTgTVu9yTm0Hpzx/vvrQQ92fNvAHd7Ikup
	XHWGL/xd8XEhBGabbM7HBug8cySPl00Usy9FLRKJkFLeMR4DRJqdxxZiMoXaqsnZ4SA=
X-Gm-Gg: AfdE7clTn4AfLTrCYdu0zcw29zJkTal94GMveNT07CXmSg/YL+hIK1eBQbDcRD/TrJE
	QkuoFga2CUlzZOKHMjolnTzGgIhbYavXXTQkMuhRLp2iEAJSLmbBkmyPc/9YttGBJ62WPAmRxdG
	Oor5ihVTjsGShB8zXxYr+R4QFNpHwjmyQeKzjvyKffT0xLemR7Z8eedUdZkqWRoi9uzmOSYNHj4
	K54YyPdHkmKlAFI639SVq44bWCZ/rrofAql9WIpevMj3c5z5erJTlK6ryq7MS6g7HS0y4U9fs4n
	fuoMsFqZ5aZJa7AR8Y16j9JVXhs4CuYm9uJGr4jKEtiJoHu2EFwzPLYd7bsg+YOilwAtQx2w+Oi
	FkwRrm97yHLQGDuek8b3Akf5IyhUW25IqTmK8/bowjpQrfwM9guM2WgSkJE9nVv+gVhyXC/CDu4
	qjgMwigY/NRuRp+BMatLyP3/h03udOPEtYbbtMVMrn2fyazWZTDRHv/DNsP0PbaZ5mEle3
X-Received: by 2002:a05:620a:28cf:b0:92e:68be:1c5 with SMTP id af79cd13be357-92ecf6165e4mr847751685a.21.1783610574232;
        Thu, 09 Jul 2026 08:22:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90b7fc3asm1638936985a.9.2026.07.09.08.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:22:52 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:22:47 -0400
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
Subject: Re: [PATCH 15/30] mm: introduce and use linear_page_delta()
Message-ID: <ak-8x3TWsuhGzKlJ@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <eedf589778aaab33e6df2ad6556dcde536e13460.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eedf589778aaab33e6df2ad6556dcde536e13460.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 230ADC0011
X-Stat-Signature: t3weexucuorbpuocimg4c13naodj7zey
X-HE-Tag: 1783610574-439960
X-HE-Meta: U2FsdGVkX1+KtVSehEjm5Qat+SLeZilBytMgUlPNtFFXJt4es3kvSPLf+aW4Rh9WErXMMv8XMG7RHofKbvvdYPOZjVZrX9L1+ZOL8LDym+Ps0rBsW0fn33RL9Cbo6sBBagyGM7rpDnCcGHcEmDMZclqcHh96vpmtXKqBez7DtjD+fuGGzVX2jfPhr3cAa2Ehw/dGLXxWjHIs7erkMgmveKACkSWj7RG9BaU1OpTR/8QhmNbBxoUuaFvoaF2IR+ZObQ+SX/Ru/gKmwIJvtqdnPshiPfATqcnLbdshndIrTwwgRhqOJIxObH1zRqt0jlh0UFE1+qIFI7ir4PVw0yvhM46Kv8T6t/0Ro6iGg8PKS6hraRb7SJd5A5Y19Y8aybImF0ylenA9fUA5UDFdcVCMf5IR8irtQHFzVIGiJGFgVHOjppn3os6VgPRb32QhKy1ZY+TpdNhOxm85UgFnlMPwtbrvwy976LvnUsTS9SG22rKZLOycvQ/fLH2PtJbckke8STUhkTeYaTkXpVXKyuMwsUMDBqBOK00BfNLjST6VBanip7nPuieC2028ec2tcCoPKPAIMvwSCT1aiP5JFfCnQslF5V+VJ3rTrnzHUFWfQ2qvH67LoTzlhIdgPpz9uPCy8M5Hi6qLgHt1T4ISiNYH1lBBWjQvXyxM/0ic04o2XIWgshckWFEN6igeq0YaLOiohp8zd6K8ssn054wGQWEg/DENNYMlNlh3CbaZKG3awWf6H5X0nGyOU0AUON1NPDLu7vsl3aSe+C2H18R1u3b8ZlVSKmQ1ywbVnf2yURsDPnQw0jzRmWIheiRdjjjFX7+KgT6g5wEibCxXKOhTw+406dfpw8fOdh7AIOQhOmuGcGqLDk/0fNipC3RuDrrAlkcNO9IyAfCZKP44kXNaVK2rxI72XhfmwmrKZg4rh67+A4hGPLTnxw65PznMwEzT17Rz4P+pHZlVnF+qW2lgBsZ
 n9VKdGqG
 A8c0vxUu4x1u/6xLUq1kLarn4AX4947z98ruek44OLxa5LVB+UOv8aVkDkkxCpy6Pza/cwP7uPvNymTUkF+h0gDx3YqP+/5Tw9aGXZc/+mvSz/HlHYFtfadZ0glg2rpUMqdqjvIxRiMF4LGZlS+eGbW7Ex1gmMlK7OtT78vKZp9ApshWNpT1ZEyutbCIaNJ/GewShNsPDsOAUwVSomyKmWQmvTzyoR9t3WbF0Eqp95f3KxSZEUOrJqTh7zR7v9E7Yk7Oz1Ad4iNHbJG9HJHCZfX3cIeZkboSdpdwr9T1Q7y2nC9CeTOvIdF3YC4DF3PW7ohRiIYP8InKRf5NQORiBkG/+XArm2Yyb1H/Lx4ogHQHAumtH7yHzxr/CoEHeYd59gbtvrhye/2P35+hco8j7abNSu0vYEdg6hdXOOGqBQWyjFDCrPbjK9tBOOqL/LpJF9GOAzw42DxoMun7aC9WY9wu5vdUebds0+igw1Ut609qdV93xa5Vz9a2njKmVBdTOuxqeZBoKsk2PIyLhcGXVw4adog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:26PM +0100, Lorenzo Stoakes wrote:
> It's often useful to obtain the number of pages a given address lies at
> within a VMA.
> 
> Add linear_page_delta() to determine this and update linear_page_index() to
> make use of it.
> 
> Add comments to describe both linear_page_delta() and linear_page_index().
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


