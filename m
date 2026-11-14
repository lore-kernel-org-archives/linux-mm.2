Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B87DE606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 10:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=f3lix.dev@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=YypRp1xo
Received: by kanga.kvack.org (Postfix)
	id BBBD36B00EF; Sat, 14 Nov 2026 05:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6CA76B05B0; Sat, 14 Nov 2026 05:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A341F6B05B1; Sat, 14 Nov 2026 05:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2916B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:10:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E655D120377
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:10:09 +0000 (UTC)
X-FDA: 85433304138.06.CCFA330
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD98EA0007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:10:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=YypRp1xo;
	spf=pass (imf25.hostedemail.com: domain of f3lix.dev@gmx.de designates 212.227.17.20 as permitted sender) smtp.mailfrom=f3lix.dev@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794651008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BFBaVnuXXjZ851rUgHHwu+q1SxO/ZY1qzZBaupExlXQ=;
	b=4yoXunloapF7XUEkCNqULm6BR1MQ6o9EXgnjkR+ZY1QhGa50zJ2fRvOG/++scOSu1zu/kH
	P3olgUYf7lPDN3refRwStt9jsL5h8iBuo0BjXZjoXB4Nt8Q9qpXjcMor1aRjHOtVElLt7X
	McruLIcSe8Bqa+QrwYBeIVRNSqLl7Co=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmx.de header.s=s31663417 header.b=YypRp1xo;
	spf=pass (imf25.hostedemail.com: domain of f3lix.dev@gmx.de designates 212.227.17.20 as permitted sender) smtp.mailfrom=f3lix.dev@gmx.de;
	dmarc=pass (policy=quarantine) header.from=gmx.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794651008;
	b=Pdn66qaQ6eXDwh3l3zSQ5gsd62r+bx2NpSsTfNDccfjzvlUWzPKudTyYGPnr/YFIE2bUYK
	JP+jlJZIcARXeDsBS9wARvhlD5ZZtHtyVSnOpA887hFpznY7lIP8gl9X3Js0b4PG4jhyn2
	1fLlGcQvaBW8wUl4+oEO96vyo6B/09M=
DKIM2-Signature:  i=1; m=1; t=1794651004;
 mf=PGYzbGl4LmRldkBnbXguZGU+;
 rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
 d=gmx.de;
 s=s31663417:rsa-sha256:bJq0k4yd9g4K1ztVF2P4db7ycXH5
   1zxDTbkIk67TAwMGDJ+pePe/JA8SiIyDnUK3zUy05hQEUhukNkDRkWcaZU+uiaLJp/F9sICukuh
   FBImBCWcna2GZD71Oy3eySLPcXcDsrMCmfMDXPV/1NijZW0+W/iFz1CHYd3jGR0H4Xr05tmaxU0
   +w+0U8ca3yK3lUVef6L9OLzkrEgT0mvAsBoQuLukz3n689uY8FYOIoFduMJH5adAgISCtUpxXls
   R9JAqHzKVRKLp3E/r07oPabKTtOMziPQLk4syXBPcfzGJU6s2NV+06GIHNafIp1p/+IqL06NPnH
   WEd3+TDWqvDJmg==;
Message-Instance:  m=1;
 h=sha256:
   alSbCpZ91EYHNQXcny9APJalaZrWF8ldj3J7ofgoWHk=:
   BFBaVnuXXjZ851rUgHHwu+q1SxO/ZY1qzZBaupExlXQ=,
  sha512:
   d09dKlAkvRdpsn52HsYzofq12yvWPncVL0ADgRSQ1400HUVgnukTfwFVnuJM6HdgEVW6X2BjKKjyClvkXycdSA==:
   jwtpE5vit8F0Jwz9sXdY9O8VxNpqfgSYNL1Z4KEf+JLFPFME5p9jCja5c+/iU2TSnyLpffj48xdaaz9HLpFKgQ==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1794651004; x=1795255804; i=f3lix.dev@gmx.de;
	bh=BFBaVnuXXjZ851rUgHHwu+q1SxO/ZY1qzZBaupExlXQ=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=YypRp1xoEwiOxT/dfPQdV0Dbp8rQaETojk++hkfmQNuSHLSbXP/WYUWIfmKyPgUS
	 n1yxjk7DE0VjCXyilB6R/a2itLpAdoy2PQ4+K3cLl4bCV3xlc8UpTnMWdT90UWjr6
	 7pZTAXdnEETyW72j2qBdu3bgqzqHtXniknDSw+O5pcQLiXdZ9IbV4eqyYV9GtdZ22
	 HfluKnwn/R9waX/3GUH3zje/DHsU/PsF4SlcRfLuZsfZ+1aS1WpI+1X1Y26TrwQiz
	 ibeVsnNn5a2uDg+NrT4WOodGlaIXo7KKZI6MhwmIedR+PnOByFX09T3Sxr8ZoXKzD
	 0fiz3wxUIMNPXX0EkA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MZCfJ-1wxfFS3niT-00Kx9c; Sat, 14
 Nov 2026 11:10:04 +0100
From: Felix Hoffmann <f3lix.dev@gmx.de>
To: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>,
	Matteo Rizzo <matteorizzo@google.com>,
	Tamas Koczka <poprdi@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: Flush virtual-slab work before cache destruction
Date: Sat, 14 Nov 2026 11:09:54 +0100
Message-ID: <20261114100954.8262-1-f3lix.dev@gmx.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179462737686.1463521.17920259642574913474@kernel.org>
References: <20261113221330.162567-1-f3lix.dev@gmx.de> <179462737686.1463521.17920259642574913474@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:/7XGH/JyQuF1z5DlFnc1FHyZ9hJzJWiJ5xBd1e14Z0+/63cXasQ
 wekWSuQ9jG7/jifJ3I9rsGL3iIDbY/cEer65sTWgh2ZQJaGrIj77cBNo0D3UD2EvPg2uKkA
 XsORYQ9fdrtjsoeKa8ilQpayd5bCEEfpAmssiZQHz9x89M4vBiaHdyMsA4pv6HDt9rgEbES
 Y0kQGOZFmmcLUZWAD/zDQ==
UI-OutboundReport: notjunk:1;M01:P0:k/aWCZLHD2Y=;zX4xJVdq5xvoUkVohchbVQPtZl/
 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
X-Stat-Signature: wbgj8udd498yh8unpwsbz5q73g9onu4n
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: CD98EA0007
X-HE-Tag: 1794651007-219752
X-HE-Meta: U2FsdGVkX18z+CdAQ/8a4fLTFzfGr/54M/QavhvBoITuwqbkYCXliyMhYoWq10NSR7IAbsQTJ50LPJG3F/6mdlGfcjo6EOQZioeK1LyPYaUcrZ2YQ3YMQP2/Tz6Pi3rOc1fES7lAXHTfiZGleoZAcM60hnqgXPjUGlVdvcMZXdyeklIQ5Zjn/LLfd84BYshfaHomd+OOGEM4n/4OTAl1JPpJ+ADJU6H+lH2w33F8+egUlDn0ct+8q4385DLw7JZGr8EYEiPFgbGGa77MbPyrkWTtvALBs8d1W2gPnT+gJP1DQlnaiega+Q4MFIXd3fgKX4gFvAhayRJs5mwRYsLbmnkWm2z6VOaSZb/w97s/mRhyAIak18UYV550kzKkun99p7DVdEwRG6ze2X/o5qrGZ9MPxnO/vg+reHNCYR2k69eKwFHdS+O+mkYfSwTm3R6rIh690xJJIQAo9ZTofYs1KdNr8HV9oHGlEWL9ykYUk/48tGFzQ4ylMYVQQMpzBN2JeZpUAb9nsJngh/OwOAdhhwMm/sQeGJq5FdGZ/UhOyBtg2Hrl4qnMilQhfzmBL027YzZtXE5kfJVq43zVhy7+B3+XHlh5J0USHlyihxX4/mHm6I8K7BkQwEd2nHJbNmYjvtIw5nEvuD8AhcZHgpbUoRd+LeEtSWHrGWaqP/0pQ8WTl2KzAzpQajYs3sv+4TMBYmWn+UKRZUSm82i1WmC7Zm5ZMPKvgugQ69vefUjtOkD9Nj42vg3gEXQyXJXAZyLu9cBS6zgUX1fus2ziMAMvpoRIyeYECndheruGc+KzJiSSHLQGFQol5uXDOxgnRTjVwiHVV2ZdBOhKo8Hh7bEU2K4/X7R38JXq2CYl16vXf8eO78zw7nZijKeW4Vcw48WpkZf7N9pwfD62G9uLwI4WcvoZWTLo/YKlt2H+dZrEY2WGf/yQ1aTqjtF3DDonJWmxbuGsZ5wNcQpnT1lBFPY
 i7XHuwsY
 sKWsU2EiQY3b9NfQxZUC25j7MTOWJ5AW89IhytGTR6QGIefZVisYIYtuyAqG4Ph7maCUQZI8RhzjlObZcI9+XTBInE8AahTDg7F5EvoaSb7A/rZt/EC2zypZaaKO6mBJliEjVs4ZlWQ9HUXoGl471VsFFdlb9PwX4DAofrO83P3L6RuPoMKoW01ZoQsUhEa+ml4gOoReW9PPySY/fW91LV5pgiMZDh5AVFSngdAKxJRNvITzk4X+CVM4hBrTr4J5/spdJlLKwgyFFi9f2tmNDxVedo5sXoso0apmGQ6fPdjpdN2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Harry,

Thank you for catching this. You're right: CONFIG_SLAB_VIRTUAL is not in
mainline.

This patch is against the public, out-of-tree SLAB_VIRTUAL feature branch:

https://github.com/thejh/linux/tree/slub-virtual-v7.2

I tested it on commit 699594e8888d (slub-virtual-v7.2-rc5), and confirmed
that the same issue is present in slub-virtual-v7.2. I intended the fix
for the feature authors to fold into a future revision of their series.

I failed to state that dependency in the subject and body, so the
standalone email misleadingly looked like a patch against upstream. That
was my mistake, sorry for the confusion.

Jann, Matteo, and Tamas, please let me know if you would prefer the fix
in a differently labeled or rebased form.

Thanks,
Felix

