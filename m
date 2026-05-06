Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48AA9CD3424
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 08:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9CA6B008A; Wed,  6 May 2026 04:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0AA6B0092; Wed,  6 May 2026 04:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6CD6B0093; Wed,  6 May 2026 04:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 888736B008A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 04:48:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A642A0624
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:48:09 +0000 (UTC)
X-FDA: 84736367898.22.DEC14F6
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id C3749120004
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:48:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=RlAu3AWO;
	spf=pass (imf29.hostedemail.com: domain of "prvs=579771007=hans.holmberg@wdc.com" designates 216.71.154.45 as permitted sender) smtp.mailfrom="prvs=579771007=hans.holmberg@wdc.com";
	dmarc=pass (policy=quarantine) header.from=wdc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778057287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzG1QcduLYPx5YIGM/BfY47cz+ZD2G5MO0VoLyhKKfU=;
	b=RxuVVLV+t228QgoGIo7DBJlxNMPbr9TTJ7Vb0btpJioBg4ZMzCCha8Qd4LvvasDWm9VmEI
	yONS+afhzZHFTzNWeLY63FmcgJSix45EOTIid7Sk0idmbHR5RUIiarJjJmjNcLczmXAA9L
	OLMpbPQxjPONtkNcXGEfjG2UYv1GOh0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778057287; a=rsa-sha256;
	cv=none;
	b=SmCeQqAlRSFB5UeXtlRQpCsm9tydUQHQpz/sCzuYhcQm3xJBX+XP/eBTqlyyrzxUHDmUkn
	TxVklF6RNwxZONNE3kSzdgXcPOwFWkCzvbiGtJZMYvtDN09sklXkQ1nHEDKA4FlBJ79vGB
	POPj3wGWjXvFWFrKvrikwJVjrFCvPKo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=RlAu3AWO;
	spf=pass (imf29.hostedemail.com: domain of "prvs=579771007=hans.holmberg@wdc.com" designates 216.71.154.45 as permitted sender) smtp.mailfrom="prvs=579771007=hans.holmberg@wdc.com";
	dmarc=pass (policy=quarantine) header.from=wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1778057286; x=1809593286;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qsBm1M6FmB0XbuZrcOGLDEAaSmoHvdrJLvIG5bXwZLM=;
  b=RlAu3AWOTLp4kCK7o/4wdTmvvWKjAAIzOVtJQVdDsFt2NCrX+9qgFuhR
   MRo/MyPOguxtL5Dido170HmNNdv9RTMIuDpObNm7QgURmvj2KaoHPWsmq
   EUWTcrfb6BHxstsuA2XMHnk+3HpWH1fKR9YmHdrrc5s7FPEPsKU30AzJ3
   jLhFAjjCvcaaeM+kc052BG82HCJgmIIBaH0whCFRwZHmyIOu0hdP1UF/X
   IesSZBxl/+dBpVWXvWlXvyqtEsCxiiiVjS5oBJskL9q2UTRzfxQWo7Pwb
   +mH1n+uP6pd7MPG4JzA2hhFZmYvLKD6SnJaQx1jx3/w2uX6/wOq9Zvq4q
   w==;
X-CSE-ConnectionGUID: 0b9auKheSPeCiAkXoS7K+A==
X-CSE-MsgGUID: FL2sWazBR7mjpvIttvZgJQ==
X-IronPort-AV: E=Sophos;i="6.23,219,1770566400"; 
   d="scan'208";a="144862048"
Received: from unknown (HELO uls-op-esad1-o.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 May 2026 16:48:04 +0800
X-CSE-ConnectionGUID: eI4/O+xOTq2tLmIII0/D+A==
X-CSE-MsgGUID: Rvq+HWvvRven8pI/FnqxyQ==
IronPort-SDR: 69fb0031_MUdC6BWuV1puYMCO7bskfX6GKGT2Y6tAY782136AyDJ+oET
 rlop8WW21jeHtoiAwVGd2KVWkX1CjvX3NAhfL+A==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad1-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 May 2026 01:47:44 -0700
X-CSE-ConnectionGUID: 0L+uBArmQx6WoI2fXu2yXw==
X-CSE-MsgGUID: 7/GmHKBNTfex5oqEb8E+6A==
WDCIronportException: Internal
Received: from wdap-ev3kzn5lk3.ad.shared (HELO gcv.wdc.com) ([10.224.16.14])
  by uls-op-esai1-o.wdc.com with ESMTP; 06 May 2026 01:47:43 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: youngjun.park@lge.com
Cc: chrisl@kernel.org,
	linux-mm@kvack.org,
	hans@owltronix.com,
	lsf-pc@lists.linux-foundation.org
Subject: follow up after discussion at LSF
Date: Wed,  6 May 2026 10:47:41 +0200
Message-ID: <20260506084741.14228-1-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330>
References: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C3749120004
X-Stat-Signature: h1pge3786uj9s4n3k6stmom5pk6xh453
X-Rspam-User: 
X-HE-Tag: 1778057286-57467
X-HE-Meta: U2FsdGVkX1/A//WiB7GXx/dlzKGJ3KczKIKbFIJ4u/eteJ1aWmHzpWIxGM5/NCGojld0I2sm8KeKLV8UGyp/82K1cheYMaFRjUqp6FRYEo65kwfCgvCHDvVHJY9purzA0JQ31gNmAP4kJqG+JMwO8am+MbQUUienA83NM+C4t7K8nGORp0jsqh8qW5/x+zOp7e1ZE8lK6x+G+atOfFpWOForVsm5P7JqOWK87As+cIg4ZBtx35+p2uJyiA9pXtEcxqaMiMY8/FqJHpHecVaYNR+6v1qNdBKl+vZ3ZfogZq8Jx9R9jbmF6l2zNYCxtA3eH7hET0RohIhS2PJ5aKD+BgGOqWQU7L23HlbAsJJ4E7jnuraknhm5l5n62H24V4MCREi9N3vOVdFu+RbG9AoYqX9nZT0YgeB947iZO7iNF43GRIfptzlIIw9QbzmFzTzxEycURQhg6kcMIy463Fr6P9F56l/mHNwL6XDY/ynyybBUx1Mol9PAwxFVr284NY0qdSFZRsK7G5UVxuqGDbmJfrL54IYTYDU/zTZ7gxf0btzZfGmIUfdr0eHHhJUKWoEByyVPRLmy2P6OCdbGqPBc59My/fmH1z6Efs5EiJzd41/Kq1q2xNn9l6mUV9EFlXhkzG0nuo171zPGF+8ARIwjmZBP3yqq+6EvGrJtlNSxq8hGrdtCY5Qmv82Vn1J1YO1cPNDfMO5/u8+s9o9oXSniS6NgWAlAACMRZnj6D2YyHz/AtxhyL5QZYASGKylx2RZfT3LRzzbg3hREb1fRVEw41SiHq4xtvmG0JFIwhuytm6OWVvWd0tCL7MmeFvWsiTpI+0QgrLckB+GilHYwHpxhbWQyrwEzEyMggGsLOhf9IBAJY9LwN5IFS1amc7MbpbOu2BSMdpW9Co8weZZZjZe4PWuCClLaJCJo2GAZMvPVCsov5VKI0M75KXwcnWXacNQx75VM9vmjwuwxN+ubOUg
 SyeKiNrQ
 gCmnfYaOIjI6Pc+XReuyGacO/DRAy2RRX+XCOGZ/PT4URTjgUVOXlCfjz/X5DPDr9hA1WXcuO/bLlM64XQ0/EHg7BNxEr7kgKBw6uIGkucK7dQO0keUh+ssybWfmcaPhn3BQ75OYxzIfpt+gcaMCtp1pAafeOMBwqAAWynWfNPh4fPv4sWOFNkrqBIBSUKyZyeLl45pXIj0EzAtf5rH3xDzSgh3OurHRPQqIvu1mRDfG6R+FCO8VIyXCtUhJw7Tr2/VZbsiMM8B9qieo5VE5kUG7+hULWKL034VtBPZDNZxyvT7RV5zkPCAQ/XcRoC05Ec+VNh32rPFd0zSqNQ6UXtOfOTGXXeeTWchbY8QpD711kY4RvwstIuIqecx1G1SaJVWynL1yZ4TUhy90RCpSYr00H4BROM/IkklXVCkX7D0aKKrs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'd just like to point out a paper by Shai Bergman:

"ZNSwap: un-Block your Swap"
https://www.usenix.org/conference/atc22/presentation/bergman

It targets ZNS SSDs but it has a lot of relevant good stuff. 


