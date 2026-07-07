Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AC53C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466CD6B009F; Tue,  7 Jul 2026 09:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D776B00A5; Tue,  7 Jul 2026 09:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355EF6B00A7; Tue,  7 Jul 2026 09:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3FBB6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:24:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6170C1A029A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:24:24 +0000 (UTC)
X-FDA: 84962049648.19.D6A4367
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 75617A0003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:24:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GoMWlXPM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783430662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9b8BbHxhkf1CoCrJjN2FxRZeuKaAhw6KBsFbbBlQaHQ=;
	b=aGtlrz2yGL282RAWrmy2AHcfZ7apiY85R8D3JF7LvrEQsGUS6YbuZo8MMNo1cx5+DRKoCD
	a8JggBNNW72q8a6BdCUpGaCyYSQ7BBOOEf1WJKPPDSM6zrrbsxkcGoj4uUrrNPJoJlFT4r
	NpCIHit6oA8WK029Jqfe2u2nZmJb/dg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GoMWlXPM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783430662;
	b=jgeYnJNG8uafsRYiFnkVlohuoYhYnEGZ3XYzDtyUp3tVqccg+N5Vys92VxxsMECGjXZ79B
	Fa+rtOauDYhqBT8lu8vYRUrG56A05p28AyR8qldACcrhuyN6jYFXmNbdTXD9WcItULZEIt
	yb3vDZIdeaj5ySvD/6bkQnWDGibhbyQ=
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-664dd23829eso3817203d50.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 06:24:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783430662; cv=none;
        d=google.com; s=arc-20260327;
        b=kE+uuR+/ZFYBgTV/JToPYoEv/qUH8XMjud5NzWEaNrxx8kqQRP1AdWu8mHmig1a8zp
         Zn46pNeEVYcUQtfF2U2ozTrIjMrTz3SAImlDFif84EftMDP0I4zjTqcD4doPuRZYmymD
         F5Hf1TwThU7JlislXvJhiE9owGvVK8CvuhPonDYWMYAeEEfAQQtkNDk1Ec6HBa2e+ZOJ
         wX4aanIYF5zo6q7FA0H2RcJTkytK8iR2oJHCo6LaVZCwbjskVNE/W5eAzeG7s32Z+EH0
         7ANC1g8wj5dCRJxOYjSROpjBAsLrvOf88WuMni+xzncwOiRgCC1HBnIecixXrCWhVXOM
         bt0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9b8BbHxhkf1CoCrJjN2FxRZeuKaAhw6KBsFbbBlQaHQ=;
        fh=NzVUeuzYRglgwzpQR4v9WHTEIHrYnlz0y5YqrW6daf8=;
        b=rDkwqvdPwvC/EwbvlqGPLr6D0tOmGbn55vI4YFc9jE6KMrwpuFyemfknN8hthyBgSH
         +QdB3yfq4Mbg44Qp29ZAK/eouXuYla9q3NeVXzP6XnxMy0uWItfu7L7fZQVeN5dWmEdW
         1ciiPQSICUzj5gX2h9uRSE582Pi37jWqHLVvPfkJwZUh+/TJdWfAVRRQkgXHpcpDGmsw
         qal4QztWhR8R+gaRITVtNWDsEtZzn2NgBn6qo3FzZy0aPSwX44xPwPP+HtKYZa6rsUZM
         Una7LTfoBCiPVhn8wrjSMfs4+lSbKsfwOTdkBFZzhEzRKjCvec++UTcKC+OPKBRwciMT
         pZuA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783430661; x=1784035461; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9b8BbHxhkf1CoCrJjN2FxRZeuKaAhw6KBsFbbBlQaHQ=;
        b=GoMWlXPMAcs3QAa2JWNyWy/5vS3If9gG14WMo27Qv5X4hyVLvYPDnHiPJuAsNaEbIf
         JKQLRlJuK0F/hK+XzoIKG6ltnH5SYzOw8W1e2pP+tD06Kng5pL49nV2QyZJy9jM1zkX5
         5KvcreT/8LQrAUDeDy3PBS08Vfmb+gCYS/vtZjxgvwS82fiAg3jCjY2Ab24/dwATlA27
         AHCdC8nccFW9rwZqwqhDtuBxWCcd2gBN8ubcSadF3+tX7b0rIPftey9YBhaH3robfWLW
         50DbZvjp60An+CrjNzYvA9TRXUp1ZpK3nIPG32sSOebKMcoThSNKxZ65lytkIJ8BZRhi
         75iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783430661; x=1784035461;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9b8BbHxhkf1CoCrJjN2FxRZeuKaAhw6KBsFbbBlQaHQ=;
        b=ityXCBi8pELdLie06dbINS1hHzheWC7zNjsajHzBBfeyFKv9J0pXcBl70o27G+7zPP
         q39NFvvV8yIfNJD7a7T3jbuYOK/XHD+RmORkW/LccD/zIM2CjzYH0HKlzeMUZEPewWro
         h7mRS54eOclQ8k9sq1+s5MAqDH9ixDPjfTGfjRxp1ChvmDJHKALHz8E7QeLleCZXviLK
         AW/qSuxdlAXigrgL8tHdRMUfzpsvoE+epqIdAK6YVKzlG7JV+Ix+fCU+H50PrwVv5DWy
         T8k56xKZseVxA9GCddfYokEU8JV5j58pehTAAhd9uLjMfWRtzn9YcgRWaFhW3gboqgsx
         +wcg==
X-Forwarded-Encrypted: i=1; AHgh+RqsvdEG9Vb2zaZSuHL/CLruh/X2Qdg9MUDAmv3NQuGpqfFPmIj5xGOCTZjJHJaII3FErB5g+xk/aA==@kvack.org
X-Gm-Message-State: AOJu0YxAH4QqDKLibBYauenJGzOUyv+3Zb7yQBLa+tBt5wobI1JzV9Ei
	m3N0sVXyQKHcooIORVGlMfe6McuYQzEyg59JDLLIfUSWb6P0PO+u1CIRyk0A0lnQcF7kEX36/OG
	XAWD9Mv8g4cl28PYWuFz4/2rVqXbrfK4=
X-Gm-Gg: AfdE7ck5fykY2x6uf3HIzAAMzWydoBmYjerHqA921O3fgZL/omPAzUGJZYJ7B4+CGps
	Gjc1hK77ZzJAtudmd2S/AS0hb0U1gsU4XIp7HRv9xuPSBpzsCrbEapymhVk/IXB0Le4PtmB2J0k
	m7FlTnGNrg8xbR9suSzMrhtayjE++IBFKmZwPKYVQDRhJtpJmWMg/rKlwD1ls3/z2UJNwW6W9T3
	/tXV8h/m3VtpD+SpBdJEcULYtzs8an1FLaYdikK7JcDC0SZUnrAhFjEpALrFBaTWcIicg==
X-Received: by 2002:a53:adcf:0:b0:667:8b90:2ecd with SMTP id
 956f58d0204a3-6678b9053c4mr1264848d50.108.1783430661475; Tue, 07 Jul 2026
 06:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260706163753.193875-1-ekffu200098@gmail.com> <akyZ5DhIV_Grn1Kc@kernel.org>
In-Reply-To: <akyZ5DhIV_Grn1Kc@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 7 Jul 2026 22:24:09 +0900
X-Gm-Features: AVVi8CdmNSJCGxYOGWnK5wJL_8NTvAWhpJlXJNdpTu_SgODQvmfDBt7ZZCk7fE4
Message-ID: <CABFDxME7ig1SQDB39TUeUXoAOA2jSRhg6h-bm0kUHrHzGYeE-A@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] treewide: remove unreachable memblock_reserve()
 return value checks in early boot
To: Mike Rapoport <rppt@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, Chris Zankel <chris@zankel.net>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Rich Felker <dalias@libc.org>, 
	Thomas Gleixner <tglx@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, linux-mm@kvack.org, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eoe4ezby4yenj97wk5rt4ph8p74h36rt
X-Rspamd-Queue-Id: 75617A0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783430662-5543
X-HE-Meta: U2FsdGVkX1+uqg+2xPRWgbCJE4MoRabeAJPr7fZPjMKfe9o4lVUGCZr8lDgzXNmq0+oxVoFOSkhMsnGgfXgQx3esihxpm5hyKxy/M81ads78oHqERQs0DWyy1X5UBM9ZIV5gQmifoF1+0o2krGJcAkOhHHCcPBiIotT675OLmrB8neXvPOOhpomW8HAVohUy6A4fCM9Fu/0GAF1IJbflK6yEm0O08rkOLHHFD/X1W7vtzCMvXJ5ZysfPEsqKTGE7l0pprb4wvDAa3Kr4BU9kY6JlaD5nrJpiyCYzLFPDSH7BV/uJhCGzjmUSSlJJOHtC1yEIiWihhcMKC20XPu1/qn6g/0OgEGwmjEMoGQoZzL/5QdWsH/TuXt5zEVQ+qmodO2Uta40BidLlIa/JkGMj37f/YVgyNdgiax9zmjwW/U8ndXvMtUDHC3uWWQMJ7i6GXH2jxQTvMH+wgW/IDqlOe18uk0oO3F0lLT/6eYXIrZkDl8DuHNN2nWpf6Zlux+gzN/Fm3VxYHHSPD2eq3huq0tuTpNLyljvdKU6oIvYdcsho+n3BgcfDra8H39b5ewt0AfNKBsy6Uef1kg+BvA8OulvEz416jGlr7focsnHQhrK7y8bXx3B+TCq1MgsKPRTN2g9QWNRhbjvi47xc+o7HRMSK1FOsJekDA183u8xxWJ9Zgey6oP7GPQJsIexIVFSJx83s55hlgxrPfUeKupHJM4syWWt31KPbRmtPL+Rhxg9AEJgrDOTg4q9XBrt8PoBTYNR3l0gBc+ns+8/1OPORQtXjdig5YZYkwOWksVih1YcOFA/6A4B61pIOKak7LycvJ6yA1Hs6TSOPqW+G7UU71crAosGzO6nZ4e86EaM0rx/i2ZactZF+tkxFD1dIlysTePS4mWxg5pPQyxL3kvuc+gk7OtL025sJEol/c4WJ7ADdszl5S09aCXO9dzGt5kIo5T09514N1FXDGdoBsAf
 7vCtvs9K
 xFFbq5+NbdUFA3ML1pMMyBa8j6TUzUCcEoqT95nfc2GH2pmaBBtT3Ilj660ov7jNIc17quTG5zlI7h/6xt/C6krbLMUPRSED6cqaibs5bHxXd0V72RgMH2nHx0jWVpc8kgVVHg7rYeRdrFohQ0/l+01tvZxmiQnd13p5EObT8GNSdevOSQ/l4/BcP95DkBVvGHGDB9mu3sko33t3xD89jQyoOcTi6dW9YUi0JBRnZTGTepWkOof998tr/Qwjqtw95gOwe1blkkMYIK12yDp6UsxufCCaZ8FtNFRjzZAZ0CMnoMUbFeL/00t0LjShVgVE5C5zPioq/o63S8OwDy0UlJBRXpN9gbyBT6wg9sB+aQywEF+4Y+3IbjiqhZqU3XiRoNX7Yle8vR5bHNhO1uin3+Abe9hBKwvYrMQpf5UTCPaxZLQ5mVvtxa2w5XzX2e2uk4FPzOHT+sbnecS4EBYdD2gjmjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Tue, Jul 7, 2026 at 3:17=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> Hi Sang-Heon,
>
> On Tue, Jul 07, 2026 at 01:37:48AM +0900, Sang-Heon Jeon wrote:
> > memblock_reserve() can only return an error after memblock_allow_resize=
()
> > has been called. Before that it either succeeds or panics, never return=
ing
> > an error.
> >
> > Before memblock_allow_resize() is called, the return value checks of
> > memblock_reserve() are unreachable and can be removed.
>
> I'd rather keep these checks.
>
> Removing them relies on internal details of memblock_reserve() implementa=
tion
> and the existing event sequence. If the code would move around relying on
> panic in memblock_reserve() may not be correct.
>
> And the few bytes and cycles the change saves do not worth the churn.

Makes sense to me.

But most early boot callers of memblock_reserve() don't check the
return value, so I thought we already rely on its internal behavior
anyway. So the few remaining checks just looked a bit inconsistent to
me.

Would you still prefer to keep these checks? If so, I'm fine with
dropping this patch series. It's not a big deal :)

Thank you for taking the time to review this series.

> --
> Sincerely yours,
> Mike.

Best Regards,
Sang-Heon Jeon

