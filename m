Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D40606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qm+fVmTi
Received: by kanga.kvack.org (Postfix)
	id CAA076B05BD; Sat, 31 Oct 2026 16:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5AAC6B05BE; Sat, 31 Oct 2026 16:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70466B05BF; Sat, 31 Oct 2026 16:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 939A16B05BD
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:29:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18F971409F7
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:29:03 +0000 (UTC)
X-FDA: 85384060566.03.2F6620E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8093180007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:29:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qm+fVmTi;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793478541;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2JHwEtDf9D7TWTWSurLCwRlzX6xohlUFs5XtZvypmk=;
	b=VREJ3EaMS0h/jNFFXlHClo6lIsDjlPnk7F4JBlaZB+t7JjApKKvTr0upmgksq36k40NuL9
	LDL7b5CxSW8BHMsGBrPAsLZpRcMoERTINvidt9HMC476NYyMcy2FVrXSg6lLVIigEAqnPQ
	SHBivuDN0XmXqqhEK3luxs1aIrlMGVo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qm+fVmTi;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793478541;
	b=0amWbiiyJyvIrir0M5yuPUS9Iy6mE0msE/JIMpFdk8zp9npT5guTBzk8fHUtVyDI7AV+Rl
	mzgWJ+pTmkr0O2ntbvNOEv+MsnTILgXBA2GyrXr995RD4BagLikYzcdEZvCBDlbiKVKz0m
	j+YBQQYJZF+SrVH8n6GQzCdJvs3RESI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C250041F18
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760F71F000C1;
	Sat, 31 Oct 2026 20:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793478540;
	bh=F2JHwEtDf9D7TWTWSurLCwRlzX6xohlUFs5XtZvypmk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qm+fVmTiP5YQVGyMNUQskoohBCdoe4RPYkTh6VwfWeR+c1Bd+N7WtG1Blbz7fJDH1
	 8oXAQYvGKHcgqixycxbEp9m+PrZ++Ncvpz9sWTT9Ywf14aRRp9TR92i0m/l15bvVQs
	 ITjwgXCUS/OAj+MMcCIMVIurlaNuZg9ac3br4ZRhouVJLhT/VQVAhJwiiHBvQgDnxI
	 46eDDm0WJoI39YlGj3lvXtt0ujUt5Jv9G59PRiuk0vQCCQTFj5JrbNoOrQJrYNBLdp
	 V7//DvgfYY7i8/zd0HQWve4PegoKeP39VCcUEjZMTnonOJktX41eOP1lSTcNdlmOXL
	 mLIbgYTePnQqw==
Message-ID: <sashiko-outbox-192115@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6/6] selftests/damon: remove unused imports of os
 and sys modules
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Shuah Khan" <shuah@kernel.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261031202614.96036-7-sj@kernel.org>
References: <20261031202614.96036-1-sj@kernel.org>
 <20261031202614.96036-7-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 20:29:00 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8093180007
X-Stat-Signature: nop5uwgqbcmpte9dghuzb8fqtigezh5c
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793478541-614876
X-HE-Meta: U2FsdGVkX1+Hd/CtWvbSzihWIAyGYQ+ZiccvsKAQDg3A/X+KMBbQobbRRaz0nq5yW0f6z2Sb50mrng9zfZpqQaXjbGX0R9CDwTAoLrHA24d5KfQtMij/y67mUW90hhL6901KKGq4EYMenEv+XFDjcuxAf565d8d/iZXjag4SmUHkjzEfVWP8FJFsoIhIVhS6BJtI/bfSSGNAT+bDpWHW1btFBnu0yjT2wCM+dTIDwybzJ8YG/u0h2OC6hcKlP+H9THV8gBsedPjtHeWqjMC009oL2VsSdklJc2LOR0vPnravi0YIHqzMvZcQa88yWq+kAvNE5Z7kIofhDBDUoiRQq0mAsMXO65apt8DHOPuMACnFjJDTkfDxvZ5/2kpnwaIajRHo1tYs38oKCaXmqJqm2QqIxHLjHB4eyyTupBCOk2DLvyNAxboIlcM/5fdR6qGOqC8JaI4pcUueUeGdnqXcZMoYwIuwzSjXwtuX6qJWOAXwnqShf6sGbzEgW/9JG+5RXbRLbJaaA43Bsa7S2xyrUJgDc5dwq/V6xfJgk1nh9YBVE+Za48cylXRApjL/y4GT8o6UOv4B3f9wCfyfJ3Ub3zB+Gs0KQNnWmCZSngGHN9gcOvUwyX9rEzKgUFGNYEbNSUMR+Sd9ZSQTjbLR7dvmdwU3gPtXcOcaONUY98C+G0ZGhdluZNZKsLVUiwmVz3JNJCLeFKy6e3AQ7Fl6nZrPpBZG+9HAzTuKGXuoMLfB6LuTjnwcvy66KrSjQVseRSgbf6g194kWULgwpfzjldhjRcvlDoAufDD6BSljkgYXBiTT8XlcB6wxLcSQL+e3Rnzv1WpC71TyB61spni9ojgAMySOLusHynduRyp1kDmWBZmLoxqkFce1uFak/+Ux8muyHNkULktP7sbsoL78bzqwIMQ90+jZiGFa9bgYmhKhuaEUTC85FMTHhNg03svqYUIc0/Ol+wP3hKdxIlrBMg6
 deiHcRun
 ttrUOasdZ1XXFGoQNIdUDifnmELbI2EfvTK5XbQAM3Ywco9Y0UyjUMeoYhzDHir4mX5xdyRqyhRGKliEtN1wojFxsrlFXI6FyeMUtKs4BkMQjPUMU+qAPZFQgOyPesWEb1XX72+J31bkyLGTveJl8DFyGV1amCU3T0LGDJgmnqYeWtY/JNalFuMU7vXOPudXJJs0yfRLUxyHjff8hd9H753gzsYPeOoWvCm1ZbhbmSSD1dMFg6tJYZ7rkZ0vlj+w4XmBlxZfbAVWbrDWx9E7l/7BXoZPAsnrO0QcHAKipDYS/LZAxB2fapSmSEbo2zUhOZja9j7i3moT3/zopkoYIg2p3vbwKaBSEZXpeCG4XNBdpCXFD4ZCQtnrrjMx7WetHhiwRmFsQdMD7h7apm3Uo1wBDMc+9zYMnN1Z+I1dUZPvp/bkoM9p8oy5K/vvSu8EDE2nQeqst0/6fvDYkSFKdSvJNNIIYXwN1ZAvGTzKmeiFUUKVb9c8bXjfkD593ZAeKn6c3n3i9J4EjUura+64p7mleaiD+2m1pn7HLQF6kB6azocyyZVqwGAdsEBGE8P9cTyt/GaD/cJV9FT2ZJME4HNAxlTL+W2SgircYBpdxNluTPv6hrTXV9RQvZwJ2TjC5yy7TMFZvyjA5WaE20VF3qgkotQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] selftests/damon: commit message names wrong removed modules
--

commit 55304159b940aad6f9b71d318671a40d9d63ca46
Author: SJ Park <sj@kernel.org>

selftests/damon: remove unused imports of os and sys modules

This commit removes unused Python module imports from two DAMON selftest
scripts.

>     selftests/damon: remove unused imports of os and sys modules
>    =20
>     sysfs_no_op_commit_break.py imports os module but never uses it.
>     sysfs_update_schemes_tried_regions_hang imports the sys module but ne=
ver
>     uses it.  Remove the unnecessary imports.
>    =20
>     The issue is found using flake8.
>    =20
>     Signed-off-by: SJ Park <sj@kernel.org>

[Severity: Low]
Does the commit message name the wrong removed modules?

In tools/testing/selftests/damon/sysfs_no_op_commit_break.py, the patch
removes import sys rather than import os, and os is still used in
dump_damon_status_dict():

    file_dir =3D os.path.dirname(os.path.abspath(__file__))
    dump_script =3D os.path.join(file_dir, 'drgn_dump_damon_status.py')

In tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py,
the patch removes import time rather than import sys, and both sys and os
are still used at module load time:

    sys.path.append(os.path.dirname(os.path.abspath(__file__)))

Should the commit subject and message be updated to refer to the sys and
time modules instead of os and sys?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261031202614.9603=
6-1-sj@kernel.org?part=3D6

