Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9374C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D77D6B0099; Thu, 30 Jul 2026 10:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF156B00A0; Thu, 30 Jul 2026 10:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5066B00A3; Thu, 30 Jul 2026 10:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6FD6B0099
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:03:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75845140158
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:02:59 +0000 (UTC)
X-FDA: 85045609278.04.5C1E563
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D838F180019
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:02:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cK5nrJQo;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGnmXHIqz3SHpZt1Fpg17ojqINdGAHatAP1AYjREhpw=;
	b=TLqTo5RsNZQcKBmcuowytOAWf/Qk7SihOm7JMc3e5shYNaRHTsi1vP5fTJcROM6MbWz5Sa
	OLLhbdPsmKbFnLjHoLSwBdPe5h8zX0175TynsRA6v6Qxy8kynL4dtXwMefAIfPEIp5vqqr
	+fGH/WZeQDNO33+JlkAZxGXvOKMLDXM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cK5nrJQo;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785420177;
	b=QFEnmypzKBhaJIJw/+3ZrjfuTKINnOStuvzzrIQbzgtb63F31L1jC39GTaAzqTiUvK+qTO
	ZnU1K2yg1lAOScgn7DSg3KcJMHK9WIugUy/wCHn3r97a9vlfax9Jm8vhGpD/Q1T4qJedn1
	DYIlHeiTKlfcwau7fmZTAOC7J5rtBKw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F146E600B0;
	Thu, 30 Jul 2026 14:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0DB1F00A3A;
	Thu, 30 Jul 2026 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785420176;
	bh=qGnmXHIqz3SHpZt1Fpg17ojqINdGAHatAP1AYjREhpw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cK5nrJQo4anHOM33If1aE+Zewq9vR1/A9k5UPTrL41oUVTqWnLbGFQKTjEmRQqB5C
	 SWyxkCD6ryDyQti7oSg/8c/WqIN9VILtay4qSFRMkTKZkzov74016iAKJ3LiCSLQNW
	 xrPShmKXBWaJVnkUuqaabUV/GkfpNZOi2twYSPTj68nWz9kp7mmz1fAP73pNdHxoF2
	 2rcjXL+sWL13UqureGyQwLqZ06j7fXIkkxJ+I2CKpbrSqDuQxSwFbCXosyTYrW3AAn
	 1BEa2lLBrOab+tZzAFno1LO8V+DikV/mJJZbn/RLiCDWyq4ilfcLAS+j21ewQiNhJ0
	 k/AMJBWAE0ong==
Date: Thu, 30 Jul 2026 15:02:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Xueyuan Chen <xueyuan.chen@vivo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Bob Liu <lliubbo@gmail.com>, 
	linux-kernel@vger.kernel.org, Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [PATCH] mm/huge_memory: fix huge zero folio publication race
Message-ID: <amtYgCqaMZ0A2UPO@lucifer>
References: <4ee89c27873fb4d9e598f8a5cfe71d700ecf894e.1785300563.git.xueyuan.chen@vivo.com>
 <37c40d62-51e2-45b4-9837-a4b96d1640b3@kernel.org>
 <20260729180241.2b8bcb2379b975b22c48d251@linux-foundation.org>
 <amr1tqBj9ec57xwa@lucifer>
 <97d8fa18-cf63-49ee-8ed1-d7e55159566c@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97d8fa18-cf63-49ee-8ed1-d7e55159566c@vivo.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D838F180019
X-Stat-Signature: tn1shzfxmswr9x5hcbqep1z5nfdikiyi
X-HE-Tag: 1785420177-985321
X-HE-Meta: U2FsdGVkX1/YKLrQb/EZz/Y9A+INBcHj1F4MVXOUTtmV1S8aWTkQY6jNkbRWwYON6xcL/p+KN2ZM9eMdouQYflSRdm+Y12tgPHOssb4K7ZBxPJ8hC49gEDR9Sse6UO0/HV+rinuaA4gNTNepPp25Lot2yUuc40MlHC7SxEkUd4y6oEI6LuiXAXez5gRkfEduh/zIcF0lAss+++YxCR4GFeQ/Hw9h9Pvgv2eh7YFIdzrgMXFj2195/Iu+Cc31Tg9c3qv9mX310EOc4T9TgAVa73HtVHp9yX6Rkue7FCLLRWdd+gsxR02f0vB9fK/gh7mLFERa+zjIQtfx/QAlfOW7m0W8YvHmf/sjv5vTEpxLgrkG1f4VNhG3D9WxBIwgbXocOcvX66HG2HB+lMiP+0m4vN40g0mSsisgrsgqx59Z/Mr2MmMRcPSKHzl7yCqibrrdtq2yk7NaToskOxXWSGVJyzzS2Pz3d7orIvZwOlCKDvOZTNuFj4sY/o4qK9xJVW4aTuktStDEOmoKENFdYcynGsZZq2Oro/vFV86xVzg03vvjCPKO/1FIe07tm8TYH0bU7vkWAUh8EvtviArB7OgfLeMneXHjddbnwjlaf9CEv0eTwC65Ay2BdQbUlMMHiPV/oGb/D4sELfT1sJhRnQ9ehiJTrsGzPAVZLGYp93cYU4U4nbgwVVzyqcsG/1fpdInaHWAk7jiNcgu7ptxCewpFt5MEJ52Le6exMnQgGXg6OBqNsHsb4HOYwR7tuF/eDf78o+ibQFvoNDKbfGUgcbuPXl2Cf+mDyij21+Hx/lN6U5bdt5W7002CjNVPxgr0BAFbRCGi+MhlubHRuKpLCF6prlge0dnTe0P5RtCXUMbkGiBfMbRJ+K9qReHDCdFyEE/VYyJqPy3QaKJ+qVGA1gfO+G9aguc9sjsQfdPC80L+gGpE4Z26v+S0QDz9L1wN/QThdKPwpLoADuu4/UN5mgX
 pQCHS87M
 c8ID2mtfs3jpjAdMMg+fOfFoY5nmIme8iEkqZC4WnRBKI3NqSVHN/jIvb0K/c4XXA2Q/CkrDonHBChe9Ar0SxaiASsBOJejdVPSXDMIipj6mHHp9IEDJKJjNUXjsRN+K5pSSEMu2zneflPppZGKUkPibOTXnWr1dhYyorXGsPWSPGL8e2fG3ZVXN+LrHKVp8SpquYCBgXjVLgzs+Ml7cuUh65Ynh1eh1v8X/5MxtC9hS4Zphz2B4WOfwmk9n4Wc6RpFZ0QaD7pjuLwdYvcpVf1ghkWhAqiPTOBCzK5S4LqeLs3nWbGElP3V4/YS3remVbeUzu4elpz16cF6Kj7lBTpm9Ycfvvb2qqpmh6VNv57SuucICM+wvlMZbnwHAq5Igs5zs8miI+Kb7PDjlsn6cLfNsxjCVHBzZh6kCAyZWXHWurnZoleY/EeWDLDZyFubi7FzVTxwF9ikoZy++W2fQ411TWT6qPw9fShA01
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 09:40:13PM +0800, Xueyuan Chen wrote:
> Thanks all,
>
> I sent this after seeing the Sashiko report for my series and missed
> Lorenzo's earlier fix.
>
> Lorenzo's series supersedes this patch, and 3b77e8c8cde5 is the correct
> Fixes tag.
>
> Please disregard this patch. Sorry for the noise.

Thanks! :)

>
> https://sashiko.dev/#/patchset/20260727143426.1077133-1-xueyuan.chen21@gmail.com
>
> Thanks,
> Xueyuan

Cheers, Lorenzo

