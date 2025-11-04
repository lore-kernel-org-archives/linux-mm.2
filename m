Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F4C4CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 16:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A218C8E0005; Tue,  4 Nov 2025 11:21:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9518E0002; Tue,  4 Nov 2025 11:21:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E81C8E0005; Tue,  4 Nov 2025 11:21:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8838E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:21:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B8B712C1E9
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 16:21:12 +0000 (UTC)
X-FDA: 84073439184.07.E9FFC7F
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id 485D6180009
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 16:21:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XvJy1SzY;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762273270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQtHWO1T1LZaZkB4CcCLjZDictjbTTqJDQAVMpe48s0=;
	b=Z4v7nIcmQGBtTjJKiTlWRTNcd391wHvObBzjt7QlFr5jPRDtoKNl2YjJfcoi5qFsb9BuGt
	GsI+KWu8nJlpMTA2Jiab16yIAmiJifF81G+9wUtYtfQuS/L/T82niNC548ybYryq1Yye1P
	BnnhaFvnCoJ3FGQ82BvD30ALx1vXUUg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XvJy1SzY;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762273270; a=rsa-sha256;
	cv=none;
	b=U4vOb8RMrj/RgqkHKdvenriTDhRZ1fDiuxN8Smp2jlSVZN1YLryM/n9lWupU7RnAwOaRjb
	x2am7C88n4FVk3/7N+W9wQe+Ezt5QzqY8LPMvY5PiLJruASI4IGOduNGyVA2OtNPqnCpEX
	1S1bQys6vJcEE0R7JtLmWoicHfbSM2Y=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47118259fd8so42873015e9.3
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 08:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762273268; x=1762878068; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQtHWO1T1LZaZkB4CcCLjZDictjbTTqJDQAVMpe48s0=;
        b=XvJy1SzYDvRKOmxNWDIU20a86Kqmf7HKHxhJegfWqytwcU1np6hTxF6SZGT+wU/JRB
         ozXNiIoqjSZV4PqAw2AjLGsILhRQ/LM0FwOOtWo6XDAy1RQJFbE6ZqX5pAPJI/ImNQ+J
         RIdqVuu3uOUP2oWO5PXzmVyktAremVSN8OzY6eErL+Z6TzB3Vrx1YFeVzotgr09sofKG
         leBRphfed0es14egfg5jmtxMnE5ljYeeZX+VqshUoTC2mZCnHr15CcIn7E6T7vhfHdsq
         AupuQh4P/njXl1EpIrYNy+/vpZVx8s+P2QoVayOsqkFEEaTayD3DNN+r91uv8Piqw+gR
         4vVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762273268; x=1762878068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CQtHWO1T1LZaZkB4CcCLjZDictjbTTqJDQAVMpe48s0=;
        b=UIsuYxeFAruKivCAYKUscmbwim27KbFdUZiBaJxzGHCjHbkbEtHMBNtJadTeWbQmhM
         w8Gi58SPhEevoW25JA8BMtkYcRvCUbk5qJSZIua2lLbY3AUy4jrcGmGN62jrC/UZkb8Y
         Y+thdIOs4/Ru59b7121otskmQ+Uhx47p+tZRcp9c/kyDXeevzOo98u7akWqeZizDrRb0
         rMGa2iULnR2hvbITJ/Ovm0ejTCGOb2QVkm2NiS4bIcgnjlLfEszvrMdWRo+9rGUi5S0O
         OFkplRlzqQ5Q0Vi31caZNvisbCyROEbCasIjJfBo7G35dCq2VXGFznIpmjdcH04sxiUb
         4Wkg==
X-Forwarded-Encrypted: i=1; AJvYcCUVQvhgfb35u6Yee9S/x3Y9qHq24VlwwdpascG+O6fkWshIMiD3YYjAvst/RoatL32CycRw1wxVgg==@kvack.org
X-Gm-Message-State: AOJu0Ywa9GsHN6VRaomJpCYTeU3/xi82cnVShRtihbP67ZPWyrv/11DG
	Q1WjDqOzuGTUu19ZIioEJqV9QGbMO5N0ipZ86hpjyZRgGOVotqfRsSVhccCRuOkGpkJoB2NgPrC
	bNU2KPipFvj8BUUCEQ6KxlkhWmaHjvzY=
X-Gm-Gg: ASbGnct8N5jsPnQYT4+Rf+u07vQl4xWAH6zZEOOc+1Uqnf3kjs7v92HtYm6vr+he+fK
	kPEiJkwz0efEYUSYt1fayjgQEbbrmd1EeiF/72Fz4ii/viIxo6nXMlJZ8eTSnM6+ujTVoPnSEja
	fLanYFfTcjvsvA1EwQLDVt+1mddjxd8rlbt/8jWlbQy++8fiwvLvsNc2XpF0ElnC7yl2a5a2+Be
	Wvz6K8rToq4WM2TaTOUWoN7FrShW+s8eTDCSIN1o58U8dQ+LuJjXVo9UQ==
X-Google-Smtp-Source: AGHT+IGOvvt9b59SLVpbCsEQFt3dZXMd+Hg1SaHjukt1cqE5ShIxaX6RrkT8ZwcinfKPHIjF4o1jvMQQiUentZ5PUsQ=
X-Received: by 2002:a05:600c:4ed0:b0:471:1415:b545 with SMTP id
 5b1f17b1804b1-477307b8f57mr160302895e9.7.1762273268414; Tue, 04 Nov 2025
 08:21:08 -0800 (PST)
MIME-Version: 1.0
References: <20251102082456.79807-1-youngjun.park@lge.com>
In-Reply-To: <20251102082456.79807-1-youngjun.park@lge.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 4 Nov 2025 08:20:55 -0800
X-Gm-Features: AWmQ_bmrV6AP0g2hXaOpOwjGzlcqcVGvqC6-WugJU_CSuWMfjkTAWh9WliBt2RE
Message-ID: <CAKEwX=Pe1NpQKneE0q62orCteu8=V7L9Xp8uDd5T6c-e2vpd6w@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm: swap: remove duplicate nr_swap_pages decrement
 in get_swap_page_of_type()
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 485D6180009
X-Stat-Signature: 4b6y15w9njucnugfw7we8r5yj6na6swg
X-Rspam-User: 
X-HE-Tag: 1762273270-326555
X-HE-Meta: U2FsdGVkX19VJpktzF+KUdyJ1fcjb+0382LiPtI68bupV9l8yXOYaMKxPvORgOsx4OWj7fJRSj6jR1wJkyy6440KvL6AN+CqvikIB1xmgOhonCoyGWVn+4AnYEoGQrMQAT8xm175SFJjl1USGQr05uurfJLsxm8RT/J/s2ORNG6ncjfxjj1m8IfbeqXgFGrPjB/AWDqUcaV41Q6fc8Pvvf0b8Jh6togizK91TndmcY5D2kJmLG8jvINJfvUth5C6zayfRumU7L8hNSo+9TB3yMJZmbxUKgj6+hz5PzdqDQxxF76cZIo1F6gytDDSm07zVHKqqzipF88U7yW6nfJrF7P3kJ+EIncl0qnqmuWiinkjrManGssw4/MiR2WkAGBF51Yi/0vPHPVOHNaZHgO3AEjvjil5d7WAxFclTYPxvSv/9NyC9pNo2YPAyRtzRlZ4+sZYwxuo8YSrC+6yTFfBN4ogx+/NzDtcVMUiAmDHr9KqTlVGYJJJDsLosn+o8rIwC6sCZvtp3kYDEe+jaJUG+x6qoua584mEWiz6tSJr8hAtexCBFXnK5tpD19Y2BQxoQ1hb8wgUQbGG23dk4wmkMyfW5TmZkwSoLfphTfjskb6BczGulcr+vjWePY4p67TyneMBEGs8WfJ1E6O6YjeUGRP4X+ydo+jdwDqNdzw645PbgW5w0L6MEQi2a4FYLRrdQb/w7I1DvQhjVR0rhODvyZn5sn22J527kEsmYdKgCsjLqkPO7Nv4//Qb0LDdOYKqhYrbDv/mTuUDBawAYlrzBJIXUqBCrOxpsPRh8MKvBCc1U8m/L/ru6AePUrISn4D9ANlom/wMZPUOGU/7djCmNJslasJW1QLlI2FqA15zh9XT1hYQyNDpQUPPWT5UPk8115CAjxKyfcGcxtBUVw0/rCwPu9lHs8FkDQngZshoa+yEmLbSRfXegAoiqOweiTer7kH5ovlU49n2uyQaTzL
 lYnLgawo
 f/vlQmwN/BJ9WH2GD4ft2jf3L07NLwcmm/pK3Vc0YDgQlLW4i0XIdpCEcgG1KFhpHWRe5B++o98ub9qMYyjIirCpQ0LoJGNxA1E6dqrW1WJ3EN34SKyuU3SUWSjE1d28xsAw63qaJLUCeMMttOzc9+hHvVJhJUSrYbFn25cs0xuVsHwLKDWCczgOIsAMpui5ixMHcbSejHMY6DyYxQEw1W0wV9+P20kKMHj3MPC0LrJDgts+KlUUUeptlDflpU9E+I0iF97eBHwiTCf2We2Go4VMM0oNvTVCwVVHPxik5eSCD1uGJSt0DQyVTWaUOwwyuph60B2UtxCYSKk1RuRQylmGXunMQvDysLUeTZcOynWBIoj/pLJyaAkXbwaIgEQFuC2gMhrBpeyE/BHIN2/le/2VCN9yBiQ3OkfavqbOMXld7GQnBaI/vJ/gWaqxStNZKlZFc/MX30pouppNQeZcaWaCoBM7dZcOhvc6I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 2, 2025 at 1:25=E2=80=AFAM Youngjun Park <youngjun.park@lge.com=
> wrote:
>
> After commit 4f78252da887, nr_swap_pages is decremented in
> swap_range_alloc(). Since cluster_alloc_swap_entry() calls
> swap_range_alloc() internally, the decrement in get_swap_page_of_type()
> causes double-decrementing.
>
> Remove the duplicate decrement.
>
> Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from=
 folio_alloc_swap() to swap_range_alloc()")
> Cc: stable@vger.kernel.org # v6.17-rc1
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

