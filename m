Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FDAD6ACF1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496F96B0088; Thu, 18 Dec 2025 07:46:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 419C66B0089; Thu, 18 Dec 2025 07:46:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326656B008A; Thu, 18 Dec 2025 07:46:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20FC06B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:46:14 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE839140113
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:46:13 +0000 (UTC)
X-FDA: 84232564626.17.BA12F51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 147A980006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:46:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ezgF0/1r";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766061972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvUaaF4PoaRxCXa1jYemuPHHcilWp8uuBxoEE+kDKPI=;
	b=pCxhyJb9RgsDSt0YZoogffQo5w/aaGPrg2L62u192rKAd4oB1Xio/XrsquWvGfluga8IHJ
	aKxPRomlezCCPX9hr4uA/XZxLsXjglave7LpWJNwoGsT1STl50Ii5yZsSE26c+ExK+ZZRw
	nZcY1XmqNxfoVR2xTR8WyKpnqLVR5xY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766061972; a=rsa-sha256;
	cv=none;
	b=r7i3boiZNE5dfDhHDUdFqG6RO73mkbmQuntjZs15DMfUK5W6i85Kt6QkluFmEFdjlLeF8b
	MKgK3m2qwopGFGh+TI4jlbcKoUY/P5dQoU6FHXF/kc4Zvw/4Y+Nw5o86mr7j9/mYQ+sb9o
	1nKfMyY1Kbj4DJAQmv47Ki+GjQwbt8E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ezgF0/1r";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC9E1404B1;
	Thu, 18 Dec 2025 12:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D81C4CEFB;
	Thu, 18 Dec 2025 12:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766061970;
	bh=YzrYTwCBCeJIPAsrX0EEytL0tog1DwXr5Kzt6L/Wdd0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ezgF0/1rzZUOZf50uOAsMcdHYRlZhlxl4GHkh0HYFRYgSD6fAHCkadQ3Aj1gM1FDJ
	 ZLfnxO3/pEbMSnVd4VC8T+09cFuBbW3biupY1cjHgeDDvpLEk1WDcGVmKgpYe0++bB
	 EiYvqlT3P36M+ChHCeSlEkPw/t8qlSUQT80+rOQI4c24wJB1pEcdTGwNFcQrHrNNOa
	 D6INYnPJnLyKejNGkxYp+NE+AS/6ZZ0W5N9o3X5aRZxsAGpz4KbKXBf8GCML+i/Hn/
	 IgpentS+D2hs+G2Fq3Y60JOMlpdmrDQDx7KVqUCN4RM/ixCPNZaWGj5sGfIeELx12Q
	 up8PbPwefEdnw==
Message-ID: <f13ef321-3987-48b5-99f7-5e0a12e2ad29@kernel.org>
Date: Thu, 18 Dec 2025 13:46:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Correct minor spelling mistake in huge_memory.c.
To: Kevin Lourenco <klourencodev@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com
References: <20251218112016.9613-1-klourencodev@gmail.com>
 <0544a9e4-bfef-4af8-9f68-a5aade840adf@kernel.org>
 <CAFveykPV1ZFWWgu+HK090njGoMDqhH5SAd9EmG-+VO9a4vLg4A@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAFveykPV1ZFWWgu+HK090njGoMDqhH5SAd9EmG-+VO9a4vLg4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: axx1js7x6h959gy8ejcfrb7fnoay7xot
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 147A980006
X-Rspam-User: 
X-HE-Tag: 1766061971-746250
X-HE-Meta: U2FsdGVkX18zloiEC4JuB36nxRAgX4m42ii00oveWfzltzj9ZB1kSxWywmDrRrVUNCDVfmZF7qfd29po/1DwCfV1TCUV+qF6kkeX522XCstzgl4n4TDsN/uAEetNeQtjRuLqcaxCMmYlcTB+rH8d83RdHpQJCTNnfmNj63aaUJbuaIxK6nCVd8Yc8tmPy4/eHfN6m9+ZfWk4TDB0lt3bkjSUoEwblfzcc30kudmNd0cTjnQ8fgQpUbODdxGatguULqWEHcpYUYc29Plm/DsBz43q2ZFXqIkgcxn3VwxQLZJWm+dN6GjPh7ZfZXSEmY8EjRYTsTZFtmezcvXT8dnsg5tPq6vnIpAgOqwiS397the0N/anLc5xfT3SL/1hmGAg2syS8VkUS4szPFT+EqvmtT5XpVQelGaXmi+gMIRuNZmTeOP8t5KbgPHCV5aMPQWEbbYGC5UWopXWqBTEX9CbSQ0l2adBqd8DegXYsHFFTJn1COgAPCo/p5IB8HKAwGP5T5nAHpgIG8p6pA6O07Pq1M0HiAPJixJbWYNEgC6STDosok/sHbiTt8NQp80P55BEgx+MjNUhiMfvmxDaOBO05bKxIa3pwjRuEl7G1jM9Y0ATcjPLiND9CCgKyb7LfJ4JxTOIcXv63V3yQisc3uvRwUu5gr83MLXHU4ndtuPGF+68h8HowB8pVT1zoMqTR/kHp1N1deDLi+bfrNOLglC9EhX5jJIGoRFnM8TrJAg0juO0OwNufgxUE0FJyFoicZayTzoBQJFy5DTqjukfhCTT9kalELrVjafD2axfCskTZWUk5hFEfpDdP9FTUV4lOpv0fZfwbbPBtT+X2uaTiNcQZsyOngHdDTTWdJsJNdepshPC4XfQ87+G8WR9PS8Qc0ehCy/GCDhsPIMPtY5Ny9nzBPoSDcIJD4qCD9yJ34AuGUygJoHS/bVMgd2u42iDYvAMK/1uZn5H/XBWVHsfsEO
 67nrpb5B
 bL1zdsxyekyEMecAZ7qSdjRYsNhua0sKITuAlgxUOD1QlAbegWztslkvxW5ZeLS2qRKGBxpNH+lfhiQD7Sk+pXwbeanHY07UCne2001qvofzUHNQMS/Wws+uWPfke6yF4/leNbljsCof5DLhnJ8ul5GhotFIr5qWJ9VamOgNQtwMPJ8tBnwKn1OE9KTVfazr7Pwz01C3ho1X41MV/qyKHhOEdB4SJM3iqj+X84hTWjmziQft/MgWxIFcZhJXvC3LgcODRPniqJ9RKJRQVX+oubKrhr8lsMH47JspM3hIE+uswLzU7kJTrfaQ2cA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 13:21, Kevin Lourenco wrote:
> Hi David,
> 
> I have found no other spelling issues. I also did a deeper review of
> the mm/ directory in general and identified more than 20 evident typos
> across various files.
> 
> I was considering cleaning all of mm/ in one go to provide a more
> thorough and consistent update. However, if you feel that doing so
> would not add significant value and would only consume reviewer / my
> time, I completely understand and can refrain from submitting them.
> Alternatively, I could create a single patch that addresses all the
> typos at once in mm/.
> 
> Please let me know your preference.


Hi Kevin,

then please send all of them in a single series, combining them in 
patches where reasonable.

For example, the feedback I gave you should be applied to all patches 
(e.g., subject prefix, patch description).

Imagine doing that as a reviewer to 20 individual patches from 20 
individual contributors :)

-- 
Cheers

David

