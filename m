Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF92CA9EDE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:40:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3891F6B0088; Mon, 12 Oct 2026 23:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339686B008A; Mon, 12 Oct 2026 23:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229846B008C; Mon, 12 Oct 2026 23:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F40576B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:40:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81AAD120AEC
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:40:25 +0000 (UTC)
X-FDA: 85316200410.20.731A488
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DFCCB1C0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:40:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oj5zpxoG;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791862824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHKRBDHmsXsK48oKqrexgIqndzfvmbI+AVfd803mUSA=;
	b=ZiktMbRCBXa2JVDSoBHdO25ajk8CgbP8Luku+jJ7doMUTWobwv/t/e56kBRjrT9LftN2bF
	VDx1FPiI+NR/7mUlIhkWaho8Fr7bgQJQlUCiKgQV1jHwqVM+uI9dGuVnCPNFpuX3/zmyAx
	3bi4hAF78h0jmO2bhkIwgqRawQc6+x8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oj5zpxoG;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791862824;
	b=jrRHfqE3FtUNOVHMjgI0EDA1AffFogcOM8Xh8KT14iPjGeIhhx7r3LykXxsniYQ0REfu4X
	AU/Kbw1ni2Uwo+SrH4lD7MCWNo7O2zkr7yY+Z+TKR8c623IHUFpz54xIWXPR6UVYWO9kvk
	24YoS+19zVm8qryTJ8dCSwzwiY0m5bU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE1D540387;
	Tue, 13 Oct 2026 03:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4831F000FF;
	Tue, 13 Oct 2026 03:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791862822;
	bh=MHKRBDHmsXsK48oKqrexgIqndzfvmbI+AVfd803mUSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Oj5zpxoGgdzmeIog+7KO1QLrI4HUFkQNtnMsz/Sf/iwRjmXaISNO5VFNexwDOfA7I
	 QLiRzOMZyLuAs0cGPMstdgayiiW91bVrnPRgVfDxA9f45B1BQKQ9Sgcl3vWBYynlem
	 9eFhgaA4Z7w3AHx2qx192F+EVD8bM8OD2lg7BcxAX3RJCu4AEjGD+/ajUMxe/+F0lU
	 vAUsbFr/Gr22WvlIBVGbtqHob5Fevhl6bJtrxBAtC9YFcaDUeubtmBEl3k1SWaU16P
	 wOPAnsesfWb+rpki9Z4AUpY3luNT5svEsOgbs3aNHBuDM0iTMVRSnTo5Z6/YR5f3Xg
	 YheZMVbSKLEoQ==
Date: Mon, 12 Oct 2026 20:40:22 -0700
From: Kees Cook <kees@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-ID: <202610122032.A63BB70@keescook>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
 <asjhg2e4-WSeKuXd@thinkpad>
 <202610092010.934197B@keescook>
 <20261010153714.b9e91801ea93675da099e903@linux-foundation.org>
 <4866a382-42d9-44da-b68b-377d36642528@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4866a382-42d9-44da-b68b-377d36642528@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DFCCB1C0004
X-Rspam-User: 
X-Stat-Signature: gks8h6xfkkaurggdrkfmgabuuuk67t7q
X-HE-Tag: 1791862823-408812
X-HE-Meta: U2FsdGVkX1+NSZxA9FRFNeAQRx4HhJSIXR6PFIzJUgwranNNRYUWDtNHtuVqCGvbfk5R4lTzUHwbiwE9gX/3lbVQtiNIOsAnUSFqyvzqs0eWPSsY0AjY2IryGDs/DCADhXOC1Z6lkOVf3K63bDUErtchNMC9HenxoJ95qvEraBmL91EDW6SO4WTYC93BLM/cDbRZB0XEQl7f92aonEd3T95y/0y0AIblCZPA9xLqKt97iUhVEaf3Yle2O3LyxKdrWdvmQxm9bFuHFovqndIjenkqUWPlKTMsfpvcBTuNxRJQ8wIjW92/MdvBCjn2CuKyiNsijNlgfuX29YXm56Z1t51IL+NDPIZFWo8BR5mEz/0thfd00DrnFWUSUt9tSWdmRV/xSHLjaBAzO0XCRPe8TCYp2/C6AGfVZPNPZztFvxLEK/L8IKc3PEu7VjT/rdPMpBkrm6rDyuHjgnpAK8lGWcaUP8x8vYFuD7fqj7hf25neuUTL0of37cWcPTBA5aaQV7cGFLXSsn7H6iLgoYJ7WqY7PTfm27bmrDH5gMgBKPHJ6t2Edp1tZUMnco2IQFujnpKrguGDVvMhWFSOaA/xrKtU/WLaMcb6ieTtvNdtJ9EZwoU43wkMBk5h0cQRw7lNzNm/df+A+V+ftRJNCC0Svuvj5pWY2sPonSV6hRY2HNS882zQet1DzLANTRb6laKmBW53IoVJjjzW8KSLQbVXzq+tDFdXbl0YZesIcpvmMo0yNC4wAhdLLigQLkwTYGmdvZQ74S405fryiO6atY9sN+6uki113oCAjMORGd1ZFg5KtTeQq1IJCiPxlnPUHJ8Rf96pLdy2nflYTgo30Vy7qi20H99I7wCMK87l6gmFSluYu0TprDbKQj2K1iktQAaCaTEYhtJlEUfec0kiD5fkSUAN7OXjgqBsB5cT8irBHLjC9c4PYIdFCRLEqJgtcFAvvOgw995Bf0mSAQQAdVj
 rHrxvT8b
 XD1wCOHIc2BQTTuZ9MbEhOuBEEvMhS1ez5rFXckX0LkAQyGJLBDM5OatoHB6JPMgEooNcjJ3BMscKdgl40Q+yOX53hmfL1j2+J1b53u0bAn/XsCEyf1aLPf14Mdw15dbhkVIF9n6KwBahPQlLT7FovA3Vpn6ngfvvYgVmG2aAHbe1EmND+q1sKD7C61KSJl38L1lgKFsKbIixcL0igdpkkv/niwWifEFdBbzmIzIjF/0e+I5kZdFCf1lVw5bKrvYoxt+TbIfsweLS9NfC/AWmHOAPLUbAQ3ZcOOHVyVTR+LcfPAJccuaOlVg1LUkdQrIeJ8CmoNYhg9M17fUGTN28suCkPkxnBCFx48+naiJok1k9PkLbKx/Kizan3zDv9SCnJeoWrq8w6FzOMFI8979c6Z72dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 06:46:48PM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/11/26 00:37, Andrew Morton wrote:
> > On Fri, 9 Oct 2026 20:14:20 -0700 Kees Cook <kees@kernel.org> wrote:
> > 
> >> Anything with Fixes: will end up in stable, so I just leave off the
> >> stable CC these days.
> > 
> > -stable maintainers have been asked to Not Do That for mm patches. 
> > Other subsystems are doing the same.
> > 
> > I don't know how they determine whether something is an mm patch.  A
> > patch which covers do-do-that and dont-do-that parts of the tree is
> > likely to be mishandled.
> > 
> > So yeah, add that cc:stable to reduce the possibility of mistakes.
> 
> There's also this from the list of pain points at
> https://lwn.net/Articles/1099594/
> 
>     Kroah-Hartman: subsystems that do not add CC: stable@vger.kernel.org
> tags to patches, but which still expect the stable team to pick up the
> important fixes anyway. The stable maintainers are overwhelmed as it is and
> are not doing that.

tl;dr: yup, sorry. I will add CC:stable in the future.

I went to go figure out where I had gotten this misunderstanding.
netdev dropped their special handling in 2021 in commit dbbe7c962c3a
("docs: networking: drop special stable handling"). But I
really thought I had Greg tell me (in person somewhere?) that
"Cc: stable" was redundant, and I think what I misread in current
docs was, "... such tagging is unnecessary if the stable
team can derive the appropriate versions from Fixes: tags." in
https://docs.kernel.org/process/stable-kernel-rules.html#stable-kernel-rules
but that, on closer reading, is about the _versioning_ syntax of the
"Cc: stable" trailer.

-- 
Kees Cook

