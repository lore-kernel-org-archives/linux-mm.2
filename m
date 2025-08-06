Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1ADC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1CE6B009C; Wed,  6 Aug 2025 11:46:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C97E6B00A3; Wed,  6 Aug 2025 11:46:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B80C6B00A7; Wed,  6 Aug 2025 11:46:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 055A96B009C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:46:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0D0F1606BD
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:46:06 +0000 (UTC)
X-FDA: 83746758732.10.513EDB4
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id E8CDE40005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:46:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VBGnYCpZ;
	spf=pass (imf17.hostedemail.com: domain of pranav.tyagi03@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=pranav.tyagi03@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754495165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zmrMmlSKNc8Wry1y8dWX27pKFPjQrw0O9VLnGzkRYw=;
	b=0HDWf1kPIgJotDuYeKJCufYZBJNGJdTclSzXi+/bbxD8OkdCnOOh15wUxkkG1eQNu40Pii
	QHryfK7/U4Iwrr5YNE3qDlFrFQj+qwST7AsYcptiRpEGYR/Cpo8zM4weeFKcBivKfxmXkJ
	uc8ZdwX67gDAF1XnszQ7tJDwvUA8L+o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VBGnYCpZ;
	spf=pass (imf17.hostedemail.com: domain of pranav.tyagi03@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=pranav.tyagi03@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754495165; a=rsa-sha256;
	cv=none;
	b=MV4f88jO4xQTxZmi1Hd+mvpRELiQmthnRWTy7Rhq+ybyu7+3O6WA1aEUj8Kxn206JvTehQ
	ztHYhXttImT0lZwscYEDQtZIadeX1ip61RCKbDuj7JLmyBzdV2gQSlKT0O85e9f3iyVdeS
	Ad+Ftb+jG6XaOVTm9cODiHElX0OZ/nQ=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55b87e13a85so1616e87.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 08:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754495163; x=1755099963; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5zmrMmlSKNc8Wry1y8dWX27pKFPjQrw0O9VLnGzkRYw=;
        b=VBGnYCpZBsCdug4fEe9i5b4JCOUGamX4go9XNFrmW+QlFS9wdLkoNvNePW/azX8Rbj
         QzXpQrJPa9iJ1/H+tFlDHXg1i8rcoUboseXq3UUvmX624uNW83s3CSDCbvzV/jTd7Ckb
         FR71R+WpX1sh5wbXA/V0vslxr30N7ylpOYChk4eQBAh9JCmKbTiAOXbuMYdy0mavh5+B
         +bTFspSmt16bkvbaaljnTj2tKN17SzptFh5qXe+woMC2/plvX/gKjOoAOQayt1IOZM5+
         wzEZSt7ys4mt2XWIRQEYMAb1VaY5P1S+yzhQm+b31Lyv6s5yGQDehB+sN7sIDHn7bhDV
         BeGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754495163; x=1755099963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5zmrMmlSKNc8Wry1y8dWX27pKFPjQrw0O9VLnGzkRYw=;
        b=VDhX4st2LvUx1NCzBSMUwvZQsM54X8mAWX+GFEYqUXzpRT3r9uXREwTxAAMu5d80Rn
         wVZ5VKyAGrXMg+/V7A9dtwOv+L4Th4xVHMAzrEGBHxt3MbQ8D1G5Gx9rCnSvz4krKdax
         qPcdY0joTy7Z+VUqZBT3OIGAev7Nduw7OIvwvcxBPVXJzLRBpXRm8+z7Jnocb2/6nTSO
         lOQoJao3u4P5QZPVslaCrOp7DiAeJ8mmGfwThfqg6R/EEcGORyFvLvO5bXtz/nqMPmUQ
         lOzHfjWiG/pS2EfpgKgWGI9qAx87zmmWAIRT4tVAzSdkxnN2kY0fjW4CnEuqWA6ccZDr
         JQ6w==
X-Forwarded-Encrypted: i=1; AJvYcCXy7Pdz2O8Yrco6ZN3Fi7SWWhMKdWSoasZKqnh5Nd+ush13GPTJTGlESNfc4RWQPbWeBeRRm2IQbw==@kvack.org
X-Gm-Message-State: AOJu0Yxu6QY5VK5UKktGPFpeIzmeGs/dAtqM2SxaLKIU+nAqgsr0La3K
	bJZsh/BlLt/QcAdwq+cg16bWgK4vdN6SfCsx0N0bRDrsp28craSUrEvUj5s/G4+bFR060TaopOh
	izJzzUWIXaRPZCbKle53dggHuWNxlUzk=
X-Gm-Gg: ASbGncu94O8hxHwa0wIjXWmy0oFWoRrhCuQtCeEpuCPjGgkcj4WndQ4Jtxuld9Hdjt2
	8FWMhiksNSrPPtscN/8FOyVobvEBfs3TGmv+deCQOm/V56YjMR5HUFG4jdVBmaAj6oVfEyAPTa/
	JMK9fLu/nTvO6tApvs7SQhc5yTtGMHOPTAh6JMxZgzg8JVYKtTyESwHdF8xsvhQ7OzLqm8Dsg/t
	O+QK+yce2zxVC+p0oirKD3UcZ8uExnW9BSmYzhrDA==
X-Google-Smtp-Source: AGHT+IGXosmjvzExQ3C4RK78Mcex7Mn1Uk/h0JUj5QUxdn/C6gvDfKT6OI5wS9vLx2H97RSvkUJIJkgfNFNXTPXKb0g=
X-Received: by 2002:a05:6512:118a:b0:55b:82b8:c2f3 with SMTP id
 2adb3069b0e04-55caf5f82b4mr1212425e87.43.1754495162686; Wed, 06 Aug 2025
 08:46:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250730142301.6754-1-pranav.tyagi03@gmail.com>
In-Reply-To: <20250730142301.6754-1-pranav.tyagi03@gmail.com>
From: Pranav Tyagi <pranav.tyagi03@gmail.com>
Date: Wed, 6 Aug 2025 21:15:50 +0530
X-Gm-Features: Ac12FXyNkNIXJt8LjQHrVLUgBnSRkW0iOHvQddA77ExTJZswxw6Wx4O4SJ98_zE
Message-ID: <CAH4c4jJ8VywRUfn2z8HnA73vNxviZ53DZttcR3JaPULF3JFkQA@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: use __auto_type in swap() macro
To: akpm@linux-foundation.org, peterx@redhat.com, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E8CDE40005
X-Rspamd-Server: rspam06
X-Stat-Signature: dynj45jmckuntd3suiwtm69weywkrkr1
X-HE-Tag: 1754495164-37125
X-HE-Meta: U2FsdGVkX183sVGoyg4wRvkDvE7KOseq8Fwww4klCNhevHDmwo5NZW1O5Ayrt9VtdkBDi1Qt2OtTTcjppRcYcB91GhOCT5eyPEFWss9rMTDJMrYKHsWnXvRBkvrs9yGWUZkIbCwWp8XVOZPA3e0YE8VY0p2gi65oQMJw8KGMfyFGpeKnnDlUiyb3qP1A9hUYoCbbHQV1SZfCCos7yd6HEEIOrn84+2TNvEkRz4GqB0M/7LxbVEN07VdaRzYzwwL91nC+vrbx5UHVKcD3bt+Hb1uD2Q5oSKE5AYDVPNLVuxXDaGSy9BhQN7lM9E2RWNW3rEc5DHMv/Nwgmf63Bcfvbsy0bJhUfgMZ9ZwyEXqS4LAtuiEyYWmfTVsU/9k3wVOhDIOmC3VDZJrWQuuJ1Ydc1snjBKaZIU4RpHB7CKcVdNpX3S1onuiMRB/ED2fVSldsyANrNIBp56Pwuo9T5SQLFh6hdVzQyGmrnqpcl1fzIUA7ApgIuXjOhIXASDmS0sywPOGvEe2L2TdQFugqX2/EWsuG3X5wzwgt5l1EWGgAhazOy+SalLJSv2vPJx2xq9d8kANaKkxrThjIDxcx7xlCLzm+dz+zTXqEjDnDzURYgE9nwdhs7gYT1HSPYaMB3FQGAHxKQFd9EJ83ZiaMzOi6CK1iB4ldCk/GyYr4FeiXZUeLSUWAbD7A4sc6OoFjklFOGcXdTIqEhb67fMhWpB2yABDrCD/76l7ejvGnQOnYEMU0IcUBLWtsSARP74Tvd9LZlCUOlONUMl4QUuqHhTAU9l4amy+Hh2ThdMvNDto0RgDtqiu3aojYjyG00Y2qo9OlWMfwtOkOPiG7NsLxCft9c5FfA5D/WQ22/mbNn61kB8pj0cpIS0wwIhzznp9okvVIlyTWlvfHwiVOyhV7KHfmMVyLkdL/xVXBC9QiB3Tx8w81YO47h//YBah+BV5ZihQkE9bAzxKdCQv1TGwViP8
 NCeynOF4
 WKbutRbbE+6c/G6+2Rzt++/7Vg+xdL6Eddx707GNsJg1WXTIh3kkw3LdGksabsVkI6/6bMm0+slGsY070anISVBqwosoSGedL2lvj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 7:53=E2=80=AFPM Pranav Tyagi <pranav.tyagi03@gmail.=
com> wrote:
>
> Replace typeof() with __auto_type in the swap() macro in uffd-stress.c.
> __auto_type was introduced in GCC 4.9 and reduces the compile time for
> all compilers. No functional changes intended.
>
> Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> ---
>  tools/testing/selftests/mm/uffd-stress.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/sel=
ftests/mm/uffd-stress.c
> index 40af7f67c407..c0f64df5085c 100644
> --- a/tools/testing/selftests/mm/uffd-stress.c
> +++ b/tools/testing/selftests/mm/uffd-stress.c
> @@ -51,7 +51,7 @@ static char *zeropage;
>  pthread_attr_t attr;
>
>  #define swap(a, b) \
> -       do { typeof(a) __tmp =3D (a); (a) =3D (b); (b) =3D __tmp; } while=
 (0)
> +       do { __auto_type __tmp =3D (a); (a) =3D (b); (b) =3D __tmp; } whi=
le (0)
>
>  const char *examples =3D
>         "# Run anonymous memory test on 100MiB region with 99999 bounces:=
\n"
> --
> 2.49.0
>

Hi,

Just a gentle follow-up on this cleanup patch. From what I could find,
this is the only use of
typeof() left in the mm selftests, so this should be the only instance
needing this change.

Thanks for considering!

Regards
Pranav Tyagi

