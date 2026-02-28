Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05FE0FEE4F2
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 17:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 283076B0005; Sat, 28 Feb 2026 12:55:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230896B0088; Sat, 28 Feb 2026 12:55:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13CC16B0089; Sat, 28 Feb 2026 12:55:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F42226B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 12:55:57 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABDAC1B6E94
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:55:57 +0000 (UTC)
X-FDA: 84494618754.07.54852FD
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B276120007
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:55:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jkec9Pte;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772301356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=fDA6fINhoG19nlLDNAxKdZSYU9C7hnrjgxA7avQ35o0=;
	b=fE9v8uLLZ+0R9BV50KKQOe5CvMvDL54hMA+H/KHfqH2PBpXA4ThawbQ82qK53dxGakPKpt
	WuKrNO7Gmi11GY5eznXYLu13c6qt1segvRe+0AaiVjMXbImgdklNQ1+qwME2V7Iafnx2hH
	aAUgafnrI1Y6L5TycRhQy13qqB6+v1A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772301356; a=rsa-sha256;
	cv=none;
	b=8ahOWN58Cn4wsDmKzmb8pMAxrqhc0uxfCm4eLoVJdCvLteXll4CK7Sa1X/spXahPs8+2Ra
	ZIUvoa9xCD/VuyTwMVEka3glt9JVHHKd0F1V4ImwOjnRA0SYqIQrzdxvlZWuUvX7fJFeCB
	agGceojq/IcD4WjfjgT650XuEZJbEo0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jkec9Pte;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82735a41920so1226438b3a.2
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772301354; x=1772906154; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fDA6fINhoG19nlLDNAxKdZSYU9C7hnrjgxA7avQ35o0=;
        b=jkec9PtewUzKrRJ/6RZVbyZhH03mOie/8wOY7T6sJtbJZiKN90Z8KMPPPDix9EgfBD
         e/RmRoSiRGGd2rUQdZIKC89/G0oE45QZF0AGI4kcZJseEJXjfy8QQ+BsLqWzvoTBaAsh
         2NfOX204fvQC+2AJrXNVMzLWU+0k7qStWqXCXEGmuSrCGeEta4dtwt3iW5MemLi6bQ5X
         28qfRZ7w0ItOOKjqt1BIG1cK8Pwxi2vKvcxllu9zDU6ka2u/1OJGCYZWIJJI4DNsAyOQ
         d0/XhvZakTEVTk+Ja+icxM3gL3KsF7wO5dlORHhaY4aBFV7XxVxNhu4s3shU0T6119wN
         qVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772301354; x=1772906154;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fDA6fINhoG19nlLDNAxKdZSYU9C7hnrjgxA7avQ35o0=;
        b=ivh7EVtuTnvf9wDv825eZO2YUxwNYxCRDeBkm6X1ceY5eMYbFQwdD3yXOV7y6CTXrN
         ogYXEjTj+zMpS8RPewYgKhi4Or93gNy4jot9NDSPFyvhdrShWmhcYE9KHFTNOGGRYKNU
         ua2dDaYsM3SrN06BAKsxB2NdmwwlGeo190upAWEZZ+0dCHEeD9mo+VrHWZBfpgNrRV+p
         10N9dg4MydYvUPY6viir6I3ceAwpvv/qJLPeAlhiDYAZBGUjdXwrgQQ2y1PdSTjJjd7G
         +tNay3Lj7WMY5S33vB7mrEU6T/G/qBbm+tjrCJd4VCQ9yah3XR/z2si/Zm9W5BasWLuy
         ZlqA==
X-Forwarded-Encrypted: i=1; AJvYcCV5cFBZRY//PSDta5Klt7ClugpC6ugTJ8EkxL4y+DhDZyTUKjw8VQgtv7h7wrbXMv5zSFAqWx6MMA==@kvack.org
X-Gm-Message-State: AOJu0Yxv5gnYwDa3Xlyb9vj673Kh1Ctwk+fmU+KGtturyle5pS5S9pgj
	LkpuCYrkZ9zc8djm76I7pDPccD3dbZ/tomqtlwJAexD+6D6ZLYypQV5zKhqOsQ==
X-Gm-Gg: ATEYQzy1RZM0NoHMqx/Hcqyb4f+FqK7/Chpw3sDabSjggt89atgHHSX7qkK1NbNpKT9
	eZPdeDYxsk6y1uG9JZxd2iu9fYIgxhIhAGV01WtfkieTrTEfQihc7w6vM2nZ3sXUfLEyMPeqXjR
	2gBZdDTzek5izHilgtls8sb9JUogo10I2VoSQyHNwDfo9uJ1buMTwISuDIB0erPFNagQEz6IEFt
	ViiAAfcTyaYoIl8VT4SkfvDuE0snlcx6vf4HDub+QH7He4oJPjTItVDfkT8D62abnLR5Khrlp43
	Hpnw4Nx5ckA38QkP7nxMd4H6JFc+Ni6LdUN0xYjMCFeh1ExRLEMW6EXhPch2N7c9YlwiOY/iU5o
	IbtX7j1sdPQjrRRZbsUtWM9C0RBxKuyJ7TbUEKq6LZmgRxveBUhk+My11VE1LO14rdLgy3gY1Sl
	VCOoxXzkYixTSEqobw
X-Received: by 2002:a05:6a00:3d55:b0:81f:17b:c70f with SMTP id d2e1a72fcca58-8274d979671mr6142851b3a.29.1772301354054;
        Sat, 28 Feb 2026 09:55:54 -0800 (PST)
Received: from dw-tp ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739db4955sm8884208b3a.29.2026.02.28.09.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Feb 2026 09:55:53 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sourabh Jain <sourabhjain@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Donet Tom <donettom@linux.ibm.com>, Hari Bathini <hbathini@linux.ibm.com>, Mahesh J Salgaonkar <mahesh@linux.ibm.com>, linux-mm@kvack.org
Subject: Re: powerpc/fadump: CMA init is failing
In-Reply-To: <6a0fc7ec-591e-4f23-b0f2-aec9aea88621@linux.ibm.com>
Date: Sat, 28 Feb 2026 23:24:22 +0530
Message-ID: <87v7fgiwj5.ritesh.list@gmail.com>
References: <4c338a29-d190-44f3-8874-6cfa0a031f0b@linux.ibm.com> <87o6lagljy.ritesh.list@gmail.com> <aaIDkB2xLABDyV1y@kernel.org> <87ms0th9xt.ritesh.list@gmail.com> <6a0fc7ec-591e-4f23-b0f2-aec9aea88621@linux.ibm.com>
X-Rspam-User: 
X-Stat-Signature: uuofqionno736itgogj98infebahr8er
X-Rspamd-Queue-Id: 0B276120007
X-Rspamd-Server: rspam03
X-HE-Tag: 1772301355-818144
X-HE-Meta: U2FsdGVkX1/iI5a/vrnqL/N9CsS88XjnLPeeSymjOfBCOmFN01HVTDXvbwSnhuo4MSp6yjw7ox3hT9qXExdJdyh4cnOrnJaR9jtYUdP1GD630wWlNLQdIcwuhJ1SeOZy5xZZSjtjgZPZDu8iacMuECYni5ClhQzsyKPGVnZVxakRmGKoKkzroSdsZnYsxE7PckU9YJ2N0lda0OXwWvmJ1jIxwj9xpKvStoJ3CSWEXYSw9l7oXLbrgFmTsPX18RE/ZXgDH/SATN0FnF1I5tPiXwQO7juqibzdZEUhqeBCGHhUpYwaeNjkO5yfLZWUSYwHpbWCb0hQ3NwB20wS2jqxJGv5Ie5TFZJdV97xBpPjXhsVOA5T+BpAbyR+4nmonAm7kp/9D7HNS96PFHHLvysJijcTf5gj/TK6vvq5Nqx6AOPtDtrkrtdoqwCUJxxmVbpyusKQn1xsb1ABDd+YrmrPjCgFPMvaDkOngjB7tDlYGhoqDHpvaehaZzR7yg5YFK8TIUkvMA/PIGjhedEsukLkXBAKJcpDKVSXwtVkmPj3HBh10pO/3BuECruz/BwsQmvfL5uZ/XrsTeSXLlDbcswyHHHKZRcUqBd8j4E/jyj7KsdlC8zRLzLxOmEKGoJYyzGc97uGNXBw592A+A4nGCRx6QpmiDembZl47vaHkJWROwISeqydYcs7xYLORXJB1iNZqQR/Gfp/I5+YewzDfsENPNtkc/sPHDm/Czi6LvM8bnd813n96daCbwGdgjku/gFC5uuSRwxhIaOzpHHa6z/G9PgHseoyftVofUdET12w7lUP2LmsJ9sfeylEfB+TFNu0SWSaRL9HQ4Xu3Q6e2NXH7YHlihQ7dicyELLpEEssjWLWaD7SL7f/7YQWvhP0pb5vuFl7aTBIs4qI68n00XcIxJXyrHty1UIoG+GZcpBrDLgCo+ZdilE25LglmxyJ/F7WOdz3QrfMHh2iOiWB3FG
 PjbVhiOa
 EbJSoZtkrRBhidvxBblrRS8kvuTd9zxtHQ4bhSp98QKy4MpPQXeI+mZx3tdsmuBG+UZCtKqr+QsT5g1CtirrgBJ0kE/83c8evJ//knHn3ZxGwxcG+n/iglr5ETfLgnLz9Keot82mbZlf3sG9WauGcwUfDaW4Fm22wdfZ/foBDLzdjp4LgUgp6J2al0Rn9RualylMaZJ60fYhRWSNQxHydtg++k5NInaIBNKB8L0uBUdsdCfQifSohMgj1WRsF0iP8vj6xnsL0nCdksDkH7EoUqRf8vhwzCgml25mG/4n3UuDcjRzf61H2L3yxL4So/oe3xxLa0MPx20QceElZH1Sqyr2s7DW6jC2OBdUK9dF1Sl3x6tnHrpWTzQba/XEfILxCn8oIg1xBoi3d6bxMosunxES+jtZWXg52BU0bOQX0l6G0YX3owbJZ9yynoq2Y+o9nz3O1Iz4LuvMk3qAxvnvdjmV3lsKHy9r15bn5GhoptCcYUg6SrugpZZEHfTHonjWVDhjQJAA0n0WcCBxecWSqCNrGPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sourabh Jain <sourabhjain@linux.ibm.com> writes:

>
> The above changes fix the issue. CMA initialization now works for both 
> kdump and fadump.
>

Thanks Mike & Sourabh. I will soon share the fix.

-ritesh

