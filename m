Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C4EBCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F1B8E0022; Mon, 17 Nov 2025 12:26:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76748E0002; Mon, 17 Nov 2025 12:26:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8CC18E0022; Mon, 17 Nov 2025 12:26:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 967E78E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:26:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44E44128E9
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:26:52 +0000 (UTC)
X-FDA: 84120779064.16.65C42DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 879531A0005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:26:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rcpbsi6S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763400410; a=rsa-sha256;
	cv=none;
	b=V9vLzlGXOGdbOEinCODe9l84W7oDmnvtpSFpPVBoO7njoXmLi9h8cq+uMPuweM67C5TyJv
	B7zms7ug/7ee43xACgX+D0iB+BvQ4F0K96atd+THoKPAE5X2dNdHZTtXG4TmyedRQnl+tC
	zF/xN3G+RiZlM8hrRl+N5KT+g0X0oh4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rcpbsi6S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763400410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ExTLBdzou9grekzPtW9sigBvrW9pW1gImgkcVJxqDSk=;
	b=hMwG33N7NjyFcXhDl5Pr6Kjh9vaPDiMZiQLnUSaG1JgYCUC+beedeTSbAUc5fZiq9xYsVa
	6e1VwHq9i6wkTOfG1tKrxBOjX1PhNpu8RqT3Khh4Dwwt7WFRNAQ4SmuoidbpAd5frp1NWh
	MbdQx/pwspZgpyF46VVZFNpmg/rXqqI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CD18A60051;
	Mon, 17 Nov 2025 17:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8862FC2BCAF;
	Mon, 17 Nov 2025 17:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763400409;
	bh=8X35UhndyCd0W8jU+3HwbPtq+D06FpwY8+INQy6n0iA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rcpbsi6SNMX7lI+gCRi9tB12+6ty1dPVta2IV0vPOBrQxrslOdUs0hk/5kZpVcHPh
	 FAfEUWcXwGsiDHaFKrrFjLUXvn3DNapySn9lcICUEK+yCeOVpNztG/nrc40S2oNs1T
	 51DQCM737IMHEukQVkwJTKxCX48yfVasB6lgBV7Ue3qyLhTUXCyKbbxTsYLGbScsxF
	 TKSP3j5WF1vyO6XWxvDj00WIZJ63h64ETHDUvLkJDvA5fuigOlIl2/frPi2ADwNMW5
	 YnKDYSN704h3HiqhXvcwsBQB27/G7qja+buLo3gS+nr3Gqxgw/43BqAMasPRDCcTnr
	 jUuixny80PB2g==
Message-ID: <bffea226-48fd-4d51-a38f-e79a823deb16@kernel.org>
Date: Mon, 17 Nov 2025 18:26:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/10] docs: tmpfs: remove implementation detail reference
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <707886a5ce4afa4c54456ab2ad8dfe5ba0d86086.1762464515.git.luizcap@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <707886a5ce4afa4c54456ab2ad8dfe5ba0d86086.1762464515.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 879531A0005
X-Stat-Signature: fwttg436obdfkxm8zrkjns1tcpruaazz
X-HE-Tag: 1763400410-459888
X-HE-Meta: U2FsdGVkX1+Oz/f21CoKUVRyeWD7wTCJZsmVUCWDca+cKYKHVAnxK7sx/bpmM6WCwEqHwBmzWiDLYmaOuV31VB1Ct0azoss4xNO6gqitziqwxhD3ed5O0r2suKYRGQo7WHpq8kZrUk/ba2EFNMxifYdOHRTlWpKqrxtKShiqdErQQng2AoIk6vjOnY51GU8gAsOxx0NonXphBrja3hK+C/4L6gTn7W23QlX92yG9M+a7MNXLWNPi4DWmagWxDM+cmBEWAkP9Trxmp9Dgl30rlFeEgNtFab+YTw9D1YT0723T75x1rXTcYD6LLckTSac/e0rjs9WpxQKMBIQySaYdHJY8Gw0lT6AQUZHb0OTQvuVATh35+6rrFa0aR1BGCScH+IOPaBgxs9U+k2SitlDjfVaPJmZ5sIuhzr8Jzb3RdmddLgwuldzZG5ZJxSN56qEpBBwnoVB+L3ezfb+ZumruYpSecbWwUshxXvX8fOlhFSuBoEaDWf5Iph3ZppJkValbU8shqSeSOkPwb3p72mM9s9dnhLPTHODPBJZVfmdG6vTyO4zQa3JFAWifUvL1w2fmL6mdosfQMOTf0LLjtQq49dxjZacOwzu52OYqbFfFvAI/J9z/DxF2IQLmTZJhGXvVz1ic1a2SOM/CvbvtFRlrWg2qwwTz1/wBeOXzPJ2n4OCzZ6IF8OfPoqS7/psmNUQuOIXWw/7+ueLXop8IQk83JCO0PQZiK92GkTD4EybmlZxCsbEtYf3Q+T/nToEi2MBMNZA5mR1kp5cV8qSDvFdSKTmUbYRcx8QfT26mT0NOZzu8rXFqC4QMm1gt3cEVyIHzt8m4JPrHdqTPA+FcwOgMHD/xE5s4yGhi5ervL5BF4rqMjv5MEXSl8xfeeaiHPWh9SU+vJykozItHa4VjoFDmj0ap5lRmHkBgH4hHYgIzRcogO4InFt/rxaOHbQrOCVXzThbGmMYinKIe2T3xIZD
 NahMaEUe
 EspGoIIMcdxrAKAZwH2Wv7mThU1Jh6YOE3BZuQJDf/Gt9X6UuzNffk94kA+i2/w5G1HisLvRltpJ6+bFbwhSUFfS7zKgGb1qOhjLxV/a36XAoyTc96ozzvNvaRXYj1bZKJLR6OL8vGneWDJT6e1cfqn8FrmqtQ6/Pr6p7j4G/3qfWT+gxmOzSi8NNwqdTl6RSHlPAGIsL0i8/xZnffPmqnny3iwXvgH8yFVve8oac4QlpFijJVL+Gm439zSTEfpiUidaBWK2mHS/jhtTWFJa9abDkByhhAEJ2W8o9MsGEu0q79o8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 22:28, Luiz Capitulino wrote:
> The tmpfs.rst doc references the has_transparent_hugepage() helper, which
> is an implementation detail in the kernel and not relevant for users
> wishing to properly configure THP support for tmpfs. Remove it.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

