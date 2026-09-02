Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA10EC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 01:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB58D6B0088; Tue,  1 Sep 2026 21:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86AA6B008A; Tue,  1 Sep 2026 21:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D3F6B008C; Tue,  1 Sep 2026 21:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 84D236B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 21:16:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B786A05E4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:16:36 +0000 (UTC)
X-FDA: 85167057192.09.106DFD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7B592A0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:16:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B6VTk05m;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788311794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Mhxtqabf4BN/IkLfs+zcaKuZOjTdW8c4GvQzPk50rE=;
	b=cR0NBlTKNhjidrg91Q/xU5+sbP6+B4ofMlY8gwrjymFh1Hg+125oiV+XoiXw7ah9SOe44t
	nKXg/QPHmuU1u5YRCRtjmFvhIJ3EXfXl6z33ZT9A+YNSCIKw7Jk1cejcg77NQjQKo9/l3g
	AqeBVRlZp0TPPh4DSaQkqUE0mgaUC+k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788311794;
	b=g6l7vagvBhyM90wNA1zS4D5hijxJqUjF7fTyHs8AagVqzqf8z7534RA6HmmTDbNDu/x/I0
	+vLdcKE9lDQmEOWCJ5tSltSdDRGQtbDvm1AKQEEl3UNF01MVIumfbFc30DEv4vKL0aK877
	zFDMLq2A/2AUpmCKMZWhkPuYjhtlkX8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B6VTk05m;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 09B8C600C8;
	Wed,  2 Sep 2026 01:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5557E1F000E9;
	Wed,  2 Sep 2026 01:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788311793;
	bh=3Mhxtqabf4BN/IkLfs+zcaKuZOjTdW8c4GvQzPk50rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6VTk05mMB7XY9sH06GdL+3cstKc01C0XAWUzwKsOI+viYpXBgIWqv19h0pNBfyDS
	 yu6N3zjMGoyd8lCGBVKIACZ1ROaQQoIpSchThLqu5MBwsUhh5JBbro3HJvsyCBrQZ4
	 49AZtXRdQaAsaW0CF5AJz0LosDT+vqiJkrUiald9DrrXtJhTUcHej3czB3ApX9Uq22
	 Zg0jVQw/Nd+GKBFA8QcOFQUPwfRoxqWN92IeSculnOX7/OoNLIH6eojeFEFXoJPmPY
	 2QacL5mWp2xK3657euV5Upzqqs1Dhqy/u/4GMiVppTN0XKlSMFOP84qfpkLd1ePSW2
	 Fw02JSydlcPTg==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/4] mm/damon: fix misc bugs in kunit, quota goals and sysfs refresh_ms
Date: Tue,  1 Sep 2026 18:16:20 -0700
Message-ID: <20260902011620.110326-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902002725.108635-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7B592A0002
X-Stat-Signature: 3jqdc4tk3f4b1esqwbhzj18ncz8ucfc4
X-HE-Tag: 1788311794-861599
X-HE-Meta: U2FsdGVkX1/N2u7Ltydh2hf6Q9vJeuBtsy1c2iz4Y8ArPnOMME/2Q46PCoVyvEmJrYvPOOlMHM/21uNigTAUBvuBedrPuI5IIvASZ3dx1svj43CJMICiYm11opVW/a6dBeh3EVO3qEDmP+zCDGsi8qjXlvGfqVpBncy/jNKGx2QGwHh1J0ylcUcLiC9MFYNNgYAuxu+39aHcmq52twRvjKihsAILOHCLKk/MI5RcTf29pswJDpCh/Bou7VXbPVRwRYgoMgcxaOIdKCKKJ+MRUpYvqzzhipK0Oo0h80LfjrOSCgQT/S/lDidxZZrKiruPz9F5FBmAAGUtD9jr6dHeX+J3u8RX+D8W1g/5G+nPUGA4WyEH8ALxjQMMMouXEcgTVASHIqIOwxnfRoN8EE2gce5WK4YLENllexTN3/zUwSwuzO9jYU30XbnCEuxsJhA6mzCLYiY0DQjOxbrO2vBstQ3lL7DfODjg0+4Mq5BflE4Q/4CRCxYJVD98WXNivXq9HJh0R6/8JabkjJHQEgPnAQrhH4Rud9ciiHUrMleexYGd8LSSwyyrHB1n4XJOq75sxC8xyjMneniP4SEytr0QoAFtUI/YgnVk6V79+m9bUWJB64X79zodkTe/8dW6f10Hp2mnJl4KnRheGNudnSasOE5OnWb6BMlnUVpZvYsCf5anK1Teokxx0uzqtKE4v+Vv0bzP2T6iTprA/FS0otYJ+aDErxrqV+zdu1+p4Zv7za3nZi6yz8K8Afeedz3GZS1VgSim85NtPaCkkWhCsWOcCv6rfzCD/RE5qe/X9msgLwuHtKsqgWbIwCwX83QLYq4EiyQP5JAEwgiD23sWo9BaYg8vde7c8xDS6CggiQ8d79pV3a5Vz65pKaeW8D60CB5m2cRYBRRdDHbQBlGnjcoo9btVySZdnZpJif8BLrXMJK+NRKt/E3/LJQ+bMyqHB0V1Jv+ReRtq4kELDb6S0sr
 C420rwVm
 i2wAbyMdCHBtyrT7v0UNJb8lGMRNAVehae5uKXdHRVK2mcT1L+efuceXvW/nF73yvrzdvDKBGFh4/8rmfkKMiQQhzydPcO21QAp1u4UDFOneZ9WheCQh6b7aV4/HeUSQ99516hTpzcpayIQg4vkrqgAqDiKVD2vBBMVcHINZBPMs1BLKLUFO4x2y64gH6B0TxSRTlW34vH12dganQz71B8simjnJTRxMndEBpw/G0uYkxADhipuxQZK1tjVEMetHDIoyivrkioIE+vtuE+rrrK/x1kbcbnnaRnzu2A9l+WX1HW7UFOiL7PeAv92lZ4lt3L+fQOI1WKaj33mNLQOUVQCtjUrYDyeMZtYGp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 17:27:19 -0700 SJ Park <sj@kernel.org> wrote:

> DAMOS quota goals commit unit test is mistakenly not testing a test case
> that was designed to test.  DAMOS quota goals and DAMON sysfs refresh_ms
> file have bugs that can produce non critical but still unexpected
> behaviors.  Fix the bugs.

Sashiko found no blocker for this series.  Sashiko sent findings to damon@
mailing list [1], and I replied to all the comments.  Please read those for
details.

Sashiko found a typo in the commit message of patch 3, though.  It should
's/QUITA/QUOTA/'.  I asked Andrew if he could fix it from his side.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

