Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26FA310ED677
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C1C6B0092; Fri, 27 Mar 2026 09:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543426B0095; Fri, 27 Mar 2026 09:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459346B0096; Fri, 27 Mar 2026 09:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30CC66B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:17:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B68AB8CB3D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:17:00 +0000 (UTC)
X-FDA: 84591893400.23.1DB727E
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9640D4000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:16:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TXW5OPMA;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774617418; a=rsa-sha256;
	cv=pass;
	b=I4fH4s5O+52aLXYOHV+MtjqlTMzUiigvjk9slIJoNT4eBqOljdUInIczrUNWiormPXeB/x
	OUfm98k6EiJTCmbR/UN5HU6QVvC45j28xqFxR1fpeGKl0RsJHt9XPOQRJYG1d6LF1PhBf/
	x9xoKLUcM6MV/s9Hfp4ttz9m/H0knAM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774617418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53Tid1pF/DPyk0e2RXtur5yeh/pvYC68/Ct3diTtDjc=;
	b=OPp//Rnab5HzB48RbIrzwuVAdiaM0CMYpitM8vimOvFTAfE2Ela3lfBXk7bYZOTB7uXhrG
	/N/lhr+CiS9zD2nR5SdU7+0qag++NPp9Cv7vt/cfhrxmunLoiYgPr2Wf9bhTCbX7f3fyTd
	Na8sBIwWN6inS6UzC5XXc962ngpW3Io=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TXW5OPMA;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-66b51bfe5f3so585079a12.2
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:16:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774617417; cv=none;
        d=google.com; s=arc-20240605;
        b=S3T5Cui6CO+tj8gRafXq9BkhndLTLbIbxeqX247DhfvYEyhUG/hWI0HCVQZdhRyMej
         mkZkXROjB/pa7rygO2ynJc3uP1AFS93VbDqQnefvF2gsETE5YumHIOS90CTbjtfMNVuF
         AdqgtI30NZzVyNI2xDp5dapEc8qvesEO+ZbdbluUjM1lrTAMJAME3L4QzdIv+QXZx/a1
         sXlmP5uzYJrH7xh34AeiRm/+9EtBsPshYKGTI2beEMieTYRC9t3Yd0P11GON0FR03YqZ
         TREVzDtwbSgbiRjOTzQOTtvYZT0/m6Anhml1ObZuHqJK/VHI1bdUeRPQmZhk4XANn2Dk
         fxJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=53Tid1pF/DPyk0e2RXtur5yeh/pvYC68/Ct3diTtDjc=;
        fh=1+3Zj1GUegyrqNCv8OGFxQQL5AzSvDMuQK0sFhzDRl4=;
        b=RjHxfVerbDDw9CfB17KOTXnQrg7hUw6SSoRIWV0LFhjUlYOl6rdU7+ADg8KHLMIuLU
         UEG9I363iH7CKlqGaydaGPSabDgNfvD9gsNUfTgNydD+V9hvxyS9bOUGi9p1igGBHHAY
         buAUVBjxpBbaEKiUpDQyLh3TaIHf4melFUf6z/V5IyWeP7kvQVeOJ8yDNPo8W68QZQe9
         rI3mbWBBPA3bwj+Fk/Q2hhR+hwJVNPOy73kWVtida79RGc1f/H6FsHcPe/lr6FvIJJQL
         R0XuvNYl0+/1mBl7z2hcxx1pDSa8emETrUv++1i8D/JJQwYSu5hGGTVRp57Ug/6YpNCC
         1Bwg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774617417; x=1775222217; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=53Tid1pF/DPyk0e2RXtur5yeh/pvYC68/Ct3diTtDjc=;
        b=TXW5OPMAYsq0rnkIkmqk+gx98DQCSMhnLWTVGt6dDrH70QSPV92Yi86yTynH23h2xn
         iSOlZGdQwUFFkl/C0UpilJqiDpvrWTTC5mL2jENNdyXCKjjlVyRTFgXsfAlnWeBSb6g1
         3nFWowcK1IUrVuCQfg1TyZ3CJta4WEVkHD/8Tm0EOy0DvPwESbAquPMGrj2rM7IPOLzz
         MzBbIdftnC44ZTg87eTjgylR+JGiBaK3GI5REz522ukf1R5H1QoROUQG/U7BnA2dcpKZ
         Ljpl0zLMfsaamD/SdlvL2Vx+vEp+JxH6tKYbIp2AFUFtUWzQ3t6xHTZjnJrE+Pfayauy
         3ldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774617417; x=1775222217;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=53Tid1pF/DPyk0e2RXtur5yeh/pvYC68/Ct3diTtDjc=;
        b=k1YguIJOxPrrrAOyqLqSIQjrxY0t3ykcpx2D497HaDTS9hLuQl9pqvs0wzWIgdOb2f
         LcA560q0hyB2Qz1JAxA64J5P2iQnwFpvjltyiMqIrafXVusG/YwgS9GMQzM0Ua16unbt
         3cZBeLgr1qRO0o2wJao+OgsPGJCUBj1t3RtrXhsx6E0AMmoED8ZlD/r+uoFkTMYatxLl
         tuvk+QKM3N2gIo9CvHtydC3MFl/boL85qWIcptRAxMD5bo3DXWhV8kLXhE9NMF2tIoTK
         zYmSTfKR4eVaGmgNu7GudBDTsGojRw6EbIUuGl1qlEfoWHhcO+YcsU/o5MwavHgZhXbJ
         bj3g==
X-Forwarded-Encrypted: i=1; AJvYcCXYja6XtlsffqPvVx6aSmjjA+uebqBc5rjYIuHG1WOqU6SLsrCkLpz+DDJyWgiokTXKGbgWZHeYnw==@kvack.org
X-Gm-Message-State: AOJu0YyYRmPffochGELYEH0gppQXloJsFhOjvLEUmnkqIj03DaVoPL8T
	gbqMaYoPxGGfwJG1xpwZiQz2tX+EDm7Q6sZXwNKLd09hRdyk2xFyW/b44LTqmAzJ/1MPElhzRuq
	tDRWnZQu2lIh4jGKaBXTttNng5tGAhWuUmI30jTB4Gg==
X-Gm-Gg: ATEYQzwHoyEMiihYZ8+bHIUjd0PstXV+QDF0Vu9CsOIt1JtZcLDPkW5qpozcUFt89Bg
	e7r1JqMWni6WwouOcP4/RGZeHi88ksDIeZQdSsJNkY+3LJl4hx9rvTUiTSZ8fDHANRczbktT3f/
	znC28qRNxEv4vrXOKGa+DMM5ZhFKrQqtMg8DqLtyg2MHKvwIzeFF2vX17zVIIvkXsEP6DvmfZXV
	pBblQYJTRlag1L4s1wmzHh/PsjIDdUdTQj7NR/ZgqLkO08LJFPGjJyV5Jl5MSlQBKx1JrKLlrZe
	3UFDREQRCzc/D7BkFR9pgB9cMpxHeTPboRZNDg==
X-Received: by 2002:aa7:d391:0:b0:66b:3cb7:f63a with SMTP id
 4fb4d7f45d1cf-66b3cb7fbe8mr817711a12.19.1774617416048; Fri, 27 Mar 2026
 06:16:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260327033335.696621-1-pasha.tatashin@soleen.com> <20260327033335.696621-2-pasha.tatashin@soleen.com>
In-Reply-To: <20260327033335.696621-2-pasha.tatashin@soleen.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 27 Mar 2026 09:16:19 -0400
X-Gm-Features: AQROBzAzTw5vrOfwLpddYaTbidyVZvBLrp2FunFo3w8jJEA4WmWslajSm4DGuBQ
Message-ID: <CA+CK2bDJJ2exSz4i3by3QLX1xvLAyqG5L+UipraiQw3Ytmx2=w@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] liveupdate: Safely print untrusted strings
To: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com, dmatlack@google.com, 
	pratyush@kernel.org, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9640D4000A
X-Stat-Signature: jmee1guwazxa817nx1yzzsjxfkremhn7
X-HE-Tag: 1774617418-780401
X-HE-Meta: U2FsdGVkX18lzOvWtoJdsTQ4fU+uo/2w5peNSdmhnrN/Y4GOWvl7M4tjiB9NXea7sSqAV+OD+w7FTvkXcutSmQ0UP5TauTDnJRnVhcQWQeozYi+TQsQo5Bj2axzadYI6wUPIgHCet1s0IN0i1UN5/GYYJ7yJSK9k+PommCoTR+K54y3tjLWrbP9Yv0pcDn9HHLEaipPeabqiT7hl+RY8Shl0cuyzitljegJnkxXewLrfjkSLR2uHwJNiqmAWDeFaAia9hDDFmO9oC5jURQEu2oR/IY+59fhm0fIXe3va4BH+gjSpk4HcrqErm0cua1SHbQphx0LdCRyLXgwRXlmmyBr2014TZhTwxzpMKjRYcdEe4CBkwUUjw6+zkqa5n3PiQC9e6BacmEHaOnubxi+OL27sKoNz/c5WpNpPr6E6Oj0ps42QwL8uYlC27OB6CLA1nk3YtJfBP35xDAtdJi32Rd3dgP8ATOOnJ3Xp2AXZh7n/CmhclzaBdUq6Sf0p8vmijw8nCAItji2PDH0CxHjBGM4r26jMQH+FCVgfpYaw5wRsocvytOPVJCV5RjAC6AR+UFQURMWbpqT+KBG4JN1WOJ9z0bmQ+WK2DQlQT+/zZg6YQ+EJBY7Qk7wu7uUmsRf/7otAsUKM/iV98PbN1TAiuauqYL4KIv8a4g7wevjzX4F6vuTE/BuW/AzeIKbmnTlU7XYlNXKzdQxhs9+GrSs53VflX9UbS60BN8yHphYQMZfUFzuME/6eOiq42s5EfE/kQ6hj75ji3UJrDXwA7sKi7zrppXF3L+1dqC2xhzP5dOGHq3g49H+SWxnIhOe1vVntDvvXEfL0U9LOd2/+3Tst9Uh0zk5xRKcxn1uwTHmj51YKEDkukCA5RF1Q9EqB1M36q6HOxwW2qWp6eWOJNiNOAFxJxVOqIxovwWIuUF1AFcrMEkm/iR+YXwKY4jfJ2+yD/bYMz4xWADOaa30oyjV
 8wu+56jq
 G6Y2s9Bf0nFgrthC89gwHohjmTq8BvGktU8w/UfHc6Dezykeq7dXlSSIFkGpsJVrTmjyy1chzZHVwRRxp8jTbBxf9RI5m7oe2VebCRp3dHqPGEKwhHey4jjPhxWFO0/eR3B/IvX4rBMGZKUQDNXD3TdhTRl+IOR2X1sgvJELIxFBd+TXFwqS4JdmqmjiTcpGjqs838psmQAw/k8tiO2x3buybrSjkuQHEggHRYYEXsQJd1pYRhwJJDf4Ut9SR8zeKBZIE5HXB7/QPARNDWqEsCx7kKEx+6qJb1ivUwXrEfJfjb2p0evhapALdb1qFsFERfEpRh5g4d/bu96nVc0M5fljobYt4EFQa6usKVWvNalRBwqlnnfIATWEA8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 11:33=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> Deserialized strings from KHO data (such as file handler compatible
> strings and session names) are provided by the previous kernel and
> might not be null-terminated if the data is corrupted or maliciously
> crafted.
>
> When printing these strings in error messages, use the %.*s format
> specifier with the maximum buffer size to prevent out-of-bounds reads
> into adjacent kernel memory.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_file.c    | 3 ++-
>  kernel/liveupdate/luo_session.c | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 5acee4174bf0..a6d98fc75d25 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -785,7 +785,8 @@ int luo_file_deserialize(struct luo_file_set *file_se=
t,
>                 }
>
>                 if (!handler_found) {
> -                       pr_warn("No registered handler for compatible '%s=
'\n",
> +                       pr_warn("No registered handler for compatible '%.=
*s'\n",
> +                               (int)sizeof(file_ser[i].compatible),
>                                 file_ser[i].compatible);
>                         return -ENOENT;
>                 }
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_sess=
ion.c
> index 25ae704d7787..8c76dece679b 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -544,7 +544,8 @@ int luo_session_deserialize(void)
>
>                 session =3D luo_session_alloc(sh->ser[i].name);
>                 if (IS_ERR(session)) {
> -                       pr_warn("Failed to allocate session [%s] during d=
eserialization %pe\n",
> +                       pr_warn("Failed to allocate session [%.*s] during=
 deserialization %pe\n",
> +                               (int)sizeof(sh->ser[i].name),
>                                 sh->ser[i].name, session);
>                         return PTR_ERR(session);
>                 }

Lol, Sashiko went a little overboard and gave this patch two
"Critical" findings:

1. If a registered file handler uses a compatible string equal to or longer=
 than
the buffer, and the untrusted string matches it without a null terminator,
strcmp() could read past the bounds of file_ser[i].compatible.

B.S.: The length of the string is ABI, and fh->compatible is a
NULL-terminated string provided by the current kernel. In the future,
we can replace strcmp() with strncmp(), but it is not a high-priority
issue.

2. By returning PTR_ERR(session) directly without updating the static err
variable, subsequent calls will see is_deserialized as true and return 0.

This is regarding luo_session_deserialize(), that is the intended
behavior. We attempt deserialization exactly once, and if it fails,
some resources stay "leaked" and inaccessible to the user until the
next reboot. This is the safest approach to avoid data leaks.


> --
> 2.43.0
>

