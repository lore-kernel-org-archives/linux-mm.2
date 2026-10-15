Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03812CC6B2D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 00:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA466B0088; Wed, 14 Oct 2026 20:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B6D6B008A; Wed, 14 Oct 2026 20:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A02B6B008C; Wed, 14 Oct 2026 20:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 775106B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:05:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 097F11C3F6F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:05:23 +0000 (UTC)
X-FDA: 85322916126.15.4CB5AB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3FF2714000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:05:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qB51PsFb;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792022721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HX0jqZ6Ei4Zd+dXuJ2rolcpkuLDQZATSc3MdY7kcrts=;
	b=XcgImEeFdhqgKbIWMFjZeK2vUuYDqUE0XfSBKzXNkjuItV0Qce6JLq0FkYhirJajahYv17
	TzGpZJpJ66UGaRNxTU8ToxQq/YtCMGx/S8I+SczyqqlgLqc+BXb1Z1HQD0Yxulr4Ehshgp
	vQbA0SSbnQLT652sJfZY6Hke6gf7w+4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792022721;
	b=gNxV6mEnTwzzQ+rS2l899SAQRRjxkYoxSGKUUls3cjfGC7kyomMVsfbs/qYKFEUD/x0x5F
	aac75+DcGQiPvzZQqWdjdS82A/fMArbFScibau8yihW7wMkbgOb82uJZEfjpyfEeapPskK
	+l/XTXtAHKc0HwdupP4tIQkua9ru9pY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qB51PsFb;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61B6A402E1;
	Thu, 15 Oct 2026 00:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2730E1F000C4;
	Thu, 15 Oct 2026 00:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792022720;
	bh=HX0jqZ6Ei4Zd+dXuJ2rolcpkuLDQZATSc3MdY7kcrts=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qB51PsFbylsxK7W8jTmiK0HxYIjGQ4CiZTFQkcBr58p8QorGxfQTvamTBqshxBnVy
	 Adr5V0xQWYRfCju9oncwQ9xM5AihJmOqdTEqMvWhbwKjGEyMJ8RryOl+kdN9rvNZ4M
	 OBlsaAXjwj/ViNxVlnx+p7ekyRd30M4ujllDYRUQ=
Date: Wed, 14 Oct 2026 17:05:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Ye Liu
 <liuye@kylinos.cn>
Subject: Re: [PATCH 0/3] tools/mm: show_page_info.py enhancements and fixes
Message-Id: <20261014170519.d07e3a5f791e16a5cb9f51b2@linux-foundation.org>
In-Reply-To: <20261014-show_page_info-v1-0-7a68aee0114a@linux.dev>
References: <20261014-show_page_info-v1-0-7a68aee0114a@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3FF2714000B
X-Rspam-User: 
X-Stat-Signature: tn1zu5k8npqenij7utim7pgx7n74fakc
X-HE-Tag: 1792022721-13095
X-HE-Meta: U2FsdGVkX19FWyPI/3VDRqgMGlXyEqacit617wWVjPumfB41rlHJLUG42FpTnD+MNxH/luPmhltn2CdMJzRLjEMbg1tzP1kbGUiEoK0ztd3eBgU2wKZbPOgAK1MwRTzX+RyS1YMGxyPeYNmsPNU/T2bk7E7wUKPGj27pdm7fsZR5KzT5oAeEp7EuvMP8MvdoNiblX4NxGgOUmMrIjlXk4R5T9UDyuYiQIUQjRTij2XmtsJWbv/xtvuATfDNzgKFFNPQjjioK4fqWQoJfdFB+LO3lEXDy2Pj5+qI9ey88fo9QqijvdyVmUfYIIpmqiq/GjdMU6iaV+hTAA5XHpGt1/GJU1E+20TKseMGbGQfDw6DmxLoPKrOf1IfiuL+bpdguttEXOXUrHc+VmRWNF3fY3La7nO8Bsh1/wzfg0IoqyoqXRU2G1Vtq9PdgRok+6yE8GO92IDucmo457N/2n/MhK8WsQxd3Z5L/2qQDRYTCC/guNGy12Hru9p9/Ml3wf8PKLfB5jwLcN+OsS6BnrsKJj9XeEoNjYT3sNCaLRrdzhnC/imkNlsbvJrqC9tkFmz2PY4B36ICoLzzXJebkTu0x51cMZzZUrKwD5xKlkBE0NX35oD0NC0+i2uiRBtkOlkFcp8+i4PSnW5Rm90CUKCX4+g6V6giUtmNkwAfnzLdIRuIwjX5sqLGc/FLoJ6eApB0tkIOmH79+xieFsfUcLgZ1tZLNDvtzc44mONZBpCe9GU984bYIletZTSoUJ45W0T6YKNkXn+cwXArIHbwpKDE7nQq2R1YZ/yQg9suh6OpoGrfaBpbLu1kuZCfHI9RYoWBXWf1UjOrhLA8Mkssc/p0Ch5jABVK0m2TrAW6FhBsUbKisOGH268vCaiYbgtgX7bKLnTOll2LljOmip0/Rhf8VwYP1enkRzAg/OmvKrNqJ+9vWMTOAI1DjNlhZio5tZs49ifcp0EoAHCn8sa/1NEv
 VwNFTvIV
 7RpLHoRkRB0Dunx1NkhAaGkZbB7yV11VxThrWE2PIVNBYrWssE5o1QDyP9a2Tuu3eJhcoN2ZxHXjfoq494kfBeH+kopKgSnY6TIzAcF3nw3JEd4jqGzDUjgBod/LLgo3o4Kk2o7ty5Y37vMvLrxMRSVRSqcOWeL3xJMaTYLED7CCwJb/KeJqV7TeFWhmpwUu9nZ1peb2bNAgxjvkKs2vG6Jpw8md0f7bbuJ4F1RXngZEKNbBTdHbL+wCpOrljTsI9nOzSPFmVq6dMAHMsWFZpE3XCRCFPPpKzf4ayaDxAUFnoIB92i/B0pPtEP4J/MVRGkfgiyZxbtUNOpcKWO+4nhV0AtrTsgxzEv1ZV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 15:04:27 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> 
> This series improves the show_page_info.py drgn script with bug fixes
> and new features:
> 
> Patch 1 fixes memory cgroup information retrieval by updating the
> obj_cgroup type casting and handling slabobj_ext field name changes
> for compatibility with newer kernel versions.
> 
> Patch 2 removes the incorrect Page Index field display, as pages
> don't have indexes - only folios do.
> 
> Patch 3 adds VMA flags decoding and VMA name display to provide
> more detailed information about the virtual memory area containing
> the page.
> 
> These changes ensure the script works correctly with current kernel
> memory management structures and provides more comprehensive page
> state information.

Thanks for continuing to maintain this.

I'm curious.  Does this work mean that you're using this tool in
real-world situations?


Sashiko had quite a lot to say.

	https://sashiko.dev/#/patchset/20261014-show_page_info-v1-0-7a68aee0114a@linux.dev

