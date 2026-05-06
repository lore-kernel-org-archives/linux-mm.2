Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A940BCD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 17:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC35A6B0005; Wed,  6 May 2026 13:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9AD36B0088; Wed,  6 May 2026 13:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7ED6B008C; Wed,  6 May 2026 13:08:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DDE16B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:08:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FD25402AC
	for <linux-mm@kvack.org>; Wed,  6 May 2026 17:08:48 +0000 (UTC)
X-FDA: 84737629536.17.609A3A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9D91B180005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 17:08:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lt7vj2IA;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778087326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OinfjCEBW9A/zEcVntYLmeTMVufnD9W2gbv4xH5bO3E=;
	b=O7FvnwYMpv5n+BcyMvAs++Ar2AaQBB+L/K1ScTRf2Eu6ZPWesQSrNSigGK0TckKszESTZr
	gPQzMT4GmVhdWjXl35ZZB7MMXmYu7aJzgdLftbpNR9+YpjOmHcw/zPg4q1ux+yA2PrlZeg
	z+Hx14DqDSxh5w+1R8zGXu3Q7wwfLvA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lt7vj2IA;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778087326; a=rsa-sha256;
	cv=none;
	b=Tuw4J0+Jtq7W8XNHq/EtNMaA8y0LAxjCZuOYC88OyOjsjlekbYNIvN8C1ke8+La3ZEwQ+D
	9KeG51eSAnTos1CFz23mIygFY2n9MXDxh+nVx94WQxWADXmN92nyt1QDXKNUnL7YkjGJOa
	2Ms7zWlewgEuftabergV9HUbzpn6Q18=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1111360252;
	Wed,  6 May 2026 17:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6C4C2BCB0;
	Wed,  6 May 2026 17:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778087325;
	bh=OinfjCEBW9A/zEcVntYLmeTMVufnD9W2gbv4xH5bO3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lt7vj2IA+WpEvC0ZhjqIJ0A2V6gsUo8oquR3lYInImLJcrPRK1aO5F5mdSnprtNOv
	 8j2AsQjUDQvwXnWaXp/ecedUh+kX0Xq3o35LRkV1n+3On6q4OiSkFi3Vs8pULtOFjo
	 vENrnUy3lfVM223S+y/W5HdHgEd7GOzIcGmCaB1BaLuEkBsAbsuq/X122JqmkVtcC4
	 jWk+zmZqRPKEP3kLNfldshCkLMEh0ar4AxnJFduRatzgHc7DJMNIiCppTsFe51ICjM
	 2cPHpqA/Gifc6iFTZxDc1q8HgNyeFoqmGidxrtn1NI/SSSMctMspP0PHXN7MzuCzFC
	 3jCY/58CkB/Yw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org,
	linux-mm@kvack.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Paniakin <apanyaki@amazon.com>
Subject: Re: [LSF/MM/BPF TOPIC] Allowing NUMA hinting faults or alternatives to DAMON
Date: Wed,  6 May 2026 10:08:39 -0700
Message-ID: <20260506170840.10882-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260218054320.4570-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9D91B180005
X-Stat-Signature: jp8aesro558oruh7c3ayybhu6ok1gpmq
X-HE-Tag: 1778087326-689778
X-HE-Meta: U2FsdGVkX1+BaVpmEPdgYCZUSvVuRgN2NKbdafUS7ePgHmnPD8tzSytywKTxpPaHVxisXARR+zh+8r9pDoa7N1S3W0r/qJQ++D0wemkRs/nyQLKiHwSmUAqp7Ixcc5ecSFxYKd6j9yskKEy7HJGFOI1MXB9maX0iGhWwWOL6elPJ+sxbSiap05VTjGZMqUuCL4XQqySxTMZN0mN0mU8k7Wx1/TViSnXz8hXk1LAgquDf44dxeF9NFV8tSqs6sTQiFDge+AmWMpTreCtsXn6AvP7Kxqw4smpjJdWP/txxhkXmMf9NSFopnom3kB32CcksKjZCg5/eDETMkn8cShoTaLIT+uG6wC3uSYdM5J+f+xyiSErWJGUZMqlKk22zQd3tdP+KH2BFItMp9WL/vR7duD1aH17w7/MY23brq72TCVGc8IQBNWnclDTAHwOHucLKej2iwkhRNEhc6lk8BoL3b78Mn5ZhI425mSA1/CgkWJuYOK0ZsS2VxmxB8eDtwjICrNeI+pbl3vuWssRn/DdeLAeg4x7GIaOaWDGQVjYA3HOUiiVpjmhoiKUXSNx05SmsYg/SKQMcacpIG5F6qKV0KQdZ/gl+67TefYcPmjaJADcADdq0AWxTdVOBbKCft0oI3+C4oS+Xbtlkx2+UPmrkkt0y8RwmcBYn5+17BSbbVSJmvDzbZ/0GI1TTkoWI5b6pEa40xHIl9WJM9++qzewNlnGeDSQamGa1x1KCxzbLej9Xxbf+H5UV/JEEd6tRQ1Znp41ZqQZ0Ym+5RQqYsPgT96UINfMVNGSeyP/24J+Y5DYvDXO6Jj/NgBzZFN5HhL9SG8v5YZcXePALA36cMuZ3AYVpS3kOXo3xvFMDnSECPmXOH1DB3XE6wB3rUxPN8htwEdxYwZjYWTJQVnTgrzxYe+k27lE4eLdFbDYKv8R6ItLbUMi6ryXY5jdAHKXLqOuHj8rtctL4JfHnLMGLCG9
 He0T/Ar3
 H5Z7eMtxrPL60mJd0iy2MF0U6skM/OgdV+4yRSHSsi3iYefLOEKjZpWLQ0VzSrn0nLlmaYvqfJ2PHiaWH15ID+4Vd+Re3k2n4NReOLwz/k45YFqwJe/jP1g3XnV9P6gAcQUWZmHHU79+v+XdLn21mkRZY+6Jj02i/ivRiV9Sm0jM3sx+A5EZISMr/xMME94xAm5pfjrdxg/eF+fu1OmFjRHDItcADBuQGfi6moWvY2gcmFLsElMRN1sMiL8ukYyL23y3fmcmcOUevYXk24Pkc3RRbW0pwAzvrEVPS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


Slides for this topic is available at [1].

[1] https://lore.kernel.org/linux-mm/20260504070208.7106-1-sj@kernel.org/


Thanks,
SJ

[...]

