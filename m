Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50FAAC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 14:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 317D16B008A; Fri, 24 Jul 2026 10:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1956B008C; Fri, 24 Jul 2026 10:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1453A6B0092; Fri, 24 Jul 2026 10:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D752D6B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:30:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56B101A03C0
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:30:50 +0000 (UTC)
X-FDA: 85023906660.10.01F6F42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B24F2120002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:30:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dDKmSevR;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784903448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYVYdgPS5Cj2uoeadzoubuPSBbrZtwJpYWcA0RRG88M=;
	b=RXgeU1RJkFqIRiAM9ZdvzwoYm4EzGvNWiUhtjU+x0+lIqXuL6PAukszF+NdzQ71fD3RsAe
	j6x0wxwktI0U03ZHbwUcmgkWl9Z7wXf+Pa5B6JmIInYfPyXLIcijpk1V1N0sC11AR4Z9n0
	Uho/hOtJGZhXCdcreJKxSxrwaMZ4vHo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784903448;
	b=yYefX51Oc3ihVXH0kyrB3slTmZW3dl+1PyYeOMxW2lhn+KXNjrH+w5KCbhMuErVXU5yvF1
	8rF6x87ZcdAuWoHmeQgGKwyZhjL2HBSG1a2ToBSkqJvcMa9wRjot0sNvUaiPCxitRkt0dA
	7Jr/2YErsVSE/SR3XU42xWt+oiNWCXY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dDKmSevR;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8200C44FC0;
	Fri, 24 Jul 2026 14:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77DB1F000E9;
	Fri, 24 Jul 2026 14:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784903447;
	bh=QYVYdgPS5Cj2uoeadzoubuPSBbrZtwJpYWcA0RRG88M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDKmSevRZ1b3kALn26ikXK69qUTfOdF/EukPGDEsFBDXkLpsIU+SHwpLqZsONXgRV
	 bxvwPZurbhU7XkQhV8dWW63lPFs+z5TqmX2ZxszusJOs4/BqjgYhoNvZT2/3ePOJcT
	 BkoB7mTqs0U1y9rwoqXz6+bnczcPYLRRfjXlWozjINEx/LE/7aF95SlBStGW6kfwZf
	 sUE3/hfWb5KxrOOD0FaEpi8BnaVfkF5LcnYJ43WS3yLLJM9FGEPikRKB8V7pieXGjB
	 HKlcHHc9SgOCY+R+ypce1m01oQLHwrArFzifx3UqjIIVnWVN56ws/tWW61WT6pOEC+
	 KVcWgzi+OS4Nw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: dayou5941@163.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>,
	stable@vger.kernel.org,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/damon/ops-common: putback folios on invalid migrate nid
Date: Fri, 24 Jul 2026 07:30:37 -0700
Message-ID: <20260724143038.94157-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724142635.93839-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B24F2120002
X-Stat-Signature: caji7ww6815erqdsygtn4fsdedck1awr
X-HE-Tag: 1784903448-596187
X-HE-Meta: U2FsdGVkX1/xNvup4e1ldkiCHyDfmihKubgIbt/oXffFe4ixymA5Wf+9ZPW/fMbPJTqvi9/bDhmBSXrfmUmbqRabktUsOfWoVvTkndE2UFtIOocVsUNR+RsDx69BCiX7mZ8CznRvcVaVf6p+AX3F/zu+XWgn+n7Gtldcdh8MyJm4feGL9LiVaA6+ASChxDwDzCq3sFfgctn30L3UeCZ1z8xKnVEqyWQofgsbMcKJc7AWsanebkttkl0afOFj7vGo8bxfh2TaKVZHUPKONu6DlNrMgqQzN1ugTlLxbNr1ljETB66frkO+4RYlKYMXoL3Ita1wIMK3ZdTe1WAPih2NVRypzFwgCdEClo1zVqQM3kFWBE1ctKgG3uuJNQ5Y9PSYaGoT1cWEJ1J1R0i7Wb6nC5UEHA15kx0MtjAiCxqyyAc6Gk97f0IxzZUhQF3z57t4N8ucAo8Kb3WS5AmBBAeajFkeoNb66OArF0KFpAXXtjEmQ1RW9LRnGdFm0TmS6fVVdUFxI42vUEd0ndVdOKFfbJl1vjix4iBavVzVlwmtgD3kTYWA25ykO8sYMDMIW14UW0bXxSQlinalViTQYx/YTqyMcpR2IZ7ELvEHPpptyrNuTvx8hoGnW1raoYKrsVDCpcnRLI7lfSaVS9gXRfrWqj8JGoaRef0uG6ADQm9JNlqnCrXA9odGnLPUit/5nuCRDHFuwxlFpVR5KZsEpI6zwWPzLcui/gJ2XMvHpOHUf6EzP7FFpGTpnyaL7ntDJ6lV4xswanmvUC25Evk1mIQQd6y6eCQnCOKunbbwQRQz/+XA0f4/otypCdyIJLAa4gRXtSX4iyEeRMSltLH3AxHO9GQ8omR5jZw1wOtgfVHIz0DzfQW9aj0NKG2c56gXoF7HvOqWz87dXx4C2B5uK9gdjo6X5wUUO759aV2w5HkrJP7+e+4S8E3WRU/hibgNr/wOxEZ86xfDflnPI3ucR/u
 egNEXB4/
 n/PEucCxWHXKCIwkWqJWAmeh1paOkVQpekgs3EDm7swe3BLaAHJW1/mWfhNoEguIqS//M4SELNc8dS0boUSNr4kOpKoqcnWymWbwcNwb6vEw42PRZgEz2jywnGtwCXJN+3jCMV0MhfvCg1R3rRpGraJ6dcq+gWsF/V0coesJDP4upGGyGG07oOUT68fEE2hnREnMcpkQcZCEseQWvGwLoCb5K25Oiujn/s4FTsKfCendyROSiH8TGbfrQnaM3qfrDy8UfgvZ1z8aBN8kAz7GxxtKZvfxSn5+zfpt6fx7EuXVFF6ZTJItFGd9NJ2terigboArThshsT9lptJIPp7/jp0j+g8eIMzeUIh3ac9MKtH0q0PU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Jul 2026 07:26:38 -0700 SJ Park <sj@kernel.org> wrote:

> 
> 'checkpatch.pl --nogit --nogit-fallback' suggests adding below recipients.  I

I mean, get_maintainer.pl.  Sorry if it confused you.


THanks,
SJ

[...]

