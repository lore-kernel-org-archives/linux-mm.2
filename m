Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D792CE7B08
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 12:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95FF08E000B; Fri, 14 Nov 2025 07:50:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937C18E0002; Fri, 14 Nov 2025 07:50:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874178E000B; Fri, 14 Nov 2025 07:50:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA5C8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:50:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2625113AB57
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:50:10 +0000 (UTC)
X-FDA: 84109195380.04.1B088B9
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2EA8680010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:50:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763124607; a=rsa-sha256;
	cv=none;
	b=AUcVBvA4hcrRJWsCXadn8eT6FyVOltedlE4nOi1c+0bGzcm7lCRii8YeZqtjddRQLeI4Nx
	JGyvNWhDtUoM4nOkwhV5w9+NKhjA4V4wbUVamCAblKzHh8QAIfeb72EGG+60Ki+F+pLV6I
	QqAukHfrM1KA8KWOWNoWD/WZCVAqr/Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763124607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bYaLI7QAmVU7GiJU7z+IdGgZ2/O58hzIGFV/EOmiGRU=;
	b=64dDiAx7CEfdGf/+mbYhC0c5+k9+lW+DFSsuOXCXDq2GqFpBtD2NB8ozMa5HfrbrYVMUEy
	RHCsZ4MHnk7rc+sVuiugEUBc2KWXoxHhJfLlL22hpEf6nnK9bq95oYcPnPiSP2T/Oq6JY9
	1Hg1/bpOszRRSsZ2ysQ1/bRqFzbOT6c=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d7H5d6tbYzJ46jg;
	Fri, 14 Nov 2025 20:49:25 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id AECB714033C;
	Fri, 14 Nov 2025 20:50:01 +0800 (CST)
Received: from localhost (10.126.173.232) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 14 Nov
 2025 12:50:00 +0000
Date: Fri, 14 Nov 2025 12:49:58 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>
CC: <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
	<linux-cxl@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-arch@vger.kernel.org>, <linux-mm@kvack.org>, Dan Williams
	<dan.j.williams@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, "Peter
 Zijlstra" <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>,
	Drew Fustini <fustini@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Krzysztof Kozlowski
	<krzk@kernel.org>, <james.morse@arm.com>, Will Deacon <will@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v5 0/6]  Cache coherency management subsystem
Message-ID: <20251114124958.00006a85@huawei.com>
In-Reply-To: <20251108-spearmint-contend-aa3dd8a0220e@spud>
References: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
	<20251108-spearmint-contend-aa3dd8a0220e@spud>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.173.232]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2EA8680010
X-Stat-Signature: 4i1zdbqr5t89x765utc3fp9ruqkh9eon
X-HE-Tag: 1763124606-117307
X-HE-Meta: U2FsdGVkX1/F9x/Rj/OrH7k0iBzTFs3M7AX+OdtVyIARFtJrbB4appdS7KLJXPbPoLl2qXOTJNMvrtDwVuClYQH/mLI+uzcV/YY67+C/UJTwmtm2krZR4ZXpJ8n4yYekA+NKcjrei5O/awvnwcwIAp2jFlX5eNA/6uk981grCgoBQH0HvwIxBzMVWGUkB9TKSAfDJcsdVb48kx+/WA1kAm0htVBi/3jynGo0k/McHp6FTloo4WrQU62b2X/53f9ioL6SqaLS3vEINe/CbYxPozkisyE/+7el6eGePLl0Arux9psaF4K7gTFkpmnlA0OEQ50FiOjioZPmKUDudwOSZe8PH1EEb9oDSBsk8pz/xsUfKpGMEAXvXPY/gDBRbkSFYnlLfZzpgl1S57nVVC/7vfavMGfma9Dl4kEZw85MpOPw7T1IYcz5a90AiEldUPe3TmuKMs51QDZI/xObO1y+AtY1g1fQKArnvRxhTJDBv8WXBOqfgovSCoPJhZZv4uPJ+ZV/RvI/py2oJyn/zJvn8q1y7nA+FY1trKSL+bDpJkFUIhcNtmkFDcfeMWcrgBVWb02RB37MEwXN8j2CmYVfuw4OYkZthHdaWQiDVzHqpAW9DbLc1cR1H88PAkdp4165DOkrVN3z9zKUmXt9Mo7e3RhohjmpxzRscXL+qwluaGc8w6GgF6TpGTgkhJPW2DL0GpjGDkJvU6QwQNjakyZKZ7AsLapl4eZlDvor2sDHA0OyGT323512AEJphTt+SuYzWsSWx+9s3xU+vqfJKHJUQeVaAowfP0ePRw/NfNMp2NUnrPTGZ1vOuc6Uxa0hn87uUiq3DluQY50juYKIjax6A6HgjgOxblkFzdbYZaGOtwUxOFw+34JYW38wXJzrb8gGgfw49utJxygiYR0r7K9xElwAELtESkORGMJDGt99kA+/teKXqcbLoaW8ulDahnGL0HU4c+fUIv03L6rC+tw
 GM5ikObF
 hQvPyyO/vFbEPJ8DkfevXoH6wXaN3/oUO9NIwe475DkFtQzbp+LqcIXpSDzu3ETAo6lONXk8Qw7brV/ddNU6BYLB9jPpzqVEbEHnsx5Hy4OykObPWqOAi5Ajfo4UMc4RWc+7p5dQGtzaGkfz3Kg1KWOfwhQ9yaPLXkYTO2UVvL/Svu3ryyfiL56RIoD7YkX4XkSx1ZQM23+SWBjAgkzmd/XWaGPgPmiNkFH4Bpn29DSlRC4ozAAceH3cTfmn1VVgLes73oW8YS40utkms/PekreZGqsw/j00q5Ei8OYpzf5cNzii3wQqGGwzFxBSPpzI/dzjJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 8 Nov 2025 20:02:52 +0000
Conor Dooley <conor@kernel.org> wrote:

> Arnd,
> 
> On Fri, Oct 31, 2025 at 11:17:03AM +0000, Jonathan Cameron wrote:
> > Support system level interfaces for cache maintenance as found on some
> > ARM64 systems. It is expected that systems using other CPU architectures
> > (such as RiscV) that support CXL memory and allow for native OS flows
> > will also use this. This is needed for correct functionality during
> > various forms of memory hotplug (e.g. CXL). Typical hardware has MMIO
> > interface found via ACPI DSDT. A system will often contain multiple
> > hardware instances.
> > 
> > Includes parameter changes to cpu_cache_invalidate_memregion() but no
> > functional changes for architectures that already support this call.
> > 
> > How to merge?
> > - Current suggestion would be via Conor's drivers/cache tree which routes
> >   through the SoC tree.  
> 
> I was gonna put this in linux-next, but I'm not really sure that Arnd
> was satisfied with the discussion on the previous version about
> suitability of the directory: https://lore.kernel.org/all/20251028114348.000006ed@huawei.com/
> 
> Arnd, did that response satisfy you, or nah?

Seems Arnd is busy.  Conor, if you are happy doing so, maybe push it to a tree
linux-next picks up, but hold off on the pull request until Arnd has had a chance
to reply?

Jonathan

> 
> Cheers,
> Conor.
> 
> >   *  Andrew Morton has expressed he is fine with the MM related changes
> >      going via another appropriate tree.
> >   *  CXL maintainers expressed that they don't consider it appropriate
> >      to go through theit tree.
> >   *  The tiny touching of Arm specific code has an ack from Catalin.  
> 


