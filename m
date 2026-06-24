Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3614ECDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 21:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5216B0095; Wed, 24 Jun 2026 17:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4BF6B0096; Wed, 24 Jun 2026 17:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E396B0098; Wed, 24 Jun 2026 17:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C587D6B0095
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:13:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A064C1FC2
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:03:59 +0000 (UTC)
X-FDA: 84916033398.19.223006B
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2207220010
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:03:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y7Lu+dMe;
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782335037;
	b=BT1bWrJq7nk/AFuNr8GZPcT+ESAVocRrvpWmKMHX1VcLWbnDdI9D8/rKFftHyJMuj4K1zs
	7Nwue8L20sPmWIrd9FDnb3Gb0/iOIjpoyrq1ICna/+h/CQhM2x7csfr5n/iTz2Nw8am3WV
	+yUT5MbIgXq/vKeEC4wUj340l4S3AxY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782335037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtXqtocb1qS3/K6xnMYZSBV/6kQD50+mfkfO7ut81Ek=;
	b=2rERmzyGt/D1yeKFokp5+uvyNriy04KAdLHRNx/rCJ4RIKi1EWYXWwWdzxqsHCcbtTKPpL
	0jrgSEmxWdBty46OjrjpnrdeYYZ7GYfJENNVoj33JrWEC7GproYSDJrjE8ut9c3x7yIhGG
	ZpXU8d+8hzpgVsCoTJpAR7wi5GLssHU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y7Lu+dMe;
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1363fe80fe8so3034389c88.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:03:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782335036; cv=none;
        d=google.com; s=arc-20240605;
        b=IdABEgyxweLmhWwv55qXLSthCqREzmFdzXsMdIVI29fB2z2EAhZoD4/6sy2W3BRoeS
         rXXRMFVZu9YgKX3qXQhPlHPMCXbPbsQmAwAspdSW55C/sHEshzjF3STS+pz3vCxLXWD0
         5iTjP6HSRUxVaGObbufQ9k5Vt3g7R8t1QULxRpGFxn8E2B+j9+CsAe/m1Xws8icMeOXe
         yNvVXfr0mWOurUPv1fRRZrjN86duYE4YHGQmY2QfyUKe1TiDiVhp0xLekbJa5v+8s1A2
         77yHgZ5fFlZE1Uo05Cv1c/Kk66tyBwtWpuWPq7g/3x75qs747qRRR+L78TGLU/Yjhc/K
         aNHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=JtXqtocb1qS3/K6xnMYZSBV/6kQD50+mfkfO7ut81Ek=;
        fh=2GYSkv2UGO4q/ORlJwkN6WPcplPpVB8SRM69w301ny4=;
        b=gA107tWQKdDHrXvBEw49vnfROfQeXFEauPpZCG96cBsbgo/MSTQBmuewxhVIHehJML
         hRs+xInLKxTgWccccVnj8xXurdPFD6lAZha+er0hbX4w7jXBzk1Qu/djJFULbsACStil
         vovYaMQ8qvlxKo7J3z6TVwelkUeFR42Uyj5SmWNtwg6P2j0Xt7yAlCbDTnqYBLOPb4wf
         CsHJzUrsrxR7A4PKemEF5Q6GS82KvTJzIjkzUZOqX0L8wkyPNqHP+eB+kHxeOJdcuzt9
         y4WmcC4v/2LoHIrbU8UDWi3TQy/lYFFgyaX8YBnwWkAxKbthZRxmL9t4QUVTVmLkAibg
         LtiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782335036; x=1782939836; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=JtXqtocb1qS3/K6xnMYZSBV/6kQD50+mfkfO7ut81Ek=;
        b=Y7Lu+dMeCbQb5c9RMYUKKVH5FazmAmFwWgA61G59S5I6W7RBCjA8dqRYwMA9YCoTc4
         00w5KnSV7NSiVzN+TrcDvs44Ds5vo2o8HRKRWF5HTFOZJJL6TI9Yq9bk9cEWDju3ec7N
         qGT99D5o+5/VP1Y13z3PRTl5+MBJ0M1dfo9SWO8+T23Ia/9H1RTFJEi5UNOBO77nl3bo
         YHeoHeQIvsF3Pi50uyMreOW7bbI2sL0biVLacm3oTJOHNjfAE7DQRoiZPvB/2ST7o1Nr
         Ir8YQ9sOMwQZjbMZjVcmZrneGsGR40bQFtJWuu/DR43T+NlPVlKwqRzd/xjBzIQlTiLs
         SV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782335036; x=1782939836;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JtXqtocb1qS3/K6xnMYZSBV/6kQD50+mfkfO7ut81Ek=;
        b=Qe92t2t845lEUcB2GxGX7Jd01XA1tLPTG2iXZeI09x9k6q3izZC1FuCbsn6Zw1KlWd
         h6RbmV258hjkH4yQP0N5Pl22hAB0dweCV5pHoSR/InYsQRHQOnpBBGRcUTdq/grhpFlv
         Jx94H/TYjLvj8/GVOG0W1DXgXy89EWrkFynQ427b4MXkSNKPocMkpS3j0deX1SZvqUyY
         2I2zMRSqemnjtxvPVZGg2XK7Vcb/mt90AM9f0MfFmRTxVoeghkLpMK58G4GV3gHdKIvJ
         R8ryS8FEliaLdosOf6Wvk9gI99RZWvoWpmwUt0j9dgpBC5aOX043pL/EfTwa73ps9e3q
         0aGw==
X-Forwarded-Encrypted: i=1; AFNElJ+Jczznx40C5L3bKY5HEyoRn5m74ZKvKUNDvjdnRsjkS/yoTq20G+ByknGdOWbnXN3WaXhusA5wXg==@kvack.org
X-Gm-Message-State: AOJu0Yz+7YR/MwN0isID6QAetlCuEepDv7JqM+RIBdOSXDvRJs7dp3DN
	q0cyA8D538SFW2KOXTc8VU/xMeNY+f6+EZNyu/xb6qtINm7xgtZDKtsjGPVygyEU48gU0dcZDVf
	C15lhQm5OLXU/yKY6XQChOhTJ8EUA17PavpW/bOcX
X-Gm-Gg: AfdE7cn+qR1xRPXKvdcJyhxcHsArFaDRyZs1NAZzkP86v/rqzcACmVInpb6wxdjADr0
	nTnzXK9ipEaZLYFis9g79ONUCZApiMRTWOm4+QVvA5B26JnO6Hb9fMU2IbYfrNORJUJx9S03XCz
	rexW67/K9h1PIwT+qpkie12gqxgh4pkCzpW9v+zB13VV9p+sZO6ZhnprqHa7mFzDO5VUrGugD0t
	fHbAWz4McE1gmcWZnM5jrlldjXUnGA0tvyt7dxCaWvh6wa2vTbC+uO9eXmCC9kh1bufZptJVx9i
	Mh5UcwbNCSqLuUhb4TnTv3H1myZiMk7ehQO/Aa5HFH442/j84W8TPCm8T8Q=
X-Received: by 2002:a05:7023:a57:b0:139:d82f:2fd6 with SMTP id
 a92af1059eb24-139d82f32c6mr811137c88.22.1782335034214; Wed, 24 Jun 2026
 14:03:54 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 14:03:53 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 24 Jun 2026 14:03:53 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CA+EHjTwLPCvZJgPv=8u3pgp+kwEwQbsXn_13FL3xUbJ7HRfXzw@mail.gmail.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-13-9d2959357853@google.com>
 <CA+EHjTx2xKjheiW5VzHw_TdWFUqdJqfgu=dOPa=_yaYBMY8uyw@mail.gmail.com>
 <ajnRxuJ19OzZ8zJC@google.com> <CA+EHjTwLPCvZJgPv=8u3pgp+kwEwQbsXn_13FL3xUbJ7HRfXzw@mail.gmail.com>
MIME-Version: 1.0
Date: Wed, 24 Jun 2026 14:03:53 -0700
X-Gm-Features: AVVi8CdCAqwoqTik6utb0yHbQZV7yiwfOGNo-KA9dUnC-gGzh63Sika6JXlmCvk
Message-ID: <CAEvNRgFDcwXAx0YYZOGzA+adVhtMLXaR6KkYtW=p4xL-Hp4pjg@mail.gmail.com>
Subject: Re: [PATCH v8 13/46] KVM: guest_memfd: Add base support for KVM_SET_MEMORY_ATTRIBUTES2
To: Fuad Tabba <fuad.tabba@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: p4w31yaucq1t3ca4j39m4ebkipkttw8s
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2207220010
X-HE-Tag: 1782335036-22626
X-HE-Meta: U2FsdGVkX1+NN9S5QACS5t9aVaB/wexVFcyd4v/29UhLtGwO0wfpLf/ZoN3qh7xrnWnTzCFBTOJXY9fnKREzaMMCRhsZr3kDmbqlUXn0xzsCmAssS5DVsUDfl7RnZclzAZcZpzsocfu7s2q7rBmhlBFTnWGzzNp+QrcofsfNY64bF75qAJ2VqVuuIK8ws45F9gGScglu1edSHbYOQBqiLRVD6Ck3sM/uoZN5GXmZ7BQxcGfOM4Wr6aPT6IxwajuMHz5YD/6PPD/75robGV6008wJiORCNZCRUDG+ibNDAjjJeeqYmjsxDS8udNJI9Hzrl05K0sMbJWNG7lVom1/Yp6kWBKHcNMwu/35fnI/mCt6mbCptvtV7Dkmbeo7DUbWqyHvi0USPDT/crLWXDWtuyTUZIaOD4V+nOEe6Rq7ZSO2Pv/s3ikJfSEWANbzcmivECeMrNexzH/B/eIXo9rWczFbsTJ2VZ+K+JUCghoGCoSaUAMmb7HJ5YcyKCv823xnxZRxLfB0/U+x6+JPrnXU44xPrzqZlUjn+g3n52jirAjCbBPp4yuElZbCOe3pRMP48wSmTpOKc6l6pVbbFd0jRFDZI0szYhlPcbTT28HAZ3u7dand1gQiGZWFKjfYkMsAzcSTpnW+A9h5ZpQQoPvl8gg964LGi2nefN/906jAeH91DYtFKhb7BWM9kCgIBXFydq8Pg1UBj07TbbN32HDJQeslErTMvCiwWrl4OztZ6Mwu9Tn2Jm8phDjyrAIlmHrruMuD/ATAQizwNiUkesydbJ6zke4Vplku73kw03bMLrhYIkH4FWPztrRKfayA7M1sRCFUyGhDuYUgNa+COuE9plxzTx05XF1YhRXNbJErg8UtcqbE3lHR7uWJUgHa7aj2PbRHLwLYv4zArSj76YCxCBbRbT1oOEVhomPmE1KgNSjfcdZrU1/LEuIFK5Oi8n4Z15F7/meE03h3vjRC8oeZ
 DBiswaT+
 BPdJP0L9k9fqC6WmdIqcsz65PUDX+vJQLqCDcHlGQvaC1+T+0xy/edXVGcTSPoFYESwaxDmY7N6PW+8jqbmatEtxuSD5Q5H4yMQv5EhbfvWob+TBmB4ssGWtd3z058Pzi+FC9t4snOVhu8TmMYF1U16G/XCY/zMYu2IPrrBadZiKWeb7DcaEg0/GxFXTy+JMIbdUurYR8+aPGwZRKjWeXEbyTkxaYBitqpR/SqrFCd00cuD9OXOFA9ecPihG/nelyjukC0MbTsrF9qzOoySnCzaTiK/RUDB6XjlyHfIiREpS2GWlVcrAgKmCbzfTTxjEbddQYcC6QxxqoHHYAiXv7zoidObfAs/11g07hx6CD4TexkTlT3fDFqCgsnOhuWengwYrIHy5/V64at3EhpjeLfpAqCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fuad Tabba <fuad.tabba@linux.dev> writes:

>
> [...snip...]
>
>> >
>> > Note sure if it's user error on my part, if I'm applying this to the
>> > wrong base, but I found a build break here on patch 13:
>> > kvm_gmem_invalidate_start() doesn't exist in the base tree. The
>> > function is kvm_gmem_invalidate_begin() here. The rename
>> > (190cc5370a8b6) landed via a different merge path and isn't an
>> > ancestor of the stated base.
>> >
>> > Patches 19 and 20 have the same mismatch. Fix for all three is
>> > s/kvm_gmem_invalidate_start/kvm_gmem_invalidate_begin/.

I took Sean's patches (off-list) and tried to combine it onto my
existing state. (I'm using b4 [1] to manage these series and I didn't
know I had to manually update the base-commit. Will try again next
revision.

[1] https://b4.docs.kernel.org/en/latest/

>>
>> Ya, Ackerley used a slightly older kvm/next to send the patches.  I at least was
>> testing against kvm-x86/next, which does have the rename.
>>
>> Other than noting that this should be applied against the current kvm/next, I
>> don't think there's anything else to be done?

Should I base v9 on kvm/next, or kvm-x86/next?

>
> Agree. Sorry, didn't mean to be nit-picky, but this really threw me off :)
>
> Cheers,
> /fuad

