Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC20ACDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAEB56B0139; Thu, 25 Jun 2026 08:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87766B013A; Thu, 25 Jun 2026 08:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9DFD6B013B; Thu, 25 Jun 2026 08:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4D06B0139
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:12:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F40564069C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:12:39 +0000 (UTC)
X-FDA: 84918323280.30.C6B61AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 65DBA100007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:12:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jfdMMVYP;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782389558;
	b=3ZQDEwJiTYzWijZ4ItRseT63dIIZpe7y+NecPcUFOZSx0fkai0L6r0W1ZLfQ/+78nrZzi4
	aDUWkCApQkkHhiZ7uDgb28FyugslgL8MEPns8jWsR8LtuQpGS5XSV0hsvDz4ThJQmZP6EO
	pl2YkJWI5gMKM/FQkhTq8FxIetWcJ7E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782389558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IdozHlBC1r2aqUzPaf46PBkgt34i1vS5Qrw7ojqdRjA=;
	b=RGiw6WkgQEM10QS0q1hSBLxNw2EltoAIv47mIbqb9577B2DITPqLyyKnuUcmu/0demvjLj
	zrRSPSrJI1mKWaukFozg3VsBcRBNaY04UiMusTZKubW/Q4aM8v1TpIGrCFD1y+Kc+ICPrd
	veAd09yuGijuflV17Ylz9qJIrIYC2a8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jfdMMVYP;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC523600C3;
	Thu, 25 Jun 2026 12:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49A11F000E9;
	Thu, 25 Jun 2026 12:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782389557;
	bh=IdozHlBC1r2aqUzPaf46PBkgt34i1vS5Qrw7ojqdRjA=;
	h=Date:From:To:Subject;
	b=jfdMMVYPILjEqtCwtHJT5w91p2W5mxdNnYsojr36Py6vueoKsIoULClYP1btsPVtw
	 fRk6IDtPzUwmpYS/LrmjgqXZTr9jxSCQpZ4YF2j2F65JlrimEl9tL6yRGwN7v80bE0
	 LVHBiSjsQxOppJunf+w2p7mjeaZEBSfBO83V8n+AU4f3YoWmu6zFKdhXiF6zzLIoMZ
	 PTR8/stRnCsp97tyP6nrT0OI0BA2DlfX5Z44MK80aCFaEoYJFKS5RbChwN87eGM6D5
	 pVU5Cmz+UCRSCmOGnFRdnAUTbdQju//ldyaWqR86Z+DWmKIFrSm3w0+xK5wIaEaWtc
	 jKa9x9vInX/5g==
Message-ID: <3b190dc7-296b-499f-ae19-c7b80b9ef491@kernel.org>
Date: Thu, 25 Jun 2026 14:12:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-06-25
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 65DBA100007
X-Stat-Signature: dmjj9ez88incky65yp5365fdpnrdrs8w
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782389558-430032
X-HE-Meta: U2FsdGVkX1/7DI+J63SOupLlPuxRFxz+tx+f7wzqKMVEOkijWkcpf2DD6qGYg56KOJs+QI8s+I900L2fFcF4hU8EBg/jW46ZTG1jWTUv+NSniVYqrgbBdj3pZPqmx7j6vZ1TMy1bWKXvq6aVAvEpqyWeAVG6ZXyjumHY7kPjR8UTgyfC9a8+Jd4zh2A9AXb/skB8dYWu2WTn9uR8WoPw5V1uDNnY+VTc89vpOowsElC4lggIrwv6BqlfK7gKSGtOckn618O6JuBwQzyx4QP1ER312YKnZiGiYEdzKqoURtmA7f7oozROAeqcVUFFuQoYW+JZkhKPbaPRiGBJmj7PdZIM+bzYvWHScIYqBAqT3YJYakyfaXOh2M8vmJmkceijUmZhBpCZQv+HKo/x5E6Z9K4CfiiZqrcz/NihEjOjESZOR+90Q2/+yIw8upHey2GWZ4KhPF1RKFQ3VbuyCo3hcIA71PE9KwxG89k5cur5D/1hZJomMweaAyEkIvNq86kPkF2rze3gcv8MEMXRbESSgsryOu+p3devi1TfZjYt5i88lnlxzd52340niovBuf9tCd/UJ1q4BhNl4sJmzKQVZPoBX3UQztXEJ2UC+XRZYRPnqHHdOMaPdz/tf92xYAezqNE+5GEOcA2/00e6l2MKyesTkAyeIJ9p7J98bK9VvINKHvzMQKR5uyUSiS6l83+KPfEaSFesQZpleRtSV/m8nqhk/VshqutcpVxyfVHGJBp4xabwe/+rgWajur7OrF5Lic1zejIjY00HenAnIRr90TBwEUhGwKXLJdnYWoMKOUkyDaX+rx2UkxIbw/yXqWbit2mvRyWpOolGltGsolt6Xg9xlWDSnrJ9wxsiyzpR6N9hfxzpDVlRbAwcf9pXEoFtULgbC1/04Nkgxidndln6ZJcRmDL/qngFiOjveubryzadHeceJ99Reo4yRuyxgqFQz95OfnW+A2cVF69LC9u
 zSQlq7c9
 DHlMeOqKaEU2zCv/jZP5ePX1Lay6gcdNggHfyuzGWYU5B+zylQ3DduEDelYVCK2JulzSOkYMKjZMq5FGvj6pgFwonQkIeJ+iWVHz7qh4lQ94boIbusB9ryMO1nQOMT/jt8Oz7RLyHnBsdqaeEwLVrLkPDfddqbIE8A/tekyQJsiyl5QnRkvtvuC2nqfA0UXhC2uZzupDoF0dS301Gw1sEFct2Y3bfEWGL9/s2vhpdv05lSeocxcZm7NN06scre0yEeUTAmaq9xbK86YzuvFnWwVKueqBlp3fOhBS1KRUdX+3WEvjpDesxoQLvasYhjf2NzaRjF9rKelDMFEgRDU99Kcl9woLsmRvaY5neK/ssOED+IQFwc7vzI1/kdw8lbIh8aPPdNmBf1l5kGAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

very late reminder :/

Our next guest_memfd upstream call is scheduled for today, Thursday,
2026-06-25 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

So far we don't have a lot of topics, so maybe this could be one of these rare
short meetings :)

If we have the right people in the call, I would like to continue the discussion
on proposed memory hot(un)plug/virtio-mem support.


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


