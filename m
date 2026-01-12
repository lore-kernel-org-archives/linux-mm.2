Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0C94C9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 13:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1507D6B0088; Mon, 12 Jan 2026 08:38:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FDD66B0089; Mon, 12 Jan 2026 08:38:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B636B008A; Mon, 12 Jan 2026 08:38:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E54F96B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:38:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F3ACC0BE6
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:38:34 +0000 (UTC)
X-FDA: 84323416548.24.447CA01
Received: from mail3-164.sinamail.sina.com.cn (mail3-164.sinamail.sina.com.cn [202.108.3.164])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5FF20A0003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:38:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=zr19TTnf;
	spf=pass (imf25.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.164 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768225112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCfWFscWKDhy+cPYbfvIWomaGYCmFK7y0R1EiMwaCLI=;
	b=1df8TxC0OYyTf6rSPs6reM3tw3dfRBcTu3FuJtio/ELMJ15rOswRDw7MLQdi8hma3Zb4bV
	o6WMVgVe5GFWJELC1fF3EXLZlcNlBY5gOT8WKMiBNaDpUrnLsLgMgUMb4vYYSIkIJ5bXCe
	aqalUHkg+sp2spqpzjxVKyhhJx8SyUo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=zr19TTnf;
	spf=pass (imf25.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.164 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768225112; a=rsa-sha256;
	cv=none;
	b=bZ9Y7ouB9uHnpKotT6kNkXla/4pRTL2TuvGadSdw98jws+rYN4QJpkc9NJhrI4YxY9epBC
	BCLATYHCWAebCQzaWG42BnnDI/l7Yt1UcNLxyHToCTCAgVN3A38ouCVmDunCriXdgKDzH7
	Be4gbBFo3o/OcfZ8kRA6Qu94dTxrL/g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1768225111;
	bh=sCfWFscWKDhy+cPYbfvIWomaGYCmFK7y0R1EiMwaCLI=;
	h=From:Subject:Date:Message-ID;
	b=zr19TTnfDFXed7aLMCFC7gVUzj8QcucQE+ANKd1/bUCzlucNeQrCLpFXSA8mh1Ho6
	 qzm2+4OW41VqbYwRaf9l/BGiI/u6pZwj+W6PlWoW0tsu0kDR7n/NrxDdxtGaV6UCfY
	 at/GE7uRtpQkHahHLaxbMZrq+V3Ze80U4yob7e1s=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.160])
	by sina.com (10.54.253.32) with ESMTP
	id 6964F94F000019CB; Mon, 12 Jan 2026 21:38:25 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 5717074456672
X-SMAIL-UIID: E3D100460EB94DECAB4859F73DA2DC40-20260112-213825-1
From: Hillf Danton <hdanton@sina.com>
To: kartikey406@gmail.com
Cc: syzbot <syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com,
	urezki@gmail.com
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in purge_vmap_node
Date: Mon, 12 Jan 2026 21:38:13 +0800
Message-ID: <20260112133815.2190-1-hdanton@sina.com>
In-Reply-To: <6964f35e.050a0220.eaf7.00a5.GAE@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: np59ww6au7b3wi6g8c7yq7mhamfyx9sa
X-Rspamd-Queue-Id: 5FF20A0003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768225111-983186
X-HE-Meta: U2FsdGVkX1/qNf83vD+BHVCqDEnRnBAwnbnzNPZ9pumJzteHD1Q2wqMFNeeti5uVUWAQo85mfDj9ulV3wUKeN1c6hKyAIkO8hp0esIChzU63YWius+2urWsdJpr+kEz2hCunByxS6McKEIilUdCL2dA3Ypv+3qgrlHLJrOgDDP2YA/lZoGwjq3rqTK2CdWzTlHiNwbyBpw0g2rsQKjZPN9SXaYDyDwiu9fVGQeXSA2vApw8NWpLujkNAWITSmwbuzz7ldgB1Vk/SrUvkEu0Vw5Uy9gI/k4CbHO9UcIdWC2x2Q+1RJvPZe4pl0hCOXY9fLBHW4lxVIWHqVomZybK6Q+UDCdVDmszQWStTfeYeLSKyQa7YSt8b37WiN0/NylI12mXjlkmmjQbwlPwxstyFyzQS4sjUi2ILm/oScc8mO/eMyr35Bc0GGoObtuoD7QnAHdwL78qqMaMm4/gAWSHreoakD2HLquHcJzNQCJp5vzE8OAbV/Lg51DcrHVNqmZp/6hoJJLgistxfR1u8s9rqMc9zaS/JyPxfY/Q3zOrUu1QSbFpgGc+XeUMcDEVF3bPyJrpDiLoHuDOwGuml2oPc6W4mdE90ziTfw08E5VZ5AUnfZIMTSvz1kGnmhgdHhNw6P+blT4tagQkN29ojOndKN7QlwAX4KaL8YW1WNMGTXg+27azM4Uv8lbdGo5M9ZJr5SjSbtK1MSQLVOjBWn0Kid4K3eAr3hXAwPxzMo3giImDHC4/pbs4SPs/26Q/TZtgA90rn2VCK7zWkxGxa9SCMekF5l+WTfDVJqq5q4ow5ZmvXbiN6nOr50a8dAsiIUvmWb8ZGOVca3MP+YXhnF0oE/yvF6DsC4EI04vXDwoeckGLHS90rRYfPjWu849B7QVaXSHnm4z+jqWzPNegrkrzLjk7xrt1uotz1cLn9nC4r0y+zS4tCLgl32PMQlfPLpfFU5UxVTz+pfgr96S9WAuL
 an1d9Rd2
 zOmmJ5dGsRWEbPkBglX22JC6rAW2W8Gqnpg6d87firva7TXy9BbnHaMmbYB3amD7ObIAWKVit34DNZ6Se3E+sUzIyGM3FMggngJrgwjLbek2YdA/zv1VXDLx2Y/HjeLXJlP1EGDjwIdQ3L6l089GudqtdsmIODpp3bGuLwvdi2TKByZ5FB5IWikhkPjP+xmF6daj5c8QYJQ49o2/44kBE6wAaBPDyjVbwTYvrU+R9Sin3uNV5c6Ibv9wzFiM/JUwzzLf+lmqYkPe5jiJCi9ykHLjsD0/GBv48wvDPajWQRtTVnpAM7BkWh7PlY++oFzh9s7nORJxU/M2Raw9ecnJG29KfamBBDVQHRfItGPfz1NfbYz3up2DDFMCRgr7zzqvquNthwbyt44I3x4UssfYY4nW5fbGmZ7jNbJoocBNn+YCijqhEwrUBz6U4mIzy08EIzIMfH2EMoyMjEUGyxpdwODNJmUXb3YgK+3pV4rSU9SGh5bSUinbsc7GgvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Date: Mon, 12 Jan 2026 05:13:02 -0800
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> INFO: rcu detected stall in x64_sys_call
> 
Given the test result of your patch, can you specify the root cause of the
stall reported, Deepanshu?

