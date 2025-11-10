Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A271ECCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 18:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED128E0022; Mon, 10 Nov 2025 13:07:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5A98E0003; Mon, 10 Nov 2025 13:07:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002778E0022; Mon, 10 Nov 2025 13:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3BA88E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:07:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C22AB72EB
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:07:24 +0000 (UTC)
X-FDA: 84095479608.26.29AF50E
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 94BF018000C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:07:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QLgOmEXD;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762798042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qL9D4+vuZNdcA1n/TETU1FBv3lcXALq5Yj616FCh89Y=;
	b=vWMLBgHF0+Ys9aTmIpYIOep22cbV3L8u8iAR3rMWRzKQsCsMEob8GDzE7KHdezOR3lfm3A
	e+7S+R+d3fTWzIizPE2bZi/HyMbEcZBTtMfKHIfOlgSCZ1INf/nHCatdW1uR1GtJKZOGSO
	USx5DDrLApNSy0AcF6m2K6I1c6jcIoQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QLgOmEXD;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762798042; a=rsa-sha256;
	cv=none;
	b=BgNsqpgau16xLmNWjBzkcIWGr5unw3Y1NFcdDK9DEUOxZ2ReqBXl5f0UQIsJ6h6JG9Mv8P
	B74MzHQg49t/P/dht+F3ht2Vb0NTGXOb3MR+xGWslarZJG2HdHzqlOEU+u649y0g1mFObK
	FLOWaN7Mc+66VcaT9sGDJKEhd7G4DYo=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-63fd17f0cd2so2686744d50.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762798041; x=1763402841; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qL9D4+vuZNdcA1n/TETU1FBv3lcXALq5Yj616FCh89Y=;
        b=QLgOmEXD+MWc0wegM0EXWcmybmJ8ra3gt2lO+kveLLNYCynb3jzjJf5GDKFr1ofEnA
         oZQCzLp5/Gr7BnRERNMbt4WkBTYsuL5vELAIw3ZZH1JDHLCnk/MfPLUbijZg0why4J8F
         VBXCw9IMNcgAif91cS1lFSXIAjZ0sm5JXjmp+DVu9O8dIWTRaGT0w5iPQYidBVObvLdF
         mRgouXPg2R/ifZzr6fGbab4jC85IBg8DThBgggflJdb2oXbS9t0B/tPeCA1UQAZNhOKn
         BlN5tPlyTW6y4h1bIDLDN56v/Oo3H21MWpm/21XGBab5yiTSwyP1QvKZ83GFQkM1GXcy
         y93w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762798041; x=1763402841;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qL9D4+vuZNdcA1n/TETU1FBv3lcXALq5Yj616FCh89Y=;
        b=Js27goU1Lp7HkUo2ue9of8E0q1GwpXReKnBVvhlVNSkAN2ZUwjsTwA62cv08+nWWPn
         ghkfX1Ndolje5yUMPxekc0rkXTzrXUU2a2TNTi3/zkb3KCkjJLB4ZWh9R7CrP02qK60K
         kGk2/IaG90R83uh93xwbZ+NZVsxUqsZOHbf9ovTPAyIMW9WZtOaC6PO0VXouP/KHyDFw
         KT9+dCHj3eZeiqzp4M1B6uowbfbfW6QeiOln6CT1o3UFSk/gBJcpA1JqirjKd3VTHaAv
         GA81qw5u6FS0Re8GMaVmzEDTgsmTXP+tta9ijOxZ0uF3Pyi/ogaf7HPuNVEbRacqa6Ux
         rRgg==
X-Forwarded-Encrypted: i=1; AJvYcCWZdOZPfdJL3uWhMYOuu3Tq0sKYzZVXyWsXlTCdil5ciyTqkvuuBJaYKHryl2SbuV8wp3D0loo3iA==@kvack.org
X-Gm-Message-State: AOJu0Yz4pWvuA5kT/XcW/nkeGN1j0r1AdEtucPtAxQDtew1Qhw3Lmak4
	QUu8Mq2KvNSy8mB2UH1nfl0Bj5Icm7XEHTDE3g8YHhwmsEALFhhnMjmbfoo8tMAuSjE=
X-Gm-Gg: ASbGnctBpV7tfGxZihTLXN0Sg/vhjDLGXAif1Plh7yTp7ekdbHniBZP48yFxsGLTN23
	vuhlPgqM/TvTQdYnBLFi/Ysl8JJr4r4NUV8MXS29MOkCHgVofSGNAQEoOvDMwRR2KqKRpSuFNLa
	47j60nto5R+cbscMiE2HpESrUA8IJdUbKOZf9BBD4jJPAw8dK35+lLAAktR+G8JrUWYiVdZtQso
	2ocOlu43y9/Vy/5UYojIGUf1acUCBs8dvbUD5rfIFZwEVgju1q+EPsg6JNWQv+Z+fG+JFXWiXbh
	qx9EgF5PB3RNWQa8ZajZPVi21Jv1WFxRMVPtL0mKtAQdFv5Q4I9Y+N/Z5+EWoQE4SDjw7XCGJM1
	+AqUQM8wjgSET+OdoFuuk8DtFHhfPZ+8BfpSY3rOENDPWTpuyhk5nHhh+h6ZlM2qao1jqYFHfWV
	x3PaKnMLLOYAf8eXM8fUqLh+r820EJXcTzNUtzBxr3XBn73M62qjfCncYkXtELr2n4D/ss8PqvE
	Rr+W3I=
X-Google-Smtp-Source: AGHT+IFI8k9m6fstEvlSakNx4eRqRGXfQ5gFh54/EdAevddbPRJpRnpFRHjsRRXHMaEqb+vKcs/2pw==
X-Received: by 2002:a05:690c:3505:b0:787:cad1:bdac with SMTP id 00721157ae682-787d5473912mr97384637b3.65.1762798041432;
        Mon, 10 Nov 2025 10:07:21 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d6a3f334sm25489757b3.60.2025.11.10.10.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 10:07:20 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	graf@amazon.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH] liveupdate: kho: Enable KHO by default
Date: Mon, 10 Nov 2025 13:07:15 -0500
Message-ID: <20251110180715.602807-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 94BF018000C
X-Stat-Signature: c35krarfxmgnghpunuq9qs5hz3y6wfi7
X-Rspam-User: 
X-HE-Tag: 1762798042-579652
X-HE-Meta: U2FsdGVkX1/rJU71kZbQTtCroGL61uNFZ/oIYqkXBXWOIV2XBdBCbP8x9VIeQMVxEfqVuLLS6Y72O6zunZ4DY9YfiGsLlP2lG7WJzBfxRP1Wb+GGuv/kc5317rx0YQEQJoWS4LfIb6sL4+OZ0VCnO1vGWM1BOHk5AlLI2YV6llG2eOvwPfywO5wonw8eu+eQHBxVxfcFqCo9U9Zp2W7DjMzR5rhXcpk2kFiFhctSQHXACNpQNEG1u7uEeiOYt/Gi92bLJKx/UVOA9vTfwZoktJb4Z3Ym9ZofSamv7a5fg+Gs8Ch/5weGGdTeg8HPIACVngtX1B+yPn9wjMUh00bFGvOM65/NAOtYeHGW3fHlbuMFnqujB4HOIhF/0HzvVXpzDi0vWXkp1wB4RfJKB6FXelMpmE1RIGPFAR5LtqMz0+iGVJVK6vOg2QR3SEk4cimAJi3BmsYXe+pQtjR93SzQmL6Jlkil+z7/kfPZlsV700E907tgzxpgkBRTtcmgI/Od+x3kfO3/RKvQfXmfmnncvrKAkNt7c0S6krMK2myBkmT7qYOaWB25RZwOUYyvP5Lpmid6REP27D9cWeY/jNU9wKHI9zuN1Ld3zl0vvUGhmD4g+NTyzvj1wQbdt0C7CocqjkpDcK468HaMNCYRNpdN/KBLnhD0hK7EFryzS6uhQG6rg49y+atHXKBb8GsehkpPULksziga2ou2vWs+FbwQM0xU/eupEiCCFOX5GqIFHZhLdS0bHvcK8I5sFX7kKkCvIjbucN24ope4QGS14zKp/9t4jeOmoIkaZT3iPn5eUAKLWjz1GZetBOByRAk6WX4TOR3AvqGK9nj9DJ+AqQyshDdfVgoQXyLUlnXKO8P/jplMeOkUJXPZecoXHt9bGKhxxZCvhTd1yyOkrNH6eiomyl0uLSszBm3tXLQiZuBzKuBrdPOW2VxR812jUOYLB8TiHZlUEckSd+McZkuR7Ua
 Jf2MRnjz
 AOGLYBJsh5/uJRYK6vHnZb982Y8ejH7HoAAdBLGA5thwRwSt6O/9ThNAoXGVB91mw4quAYWfKq4w1i8TDRP4+5srYvPv2UFrY7IaUxxLOeveo5x9fqFiqeeOvy9JCfvxQlnfCSSTz0zoF047nYLMY0zi/+4ikSFI+Gm8Vv5a7cjhD0qwjNZ+Gtxn+IXjVXo2dGXA+Ue4dHGPcSN1i2poTW9sjZnXMP186FyePj+SqP0TVH6mZnT9nG+kAuQtPY2Vahseo/k9DlfIGE8rlJva/vwVJoLp+AzxdnEpTMjy3P5hvUXCjs6JBeDh9ZFtp4T0LaudUhwBaMIGz11xZ2XmeQvsFC5Z59uMmWqnTUAas+7mesIk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upcoming LUO requires KHO for its operations, the requirement to place
both KHO=on and liveupdate=on becomes redundant. Set KHO to be enabled
by default.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b54ca665e005..568cd9fe9aca 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -51,7 +51,7 @@ union kho_page_info {
 
 static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
 
-static bool kho_enable __ro_after_init;
+static bool kho_enable __ro_after_init = true;
 
 bool kho_is_enabled(void)
 {

base-commit: ab40c92c74c6b0c611c89516794502b3a3173966
-- 
2.51.2.1041.gc1ab5b90ca-goog


