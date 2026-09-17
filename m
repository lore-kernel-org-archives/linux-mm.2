Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C16CC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 22:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033156B0095; Thu, 17 Sep 2026 18:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 009D36B0096; Thu, 17 Sep 2026 18:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63FA6B0098; Thu, 17 Sep 2026 18:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF17D6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:11:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10886A5CAC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:11:36 +0000 (UTC)
X-FDA: 85224651792.03.8DAD1F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 60B5A1C0006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:11:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h89Ps18w;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789683094;
	b=7sH2D94xSA+nl+w32q0+CbO3DnGTqRJGjaqHgufFVsncm1X32pddJA5GZZ0iewO+U0M0rZ
	tZFue7frSalabXHW5WJqcF0zBnkQrOsLZLf/QUScX+zZ9sAVLmGMeW1WkBjbrKB8SfXPoC
	Ixz/OQi/2uMfeHFBfJ3wlS6iXaV9MvE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h89Ps18w;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789683094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fz/+qqG3YFGhplHyENgnUXZVvp0zQVnLGYilI98zm/E=;
	b=AQQPVK9WAcHzNgz0fS0oCkdcwR+H2wCBxVzKwDAKtWnjFhKe2fe8j9fNBBg39VAVmmCrEp
	Ca4wu19BtsHFlDLnk7+AMsLDUCgSwtXc7meDRPcROlo/6iYjUWFeTuMq0Shu5PVoM6QKm/
	SG4UeFy4naQ/gwfqWKYJ/TM7wDRE54E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92462600AA;
	Thu, 17 Sep 2026 22:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31D81F000FF;
	Thu, 17 Sep 2026 22:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789683092;
	bh=Fz/+qqG3YFGhplHyENgnUXZVvp0zQVnLGYilI98zm/E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=h89Ps18wwMDFibSFyyuUTnuuJVsi0PyzpfCtuJEYGc7oAeOnwVeT95qzfzBqq2TF2
	 K5riDxYOeThsiLMTEjB9fPcb1wfhbK96M1QbJPwUFIl6wn50h9sQrBjrcItA5qymy8
	 wkDriZ4WmN/37Y2ec89icgGz94IeXYtu+ayBGnmI=
Date: Thu, 17 Sep 2026 15:11:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>
Subject: Re: [PATCH v3 00/12] mm/collapse: separate a collapse from its
 callers
Message-Id: <20260917151131.ececfd158627e58257ca7110@linux-foundation.org>
In-Reply-To: <aqvcElQxmtysJwbA@thinkstation>
References: <20260916093145.4022188-1-kirill@shutemov.name>
	<20260916154826.a55591eec86b5514dab898ca@linux-foundation.org>
	<aqvcElQxmtysJwbA@thinkstation>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 60B5A1C0006
X-Stat-Signature: rr5cer51xagp7nyj3sxwrjredcij6wbh
X-HE-Tag: 1789683094-904669
X-HE-Meta: U2FsdGVkX1+byhpAoFU5Bf8+LNcKWT8jIM6UlRa9e1Xn8g+g5CXrA3thbIWVctIHsg0E8wPFtUTK9zYFqGA2OUhn22pNih2Xee6i5jG878M55PW2p68i0Dqnh4oU6eVtzPd7l2ybmEFqFgB3Eoep64IyS4efyDxmt815KB3idr5lgQ121Y2q2f6EUug9e9er0e6ItSad0MRCmy8wGN8ClHb/87k0vfLIM+rMNRx21n5oJVSJgGhzNdvQ6+0ABiDYWa1ZA3r55sXSgioECQL0T3acg+l2rf4/9XvMxsHbJMHczPlmUit3cSWeEx5nqiJq7r0fZsNDnLOBm6oWCD+CCM7ulDoMn6givGAtlHvGV/eKlF/1UE0vhGnSUlkeBBtUGh7o0a5GrB+eRIKCtNttjjgZD7ZCkGhFbjadf8SjzG6yXaKwhEIyTXnQHMtgU5uJPbQ2Q1k2OiWQ99zFRSU6pgeJH36ggGShFx32EaWum4XsLFXt704eg8yP7PJX1Fxq7DGnNqOiBq726s9ywLhIyLRNR9Q3DQWDGiK/eAZvxK7X+GQSv3mBoeBSBQzpUY87QnI1adi3bDo3xrVgz5jUvGjm3C+hbRXCEIOn1tvtsvf9AJ+v/GL/hHR7jHl/u0SK4nTFAog6a1NuSVYSL331CJqThD5jQrpCYmAYkJSYFmyONX5VsYTmBgzNsCxNKaaCu1k35rdteP50vKsOu7xq4zMuM/WLb/QuzwzTW4WnzHqf12YUJASmAC+wAmFSPdwp0lVblgHyv7cbu7GBEbhze/DF1nEoUweH4wj40G10k/EuYGqXuUb4y1ZGdHZD4pfaKUTvKuRM6kepSKcrVOmbXsRcOqvrsYRYS4eNZVnwVIMYdb5ylBIggRv1ed71kZ1AAaPDF3/Z9eNvN+aN1gX2WDnvfH9xSwYMS1mD2h20VlUIGOYS7AshtWtEFbenvltNghhdS11cZm32xqDdgAv
 I6skXgdd
 u5NC5QmU5brwzIQvlkZVZU8TwEMfXlv7ahIgpl+ghWQn7jRXP3R5l30OBvoc5VGrEYvIhka3Pn2GMD8At4puEv7m97b1oKar26A+yazMIKRrio/ajS/zrxwWEJ4oEqOCxUMNGUfK8HU2JNCkb95cmxVhKINI6mpOSdLpUf/4szy2m5Bfn4igVkE4sUkKBO9XzYyPupgrjFsQEeMKYy2UwUA4+aA/66gLwSt1XDyXsQzFhaOw8w6QQJqnni2xZmFEF2Tk6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 13:26:51 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> On Wed, Sep 16, 2026 at 03:48:26PM -0700, Andrew Morton wrote:
> > Here's how v3 altered mm.git:
> 
> BTW, is it helpful to append a range-diff to the cover letter on a new
> revision of a patchset? I can do it in the future if it is useful.

I guess so - that would let people see what changed immediately rather
than having me send it later on.  What do others think?

I don't know how useful the heres-what-changed reply is for people. 
I've seen little sign of anyone using it.

One reason I prepare it is for the author to scan it to double-check
that they meant to do all those things.  The exercise also make me pay
more attention, check that diff matches the v4->v5 changelog's claims.


