Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C56A0F33824
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93BE6B008C; Tue, 17 Mar 2026 05:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E44B56B0095; Tue, 17 Mar 2026 05:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D823A6B0096; Tue, 17 Mar 2026 05:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8D6D6B008C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:51:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 958DB1B8402
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:51:45 +0000 (UTC)
X-FDA: 84555088170.11.CCED4C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BA2ED4000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:51:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DuF7/B9n";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773741103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMJ/FnjYCpPiRqVs2/ykHGX0CdIQZxCC8Jm3CSwmHpA=;
	b=AjFV1R2tiXZ8ZTxucTZlGNOhRv3j+PkHykUmm5ik27R4bBPRLcN2NUTddVg+BZWihoihVl
	uM1DCoaJzMXOzg2DBbEFy7E2Xc+T4mEbfs3wAjhcIJ37u5mHJTDdH2FI9i213MIp42ApPo
	nXeElNsueWps/eqJKDwyokINSpAjSjg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DuF7/B9n";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773741103; a=rsa-sha256;
	cv=none;
	b=DS1x9KJSdUXqt5oq4lYa1738wbQFJTblLID25lwNxHUTn8cmrQVRgsksoCQUCqrHtoHITt
	SgmMigCe8FgTiK5enWMf8foMe9tydRHi2pJrGZA2YbdzAgQfB/phmVPGG1hV+TU7AzwhRb
	cTW3MJR8V07z1tt+xe02QXqSnGfRMvU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA05840314;
	Tue, 17 Mar 2026 09:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929A2C4CEF7;
	Tue, 17 Mar 2026 09:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773741102;
	bh=MptDcfDk7sf+wrJpYNzLCkpJw1uZgYORXatXpa24dPM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DuF7/B9nlgGloeZyBKf0CrXWEpvp5iD/ynlw0wCoFnypuj7qZz685KJKSVZAZKyBV
	 q4s/PSa6zUA3dziWsC6cuIy4XY55ULOPdzWQ3L7glDS5m8ZyEMj0Zxk7A1RFl2NNph
	 R/aZpNr1z5oBKGzGRsPt7RE/gviG/5343D1I1E4lLH2mi04SAv448fHUQ9e6T/6/7n
	 LvqwJi5glWLE/4gFzyzz1kTsPp/uTMWART2G7+8uZoNyPCi+oAj6Ff95TcWI+Vr7No
	 rCSv02wwsHmK087SJnbBEam1+Qo4bKFNjHcoMSuCcgFpuwkWKFqI4ZntqwKtis6aV3
	 s6DhlKaI1bO1Q==
Message-ID: <097eb204-a665-4f88-b4aa-eb3f434f84ac@kernel.org>
Date: Tue, 17 Mar 2026 10:51:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] mm: list_lru: deduplicate lock_list_lru()
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed
 <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-5-hannes@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260312205321.638053-5-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA2ED4000E
X-Stat-Signature: 8y1ca9515wnu1pxx5r3neocf5e4ncdte
X-Rspam-User: 
X-HE-Tag: 1773741103-359186
X-HE-Meta: U2FsdGVkX1/I882AJ8T+wJfBmBhsqDLlo0694RXGAemsZEQu51XGjFTSFSaY5lngpWEogB5z+qPxIyIuEuY01KEPIBZsyftLKl4DXD01ZDfkPth5Jvb6oo+O0JSLmegkoXn99h1igVFVczN9iGvL+c30FEahf0+xEbplU0kg7CeuYubchE4jbreqH/+tWDIjHruvmP7X5D628cRjO3tkXww2WNBMBUaV9AT0awkmxZujsZMKTCJSIEO2hvqRV/7C/DpjE7+aRzaPZWfe8R+kNpVSn45YPem1soadh4aFZFjcDK+Ji8y6CKZNlRjOqVmRIh0FbSaQNrivQoHVZIWRH7oziLafbqhqkTo+/uYaecGbMe3F7AaYHeEjOglLO63RvMr+vIYRFEpQteF12cltmNOl0AclH1yZyDrzSFRujde3dJzLXtZ664yTrsrkgY+bz1hFGLbL17HmyKLFh5P/8ssf3sE8d69/wJnQHLJpe2VX/YfMppQo+aJYTP2wIzOFgcQ8RBShjl1izfacSNdo3/hqI7i4GDATlCNw7meODLPp/pd5Vh7V/MZlaDmpJU6M07D+CWxSfiFkXbc3c0jkWVCK6RikOMt+y1WcD0q8j6uRV79B9Coysv4bZjLD5DoLbqSsg8SWbhG3Red3kVVYqoVvskS7Ko6jkYZWBSV/64/46RUr17JEOg5oW1MUnCp4nGHfGFrrIXqzbwHDFWznyrQhqNYwCBfBTAdlUtWsBALQuRo/CEM0B6FcAncRgHXUybQ+hC+LSFygnAptS91+BAQNh2I0gBZPCO15z35I+oUe//H4DCOX9Lvea5NeTchYuTpEEfotqd71xQS8Oz1O3p3tnyHnULIVbDJ2Fer6Gg8uTIsy4dDoyzObs/lyN89N8YrgPv7PtExs9kHqoQHcfhd7dVqvoLw2S3PJ552e1mGZWE8pDZE3Cdhu5lJC3o9VEDiyS59QJx5f/BHzwPM
 VnYFQ26q
 /Onq5qQLUwNowMYbkEzftDVpE/iwO8GdqhUdan+pX1lSFnKqCOQNZrZ26VFsWYQrl5eaewL2rVTx32fZ8kdvyQRYtnkaR0QRyGyAJr8LO4ipys+X/bGRAJRu4dL2ApiQ9CXRT8/XprkblPNRPYMvX38CTzOsLggZALmf2ACJonyHdhuiQRofvoEuBg8g5rRAUM4hQtwoTQ4gisWabQJ3ZCneUljzWdF6tFnsEJ2WLQ4Tg7zM9UZovIcWPgzHdJys48B5QmQsFL/6xFAbGmc3PFunYS8FmEoiOzTbUDjMWYf0t3ELhs0/IkZQW2HQ/Dz9ZDJZ8/UAZ9P7FqExtyYITLxMQgTi1eqYKGahbVulF6hLt2DgCRbiMPc/MomVQKj6Gaezx5hVqyJGmf7lrsOfSMQQ57i+FapBYvf15
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 21:51, Johannes Weiner wrote:
> The MEMCG and !MEMCG paths have the same pattern. Share the code.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

