Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABE0AD3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 16:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75166B0005; Mon,  8 Dec 2025 11:29:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4CE76B0007; Mon,  8 Dec 2025 11:29:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62E86B0008; Mon,  8 Dec 2025 11:29:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A44876B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:29:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45033C0241
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 16:29:32 +0000 (UTC)
X-FDA: 84196839384.12.2D27F73
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 09C84A0009
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 16:29:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765211370; a=rsa-sha256;
	cv=none;
	b=xyEjs1A2Ha9TyBZZWUxAQhdp4ScBkwSDWeqeiLOtNKoftiKVgK0nBMkE+K3d8qyJrAZmS5
	aIKpLlY2xSEwiiKjpeF3Jcg9TOd3ezOvMzrqULHG6CmD/0oueIAZkUgyf+pMjbRE6pgRBU
	nBnhlXC8wyWwNkcVSGrUJlk7kFJnhQ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765211370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wiWKTOWf28Kw9tRcwwsL/2NSPuC962ebgl+JWXOTXLE=;
	b=5gUWrxu8FzwmrP95xPeIEA2CywgSo6AOUN41RLRfHGJfLIvwsmqn6bZPuSlUpx6NnygRbS
	2jEXkfmzsTZ66OT9+dvcFPJsKN/FaXfYvpv4x/hf19ZQEbyG9rPu+WcovyEqK1z/K+ha6+
	ycEtiNKy5gn/MlXUhcpW1+RjG0AORrU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dQ6rH30jGzHnGjc;
	Tue,  9 Dec 2025 00:29:19 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 37DA840565;
	Tue,  9 Dec 2025 00:29:27 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 8 Dec
 2025 16:29:25 +0000
Date: Mon, 8 Dec 2025 16:29:24 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Borislav Petkov <bp@alien8.de>
CC: <shiju.jose@huawei.com>, <rafael@kernel.org>, <akpm@linux-foundation.org>,
	<rppt@kernel.org>, <dferguson@amperecomputing.com>,
	<linux-edac@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, <tony.luck@intel.com>,
	<lenb@kernel.org>, <leo.duran@amd.com>, <Yazen.Ghannam@amd.com>,
	<mchehab@kernel.org>, <linuxarm@huawei.com>, <rientjes@google.com>,
	<jiaqiyan@google.com>, <Jon.Grimm@amd.com>, <dave.hansen@linux.intel.com>,
	<naoya.horiguchi@nec.com>, <james.morse@arm.com>, <jthoughton@google.com>,
	<somasundaram.a@hpe.com>, <erdemaktas@google.com>, <pgonda@google.com>,
	<duenwen@google.com>, <gthelen@google.com>, <wschwartz@amperecomputing.com>,
	<wbs@os.amperecomputing.com>, <nifan.cxl@gmail.com>, <tanxiaofei@huawei.com>,
	<prime.zeng@hisilicon.com>, <roberto.sassu@huawei.com>,
	<kangkang.shen@futurewei.com>, <wanghuiqiang@huawei.com>
Subject: Re: [PATCH v13 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Message-ID: <20251208162924.00004a38@huawei.com>
In-Reply-To: <20251125073627.GLaSVce7hBqGH1a3ni@fat_crate.local>
References: <20251121182825.237-1-shiju.jose@huawei.com>
	<20251121182825.237-2-shiju.jose@huawei.com>
	<20251125073627.GLaSVce7hBqGH1a3ni@fat_crate.local>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Queue-Id: 09C84A0009
X-Stat-Signature: 53nm7medym9mopbofmiiz5trk4j8ea7y
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765211369-108123
X-HE-Meta: U2FsdGVkX19S9D+cs9yc+nsfYsZq1nPTvOoIrx3eSyZ/VnAfAikjQt680FlYKYARpL93mbPvl8ymkh6v3Im0ndvQHdAyxUPrRBrvMTAMdVttdPnNbbh4YRnQHP2cUaBKRlBbE9B+2cD2tYtOnHRzUp1MeLVo44FCmQWSU20FskQkDFyGd843FxHxyBG7ciqHHMP0J4sbqLokigl0tAsrTvYsgPgDsLRE5Njn1MrMWh1x10kcCUszSoRdV2zzz5lQ0l4QKwOFLUKsBePoyWjrSGnT/OhTqy0V9biQW/W3wwI8jUDzJpWzGmqGBOfnKTZdm+/Wgvlm8y8B657avIORgR71OdF2fJsEs4d4OQxAj8reoKHnaNa3DzYUSHa37WRplVSaHn6OvfBys1hj9+ihYRDw/fCIwEsXi+dX/zTzFkYkGca5HzIg/6+O2ztzqOXQMsumiFN+CoCVZGtqQ8R0m2ysdMZzDmWqwsUqiSq9FkYmLDU0ZqQeDk3urav+vxdSdqkDi01QmOY4h31x7s/umblVHbp2QrOLI183kOyTYyOy35wo6763zJ0HYbUMVZ0ZTzgXP3Q37aYzQ7pIZ2tqx4F7OJZhMO0rUnSQagsFB3YsvXxsiPrJNjAvcfLrUsuGFTdr+8PgkY7jnGACcDsMjhtQJ7JQH3RjW6658oEdIObtajfiZ/1haoUEgRSk6TEVYeTSAzo5h3+5ZdvzJbSHTsnAM0VuEU8AqNjsZeif29KpHTYV6XjQHnebDTJoiKpVcYbq+c4OgTUyNeiK8tTsPA8mjT2bQ7ASk6SdfIGgxxzvAt1obfYQY8FdhpoNOPqFaW2j2KoH+eqULM8KnLIMOXgT5Ca78CHPH4f8eMwppMKHPsW7l3VIdfE+SSVHScjECP85w24GFYvr8eyMgfJdih5lnNiZI/0DUYXK9bvnhUhCQz8DuAjoepjNeSqhyRDI4++obAKCWt8VClGORvX
 azMjykwF
 04zCHJdJOPqLE/qkBPvJL0C6pusXp4Ef9Nxc/IugUxl5in4DMblkEH9zaxxZOaEZ6LMjhLaGQq2BGdZ0jqIUERyPp1qMsOVBmRJhxJ65TSwcEzbLYulFYLB1tCoEhN/WLtWLQOGb/KWFWDsc/DpRJ0AN2HZNt/FNb3b/nCo2AXluL4drkwdL4LNsA+CL2jB3wofGT63UNnN6eICfp8iT6zFpjgg0I2E2QVE2A+yBaeGmqxD1oeR9oR7hq+1wu3T52SzbKemSlw9O5C8Ao8Dd1p9+5WdTMqT7aqba2iNsCy/Q2ziST4aWlDAtO4dzVbLzNGztx5KXio/3gBiw1cKdjsLtunkV9j3+0AxbpulioEuq63EHYqR0kRb+zvZJIV/H1u0aEctojWvehqysLoaRon1mgDEPaBKAwsQ3l9MQHQwUAY/EOHOwGqMJzTUwlBT4TtcSw6HiRHr91MxiJVm8BjfDGJ92Bj7JZWdWB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Nov 2025 08:36:27 +0100
Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Nov 21, 2025 at 06:28:20PM +0000, shiju.jose@huawei.com wrote:
> > From: Shiju Jose <shiju.jose@huawei.com>
> > 
> > ACPI 6.5 Specification, section 5.2.21, defined RAS2 feature table (RAS2).
> > Driver adds support for RAS2 feature table, which provides interfaces for
> > platform RAS features, for eg. HW-based memory scrubbing, and logical to
> > PA translation service. RAS2 uses PCC channel subspace for communicating
> > with the ACPI compliant HW platform.
> > 
> > Co-developed-by: A Somasundaram <somasundaram.a@hpe.com>
> > Signed-off-by: A Somasundaram <somasundaram.a@hpe.com>
> > Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
> > Signed-off-by: Shiju Jose <shiju.jose@huawei.com>

Just picking out one point where I disagree.

> 
> > +
> > +	struct ras2_mem_ctx **pctx_list __free(kfree) = kzalloc(ras2_tab->num_pcc_descs * sizeof(*pctx_list), GFP_KERNEL);  
> 
> Function member declarations at the beginning of the function, pls, and then
> you can remove this ugly linebreak too.

No to this suggestion.  Doing so breaks the rules that Linus has laid
out for use of __free. Constructor and destructor must be next to each
other. See guidance in cleanup.h.  This stuff is new, so it's perfectly
fine for a subsystem maintainer to say they don't want it used, but
if it is used then it should be done according to the agreed style.

Various folk have already experienced a grumpy Linus when they put the
declarations separate from the constructor.

FWIW there is a long thread on the ksummit list that repeats and
extends the discussions that lead to the guidance notes in the header.

https://lore.kernel.org/ksummit/B92B21C0-093D-4F52-A7E3-1A7DDC83749B@zytor.com/T/#t

Jonathan



