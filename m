Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A39CD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6AD6B0088; Sun, 17 May 2026 13:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99E496B008C; Sun, 17 May 2026 13:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DBEB6B0092; Sun, 17 May 2026 13:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6156B0088
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:25:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20FA98F1E6
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:25:16 +0000 (UTC)
X-FDA: 84777587832.28.92A626D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 43BA7C0009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:25:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pKvjCb+w;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779038714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQ51mDNmzYlOwO2RNhKMup+LJn3UvUp1u2hQb0kvOlw=;
	b=s9ZONmxLaa/PQ/ZQRLfM8jShkSnqZy5inUPTQYBS61a6NkEh3u62dqAdhmF667uma0mX8P
	TO8cu76vpSnEYrrO2O0p5wkBEFJp013LEINE7o7inMJ0AcO0rB5dsg3hmFmdsYfdrl3PfA
	BMyHpcwlsi1Ie4edyAFt+CBGKLv9NRk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pKvjCb+w;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779038714; a=rsa-sha256;
	cv=none;
	b=o4YEJKImNw/chM2aMk78YK5PdZCnib5kaR7VOVSwRaTBbun2NY3cy+vvjn7v9Xd9WmWxqv
	Pk127pHoyilJB2IuprYLTB+zvG27XS9sGr2kTcfcM34Ek2aaGa6txDhF+aDGkbrWUpajwG
	Nobbf6ofS468Rb98/VPPdlbXNIEo9x4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF6726020B;
	Sun, 17 May 2026 17:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D36AC2BCB0;
	Sun, 17 May 2026 17:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779038713;
	bh=dhS9wVv40cgOex3fqEGWAJwNPN0dvGp8u4KcgCsmWV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pKvjCb+wKRGA9xiiCNbRlqsxXuUdAB4R1A/U0fGy180AVGpyQhHWCIZyle1QqYBL9
	 X1S8o+7dJztCIkngZZmyOti6FuvshZ5IxQ5HzImT3wBfj05+ljzNuC3yN8at6VCwTJ
	 KVm7QVCGtFvJIHtTdl1t4/qX00JkcdCM3PlpfyfRHJZs+Jw7TjKCGj4yi9aGQlGGZ5
	 OUwk7sXt8f271KeRvmGmzDszytUKK7MgQSQ9U1SCWplSyTYyaU12+Eno9c7ytzXxSf
	 1S4Rb+H9f1eagWaXhLxyfdMBzjCWILZifNyk7j+3D93YalZOE1sEFndj7Rb+9NjWGr
	 gS1NDt/r92Wcw==
Date: Sun, 17 May 2026 20:25:05 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH v2 03/10] liveupdate: Extract luo_session_deserialize_one
 helper
Message-ID: <agn58YPpCkkKFfWA@kernel.org>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-4-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514222628.931312-4-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 43BA7C0009
X-Stat-Signature: k6b58mhrer44zuqmcanrbkbdaef4bg5i
X-HE-Tag: 1779038714-649251
X-HE-Meta: U2FsdGVkX1+pN+ghgMfu7XX9Uekrayv8lGUlZ46nOGkmxJclrt2QKGD760KybLd1PZMF6tnin63iGRleeSM92xexXUSmzrRcdBMYTVCdYR3AkS90MXshsGcfVPEaRgxARNgMzfSp7mOJfjUeROKTipHO8d4NKl31D6WY1/A34d6qrUHjfzYEJYXUIB39y2AoG1Bd1JLxy675ftLlqOLRM32L/v9gzBSgeE/82wnnaDWunSfpHth4W6JDUh00pjqvukg3w8A2/Z6J1/dT2llsNqQZUuKeJOSx+8PF7ax1fdN9ZsDpYry8ynHKhItsDloF4IMsEBIpp6T3o9wbfKXBicj1DVmT4lpGqvdCAe1qbK4lh4TmR3Pd/UWnkCAgcyggAWXZcxg3H3g6NvFBJVVEXL74kYRohyCuI+hJotWyI21/3DlhDWdGnGwQxt1E7RT0i26xoUaEbYRkzFdQHra14jEp/TFfQ4kIVheeeJYUgoDfzRORSyeAjikTBkUAAGUzyR1crVJWmu+uc7ywM3auzyEYGko+RFceNXbeX0D03AIu41TRSUkODElePWLFSjswNjf1GDNFH9Es6Se8KAZ1aMRBGD+2mzqY9W4L+hdX5JMCxWwMbPguCeNyfGyXsgRAzOhv4f2Nxc+9QWJ8mTlvvSYi5xexsH6o4wNlBQyjDGK2X4Uuya2HnGxLUBB8KdboCegt9lsozx4Mtv6h73y8i+uhbQv6R9diClRuR9hDXlT2Yk+VuhkeWCVHEmTQccJa7h3R/GwAtdpqe+WfeM34tXHW4rlAEk1zpxqYiOksvRwdFwon4ZJ5OEmBnohnTWWICyP7/umpmbwssu0jpwdOxzFtr4KmljhPz5LGYxHccK5sFRJfVhIea+bqd4q1OHX1EhSEyzUMia9f9vzxyMObLPNif37jNGXD8eplw5WUOSLfyb7ez+hmV+rKtArE/4X/PdcbhziUCCQycSFgjhh
 InzVQcHW
 nobjzpBJusS2rP4ZFsEkdqv4DfY8OJSaRdFsFg9zpW+an02q8v4uC1CQWZCVREzOB5FYUSXeftsbHZuAf54zGM+0bz4HpQ/5aUo8+1VVuJdSL7m7Rqm2B8tCciphoX3VIWd9VRDQ8/M2KeunpgFjnPqAz8c4YZXtYzj68lFns9VsjKW9k34g5KicOxTPWxeFa9mwrnmlfX+nj2y+rt6Pw+T5iIyg+bwIiJt1rPooAa3V9REoZUjTlvKSZ0QM/EIpTwbro2hpLwKhzFtmL/NpHXNWCoGCORvb0fRTipSGSAxfEGBiTvEi9/6edNNm0ZNCyyr1Wd5aPh6DFHp//pCkYnbIa4zsgwXLQ4QEsCbh/Ih8AdxR4iZkIy30K0Tx4C1/IwuCS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:26:21PM +0000, Pasha Tatashin wrote:
> Extract the logic for deserializing single entries for sessions into
> separate helper functions. In preparation to a linked-block
> serialization for sessions.

It would be nice to mention that this is a pure code movement without
indented changes.
 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_session.c | 62 +++++++++++++++++++--------------
>  1 file changed, 36 insertions(+), 26 deletions(-)

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

