Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E4FCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 21:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 101EF6B0093; Fri, 22 May 2026 17:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2BC6B0095; Fri, 22 May 2026 17:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0A276B0096; Fri, 22 May 2026 17:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E329A6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:50:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ADD07161988
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:50:15 +0000 (UTC)
X-FDA: 84796399590.24.4DA30F6
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 745B3180004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:50:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=NnV7peFi;
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779486613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IK/LbqWxIpqrOMdgLASbTWPmmkxO6B4/99jlCNN7VsQ=;
	b=xiU6dQyGNk/vxcqH0SIYppVYkphA1X2MChhjj8ivBszjy4y1zpPFBVbFlOvFcEinzX8886
	qEwokSdmb+OJiSSDwvUrpUuiKHmvqOD8o6uYOoNl/GZhRiZIxwmC7mxI9doidFq0HhZf8w
	xnjHcHfZXqlF9yS5osbwNALJPLn2T+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779486613; a=rsa-sha256;
	cv=none;
	b=v8D8I6QtO7o7RoHRcEh2XG2SXTOEr/AAvF6AI1DwimIAvu51jBqWotpr8DanjDyLY93kUK
	0qfE66ihTdiUwMhCORSPNmjd3UuANlL8nnK2R39x2yNWFT2WHrNimQ2ULW6QEB/C/5HzqC
	ukd6Bm0u+hVa5zoqWGcVZKFVWpIiEpI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=NnV7peFi;
	spf=pass (imf06.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.48 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-687e7edaafeso1108663a12.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 14:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1779486612; x=1780091412; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IK/LbqWxIpqrOMdgLASbTWPmmkxO6B4/99jlCNN7VsQ=;
        b=NnV7peFi0GrT2aBgpOiSuFEUyAbyDOO1poeIHmXL25I/gGyljczuzMkOczx80MIcbZ
         Q4w4FdFijpaXEhCT1qQvcx6ImZuy6+L9/Wtzhp95LyOipKxebWy55mFZRtMgbVmsrUMX
         NCBs5WCfsRRFm43m90E1Hq3KEQCmBz6WNbLuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779486612; x=1780091412;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IK/LbqWxIpqrOMdgLASbTWPmmkxO6B4/99jlCNN7VsQ=;
        b=p58+FYwaeT3jLi+0px4MGDBJyTapWUE+XzJ9mc+F9hyIheWvm1JUWoplCs6wZd7lu7
         wEetA3FYkpDVfNHz+Z2sM6yWenFQUap8qAkyJoth6OVbqMe8MADCvVtaSZrW6tM3b2nd
         uVayNHQq1wYzXkssX0HZeoF8d9OoLICCNUdVARuI727vpPUwKaem28llyhP2CogwDx8k
         CYEbyQjnTP37NiKkcvgty3VOZ8FqT+/VDvO/ItemrwCMtN/NkqJrSYUKAGYKwEm/7bB7
         Q/r65M2g2zZEi04vvLvMQmdYNmQvCplqs6UyIvamTU0Z74PQWf+OKFCxBPO//pqzbDD1
         LZ7g==
X-Forwarded-Encrypted: i=1; AFNElJ/4hKr0uTze2JP4bYZ7zeIkuVZJlj5I7MOWAh6w05uC0undP39q86G+0N40gx7EDmbdlzoHzqkIqw==@kvack.org
X-Gm-Message-State: AOJu0Ywqtm1X/sG+E+8v3qahIKzRUB+U22AIsSXQTq5/WVkI6jO4SUlG
	Z1rxG2+ShuOMEGYm08moCAsdSyl6wfEnOrvVlwZaZWfObUJtpsxIoaBA/11SoA+JCIkFAfdfMCW
	YukRdLrA=
X-Gm-Gg: Acq92OHixw6EKFBdYsRJGX2fzq0oqEJZYLCVHmzDwnzeuxtbFeJgotgkKjmIPTN0zdk
	gc+HkqS9FBX44keX2pxBK/k1hYHkmFmu3LBheej+dakrql2D6ksMaVW2qQRpr2zCoeSu+IeUK9b
	d5NGcRYLRiGOUoZHHpqOuyW60HkYcMJzQRp6XAX4GK5vb75/5vdXidTQigF2ScnqKu1qSoHyAeY
	G02zSwLfhuwlRVpi3Q1T3NOBYtbaWwPVDkH3hkpldTh+aSCZhyZl27eoxH7p2RXCPzJ3ePVrytL
	me7lhILW2HNz/401IWHbBdD4XIKVz83J5CJVmAkgbtInyuGEB6bXra08YlXeNam2+y9NoYmTVhl
	ziyRqTxEtFwy+u/SQfOr4p9yAvB0cS3D2dJn+bjqti16IygLMD8cRn6fozfZHr/vThVhBLrNwtW
	4sYSZ2bdzi/d4B86eyZrz3Muxi6rR9RGVbxMF0xFNGbujclEnqWqB8LiwgFbMIwcWbyj+GDE41W
	fN+XM8ZNqg=
X-Received: by 2002:a17:907:602f:b0:bde:170:a0ef with SMTP id a640c23a62f3a-bde0170a22dmr145409566b.27.1779486611413;
        Fri, 22 May 2026 14:50:11 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bddc5ed2d38sm94354066b.34.2026.05.22.14.50.10
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 14:50:10 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bcd3c190f71so1275401166b.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 14:50:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9QZ1veympcDNQHj/18ra8wzTmBPDUVyp+57NNkKqUmwgOqhV2dAd2m2BRn6PD4vUurT+NoPdr0Fg==@kvack.org
X-Received: by 2002:a17:907:928c:b0:bd9:a95f:961e with SMTP id
 a640c23a62f3a-bdd23df2e7cmr385157066b.3.1779486610031; Fri, 22 May 2026
 14:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260522-work-exit_mm-v1-1-bd32d5a560bb@kernel.org>
 <CAHk-=wgJRmdjDQExRP67GprmG7VLopuuaWMyZr4YNp2NvdNbKw@mail.gmail.com> <20260522-bezog-kupfer-gruppe-e2ba3adfa44a@brauner>
In-Reply-To: <20260522-bezog-kupfer-gruppe-e2ba3adfa44a@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 May 2026 14:49:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=whXphXLqC5GxT54M8pA16q43QWexDMLB2=CzwmU_QXB3g@mail.gmail.com>
X-Gm-Features: AVHnY4IC0enEsiRFdURtw_2VmgkH8vd2k8UXTsNWEjFZDiGZ7ypaDkMe6MNZnlc
Message-ID: <CAHk-=whXphXLqC5GxT54M8pA16q43QWexDMLB2=CzwmU_QXB3g@mail.gmail.com>
Subject: Re: [PATCH] exec: free the old mm outside the exec locks
To: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: dio4s5pxryj76m7pq9fobnfwykrdqxxy
X-Rspamd-Queue-Id: 745B3180004
X-Rspam-User: 
X-HE-Tag: 1779486613-787626
X-HE-Meta: U2FsdGVkX1/P/8PUPXwa5QVX1JVdtLD/APgY7W4I5dRnqAiqQmpcI9QLCHrG6U6VbuKXpPCxcAUlQivgdMB8jRdIlRfmDekfV5iHrikXdq/SrazMSB7ctBmnKlXv/nFUs2wuuHTGUTgEtN70UGFe8QC1kz+Q4n5Xzc1oJkdhrfsrEDPRZO+d1GH3Cr3mla9CvjLFouUUYtDO+8L+rFLOwAnTuEcNZ7rRbw2ZB7LBUkFRUSdAoTxx16deBuOMqxcOiP8oLkjt5KDUdnoTQ1byQG9a5L/MSuh7vu3DwpJvDe0r+5xqd8tgX8pkGSzWRErsfu/A22y/cB2IC3xSVKHtSe3Vi48dGWg/IWlnhvzHLoxQbCWvGiaqokhZYkgIVkt6a5C1AY0825tuZp0qZAyvihJVE+UF6pPEU6iqAPPoBJIHfXcAV5pHu3xBnVMc7U1OtDm7nd/e29oeWyFSo2vLMnwBn1zE+gxkwU1DsnPGUu9vZ34ijF5A7HP2Tz9zg6KNnMDQFsOyTwm86AVUjsan66mLdeSsptdV93qqM8UeZLGWMOgcIyxk70K++lEH8CAiLejm61YbTR5kcR/p/3WLgYyLn26wqDyFG2kNlLKKkOfM1Vn79pVn1Q+2N0J666kV/B5WOKzisEOJguXuAjHyqIoteh/XLnX3KEGjllim9JbqfuhaSd3IHo8l7a0VvtK2mZYlXLGykIQx+GfQxmsoK3jCyhMrjEXYetlF+G+ueNUeF/RMXC9SrFW6H8+NhfayV+pyYnZ0s2QxNVDKbliEcPA7bJer89NuLSa/BOEFeEAQ3s4DcKhqCKMPxK9YlUaI+ziM/g4PyWAIWbqIEvec4DI5sqGyBloExzI52dMITYeY8sWp7XRGjnyfVtIar2m27wwde32R1YeOBH8f1rc0XKQHpCjad/uw4FC7wyqlTmzAVOEnwaQlCZUnO3kxp7rk3RPMsa3GgTABSg4DF/j
 rdHSXjOY
 xKPKxIQKKYjt0TDV7E0CES1kn8Il7D9XWcgFp3lCxan1gW2d7r8XVgqyLSlNP9P9XEgyPV3KAUztNrA8qs0eEJumCOCAWBtG75LpXTOKdAy33PrIZiiTxpcshH7y5q8q35tY6jZe70YO16OtXp6Kg4lvmRYGjcRFA+LnkPZ5KPLFExhLzW+idQylszP4bhhGIDlcayeWP+UHjsfpmtKxR2OezgOnd4AP9TnvRAv22aJwz+/58T7xGQDBWJEuQW9ulZD7yXumYBBH3gCiWLBS+93ZnR5GB9MIlVbwsfqe2u9CakN2L/TYeKiHRU4wt3tKBjO1eYLsoEitwLfkpdfDwh8FSvxHCXG93SludzYkdtpDnUbM1y05GdUr+lHdFtdxiUrl+jvL/f15N54k2E4UcvjtWIrTusgOd/kA93WDQ8gDc1Yz/7ajX48ZqEUzwXeGbNtIqhcAR8kYW4NpkcIST60t5i1fDtaH4vd6BIsWwyLCFC+AOwGuiYkoGDzaUz5swUyX59KvAKMkpjUa/kLY5fXN1Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 at 14:10, Christian Brauner <brauner@kernel.org> wrote:
>
> Moving it to free_bprm() has the consequence that we pin it across a
> whole bunch of work. For example, for binfmt_elf:
>
> * setup_arg_pages()
> * mmaping the elf image
> * the whole elf table setup

Fair enough, I guess releasing early might be worth it just to not
keep memory around.

          Linus

