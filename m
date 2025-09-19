Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9DA8CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 20:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21DB58E000B; Fri, 19 Sep 2025 16:08:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD588E0001; Fri, 19 Sep 2025 16:08:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BCD28E000B; Fri, 19 Sep 2025 16:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBC7F8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 16:08:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1EA5C07B2
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 20:08:01 +0000 (UTC)
X-FDA: 83907085962.14.41FBCCE
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	by imf15.hostedemail.com (Postfix) with ESMTP id E973AA0006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 20:07:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=O+mpLLd5;
	spf=pass (imf15.hostedemail.com: domain of dgchultaeiz@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=dgchultaeiz@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758312480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1M+36cYafTnM31hEs7Lp+sthNpRZuriINwS7pHsmmR8=;
	b=eK7fq7925Anv+vps5YPTUEu4X/A56+dCDkl6YIkY8xkaMGfF+NC+QteXCa683ZCqvF/Zn0
	NfoRJiTpD7RJacaCbjzdaMlO2tO7B8Z+LIW8RX2GN3avS9KwIrxykY8lXxJyfHU2eqRy2P
	oV01rn3bIbx2GItw2TK87GzpMuqSPVc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=O+mpLLd5;
	spf=pass (imf15.hostedemail.com: domain of dgchultaeiz@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=dgchultaeiz@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758312480; a=rsa-sha256;
	cv=none;
	b=GyhypE1NAntMf/WGJrji07SK/sAgKNDimcAa+ApVDG0RDmiaso7Kd11Ab9j+xLWAerxA26
	r3qo5S288iSbDye4AK2PE27pf7qhLdyUrRZ/r07ukAG3aR7Ux0zfLRQSVBHLkJd5ZGJHTB
	2B2fQF1tYDGEtRBJjEnIsMLR6murPfM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1758312474; x=1758571674;
	bh=1M+36cYafTnM31hEs7Lp+sthNpRZuriINwS7pHsmmR8=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=O+mpLLd5b/fO3AJwf2wLcD4HH7ME6kH033QSI/ZYXcu0o/a/ogfSURFKmXSsORfGT
	 Amy5xaMoZDdP1up4mI250zIJB0QEMLPVLkr84XedrNgZXAProAjxvAWNFLhkvFrrgn
	 wKQ8Lm+Coz4IFFmg0iQ/m/3z6aY28pf87e9lWtuB4ax8m6FC7+iizvFOEQ66qoHn/+
	 feLc2NyBr/DiQgVrrs7QmIYRW3/ywLwlxS3LSj3cI8L7Z+f0I2HKhYKFBmdGiO3hyi
	 BchYz/tLa1xXA26MJQgRWjNmRCCSe/lr4UeYYw3h150NtjOv+unb0T+KHwnArUGMKx
	 YwY83HI1TRZOw==
Date: Fri, 19 Sep 2025 20:07:48 +0000
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
From: "Daniel G. Chultaeiz" <dgchultaeiz@pm.me>
Subject: (No Subject)
Message-ID: <FcGA3wq6rWvSB2hsmXrOkDtlRHfhnAVfLzKc9VnIz_Dx-3kDVRRsh7_5y5jlAz7wPJtRVe2cZrspbuqG81Mv7X71hO8W9y3IjIdARvKOZS0=@pm.me>
Feedback-ID: 159560255:user:proton
X-Pm-Message-ID: b462df5ab307ac2b7ceac07e1394174fb0e28aac
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary="b1=_J4z3FifTL4MgBCCXpHLgOC3aMkDl6oxXEqnLvoGBnmA"
X-Stat-Signature: 4kq5mxariwqexaps1u8qkjhussgc9dep
X-Rspam-User: 
X-Rspamd-Queue-Id: E973AA0006
X-Rspamd-Server: rspam04
X-HE-Tag: 1758312479-885291
X-HE-Meta: U2FsdGVkX18z4hLqG9mzxWqAYDRMCgb4mbF1v1ytcijCqjU34hRM5QJsHTtCt9qoB9vryFiNtf8v+BRWUBDLnNP4cdQziw1cNop/hObxxruTwptpU5Po203VjMSB9G54tZYxTlsDYAavYHpZjIbbPdLWM4MNysEVZKjckqRPI2heBsJ1YMXMygBXL+bRxfMOUJIRwT3bsSbfhfBT7jKAumaRCYyBmtomyofCVd6xfyBGxxFZ2qHEn/xw1mN4Kacf5mW9+8RSHKBqV+2IIzgxlrOx2aR3RyTw/JQx+OIHpQxL22+DwrQw+Vm/VFQ/s7gz0KeIMacLqMYosZipCIK50dGx456OisfOuY0rHRd/5GUTsHhV+VfxBVTXEc2qWUgz0BPuMrnqi7gXkm04Yd/nAQgmMKqqJAvOavct1cYjOHGiOBhFsmiSIu50DUo1EsfmqZJ03fQDfYpqAHJcX9dsVokbbqFdEfR7ZZdoEwakGsBdLkCH1dacVkYt4L3HMtwicxpl3P00hvTnW4oFTlYOfc6J5EeeR+dF1AsXnEOPMQw7ChYPapuEhme60bhzehtx+rE5m49DUu4vPwF6qrDpi5PBi0NRVk+TdeK/YyiefLHm7RUbr1PWtskwrXCqfpnwD1ylD4fvDELw1C5uGzub5I02JWtnBRZbKQIjVNAxYucEjgooHVkoCtb/esMST0RqCvyA9Dlgafw9GmbieRzJjM90y2HcdZu8LRUCiKrkFmKtM/zxZOgCn10kaIoGAkQ3/E/hM9YOD3N6bYw4CwZSSohLvBCFcp4dy655NOphz8oqgGkeTf5ez8599opraoqJlgmCOTvKZnMBAdPMwd/PTwVDTWjGiAtsCuH52b3XHmNfBruziZvXKDrBoS2Qy/7ViEBskmYPxp9gesDt34scRkDSbAxRmusMoNtJOYAKEYooajxct5fdtQn0WnCRprPH9PzypfN2YRqQ8O9Cyfw
 C+SW5tO2
 j5WpW+BBhZ55kC/qgmg2h9i3ven3zWSls+W2N0eHh9QcVaQRcYRMgCN4zp6cVD8Zd6jXkbZjO0VROFKjcDDWqrymAs6vj/hsRRsRzAR5Kso/LIrx4gLYEQTqv7mgRUW20SNBsPvrQdktukZU+B/+EJQHINaSjRalO2cNwzJDCpn460TvAJb4aO/eYsvKjIrvNDsufAcMdGkuk6bsgOeBJ2nH+UJcTvS9LeCpCdXiZ/Az43jq9HUrRmti8MtxShXefZGTvkxX1wpIcxU/3wluFg3VOsSop8XWpsgIYRJnj2zpSObzRfn78xGEJEH30vqoRxmdSsGLkJn0VQ1bxuoFDsxHxHHcn/CZ8UCMmqqD0taR8YMD4hkvUP95w1RwzPjQvq9tkd6nul8rkahU3VhwRrshHA8hFXaA8gG99LfVBH19aMEzfjE6aoxE/LUeQTnlc5Vv+LZ+WbrdIeMyNJyslBOk3tl5beFo7VIBvHNauaG+8PpderJ7OrQ7WUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--b1=_J4z3FifTL4MgBCCXpHLgOC3aMkDl6oxXEqnLvoGBnmA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64

RW1wdHkgTWVzc2FnZQ==

--b1=_J4z3FifTL4MgBCCXpHLgOC3aMkDl6oxXEqnLvoGBnmA
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: base64

PGRpdj5FbXB0eSBNZXNzYWdlPC9kaXY+


--b1=_J4z3FifTL4MgBCCXpHLgOC3aMkDl6oxXEqnLvoGBnmA--


