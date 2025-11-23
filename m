Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48553CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 17:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4386B00AA; Sun, 23 Nov 2025 12:57:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D126B00AC; Sun, 23 Nov 2025 12:57:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CD36B00AE; Sun, 23 Nov 2025 12:57:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3B06B00AA
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 12:57:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7678138E6D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 17:57:55 +0000 (UTC)
X-FDA: 84142630110.12.A687FD3
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0C8AC40012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 17:57:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cuYL+CRH;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763920674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpsNplA1Voxrb2YjfEKZCml9qot8JSx+g9qK04gre68=;
	b=MYp/68VrDDCyFjEXAnfzHlk4ds9ZnLygvp76bkveg7+EwXckmTpaiTjRyxPQ24BIdqbdFT
	h9z27YF6En1o8S54uxlQp+hRmFDlNkKwmvN8KvJMp5rm7QJPev28m+mlbd1BSgvn1f+TFH
	/keNL0BgTwUigxnA8WdlJxDSYM1GY3M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763920674; a=rsa-sha256;
	cv=none;
	b=xLIPvGXyek0CEUrpbEgu3oZDv4Dsu95j0AofF2fHQbV0X/H0hSD23BuWrMvqSw+8uXwlfC
	0eDEC9kvfF+z4HZCDrichKUZoQNuutHRHlNgl7FBuG7Lgw3ymhiNMW5vnHf+vHNZFwAUKM
	gmaEVZ7N0pFI+xzvMqTFJe0LsYha+J0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cuYL+CRH;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6408f9cb1dcso5299984a12.3
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 09:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763920672; x=1764525472; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tpsNplA1Voxrb2YjfEKZCml9qot8JSx+g9qK04gre68=;
        b=cuYL+CRHF7CxeBQS/7eorxdWnXhgPWi7+y7c6y10DzRAXassSQXBNL7RhpPTv2ZUxD
         Y9qMs++Fm4TPuNLD8D2fj+l4tlJrOPX6sA0V38Kjm/fMq99Fp6HjBU0eUKSIYWKMWs2z
         DezsSVlfUznXrhod6clhbwGrQS6MC6okVtyScXRQXABnSPGHFd1GbULvELSJegP22ShN
         5RW/iFg/QduCIlUp/RiaiStv8pDOXQqKQqGeC0eXKgVovaqpFa6z5ReFf/mAK9ms64IA
         D8altbYLKNQQr5z37Em3YNLtUJ4AsRkDZagrXv7pm8tByDvui7CL/W1QZy2DInQDDf7a
         DkUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763920672; x=1764525472;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tpsNplA1Voxrb2YjfEKZCml9qot8JSx+g9qK04gre68=;
        b=V8x2IrmV1SaR0K+8ocmHVo1Sc23xLvr9BDWOhgNVdCVFD9ZYMFoBhcFYhP0SXgBNwT
         sp3Jgyh2QbgFHHIxQ9nNsl4I1bFOFQFpCLmcmmTDeTiEjys40V+Yq16TIrhtgxahiiJs
         vOUR92GR3X9ZIEWVt3AWh3eggUspxvdh49XbZYvd1V6C/f8hrNZ2zVMa8YJyyL4Ot7Oy
         g1sGQ5rt/dU/3e7Ix1sRL1NMLE95Na9bZ3PmSaeQyh1g/EsBiHnObqD+SHhRWxRk8qYL
         /99R0xdZmkzw2w9ofm3ehlk3YGM6koyblwlGqqnsXPi+Y0J/7sJsqKIy962QxUI/co9B
         hE0A==
X-Forwarded-Encrypted: i=1; AJvYcCU62Hn/ZuJpgS8rIm1q8xMisR06DfCTnUczJLDQrxcDgKnGr+HNwQZeuUSzrEXC8wIOsoJoXuK7ow==@kvack.org
X-Gm-Message-State: AOJu0YyfmUb9QF7cY0AC12J7As8KQ0RCmjZ4otoAxg037M37KVGi6+KM
	HFexRwTBEGn9jaWlWKsoBzmx72BUt5B1hzH90ozGz36TrsVJEBPcWVZ8OdgApDtOaxXU04U11a6
	iY3xl3deo+oC70yazH/BTyzNU8DvQzld6dW02U8Tm5A==
X-Gm-Gg: ASbGncuwxrtutj6r3F8XxqaJP1GPczkpqHtyt3p+sdyCahOxhrevOyQiXqaAuQdwQqp
	QBLI+5K3HSZ+3uDOufkgOhwzTKV1HCqpYu6btwP9O24PT2A0MEfgk3+Z7OHYGSkTW+1hvdnvqf4
	pzyQfQ+C176E0iEPOIsod+Bzq8LgUQlXNlKx+7FDQGbG4yM8hBLs/jA+vzTGUanQeoEykoOeff5
	+JX6hkxLgOujFZlZt/hjsFyma9o9ePmDRbumL2/6Xr6Vj0yLY4Cu/UDk+lDsWZ5OQNK
X-Google-Smtp-Source: AGHT+IGpPvGwBwElKBibg79KxrBIQZdO1vFW5PwlaPoM2uZEHzARN/i8TzvXzLxaRVhlOvuafeBOkUf5sYbTlf60CsU=
X-Received: by 2002:a05:6402:2750:b0:640:f1ea:8d1b with SMTP id
 4fb4d7f45d1cf-64554665a54mr8854375a12.16.1763920671902; Sun, 23 Nov 2025
 09:57:51 -0800 (PST)
MIME-Version: 1.0
References: <aSKvbLiFT0aParmU@rli9-mobl>
In-Reply-To: <aSKvbLiFT0aParmU@rli9-mobl>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 23 Nov 2025 12:57:15 -0500
X-Gm-Features: AWmQ_bkrWaeby1Q8WA0pRgWJpDWpR9oPfzbbe6thBvqJtwQSoichCxeFeoD0NkI
Message-ID: <CA+CK2bAsNp2j=U4o9pAfC87TSE+1sPRA4Gd6AjCUW2ZGKffTgw@mail.gmail.com>
Subject: Re: [akpm-mm:mm-nonmm-unstable 86/104] liveupdate.c:21:10: fatal
 error: errno.h: No such file or directory
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7i7zfkgq4o7jhwdqzt3b8ha85zts7y5k
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C8AC40012
X-Rspamd-Server: rspam10
X-HE-Tag: 1763920673-875063
X-HE-Meta: U2FsdGVkX19omVc6AbA72SCySdhFj0T93cDT42PA4aAuIUlFWSdW0sSnXjUxC4t/cVawl1nXo9rCRY39nHXbcEeJlpLBoWfzgrg6esrPnkz5wy3EZgO0r9RBwj/N54TEOBtHMhoktXp7o2kaapxKYPBVFYhQJpVindb1BpUO5Qc1egf7j8rHYxEY57H/DnIYXPCMIRZpfHvrFxQUrsfLSd6J6w/vhpWVmcJQiGNoC2DRO7i29foJ6FHGfFAQHn/xuQJlCrTd26cYWsbfknufSHWOa+V3npI8nJReQVVV/gsI6Ry9pGLal3z3oD7I80fkT7qlYfOXNEU2nMfLFOmibSTgXZ0N+qbDBwSoRlyRK2fy9ddwKWmteBIg1m7WB5lxU2m2VoRwmmmbKUxJliCu8ox6x6OqNNScgeT9nS+epZxucYdTHzZ3pu9GlbIQPmZPVzyMRJuhH3Boo9URNRasayAB5kSZSC9K2ZJkHZQqrsPBY3t5/7ljP19IIIX13hthJIyHEtzafZ6YaowvFTo3SOBRUYbTEJUCms2xintCg5S/UE8PjkWvM8TRVXK1yFer5X9V1oorWfqsWbI0fJaQInQjA+1BUcnmveb7/ZfVolIDxj/JPOCdngTNQiVInsV0vrUcJ37KxyKjr8jKe3GzKNu8EdrcQJ6dv4U3bWBxZoX9i0wQL49KoWIDAWDuv3hGJ2ZTFrwSfYT3cowQAklgRm+xsUtBEUOA76nIJF//Izn9d2VxedY35ApIiOcB0WPa3qlDDOYKFuFl98QThKe02mlExVmcvYiC2+p9aWmG5GI6h666+h54IFgBFGlyey1neOOXnnNTb7fo2cOhEezchOjjBWNlKeNmbplSL+qY9ROvKEMcgsJsZweKT5C7am8ruxX24rKeWa0tSVP0gaYiBCwS1NYtCDWB0/XwacMDMt239A2ODMYHS2eUCIuEskbod6LtxoRg6jQhQb2/+Ek
 LfrWcixj
 bJSPm1R3kup+5znDbw4A756zB0LRhhNi/SfoPtkdkwoazL39/1yS8cVcnJPySB49AvaVOga3wpMOq51ehbc1gnPQq2ng3XNJfItibVjyUp/SbGBlGnq/xAc5ZE7GjEj+IuFKv1bCF/7cwzjAbxyu/7Fu5m+6xbCkRIbNMEWjFF5SO15lsQgrLd9DhrKVgg29YT/N6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Note: the akpm-mm/mm-nonmm-unstable HEAD 5b8dc8b45ebd9e7f3fea3adefeccd9ce94215103 builds fine.
>       It only hurts bisectability.
>
> All errors (new ones prefixed by >>):
>
> >> liveupdate.c:21:10: fatal error: errno.h: No such file or directory
>       21 | #include <errno.h>
>          |          ^~~~~~~~~
>    compilation terminated.

I am not sure what needs to be done here. I have tried to reproduce
this, and every single other selftest that includes standard libraries
(most of them) spits out exactly the same error.

Pasha

