Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83485F30946
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECD5F6B0089; Thu,  5 Mar 2026 06:33:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84606B008A; Thu,  5 Mar 2026 06:33:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB12A6B008C; Thu,  5 Mar 2026 06:33:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C97016B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:33:31 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AB3B8C6C9
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:33:31 +0000 (UTC)
X-FDA: 84511799022.02.62441F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C961940008
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:33:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F2sPU+z4;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772710409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSs1Y82HjIkpBOnu+jWC6xngRaI4DK3dlxf93FXGKTg=;
	b=CKIc6Z/6Ax55lgZms4QDlLHX2MFv/lC1qvBeY190qiNJprH4luk1j45S7d1XGsysLeIDbE
	OTL3nL7rvwA6FxIGHWRpUbldvL8+RUH/AHrl0/ZpYXzYgzzyvyS/VlVFkqOvUexRSR0gf6
	R22P2y+uDgM9IMWq0ILa+iFfXybajLw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772710409; a=rsa-sha256;
	cv=none;
	b=uD7+PdjVkxzBY2O7XqDQMCokb8tnI9TgZmt4mdsrUuImXX4pgtAIpSygDGs/8KFPtpNjPD
	i0W6ThRAs/9hYxTjlo476pw5CQVDor3whCNxQFhiXtCgobmYFt5HV7/I9yCMw7TyBLDski
	mq87/TQX/07FD50CRJBQGJgx48tywRM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F2sPU+z4;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 30D0C61340;
	Thu,  5 Mar 2026 11:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952FDC19423;
	Thu,  5 Mar 2026 11:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772710408;
	bh=jAm91PwAc1lXkftEcgwrlq7IMdvMygsVEaDADqawJLs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F2sPU+z4IPTNPXgA+GjqIRgHYF9PPFTGzsJ3S5kTQI0nTCx+m6Tr5FkMgFowSja1f
	 We/mTmsyf5PgYQTsK+yxnWPtHjdeR942OQv/gXobBlNsfDZcKrIYIDJ/4cCB/wyUjo
	 hp/icgVPvJHlrQ8u+wmWLPULS5mh1BWI510HIoY3+2ow9Rn347x45R0muFarvHusAK
	 M+IgyQVNbkXzuTTKtUKb9XAvIKKEVzclfUUhKhwL9Hw7iSaa5RZxb/bXNWWKEQezA1
	 7tb1TJX7gdUflkeEKqlxWCIt9pVUCSbb8A/ZLpgDRjPPrI6RNBD0S4z4Tf2ctD0+W6
	 RYlyKlMwzXHUw==
Message-ID: <ed3eecfa-a8d7-46fc-bbcd-025fd73e5511@kernel.org>
Date: Thu, 5 Mar 2026 12:33:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: Tytus Rogalewski <tytanick@gmail.com>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
 Jens Axboe <axboe@kernel.dk>
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org>
 <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
 <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
 <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org>
 <CANfXJzto6Ewoj2qDQ5OJEMAuxVcfFcvuxbtKChentqvb2r+jGQ@mail.gmail.com>
 <e2ce4df6-ef2e-4a0c-aee4-86d9614017cc@kernel.org>
 <CANfXJzt7yGZZcuBjmazU9n7V8vupMSLNm+qCiZxcrmtUZicR1g@mail.gmail.com>
 <CANfXJzthDnrQJoCQWrfZwK1Mrw4QZv92ZEzsOy6WGqq3zCYzHw@mail.gmail.com>
 <0dfd588c-3284-4310-b1cd-aab54567f0c0@kernel.org>
 <CANfXJzs29Zv7Qw7cAiEzDLdTJpQEbm6mPeLTpuZkErV5GsDKfQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CANfXJzs29Zv7Qw7cAiEzDLdTJpQEbm6mPeLTpuZkErV5GsDKfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xzxbntpxqm8ufkye7goz9mkdkj9557ep
X-Rspam-User: 
X-Rspamd-Queue-Id: C961940008
X-Rspamd-Server: rspam12
X-HE-Tag: 1772710409-781782
X-HE-Meta: U2FsdGVkX18polYEWTY09WB1mAEDCPGN/G+KGLKvqNchWtzqFHulcOtG1v18TQ57luXqSoMdAfDSuKkfFEU8jKmkndVY7Cb1GgZM4IKIzOTPAZTriJZrzT+W3/DC+zAeZZKjMiL+3zGAVXQuK0sueZLHqJeymSMwgViQBTYSxttsd7QtQcCKZ8NoWZEVpRCf5A2QYF4R8Ap4Nz/GoqZz1TBDAHH23eWimsNU+31agNPdItrC1JvNBLjesb3Eem4j5rPOovvWpamfAuegcRs2z8mQBrbsIjHHauGmSi4QZsB6RVAVe1Mf4Ey0/EsutaTl/wzaVXW9fwtRAOdK73hOtjyx14Rfu8VizBtyx8G86XOu0IeAzwV4d9R+lGPP7BH7GqrW81RIy5+JPM56ppMP25aEcpjDsKpErd3wXkJUZP7TpmR8cRXzPAkvZGXpXeRdSjhEXtU1MnMjGc0XjcXdyvXFyDR4Kwv503dkC5X1dznjYxaBNur4zv5DEE4r2WFl1UJ4eQkDkuNr1aZf4FbIFg0EW0F5A/gEJmHl1KF96lwoG+k/pS8i2UJ9v503HDa56iyIaZF8F1prMfw0xN8rQrFiB5uu1Dn2VsZ4G4mwwOzMaY+hEn+w+THaJPiKcM3GnuDPH5S8cDZvjmzM45BoLupusCW9J+H1Y8OlGogcu4NShaQiko32i4Ps7JQ5f1lNIAWRtBabjBk3A6SOAcwTsmb+itY1oafxff28N8yFDOnI39pAdoxTQfqcpW+GnoMM0S3gt1bVUDEWLErA/RAOGUAmxHgy4fABCGExFr6BeJ2qFW+FGvzcnkqzKCYZm/cVXF4SMVmFnwKDFtDslK5r+x0olLTxrwokg7cmGDarRlMKYYQWPAwZo0fYTRVZcMA2rVaJufJ7SDCAyzZA9PDKUgNFsGEMuPwA7AmJXGvq/WNJYecSzszUTRdQJ1nTtIbzzxk3510wDI41Ua7OMhY
 ABiw+FGi
 vGEHQ9VV9zLZ2sagPbNoRfVTUjYQNZF/6mZgMm/hBvZP0VjUmIDw8kyv1LMPFMTFSjoO0pdYwHKOj8f0cuL3H9OoRRTXD3a7FwqlCTcMfHjp0LLL9/tN4TveX0Q0a5S6kqlrSZRC/swHHdr8MLk92KHnKTfoVUewpjIrs4vbmJW6T0gvZY0O1paRzGzoXuv5NGkRrazH5P3UAUpvsaEhDgNOSDNW71dvKZ3/fHI1acqmQJE2gcTYTCiKaghJitLKVuQE1kjUbfnnwsJ2aOV9WJypPlVNQgp1+544i3Zh8+6IQZvyL6h13X4IY4NY4wS2IG1hL9kEj3wqdpvO+0ZHJVvbyQ2M6P6IWkGga
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 12:29, Tytus Rogalewski wrote:
> Memory space was fine.
> I have big mem usage as i allocating 95% memory into huge pages 1G
> so the rest is 32-64GB of memory for system. Anyway i had plenty at that
> time when this happened

Just to confirm, you were able to reproduce this also on an upstream
6.19-rc4+, correct?

-- 
Cheers,

David

