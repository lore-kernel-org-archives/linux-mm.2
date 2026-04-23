Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20750FDEE53
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 22:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7653A6B0088; Thu, 23 Apr 2026 18:48:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EF206B008A; Thu, 23 Apr 2026 18:48:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7916B008C; Thu, 23 Apr 2026 18:48:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 463F96B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:48:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E152916057B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:48:41 +0000 (UTC)
X-FDA: 84691311642.03.7248B4E
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id E172D20006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:48:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vTMtJKpq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of fmayle@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=fmayle@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776984520; a=rsa-sha256;
	cv=pass;
	b=BmFPu94POFcwGOt0rzRMD8BhNimGiglvQcdHxjLlTRJU3X5FFz0AcAK6tSB0urH1OF1Fku
	1bc5Yko44oKtb8tVRCpjCvoCm9kim+UQOcSKMQeL7+NHRjn2W+QYnLoFUYk5JLpwrz7m/L
	jWdxlbQvg+TRno7m0B1CbILMgBIDTnM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vTMtJKpq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of fmayle@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=fmayle@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776984520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdpbEPr8sE7aTSdr+qiHK/yc7hLSV1LYoXL5XQUQfyE=;
	b=UEvXfNNHrOfZmT2hXJ87YOxxNKQfbRWWbpBW6K3kSfrBEDA5VnykNNPnd6kIwZsowxbvEa
	GZWDZFIT3dh1zB2X62FibID7rKD8gofspCdyQGi9Y6vJddjo+d6dXOBcBVgSq7lHfrP+QZ
	XcReX0IiFi2ktCypwgbTENOCcZ7ujRc=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-126ea4e9697so58169c88.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:48:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776984518; cv=none;
        d=google.com; s=arc-20240605;
        b=D+BbpoKN57LYYfkhfNuwi6hcAJb6q86e0kNgK/DXOvcNhLqvkUfc/vgvQNLy3pmPpi
         GiDvHDASOq7C7Dycs+xKStJAk7RlZXknC3vlPCfCQvRxej5H2i/iRzhOu+5MKwFM4+dE
         HHQNz8ntSQrFpMmaIJGF1Gl11usrzihiEgy2PmRSpH3E08trgBA83DiQQ0H1BB3R95u2
         6PYdOlWZYDGXvIs7avWCnyXLGur3JdQyPk8v+V09569aeje55eKmF9RG+mMm456hWh+7
         WXwIbmoS/Nudj03jM394ImIvlZgsxv1zqQHiwNYi0JLi08RIjqOZl3PyILYVTyAfKecJ
         AvDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zdpbEPr8sE7aTSdr+qiHK/yc7hLSV1LYoXL5XQUQfyE=;
        fh=GcSF+9JLI37wQ0ObcoH0/EIffL8YG2j6Vw/pSGKPO0Y=;
        b=Ifqf3Qj8+y5AQw0U0eJ3aALaPZliZxitnRgRu1OWFNKy1x6CpctWg9bOI6XD7g2ZTm
         iBgExLh6YN1l7Jn66p2CfgGcuf6+AmwcVjII2tFi/vq54x4TGaIf2W2maoxh9xQhyeLo
         ZdSEB580NIR7psGOAM6KxS7D4xwGCdaCxFvzS2EkEwf9BH8OO3xC4LTjh/2mP/d9Lktm
         dFSbm/KvB/WaIkl49uBlRxkGBvmoN0XPQU7NNAYu/nXOAs5F+x+7ZjfKj+U8mYnlhQIK
         dbZkXpyz2cc15Cp+/n9fAzomBYujBcwruQtvLiTWv3ykRmvTOkYTX+t05CfrvNRzT7Sc
         miuA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776984518; x=1777589318; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdpbEPr8sE7aTSdr+qiHK/yc7hLSV1LYoXL5XQUQfyE=;
        b=vTMtJKpq/VFuTng1GIkH+TjOieZxfg/RTxCPULpt11ICG4KfqPBfCkU6h2ev+2gQH8
         p+lTwjFw1pOC1zjNiJfPWYfR4pfphLBAPBc8Vb2Q1RER8l4ybGBS1Siz+uU6VEnrwTnE
         iGXhvNtBz24EsSUMD+dWstzEY2vRcea4B0KamkhkXJHzFVePTJ9dtZBnOjt1eU7nCrv9
         aw/jRgbWM+/lRnTZ79Iao0xkexa7BPYlSN2qbKlaZs42HD6Nk38OjeurUqVGoKMl1juI
         MsuM/mhZeXuCsIblLcYQnjEZXHStWSFBPG95N1F2X4y45naaFjmryXYPppknVMKhOZ5t
         j2Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776984518; x=1777589318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zdpbEPr8sE7aTSdr+qiHK/yc7hLSV1LYoXL5XQUQfyE=;
        b=jkoZZdz5LC1yxPxCOrnH3fWUGz7I3yoSABjh6i7hUCjxQEAd+tnqagYh7hP8cHWyTD
         IV+bPNMX2uA/u5f0ElQZ6Pc9jtOk0raJWpM5vxHUx8sSRhU4TWive6q7Hz7UeU2YR+vG
         kSBq50ye5zhMqtg9BaCtHWC1banjAX+E0sMoBqgpK7K7hcS7Apq9hcOz7E7jBJk5slxT
         LMf0USeU8xeft1m/Tz+tnHEF4UysVB1q+nUSGO7GkTOo1XtWXa+JaEL7qlCrvsOI1hKj
         ZSPziES+8KBuRgDcjGG+jV47AyphEAFFG0THhRTi9axF/VZN87H6xT7xlfFeFrs2IsAC
         IjvA==
X-Forwarded-Encrypted: i=1; AFNElJ8yFt11R1jNc6EWCaWhDAhmwqIKUMhWQChz4uIXhyj+VXn/fbDRclP64n1XZ3N8CQS/VLvT93c2Zw==@kvack.org
X-Gm-Message-State: AOJu0YykGRfQQDImUIRuTSNtxkyxSZruNyD3gviyUldiJhhsLJkz/Mah
	wx3F0Us/xuRf5iLS9pSxCBocHPsAuHpA5mSel2C+xyZWSdxeeFLesysm+XyhfG4ZlIbwWDY5qgQ
	kRheqAhAavkJ932iCwAler+Dk46jh9oMRm8D2w+7f
X-Gm-Gg: AeBDieso14sS9ogQ+y4v6J97Pp1bkBY6zqcpMefXKdEkSC4v6voAyh9OhIi3uVIn3oS
	DCS03MukL6LEwykk0Lno4bEA0JeXuLuiNC7vgyhAfLh6hc09ohiuyFkJkQXIPYhIwdru6fA90Oj
	KbyfU6XqjDf/HShgSD+4LPaDz7JVR2Nk47WP6uKqbQTgAvslBfXAw5QMYmN+dEh1SAPnJ/0qjif
	0vxTD4lQa7AHdE2TqHMe1kk+gJqu1emTnLKhw7nh1B+oC2j4Ix7lRYKSkSXpt2Ww0bIl/c33ktJ
	lDgqU/f2BCa4JN38htUPXgynvyn3zUuClj/CifVrG1lXGIuWLvkFFbJmK/4=
X-Received: by 2002:a05:7022:6b9d:b0:12c:61fe:fb37 with SMTP id
 a92af1059eb24-12c7b258b49mr945598c88.17.1776984517927; Thu, 23 Apr 2026
 15:48:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260422005608.342028-1-fmayle@google.com> <aei_d5KMKmLhMx3S@casper.infradead.org>
 <qmojyvlsbjcgavnecbvfwax6o3d7edzifpxp7raxbevbfcxtbi@mox2z7njeodb>
In-Reply-To: <qmojyvlsbjcgavnecbvfwax6o3d7edzifpxp7raxbevbfcxtbi@mox2z7njeodb>
From: Frederick Mayle <fmayle@google.com>
Date: Thu, 23 Apr 2026 15:48:26 -0700
X-Gm-Features: AQROBzBKmc7DAAss2RftthMElY3qEGGKztQAKz3HOJbiVkmJ3gzR2XQMGvOzSpA
Message-ID: <CAHCxdc6BUtT6Ozdpas0+7abksrR6hM17BNzz4=rsiTka0vxVGg@mail.gmail.com>
Subject: Re: [PATCH] mm: limit filemap_fault readahead to VMA boundaries
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, android-mm@google.com, 
	kernel-team@android.com, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: g6khe5zq87b38qb8okpoi7z4i9bouy5a
X-Rspam-User: 
X-Rspamd-Queue-Id: E172D20006
X-HE-Tag: 1776984519-264178
X-HE-Meta: U2FsdGVkX1/jxVKAPhIeiEE/62jl079WYydwrkH1RME84U6ar79KLWS1x/aQHHBZjDaNpK7n6xj63bEwYu8GRVBeMEGsLup3+UFWc0kiSjhyYMolr1IgSeuSZ3p46olUSk8ACq/qFkDqBlw/KxtZMM2g4Mwgf1t4eTYAhzVejZ6C0pSI179tnSOvdFr3tfW1I512znJg2w3xKZAFC0vGDzVHHhVbJYi0FsXirsVZ7OAJ3tFhFlnc4q9gGybBSbVMUFnFD2DkvuczxlL3z4Vl2FUJXqY0dnjwD2KphZvuNLvbO4aD8F5O5WJXXwUfvZh36afY2Gi+XgbE78cBUsOPbIzdwIVsaV/QjLW3QOhFHD6twXNiYclJu6wnolHxnvz5IvWa0DUevSDeymXs1B3UaLTEcNm+RsLm9ydbcUmGz6ydkN4c0bAUL/3zfyWCWerGaA9ElEK3ocvNGwB8Rp1OxJqx3XSZ5Imy8wvuraItxrcGrPIBN0bPYJHUtSagT0wHM81ndfPUTAnbjpXvMr9bm5dMtUXKRtpFfbsspoNaiSNSnZvRI6u6eJWcBfj4BLv4QIjV3ZNrqvPUQQpmmkAAv99Dmc+mrMjW5onDzLxsasS/CHfnT2eZmzx0nt6h2uBeyARJ2zObT/Eydd6SHo8qOyJ2iD2f0ktMSmEovaNzMKkC+PN9Oha8sj+68ms8C6EbTb67ZQDJgozpPeXuO3mwdB3WDGdKNfhAfkDWN613ZajubgxqfWNWXNc2ygRPS+0cjRi8KPgk0lBLfGctLzgyrlt2CgKgpCCvlbVhJTPUNThbdgAz4XkBPlC0X5QXt76eDsDFoURucSl7sJSzQ3CTclgU6PpDWJFkMSLYxBFR7yTd8/2AaBHEU1LD8PYxuDCqpLu6gFJrh08PKPsorupVUWFIXKoRBci1AKC52O/On26dgEPiaDWCeawZGI4B5ZPbNQ4WeW9vtrXvlMT+Mfq
 NrqTbBAq
 GZj/6oqEkZEtgpH+tutWMU8zmXi3QzmwUQKRdhPBM21sAzaX63y1xrCgCmsRGvfmDfK1Sb4bZHBsYx4FE/yHcvc6XobwWutZlSiD337CpdZJT9VsYPtXZJpj8OJ4r6ZCAi18Oon0ZMPt3Vlvhpos8fI8GBWdkx0r+v77hbOOnj4tlxDba46kngKGxwAESuBepwlvaqIxvwhHNtEmil4WOUqqMH+JtEQyDivMjgQmibv7rD8Zk48zyZi9JOPd9GH4ZHu7oQD24Sa+eOu6HPoHLnguOu4QnKMpzQ05t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 5:56=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 22-04-26 13:30:47, Matthew Wilcox wrote:
> > The problem is that we might (for example) use mprotect() to mark a
> > portion of the file as being unmodifiable, but nevertheless still want
> > to prefetch through it (since it will be read, just not written).  I'm
> > sure this solves your problem, but I'm not sure it covers all use cases=
.
>
> Well, I'm not sure whether all the usecases are covered either but is wha=
t
> you describe above something you'd expect people to commonly do? In gener=
al
> sequential reading through mmap seems to be already relatively rare...

I'm curious if anyone knows of a use case like this. I'd think that, if a u=
ser
is making heavy usage of mprotect, they'd be advance enough to be a step aw=
ay
(or a few steps beyond) wanting to manually trigger readahead with madvise =
or
similar.

In recent history, commit 38b0ece6d763 ("mm/filemap: allow arch to request
folio size for exec memory") disabled readahead for VM_EXEC mappings and th=
ere
doesn't seem to have been pushback yet. Of course, non-exec mappings almost
certainly have more varied uses.

