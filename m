Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76A9E10854BE
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 09:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A496B014B; Wed, 18 Mar 2026 05:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BB046B014D; Wed, 18 Mar 2026 05:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9FB6B014E; Wed, 18 Mar 2026 05:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0CA6B014B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:23:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A1A521D501
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:23:04 +0000 (UTC)
X-FDA: 84558644688.04.F443FF5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id A93DFC0009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:23:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eVpn0LA/";
	spf=pass (imf10.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773825782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QrSQffYYLv7Hm1BPK9VpU7To1qXa5RDVgaRDEWFTWU=;
	b=rnWF3TOwcb/H6FCu7eX9R4KQznhHxA/hVivCfZ5jmZA2WsPMxIuvEjy/sgmeU1be2E0P8b
	NcraEt6YYpcpQfFxLXs9Qk+u5SZVLdo+G7YX0xvpIJ6MkStLoYw8WKTsDcdQk6mHKC864z
	pb1maEym7vLIMYS+s4me2YKQ2138/5Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eVpn0LA/";
	spf=pass (imf10.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773825782; a=rsa-sha256;
	cv=none;
	b=W+GhWjiBD/CzMvRuNvdt9L5ukE0QR5s/nyKjhJPeom/t9RUUfXq3MBBRWpTpDyX6t7A+So
	I4TGvVOVcSLtQ4gsVij2gX1dCIO3U/lhZfs+fSBnWdHGOidxKtcxcJrYBtZtvkJkGuOdBu
	qTDJ0LsNmiTh4G3zIxmf2aVMqR2luAM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773825782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9QrSQffYYLv7Hm1BPK9VpU7To1qXa5RDVgaRDEWFTWU=;
	b=eVpn0LA/911KxCoXgrd0iCeK7H51abtomCS62KJFRMewQAh+h9prELHg4Q6WFAus+6De1q
	UAS8OsfeUztiHSP3/8uNBK6J3TrIMS5ezl8P8TiNPrmqpdU8W6HVsN2M3XJVR3vQH+t8Ue
	QilHhdQqH1txGGXWLt8ba9ctWMLMdWA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-295-N_kKHe1IMEq-qYSSXpWm6Q-1; Wed,
 18 Mar 2026 05:22:58 -0400
X-MC-Unique: N_kKHe1IMEq-qYSSXpWm6Q-1
X-Mimecast-MFC-AGG-ID: N_kKHe1IMEq-qYSSXpWm6Q_1773825776
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D03A180044D;
	Wed, 18 Mar 2026 09:22:55 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.184])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5F401955F19;
	Wed, 18 Mar 2026 09:22:45 +0000 (UTC)
Date: Wed, 18 Mar 2026 17:22:40 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v3 0/5] selftests/mm: skip several tests when thp is not
 available
Message-ID: <abpu4OMsy3Xl5QA0@gmail.com>
References: <20260317094419.1429259-1-chuhu@redhat.com>
 <20260317113730.45d5cef4ba84be4df631677f@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260317113730.45d5cef4ba84be4df631677f@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: Q-sGsbQQTT614ptTYjbU-TlwpFZm2lcULa3yZN2Pwxc_1773825776
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: A93DFC0009
X-Rspamd-Server: rspam07
X-Stat-Signature: 43qsaaxncoq6dqamrc3xxrbbim9kkj3m
X-Rspam-User: 
X-HE-Tag: 1773825782-150748
X-HE-Meta: U2FsdGVkX18gL3+cf0sow6hNpO7SWwGKXL65pbtxE0gDji3HZ7hRYujiBoygM/MK8IjSMOOzXcz6LUsXZ64MfDOiZzy7b/O0zDjdWSvKwxsVQ1XbpkhjtKdBDtwu3FoVCC9Ea4ysO8cNtccB6FNekg3cpV0W26m6q/Pocq0TCZ50Ka1RVdtJb/UoZAWUoRUjFbW6tbE8/vwOyORW6uITUcRj1HTigi42ft9Cnjz6MD0k88FIAyNWM2VA2aeruyvtfaOYysthAKrZ+umq86NUWSM1o6otU6OGjDc6+kMr0wIrvfB3gIz3e8Jg6WCUG4F9FYYOxpx3VzPYVZdvseRtItgcTLtudeopwuoX89Q1nMZrn4uN6SsmL59GFy/Y8/NXEhAQCGV3k4G2iIO3HgLLXqHmfo7EMN1GXyhilETuJjh9ko5yy2mw7UUD9yjMY6ZHKBNNM0blTinpEPuTYGSfufXwOzhGyqSirlYd1te8MA4nZ5pm8co+wH2RdfzNgeN4QhIsm6h3atzTXSe9J2w/k/lfsFVlVVLFZ9eQfDI0CYRq4+Guk69rDjBbhYQOo0HTS/LsRx8qUGXcGrKFs0DpNIMd0AdVbjAb8CZCIC36MrxyjUqPK1M7L2QJXBOoJzSxshulsX8UB1G8yK5x64sgEOgF/0Erb4HfHFHYtRZcmM+/GGwYDARNfn2mma+BNu7LTmKRCMU97if5RFyCCPu/IccBzBAl2iw0xr1xp+ohjqfChY6991gswAdpQrHhYRP3tkcZSWdoLugABG0f5/C0nG0wHh85PyGhZdNZL3ezYsgbFnRXoPbDGa+3Jw01I3SodJ3jz3Lf4eizvLCGwnqJxzNd+UN3HX04VRtPux5prw69l3zMlNTW4PpMySUFk7eP0rXzs4IYR8pArZE2cR5nCILHvUrD/R5P9synOgiNEt5gdBF5YQfo2eeGPyrfVCkdwAqP3PbFZCunEj7PEtS
 ohVDUBKV
 X5r/Iop4Y0UlntHEgVUw7D2qQOg57zbGjpQ0ye4OhKJKH/ipoMMWJPsJrn8fSyMuSEOI0HeSITh9HboDN6Z0WGaJhFt5Ffx0RY7VHBb3KdMy93K0rhOlHBEEnEqMCOdNhT8UlJhJZ4YCkUadBYj3yfmNTCCw9LVbuOkvs5TFffm3EHBbJWAeZWk1GgyX0sZAKkZZCaIfVDykCOharjqmBrQklDJ7JgrqEaaVzZZDlFd4mwMe0eOr+fJwsidaO9x2+4HwJOnwgeL2jwd9SrEwCE8JQviqHzvP0fJZjVKThq+XBLjVT5+uohVbkYSuDct9rdlW6QBC9faxnMkT1vkAgzWDEgz0ptXUc8dw6en1fNEkos0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 11:37:30AM -0700, Andrew Morton wrote:
> On Tue, 17 Mar 2026 17:44:14 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> 
> > There are several tests requires transprarent hugepages, when run on thp
> > disabled kernel such as realtime kernel, there will be false negative.
> > Mark those tests as skip when thp is not available.
> 
> AI review asked some questions:
> https://sashiko.dev/#/patchset/20260317094419.1429259-1-chuhu%40redhat.com

Hi Andrew,

Nice tool.
 
For question one. In guard-region test, collapse tests are for checking
collapse is denied when operating on guard region, not for checking
madvise(MADV_COLLAPSE) will fail when thp is setup to 'never with sysfs,
result is same, but it's a different test. Maybe we don't have strong
interest to test when thp is set to 'never' in this collapse test.
Do you perfer we let it run when thp is setup with 'never'?

For question two. In soft dirty test. Yes, test_mprotect skip logic has
similar issue when open failed. 'Bail out' would be shown. Maybe we
do this in other series or you prefer me to fix it in this series?

For question three. Add buffer length check in write_file() helper and
check if written bytes equal expected bytes. It's easy to add a buffer
lenghth check and make it robust. It's not easy to do the partial
written check as that will make the helper more complex and need one
more parameter as expected written bytes. Maybe for such question, we
should do with other series, not in this one?

Thanks!


