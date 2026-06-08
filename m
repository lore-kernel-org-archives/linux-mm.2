Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9DBCCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2330F6B0088; Mon,  8 Jun 2026 04:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4366B008A; Mon,  8 Jun 2026 04:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA696B008C; Mon,  8 Jun 2026 04:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 021966B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:14:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E92EC3223
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:14:36 +0000 (UTC)
X-FDA: 84856033752.01.B08D27B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9E7DE140013
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:14:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ojQPN562;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780906474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpH/zlRhHjTc06tdM4f68buEiSq6Vkp6kXQ083ejESQ=;
	b=LqMeimeRsf4O5rDel/m+WHcHd0EXlrZwJi9pPS7Xo9D2PX/zk6UzYpgylrXtv1Ul59yPo5
	wZ0BVIeDEjQ5mpYB78xYjuturt5DejkZsgoywIk9MyCOburWbl3AIejhAG/bcq9m0zhRGU
	vkmegNrRc/2rNFFbRA3kXYfNSA9CRcI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ojQPN562;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780906474;
	b=mNnjjrGSIUwrwv/goqVEBSCeEDn9IFGxmw2Mm0Oi6IiI7HNRwzrkDzDdBeynt+DHxVayJH
	0UrolnR+DkopMm42WrioQx/VL1hSda0qGUulQTLHipZDF1JPYzECg8b7f89BNhkaNitQ4x
	c8AON93kW2wFML2P3ffBhZJXmdnaBMc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC97543D5F;
	Mon,  8 Jun 2026 08:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F9D1F00893;
	Mon,  8 Jun 2026 08:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780906473;
	bh=DpH/zlRhHjTc06tdM4f68buEiSq6Vkp6kXQ083ejESQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ojQPN562QoWHR+TdTkN2GuTZAwrOuXOmiNT6LECGD7COALg4AS86+0sKiH1uBpJMO
	 Kg0vgw9TGCD6GLK6Uz/VhkD2wzkETuOalxPtxAwkbuShvJ6Tjjjmr9V0iZPKH3DSBE
	 PZ+Pyei59ZIUTVaiIyDqWEP9dmZS80grN7kQ5QrJo3Jh5mEQgKPNfhXZY35X0QiZKo
	 xNfjO5YbTpx2Xa4kYXd/cO/3BTKlFhcAd0PDCU9LPjf9m0KZnU7rD/GXyJE46ajNla
	 cavlrpYUhCOXOfO3x2W86VtqeoC5/5HJyze+kwZQWD2KFmjXsJ3cG/aI1BuTbtzimc
	 ER38V3Bir5fVA==
Date: Mon, 8 Jun 2026 09:14:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
Message-ID: <aiZ5qFTc6XDMsqB9@lucifer>
References: <20260606015729.1837935-1-surenb@google.com>
 <20260606015729.1837935-2-surenb@google.com>
 <aiPWD6xZLg6g4DTO@lucifer>
 <CAJuCfpH74gRmgm2tgwB7SHzL9DrU3Yc4LyS8XLa0tR7fJqaw_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpH74gRmgm2tgwB7SHzL9DrU3Yc4LyS8XLa0tR7fJqaw_A@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9E7DE140013
X-Stat-Signature: 9c417pmtz7e7su6ey4h1mhf734fi4m8m
X-Rspam-User: 
X-HE-Tag: 1780906474-160673
X-HE-Meta: U2FsdGVkX18QZOntkdvy/1XWFFYIDZeFV+GJB3KRkbKwa/6MPd9N0zQAi0aYl7wNjcAZGAcahOZ+UA/jtOYX/JeN2in/K4g5yxCobnjX6AYGJlOxO6R4qWgFLXDINOhAgPcxamEGj+PVddNIgjR04QH9mlegoviCXTgAIJLoKU3408krcoaV0T1gz1ODay/BIXHcHANk0f50yCHxMUEkFPNKWKZJHhUnA8SapZBBV4ApDt8r2sbYjeZEsy7CLJK8LpWOFUlrW6KuzBxyantUGBJ2S/1MzNE6LE80Tfo7n3Pb5blNI5ImasH1u+wrGULNZgYziRVw+HSI1KahtYec/txL2M3vs2keYY1zSP+sj4JKk7CQ4jY1K0nI7L/Tofuhv77Am6wFVSb+mmYL10ijl6dosaU0XNIhAov+DXkUY+FUgoOSkR00kutMmIdYP6N4JjjUbaSw7zWJQvnxeIzxwW5Ooi6uwL3RRdeWcJH//ezE77dRz6+TvonhJZ7SX+ODrIfKfoqIThBfBg1v1qjUTb90sWXNLDhV74YTJvJQgrXBE5qfa2EJ7NdFxhkCac3Nd7x716urpsg7tbnUL3yhDZd0jskQkTi1HsYwXorA0wsrIJNIT/hUvrnCKcQa5xc9QNu9A+bKCIyW8JsCtkwjW1Sk5FRHxT7LGrikBXedjKZBmy7vO/7c19IGE08/GCzyBGFo0jHwj5TeUfwP09J2+hNlzwXyor1i5AUYlj6lRCyoOk+fH3Fybe471i8O20DHyiQj1tAzbfL8hoHen+qWUJ5BrDQKFWxONn1gzW5At0tIfPmPmUuB3cDloligff1p85nmRil/XanqcJg+OeEpr9I7+agbT/y05m/Z+2XjSIXkqXAmeAkhG3HeMGMmZQDpEmwrO+Mu8D49JTJOPKM1Um3629OerrZVNFt92EanlHUavGpzIaQxzNVFhuCE/ZYLpcvttekB3/ei2op+2Ho
 MwvGpHno
 jq7PktfqxynKEaH2gXxe6zx9EsqOfEpSO/MG0j2KI4b4gQ/bCQMPD8R5mEoR7M9f0eGrNPQ5z2L+Vat4mPByvGHMY+7iiZQ6gdiBq7b6FhgnBnOvCfyBGiVPFs3GkFCQY68x4TrTtuQUw8IvEg5ZjoF9TByaD5Y8Mdb3NI4qit0PUTfkhaaV8SJzowM8boaeutmZV8/Mngd08MppLpNxcswkCvuN/e6ZqI2MdG1yEnOalx/AUg6rU6+mZmwgRy3oSbeRgmxvnbROyuavLz+yjAXkRf9xWRvJf3s444Rr64uSGiamDt4uNq4G/G/6m9nb6prggnQ9B1GcL9MwpBy82c5eT4M3TGD4LOLWL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 07, 2026 at 12:45:23PM -0700, Suren Baghdasaryan wrote:
> On Sat, Jun 6, 2026 at 1:12 AM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > (Will review separately)
> >
> > Sorry to be a pain :) and I know it's a petty thing, but even for a 2 patch
> > series it's easier to handle if sent with patches in-reply-to a cover
> > letter :>) also makes it easier to track overall updates in cover letter
> > changelog.
>
> Yeah but the first patch is a simple cleanup of about 10 lines, and
> writing a cover-letter for a single patch seemed excessive. Andrew
> would have folded it in with this patch anyway, I think.

Makes sense, sorry to nag but I want to be consistent in nagging everybody
the same :P no matter how well I know them or otherwise ;)

I will take a look through the patches properly in a bit, I meant to
actually do that on Sat but got distracted...!

>
>
> >
> > Thanks, Lorenzo

Cheers, Lorenzo

