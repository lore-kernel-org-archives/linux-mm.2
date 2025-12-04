Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ECC1D29FB2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A4D6B0032; Thu,  4 Dec 2025 14:36:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2A7E6B00DA; Thu,  4 Dec 2025 14:36:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2DD6B00DB; Thu,  4 Dec 2025 14:36:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2AA6B0032
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:36:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 422A5586F1
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:36:57 +0000 (UTC)
X-FDA: 84182796474.18.9CC2661
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id 342408000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:36:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=GV41TixF;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764877015; a=rsa-sha256;
	cv=none;
	b=0Y+lhOTM76dhUUYQpv/JML1OtMIfFSC7u6c6myUV6M0HWK6fzy7huvT4gdLJqWOSsQOQJ0
	Gzs8XgP7Nz7ZQ2H9+pOWrxXyJB2RkMFo0eYs3s3zQcMGBnsidxQaS4olmlcvxeYglzmOjY
	CVpYEYAcPKcFXRkZbd+bV5kcArnxd4Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=GV41TixF;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764877015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfmTeirb3cJ8WH4Elb1KL8rsHozjiNCHYSp9+LExjhM=;
	b=21xY3vVU+xicwW3etcX15uDMFM2bf/I19Z4+g2sl8HiqT4zLd49WgTEwlK7Bkq4lK1rRhB
	EOqKWjavMHUCrdF6FqhPt28lL6MhLGBMLLSwXjzH+X2YJIq9MnVNJD7nbkfDr9RcdZ6eXC
	vwZElNjdpqdmxgyiN/YdL3scSCgil+s=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b73a9592fb8so355751666b.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764877013; x=1765481813; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hfmTeirb3cJ8WH4Elb1KL8rsHozjiNCHYSp9+LExjhM=;
        b=GV41TixFKIW0qXo4kSbGOavPUB65abPTuffmjQQhWzpPuT0EbQ6e5FiojAREfFJ6dn
         bksRZXfUDvDgfmZse6Y8FIisYJVCl10mFGu8pT8U2SRLENF5MGpe2fuoEyV+p+yNoj3H
         4kxDfNudeC4KWtPOG3oaVJyLH9fhWXpiCU3MY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764877013; x=1765481813;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hfmTeirb3cJ8WH4Elb1KL8rsHozjiNCHYSp9+LExjhM=;
        b=nRBVQZ+fhzGTeBINopS2PTWW0eBos9qKmpzEqEYe+Apoo0b4cBbVJ59v+O91MOG36l
         ny5ISuf3bYKjcmOWig+CujvZfrhfu61PdxABkh31VCz0vjW7x9WvEPloeDL/W5RvTpXF
         SUH+YnDWb7RWaQ95r7S671m+U3eIgoxt99CwoAWLLes6/1Lvp2M0BLsJ6ZMnujG4WLLm
         JNwgpWbHw2+gbdjim7Gl41hHPM82bqw4WGQPn2sx1ekbwADh8ETnbhpLdyYBRLTRB+LE
         pVVCGd9iFdBZt9tyH51DAOZZHreYpeS3bqCozj4yGPQuGCquX3zFQ0VTPzg8YFUXRSdy
         l2sA==
X-Forwarded-Encrypted: i=1; AJvYcCVF33rccHEceHnbCYB2s190IF9MsXeSs2FgWknwAmnsJ9plsquYhYYTOQdBqR1q1WNhVQ2fSY00EA==@kvack.org
X-Gm-Message-State: AOJu0YxnRJIB303Bie1NsKyuzlDnn6+p3qg8j2cnBnKgDJ+2kUXqgyBG
	b9RqHSuGs8XzMLnH9sxktW0qNs0i1MgZCbZInic76SBLrNSrTtl3PPH+D1Ppp91GSC24KuufJPQ
	P7bbuxyI=
X-Gm-Gg: ASbGnct8/9lPTjb1a+pFMvJzfw8+BLxkIH+2uENEgZHWyJAp0FfQi2We3SRUgBXjTI2
	Un8rg+WWiinQZsiumTxdrjG4tgDRK1scY1/uQcYaGkl1ykmNqtkT150kUel+AOfk9RSvFLaOZvo
	dhtdKd/C8b02JozywBIyx8r+0T8lLWAJo2ARQh0T61dogWnWTn662zXVCgxdzM7vcfWvVkrNS3l
	t0ooN6dXWrH2Vc1jmp3frbbvI+/vWK1a1bxBlo/oGK8QPCPh5EUCOX7lwol0ulndAMvalhNfVc+
	fSsZuRHgaMhEoVXqwYGXPa/JVHOC4OY7ynxqnq0w4MPSDsTLc5ae5Fg8MWfuaCF/Hd1UeGLsuHk
	mOk0snnxq3YWO5KX4Nk1wmtNd6BnCKM2Czh3ySPANREJ3IhotLhzIxnF9YngO7tulLIipITblZb
	/U4Ztjy7KGnyEtQZeGDsbI+YzHE5sanNHYQU7Fq6h4CEZwClnPMR4jfEpAfz+LNN8Eb1wkgSA=
X-Google-Smtp-Source: AGHT+IFzlFcNZr1F/uKz7U6R/P8Zk9RIPsGSltDu5EK2nuCSLEPHH2ffWz4V841uTFx20cQKU+VsCg==
X-Received: by 2002:a17:907:9808:b0:b75:5ac3:5323 with SMTP id a640c23a62f3a-b79eb66859amr460833466b.25.1764877013282;
        Thu, 04 Dec 2025 11:36:53 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f4498d2fsm200230266b.21.2025.12.04.11.36.51
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 11:36:51 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso2622353a12.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:36:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWizEdyrIHwGwUMTAFJBk6BxfDIdR1xKGA8ZsKodV2CJ3ljjzZdEYB0hPJBAx92WQjNqgJQEnoDJg==@kvack.org
X-Received: by 2002:a05:6402:5189:b0:640:9997:a229 with SMTP id
 4fb4d7f45d1cf-647a69e6acbmr4507453a12.3.1764877010898; Thu, 04 Dec 2025
 11:36:50 -0800 (PST)
MIME-Version: 1.0
References: <74032153-813a-4a40-8363-cce264f4d5ea@linuxfoundation.org>
 <1eb24816-530b-4470-8e58-ce7d8297996c@roeck-us.net> <0425d7b4-76e4-4057-83a5-a7b17a051c54@linuxfoundation.org>
 <ec77d11a-7613-4b75-8c9e-f2bba1595f0f@roeck-us.net> <9d520a1d-0b8d-4d30-b29f-230fc0f92b8a@linuxfoundation.org>
 <1f31b86d-283c-4878-92d0-ab90aed0c58d@roeck-us.net> <5af4522e-30ab-4eec-a861-c2760cdabd4f@linuxfoundation.org>
 <2bc690ca-fa57-46fa-949b-28b5441cd364@kernel.org> <b24fc85c-0e6d-42f9-a6b9-05136409098f@linuxfoundation.org>
In-Reply-To: <b24fc85c-0e6d-42f9-a6b9-05136409098f@linuxfoundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Dec 2025 11:36:33 -0800
X-Gmail-Original-Message-ID: <CAHk-=whd-k3GhNGvVmP7W2p1d0d4ctqJ8iCuG8DbyKzgNqCL+g@mail.gmail.com>
X-Gm-Features: AWmQ_bl15pRGGXuHFcuQkuAPhnzgKRm8fbeljiIJE8EGq1gNKXLgKf_oozB3SVU
Message-ID: <CAHk-=whd-k3GhNGvVmP7W2p1d0d4ctqJ8iCuG8DbyKzgNqCL+g@mail.gmail.com>
Subject: Re: Linux 6.18 amdgpu build error
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, akpm@linux-foundation.org, 
	Alexander Deucher <Alexander.Deucher@amd.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, 
	dri-devel <dri-devel@lists.freedesktop.org>, Guenter Roeck <linux@roeck-us.net>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 342408000A
X-Stat-Signature: 4yhacrk5qhouo66b6nda1wbxqrux6sn8
X-Rspam-User: 
X-HE-Tag: 1764877014-788243
X-HE-Meta: U2FsdGVkX1+dfoG/gyZ4w8f0Xtasg990brcVSh12YZL17v6G3eLg4QZ4Wd+zMwoCBJeezYQCC1XKQeFJSIxgULI404EgBvQpLN1BMNKye4ggyZEj7qorRTZFU0b1neyliHpQtYUWaurlq3rpWXSdf1AlJqgb/jfvpyJwkZee+TeQaNAFv20YOIHGFCNMAu+9w2qxRfTx81ZTYwKLXmNrMDqUQ07tyY7dlcHfnShzc0+xnp/Une8hZXqllWy9MUYwh34WlwmwCydSYg0uZQ1RAja9rLiax9JO+yPm33G6OA2eXe8f14RYGjZZLQzcLP+8DSRWOLviR0rm5msOhbxpEUJg+n1+ng5AEswZWkiWipZaDXDSnu8bZEEBiFbaQW+57akWW5xTiF0bF/4+aekq7dHaaAmgzP4jrY1JKPtkdcIuM26iwKQZMnAEf8b6d8P+lhT9hKtUSviKyXSyuAHa7bmDNPl9dmKZknY1oImK+w2eqvyabquxM3skGoaKSK4BXaKNVrgNC1ghjEG6DNb+T9Eakv2XRa8EOqUASfFkTfpi8jGN22tOU04pYwr82Q5m7jGrrQg/H155SvX5/0U8JoWs/SZHoWGeHAjlGSQyLsgraGrcTf8yZ9YQRLas7qN6Jw/ZEbGtyNQrmuaXZ9/WH+aS0GVdZpdi8y7jSX2Q/vmsZzBtJMZPZQIC4hwlP5HWq53Gpmt6J+rdzkaka5vK8MhwFWOwMbWn8sGqQlvF/gscksfAXuU/k6eyaoKu+gmjCp+XYgn4SDVHkIMgMLgxyYiRIkf5aUMUamMslldqhl1x6Fuz+mkPuoSuTiIq/rY3YZFK3TTjwHMQrezvIaNF/eYPzbZHVWRaKvhaxsSoUfj5xMWG9SpcIBRQLjSdHJGMOyZS1miq6MIiaXx+2qqPYJrUguYn8MqxfHSMAIgdeWcJVIlL9jO2st4cjlHqj1Niy5CJHJWDpOysozNSH8b
 UaMmUIZH
 vACreSaJS+y7R/p0u1Upzz/jH2rnhImpUllh39JpP8pmZCJzCOQsZhliV/VZ/YzOUGO3g5r24oamcYTIdyqvd2H5PZFkHGpaVZM0sRFIcRgm1nqWGwaFE571z0ByCInuSoKuWTTgJT6mUvKz4uCOkdKnt0H0B57UVpsP4s9BOY7t5UeF68UPtwgXWAx2iYRIevf6LGzgp+0YCqJI9BzWniIsDaH+E4Q+d68QV4/oJ/JiVO5+5+4oCMlmB4p36g4EVjb3UD6YNTC5RPi85EMZJypfmOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Dec 2025 at 09:40, Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> This commit has impact on all architectures, not a narrow scoped
> powerpc only thing -  it enables HAVE_GIGANTIC_FOLIOS on x86_64
> and changes the common code that determines MAX_FOLIO_ORDER in
> include/linux/mm.h

So I suspect your bisection might not have worked out, and there might
be two different things going on.

In particular, hugepages were broken in 6.18-rc6 due to commit
adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero
folio").

That was then fixed for rc7 (and obviously final 6.18) by commit
5bebe8de19264 ("mm/huge_memory: Fix initialization of huge zero
folio"), but the breakage up until that time was a bit random.

End result: if you ever ended up bisecting into that broken range
between those two commits, you would get failures on some loads (but
not reliably), and your bisection would end up pointing to some random
thing.

But as mentioned, that particular problem would have been fixed in rc7
and in final 6.18, so any issues you saw with the final build would
have been due to something else.

Can I ask you to try to re-do the bisection, but with that commit
5bebe8de19264 applied by hand - if it wasn't already there - every
time you build a kernel that has adfb6609c680?

That way the bisection wouldn't be affected by that other known bug.

                    Linus

