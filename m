Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2461C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5556B018A; Tue, 18 Aug 2026 09:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C356B018D; Tue, 18 Aug 2026 09:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8906B018E; Tue, 18 Aug 2026 09:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 922CB6B018A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:07:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2ED1D1C004D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:07:37 +0000 (UTC)
X-FDA: 85114416954.28.73EEFC7
Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id EEC091C0014
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:07:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=ssVyY3sc;
	spf=pass (imf18.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+FrlVBFSxRPONQ0ZzFJrYgl97w5FLa5RJAF4PEgUfs=;
	b=cH/xEHBvLF1fyI3SqRuPdZsVWtjg6K5pz3b/8w1VGhUnJ0CUEHKyv5Mx19688gGzXoDy1a
	l/AUBud4kZVIzG/PZQGApK4/BY64R/Zl/9FlWhaZPhdpus6H4x8tCBPmnB95we7vju8RCB
	GHzgGUMihWw9hWQpplnrZd6MyAU2KBQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058455;
	b=crMoo/EBtlMe+SboBFZu5QDQzjshczV1SaqaY5ohg0wu6mK6ZguUmc/hu+tPILtSrewi+d
	jP53tTG2yE96Lb43qA/DuPTAT7WtgNzoJ0/JCEoC5dRRpyu4t6L+61EtodagrSRWOdVOdn
	BzhJbJxz5RtLnTAvPEnyidX6BTO9ckE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=ssVyY3sc;
	spf=pass (imf18.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1787058451;
	bh=d+FrlVBFSxRPONQ0ZzFJrYgl97w5FLa5RJAF4PEgUfs=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=ssVyY3sc19bJ6q5l2YmHLAdN0vBOZKLOUyX3lHHwn532OcT974Lhkt1afyooIleJU
	 /NOwFLmzS9yNHvkKXj7OV6bSJnA0aJqcYFF1ZUt5+wKDTzNNxOFL+8kioGCANJ7iqq
	 hBdDOrX8umcjgN1U7E6dC1b1OlHSkMpcX/qsoX9c=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4hPVNg0vyyz6vKm;
	Tue, 18 Aug 2026 13:07:31 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4hPVNf5BfMz4y6W;
	Tue, 18 Aug 2026 13:07:30 +0000 (UTC)
Date: Tue, 18 Aug 2026 14:07:30 +0100
From: Bradley Morgan <include@grrlz.net>
To: Joel Granados <joel.granados@kernel.org>
CC: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com,
 kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 shijianlin11@foxmail.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, ziy@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_0/4=5D_sysctl=3A_Disallow_partia?=
 =?US-ASCII?Q?l_updates_of_miss-formatted_sysctl_vectors?=
In-Reply-To: <4hbx4orb23mruq4dsjolglzgsjue5g25bbmnbeu5w37x7em4rm@o4hp6nu54ye6>
References: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org> <5F021629-DD85-4941-8263-3C4F51E9D6BD@grrlz.net> <4hbx4orb23mruq4dsjolglzgsjue5g25bbmnbeu5w37x7em4rm@o4hp6nu54ye6>
Message-ID: <9335573F-07B4-46EF-B947-502A118AC2AA@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gk8iswzjhj6ujsnm9tqqgisyudqzro6n
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EEC091C0014
X-HE-Tag: 1787058454-204770
X-HE-Meta: U2FsdGVkX191WctqE4/YJ2yXEnLU0mkiwQvsusCVKulIGommBuuyGljECKALkySGw+CzldMqkGDPSmwc2WVEplstxKhl3K/BnsKf/34FhCbjIxgi3+LwcGRfrBDijVAv7P3H4MhMyHwQK89Rj7Gy1aI6B4wCRHhkkscSIHOpnE4Rq3eJqrgNMcC5yk3Bb0PANhicBKrWSPfEPCBYW6ZlfaQib7+TxMQJly7hQ7Csk36N7SNqfJivRhfHogACYBVbQaEqMWMvXsOnFqGaVaMh1vwxU7Ogw2iVmSm+pNZ8hpDS+n/jShcArg1Xv9uo/SXox4+Pw0YmXpqdWBFeGpG9sYMRHOTg9WI8hJ6rWx5eDJtZJbDn39opY4JA+NjM7hx9OMh4KPJh3Jthm3tQXSPt0a9XEhNTeOsbtRh1efqKYD045PKhrL0QhzupNDQiv7gSVgYOkwMfJ3lr3NlI4WpwmZKy5DtJ3xQx8hW6YjNH1wuBZidhOC5oxvXYfok7TlnkQedVZfNU1ubif3YwvTUromwp+ZsWyrpDTahlYXfDsHvLCuFd/i3lBYXbtuBL3Z/dkHlyhIuMuOj6qlFSiUlxkt38bKizPH6JM16yZDUKIUs+cEK2qlSudkoXDrat+biybrLSzA04GSy8ZMoYG5HHnGE1YyjcjrqkmWnPMRy3igzImgDhChaCxuN+iZsbS0rgwv06QP17pf8G9NbC6NSOfHi9BzXZukjp4kXc3G8xc7L79oqDKl+k0FUnY1R8tccYPBeGpGfJJoMt7j6Nosm3Se4d4GS/h9sB3jWvw83sEVHrgS24My1r44OOG0O9G+a8NRlKYklhUPuywVCLBHxb+wMCkONZQfIyvWK8x1vjCR1aSdekjDi17I+t1ms5YzUW2ho4ROh4zWeDkRpeRotZTC60X7qNK579MARAv4+t9ztMhZg8mvbZTLExBsiurDBmVyhY+j3YK4WtBY9l7hZ
 8ZbWielk
 YdQI5mnihpI1YjVQp3XE/KVGrefk1VBm0xOUBc2vmr+ChgDJ/xetWKEIXrYoqJ8ijgVM6v/x+tl9eF+OoPCsCyuRQ/u/GG2MHhujiGBGSU967yTqa3uyU9chH4zYWiX+eyUQGMIT4GpBMqis50CIOoAxg1kEUChvsOY4kMokrpDrpSEmB/sMBW8hU+nm+fClA7t5YAAmMt9np9W7W3qHPjbrobma0cIPprAOzGZOjnSkYsGRDmJrT+t1BH86B0zHWvSrxmO6q/6GYVrNzcJLVGc4Xlkh5//BUFLrrrgw+sLWnUDghnCGR+CvX2XWkg9nDu+pHVgXp5N2TxwwMLuelGiQaiaOu0A48lnqBPuqDpoakiJEr3i3q/VMsQwYzfwSTqWQPLzusm0FEHQFM3BuE0pIOi7Q3Bj2qBsOGYSTHYc7yqHF4goQdBRQ35Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 August 2026 13:46:58 BST, Joel Granados <joel.granados@kernel.org>
wrote:
>On Sat, Aug 15, 2026 at 05:09:30PM +0100, Bradley Morgan wrote:
>> 
>> Copy it, only write back once every value converted. That's the
>> right way to do this. Went through the whole series against the
>> tree, notes in the patch replies.
>Your feedback was useful, but it was riddled with a *lot* of hand
>waving. Please be succinct and to the point. The previous paragraph is
>not needed.
>
>> 
>> Some nits on the series:
>> - "miss-formatted" in the subject. mis-formatted, or just malformed.
>Note that this comment is missing the why. It is good to know why you
>want the change
>
>> - akpm's scalars nit still applies.
>> - Sashiko saw something on this one (akpm linked it).
>In my opinion this is just noise. If you see that I have missed a
>comment, call me out on it. If you have additional information, answer
>to reviewers mail. 
>
>> 
>> Otherwise fine by me, the split is clean.
>> 
>> 
>> Reviewed-by: Bradley Morgan <include@grrlz.net>
>> also
>> 
>> Tested-by: Bradley Morgan <include@grrlz.net> for the test
>How did you test? And what where your results?
>

Built and booted the latest kernel. Its the summer holidays, I can do all
this, it's magical

>Best
>

Thanks!

