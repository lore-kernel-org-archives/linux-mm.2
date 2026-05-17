Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89B77CD4F3C
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 23:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0646B0005; Sun, 17 May 2026 19:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70F66B0088; Sun, 17 May 2026 19:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60746B008C; Sun, 17 May 2026 19:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0C9A6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 19:43:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 512931C1B3C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:43:37 +0000 (UTC)
X-FDA: 84778541274.04.EF72834
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id BC74C120002
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:43:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WK2w6zkg;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779061415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lfw/TTFM6D7fy/gwFZ84WeqmLBD4Oe7vmrWoOFXil+o=;
	b=t5bFOIppFD8zbkbOnUcGoRhdm/ES2CdhzmFj0SCl6oUH1Rc4tseRsarKW2HmZaRCCm8x1w
	G9O4A/bjKYWj3zvtvcXrVET5THHjz6c2kco1fsUSSsoCKEug8TjnuVNQZZvO8IYd8J+I/x
	4NljE4WBQKF1JKrj/Q0cu0EskUj0ZG0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WK2w6zkg;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779061415; a=rsa-sha256;
	cv=none;
	b=xDcvjdceFZb62BqKh4dV0GJZ0zR3QChfPTHGxsuisbhwoDebwRS0DZtxZuV2eab93ueTjb
	kry3O1IXPl1o1+wXhVbn/VxOk16Kw+y8yBr3JZ4EZ5PWyrIVBvyZos4sqlsnMyKqZXq3Du
	MYKPKB+LnNdG6gc/MNBFgVOJBreAf7A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 30E516001A;
	Sun, 17 May 2026 23:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67094C2BCB0;
	Sun, 17 May 2026 23:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779061414;
	bh=C58ff92wWoNH074Y3QiAq04Vkd69pqekAVx6WD6vV3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WK2w6zkg+hyM6I0VJmSXyURzLnFtpc8fa4kp/+6F9Gi5LZf4krxwBHJnM417Z1HwV
	 9umdTxCwTRdKgS9Ti0iL57DO/fztm1+KxMc+o7XdMEC5t2Ww6ErmYWZz1I4mUPgsXF
	 91o+JFyKX1LUceV66zsy+c/FSECXK4H/1woHnRs7IzggpjLwAhXxLSOyVMjFHrAyUI
	 eNSuVol+evLXtWKdS6hblQPBl4JNN3FCSD+f8pW3rOrvzqkpsgR4IJH4vUjmZl5/Ax
	 kygbhDx1GVkFlLh6P9toqqVBHyQ0oHKjQD8aCWbCgT5lUbtdlLZ68D+Tj2rlfdMusy
	 W+rTYYsTPrm+Q==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH 5/5] mm/damon/paddr: add time budget to migration page walk
Date: Sun, 17 May 2026 16:43:24 -0700
Message-ID: <20260517234326.89365-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516210357.2247-6-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BC74C120002
X-Rspam-User: 
X-Stat-Signature: tst1yyydod7da7net61id1f5fpo99nm5
X-HE-Tag: 1779061415-564571
X-HE-Meta: U2FsdGVkX1/fDewtPoIo5abEH66ymfqEBYDXs0NY19UecHxAdGxSdoedu0udOIyhwnQxyvevq6hfpcCKd/F8rqPH18PQ0a+wdqQOjRNsa0OrlcqB4CKDlYBRpeeATI4uR1dSLYWbiQHCdMYgSJKfDaCb27S/bhbds1dfn3IRbmd5MjG9NvV2DB1+aLdRpzIl6/woFAt/kz9pv5U9DWn7uvhfgsKExg8XQAnnPyZU6i5d3bR0lQZ8/hGuvyJ/xFBEG3L8IbTRWoiCME3waVmEa3dhV3UKFzmQuwK1ZtBv0LKcWEkOV6dcisgo4SCvPpxRpX0btkPxDSFsa9GVPc2/lkA/5DW8+ctGjXA22BoY+mE569ALcR6ZmjOb4aTCkP0s27uwrCQ8sfQx/XuLZGSbKY8XhuBOakoHJ3mv+LdzimTo67/c5mCiL/p2/PDNfJ4zl3vVlet1TZ4zxaig0PpyG3LI4mseZOg9mHpwsA3F8NPIOwEDtdChc7+iofAenHLed9vo9O0QcL2ZB1oZNm6FzboITWB26ajU98vGgHYl4ScnjaLSYNfBFXw08uTkViND3pUXcNyAIQoP3e/xzhASjbTtK1qth6feMTlX7PgHUOtu13oE+KTbHyDhzrDYjWvRe44O192Y16+YPjFPfRFFvS8595yehy8iQIq/uIvgCuBRV0G6++jCJ4UQNzlnzX3qHFxBLSSpv7lIt2h3qo3ZCWVwUSFYshA74eTB/oWXl674KeemBgHAD+GkpYNhmqZCh7i4tOZ+htMTVE+UR4CWFmdVaL0yNSibhAkeTUL6099IXAAKPGLI2A3Oi6tVF4JssEiqKfbsKAyllkfoOAqnaDnn7nW9xcSYJHleQTT78zOlk9pYFfK/oWcmXEt+Iwc/IfaauTstK40MLZ4LaO25ku/RAtpT5d8cEHn083+SFNStyv93v7cwR0M+4bpI0YK7m8+Hhz0zDvKaiZGwets
 5Djp0m1l
 6SRTbNSPkOTdWtgX0Cn10ZS4qB40LEBDuNtlehpJCOpXoqLQh2pxN8gSX34C4TxW93O4zZ9kc9VOKofvlRWorBg3HoOjiU9j5qiTrJcaPVcghW9pEga9CGbUV4OEwVy69+0RgURuzFZu64N4qhJGIoq5m7uysaokcOmoj0XWQ0LUACBTJKV0TbcdaeqkwT8+IzsmggD8ZtxkFivqN9O9bkEMOZhwN5BQ7b9Ursg/ZQDew5XJYG45CNW7TfcZqzFQQHYeJRM56GMTOAVAI3ioqPcoxUA1+85g4oX6/94HI3sOypi/tzYqJDq47/+41n2EuhcoKWhg2v/XzDN1YrFTETDlE/zdgQk7GY3Hu55SSu5LEu78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 16 May 2026 14:03:57 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On populated physical address ranges the pageblock skip optimization
> alone is insufficient — most pageblocks contain at least one allocated
> page, so the walk still iterates millions of PFNs.

So my questions to the fourth patch of this series are also applied here,
especially about the assumption of systems having most memory free.  I will
hold digging deep here until the high level discussion is completed.


Thanks,
SJ

[...]

