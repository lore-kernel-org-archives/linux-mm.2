Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A97C87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 02:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2B4B6B009B; Tue, 29 Jul 2025 22:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDC5B6B00A0; Tue, 29 Jul 2025 22:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCABC6B00A1; Tue, 29 Jul 2025 22:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA4016B009B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:00:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 892CC1DA158
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:00:02 +0000 (UTC)
X-FDA: 83719275444.01.C3F6F51
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 85482160002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:00:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ET3bCpny;
	spf=pass (imf08.hostedemail.com: domain of isaacmanjarres@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcSJTaElVVvYYo9nNi0EOGtYaOjMylV8RmeZ1BcyB1k=;
	b=oE7EuEHKxz0AYr3RDQR1Y9vlO7y6HgcSxBUZVxINNEt+reP6csrl4RgNBKkDxg4p0OUvpw
	l6k06F1LuTGAF05BnBbJ4obHontBS1/dXXCYrMDD2jI8jo5A+TIL0H1pdEZrmy+On/INim
	GnyUfRt/zypiNc9MWLIyIk+WXXCFpNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840800; a=rsa-sha256;
	cv=none;
	b=6cP6BYQlehbj+o0RheUR75+TfHq4hHGd6L4iXSytvzLgd2nSLmoRufO2vAsgf17PY525Wl
	MA8O2Y/vh2rK+jztjvm0/odTUxe/9FnVOUqyu/T7yNHgSkmgj5kou1bYJ2dcHB9NP7wXIz
	NWQRIu9bh45VFmDPqg1CHFHzK7cqbSw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ET3bCpny;
	spf=pass (imf08.hostedemail.com: domain of isaacmanjarres@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-240718d5920so72835ad.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840799; x=1754445599; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QcSJTaElVVvYYo9nNi0EOGtYaOjMylV8RmeZ1BcyB1k=;
        b=ET3bCpnyPdfSjaXt4PCxCVqfS0ER2JYFeh3kvK1na/10EKnX6PHpcu0DL+6Y17saGe
         ibY/+676ZHloX3zllvESg28ekMgeFCBpyUUEJEzlfzhigyn1xAQv9L3z9AOIHQ5PaPRd
         t99Q/odeMAXr7q4U3j8aUOgdQZFHmAm22y3sgms+vK2L1BiBC7fI1k/yNZNe7fXUQ32p
         w1alSW5D3PthQ+frFb/1lOQ5uscu7vgOW59hY1NzYDLK1t+/VKLlMUgVprweqWBWv6G/
         TEsT+g70WCHGVs6RA42zux5DSYGPNd+1o7cbYMTA9krzAiSCRFPeVCqmV0ZC+T0L1VmX
         tMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840799; x=1754445599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QcSJTaElVVvYYo9nNi0EOGtYaOjMylV8RmeZ1BcyB1k=;
        b=MRpPatCB9iX85RDxuT/vFLcNukF6F4H5NRdLslY/nejrPaJ6c7Fl5+d7ECnLKjeD50
         6avBVc+nbezaFBzxbr7SPbjQsvgzIWnLdtRla/hHhUfL1IyF6z6Xfq1yLtCDZAy0VKg+
         iQFT7GV2RL6p3o4QLvW5eY/woBtkfX1CmnJ9OP4lc8fCB7MtM0lu3KeyAHNldZwXUfE7
         L5gtVMJAHTunq3T30FZKQXAqRUedt0C22h/c8F+ek4jkuzzPfFEYvZck6oALxl25eKxZ
         VxESUSNuDSrDHxHIepRWDd0O9o7niEx6SZC9BBLlbszvDvGtYCmRjeacrIi4itR9CRLk
         t7gQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLsgZi3LmMvGWm86IOc4qRIwpfTpUC6hBJzdAMQEvnI5TmUyYyzOptRxnSinDflCbNrN+dKs68cw==@kvack.org
X-Gm-Message-State: AOJu0Yyhoybj6s4Qil3zVhWd5cU+cpmmzVPCw7+XPhQNH+Xh7ROyiYqa
	FZatYFspNUdOkDYdNlIWCakuBghENEEspLvJOdjfDkfA29qJpG/MAIOI+CkGSDxXNA==
X-Gm-Gg: ASbGncsfhJc8QUWY5nPWnmYi8sf3AyhWCIjBqX3NBE623bRMJtfGC14BfxQRYz0J0Vb
	RSfLQkZb1/on+EBDvJBdX/35GObpEEfjqunWAqrjjXf0aw1SEtGDnmE+35KgoX7wQlRYMxEI0Ul
	LNShvtiLAZEMJqPL1frfrgfktKYCVVmfP1chNe6Rng4Wqze2aZKkng07gyul3+Y8eEs25aOf7BD
	0KHiYBToMjGWLv+vYBOPMmSfzuOCnE4b4MVwOkciWTjaCtI1SkZtAAvBs5VEl0mBJKNPLxjbdDi
	f0iQp29JefOyow/E25RLJZjD9gtgEjkW+DNrby2nr11BartyQgurP2f0yRRftgYEZxGpWKSveCL
	gAg8mDGDwx6bXGNZjQX59YbEEwO1JKIPH3zB2cXPhQ9Xje8J8zl2yMyVYY5mSzEE=
X-Google-Smtp-Source: AGHT+IGjlp72ezcaslBe/4Wam1DWdKTtFPAg2RfpZpa/ZWAp7fRLm64jv1x6op5wLdcpNXOdDDpIQg==
X-Received: by 2002:a17:902:cf42:b0:240:5c75:4d29 with SMTP id d9443c01a7336-24099e4ecc0mr2140635ad.0.1753840798874;
        Tue, 29 Jul 2025 18:59:58 -0700 (PDT)
Received: from google.com ([2a00:79e0:2e51:8:9606:2f93:add0:9255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76408def71csm9185669b3a.56.2025.07.29.18.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 18:59:58 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:59:51 -0700
From: Isaac Manjarres <isaacmanjarres@google.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, aliceryhl@google.com,
	stable@vger.kernel.org, kernel-team@android.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 5.4.y 0/3] Backport series: "permit write-sealed memfd
 read-only shared mappings"
Message-ID: <aIl8lyrHJ4DAQkxg@google.com>
References: <20250730005818.2793577-1-isaacmanjarres@google.com>
 <aIl1AbmESlTruw7K@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIl1AbmESlTruw7K@casper.infradead.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 85482160002
X-Stat-Signature: 9zjrejthrmoc9yjjj5nkt9eeifjzg6oo
X-Rspam-User: 
X-HE-Tag: 1753840800-132287
X-HE-Meta: U2FsdGVkX19wknl6BfY4NxhY3+NWVMsPOZYWNdWRwG2/ZkBO/8d3fcz/epXKxzWt17Y8ym4u73tisWcoW3W4om701zgBwu2T6DATxgT450/V0neW3bYXlWeieOq7bfFSkBb71uVNL2Db+AzI8Y6X2yCJq5zBfOtA4MlQyZxFkFlGx7ftweVvTpCpu7XK5Hkc4F4402hZBF+l678ElH8rD+uKp/FOpNRLn37x5NrI77nie3mO1PPxJDdITwpF38OQI1G9dIv65S0iJ4CIh+Q4i/DkuR9+xzmX6xKCDXXlpCc6XF6ZfWtEUhtYPrWkvmWwM4pYgMrYLHbQ+tLSjtR3nP8+5BHMoEFVqrKbdHQwUtwx855Nyf7D8HMec9j64rM5ysF30cu+6z6+OFRRBdMbyJZFslW1xnQPUaY/GOCD4cG3VDgsw2HjMND342Xgxvg/PtBAtAXx6PyeTx1eYP6zgXxwyQV31gkicfMSu0haaMHLFrZu1af1/n9XFMb7K0lYRyhfSyv91aTNj5klh+L+z1PC0If8QBPfLHsVe1xqjjpNkr22FMyDM7SS+7WTUxQ21VSCPgf7s2Mbui/Tdgg40IOWAI71uu25J7dFe4vNpPCAltCvg4i4QgBgnF6tkJN92t5MZku4Dm/sWxz5aDzaZ4nx6kgWeUj90mhqhLL2zqI27hUCTi8BGTim+cuIbgycKS6qAso2Pitd8DD/NWXtz7J9D7A455iZ7FOtJr1X/JRXq06fbuilmkhx6j1zXYv0IMNBXGk8h+TXl2vqSNSNxWx406tueMNgHxOfTo4kMFbLKdpmBQobcYDtbx2QGxzK3qJb8V44llamV6Nj5Me78vtA72qGK0ZXQyv23npb5FeDmrnZyYP8EXygB6pbz3KhpKKviBUnUrzBg/HJ4tu2weSM3x0ctFsuCHhaDJLl1feg0nz34aljazi/XWLd5gMkFqzVZN6cYwDLCdQ8xAu
 4ZQh1bYa
 NE02wS1EkR3p7ENUiNDfPjGPRRHlHGvug9xkKkuvFCiT2qLcut8Mcwegioo31WPXy97hQV3h7ooz1n+QElI1V0LZetn+btKYbqQU7y5iDOx3oWXuLdsAKZCeiNYSwzl/7RH+IrSGrpJpdcviz/R5RY7eoen4LAhg61kDvdv036nQ1TBzvaDgDXzlmuxEx0NxVOD0u5di5+V6xU0y5K8usB8Jo9msu0hmHAuzulszFZVeiHhxXtrNgp5upGBH7iI30o7LgOnrIUTYg593IzrxvhL/T1vzoUSYgeGVn2A8ucsaMWv8bLK/e3H4v/rAfaZpWfbos/RVWNklRHZE3TOWFwY3bMWMHRX0kCYJdXwmQIroGVFHw9R0rSqRCXuXUffF5+dw1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 02:27:29AM +0100, Matthew Wilcox wrote:
> On Tue, Jul 29, 2025 at 05:58:05PM -0700, Isaac J. Manjarres wrote:
> > Lorenzo's series [2] fixed that issue and was merged in kernel version
> > 6.7, but was not backported to older kernels. So, this issue is still
> > present on kernels 5.4, 5.10, 5.15, 6.1, and 6.6.
> > 
> > This series backports Lorenzo's series to the 5.4 kernel.
> 
> That's not how this works.  First you do 6.6, then 6.1, then 5.15 ...

Hey Matthew,

Thanks for pointing that out. I'm sorry about the confusion. I did
prepare backports for the other kernel versions too, and the intent
was to send them together. However, my machine only sent the 5.4
version of the patches and not the rest.

I sent the patches for each kernel version and here are the relevant
links:

6.6: https://lore.kernel.org/all/20250730015152.29758-1-isaacmanjarres@google.com/
6.1: https://lore.kernel.org/all/20250730015247.30827-1-isaacmanjarres@google.com/
5.15: https://lore.kernel.org/all/20250730015337.31730-1-isaacmanjarres@google.com/
5.10: https://lore.kernel.org/all/20250730015406.32569-1-isaacmanjarres@google.com/

> Otherwise somebody might upgrade from 5.4 to 6.1 and see a regression.

Understood; sorry again for the confusion.

Thanks,
Isaac

