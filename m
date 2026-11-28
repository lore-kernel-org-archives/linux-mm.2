Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E38606A321
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 08:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VIuhbGPe
Received: by kanga.kvack.org (Postfix)
	id 8A10A6B05B8; Sat, 28 Nov 2026 03:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878936B05B9; Sat, 28 Nov 2026 03:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D176B05BA; Sat, 28 Nov 2026 03:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04B1B6B05B8
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 03:14:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64A7E16031A
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:14:22 +0000 (UTC)
X-FDA: 85483815564.06.306354D
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id A4A2920004
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 08:14:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VIuhbGPe;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795853660;
	b=TdjZEyhsixNV5orcxtSvV9ITo+RwNsrZbcd2cJCwVNZzAbT7Hv1W+wvLD5fBhwS+Xv+TE8
	zr99Ptusn1YzuiqGuCKa4QWhSuzpJ94Q+wf1Q8ToOz6ZAjuuEj0joF2+YkbGcj/UYIFf6B
	J/75gpf3mJ6sxqynn8et4rdK7lfXcyY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795853660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5cs8AaJOdV3ZQpL9gyqbXhUnUJiadTuA1kMgyOem6I=;
	b=3Qx3CwUiXZv2K3b3LV0jA4bwg/axXOpG4nsuJTmHqCAy+7ztfjDdgB9w8waEzPjAXJdtlH
	khw8iB1zhNN08LclUk/vZYsBrHI8j1xVLV30un37P6X01yS2HoWe3dLZDcBBssdpGdBreH
	eshSsiwbasy6ZQzzX1lkADH16gkBhyY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VIuhbGPe;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-386cf1041cdso6437700eec.0
        for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795853659; x=1796458459; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i5cs8AaJOdV3ZQpL9gyqbXhUnUJiadTuA1kMgyOem6I=;
        b=VIuhbGPemFX7oezm8DZn/WfEdE/vEgZeTenOvTzl8A2T6AqQ97GgT0igD6fQ4hW/cN
         kV2yICU9cggTIQooiWQK5dj/GOrZt/fSCv5YM2jeHzxKK9HoqLpePQLERuLl2mzS36Sh
         qAgOb09cHuhudLy5V2M/TRoHc3wrs9155a6wKt1vQD8KwoqAzdSyMehJWb1hv8gJjB8Y
         OMJltKhfWUYlSMPaZ5cl+67EbNEsCoof0MhPcnpc8r+VKgoLxsg82cjssNzqct9XTCDN
         q2ohfyrB/r8N4FbfssMtXuMGK2RSUswOoGq8jPnzf/w0GuW6hq6tz4Itu+2Dkkg2spNH
         +6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795853659; x=1796458459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i5cs8AaJOdV3ZQpL9gyqbXhUnUJiadTuA1kMgyOem6I=;
        b=Sn2pyAfrsA71kSzmzdJEuvaZ5TnVsDuABTSR86zBMnh9Yc3pQVLmPwSEDboccbMfig
         IwJMSiLgBUwFwPtgixjVfvkQhIwMGwt7DwSs6xyBUKNa8vhD8L7MyS3EiP3bqExDaQ9I
         qrFW3D5fD1C6/8YxYdYYklvRsQfBktmYpaYn2ci0/YT8tjY/wieI53h+BB2CMtsd46cU
         dQu7WeAJUapbMu60qJPBqTWwIo3Bo5LM45915yVqUmP3Fq5FJb4Idf/fmWoyHnshGE2c
         wTu2eMBvVjujzJGUuszYoROqD0jPIeRXkaCbICmgv2nxPmhd3pSNGDpwXerwiD0DrRnL
         zYtw==
X-Gm-Message-State: APuU4Z/CNPZVuvGv4lNLfa9aEHv+GLbipbmHrpzeLnEOc6oGNLSppApN
	bed88g21I3cC0JbpOaltHMbetp2xOV8vDTPTsRT/e0WRyUooj+xT5n0M
X-Gm-Gg: AZFdTZe6IUb1ohk0iohxF71enWZLlHFR8P2RbsJm4lDF1Kvusm5AVOj4SwrsPLLPDWu
	tEWTLk9kTOIGVTWC3KEKMyAGCF7IEFPhDbzDukiOGRRSluqj8jFzvTo3Rwa4TspZgM9r4xYbyJA
	z53eunAivgWk7lNyXFVvE1RioPFb8TWbXvCeRJ5nCqekmcjDWFrijlXljqAqij7vnZ6DalhfjYX
	l8sVfyW/VG9MBIhnAVX0oCqfPhYAdiiFD5sIgr1yl/y6yLE533Agex4VyGBQJMpMtkbU+JDJvne
	7Akj84DYrxuRCfteazS5jk2AIbDW4SkXf3egrtpWC1mu2QOmgfKQIk/9g3DHKwdszcTs5DAyZYj
	mFXNN4JC0IGz7DEKzv2jCHsvtv5YYw/n1o2c4Wmk0TymRAtDqoB5xKuQBjbonjXYcO65cePDT+x
	CKIILca05ppTsRfCXGS9N1Mb1gN1/TsYW425WHCwL8MzE8vOaloiX/NWTSETrTDotUVxWe05UTt
	ZW21zkBwWgpFk00z/pCtZ0l0NV8KBGFBdz8H3uws8CpeeTPT3OteH5X3KYErjQKR5NUPYYsAcM5
	w8FFNl/wPBKhkP/fsxuDBq59o12hTggaWf/tldsYoLywPxWjPDE5G8Zw1L5/Ozno6PuObvk0jOH
	aVH1BFMPqsmzdbA==
X-Received: by 2002:a05:7301:2108:b0:386:b99:8ff9 with SMTP id 5a478bee46e88-3860b999354mr23638515eec.40.1795853659296;
        Sat, 28 Nov 2026 00:14:19 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-386f6651e2asm5676959eec.27.2026.11.28.00.14.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Nov 2026 00:14:19 -0800 (PST)
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
Subject: Re: [PATCH v5 10/19] mm/swap: mask the off-list bit when checking whether swap is full
Date: Sat, 28 Nov 2026 16:13:48 +0800
Message-ID: <20261128081400.38292-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CACePvbWk-TK+VtiD_0ByM_pxXzyHhZiW=C0LB_mH2FtBXH99FQ@mail.gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com> <0d61898075921b05c626accfa34a60e16472b556.1795439990.git.lianux.mm@gmail.com> <CACePvbWk-TK+VtiD_0ByM_pxXzyHhZiW=C0LB_mH2FtBXH99FQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A4A2920004
X-Rspam-User:
X-Stat-Signature: x6eg98unmh71nwpgm3nzqonu8npymsqt
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795853660-658754
X-HE-Meta: U2FsdGVkX19aljdXlr8GmLKGFwG3eO76w7FtKkpcIQ+9ZbwywGbMeoWaLWldpEXHcjrdlcZ6oB1olM9xd2743IDmd73lTV4jSQ0lLqIzGAbkieFQ91qUz8MDoYS4d5L9i8RR99mU/Y+cBBMneg+l/Ql5L4chTjry4T8Hnd9WgHY3fewENWmcazuKKXfu3SL33vX8lqWnO1FR/dpPLc2d6rsaxJfiZuQdQyATLLRDwE0EioQw7KmS5+usbzM9wj81JJmhGINR9u33xvJ/3sbMOmD43eVqCts8e+uVwkL6XZkVroQsA7cpir5cKrKjAH9jcR0Fmdz5K4peLewk4oCJuFTCPpcJ2KVgEXmEGCDNHIC7Tv83aMVV53uEH9a24VGwh6CvZEt8FN/z17FsOurs0vYtqAWaxGBNitkIiMHz/UhLWMmQvUpgboIJcRYT39quKhPmY4FATY3vDHIVd5TQ61ji7dIVkDo56x+W6CUsxVitw5cFeiScvBdJO4z8BpWRX1PtIQKJKSpRwrnBCOr3fzBcIOnuDihGkinb/0IF4wwC56Nx9Bd78f3Tk0xOOs5s+Mb6gz6TPSDeeS1Tx1xL2n7UFc03+d0QWW2a79cZNVXvwYEqTFpnr4+2fi9wMQgMkCtpAG0ffGiLgb0ptvP8EUfFrs7HuhL5LfUpmTLuOL4li2fjc6m3aJ/3QlAWVfFgmdvY7lqt02nQc/FBuDzQ/onO44nMXGFQhiJGDfPG2pRg8GkOXo9lDs97yTfOcsDcuf4fJ/H8jk39j5SK1RWyojXS5I6EtusE/ZXT9L/dKrPYaHj6/sFIaqJoO8WmdE6+vr04mrHDPv/KMpJMaWtDK7P4o/ibi6LKlNRSVKQpAA2aksaUeSlweDum2i35vZNL9T2aPmLo06m0V+pH4CH9l8QIXAqxUVdw5Gz53z5p1DH1WJwelqXKWjkWDVg+QOKpQbXh5uWCswiVAe0bn8b
 j5BgEssM
 ONDKdg/bqzLY2Rjr/iMwiSKpDwGFSZO/OeTpmPmDf7L3xJLRNjQJgvPwSr7f7bizpSZV+9Wbaue4ZKTqbuslqZN+fJ8CMr3sUOaw5ssFEQZNRZT1/PydRLTYK/OG1WBWBYw2UpDnKXWsf/MHD1rp5ajsn/Ksk2ekyFP3jwpouikK86X9WSR9qhcv0y6jJ9UH2xxkEW8mw4E1nSDJsAcjpGgpFkd+My9lorUJ0wLSjF/AAqq79XT/T3QS1MPoqPP7qFGDEe07dSrm6LNIPoyW+3o3PeIO6TRBoguT5fMjtHjkHNZyPk2yaDpsiddJlLfjFI9En2ge1IfRw1zsuy5Wa2x3o0gmUn31zKGCixB3r/O4QduaaTymRPci42tvafLEyglhI71sPMQ2XmpP2vcGzwsO7nxscti0k8HnO4os/i9SRIAQf2waRzyl4NrtwZmR9ePNsNtTZbmseb2OzycGRKeDjTOUsC3Mknh3DGNTps3b/hI6o27/OcfI9ZaUG71LnDEbz0d7mQs2wzWKRRQ0Bk7eyATBfxgt8+meFQ9G5o6lHMODyIVSMO/5HQhxS/ZR8Hh1J/mBiw2dvBs691+Ut5RNb4N8o304QN9S+zWmMSjCQ6A6SG+e1aL5ZaoF73YH1ptuAfDrTIu68XzLe4YhKzK5ikzYWrbkpvJxuK++rNF3NOilzWM9y5fZvMLx/hYgC9y8B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 26 Nov 2026 12:09:23 -0800 Chris Li <chrisl@kernel.org> wrote:

> Acked-by: Chris Li <chrisl@kernel.org>

Thanks for the careful review, Chris.

Lian

