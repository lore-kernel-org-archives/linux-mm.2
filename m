Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C79C10987A1
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA906B00D2; Fri, 20 Mar 2026 11:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1B96B00DC; Fri, 20 Mar 2026 11:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E886B00DE; Fri, 20 Mar 2026 11:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1067E6B00D2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:56:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3B39B7654
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:56:33 +0000 (UTC)
X-FDA: 84566893866.20.ED54366
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2A2FE4000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:56:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b="bn3Bg17/";
	spf=pass (imf27.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774022191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CA+8hnD1UcyY5V73KLuUWNPdACXCtzhVUU8X6g3h/pI=;
	b=EnxWdXzvIwqIEvGk4uCI1X7pXaHj2urzLsVKXUHlbxtsRQ0dbW6AkFnL5A9ESTS+i6f6lT
	AwYEv2GS/bia1WCzDw/9ELIU8f9VzAT8+/4+4Tx5oRwx4Upc6oE+4QRC/tJlrOFiwDJ7YL
	gpGQ5EGxhmIP6bvcwk6Al8yS6fxUWAM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b="bn3Bg17/";
	spf=pass (imf27.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774022191; a=rsa-sha256;
	cv=pass;
	b=LL9okM1rom0yk+MyjkAtnApRaEljpZVfoFyYI+kQjTdqCuvNggO2+fs8hlPTqb98ISrDqc
	oixiIY2cimvorjAjjhjPOTsUCl4ln5xqcayGh9263gjEVqNu/P/wgMxKIBomxhagFoQAqD
	ZtoL7n/VBd59J1RdFyssw+jwmQ72K/Y=
ARC-Seal: i=1; a=rsa-sha256; t=1774022171; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=GvM1y9O7vXkIlcCHrvTBJtnv9HCQV4Gc/c0zB74+2dB9SSYoBC18N/JP6Rtz+oK+2jvH00Bfv2IguP5GkWiYHAGZnbmdVzsITZ7U4PfuuZJ4hKl4yZnspmLxhaof3Dkc3tjB7oXNdeQzAbOwMXXHdGSVQ4HlcE8pzS3oGBiWnc4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774022171; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=CA+8hnD1UcyY5V73KLuUWNPdACXCtzhVUU8X6g3h/pI=; 
	b=kQ0gDcoQsX9q9f+AhuNhazwq8AHv8/Oe1nZaAQYnV8uBDwWrlMjadBB820LR0NxpyVb310A/Endhty1pcD4JpFpY6kK1Z/BjtLqxhZhCQ2os6B6ctqF1pKfkn1hvIk3VIYDDE+e7zfJYlQt3Kh87LL5rWWbEDbLesFmHEKllF6s=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774022171;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=CA+8hnD1UcyY5V73KLuUWNPdACXCtzhVUU8X6g3h/pI=;
	b=bn3Bg17/9HkWaxtWz8egaSn05oV6OjxGB3ufD6xBy4RG1mT4kMZ8YhAyagwBNebZ
	FXv5c+17OnuT8rlXwXR6eYdyNzrCIc06Y50QrPNmYECUh9F0zl5vDTfrq0NKLh8wKsM
	wzCdTrQjBatcthNN2D/2Mc//3nFu9tz0MokOrQkg=
Received: by mx.zoho.eu with SMTPS id 1774022169790495.36152178791474;
	Fri, 20 Mar 2026 16:56:09 +0100 (CET)
Date: Fri, 20 Mar 2026 15:56:09 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_2/4=5D_mm/damon/sysfs=3A_check_cont?=
 =?US-ASCII?Q?exts-=3Enr_before_clear=5Fschemes=5Ftried=5Fregions?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260320155115.101025-1-sj@kernel.org>
References:  <20260320155115.101025-1-sj@kernel.org>
Message-ID: <E4735091-5CE2-42C7-BAF8-B74E49791829@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 2A2FE4000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 63qtpf1ysae4q1cbbrgpg4y187fw1x9g
X-Rspam-User: 
X-HE-Tag: 1774022189-842291
X-HE-Meta: U2FsdGVkX19xIECcftnmlmZStzwA/zTEhjFGTYRqiT1Zx81ebdC/7H59dXbQ3AYBRZTFGYCBDm2RxJa9qT24QYGIkSshSlpn1GnkmSyPzdV9+2EmVDBF+c4Ka1+t1Gwihs+SocpSox+kOl5Y5U7RuPNZb5OzpmBk2FMy7cMob/tAGDc0WISlmyOndBqaW7YD2hqmFScy5O9L1WrS3VXkMTEoutiORh9FHbG0A0Qyyld2loZECUibnNrCcH3IZLpCovteBHbDBuGLfVNZRB6GIOGijNGMP1JNxWU421Vs4sJWUl7W0nYxkuUpoz0LOeBAwR2yO7AA76NtEYh2CtoJh/TgkmQflHbgOzi5eGpdLNMMmASPEIpKpswgqJIiCJUbo23RkOEZNDNrMMNJF0i0AKBgvOzHGx0F1i5RHSFb/RcsDjUl7H1lncKPmorJ4ZoIfHpcnXRx3tHf3FmcyaSttaAK+zY3Bd2Zlf3hase1/4xkN27p9ndm+KTYXo8368D+tA0vHbRzQipWphz9pW6x8wLWOmid1UjeDNNdjBUY6GaPHeeU2KuKAPjf9eb4qPU/tX46HNprBXGXTWdQer0OZ8Qjw3fCvzcIIBo9mLqFPbtrd+Kc8xD2VLE9T3Bs6fRIwbUyE3rEOfRkN1cCqm5632ShADbSAY1F5+oB321d8BIT8WvfbXNwFsqZ9I0E6Zy7XTayJZeiCWclMxqHKwkAB/JAdwpgrwJsLl7fJHli6+/EGJTu7Fn1qaHjHDJeiJzQi1uhHAvpm83h5nX24vDYzof00xOaodcdTLRSyaEI/37vh/wQYopioYoiNvID62N1pcWQZsYZSbZ8Tt3cKhHCqiolsO14csC0aHRI/lNZL142m3P+/3rfJp5AODW4FinkalCRiaz6e1dltH9jzR7DGuuldzUsIjM/3o2azSPwEukHSGwXtkcgMQyzIMMfSBPQxbL4uI7Hl/apKo4fvsi
 xqG3oMSu
 tThvWydZh4NKhnndzXK8yctqh/Qu50JSugw8RXBkpoojsUsV6CdVfPt8lsf/fPPZeKcJAyEnwrlFymz1dwWEDKlyHl6y1VmyqHafg3Ne4N6Vmelm09GCT6SYNeVw+/eYM3PGvTZnCo+Gv2V99GKjdzZm2X0gy27YraP3Oxne/pq/tYiTqldglxxxn8sVEerVr821ZVr5aJ5chmVTGeVa5xoaLVH0pAMpVV/iGdYVys72/ZzDlySFjPiGJgHwyxk/TwaNtYjhRcFEdbSfxnhvBoFaXwkuh+XSn5/QBr9h93GWsceffDBJNKQ6IK9Bxa70qgX+skQGp7E8yOynyuYt06N5b4AXO68ec1bvN5Hgq2jInhIScqWIZ8VgpuqrfTc+7/l29zDy+RJ7v8+YpUmvgmv5vBunB0Svrd8+LghDl+kMWsYfiI8ceYl1DANv50LaLfqfxNQ2qnC+yCgUW477WEAu0OiVuSE9F8NSmzMsHMKTJe1Zh9dK+L9uSABEvekd6lsdDrS/nXg+TKvbJ75ZIK1dmxs35U2isuJIKybUs+D0bvNdJnpps8zEfDCtey25DCd96EmyzAafgf3rMsCOwfvBndw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 20 March 2026 15:51:14 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Fri, 20 Mar 2026 15:14:54 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>
>>=20
>>=20
>> On 20 March 2026 14:47:40 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>> >On Fri, 20 Mar 2026 07:06:48 +0000 Josh Law <objecting@objecting=2Eorg=
> wrote:
>> >
>> >>=20
>> >>=20
>> >> On 20 March 2026 02:13:17 GMT, SeongJae Park <sj@kernel=2Eorg> wrote=
:
>> >> >On Thu, 19 Mar 2026 15:57:40 +0000 Josh Law <objecting@objecting=2E=
org> wrote:
>[=2E=2E=2E]
>> >> >Not necessarily blocker of this patch, but seems all the issues are=
 in a same
>> >> >category=2E  The third patch of this series is also fixing one of t=
he category
>> >> >bugs=2E  How about fixing all at once by checking kdamond->contexts=
->nr at the
>> >> >beginning of damon_sysfs_handle_cmd(), like below?
>> >> >
>> >> >--- a/mm/damon/sysfs=2Ec
>> >> >+++ b/mm/damon/sysfs=2Ec
>> >> >@@ -2404,6 +2404,9 @@ static int damon_sysfs_update_schemes_tried_r=
egions(
>> >> > static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
>> >> >                struct damon_sysfs_kdamond *kdamond)
>> >> > {
>> >> >+       if (cmd !=3D DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr !=
=3D 1)
>> >> >+               return -EINVAL;
>> >> >+
>> >> >        switch (cmd) {
>> >> >        case DAMON_SYSFS_CMD_ON:
>> >> >                return damon_sysfs_turn_damon_on(kdamond);
>> >> >
>> >> >If we pick this, Fixes: would be deserve to the oldest buggy commit=
 that
>> >> >introduced the first bug of this category=2E  It is indeed quite ol=
d=2E
>> >> >
>> >> >Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
>> >> >Cc: <stable@vger=2Ekernel=2Eorg> # 5=2E18=2Ex
>> >> >
>> >> >
>> >> >Thanks,
>> >> >SJ
>> >>=20
>> >>=20
>> >>=20
>> >> Hello, did you give Reviewed by you? Or not=2E=2E
>> >
>> >Are you meaning Reviewed-by: tag?  If so, no, not yet=2E  I want to ge=
t your
>> >answer to above question first=2E  Could you please answer?
>> >
>> >
>> >Thanks,
>> >SJ
>> >
>> >[=2E=2E=2E]
>>=20
>>=20
>> Well, two is in the same catagory=2E But seperate fixes may be best=2E =
 Because patch 3 dont call that function, so it may be screwy, i mean, if y=
ou want me to=2E Ill guard it=2E But its a bit on the hacky side
>
>I agree there could be more cleaner way=2E  But these fixes need to go to=
 stable,
>so I'd prefer a change that also easier to backport=2E
>
>So, yes, I want to=2E  Thank you for kindly accepting my suggestion=2E
>
>Could you please re-post this series for the first and the fourth patches=
 as
>they are, after adding my Reviewed-by:, Fixes: and Cc: stable tags, and a=
 patch
>checking kdamond->contexts->nr at the beginning of damon_sysfs_handle_cmd=
() as
>I suggested?
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


Absolutely!

Will do

