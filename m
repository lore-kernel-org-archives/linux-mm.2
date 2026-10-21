Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D05606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 04:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=Wivbp6J+
Received: by kanga.kvack.org (Postfix)
	id A8FDF6B05EB; Wed, 21 Oct 2026 00:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F0D6B05EC; Wed, 21 Oct 2026 00:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934E36B05ED; Wed, 21 Oct 2026 00:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF056B05EB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 00:24:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC160C0468
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:24:12 +0000 (UTC)
X-FDA: 85345341144.25.6141A60
Received: from r3-11.sinamail.sina.com.cn (r3-11.sinamail.sina.com.cn [202.108.3.11])
	by imf01.hostedemail.com (Postfix) with ESMTP id D79DC40007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:24:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=Wivbp6J+;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf01.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.11 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792556651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7l7G7i+k9QsTVZdhBJhV0zpS6MyADVD/+C82vITnO8=;
	b=Eany/O/DTOR41zCh40KLNq1DEI1BOvqprVEx4CUScGP9G9ISdwEKGCpt1dpN8Thl4sz/0x
	yfoxXqulskBHpbL8N+oyLbtCgx53iFlel8M8s62XlFMKxsmUpIkiXbW1T5cND7/PeySLpA
	1OVuR+nOk+dve80U8vBmIwpSzhVJ3/4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=Wivbp6J+;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf01.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.11 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792556651;
	b=LbYpkxBGRV8qDVKJpDyyEH9OUScf5ix+Jo51xjxBU0VdF/xT8sw9n4oRxmjvseGirSqZ3R
	pFAOsgMHdlBgLtdDoyYbWZd91wo98Ql8Fdp6dNDa1oiG/mghUysjQoZnmfNGqKhNUl6avy
	xh7CBl9tHN7eA0h1EdI8P0hp8pfB6uM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1792556649;
	bh=A7l7G7i+k9QsTVZdhBJhV0zpS6MyADVD/+C82vITnO8=;
	h=From:Subject:Date:Message-ID;
	b=Wivbp6J+N8VN9y0lg7HGEHoTnV9guWNNoUH/ucN8DlzzbwliNCVrTuqn9+mhB4jfq
	 hkrvsCyBQlMVZXrIugEO5e6qYUnllQe/kJZf32PQnX4bulXYjVQMidteLI2PpRePQt
	 wYt7w7EWn2HuswyqfKP6ALKT8m4DkDdT7f5mfsWc=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.254.2.239])
	by sina.com (10.54.253.34) with ESMTP
	id 6AD83E5F0000427C; Wed, 21 Oct 2026 12:24:02 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 8999416291657
X-SMAIL-UIID: F14EAB6385CA47FAA0CA6358ECCCDE05-20261021-122402-1
From: Hillf Danton <hdanton@sina.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Date: Wed, 21 Oct 2026 12:23:48 +0800
Message-ID: <20261021042350.907-1-hdanton@sina.com>
In-Reply-To: <20261021024236.1787884-10-senozhatsky@chromium.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D79DC40007
X-Stat-Signature: p1xj8i8i38r55jk37gox7x99quy8x89s
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792556648-290544
X-HE-Meta: U2FsdGVkX18UpHMLEiLoOLNdFcwJ38hr/KzrMadgXHZi4hx4o1auX8DHTGAeGd595kihJRBFQcahsvLuZpBsQvOxWwEQmgvXfBhb8K5Pq7dng3ElQ6UEcOn2TJuf26VEbpgTj7FjneiOHDlEZ/vKIyYus4ATiDJTsjSFEN4DCdmF8KNh9U4Hx4rlvzeHlXGMm5rR65e9HOIURlJEr+p6LacKHUnX7kHSrbwzMpncOq0QLIQUbUBmM1n5EitKHsFLC8uK8kFBQHGgwvxffy6ecbLxrw8fg6sGJQ9s0XPTfR47/9RGrGZ900jsbf8J2ByJTIJcDUmHiFiO/MiAQz0Ae5lQao4mmMtXU5bcSqrJ25gNT86JVBNbIT4nWaT4rzYMiYeVMuewb00WNaIEjXsTpv+Ee1cSsdiZdhbAiLRww8srs9Baqqs2aVoAp02qq/SjpB64vF8QF4Qm3AeHIp19MpURq+YNSrkR17/OO50gqNxadHZt/wJKoeqAsStnURMZ52Ya1maduGrceqIFtah0faTUybDe6ExYQT7Kxl4SKs/qGleY+IT3+6YioccUV0cHPHWVwIIIJ9vAV4Fe46e2yqVIPwP4Lzd/TTaZAozq0I8EYIJD+PNJybOSKSAHrGENYWtbxYSnOiHruaY/GV19PVQ7gf7whSEtjmfiJtn1UZqgo9sn6xjFn8Ynz0tC1J5iEIo8omj9g3XnKyh1NpRuwR+NmopPotDXyVuoVxBZxuepBw0OiAojuWHtD3Md864ajs9M7rUcxME7hBFm4K9iHz7Xkx/6P6FiLl7YWMJtrpYt66/pUf6vEgLep2rhYWTJRRc3sz/KTuhBsdWfTMJdWtqzEallHBLnfuN4XpsD8H1SPYOdyaLeFhhJshsIevPBR0ERU0r1Jz0vdoXw5VAuYa3vYSFLEqDDabFoMtnxiZ3rokWYkkKppxTwolqQfNSAgZKVUMMtwVjCG/9Rvbz
 AOvEoAi5
 WrYrLOHhek+7ME+n+nLueHXVBc33Cgcy/V0i5C/XWT2/oMWfGB3mE87uvcg+8I96yqex1phjUSsGLHfP8FlYC/n0VNMAdGRu7OlRPCrsSdVYOValM0TBy8Pel5inmtQFMrSspVrJDuXL7LjziUp340WqHH9KjnFxflH3ziEDvlqwbPGyXYSWvWpYdr9yzg+ptSDUPDLViSAZT9/hENQ03LTHOv1XZHL3hLA6pvE9z4Nc05v4N2denYsEkvf3AMZ6ZCzSk8CRoD97tIw8wZcNnsa/jINW/c+AW0Ak3S9VTfyHuLuOpvP8LoYP+Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 11:42:19 +0900 Sergey Senozhatsky wrote:
> Split struct zcomp_strm into separate compression (Write zcomp_cstrm)
> and decompression (Read zcomp_dstrm) streams, and split zcomp_ops
> context creation/destruction into create_cctx/destroy_cctx and
> optional create_dctx/destroy_dctx callbacks.
> 
> This decouples Read (decompression) and Write (compression) paths so
> they no longer contend on the same per-CPU stream mutex (Writer vs
> Reader priority inversion).  Currently, a (low priority) Writer that
> holds the stream mutex can be preempted by a (higher priority) Reader
> on the same CPU, which then blocks on that mutex until the Writer gets
> to run again and releases it, which can take a long time when there
> are other runnable tasks on that CPU.
>
Given lock like mutex, priority inversion happens from Monday to Friday,
but I wonder if you are inventing some wheels in 2026 if proxy excution
works for you.

