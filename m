Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D8C7EA4E25
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB896B0088; Mon,  2 Mar 2026 10:38:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D896E6B0089; Mon,  2 Mar 2026 10:38:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8BC36B008A; Mon,  2 Mar 2026 10:38:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B62856B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:38:18 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79705B68C8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:38:18 +0000 (UTC)
X-FDA: 84501529476.06.AEFFEC2
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id 709EE40006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:38:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ijOoY+xJ;
	spf=pass (imf07.hostedemail.com: domain of acastroramos1987@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=acastroramos1987@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772465896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYG94TPbWCbZG8/V8D/k4AWAWl2gqqa5tdO0TdpBNkk=;
	b=i7e4eKEmKaD6NLOKTR9P1zCKkfq7WBCJRhnGGSg4AeLM9uOgOSa9PDoH21AFfHNcR4brgz
	ULl+o/i5Mpwp9aNgZeMeVloIGcQYXk3mNMkJp2Lw1BNQVPuXR1x/m5xEl3CG0UQzm/Pbgu
	qFCkwmosXGJfs74dx7J6OJhIgo2Qkmw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ijOoY+xJ;
	spf=pass (imf07.hostedemail.com: domain of acastroramos1987@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=acastroramos1987@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772465896; a=rsa-sha256;
	cv=pass;
	b=e2Dg0WG+qRH9xehL557T1LMnfPwwdPed4Fc3L1GXQg5o0FQ5a6wmZs7Sykcg8IGqTuC6M0
	H/39lIFaH1Tygk1enR4wrwDsHGsizSl1VHnJ4brMViyJDxr/jX44IRH2EVHN0gWL1fh7Wi
	P5T8V+IaG42OG2wwK1+3NfwxB2Y3kQs=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-389f200c26eso65162411fa.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 07:38:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772465895; cv=none;
        d=google.com; s=arc-20240605;
        b=Y8TaL0k/er+Qs81H0OO/hyYJfiZc8/rgc2hqN6/OudfI1uhUzPtNvHIpmxa4+Lv8f3
         K52F0pkofN6YKN4oiw+5wZ5BnWliDt8kzIfM/4yMIY/NGG/HsIazA5xh5BCcRd6gQ9z3
         vaSXJDf+xrv65cn+TjPaWjOOt1sWv7OPsqYb00Sci0yhW6oyIp8PxlB6ocfR2/aHYU30
         2Oy5ErupX1gxjZe5nXbLCM1cj1OEs9Izxd8pf2KwxTwLw3sDvQIgxZTc4nAAOF0Ln8Fm
         6aTgy6HLn3AWrPbM31qdwfIfgB4ZNDVCsaNMqwdsIUX9LT9+0oWm3gZLBGuXRX7tDv9o
         R5jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dYG94TPbWCbZG8/V8D/k4AWAWl2gqqa5tdO0TdpBNkk=;
        fh=h1N6bRfcDDTQ8mGDe0bL7/MEkvHj8tcbF8cN7ExC7Rc=;
        b=S40Vw0s/y2UC5H1wSWF6v4ya2hE4JKOztPHPXyJEIbKNHodag1cm+cs+nTnKpgy0io
         hjVAjJGukoOk+1N+lMKHLb9kXH6fdvg+ptXU5leComT1/9uUpTrRdH11YpDzhCArS2r9
         DJ+YuR+CV4YLWMVSuVqrcKKrNuK883tcDokLESSEOdHo03UWf8FqYDDrMuw6SbhQTORm
         RgiSgogBDhOzJdOLFukDRb8ve+khZmTSqagZSIoxDm/kYRrm8+gnuilvcH5yocHFpaNl
         747cyNyPO4L5lyZ/8dYDAeL8urDwpOp4tA0JGCmRvdcpEXrhTQZevFtLkY4rDnPxEysm
         sb4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772465895; x=1773070695; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYG94TPbWCbZG8/V8D/k4AWAWl2gqqa5tdO0TdpBNkk=;
        b=ijOoY+xJXnADQZjlJRskzXpgl7YpoCv1SCfvplmmvcBSr22/jhIqj9XtRWN7Upf6ld
         n6Zy8vrER1bmoGbQPMHX5UjoOxvVI+37z6sPMgQorPnjomPsDWaGtKEw5HzT+HIiWuTV
         jfmPuFgKjnZKI8jx2VDbYw//cz9Rr/nmDIf0ULXUe9sFcAxd2ur12vte1gY0SPpQDotJ
         DuJ7GCtEn84c54jthtguv7Eg1lp7TDQ8wlvU3Ut1BLHXRuhZ1kyQohlyYwQRpyIvH5Wb
         GwpRPulpZqfDxYPIZlDRlhoaIQxix5fcaCRjDZgAqNFE/vb1rsGmJEmSFSjDBllkNj45
         99wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772465895; x=1773070695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dYG94TPbWCbZG8/V8D/k4AWAWl2gqqa5tdO0TdpBNkk=;
        b=c2sqkuFncK/7makOz5WUlpvCSLPfW1+RbWzSyaEamwtmS8ylvVAFxe4OT0R1iuGr9o
         92sux0B4EtPdH8N8j2cFlO+/t5k2IX+HUKvascsVZOxM6dAkeI6fcWrYsuCdwhrbRBeH
         rx/BjwMLpz28j3y3tsgJe49VMsOrdU4uIXq5zjfh2+gn+HXZ5q/6W0Odkp7ON8Y01lXo
         OZC9J2DqcGK/l2Y1HnwWe/hi1Q7If7WjrYEe4THmDsb+xM+Lq0MDF49oO9ociNQ+kcJA
         pRTpEG5Orky14mfuMWbtG/fKjKdRVpDOGdlqYqABhEPVus49zVEri///+ChZnD/zDFWG
         YQVg==
X-Forwarded-Encrypted: i=1; AJvYcCXvFGsrm9xLVjEuAX17PZcCLBWMpsWVj6/GAMkMX7GuL68Ewq6B+TQa+43Wmsh75FTok8YQb81NAg==@kvack.org
X-Gm-Message-State: AOJu0YwZYAjG7KKQfxZLmmSElnzOBlsgd9EFeRr2x9tpJS6z/+cYUnl1
	l7KS6QLl1Lno1K8os6lpbGmfw7SXbFlkkERfBqzXH5b412l2P9HwtyqcbvD62ob95KZpZG0dYDZ
	9ByoOKuQxS4y0Zat1DXRv+dQNZjfeaGA=
X-Gm-Gg: ATEYQzw2LQ43SNvvpThnZu74X/mnlflF+bLoCPMtUc/beMUdKfLqb6nQgx93TTPk8/u
	ZBd0dbxOLEmaopSnXOTgtz+07aMlJYO1dQssIk8gNkmChAQt6mPPfuAHBeMegdCsZ8jxqy0eyB1
	v0xgBi/Ks4QTjsuBgnBF54cESQWxVT4mn9A7iz2rifxFRvNVMrQKTV0+sVjHr2o8xFNpO5wIc+u
	AEJgyZX0dOH9pb7aRK+nS0eCS1LZF1hux0hgUTMwXnmQhGTURLjaUsfKE13L98COUxm1pzSoumf
	MPXUk2VSuHjU0CWUOqnKZZ5x0zoa5dlOFPsKv3KJ
X-Received: by 2002:a05:651c:43d7:20b0:387:df8:9373 with SMTP id
 38308e7fff4ca-389ff1197b7mr60947671fa.9.1772465894306; Mon, 02 Mar 2026
 07:38:14 -0800 (PST)
MIME-Version: 1.0
References: <CALXtAv3u1hgLkBEbEgR3=r_iz3=KrnHB8B-=tg8Q3CEOWAPFiA@mail.gmail.com>
 <aaWonCzCLayQDXOT@cmpxchg.org>
In-Reply-To: <aaWonCzCLayQDXOT@cmpxchg.org>
From: Andre Ramos <acastroramos1987@gmail.com>
Date: Mon, 2 Mar 2026 12:38:03 -0300
X-Gm-Features: AaiRm50gg3Y5F9SqTPBhJaPRyGUa-m39VJsleid6bB5cl7M80SOXalQD6eP8Sbw
Message-ID: <CALXtAv1=p2h7fH21SKgVktTSrafB654hL_hgUW2WNbROSr0wzg@mail.gmail.com>
Subject: Re: [PATCH] mm: add Adaptive Memory Pressure Signaling (AMPRESS)
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@kernel.org, rostedt@goodmis.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wuoe1eomnqytcqshdzqn97dp16yppbz3
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 709EE40006
X-HE-Tag: 1772465896-198921
X-HE-Meta: U2FsdGVkX1+xgCz/X22RGu2d6KiO5DcYCH4LO/iSueHMkfabXIWBJNSwb849F+fM9Ad75+4ihRrqCDjW9GsQW2Lpay1ExPVMqEeF1Lt7kPPrAKr4dcp6r6fXp24AZPbk1DvbZ0E7JJra1EbGwK6BieiZMjoew2wXRDZQ8Pq65KAIF/fYIXpniVRmBwJRoChTiRs8uej/RbGKmHcGEzSlEmlJMBQNuplGmcFYiwNqplgsw3QRIt9Vbxc0bhDKdDw4QB0H9TML5Pwu7Kde8so/SQAiXDqzEtcYY/4C0NgNIoyUuV9Fd3WcPiTAzmEvKFPCVt1TN+e/YuGU9G8yFILZyqEuHgTy4YcVZ91E7pzut6mKCEAUtIivddmqZfGzxEgVlPurUNcSLASOHdgYHwnZVs0PibtuRdyB+4G+1fT+eOcdXoFwWzj8oy3sIguFBBx22kCRTY+BFMEx2X8FO92EdB2aWnGHxnvgDpyKA8oKKvRNYTB1eUCAAj7hXEmUkgJpESMbvGzxUEw9hnvJA/jxOU2NCob2oFg7cA7jqUCdSO/Z3WBwsoXMDuYTZ96de5KuqV9AvXdjGpcKitBYT+QaIKvw7W7cd+gQLJz1GUeNBSTGbG+OYvAgi1d8bOfJYPQyY3eiGJKuqAggiaDLFY5JGfXWMZFvIisXh3j5nVmpbB0wyA0dw19ly6PYNr1C1MciHLNry094UsvZ0RmkkjsCw4q1Kjy23TcR69zMgWcGm3esM/pHmfzgDEya5p0tEwgO5MtD3780OTjNO2/9uv4NOSO2OgwzAl59Tt4qjvd3/jyTAT2SYIDvgYUcCIZu3WkNipjrc5hpCMPOK/jqX8vNJ5TeSXtiMER2ekgYgsP4t88Dal4/4WhGBUv2qQ8HUD7Ci1zWCwE9sZb8PWPGCqiUs+ummgfejmeP4+9xH/+YSTon85h1Unl/Cfg+WT8sQvc3L3Eh/OfUGsvwGsrnnkl
 7ncM65S2
 T8GhaF5MF0g2JSERlFogXzRnbQ08RUgGfOX/7Tg/xMMCoZFh6gnlPHH0jFQGayuykkB7GUNHhI5kXL0h01KkPJYnPVvy8n2dYjdJ0GOrc/DTK6Gxnl475zmlmBH6v/vkwUo4lN0pgahcNThpfenHCPA7Szi3hGVjue8omJoT1hEtYWNQHforGm+Zfx8O/ur1rDVUw0DI67OU/W4Y1IN81Gq6bZJSygFXEen5iF24lja2B6e6nhpYJmbm2FN/QLERyO52aOGNxqhRp4wctTLMYu04Y64onUOElPCgkpuIeWzAWDfvrj3rEbJWx7f4OhgdRCfdkZKds0ft6aCtEKSFLuWo3urqkhv5k/A1qRs9B+APA62YQrvmGJ9hIBqR+F4ZE563o1I752/3hQ97H32vs2oG7GlE1titlh3v2aW2iZGchP2wDCne2EgR+en0DO7wvWdlzSjwbH5NgU+CITW32guCbesOvkUdK9x++UuxuzoqErxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you all for the review.

  David, Lorenzo =E2=80=94 understood on all counts: RFC tag, patch series,
  and the maintainer entry. Noted for future submissions.

  Johannes =E2=80=94 your pointer to PSI is appreciated. Given that it alre=
ady
  covers this use case more correctly and without the reclaim path
  overhead, I'll look into that direction instead.

  Andr=C3=A9

