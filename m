Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D24CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC8E8E0037; Mon, 10 Nov 2025 11:08:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D528E0003; Mon, 10 Nov 2025 11:08:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34CC8E0037; Mon, 10 Nov 2025 11:08:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A78B8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:08:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C1071401BB
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:08:35 +0000 (UTC)
X-FDA: 84095180190.30.7006560
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 796D918000C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:08:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H1qS3Xaj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762790913; a=rsa-sha256;
	cv=none;
	b=ZoOcD3HjdfGLb7AVxtz4efwnpxJgN7jU9O8spKcn73S5P0LJSPOp4qbA+8JSzxNOnVvquE
	c7HWgl1iAfjtBn7Q6xgrSURZkEL8KfwuJ6/IH7+4VxrK0ONiKw/PhZEsM9zD/zqwwqBhmB
	cE/wgwzojag+AGPWM3rK+Nbh6cRe8Ro=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H1qS3Xaj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762790913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVE7mMINIDNpzopu2/zpPrHTRDdiMn+0L7S/Gt3fNJA=;
	b=SptKezCwKLcskbKn0De1tVpFt3h94oCi+GcUEhTqpjPYpflN3ROfarchU1rcX6nTWHnocc
	cGuL47E8kel9RcLXOKaDASnmx3h8uaeebkzuGqpG0+m9231OId8kAHAWSIPhEtCIBRJpNM
	3VkR/rqJWoeu+g+60Vj8e/oxyRCAOK4=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-34381ec9197so1482021a91.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762790912; x=1763395712; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVE7mMINIDNpzopu2/zpPrHTRDdiMn+0L7S/Gt3fNJA=;
        b=H1qS3XajsVn388kiBlmgN5go75UEmbZyP9ehCLCrgvFCCoB5/N/1+a2abL/kPCzrxx
         r5TNfvyWRlvPicU5iUU7KlNXPPUEchRQ4OiNqXtXERF2n6sm3l+Uc1j9nFLbemL/jrpq
         /YhV3wlFFF5AOMzfxfTBW999PeF8KPx7/eIZH5EmxIok75uW2FHZZ7C/n/Y8OJZ8DlBa
         Gf2qhh9MeoOHjjpYuHW+js1s4oHKG18dB735jdHkmIIHOoTUVt3oWGbcmfAYIoBh2Axj
         QsJO+Fa7rfM14afZzGGZOR6w33pEpUTxXF1YQZU/Ee83xCJobERfx7DXU83ZIormE7tQ
         eZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762790912; x=1763395712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZVE7mMINIDNpzopu2/zpPrHTRDdiMn+0L7S/Gt3fNJA=;
        b=ILysjlafMfK294Bq4SHpkPkUNNs0BIrWum9QC12x7Zs4XUdD2dclDg3mtl73RIbULo
         H9RQr9QzXz67ySC26ZdE/E3mVQ3uEpQekjbysPkBe66tOK25Bw9GCVsqOgNeSOK/1+xq
         n+Y8ilxN3UA8JmhBSWHOjoraEenA7q1Vr7Ck+39mHEfF+329REmmirg4qi8UomI0uLg+
         dwyrrEfg/Guue4jqCelABhR9DsXvicGTPNFGjlq+oqfLBIQOIBbngh1+FF1WGSPBQXo2
         /GiN1EaQLKrVr7YmBBQ8b0Oqgmz+IZn+yco0dy2dQDuPetP7Rf1GR6+44pNqmMz8jEfn
         C3Fw==
X-Forwarded-Encrypted: i=1; AJvYcCU6rwn1Oh7k0zNI12fA5o4XYppXyif3fnLmn/AMwKNOXE5snD8kD9nwpWe5aX/6FjiNoPouP1s5KA==@kvack.org
X-Gm-Message-State: AOJu0Ywg9NDh8+2n+DfisTE6otxdVlACsTbDfXrBkHbhgH7nNx0iSwHv
	071Qi3UMyv/GAKQjysxH/7Ec12L/uHBl1n8OvPxgc9x7eRIiNtm068IuaToNntxg
X-Gm-Gg: ASbGncsyiF5bX4GU5hzJBAWOeOlkGH0OQRgzIRCI7gzvTfnB86nBPvtuVx9s4u9u+8z
	4x1zQ58lqOTc1JtB6JS0ShIDThxs5d1YGdYgXwaNlitSioeiutp2kumCoKrdKpGpoEM0BERyhZH
	SLhSL0BDGNrhD7UZ3uXcnNHR/zBsrp6QRlcd+g5TM2LRAxkIAzEpP+lk0/UKhy2csepw6CzqJu+
	UAJAlJiNp3KU01O7xwUA1X5AcPwhUoGdIL+6k+jfA1NLFwjN6XABi/hQlpNpYmQrHF91ClybvYp
	rMlV3qcZTdpdIpxNE7v4vVAkpk1mLRycaFq7JfqosGTXNjPx2aciudRY1WQnhv7p2oRFOBzdeDs
	M5G/Va5vFYBTf2Xf1Y44Z7L42m1n4B8cPfIQbeuYA0/Mx/8YWA7d0nz3T38T04VKqdibbGL4MhO
	90p+HcXeZIyqthSz6AAHilywpbzzdT8KOxZQeK7/2EJqE=
X-Google-Smtp-Source: AGHT+IHboFWnsEunfUdx7DnEXCq5unRFJ0uQNAfEgav/prVSXlSnil9ui8kxWk8RTLeK0C2Ray4voA==
X-Received: by 2002:a17:90b:180e:b0:33b:b020:5968 with SMTP id 98e67ed59e1d1-3436cb8de8dmr11147326a91.21.1762790912334;
        Mon, 10 Nov 2025 08:08:32 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-34362f1f231sm9308893a91.10.2025.11.10.08.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:08:31 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
Date: Mon, 10 Nov 2025 08:04:56 -0800
Message-ID: <20251110160457.61791-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251110160457.61791-1-vishal.moola@gmail.com>
References: <20251110160457.61791-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 796D918000C
X-Stat-Signature: xfo1pymzq4c3r9xuo3xfteob8b7rej73
X-HE-Tag: 1762790913-868244
X-HE-Meta: U2FsdGVkX1+vLr/MdiVeQBKlzorfI5qvQllTYa9qAwLRESdnNGdrfKR4E89aDlTPHxDHqh1pp9wgduagrzx8/7OGmqYqEnCGLb+saPE9I3CdHr3devv8iLR9qzvSu4h6CN8kMcSbW0MiRM67lpgKhQUTB/cPxTKRClfqG8VjKpBPkmG03fKa9VNqCgjAX06bWUVGio+CWYZ/mcDhFIfloB8ASF9EJnbtFYBoZITNcd0fKaKhk1Ytpzq1pd3rqWidOXv2Dre2576xoSoOUv6RVuZQGOkmwRoNQ58ZfCuBklI3R9h40qWwhUMDqxbkEB06uOVDJTGjQfT/mPgBE4eQmdiJKtrb5bjdi+14wbUk1dwgmR10sd8eeRWYcQ31dnRBmNv2UOa/JpESmy/fR3VnkLwh5bNbszFh3Jirr6+TJsDdSyBWwgUGMi5FzA+NuE9ip6FGhcQld6oOTsdHIojQ+d+F0Nb7EVLZggrBrwjuTSJttfTvQBrjoFIk8OXxad3doWS5GKrw5BvucNuyQrpqXzbpKnmK1JGlF56o3NUWYxWzcgn07nyqeb7FYXVl1I+yF6JCMdl4VEHJ7DouOAKVEKSWNiDhTluWnEYCmCnHc//W1pkUZwWO7daEAeUAeZA3vln4K1+J8WEtC6dmec+BIKhbaqHM0/Ots0YsOWkZBiVz2UQbZI2R0RMc5PL/1Dd+c3s1nuXB+t3GFgxmso/bf7a9NlK3lvSJ3FLcfyj6SY4Jhzy1awJEotOzj1zzEdss2QFxgilghiuXUXl3Rv3v/cxO15ec910ikEfyo+xFUdgU9lXoZCUIlhQRAIioFHW2KvASyok9E8mkRR742prbbe5FhcF01ju+20jt5lXEehOO5Nv3TIiGw+sIRhZIomMnJeSm5nnytSm24IfCUr3iA4a/wEQwi+uqzF/RDuDpOsky9GGNvVsQOTSU4CSIzR3aEudCO4+VnWLE3nw6h1z
 KOSXlQRs
 D9z0WynODHk2md5HASkaZ8JgbXRgGpBN5QlnLiiiyfQgQu/v0o6FO0kUEREoS6NeHVfNlsEyrkd33hKAb45Fcz3YBAEawXP0l3XcwSiiFuX6oYH86Q8xLlk8DOKwmehDASZ0MFPbHq9J2S8mS6fyt5phNFk921tdZpxNLBgEP3PoOCKSOnV1jGJVzEcba8S2fkCL9luSpzaIA+gLZCvkAYnDrr/IOPIHue6kh5I9vVeYcFMVYKXTmDTOi2LEZ+HaTwjDApBQwtPw7zNMwolup1Z+SCMnzJHWBIiDpg+vDf5EDXaP3N16AZbqUA4vQpURiggE7qRyvZnPnDa/p5N3OExs3A57G5D9t0nw9MCFN9NimLfmHZ1vsHoucb1fU4aNYBEm9M23IJDig2MA+CsCG7n/Vvdlop44pxMohc6RhbVkdZjtlbrSDPR2rilqc/YtbRJoQ7lIgYeAoGRTnu9ehlwONpApryOhzPf+xNmUXIyrVeg2DByhXdAjtyyjqkEkuCzLymbbe3RchZ9Sm8XN1ZzH7xs+k61dbtH4bPxzKZ1h6Z9ZsxDOKXy5IrNZJepQCzWDjX5eDGN+adOQ0RcABetznSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have already checked for unsupported flags, we can use the
helper function to set the necessary gfp flags for the large order
allocation optimization.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 8fbf78e8eb67..970ee6756909 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3634,10 +3634,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
 	int i;
-	gfp_t large_gfp = (gfp &
-		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
-		| __GFP_NOWARN;
 	unsigned int large_order = ilog2(nr_remaining);
+	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
 
 	large_order = min(max_attempt_order, large_order);
 
-- 
2.51.1


