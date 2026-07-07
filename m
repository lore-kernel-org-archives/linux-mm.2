Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76502C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A666B00AD; Tue,  7 Jul 2026 05:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660A36B00AE; Tue,  7 Jul 2026 05:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550A16B00B0; Tue,  7 Jul 2026 05:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A1726B00AD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:08:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A872E1C7F3A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:08:07 +0000 (UTC)
X-FDA: 84961403814.15.B1ECC7B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 86242100002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:08:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0QmhPMcU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4+urEO7G;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=B0UgCNFj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="0reR7q/r";
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783415285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHv4kahBeNrmd8/qDWoJFBecT8vqZhiAuIMjLHee1tY=;
	b=YotL2giia9RIQOw8pWPDEzL0gAV5TCTY7rtVe7B2Vfjjtb6f9YOl82OeDoO0Lw8DyDuGhc
	sGzdG//qngLDlJe7/2fGTr3T0ANiTValVa4kF5eBD94an2oDHSvK4DN11Bk9ALXblpi3sO
	LQ6uYQ9xGv556v7uayAvxeOIjMOIRrY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0QmhPMcU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4+urEO7G;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=B0UgCNFj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="0reR7q/r";
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783415285;
	b=jC2vqDhNkkZRvdNW4zed5vpYiCpRNtVrmSFjoRtFnYv+Gk9xrheXYuUDtI/XrXvN3HlLcm
	/jsioJIQlnLBBMocaurhHH1pEyKH0l/xsT+6FS6L28YZvsdfurAhXpQ29MHugwaedRJWUr
	RI0AquwPliCttB+FtyiiZYa3/KKT0LE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D9D39758AB;
	Tue,  7 Jul 2026 09:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783415284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aHv4kahBeNrmd8/qDWoJFBecT8vqZhiAuIMjLHee1tY=;
	b=0QmhPMcUlwUDUqtm6987poHzhjQ8wXsPRNp0+n13eKN3ld5nfEJgqx9qWJ0BO2OcvPyihX
	Y5LZcYYUizapk2mYXJA2Noo30bt2T7tP0lLiSJJdfrwRsfq9FO1jV49favkoCXnL2k0e8g
	52OmzxBlNN+PCDx+4Z//UQDjp03W0zw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783415284;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aHv4kahBeNrmd8/qDWoJFBecT8vqZhiAuIMjLHee1tY=;
	b=4+urEO7GVf92z+DsHyXVZab1QdBA96SV/AA0Osw+aQt51NWZV2NXLRds473Iu1ASwtgwGI
	yay7jI/HYfqk7DCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783415283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aHv4kahBeNrmd8/qDWoJFBecT8vqZhiAuIMjLHee1tY=;
	b=B0UgCNFjqqBLJx83yWDQjZgu5HLThcnZsNyKZs2umLaATtGQ2G6EvKRzMDn8C17Sq8DWVc
	m6giXIX97v+3xoGls6zmGqh2aioRQdV+6LD0KU4hPkzZ4yRw5NRnIFunKM8sMsHBIWjhTB
	LAE83bdJ0+M130kHjXQ4LTSK8gE+6Ys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783415283;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aHv4kahBeNrmd8/qDWoJFBecT8vqZhiAuIMjLHee1tY=;
	b=0reR7q/r1BjXy9ySDjT5PUxjfbC7i7JijwrJKygtr6MhGaL8F22+rXsYWeATnSPJH/xhI7
	yq0sfLIvmjkR5iDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F97D779AE;
	Tue,  7 Jul 2026 09:08:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rPc4CPDBTGo6LAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 07 Jul 2026 09:08:00 +0000
Date: Tue, 7 Jul 2026 10:07:58 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: wangtao <tao.wangtao@honor.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"willy@infradead.org" <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, 
	"kees@kernel.org" <kees@kernel.org>, "luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"ljs@kernel.org" <ljs@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
	"liam@infradead.org" <liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>, 
	"riel@surriel.com" <riel@surriel.com>, "harry@kernel.org" <harry@kernel.org>, 
	"jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, 
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org" <baohua@kernel.org>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "muchun.song@linux.dev" <muchun.song@linux.dev>, 
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, 
	"rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>, 
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"apopple@nvidia.com" <apopple@nvidia.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>, 
	wangzicheng <wangzicheng@honor.com>
Subject: Re: [RFC PATCH v2 00/13] mm: rework anon_vma and remove
 anon_vma_chain
Message-ID: <aky_oySdi6YhtJWW@pedro-suse.lan>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
 <08c001ab-320f-4676-830b-8e4ba6a05dee@kernel.org>
 <b00a03d62c53430ca22b3f3c5e5327b5@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b00a03d62c53430ca22b3f3c5e5327b5@honor.com>
X-Stat-Signature: bsrwdaxhw8fqgb14fh5qyp4p51nka7q3
X-Rspamd-Queue-Id: 86242100002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783415285-782513
X-HE-Meta: U2FsdGVkX190pulOcPx/T9GfVYmweJp7igAUA+T+qFCdLoVON05KwhsXR3JDf/AUVBRPlUbi1x9pXDNxqJmgobib9i00VFkljuURnruqS+uMVcqwoy9t7KMVquylAak94bGzhOl5LvXKSubXIj7zMwzlY055iqNLtPpYejF9IyNtiI8Okv/I0DV8cu8pKPMNpwy8C4LEtlKmgRSm4d3m+UXgNOzLkLMBte48zfImdB971xN3gQhHaGBmm3r25IVUUrUDZ44erDScBIQVaYH3VfXBbEDHW1CeS+ils2oAVM0EClxYuuRJXCHEZRZHSXtZ89+IvF+q+C0k6eLizzuud40bApwEdUGCcFqzEpPtVOK+SbWyAKcoem464XfLlemjiT/PWxZ7iwaJIQWoTWdiDka4hYwX7DSw/3sXAYUYEuRY+LCyEnvESvnHCkWcm0Mkd15DQ0ckdC0SjhZZ+uYrNXJxVezTPRj0m+AXa5Mx4JvwC5ROgkikkN/EVzSrpKi6GO1IVij+T41YPoi0O9/Dw9XmyzhL+0lzUe0x3xIP0AUBui9V8hine+g4iXE3+x0t44fZuyQ/xvvIWM+Yj2/0cABL2ZXJV5+c4PEjEc0LCbXto253vpmSfCufsMiAGp7heTbEN2vnVd8Z+/aARa58P1eNYqoBwIWSsZM6sFnBL2Zq2gViGbkS40sNWIEBEX/PknwK3jyC6b9nkuh5oiHAUhT3PPksx3FOu6cL0WeMv+9tpVv9j/W3ZcOZxvsQLu0j9bFnAV1I6FQt5+RCMk8D6mplIf0wSGY2L1rOeak0ITp3IukJHhhPts3eVPBLf+EDm8tAsYZgfAiPqGCLrJSdUii/rqZVxqjCvm5rs4yqyAB5yvESZVHhiP5CrwyF3gqaoqVBEgEfJyagXuIc2VHl59xi4ITrcrpplvxloyIxMnsF6pom+ONNuOVYuxRv9cTwK2Mhzh9Yh2mvXEYpyzG
 kGTqmLxV
 B/7XtMrWInY1Qj5L00l765m/2tyE8uf04Os5jfnz0gakLnXUU77pQCQhmejjVDqBSzg1X0ecqkg5ON/pCjPiD9uc/F0b+WnQGfWN1sk+lX36+q7cPR2g+xeIUA3dEkOvBNX+5lVjDkgl9ukwd5j2hXox/fDO3q9oscB237/hH4TRm/hsWYBLvp1FbVgO/ukCHxSAMit8l0OwYac1BH3nZkEPW3SkNqC1Cen4498ix/GxHjvovWBpa3rpoAD4cRCap7zR5b5znezseVT0duEGaDwWya9/Ofi7hmVsxPQYOMM65nugaQ7RLLrqlW18CYflblbvi15fcbFJG/PsEmGFpfeFI0PyQVtIb0HSyV8mPQTeVrzKHsCLKfH9hJsJkmQ9evFFpz/e5qrAldOWhHOq/cXN0PFKwW9tllMBhgPeAJJ1Ee52wyeroqikWDWwLy0Z7pLvc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 08:21:24AM +0000, wangtao wrote:
> > 
> > On 7/7/26 08:32, tao wrote:
> > > Hi all,
> > >
> > > Since v1 was relatively complex and difficult to extend, this version
> > > adopts a simpler anon_vma implementation approach.
> > 
> > I really hate to repeat myself, but you seemed to have missed my main point
> > [1]
> > 
> I saw it, and I’ve waited for a while as well.

what?

A good part of software engineering (and FOSS in general) is collaboration.
People have their own work responsibilities & personal lives. If you had
questions, you could've raised them on-list or directly to Lorenzo and
could've helped him drive it forward (which he is, and he's posting careful
precursor patches).

> 
> If there are technical issues, please point them out directly.
> Or is this simply how technical discussions are usually conducted in the Linux community or the mm subsystem?

There is no technical discussion to be had. Lorenzo is doing a large,
careful rework of anon rmap (and rmap in general). You don't get to override
his work because you decided to ignore the "community outreach and
collaboration" step.

-- 
Pedro

