Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47D8CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 16:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276C09001A7; Thu, 14 Aug 2025 12:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24ED1900172; Thu, 14 Aug 2025 12:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18BD09001A7; Thu, 14 Aug 2025 12:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03FAD900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:28:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7EFBC13877E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:28:36 +0000 (UTC)
X-FDA: 83775896232.30.D960FB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id BD4FD100006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:28:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BweFnuNU;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755188914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=co/rFVa6Oo0N8ayCf0QxQyuA+2AZ16QJPpbuPgrg/R4=;
	b=YvXAftoRYlqTy9xnUIo7qCIjhtZ+frZi8OCqU+cHzViNPDkmaAL1kzrHLtmHLp+FEd/yHT
	ITBR3dsx1ldFmRDnNzygtG15d6q3pVmafDrZ0WmbwqYNLeK5/0rqhh2tsNuY2QDiBVC9q3
	E1MdQwCUDbAv6l53sO9mSdPfVccxDoA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755188914; a=rsa-sha256;
	cv=none;
	b=TxFWuQYv3RvjVvry3J5iItOaj2U0Y1Ch4XcctPodXUQ+3OvbO79uXjVA+qVuGF/f5OSeY1
	kYcREazKyhtjcW5X1pIaORLx5X9Ui9m7pHQehxRAb089hni5mMsmaKVkEolTH60mndKtKw
	fbBcrl9W1gmuNERJCGDX1+vJ/cacqnc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BweFnuNU;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 45C6D4515D;
	Thu, 14 Aug 2025 16:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CB7C4CEED;
	Thu, 14 Aug 2025 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755188913;
	bh=qqqqhwozdCdum/ULbTBpHpXIETkNzrqeHLjyeJRP7wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BweFnuNUx8YnFSQn1f02ZMTNu32wJoIroLq+nRjjVcGtLqQU8QI+s4xxqbMwLNk3M
	 CUFJXCCVM9bWcYzDUXKfIWlzJ3mLdi76diaYMPzPbQsO6GTtVLV53/cSLbkDQ8WlO2
	 edpWZ7q7OwLWlgVOG+qI/dFuU340KYcgkhYaB9eaB9vEQtJ+ZAOt6KxJPqHxTPiwIR
	 d1+M1IPedSwcoGLE6N4mOuN8fYibmnPeEN8faLxeiQ56c300qjvmBCszjF41j/OiIY
	 vvDMSNqHMpa5EZbeRNwjCoiqYM+/HfV0ASBpeFPdI5ewcXKiU63whhTRdNVMCzfVoH
	 sNhkqG3eovwMA==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] selftests/damon/access_memory_even: remove unused header file
Date: Thu, 14 Aug 2025 09:28:29 -0700
Message-Id: <20250814162830.69820-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250814125417.659937-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD4FD100006
X-Stat-Signature: u98itpg7pss8npa3o7dy4h9o1huim6da
X-HE-Tag: 1755188914-614646
X-HE-Meta: U2FsdGVkX1+yX17hALm0mFDi4sYloPcmBvdK9DzAwajZphU7A2Epq6eZad5qgH1jBYNlApShbNuJik48uMBMl3XLW+96pZNpAVxEWkbWdaYuPz359m7xORXNRrtz4XZo7u7qgRWWjNRaAiH6mi8PlHGW6TFkgbrzWYA50pX4Fr7XO9Py9obPOfJUBPMv2iQvEm3SB9sL/+I1EiRl5vo9IFBTR6nwx2mxfnuamGseSihUCJd0+dnkHTouG4BDwL+/gB/sw1g/wkpFjszz2A4YFwSsIBJP9Vp8zhBigBCepjBUAUWAwVJ7cBpQERPG7qpmYXjIA86lCzSLS0+IRABTwO3x20jI5PvxP1TIO+KRsU0HPWKEPIwzQjMqxO0dVAEDKxPdr5iVsSwkn09Gg+b8262L74o2NL8VLK77egzcmbY/sAkAaNM4ucfCQNqKsdA531pFQne+IT6X9uht1ImJnnKWTeVLDkPIfr2aokv7dRWAG1j9uQPpwoZAFLGZE6dOCfJoCYe2J3OqLgJZex4PqSVsHRAgEWCrqsh7Wp+9CUvzAoPelPKuZeoi4qzBNxBq4b5jPX9pxuK78vzkAbBr4UIw+FrVdJCNu6Rh0ZslnGB/gPmvJe0ik6VhU6RmKVET8SJR5ieRrEt4tc9Rse+F0ljalRdILcd5GUUqUyYxc5CgIuRpuvb5fWUvFIheQOd1qdIX7RdD8KwtFhcTLsdgXK/LmtTCVCRr88gyUKEx9SR1DLzUqUeMA2f1TXAYJngbcqqTt7GJin8zzK5lwiMeEShsFUfBEREN+ZMBOKHtXApOl6Ghfg6DSTwsWcNazimVDV2PQM4W9/IqHhJbbs2vT5T6E9ogMV8u83cgc1ID0oU6Eaoijw6OpSaS80/y/zJF6vs56kO/adT1Sd/PckbomTe5mmjRHvzUDGSaj1UA1WiVVZAml47eOg59Ygw4hc6Wn/iwpN3uLFbn2t+DqvC
 h3PjOEux
 i9KkESxkgtK2UWQ6OmVXPfwSrRKLT3OZVpeR4MSMwJ40pU4zOi78g33if7GxcP0UTYrGDe3kU8jCSbyC6aZBsVypIs4/xnBVu4zc5U1W6QTNMbUXiKIT+tD4F5oZNtpf6rYOqqoGfKY+dGRiXMah7PbgLVodAmtmDWhrwuXtnmymGTJ4iGywZJSMfwPqFRIwAEtUWGo35omUP1Fm074M/8TuFA0r0enrKUaraGVmj2469l/r7PTcrS/ObbcUyZkxY9gC1xq/HjPseGAKU0RW6RiWwfiP/QL+FwkXyQ0+AhJmr8Nv7vS5Xdvyvyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Andrew

On Thu, 14 Aug 2025 20:54:16 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Since the time.h header file is not actually needed in this code, we can
> safely remove its inclusion.

Thank you for catching and cleaning this, Enze!

> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

