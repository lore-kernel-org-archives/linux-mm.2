Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70509CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33336B008A; Mon,  8 Jun 2026 10:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0ADD6B008C; Mon,  8 Jun 2026 10:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20936B0092; Mon,  8 Jun 2026 10:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5936B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:16:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F6728AABE
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:16:00 +0000 (UTC)
X-FDA: 84856944480.20.575B2A6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8716C140015
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:15:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=a6tRNfOm;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780928158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoptLYrQ/yGEg1kcudHiCfX9+RB6G6nAL273PX8CPRc=;
	b=FqP6Q0OS3sPvzN9ZsQJE1zuYkniFSk2XdOHiXB98mFxua33eQ04VS5SLunvzQb8OzTPRly
	2RN2lDWyka5Qn1i39O7/6ytz4YM2TIoaeHWiBF7lJZRlA0ggjLBPvmSgEQMw96P1PvkRJE
	nB2SWk6s7vrYGHQYgN7wMx7TW88QkT0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=a6tRNfOm;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780928158;
	b=fAUYjaWITKlXz6qfprev7mnKWsT61DYe/+7J1nht+OJSUM58HBKr7hctHqO7LM+5Fo50hZ
	Rz3zNMufIp4/jlTtY8uQGdClAPOcWqucNXaD0Q/0ZlgDPMn67Iz2/kUMAMI+qmod5r2P2u
	WTubs9NoVddSQ+FBYAyKD0Az92O/10E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BoptLYrQ/yGEg1kcudHiCfX9+RB6G6nAL273PX8CPRc=; b=a6tRNfOmAflmUrPXXCxKRgWVru
	iNPc/WKDKmTh/dwpZxhTjUQw7yU0VkULPq7LRnfMgRO1+ytdZGjyX9Kieq5r25zoaET0BSP17OF8u
	dBmTPnOWf/2MK+5f3L5mkHsvLWa4ATBctZwb267FWUCoU33MZzXgJy5D1bnuFkCSRzzHLaSrBtVin
	DxtQeWnFL5GfOYbObu+dCu+s8JhX5MtJDcpk68rYjVzKeT4LCzWJpZ6DaOhnUsvUFfCXVqS84juWV
	3xav5eB+GMchWt48uXiSx4JJ02Yn6c1b+wXGSccYNFe2ob5a9AZru2f1wKewsycQOzTHXlv2EJRk8
	ERPucmkg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wWalX-007gH8-2v;
	Mon, 08 Jun 2026 14:15:48 +0000
Date: Mon, 8 Jun 2026 07:15:40 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
Message-ID: <aibN4osY_QF1Rejh@gmail.com>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
 <19f968f5-1289-f573-4406-e5c91dcd8923@huawei.com>
 <e3d023f1-ab6e-4424-b304-55f1294480c3@kernel.org>
 <33ef8821-c809-b7d1-ea77-6e8a07a6e784@huawei.com>
 <21732071-14a1-486a-951c-34de97b7c757@kernel.org>
 <4b27467e-935f-5587-2f48-5a794c30a592@huawei.com>
 <aiKXrovzrNN-gExm@gmail.com>
 <f1a742be-80cb-4256-b1f9-e50a0f83cb15@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1a742be-80cb-4256-b1f9-e50a0f83cb15@kernel.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 8716C140015
X-Rspam-User: 
X-Stat-Signature: umo19itn9tt4nwik48u9cmc1utiwpbm8
X-Rspamd-Server: rspam09
X-HE-Tag: 1780928158-977821
X-HE-Meta: U2FsdGVkX1+VVKsZSVr70Oh3uQr8Lkye/1r8IV7Pjg9861tZBEqOehMf0IN2+olPt7gGCfUHxyJNsZSIYZVNXhRlFAq54pDf5rVIO/c6ykGSVXud17iRGzpq4FTw5N7VsKi0Ro1EPETP6ebIhkg40k8wsLarEwXpiMh2GLEKB59SGEjZnKGYcpJlmuFlZgFgBYe5ex5gJZp3e/dRYibrmjXOIYGlkMmfFia4LOaFohUcx/uNu0HAWiZyYRBp/mHVTmhEuYinGg4dy6paKAYM7lAWnvfaTyF4W3SDVJSyWy1XEqGQR/6FjtZOrfev+HH02sSGIFpxsUe1pUHkCti0fIU81cgMW7V1yxLfXYGvq8L0Z4BUaMMpLl6IIjbupifPNSkl98WPYw7U+LeWCsAkDN8DbdGN7E5XgutI/fov1B8JnvCjk5d3wS1yODWZWOaabPI38OcGGDAsmT8SnBPEp6yx/+4PZc2SJ1yP/ZGCZb2HnKam/lflKVIcgy4zrZrUmzZ5XQTGXCMopWvXXN9R+ONPXTrMIb3z2XkuAsNn3RS4yfRd4qjPetKftkDKnqfZD6QI2aVnTo5u4OkXzmQ9fwK+O3MfVv5GNLSQZcazuIJakWxV3NpPzjRFDDpbyhrzs3MfTljN/pRUSwW3HMhScnmFMit1u7IZhOmMKqhoRJPKwt0yjyW01e4ZwD9QIRn1AR7JSHEkPMqIauzbSrJg2udGUIASdhwtfKZdZOzzjGBIRiHiClQvjG3KZokw/oLRsQKrJ16aGJ+1MZfB1E0kNzwiE/kH6qQms758ibnGCO8Sx/52OWDkouO9DiiNxyM0mX+6lFafEtlvs+KRpf3VPCHHKLw451ynK+09XMtLTcRh+NLte4eGbW700OaATrU4L3mzpgPXONXddH6khN/64OKKfIcHTGRCMrxA4sCVWyf9M9VNkcc6fUMhf31wdGrSXmxRXW1sMt+QM513Bio
 g0Su2QV6
 9VjxWtlu5zmm7OIoqtt7wuUIIaycTIv0jquVL4IdJvHgr80PyVmqCblDdY9Wr30nTw3MuwVDu6lT1MSf5X6RL8DtYRD2Nz7yKsm60rwUcQoghz2ZX6lT8HV6kigfSVfU3EgT557my1PiXgfSaBaL8593fD24YSLuCKYNphue/ZYVE7w3RR7RXljMDCDuPQyKHusrg9HVOeIfQ6qJGUSN2O6cd8t/ijc4g3bMUNNmIgj2By3WZLI0wBJDSI03+aDwzmzKL94CMaiOiy2xCVFpYRpQpYEZYbaAbuSjqpmuROOCbEAPA1nmHi5gDfDDRoqzo5ivWIkaUeGKcqy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 11:42:53AM +0200, David Hildenbrand (Arm) wrote:
> On 6/5/26 11:35, Breno Leitao wrote:
> > On Wed, Jun 03, 2026 at 10:33:04AM +0800, Miaohe Lin wrote:
> >> On 2026/6/2 17:41, David Hildenbrand (Arm) wrote:
> >>>
> >>> Races are fine. We might miss some pages, but that can happen on races either way.
> >>>
> >>>
> >>> I'd just do something like
> >>>
> >>> if (PageReserved(page))
> >>> 	return true;
> >>>
> >>> head = compound_head(page);
> >>
> >> If @head is split just after compound_head. And then @head is freed into buddy and re-allocated as slab
> >> page while @page is still in the buddy. We would panic on this scene as @head is PageSlab. But we were
> >> supposed to successfully handle @page. Or am I miss something?
> > 
> > You're right that it is racy, but I think it is an acceptable race here.
> > 
> 
> I mean, any such races can currently already happen one way or the other?
> 
> Really, the only way to not get races is to tryget the (compound)page,
> revalidate that the page is still part of the compound page.
> 
> I'm not sure if that's really a good idea.
> 
> But my memory is a bit vague in which scenarios we already hold a page reference
> here to prevent any concurrent freeing?

No, we don't hold one here in the case that matters.

HWPoisonKernelOwned() runs at the very top of get_any_page(), before
try_again: and before __get_hwpoison_page(). The first refcount taken in
the whole path is the folio_try_get() inside __get_hwpoison_page(), which
runs *after* the short-circuit.

So get_any_page() itself never holds a reference at the check -- the only way
one exists is if the caller passed MF_COUNT_INCREASED (count_increased ==
true).

So on the MCE/GHES path -- the one this panic option exists for -- no
reference is held when HWPoisonKernelOwned() does its compound_head() +
PageSlab()/PageTable()/PageLargeKmalloc() checks.

Given that, I'd rather keep it racy and take no refcount than add a
tryget + revalidate purely for this check. As I've said earleir, an operator
who enabled it has chosen to crash rather than run on corrupted memory;
mis-attributing one such rare, genuinely-poisoned page is within that contract.

