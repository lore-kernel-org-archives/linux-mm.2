Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0858E606A327
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FaU+7fd8
Received: by kanga.kvack.org (Postfix)
	id BB9146B05BA; Thu, 26 Nov 2026 07:15:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69B16B05BB; Thu, 26 Nov 2026 07:15:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31426B05BC; Thu, 26 Nov 2026 07:15:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 831B66B05BA
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:15:02 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22C36160382
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:15:02 +0000 (UTC)
X-FDA: 85477164444.29.1193A23
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 54F2618000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:15:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FaU+7fd8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795695300;
	b=btTjY7g6crlwntCaJjwJ7ku6rOZl14WuiRkc8I/Rk5X4CcM2CiTPrGtbfPENPrDq2NHVKe
	hx9YBuSNVQfGbi8GDEoQzLhFk/E/FT/SBOnUliw4jZSrdKLGrvisufMcJx5extVRF0Mncm
	1dlFyQDj6GKzDei4oc4BRDWoCrFTtjw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795695300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCVZxwPpgvCRm6fFYl5Jvfibq2GfrDdmfWffaFs4sZg=;
	b=IzzwpnpVY6ozNpedbg79yA1fvnh7C8F7Irm9Z4PyOMp/HelEw1fwdh6y0Uwe+2YNUXJiXn
	km7qnktGvkvxue2356epuEBouhXPwBppLVXgVyKmrrT/zKuyfwtatIHbSO/LH9LfYZShKP
	dMA3fOsoDWGs/ZytEDvvNfaWxBe0UNE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FaU+7fd8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-385d8a00598so10218823eec.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795695299; x=1796300099; darn=kvack.org;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XCVZxwPpgvCRm6fFYl5Jvfibq2GfrDdmfWffaFs4sZg=;
        b=FaU+7fd8EvZgN6JSwG0ms6QrSMhfUkSQ5I6CRV6vApHM86hizZ+bghT41IfqsZz1w/
         uwgebMkt1hnamE56n8SeT5iqJtLXoxtjU9eTxBjWIjpo6j5w253L+7sORMWWbFTnW+j2
         NoL7HReNJ17MPYhy67v45usUi1GSL7n41W5jdavchbVQW7/cbdSGFBdaYt1SxQwN+lDs
         vMhT8GUqxn9UQAP/VexTZQ0dI7B0yigHexdma3DRNxutjmm0XxwtmDVv4YwzToRm6jal
         w1kKV/fzYIRJlahyebRdsS8KfVg4CXb6sTkub+y/bXxLzfqZuKYKLr1S2xygQ3tcJBfJ
         AOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795695299; x=1796300099;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XCVZxwPpgvCRm6fFYl5Jvfibq2GfrDdmfWffaFs4sZg=;
        b=NQ1EzDKU607+liEBZ4+NFhzAfZMhpU+H+0oKMEi2Wlua1Q5a1BXzTM14XMwBOu7bnq
         t3DUsVjTBQ2vi0OpEWomwvXZOnICAafEaJ/Z3poV36yOpBqi+j5FU/HK15MEiHMw0AJJ
         1vFCXQC6HorZkf1Wc+W3z7E9+/m3Ibg6t0N84DbUNi8RcoRvscBWAaFrNmIo8HsxDEG1
         wEV/bd57STDAbNaxanQpJlI0ipyLSRnAHWkljSMIRHNO35OqIlYzrGeCR9JEJur8X7bU
         w2GQ3Gv2vFwqh8LOcUtrlsrBp9YjzFTUV7/XKX4WTb7Tuv9KtJ2t26fjfGeOPf+j656K
         TsFQ==
X-Gm-Message-State: APuU4Z+6TePYmuRexfefrEEP6165HS5umRhogpKObw45YjWpIz17uLHs
	SDsWsm5cZ53PvtJMikh7SdqRWFP45fft+rnKl8SEK+58fQsG/hVJU7bt
X-Gm-Gg: AZFdTZfBRvqQ4B8j6Oa5AsszslLJVBXI3mBI5KtYYZ8wPPwTQsiIpg5kzeWTysEtGR1
	2jD2mBwfZ23ba+LQwfMj90taTnp3Tw9McoL/2JFMkGtL1Wt27ZZN9YCp/Qbw9lTTyVJGzdhniXC
	9O2IU8AxOHtLhOGIhsUpnhmHBhytviEUwX1CjmNphcjr07IxQzKzesrE136OE7ZCknwUvG0WfdS
	PCuEeaXe/kqQV9t8SZl6Ah5mA/OyL0LX2hzLtNkjAwHy75jNBDPqaEEbuoKLlbhnSL1YNr7mUQD
	Hl/sQ12W27zLFGYZiS+Sewz1T6LCZZZCOwfyG/rwulwro5FBH5y19Dt2CPSPs6tOAkR0TFb8GWD
	NbRe5L+s1tcfoPvIBrX3ICIQWSFnxGbi9myGiWEC0zmwYHJNeqCvKFDnK3cJy2nbzLVw/Nnnehd
	bcjCZnAxsRPJiPhuNtRt4MrQF+eF3aX0BK3LeYSuOd1H70pVH7aMdAIu/BqARtbESIUXBRoCVZ8
	JXjGQkbmqI3NcrI8I5dt0zaSQ27tFHoc8fcHul8tRjdovjWSCW8edfEL9H02zu0i9UFVHhSCI+p
	B5K1iomkWfkv2AQW3T4CIolLF0kQEja4u2kzyhMDX24NLebYKdx//IXXgRK3Ug==
X-Received: by 2002:a05:693c:62d4:b0:386:ad86:21a9 with SMTP id 5a478bee46e88-386ad862c8emr12324340eec.13.1795695298917;
        Thu, 26 Nov 2026 04:14:58 -0800 (PST)
Received: from HFGF46V04Q.bytedance.net ([203.208.189.10])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385672ce402sm59109818eec.16.2026.11.26.04.14.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 04:14:58 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v5 02/19] mm/swap: clean up hibernation error handling
Date: Thu, 26 Nov 2026 20:14:28 +0800
Message-ID: <179569520640.49764.510050912247709774@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <CACePvbWzE6AvbLzNFe=J5Vid8iy6FFQh0RBgr+V_jJJ4p=OEVw@mail.gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com> <3e8d55101602d5ec982ae636eaf5eb4dcaad3ba8.1795439990.git.lianux.mm@gmail.com> <CACePvbWzE6AvbLzNFe=J5Vid8iy6FFQh0RBgr+V_jJJ4p=OEVw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r1pdhx6jm17y9nqjarrdpfgajbi7cs3r
X-Rspamd-Queue-Id: 54F2618000A
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795695300-104592
X-HE-Meta: U2FsdGVkX1+hWrSbguHKoQWYH4r22sW94n1k0WNB6bR8RHprYz1FTWmJDnojNL+DHieGfIUnrqaSG+302WJgyBGeDa6SU0wijHzDRHD2fvNMcPHqf+YS1QnEM8/NROkUr6dbBX5nWy7N0LiTTI3+tgHT/6lQIyKdPr/fGPbYAQPl6IWgHV23YWOhx+qKWYZP/v4pPEDmJYkNiwaqZQENOxuCctpRgt5Huydou8m/21kqPNWAdraakl8S/IoNSVoT6QAXShjyrf6tCI4fd5iAtgaS8xC1up1W9+xxXk+A9TR3Kx556XgYZNcK0HHkD3olaH0OROuNm3wlaLwE1mctzH54B0XjYEj46fCxEqb+bu5It9rKCnBQU/CX8rxQjRM5xR8s/WLSer95J31g8STzjreHbeWuDma0uQFZygwiAtZfsh1tIpxC4Ja76WGL1Xrvmt4TwmJQJDhmYljXyPOKlgvei7gM+sG6Lpa6LvrkOj695TZSLK7HosE7j2Z+Xkgjgrq4FESEwuDJssjMdc9VJJ82Shf4Xb0cjibpLwebUOnZMF5Q0wIfiW4+V3tAnj44qh2tDpPWj6OCGxVPD4heX8uVjo4ugiJsXcgf4VOCDcJuDsJFOUVlyba2phWjcZiUMlC6KLceeA4zAoi4HG202PxiUQQGhv8BoqtuR9K2WmOg7n2eAW3ArJf0/kWf1n+gaafaYOuqdsSY2KsFfM1S6YyCsL8+3Tkz2BpSn+++HnwUaviac2cFLUns/dc9sbG9YQrTEhPvsfjY1o8xDh8vsepJLundNkp+Z0450+CBN/d0WLnhF67I/Q4eprcL1waU6YIH9Hh//jH7OuAUejC8GW0wxq/alLrJwjG35DrrPgWJ9p3iTjZDTgEymTyRzfL0eU6UmzvNrc6631RgTvWXZyaaygxV5i+8PFCz1uKskpUlVCbxhfAjQBGAlakA2AjykK1K1sEGu7jnFtaqAoA
 m+DUi30Q
 NlYocDhs5ab+VVvg/AjMwocrztNxcGjnocBa5vAgtMqyCanJB333wosHK+2TOFI3UtG4295mG7wDo5/rIMVc1VUgNBZoTrggkMwTjaTubFyIcIempKh4RBL+nss7lpNYJXhw1Fq1im8GY507treKrzwZTnc6e+W/0jxKsAD25aICHr3bAtk1efloSDdCEX42zsucxFWEVn+Cas9RYpSDKlyzm9q3DyAXg0Ofeph0ivrsWao8efTW5Yi6F+dooVY5qTy4ufWn+5CQABfixONA7b9S1Th5auYu11HCNX6EvPv3tis+tyNRRZNmTzWr+7/M2wnt3sj+Mbc6fdRp+265ii5hkUWOzJ+GFc6XT/sCFI28wo/9c4F5K80Ls062R45NN3w+4jAD0786k8vnkiObVgu2SIhZ6zXTC0mUEnoDwC0k/KWzBGGcitrI70Kd3ZjdgCJSO+XYaRLeVAGHoKTxPX7TswecfxLvLUwrYXxpNzK8EDJIScVCgKZt9Nt6/NTARVGBctwdNZz4OP46C1Yh8zzl3ravq63HUWrOLhTfsDY6w2KJw2s1xVTFSt84HjNKq33uvXgj7h82y99z7S1Xx2edsESDER5uD/mxVro88U3lxIGHFSjkHS7shs0IiEy2RQPEEdsrUspylEnU+DW5oX+6rqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chris,

Thanks for the careful review.

> Nitpick: Here "ret" only carries error code. Maybe we can call it "err".

I'd keep "ret" here since it holds the swap type on success and a
negative errno on failure.

> Nitpick: Maybe "unlock"?

Agreed. I'll rename the label to "unlock" in the next revision.

Thanks,
Lian

