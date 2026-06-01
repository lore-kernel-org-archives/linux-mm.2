Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCD9DCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0DA6B0416; Mon,  1 Jun 2026 11:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3714F6B0418; Mon,  1 Jun 2026 11:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287CE6B0419; Mon,  1 Jun 2026 11:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16A406B0416
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:15:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B23644069D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:15:02 +0000 (UTC)
X-FDA: 84831691644.13.C14B7AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id DE0BB180006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:15:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkiCPUTQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGEqVtoj38dMSfwBAVM8djXmJXRkEyUnL1BLv8lc/cY=;
	b=YPpTUTRwijdsZm6XGt33NdsYK/+KX9ucCrIZGiiJjGftqUYjUWh2xboRY57Ds6qxlgWWWs
	8SAsCTUp5UXVHHuz7T7IA1jBCvRJaRHmuiIiKSYTNz6l2dyF3c0gfvpiB/PlGpwBHLPvrw
	YJzO1fADlCq3jCtp7a6c9ODCa7TOc9o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kkiCPUTQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780326901;
	b=d9gRpgtTxKdA/JwHQrV+WuHdg0uZqdU8DZ6WUKpVPDMO7NemxpKnWTQ3H3FWOMXHjcGi1i
	eq4Juo9r2IZZf2gdLrgdLf5+21xDRFyrjtBBGVte+uXq9NJu51d/DYKLgQIh2/jhJG6Kl5
	fcEvrRdY9oWXTJZox1eYzKzV8lztd/g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8F0042A6B;
	Mon,  1 Jun 2026 15:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F8E1F00893;
	Mon,  1 Jun 2026 15:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780326899;
	bh=SGEqVtoj38dMSfwBAVM8djXmJXRkEyUnL1BLv8lc/cY=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=kkiCPUTQWBCm9xQc2EarFtURpszatkbzrUdKBEBuyLN38qDy3H5l86J/6I8zPqXw+
	 0YUFC7xYc7NgNUuHwgf3PAZ4VgaMNfK3rd2MZ8v6NaX47v1tZVrseQttE2ug0McTTN
	 4bnkBiZtci+8nr3j5t+j64U8xEZjf/JmTpXd5FpPFr/OhpDP1Qcx59ELBZXhRBa98y
	 7Ev/fm2TjNpjDlSjoYtsaE5mDbVcnhsHh2jlOAEHS7kqYMHluUKHKo5cO4ejFAfnvs
	 rQrj/ox+mR+XOiJSMdA/g1haX12tOnwFCn0k92PaM54LH+xlfRz0AH2nmsBo4ePZGE
	 4O7K3KTvjPffA==
Message-ID: <05b73410-5e47-48e4-becf-5170105e540f@kernel.org>
Date: Mon, 1 Jun 2026 17:14:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm.git review status at 7.1-rc4
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20260521195246.c562b881be1d4881a19a9d28@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260521195246.c562b881be1d4881a19a9d28@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: mmokd11qnnefhfj71n3xqcg8qnud6kkk
X-Rspamd-Queue-Id: DE0BB180006
X-HE-Tag: 1780326900-175444
X-HE-Meta: U2FsdGVkX1+C8DnRrHoOh9L/VJB86MBUzschhHx+RSsHElU0orO6TxpSxuJ4wXWb2ISfUvfn6gP+uWUNz1PlUp5MEG2cKhVrpaF8mtuBgG5M5WkI9nyNXZHlOhTJOMD0lYhq84rHKXvOaknuzT4s8NrI+5EJiV75kEQC2dNPSUFgbvU0o6GDgMuL4Cu8m2GQbeFAScLcDKrrs3SQbR6xXSmDRCK82eo2YG2u39ZclLenqkwG6UxJBa9O6nOEdl6CTI7u7WLzjK1wbHPmlqk1eAZJ7IxFtwfJuURQfxPjf6vBGdTq202SybkrF1ix/B+hZ2p5koZ1uTCEzWMu9fRsy6QKo5FbnQ4hUjyAXu0utkDIBJox9q606NEe6EW3c6xT2Wy7VV07mtno7ObpYfkl9sXHpC0H5Q8QM6+k+IZiK4VmCM27CqdGqyQpN4Jj9/a12dylc9vWo2ojM+iI5Hb0y8QHjz8xkDZcdoHglbr8H3u/AiNuAdZVvtPKmGJ4L88U0FDeYWem4E03okF12N+C1UP/LEKaLnwZybtLZYe41hxmTe7gMTS4DgwIFJWZ6xK15g0ECXtcazfgObKQ//itmRFXVX0Dut9CG+u7sM/rjkk56TrixoEfsqoe6jWGWCR2kDcRAog4tzZs/t3RCjqGK2EMJmn3UP9vp49bsppNHgdZWvmw3zvF3gU/2CRSvdIv9AN1aYRWJY98wQRyQ0M8KL1z7ITPrmT4dAuwnTyVsTbvZCsasZAyggYAR6T9NBs2CKyLQiKaxRBanyESyheybMjEhYqEMIiP8oOLcqWIUwfM0RYHA/4cb5f+VQLgbeIz7Hlk08MdvJw/InQvYAmWIMwBUCgCuyKz2izSpwl9+3oBZ8e6R6zZvIhly9VpsSlnUv6wJTFLx5AKxSA5sH26VnOU7jEZ4ehlxEmCg4fmkGRgETZFMeK7JpQJMLxJFsEXRKie1lXnmtGXjFxpKzc
 Kd185x9M
 2c0CCP2kTg+QjlL7eQZd5TBvhcUJENFIv0riNacCoTKUma006IIFDCpj6EHzDaZO2GKw+cVaeTskgcX+26aNj+l128qcvKDhBVZb/cy+mFauXwvtSaFPWFISZeIdcYT7A1ixCN854SRjLK4oS3xOEr9jSkC+EC6igjx1PjhMuA3BkUyRkF2XqXhgUDB4DDQRfcdL6QA7Su/XjdhsLPUCG4R3y6iFGbUkTNaiSdHksWbSSEqOSQJlT/fHZ+24ezJLTHOZD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 04:52, Andrew Morton wrote:
> 
> Things seem more hectic than usual (if that's possible), with travel,
> conferences, etc.  I'm feeling a need to slow down, consolidate,
> stabilize.  Others are of course free to disagree!
> 
> I'm feeling a bit more disorganized this time due to having spent four
> out of five weeks traveling.  So if you think I've missed things or
> have otherwise messed up, you're surely correct.  Please tell me
> asap.
> 
> We're closing in on 400 patches this time, which is a little more than
> usual.
> 
> I believe that the extended "quiet period' last cycle was helpful,
> although perhaps a little too long and severe.  Opinions on this are
> also sought.

Yes, slightly too long IMHO, but ...

> 
> Maybe this is how things *should* be?  Four weeks of enormous merge
> flurry then four weeks of diligently picking through it all, getting
> things mainline-worthy?  After all, that's what Linus does, with
> different values of "four".

... it is indeed helpful to focus more on getting existing stuff into shape
towards the end.

We're getting flooded lately by new stuff.

Maybe people can switch to review for a bit ;)


-- 
Cheers,

David

