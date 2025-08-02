Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B462C87FD2
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 12:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2725F6B007B; Sat,  2 Aug 2025 08:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C636B0089; Sat,  2 Aug 2025 08:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B756B008A; Sat,  2 Aug 2025 08:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F03256B007B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 08:58:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FB721403A2
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 12:58:28 +0000 (UTC)
X-FDA: 83731821096.17.F2C54B2
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id A9647A0002
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 12:58:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fX1JWFpS;
	spf=pass (imf25.hostedemail.com: domain of kimth0312@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kimth0312@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754139506; a=rsa-sha256;
	cv=none;
	b=jX75/9qcHx1YeA1YvDs9pXfA9Wg6m7ZMoCWLPRh0w2S+ooO7lRN7eMQqYjF3v1m/2bRBQ+
	KPMm3Y7bh63+de+2zLZMAcG7aayML/uV9e0iLtrvhexWlfvRMWbx5HZoNxmOdZNN92iofP
	tSBDWGvInsqYcC8jOHzKWmHUzlAf3Co=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fX1JWFpS;
	spf=pass (imf25.hostedemail.com: domain of kimth0312@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kimth0312@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754139506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JeF05721YVJ5pBBmgxwBbsjT0X7NTUhpkjiEAnY+Z00=;
	b=g/Vni7com1dwH5REaOlV0ps+pTC3vUM647D+EGpAd4aU/+3eLVqW3pvA8Oer1BWGcMGMQk
	UldDRnXB3m3kTE2Nnu+cOVejlj0wyMbfS8PLsyJXRvn/XbkACC79fTku5wGqn3oI8q2FTs
	szte9q0D8at9a45qYj4epDRXz03f+KM=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2403df11a2aso18213195ad.0
        for <linux-mm@kvack.org>; Sat, 02 Aug 2025 05:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754139505; x=1754744305; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JeF05721YVJ5pBBmgxwBbsjT0X7NTUhpkjiEAnY+Z00=;
        b=fX1JWFpSV3Hry53+p+1CSWLAyA3jDF9vLBWknAmO/+8TL6yALqf2dowWLZPdWOSfVE
         D4jZdsWlwmBDB2i+VJo1v235Kj5ac5zMBYGYTNdO/WFh0+gVreBSB90InsmzukbYqxEJ
         ERHX5YnfhGjKPRhEBWVlVIS/wzXyN+cSl5Ruz/U9dPayOB0VntkntJzRIS6/XV1yEMaC
         uZyd26W3DvJJJz0YLpAp1KRj+rT61ZZnqaPNry7uF2DMhWAmyU6cZD2YAo3R9mCTZioK
         oNqCqJe1nzrFVCNllCoSQERsDQmzKQ95wJ/ISEblAOeIei58X4cQfVtqB4N/FdV0G5UY
         dd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754139505; x=1754744305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JeF05721YVJ5pBBmgxwBbsjT0X7NTUhpkjiEAnY+Z00=;
        b=aeDbueNrDAmziGRu2ueo13SadQE/wLY42aVPbGgpMclUqoY+YCeM+tv+WOJk8F+VrO
         KDpVhctTT+lRlCl24O6eLv0Eg2vrne1qimDra8lIfNBNmKpFmqsxiO4M6FDQSIuCnAqe
         z4jSkHoczsiSV2T2Tfs9qAs/J4rvT1fkoBTQXvbrBNzapNJIKb1fBtOrJTIl/i5fpz9h
         NOfossPvcseUWkigGkEPESumHF+TgC2UpoB1LTWXt3sXWiDQVlxDnRM04SOs8ENcoHvM
         VWyGEy8PKs4Prq+lDqWoX2OpgyEX1f8XM1q/A/mvvaOM4yAfgIoXaX7MAaN4oZWnRSLR
         oUAg==
X-Forwarded-Encrypted: i=1; AJvYcCV7hTQVvXgfOleMnpjDvWAZuxGefQQRlbktOmMSGpxlvFR6P5oDy4YpRbf60by9I8fQB/fHlyh5Pw==@kvack.org
X-Gm-Message-State: AOJu0Yz3G3f4MdyuR/1aCdCWaeBR/k1lDDmUld0QF4luKBkrtiWo1RL3
	7LR48w16/lZ3yfHkmYgPOoOLtRUYgSVWhya7PX8e5py7mdEd5DVtaMkA
X-Gm-Gg: ASbGnctz2mbND1a3W6Zg+xeJzR5GLch1ag6BymAFXgp1pM49TP9XJzTlJm35Xirlp2v
	aGiqYmwdALbxVsS1STzzhKEFFv1Uq8At6qIqB0VUXUjdijLBp7ZZiElXRdn56bXneRbeAWZdDYd
	lm2cYTvX4ClOvm//Q57rKxoH0Y+7mZ9PGWfzhxPP9CSALhpMQ65RR3RFendEDppHQBbk4oWMpLO
	pZMPlppWrqPGC1SODLarDfKlc86UhQwPH3VJWhR+GPYQdzbRurVGciDXofnSilqLnTJbogrUoV5
	CRa4IfrNr2taAgfjhYS9WesAUAd/TJsFdcLjzCLyxcyGRj77ZrFfRwEAjo5GdOSmDKo2a77i/2G
	9nZz+N4KHmeG76VmkGNf8DmoKUo0XlhtLsuIa/ktMHG1lgzN5rA==
X-Google-Smtp-Source: AGHT+IGui/tjwdKbWTwckNP2ApRA1WN/cOeq/iRXpzfKqpbgHt6m+WPc0tkdQsIm8M16mN6hmnfWcA==
X-Received: by 2002:a17:902:dac3:b0:240:6ae4:3695 with SMTP id d9443c01a7336-24246f461e1mr44675175ad.4.1754139505405;
        Sat, 02 Aug 2025 05:58:25 -0700 (PDT)
Received: from localhost.localdomain ([220.88.57.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e89a077csm66788345ad.138.2025.08.02.05.58.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 02 Aug 2025 05:58:24 -0700 (PDT)
From: Kim Tae Hyun <kimth0312@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	corbet@lwn.net
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kim Tae Hyun <kimth0312@gmail.com>
Subject: [PATCH] [PATCH] docs: update physical memory documentation by adding N_GENERIC_INITIATOR to enum node_states
Date: Sat,  2 Aug 2025 21:58:01 +0900
Message-ID: <20250802125801.10068-1-kimth0312@gmail.com>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A9647A0002
X-Stat-Signature: rorudknnj5d4txbfef3bqbkgkdpcbos5
X-HE-Tag: 1754139506-759211
X-HE-Meta: U2FsdGVkX189d/UqgqNam7V8cy532vmhIBS3Z7wCnE5n81CwXW6SyOAptTgkZ766/9gWj+z4URxyLgFIc6NUv/5/2A7YyPt7H6H0d9RIr7T2ff8dp6kfHg3T7YXbJRmQgH0ehjCvEbvAqo9mGoAlykDppJNe25wMqMRgdoEAksvCWkkhve3C4DyDM7aotOpfHgUigblLwAa4ghmq3+eKFd3YF6Vr7JSMaLcwWgO4v7vch5671AvES4wHDmqwqAb4JQRPoQb/b2my1uQWssJxwZOh9k//e64C4dtv1AaSpenWKGuXSOjwPE3zVocdyZi6KcKRyoUgNhzUH924eC9NzqZXQ/Ysi0aCOkaTz1jxCAg8QVzc6apcdp6JLqimBPJFPfldhtA9VOEan+bfGhroshdVo+EDOcMZ4R92EJm0Fqq8CsM6V8E6yXMglarOTV7bjtpKE7aXcIXISw0eLfFco5U70+ATvsDoN4992JwXDlLhvPB8SIctOSNx6KeQrlskCMQ1M0CJo4wD5tBWoghMu65enLwyMFZZbFf69U3Xlha3qbIiMk3PZcPLskp9r8wSWMF5V7yymcPeoNarW86/XrMVR6f+FEt72BTocFeLtiUPCxcvvJo9cdFLJs+LSP0sfnKW6H6Djp6jf3FNx+05f8jzVmbGq2GreapCgDjnUuj/fXp9WrvRVCobRz/LOE/HuqiUNu9xqjqf8XGc78s+9W+aMHyy10IQ85JmKRtu49/+oe4bYw7+6Bqc380JWWdF9bu8jga+EpdjyBODZyVCQfqwLH7m9432RcghnopqjzJ22espp1zawXlGp+Q9W3CGGlj4ana0c77JwgC6yxJ656MhHnKIgTGmB2BhydvGRm1mH8CpQ7MqdEEBsjRzogBsJzhdNF0fH7CeXmsDeyENFvwGefxw2Bxs0CLouP1jTcnkKRtyHZ6rL8Je8RuTCDySPj/VBMeF/WAjx/9Aix2
 6X3P3p3y
 ZV/7zuX+XRe55VXYcDIWsPvyTKQ71DrXI4lqk5wWvdwKrx0vfOShX5qWvr996sOCaKRvThcuNIxZQ/j1DJihiic++B2/ckjs7PLJ2ujCMlDSFcyM3qbHRr/lsSHJftgiJ5X6XTdBGk824W9N/HwziVxrGMwBlItFxiHSXB++lHhcdLewg0ENh4rjuUZdoH868pOLCeoBNfvqpUen2miJWsSBabUP+dTsXD8YhGEWEfJTUCvoSc9Zkpx1l2mPZq/IhOl37JzsRr0jKZ+TFCmKdEGhIrerqxCAI6AQMBG5ZanZwX8zA9U2YKmerNYY7PK6zz/GocNZR6Egpm/8R3zk1efN8K/hShgHZvSJyKGcQpBSeCSkaBqJyqwgVK9DN7ljHTCAyLLeFDF3PSDA1RvmI3BKi86CN1d77bjDnwZ7WfqheoG5ZFokxCVi6TUD6vut0uVleGEP3ty0OlKI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While reading physical_memory.rst, I noticed that N_GENERIC_INITIATOR has not been update
from the node_states list, even though it's already added in commit 894c26a1c274b8eafbb4b1dad67e70e51a106061.

Signed-off-by: Kim Tae Hyun <kimth0312@gmail.com>
---
 Documentation/mm/physical_memory.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index 9af11b5bd145..b76183545e5b 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -171,6 +171,8 @@ nodes with particular properties as defined by ``enum node_states``:
   The node has memory(regular, high, movable)
 ``N_CPU``
   The node has one or more CPUs
+``N_GENERIC_INITIATOR``
+  The node has one or more Generic Initiators
 
 For each node that has a property described above, the bit corresponding to the
 node ID in the ``node_states[<property>]`` bitmask is set.
-- 
2.49.0


