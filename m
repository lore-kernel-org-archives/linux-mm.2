Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE08AC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2E86B00DD; Tue,  4 Aug 2026 15:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CA66B00E8; Tue,  4 Aug 2026 15:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE6F6B00FD; Tue,  4 Aug 2026 15:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2D26B00DD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:30:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B58E1120215
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:30:09 +0000 (UTC)
X-FDA: 85064577738.28.1A29BDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 18A6C1A0011
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:30:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LWkjk1/H";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785871808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=X87HZxhBIVMu0rRtU4tqFRxQ/YsdcUVYlFHYSsFZZmc=;
	b=oey4S1ln1ErNZtiDiy+dObzLwFmvlBrFd6M9rVNLzrpdcIqL/GE1/Zkn4uMUkqIX1YpJHt
	sRfiWCHWsQvqePmKAWjFz1/Wg+wYcnSSFyAbCxR6rFLvA/nTcz3DT4qw3giLJRrna+C3d8
	5hjQajbpmnROaNH4d+EXzEA4rsVVmGs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LWkjk1/H";
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785871808;
	b=JOL7qSGrp/6sqZyIKj+3povXpi2GNpDv99dQLgGTuOQhPBNEDi+j6TL3oMiRi3DvExq+10
	+WbaInlrDdSxUbTyVnETDmRlWbKzTxxYBG95X0wNxh2E/SqJkXZ9SWmHpLcowZb9NGB1V9
	BAu1kRSgBYQOGysaYLcIJaOfWDOOCe0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 214D443BB4;
	Tue,  4 Aug 2026 19:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19AE1F000E9;
	Tue,  4 Aug 2026 19:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785871807;
	bh=X87HZxhBIVMu0rRtU4tqFRxQ/YsdcUVYlFHYSsFZZmc=;
	h=Date:From:To:Subject;
	b=LWkjk1/H7RQYR0z1TIPXn2uUSaiV72i687OMa+eXNrDfQhm6URrswevNvCYcFKA7s
	 JwEVQY6AmMENbQDewTaNnqfLOa3hTJVgUojoH0Ne1PEjARnQ3vDoODKSMntRDGuWqx
	 kxQDd8ra8XKoN5iMicCAtL2KX61X/OaqJ1tr36E8q355XPdzokHCgoCo4EovoaludG
	 crCVv3vXCm7FpPITFYoyiwra0FCCT2c1V3/2R1zup++6HnUqMmo2Ro6EajC7IbrAQD
	 fuptERcPGeTRI1Jaz/+Y50O9hxzxf/sRN569a2mLZd6Dkjx4wvDahw7Vc7ncBxwWFV
	 2XGRZhKxCHxog==
Message-ID: <69806089-f615-490a-8367-cfea21fb0854@kernel.org>
Date: Tue, 4 Aug 2026 21:29:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-08-06
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qw4rt9n3dibpprah6zpsn1od4pw1zrff
X-Rspamd-Queue-Id: 18A6C1A0011
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785871807-541412
X-HE-Meta: U2FsdGVkX1+01eRfhSz3c0S2vdy86kXa4fvrfigHwj03B46zWk0/X5eLRmeqrRBmKoDrGFEs+ORCUxsPjvHs71yc/w92NeXc88V1kKDvxadAmngKyLjPIfmBx8cPpY6Z0aGOQ98QVEWjcO1meqY/1cyWmC26H6hqVGtLMaQ6q43FRFlEX1mzOil06OPdPFBMw3LnTgle/hrKj2sJIrJkQkD76VGg6QLgrx/1S+GzcLJ62zfUvLZf2Xc2SYBcgagoZIWjziZsBMoh4VE/K8+9NKmrIQ8Q+1VReU0wCXntuJdEp4CiU612ELrbyKejni4uF8iMb0zitMkiDjMZXQXYhFtjzYzCJF67p9b084OP4U7/KLaTOed7L6e6Y/D+3reGN8TV9JXDZkjoBymtHLUisYSPLLHcpsrr75Ugd/N/yETB//Ww3jqyyq8ecG3/V6047ZyW3a6XAjf24TUuzkV5SCKpceCgJBFcvPTp514bxHBbBI3psuEVz1joc6SM/iP6Atg54JaSTYdAubSQKE9kYzj0Hp2df0vnCstmQBMghdnZfEJBRxlRnrSFcyTNpLMEiiXm6RARnXvW3TIUvoOuC6GCV7zEmofqsGN7dEIkPZ2OzuA+ZIbypoD7oHCXrgHEqP3hYpc4YAnKq+azuIkIk5kPp4PEnuNg3dGWt036AwsH81LCYDK3m2mS1lfeYQ4SGgXPbiIRbOVDMcoP5DOTuFGSGjEv34jC/qsSHqQd6fx5Hrt6W+L+jC5g4b4snBsPJABNP3fkSh/PUT6nC/sBceTBSu1G/sd0kpi1/YvnmbWTofSWIrd1mW61aig2hdU7Ms1eoj1159tcfPokiBcoKjV+s5UuxRvxB7tftl7qEDza6TLExXUooV2fPuqRjP0663T55HGAn3bBl2gQuu/9ow+pBUo6ENofUUDK5MjsZH6RwpY3cmR9Z7Wr6+R1Iu/8rCoUJ/4SEHsnxG1rzGv
 lcZFG72l
 56zHKTeEkmBzJ+augh4Bb/nZnHxfU6iurmMI9Fny8LqPcTTQaECWRehzjoJtpmtmeTrUD9qBPBVkqM2mp0OYu8ZC7K4akJU47ZaxmavtfDbc7ZyXLWMeAgpNSz15H3CLXCeeKR/l/2iy1O4idmaT2mApI1hsMQuIgqHsCoGm4etm9zhDWhID3jeSmmlxuycHWkmlm+WxplcMZZP6tJWOZUW2EzCBpTUrWTtXDo6wQg1EFdrdEVMjvAwAPXx3Lh03XaWfDKP76dvdYUrUdGjJbKqCMNmLFMjj+QSUVHGDBUKSoARJ9N69tB0z6/PhFZZDqdhivBNDaKmCFopUZl37Xo7o1If/Oe0J+jeI40Vr3wbl3r/jww894eQoFZ9e17pnq6UQA9GEzcjYFWTw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for today, Thursday,
2026-08-06 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

In this meeting, David Woodhouse wants to discuss a solution to get VFIO flying
with guest_memfd (I suppose now also for private memory! :) ), and we should
sync on upstreaming of in-place conversion (and how to deal with LRU cache
draining).

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or Ackerley a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.


[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David


