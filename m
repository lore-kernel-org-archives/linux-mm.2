Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2ADACA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 07:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E758E0009; Tue,  2 Sep 2025 03:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465D48E0001; Tue,  2 Sep 2025 03:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37BF28E0009; Tue,  2 Sep 2025 03:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24EBF8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 03:59:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E0463140B3F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:53 +0000 (UTC)
X-FDA: 83843561466.18.CA7B218
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 261B740003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:59:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uMT0BAJe;
	spf=pass (imf17.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756799992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNeLWs2qHyUDts+2iHePFK0hNcgX1eWBxmSFpW760QQ=;
	b=MT0jnM/GQKNHwhU7qzu6kfKFZ1+Y3tNKJarLc4rSv995A6WzTr+M2kVSf2dMicjPoaHHjR
	l3DxG583b39kFvlfjibz+Xc1wA4ayzHVh6krckErbb0smj+aEJZ26Z+MCAucEBCZ4vdcVU
	kpg0bC3jCBF+TR750voCQhzT4uMdpIc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uMT0BAJe;
	spf=pass (imf17.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756799992; a=rsa-sha256;
	cv=none;
	b=rKv4PDNn+ibSvL4EtiZxuXMBTqgLzMqUfWjTYBo/AnpAObXqF9THJMQJHgsyGWEbIiCBDR
	uQZMYGNOmpKt2pzmlSdvN7dLZHrmccsow1ZdJbsGeyDRDPznSxKaDMY6L47VsYcHHGpt5z
	OzuKoYjX3ULDbEV/Zg4OIaXu4wNFyco=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b327480fd0so824571cf.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 00:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756799991; x=1757404791; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oNeLWs2qHyUDts+2iHePFK0hNcgX1eWBxmSFpW760QQ=;
        b=uMT0BAJerLhx/BjSdPWrEcJ1eR0ZtzE94zR2ts+fPsYIJPtCV3fG7GJreWpks7JNua
         Ojllwim85qLXTnOAHjMdYwr12EvZ5Xufv1vFHTWcIteYv2aXz7tvVVb9YHXzQLXcFoAA
         gLSwTg/cWle0XYilcZrH81Z06k1jjbYT1mo3ZgHc/ZMy2sJpWwR2nM3uITT0gZZM4qth
         gEzJURxBwuL6MPDnPkicmCFfEnSbh60fs3OtrAOE08VXqAvUNVMXqDtsYQfJ7ENLGTNO
         LnYhbSvIQKOSpcqmBNkDouJkICGH4WgbzW4+rftjPguqi5QbPbQI87rgtAYlf6i5HIdf
         wA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756799991; x=1757404791;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oNeLWs2qHyUDts+2iHePFK0hNcgX1eWBxmSFpW760QQ=;
        b=sx6G8i1PhwWit/BiourRNYlf1ue1TpBpVp5PV5N4nYi1BcgU22cf7kscom+1ZUDSRZ
         JARyBqG18AhIR+1JRE0UbAE6YaDybINkmX+HtBF9LSnh55nI6taygHHe4aDoUUZFALjC
         xaMwWpElCxaiQa7ZgFQgHNsM0KqRsL+EgGixGRNEHkkRXg9Z5Bqbe6U5q4XAnatE8A2s
         G/1WtmaHOj6nD/pv65P8z7mP6FTQZ1c9JXlcvysdAR8rPxbQSFfZgKww8j8jZ94qHkU5
         CNYDiRW/Z7qtsu1ZrpXRYZ+D8nqfuZoBmV2Rdq7SRKHDH4RkM+MG7hjo2bBXeqBdW8gq
         Z4KA==
X-Forwarded-Encrypted: i=1; AJvYcCXAPpKGSvCx0yAiWhYhjQFAFn7Z0CboDEvDelJUKK4Gq0nTdybl9OL1cDbGngukl7dF5fxu/Yirgw==@kvack.org
X-Gm-Message-State: AOJu0YykyN5cFmCsjZ/ibZuit9VbUjseWYyKQvHbf1K60m076UmnBVCK
	PhPv9CisQZYfGa0ZjkCIN7zecWBixEfBg2var4A8Ivp9m9+E7zmZFeZdyIFUeZpdZW8M+FUruc+
	I9NRNkWDBxgvBaz3KuLXVu2r6zXNLBRixUz2g0ECY
X-Gm-Gg: ASbGnctLCHGEZRxQux7c4SI50KtqNf2+smwF7tJd83vKKnFsX4NY073pf+syemGkRgb
	sYdGQmDS1DwVuhEqRcWKNOaocTPsyVxxYoaez3IE5EDLRan6g9zYwzDLAgnjZx9h/mtEWv0/miW
	yKi/2wfSsslz7dNjZaflo/mFw1M7C0kVsikxpUztHwHAjhTh6TQuI9v4r8OyLKwSC2/yE4eGLUq
	Rv4ZaSZNRl/aDvXRweQoOKPxPBhbmYLoRdZ
X-Google-Smtp-Source: AGHT+IFkdbqiMarowY+mmKOzuU9RyYySZu0bnzDQg3QNeDfxzMXfy+3OtZ2GRaaDn0H+MAu5W+vNpqCjVKeX20zwo4o=
X-Received: by 2002:a05:622a:107:b0:48d:8f6e:ece7 with SMTP id
 d75a77b69052e-4b31b245bdfmr13130661cf.3.1756799990207; Tue, 02 Sep 2025
 00:59:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250901135408.5965-1-roypat@amazon.co.uk> <20250901145632.28172-1-roypat@amazon.co.uk>
In-Reply-To: <20250901145632.28172-1-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 2 Sep 2025 08:59:13 +0100
X-Gm-Features: Ac12FXwFaub6kV3Kd2ykY4foMIV_-u80DlGRtIr2iGvqoKH4iO-6ScE4yMry24U
Message-ID: <CA+EHjTxPfzDk=XmwS0uAtjwsYB829s1uZSMC6x3R6KGQ-SqjtQ@mail.gmail.com>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>, "david@redhat.com" <david@redhat.com>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "will@kernel.org" <will@kernel.org>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 261B740003
X-Stat-Signature: i3ohjhnyygghrp8hsbcipcdpceaucezz
X-Rspam-User: 
X-HE-Tag: 1756799991-639650
X-HE-Meta: U2FsdGVkX19M294/1hNCDHIHvVbWCCgube+VHev8VmxYONrVkPJI0wLEjpbh9hTkHrgPYLOwdc77dErFJgOivQMZSuB/JNgKLlEF9P5+7PUFzgsMZiddIpY5AYqWUgZp8+G30VOOQoDPOTj+PCxe2nvwADvu46PojAI3Tvwb+Uh17iamTzErQHeemHUKflpd/9rnijTJvyTm+/yAvCWDbZ8Snn3bO93I0mSq1hT4IKc5aIZItSJF+n2+xce1o+poNjYIk83Pd+fKowp6i12hPIoTJx/U3uh3qFcrdxHSOo+UyAr4Urv8DFhDPcIu3oviXHkTsomj4FfacSv/eV1tfZuoE0hRbMcUn6kVupbexx81jpMHRvQbtbWTTg4a+y7OcdyzIEq2/BerXGUHBsSjV5FpzofnlnMuY1mvOof5DULj+KONmQtvAU9DWEKetOyngExz/EFJOXgZ82ikKFUXyulz22DgKLQkGk/hseUCTYP4q7LJeuGQqaTGyRTrq/WOpY4YoO0LBzyCwy8YpCNdT/Kelzi2RD9Wt2Yc91jcwG2q6dyJDxl1BjxEN921ubCFUOiSy5p6qFX+B3zJwxLF+lWa+1ieg/smf1woOz5RVd10WEoRZwtzSV5pLL4wv30J/2qzySu2yELn6zs0LMyiI5kocxiTm3QVhW+WYYOVGt6B4u2qJ8INqDihqqKMqIfnuakwhpuORSiVoxOaEN94om3n9tHkKJZfCs6YxkfUPgCDa+HQ1ycbJp9c2u7iiXSH+2oRVZSi7RAUWcdnCxz9erJaW7jyo/XtxbWMIX/i92jXRtBnZaz+dcPAo9OkLx29ExMyGP1kuRWlZuuo+8zyoqzEqCexUZ0aRJ/kfnhsAcS+BrZMRlR/UFSNkOUKHB3pXcuzNDvCIFML44rm7cT98PifA2cOiR3W1MZ1TPKKsNeiu0WnCwkszBW7MvuV5VyT4F2vPNuOCW0l0CqO7z8
 hSK+ERpx
 C9Hh02WecLmo3OjOx+k8FRvQao2raBGX59iwgBC59lU/yo0LoabY36z71xZzYJQ286tFgj2Korf4U4CvmIP14FemHp2inmA12cMgAM6iwjYtRqwIjg40JlozfhPDoBZlzy0g3xO0x+cx68QXnUUsjwij49pUJboFPySYm1xBd8PLJ41AwF+2jzVgJaXJES3dkHC10A782jD6zT/b/Zt5RGrvbNLBkKxBGBAunBIp0GmjQmEiiIHBqN9/UBV+kh/y5kZaZ5E81yyFdRCmS2s5lrDQHLqhrhz6ZI4SmzwLAdU4VmGrSZlgHhYbHE8SQW7DY+YLavx4k3DzuEcYzvBMiRKOYgNQ+wGf0tEErx71F/d0MetZge9m5/XV0NJnDJgPD0iZM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Patrick,

On Mon, 1 Sept 2025 at 15:56, Roy, Patrick <roypat@amazon.co.uk> wrote:
>
> On Mon, 2025-09-01 at 14:54 +0100, "Roy, Patrick" wrote:
> >
> > Hi Fuad!
> >
> > On Thu, 2025-08-28 at 11:21 +0100, Fuad Tabba wrote:
> >> Hi Patrick,
> >>
> >> On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
> >>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> >>> index 12a12dae727d..b52b28ae4636 100644
> >>> --- a/include/linux/pagemap.h
> >>> +++ b/include/linux/pagemap.h
> >>> @@ -211,6 +211,7 @@ enum mapping_flags {
> >>>                                    folio contents */
> >>>         AS_INACCESSIBLE = 8,    /* Do not attempt direct R/W access to the mapping */
> >>>         AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
> >>> +       AS_NO_DIRECT_MAP = 10,  /* Folios in the mapping are not in the direct map */
> >>>         /* Bits 16-25 are used for FOLIO_ORDER */
> >>>         AS_FOLIO_ORDER_BITS = 5,
> >>>         AS_FOLIO_ORDER_MIN = 16,
> >>> @@ -346,6 +347,21 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(struct address_spac
> >>>         return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
> >>>  }
> >>>
> >>> +static inline void mapping_set_no_direct_map(struct address_space *mapping)
> >>> +{
> >>> +       set_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>> +}
> >>> +
> >>> +static inline bool mapping_no_direct_map(struct address_space *mapping)
> >>> +{
> >>> +       return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);
> >>> +}
> >>> +
> >>> +static inline bool vma_is_no_direct_map(const struct vm_area_struct *vma)
> >>> +{
> >>> +       return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);
> >>> +}
> >>> +
> >> Any reason vma is const whereas mapping in the function that it calls
> >> (defined above it) isn't?
> >
> > Ah, I cannot say that that was a conscious decision, but rather an artifact of
> > the code that I looked at for reference when writing these two simply did it
> > this way.  Are you saying both should be const, or neither (in my mind, both
> > could be const, but the mapping_*() family of functions further up in this file
> > dont take const arguments, so I'm a bit unsure now)?
>
> Hah, just saw
> https://lore.kernel.org/linux-mm/20250901123028.3383461-3-max.kellermann@ionos.com/.
> Guess that means "both should be const" then :D

I don't have any strong preference regarding which way, as long as
it's consistent. The thing that should be avoided is having one
function with a parameter marked as const, pass that parameter (or
something derived from it), to a non-const function. Instead of
helping, this could cause a lot of headaches when trying to debug
things in the future, and figuring out what something that's supposed
to be "const" is being "corrupted".

Cheers,
/fuad


>
> >> Cheers,
> >> /fuad
> >
> > Best,
> > Patrick
>

