Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE06CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553176B0088; Thu, 30 Apr 2026 12:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B156B008A; Thu, 30 Apr 2026 12:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468306B008C; Thu, 30 Apr 2026 12:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 399336B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:28:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 536421A19B2
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:51:03 +0000 (UTC)
X-FDA: 84715660806.12.A12281E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7A39C40006
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:51:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yGMSUjDg;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777564261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThnY4+gYDMsp/SZYv68JqU8TZn9wL+KNhhcMYcPG5ks=;
	b=3wLxDnN9fpDYYVVtE/Ia1GVEr0SM1BO62HMzBXm//5+hMtOvcFIZV+mZsS7GUemejUpDXI
	ThdPk6yhGN7RrekO5EzClAAo2aI2CuXszHu0zIJw6I61L2ye7M/enFiuggryRqOPJSsxi3
	hBIcKgpGL0Z9+9iOsxuF04HV9MGN/Ko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777564261; a=rsa-sha256;
	cv=none;
	b=RhFl0IUEY4HvrNvh6HRjrmbwWGsiSTZtCnYzpn9SY4zh+hbLjLpPjmNL9cmF18ncMZt4WX
	UA91c3HfYYG7tX5yk1t0KBLwyvUB5weN0NmYEpG6kxf5OMsd7vnVsWgWLuTthR87g6ztCa
	kxPEuF4rh0CH0+r6rHCfQBj0Yl0yD/A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yGMSUjDg;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A18640308;
	Thu, 30 Apr 2026 15:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B317C2BCB3;
	Thu, 30 Apr 2026 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777564260;
	bh=VCwG/evqvBgdVG6GZCPvR18G1PtMuMNk/bVzaUD/ngU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yGMSUjDgcVWPfy1XYK0lJb4V8O16KsRRfBKQd/aD3cP6f+SYk9+hc2V4ICklHG6Sj
	 8FHN0MJm3/mmxi77yGWm44pVUzUvRaAI3Dic1FDgpQoeCiZb1DBtUS4Ox2Qt5CKpny
	 DuATWvnLOZDOFrVfhmkJR9Z6CfVrsiieyIbmhRoo=
Date: Thu, 30 Apr 2026 08:50:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Usama Arif
 <usama.arif@linux.dev>, Oscar Salvador <osalvador@suse.de>, Miaohe Lin
 <linmiaohe@huawei.com>, Muchun Song <songmuchun@bytedance.com>, Vishal
 Verma <vishal.l.verma@intel.com>, Ying Huang
 <huang.ying.caritas@gmail.com>, Dan Williams <djbw@kernel.org>, Naoya
 Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Rafael J Wysocki <rafael@kernel.org>, Danilo
 Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison
 accounting lookup
Message-Id: <20260430085058.f566bdc2aa5c19a54936da30@linux-foundation.org>
In-Reply-To: <C2C5188E-76BF-444C-BF2D-8BDC1410BC61@linux.dev>
References: <20260429101134.1358607-1-usama.arif@linux.dev>
	<b67ff3f9-8661-45cc-b408-6a7b611d31c1@kernel.org>
	<C2C5188E-76BF-444C-BF2D-8BDC1410BC61@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A39C40006
X-Stat-Signature: ua7a3hf54dfbxpkxnaafeemww8t5or8b
X-Rspam-User: 
X-HE-Tag: 1777564261-638677
X-HE-Meta: U2FsdGVkX1+c2xlwhAxE99tqeiNizL/Wk0OwZ6eHpksDe+Wsk9rlOKB0RTGF4D1kNnUKukQ7OVJYH84UJ13wySWK72E1FGFYkxtWy692a1FS8nOCU4eSV5rnZsAoDFBSKSuGwAIe8S594Plphmzk4r30zTM0jYV0q9RTnfSzYf9F/tVsmNUWENwSLAuXnhXQrcYxKzC6ia+QGqJLUTG+1aN/rNTQ8ygkMTifmX1K3FUEtgcw4Jc8z4juMKnonzhVdRRWheBA4tcHFvSxrw6e1FsNGmimPzKHSOZuRS7CPXJdWSVQafhZ34u+WeYjI9/2yvadUHwrx2VO81Bhe9iMOpsvPL+XB9uVITzDRk/PUPEHMqPk+H3E458JicB/4vCi6GB1BSGMBc27YFjlZnd0vssaus67zt5szR4xLv7WQhK/U06jqB8Sfb1NVe8DivlkWjM0Cf5NdDgqNDOPF/vfhCWuOTDYEQg5CcmG6C6n+BuQWYuodZzjz648YKbVFpxuZnY61DgFmu5Q90E+yyQuIb81k84zEkbVmlzKZLN/vIKvJGegtKroI/GXkBTIVNPiS5EhXmRwqdYkEIzI+uhFqHBbn2kPDvQkRO/Hvsr93PRncEzoGpEKSl2MLUkwmAwQfWrFH5xZUmON9uY3J2SIAN0WiScYE3+mgQ5xBPow1cgT6xejOdSTmIEQVCv3orHJQlyLhUCBMssgPzFCkKe6UbkmeEjvTrf8lhWvC0MD2XEGy8Dnxz80ks67MRfIbSld/++iwLuy0W1YSW9TJ8SRy/1YOdVHBrZqAsL7AqB6SZplFgugje/vgqo5ZmrVGWzr/EgVNgFf7glJO7rZbhU+CPy+UsuqIoaLTgjmauJseDTXpefuId0mQpJ1c3+R8bkE9FnK+a0knVfbgTMFL6nvZ3bnYyaPDP22TvcMyhjxc+DYr4uSGk5DYHFRnQ/yLBFHJ+wLpGIbrU/0jJ+DuJv
 7lXSDSqy
 TZeoq2LV2561bzcYwPW2C54CvVbsyMt74JZvUp/VbLqs2p3iB5MZMNhn2dA0Wv7PfbP7k5APn9S/smjdbG/GYi8lgbzRn7zXcfF75glzNubQJPsJ37ozgSejeugb8CukKgbmpxfq9PzTLWTQUe5nsOACXxYRGN1uJluhSa8snIvnc2Y8ZjpzxPvUWjrklUMYe72Wz6O9rRtwQW7jUXXJNm/LtPLgDe9mye+lL0ieaf4VytGgXIuBk0Upa4A7Fn9wYtlMlXnQ+L7TnroMaDb06saI+OPDgPa7l6cU7aIswEXvll3F50hI0g10WAs6LQ4IS+8Xb680m3zeDOAZWdL2k11eKGAR5r495oUZ1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 15:59:33 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> >> Lockdep would flag this as sleeping while atomic when acquiring mutex I think.
> > 
> > Another thought would be, that we always call the inc/sub from memory failure
> > code while we hold a folio reference and the page is not poisoned yet.
> > 
> > That way, memory offlining cannot continue and the memory block cannot go away.
> > 
> > So we'd let out page reference keep the memory block alive.
> 
> It seems unnecessary to hold lock_device_hotplug if the user already holds a
> refcount on the page. I'd like to drop this patch.

Dropped, thanks.

mm-hotfixes-unstable still has

"mm/memory_hotplug: fix memory block reference leak on remove"
and
"drivers/base/memory: fix memory block reference leak in poison accounting"

