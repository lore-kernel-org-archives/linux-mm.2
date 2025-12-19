Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38963D78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 17:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D9996B00A9; Fri, 19 Dec 2025 12:27:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B18B6B00AA; Fri, 19 Dec 2025 12:27:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0976B00AC; Fri, 19 Dec 2025 12:27:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD9B6B00A9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:27:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AE3E1367B5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:27:37 +0000 (UTC)
X-FDA: 84236902554.26.021B6B1
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 061FBA0017
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:27:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rdkh8Xri;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766165255; a=rsa-sha256;
	cv=none;
	b=bn3QLrIK6DYcMobgu5JWOCySrNySbJnizFirjicLqYVVa7z+b8LBVDnc+JmB2AxqAeBus2
	ni8bGs5DDiBPEOPZlJC/f8gmE5bsQHs0hFrkmMmua16qpmweN4i+n/dqUFXLuugOOJ7P91
	c6e7ufuN+AFlI/QLbGHLfbKTmZhWnco=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rdkh8Xri;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766165255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ttCxKPZTd+PuE6lqbLWIoFDKTsRHEe6E3SvyinsDkc=;
	b=NGMnyUhwcZKyk+1AzjkBig9s9xitmyC3kW6fDrX4btpAkvmMiktP+rPMFIVmwD8g4nZe9H
	hJ6FX/hR6Vv9XLfGH7N3lxvlqRbUV31+yZkIt3kZWR8L1RmmjiSF4p0vtzxmHtGW7ThghK
	V4/zJm5N+Gz65Fbu7R98wddjlCtm9D8=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b7a72874af1so360284166b.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766165253; x=1766770053; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ttCxKPZTd+PuE6lqbLWIoFDKTsRHEe6E3SvyinsDkc=;
        b=Rdkh8XrijPajoSVbONEzgmwFZ12ZE/g/bvs+IqRwS7KTbtNe0MMurvfn9Y9LDtSk1E
         yqYJqDmST9vdXkUu4vY5FomEkbJLfmJ096xEZQr6Fym0ocr0/1fh0Hd2hPYVJi77Jr41
         kEv5cGdTVbJzBQ3sNTP7ZjUf9nnIBJQdj1/qkiIukUoLhsnvbGT5SMs9Ks9wj4Z4mLDO
         7WAjeAmHTRFOyMMEm5vLhPlJl3cBIN5sNsXDBPk07FEN9wN4LMFtVpHV/9KXNpd+cXGK
         4/649mfivEJOEDyf8v2vLa8GPV2KjVuLrSiXThB5KKlb0WIuqHOT6ofXOFEdqzduBx5J
         rQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766165253; x=1766770053;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/ttCxKPZTd+PuE6lqbLWIoFDKTsRHEe6E3SvyinsDkc=;
        b=S4pvdJG1HtRYSwYZ41D2CEGsPaCay3t0Os3WaIB46z4nz174ZJXvCO+jEH8L4vXGlD
         mjRu6BAzwfvonEYYumgQKItXTlIBiUrQl4qN3CScVyGD34ixAQHluvzilDW7iOCyJa8Y
         cdCQVCjEQSuoLXFjQno3dATKZfjZKM4gSsMFutqXE35PzjkY8Avyyuxdakdvo7TzoFa+
         RqD+UsP4sDcfm38mC9FUGCTndxds9/Qc1BTsXClcwmkiG2aII9kP57skTdsS3qiFUBW3
         ICuK1iqSan31HECkuDrjeC1Hqouc0IxpzGjoMQEY/93s/6gac21jQu5frXxDpWuflO6Q
         YiQw==
X-Gm-Message-State: AOJu0YxrdC3XG/3C0XIOuf0O8Uv0mELQxsn5S/mZ3I4+WbwgXHiz75t3
	lAOHbeVEk2m5OFZjOmNL9wfP4vqzfvBrRfvR+r14HfPyKB+0/72OLHM9RrPqBR0s1Ym8oWiGzXZ
	tX1n+/88Lz1AoEDiTD9YE4SR95N3L8Mc=
X-Gm-Gg: AY/fxX4MYVRt1jsPFNDc9KFCAE4pInE/DA/An4dKkbdVU6exuGqFiIXCS2OMfG+15sD
	HBP/yVLzB8F8ANkNA/fI0mIc+Hb6e319r0t72mli4hJBBV79IEnNi5FToP7IaFrQyBarxGjhRH3
	kchBC5/4ZaSHDwAEI2ufH+oXKl0xheP+4pm00YOV8/5MKO71pEQS1yMEvIor5kLa3Ea2Gy+SryB
	f7A/whyFwy9zqf9sDyXtZPMHnSUYoucFg292m8xhSDcpq4mYI8hoIJwOLIxtwQEze6HHLMfVGbb
	djtztaZRyJFfLHVaIwVc/UYTJUYLsls=
X-Google-Smtp-Source: AGHT+IEKLeGTrb/TxdmrKtLEB0MGLlW0hX2AJCUrP/nopitG/aATHwyvXAd0XPwS08Zn2zhJAXMQrj/uA5yUdBCTG6s=
X-Received: by 2002:a17:907:948d:b0:b79:fea1:5c56 with SMTP id
 a640c23a62f3a-b8036f492e2mr344588066b.26.1766165253148; Fri, 19 Dec 2025
 09:27:33 -0800 (PST)
MIME-Version: 1.0
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-11-cb7e28a26a40@tencent.com> <aUKSgf31kQ+vfbmZ@MiWiFi-R3L-srv>
 <CAMgjq7B85Pv_1XUspypCr3=QaQfkGdJaL+ERvtQ5yQtiQLqRqw@mail.gmail.com>
In-Reply-To: <CAMgjq7B85Pv_1XUspypCr3=QaQfkGdJaL+ERvtQ5yQtiQLqRqw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 01:26:56 +0800
X-Gm-Features: AQt7F2pLuJvNzThmQS7jkeG8p4ov4JqOQHlAr0SGlEVsG4-mF2PtGZKaO7xq2Sc
Message-ID: <CAMgjq7C3XxHNALturkgpzne6VYTSmsyBMTTG68MMQJaQt=1j6g@mail.gmail.com>
Subject: Re: [PATCH v4 11/19] mm, swap: split locked entry duplicating into a
 standalone helper
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 061FBA0017
X-Stat-Signature: yst9wnjmx7i1w4e31gss4o8a1r8qjsdn
X-Rspam-User: 
X-HE-Tag: 1766165254-836527
X-HE-Meta: U2FsdGVkX18iEwFsUQ/D+t2oONX3EfEHVwVnm/0PyoiePYS63P9wr3cBaLYPfvC/zh4CMvl7RlQ0yHYKnhrYjQ4isKg/RX0mXgEPNudAREucZnXRprZgGqO0ZY95R97UmgHQARpuB+UCzqQTcZBnoUcvxeYq/JwEk4UHlVm9N2+OG+nsPytMSVgECOSeyGwJYe2Np0BsYvtVGTaWSfDrzi1Hjitc+BCjPpICa0tbRxoY3Uk+uzKOcD6NYym3wF0s6jwkxy3T0bHPH1X5zkWPbG8W9Wg1eHC8H+fNiKdn78Sv9ZyMksdWPJv9LI5WrC0DxfCkkl2DyqNoBKVvB1ekyGLm44SdHCPiiNLNvwi+86m05I8Do0x/XTn0ph026ngUwYuWH/e1yjAV1Q4nnmA4fyrdL2oreffSyCInYQ3wvIQCREDT4l8vqmaNiS2cjAjT7qkqOTLKuIExsfYz64zhvjU/8XgRbuaFKMgKHProOPqm7fvdhJyFZ3kyKdWYOEqJ5Wb0cpAD9KZ26gJzOIwaW3HSKcDoBNIGWWG6q9vN2NAffqWROANNUQlC0gq+FQPEQmOppTXOxN9xq76vuJHutOUQvC+wTm6vN6ebY+AhEwSw4dB7LMxDUx0EBSdMgVQ7pumoxrzRPNgCFA33i/MohkFCSFy4x3ZENckEnen7V3CsW0xDPK1u82m7InaMg7mVjh1y3F0oTbPQ5JLK5uqGTliplBoOBbFYi1wiS43g47s0eBfSE1qZWkUNeGYRA3B47muyiGtLSgsMkTP4bgg7lXfdZjWlucAQ1zLUZKdn8ELqk9ZoNT+7aPYgaS2N1lKCLy9lZ+rjYT7KsaP24JfrKJApMIkKC/xtmUF1T39UCU4jowGTc1wRwuDSK6b3lgsz4Y78LFk0Td+EPWi8O2QcsvbXJY7VZ16LWFZ74jgJGctS3KChkm95e5tOQeC7TFx53j0tpPjOhDDHvnyceAG
 c2qUpKkR
 dTV+69iiYcYucPJhCaE8pSuNAYLdXly7hYI2kK9iKrFE3dTD9WqOzblgq848VK2Xkb6XC+4Q2HQAFQi8J/lKQ6UU1K3M3QxnjeSksUF90HpospACN5Z0AmPXZ+UKgQLbSOxRdtB14FUyZNuJE6WMs+ftsBNfFY90s0G7lISQhqi87VWig7Rwb+1iUa6R6YMQWyCv5hxZu23if11Z7LofxkN1/NQQIUP57xU4UkG2/IuCWOOwSwtZShdd5YB0T0FDQITWbT2f4eXT7ER8jIhcHCFPTPcyhzk+4k9jd8y/pAy6rBCaFJaU4X1+F4Z9lho6DqvG+KrZ02i/jc1X/HFs67QEHuefyEapRaPwXA++1qJ0usqttzuzTPHjoKmdXc+lU15NkA9B8ZC2Gb6MpmIsYkpjkEUExbq9ERa+XiL/271ZCbqw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 2:37=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Wed, Dec 17, 2025 at 7:22=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote=
:
> >
> > On 12/05/25 at 03:29am, Kairui Song wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > No feature change, split the common logic into a stand alone helper t=
o
> >                                                    ~~~~~~~~~~~
> >                                                     standalone, typo?
> > > be reused later.
> >
> > In phase 2, I saw the newly added swap_dup_entries() is only called by
> > __swap_duplicate(). The 'reused later' means?
> >
>
> Ah you are right, this patch belongs to phase 3 I think, I can drop it
> for now, it's just a code rearrangement. Thanks!

Hi Baoquan

While working on V5 I noticed we do need this patch, the patch "mm,
swap: use swap cache as the swap in synchronize layer" needs this
splitted helper as an intermediate step. That usage will be dropped by
the end of this series but I think we can live with this splitted out
helper. The splitted helper and original help will all be gone in
phase 3, and there is no behavior change at all.

