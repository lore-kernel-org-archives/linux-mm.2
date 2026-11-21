Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4349606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 23:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=FHniVaW0
Received: by kanga.kvack.org (Postfix)
	id B514B6B00EF; Sat, 21 Nov 2026 18:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01C26B05B0; Sat, 21 Nov 2026 18:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD206B05B1; Sat, 21 Nov 2026 18:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77D4C6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 18:10:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A52FA8242
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 23:10:30 +0000 (UTC)
X-FDA: 85460672220.13.B1B153C
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6A1941A0006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 23:10:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=FHniVaW0;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf19.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795302628;
	b=FJinJgWkq0wrSMbmaFVew7uTORWfU+GS+hHdpAI/6ugxEuLiDSNvjrOMXy5eW3MXg5TgU8
	NHBD7xF3oWVqqiuZjzf9wDnboJdw7FEi4fkMqEigEX6qkTMNmzfS5BEAw5vFDy5HmTNNpL
	0tVr0cNHSjcRzLQQzVhKN0iKIEe89cQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795302628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KUpBP0Xy2iK8BxAyqumEvuIzOsYp/Z0C1HcgAVDz2GQ=;
	b=0zrqjEPUYcyi571H8R0m3MDNh1LVGKd+OhAYK6fgVku4rnlkOO5Uswxk4Phc7arGpgjOtI
	2v72g3TSRJILysh9ShlqVi4tunlZN4OgDUNH7Zuc1ck1heGZuZPTifB4rVxEXTicJSNex+
	fE1/H0RBrj81qyqvdeIcK/GnX8X8+3E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=FHniVaW0;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf19.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DEB6640E01E1;
	Sat, 21 Nov 2026 23:10:25 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id FQ6qc95uBY8V; Sat, 21 Nov 2026 23:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1795302622; bh=KUpBP0Xy2iK8BxAyqumEvuIzOsYp/Z0C1HcgAVDz2GQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FHniVaW0TbDaJdfJuduL0+Gg5CbWKtdEFQHv4NPySjYOj5x35KLTnUI44sCioUC7j
	 QLQFvn7DrkCBXpyeF91H//mzmoK/UYodxPzNNa2VeJUo6nDrmI4uH0GltUppRHLUpq
	 mutb4t6rqIUu0o3/loErqn16UkhwbyYeA56RWmGezODDCFvWV7Jdi12i8pl8wTV0LN
	 9Ehz0z/l0o0GNf/f6lBFPCClhgfn4Co4hFeH4w1it09emZKF579wH/+pXFIuUpRfUh
	 d3J0R5YHEYNtmdUJ5WAjxxZqA91q1IveAuBIefWLTrTrPTMqC6D9u3KiEx12HIAcBA
	 tmPeOpGKoeYByVp4rptpUI3h+ay/Pflty9PPiL4Hmuuq/F5OdnEl+EVXru9NI+TedJ
	 JbOFk7Ns2y+ONmQXqDPPfonErzTpppUyAvuKucMsd8O+Y5zpt+q2lqQZsKm5sDJ8/L
	 z5N24mILDZ6VEbAKe0kNmJHIKo9prkyplhLoEF2+Kj+K611TUYsf9gougjNB1ggyug
	 pcxU4cYGw7LGI0+9kB78NE8HpCNf3TqPZROmFILWxfP3aD32uzCi5bStxRNcmku/ur
	 HYpl2qqYSYByZ2BLW1I32YSxqD91TLxqke69y6/XWJSn77BaZXRwpbMhRc5oLdDven
	 1wbG5E3L6wUqOcFPlQQbrshE=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C9D9240E00DC;
	Sat, 21 Nov 2026 23:09:45 +0000 (UTC)
Date: Sat, 21 Nov 2026 15:09:42 -0800
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shijujose2008@gmail.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	Yazen.Ghannam@amd.com, mchehab@kernel.org,
	ashok.raj@oss.qualcomm.com, jic23@kernel.org, linuxarm@huawei.com,
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
	gthelen@google.com, wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com, nifan.cxl@gmail.com,
	tanxiaofei@huawei.com, prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com
Subject: Re: [PATCH v23 2/2] ras: mem: Add ACPI RAS2 memory driver
Message-ID: <20261121230942.GDawIktifTKlYhUlpB@fat_crate.local>
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-3-shijujose2008@gmail.com>
 <20261017055852.GBatMOnEl66YObvU5k@fat_crate.local>
 <CAG4KcR+NOKHNzg6FN-oLLHgUxeitZHKXg9cN7dz24+Ap=RrwSA@mail.gmail.com>
 <20261110071729.GIavLFCfLKzPx8R0i0@fat_crate.local>
 <CAG4KcR+ikfQEBjCZiNJ1CUz=u3Gtbk_XDroA_GQqYpgO4Lo5Qw@mail.gmail.com>
 <20261121194030.GBawHzrrCNCMpfr7Gx@fat_crate.local>
 <CAG4KcRKhE1UXwrhscUdSpDJS8R0t7kWp8RXZm8j_9yXYJSQ2KQ@mail.gmail.com>
 <20261121210749.GCawIIJcidCeWs3ij9@fat_crate.local>
 <CAG4KcRKzXNsvBWuuU2_aX5gO7u4vgKAK+bkrB2vgEFBGu3WJCA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG4KcRKzXNsvBWuuU2_aX5gO7u4vgKAK+bkrB2vgEFBGu3WJCA@mail.gmail.com>
X-Stat-Signature: 5h68ahsnxg7h8z8mgkmrc5wjj7gytm1c
X-Rspam-User:
X-Rspamd-Queue-Id: 6A1941A0006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795302628-475791
X-HE-Meta: U2FsdGVkX1/NMevurUvH13JLGUrj0ImyAMdl6CSZwSz1twTfPpWQAcwlT9hlm2D0tgwlt5UY4qRzMtQtr04Ez3JaGoD+uySCmO61StFmjP8RrauJjqGPgl0FGT0F2fqghWUupnwxp3WMEKCTRmglfCjdeo80YWcqb+Q2Jz6SGvafGn/dQhhlnWJfnMGDuFnQjMPD4cOnE44dTy6fdyg1eq9kGQtMHsvnhYWiLUq3IkegvTUWOJjKNkgA5Khgsc8POlP5+IUmsfYix77WXW4X/1vNibw9TwzuHpVg/XRksH/GM0kkYiSkMV+IDIK2KddVQlntiX89T07IQTfDCI/FV8aHN+3gl69IGq02vYcJC30Dm2ZyeOVa+e9QBLykFWDwiRW5bTEse03yTnIYqxbgB0cYdAGtdEK70U8g53p2n2aOosD0E+sfQsV89P1bpX9KbBywsc9zYWLe1Z3DipS6JGWPlo6rsnUfQIC/hr/g/s3ioacKOvsrKiDloVfGLxn7EVrnmC5v9jPj8gVl+xvULnkloGBLltv/WkDiOAcu7m+Lk9Qs3YkUwhTHND3tZ6F5Dt1zYxy7sZXchRVuoyVlnj6hBmWRaDYSuOHf1f0xjlnE8ec9oPn9NfKkQQ1ilONXeISbfnD78gXC+8OQjRsKB7beoBX+HfvecizeTheCMBSpt05vQpRGm4h/RfvCParm4c/5lmKF1uPvSWo3e4zieC9wel3sqlRnTK/rVrYwGhOfm/LMDc8oCuO8eb1TnR8SIdPg9OiuQKM+WTXK0SvxrJ4yaJbIuBSDq43R0KhVdk99DnHF0lniogUlEk1X3sDHJTOfbib3gwGuf26pRaG3F+TDY+A1GIiOlvTCoW6i8J59h/ekFiw1L3EM2Z8p4CIg3djyfmwEuqw8NMdgICvGkZ/SI0Yb3XHNOfpezV1mbdO03GBH90VFjuJ+/wTaN+hV2xAnYXo1dzCHfi6Fqhd
 lk5jVwWo
 6yRongo4DotyFiZK42gfXLYI186RysG8eZli5eRTe8lZqCDk/PzFql/0yfoQDFbtMTt6R44onLtbEv/LDoEouUFI3Icb9/ehv+tPa2ItkT+GeCZapbAcI8UPWHDa8gkKCHM1B/ctYp72DlpodPi0clbfHMGyi4V3UDrH+WYXJ5BzhF5TiLgTOx0+spLntD2M+VvhIAU5LVWhWUN6MMRlPMNeBcoYj+SLRYX+VzRgsR2509Db2WuZTVysYhJFr3/ELo8q5oXzbeQcmqPDyX6y13xhFsjZRKURLSG51zMl9T6IMACI6mXHihwUSSldn7UU1njQW1Anvy13nXx28t2IRXW2lm5MxTVtFuow7PnYlTKmCotOtkgzGhfxGJfGlDp2LycPv7fyMRCzRl2c9n0UR0KEr7KUpS/avch9+7BImm/q6rd/5gUi0kyhJ5SupoAdp9xqE/mXW4j8k9AzOMl8xBXz/Ycc8D9BQrySNFmt+Y8K8u0dTbCwcO5ZDHEQr46mfPlnTuoMYTOwza8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 10:24:28PM +0000, Shiju Jose wrote:
> Thanks Boris for fixing this and verified by testing.

I cannot test because I don't have the hw. I rely on you to do the testing.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

