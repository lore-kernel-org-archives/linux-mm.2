Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFFE8D58CA1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 21:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA99C6B0005; Sun, 22 Mar 2026 17:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A606B0088; Sun, 22 Mar 2026 17:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B700A6B0089; Sun, 22 Mar 2026 17:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DEF26B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:32:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BC7CBBAA5
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:32:43 +0000 (UTC)
X-FDA: 84574998606.20.2D6E4DC
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id 36551A0002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:32:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=kykmHEEO;
	spf=pass (imf15.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774215161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gj+dzsGVi7TSx5K4xQwq2AxIni5W2zhxGVIg45hd5A=;
	b=l/9OfnoUQn7rbTrpoaHws8WFM+3PsBeW0ynLK0NzbIHR+nQAfx+MXcayawBxnb83xxtbzV
	M+cvTWXMX0Nkk0hsKXm+FUpF7n6t1wdwoMF8zDQbaTQpdfuZP/UlV4Y66hkXqceWciMa6m
	CjzlANjc2j33sBaDXSz+obMyLlgYM58=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774215161; a=rsa-sha256;
	cv=pass;
	b=Op3fIFryS78aSzuHauZKLfmdF/ATHICs7SVDouAI1O1/fvEnp3np9IlG/aoRfu22Qra+8+
	M/Bk5HdpXJ3y2FO4AzC0QRSenAIJW18H+Wr/ZszRQP/6/Dtmzij9VtiqNRzDYa9ZgqM07R
	dhSUb6Kz8ENyfdNviAKKiFZLxBdtE10=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=kykmHEEO;
	spf=pass (imf15.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774215148; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=dAAwTcEtXVznBzEBXgLetog4yhc7R9MkvETetVFJ6gfUmsSd5Qgi+hYduufHrlO//Z1kZ6/4BsNJBcHBUX7FWveEJaFRvkLz9LOua8n0vvkl38+gXuIDgf9SRYOmD3M6l31XanOubeLbGciWWzg1wvGMRI4TI+Jl/CY4d7t9kEQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774215148; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=9gj+dzsGVi7TSx5K4xQwq2AxIni5W2zhxGVIg45hd5A=; 
	b=KfRi4TNlx2mKPyYQL9YVsz8haOEjykGYe5qnO1blKRfs2kNYj23WUe1tZvBpV2Fl30+YGxg2f0Alrv2jof57WBfBeZ4wkYgTA/F8HJB5S4fPOVaoUtmnQCKLiMl9IPr3xPauc5tgOxXk19gQw5Ry3d7VTaHt4ppipCWoNp5oLBY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774215148;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=9gj+dzsGVi7TSx5K4xQwq2AxIni5W2zhxGVIg45hd5A=;
	b=kykmHEEOV5XO3RHDGrJX1O6zlUNgo+u55t8bHs8a00ajGnQoEoMcb2jhL49SJwtf
	I1PMsjphPrqkgn9v68v6pXFXpdZ5RWCsJkFxlJYA/t1AEEFRFn3uW/3EBg8pwDgL2Wa
	JftcFSXbslAea9JoO96vGb6bX7rtenTyldxkVrsw=
Received: by mx.zoho.eu with SMTPS id 1774215145632161.1866233750835;
	Sun, 22 Mar 2026 22:32:25 +0100 (CET)
Date: Sun, 22 Mar 2026 21:32:24 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_2/2=5D_mm/damon/core=3A_eliminate_hot-p?=
 =?US-ASCII?Q?ath_integer_division_in_damon=5Fmax=5Fnr=5Faccesses=28=29?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260322213015.89161-1-sj@kernel.org>
References:  <20260322213015.89161-1-sj@kernel.org>
Message-ID: <E7EBB8C3-3AC1-46BD-BE5B-E4C2A6080D2D@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36551A0002
X-Stat-Signature: qbiiruusbxaiirbq9k5yoje7hztftpqq
X-HE-Tag: 1774215159-517026
X-HE-Meta: U2FsdGVkX1+n/jZpEZjQLjc7P/PhWfcHh58tUX47LGSjpfg05Pn3CZq/bVPt8TUFoo3hLC1y4ndZBRylW2xFgxr4RL78en6v2Gqe9XtmQQyMnQksLm/JNz9v+8kQNXVMj2XiICNdw3nqO9S46WYU10kbvazYP9H4tT0vujb4+mGImMKULXQx1tE5TQBqK2S0d+QyLuAmEl99+vx7DXLYhX4V5H20F+YAaf+nOB595H3N53xb63PyiyTuzE5ayHpmI9WSbAxUJ4vHbPZ1j4TLc9wbrUhf4XsnVQSywo+LBJsrM1qOT/B/shQCaWVy8dCz0D4jpWKx8vilYBaSqbEt9GXNAyiloIm+bzN+7mk/v3ZUiLWtPIJEC+CfglfCw3JQjhQcJsqymoCMvHvl+DY5HEnnAogudkE1SGnZb7bg8nljgLxxs8/ojBpTNzZOfdgIQQbhmiUtj9BC74d1ydxC4Rjtlc29/LYrzE1X6H0+Z4kTEMtNbL090E5kF1fvcdwAt6C53qKpvafwSjJoIaREkzve9jq2jM003OnIIayUgDVe8SuCmFKd4731SV0Zm+6//VYOjg0RA89sLK86V/fYtGexRvG1QFBf5oZSVPI8DIpxWlkYrWsjWDteEU6O6uuGJZEoDlQugJ2rwrOzg6ZpBpqQgPHTr/XicIMNGT4jwDi0D1h/oDZPY7wR4j7uKAcWdsqb8tZmOycEC8r6l3N7tJRyoJaxXriEfWTxpY3Ysgc/ACFK5T8l9g1HvjVaVS4qAWWdYh7zIKUSNyswsERWlUXcxyhq0+9PpOJkdSpSF5gLQQm3wJwfbtwf7HVUlQG20G6QNTj0JnLCr96R3N/kvm/iTQZ6UF/SUo8p73J11GgyCGrSY7CzpiAJWe8Zz4KyxLIliN/xe97BbMaG1vX49HSAwW4J5ScKMrcJCYyhrTAJVE/HR7XYZ2nMlwFkfLkIGsXmNt7XiKR5so9F/8j
 Msa1aCYI
 LuUvaRrrqIeQWMS7h5/5cu+4pKT2Ap9oFTUkiMXapDRAe+p4I1cqnl+audnIRstrPGkPqFGsayo+6F832NIX32s9Ee5TB9mKVf0y5glvVaGDQ6C1RtxJ/fV+ZMw1sml8zRxDrTHg6BE5Oi3anAbzHpJq6LSZ6FJ8jR1pPeR4Pbk1UXB+uG8WywV3VPbsMCg/Y+/Qfzn03aPX3qXmsdZoEjHe58ga0FS7TQpY7t7k42oDv6k5uod1laKo5cQvvIiiXfnKJPzF1xxmN83IZBqVwEonU1SNHpHKEIP7ojUtlm/cxm8tAkWKWEIQSJy0GYvXeBGgnQLE7FCHbg8ZFLv0px8V/F5yyA4kLyLbM8f7XfxpbyfsK/P/OwP+aStismQifUg0iLmL/fxGN6GYOj0UihLcae68RhdMh5tRQHZt9YWQqSnfUYMe/GJsQ8k3or9nSJgazN9okdDitoQ1xMO+P/5vlJjHnbBoylazwDGfmCmFSWIHr0T5Q0xbMuAhkI/1OmFgjMSJmP+ZnMWyIm9GT7pzNgxDzoNBBNpWB3P7COih8BCLQ4s7t+1Lw+cT/aUTwRdQ4hxzN5VNOym7IIeXinPTSGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22 March 2026 21:30:15 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Sun, 22 Mar 2026 18:46:41 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>
>> Hardware integer division is slow=2E The function damon_max_nr_accesses=
(),
>> which is called very frequently (e=2Eg=2E, once per region per sample
>> interval inside damon_update_region_access_rate), performs an integer
>> division: attrs->aggr_interval / attrs->sample_interval=2E
>>=20
>> However, the struct damon_attrs already caches this exact ratio in the
>> internal field aggr_samples (since earlier commits)=2E We can eliminate
>> the hardware division in the hot path by simply returning aggr_samples=
=2E
>>=20
>> This significantly reduces the CPU cycle overhead of updating the acces=
s
>> rates for thousands of regions=2E
>>=20
>> Signed-off-by: Josh Law <objecting@objecting=2Eorg>
>> ---
>>  include/linux/damon=2Eh | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>=20
>> diff --git a/include/linux/damon=2Eh b/include/linux/damon=2Eh
>> index 6bd71546f7b2=2E=2Efffdb08326a2 100644
>> --- a/include/linux/damon=2Eh
>> +++ b/include/linux/damon=2Eh
>> @@ -960,8 +960,7 @@ static inline bool damon_target_has_pid(const struc=
t damon_ctx *ctx)
>>  static inline unsigned int damon_max_nr_accesses(const struct damon_at=
trs *attrs)
>>  {
>>  	/* {aggr,sample}_interval are unsigned long, hence could overflow */
>> -	return min(attrs->aggr_interval / attrs->sample_interval,
>> -			(unsigned long)UINT_MAX);
>> +	return min(attrs->aggr_samples, (unsigned long)UINT_MAX);
>
>checkpatch gives below warning:
>
>WARNING: min() should probably be min_t(unsigned long, attrs->aggr_sample=
s, UINT_MAX)
>#39: FILE: include/linux/damon=2Eh:963:
>+       return min(attrs->aggr_samples, (unsigned long)UINT_MAX);
>
>Can we use min_t() as suggested?
>
>Otherwise, this patch looks good to me=2E
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


On it!

V/R

Josh Law

