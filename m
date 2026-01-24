Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E43DD715D9
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 09:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA0D6B059F; Sat, 24 Jan 2026 04:35:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7B2F6B05A0; Sat, 24 Jan 2026 04:35:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953B56B05A1; Sat, 24 Jan 2026 04:35:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83D426B059F
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 04:35:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43C4414023B
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 09:35:14 +0000 (UTC)
X-FDA: 84366348948.21.F6CC8B5
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1B6F1180009
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 09:35:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Cu7inWK9;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769247312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YM0UILcJR/4TkkLhadUMFOx0cYmqNgriWCYaevIhEXQ=;
	b=UnO3jE/TAmltDRcEiVoL6GOGTjASti2//X1x2R2EKUIfarBBtkIQUDY9X760na7O3HGWBc
	JRU2uLQwpcAJHQANQrTpg0quOeVCat5PiUb9mRP7mC0MK5Dhmo/A+E2oWWoPIxdeSWdcns
	o9ixba9fVBWjb27vYYkbXqsku49sfOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769247312; a=rsa-sha256;
	cv=none;
	b=qmqJM5Jc+p2Dm0qvlBgw5HerB3WevSIkPgAsspUYVnXwzYRg5Bqe9Sbv7+c4CJRsGq5BKV
	bBsoQIMLGizr/LK/1LbNYxP7fmokqIb2vvFvLtYpjsKp7vLt8pwzv2DKVy5rNOi9kvJSXj
	ufW45oh03HH6dxcNS2Tl6Tem5Qk0nQk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Cu7inWK9;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769247307; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=YM0UILcJR/4TkkLhadUMFOx0cYmqNgriWCYaevIhEXQ=;
	b=Cu7inWK9wWCktv3npihz+61yjaEret2q6/XSLMhde90SE+MvAz89h+L9VHCbqQk7Zx5HQiRUUjM2UyMtwMk36b78EgraKTefPbHYhY8zW/ID0NpoenEyp9QGsqg10Q07yULrXbJRxi53RxitZCtc1FWK9hKXxtTckRlaCurNAss=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0WxiX9Q3_1769247305 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Jan 2026 17:35:05 +0800
Date: Sat, 24 Jan 2026 17:35:05 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Uladzislau Rezki <urezki@gmail.com>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
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
Message-ID: <20260124093505.GA98529@j66a10360.sqa.eu95>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXPEFdEdtSmd6AzF@milan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspamd-Queue-Id: 1B6F1180009
X-Stat-Signature: btgj4wqja4me4pwrmzcrdhsqi9baf4ex
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769247309-128770
X-HE-Meta: U2FsdGVkX195ceHkHZhiKSw1E8FYEkTJQV1g3wpJf8w7EUPwGR//F4/xSUDOiZCwml/ZZOUQpqgd6FvXUOYr52GLvHyTw4rpkLb+3S3PFpupjJxbnZB4LOngsTy/2meYwpr8KTQIyHJmWvFf00EJn+Tl3UmTFfRF/66b4302EDU9a1e1hzTVqQf6xu2VeZP5V71I9dB3mvuRi0w5UjsM31CpUoUIDYKfPgrH9XVjI3T7doaxvIdmGstAm57HROFE7DiITASKvZRDbGSy/K0i27JM0QBdZeT67WY4w/dH8+sFOJ3bCOA+472f2lQ+60oeQaOHBsomkC/lTkPnuSOTPYEw6LDu4/NXELXkIt1ks96iwhyklFMYWbsWOF3T0trl65g05qg5LG5cJjhfvPogRnxnRXBwVLU3Az5lcncEjIovsO7nK7PCkBJZ+0ihEWnb7ym4aGUoD189lfMfmNBrxOPAH+OXmC4kCiNC8BUmliXU9un9d/gM7X2WqHX4WPF7MGjJO5xFZm/NyL7CXntSA8coJfdEWtBLKpjjAtzDvXtNSElI8HkNfEwraBFB7a9h10slHv7AuKRaxbKEV0f8NS1vhkz4dY9rTNAdnY2GtnZpb+7piWFxhgxgoHOv4IWlicnM+M3k+x/Olrb43HgPcjoPZ1NRFUhqWS/OhJGMc+NwHTanbBR+V4Jr4CMFE1kSQWnSMh6IIgXrW3uUr/I/MyW64EVACr47/+Uay8Wxb7aFtiwA1Lx1QdQ3Qt4vODItWbKemG/w7QONWKxWrrfRm7T9V3yclo0Yw6z8rOzFQCqnkzcB9ttBOgHT0jCG8tU3QKj3V/FozNSCCEByIZ+2Y3CqKlYt33NVNN94avoFeBTr1W0x7uEMd1uZmaaeRnf/iCQZJEp6X5Dzt+uaFKcrFTvrgJLHXgf3rVISM1NwCJESYa1qKRjw7e7Gf3NnjI0Z4qwEUUHT7156fhBApZl
 BmVKVM5B
 X8dhvI8FrqBslRSP7VqiMfomslZCKN9rAOYjkHTja3yuD3AmIp7anZ+LfKKkDgcqqiTkZL6NX/F6HHd74vb88Jedujfm67w2E3QU1HLKoAo2RNeZrx6R6iduLd/CET/Toqggiw/U92YO/36salk9oP0eXgpPjHu1TQxFDO5y8IL0NvtpCFDdN//lHKWcJ88fTjW2mBwtQ5XhchXZvw8ABi0hHbRiZgiXM/lPdlbA+rgp/MzWjEiUdHV4OVSLTuVUoMuaRyIb1uDE902Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > find_vm_area() provides a way to find the vm_struct associated with a
> > virtual address. Export this symbol to modules so that modularized
> > subsystems can perform lookups on vmalloc addresses.
> > 
> > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > ---
> >  mm/vmalloc.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index ecbac900c35f..3eb9fe761c34 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> >  
> >  	return va->vm;
> >  }
> > +EXPORT_SYMBOL_GPL(find_vm_area);
> >  
> This is internal. We can not just export it.
> 
> --
> Uladzislau Rezki

Hi Uladzislau,

Thank you for the feedback. I agree that we should avoid exposing
internal implementation details like struct vm_struct to external
subsystems.

Following Christoph's suggestion, I'm planning to encapsulate the page
order lookup into a minimal helper instead:

unsigned int vmalloc_page_order(const void *addr){
	struct vm_struct *vm;
 	vm = find_vm_area(addr);
	return vm ? vm->page_order : 0;
}
EXPORT_SYMBOL_GPL(vmalloc_page_order);

Does this approach look reasonable to you? It would keep the vm_struct
layout private while satisfying the optimization needs of SMC.

Thanks,
D. Wythe

