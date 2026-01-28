Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFC11D25B4E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 12:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A99196B0088; Wed, 28 Jan 2026 07:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7AAD6B0089; Wed, 28 Jan 2026 07:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97CDE6B008A; Wed, 28 Jan 2026 07:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 87C886B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 07:44:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E27B4D3580
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 12:44:12 +0000 (UTC)
X-FDA: 84381340344.08.1FB500C
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf30.hostedemail.com (Postfix) with ESMTP id CAC438000B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 12:44:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JZUa3yfG;
	spf=pass (imf30.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769604251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=926yyjJ3/AGkTyEPy9s/F8eCj2vY6m18P4EAX1f0swU=;
	b=QN5wbQ642qje9LI2RLVuSLTKUiJTzZwKmBPOdewjl9hDTwK77JMuTpcewNYuHld52vij+e
	+sMlUvIihGBEfgSL5aUHmyx4rzHQ2xB3G5+tgzsvu6bd0pqoSEodT587fZH7DdSETUhH99
	YuvKOK1W4iRaXcbyoVycuiHpz6xUQzU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JZUa3yfG;
	spf=pass (imf30.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769604251; a=rsa-sha256;
	cv=none;
	b=QqM70cAdRxxR5YJX3CA/btO3dTMUp4JjM3orpFyKJ1xg9ERnqU48hatQaM6AMCaGys/4WX
	uoFWFV0VP4P5OUWax3L+z47E//vHBSbx2oWYLjLECLjIddOL8K8vTrO6kXtKiD3viHsHD2
	czNv1kcYmV7Qm3k6AQiIr2M/4ZjYKy4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769604246; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=926yyjJ3/AGkTyEPy9s/F8eCj2vY6m18P4EAX1f0swU=;
	b=JZUa3yfGJoPas8sO2s3Jy4KxfdRzFJCLBm/DsicnhLoPnpwvydldV18lwuH+ZBHDoZgtbYv/gGGoCCgTbNZWQ+aWlwx1hnlXvA8VQyJ3ZHK+RJ+A3Acvq89lkh4ZFfJUhcjdqZnSz1j1Tx7kKWHy4GU5qUvURapY/5i8rUky43k=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wy3QjgL_1769604244 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Jan 2026 20:44:05 +0800
Date: Wed, 28 Jan 2026 20:44:04 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Leon Romanovsky <leon@kernel.org>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
	Uladzislau Rezki <urezki@gmail.com>,
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
Message-ID: <20260128124404.GA96868@j66a10360.sqa.eu95>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
 <20260128034558.GA126415@j66a10360.sqa.eu95>
 <20260128111346.GD12149@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128111346.GD12149@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CAC438000B
X-Stat-Signature: fkpkenjd8offmszku67n7dx7tarw86i7
X-Rspam-User: 
X-HE-Tag: 1769604249-899841
X-HE-Meta: U2FsdGVkX18WAJMDeSXocfb/Dy0timCsI20Klu8mFHoHKebaslMDR+OEogsmev2ZnqV74VDKcF6YKDgrJrHwNgKgjbDIrDT7RvLyk8bxQ19V0fBB7wjrtTzrhN7d6GhD6UYXAZ9UY13Q0qWxoLcR7np4BSnCBymZyQCMx73P46tb/UV9pfs3CmcYGxcmnBobGg2uK+gbb+efvKsD0MyBWI3cKBzdP2WJI6akDPZsEH/9t0cSRvRxkRZ/j4LhCMqi3HD+DDM+5mHY5Pq03PkcmtxH3B36Wv/KPUPG2WNJtk9OTHw6QrJHhy0eKf08MAm4rgopZ62XLDjnpEIoKyJKEaPEE/k28aHFklb2SmI9mwsl/Wfj1leM54Us1SX+hUdoy/P5+qFpWVstmVbNQ7kMXlyWLJYlWeOJK/MGaCD7lRlieaJHyRnVg1fqKQtAiMK3hCcYFLcrfp9SKWB5AdhblteHrXmxCMOAG1dfbRR5/qv52Qa+EU8FbE9Kq1/dNYmkQtANdx7mGs9Fz7U3mNUyeYW4jH98pfx4M+RDTuoz1ibCHhq8EjEli0ZFMfgJcf2arx2fzXMVEcfdPRD64vvwIwdAa8CCxqpmqkYS9Yg+ZeilbgjtyQQJTQflMrK33eyhVnttSR6eEcof/riH8uDE1M6Xbkpq+16SBa/W209Pdxtg3agmzdAFdxRX079XZhS8H+V4x8fyhMZTacbsZ9N1aOcVkLtNTRKsLiNkBC5nqK7runTC/4tGohq+2FK1Tw0nC35WHh9Ayltq9dIQNdcxQKUHOxoH2vh5wVv/4LYKZuVLqSw3e9hk7D6q1x7yXO/owUrHJ9teqK7ItwzM0BiZIOUhEd28b/SQ4KSLnH0i5Qrd2hbvIrjkcuKdLPyuuN0sHMSVjwD6i4Z8lDVgYQLMIYcpMBpyG/9Xm01XvzCuDSerMDux7Opcrm6zGrJT2gy4ALV1YJSqYjGoJ3IxQC4
 VBZSkFaR
 9F/8faALIdLKJaDarCVGx6+BGTIcQX+qT/4ECatKt497sZ4fScRyY9TXeMvpmNZqBC9HkemDROTq88KVA06AcVt8JUMNqkRvTupn7/jvLUvmsqKczwXjQ0wnwESYEzw26ssF9MTyvI3xPeu16fg05FEua7erFicHAdwDf/dLRG/vBZGcx7jGOYfr+wNSyGmkk4g4uYXYiLmymFXZ2hXUN5H7gGKEOF49v8/ngiu21wYjeHG2gT2DgqCeEkEcu5WvyIXsu//to89SUob8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 01:13:46PM +0200, Leon Romanovsky wrote:
> On Wed, Jan 28, 2026 at 11:45:58AM +0800, D. Wythe wrote:
> > On Tue, Jan 27, 2026 at 03:34:17PM +0200, Leon Romanovsky wrote:
> > > On Sat, Jan 24, 2026 at 10:57:54PM +0800, D. Wythe wrote:
> > > > On Sat, Jan 24, 2026 at 11:48:59AM +0100, Uladzislau Rezki wrote:
> > > > > Hello, D. Wythe!
> > > > > 
> > > > > > On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > > > > > > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > > > > > > find_vm_area() provides a way to find the vm_struct associated with a
> > > > > > > > virtual address. Export this symbol to modules so that modularized
> > > > > > > > subsystems can perform lookups on vmalloc addresses.
> > > > > > > > 
> > > > > > > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > > > > > > ---
> > > > > > > >  mm/vmalloc.c | 1 +
> > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > > 
> > > > > > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > > > > > index ecbac900c35f..3eb9fe761c34 100644
> > > > > > > > --- a/mm/vmalloc.c
> > > > > > > > +++ b/mm/vmalloc.c
> > > > > > > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > > > > > > >  
> > > > > > > >  	return va->vm;
> > > > > > > >  }
> > > > > > > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > > > > > > >  
> > > > > > > This is internal. We can not just export it.
> > > > > > > 
> > > > > > > --
> > > > > > > Uladzislau Rezki
> > > > > > 
> > > > > > Hi Uladzislau,
> > > > > > 
> > > > > > Thank you for the feedback. I agree that we should avoid exposing
> > > > > > internal implementation details like struct vm_struct to external
> > > > > > subsystems.
> > > > > > 
> > > > > > Following Christoph's suggestion, I'm planning to encapsulate the page
> > > > > > order lookup into a minimal helper instead:
> > > > > > 
> > > > > > unsigned int vmalloc_page_order(const void *addr){
> > > > > > 	struct vm_struct *vm;
> > > > > >  	vm = find_vm_area(addr);
> > > > > > 	return vm ? vm->page_order : 0;
> > > > > > }
> > > > > > EXPORT_SYMBOL_GPL(vmalloc_page_order);
> > > > > > 
> > > > > > Does this approach look reasonable to you? It would keep the vm_struct
> > > > > > layout private while satisfying the optimization needs of SMC.
> > > > > > 
> > > > > Could you please clarify why you need info about page_order? I have not
> > > > > looked at your second patch.
> > > > > 
> > > > > Thanks!
> > > > > 
> > > > > --
> > > > > Uladzislau Rezki
> > > > 
> > > > Hi Uladzislau,
> > > > 
> > > > This stems from optimizing memory registration in SMC-R. To provide the
> > > > RDMA hardware with direct access to memory buffers, we must register
> > > > them with the NIC. During this process, the hardware generates one MTT
> > > > entry for each physically contiguous block. Since these hardware entries
> > > > are a finite and scarce resource, and SMC currently defaults to a 4KB
> > > > registration granularity, a single 2MB buffer consumes 512 entries. In
> > > > high-concurrency scenarios, this inefficiency quickly exhausts NIC
> > > > resources and becomes a major bottleneck for system scalability.
> > > 
> > > I believe this complexity can be avoided by using the RDMA MR pool API,
> > > as other ULPs do, for example NVMe.
> > > 
> > > Thanks
> > > 
> > 
> > Hi Leon,
> > 
> > Am I correct in assuming you are suggesting mr_pool to limit the number
> > of MRs as a way to cap MTTE consumption?
> 
> I don't see this a limit, but something that is considered standard
> practice to reduce MTT consumption.
> 
> > 
> > However, our goal is to maximize the total registered memory within
> > the MTTE limits rather than to cap it. In SMC-R, each connection
> > occupies a configurable, fixed-size registered buffer; consequently,
> > the more memory we can register, the more concurrent connections
> > we can support.
> 
> It is not cap, but more efficient use of existing resources.

Got it. While MRs pool might be more standard practice, but it doesn't
address our specific bottleneck. In fact, smc already has its own internal
MR reuse; our core issue remains reducing MTTE consumption by increasing the
registration granularity to maximize the memory size mapped per MTT entry.

