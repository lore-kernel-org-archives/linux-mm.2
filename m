Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 364DB60A2607
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jim3cql5
Received: by kanga.kvack.org (Postfix)
	id 588536B05BB; Tue, 10 Nov 2026 13:06:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560916B05BC; Tue, 10 Nov 2026 13:06:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4766A6B05C5; Tue, 10 Nov 2026 13:06:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 212AA6B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:06:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0231A8586
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:06:29 +0000 (UTC)
X-FDA: 85419989298.28.18DB4D8
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id B0F41100005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:06:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Jim3cql5;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfoLXtHqjGBdWNvjzeRsPhMhyNnS9gocssbFMuTMFA4=;
	b=6cnX+7EXU+THGqbCg9kfEnQQBFM9osbJ9cQN7CzCpY2v5Xz47vdLLeiCJmuUZS233mfbSq
	8WIKA63IbScD06CEgmAJoGJqFagQ3gxVGT8sqJJUSnXfd9YJ5IGP2HYon7vBrizCZjqKwN
	+2kDpYNaw8mMd0nzcO0UM2hpk4+a96Q=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794333987;
	b=P7cK8CeHFh8qeEDgzdP8sDsbXxIEqJV3RZAQVUE0Duw4dOjaofnjMEj6aVKVmPuw3ZIMdt
	pGZFPqRhZcEEnmH50QHkFxadT1usKOYZKXxaoihLEEm9z83X5j5DlI9r7JkzEYrQC3Jp3E
	Qzbt6oPhMRQM3AxnYjyAlcHVRhaGT2s=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Jim3cql5;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3ab27e45e7cso17820371fa.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:06:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794333986; cv=none;
        d=google.com; s=arc-20260327;
        b=TkBeuzCTIIlL1s4errCWV8Iym6LHchIywOu9cP/YwGfmj4NXflMSsQhzh89ydQoba0
         1NIIyT3fSfX8OTFbA0qzNw69oNT0osuOvgLoYbJwoLsXhsBPZxfh2XFLhAbmHXKamQ2K
         j7wCqWUXcfDFMPYDVXmyvs/pG1uwmV7Ffu40C+hpKaS+EvPqcfhHUI7dg8Z+wY+CubAR
         X91/jODArpaDvdAxPU2NN7PTwIitRxVIeJBkSpnWDU7wiLkFyNcnP/HQurfMA3sfnIY2
         VawEsN6/62fHBg8rxvE772i5k4hz69wI1LnqePiNiFX0tWb/b3AXdrnY+BEeA3o62NpV
         k8PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SfoLXtHqjGBdWNvjzeRsPhMhyNnS9gocssbFMuTMFA4=;
        fh=g3avAnWEmTFYvZJWWJdd0H9zfz1WPUbxXFzgcHY1u0U=;
        b=cV39MbFhoQz01La348TXq3zrRBWyQXlr2ymq2DLZco6fXfzA+tFzx8hcbJA9GpL84G
         LKMgzmG8m98ZAw7St/XWIjsuZr/+OQkQTp3fGe8qvL9hymvQZURTvHFE1Vw2fR6WZbjD
         qCzEKcagnxOQFQx28krUpm+7+sLCtGlAvvjP++u0gg9siPfQbuiejNsqUGqoz4z0PBUW
         2dzahF6DWFAb0bNyu3i8l/+uOpgW2p3gk5jby2Mw705oIyySkdLOVdLK+6sNPNkBPePJ
         8i3DRDwqUUjvJ5DIyCiiXe+91JQR7pYSPs3tVPgMXZus34Cfr7is/L9lDLeDDLgvumqG
         TfFg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333986; x=1794938786; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SfoLXtHqjGBdWNvjzeRsPhMhyNnS9gocssbFMuTMFA4=;
        b=Jim3cql5lVic5sOsCJONKer+YWuo5cdJ1Yb8hz/VYm+PbJzLSEzv0nNEJSsr5SN8X3
         K7sWISxryejY7Hj88799tegfhIUI9v6jqVXYN9zJK1kcJjaMfp8rR6U+o26zJpNFSRkE
         D5WwgnhCnOWauUrPwCl2LqQU9Bst3WhWPZTFWr7fYngANJ853m59s/pZs5aTayE7KWuO
         aHAGwwqh60TGUsRtl+ZI8vp0fMnPfMIvDjpIzCuuz/r699iEJIQJdoB8YCHGnJnCzRYv
         LeRJq37aa8jVI/7eJAP/QfRp5Uj7lc4XdqDTDLqrkW0KM2cpOoZ2qRbtwb1XwlsX7fuw
         d38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333986; x=1794938786;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SfoLXtHqjGBdWNvjzeRsPhMhyNnS9gocssbFMuTMFA4=;
        b=KDA66wtK0wWnQADN/fJksn2qLfPnwq4NHrD8toVv6EQVdu5pi45Yvu+tqkDm/P1f8L
         7koINmHOq+V1+SQPJdqgkszmfOuq7Ckr3YxSVBq3I+CU6CbGuKfdB8X/nQOkx7OLiAN0
         WJ+0TWaVq8TzRCST1TdWlg37OL1lxDkeNJDr2POmIEqyVC0b+W6aphn+eCUwtIgAaTNs
         VQTxjrLd4kglvwtYijDk2BhIC8Mtw/lRzpswwwZT3qWbM0Wzq+o7DhVGhE48JpRXzpF0
         2UxHreBjmsPE0Oa0otGC6lvsTvaY9P2ooBH2DwmmVyv1lBmCsh5oAiQBps/7RC0ILgEI
         ZXRg==
X-Forwarded-Encrypted: i=1; AL+hErGmHf63imtFOD7RLZAJ7ZSdkZ9+eJHTUlIxc+nj3HM/CoE61nLytJI/zbFSVEPi9zZkO11j9DRaXQ==@kvack.org
X-Gm-Message-State: APuU4Z/Q8zb7BupwfXqXnx4+R9cVHIReGTPddB5NWv9ZFYFnNYeIYuXq
	tnvGYPqmRq1GeFS5Dqtqbpisly4Vkg2sKFiXIWhO4z3NtKA54yGG1UYt5OLWMc+ve2R79CiiGOe
	MXSERmI48/RXVL3AJlMqYeMxX7uaYgKM=
X-Gm-Gg: AYBFou33EJK2oXzJ/AjOStjcLWhBvROUaalidkREnR+tgyPXBTnBXoKdFuNXAgE9Nyv
	Dx/E8rOeodrQx/4+tgALN3j90v1SB3ItLMEpYPSyOvU4ckoHw2Eiow0kKdspKqLJ9v9nuEbcxTA
	1nIwraUD7F/t5EqpMaPhuySGjAYg2Eac0/i2+kgBzuabixH4wW1tGROPSVpYhr1ym3CV43noa81
	P1PPnk3+QZdIltRQAJWVgorpd2YdbFODdFem8CgAnK5mpRXlUW6qUjS1TBgJCDg/2buK1cXTOb+
	+XXs3pnFonuk2oK2SysJVKtWEI8I/+/RrItUdYKfgwAWaZhVsqXBQBNOPkVvFJa7J+DPI5iVXhk
	VeahifdXNuOuHEnwD53jN5dHdPmnrkK88nhM5CC3q5cVcRA3+Qv7aAYfsHROOqJY/VjvU0br7lc
	1p4l12j2BmOZRP6GubUW55mYbTPfAfZQnmj/r8dlByU6opoFZKKqrt
X-Received: by 2002:a05:651c:888:b0:3ac:e902:f22d with SMTP id
 38308e7fff4ca-3ae09650574mr6624441fa.27.1794333986106; Tue, 10 Nov 2026
 10:06:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110054836.1515030-1-senozhatsky@chromium.org> <20261110054836.1515030-12-senozhatsky@chromium.org>
In-Reply-To: <20261110054836.1515030-12-senozhatsky@chromium.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Nov 2026 11:06:13 -0700
X-Gm-Features: AclHuK_swjugJ8PYhgUUzKQzdHDuV10SGT2tfqTTSkLlpXsGrfb9HF1M_R3wmdQ
Message-ID: <CAKEwX=NvOym=p+pU-nxW9hdrf3wq+Ns6TGFqmjqHw1rY9ELcuw@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] zsmalloc: populate new zspage outside
 class->lock in zs_store()
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: i3ky94sjobezsph33dzmejapaszp6u7w
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B0F41100005
X-Rspam-User: 
X-HE-Tag: 1794333987-386626
X-HE-Meta: U2FsdGVkX19OtVfNxsGNekRJK1U4dkuP+M6gvQm0BPTq0GT5uDu9MlkSg+5tfdcLYOy5Mifm+oz6hrvEwxKnpt0zYBVbCFDMLiYbFz5eX3EoA//y5YAZ4mDGcVI9nit+5PiRCIMZ8A2fG8IDxGpe69C7/YRWWVtfUg5g+RVI6BBK7/3ADVmr8UxCn/FDSDWOJ9MKy0NxG/4UnbNG77fmJNcxcAK2V0QL5JDXHbTGoUbufvwV/X4E+JG2EHeP9/Pb4XZdUq2h4IsLSBWG50KKGhbaVOl7QTovJfNexDKwAWDW8Sp8gmBubsBWLIeGE6zTq+3w9Y1Sc7AdvqUtqhRyIt/X6eZjJrrabYq4k+J2JMLe5DLA22wtIG8s1CbzNe62SMT1lOqwuw0UYnrO+9PdSVrVWoGheVIv++oVtdJa5J9bLGpuEJjxhsSTMmde2FJBi1UZN+o4ADBNmsE/WcDp6AJQj8qKefCCXt2nHo4pVYUSpb64J+pjfms72pGAN6lPucR9ynjXHJPqrhdi8o5jq54/DYffOAh1tL6ARLsu+MNQbfDWjeC+clrCRZ3nZzehOXv+boKVoH/wpeAzghO105PH71KiIL0bm55JIUibIxRkWZr+octrl8pmKM1T2PjISwaZa6CA1w+W5bdxbEMLztBOzoVyO2ycIaqgKZJPCCBu6Fa2aKJKTipuQ9G4aKcMz0CtIOC5g0+nGGECZyqbOAS1XzL9KYp+5npuzUkD9mCXqFp2gTPjoh5pOMR+BrSItbYh4+HONx887rGOBBfxXhSdZcnhxnEDOWs/HvwzZmtnSx11EKTBJlfOAfnz1FDNPjmTlpqQa1qaXi28AkCys/aoqhCJQpoFjoF5WqMvnSlshgSfkvSj6mrpgwL48v+90F2JYf+xuISDbComq9TDkuzF9Ggp2uk+5vLNCVxc/jCXNQZOtdoPeZ+vXUEJLuJribNE8or5I2h5Hnay71p
 d6fcpPY5
 HOecjtBl7jezYHxMVMBUNAbeaMBNIpjfkU3T2gLADPn4q+A/hj+7RirdtYt7+6G+hZkodcT01jlqxvn1ivSMmTHGGyufL9rRj49cFq2As5VYKGwZAaqj+3Q7wwsRgT8McIQg9KVcQIvyY0+mexlvd0DmhTSZmDXV+Mo0lQlZE6NACn7EsGWO8wEHyLxOS0IFGMmOMdR1kk48tkVRIZUrsj3shIbUoYi9vVZPwu7XHLO+UzGgtPYMpZkHuA64I2o3lddt/+zBRt5mnez0xrsfYlpnT+rqu6rCpCuGeMRtsXhRJW3ExBH9JvUGiab6enPD8gNh88ABjNzyvGX6mMRVZ7HWrp5jESlkiZdBp1JJSOHYMDQgIj8lWG8owyxPuCD6ALTRUCSF6gdYOLDV1q/RjWF++4vyfI5S9m+ZHfsIpwxLqSGt/tJ41ixf1hY3D4YXlnYvhvAsJUQ9mlLtBiAIy5UigAI9WVnU0LNP4LxysCzs+wxGaYsSmu3Rc9yE8cCZkwp681AiDslsx4pw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 10:49=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> A new zspage is not on class fullness lists and is not movable until
> zs_store() calls insert_zspage() and SetZsPageMovable(), so neither
> other zs_store() callers nor compaction and page migration can see it.
> Nobody else has the handle yet either.
>
> So for a new zspage allocate the object and copy the data before we
> take class->lock, and don't take zspage read lock.  This makes
> class->lock critical section shorter and saves a zspage lock/unlock.
>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

