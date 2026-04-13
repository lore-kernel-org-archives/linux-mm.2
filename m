Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7633F34C4F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 12:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26F176B0089; Mon, 13 Apr 2026 08:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220226B008A; Mon, 13 Apr 2026 08:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E116B0092; Mon, 13 Apr 2026 08:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2BB06B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:38:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 935F187CDB
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:38:12 +0000 (UTC)
X-FDA: 84653485224.26.692AD84
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8A8FC8000F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:38:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=skH9Jps2;
	spf=pass (imf02.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776083890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYnjBJ3lI+5DySep6CnxXC5pG+8CBPX6FoV4skweV9c=;
	b=1wrVjmTO3Rg7bQfsWE2HjwvPDkisgguhiUbMO/3ciAH6ixkgGpXSGDwclLBYxu7iEvfFDA
	creYcm9w6xYBMN3ru6mGogOyRnraeqrzEP5FPmDGnVZ+Hi9iuZyFhpA1x94eFM8TcT+Vh2
	yafJfSy7vncGYCciKDGLJr6qR2tTUwk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=skH9Jps2;
	spf=pass (imf02.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776083890; a=rsa-sha256;
	cv=pass;
	b=tbq+yz4v6M17T8s2gQ9fFVF37jtKkeALSUiN8MQq7u36Jytf25gPlHTnu3Viq3KLvmrmP5
	jpjQyPwf5dUnfCMQ2ri1QR8lNeRGHzCJUEJePCkkXm/6H9AaqhRCg7ZjTkALbNeTb0qwK1
	+KUXMK6mWZtLBlZHXer0s8Su0PECSHI=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43d7605ec91so1002782f8f.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:38:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776083889; cv=none;
        d=google.com; s=arc-20240605;
        b=C5+FgR+Fk9rdsiJTde9U7aP6RetfMyrI/xILStSbN4k6V9wsWXgER5OpWLf8U7vjsM
         OaDX2cwsl2tRKlY1Y2eWmXTRz7ohlmSoMfh27jVGRsdKc5gUfu5Oo2yWp/AwixldA/xP
         zhD71mIr25rVQfj20nm/28DtluVtgUb3X0CNWbv5QUbLNQf5PNSU5+9yePiyR1AHcp+f
         HSTMdQTyGyTgJRoPX9Ge7Bd/4XNTFsQsOAxJeRWh27D5wbUobpfOS70MEhl86FkabjgL
         hPEM1LPGaZ6Jv6sUay5TNJgz8waFFuVQfQ0W5BQINd/dk/wVgearYPLrKD/W8LPa3qtT
         JK6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aYnjBJ3lI+5DySep6CnxXC5pG+8CBPX6FoV4skweV9c=;
        fh=eCordLTCsbcseX1EpSI/1xz4fvHPTm2NLqk+PAnRqX4=;
        b=kM25zvaU9UYB6hwgUvuQiGp0pZEzMpJC3L9HQnoLI24Q4tjL5LKPze4sEiOC9H8ZNX
         3wlZhcvOe4ScSJA/173o9+DYmiwTzdKD8xgSXDrlt49ILvE8U/GZz+lHDIixPfamO5mV
         b0Sl6alIpJk5y9lGaocDoOh9N8RJ1NgXaB8bLapfoPJkcgfZFgRz+cNZxtEOnLvYEJMa
         Eod2ZqMH6q36/3UX4Pospc2f7yUMJnkMxgYRK88oh2l9fjyxsRcs6NLQFWpyYYyyEuSW
         WMhjByTKJj8LR+Js3noqOryiu3sepsYBbzwvBHesLr/nyour/TzqazuUrOZFypQvYMjN
         QM3Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776083889; x=1776688689; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aYnjBJ3lI+5DySep6CnxXC5pG+8CBPX6FoV4skweV9c=;
        b=skH9Jps2z8cPO5MOGLNMW1ClzHGWggRbiSMtWQgNkLP6L8IjDskwlqxZDqJs6JN/V9
         EFFn06GyQOpwoOsQcpX5Yh0pb39+KQYUK4PRvg0pUJT/AiVwi2y+MKyXBidzYusLTlrm
         4yoI4AXvivSS5xZlOAF1uiiy5brParSdeuNdyhrjWb9hUp9UpPjRfY1Iqn5FKKQq65qe
         gQaNPxnYyIAyTN1yPaf9NZhwDuBBEgjFjOUdhzxXL9hsd60Z6QxL4/6+5YrDPor8lMJ9
         jTmt7csEDzgPzyBe1Ja/HkpteAK/jsljzuQU66UQl00IAFWVjo7lBYPMyDetFypfehFU
         QGEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776083889; x=1776688689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aYnjBJ3lI+5DySep6CnxXC5pG+8CBPX6FoV4skweV9c=;
        b=AIl3iIIDVZHMr+h6guMZNzlNmfVJsvScYufMw+Mevpg/P55L3+0iS00CJpWaSi94nN
         p6lF84Rs69LYnq2kOSdsPt4UY0StMDe9fiRmWVbcZ2d7lbK8X9BXUHCqIw6f4ZUXyYQE
         vg8AqvBOjsORaIGV7j02H1PlbMOSfAPuplWaUKr3uhNub42j1992iKOVXSuiDE27QqyG
         +kCFj1gfcnpmBVu/J6DNp6rw60FXzfXwVfNzf7zirrVbhpG7CYUF1GoXg7aAAV+cIonT
         M9hl8lTbDdHnvb3b5mOxNoJxwciJA7YlllhI4k75+oFWcHOd2tqC+LA5TW+sznZLEMPw
         KdpA==
X-Forwarded-Encrypted: i=1; AFNElJ9Yz8EwsoU7OH2ognJiJc2NdA3fATZbtr6+91nVp0E8VPVrD7AUbVig3nneuHNVG98QOJZT5yRI0A==@kvack.org
X-Gm-Message-State: AOJu0Yy4SvRkCmirImYKO+KRCl1pSazAcQ0QOoRVlq0F+k9ycRDRIGtf
	pzzFEAKFoSABM393Ry4oBypOnAm7HUBiWd1f9aaEe6AqclyrAiqXoAxKgtof4/OfMr+EbrZqBA3
	hSSR2iUi7oj9ClO7IBw8+AGqfu98P1ZE=
X-Gm-Gg: AeBDievGO892lhN5wdxZnz5R4fzpjtIUi+PmGyaBkmu+wDYHLUFPNGHwtq9POHF7u61
	Qlqax17w55Wtjgm0F7kIVm2/tpDw5QNZWCGRxnEPE9oxoMhMa0NWhxZEel5LgQ6p6nVzmjDaDeY
	sf7LcNNHcl+uv2MQm5NIuxh8lt2wd5D/wJp84aRecjYH8wMUBwaRiqnukXPqtw2NLUXTcjVykVn
	cOOAAtDUibgAD9G8HCtZER299jWBJUdLsLO9zwYow8eINsbIXrT8huRXkMhpxPICoF/I1+XjHMa
	TTGJ9Wt2AQZkUiVHAnuLAItPeCAST1bOmxj7EbQHzyodX8Z2XZYx
X-Received: by 2002:a05:6000:2885:b0:43b:5022:804 with SMTP id
 ffacd0b85a97d-43d642c4ef6mr18965465f8f.29.1776083888671; Mon, 13 Apr 2026
 05:38:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260413094034.6944-1-pmenzel@molgen.mpg.de>
In-Reply-To: <20260413094034.6944-1-pmenzel@molgen.mpg.de>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Mon, 13 Apr 2026 14:37:56 +0200
X-Gm-Features: AQROBzBS1P4ErLaGsIvnQskkeFiqanfCrOMkT7tzHKJ6ti8IQz6_j1hecYm4m40
Message-ID: <CA+fCnZdA6GzHRifhwKCU4pfZrHxzr-btOeaZqgH7KnNLme2u3A@mail.gmail.com>
Subject: Re: [PATCH] kasan: Add abbreviation KASAN to init log
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8A8FC8000F
X-Stat-Signature: 79hyx4s5dcgsu6sxgonbgbrkpyhhoqcz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776083890-527538
X-HE-Meta: U2FsdGVkX1+wRNNM02wGb/p+4q9ojOSSyWRXf1LWg78uDMqeWsAZRzOW5QIU61E/TrvC1lSsaIRy8bUHx2hWu8NQJezwjGCt8JjUnD5aYmdpxEs9Qta18oMJNHlK4CLILLAJNWWVYVv0d/nxcNogPdYOgDlR+/g9W+Ov/d93jnT+TnTVH2YUfCxRVRQVrZSD6wYqIqe4etHccdeOu2YTJTKhJfROusnCEOXLAXbD7rtW2mqL1Zz+oVe4039vqOYkfyrrIP/YIJMrjQGzbta2eCwJarDhfZQhK9dQC/1BB496+S00LOJDkej7fj+4bcHWGSRR8bq2Tn8v5qqzy4PDygPRs8gCtFrwea9DIuCzZ+N7jsTFJKa99GpmMpcMfzbslJevJHdC6+A7FrXBcQNCQ6/n6iTPD8Ld8u097spUTlur84bn3pggAIcndPNL7zY86bq+RVErjQOtCe3yFq0FnybV7nJITldoXtzuAdGmCtQUIfhjbChbPg1SWDpZ/fbSd4c+szuZBuYsgnxst3xiuaT+sb1XLaocLiFXNcXWg1YLlHjMJD1dkVblD1WgeAHciFh61REWWHO6MKkeXycjkAG0H3lnIz70mLWproLPNxlMamFw+TN1T1blTkjW1/BXtvZR8GNMdmJKOLcSE8zkpnbK9mDJN5CIurpRL444nYqGduNkefGi5BELDWlFH/p6rPPiLUjMx5RBYpvmSzotHA/pKE+hbnLhPHx+PBAItuO9Yu0g5LH8MZC+Cdg6wQFOXTc1RxBRZE6DTF8u/CQqE/+bSa2PlnHptisll9/hYEjYT20P1uIxctbEnWXWzjoYpcEQlmn3RI/FV+c/WO4wFHBADxhcrVS+Zo/0CyPvO9bUQNZGM8J3vp/ri8MtBsbuav0zrd6Yx16ufymgk3LO29aiU2IXY9Z+6eQsXR9JFi1o6c/uR9GkrPSwwHkd9xEzLryPIiCQzROiKQ/bmag
 ZYzHOM0S
 RfCfIuzgkaJWcbKaMmbnq2CDrZIxQwj/Bc7pdfN2hlAOll+WjqOIa08jVSxDKO9wcvex44d9oPsXUsZ6WWKG0OENIewJo6ZWzyJiZVeE9sv0lxwVh8/w19Mz8Zt6iouY2FczJZScldW1UA6FmR+y8XmMKpRocrhWuTGR9lqpFfKQrU5+nS1i2+xJGl8wOjti2v2hxEBG85UoY8PyPbzEOEEXcfRljsSv7MBYZxN79p+QUBgc2hyYpQd2RG4fWUGBOu+ZVMI9darkiU6SXXnW0PmTQUQ4rjwSVecrKLfdfkHZ8JI0KyccR0YOjG0z+/XHLl/ecRO0QDLgIND8TO7W6xWcWvyN4XstcDXSMsm3ix5jfytTMvW1P+aPFmRYr17mveT5smpMN2ITjEwZpnmKqo28dEd2NTe1dPN6GWlrMzwYtmLaLcSCnGoI/B/Srt3nzLfj2zMw7Ypj4T0JyNUoUClZ3Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 11:40=E2=80=AFAM Paul Menzel <pmenzel@molgen.mpg.de=
> wrote:
>
> `sudo dmesg | grep -i kasan` comes back empty, at least confusing me.
> So, include the abbreviation in the log line.
>
> Before:
>
>     KernelAddressSanitizer initialized (generic)
>
> After:
>
>     KernelAddressSanitizer (KASAN) initialized (generic)
>
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
> ---
>  mm/kasan/generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
> index 2b8e73f5f6a7..1fccf7cc9fce 100644
> --- a/mm/kasan/generic.c
> +++ b/mm/kasan/generic.c
> @@ -44,7 +44,7 @@ void __init kasan_init_generic(void)
>  {
>         kasan_enable();
>
> -       pr_info("KernelAddressSanitizer initialized (generic)\n");
> +       pr_info("KernelAddressSanitizer (KASAN) initialized (generic)\n")=
;

I think a better change would be to add:

#define pr_fmt(fmt) "kasan: " fmt

to generic.c.

Similar to how this is done in sw/hw_tags.c.

And arguably, we could also drop the "KernelAddressSanitizer" part
from init messages, to make them look like:

kasan: initialized (generic)

Thank you!

>  }
>
>  /*
> --
> 2.53.0
>

