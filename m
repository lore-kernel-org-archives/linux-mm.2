Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92256606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 00:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iB3y2nsF
Received: by kanga.kvack.org (Postfix)
	id AFD6B6B092D; Tue, 27 Oct 2026 20:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD56F6B092F; Tue, 27 Oct 2026 20:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB116B0931; Tue, 27 Oct 2026 20:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 749A96B092D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:55:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5E5340B4F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:55:02 +0000 (UTC)
X-FDA: 85370215644.06.54C779A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5BE97180003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:55:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iB3y2nsF;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793148901;
	b=klPV7zIzTJYaqivjuqbkgSsTElufhEgy7Vuyq4GbSmGKZs59vtMexx085dagL8bkCFng57
	mwYfDcYzIus2bFLBeGO3ejDi/cLc24mybUj6YkVT2JmS+9jWCGL8FVIP3eyesZAAL+TLDl
	UvcrwsWtgalc6//67w0UDtIVoBZp/LA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iB3y2nsF;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793148901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZgROYSFX3uxrNR5jpP0XfaMHw/DaoPH2lgDKlwezuY=;
	b=bNA/C8i119JPBOy+ry1Rqu84qCo+Dcvvo+jzmOP9EdxJeiYMTPYba3X4Yt6tmrL4quA1uY
	rveK8mxQskeW6Ij/jaeiAm9R0Ze3adWpaxRbLMdYtbag4Hq2rJgzahWOpEaoxcQj5rWhfo
	5dnHKLZ3UZu/pseW3Oa8yICslerLkCw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA11F60136;
	Wed, 28 Oct 2026 00:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0496D1F01825;
	Wed, 28 Oct 2026 00:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793148900;
	bh=4ZgROYSFX3uxrNR5jpP0XfaMHw/DaoPH2lgDKlwezuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iB3y2nsFBMKfAAVx/mDQIl6NqTb6vNM3Wtbs7LJ6JXVXIHixsjFy24NuALtMNEA78
	 RswEHWxDTSjCj6WcaaKlbRDyoBJV5eMAHIbYfUvKldVz5+B3vNtd1gsXGTb/Lvt7cR
	 +bq95bOiWJZ38nQSoH8qqkA0NDUCoaHuFP/SsL+gqEkmmI9/OggVa5UeCXomRA24G9
	 XH8P2uO/zy7NZsKblD+4lExNvMGoO1R6C4HouLVtnCH17Gl87e3W9OpHGlw4mJ1Hsf
	 p757BDd/K5HWCppehd5KakAhD01doOIQea7Wh6d2MANIXStfCVRH/vxKGtfltY1Wmp
	 rQGEza6WYsRag==
From: SJ Park <sj@kernel.org>
To: CharSyam <charsyam@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	bijantabatab@micron.com,
	ravis.opensrc@micron.com,
	bijan311@gmail.com
Subject: Re: [PATCH] mm/damon/vaddr: preserve migration weights above UINT_MAX
Date: Tue, 27 Oct 2026 17:54:52 -0700
Message-ID: <20261028005452.157810-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAMrLSE6ySuzsJJX-KXoeG49pS4ZVbNWZve1dwj1v1avAhHeEdQ@mail.gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BE97180003
X-Stat-Signature: dz35o71xn7acnocem3xpbtnqwgf1sree
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793148901-606388
X-HE-Meta: U2FsdGVkX1+Ia9GUcusZqD5i075Q3jvgy2B2LLQeTYnhIbNLblMjRQ/DWXwQIhOgP4YuIl9b2qo621Pfpicwmz7AUlDN49oXrtu6ukXp8TM1NcwRoIOD6+a07MBEICMDP2+ac0grDdv42M90tjsbBcwjOMN5jbhnhDFwRNf3MSDXR7ZCRV4r2I0udwm79FO+uHBprv7uWHedWwmBWKP+UNKi8ap/cvLMWojMR0JpCK9ZlD2ZIYnjgsnly3YmuFALr2gkJ/GvGCDt7K2+RSFwaYBLBoB+WgEMlR74vkr69omtOiKCx5SRfao8K2rw81tpUBqz+fbAkPGwwpmuV1MFmvxvv/oZ+vP7Jd7MXKzZZwHJQwdBt6IMqBF8QfhPe9DrsyV3geMTiIUWMCXwh6mYdkGR7U9yYqJ73Cq7jio9yc6K6sRR6QTn3taYn75Ctqd5PgwNHDi8yGcLQhZi1i9fiMEOvN+X+mB6hlLRUQTAzRHGY/RXq3CSabRpFSaqN1zduyEnydCwxKsFMaBfoI7iBJSA/PvnfS+OIu3he+TjxgBt/8+/fAvcjM8AX6SBz2xcIzTX3I2WuOJkJvuhga+z5pl/viMy5cLLvwrE1oW30PXW6TsLlFX5cL0Ny3O1Y1c+1g1FHTfPnHQW3XYA6T4oopjbIn/+O3UpKWlnnM9MH+Jx2zLiuXLGv7kJbVPfdoUL4RZHOY7yWJYHW6maGYK7pwiqir4WYojIjvIcW/AbXtKlYgwF8/hJJqtf1cO8mca/YVzW5zDbpmBMpDg6wic/OSFC6CCO5agk3OH0/745HbWxb5G2Z19CBzajGF0ty54vd2tc069+uZjiiL7f6GZRj3m2QRpCdhIszxOG9ADheeKWNvB6U+SMG1mDNr80Y890DjhxyKYrvwrcXhha0i3NWu6xvDZKCX2I9+g5BcBzwrLSXP03OFXvuDlIozcPZkbVVvqxb/hvEvbZ/uCMC6H
 fhwgprnf
 4bDSGGwf9v/sGvJuwObiOSbYMPR/dopBZYQYWjqs7sCktN0j3WbrYb95ehunVYTo5ywE5jPp8yatI/+NMBUDvlDKrm1US7Wip2RbwVnpfeWKfGkxiF2JjJWnHFlWnD5xXLgHAjiI0+obBBFj9TZNmWxShYMgCFhQqAIae4TFfnHp/hmawWPfHEWMNtGnD+2htRQuGmwqZccSqpMKlYPIpT7TsnpdbfRSAfafIGqoOVvXlp9j9IUJ+2KqSkjv+wCx7T+AE5B2b926du9AezfNCUXEaSjmlx5KeU0gbom8tAg5WpLEEei+X+LDS9C0s/pG/RKU+Zf9p1bpn1b4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Apparently Bijan's micron email is no more working.  I added Bijan's gmail to
Cc list.

On Wed, 28 Oct 2026 08:57:06 +0900 CharSyam <charsyam@gmail.com> wrote:

> Hi, SJ.
> 
> Thanks for your reply.

You're welcome!

> 
> 1. I found this by code inspection, not from a real-world bug report.
> I consider it a correctness issue for valid inputs.

Thank you for clarifying.

> 2. I would prefer a u64 total over rejecting those inputs, since the
> interface does not document a limit on the sum of weights.

But I doubt the value of documenting it.  I wonder if real users will find the
behavior at all.  I think it would be not too late to consider documenting it
after we get an issue report from a real world user.

Even just keeping the current behavior looks not really bad to me, as long as
it is easy to test and only shoot the foot of users who didn't run test for
their weird inputs.  We can revisit after a real issue report is delivered.

What do you think?

> 3. Given the lack of a reported real-world impact, I do not think Cc:
> stable is needed.

Makes sense, I agree.

Please avoid top-posting [1] from the next time.

[1] https://subspace.kernel.org/etiquette.html#do-not-top-post-when-replying


Thanks,
SJ

[...]

