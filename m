Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53BA5105F787
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 10:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8D26B0005; Fri, 13 Mar 2026 06:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856D06B0088; Fri, 13 Mar 2026 06:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7301A6B0089; Fri, 13 Mar 2026 06:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6128B6B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:01:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D4FD5B7E9
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:01:47 +0000 (UTC)
X-FDA: 84540598254.18.AA2068D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 785A6180005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:01:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y/gC6JPh";
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773396105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7LsNLm8V1LNKM3RNu83Aj+OCZ8LbzE5exZLbnQQevA=;
	b=K8rpGJbcufFKcP8jPRLE6/Y5Q6XfAPtbWV0yJl8oClgTWAqT4f3VI5LoMm2/lIh0JEus8d
	BknYGFb6b+WVnx12X4i1ncs2SEgajrZ8DL0hsIQ2vWXI3CrP9zyxuT2s8l3XKSIY9Ek7hB
	W+pLtfENSyKr1fH8VS39t0TxSDd553Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773396105; a=rsa-sha256;
	cv=none;
	b=DAU82/MXM2VCE1K2ypLAeD943I8339Og9w1EviakP2Fu/G/EAeTUK5pRe6SlvZ4yxt0d3P
	WgCw3O7JWNScCH1ZuoDEJ4URIwpJC7w8+09yeu3Vnr0SEzYSvfymE4Vb6ggFnWzXRLZ337
	kQVaNR+liXeHCHisCSN6DeW1NMl7ja4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y/gC6JPh";
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D0E636013C;
	Fri, 13 Mar 2026 10:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FFAC19421;
	Fri, 13 Mar 2026 10:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773396104;
	bh=OIFeikD82nmwD3OmN2AOXV+pImCHdvGmD6kzGbZztMM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Y/gC6JPhy66S1xqzXJ3KdEefi0wYq8mOdiHoWgx2/FDpA+nmJuZ/cPubHSwIx8sZw
	 Wfgyaa7t1krwXHYK73m1pVtjmfzmB5smo+c/GWzcfI/thdsEa/RuYE5rzJGI+ZZ1IF
	 6/HDCZreZCUQEJ5jIC5wkDanWpLDHJteJ7TjsWbo5/yfyyORHttM2EP6YCP55BRcW2
	 gtZNGo6jmxAhnJFDrUkKymFYGdwI+b5IhF/MdDaldEWbuWsRJr2kcQLVwHV98aUKVV
	 aj4ICSIaxLUTS0gYgWhQ5fPtrjN2/wiU1tn8X/ZXWEMsWiMp2dkOkgJ3KsycSJO8hX
	 fq7dpuVDt0sQg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v8 0/6] kho: history: track previous kernel version and
 kexec boot count
In-Reply-To: <20260309-kho-v8-0-c3abcf4ac750@debian.org> (Breno Leitao's
	message of "Mon, 09 Mar 2026 06:41:43 -0700")
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
Date: Fri, 13 Mar 2026 10:01:40 +0000
Message-ID: <2vxzqzpof3p7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: o5cnd4crgcxjbwjcibqgupw3bbnedp93
X-Rspamd-Queue-Id: 785A6180005
X-Rspamd-Server: rspam03
X-HE-Tag: 1773396105-852789
X-HE-Meta: U2FsdGVkX192FdS2benh1DcQj9wN54zzNNUc5+8l7nEFV0tQ/sm9Himsc0Lizwh0ZM5seklSRZIrHOG+6k8y1Pna12dS4mWLqOXinNksvq42IFhdEHncGDQKDhVPzyqcL6nhWkR/4vW18UAs+Og9vEQBhN/JLRaTY9l2DQaDUHZfyxZ0uXt7KZ1ggEz12zxSmX9xXHlpxCTD/6y8eD3Po5/2QTIROlZawX/3jpCmXzVsRFsFBFO5gLXophndFjNguF8IopDf9dV/KzHZQMoT532YQv5cV14mQwTTziejbb46B9nSBD5Lgg/zNt3prIo6m+57tC4+D1tSf/uvX+4CHYVoaFTZLko8jTmxL+7CgYXmzobygBfLf8Af+lXo1Gn4VMWnJW+L2kODW1BNNfuL6u8Bc3Dz8COedZcCPbWalV5vCKEb5UzBw/XTI3erihooWPUl1+Iksw49XtBOavRfm0P73eNbDRcQl02EiktLvX+wxdeAqyCq8LJnjGWNuzrLDynZNfF/gdKchPnxJ0aR4PqmblYQtAVaUrXew9nlSbG2Y0vV56UeM0KIxIlYh3xANBa8cadwpx7Hfb3aY7H3CtfX9XnHSNRwpSwDhjljqjMqmU3CbM8qzHxBCl0kySGnX9UZL2S2FBAPbcDgZ0EcKwSYKRpe2qB1IAcGtvX4XhmvkzWLZDxfaVxkhn1Cvx+7HXVMNoFR7115wsePLQw+jtImfGXq9IT4/H0IYGW1csnV9GMabiVDop5k+4XvAlcarlCcVYQI74KQBkDrgJJ54XbPmG/lZMNrsSLwKEwSFWh4WwCDz9Z19lzvkqFhYfgJk6kSUkBmWnnwlNVSeu2+N7ltMDubBkROqjHjKnPi0F2xTc4QfqdaJVWHARLZkDxy1nEQRtHfSuhDhkdPT6CM34rXDhWmoiZtPvZPZ+mEdmFDzajOze6TWo/Lc+nx7j9fRVXZqmjJtoNpc678quS
 m5ctm9Fa
 /Uq/tKezZXgvvGgX6mv7l9sILWe2DA58TWJshobn54Q44cwMac1klCSfvPDhni/4tGi6byzzTDovzGowqIbVFqDekCUBh0kEmrJa9pYmzGgVteNfOqwUWsTHYpDHco1+ZEnZsHrE9n58iZrQe8ksSrVXAjmJygvj90pfHURY2QC2Pxwc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Mon, Mar 09 2026, Breno Leitao wrote:

> Use Kexec Handover (KHO) to pass the previous kernel's version string
> and the number of kexec reboots since the last cold boot to the next
> kernel, and print it at boot time.
>
[...]

Thanks for cleaning up the KHO infrastructure. It is much appreciated!

I only have a couple comments. Once they are fixed this series should be
good to go.

-- 
Regards,
Pratyush Yadav

