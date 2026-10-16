Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 467D0CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 13:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF246B0092; Fri, 16 Oct 2026 09:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470376B0098; Fri, 16 Oct 2026 09:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35EDB6B0099; Fri, 16 Oct 2026 09:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 156186B0092
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:48:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B0F01A045D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:48:56 +0000 (UTC)
X-FDA: 85328620272.23.0E9E4D9
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id BD3F91C0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:48:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FwN9ovKl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792158534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5uF+LfQczF3q7pmbkjozwjBwMdX5SJot+p3Vd/HXF+0=;
	b=XqNJ5Q6mjWscdPcV0nBBgVJOCTR/JLiF94cqzAgjTtYnRddgXoO+VD8S45fAlk8LKXy2Ho
	xF3NLDAsHqTXsn0YvxNORVB1GXsuX6qw2/DEadmUHfGBO9l6QSbAlLckFcCczbo+MiUbMf
	5pgRFWJziwRHfDafnrT6o+3qNjJNnto=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FwN9ovKl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792158534;
	b=OOywTCXa8aD8WhyKvDIVyBI00Dn1HI1X07kLC4gUpHrW4gCTBhkVRuFvfGmoz5ZN3cAX2c
	rdiX77RFlfbSF1Q7ejyS+yxGCE1xP38yETRgb4Un1HXY3PgfBce6EzT0g4mE/c37wQiiIi
	YNuG9vJfkI53UU1WoTaCQeewylVtsSU=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-144f79153f5so870609c88.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792158533; x=1792763333; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5uF+LfQczF3q7pmbkjozwjBwMdX5SJot+p3Vd/HXF+0=;
        b=FwN9ovKlhgasLAOHF39KP4V2UBZ2NsBkiZWuilxhtU85Zxp0a2yCjUgCtEhJGYgmc8
         P5mtUC8X6uOm1rt0mZCw+gLojZS6H+ZZrrd38uWHlnIn0fmDkDUST2Y/TxT7GKW3Le02
         DlTZuqZ/ZLcWTKYZiBKRjbWgjaCRAF9ShlEEj5SNMhw1VlSJeJcCaOzQ+OPBrEniotUe
         f4NOdh1x2DPeEcCZ78CehWPU8MKTdiEX5vlzK7Vb78Pz1GLdgl3TCl9AIamlr8Kjq5zD
         MRw94ORNdMoe6rGVvauv/sM0TSvHlycYGN2ihWHLtyZrGDsuwZh+S83l4N9N56aOzteB
         1GWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792158533; x=1792763333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5uF+LfQczF3q7pmbkjozwjBwMdX5SJot+p3Vd/HXF+0=;
        b=vyC/P50YEmBuFEQbsZhU436wMfKV+MrO/jcCiOUXXGq45CJSKzeJDHGGKY/Ivy5fan
         z7LW9HDlgUEPMRgzGurd40/VTIxeS4m2GGIYlysyDcvjF0r1QCbsl/Ux38Higmhzuoxn
         HIdc06Dd3G9HWkdAOA4iYJ/hg3KAVCtephZYbDh8fmu3mIezbgYiBRxj6pDab4XjQdPO
         2SkuwFXs5tZ9Afk2JdDGydKrQ9ATxu0FEkPM/kPFQsZJ8QwYZoCflyolAtUtWW6escye
         u/1q77pE5rObcmeKHnLGJCFwgpnsJ/AaKX9Jh6PyqGLsrmgYpGXvhi31wJF+wi5TJjYX
         2qTQ==
X-Forwarded-Encrypted: i=1; AKwUvBwLes7bTlgrAo7RkLjfxm3MWwMwRB7X6toQnAU+kiA2w2Imkmq8XxWakNbeQDDUf9zBw7fijsYwkw==@kvack.org
X-Gm-Message-State: AFq9FYILCE/pjjfbxIBfIS7A5vUHYjPbOB0gApeSJ4+GV5Q96ticMSnW
	k5sBJ6ejs1uQMTaeMkfaWLvwgsfQzk2J0qZRuJuXeNEIjPlQYG6VZ4P0
X-Gm-Gg: AYBFou329SfUuzreH6ZNj6w9EpcMINehIBB7W5JfDRZTO4eJ2xDteitwTTAY3tEqjqW
	4Z1bamA5iiB68yDZLLyfcfp7fZKI8Hqvj75WXejIgf3lUWufw/quFM0VpYIK7KtB74RBToZJJL2
	W3HXcKU96qJSJe/LD3en2WkVuT+qscBqRcYAjkR+ldiKV5br0Agi4j6OiFr/IAomxm3y8FHSRkw
	ixg3PzYJ5uNAlipv6uld4wFo+zX583hGSsenvhgA6//wx6gWJ5caM3xhxDcvHrtqTcAgpCiAvMj
	BgYyXYFiucaVuyZ3NAjb8WuqU5CebFCRNDDcUEQ7ejbAOmn8Ra4QpLdjdtebGdsqTi2mBHdxSo/
	YzyLjsEY/DjG8IT82ht6IY5L/PzQcZo/8RWM2mOvj4FgNMr3OLnowe0g5E7QoUY2Eayt+QQFaUD
	nvZ4tyASDMi3QdoaE5b3PryQVaI5i6NMbsBZMWOfEejMZoNLXOXvWYuHVWt9991fCysua0wUDtM
	qAdGhMSvZjGdKxfG0wGerl+lrVTypvfe9azOmIBlVSx9mfIodHgSFAWFPXbbrOn0up+gkIvg3g=
X-Received: by 2002:a05:7022:43a5:b0:152:dd1b:4fa7 with SMTP id a92af1059eb24-18511eb69acmr15578c88.19.1792158532965;
        Fri, 16 Oct 2026 06:48:52 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831919fc14sm7956376c88.6.2026.10.16.06.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 06:48:52 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	bgeffon@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Date: Fri, 16 Oct 2026 21:48:47 +0800
Message-Id: <20261016134847.1620103-1-zhangbo0325@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <atHftz13hWzGludk@google.com>
References: <atHftz13hWzGludk@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BD3F91C0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: cmhhgu1butyusmsh4sbs9wwpmek7d71p
X-HE-Tag: 1792158534-29630
X-HE-Meta: U2FsdGVkX1/yaYU7lBC71t2PJ6KSZqW1+sPrgEYoFGjqeJWqGfLaQBnZqls2NwrHU3YhrEOvZ/i+H1j0MfDWWK9aUZ/kgxWCv/xjixyf5NKscj675YPAFHxbrZfPelX+EemWB6pzx9XbTHAreSCH3QogzFSYOmnZjmLJHi0XN2wBXnH/mkjFFTpi+uUtER4UdT2alWFGBUqj9l2hay1gl5YuoTcgYgNMvALeEpRK0BRHx/2i3oDqE9Y5piEc1FkrvCHwxZhK5KdWWK3hPXKAf3CwgjxehqJMhO98XToYBkmVkF8F1zjT0bs0/PC5fx26OQjbPatog1E+aiR2OJWKOQGwL2YUv1CSAPGtLMAq6kZ5Z/qByc45wRKfmMSG7etwbNGjo6WCxUp2WSDQjTghQvU/Dv773pKWwwp7h/1JB08l1O713za002h2H2KD6sH/eHutkmqhNwApVgNZk7m867SRZwzBRYfR8Naj5DM/+l0jXBW7rIQ6k2FGmftBPnUtBpRgyrKR32iqy3oVAOSBwYnhwinQp1IvCyfKQelGZCymR/7TEhMGroOahDnYe/ZOrlNAQEhUNc7iRmHLQ8gR7mLvIn5CxS6TF4aPVhKTzEM3VCi+Ht/D3BCF8F0tDBE5EQtiIKj9yYcbJx31d+xjMh8l+HNelmTUyCFGX6486rIBk6c7w+YSznfjl5Xp8IB36R3DZiR7LR4rg36jQa2jLgjGKF/Q7ebHCeE+05J3eu3uIEGS6G9AbqktnH7ST6BNV9Od+BXR5BsbiM7KTFzACsmyCWJeEZPsiW0DQGFzEagD/nshQq5YgGsZA7+pcB6EUpglUA7MbAgi2OW8YvYMk3kwldXb5n4USVaBFniUbtc9XxOYwBt1LQLkyP3LiPkqb4jN3vJJsSmen5RfJhqmX6Ku9P27hVDVxadjzZGdIGgeb7RCs1Ho68zXdLbfJkxZzxDBYrDIyLhMot+bSgU
 OUOflMXX
 sy0Qc7wHXDjJa33vLwjVCTUlOQ+zdobYSr8U59E/9XtMFn3tN56bmiCQSKaD5HKo5lJ1tw+MtTKocWmilrngtbNBhCUPZy0FZng/nRDaxtx+HiAVlSBfdbt8qRfeesElyYmPtjO7Sabnj+8GoXHPm2A3erFnNPjyAstiepUIfHIAwPKrsKcRS2zpCpBv40JbmMEfayyvb4g9wRtgAF59HsWcyY6bIcctqImFLc1esywONgsdX0YAx3YLTWQ0MH/0WWqcPb2u/Al4xSrErObNSql1D77w8npJvmvwcRFKK50V8W17TTjiJ20MOOeuVwZfjyVXO0ARsMBwBxQvN3AUq/A158SKRGG/M2fRI8WUVnNNF3udJoIs9vkoS/KtCBiBdMoL8uZyZgV1pAgDOh73tJr56zD7DM3MqGbu3ta/PggsKFBytbVlIl5GDQ56XwOJkLkRSU1ohjZgfYic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Oct 2026 17:54:25 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> A quick and dirty patch, as usual, just to play around with.  This
> attempts to improve the reader side, because the reader is side
> much more sensitive.  Tested only with zstd.

I applied the cross-CPU borrowing patch on-device and re-ran the same
zstd Android A/B, so it can be compared against the preempt-disable
numbers I posted earlier. Focusing on the read (exclusive decompression)
side, which is what this patch targets:

                        9+10+kmalloc   preempt-disable   cross-CPU borrow
  dexcl_contended       15,919         54                1,447
  dexcl_wait_ns_total   109.6 s        0.68 s            3.66 s
  dexcl_wait_ns_max     145 ms         34.6 ms           26.6 ms
  dexcl_avg_wait        6.88 ms        12.6 ms           2.53 ms
  dexcl_acquire         2.21M          2.75M             2.94M

Borrowing clearly works: dexcl contention drops 15,919 -> 1,447 (-91%),
and the residual 1,447 are the genuinely all-CPUs-busy cases that fall
through to wait_event(). More importantly for us, the worst case and the
average are the best of the three - max 145ms -> 26.6ms (-82%), avg down
to 2.53ms.

One note so the table isn't misread: the preempt-disable column also
disabled preemption on the *write* stream, which is why its
cwrite_contended was 48; this borrow-only build has no write-side change
(cwrite_contended back at ~16k, as before 9+10). That's expected - your
patch deliberately leaves the writer side for later, and the writer
isn't on the swap-in path, so it's lower priority for us too.

Scripts and raw numbers on request.

Thanks,
Bo

