Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 999FED74EEC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2066B0505; Fri, 23 Jan 2026 10:32:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98F56B0506; Fri, 23 Jan 2026 10:32:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B626B0507; Fri, 23 Jan 2026 10:32:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6EE96B0505
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:32:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 742431603A7
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:32:33 +0000 (UTC)
X-FDA: 84363620586.16.453B1BC
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6014240014
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:32:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GZpTv17Z;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769182351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9XNHzU4slxNurpxQryfak1aJ14di2n6/2qKm1fvy5g=;
	b=eioVkCvQr5d9Vmk/XMqpc32vN8jiVNeCqDwxV1XFO19Dtp2W2zsTfnT50RRzuTxP/Dm2GT
	IKLA96w6Upv3Y2ebTCnshnjDAVRPbEBT8kifQmXNoDhu6fg7hkIwqQieSJx8of+MmzL4Fy
	KJppQ8zVlX5Hlxl0dbg9cDu5Yhv7Hs4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GZpTv17Z;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769182351; a=rsa-sha256;
	cv=pass;
	b=Sjkbx8YerkiGcwVAlE3iBdXJ5NcVzep6F2Lj2ntsyyMaW7vBC8ZCxm+KTgtbvASDvEBgB1
	jjmPzcv6kLkdXAxYcQCTgm3lXxw8D0HwAudcBv6e4RBgeYoo3CNNp3zYFBOk1IzkQAhXdB
	5oPv3wJIALk3COdNkSThmT6+Z1MFL6A=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-382fd8aaa6eso19579801fa.1
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:32:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769182349; cv=none;
        d=google.com; s=arc-20240605;
        b=YiouqPPpirnqGyNmmrBQwlCOYkqFwxXVWeipKxQ7wGni3ct8UD8IMutCRAGHNcnRg1
         0aTxXWZpxlKGdNe2qU3HFekqAQ6mIzBykil6ohp0QCz6kIsjZiwZmRH++YfGjORNiwnk
         7ARwRasJZdqdGEqiDEReXqk3/b20x7GgtnWhKh0Ub5W9NXJy6fetVRTsAASdgL6g156i
         PbBpjtJ0RXHTBcGcmpw0AgQ0qs1OUEHybW15XvZWYogn9W8DDXLbA7JqvXJoOibT8Pz2
         omffUbwis5/TIa5PlUzSMk8SOdBC7MPGimTKTKgLQof804lwogR8PkMz4sbYHimKKWKP
         hXzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M9XNHzU4slxNurpxQryfak1aJ14di2n6/2qKm1fvy5g=;
        fh=CtbJxkTVuubgNObdN1O+TMqqBEhojNPO3gVIQOuQewU=;
        b=OkLSifYCdRn7ZT95BIxia+MahzuNI+NleqSMQKMjM6ZqEH1R5aEWtbbPa9rTUOI4XR
         sctO/6MgTLzzSUHx+5+gUCKcCRqQIie96dwWu5IFDASKGcAkilXrfO6SjeaWFHGn/uWP
         0xQOuHaKyDXNjW445YES89GxePzSR9gnQyK+d6T24jYLI3ENw4C4Bpn2aWmP9AmhG7Ov
         zg9PiAoX306cQ6wDaxSeTDsioPNwYnBdGmZcJ2p/BRsh1+uVepC+XeEA4RdWyfIEdkeX
         xxyqqKD55EnMuZhcNCz9cr2GEBpGlz/iLHJD2HzDpRjks6IHawmNSwkcFR8ZXUuRae/3
         4L9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769182349; x=1769787149; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9XNHzU4slxNurpxQryfak1aJ14di2n6/2qKm1fvy5g=;
        b=GZpTv17ZPV0I7erjgSc2PdJImUBaRFNh0UCVL6/rzJBfW622XaI+icAqi4PJE609Hk
         DFjjFLHH23+oa7ckXOb8536IUMhHrrFcNYpU8h6nVx/G/YAhwiwQ771xtrjCyXo+LghA
         LxzGmSbg8KkNgQa2OMwMnQAxZhJ1zNaGHUP+S7y9f2xjYxS5r1yaUA0HuQnNwuJwMoUk
         mOmST6V7ONIfiFNLa3GJZbP6Ww0xPvmxUA/kJYgzm1Lv1fcziu6Hp2bThC9qYlDZSG2n
         yoy843uP1GLH97O1Dz1R3o1eV5aXPcYY6ZYfYMH99DbbpazhMHVD8E8Xm86+tOF3GXOZ
         wqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769182349; x=1769787149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M9XNHzU4slxNurpxQryfak1aJ14di2n6/2qKm1fvy5g=;
        b=JtJq9tN7QyBRl2Fdv9LwyHpYxnpXiAtVw2RblKlYxwmYT/E3m5XU2LJ2o+IfbwoVYq
         kbmGGvuugnUEjbwMW6w1ZeEtGhnwgFqL3OefasaTURPiw1qC51INsB5yE+s70rP1N5+8
         QW1mkYiyiI9lRNfoC6OtM2PY3AhDonZeNTL3M3IjkUhpEnZ+GCW8OAi/qs4ih4YBsBgc
         uZizJZSM75DStxA0r+GjeRtrW5QKsECmNYomUUTZhKXEhjvP5RCZY5JPxctbf96c4tu0
         6N40aj1gAiSmhCRW/Aq3EP2YXIB5Ik2jv9xqUOi51UYROFNY6xzoA+LK7fRnrw/2MEHP
         VKnA==
X-Forwarded-Encrypted: i=1; AJvYcCXOSJG35fl+Ddz38O+i8QhjxgOzj20OtEr3V7dcR7YHeCkHdQ5lYkI2eyA/wMADmqTkgclXroBX7Q==@kvack.org
X-Gm-Message-State: AOJu0YzOsGsLfo5tgQ6PH9MKMpawGRceUXNXCNiRPxkQZD3queEX38RN
	rEajSTia/usOfe4cQKL3oGgJ735QYa7YS5XprU/eyRKtohRLoCH/Lp1L6NOO2i+lxunP3r7MePh
	Fm9X8qM3VZlq2xLz43IUmUu8RJWHw/1M=
X-Gm-Gg: AZuq6aLH1QMEvrlOjX50xsOZJuFArjy0EWfEXjq7GK5sindKdz3KirWZH6X8NoPQ4l8
	VvIoGG1dw+7jq3RjcAf1JMLpz17aRY/FZOvrRDXK/UlwrT9I6FsOiAhKVZs0jMffAmkHp4oxVR0
	WFLXnDH6QUXel9V5cSJGBipzpLx/IZVZKjSgguwnxtDWQEYp8MrPr+5uh9d5YGT79XpUCvvXCfz
	7E6Bf3xR2jv/vb24k8t7t95TABmsvUz5lCh6sMq5jOsIQ10ZWWuZDgVMiV2iOjwuOCjTRw=
X-Received: by 2002:a05:651c:221f:b0:383:27b9:caae with SMTP id
 38308e7fff4ca-385d9e8d33bmr10623171fa.9.1769182349239; Fri, 23 Jan 2026
 07:32:29 -0800 (PST)
MIME-Version: 1.0
References: <20260123082232.16413-1-vernon2gm@gmail.com> <20260123082232.16413-6-vernon2gm@gmail.com>
 <626132d6-360d-4655-804c-f36220b6f669@arm.com>
In-Reply-To: <626132d6-360d-4655-804c-f36220b6f669@arm.com>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Fri, 23 Jan 2026 23:32:17 +0800
X-Gm-Features: AZwV_Qgty8k11Rc1ezHDGCFf0PVzoc8tMrLtbO9kqxKlT7Wr1dmYyFI2t6G9nMA
Message-ID: <CACZaFFMJkjoQP=w_nCJWicvTXT_9Tm1TYcYYVUiS=kbVmwQ_uQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v5 5/5] mm: khugepaged: set to next mm direct when
 mm has MMF_DISABLE_THP_COMPLETELY
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6014240014
X-Stat-Signature: uq8k6i9ekxzimegcimyo4t3y8k44m1sx
X-Rspam-User: 
X-HE-Tag: 1769182351-877016
X-HE-Meta: U2FsdGVkX192SZbH6jKbwGQ+YzAmJEpX6wzSd9WIOpC+1DCTx1nR2n2kANN1gGg0Jz4sl/S0A3ZkTCqgWdy7kCIy2MdrIk0cY2/wmr9POAH/YCOEFuDILUfbrVftxBBkPT427PQl9owB3ZRftq5BHztGOqqKdO/7JGPfITAiw18B2Vi+aWUci0Ue/gpD/hzwpm+BZFEsSxKCbDzVmeDP0ktRxFBp8FTLr1ZnBH4rrkgVEjrkP9zWIK4KH5F/O0kppsM9HJG1obG8JAel944ePPDDCDD0cUfwbfqY2lWwwgkfzfYtJQxZBmYzbEdd/cyGORZdR7BwTsevTvmXmPej05H6O8aMoBiIgLUbEMRnSS8e6oPty6DVXegUwXPAXdqPS41NdgIzEiQRxsu7cA32az4aHnnqlQO88QY7hpRY1DTV7wSJiPjCu7go+yDV+Kh8SGrDkrIhwfWVRngHfsCtV2oMA2izpW0cuWNE3N7OkeHnSAGIJ7igc6QgrQsoAHqrZdZjijuoiATU5QUCDwmCSYpFbTBzw7Zb5/63Zer+HnNi/SpUfnjSW52eIWt/n/zN3e72Bh3BB78SLGqsvBLv3sOPpOWhrNNyPUqZ7uVBrnEra6CVBlCsXuukrYV7Lu3UdLegFIXTQg6wu9j2ehMLdLYAOMTB1M5mU04R4orHA0KSbybVS7Icl2DJunotoBOxgLfPRYlSW2ereFfoaLpKS/v+2zy5b9WgNi5Q/InnxJTb9BkQhGrbkEbS8PFS6L557euWX3u03gd7B64EPNMnxltM640DMlBhn+UvdXHfIEQ8tLKkPFr89WXTWEAv5BlFjrBANHL5u+m7qXt682TLnZpfhwr3Pw95y1xSeDtt9VOWWLi3LoyneOrwC+g6Fd4Rz2C3FdJ+3NY2OFZyx8xvInG5COQUjIVcXNkxqFoiznhKHohu7wOf9fmUbaEHVcxuBShHNhKGlSyQaZsx3rU
 Cadl5CSy
 cy0hFREJvGrbEHQx9OpH+I4wvjyTzUvpMEem0cBlHGrKbvbIFRgzj2uFhGA8cwfAdLstNJTtaLMtFNoyp6YSF/mkGwEbep+/Hz9qnFVLFij+aFW7rtbAt+SBwDFdyiZo4KQSxmPkUIptJ4GIX9qPRdmMBrnNfgeYgrYzx8F6Zk+hCQ6kkbthICvChcWLhGypVLOdVTn/phqMK5AiM2cp+wbKdoSGCpX/r4mB31XVHYUP/N+y24vvzzcD+yIzHaeQhm5uFpkIUwheJLXjG4pADgrvuYmcRWVhROKtMfcmTe58FHcgQ/VY4Yde7tdl6ymCOC0jwTGRboqi+HsWclmRkSqIxWTkQiqDz6D3+iv3CpvVHMcJYyjtYy4vUzsMZC/DXYKSJkmiWT9xD0XBlyOVqHqSf08bcniKwyuijSv2yPZZ7JZ4ezJP6oehzwXksyKd4G8eZ2CMVBxP09BuBPuB2YDuosyhjcMizsFHpzSW8MnC5YOgLYJe9WmC6fuMi6dh+eGUA2GXU2E88kIvvHc/SAlIRrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 8:40=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> On 23/01/26 1:52 pm, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
> > scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
> > reduce redundant operation.
> >
> > Without this patch, entering khugepaged_scan_mm_slot() next time, we
> > will set khugepaged_scan.mm_slot to the next mm_slot.
> >
> > With this patch, we will directly set khugepaged_scan.mm_slot to the
> > next mm_slot.
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > Reviewed-by: Lance Yang <lance.yang@linux.dev>
> > ---
> >  mm/khugepaged.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index be1c09842ea2..1dc19c1b1f97 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2558,7 +2558,7 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, enum scan_result
> >        * Release the current mm_slot if this mm is about to die, or
> >        * if we scanned all vmas of this mm.
> >        */
>
> Need to update comment: "...or THP got disabled".

LGTM, I will update comment in the next version. Thanks!

> Reviewed-by: Dev Jain <dev.jain@arm.com>
>
> > -     if (hpage_collapse_test_exit(mm) || !vma) {
> > +     if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
> >               /*
> >                * Make sure that if mm_users is reaching zero while
> >                * khugepaged runs here, khugepaged_exit will find

