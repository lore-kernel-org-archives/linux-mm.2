Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4222ECCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 18:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E60F8E0009; Sat,  8 Nov 2025 13:14:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896038E0003; Sat,  8 Nov 2025 13:14:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75E0E8E0009; Sat,  8 Nov 2025 13:14:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F37A8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 13:14:13 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F28014B3E7
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 18:14:12 +0000 (UTC)
X-FDA: 84088239144.18.75EE49A
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id C979F4000A
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 18:14:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IkT+3qNN;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762625650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Q3WFXvp3nzw/xfIhFbqypMckNDbnX8ReX564Qc9Enc=;
	b=bN0SXQuyxcz/08WmSvxQwFO0JrqwtxYV+d8E+rQTU0bcAaX5o5cWXwojt3qJz2oZyAVomm
	3v8S754qm5LcMI1J4abGGJ711EKFtgOMfdu+Cv6yxjAgLXWt8hofW6WdmRPOLC7F0e4IZn
	5FHgFxkzl/ohqJ4Je4rm1MOR57QtazE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IkT+3qNN;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762625650; a=rsa-sha256;
	cv=none;
	b=oB1zHV5CbpOnK6DfzYJh+bCk5ZXeKornv/mE3btY7l3lCqZZN7KFcslb8Sr/jANbeuAmam
	SljYwS+kU1WJtZwf3lQuHY+T8o1nsJ2NcxVYPLSLgPwfhiWx2ALBTQs5IE8qqh7gGhj+Z9
	K0ScCTn/LLUKy3kWaJAOPZfvihE/mNI=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso318529a12.3
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 10:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762625649; x=1763230449; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Q3WFXvp3nzw/xfIhFbqypMckNDbnX8ReX564Qc9Enc=;
        b=IkT+3qNNhEo2k6h4c+y/sUdS+YOfSmekwBED3waTZeZ1qEAYHtlu+pFzr83vCZs+1e
         PDFca98DUVfpL+TosROq7Gl178Q850mSEoPzZB4o/JlLiFprBevaGA6LRAM1w+iw3rq4
         QV204DVjY2EHmt4hj70KM7Y4HS92IC02WxBNdVM7OlrwaiqqPW8O2nkeBeCpvbxVusCD
         b+ExVlDPWDoyyi13RWQahcqjWaXHjjS91TuJxTTD/OFXerdGsH4fDvVgQ90ecgth6AUP
         PwS5jS7RBtv7uIoWICtpGCaeGaHH7Zg7XTaG3tOZvQOB0Wq554SakQfaJ8KB/tCOh1TZ
         PHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762625649; x=1763230449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2Q3WFXvp3nzw/xfIhFbqypMckNDbnX8ReX564Qc9Enc=;
        b=rgob0HSLzYq7bTRy5MQ/k2K8/i3FWyMnQ7c1XjlqW0GFrmn0Ds2uz1Cqp/nQWnHEgM
         jimap6xsTtstObaoW1rkm87fsbZFWiuiNaB3oNTT3hoQqOTFOShX9E40XcbPBxSGOtTE
         w7eP7dXgFllWCz7h2oqoEuEqTrTbiUkUJXss5RjXN3bkmLpB7TVuku79sCVMXyX0HBnt
         Z+4x17crls46u5O6kTtUZ18zpTYdSzma8XH45ldbj04w64gjDd/OhFW0xAGU+VxJCeFW
         7rlPnA5qNxc2r6XeUbWemfkeJO4AcoBnGEFDchonDD6hgmVuM5mXK36rjWq58wGZ+BGT
         yK3w==
X-Forwarded-Encrypted: i=1; AJvYcCXKHhmPM0DyW0Hwd0K1KrhRegzSLERxoPT1iMFF+N2oPht2zE88OHaUDYwHfdDS1oVzfoynHDOBnw==@kvack.org
X-Gm-Message-State: AOJu0YyNGX9nRrXEUKx8MVxRuFGvODfl8QDan3aY0VTNWYGZdoWN11lB
	If4eD2/JsK8JtK7cUwLU2gfo34jNzuoBvdhxX10tv2B5vwQz6K1k8m2SzH+2CEO03SQ8REoENZh
	Jvp1Q1FOb6w4C0UkzYjO0iNfieNJ5FRHC8Qr/cI0LmA==
X-Gm-Gg: ASbGncvTtYDbEA88R2UDlP/E2RM8kUHjq7mtAWs5XPtOtf3hlnDm3gE7wfaTezY9s5w
	KsvbxD+JPFnTlKTq5hy6O/ZE+CIZl0qX0zhBOrWlhGjesquMExBjuc8KCXx0ISbDBex2n+kc8jB
	1fhl6H2M+dX6JonKs/Hoh/s3mMJl7zwyu5DFeNaRWJdxxZUJL2dgjXLy6f/6dhE5HhplDKC7mb+
	4MYEM04Ql9ex/bGxypym0sm0/wX5Q7UJxJpiAcht/6UPkgbQXi01dbBXc0ATy07RjzH+qY/cEHG
	FDwR9y8iJqM+slq5Fm5pMjRfXHxm
X-Google-Smtp-Source: AGHT+IGnxIvGVB3DoG73/LoR1IZOJvd+jikoooj0blQZKowrXDzv2ZHuSFpnulnp2McWHadhftCSnlvUuIh9AczGGLk=
X-Received: by 2002:a05:6402:280e:b0:63e:405d:579c with SMTP id
 4fb4d7f45d1cf-6415e83f02fmr2267675a12.29.1762625649247; Sat, 08 Nov 2025
 10:14:09 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com> <20251107143310.8b03e72c8f9998ff4c02a0d0@linux-foundation.org>
In-Reply-To: <20251107143310.8b03e72c8f9998ff4c02a0d0@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 8 Nov 2025 13:13:32 -0500
X-Gm-Features: AWmQ_bn1c7HhzSfiUpQMj3X6qTh8tFK5YjykAbxye45PZog-6bB9QqhpzjoyA_I
Message-ID: <CA+CK2bCakoNEHk-fgjpnHpo5jtBoXvnzdeJHQOOBBFM8yo-4zQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/22] Live Update Orchestrator
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, tj@kernel.org, 
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev, 
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com, 
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org, 
	dan.j.williams@intel.com, david@redhat.com, joel.granados@kernel.org, 
	rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org, 
	zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C979F4000A
X-Stat-Signature: 6gqnhi11seywk8xhdb3cqrrnbui8ugtq
X-Rspam-User: 
X-HE-Tag: 1762625650-114666
X-HE-Meta: U2FsdGVkX1+DqM7o3bhWRbZvKZA6gs8ZMn/szduKzQOcZyke+Td14YvRVJlJYUuSkHTp1a6vfz1GSrQemud2fR7HOxECIAaqfoI2wk9PFu/fc7H6RY+plRoJPdK8K0MXV2dmeuA0o9OFm8JqgRuo2bPDwHFFsRpCk2NhofNQ3L2EN4uBqQ0Cv+G7RaeDZ4tTPwCBUWufo4uv47oS5XeYo1Nd72WPPVlGarfj4qFqLZrzRdexAvs3QcjJTbuth/BBKYG0UMZNVOV9OhhLZXH//QwfcE7syV1LvLsRHFwfcT5zCJvwe62CtxcGAQFjOGZryel/22PwM3kNUJKUQ2OhJ1m+nrOfjpL5z2FHrYWd57xh2FXYQGkqSUnAg6XsrAcn5mXeb0x+BkM5mQbuqX8DOoJtU5yX0/hIhAqBU3WdfSmUo4y3bZ0urHfJMMPLGj45uhjQYnC/psXDO460C47TJ7gmLRO9nYGWOmiQ2Xjz+wVGApScfA0eiq3GFPCplr5cb3TinFIe3zBLyng4qUJdrDOyS6EGEKDogqS+Sj+AtEWOROA6Hkb0kH3PEetBEc4llWFy0+huYURIz1qvbd5DfXB2Vv0hJ7Fie2M0FY2BfKXKQ2v/eAoXgbi524g6VsgZ6vM7qcpZdey7njycamWJfUpWN9xNCGD3cLQaljfCdDEi9NPps/IQoByuNyovyuavCbwu6PDYFeaE9bn1Kv3vOWRQp4mA8qEexmYsX8GFKxInKTKLAheJ/k7u6yHKH4RKS1SyP/cWCMpoIophPY28qmfN7qciwqQch+xlyRAjSTaIjl6w7htzk3SHHsJe00r7YqWnhNHL2uzVeqxZ5mhPP1JCH0DCWWiv8frRFMvB2o0GyK/cQoOv/AxkmVn5nSdRECfbjmEsMY7yNQpvgZnCPfnYtjep8jZadlnUOgN17B4Z5wWiC4NiQNv5KF7NKIVso017r+l4G5Eg0bcsObF
 MvUU8PUN
 fFStoDxdAd82jACFHpiLQuPPGhDYbSQvvQa0q+GVuBMQ1lQaV/VE0QRHNSAaEf/hClL1JyY2eLbFeZ0j6esTAM5loz0QEQAdEoDYkvFSDTcz+oxx6qoyedWqQisqiMaandDxEvc1AtgvYYro+Gj/X+DyV+U881aeTVQY+NBVedwyZRsu+AjPe4RhSaCLs7244JvZoqDaFI578fZxuI7rKqlwbW3igi0nlkYhXq9o1WDb2RgTlZCb2KRurO5jgdSXRXWHnkkc2SxD6XtTKcB4qYdcmFINrfkLpboavcPGL3x1yh0RY0FGjztqbDR5jB3PuJDNTBVgQ316g3RBqgM+MdiPwB8ihkze0CVqhvwfjKYrJ8NKmwaKLjlQg8vv+eJJ1wCVl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 7, 2025 at 5:33=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Fri,  7 Nov 2025 16:02:58 -0500 Pasha Tatashin <pasha.tatashin@soleen.=
com> wrote:
>
> > This series introduces the Live Update Orchestrator, a kernel subsystem
> > designed to facilitate live kernel updates using a kexec-based reboot.
>
> I added this to mm.git's mm-nonmm-stable branch for some linux-next
> exposure.  The usual Cc's were suppressed because there would have been
> so many of them.

Thank you!

Pasha

