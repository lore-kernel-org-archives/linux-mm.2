Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40588CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 17:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4EAA6B0088; Sat, 17 Oct 2026 13:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF5D6B008A; Sat, 17 Oct 2026 13:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEE2C6B008C; Sat, 17 Oct 2026 13:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 988986B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 13:05:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7905A79C0
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 17:05:53 +0000 (UTC)
X-FDA: 85332745386.05.F89DAD5
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id D582F40007
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 17:05:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lOyP7KKe;
	spf=pass (imf01.hostedemail.com: domain of malhyuk97@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=malhyuk97@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792256751;
	b=lKulmrugUKDmUK/JR32csrfFXBSkknF9sNsppm46hzMH/6GGUYhVTpPbYOBT2nNyjX93xZ
	LUy7MvfefiFEhjMYrzttItsn4BZrJFP8Zg6D9FAz8yhfJpGwVNmqaHsqn+vmP8Mmt4MzSY
	D1RUlOMacEhu4a3Vs+qmdLJeN57nFbs=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lOyP7KKe;
	spf=pass (imf01.hostedemail.com: domain of malhyuk97@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=malhyuk97@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792256751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6ml+o51cH6opK/vvrKWQJpNc25eOwq4x/N767rSwqTA=;
	b=6nt7WiYHt6SSHFRH3uWUCprL/KQbJTrVn0MH/xhBV+LuCgW1nYo2oOSQUFL/1h+f299h6V
	9rsvkovni38sRXQiSbuyefFSDVJ+ynJWHZ6qZ19wnpPau3e2GhwgF0mM4twWVpdE7aoKfk
	zEmzcaFmtBbDON8PJAUCtAtryM3XbFQ=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6acb57c2b88so960953a12.2
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:05:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792256750; cv=none;
        d=google.com; s=arc-20260327;
        b=j/2pIj9Qa7hUdDlEEDzS1lqS3P0I4WNdlR6pChU6CKZdMOqlKYbMh4dOJCPvMvsllf
         O2jFen8ux/Gr2GV6gujK4klhLjhWrgP35adLyeRMke9x30VPSoY1Q9bQapBlmnNXE1bR
         HmW0FwrayOenjcp43phC8CKoVLfrBR9Yexv+9c076AH+4JfT2e6s33UQdyAvs7FCoLwM
         PBcZstB4k6RBTGgNYHADz9PHB6jm68hiUIC/lCvaxta9TxRlZcJ4P14qSvnZNlL2kZAx
         Irqf/ES1EKLIhu1Hl7H/VTQlwiNXSNcNuAYgkMbKSEQPb0Lu0AZocT7GIscfi7ObRyh4
         ZM7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=6ml+o51cH6opK/vvrKWQJpNc25eOwq4x/N767rSwqTA=;
        fh=ZAzzuG0cujAgc4TGuMcneLa4k+YRIqY1P+LV63KOYyk=;
        b=HEMwoIQ8Bb7zPEK+TnuwDOX0JXRNIEEeSWXtBX08I/7uw2qzrl+upldXs1p6U+fBRs
         cMWIpYGCJSw9S2si2nc1t8zz6WMWsNcm43cYIVa/goDS7gj88oOKjue+93v7O7b+Il1O
         LpmESgt6fNCir+WfhPzxlmSquW2vXfjcmBOFYSTrVsDlQuRPfr64/CdKZ6GKdApdCNsO
         gU7Rc+LJcnn7b2O5u0yuK5uEbfXcz6QyS25tzl8ZU03WpdjzMAJfV68kpVGkK8/NY7fm
         julj2Yxk2wwZBJoTp4OyZ1u6NDu/A8W1jg3W87aQqhI5b8irT6hrT+2YRgnfpNY720dF
         H16A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792256750; x=1792861550; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6ml+o51cH6opK/vvrKWQJpNc25eOwq4x/N767rSwqTA=;
        b=lOyP7KKegXqu0F6Ai5b2osQ1IxRnR2SCyOhswQ655axMoDqHJvioZxkv+uPSPZJ/up
         j2o+SCfpqRf/8UUPT3EV/bK5suv3Y5Z85sLA4nXYi7f1HAsHsfoWYJAfckIRTk/FJUKS
         sskeHUXr+UmcaGalfjzq43BWcnz2hLnsowtWN7AeaHM4IQQBuzlmdDyn4baQ/1WbU5Ww
         3rwfxjV9prqhMIyJqAtL09eYZh8KP8oJJlXqmuyNFLGuSbqQ7ElqLRNXNvVl8QKQwuCg
         WxJSf4c+6RYu2B1s4wvXdgOTbFKd4L5YO/oOj+jhbARUK4sZXSbYykz5aJVIkVdDuHk1
         /m3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792256750; x=1792861550;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6ml+o51cH6opK/vvrKWQJpNc25eOwq4x/N767rSwqTA=;
        b=au+gIFknCqbr3ZIWG23EaFXFpMeDvgGp980hSXI/k9afVeYVnlxDFCdv/Jwf7P+UV8
         wKIeRf4bch8iPauNR6YfeeoIKTYro2PlkWMHE/C08+7CJfGXg0T+uic3j0g1iZ/M96WJ
         g4jOdJ+yQJEv5XUQlFmvEkhisaupnc2QQPXCGcmksp7BgND1wdHI7yngL9I2gsyxDviT
         G3kAf9aj1ZGMmcgJOTmSRo72qjHUfnIJc12RaZkk5/q0xBF1vzd9YToSg1N3Itm8iNrB
         63iNeOI6dvtSJV4IfmVdDaV1WbqEOcKrX0heXzLq9EhNzGavQaFgm43hLFhgT5THJpN1
         a9Sg==
X-Forwarded-Encrypted: i=1; AKwUvBxtoTtoBeT0Q6TWOsHAMZ6T1EZagX4OJzZZ9KTTKeCcGyWHrLfQwaIrcVpWua/dB16ZBisU791Xnw==@kvack.org
X-Gm-Message-State: AFq9FYKn2i2FZHR6XY5JqcI97QTOMcO9tkY3W5QjH/zALjx67QRvYChB
	SaK8bs6pHN3UkqvAKfxBrPJKp2Xw2XxzHBQSS2MmMdyxNfLp8rM4mxmoN0uVq5WpQB6W5Ht4GFJ
	bGC6M4UT/8wAgeLQTLMnD74u9wmmGqQ==
X-Gm-Gg: AYBFou04+dWVXZqFzd/yxuQz6a+Av+RdSLtYSRHEXPRp8Lpccjp3g8Ceot9JAiKb+dY
	U2Jto/7DuLv0zssZdcvobfwTTv62rnHWQHNwuNrjjattTYS27GQDgVmrNGbi50CN3MyGK9Q8iz6
	NnZ6B/BIc9WZ2rpynGiOAv95BPIBMhQR8m81MlBUuJsCwvGElOc10ymPImFGV7AynW3PD1w67Rn
	/o9yu4M9D8QhHyBdqmITEKEsDRRR6InjQ1eJRe4FtVv0/M7rA+AmHurORWToOclFhJRhMliGNUG
	yB8y+HnDLiWUDrdp2s9kMd65RiGRvbC7Wi9A4ob0fqnSUTGWonqXAPTcitYQweaqzvK/Xp/EZX5
	jgUMqCWdS9DReiulN5Mk65u1k4BVPbg4o0SMw9A==
X-Received: by 2002:a05:6402:20ce:10b0:6af:859a:f306 with SMTP id
 4fb4d7f45d1cf-6b3a8209426mr1223690a12.36.1792256750056; Sat, 17 Oct 2026
 10:05:50 -0700 (PDT)
Received: from 101988054943 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 17 Oct 2026 12:05:49 -0500
Received: from 101988054943 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 17 Oct 2026 12:05:49 -0500
MIME-Version: 1.0
From: =?UTF-8?B?6rmA7KKF7ZiB?= <malhyuk97@gmail.com>
Date: Sat, 17 Oct 2026 12:05:49 -0500
X-Gm-Features: AclHuK-rwvWEBU2Oy0sAwmLPG3_SsOPthSp3XpSWU2-zCzp7r9iU8kFg4HiECtc
Message-ID: <CADQRuqv1akf67+qe+DHbfEM-nPtEjLNzz8BWBRtBVZ8VVqKubA@mail.gmail.com>
Subject: Re: [BUG] mm/huge_memory: lazyfree THP PMD restore races zap_pmd_range
To: xueyuan.chen21@gmail.com
Cc: akpm@linux-foundation.org, david@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000eef9f9065e0c4a41"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D582F40007
X-Stat-Signature: wkrsnj58t6uqtiqgbhnrar1dwi8xychw
X-Rspam-User: 
X-HE-Tag: 1792256751-689524
X-HE-Meta: U2FsdGVkX19hpEJrqemBplqt05F5qRcbKiNu7e61UbbKSsFEetBIjoCb351E1MovrbLNWgFll+TWp6XpFbamoHjK2J+qUtFlmkmt4f9Foyo5f5Q1C4l6Za5I5ndaRWCcOLPJHpkC6RFJ1sbgDSHex/uZiY/EXFNG35ax064skpojjto4V7Y0z4MyFTw8X4cydCPlHaDvKVVCnv2LFFkAxhM5CxnELHERNu3m8tu+wRdPG0yhRAa7ISkz2Fkz8PulEnh8XWtaE/kQOJPF4L1bWXf5AhApJ6hAiu28IJiu9SZd1jIUMHNhdwcN/n5WzjH4eDqj4qio4tGNbe9koQ/CRJkWkrZp20pEby8LxwXKqF9DWaULK4bKNUVp+v8wCQN/lqOgmocIuXgFM3EpsuzetZjjyu8WOfTlC3geMEwLXjDn2KdqMLOT7hdtCfCRfkZcdgDAkzLx+yP8vGFazqpFqe+w+q3TY5B6qXC9E6Q9mYseK2bbTx6AQtfphHIHMid6ikjILtrp3bG6Xsu/W2spz5F9863wFkyQMSb3Bq66+cGtN1oqYW0oHeeMmlv9EX9ptAzlmwta+ra5eC6hz2UISbFRJfZkupQC4jMuiq6GuuEbDGsBZz1ntMPAdqnv7QR/ncFQXclpNcsStVukfF6wbQxMqiBOUrlii3sRy1k+EJxzkMi5IS5A70YFrZbOgPilbA2pao0xg46kYlAhtwLUyfi22ldwmnWrJW4xR7lgPIzZeH5Jr4yvBc7Rt1etJGIU2MUt9gBO6wP91lgtYceX9LXwGMTcQAjRW4iF8kVwBJe0NK6Achr4lQ880YPuhSV7Oo0taTsk376eoK6d7WcHwQM3CnSsNYHvp5ZTZED2ke9uQFP982MPDJX/o2Mw6+Xfo97DZtat+Dkn3jV8Lcc/9v9Xq8BTAsyuAe78Xng1TQlAXteVXYxEVowOMIs3Xzay99B8vi2tqLeu9tVGeTi
 9kXaRxYr
 IkEA//fGG9np/nN3jYaN6mVOB3RNmlvVmr5+0I5fWQnBIfiORYG1GNJ39ewc8cA/DDkcgzDVt+DZLt58IHJt/VnGh+frBGO89JG9LdzgCdoAmiUy8La3zzUkRC8tWZGqixxSm2XUcfkycRf+3T626NP+ItMJgct1pN2Z9RCBhLh7s1YW/F5FtgernMiLGI2DaoNBcsABhWg9OQBmIxgwiX0qDTHUV2dHWRPbEqpLFrOxYQqNTG4inJlOOYozzc54bSIFecwqdzq4QDJAwyRkkt3XFKL2yNEo5s6+RGKnu/rtsoBYxShWkwzVovGm3ChPIHKgowXzQKe/WRkALEPgB5u7dnUOXaNTdwPjnRc3fDI6as/tztkDHdo1q+XdQv01SSYP0gju0/hkJH1qnXW6vre3sg8akX5353fP2olr7T9XaHns0ftjT60l/a+dXnLJGRFA6983WpXVOuK4HIolhSPr3n82lFNxY7pVUf8Onbf8feK3qKY5Qz7VSdk20LZnpB/ZRjKWZc1HBQOGTWotiLObUP6Eeyr2lBt8oiCCLhgfpKHO2rayRgzN2gVSysKjUaTJr4XQ6VsvnXpWt4ohDEjREo3LmNpocXFJmIuxfQRZ3HHFfGGredeJ3y+1ztFeCBbelgwY9uxVHT2MnxHV1sKumTzgMFNUGD9X9iLArMJSPXDdRWGP6r8ZqB4pFc9mBUykN0ev7Kebz7eRdn8hOYt5CiSlFLtNNIIIqmzDt0KLm2bAyPfGlnxZGyEMNhbWJZSS1wU6YCEmKii2MJXYOj0oLZDvVtGLt0WBY+Dul1FujUE5cxWuPIGGOqHvw/8Z7GR6T56eiMjjzrvxUFHNvQ3eOmiIsksUOBJUbkm5ylkQuDoz5uhKB5mJ6/9BmM5G3WcvA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000eef9f9065e0c4a41
Content-Type: text/plain; charset="UTF-8"

On Sat, Oct 17, 2026, Xueyuan wrote:
> This bug should be fixed by:
>
>
https://www.google.com/url?q=https://lore.kernel.org/linux-mm/20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com/&source=gmail&ust=1792343148969000&sa=E
>
> It is already in mm-unstable. Your reproducer would be a good test for it.

Thanks, that looks like the same race, and I should have checked
mm-unstable before writing rather than only the released trees. Sorry
for the duplicate.

I would be glad to test it. The reproducer runs unprivileged and gives
the KASAN report in 30 s to 5 min on a 6.12.112 KASAN build, 6 of 7
five-minute boots, so a before and after on the same guest should be a
reasonably clear signal, and I can leave it running longer than that if
you want more confidence in the negative.

https://www.google.com/url?q=http://lore.kernel.org&source=gmail&ust=1792343148969000&sa=E
is refusing my requests from this network, so I cannot
pull the patch from the archive. Could you point me at a tree and
branch to fetch it from, or send it inline? Either is fine. I will
report back with the two runs.

Thanks,
Jonghyuk

--000000000000eef9f9065e0c4a41
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<html><body><div dir=3D"auto">On Sat, Oct 17, 2026, Xueyuan wrote:<br>&gt; =
This bug should be fixed by:<br>&gt;<br>&gt; <a href=3D"https://www.google.=
com/url?q=3Dhttps://lore.kernel.org/linux-mm/20261012-lazyfree-stable-fix-v=
2-1-6387d6e30063@nvidia.com/&amp;source=3Dgmail&amp;ust=3D1792343148969000&=
amp;sa=3DE">https://www.google.com/url?q=3Dhttps://lore.kernel.org/linux-mm=
/20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com/&amp;source=3Dgm=
ail&amp;ust=3D1792343148969000&amp;sa=3DE</a><br>&gt;<br>&gt; It is already=
 in mm-unstable. Your reproducer would be a good test for it.<br><br>Thanks=
, that looks like the same race, and I should have checked<br>mm-unstable b=
efore writing rather than only the released trees.  Sorry<br>for the duplic=
ate.<br><br>I would be glad to test it.  The reproducer runs unprivileged a=
nd gives<br>the KASAN report in 30 s to 5 min on a 6.12.112 KASAN build, 6 =
of 7<br>five-minute boots, so a before and after on the same guest should b=
e a<br>reasonably clear signal, and I can leave it running longer than that=
 if<br>you want more confidence in the negative.<br><br><a href=3D"https://=
www.google.com/url?q=3Dhttp://lore.kernel.org&amp;source=3Dgmail&amp;ust=3D=
1792343148969000&amp;sa=3DE">https://www.google.com/url?q=3Dhttp://lore.ker=
nel.org&amp;source=3Dgmail&amp;ust=3D1792343148969000&amp;sa=3DE</a> is ref=
using my requests from this network, so I cannot<br>pull the patch from the=
 archive.  Could you point me at a tree and<br>branch to fetch it from, or =
send it inline?  Either is fine.  I will<br>report back with the two runs.<=
br><br>Thanks,<br>Jonghyuk<br></div></body></html>

--000000000000eef9f9065e0c4a41--

