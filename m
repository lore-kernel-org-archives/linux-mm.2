Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD44DCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 16:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173F26B0093; Wed, 10 Jun 2026 12:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14BB36B0095; Wed, 10 Jun 2026 12:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061FF6B0096; Wed, 10 Jun 2026 12:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC61E6B0093
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:41:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0B69C10AB
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:41:33 +0000 (UTC)
X-FDA: 84864568866.24.69F6E82
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8C6EC14000C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:41:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Z/YoTH99";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781109691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PT+PY78KXxofjyRxno52RBKQ5jXbpc7xwPRRoOZh6d8=;
	b=8BLnrMSAhDqz2Z+/I2YOPdjQeo+spzNqWbdtpXuHjQJBpUy1HEsQh5gNyXONRF7ge+jTFv
	LCfxs+EETXNvYKVDsKyG2+ht1pNfEKiLJoA6LVpwYbVcfVUd8BnxFsLtEGj7upK8a1adHE
	4USAtDjPlmtfHLU65D+o/vAK6OJyBp8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Z/YoTH99";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781109691;
	b=EQ3OhMm8U0R0q92Eo6UXdf978kqY31EGBIEWsZdINn7AsRE152GdsK+me3UJuyqd7poWep
	RHWNKN1d945O/F0i+Oh1PbFmIs616K76N4RvzELrrD8kcJePgpBodKCpc4mn4sSuOVz1EA
	0tKEE3/2ScPM4HqGjYXXcXiuyyrmsdI=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-45eedc94d37so3626027f8f.3
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:41:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781109690; cv=none;
        d=google.com; s=arc-20240605;
        b=d5e/w7H37pnvaFdFHk1ji1egcLlGaE1Wwuwm67n1u/n76dOCf9QhDdi0MEsohWy5Dl
         Rc1OASWbqH6qBzhNRGQZ9eczgr/jcaSlIs0qM12nqxse5BGD0+Yamvpm/quTN9x9dWvW
         B7s95PsFCKU/toNr9BZaxno2iAGFS117kHJy7eaBEgGMRzj4rM5x6RHKb16kwY1IGopU
         he9qexmrZywz8rzhHIMzuB25qzr7qfC6ystwLX0a+uUhEVM9ZFRa5jPmtFjdy6TCfDYC
         uHFe0O5wDSrHteBnHeHtCueA0i3ArFrHjl8Rf8YW96kSKPQHQc8YOh3y2ytht8LBvvgP
         xTEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PT+PY78KXxofjyRxno52RBKQ5jXbpc7xwPRRoOZh6d8=;
        fh=v5GgzbAHui7JPoJPzf4zO4Tw4c31tbdxoQN3zaV4NS0=;
        b=eTYkcivv5Ye9foutT4v6CIy/9/jkef5aT7ZaJKRtX662GkA9z96AI80fySdj7DFLr5
         zw6EYHp1GW/rQKcBc9NK5OcXKE/vAKr5JiEepP/En5KS+E5C1uh3y2oZsjX7TYeSqEYx
         S7d6MnxHyglMs+WpZn42gxEpjrC+RfENnEURK05yAj3pN9bSI1IUbZ9hQjMJgeGZHOUu
         wy7N7zfr0ILKMu0k9AiCd2juM5SSt65kemSGqixADKpJ8Qzubtnppzy5paI+rMVNZSrV
         1HYZPOIBUtmgtCRQuun+S+Hy/8B/OhDaahdtrkArqeoA7mBkSQCYGEmjb3ib6m7ks35e
         5pgA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781109690; x=1781714490; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PT+PY78KXxofjyRxno52RBKQ5jXbpc7xwPRRoOZh6d8=;
        b=Z/YoTH99LQ7FtZCyfYd0s2qhee3k0YR2j3RWnPmckzhn5+DBSiE5sYHNUJJ/1z8D0J
         n9I2fL3NNboRbDh87/voJptiFSzuwuHMSa+t0siYvKmf93pyVwZKe8e3mKqwiFpTK+Fy
         vJHAnrNiUkj1o7ly+3KChe8r0T5AhBLAzAhkR57egONJ1Q62Ix4/2ch2BVxbAF06pHqh
         F8V1/KljdFaRHYIc+sU/FDe5aXzZDLWa56AywvQ9zP2Aa43H49FD+EZG2T50KLwpySNI
         agfiO4T3/Gjj+0lPUHl/Ca8Td0ztzX7DmjavPNvfPcsojeUWvKc6EbQ1vfldktZHV2uM
         bO1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781109690; x=1781714490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PT+PY78KXxofjyRxno52RBKQ5jXbpc7xwPRRoOZh6d8=;
        b=farqxEB4YmKAJElz8h3lhZOdzEj9Koc0AD0qkmf7Viq38eKQcU9eY6BP4vYdQLw1jb
         sXDeyuM9w2F6mZUxbwMMRweKP/cEF0ArnvsobuH38B8w/cHMZqS7lv/97byxDHjTL1Me
         MxGp2bFYK10TvIj4CqiLaGetcKRCCAdfu0xQSUTSSI/S5BC2GkIReJFHouPoomN3YnU/
         DUDnREmv/o6VUM55X6up0ENWgy77Sqk2DMAttcrCCCqNEuIp/plX8ln3IwhQ0clPOmgM
         c1BeqnJh4Vv89ogt0cFddDmVUTIOG1IxjM+lLNoN4KSDWMRKYvemfZXFiRPKVoo9OWir
         Snww==
X-Gm-Message-State: AOJu0YyhpngchNApd2kNSVs5NMyJ9k/iV1+VhgmPz10aYb30P/E9IaYI
	Xm0maEEoSFzNxhMyyzjkrR3LtQde54D0fCR497DZ8YqNoQZCpyM1SBqfcgR1qcMdwq4RQROaxfz
	S6sN2ZfEW/UdW3t/w8/Y8u+NBkOynZT8=
X-Gm-Gg: Acq92OFRn5Gpmzr2Exoa2iJGXjPkur//wuFrYdmQk+ojbBUgTWdvIscWMf1urO5j4NE
	HhrU6AODOz0dnXJ31DNQfIdgJeeV5dyHMGt+95yxKO8nHoxmcGw99P/WqEsp1bIy7nl36ik0fNH
	pSkyqloovVMK+TxCPC9LmFLnUww6XwLvUoo/WhLIUvXT/qZ+xx5Tp2NC64JHni6027F2gAFJzJm
	zJ3A6OkPuo6Y6k3I9IsUtvZUGJxfxb+5JOFTGBt/rZyX1a11/nD/zjPr278jr8g/cdw2dlx60sn
	vJF6fnH4sdTrMntmMsEsQY+Lv++OEairnohvkM12kEwxE2NfoS2rF36xjeuWkBbSVQ==
X-Received: by 2002:a05:6000:178e:b0:45e:f52b:f4b7 with SMTP id
 ffacd0b85a97d-4605668e61cmr11443793f8f.17.1781109690091; Wed, 10 Jun 2026
 09:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781000840.git.ritesh.list@gmail.com> <68591daf0d679e5a0072d63751f187d14613e2b0.1781000840.git.ritesh.list@gmail.com>
In-Reply-To: <68591daf0d679e5a0072d63751f187d14613e2b0.1781000840.git.ritesh.list@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 10 Jun 2026 09:41:18 -0700
X-Gm-Features: AVVi8Cd2j8ucYOyrC_mYn3R-SWWpqfSCH5PoEKv3S1kL1-SjdJ4cmU7YlrR2bZw
Message-ID: <CAKEwX=NCB6yrf4Dc0yU_CwZWi0Kk3tBup7yvP7EUz2k7_CR2RA@mail.gmail.com>
Subject: Re: [RFC 1/4] include/linux/swap.h: Remove unused leftovers
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8C6EC14000C
X-Stat-Signature: zbthyyzgazysao9s7q414w5fkanhojwd
X-HE-Tag: 1781109691-445687
X-HE-Meta: U2FsdGVkX1/uT6WqcDUKcnOYWGClI4VkP/9Lsxq9kXdJDkR4rWSbgrC5EpqPHztIf8hunxw4oaG2dw/N526TdRHopI8/vmsCnIq2dNv1mWgdmyvDeHRA8Y7dLJfFXv4mcekzvO8LdtCNb/O3OEfa2SI7by1eS9l2gJccywblENIio3ZC4nNQyxBGJxK9ldZFTEd6+5PMMtikOaxpPv521n2fLKvu65UKN7HxuKnqfEpJhEn6mCHL6riEdKaMEYmIRC02ERdEUyXrEbdTAKYzjQdjs9DsyN3SQUdnYc16nNZM1N7jIFiTpIkPycnYgaGRq4rms7OHnVF5oC/pJ2ZLDoMGk1uJ9GbUuWc1pFSUmZXI6lUQU7VOKLjLxcIoLbTInoGvGZD564tnWCd8EspLxg/E2Ff0IAOrIHQQ6FlRHJXtWI9QJ9GoFvhplM4cOkFFDE3vscQEB2ozhm7DrRFXXfGRdfTpypErTLIrd2nHLhZ3m3YKG6yHSP9pnKyFLtLdkJbSCBh1SEwNiqMC+cSUhKuLtdzhe4zXr8+38VRNxoWl98Wkt748/WJiYOkCSEKHflIpoQltBjVpb3GLdPR33wGyO4wrL9UeDddmLsbOPpEsf5SAjrX4K8dfIfaBjXG7E6ubaUYy+y4kABuGnFYvADaKrjvqNAe3KciJBvST1M1KpMVMznAo00MMCUBKgrLUEcLsA9Nbj631LLWFxqsICMGVfu/WTRmRGgnoq0Vj7zJWUNwvWlOX7wFlAXd32QB+a1Ou8et33i4/u6SQ7Rf7bqBz1d06JwZC57Udy5BITmK0qNJdlzUnz5xgHNyxVUp4B6Te3nzsgHEAYPYq/OE4GZQ4HbhOFt193MiRs18d8PyYygT+0H1rkxXFpI2ASPVonmvhAf6oy9THtTJRdl/P77JbhSkk2sx2v3X8aM2MI4k3X4mwr5SBAxkempJS6olJqbFNd6hPpKL8d+obaLW
 fWbLB3vp
 Qgo3cUA3eyFS/YN03Lr+ULXxCR65QRkXdNnrj2xgHlJNzznE0akPfsmxqvd/UFgmdw1ZJxg4DD53YohS+hE6CWqCTm8+GRThZDYMhfAQaLCojxr/0huBbUWPp+v2tjUYbNZ9W6o+B3wWk8BKlO16OC3W3wHGE8HcdS5mYs2NaoaoTqikzpNQe/SpWZUFen7cykBVgTsLi63yVuWNDcFTcgXn8mDXqA4LNgrlbCIpOwTI0+E0r3OO/Lhs9U52zjm3KdyPsXXPJgUhKEjHi2VN2qlXqoilppOOuCKLtZmwLNJ9qe4Mr64FYjZCDpTIFKcy+ZDn8O1+medE4zyQxlL1zp+Oa/F96fHQ00/olc+sOTMwi2TkhkXIfx3EdIkEeNSyEOIHGfr/MyRm87TN7F4wxXpKAFEy5vQoNABGuC2ygeck+Iq3bKuNEHj1T2uGiudPOY/2DlReUs9cyD2quuZ+6XOV5UMhOZ1rRCQ/GtB2bQC/JacaoytghYbuXWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 6:20=E2=80=AFAM Ritesh Harjani (IBM)
<ritesh.list@gmail.com> wrote:
>
> This removed unused leftovers most of them are forward structure
> declarations. Also removes SWAP_BATCH macro which isn't used any
> where in the code.
>
> Found these during manual code review.
>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  include/linux/swap.h | 7 -------
>  1 file changed, 7 deletions(-)

Seems like this can be submitted independently of this patch series right?

