Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77BACEC1120
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 18:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85B86B0005; Mon, 23 Feb 2026 13:55:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33416B0089; Mon, 23 Feb 2026 13:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C151D6B008A; Mon, 23 Feb 2026 13:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE3486B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:55:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 658661A025E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:55:52 +0000 (UTC)
X-FDA: 84476625744.08.1D749EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CE3E2180008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:55:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jgvBta5f;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771872949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puGVxrTUkFvnPtmEDiLABXTCpqtFGLbD0oVrmyrxZLM=;
	b=SrJTIesH+KbZ2HFrgJj8C96J0dFSpK4tc5Kkt3fWXgohMqEK8th/WIuNWOFX5I7RMr24H6
	KqvyVmLWy1ZVsUXLxAKA9kppguoEC1uAvhsApJAdfDKDwGADVWWOSg9qXioBXsevjmgNdo
	dTknEZRMhNCbroe9KrExXdW62GLKcLk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771872949; a=rsa-sha256;
	cv=none;
	b=JfHjPu5GJVjImitqaHTYpqKaLyQwS/6WDfSs11teWFrzo888DX5pVInISj8YYQXzgqavll
	dE5z3LnziMpiJNuVofigXEk/xz4K33x/XRbSo2hvVsTUasvsk9Tj/1bvDQ/EpQiTO1gHZs
	UsPjrr2qO5vXj4l6mn3mjHzWnMhhZ9c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jgvBta5f;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4942360145
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11E8C2BCB0
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771872949;
	bh=Q5Hf8PxTn0HsGWdzSmEeJ1AOfzBulg5cuO6xu0xbVbA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jgvBta5fF6oTtUxBugCo6U48aWTpJgEYPrQABIMLhnToYkJWLK3YLLhPIUiLYY8BP
	 nFp74m5H9qOyEu4uhQICLo+5YgUyNiv/81noRzH0M9rmTj3NNE0rdYSsnJXSHezpDq
	 HtLhbCVkln3vwyT6rVrFbsburQevDdv1JJC8SCBxQRjhnUTm7Wztcr/WoYL4H4I5pD
	 TV4UeLYm62LVyephhT/cZ4gri/HJsKeCee544FpuUNEbF7iXfFkZOffriaxXFTyYSs
	 50mTxnwxS9dQgtlsFoPVy9HWi8Z3PURF6hpDkkhJ/aby608tMMRFIxRWddo78kFHSI
	 6jVi2VmPIRS7g==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b884a84e622so704113166b.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:55:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXAO9XzV7FtSzPMAwquuW/1VxpKj3B5tBmW29Gb6n2b1xOWO9x4DADOaXR5rKPnO7ckpVwISgk8vw==@kvack.org
X-Gm-Message-State: AOJu0Yz4TFfw3BZfM1xXk+VHZu5lvEA1WRFVu1Lk19b+fRmqiij6l1Hi
	+KKsRg4NUrXPG6trFJRs2ty+s3mORFZOvleBLa3yz/CegqcgDEfFhE4qd83xgb7Syt+fDDZMJvt
	usAvCp76Zzdb4YR5mahMRKeFPB80iyjI=
X-Received: by 2002:a17:907:7201:b0:b8e:14cc:9197 with SMTP id
 a640c23a62f3a-b90819a0ff0mr716527666b.15.1771872947772; Mon, 23 Feb 2026
 10:55:47 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7CCcsh2twG-Ud2b4U0hZrAMV8zmvLaM=NBDvmoaWziPqg@mail.gmail.com>
 <CAKEwX=O4ishgvhhZ1ssgbDUQewFamkyFT-uCpEWecWfe8SzwGg@mail.gmail.com>
In-Reply-To: <CAKEwX=O4ishgvhhZ1ssgbDUQewFamkyFT-uCpEWecWfe8SzwGg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 23 Feb 2026 10:55:36 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOZYuQWmEvSPSmBs6gz3HEWi1-MJZ0=xxV2GkQVRpMMkg@mail.gmail.com>
X-Gm-Features: AaiRm53lLxybs3hbYWn6dZ-mzt-lSQcIYrW1MZyGgQycAcCVbcmDKxVOUPOd5so
Message-ID: <CAO9r8zOZYuQWmEvSPSmBs6gz3HEWi1-MJZ0=xxV2GkQVRpMMkg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Swap status and roadmap discussion
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, lsf-pc@lists.linux-foundation.org, 
	Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Barry Song <21cnbao@gmail.com>, Baoquan He <bhe@redhat.com>, 
	linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CE3E2180008
X-Stat-Signature: znpepxwgjqh5sgx9rywwz7ecyt6e8ukf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771872949-177775
X-HE-Meta: U2FsdGVkX19/kbOZYY7lFSsMQiyNBE+LLxdbNR0cqu/MHmXbhuDhjseIYLEw+GC7C/mx/QLXC78T+HTMdiuLrumZZIYKV1Sf8HIwAgSNaWIJpq7tbcf8gjLqGUavNbNUQT36h4WcZtmazlTQhdRWgjiQ08bOF3RgZBLhzbUB+L0N8Gp1zHXEWck20oQv9c6FeeH8bHg+9ZLau5lvXgY+q8FjAppL/il5ctYwE3vA8cXi8rynRV+tSQYxCiaSK5kygaoAKiZ+kn3ImvqOin9+Edwg3aCwFymsr5Dlq9wG029SVR4QbD+ndpG7Z0k74oBvT8JSRkLjunx88lElimo/VuDzk9/26XQYjMOunVWy+T7XA0m2lcDp1P19Efsi2tMXikqTzATZm+XE6v89MPi4DHZr3BXj39roQbq/g3wnEqk1zDFWmR85Q8GOqs6qTKrczkbIvE0ED+lCJDt+hwOuw4Wa7tFHteuxKheHMEMV6ws4KOgICnz1rVo+B68gvf2LfaptU5z//L0z6KDnsM/l8s8dt0vDcgbLsdyxI+3litl9cgMROFjtDCc/jwB17MTkDQBYuEPCcVkeIGcjmqpgLkBFXRbUhaq8Vcson5MzSpOMCnv3g4feRDP3dmwO1ajvtmS4OxCj3CxFBsoCQDYo/c4ykUyVSIqgtLJPsInk98fS94/AjLQS70GlsowQwe1BUNDdbI26sx/jPhE6ULsCcYbdxxjPUwsN0pqKAwyNFxrRzX4bU0xpfKgvXLlE+jzlAmcbaDsUhba9FesTvGJuCGha8f18eaUdM6dBKWL37Vk9XXKk4Ce24VUTfrHkDOdi5s7+QJRfFMMhoNAqFZ2Z5k9Y/binArme2S3TdROHxQuEl7r5e3zJsBxIWW8NnKb29mkOzSJnXgGoE3A4aNHIYN1k0YeLdnS51yi1QMOFsK5trnQYBln7m4iVjcwM4bbu4ODNgAHF21M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > - Is 64 bits really needed for reverse mapping? For the context, reverse
> >   mapping here is a swap entry recorded in a lower / physical device
> >   pointing to the ghost / virtual device.
>
> I think you can compact this a bit. Swap space itself is not fully 64
> bits right?
>
> Just not sure if the juice is worth the squeeze to save a couple of
> bits here and there, especially if the reverse mapping is already
> dynamic :)

I think we should actually revisit the need for a reverse mapping to
begin with. For swapoff, we can probably scan the virtual swap space
looking for entries that belong to the backend being swapped off. Not
as efficient as a reverse map, but still better than the status quo of
scanning page tables. I don't think optimizing for swapoff is worth
the consistent overhead.

The other use cases are probably cluster readahead and swapcache-only
reclaim, and I think both of these can also be revisited.

