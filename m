Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D12BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 19:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7497A6B0005; Fri, 10 Jul 2026 15:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7202A6B0088; Fri, 10 Jul 2026 15:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EACE6B008A; Fri, 10 Jul 2026 15:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 379F76B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:38:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE798120570
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:38:48 +0000 (UTC)
X-FDA: 84973879536.18.862B663
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 097AE180009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:38:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LTTgI4JQ;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783712327;
	b=FGyERgjGaB6uUKq46vNFaL8WazAPIM3u9hMnSgBMgm27OnQjYrSmt1kX8WA7P2gZIsR7/N
	91+lp8aLhx6QAg+kqdugnAs4+iFOmUf1z57e8lYU1h8JH9YrhOWv3zpJ6vL6wH0Si/93Da
	rx0sQnhG7XikaU7xmlQRBgmEH7TLLsw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LTTgI4JQ;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783712327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68XwZpqFqsaLFsxYJLdxs3+k1PzHke/kGWmUPy80R6g=;
	b=rCNRZAex7Rjhict5j4q1cT1i2QGlYhGkav4kkhMnNQ7FhYMsAL4uxp9eQkRtE6AHlU0SJB
	9g8T6IeC9cN0ZCNMGfAwMoHhBI8xg8NfbS9fM9AUkonSStCuEeB0MweSjE7/nzVjxslGPi
	te1hp3HlszQ5ABOYoIIkHYxMPg8iCnk=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8f032b47e3cso10244436d6.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783712326; x=1784317126; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=68XwZpqFqsaLFsxYJLdxs3+k1PzHke/kGWmUPy80R6g=;
        b=LTTgI4JQcAabk8COzk7EpoqEpsJQQ2vMhij55Ejp2ivhkto4Og3J/IU4DVvRIgXhfT
         e7ntVLQQUOyM/JHsXpoN7OJZCyIMtLi0ShPCQzsW5+2lYpBwAGHftNRTE/+JxmdpvGI9
         ruyLRCkOvexvQk5ZbjGDfjgaTHNBCLXY4QR+jTDHx7zoyy+hbtPmmFDW7Ty7xr6BlXy/
         fdVaSNsdl5UpaEDeqthYPbGEM7k3j29Rc7R7b0cu2SQFC2X4JllOkUssmZ0JQVtqDMG/
         VGpj7uHNo/85rERtNXROi3dktGtoT6uqoAt8WuzabVjOMB4YXPuBAx2Oj/7U2E8BtfPt
         CbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783712326; x=1784317126;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=68XwZpqFqsaLFsxYJLdxs3+k1PzHke/kGWmUPy80R6g=;
        b=F6srOe4d/6U9O6rzp9N289GQVrqpJYZjhCuka8HEt+WnBnc9bqydDYbhw0ONsL6OdH
         fySBhWtu8vdei6wTABy2lZk8S4m7ZlO5uQ+22HSHOCiRjrnHTXZn/L/gRWienBzWoFG2
         Cy1N2XVD5Z7/ZJlrQETvMU0bCbazJnwYNX7feGRcU2COEiW52RrJNTf0wakeibwUM3Jt
         /hAh1AfctfX8uf5O2OZkT8jsSr8neXsUTS789KU7UvCyDL/gQcguiAccuxyQSxhM+ivP
         S1H1vzbThJ2fYeb4qVBn5wb8nKkdtqMU4oUqUPcW3UhPCOQQPvhZwTLdRr7d0/N1xC//
         fD7w==
X-Forwarded-Encrypted: i=1; AHgh+Rp6AksUEvl5HT7wc7NHavRmuMjjAfJhM10WQWoJwdo6MjG0R7Kc65s9bBhK7C0o63dcFJTGbI6pRA==@kvack.org
X-Gm-Message-State: AOJu0Yytf/7Vo0S20vVRQTRZDA3BgDb2nFHH0yB7vh76ca24cncvw+rD
	/45YPhzrGfMaQi1eXzx4N7mjXwLfdFKHRsGzGvw0uz/XRpKB03blfak1c+4NTrVjEts=
X-Gm-Gg: AfdE7ckmSRstkRIx1oQYUh1lYLf5fgKSytf0HtJokr/aFJBT63OQrIjwaKanCAe5u3y
	Qt0R55qavB6/8iX05ATqRbZUb57QDUSCQKCr5uvE7u0/DLO4XrNnPpBAbRE2lv8CsXxZEl/rzLl
	CP4O4XVtJ80fRbzQr8DH6GV377fRy8ZJopOp1awj7lrMz+MgdQS3CYtzQx/goEpSFFSpk9Oqnsy
	12mZwOvz6gZ8xl1m3OWER0LhPlsDIiLLaZnOQBdMk9dH/1q7Hw6ctDz+MzwN5A/4hCJ6W1XpKHb
	Rl3qcF/X0AVn1rLbIPwrIv8mB25weQ7Zc05ea6FO2Qqf4fO3F8sfO9/i55RP+vlrUuuv2RlFFcv
	Td3Tmwq0LeBhIGSQsxK7RIq/52eMYnFywWsvtXR2nbemP3EH7zTp/0x6zIMEzb4IRzH1kIwzoyQ
	/Nho2XgfgUhxcBH2cCLxY+MrDijatlo1bd2gwl5o9L1foaX+sIbg2jLpybkUOw2ajVAcUl
X-Received: by 2002:a05:6214:4b08:b0:8dd:fde8:68c7 with SMTP id 6a1803df08f44-90402c685c0mr4983166d6.30.1783712326120;
        Fri, 10 Jul 2026 12:38:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd87c9500sm48486486d6.46.2026.07.10.12.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 12:38:45 -0700 (PDT)
Date: Fri, 10 Jul 2026 15:38:40 -0400
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
Subject: Re: [PATCH 28/30] mm/vma: use guard clauses in
 can_vma_merge_[before, after]()
Message-ID: <alFKQOJrgiJl0p_t@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <213918ef85ed427d29d0635db6b07b15280d3bb0.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <213918ef85ed427d29d0635db6b07b15280d3bb0.1782735110.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 097AE180009
X-Stat-Signature: 1z7bnr5xgo68dpizzmmq4pijom36uocm
X-HE-Tag: 1783712326-192365
X-HE-Meta: U2FsdGVkX1+93ZQ0wJrClzMwFOOHHShnoeDluh8ufckX92sUqS39Me8mPYXAy9CRHeTydawRpmxgLj0AG6D5ce6BTsazUCe0pFPh72DZHHefso9Ln9XvRG/lTvmG3QSTIIB/Tlk7pITcot+vrmeKRNeSS8R9S7DXPL+0H/dbjWGFXtiej7OcNbSvTVNdazMbem3v0CZl808IAGE0REj9Ud68VKHWGEOkL2uzGAR4era0eoVkl2Njr4AX7oJRf25FGYp0x4npkw6THWPuQXHn/+l7vfRAvlk73N8FNK/KBc8en/ihypzHYe6ijA3YWyk4K/Wxp8vZBqTvDLQB6l8INVNpagzAR/tNVngVRP+mvzFPJ/skpcR4ykERw3yEu+K+nLTl+DYLan/QhfAgKdh/2mCT9WLDP/TxIiZio0vpPFaK2CMcZEgSEIkj9nuLlTrKNfx+D4n3E3P5TYq/OwriuzHpu6XmE/8ek3R1BTf7KSqm0GZKgmX7hup+WKoknaMJPZwTSkgUUw2nFkyRpd7VPgvvDMBa3LmvPQrCDw1vggEv69x6Ma7YkxJ809Pj7wqie/pVLZJ0OeXln1hgCP3to0zdh+plqVUFrGiu5UxY99GFsJwolhINomxE5zhkraD/hsYItdb3ZX4MrxheVh8dzEu/2fyshMDOUfrZpmPSEG0Zrx7xyqGZzCo9P4rn3D2r8RNFzoXtJ3iHWTzMn7lF78VusXsYd4C+2JwdWL9ygzHntspHPRjFLiS48BuwqcuK6QdeLHCwkYZS9cNmlBMDyaPv1PN5moE8kj4mKoO5+ultTGk8kx2MR5NVZFeJ5XPsaScLUKF/L72HSzeBkh2XmB4UUi2BgBuYP6iI4bq5EXrmtqNhliFFbaavhTUOC85A4rPrG80dsafumrxRKsufZKIBAnPn1U0DyUCSeFtTBOy/VLXOWLhJv59g6KdQvYNvdrER7bd9xbrXxklQ+4y
 37AEfFYV
 WP4A9KXTRnIOiQSny5G22xN8z+bVlCXfL/kGBBH2TPRjMa5xrPDd4xZ5qdCLdGH0WJsjiDuPN0MjrqaRHL5MgQdIda7NtfJSHCG17TNpOo5XULctXlm1OtfUR5yuC3ZM6GgaoLmcDWnQgC5gK5v6taMvlO3JyWPzwziJvXnysr2G625A9LJZV3nRdAeJ371MeEI5LMunglfg6SGUemvXN3v8TJvWMUlqmvQzS2ucEGOtno8f3/xv0zyiDlpSc6EH+8x62IcjE2J+eeRxqkb5tRxrzvzCEGK3G69bud08sweZqcaxlhcx6Fez+b6AhIeQFbCPAkSfY4pMdxGoqBAfQ5Xcm5laT6+dsobyo3GKamkqgknlb6oV4DnzQMjMKnSUqljT7B6CWwP1g9e7a9s/SCB3/RAedCW3jKjBLMsy0tlz4Ad8CKyL103JbbLLAxnWCPYGfLasZw+uDEq49ZwRBHfL3diCihB5oNefI4bONuy94jARI6UjH248pxlW62HnlUeXxn1F8mc1sMOojsqpzSQyjZRMlT3kuicvJgf5NuoGFvcUnFTazHOUGXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:39PM +0100, Lorenzo Stoakes wrote:
> Rather than combining a bunch of conditionals in a single expression,
> simplify by inverting the mergeability requirements into guard clauses.
> 
> that is - instead of checking what must be true for the conditions to be
> met, instead check the inverse of the requirements and return false if any
> are true, defaulting to true.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>


