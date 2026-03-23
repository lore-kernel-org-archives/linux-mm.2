Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56B0CF46139
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93B86B008C; Mon, 23 Mar 2026 11:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43EB6B0092; Mon, 23 Mar 2026 11:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80E36B0095; Mon, 23 Mar 2026 11:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2FD6B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:18:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 462101B9218
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:35 +0000 (UTC)
X-FDA: 84577684590.20.CE845EB
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id 63F90120002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=ETXMoEEM;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf29.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774279113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y9ESIQooWXRGmMBVhYDoop22vq6zrlFH2hRBQeNf9v4=;
	b=UrXvzG9ZJ57uaNBLFpJfuLbDc1TkXEIR+84EQb+BBWCNRXZzqudHVhvhTTH6A4hExfga8j
	UsYuPHSf0G66t81u+4/fFk0FrgImwXXrQqPIXnxBBZkYnClV6UUmhK2coRgkeW+BO6Lgbs
	Dmlu4U9qLh52vJzJckf0H/Dk/fhu3k0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774279113; a=rsa-sha256;
	cv=pass;
	b=cZHNufJWT/PuTFGqcp/HEfR87m58ZoQmR3Fn7HkaUfu1PGEXJ4oEFtDMtZ2N70UsTjLUXX
	xM8ebKr+CAjH3CqYB7l2TshU0qrrmO758f9fOCrAbgep6GtCyPxWrJCpRsNjMVspwAvPUG
	NnBal1fAGsSBo3DZSgA+6bJZ1D9CVI4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=ETXMoEEM;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf29.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774279101; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=iMzGlbLMUL3oZM2j1/p+AOJS0TxxiMCpm4NvviM7OXIaJWcJYA2Uj+OzZq5xVltmzp0l7h2kCxEnleofSlKdeGqE+NcqE/cJU+Bcqd/fR4MAeuL6+LrXjMOeEncpjrCLfW/8vR/OzpzP6kKAyROgTy9MzYIGihjxqAdQYQJdl0E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774279101; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=y9ESIQooWXRGmMBVhYDoop22vq6zrlFH2hRBQeNf9v4=; 
	b=PlZQ/ha+CvQ7WpcjhTMkpV2kbIRaHl5L1PA4oK/9dJY5bL0a8SV5+sbcBVSo27WyE9+xa9ZQuwCGf4FtG3wi7reb3rrVccJcQLQmGNxIAP33ktVUPt/w36SN586BM/ca5rgCWmFwmOC6Ivfba9V8a3vcpG99Zou8qoZapU9aTHg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774279101;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=y9ESIQooWXRGmMBVhYDoop22vq6zrlFH2hRBQeNf9v4=;
	b=ETXMoEEMn6pq1bQ3fhTsQIuYNIanASqLInTEnEZu/y2h2CvehszEbJN9QYnSlzMM
	Q/84EZpqVpXAQ+oyoX4whcgjjUXrSrAml7oUiyVYSgP7M7E1VrXecv3on5vywW0WseY
	TQdLwSsDYgJyAbehv/uMcD/pRKryoIodtpz9jvJQ=
Received: by mx.zoho.eu with SMTPS id 1774279098669283.4803668678818;
	Mon, 23 Mar 2026 16:18:18 +0100 (CET)
Date: Mon, 23 Mar 2026 15:18:16 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/damon/core=3A_optimize_kdamond=5F?=
 =?US-ASCII?Q?apply=5Fschemes=28=29_with_pre-filtered_scheme_list?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260323142051.80436-1-sj@kernel.org>
References:  <20260323142051.80436-1-sj@kernel.org>
Message-ID: <43C21A6B-B27F-428B-B65C-1BBC9D66AF38@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 63F90120002
X-Stat-Signature: rqakuzhzzppzrsihqpazqqtnztfqrbx1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774279113-50263
X-HE-Meta: U2FsdGVkX1/pPQ6ebMn6e8C+JCz7ITbm6iT+4IUUeXIHQ1JFmBSyi6YYuMDyv2DISI+cgIgwJaBV1Q2mv+S7XszBajA+R2Jna4gqhmAP5OIbUdog+nlbuIZ7NXQwM7PV3Es5lZsp8M4rUlYvMEqhuXkWDZTRvZnYb5OHhx4W+ooC85f7heqzAN+L4RaLw8Lk4UGhSPExeOIPzgLmgS29tO1YwuIz6mnQEuoR2LLWcD/PS4tklARyL0uGHOuaSE7RrJG4a/orxG/S/pc01yram/F0OT5gD5Bi6VVi12O2QTQfNBQlm0HCS/oIEsdhnESAg8HXxPM2roF8MUze3GNfMO8SdGdZPvhS7cuPrbt3NLfdM7VUkWE5y8JWS6EAX8v3RQ+PviZccwRzz3GdGBuJMaF2tFniiZKq8eimInHq4ziwE1ZUYo7DpeTNmEVURw9jhigLn9tnjFNHZMgAMQGCzD/s7XOAclMlY1/S6DtME2/sj+7wpT0OWCH1zUDa7DImsg9/ooW/VWrIGEMvDAs2X6/uUskQIspV1DsV1JSw1pCOBA7X8x+qBWQqotNBA7tbHel3kzNGta9nETf9HCjLDARWt5RAbtZ5d13xNf4S4i25Ac9OxjdF/HLrchGo5viK87ew9wFSw7M9MCIS5uusxAob25syfwUMNtoRanKUt2E60i/KdtKrRfYN71kWuvfAvhRor1mLZQI2csGMYi7C+Vymv4gUvSg/pu99F3LpTNVhB5JcCv7DRmPKbNZ6kt/blYHnSurdtLZX425Ixy/yEnnDI/1hlFYHe0A91JEEFpiko+C49xElR9h/9rMr1wX7E762NDVwWUzJkCMjDw7ZYecofOa+xMgsaLiz8duBWAQbC3bziuqdxIfHS4OP+hCJxyUGic7s91ykEl7Px+shNL9krKfaMwvveSaeVGFHeoTXlA+3woVuCmmuPRmo2NVwTD/2edUie8sce974xdK
 mKsu3TeR
 HhALLwF7aCffyerR5Jy+yOwrgIzJ+XUblYTo9osR+Gu77aWZxmfF2hTh3CLyLY0F77YVHbEFo43jv6JFWn4vjgllr3FBMRbU49BiMctHCSpuqXOSafsjuDTJN5iruURuC9Ql2o0nJoMZ+ikl3CvhYK5ikow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23 March 2026 14:20:51 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Sun, 22 Mar 2026 22:56:27 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>
>> Currently, kdamond_apply_schemes() iterates over all targets and region=
s
>> for every scheme in the context, even if the scheme is inactive due to
>> watermarks or hasn't reached its next apply interval=2E
>>=20
>> This patch introduces a pre-filtered list of active schemes at the star=
t
>> of kdamond_apply_schemes()=2E By only iterating over schemes that actua=
lly
>> need to be applied in the current interval, we significantly reduce the
>> overhead of the nested target/region loops=2E
>>=20
>> This optimization maintains the original Target -> Region -> Scheme
>> behavior while providing substantial performance gains, especially when
>> many schemes are inactive=2E
>>=20
>> Performance Benchmarks (Filtered Array vs Original):
>> | Scenario Description      | Speedup |
>> |---------------------------|---------|
>> | Mostly Inactive (2/10)    |  7=2E5x   |
>> | Half Active (5/10)        |  2=2E9x   |
>> | All Active (10/10)        |  1=2E3x   |
>>=20
>> Signed-off-by: Josh Law <objecting@objecting=2Eorg>
>> ---
>>  mm/damon/core=2Ec | 28 +++++++++++++++-------------
>>  1 file changed, 15 insertions(+), 13 deletions(-)
>>=20
>> diff --git a/mm/damon/core=2Ec b/mm/damon/core=2Ec
>> index c884bb31c9b8=2E=2E3b59e72defd4 100644
>> --- a/mm/damon/core=2Ec
>> +++ b/mm/damon/core=2Ec
>> @@ -2114,19 +2114,16 @@ static void damos_apply_scheme(struct damon_ctx=
 *c, struct damon_target *t,
>> =20
>>  static void damon_do_apply_schemes(struct damon_ctx *c,
>>  				   struct damon_target *t,
>> -				   struct damon_region *r)
>> +				   struct damon_region *r,
>> +				   struct damos **active_schemes,
>> +				   int nr_active_schemes)
>>  {
>> -	struct damos *s;
>> +	int i;
>> =20
>> -	damon_for_each_scheme(s, c) {
>> +	for (i =3D 0; i < nr_active_schemes; i++) {
>> +		struct damos *s =3D active_schemes[i];
>>  		struct damos_quota *quota =3D &s->quota;
>> =20
>> -		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
>> -			continue;
>> -
>> -		if (!s->wmarks=2Eactivated)
>> -			continue;
>> -
>>  		/* Check the quota */
>>  		if (quota->esz && quota->charged_sz >=3D quota->esz)
>>  			continue;
>> @@ -2476,7 +2473,8 @@ static void kdamond_apply_schemes(struct damon_ct=
x *c)
>>  	struct damon_target *t;
>>  	struct damon_region *r;
>>  	struct damos *s;
>> -	bool has_schemes_to_apply =3D false;
>> +	struct damos *active_schemes[32];
>> +	int nr_active_schemes =3D 0;
>> =20
>>  	damon_for_each_scheme(s, c) {
>>  		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
>> @@ -2485,12 +2483,15 @@ static void kdamond_apply_schemes(struct damon_=
ctx *c)
>>  		if (!s->wmarks=2Eactivated)
>>  			continue;
>> =20
>> -		has_schemes_to_apply =3D true;
>> +		if (nr_active_schemes < ARRAY_SIZE(active_schemes))
>> +			active_schemes[nr_active_schemes++] =3D s;
>> +		else
>> +			WARN_ONCE(1, "too many schemes to apply");
>
>We may need to increase the size of the array insted of just warning=2E  =
That
>will make this code little bit more complicated=2E  I'm worried at mainte=
nance
>burden from such a complicated code more than the benefit of the optimize=
d
>performance here=2E
>
>If this is real bottleneck that bothers real users, we should optimize th=
is
>even if it makes code dirty and more difficult to maintain=2E  But, at th=
e moment
>it is unclear if this is a real bottleneck=2E
>
>I'd suggest to hold this for now, and revisit if this becomes clearly a
>bottleneck of a real use case, e=2Eg=2E, a user claims so=2E
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


Yep, ill shelve this at the moment=2E Thanks for the clarification



V/R


Josh Law

