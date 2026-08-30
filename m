Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 127B4C61DDE
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 00:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5436B0088; Sat, 29 Aug 2026 20:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76866B008A; Sat, 29 Aug 2026 20:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C401C6B008C; Sat, 29 Aug 2026 20:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 993F26B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:05:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10DB7801D6
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:05:52 +0000 (UTC)
X-FDA: 85155992544.25.97F4D13
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1AAF040002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:05:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rcro7aq9;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788048350;
	b=vlyk8b+Hj7YSAGCAMJizitMG8Py1tYa6mCPxz2nq94yXNxIyYq6G2JNhru6yx1t5WGRThZ
	Ms/rCJ/mTdP9ViBIbIdr3YSAV8Oi6Q28g3ikFJONMHaicfoyuGULM8/bELU39t4HKAfi7C
	mO7ZVjkkqFJC7dOORzlJo+6GdljOCeo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rcro7aq9;
	spf=pass (imf27.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788048350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OVPtev+UPa7dvRpZFUPuPS+p0V4Z4HKOiUpL+88GmnU=;
	b=eZbn7dAlsfvM6X28E1uyGNk+zTM5s3tcXy5GmwSLbSRgqg5pU9gAjuiRD+HgYMqz9v5MdG
	rUh6/bph+/lPWvsDccNhGR88b881fNvRRfEuXIBj9g11eOgeDWY/O2NESBZkbkd0rOWR3m
	hEQDuNh77OJdUDO1/XZIsjc01Gv638g=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e57a753f9so230703985a.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:05:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788048349; cv=none;
        d=google.com; s=arc-20260327;
        b=VKhCo8kw2UXFLcFua2cMXKFkUzYNTCZOzfJ5Nm5p65eHwG7B4NWx76Q4Nn/kkSsP61
         KOZIFqigUP9yaZt28x4g+GcJhsCtJgrbFwlLsNjSjum2qATQJqZHRb45MiffdkPWCDHF
         KuhOEIbAsIZMCAjWqcYP6TMvv4Oum+w+VN5nJjLw1SdiWeo6eLyD8nHo9ZyNPMYupatW
         CLZdBc6cgSBkm3GiJ44iJ6wAv/MHrL2axg82SSYsIfNXkSMDkQ4xnro1mNE9hKnx+1pJ
         6UHukqA0foQ+vZRpr2axf63+UFOGLrxuHliMw0sR+uuDiN1smIVV+6ZDcI2wVCeEagl1
         AvZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=OVPtev+UPa7dvRpZFUPuPS+p0V4Z4HKOiUpL+88GmnU=;
        fh=9Ojf+6ZeTa53u5F9OZ5SPp9AY/YaZYlPWPKjPYRF/sA=;
        b=Kcihejr3vaVBoMTmtgtITqvdpkWAN2ixnf/O2psInUjkNvIlp3zKp8diC1DnuVI561
         jq3XU1ECTp1z9K+Oafz/YZ3HvG6pLFY1U+fnQF2NgZGfKe5ES+U2SD3xZO6HlAWaj6Nc
         80qcqbgNpkUBvK32mqzW1SwWW+w81ZANxiCXNEs1i+0SL9ulyHLVGtFn2i3pE6DKqJKM
         r2zo1TpG7qPcK2dfBpykPnEI7SZY+eb+Ov5UZZTuA1XgQQBllsJWL8cyD5InlJnreKZC
         s8xFR/hi/H78OFugZqYUJxmJVV1o7z0nUcCt0CQ6O2D1WAwaIcNFzxlTieOgVFf+5kiI
         T5IA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788048349; x=1788653149; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OVPtev+UPa7dvRpZFUPuPS+p0V4Z4HKOiUpL+88GmnU=;
        b=rcro7aq9YmwWGFhzcvQj1ALFwb6gFbV+FefV3TSIGhg0Ki2Bts8UYlpdJREcVs74+n
         MEnuO0Rufr01B4Iak34nvZIcJMBU0lHFJcillmM6qBnvR1qayvu0b6/SOHcslNYzTqLL
         UC9W+wQYVnmvhRcZ/YPxeEbXIze6R1BTS0ASSGdgKPzO/aXd6QL7dEJHL2N/97jBjRIh
         EVjqfbP0X5vNg5qUkuRQKIn9/iH/HxZpB/t312O8QPodoaPXHy2X0KA4J8IHhFTbguBz
         QwTJYj/jF9j9Sb7tnsB5CcSIQL2W4QK6Vh4VJQ87pmPu1eOMHnZxO/kwxI27x+0NGwS5
         N5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788048349; x=1788653149;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OVPtev+UPa7dvRpZFUPuPS+p0V4Z4HKOiUpL+88GmnU=;
        b=Z9HL8zAuxShH3xcnQggwnyTNKmvVKMmyUgVoRHcOPMsWqVTYI11c+BJObKiEWTjnp6
         Wkr0WWmOei/PFxQlQegtZJNBG5EvTgRpL1JIHNd5ayypNsJpH/XHxWnAIUNbZ+RKSt5X
         sgDqRLun1gbVMKE3PuhIzrUfrAs/xKNzFAOiktiX/rguZLDJ+nmZ3EWY/p+p0ouU9HI1
         Z/fben58JmzFNF+HqYdijb5LCbwaWbUyjHXn3+6wIAmvqV2xW523mXqm2boKcz65pbhm
         81gj4nT9hJt27oQpfa0g8Y2EyIwVFXRTbI8++RFEbmfGqkwuzSJTQcbu2R2bO2pdSj4M
         KU1w==
X-Forwarded-Encrypted: i=1; AHgh+RqxGlbmfaCJe2ER17j6+8XfHputFvul5iyyOUVFf5tboL2QjzE47SUT3wEZYS77e2ojLhqzKHMIXw==@kvack.org
X-Gm-Message-State: AFuF++k9DlMqTXDyLzrKSuxwLTyLjNrL4OojEIIzk3MKYuubTq5iSrvK
	ybZ1Digs2IujDB51dRmtirVwiPl4Z2sJNTSTy8kAB85X6GP+TgRJ5ErsJ6UAxsvd2K04K53eX1t
	+kWYPkDirhXiyuJ+nOSNuvVJrpgLBmQTu6pGXDZzK
X-Gm-Gg: AR+sD11A/KUbMy+WcUqr8VzmfF+/0OqcLiGy3Oli0wFdvi73Be66hDeJWNDhmLiCEU4
	+7XxLUEAE1cdOH6Y5Ze4pKZ8pdqtKVJoOftVsjIoRYJfD9nP9qcQB9Vdgae2fQGTX8XP3ZiQZ5h
	qGLsnXEZ3l1IgoanjDRpBYVSIKXqpYnj/fpZ0ozA46uZVL15L7oPx3KT6OKsdlzHd5tNDHcEzOP
	oknBaI9IuuUxxu3VP7iSkySxz+Jk0USHOCqOBjl93nRKBf411tI7SC21REj9n8y8EiXR+/qChky
	dbnTaYBcbBm2pXJCAETaRnNPtm7m8pQ+H9XUfiNebdWUn66OpmjL7bmlBdUpJcPCzUj1lDjTyK2
	Y5VyixMWAafwZ+w==
X-Received: by 2002:a05:620a:2b8f:b0:930:f35d:41ba with SMTP id
 af79cd13be357-939139565fbmr2030756285a.36.1788048348431; Sat, 29 Aug 2026
 17:05:48 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 29 Aug 2026 17:05:47 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 29 Aug 2026 17:05:47 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgHAwAJee6_ra9-zioDh_BqHM9Lbu+TGXxWHbG7za=g5Aw@mail.gmail.com>
References: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
 <20260823-memory-failure-mf-delayed-fix-v5-5-d97a5703e45a@google.com>
 <8a99f753-0713-4194-8eb5-90da0724e647@kernel.org> <ao8pCI3AaUssIO8S@google.com>
 <CAEvNRgHAwAJee6_ra9-zioDh_BqHM9Lbu+TGXxWHbG7za=g5Aw@mail.gmail.com>
MIME-Version: 1.0
Date: Sat, 29 Aug 2026 17:05:47 -0700
X-Gm-Features: AcwNN1UOqbFFjDrkvuROHBeY-FoM3Gy-1FuQx69V_3hC_6MdAax2NDuhHQBC0j4
Message-ID: <CAEvNRgECQqS8xXu61btmESZj_eWWjuEt-Yq0vRFrxCObvfnJVQ@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] mm: selftests: Add shmem into memory failure test
To: Lisa Wang <wyihan@google.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, 
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, rientjes@google.com, seanjc@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1AAF040002
X-Stat-Signature: mu1yo1xbmqrfeye4ao65s8usqkod9huq
X-HE-Tag: 1788048349-163025
X-HE-Meta: U2FsdGVkX1+gV1Jj1gg4oM8CvK4KwL3fYFF7eLGgYx1ZO5p6KjcAEw6wJosRJV8KtDre95nR12pvPpTR0fkZad3YPmAyKf8uepce1ss/r+oBj7iFPWViwTk+Wk9hdEPG6SrGyiczu1t1O3aiYrjl1+m5TESw7iuhL7Z0cJi0YFGiaajOWZiv3ZTiO9+zfAb8rgwEe1p9KGVmygnNDrYS4NDUb67XNmrLD6+1QWGkL1ev6XhJvdeunn4FljjZEeWYTd6IkLwxPwBh6BWrzeLt1QJonQ5qUGKEtBVKw6RLydMQvLAwc572u3eSdoy3fUopq9MHBl1vJxXaJhW0cFTiQCE1zNMW3S6d4NnVkat454uOtpyINoXHCynGwYQ2AY5cQ1EnLYZStz4zTuItqJybRBYqaI0C7UxML3zQ/XSjvSqgp+ENLkgv2i2PaZ2u1m4RS+ngTcLWorsVBYXM1KieJua5zs/qqZR/H+p3hiJnzlC/7WK0lb6i49bfO56I94fSsfX3Lapmz8c++dbFtRoQMEz8i4kaz9Vo7vEFB0xSXOoZc4DesCGxtTW4L94Dskd+pF9gfH7WKe/nWuQMj3FjyC1FI4tsWODbZWnyKIbtLMJzTXIaXYe9qG0kBOQEr9kgvmNu+28WkLKhEJiEMGTqNj2v1N255tCtGDLsevkC+cEHwmywpqtj+wsirhv3DH1uKwwek4rSSa8yE7b6uIkZiSsWpjfOjqr3Cv3fDbKVcvNiDjjd9QI2F2TSiF3LBaQZ86Y/Yb2y7cVtHgBxJEJXcNIZ0qGPZA3qeSSsojjWTYRzwtS/MfFWcCPkjfCApur/Dwdi1PsIm3I5e3iGyAvU2ULZ210cFaV1yI2O8rIpfi5yR3j6g80ChNTZcXA9bHTehFbsrZ29az7Sm4zCLSVbpxxwf9Z/EwfnQkAcrlLMRfoetihFIB1SqrbTPSr28ZtzwtogPuTP9AYBIIUeEQ6
 OFJKdn+J
 i0+CsB6Olx53Vc1TL2kvcQ8LHzzApi2BD0ypApMOHOrDYOZoAyPeGvpLXJN04p5AVQTCo+Gdspg5Gk9Ihe2faFrKd0YOIaKYXM0OxT9igOrezESPUSXSZ8GrkDHsQQGzfnDUlwpDnGXm1MM0ZXRm0kixZvtiyQ0jDhbT9tZIhX9wtiErRfCBkLzMJp4D/gVpzwsIS1HyKIB5ToU0Hymcatp7P1Vq3/fywgmeBphdwF08o5ySoijXf6sJJYZBjMeF76BNuPuhNqbOzm3UWA4ep9Dmaq3GNIbGqKZ2aTQGNGCYYCHUpe7xxjs3KTXee037dY6In666fkHdWxTYtG9SIhUAWW0SGBnKViUgkFB1QDep88UfD8yBusjbd9h52x3YiFX4kIGBL0LGt2SecnEAPEfu4Aq1tnj/0JdLnsqen5BbbUZCdZEeeLz2yNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Lisa Wang <wyihan@google.com> writes:
>
>> On Mon, Aug 24, 2026 at 03:00:47PM +0200, David Hildenbrand (Arm) wrote:
>>> > +++ b/tools/testing/selftests/mm/memory-failure.c
>>> > @@ -20,6 +20,10 @@
>>> >
>>> >  #include "vm_util.h"
>>> >
>>> > +#ifndef fallthrough
>>> > +# define fallthrough __attribute__((__fallthrough__))
>>> > +#endif
>>>
>>> This doesn't belong into this test.
>>>
>>> rseq/rseq.c selftest already uses it.
>>>
>>> I think tools/testing/include/ already provides it.
>>>
>>> Maybe
>>>
>>> 	#include <linux/compiler.h>
>>>
>>> does the trick?
>>
>> Hi David,
>> Thank you for replying.
>> Would it be better to change it to /* FALLTHROUGH */
>> like the rest of the mm selftests?
>>
>> If we prefer to include <linux/compiler.h>, we can
>> certainly do that, but we would also need to update
>> the Makefile and fix a redefinition in pkey-helpers.h.
>>
>> --- a/tools/testing/selftests/mm/Makefile
>> +++ b/tools/testing/selftests/mm/Makefile
>> @@ -37,7 +37,7 @@ endif
>>  # LDLIBS.
>>  MAKEFLAGS += --no-builtin-rules
>>
>> -CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
>> +CFLAGS = -Wall -O2 -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES) $(TOOLS_INCLUDES) -I$(top_srcdir)/tools/include
>>  CFLAGS += -Wunreachable-code
>>  LDLIBS = -lrt -lpthread -lm
>>
>> --- a/tools/testing/selftests/mm/pkey-helpers.h
>> +++ b/tools/testing/selftests/mm/pkey-helpers.h
>> @@ -22,7 +22,7 @@
>>  typedef __u8   u8;
>>  typedef __u16  u16;
>>  typedef __u32  u32;
>> -typedef __u64  u64;
>> +// typedef __u64       u64;
>
> Removing this u64 typedef seems to be unrelated, the layers of includes
> probably has some weirdness that needs to be ironed out.
>
> If the weirdness is not too complex to iron out to be in time for 7.4, I
> think we can iron that out, if not perhaps using /* FALLTHROUGH */ is
> fine, to be aligned with the other mm selftests.
>

Lisa did some more investigation, and we discussed too. Here's my
understanding:

TOOLS_INCLUDES in the Makefile points to tools/include/uapi, which provides
underscored types like __u64 to avoid polluting userspace symbol names. That
makes sense since tools/include/uapi is generally copied from usr/include/
that is generated at build time, and usr/include/ is used by userspace
programs in general.

selftests are a special case of userspace programs, and since we want selftests
to look similar to the kernel, we want to use u64 instead of __u64. While
the kernel uses include/linux/types.h, the tools subsystem provides its own
userspace compatibility header at tools/include/linux/types.h defining u64.

Hence:

1. tools/include/uapi/linux/types.h provides __u64.
2. tools/include/linux/types.h provides u64.

Adding -I$(top_srcdir)/tools/include switches from 1 to 2, causing
definition conflicts in the mm selftests and more warnings.


Since adding the tools/include path to use
tools/include/linux/compiler.h breaks existing definitions, my vote is
to use the comment-style fallthrough like the other mm selftests and
clean up in a separate patch series.

>>
>>
>> Lisa

