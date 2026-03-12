Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACF7D106ACD9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 18:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289A86B0088; Thu, 12 Mar 2026 14:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274506B0089; Thu, 12 Mar 2026 14:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14CA26B008C; Thu, 12 Mar 2026 14:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 042D06B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:40:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B44F71A0393
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:40:58 +0000 (UTC)
X-FDA: 84538277796.07.D6D77EF
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id C292A80010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:40:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TNDHwcH3;
	spf=pass (imf02.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773340856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9k/wKxZxUpjtgU4Vct2zinh+jVqJ329Xh5sQ+TzSypA=;
	b=qTVB+b9RBoBNq7NVzwluTFyrbD/PygVA0zEY7lODkCXcKNlrjt7KaXWDUKMSXYwnr+svak
	DIsbr+Ouz77/jZdvENFmxiuI6CshPDAxUWNxVQ8Ng+MEqjgb9PXPEm0yPNDJHK+rPjgzwr
	VLWp8edeUhmP/w+DLVZnK77izQU6G28=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TNDHwcH3;
	spf=pass (imf02.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773340856; a=rsa-sha256;
	cv=none;
	b=L707KNceJ0t9QkeyPqWxNzI2h2vxrqZzbjcNavGELbIYPG2yBUZV/Zn1V7p7vIZ2wI8bok
	dpnAeCwWvrXONG94c7SwQanwuA+Pl4DnSAc1d+AeK23oL1co0z4z1sSmxWa5L/6cA3Hfys
	4Ll+KggZqu7xH5Gsxohixl8gilvpAO0=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a13d1c6f25so1459030e87.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773340855; x=1773945655; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9k/wKxZxUpjtgU4Vct2zinh+jVqJ329Xh5sQ+TzSypA=;
        b=TNDHwcH3S+84R2ZRuuBkar5BSc6UeXsLhZLtsuJJXoiwCFWISVr+ykScHHd2ki2Hi9
         a3GG5sM/BSDGMMAkgltnnhKA9ad7olttIYN8s30fA/JInAjYS7Z3RiIOdDaNO+62Z+IE
         Y9MTPZgtHDn1wIguPc6A0IjLBLiwspB0AYlcuGx16PzSvVgL60IDYFRrK841XcVP3yHD
         40CLGlfuI4zwVHdx1fOBiPaJSmJCb0KiYzn0fWrXwC9DLk/zhS2kwS8SjGmIkGgaSk8z
         Nq9IbK65v8PJhJUfZEaJsqAdS17A5CinFVnMCxYio6/+Opico6hFm2lJB2dFVB1r4yJd
         ad3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773340855; x=1773945655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9k/wKxZxUpjtgU4Vct2zinh+jVqJ329Xh5sQ+TzSypA=;
        b=d6vz854km2J0BSrQtrTrXPh0+IN8X1BVGkmuTvkgcbUpcT3nRq/1XOo/P0w3xUfRHv
         YUOypbyX7GoayJkEWf5QjoQpY4AdgDOYS1YEVNt6w++9xr9MoclOaCHoS6KgetYFM6+B
         K6OME4WmHmqcymHIknPoM/d/9Is3whfAyS2hj5Cx+VymbIgoTl+Cxha/t1TXWvcaNy3i
         T2vWYWRzl+uQblA0sM3wHEmEACV4D9RE+AAMRxZD/Q3HkgQGRl9c/rxBaBqgOW0fhEK0
         H4nEI+jEJXPA2Ow1JBbKheWr6j/YjiypuJv0JIj2nEYLuCZ4oD5GD77tw/br+rwk01cJ
         2iPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwHNT90y7k6ET3LrCUWRlpwLPlBjW/hBnMag+VFueiuWySP6HX9q+OgXbXztjU3C9LtDBxrE3RFg==@kvack.org
X-Gm-Message-State: AOJu0YzJnTsgX+3qxFxdwqqwOn2AOmu/mcU5j/1AZV4wPwRYGy4bTzoD
	deWI/uDDM13End7p4lB/gJUjGxs60XHBpO5HDTK5qpn9JgHWjy2uteAW
X-Gm-Gg: ATEYQzwiYWt5AgHVPi2mLatvAzu0fiFQus1MuGoeY+DhBmOFvIdrgElgDGebQBCP3Do
	LbDqJaHI36RKga9KfIiRRBoH/4Mc8ZAob2DCZ/j2iKqJ9ejS3maq8wtHnn/2h9GyaW9bD9lD5bS
	lq4iaceuIXNnTx6NoLpnKDE09xf7xa/pk+O/UXp6iBDkUwupr6RAMj3IRnUBgYi3UqSNdegoCIg
	Ca1WluQvXF772mA9y03+9fudsoZBo5ZAFh70XjQmw/A01E1CbbCWLlfNipmeLa6Qcv/0gpHZgpP
	ldZyFxIQRw0cNO+lRh+/fO5RDSNMQqMhN7FRDidkxgIXPibGd5wt/EXDewNtyMlG8rRJNA0eqwT
	CCJUgFlTSraQPOudAfydT+JuuhJ/TiwqYT1+3UZDeE1IGwWpqHa9KYZvP2yufMWByyRczg9wAGc
	VMwgFmMi+8iUMoyLwiYhhgvPpoytXWcAszwEMaSq6P7wVq6mynF+LzIuxRWzUC0DXaXYAswYSJH
	T/6X8yn7A==
X-Received: by 2002:a05:6512:3b9e:b0:5a1:3a0f:f2d6 with SMTP id 2adb3069b0e04-5a162b06d05mr249759e87.34.1773340854947;
        Thu, 12 Mar 2026 11:40:54 -0700 (PDT)
Received: from ubuntu.. (static.159.107.27.37.clients.your-server.de. [37.27.107.159])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15636b69dsm1107694e87.82.2026.03.12.11.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 11:40:54 -0700 (PDT)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Josh Law <objecting@objecting.org>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] lib/maple_tree: fix always-true condition in mas_erase()
Date: Thu, 12 Mar 2026 18:40:54 +0000
Message-Id: <20260312184054.23481-2-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260312184054.23481-1-objecting@objecting.org>
References: <20260312184054.23481-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C292A80010
X-Stat-Signature: myh1p5y8f3bjni77qjitgtg35k87j8pp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773340856-435835
X-HE-Meta: U2FsdGVkX1+swdUKCv2UT46hGrY6FzsIX2Wl3Tca7YSeCOsOLUGa90BAkaG+erzWalOq4wQwYmWc8ZAmlD9YHYyv8+KOrUpfNjgLinMrlEwLPu1wqZsMSr8Z0fIDgfo6uIlwifcdjGpmVRzlaHHAh1NLyGnHV34ig9BCrLYFTtNFnzLLCcDt5tX2HnFvEvsPTFR7i/k50qL82q8jAysI3QUU7eiv9LcL7/q4YFicpC2pXHR4o68v1xatU+THanK12CldnaJUj1EnqyVaBYkZXckGthMtOfaES3dNkO+xB7EqdOlYFc0zcvZDF8GWx6om/wQIK1PD7Osto8TY/lr4EuejLIGM7lRw2Jx5pSx4rEZQf8kp4RNTBum/9UZ9B/YqSNsPyTYAcv3X43OtTtHjpmwilgtxQkHvNM99zknBcdRq1edF5knZL44Q4KZtTkBeACTdqRZJM7YX33hGKdMNyCX/azDpcxigw8dEvaj9sZqJhrk2Ux1gD4RLwulQt+jg0LNKx3jAFRE7s4j96IH78v1V5rtSL/rMEoKucknF5bYsS8cHwczmFeGQzOUyb2o3nS7udGNXrj2oG3w+vIi3pA9npWUWbA1npHuvJznA/NdcDpDtlztt44idJxErXxpQpoH8A8I++OUY9hZ4fjX3bMI5Lad1a9L+ste7g3tU2is9ypLMgIoTS/VTplCluq8z7Mqv7fdB+FIcpfjaN40SukBDZ27E86x/SXXolXmIAPF4CQTr2Zg7plEtisc5dcPjxkiQtouQTWh8t2qgb52zywFzHvZRtuOUBheUiLVOnF8tb9YHztp4eDkX6DqyPRDg2PGo3CP+TLY0DSA60kZI8Wah5Pi64tSQnR9QtFAMGS8dO/2Zd7lZY4i7zPBmvnIf4L5QVglejnDyxHsQB64/QN4yyqgNPaJ48KB+HVtNpeTFvCifGxqMyFP4f46XwEZlq6hcx2vif+uMNgH7M1c
 KQ2R3rkp
 E2sXDDmsB9tpOH+R83mVodO4b1Sus47DOu/6oXiXzM/Q+B5yqeP0j5g2AwPmkKrkkXLJr/WwaRF/njE+GRtkh2/4Rk1mJTtVmEVZGGwLVGud6XcpjBydCm/qHpeEnKqgPzZMnpL8odMffDmnm0TO6r2tUip6YH0PeUphhdEwo/1PTtxb58zrv4sHnz4w/V4LvFfjb5yjV3gW2bkm1sNeAwOsYH8dzr92bWavTBG1I9k9d4PxHfXPZNMpIqfVQnkCvaeKR9ULz3lW8UNmNqP6ySOjr7JGyfkm+GntgSRW3oA/Lsxi1z7/2uIF7NaBl4PsBBxkPCFOtGBhYCj0DtMkcHaSD/kfA+DNu68RLQvQlB4rV1+BVbu/4eAR+Hk4zVzBNs/65EM7wsRR8zn/LecxVawgDku3B05lGIGD02D4//DRtENEs9QtOzg1rLiRb4Zm1Wjp41F3vhIirHZk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The condition (!mas_is_active(mas) || !mas_is_start(mas)) is always
true because ma_active and ma_start are distinct enum values -- a
state can never be both simultaneously. This causes mas_erase() to
unconditionally reset the status to ma_start, discarding a valid
active walk position.

Change || to && so the reset only fires when the state is neither
active nor start, matching the equivalent guard in mas_walk().

Signed-off-by: Josh Law <objecting@objecting.org>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 87a2ba6468ca..9727dcefbf65 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5574,7 +5574,7 @@ void *mas_erase(struct ma_state *mas)
 	unsigned long index = mas->index;
 	MA_WR_STATE(wr_mas, mas, NULL);
 
-	if (!mas_is_active(mas) || !mas_is_start(mas))
+	if (!mas_is_active(mas) && !mas_is_start(mas))
 		mas->status = ma_start;
 
 write_retry:
-- 
2.34.1


