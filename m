Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E06FCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 902BC6B008C; Tue, 23 Jun 2026 06:52:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D116B0092; Tue, 23 Jun 2026 06:52:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE0B6B0093; Tue, 23 Jun 2026 06:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 366166B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43AE61C5467
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:52:09 +0000 (UTC)
X-FDA: 84910862778.26.9636568
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6BAE98000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:52:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VRKfXNWW;
	spf=pass (imf02.hostedemail.com: domain of 3VWU6agkKCGITARUNSAHUGOOGLE.COMLINUX-MMKVACK.ORG@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3VWU6agkKCGITARUNSAHUGOOGLE.COMLINUX-MMKVACK.ORG@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782211927;
	b=HxG1olgBkaWhc4rQcLWk/HIPSSIfG2XFU4ouZAYVxPWDYrO59Pva09rwTZ+X1rd0frK1Ia
	yVJcPiJCP65PJKHeOKBu7cgqKh/eauKnpgLrNhgpW9iez2j0ipzaE2FTINoltQHetub3ZM
	cJ76W3EyyssiG+GeaMwip+/Njeiij84=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782211927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AwBhzOQmDvof4o67YNkTf38WRniNdVc8sUDs+ORB3x0=;
	b=GVpV6T+JqD2SVfUHrlYnb919DqQeSheiu3DbAfnM1KKTZapaxLu29+l+PeXeKBGFBoPE+5
	lOXBrtuvK5p2EEuMvPloapjrV1U79UCv3uXY+M/LxGbiCMfrDXi4X0oPm0kmXOMGdCikCk
	bNALf5RL9qhbKUNeDT85BhvTzhM13vE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VRKfXNWW;
	spf=pass (imf02.hostedemail.com: domain of 3VWU6agkKCGITARUNSAHUGOOGLE.COMLINUX-MMKVACK.ORG@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3VWU6agkKCGITARUNSAHUGOOGLE.COMLINUX-MMKVACK.ORG@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-695b677095eso5627878a12.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782211926; x=1782816726; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AwBhzOQmDvof4o67YNkTf38WRniNdVc8sUDs+ORB3x0=;
        b=VRKfXNWWstu5tbqyrnY5ylJGOyAr8mqRGYrwLTsU3y+JxpBMuxTrz1xY7PlNB6FA2Y
         eHeexP0bVmCI1Zm25oaDJ9kX0xwiPTtrEkNRe3TgUDo4GPulltAOcVyUjehmXZAMe178
         i5RbLmaaMMEv/1eThlIZ1zA83Bx+E8pirJfAhFaGKSpb5PMfMb2HZ+0M4gFMDbGNCWdb
         5N54MQ59C0b6Zmo9SRMKlbZ8Wn4CmKD360EbEXc+Hx0ijApBMeK4k4+V2/SpWxSqDBeU
         CSa+UkgMT4SE11hK5U3bdqZPeus1omRqOICyeJK/IuY+i7MtB6MDG9t9S1fGdFynLGB6
         VGtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782211926; x=1782816726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AwBhzOQmDvof4o67YNkTf38WRniNdVc8sUDs+ORB3x0=;
        b=OU2XOFVbh9551HyVJHYGJ3rptMCxWCwoeFOuDjjkvP95Ci/Hg9TRCGsmXUBCwdloz3
         04+PToADeM6SnNR5fcJyET1mPPFSDQSwSgGTn0Hlwr/8WobYRxWsqoaRfkKKHdgHza2j
         yYdmRDCI+FkkoUqEPqn5oVniBEKP17KuqsgsLDtdZhyJI6kRtvYLz6ABH23qLoGZYLgV
         TctgV6p4Yj73ogTbD10fDN2EshlOagWiTJxuSJ9kCp7XeSQmRFRbVWH5tldoO2hAmxTV
         35t4sz+Z7Uo+toCd+q/H7VIKbcw6WnBoA4D29NK1C8mkMACJyLnisE3b4EphmtHPjd1w
         4auw==
X-Forwarded-Encrypted: i=1; AFNElJ+LdvWVdwEXvOn0tUUCwSDeoi8ocRtUcvlg6pA2zgJqKoPI+5anx8kNi4BnfAoXTOsP4+ak2rkvFw==@kvack.org
X-Gm-Message-State: AOJu0YxSaa/TmfEbQI63/Gj13iaCD++f9XXpcYJgsZvkcAJVHPG8ALhl
	40hmcyjhXtVWnTauD1E8GB5iyRk5hUi5fYrLU0E5Xl/CT49Ipy5byq9R6JfljR9CeVJgoNCpsO0
	S/olA49/sV7GrwwFHMw==
X-Received: from edds5.prod.google.com ([2002:a05:6402:5205:b0:697:9ff1:9f21])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4598:b0:697:b75d:fa86 with SMTP id 4fb4d7f45d1cf-697dbac90a4mr1031248a12.19.1782211925395;
 Tue, 23 Jun 2026 03:52:05 -0700 (PDT)
Date: Tue, 23 Jun 2026 10:52:00 +0000
In-Reply-To: <20260623105201.3724592-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260623105201.3724592-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260623105201.3724592-3-tarunsahu@google.com>
Subject: [PATCH v5 2/3] kho: add KHOSER_COPY_PTR to allow phys copy of
 serialized ptr
From: Tarun Sahu <tarunsahu@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Graf <graf@amazon.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6BAE98000A
X-Stat-Signature: d8cx8bgxz3d9w1ezmxuw77hoytfazrcq
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782211927-917335
X-HE-Meta: U2FsdGVkX1/zQMy7AfWd46C71/C5J93Gj3vy5xlwNunqrgrJvtxxq+eLOtvAX1UCAZTJHuX9tISha8A4muppLTae7IQNEVSsv/E09CrLrbI/e5APGBnSEAQSrauteba+ufCFKYAm4q2S4q6DLbH9VDkihG+xlCmH99XSH3XlXvt3F4suf5knN2SaFLHMvRIsTpTcljKtezDqwIFegDzesr1tLP7PwnRJ8ndiRo9O5zlpNmvqB1eCVuu0Gu0Sz98FtmtWbMSsSqPotpfpgflbbeJ4Dwe1cF/jTd/+vNkEq5AIkk9BJYFRsPCRlZiTmwWapXPbGUt8ru5r29pe6Eynl2DZ9a4THoB+Znashm7VN28v0DOtVYx4MeWVxEsogIecJ/Xh7zo7W358C7lQQF/8/CQOVoo6Xo2u0LsX0FG+W1bEnzBAk0vZZr65QdekL3oiNG+ugBIvto2bgeXIbMGVClCFF+evEc+VA+VTw0N6timicBY4FQG6de+CKLy2vezSNX3RLxi7Pf+q5Sm4MUbFxPs9XYjVSYy3Q7UPCzEqFZ7D+LO80aVbnjSSLgiGYqdNP8j+uHXHg+D+xOuC1mXTDwvZ42OTcOgSZYEKSufqo4QObVKm9Lh6dTYIpfKZrHqmdkcr7pFlFDkTOqJJZLmy4v5jI6xM+YHSxYXBQGDPYQaf8SE0SsxkOlLVxJ1BdH4P63vro05HdILNaGYwu+KWBar0mXIXQ8fqFTAKnjbGOex83Z89eBo9ZjmT/n5lJbqpQlYa81+FHtrzAiFnulK1bf+Q55LbbW2Kf7vcU96WE11xQfLAXJLDje6tJcX5HiDevb/0AllgL62SIf5shBJ2YT2f+xyVyQIXGqQvBeUlXu5j7AuSd0f31myfASShmHRsdsopYgRdoLkGG7h2fnKTwAqVBEyPZUUQjLUylyTQM+zoJBtwKEFZdDFPgdnHWHWWMv1ggxPgl6PlyVCUtxy
 xXa1VmeZ
 9wZAQKaKHthfAEpcSPKkPOchSbP9QSBqCFJzR3wHoigLvwwNPP3KE+ONutvw0swjNFemsbPxnzVAiPviGP7UlN1evSmq/AXS6XCYKGVoe96rnkOWOW8PzvGJhBfvRxe5zDgRCXNDY1MxJRLtmCmm+XrdF5NkJEqba7+nZti6FC4UOmmZ/fXixHyR0nxz61S3GwpuXlAy2F6z+3fgtMMfBMgOkytQgu4S5uubYedfIcbAcxCQotaJdcsbF6w+xZWLNGMoLpy2XusIw0CYY7b3kyHHNr/5ipAOCyyRqqRaG8eYJZySaT5UeBmywxiHEajh4hIJbc3aQwu5IC54P9uTPizjV9S28e2cw2u0ndNbAQ8C9ZTqDdvzGRrARf08vIYnS1c6VShbihCWiqlWP6qSswJNXAoAXFlXf6kQZoSkZM7PfPKP4yfGIDwzzjn0UjW8ncNlpJgZgwviFLJyflLzm4/ez7SvX9SCr8E4fV0+JVGA5KQ5CJNZGP+BqOZMJhRhmrS2Uiz3Nk+PpPSUMXVIAuqpe8svJyyQfrs27U3zd6WMbLer8ntdbtfsaNk1B7npbc5OE7ScZf3oQ869t11j0TEg55tYgeteTOiwQHwDL6o4I1F0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding KHOSER_COPY_PTR to copy one serializeable pointer to
another. It basically allows copy of phys val of the
serializeable pointer.

It ignores the typecheck if any of the argument is of void *

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/kexec_handover.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 5e2eb8519bda..c1b61d875dcc 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -139,6 +139,17 @@
 		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
 	})
 
+/* Copies one serializable pointer to another. */
+#define KHOSER_COPY_PTR(dest, src) \
+	({ \
+		static_assert( \
+			__builtin_types_compatible_p(typeof((dest).ptr), typeof((src).ptr)) || \
+			__builtin_types_compatible_p(typeof((dest).ptr), void *) || \
+			__builtin_types_compatible_p(typeof((src).ptr), void *), \
+			"pointer type mismatch in KHOSER_COPY_PTR" \
+		); \
+		(dest).phys = (src).phys; \
+	})
 /*
  * This header is embedded at the beginning of each `kho_vmalloc_chunk`
  * and contains a pointer to the next chunk in the linked list,
-- 
2.55.0.rc0.786.g65d90a0328-goog


