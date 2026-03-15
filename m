Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC634D58B0A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 04:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0048C6B0088; Sun, 15 Mar 2026 00:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4986B0089; Sun, 15 Mar 2026 00:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E004D6B008A; Sun, 15 Mar 2026 00:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC60F6B0088
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:10:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E6EF5C69F
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 04:10:36 +0000 (UTC)
X-FDA: 84546970872.30.44D8FC7
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7099840004
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 04:10:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b="rr4i/ocS";
	spf=pass (imf17.hostedemail.com: domain of r@hev.cc designates 209.85.210.179 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773547834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKI+YqwJwuQjw262CBFVWp4TrJeGSGv4OI3cEOIx48M=;
	b=wmtBM89ygT2PC2QJoPfRpJu32wXIs5hBqNqqn017kCOTILravXloJqa+hQdPCzWMUCb9m4
	yYTn6A+yR88xXMn2Od2MWb2J6sPgZzGMXLs55gxzUHWX5h5NmQEU/lM8Y+MViJDigROQrJ
	LG9lELmwK/E1eO1sBcHA7+LmbqZOBhs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773547834; a=rsa-sha256;
	cv=none;
	b=T29s4Zg6Ie1He0x0fdjd9ORpvMnYZ8g0w345GWqKHIT/itDw5mRaflzHqnpv9i8+1L+5Zj
	VYc8jppmxJsVzrF7H6E8w0rpGmbTi7ij7f5jlZzPDmImAJdVl8vAe6sWCavCWvhatD9sAw
	NxQcSKLXAgdtBG9vlYfvfmnv0cWXHhc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b="rr4i/ocS";
	spf=pass (imf17.hostedemail.com: domain of r@hev.cc designates 209.85.210.179 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82990763921so3300577b3a.1
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 21:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773547833; x=1774152633; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eKI+YqwJwuQjw262CBFVWp4TrJeGSGv4OI3cEOIx48M=;
        b=rr4i/ocSdr3cyZnATtnKV/ZSFc47oRH6pGY++1618L5PzNLE+GRxkeLwYQP5W/jkAS
         1XW00G1H0jjZXE1P+LYqjSq/BJHUtI08+eatpP/g+WuktphjJO5ENdyy0Z04XIKfeH56
         e0BrpsElV4ZH6lsksOv+HRpxP95tyiDon90gZL1OiudltNoDjkBC3RVLzWEetETdBANi
         C5dAuPrdBUeggAB4+Ib8Mq33PUtwgXOiFJjlUhBN1SI0wiqlIZ+WupKJ9aXJguO9o4Ux
         ubxkTgxzplvJByJ6u6ASRs7CvYSFjB5W3MrYNeTdYPLjeK3d/deC0n55rQmPwsJI4vD/
         mAyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773547833; x=1774152633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eKI+YqwJwuQjw262CBFVWp4TrJeGSGv4OI3cEOIx48M=;
        b=rnPE/t5h4yDyR7TXfc7d7ZhvZ3NLkDZgJYpJb/v99VNpdGGFiKA47aSnEn9dRezTVK
         AAyozj5E91N6SdPKCXbA2UMkDSaXauO6M5eX+9hkSUANnmka2z4yIb6L1E4Dk4tWzHg6
         WeiSiPWlL7UMSHa+oUS1J1BvvfEVV4TM0bGFfJll9QqbaCvYk2Ovbmo0d+5MTG0ZyO2M
         aJXDalUyIS5TN3TX9TDQhSRwERypJ4DoBHXhPaOb3OLoLBSoMFTJcHEZ4dxo9i1AYfR9
         nEW1gaeCmv4ByM9yt3TcNg5VsBWQnuoxNSa+p53cg0AzOn2G4UKmt8o9PJ8nHS1FMvrs
         zJ3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUsT4yx/fKxYmngSjNA+wnOd66SGDJ3YhZ68OrbL2tLy1bhztbTmRCb66vNjRkXd7wnyGGFcyxNvw==@kvack.org
X-Gm-Message-State: AOJu0YzplZSfGfS1TtIIbErFrkmm4evX2XcBf1/1/v1Agq8MSx2vGLeR
	ZKhR8bWIdb5GPxT5QQWBvYhPTf4ytr8SGSIVEmg5LbRVAXMZoPzlqRoofSaLGehxDxg=
X-Gm-Gg: ATEYQzxgtHfyIvFWbuQenZb7joMKpkgllviI3kg51Yshk0jGbmIiQe9+39DGNpITqVS
	07b6sSTV2v3fOWp6vGCEtuVepTPuPt9HNX6rgN/iLH0zJ28FcIkPIS1TXm5suXDp2V5GlZnuCnU
	wdxL5zTuZcxm/E25LM0ym6FJd2IjzRvRzGcNF502FK7eh3HqCzaWFKPBcG9kyBGLWHMQj/QoVdb
	FiWQvFHe5nkdz5LQ9BdgojfWsOtK8a2TyoSMYvKLR588ZfqGcp1GtVApy+Pw/NvBzgPqklnb1gp
	NXBY3yFap+Yjw3vY8AQ5iQMkBN1pMN1eTdd+ByVxZJVY7WuET/edFXPEbCgPR5wNyULhYANd1+i
	RGZdMF+ggVy1F5z3VKgvlK8v36tzJbR7a9b/qtavoWodcjU8Dc7VItqO8FOgEv8sj6MS8s+F2Q7
	qi
X-Received: by 2002:a05:6a00:6c81:b0:827:2dbc:27d9 with SMTP id d2e1a72fcca58-82a19907f86mr7927525b3a.48.1773547824721;
        Sat, 14 Mar 2026 21:10:24 -0700 (PDT)
Received: from gpc ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a0727c1d2sm10079491b3a.25.2026.03.14.21.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 21:10:24 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: lance.yang@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	david@kernel.org,
	jack@suse.cz,
	kees@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	r@hev.cc,
	usama.arif@linux.dev,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH v5] binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for THP
Date: Sun, 15 Mar 2026 12:10:05 +0800
Message-ID: <20260315041005.11682-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260315034647.8462-1-lance.yang@linux.dev>
References: <20260315034647.8462-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5c4ftt3b3za6bu9yrrj8qichze4nay4e
X-Rspamd-Queue-Id: 7099840004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773547834-74342
X-HE-Meta: U2FsdGVkX1+dAqgAfhwl73HR+BsrfHl7LnVI/LlJp+xmPHIvhQfLuPmjHG3CzCT+D8zPW+U+y06KOhjad9TCuMxav3EA//ln0nUvXXAekDjRoKAnuUG5VBstOFCySk9hEA4c6yVFCrzWzxviuUhlkuuEsrK1H6nmStqJLZT7LfwP5E0s/oKotjKcBacuOEcOD7kXKc79CdFhTxDSpZKJOnes55iFkBlHSOba2t6TUcXH6MAOWBT65/h1rENEtIbsFAe3JVIsg52nB27KYms7Jcc4dmQRpAVE48ENlnsm1p+WmyGNvEuTfmELxkYPM91aRmP3uj/edXYHfgTdcDKQnBfDhX2MlHB43S5UrwVHg9LZfVeyb3iMihjU/eYVfJydZPQ5xjb4wmtxxnN9LfV7g1I63GKg0mP6VGx+mqbZ/b3i6Pf02h5G80/CuksLU92eLliclzo8wObAIzvcm97GZxS49wZUp6cK7ZZ+uwTXtHWcG2pxL5cEQDs08AHxvkr1qekBMsj3I6qZhXFq3TlzeZfdlUSp/AszJAj4lvxnfjO/aH00567xFNzMzeHn6map/sDunyKSuIxfj0J+kQhvCObo9IIG4NCykMcM1vR4kQRi+UBWgLD6ryHjsGvIv2ZbxEYt3CLWSwYyxbARyQSidHv9RIDb2Mvij2d57wsFV4PDpFeYzYtnyve+jvujd+DpzNqb80GdIzhWjIkXjZpEoO6OLNl8bfe3SJYmsXURakfY4sLV/ZRt8iRV/4WXHbXNFFs8raTSfOUuKrC2MOC8nDFEGB/ETrh3DcxzfCuhF3z7UB8OYJQIpkv8yXDnGUrvfgdBeRPB01Yym4BViDQOasTLlpav3s9KQ3Jgko8o25nzEOWmghdAmWaSNHcBphA9RYl1UyKJR6OhmRENzz7nPttpwDQTiIH+2NLzITUPHYZ6WNYrbdPTgqst5F6kcqQQv288wZEPyvYrDeCQ/i+
 SA+i2oW8
 GtOz4gw/kLLQtTGntnfbvSuE1X9MsRd+epaYx7EEIrcG9RVeLn9AXpikc1c73Q0N76KkJOErehANbk4NbmkhadWjaLHls6kLpseYiE3Qck5zeYW69ONqPKWS8SPUqs9sQ1CLI/kD7+85MaDrhSqkBz6myzFar0JstkkCS5FY8s6JG6zDVJuliDBQsyQynEbHHA40/YdIK1TXbOx80IF0IrUwPUwfCGvAMoUiVydBLxOzRkIU1OYBZwJDLxhSfjVqwFk4wjND30fWT6VWADovSggwnoWcvEzVU35ZxKeucmEbJBrRDlvSVXeyAkIujNVLXYMgr4RHnTndYGlzJw7W2Vo3KZNv0f9yunZwYrRBWP/advkKylu2WwDPV+MS0Sf2bImXRFBoc+9d4VKeHnw1FQ+RzUuFNR4ds8JDLZ6x92Hfxg/j2tcsxy/JPOsW21M3S9mzWhAvKKSFa6jYDfOFh/fTEnOc4VUFSVBn+wjrPqkBwzOUY1oFeM8t/xl1+/Zbc7I2dFvg1lJ+cH0r1g41HBB3nWhlZ4Rn8P/dr+J1D74uaG0qq/ZIdXgcgn39G3h5Si3T1pkEEjepwfKjl9SE8PFCIpueUdgh7bW57
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lance,

> It would be better to keep earlier CC list across revisions, especially
> for people who have already reviewed or were explicitly include before.
> Otherwise, they may simply never see subsequent revisions, and from
> their side the discussion just stops there ...

Thanks for pointing this out.

After addressing David's feedback on v4 [1], v5 no longer looked
mm-related to me, so I only sent it to linux-fsdevel.

But you're right, I should have kept the earlier CC list, especially
for people who had already reviewed it or were CC'ed explicitly in the
previous rounds.

[1] https://lore.kernel.org/linux-fsdevel/60ba4311-01f8-4ff3-a2df-e1b3fb6db699@kernel.org

Thanks,
Rui

