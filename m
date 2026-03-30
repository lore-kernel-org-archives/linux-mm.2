Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E8A11061B24
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 22:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F39E6B008C; Mon, 30 Mar 2026 18:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D266B0095; Mon, 30 Mar 2026 18:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26BE66B0096; Mon, 30 Mar 2026 18:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1279C6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:11:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E2C1160881
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:11:29 +0000 (UTC)
X-FDA: 84604126698.27.DB96B72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id BB0041C0007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:11:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HWZGK5pK;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774908687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wL6yxEsEEwaULE5fDTTo2PQiypnv7Xy3xqjrIXoEnFo=;
	b=QUrxsBQ/3/6UaFCWvnlED/5bDmUT8OxyF687PfcMtTquxJ9Aw1QiAR6TXozaYOw/uoPPkz
	OmXqbeACjnYoaAD42hLgQhnitu1S1xi3O7xdzRfFDddvp4qReh6nbV8R9VWvPhfFJ3FzT+
	ym23dDCCroWVu74fuFUfq/+NZvS4F1w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HWZGK5pK;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774908687; a=rsa-sha256;
	cv=none;
	b=DEOD6GJP9NsuQcW7/fLqeepG+/HNbmHrv3mhAp/qxJIN2kq9UleVgz6IRhgaogWXLPtEf2
	C1O09kWr39KJe8TRYada0nlwace2AEZhkHUdtaDz0CAJjvMiK9xWPuqIujfnPTe522lsmI
	CR+TJtufDcYFp3vn3GDgCtn/J4RsUa0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC07542A4E;
	Mon, 30 Mar 2026 22:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341D1C4CEF7;
	Mon, 30 Mar 2026 22:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774908686;
	bh=8Flcs8wJZzrHI02Mt/eaFqZoitQYdsBAZWuFqX0qmpg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HWZGK5pKlAgxIRFuQ2YHfRFgJhoE1bVfCn62Pt4YcDXzAC7xJeU2J3eEJp2rU0xwz
	 3agFaCWBb7dwgLxEu96UIdiuNJ7Ue2JYlROiiVkGnBQYlURszQLspmbASxOM5OLNmf
	 fQacPOncyQL8Vwq9sYh709Z3g6HOm4lXzCmREr+w=
Date: Mon, 30 Mar 2026 15:11:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Ritesh
 Harjani <ritesh.list@gmail.com>, David Hildenbrand <david@kernel.org>, Zi
 Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain
 <dev.jain@arm.com>, Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 00/13] selftests/mm: fix failures and robustness
 improvements
Message-Id: <20260330151125.d0b6cbb24b273bc963b05116@linux-foundation.org>
In-Reply-To: <09104413-483f-4852-9d7e-71e0f86a1754@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
	<20260327111104.b8bc18be45172639f5b9226f@linux-foundation.org>
	<09104413-483f-4852-9d7e-71e0f86a1754@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zq8fkyddeiro4h6p9tbdpeecmaxdioic
X-Rspamd-Queue-Id: BB0041C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1774908687-81684
X-HE-Meta: U2FsdGVkX18hpAP4GNmsmWN0KeDL303gmmncnEO3sTKInjx/JxxSfi7FP7IuJHysAKbbOAFvKcqHj1WyxGhE+u9x2qwzAWLRtgK5x/cL7B3eI9y805cTuOJZwmHZca1gn89SA/bmIyPAheL/eO0fSskihndrz+8O8i49WSRJfRBb6F0nlqYAhE0tVP9oBazgot9kLj4FWO0X5WpejDK6JFV1acAu9wEw0hl532GK3qlUbfn1jKT8ehHWSmBoprdMbaJ7Nf6MAVL/dNOa3mCJA0r3rWUeTgvoUmUV0Y0FzhoRrLFYCe1CBe6nAuyfdbz0eUeh1X9bf4BvRFitx3tqQabXtz1MrE913o58h/2s8OTEU96vAYCA04sBQnCa6kn0zJ3rNHOguGyklrE3BG7rq4tm2CI8cGqXd/d3Dp92wwQTor/+VaxfSBecSY+b0DavJdIo1iPlyZSyt77/hgN63T0MhLSjxdqNOV74nZV9/dJXrF4Tc3AbGLem/6BzP7lmCohZQsCr8f+WHYA7kpqtqGMc1O9eT7Pi4l/VGHgJ7aEPnK9gBs/4Xa0m5O3fCi4fZzJvl6XuerahoI6daVRLX1pRh0XigSeRwRmWPiN/Keyl6bhzB+4nkRFlGFNnqpJoK66bqtIk0D1DQGPd43OqeYPntR77/2Q1OZa3pjyP8MZ8AYAKOpbj639S23/uHfmsVnM2c0M++jFQQBI0HIqMMe8/Ty6VNE72qNbG5xqzoUlqOLWi4GBKoawOMen8oU+HKqlWX+yHDpG6ee4Sp8hGeJu4Tg3FoTSTnH5e48IQHIYy/ta+WwaWD9KvHFqSUNkCgJZCTUbXTzkYvK0sVIgAuEAcpz8JTGWwxhseBDempDqOX9Gkgc6nuVV+VKijCmBxwJ9i7EzIXlf9/4SHp9YDjvPaD0M9IdX/awhhkekW0Y8v7gZT6T22WVH+rZ8sDLxEhyN2TVVoOmrzB27WNlF
 T84ufVvs
 H7VEgMqJow+oMhjs5J8qqYC63KK+MlIORUwdxL9LjyDupAVsQfLaUbW2eXU4kjEyF5W7pe/QIhyDEg6pIePrnC0ZJ/nfuaLY9zitt4TpvDx3vzReWOJFwyjC/n8kIGDxkwNgR2L5zC22t/0p61Z3B++1qmp93NfQAYgA9t3O4Qp7UHcqxu4TazMycx4JIkkOKrQgjImfIwR+Gs3Ijr9baCRF+NS2baLeVIhAGfmOSic8qSpEapjVxHQ/VQL+Rmf/wc6Xa0MOYAW6vNk/NWVOqhDZuldyOau6ktCiqqg3fCoApVQ5GD8l6uGCNqSS9CPvDBYcL3N8bbKdD8MxfXFG9ZgCiT7rmCzp4Hc1eRrkGEZEU/IEWISv3OsBMtmWhNz0DOUj25xuc/ChgnqHX+OZ8U4JU+GTu2FMCVV1eixwUVw4rNij3+Hf87u5w9x/n/FHmf03LQv8fsC5Fgzzw+F6LVsymwT05hUiutHMk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 11:27:04 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:

> > I don't want to risk breaking selftests so I'll set v3 aside until
> > you're confident we should proceed.
> >
> > Thanks.
> 
> This line continuation pattern has been used in selftests for quite some 
> time. For example, a similar usage exists in 
> |charge_reserved_hugetlb.sh|, introduced here:
> https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u
> <https://lore.kernel.org/all/20200211213128.73302-8-almasrymina@google.com/T/#u>
> 
>   echo "$reservation_limit" > \
>      $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file
> 
> In this case, it was primarily used to keep line length within 100 
> characters. I’ve tested the script  and it behaved as expected.

Great, thanks for checking.

Series is nicely reviewed and an earlier version spent time in mm.git. 
And the bar tends to be lower for selftests.  So I *could* break my rule
(https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org)
but would prefer not.  What do others think?

Did Venkat's report
(https://lkml.kernel.org/r/cf815c21-138e-44c8-986d-d8496503ee32@linux.ibm.com)
get addressed?  I'm not seeing that in the v2->v3 changelogging.


