Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D4EAC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 09:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A116B0088; Sun, 30 Aug 2026 05:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CB026B008A; Sun, 30 Aug 2026 05:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA846B008C; Sun, 30 Aug 2026 05:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 000F56B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:32:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AC43802AF
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:32:02 +0000 (UTC)
X-FDA: 85157419284.20.292666E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 99E53140007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:32:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fCCv+HHW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788082320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nvYs9KqQQiDFu9j18mNGTYlbSQTfBbCYWUQ8jg0y0r4=;
	b=KDvnL7r5wWV2/d7bG3vXlCLgM/dsOKPVWOWigCqutGq/5ba+fILsdqcAEkjkVl/rwuImRu
	d3DB3EGmnw9BkLOjX1S5c/K4BC3VUPUtheGCE5cJyK7T8p8iviLNOySL4kw4tqDO2sOeLg
	wsK2pLP6ZgaITwe/5qDSwubE7PRdxNY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fCCv+HHW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788082320;
	b=Bnvfh/llKIzG0x4qz1x7zczdDaeVrOxLwZuBkgGwa66BpnneGDd6EiWVd0OircU9kyhDVJ
	WBinRlGEQ0RtlCvsl2Ury+kqcSARhmAiNvsBFgre6Bj19eplr6Pb8KdLy3nGdQMrmM9IEN
	rA3L7m/GmFpalReYRewuNWC9va06EC0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3B36600AE
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B67C1F00A3E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788082319;
	bh=nvYs9KqQQiDFu9j18mNGTYlbSQTfBbCYWUQ8jg0y0r4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fCCv+HHWayBekTpcF1F3IRCa/NlTMeI0SHFmDk3sJXRVzb5NYiI4k+PAr1AcvyU6Q
	 3YAt1YQIi1PVpovVNd5xSEfN6Hs3lLmAnILDBFG5GfLK7l/7AH5vEjydVEs9gN3H31
	 inOHTmiBDKTyLT3qhRXAt5kJNuny/gM6XkeiTagk8BjJdhm9tnLLBxD113isvnQKnr
	 lJmAWlzKCyuw2jt93bpkuOqmOV3rk3qfIzegw6Vc6J3/XmJ4m856w8qfFeuCWX5a7i
	 M1gX0nk57QVgeyHMTgrl45j5cgRXvMxYPyGVxp9DNHb+JnWzBuBHppIvWBNsfYGxFa
	 BNw2amaBlp1yg==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-930f618435cso182145085a.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 02:31:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp4OVf78lOufudtNvV5CcBB5vY6Mzttd+eVjD4UKBOK9T02a9rph4GDEjI8CcUn3zC0AGvYE7eHCQ==@kvack.org
X-Gm-Message-State: AFuF++lAIBRE0XjtH+W2A5xQbd0W9tKeAHcprbPaZsf3PGI1erqpChUz
	1S2vaoVhexwg9yzwpLC5JtgBUYCNToiZYUuIXTT+V8UlagC38URK/aZSSObcxRmMRBWu8FhXWMG
	x+pB3vQxh5VdwASUMFDkS7dn/QsHR/yg=
X-Received: by 2002:a05:620a:f04:b0:92e:6a33:7118 with SMTP id
 af79cd13be357-939138df202mr1911249285a.30.1788082318676; Sun, 30 Aug 2026
 02:31:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com> <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
 <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
 <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
 <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
 <CAGsJ_4wpUBOXKd8aGNz76U+87bwDUXZZFSW2UhNcq4qpjVvggQ@mail.gmail.com> <20260830165401.1788080041-1-qwjhust@gmail.com>
In-Reply-To: <20260830165401.1788080041-1-qwjhust@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 17:31:46 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zGN9rqqxoFU66G_PbXqTiDaeV_tUiyr8vbfxFWEJg62Q@mail.gmail.com>
X-Gm-Features: AcwNN1XZPfiog3RD9yg8B0eXNaoAai7OPxYRVCjEpqabBekjMlLKWknwxqjTMg0
Message-ID: <CAGsJ_4zGN9rqqxoFU66G_PbXqTiDaeV_tUiyr8vbfxFWEJg62Q@mail.gmail.com>
Subject: Re: [PATCH v4] mm: filemap: retain mapped dropbehind folios
To: Wenjie Qi <qwjhust@gmail.com>
Cc: willy@infradead.org, jack@suse.cz, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, axboe@kernel.dk, 
	trond.myklebust@hammerspace.com, tz2294@columbia.edu, jaegeuk@kernel.org, 
	chao@kernel.org, qiwenjie@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 38zt6wn7fqfpg1mg51ityi8xc8n96n35
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 99E53140007
X-Rspam-User: 
X-HE-Tag: 1788082320-570718
X-HE-Meta: U2FsdGVkX1+OSOtWeXAvooO+3rwLwyjPbE9vYM2tpXWPEMEHzv/VR2AJlh0yMvx3JDO/yXaWkInjpusC4sPOu8m+VuUIPlFEN4PRXY5OVJYJbp2Er2hhxGM7kietFmD9ulTgFVwP4vfZO1HB2A/Vf7fCRTZc5QNSW3ZZUeRIzx0G09germKRKz5nmeiHJ8VsnkKB1Pp9uOYHxMjTRwALWQK/a+CWGAuOEk4ALKCWOcFzrf53kJGnAc1WeQ5KciK+7jOux9eCzt/lFulPG0B0c1pn65wnQY8e1klM23mnQL5JpJ46sFSfpSUElEAStlh4p+Sl4xw2ubfj3gQEX1eqd4N/ZEEjvY/AoOP+yOgWuMHUfpvpAhG3g5loqEDhm7NFxpmVxzfAmu/d1gu+4fhLVOF+4GkjnbjPFsyxEcVSa/gEJU5KPrLN22qTMtIU7xLcIfoaxEe4HoXaZ1hqHB+iyVprsPWVxD5DzkZz/f9xVzPqDdGY98rg6JwTrdCJrTsgfw67XCr9zAG9Njsvj7SQzHsdS6N200HQWBjMhdwgAvls2eRwJmvpt0TIAeMw00dVNHPU8X/L/jth2qwaM3Ejx372gphw1JBlAd0bM0wN+m040Q+tEdxBRVTgleFLsmgZOWrE9/7+iyFGV1Amn1bwSRVEDFkXO3rwYYn7R4wrhdXpu5pLPBD4MgK+Kt53LrSXv/xFfH8WNbCdZPTMOMil+gie4cvmLBQ7rB2zSks2Osbe7NHGy5EW3hmY/m5rHYFmEBW3vmzezXEkYpZLlqOnvsPch8z+MlZYJg6o6r7WBARJC3ZLJVHj4I/5qiwIBuHFb27EuWZclEsoNswm2hdk+9MGb38dHurlW5Zq9WmurPz7c3VF7jU4jVWec4+xY248AQ64mGbGUhKGDRMttq37Oesv2v9vV8uZvNVCc3zeGpOhKwdWxq5R4BDlJja5+cSoTEcrB6PdP8FyE+KshVH
 erRs9vfH
 WSZxD0pOxvGO2vUnm8SxPTbGssMxfHxV9neO00eUwvHg6kGMUICe5gxRF9bjOAS+7DLp2Y2Ms4k4j2kM8osPhyoPCKvrXTcv8tJ8xz8IYFR4vES91YGWyYNEUs1p14jXP6NYsw4bXI4EJksu1Tj+AjoomwXzFiurPuDljipgU3qfcqNBG6QAfyPcw410JGqgVbEnG+vv6IZII9HwRAabLENn0JP48xhGReJVr+zDFui59CicqF+HfSDGCYVKRqhUvqrSNTPnrHZYbA5ziGg1OGlCEGnon6VVjzKs6MDTcJ2n9QMWhF1+LxGOgOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 5:13=E2=80=AFPM Wenjie Qi <qwjhust@gmail.com> wrote=
:
>
> Yes.  The current path removes the folio from the page cache, so a later
> mmap access can incur both another fault and I/O.  I should have stated
> that explicitly.
>
> For fault-around neighbors, folio_mapped() cannot distinguish the faultin=
g
> page from a speculative neighbor.  This patch takes the conservative poli=
cy
> that an installed PTE represents a competing cache user and wins over the
> writer's RWF_DONTCACHE hint.  It can therefore retain a speculative neigh=
bor
> which is never accessed.  Distinguishing those cases seems to require
> fault-around to preserve the faulting folio while not mapping, or later
> dropping, dropbehind neighbors.  I think that should be considered as a
> separate follow-up.

Yes. Maybe we can skip mapping neighbors with the dropbehind flag in
fault-around.

>
> For folio_launder(), filemap_end_dropbehind() holds the folio lock and re=
turns
> if the folio is dirty or under writeback before calling
> folio_unmap_invalidate().  folio_launder() also immediately returns for a
> clean folio.  I do not see how nfs_launder_folio() is reached from this
> completion path unless the locked, unmapped folio can become dirty betwee=
n
> those checks.  Is there a path I am missing?

You are probably right. I was referring to the bit wait in
nfs_launder_folio(), though I'm not quite sure whether this can
actually happen:
folio_wait_private_2(folio); /* [DEPRECATED] */

I assume we won't wait for `private_2` while the folio is clean. If so,
it should be fine.

