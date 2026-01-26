Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC826D19504
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF3A6B0089; Mon, 26 Jan 2026 11:45:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB9D66B008A; Mon, 26 Jan 2026 11:45:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDD6A6B008C; Mon, 26 Jan 2026 11:45:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ACBD36B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:45:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7489F1B0A83
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:45:07 +0000 (UTC)
X-FDA: 84374689854.22.5A620F6
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id A049F14000D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:45:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="a7jpdq/1";
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769445905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67gINf8nv70IfGM4en9MXo18NWyvtv/UqgQR1tCJ+fU=;
	b=3vw4LU6innbVKAD3487OAyJd+ql2TvR4ccLMqMgpfeFrNcKC5eQ9kgQU9koBv4oLGDrAuD
	EP1OIakHUwwh+M9zRChA8KjmGJIGaE8/LdBi/Xcg6L0h+NyV4Rq8aJG8Hvw3uk0DxCBSUX
	gahcnyFuG8lnGE9cuxhGZrXTydyplLE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="a7jpdq/1";
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769445905; a=rsa-sha256;
	cv=none;
	b=ydLohjMBY63RT83MWUOgbUHYFz7pj8oztFyrLyYQIpDPBAZTOYTE50PFEHXg6zXQNfOOwx
	M0/xV+me0XaxVoE03xet7HPah8oP61jERmfw65Q0ZF6j0HOVZDn0ygAvOzbeMV3gv/Tb14
	qWSFyazPCHyGFPvuZRtFaFw/Xfqhv0k=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-59b710d46ceso4530690e87.3
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769445904; x=1770050704; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=67gINf8nv70IfGM4en9MXo18NWyvtv/UqgQR1tCJ+fU=;
        b=a7jpdq/1jw2Dx5Wg5nMcp2R22omcseTUFs5l7/wWg6H3kZsFX/PdxXCwWiMv40iTFt
         2ZMgDgGNus2I18sy6yhbJwA1+QfQsuf/WVFd2/LALjJ3/1vpaTrUCg4Pk3v4GiSYeiv7
         pvIYjLg22CXkn9HnO4yAsyi8FcdJ7yyOi0L28Ruuzw72JUmbwEWlVQdoYP8Toa9aODBh
         V8B+/u8/AKW94Sh+AE+xI8Olv4Tir4dWR38ksspRt+hp/L9aEcvxMp96nl046v0W4VQO
         n7vWYlIdPmgMrsHiGmeROJbK/jPfFgc6/K9eSgwpE0ueZF4VFLIXpAuunuFc2BlFNpF/
         Px+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769445904; x=1770050704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=67gINf8nv70IfGM4en9MXo18NWyvtv/UqgQR1tCJ+fU=;
        b=ORHP9980wp0FZ7YCbAPXdDakyiuR+NH23F0Ngfnu/PwPioRg/OOQr9zhX3Tl8Aa7ZZ
         /vFh7AwwexGAp3YJM0ucl40BucgXslmpoMc6Quxth+YZDFvQ6EWiASdUDTU4sFNqYphe
         666OJ6CTuuod9ElvV3g9RRH5ar/VgQjhOUHdT9gSJ9b5f3u26+ZVOeZd5ysgu+evM5QV
         fs+ULj0iWZ0PCIS5gGnKzj+72wasSobitVj8MsMRWEP5jX7F97bc/9jP1IYhJxCy0c+Y
         Na7Q1fxMZrY+VHzsefEBtOoWwhDAc0/uZu8Nnyz+NrUNwEb6KUtk/hIm9U6vcdAH+mY5
         hS/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVAV5667uTCHP1m+cR4hSkOo4EV5wmQzYzrds5+FWxC4K5uNT/kETJWQ6Xv5D/lkkZc9rSqBvDXxQ==@kvack.org
X-Gm-Message-State: AOJu0YxNqVWCwSZW7GOx3O//+Mc6nAh2E5XCAKOzMP4zZnrDb1wCs/Ds
	ZrTNAQeOicJziRA3a3BPkFcUyzFnBZ7xWOCAzU1IU0X+q+oinsbmRuhj
X-Gm-Gg: AZuq6aKA63mwqht1JiE36elTq5+F3hEVZOFKAfFOqlZZEuw0HXeq51BUVLfg3i8YjjE
	tpbD/tDQLV0p4VhSVmGM/Q78EIr8nM2/hMi06Ca9OHB8Vpd5P8oC6JvvoIzcEDqI1zL5M8d4Zd9
	3Fq8NxcBF9sxrCmCK8dv48l03tNQleeaxMsM+YqGChHHxA1Q5LJNB5u3LyhQ3KwLHpaBdApCr7F
	Aha1oJtNqP+/hD+PtYdPwLCRdFecg2aqdibooEOTVgqKWB2Hafl2P/N1dXTTd14oYrClajw2I/w
	BBPxBgwELhn+I4F92/+MKPXrH8YDQvGAJHgs3OsluCB46GwoGj14J5n20AlNMgW0yTqmTX/Mw+r
	u1wOdthz/+PeRjA5j0hnTikFiPyLY2vWB//32v9qVBwkrTBuJHlRL
X-Received: by 2002:a05:6512:3f06:b0:59d:f2a4:3e98 with SMTP id 2adb3069b0e04-59df360afd1mr1753347e87.4.1769445903361;
        Mon, 26 Jan 2026 08:45:03 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59de492cd32sm2794304e87.100.2026.01.26.08.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 08:45:02 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 26 Jan 2026 17:45:00 +0100
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 2/3] mm: vmalloc: export find_vm_area()
Message-ID: <aXeaDMczmQl6wn9v@milan>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <aXdB3lsm3w0fJT3Q@milan>
 <20260126120226.GA6424@j66a10360.sqa.eu95>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126120226.GA6424@j66a10360.sqa.eu95>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A049F14000D
X-Stat-Signature: 7pdjfor6cmmhcrc1fmu1se6hjzshn1qb
X-Rspam-User: 
X-HE-Tag: 1769445905-306099
X-HE-Meta: U2FsdGVkX1/UJfg8/mcR+oiQLmQwhPXpIVd1oPy7/0h0qIPsTW5LaCTE4jg3hWwOJjB3bp9bzJMazRVFDA2RnX8MhJHJH9tYvJz8+wPg5he9xddwNe6WZBhh1V2UzWrlGXQ2gFTXDTYI5QSXNQ2W0L9XQxPDYBFFMJOlScBtAY/EY3W55E+0/MF9i+7furn2khi/f+9vUsqb5vrptWconEhUQevUZ558MxWOhz/wNK9Tp3WYFXkhZ08cJdz0LJbgKTzI6o9iT5OQmUJY9bPWhBXyIX/d8C+vRnyHWxQU59cZRo/x6ifF6kBILPF0MqrOD9/wVzR9ZLbxS3WzItOn0hfg2EyoXHcuXYI0JuvKBJ2LEE+Ki205DACmr40QY/x2YrlD6QIpJ1V4tOKImAjkl5jRXBU3s/4JMxLllw+qSEOQeg1aCtxZLQOuVWOVfsRWDkgn+ZZh3umRRNuq4yXPnzNVbGpBDq0l5c844eChTu8JrlJA499RBC0DS+8mN4oU055wX5uuZpb1TOc5RdTTPbl4bx6jRPgiFYXaDnueBV3k+2GAwLcSc0zX1rhtFuD81okk2KPtPjX1TW2eDzmO7ah2i2xASnLclOU3tUQhIObWQ4jhXRKqeR561X+r9sEGHJy/nbjR/PfPYrilu0qumziqS97/Zi62GXY6xfUHSLNGvMpuT+s9/N18ewGKWTiAYSLZnQjqc5alxXnKPOeIVD+008wFnPSdjlnJPvxi1nfO8Ownm8PPXqAK57rt98KYZ/EDxYAbe0k3Wvlf4kOrK5Q5fsnuIAvCYnhCtDr/D+XBoy7iFs/HEr2bSILrUzQ1jR9gPvBVKfxI+FavgsTsXCuaxNrNhdUToog7vLFcOuYVe2TCP5trXEZXy8dNDu0X44W/kPFRLg68gUO5hBVJ8ghlEfZtve9RDZa9jFGjc0XHvEfHXm5OQ541dPuIJETESxA3YoiZQytj5MzYQyF
 w3VZFIaJ
 MYJ2dmYqNdf1jQskkk8AlekB0qgErlVsjpIrke533XsGY7XqvD93QUr+PE5jLZekK4x2oTW4iwt538XERNNEKvKfaxGxC73Fzyqiq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 08:02:26PM +0800, D. Wythe wrote:
> On Mon, Jan 26, 2026 at 11:28:46AM +0100, Uladzislau Rezki wrote:
> > Hello, D. Wythe!
> > 
> > > > > On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > > > > > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > > > > > find_vm_area() provides a way to find the vm_struct associated with a
> > > > > > > virtual address. Export this symbol to modules so that modularized
> > > > > > > subsystems can perform lookups on vmalloc addresses.
> > > > > > > 
> > > > > > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > > > > > ---
> > > > > > >  mm/vmalloc.c | 1 +
> > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > 
> > > > > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > > > > index ecbac900c35f..3eb9fe761c34 100644
> > > > > > > --- a/mm/vmalloc.c
> > > > > > > +++ b/mm/vmalloc.c
> > > > > > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > > > > > >  
> > > > > > >  	return va->vm;
> > > > > > >  }
> > > > > > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > > > > > >  
> > > > > > This is internal. We can not just export it.
> > > > > > 
> > > > > > --
> > > > > > Uladzislau Rezki
> > > > > 
> > > > > Hi Uladzislau,
> > > > > 
> > > > > Thank you for the feedback. I agree that we should avoid exposing
> > > > > internal implementation details like struct vm_struct to external
> > > > > subsystems.
> > > > > 
> > > > > Following Christoph's suggestion, I'm planning to encapsulate the page
> > > > > order lookup into a minimal helper instead:
> > > > > 
> > > > > unsigned int vmalloc_page_order(const void *addr){
> > > > > 	struct vm_struct *vm;
> > > > >  	vm = find_vm_area(addr);
> > > > > 	return vm ? vm->page_order : 0;
> > > > > }
> > > > > EXPORT_SYMBOL_GPL(vmalloc_page_order);
> > > > > 
> > > > > Does this approach look reasonable to you? It would keep the vm_struct
> > > > > layout private while satisfying the optimization needs of SMC.
> > > > > 
> > > > Could you please clarify why you need info about page_order? I have not
> > > > looked at your second patch.
> > > > 
> > > > Thanks!
> > > > 
> > > > --
> > > > Uladzislau Rezki
> > > 
> > > Hi Uladzislau,
> > > 
> > > This stems from optimizing memory registration in SMC-R. To provide the
> > > RDMA hardware with direct access to memory buffers, we must register
> > > them with the NIC. During this process, the hardware generates one MTT
> > > entry for each physically contiguous block. Since these hardware entries
> > > are a finite and scarce resource, and SMC currently defaults to a 4KB
> > > registration granularity, a single 2MB buffer consumes 512 entries. In
> > > high-concurrency scenarios, this inefficiency quickly exhausts NIC
> > > resources and becomes a major bottleneck for system scalability.
> > > 
> > > To address this, we intend to use vmalloc_huge(). When it successfully
> > > allocates high-order pages, the vmalloc area is backed by a sequence of
> > > physically contiguous chunks (e.g., 2MB each). If we know this
> > > page_order, we can register these larger physical blocks instead of
> > > individual 4KB pages, reducing MTT consumption from 512 entries down to
> > > 1 for every 2MB of memory (with page_order == 9).
> > > 
> > > However, the result of vmalloc_huge() is currently opaque to the caller.
> > > We cannot determine whether it successfully allocated huge pages or fell
> > > back to 4KB pages based solely on the returned pointer. Therefore, we
> > > need a helper function to query the actual page order, enabling SMC-R to
> > > adapt its registration logic to the underlying physical layout.
> > > 
> > > I hope this clarifies our design motivation!
> > > 
> > Appreciate for the explanation. Yes it clarifies an intention.
> > 
> > As for proposed patch above:
> > 
> > - A page_order is available if CONFIG_HAVE_ARCH_HUGE_VMALLOC is defined;
> > - It makes sense to get a node, grab a spin-lock and find VM, save
> >   page_order and release the lock.
> > 
> > You can have a look at the vmalloc_dump_obj(void *object) function.
> > We try-spinlock there whereas you need just spin-lock. But the idea
> > is the same.
> > 
> > --
> > Uladzislau Rezki
> 
> Hi Uladzislau,
> 
> Thanks very much for the detailed guidance, especially on the correct
> locking pattern. This is extremely helpful.I will follow it and send
> a v2 patch series with the new helper implemented in mm/vmalloc.c.
> 
> Thanks again for your support.
> 
Welcome!

--
Uladzislau Rezki

