Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D255BC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B854D6B008A; Wed, 26 Aug 2026 04:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36206B008C; Wed, 26 Aug 2026 04:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4ECD6B0095; Wed, 26 Aug 2026 04:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76F516B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:23:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08284C0280
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:23:22 +0000 (UTC)
X-FDA: 85142731044.13.BBB3018
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 74169160009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:23:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Uu/P4OIR";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787732600;
	b=sdJLkMlFpEjC8AU3CxPkUStref1ERb/7S3dLB+DAQLkXL6qXjkoV9WON6bR8cCDWrTZqzX
	/IR8m6aCoZnu9Nsamu+yZFVK8t3EwOLdZy0QnrZVgVvWQv0ifGrJiCakiRHl5najN+FX0Y
	1/yDkSY4qcegB91WbkG3k1tXtqGyPIY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Uu/P4OIR";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787732600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSlNADoOyqAJEpBJLjZgDAKsxtt0+35c6vqLhuQFXYM=;
	b=pf4nDn2xPzX61H8scQi18DIyAejgJ+XZm3L4t5b9JQGJVY5XVt6j+BGfxjBXyB9dfQ7deL
	/HADwrXtsZyO+1UsuLhFEAk0PwzBHT3ULuh8ssnhJaPmPiRQryOki9QJhNhQwWItoN2dQP
	SGDIQ6ZIrPz6sjuKhBlqWJ9aXHaUL6Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EEDE860A6C;
	Wed, 26 Aug 2026 08:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3588B1F000E9;
	Wed, 26 Aug 2026 08:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787732599;
	bh=qSlNADoOyqAJEpBJLjZgDAKsxtt0+35c6vqLhuQFXYM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uu/P4OIRNL63avNQFUualVWA3ANWRe6rGU1tEW52kAsy3mssgrwHsPqNcVO7tqX7M
	 3vZivTBTrTm3faFZsdpzzqigGWyk2/fTQTp7xncuOGzf4Wi4iNnjjjmI6Nfys7fZyS
	 V8/R/kN744EiRsi9cKutwFaex1J83GbfqkWmq5T8nH1bUMNHmkgzIUHuTf4V5h/fxI
	 RthXtMgGZFZB/qUNW83YLYt5bo6LUx3Z38Hb2uduyhoBX8a9Zj5aiGpCeDYI2XIS30
	 YnWP4UAJarDSQExdRiMpvzcfcM3eesPzQVCJtY+BmrtSK2iV0ny5GYuoUYMi3TrgTK
	 u6KFbPVflf9dg==
Date: Wed, 26 Aug 2026 09:23:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, zokeefe@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 3/3] mm: khugepaged: fix folio is used after
 folio_put/unlock()
Message-ID: <ao6hClAw33UnGmET@gremlin>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-4-vernon2gm@gmail.com>
 <ao6e9RxwQ-KC1Ikq@gremlin>
 <77412338-b54c-455b-84da-1f39db641c90@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77412338-b54c-455b-84da-1f39db641c90@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 74169160009
X-Stat-Signature: 85e3qurx8zfadc9r1ts8syzkxxf6cda6
X-HE-Tag: 1787732600-848691
X-HE-Meta: U2FsdGVkX1/31PPp6yj/etSjUL1t7WtmJTSji0sg68sN8RPfNs0x3DVK6Fj1wEGnha3sJx5tpxXbLqq31TeviqDtl3ydCCmVPO192KCMRj0/hBgdE7RXWweFLvMkHnGm0qlBO5wYrXK7fVCHJnRpNJeD+VtOvd243LZu1Ghw/n10m6gvgKAwadBlWRSM0d956SFN8tOQ8y3cUL3HrDFqmRO6iLqM3HG3rvxRjOAbA7NFso4ZatZTv12B1e9LO0nyjY5LQh7dmisN02GfupV0YZlUUBwjyVQrFbjkfBiJKlQe4i57SQcmdFAOpy6rgc4YDrEVCEsvThF3d/vTR2N47nPUgshI0dBh5dAtxxM41VG1ibCDDyMnJBP8urrWCHLAbhApQUuubnXYwsRHIEAJyzhDQ8buuwxGWl2dFlXlDFaKx0qcIHzl0QFjELpfRcVoViK8PoCF/9UUZvjpC4I/z9kECQv/f7jEDxG+uUaZKgplCQTDJs0xgb4DEENM2oMPA6SKG7gUnTMoyN3qSI3pNv/+88/Nq4v+WO63RYAhBgMAwqkY+Nq9V6yF7nzSU/9DFvBsnE9xLE2WG6289YX73Cxpt8cl701d/qkOSyshuoF0sHuBFIU9Ce2KwQjk2tD+5JMiVWApvRqOQBmPD7GyzSrrt0i7Yxup47mYHNqhnrO9RZdMzded/JgMhdzpDEbFIwVqbDCzyOTVxWYuwfP9piA7WM7hPKDvDCjqQzbI5OLhtGkXZRUjNbKvHURb6X7xHCTydfSSe284OT4bYCqJttGo88tXPVVt4QMP4QJtspanmgRLJfU/ztvJbxZQ4IyNsCoG0yUyHSoZvrhUFnF1cbpfcD4pqudxtqSwFDRtpZ1jRBxAmqZ9J8w8RlAHUPoC3KI9KsYuK80ZhFPpIKXHuoUT0pXSq7pTpLdq4DpZYWi2jX8ziquuZTEK5QJZ++dNU0griYbHn2iEp2uP0tE
 JbG0t5d6
 qdZgbAlYoxdCzfmVZlv8jajqh+GrwrMZ0f0SQ1/Y+zKfzjbHwqrknNrcltwzGsSSuL/5ZYICHQhe3/Uj0xyjF1AwdwiA8+/K/QxwRsrxHr/glPE/4gWgeFaboF/XT/p/TB8Zlz9NE0NpvGHLBetOcvmSsQ+q0XqK4kT0W5f1K+4vL9HJlA6VsIFICSy6+C+NQSpG6RhICKyEHclgbiBTJBtyL62n+vhdcDbICuziROF9GnnB2AUbS3FlCJH1IqCpekknH0SLExwu+T2Ywuv8WctrBoiQlExJAvaGZVWMkZ8Ky6/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 10:14:43AM +0200, David Hildenbrand (Arm) wrote:
> Note that the monstrosity we called pfn_t no longer exits. :)

Oops! :) Fair enough. I mistook it for one of the various benign typedef
unsigned long xxx_t decls and forgot (repressed?) the horror show elements of
struct { ... } with flags and what not.

Vernon - please disregard the pfn_t feedback, obviously :)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

