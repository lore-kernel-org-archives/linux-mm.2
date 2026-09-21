Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D28AC982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 00:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79AD6B00B3; Sun, 20 Sep 2026 20:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E295C6B00D9; Sun, 20 Sep 2026 20:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3EA96B00DB; Sun, 20 Sep 2026 20:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2126B00B3
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 20:30:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D40CD16052A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:30:53 +0000 (UTC)
X-FDA: 85235889186.09.801D6F5
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf12.hostedemail.com (Postfix) with ESMTP id 265234000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:30:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="q/FDReCO";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="q/FDReCO";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789950652;
	b=QVipeqwXS4aC+bQ4rilssjLOaoM0EzhHQjHevMixXgRVc6SX41nqxq+dxSsLoRDp8KwUm7
	P0esaZySEC9s9CqEnIQix0gODuSGx56+6IEr/hGTDIeioMh8lqHFRhc65PnDVYFnP69PGU
	LB+sVLrZ2WG3qgm5jNTqoPxAJ7zI5Hs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789950652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9gh1EhGas2z2opfanmdNTY/ZLd4Wr396PDY9OySpgHE=;
	b=HwdBHxyat5nmK02qfKo8htzxb1J5+rV7jCZyzeaoz3XQW4hpP/iPEvXNtzDaHgyZ5sfR0b
	jodokgGCAzzT7DmPhJjAvrLTuSo+n4F2xDJrVPFZxqloUnWCpdvufeFmT53Gu20Do+/V0s
	iYgKBaK3XHr0Hfffk5m2HQe/WxAfH2A=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso17205195e9.3
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 17:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789950651; x=1790555451; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9gh1EhGas2z2opfanmdNTY/ZLd4Wr396PDY9OySpgHE=;
        b=q/FDReCOcoCeIXzmNV10IEh2Og6itqf3uHXBFNfPyGpcvmWhs4WoitmK/JiiPlMD4l
         TSG4bIzGD+PbaoE8L+oTVicB9FtG2zqd30jhNlVzQ/uDQo8C9VPoj8pDjJY6WJ7p7VEM
         4jd14GLHmOvLm7SBskAvVZxXO8XXRyarXtkeQWaXDWxgfKhcaJKewQ2Gc55ak8F32lhw
         vp6JwtwWv+0AJ7+22zEPObvrkIAF0OTzm61PqjG/hlauF18RdXnocG6ykTtIUlo6UQ/4
         QELYL5CVHum4DyQnPyDwbeLjjf+WS+qDrVLfCA/h4UuLjEYy7rHcdT3eCT50ktDM5Wb+
         PFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789950651; x=1790555451;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9gh1EhGas2z2opfanmdNTY/ZLd4Wr396PDY9OySpgHE=;
        b=Cwytc5O29GKyerYx7ALg2B3gRBS9ekjq1y+N9P2oqVg1mC2pb4dzRgmaiLJ4H2DJOB
         2GRrK4aMLeGc7sZQZrb6yha6eRmsTnRDGpxhnOy/Rek1tMV6n1wGU8aP7XFN1ss2476F
         XR5pkidrHr6C2HldWHd0ypl9fsizMC5nZc6HQAxSGVaBwp2rQAAMTTh4Bq7UZQGme/bG
         JWYeJDBk8aHY8L1v/5D8j35wsd3Qz+6d589wbK4ykRNS97vCvPCMbpWWVnNRUCsB5Nfa
         5NHcjt3213ZOTmLIkqXs9aBhZkEekeCHGmeT6I02Ux4YNjw1vpuwsbMi8YNSlm8sbqa2
         dlzg==
X-Forwarded-Encrypted: i=1; AKwUvBwFVQ/3hBYScNy0KEdCESU3yCyTlusoPk9FhK4gHdDfKjdzTsJ2mi/AuKxQYQNLlVS4gPLxYyrMjQ==@kvack.org
X-Gm-Message-State: AFuF++lLRCMK9pcIdum852yzCecsiHlAdFxdQ/Kh0rhJR+k72DH2b7oD
	U5utl1u6imKh5+fTyhQMVCEwpnoWjjySbai4jVxwFgfTd6LupSj9kKNo
X-Gm-Gg: AYBFou3c77OPOgIjg7q94f51PvcwBWIIVVpVOU8EOYZoLEeUegDXvHc2JEOx/8BXfPJ
	XpwowNBKapN5rDhM3yvYFLX/ctkP+h/aAfpFiYCyINGoiPegqyYsgPE8qbJYTwCyf4lpNyytYwC
	+L+dfYj0QROihaXR0LaMYWEVdJR380OPpC5XyMuKGiR7M4j7s8VnXQr3MY9aJZLLRcmZcthhDzI
	Q16+IEIuUmNkVrAbf5Kga5xXbtKjg3YE3kmApz99YK7B/azEelfgUWCV/pMp22tam1G7DQI+Xsq
	cOfMoDVXSKycwMGkeekXfC9d50Q9B9AvCrb7oiyCTOYmNCO6VlVSt7JduRXlCBiPcMcMC+7WoM4
	e43CWgq930eQkdNP2OCi6dE+TbfmBrhKUXQzv70GjFVt4vTFL0zia/bByzbfW1QSDB2+7jEN9Lz
	Z20BEXOanXM+LAn+H7tEuGUugwe2SZ5vomTXXftiNzutkkRKlp9N/RtmRpaKMZ08omM3Dv9EsYh
	mP9lx5G7rdmXjVCYwogHMEMnlX1usxlHQcBTKz49nU+C9NGGFyyDRjUMWPnvEm1Qy9jCcky8sxV
	nC7Cz8t93jB4FZICFfTjQhq9QCBhSxyJxrUwCpMNTZIVIvFI0iCerBktYhXn6ktYNA8y9aZJOqC
	77w==
X-Received: by 2002:a05:600c:8b8b:b0:49e:663c:c69f with SMTP id 5b1f17b1804b1-49fc56d170dmr118923645e9.15.1789950650423;
        Sun, 20 Sep 2026 17:30:50 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a012-6c01-e0c2-ccc1-7acc-3570.310.pool.telefonica.de. [2a02:3100:a012:6c01:e0c2:ccc1:7acc:3570])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48724583fffsm17515695f8f.23.2026.09.20.17.30.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Sep 2026 17:30:49 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mm/damon: preserve quota state when constructing schemes
Date: Mon, 21 Sep 2026 02:30:45 +0200
Message-Id: <20260921003047.12041-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 265234000B
X-Stat-Signature: kijpsae8kxr3nb8frruwjmpo1xnfipx3
X-Rspamd-Server: rspam01
X-HE-Tag: 1789950652-243835
X-HE-Meta: U2FsdGVkX1+hu4DVTE6XHB+lb63/pxwJL3DsaFnWe7+tZkXZm7xe3QJsS9QK4qq6GwzWBsPhN8ruab0TcECfvAkz1Y7ScB3bCELEgoryXbmvQZcLSwa98T2hQQegwuAAE8f5WBPT8u3q2ln+2CY1j/TVDx+Ve8Sb1i/uW8YXjW0r/D6eu/06NpDhPMp89xcaJ+jGPaBD7FZhkEtvoeagWqFqB84CfHpcIxTnFxvQPuDGKR01b4A18Xh+OuyVC7r1rX9sQLmI3+dht8IkmgL7eBIVxNiKLYn/ipLrISJspKCkkKPHkHZI5tOHZ7RcM//qbtp35lrAN5UxzA4qKyaWJzW+3y5UlaHrdpKLS1/YnN6VGBkx1aRdFRpxXHbBfxkFk32gVjRdHGiHLUGu8jB0H2TnRQXYhSmUEdoj6XEBxp90ygBt2MKTBUy37lM6g/bK6zaGXqhhbWd490qlpws0HxaZjVCnPrzeXrpCDhJAX3fzy9qwzHKFCID5vUVvbfB7Rd0+00Rr/8v4rexYb22IiGrLO1T1uHrFDO0+6CbBUHxFYq5oS0lXY8qlTCTasMZP5VJi6YLXDbz8dHIl20dOEKrVBC4Ob1La4olxqqpYyx5JA8B5wALDEr4KTt+zuNHpIzLp6D9slBEe9iWIpJo86uWOVjgFraoqbTyQZDcmGFz0+++DPi5ctujTjcZyO6Gg8FCt0rZ1Djp5jLwoMHkZ7HFeHTKZ0XRTuFsV3V58/n73DJrB/e2EKN86YtVkaqS7xJns2Y6tOJ8VxRPOgxIGZMaHAb5YuW3IgQwvNWo8SYbcMujXHQkYa1lIYDZAONHO10U9GLMoJna2aFi4t+qrNy6wY9wvZ/eSVddT2CNhGwbFCMBYHgXD+QMVz8aCula7cTf2KWut8KV2BdiUFkyX9CWGV41+/mRWtpFxalhWwPH54GE/bO5rd7vP+RCEm0BC7BteICSCMasgPkict4g
 uoFjW6+E
 VXY7OAcQtqTQF2CduUrXSLFrDeOf4z7F2p6Mk7IRtEyOQXSwRcYKofYrU8DJZuN/nQG8lmhezZ2D0bM4pJJxe9460Oo6ch47SNejUA3pKvslHKtXNIPcLmb4jiyMyUrlD6VHLmnMMIvU31wLbfWl+zInV2wi327JNnT8ElV/hdaFe8JWr22OnCZlnyX0O5UOQ2WJhAriHFSzUoF/famXicn8mxkkJpXB9UEGGxBbN27KpNryYIkO8avqlXo4iPMGzxsjJhZQYIOhJxyG58OKG4WVVVKtJdA6ZYEMvg/2INvbrgKEyq94esBrRaxJUOzxbTimnignBp3SdNs/oaxLf/bGZNObjCVKKYtMiVKugpVz62OYDbfeTrli20++4fu7dgGGZieAXcQZqiMhz6r1RH6P8BNjjIbzy6Lmi2ctP6Yz6QEAvqD1UP2eTuoBAnBNPXXmP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_new_scheme() initializes the caller's quota in place before copying
it. When damon_commit_ctx() clones the running context for validation,
the quota pointer belongs to a running scheme. Constructing the temporary
scheme therefore clears the running scheme's quota state, even if the
proposed update is later rejected with -EINVAL.

Initialize the new scheme's copy instead, and add KUnit tests for the
constructor and for accepted and rejected context updates.

In a live test with damo, a scheme with a plain 64 KiB size quota and a
60-second reset interval uses its quota, and a full "damo tune" with
unchanged parameters then lets it try another 64 KiB within the same
window. With the fix, sz_tried stays at 64 KiB.

With only patch 2 applied, the two new tests fail on x86-64 and i386.
With the fix, all 43 DAMON KUnit tests pass on both, and the DAMON
selftests show no new failures (QEMU TCG guest; the wss_estimation test
misses its accuracy bounds with and without the fix).

Karl Mehltretter (2):
  mm/damon/core: preserve the caller's quota in damon_new_scheme()
  mm/damon/tests/core-kunit: test preservation of caller quota state

 mm/damon/core.c             |   6 +-
 mm/damon/tests/core-kunit.h | 107 ++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+), 3 deletions(-)


base-commit: 185111f116aabf202d12ce440c0f6e9bae073514
-- 
2.53.0


