Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E5BCCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 22:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19B79000DE; Wed, 13 Aug 2025 18:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACAE2900088; Wed, 13 Aug 2025 18:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9924D9000DE; Wed, 13 Aug 2025 18:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83765900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:24:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 02D311DD010
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:24:20 +0000 (UTC)
X-FDA: 83773163922.22.182F9EA
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 12C0D1C0006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:24:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xvXoZQCU;
	spf=pass (imf20.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755123858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBuriLyGg6Pmpqe4MLdQ2ZnLG6gcsE5Zsx64IXskAfQ=;
	b=ItLbjin2nouFIAU9io7ZuJrWPjYFOrAx/YWyIw4FLZTFEPGNlIKqjMsDn3i5ZDwCTAJ436
	hLVDJk6oCNnk0wdzp25yCya+bgCc7DmBXWoKGoHVd/ZptdOP4IfzFTgh+onZ2bPpv6K++A
	TOyb8pT062tCWeyIID9lcQCAiXToqIQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xvXoZQCU;
	spf=pass (imf20.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755123858; a=rsa-sha256;
	cv=none;
	b=ZPhX/anzhSQjsPpwVLvu2D6N6otYEgdFsFq+XZCXaO3Sk0TQbSdFTCsXWpoQDj116PJm5j
	No5VckxJVZ8vE+MiWMx3G9Hf3c0ebsx1b8MWDrF6e5rybKNPNA3EX6c6XndVcN8EGQII70
	o6uiCyWWLdbop8eGHFy4dTS9zfu7qUM=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-618076fd48bso1795a12.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755123856; x=1755728656; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBuriLyGg6Pmpqe4MLdQ2ZnLG6gcsE5Zsx64IXskAfQ=;
        b=xvXoZQCUMBJk7Q4UTnPFxH5HtFZWG+VuP+ULfJxyeVXaJsxajfib5vnjskUT3+mfma
         Lmg5cfO/nUY0KzEXkOGX1MqzeIQJUzgTDZ1JNWAWJsRfYH+B6O172hzdaHGOhcMlKhzS
         OiY1bbzXrG3zxNw0cjpDBUIN2li49EsLafoquV4ZUumoDZjiSarrE5l2tyz63cwG6BCr
         h19enpp1gxvXy4U8CNP3Arcc7LjCdGIn6gF6jleIvsbmEEW64wWlKTH6y0xybMGPW1XK
         J1orSQoWeQVZ5GpjGyDvBudR/l9U9xERX/kYQNZWtEEcBxGS+808WPVM31bO4/QQV49x
         +c4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755123856; x=1755728656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TBuriLyGg6Pmpqe4MLdQ2ZnLG6gcsE5Zsx64IXskAfQ=;
        b=AXbEYksahcm9t+vDeg58wpOTUmY3HBaMvrhkCtTgA/RKOOO1drn+Dqj3UCzFzYpMzC
         EVqdZr3lABgtg9Y396hhLXqMp4HK9pyUvFYFeKw640ncX+5T0ZkvMSIcwrarHfkBCXM3
         eyqQ6FFWVZhiFu2gXg9xCK5Kd7SUKddyRx4wZFN49avwwlIfxhUmy/pdG7sA/F0atQKP
         PexES0IX1wui80NdkBEmKmNlc1LUialIt5CBPOOkCoOJqgEUjx5j9+p0BTtQff7t7+7i
         4GXxraMWoFM/uNTIUfVha1fBVAX3YBixb6pIMqMAesyUyXEqIgAS/8qBU0oubcaHzDBt
         QTNw==
X-Forwarded-Encrypted: i=1; AJvYcCXVD5YkB6k+cI37uLeBeXi0OJ2TJVRp6pHaZbYTIAxLQ3m+eqDC0qkzL1MYiuRKcPAvFUqZWN+7+Q==@kvack.org
X-Gm-Message-State: AOJu0YxAfgx52o63tV/iZYY0jR6miuXSWOS5TZE2sX17VRN5Gcxo7Nf4
	65r9CKqQuvoEDpdXHq5US85MulqIcGiDLfdxs5qNojmtf1ahpIoPWLbqMO5zsAWbFaCCVphXq98
	E2WFCTwqcOCPUZAJDe7aG/dCuBX0TIiNs3GtSz9Cl
X-Gm-Gg: ASbGncvUHSXDxr9Q58lRs13ngX0FLtw6li3UPGamdC8zL/s+bI1AtMfc+GlpzTqzHPH
	ltD1SWhU2jnX4XnFEZQF4od1rZUq9xNBzmRsVJ2dfC4ilGiq3OvyY762CCLc18A1YHW2stjqHN7
	AXDhz/YNMl0y8Xf3AKlmVStyC/WJzZPt6oCe24KpK0kQOF/AtZT6+UFSg2+PyKtDAm7GxlpjUsI
	vqRFuXZAZpslfAO7wkPin7/5aKp1zoR1EwgZg==
X-Google-Smtp-Source: AGHT+IENbqcS2gMv7BJVYfjz2GEXbyOWPRtRgNavUBGaPR2MOtKnq13f86SWbkCCn2Shm0q7D0JeWY4FXMixuTM+h6I=
X-Received: by 2002:a05:6402:438f:b0:618:8373:30f0 with SMTP id
 4fb4d7f45d1cf-6188c4b0c88mr38852a12.2.1755123856394; Wed, 13 Aug 2025
 15:24:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250813193024.2279805-1-lokeshgidra@google.com>
 <20250813144737.c3f388313fe13ff44856daf5@linux-foundation.org>
 <CA+EESO4rMS5ot_wJfWVT+7rDKYgk187xnZJ3NNZsFgUXCbG1yQ@mail.gmail.com> <CAGsJ_4w2L6ztZZG9aypa7DVpSEt5vJWPgUuDj7WY5KYtZRFvuQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4w2L6ztZZG9aypa7DVpSEt5vJWPgUuDj7WY5KYtZRFvuQ@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Wed, 13 Aug 2025 15:24:05 -0700
X-Gm-Features: Ac12FXyAW-Ox_idR1AP2BNQ5--lukWi7vwsrQTQsXefehnnzmNrhmxlWy8pHtSo
Message-ID: <CA+EESO5vjGHvCkUQPgfm5HZi=WyJD0nPMbK7vwNWsrxNqzBpzg@mail.gmail.com>
Subject: Re: [PATCH v5] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Barry Song <21cnbao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12C0D1C0006
X-Stat-Signature: x7qa91uwdhdj73z437xsgm4gesoob1t5
X-Rspam-User: 
X-HE-Tag: 1755123857-977662
X-HE-Meta: U2FsdGVkX1/XH920mibT184HPPnQTygPPr9pwDNU7mtsKyavKars3iY/q6eokhRdTaWB0bxKN62xl1s571QFe9jwyqNVahc5P6FPZ9/RuVAFAUCykB42xHTRGBeBaV3ldirqqcSMrDDa+v10MOfLxOALvnUnss0iF01B6lZVoOAmShFKrGaoNmvggNN5Jcb1JHpKIFgGAAPpB4UewRf7uEoTIpw3930opot20ush+nETmQJutquR8ieba+OzKuALP8ZguddxtrS/Z7LsseLytjKYE8i3hNiP0SnwSMt3GZI9uGt6BKXL5IwFGYOj4njTC+m3xI3D7p3UNi9pxQ1X7g8LK/ou1ynmxkkZuGFXdwMCG2D5G/oqqgUqHTR4f2NU4ZHNkqqJM1VV0WtyTcwZV1TGIeuONGzm5m/s6IB6GlcmWUYb3tTg0Gvqt+YfjZEzhmmgElVn3mkYeR1AqccDyjO73hOzWPaNboFNNNyFMfdjfLUHV/aRt1xkeQ41z5NoO0mIYASGXoa8eZR7b91sFbEYUY6MVktBmbXXEvPQCN+UiNlA1CtsW3RJ/pSXBC5lNprfv0PaivtHC5ueQno9ZiO4LY5GX3w5Q6VtZBRP5/eRKzfv8WZNFjmgdcujY+u1ZPSQdp0k8u6D1Bmyw1HYxwkMneXlbYcM2jVvcj+9jeKpPuAwh3KT+L7uXkkg7etWwGYfv6y1CgQ53US0SaANEhTTkVFsZ/3+W9/MSm5gKlqV+MdVdfz5377aKLMoA8wemOKWVfI8UPlJhvm0IJAyJ21oaIuJGN83kZdMPu9wEjk84Zj9l4Pxuj69eZZJ+i9xA0yVBreI78G0LCNeNNZ6A9IrPeTkAGT0QTXcRtVMxcd0erRaLbitfebzL3w9nP6aFIiRq/21HVZObCMQr8SiRzXUxCyyxSMBL90tcphBKwLW0DlfVy61N2XaX7UNfJbzGW197jT7qiP8kn4/P7/
 1Ci7gfIG
 EAfoot0KHj+8rrSgi1tskHQ87K3iGhxRTpwP5PCLa9uZV4t+g0YNwO0acouCedHyqyBIwTw6YKKx6Fq8aZ8N8vwgmj67sobFuYQuyJ+4htyfwbP6dAXFMLlXBtq3kfnbMxg3N5yG7XnT4fpYg4tRblNpBvo4MHMN8SgLj2O7BvKuAZqL6tJ6wQC5mkF1t5JfL5XNY+tMsUrp2ihl9XvFbltAWbDwM0Nm9riEXxxCGivruhUQjj4RaqGr1asLl72hvkCNtqW2/Z4QJqnhYWitQAm+oonSpuCwsaPQZKVgt8mbiUc4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 3:22=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Thu, Aug 14, 2025 at 10:02=E2=80=AFAM Lokesh Gidra <lokeshgidra@google=
.com> wrote:
> >
> > On Wed, Aug 13, 2025 at 2:47=E2=80=AFPM Andrew Morton <akpm@linux-found=
ation.org> wrote:
> > >
> > > On Wed, 13 Aug 2025 12:30:24 -0700 Lokesh Gidra <lokeshgidra@google.c=
om> wrote:
> > >
> > > > MOVE ioctl's runtime is dominated by TLB-flush cost, which is requi=
red
> > > > for moving present pages. Mitigate this cost by opportunistically
> > > > batching present contiguous pages for TLB flushing.
> > > >
> > > > Without batching, in our testing on an arm64 Android device with UF=
FD GC,
> > > > which uses MOVE ioctl for compaction, we observed that out of the t=
otal
> > > > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), =
and
> > > > ~20% in vm_normal_folio().
> > > >
> > > > With batching, the proportion of vm_normal_folio() increases to ove=
r
> > > > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > > > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > > > includes TLB-flush overhead.
> > > >
> > > > When the GC intensive benchmark, which was used to gather the above
> > > > numbers, is run on cuttlefish (qemu android instance on x86_64), th=
e
> > > > completion time of the benchmark went down from ~45mins to ~20mins.
> > > >
> > > > Furthermore, system_server, one of the most performance critical sy=
stem
> > > > processes on android, saw over 50% reduction in GC compaction time =
on an
> > > > arm64 android device.
> > >
> > > Were these inefficiencies a regression relative to an earlier kernel?
> > No, these inefficiencies existed since MOVE ioctl came into existence.
> > IOW, the patch is improving performance, rather than fixing a
> > regression.
>
> It would be nice if Lokesh can backport it to older Android common kernel=
 such
> as 6.6, 6.12 etc.
I plan to do that after a couple of weeks of soak time :-)
>
> Thanks
> Barry

