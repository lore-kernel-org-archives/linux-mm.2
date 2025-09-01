Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64126CA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DF1E8E0097; Mon,  1 Sep 2025 11:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142228E0094; Mon,  1 Sep 2025 11:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030978E0097; Mon,  1 Sep 2025 11:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E386E8E0094
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:17:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9229185D53
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:17:35 +0000 (UTC)
X-FDA: 83841035670.02.EEB1680
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6046C180003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:17:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=eQS23YSz;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf24.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739853; a=rsa-sha256;
	cv=none;
	b=K6Irfraa+HJJ/Ig4AzeJ3AiGZCy9G1lR7j0T3neT3LyBia4g70BcUwGutWrgSsVPa3EXPN
	4MEuKwAEa4fmwN9SEOKf2UK5xUkRtPYIu6O+LooJY+xUpUG2uiHYPnmIXDtRH2tdm6sbHh
	wTIq2nSyFq+9csM5ZeZ2GGI+NNuvJVo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=eQS23YSz;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf24.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVsve/IFMKMWGwAEF879SRkVfMnyldOnTnxfs/L/xuQ=;
	b=yO6EXxMfEa+QHT+ubdE7yZtN6SW1eqfMWkxZT1BM2RGvWe0XB3s7S2pPVX0b4Q48yMbrOr
	6/hPyE2Ykn9VExqxIO28yGRk2pY+B3tVs63/sCPJgptzpxEHXSXC6BpwvJ0YIrpVPkxKKh
	uArEF4B522wuhcoQRGC2wy5gdatFP9w=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b042cc397dcso134851966b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756739852; x=1757344652; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVsve/IFMKMWGwAEF879SRkVfMnyldOnTnxfs/L/xuQ=;
        b=eQS23YSzOkf/6E2z4WPPp5VFiKnKzBIHLzZH8O/+usrow3e+WvtsPH+AuJB9Uf1bP0
         0Vt6G1V/dez2GteXipIxJzD/SnLhOvk/4XBQ9O1QJynmb/VPSnwe9wBnhmPHYJCyg75E
         lgx4f8paByIwf1OxUa5HjFcSmKb9Y1X8IKMkXVV/EVF3YiO5uNnHT1WdhceCRlbdmRMz
         x5eodtW4i17UYnWzJxWMumrkl3gG1Z0Wv5oMTRgDnCx1Y6+tZvDWagveuFEf7N/YUBAh
         MAgD3X6mnJRjDC7z+kW8NZHHtz+eZiPVkkcRUrZhsTjDoDBC23vegp2vSiOwxwOEz6Js
         hOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756739852; x=1757344652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVsve/IFMKMWGwAEF879SRkVfMnyldOnTnxfs/L/xuQ=;
        b=UgwEySDCsvPdc5XJfV1Zkg0nEMn2vRiCaOUdAxKwU850Lr2AwI7oDsWCiKwW2VobJs
         Zd3VWKyivaAZsYWckikBISWgqNMSRYQf8aEQw7tl0LTAUkve4SvpA5YeGjJaqPojKmQz
         +0bCQWEOeRmXr8qp2Q2adEOcv73CLxK/vKsVHfm9MaIhgTPWYb/rLlWnbMuueyGGsYDx
         7bZijkdfDp0kLI6BZHJaXXbSmm7wabmMDxhKLZGODRC0qJoQTpORaooSWO0L7Die7EdT
         +CGWX6owEUG914TGKimVmFccTlL+Bqcg+zhjE9UQzroaM//pHpRakLaSFZFzMBhMqmUL
         Fwuw==
X-Forwarded-Encrypted: i=1; AJvYcCXdQKxzCa14siUWDL3MT0fxWQERE1E1w3L1Zx1dMx1K5qFawTBpqFXy/ix69Oct17fFtgK+VD3+fA==@kvack.org
X-Gm-Message-State: AOJu0Yw1DyTgI9zJvZcxAoI87Cw12/4JBKC5NkULommW2BgmMGDL6G5g
	YHgeU3wq1w0gasDMlSE6a8Z+o3aq1lsBdChljdVrYNIKT2bXm/dFZ1BraFayTX2yql6BmVwB2L5
	j7NUn8BNfWU7sLcCBli9+X+fT8HiWeY+1rT08aqBPjw==
X-Gm-Gg: ASbGncuD0v4wb2+GwTeVxrWtWhQdJm+vAW8ZHKOGfQ/Fj1XAqyAVD3JosPUOkfOWkZ7
	eJKY413/B7l3XjZqc2XeZcZhuaTKPanFfTa+A9soR3oFHakzZOl0rHDfDhB9wbUYvV/L0KpvWYq
	WnjGLN8ZyCaHm3U/XZkNS4D8xyfA+7E5cjjK2kIk6nmoZO9GeFD+NWzqyHqSZO3+/J48/tl1fiE
	BNnmsBAsRtap7wB8OTSVlZxTz2rupoc9NM=
X-Google-Smtp-Source: AGHT+IG/xTCJ9bj+alHxnm8uZcbqfurR+IyDtwLk2ZtZW9b4+JSGWCUUEu7vdYbFqHJ+Zaxrj6LPdykdWiyzaO+0sH8=
X-Received: by 2002:a17:907:d8d:b0:afe:5c9d:c7f1 with SMTP id
 a640c23a62f3a-b01d8a8b328mr935024266b.10.1756739851758; Mon, 01 Sep 2025
 08:17:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-12-max.kellermann@ionos.com> <081a7335-ec84-4e26-9ea2-251e3fc42277@redhat.com>
In-Reply-To: <081a7335-ec84-4e26-9ea2-251e3fc42277@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 17:17:20 +0200
X-Gm-Features: Ac12FXzbdsR-8kES_4on1Dew__ksXVksfxEkYJjm0-lwqH8RlE2IsInEJr70z8I
Message-ID: <CAKPOu+8xJJ91pOymWxJ0W3wum_mHPkn_nR7BegzmrjFwEMLrGg@mail.gmail.com>
Subject: Re: [PATCH v5 11/12] mm: constify assert/test functions in mm.h
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com, 
	willy@infradead.org, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com, linux@armlinux.org.uk, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, davem@davemloft.net, 
	andreas@gaisler.com, dave.hansen@linux.intel.com, luto@kernel.org, 
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, weixugc@google.com, 
	baolin.wang@linux.alibaba.com, rientjes@google.com, shakeel.butt@linux.dev, 
	thuth@redhat.com, broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com, 
	mpe@ellerman.id.au, nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6046C180003
X-Stat-Signature: zfcr6i7hfmxgmrqpsorzo6brp1j7jpdr
X-HE-Tag: 1756739853-667765
X-HE-Meta: U2FsdGVkX1+q3f/nAl5piB8HcJkXB3I5WP+YSVtXh4KXSxUheMNvpj6rE+CrGgMQXSoVZZ1yFECAbeffux3iP7D40Q9Rogji177BIAsKZ8Otfpnn7/jeYi7b6CLCdSpkQ15CFw0Mo6QofA8UcXuANC1k8Y6502pSPbPmRjBzioH3N/XMnzIs1MOdlht88vxqol7WBpBe9AyMk2eUxgSTlEbbdH44iDncbYflb9dF8IDQhxO6nb1y14aXkWcrralzZIZU5p4H4goHz/40RscRQFM8tk0CnwTqq1+3ecr2AfQw0rZHCv3TYeFsEL21rPLuzyuWq/s3NmLDKgfw9Z4Gc6SL0Nf1cy/eJ5CnvV613qZNGNF6TXIF9qgjDbpISCJp1NJldHcYQLeVK9LPvXs2P6vD0qnXneLkgNUvipRuA0+3MWL+KZcOx7WX1JkdQ1MLwaIus88kioUS+j4zihaqHkZ9Pi9yHAPEpfwyJRgevCsgsxHGZu+feUe4TE7YwHpKiI+ylYFp7Q8a8Fy4z1CFj3khE92yyxIAUbUoyCwQPhuMt6JqJukQnaVIumF9m+gDbvqKmg1DLJa0indsCvnHdDuWHJ0O7Ze05BRf0nCVUtgu71KwvtZ2ZM/F3zDU+f+WKKHgvy+4La8UZXIJE3BSUrxlYCEIEdbEojYOM7VzFyLHATgF105T5CnmUdS2dpTR/Tje27S2n1+sdv9lAYQ3C0lnK8z1XTME0puqFw5J2z5RFu2FAKPMmFJ/3K3t4CeLt/eonMO3r971LC+vtNifFgaE5r6iP1BrFjtWjbToVJ01sDaEG2xTEsC2DdPqGD0XEw5jvqMBcqnvkiqxsSNYhhrqb/zQHlr/znZ3IaXMaPVHSX19jyawbQh0BgN/R3vuwmFFaATrIuXqVfugiBKdMytM5JtaLrh7/TlS5WFJFSyYve0xgnWSKMGJfUwzYJ3R/3mUN+uYWEZsYf5lvyg
 1hugENZn
 xqCROApAsEJ6vH2ss2kbj0EGc9MkLqvwTVgGN0I5YmHJURXGmp+4FgPkKxPyMRN7WbH1sJg9PWQXLxQqGHDZwjfgtIwH8A3HoMoAvEOjcjitNUld3Li3yWvtGRbzplnoIaoUbPVKRP99z2Z5h9QyeOVJufIHoU90M9qvIJGwSnSPH6kgaSZT30kix40NLlR5OwE0HoCdreygEn6V45OHd5pP+5UNd7fQ6FwJ5FdRHJcudG46fJgT4erLsrfwP9bwbMwh9J5qfmL66FZgm9JR7mcUKHHg0YrCD/kMqCdAXBhI6oYuoIYpGm8wNsfDv+NEj+39R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 4:07=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
> > -static inline void assert_fault_locked(struct vm_fault *vmf)
> > +static inline void assert_fault_locked(const struct vm_fault *vmf)
> >   {
>
> This confused me a bit: in the upper variant it's "*const" and here it's
> "const *".

That was indeed a mistake. Both should be "const*const".

> There are multiple such cases here, which might imply that it is not
> "relatively trivial to const-ify them". :)

I double-checked this patch and couldn't find any other such mistake.
Or do you mean the function vs prototype thing on parameter values?

