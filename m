Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D6A5CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 12:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6534B6B0088; Wed, 14 Oct 2026 08:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A296B0092; Wed, 14 Oct 2026 08:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540CC6B0095; Wed, 14 Oct 2026 08:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 352E86B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:38:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE7EA80501
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:38:55 +0000 (UTC)
X-FDA: 85321186230.29.D8633C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DCBE140007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:38:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JuddftiY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791981534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNrAQ6d49V6G1uyJ+wK9v6kJSn3X9wGyuhIHTJEV87Q=;
	b=hfAayRE6LqWnn8skwXZu76+ryqJUvqfs0RhQtlSpvUIsYAowFCh45rXDlRybEHpmdEAOAC
	m9hiqI0BW8SWLk2TtIiWVz8/lbn+urDfFZcb16XoNM3z2To7zq0RknHh+LewaAL25IKQsJ
	OYfKKMjEK5L9ibTki6FxWIRqvRpnqjU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JuddftiY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791981534;
	b=EZLe2/H8uO1gIxsDrvqOOzSbUGJ1+5Yin41RPZUqsj9vnlbfmpFw+FTgQmqtosdg8Qf+ti
	fMOLVL+nWyaFdROR/GTjZOTA0GSm8nzO8NWJKH5CByOkWrBg80/7+tGVzUPVDQKfCLbFXj
	lEEedJ7DpFZMzL9u42PVsu8nbU1qCFI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2796E42B80;
	Wed, 14 Oct 2026 12:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6D41F000FF;
	Wed, 14 Oct 2026 12:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791981533;
	bh=yNrAQ6d49V6G1uyJ+wK9v6kJSn3X9wGyuhIHTJEV87Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JuddftiYcMrL1Qj6zuwYV9QaIskCLIY2Jn8vWKnkgeXQt5BKEL/kGuhvVFyburuKs
	 rj6ZbEkC+xk9J5IiEjCmDMzgmKxwPa0/yrbmDF4q/LG1jA8bUZttXMuQKcsWKY2a8G
	 axtr5RGQOHawyjHEnm/+BHg2i8PW/JajrAfX2dRiuic/fH/KQ0zSuOPfIOuGX5owpv
	 iBSWhPRPMzK0HdDYuN835qIPeVokHvCrVoeNw5EDIz8DkXoVazpgvJeTJ6OAPRVyeN
	 gGrfsg2J6DNjytX8ALsgNOJgJv3Ao6nxFj6zH3BNLoB2wY+WPSsVRWe1932hh+QHcL
	 3TZBeBxdETm/A==
Message-ID: <b5b2e72e-496a-4756-bdd9-c83c78b3da89@kernel.org>
Date: Wed, 14 Oct 2026 14:37:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/13] mm/collapse: open-code collapse_single_pmd() in
 its two callers
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-11-kirill@shutemov.name>
 <b2133cff-ce69-4a45-bf33-c44b774dee7b@kernel.org>
 <ar-nKHZ5hlbsXeFP@thinkstation>
 <dfbb4bac-0def-4e1b-87a7-91c9cd91349e@kernel.org>
 <20261013143839.832f1a4db51f801a2b95f850@linux-foundation.org>
 <3bd88620-c245-4fab-abb7-9091d9a1b649@kernel.org>
 <as9cHpbmDm2FzJai@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <as9cHpbmDm2FzJai@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DCBE140007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: q867xmakf51kx9pa3kfgktnmsqaroc78
X-HE-Tag: 1791981533-954366
X-HE-Meta: U2FsdGVkX1+PSEV5/7MFBhbpJIEX4Ml3Fn+qx4okuXETorxLuyQzO4IV4wS8gZrv3+C40nHRsGz49CcivKMGXmud7ko0KSUeYexA4bw4GCWJFjitQQuBCHl2mCW7cJgHMaVL1qlr1TYt7DAAJ+MeUt/UGvPGMeQKpDx1Qj3QRPy+DgeFmtXLIfcBMX0Bk5sHfP1NM479ATBa0Z3WL1T+T2Yov7mX0HuodWXy6pHmrxUBWsFScqLXq2rWBHbJgGKDAv1M5LDAEZmwfWi85kYCDtW88/zzEUsEeQlkTZcB4CreNtFdUm6TBNgiwnTn3z1BSH9S4NYAy3zYFsK9iE6p9aQ3DEeWrWiEJhn/tUWuPaUaYsiR/kSHOkuCwe4L8RItlmlWDPU++Yzb1TFDo2UCwDVYPutmoiGZzT4aHqxQeiuxDQH45ldoGV11D1aPvonresk1SNPnI45N2sXz3RVtrUzPGFqyRoi1kO4fx9Tqs5jssrt6rXBRNXD7EX2eHWEw3i0pXxTzvY3gATAUQy8TSpC6XJLlA/gBa0q9fxo6pPMeclnvg/on8zcQnV35Lstk8qBk05OVyEME2aZiGLZHn4UOe/PzruYUSDVzv+TQhiJR5FHG/7avj3u+8wkkH87BWly/BW08LhG/kiLyYSZNZ2TdIEMBRj7HN/yyV/RZ7Vn8+Wwlvh9Hgst1o5Cy5ADauJ23rL9q8ilfVJd/99dKFJscz00Cz3snMXo1Os3SOd1ESX9worPBB+YDOIA+yF2x8nmK4Go5kyMaqNQrlQLGJgTlYUc0D/+DSsyIqQJlBmIAfCQ0Ip9PUzj5tjTW7sl5Q0pXmPrH0CNFsRjaNb9rIBwQhR1IajXhbZGsuaO2HCn+ihC4BdyccJtPI4GzDVlTyYysG66sweNvfqX84b7/LMZXCosvCsKYmXdrvSHG9ERNZ+c+Eoj6HWdz/sGhUeII9naBE+qArvCPbLr2MM3
 yC/w0Rx8
 D0Q3nLjup7baMVgBCJ4awVfJR2pUNBNhcwG84wlir55+7vSqULdxSQc55BnSjXw3uTi33PiyXxCb6VK+xw2e6/+AwocEg2jGMMoabOIOMWahbetpIxkRmlPzGCYBOhYqTlaKV7tkjnV6jQ1Wc6jNFfhbA0vUG6WMlamKVh8KopE2LjsM+JguNKCvW1dP0fg5Psoih+7bakvf0loDUJzWL2+TE5pe+HzKEscAebv1g7EILp7keos9IpTjXR/fDQRZ9QMKVrXZ2vmvRYoougYjryvtxm49MwLrUzD1y+Eg8EMCIpvEGaNBdlrZUcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 12:55, Kiryl Shutsemau wrote:
> On Wed, Oct 14, 2026 at 11:33:46AM +0200, David Hildenbrand (Arm) wrote:
>> On 10/13/26 23:38, Andrew Morton wrote:
>>>
>>>
>>> I've suggested to Kyril that we park this series until the next -rc
>>> cycle.
>>>
>>> But I can bring it back - we have a couple of weeks, three if we get a
>>> 3-week merge window.
>>
>> I'd say we move forward with the uncontroversial parts, and keep discussing the
>> controversial bits. Either these make it still in this cycle or we'll simply
>> have them for the next cycle.
> 
> Agreed.
> 
> Andrew, could you pick up 1-9 and leave 10-13 out for now?

I think #9 needs a resend, right?

-- 
Cheers,

David

