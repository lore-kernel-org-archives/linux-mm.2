Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4C0606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 03:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fV6/RnI+
Received: by kanga.kvack.org (Postfix)
	id 194126B03F9; Mon, 19 Oct 2026 23:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E746B03FA; Mon, 19 Oct 2026 23:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00476B03FB; Mon, 19 Oct 2026 23:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF0AD6B03F9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:22:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3ADF5A08EE
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:22:13 +0000 (UTC)
X-FDA: 85341556146.14.B4D015A
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 46E3A40003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:22:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fV6/RnI+";
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792466531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJ0jzd45ePDV29eKZJ4sBGXJjhUAwze4eIfc7K86wG8=;
	b=60nYSROOSIs7myQey+wrV36FNdySmbVMYeaQhmd66d+BzheC9gY2z4fd0vOdY3YvRHamHF
	NO1kskV8XBuJ+sIt/IwiXrVJMz0aiYH1C9gdA58LV4YuQKas272aa8QtCORrQkpKU2/vxk
	1yONLvtPHkLF7d7d15KDutnH+59luWs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792466531;
	b=Hq4L4sPfmMy/Eufdu+3hrvPhlk+qwYgIT8WbMx/W0cvf7D8Dab2k9Ie36znFoCuQ/1laj/
	kH134QIevjLOachkffi3LrzX6i/ee+Xn1vRXbup1DlHyfwL8jyKHmJKT/LVZOxXxVXEJkQ
	gDbgmBovF1Na+ExDIna796HgWmtImiM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fV6/RnI+";
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a1df4c0966so1385315e9.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:22:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792466530; cv=none;
        d=google.com; s=arc-20260327;
        b=ShTlJQky2bMoePBgH5xXYNj56echRWtnP67kTXdtpnnKXKrNtDCJTk8uDE6tnETL8I
         JAFNypwf+yA+D3wxEN46Nvl9tMPDWHkUz4H+yJEaNgmu3St3lh4DpiGGXl+e9y1W8HzH
         1C6/1UIGp/jtNGY578skHm6uImpxr6ckG9OfoipUp0EZBxoOfV8i4PRFOv95uRF4THTt
         CzeZO6eRZx690Y9xYg6MiJzpNEi9EpTaMjvg6EJZpiY0FCN4I8mT1dGwerMwI1veYyu5
         ewSmG2z6E6C87gEh21mEXQN/agbz2LCIJGtqPc2k3fjc5FVeozfPduZo5m1EoQ1aR2X7
         I1vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GJ0jzd45ePDV29eKZJ4sBGXJjhUAwze4eIfc7K86wG8=;
        fh=A49HW8PKEBTlJ3n4X42gmViquWoDQusgOch4REaPwdI=;
        b=C4Zk5V8ZBf7BNNIrZ9TcImE9gW0LZ7fjC1ZPwJx/rEf9xTf0tqeuytCAtZzaaQeJ/k
         GTZZ86LqOe0k6nw2h2gQJhz6LATp1w8YDtGmCG4qUZxnDmkAtZJHDRygwgkfoEtDqsr6
         v68oo35OeXWq5lKZNCnRYSAUnGhbvt6gXaRybjiyndqp+a414SmbjkWLAXAr+jN1Hcae
         fSome7qv8eoWgQNzzEMX8rwnLP+LlYFBL/guz3fxBaVznBZILmaQRmxaFJthSPi/bSZU
         bufLRrnINRA0JItkLoh2sKY2vqSmNB1o17fE4jJNcO5/d7dMM97myazVTvbEDbxDGdHD
         cRjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792466530; x=1793071330; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GJ0jzd45ePDV29eKZJ4sBGXJjhUAwze4eIfc7K86wG8=;
        b=fV6/RnI+i6O6cfo80HGt51tNDPrlyw+bVTJS6oQY+YSTcu2XScGz7Y/avXWa1wfdVO
         /uysogWc94y7z8mskpZtHcWrH67QytZKEKfPp8B5XES39u2yy6s0HOlAdY5K3lPu43WQ
         FWS7pmYeQaN4A5RCPLSG+UdEIVnSmMLN3XkYmGO811wu09GnDSgkaL6CUDf76aK+ksxl
         aZpzHOCaMfU9xTdQ3O34hk70pUmBJl+AOVdBu87SLAdLgPNmAPPiNERTo+jkvctJP+jd
         WMNVuydRNIPx9eB0xoiBV4bHh879xu+gRL65T+uW5CHsM9cOrrxQIFcBJakYip5UC+Wa
         MONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792466530; x=1793071330;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GJ0jzd45ePDV29eKZJ4sBGXJjhUAwze4eIfc7K86wG8=;
        b=TPxc0jUrMKwlejrxQVUGvYs8MECQXmiEg+Ws9qVfwjL/Unbj1jPZs46Tnwh0YmCDf4
         u4UXPL1m1C7rDetbbjDFY2o7sKSzes7UUCj4kvZ1kextJXT4M/7sdeM1CUdvVRGSRuMp
         JFbk79+IUxK+R/Sqv6XKyEu7b5fP5c4L6GVSSZ6uSrMu0C9AW4wjTtIdrJGfX7WBPSku
         cbbvhJanRV0rN0NlmXg9mIxLS3kcBl0Dr2jfmP5FKbs5qyut5RD6FvFgrb8DhcZHPDsj
         zBGDKkrHYgQhNfQVnyZou5ecvWwP62FOhqjm5Lg40IVfCWKyrU4WXNeNPDK/jAx1mqKx
         muVA==
X-Forwarded-Encrypted: i=1; AKwUvBwYJkXinAHfOlwzu9kpDI6HKh0WX9iiLXMIYQCmv6LfRoxeXP8wDrYCR/Zzc0gCpNXh7ft83H5vaQ==@kvack.org
X-Gm-Message-State: AFq9FYLrAIR5kAbWq4K/DBhItC1EK+swW/5cHCljylGtFvRcXXmqfHnI
	nihvbLZfZP3kbqPnR02CeibBXvICiGfiC05XDPAind+pKTSU/jrMlN3Gbll+k/RoRCCJGC0UzKE
	ukfPeJJ/0G74Oq6QhGhzMC41sGz7NGwA=
X-Gm-Gg: AYBFou0g850WcgqLn5o86VsJyzoBje9xVWUDJCB7B1QrxZnD+TvpENmGghapiem4spq
	/rJ53UNKJKIn49Ut4V5ZB29AXOsTVHVzdyNEWIHtH3W+CNz7fGK7TMiz0gqTUXAVkkDMsM163qa
	vuG9KPxrayq/kqpC+ntqBceR8rJgHel760gS62NqyYO1gYl1Sp7Pa98LfKFe9F4LD5Q6gg9TkAq
	ENS9wkPeqZMslDlARpVKdgvgd/iFnPUm9w+tYBATC/UqJucvW/b0p18lI8iaohtrPZbHt+mzF/6
	inDKomyA6021q1H88xlgP0P6mZzxYMFpTHGx9y/43Z+Qc/VFlJZYieUciF1ENGahBjKtqZWB5zC
	LokAzhgCustEe
X-Received: by 2002:a05:600c:4455:b0:4a1:c6f5:2450 with SMTP id
 5b1f17b1804b1-4a1f50a260amr15362205e9.17.1792466529668; Mon, 19 Oct 2026
 20:22:09 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-2-0f00417b41bc@gmail.com>
 <20261004083036.613169-1-kunwu.chan@gmail.com> <CALa+Y17BOR0DBLS9-vns2SQfRhCueT0f82XCVojHhg9uacOX+w@mail.gmail.com>
In-Reply-To: <CALa+Y17BOR0DBLS9-vns2SQfRhCueT0f82XCVojHhg9uacOX+w@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 20 Oct 2026 11:21:58 +0800
X-Gm-Features: AclHuK8qSfFyajdptQhJ0NGpKFtfIDqK4tiHr-fgZMp9gM24ujXx87HbJLiQhf8
Message-ID: <CAN_Opa9=5dqD7CUpczUAz67HjmvUYE5vLMSgSVqzcKLAcjVxng@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/9] mm/damon/core: replace the access report
 buffer with per-context rings
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, Wei Xu <weixugc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Jonathan Cameron <jic23@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46E3A40003
X-Stat-Signature: 6hnpoqj5hgeouir64txzib88b87qbrsi
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792466531-76179
X-HE-Meta: U2FsdGVkX1+zpAUhgSLg4nGX3/XEJv+K3fPDF978biquMgddP7+JTO1Z01wBJ4i6xINX/nJ2BVLAK0BOuapgL81oI4oZQBPCkoRv8ewESRHVTDx76wLt55B/q3iPWGPKNrjWA6FFs3ETyvra03JcM6ipswf/ieMDrAfKdnetdfVqVRAT0aKr8a+XEc4d8Nb67mXLT0OpipoRr1mLxYi80NjWYaIVv34u1DMO37A3IRtVKcRwzkSU2rXH7tjBGn3WttLxtqyndzPt/5OsjXnNbULQEdNujRkoO8IwQ1Vj5X0tOp8q2zcMb0obhWa6FGl5eoO4bGjQJzFuGoI9nlzN/4FvuQXph4bnAnRxYpyNhul2DySyxXTEDa2249G7ydToCeDDYSJslP1dte/mQt5UY4SmNPZfePB2F7u9Z5dFkTz4K7Y/DSO9xxWaefkNCoEzSgZvJ9vHjOUUdqHQiQdGUhrfv7zK88GVBxZ/IdfiMvO/GF9418TRPjcXrSVYRqnGt/Tkz5taMFe0GgACi406Secx5Y0333/xVX/CQFADVCNZ1JQXAWsZgJC5HCAeCPJJS3bjp91LPsH+wJlkgCqUWq6lOFo/AmDYRpNZ5Ei8eEOG/DxFRCyDJzRTHMw2N7nKWCk3Wi8WSkBjLH3IavdBwT9PieI+e0aPYM1hAEtEwEfw6ePOyKnRS1Vp0Lrn9JjAZWDZNxZ+esmTlruoZHFtTtvN+eW+vvXOUv2ZpUVtl9vRjxhCqiGAgb9FG9UUErIEJ+xsh9ZOAR6/3eWH1FQuCVfcsg16D6PeC2GiI9WEPVLLne7gidCzQFVMS8vvfkbR9GT+XkBgzzy4LmFEj9f3vH9JbRTsX8y9XxVkXYHJrnAwrA8XV9i/4yNJ2+jKgONnINQF/zMBaXtfaDcZqkw7ME0uJLQgYjR95zilkl2ePBwO86QEmckOISebjP/t9qIeigas+zafD8rdLuDRoin
 Nr5+5LXV
 pgcKeSG/eT3qlhaHDzNwaCzeuOLKURDfw6mzyRJT/412XMHYCPnugeN1oNyNHaGHNVYtV/+cKBI97om3mbMqBlE7WrROjtt+KJyr6F6Q2hFZkfaWUXJIxVITGkCgjkBtJCQXUXGRLIFenVK/NAKzaYfrP4IHe9AmvlTzEuDGZYr54IXWPxg6RNO6JkLqZmOBQCC3Xcb38mRjIJVyQgb0I8rsAIAW6fvz7jaJsq1GCx8ScW8Ih+TPhnYbPRyO4TFSR/tD4O2I2vG3SFk6YHYg6xPwT2ZinwF4ah6NsMnlQB1JyPZPkkZkq98T9897YNJVJvJcxp4ND/lfHHpx9MTpqdKmGFL9XXjHSalQJWXZq1xjbY4CqKOqFvfwmRs7HpHxjooVa+jNrhsZRvomRUVPQAoa5PtKKL/Fn11CKPLukMs0e5JKw2IiIIThH9dhFuiQAYN/dbbUZgvfHieJhZsVQXtiqJ+jWbbOWUmMLQg2IKZlpG+xx3IKs25Y11crDvRIJecb+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[...]
>
> So in v4 [1] the drain no longer touches nr_accesses at all; its scale
> stays with the access check primitives, independent of the PMU and its
> sampling settings.  A sample instead raises the region's probe_hits[]

Thanks, Ravi. Separating PMU samples from nr_accesses sounds reasonable.
I haven=E2=80=99t had a chance to review v4 yet, but I=E2=80=99ll take a cl=
oser look when I get
some time.

Thanks,
Kunwu
[...]

