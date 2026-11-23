Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C6ED606A327
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B62E6B05BC; Mon, 23 Nov 2026 04:48:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93F946B05BD; Mon, 23 Nov 2026 04:48:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F616B05C0; Mon, 23 Nov 2026 04:48:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1B16B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:48:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00669C084C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:48:16 +0000 (UTC)
X-FDA: 85465908234.27.992F60B
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id F2CE3100003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:48:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=linux-m68k.org (policy=none);
	spf=pass (imf05.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.217.47 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795427295;
	b=RMDxOaBGxoJmkXJ/YDdnNiEbQIRqdOZc4zwMGpRbcz1A02yLlKKW4G5gVJ3lmWaC4qfY1Y
	2xNm7VmOBXfHkPVTwpLIzXIkiltZ6MhSnYEa75yihbIwDG36dvXYMoDBM3AILgnS2BJTQt
	Wnb1iEuM187NN0wGvbmAWsf3kIq+6MA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795427295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cWZpBhDqNHZ7OOEEIRJTwjTd8bE65OY0/Xt9j7AHp2c=;
	b=dq809j31iULTUQeDhvBM4ekfZY6fNWWcGEcmmRYCC6wN+5DD0mG3nysrFee37vYvrWW+/M
	Bh5A2ziFmNubWwADiGKThb796ug2vi0vZUweuJanNb259xWL8OtV2L+9OIBeBUP46VNsSa
	XkGa9U5ymJswI8jXcv74XCq7kVsJShE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=linux-m68k.org (policy=none);
	spf=pass (imf05.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.217.47 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-745497ac8fcso1050660137.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:48:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795427294; x=1796032094;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cWZpBhDqNHZ7OOEEIRJTwjTd8bE65OY0/Xt9j7AHp2c=;
        b=QzyFMwDZw5XMMfKH25+ZpomTB/HN1BwIGmus3T+I5maSPHMHZA6Cge+MHqNkLLNUAV
         drIgwke0b+PRZa1K7z88bnArP1VtD3Ni/LF9w5j30LihcArEInDEzVYJXmGRb8WwEv1D
         QrwxwdnCIAq4EEcxGwjVUXAX3t/tCDVAtM5MiHE83TAoexmUElzRjiPNKVfM1MymKZXD
         N4C/mDCPmLgHviKANv6qYFkaldBpRaX8egLM4J1AGuXoyUyRRFnojT0RnQA+iI6rDWTu
         kFUOLEL8GglvsMcjdA35sMwfqTg99c4whS1xORrbULwDtaDwcxDgdfvYCj7wcNB3qirh
         /H6A==
X-Forwarded-Encrypted: i=1; AL+hErGDGV5gIfzMY5iCS/ZwgaOCrXXtzUgMNZdwCza7l27Bv52mNt858jJmFSs6KkqEq51FXLVIkajzPg==@kvack.org
X-Gm-Message-State: APuU4Z8fcYthWEAUemWz4CeDy6RE/QWtgcYbh6EqoNLyjpu9t1K+AnvP
	jw5kOqr7qRotj+emghrzVPC13qtWzqft95aF+6BLW0UhjRTvlkagmzdf8g90Ylx6
X-Gm-Gg: AZFdTZfw+avf3PGQSQEB/92XK4RJyplqpiECeL6DVr4kMpfJ2l4iMzUrPhagtLK4Yn3
	bh6DySgvYNgZlCvNp71Pol1Jtxrt+/fQummDtURMmSuQbx9PNrh8AOQXa71D668wyJTCe9mSAUR
	I4bep/aJ1Snv9szGf2FmeKv7CVkVkp8UUlY74Ecd6z+inPZ/T11gT5nj/6gSw+c3yDpfaOpQS0x
	5cRiYDTHJqMtVqgPcok0PtVb8qxOqnuVgLZNPgvNkM2oYnlQc4Byss0MUzSB+0FfAEzh7eRBHr+
	2W0hcMQNDs6ybkjzn4jwJrEydyckMZhyfft/8Rvb23K6LYDtZfTcTVsmnYe9PsU35s4d9sSoobM
	BFvsZBf9XSLukwi9PM+08mF/3KceUbtf3u68Ho7ZUeROE/sR/Q/ZBS7doir5BpBR1n5OjRPyRF+
	3kTC4SVu2MB0RsfeRK1j1bxIJOgQyxkpVaRfnAQyF74YblZTOVYr+q3oS8beXA1OKeVDbDKUObN
	r5KtRr+QKL7j6xzhLR77ZRF2wqLHDcyx4Eyl/K4lNtFDyftEmsgWJOdNANvCM779EC96LdrfKpJ
	jOLUrc16Ko+FDJ2wk2DvggH9YzhCydXxD8G4xNOee9CodibPQmbwDWNVudyi7b1Tnvo=
X-Received: by 2002:a05:6102:6055:b0:7cc:95ed:3147 with SMTP id ada2fe7eead31-7d739689235mr4078338137.34.1795427294077;
        Mon, 23 Nov 2026 01:48:14 -0800 (PST)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d6e7d76b74sm11154495137.1.2026.11.23.01.48.13
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 01:48:13 -0800 (PST)
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-9907a58f14dso698171241.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:48:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFiBfubQ8J4NKm8ENpS/fD2UZomxkpszmfI89GWQnVEFR4CdziUaCrw1YhDuM1MOXJEOPgFuNGc3w==@kvack.org
X-Received: by 2002:a05:6102:5813:b0:7b2:508e:3d57 with SMTP id
 ada2fe7eead31-7d72b3688c2mr4372703137.4.1795427293752; Mon, 23 Nov 2026
 01:48:13 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261121034304.2dPxVKzk-lkp@intel.com> <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org>
In-Reply-To: <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 23 Nov 2026 10:48:01 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
X-Gm-Features: Aa3M54rqU2bNqHYEoVpo9DgHQN7kUDp7nLSe10xRxRC_Yz7fZEF6xyok7yTvw-g
Message-ID: <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u)
To: Finn Thain <fthain@linux-m68k.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F2CE3100003
X-Rspam-User:
X-Stat-Signature: i9zyzoaumohpi86864nfycqnhpjqpz4o
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795427294-544126
X-HE-Meta: U2FsdGVkX1/ZdvmyhtCHYixN6Y5Hwpzjahtc9uDXl2KOPg/vuu4cK90PVjKsuPftUwMwMfoI5edOWZHpH6unX/pdWzesczJ5RVfdhebFcvsnER8OTuBx94YWKNjm5CwS6w+1askXYTZDpDfUhLA9bQA4ypYJOsoQtJ5143WW1W/yoi9SnHrrTGK+IltZD7W8VqY08DvY1Vp91rdOfeATHqZAnUPfX96CPby82bG9zJjPlUlY3ZIkTaaNnTf1zmZHmARwHnBq+RViHCsM2WeyU3VmgO/EZtJMm64pRY7gAPTBVBS6S9Rpe+K6uRUEqt/Gn1mWBPEoYDtSCDfujZ42hc1bE0eIglAsBy1pN7VVrmib8b/2+jFK5AxduV4cvQLI3ZMbwAJG9o/kYFFO+GJY8n8AK+FWo1TCntkJfr45lFN0dnSzYubXL8vsJ9Lqt5rzeGrOD3yBBOfzbYsp7m5l1OsodZhQnAE2/M1auPmtydVZ1Y2UMFIejc/hbeYYGiokpKE8cSgg7RdL+24TISxb5U/AnKvjibosVSUUoE8q5ZViIDbmQu3AFTDeGPV5aogf/i17LD7ewxwYVw8O31QGKtt/yufXzOQXP93Hc2D3+kQzgb+8K9Vf43cx6i9xMmWacQNAtObMTAwGsYmpNheTn5VmO+3nhleL6Utt7+UVz89aujL+CWW8N8i7LwR8Ry0k76rKHFvAI4/bqL5ZBB7Xev8NlP2+9klgFyj+1ein42nrj5RV03PFYMOfdbEubr3BxGtIEn+qsD7+IcMrA5GINY9GuPXgE52rOkHAmfsbUHm6TztTlkfmGWahHBU1OtUC2885Ikk7PZo6BJ1LYxu8bglswyuyAQEVbsK2a40AF4lbfGLN2FTA1TIcgkFaiIIXVBgs0/A0+SFdVpCOMFn8DMDwyXyuxq5gD4GyKNddkVIukY7dTSB5BKtCzW4hAiD9O6ejzte5oR/g6C4Ed/5
 xqZ1eJge
 X39aOjIH2l+sYO9+NqYWXodYjzzGhBFmWXxDxqaGVH93yq9RylF9FGnNJLlxM5zcS6MF7gkSA+5p5yRT4JN+/uYUG1XHGZlZr7wd47T7g6mEmXaSU658H2Tz/8sd2SjK95jdn5gmr999I4mdpdeTbq3+aDkTyIQ/A9gdGdksfgU5gmUiQMlGkjrbLSONq1dwab/fvdfBWEL3TJv8hxu9GqWWv0xmsQZ0SAehnX+fLUVCyY6hgFBt6s3/U/0F/yyYsRmc+zKAd3QkpS1sSdEdYuGFGnPWTgqCIAy+KUHeG9K4NNlOmmIFdl41TeJ+5HRZv1awPREGjM/EOkK99cs7efSZvbC7vLTHuN1wBPphYIZhMICNk8Uim3HC93THxMN4W4vN67vYryk1jHrAcSsqcplXLaHHU6lJ9S/T7MX7q4HHmEOXCEC+lLyK/YP2gJ9Y+VOU84ZYP9cGFgbHS0na3weuF4s6Bua7d6V/XJVU1/eZHkz+sHwMIo8JfXYvD7wAgS7+YYEXCbwQBj/JxGNU7qSdGlZikVma+gZ+CnfPeMQmSK5bpjDPHWrfc73us2xewX4z8x/fPFd+aumljPYDKIgCaExmJbhw4SIBS4JIC3R+UsU6cg4ua2wCCZSd4E0JmvuTXrNvWE0nyAh2IIU+zbDO4+UhvBuMplempvb+d2fm04bdtKF+yK4q8mR2Gg6BRbcfsiZ26ws6QhlCNVH5jsnGi7UtuCWtM2mRVk+i3d2QaLogj7zOKnFxMZrYkPB0C82D9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Finn,

CC scsi

On Sat, 21 Nov 2026 at 05:10, Finn Thain <fthain@linux-m68k.org> wrote:
> On Sat, 21 Nov 2026, kernel test robot wrote:
> > FYI, the error/warning still remains.
>
> That's because the qla2xxx maintainers at Marvell did not respond to any
> of the three fixes I sent. I'm not a paying customer so all bets are off.

That's "[PATCH] scsi: qla2xxx: Rework BUILD_BUG_ON() assertion",
first submittted in March, right?
https://lore.kernel.org/all/4808a5dc1a71528ffa3360868561009744277450.1791502886.git.fthain@linux-m68k.org

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

