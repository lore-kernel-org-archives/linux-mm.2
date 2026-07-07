Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E7AC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169066B009D; Tue,  7 Jul 2026 12:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119466B009E; Tue,  7 Jul 2026 12:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008686B009F; Tue,  7 Jul 2026 12:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D07BF6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:19:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 151FE1A04CA
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:19:22 +0000 (UTC)
X-FDA: 84962490564.03.5B90C16
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3E43312000F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:19:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dVzTgTLv;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783441160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shTm78OzX8lamx3AIG2aka+O0fr6RJu853HQxce+7Rc=;
	b=HHb1WW/RI1y+ezrHYVFhQvPFF25SEPthDHPpX9DYYfm9Wl0AU9hQnmKutJxH0z3BPlh8OY
	wzFuye2qSR+lM2LMi48BYpi8pRAxhxWVdzBHTksHpmCRDOy5lLv+6Os39m+umGu3LcGfn4
	N2HltA8Rxik53nLpuY6hsEKQ9LFzOig=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dVzTgTLv;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783441160;
	b=Re6T0RLATsAt2CxQLB16pZkvSEBmF8uZ/+FJBjaUSGBcHzam8egcuDNY8Ks0mkxuXhzRIU
	zFo7onlef1AeLDxqYwu80PWBPRlsW0Lntrcu6TAL4jKLAM5YljR84uywmNWJ4RsWeCsW6B
	PNBjgVcgySVY0nRmnrkw5TD32YzrIjI=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c149c5722so6807801cf.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 09:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783441159; x=1784045959; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=shTm78OzX8lamx3AIG2aka+O0fr6RJu853HQxce+7Rc=;
        b=dVzTgTLvH7BmosIUztSNg0HJXJX1LcXJhPwOQkUZTbvlolWkkUpoA7eGvbAGhho406
         YiI5Dq5qdBTpLqHkms/EQ4T15zWsR+sgEBV1rCxNtThVzx3y7QQJ0Y8nmYHOL9WaO8Nf
         jrAk4fhKGr6zHiAv4FZb6oiU1J4A6yEjFUf3vTAeUd+Tv3Sn97SCM2X8VBP5Q/Z+xBPr
         ZtIAYck7NBFQ/mpO8rcs7iOb8tAICjtqi26bKTM8EZ/CKM5dqhxsDKBkAzLF4sLXIWdz
         VwadsFSAUGZ74Ijx1DZjPL93Q0Ajsf9qm1yw5K+4H29D+YMYKU9Zt7UAg4NqFLEocbQZ
         dTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783441159; x=1784045959;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=shTm78OzX8lamx3AIG2aka+O0fr6RJu853HQxce+7Rc=;
        b=VfZumQ0lRYcWRL5Ebbz7LU82ycjRw7w3VREV5Mz8z85inelAbjlkgKJ26LXtGp1qMP
         DbPptwOjcHyW0bIYubb4duOFKZsk3nvue8neeclOM2kEYyIVaSVoJtewPdcUuxWref6P
         Zn20+uoWvnybxTlFO083dNWOXgG8C97ReLzTyP27jWCfkV4TaKflVwyZujQULgwQGbQK
         0a10A3vDqM2YAKD9H01lj4kLQVd4j7MRYq0oA7/mlAF8RqVvaywdcmkDJSR6UoEwhSx7
         OltvVhZYXG7ahQNrpcq1jOSbUjR9+EXBMlg0XbZLxTlUp0PuZkskgnkHs/ifLfQjp6Jc
         FEOg==
X-Forwarded-Encrypted: i=1; AHgh+RpYfOEcqbHNuPn4zY1T098LZE64bLkoBCmROabMTLU3xVStQ+lRwxwEmdO1nmoX+XMhZYkslEsFBw==@kvack.org
X-Gm-Message-State: AOJu0YxmZTRAibsJYOyvyrYTqzUpnOfqVkN7lJSEItQWfkYVIW5eyZel
	KH6OpWiSXlGvW9+0S6a23BF2v6z+afOF0XRL4zFG/gqBVdS+FVthTDFL9533zg7Y7Xs=
X-Gm-Gg: AfdE7ck7/lFhhxT+fKwiFBzPyL5UIYNEQNOquSHB0+U+95aP5JiN5cTnQBnQUH4I4SX
	4y1N9jiaV8cLGYKqWU1pvJPSrfKrOIXs3A+3mGKGEyfDYmnddRlx6V3dYFsop6ML0O6B7nrJOiW
	vlIqOrm5xkPZDVbbR5hEAil7SbOQvydgVpJ34y3XwAdpkvebhRuB3IDcNHP5yIz47O3erFjUVDp
	VS+1byH9ZIsq07zaf1TADrnLrPz2KKKHYKf5p48YW3tbdQT+N1wat5N1gEYGDlGvE705vWJ7DJK
	5qU/sXqa/TxtXtAmF8CUiegROXocSf2fRBanbOarW9Z57U+Ut/vlxy3XQ2OkzsbQUWmlD/iBLN0
	/E4/NCwL6a9woyp2RnluxlpwT8Sa5j1uX5WUulGAbIQJEPsfxSiM08U2puMwxy4l2qya2t+kF0k
	oJO0Kl6us5lainRgQf1TPeDAxI2B+b5DsvG72yjgRSrm6bjxk+4b/5U1/FppTF+6Nq19EN
X-Received: by 2002:a05:622a:124e:b0:51c:1f35:4638 with SMTP id d75a77b69052e-51c7a7515famr34037661cf.21.1783441158809;
        Tue, 07 Jul 2026 09:19:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c41da510dsm114014641cf.22.2026.07.07.09.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 09:19:18 -0700 (PDT)
Date: Tue, 7 Jul 2026 12:19:13 -0400
From: Gregory Price <gourry@gourry.net>
To: wangtao <tao.wangtao@honor.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"sj@kernel.org" <sj@kernel.org>,
	"kees@kernel.org" <kees@kernel.org>,
	"luizcap@redhat.com" <luizcap@redhat.com>,
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"ljs@kernel.org" <ljs@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"liam@infradead.org" <liam@infradead.org>,
	"vbabka@kernel.org" <vbabka@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>,
	"riel@surriel.com" <riel@surriel.com>,
	"harry@kernel.org" <harry@kernel.org>,
	"jannh@google.com" <jannh@google.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"npache@redhat.com" <npache@redhat.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"dev.jain@arm.com" <dev.jain@arm.com>,
	"baohua@kernel.org" <baohua@kernel.org>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>,
	"xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"muchun.song@linux.dev" <muchun.song@linux.dev>,
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>,
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
	"rakie.kim@sk.com" <rakie.kim@sk.com>,
	"byungchul@sk.com" <byungchul@sk.com>,
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"apopple@nvidia.com" <apopple@nvidia.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"damon@lists.linux.dev" <damon@lists.linux.dev>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
	"ryncsn@gmail.com" <ryncsn@gmail.com>,
	"jparsana@google.com" <jparsana@google.com>,
	"dvander@google.com" <dvander@google.com>,
	zhangji <zhangji1@honor.com>, wangzicheng <wangzicheng@honor.com>
Subject: Re: [RFC PATCH v2 00/13] mm: rework anon_vma and remove
 anon_vma_chain
Message-ID: <ak0nAXzlwnQ-zPkN@gourry-fedora-PF4VCD3F>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
 <08c001ab-320f-4676-830b-8e4ba6a05dee@kernel.org>
 <b00a03d62c53430ca22b3f3c5e5327b5@honor.com>
 <0e8e5a28-1111-4b81-b04f-b81e749eb3dd@kernel.org>
 <f640c89d9722462098bf1b7a0a6854c2@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f640c89d9722462098bf1b7a0a6854c2@honor.com>
X-Rspamd-Queue-Id: 3E43312000F
X-Stat-Signature: zgptx98ai3q68zjckukwffekhyzje6dz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783441160-719684
X-HE-Meta: U2FsdGVkX182gWTdD/PPhEu1sL/rrO8SlF/tY3PckIqcnepmoludQnZuTb4VtdsXHltT0IP6Lgy87TC9f/uRsRqMusWAkPqrL1s/9XbdwSqJdObcSxEvnEPowizx8s0RogGIAEA80QI+cBcGR+hkaCVY9cYOFHjb576112NmSNIgiVjz6ZQa7/TxH2GpXnFElgB2kS/pV4uI3ipk+A3H/e6KV6431EAumwfDmudGwm6colsQHxj2Ht4FEIdCQq9B1hCkMUusyNDT9/TzmIstYpgsh2ysakWROO8jwOf3nm4EzvTaqKolGGXYLV08ZGW8aIcqDo/Tf8Wc9jqPurOW3mZZcHaXEZN69DKZn4gAE2i/JoHius1I6vRKxnoexeqWHtuN6nANp2WKjRxLytkhnE83hLfx+02b6j+vJR2tPYadHk8D7B+EKcGMQNGjSEajE5jaCF7SyiZdycClPrYCcjp58TYcUc/1QSxclsmAgFhyfgX9gUyqxrqO5nqn14TmT8cIrDfsDUOsHu100duQBHOqnLepwyWVZgijVoK27lp2UGCc7O7k77221brPmsMtkmwP9pkqiTxdJSyru176HE2g+OxzxnBXEmAA6t0WJ75kOzbaLEcU00MGHp3fIaYfgo+M8uFnuLcZZrDfZ9nrVIr+c5Fesxk0XbZl2qT6kfyOntBSRcz90eKSAlxccUBwPCgGd3rC61Meixfo4cwgQh73k3xtWed1EFhQcIUZpHSBcv2/a42ZRHcN7FRQNWUgAGN1uIFnARSfsMMFnoiXGmgjqNlqkhRz5R+BsLybxtPNQHVUSNlfFVwdXyA1jZ2SPTnX4eCG7G3Z5o9a56ysj8yH/qugzOLo0XPa02UjOcOqkuyTCNrw5TCFuNxVYpOd2aQbkDTAAiFjwxa3YlDOmiGTSj70rON3qPow2TdC8s0d3qIPjWhG8A/VWjtOoUXaTdDZpVERH7QPg7afsjJ
 EIdOCoFH
 g4MIz0FqiGV1o9Ze+sdVkfv8aLGL1Bh+y+U5aP4l9qVkJdB1vZwc1aHUqBjdYLzrkT8aLBcG4qbW6lyPBCgr7UwLsFSKKYMZX9JLjWo9VZxOHh9krnH173cLOHt4fnPhYYmj5asCttiUwjrJgxMyA4i7Wc6PcqLV4gz6VVNnvVBB4DC6tcF6AlGRv9R6h4FtVrSm5SFKTZiCACYL+ayxhdjlJPpoWIzM3Fs1KgEoDMPZ0fVyoe93YHBrYzs/pvtBc/6M0ysR2PL0z7TXSbibNyWbxpWqyWnGNF9sJrSg+Cckh/2Iy/Bzs+tVQmWhsMq7978h32K3KE4JuB2hd9ywZ91JQt3EdUlq1+bwUUVXCr5dgeELrB1TvV3Il63FV/dOoHv1XgVL+yFqIthIOGDmhP4dvUr/5bZ4sqUUFHlFJLCIa4uXQ6fGAcNdexOyN1CLgOoe8UyZC2aNO2wh66doN1PFEkqVkTjA5St3uv4n2SjaLfukqN//MEvgXmPV1Gm0PbGVT+bHH+ONKasaTFHihCcqVA2xZxPII7fuiK5l67bD1Qz5IJf0aQm/D+JSCm14x4dns
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 09:20:24AM +0000, wangtao wrote:
> > >
> > > If there are technical issues, please point them out directly.
> > > Or is this simply how technical discussions are usually conducted in the
> > Linux community or the mm subsystem?
> > 
> > I suggest you go back and read my email.
> 
> At first, I thought I was the only one who found anon_vma hard to understand. After reading your earlier email,
> I realized that many people also consider it difficult to follow. So I tried a different approach and implemented
> anon_vma rmap using a simpler doubly linked list plus depth mechanism.
> 

The in-flight was discussed at LSF and then reported on by lwn

https://lwn.net/Articles/1072378/

https://git.kernel.org/pub/scm/linux/kernel/git/ljs/linux.git/log/?h=project/cow-context

If you have issues with the in-flight work and think there's a better
way, it would be good to engage on that front - rather than posting
competing work and expecting maintainers to have to context switch
between two solutions for an objectively hard to understand problem
(which carries significant risk of regressions).

No one is saying you can't engage, just trying to avoid doing the same
work twice for negative value.

~Gregory

