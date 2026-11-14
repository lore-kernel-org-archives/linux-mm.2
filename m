Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE5B606A33A
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HrKfzIzO
Received: by kanga.kvack.org (Postfix)
	id 7586B6B05B3; Sat, 14 Nov 2026 13:10:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709216B05B4; Sat, 14 Nov 2026 13:10:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0646B05B5; Sat, 14 Nov 2026 13:10:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8BC6B05B3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:10:40 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89F2D80127
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:10:39 +0000 (UTC)
X-FDA: 85434514998.22.B120F44
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id B18F0140006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:10:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HrKfzIzO;
	spf=pass (imf09.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794679837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2tV4PJFJAVwFY0+x5FVmRJ66Mz8ksU1cklE+L0oAwR0=;
	b=ka/N5N0WgQ7oZRBTFeAa1On1rG+DhqSNM1SlpN2TcDEzhjfK1AO/L/EQgE+yYMEfL9HIwh
	/sCYYq2nnXcIGGNfkokObGvxcm7ruog7n/VSLYRcthf/jOzVRbxnx2ujXhGol2ZxVW1vS0
	899Ntd5QhXww9dxwj32oP7WfPlbx7Q4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HrKfzIzO;
	spf=pass (imf09.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794679837;
	b=Us2doGCfo8jAxdpqSsLeinmw3qQJWaN+o6ZEKLm2pXTL/qoHGtHHsHrjBS1GHfcjgT/A7W
	zn63PH9yDDZZirRWuSn8izuiOSvQ6K7X6WsyekuV+Y9VVATbP2l2n3MEOob2kAp9EmOYG9
	4mij4aig0TStr1sfcrHiCAloGh1OtuY=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso15433795e9.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794679836; x=1795284636; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2tV4PJFJAVwFY0+x5FVmRJ66Mz8ksU1cklE+L0oAwR0=;
        b=HrKfzIzOI8+DaO9CkC4RPGqBqHc8vX0CxMgMzxEk7h5Zw49nBG6LQ08hLSUSLbCAS3
         rUNEkRAkIg77CcUOUWfzip55wBsETX+/ACEOYK9VhoCADvj0XxVe31+BkUGLeG0SC0ak
         iAq8fWsF75HNQI61ltHHU3in0I5tFLtJ1Lm0EVU+X8HVQ0S2ufC0Mvi24cIqFcvbycqb
         f/DmVdCvUhLj93wc6WAkko440YpxIGp74dFrr2VNRE7TUA3ySRRzzWSd0OzyELjmA9G6
         Mwg7O8HcMeXjPe7JBaoak3NzG6tFfL7BmO+ga/hz4Vy01gCfSBmCiAxm0GH4SG3i7OpV
         c/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794679836; x=1795284636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2tV4PJFJAVwFY0+x5FVmRJ66Mz8ksU1cklE+L0oAwR0=;
        b=IP4ixM+gW1f3ubBqtnr7x+EIcIJUkc5CyoKGvNt/hVZAFnGUJBAJ+uwRyRNGa2N52Z
         aOURXueqQHpzhvSmKmPoVoF5LzMA1K0W7nDh86nd6nbcp5Ss2OJRhj60LemTTdxrK2oo
         /1zk6Cbj9sajYfExd3GCgkxckCWjtOI7NcwL2SMtpolZyimepiyehb2eEicbgG3HJQkv
         OM/ioVo43vOangDxCrMa3sZyVIaxJTC8Hk2cTL4HJedUT2ip+mTgat+0NJD3rc21rjp9
         y4zN6Mft7vaBVqzBE56aG26g7QecSeG1kJCvqCDT2hmfDkSn62QMLlqUBJF+TG5jD2j9
         fg2w==
X-Forwarded-Encrypted: i=1; AL+hErF0LlPSXiYvEsQbE+ge3mVGL+MRR58a3oYZ8nraVnEa73MztxF6GY6zN84u0yy1QUa6BnA2gntUMw==@kvack.org
X-Gm-Message-State: APuU4Z/Yttq0fgGrU/GIhOa5mBysvOYOHKYWO1M9pAkLNS12gHikNs8n
	k46dNUDggo+gHMQ5s4ILqh3mXzE9HwibtxLlGhniyQI25kMDox2jd+lQ
X-Gm-Gg: AYBFou1LjR/yAc2d7pRQPO5XSYL4ALG2UtgHjH6C8sE/cmDhWx9837xqjLpnLTxruDL
	cFbHJdR2lYaqywVjaoYni1whDofrdMcFkvJdt1SYRPerMyvRfGsHWs6+h0/ni87ePO+3TXeSOb5
	Ak50HzH2QMn+CSVuItzJwNJkYsEQtJQx0pIBqYKzIZu5PZXrpKdhTYDQEIEUbpIBulRFO54dd8H
	DeE///9W0Hf3voUUY6cz53u4olnymCpZ3sPxEfKSIylL48kHxOFhIjg0E/qVXNJAZGOCUJ/OFUq
	xqtqI+LQbajyz1HdcKUcIu55PU9k8Syg9ERRzZe2oMNay8GylM4kiVP5EsIYoC4uTD40v1WLdUz
	HypVzjL8nWU9VbGJPOvALTueMgGXiH9XmbvNsWgqOfmr03fi1OXbtOHF/L6Zp/SVdn4bI/noz/+
	kTBborJ00vdg4cFTjHFVWmdMSy+udHH3ZjPEEqWJ0KJ/G/K8WwyzRjttYP36XReR/oXXAHUExn4
	sKB6k2gDY3wljy7Nt60NXTIgJnXtjgVp+9cXufQ8ZP6bO0NStG+fgDr2r2Wfz3uT24KneTqWNF2
	AdA7tMlVDyQtx574rSGEnc/+5V0WKM3wJZvv+fxQk6ximMZNl54QE5y8TnMMUjVXrJMJ8jas32v
	qfDvS/v3L5Diwz7jOLz7URt3VovylydG6r4U=
X-Received: by 2002:a05:600c:4715:b0:4b7:6b0a:a2f6 with SMTP id 5b1f17b1804b1-4bb55a963ecmr125366935e9.21.1794679836134;
        Sat, 14 Nov 2026 10:10:36 -0800 (PST)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c605e5b2fsm12637227f8f.40.2026.11.14.10.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 10:10:35 -0800 (PST)
From: David Carlier <devnexen@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] mm/damon/stat: avoid 32-bit overflow in idle percentiles
Date: Sat, 14 Nov 2026 18:10:34 +0000
Message-ID: <20261114181034.2665113-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261102150757.93058-5-sj@kernel.org>
References: <20261102150757.93058-5-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jbq8g6okp13qqth448qa4rxxiso6fe4c
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B18F0140006
X-HE-Tag: 1794679837-492339
X-HE-Meta: U2FsdGVkX1/niv4zLf4ykkcSRIL5Kqz62FBufB03mLn67tprvUDjZMJ4A9tI6+7o/Slm+7Ms39ssI+huJ8+7/1u675r4VSJQilKH5hd8cQFNsa0zEv9C+MQSSBmm9KBOrMZI0cPe4wbKTOpRnFMEGuoFhUDf3UDwNFnqI3F4sQkefWehMjOn8gh4Vbg6AU9pzxJ739bGzbEMxY/rFw2sAAObqtinKmrQVJui4mZrO33CtyAIcDS13l6ZPXaZE7yd8HqYb0WvEqTeEtefe562ECgp11pFbNadFPfwX0PvMNzubcp04JgTMdhSTJ6YamAJQy2Zfih7u+kO2htXKIYCgkX+p9C1pzdOCYnckGwE50JPBnlwPdxGaBB9ACx0F2+pKXScvFfEw5+LW/Vz9KxqsaeeiEZCW3eQPIzPGr9FH9NdVufkj/BmzKol1SoseeByvrlNsRaT+r0xRSkxnhdMjuOLEqdk5x3NwsM9vV2I7Oh+yvTROGROQSdPJDausFLqFXJFNTb2xb+bWWaedi/n2ByT5WnH6Z4/Ws6sKFPMsilv5e5PxY96KBfdGB/WrF/DJv6yFDUkWNfcy8815WPRgIzKW0qrehFJW5somL0p//GgXBOfx/SOrjh6eO8+NBY+PQfak5QgdaAuNm/qDeGVu46VYjn3jxXgqEAksL1/m0to9/u0ifRGlmhLfg7FvrODUjBSHURSwQGpKtInfIbpEA0LjbfufbZihgIC405C5P/R6/imSNpo+3xjJ99K/78vrSkI/y1dJRqZllcFFELmzklnqEnqr41onDHe9pWKBkoadvXoLw8FzkeczgCm5LRBynYfd1y78mKzlUBnq8KUz6RniRWbfmUsCwwpv6A1eAuRAvD2pK3quup6caKdei7yPJITHysyduxdFFEvFdlLnP/BN80Q7eF+/ivsvTIVbfHq+DJeqhFvJaWzVG6CtKLtY7eNyG0jD7rOqqHm36Y
 qHBnaOhC
 sLfGPMaWWslcDgr+xhARtC4dYnZOy2Lp6jHYVwbapqK40D1wQyw8LSvygy/N9sLmoMw2oo/lA6Ws7/jrczzFwEPZVhTK2jNyzL+CqF7MKQFOHwVmHBBMDCpeFWgOTOBiBjlDfdeYW6TeQcAQVFCNg4+9D3sI7ZNRbwioMm1srpgQn/Pl9vg1VW6aP8pNaKLQquvOTbVj+OvtIghBSBuHCkJfuI7n3E5D8Mj80Cyux5EStD2X4kQfaFH2W29gQvqseK3HEFPTPqMlINqyBYTQMBLGqrY3sj78YyYcMroBDQOsliGPt+KcVT+6wwJKvlfDHKaIwHt7sO2tD9OamYK0nOFWVamiXHV4RipQpoom4Kib6nj7OddtFqNm+QlIzIK/U3qYirJNv+FGI5KCaYNXvUjUBjSpOwlavuc80
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ, Aveline,

The value stored a few lines below has the same problem on 32-bit:

	damon_stat_idletime(region) *
	(long)c->attrs.aggr_interval / USEC_PER_MSEC;

The product is the region's idle time in microseconds, held in a 32-bit
long, so it wraps once a region has been idle for more than about 36
minutes, whatever the intervals are. The cold-end percentiles then come
out negative or wrong. Doing the multiply in s64 with div_s64() would
keep the sign and avoid it.

Hope it helps !

