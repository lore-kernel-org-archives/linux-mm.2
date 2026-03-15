Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE53F3027F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 22:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B3A6B00E2; Sun, 15 Mar 2026 18:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718EA6B00E3; Sun, 15 Mar 2026 18:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641CA6B00E4; Sun, 15 Mar 2026 18:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 52A0C6B00E2
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 18:20:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5B19160C00
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 22:20:41 +0000 (UTC)
X-FDA: 84549717882.14.60139BF
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 405981C0006
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 22:20:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hMVBbVOU;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773613240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67C7cHn5h7407y7nIRKTNTNjbKB55wp81ekJO/EFaWM=;
	b=f9QwSlEW906nCpMQH/dF//8c/Cqj5yIpkjmwo5sgXm8En3pHojkmDHsTsIuKI2A3EYPvxK
	EA/du4Boa21/GF27nB6oZZlI+yVE9WZsz5DTmjD9InuuRA3QSyTcpbAVZUJtlxtRb1EmeN
	rMEl51GAQ3FmmukAHQQwoMExajlJPU8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773613240; a=rsa-sha256;
	cv=none;
	b=wrFX8atT6XZVVijmS0F3T7Swv/AWseMQJIt/vRJsJ49mdtMDdHWlyudpUcKLvifOA/FD/v
	gjKuI7GNSF9tOaxc/jaRYDfid5IBCl43m7gWrPEP4ramw2F+1Mbh7e1gBEQuK+Mn/iol9J
	rLv94V0T3g/q3zjHH0iBtj66j9Y25bQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hMVBbVOU;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773613234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=67C7cHn5h7407y7nIRKTNTNjbKB55wp81ekJO/EFaWM=;
	b=hMVBbVOUoBXtF/NEY7sXF0ceC2nQR3+epUdIKpinm0C9nAcof9vd9e3FhR3xtCg2QeCaNa
	5+8B+nSlExsb/Fr6FymytEZPVVKvl3uav3MZlH2vFTcHd1C9UQQEnHe5LdUx0nzD7IvTbt
	JSue62G7anP3s2B58l7ooZgieFaR8jg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/damon/stat: monitor all System RAM resources
In-Reply-To: <20260315001809.77161-1-sj@kernel.org> (SeongJae Park's message
	of "Sat, 14 Mar 2026 17:18:08 -0700")
References: <20260315001809.77161-1-sj@kernel.org>
Date: Sun, 15 Mar 2026 15:20:30 -0700
Message-ID: <87ikawybtd.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 405981C0006
X-Stat-Signature: 1umbm5du3dkameyb8rufe9rqxiwaa4iw
X-HE-Tag: 1773613238-952586
X-HE-Meta: U2FsdGVkX1851GoWLfZk5CFa6TehEXGEqYbEF2bWAtNJeYsf1RLjzulTjv1viXdtbcy4phvlWt/aTa8xNIfzqyHTQafdSaqZbkczqzCRzyIZdoeIcaZu1H2RRyDILrvh2LeBIVc/TUtNJrkOWC/m3Rz0XltA6MZ9UjLYMhoVaOpK2EAJeCAQQubtphKUo6858rULX5d4hCTiIYuYAOyXFkhhRIItoS/UoSwduEyrlcxDjllTxyYErAzh/i7W+7KkXzIHt9B7nDmQae4/jNaWFopXkE+Bs4nG7byxe4mWf4Ln/vQJlg1FHeOueYe+d2qWrGAAbkCiquRwg8vKEFkS+nI7MI3Q3Id9Z7TYua3DLzirm4Xp8BiA6R+2GDYgiAkAUOlCfEufAqXjd+kDkQpgFMNdFAJk9iRdmgH69H3b9TzIaVeNgI2r2q9dBvTqw3ax14nr/KuEI6lxX1m5umxTTs8oZVFzd3/tUuDBV5m1BrnX6ZtVB1ZQDDaA6yePsJO9bTBTuqG5TZmy4Mvbbik1EKgqJw0JnMl936RFse6N7Kf84B4wvUDru1HHphv8JqEf7NpU5LFDvlck5Yf2j17Lp/nbjIFFTqy+r0uSe0sVfmaIGtosLExcUj1xOrmDauwBA8Uf3YYlIGOtVmT9vp+xnFp1wNAxWBB2/K3cVNLYMXALA2JpCXSu6SZvyakpbycSkRHDu4BMx80+QyWrlY7gQ2CMf5X2+ZFqT9+MYsx4wEEVWabbwfZe+nqNuHkVVl8OwBFVm315aivOakYoG3cY4jT/jvgxJbT5gl5fFdzrif2CBY+xLstNJUuXkNgx28U8FZW6zqExL8wV7jWIKron0HLf1NURpVMnUxMfH1vIq0OTho7uGe+kWlD2D6d/qMrv3a1zNXosv7zkkoCoXuHXAG4/DqS9mTm8TBoEUXCrH4DCaE5vLi6fhwi8ey+7Vg5l/hoAnVb4+XFZ/8fx/Jr
 KoLxeI0m
 lZmKVkJ5wlo8X7qNg6jw/pypEzCLr1hVia8i5kn3UFUUzToUGkJMHDlvkzQpOIIPm5tUtMIDTRKOhPitTffvSk3ZEiuu+7O6/GULeOzPwY35YhNpsbDGShwrBTjPvU6qCTNifjsqOBzKYUeNIijbLpUuJCvNWSmnd7IsJlGN45mQq2mNFOLb0RlgqO6rH8PC0GccjPanqjyzTD+KNsRuae/oQ+Y8pGU/A5eLSjYUxu64KInVutFjoZ9z8izFaC2T/TDMQnq6HAozvrb140jkKm/Zc9hgtdtRFJHS0UY/HiZbXqipe08b56Rd5iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SeongJae Park <sj@kernel.org> writes:

> On Sat, 14 Mar 2026 15:51:09 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Fri, 13 Mar 2026 16:40:22 -0700 SeongJae Park <sj@kernel.org> wrote:
>> 
>> > FYI, I found this issue from an AI code review result [1] that published on the
>> > internet.  The review also added two more comments, but those seem irrelevant
>> > to me, so ignoring.  I don't know who made the web site.  I only got the url
>> > from a social.kernel.org post [2].  Whoever made the web site,
>> 
>> Sashiko is being led by Roman at Google.
>
> Thank you for letting me know this, Anderw!
>
>> 
>> > thanks for the review.
>> 
>> yop, it's good.
>
> I'm now a big fan of it.  It is really good, except the lack of the dark mode
> ;)  I therefore added features [1] for showing the AI reviews on the terminal to my
> mailing tool (hkml).
>
> Anyway, this is really awesome and helpful.  Thank you for developing this,
> Roman and the team!

Thanks, SJ and Andrew for kind words!

We just launched it late on Thursday and my plan was to keep it under
the radar for a week or two to make sure everything works stable before
announcing it publicly... But it feels like it's too late :)
I hope we can keep it running well, but, please, don't expect it to be
fully reliable from the first day :)

Good point re the dark mode - I'll add it. And Sashiko itself is 100%
open-source and available here:
https://github.com/sashiko-dev/sashiko/

PR's are really welcome!

Thanks,
Roman

