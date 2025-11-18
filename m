Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B8E7CEE327
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 15:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBFCD6B00AA; Tue, 18 Nov 2025 10:50:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70C86B00AB; Tue, 18 Nov 2025 10:50:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86536B00AC; Tue, 18 Nov 2025 10:50:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A529F6B00AA
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:50:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 515648919A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:50:48 +0000 (UTC)
X-FDA: 84124165776.05.AC9AD8D
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 896DD180018
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 15:50:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AW5vJrQ4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763481046; a=rsa-sha256;
	cv=none;
	b=MBrJEC1gtERcGnRcnhz1qFR5QbA+FUYWEjvFZwkMm/Hv5gZu1JL00bQKKr18TadeDn4pUy
	ksGT/ikd2nOze+OvjCtCqrlezMR9zZdaQ77Gj2dIx7Bh5h1TDcU8P2cUWQQjACDMCc4uIe
	5zh41th8x0R3sVQ/k/VK/6agbOF131M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AW5vJrQ4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763481046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=znBmL0qYDlLmUNbMvde3BYp5lNRkQdrLDGuhdG6PFqQ=;
	b=uoXpFkTuXWa7YfDBc2+MrlVbCGdxV9HiolFw43gn9IOxripljB0E/YtFuj/EGLECii7g6k
	fHovICuo+QlGK1tnjbzUPbPR125ySgEL9xCCljGcg1rH0Os9Y8+2Wb+LAQMT5MgQPN4ErB
	bEdB3KGFL7DFGVsFmxFrGsJFaB/U4Ec=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2953e415b27so59938555ad.2
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763481045; x=1764085845; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=znBmL0qYDlLmUNbMvde3BYp5lNRkQdrLDGuhdG6PFqQ=;
        b=AW5vJrQ45WCwMHc30xxJ6NonbC929l9le9mWhDS6sSBfjlDt1gQe2z2iK/hFm7hec5
         TC17xB9Fe/Qv0f7sHPAAlzY6xW7aKUB6n3puvIER7eEXyKyR01ru5oSdMFFMXkAsF1ev
         YWOSWwqtCj9x8C98AyXSAGYqE7uirbO2yw8NNVCsmrWyRmDm9uwhkjpp/1ZdqPH19L4e
         efcP4jhOQCR0A3BobgOe0YMs7yBAJecmBIf54LgSj/bqgDzdowqDACzQH7nhtqfmInq6
         peQKaCOt2+VcFA3Ymgj5iuXlzZAwWuS4cZCsXQJq2wL0ib9wdfSK3RSTyIeO3hxSmxQU
         hatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763481045; x=1764085845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=znBmL0qYDlLmUNbMvde3BYp5lNRkQdrLDGuhdG6PFqQ=;
        b=lri0/DORz9Zp8nX8Plpv249eRneAqEwLJtQ2OAl2K+cBIF9zvJvDMk2AHvhLJoGOAb
         M7leSU8aD+QPmCf4UfLdGxLAz84FFYBugavJq8MVImZhj8y+6F8nOGIxso7KSDLHmWxm
         +WxkzRYVIvHrbDLqzXQdIdn3k9nVN+YUQRp0Aygj3Hk3FzK9FgRWDO5NmHYXwoYjVjKR
         RQ2LZ0vRPd9S6iOmSpZw/e9TYu1VVVjIyIu6MGVSGd1P9ntSduEV28+T6c0pbCsQ1YTe
         TkAATDL2Gmio+nPaW1ei2o/okbYHplijNOEbYn97FRww4mWIuAWXxZWddZs4k8pZX44g
         pngA==
X-Gm-Message-State: AOJu0YzLggmg/E2ODbVphBeqxklAPpTHdKrxk6nlIrznizca/GdFzg35
	WaB65MSgGQkrpWOX57EKkrMX46xwYxr29NgFxscz3tq/GSbi8pkxtjzpTtUEvOd/yl4=
X-Gm-Gg: ASbGnctFGlljFJqEhaic0Na9JjWJvuLgy3J3tw+lntyLkKhNFvOGpJx+OUjndDDvNG0
	NjvcKtdb/8Drrnnhz0Pr6AFegCJArvnC1LsE+O2FB+UH5DNmIp2qB6w2N2TfYg1gDyDezeGZknh
	Q4EPzdwwnwHvy0hoyPHh3w08h4PRQVq5dMVdQidvtavycfuZm+UgJ7GQmN/e0fahwzO5fA8RToK
	zkPdX4woPRAGzyuXz1mQCEvNoU+PNqBtkuUCDb6TTaUkO5hyjn4n0DY3j8jrvOL5MuYotPNz2Pz
	WfDOuR6TCxoFjymUl981aLKQEhPJz/walWFNFJvjbjXRlapg2pPLggS0x5IQWadspmtgVYodSjP
	xyBjfdWhxlN7H4PAViX/2cm7Tq/SjfCheFRyjVzsII25MQ3dOUSI=
X-Google-Smtp-Source: AGHT+IGhPuHebhbsdd1/YPo0JmxULz5EW7cNxLS9wqgEkAgEcu8AWv3E2wwf+5ShqW0ngI0gKPMjYQ==
X-Received: by 2002:a17:903:1ae6:b0:295:3d5d:fe37 with SMTP id d9443c01a7336-2986a75258fmr203570505ad.41.1763481045056;
        Tue, 18 Nov 2025 07:50:45 -0800 (PST)
Received: from gmail.com ([117.147.72.154])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0d34sm178002575ad.51.2025.11.18.07.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 07:50:44 -0800 (PST)
From: Peng Li <peng8420.li@gmail.com>
X-Google-Original-From: Peng Li
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@redhat.com,
	osalvador@suse.de,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	Peng Li <peng8420.li@gmail.com>
Subject: [PATCH] mm/vmalloc: fix build error
Date: Tue, 18 Nov 2025 23:50:34 +0800
Message-ID: <20251118155034.273696-1-peng8420.li@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 896DD180018
X-Stat-Signature: n956uw7tkegwy9dmx7khnpoxkc57c349
X-Rspam-User: 
X-HE-Tag: 1763481046-895178
X-HE-Meta: U2FsdGVkX18rIyAQH5WUmXYfapIl9ahgCISAiJ2Z9DeCUkVwSwSyShyMQGG01OEyuo5BwBv8E5Tg1SvIQXU3XOVO63sl0UJTI7OFd8coICxBLGkDU0YrHt+MRTu7jmEkHJDb4Q94d1CY/6PlBrycFdAberftlAx1v+7d2tzvQM0nBmIZ93udrs8h3BeVsk1zraA1OIsBnHlYgug/mmhaJQ49r4S+GIvkmZOivibtqzJLuAw+x1PYTqRUkB9LcLlgbbGB5MfhX5C5Cbip73F4zz1lQvEPYnTpQlVmyD165ncgOyVDMs0D0IqCD8YbE1Ca2sQszdB7wr+x2+rHv1pCGmts+qapUchVvdlV9KRo9KKHQQBw5MRqtQWJH4GiaVcHUa6eAa1jSgLgQ886RCE8K1e+AK/rUam+5Dcv6ce8hl1xYkgFbP0XBkGL0RaHM8Qx2QyfBbgVtEKVg4wrqilKsGsH20VRf1XgqetL5A3HokjzB/nGcEqRSktAECEcdzwCzKrJolpE2olNrHzglhhOxPVNxErGRt66Glp/ml4VJYefv2UAN/3Ivtl74Yi1Db6CJYCcwYp+ljg92MPI50kB44bsz/uMrqQza89uvlMnQsbJAiKMfd9kgjNmEgc8n4Bc8fLGMvev28wBMqF5DT4FNqsMU9AYtEpX0Als+K8rQwEFdKav5cpT4wfnU8rPfTHyTt3ejWLKeexPEiSLkjsVdMxyvAptZ0oq2CrIM6Ka9fWrKgb+yl3z4eEjht2UHZIwoICqYkHmZ9eYaPjqHSLAYozl2F5EByEz2HtLWjzTDBL6oZySpcmfyFunM5+tmXF6YB9VyPxcyp6aS2NH6e+atMJ83GompgKNXWo1FYJU77gcKT8IyOJ31Ou+j1rVBObMvg3mHXKa2vHfGNJXk9gJRxnX/dP9tqK7GxYRGRhH4k3+uLTJDohDKvP8trfhw068Ic0dHO1FgxuZebgg/Op
 RUH4Yiaa
 Sjh4Z1mfwatzprf6TSPXcbEimdIf/soXBY/wvAqnEujHs40auj+lpiY8Kq1ulcn7Sx6+6y4sXd4qQAkUgM4ZCG/nZ8Pw7GQ+lz5cmQgU6S5Fus2ssK/v8la+k5xAAQ3TXLOYjB+ydZLW9RGnxVM78v0OLkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Peng Li <peng8420.li@gmail.com>

commit 056b93566a35 ("mm/vmalloc: warn only once when vmalloc
detect invalid gfp flags") modify the function call from WARN to WARN_ONCE.

WARN_ONCE input parameter format error, missing ',' tag.
Resulting in the following compilation errors:

mm/vmalloc.c:3940:19: error: expected ‘)’ before ‘invalid_mask’
 3940 |                   invalid_mask, &invalid_mask, flags, &flags);

After adding the "," tag, the compilation passed.

Signed-off-by: Peng Li <peng8420.li@gmail.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d78c4d09d6ea..0469ba2c230e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3936,7 +3936,7 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
 	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
 
 	flags &= GFP_VMALLOC_SUPPORTED;
-	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
+	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
 		  invalid_mask, &invalid_mask, flags, &flags);
 	return flags;
 }
-- 
2.43.0


