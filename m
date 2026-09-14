Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75DD9C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3C96B0098; Mon, 14 Sep 2026 10:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB736B00AC; Mon, 14 Sep 2026 10:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710016B00AD; Mon, 14 Sep 2026 10:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51F2E6B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:50:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0EB6A016D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:50:38 +0000 (UTC)
X-FDA: 85212654156.21.F7A8189
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 349CE1C0003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:50:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xrh5nycr;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397437;
	b=xKoJasN0gt2KW1evf9FrB41goemu5NMvQghKgUmuj8l27/fh3Wex8PN2oka6S5j55ah6+E
	Eeo3b2NpuOz/1j2REuoCMnTfuYZpUvxQtcH3qZwIb3vkquOyBUEq02hDtB8kL6TCn/g16z
	CrdsFviPMBoIqGcqZZk8IWXcVc2MbZE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xrh5nycr;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DdSX/wEBxUG3+6tT6fIjeyRChWGrmi9MuX4lYifuSLI=;
	b=6iOKmxOA0MRId6Jm7Te2PitppdEojy94LTIOvQO8EYHAOx5MC7ZodosoHNxIICYWCLK940
	E5c5R5Lb64xLbLGOdzF/z08XFZYzUha/0+U58mGNvztD0B0U3zaiiedUAnaC46lL6bInJi
	KHscJJUb0gsVFaHxq6/OrXPLfiTLjjA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63A2B41702;
	Mon, 14 Sep 2026 14:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1861F00893;
	Mon, 14 Sep 2026 14:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397436;
	bh=DdSX/wEBxUG3+6tT6fIjeyRChWGrmi9MuX4lYifuSLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xrh5nycrsmxLdc0/rrB872qvYgTBBsiopVxuoL0Eg76RwQd4wfl7SIELOttWi7vbf
	 67u945e7BRvfzE1fM69NYRvHQ6om7BFeIp5Axac812YZKEsAioBldiq8FFK6VeO0jr
	 BWNIimoefN9o7bUuSaYhqlAbZc3jaMMFWlVDrsuBXMOp7bKpdducaLnmKclQ3Ap35H
	 lPDa3GSujp4JT3vIIiFJ9yuMBzF/cu2rObi4GDzzbloWSDcJk0W4KOLExovapM+7+I
	 p3NMtyfiLm2goxQuOR042ubCTl0Nn1hsBA/gB4QoXl1xeNoPG2O3jst4eO/QO20/Qy
	 DBt6n7R3GJiNA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/6] mm/damon: misc improvements in tests and documents
Date: Mon, 14 Sep 2026 07:50:27 -0700
Message-ID: <20260914145028.94705-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914141952.91465-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 349CE1C0003
X-Rspam-User: 
X-Stat-Signature: btwsr4s9eja7q46kriki39ok8ydrhgr4
X-HE-Tag: 1789397437-974477
X-HE-Meta: U2FsdGVkX1/uznRapp3lPiWZ4Y/b5lPnEbs0yRtgHamC2INpkySv02JB5tYtnjBdeV1wG/5Z2fVmAy7WOpuiBu3LP/EKakovwnj91tbXUKUno/+G3/8NsBirBVSMyYmK2tL6TeJ7UjVxvs8BUwshBUOxOdwoflTcBBswaWQ5mDhJDnv/jRo4fSYQRRkEGW3TSrU+H0na/XjfqL9H00bAVixuulL3sYwvWmV5VtCQETyBwIj1k8X/oAK2SJgSPt/E5T7eY0rICgbQl2cSRzimYW6Mhr346YDdMKG9iBXX54zdbmFbxZqxzqtihBmrHfrbn5wFCGUS3bZP6Ql30aKZOQmCQIuUZDV1uwnjH7FdgJ7Kwj3rmHik0fPAIb/OzvZy8JD0hw/YDDhA1/V2sh6pbTBa8+NlcsRTed2VMY+aEnrEYdo8ZLxFhi+8+o7Q82rz3WiVlksqBwmW/QY9TZZXbw/v51raQw/9g2PGtHhQy+k2CivCGmuws+T9CETskx5uStR4JuMfKcy8+l02wuErkglaTTQjymYqh0vkbjsV2Xa5KMfm7FMlvOK5hT3kyXu6UEYe8qjRpXjM9KPcW/Ic3EL4gjtj4p0TKMm2YBQ+Q7ehtE9Ren7o26GgPH/hSTiNaAgbLyNBFQ2pT9u6jAln8RVkoCs6qU4v2DgXfJVXW6UYg/7B8FTungMKccKWenyJmC/A0tlrC1EuXMakaAe52XUmYI2yqEUvsqZAAcw3Rh/x0uANnRmhDLzfNyy1Qhk6Kn90i2/66RrazQBOOoqG96K5Gs+Kb096G/ul/Dxy4JEEUQZLE5JZ8+9N7CZHKd/Z/UTCVhrvw+oqzrf84/AI+lLhKwxjrIpHu4ifki/AiyI7b+IhPL9/pcSn26ygeLQRys0BNz2pplDs1Mr14zabOAd0fEgfiHc7HcY62ldyAtSP11TUGI6pcSp5TzGBODDi2enkx7Y3flCF6IhRBbX
 QjgiF9n+
 zdVA8q4lpPxo11ZbPIkMkoXaregpJ29XbmVNUPjZ9V8szA3JiI7Dp2fcxdc/1Pxr+0SzZESluSCtrm2fX3rxKuWuPhANzjwun6YRY3m/0t3jHlF9kiCDRd6rA4M/qbXu7EJoUiJRGJGlfokbwaIIpTsGZJsexA0TWVLODF7EaqI47Fnu73vqmnxn8QxjFflllmCtf+k5iXOOfKp50tCehI214GXw8iXtzCP88mK/wTCxqROU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 07:19:45 -0700 SJ Park <sj@kernel.org> wrote:

> Add various improvements to DAMON tests and documents.

Sashiko found no blocker for this series.  Sashiko send its findings to damon@
mailing list [1], and I reply those if anything needs to be clarified.  Please
refer to those for details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

