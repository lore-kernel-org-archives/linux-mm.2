Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 575B6F31E57
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7CE6B0005; Thu,  9 Apr 2026 12:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F6A6B0089; Thu,  9 Apr 2026 12:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5576B008A; Thu,  9 Apr 2026 12:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2906B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:17:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B68B8C6AA
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:17:02 +0000 (UTC)
X-FDA: 84639521484.02.A263C2A
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id CA1D940014
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:16:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AnHZuapb;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of technoboy85@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=technoboy85@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775751419; a=rsa-sha256;
	cv=pass;
	b=Mv6hWdsvXclTg9vd0nG24pKTEsUrPAY9NCnIyVocJH7ji+mciv0LD3imBH4lPGUAQhtxhv
	PWldrAI2YJZlZpasca1Yef70PrUPyZCYwbHefUkzib/f1lPYJDUU4JkbQ29gzmeZ+eus7e
	uUIaz6qVs0eRLn80km3IUjb11ZrWhRs=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AnHZuapb;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of technoboy85@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=technoboy85@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775751419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQFyfbZpEY5tsQkH/R11s1S7djWon24HiYbDSXiUGk4=;
	b=k0vwCqdlGV/qCilwynhh6fP0/7Iy2X0slrZXmv257ghOyDfKkgfZhiUlfuI4UMhfu9w8Oo
	/LlvWT0K5f22bNhwsgAWBtLTBSSlLrUGJNrE6tDJlDqPYa8qdNeMQQbSN+DUyQnAZtrZSb
	P++7+wNm0bqdVbUAqLICmokVfMiCr3A=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b936331786dso131657966b.3
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 09:16:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775751418; cv=none;
        d=google.com; s=arc-20240605;
        b=fn7zFvHvWXDrzwEwJnx5wfRNAgccPNCitYr1jcVTYP/m+n+//VVtdecLCKDSjlBwva
         nEIi3R/VuU6h72iyGrjlqRGXpzEUfec34myaf8HqsdaLHh1SlBmYfGQAGj5eiTLurogs
         yAxX6JLAxlES0qHKhaS8fo+EJMXAbKMsLPXMrM/aaNjm6KCLll8fs7cd9KUBouPeMVfq
         un54y4dWwUhnHUhrceWDWTCpFnWADI5wmuNSNehGQXgesjN4BooHTzFHsNdLEKBCADq0
         SYzGwOyAc95KTxpA0rQUYQKeOzjVK9QuthYO47X+ziyS2AKR3EULnjC2SYitazZ+hSRn
         WuMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=oQFyfbZpEY5tsQkH/R11s1S7djWon24HiYbDSXiUGk4=;
        fh=oKwEB+Iq5K4Iostgu68Lr0TeAQTEh6VSH9LW+8L3Oyc=;
        b=ihrt3Y5A5RSYi/TTpdGcDZAVf5bpKRjLiuElHM8bJtsvr1xO9qanTEHqX7lyE/PqwA
         wwD9RkMLh+uqD+jsjjLMncaPtXGdJ43uLoJX9L0eWZ/zlmTyp/6askrvR6n2B7xdYPOa
         4N6PCl8ndsLQRFM8/wNywT9bnGtcEpWy3p7IOGqg9nEo5TCj54UB4mt770dSIzDif72R
         hulC3LrF7UU95vE5lvnHEInKV34jQ08mfiefaWAM20TyjItgcYto1V1Qpx7rdCIBkDRt
         aFbWpoKXjHobb9FV5U90Z2fxztX38y/hTm3kbDSsczFwcIoLQ7z41JP/oxPkOx/pVMb9
         renw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775751418; x=1776356218; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oQFyfbZpEY5tsQkH/R11s1S7djWon24HiYbDSXiUGk4=;
        b=AnHZuapbB6iTk4RVWiVgFLRPVB0nPLBmHIFHzofErA3zPO8wpNQNsuFkc31bC1G59a
         ZvFl63QIBWaUNtazB1bue61GLb4MVDdTpfuNNotFZNxJe1Mx1D1mAsRUEJ3wxI2YmPoF
         Q9pXyOzTEieRxxDTCRF/Gf0dPuPS8lfC6c+vq+pDbVulXNM7r2FkUertRu5A3wpwLX0r
         KoMzyPYvx0dnlvKCI6DGHGgBK7UdQIKDbOJyxeh6ae6GB4SKABRijYDU2vCPAd5kSAgo
         GkFUqw9SHJ6G1nr7BM00PNQRFbYKYqV1TO7mCI+xXJKpmdZ7peF+VkBNmJ8n2kWpbftf
         OBow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775751418; x=1776356218;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQFyfbZpEY5tsQkH/R11s1S7djWon24HiYbDSXiUGk4=;
        b=DoYPg/FI04XY2xwU0rUfqM0ubE6JXCP2Pha+us4xgoH6ZJm8P4Dr+mO724BWapUyr6
         d+RmuzgDPLZrWNJTOppPHYXOnJ0dWcFoTaSsifwn1OaudvMbz9LcIj12ZzssRitB43Uc
         IX9EvclXkkIn1OSdSAOTqw3Xvv4qPDmhJvI3ZpGirQBNxjKhB/qJCazyaK1F3ax4LM0A
         DPbSyYfuum3N5ukz2emRXD2/vEGiD/PUZr0ozNYS0EwlqkPYmPctdmJCNXP4/PYrFV8g
         JiibYfxIYIhvHpwvs9fO9pU+5ggF9RvaE8aH6vIYSj9Dm59USkj1V/zLfagdlulnZNRN
         BfIQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/RxT4r7oOBaN9npjfjkImqFYc5i3qFjq5Q7QXNwFmAIDdPcfvH5RmUq//89fJvWRk6IpbShjasQ==@kvack.org
X-Gm-Message-State: AOJu0YzKjinXhlQkWHDEkwksv8jICZ3UWh0w6ygUVtxshVcdHfO1zslS
	yHiJDYeASgHMf8417CVGFcl9aNWblCDgaVQhbkpD9OYKv+Rk5uuEReNuwZ0GjmsMwNVTlN2BMiw
	GZGCSbJDQHHnSxFqZnKY1xhSKv2hvVEg=
X-Gm-Gg: AeBDiesvrLSZlWRd8CqOAdwLFttD5iCsVul9TmC1TcIrexJnxf39qrR6LRidzEs+6gO
	ZYLN571Ha70nYRDd24MirKUmLE+YGbyrDR+xyEmTeWda2MVnV+FYU3i9M2TCB656WUNhPdQ3/VP
	lfFRhFgmFuv5Lvk81K34QvsrMi0kw+4aOYIhOSOjx/r6UYr6892CxxbvDrpV/FlOhJKT2i/GOKg
	wC4V1OkD8WFDXiHpfb++Zz70ARgm1wyaHSk+d8ye9D3kdUt+APNW16oB4ANfL5sNNJCjpgHvXZS
	Tse8Szg=
X-Received: by 2002:a17:907:961b:b0:b98:4abb:cc49 with SMTP id
 a640c23a62f3a-b9c672d41b7mr1226019066b.5.1775751417925; Thu, 09 Apr 2026
 09:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <202604090741.1kUVXMoc-lkp@intel.com> <CAFnufp29D4VdTgoJ4uDk-dQ4-RuO_C6=TQ7O9TA5M=JSe1j+cw@mail.gmail.com>
 <1c7e8c605d2373c26b08d0eb64cc56efd69dbc26.camel@perches.com>
In-Reply-To: <1c7e8c605d2373c26b08d0eb64cc56efd69dbc26.camel@perches.com>
From: Matteo Croce <technoboy85@gmail.com>
Date: Thu, 9 Apr 2026 18:16:20 +0200
X-Gm-Features: AQROBzCo2-VgCldPF46Lb3Hu44BVes7XNsrMjMa5Vs3HM6cSgqwi-R1iHJrqf7c
Message-ID: <CAFnufp0qW40DrZPG5akNaoXanRNN2MBW2ougcwThtzAXh-z5VA@mail.gmail.com>
Subject: Re: [linux-next:master 8662/12838] htmldocs: MAINTAINERS:40: WARNING:
 Inline strong start-string without end-string. [docutils]
To: Joe Perches <joe@perches.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: zc7wheuw4bg8nafa1spxdrrjoq6sa3kr
X-Rspamd-Queue-Id: CA1D940014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775751419-489620
X-HE-Meta: U2FsdGVkX19oAcupBXvlvWHW1Pt2hNUQOcDxFoTLne/BkH4s+PxLDxFGzPUJnjpYGsLqydf/2K9W76rlT++45dkwHomTZg12GzO/+fbBu32Ain/DzqVv8JF+5xtXQoTa+sjqC4Gpd2XJWvlsJztcRBhAnf+XNPoiML8Zx12FNaM1l+luFaPLJ014rivSreTwoFBcJum/HHfpN7oAVDSOreUB6jNbW1UDZRheTxucVJymnXkzD841v8jp59857FT0hCIvljaOa8OJZtIu5ZVjO8AqyCoz6F0W17XOYzAmaA5gBzctt0cTo0ea/PkJfs7ejpAbr+JoatS/afwHDMAD5xLvWMuomP/Y63BLARkmnS5JrWykTwcEeOEIA4WaCjkuxfs0s7pnfOtV6bN2GBW+SyS/ZgnWX/iFGWSaRY1Mi9HOCBGaILlyxUBHTxXAAWEtmG53s9yJg4wBhPFypvcjXfagWRoesnAyBSXwdV+hDUTgg49ckqxwDYQaraSTTiHXGOyk5XZtbGakxUm8PJymNoBsLh3qdEHXDe9fQC6sypO5tR4baq8cO7mIl0l7b/FKG69XqFGtmCGOCV24iq23/vhVRK1wsES6CXFdn3OyTsMuRVoqdb1JGRW6PcjYNTg3kPH5o/pVU7Xo/5kdR7VL1cwt7dkKheF0HikoAlHyAbcc3Hxzc8v2x3g56gjEA86nA2+b1XObHoeiPcZjoXzeJOhuJk9aiNxwmUiXeMtA51gTP3YE0vj5K4YqM/Q8TWKf2wCcjyGvdeux2a7XYjn6fPMLwI1Qnh68VZNGQieOPThqdKfu+ULd1/FPxxd6j4y7nONSjl/vU1npvxYbqLb1ybjoNxAcLMy7MusBQg5hrQIlb3ry2NNYQF32oQi4OfHe7g3SmhTuTPEljxRqjwBEDVBz1mAiGxAImrnxM5PosEm8PgDFaEBOMD82Y+M/cLCPJWi8P/b5HLohc81D3oc
 J3604g5p
 vp72Iam0Gb62bhBIKfiTRHZoBs3OFHsvK8mfCIbO597yaWZ87AYG2S8iA6PyJI4iCbFtQJC3cFiN8FqHajRTVw1gDnwiOWS68AyJyhkAUs1AkBFXu91aH+z0oi7zwFBCIBhqsjwOP+61ZMOIbdlwg2BsAdW8pJOSGgjHbz4IDs0fM0XqKKHP3wAR+4coNDToMCez2PPC1s07DJqutyNBnUnoxbc6q3pVPGFlAMtPlGqawqOz1L0l6q4cdaxr9cfuRwAnpOzjuuJISvwKK54Pnc1sGeYaFBDCMS4Mb8MfXy8oFjDp9J3ejkdgeQJKdwM1fEul3xWn95xYDfDkbtQdssQ5TF11/J+hCz0yIqdozMipwPQhrC9DtF+VbhIetVf/FcelGiEvO3ZtTTwshrGLIMNVxcvjOlC6yrisT0aGYNRjziColKbRtuCz+9JHP/rvaMm3utE433vaQcdo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Il giorno gio 9 apr 2026 alle ore 16:47 Joe Perches <joe@perches.com>
ha scritto:
>
> On Thu, 2026-04-09 at 12:12 +0200, Matteo Croce wrote:
> > > > > MAINTAINERS:40: WARNING: Inline strong start-string without end-string. [docutils]
> >
> > >
> > >    Documentation/userspace-api/landlock:480: ./security/landlock/errata/abi-4.h:5: ERROR: Unexpected section title.
> > >
> > >
> >
> >
> > The problem is that "**" is seen as start of a bold text in RST.
> > Escaping the first * fixes error and keeps the glob unaffected:
> >
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -35,7 +35,7 @@ Descriptions of section entries and preferred order
> >      F: drivers/net/ all files in and below drivers/net
> >      F: drivers/net/* all files in drivers/net, but not below
> >      F: */net/* all files in "any top level directory"/net
> > -    F: fs/**/*foo*.c all *foo*.c files in any subdirectory of fs
> > +    F: fs/\**/*foo*.c all *foo*.c files in any subdirectory of fs
> >      One pattern per line.  Multiple F: lines acceptable.
> >   X: *Excluded* files and directories that are NOT maintained, same
> >      rules as F:. Files exclusions are tested before file matches.
> >
> > should I create a fix patch or we can still amend the previous in net-next?
>
> nack.
>
> this shouldn't be fixed this way.
> betterwould be to not try to format things that shouldn't be formatted.

what about escaping it here?

--- a/Documentation/sphinx/maintainers_include.py
+++ b/Documentation/sphinx/maintainers_include.py
@@ -89,7 +89,8 @@ class MaintainersInclude(Include):
             output = None
             if descriptions:
                 # Escape the escapes in preformatted text.
-                output = "| %s" % (line.replace("\\", "\\\\"))
+                output = "| %s" % (line.replace("\\", "\\\\")
+                                        .replace("**", "\\**"))
                 # Look for and record field letter to field name mappings:
                 #   R: Designated *reviewer*: FullName <address@domain>
                 m = re.search(r"\s(\S):\s", line)

Regards,
-- 
Matteo Croce

perl -e 'for($t=0;;$t++){print chr($t*($t>>8|$t>>13)&255)}' |aplay

