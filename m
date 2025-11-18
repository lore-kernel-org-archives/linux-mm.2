Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C385CEE343
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 18:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80AD6B00AC; Tue, 18 Nov 2025 13:35:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31056B00AD; Tue, 18 Nov 2025 13:35:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D469C6B00AE; Tue, 18 Nov 2025 13:35:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2EF46B00AC
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:35:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7FAD7160195
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:35:55 +0000 (UTC)
X-FDA: 84124581870.12.19D355A
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 733B1120004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:35:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="a57Wi9l/";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763490953; a=rsa-sha256;
	cv=none;
	b=z0YsKufIxJq80htkA+O5NMm4vKTld7+FH8JS60W5HsMwFnRsk+Woz2nheXR7l99caHJS+s
	7BKpKvoF7XWA2RJ5suhkW7xSypJ+hqMUtgDgv4rtnjgqadn2bIFczPR30etPX6/Yp5RUvy
	vFs3aez2UlbS+u4bwI3fhPJHGOXAfhg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="a57Wi9l/";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763490953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RyRTgkSKs87SB8s3jqLkcqh8DAVS3ymL4PEzUKP4wbY=;
	b=kp9ohdZCfbKtoB9SpPzn54bMd+Hg5m+x6GV1dvTtK1zKNXr8bsd+XtHD6UQTb+xcvSY4wJ
	uIJZxpBbzIj5cFNIQnCHiMCBtK3ZDyocCeI7V9nTgXh/3bGkE0jSQ0poKY/nhVWh7r4LMT
	LhuxmoK+b7f/gojyFB/naASfoC/nE1M=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64165cd689eso170166a12.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763490952; x=1764095752; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RyRTgkSKs87SB8s3jqLkcqh8DAVS3ymL4PEzUKP4wbY=;
        b=a57Wi9l/00MRtKbRP4ooKy10PrkUrDjEmw26kyPqmEPpqtsNOQNHy05qusHbmAQZvi
         5zmOzeZwMSaMSsvhygOTrHg7mTAoOOcY5PpccNoVs8TX9+j18SLs1udEKUjbHPkrS/US
         NbEuwZlth8z8O3IcrqhNf8dgszKIY1Y5orFcwfBbmS821zd6rcHyvsElBC+ZAQGeZi5J
         c/xTnNsGc2UuPmUjvilT2qcYKyTe2Fo8p47t8GUNWjEXo5kt/r+cHVMobf8vkoKM54/P
         s76SIlTic8sQ736qrIvksyY48HkO3ccLtJQJt4o9j9QqjabVyDXNoNUOjRe4KLsaJW7r
         3rCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763490952; x=1764095752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RyRTgkSKs87SB8s3jqLkcqh8DAVS3ymL4PEzUKP4wbY=;
        b=Gw9QKBAsgeqpzqyPJs9iV0oM42oeqlhV72npxK96tv6Atcjro5Vt4Di5LH2syf4Yrr
         ADmfR3aJ6yLR5dpUO2AWej/NFHc2n17r+nt4+EzYfcMg2LItccI4Znj5St3XEPynlwVT
         AcP2F7/uXa0/j/ABGbtepyoG5bYp3jolxFlsXg/r4VbQaWGI45DZBxTOwWjWoD/6PUZR
         8e7oWaSUj/voH4ERnVV/RZJE4vJV+gfB7aXnsc3RhZQmKYVRxPy7aW9kjsq+ScBScEdv
         KFadID25HrXeI7YFmhB4U4GQ5vjN9m7N3a35gqdIQOyOmWvAgBY8ebHutN5muQo99TFO
         2ykw==
X-Forwarded-Encrypted: i=1; AJvYcCUwWYstVkWtkCh1oCxW6JCApaaROXmQgfQs+groiSDkh4xrKqlsVWVjsOHvo3HQv6oWNyZI5zgR3w==@kvack.org
X-Gm-Message-State: AOJu0YzKdmCA6M02omrYctqmD1v1J1OJNyjhaJ/p5BFQlUhAW1PHojI0
	qLx2VEyfRE2dvLo2d2KQQAoh/E3lkAyL48bnzbxpwKzDVuJwY0CQAfI68As8vOlYSNJTZroJcg/
	tKGHXQbvi+YVgKO9EmFgEJRxUJ74J2Q3qmQ1nway7Zg==
X-Gm-Gg: ASbGncvSobFn9tsW6WZFh8H/XrbT/S+aGX1TNIEPUEkMwR86jTZ/bKcPx1CArRRWJAm
	ji/UNt8ySJLltv7Khnu6lhevlD+owDKVNkEGFTTpM0EIVBFAWKhPF4VvnDN3QR6BtVGNBhJ2t7r
	O86UlTKcfepXcsOgOR5aI2Q3Tmd4UBbSBNL77Jjtxv0oVsFe1eq5AhlbsyKI3lnCz2NU7xhyRIT
	tLcTSZEwhOJ5P/1Tb9UaL8dFRziPMXjQSxKCvzg+n+LqAJIXits25bxtrik7Z6oNSAG
X-Google-Smtp-Source: AGHT+IGY1b8vCf1fid4hLfUOxiAz8fmDTgBhQ1eRdZ4VYO7oROGSK3fr2sUwAVyfU+H5ZlCd9QfKeCG+BFuDsmYifK0=
X-Received: by 2002:aa7:cc92:0:b0:643:eae:b1b6 with SMTP id
 4fb4d7f45d1cf-6451a78c2a8mr289851a12.12.1763490951883; Tue, 18 Nov 2025
 10:35:51 -0800 (PST)
MIME-Version: 1.0
References: <20251118182416.70660-1-pratyush@kernel.org>
In-Reply-To: <20251118182416.70660-1-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 13:35:15 -0500
X-Gm-Features: AWmQ_bn-9Az87x1D-uqAKwYqa32LAYYFMR57J5R9sIXwHik0qL2mN1dUbKo6LOY
Message-ID: <CA+CK2bCFxMvSsafk1VVQe=uUfFQMeDNtBSkTUexbfvpCeWocAQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add test_kho to KHO's entry
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 733B1120004
X-Stat-Signature: xaqre9n1hhd7etxyag7tqc6js6o5badh
X-HE-Tag: 1763490953-179076
X-HE-Meta: U2FsdGVkX1+3lpewXd71FrkvRg0zHsGBnFm0rkTLZtyhVMtEoptlzP0CS3qJr8nGmDPZhqYo97LmkxJtZh/HyCWv2FG6yPdC8htan3T8LnTeWzwiiCP0wRD+o+W10tbpEioWhJFyhtCfPHpos/VatAaUVfFASc6+YQB8m/w3c9TfNpBJkM7SQUDaYe0ArRrnXvoeID572znOl8Iv9KXcGuJLhgpFCR0jrx1QiSqXzIKXA7wq2RK1n2UIEK/APlDzViOOXBatTAjiyM7ypvweXejlHEe6o8TiUFhF3yBZYpB7UHALN7xdf4hZyZcaKn2LyESSdiEXtarWXsn8bQ2jtrmwpBHwL1tyIhh1DBzYj6QoEceIWPxAOgoDLwtRwejHkSflnsQSK3vcbZPSbNLrCN6R0/0m21l9Ebp4R8lfWPJAI1oW8Q+o6SyvmwFpMp/yat1P98OVkb1nE7azawbaByUR3yzp72yYJd4kTsXroIgwFhnFmrABUTtMfDP6zNIcDV+Qb+HkNULTxkZD6lMmz2UMMCJFwtvanJSvcK1ti3XOYGM+OpLPWj6vAcSVFInXTaajgMtjeJBp/Jb9Fu0pTCcuoAvJeDZiN0DA2zxGT4J1i+dX8fGpsW+nSHj//syKuqSqlzGctfy/YeEtMjKMWcmZrx0GfWeq80/E+1pq8nh5cAi2vc8uY+2R1Sh9BgMuWPTJGLBdctACVVBRTgpi57+jr9lbUJQz5fo+muKBSoLLbtKXrXXJk/cnA/eO8S+2JOUKj0mFq0VAzZ7f9BJNajL3JF9PGZWRz4Z+kroGcwTPmEtZLEq6YHFH6Q9wfG6g7Qw+NIePQrG+qEsw2t2/exmkBJoCXuW4JzM3/2eu0C87UMN9L7Ip+ZONWjAtRQm1QvwzXMWpBgXkGRv4Wxww2ecrIX0aOXAJOT+/KdYbLcmiAgtkIlT8LRugA9QSvR5LGeitsBFDRGV5SXFVxVM
 vIWBApyj
 Kev2A0wEgG29+q4dP8vQbwzTM59dnDVa3kZ+3H0/K4m7c05lhjsB0A8Cy4on5qn3boPosdosXWKwddX3mWBvUrdcUDa0dk1wL7aJjxZ6A1Qx75n9xcBHc5GKeX5jXu6PW0kPadrACoIiMn6ZnFtVg3DnanigVvfacvbmI35LpszEcmthSrhhGfeTSeojM6CpeKeNP32qUMc0jqFuTW3djyUtec6zBeGPXwC2u9H8oKnQkRkavvmtDDySdQY1QSkgC5oYnE9u3eOVxGqHEnYz2RJd8ACSsURlm54SXeHXeq1c7m0z7hMAPpoUwTpUg3of9Z+yk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 1:24=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Commit b753522bed0b7 ("kho: add test for kexec handover") introduced the
> KHO test but missed adding it to KHO's MAINTAINERS entry. Add it so the
> KHO maintainers can get patches for its test.
>
> Cc: stable@vger.kernel.org
> Fixes: b753522bed0b7 ("kho: add test for kexec handover")
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

