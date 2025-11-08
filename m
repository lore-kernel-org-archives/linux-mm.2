Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E5DFCCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 18:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C2D8E0007; Sat,  8 Nov 2025 13:02:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6543B8E0003; Sat,  8 Nov 2025 13:02:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591678E0007; Sat,  8 Nov 2025 13:02:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 45CA08E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 13:02:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F00AE140818
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 18:02:10 +0000 (UTC)
X-FDA: 84088208820.03.07B645C
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id DD88440003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 18:02:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AJuCaMli;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762624929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+GWnAPZ9fJcziaRXd9RH/lv4CcYCp+R5b37Pg12ambs=;
	b=p8AJXAcrSb9lZTytaBC+XUsnys/KxVpiNrb6auW66RNWQh0Ly+wLVPO3JLrqY5A5ijztcp
	QHXdkdoRL8c7HkZXHemMBJlN0xBVrYNz+DqFeLTWnuDtOYcZc1iVgPOmhpKs3pL/WPnPFo
	lBkKZrWMVUTo06QBjBIGsyIwTJEQqLc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762624929; a=rsa-sha256;
	cv=none;
	b=t07wX4Xesbo3nXaJF4p8QhMQQyOwxVYJEwmJHYkyCBlYKiG7Iw91L7GETTmalhyIFcchMj
	7hJqn/7SunAsF0uvwzLKsidL4rHrxv4UfxnauLmLeO7Qe5nUlQpMcOnNePQYkLPaG4EnXz
	89OW0RdLdosM5scVAyvScmmJ4FuKgRs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AJuCaMli;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-640b0639dabso3141152a12.3
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 10:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762624927; x=1763229727; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+GWnAPZ9fJcziaRXd9RH/lv4CcYCp+R5b37Pg12ambs=;
        b=AJuCaMli5q6lxrHp1IUUgwucdho5PhpUPSrkA1fWdPb0ToU2eky31XaGpPeuqUZknI
         yVZUiyO1ajTMoHzlC7vwccStEQsyFx6MWVjDFYK1zAgdLh6mU6uKy2skvnMUXoMr/lqY
         maFvTEsojNG0hQvxmDa+i5T5qS28z92s/9gDkIVg+rdTwEqa59BgqBkf/Y9MsVMohPAn
         /z26Lun8C8AvUyJOAMnh04T6cXLIqtN7fJqxC9EsHdAT97Hne9YMpMl9+mRGQ5AUgeQA
         p9QPO8wh+Go0IOp1T6MkRsg0GbHmgMsc1uQ8/kxxeB3r66uqJtnw3hxWiNU/HVRr4xCZ
         WnTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762624927; x=1763229727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+GWnAPZ9fJcziaRXd9RH/lv4CcYCp+R5b37Pg12ambs=;
        b=Qb+uFO/slxf4QYgevu9O0PbJp26ei9M83w/RcCofVWLtWHRhj7e2XtdPH6UMlNUgWO
         HRnDusPSl4FeZ5gNXc48ekhdVd5gSNIZIHH4jYp7W8j/mzrwdcweSo0bWtwHj9jGAZPX
         QfpiIbbcgcFG5nrQI0XuPFVaVFkE6en0hSrQC2mQB/VIxk2g96dc6VW8acZLQh4Jks5y
         7AE3SxjkGsBAKfqNCO9PNB8MPXMCdRHWaPrNMpQL7nnGbzHGoQmKlEvJ7uSjRjnBYtNV
         3JLAPrjMa4QTQFvgjLQDjHbB+sJVr13LLiibCDRAAdJYvR6kxAH1o6b9R8lftBHzelas
         3WTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWyoTeQ7mng6EyuVkK4YqL9cbae8tgnorzLMXOV8b6eVfxz1C9E7qOsv410X0aFZH+GtVAHPGrfA==@kvack.org
X-Gm-Message-State: AOJu0YxQb1SDwvUp5ndcAbvpZeLw1HBfvMNMXJWDWCGO/Hu+OFm/KLbs
	XtSr6NhPi4i8F8qbjiYCfXt/1/E5Gj8AnceGg/Ze385Kx9EbuXwwIDaN9GUYKWGAsmhl7IV7h2W
	owilpjn2gZUkbTD5pkFxvx2JGS0WBxw/w/KTSohwzgA==
X-Gm-Gg: ASbGncs/vB7mUN6KmBtD58s7u8Llcu6+3PwqfSNom9uX6gD63++uDNauNBAt/zQKw9h
	m03YB06Newue8X2hx33bA6dz703WNQWZPXBuvz7Y1KamdJjGneemhLSEPg6yZcvCUiNMgaf7N/i
	c6jkVw/bxV0PG6YcJWOf1rXnAku+rE47qSkGTUDK3+Yd1SuIi3kz97ixsQF0Xqu9MevOTMhPawI
	ohxIz0Y27oZND5xtrRh4ROrmkc90lBmY1WYclvrsYePjzUwY/W1+S5b88VnXvcmrksHgqCqLmN4
	5anRulCKcKukBIdq1It5rFYSrNCRZ7bh+mZym+8=
X-Google-Smtp-Source: AGHT+IFsBU5ndj9huagaCxIuqQWmECbsaAtYI+vyGpVvxucw0lq5Q3fxfGJV+B8R/tEvXu8DaclLEzTrS4Qfd5oPG4I=
X-Received: by 2002:a05:6402:1e8e:b0:640:9aed:6ab6 with SMTP id
 4fb4d7f45d1cf-6415e6e4832mr2571858a12.24.1762624926681; Sat, 08 Nov 2025
 10:02:06 -0800 (PST)
MIME-Version: 1.0
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-8-pasha.tatashin@soleen.com> <20251107142304.6d22289c96023fbb7e99464c@linux-foundation.org>
In-Reply-To: <20251107142304.6d22289c96023fbb7e99464c@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 8 Nov 2025 13:01:30 -0500
X-Gm-Features: AWmQ_bmRKs4A_xQMqsLqTmPYtgSzWfjOGsBbh71PdYDaXz1vtujo3t8KJ5u4TWo
Message-ID: <CA+CK2bAvh9Oa2SLfsbJ8zztpEjrgr_hr-uGgF1coy8yoibT39A@mail.gmail.com>
Subject: Re: [PATCH v9 7/9] liveupdate: kho: move to kernel/liveupdate
To: Andrew Morton <akpm@linux-foundation.org>
Cc: brauner@kernel.org, corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org, 
	pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org, 
	yanjun.zhu@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: DD88440003
X-Stat-Signature: 9yj6mfsshf33m4fh4stsjdxnpmwa1hdp
X-HE-Tag: 1762624928-657087
X-HE-Meta: U2FsdGVkX1+AA7iJnHN32tl0/21VsBH9ywIqncFeVthFDkqemCt7JM5eRl5XQAi8aK4a5D3ODsiVBq2nknctIJvUnXD3+KSahK9strtn270IUIMOAoogUucLtgKMI3QLFzhwOnZzGSXbpEfkwXflws2cVgtXTBZPUjeru7WDaBAjprK2slZR374Pke8of5RWfXzXlqQAK9X8OUfKO6xglJ6ciJW6af/CkAF17MG5m1w3wSP3PoJp1PdTvtZ/Wvc5owGYMf1zDyBu6KInjv4Xu8CNmBR8lbXqLKDJCs7Z+cCO1vxjEVNvGvugdSS7DN8+JVq0pA0EWqlXzx/0GWxf4y9Rix8d7fkmAHtdv6ONyE+R/dLkZGOla5RQus1FNDEhsFpRCIhxCCXWTAZFZqJaWWWkBnLQDvbV8GX3a+VCmw6b5+Sd223Kh0HeZc0iW5opwpW3x4LSKKJfmmSUajlgP/3KOiY6CBtF87GZhG9YAxBMn2ghUV9CG/3ZLqvNnoiSwtDWflKI8WkNUa/dXCYK5sYj75j3OUm2Y68rVLXgODk6aEhu5R/8QJOzem5XoDFJLnhZWJRbjiIEEJ5njn3JUg9OQNYdoxbD4y4gvolczKNAYFJmn2nzZSb+kKWg9+qxLtWrUNq4lhJ7Div1OfNFCMV9aT7ISWT/iOGsn+ghpdBXAXX3BzKHXwcTkCNe/cv6hPP5XpLx1jHRdlv8cj6Lo0MJh9Uib1a4Thmi06qFKaIxSRLUViurAY5F04nDBj1/zWTdJqNikH+vGFT+Fl/rid9g4V4e4REAqwNxu+I36ksuAH5tPD7ZNBqWI7nIdHRPGbUxdR2+0JF9/AI7H4WeCWEATvv4xXgwWrqVd/IJF9sbwRNdxVMebqr7YIfu1Nov1F5uMJTncMtTt4kKIdl1vEDzQEUwHa598aPQ8zeJ5MgSGvyK6GMFwHy2zGK/8v5/QuE9DTb+TJQJJYnYGVC
 uyckWeTs
 GE9y2R72ZNHnS9a+P9AUXG/2+qHhwV5UVWvwnrrebFL9NVwNHia/AFcF1537w6mEY6uuD7PYyWjFVtJOmPTBT0TxUfozsg2pLLxv1GnX6SQJGYdUxPX/MxdSKDcoIdOCZhFflD6cY8giw2O0RoixHTaX9FF3/wCmfhVUhNuARTp4vbn3jIHzz2gHZYC8zj3emYjfaNl42vigen933dXp8lzSMpYnUUJnBVRKRkziZaOq9zNHpFaOC0P/RZ6qeIR29J+wnOSTVHKhFLgMjnm6ETnpZNMA+WFTvyd8XXGVs1OZdMsZCSsgfEvNT8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 7, 2025 at 5:23=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Sat,  1 Nov 2025 10:23:23 -0400 Pasha Tatashin <pasha.tatashin@soleen.=
com> wrote:
>
> > Move KHO to kernel/liveupdate/ in preparation of placing all Live Updat=
e
> > core kernel related files to the same place.
>
> I notice that menuconfig is a bit weird after this.
>
> The "General setup" menu offers the "Live Update and Kexec HandOver"
> menu but there's nothing in there.  If one sets
> DEFERRED_STRUCT_PAGE_INIT then things look normal.
>
> Perhaps we shouldn't be offering "Live Update and Kexec HandOver" at
> all if !DEFERRED_STRUCT_PAGE_INIT.

Hi Andrew, thank you for noticing this, yes, indeed it looks strange
when empty. Let's disable the menu when DEFERRED_STRUCT_PAGE_INIT
until we relax this KHO/deferred init dependency.

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 054f6375a7af..d7344d347f69 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -7,6 +7,7 @@
 #

 menu "Live Update and Kexec HandOver"
+       depends on !DEFERRED_STRUCT_PAGE_INIT

 config LIVEUPDATE
        bool "Live Update Orchestrator"

