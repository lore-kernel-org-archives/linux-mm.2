Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACF5D6CFC4
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA096B03B1; Thu, 22 Jan 2026 23:57:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A537E6B03B3; Thu, 22 Jan 2026 23:57:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9523F6B03B4; Thu, 22 Jan 2026 23:57:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 769AC6B03B1
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:57:45 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E365C136A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:57:45 +0000 (UTC)
X-FDA: 84362020890.19.AFD25F0
Received: from mail-yw1-f196.google.com (mail-yw1-f196.google.com [209.85.128.196])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5D69FA0006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:57:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MVD23NNU;
	spf=pass (imf25.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.196 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769144263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUE9K2FZw5Ls36EWUpBYNIoEjPdLY+PpGcwmuAyPWmY=;
	b=eFwHC8jSrKz2GpR7ra6lxsaxshkoMphp2CpC2j6/Y6XQxa0qpWCJcWgPykKls1IDYtYX9n
	w1caFu2T27dI0GNaC4NUVZACz2HGCNy4sTWPBAv0c2KTNiAirEuqCLn7/TmWu4jRsMeq0a
	doroKoFGnnx7+B80EpI0J3anPDZYMQ8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MVD23NNU;
	spf=pass (imf25.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.196 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769144263; a=rsa-sha256;
	cv=none;
	b=RY4m1HS1/fA2XhW0z1yseN+hsRGn1y6wlX8+6PlLvZIakRoQql3Fw6OABfIXKVGlWpBwzb
	HooqUUOTvkjWZTZKuwXwmcDPaOUlcSbh7QVa5j+vWpjvzk9iV7OMD0/echpLgqSOvGlLRV
	do2iXefRz79TF2RWJ/9+CR7M9BQIbsk=
Received: by mail-yw1-f196.google.com with SMTP id 00721157ae682-78fdb90b670so16494557b3.2
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769144262; x=1769749062; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zUE9K2FZw5Ls36EWUpBYNIoEjPdLY+PpGcwmuAyPWmY=;
        b=MVD23NNU10xG3Wl/Bk5nyOIzIvc0rWoWIEVoz3tw61es2GHK3PJAFbaeJH9h69KaXP
         YvjwWaAa62hFAflOg30PiDVc1N8fW4GPC45t77kRRZV86iLt2OBVIJ+///ZKgqnwBWbY
         o68+pdegW+5tugdqA1SDTz1A3GgbTgHDzhMddnhss9kSNE4QBMhEaVX2XuR23CMcs07y
         pa9i6k309eHS6CCXSJ3RC9wnAGnuGbRGSAnNpDvv9L+PfSYj3IGSjP833DdeRo9urV5C
         NAaQuKcUhYffM3XFNNyrQx9Tc5/hcCwdiji9QhK/6mUxcBsTsPoiXhFYWRbIv0Dx5cnZ
         EQUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769144262; x=1769749062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zUE9K2FZw5Ls36EWUpBYNIoEjPdLY+PpGcwmuAyPWmY=;
        b=n+7WoIPaZleeX9XM8d40S7BqtebMz2nra/yKqV4icEiD/S2JNmbkXhfm8gBGtR+Czq
         xh5Y8481Gkb8lWmqO0sWnOJSoZ2ft9an8A7a39WX/UtGae80UwNqW0qY1o1gIQsza5Ka
         FVAGzaAPGSGSxYLZtt63WPelE0nMebl+aZaQzxd2Nux6gU+5X98z/qFtF0IZww5RPCIu
         W32IrREKhH+iJmv4VH8uNPUlnOzw8QSH3UDmS5Xe4hTPQToVuYkx7AuA4E+U5GpoGhrX
         dYNx6c/QFV3BUSdukdVWyKnbDsj6kzjRLTkosaMEgim8O/ct8R0hyNuAOevYp1kJaPEk
         6keQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoNfcUker2h6ANf95SyEb+Oyhq7DOTI/yThEHNfu4owTqodSYk8Gbar98/Ie63CqvGzcXifk6y/w==@kvack.org
X-Gm-Message-State: AOJu0YzI38bhlIUYIr20Syiq9kefhlJSCCx3ZPahRGi/C1PR2X5/jcgW
	J9LuMtOV/T9pnGkYJvLaUARAZ1oj7xVPEpyKC5OFOBJhHEs8RdaSVHA=
X-Gm-Gg: AZuq6aJA/l5BAQwIA+zXJLtNCrs8f0MbbeDq7f44BDqJYOohB4mBo0Oj7GNip+NJoTk
	UXBvfdQ6vYOYx5DPVzLHEylOrfu+c/9duzirjiuYIXLXlV67yreS2n54Diij8MfjuHiO529Jtp5
	jxe2owRwC4ThXftC99jWNvEkyWzEFc76clDdgDP74J1ESt7mB47WhE4ydSSKkn/Xz2OlSB3/2C2
	MKn59OZhqaBj21tltIKka9baGXNQjPN519CtDpLKziU+DYQGFUGVmcMs+eKjiFimIpwLHhawzIh
	pNOTgR4wMJJJOvdssT5+8HHm895uKyqt/ZUhzUhmk0bePsO1e5noRkO9qDqHc1OmNIPfaDlea6O
	TQbftvfYjdDZPnt81PfnUmXAjSLVTPuvDDCemfXxm385G+BbML4mm0S8rMcNoEXSMVFlt072z0j
	3XoERaEM9NDBXB4lC9gCWe6AFPB65NMZwsPklv+prwg/xFsVDh93u/AAHLJmrc8g==
X-Received: by 2002:a05:690c:39c:b0:794:4c3:65ec with SMTP id 00721157ae682-7943992fbf6mr17105327b3.22.1769144262401;
        Thu, 22 Jan 2026 20:57:42 -0800 (PST)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7943b2b9bfcsm6436687b3.38.2026.01.22.20.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 20:57:42 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [RFC PATCH 1/5] mm/damon/core: add DAMOS_QUOTA_NODE_SYS_BP metric
Date: Thu, 22 Jan 2026 20:57:24 -0800
Message-ID: <20260123045733.6954-2-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260123045733.6954-1-ravis.opensrc@gmail.com>
References: <20260123045733.6954-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D69FA0006
X-Rspamd-Server: rspam07
X-Stat-Signature: mem6pyn35cm5n4tu9wc3hhcf38y6ybx8
X-HE-Tag: 1769144263-680146
X-HE-Meta: U2FsdGVkX184HfuZwi/mM+stLUkJUtXi6KhrJ1yRgiOwLVsfwAL19Q82YHT7Y57/JPGGGE+sVibJn0pdJW2Uf8AH2IBYX7a+ECAlC9c5Gzo9eJZ3eOZV3A6y9GApHoFPJC5XLjyugPDszpolCdOy+jKMINICsySowYsgrQTnF/Nqoo2y5uJnPArpjzy9ZesFbsjPfFY7akQLqUhWAeKTUUiVP2PJlTukdgLYlptzzsgVIntLfCn4nLL0YvJgVtIo61qh9oOC81WlM/yI8aXLbXjea60lM98eDCfxFcSPFpecvXJq94u8cZZP6UgDOXwUAh12awNYPx4hrx5P3n2huO2CjbrhqskUeGvftzKMHNvWl99+ayTZd26zvd9SH+3VeMdzeWKb5dsUfCOAfRO5rFWYYHUFrihE8SpLAKaZjCvIO71pXPBgX9n0EftoqG8Q+LRzBfITaDI2HQS0bTkyIO4SwKF7mv7uaY3OhQbAljLEL8fYmuXtxb+HMX4BO9dPfmg+74UGUPE0M0v5lD/1wfLpnQbeAyrBHDqBHV48GmNaJ0dpR57T4VfIEK+H+TsSvar71dYhHRlN+yo5jHcYaHbFFzAl2o+VQUq88Zen5qHEbCMnU9xEoOha9udvchua/4gTWwswEzqKRDOmqXhR+YvW5u5WiZJdd0LbGywt3EdpoO8sCs6W0UkiCiwbZlgh3XukMHY6C0HmtsQWI5h58bJXtmglxq0Wr+AeyCHOY69ZarkQp2oiHfurCAre/1NPoDCdCdqNnqQGmHyT6hmNUdKAf/alh+TLTmGf3BdEZeJXva0EvreA7Rnt7y5I/mqcDbYRE7EMdPdntEWt6G8nlVugaO8yB4ysVFRtdrrGg1/v1pRnoa77Z5By6HuAnIbbs3UbNFKnxeBVx0pf5NR69oqsYgZPKNYssKHn8gCIfZP8ASfjQ7PlDMtCF2iC3XycLbvUFhLuuvsBvJXqabA
 rJxUx7z/
 JQ4u1UTt/MaJND2pIbG7hqKFxp61QdXhOLq2/pwDeSgt7pkwLFcu1Inq3YWVEpI+S37uMv+PNr3egELaPznpe6svDXlZI0Q3GasDbZA251QUAABOez6sU7rn7L0GrVOP5uw+QE0bnyZ65YuNsxppgYisxfZAhieUAz0T97iDoZQhjzP4l5S/2STCqk9tnhdt4gbyZBEG+Cnm2BFODl8Cu6BqMIbNu1diu0nXOHXf74O6ZLADybd6ZOPQiMlE9n9+Z8Qf3ZZVM9lOXU/i2pQwXTP32VwyA1COmpQPe1SDKO0hVEmiVr7mdw/QkeBmVnaAVlioEiGefJpyq5u/FnrjwaNMoLUb8tg6EDmjxUcI+RpwNI/idRDh94ySKHDXRElJsgCA/uzgL/SQpFWTWxgNgNhexi9oO0NnbgeKSvFCs2IiIcu194C8x8/THpKqbFklZh3rkzHOs331RUEe6aUHx6DPC8SpE6CKBoeInXnK688mGMiDHS6i5xkIO7b394dsZGSS2+47IxcYGT0DWqjo4a8rq7yiWUa8LpFfDNrBsuhMua6ERJ7u9k6WJgAT+aT2THw9ruUkXDm7FEdUlpA+1T0mr2Diu/0pBAjnIZ7SaXu1oPMijwSGfhgAyYny4T/ihUdMszGMhf76YxTnOwDCqY48NtCUXUklRaqZ2cVsVRr0iEJnp9XzCjqTRjH7zXTBa+g7q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000362, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a node-scoped "system bp" goal metric for PA-based migration
control.

This metric represents basis points (bp, 1/10,000) for
(scheme-eligible bytes on node nid) / (system total bytes)

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3813373a9200..ec5ed1a217fc 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -155,6 +155,7 @@ enum damos_action {
  * @DAMOS_QUOTA_NODE_MEM_FREE_BP:	MemFree ratio of a node.
  * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:	MemUsed ratio of a node for a cgroup.
  * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:	MemFree ratio of a node for a cgroup.
+ * @DAMOS_QUOTA_NODE_SYS_BP:		Scheme-eligible bytes ratio of a node.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
@@ -166,6 +167,7 @@ enum damos_quota_goal_metric {
 	DAMOS_QUOTA_NODE_MEM_FREE_BP,
 	DAMOS_QUOTA_NODE_MEMCG_USED_BP,
 	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
+	DAMOS_QUOTA_NODE_SYS_BP,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
-- 
2.43.0


