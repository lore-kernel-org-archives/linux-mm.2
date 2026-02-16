Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2570E81A3F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 16:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 114DA6B0088; Mon, 16 Feb 2026 11:13:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7046B0089; Mon, 16 Feb 2026 11:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0035A6B008A; Mon, 16 Feb 2026 11:13:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E02B86B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:13:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 923191B545E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:13:34 +0000 (UTC)
X-FDA: 84450815148.08.35A1113
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf22.hostedemail.com (Postfix) with ESMTP id E1F8AC0007
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:13:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c8XLrnX1;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771258413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yEJ5XvR25sXoqOGNkg3EARgXM9Vsv7j5sELin0pzSgk=;
	b=ahvfoWnnV3/D9muoiZbq6hv3H2ZD57HsoW0K6zW1DVaHK7v2giOd8KicH2/gOM7lOXUGX/
	s4bDAkXh6rHB9kHA5Md7EKgepW7KyF1hXhZ8uW5Z3hl5VA9nLGTGrrGU7HOsNLFh4xAT5U
	dA/tT0ZgC8Uq6oh9xSEqy8Y8ft8s4og=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c8XLrnX1;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771258413; a=rsa-sha256;
	cv=none;
	b=XXPAg91FkJtGiU+jKJ/RSWAUIxQO/YqNL4LvoMjOnSCcbqBmHengbpY33YNn01322/mzOd
	UAxtjzwGbwfcMeZJLemrHr3z1H0hYtRb1Pd3ViPs3HII+tUpWS/6nbKq1AnBjL8T73D7aV
	DHKUjwJ1L4l85gVV1ejwC+MMNR4eKPs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771258410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yEJ5XvR25sXoqOGNkg3EARgXM9Vsv7j5sELin0pzSgk=;
	b=c8XLrnX12RT3ltlhocYhfvfPUctuYDZKleznOrVR3zi9mOSYePzGZRsxPNmGk6J/FUD3ME
	ZxEmQfr9BExV+vYE5W5cv/Ix/VhWA2BpWQP1DBxZweQqzFInCyW1HtDzt67O5149Px4gho
	wObQ+K2SdLr6UpeJefyD4jzhGWZVPMs=
From: Usama Arif <usama.arif@linux.dev>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhiramat@kernel.org,
	mhocko@kernel.org,
	rostedt@goodmis.org,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: Re: [PATCH v6 1/3] tracing: Add __event_in_*irq() helpers
Date: Mon, 16 Feb 2026 08:13:21 -0800
Message-ID: <20260216161323.4098568-1-usama.arif@linux.dev>
In-Reply-To: <20260213181537.54350-2-tballasi@linux.microsoft.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E1F8AC0007
X-Stat-Signature: 77448jwmib4cb4wnzj96k13hnbit5axo
X-Rspam-User: 
X-HE-Tag: 1771258412-850470
X-HE-Meta: U2FsdGVkX18O6d2JAYH1HQljT5GGutkHQznJ/uCFCBcEp+JdKwGQ3g36L6NihF+WecVaORwWBm/j36Mu/G/z3xoEqJiNAd2kUVnKk1XRSEZywWqbKXqGtbv4zaYrWQ+aK/14mXvB6ER2kAebBR5q35UacH4Qohs2R54Lt8ZI0lKFxzvNKZ2L9GN0eIqtXvc8tAzF9QgNI1mP9qqyp2VuSrqgTBXYY7jbq47tpXqGL8wlOi6V1GWjxizVg4aAqVpXX1yDolT9V11DaSedc06hMm8WZ28OCiYAiYvtKThqUp8V0N6glTIny++QXdruuyAbRN8X3Ki9XhNc2uHA/dPvMnsiPsxW3MnH+HQohdAke5h2FU0L62sAb53dTQivhnAjmcFM1w68gQIfGViZ53y/MbLkjxqP5OtPh/vSTQwTTNJ+UucN3YC9mYm+MWS9a0/E+iEix65yviFv03fv3BsW0a637QFJd6hrgEpm1YJzAVGCcHZr4mhbdPCFRIastfG9aA0LH5L14aN8s2czosKKnrGy2gQGQQ8l/kE7dOMgLoAf8RCMSY4wLstX6wivnVzUXO5ejQ7/FjK3rTI/5L21sihjONkKwKb5CXpHPE75k7p71JTERwexHPJiJY+jCGQH8qlhIvmNg+aFf+uxtkpHAwvgH9VflwVVI9nbAk7fmjUEZfTeeETXv95EguQ+GijXoTiIu2XCUCLWq4ltqfp2IUMuwIh1UEtjzoKlIiUR8S68Soyh2GfNywr0+hJyfwYGLXgskW00X9hLIN98tvWkK+A1OQE6Dw2Ob+NbggOwAQguPIfvh3SKYuDO1Cu1rr4ReLC8MepDgpNnOZBYC3CfV+6wk2Z4RkNtIhpc4o7ZspfIIjbt1twTV6cwTnCcJdYeQzgMcl+KcVBIr508aqGFallgl/kyvoQVWoQ0xrms9iIWbjCxbYYuZCiBjlTShBKop8jgZm6+XRfgjSD3qdx
 ly0ibImm
 NOMfjzsIHRcBgKFOI1pthaifci25rG7g88irSBcqE4XrA3nSmeOVKfMzcATsq/f79vekqDWMGpX2Jcz6qBTy3ilj2f4otjVkW4NOKiKqVPjXdNCEBzAiVml3nVjxDvec3k9UP/qty5EE+DW4jhGRwp9Q1k84AyXWtIyeJY8NVlzZghsR8eP8Xe05yeTaEwCsD/DL2+YzeZVHpVL95cuvJ0rmzJimqjEumqHcxvGnzm44YMtV+p4ipJ13fYkkzZAv2X/HL7R5jDNRWScxVdCA8tjYLgkY/3B/jsE1dmRb12tJ0KqdSRBaVVER6Xobgqjsj4mEPT3gEVfC5APX1gmAiy6qTwvHhiwAt5C9C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Feb 2026 10:15:35 -0800 Thomas Ballasi <tballasi@linux.microsoft.com> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Some trace events want to expose in their output if they were triggered in
> an interrupt or softirq context. Instead of recording this in the event
> structure itself, as this information is stored in the flags portion of
> the event header, add helper macros that can be used in the print format:
> 
>   TP_printk("val=%d %s", __entry->val, __entry_in_irq() ? "(in-irq)" : "")

Should this read __event_in_irq() and not __entry_in_irq()?

> 
> This will output "(in-irq)" for the event in the trace data if the event
> was triggered in hard or soft interrupt context.
> 
> Link: https://lore.kernel.org/all/20251229132942.31a2b583@gandalf.local.home/
> 


