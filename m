Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18966C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 19:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAA086B008C; Mon, 24 Aug 2026 15:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B0E6B0092; Mon, 24 Aug 2026 15:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4A186B0095; Mon, 24 Aug 2026 15:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A50DD6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:18:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19F1EC0245
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:18:56 +0000 (UTC)
X-FDA: 85137125472.05.806606B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 365334000B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:18:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bA035ozC;
	spf=pass (imf12.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787599134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=bDDPwn4xCpHQCGnWoBvi2mfgf7tmYr3K7oyrB3+/vVE=;
	b=bHtlRHadYFSDrNI0tOgvTHdhTWnUrDIRLEjEkW66fLm3vYEzlMHMOeCViJht3t8Dbpm5Ke
	ib9VFO/FFzt9eCzoug2xIEQQd3kIBDLD3oopE3UXaXv9/Smj/tYue5dFNbB1f+B8h20l3p
	Dc+uzfKRKJKCn7P+zATHsYcexjCuinQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bA035ozC;
	spf=pass (imf12.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787599134;
	b=lkppzOH2SVU+PFsH2mJqmsz6TYX0c7G/HDXoVmNl1GaTyXZ2/lRtz2MWvfWAfVOFmoDPWR
	mpaByuj35VHRO63C4uVOD58sMui3O9Ue4KJ0Nqa1XRunX1h6JYyXqHgE0CFYw5aMo79Qti
	T9/kpRmyaHF8t3uuxAa6d0/IukgCkjM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A60143F3B;
	Mon, 24 Aug 2026 19:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3871F000E9;
	Mon, 24 Aug 2026 19:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787599133;
	bh=bDDPwn4xCpHQCGnWoBvi2mfgf7tmYr3K7oyrB3+/vVE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=bA035ozC1RcPbXOOGIblgpGpgDPorErz8t25zM6nfH2nlUUFHbiyXfVnEW1jbqsZe
	 YLirPMEex8SLSZ/SRJh8oefTvN9y9F11uHw9R2JYN8/myRYvpWMFCOufGsLUEVYnls
	 NFnkTpXcVXmobJp4X28Vh9Y1Ei/bd9m3Xw5OCRrvvlkkcmm8zt2GusMI3ybd+g9cBc
	 rOhtYOkJ3kAp4yG7bXfRo78ypjLG3B0pQpMqL+uDuIUNWBUXzSK1xY8at7CSHhuyzp
	 QwCJ6JmU9B2bMxmYyxhQQQnONDcD9GFx4TOVXnkAbPFRcQAtfIqL1l6BiD4+hRti2P
	 rBnqGzHrCqe4w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A983924A4C;
	Mon, 24 Aug 2026 19:18:01 +0000 (UTC)
Subject: Re: [GIT PULL] slab updates for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <321f40c8-c694-4cc6-a4cb-df0c9b3d3fcd@kernel.org>
References: <321f40c8-c694-4cc6-a4cb-df0c9b3d3fcd@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <321f40c8-c694-4cc6-a4cb-df0c9b3d3fcd@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.3
X-PR-Tracked-Commit-Id: 564ed40708ebc60a78f280944799cbe8e3401816
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 918e25291ce95ef26c288234b088e9d433ecd94e
Message-Id: <178759908041.3075085.10406364731845307805.pr-tracker-bot@kernel.org>
Date: Mon, 24 Aug 2026 19:18:00 +0000
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 365334000B
X-Stat-Signature: uhrs8hr5717p7ze93kinw7jrcd6zjgc6
X-Rspam-User: 
X-HE-Tag: 1787599134-293144
X-HE-Meta: U2FsdGVkX19s79uOIZVwUcEE0VYNmiYtshUQ1YCVZoDmnLUKwOCUhES4GSfkPXo+d4hgoSua/sVuIilVHBUYi8M7IQcsGJ6Ms0l02jYr85hn1on4v1lpX1ZzY+DgBfihVJB9wfDOc44tFCDsVRbwDWcdkunqSZP1Qkq7D4sWAFJrEhnNf9iJI1ER3Tkpl7RXHoL3AyHxHMypHy5gYZxMb7XExJQqq+nF8qsx0vq2pbvWA0kCEoTfOtmLO9BbgCvA4F3hgKpH63QPzxh77D/E5X8W+imMMdESm8wSYGi5cNcsYRMEisznpC82V+YVNv7RSW1bfwdRzGJA03UJjrFRZzXr+U73wkbUnjbdLRy8Ac2EU9HlFD3TOIUPrvylEWFZXe2Qyfj349THUg1ImtKKWZb0R/UskjinsbOcxQVFl5Rl4O9IGuLtsa17euM0qgre6RPwd5bazsFEBZgwcaJQui8zgor31sIWmN8GvKbdeTROomEmU8mQe+5p/u/I8Uh8saNp4H1du1JO60g03Yt+TSLGwGZDZgcpHH6qV+i0a/OtDNr3ZpV1DsbpwD3vh0w0c0bz+e6GovON530bzQcwtjiD69IFL79kpeOaWN6obysmEsZQG7eWL0ZgDfooKGTviT/xzGGdyTeTtmyrLbn0akJAKbtslSWBIGrBx0eQc8EaWFxFSm59X2jKkFFh8olAhYWtrca1mJ692VEttNhminF3lrbYLX1DjGZD8Q5a5qU4Pmq0geKbLgxlZWDYoEWjbYtazR49nwLdji6uqyvSXNRZnADvU9TbQn3CI7SKssc3X/Ai8yEwJZZC5PM5Pq2709ef9qt2QFydfTh5i4q1qzBUzd1gCj8Qat0XrU3eohvNyiROow9Csg8mbEDpqrRAkl7V5WOlsZUtRYTdCpoOR+9aouYsvLf/JIQHubEkMykd4JHy1eQUix2v8TokO/vWis+rDDIhPbkLI81ltN0
 +Gq11YeP
 gVlvDx906rpykDflbzzmFeGNbNW3WLNmgveMQaJtfuRcV1gVzGK1HeADEHHeyVTIMIAT6hHR7zCJgrSTo9JDr2ENSLe24IUdmKyiFZ2IuXGPm1+wlAkz1KQVn6jDuZhnMi4nsQbYIiLIgdp36oq9zPkP2q4EjCGfFG07EdZyu7gI4RSgl5oAXBk7xIJtVvy0SBVqN/HcftFt8ucJE/Iln+AzS5S3JEdx5iCsRUAUwC7kqlcS67jK67z+f8HEDsykufJoElEArM6Y9/OW1YCfIIYRDACamj7QsCy62R6be8GGffeY4kVb0VJLhHLqB0LgXOqhYGMTTiA2AHytQhjKi0v2bxnzOqy5OenTOvgr9HJWnSVOuFFJnUxYRyPNCScIODq+OzRRgMbxsXqBT0hr3giSGoiFu5oCKX69c6ysDn0egizV4uIy8Q27JVov21vUN3vvDwPyrWVcRQnHSzOBHToX5p5Botf0CmdEt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 24 Aug 2026 15:57:51 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/918e25291ce95ef26c288234b088e9d433ecd94e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

