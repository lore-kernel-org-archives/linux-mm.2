Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C87B606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sd2We4iL
Received: by kanga.kvack.org (Postfix)
	id 889BF6B05B0; Mon, 23 Nov 2026 07:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861B26B05B4; Mon, 23 Nov 2026 07:00:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750876B05BA; Mon, 23 Nov 2026 07:00:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 525D06B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:00:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC00180856
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:00:58 +0000 (UTC)
X-FDA: 85466242596.28.72B8B3A
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id F18AB4000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:00:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sd2We4iL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435257;
	b=DQn2fftvvM//zt9jWz+Q5nJUn7Pfo/dSiJgS1h9jLZwmGSfUeSUnByfSIFZP4/DQe8jK9i
	0cL33P75iW7UjPweVwmmSPuRUxqQk8DrHy9GlXO59pDdoU6oLB1ub+DN1+yuV2n1MdS4Vc
	HnHjerUOnO9avbHwHZXkwZ2qteT3FyQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rp6FcotIUDI6/JIrdYCjFGnaAeSHOift6cwIe2xtLdU=;
	b=hUgYQKETLxuhYINOV2OjI0QUlV9nqXp3FLoAC0/hgG6ej/9O962sK0mE89uatvCRzGfXC/
	SiSvg3zyZuRpz1VX0T4w0rV4lxjZgso4+yekBc4UaLq/a4meXQYlAxqTYfBcPx+8ZPeTpE
	rG256rk1TAAjFBT00gxj04LZ6wJBcB8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=sd2We4iL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-36a315ed211so4088948eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435256; x=1796040056; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rp6FcotIUDI6/JIrdYCjFGnaAeSHOift6cwIe2xtLdU=;
        b=sd2We4iLaQIB7XB1y+YllvWF9Xzusy1tzlgjyqkpMGaVgkjo0rvj4BpMKdhXnevvZk
         Yr+A2o6eDpz12+hVmZ+L62nt/7xdyaX5vQmQ4swuzYlMJWku2yGMzGlhCH7ti+LWO7NW
         KMllPIo/i4nzSVVmqsmDpR2QVzkASmqGMI7wxfr94ybTwig/D+zNlUNydyaBZEfNnmlN
         LuHcAi7iBdia5pC45S/+F9Lo4rSbRFae5gRH2FH2Xq2LdID2mhC9XKGQwHLybt7oSQmW
         a/v8mXlanAl+Ue4V79BJRYA9t55/l7mD8Q65svfjFgGYda4/rIXOwNBu6UYNJsBmf5r6
         xizg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435256; x=1796040056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rp6FcotIUDI6/JIrdYCjFGnaAeSHOift6cwIe2xtLdU=;
        b=GF01b96Cel/susvCQcSkgY82JMvOf6JyLrQ6HYjT1Ps2dJuEJeSD08PwGvwHc7A091
         qUF14f+d8bVyPODPgANT/r2bHiU7W2tKwPCcYjdGvIFODwLg0fgFViNfP8BqLVqRO9wj
         0LSlTLIic4/C+PzwrrQkpAO7AptOoF8c5I4/ST0i8ITlmi4Pa8/5vmXfsvSoCv9vKBXB
         h+XhBZTDc9EcLsimjWzopk/+9++RV6VUemoSbDFSbqYhajc7tiKonAo0ZwCFOueQydlS
         7K74ffbrS1PEMkBqd9ZmIGRaATb4jQ5nb43/DTwhukice3RE1ddpOIGB9HnYm9s4qvbA
         Zvcw==
X-Forwarded-Encrypted: i=1; AL+hErFk2l//zXxFbE0kEvM7OKe+dcKW34N5kosTAHuWRlEUWlUOJF0+AELBgnmsxos62Iv8b5U506M+Vw==@kvack.org
X-Gm-Message-State: APuU4Z/evGRYU33dvAl69gWnJGpmI/KeYJx5Q3qGftJj1rHFeaHeFk9c
	c17lN2xKMKFx3QkYNsp3Wry8ojfwMdXzp1qcpPGwr2WECt272mh3YX9IDT1yG8OCPN0=
X-Gm-Gg: AZFdTZeEibEWll4kbe9fEOOF6puKmTAKhjnsDgVSzQWa3RWLxeAW8DxLyxNyAcWC3QQ
	TaWsowBlhP/2VioN9s1ahcpGV57qXH1sIsiwqnyyRCwEPy4+RDVcG7i7HzkiWob6g3Taqw+J9Xr
	mVy/UM/DSZtt/djKQ5w1eqxPjXN7mlwhuZ7/Ko3oF9N5KPy+9R0jA1xD2Kip3MmKz3Ne6XwHcrI
	9Ng2nqeP3XbGqI8yxfB5XhQJ3+erl9Am+ppxw4G0Q9oaPB5M5zcEDKFjncP1EpJ1vG4/miqAXm4
	IPEmWe3qWVu3PBOeLgnuNbMYZG2k8duazyFxl542EAS9prQBCViiUBLjISuFZqVhChB3t1ipcy2
	YEfwJs2xvnyhnFZ+YhRw+7gHyeUcLJEhSYbQEMLDriSTCRJ6IMVO+hqiV8SsRsPkhA8pOP9baa5
	WNnQRValOUHXHY+5dfNPmzWrqpMySmSjF3nA2GOWWXXyQt7TzzPhdHPuL4O3LjWbcGAEPdV1sXm
	HkdPNW4dyGPwNdJau0KDcM3Ej+A4NjfPeoZzTPB/pdD+y9vexZ5TxcFibQE7Z520aHrg83I/eKj
	OxR2rdZkiN0jXG2EdpyZ8YxhxahqFNddUt7J4WKWq9EjO6saUH+Z5NoNuMlj2p9uOZUf3XsCe0+
	5jV0RHS3N7UmFAg==
X-Received: by 2002:a05:7301:6482:b0:386:b39a:883d with SMTP id 5a478bee46e88-386b39a8d30mr2312894eec.0.1795435255730;
        Mon, 23 Nov 2026 04:00:55 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c371esm35541692eec.23.2026.11.23.04.00.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 04:00:55 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 15/27] mm/damon/sysfs: add filter_report_type file under probe filter directory
Date: Mon, 23 Nov 2026 20:00:36 +0800
Message-ID: <20261123120044.9172-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-16-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-16-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: F18AB4000F
X-Stat-Signature: gejq8eipoh634hsybxkdga5sw7h395zw
X-HE-Tag: 1795435256-598293
X-HE-Meta: U2FsdGVkX186lhxCKcQMj8Fk/1LAhvRVZzziWJNalOs8oEIMrphmbqAjtL88P0vA/YkJkMq6CIXijWSFFzmUyslDTtkQLfXeMLsXC7yCNF9kGkAch5C1Sm8PDvg4qCAaPkMtm4geue8O3+EBGLiozwNbuJuiUdwViwhNzzdOg7CXSTmZJZnhB7qrW6i5va/PO2XhGHuiZ1ch9YEaBQTO9u23obmc90xU6OpUsMTcL/aTnqhrbMvuhDdCq9ncVrhZ0lXePsGBGiK8XmXyg0TJY9RBvs7AV+oDgmNqstPAJCWVyk+Cjt9oaULWL0XmCipePXnK/hLYTqXHtE5jgnGaE9USN0aLYlY7iPby+w3y/E55y436qm4qnlIr4kDrULOeRSfbNnrjEgIkNRANKTioo9lKia0J89mfCTzT7evuswQZEYC/EnHKAqH7tAhz4qCyDK3lcKiveZPn1eJCbNW3mV9SF4pwousgeMGv28gK0ESD8f/9Xn+G9En2qaRkiyuziaHE4nn8Ex07M3k46o16dYS7GZyzgGTJV98R6z9CzTJm/Kz/OMLigN6bSXV7D5+jBwLcyEudqgtHte9kOcTOWXQjWrrFI/nQXenU4rYflgQaFxKK8dbQYibDjrh3GLOEHMF43LUD36BAGKhoQxT1TEPjStGHnEenoDzg4qUGWZ6yLSdRgNemssWyAEWVgCjIYR184EePmJS24dQF0FEIMaf2LTQeIpQLkOknZ7otYQsGKJLv+JYm32fbCLN6gRnjovOvfRNoKzsdaKTBQT/rY71tObBurMWwSYk7kyPP/NR780jDv2Ui4CLZxKjFp5HsRIUdWoDcrqLzyJZbN/dyHuXT/AjJsIQwKVpZqUYw9VtjJRRI7F+MOAKB1kd1G6dULFG4n3jOc42Nlya5+hOHn/lTDG5xiwGHueC8XjRdlQ4VSdRg1CADRL2X4eJOv+FSa74KVcJbC0APuX2mVPd
 lNui5gPM
 amiJfPKZEb0MYMrPcD+zMVoyzu24A6ZoR2gU0IL+xzcZoQy229WWWvhJoBCGYmymmD8mzVDZo2eiokx254+4tYsldprdSTxsRb7l6b8SnK65IHU4Uk36Jas1a8QSwKcbJl7E80ZNFtTzYZCf5cNKpv+mqgkIGkw3JmRfhz742XfL6HcN2p7wivHjslAqIty348NcZW9VeINTrCp9P4jk+jaihUHbP7rqSSZCrn6fFcCSU9C2GTZFoG0yVPx4BCpoCegDdmnnPrVrcK0vqOH1rgwRMn99UFp1yjhWtpOqMPmoKKl8QYds92qXDPP4B97zKkbk3gsoYGJbTjO44OrZ+B4WEIoBLPX4u8Z6oGeVoZ5tMrE1hXbze7kgU1nAdIXbJxeZdqzI2M/UOq2zDmrCSr1qiC7c340ob94wmzBR5j0jATiBR9Bte7MJHsCVb922WMIjPmGMV2grX1qWl94URGLZSImAZGSjQvvlcl3gA2Emg8JFDhNyd1vS+xbgrSDrOiqR8EAQ3KfByrYS0jJmZNmhLmlY55ybsewCb7hcINm0teL6nz16ZK/Tm7KekQbtUyCRrG40AICpyNuzJqRkPD23SSx1mYr85QbE6tsqjr/TMCJ3BQHzKzlrjj5l8J+lrrg62stBJGUxGzopW6xa3E9uVm4YGR/aj9vaNVKRzPsxbJqaY5TjKVNwPJAHPqSF8pe/+mPWGlUaEQeXztLqZVUvYsqjsWe4LoHnwlJpQA//9e74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:59 -0800 SJ Park <sj@kernel.org> wrote:

> Add a sysfs file, filter_report_type, under probe filter directory.  It
> receives damon_report_type from the user.  Reuse
> damon_sysfs_report_type_name struct for user keyword matching.  Move the
> definition instead of forward declaration, as the code change is small
> enough at this stage.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

