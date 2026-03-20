Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B8A81093177
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 07:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C34A6B03AA; Fri, 20 Mar 2026 03:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273B46B03AD; Fri, 20 Mar 2026 03:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189816B03B0; Fri, 20 Mar 2026 03:07:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 050646B03AA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:07:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 994C28C671
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:07:18 +0000 (UTC)
X-FDA: 84565560156.14.018DCE8
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7CDDA180002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:07:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=NOt+Fn1o;
	spf=pass (imf16.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773990436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8oK5RCe9uCIwAhJ1Bo5VEmx8tjlc5XR8v7u8F6fzXM=;
	b=1d6s0qIzsydGGuf4HEME+A4Z6dr/ZqfxQunZQEn2ONWiF0ZeQftmSlVizyQnNU4BsIT4Qa
	PebXwuAMlI0Q/NmAfaIL5Bhfc0DgO+eKVplK3Xnbuqn8B+zirTDeovNrhBg+pxz3W0CpHV
	KeT7AUqzLvBtdyV+sNHPHD5GmGfRpsc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=NOt+Fn1o;
	spf=pass (imf16.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773990436; a=rsa-sha256;
	cv=pass;
	b=G1rdCsYfNUIm5ZttGDodkjm9pZV7IY5Qj1KiTnCzoqTY0N32bV4nfCc6+3HJsybN8d07wK
	c9pdLANuiTkO1hejBwNgy5HY/PwHXQpTpaSYm7284Og3DpswEqXPhoF3rh9IqgvAMhg1we
	MJ5fOeEBhDjEKBCacFYTKeWMKRKarU0=
ARC-Seal: i=1; a=rsa-sha256; t=1773990410; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=k5CguAlxOCS5xMApFoTv9ZuoSWHIB+mQjjSdXJIZ1gd55C3xW8Y0QVjukOmN/Ee4tWKV1aWCHfFMhDFdLF8JGWeQN8F1N4WmmjE6830Upv33kPQuVhhGqVXjW6Vh1g9NdzrfwFB+hpRSJ/xJo7Tk8Ea8aS4/uRzV+jPDHxrLY8g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773990410; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Z8oK5RCe9uCIwAhJ1Bo5VEmx8tjlc5XR8v7u8F6fzXM=; 
	b=hmrmdKrFf1z4EBOrKhyNvWubCIeqLqhyyRGhK0/fZ5fjHii6weFmUzg4tMkq9M/RUALNCm+C4NvGPvZBumVqePXQXleOsvF1ZAwWjXkicCiv5/vgo9yPD9CMbTC9FvvpVeuFQTQ9wl9yua53MHaGtdlNxdfVX4efVRI3zpxIb90=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773990410;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=Z8oK5RCe9uCIwAhJ1Bo5VEmx8tjlc5XR8v7u8F6fzXM=;
	b=NOt+Fn1oBhfhfW0ws0Q/WT60QDumBxumtZ5mJgAmUPXFd+jl3VYpDLB7E43xA9A5
	PHVwB8tL6XM4pmT2uV19RFRay6orZV9X3dZlmh/Y+eJx4pxLaZ9V1NN4rMQRktHj24R
	wWO2XkAGYi+nFigDnR87WEKdyGUUNW58QU69MbSw=
Received: by mx.zoho.eu with SMTPS id 1773990408143822.1742080429242;
	Fri, 20 Mar 2026 08:06:48 +0100 (CET)
Date: Fri, 20 Mar 2026 07:06:48 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_2/4=5D_mm/damon/sysfs=3A_check_cont?=
 =?US-ASCII?Q?exts-=3Enr_before_clear=5Fschemes=5Ftried=5Fregions?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260320021318.1117-1-sj@kernel.org>
References:  <20260320021318.1117-1-sj@kernel.org>
Message-ID: <8F30B2A1-240C-43D3-B756-20E327F5BCF3@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 7CDDA180002
X-Rspamd-Server: rspam07
X-Stat-Signature: 4kw9sa88our6xr93tjoomuzkq8g6ny4g
X-Rspam-User: 
X-HE-Tag: 1773990436-905424
X-HE-Meta: U2FsdGVkX19PvnKEQX2TsYpUfDj2lOYrUWgQOqYfHHIe6ATdMpj2I6auYxcmvpZbkkIHsxafSvtsr56LFE2BMgdHi1fnCm780+9ImWr7vGr0Kl1uN8ZOS3s677f16Tt4tQ8kPv+5gtnzpFH+RaGtAin8r/vo5vC384U60CQpd7odOca8FJTujViX3mz+xt0xwbsRHeKw1unEAocw7yoRW9U2oKBw65cwRtV0+3mA1yUEqfNXXl44tDFuI2VBreIxlzdsQrCDb06CVUmXk1n7mHQLCXzWRllOkfYCoTAvhEIPJ3GFKZLvy/uGUXgj/DCwg+dfnTi60t5NJQjgb1gSJh3/TTzsi5ynRAmZpRlJQ9bhhoM8N96d0ZnxberEJf7Hh2ZeDt7JrBFriT4bra/cyJuvgmkRyLu0C2xinxmwQ1yx4uFenwYwB/l53Sb0qscB1tJrmaZVox6EVaU0AyK6euyJtDLbtmMrxNzwngpfHxxJA6Au1m/R22yzRji6RZZGJC+R+nBWc13qGy7buggbpZ6n2cS7KY67KSeFEexZCXjzeEYr6Mkxl2f/nHkUjwr5+/ZZ3b8GF7WeLRXAzz4+NcPUuhJz3iP75mh+GSx/HV9ARTyMhVC1a+tbvf+d8YCu8GTs+RgZZD2q5emIJf5lSkuBVw22h4T6wNYQ0UfVIadA2pp32OE1K9Q6IxnRiN8IvOc0Go+SksvbHgDqzslcowxdq2DaRFuzrdezwbiwxyppnNfCpxU0FNPoaHMwAOO0L06uRMwfQAgyRNQgKMVdfVP0ubWCj7YFOo2ifdmvbJ6UPfdFaN0BKqwP8bTLmdwNDVjolj2c+GTlQuDq2lb+P0y4ApCSOlhVbzUHC+VhnrBusdoMmYxjP524UWCOgjSHI0YpP5yM6zzScqECvdbKh0taI7wUVQ3M8mG02IVgMiWUjYrgvQO+ibFijvv4vUUaqAn+BbNY2STWxJA/HJw
 5acKnhIz
 9JuxvKbFs4NfLfEF7dkXdBaM7yNskmkEe9yW/O7Bf76qX7QPdiknsNAqAsCbWmqZxX1U9+6aBu8KmMY6JvqioESnFTlvhY+kSlHJmjQJDdcSSlSOoXyl/8yoHIVtBJoTTnKCDVGTIt4LemqS4qNX+1JR/Ri+1cAF3CTPMxv5V86gfGCEcqI1gaWwsKAOnp6vzYwOKn7Qqk5+jACcfmBZI+g3rYXy/RTqEYRl62ijj80O/6Bh+trXEs7907zBs+J52Cbji8UH2uQbRB1OqmfzPIpw2acNlJotRnaPtrRnyvL5mVf2xxtBA6sJVjC1Cv8oS5+Jb/8XPP9QXoUGOa83+OFcXfHMPvwZ3noY4qxLswT0lIaFQQ1PzXOXcaFreboG8RDYDldXTn3MsFMiOX9UK86c0D/aRAUmnzTbj8cTSLIchYFOpjiNzRYaOj9gDGniQRDR1Sh7v9+1x4JB0tgbjMQO6T62DkEVTkGbaug5lw/U3DCAjwSgx+Sc/HlEDbBG7UZJdkSSIjkZM8d405Iy+bDeRUVKljkVvAVmaJs1Zo56DpqdQK456VM8l/DMLGgf98fgPliXE/hE+aj1sot1dzuXECQBGqjWLm8VlQqWlsIufwA3T0I6knaZrsbsBpN+b/WoN0krjtFLHuIc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 20 March 2026 02:13:17 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Thu, 19 Mar 2026 15:57:40 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>
>> The CLEAR_SCHEMES_TRIED_REGIONS command accesses contexts_arr[0]
>> without verifying nr_contexts >=3D 1, causing a NULL pointer dereferenc=
e
>> when no context is configured=2E Add the missing check=2E
>
>Nice catch, thank you!
>
>Privileged users can trigger this using DAMON sysfs interface=2E  E=2Eg=
=2E,
>
>    # cd /sys/kernel/mm/damon/admin/kdamonds/
>    # echo 1 > nr_kdamonds
>    # echo clear_schemes_tried_regions > state
>    killed
>    # dmesg
>    [=2E=2E=2E]
>    [63541=2E377604] BUG: kernel NULL pointer dereference, address: 00000=
00000000000
>    [=2E=2E=2E]
>
>Privileged users can do anything even worse than this, but they might als=
o do
>this by a mistake=2E
>
>So this deserves Fixes: and Cc stable=2E
>
>>
>> Signed-off-by: Josh Law <objecting@objecting=2Eorg>
>> ---
>>  mm/damon/sysfs=2Ec | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/damon/sysfs=2Ec b/mm/damon/sysfs=2Ec
>> index b573b9d60784=2E=2E36ad2e8956c9 100644
>> --- a/mm/damon/sysfs=2Ec
>> +++ b/mm/damon/sysfs=2Ec
>> @@ -1769,6 +1769,8 @@ static int damon_sysfs_handle_cmd(enum damon_sysf=
s_cmd cmd,
>>       case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS:
>>               return damon_sysfs_update_schemes_tried_regions(kdamond, =
false);
>>       case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
>> +             if (kdamond->contexts->nr !=3D 1)
>> +                     return -EINVAL;
>>               return damon_sysfs_schemes_clear_regions(
>>                       kdamond->contexts->contexts_arr[0]->schemes);
>>       case DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS:
>> --
>> 2=2E34=2E1
>
>So this patch looks good as an individual fix for the individual bug, but=
=2E=2E=2E
>
>Sashiko commented=2E
>
># review url: https://sashiko=2Edev/#/patchset/20260319155742=2E186627-3-=
objecting@objecting=2Eorg
>
>: Does this missing check also affect other manual commands?
>:
>: If a user writes UPDATE_SCHEMES_STATS, UPDATE_SCHEMES_EFFECTIVE_QUOTAS,
>: or UPDATE_TUNED_INTERVALS to the state file after setting nr_contexts
>: to 0, damon_sysfs_handle_cmd() queues the corresponding callback via
>: damon_sysfs_damon_call()=2E
>:
>: When the kdamond thread executes the callback, it appears functions lik=
e
>: damon_sysfs_upd_schemes_stats() access contexts_arr[0] without verifyin=
g
>: contexts->nr:
>:
>: static int damon_sysfs_upd_schemes_stats(void *data)
>: {
>:         struct damon_sysfs_kdamond *kdamond =3D data;
>:         struct damon_ctx *ctx =3D kdamond->damon_ctx;
>:
>:         damon_sysfs_schemes_update_stats(
>:                         kdamond->contexts->contexts_arr[0]->schemes, ct=
x);
>:         return 0;
>: }
>:
>: Could this result in a similar NULL pointer dereference if these comman=
ds
>: are triggered while no context is configured?
>
>Sashiko is correct=2E  Privileged users can trigger the issues like below=
=2E
>
># damo start
># cd /sys/kernel/mm/damon/admin/kdamonds/0
># echo 0 > contexts/nr_contexts
># echo update_schemes_stats > state
># echo update_schemes_effective_quotas > state
># echo update_tuned_intervals > state
>
>Not necessarily blocker of this patch, but seems all the issues are in a =
same
>category=2E  The third patch of this series is also fixing one of the cat=
egory
>bugs=2E  How about fixing all at once by checking kdamond->contexts->nr a=
t the
>beginning of damon_sysfs_handle_cmd(), like below?
>
>--- a/mm/damon/sysfs=2Ec
>+++ b/mm/damon/sysfs=2Ec
>@@ -2404,6 +2404,9 @@ static int damon_sysfs_update_schemes_tried_regions=
(
> static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
>                struct damon_sysfs_kdamond *kdamond)
> {
>+       if (cmd !=3D DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr !=3D 1)
>+               return -EINVAL;
>+
>        switch (cmd) {
>        case DAMON_SYSFS_CMD_ON:
>                return damon_sysfs_turn_damon_on(kdamond);
>
>If we pick this, Fixes: would be deserve to the oldest buggy commit that
>introduced the first bug of this category=2E  It is indeed quite old=2E
>
>Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
>Cc: <stable@vger=2Ekernel=2Eorg> # 5=2E18=2Ex
>
>
>Thanks,
>SJ



Hello, did you give Reviewed by you? Or not=2E=2E

V/R


Josh Law

