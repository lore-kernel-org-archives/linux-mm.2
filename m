Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F11EB26F8
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 18:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758776B0088; Tue, 10 Feb 2026 13:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705C76B0089; Tue, 10 Feb 2026 13:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611B36B008A; Tue, 10 Feb 2026 13:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC616B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:39:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D16198C3C6
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:39:56 +0000 (UTC)
X-FDA: 84429411192.26.46F0C71
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id C7EAFA0009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:39:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PAGKPMXD;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770748795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQ846SBG+nP/4stgxv7mhMOSp1tkPJTwAIeCH8UHcFg=;
	b=cdh8RGH22ickP0tVsIdpeDDMdItEWAwJQOazqG27Pn+lD3FkP2+08FtOu9XjdmYedhVrWj
	+pM/9HCSARn72DTAWOHD/S/LD76IUHZ994EA/YD+45FBytva7mW04SYLnpwGQxM7CSenW3
	M5EEqFUHUWfuxgOOul4sI5Xx3O1uE50=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PAGKPMXD;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770748795; a=rsa-sha256;
	cv=none;
	b=pDF1PqxwVsjvnvnIKVu8K+Rp2/vgEu8f3aoh0bDGNdsRV4p4ak5DpPVdqHfuWiXVNT2fQ3
	DOw9wvPy+TpGrjhmtqsrrfSm2/3RyXBLCn/kjJcBiCnovKJC+uQ/5PxltR/cxhU0QS1M8w
	H5l6c46BOiefdvOp2biYTy3zQbY8AKI=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8230f8f27cfso2852700b3a.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770748793; x=1771353593; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQ846SBG+nP/4stgxv7mhMOSp1tkPJTwAIeCH8UHcFg=;
        b=PAGKPMXDPxz2P2LmavTv2LrGXh4R3q5mbzDqS4toq/9gj/ymqxwzfLR32K7VtCcTAP
         MICu4k2PwSL13K4mgTzDfD9H1+X1vrG1mClGndxw2lCwfzun6nUVX+rqT92t8fnCr9NM
         HRJpwS6Yza3DZtspRyuDGUD4b9umEW34mfuMJ57lirOTJN837GP+CKtkJtmexD3EIN5w
         f/TLuhwT7x8ZfyFd57Sh6zInId5lw6mk0pRsVHnmnRpWwWj/4EMdPLhzyloo2eOE7SgI
         s7aK9iv5qtnmDEUS+KU55lX3D36lftBcMzN9zdIeOdS4KLw2BMDjsEsVsy5lyDBIs64T
         ak8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770748793; x=1771353593;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQ846SBG+nP/4stgxv7mhMOSp1tkPJTwAIeCH8UHcFg=;
        b=UxCddnjEJrFDuxfIx9r0ep+sdn88XX9GWbxYkbS6T+0Y1GRpO6vmClV1E+gQpERJXf
         dRBahonqarN0huHoRh5jRdWnlWNnz5BPCJ80qTui64NVMKmIRYkL2xXWw9Q3lgP0NQPi
         czRhMIYMVyWEVEl+qwP7jnjpWak05lxyGfLrehxMacvMNpx9+3oyY0OB3vXUYY0TMSMj
         x5SFYNVSOYOmNsBBzgFh46rUkYj93RS2KL8Zb1sdYtLC+VZoQ36PEyhpkQNYr+1cJQne
         BAoUMVs3sm3N0Q/TI0Ze7n6XuxYn0bytMbKzJNrBcc7dPefZFVs/IULeYGcqpoXZc9sW
         Ex3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXIUXSHXdjj+daGEt0YEc4+kgjHlV9R41rg7phdpKw2TiwJk+e4svdhg5rWMaGTzMtGw9u5Ioa0CQ==@kvack.org
X-Gm-Message-State: AOJu0YyrbO/gSvwSSSgsaI8mf7xRyTo77FmSili9aNPsN7hske3Nl367
	8X3Ezpy8rUpKXPH7WDwTDKla0hoS254tzzItzCvxb5eClfTty3/uONoN
X-Gm-Gg: AZuq6aLj+WKvAo8dIZh9Iyyrn6dFDh7zbd5z9OANZP55WcqeZvE2El/YWpBUFVmlsHl
	oVYpvF0PB0b1+rDuBXgEq2ynuE866bsv1yTslf5tFnW3507Zdf52x/ub3qz4wL5T4VrXD2JQhYs
	leVJUTQktgQ5A0tsq+qj4bswmi5lmU9FAN+y1TFjRa6ZQpAzD5lb4sODBCAvhGYXl8On2XqzcsC
	SHYqLvP2sj8rtzDeNwJrTdO+eAQiiWiB2JagvZbfkAKEwsqDuw3KqLSZDuP6THRt/Cvha5sB0P9
	a15aU2HO70FXSVcmDHkYZy9Dv1gvCjTQK0lyPWSn/rRiOtswXhI8ibW4VB2En77ija0Yu8ricvs
	gM9plPIdZqilXMbHMXNWgIyqwpgclQB3SoE3qoEBt1QlJfbkblgcDwqI+an/b3yzo2F+L1D/240
	K6T9eCu0QI1k+nqU++0E822A82avkf/s4SZYNJxy58rP/n2YiApoZ+QivP9Hw=
X-Received: by 2002:a05:6a00:22c7:b0:81f:9f41:34bb with SMTP id d2e1a72fcca58-82487ae59cfmr3152744b3a.56.1770748793470;
        Tue, 10 Feb 2026 10:39:53 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824418b5373sm14553760b3a.53.2026.02.10.10.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 10:39:52 -0800 (PST)
Date: Wed, 11 Feb 2026 02:39:48 +0800
From: Kairui Song <ryncsn@gmail.com>
To: carstengrohmann@gmx.de, Andrew Morton <akpm@linux-foundation.org>
Cc: bugzilla-daemon@kernel.org, Kairui Song <kasong@tencent.com>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosryahmed@google.com>, linux-mm@kvack.org
Subject: Re: [Bug 221055] New: Hibernate image write 10x slower since commit
 0ff67f990bd4 ("mm,  swap: remove swap slot cache")
Message-ID: <aYt4RwxqH1W_zHez@KASONG-MC4>
References: <bug-221055-27@https.bugzilla.kernel.org/>
 <20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C7EAFA0009
X-Stat-Signature: 9n7nkab7te7hbmg4gtaw1erzme8a8xuo
X-Rspam-User: 
X-HE-Tag: 1770748794-803351
X-HE-Meta: U2FsdGVkX19v7xB//cWaqTRzMxRDDMdduWD3o8L1fKbLKGO82JRH6eC4Irx496RFyTqZVneRHJ/9tFAUfwK1d2isxwZmZQJQxciNhrlWl1dzgtghXoUJf7AktsOITuQlOP8HsqNfxOKs0LrVsdRRvmDrFGL6ryEMCcJiVlRCbWBZgtz9LoNJ4lJ3OxrkJgAVFFAkzXFha6boHaZwZ6UBrN2ucUGdkEktF8yA2wtU6U7g/Sg8z2XPOptMy6jJxQwUWy0ZmHtDWr8TonEr6nG6BlNo3255cxvJUSFwWaQz63X2Q25t//UsbeLHx9tOa40yIUwMG74TB+e1ot75PHlqxDfAqerzhgZDMtFeyFC+Dw2irBgNx03btBbHuTZ7z7qD6ORGU2B5uv7viusDjhbNoR9/NMknQYAlEscoXpin7eMeN2W2S/ZFWGjpxMchaxUq+nkxwm8M3yi9HBfN2GkXkTAQKGkYIn+0J54HkKTuLSuliYDDwLwfWO6AuIgvutgIq09SpQaLH/MrmK8iXWuLpELNpkygUTGuzQ6oskMKo6qxhMDlKWCIZHkGnvHvoJxNsH0ghbBBS9XoBGt7up5lPeDM6hm85sxnzjYNbWOQeYl3QcXt2l9YxSm7ke45w5kez0ge15afh+kI1ZlP1Kv82yYIN+SIjRWPZti+Gpo0r3h6DkBF+QArbLBSxvPlZP1nnBm6TyA0JrI/p9dS9RMwe6B5hLmVb3SS5QyavTrS6HWImWvf/1bDf5UVE6jCoPXNxPOtGACX/jkx/BegWhF72CxXlBz+XKUR1dtsmlcTL8n50vLWVvxvw/rVv8Yv0e9KuzE5gNOngzFsaatC0Y5iLMA9ZPrfwoP4rvblkB42UgYN+XpqU4+ueDlxfq81kcOjCLIOZTw2rpSBsCqZ0Ez9cD5/DltiGQfV3pLxffiG7FRb1A8+f2lDTMi1dp3WRn0WYWZxHsCvw//OC6BWTzH
 hTXOO0QX
 EsZaVSMJCUEvkojq/TBIb2/DYQLkiKQZEhS7nMb+5+tvYomlA2SnL+j5XFy+6o6MnTMrOAymvrq1mJTuGg/8jx0Y3tfMz65u5I+oZnvpafkiPs2eEo1yZpJw02EEwlWxwT3bD54O/XODfqrtT7StjxvGTroRqiTex4RbQb9P3jhFJ7amfl0o5t/ROA5bPMpoQmxiK+rPy7Jvxd5PdmlIxp1+OAQAkBN/628ZDB4Wv59r3n0H/2oacoodiYr9fu8zpmKut06Fl/k6MI+2wt3FYHiTb87FkNaza4ExniF1lRuw4U5lW+y1jupJFM1WGjPPqD8dcgu2MI6yMzWKdrG0j76nBJGYQMog2LIUv7UidL6AhQXSjsTaQuL07pceOEk4f30ogOP3GC0VUyo40+B3POM7dI1OBvCf5J91K2T1o0VEwyUTNkUn7aIdbredRpAw0NB1y19UjNOH1b9YD98o4ogsDYwBcL24YyRXl4yMUj0fVgIgYafIr+idNpYIuGEA3pAV/VTes+82iCJM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 12:11:51PM +0800, Andrew Morton wrote:
> On Fri, 06 Feb 2026 19:51:38 +0000 bugzilla-daemon@kernel.org wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=221055
> 
> Dear Deity, I do wish kernel MM bugzilla would just go away.  Sigh.
> 
> Canned response follows:
> 
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> 
> >             Bug ID: 221055
> >            Summary: Hibernate image write 10x slower since commit
> >                     0ff67f990bd4 ("mm,  swap: remove swap slot cache")
> >            Product: Memory Management
> >            Version: 2.5
> >           Hardware: All
> >                 OS: Linux
> >             Status: NEW
> >           Severity: normal
> >           Priority: P3
> >          Component: Other
> >           Assignee: akpm@linux-foundation.org
> >           Reporter: carstengrohmann@gmx.de
> >         Regression: No
> > 
> > === Summary ===
> > 
> > Hibernate image write 10x slower since commit 0ff67f990bd4 ("mm, 
> > swap: remove swap slot cache")
> 
> Thanks for all the work you put into this.

Thanks for letting me know!

> 
> > === Description ===
> > 
> > Since kernel 6.15, writing the hibernate image to swap has become
> > approximately 10x slower. The regression was introduced by commit
> > 0ff67f990bd45726e0d9e91111d998e7a3595b32 ("mm, swap: remove swap slot
> > cache") authored by Kairui Song and merged by Andrew Morton.
> > 
> > === Performance Data ===
> > 
> >                  Before (6.14)   After (6.15+)
> > Hibernate        28-32 seconds   290-342 seconds
> > Effective rate   ~60 MB/s        ~4.5 MB/s
> > 
> > The swap partition's raw sequential write speed (measured with dd)
> > is 255-450 MB/s, confirming the hardware is not the bottleneck.
> > 
> > === Bisect Result ===
> > 
> > A full git bisect on the vanilla kernel repository
> > (git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git)
> > between v6.14 (good) and v6.15 (bad) with 14 iterations
> > consistently identified this commit:
> > 
> >   # first bad commit: [0ff67f990bd45726e0d9e91111d998e7a3595b32]
> >   #   mm, swap: remove swap slot cache

Oh, I took a look and I think I know the problem now, the new added
fast path in that series is only used by allocation from vmscan,
for hibernation it always use the slow path, as I didn't expect the
slow path is below hibernation's requirement.

Or maybe, it not the allocation path that is slow, but because
cluster rotation in slow path splatted the allocation to every
cluster makes the IO much slower.

Both are not too hard to fix. Is that's SSD only issue? And
should we fix this in every LTS or just mainline? It could
be a bit trouble some if every LTS needs a fix.

