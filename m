Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA4CCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E63FE6B00A3; Wed,  3 Jun 2026 11:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E145E6B00A4; Wed,  3 Jun 2026 11:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC6C6B00A5; Wed,  3 Jun 2026 11:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5C606B00A3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:44:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 841D5A0433
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:44:30 +0000 (UTC)
X-FDA: 84839023500.14.ADDBDC1
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9FA4C180005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:44:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VKgeYjEQ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8sI6lLCNHN6RKEMLtPAJ87Qc5cPrvkoDu5wACGhMgc=;
	b=AXbsMglF+TUGACQp2cLhDe7dbOdoc6EWihHyRJPJbeJgAuMvCZbj+/xkwNGOhnYfAJNpX1
	WZJMT0XyIrpdPw5QL+2mzADbbp5JwmsRoenJPxBV8t5Q9Ez3tDvrcTHRbBr1N45FK6ZzYr
	7u63Wqm41kEMkyRZXZmWaDKxbgM9SGc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VKgeYjEQ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501468;
	b=8JHuqt+JiyVch6WAe6ze3R5CgIIw+F79aOhZyWTMK9RmD8eRf/G7qws0LWZori+csYnyxo
	ui03n2+27sz9ZLFfLvswIICDs6UnHAdsZCi2ZfLxmNfBIXsFLfOGLsWlwHDUHJwENwM7nU
	XsTl+5ujehTjdJx+MAfMBoJg3EU/XyQ=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8cce26ee1e9so89594936d6.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501468; x=1781106268; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i8sI6lLCNHN6RKEMLtPAJ87Qc5cPrvkoDu5wACGhMgc=;
        b=VKgeYjEQU3rLoq1hpWHznhrA5FP38eYAxd+MLjgx0e0GJrPyq6HHQ+5GJK/B/HeQug
         tGDYz1qWeCi3mJoTPYLo1fbmsPMNz7qfRF1PWeFXmuaJyHGCcz44n6pLXBwpbCWknBIA
         uIBn+ab0/wqeg1WjHgjUX/FGMuemHcoreI7oMttDht9yQVsjd8UlSLiM39v13QlL2wLH
         sGjIf070cvyf/F65avpZHMUsaIWt4231Xm1e03fPe8LbGKbIdM18KgcRiQfXU9Aixl0V
         bhhSJZMZrG2wYx4g7vOe+pOSurx7I/wWlbT9mNzGNJAYXg34wvGSyI1liM6bCuiBrGlV
         YAmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501468; x=1781106268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i8sI6lLCNHN6RKEMLtPAJ87Qc5cPrvkoDu5wACGhMgc=;
        b=boA5dYHXFar/ZHRUjBq8nmbHhF5zjvk0B84wplrhHzcmFh+d5Cbrf5/XK3rSnBXwKo
         rIPa2Vg0tsDMln9aNYJ+RWbK5Vm9C+iGOmZbiqs6pq4fwbE3Br4IPzxRUv6uZbQN6dcH
         apUZcx0BmEv+C/yGsEPNSiU3j6Wjl9YZK5MI0ZPjLTY6CSMoEi3zqXxB5n+CXn5mlSfQ
         s4NSvXljYp0ZnfMlchBGo6uJdc7o+uAHc5FKMFrKuLHoi9CjFxP0qYeyb2NZx6a4MeZr
         B8skWIkGOxq368QSsdQw+0QENHAHP2Y/PPu22MqSajf46snyM6TbrqjJ+dBA5iE9sStL
         VTZg==
X-Forwarded-Encrypted: i=1; AFNElJ/VbKzQeG/2429oljxqUyMmaWML1iMOe37qxwDi2p2cSsj5V9BZj4IIlD620dDSrsejgLLLtWOvRw==@kvack.org
X-Gm-Message-State: AOJu0YzzFhr5hN3tB7X8CIBNQywr80XLwCSa5UpNETuox5luZYoyF1SC
	3MmzWkwAa8RE5CnVUBhnIa83NFBC3kS/U0um3ONFGG4vKxWRirNcoBKvMeGPQK1dHJA=
X-Gm-Gg: Acq92OFxP6fK/vg3fa7JgkhnP3hv1R7aox0H2oNyiNQx6vfye4j4+0IGxNF49YMCjeM
	eQO5N0qEXOpkiQhwNndQfYf5k/He3taXq10ZR/BvzByZHIFe3ruyC0rbdBn/3XalavmHqcFW0pD
	zy/ieqn3y33JNUq4hVFiJ4pqMG6A0f+P28cJ1skc6KfYW6JerbdsS/yF54KH6EfjaQi6qSLPxfI
	w9umlOgsnEfhqEVQidpHyTk14SDcofIattdJG9UF8bgCFzx9WcaW7/sCCl3sGLmLc9VvdXB7fTq
	dGNhZSw6hmj33PjT7aDyhAXRvdwrI+V4XPht7c18QRDaWPP/MermTr7gkH0BLVWW5SDNPySm29j
	6DD08O9ATJ/8pgILi//tCVc524au/iRitwPrH1CxKpDxS3vQxVSjMvKCNlTsv1eIhIHMpFvSWbP
	bYG5oCIi+Hhvcfqeoz+8BbqvjCDIUsFShbTDB7QXKbnX3HCX570cqkjZwF7t9uGQ==
X-Received: by 2002:a05:6214:aca:b0:8bd:6baa:6a0c with SMTP id 6a1803df08f44-8cecdc28301mr58362326d6.11.1780501467702;
        Wed, 03 Jun 2026 08:44:27 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd0520d3sm23311476d6.27.2026.06.03.08.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:44:27 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v7 02/13] liveupdate: avoid mixing cleanup guards with goto in luo_session_retrieve_fd
Date: Wed,  3 Jun 2026 15:43:51 +0000
Message-ID: <20260603154402.468928-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ykahx3rk89wr15qbhioumrsoq6ozawqu
X-Rspamd-Queue-Id: 9FA4C180005
X-HE-Tag: 1780501468-689237
X-HE-Meta: U2FsdGVkX1/7AaS101ZnLoD+KZXKnn9qJ2jYPmj30a+TWdu9TVO4b1GlZU5/tmsq01YP/YV9/TEYcYipHTXfW1qrX9wd8g52bg7LYnHQcOzoKEjysDGxguVkqrBcvhofoqFIYvuPZTIivmSI/Jl/biE73S+tioub975US658RiMdegvoe/wwMdfftzeYlsv1iXVhsIzYySPE6J56IOrMqwvi+a4E34yMclD9Mp5KJF5mtrSxlYQle5yEWSbtHulHcEAiDtIadS15R+3iwFfaWT4B1ugNGxOq4182CWYcqnPzvV04qxtrcjDd9JUM0u7MyjfATMBt3bOaZJKq8P2liZoa5dB56lbhqEqzia+xnHQOHvRLC9ltPsQqsU/LnSYU94BzcBbrUE859UePDernTiGlR6lCalubeeq7tuxVnhztmanBjwnt+76F/lT7ix66g5db6gTRdFaqijg47j+F2pvMyTY0ScVDMog1vk6rtpbnxlSuFdy8ClTg9rETjEJR2rgU8NUg9tm6quYWdva6TU7k9V8W2XDQGCKyJ4htOBeJo0f1VR5AlZybrK5azfMAu0LqD/4gqPVAZsHo1yfqNz5hc/0lpoueLepz5o6ucw2YUnLcC1ku4TO2Op+qvJRJsMFWP9VLXwENjjLlrqpWufhWadlOCPmJB9QdJNQY6wK4m9K4Y/ECoOwOrOLl6zuRsgmhEQ7Odi7uBMhv9Xp0FT1w9K+4Qg/oddYclHM157FH/DNT/7/ctiwyR/3uGsa9J/Cu82dttvLd6ez95vCAcBe10v5HWEIyaWJhyquwNPFX6Lf86Xkvx0OHt5W+1wonurEmW/OTmfHmogdl3NvOuLZ0B73WpHsHRROD+4QAg1V8TYu9NrQd67Sjnqpighlf1XMHh0HbOg0QxCnkjPpJ6fzw5wT5n2atAmktZVWYDg8nEhluC0sz2jJX2+KWbrlPGY1DMQ2NwTD4nTwoNf9
 wBK8g7aW
 PIntAsOSr/07+zp4hQwFwMcmgXplhJZEchtmz72Enkl/WdlNalRRE4yua5kUswrwTwO/ym3GvafFgmBe+swRpSxR2dfqqjTaa50g8eXLf7AUExLWli1DcwjJfTJ+zB+tuezH8ezQdcshSHSldXd5wuXXIOWGemVgZLijoWygCchq8qitJq5vB6aEOV2+EJSM+mM+gCIt/uWd1Dc2/PMLMEk3wGyKASV3R1CuTjUcBdTpfUwaPGUB50+EjjaVPG8lz6+ujASVp0RzoFbngPF5f2DfNetA8q52vF6ingKQA5R1nk/uEmCqAOKFAcH1QlTcFkpdkcgUi4VL2cfPcFCUyzaACZbA419fTt0+dmX+T628jAf4M9Bfa7Bar6SE1TPXHpY0Pqn7gL8z84DM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactoring luo_session_retrieve_fd() to avoid mixing automated
cleanup-style guards with goto-based resource release, which is not
recommended under the Linux kernel coding style.

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_session.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 5c6cebc6e326..47566db64598 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -291,10 +291,11 @@ static int luo_session_retrieve_fd(struct luo_session *session,
 	if (argp->fd < 0)
 		return argp->fd;
 
-	guard(mutex)(&session->mutex);
+	mutex_lock(&session->mutex);
 	err = luo_retrieve_file(&session->file_set, argp->token, &file);
+	mutex_unlock(&session->mutex);
 	if (err < 0)
-		goto  err_put_fd;
+		goto err_put_fd;
 
 	err = luo_ucmd_respond(ucmd, sizeof(*argp));
 	if (err)
-- 
2.53.0


