Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23F7BCD6E56
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 02:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651686B04B5; Mon,  1 Jun 2026 22:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602D76B04C3; Mon,  1 Jun 2026 22:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518476B04C5; Mon,  1 Jun 2026 22:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43BC86B04B5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 22:30:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA3F8C2853
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:30:07 +0000 (UTC)
X-FDA: 84833392854.12.0923172
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9234AC000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:30:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ibHfnmMK;
	spf=pass (imf22.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780367405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpFwM62mGltWd7B25NvF+NAcWZCXVWfkeyArxV0CLTg=;
	b=WYDPmASGar1ZyCqhH8hX4+85bnpEy7I/loFZmkUq1zn2horxlHe5MoV3K0TkfEiWAHYy30
	fqxwaY6cWUUqgyRK+1e2Y4F4ukCJeQAZ3Kw275XrZI5vZ/lBr7Kx3X3lfj3u6XRwAiE7Dr
	OMSoFr3yfy/RwTjEapsBXQvLpmnQt1M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ibHfnmMK;
	spf=pass (imf22.hostedemail.com: domain of chaithco@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780367405;
	b=wN9bIV0la+e5XE36vZxZiTb8+MXF0/lQWKzAWGUQAP087NiTY+KKJDTQO0POc2fF83Jj2E
	b1sIGQh3rFL2Qm8+M45gMJfPxeH/rlux7Qkhrw726XsybQ4X/l0d1mRCP2DbaUWkaXuRrz
	mnyNj8ifYEuQvfkjYKBH0bjZzQynR2s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780367404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EpFwM62mGltWd7B25NvF+NAcWZCXVWfkeyArxV0CLTg=;
	b=ibHfnmMKbCWWbtteJI7cjbnJjONP35zSVUCYHPl9F5dcZuof4u+J1K/gILRXJRzb306gbv
	J/w0zBWo+WJKH7d96PGb2o6sA5H1Z3Q2/yMB4muwfjVSHJB07oy6K4eNsowysqxn64kz24
	tN2//Oephkqo5iHy7KNQgaUuBx2GK3M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-mescK9sVOlGdcxj7rWM4cQ-1; Mon, 01 Jun 2026 22:30:03 -0400
X-MC-Unique: mescK9sVOlGdcxj7rWM4cQ-1
X-Mimecast-MFC-AGG-ID: mescK9sVOlGdcxj7rWM4cQ_1780367402
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-68c6649a135so2556290a12.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 19:30:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780367402; x=1780972202;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EpFwM62mGltWd7B25NvF+NAcWZCXVWfkeyArxV0CLTg=;
        b=mUcz5LLI+DAtPVkyB2Afj2Z9L1J37bXzGHAwZ3sZR3ocggGZtHDAvRL/eRvOBCJcFT
         LSKj9gcHiFU5pEqpw0/iC61syIv7PNG03FoloWtG+s73K7v36aiOV2ED3xy6/tXDHouL
         dErcTEazdh4l742b9h3BtUR0Qpo/4FZLnegJrxzOKZZWWAQ3rha3S51YOkI53y+B7qta
         ce9WLqmsM29ta7Wj9yaAYpGaHSlS3/Wn73k4lh+p2XZJK3ncxNGiFAJPG+//9bsuMxyk
         wAed3kdjBNdyw/O5OPWheGOHXdMGYS3bKtLa3qiH02B8/uwrmC9a4b7hIb/D52wFOPmU
         6REw==
X-Forwarded-Encrypted: i=1; AFNElJ9206XTKpejwxJHFd8kOqtQK90rQnAxzMV30x4wLUFMcduunS7oBakNVxLVJLUhBEkDRRTKjFRNsw==@kvack.org
X-Gm-Message-State: AOJu0YwhV/SUj/JP6EmxjQaTHIZ9UNmRp9HTgwRfiZZkWZf/kooXU5GH
	FMJfWOv7QqKyoEyT54WxlF7qaCkBtqPmK0hNjsapaq2rhhFKDv9Uy1dFIWqREfEecK4STl9hh6W
	Aj3Z68qWauqrLP7V24GkhqV93qT4VZM6MDtWL2o1v3AwNoeSYqnBkNpbrImn91TCIATVRC8EptO
	9LX+Pw5zd4kNxFx/XMI2qCeBXvVg4=
X-Gm-Gg: Acq92OEv6gGTgaqWKVYn3+WsxRgda05z1QyZOaij4B3I4FxCBkd8brQXcpJQcl4MePM
	liZn9XSXNTGQ74k2c5MEUw+kkfJ75+PjoZ5Ok8FHU/mBnF5y8sYZxRpCTpVLEfXjTdGA72nxlSb
	zoh0u8zltmo/dAzxjcQnnswUbSt7WydGpP8kgxrnh3KehaezjzKdfxxfMHVazFDottix9Dh1ydR
	txCHXIZ6KB2ffyh5g==
X-Received: by 2002:aa7:cd10:0:b0:687:2181:90ab with SMTP id 4fb4d7f45d1cf-68c8c464e28mr5811230a12.14.1780367401920;
        Mon, 01 Jun 2026 19:30:01 -0700 (PDT)
X-Received: by 2002:aa7:cd10:0:b0:687:2181:90ab with SMTP id
 4fb4d7f45d1cf-68c8c464e28mr5811219a12.14.1780367401553; Mon, 01 Jun 2026
 19:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260527224848.1753560-1-chaithco@redhat.com> <20260529203508.a1813d90f7bfb638bfdc815a@linux-foundation.org>
In-Reply-To: <20260529203508.a1813d90f7bfb638bfdc815a@linux-foundation.org>
From: Charles Haithcock <chaithco@redhat.com>
Date: Mon, 1 Jun 2026 20:29:49 -0600
X-Gm-Features: AVHnY4IdFGieGAlEv3UARvxrkJeMu1jzyAcJEJPjv2kjcRWBPUVbmJUsicfVVVA
Message-ID: <CAMcbwu6Yia5mjCgQbq7NM7HJ5+3T3gNKCa493H4_jO7a+MEC1g@mail.gmail.com>
Subject: Re: [PATCH] Respect mempolicy when calculating surplus huge pages.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8QpaQq37i9ztHkrBKbbAztCnOvoE7ARwCRKT5rduTWo_1780367402
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative; boundary="0000000000008a36c206533c1621"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9234AC000A
X-Stat-Signature: phaamhzngxocbrgwtiawswbta5nojs4b
X-Rspam-User: 
X-HE-Tag: 1780367405-683593
X-HE-Meta: U2FsdGVkX18A+WX3dt1914223UC8Y4gaCaUlt2JVGDUUlP9hpihn5SC2aYDxhaGNFNlfRfRCMymmZeX0dWHlPnLaeXml/cjebdNYJ+rd6Ij8yhIhp0dBoeHJzg/WVrd5aamYD5gb775ZJIm8B+4AbQKrXcIIFy/1f+TaAAYg3xzr53MZ2BI5jw1MtyeQ4AO+V/JQPMDYx5EUzeSGQgntp/8pjqkaxg3fKJXlUgkwSkWAc64nRAyCjPIOm1d88xF0hFkzjHSzYvQjCjLDEux6IMChXkYp8bpCNd1viOeIcp1TyvS0g5tFh0o21G+matnhhumG34He47DKUzRm1dpcfnfgzDYG7f/rOz/JFOsSnN14+ZowgxVoDvuJI6nrOZWshfQkm2Zor0n0VuV6V+ZkqkFqU/RKe0d9CuD0hTs187DYx4GRumWR1L778DtqvLIiaVW8+mtyaKj3yLnH2Lft+G61fkIrHvSZlxGuKW7ws5ApJ6+EM5Zpqadu8uFWNLhw860stkQ04YM5P9uvaTWQ+ZDlRmGelQrGKMl4+S9Xq4sUryprKXv+H7e+iD5mp7BFNU7Z7FwX+eGBPo4Geh135AL5HP4hbBYMe/Sk+vKRCLMOEYbp1bPj/vl0S/pnkAbbHDEj4qqHTTQGeDaurQlLWX9eoUVYn2UgSKQxRiBGl63XzF6fhL+fZXiLnmRi3MnT7zsUKOASq/5JzPn+ke9OIQvBSmKNwot8MUHELhxofpXPD3PJZtQDXvgl/JN/KVjvTF2cWl53AxeFZ8PzHOQ4fbBx3A9TybZ4gs2v9+wrEV/KBDiN/eLSSC1lbziPogIPZQN/8o2+zvUEI+rUL0gBex/BhyvxWKyCg7UGFNv84aI30lnLt9xzV+os4DVd+BPsHJsdmsw6L+kz3kf2HY0k2fczKUx7LaAm9ZnR4keKQ5eTImB9dklwrHyPbSBPRvvbJCPuh1NfRUimReeMZJn
 M588StTt
 UWmPcB6kDBUa0R1m3/ivctDzOtDGf7/q9SEo+gCa2JnOF4kOl8ShlW1Lf2ALPCHysW8SJGJhbBWuM2i8kl7bENC/PxwesQKvA2oKAbl9DY+74fpDI/nBeCrH+lkt8MM1Gf0PWD2APZK7HtsZy0TQEA26zvh/yUIE/EhQyLAlkoTj+VcO4JAwJhyPJhlc61ktXBcg0LxSfyHN2qBt6kFaCYBl7lTzN3mPfSW2HEAjeRSIDb3JSNGxFQueKwGs0xOH36Dnl5eMTxAQ57OqgPPPsFYU4E/IDt4chmOvJBIC7apHglGtrJ9DTktA6tLafcIFWA4VPAMPbNt68LPqyEwGxIPtTD3DPXkZXc/XxiTr5ViLbxgb4cNNzetOrEVr4RsAxOPcEhX2jj/RP7ajiL+qH/cYJqe9tdboyzZePIgNIKvuEhU9O8a1SX9aN0PtNclE4MvWfm6QLQys0+DSo0mhhd7SD2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000008a36c206533c1621
Content-Type: text/plain; charset="UTF-8"

> Thanks.   AI review asked a thing:
>
https://sashiko.dev/#/patchset/20260527224848.1753560-1-chaithco@redhat.com

Thank you! In double checking, I can confirm overallocation of surplus huge
pages occur under specific circumstances as described. I am working on a
second version to address this.

--0000000000008a36c206533c1621
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">&gt; Thanks.=C2=A0 =C2=A0AI review asked =
a thing:<br>&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"https://sashik=
o.dev/#/patchset/20260527224848.1753560-1-chaithco@redhat.com" rel=3D"noref=
errer" target=3D"_blank">https://sashiko.dev/#/patchset/20260527224848.1753=
560-1-chaithco@redhat.com</a><div class=3D"gmail-yj6qo"></div><br class=3D"=
gmail-Apple-interchange-newline"></div><div>Thank you! In double checking, =
I can confirm=C2=A0overallocation of surplus huge pages occur under specifi=
c circumstances as described. I am working on a second version to address t=
his.</div><div dir=3D"ltr" class=3D"gmail_signature"><div dir=3D"ltr"><div =
dir=3D"ltr"><div dir=3D"ltr"></div></div></div></div></div>

--0000000000008a36c206533c1621--


