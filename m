Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C28E606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 10:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ua7oM8fD
Received: by kanga.kvack.org (Postfix)
	id 82A4A6B06A0; Wed, 21 Oct 2026 06:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC496B06A2; Wed, 21 Oct 2026 06:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674136B06A3; Wed, 21 Oct 2026 06:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 431526B06A0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:17:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D3121204C8
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:17:23 +0000 (UTC)
X-FDA: 85346231166.30.AA04741
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B2BCC40002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:17:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ua7oM8fD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792577841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kt6vo4l51awhjqq3I2zXUePIjWcvYUZXxZ9RPkgXQb4=;
	b=4klAS78Ac6r0o8odJoSYlzv6pJMWp03uhOYYnKvOqZ0nT8ghOIa1cBdifm5kJvyDeFlBDf
	cZ7mBOXQlXK0PWgAqgpr6pNLqZ6JLA49+I2eV2iyJXMQKk8X+cqcPSLAXUv6+TiC56VeQl
	A6flYTOrF068XVfvM+JQ5svZkVNioKA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ua7oM8fD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792577841;
	b=Kp4xKStNFLj+NAYLZg/rE0Z6L2d54MU8Rr4icfyvLUa1W6slEdyduc4ipyzkaK3El+mWYl
	ozh0cG6xtbvfeXhJQrM1aVg4Wuk818qHJMDHOZrZd5l4Rr6LFfOZ8tT1+rZGfF2ePkERYM
	MiZaH0NViRVhm12tjc6q6qSZspN1zdo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86F3860052;
	Wed, 21 Oct 2026 10:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3D61F000C9;
	Wed, 21 Oct 2026 10:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792577840;
	bh=Kt6vo4l51awhjqq3I2zXUePIjWcvYUZXxZ9RPkgXQb4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Ua7oM8fD2K3FMaghCaMTRd9ndhsONSrpG8JtFqKFRH7QkzZYnNXA15wEiVNRYcXDG
	 /ZrdAvrUX1dtBFeRhboJ87hFl8Lzk2RKkMo+bHOPOlIZFAoDm3FUFDBYiwNrXbzbiD
	 o5PqeyWU4ITidvmG4Pin2asL7HiPpAK5VRQp/lO2O9dQyJoeQua+dNbvzRJ8i0iXzw
	 17K2T8spJdWwbNdFEGl73ma9zW0rwXlPoPHGDVLapHBQ+CXK8paHtxovCMXXD2WYB6
	 AqVhpfGAghihIMoozPSch1/UiP0HFf8Obo5ajBAhbOVNVfIEePRmHOtVNCEyx3kiUa
	 Jdp96m58i4GhA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,  vipinsh@google.com,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  graf@amazon.com
Subject: Re: [PATCH v2 2/2] selftests: liveupdate: Add tests for
 LIVEUPDATE_SESSION_FREEZE
In-Reply-To: <20261020144710.4154339-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 20 Oct 2026 10:47:04 -0400")
References: <20261020144710.4154339-1-pasha.tatashin@soleen.com>
	<20261020144710.4154339-3-pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 12:17:16 +0200
Message-ID: <2vxzzew7fjdf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: B2BCC40002
X-Stat-Signature: nztasd9uf1ojaatqkbobdg6ztxd3efq1
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792577841-916834
X-HE-Meta: U2FsdGVkX19cJItZ0kweUMkTmEpKwuDUWeEjQu0QpHH6RgUzRoE/oaFydr5qsdNzyZdqTk5e5V/+MAmBaFz5AUY4oPrLDWDZBGBemHJH+fMOQ2WtsAwAxSnEieRNpdG2Tbxg25/yOWqqm4nnHFC0m6Q6ZKdPw1qrWkFMf9RkcrWW0v5oqKh5A3WdHYAgeumseWKjf7e3RzJ4NwO2P0oT09JRz5lYb1eOzmi6ECC6g7UfRulGwvRpw3IzIiNi8l/2XAjyCjWdDAJj0t58Nbwy3azD/Edjf6pLzLYYfPY3AL2N92RMAzhHi+yXTUC09Qw9ml7CFykEUK4RxDkqr7mcZytPBYWA6Byui605gp6O6XOKA4H6z5AXawYPtvjWH6X/U4kt/kGDTOXuZ1ZGRmRHz4Og0mYIfVmeLeWfY/r0+Mbv48JWSPNN6Y0nTe3WAABzUM+//oZnVXD/TCq189IzHZAkKmfmhF9BggpOM3VWbFIXYEFPrb7E63unslT7jB+hPGYUyfDkcnZeR0Jgo/BDNY+XfaEQOMw4rNsvKNC/IlWxSYtsdSGFRJyufvOfKLfXJsN2yjJZ92pGE6kFar3AXrvzrKx8BZEArFxxaibd6+eORGk5HbUkJtAEKu5iTK0926nS6YMQtGlEDeCZWUW8pNX8xt569nYKx/jOuEqNkYjM6t/yCwnODvrShzZ5V5GGJ7g2PqWo68RAjctOQsk5M4iRAFZBk9JhU2456n3iB8scodZeCXqd2XmT5P0aXyrcigEqYJSyGbDLe4MhACR66TvOMSZgjZX32Ov2/zDbmsFsBUPiB4MIbh63onunwPhHvKBxu442KvkhBLPWbe55BC8eDXEleoJJ484jad3+KXD0ukvkCzCpD0HZ6fb7GuirpDq9XmzItIfdYg2DLUSxjH/UA/2QijRCK/hqALsk7R/sqoLtaNDE2uvF91M6t+Cw/vrPvRxz1yPPDa+bjGm
 UgfUuJnE
 WcEFkYNfnvsyf+TXPZf1FOYtLEuvOv5GFF1aKD4xgqRadI0OHwHMNfNH9iRefFMBrw12aWsedBn8U+NovsQO/dDou3KYL7HCdF2Fvec8vkNgiNbKOpaa7+3BZR9Uj9fBbyem68VC0bnPHL5dJAnyt9RAgRF1Tqwf79M0YlIoPR6F9iec9fmzVMrHYk8h16HncreI1k/y9W2AZNbY2TpijT4eIhdDEHjAvartRiJB4IvII8DgMPROZ6xp5sK710c4TOZSHAARo4AtQvGa6ysvXicskF8mB4OPW1M4uz9XJZMRxK09Gp1SKB0ir8/Gc0sPI03NKh2ygAmwjoOq4iIg3TDB4cTKxw8ZsingytgbvichuRv8kra/ynRBQ1iW9v/dZcsL5cFol5gpGTsQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20 2026, Pasha Tatashin wrote:

> Provide luo_session_freeze() in the liveupdate test library and add unit
> tests in liveupdate.c covering the LIVEUPDATE_SESSION_FREEZE ioctl. The
> tests verify that non-zero reserved bits are rejected with -EINVAL, an
> outgoing session with preserved files can be frozen early, freezing an
> already frozen session returns -EBUSY, and attempting to preserve an
> additional file descriptor into a frozen session fails with -EBUSY.
>
> Also freeze the test session early in luo_kexec_simple.c to exercise
> LIVEUPDATE_SESSION_FREEZE across a kexec reboot, and verify that
> attempting to freeze a retrieved incoming session returns -EINVAL.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

