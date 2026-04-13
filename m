Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2918EF34C60
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9420C6B0092; Mon, 13 Apr 2026 11:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9196E6B0093; Mon, 13 Apr 2026 11:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856926B0095; Mon, 13 Apr 2026 11:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 782AE6B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:06:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B0F41A0230
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:06:08 +0000 (UTC)
X-FDA: 84653858016.06.D46C686
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2374EC0015
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:06:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BIsrJt/G";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776092766; a=rsa-sha256;
	cv=pass;
	b=GG790fvQX+on2oY4H5xfXJRYFIVx+arRkzO61MDmiEF1nS+WjzO/5nbwyFJnIxsp6RNkjU
	84ikXyO3RKNDLPbetTn1wrvrd6aoOdX83CKoAZ4LjtSkhgKamEEKu/G1u9suFlR9HF7Ws7
	+AdSUc2Rv8T95TssBChppr46bwU9KHE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BIsrJt/G";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776092766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=15IO0ZZ96q7bfJAZjUOY5BIk/Zn7/LjOZ99Q4LREgsQ=;
	b=wRyuMZLqdqp4cLfLp0pSQ9IRQzwuBKl4f4fxsy2uw6AOTOV3Aq+eWZtI6qkI7mGkZQVRc+
	6i3gQ+1T+YosTf1ndHXSaoPJwsVgm7ZHj5UA2vaCTB7ZDpet8xatQ/nhXBUQOiPY+1QeBQ
	2549zhRAx//52hzLBScKaViFFrM+HLY=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso43286765e9.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:06:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776092764; cv=none;
        d=google.com; s=arc-20240605;
        b=Dk/kaKQVEgKnXTJYLotubGtm98ZEodvWHamuofwm+CEc37zj6M8gIzDGLiyqk0OxgW
         HfeGSGaC/tQ7fHZqNJIiVHzDL6fH6PkPYLWlJ9BDNmImInLuOE+xPEPadmJgxt19f/o4
         xm0+AWNHg3J0mRTS/voeNBPMFUlK6Gl2qhAOuF9T/JBWy4mfBYNTTBRsri+yg+cMUlJe
         88xQhb7ECD6qRFvKvIPndZh5gMVeXuROrsziAPd+a8Kylb9t6FhP/ZfBfq8RuqZwnn68
         N/hRLmR6lGqSUUGsgo3+Qe96q9bPcvEm1K2d/CV3ohGXjxeyNDl1S6OCgtc8xa5HHpoY
         EYGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=15IO0ZZ96q7bfJAZjUOY5BIk/Zn7/LjOZ99Q4LREgsQ=;
        fh=PJotS8CgxyzNDrBK1yIB5gyNcEHvJNV9qmzv93y7UBk=;
        b=GS8PiVt4+5XY3xTMoOyE9T7qtr9WpIqaxtYpU6HqHk23g2N1KGiEGj6OyxjLdNFR4j
         Tbnty5ljwWNv5NYVTQPwCC3Ij98t0oHKRQbFxqSO1uAPBxyw3FwD6YoL12AdrBC1R//h
         nwcZjjOlUEurwaLQb37WSsAD2DdOSLJmBMCX3ev81EfPCUe99kJYZ0cFAWLhqd4YEtaC
         sDaJnTghI2CJwEMSSklSLLgpjfZ8wgCY99WzjQCrjvVuairndP4rJSk4tqiOVR88tRXX
         mf6j92hQiscfBIJccDKffbuy+mvnQJyrMQX8Gf7p7juYjK0pCoY0SP6Nl+mAiPfOpGXP
         1Nuw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776092764; x=1776697564; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=15IO0ZZ96q7bfJAZjUOY5BIk/Zn7/LjOZ99Q4LREgsQ=;
        b=BIsrJt/GktwsoXBnpNdogKI1iImwib/6jRJGVc5+S57t2+XtN9ebomyxY+z+p+m9wW
         q3sxdl6UkvJDP3PAgQO4RpdjEdFCpzzpOIpNnyymznn61OEaUKTz0okAdUe4RFYn+uGU
         GlQC7MNwmbtnTSHz+QzgAfl8P/2pF8y7VGrvD0cA+JQSbpaq9s8OSghN2W/yBZ+md+fq
         JF2jZtnUYYEh0Zq7+VgVUscnY3t4KiaR/R1boxPn7ZLUcPeouvxA9lgKQSD5+Ddi8R9E
         yFsCHbo5pJZfMz+3G/74olMOSNHR9/8JZsv4jJEXZU6VEoybWD+vDeLSNqCX/UPX+ynz
         3Y0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776092764; x=1776697564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=15IO0ZZ96q7bfJAZjUOY5BIk/Zn7/LjOZ99Q4LREgsQ=;
        b=FgPG/mV2kev4ZofA2ILZHOZ/+I+3LZoIQmdN6O4HGURC5DtxlZhbLXSd9jeNckl3gb
         rko33n598weg7RUVvZa40CFaEigguyULXtNczTxWtIBvp7Z4DytssEux8sGic1ryzKo3
         BD6EIkaw6T56aE9QyRaxHMcPJRcjGP824uAgfGm/Y0DJmFrPHGsoReyKx4+LXh9MExVc
         3JomAd78IwqK0ytzy9P9+lM+A/5ytpKxJd8U6S9pG13of5LQULIrVdo2yQ4g0ZDDWOuy
         uaz5X+RC2eTLpAEryFwEBk4CneF59aB7I+kjdI2G/6VUd7+BAdzAJhSQnX3vm+9dIAS1
         jmEA==
X-Forwarded-Encrypted: i=1; AFNElJ+kzvQrNQ3+w/KCKJCvj48o7YUuVoHn/OWNcuGVEFMK5iFNk5TQ2qDihL4QsPOxt6aDxhg+55heSg==@kvack.org
X-Gm-Message-State: AOJu0Yz3KW7KuWrtYsEAHxG2Yx0I5HNOVh5B5UQ+N/xODDncFYxUUqiX
	wuHTkyhtWuQaYnFhzx909tVMfcVyl7hrLIXNlZDP/SPlhT8TLK8aWOsry/vmLQZrf/0jr5j4zH+
	DSP66YwsZn2ar7ajFeLBfjDpCt/LY4P8=
X-Gm-Gg: AeBDiethxYuCqwyTSyFpk2TWoQhUqP9N2YAEanHNlrwWDb7UBEauIYH/dMYt/mPdsoa
	vBLV3NS2Hl7OdGHty1eMRFbKIMigrvMM6lqE5Qmxc81xw/cqHGmhmYgfYy9yL0921qZBl1kxIgD
	WvON407XIxU3ub4KKlZPHQOimnmuyWpiZYe4/gmacp/cB5b1Kc0lcTVBM+AD8BqrZ4LImRqAzWE
	oIeDzp2rHZEpXU/rjYQJdpoQCWA/4VNS7HUmtgy03wg6sf/ezDIjzeWS4fRt50yEuj/vB1p0wTF
	fjRtIYAspuTRKHf9xVxZd2z41dtHboU0dd02nmcY
X-Received: by 2002:a05:600d:8449:b0:487:55c:e0c1 with SMTP id
 5b1f17b1804b1-488d68364fdmr149985205e9.14.1776092764231; Mon, 13 Apr 2026
 08:06:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260413094034.6944-1-pmenzel@molgen.mpg.de> <CA+fCnZdA6GzHRifhwKCU4pfZrHxzr-btOeaZqgH7KnNLme2u3A@mail.gmail.com>
 <ce76f184-e463-4bfa-afab-0a71f05eb587@molgen.mpg.de>
In-Reply-To: <ce76f184-e463-4bfa-afab-0a71f05eb587@molgen.mpg.de>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Mon, 13 Apr 2026 17:05:50 +0200
X-Gm-Features: AQROBzAyGr7IHjoRr9Vi9a4IjKyGj4F8GRWNFzqRZUqRPNkYJhnoomSlg2vkZ2g
Message-ID: <CA+fCnZcsPehxMCP0v99Q4nsrTiEq79YKou-O8U_iRK-wBmTf1w@mail.gmail.com>
Subject: Re: [PATCH] kasan: Add abbreviation KASAN to init log
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sw8umxn7u3dukfj9nccf1t8ekyi3gz6f
X-Rspamd-Queue-Id: 2374EC0015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776092765-591667
X-HE-Meta: U2FsdGVkX19RjEgSUy/qFBLNunw/NlqXnem7qlUKN1iIeud3tCTT/CVtF2nvNWWkiO+zrl9HiAZBIakBJ0tkJ9ST+6gJ8E80bbc1jDxBEVUhLBFi1qhIZVShsFWfHDQNNsd8dCyxMHmxteu+32bmepruFuHzSFSLGfB1ZkR7LS9Nvi5BZRrAcmmkTqFVq5QQUUYflif5MUsr9KsvpM2IkOLU0hcLv2wHVPpXA9e2ugBam+xkKpXmWzLSC7BUf/9vhvXiYlKXAqvN0pUzKU/fIdPPJQaCj8VR9BhnkfT4dKk2kgzHeqZF9XxoX9GCuwr+/N+vhn8RgS65a5WkZnSXkoYDidvWwppuM4ggrj7GLa6eWq4LcpaMp3OZUFUVuVsEPFLAHz2yxZfVWyXfIp8fvFXDKjRyO6ZXCZgVr7AImX4cwhQA5VACaG/pGP6njv41RMYfB7jRX5ANHexB25EyCDxWahLHwp54m4pYLzbWIHDgkGLWbw3/AQoKeA+9d+Tm/uwRMPibXDw+DS6f/QZHQGlmrnxiTZw8iR9jPx5q5d/yNj8CaBedIizC9PazztCYDb5qWF6rFxPO4HmZJ5JjUH/AlDVY+JUvjobxi16g1V/XlWT5EHnfKPcgKbsnGuwrilCwOfFR7lm+//E0ZK9xulZDRO2aVehxRPESIJh2KFJdM5pGiGGeaUDSjaLAmECE3CrNy1Y6vDNhL0kl80vkxCtS3Kw2GhmbPmot6sdKokhj658VdpewqVoeWkJF105bsvpQhh7Tx4GnRaKiMrD5DvYWDUlGqcOUBQKVW1GxsoaMCS6Pt4xSmzRFvBtc0E1Ug4SLDNXOFmXn/0kMjbJWHoZ3p7/ln4UL566WI+fSFjFuWXmb1+WFmNosQYPvVuulFeg/jdP4FwN6JXkQJtJHDgw/BFiOdZXq0IqFLLPVmGbJjdpcnXlRH6T0JszKSWdnP6MbCpIIfGTCyK9RmCc
 j+Z9U6jv
 /pRw2DwJWFcrTBit4DoKhusKSkdFBsjtikoPLQ0VxGEPnC1QfatWmaNtjMJKIvRuWk6TUp2UMe0fzj4/KEroLlfJJSBrEeyrQh0iq4YvFFaztLJttglxpg+nEnFP3GHJah3vHtNFx6xHxq9CXJkWh5giCH/IrQqvJjSQxBBhU0PsG6evMGAr9E+g3KXfj9OdcCOXbg8TxQLMTAZYwzzBoCtG2FjFwCen9olOis92dS+z4FiheBhAaEWE5xn90l7mw8h8mT1/+qpGsJoFN47u69tBtblpjlRCrHjOosp61Y5mMp0kqU8mJwWQsvZTv6EO5q8jIko6GfoeDGqYOiJmiBp91Dx94845nQvPnguCKR/UkUn4fP/eS7cf1Z/CoszWGCwltCNTxQ2XdTXrdC2l2TlR8IdkN7g7lR1OLeG8OVpjFyh2D0WOZYzTybEpz4RtR9YKmZFCMvJn4ywqQ+pGLaFukKa1+TKoKBcLn95VfEMaqPYVondHY+idqNB7pSyII51Gv6f3SDRuXf5W/MPXO0Fg6xn5ABh8P+Br4O8qa5T3WHrw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 3:54=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de>=
 wrote:
>
> > I think a better change would be to add:
> >
> > #define pr_fmt(fmt) "kasan: " fmt
> >
> > to generic.c.
> >
> > Similar to how this is done in sw/hw_tags.c.
>
> Isn=E2=80=99t there only this one log line in `generic.c`, so the general=
ization
> is not really needed?

I think we can add the generalization just in case more pr_info calls
get added in the future. And also to keep the code similar to the
other modes.

>
> > And arguably, we could also drop the "KernelAddressSanitizer" part
> > from init messages, to make them look like:
> >
> > kasan: initialized (generic)
> Some analysis scripts might already depend on KernelAddressSanitizer, so
> I=E2=80=99d keep it.

Makes sense.

Thanks!

