Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1FA606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=ZItaBidm
Received: by kanga.kvack.org (Postfix)
	id CB3026B05B1; Mon, 23 Nov 2026 08:32:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C666A6B05B2; Mon, 23 Nov 2026 08:32:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54AC6B05B4; Mon, 23 Nov 2026 08:32:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA8E6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:32:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 235901C42F3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:32:15 +0000 (UTC)
X-FDA: 85466472630.15.3C253CB
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id BE8E6100008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:32:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ZItaBidm;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795440733;
	b=HguvijPuZ165mVLxFAXTDHdmaeSR48Jsv0Qgnyk5IoQdUgwpPrbgC61cFmVXRieg/JTObc
	ubI3ycgknmvSGv446vMgl1jADf232JzcEg1FYuD65xkTYJ4eBFwkMry8lNhL0NWvDSRSA7
	zzYiIS+i3pvHKX/cnrD59ZUeJtPzmHI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795440733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ptu9eKd6CbNmjxebzPMpiJtVszjbsUASR3ibR5T8kw=;
	b=Dm8H+ANrPqb3pcjodaBz6l7MmFhq83IW51o6kjt2wexIkmh89UF/vTNAw/qzExTlUf7yoK
	DVocgONy8i0hH/YiiOHk16gDdyj8YojHeJ/zexEZG5vtXKeh9hhQaDTXzf/0oQJfGeHjtg
	8RIYWoSrFVbIyA+N1dYDol9vFns5ydY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ZItaBidm;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4d28f75d62so547890166b.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:32:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795440731; cv=none;
        d=google.com; s=arc-20260327;
        b=nYaHyr+LqAadoclleitZEl3hNVi6wBbThSzBLG6q9FAbSYdUFqKcUjbo7PRFR4DRnK
         xuXAbAYlfBhnGBIQSZ0CTCrQyQsWqmXkoyEUjzf/n1k6XG+hJL2vd5GDoXmCR1REow62
         F+amtnsztZjnioF7HilVTGSwbO/MVqQWMk/WjcnOuttbjV3MHlpc7xJz7uwiPHDBb1sk
         Q88kWDoXnWpr1rhlfEAElhZihWYjWmRiHenSs/wDUUNo1UnirJJ5DA9vIvMczFggl2wN
         +Zyv6jn8Wj64KWBFnw0tl8KV3ZFaH3KjFuNus9OL6HIqEj8ep+o2QhylfWdQ49Iv6qtg
         8d+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/ptu9eKd6CbNmjxebzPMpiJtVszjbsUASR3ibR5T8kw=;
        fh=vVz7htVFass/7B0JMxu89MIr6zm63BG9Lnv+DR+SI+A=;
        b=YGNi48dMYrFPzZCUeIRXQ4824JWYGJ/dwm7sbTZrPBDBxqKGrzPbVFuFp/RhRcLI6I
         LrmFZgEnJ9RBr0HDAhgW9+IR+qe6LA0Tk22eFciz3PpI40OIsNsyv4bzpjL1MJSvlfON
         1AQH+UaelfxJmLi9VlPPFhLZfEirY8sjiyr/BtGE8ntYVQ0KfflOmWrX4nzkteSCTqAk
         0NJxXf1e7zJFZz4CXNVWGdhHqmMg5AxGta9jLDf7Sj1ugGZq0fz7bDsWL5O+IUW3H+Wx
         FPLtuhz1ix1KR6eg2Cx+qQmdY7BXzjSjfFE0PRMfyWDQTvLOYdONfKsw+3K8bMEI+7G0
         /QSw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795440731; x=1796045531; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/ptu9eKd6CbNmjxebzPMpiJtVszjbsUASR3ibR5T8kw=;
        b=ZItaBidm3vRZvE+KX4NhbJVCt3sB2YUzJiX8msbRb5BUNfU7EVD/a07VN2iZe86rbJ
         RtSoADcdvYhx8dxdrNLmrAURvV1qHG9XVFPHIdxdTk0lNS20OaSAghzh+0mCpXawEEca
         tK/G/kBoAVnVf7EnbSgLtKxg91yOjBlA0LRpEySVRIioGh2GjD04hxXFJm1y2cLXe7vr
         yKdFY6tNla9Q8RZh1SaKL5d7y9m/4z7jWJSK4G3YA09jyKqZa59I5ZjCrOkmwaR8FQ5e
         /82tdCOaDVR8WkXR/00Cs6FNgHT7Hw7bk+p7UsTGNpGnm2tUxCz++GZ2A+lYFrVsQqNi
         a4/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795440731; x=1796045531;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ptu9eKd6CbNmjxebzPMpiJtVszjbsUASR3ibR5T8kw=;
        b=nMfbKLtTKTuGXC5jyVO7LEn7LQgUzALgcoHwr+b0dvl/r8APC3MT3eWOQ8phzwnlis
         Fsd6E7VE5oPziVNSkwljdCRxtPrkTAL3pVOXWH6BFIYCeUUM+JLAHXjJezxC+/6EWdfS
         XtL1YmY1ei+7mUabn82qEuKr8HsGU8v+5IgpwduJcOOY+lSuWnMHCuU2yn1aw94x4Wco
         LbgHZPKIBGntgqgLW/0Bwqh3EqDqdcdmRjuthfR0O8Hghxd2u6lplEB4ZpzI84i1Nhr1
         tcMRR3E1RimNwrKU1d2A7sQXruW3n26jANXHys2O3ZJr6Nsimqg99s0t2cHy2iqP6Eja
         SajQ==
X-Forwarded-Encrypted: i=1; AL+hErE5ZD4C2WYlfG6FsIN7IMzLeB6wbbgvIkXNCzGqGEoRWSgM3SrLvRGlbY3e4Ja/3ZhioxXD0l5+Dw==@kvack.org
X-Gm-Message-State: APuU4Z+GVeyC2mfjo38sOl2FpFt8g0g8QVum1gQ9tSZdaJkhbgjZbk2h
	WSyp4xlJJyKRUyphtwB+LN9/m4i73n34OnwplhkpWgCv+vjR47NyyWzgSmlqWEqXPxB4LWg06MU
	p8LMloFyg6srkoN5jTyve5td2ccK1LMyf2zJ8zeJLsQ==
X-Gm-Gg: AZFdTZeSkJDtr/MqdlNANVwt0ftkpccW5zsmAnGe5jdUe7EPJ8IvF/V6CBPkEnLgyoF
	LUyfanRP11e/H9NXjSFBRp0XfvCQX01PdP1z7AdTxaPajgeRYLS6x+W/1oMBPAn0IpG1VAK9d0C
	JqlF6rvT34fDUgEHxoo+VbTw5dyeI1CluEWLBXLmNh53sQJPUOtlMmsGY70uVx4CoKstEqTEAgJ
	yrPhfTZVO9CIdY2swQMTari58ILzWZv30bivwb87fce5iA3EUdCL/hvestkOAiGHcmwj4sYreiu
	yeVNlXG0c4w+OdEznN4Orakdv+YznFG4XMTy5d/3a853QMkjVzuckzbJEEeqbZ0BjguabP/SiGG
	ISbqqOcy7GB7EO/zggyi8PxnltL62ivflulk4bnDq/lZYBNA3HBFRXVsrrmsZTgb91g==
X-Received: by 2002:a17:906:694f:b0:c50:ff1c:22be with SMTP id
 a640c23a62f3a-c513aace676mr685329866b.16.1795440731316; Mon, 23 Nov 2026
 05:32:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116081403.216452-1-max.kellermann@ionos.com>
 <20261116081403.216452-4-max.kellermann@ionos.com> <92bc11db-ef40-48e3-8768-9af36bfb5a7e@linux.alibaba.com>
In-Reply-To: <92bc11db-ef40-48e3-8768-9af36bfb5a7e@linux.alibaba.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 23 Nov 2026 14:31:59 +0100
X-Gm-Features: Aa3M54rFMydpSO212ScIFwe64mMnhlUhUt1F_GHwaP5Pid0tLkWi9Npl8x_Do2s
Message-ID: <CAKPOu+8vso58=3Z8ijpg+91q=BSmJ-M01KyNY=NwUH-9HV_ikA@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BE8E6100008
X-Stat-Signature: pqzxbjg3f7eejpge4hsuccicdxmtqfh9
X-HE-Tag: 1795440732-455179
X-HE-Meta: U2FsdGVkX18BX+uGhC/4YegOWiPmKjSM3dTeqA5SiG/Ngh6rKUgBOHPtr/ALuhwF5MTqPVe71e0dK0GsJA5yRCgyjhX2tCAid5XmShqJKpECucHHBiMOi8QzjI6OgdyUgBSDJ9ceJlxPK+jeXcz+pjcWUHUJlJo+wOLxI9E+yeFD+ZSIN9SFRCkhw7p0Rc/QO+Z+qEdoAMJb07ezfYwztS8XERF7TWeyNAd0FwPcu4GUetiEsr6m8N+HLMTY6gwkPt4gRlp/vBe6WADQVr5BIZIUnk2D7/9IrFptjC0P+rclvKgEWtGEDReOezX1vmIsY2TmOE8gAVD5Ou1AhMAtRtYMy26+f0PoeO6uP2xHds4AxZcLjSdpDqdxTr9Su4wHeL4wCGTNNnuZrjXfqe2i6QKlq3lU4u4bJipbu6Ex6QPtk9/ntENuVucBg20htQA2AB7yJU5iRnmMSdQThTjpCr+vResoe6XnlkuZ6piCPtph7HMRGAAWskJPm+ZfIa9owZ1B5DiWfXNGAp0r+fdYjnqu00Qkd7EH1HFJo6CU6SV8vmZyA3YqKDkeDIYzlrmZ1NQmHVZaHShBiOggW72QNgfAcJXxZFHm7cMF8WRcS1jDz3ciTbGrLlMvQD7KB1gstEk9wJp9cQtjynVUuf1EFP3zXRzNk38QAR0YO6G2kH4AXtzyuuXUKaanFyxMFe8keDTnz5OnAXXygREGB/AmZxOKfZ68VfFaAekDfxUobc7qpul4ETR/Hc4kbdn066uXHU3WDlbEKiiypopl1HWcfJhc8ggPdpLnw1V3SVwosVLPvrH75VKocikehEfR+6Bq71/vtIwntHXAupCZHBz9rPr9yyJLx1N7DAHN6ruTQAY4ov3/SjuRwDkV2K/NNM8zLthlENNwpTyNHZPdIDD/b5MVPK3c40O5FkXxAQk0ATjN2PYOKk14IeM2zD3PL8m+xNz2qKyRyKAeOfzl5RZ
 VkUAlkFQ
 VD90E/gYNKPsavdr+RSd6jsWRS6aK/oXgtGHWvb0yrk6PszFr/QIvQevpvsPHIAy1o3fiYL6qTYgA57CUcHd9Y81CyN8qXJgJiVCkDCImK8FJkr3zmp8C+k55QzP0yRcbYkJpyYg0U4eEGqJg8VE3JGrR44D5kdCDfcSVzkQC7Je44ps3aNb80WmKetFVEttSMkaRaQU/F2TQCtdGLKhYIAtrB97wWMj7d67V2DgbwzzzphUoafFN7/FxUaZ89sUHqNnWUygWJOUgX99V9cePr1VuqJorvjS95K4v6rRX9sAcRfy+wYN7O+gItch5szjq6soyPL4fb0Y8UGi96KAy3DuWOdE//cDJLmd519wBT/Sejp6ywhY9sGY7UD5mqjyeWsvUK7tilB2cp7P5Ez1Qi/Xk4mhZwwrptWn/G89YFmi8dk/wOkm7+iji0tAZdPor0xpfyoP2QFYdrnm5vzFENlIBCV+mv8OyfHVjYVkDEjXMR9KiSwQlQuLst6+Bje++xBoeR2MuDsM0iKvVukBInKIMwTCKL1e2fd+C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 11:00=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> > Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
>
> I don't think this fixes anything, right?

Right.  It fixes a performance problem that leads to RCU stalls and
soft lockups, but it's not a bug.  I added the "Fixes" tag for the
commit that added the code responsible for the performance problem,
because I thought that might be helpful and appropriate - is it not?

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group

