Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D766606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=kT2nuEob
Received: by kanga.kvack.org (Postfix)
	id 488C96B05B3; Tue,  3 Nov 2026 14:21:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B7D6B05B5; Tue,  3 Nov 2026 14:21:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3289D6B05B6; Tue,  3 Nov 2026 14:21:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 065DE6B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:21:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93207C0539
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:21:32 +0000 (UTC)
X-FDA: 85394776824.19.B072CE1
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id ADB221A000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:21:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kT2nuEob;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793733690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0uILcWGxRJkmEp+n0zS/w9W2zfSCMknq4cj8Cc7NJqk=;
	b=aNBHwtr2KJ7yyj//IWb/oSoM4ttAkc8+rnaezmwSl/T0XKSpiyYSdCM819HAflZc3bny30
	F2+5np/7UFVTPHFs58e+itiyiVWf8eFIQSLa4ksI+jT0QN1UN153FbJFJ//Opckq4Bquwv
	gCS4ww9r8h/CQ+cKSEedA3HO+Ybpa10=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kT2nuEob;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793733690;
	b=RpMNQR90F2UXEvanc7qO8CYtgnh6pLG7rF9rdjvekn+VvZSvoqULBFcJ+biupf8+Qa9p1w
	aBPb+AQWZaTJLFCrwoiXR7Sj0CXZjsrmiINEr9yyefrJE5SZRMP/4Bz0kdwCTeSXP7UeSv
	usI2ZCf0pW/9liaMtY3yuU3vNYn+M/Y=
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7cc0e865dd1so1536005137.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 11:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793733690; x=1794338490; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0uILcWGxRJkmEp+n0zS/w9W2zfSCMknq4cj8Cc7NJqk=;
        b=kT2nuEoboAtJRtLbsS3Drs2o/LqNyEMBjlstU/ewjWt6qvIWCKYzzESyiDeb5XzgDC
         xFoqKCe/A51FNyMeXQWfpsTCn060kK4CHitFK3+LXS04zFojCw7iuHNHeAEeTfx27bz2
         EvTgh/9Gm5RJ4AblZGiUVUqIfbVIWrBLaaxLg91BQONDTbpOZZIAS6r2auSfPu9lUUN8
         2uThrEvEdbtaX+iWu2iwsauYFvoXEF9+8TjnR6ciQBSrCo7ew3wJ5oEraRmEUCNPlu6l
         Rs9Rh87+zOxo7dQSNrQgWZfFIL24iYOSd4lx9ckFfc107BkF4oT7humDoR5tuCUUUZyR
         Rnyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793733690; x=1794338490;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0uILcWGxRJkmEp+n0zS/w9W2zfSCMknq4cj8Cc7NJqk=;
        b=J6cj8xtSALhyfFtI9sHDSUZXMS9lG4OPiKS7mPChAppz6aKiCkeYa/gh3TNijijh4q
         7twIqli1J5KSINIrSeK/fdjoHypX6L8idpKCvYcicG4LQ0V6NT9p4rDh8VJS5wHoLSZn
         Gsnt9DmluNBatQStiqZ/LjiNGdr8iYvraiNS7HF68527TS5DFPDNbtIR68yFI8eD9xjI
         ixkXvRTGMCMaAFvWO8JGJg10YO0dDkdbMO7eCLMtcd2+qIsR5bD95vfak4b7iIYeUqqM
         A4nmrwqQbDlu76oeYwA1uT27dCuRnSwhaSYQf0WbL3UqNr7He5Apa30616GvYUyH5VMx
         HqJg==
X-Forwarded-Encrypted: i=1; AKwUvByIBhh9F4Cw2BKvPhArvIqOOYZj27Ec6ggCHAwbvDzH09swB8o7YNP+zTO4qdOS99Qs5+Pus5mqsw==@kvack.org
X-Gm-Message-State: APuU4Z/OSXaUktI+mWn+mWMdYmjxhn93dMujGKA7tnpe8jkPib2OddWo
	ToxgReb4oMrcSIoUGxVMYxNh/io1ojYgfxkCh7q5pqNAxYAZD/twdtAbKzecs63mWaw=
X-Gm-Gg: AYBFou0NlwuILdPpvU3a6Y0wWpIqsTuCrPnk8vHvet+GiB4EOuaTlQu3qthaG5bCk2a
	wjwdbd9IwhcW+Uqd9bg5V/tSySJeZvcuHD4BI7Z7WGnW0SXt3mnR62qa2l8+Nj32jbllkmntd7r
	gaQXeACkTGCAxGiymFcevnV7iMuNhFv4pJluxD7NAWIqA4RaaHGuSSawF8FZSJKEpNFQ708XDFn
	TdiZIZhRu5Lylf+bXKJFq4HIHY65AT9zfjrNpHrJchFZJlJw/1OezFTgRnGxcbMId9YTOSNYquA
	uLcOSsJvTjqhva95sykcDH+sxqblAXycM2luiNl892rF0NoAqioSLUu64WeO9UE1Ns9xq1NCkdn
	6q0vc7RwUbUIBHdP0Lu2MdJKaYVKZ0fGPRCWB6ErmANgm3W2UCEF/UjPZXwBMKmS1QPFzepL0QL
	Gkpz1dKfxxO7mJcpJeHVhrg7AQ2fnJyFSaiQd+9C4RcDL/9c5TKTkTNukgM1TbGurhQ7LXGUFjW
	fgAGHdcuOQXNGXrJ/nS4/S7OSPFaQ1hoYnZ5vbxrR7qehPSMiRoAgS3cMiRM6TymE11DWbTwgtS
	U+qLthy1g4u5YC8mHqNBqVZa8VCoiQ6NHQC+DyN46/hsid7NvtkBZ3PrFy1Duhi24VI+K9JNJo7
	TDJwjy+k3ldo4qasWHJ252Hjm4qdAmAUO+lPsKAac414zhg3h6cm3+a4IV6jXUoAiPgBUUL9HmQ
	==
X-Received: by 2002:a05:6102:6c4:b0:7ce:78f9:adfe with SMTP id ada2fe7eead31-7d072c17d00mr5173411137.18.1793733689733;
        Tue, 03 Nov 2026 11:21:29 -0800 (PST)
Received: from soleen.c.googlers.com.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d999c2ccsm560241.9.2026.11.03.11.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:21:29 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 00/13] PCI: liveupdate: PCI core support for Live Update
Date: Tue,  3 Nov 2026 14:21:10 -0500
Message-ID: <179373348545.623992.16522569527665218421.b4-ty@b4>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ADB221A000A
X-Stat-Signature: cb6sxi3tudeyxtq4bgt87f7e6g8dh8u5
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793733690-165586
X-HE-Meta: U2FsdGVkX1+mmeUUmHRX9bkiJGpS91Lpwm4V44Uqf95CLdIwDuA1wnxM7AhaudBosY9IApmovN1bJqV6wmWs0XsffgV0d9kj6rJag3EwHBgdY+367+Szh8HWpauxt8NwyZHtvQ2H4lzSVsV3y3cGoY4iHCnGvumV9csFxE3u/Z5G+3kzLsW3SL/fhgKqgduNWxM110U6dyRMZifJaQcpZrc+HXB5+gyBEOgaKjeHq5YLpSK/fcOCQbnbtS5p3f+Pcs/fxIjEIf3u9lWUmenpMIdF/Yju7DWW0Wl8krU7s3QV4ERqiJB7eGYqENbvFD5eA2xZHiPsDzQBOx+EOeOT+XKj61JAo55/e9twnBktPBi/6Ht7FSf7J/sBeky9LF9rUz3MxflCDS/sp1Y2wZIqh8UL3MPUug07nRLHMmg21hK8IkWkyYLXUIE5EOix7RVeaRQ6Ml6bQv2DqJQiGV8nHQY6VwqLIZvfBjas5Bs1ljgZedmPY2UoHknLZLw6qC/eBt5ziGZSDjm9R/vAwsuTufq/z2Hyipj34jDF5QtAU7In9n7Gb2uMiosMWUS+8BDuCQ9I6T97HCLR4oiq3RF4ixJCbfFB8wdNxbFDaC5y09QRSSvYew8OSgUAwH/qWrTjGS2+RU0T3ImhSumHHZCtTxNcxxTtrmp+r9L4yRaTXWVFHLxIrmuVPAJ0gNyFe+XIBNELauuUyYILFPONLjgn55QhLpi3J/bHupNMgVlVPQUIYgQ8x+Zdcm+qLc0VZPcmpYB7uM/MArtsw6sbtEm5I20Jbc/HyvZPdOdphnD7Te/RmHrNHWlMYFLt5gu9OG4bMSsmcro1sdYDO0XTYGhvvRJBmFrFk+OSYmWJq3MB81jq0UtazDkBtWzImsXp2LMzV5PWRYGjqe2SqSviltUnOcSvgXqRydjv7Vk89qEBEXCFL0MKgVL4HTYWbmQLF9b/pNNIsJahE2nHRzP+Rac
 lYX1deRi
 /06eekrVRAXpDC7mfNEiBon7/Xmz7wzKzrSTJh23nS+8BataL82mG7jqb9SkNZsUwelhgDThgXTRPSH0aNNpgm1P6YrlTL0q+/HspbhMzs0neQb2U+/3jeUcnuza8rrBPSkS0t1I7wUmdW5nWRcBV2jMEDL/xrQ+/k8jnwmki0fZDXdXKjhU1wphDQ1nSsvFVijF5Nv3+2HRrDX3iEgHhH31S+dDYXSBBz/Ayo1Q+sqUQxAK9/sMGt1xyS+X+jEDQhaJdPbMH6ps2ycucTpn+I8w9HgwGpic/A9pDgir7h/RsKjYZ5mmZRCSOrbONktqLs2RH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 13 Oct 2026 16:25:16 +0000, David Matlack wrote:
> This series can be found on GitHub:
> 
>   https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v10
> 
> This series introduces support in the PCI core for Live Update, enabling
> drivers to preserve PCI devices across a kexec-based kernel update
> without interrupting the device. This functionality is critical for
> minimizing downtime in environments where PCI devices (e.g., those
> assigned to VMs via VFIO) must continue operating or maintain state
> across a host kernel upgrade.
> 
> [...]

Applied, thanks!

https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=lu-pci-preservation

[01/13] PCI: liveupdate: Set up FLB handler for the PCI core
        commit: f874391deedec9be601bc044f2aed52a267a3671
[02/13] PCI: liveupdate: Track outgoing preserved PCI devices
        commit: e207461556c0d3a42fd59dc548e9e8f599aae298
[03/13] PCI: liveupdate: Track incoming preserved PCI devices
        commit: 42907d099a3c37f5a089d92465b3a61de9c7cbea
[04/13] PCI: liveupdate: Document driver binding responsibilities
        commit: 78d4d22c0d4e0830a5db9b903f1325b7fbe0eb17
[05/13] PCI: liveupdate: Auto-preserve upstream bridges across Live Update
        commit: 8178f14641e2d7acf648acc33a0cc070763250af
[06/13] PCI: liveupdate: Preserve bus numbers during Live Update
        commit: 3f832a32a1801a9e7b1dc4e88a3e1744a316b538
[07/13] PCI: Refactor matching logic for pci_dev_acs_ops
        commit: 966230f2ebac2013f60ba6376a6ca726f6427ecd
[08/13] PCI: Save and restore the ACS Control register and Egress Control Vector
        commit: 88016172c5585b1dd0d777ec529fcac577e4e94f
[09/13] PCI: liveupdate: Adopt ACS controls in incoming preserved devices
        commit: 1fabde9a0e4964ac43e8ef3f0c9619d8ed80cc23
[10/13] PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
        commit: 5506c59d1b844edad5cf2a704f8b87b353b3a2bc
[11/13] PCI: liveupdate: Freeze preservation status during shutdown
        commit: dbe2c3dfd43f9aa094b59669b81aa92b8685d23f
[12/13] PCI: liveupdate: Do not disable bus mastering on preserved devices during kexec
        commit: 534abf9f0870b457e1e6f4ef8267b0471e9d2c2c
[13/13] Documentation: PCI: Add documentation for Live Update
        commit: 5d995129832f72dc7a3870eabb216d487a145cf3

Best regards,
-- 
Pasha


