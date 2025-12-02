Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9CACCFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 08:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40346B000E; Tue,  2 Dec 2025 03:48:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17B96B0010; Tue,  2 Dec 2025 03:48:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B89D6B0012; Tue,  2 Dec 2025 03:48:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F56A6B000E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 03:48:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F6B58992C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 08:48:35 +0000 (UTC)
X-FDA: 84173904990.29.33E5BB2
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	by imf21.hostedemail.com (Postfix) with ESMTP id B9C6F1C000C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 08:48:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HnPUP6z9;
	spf=pass (imf21.hostedemail.com: domain of haoli.tcs@gmail.com designates 209.85.210.193 as permitted sender) smtp.mailfrom=haoli.tcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764665312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBS8+olM/4M+ACTFgRPt5Ss6w8SxO0WWkLSTJ+Iinlg=;
	b=0VTbkbZVo5lUX5KOxn2oHQO2oikH36Nx6JzksfYKVpw7IQ3tuLMnhy8gmuSHApiyspGTH/
	8sWQo63xU+9/M3xeheRRvVYlfbuqdixxbB18VIvOOj2k38X9MxQQVoyw+eFfE1zWOTuAfR
	NA9mtovWt4wVpRItCrQgAofBUb7qmRo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764665312; a=rsa-sha256;
	cv=none;
	b=ygVkLOlKCBeqIOX62M6KvPp9qMuBbyNLv0L/PKk3JO0CMfZV86L3u99PRQ2JIj52vmjXIB
	OmeItbkVbalyGtmU1abi/vaSDdiVnKTPXp3bjkWOa+5v3gL977dUpLkZOa33WGJ9g412u4
	yZ++vjyn5048Y4lkQgQswzc64e+1e68=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HnPUP6z9;
	spf=pass (imf21.hostedemail.com: domain of haoli.tcs@gmail.com designates 209.85.210.193 as permitted sender) smtp.mailfrom=haoli.tcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so3572555b3a.2
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 00:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764665311; x=1765270111; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:mutt-fcc
         :mutt-references:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OBS8+olM/4M+ACTFgRPt5Ss6w8SxO0WWkLSTJ+Iinlg=;
        b=HnPUP6z9j1enUDXKCw1708Vp7s/mWiFjycbkFcEq/ftvayvRufcF1DVn3kbuDlMQ+/
         3UA0UZtX94ySf8p03rbN6zEz41uhrmNX/mwHw0zhcxjLXPSMNwwCcZjVlurE0xLg/zln
         ztG/RvofK/2HAiY/odHdPSeLTRmJ2QQOm1yGYHrfZeyH6aG1G/KkzsqPtd2z3TDrQb2M
         YvSaiTAxud8FbtjYr2DRrHvVV/JaQIdr2MweeC2lgw3rgEtzjsFH+m4PlqoU2tbWwJzF
         EZhHkKR6OXdXc3tJLvKo/ML4MQzOc+LeqCNkHQjyJIZjcclZfitimqWjquM45fKmossz
         sS0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764665311; x=1765270111;
        h=in-reply-to:content-disposition:mime-version:references:mutt-fcc
         :mutt-references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OBS8+olM/4M+ACTFgRPt5Ss6w8SxO0WWkLSTJ+Iinlg=;
        b=SO3jNJMXOr6p6QRUKE38/bY+R8Gs7LJZHgBEu/RppxD0GGImZQFXTPPDZ+JSGUTCNs
         +Q4VK0ZmNRTgnKupqM/MNDnc9BuVL9AD3IEnj7kIhYkACEtXn8hW3f3lEULPSI89FUrA
         vXNI5FswCt3Qq2EHOpBR+AoqsjEg4eG5Zw/YoF9EccTQ3Sr3P5wnxZysxADuRmshZzLw
         C8skJ5LE1wqSWpLvXYGVoAg1y5lxwI2wJm1ImYJJEDPLEVGrJPgDCYhhdzE+vtD1q2u+
         CHsDQz+0/SbnT4D005RjDEfDLI57JjHPfsx0nHN1hMPNb1MC0iXBEN1kdTpNmT+vBqeV
         FzQg==
X-Forwarded-Encrypted: i=1; AJvYcCU6MKmkdDXUd/f5WXGagptHvq7QrLY7WvEM93XnCtY8ltjaK3qazix6iof7YPUQ0diRS8Q+gKj/FA==@kvack.org
X-Gm-Message-State: AOJu0YzJTgjFWoxNLpTR8J38Pt2kn+SfAKT1VNwz/Cack5gq9A25mqHm
	VpTMluqgsmo73gNYXBp2yswPDamo1bsdsCHCVlu5mMq9Ru3XkEJ577J3
X-Gm-Gg: ASbGncsY+IcOMGcgPCeQvPDyEnGcPMfZfZYaqV8ln72145ShsrV9GVGNacpk/+fkguB
	Dwu0iXVTPJG+voUC7bcND+Vn4LHEAE4hWz1xunJeKE0cSJJt4sWZsGZuGq2FkUMET8o9jAWsMbe
	IaTY3MedRvznQxkELbz/Zzaat+9NQJgmHzVKyrOgUhjGnWbHGAUZTfJQToU8ZGa1gUG9OxGQ+PM
	oKYDI2O0WbcMn2JQbsmC5D5EyJhLa0sGhQ22ITN/G1XzKgdwZ1m4SFYzkuTRxYfyfJjI5kUAj/H
	bJim9mphtE2XoO1nj1fPWsVWNYgTaOlKeXRlOTF11DXw+YqN+pJLGEwyZuTUzKGPM1FvUOvU1Iu
	CwPP2EUxHfGn1lnFTyP+/AO7FfW0tQU02f+JgTcrDNh7qHXFguELHDuaCPirdgwQLb9Ut6x4X69
	OT4Tqb1AzmQA3ZsLQ=
X-Google-Smtp-Source: AGHT+IHTH0JinbOevFQv63FRumPRo26JUUc0qkwllwN1bogjyVzWr4TpTK1y1HuLN31XKsWATKEW8g==
X-Received: by 2002:a05:6a00:c83:b0:7b9:7f18:c716 with SMTP id d2e1a72fcca58-7ca8740ef7emr30483141b3a.1.1764665311073;
        Tue, 02 Dec 2025 00:48:31 -0800 (PST)
Received: from fedora ([183.241.171.104])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d15f080beasm16166803b3a.47.2025.12.02.00.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 00:48:30 -0800 (PST)
Date: Tue, 2 Dec 2025 16:48:17 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B9C6F1C000C
X-Stat-Signature: b31e7nbhzjnua3dudak1gbgcyd6yp49f
X-HE-Tag: 1764665312-178070
X-HE-Meta: U2FsdGVkX19jXraOwTIWaKf2S0cHwdHOc1xmW3L8CikIKakOCPWeGCWnWe6JIKVnI46AeQi+3b1tJt3O1nOElq2JbvTWboJdqDIxl0sd5qiKIMBwzpMUCf5V0kmtAHT3YzLfpCcS02EpHBan5SeAUY5xgyclOCyoBf9UAOQN91YNfvnqZ+3M99bweCv2qha7lCCuHOlmfuaVBQn9p5Uf+CUMO2JFgyl4Nr1kEk3lgNQVrZ1oiVSQplrsA0YzP8G2q3ImkNgju3r/LcPtuuMsO1VIfWUlsFXwGl8kdj1foD6Z+1bS5QkNncnsFnlvcYL45b/DADhSPg1vmG8rPQkBPTU7HAquY4nCXsKJ6iHRMWQQWpHn3c/uquWMe8nqdzX2MWTcqBBp0YE5d6GOHEL3A4thEYknMyayb1Hgh7S4rcYjKh5SIb9GVbIxv9NLy08j83u5PeuhpYdX7HY/687RP6AYW5+8mVB3Z55McWRBrWamoT70+gkAbgLiIe9JH8MHH4x4lyqgGVwWlTVtkDyD6J1gc7vHKKFziExvMWhmiK7YxnPSdwmb5bJbBNYVHf27iaNchhWOkfoQD4crPtQwqYhH/yk+kIbMWFeH6j8uXYVsa/J1HFidRJXvkw8gkt55OUfhoyEAFhAb+Ut1VxgGmERKdOT+0b/ybTbwhazNsAIH36vxVzOOPAal0n9EwnLjSnr4oNKagxbEavkG/tkQln6fxytrfXK65nmsqdHnRjhyUCEzfW6mK5b2WqA2gN8Y5Byd/uqKgEIJAHFHqQIjoxmHbkRLN7l6XjiDFfAhlYP6EEeDqjmBoq1wVGfgF61f8Fbq/ikJemKd5KKJ6XadXEEUE8YqjirxbXpYC83YZqBYJPCaAriufDpHIbmD5Lly/4mNWGe+idqUQjDURHZZDgF0I8DFcI1S7MWjdUwLnt2n7WPZhyWtkijPymyWcIFjHZDDEAhDUt9K2GRZePL
 KsK7Vqsz
 E3vGSNdUqZZc73sM2kd94fVZGHwlYh1+B4b/5hxOagIrPEg49rS6T+5f1YlGcvucHiaL6NCVCOaXY1//pdnF+y7m/LHyw80MxXbbsZJMH/Qh0J1zEglbJTubbRTawJY6iozHsWjFiThx80JVm0QZYgZgE2hkHeInMzwDlrbzzT6MxfXhvtY5zpIGDD9dFp2u3Jf2HzS6rJQ68+f2E0g33sRRetNR5oxCtyULGOzwfOh8EFePVUSaTUoxh+b9pYxDWpNleMQ+rEbHcV6Na/JP24bu+2E29KRkgy91igTUY3IODJ42xwIpH/oS7g/yIEqFa9+sudiH4i4VYpaNc/gQwnX2n9/t/G2KrhV3fZ002g5gaFsQfUNt2EWnHWKrN8ohzF+mXjPuwNrwmAvBNno/KfvUK7u6MtKhstHHe2BfyDmAiYn3AbiQsbkmsCGIV7r3zRxSKe/i+DAIhGS1ZbyCA/nMOexE28HkVREtkptO3F8bPrRWVNGyd8s2Qrg5RMx5kUwwHcT59EQpzUkrhi+vQbVwsnJe+l7qBYZDxqg7yI9aeT0am/Ijw0O6o+LCx3ACld314GFcyVjrmOurVy3DcVpCpdu5F/sC6/VPQZLl+7wUIqpKo8TrZ46B01pQz/eZgNMt311J4VrY/HpyvwidmTSedyYZebE8H54gOnF6K+bWZlhojmn29CdWzlJMk7LfrgeI/odYLOmMT4Io5XKE9A7wQjGAUyJdklAzWHeubE2pIHkrvyFWD/Nq9HqykHXky17PZ85OdERCiHQvrEu/WEM1nvOUrvCOoGXTGn5XFdaFbtcqSt8F7p798ofuOwIozdNO3nJJrdMMbPlfe86qXVyoCiljsz9byHFMpgkWT+S+4C6RjDf0vBYcf0NCP/GZMlQDR7MNj3uIUBHwvl3t24CPaYZK3e4JA6eyAWinwwiyJtJS3oUPAz+QrBHUHN97lq/Nt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1


From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:31:49 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 3509
Lines: 119

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1



From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:33:21 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 8250
Lines: 265

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1


From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:31:49 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 3509
Lines: 119

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1




From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:44:16 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 17732
Lines: 557

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1


From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:31:49 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 3509
Lines: 119

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1



From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:33:21 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 8250
Lines: 265

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1


From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:31:49 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 3509
Lines: 119

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1





From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:45:09 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 36697
Lines: 1141

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1


From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:31:49 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 3509
Lines: 119

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1



From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:33:21 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 8250
Lines: 265

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1


From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:31:49 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 3509
Lines: 119

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1




From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:44:16 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 17732
Lines: 557

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1


From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:31:49 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 3509
Lines: 119

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1



From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:33:21 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 8250
Lines: 265

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1


From haoli.tcs@gmail.com Tue Dec  2 16:24:49 2025
Date: Tue, 2 Dec 2025 16:31:49 +0800
From: Hao Li <haoli.tcs@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH] slub: add barn_get_full_sheaf() and refine empty-main sheaf
Message-ID: <fqbhzbjw3nvbylvxayboyug7qayfref4xti7udztygd6zbhcun@b7s2yjihrwos>
Mutt-References: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910-slub-percpu-caches-v8-3-ca3099d8352c@suse.cz>
Mutt-Fcc: ~/sent
Status: RO
Content-Length: 3509
Lines: 119

Introduce barn_get_full_sheaf(), a helper that detaches a full sheaf from
the per-node barn without requiring an empty sheaf in exchange.

Use this helper in __pcs_replace_empty_main() to change how an empty main
per-CPU sheaf is handled:

  - If pcs->spare is NULL and pcs->main is empty, first try to obtain a
    full sheaf from the barn via barn_get_full_sheaf(). On success, park
    the empty main sheaf in pcs->spare and install the full sheaf as the
    new pcs->main.

  - If pcs->spare already exists and has objects, keep the existing
    behavior of simply swapping pcs->main and pcs->spare.

  - Only when both pcs->main and pcs->spare are empty do we fall back to
    barn_replace_empty_sheaf() and trade the empty main sheaf into the
    barn in exchange for a full one.

This makes the empty-main path more symmetric with __pcs_replace_full_main(),
which for a full main sheaf parks the full sheaf in pcs->spare and pulls an
empty sheaf from the barn. It also matches the documented design more closely:

  "When both percpu sheaves are found empty during an allocation, an empty
   sheaf may be replaced with a full one from the per-node barn."

Signed-off-by: Hao Li <haoli.tcs@gmail.com>
---

* This patch is based on b4/sheaves-for-all branch

 mm/slub.c | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..1fd28aa204e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2746,6 +2746,32 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
+static struct slab_sheaf *barn_get_full_sheaf(struct node_barn *barn,
+					       bool allow_spin)
+{
+	struct slab_sheaf *full = NULL;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full))
+		return NULL;
+
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
+
+	if (likely(barn->nr_full)) {
+		full = list_first_entry(&barn->sheaves_full,
+					 struct slab_sheaf, barn_list);
+		list_del(&full->barn_list);
+		barn->nr_full--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 					       bool allow_spin)
 {
@@ -4120,7 +4146,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool can_alloc, allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4130,10 +4156,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	if (pcs->spare && pcs->spare->size > 0) {
-		swap(pcs->main, pcs->spare);
-		return pcs;
-	}
+	allow_spin = gfpflags_allow_spinning(gfp);
 
 	barn = get_barn(s);
 	if (!barn) {
@@ -4141,8 +4164,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	if (!pcs->spare) {
+		full = barn_get_full_sheaf(barn, allow_spin);
+		if (full) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
+	} else if (pcs->spare->size > 0) {
+		swap(pcs->main, pcs->spare);
+		return pcs;
+	}
+
+	/* both main and spare are empty */
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
-- 
2.50.1







