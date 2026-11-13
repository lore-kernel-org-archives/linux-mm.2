Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C7D606CB13
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=TeNSsJ6o
Received: by kanga.kvack.org (Postfix)
	id 866806B061F; Fri, 13 Nov 2026 03:51:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818B76B0622; Fri, 13 Nov 2026 03:51:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A5C6B061F; Fri, 13 Nov 2026 03:51:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5655F6B061F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:51:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB94DA2D9E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:31 +0000 (UTC)
X-FDA: 85429477182.09.ABD1466
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf19.hostedemail.com (Postfix) with ESMTP id 11E5E1A0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=TeNSsJ6o;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.138 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559890;
	b=6rTX1T9ctkVfVOtRC6xMgM0d9O/NTT4TXaLaSluCx8UPsqq9h1ldETHZ6C1pwWLyQZN1JF
	tfVCkcyzqbkRQ4XhZ7mcD+3HjbrWeFcQ6hwyvGcv3Ju4JuVmZm58nPzUpR0eR3+BsLJ4TW
	2L/TYO9p6zMQ26pGT9DDIdLETBkMvIk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=TeNSsJ6o;
	spf=pass (imf19.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.138 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Md769LsMtNFDtvpBg7Ba+68YL18ytLzyTSc3mrMJ/dI=;
	b=R0P0f7Z3yGQdf0IRVoXsbC0AnvBgyJ1GRvtzCmFjBqCwHN8HVzeMsT2UhCLwvW+Ty4GMAP
	RsxST6njZDnfdetr5hMURYQYqG22zSD7cQnCHNZAXNvCfMOAZqZZGW52dVgUDi3i8OSLKN
	GLesqTW2bTl1KMp8iS93xD1OvIw46Wk=
Received: by mail-pj2-f10.google.com with SMTP id d9443c01a7336-2e934c6c20aso7478085ad.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794559889; x=1795164689; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Md769LsMtNFDtvpBg7Ba+68YL18ytLzyTSc3mrMJ/dI=;
        b=TeNSsJ6ozALXHNyxNi1LEuRbeOd+Tqf9PYuRPmFM7hi44/rTiaIPn+8mrePoCy4+5O
         X5+Uec9A7gWwecVXVq4lmq/tS0mM3vv8pB21K34TxynORn6fFkZERGdctOipVyeLS0QL
         jKXBWTZBscnFGYeSru6+iUIMhtT/H1fFpimuk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559889; x=1795164689;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Md769LsMtNFDtvpBg7Ba+68YL18ytLzyTSc3mrMJ/dI=;
        b=Yw7+O7f93GRUEpLf7pxLZJEc7SFmQRnMxKavhb3s/5ZR4foB57ScrCCf0PNZfL/QM9
         /yfNVzfNcI1Z54JI4Jlg4rE0lfUoaswMPQinM9UGyMaGQqoD0cUL09dfcETsIrO+1ZTQ
         XHHajosTbSvdHYZAd0sHYGtbYZfcz1oIYDL12TnT11A9Y40ZZZCbiq3FySzCfxveB2Ft
         TtPlTRJW1ZrPmdpiG2Db0krCi15Ve94bl8EgQYpBWBDD+xe50fBCgZXj/sFprtGZweIH
         UYjzg9Zf9pNsrKmFzz5JH42OcabX+9RpEsr9ULfjZ6NlJENs3wDrkbngiawtTrCjVaJl
         O9BA==
X-Forwarded-Encrypted: i=1; AL+hErEh5394nWaJr/XPQpVWfMyFArusjU8US7ej0JWENnXMxgDurgcQaZXiFo+YZAFdpXx22hqHHIH8Lw==@kvack.org
X-Gm-Message-State: APuU4Z8ij0u5V1bl/w9qsFGGxAYyNchy6rpXGKH6lglr+PWrzGXns+bV
	QeEWeWC5BipcbsLvq/RM/lmKsMwdhQjkHRg5t+4dMi4bN486epG2+UFyYvCiZcHCsQQ=
X-Gm-Gg: AYBFou3vqrFiyV88WZlhtjRm4p3UDiJM1UWJCPkRRbkNZJwVBqaHNsY3B3E6vqSlmHa
	UodTiQoZwtWNmbewy7N9ZWBxI6WB0WIxT0lYSmDko/q5Oz4rHaYE4McXQ7KdILVdw6FCHdQ5R6D
	O+eWTU7VQZfjapCgy+xUSVMQ3cHmHm/1aa3Ur0cktBDlq0bBhcIVgUM+Dpwcm2ZKLluqnsOx+AN
	sxHcruO2/yoFbAGuEt17U3sKoAdwf85v5COE/MJLMQUM1Tpzre1c/4qQL7/DB7aYZY+7/wpc+LC
	lTGfdmqxJyi4hw0TGIMwsBPwZQ0h8/YzFIFP6GMUeoYy+og2ZYbFSMD4kwDSq4Ykutzyq9cKNC5
	e4IoMjVy6hIY7HNvU9744BZCZULx7Suf+9Ozlt+GhdULBtMuYnEhKsM2ncvi1hbfMd/P+T/5jn5
	qOsCSqFdwzhyK7961weThyTSe9FdLhRpw6HDiYQ1rPYvlNbxunOEbpEYlgDt2DEm536L+b6loP+
	Oolkbtv/+nUZBGsrVqMINStTYK6kCsqKh2+pREwKIwT3KB3dMr2P8TRFAPojRY1aYIYSjQSYwJI
	6LFDClVcorPiPXM+FYfzDYExanOqIQPQo/1e6xqNv9l/YXMp7U3t0ESt+5pmCXmWiPTRhm+DpIw
	buC2N2DzIotABovqI47mBS0XiTmISHG+5pENDjhzxffioGHxjG/qk46PlEcKrfUm2t15ViXeiKi
	Trf+wCj3HjRIwLWiNYNeEzC0KFd/q4QAP0vd8iHML6v3w7gSRQN5eiI0DdgTM=
X-Received: by 2002:a17:902:c945:b0:2e8:8637:5e3 with SMTP id d9443c01a7336-2ee0daf1004mr19821485ad.34.1794559888836;
        Fri, 13 Nov 2026 00:51:28 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee1c4d802csm2287965ad.37.2026.11.13.00.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:51:27 -0800 (PST)
Date: Fri, 13 Nov 2026 00:51:25 -0800
Message-ID: <25b5bf9a7ef115709f1149044824576e6f71e71c.1794506262.git.chris@chrisdown.name>
In-Reply-To: <cover.1794506262.git.chris@chrisdown.name>
References: <cover.1794506262.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v3 1/6] mm/slab: Enable SLAB_FREELIST_HARDENED by default
To: Vlastimil Babka <vbabka@kernel.org>,
    Harry Yoo <harry@kernel.org>,
    Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
    Christoph Lameter <cl@gentwo.org>,
    David Rientjes <rientjes@google.com>,
    Roman Gushchin <roman.gushchin@linux.dev>,
    Kees Cook <kees@kernel.org>,
    Marco Elver <elver@google.com>,
    GONG Ruiqi <gongruiqi@huaweicloud.com>,
    Jonathan Corbet <corbet@lwn.net>,
    linux-mm@kvack.org,
    linux-hardening@vger.kernel.org,
    linux-doc@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 11E5E1A0002
X-Stat-Signature: e497df9pd695s55znn4z38ghqo5fkcdm
X-Rspam-User: 
X-HE-Tag: 1794559889-663939
X-HE-Meta: U2FsdGVkX1/QJr5QNUkvGzxcZECLTFlZWUPmFlUPy0uOd6w7OAt+euLqQrZqB2In0Et4hwqQadMZ4xmSyzJA+YCx3EWJrrV0kDg75d9DOz2HSFZEygLuikq7Tj6zGYRWR+qQXH1WJlhQECYykwETGYYoQpb9cyizpmjmVszEsdlG48iJB28ahyxMR5iVTfuJKnaHmcUglUJp3tgYALFPIvYqPfz/WsM07d6mBWQ1k5ou8eUjHiRIu/LEg66mFQQ9XkzQiJuXW2Pe9ews08adDMKpCiRu2dNv1of1R9Nak8X62V8V0D8cMfE4MxFT7SwepIzthGczUDbalcBiO6wW0JtmqqN53vMAJhhleECNruOne9B8oCCZ9O6hjnpKaDr3XMZpdhbi7RlHryK8HZexbSeo9gu05RkvjhSlf3cxyRBH/NNK2nVyZ0OZVD3lfC69+VDAHrGSZ0FzEXSnKOJQMa+zxAtg2JnodAKHbISUDJl8m1zYud7j6922vrPVBfQ0FGN+PVS2YHfxWJ6SooYKmlEC5JIhLVh/8G7jrxoaTWQw3xQ8sP0GXVyk+k8S2itDv7GcE7hQebdrR7Ig7lMXpTUiSqz3vi5M3N4rY9hQm1CdswqRQkai6qrK/SttTWUGU+1PckhwijfDF0Y4eWmMDnc679RZNps7WEyeC0mLy5PCIfHPK5RILhkAfc09F6sWmTi5ymCkg8t9D33nGRxVyPa14032lvIY4YTlMqq4by4TzXNgyV23T1v/ovEA0bjSvAgzfc/LUciRfiV8f+nzjMU6ziKJuE/B1VFY6FWmtjO9S73310krK/5sZ3JkfmISqdo1PSAzuZX6fbK5+D9bHVYoVTdDQjHYEBdUS7xXYFrA2ThGPvSzuZuPWgsyIB1WRh8Mrws6Wa6RvY3aNAaFHFNfPEo16v2DM8UA5i3La8LA0WvVPRO5s8ALtO7idgJtZ8QVqIhooXYPiz/NYVh
 KNrEiYTQ
 s8Dkm4artxwkrrRsQx9cVBHgwiZ9gXhZv3o3xDcf+pIKvNLPgnBPNCm2cPr5Y51j8HnwijWq5sV5vdylI5i4s6LkCYzVv5DFN1hWTtO1QPBLaNgc2grVl1jtSX99HdPs13MYu2FnX+JmEFOJg8zOHWN6tIKMJkW/SlCmXNTT4mBKoS7Pr0TwY7KXy9n5hG5aXTY4VQtiV/OURgJwtCwDuzsrfMuZPobpP3ugxcNWCVi5fJldy75tsfiKQCNCzO+I/BcYhkO0UtSh96BgBb2IpIqgWStmz7kcBlUgXl0mf6d9mDUZ1sKjg4DHH6ZFDLNk+ZoOMPjk84fe9go/xfLh0FyMqO8t88i/Jp8+Rw50ZnihiunTSZ7CGDHY5BbBmcixpPfu9zkXudXhjNCTpyb4mrbl/08dF9Lb/+135xtEn32B2HyKIabATAPpC1ZqWyW/yRSYyjXIhIuy0z1RQlt3sxgObempMyMjczs79eEe4QIkJlmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SLAB_FREELIST_HARDENED obfuscates the free pointers stored in free
objects, and catches naive double frees and frees to the wrong cache.
Most distros already enable it, and with sheaves its cost is small,
since the per-cpu fast paths don't touch freelists. Measurements also
show this quite clearly [1][2].

So let's just enable it by default. SLAB_BUCKETS defaults to
SLAB_FREELIST_HARDENED, so it's now enabled by default too.

Link: https://lore.kernel.org/all/auITixAJMfLtfa7i@chrisdown.name/ [1]
Link: https://lore.kernel.org/all/179312451613.474906.1475329637924619088@kernel.org/ [2]
Suggested-by: Vlastimil Babka <vbabka@kernel.org>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b543..f330c2c29fd2 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -208,6 +208,7 @@ config SLAB_FREELIST_RANDOM
 config SLAB_FREELIST_HARDENED
 	bool "Harden slab freelist metadata"
 	depends on !SLUB_TINY
+	default y
 	help
 	  Many kernel heap attacks try to target slab cache metadata and
 	  other infrastructure. This options makes minor performance
-- 
2.56.1


