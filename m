Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE021098799
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CAD6B0099; Fri, 20 Mar 2026 11:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133926B0111; Fri, 20 Mar 2026 11:15:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0708E6B0112; Fri, 20 Mar 2026 11:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA9AA6B0099
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:15:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C54F1D1CD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:15:57 +0000 (UTC)
X-FDA: 84566791554.25.0E3A70B
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B786C0004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:15:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=YlBD0JrE;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf22.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774019755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZoIGVlxoqgpVwZ++hA+mPWqVSD5mS9s8EZM+kwCgTs=;
	b=BHtVV18SXwfqmabiXzNuHFI9GxvrqAtNYH+nKrL+qp57Jv7RRi2ofZ4CHFTiU45brmdSE+
	ZKFEfhsDVBfn2tTYpeGkpYqCs8TUTVPpvlIEp//T2zl5uPfinD2TuJu9uT3q9N1cewWFiH
	C5zg/pZtlmuCTDYIY9s2T9Mv0ZI0Lt8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774019755; a=rsa-sha256;
	cv=pass;
	b=u3BsX7wZyUBZiUgWeh7KIlMVFVlNYfhS7NkdMakp7NMYbKTbtKOoGtevkhv7hoGhyM78hb
	C6C722zKjA7FBPvJIpYGKymhKEKhV0YvFPcz4C8dAnSdw3RBgD95RFf2wwt6eDLSIkjXQ1
	pVIeuxxXnCv3Q20j2zmjwp8Nwrz34cE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=YlBD0JrE;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf22.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1774019742; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=jI0rj2fx+zrHYx7AJcLDpMawOsI9Ht5Bkv4AgQZfVyIHbjXBKwb/Ow77g5FLiojVmWw7EM3HVa/sI/1Ye2z0poWiPNsV8HbDOPmUelvkRjw3QFIbx0U8SH6CEP2k2G2+K2u6j8nz3wg6BsptzHm3FIOfyQ4GN+H8QZpMQ7l3kao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774019742; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=WZoIGVlxoqgpVwZ++hA+mPWqVSD5mS9s8EZM+kwCgTs=; 
	b=Rbh6t5u7MzJUSab3rDCaWAzB2ygceu4QcwnaW+O7yzkNFhfISnQY6XqNC0mr/EP2uuj6oQlrRtUgTFXH0J/X0ciLbXr5AWA6XCLlzKgiIvcJkc8v0Atx1w6WgUPjuLvvBwKlNQ2fXa5Z6AqY6XtN/B/OEZnVO/eWNIA0f32h8WM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774019742;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=WZoIGVlxoqgpVwZ++hA+mPWqVSD5mS9s8EZM+kwCgTs=;
	b=YlBD0JrEdze4SqlLpmbsPbnVW3QhDIdBcSuVU+He6U2UnmwPt6B5ODJ2yjDVa3pV
	Ky1/M4bNqzcpb8i12HN+ACiMNzRULLcC4i1NVgkEw7UncwHasw6qvEyIVIbXQIDs/Tp
	9RjSIpYKOH/VrOTn3pwgQ1zecwW3uo8RXcTlVKJY=
Received: by mx.zoho.eu with SMTPS id 1774019740177737.6191439933341;
	Fri, 20 Mar 2026 16:15:40 +0100 (CET)
Date: Fri, 20 Mar 2026 15:14:54 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_2/4=5D_mm/damon/sysfs=3A_check_cont?=
 =?US-ASCII?Q?exts-=3Enr_before_clear=5Fschemes=5Ftried=5Fregions?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260320144741.91848-1-sj@kernel.org>
References:  <20260320144741.91848-1-sj@kernel.org>
Message-ID: <C65E16CA-8D81-4B88-96EA-59DB554494A0@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2B786C0004
X-Stat-Signature: ep9he19mobbokfkiih94xkxbgqbphapr
X-Rspam-User: 
X-HE-Tag: 1774019754-34965
X-HE-Meta: U2FsdGVkX1/mEWssihGg7i+wpdnD/jhtjdIxT5HaxHb4UDBOUoht3CXuLC4uzYTZsql+TFTKr4D2u3qmhtJJzKBOZOWfRVJnnxXwVTV86fOdd3b/tkl42J4MdUoN40RhQUcQZJgV7t92P7zX0N5XTfr4jHm3c5PYp6U3CEbwC3y7SP+uMrqam7s+9eoPGIrgR8yNeVj2FfJak1SckclLWfbjRpFX9Hz2bQtpim7yCs6rPoebhwlhtnuo4SKWEr4wI8z20USNHwijaEqVNmm6WJlCX65uzcfVLE1fjqNyWQTHK7Gpiso4bdaRR1TsDYB9dwhmJFJt26SU4469o06OTDoz67aFOfnUqqegcQNvxnPIL3mokv9MT9BXyU5RiKXwhRZqjoEovYFO1BXvyDmcdFzCVgf297ijmFcciaBrh+XBhlU+qZNtE3FX5DC9Wi6DaPv6Oq/6XO9o8zWR0at4n4+fYoLd7xiHUmYCaVe5jYrZnruqQddLOOvkR8Al7yLtgZpMQpLnllQcsSn98sI7pcMTNkxp98PiZktvDTEy3kwpe5geF2L1O+k/QcpoZ+rZdsARss6zrWbL9Dy3kB9qMe8/1SR3jYig/MOp5cXoLZ5xH0BJ/IcYvejvS9FuEoXseFoeFA4bpeuK+8ap1gPLaEMHbidQV/SnQo4/wVSjHosUXUfkCl39MNn1LJibdoqxFPU5W5faHMnYv2NnBX+N+aSWlihAXyxgeqVKlpzOoI6X7pJbo0lSGMHIkOAnwPqp0+2pXFshbd0AY8eQLtFh2S6jS5fr0fhLbeT2XQiKS8BQNr5R2GaiwGhaB51uIq0vJbF+K/CmPnojd8Pb3SfhSeYALcGZsl0AU1fAJZTWXpUBAul3m+wAUVir/TiR6gs1n4eRXomNuV2XRejOAq5th5JmEdCT6vbHROcivY71zSF4sQsBmcyfuyPgVyrCSNE6szpC9OgDbQpU8MvNPJn
 xBrZTrHA
 diwHnUe6KIO12JyvUkegD3m7ejgPUOHe3K6ctdMwxKl5z3N+bY9y2BFs4L2UmJv2Fp0ifMbFmppF1mdkZhRQyu54n+j37FBgFZ20cV0LUVrj0F9ghi8Zx4IuMETN72BH0mKLkWtgE2wicQJ1RH18olALUxoG0KNAkbjs71zQZvSCE1uR94Ylj/mbj76RmJOiQY2f2XB9xnxXON7Vx3vza1+LBi1ceHqEq295EhftnK4DJNKWG/6Ps+vcYBv9Y0OWcKRbji4pcau0lMi/5JUajHp60cGox2zkSs0X7gujMlZtyaldjQ6FZhGeU6WUq9mDdnDForAFUwMcywZ3IbJyCovvu7DLMMFc6nTCpU3qzj1Uh+DPube8zfPwC6FqyKOOUewRMVAcZzM3AECkRnZ0m2wJ1P6ugoKOMaF7gZkYyAf0Os331JsAdoQSgGbec/wNH0YdOTtantspYf4pc2Yq4FSuj2t4+ZuPGtNsqPOGVKGn9MK6WUVMh0WqMQ+YyJgYMEAa+hrGTAv6Qm6dvg8A45uR07O2cXskQxKcv6q87kg0Xr0/bqPXMBu7rSDjO4Bl7YDdJ/nmdsyZUz+aFqiW50kXD9C7QChji6zpRmQ+TSuHilgQPm5POUaytVU6Cx/INlJegiykOlxwZyjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 20 March 2026 14:47:40 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Fri, 20 Mar 2026 07:06:48 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>
>>=20
>>=20
>> On 20 March 2026 02:13:17 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>> >On Thu, 19 Mar 2026 15:57:40 +0000 Josh Law <objecting@objecting=2Eorg=
> wrote:
>> >
>> >> The CLEAR_SCHEMES_TRIED_REGIONS command accesses contexts_arr[0]
>> >> without verifying nr_contexts >=3D 1, causing a NULL pointer derefer=
ence
>> >> when no context is configured=2E Add the missing check=2E
>> >
>> >Nice catch, thank you!
>> >
>> >Privileged users can trigger this using DAMON sysfs interface=2E  E=2E=
g=2E,
>> >
>> >    # cd /sys/kernel/mm/damon/admin/kdamonds/
>> >    # echo 1 > nr_kdamonds
>> >    # echo clear_schemes_tried_regions > state
>> >    killed
>> >    # dmesg
>> >    [=2E=2E=2E]
>> >    [63541=2E377604] BUG: kernel NULL pointer dereference, address: 00=
00000000000000
>> >    [=2E=2E=2E]
>> >
>> >Privileged users can do anything even worse than this, but they might =
also do
>> >this by a mistake=2E
>> >
>> >So this deserves Fixes: and Cc stable=2E
>> >
>> >>
>> >> Signed-off-by: Josh Law <objecting@objecting=2Eorg>
>> >> ---
>> >>  mm/damon/sysfs=2Ec | 2 ++
>> >>  1 file changed, 2 insertions(+)
>> >>
>> >> diff --git a/mm/damon/sysfs=2Ec b/mm/damon/sysfs=2Ec
>> >> index b573b9d60784=2E=2E36ad2e8956c9 100644
>> >> --- a/mm/damon/sysfs=2Ec
>> >> +++ b/mm/damon/sysfs=2Ec
>> >> @@ -1769,6 +1769,8 @@ static int damon_sysfs_handle_cmd(enum damon_s=
ysfs_cmd cmd,
>> >>       case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS:
>> >>               return damon_sysfs_update_schemes_tried_regions(kdamon=
d, false);
>> >>       case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
>> >> +             if (kdamond->contexts->nr !=3D 1)
>> >> +                     return -EINVAL;
>> >>               return damon_sysfs_schemes_clear_regions(
>> >>                       kdamond->contexts->contexts_arr[0]->schemes);
>> >>       case DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS:
>> >> --
>> >> 2=2E34=2E1
>> >
>> >So this patch looks good as an individual fix for the individual bug, =
but=2E=2E=2E
>> >
>> >Sashiko commented=2E
>> >
>> ># review url: https://sashiko=2Edev/#/patchset/20260319155742=2E186627=
-3-objecting@objecting=2Eorg
>> >
>> >: Does this missing check also affect other manual commands?
>> >:
>> >: If a user writes UPDATE_SCHEMES_STATS, UPDATE_SCHEMES_EFFECTIVE_QUOT=
AS,
>> >: or UPDATE_TUNED_INTERVALS to the state file after setting nr_context=
s
>> >: to 0, damon_sysfs_handle_cmd() queues the corresponding callback via
>> >: damon_sysfs_damon_call()=2E
>> >:
>> >: When the kdamond thread executes the callback, it appears functions =
like
>> >: damon_sysfs_upd_schemes_stats() access contexts_arr[0] without verif=
ying
>> >: contexts->nr:
>> >:
>> >: static int damon_sysfs_upd_schemes_stats(void *data)
>> >: {
>> >:         struct damon_sysfs_kdamond *kdamond =3D data;
>> >:         struct damon_ctx *ctx =3D kdamond->damon_ctx;
>> >:
>> >:         damon_sysfs_schemes_update_stats(
>> >:                         kdamond->contexts->contexts_arr[0]->schemes,=
 ctx);
>> >:         return 0;
>> >: }
>> >:
>> >: Could this result in a similar NULL pointer dereference if these com=
mands
>> >: are triggered while no context is configured?
>> >
>> >Sashiko is correct=2E  Privileged users can trigger the issues like be=
low=2E
>> >
>> ># damo start
>> ># cd /sys/kernel/mm/damon/admin/kdamonds/0
>> ># echo 0 > contexts/nr_contexts
>> ># echo update_schemes_stats > state
>> ># echo update_schemes_effective_quotas > state
>> ># echo update_tuned_intervals > state
>> >
>> >Not necessarily blocker of this patch, but seems all the issues are in=
 a same
>> >category=2E  The third patch of this series is also fixing one of the =
category
>> >bugs=2E  How about fixing all at once by checking kdamond->contexts->n=
r at the
>> >beginning of damon_sysfs_handle_cmd(), like below?
>> >
>> >--- a/mm/damon/sysfs=2Ec
>> >+++ b/mm/damon/sysfs=2Ec
>> >@@ -2404,6 +2404,9 @@ static int damon_sysfs_update_schemes_tried_regi=
ons(
>> > static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
>> >                struct damon_sysfs_kdamond *kdamond)
>> > {
>> >+       if (cmd !=3D DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr !=3D=
 1)
>> >+               return -EINVAL;
>> >+
>> >        switch (cmd) {
>> >        case DAMON_SYSFS_CMD_ON:
>> >                return damon_sysfs_turn_damon_on(kdamond);
>> >
>> >If we pick this, Fixes: would be deserve to the oldest buggy commit th=
at
>> >introduced the first bug of this category=2E  It is indeed quite old=
=2E
>> >
>> >Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
>> >Cc: <stable@vger=2Ekernel=2Eorg> # 5=2E18=2Ex
>> >
>> >
>> >Thanks,
>> >SJ
>>=20
>>=20
>>=20
>> Hello, did you give Reviewed by you? Or not=2E=2E
>
>Are you meaning Reviewed-by: tag?  If so, no, not yet=2E  I want to get y=
our
>answer to above question first=2E  Could you please answer?
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


Well, two is in the same catagory=2E But seperate fixes may be best=2E  Be=
cause patch 3 dont call that function, so it may be screwy, i mean, if you =
want me to=2E Ill guard it=2E But its a bit on the hacky side


V/R


Josh Law

