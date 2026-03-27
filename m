Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1627010BA451
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7449A6B009B; Fri, 27 Mar 2026 04:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5AC6B009D; Fri, 27 Mar 2026 04:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BB16B009E; Fri, 27 Mar 2026 04:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFD36B009B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:59:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E855D13C53C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:59:52 +0000 (UTC)
X-FDA: 84591245424.18.679E69F
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 96B59180002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:59:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N2j9MZIP;
	spf=pass (imf24.hostedemail.com: domain of tahernady45@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=tahernady45@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774601990;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HmEX+ORL027fNKz2U61dhZCueuAkQztEsTnb9+25t44=;
	b=DJPd4H/vc189q/cGInB15lhTHbmwO8ByWyjpa1X1o6+2ekhT9yOJ4dKRnU1PSwWPnqYQFY
	XewJPH3zlsaMqyvrFKKYS4gkzyEbSQRyu0lie1R80pMhDR2tY04xUx+I4Uhd6XNg1zLNy4
	RgcmX7JUatkZvuw/jG3KzrA+R1IhjX0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N2j9MZIP;
	spf=pass (imf24.hostedemail.com: domain of tahernady45@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=tahernady45@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774601990; a=rsa-sha256;
	cv=pass;
	b=pnvQDefnetgbGnIV1z+XUfpGefPGCvqtXQ0QXFjye8fW0DiO1VQLX76FAa7KCpnywcOps3
	3YwTV4m9ToUn1sHadGyRWPdw5Q1y/7ecNDWLogJzdckSf4C4shLDvb0m1O38qA5gJucEAJ
	ujK6KgaQyXDMtcY9kA5ZgLXHJvfdgnc=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43b98652f05so772894f8f.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:59:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774601989; cv=none;
        d=google.com; s=arc-20240605;
        b=ZM1vrfvOOzTmqXMR0OYTUnxhal+DKyfnWgZO5xDVbCFDhmVwZjfjyefvzqgzxm6bs1
         35hA+1Mga9FMtQ2Z6yVG1O2JjIB9cPZU1zIxPIYqoYkExP8iwCQThNbl33QdOSEFnEq7
         20kGaq/Tm+PbO52gkwQ+ntZbiYS7wim1vAF1zMlSMsdPYKTMr4mQEY//ca12zxEQvJlK
         MFlIErPrZ0ZVdTGcM+M7JfmoG+WmxVyVA39XHoYEdfmPH1zRh2TlL45Ky7u/xGh7Mrb6
         GYzZFZjT11urV91yfLNl+AQb3pU6nfhu9YQFexL2D5jxNNk5ZdK4HRNGwwrQejTM8h4Y
         vo8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:auto-submitted:mime-version
         :references:in-reply-to:reply-to:from:dkim-signature;
        bh=HmEX+ORL027fNKz2U61dhZCueuAkQztEsTnb9+25t44=;
        fh=GMB2SmBPTLJpRegfVGR5iTx/GcMOV9J/v4AFZkCGJ04=;
        b=RdvhtQ/0T6M71JbuztzUjaK5AzKGlJVcPSgId0HFrPp7VAgo9JSfYPlMa6mff6nc4z
         k8VI1eM8D/zhpIN9ds0dap1HYUPNVEAvhHcX62Y/xKN5h3DA2DfptNK6xGAT4F+hIxrd
         1/1VesbYtUYHL437q+l+XOkZ8XA3JB/wuWZO2zzLPSxXInM95yPXmqOBbtK2NcdfZFZ0
         jhR7t/GaSqLZhbodgelkh2uJZ5SZH1h2UdNRiOWoAyGH4D7ZHFueeN+UN9rLFpQ9BfRU
         7Hc4XDIj49EyN5FWA3QMrbWrth9Znj6EPHNsALl7itnzz7RrhkjP6JR+bN0TaS1/1Apq
         jfJg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774601989; x=1775206789; darn=kvack.org;
        h=cc:to:subject:message-id:date:auto-submitted:mime-version
         :references:in-reply-to:reply-to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HmEX+ORL027fNKz2U61dhZCueuAkQztEsTnb9+25t44=;
        b=N2j9MZIPD2QUvIrdZMMGMFP723ZPu4eY5i2KAH/+7NorlpKju5hiAUVdC67fB1d+Wo
         iw2QOFkwVIoROR0ywoevpoJHc6MKz5mU7/AhZ4OzTt5qRyVUlRdPC13GOG70ojx6nwEX
         mc28bcnI6lFrnlviE5qNTYI5mPww4KtIBS9gNqjgGT1FjdctX0tALZA+M/IsFvZmDWpb
         bmpVizdtVoTMMQlBn7D+s/h13kWfqZZNDGn61V25FYGvfe4Ej3Cc65jkywpoNcmKWbm7
         4x1rf7nyJV1OrcpsFMGXuLSe9ATikxHMFz4DMBYC8BR+WVB2FmFejdWsOd6S/WAY7lWC
         3M5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774601989; x=1775206789;
        h=cc:to:subject:message-id:date:auto-submitted:mime-version
         :references:in-reply-to:reply-to:from:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HmEX+ORL027fNKz2U61dhZCueuAkQztEsTnb9+25t44=;
        b=eHgAPFPTaIdiOSl9sB3jcSggzwr/4N2l6h+FgsmCRkLKU4OgWAfdefRbvl+0CMKzfK
         UhBPVAAD8Kj04WpHM8+PPMjJH8BYbDDob/dZQ7goPqVuKiE9LS9atrHa3SAh94OQMnWz
         m0cpMnG5wZWk7Xw9d1I3klV1ZY4kaOJ4gPTNbEt/OjERDTlI63rHjLaAv2GGrHnnNb1k
         8PbPEBTI+ZZxU5/EVE4VfJz2yQW1akLZwXc7UJ/yowDSTv2e/213rQMofcVek5RN0qGm
         LkvOqRYXWEWEXyrYWYa129Ep+eJWtUWcn28iWngB5VyrixbSopGZTwNEJRxFkwYhuKZl
         ljWg==
X-Forwarded-Encrypted: i=1; AJvYcCUTC/GjV2KzfoTldGZrjZmqKHpwvzEXCKkNJE5BREkTqaBW0xJTWMsbW9p3jHmNDilmFOP/5aBJlw==@kvack.org
X-Gm-Message-State: AOJu0YzjfcNebfhMIeqFzIw/4JJSXqt3jQHA/zihSEYTVbIrJq1c3qh2
	brPKB2NOgA0y2pYI/hTeENYRB/yvlWnbQMlScKpZjyKyii5A1m8be05dL/KBvsCSlnD/JtHKOhC
	penk7gEzvegPwimvAU+B5hntMK4wC5ls=
X-Gm-Gg: ATEYQzxPuv34ZpKCrbbqv5tymW0pEqmWYeT2i9pqsVzIgQQOev2tdIXtg8YyK7woJZX
	YsgYwFGmfsqjpXbFCI+wmQqlMR8tyvoRfiLcbsCAJl4NVLTe+1Ud+MfEztXzOul3ybf95KurM3m
	mNLnN6GIi11ALZIhQxHb8hl44Cn/BDcmJHLuC59IlWR50J3IcZzAug14kNb66Bk+Twcy0hmRT0I
	63yUKr8XOifziDbydcx1Gmi57FrXAr3oPNGUcdTEDoSXvPsIkpS79Q95FVuFlQRXVgoUinr2UTG
	T+snc6cl
X-Received: by 2002:a05:6000:1866:b0:43b:3dcc:8b04 with SMTP id
 ffacd0b85a97d-43b9e9d605bmr2340132f8f.2.1774601988927; Fri, 27 Mar 2026
 01:59:48 -0700 (PDT)
Received: from 382830561574 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 27 Mar 2026 01:59:47 -0700
Received: from 382830561574 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 27 Mar 2026 01:59:47 -0700
From: Yail <tahernady45@gmail.com>
Reply-To: Yail <tahernady45@gmail.com>
In-Reply-To: <CAK8a0jwWGj9-SgFk0yKFh7i8jMkwKm5b0ao9=kmXWjO54veX2g@mail.gmail.com>
References: <DEX62KG7X9P@zendesk.com> <CAK8a0jwWGj9-SgFk0yKFh7i8jMkwKm5b0ao9=kmXWjO54veX2g@mail.gmail.com>
Mime-Version: 1.0
X-Delivery-Context: automatic-answer-34355976505746
X-Zendesk-From-Account-Id: eff5728
Auto-Submitted: auto-generated
X-Auto-Response-Suppress: All
X-Mailer: Zendesk Mailer
Date: Fri, 27 Mar 2026 01:59:47 -0700
X-Gm-Features: AQROBzD5WGl353eghs6Rahaf5CNmgUV5fXsO4kkl6-Nk23Ud4CFETRbc-WF7w4I
Message-ID: <CAApBg0HBf8RebNFFYJmTnc7SX2c3e-Dd9O9cCwzKWJFbrFKAtw@mail.gmail.com>
Subject: Request received
To: antonius <bluedragonsec2023@gmail.com>
Cc: Akpm <akpm@linux-foundation.org>, Jeffxu <jeffxu@chromium.org>, 
	Liam Howlett <liam.howlett@oracle.com>, Linux-kernel <linux-kernel@vger.kernel.org>, 
	Linux-mm <linux-mm@kvack.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: multipart/alternative; boundary="0000000000002af51c064dfdb968"
X-Rspam-User: 
X-Stat-Signature: 5nqatfypgny6nset538a7qwmq4gzimmd
X-Rspamd-Queue-Id: 96B59180002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774601990-666676
X-HE-Meta: U2FsdGVkX1+++FEjaA9P18FT4RRGDOKrG5ZCxe5FC1zoiTPeFCwARcoZfbppPVxdwbRPs4Jt1kGD76fI7dWG308OJ8QIHi4kx9AWNt4nGE1chixXu+4WTU9cEoeS2uGoMi3VRY7B1XiI+wT4duxGD2YDXmNupXcSsSmD0A0c/FufWFerkvFqS4z7Tifg0LZitsoElzZIXJ/cgwpTOBK6PLD9vkzQ+Aw5cxfODbqZdwWmc1yQIEKKIjtObR06ne8TY86N6RYJfV4wHYWRpUaJsLrxQ9dXTBcnWhDVs3A8Wc2SDXGOsgrrbzWxClTv6hZWe+Cjmg+dDRyyyjPyHBW17KYCmej9sUoOu4fqN0OkF85LF/4aPpWPPiU7hRULbOuts16iIZoqwoc6Zr/1Cz1Vd5sFLGfGB/x+1YZvhIN4ERvmDNw/IVIEej4vbhavoYzGXBPlYZJFCiZ64f20eNLdaRm5IIH5rLekzB0bVWK31TmpqKr5JbfheqH6LRba2NZzHoOoyJYcQ2snnQlp1BBt0XzvqJvh4iO1Sx5/ZGIMhbHY8nhobMMQAnf6wQiZBGD4yUkBlaBYBVqMp8JVDesKFQRJxOB+JkpeOyD7IqJlsGEScg9Kn15LO7O1dzRV1BO97l557IW3iYm0mUSvLHaRg6Da7uxcDcfbKHVX5EzTYLyLzajkXIALQIy1HdCmz/e2+6JAY/qR0sGOB/kzU1UO47xejSoSntmcpBPjpyWqd9UTk6ChAKVXbP9vqZCFRsh2CrbFrGLKt/1YsDLLa+fTzKz2FEwD9tKJJn5B8kZrLAhKDX+i4upNXInd7a1U2hX23ckxpn5wriXQrPnfeq49YDisuMxzAK3YHXZBY1JlIKmXuQpYQTmDi1T0yIL0bz2JgPXbPpVJlufAw53myaYxp06PeW3nwGXimtN6vBF+1Ykol1V7TTqkOqhZdUK0sy81erGJ3ST/sQOpJqgDC4V
 ofyaO6le
 aGkE4UXB1DhfKi/vUfuTEoRT87gFIhz5Z5MqbpSC1pv3s+TuvKP1iF/acZ/g7sO8IVPfe38Rcwilngz5wSlcSiSg5bZza5iUa/Cgc0qJ9YIlRez0FEZkWbz6mCGQ6HDpuj6PFcvic+xv4uWHUGC6XPkUn4jOueEjqUv+HeJnIKxMkaDu90WzetoHbEibKVWpa6eQ8d0pVaDF0CrD5QOZ2cWwRd/4D3dM4vyyBUdNSDVRx11QlIwVfI0ujrBalFyab9R1+zc40ggxxVdBqpDyquhXcCAzJb/ibvCCFL9OUb3EhPrCJi8CzLLZlSlGRmIKZ9RBaekBgmclj12Dvh10SwubyUOqdEvK1jVQrH/BniTLM78dfMlkdIimcTPAoLtSVsRCmmm1WqZL+DHq29/VmavCDQ2CBiC4frg2AITfMOtE8xYnhbag4JmcQ8R9zqPY8ffWPvotGGjv+f15/wEhb4mksH/sLHjJSxrype8bl5c7dPw/3LqfSUNMlRLAoS9rg+bfShMuf3iPLmrz7G/GsRiRRK+kbhTEcQY0wGfnPkfRET8vdc2lx597Bb1J32OWxB52kElh8dSNoOuMqLB4nwhU4xGNNcYE7IgRwhyAOMHiBjL+stjMw1/KbEBQPjOK+8xd6WEuwhkCxFVXtTg4Nxpn87niYNo7Uu4Ku01RNhG/6VLMlsGVKry1atYJ0kQ15KSmnbG0c5CIctqWpQKDO0SjppgFE2p5BvXBSLNKdYxzc1oK7bOG9ySBaNp4crYyacFQfp/p15IrDo210rGABApJoXUdwih0A9ujB1mKiFHVnw/rCmhzEFlYX7zVt9aXuReSDOgWjwK9TeICW1+9LCWIzSEchTZI3sJ8Xta4OlSJEXHeEcxWVYiUkYaUrjC3TDYMl5DW3SmqnyY1eHJ3cBwlxzXpF1gVZQjc/H4oOtexg2rjn6Fu9LwIemmh402AcuOGVoVBNDwvrnKmvN73IGbUDvsz+
 Aw2WBlGk
 rb/Vf+UtrvErXnBVWcwfuMb/EfABbUS42OWOo6isDiXWdzaaiLMyYo58ZFi7YOSruUMVOZSecMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000002af51c064dfdb968
Content-Type: text/plain; charset="UTF-8"

Your request (39) has been received and is being reviewed by our support
staff.
To add additional comments, reply to this email.

This email is a service from Yail. Delivered by Zendesk
<https://www.zendesk.com/support/?utm_campaign=text&utm_content=Yail&utm_medium=poweredbyzendesk&utm_source=email-notification>

--0000000000002af51c064dfdb968
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


<html dir=3D"auto" lang=3D"en-US-x-1">
<head>
  <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dutf-8">
  <style type=3D"text/css">
    table td {
      border-collapse: collapse;
    }
    body[dir=3Drtl] .directional_text_wrapper { direction: rtl; unicode-bid=
i: embed; }

  </style>

          <style type=3D"text/css">
            @media only screen and (max-width: 768px) {
              .simplified-email-footer .namecard {
                display: block;
                min-width: 100%;
                padding: 0 0 16px 0; }

              .simplified-email-footer .content {
                padding: 16px; }
            }
          </style>
        </head>
<body style=3D"width:100%!important;margin:0;padding:0">
  <div style=3D"font-family:&#39;system-ui&#39;,&#39;-apple-system&#39;,&#3=
9;BlinkMacSystemFont&#39;,&#39;Segoe UI&#39;,&#39;Roboto&#39;,&#39;Oxygen-S=
ans&#39;,&#39;Ubuntu&#39;,&#39;Cantarell&#39;,&#39;Helvetica Neue&#39;,&#39=
;Arial&#39;,&#39;sans-serif&#39;;font-size:14px;line-height:1.5;color:#4444=
44">
    <p>Your request (39) has been received and is being reviewed by our sup=
port staff.<br> To add additional comments, reply to this email.</p>
  </div><br>
  <div style=3D"font-family:&#39;system-ui&#39;,&#39;-apple-system&#39;,&#3=
9;BlinkMacSystemFont&#39;,&#39;Segoe UI&#39;,&#39;Roboto&#39;,&#39;Oxygen-S=
ans&#39;,&#39;Ubuntu&#39;,&#39;Cantarell&#39;,&#39;Helvetica Neue&#39;,&#39=
;Arial&#39;,&#39;sans-serif&#39;;font-size:12px;line-height:1.5;color:#4954=
5c;margin:10px 0 14px 0;padding-top:10px">
    This email is a service from Yail. Delivered by <a href=3D"https://www.=
zendesk.com/support/?utm_campaign=3Dtext&amp;utm_content=3DYail&amp;utm_med=
ium=3Dpoweredbyzendesk&amp;utm_source=3Demail-notification" style=3D"color:=
black" target=3D"_blank">Zendesk</a>
  </div><br>
 =20
</body>
</html>

--0000000000002af51c064dfdb968--

