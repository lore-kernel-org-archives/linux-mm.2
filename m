Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6AF1606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ldGyBC+E
Received: by kanga.kvack.org (Postfix)
	id E5B886B05B1; Mon, 23 Nov 2026 10:14:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0B866B05B2; Mon, 23 Nov 2026 10:14:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22996B05BA; Mon, 23 Nov 2026 10:14:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACF5B6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:14:59 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 421C6A8618
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:14:59 +0000 (UTC)
X-FDA: 85466731518.11.87A4DB6
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8CAF91C0006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:14:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ldGyBC+E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446897;
	b=QN4kGwbYOrw0gtqpCCFjco9W242ZWgiIB2KRJaOMgoGdAIwQxkhc1crc0nMOaqm76AOoaz
	9LffXihpB9TqCHRTji2CkrNg+fX5Gognh89ZAg//614wJQvOBHaXmoaFS3bOyS8nuLUWfD
	LPjeEM4Hc+lERuNSQtXMWLkeDRIH728=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:references:dkim-signature;
	bh=L5M3f6tXuCeudVEXZHMryiVzKAWS6njMK2AQVRvQJEE=;
	b=3z8n0QMM6LOEwZmhzfagi8uy7dBrEDnfL542uaUs4WRuRA8b1s5vXHh333xv9KjaszS7su
	CByj/1TlXXmDVR0JGdlZld0ORQxX2JPxXa3hBIjLtUPyjo+imFGWkl5dV9M1JmcKdMTXiy
	XSMGRJoTh3a8eF5fJJ62idvBWPJs9Bs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ldGyBC+E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4ad6219f7d8so2722644f8f.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795446896; x=1796051696; darn=kvack.org;
        h=in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L5M3f6tXuCeudVEXZHMryiVzKAWS6njMK2AQVRvQJEE=;
        b=ldGyBC+EJIt2528LcTGjsw8IU1m6LuBgKlr7LzqCRTZTzH9pJ/geOnPppSUgnieJrm
         PKhOC5Qg6bXyhs9gkdjk9S45edIbbjci+gaLQ5Y6ZxpUVV5KNZSDt3mlttTPiVTuyKMr
         h/W2PP/oZqkNfNnRgwI4/ZlYvHuu99AZgB23xybL+ggqX9w+0C/ooZZ77rVPXCirTBfu
         7YltluSZoFdCBlJ6pirKhSIZ5dMgu3oykqFPIjAAxKe2K+3CMzrD9Eebz3J9fPoQopni
         t8/uO1DjoUe8IbIrU3hhRlGo08bv3rXEFy2umuFFSjmk1m1rAXh9ktq9USCljHRMwvma
         6W5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795446896; x=1796051696;
        h=in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L5M3f6tXuCeudVEXZHMryiVzKAWS6njMK2AQVRvQJEE=;
        b=ZSDjeaAYGii8Kjsiu1LOQTwm5BJ5CXUE3hOTIA0GQcvZBQzvRu8Avrw20K18gbyZIb
         OAdnW23mXZFNckzeKRfIAd2a81hIy1ryrwI/5dql8lV7k/oM+zHifisQLB+N0JpI7awc
         jhlmxV3CohXrY8PPwg3z72AiNzp/ai7ZZTwTe4BGzAdEwN723LndDnjJNE64RlGnvkpt
         nMZYZ9a6zTxfydkmrnjyZq3GZReZBKLQ+bJ04D/ClXU/Wpl6OyALaUVH1E08scnMMdZF
         wuDdiPAToQCDgmMVGXGZS8/usE9BOpKKGWzo77h6eZ2nsgGyIreAMGqAQmHhuq2qHoq9
         UcKQ==
X-Forwarded-Encrypted: i=1; AL+hErEh7ZiKn5Nv/vY5eUWCgrQ4YNYkLwDUwCVwWslqk9aMwQGJOYJdc9q2vpz/5sB4sPJKzFWVrAgTbA==@kvack.org
X-Gm-Message-State: APuU4Z9lBqbIxDwXHyYTPFO29ef76B/tB78XLZYSDM2MURLGJqtzUa2t
	XNn+Grwlg3VWKKojRcR33NcgDnXOHdN0Zv8m4RhYR9gY6AC5j3IVaNr8
X-Gm-Gg: AZFdTZcIA5bX71BYSK01bmFsUh2ILwJg4ceXPLuTZQ1BKEDl+2p8m09h82bhs4zOjET
	TfqrxJfBYfprwYxIRNL+TYa4NHd5+unSadjQesPf1Ip5CAwd7Dlq2gzegcVHd1wCLX8yo8cga9O
	qr8gMp2aAaGO1z4MdSGpuP01wbjju6S1TRAwgmClLF5JHBuMKOpluO9s1338yId7Jex6v1zKGEL
	nwe5/4Mqa6lQFI4b9t0PB0nxEBLyZdhiy2aI8pKol4L9x19H79VqMOsbKMtBNt6aXBNqGEYL4Ba
	N0YOSI78+lk5nRzTZPQbhO0fJkLrWZNavFwIizMz6MePBvPcRgHUy2Zr4tMZ7FrDE+E5XiUjGcF
	tJiF8lzvKQxxgaQH6h1l4WUc40IKs6pOKOTITgVxoA6x2+QA2EJHTejRPMeXEKXApogrd+oUs42
	6l+oDe/MHVgWGoTeCFaXxQe6eqWRYHE4myLYLdzXJ0HAzsKIUC37nLMs+D1lMOb5BYU/SQs/Du4
	jaosu2JZ9KfkIjbGw6lZpTOKx170MCIUoA0R3KshaFTc/5alt7wfC1pAPc3e1KT6Zx48B/ffTDW
	VbE+FuPPBRGHA2hVsbBXRuq6KnDlzUoaYqu9CHO9Vr5iGF9hwIAbtmTTPa+I1ls0PAfWr8hcYzn
	07qI=
X-Received: by 2002:a05:6000:4b15:b0:48d:df08:307c with SMTP id ffacd0b85a97d-4abb8ac0d92mr20304624f8f.44.1795446895827;
        Mon, 23 Nov 2026 07:14:55 -0800 (PST)
Received: from localhost.localdomain ([196.178.137.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ad644140b5sm19778632f8f.17.2026.11.23.07.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:14:55 -0800 (PST)
From: mohamedalibouhaouala@gmail.com
To: jack@suse.cz
Cc: willy@infradead.org,
	corbet@lwn.net,
	mohamedalibouhaouala@gmail.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] docs: filesystems: update filesystem type, superblock and inode documentation
Date: Mon, 23 Nov 2026 16:14:38 +0100
Message-ID: <20261123151438.47681-1-mohamedalibouhaouala@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <p7wf376fhejkqtke2l6jxwzytlhiiaidjdaeapw36jxukbk2qx@kyk2wc5m
X-Rspamd-Queue-Id: 8CAF91C0006
X-Stat-Signature: 1mt1etis5gkk9kwczpoyitcu3qe1sc4e
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795446897-816429
X-HE-Meta: U2FsdGVkX18QhtT/n+VjikQf3ku75Xhu1VGnLpa7fF9FAMcpCLxgrUutJy3V899ZyHxHMHe3WWRl4FqUyzIEfT8SLGbdLsrFCZDNTfhf99XFyEivpVjLyFscnu3ZdnCUxtTuY57A/Eqbh8H2XJZdW40/AaomaCUaJ0qmAGY8a/gAIe+nYmazB6LJzltSva2637A2XA5JzwTzjYwUdf8M5h+V8myY+KF4ttUEnVgebk3knqEsemLsYG4Z8sKlI045B7530gCYP19VcMnM17NctZGlvwDKdtnr4aTHfOziY5m7+oCpQppoFtcBNsa7t1kqUIsHrjs9XEPtGcg3cbDPOwGQOFPrHEoS0kHkZJnaiaZqDCjVlh9+pCFCDDRj4xzNNueW2Nx8CpPLiFaRbFTvXarkecj8ifzvQvEUnM5gQWZTpaSA0S9EV4FxsvEY+U7L4EabLbnuEqx5phldu2JREB4mBPA0plxaXk1TqudByLUyd948iwegg6Cdp+mMUCOVA2S5z/Roq9vMQgF3Y+yzyqhn0fOCelc4VwzusY/GxG1NW7CNnvXGV01l788s1igSCEedXD3Q1o7QNaD0RU4/IAretkX3WG3kadm29RL/VuM2Epysr6J09jEi5TlVe9VUFjYCJieCszrjg33dEBoRMaVtksuqR/dquJcK5e6TwTtSC2ZsYeOJxDuXMBGIQW02BR6ZzdJcnT5SSpMz9d7b1vZBlFonU+bxAJJiY9eP3WLA0Sg9B0J1HhoMyjtMycEJRNnSl2BqRKIVnUL2A9IcmVpy5giNe2cVs//efvoQRDspJf+QW8VkGXzr+1hfoEbg0jSDYvCu9arQ6MOUSU90C24ROF8YfLawsDtbrD+9DPCfdMyhhyL0hVqB0Y3kRY1jgm/FfYadg6Tg1aWuLfJd7m+o7v4+QGajlAFonEj3KqonhSYPIUqMMElZHqA0MmSW3A/Lu2z0QUwGSFn0soS
 Oifk/VoU
 XeyAoAyF5PtXUTcMUIENCKHRa2RVx1rClWISAesKzmnEh3Jun6epXLw9bk8IFmdqg4g2w5+ccExqEJ2iOMPg/T+nvNcIsJ5usoxjjB2cNV9CqfnW+ELPtIw49RkFLr+IRMSaqswICfP523U+KmqmvB+HYzHerO3pjb9InwOG+pKbBI0z6J+Qt7EhipPJE88iIuNeD7+p38wIrZPyu5JkQwteyfZTtyLSxgPcMbUwKJD7nSgHJLZaq/2mbDT6Pebo7Gf3OsTxr7e86Z8/I+Jg6eAngD8bpBs4LKp1J5qZkPCe9tzJ9eSC0noBBAUn8qAM1n8mXllN207lW0KWa8oDx3Nf9oGeHIMZ5MeVOEuXpIONd67ET7PSjVWTW528SVMIw9C3yw2F7wXNT1I4miEB1QgybI6+3lqfj6CuIZfsajEU02SPaurEOw/PbaPinK4nSK9xTlK9q8N6MJr6wE/mTOXRSxhcJH8TS/i8WtSNubw2Bk6PwEVQzIji2bvOwykQuhPdhrKjhF8CZ5d5fKGi29rGoUZDrekiV74lEjSwEp1ML761WitrUnOAfi0pcAA9zojLMu6hbd+8E4oWgFj9j6+RXcQSudOhiG9jvP9otpILda9GJ0UyMLL2mwpQgdVLibYf5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

hurn>
References: <p7wf376fhejkqtke2l6jxwzytlhiiaidjdaeapw36jxukbk2qx@kyk2wc5m
hurn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Jan,

I checked the patch against both master and vfs-7.5.misc. It applies cleanly on top of both branches, without conflicts.

The previous documentation work I submitted was a separate patch updating Documentation/filesystems/locking.rst.
I wasn't aware of any ongoing work overlapping with the changes in this patch.

Please let me know if you had a different set of changes in mind.

Best regards,
Mohamed Ali

