Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAAB3EA4FB3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB9E36B0089; Mon, 23 Feb 2026 06:59:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67ED6B008A; Mon, 23 Feb 2026 06:59:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3FE26B008C; Mon, 23 Feb 2026 06:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF8136B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:59:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64894C2E55
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:59:53 +0000 (UTC)
X-FDA: 84475577466.17.A11A284
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6ADC240002
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:59:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jV3U6T1o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771847991; a=rsa-sha256;
	cv=none;
	b=o4qvb6v8tw0NKrRz3uS3QPIHTqzYQtAVcBvWT/78NDrNU59RU/b4Jiv7ISAUJ0OiJY9CP/
	V5yYYZUm2FNqZXKuZsBHdLLAnb+5zrtshNtLwGnU1h8qKU08k8yPFlGKNkjEY/SPn9kGTc
	QVDXEiMiS5G/hv/vgUAzzKmTBP7IG/A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jV3U6T1o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771847991;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vVe4ECzGRhXkACUHmPnEy8Bbw1dx3z3G3SxbNHeLbAg=;
	b=AwrSvrbOvGdSWP+vKPWJ8Gg2RCggsDTKR08Y5C2HxgDQaaC5JqR5CKDEoXKJUPA0uJMYA2
	fNGQoTzpz+Fvw6g1lc0hFpdoJ6gOs/vkbpHN7WRDxMWUVFF3R6aZZ15gh2A9SITTH9TZnz
	ETLZSUGR0bh5bS2nDm4tm+XktWIBtsE=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b8f92f3db6fso679726766b.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 03:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771847990; x=1772452790; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVe4ECzGRhXkACUHmPnEy8Bbw1dx3z3G3SxbNHeLbAg=;
        b=jV3U6T1oRablgsSFUaBD1bdJXe71+4OkeKEx05JH4jnjeI+Qi+hXTm83014uv2PMVf
         BYADYFMJxdQWTmhKZGSVc+OX//3lqZN2HuIH3BpJ6byct4BSvOmRZBzx7CjEBiA584/r
         ScJNmxaeiGuVaTdKFTCbg8rPxXRvOd8ZS+G1Si8jH+DbcswqbAx2fs04PHpe4K6MBGYJ
         UM9V9Ot8FyK5vVQQdxg9vVk0YArk6PRoUagfODtg78nl1BHDTJ62W1yorky2uEWtrhs9
         39EHVzsgpH87WF9oPbg3yGsxwEMsgG9oJgavCj+P/4ZeRFljL0SFVUknxhznEGS04bvy
         0T0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771847990; x=1772452790;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vVe4ECzGRhXkACUHmPnEy8Bbw1dx3z3G3SxbNHeLbAg=;
        b=aViPuLsjnk2SHxwrkvR64YQg3oH9LHs3f41xcBLl7YG1kg/D3BsBOhTWD1cfvhqvm4
         fxRzpTl2Qghn53b2p+NnaVQCmIwk9yOf2ksOhG0ySD2vZZ+aBy63WBAX7l2y1sfJ4jqY
         zcfa5UmU/Is5sWnZlrjOdHzSYrR1IKMEJXsUb8uZVUXJXPIkoNMhPNX04410mdmB7zei
         9rnGGx59jj7R4N++CP78vMDgjsn8FkqWnZNe+vMTXBs35Nlh6p7wcrD+W0ehiXIf3r30
         opihMrsMlP2wNLxPjwYXhHWpa1bAAVom7gLCDr3omBiEZLytVLkcWkE2k7PBYEdbVcZ3
         L4XQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4AZEuCTZ8OcIqHKBb6HA3rcV2my1vraGUz7tnODDfclWzPBZw3k+hh/NAwnWP6Wzmz5mTaSWaVQ==@kvack.org
X-Gm-Message-State: AOJu0YyVtMex5GJWKQdROmDGU9J0s4d2V2jWA8y6TS7wuojVP2VnkLO3
	1OY0JPqdpaS3w9SgMwrmrm0zgfBZ49pO3ydVsrBu1zUHJyuO0JZekvxa
X-Gm-Gg: AZuq6aKd1CpafhDO38gNioS14zUAi7Ag+7vtuCm1YnZBKrsoTHSHxsS/+6qHDvNq0pS
	amFpQl4cfl5N5oE9g7QasGRQ0DNASdLjHNiwv31Hk6ftt38Yg65q9nj0+1gq3IKj+DWXUGc4bcf
	IWDK6HVmHV4ApPSBV+yG8kNkWP5Fv/rhCTwf2a3aRlY4auDtMoyPSB17okTIR+kalIqH6Lw46t7
	HTDlNUDPkbIXORDU2VjJN8kWzlrokUQnSI6iR7EJL1RA4tQ1pPoQljG54qm4Lge1WK8wYhyv87q
	KhKtV0L590mRvTpADfn9aGfDBSeH0AKEWNFi6nA/Cgj2hL6z5meRqP655tWjPGbepqGDBpdqiiU
	bBoLdypBqMN4NDo7eKtja019Oh/ropcR7wfbtdcHUSeKAX9F7ROkr/pJ/DT6AlW0rLMve47gJMm
	SttY1q6/A9GjW8VR8hFZxT/g==
X-Received: by 2002:a17:907:1c89:b0:b88:5182:b869 with SMTP id a640c23a62f3a-b9081a490f8mr527916366b.23.1771847989422;
        Mon, 23 Feb 2026 03:59:49 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084cad862sm317790466b.26.2026.02.23.03.59.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Feb 2026 03:59:49 -0800 (PST)
Date: Mon, 23 Feb 2026 11:59:48 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
	Linux MM <linux-mm@kvack.org>
Subject: Re: A potential refcount issue during __folio_split
Message-ID: <20260223115948.sbylmtqhznmabcth@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260222010425.gbsjzhrew3pg4qrw@master>
 <20260222010708.uohpmddmzaa4i4ic@master>
 <6346656B-7518-4A55-8DEF-C2E975714C8B@nvidia.com>
 <3e22afe6-ecf7-4180-9287-c48fea7b8be1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e22afe6-ecf7-4180-9287-c48fea7b8be1@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: p64oodhf1nsqf5t6boxsuf576nruftuw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6ADC240002
X-HE-Tag: 1771847991-107278
X-HE-Meta: U2FsdGVkX19PsUD/wLr6VeGSBl5gYkWojO4QG3jCxp71PDPvrcTKCnxCsqKq63wex6NzSeZ0cuU4okV8KhJLadXscQGgPcLRQQnLDwEr8J1hD8V9bSbUWCYB6V+GrdgowOzQNBUvptT5efd/NvZD0UTgJ38X84cCfHMFvAwIvN9xwEf3ruA588xLVxCU1wdAHnbMyWvXFDnM+u0os26HR+fQ/TrJQ4SfZal7rZACxJmgeAZCuW0BRzilGZTrt1WwcAhdCKCp6pSe+UyG6MZ4Pd2f6e0fxEKxD9JeBCWjW9L8brqRk4q2805wnLtuaKiz/jhM4JdVAFt/dwX38H8ldE9DjX9di01jGp3dah0Rgl3/Dg65sjtPCL7o9C/oW/MeE3gcUtq4fz0BQsLwxecD+yBVMgHJmYp5UfnXhtoMJHCwfTkagZeT5CVJsH28zBsDwKtXp6GsmRoDiVyVNfof+uvlR/F/i8ZfIKKFuLGtFOorZSrZCA1raBgQv7Qmkk/B7MfSgtSXowRcm6qlypkegSzu5sIOaUatjtuGPvsgPRLkI1mZ1Mur5fr359SPOaGuRPjImjiIty6cXButji5jopH7AhI8vB3unJMpdWetriVswc2sp3QKqoaLJEBwqiWhRlimnDc8HlM1Oq96UZXDwwxsAniGSriu94YVEXoJEO6jCv+R9HfTgcalMQ9aIZDspgeA9S32wZEGMhfB0t6xntwkO0+dKVNPq/gaLzlBB3cgCVplFCE1nbTy6OVxMszmze8v6X+Fn4J5nMjqMOoeALs92SANMxhA4w0rTFZNaRGU39R+8WS25Am8ABhR0oBxp1t4/O5KbMsZPemJo1RxWWC8lnV9RVnaM4PRa37eUbtYqdAECl+fmZdgm8/6cZBjviuLHma6iyqrO+is5UCXb/RqAk97IJiIGOIjAXf2eQIvNrbCAUIrnvcWbrP1PwTdUBd0/cw/PsMRVZIlJCM
 8dBwVwtQ
 1V3W7pZFmUVVP9B7oOkYQo6qfn45NcCwONkVw4vp5iYVRonVA+PKmHCBj5UOxrO53IwJGoMIKZf9VauUrV95o07uH3PAufCKVX411otPVALsoaR4DxogKodXRurPIQ9CgQabZBekLzTz+IEA+XTMz+yEaOHTr3ogtICRSa5wA2Xsbzx0AbE4Eiheb6teZUyyWIjtPGhJ7B12slcK6E7luAvdGi+N7WFDqMKjFvZ1VzRmT/jIfOl9gBJveqOYgPurjR5Chs4paMTGYMuhFkd4VYe6Pk26Ii+ME6cGqDIut1QYPEyJJAKmTkffEXkZwS81QFhi29ChLb551I6Q8fbYep6KP4FsvvlfTNhBtsHOFICblwImuIUWjHo2ul4WI3eAu2xwhr2dRD8Kofe7ByAbxV5L/Hawot14UmKzlQ8N7Xjiu7/NYey5jOsfrJZtScIiL8IIEzjol+/mAue2U+MonK1B9kkYX/UyPhcGRmZfGrHpcMjdWRWgzwu18ak55gSQflplVEHPui7rbD3EDdhVSwy0+l1MG5K06ZAGAKWlKmuvA8y1vmJ33WNDZqQLxmLE/z2GXaUzCAFOa+JcGdxZq5k7O4PfH9M93AHw+nMfKSdHlhuT3p3wNZFrFxkvXzZ1sRVBkmWP002Zk478fVi6JbMyQ/frhxPGlL7yM5GM2aXpILBps55Y4AYWdYvc4dueLrq36j9eP/jl13TDecXMRSoZ0lnEY7JIZag0YoAp8NgzCTY8LcVhd1keRrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 10:23:11AM +0100, David Hildenbrand (Arm) wrote:
>> BTW, in the folio world, I do not think it is possible to perform the aforementioned
>> split_huge_page_to_list_to_order() pattern any more, since you always work on folio,
>> the head. Unless there is a need of getting hold of a tail after-split folio after
>> a folio split, the pattern would be:
>> 
>> tail_page = folio_page(folio, N);
>> 
>> folio_get(folio);
>> folio_lock(folio);
>> folio_split(folio, ..., /* new parameter: lock_at = */ tail_page, ...);
>> tail_folio = page_folio(tail_page);
>> folio_unlock(tail_folio);
>> folio_put(tail_folio);
>

Missed this. Agree.

>Agreed. Maybe it would be even nicer if the split function could return the
>new folio directly.
>
>folio_get(folio);
>folio_lock(folio);
>split_folio = folio_split_XXX(folio, ..., tail_page, ...);
>if (IS_ERR_VALUE(split_folio)) {
>	...
>}
>folio_unlock(split_folio);
>folio_put(split__folio);
>

I am afraid it would be complicated?

Well, we don't have this usecase now, could decide it when we do need it.

>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

