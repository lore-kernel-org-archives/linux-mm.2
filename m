Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD35CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 07:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68DAC6B008C; Thu, 15 Oct 2026 03:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E236B0095; Thu, 15 Oct 2026 03:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B7A6B0096; Thu, 15 Oct 2026 03:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 301CF6B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:36:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2CA0140400
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:36:25 +0000 (UTC)
X-FDA: 85324052730.20.81C7658
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1BF63C0004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:36:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b+rtfN2z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792049784;
	b=m4c48T+/l6/oXHp7UaurrofScDARpOiwtpZiBeJHpEDuRcaDIEz6KE1wb7yeY3gZ7VeS78
	c0urXF6oWWgpeTI5cSvV5Ey9j/2GdgoA6cLEf6qXnMrH80t1ieHt0UpEk33aRt6+UlxNkq
	QgqSaFLPWNajgC4jcl6PUvYKxxAKozI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b+rtfN2z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792049784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=z4UeIwHQOxwYBLcVKwKbKO8z42PA/RkSXPeAr/0bJgM=;
	b=YDBh/+XhQUGXb3cV3vY7S7cLoTTqjYupoo7pk309ujgcNypf4ZRJEgUWIHwgwQ/qCil3aw
	IsRlw5JaS/efYHietmRRR2h26bz6F35If9Xlf1SRqVg7jMu5MPlc3Yt8igB8H9BYw5s5jm
	AZykc1Qh5p+rWWxZdUOyRTSogS5pqZ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 945186020C;
	Thu, 15 Oct 2026 07:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06711F000C4;
	Thu, 15 Oct 2026 07:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792049783;
	bh=z4UeIwHQOxwYBLcVKwKbKO8z42PA/RkSXPeAr/0bJgM=;
	h=Date:From:To:Subject;
	b=b+rtfN2zttH776LAB46ZgXtroe3AHZU0pSdQoy+9dHyrLMGtejkPfBgo4WD63m3du
	 fqYb2ysCRjxBTjuReLhQIDABshYxKcPf4sB2gDFqPWBJQNKEc97/HekCVltcprZonk
	 XUO3WGFt7WGFHWbkx1hUv11Ah++luCQ5sLR7/FUzRyRLzXbsPPWUZm9busgd0btI0Q
	 lbInucuL9M19T9lxQFavWqS4+XfBdSt9HwzOiPPIrDF8cUL2FQmNgkctjg/s/Q8OVE
	 St88lIYUnFEBLn0VGPNjbbU383u2vEOphDu2O3eHzumM8VlDFfMGXaOnK5/IfYgx/4
	 4WpLKICCWP+xw==
Message-ID: <dbabaf78-cb48-409b-a7a2-3eb60ec06889@kernel.org>
Date: Thu, 15 Oct 2026 09:36:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-10-15
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z45qfw5k7c5gu7gmprk6za6nrowpuwoe
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1BF63C0004
X-HE-Tag: 1792049783-272930
X-HE-Meta: U2FsdGVkX19rMUQCZ1HJdWfU0cXkb+fpnZEMmi36FXYHudzDT4YzAQ+SZdN+WiAnZfU9Sc1L93jqIUpc2n0+CPk6PQBK9KxGYIblVBESK2NT8OTEaYPuQIq08T2YYnoFaUtm2gQ6/F5NKb7UIMYFslfLxCMpV/Ms62ixrZz74MKvzQR0IWakRBXhujhADM23ClkDJv6sIBtg7dsxE6QOdpBxyHd2rxEf2gXxdoTEpPZESt1a5eTEhU/z/Idb2fg2A2LKIE6YAd3FCzJ2lz/Qtus6+rTj437yoNDU6FBfa6YEdeiRi/Q7j01rUR369x9++xrmtebsbTHaIRiKEA2CcW2Qa1wcHac/kb7pG/y0SIeW/Jorf/zpe8+6qIujRti05KxnPZNQlphMjFmhF/SKW/e1BPTTR+Fwere0UlGOBLGpSf1xrMDJp/qiLzi1ogIuam7W2vM96GjTmcXEsKFNvQi6x2hrjZe7JLOh27zSjQs1E1+chnoJZA+N1l0sSl/uC/dv/6PDwPyw0/6GtyaX31Dm+gUwrP128C4RPVr8ZGIhVIAKy18GUTJW+QG7APpUH2E47tSYtcbX9CarAk7+akuWDVvgHIbqU0eJ+Jke31VcbaCflByShHWDRaC42ocjaq/TatzmJsLPy+R2CU3QVT1wVi57Qiwy40cd/if1uJNHyuJZ9g465pTlQ1pjFizBFyPYdyzHgsGjOJESGxo5+v6zmsCyVTdRgxI/kkwpkq1crFltHGIq34ZD+nQdvc79r9Ocl1yxeQU+okmLEMtsqsqloiRyNRdI3CIsXsiZEOUzKDoFAp4a2xWaxbVgtzz1g1dBPW6lGTboyc2fJjeoIqj6qKcUdjIdPTiRE08xh9CiwwygRO3ii7nv/Yfa9V8S/r3HB3qFtXYj60OoWJnPFop4ELorz+L8tlFO0CYHPS9ltq/BpdHqezv4ASNAUgEetiso0TiThDxPLpl1RVq
 MZlggAep
 Gr2iYYjQxvpRRN48KHl6C6Y/MXlX8LtR+ZBUxgy5qUYrFc7wGhXch2s0sgoMxGTuQnqkeisI7LINdoaxzrqnDMi1WYKK+cqxPmkXIQ80XgTm1XACZFfqqTFtIngNvuUHxTOfqpm7xExddVwBQVA1q9/41PvH/UiaSCkxi+ytOutgYhGQlSCZB3KxupaPYSxNm/Y3cVrJmrK1N+MOwgj9ZBkdgvZSA7HoYXf6G9mHeS16S2yeGEZZtcvF1NyUf0c88okN+InPSeFDPbL4PBt3aS7TGciQzfE51yhi5G4NHv6bFNLqNKs2rnF0+q99bURomYPZBXM9+CudDOvR6eg21rMZ8j+lACIEmcF144Lto//osszXj2qfpTZ7JuPjmgqmyfh1WmoQVbq8sLcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Late reminder. Our next guest_memfd upstream call is scheduled for today,
Thursday, 2026-10-15 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We have a couple of things to discuss on our agenda:

 - 7.4 in-place conversion plans (SNP, CCP fixes)
 - guest_memfd link ioctl
 - Current state of "multiple providers" after LPC

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

