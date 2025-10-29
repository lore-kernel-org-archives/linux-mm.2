Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17B34CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 21:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043118E0104; Wed, 29 Oct 2025 17:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35018E00B2; Wed, 29 Oct 2025 17:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4A0A8E0104; Wed, 29 Oct 2025 17:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF1C48E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:18:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96F645A4CB
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:18:16 +0000 (UTC)
X-FDA: 84052414992.17.C541FA8
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id A409DA0008
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:18:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=D5ylxt2M;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761772694; a=rsa-sha256;
	cv=none;
	b=acxBcDqrZJr8yEX4sFe4L/8sj9mgqPb/iRyANR4df4tuZmjdgi72N6SIT4cEbu0S8TLvnF
	zLtkkTxtU2fK7enKuh1ZbTrDY6viZXkCcha9CrQsRYTAEeti/RfgtezZSUq17sWLPSjjnb
	H2BbIdHk30yQIqKqvsK3nTCAOpOL2po=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=D5ylxt2M;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761772694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yx7YCqrIwLLNoev+bUFlTb0b8ZV7lL4i+OuQquokGLc=;
	b=GBWKNtggSSlJs+UtdXXs6tBsqazoI7aTMbnQ2QzapO800FUKnB8SxLilzfQYz42IYwstvV
	Vplv745guedwHwFUaQUgeXXjQwVqv4F91MtJ7h+3KA0gobS+l9neLzKw3IyXIs/VEnV13K
	Qtw+FM740WZeZGix4VyQdV1qiOmH8fo=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b6d5b756284so83631066b.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761772693; x=1762377493; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yx7YCqrIwLLNoev+bUFlTb0b8ZV7lL4i+OuQquokGLc=;
        b=D5ylxt2MW1eTj8ibSxUiQAhu0Stsq0OAgrxOqUZcA3M1dPlPqLHG7X45tB7tBUaZvX
         FD7LylXtGhsG/b8I5kzEmt4lVl7oPS6Zy4k7vQ/sAVwo37a8dV6DQc+1Aig0/ioKzBFX
         zYnNAJEuMmTIm+QZhDoodZIKLna6JoKd5LY9jZWcsuhWsB2ef6s9sbTbWiITrDldmgzc
         CYao9IT8vBCX24zMcxuDHOqKx8N2kClqC2ZwLyGHujtucpxHBFqJXgnP9SsLqz2UdKpv
         YCHSE3Kp4T8Eg34KVHQemcwYL7bgc0WzjhGrVKx4DdJ1JpEiVzjlZyFbJbsYtkF3fBo3
         p4nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761772693; x=1762377493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yx7YCqrIwLLNoev+bUFlTb0b8ZV7lL4i+OuQquokGLc=;
        b=YbbnPnm063YUSUQ6twnB3N3Nwnyoqn+2gD490mVulzbUOUb20ouRQ2kVSxWiziAVws
         jewWIuJS9k/SySeMc7BPCu2dp9SsN26jlnEz93hWZiBpE64DPbPDtkn8Q2ICRrmpWSlu
         MrwcVUY2o/MC6+fm5pAMuAOxgw3tAnlRkwZGa5ZtdzIHPRzvyV5D2MgcZ9J+Nmqe2jFS
         0XC8MpAQ9pWDvvJcS4fEeGiS4qBTXN/sN9GydIQMdZM+4ZfH1WqkezQifHYWdRU9O23q
         1cQLJ2AMZ/qz70W64ELCcFvYOUD30K7diIiM33FlfUxGdrvl93kW7JTN8kH7PUXS3PhV
         kWhg==
X-Forwarded-Encrypted: i=1; AJvYcCV8BbW48F3/QAGg72vd0qf3+6UvB/a13SU8jP4fpf27fHBE8vnlqcym0p3f/HyXW0/M0DqpI5gw9A==@kvack.org
X-Gm-Message-State: AOJu0YyMBjCN/qSDJYUFOZpWI7AaDZlBFNyflipd9ezBMYfYHBu/goAm
	+xbZfgepeLeHvxDBmZleHo/XQHS/a0qLsIELp1GPeGrRP+SD6NQLYJ/9sHhTopTFbUL04XwuzQ4
	Usk1NySl5brTJqHnW9JEjL+jptstmXB1DX423kDadXQ==
X-Gm-Gg: ASbGnctLgCjhvGuSMOYJ21K39PYSPWRv8Q3qhZ8l4Rnwt95gBl28Z97u1p+uioymIxQ
	j19e1+LUcV9JKJMXnu/794jigog7KpGFlvDc0lVwyZlb0/Z0RXRHhAuFm3YYf9w3/WGt5xiPzyS
	wL4Q1cWaw5hSeiuJUSs/tIsGhd3uMQDkak70iowA9NNwfYGwixMkuxMD+FW1UEvYaE1j4Z9WuPf
	RkeRpbuGnOD+W1V/dcOFQQGOLkcoSUnVpWiNK2iKKf3Z6rXTk9YZn89jA==
X-Google-Smtp-Source: AGHT+IFiSSmBV0jU0Ss8+B5QBA6lJtv5vF8blJP/ha+JWFJmpNgyZxdpZA+HlfE38+Jb0bhjX5O65LmIxIHlrRfKiu4=
X-Received: by 2002:a17:907:9721:b0:b3f:f207:b755 with SMTP id
 a640c23a62f3a-b7053b2a721mr51136966b.6.1761772692799; Wed, 29 Oct 2025
 14:18:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-15-pasha.tatashin@soleen.com> <mafs0tszhcyrw.fsf@kernel.org>
 <CA+CK2bBVSX26TKwgLkXCDop5u3e9McH3sQMascT47ZwwrwraOw@mail.gmail.com> <CALzav=frK48c1=nsbVJ4EvqqOqr33pUArP4G17su0hxOYveALw@mail.gmail.com>
In-Reply-To: <CALzav=frK48c1=nsbVJ4EvqqOqr33pUArP4G17su0hxOYveALw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 29 Oct 2025 17:17:35 -0400
X-Gm-Features: AWmQ_bn6VS1Xxu1QPUMyT4niSsaGvQIJZtr8QMKM1ksd66d84DVSx7b_KujGEQk
Message-ID: <CA+CK2bDUDryK6xZt5u-cMv+eR8ZWC82Phu9F2fS8DMnac5ritg@mail.gmail.com>
Subject: Re: [PATCH v4 14/30] liveupdate: luo_session: Add ioctls for file
 preservation and state management
To: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1cgwn6xz86urajkery8r6nzp76ucb6zy
X-Rspamd-Queue-Id: A409DA0008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761772694-636758
X-HE-Meta: U2FsdGVkX1+RN1fWkGtdKMWgQQzg/oq32LKUNie/tZS/QqXuLto8jUMAgZQoTX9gTERRlOlch9To7xBaZOFIFBdV1rzxPauw0jzk+pb78pIvy4t22HKeZVCOB1CDNR5/ec8R6o4KqCe1tDWGQ3/538SdT+dh8z7QglROJhlwBiOEPJ1l32eL4NDgAjH7vWjoHSf2ByKCqu0B1bvQ8Zg5D6QYlUkj+lDGKwwDZdX3BaixHMRKxIQDrStbZroOnNaw5iPlx3mOYKn8B1wbgHRuk/yYR08SEetaj0sDXmAMsu0s30vQl4qosYfqtwifhdRE/zbo5OgvM9IMhlDgxNjHWSiC8fgz6MidFgIKTobLt3PVlWZzTDSMtBeHFi+97FVxlTAxaoFLo93ndqU232eROZtMAtW78ZWNy9mcro6mBlwfWBd1/Ht5R2EbXOsaCkuBK5Mfyi3qChM6lH38onELeM/h4Q9dNgeJu1Xvar3NZhlwBsPxm4sIXkcVNd293r04i09M6Qewb2FynXTplqbEWONHkzyI0nycBjNtqxWJ08MqQKSmeK/44cvtXVCvPpKr4CrSk/mGkF2C+MhMswThELYLUD5I2zMthjo2fcHV6gH8HDBFMIvIlzCeHka9syGBC5O5zNXviT6T1veOeTih3hSmWjSYsn/n9HQk+ehGC5+G5LD3DbEuVemILgbrAsOZYFnCbj6wBPqYSEunalOPn0axMj3vg8tnp0B/eTBF3bz+SPL6sBrROpcE7MFz9heUxKG9xvDOguOubVY1ykw5qkf/yy1cAaRlrZuSgKBQHZa9rIdGUrPZSZH9RrXqU5Slf+Elq8vEnMNVUg5rkNZhIa7Wq0yJDuIIDr8f4S+a1hBT72zJ0w+bnSSUV2bqntEJvH8kmbmhrgY4b2+9JJOR9vx21SPESxV8tyRiKzF4YodoLX2/BXR4+HAZWvDVXNFtWDbbhYm+fP/iYK3T6um
 mvgcYlC4
 pFcEMihznc86Z2S/YmBUgLmTdAzZUrnW+hJd1eTi0DwxZKclfFfFpYokx2bgbxYWznWoRzOREWiWSKkrW4T8pzT9bssjw2U+cvELBH/yBj9ZsBCs6556QTEP8Jv0U71Pi6unJOAi6FR44x8I7OcgtuEyN2Bd8ahN38I/f2lklbS5YGJMJaxiU0XIGmmMSgLHg5pjB3oIpl8KWosL0kqRCY5TZimKSh/3toa3kH0Xh4LJk6F3G2pKq7e/qyzOL37U735yAhaun+7Th2yFBvtkWkaRrvvBRt2lRsyhqWUh9BrWamQAFmjYZc63lWWbxMToa4V/Bn1OVkdRJxVUYQLmko1yscJ0DEvv9gBEofQ+vuRqV9fS9AJVc3EkH8JjIb1x+/quOW1HXtB9zsw0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 5:13=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Wed, Oct 29, 2025 at 1:13=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>
> > Simplified uAPI Proposal
> > The simplest uAPI would look like this:
> > IOCTLs on /dev/liveupdate (to create and retrieve session FDs):
> > LIVEUPDATE_IOCTL_CREATE_SESSION
> > LIVEUPDATE_IOCTL_RETRIEVE_SESSION
>
> > - If everything succeeds, the session becomes an empty "outgoing"
> > session. It can then be closed and discarded or reused for the next
> > live update by preserving new FDs into it.
>
> I think it would be useful to cleanly separate incoming and outgoing
> sessions. The only way to get an outgoing session is with
> LIVEUPDATE_IOCTL_CREATE_SESSION. Incoming sessions can be retrieved
> with LIVEUPDATE_IOCTL_RETRIEVE_SESSION.
>
> It is fine and expected for incoming and outgoing sessions to have the
> same name. But they are different sessions. This way, the kernel can
> easily keep track of incoming and outgoing sessions separately, and
> there is not need to "transition" and session from incoming to
> outgoing.

Yes, good idea, I was thinking of recycling finished and empty
sessions, but it will only add complications.

Pasha

