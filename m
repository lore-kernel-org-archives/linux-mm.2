Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC08606A33C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OZHwB5Ew
Received: by kanga.kvack.org (Postfix)
	id F043C6B05B5; Fri,  6 Nov 2026 11:35:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4736B05B6; Fri,  6 Nov 2026 11:35:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3CE6B05B7; Fri,  6 Nov 2026 11:35:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F36D6B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:35:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 858F91C1C23
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:35:06 +0000 (UTC)
X-FDA: 85405243812.23.644D5E7
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 94B7E1A0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:35:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OZHwB5Ew;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793982904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CVOtjuY7d2VzQ4Z2Zf3KQsMmbUtgWXk/lvdZGEh5Z4=;
	b=wDvVtoEhX5ySW9i4/q+BMPOFywiCCNY2LFoBlW+/TXVLBHjOg/0/vXWjWAGEqBEWSiyzwk
	y0b9D7ugwtMyO8NYfFMtPHUAVrH+i+vElTI4eaRMu8YSOCMlDzhBwGb1hHp0/0rt/JipKp
	3uyums7rbwr9mvuBq2KuV5s0ZtaobOo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OZHwB5Ew;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793982904;
	b=HsjMA95auZ+xd5hx3luQZ9DT/5vSKsnhyEV8hXD8Eu5kv/frTnFl83cl/VARI8pghu/sFM
	hHYc5ZkH1Wbly1zqt+dA80Xi9ivwnFiDTH6STAQ9hJ4KwcDc2oqJ7MeQdhFsx1uzat2aPi
	yvyhwbswi6SW4hSrHShl/z7KEetLqNs=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5be3ea5a7adso679657e87.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 08:35:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793982903; cv=none;
        d=google.com; s=arc-20260327;
        b=sRk40MnOnvPv/qlef0I3rsOksjYTNvWYJbm4r8sl+yu5zYwYBNhI5gTSh8CVDFeKgU
         NYqtFfnt9pWC3u/D16KYbjfzvNMSZHZzCAAnUUspNGDmY/NjsoKzUN9Ap6HmKrV9xiGC
         ZU652fXU16o6aY/2RlcffhC9czEAdLH9yQ6F9noWhHOXUEEhsemspC+0b+mvSOiv/EOX
         djA+4NQEk5SF+4mzscoxSVpjAc7A8aGGnvK/byJx2yz5h/MUppQ1z0+BxfRaUHkAiCGZ
         nD8wHSrYHL0iGhnZKApLtp0FnDD0nTO83tLZfBgI8fa1cBwZxk6pea7nFmtZecIpKyRC
         qBjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8CVOtjuY7d2VzQ4Z2Zf3KQsMmbUtgWXk/lvdZGEh5Z4=;
        fh=sxdNrIHnL5omkGPnaIrhLqgt2hhmbKg1UK5N6yxjbOQ=;
        b=CfysQ/2KHhTJ4oXTQ4LLhb95qgfRxIK/0Z2jkWlLlm5drjCsnJmrqhlrO/GBy/QgNa
         Au2us+NIrAf9Pbfl+BWzBQRKTH/XS9ZT9vm+Can67ZXoAk6SjtNYjXjzA3slXHCXJWeq
         bLp+ZGUN+r/rjtGIZmSapVI0GAYwd9Rq113ZU5zuPEZyhDziVAjKmELCKzfqetomP8Ak
         WJYbO7jm5GJt+T0JqeR/kIzCnrorIJPB2Gb9MZh5W9aVRXj8VoqxQFOfC5c0LnrbDY7p
         y/L3hshuKK8Uo9xiG+A9s0GV71UQ5ueFBLCExZfSBEXfzeq+ubX1Wlc2QE/xLJ+YkjEh
         DTvQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793982903; x=1794587703; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8CVOtjuY7d2VzQ4Z2Zf3KQsMmbUtgWXk/lvdZGEh5Z4=;
        b=OZHwB5EwJLMu61pP0fwtjaBLHjh7qrmKVAOMQQ0/EsdGTuK9zYqz6Urd8vnBIGQqCE
         3Xoxa5D+gAV7uXaYI3JRZWKW08F623fSrshJD7BS4X9be+WZ+nt/nWWhHgrR0qDClbuj
         +Tv+JqqEBxK2b5HxCXbEqrfDsdlDNQ8q9vmNwdoBKXsVZAAWZyib6h5M9qHCsEgKo+DM
         p5YuKFed7UTRGp50J9jQE7c15I5hQMB+HpuRPpira5d0ElvKApLwdggzIqhcFdtmSkfZ
         O4AGuI+ka2op0vxeVGexDKMGTkekC92VfTtM4UD+6kL9Z0krhb2VqXEHEj+HY0n0Z4Cs
         z84Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793982903; x=1794587703;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8CVOtjuY7d2VzQ4Z2Zf3KQsMmbUtgWXk/lvdZGEh5Z4=;
        b=p1q+keMPl2xWFg+L9LxE8WyC/7azNUjCgIuqcz25ny5qBuPuJt0OMBN5ln6StB5bcj
         xnvpZqP+mmE8qXPKFiX0sgh9IbauxsrQ4AqV7n1PtsAn/y5DmHdNwOmuMZzg2/ebMPtU
         U/ldtiRjFmOwMkq0UpSOwkm7aAaRxqo8ghamZwiWUvXBfeSh16mbu0KCeZF5KqKwVsvl
         rEr4FXswyqgQh9xRD68bXrWQsLq58/1mR8OwjVft1mYG1g9+t7iRwEGbY69jg4o/cj6y
         NM/vwca1MEOdV0J1YoNEnhwuv+U16cvtevjEJPGDNnTic0YXQ25kkaTZyfS5cwt7aKNe
         AOFw==
X-Forwarded-Encrypted: i=1; AKwUvByA8yTW1NiBUI5fr8dDNmVHFTeGXXVUzWff2RDfM1PdYZIKHv6GJlKxnNu/ue4ekeeRvIdFaqq1CA==@kvack.org
X-Gm-Message-State: APuU4Z9kUy1y5sPjejl5FFN1eCmp7R6foTKfHgVf3IiZz6uGKgQGQ5Rj
	NvS9jAn9CTzoJBUjSilINEM+EHaYytc6JhqKAjonqcj0E1Gr7bIjJR0jITOMb0CDHQSbSvww3IH
	wdAIgPIiQti0BPEbQnINLSY4VrasyVAZkreOLO0zXIg==
X-Gm-Gg: AYBFou2pthxOXceMEQnDmSugQhR5ePPZ/fKqKjxyvpPRG58YH78bBFTkW/80+HU8sAO
	ZtVmst+6NsfwuHNjfj7GjdNbTL10g6OGpjEJA5eIwt9M3TBQYzfl4+JZ/MZuGW3bBNIygWQqVYo
	QgCDE36s0Hk9OiZi8iWAE+dFJLdmhthEASy5c1qfUn7SbAEz55Fn/sK+HlIwhQJRaufNM1W0cMJ
	7Qrqjpb3cvuszrhL0sgRcI5HPLPOiYPWr5Ff5Ed65mkV0OC8hst2bdO8eGiw6Dk/lZSVbBRnPhX
	0E/XCDT4h1qc0mwkAByB1vf6vN3SjErIRP7c7lU1qlBfZEa44/rIruncgiCUt4o1TcfUgj+4wym
	KlIfNglVJklnLmLZdvVsoanHmuQRuFKoxPfTSgKTLoLqFHf0v3OBIeu63xV+yXQRnrgrkqf7MRT
	bem9xxjBlKGqYjJz50JAl7bV+c+JpMqdrRg3uJ1LUj6HrFhl/vtzcY3l90a5LvxDBs0l/myq50T
	g==
X-Received: by 2002:a05:6512:2524:b0:5bf:a363:3392 with SMTP id
 2adb3069b0e04-5c0037c305cmr1026548e87.2.1793982902662; Fri, 06 Nov 2026
 08:35:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106-zsmalloc_stat-v1-1-b574f4714adf@gmail.com>
In-Reply-To: <20261106-zsmalloc_stat-v1-1-b574f4714adf@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 6 Nov 2026 09:34:50 -0700
X-Gm-Features: AclHuK9bkduKRW_-rCB-rmHbL-N2hWHiB5NT8He7c1ja5_0IYw7qh2rihJItOYc
Message-ID: <CAKEwX=P+8AhOV-HQGHmtWftMs=if7LTk6K16Q39bJyF3DFFtdA@mail.gmail.com>
Subject: Re: [PATCH] mm/zsmalloc: keep fullness stats consistent with CONFIG_ZSMALLOC_STAT
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 94B7E1A0002
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: xaz1uefj79yxomdgutjz4o34ubgtir6d
X-HE-Tag: 1793982904-321432
X-HE-Meta: U2FsdGVkX1+dDO0o4JbWUPMexTOwK478QdA+oaFtrH1ussdGoSqlQd/icTdhgZp76bLHaMXuFtHE5zsXfrbCtFeOIOSnM/vhX/aIt16Qi1ZdEZw0Jx7xcF3zPaDeEeKM6mpOCu7sd3f5dDkrCmjjTGdeelKT8XpH8NXg1mASF5MLkBshaZ+suR6SGUWRSENkV7cfzmT/ZDCOKNO3cQufuweIUpCJFilPeGJob6lzJOBsFJ4bxCN+T2Bd61nk6boiGE5tUABAD1tiGDFo3IFyiCEqkcJH8VctTTFo7QUiMFZwfcsE9avAqU82qbOpuW1cUTnFJbKCHwiWUueWtkPrmwhuA3RlbbjlY39Xfpyp44CgokAljdunKMbnN902ibWAGwamlfdDIcmQ7s6iig64xU0D47G8pWUC8q54VWKkGMU7el64MKeJqI3jocHnQSL69KPbFlN5R7WB1QyYtieRGBNl9b0vQ1KPOkj4+8cflOnG8PbN1QJd3g92gCsFflW7W2sc9Qick2iL1nxjTCT2X7l3/MFP1mNW4TfgaqKR1h0v4xpMW9GkUkfoPNtAtwQAHlQQdHURawCWqM8QjLyiWBbKjh7MgJK0aOtwkW8/ZCgyd2FTnq5AByW3C6Ln4CR5WofzE9FG7bvDnxHRayO3pL965OdEv6abUw5JcVpCyoK9Prei6crggUCuD/STU77pG7vFDMoznsR83NqCsgesM1BB5R3ON45KzreQvNXjLfDqB/HMA+y4Aac/GSvENwBPyaRw/Xa0ckdRKZsNYcGZDLXnDvIKCkibNm6dKcH5Koz1GvpIav+oD3OM5vLetfAIqqUiSkDAuSlpKvD6tVJUHoRPeVAacYXhLDo0Oe7IW1Mv0CK7uhtv7KwFP/HEjkYo/LV9hiRm1aheBTc++2eE2C8z97UCRHKG5kT7hOGziXOmE8lsZDsiovh3071b3ivyuxVaDXGO++9okjyqYx/
 VLczonw2
 aV3nQsGkos9fke6So5Th9n7p8wr5qF803HYFaz1y7YANMCadQcarNDOoZ0KamH0GfCQHk5zE3erkukqDzSPcYlu8XERON8D1J1vcMBfZekNACkej+T2HSvSyICByPS0XjO3YzesRuMfS6iJxL6mMdpRFRpOapxzt2NMjkdADrAgFFdK5Mukyws862w9k1VD8i7HX/tVnVlElhTBdSWRxvQvysJVDKhxP93OIBQRv4er3wYTNqGdKP1TMktvtj0EfBb6/yv7BKOyQETS6Ypjgkysm6eUqGQu7MUjRAHhjWqlfoKVWUj48iWM7FC3Wzme6VWmtHKauLRYlDW2xAAdGycZ8/+cnNQ4r6UW6dm5nI4k75ZgCBeCB0Yc/Uko469qCDP+kujq9ld9wpeLTIPqIUzz8hBvwbbfA4+34May0h145NEHyTkn42G+cDXK6mlf6KU27YRGFyTaOeb5O7VT4BMSTCFaHl2aVpptem17Ce+FlbWstudynpYUDbPltMCiXxosncCb1dKXTRQLigmjPAuH9mm6a07oaNc6UN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 2:56=E2=80=AFAM Xueyuan Chen <xueyuan.chen21@gmail.c=
om> wrote:
>
> The fullness-group counters are only used by the debugfs classes report,
> which is enabled by CONFIG_ZSMALLOC_STAT. However, these counters are
> stored and updated even when the option is disabled.
>
> Make the counter storage and updates conditional on CONFIG_ZSMALLOC_STAT.
> Keep ZS_OBJS_ALLOCATED and ZS_OBJS_INUSE, since zs_can_compact()
> still needs these counters.
>
> The behavior with CONFIG_ZSMALLOC_STAT=3Dy remains unchanged.

Do we need CONFIG_ZSMALLOC_STAT in the first place? Is the overhead that hi=
gh?

Also we already have a #ifdef CONFIG_ZSMALLOC_STAT section. Can we
just move these helpers inside it, and provide no-op skeletons in
!CONFIG_ZSMALLOC_STAT case?

And if we're going to have CONFIG_ZSMALLOC_STAT,  anything else can we
wrap in CONFIG_ZSMALLOC_STAT? stat field of struct size_class? struct
zs_size_stat's definition?

