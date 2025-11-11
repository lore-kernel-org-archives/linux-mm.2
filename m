Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E20B8CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426768E001A; Tue, 11 Nov 2025 04:14:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6188E0002; Tue, 11 Nov 2025 04:14:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C57A8E001A; Tue, 11 Nov 2025 04:14:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18C1D8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:14:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5103140307
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:08:29 +0000 (UTC)
X-FDA: 84097750338.24.F2BC110
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 133AD8000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:08:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bFAFJ9It;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762852108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+mH9+7PNLYr6Z/2ln9TuMbRS+qcoVyhy39YsWeg6dI=;
	b=gJMJuO7AI2D7QLIHUDL3VAsOiRdTqUPQiAgTOIsQLo0DSW4b1QFvqohwxdkZE8781ttf8J
	upOxmnhimsDUqiJyIhXu9CumLuEeprDiPsxFRszlzZpFxnpLXSZ3G60M5ZX1KoPqJ8E6QB
	wE6cfPwjdB30HEKQdGT2KuIbn43lye8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762852108; a=rsa-sha256;
	cv=none;
	b=UlE3FxywC8I3c6wFFUJ49XURuD4mZKxkQCPzuVx/jIkGWcBMvN7XfwVCFb3cwqwe3ASZTb
	YGL1EAQ2au2/vWeLI3CMKzrnnsFhFUIJvQt7CnRBpXZ6AsRfGrS7QdYO4CNZFDr4XGbOEz
	GX/5XeLdErKB8TZotPz9cCv6FCF/dKg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bFAFJ9It;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=glider@google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ed861eb98cso45651691cf.3
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762852107; x=1763456907; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T+mH9+7PNLYr6Z/2ln9TuMbRS+qcoVyhy39YsWeg6dI=;
        b=bFAFJ9Itb1xdUvCmZR1eP2MbsePSJltO3YR5Yo3GCHPQiNSZCV6Ck+zKY2GUE4VS2x
         +NSkt65tnY0Gv+1fPWlZlWS+D5eJDjCRAiW3MmbmXfZlL8LSXrH5o5g2F0/sH2hPif1h
         pq4j2cXSLddF2BXaeYEoyEu6ZdsE5tBrCdu65+sE88kfjOyVOAXU1Kl+U6YAWYjHrfwH
         21N07o2WHlfB7Q8y0Jw9laREidPGhwj/ya8Q/SCfhA/a0J1GIqrZVDGjOcTiFSoszyCb
         et3k8QNnfeETWQt5xjhgn0nkXoFsK7dACMGw48LaXQIoyujAqILEwYGqny8UjNMK7QTX
         p/Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762852107; x=1763456907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T+mH9+7PNLYr6Z/2ln9TuMbRS+qcoVyhy39YsWeg6dI=;
        b=iz4PaqDHqNDj/u2kIeExTsS60DncV/RrDKfMfN8BIthLw8uQD2h6WXvgcwfQeu2UJb
         REPCOTiJV+Lyf1sCU9NdzR29Kse2Z31r8DK44XhrDAGOL3Ez7OhPyIQC4ZNhIa77sa3r
         iEtXLLp2Jz860C0GVRLlv1j2J1usuHd1QL05XPE2EyyC9D3txlTJd1lwGA+pIqCO721o
         oL1pTFDaUkQqFs4ZBNwIu5m8zCGcc+9GJ4NLumkxdxfiFLb/Xtbbx4z3Z4ebVyMVMebd
         rk51SEXJd1AEOsQal53eG2LW6tKIrR6TYvRNuYBOlQXxhW/Fl/0MzFuERiDL5BdKVEAt
         BY0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVoLXfNllnVmih3EVsvw3IU+5vk/kr/KA4m5DaLTse9F/jKO3WVp0hHcRoZE49TOdIv7JflIMlNHA==@kvack.org
X-Gm-Message-State: AOJu0YzJsNNb7fcwcmbiyBT4ZS8kWj3c4J88CPi5POxGiDSqSjgCStSv
	Q4XCGq/6oCTwI8xT19m1zduB6+Ywuu+p3S4EmO9b8cICu7tvDMywCk1IIPQBHLxaFPTZxr8CYUO
	F54lhc4i/GS2pIAie5yieSbdCfjWxJnwCr6RDWtda
X-Gm-Gg: ASbGnctzSJlCs2sU384HnGglvIAV4uE840uFbkuM5Jci3lt7drKgGVvPk/piatTRjUZ
	wbla9a2UyBIfwJODfPVRkiLWTKQ0FmAmhhs2NGw0C0RwCqVkDYJeqUI/06cFCQIX9U64cGrduF6
	6blSWNclmQu7Bmy/OKQN3+gvgrQIIEs/qNvAyJv1+csXAlpxmpZQJMIut1Lri+VohJ7yuQYXivT
	yEDvkitnIMlIj+jN2Ty855Ivwal6GkT7fumZLk2+2hIuuBAcsBpx+vFNGuutInm2Bbl/Y45NqJg
	A7t86U3BUdBpeJ8aLnXzAHD6S1vXpBFqcIHG
X-Google-Smtp-Source: AGHT+IGGiGzNQ2eAyJqdaO9JyMrXkP7w+emfDXwZMPoyyY2gy1i/zUBgnLRf870LMq5UXpv/uG8YRTM2WfKUuwW/Bjc=
X-Received: by 2002:ac8:5751:0:b0:4ec:f4be:6b12 with SMTP id
 d75a77b69052e-4eda4fd3621mr141844221cf.72.1762852106635; Tue, 11 Nov 2025
 01:08:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <56d9203b1fcb6281b0d29b44bc181530e5c72327.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <56d9203b1fcb6281b0d29b44bc181530e5c72327.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Nov 2025 10:07:50 +0100
X-Gm-Features: AWmQ_bksKNIR8oRrvQW5ElnBBjqadCFUKWpQKwYmKonXZ13JEF-XHOSa5ehktsY
Message-ID: <CAG_fn=U3SLOoy_K-2ShOMYf80i4AE1tB1AL4w7wcJAXBxi+PtA@mail.gmail.com>
Subject: Re: [PATCH v6 12/18] x86/mm: LAM compatible non-canonical definition
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mukj6t9pfpdyuiquatpij84knmww9sh6
X-Rspam-User: 
X-Rspamd-Queue-Id: 133AD8000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1762852107-233153
X-HE-Meta: U2FsdGVkX1/1LVGhMjr0wRP6/ud0BR+lpfFhcGi01vZcg7Iew5x8HTQm4jOQLhFKXwF/5yYUFCyvGXmSycVT2eWbIdHuybxDitXkl3cZ59bmeFWmG1j9xk3c5NPLr9pFVlVaMVql61OfTh5VdBPj3SFCQ/bR8tlQgmFIY/76tuCdEvmSuBklUMRMD0fQ8E0l+P1KrvKargUCIiY+vgwVu6e/jBxv7a16oVTZCtr2Q5kxkFekyQGSGFBqtwFau8hLfn5LlMXo5bejrUuTszbPLhOJMRBsHZ6Vk35SHBkOydhQLwPlyJ8gW1noeROay6UaW/mKyikeXJkKfbk1jwOkWl0OanaocNXKr57Inoxo+wJIWH3QsIseO/Qd4kaizg2/hTRt4At2pDRs3T6jXZNy9L0pSecAMPOKs7R3OafsSNW62gBwaA0yGiNfrg6c6X0KHc4yje27f+mcqiHQ+6+h4hXL9UPjUU8BKhV4LSYIJ6sFPJ6LtkVvMLKkymvaV3kIQRXSbcvHUXtJLsmVZFZzRKpe3kq2khfH5TBtSiQTmOnGhJp5fdGqQmaQaBRYMIB7W1NtGGiRpbSDc5FX36ytRQ2kjMs7RDCj6CM8Iahn1v/r6ZGjguvavu/3fPnCYrEAiA38D4PPcWf6myGcXJYo7Q4e55RiTp1mxVnGVOuWPxa6SYyofHNdZgfVoHpuFYa43elaWGMTPqfSd3W3Z2q6R55gW5O0wS6bCR3dN768iKw+h+SozKJlPNimKHBgm2qU9Q1cS1Ad5eCvLUQgWOY8pTGWdJsvDV2mzQE8V9F0PNf9gUlqIJNMwM+Ca38nqtj7GKj0/HhJB4wqVIM1fs+3C5oTFJyyEVgRCVfHks9RgqlSb7amf8tmjzt5UqH99sO+HsJq3uutTW0j46IhQFtbUfQyUAXyXwHDEMMq/EWuSKtANZnTDm2At/cO+qKlyweBtn1JqaAtecZN7P2kI58
 R7wasSwF
 BCgivCZOG2Yi6HdjsYJ1B7YHLPRG2Iqh1alDixatEJR1IphC/JFXlCEp/x0K9IVvd75PBZkjcDcKcwFVvm7sLjLGDxKc3nEQR9qAZCKWgkRExN5Tc3uTvGBt91lw0FMVOVYcriNFaIkj1BVeGbJuc70+c0kh+7QhNj7XL9zjIXO8RiVE4U2cB6q9QaZFY/kK71Y0pwf49zJf8fe/y8XnIkctD3q3wRRnM9CZVFMcxAbPkoH0XIEoLyW0L7rb2GH5dcJqbgkTMjXIfUNG8PXdCBttSjiQxUpfylUe5Njewnje9exV2L2DwMmo+YGzPtUD0X2Wq3oRfa941vQ1o2DcJ1Hr8xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 9:08=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> For an address to be canonical it has to have its top bits equal to each
> other. The number of bits depends on the paging level and whether
> they're supposed to be ones or zeroes depends on whether the address
> points to kernel or user space.
>
> With Linear Address Masking (LAM) enabled, the definition of linear
> address canonicality is modified. Not all of the previously required
> bits need to be equal, only the first and last from the previously equal
> bitmask. So for example a 5-level paging kernel address needs to have
> bits [63] and [56] set.
>
> Change the canonical checking function to use bit masks instead of bit
> shifts.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Acked-by: Alexander Potapenko <glider@google.com>

