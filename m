Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 903FFCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F397C6B00C5; Wed, 13 May 2026 11:38:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9F06B00C8; Wed, 13 May 2026 11:38:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8D76B00C9; Wed, 13 May 2026 11:38:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6A936B00C5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:38:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94B418ADC1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:38:34 +0000 (UTC)
X-FDA: 84762803748.10.BF0DB7A
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf30.hostedemail.com (Postfix) with ESMTP id C49898000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:38:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TsJ8V0Uy;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1tKKt5poEhguNzfDiWMmHOdV70UQ2yko+bYTCbZhQw=;
	b=6tPU1m49n6yz6R+w5I1+wmKWZ4/utc3nGFeiPWWthDtvzPQHGKL1Dr5OcGCVOj1qT16OtR
	dG1TvHhSQ2Q7/kVExa38ZC6fCGWwSpA5+8aSPsqdIB5v70B1QkhtwnftU4SI5UYLJc0mhp
	iyqYXkC2Bz9Pwyd6XQdHO3K8AKTUnqg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TsJ8V0Uy;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686713; a=rsa-sha256;
	cv=none;
	b=Z+eRp+J3wSzpvRU+NrmNMOxs1U2NO4P6EtY8gORuSq62l4/SPppG1Jd19QbwGf1LVRJ5BN
	7XEawiJLIvZm42wc0CkZb8kejMcOfD/Aaz41HNAZNo/4/b2tQdSIYniTRcekV/oGws0jdL
	wEwtxXi1QlCjUOQ3240+KXTB61aqKUk=
Date: Wed, 13 May 2026 23:38:22 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778686708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u1tKKt5poEhguNzfDiWMmHOdV70UQ2yko+bYTCbZhQw=;
	b=TsJ8V0UyES09OmzFS7YpqitKnC2ttNmKnMcWLjVTJbyr/87pK9caGcDItikQVApd2O4Z78
	cChTcK+ARjXvWuRZs/Xk/FcWVnRF8VbhWRpDXg7j6nSr2C1sIEwVWCyu2S5qonCgLVXRvb
	5ALVQ+gVeluhi4TIc//zDJuPMZVZxik=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, baohua@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <agSa7j_6iODbMsmo@MiWiFi-R3L-srv>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
 <20260512104201.716213-3-baoquan.he@linux.dev>
 <agQQCeJSAjBkg5FW@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agQQCeJSAjBkg5FW@infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C49898000A
X-Rspamd-Server: rspam06
X-Stat-Signature: bgxooy3q5upa8h7eiwmnc9uni1rsxtw3
X-HE-Tag: 1778686712-745970
X-HE-Meta: U2FsdGVkX19DCap3j2iwu6a/ucVDpktjISjyuIbyQu3/qvYieJ6h1Dx093BKOYBWH9zf4vuiH+6ODks36cJ1llNUV2bvpcr0pdvevXiIL81LT+aL1MJA+5HqTKAh3I9zh9/c67T3q9ovNIYFWQ4+MfLMUItvj9VfjPKBNLLMS5D8Z9n1qpiqbe03ps+UdZ38GeoSVf5/mtc8RKMbfQAJFssdaOqFDcXbnqgMIr7u0wcg+2V+bMVGQjhLk16jMkOdpvXX8VilPcFpz0QyN8JsmIYPS5hYf7M6ddZK6Jx8NMHuSFc4yRdjEOP1hRj4D4hsku8MWAdle2kYBeFFuMKW1ZCAoNVeVd+7Sr0kk9/DfQUG1heUydK0BNKOrwncbfmyzSU/BWv9xZPs7E4cgkQ3l1MIGdSh2aFhJD+xR5S5IGYLneM0PX6TC3bZaF6HtWuz4YD3Ut2fJPbMc4JOSFiQTSbw+B03hqRSvLHW7RtoUiyXFYDLZKjHtyWUR3T4lSlgqPlONWydA1aPMDMngRjiFLTCAViN4VkS8RITQIljVbPd33fGVvpKgyBuYeu0a+5EB7xvvriZXUwUKJrigcPkoS0b/kO9d9QoeYdrzTTjCV1XbCDcctYPSm2gqpHQpCVVIIT2Xd9bxTuy8rayppunEdoIEs3kTjotJHitYDcH/Hzpy9wpROQmpFWY+uNiyFFjeE77Ippd2i7VCDyzY1jqCJIzhUY/RMFCj+SHXfHsUJyt4EAnl/sLBCqVauz0JYgt+UlpB6/aIXBTzPm/EekEzqrJLhhmhS0bda9P7h1PM2+9tTB4Y5FLTuIbSjfRK/ZlmR9ZGppR5NeTMOaAaU2rMJHyy62tzV3npstTkyu1B26S3ss/1I2Ccxo+KSbACkEYRMnHtekgw2qfcjsl0rPdJKvwzyszSzNn4IYPSPKf2wK3t+7AulRWQOyA8zGG6NwasXZHdAM5Q9mgIqrjsAs
 29PSfZbs
 BwCefYTTaNe7Dt06PO8grPbHunmRpQlHAabLlHT9ZENg1PTj2TAdATMmsdfe0+Q9/i3QTBYp4xOvtPFZcKyJH42L5YooAB8dFUbUmpJ0cqxpDAN+z8tnNYCuWugao2rNT55bO4AW3hkoDBdK69jCSEFyU7DInLa9Q2QYCflKLyRm0J1rVzQ9pQ88kwJCzBxIw6twLLqVLwduVdzchufqB6HJp8Cz6A2xsYq+90/zWXkrU5C+4TrqhuySyKZc4hGlIHQ5OB3d0mnfw8wOVQC2njy3ToNtGP4a3ZBdLgV6JS7I8rdI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/12/26 at 10:45pm, Christoph Hellwig wrote:
> Looking a bit more I also think this abastraction is still leaky because
> the unplug calls for fs based swap aren't properly abstracted out.

Right, and this can be easily done by adding a unplug callback in
swap_ops.

> 
> (note that it would make sense to use them for block based swap as well,
> as building a single bio will be a lot more efficient than relying on
> block layer plugging, but that's a separate issue)

OK, look forward to seeing it from your post.


