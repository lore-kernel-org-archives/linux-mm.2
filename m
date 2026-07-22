Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D741AC4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 02:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C09956B00B8; Tue, 21 Jul 2026 22:38:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBAE56B00B9; Tue, 21 Jul 2026 22:38:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAA406B00BA; Tue, 21 Jul 2026 22:38:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85CF56B00B8
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 22:38:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13C2B40358
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:38:10 +0000 (UTC)
X-FDA: 85014853140.06.FC5806D
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7CC18A0010
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:38:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jG0JqRcv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784687888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ml2B/ksyU1FNvd+iabrZqVktSSMC0qeu3ATx01Yf8Tw=;
	b=sIKXw2HUvQ6Qxr2Z4JFSSJKvUc98T5HjPfuS0iJRBoOAPfPrZ6peflhzmfiwIug1jenjE4
	wjVqVSC86xPt5/Nl9B+9hBAxpEusToN8TqGPMQnN/3371g9c4Wvj+Hjrni5BPVBwH//BvX
	o1aRhAQ3zmXo+ubxuFdGYHNTQr4URLI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jG0JqRcv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784687888;
	b=U6Ca6sQOicrvSLAagQM0PimBB0ODwnuXchCuG985cPaWVqL/go/oCi1NfuGEjPaL7PWj+m
	2z0wCYyMRQZpOgGm2OokAFOukpjiDuvSWuV/HKiXKmygWJvjXsZMc8plLIOyZLgtPfbeWp
	ljC/GO/VKRBtiUT9CglyY0pwqQ1jlqo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784687882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ml2B/ksyU1FNvd+iabrZqVktSSMC0qeu3ATx01Yf8Tw=;
	b=jG0JqRcv9aUBRHoUTpnC+RthNmdjxiNQnok24toetuarjDeMOy5DT256Z9xD+c9NaSLoZE
	QYTWHNBQTvl9j8a/4Gvq9b6Jg2h78lsw8jzK7P5p+gi/5aCfh7M/Ij1lX0c+OcdAnxzj5i
	3fV7mMoreBPOkNcuEKiyBmOtpzSb9Dw=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] tools/mm/page_owner_sort: fix --sort, add module filter, improve usage
Date: Wed, 22 Jul 2026 10:37:23 +0800
Message-Id: <20260722023726.600200-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7CC18A0010
X-Rspam-User: 
X-Stat-Signature: k9zg7zagy8b8qk7nsmua88ps6sbwh6up
X-HE-Tag: 1784687887-314812
X-HE-Meta: U2FsdGVkX18jZwpWNLAUl5MgdoKcKgRTwjuAAF2b7ILUREY2xOKKkGCVcsufvyW5icJu2a7gJAfWifSFE5sVaAjvgurXJqNvWykeSVgo2GTUXP0yUJRP1ct0ztTJKc5dy0Ri7L+Cz5WOGwpGkiHkMyxPEWyu12nqfheTX8RBPEeEI5cRrqCQZDcPgYvriew3DbQfuflerF57EInkDYnue3k2cCK8MqhiSrjdNONZvUMoo8LiWU0jb0dQL3DcGNPjeRa2T1BiIkMuBPvTUvgxTuFP219c2eTM327sLsTBquO6YevIM8C/qc2yysL3DljqnMYOp++OH9bxw6wW9VL7ETPh52/n9LsKJH2ikpqF18pfnLN2zfgl4rXdxJyz8JEN0cQXebwg4KwCJ+W/mvHS5lyALoWtRCtnDPWQTxeDgCoLQqtu2Nafy3U4b1vV/Yyap2uQ+60ymnv75YZ0WKZR0iuCbCbRHZ3eC2wRoVFsxOtiRhcim5DBAGXg2gBHTz7fNFnCs5PXEhnjyq8ZSV8jLKEu9Mmrc4XdRfqM9pblGQ3igWhVf6RwYRfX/GP32EsusDWk34exH7WynWQn/OiD2LtMGX6qNudyNxURAF2AnfqHzG2aX8V/dwO10+bDxbOowcqB3ZC58jmbEgfzj4L9DeZU8ox0ZbF2WK3ulTmgqZ/E+XmpnHT86xgEBCNyhfhHjtehY3MIM2qU7oGA5Kayc5/bkKU0mQbDEkPVFrl8wSeRBdaVIche0hWOXCWOrcA+3IkkmsOCKxllTTna7H1Jf7KzihujunTEnc/uNWb4ZUY0n39YoT8CJHqKIUgeON+KgSMQORws42iIdE3h+GL1gvtfMEsXjDTlIC0to5Xn3GfceOyVBNpc9o9lsupLtDQNRmKAsAd5EdVgPW+wadrB0/pi+8gXnRXnkBOWm32N47Cpcl5/KsubCbAZb5i6qy2xGus0M3hqDCQsf8fpsfA
 +04EgmcF
 Us1MPbw3J9H2Slc2Nm/RuPo8SkymNLwdPK/7cyfaOWWBieGupbyQi8ix0bt5mpVnXibwDjYTwXzQfku4sX9fCWOLBC0spi/bozTTn/kq8N90fHVwGEpFw4oc0k5LPOY23pkj3BKRGQ8U8QG0FEbRTowZ/OqP6qdm0Nl8ap9ghPyF2NMGj0WDfRPTQoxZwsFgk1OwnmfJZ7Egd3aWF2P/1Q/argYGOfXamo9Tmm/d7XlzvLC39jr/Kgw/h4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

This series improves the page_owner_sort tool with a bug fix, a new
module-name feature, and better usage text.

Patch 1 fixes a long-standing bug where --sort was silently ignored
when used without a short option (-a, -m, -p, etc.).  The COMP_NO_FLAG
case fell through to COMP_NUM and overwrote the sort conditions
configured by parse_sort_args().

Patch 2 adds kernel module name support for sort, cull, and filter
operations.  Page owner stack traces already contain module names in
the [module] format produced by %pS, but page_owner_sort had no way
to use them.  Records without module frames are assigned "vmlinux".

  # Aggregate page usage per module
  ./page_owner_sort input.txt output.txt --cull=mod

  # Filter to records from xfs module only
  ./page_owner_sort input.txt output.txt --module xfs

  # Sort by module name, then by pid descending
  ./page_owner_sort input.txt output.txt --sort=mod,-pid

Patch 3 lists all available sort keys with abbreviations and examples
directly in the --sort help section so users no longer need to read
the source to discover valid keys.

Ye Liu (3):
  tools/mm/page_owner_sort: fix --sort option being silently ignored
  tools/mm/page_owner_sort: add module name sort/cull/filter support
  tools/mm/page_owner_sort: show available sort keys in usage text

 Documentation/mm/page_owner.rst |   8 +-
 tools/mm/page_owner_sort.c      | 125 +++++++++++++++++++++++++++-----
 2 files changed, 113 insertions(+), 20 deletions(-)

-- 
2.25.1


