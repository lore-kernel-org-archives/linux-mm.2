Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE08C531F9
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 03:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB8706B0088; Mon, 27 Jul 2026 23:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69446B008A; Mon, 27 Jul 2026 23:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81216B008C; Mon, 27 Jul 2026 23:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 84A196B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:46:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1597CA0255
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:46:57 +0000 (UTC)
X-FDA: 85036799274.03.BCA220A
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9DB6A40009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 03:46:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785210415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3VL3XeZjiQCnE6bNvsXryX0VZqaptUWuAXmV7xcD1g4=;
	b=SqselqauregIPrpOn/8OfqxJJY5hxcYsNrTp4NGbakw1bFUJ+EDt5nFSRWvFAWgfzmKwCo
	HgS1FR/CAEwrqm8jnGJKfzTqiE7Nkd1kqQMeS14QhmMgp0Gjyczb7irCtmTUuE640rH/NR
	aLz8qA147Tqho0OFXgqVUzWZXRKa4HQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785210415;
	b=p+ekeZXyU+WgYjKRU4AbjrsIblxuZw5s3TVX6u/vVmFUBsuF4nHmz8zfxmgg5MwQEEgHAO
	tpG0+O7uGQJVcS9q8wK5df0RnlJDLceBA82eXxGNnPrRP7MwJg0odfVR3lZyjoLo5nT87e
	4qM2iyJZUizh9l6yQa9AoUq3RdEb9Kg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from TW004-1.hihonor.com (unknown [10.77.232.85])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4h8LxQ08q1zYl6Wq;
	Tue, 28 Jul 2026 11:46:50 +0800 (CST)
Received: from TA012-1.hihonor.com (10.77.199.132) by TW004-1.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 28 Jul
 2026 11:46:49 +0800
Received: from localhost.localdomain (10.144.5.36) by TA012-1.hihonor.com
 (10.77.199.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 28 Jul
 2026 11:46:48 +0800
From: Zicheng Wang <wangzicheng@honor.com>
To: <baohua@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: Zicheng Wang <wangzicheng@honor.com>, <hannes@cmpxchg.org>,
	<david@kernel.org>, <mhocko@kernel.org>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <ljs@kernel.org>, <kasong@tencent.com>,
	<axelrasmussen@google.com>, <yuanchu@google.com>, <weixugc@google.com>,
	<linux-kernel@vger.kernel.org>, <lyugaofei@xiaomi.com>,
	<stevensd@chromium.org>, <linkunli@honor.com>, <tao.wangtao@honor.com>,
	<zhangji1@honor.com>
Subject: Re: [RFC PATCH v2 4/5] mm: mglru: run aging when pages are severely imbalanced across gens
Date: Tue, 28 Jul 2026 11:46:33 +0800
Message-ID: <20260728034633.3387845-1-wangzicheng@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260726122123.7614-5-baohua@kernel.org>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.5.36]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA012-1.hihonor.com
 (10.77.199.132)
X-Stat-Signature: dcj6pm6z48r1z1d8rfmtqxu9gdgekf4a
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9DB6A40009
X-HE-Tag: 1785210414-503143
X-HE-Meta: U2FsdGVkX19R3G1eMPwsEx+WrevMadlerfi36Z5xf4Eanq64CCOq/Ayk+8QMNX1AsYODmPlTaaXoNAn0UtYhBeP4rNlGhFqeDXt78M18Em3aBbZMDy2zOLxwCrA8wXgHDgLzUEb+tcE0FqfWdT1yO7ZwEglfSqZ58VUAeH3XmEotIM5ksmInVUwQv4oDY7PqpVHpuirm0UVCbtX+A7eck4WzcUDMv46XzCF5g1o9YRWO+r4SCJmYFPHx3X9uN59z1Z2IpYC3YuGPjEq+ISRxSDKuxeH3e/qxrIgP3or50XLaEMxgytziyW6IRzNAOXTmWWl/1Xij7lLl4VvvWse+4wGEoSJnxtTO97nn1bBk4VZoIshpmDYiyCC4Mvc1IOZhjgunsGtmlLfG2MyG+ll4NrN6naBFMndWi4yEFtNNTsdL/V6Nn+ZCO5+IFMU9P/Y5DDWZTd1PnbOqcYHNObx0MSgmUP9Tv5V/qDsWnh2veZNmsjcioYgr9n2qUJ63/RDSzKItJpDGpEzJrPrq3O8alo1QDL5+8OCw/hcOYHBuCj8PPImxeoMnclh6seeqAd1f+B5NWpSth/+jqLvS57ePDTxnrG0OwRKKn71UF9q957yy16+id33Umgeax2OP/jH56lELEAEEnRZlKvONN0JjpiectqGmxM2WjbaQvjMKicC5ehJAqn4h5IOPr7jFkTvDood+Tk+rMQgRs45AFdk8TfgT7vmlnAjnqmodMlpsaDlOt8UBg9jJftYgvr9PrC6C2Bzx7JHn+wRp6hd4kuRccS6le5QdQnmdmHpjzQZuArkJRu/igVT3ed6a65S6WS9a6LhfTnuNtA3SaEEO/aHjjcXX/vrxKMzLkLS7rmkZk76M+FhoTnaeNo7Wrsh+x3DhYfrMyrp+gTs69Ii4oBxtZH49lDih/Tz5ARjJTpfHdiGfYRJ9rWMxn+r7ZJ+mfdBhPCIne1v4Eg70aEzHBnz
 WXTXoKVX
 9VEZ6fERkbMm5TCrs+XAeVShvXzBQaaHfxNEF7Oa8mPLHfXokVl15J6bwXBEFQgUf6fhO1uXvJrAPXuuFnQhANp9E4NrZkez6RTKh9iKN3j6/Y6t8cdK/hipdmtW6AC6Idv+Acxw7WVDDIqw/IWTNH2rDRJdY4bHTQ/BmKUPGmQTZTZK/QOM2Jq1iyq+u66m4TqU9L7VaJroSHQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry, lyugaofei,

The cover letter results look good.

This change looks like it resolves the cross-type skew from 798c0330c2ca
[1] (if I understand correctly).

But:

  removed (798c0330c2ca):  old * 4 < total
  4/5:                     old * 4 < young

Can a single type also skew, and does changing total to young have any
downside?

Nit: the old form derived the constant from (MIN_NR_GENS + 2).

[1] https://lore.kernel.org/all/20241231043538.4075764-4-yuzhao@google.com/

Best,
Zicheng

