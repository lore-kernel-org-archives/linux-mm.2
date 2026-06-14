Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D10FCD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 12:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95206B00AE; Sun, 14 Jun 2026 08:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C9B6B00B0; Sun, 14 Jun 2026 08:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82A76B00B1; Sun, 14 Jun 2026 08:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B109F6B00AE
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:02:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EF901206CB
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:02:48 +0000 (UTC)
X-FDA: 84878381616.16.66CACC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7E77C180017
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:02:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AdmY0WT7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781438566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pKzj8DHHkqe+2FveBrKL4u5guUBnntJaiFQS8OA5Fw=;
	b=aHsVuaJxczmjNuKis5NTwxzFWY0hSqvBWNpOClRGTAWtQ5SV23E04VXdvNyM+5i8P4cKqM
	mLGuNNgFwwubMgiknHr4CiZ9vlQO25kLnbXZsqrlpgXFAPJ8OqQqVQFHJcAa4JBjk45b8P
	djvyfAiZMWddsWGiOK1GPmTn32f1yG4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AdmY0WT7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781438566;
	b=JmIKmBmtvmYFxKH4gZZlUyKhZS6W5kc0usLBtrM/IyqoCZiNxEjFAEM2nRzLKiS2DHa9tE
	fugnN9ECQ6IhIkh59/6tet5XXkWzqCDDDycS80oPu8OETA1P4phGnlDaPtApFvv/x05q29
	mdRC9PVMLy3DCeQ3Vdj3mqmDsdFgYXc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9A5440320;
	Sun, 14 Jun 2026 12:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DCB1F000E9;
	Sun, 14 Jun 2026 12:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781438565;
	bh=7pKzj8DHHkqe+2FveBrKL4u5guUBnntJaiFQS8OA5Fw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=AdmY0WT7ISPomjl4hbDwMQ/sgW1wbNaubsdDZSqFwINSBYqO5vmrrof25aTgy5Yuh
	 zB0pNGNFO9xtQpuySRJ04Ubohr92sIoFYAEKeit4gEVIZJV1OqDZ3uDDwL6qYergn0
	 S6XOYwgUfSNUDZiWeFIjtUcQeykqW+PhzKzpGtGccr/lO2nEEHe1tw45qxoRSzlZoF
	 0fL4R8GHTf7/xYdcTyv16bQUPhXbSh3hguQ4dvGDwTPNNqwCuWFU5cxYDf3F2eIDKJ
	 kj26kbEVRq7fCXPIQbB8wYOWMxsVM1ZGURv03c8ML156F3KIXfZC1EGY+oPb32HziE
	 XRei40a0tu5qA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 12/18] kho: export kho_scratch_overlap()
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
 Jork Loeser <jloeser@linux.microsoft.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260605183501.3884950-13-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
 <20260605183501.3884950-13-pratyush@kernel.org>
Date: Sun, 14 Jun 2026 15:02:31 +0300
Message-Id: <178143855113.2123877.811509669260246457.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 7E77C180017
X-Rspam-User: 
X-Stat-Signature: rw13md6xmer6cauth6mbwq6e1qq6mmnb
X-Rspamd-Server: rspam09
X-HE-Tag: 1781438566-513349
X-HE-Meta: U2FsdGVkX1/l3c8wbp8Lo1V7PqtVZr5/Cy7OsKxpMpVhUamj6PX8ScTt74O1v7yWcYVYpqZwLPODDP6vYHbqrUxaJ4+FoCozGB2rZbVfg8+e++XXlCt/YsWGRURH6dkI53FENAGDZnF1MZUzE9easop4NBsv/iaIBv3T50bBsa5wrjTlB9wbYG0KcRS4lU4CQpz+M7MZnfwxagTl8AwIJNjjmBx92ZZM/a1U8rcIe3J+c5VVC7GnAusRPZBiNTVW2S+4S9ub52ZvVNRVRXe148/DB/JzP3gOdojlTMN3HIVbzQzNTsRyLE0R6V0mQ2fb51JG3qk0NKUsb0qDm+k7p1OXPSbkV2b3npvp0y8Q0Mz57H3b4c0oq6bXJLtjO8W3ycwHfHZKMxbXJFLtYvxj9IOojImeM3J6J+ee6Wh7BYN31zoNgBS4jFs33GUmf+mYoblsQi+erebqIOv8RqNiOJDb1BvWMPkjdW41O3qM+wOF9jNCarlS/PuBFZHoPhwVS/CP2UB/X78u2ESsYt0qh96qhJjfMcfKR2a08h3nhkiZal7SBmvAR5MIzhShpzOiC1CZOaRwsMYgb5NzTE0gg5QctEqSIwZtVrtYMc05dCIf2ojOvwOaV3K+gCNS8GSf3rkZQGwkL9r+NtJcqXmUxPXfCLYGIf45YBlzcHTyVL+494ujyz83oBWsP2hTwnweLpcM2JZk+BGwSxD9mso2/lc6eFGScNUzFFWYcFQK37G0b/wAkJuJiXRmnGy/71SpBj53TdMT0idird456Uu2V9YaqQNTni3lKi0o0zcinyUI6ztp2eabJtu85tRg3V8SZkQrA/BaUWbKY4dmveV0Luk0JGWkH6aDRA4TU8p2Y1QkJEtUxruJ+5RBVE7tprwf/mBUV93VhmtEq2xHjq0J40HL00xPvwJfOpeRXXlkxv1KXTuA37SAA421kRf+Qp6qSxRRHRjZO1yUGsDw/j8
 rmNN7kaQ
 2xmVQuCiWTwtjbMPyY12yA+nKrUbX8eu4vo7bPeQOJsDhDXQzHbKINJPXHDejs+Z5iZzt1Eb5OJZhEJWZJ5U2vw5pTs95EqJFvjwPQa5D+Bi2JVf95nr2+MX0nVhCaMojMNme+NSxUpcF5mB/EtctEuVSFeCtFGZb5PIzGLuDCf12xEaXQsii7/msItFILzm5N/UaLEC6AAjdkvgm0THaDVuaYOzBMYgJm/pJAMQ9sEivEiN1I6dCjssbTCjZU0yo+IsnPff1kwZUiaX6aI+XBGh2ZF6p1GLDpSIB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 05 Jun 2026 20:34:45 +0200, Pratyush Yadav <pratyush@kernel.org> wrote:

Subject: kho: export kho_scratch_overlap()

rather make it available for !kho users and regardless of KHO_DEBUG.

Nit: we are not really exporting this in the sense of EXPORT_SYMBOL, we

Nit: we are not really exporting this in the sense of EXPORT_SYMBOL, we

-- 
Sincerely yours,
Mike.


