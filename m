Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBA1CCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418FF6B0433; Mon,  1 Jun 2026 11:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EEB76B0435; Mon,  1 Jun 2026 11:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32BDF6B0436; Mon,  1 Jun 2026 11:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 256E26B0433
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:45:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1C87A065F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:45:37 +0000 (UTC)
X-FDA: 84831768714.23.5EF60BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 37D97120012
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:45:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cxuX6BBp;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780328736;
	b=ZUYXiu5j+mavJ6HpEZATRe4rrnv68Hpedod41seYAjo9/p6Bu9MzDD8GmuHdrZ7Py0Anf4
	z6fAGz5xMkAHTia6tOPUYLUELKQ7DxQKy1ZhiCVo5hjqjffZr1Y/pW3CKtYQQIyn2y9uku
	ZR7oUAH2QXdxGeKQWG5GevOkdTnbGOw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cxuX6BBp;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780328736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbm/oC8nM/kIkBqtYVbNQp3+SXT63KXvW1SoKSpbcmY=;
	b=oVeGdIEGt2tQC+TnohV531O7LTVJ35QhElOWrTGdNhoa7i5jFVFeKDxO88PcVQFehcme4v
	VzAoQQPTdH/+E78Ioo8fSvWTnx+G4KKs/dkRnT5eYc1I++5TMdyZyvexyxKgbW+KQMATpO
	p+FYMEXdetHxv5NDmAh7PtKhQZubgeM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5599601E3;
	Mon,  1 Jun 2026 15:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8F31F00893;
	Mon,  1 Jun 2026 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780328735;
	bh=xbm/oC8nM/kIkBqtYVbNQp3+SXT63KXvW1SoKSpbcmY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cxuX6BBp409qhCzGhOiEKD+5ln0UoZjqvT79pO87a5nOtvYGts9RsNisid7pcLb6y
	 3KNj5x83nT1Y8M+0jhqd92e8WiWl8vm3UqABY0AXwm1Z06mFw10iZI1KxNY39AFVdx
	 XX1VutBNycJ/wzu05KhsqQa50BOSRgxmDtgriFkqj4XeTVQ3W4tKF6j8xkDAF8jVe+
	 eFW+YKV2j/uxIoPgM9UkaRgcu188mF8yP4pEB7k4A3JJS6zaRXS6uWzXKmNfnzY0Jm
	 4LEqjCMcdHTpn0romN3sOO5Tooe8r2pzreKlyiRfV9oIYa3Lex2oq+CrGsC5mIgjdb
	 VAmsaIdeDY1mA==
Message-ID: <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org>
Date: Mon, 1 Jun 2026 17:45:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org> <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org> <ah2ndruO3RQGtePP@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ah2ndruO3RQGtePP@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 37D97120012
X-Stat-Signature: b75zh39ig8feimzqjbtjq4k588ayphia
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780328736-958436
X-HE-Meta: U2FsdGVkX1+MqkxxnluWMlXY95DV7cmf3dklBt9r/0QAO1WjpC2NCeYI1BydoZ0k3kphInrP5Rzyls9TsxJ/KE/CJhaT2DO9crh021vWqURYXyhHamZu1EQVK++0oFALOvk1p+/519EFuSAVFOb5m1vm5q5l3gUli8LCN9YuO+MhX7mar53YXZwgbaiomf0IKAHXmYF8WfOJouct2QeyvuqqsFdAldRiNMK1f/XimYEMAXvlmatrKablxgPcSlvCaCJb56XMORtLFH33dhClnaRBNIq5ouotnJE/XmOeNToe399R4B2Py8M9LbAY+HyYN/67bmb2xgp7Dk2U9w30apCTt44elb/MPdW1QaNTSpqPnlynvr/a+jR0sVe45LRhtwTEUmapViSLGcEC7u+55gYeW+GX+SRzzT/x5E56KziD39lyqhgMNg/uSzC3u7LUwVQNWiYtAO5R7XaMf9TSofbfR57vuGO1wZQSo2fkJdvzTdstpoEvOUztqcNatfgeBQ87/OpfbSogIIXPXGfj+b0XxLRJ+gAM0vVVg5fSFR+TCt1RthYHD97tzzNPTu4nm7GrAwdkbjB2Yl0h2xT6TBp8riwIBT4EEXLRM4XynfyCvAJNjBE6JMZ1BpScpNFIUjVW0aJGNCuBetElmgHtMBONNMXwanYSeT/fNTr2u1d02fRYRNDblkkm1jUwF3AHZ46PlDwbyHwZhG6AO14v8JE36Ly2GrlbKN2dYapUs48Dcc7vxZcdbTdROo81bPAi8k2nKWp5yu/dhENZZEswZWiLqKNojc6BnsDqeZRFlb1fBVoZGFCexcrJ+c5TzTIc+F+3GtoZ7tz9PtUtDEylCfWDtScrdsyXBVczqeSZh33ki/BoAP00JXj1VSJILzh5J087MLmziJPMZ1bICMrQXd7WPKHMAPPa4+CrJe29LPc83pUoOaYSGOM52HDesP28UPl+Y20VmirlKDR5ol0
 SD3fAVjZ
 7Cy3t5/2Zs3ZaEfh4DCgZqoXEtzgjicdRPkyD1Eju9Etlxz2++aOHeyj6Xc2SmwOTV7F1fEV865p1nxduabe6WsEbpCI98gbJ9La0fYI//qvuN5G7aVyKXHlPGeFLT5EvozXbYV4zLnSMti74liXfJOf4JxZdwx5l1Vv7yg/AdIoawhmZjtAjG6qa3zaX5LVfl0xG/ing/5EAuLWvEf+5MyEUtcr9cE8QNgynwM78m/FQvvHSaiCush6jeKzPXSpa9KDJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 17:41, Lorenzo Stoakes wrote:
> On Sun, May 31, 2026 at 09:49:02PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>>
>>> This I'm not so sure how it would work. Assuming we have submaintainers with
>>> their trees and branches, the final "stable branch" is merged from those.
>>> But it's not a good base for work targeting the same merge window, as that
>>> work would likely go to one of those submaintainer trees. But then it can't
>>> be based on the result of merge of all submaintainer trees. That could only
>>> work for patches targetting the next cycle (after the stable branch becomes
>>> part of rc1).
>>>
>>> So either patches can be based on rc1 and applied as topic branches in a
>>> submaintainer tree and then merged, or if they really depend on something
>>> already in a submaintainer tree, then based on the respective topic branch
>>> that's part of it.
>>
>> Right, most patches can be sent against the "stable branch", but cherry-picked
>> on a submaintainers branch / topic tree.
> 
> I think life will be easier with submaintainer separate trees for this honestly
> :) or it could become a horrible mess in one tree I think.

Requiring contributors to submit stuff targeted at some random trees is madness :)

> 
> I think the simplest is what I suggested in reply to Vlasta, where each
> submaintainer tree has their own set of changes against mm-next/mm-stable and
> then we merge each week.

Throw in hotfixes and it already starts being crazy.

> 
> But am open to learning about what other subsystems in the kernel do...

The TIP tree has a pretty elaborate model of dealing with topic branches, and
don't require things to be sent against specific topic branches.

I'll try to understand that model.

-- 
Cheers,

David

