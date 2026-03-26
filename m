Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCDED10A88E5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CF216B0092; Thu, 26 Mar 2026 12:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332B76B0095; Thu, 26 Mar 2026 12:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242436B0092; Thu, 26 Mar 2026 12:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 110016B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:39:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDC4A160CDC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:39:49 +0000 (UTC)
X-FDA: 84588775698.20.04EFD3F
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 48899120004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:39:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FGoYnaGT;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774543188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NveMeYJyXR51CooSgOWz6j3nuc+FLl/9rhH+hQCzaw=;
	b=GbdRs6vTF5SVLdl1a8QvbKgLlUtrIzL9/EL49sSwbK/RL2RzIcO0wgIFpHFPYimtDKyRYB
	9ok0LYnwvKpWf8ruS/Aj2rmYjjy6pQWMfTOZtM/bPYVJvgkyJzve0I9MnW8Jw5fqRxrli+
	q8S2qC1hHGweEbIyC0EwD4H9qqlUmfI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FGoYnaGT;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774543188; a=rsa-sha256;
	cv=none;
	b=Q2hZ4VHkWUE47fXv0BCWVCDSnCa3gtadqDiG7d2+xt7IcRlUOXe2kLu+GLZrZ7K0cO4Iih
	b2x7CXG3rCLl8Q0XYQc4BiCiTSpnxrCmOGrcz9kSP2AVBLfP9NEdXUt9uRcEgL/D2vFZkw
	CfiY42Ey21uZ+jgFDTgEFSvlMPZssHE=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50b3488fb31so28804851cf.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774543187; x=1775147987; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8NveMeYJyXR51CooSgOWz6j3nuc+FLl/9rhH+hQCzaw=;
        b=FGoYnaGTbrP4oEKVQ9d4nAJ0L/t/TfdpVzp/jexbyjz1Yb6hdqNAWem03GWi+iNVsL
         z+psoHemET4RNts9n0EA9Rt7xVBlaQ0rYMwC9qew2IRgoljh8vLlqnTQC6UW3IDc0QSi
         wHOZzBOtdqAORu1oQK0oi6FZhVaGMbj4TSzdajXVIwa8NXkrz2Rg2PrZXfVmbde7oUqW
         k74jGnRDL/KxFogY02BHxiwaH+xl3BnJcaRux+Ka1ia6FQZHAS3MraaaSpUPDZLf9eGV
         TZ8u4FNrEihagmQ6+aOAj9z+we6RAryYkr51s1hs5pnB1sRzZpqs3es+KSMPfMsDn+1Y
         vEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774543187; x=1775147987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8NveMeYJyXR51CooSgOWz6j3nuc+FLl/9rhH+hQCzaw=;
        b=DU94slWxswDcueT0832yv2/XMtKxsO7fXsyNlZd8Eh4Q9xIL80S8W00Vp7PkehAu0o
         ECLpvRAKjk5tMdm1HtkW3fe3OuF+fA24avd6FcVdczWIGMWLmHocVMkefUbVKRHAUXIh
         cwcav3ql5ve6ALRWRCrB1ffr9nKVu1bGlTL7/0ZES/3qd+RRnVth77gi5fp0GCWC9niq
         f4Vu0OXLm3d6r9IbSR6qNco/PUj+cqZHAIndgo6TnozHVtU2jRop1BkxGQIB7UENXPEp
         xn2u9LIKeX9F2LR1CgijLulRwynD8nHmqEMbbSZgZs6aqVpdJ91GZxHXz9abZ/W0cYv7
         0+/g==
X-Forwarded-Encrypted: i=1; AJvYcCWnghMYy7XykRsqP4XtDP0mErMlEaNVEpcd/exaMvFAQ7lGOsGREkZXaj9g0tCdHKo06eS+/Tm/Yg==@kvack.org
X-Gm-Message-State: AOJu0Ywy2FMl8EBkFbq5yX+/W8HN8t4KHcstFuia6xayyJm7AhBiqMvV
	RBDF7rLYpYq8FwbHTubn235IY0pO1d/EZA4a09BabWpTAl43R5seNyaOJP2I94ooZI8=
X-Gm-Gg: ATEYQzzAh8Yu/hQjww2vu/k1rciXQmWtxDiV363PC0j61u3A9vR6wDeOyHbAwI+WTDX
	wrFgDbHxGgFge8uEpWzmk7kAiMRbUMdHjqdvxqQiQsw0uwdjJzFfBxN//TTuRoJINPO7rEhX7Ci
	E65x2HiNLRW1CLpIXviR0pZEycX/1QYhkUEqzOA/oZjz+oEk19YSA/Ur31E0yhPxMvKIK1ciJKR
	Uu/ShJYsL92yZV3t8h7lHRyQjMs9fmFUHkQNyZ4sZi14yZoLXudWzSusWUw4ozViQwoFWgE7EFj
	kqn7+mbTFZUKjt2L5ttp+Eb8tpzPrZZWIJBeSwgh1gC32x/og/kG7APUMrApon1y4Fao0+FafCR
	QLn7HgB9HhII4blpCPAcVaNsHupQjJJBFI8mFrbRURjI3ubiwYaPz3YkjFQKMS79ZK1y5gP0lZj
	o+36/vuLRtGsySwbIAJyY4is+bRBVrjEHngiKFCwCEn9lf7PV/qvfDy5HNcgv7YtnYLw==
X-Received: by 2002:ac8:58d4:0:b0:509:1ad4:6309 with SMTP id d75a77b69052e-50b9951400emr25921331cf.32.1774543187273;
        Thu, 26 Mar 2026 09:39:47 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b920f77cfsm28238251cf.6.2026.03.26.09.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 09:39:46 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v4 2/3] memfd: implement get_id for memfd_luo
Date: Thu, 26 Mar 2026 16:39:42 +0000
Message-ID: <20260326163943.574070-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260326163943.574070-1-pasha.tatashin@soleen.com>
References: <20260326163943.574070-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fjykrr6t5zweau8ti1cys1ibue4fjupa
X-Rspamd-Queue-Id: 48899120004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774543188-185428
X-HE-Meta: U2FsdGVkX19bG5LlqOhz/IzBxAY7kGF5zVbh/s/q6on59uEDJmEMtB1gfcRMyNVYOkhvZmmMKqZrDKNPaOPUfo3Q8hro8bYJkOwjAnFBsT2eow9KDfEKoE9kpWlqWGWLyzmaUyfHs1XVddpjWFFnClDURHvd2qiJz9ZtmC5/mhSkJLLrrg7pt73rtu0KnCrWHwAS7akY2k/numoLbEFy6VgZeVfaaDyVG7ZvZQbyNTww49ptfZy5C9FlLr1WxQphbjSkNs4S+RA5+qpVqGskDIr9Cir2W34Dq32o/aDEfjXX1WZb5NP2XDgKodgWtlSCFrMBq1zxEcRoXVYskZcFRGoKg6x5b4u2iOO1scvv/Vr+pYJdrP5fuEJVPicdzPMtKPdUGOqmJ40dK/oTEzFVH9FvHQItccFmgls4qqnEJGPXXqBtojc9NORBa4bkHRdi8mBgjY5uYaKKUGseQfVq//1fudjtwF0N+RdYn6E1hnvXaaeetX8trfGNVBra/Zpi/SBH2a2gOkhoCcO+zt5NmvKlT2FxXvCVOb+mX3zNOfzlnp0mtiHXlNLdUoubEx7VN69Wf37fO5VSQMg8AjI6YBPpZXojAJzGiWzFhlWRf+7KfL1pVeEF8jD5AgdIeBfjhHp2j70YkqBHu+1dZN3dDCmCa3NiNFIqqLniAWQoOmDddTJCX8qyLpsvHTeAmLATTB+YBmYpTFgpSILs7Nk3qPOjdZxtR0yUiOXZMochuMp+MnxYFBWJCqns/UDfnwMlU/UdY+eko658AsKDNQ2ha4ZrJynAf8Nc4cUS/LMo4vWmabz/dmy8sFg6p5wpT+sk+aV6rH29AiE5ff8yZ0mDmMF75EeneKC9WA+O5fSzEsAjjd5umo1J6EypnD5QVi6GOtCIAS9lohZE8Af1g18fySdrUq01XrY4FZsf/yZpwyWacyuBgjVFcJdC7YDgbvAJzj7EM427YpVWSU69AxY
 GMEmR59B
 HSt6tk3C7QrAOvih5otkOqtrtT0vr12bbEL61TcDD4HECKetUFXrafar811qKS8yWMOrS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memfds are identified by their underlying inode. Implement get_id
for memfd_luo to return the inode pointer. This prevents the same
memfd from being managed twice by LUO if the same inode is pointed
by multiple file objects.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/memfd_luo.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index b8edb9f981d7..6629ab4d8e30 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -529,6 +529,11 @@ static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
 	return shmem_file(file) && !inode->i_nlink;
 }
 
+static unsigned long memfd_luo_get_id(struct file *file)
+{
+	return (unsigned long)file_inode(file);
+}
+
 static const struct liveupdate_file_ops memfd_luo_file_ops = {
 	.freeze = memfd_luo_freeze,
 	.finish = memfd_luo_finish,
@@ -536,6 +541,7 @@ static const struct liveupdate_file_ops memfd_luo_file_ops = {
 	.preserve = memfd_luo_preserve,
 	.unpreserve = memfd_luo_unpreserve,
 	.can_preserve = memfd_luo_can_preserve,
+	.get_id = memfd_luo_get_id,
 	.owner = THIS_MODULE,
 };
 
-- 
2.43.0


