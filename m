Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA48CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 09:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595206B008A; Wed, 30 Sep 2026 05:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545AE6B008C; Wed, 30 Sep 2026 05:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434CB6B0093; Wed, 30 Sep 2026 05:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 211C16B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:07:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9630C406CE
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:07:54 +0000 (UTC)
X-FDA: 85269851268.20.5708F1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DEBC040005
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:07:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H8fv3xtD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790759273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsvz41YEH/JaemNzi2jV2AGQCeCOduA17FkfpU1Sxy8=;
	b=q9gKHpA7Atzo6Gm0fc6webADM+uG3ZZ7bMp932OoTWIy4FWm/++ZLllltAarCgIqhqseLN
	orfNp9npTA5P0u+K7G0xm6iYJBjeKWNjWRmXGKNiLJkkCBZMsSUjVT37KfVvdvLh/6kZau
	GlD0Lze69N5lERZnGkxRXDOYeTQD4BQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H8fv3xtD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790759273;
	b=BKaMSFNNXEnpjeC/t9X8IJt0faihG+9ZMx9Tv15WTSP4gfZp6grZodbCg90JH2bd9q2hCl
	rI0ZjQ6YM2PYP1wfi3E4WDAPKWvW2N4xSR3DXC/ax9jq+Yk8lMqMuXfgS0Gf2hGYcpFGrv
	EpeEVa0GZacXuF4Hp6lcMvcHEavcRTc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0D894021E;
	Wed, 30 Sep 2026 09:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD7E1F000FF;
	Wed, 30 Sep 2026 09:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790759271;
	bh=rsvz41YEH/JaemNzi2jV2AGQCeCOduA17FkfpU1Sxy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H8fv3xtDT7tjw5iv3k/GNuPafrfnFiiOAqetDtbjGxVhpFHySLhIR8+Bf1Xpo3KFX
	 22Usof6ZP7wLrZx+h4OcXK4sWw93jX+EixGG9zzXiUmmBJ/HwjYgefshaG38HcFgjm
	 RfsUaD8sC5Jch6+TKj84bojgo2iOA7C8RPDvEdnY2BjZvs1w0wZt6l3Uw5YFpVEccP
	 JZwhV8ym1Kuscx2J+5NaTxd/xf5/mGKbtzOsvx02hMmoVht148UtFeuc3pt5wj3ubF
	 oT/LC49IKNvKTfdmCRDVqmdVLefzHW8g80ktCT38wjGT3FHPkLQhQoHf+RaNSUdvXD
	 D6A+dETil113Q==
Date: Wed, 30 Sep 2026 10:07:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kiryl Shutsemau <kas@kernel.org>, luizcap@redhat.com
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <arzRBv9ceJsxJppI@gremlin>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
 <arZHp8hjYFXE8Rkt@gremlin>
 <arde/t0zQNEkWqi5@pcnci.linuxbox.cz>
 <areOeRwZOez0eHm7@gremlin>
 <arotyz5g6LozSjb1@pcnci.linuxbox.cz>
 <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
X-Stat-Signature: dc5sn3jzfa9g5ua5a4tmr6gqx1eh4soy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DEBC040005
X-HE-Tag: 1790759272-935610
X-HE-Meta: U2FsdGVkX1/zkf9pudC9UgWTjwKLguQRVvYfA3gTFTlbKUndZ9NoQdydOrh3IatTC2mFIrqgvu6jtqq20kwPfQbJJ23SCicuJJSEY/Y1J6t+3HBSitxZ9l0dbACG3kf8MyaM6tmHynfKzZEpu5/Qc+hPw6xf/hu5/EI74quf0dKfittVc25rZQEOwSxdc/28GwXugV+WscX6uiEdmA62b372qHWR90tbLO1DE8iuB5DGxe7FLITHo91oAzeAhYE1CsP2tUu707qxFYBYngc2AEmMtTpZJhKt/8cLZsPw38TRSldz77ICh45mqdgkHsxtleee6M/jyKg5QpM9yIrnfhrxiHteJ8Du0HvT45PRGfeTXK35AI0Ppn2vkP9VDmX5lXsQMqdp1FhRh27NDiHIcjon8nNJtiFeS7vpRqF9wAVmP04tJv9xjb7uvXiaC2Q1vFc3tqU4SnqGX+Q3+YXANASRvs0yw/7aqGYBcHJJftUwp+pL1+7r37oY9zBZ6IdJLmCg3e5a+xrYFNeCpy9+BMtDzZ3Dj3ZnwcKYbGIFMmNFmZG0ZROUqYHc2veL6RsiVfq3DeiwDMW/Kho56CWXCja8kLmZXjqWD5HTEYK5VM7vH2DX79SKV8e2e/NTJAWLfb71lqdAeU4iEkfNL+Lnc68VZCbLBhYx3uT8gWZngtgSqu0EbwR72ofY4OCN/t1s4/xSrvh3KuxBF4rd61hHuQr45fAxRQxVhnM/X+KIMkPpldyfZqxoHGkkg04v3j57/qnHLt7IaInv8cM1eqmEnAOodlDgErvXb41Wq8vu7c7gjKm+lfrHNS0zH38mypbJfisx3M2IjJmU2BAse38x6Mcq6I9Q6/7U8YZIk5M1u9jAaZDAGIkWOPkcGHMsWKKy+hVBuMUgoW+cvGgSuVJ7JSdY/iEqAgJ8iwd8O8QUYqoj+JH10rg3B8zZ+AUWzCou/ctJ2CgDjygJA7IJkla
 vln8nLQu
 Z55i40/qvlzPb/Y5+dJI0333jFbsGGqHkoTYlWB5FXkI1DlFGjkRj2170KJoKH8jpsc/EHIRAt61sQSlG7R/8XTQoU+VSqVmlZRdrT1LudTGOB+mdZaVikC4UiCVWwBeGSxatIdGkdJRvPc0pbhU/sUnIUvzPa9E1ssG6/aljDKkhcWXBRRDcoV/MvsuT5V1171olh2QK62b5SO11k7y2VyJwD1tQ+IrT2YErh14TTnndYoRCB3LlERCmdpM+ohDwTNnwznsrgaiJMwxyGJwCmOqiYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 09:11:53PM +0200, Nikola Ciprich wrote:

> so he reverted back to 6.18.15
>
> then he got crash of another node (to which he was migrating VMs from the first updated node), that one
> was still running 6.18.15
>
> pretty unfortunate planned work outcome :-/
>
> but it confirms that both 6.18.15 and unfortunately also 6.18.54 are affected

Yeah 6.18.15 is expected, I'd not say reverting is really worthwhile honestly,
given what you've observed previously.

Maybe worth checking if commit 26505e1b5b54 ("KVM: SVM: make svm_flush_tlb_gva
do a full asid flush if NPT enabled") helps in that case?

--
Cheers, Lorenzo

