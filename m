Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03000CD6E5D
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CA536B0346; Mon,  1 Jun 2026 07:53:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17BA66B0347; Mon,  1 Jun 2026 07:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091936B0348; Mon,  1 Jun 2026 07:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EED3C6B0346
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:53:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 93B4A1A061C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:53:17 +0000 (UTC)
X-FDA: 84831183234.28.EDFBD1B
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9EA8C8000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:53:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F+9J6ObS;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780314795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5ZZaFTUWyVWTNbltlU1mQREjKB4vAAmu6OIQ74Mh0k=;
	b=AcRF8bVW9oKoqPp+/B+W/qjrOVpBCNcZsiSnAd/jFZ6gfI6UddHvtkEQsA8hCzd2Xhb2RG
	+FHs2A6DtbYnClH6mt82gUCCrdgtXNM6LXrXIxGC99Xx0hOH3SWsgdP6oEUIG6Vjd0VLM6
	/V6Ama8HkhrwF4l/6aLTuo467EiCn2o=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F+9J6ObS;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780314795; a=rsa-sha256;
	cv=pass;
	b=wQfGyC3my0F3FC0EYym0sPsl4L12L+Zm4xNd4vyMjk+YrZOKVFncEW0pKeAwBoh9hERIca
	dB8M9Ggl+CfZv/3x5yDW+Q+9RcuJal67wdUDIH+snzaKiwCl9sfD/d4ftWrkhGCnXFTAFK
	fKNXVz/XLAWrmmEiCKJrVBnRgb06MqE=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7dc6255e42cso3517067b3.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 04:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780314795; cv=none;
        d=google.com; s=arc-20240605;
        b=kzAQUNp9aGN3eGKtqtMC+aEGHCEF3yKD1gR9gvBzdqUV7OloJ/WLASx8BCEq91HeqT
         4zKSmJdnN76/HB1/KzuFgGvnG2sbGieKyUyJSHA+2rHZFoQd6WkLcgxX3paGqOETI3BI
         dj/mUQqip02fE/BEpwUebEbUA7SB6PpP6408Fqwuipp3qu5+wcw80LRczex5uT5X0cJK
         Y5uqQx5BAmJgeVwcaPrxSsbyLuXbLyCV5rjPGRbBsD4PLc4CKZ4c6xHbBnwtOxeF+Oys
         F+1ntD2lL6YSUx+qLt3n5lqwZxyTSQ+Ro0JdzGrDxynplQOjNiyX0Ts6OgWNzZ624HcO
         91Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j5ZZaFTUWyVWTNbltlU1mQREjKB4vAAmu6OIQ74Mh0k=;
        fh=V0TJwILCiToDWk+a7zrRy9U7mG7BaL0sgNdgvCRsPaM=;
        b=Yf/Qi7vjeSblmr1voJjF5RAghC5i/ravrE6EKpr1eCAsm1ud8BW7RPzIiN46qmKCw8
         iwUDAOyo+Wuj3eQZrbtYwWa0rVqI+8Bk48dtO2R2YzPsV2NrWEhtWZfBXUYGKAW9IwLg
         7kCTRkvafgCt49WytdEHMW7/A+HkOwzwkJGOrO1/FdIEHZC34rxuwJQVoyO5qR0YeVp6
         wM65pljYHBa/lI7MoEfFtajwk6TnV7thF3ojo14Ja9SUb2T0mKiaOYJaO2u3l7LsTX2V
         JusQ+Sj4C29HgwIakhVsBx4q20C8hd3iHNqCsH0M5GNbvVSy6ZrzAInkEclMW2PzNg4F
         iUkw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780314795; x=1780919595; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j5ZZaFTUWyVWTNbltlU1mQREjKB4vAAmu6OIQ74Mh0k=;
        b=F+9J6ObSGhVYXghIlwRt7ug/NhoKoaikdBK5eI4s08sxw2v+cPFs2a1Ur9ZnqAVRGZ
         njqM3WE3pLPZiJWS6Y6IAz8gv49L1T9UDtQgVKu02ZPosCdBBFjJ7sTGTZio4gvpvxtc
         1K5SSSHw9a6ufgOVsXK9Kc8E5JSEbyq+LaZ++Bkf4/EfsDDPcz+qPREXJEIGKqC6Tpv7
         L27MHjtVW3PhtBZJOTBlBlRI/KRS+eU51iwz1fdBva7N6dezCpEJzC8DyUuMM5BeqW0f
         zng5pbqqifnQhi7VuuPdetxl/bt0H7l6uCv13iCc+endBQWCMM6xoZKZ8KJwcAQAHNz1
         l0Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780314795; x=1780919595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j5ZZaFTUWyVWTNbltlU1mQREjKB4vAAmu6OIQ74Mh0k=;
        b=nuD1Ca5I//+HuYEGC4mKdYG54kkzt2ou884QENaTEkkeGgKc/lLUHWnGzHOf9m096b
         XnMQDXeilgxypeacQiMihOtky6AUHq0/WQpdv6nPzz/F/wGoGejXAg/7ZQQF/8zM0Ku2
         7Z2aox+ROFysdjHurI7LAApdGPlf03b7a/J1RYX/JSbGCnhNtQFmDbfc8/MxEECo0iwh
         MuYpdSy5xIWCaPzHRcpZPniM5kcQJPoePUAyXS5ULQ/spEADoLKwY4zPz6yDEO3XZ6RU
         YVbB97XDUrnKq8cs3dI9TtzYxTVxRY0P+vtwcS5NZDq1YbyOW2xQN7sJYxhz5w2tHLmr
         Ul2A==
X-Forwarded-Encrypted: i=1; AFNElJ8d0BxrJoLNxZV2c3xwSt4VOTfIqbw5YpbXwotdSuTiIMkXjNj72/o/bnPqo0hNgriV8mt+6+wfQw==@kvack.org
X-Gm-Message-State: AOJu0YyqZbDJVk2G4RoMg8kIy4e3X3Kth2TjM3FS94RKHqosjDVqQB8x
	yaFgNSfwAmrirTqaRtzI4F6Uj/71HPwItJwaiAcYpzooiQUVxkJMMBXzWOclIDURJcMs5xlIUzI
	ZGhf4MbW7xPCjzPo8QjOZau9adSQO/kY=
X-Gm-Gg: Acq92OEXn6aT2TzwOby/64odgshBItbf/lrJSa46Y2TzWyvCnVLc+fYkRHvEMr2OL4M
	ahhMVhlEGt5agSeeNZcn7xbMfLVzZTIn7cWXdsGdEU6CFnfDSYrXX7hAxuXfkGAwDj9fOsVrBOA
	VARUBA7LTvxVliJLhkxPCsxekBCmFfp45Pmckfp2PnoGX6JWZNEd6xOJgrB5F7VSZ8vhID0DZqO
	QTEG9f4EwOZtPZFxscPgeYn/ldzVCvnSa3pNL7Q7jGeDACIjeiBHP9L15yrCXrjkRP03keC/CGc
	K+PaMxVRxaQyDHTRP244FDhbczp3elxbW/MOSKg6QWXkYoMUs20MtaEUidaHVmUuM3nWcJcEhMp
	GOlUSXVtvPt1X5L297ct09sT6CLmKaFI6
X-Received: by 2002:a05:690c:a685:b0:7b1:2c46:94aa with SMTP id
 00721157ae682-7e05e285003mr40275437b3.4.1780314794574; Mon, 01 Jun 2026
 04:53:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260601121122.94379-2-giorgitchankvetadze1997@gmail.com> <ah1puPfob4Ux3BWi@kernel.org>
In-Reply-To: <ah1puPfob4Ux3BWi@kernel.org>
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Date: Mon, 1 Jun 2026 19:26:00 +0400
X-Gm-Features: AVHnY4Lxed8548TOfn68kOdGejDu4Lq90kBK6P5c-e-xJ9aiRQZXXrzDA5a3zLo
Message-ID: <CAE7dp2quHOofO4T9EV9+s2qb5o0jY0yO9L1f1Riu605OOWXbQQ@mail.gmail.com>
Subject: Re: [PATCH] mm: mm_init: use div64_ul() instead of do_div()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: iqp9rmhz8434ci7iw86cdd1rq7kq9pfh
X-Rspamd-Queue-Id: 9EA8C8000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780314795-913847
X-HE-Meta: U2FsdGVkX18Y+/h8qtoPhlSWIQc3SE29c7AOerNupOH+yRj5j8u+UBQjy0fv/d1/kbjCHSvzwWYxCoKo8G5ZBgZPiI2rAoq6hiSkmm1K6Wa9ucjLDBw1QRAtp+6HusJP2KPqc/zijTTc/SqX9YxFiAd4a8idfKfYlFJsvRUenCu3KcoBSQ6h+23R4/+94EBs34VvR4+Ag2goxxlIqad53YnFI1oZ4JmGcSa/+bwa/nHb15z8r2bCvVigHDCkHHKkfzWoINLz2xxzwfzpKJfuza9kfE90jOPeT+queJgpJ1uyKHD7dYOq2exEcy6b8eTHmwX6aPnNgVUKVdM/Fh7Rn/xCPrkWjJ523BfFbRXXyqHa8OPx+Qzd3kNUxWPnbyinbwf9voLoesYITWzA26S/r0V5twGq5fMCYXaKRTj2agN02/RPu3qu5GiWJYGwnjG0Mh/duzIrlYD5EcWGzzB7GlpBVtuFQAraxS0fXEG8cUIdczmAZEjABZQER3opEnNkinXpttSVXL4ckNCS+vsYeGvUcbzsGDMQz3hUi8tbnH9xkGx+M07cwtL2/tZNuRjsrKI5M5M3vAIpQFs1ILAsq3/ROPEt6SI0CMpQu6K1/WyU9gSHQP1RbpdtRc/eArjdkeJZj8/9Mlwo3xpisiNTDGjnBLczt+e0gZKnMoRD3RW94b/3bolLkhQ+cnmhVTKR9uKvrfD+Vnrwz8/qiPJdGoBtl84jkk4nWYFItXLna4/rvrXE90zpkK7dh7/tqmsOSpXTjG57PjFXGHqd7v1YlJUVu0fXDn61t8QJ0dwGxZl7C03IzbUJ0rCXfo7PtSNS736xSYJcXZo+E/XJKqvN7c1z1gA5Un/oyqH8K3FN9EivQsBFiEKp+tQIZOSEzkyxlbV1ijHwu/tEQDdhH7en8vFgCPDc5a17CYMMoDT8Bbdpj1BDAz/IC9UFWa8+HgJx43rcJItJVD2ayo2XFW2
 y59iohlF
 oSXRnc1Y/I4umsWWs29ahYxtsiyrVBQmpMp9cV633qnpJCd5gXOLm4ad4qxCzppD6zipZSnr6qmfdylkJvlXW3M5wBeGybEtGkeznAZO3eCG9YwyZjNunicnkgX0CfXhcU9ciBxhA1F9QI3qUje2tm1O+SUN9ea9y6l5g74vBdsQDyaWDYzLjW7uzgn2B4n+cZDLhjyTxM3Um64ol2BSwAFov0lqwl1qb47TkXK3ilzbgeybTT8rqFx/EGJLUMQKfH8MQG4wFZDrSEuWPCDDIlRLzf0JHbz+3RD8zaPNfjTCGixwYKM+PIC/iBJUJmp37iN1H/88jJ+CYz2sIu595yQ6MoHg4x6lLlreSGBbDKw13KrhiQmRn0AdgJuAYpEmz5kgT84M8VRVDj3D9NpsHXHuogPxxOeUaaeZTTTaGPqN8Mt9xvN0HHVFpqyszox7ISihg+nUWnPpJA4XmC6hhFCiYYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 3:15=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> Can you describe what are the actual visible effects?
>

Hey Mike.
The only benefit and effect is a semantic cleanup, it better
communicates the intent of the division and resolves the Coccinelle
static analysis warning.

--
Giorgi

