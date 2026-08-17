Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89838C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 10:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743B26B00C0; Mon, 17 Aug 2026 06:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4606B00C1; Mon, 17 Aug 2026 06:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2D46B00FB; Mon, 17 Aug 2026 06:12:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 209EF6B00C0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:12:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96F74160670
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:12:27 +0000 (UTC)
X-FDA: 85110346734.13.6C9ED56
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9129A20006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:12:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="x RQqngJ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=CfTV6G2L;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786961545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2HZwQB8X79/qdi/4/eTag5lQ6IwYEUzzGIop06qT48=;
	b=Dqv/hHOzRO49ElznBsYDOcFeGZ4S1TgGUctCgZfA+rlUY4DSVjswd5yYEXe85pgXxdgImS
	EA8JsyARATve4z9D3Vu+aSdJQq5rWmESanjfajF5RahH02K7EWZHkBGKmMMHeAAEnElGZy
	F2GRMMx1VaK32MvzG88P53ys9qqUDTc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="x RQqngJ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=CfTV6G2L;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786961545;
	b=RIUGRBqshtsxAAEFuquafNstANpCAtlm6D8iv1ArXkJXAwax3FKhkJkpJbYnEkCYs/RoYx
	+KeePG1sW6zAsusRhCVSihFLajN3+g70bR4taVweNdLN719NdW7GHPYzKGqt/lnS2yUAEP
	vIbFAdPTMMZpZqy977ABap60kRl2ToQ=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.stl.internal (Postfix) with ESMTP id 63A571300117;
	Mon, 17 Aug 2026 06:12:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Mon, 17 Aug 2026 06:12:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786961543; x=
	1786968743; bh=X2HZwQB8X79/qdi/4/eTag5lQ6IwYEUzzGIop06qT48=; b=x
	RQqngJsQvZrHf0s86jYgcXCj5Nva4QQgYdFLWvnPsm5pHlQWL4f4JsJcJmhZ1KQd
	ebFLHWOBGxdPAmJtctVNUyRxj4+VhIKyNK3YnVAl972sH78EIK6ce05LQA1UmvkU
	Gc0qqJ5KtPCg5gpc6OycPPTdXp5kb76hiwcFxd6wLtAauHCP/cYu4yRlnS/I0yjs
	UiNYqJKPGN+Zk0j7dIYGHCZ6IHNKZAZutsmJpaYFEHXXzjaNobM3+E+I30W4Xu50
	CkT4YMcOK0UsdcX7N/2ylmqshv+nlx8VmsGzHdAQQOacPUw9o/w4fiTgYAL2VncB
	gc/zLvswJrx8vPKiXrWLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1786961543; x=1786968743; bh=X2HZwQB8X79/qdi/4/eTag5lQ6IwYEUzzGI
	op06qT48=; b=CfTV6G2LTjN1icCJK3DcPrP9QPJjVSJHPG8zI/AUFBKAc5iZ4xi
	BEA1j8oQreIWLuZjLOeq7e4byBwT98UUCgo1D0bLn82yuUMTZU4MxtGr2rV3/LAq
	ncbRIN7DVdoL71TC5/EEaQ7K3gsezUrzmGlp0zVOEyNLHVPxo8L4R69Flq2iSwuf
	2KPlbdSf8PPgZzMEF6QGo+EBmKJDYufqpS6CR1Z+1v9jmcHQ047HbO45s30og0Mv
	rjxJv16nupiABUJpZxDIh4swNyobXKpmzNbgJO9pxVu9ltBYUgDTjlonPcz7tHJT
	60r+kqnOk6LGF3nAFaaIclnFyXE9txjhnyQ==
X-ME-Sender: <xms:ht6CajzZR34q0SpE3IBGlWMzV0HsL-On7sQsj9W0qut91mX6-gWjjQ>
    <xme:ht6CarveJbz5zfChiOhwbUClj7gzKj2j7UzbG_Z7gTfe2kKYdHvuMQeL-DwdBY-jE
    NiPYswveJGNCTo9suitCqpiy48ahU7evBboWLm-2KKLJFyTz0-k4wQy>
X-ME-Received: <xmr:ht6CauxtAk3icX5Uj3LwCKfQQvgQ33e5GquzNj3jh6MWY81ykc2npIuhqco>
X-ME-Proxy-Cause: dmFkZTE04h/Xk+B6F38wg1Z4C6OmnrAKlBfM7UzM5EIQKp4sCWLVWOi+/U7GmJGoQVV3aU
    PCZ6qKdMqIGgdq11Uk+Bvg3GH0Qksqp9icwfxUi8xTi0VgIM9ofTpDppNiUf47vBs6CnCa
    61NgyKhphhFRp6j0B1wVtMY/dUPe6YISZOK/wa2GNLF6Pdz3RFO7QexzO+CH5Dzon7VkqL
    cUykLN6rKkOh2b64Cj4PEuZ8L0YOl6N3I5fW9T7NeStA2TOnjgJqfJ90ZWJWfkCgUetW8k
    BwRmAcnGQoAwDIW3yl/VOiIdWYaNABY6slB4PBxG9o3FolT+tORmcgvXoOLN6jodX7rQHi
    jtZcozexYhIZ73a4vTqm+HwRcZ+j4fnZ7nH2DgowV2OWuwKGUJjmojdWA5wbuU4UfE4WCr
    XiSNq/MJrOKZsWh0BQ/fdiF/3UIo6WSAigw1v9d34tpR989iNEBeznfkd1GbFPo9SDz+jM
    ukwd2k91H36BTEsP23SmdgqLLptzUc8tZxoDRdMmYEe2tkdWI5GmKU5pWWItjEYqXvpUoR
    eRoIHtCk2h7wkLc/+7cF2eDgtfbj/UX/q/ipDTHmr6VYhkwM0NuLOf6t9SW2CyIZhZZGuv
    JE79Jf/na2ye8Z/yLwVLL8B+/otnZA/k62pQwiGUk3SREVwoN8JCWEH9X3kQ
X-ME-Proxy: <xmx:ht6Catj8BSPlV6w5NE2AfS7My6PfEb6qYAePZKZcqv2EbIDrekWfyA>
    <xmx:ht6CakYkZruLAxRYLQcbZXIs0Lo_GApO_kKv2aijIaD26LH4oRaL6A>
    <xmx:ht6CauiQJ3zXuSu-QM-XGtUkcsIqBNywZufZq5nCdi6ytv4f0seGig>
    <xmx:ht6Caj81ZylIxOsO7YPadr1koFSi6F9Xcjdfa_-XQ1wfWK1AZLi98Q>
    <xmx:h96CapKWXoutgBeqJ8uTcWbxvl8CkWe79PwwUwJ5FsBS-iCjL65xbjOI>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Aug 2026 06:12:21 -0400 (EDT)
Date: Mon, 17 Aug 2026 11:12:20 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, akpm@linux-foundation.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, 
	usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 57/57] MAINTAINERS: add an entry for collapse
Message-ID: <aoLecacFrU6bqmp5@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-58-kirill@shutemov.name>
 <aoLASuFkQ3rUrWa0@lucifer>
 <985a5b95-e2af-4603-b2af-973cd634cb59@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <985a5b95-e2af-4603-b2af-973cd634cb59@kernel.org>
X-Stat-Signature: rrgrxkjdbmt1foj4mowsmn5i97ntw3bq
X-Rspamd-Queue-Id: 9129A20006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786961545-510235
X-HE-Meta: U2FsdGVkX18Ox0/Z/JKreXNNHEZxVTrOWPgzTSqNQOVMlX9XRkDyisceXIxwqb/D/syKoXdkKtxQRkKQ7huy6DxrvKoqis5e30QU3ZzEU0gvJWXgc5YW7ft59JDVauPKzoY9XeqDHLvNeeLYunc1ZzlIS5uq4Xb0eYYNSjDxCni8v9fpOgGK6pG7b65JOF3PUYaYGLUqgif0RRk4zL2Lx41H0sN/7sJkoiz2dW5iYon8wpvzvyFrrkjTon9pkfAhhn63fTXUnxzZshjjnEr0i80NQsAKizR/77MPQLxfLZFxlyXmjFQfvlEbxu5Wd3ozEmfExiaCgsuDMEApA2ECOF6Uc2rXX9Nc4oPNI7ibj8Re8Kdav0hbN9eFkEkwj+LddfF1OUoU4plvnd/8MMcduromKOdvvyD+7XolCINSqoUjRnGAypHBJwWrdqP5BE0jAyTrJUVeGPoULBORmTw4jRq9QZx7ozUceOg4NqxmPwyHeX+pOW1btrusmeOQp9OyXMJfJ7i+AZkQKKYyH/SniXhBMJ0STEhIfwl0oaPMUIO6WUp+9Wo6jr8vkaWn3NECFujjvXR4LWs+S6poJ3pSZVGf2UPg9uiW8eyT+tI78zRSbeL5c4NW9+GKICAKd+tHcfda/IPAe/UpiFg7yCtL+QFDK9zD0sQkD7DWHztyE77Y8EheaC9LSzNKS8QdP2Z2MC6di3S0RycVT2esNSW0Z49hQZ1gOwwngtN3X3EBebabF0+NvdLEIM65G3INfbuxnS1ESZre4yR+wPh+CW8TceevU0IuI2c8jLMnj2DWfRD38binAtyvcdoHFlMLW+IPlBwm8HrSzeWgU2w0K6YG0hV8b6GoxEbRKq3pMiIVb/zo0AcG3mOI5Hb7g+e9AU48JQ2kn8kL7AKnUy2B1e9SkGH2RE1OHLm2mqeS4qyw6FVgEV2Q47pA9GNNbE51ZpBtWD0JYEJys+UvOsL7H0c
 u4oF31ad
 QEesFfnVzdN5/XH3CtzvcbJLN71RN+BURmryX9PTP42Kk5fhVf//oKXzWrZq3tUoAiIM3rBdX3mBe/RmprgIBLV7Y2K4u5+01Cu6+iHFqr26VskstppXyrKpQSq7kLfnwDKUZGym9vlKthjWe8F0ZQdMacnFLsZzaQ7jhlI1MmJ7rFd1/LnclhUGs0JFXxSJe0OgnCZTyObvQr6OjPjGdHXSv0cEtEqDWBqSOye+/NYxlW6bpkXdXLlRgeX5l8D6BaxqK1imJiLk/63k82aZWUf3HLBRrtUb79SeOObyEl1K2RBtbClLlrvJMExFdDqyuQEdjO4o+8ZNOQhrCQVPqxJDxa5tqEbRTo9rOM31N/pBXG4NE+HPnF2vrx5S6DxcS1QDZqGH+OdcpgxOKMPGuiBQzaGL5KYoMq9gL2L42/pbCq7IHYk4bBkvYj1xtb3SbxzJ7wHvXh4/b51nNAU9zR6Ca0XrBy4oJJCL9ImlP7/eVOUcWk+1Dbym+VPZSSJ7ZacRBx0TYQAdh6LRHPK3PtXI5nFSSvbFaqaCsIzsp40gd1b+QMpaVChn7mcK09rQ/mkgu07227sBM5Hk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 10:08:32AM +0200, David Hildenbrand (Arm) wrote:
> On 8/17/26 10:04, Lorenzo Stoakes (ARM) wrote:
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 7c179b333e4e..4e4e5030b979 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -16955,6 +16955,20 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >>  F:	include/linux/balloon.h
> >>  F:	mm/balloon.c
> >>
> >> +MEMORY MANAGEMENT - COLLAPSE
> >> +M:	Kiryl Shutsemau <kas@kernel.org>
> >> +L:	linux-mm@kvack.org
> >> +S:	Maintained
> >> +W:	http://www.linux-mm.org
> >> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >> +F:	include/linux/khugepaged.h
> >> +F:	include/trace/events/collapse.h
> >> +F:	mm/collapse.c
> >> +F:	mm/collapse.h
> >> +F:	mm/khugepaged.c
> >> +F:	mm/mm_slot.h
> >> +F:	tools/testing/selftests/mm/khugepaged*.c
> >> +
> > 
> > I'll look through the series properly, but presumably this is a separation of
> > the THP collapse logic, and therefore should have the same maintainers/reviewers
> > as the rest of THP.
> 
> Jup.

Sure.  I just didn't want to volunteer anybody here.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

