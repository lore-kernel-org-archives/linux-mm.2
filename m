Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE00CD98E4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 00:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5CE6B0088; Wed, 17 Jun 2026 20:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC906B008A; Wed, 17 Jun 2026 20:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A776B008C; Wed, 17 Jun 2026 20:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2626B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:20:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DED6640620
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:20:09 +0000 (UTC)
X-FDA: 84891126138.15.F11BCCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3EAC740002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:20:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZYtnYh8k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781742008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nm5YTSonfWo5AmxP+6Yk9tTG9YTHgMUcZYxSeB8yQm8=;
	b=sbTP31lXj/tqlxec1cB/W57ypUf+FKhc3iLenKNMmRpXzyKLLJV4fmDHFMFzVjPWGNU4BG
	bgIg8UFZwtdpzDNdG4qdojhU7OPP+uVOLCpMY/NUxpGFfZ3fHeCVLerb4XHdfc0qMVDWMK
	fB2t8UPflKMPV0I0uiV4ejJZ3k0paDc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZYtnYh8k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781742008;
	b=dcRfXCSX/yCu9ExSWvt43HWOOy66mHWxRk8WM7uP+val+duLAt0UZio1zbfiQk8F9MrpCl
	j49Z2MNyqkNU1hgEukE5PrfTsCEkLRFHmdqjXdEIASSRHFgGviCu4VaYtqyS9+kdWSuspe
	UG4r1ORpmSnM2MxCjC+mYcwgkB9bL3c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 354684060A;
	Thu, 18 Jun 2026 00:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC111F000E9;
	Thu, 18 Jun 2026 00:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781742007;
	bh=Nm5YTSonfWo5AmxP+6Yk9tTG9YTHgMUcZYxSeB8yQm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZYtnYh8ka5j+1wbYp1kW4Qe0JWAnZYadELtku+/W16/IsaLfRR+iP3uvsbjlDMIFy
	 bq4Zq7W4GgeA3mmGopZvqyfN1FteKfdqQcsPvt2+qkIoENV+1HRoYOaiL/0RDqmR9R
	 GOR8n+UhPej2kxOjgtnJ5lPj2c8E/gleg+WqbUxPyL6dO3Oz1TwebHbB62eFSw9/Fx
	 4DkzHyzgnvUwphCVLJphdf0PjkxpHw6mhVtil1yx6jbgEWTwID/n1vPDjBLZAcmD6m
	 28UdnHXFF7IQi5UvncjIOxnHD8BIKlOyk/ONXrQtNsyGPYs1mbBXEQprtIpbgW+6UP
	 j/3z7z5miYZNA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: gutierrez.asier@huawei-partners.com,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/3] mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
Date: Wed, 17 Jun 2026 17:19:50 -0700
Message-ID: <20260618001951.84226-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618001609.83965-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3EAC740002
X-Stat-Signature: sj8umjmoxygsch1bws4atqr7489iqqgc
X-Rspam-User: 
X-HE-Tag: 1781742008-271757
X-HE-Meta: U2FsdGVkX1+3XTy6hbTIaO1PrJWao+IXM05Jw/35PW1tLwakHyleNYFJcs/5p/+dYSSX0JgfBDkDNsPnDCDO21U0rPyUYGVblqQfxrDpxWGrQ/s147RLOV+cjvW4phIQTEXsod0td5qNmKa0TYFLxQJLslalK1KMXfDK4bC6eYRN50y8Nv865/88CMrlLUmywnD69LuYr4meOF/vwo3MtgQ4k6tIq+gk6srxPfE0Du4tjch9iwDWPTfU3w3DiGrMMSjdh2OvuvmGVKhcLvHt3unR8lRvr8E85WNApBFCGll7UDffNur9aoRg+PFzdC68/d8AsAL4d5Xwy/PksmSrmD1IbFHMXZBg8yqjyirLMHPdEyEwJXzThrDkTCbn/Ssk9RrYHytzU6la1vBRritA3Rj/C/O15Dh+BaKlsxD8SW1L1Q3dK7/ab+g62X9HwCq7kWJU5ZIUOH0B5S48Sr30f017FlFAtGP2jC4Z92CD1yjy6JEL2U6AuSOQnm7gJTLT2tlbf8+ur6am120avQXCtFQTYpn7zn3G60ar6suRDF0b0qEM3y8ytLau3tkf0S+iO/1f2DXLl62pIG2IU/aIERjrwI2zQ7o+a4i0WUAUtfRh2LCQzw8Cm4HHAuNOWvdFsh91vDFNvFweC5RFLghalQIYGc5H/Z8htKsUXf2CzeZTCrXz6LQV6DW13O8jY9NL2+Y73i/pkthTNP8HHwSrwguR3WzKwfhFRFc4Lfwo86ag8TCedZdD7qkH1OvCaK6lddQUH+KViIt1YW9rpM6xfxtNcu9bysYrzgxJ9OAUVORNCXVrQBcz1AD9ymkdNxhqc1ocPw+M9es/clLv2+nSwv+uwkDX0BXsApa4Y+FZLYgkpzmt4Uj1/6Ep1w+MIm0KZGrlIuo/5apcXxcgR2PUdtWOPxsPT/QJNszujy94Dbn6kQeh+YZS4C1E0UrDMiuWhWLnPn65XJFAsN5U0o4
 PzuMiOzJ
 3u4Q9PI+a3x9jrGMR9cWMDP23ckiMAV4AaTKQAiIvRntnee1hgdXU21vMtPy99btDmk2P0zgFKPp3Zuz4pEj0tlXre7VYdrVNDIGXNjeDH+d+Qn2PBacOxw06wHT3Mtit/hxyo6ASLW9iV+rMs+KDL+pu6gx3gPZjEmgdKkFykEDGjR2K4DN+fFHrUaYdpbzUto0PTBH5WJV9t2xfZkvl1j2M8nbsUQJdsUmXemt0uuHEmHK6RyxOjkHQGKqI8illqKHUhmFFJ9z7X+H9IfBpIRfA6hhjNK/KuKacljiex/NaVmfv5XD8FO8J/J+3sF9ZopvSNhvQD71GSlj9S3WqbW0v5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Jun 2026 17:16:20 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Tue, 16 Jun 2026 21:04:52 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Tue, 16 Jun 2026 15:03:15 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> > > From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> > > 
> > > This patch introduces a new DAMON module (SAMPLE_DAMON_HPAGE)
> > > which collapses hot regions into huge pages.
> 
> As I mentioned on the previous version of this series, this sample module looks
> much better than the initial shape to my humble eyes.  Much smaller and
> simpler.  I really appreciate Asier's efforts on making this.
> 
> However... I was asking myself if this module is really needed last night, and
> still got not real good and confident answer.
> 
> After all, this is a sample module.  The purpose is to show sample code thhat
> helps people understanding how they can use DAMON API.  Maybe we can argue this
> module can be helpful at understanding how DAMOS quota goal can be used.  But,
> mtier is already showing that.  So I cannot say what new advantage this module
> is really bringing.
> 
> Meanwhile, this patch adds ~200 lines of code.  It is a very small and simple
> sample module, but still we should maintain it.  I, to be honest, getting
> little bit concerned about the maintenance overhead now.
> 
> So, if Asier has a good reason to add this module that I'm missing, I'd like to

s/if/unless/

Sorry.

> humbly ask to consider dropping of this module for now.  I'm so sorry for
> raising this concern this late.  But, Asier, may I ask what do you think?
> 
> 
> Thanks,
> SJ
> 
> [...]


Thanks,
SJ

