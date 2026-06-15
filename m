Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6097CCD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821F56B0005; Mon, 15 Jun 2026 07:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ABE66B0092; Mon, 15 Jun 2026 07:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673B96B0095; Mon, 15 Jun 2026 07:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 53BB56B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:39:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D56FAA09D2
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:39:19 +0000 (UTC)
X-FDA: 84881951238.03.1B04FF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2179B18000A
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:39:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lE039RTH;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781523558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evSn0i3aRCo8rewDkLxOYMP18paLc7Xbjt30VOZ5sKo=;
	b=wj1X+VPm1hp46pxtklBO52vWdXxUnOKGAVY1VUK/Om5FjYsw1R/MQvp8Hem8KNAY/pT4W7
	ZjIv7dWbpV1+apUVb/oTsJOpoj9hZPGX4X7FL9SpIEfrZTk8tMRkyy7V6CcaMK9qxwKMfM
	C/t2m7uKcJOLRsRY8TN7ezVQL++3OMw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781523558;
	b=wKD9ynqqm+I2RxkglknYnJwlEV75I+QOR6+L//Ije9FEWGbI6+GFkREpWOYtDyiRblX24d
	MrXhiMAYWqChYgeqwAUI/Z5tH1jxOV70vDSyVeAvXIipXaKmJQbx3oA8QNkoSirdr+FLAk
	7gg0agqIeTNVmiNVLBajT8BD9EYFC5k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lE039RTH;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 989026008A;
	Mon, 15 Jun 2026 11:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80511F000E9;
	Mon, 15 Jun 2026 11:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781523557;
	bh=evSn0i3aRCo8rewDkLxOYMP18paLc7Xbjt30VOZ5sKo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lE039RTHXLVkeFZTudC84YWy7kBEB6paYo0JuB/agaBcilzSuynavx1sUmCMSmlwY
	 6WYnZr4baq8MW7wYE9vrnLX4Ta24DCc0ErBbkinkomEhFnNMaIrNlEXdSLEiwqqm3+
	 qwJ1p6GABFYQFWuQWlhANQzgFhBT0T3v21aItv+r+Uye+ptfuYMBnFNixSX/l2+C/t
	 hgAkHpDp6b0aP4MVM5LS0DIfWtRgJkKpTyKyc9zh90tBET87tRc38v3Dh4920P/7bU
	 04Z64juCAOG8gaZ5XU1d/ukehAa3gHVrtp/et6z2ZAW/uGVv65YTBGOzKb0oZYEEQX
	 mPi48Gugjro6g==
Message-ID: <02d432a5-3241-492e-9fc8-40ac151f6eb2@kernel.org>
Date: Mon, 15 Jun 2026 13:39:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
To: Gregory Price <gourry@gourry.net>
Cc: Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Waiman Long <longman@redhat.com>,
 Farhad Alemi <falemi@asu.edu>, Yury Norov <ynorov@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
 <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
 <8d3b4561-92cd-4ebc-8462-5fb0fd659e8a@kernel.org>
 <ai_IHvyptWPcTD0y@gourry-fedora-PF4VCD3F>
 <ec4b4b70-dc01-41fc-ad58-e1c877f6a7eb@kernel.org>
 <ai_fsVg51_GTtzT1@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ai_fsVg51_GTtzT1@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2179B18000A
X-Stat-Signature: yb7pkju6eh5jmwkk9smu16esdwcd7zuq
X-HE-Tag: 1781523557-889693
X-HE-Meta: U2FsdGVkX19TXkstRxtS/vaVj/RCzEcrE79hGUJ7Ol022nI8OCfZ/+MCi6qKj+Yuibt92gmI5LETg/rgI/AVyVjfHtfjhg/3y4ctjGBrJuhpfMgegGDyV5NR4qQBUG9mgbyTcIrbiWD0nnfsp8vTcUGUB4KoPLRFYtzsTbPu1zyzKt51ynwnLTkn6DCzLzeZwzEZUjVM/U5mJwpbozZ3Cy+hTsfRTdB0s1sx5eFkGHpCdpURW+dHTSW3jlrcAZFe4gtav3JAehypU/Wu14p23AeskCyk3cofLoEQn6H+yKc7yXHKo3qRt0QTLF1ZwME6ndnoo/zZcdKBNAaQsrl1yjAFSG2PffqhAcFXK00AanM80SISUxPhAVOtlrgKSg9ps2R8iTC9vQycEw35N7uqEqxUt5f8kEREGKAyvkMIZ8ofU/YhVtw5RwecQRvg5F/7TbL3kqezVs382ovSbzAQyhNOjuLrJXTLxcfhwg76s9OnKCafsAA4aCiPrmKSRzFlQ4Lfb8emrtTPmWbZHyuP6umiS+vRGwz1d7IqPXzhILir+kx/l1PsTBVgstNOShJ4Yuv5ZF2KNr7Z8h54/c+6zMFm4mVX2gc0SHkcXhcnylcHm9Jvacfccr7snr8BpAI9wVhqO45WRxKPsl4owZv2G/Y8HdCyCf+gVQwsbRRvMW58K1l2CkJN6n7/oukNVfcEgjxFprS/NxCETT1Sha4Xd+1H+hAfzz3yRWLFCxwdixaPkHUUsOcAcRSzhwpmzEvtLuJr8kfXY4hB9TTbwpjMspXHCC8NahgZq2ZCL7Asf97DU6e7LcpJgWeEEhBQqGngVkJBV5rMqc8b8cUFc37DJSKYrKYcCcogiCXx0iTDaZBEJW31wg61P12l0NaYPYJcrKruvrCfZg3PVkae32XAU45p2NmP1OI1unhBBB/pij4BM1XJuSMdJmtNZD2H+DtjE2ISiG6Tu0RSffsQSX6
 Kx4sI+mx
 +lygI6KejFl4iiQtbaE8MgJ3iJZB0cUfcyNawqa9ObgpAgYsMafvjaHtVgApbU4D/khTZxlslYMEs8yDgd/BkarC2dwH41hLPCIMrbSluXvMqFDLtM4zL4uOv2d+yEONlqwfiJlwv+9jgRMva5Ubv96lw1O0JnMvopQcrKK+T8OySAfr1incdOt+Y2lSO44kAO8QBsMS1MOOkO1Hlw46QZ1Q89ul48hAeGYZnfCxmuziEzxKEtov2wjwb5jjO6PcsHQrFKzFxE9U0EQO60C31wiNj7aMKFo+J5icKoL6TrEVvNPselcXFsIafbMGpRdUO6pa7LrI+PI9v5/ADk8C8etMBS4ptCy/plkpwIE4JtAsiAuvZ9XmhjSMQx/qyY5PseQlYmlyPj2vs5kvIemtb6PufDSEuEIokn02h+/ifOM5vVug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/15/26 13:19, Gregory Price wrote:
> On Mon, Jun 15, 2026 at 01:08:16PM +0200, David Hildenbrand (Arm) wrote:
>> With newmems it's clear that it is guaranteed to not be empty.
> 
> I hadn't noticed he switched the patch from newmems -> effective_mems.
> 
> This needs to be changed back to newmems, otherwise we're depending on
> a derivative value set somewhere else in the code being correct instead
> of using what we *know* is correct *at the moment we need to use it*.
> 
> So yes, go back to using newmems.

Right, that's what v1 did looking at this now. Waiman requested the change, but
I don't think we want that.

So for v1:

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

