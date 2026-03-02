Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F77E9B365
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0232C6B008A; Mon,  2 Mar 2026 07:15:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12B76B008C; Mon,  2 Mar 2026 07:15:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3C236B0092; Mon,  2 Mar 2026 07:15:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D4E246B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:15:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A91F38CF57
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:15:45 +0000 (UTC)
X-FDA: 84501019050.28.2CE2153
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id EB9C380010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:15:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772453743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hTdjfwBol4y783SVyY3HrPYKSjRGrzbwRzfEkfE4F9s=;
	b=LsaUaX1bCq8CSPxC+ILkm76beiAP4fSLToIt5VN8T6C342E3VvA1W/P+LftUeeVrVGL/UW
	W1wtHZvWAtZh0vIoR93l8fsWceVUhVg1r+McT7b1cpr/yn48kV60M3pAzIPlTFVtvZOh5L
	yD8dtMgTQt1wJXC0x7ybxh53HsHbOqA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772453743; a=rsa-sha256;
	cv=none;
	b=tGVP621ZUglqiJsvebUHRubhcbE2AykECUVTFe/DICQo4Dw2GG8ybl1tCRnBIlMsVpEzNe
	Lipdt/rJQpWjljhtxKQEtADBIz/xYo9rhIWJe5fX5HUt1QSYDmhzMocqg6VoL7U2d5E8wV
	0Hr9cjoVbO/ZEHkdqHpcuPvOSTiFw0g=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fPdDB0LjMzJ46Yf;
	Mon,  2 Mar 2026 20:15:06 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 6CABB40569;
	Mon,  2 Mar 2026 20:15:37 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 2 Mar
 2026 12:15:36 +0000
Date: Mon, 2 Mar 2026 12:15:35 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: David Rientjes <rientjes@google.com>
CC: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, Gregory
 Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra
 K T <rkodsara@amd.com>, "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae
 Park <sj@kernel.org>, Wei Xu <weixugc@google.com>, Xuezheng Chu
	<xuezhengchu@huawei.com>, "Yiannis Nikolakopoulos" <yiannis@zptcorp.com>, Zi
 Yan <ziy@nvidia.com>, <linux-mm@kvack.org>
Subject: Re: [Linux Memory Hotness and Promotion] Notes from February 26,
 2026
Message-ID: <20260302121535.000001ed@huawei.com>
In-Reply-To: <855370d6-811e-5864-b93f-c5bf4b6e27b3@google.com>
References: <855370d6-811e-5864-b93f-c5bf4b6e27b3@google.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB9C380010
X-Stat-Signature: yzj7kehukfkafy5j4sp99g9ob8z6ehcn
X-Rspam-User: 
X-HE-Tag: 1772453741-87108
X-HE-Meta: U2FsdGVkX18XCDZJAveDa6loL/CR/gO/X79NHDh2wKQvPuWVmtLFZVRVQIDIxx18PhFE0kLvLEVAouQxEmfdBuhvM554QS2v6p+6ND9wb9/Em8h4OnvY/fdKr4L0GpxXXHMWK1h0J0niLh7XM27AEY+41MUSNXyulH1g1Wsn+8ILV2JOi8ghdh4Shvq58r+jEsOYBWrYgTlHz1nfMeSHcZhIMQNVVysv8vfCaT7PudjdfcAvKynxN5r+zSaOu+kUs2A3kbEuB+RIUZ/bI7GuJp+8LStJkLWrHFvFew/9GEKGINtePm8DBtadSnra6IxDNwLfhHJYBJ4HtWtQNS2ZutAGdjyMlbecHdk58Tjcw6zZLrmD9OH8zE4TPbtJW/DQEeguT1Q3Qzg331AQoHgFWtooerAFPXFjH/6zizlHWxTZicU8hN3D62KwCz5R8UkHj1vDN0t75BjxPm4b/UizQ0HUA6IR0tyryU5OpyfkATn8s0btvGj2lkU7VoS6ICM7tjIhcvVxMWXfYi3zQE5dfy1njt/CXR23aeRAAzm6VMB4XzPjlP/HaEb8odiwMKcrSOvH10VeecZYQ9MnCVkTCErPknQMmQIWiMz2RjUNfvx4P/Ya/gIa988b7LUGZI89iokOJd2FviLv+LRfLRe6xmkySB0S8FARAXktq2uC+lhOWpzrbuxW90kjvy47+nYApw7TznKclvR2xNSquUhuZYNJL8/O2ks3iuYXxvsJAS024nlWJ8YT/+avAUaLyYX6+hLIJE8hY88gyORL3NJbvWqwMyC5aS2O2rhP8/yciKrKWuehMINMWIHHeUOwO2NVk9CxOKMXFs7nitz/Kga2YT3vwi35zCRF3q1pEwN4xx05Fa+ycT/ivJ+X2lJt3Zi9jHGv3GqMFQGN0YNLaszExVKPxP1zKgPgF6mW66/1gTO+/EwqRj7h3IIOYFNnND7C7xAjKD2qUyBJFtSS1c6
 NeLE7ENl
 94JAeCzeR5EIcrdfwIzgSp0jO6xs7a6vs5CthmTRQK14fMr/Ksjg6YYSGOF5Ajus/3YMCapSTtrUIHpqdjkqAHMU+7O5I5ihhEdLQdi0Pm/Xf6fdVmP5lQcBsMNSh4FTGNty333HB5b4E85t6fn7A02F8NUGDnC6DBdedn5bwOw1k/EwRhLtgLjPbmWjhHtLg/BIHczPCWV287+gOyBK9YOje2C0zMutKJhDILvDjpTYmpti4fN0H9blTuxI1aLDyd3Fr7T3CnQxm6yAxMmhTAWs+npV6CRaIEFEhvt/pC48rj+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> ----->o-----  
> We touched on the CXL Hotness Monitoring Unit (CHMU) and whether any work 
> was on-going to abstract this in upstream Linux.  Both Google and Meta 
> were not actively looking at this.  Yiannis suggested Jonathan Cameron may 
> be looking at this for qemu and testing.  We concluded that not having 
> CHMU support upstream is not currently holding anything back and it might 
> be addressed in a year or so; it might also be solving a problem that 
> nobody has yet.

On this, sorry I didn't make the call.  Whilst we have some minimal support
in QEMU for emulating the CHMU to allow data capture, and a tracing style
kernel driver my priorities currently lie elsewhere. I might get back to
this a little later in the year. I'm aware that some others have been
experimenting further though but heard how they are getting on yet.

> ----->o-----  
> Yiannis brought up non-temporal stores for tiering and the possibility of 
> finding time to work on it in the next few weeks.  He saw great value in 
> this from the compression side and was trying to determine if this brings 
> value to CXL or tiered systems in general.  The idea is to extend 
> migrate_pages() for the demotion path so it uses non-temporal stores -- we 
> don't want to warm up our cache for cold memory.  Gregory noted that we 
> want to ensure that when allocating the folio as the migration target that 
> we would also need to make sure that's not in the cache for this cold 
> memory.  I noted that Shivank from AMD had previously presented to this 
> group about enlightening migrate_pages() for hardware assists and using 
> the "reason" field of migrate_pages() to differentiate different use 
> cases.

I'm also keen to see progress in this area.  There are lots of options
for bulk movement of data and tiering brings a specific set of constraints /
opportunities that perhaps don't apply so much elsewhere.

Jonathan


