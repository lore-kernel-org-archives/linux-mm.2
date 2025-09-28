Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E66CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 13:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13368E0003; Sun, 28 Sep 2025 09:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC44B8E0001; Sun, 28 Sep 2025 09:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2D18E0003; Sun, 28 Sep 2025 09:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5C578E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 09:18:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 559CB134022
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 13:18:36 +0000 (UTC)
X-FDA: 83938713432.11.D3F4715
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 232B5180009
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 13:18:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ov4zjl3D;
	spf=pass (imf24.hostedemail.com: domain of minlei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=minlei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759065514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZrgw4gpKloeX9jAq8wMstO9M9cFrPaCA8nWHSUeCis=;
	b=N7ILSUwlcJRJx68Axm6m9BUXH35UH78mV6UqvogqLGGjnQLGzEXiCmUEoJ85bCvmaqJNCN
	yDFlPaMNFs5/PU4RZou9taajiPxx2xvsZMryLJovqgdkpGKZFrsvKTj8cabEZLTlgLhBv7
	zRFx/AA27wiruclyBKAp3Z4cuO7DzrM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759065514; a=rsa-sha256;
	cv=none;
	b=Zb+wJsQ0Sl4cO3kH93pjg+0rodjyXcCHM6GtqRYRT/kBkHcjs0/jQIoUurgOl6VMvhYZ6x
	jjn9gGHWj1LQ6urHZBfh1asBpfI2x+z4Q91XtpC4Ujl9rOoG2d/I/cjN06XlbTHiFw4hxr
	LdjMdiyvye1Tu8osQC0J3t89izM/IXQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ov4zjl3D;
	spf=pass (imf24.hostedemail.com: domain of minlei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=minlei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759065513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZrgw4gpKloeX9jAq8wMstO9M9cFrPaCA8nWHSUeCis=;
	b=Ov4zjl3DM7+arRlhDl2d42vTVNfCUPb2MUJ+5t9C4tpYFvq44/OspkXCFJz8RiMXSoGFdR
	yJw1pMFmrPTyOs1kgPPnteAHjQfcI5304Wda1nNQcC1K1H6KBuhXL8Xs5bvpexy31SrTQI
	KM2qHnRviZI05nVRYxCSHi7E62+JlWM=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-qXhFyb_xPLCSrlnRVxdzlg-1; Sun, 28 Sep 2025 09:18:32 -0400
X-MC-Unique: qXhFyb_xPLCSrlnRVxdzlg-1
X-Mimecast-MFC-AGG-ID: qXhFyb_xPLCSrlnRVxdzlg_1759065511
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-8e47b4f0c3aso5038189241.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 06:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759065511; x=1759670311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XZrgw4gpKloeX9jAq8wMstO9M9cFrPaCA8nWHSUeCis=;
        b=RcTb7aOtK5pMRTKhXskNQ//E7OjvTF0yB+c/gKNd+9HsXrEZdy+bvtcIsHO1bhk4J1
         lLrB9snyjmZmvfjX+47NC5hjEgJCy/jyDXmkuH58gvg3+AClYqRfH9FSqVAdUftitjz3
         qflbxS82lMkgwPRryUz2G7vmbLDcuN+7ULUR3FpMVNssMomC9M0uqV8D1aQTXLYofeiv
         o6xdvFPpFOyJ0BNYM4u3VwSWL+kM04Dtg2CJ565E3kBOGxNmSoL3z2C9E/mrVjb0uChc
         sd/smrWCAkTH6zZqwj0EZwTIBYhJ3hUU8ILFSSGAJE/bHt32+fBtMzWvsXQ+zTwa7RtK
         o0JA==
X-Gm-Message-State: AOJu0Yywtr11JSFX4xqS3meIVqLtqtQV81AElfaarU+lI+BU8OogD5Gh
	2vDgWmYn1kREf6wJAAppNPMufnYPIUuUX8Gym4RFDAFi3l7EAJG0fNdUtKxZ7wxWPomVASfnWFJ
	tQUTVtHTei8YGxJjq5PBTR2QLZk4xw8Awo3vHbV0oD7JoS8uS4UHof87HvCOHQhl1ztmDX1nFeX
	8TxiuYIsjH/3BykwENMmT9lhb09/Q=
X-Gm-Gg: ASbGncsweUo4XSoI2PCHUU6gFxE3oFYkw8sNUwDNRGEnGrVxPg0MF122qnsy7boo2iv
	c7TfrI0oVpyy/fcX5bcJ/7BNqT9Gl+hrm7SCisD5EnohmsvAsSzXxjxOzjLgmoINEJ2d27Lee7Q
	0fCuhubyDo8TGdakNPwSpTOA==
X-Received: by 2002:a05:6102:3a12:b0:538:dc93:e3c4 with SMTP id ada2fe7eead31-5acd4636d52mr5613328137.16.1759065511354;
        Sun, 28 Sep 2025 06:18:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmHzfMI3Oe1YG7uKvPaPiSWpbJ7zP/EQGzITHlCvVsDPm2SGtMgLiLw/1bq/SDVd4FWH8fuf8RN3ofjSvjzK0=
X-Received: by 2002:a05:6102:3a12:b0:538:dc93:e3c4 with SMTP id
 ada2fe7eead31-5acd4636d52mr5613323137.16.1759065511056; Sun, 28 Sep 2025
 06:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <37087b24-24f7-46a9-95c4-2a2f3dced09b@niklasfi.de>
In-Reply-To: <37087b24-24f7-46a9-95c4-2a2f3dced09b@niklasfi.de>
From: Ming Lei <ming.lei@redhat.com>
Date: Sun, 28 Sep 2025 21:18:19 +0800
X-Gm-Features: AS18NWDT6O8C5AwkRhe1aYAm1xR2Cn4j-NljwDjrlE4H2_PARSLlyFDDCraW_wY
Message-ID: <CAFj5m9K+ct=ioJUz8v78Wr_myC7pjVnB1SAKRXc-CLysHV_5ww@mail.gmail.com>
Subject: Re: [BUG] Double-free in blk_mq_free_sched_tags() after commit f5a6604f7a44
To: Niklas Fischer <niklas@niklasfi.de>
Cc: linux-mm@kvack.org, linux-block@vger.kernel.org, vbabka@suse.cz, 
	akpm@linux-foundation.org, axboe@kernel.dk, nilay@linux.ibm.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jZMAO6VXb35LRywIQx-jiubiJugyL0EQDDqxKhqOXi0_1759065511
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: urd95m38f6ztbci6rcifkowaurq67qa5
X-Rspam-User: 
X-Rspamd-Queue-Id: 232B5180009
X-Rspamd-Server: rspam10
X-HE-Tag: 1759065513-583417
X-HE-Meta: U2FsdGVkX18Txu1QKkUxCZ8qE+D++sXDd6jAzmeuFqF7Va1f7cJxyKvQFp/+sqAz4NPDSe0khPWM2T2JCGmdoL/9Mz5sbM3bTwvJpmJNMqLjSZQ4QnhiSYEWY8ykyWlCGNWacNwfJdNmwAazVbS5XQUQ+RNXrdqv8y7PNMS6nvm/E7PB3e8LgjhU8JtMzPDuLt0rEziSsDiUqwzp6Zy3WT0AW2G8oHLHTST7bDgCie8KxviLGlDKpexYz270fLu4RdCcnD6gzuTMt/eB5WdW1uuiugn/pdmNtbS7qrbmim/Gbpbqb8fWc0MtRSNZ6cn/VycR3yy0zUgRpWfM9Sjlz5oH38LeNUYnmN+yys8QBsUCQlRrLfq7GDj5+OTlQ0iAhQl2sJvKa2nVpDO4jJxKoutHmGCPovO+IR1yKqZd6YIttSoKBYhqpWzFqx9MkZ6JkTWvzVor8q+m0WPD+CX1EfCzzdtqVveKGWXBAZiEEQ5R1lnWxgakTZzmQ2SX3/CQYGnZ8rtCYnZZpkrx+u1Lf3dbs+IdkBLVP94Hdydrqp1QM9/W9nVgVVTdv+6qRK2HuH6kjYfy8hPN2quNxgOkPz+Dlrz1tiKscxBxQHptA9Y/yym30DVVnvFT1t3fXOOJnQMQBXLPBy9Lb9Iv8noZvxq7mVkqY6pxePj9EW1RFhef4Zb3sNJ2vcQORE0zdsnOWqgM9fXvC9jtgdXhjnE1q8EZ8MMhJS5ld5Grru14FF9Um171VNYSPtjKTkhWQLaTcL6duw77TXgJeEhKw0xc3GmmYB8xkDah+Yy/U2mED0cY3OcYFrbjwnSJii5BMcP7yxdS4lujEsvzeiESKVf8Sf8SO2j5r9Ku/+gN1DsFu7wsJgW+DauH0Jug/1JJALtBWIpGeqD6MkZ6pxm7av005ORqIW5MKRlj2rKo4RP+zhNk82rnUaHseAyo21oHI3zGC7UGN8g2+c3g4JbttmK
 CH6Bphns
 WfF39dHYu8O7c+AkZb6ac0k3uXem1Pos5s4PKy9/VBjYd/h2f01SB31aYJGlLHzq7augz45yiB3le8Rjdy4EcuPO4fuQW1uZNlDfV/3MTomfcPcNCYuBGw2OlQGDlQWzMINY3HSy33Q5d6nvQoWm0mfbf2nQfzKY9Oau+I5UVPARuaXv3j9Flugt1vXCu5/BMLxW2k0s8LpQ1zkKbdCX7BS0tHV/N/neIphqo75si6kzeo3yebgFJXF56BGoydvF/CvDb4k9t/JCRweGT8fEQFPGYMI0dP66SbRH/BUvyj1fZuvnB0LeO1jQNKEqDVRQySdEcpumjbXbAedjSmC+b3Y8KSKqCswQ3JwWL1saLW3NfcsaDYcN2TEryZ1X0Tbcv+YYWRsrmyeD+DnGZN2jNi6YaYwuvUbmOWzriHCIY53Qao9GKtpdMOKLnC0yZoqXW4WFeUxf6sEVTbo33niP+QemMtE0FAv8Ys3mPLL9AWB2m60Pt7lpurWVmlbkg1Ev5ao5VjmOy4H5o3niJ1DwKim3s/wEFLn/FgSTCHCNscBu8DE6iUT1zvwG+fY8naeGACeO99PWxW/oznU8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 28, 2025 at 8:18=E2=80=AFPM Niklas Fischer <niklas@niklasfi.de>=
 wrote:
>
> Hello,
>
> I'm reporting a kernel crash that occurs during boot on systems with
> multiple storage devices. The issue manifests as a double-free bug in
> the SLUB allocator, triggered by block layer elevator switching code.
>
> =3D=3D=3D Problem Summary =3D=3D=3D
>
> The system crashes during early boot when udev configures I/O schedulers
> on multiple storage devices. The crash occurs in mm/slub.c with a
> double-free detection, traced back to blk_mq_free_sched_tags().
>
> =3D=3D=3D Crash Details =3D=3D=3D
>
> Multiple crashes occur during boot, showing a severe race condition.
> Seven separate kernel oops/panics are observed:
>
> * Oops #1 (CPU 13, PID 928): General protection fault in
> kfree+0x69/0x3b0 - corrupted address 0x14b9d856a995288
> * Oops #2-4, #6-7 (multiple CPUs/PIDs): kernel BUG at mm/slub.c:546 in
> __slab_free+0x111/0x2a0 - SLUB double-free detection
> * Oops #5 (CPU 1, PID 952): General protection fault in kfree+0x69/0x3b0
>     - corrupted address 0x2480af562995288
>
> All crashes share the same call stack pattern:
>
> elv_iosched_store+0x149/0x180
> elevator_change+0xdb/0x180
> elevator_change_done+0x4a/0x1f0
> blk_mq_free_sched_tags+0x34/0x70
> blk_mq_free_tags+0x4b/0x60
> kfree+0x334/0x3b0  <-- crash here
>
> =3D=3D=3D Bisection Results =3D=3D=3D
>
> I bisected the issue to this commit:
>
> commit f5a6604f7a4405450e4a1f54e5430f47290c500f

It should be solved by the following commit:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commi=
t/?h=3Dfor-6.18/block&id=3Dba28afbd9eff2a6370f23ef4e6a036ab0cfda409

Thanks,


