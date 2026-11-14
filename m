Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B6A660A3824
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gEhnhCZE
Received: by kanga.kvack.org (Postfix)
	id F10846B05B1; Fri, 13 Nov 2026 21:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8956B05B2; Fri, 13 Nov 2026 21:01:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26806B05B3; Fri, 13 Nov 2026 21:01:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B764F6B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:01:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D148160158
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:01:04 +0000 (UTC)
X-FDA: 85432071648.08.E952461
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 887944000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:01:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gEhnhCZE;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794621662;
	b=2vdBoF4EmKthvhjwLqHVuZhMg8WnlCa5YgDkCX2N1Pp7sQBAtqk3z9pnay5Qz9cHy9sRVH
	IP09txnKFGdBPbNrBLup9T3M+0z20fJi8B/0Zssc0PrAQGGTpOGgQUI0QpBiDJgIn4tvhy
	s7tcUszKVeEDMbBSswx4t4ZCwuuV1ME=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gEhnhCZE;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794621662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tMxB3nJHm4VLSpjaUX4N0sdRzUI9Yhm8pI2/MBZa7yk=;
	b=utF98ofc0SVtmDZQj2ph8pGH23aiIYPZYYSbby0RNSFm9D4/+h3lmfev1cbe1Ih0SZDqNA
	1CiNmnwF3uC4AVQKmYcvK6Kw0tDvWpoDnIeUeI3dgq4XdtfmM2O0C9cVEP5C+5if4g1WNY
	a+ttrJGcSdipb7S5inlXMK29NX1CWPc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 40D7561ED7;
	Sat, 14 Nov 2026 02:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F181F000CA;
	Sat, 14 Nov 2026 02:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794621661;
	bh=tMxB3nJHm4VLSpjaUX4N0sdRzUI9Yhm8pI2/MBZa7yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEhnhCZEUhjHhknFxhwKV2eoFSVSyYSiMZKGShHkzTiulwCmnS1kEb6Nu/09kzht/
	 OhmVffjz+iYVo90Gp1a09mvNY9Q8ajZn0nJSfRqVWG+aNZ7oRg4x6rbF1gyS/zYw04
	 gIXS32eSkn36BEq0bWCBJ96iL2HH4FXr+VSX8NJHqjcC/+t518aGAohh4Nk52PGQNE
	 aamfuNIDW5Niqpp8hs30FoDhK9t6HOUYKXj1yZNy33hwNpOZC8iC8Krf59NLof6kNO
	 lvlYyYjvZyOc0eDAem1rz82NXW+0p0rZ18mzDQNvfuRKXCucrzUYitAiTGrsKcIL1+
	 ktiggl+92bKyA==
From: SJ Park <sj@kernel.org>
To: Jason Angelov <jasonangelov@ucla.edu>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_test_commit_filter()
Date: Fri, 13 Nov 2026 18:00:52 -0800
Message-ID: <20261114020053.109570-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113-test-age-ms-filter-v1-1-b99eab2f71bb@ucla.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oafx8makwrk9m7p641kc71t1muq3zmbr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 887944000A
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794621662-973214
X-HE-Meta: U2FsdGVkX19HSsiL4KBQNHQNSICGthBiCdptbk01fc3SRDfXY/rjJzMdtSzS1VJYVAcGnNKXCT5XFYoe1VjOfU8T+tELN4PpSXIC/lceV+rd+CTZzTM5A/q9bmMSWlDE9GqwP2cEJz2YjVXA0b46yte4GB686c5GLpQnLXsFQyJP8CuSIjAmI6rFEfkd3RRS5rJVjnoXwLLlmDCuJm96Fgnzxlb5sM26kaUWg+jwz+SXa0QeaZyIWML34mpud7Lf/t5YeqUThRdg1AJ2KibQP6njAfOhHX/thOfgahDsmYui6SzAPR6fVQCl34g/R7XnJH008pe7g6YvV60/j/oAc414kr5eQ/V60rQ/18PgXkSQKJ5CpTGPZRYlydYkB3beVRoNCNrUyEw2d14NKuvLzfURrkGZvDIIwRf93pTkR2snpPY9LSVvUMfm5vPEzhF3HnHdw87bcD/DxEpvT7F5OKTwIPblKeDekGfUZFLhrNTzMsM37d9Up5iwgk4+nutianjOPZb1VvhT6tDkxXQ2JK0cpwZwbHc9wZoFWcfX/ovnMaIKQI8I/aihg5TyKGEx01D3RmtlHDzaQNbHlElEsCAwp0r7EZITRI6XvVv9oZ3Y/5XJQ5/rE/orzWJuV26tgAnIJl4m+MPK6vbsLqOcl/hdt2oldlm2c2KDvdTd731a8MBgFd+P63gugu+10Vjpn2WPZ4OnDo+9hMMtfGmLEK82ya1+1zXFOAE8b6qGpfzF1gO5w00SdtTJyDHDdMSyyXq/bQXy58G/PJ5b8lMXI1a9QyXH70HA20DfCZAX9SwczXFkmaazP1P+9kGuPuxY94YYpIAqm756Y9Al4NjBd4cNfaZ8KMGIMAnNxurBQPXZ6aWiSlZX3zxOHjlrsRv2AHpwhGRiL1fcPS/bqfRdxX2owlFfBBkhVQUX6E1uT2IHAme432Zz0sQvHLecNCO+49HzyWQgRxMvFmv76lr
 HqLeMEjM
 wBbaLHlpdgTSnBMn34NebCMp6sOAx1OAOgj7sOsWZMrQ5+X8ua9Dr2YSG763N1enFXWIotAgxo3+ZKP3zrWr6OriwzK2fkLD8K2BufdduhjSliILn37b8zVdOXefQeFRcUWCpZVxD+RMpaSPA2Ge/9w+H7BFTgp/g8Up2kjDcoWw26TTgxcJrbapsb1tQRcOaFNOT6x1z8gUDlmXO6JPXzdFvINz6pZ2/3rh4KRyAjxU6emDVwLQuFQWQVLDxZq4L1FnVqHRRNTuYLuyhewDgjy5IKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 07:58:55 -0800 Jason Angelov <jasonangelov@ucla.edu> wrote:

> add kunit tests that commit DAMOS core filter type
> DAMOS_FILTER_TYPE_AGE_MS.

s/add/Add/ ?

> 
> Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>

Other than the above,

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

