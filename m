Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50BD8C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 07:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29CEB6B008C; Fri, 21 Aug 2026 03:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274F06B0092; Fri, 21 Aug 2026 03:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A9C6B0095; Fri, 21 Aug 2026 03:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D849D6B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:45:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 286008035A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:45:44 +0000 (UTC)
X-FDA: 85124492208.17.D6ADECC
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 16488140009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:45:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TNoCs1mR;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787298342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rWco0Zv1E66QrWcdw7k63EetmMugHVxwGwsvEvMFijQ=;
	b=isfJTBA1bZIz19Yur3aFXJGsGjacrmJfBO43lXhcx9PIlBI42XL9DeIxKBSzHzUIupK8bH
	aoigEUGwt5yc7/HlmQgbJ8NvoeoqImVwyT3XzxqzUllCKVaG+WkRxWN9CznJNAhFMswme2
	NhDiuVZATlYN7/alp+YTH3jKtfm2IBs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TNoCs1mR;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787298342;
	b=XUz8bKvDGRxySXGh20B/PjpIwoj5z78bT4eRKWVkJXpFRe9w2R0coIMhuhIs7kfZ63al52
	JXmZ3fi7CfhnIMVTBBBn0lo2HF3+gKP06daLWBP4mxX95gUGSkGpR4pTP78Rc8BvSsaIPA
	zB2bMqU81btlRoiGp9N7OIfvG9NC9HE=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1671ec8692so109465166b.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787298340; x=1787903140; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rWco0Zv1E66QrWcdw7k63EetmMugHVxwGwsvEvMFijQ=;
        b=TNoCs1mRN+kMcBAvO2cjW+KGVNtK6oeujb+Cs9XPQF2HuUdwuBTXacspJLLVJgVioe
         gQEBh3qNPrvSo1z9U2g5NU1TUAMGvb6Xg8Wz4CvsT2Uk3/0/DOk7hGZ5IbavhVQT86Ow
         30qDzb5u+kkm46VKkII+Dxm7t0PypgvP72akFq/uHLkornDKko2ax+s8Z+ezDNPJ6QHk
         o3AGsWLIx/nlMdBk1n5dzPyMQl5+QXKPxQjeXH3rmgC0OHh96Dmbo2wOPt/IL3pvjiQr
         AOayNLvoSAKLMEfHQHLXLfcOFJt3T/0NH9FjXHqCSu3FBuIg5g1Ey+FBSDw5n1BYJD1j
         9RFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787298340; x=1787903140;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rWco0Zv1E66QrWcdw7k63EetmMugHVxwGwsvEvMFijQ=;
        b=RJeoBUvpi9gtrY528vVdehpaC2LKRkCAqFkCfQX1/Jw1aX3gIAN1T3QD1fl7zEOZUD
         /YXOZR04ow6nYaakYMPw8AyNvUMnArLYUb9q2F++LdyS4Z3Ic/+d+M7j6/a6thfSIJeG
         F696qGo2ET3rBQn0aq/ow7kBQq7ZMqWc6iAWd12sxxOWR83NH+u98PHp8of00gOwdMIH
         +f9DCj64+ynypzh5wmwJ5O+O36zBCGHHJxGnBeawIC51rGnBehbr0xd1MoiUjtWq0pg4
         CKF+pNZxzsTrghhml3kzKdLX3P0g7WZai2rZM0AsG8PoGJz4xinwnb9aKf7uRXop8KbB
         ICYA==
X-Forwarded-Encrypted: i=1; AHgh+RoaKta4kDZIypvQ+d5KA5ONsMGV/BRg2fooFhBAmM6ue+rlgptPdpV+msXNuvAhNPGBk83xUJ1LPw==@kvack.org
X-Gm-Message-State: AFuF++l6CnQ3t1THoLPAPlTq0kpfEueowtIJrlEYJ3sW7pDvs56Dgnwq
	2A0hbP3wCoBSaNasML0kEUWGzD7OcqUmMX50stksj30qgRdTn97DoVcJqQYqzYCt7NM=
X-Gm-Gg: AR+sD12CDAvnXsy4BYUu3YbVzxBn8a/+5vZL0hcW2Yuo46vWefchZ8aos19TTCIuIXE
	FNAAj0JtJIiZ+nKXKQUtKBW/+IYOncc9TxvTQCYQdFbDWROyMe7muo9iiLwQYmIcQfeAEiIsPGi
	GosuwJ5U+GmYcKjgJzapKMVyXlmFmcgNpQJ5IOXXRVCZGahDB0KDB5CT38ClUCxAIy7gSde5xTF
	zU4L+Q2QUzfWj7e7YPWbM3HZJhMPua65is+JdjcqRqpm+tu3GIaOpzr92dha3REPOnArfHAOdwN
	bCrtRY6nJcbfFGL9OEnQS8BpOUWUAWfZL/nb9YGUjr2y6BCHFHFpnlFPryZTmnpT49twALBqHAI
	rtAfpjN4+ZP7sXRlyfYSAZ7k/s8/Cy7tnb0Tmr3NabAtApfMeYHH3WUEStH89yecaLbkotcE5xq
	3KD99XID3gcTjo8iSrpychdOAdFbOANFSkaclTIKEDPPvckAn0vtC1uOcM0qLPRYgCvpjwDVS3V
	Lwmh9/skaBV
X-Received: by 2002:a17:907:3c83:b0:c20:899:b8bc with SMTP id a640c23a62f3a-c246a4d116cmr488381166b.6.1787298340554;
        Fri, 21 Aug 2026 00:45:40 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2458b09448sm360492066b.17.2026.08.21.00.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 00:45:40 -0700 (PDT)
Date: Fri, 21 Aug 2026 09:45:38 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <cxiong@meta.com>
Subject: Re: [PATCH v2] memcg: trim the per-cpu charge stock instead of
 draining it
Message-ID: <aogCIs5-MCpo9loo@tiehlicka>
References: <20260820012010.2016086-1-shakeel.butt@linux.dev>
 <aoanalsTiGmL69LN@tiehlicka>
 <aoclMssJAyYw2aCn@linux.dev>
 <aodLEmCg76oRHY2j@tiehlicka>
 <aodk640QxaSa0gVK@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aodk640QxaSa0gVK@linux.dev>
X-Stat-Signature: bhtrpo11simrdmtb3w8k737q4ity4hfr
X-Rspamd-Queue-Id: 16488140009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787298341-733256
X-HE-Meta: U2FsdGVkX1+J153/PD2AHWYp3Mcjc2eO+olVs9yf248mPGUqJDXd8Z8iFfE6ZCfvUBsmCD1f8xkcGUZVZZZk28JXpmzL0NPPp3rQvjRujYGWynBfkuo3yzwzuh80mLA9JTUwNwbhnz2GRyMVxUB0PAQodq+u6py85U/ZU4Yx61LALFjIZjq9Oj+hYNsHBxAeHWxsnVN2mOi7mylckoid+phbXoDc3G8SbPSLz9zW5vruBDcNzatuDkLTxAygVGr2AToeCOxPnxy9WRtFiKbl29eykiBqjBq+I5Ba16vHQisfQk6QbOhUKHdr7/IzSbKc4h6WZ/nt4aL77fSZAZbQtr9TcPlH3hdNRlwcZIwmMXvw01OCCk0QyXq6y0IH2Zsn40jPwBBQj5eWqrEBHdH8MI9OzCC2CjNR7JbVAjVM4Q6DHh4Mx+BxwEaKX7mc1frhBKxKkuMbmBr5hFhgxVu72S7P3oPUfiM3XbD1QEEktPlxNkbBX8WWjUyUR6iyQ23FfUJJFuov++vY9kpJqGEJemULi1Semz7d0rIM3/MsU08Gujokz9YPK9J5qPxhVhepxGUdrNEEj4PaXdTnBLrcbZf/aLDOItdOVH5j3j5oT/NCqSCB4auOPoR3cSofSj2T62Ml18yuMLMShPG3AWw2pZMreLLZNbeNqJVIFCe3QOMfEvANG/wxJArzDzcrIi4M6p1y2EcJe/qhrRuI9lwHUqbC9TTOJMp8nglpwB700TGv/UT58tOpfFkCvj6TbcIf70IFFczhl1y/KCqqk4ptq8vpqpaN4UbwI452lNXApxX1HMVMuwDPG6EtF65R5KGGFSjHOEibPvpugnDLdXHlIdqMRcPmGxP1bKDFnCTeH8WHNsMqE5UAcTkdQKIvSC9b3zu+M4oxv+HGzDICG9W1P9KOFm3T9V75wIMUv2FwwcDK7tDRNPJyjTIXRwdQJlnNMfaJNIqnC3RomQRIhow
 GoN7/tqa
 9/TtwFAcPCGavpy25ePrRExr+w2zWwu2KVEgbWt2EAhqIM9gnMeg4dXgGvPn6MgxUvTVX8Nk4S8ffarDAlxOz7x5+BGkNr/xrBI3S62+J+FhgP7epCxGpSh12m6WsHmJcmlxuIf75YT+DKTF+RMBF1+kkofFnM5rcdSnrZ7fdQZt2AF4wBeULDokK5VYE2UmBVNBlS1kQl4XV/i7pD2SqAQBYyDzoHpMX7jEv5QPMIpEvzgIqC7Er8mcrSIjuMPLfNuqtH776/qQ53oa/jEHZoWNsTIG5q2ykSUdijRn8lJq+1mFm7GDCSs0cTFX29WkGFRK85TJY730KwzNPmcZpR0+2TPr0nlcEQpnRjFDtZECDPESEt0ZJTyAqaUBE4rXj3CV0aoYSFAla6EiL3LEIGgCcbJXMluMyNwRAruM0aqN/oAr6GLQnkdeLIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 20-08-26 13:50:32, Shakeel Butt wrote:
> On Thu, Aug 20, 2026 at 08:44:34PM +0200, Michal Hocko wrote:
> > On Thu 20-08-26 09:06:29, Shakeel Butt wrote:
> > > On Thu, Aug 20, 2026 at 09:06:18AM +0200, Michal Hocko wrote:
> > > > On Wed 19-08-26 18:20:10, Shakeel Butt wrote:
> > > > > @@ -2254,9 +2264,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
> > > > >  			empty_slot = i;
> > > > >  		if (memcg == READ_ONCE(stock->cached[i])) {
> > > > >  			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
> > > > > +			if (stock_pages > MEMCG_STOCK_HIGH) {
> > > > > +				memcg_uncharge(memcg,
> > > > > +					       stock_pages - MEMCG_STOCK_LOW);
> > > > > +				stock_pages = MEMCG_STOCK_LOW;
> > > > 
> > > > I would find it easier to read to keep the update in sync with
> > > > memcg_uncharge, i.e.
> > > > 				stock_pages = WRITE_ONCE(stock_pages - MEMCG_STOCK_LOW)
> > > 
> > > Sorry I am not sure I understand your suggestion. The WRITE_ONCE() is throwing
> > > me off.
> > 
> > Sorry, brainfarth on my end. I meant to say that stock_pages should be
> > updated by the uncharged decrement rather than capping it at MEMCG_STOCK_LOW.
> > So in fact I meant this
> > 				stock_pages = stock_pages - MEMCG_STOCK_LOW;
> > but then shortcuted it to a nonsense.
> 
> To fully understand your suggestion, let me walkthrough the code:
> 
> Let's suppose stock_pages = 65
> 
> 	// Original code does
> 	memcg_uncharge(memcg, stock_pages-MEMCG_STOCK_LOW); // uncharge 33 pages
> 	stock_pages = MEMCG_STOCK_LOW;			    // stock 32 pages
> 
> -----
> 	// You want instead
> 	memcg_uncharge(memcg, MEMCG_STOCK_LOW); 	// uncharge 32 pages
> 	stock_pages = stock_pages-MEMCG_STOCK_LOW	// stock 33 pages
> 	
> 
> Am I understanding you correctly?

Nope you are right, I was clearly not thinking straight.
Sorry about the noise.

-- 
Michal Hocko
SUSE Labs

