Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 699F6606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=GcxX/XWM
Received: by kanga.kvack.org (Postfix)
	id 7758C6B063F; Thu, 19 Nov 2026 07:52:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726D96B0640; Thu, 19 Nov 2026 07:52:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63CC46B0641; Thu, 19 Nov 2026 07:52:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4909C6B063F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:52:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87461160A9B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:52:34 +0000 (UTC)
X-FDA: 85451857428.27.6C1F137
Received: from mta0.migadu.com (out-59.mta0.migadu.com [91.218.175.59])
	by imf13.hostedemail.com (Postfix) with ESMTP id 735F320005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:52:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GcxX/XWM";
	spf=pass (imf13.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.59 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795092752;
	b=XFXr8HjR1RwCBopsfjTp2OUc/c+KRHVuo24t0ADdrVRsEfT1qVE37XgDIqWVdHnfiTzd7E
	TzvLV6VIwlnpS3+tsfWTF31F/Zxlv0xCYQTtLTH+sCCPEcUviIt4KUdmFsFhgYYtHU5Gaj
	56XD2FxGo6S+7yxui5XB5+4cMxDyzUw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795092752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nOPSfl7MrQH3aAdmvuLmCg2r2GTpQs9P2IrkXtthaEg=;
	b=a3dT7Hz3Df3OAATAPnJpy0zHD1YXTHR7eKQpjmHz6yXFtAonliqmSS64ZtNyTBRfBf+EPu
	w/vJqBmwdfWS+ke78U1rJPO0EtK8CnHSLMmK6j3nQpOgRO5YPSjwnhzRXB3LAX2m6gpGYw
	TldQiTWxoOWF8NPLCCaUlB4j5Uj7hYU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GcxX/XWM";
	spf=pass (imf13.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.59 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nOPSfl7MrQH3aAdmvuLmCg2r2GTpQs9P2IrkXtthaEg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795092747; v=1; x=1795697547;
 b=GcxX/XWMeZeuTZblPzOCtHls2XYIzke8Wax5r/ZTDw01/8E0Ew5c+J5EUDAe6wPJ+SBNgxO2
 W1IO25VH7eI9UG4Pun7lF/zTewsf0Qe0eTP3N9GVUTCSBNSFInYGMP0Cpy0Rrh4x5KPEFMc63FB
 jGN0iSoqJ4DjznvX+zMivyik=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c26360b5cbcdfa14;
	Thu, 19 Nov 2026 12:52:27 +0000
X-Mizu-Trace-ID: c26360b5cbcdfa14
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org
Cc: kernel@xen0n.name,
	rppt@kernel.org,
	liukexin@kylinos.cn,
	guodongtai@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LoongArch: Allow memblock arrays to resize
Date: Thu, 19 Nov 2026 21:52:21 +0900
Message-ID: <20261119125221.11897-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAAhV-H4pmcV8hah8sPyQn3nR9cO-NwkXMPLeSABAO-VEnS08fg@mail.gmail.com>
References: <CAAhV-H4pmcV8hah8sPyQn3nR9cO-NwkXMPLeSABAO-VEnS08fg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 735F320005
X-Rspam-User:
X-Stat-Signature: b5tsroi7h6buobww3f9wymbrj7ejotiz
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795092752-275768
X-HE-Meta: U2FsdGVkX19Gd2soN0OZ1yMZzhg2cS/OTJnaunBKrVHZMzxu/acuka//hYxPZKobWEFC7ztcUrPLD6c+DHVOSE4VnfVTSeit64E1C+w+/SwguAb5uAL2HBTbmbgMUowaI29tjsDfma3Di2irc9oOr1+pqSS9hcKnDmsFZAWCizcdXcFoMAolVzSyFY6sVH4qXY2AMN0z9ykqR1wAdhoUByQztny0RtymV+BC1L7lkR9msa2KCQTzkmT6kjeN54DteEUKVoi43hwjLpAql5sdDb4KS77f1rlUvNuh9Gu3iTDh8pC3yklrhLabCv2TM9kBbnp6tZqhLkQv9RE+Naoy8qdhpBX5PC1YhMakhnvOSC72jXAx7Zwm8zyvQr0WQIQz5v8Y9f2+Ia+0ikktKwNLu1LJp0ukbZTaXZSiAmxn3Aqw9nfbbA6liecgTzEIlkaRKwSt71p5uPC3LEn43pJCM+LHnoLfFEtYAwFNVoBMxfLUcbgXhgPnw37a4nFh0BKiSkl4yslUIqlwX/RMtH/BzEcmsgboY1P7E///MBAgAerJq8dIVkPBHEvn+kMbiAeGEN91ZRnHXUp3We0ZUOS6dNSrownlrl970EYNrK7skDaJgG2rabWrWp11P5bOF1xiPEJVwQGM21P+Ntkqglh/AzJ5yaRa0Nj3D8i2H5+8251/uKr0L76kwVUegoPiAX83MxYcU6CfdSajDCHtgJNfdp6rq+Qwb37RgULR/6TUFBlm9pH9glG454CVSuwoRlN1nEvNQDsLcUWCBaUPNVzk5FtUSs02wk+AoY6Z1XfBGhGl+7UdqPgSx4See8K/x9OnGaUWbMtY6fRh4D656ll7N/ruV+fk9eVQi7VIB7xGfEmCxL9hLTDUWeWtTF5QEk8fVOfB6AZWXLaBvhDzejqsCxbWXPpaQVpQEK2+XggCbVv/TfCzcVhSir+CJGZR7Etn0wrOKA1j11Sm+s3HhAa
 fxYvvWtc
 7qROnIgCRAbpd/9h3XWue06ktqXk1HqnwEhdAc3ybuSFGfxPoP2X4XhJMLx4rvTf28YLmotNKUyLxLSxbYgwMY3NE9A5Dszfwa1Q1/Ui4hA2rO/9vbhJ9JQHwfq7AyM0BuKmVQObhKQ7ULMU9e1cmGWfT+cUIy9fwjmqrrXn+/+lPJ5HsvTR3QPJrHnwu0ji198RquAYX8+T58AM/lcTwuigtqYW54gCIAvpAxMR805QCXfk9gdLolvRryOrknBVPA9wag7CVSy5IdigNTrNlgIaXQ2LvEKx+O2Av6tHOSEr8FRHaCgf2KtAXFFwHzvUuDy7yQRL++w1KczGt2WTwMhioQBcrPuf3buM6bTW4/UdJHfE8CqVSnvf8SI8cb2gTODidxH1MHySNJxVzLH4huC6JqY9R+91fWZuviZA9yHZC0fNJdLftVFwbsa3Ha8DxNGBFNyfQK8bTN7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Huacai,

On Thu, Nov 19, 2026 at 8:05 PM Huacai Chen <chenhuacai@kernel.org> wrote:
> Would you mind if I move it between memblock_dump_all() and
> memblock_set_bottom_up(false)?

Not at all, please go ahead. KHO still works with it there, since
kho_memory_init() runs after setup_arch().

Thanks,
George

