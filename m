Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 963C6105A589
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3236B009E; Thu, 12 Mar 2026 07:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80E16B00A0; Thu, 12 Mar 2026 07:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B555D6B00A2; Thu, 12 Mar 2026 07:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A422B6B009E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:36:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F28387B06
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:36:09 +0000 (UTC)
X-FDA: 84537207258.14.9DC4D31
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id EB43340007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:36:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZOyKrkDp;
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773315367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fHlkrCbO2PHI4iRbAAS4ONOWqi88RL/qFN7un/ieAQ=;
	b=4EXxWr70HzJTeKw8iZ0XhHGjR/z8NjZN5JZBT2G6r/Nq3zHD14R3dZ2EN8dZ6l1tuq+oqe
	aOw4xBr3qJvJcb01oxKrEinyLuOtPy7mf92ncKAosaV11Rn/qphClnrO/oLRoSWDOO040X
	88A6kq3NOszhdeZTmwNRc2H63px2Atw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZOyKrkDp;
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773315367; a=rsa-sha256;
	cv=none;
	b=mIaJfyKy2ycLhFgdAKieeRz0M0MbRauUsoATvEEpesTJiE81aLCUGLGbRQL+1Nf2+Gbj7C
	iM3FWH//YuNWuZcntejbFpmIcT3vD/sd7QyQM/9KiaXf0JFAU3GdDd31Oarz7jf5/th97b
	1Wh7VOuvNP9WdRwCH3VEXy1uIbCS3ss=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773315366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3fHlkrCbO2PHI4iRbAAS4ONOWqi88RL/qFN7un/ieAQ=;
	b=ZOyKrkDpJpfZ/fs2J6PXUwr7QzMJ6sWqJM4mlPWcSVSXGWr4sWEB1kST98svBtC434awNV
	Bxgrs+0lyeR0M/5lcPt9vMAIZ7MU61eEI2pFduZLvr6SGLhVX00wndwU2FsJJOT+VuUkKw
	mvsSzbK9hB2zAm1P3HiS8J0UJyXj20Q=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-a-mxGn8QPkmogGLeUjguoQ-1; Thu, 12 Mar 2026 07:36:03 -0400
X-MC-Unique: a-mxGn8QPkmogGLeUjguoQ-1
X-Mimecast-MFC-AGG-ID: a-mxGn8QPkmogGLeUjguoQ_1773315362
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-829b9320a2cso421081b3a.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:36:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773315362; x=1773920162;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3fHlkrCbO2PHI4iRbAAS4ONOWqi88RL/qFN7un/ieAQ=;
        b=HCT5KmJYuNIHdL4idKP/Kza7DsXGQUOdKUUvmuydaLAGeUOVvwOpLMfSFd/6KJhTAb
         s9a2vCEKAg/vFtua/AdfCKicOPi7mbP/EZGw9gWl3m+ERD1Taz/CmssEZLSpFrq2hve4
         rpwM5gzKShboZfKQ5QQpGxiWYvC/VJVsKkXO83lfJzSR/ij5jGuifHwvAlzpJgE58kUV
         mHtl9CTz6qI+pPWCodrBlmIGptBygtoaYDyhfjdbd+YARC11IA+/KUeKXWTDuynhuVGI
         4utPe6fHmhxcCYFYsDCNlwKNXSBZ2pQ+hQQ0xYhL1CXyzH+c0hM9K3dnVPAXDRSnqJK5
         5VJg==
X-Forwarded-Encrypted: i=1; AJvYcCVU/K0lyJxyXIOgqXj1kuoLf5+PdpNEaLknlGpI7bA5/G/Fb9j2vEdf6KJEq8eiyOAFxVOT7XF1/w==@kvack.org
X-Gm-Message-State: AOJu0YwvONLKGH/APKV5psUpfxhIskXegq47NxytilI1xO8VT81Dc5ca
	58Aqdmm8l8g2A6gh2/1Qml3F9WwzJdU8hDU7mN0WbiBfLl4f/11qfcJ+lVI4pFKJAzvLPYMauH3
	2ClARcHIvTaeaRho/Ks4t1NksAvWJoEht3cNvJknsJvEht3zZWwzmB26fDzlNnFPlf7Q+3AjZ0R
	oGh5cuwWp5Izp9Hpa8XDMiKI8As+Q=
X-Gm-Gg: ATEYQzw6qTetRWkiWtKJMsrAPg7B2iC+glkh47xa1Q/4sreBK5cbXOEzOkj1GBp7w1a
	9w/9OVjUpR1F5TPqWVVZkAoRpRI0eaVLc05FYubL/ypc6jCTrOc+qJkmhzYd5HEUQpmvWtHPnVt
	Gm22oNuj0l+MD/o2ZviQHeIMufIpXhmkFTM0OMfLSrgsV06GwRjRQcQ93mnD3aHTGHu91oYAHlQ
	n78Ja0=
X-Received: by 2002:a05:6a00:98d:b0:829:88e7:c88b with SMTP id d2e1a72fcca58-829f6ea743fmr5126206b3a.19.1773315361903;
        Thu, 12 Mar 2026 04:36:01 -0700 (PDT)
X-Received: by 2002:a05:6a00:98d:b0:829:88e7:c88b with SMTP id
 d2e1a72fcca58-829f6ea743fmr5126173b3a.19.1773315361494; Thu, 12 Mar 2026
 04:36:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260312112612.633138-1-chuhu@redhat.com>
In-Reply-To: <20260312112612.633138-1-chuhu@redhat.com>
From: Chunyu Hu <chuhu@redhat.com>
Date: Thu, 12 Mar 2026 19:35:50 +0800
X-Gm-Features: AaiRm520E5Cumg1b9GqcrQ6F2UD01l8-iGvUSDUFLPXE3ZB0WaFFk3KmiIqlLAg
Message-ID: <CAKJHmxyw1gRega+Zroc=_bO7CRUY_d+TmJHoRY5fexukFRRdGA@mail.gmail.com>
Subject: Re: [PATCH 0/4] selftests/mm: skip several tests when thp is not available
To: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JwQZV1K5CtH6h4w8UIqikmja1pO9HHphPQf10qVK1LE_1773315362
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative; boundary="000000000000327676064cd228cf"
X-Rspam-User: 
X-Rspamd-Queue-Id: EB43340007
X-Rspamd-Server: rspam08
X-Stat-Signature: uingoinf6rmqgeidmkez18k31foh9uu4
X-HE-Tag: 1773315366-557234
X-HE-Meta: U2FsdGVkX1+zjraqJqqPV+RQ61H7VINAw2VDNN3OF44kccU4jO1wMjtswHFYR9z6zE6ihhIL2tj/V2Yrm2ORzt3YsnlvoeuKokdMbzrg+wioxA3NpQPc8MxLKrFnoyUWxKMU/VfYKb/7Gl8f6LjY3YB5E2f3aII8YYiZU1ebbi+dguAARGn+Jf/pvLSezxwIf33hQ8Y8oYFWe/YA6+ZfwMrcpOqHVGPAM+SLDTID7lvzOiJqudLOPiVTb3SjsYDFYVOWsaGV2JyXM/Yo6vv5/0N0RP3k4wAZe789wTl8/ve7OHoLMw3psTALN0m6pMO17pkxR8r3RRUOZ6dvjG64+e64ZmCE1DWCWADfR+MyWgQFO+CUEY9Qwg2iqTnOrbHWMA5Y4iHZYtlkin5d3GeqWqwW29UFHtGiQMszDxiKQIy/qsxzV913WZ8Vx7vmkXT0RS3DNo3EifurXQZPf0TG2DU8WwDmEMzVGOa/sQPDfPtE3g6Wqosi+/3NSlYWWB3gSNA/Gwy+f3VzoK/nn4P5P0gggx8tisqrshX7rjMTonoGXLth+oHT3dlhvj89V85gb9V0NGKfVqBfpc1jHuIpQwolUzK85jUoSqlEPHjdKrn88V72Gb36PYR2Kc1G3xIHmGZJoz7NrPdjLxXOSAfCDJ537MENBQz2XpmpHCDR3qhHC0UJpmnzDbj4rGRBhX4gKvXbRA76bEvKXXfklLqwiJmCDrY0apQb9RiivXA4D5YPgvJdusSRy7Zfl7vzLcLvVe8rCJeFpKjiguebG6IOBVSKTXZCDO2XHUszzUeE31IeeLuphMmw/OeSJQQ3O8+5ZiAlEI1BJ4dSnEFjKFmHLdXmIs1Dlqvwkd2ROoHYaOsenezTPjKjbx+38lALP/W8NcyrswpZF/ylOtG4kUx8gAQtD2xcgQIonpg2f/UMajt/6fLdhV7K7FAGfiKE9bdqGRvNlk1/qyS3NdwUxc9
 XRbu7nVO
 7hzzLjAUwtT4l2clCey6e+zpc4IxvTtCWvTfEozlxrqcvS2ZManEO9xrOVKfKT+Rj9jUXbqJT/Y+iej7LLIxPri3d3kmJXYdzZOC0eljhNicRUHua3x00rbsWU/hYX69MtiEIyfG45j2l5zd1wvMxs2w1sRbaK04YW/Kq4cbmBU7a6t+qw13GczQpQUa8Tk+P+CBcmFSksAzGv6rfBoy/6YJOd9i6R0xUDik3jMLHJgSvli6rJ2iSkfyLvmvBHHTgcGDwRTimKO3pnsuJqfwe7mNX2vTzG6hXyfDFVkZqIK+3028vT75fuKeTrXf3lUC63NEAvQPFntcKRt//jN5WKkXLFso3MKa3YxDzb6F2vPl1JwtoLp1F8pPUdpvhA4uoHXxx14MPhWb8cENuRNANypaQ2cgDlOF3IUR3Amyf94QvDeg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000327676064cd228cf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 7:26=E2=80=AFPM Chunyu Hu <chuhu@redhat.com> wrote:

> There are several tests requires transprarent hugepages, when run on thp
> disabled kernel such as realtime kernel, there will be false positve.
> Mark those tests as skip when thp is not available.
>
> Chunye Hu (4):
>   selftests/mm/guard-regions: skip collapse test when thp not enabled
>   selftests/mm: soft-dirty: skip two tests when thp not available
>   selftests/mm: split_huge_page_test: skip the test when thp not
>     available
>   selftests/mm: transhuge_stress: skip the test when thp not available
>
>  tools/testing/selftests/mm/guard-regions.c        | 4 ++++
>  tools/testing/selftests/mm/soft-dirty.c           | 4 +++-
>  tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--
>  tools/testing/selftests/mm/transhuge-stress.c     | 4 ++++
>  4 files changed, 18 insertions(+), 3 deletions(-)
>

Apologies, a duplicate patch 2/4  was sent with minor different titles,
I'll resend the patches.



>
>
> base-commit: 80234b5ab240f52fa45d201e899e207b9265ef91
> --
> 2.53.0
>
>

--=20
----
Thanks,
Chunyu Hu

--000000000000327676064cd228cf
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-size:small"><br></div></div><br><div class=3D"gmail_quote gmail_quote_con=
tainer"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Mar 12, 2026 at 7:26=
=E2=80=AFPM Chunyu Hu &lt;<a href=3D"mailto:chuhu@redhat.com">chuhu@redhat.=
com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1e=
x">There are several tests requires transprarent hugepages, when run on thp=
<br>
disabled kernel such as realtime kernel, there will be false positve.<br>
Mark those tests as skip when thp is not available.<br>
<br>
Chunye Hu (4):<br>
=C2=A0 selftests/mm/guard-regions: skip collapse test when thp not enabled<=
br>
=C2=A0 selftests/mm: soft-dirty: skip two tests when thp not available<br>
=C2=A0 selftests/mm: split_huge_page_test: skip the test when thp not<br>
=C2=A0 =C2=A0 available<br>
=C2=A0 selftests/mm: transhuge_stress: skip the test when thp not available=
<br>
<br>
=C2=A0tools/testing/selftests/mm/guard-regions.c=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 | 4 ++++<br>
=C2=A0tools/testing/selftests/mm/soft-dirty.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0| 4 +++-<br>
=C2=A0tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--<br>
=C2=A0tools/testing/selftests/mm/transhuge-stress.c=C2=A0 =C2=A0 =C2=A0| 4 =
++++<br>
=C2=A04 files changed, 18 insertions(+), 3 deletions(-)<br></blockquote><di=
v><br></div><div><div class=3D"gmail_default" style=3D"font-size:small">Apo=
logies, a duplicate patch 2/4=C2=A0 was sent with minor different titles,</=
div><div class=3D"gmail_default" style=3D"font-size:small">I&#39;ll resend =
the patches.=C2=A0</div><br></div><div>=C2=A0</div><blockquote class=3D"gma=
il_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,2=
04,204);padding-left:1ex">
<br>
<br>
base-commit: 80234b5ab240f52fa45d201e899e207b9265ef91<br>
-- <br>
2.53.0<br>
<br>
</blockquote></div><div><br clear=3D"all"></div><div><br></div><span class=
=3D"gmail_signature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_s=
ignature"><div dir=3D"ltr"><div>----<br></div><div>Thanks,</div><div>Chunyu=
 Hu<br></div></div></div></div>

--000000000000327676064cd228cf--


