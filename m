Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE069CF64AB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478826B008A; Thu, 20 Nov 2025 04:58:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450506B0095; Thu, 20 Nov 2025 04:58:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365AB6B009E; Thu, 20 Nov 2025 04:58:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 22A796B008A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:58:04 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7AAED4EC7F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:58:01 +0000 (UTC)
X-FDA: 84130534362.26.3B1B7D5
Received: from mout.web.de (mout.web.de [212.227.15.4])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6B81D10000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:57:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=SKsQG0jr;
	spf=pass (imf05.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.4 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763632679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMRteEgX+7XYeptNGrQQ5sd0xlMP9fffdpk+5Hazd+k=;
	b=LYyq6yzI7Rmc1OHgr677h6GWrW/JhhQwc5nuIvNFAEAcU4O32PM9N7t7fp4B1ywmExSdQB
	7oNDTSFvkhDXkwy05IEWAUNrVcIcT8MGLPLGAIssJ5ymdMiD8zG/j9hkbU64601Zp7a+B9
	F0kK/oZssQ4vqyE/MNR2HoKUUst1B8M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763632679; a=rsa-sha256;
	cv=none;
	b=RaMqdNihSa3d94tJcFeVs3+5DhhMQIVNyLRTO6kvRrlNL3nPa0YG22WPzi/SMK5HgFE9Dp
	69o1LaMStaGop3KiAYvexVS81Z9/teEuI4WY8H8QPzYYpcR92gbdFSranyuF2Z2lunvrDw
	+fPowVzszSkqoLMQN+v62Qr9WnVacqU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=SKsQG0jr;
	spf=pass (imf05.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.4 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de;
	dmarc=pass (policy=quarantine) header.from=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1763632663; x=1764237463; i=markus.elfring@web.de;
	bh=dMRteEgX+7XYeptNGrQQ5sd0xlMP9fffdpk+5Hazd+k=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=SKsQG0jrAFvw5ifboeGZ77RV/4lX48+iq3BICXNKfCUtq5p9Toc5RwPaMGG23Hwk
	 d+kqCkuUQh+On4GEF0ll9HFuzPC1RVxQswrmSuBqgjpXlnTwHSGmM5hWHJo9h8Dc4
	 3qWVl1dMylJmmft73226fHywvVwJqtCyifUHYcVLAAcYlD3lyJRVRvrPhvJskLhDt
	 Pq8rFkD5JuflrFmOD6f35OxsyFhjGf9twAaW3SBytJa8TU8gNPUVbfZ55crLh6ZjK
	 kNovxdd4jw1uU196IscaxPKWvA8RGYglLSf7R1v4soXz1IkgFgW0QBid5Dcrc+Pnj
	 MFYgjiA3bx6/9nVy2w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.176]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mc1ZT-1vrVkn3rBf-00ipC7; Thu, 20
 Nov 2025 10:57:42 +0100
Message-ID: <11c0819f-f0e4-42a3-9a0c-fc71de1e59cc@web.de>
Date: Thu, 20 Nov 2025 10:57:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: kho: free chunks using free_page() instead of kfree()
To: Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
 linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Matlack <dmatlack@google.com>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 LKML <linux-kernel@vger.kernel.org>
References: <20251118182218.63044-1-pratyush@kernel.org>
 <d41ce2d1-e353-4e5b-a17f-52d888a560b4@web.de> <mafs0qztt2h5x.fsf@kernel.org>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <mafs0qztt2h5x.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tvu3+nV0l4pUnx6OlIjZ+34j2cXMpbhpuiMyDW+MdSVWiFLv84g
 hfZ1EDQZGJfrcOQ9tZv5WiLQcZz3xPtu8mTe815rbwbw4D+UyDsks5udqX8CP62z/JwcBQO
 EE5ZKv3inlLXW2Hpnzy6qX1C3seU2ziaMSj95eqgYKzcFUKCDI/w74fYqIN4dL9MmF/LGva
 bTphGgNeY7gpm2Pmi5EFw==
UI-OutboundReport: notjunk:1;M01:P0:RrDfrEaxlZw=;YGEawOC/oWyu0Dw8tD8qtEv00B/
 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
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B81D10000B
X-Stat-Signature: tzssdwp18qjr46qw7g5b4js55e83eo7u
X-HE-Tag: 1763632679-918065
X-HE-Meta: U2FsdGVkX1+8PIktiqVSCs+F02Oq1MWdgXo1jP98y+pB9T0ZLmGJF4PkNNW7gyrWgxtDdTzfNc3mJjG4zPUC4tojnCgb9GGQOeCTSD9kRtXUtoe+TVvdXj6dfg+Zmvhwe0yn8rKUWKSfCvhdTYjtVTgjBbMUef50mQJ+isjftpUJLCgtzi3AkwHHwMEBZugGRXaYJ+Pr0bcH1MeHH073lQxVK/x09Dxguh2zMZBTFHhlswy89803FMoqOMUlO/eX9cGxTD8U6n+7Sz7HhFRhWPt1aZ1RlnFteix31m6UNDPWV/QYoQ3pn/6imzKzRrFo2we25bqgKExX1H3qbHSZxQgz8FWrpDwuwYGd1aNRjNkhUkyEWgfW+agFCVGzk2INivcghqydoDlv7hfPKEBWp5M4ve4R3/i3js7yVBpSG18eps+OUjU1IgylULs4/CLibIBS5xTkm236GX4Msirez697Pzsu49QY2vxvL8/fYaPwcfR1fusK4OFYuPelx4xOVjYHGXaNqrKzc31FljHdNCuaEtcsKE8VKkf7YJOLy5/XbO+tTNMqogkgnbH2YBVRuUuIDrVvpLOYjGLiiQZjimxEb/ebMf/rqegRagf96MbdQx65xSMj+sdLNMKEUkOBKBIzP/YkQZcgkonrFvgvirx/xr5c/L5/zNQ5GwrHCbcPwH92P5mK7x0mpV6jipFeW3Ft27Mfai/DunJnWwn+8yyYUMxmDrFmPQxDcsLOt7dP39W1exL3i/qXE8PTc5OILrtfumDC0WfoQZZUi6gO/DREsLjWUMueqwf0ookJEugELTokyN0KQ96tz27Qd4HFe0ktK/09Ril/SC/YaUh/edg38cnHQrT0yKT0FtEXXJoIWuzFII5Ri/YBQ54EerTy5fXqdjHn38KkVfDNaDEqBFXar30CY8skCswk7cCCGhF/bw1fJQjDjFP1XLs5nqLj2+7bLVqXvAGf+PMV2hB
 FN2R+oh3
 c0qNd2DHUtLnvoYo5vYMAzChjOCh3mCAoQKMT/7lW8xEtLg0k4/vgxygFhG8zOUwjEan6t2vmuCn1ypdont32j6uLgRh9/48EU78BmysdnYnAFpy7DGve3A20nuDeVCBXve0e5+CV0ByEhkwLLaYHoCc2za9z8yGINM+CwlShvSX6dqXPr4hw1dFH8cOpZKSE0exip8n5VywjrxhdgzByt3KflF8p7MSEmm2Yr9zkf0UxxIozNEVTClLCaB+iwVxjr9JRjR5ykwtSI19lU7bKhrXns7/YKubktvxOf4i5E74zf59YXSlk7wOVud234ohwwoXQnJYFvuRyzUcEQ2Wb/Hl5K8PKfbamH4uRaypKfGi3AU+DJ2ebRKmALaKMgO9wkvyJ4lqi5Cs7iAEI1aCRxGA+Xw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Anyway, if you have something better, happy to take suggestions.

You provided a reasonable change introduction (and justification).
How do you think about to add a wording like =E2=80=9CThus use an appropri=
ate macro call.=E2=80=9D?

Would it be helpful to mention the affected function implementation
also in the summary phrase?

Regards,
Markus

