Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA8FCD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 11:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D6206B0005; Fri, 15 May 2026 07:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AD746B0088; Fri, 15 May 2026 07:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EAD66B008A; Fri, 15 May 2026 07:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F31136B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 07:34:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A82468EDE5
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:34:28 +0000 (UTC)
X-FDA: 84769446216.12.C907E6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1C360C0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:34:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ia2ne/27";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778844867; a=rsa-sha256;
	cv=none;
	b=dNLWw3xK8Kwbkh6rJkIS7rYQooXyckMU0VUlFGlcklSsvV8U3PIFcs3eeMe6HdvsDOiI3c
	wtvB+LUm/0w8Ymk8VPqxvso6oxJa5YhcLSJk44ip9X+1X8hKI3qVIGuFUTbDU4g746+W5F
	sTuwZYizz9cGQCY19XRxwTKoXHvFsO8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ia2ne/27";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778844867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OyUWFiCYJJOYesbaog0a15HMukCypct41d+X5PgQVJw=;
	b=jqs0MlJLG4F3tT1ZbKtvJh1Qhiko8nOr1SifUOyHqwk9a1f0nN0G+zO0uXr0HbZP3/HMtr
	KZ/ckjhN6ERCVbQhIava0Nt2naZRm/gDmV5bMspGhU7PxHNbpPC5AEU2HMrxw1rOdpIalL
	pLXAN3snGpS6ZgcdL3WuVy1r+rhLNLA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 510AC60018;
	Fri, 15 May 2026 11:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A0CC2BCB0;
	Fri, 15 May 2026 11:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778844866;
	bh=dV3f4iOgUU/KkC0ZeemZIzRwGsXHk9M9r9YxVxZg+k4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ia2ne/27anPGvbhjlp0aCfY48oj2uM+eBY81Y61x6na3lMWrls36u2Tazi5d8hFZ1
	 Qx9uhpUDWfDZ/R8AO/iDzRHWzmjE+6/3kUIhbquezsKrmGSSJ9vGbX8//fB4KffcQE
	 5aprOJLm/B/50MLso3xMIOeWLrgrpF0yB2LI2+qqtlRCiahvgrPF8M1dnFB0IqQrTh
	 BtFG0vQHugDsmThgCRS6xG9YdkXkniJ5qa36UcTUq5CrvJAJNmnXHc6YU3CCtpeHu3
	 d+DNOZZTxEY4YeSSVceQMS2HhtXWyw3btRKdzX+7dsOc97dHjWEilYzJyAhuj1L/Bv
	 zp5HMazgY5eJQ==
Date: Fri, 15 May 2026 12:34:21 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ranxiaokai627@163.com
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, 
	hughd@google.com, leitao@debian.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_store() with sysfs_match_string()
Message-ID: <agcEn02SSsh7fPcN@lucifer>
References: <agW_BR8qNsxzAKYi@lucifer>
 <20260515072336.53287-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515072336.53287-1-ranxiaokai627@163.com>
X-Stat-Signature: cwwaw6pcugr45d9gciryfj3tknc3tzg3
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C360C0005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778844866-180592
X-HE-Meta: U2FsdGVkX19D8jdrFZB7z4PgyB64MagvWv1UmJZGPyLGY8AuDAfSx7mAJPgLqJ6icXuAVIh+e20gNNRx/9tF42TmUo4bLUMLVv6vgoKL8coFpnChjUNofXpx4OMJqJ9nN8effquvL/HZgT26nHuG5clZqI/v3kwBUOnRqsvyBRtuzOs2tr9pksCYD+H/uUKl2Az4nro9M6FuWq+9p9sYqQ+IjdLAYWrJeVJGPsQHdknKQnf30/hcz+DclXn08NCUaDWA2OWDqZx9VA3hj95FW46pv54+KwWNoRlzqn0uyhlYQE35bL3sam2ptJQa4kuXH/KfGUPA5RY88P/C8Xvm3/RIKvpSkNm/VgP93hk7mmtT5XaO7ciPZ7KGlrSh3qkuK/jGphuziQqswJYY/wxCwcShCXASeGipB6xFIRovg3m3CYxr8+/Vg2pvrB+Lm4jtQaI3c+guDDDMzYY8rIUGWCCql2aDvP01rq6QNKHVbmDaUf+pbh9JGK0uRHgLTe4Dt8zKGOgclQkQdHbVEUgLy0eW6JejA8MxLmyc4TQXZDLbh2rar4D4E2JRmMAnbCJ1qJ5UH75IqOLxcHGDZU82ztmBGtpwUjuzsewuSx+CnhC8XJeKqu5ORQ9HzQ1Aezbk8zltcaJPBgFi3lnUgZhpftXhYkgGwH7PrIvwBTn4i/gMR7FYKYoxPbHPXHNBp7xeuRcVK8il9+HyAyINt+YDLsc6xULTenDLlo57bDomj+lqVxSQvGdk7qUkGe+Bpdl6OS1mOe4pOwTZvykUzY0EPq8oTEXQUvZMDJsAddIJxRafFRsFfMb1O0shkqtFeJBfxd9XtO3DllR2cWfGjMSZaWZ6UqEd96/UIoSOCAyZORSGLlcow6w4QPMCvXxXeXmPHKt+V3h3qijN1LYPNQ62YaERymWYrXR9VuMlJeQ1wmzopE6Ji7BpzwHkBdKf5BlzQhGjfBLBAAS2s6O4Csh
 wMkbXE2F
 lYeBOdGilvJrDMk7Ncn2pN5qQeXMDHgd7MWPVmPx31/w7MOYz5/g3l1MpZ6pOhlvEIWeEIdl4NK1nJDjkLePfYHo+FEXx5tYrOfW+n7YHKQoWw4goPGAmAGz/UKjef7m8bbmVSl2M8O7qNDLcVE2pQw/E0g2oCuJJxioyhVUlaa8k43Ujqq7dCGxmnb3S6Izw4J0czWjd0tavpFdt3P4w3Zsd4IRgAVmyTYP1YSKRes0/AkOOOcSw5iJxNcukFixPhYUb9DwsYGyZaHKLn5ZaebXbEYtik74A/8yUcT4q4O9tfcQxHWOnKaC91mCSU/9jSZgf7nIQmiYxmOVSLStCPmKrUoxieL1HeYv3XiW3fn8UcWOnsycald2RE4LuDAHCpG29
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 07:23:36AM +0000, ranxiaokai627@163.com wrote:
> >On Wed, May 13, 2026 at 09:45:07AM +0000, ranxiaokai627@163.com wrote:
> >> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >>
> >> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> >> anon_enabled_store() with set_anon_enabled_mode()"), refactor
> >> thpsize_shmem_enabled_store() using sysfs_match_string().
> >> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> >> calls across all branches, reducing code duplication.
> >
> >> +	/* Do not override huge allocation policy with non-PMD sized mTHP */
> >> +	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
> >> +		shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
> >> +		return -EINVAL;
> >>
> >> -	if (ret > 0) {
> >> -		int err = start_stop_khugepaged();
> >> +	spin_lock(&huge_shmem_orders_lock);
> >> +	for (m = 0; m < ARRAY_SIZE(huge_shmem_orders_by_mode); m++) {
> >> +		if (m == mode)
> >> +			changed |= !__test_and_set_bit(order, huge_shmem_orders_by_mode[m]);
> >> +		else
> >> +			changed |= __test_and_clear_bit(order, huge_shmem_orders_by_mode[m]);
> >> +	}
> >> +	spin_unlock(&huge_shmem_orders_lock);
> >
> >You're copy/pasta'ing anon_enabled_store() but not the nicer refactoring that's
> >there.
> >
> >Please split this out like set_anon_enabled_mode() does. And put:
> >
> >	static unsigned long *enabled_orders[] = {
> >		&huge_shmem_orders_always,
> >		&huge_shmem_orders_inherit,
> >		&huge_shmem_orders_within_size,
> >		&huge_shmem_orders_madvise,
> >	};
> >
> >At the start of it like that does also.
> >
> >Please don't reproduce the single letter var name though :)
> >
>
> Arrays huge_shmem_orders_by_mode are shared by both store() and
> show() in patch2, so we should keeping at file scope to avoid duplication,
> what do you think ?

Ah yeah ok, in that case keep that separated out, but the other points in the
review stand!

Thanks :)

>
> >> +};
> >
> >>
> >> +	if (changed) {
> >> +		err = start_stop_khugepaged();
> >>  		if (err)
> >>  			ret = err;
> >
> >
> >> +	} else {
> >> +		/*
> >> +		 * Recalculate watermarks even when the mode hasn't changed
> >> +		 * to preserve the legacy behavior, as this is always called
> >> +		 * inside start_stop_khugepaged().
> >> +		 */
> >> +		set_recommended_min_free_kbytes();
> >>  	}
> >> +
> >>  	return ret;
> >
> >return count;
> >
> >>  }
> >>
> >> --
> >> 2.25.1
> >>
> >>
> >
> >Cheers, Lorenzo
>

