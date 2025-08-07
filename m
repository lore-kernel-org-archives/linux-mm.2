Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B2AC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 23:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FFBA6B00B1; Thu,  7 Aug 2025 19:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA376B00B2; Thu,  7 Aug 2025 19:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198FD6B00B7; Thu,  7 Aug 2025 19:07:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0ADF86B00B1
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:07:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A491BE87A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 23:07:47 +0000 (UTC)
X-FDA: 83751500574.12.41F0FD8
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id ADF99180004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 23:07:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GRzWZkmd;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.182 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754608065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BhNQ9xJy5xn+DPyyr9WXvCSNgNgK8FMbQ6lL+dFO4IE=;
	b=PoRlP2HdgeaK1q6mBUU7xRMO9x+XM72WeOF5OiCKmDigPzcL5dSwvWIyfG/YD8JHA5b7gu
	UWEeTkkRrfwpxlDaNQkOdRxal41Z2YNQ5shibHmnegihcSRNUzMQL3FnwqI0Yv2Rl35xTf
	N/hBOYdj6+wvF3Wzsxml26tamTgHfQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754608065; a=rsa-sha256;
	cv=none;
	b=Cxl0XsLqRnOy0uY7PQTHm+sgN06UPxP1Ez82h1R0i8vHI7pFoEbt9qbBiEhc40AMmxj4n/
	95F/MPrKLGcAeLW7sLM/2jHQINiGOGxjeH/S7qZ58ixOPu+0XH121nCW/beNxySd8YhNKn
	tCUiuaSRsocqXuvR2vjC3GpwKTNM3+Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GRzWZkmd;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.182 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3e5172e496aso12210745ab.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 16:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754608065; x=1755212865; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BhNQ9xJy5xn+DPyyr9WXvCSNgNgK8FMbQ6lL+dFO4IE=;
        b=GRzWZkmdljr+DtNtfoEj+yUxDIWnrd0vBk0iRst7OGKwW8GnRhHNgtr18G8H5JlQFj
         3JCe6JJcZzfA0qHKadpJBeJ0RuYMULQe1skitSd8V+PyjAQIRr7hcj6mMLs5KgO2obBe
         fdeGxenNWyRlTUTVCb9byHI/Nh0ilPb0lG61Wle560dT2NFwj/BiezO0BMaNMPlFqDaK
         dt22ZDR1ttFbJklpxkjSoaYXs31++qHAmAkFsYT/hzMZUmozTdOUaMKR4yRi9vckVqyN
         vP3GpP0fq9d7AXlMyejRFYldBUE27k590fW3+zjCZHEmJ/V0H3jnq3V3W+o3uMrW6XpF
         s+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754608065; x=1755212865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BhNQ9xJy5xn+DPyyr9WXvCSNgNgK8FMbQ6lL+dFO4IE=;
        b=J9WNxoagA26snG5SO7qjELL227Bv83GgMURfKvc88U6CkN3E2zs3SWsjDXe+mibovQ
         Gr1wKq5Dws875Z74SncofSF/cWCFwdZvGcEH7k0Pvbvs3C/Gbr1iI3d/DgrVyel56BJ5
         8BCOb8aseM7T5FBm0td+aHz7619Kalp6O88x83lGZqpPKo58rqK7wNv3CGqCeiztzvyJ
         LrN0EdSwBaaC19T/BalBXp0/IzpdeBqCj6oPY/+lQwOJn7V6P6pKcSl9LiY5igiZcbqZ
         q979f4ULXmh/MuMEuzZWcRUl1cDXNv6B5wSWsF0dPxJ51OE+qth7JBzANyqNXOIuGjeR
         g1/A==
X-Forwarded-Encrypted: i=1; AJvYcCXe0rtUUoCrwILDG6uq2zWhteIbYYBgccAaZYZb5LpapykiYNdVvpHQ4xQ5C4iwbCpP1GKEyyILPA==@kvack.org
X-Gm-Message-State: AOJu0Yz6gtHxI4e/79MYq1KK6EZh+H3+Amew6Th02IIMIwc4q7Rr2LpD
	Wzfyl3/mYG4KFOWPIpfiKsTODNbbXpZw6v659ITFLvmaLXbRoV0jIJPicKTkXaT5P/WBBlke0+5
	i1MePa/JBhxlEZAk3QARFzmxRp1Z7p1Y=
X-Gm-Gg: ASbGncuD9dsXUY2LAH1AfFLxUj7aAjWBloKMqujeXc95EZdph2HTtqz7FkYUG5ZWovC
	4qlabd7CB3A0xu5oseuV29OoV6EyGjch4Tb9v7co5yVBPorA9sTWgjt8DlfbGiMIR/QfNAejo4f
	QJNZoNkoLsP6nkiFHvnwrx4lBWk9KqHejENeoI/wufnNo5YAzb29MdfoD8p8WAHITh3zMJX/KhD
	1hsYlA=
X-Google-Smtp-Source: AGHT+IFhT/nELws1H4efWlCkKDQExal3VxPPXLzPIbDMDwCDFzWdcQqpkx7AXapd2/WvXY6jfknx8nFn9aWyZghwTtg=
X-Received: by 2002:a05:6e02:1d8c:b0:3e2:a7a1:8cd8 with SMTP id
 e9e14a558f8ab-3e5330b5f84mr18805355ab.5.1754608064682; Thu, 07 Aug 2025
 16:07:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250807181616.1895-1-sj@kernel.org> <CAKEwX=Nm08xZVR0Zk2fOvXBmeWe5wggvTXN6+hD84S7T9L=eBQ@mail.gmail.com>
In-Reply-To: <CAKEwX=Nm08xZVR0Zk2fOvXBmeWe5wggvTXN6+hD84S7T9L=eBQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 7 Aug 2025 16:07:33 -0700
X-Gm-Features: Ac12FXw6bzCKUP-u_ImjsD4KRhwoSPp6872c06myHjLQv0GtAFsnmys31paNWdA
Message-ID: <CAKEwX=NVBVSFrUcJ8ReN9UqhsN+rr4yMqp1Nu-7rnWK_m+Lt1A@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ADF99180004
X-Stat-Signature: 6gh4xsni7m5h77if7er6h7pcf9sp9xaw
X-Rspam-User: 
X-HE-Tag: 1754608065-786435
X-HE-Meta: U2FsdGVkX19dakXQD6K8ARqJELhzMMu2+P8/taglkoopNIBSqbzG7g2edg82h0kDKOmalkgz/diSZRzDDwHiYODCPy2vZr5hWxTmn1/JCxGLY47vzBfExK95sfEAdQqJ9asdIo/bWox5YUgrXTPNatenEcczAH4sM0+Vof1fcu7C9PGjYmDQ3mpPPcIf+dV7MHAsi2n5rzPrQJFijO0Pn/iuLRfz9Y+wLY/+yaVNyKERl1Zpii79A86knA3wURza4hdVKCIk2mTk35wOtVJZ+Kvh7p1uTivOjbtq01yFrNQTvpmTsedxgcWG2pVvHDOvy/KfOLt7i89/91KXJ9giV0o6w3XZ2mD56J0+NgVNU03RzAtaBfmkFsixSU3tdWNAQZWZ33wKjfv3t6fh8C2YV1J6xXpaa2aE9cAySrMzdW7qkgTJX1V3QTMtPQDhm2NjH0Bxv4dROfz88NClp8qRqhtawJjfkLy2GgKMDf6jYcTM/NBhlYP3cStvNnqId8gpjaDRg2RnD4ZRxnoOmY1YqUAalpS3/QnhiDinKofhxm5uJ90ahsWQqzFkOEbWrMIIEaC/L2kz4396jRK4+Rl0tgcpBUYSMNOJ+mA5kgYCRf2qGuN5qZuYhR6hSFW+UD2sCUUHev98ZVL/M5kSgF2eYlmQq32XyCSY0Uo22nqCld62rSoiq+jQCphkCmcYGeSxjh+9Nwojs6lFa0rUxGoQGY7ygoY1qSBHrKWaDIKoe64Yq2Ws6vI+9qgAVgyew39Q32sqJm0JY4T7CNgof8Bqi9EuB0cWAwC/DKeKSMuS6CSudKZF0Z1L2KlGlpxrtZooihrkCRFy30KjV2V8+E8iUKIXA57NBgXqS5RCJnNIdG/fmMQq8Gkeuv0bqDKP/mEMPt3HW+vTJFDYhST0UgwgU9n9Lih/wn2eiJ2DRiVcOp6mNS1FsGQ6Tk1LRa1vAaK+P0qWMUOYLXtUFACmjrb
 /m5VsC2O
 5O74D0fxROkHTJAnM/Mf/0iPk5xFyUpNmL6ntztlX/3kM+blnsTK9xvAquc5o4lJX1j1pAOImxvexyxmoHXTurf9+7rY56tyZ5qzLF2baDDpOEuTyPZMs02aa930Jfm9PD+nyQ9vOdw4kmIvjKl1Y7qTYV7C5drTImBlkGdv7c+Rrb+rzPX8DcoV+C8BvXMFNebCaJbTQnKs6mX2bBZYcpcaJOGy/qofbvZeIpEAGox0zpoAzpra/IV93jBK+VlLqRGFqPqGsKw3Vygu1/Gr2EGbD01ZJDEUA7eXfdnOknMm19qUTB3Y5wyZa1w8uQm7z12/5Ezre3lB770dW4/vSwIYNfAbwbPUF48+aoImjrBO9g3Py45iPXkJrAv9L78KyshW1L5HXwHwbkV/laIhfDsL4omsKwPvBixgg3cigHW9qSuARUk0sykhLK+dwCt+UIUeB0gtITAvEH9Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 4:03=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
>
> if (dlen =3D=3D PAGE_SIZE)
>     kunmap(dst);

should be kunmap_local - apparently it's a thing :)

