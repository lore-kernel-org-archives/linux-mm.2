Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE41C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 07:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8410B6B00DE; Mon,  6 Jul 2026 03:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1F06B00E6; Mon,  6 Jul 2026 03:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2616B00EB; Mon,  6 Jul 2026 03:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 450426B00DE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 03:22:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD0068C915
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:22:36 +0000 (UTC)
X-FDA: 84957509112.06.57C6611
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id DF18E1C0002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:22:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W8ZxbUVB;
	spf=pass (imf21.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783322554;
	b=aOCqqKGpkc7Ez0TPhXFvCzfWASLI2qRM4k54kPtYpJzhVFwh9otGmvkNVqMy7Y79Z0s3hA
	QCVvHlXq2DcV2MR4vD5YUppGfK+DUTySz4Lh8cyI5mWm8ouJpFTPIADFjq8ua/prw/zTBU
	j0pRhV4C+mcHNAlUFpetF6TKGb/9l/g=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W8ZxbUVB;
	spf=pass (imf21.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783322554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q/jYNfg3vyt46I8puRvbOfRgp2aWwOG7z/TVgYkci+s=;
	b=s55fQ8e2n2xvbI1U6jRZOnPXMook0ViKnynRYHuFw3M9dJSq8bOeObtBanOCxFjvMcQ7dW
	Eb/aeYwbkNtjNY9EYU8kOu2w1CoyhDiUfOx9JKjguu5Dn2/DKtMRg+QBUXQawfdrywlpKC
	85YDcqH1Kdt6x5/2fAolBH/DVEPxJtk=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493c733f15aso27221695e9.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 00:22:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783322553; cv=none;
        d=google.com; s=arc-20260327;
        b=eu8cZHubkQZUHI8RXeh0pxqKBJALEaE9Lmz/cs5vA4wCraHrr15o21YhSu0DIy/G/i
         1nyAYwETRUWYSnVIPSdgw3z3FnDkcrwENuaO3ZeRK3/Di/J6ZnYegwoc/C+dQM8lsYMI
         eCjcksa6hIE2Gdn/Ave6qz/QLvl4o99VLL8/h5n0pBMz1/AVDbSOapOdm/7utqs0s2uS
         4TJnBK/cBxvRp8UGIW9rZw6e5np+eYTfmWibJwAwjxwHAesb1PUdxYmu2dHSGWXvePDA
         7BJs1iBjSTjOX8KAzowZx/oP8zlIJCr4vKmxKaPjsyF+XAG85nDwooMMs7EymEYlADlj
         bw3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Q/jYNfg3vyt46I8puRvbOfRgp2aWwOG7z/TVgYkci+s=;
        fh=rJx6LXmSiWZBmUJf2eqN44Tx5MDxqOKS85Qs+1jmr/s=;
        b=JW3I4tvVVgy0Z17Bl+e/iiwhS1AJUt1EJ8aqmh1gBzK00nAH79Nr7emG3MSUa8aRwF
         31qApCbPa3OdBLmsruYzpTy8N5X0csghO7Bt8eEMG8jvdrQDvhDmAYKGZv7G82P93hND
         y5B4mKzEIBus/hQT86eeihbU4LmbMkPIQQ3keWmzrx+yRW5hB30kSbujHsS/jNdpE05r
         w5PuhwAUTqyISimqEl56105Z31d/mIB8Lch//YOt4bVsrQgtNQPuf9jIW+PD30eRoSch
         41AGQGVKGcn0ItX+oUifvtPoapqfgYztVLCS+6DQYPvKXv77GidMkk9UCITsDc/wG+cj
         o/rw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783322553; x=1783927353; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/jYNfg3vyt46I8puRvbOfRgp2aWwOG7z/TVgYkci+s=;
        b=W8ZxbUVBrP3WZGmeSzSqyR2R89PmtDnEmE9QA5EiG3Us48rBH1lw50Nzo+EQnkounS
         +4c9ALz71A54nmgetHIVU2dDGAvhzjQJmF29RulA1o9svnJHhjQUE1667C53Vp3kT2Iq
         o3Pvi2kR0R5HeKaLj3VF/RRL/vIBbB/KbznoZeUnIo5LVSGCDxJlKURp8IlXg4g6YRqB
         TsfP9BP8/E588s0X+PAwL5wVni51hwG7BDfwo8WVZNV7iHGWB+iCvRJfFPSxEule0Fhz
         OWzNn9GMerUivRscB+6GxwLsitym9EkW8hsEJ1GTGLbSHXKuu+mr1DziwI3GY0I6B+p3
         gfYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783322553; x=1783927353;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q/jYNfg3vyt46I8puRvbOfRgp2aWwOG7z/TVgYkci+s=;
        b=Kla/LPjvvVYSJln3+E2IkfvfQpMxv2BZdiieuCUcWd4uiBOhaGbUJt6GqxmHqMkPe8
         zznd2mGKdyi1f7XsnH+CotynZBojcyWwajuNi5SWmX1H1Fz5+yP0Kguhbik1YD1g2TQ7
         4lyjkVg7OfNgqxJ3yPVgR1WdcIQfZc8y/kpkYSENpW6iz295YFqVrkjRnLv59w/wD84k
         OiZFPDHoboUkkY5xGM1BOwjtoZBQ6M3EfL/wi3p4hA4vCQHSq/zgbzaZiacKH0LMZieZ
         eyFnPOy1aTK+CaICobMI5s6WQ1Dq78Qx7sUbNj4GyRt+w0FjK90R12ELHng0+MFAN9Xx
         4PiA==
X-Forwarded-Encrypted: i=1; AHgh+RriVtpLcCOQBFWfuCuFSwM5cDgY6SqrjE+2xIL645zVOECkSG7fELhnWYqrFUeutugelZB+F/bGjg==@kvack.org
X-Gm-Message-State: AOJu0Ywuk5bkCSTYVdp8VBpwXHdA9j+Pagwh2QNnOxeS2NNDqMdz8beh
	1k/Gx+tClLUnEKLpDP4KFFDKeDGBKNgUJyT6+CUZu1CiWc43Gq+s5Pz8hzS/5wUtZN2bTrkewr3
	0aCPGDBM1tzb3DKgGafE2Q/L7f1sLEOU=
X-Gm-Gg: AfdE7cmX8xhHdYyinxNTlEhg8nzTT8nDKIgAEdcjn93nrG5vS95LYRzjaCIVWEn3UMG
	Akm59unMkxlrt1Z5+tBn9F1YUZQQLlh9rq28qmuYQ9008lTtvxWKRsom3PzStGc3kUFy9LRhYDt
	OcNHf+SCLy2/TcncNgFQwqLITlHAL/T7B2UOvoAUisZjsxP/8CweHr/XcWypO4vXKQeT6qd7uGD
	GlLwpJ+KqNURtq0N/yc8NQ6O/t0dnHtSaSSfSESQUQJ5fS1VBKNnD6O5DziJHdlG/ZY6blnUA==
X-Received: by 2002:a05:600d:8445:10b0:493:c2cc:aecb with SMTP id
 5b1f17b1804b1-493d11fb9f5mr76134965e9.38.1783322553198; Mon, 06 Jul 2026
 00:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
 <20260618084726.1070022-6-jiangwen6@xiaomi.com> <akPKkOt_GNbAbyN5@milan>
 <CAHKocdGiK0ij7FopLi6b_rQ3CDyVr=ARbC4cCwNG=pY=iTME5Q@mail.gmail.com> <20260705133535.3f4e484e298a52122c6d4721@linux-foundation.org>
In-Reply-To: <20260705133535.3f4e484e298a52122c6d4721@linux-foundation.org>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Mon, 6 Jul 2026 15:22:21 +0800
X-Gm-Features: AVVi8CfvekeoxozF62FEZtQaptgp89Nv6sXnw13jNmCNRR8vOyi1QTHiK4hlCbs
Message-ID: <CAHKocdF1-aCh7XODFLYHUxqxv=cybik0Mb76JweBdSxQt7bZbg@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, 
	will@kernel.org, baohua@kernel.org, Xueyuan.chen21@gmail.com, 
	dev.jain@arm.com, rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org, 
	jiangwen6@xiaomi.com, shanghaoqiang@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DF18E1C0002
X-Stat-Signature: rmefkogpes8zz7tjm3r39cymtkip3pz9
X-HE-Tag: 1783322554-654572
X-HE-Meta: U2FsdGVkX1+yDeMX7Xn/ZRaqCPlBTfQQ36cJXC/U8/5EOwhfV6QRGqyhbCQ0Oxz1wm3mhHePT7v3TyXbR+OpI9yi5MqOAkOAOUFchyeKwpEuEDdLxd6CeuCX4TOoTsICll0+h+pPiKEkB99/GQcwrqVi6EyvRj4DsOtrghSUVVhvwoTP4qgEuIwyEdJQDI+af0tuYq4TdTcqw7eih9yxW4D/OIfvL3sPi2L6AKigJEBfcbPu5kufeL38oxHVGvYAJQlAXgYx/dru4x4dRDjn1Lau7cVOkhylKyq8t3jCCKTkwh2dkLrIVlMjSuflgMyJn4XtBHDu5PA8VeydJvndlbPVSmVFrbLvu/ACZfN9Iy/33UALJomKA+XV16AD8ohPf30vGdRhYwB8OUTfMykwd3chOgqnEl9vXClPAzF3HR+3+5sZ4jRC57epEyaqatpZhCWKxZFtDA4PvOIidlRrbvawj+6AsHM0wCJ1+HVKSYwoToF92anCikUWZXI8ijDWlVK1OCRtztGuY1ppM8YIcU2hQnWFmoZ8oAKeZi93BDr9s9KioZtLVaEgORxQkpQ3IaBgANgxr5JJ4DMHdFLnlRaMQM5xgaGViSpM6RIGB0phnJR4XPBeaCyDCaYFhnHKS910fMhY1ftbliBeoj1kNWAZYrwoJHjJaKKZxm9S8rdjDdeOm73ynW+hJVmP0Ha64LriR5JB8V3NFRRn4jIRNBRrvOwChJ++H46gWCPtn+O5kCiQK+wyJ19IzZVU+CPFbL/KDAkh4ys+qjt10YOhhoi9+jZJc/TWHr/y672iJWCbUkObeMhIqWLIt5ckJ/t22s+CWbJGmV/oY5Ft6l85+e99GdfLqb+kdJ0eJB+vbsume+c7DEc2RXg5tUTF/jCG/wzzU7OhwpdM+atpL9eg4xleqMYSjjp1sj1emfLsViB7to281fa2TRO0IHo6kjXQ8MWgxiEQer3jnIfCNWz
 5C0KaLup
 w3JF7ChBkqkputaBuRkqMGdrPl9O9y61A8nGyhFp7+hGcFI6Z91Z0n1cnvtfJX6xYsilzElOKay++f8K3XC6WpUIQ5BR8AGxMXkwMIOwzLp4iFt7jyU7rR885um3XX+O+ZWTPymirZ7aOtFocmCbsgWhp+dvbQGYPZtrau0e+Ib1XqhUOY0caCOiEap3gpJX0drATcBXLo5QPBttpBAqcANzqehJ/S9c7QSZTMSFpVxa9X7vGSBcPGcREc9pqC9bUGP9AjvSICOoo5ouoCcikfKkj+NUdiL8zFxgyg/bdSgEyUT4BJub46taJZkYAVGvl7n0587fmjXXfHWvjAWV1PDsG7Qxrw2Mr7Iz/XCsrhGVHs9p0+mZu0i7k97DR+vQTi9o9zGbV+/xTRWucgkbCRTpb7Vb9t5LqTQdw2ICluIBR08jkmjGkyd0CSmbEuZtWQPYPb1r5x74cJKPVkYYsJ2qtW0FYM7lclLiTEd6xsS2nVHaHLdfaMl86cB5g8lsBKezwZ3aE3qhgcZrimdhWZRJ3QGKE5MPGggY1XAAZDMqWaj9P62jaQltzcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Jul 2026 at 04:35, Andrew Morton <akpm@linux-foundation.org> wrote:

> Also I added
>         https://lore.kernel.org/20260630184129.4B62B1F00A3A@smtp.kernel.org

Hi Andrew,

For the unused "start" variable, v5 will keep "addr" unchanged and use a
"batch_end" as the batching cursor. Then flush_cache_vmap() can use the
original "addr" directly.

Thanks,
Wen

