Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE207EA3C21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B52E6B0092; Thu,  9 Apr 2026 06:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365D46B0093; Thu,  9 Apr 2026 06:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3A16B0095; Thu,  9 Apr 2026 06:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1786E6B0092
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:13:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8F7C59393
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:13:37 +0000 (UTC)
X-FDA: 84638605674.17.ABED4DC
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id AE90740003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:13:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Civ11WzR;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of technoboy85@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=technoboy85@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775729615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5G1tgPSgfqXAdaiT/Kh+YtWkW5LgqZYK/6TgiRqZBJM=;
	b=c0B1bt3ZgzXv9KEj0XfoT1KuPkyaI11AJyqX2MmNUvNHcHTvAtUSX+GV8AgdQvcSuzA8TX
	xtvGOpzMYKCqAq8VxNDEo452g20NLCtZgDkwIdU4S9JQIlczoANbdULsPZt1ZyLGd+H7EE
	FGiwp7RsxhdXba5FpOojzQXgG/Mj+ew=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775729615; a=rsa-sha256;
	cv=pass;
	b=GMZMzxopi4inGhkUzRFTMTo1SjUnxoYC5Om4AcUxpEEcoab1/MpskAM97ZE6zwmgbw3zFA
	0KJWT6DBAd5psVJdgprt4BI08E3QTAemtJvdWwDUba12Fmy1GanoYK3EI3M3yBXCap94ox
	2d/9G6FA5w/+hrK4c33eSe+1E2xBpYU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Civ11WzR;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of technoboy85@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=technoboy85@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b9c11eba219so74048866b.2
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 03:13:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775729614; cv=none;
        d=google.com; s=arc-20240605;
        b=O1uZev+BO8pjCplLj00mPQIgqhp6B1fwcoknVxFNyCAyt0BHu9vqFac09lu9q9aG7J
         +5HyTsEqZLj1stWnY9zL3/KYcLdA7iIXeZjgnWJE0ViEaeVKLyfXnoBFELnFMibnfe7C
         VIg8OzFVx++FDJcl0PsKYTOVKwNZAJrqqEjhN9h24kQufQ8OGdwTE9AEidOuDB/QVGlv
         g+kesMwFnn2GgH4vJaonkjvzhK69s2ScFG6t0E4nIbee4sQvexWDvqJr58+sjmx/ER/H
         n1cE7b2G30RXOCcA7gLg3grCXjC2UlYywkYrpyDVjpTr8DqbEE0dxh2/2dP7yRj8TQ0Y
         77zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5G1tgPSgfqXAdaiT/Kh+YtWkW5LgqZYK/6TgiRqZBJM=;
        fh=8GpqOR888E9HiVG0ckTOeUs/oMNWDHPb2L8e/W2CqfE=;
        b=AOZB3VRlQMrUBJorAA+2fFeJGJG/6xeq59h7zU2VvNTKtAr+mrRqLRTAFPtCMpIqGy
         /rLl5vgg/ARBO1kuvKdeMRTFbTIwSPfWBLCdhZM/c1+85pPq0pMtqWcNaOhOU7TZA04L
         6RD6vpGZ6l3Y8qFlI3uwbOkmeC2JneDY5etp8MLWBG7S2Q+b2bLoaHEtVDHiIVxliX1u
         0/B+NMxsMBMFPmff1RcOIkf2g+Ayw687+JrnOYtkfA+/uGRC2Fdo76JVwYqCsFkBYZdn
         5oAb1OyN7yb9cFmStO543Bw45z4hlMQ8UhF+kCVlim4vpRM1JNlXSuAazsi3njyvD2V2
         28rA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775729614; x=1776334414; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5G1tgPSgfqXAdaiT/Kh+YtWkW5LgqZYK/6TgiRqZBJM=;
        b=Civ11WzRXU5poHzCAknffuVLYxPlkYx+NjHUqjWJNMtHG6sT+AtiFDtaWqcooo0eDT
         E60gM9AUnakhMX6JPL4DEOGMQZpNghiwZ/2DcW//fpkViVCa1vctHrbl1bQbhDtZsY34
         +uqltFrTZAPHhdsdzxTqc09S9FQWHtuyjkFA2w2toB/hYsgzPLnV/4u5uolZ6yqz5noI
         uT27DzpGCT6m8jGoWmN1iI39JbPcj3cgRp7f2NMoOcCni/X2VHgW2o6l1pWzHSXVIrJ5
         7OR+Ap70lk6tGIfsiqx/qiUCjU4qxl6euKe0W2TpeVlqgmMXZ/EmqWrPzEo+05xhEZPX
         505w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775729614; x=1776334414;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5G1tgPSgfqXAdaiT/Kh+YtWkW5LgqZYK/6TgiRqZBJM=;
        b=ioeBvubRXQppKtWCR2CBTM/iJG0oquZwpX+2koFC4uo4CJTD3u3rqEpKaCgyhw+DYc
         6t84tPidsRHGGG/6du1sgrO0pMkxFzM5QuJE6aWZYxBXvqlmlBTiyGCj2dRpeorvhk5Z
         LPPKypn3Z+i/vwMAPvyJLQQ1n9YONrBGWRJMB2LG8YG2NPlYjJ4G/K/156pz9vpGu7af
         QAGy/WzsdFSimdpwYSe+oA9OoNZeUgapwcfP6VfRRI0NcPsN9l8Nb3e8ENR8Thod70lr
         LKIvutcqnQ2t158ko072aUIvIGrBOHBYc5F3m0DlzCWFFcrczAIDAttzuZ4TH9VWbj1C
         CYiA==
X-Forwarded-Encrypted: i=1; AJvYcCXIdDH1hS81atmeJD56V8aMMFGI1mfyYD2b6v3H48cfCfuppMpLibr+tolAW9kalgXeALS0MQUnDA==@kvack.org
X-Gm-Message-State: AOJu0YxE1MfJy/qm/NxWosfu6L2F+TSi8oab5s4F8sfIVofWTV4u/C/1
	BUBqLd2JgLxa43mN6WxSsNEPYnCsVdxNQO6FN03sBRD2YO34VpD/7/73Hpr65swQvr8DfGr0v5z
	M17n82XmdObv1XjOlBrm2rlSiHl7IkXM=
X-Gm-Gg: AeBDievhpAIhzGWN+S4OxJL7TJoQ98/lZi3P2k9vLeBZhbfZypmkccvklWTNlMCBnh/
	qDNtPRBOFKghS8V5lJJPGpqIDwfz++FOmO6uIPIC2+GOgzNjNzV3k0cMlJhkO4i7l8gv2/Ijpej
	9lW1rOyolPFqTA5X0ZWtJfemTMWdtnaH5FY4fBRlTg4DZlJ85MaJLUELCSXhBF8a70WZygUKcXz
	mHbNt1jmx8rJ/H4fymHHd+Ywxo0OkcmIRfxSzbW7Fn5T3MA6/hGKcZOhyQQZXOZgiMRuFpnJPJo
	s8HeWFSXHG/H3mXt7g==
X-Received: by 2002:a17:907:9605:b0:b9d:3966:bc23 with SMTP id
 a640c23a62f3a-b9d4768d513mr142385766b.26.1775729613743; Thu, 09 Apr 2026
 03:13:33 -0700 (PDT)
MIME-Version: 1.0
References: <202604090741.1kUVXMoc-lkp@intel.com>
In-Reply-To: <202604090741.1kUVXMoc-lkp@intel.com>
From: Matteo Croce <technoboy85@gmail.com>
Date: Thu, 9 Apr 2026 12:12:57 +0200
X-Gm-Features: AQROBzAZyly3rkZi_uaCRUbRSjWTfZY1vAkt2NvdbZUe0X0EKu3VrrmPc-isLc0
Message-ID: <CAFnufp29D4VdTgoJ4uDk-dQ4-RuO_C6=TQ7O9TA5M=JSe1j+cw@mail.gmail.com>
Subject: Re: [linux-next:master 8662/12838] htmldocs: MAINTAINERS:40: WARNING:
 Inline strong start-string without end-string. [docutils]
To: kernel test robot <lkp@intel.com>, Joe Perches <joe@perches.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: inic6p5wjo9sp4qx7f6j6nmqyhhbmtig
X-Rspamd-Queue-Id: AE90740003
X-Rspam-User: 
X-HE-Tag: 1775729615-239788
X-HE-Meta: U2FsdGVkX18PBG0ocdtF0vnUHDClrdtJ/s3ToW/zBxAN6m7P4iIaEy7q7LGECj4IeHs66m+ulVYzqc1Im2SdmM9fXTwjB3jq2G8iYl9fWrvKOteixb6ykTsnbOtt/KZmCbiLNP1k00iE+JTxsPh1fydQdUtxcjbX/cvsVKJNEDBA7mwPAJQY8+maZMH5jVztkNSOhPLMw8Mo8HKpR4AJB9A+7pcM09jyfhLmN+6FmOnhvLng/bfJu+4jU7PSl46kZLbY2D9JMyqoYK87NYXjoGV7oMMX41tisVge7k8gHCdfvqZqE5/BO0GGQL8D1R6KZ1a1itdsjvD806hmmm3GqAKs0NHx1dwD7R8feBmBMeUV5KRDv4h2pN6VMkYoaC5/Fkv4Hz3EjNI31+cy2YyemYqpndQwLjAYF2YVCGH0Hzd/88r3V4NgdStH45wupDe1r3tu/I+HwV12rBjAK7/AxEGNkXoQfL5fqTzGUNTfbgEDFVNwWLIGqJmrY935zvXCRHmtKcIKCWFG8upEnuHROw0LByOKuT/hbgED4eSe2hM9OqRt2K+GOvnqouFcHdIiS1V45h42Oaan/z2h6aR9rx0INt5+rZwnr1n9eJh6W1gikHEhTo6YrGGcG7j1h+PRkGN3sFNQCTOnoxfT7+zBAthBjyeNWYJuBpvGU0Q/j+AnpWgsSI+nZJYGeli/ekLwVmFri7Z7T2zMd7AnEBDckFkLPEp506i5aqMIhRsWlpg/43KOBy7wMI4u0VecaGEhpJ0O0SCdKIoOLFRlwHaJeaFXm+rNfUlfP/vtxrQWZD42yE/lR7eKUAtrkL3fb3ls444Njk4gOvbLrd1n99GcoHWRTqt/J9reO2y9lPgug4REiz0igfyxEL5iQjHoTzhgNSnLwQQ7W2V7wfO0brQrXLXP2rM56dpB6zXiv6VP72bIdH1Qggg80Xet7JYbqkVz0XJ/b+Tw5/Lh7YEhXps
 YG6ntDo/
 c9loEr/l8FYlSvZW1b+yjv5pAlZiHgig0oarw559gYyEr5h2Imh29GI7rTDUq1CcEKPKu1/ovaH66WnzoS+CG/g8Abg0SWf6EtUw4u63jQNufZ4GtvGuGccaLJ6/EclB2Ou5fOh5SF/jCW+dusYvo861/To2TGrWChvKfmKbtUUKrO+Kf/2uhKymqouXyIYFcSPSXu5BKwye+PsT+iVA4ElPfYlYnpRn9GY2dXnCzl5gjUV2fYPP0Kfs6z9MzdrS9+zRHUDkfgmpYFkhrbIT3JSdcqEOtibJau7iwUc9amVdJbwWlsqCrhRERYISXUZaSoNmitjGH05IPpNR8E2X24GD6aiJHv9sCkolzmKsKwfyx8R77fOqBniD1UL5GYIzXYSmfvaXRvZSmNVVLO3udi/DNz9N7nfyQe9+H43XZNfP8by5dnu/MFEyZLWTstt34o45jGygj9bvmK6/wdeE6BXBIGITeuLH3i/SXRj2Sr3ymmPOKwPET4VbXxRe8RXSYZuxVKGcxqHtnleU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Il giorno gio 9 apr 2026 alle ore 07:24 kernel test robot
<lkp@intel.com> ha scritto:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   db7efce4ae23ad5e42f5f55428f529ff62b86fab
> commit: 420849332f9f9f1ce6ff142868ae2e6ae9f98f65 [8662/12838] get_maintainer: add ** glob pattern support
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> docutils: docutils (Docutils 0.21.2, Python 3.13.5, on linux)
> reproduce: (https://download.01.org/0day-ci/archive/20260409/202604090741.1kUVXMoc-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202604090741.1kUVXMoc-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    Checksumming on output with GSO
>    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ [docutils]
> >> MAINTAINERS:40: WARNING: Inline strong start-string without end-string. [docutils]
>    Documentation/userspace-api/landlock:480: ./security/landlock/errata/abi-4.h:5: ERROR: Unexpected section title.
>
>

The problem is that "**" is seen as start of a bold text in RST.
Escaping the first * fixes error and keeps the glob unaffected:

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -35,7 +35,7 @@ Descriptions of section entries and preferred order
     F: drivers/net/ all files in and below drivers/net
     F: drivers/net/* all files in drivers/net, but not below
     F: */net/* all files in "any top level directory"/net
-    F: fs/**/*foo*.c all *foo*.c files in any subdirectory of fs
+    F: fs/\**/*foo*.c all *foo*.c files in any subdirectory of fs
     One pattern per line.  Multiple F: lines acceptable.
  X: *Excluded* files and directories that are NOT maintained, same
     rules as F:. Files exclusions are tested before file matches.

should I create a fix patch or we can still amend the previous in net-next?

Regards,
-- 
Matteo Croce

perl -e 'for($t=0;;$t++){print chr($t*($t>>8|$t>>13)&255)}' |aplay

