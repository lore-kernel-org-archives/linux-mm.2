Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 185D5C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9EF6B00A9; Wed,  1 Jul 2026 03:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08AE86B00AB; Wed,  1 Jul 2026 03:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBCAC6B00AD; Wed,  1 Jul 2026 03:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF4036B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:27:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39350140277
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:27:53 +0000 (UTC)
X-FDA: 84939378426.09.89F1122
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6165F80005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:27:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=F4A3l3VO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782890871;
	b=rVg0mVoiU72L4wZPcs8XAA82oAUjq1U9meDwjykerWiiska3JDdL2dcZlnKo1GiYY4zUGH
	F+Oql5A/d5D04sNt6Ti4Sm1hWzKkBZQRSuySDaI/7ThKeGcOu6DNLoWE7lY44H8TQXieBw
	5nhO0BM/YEFwQ9nn+Y2HF1JHZ+hwKMI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782890871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jW1NBw1qHnlKhZfdMyrKwtK+Ae90Kyc+mX3kaOFeRMA=;
	b=qyrRY+dJDu3i0xgSYssQ82pEoK3qon5IOTplMZ0WZWBj4RzZ4fOPJOMxje0QfVJmMJ5LB4
	yof2twfR/DgjrB5LruOGbFYqlE0AVcbmB6Z0x3uICqJSpHU60ImHQ9Lglyf9ggclxdNfKy
	ed0gKLToj0aFitqHfJ79/f1l3XplU28=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=F4A3l3VO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jW1NBw1qHnlKhZfdMyrKwtK+Ae90Kyc+mX3kaOFeRMA=; b=F4A3l3VOrTV/2NUkR9aRZaFBjQ
	TuviMDd0XaPHi2ZWyedDQOjTgG9RM2G3SBYKtgNyluugoaL/Oh5FvjRcsC/SdtOe3oirj95manQ/1
	3LDhDeXDZAFaiVKzZNaGz3Jh0zJ2UmhVzvb+FExz5aRIzYMRjRfloewNYde1yA/06CVsX2dtka/So
	tREX9A1R46sDhtI5dT5yi9pChQ3yXRgiBZm9+KVWXLK/4b9c9CkS8Hna/AGuk2ebfwTwLq76o4FgT
	k2cV/luBoNu9eILWC/uLhwiwbnGskD9wJxEWGYJgECEZi4T7AjqATU4tEArVxcV2iGVLfhoTG/Tvq
	n3jHRGww==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wepMK-00000006DoP-2HsQ;
	Wed, 01 Jul 2026 07:27:48 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C368030035C; Wed, 01 Jul 2026 09:27:47 +0200 (CEST)
Date: Wed, 1 Jul 2026 09:27:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Xiang Mei <xmei5@asu.edu>, Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	linux-hardening@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
	Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
	Yan Shoshitaishvili <yans@asu.edu>
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
Message-ID: <20260701072747.GN48970@noisy.programming.kicks-ass.net>
References: <20260629214712.1198680-1-xmei5@asu.edu>
 <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6165F80005
X-Rspam-User: 
X-Stat-Signature: hsxsjt1ye91xucmi6mq8ys6ubw4r5ak3
X-HE-Tag: 1782890871-782962
X-HE-Meta: U2FsdGVkX1+E69C2sTl74Tq1nK70yRafum2WIzYVOvXyBv+7IHHd/1zH6KSnT15r+7vJJpfgM758OilQoR8moWO/X4xB/KuqedG0iWPuZtQm5NevcIcmL8pRpf/GUMx3cZR4iv97cFCZcLynuhHSDuiNRWJ68Argc3emIMVMp8r6+hmB3qDIr/U4LYmvwdSW2iVR91igc3MyyMo1xPTTiNCpg44Z5uQ8hubegqRU74cJB3wgntjMaMQw+DaGB5Xri7XoEKj1vdyQOp/3/9TYynmwp0BdgPSkpIiS23whSjPJdd/O7RjbX4CgRM9LGuhx8sQLxaNyqRobTgw5Pvd/m+tyZOxu2dcwjyrkBPyVVtT8t9291QIhwa8qlRqKBx4Zw4iUSGPIbUaO3KPr5LUn+1Zdsj+aVeoxvqBfgsyjT4rL12tQ7PjzCPKX3xtXAchG5uilOjhdCBVvcTBnJUGkyrkji5u/3FLFKFe1TTgbPdjTQXJzzYtlqgftnf9du1c6Xx91kURZAkA6b9/vfEX1HzVE+FjzMiY5HcteGPyNidexuKGGcuko/xyCfAiCJdzrFg8Wl4Y4hn4B8obFyTnBq9BmFalUmvLZetZ8HGSHXVOJkVByu+RwF1EqAUapRhm1VZ67ZkTwprTFQzxAlovCEXCbIiYOMcda8WBiijpWp+6yaAS+gO4mqSjb5MyIlJAqLx/cWkunV4ljBRuOlsAsinuC4+qCVVjiTRGvtOjJ263c4Bu00tZoBrodxBBpWHpKZcoNe5ozayPaNNq/h6JwAmWWJJBUE69D/2ee8oGlwNav2rRqHfhkBrWDN71N1N58mkTrauC8xu+/Kz4tc1J5gZvWSSSMaNgqC2d5RT6wfyLk5cxF8AELIGTqTZ9/1cWsTS1hZRHSUNx2dGluhCYsK1i8Qr6ppmxzUxHfb017/FPjn8Yl1eCQaGT8bo9zAX0QpQgrjwbRrS8pHsV2Ex5
 V358RPlE
 QtgkpGWT5zL70Rc9liLsTaGyuyyjsepevmdoDWqMzxHFE+5yO/k1QayB6gaMJYRD92xHPLX0Ai2+WGVhak3mW0ZeHc3VnHFm48uaDfEaw77WAd7BSbjxGH+FzkfVF2szxYgbRamSqE1iq/PM0zyTEL9kbaFbzFr0XhYPteuopBMRgXz6wy5I5UttxBHE7cElPapRUaBBvCk76H4LDchYan/8/d1ruz2XvMH9PneTEIrlxPVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 03:29:50PM -0700, Dave Hansen wrote:

> But, really, if ENTER is so evil and nobody uses it, shouldn't we just
> have an MSR bit somewhere to tell the CPU to #UD for it rather than
> playing these stack games?

For supervisor mode only, I suppose. We can't ever get rid of userspace
ENTER because legacy I suppose. But we can make sure the kernel is
clean.

So yeah, having a knob to make supervisor-ENTER trap would be useful I
suppose.

