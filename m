Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3F2C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 18:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B03F6B008A; Thu, 31 Jul 2025 14:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 661716B008C; Thu, 31 Jul 2025 14:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551466B0092; Thu, 31 Jul 2025 14:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 465F46B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:45:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E73EABBEA4
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:45:39 +0000 (UTC)
X-FDA: 83725438398.05.09A95DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3880D20016
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:45:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bTE571R3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753987538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlUkkWQuC+9J1Khr+cp2Tyh2coMuZqGbGf5EX+LPPQk=;
	b=kIZ5mCtBJb0OpUAibboKltGvtSnAMCb/yDtcFJyN/P9wqv/lt/8s+Lz9U9kZVZJgBL+QtZ
	Exut4S6hRoqSm8zdsdBlnZrCXslJWD7xlbdBgMvMrxM4a6abo0NX1Mb6AeHVfdlV1XavdH
	hN0Bb+9sxj7OJVyND+Nhl43HEBDvcN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753987538; a=rsa-sha256;
	cv=none;
	b=uROtQsiYU01IHIAjMfp0SFVwFU1tcqWVhWOo1mFFja/2PPeOdH/c5docICG9scAovfGfnw
	VcpFdeEDNkJ0q0z6xpMDpXBn/VsRo0cVz1y1g18tZu/y/Oph9Mgvj6OvXGiRMTPF9UnL2I
	UNMRBDVgV5Agu9WYDj4Dj74FroYoUzI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bTE571R3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C7AE646163;
	Thu, 31 Jul 2025 18:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82069C4CEF7;
	Thu, 31 Jul 2025 18:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753987536;
	bh=EDF5fbjVVtLHDax6DWwi8zVjLgTT3NYO+yAT3GKnzGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTE571R3uL8yVkEByfBkisQXXirJ/lh/NmmQvnlNQupf9TEy5rzWuRr9qcal1irWf
	 S6rbnKD0SyB7borVmo/qPY8kbJHP//vl9LB8TlqJuUhy4zu9E6W0unIxp22DFwMb7B
	 eR1GS1Lg5YMXRptg8zNAvNHTDR31y3p4Hstl69o4LhjmqJ2scrcIZV9qy6gxtIC7N6
	 HNIi0yWiA2jcnNjuL13K4aH4GGhyjb2v4hiNU6P3OmNq+/5AQLfjtwrJSoHppCasFY
	 IbfcSllb7OomUMmxK78WopGDkfVb0q8SQ59wHJpbiS+UyVv42NsSj4gO4lXLsT4Nuy
	 87Y5QC54gdWJg==
From: SeongJae Park <sj@kernel.org>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: SeongJae Park <sj@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] mempolicy: Clarify what RECLAIM_ZONE means
Date: Thu, 31 Jul 2025 11:45:33 -0700
Message-Id: <20250731184533.16419-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <87tt2t9lkp.fsf@DESKTOP-5N7EMDA>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3880D20016
X-Stat-Signature: ft6qmoh8f5y3pyyd6rb8jbrfmgekyi5d
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753987537-173291
X-HE-Meta: U2FsdGVkX1+bTfhnEFsfjUlEoKgPz+4PbwUqZsclok4/x4RtL8iUhVpQYf+5Xsk3QlVjFfwhp9BiohunuzkRfGdwbA9BdM6l5+Vs6RQcuM8Ae832Om9KRFEpbGPGySOs/yD3k+aUvQAprTn0NJPQqm4CFelIR8Gw2e9z7uq6fxhn0lqWDjkSKnW4ospmROyqtHUbjtPHa2CbSIZt2Y3qMw0eEq1tRC9Qo5Kldom+gi6AvtdGmqQtBOgSvLxJGbWvkr+4ge2ApuOyxywEtpe4bQyFhI0dyg1GknZnVk1hmN/1WvyR1S+JGKaasrmyxew7Tf9G2ZBg+P7DloKghaglr8bitA3xhlaLKfIEM0ouONrptyipSRIcs0c1B/HCP4cSacFxYCkbi4NWGObjlPdfwSkEn3Mjbfi5GgXUME+PqPUvMXQ+mqV3igzB9kwLLHpeG++P0HnLhcmoek0708eaLtmUdijinPC9kI5usQnCBOvvJyXhCwG/mEItNo0lzvRb7tpvwgodS9YIcihubH0x8jGvZpGhZmbwyPlOrrTezZdlXTFKiuz+ZKHCXbKdnerypbnqXnGaDi45640y/My9yuC7v8BypWiLbf+OhJMGm9eXY+JQKzrcofF8sItnDQJUUg9AvD7/yRYS1UqhRu1RR8c3do/rvjlRzCos1JZZ3DGf9fZM3zdCFX56Ar/fUEqNj4+XAbuCdJJBDvh0t4oLvZo0NxQVuQMQLrQUGQkqoCtX6ieqjpG1kSVb88Qr9vL9wn6JpLgwZsF4AzEMzfc1a/XsHNJ6k1yqaRgu+mqRjyW4VyW0M0uch78Q3XyqAZogLX9Vowd3Q/OxTzPL6+4/yuc+leVwqqsCpWsulXNlLRCK2Ue7wskpQrwOUM5UMi9M7U5IeLesMIKRi0aVEOzbS4PPeD5HH3W+cL6JSxwqnddDyNOP2LqHIAaFMJ4obBf/BdNgdMsuc7qOt5RkrBQ
 +Mfcij8z
 YuO9a4Ad/inaFbWM0L/aslDeNBFN9j9lknD/RUHk2upPue8mCaaC7xFy/scw5igP0EoQ85ccQtLbcG+uK92XVcHThFu9z1N1lWqolxHWz2x7IA4FH8wyMRnHUgN4PoJqTuiNy7B+lvzbt55LzyoYKaXaFXDbeLEv2ozBnv0oTp6+T4WryMQmBUGuUkxOZ9cojXlO/0rkH3AAr9jU4gUjmUoyrNv6m0srh0sitgVu9oIf9aJrxOENwiF1aflVe3bA3f6USQZYqIWf4g8ZavERCCL39kAI8Ah0xJu1kixDmq09zIkLYHzP2LW8IqcT8+sjijwHYkRB/d0MKPhRgQXkpyFsLTbbZx8nP56e/618xZAlTt99jn7Wg3ot6bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 31 Jul 2025 09:48:54 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:

> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
[...]
> > On that note, one thing that I felt was slightly undercaptured in
> > Documentation/admin-guide is what "zone reclaim" actually means. What it does
> > is of course well captured by its name, but it misses the nuance of preferring
> > reclaim over fallback allocation.
> >
> > Actually the whole motivation behind all of this conversation is because I saw
> > zone reclaim preventing allocation into a second node in a 2-NUMA node system
> > and was a bit confused until I understood what the implication of having
> > zone reclaim was.
> 
> Yes.  It's good to improve the document.  If it makes you confusing, it
> may make others confusing too.

+1


Thanks,
SJ

[...]

