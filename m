Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF44C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 17:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6EB06B0092; Tue,  1 Sep 2026 13:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C463E6B0095; Tue,  1 Sep 2026 13:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5BFB6B0099; Tue,  1 Sep 2026 13:18:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 908CF6B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:18:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16909A04D3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:18:04 +0000 (UTC)
X-FDA: 85165851288.15.A00B348
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4EA01A0009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:18:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GYUxjOp2;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788283082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNy8aFxk/AJak35WjwkPfrrpfkELAGWHw5uPOVPVzP4=;
	b=DKeXqrwNhv/axTMwascPDZ+CDqZp4BrBpbVS3763e22deVvkbM9PU2k/xqrkjJETszKslX
	FAAEzZzKDIBmItneCpBruAMhzxotV6Ivrb8+TffOuDrprdNXIPQOqURI02SqBxcMi2WRbq
	rz3a5S0FAlMqqpRCEbwHGmrnRaKsRIA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GYUxjOp2;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788283082;
	b=mZ5W5OgPfRsKxXP1b+hSD01XJW5BP6OVW87zZfgG/GnWIWo6AxUmBVO/EyFZtlQKZ4BjKc
	x6kYuJwgO4D5wj993FrOMijqGdyV1/zwC2MC0Q3HKiYVGA7RE6DpmWl4o5VGPX0W6WQkQu
	pHdaks4y7o5MDcnwvVHTiWTYw76r2Y8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDC7D6022D;
	Tue,  1 Sep 2026 17:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46501F00A3A;
	Tue,  1 Sep 2026 17:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788283081;
	bh=qNy8aFxk/AJak35WjwkPfrrpfkELAGWHw5uPOVPVzP4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GYUxjOp2aphZq8mIT9V1j15Kpl/xo9Ln9v4wuPqsr237ZjQthjG2S/Cm+pgHRrToy
	 q7RvgwrTUkHmSI1XTvEJeWnKu9G+ltZt3D2FGhMia65IdemdDZlwxecKDiyFtHcdhG
	 34ITMNX9JAw7kJ5jWiQOynxvMukRw6KtAP1TQms4=
Date: Tue, 1 Sep 2026 10:18:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes
 <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Shuah Khan
 <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v1.1 00/17] mm/damon: introduce data access-as-a-data
 attribute
Message-Id: <20260901101800.0d76452eb310a4b958d792fd@linux-foundation.org>
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4EA01A0009
X-Stat-Signature: j5iczasus59nm75bdx4u717dxw1g4pnz
X-Rspam-User: 
X-HE-Tag: 1788283082-710092
X-HE-Meta: U2FsdGVkX1+To5aNJAL+gslkdJIKmg2/JGV356rnSF+I1zjZ02HXjTZJU1UvRE4p3uBMfA1sYL8AWUlHPmPstqae8Z4E1SetdbImq1yqB1AsaITRmUIikV4ju64rujidNjdxuOStmo5HbkYpUEpEIFJr9seBKHaO3W+NBzJjb2gcFpz4ihjnFNxqtRgRdFNEvqdanu1ogD1mUlW6d8zahnMBRx334C7Vin1e08uB3AHNbf8HXJ/yoVJ4jBfvO9OA2k08H/m8WqU81c2lni2FqP6KFwKT2H2yITEZz/BYx2cJc29+0g6rkML1BLjd48K6JGaYflA5PSsGa5fUvhTmBkQft3emBD+MlU2FhMug0eolST07318iTwaSHr734mEzPAYytR1+pfCziDcbsRPb4mqDQ03mWA8FwTRFazwiYxxIqIqO+S9W55/I9MAKS4AaAfcYLC+KqWgFjEJy10CB8FrogogrJGKfaAxIj568t5kDiA9G9Sz0B5PoYnNqAYUv5Y/1saYcDf88BRqapYEN+FgZnDLzZuxTK2ugtKpxSvpNcNzF4tGsF52TEkC7WQgyIwxUsCkBcw0Qvww61foX5R4/STAFEqCQz5TzluVY4GiFUqSITkHJ++XRdnslT/lRN6hMkIViQxV8LylIyNFGnrbqyOzVUi+mV23d/Df4vBR7FJiSatEgSR5AqJX2HJl1+xDLBDYQRE9DUpfiUp20b5LscUoPX3cVttNaGSmvW23S/6dz3Da+pVZgj7wPOdd9rAOlX6fJ26llkv9vjbpZrIw4JGgs4FSJS49LIaibepm5G+7DtJOY/Bi9OOKMX8Zb/SCbx/Tc8/+NHxs+BOtLXHWyOsv0Wu3Zrba6GfVpqbHSIzjeNhuT/ZeHbu6aaQaYAzNTApzT0kg1DaDyVUCq+zXKs0IkLNPEmOajHUhfIwGf9/2RFesE+9BIaVAr94ZjdbAB6qqXPPUixpmpauQ
 IK2dLA+i
 8FcaUuutocXNuv0daizELOkeggclOhAgLS01miZqiLsE1DBeKV+PoTb9ZDPkiL3ljbjuTxIV/JG6aqhSk30mx997f9ou+9RzSg+YNSyyg5y0P1ys3kpVjmlfIoDCST97BX+uo6ntqzYtnXdAAvO4NuEbGMq7wvJ7bK5q2MibHApBszBX8YVeNHnYizeHSoNLdmA+S2wrpFs4Qc6aA7c3klMe+Q4Tyd0C3vGGekN3i/PwpM34ITAItlYHT69C1G8P6Vcm2eDlYV4qxDJHicvVi6yqlaQ2brGmHUmUFsPQN+wXCLFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 06:24:47 -0700 SJ Park <sj@kernel.org> wrote:

> TL;DR: extend DAMON's data attributes monitoring system to support page
> table accessed bit and PG_idle based access monitoring.
> 

Thanks, added.

What does "v1.1" mean?

