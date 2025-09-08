Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4895CCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636F96B0022; Mon,  8 Sep 2025 10:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F296B0024; Mon,  8 Sep 2025 10:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C7A6B0026; Mon,  8 Sep 2025 10:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 433C36B0022
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:27:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E216D56503
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:27:40 +0000 (UTC)
X-FDA: 83866311480.01.3B90106
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 030A94000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:27:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ImSGCZ0r;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757341659; a=rsa-sha256;
	cv=none;
	b=Jyn5QHzoD0VufDJ2zWc1ejgpKLZRfxi0B333gr9hsWLOaFujfAxJBFeWeFfd7heVMsW/XX
	358BA5FrrkMOwEqXknv3jTH5wVapArsvki9/7kPbS0fOFVYkVRy8yZb4tum2M5mXuvPrT6
	e+v1t8NpANgYuylD5PyiwQv9Q4nBCDU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ImSGCZ0r;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757341659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ndx57/SqJ7BMGZJUHqAwVIM5I7RGZPiL/gdAXPbMwTI=;
	b=LIVvikwB8c1wn9QkJP1+4fBDqrJL/DNKujsjVZimDqCc9vsSTS0dPYOJh/giH7JX59hzm8
	Sn+rsxRXk4jxydCI/pX8vZAZ8EslI3Cz5EkXxq3PC9kIrY6DwyFoVEDb3iwkhhz82KWm3n
	9sYnYj4fsN3O9JWmpuxOSdIrGk9EcZo=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b02c719a117so800235066b.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 07:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757341657; x=1757946457; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ndx57/SqJ7BMGZJUHqAwVIM5I7RGZPiL/gdAXPbMwTI=;
        b=ImSGCZ0rHiU5v1VZwQtjb7SOTrVDHyCPsuzZFvkuUlPP9H99BjRJtExZngOUN3WpAL
         sBDBPJKEEjrR0ItDMNzXKISP7jRlBS9PpC5qq7Gt3cyMfwXcCWSRXDs5hI8uzMzDUIIh
         v8KFjJj7Gbf0ROyUBEN6m/ceZMtNyQkSj7aILCovXPNdAyTJOR4LGQTtceaREGzKX1af
         QjvR846UyN7NHjXL/JLMD3cdFD368kmBrP/KzKXC3JVI3N6oLArpN/8HEsvL10+Y21i0
         Q+hhWyZnGfnw4PvB/xT9tzQKykAe+KJBmjm7uyslIs76mmgHhRiMIT+Kfk/zL02bwRCV
         ROgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757341657; x=1757946457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ndx57/SqJ7BMGZJUHqAwVIM5I7RGZPiL/gdAXPbMwTI=;
        b=i3G6rnuP0rmzT0X8f386x/hI16OCwjdYll12H7HipHXtDEDM6FPZkdzWEdkj4TrnWX
         YO5Eql8cfvS6QDsAAzuzQXoS+YPUn7RhnUbO72JyuoyQal9bYrOGrHjx+eYrvDcYcT7f
         DP9uHX/Zi4m+0RoCT7izUG5MM5+3uETjYhJhweEPWEHorAEM+Qwgj1NHjD+omLTIbMqW
         0IFHizRBi1yxGcJH1yc9yUifr6Iivl6SdyevYPUy+CykXLawKHbdjXoYRj6W9CS1z7Sa
         iFo2EyESMe5XIzxUzfLVQ6MqtPfqNKtwGmbvW1x3LGPo/9IMkOVGtsmy+D/VZGQC84Dj
         ivXw==
X-Gm-Message-State: AOJu0YzHjsQDeyzL+DAm8nf9fVGtU9Q7qf1qYAmjBuO/BLMuC+fA5+G/
	d4y6xIOHHAdEeEw8XZKUL13rxRRpskgEWY1xpArBYc03XRKF1lcmAek9frWYiYaCQPQyHMljvFH
	afmR2H5HvE8sfbWTwI/EmORZcobQlfKw=
X-Gm-Gg: ASbGncuZLEc8UOtD79hkwOt3l2P/5kzwslVTTjZQzkHl13rUAEAS07ovTn/ZfhHXnDd
	s8YUFduygnMXgsFWpdix+EtM+sCJfP6QF9TrgfNgB34Pmy7Wg7S0bcB7xi7HL+oynvaMTe0hzOT
	tZLM0rbWn6qjJPHYYlKa6VosCcBTJb1aa05n1x8Ostly14lSTQq9sB6llDyTkh+kMvfThoVkkLk
	bUSqvOjGvG51vPxg0bhSg==
X-Google-Smtp-Source: AGHT+IE4KQ2gcrVzi5wsR+T8BGbg6waL5kryFRWhnO4Vu3FuU//s60dXIwjdTnklt1NBkltKEcmBJ2Bfp6AyYIj7SnE=
X-Received: by 2002:a17:907:928e:b0:b04:5a68:8686 with SMTP id
 a640c23a62f3a-b04b13cfb3cmr754555566b.4.1757341657171; Mon, 08 Sep 2025
 07:27:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-2-ryncsn@gmail.com>
 <aL7NrhGw5ftOXUZs@MiWiFi-R3L-srv>
In-Reply-To: <aL7NrhGw5ftOXUZs@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 8 Sep 2025 22:27:00 +0800
X-Gm-Features: AS18NWBoClT92y9cdL11cKOWWHnIPRdQjWk5sh5wFMFolKeng8Y8CsOHHjMG3m8
Message-ID: <CAMgjq7Bp-buJfH8TPCxBiV80rn=zrvucwHgSCMFuS2BkUWkrJA@mail.gmail.com>
Subject: Re: [PATCH v2 01/15] docs/mm: add document for swap table
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 030A94000A
X-Stat-Signature: junteb98nrzn184cti3oradkk5t8zkky
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757341658-990949
X-HE-Meta: U2FsdGVkX19DDWwcJDWQ56IcZ34z31O7KfGBcY0MJ81dYHqUr5ahBm+lwN6yDDgkynb92dzsON9c6YTIxV+Eb/Vz9CuROlScxSUkccTL0eFJRcWk5Blvar0ti5X702z/19ayl2oT4jhfxdf5QuTSIwpHKAlh/wqR/wXro0Aqu96AHktohqzqn3o2fsKIFF2Ap/zYM30wpmVmozkmTMcKo4vP5N/k9I3j6qC/Yz/BppwWrWnALKXtB5OETlzAjHxLGvon0HuuE3hmKTfTeei2qJsXeFS+BQc8Ts5tumD50CINzItKt5jFcTCHOFdyU6upBx55QOBKhWpMhlI7OpjkZCYj8xEeJcjzP0m3XRkL35L619ZT9d4lBRoogAvYVb8hXrWQIDX/8ne9NzxMReZxGLHIUwHGwv19Ee8EnFQ4pZfVfgg+dGUIX61c1Av4aCCmczMfg+CreCC2lRUnhzTxtJ9xwkKSgZ/2VGX94sg60AuTcmFPAhxsx7rZ+ohF2mQrhmaNzakK4jNOS1elNl9JRerKPdG7ddrEq65r3TBUurrVB7QCKdV3v2RkpGp+lCq0Hf4pnDpDaX/7hnlD3IHRV20RWmrL7I+g2WgnwrWX71rjFsN8cmCen+xAMrMduezX4rozHD+m8aPpyK+yZLC2dK+l7Ffo6YkaO0GqUnKLak2V5o01/pR4fkNBWRHOoNX6sHcxOAmVMHGujeMPYs/sseAzK2nonGHbo4e5V16YGFcPf//5Y7ifNUGDCmVsLkjOY04EkypuvZgQmb5sWlqBkNfp0g5SpUuREhZh8D7uIlOWrFnVyxNt0MfTdNd/4K8UojIpXZqT4lG8arqFp8mC+dYxsZXdKA+d3W/1psswI4hacsBr+klvE3K7lTNyeXqPzaQZ56JqwP53/UslAU9xWBTMCOChMlMrpUScJkU26KsG16LLca/k23WB5pU0XYi8v/9pBU7Mm+ZwPhaAsbJ
 QSBfJga7
 AkpGnd1z4PSH5uXx7enOkLv5tJ+w/oyZZEdKjYI0VWwzZ01uNK3YfdET9FUWk+zcnPDn83QfSaZ2VtOsdA7taH9DfmXD5hYtGCd/zIIxjf50TGX4FGdn6EaJdLldgEHr8J8CEkjahBWaEpymQuQumVZga2ZYtIwLXFwjdW+G3QPV4roz+zwlk/EIAbLKOMrdetugjjyAytNcDhcXGIUqwPQSNxu+I9S3lazFtBrxTXQ+79eBfoCnqvfAkAYrntaarOX4sqdZSQarCeM/jMInJecmNRSfBQmiypyiKVYwWyHKaviLPL1iKhLXTOGZerw93Pj+dE07s+0ozLDTAyaNFxZyThPB+2U1yrG8aF40lEtGT0Qh/z3njLATGumA2N7/O5OpwW65530JLOpEk7JOeRFZPczJgogh6AQEubtFv0hbzhPVcXR8ZxGSRXQ837PTygjyhgPGC49lfcvvw47c8Xd4Xgz2wFo4agqtUCvxORCaoWSEbX4dbseAxk3txwJfu6iTMLh3MVfduaHAbDhmDhe04yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 8:54=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 09/06/25 at 03:13am, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > From: Chris Li <chrisl@kernel.org>
>
> 'From author <authorkernel.org>' can only be one person, and the co-autho=
r
> should be specified by "Co-developed-by:" and "Signed-off-by:"?
>

Hmm, that's interesting, I'm using git send mail with below setup:

[sendemail]
from =3D Kairui Song <ryncsn@gmail.com>
confirm =3D auto
smtpServer =3D smtp.gmail.com
smtpServerPort =3D 587
smtpEncryption =3D tls
smtpUser =3D ryncsn@gmail.com

So it will add a "From:" automatically when I'm using gmail's SMTP but
the patch author doesn't match the sender. It seems git somehow got
confused by this commit, maybe I used some sending parameters wrongly.

The author of the doc really should be Chris.

