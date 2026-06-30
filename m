Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41FE8C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5FDF6B00BF; Tue, 30 Jun 2026 12:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36B86B00C1; Tue, 30 Jun 2026 12:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F416B00C5; Tue, 30 Jun 2026 12:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 953DF6B00BF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:17:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E783167976
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:17:01 +0000 (UTC)
X-FDA: 84937083042.05.7914A1B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id CDD42180017
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:16:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sJ3ZcnD0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ez7nu8R1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sJ3ZcnD0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ez7nu8R1;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782836219;
	b=GQMNSLlq3tqRNmFLqiMBYDcXgB67YXiAmSr+MMZVEE2+HgDMmbN1GLsSn9/QFZnZbM01r9
	+6g9zo6Cp1HKsgmZuYP9qjzJpRBpKq6N0c9xzyVBJnjLgggtYvcnYkt0BJTfS0slvhqtTF
	7DwPbIn3ci4ai3yMc7+xiBUa1pW4xdk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782836219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJoAvYhq93KYCzjaxFWoitVi4doOxRa03N6I4a85wxg=;
	b=i9EUjInbtg2oWjFBHKUA10glW8vQK6JPy9vJtRNxw/+g3xKrwysjGWK+ml3hc6bEQfkEPj
	TLvisrWGPKRZzhGOmchyeynwnkAPofTUI7vWof9hyQDb6+ZYPLxG2aajMBuKSrqXdYxcwv
	NRLr+nBXwrFDC1XHGqKLc3zNI17wkY0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sJ3ZcnD0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ez7nu8R1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sJ3ZcnD0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Ez7nu8R1;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 75AC3759EE;
	Tue, 30 Jun 2026 16:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782836217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tJoAvYhq93KYCzjaxFWoitVi4doOxRa03N6I4a85wxg=;
	b=sJ3ZcnD04vfuWg15fYumkN4Z5BLAEG5OnvVU6Bka7MAyaat5LqwR9IVSPmnXInsXtwqN51
	b89OFcITXKZzIiyvIGZWoIgArrvUYfzlcEon6pgA6x1Dw72IWcn2X4CKeyscQC3mVuG/VG
	uH288u/SS5kzDZxzCA+LJ7BF9msmT1k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782836217;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tJoAvYhq93KYCzjaxFWoitVi4doOxRa03N6I4a85wxg=;
	b=Ez7nu8R11lxDQwLyZgdyYikD5oOap9w7bVhI6cDXjd5zwHEzIYIEVh0Txv2+5yqC2aktsj
	tJS7DQ6Lv6+a+tAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782836217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tJoAvYhq93KYCzjaxFWoitVi4doOxRa03N6I4a85wxg=;
	b=sJ3ZcnD04vfuWg15fYumkN4Z5BLAEG5OnvVU6Bka7MAyaat5LqwR9IVSPmnXInsXtwqN51
	b89OFcITXKZzIiyvIGZWoIgArrvUYfzlcEon6pgA6x1Dw72IWcn2X4CKeyscQC3mVuG/VG
	uH288u/SS5kzDZxzCA+LJ7BF9msmT1k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782836217;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tJoAvYhq93KYCzjaxFWoitVi4doOxRa03N6I4a85wxg=;
	b=Ez7nu8R11lxDQwLyZgdyYikD5oOap9w7bVhI6cDXjd5zwHEzIYIEVh0Txv2+5yqC2aktsj
	tJS7DQ6Lv6+a+tAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F01F6779A8;
	Tue, 30 Jun 2026 16:16:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KG5RN/TrQ2rNawAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 16:16:52 +0000
Date: Tue, 30 Jun 2026 17:16:51 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 05/30] mm/rmap: update mm/interval_tree.c comments
Message-ID: <akPrTU96BwQJoygw@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80d482a927b2e9862487b812e0ab48ebc1289a70.1782735110.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CDD42180017
X-Rspam-User: 
X-Stat-Signature: uh3uwduoxibg7y1d17t5h8t67ykydu4x
X-HE-Tag: 1782836218-429135
X-HE-Meta: U2FsdGVkX18hzasswzdcdehpBKLJJQaFBGDS5KMz6XyR+ygIO7PWzgkGa5mZ61DpCN0XJY54nLsirWSu//ke8lffXUs8+8OE9EYEvSTAm56AfDrCSOm1isTFNqUaUm823xOv+PDEjf3NUtBu6s85/SHM7nvCBCr/LgUMxoCr2AnbhueGdQSSYxSHtz4avOivIkgvBApkdGb/sEAv6enk+yl51Lr90kDD5Qo22wTnWD3xWJDOREjOrzm1bIsL0pEFkkM7tcdCv0Elo9AGIwaUHDjKqoBGjjJ666c3sjJvqYWDvNKyqitNqG/b40z2LRLjTd8eEf4rUP3DgPCd/fZqgq5YBQ0gd7C0Ew+wmXzmcf2ErVZAP/n3G3CDj3iPS0JT8zfZrZSdVVTE8OnwM/uYTHCdUq8igI28hb0NGKjvo12GGf1o9iunWPY7ljPaT7hJVs7VR4NLyKilFOw4oVTH6133/8dFrUco/DC4fYSbDernT0VaOHWI0y8PZcR/ljidun5w85WV/Cmsnnm7XCr8JuABKi6yK+959B3EotOVxzz7lnlUn+GUErX5Bdpj+dG47+A2lu2cLrGUdT1WmhmW/VAvEdwZ1+7BUWUn0+0/uf2/n2tYoe3CCc758Jo6K/9bNDoY8o0ZwUSmtf+lkBRNJQFFZx2U2uRzA+VAce9aA2Cdqk93/0qPiKEpAEqxn95ZekkmvALQipW6au4a7hJzyHO/b+48gTJQMRnAQ/rl4GSMq1k5kUTUdCKqxbGXpR++JyGISS4t98dnJq6+PSA7mxEAQKS/ZmtHm8B4LfP2eyueTDL6pA65AdcW8TvtvAVEvj0vvcKDOYWIwnLH8A09A/iO7dow/rUjBUHnzp0yi/cr4p2SmoeSGeC83xj/H64fmw5zyrAnhGbdKjaBXBwrEWQ36sW6i3KVw602aTcJVA+C4jFjJFvrP9rd4h/eQWRT4E15hgGsRZ/mju+zPe7
 thoDd8Wj
 GOS24xfac5DqeHjCFQOZakIy5Onp5lESzHG3yy07IjzTPNlUuzWVJ/zRm8pwq4sazo2aheM7SQMn3csBfO++rYcqfdYkwGlrVDRJjoDqq66XFdpVQGz9WVgtfFyaLkRvKiazaA+u+9SrCOYLSmZxrH6Ty0yPaIOQRLckxY6BuxLZZbsto2S6Vf8leC4Bjg9JQCPZf13OcIgdIotShFcUZalYlF7wPK4UZPmXOf9oRSoBywITxsbQLIePAfjB3+HebUNq+t0Ua0OjhoeSpzFbXJeOjgSbgxAb6CcoyteAiNwhuHCu8xjxbkCEPs4paY8XdWpL65Q6MpMPFuPI3m8LeR95W8Dd3dOkqK27hrGkxoX9JiJKUzegGQeZJWOGNiqqPeSy4zt47Rf50SZFBJwqANUgR9hhNHsVmYtSD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:16PM +0100, Lorenzo Stoakes wrote:
> Update the file comment to clarify that both file-backed and anonymous
> interval trees are provided, referencing the relevant data types for
> clarity.
> 
> Also add comments to indicate which parts of the file apply to each.
> 
> While we're here, convert the VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA().
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

This is fine for now, but I'm wondering if it doesn't make sense to, in the
long term, have:

mm/rmap.c - common rmap mechanisms
mm/anon_rmap.c - anon rmap gunk
mm/file_rmap.c - file rmap gunk

or even something like mm/rmap/{core,anon,file,ksm??}.c

While working on my file rmap patches I noticed there's so much stuff just
splurged all over rmap.c - interval_tree.c - fs.h - fs/inode.c.
It's a little silly.

-- 
Pedro

