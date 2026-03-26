Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A1FB109E54A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 04:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285216B0005; Thu, 26 Mar 2026 00:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F076B0088; Thu, 26 Mar 2026 00:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6C56B0089; Thu, 26 Mar 2026 00:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED5606B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:45:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73821C35CE
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:45:16 +0000 (UTC)
X-FDA: 84586975032.23.D360436
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf08.hostedemail.com (Postfix) with ESMTP id C0D87160006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:45:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=poNZp177;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774500315; a=rsa-sha256;
	cv=none;
	b=w4/oovwB6w9Sgofb8ChYH4mKTbnAGaO1aDlXOwTfxooiP/1IYZrKBsrVc+tBFTHlE7vaza
	u0CxKkM8B4Xiwpzwb0N0ZgemvVdElaM3XckqrVTMWo1DeEwy7IJp7kWAxcY1r0JfSL9kjJ
	AIQTBpop2D+eauiMcJZOZAYdboXFlJQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774500315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHlSrarwY15qD1Fb/ADKOw96D1u7Kp7mtAtYkWq7qEc=;
	b=Ct12+ILUapII1YkFpxF8PGsjeNG+I/ZIgxCBCFkRW9PGHmeo33e02GUeZ3yEBnS2ab90SA
	kekNH2oq2gcF5SMhyt/YxVfvtFguPAtyMpXPDusuYjspeZ42EaRqkJefs31x1P5hcJ1WDt
	KIFtjE5nOl9JLXUio79pYMLHja+hXcs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=poNZp177;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774500312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHlSrarwY15qD1Fb/ADKOw96D1u7Kp7mtAtYkWq7qEc=;
	b=poNZp177sGtG3rK9HQhNJSmCNVcYteJaj/m07NwBLcNX/B/y2IQTcxlnzYNY+8+RZT79rT
	7ua4d4FvckKl4R36EFRP2htagwzEFHS1tFXfPIzUK8IF9gJWL93Ax/HlxQdFVimsp7vOQr
	geMPnfN8m9SxUW+xnU7vf4sj3Gsm0s8=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nico Pache <npache@redhat.com>,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  aarcange@redhat.com,  anshuman.khandual@arm.com,
  apopple@nvidia.com,  baohua@kernel.org,  baolin.wang@linux.alibaba.com,
  byungchul@sk.com,  catalin.marinas@arm.com,  cl@gentwo.org,
  corbet@lwn.net,  dave.hansen@linux.intel.com,  david@kernel.org,
  dev.jain@arm.com,  gourry@gourry.net,  hannes@cmpxchg.org,
  hughd@google.com,  jackmanb@google.com,  jack@suse.cz,  jannh@google.com,
  jglisse@google.com,  joshua.hahnjy@gmail.com,  kas@kernel.org,
  lance.yang@linux.dev,  Liam.Howlett@oracle.com,
  lorenzo.stoakes@oracle.com,  mathieu.desnoyers@efficios.com,
  matthew.brost@intel.com,  mhiramat@kernel.org,  mhocko@suse.com,
  peterx@redhat.com,  pfalcato@suse.de,  rakie.kim@sk.com,
  raquini@redhat.com,  rdunlap@infradead.org,  richard.weiyang@gmail.com,
  rientjes@google.com,  rostedt@goodmis.org,  rppt@kernel.org,
  ryan.roberts@arm.com,  shivankg@amd.com,  sunnanyong@huawei.com,
  surenb@google.com,  thomas.hellstrom@linux.intel.com,  tiwai@suse.de,
  usamaarif642@gmail.com,  vbabka@suse.cz,  vishal.moola@gmail.com,
  wangkefeng.wang@huawei.com,  will@kernel.org,  willy@infradead.org,
  yang@os.amperecomputing.com,  ying.huang@linux.alibaba.com,
  ziy@nvidia.com,  zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 0/5] mm: khugepaged cleanups and mTHP
 prerequisites
In-Reply-To: <20260325172500.990e240d813a4b2db300e0e9@linux-foundation.org>
	(Andrew Morton's message of "Wed, 25 Mar 2026 17:25:00 -0700")
References: <20260325114022.444081-1-npache@redhat.com>
	<20260325172500.990e240d813a4b2db300e0e9@linux-foundation.org>
Date: Wed, 25 Mar 2026 21:44:55 -0700
Message-ID: <87tsu38aig.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0D87160006
X-Stat-Signature: zi9gw845bwrpeokpx5ocdgys8f1aua14
X-HE-Tag: 1774500314-366042
X-HE-Meta: U2FsdGVkX1/jdJRjPzw4PtiTIJdEbK1HVwX2K/5YIilGuXf5ZLJT7j8x8Vnu1jYhVAx4yYmGGdV6VdP6DnTz6tU5z+sI6Ixf9NktpWjA/1tI6yv/Tr5nnYc4KN8ufha53QOOC3IFgsaNn4ofuZ96kkzKg+idRi5Jpb5jlPj+9fGVKCJjQrou0ttIn1pSshkDPGHJELxU/JGNsTzCWdxqaZFfAPXUggcwxjx9abmVXQzBBYSgDatYc2P4/J1YrU1H0lrXgRpyYXHhnDrsPEztqw7LDaQ+gFGlhp97jdonbFA4mh+m35J6pDCiHOGbk+6V0vpEzIu1y92wTTZjQ17dXSV9mTkvqRZRVAf7wafSBPzpwiZAAN3aosKPaHjwXBotImLFkg9MGmiIB8V/KrYNv1aldzwyrGhUb6N5wZhye05wlVzj4vzTs+J+6bzMttBQPwiauVZcuK5GjUUkzU7ikj6SPbX/tAtcKwPGkBZ2WZ2bZkojtgPWCTi6tInwkakwN7Euzamo+DkJxWSwtiYsAKO5jvFdj7ZSBG8bYOCSAkUzIhpwxUisonpdfcAP803kTT8kCOAkWbNuYyedPKDL+A3/hBLQpmsffSc0a6nhVSsJa494mOPxiucVIKgorY5JVXq8h1VCcWtQU06F3LTrnoUmWlTxeZD8n/ltU/rFZQMclYmHPfOT0TL14lSFUU9R1/sJbA01uWwBiEZ9REKklOE/06BQtLqxWVg/QYkzVe91NrcBjL+/ZSgICriU19TcMYyrrYE0J1Ib17WhYWj40gWbQD/4vbnELwow1B2isMUYPRRCVWuRSzRLNjNYfOUJJMwTBfVE8gII/6j1OVM0CklHwwqJqq2l75B2vb3h+mXRHbQtFs8dxhGIfSYr0BphXsdx7VfOigxCHmTkzTahmyfkW5ZTkFg1SgNAMLKNXGQjdLEFsePKyJYijiPfPD6I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 25 Mar 2026 05:40:17 -0600 Nico Pache <npache@redhat.com> wrote:
>
>> MAINTAINER NOTE: This is based on mm-unstable with the coresponding
>> patches reverted then reapplied.
>
> Unfortunately the update-in-place trick fooled AI review, which might
> have been useful.  Oh well.  In retrospect we could have avoided that
> by you asking me to drop v3 a couple of days before mailing out v4.
>
> otoh, this series *does* apply to the mm-stable branch.  Roman, I
> though Sashiko is attempting that?

It did, but for some reason it failed.
You can actually see which trees/branches it tried under the Baseline
section for each patchset. And yes, I need to improve it to log specific
sha's, not only something like mm/mm-new. Now it's kinda hard to say why
it failed.

