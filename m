Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44761CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 14:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA596B0005; Wed, 10 Jun 2026 10:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47AD46B0093; Wed, 10 Jun 2026 10:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390A06B0095; Wed, 10 Jun 2026 10:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4F36B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:02:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C6D3B1A0124
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:02:28 +0000 (UTC)
X-FDA: 84864167976.14.C7E2DA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 13FE11A0014
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:02:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bRtHvAXo;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781100147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuSmwGv7M+HksYo1sSLXZGpleDXHiSTOXzJAy0Yn9NU=;
	b=AXPS95cHunRyZro4wcaE3zWlGEZy+cNf6GFa57WIYUVJ9Gk4bysOP8dI1K5sWfBskF1ptY
	dJC8VTOKySsz40Fa7OMj4r5NfTK3VkcHymL8EC0CWOTXOMO0eSgK3MfgmhV2HzbRtrNS9q
	vFFtmNatgGQj2VVs/lPLMrTwSs6UZtQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781100147;
	b=IzThOkkOUJR/2l5n84gDsV44eRqrZtiI6+QbU6aQayDwHPAkaAhhAktGuCN8AN9NEM7zht
	gn9woMNuTOY2PKy7fjtvOo+FZ0xs6xvX838b84WHNyv7iD849A/qmi2iGesSml+cj0qwF4
	NF3r+Q4KPlbN1zLt9v4dL2MVstm29aE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bRtHvAXo;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B0AF40BAF;
	Wed, 10 Jun 2026 14:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3131B1F00893;
	Wed, 10 Jun 2026 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781100146;
	bh=kuSmwGv7M+HksYo1sSLXZGpleDXHiSTOXzJAy0Yn9NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRtHvAXofUN/bHMnFNyeLYvbtY2fqUAlw6qCSwASZSLvtXYAFhhF8Vn1DNQ0Cahgo
	 uF6jFNlMHncw5BRQhEl9VaM/VNceaIEo8/iKKY5eZw77YSfajtexO5ODjyR5p6J5zQ
	 OF0fFTE0dSYIaz/V9QXi2iUk4YYAu1Bzo1p8DAX7DXZhP6nymmK6QuD177j0fJeXh/
	 vuGRJYo/oT90IY4oUz5DNYWeI7NCxHRka/qMppIP7L+13+ZQ0E0/iZonlC+spi2Zfc
	 UB4kUi8bFlVE5KeTM+RPjCn390JzZs+B794BTMpNTcQSYSLjnnMcgEdQ90p+iJg7tQ
	 G0KnDIFLM1HvQ==
From: SeongJae Park <sj@kernel.org>
To: Doehyun Baek <doehyunbaek@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] Docs/{admin-guide,mm}/damon: fix DAMON documentation details
Date: Wed, 10 Jun 2026 07:02:17 -0700
Message-ID: <20260610140217.65110-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610053951.553739-1-doehyunbaek@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 13FE11A0014
X-Rspam-User: 
X-Stat-Signature: 7jpw3hkc5f5djmoo4uxmb4pu3n5z68p1
X-Rspamd-Server: rspam08
X-HE-Tag: 1781100146-276391
X-HE-Meta: U2FsdGVkX18zAGoX8eMzRwn4IoSCh1uvWj5oLNBvMf32VlLltsZVQY1NneXS1KHL90UhiXLJ89zemqo7xUDzFMfh/dg0jbARjVTF+qW0WbdAI/CFuyB/98x38gu5b+Ew3K9tahwQyIFWuGBNTfCRhkPmm3xlipE0Upmzf4xXJbOL6X0cNYb9/S7NEvzB9aF2s3SmsYBbryyOvCBDHZ0U5WphbUSYZDzuULTkHR1MWuPQyqzpi7jrm3bma3437FMsJXhXedawkwhcH4fbRzBjhYqzEhv8Q8qHK6ardzmiCUP/sgPxcW3BAOGA37TWxCcdBRN3PoRKMQcVms2l3FNyd8V4eKBBi5XmYwOBr0tw4eszsQNOiiKiNxvFghEUOx+iysqBybS4287mrb5N65IHmDf2qSMbc+QSwfVQw77AKFRjL1KGmJTvN4n9hIYsz4CsFlxj73sNNFhlMciY5J1vsPGj2kjOv1lkSpayqdrBw3dp02EwhVYdNeQvka8wX00qKX0p680X/CjBYdG+/fW/Pxj21Cr/WkvK9y5rZePURA8MoUc3GsrML/GnBqXHVfeaRtw0cJBOScViYnRsRfQGjRSuAikAEtau+VtVHY3fj2CMbq8GKHE5gQ/e1zRuZ+CGkJEgIRxZVZEPWabc2JDcu3NSc7ZqVj28kCiBSiNLuTuqEjBgPhnZsCFQeX5Xg6bbYAlVHq8GDR3lxmT6q8wINfEqAGseZMMaPu6793Z2But+E9nSwxmH2BlBHXewZy0Heh0H/jmIcI0BPX29pqPi+SwLuAJvmKuX/q74Pcqbw+ua3LmEugX+lxL6/dgKOwceV+ihsmilLEwc9qC33zHqytx//2dXPYE02BycQdOI4Ja49SyMMsZTNMUXYNgVNez6BmqZimaBjo6e8wEHRTJs33NvprsN69eSADBZNVRm2rwM1+iGnW+q5h4V6yRi5UL+oonavo0IoGZkxqiyTF3
 P88ai2RT
 ndWUVvgHUYtONYvBRFoeAC3Hir8akM5g1d5D0rA2L4do59ja3yfRfEsNKtmBOrYlC1cmWz743mN9kxz953056piYRcWn94EFT6LIzuYRSE7NWwOU5xP0A1Mi6BY8KJWwv8usmMVS1z/+6g0WMsaLlNr8GdWd4cxoXMJJzevsvs3WA5DuOHVQjYK8Sg+jcN7eZK+WV5ugSnp/A0vBuPWOyFvO+YiEqN+RCsK2XKPk4NdlOmWglUOhYdDql/caVbHxjJ7I5aNCXsrK4lEBk5+dpGEEpBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Jun 2026 05:39:50 +0000 Doehyun Baek <doehyunbaek@gmail.com> wrote:

> Fix minor DAMON documentation issues.  Correct the sysfs scheme file name
> apply_interval_us, the DAMON_STAT module count, a malformed reference, a
> misplaced label indentation, and a few typos.

Nice catches, thank you for fixing those!

> 
> Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

I applied  this patch to damon/next [1] tree.  We are now quite close to next
merge window.  We (mm community) want to focus on making mm.git more stabilized
and therefore ready for the next merge window, rather than adding more changes
that are not really urgent.  I understand this patch is not really urgent.
Hence, Andrew might not add this patch to mm.git until next -rc1 release.  In
the case, I will request that after next -rc1 release.  So, no action from your
side is needed for now.  Let me know if you think this is really urgent or I'm
missing something, though.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

