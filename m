Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E4F4D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 13:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13316B0088; Sun, 11 Jan 2026 08:34:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB346B0089; Sun, 11 Jan 2026 08:34:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEA976B008A; Sun, 11 Jan 2026 08:34:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF3A86B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:34:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D589D0B99
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:34:34 +0000 (UTC)
X-FDA: 84319777668.24.43EEEED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id EB66FC0004
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:34:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DCQw6yH1;
	spf=pass (imf22.hostedemail.com: domain of zkabelac@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=zkabelac@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768138472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iIwW7B3/vGlG96EY9fov8v0A5KtPeBu8NxLAHkqFGo=;
	b=K4p+TZEaVXPmQaPHdMvqE6uSIPcf61oowmJkQYiJ8Dper+0ysfCuuufRcs+DQl3oE3zgrH
	cc/wJonmgaoPMSawCwxYYdtxNe2w3qodtJ003f2jGq4Yvjq3E4h2Ed4INQPEDd+8if3TKo
	NdyuPezTf3Pt+siFIDGuIA3l8wMNy8g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768138472; a=rsa-sha256;
	cv=none;
	b=jO4aAZaJ6xgeS6HZ0H2QAW1a9nqCtsn1IkPXpR8qOpnG44ib2ynlH3rowUwTPejwTpXUml
	3Q6PHs8w6kQc4aigUDRAayu+PmVzovFmz0cW8gp/HcJW2MvPPIBsSY1314sY86mqrSOdEj
	tX+/CXu+2NfBUxDN8Ggep/RLlgV1FAc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DCQw6yH1;
	spf=pass (imf22.hostedemail.com: domain of zkabelac@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=zkabelac@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768138471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1iIwW7B3/vGlG96EY9fov8v0A5KtPeBu8NxLAHkqFGo=;
	b=DCQw6yH1XGpPBxa94dHiD2wOv4JKEFWe+xRTQxI+Mj2X7CWKzUr4G/43ESdu5NNyPVtDVo
	aVUcrSiIAtlWp1yv99faP/6vZx+DIFgX9dLcSG6L/7C1GOIW5LsbK6FZJXermh+OAEKPzb
	KvwDieFRVA98+cf+yka8GEjJGiqIHJw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-zqu6TYphOVCfQ8JX3Q3UPg-1; Sun, 11 Jan 2026 08:34:24 -0500
X-MC-Unique: zqu6TYphOVCfQ8JX3Q3UPg-1
X-Mimecast-MFC-AGG-ID: zqu6TYphOVCfQ8JX3Q3UPg_1768138464
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43284f60a8aso3143608f8f.3
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 05:34:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768138463; x=1768743263;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1iIwW7B3/vGlG96EY9fov8v0A5KtPeBu8NxLAHkqFGo=;
        b=LgRyRMBU5ZnkV7BangfSxc5czl+rVEafNPX7s1ls47M5bihhHmfQcSDyrhOqnOTpJt
         onZ2RsBSGhB31E2nH/W0jfzATWY5N7YgE1bfA3ZsoB+1itrI06kj6rseZQuAvjztmuCt
         fvcGrBFVyx+s+HUBZ7kt6HSYuvpAwDAU6+xPn6dLQfRB3eACR7Zg4aEBNviOWRdhOVsJ
         vP+3slQJoHoVyYeVVK1ldKRQu738zuoYIDMY+EgfHZ/cCd/oYCfz8DAhtj+2uZIzwAPU
         9y89ZNfXxqWrmfQd6EUXscd8uRhpRd2MfGFgsvfOn1+7+XVFuTyCcK3SKFs8547pHX9Y
         foPQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/3F3pwraN6netYDULZonPTYQMTTVoSPz45fVOT9kB102bLsZU2x25dQt9D45EL8whS6Q4tZIBaw==@kvack.org
X-Gm-Message-State: AOJu0YzbhebYykUaXgNBEpCLoDoRsCsRXX2zw1ZGDACnUdxnAC3cv5V0
	aqO8T0SkAUdOsPAuTXYc49BNvItcsW37OinHT6VuVh6YbjgI8J1UN6fi/HvxaD/kO1hsK/YP2yo
	9gNYS9KUvyAcNvbIvNGx0LtSH1nYVnvmkyQOS46N2E1uiGhD56a9q
X-Gm-Gg: AY/fxX6J8XG46S2Y6BDDTG+Hqs7in8MgnqBGAEVtm2jChmUvQcGAyfedJEiR4v+BlOi
	/6pOoBVaJ5RtIAFlHQzwRlcOH9kw+ZSwivSQisC1d5aAKa04uyJNmg1cEXt2u0jfhRhOY1YrEQD
	wT3O3FQ/Pf/psXPVLfDy6/1HV/fHT5S0DD0vdCN2yXNiuXqU6lW+/j5kjpbhPFFjHPr141RGasi
	iik3LO0Y5G0v8y7Q/sQYEhRkQXwkd7o/aWHPSqJeOdJzrsmFn6+MWFkNXxko6dEwRB7oVt+X8VO
	Hl+5YhhL81LqX3f2mGR04w/Ra8BJqR1V1bDuR9ie/SXRNzfYtUlsLq1gcsoDgOiLf4Vedw096BY
	duzcEmG9ok5fJ
X-Received: by 2002:a05:6000:18a5:b0:431:8f8:7f17 with SMTP id ffacd0b85a97d-432c362830dmr16282394f8f.10.1768138463561;
        Sun, 11 Jan 2026 05:34:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEUrdZET3rEay41v44TRADbajgxRdDNJp4A+SRYJqr3oi8KK+Jf1Lh89iqwj9E2Qa02SJMCbA==
X-Received: by 2002:a05:6000:18a5:b0:431:8f8:7f17 with SMTP id ffacd0b85a97d-432c362830dmr16282379f8f.10.1768138463142;
        Sun, 11 Jan 2026 05:34:23 -0800 (PST)
Received: from [192.168.0.99] ([212.20.115.16])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dacdcsm32760448f8f.1.2026.01.11.05.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 05:34:22 -0800 (PST)
Message-ID: <fc1d7900-3a5f-4b31-8aa3-8c8cd317d646@redhat.com>
Date: Sun, 11 Jan 2026 14:34:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
To: Askar Safin <safinaskar@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: adrelanos@whonix.org, arraybolt3@gmail.com, cryptsetup@lists.linux.dev,
 dm-devel@lists.linux.dev, gmazyland@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
 <20251211182429.3300562-1-safinaskar@gmail.com>
 <eb3a9746-83a0-8271-6bd6-867ecfa49aad@redhat.com>
 <CAPnZJGAvA+SpkMeOdZx+SZG=qZxSXOThO+Or1bgw=3QqCoEDgw@mail.gmail.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: RedHat
In-Reply-To: <CAPnZJGAvA+SpkMeOdZx+SZG=qZxSXOThO+Or1bgw=3QqCoEDgw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ldPssGpadpX1SbLQjoj2VvHJlWaDCE1peK4oF2co7ko_1768138464
X-Mimecast-Originator: redhat.com
Content-Language: en-US, cs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB66FC0004
X-Rspam-User: 
X-Stat-Signature: xymuyzggi1rprj65ho6uho36r885ennc
X-HE-Tag: 1768138471-68654
X-HE-Meta: U2FsdGVkX19WKLnMLl0OhcF9GfNP8h9miUIsodRsJMaJXeUBWazOU+YFleDadq3elBVmozH6OPiX+u42Z5vwY6GlvhQIgA1Hpqm9vwhpFOPIxPo0aJSzSSSkJ1lbkybrUxX38gMJTm9pAfemDpzLqEL070faAEVXRfWcjwRL3G8TyRu7Bffdk5yUiDv0Fa6pQSMDLTQjbpRN5P99LBIpW+KEdQEIjrNr+ItfsVtkW9uDGfYRAVQOii4JSodR7RtMrnKIkiwRheI18zRowAZ7JYo9uz7SY3S1EuxJkEffjPNC3niye1floFfSawbd0eI4wtaYcQfrQePIiLJdqriT73XSqbZjy2IL2PMbcZQlk9KE0wtSiKftVCREWtTcTT1F4eNZ4O4UQnNnPTFvirg9aiceX5kprcQar3BwuYvklbXyl7AbGLakY0Par7Vyc7dl7D3QYwmrrMVEME4K+MaOYt1Tgy8wPIPkFq9vvxo+kYXrIrnNx9mXDi8jt7wvH8ofrboDYVysSpE50iWn4kC6W3eGi+GxOmUOMcfNuN9kBFFpgqbJsKBheEpY95u+IWBXZ2wXAYqT5ctEKi16RTGgD3K2Vl05KSqglkmcvjYnkntsDv8BkQwndff4Wopf9gF6xINUjriseSldMpPrWldFGLZwRbv5OYLpOeL8cLebyXn/U1N+XEHbc3Yt3Rd7BMuAjovriUAJUHpdAw+t7dtSQDQNnEaBXFPxK/rsMxMx0r6pepQe+8LVgMIlmaVM3aF3hclU6eYx8zGrdr+6ZZKQi8rtZa16mdM2txRmTZHACrXLGk/m7R8FM7TlYTQFKQIxLdCdDp4K8+oyeEoWzTOk7TmEcZVXEe8tmcyMiKyTEbEi0N/+b1n+eYjOwQ6m05JNyXyl4dkqmQ4NFb3bxYGZsJWWnQdLNxB75YDSCRyAdPNitxdEULcZKboc5huJFxxWJ0i4MdIpPIxFeMOnrSf
 CGM58CFK
 sqeYMQ+qMWYhxm2kOrXkJQAcSvQr5GpKFz9AivIHEONftah7TltaDna+4F9K3juWhHuLovorR5I1eFFYRFnAFD0MwJfDItHwNvmKPCWS2DtmT4CjWAbMts3AQCkveXXybJd3oF/1jHSRCipdX19oZg8fNoMmOD6CLaDgc/QqvpMFu7ukmF72rX58Zp9dIRn2IIAOQiwDUAAB8WFdQ3xMxQ0QHBqPrr40WafkxTb5I9a+qMAfo482tSjqvc1Uu/tmwySoOvnbZFRadFvQJz9PX/FMKzPrVjPgHWHTnAOC/U9/pYXIE0WbDWJENxtnbwdEdsTRnOB8zwqHqAVWkGGqvUmXzT0nF+45T0pFfosO1ZgVOz3pMplNOJHO/hCwSlf7HcenjK9GfL8t7l+bjYpDpPh/UslRA3tt30VJSgay0I/tt6uQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dne 10. 01. 26 v 8:09 Askar Safin napsal(a):
> On Fri, Jan 2, 2026 at 4:47 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>> Hi
>>
>> Dm integrity doesn't need to allocate memory when processing I/O requests
> 
> Thank you for answer!
> 
> Unfortunately, my experience shows the opposite thing.
> 
> [[ TL;DR: my experience shows that dm-integrity journaled mode is buggy, and
> non-journaled mode is not. I. e. journaled mode seems to allocate memory, and
> this causes temporary (for 4 minutes) lockups (on high specced
> machine). Or maybe journaled mode has
> some another bug, which causes such lockups. They are not reproducible in
> non-journaled mode. ]]


I think it's important to decipher what and how it's blocked - I kind of 
suspect your system is not blocked on 'dm-integrity' itself - rather some 
userland app being swapped out of CPU.

You probably do need to configure your systemd-oom killer to prevent getting 
your system to it's knees - if you run your system to the moment whether it 
takes 4 minutes to run a task - there is something seriously wrong with the 
configuration - as OOM is supposed to kill userland RAM hogging task much 
earlier (possibly even your overbloated google chrome APP if it run out of 
bounds).

So I think you should also show whole device tree of your system and some more 
information - so there is even 'remote' chance trying to reproduce your scenario.

Regards

Zdenek


