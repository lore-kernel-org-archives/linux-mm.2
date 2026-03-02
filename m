Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45B84D58E7A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C5D6B0005; Mon,  2 Mar 2026 04:02:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573B26B0089; Mon,  2 Mar 2026 04:02:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496F16B008A; Mon,  2 Mar 2026 04:02:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9006B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:02:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2411160AE5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:02:15 +0000 (UTC)
X-FDA: 84500531430.06.B420D65
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4605160005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:02:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a1r0iYhQ;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772442133;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNqgOCZqxW9/vQl4qdFnvYvHGEkzP7A3ZnFekCwQ3xw=;
	b=19l5OtowOOJkpWNPL8OzPwV2aSfDcZdU/IGjGF50VFMJ4LpHpE5cG/28Lf8TgEdKSAuYAq
	5bcm5oB1qNSdmKnfiUiRS5zRNl8UMsWJVpqML/qSMA6yjEjajIeI9q161DndqW+DaAIMnO
	ETwevAC047pEUSjj6qqt4N8jrc7hNjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772442133; a=rsa-sha256;
	cv=none;
	b=NGFDxIn9F6JxBWwua/x0C8UK3COA9lHhHZ8h8gQVe5vaYlNVbFW2ofujGgXqmeOvPpFBzE
	ZeVQJrWIBRaBonfCpK818a11drvrNmf/BIKRw/MTkLl/+RkxByIDiI/2DbIePKxI7Mi+P5
	tZ0A7hYwHOtjrpxxrkKSiJeq9+xVvKk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a1r0iYhQ;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8f92f3db6fso633579966b.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 01:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772442132; x=1773046932; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VNqgOCZqxW9/vQl4qdFnvYvHGEkzP7A3ZnFekCwQ3xw=;
        b=a1r0iYhQepP5T35R0Vv/ga7+r84wrb61DOfFJKa/jEzmKIZT955p8ta5/ghKbZGLMK
         HDlkww5ZdFklEb4H30iy/phQ78vWryAebrRmK/JOstiVd1QDK67AtkT9R1uaZhHjGAhE
         Tnwd9fQ9AdjlsYWeYJtwucWS8Lkf2qUEmu5wlk4L2O6cc3dH65kgSaQuWEbDQnfP9iBV
         0obMiYyW9+8BVwvWsXiezpWPgeM+R0Hqy211r0jfQavukKrgdhBzPIt7cOYOYEjYjMj/
         zsGpqRu6Yzj49p0RpHzUNQjg39yBVOitmrGCC3tpDvo6vvt0MX0sThWJRjPYTCP/fYHR
         bIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772442132; x=1773046932;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VNqgOCZqxW9/vQl4qdFnvYvHGEkzP7A3ZnFekCwQ3xw=;
        b=OXFbPXb9EMnbBCiccKgUzIJl9AnweDvHzcLLpZ2YGYLYDsodI0cHscH5WwFeYhxyHH
         6LBPwQR4nWpWlApN8dqfSkriZZcrAA8ervXIFH/lYPzB7dSSesqdlC+yjSwSWiHFK9qN
         frntZLLnnOPLNWUgVoNSk4PV3NO2XRwafxEqcT3U8/d7ayZTYG/i/g94tkG3kIdO8lU9
         AdbL890ziqdAKsvTvN9n4eR+umTXdYDGNuwYmS637lUtmIiCalQSJLPNDBUdqYG3yVe9
         vKaOsgviwISsPjUFNMuYEikEV2uS7yIT4kOXU2kzlv5m41N9gbvsEWqHhnP7YK29VeR8
         LAcA==
X-Forwarded-Encrypted: i=1; AJvYcCUjjzrKaGsgilvFzZUpI9Jhe492AN/Qehifw+YrX3wFf58P6mLxL3CjJw5LxhLwcCZV1kFtW7vEZQ==@kvack.org
X-Gm-Message-State: AOJu0YzQZJDX50Z9vptFsI9JFdxHfRKTlzBahNi2XoJTD119YqJmHal3
	+TJZWokGnb7opdhxsRjxQwrKz8podDv6fuCCdkSJOgxlLSTJfEsrWp5X
X-Gm-Gg: ATEYQzzz16JqGQ2O2+czT66HRmO59Gj2sNWNFF86MRQ3LEKRtwcIoTwKm5CXsbVJO0A
	RZw/BgxCcxtcNbQgZ7smIaARB3G8TCQBlMrKRQiPSaSyq1QPk8bTFgUQ0ejBckt2lUnHvlFKihP
	EUO+x8lsubwHCbpvpteX7hpAcfbu7ZR1EVxLWiOLfBggu1QyT/vYDECSvlEGSmkbCuFCrWZ3CPg
	4Mkx7mEYfs0omw1gDjlhY5Wu/VaZXripSmFcOpJAn0W4EUIRETOyaJO73A5pNgv+gS6/kEBf9YC
	AVsT1BnomAmxhoncMVktT7nMhJ69Mfj2VKEeRqS7w5xsalihsMMUR3noVqBoFElVZ9cO70+CtHf
	qf5wsB6tJSdR1b0SuMmsawtvkA5G4tZ4XFyYNRTq4xfaLYUJyjOU60zcamqLheYj2k8NVk2uWhc
	jC31fS3fvIor71xXvDPBL1Eg==
X-Received: by 2002:a17:907:9628:b0:b88:dc6:3967 with SMTP id a640c23a62f3a-b9376543b56mr753315066b.40.1772442131793;
        Mon, 02 Mar 2026 01:02:11 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65fabd36224sm3317572a12.7.2026.03.02.01.02.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 02 Mar 2026 01:02:10 -0800 (PST)
Date: Mon, 2 Mar 2026 09:02:10 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, Zi Yan <ziy@nvidia.com>,
	Linux MM <linux-mm@kvack.org>
Subject: Re: A potential refcount issue during __folio_split
Message-ID: <20260302090210.mssx5sdq7qrjr2yv@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260222010425.gbsjzhrew3pg4qrw@master>
 <20260222010708.uohpmddmzaa4i4ic@master>
 <6346656B-7518-4A55-8DEF-C2E975714C8B@nvidia.com>
 <3e22afe6-ecf7-4180-9287-c48fea7b8be1@kernel.org>
 <20260223115948.sbylmtqhznmabcth@master>
 <097A507A-C60A-47AF-9590-1D6CF712B1FE@nvidia.com>
 <20260301235902.duqcfrymearzrpds@master>
 <fdff3384-d62b-403f-a89a-f32abdaabe63@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdff3384-d62b-403f-a89a-f32abdaabe63@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 61zn7wu7jnb13w1nxopjnodkgd46exu7
X-Rspam-User: 
X-Rspamd-Queue-Id: A4605160005
X-Rspamd-Server: rspam12
X-HE-Tag: 1772442133-728107
X-HE-Meta: U2FsdGVkX19IL9bPdtTFInx5+ysknO5kkkDeBhLTYKIiwDgKVDMnSJW3pwU98g1p3CvuxL496On/4ehh7eHgqSdWGF20Wc8q0/3jmK/nDOFheVzwLzadXxFsGJGwmbqFHDFCsd3EqlDo27ibGzRwMyoICHI09Iem8ho8lfI+3qsoAnXmj1ycH7X6Sujlw9Z7SDL3rt29/6ic9McCJZmN0gj//5H2+XmnkdNJbMEtH0cASfMuCO2b0LZej5vDMFjIscm5QzC3RZQ9rIUIPUzNBjG3iag0c0X3UWT7PtbCqAuC5ccAhvpjGUMR2pYPEANcVMqAG9GRj/mmada1sGY/27u+fcqNSSnM/erWNtw9z7qKFXQHa0n0cGM6yqR7f2stF4CBABCgnz7/kasHNvytzoJnrQvz0/LxQAdHlqdUgc7KaYaHX36fK0HbVP41ecc5Sq/voRXa2HIQxxlb8iX2Ma78/b8o8luihYzPwF6oIv1Z+a0cExHInxMP3HrdWA6zaPQULHHtmRBNOhs3jDJRp8Y2SVr+2bFIVm/h7rzNDftExO9H1vD7R/IuJptiSO8+8CZJg0rfUOxZgeFakj0uzcfYAIfxLNKaPqY4OOk7wG8XNAtrZPP3mu58W4FttmXrTsn382nJrJcUoZk+YyorA9AHkMreQYPCi8zWfDn3tB916oJkFtJUJ2fI28sCmTK84SRSZNyF3EEOK/eQpkbfR0eySmBVbkpDl/FN65b0f1inKW6F1kjxD+I6U2p6CvdJdGRtswEw0WwyYkfCI6kgGOH1aML4JQV8vNsNN00DiTGwdDdhndMZxpKfmpZ7MQ8SU9ZaLwhGKkF5g9bEu+0WyIKkvcRJkKLXrXKoevRJtDCd7SJ3L3/5EZYQdkQkDdttG27mnAeIBjxYgckyZjRKpnFPbMA/hYwojR1/svnSs2/OWAOcGH3SRh3EbMr7Eo5xDigiDd6EN4YYyHdpeBS
 1IEoFY4F
 kPlaXZdaHK484o63UUVfGafbU0MH7v0MNkrwWES5Eam/Il1e921zc0rlrfhlAOtnoUhO3H7wJ24K8S9IDyR+l8mULtSvUVpRd6z9iNlwhkaARdXduW3EQ0TS3D00C8fsiiNuw5e8JMuPB9/elTl3OEwxttkEo1UvonsNlSAzIhGRR9siK4Wkj3scVEEmRuWzgWchj9vDTI93ifcv7gdQ55og9i+9Gcq2ZFTBQEHkgnLCohLCQyAzORby0Vk4WIp50bH63YZr73mnRz13Mf6VqC281VgXrF032ToeyX/FcZ/MfjPGjn42XbygkCY/PuJBtP6YB1a/C+jHvYeMq8X5xVXk/r6yzsz1o6yEB9bSiq88ilKMMQVcIB3NrnNX92q/4wW7JErNYpFT3KpXTkKMN81KtjJFF6KlXxbc4KKrJ/ScoQKJDS5cCXlMc94nBsy7qMCjewL3n1fdT9qP2FMDJzhdFIT8aEM2VosLUgvaN3A14Jf6cMeQ6pYDJV6bjeHdQAJb+5uC7Bm45OBKcVG5yjMaKQIlsN7KbwyQwFMQwXmCUVBEz/YleUYkL+MbFklksmYcZQSRx/J43kKhGyCSjQVZzB8mw0TraAdfnxWkXZiToEUHxvBAJxybXv7wBJwtggDMmfclN5rto/la7Bq4hYY2GuHVnagWDt2fvFCN2aB8+neqPiIWaDmbPuIbBKAiaegQAoi7DRN4thCOERX1Sb0wBQso5Aui7N9V3DuhTbpoFD2WPG9kbRgk6oH57Z5Kqb0IBfD/emNldqhAEx/Ah+HVbfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 09:01:05AM +0100, David Hildenbrand (Arm) wrote:
>On 3/2/26 00:59, Wei Yang wrote:
>> On Mon, Feb 23, 2026 at 11:00:01PM -0500, Zi Yan wrote:
>>> On 23 Feb 2026, at 6:59, Wei Yang wrote:
>>>
>>>>
>>>> Missed this. Agree.
>>>>
>>>>
>>>> I am afraid it would be complicated?
>>>>
>>>> Well, we don't have this usecase now, could decide it when we do need it.
>>>
>>> The patch below should work, but for now, since we do not have any user,
>>> it is better to update the comment and add a check to make sure @lock_at
>>> always points to the head page if @list is not NULL.
>>>
>> 
>> Hi, Zi Yan
>> 
>> Just want to confirm what we prefer to do now. We have three options:
>> 
>>   1) update comment and a check on @lock_at
>>   2) fix it as you proposed below
>>   3) do nothing for now
>
>I'd go with 3).
>

Got it.

-- 
Wei Yang
Help you, Help me

