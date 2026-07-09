Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AEACC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 15:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC276B0095; Thu,  9 Jul 2026 11:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683A76B0098; Thu,  9 Jul 2026 11:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54CFF6B0099; Thu,  9 Jul 2026 11:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 306B76B0095
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:49:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BEFFDC0EEC
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:49:28 +0000 (UTC)
X-FDA: 84969672816.20.5D0BF64
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id F367D40009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:49:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cG5rG9zF;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783612167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hryUWYzOZzjuIh9gJx+Hzg+n+E360+tJZh4R7BZGeLA=;
	b=Tw0KfAYog5jVEj3181f5a7fdQlUbeTj/pxdiTgZDlIvPuaXPUVjNHQ9XcPQbSq0HIMvAUt
	u9IWRwAmiSbYYC3RHjhZn/+H5tQjzSPc1wrOncEYHIjgFwQ6xjy5g5X0qI9ZlqC5Tf4C1R
	23ujBxjN0d9vBtAV2anuEneEEmgPjHs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cG5rG9zF;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783612167;
	b=I0o4Wxfa0Ek10v2Y2vBVsxx4uFeypFGMvctsTpU8G8x51l+ESZL/06PDPd/VG5/ChfbZnU
	nXze4Cqmihv/indjiyIfRb2XOpeLLMIMf2GhsG5kryGIMrY6ABcN9gcGB/1QbXZfnkjChA
	mz+G3FCKzaqkkuPhVwfaQWURJVGhuNk=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8f1a8e914a9so450516d6.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 08:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783612166; x=1784216966; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hryUWYzOZzjuIh9gJx+Hzg+n+E360+tJZh4R7BZGeLA=;
        b=cG5rG9zFer3CqcxMEA8CMpT2mXD8TCk91J9vgP7ZHzER8Awi1dD8KGAaVR2NRoy6PV
         yV3BfrpcX7bD1Re3fBscgqvkhYxVaUQ57oK85XxaxrdY/TtUQtuH4w4eiygHKJq1+dfv
         J1CKPA+Xz0MTQAYc0A09COM0R7Je/ykHw/X7OPZn5nsIxVVyLIDfceefak66yb+GHueF
         mFmHyLsyNqXDd7X0iXoBk7HV5cLIZq2t4hwJeiaFnbKbkeJVrYLpH5Y9osXf/bsMB6ju
         kjZOhPuC2vN6RE0m/rEMUftspLWRJJzv9/r28dtrchEX/ZTku9nHnxC+OMHOAccaUqgY
         uJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783612166; x=1784216966;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hryUWYzOZzjuIh9gJx+Hzg+n+E360+tJZh4R7BZGeLA=;
        b=NSth1Gzxu9mFDdXImpGYX3nkjkbdlEx1BN+0aZayDO6hY+VSm7fivbID6K0cowQTon
         iudJhqYaUaUefTTnlfh1FKokBoz4Mga9HiEck1252Njmbpiz9/pYoUmmQy6s5iuPMMLC
         wWw18tO10724OT2p/6hetgez3lR1vXFefZVo/GTYQRVj75PByFNVsyNVJJMlGHTq13rp
         FV+hFwQ0XoXQMxKCv+3vpju9zPs+fpcENsEziewjFp1k3t4fzBYtZkIO3h3a8nVgarW2
         UuI68Mr9nmraSUnQsliJUoKYxT5NQ4kPxP5epYH1H3lRS0qlHs7l6HTdXLJnre4FKpzy
         7Iqw==
X-Forwarded-Encrypted: i=1; AHgh+RoPrkblGXI3hpud00WyK2Z9rMVaeIYrJWFSI7a8tZPkIapBud9zAqzAawtVxl/3Aa+FGRCsnWytcQ==@kvack.org
X-Gm-Message-State: AOJu0Yzt2rqpV04HADOTfLF3pq8bU30wH451xRZ+Khrgflq4YmvZGa68
	1B1SRTZ/nsLhLX63j6nEywEMT7ZbN8YdOTm9mHx3ngVt0K7ek0lys5kVe95O0BFKaY0=
X-Gm-Gg: AfdE7clF2HxISm+1DTA5BhgwQJHKb3M/UTAfi9gLRQXne7e+Zovl8ATEU4RZcClerWb
	ArKkaZzAg+FN5Mt9iY0klx2ONKQPFqHq+S1tPPB2QZegqCEZdNx2rh2IRjmcac+4sZOOizZTzzL
	+lVrp4be6NefDBYuO/mGDpdlTunpEA2Ncr+19s8zadoECDJUaNLUymFN//Kpwg6Ld4tTtM1rtC0
	wOd3yiAKxrx0FyjfKeC8Z/3OG1MHdpWW0ynG2sNepfeTMfbpG1HO3Z2YN6l4JF/cV8DKYhfq/AL
	m3bhv+j4UsSUetyN4bij5R2lkPF4SLWnTX6vQtr57+fTQNXgzgLybV6Jxv/MfPsK4GdNfqi2TB9
	cPlaYFGV/4OYdlxuSnf49Tens43TG+5DqwcAwnoy6LCREDQlRw7vF4chZZFo/KZ5OKMCbY0isgL
	XixnRPLm1nDLNGoAWVR16bVn1k1tBirxqK8yhLXk2OAVzyGHeRqR2r/24NYPssLdNe7BRG
X-Received: by 2002:ad4:5c8a:0:b0:8cc:2a92:48e4 with SMTP id 6a1803df08f44-8fec217b8bfmr87997286d6.32.1783612165998;
        Thu, 09 Jul 2026 08:49:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1d9f6sm20164456d6.23.2026.07.09.08.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:49:24 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:49:18 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	damon@lists.linux.dev, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 17/30] mm: prefer vma_[start,end]_pgoff() to
 vma->vm_pgoff in kernel/
Message-ID: <ak_C_o2ehS17Q5HV@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <ea87349d63205bf4c26ea79854f179a9bf8cfb0b.1782735110.git.ljs@kernel.org>
 <akZCg73F-oGzDp1a@pedro-suse.lan>
 <akZGqclqQ6gS12Vv@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZGqclqQ6gS12Vv@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F367D40009
X-Stat-Signature: i8brjg6idebnusqt8n7yee453mmdkwdn
X-HE-Tag: 1783612166-504340
X-HE-Meta: U2FsdGVkX191dhYph+m6MUYipvquDgg9O8bmP3iM/jE6tFr+P4XnusalnRViT0bSq9/LW8+2J/bgGTQgNRjA/GWUTEWfYJd5TnTI4fxrk6OaMhnH4bIaDMT3/nJ6mM0ZytbKikIjZKdkfDjA1E0vrzxkmI7aJ4uG+UUO0WwPtGoS5k6WTFsQhyZ3TDXhx5E2N7aujZaLDFVsnIKpYh+vfmHYRxxXTQANSEwKX6NjOJu1k7JkTs2GnYZEKnmP4USW90T7+c3oL8O3nYMoP9jDt6vy+SMEtkDSdJeNcujhykdP/CFQKea3LXVqV6qdgc/2pryFTcW4KIfcuN0p3NF9AZZXFuVF7O6bUkrKuIs0sUVYaBlROoFls7qTgczr4Cb/5OteC4JUDRry04sZb014NmyM+uS96ZwL1yUkBaKlyin+WCEvFV5zh8wL31b298RIXycqfkkZjQ69zIT5nkTrLCQsSFJSr7UWRI7JlGefabjqaVfFWbMPxdP6KRbVRZX1HExemQxfczkIV6UAalJPXlp1F8n+8BQqH0eHQcJu1LFPaX3Fi5UUFYD+Lu51NMCP+eAnGiXqdtQahrElXzs+kieL28Etv7xEsQCGrI7iO4K2+Cp54Gj44vocY2DsJk5MN06zI9rs68OE4cuI3haZoljCKDmEQBqmb1bvgB8uxSBnYDQq5HWR90oB/Md5+bRxlHlBYmak2tJfqbr5s92WtNbXyYpqziLRYzIBGR93trJdiX89aGNxO9trakvGWjgbslJDAWu/k/p/FLok1qRUaJ0yx0sLl/AqXdVeXgj2oPGNivgEsESicmO1KgAniGV+rUWijUMojW0EJgYgT8QGeLTyQO5hS38r/HTSmsO6/oJiysgSNsxAO95OCwOzPdLk6OapUGut0SasYlJRQKqmTWk2ip9Rx1xB6cdhsdy7YL5N+lcqK0VHS80rmQG6ve3YcTZal/7vZirXAhbzCP7
 O6sDLRfm
 QYUKgHK2DSnN31DLZdMEMJsMVmJ98CRJgYoCVgGONFX7yZuprYKYEdOkYgM/puWi5Tc26nFrYtwvCuJsie6ySsi0kMxqRib/8xAVVOgXQiTl3jzyUovgBnNdV2UULeUFTlheMAmp+05pXPmV/CM2g9D0Dt3M5o36QS1jahaNPoUopslgpnHU+kGzZrC3z1oReXXQSpY89voRZkxz5rEaBFH7+7VG1/jeXEKjM3mZf8pLC0ZkQv9kxBYQR+C/B9hnCzP7LFOfPqhgS3+dxd7XKTCZi2PWenSHnWeMBD1ZCf6Vzv+Wrcu7RjCXHzQCc2HTA5XSqMBuyE44Kg7nD7hgflKFycUpdjGoYxn+sgFzA4AHim8DKRquHHbXeyTClTcGg3x4CxoU/I0Eefbe2IzuElJgmCdhwj1TZJNXfHrrVeLZyw6+udDhmxUjtfHnIn89vslqzKhBpD26GnaJB6Qg9cc4amFI9HhZrBr4g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 12:30:59PM +0100, Lorenzo Stoakes wrote:
> 
...
> static inline unsigned long vma_offset(const struct vm_area_struct *vma,
> 				       const unsigned long address)
> {
> 	/* Retains page offset and tags. */
> 	return address - vma->vm_start;
> }
> 
...
> And I'm not sure it's really all that useful. Perhaps retaining vma_offset()
> would be though.
> 

Silly question:

   What's the purpose of retaining tags in a non-address value?

That sounds like there's fragility just waiting to be broken.

(I presume you are talking about things like ARM MTE and such, right?)

> This is one that I think makes more sense.
> 
> But in general, I'd rather hold off from yet more churn here.
> 
> I'm making these changes to establish a basis for virtual page offsets
> introduced in [0], rather than just cleaning up in general.
> 

I agree with this.  If the refactors here suddenly have to think about
corner cases on things like tags, that's better resolved separately.

~Gregory

