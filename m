Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4E3CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 14:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28CC8E0022; Sat, 16 Aug 2025 10:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8DE8E000A; Sat, 16 Aug 2025 10:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA20D8E0022; Sat, 16 Aug 2025 10:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F11D8E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 10:46:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65812160434
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:46:25 +0000 (UTC)
X-FDA: 83782896330.12.273A96F
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5BD27140002
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 14:46:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UB0aAJl7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755355583; a=rsa-sha256;
	cv=none;
	b=vO4GvNChK33dicYhwt6fGkcdWH+CqNOt6bBKHY4i81TKI26cVLLC5Q3+MGPlXS02vC0zdC
	dx7342pVFr/2ZOAnmDhu11H3JHIOW4oiQJ9my0BL5IG3kXOLAyYnsAhcShtYLe4iFGt92p
	rlrZUioaoZQqrQ+tDmFXdzHUIuYUhE0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UB0aAJl7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755355583;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gw+P/Pa0Dw/S93nPWnlSUfNlUoEoEUunc4lH2vJItmg=;
	b=SY7Wl45VMEyHJmt6GiVyEs18Rzmon3vc4/IctH38i/5WUviMhvOr0AUurCyNkRfHTfalpm
	Jv2JaU/jrHVTkJzbgmltNHsDR3ryYPc3HtIICklwSvZ6LkW+xJCo/OZdaGz7Zl2cYKIo4p
	V+u2GBAK7rY2X5vL7bzhLHl9QTz896A=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6188b7532f3so4783623a12.2
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755355582; x=1755960382; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gw+P/Pa0Dw/S93nPWnlSUfNlUoEoEUunc4lH2vJItmg=;
        b=UB0aAJl79BjBF5LIWO5XtOx1WS2/tFpBYLtBS7n53cY8qPw9eS7TGRIZs/sYT805wm
         brnuKpmWE2OTwYThYUre65PV5aS6C5LyaGQ/2Jni7N1GOAfoe3PynBWVM5dk8TXObv3z
         57oCxV13jIqGjF06sSDSpJw5VHqeJLW5iGu7vcR+1ExqsKiy33KQ23kL0597fNWCvEga
         2Pbpq/CstlUILDJFs1F8+uua+fnEsckZjVaDFgp7IJaZYDxbwhY1P8NNpfZ0wuCOsdKm
         Hz92PCE3iEL/6WQFWcIysU6iGMSLPcalzVvOyH5+u3tyLzcWgGfEzWiFAEsyjQn14G57
         eVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755355582; x=1755960382;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gw+P/Pa0Dw/S93nPWnlSUfNlUoEoEUunc4lH2vJItmg=;
        b=blZje+yZ5fzlUt6g/nsy1N+RPlMs3USIgG6ZHDekZAY/Kaf6ez4LQ7ivBWYKWu3GU1
         5r4oghev6o18qek9RIwNSMQz+35PipJjE0hUD7FpUVCRYk6bxWffAkiCB9dmHqYPdEGr
         hjkQSHtB+jw6s6BIzolE0C7LT4pn6TrjqIY5EpZch+2NfUtK63ZFA42+I1XheT5mQdrm
         kCfCBTeVltSZg4Bwdu5fadnzmQIdpfLWAXmsxX09bmvx0weuJNq4fIqd42CuhmzzsTHp
         M0FxBjjoXptd0TNsIKxaSx+IXANXV5dlohk81BY4v9XEjdYRIraj5SqXR8frT5MUH6b1
         FJIg==
X-Forwarded-Encrypted: i=1; AJvYcCVw9FoFOIRntAvO6ONiJ+PY5k0vZhVelj3D1KuHQjFoCol++XxNzGlRzB+/65GullG3AoMOik3aiw==@kvack.org
X-Gm-Message-State: AOJu0Yyco20f+vLxgomSHcrr/RNlYoRWN5Kwxhem3ent4JBkBOkli4T2
	Mi/5OICNNWUgbpPPhGqleCYv5WRgv/xlfHrMdjMIYBP+z6hRYUC1DjVLunf8dU9Z
X-Gm-Gg: ASbGnct3zAJ0BUpEaDJER0YDPtcPtP1NcmI61pb9N+90pFatRXJNLNK/yp4hKc4vPm7
	LxEHp9PBaBJAsS0xFbVzBX2mUEG1MXSsexAi+UOQsVYnLKgIL6jgmzhKnyQqWjKbubFB2j1ZeTR
	cFQMrInkQCgomkzTzoHKIRJ2U2JqZwJfC1ZUuZgS/ID7yfIALwEx7s/EtoXO8RSQM925AxyQ4PH
	pkQyHl2JNofCuZxO30hWoKQSFLRMPL9+JjjCeNyEDP0rRh0Jx/0O8F/rkrGnZRHu5uPBDZtmol3
	/l7NVly58fedAPbgbg/eHhVTx5+B+h93y7sKqR73va8Bk7xFtz4KicPkXR00DJcrH+QIHgscX3K
	3JnCMlFcIZNbfnZw3ajpCZg==
X-Google-Smtp-Source: AGHT+IEmWAGVkWxKGm+74BpjO/R8tO3rFmp421TY2+nMdu59Zv37dPIM+ndBXIrW+4ecQTGD7IRrMQ==
X-Received: by 2002:a05:6402:1d48:b0:618:2733:1a52 with SMTP id 4fb4d7f45d1cf-618b050f323mr4526625a12.8.1755355581871;
        Sat, 16 Aug 2025 07:46:21 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-618b01ae6bcsm3401904a12.37.2025.08.16.07.46.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 07:46:21 -0700 (PDT)
Date: Sat, 16 Aug 2025 14:46:21 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	donettom@linux.ibm.com, ritesh.list@gmail.com
Subject: Re: [PATCH v4 7/7] selftests/mm: skip hugepage-mremap test if
 userfaultfd unavailable
Message-ID: <20250816144621.3d4ocd44slizboxy@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
 <20250816040113.760010-8-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816040113.760010-8-aboorvad@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BD27140002
X-Stat-Signature: tgruoz4xnnbdjnx7b8bjhgjqnama9xff
X-HE-Tag: 1755355583-607971
X-HE-Meta: U2FsdGVkX1/flyo2N8DN1YonSbBU0PPWQcuIziUChDF+a2khVJYu6cECx4lPzaU5BKUNNYeTswtsWyNIBAPshCiZE17sxguLix1qcmZDl0gxWfhLiMFWh4kfBbAfqlQZDStAHef+j5H+okzNs1EpSjdOabYSt5fxiuGbPFT0oc8PEMjpZIHcDkq/dtTTBRxuEOJaZT0bmPaCWfqQPSJib9GdmS8Haqe6KWI6UFlBNJEfeoC6AAwZzL+BfaUqAGGWaSngqTIZoA7pRXbcRPcKpB389FuKEefMP206jtjmy06rzwIZ2Oku9mB1ZMVYzxtUml0mKvbrVrT1HNMhRE5ifQm2vf+JAg6zDevASV2WHLSaUtBXSHd2EJJimH460uodTJiU2hiN5n/SuhQXC6CLh2hFJwMVdYK9USEjcsJDwFHrierFYT4nrXjYfpqnC9hLg4uBm40uZG9vGQyjT6rB+v8UoyT1vhf4ezEVleL3ZMEM7/I/b/A13NmogC/I65cSoNDQveywBJepqzlyfhuRCljUbaXPPXfuTH+3PUxOBuzmHam95rqrEZuK6qGO245hEMYsrnIXHrnKmgd+qmdG9ThmjeKqI9J+i7gMT5zDbP5r3esHfcH35I+Hrq+c+3iyxBaao2175O4SrZBMpkcyquavgKrYQLxBvAEWPirR5iS5EK3PUWJwFQYCcxsm6X6kV1F+TwaNZ13RIHxpXowCHfefUpRjMrF+bYtU9voBmInE5/Y8VOsMOVhh2vuZYahHsThQmTfpmzCltVmPXhfw4fn+CEdHo3zfZno9JJDTxRuGVKpSqLOcEmCIkogzQstrdjkC/dxA9P6YO32aV5U/WVlUUc/yGqlCQeU9QWioNyhhuzQJ0K+IRuMK3eXQv1729tizNTr9LrsSz8ZK2xquf6DXL0jHpSOMwCv85nwFFID4hqjp/aUKKuNBY5zlPjbZk1GW3xweBmlnFy2u+LB
 x52HeBcf
 dUxVnWEBvUVB/iyRr5g+kxq+YNXZNhg5VfrqsX3c98mt+Uj3InoaUw5O6R/Bacye1Wl9LY+1K0+lMV+OobXLX47bp2QmRd5TZTlCyI+/+Yn1ou45YEhyFF/b2eJjeoSjyJnSpa6SFaIGpFUeuE73WRNgrFOXmlmAfKatv9tVUyLgof8fe2ZY2ITd5XIw4z65DCQbcWWPTbCIfTaADFdRC4JHhi7GakTra82waY+dB/92R/itAzokO3gNvXykfKxzfBeJCGrLbi2c4nHlbR2hBGZub3d2U4y610FjFgIzoaL4CJ2KNrMRzuwx28hN1VIlbF5gdezfCrqKBH9lpMEUViO/MhXZumZWVPRF7kf/K+InJ+16pAgTEyebN35NvwzPeTKktZc5WM0Diio2AejqMF90EI9VTHdt2nxD6MYStdHrzRz2GK4TwWeiZzzeUG9GMvHAq2fmb39Nwwau1XIjXS58t6/vTntHBQDpwy4SuwKvtRytM7XxWfzhnZEbUQwEz67MgSBw/EfYbZ65h7osH9VuhTfIPaHjF2AhOBIfZrQg4yjbV7gMO1wWSer62PCCcOtuJoyxkX+utdzJ2b6F3xfGhSKpkCuJ1QH787/EC5dyQADiyNLBQdOdf9x4B9ourLhwOprW1cMw/yqwbmkAL8TEJqzsai95YhVe/wCbNUjQiMpet+8ap4lwGqo12Jiu1feS8YyZKAmvObyczePwoXIQAGDr5OT/zGTnoXOndMAZ0iF5RTpbYlrnKjFvTwJa7cXVVOG2GIJOYNZz52I6NeXtfXUqWZdsZORUD4sTKcU+AFFw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 09:31:13AM +0530, Aboorva Devarajan wrote:
>Gracefully skip test if userfaultfd is not supported (ENOSYS) or not
>permitted (EPERM), instead of failing.  This avoids misleading failures
>with clear skip messages.
>
>--------------
>Before Patch
>--------------
>~ running ./hugepage-mremap
>...
>~ Bail out! userfaultfd: Function not implemented
>~ Planned tests != run tests (1 != 0)
>~ Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>~ [FAIL]
>not ok 4 hugepage-mremap # exit=1
>
>--------------
>After Patch
>--------------
>~ running ./hugepage-mremap
>...
>~ ok 2 # SKIP userfaultfd is not supported/not enabled.
>~ 1 skipped test(s) detected.
>~ Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
>~ [SKIP]
>ok 4 hugepage-mremap # SKIP
>
>Co-developed-by: Donet Tom <donettom@linux.ibm.com>
>Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

