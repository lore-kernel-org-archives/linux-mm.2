Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4278AC5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 16:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56DA66B0380; Sat, 15 Aug 2026 12:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51DFB6B0381; Sat, 15 Aug 2026 12:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433EB6B0382; Sat, 15 Aug 2026 12:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 218A26B0380
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 12:09:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 981BF1A03C2
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 16:09:37 +0000 (UTC)
X-FDA: 85103989194.14.73AEE8A
Received: from latitanza.investici.org (latitanza.investici.org [185.218.207.228])
	by imf27.hostedemail.com (Postfix) with ESMTP id BCF9140009
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 16:09:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=WzLR1axz;
	spf=pass (imf27.hostedemail.com: domain of include@grrlz.net designates 185.218.207.228 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786810176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=2HZtJ5MrP8KDGrN133O/JlYL+AqZQq/JcEI5bqzXs3s=;
	b=v7pnqGxYMtknF1DuJc+iMD6srjWxIOcLq69XJul1Qf1Ff8/gjF0+Vgprt5EuNIYDT1G9OP
	6dv8NKbOG+/DjzJTkIprfLtbjreC9QZ3B4kXPfcWGup+zVEyfeG3qj+ZuE7yegIO02jjIH
	wA4WDcbAuPWGoTN4fJbyLHnv5Xk3H/A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786810176;
	b=bXUUdQMiTk0jKxkfdjm5a+z2shxBI4Ha71gY8rRkCIO8muN7+EHFSV6vWCtEG1P8YDKJWD
	VIyHlNMotRQLTRObUDXVJSn+WtyPvocfTf2Vgb5CeLcNgDBDViFUks+nDNeVg0yNurmJxm
	EsBUu5Wi+G0XJLrSw22ze4CzZCru9uM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=WzLR1axz;
	spf=pass (imf27.hostedemail.com: domain of include@grrlz.net designates 185.218.207.228 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786810172;
	bh=2HZtJ5MrP8KDGrN133O/JlYL+AqZQq/JcEI5bqzXs3s=;
	h=Date:From:To:CC:Subject:In-Reply-To:From;
	b=WzLR1axz4j6/twlF8xiR93obSNDUtgr8l7RvUwKkksWtyIFGm9j0fD3+C/SjpWUi2
	 N6bFjh4d0t6gGIuj+Ysq15rjqzwKtx6VsbBkCl7VDH0PLrEtLDCGS+tEEZkBYUCm7L
	 mM8oUOI+bDVSVfh/xcHJDrY6XosQG+N1R4BAeApQ=
Received: from mx3.investici.org (unknown [127.0.0.1])
	by latitanza.investici.org (Postfix) with ESMTP id 4hMkZ419TdzGp8w;
	Sat, 15 Aug 2026 16:09:32 +0000 (UTC)
Received: by mx3.investici.org (Postfix) id 4hMkZ35ZyjzGp3p;
	Sat, 15 Aug 2026 16:09:31 +0000 (UTC)
Date: Sat, 15 Aug 2026 17:09:30 +0100
From: Bradley Morgan <include@grrlz.net>
To: joel.granados@kernel.org
CC: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com,
 kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 shijianlin11@foxmail.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, ziy@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_0/4=5D_sysctl=3A_Disallow_partia?=
 =?US-ASCII?Q?l_updates_of_miss-formatted_sysctl_vectors?=
In-Reply-To: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
Message-ID: <5F021629-DD85-4941-8263-3C4F51E9D6BD@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3r1tzdcw3uwtyds8i7prt39g5zid5ie1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BCF9140009
X-HE-Tag: 1786810175-957847
X-HE-Meta: U2FsdGVkX19dLo7ir0sWjXhynFBGLCoCs9kunI44gCbEprcIknZeQ+qbc3rXJMswQc3VltWcX6XUGzl5Ryil74YxKon7Q1fNd0d7a59B79cL8kzzNz1FQwwjnmKqHypYPflQGdiS3fS9JF80jG8ek/9LSgz4ORwyw/M2z0qNACkYMDXipR9TylZ+tD9zvkLu8woDVkMFXObw4lsN6VSQSlGorRMQddX/eKg1kKZ5KO/DbWbLZM9mPZLVSlCLQEYwwM/5ZYf9cev3/J3EAbOXTyNhFY6kGwMvjmzyYLLRKjG2XQzWKsw3jbkU/gOY/HQVmliEbSLuZqWlWIGhJDj593Kjr8c8IhQQRHIrCbG8Vq6U4xi5DyJhcWQ2DN92rhyCOqMRRoeh0aTnqz555VzAK6ppk29F2tPv9wJNT5r6onzKyaWOuqyHX14SYndLxwdFGqMrwg2PbJxvufKtYdexT+idAnxj2Q4k6+s4/hDJuw8nFby2s1e514zUSYVBPMy1mTK4NuH1u7/5xQgkutHX73tj3Z4MxxetpQGPFlwr5ttfhST8nLYAiZ2pLsy6EEPQW8ylWdwQeUOn+sTHyvvFzUNPFSmFADPjRgUMXsVIiNfrIICHnKOYUQ4BZ+uNVZb89xvkUYV1BeXSkpaqQhHtiDLBGcgy0Ij50lDBjE+Sjoqe3EqjGlkp808BMIRKeCz733r3uH/dt58L15GfyqkS5B4/DzYMODnKjNFs0nAMj1PJtDVTCqMoD9zY3IdYlCzS3roesd2wrILx1bUYGsQZ0ul689W2fBllrY7SKV/LkZ6ArDRzhe7HIUeX5TBRxfKPyHup/Gz8Dm1xnVQWMvGSTm3D2B4w/QW332z8/bwX1GbLbvFZ/UazA5dcFTuJZnPISLEx8ihDcNIl1j6QghAy7jcy386k7onvva9ksaOVeMFdKhrIumqg91CQYcod20wOJTj496OUWReV8icL75S
 NKP9L+uG
 yo845Kqz13yRVqFiq3UTobK6jRZRGjI8Yo9e8y9TKYX+knamnOgeeTZeqLZ/leIbCcSKJB/q75fvN6Hwfxd0Lwf3X2YaIrBwlU2oWOnYVGimoAIfNBDU8cdGRT53GwrzmPcnoMDQZiJdB5WbZ1oDQx3+IygBfe7uXNtFNJQ91LfVphDiAGbblIA28D++yRnEFhmVebKVJcfiVkZjGJTjg8/V09lemGet1MKLMD6K9NPuT3j/LT3o/CJ25xwWTc1IJbsmG5CV5eAmt2CJbY5XyZUiC6lxuoVCg5Ohj/AaR5e8GrV2nHCJLG3ufaU74I4eb3uvgZ9O9KjC/zxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Copy it, only write back once every value converted. That's the
right way to do this. Went through the whole series against the
tree, notes in the patch replies.

Some nits on the series:
- "miss-formatted" in the subject. mis-formatted, or just malformed.
- akpm's scalars nit still applies.
- Sashiko saw something on this one (akpm linked it).

Otherwise fine by me, the split is clean.


Reviewed-by: Bradley Morgan <include@grrlz.net>
also

Tested-by: Bradley Morgan <include@grrlz.net> for the test


Thanks!

