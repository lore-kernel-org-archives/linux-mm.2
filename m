Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A05E103E19B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 06:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB666B03F9; Thu, 19 Mar 2026 02:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC576B03FA; Thu, 19 Mar 2026 02:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B696B03FB; Thu, 19 Mar 2026 02:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9026B6B03F9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:05:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2AA931A0397
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:05:18 +0000 (UTC)
X-FDA: 84561775116.05.8C654FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A54D3160008
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:05:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lKZGunh+;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773900316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWjbMA3Yhua7Ehx+8FuDyHCOk1VmWz54DJ5IZPRo3ss=;
	b=dbzpj6u72xuU/m67UiZuH/+vLjo1lzIiRY/uqZXClgk5RjWvEaszwSpTKBC3rLIzvx16HE
	R3BvmWUDWD6E/kQ/GZwVJn9JR6gyUoIjocJ63GM7mCdB/LDzGG/JBMNBj8trmGyRl0i3vw
	Ywbmv0SIIJVjTtbAz91lgTOmB9fL9W8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lKZGunh+;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773900316; a=rsa-sha256;
	cv=none;
	b=ThqzSCdpoNL7Lpsv+HC7MAmkWidO9OHmO57Q4mfIfSMJDjXmoTtmdf9Q4HtFbxd0DBNC7B
	5YOuLFfto+gEevIRwCkER/lxfijQ5COchCbNg/xF8vRi2jCTQrZMIxVklEbeg53FNFuRqF
	K7qAaQFD/ywYrpWwxLvcU3IcIpULkeA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 178FB600AD;
	Thu, 19 Mar 2026 06:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEB2C19425;
	Thu, 19 Mar 2026 06:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773900315;
	bh=YSuWgb/bZv40t/PkTFpxAbYeBoEA1FokMoyj2hWvVcM=;
	h=Date:Subject:From:To:References:In-Reply-To:From;
	b=lKZGunh+OeRh2W28KsmGk4gyIdYc9TwWYnyMbJ1grZRedgbv5ZQGNbf/9fwScRW03
	 AHXgEmsT++mHjZUwe8nNflHgqK9qRPaB9Zr5HNxmnS0Bkjpc+MlMfAAo/4x9QZfq7g
	 ms8/jM1PS/epD7b9haLyB+S6RxMujDwjWscL9Dhgw16L3MK0EITApQPOmnnyAbYvyC
	 6dH+7s9YlGwzaa1MqiGYHBX8RHxIx6JVnT1fwPSSNPDvGrWXYITgLu2BDifXv3vJp8
	 iUPdjwDc+MfHhJY/wVTyXQyf1YSLYUWJIlbOBIUOUII9gDdt6GLIu9PyYwUpRmuJaI
	 A1WOkDvE2NnaQ==
Message-ID: <7b7d07c7-7717-404e-b2f8-772987523efd@kernel.org>
Date: Thu, 19 Mar 2026 07:05:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2026-03-19
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
References: <22d1bdf9-4d21-4252-8558-e9618a409bc5@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <22d1bdf9-4d21-4252-8558-e9618a409bc5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A54D3160008
X-Stat-Signature: wqsrrrzjiutp95x6quau4xpgg94wep7s
X-Rspam-User: 
X-HE-Tag: 1773900316-305318
X-HE-Meta: U2FsdGVkX18QSU/t6FAb2hxzMKDLKhzyfxTMi3uf3Mor+LQV3oon1kMgnOx8a9j+2l3W17VB9Cnsk+oLOhlUx/Xlq1ygMyx4PgqC+MIa8m75cbtESbPWXIqUwImEZeiEGVkmjRvDx9S0wiDHoOkF/AsaWgRw1+fa6vS+6zjeMahmIJuiQTZViyWxsABF1GmsKAJ822JKXwpawRZ1pIHRUBSHa/GyUAUUfUYqYppHbHpSrAXdprm9tMLmFgDFRTscEZa1i75O2jTC4osZzVO53Cy054xnxNZhgm+TrrmwMyeGewHCTt2W64Z5t8jOuA9ucImSux7bFDQeKLdQwp9oPbIKP36UKgRsI/80KZAt8Ia0oDoi4kYOkOZxYy8wAcHFu/gklOlDHV6LaQgaYGmyAgn1IlBvuzpISWry22j35Z5r5DW6oVjXjKH4k/y1XA0I30oeL4HprEv4WO583noUHmj6WjqE5xiJTml+jQmMzkdgsjvGe+a27sllnLYJYKUGP+obdxMzv7HXCfAffI+VFkAHPRnrsDXum1/627OwOsmiu9Zp1Rm69lzOaS7U09YW5zA7cu8X3MofBW1DiyfKs3Iw5Bts1KRX0RbpsktMaAjLSOc2xyVfOIs0mI24aCnHpNZUb8zLI71tkukdsiEzOep3Rxy0HezZToNTZQJTJWYiwUBZdmwfq1qwTRBjWBH4eYqRsgfzde7yOV6V+rxjm7DvdvYUclB0eWvviaX0e8UcnXt6dofFTqwt78Tfey9NCufnjIu0pW9Csmd42N8O8foYjEKT0s7qOkKqpGDwWAGIgTbJ98tRadV9SdnIOkTqhsdIu0UiWadWOghGgFuULQEUY+eUT8qdBfovIkpdsFsIHJSvNLeW+1CLIzq1bRYgosQ6m+SE1jECLlTIpxuvJ1gsscvr5AcJ433NUHJCRJjoZKXFWC0dupdYaVraagnlvWjB5WkCcSdVTbvcDlG
 Yt8XyG37
 Sm4CzPLCm/N1V8/l70/lOXibnaIbWFpOeTlHGLUu+yxXmlEg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 11:50, David Hildenbrand (Arm) wrote:
> Hi,
> 
> Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
> 2026-03-19 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.
> 
> !!! Note the GMT-08:00 -> GMT-07:00 change due to DST in the US :) !!!

As Google calendar keeps dropping all invitees from the meeting for some
reason at random points in time--I suspect because I moved the calendar
entry over from my RH account by changing the owner--I just created a
new calendar entry and sent out invitations.

Hopefully it sticks now ...

-- 
Cheers,

David

