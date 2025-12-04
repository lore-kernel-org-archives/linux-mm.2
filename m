Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E56AD2CDE7
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 23:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA006B00B4; Thu,  4 Dec 2025 18:23:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859D36B00B5; Thu,  4 Dec 2025 18:23:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685566B00B7; Thu,  4 Dec 2025 18:23:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 52ADE6B00B4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 18:23:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 159C486904
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 23:23:41 +0000 (UTC)
X-FDA: 84183367842.27.55D65C4
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4003B180003
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 23:23:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=gmCP3mGj;
	spf=pass (imf06.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.210.48 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764890619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hr7YzaYb6eBISUfqlJbQwKFjf3zCgII84LAcloMq6GM=;
	b=I1D3ZB5Xtt6j5bVhmimKR/MyyjTE25XuSPVTtWW+PxZPS9KktNVrS6RwXyJiU0uLu5I5jk
	jJ+Soan7mQkty5YXtljYtxyp1JOxmX+3QO4bhGLkTuShyMyXG9UXsDRn1siMCnhOjmpRNC
	nBKaYO+hYCD3A5qVlIQ59QC1rLbyg7A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764890619; a=rsa-sha256;
	cv=none;
	b=AbriRWisJ2Jgo+qgQiGALbKgNASbJgoLqfmQf0kMyGGuAAZ14g0Sg6Eq2+J846vRqO3k40
	pfgBUVOuH2dFRedKthhPH+JwnNw1eYyIloSk/9y/jEifjfJ4uL6nYXoobB4/Ur6gN0FE5p
	2vSV5HeoWMBPgFIMtdnSrU3iPTe5TKg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=gmCP3mGj;
	spf=pass (imf06.hostedemail.com: domain of skhan@linuxfoundation.org designates 209.85.210.48 as permitted sender) smtp.mailfrom=skhan@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7c6da42fbd4so834574a34.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 15:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1764890618; x=1765495418; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hr7YzaYb6eBISUfqlJbQwKFjf3zCgII84LAcloMq6GM=;
        b=gmCP3mGjRfv3iKO9OURPLC4Dii9XKpEn/3mf+olTtsQ7waZhDvIci855Om1M4q1aKZ
         O+Hzznp71npSGryjwTfZQYVQfcAegnybGAKfqU1h0AonXobkrKB5GjVZr1ggdR8uuyBr
         9yT06peGa36m2F6zhwTEIaia0X/080sQW8E7Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764890618; x=1765495418;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hr7YzaYb6eBISUfqlJbQwKFjf3zCgII84LAcloMq6GM=;
        b=wITx7LPGkeor6oOunbN9MZJpKugl9j5xLBIIjDyj4fBok0fZ95q7++c1VPTyq13ptA
         Ez1kTRchLZResnwABBFflBfpJpPrVRuJWg+R2C01v7gNHsLJtpDdil+RxmimLUZBbERw
         Xu3nujPWBzre86rz3kUQmsxKPsQLPpQZJ8oec7EQHu8dPRdmvWG8K6Hagz/x6KC7/wjn
         siDLoxIh66GZrchpNXHSbqIOI87O3ftTdhvTeb5kmKEr574sv4EJSrYJKb/R5xfUFo0K
         v0s20l/9AWmtjq6i1nfF0c0+AbecULd+Mww4gTlajm0M4AGNUhNIvpz3MaDw+6GI2XyI
         BNZQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/rolt1lxieYA0oSCp5FWMejBjIU4uYgQZjHns7eofZc9WvSqvS5GZltmbNzx/9jvUlnlqZ8vgKA==@kvack.org
X-Gm-Message-State: AOJu0YyqnmwZaqA9IdW/1VLX0DtQqWTNjgo/H5o1QR1x1kH5J3CxbQC/
	tfHQwidDl7mUcQnUVo1+SeShHS1Lxja0QXoTetJor6C8ZYNl9X7nWowUzF9ItqGKA0k=
X-Gm-Gg: ASbGncsnatNYiyHLc6NL4OPSDw6vXzPYl/EG7YufaU4UYkIK1B6h+Gb838/H2fvlgM6
	dWaSgY0hQcY9rGQWk/IQcgoy9oihX+ltzH7QW/rCg2PsiYPuoF12I7Aog/PDt1c9+d+0pGDcaTl
	goDCSAyh8azg7f4DGHi1bc62B4CBO3c6Wy5ulTUg121j8u1p9iB4sW8YbgYXDfRE3Rqt2aTjnUf
	6Qqxg1HCjULSi9bye9J415Bdw9ijZ21YRslXsJuLSJlRcBBBgGlWirzjDeEv4d1t9X+dRksmMcG
	3fFeMds1M85eWeno6jfis2KqsUFKrcEOs7xGn89NJfVK8fi3BQRLar9a6zwAm+Z/5n4NJPMJ5rZ
	/ZjmXYfc90OUzqcoQGBwJSTH9i9r6yUxVlSIswZ/SBPGAMBJ6ITWZ3xzQbTUp/ZCCEb75cgXBHq
	eEEek+NbseLFOpUxj89nyndd0=
X-Google-Smtp-Source: AGHT+IHwjZ/zpAGcvx6Y2WWCyk7TEnPm6i5oJD1lnEaXl9QZZMoDHIIMLrGP7RHllD2MXO9k2S0g1g==
X-Received: by 2002:a05:6830:4112:b0:7c7:5907:b1a8 with SMTP id 46e09a7af769-7c94db4a335mr5228767a34.13.1764890618208;
        Thu, 04 Dec 2025 15:23:38 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c95acd733bsm2409067a34.26.2025.12.04.15.23.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 15:23:37 -0800 (PST)
Message-ID: <317deba2-e560-44ed-a9f7-3c6fdc446b6d@linuxfoundation.org>
Date: Thu, 4 Dec 2025 16:23:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb"
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 akpm@linux-foundation.org
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
 christophe.leroy@csgroup.eu, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, masahiroy@kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
 <51d8549e-b084-498e-84c0-76fd3de116cb@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <51d8549e-b084-498e-84c0-76fd3de116cb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4003B180003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: p1gkbhje6xe7rizjcrrgut7tnj7deqtn
X-HE-Tag: 1764890619-124054
X-HE-Meta: U2FsdGVkX1/OWWNtkCwuqN1gxWN2s54td0QbbGla7HnWh2z0xIX5lpEl9kdSV0sZ2IjzX91ZRObnNb+bf3KgGNHn4JuVRC6j0NoVEs5IzYALM9adm7mWkszMna2Y/8HCilWC8EF+wTADwNcFjFMD6BvyOm6Yfttah/fBjqruookDM3HZPynF5g93z6YvuaaAkJC7dtv2OYAY5fspEWOSsHBeXDCc038p0neIsWG+MYsjDlC1DWvYO46ox7Ax1XRwmVHb7hwRs8TJ0ZoFGM6fgdWMHRB9d0FQqdtfCb/B/WpfZNutUK3/+MFHKekTWvVfYp5UCYj4du0icGgRM8msuai1JcqMQHxRqel2EaYf9oIUlo5KZoyDv3zR3jGTTVK0wQcuk3Vascui6bdHyukxCqdrxfabmfnRgQvxZR658ZWflfO438zQ6H8iM7Tr8mbVMjLSjF5qQ0g9jtL+3L166g2+NCaVGDTruXBYatLz7bGWGEW+GmySCYF5JaAsEMJMvpkOxy60uYtYoLyaUJmriCuTvNhjHxc5n4/ikZQgcyAo7dSyVtkhnhCT4pltjmpz9/nSody3Zy/XLaFkqZH+g+HJKCJ+kNtR+TGitfny0SScUV5fEK2HBtgyglztRB0r7KdBR439Zlz1/L6EVJSW+lEpsR72ZnMYkezTHMNBE21HmNMRKBVMoFwUCrmX/1vAcqJt//V+N7JBdysLhEYmeDSTzqIXHm4Mqo+WHaSMRdcSSIwaRdQv3t2TMToGom/fgmozViPmvmLMsO3rFSTdM8sFdJZFga4ylndxJQrPOI6/f6YY2HxebuMT0p/qMwDeGdWRt2SAxc/bsk7b/AvLCdvRH8ypKagCq5Hhm1A5WcN795C35aDE5q/bCOALqyh9zNrGeoR+4SjZDnDxBNVCHMJ2Zrln4UTOBZ7xD/pYOaT66QNz1szRKoeeVXo0vJOOVoNzVyip+CYYHMR5Q37
 f8jRfgP1
 OOEJQgCv73/91Aqj1ZWZC2k1HUo8s3yXAiPy22e62I1gw1Mvcu610iTAu4QqsZNVO/tN6GO5GqMBOsOPqkdcDuNMhVHiDb51eJiNF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 15:16, David Hildenbrand (Red Hat) wrote:
> On 12/4/25 03:33, Shuah Khan wrote:
>> This reverts commit 39231e8d6ba7f794b566fd91ebd88c0834a23b98.
>>
>> Enabling HAVE_GIGANTIC_FOLIOS broke kernel build and git clone on two
>> systems. git fetch-pack fails when cloning large repos and make hangs
>> or errors out of Makefile.build with Error: 139. 
> 
> Looking at the last part, "Error 139" was confirmed to be fixed in 6.18, right? At least reading [1] there I find
> 
> "it was issue of 6.18.0-rc6 kernel itself. After switching to default Arch Linux kernel build went without problem and I'm now on 6.18 stable kernel."
> 
> Did you mange to report the make issue you reported here [2] on 6.18 as well, or only pre 6.18-rc7?

The problems I saw were on rc6. See below.

Repeating what I said on the thread so we are all in the
loop and on the same page. It took me a bit of time to
retest on two systems.

Both my systems were running rc6 - I was stuck in a state
where I was able to rebase to rc7 and then 6.18, but could
never build either one.

When I suspected rc6 to be the problem, I booted rc5 and compiled 6.18
after reverting 39231e8d6ba based on config file changes between rc5
and rc6.

I retested on both systems on 6.18 making sure I have 5bebe8de19264
and 39231e8d6ba in there. I cloned linux_next and built it on both.

I didn't see any problems on 6.18. Having said that, It might make
sense to hold off on including 39231e8d6ba in 6.18 so there is more
time to test beyond 2 rc cycles. That is for you all to decide.

thanks,
-- Shuah

