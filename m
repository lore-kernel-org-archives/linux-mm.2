Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7FF5CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1E68E0031; Mon, 25 Aug 2025 10:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199D08E0001; Mon, 25 Aug 2025 10:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF9C8E0031; Mon, 25 Aug 2025 10:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E955E8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:57:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9CB31A0466
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:40 +0000 (UTC)
X-FDA: 83815583880.23.33BD9FC
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id A3D8A40009
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NNs4h+ms;
	spf=pass (imf04.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXrNbcwSvagaIiS5O7F6FLpYe+f/n3DenUIqxElurVQ=;
	b=vMeNju/2wprKi6QfQ8zl4O3SSTo4xs9rxjRmNlThX2ZS6W3kSOVu+Qemnt23/Ukh1y3Pjb
	ZicMeyt0RTGgt91PK17IBsZ+maI6uAoHl0sdoVfjdG5hE6SKon2Hpw1S4/9cVElwxlo6qi
	HNLjVX6zZYiJVjo93uguKtArokzfWPw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NNs4h+ms;
	spf=pass (imf04.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133858; a=rsa-sha256;
	cv=none;
	b=2Epg1alKb7nheMVZbscW+BzIpjLf/FgcQTvKKB+sSIQq/4A2ljMbs482Sf0aI60Ey5MQP3
	e4n17gea1LnKzFSZeHO/pB0XkMkAk7+pusBHgcPEDzadLcxOCAPYqTKK9+6qtIcu6/1EJy
	OuVRvp+VHlIXItA1Oc8tFG0EV1orNVA=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-771e4378263so811365b3a.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133857; x=1756738657; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXrNbcwSvagaIiS5O7F6FLpYe+f/n3DenUIqxElurVQ=;
        b=NNs4h+msL84coX45+1dTgPojpPQazZT4zfzVlTzKkVNaFyLrFDdflbHXPTOdFOJdFG
         zQ9oIbfI72lpGLfRGzoI2Ed6m8SBLMlamrS+zUMmshSQsDNgibm0dUxU45Wuf1k1sNAY
         +nUfP7HiDZjNdGsm7q8wpdoV6nagKq15Om+AY3a91GE+AAsAMKk47oJzYJKRat1dMWnK
         +zcuUjqi7aw/WdeZixTy3q3mKKBn1QFE5yK6fTejZcTWTsIEv189dxJ97bJ9Y4Yq8Gis
         OEH7pv0qTGqOWYpXjR/wmKoKieuPF0XQmJLsNcoVtuVFkrzju/bgXY0qWoe16whrxir5
         mEcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133857; x=1756738657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SXrNbcwSvagaIiS5O7F6FLpYe+f/n3DenUIqxElurVQ=;
        b=wH/zSQdHfHNkZkavILuyvYcue/1hQpMTWFHtXnCbnf6GnG/iqbiNcytuDHJOmfbv8p
         nyZiqL3j/qcVgyO0yhzTqvK1/LgXoRTjStaCAsLV2QpzVDCwKRQnGXifwJhFTrOz+jQ0
         Q/4RSPaNJCXwOa3kLw5bGR/kv+YmZl7RgHQ0oT/VMNHutNmf92Fx+DzJc0UJmmC4EMdt
         WMUlmfPafuwi+3cT7eEvWH5oukW5TMtQMCq23s+e4bEYOjScoqTHwn9ll0pmPnrivToF
         1cigwxEbnegfoimGGYXCBXxR7GHm3/Nnitlu586gsR9X2unuEXdKrva2Om3t+c60CCqY
         EH1w==
X-Forwarded-Encrypted: i=1; AJvYcCUUKO8plmQeUh4QVg/QnE5LCRfVh0MpYtklgL9QornUNZTBCcFImkvG06hmSzMM3GI0CjyVUX1hAQ==@kvack.org
X-Gm-Message-State: AOJu0Yzdrd4B4/x0RGr8fPz6YQeRX6bRYrPAyK2lnklzf4A1L+Nk1fqW
	8Er2fYjqhJnSe3k8s30R+wergChr/+apCVXVaIAmd3zTju2Lc0dQ8B0gdF+0wpxXB7lcCk1RWpi
	MB/x+x5A=
X-Gm-Gg: ASbGncuMKjSxwP3noU734lVUUwhGRxgyA/XWBqgOLRTN7pKRK2GO6Xwa8KFNrODHj98
	cpMWWm+zAKYILEt0IaE4bDkFIBh5BDNHlWXopr16PL36GCHkO+xnOdqBjnhDX+keuu8/Dt1RVzV
	po1BJrqycXGlse1TKEA/LeKBCqBEx6oiEy4hyktcpNEWPuiZFc2j+FKRXAEnZJt9t9wikiPX2ZL
	u/znP4YLxqR3qP7JNf9FhxTTUty+KUkrZpCWRCoQTAFSBkD/0mKs4gKsnwzIvtNd+ZiT6uUPTUW
	ibmnKHOZOEiTYLdxEGWR5hY3vR0qQ1Trr/Fx86vPQatEslBKqty9jvUnL1pqkDYRlWAE9Z5YxC+
	zeMMd4hbc7+O1rcgo+/B6QI09QdChBnNiJ4ZyLUZ5rvJdIOyLSz/GcQYDvOev
X-Google-Smtp-Source: AGHT+IHPWyaefTjVEriFn6wD+uKtAOPue43MQG2E+07bD3h6ezfyNYQoVQXZCOE8Earcz4MwE2e68A==
X-Received: by 2002:a05:6a00:2991:b0:770:3c63:5906 with SMTP id d2e1a72fcca58-7703c635b38mr12867003b3a.14.1756133857394;
        Mon, 25 Aug 2025 07:57:37 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.57.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:57:37 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 2/8] mshare: selftests: Adding config fragment
Date: Mon, 25 Aug 2025 22:57:05 +0800
Message-Id: <20250825145719.29455-3-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A3D8A40009
X-Stat-Signature: qo1k8c73r5aiaja13khkc8ddxtagew7j
X-Rspam-User: 
X-HE-Tag: 1756133858-105266
X-HE-Meta: U2FsdGVkX1+EwGYG+CJkgn5kBKFVbDzk2xluM6NZPor3vBh8fdwceAMtxlNfoLgGLk0SpvzqqdMNLSijWHhc5KAHxY/3g27fnGk2VrygywuOZvqqlxBUwbXbdGf72i+7vPHXQDYLqUYQqQbMVxgp+gLGHfO+R/vTby2Dr6rzvpD9u5Ev6t/73m/j52Nwtcs8ZogA/mHD+bCGaE3rfAkkaNeVH5U6ivnLzzIVCSMIJ3jp2h5QykAIG7i1Y9a+3vNff508VYgGiDYXliO6P4Y5ydKENWGQHcXIUVpaANb/KVmzxHjaYSA2+7sk6wq9hxB6Xgcf6LBDanuyNvCy5WrliZGyaKuyoCchH+j2od2lB56jnIq+zf4gQH2nwRMbPgJiz7RqHdun5vkGM7VCAk2nAlVoImB2mvA55h/x7JqWszHTl7SDkkUEJg2F9W5/hw1YVIlmHDxA484e5rWWzoFFsvi590nU1gm8NwpvEv+thcfezosCoO7UrTojFGE5tJuu4hJ/VGTdpTmIODEl2Fzr4DVIiU1J1ZVHFucWmXS9efp9ncVUKxYIA0RRt+mmmsPXIaEweGL0xXaKvB5ySxROOuf3nn2WTE8ijRliF81I0ozQBDyLqi7IV85G9JojLYrrA+OJ4UXLoudCjyqbNejQRuemc4CRMRs9rw3hkkODs5bvYBtAK28A6/sz88PUCvpd7CwKk6RrhYNeSp18Gp/iOG1UHqhbdG38LqaCroFHL3Z3SMWs/Ws5KoZCNqu+y403dkGQCvvXVtvfg55gltxxRC33YFEZiU/WsHC031N+YbeXNYDOkybOiAZvFvJtadfY6BXgqtpb5QBctcFq5szlUIf/73QhE6T4rvIPNfflLGpc/xj2MANZhgkamNjxueHbN9GjsTDePaguHw3OOkjLkufm3m9LMf/f3TiJWAhEMa9Ut1XbesxNMlrrs2mHIJDJG4tSLV2SYH5cM+yCMkA
 xqJlF/Y9
 RasWaXCALaHR+yFvSwkarFO6p/Ag9tChnwP8tYq0gFvQB78Iv0LbrknK41zOBpNQrLtPRoTmCr8H0+GHe3fUMIhGBg8qCoMFeoSFqI3h9i/t4I3ALi+Q+gnJ21WPuMzU825yArAegXk3u640w1tb2pQ4L94nZSTr/+0d04m3QYW2WR2BlD76ZDXYKnvU5rB3LhI97woC7VXF0Mp3no1HU2H6ad1aeaMSFv8Hg79VEH2y7mYvEwye/aqGMNVI5uvlxUlrShB7aCHD46k10TCF65nujsMiuhHyRc6xBMl+8nyX3JEk3W+KOugdCZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mshare test cases need pre-required kernel configs for the test
to get pass.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/config | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/mshare/config

diff --git a/tools/testing/selftests/mshare/config b/tools/testing/selftests/mshare/config
new file mode 100644
index 000000000000..16fd9a3ca12a
--- /dev/null
+++ b/tools/testing/selftests/mshare/config
@@ -0,0 +1 @@
+CONFIG_MSHARE=y
-- 
2.20.1


