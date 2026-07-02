Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23844C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF8796B0122; Thu,  2 Jul 2026 20:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83046B0124; Thu,  2 Jul 2026 20:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21BF6B0125; Thu,  2 Jul 2026 20:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D74E6B0122
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:58:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC3E112019A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:39:42 +0000 (UTC)
X-FDA: 84944397804.08.6268A51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 281E3100013
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:39:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j3CntqjP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783010381;
	b=JKiA9xC79bjTRZHbNELtUDITPeLf3/PXv4nBm5GIRb/1qAVMJoAvTBdJP6Zd8C0anMM/vr
	CBCsaretJLY0aVP0f48jFLNrfmcdrCPhQ8/Emvt3CqrpZWf0CBZDb+vd7/V7FuJxqPTskX
	27LX3/xq0k6XZ2EMab+3+4nvkn7TorM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783010381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3U4Pu3SkeAaU0OMoDMoDHcyux0m0zke1PXLSBG8YI/o=;
	b=MxTKaPQdHRSWAwTIsQdqFuCRD/YX+jctDs0kvMOIncokDxX7W2z7MtrJ1EVed9xWScO+CY
	LNspwwQCxS1RuYlfdhIz9pFS4QE6eAjM6nnANGR0eY2oNDI1/ACHwtJCykIqW15EEujH9C
	N5Lu/8JLdwmCGS/r0YSOJNMhaFsc278=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j3CntqjP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24E7B409A6;
	Thu,  2 Jul 2026 16:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D38B1F00A3A;
	Thu,  2 Jul 2026 16:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783010379;
	bh=3U4Pu3SkeAaU0OMoDMoDHcyux0m0zke1PXLSBG8YI/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j3CntqjPqMtofrH8ye6WRIp8cdPg5aZaX9MVSC6KQRKwqC+/r73jfrGirDW4Ov5BX
	 MSbpLqCHbK1auotjClbW6NpXha6JiebYg0gyNHW1WpvICHkGNTLdJZECgnTyIi4ZPm
	 Kz9yaVRjXzK9gVbXKz0NNVSqBEYYJ23q1YDWrxkHAURwizXXttOohahJD4ot1rAWYo
	 utSCigkNJ5Icp7wy988bWL6IZoFhsdnk3Dvov2Z5LVfClibCqN7WblbmbwmzbmfjKH
	 JkAmC9DXGvQEDflygr9xGJOG28wgaA9Oc1ext1jtIu/LwBf36WjSb2twB1I8oieZXG
	 HfM0taTXs0qaw==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	lianux.wang@processmission.com,
	kunwu.chan@gmail.com
Subject: Re: [RESEND RFC PATCH v2 0/5] mm/damon: add mTHP collapse and split actions
Date: Thu,  2 Jul 2026 09:39:05 -0700
Message-ID: <20260702163905.86497-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702095227.75866-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: dgjrc7j3zkki3z4yhy4urccidawxdxrc
X-Rspamd-Queue-Id: 281E3100013
X-HE-Tag: 1783010381-630718
X-HE-Meta: U2FsdGVkX1911EHpJhem1cO5j/cs9kqSfNilmoKYfc8Vl4RFQA5qcycKwVzRVtQebR6ovlxPa1aTMGjqSOiaiBb/T2ADAClbElZXSlgUDqejofIGP5v6zDc41ghktLBCUwIjnPvL9NDZN7Uhww8sO/jI49TuslyT9kUYjKkABOrc4cvU9vPNM4uNfqylM6/CPh62dAAcoyxdSpfDyabMwdvZN7W5/x2KB8/ZjTkDyvsIJPlf9Cv2YWua0H/dORc+vq7WZ2aEndTfS/FQLC9qre8bVmavuq6JJfG2W8VQSlnsX6Fn1iijHT24We0gRUVYfeB4R19KFLQPjPq5EvKr7DLs8z9n6XfqByDpIHuF6nB6/SMYhzSIo/69bdmgIvxCDxyrfiuPMhmeEYoia/ZXt5tB9nov0X9gL3QLC6ke6DDZyNLYLiDLa4/aTnPXPt6D7s4F9AkrxDNO7mWxOhCnyThQsJIG7w2WjandUQRdwOVtLoHRhx9loERCtfkZ8xWEaW+zehaOSkTAsOhASqGLmLrpfDt42G/677msU1oJxYeHL5u8nvdVQkBwg9iyjwN99GsUnffb3qt+d8gQFaqbYGfTU9CzI7jX7aKDHmwY+zPodKNPfvtY7qwqpx7C5FUYHAMdC8ryUPGcQRHooHRt6GPaA2c8ZqTDPLvCgBo7wkAYr3Hlxix41R1XRRTKQ5NLdo7JYO6bfnK/o9t6RmKo9zzWqIgPneg7ACGoGTrHCngHN3dvqEpbvGlwnjZRxIh7DELtJqXCy4MN7sHqFT7N1bUz+Kg5vncEriPi6QA0OKDHPOS2pUwCnB1DV7dHn0I6QkgG5YlJ+8inFfr+ypCnDqcFnjwvHOK58khiVAwnk12LWVBRaJHufVvUQflNPBXH4P6PfQySu6gMPuJxjPtcZV+AVEuccSL/ebdktmw5Kj+v2LYtvQYmu6Fg+2FCvByjFqI3lnvSyNFAsu3QTwB
 OH7YPBD+
 C2itILQWDXpU6GqSRvrOfgZ0Xz2WaId/ZFJ8/OscjE994PiT4iPVoh+I6C+eA2Hrr3ocCgESjwPRKu3LUPi7JSjTrD5iZ6QCDHgFSAcq4dogTdWs7CoPpgxBDkHV6z9K6nhCMULYSOgPoCDtAM0dIHyizOEgtIWhsBEJJElddo+cZwTyb9bsC1aTNoGs2LFgUCKSuYq5NoCDwRcWtMyn8eee6Oj5Fkp8qg6v1pn/TmuED48w+oun3KhLFs1ssFz29Br1gN2Sq3A55LOFOArSAoAWJwHMFrx6JsvhohW3jxS2zlOBAV6TH3FD8sigTvjxV9Tb7Yrh4Iluz3HI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 17:52:22 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> Resend of v2 with the RFC tag restored (v1 was RFC PATCH, so v2 should
> be RFC PATCH v2).

Somehow you sent this twice.  Maybe your email setup issue?  You also replied
same message twice to my previous comment.  Anyway, I will review the later
posted one: https://lore.kernel.org/20260702094633.75658-1-lianux.mm@gmail.com


Thanks,
SJ

[...]

