Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD9ADC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 17:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917966B0088; Fri,  4 Sep 2026 13:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8106B008A; Fri,  4 Sep 2026 13:48:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6506B008C; Fri,  4 Sep 2026 13:48:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3DE6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:48:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C94EA1C0918
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:48:16 +0000 (UTC)
X-FDA: 85176813792.22.A020D9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E970440003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:48:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1DVOpPPx;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788544095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwuIT48nl2wnt5VCrAZDGkue4mn1dh7YR6PN+cV+12I=;
	b=0ph5RNSVsPrb2OuW/DxeyP6hXYP8hFxg/neV5gfMfD4mIJlqTaP11l5jmPUkr5qz/9UEZS
	SwUJmY0rxw9MCclVoLPcUX1Azsp+hv7JCJC6x8f4oGlbZdMMU31+9pJpHjgCXpL8TEbfDc
	1Hj0FGU/yw0M1ZV3inS9o7hW300UoC4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1DVOpPPx;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788544095;
	b=fzRf2Yb9av636t+/gNEHUQnpq2V5i/iuAeYXZFGz7O9WuhhV/Z0SLO8DafixQPpMRzqfE8
	zlpyyBrCzl98nXg8hYh4SWCHhq8h/xhjnmeWk0GG4A8It3yCOU0QWsOH/z/R/aZz9cFvUy
	SuZ0EzGhdBzl1mYej4xud1eb7n1VMEs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A310A43585;
	Fri,  4 Sep 2026 17:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2E81F00A3D;
	Fri,  4 Sep 2026 17:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788544093;
	bh=wwuIT48nl2wnt5VCrAZDGkue4mn1dh7YR6PN+cV+12I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1DVOpPPxzkSLbFtjle+PtOznHhABGSJhkv2DgxnFnj6LT1TXj0jUKktiUdcbjy8Hb
	 uvic4tyS4/Wf9J33bxg0VuiBff8dLJ5QNKI6/QimDLiyJMUnD++BkSUfEB7oSN62kW
	 aFboO5zqWvsHgrsoCyppOOCvF99cYS2skJUyOuJI=
Date: Fri, 4 Sep 2026 10:48:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Song Hu <husong@kylinos.cn>, linux-mm@kvack.org, muchun.song@linux.dev,
 osalvador@suse.de, david@kernel.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, Mina Almasry
 <almasrymina@google.com>
Subject: Re: [PATCH 2/2] selftests/mm: restore hidden hugetlb reservation
 scenarios
Message-Id: <20260904104812.7ee79803a10ab355ad2cdf81@linux-foundation.org>
In-Reply-To: <apqBn7tWDHQeMrzB@kernel.org>
References: <20260714021630.1063823-1-husong@kylinos.cn>
	<20260901173748.fb7a442941102894a0c42baa@linux-foundation.org>
	<apqBn7tWDHQeMrzB@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E970440003
X-Stat-Signature: mqkws3acdxp17i5eazepf3hpynoz9rca
X-Rspam-User: 
X-HE-Tag: 1788544094-694936
X-HE-Meta: U2FsdGVkX1+P8kynyXIyDjX3OR8zWdFEc/M79QPEIonQEMV/8aIuwotDau0d5qznUpgJVaaENVMrnbs6gScVA6ksi6UNsHTMMc6bzEAdYKhMW84vG4ZxihSidAOYUCiaIeh8yJ8YnoCAQH7/BlhAKgOhqiC6zSs74P9IM3BorLplNJmwe9ztuVghUPSMCL3RYxGxZJIIGh1lwNZ5Awh/eeiBWVEqE8VQrqolELYRQZ+1d1buHWggOPkwwlgV/PM7fbLVeqxFqNFjC9yLGDL4GcczcqfRrIWeDtkj/0khRzQitiUhLVtGYeH2iLui3n4QcU7RisvyrJeZiBT7v0DqybgmNkZ0EwNVr1+2i3RrHGAbQ7+WzoQvqeGzYwaNIo3AL0jlr/+5SwzfXnrVo8dMUBUEFPVMMbrUswDNIo+0+PE7FwRBG+mHaoYTmmCXk0yRoYDSPfnt+3jD/r1P301W7CbLyjkbhE4IyuiEpfhaHeZXiKxEtXyyZn+CsEwJ2ZoiEa4OADKGiO0N8NWDS6OI07Wiuh1jtkprT4+Yu9kPo/jtDRe8FntI/5wKqXPLZpDuy2c8oGilv2QVjNlM+hXI3yVkdrn6sR6YFW6Dj5Uy9Rf8dCs9hQvGPgE/r2Mup4snBETejWWGnUOMb0qobrwKyEnb/czaITs4Jr1Sck62RSRRld5IyNb6p5QiDqakvnX0U5LaF+ZE8vmzORKMSUvhFa/mEGHTiw42KEafefJ19hnil1W0sfJqBZaXUC4dELXzusXXDSkF9XwrmewN4OGE5WfBtqhaIUW2gfi+21p2BAKpFQHkFGu6wO6GGzT/jZe4xjbugt/1HBlkKwMKMgQnBOxSV2f0WN9haCnkawDUOuPkUXp9EO+tNJyrLMI0OI3jU5yTO/L17brNrsYBciOu4qmONU/7n2HET7oNDXiDlw18tbq9fIiEPC7wSWbV3cL3Pth3+U6JwKxoOGu8/IA
 AA+4Yl9w
 PLllRmPe+wZZVRCUsLmAH8AUXddpel1xMyYa03lZCkG/lDMeKeJlxrosE1um2YyAJjmRLgOYpwwHI9BFVqrfHcILg5SZSyNNNWNWPpGedA30VvIBpS+Zi4bVVtPSeA9f6X7dwJhLJ1zxvSpH5urJlY78URWZg5JuqFDXnhpfKMm0/Sz7TeNswIsgle0HzsVWViS3Wc0U2c6JKBdG7yu2RZix6y7KaiZEZZhcyvshc3UJSNebZmDFx7Eov+7CDh8op60cJNBZnPu/oYe+3OWInMbe35TBlgE+bKz4uYr2ldn1hBtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 4 Sep 2026 11:30:23 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> On Tue, Sep 01, 2026 at 05:37:48PM -0700, Andrew Morton wrote:
> > On Tue, 14 Jul 2026 10:16:30 +0800 Song Hu <husong@kylinos.cn> wrote:
> > 
> > > A stray 'continue' in the main loop of charge_reserved_hugetlb.sh made
> > > the "more than reservation", "more than cgroup limit", and "multiple
> > > cgroups" scenarios unreachable, so they never ran.
> > > 
> > > Remove it so the first two run again.
> > 
> > OK.
> > 
> > > The third,
> > > run_multiple_cgroup_test(), is separately broken -- a backslash
> > > line-continuation breaks its local declarations and its hugetlb
> > > reservation accounting does not charge as expected -- and has never run
> > > in CI; skip it explicitly with a comment until fixed.
> > 
> > That's reasonable.  This code was added by Mina six years ago.  But
> > he's still around so let's bug him with a cc ;)
> 
> And this code breaks our CI e.g:
> 
> https://github.com/linux-mm/linux-mm/actions/runs/33040981840/job/98414290236

What do we need to do to view the error output there?

