Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2AE6C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 02:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806856B008C; Thu, 20 Aug 2026 22:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7736B0092; Thu, 20 Aug 2026 22:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6166B009D; Thu, 20 Aug 2026 22:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34DEB6B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:05:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B05E140120
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:05:22 +0000 (UTC)
X-FDA: 85123634484.06.EF268BE
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 016E11C0006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:05:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=YaX61jyC;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787277920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilqWqTcp2QIIegN8Wykudvyua68HMB1s5p79u7p9ot0=;
	b=JHHm5n/VF9/MFDPlP6Po3K6ORhqr+K15lTlYBVYTpTvjXlk0wxBdUvi0HkJPq3ogYXZrr5
	8C082gDcSP5d5WdFgREnh1PItCRYiR5RN/YpUFNj+RM7GLuLWEMK1/9ZMI6DnpKY26Mku9
	R9N58EACaVKDqOjr9LlbR5ZNIPNDoR8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=YaX61jyC;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787277920;
	b=jEsGJOVJmQJsQMPK5D+SdkMC/wjfF7FxNeY+xwC7XcIo4ypbuT/lGfyaro2UgPUHbfQAK0
	kFOfdroJ57c7sfuMFWhnvzPrZkNGmf/TPl6qjW4wRSypH7RVe2Vot7dsUqV8HTURnPU7LD
	DF6Eyrgr7pls3Q7lwncfQY/mzvKv3So=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a374bea882so1154306a12.1
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1787277918; x=1787882718; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ilqWqTcp2QIIegN8Wykudvyua68HMB1s5p79u7p9ot0=;
        b=YaX61jyConlhqSo+wxt7sxYsT1UmBxyzO41t+kiU7CUYEFKujZdT7rvvaAHXUfXbPM
         zsxRdsDExo96S/rB0XH0nvujh3/541ZkiKaNMwzCY1OlfCFZgFMcCOqN17xgxSkXc6aA
         MXnm2+gX63hsRJxkOccHBSZnm2eeCwpc1AOk0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787277918; x=1787882718;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ilqWqTcp2QIIegN8Wykudvyua68HMB1s5p79u7p9ot0=;
        b=V3WRQlTtZVYrmXb3Ek5zOgb/x0TDvYLqmOGBV3FZTLT4izRz88Vjag/OXPBMlfk0PZ
         C/hJPGXHTXKdMFydME83u9RfZ685gMGanVARwjP3DybDA8QQnLcix/j4IPDPxw9KJfxR
         AkV5Xnn+9QqEgAp6W18RVwOK+TkNTIeMcDgxyDkjUkMwM5e5p1xhMA2nfiAmbBUy4a7P
         UPqQ/GiwfGSyuDz5h/an6MYV0EJY+v0Q62pEReiuXugLQ9rXt6Er+eY6M1+VoS4217aV
         Ttv5kwKDCTtrfUNAtlNMMN3O9/7Irg5k4eT4V+f8xjhq8sOw5D1KzIVV6NNsoXoooW1m
         YVyw==
X-Gm-Message-State: AOJu0YzRSfhIpqxi+E1ka897S1H3GpVkTHXE501P9Sgcas3p9lxiMn4O
	Mrcxi+77wRKeT8FcCs1q3NS0Jg+dIAdttfoKhFddeMJgcgYooz3VCeLL9WuqRYtcDy+nJb6hbbK
	ONphxJY47gA==
X-Gm-Gg: AR+sD1250cHSNu5HKj+EW1cMXHhBHdTRvcuv0g1p3vhabWhxTubz41A5EVA2+HhuX8/
	xCeAqKhfTKA2N0SGalsuPW6vX+fr89EB9931ea967Tu5+HnIVKBfLBzKqtl+ovW8eFNiJ59QTTE
	IGwIEsyI5t3PDEkMHNrpOiY4V2RTQQSKm1XOQ31cHc4m3XswX6te8WvRtau7UiODs2Z43CxfIUQ
	hSd4MRr75zTJjENDy9FOgPAMIjBD5ACOKpltEsgs+259m9+meXP9ohvkqkabVrcOojK5zvdLAu3
	lgj8P/e50klAvzIRa20B4zjRRKnpj5RWV/oyaRGWy4Tj7RDLRDJKhQa52loi40bQxgYGZQKd5/t
	y2b0CU7wFqN/T2EcoHqq2OP4RrzkCPT+8u3jISQPJXJ8Cb/MNtlVNM+J6GdAwXdCwXLM/l45rfD
	Lb0qj8Z7VhdpdUiBkuS9unu1lnoKLjasELCE7L7C05Hi7dajNaBlKYsL7C9TmAxAhpzt2Zi6mpY
	rlH65aVfIc7eKTkHYIFsUu84Y1TUVhYrajJ3A==
X-Received: by 2002:a17:907:9346:b0:c1a:5d49:f99d with SMTP id a640c23a62f3a-c246a3ab4c2mr312520766b.7.1787277918264;
        Thu, 20 Aug 2026 19:05:18 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c245940c46bsm251522966b.59.2026.08.20.19.05.17
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 19:05:17 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a10d02ff43so1169380a12.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:05:17 -0700 (PDT)
X-Received: by 2002:a05:6402:24c4:b0:698:ecf:d18a with SMTP id
 4fb4d7f45d1cf-6a42f1be3d5mr2627931a12.9.1787277917155; Thu, 20 Aug 2026
 19:05:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260818220711.d5d577cb135b213ae11549c9@linux-foundation.org>
In-Reply-To: <20260818220711.d5d577cb135b213ae11549c9@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Aug 2026 19:04:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wipdFaYVXO6egyacqXiTfUEQWjqsOSjxjbhZ0FK_MjRTA@mail.gmail.com>
X-Gm-Features: AcwNN1Vv4YswxSOrIw8YhWVa3VKcmfREmzL5hnmqA7uUN5u66DG9Dsgsk0KbPg4
Message-ID: <CAHk-=wipdFaYVXO6egyacqXiTfUEQWjqsOSjxjbhZ0FK_MjRTA@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 7.3-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gwggj144zkckgpsd89kxnm434umey5qi
X-Rspamd-Queue-Id: 016E11C0006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787277919-482214
X-HE-Meta: U2FsdGVkX18t7MbjxUHeQMUtw3eBiSFliwJC8lhcJKxHxkuEhNRqbcUQIH9Bfj6YtuchDNFD8r28+D58hNbM6TR8adJoTtefiLLWcIFCP/k1pxmNCSwgMltGm/WTrc5jpkg5MxSHhu1DPpkVULEplUOP0ET5QK0idhncfGczokSYSEpIGRC6wzf/1R4ugPh5ALxhnQRpyJrA2e55n1Mgt7zry05fdTG7i9q1h9z1TzAJOhNOj0RDCqdHzqqebeHfFkvISvbsoMVEFqjtHFz/Y5oFZq/WIO9q+MRk2qw4gG2vp1ht5lBaKMMDO8X9JiLnfKXy9MXxjvdwltlNIaluEbZ8Nyx5VN1x9QfAITRRK8rOf/uUw9oOctMwP4KsU2XK9oNafsyfcTRxpbAzwvAkw81/KRxYF2389eWjH24/WzjY7uaHixs88I5f3n/fcFYZATy+9pxC/wX0RsUhoXUjdv+sfdzl+JSY6c+Lw67wisPFz3a5g5oL0cmseeaLu/lxQftnBNensySg5XJlz8hYMF+XHRDG4o5DNY9TOrLpEV+WBYuvHDSO2BxeprIGwc7p+I5WDMuB2TKwwwrLhPlV3b9Gx3yQcMWcA5JFdRB4tOA13wQUAI45JUU+r+ZRGQK99CcQrC6vX8Y9b6PrwnUNnL9oXcJTxMYRP1n+Jhi3H+y+WGAFI4s1meB2y2iSFAGsZBElT/doUfgHVA7k5ZkkN27uRP1DGwnzfwrCgnfegoHkFWXfIK4LmrrSDGxnrCXFw+tjtsK1IAoOpyOLrWou0Hr+9QoxvNhym9p3lOGYTstIZ8osmbxLknAC7DAVoNXoHaskV4sUxDDqPLizHg+bjq9x8l3lCo6KPOTN1Z5q2YmGRtZnQq752T1icJcgZlcoWccDDlSgQNgTlgM1YwiaijQ/3IEEe1sapysIdqplvPIkOxof5Ewsg75+PpUbT88yD6Laiht7vKZsPqPj3rn
 itf5cgfy
 UIX3OvuuwNQb6oHTYkC8o2LKBfBxKVjaeLlb/eE4tWfJw43AvDteSn8ZAaW0v5rN7nk1jj1/guu9RFqOQNIwgUl8DoAqOoWbIxWGzhp5E+8rwUHt0GBY8lIJNIwocmZbqYd/WskqQTChfHkENAKLVKjnjGuBPDuSfsJgmL9GfYfMvXOJ4Brgq43IBm58fR6rU8IzXeXgT2mM+CDosXUWPUDELHS//8pfVpPyiV/8oOVvze/dAc5zhwOkOJky5rHKFrlQdo1zIu1f44a5O2ZV67xGcRniwYGXZaMG96XeVxV0f/nd0FGq1h2sDSpEx9oR8Jf5FlNiV2+tWOMW0tzx6hPFGuuLxXwA1128UNXXuPMvjmWiE+vcIRDaj4zbN9Zbz9DTvwNBbqhWzTFQeXWh/eJwVinpJZaJbrfvIULBbTlNFqEPk+kcSVTXH8RnmDgbxvD+PUMEgs16GR0upJz8kAo14Y8NcV+q11bBlpkMnVIMFNqX8ZGufly5/Rs5JPEYdcvVA8yBECgqvZi3tPyYrvcUHhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 at 22:07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> I don't enjoy typing up those patch series summaries, so I haven't been
> doing them well.  This time I recruited Gemini to draft many of the
> bullets and then I did a review/edit pass.  I think the result is
> better(?).

So I fixed up some stuff. I suspect you did the same thing last merge
window too, it had a similar feel to it.

And I detest the silly use of present tense prose for bug fixes etc
("Do ABC, fixing X").

Or the unnecessary use of filler words.

Or saying "This 5 patch series".

Things like that should not matter in a merge message.

You say what changed or what was fixed, not "Five patches to doing ABC
fixing XYZ".

If somebody cares about there being five patches, they'd be looking
at the patches themselves. The merge message should be about
higher-level concepts.

(Or - and if people really care about the delineation of patch series
- maybe it should be visible in the *history* with explicit
no-fastforward merges around the individual series)

I didn't do a *lot* of editing, but let's take a entirely random example:

 - The 2 patch series "selftests/damon: fix memcg_path staging handling"
   from Cheng Nie fixes a bug in _damon_sysfs.py for damos_filter
   memcg_path setup, and adds a test case for it in sysfs.py.

and I edited it to state the basics without present tense:

 - "selftests/damon: fix memcg_path staging handling" (Cheng Nie)

   Fix a bug in _damon_sysfs.py for damos_filter memcg_path setup, and
   add a test case for it in sysfs.py.

iow, straight and to the point. Not "Patch X optimizes abc", just "Optimize abc"

But I guess it's a matter of taste. But if you use Gemini, you could
try to tell it to not use filler words, and use imperative mood. Don't
say "So-and-so did X, fixing Y", just state what was done.

             Linus

