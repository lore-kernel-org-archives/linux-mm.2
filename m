Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91C83C54F52
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F606B009B; Tue, 28 Jul 2026 08:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617336B009D; Tue, 28 Jul 2026 08:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52CAA6B009E; Tue, 28 Jul 2026 08:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB706B009B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:11:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83A83A14A8
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:45 +0000 (UTC)
X-FDA: 85038071370.18.7E2C89E
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf21.hostedemail.com (Postfix) with ESMTP id CE54E1C000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:11:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tfGF4i1r;
	spf=pass (imf21.hostedemail.com: domain of 3fZxoagkKCLIlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3fZxoagkKCLIlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVnIMBasyGsCgYKzJa454oI7ZPXv6Y6JMFDgs68eV4E=;
	b=fftSRn0QcvUuTNB2NiveVCtVhR7ib3L/QXmzTnIKnyCg2hJRM/wcQmp8xQUzRCemxvT9po
	7b8bZx8Y0WRtEx1BfoJcD8GRGLekRjKf3O39EuNkklDkXGsq1ciHZvBdKplDDXcnfjKz9S
	3ttyv/MU59Y4V0bdJCpxCnw1pvTJPjo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tfGF4i1r;
	spf=pass (imf21.hostedemail.com: domain of 3fZxoagkKCLIlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3fZxoagkKCLIlSjmfkSZmYggYdW.Ugedafmp-eecnSUc.gjY@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240703;
	b=fqapslgI3htL5UXWm7JIcaEuqNWujZrPExP/5wu178GGPu/fXo9H+2ZAt2b3bjiVeJjs6V
	i/YsxuwfupAqLOFLDm9Nbd99cqfFUHbg/Na7l8QQgnPWK3SbrX7R2WjmpWgab6SFyKXJj/
	OvfA3SPDNaLy/BJSYZ6KdIiQXfzEdTE=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6986557937eso3121870a12.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785240702; x=1785845502; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gVnIMBasyGsCgYKzJa454oI7ZPXv6Y6JMFDgs68eV4E=;
        b=tfGF4i1r6CRsROLcG6iNwtY+dDUTbe957WfwecvGxt0yvohPENuHQaC+siYtsS+ctV
         DZBChgVAH6pUIhG4W9VbatC7N7FRlngQ3SbmRAD3Zfg08sRX0ATz87P3ZBffh+6TFMM+
         0l2EIEbX0QZXCsIW1C/luSc1m7TZ+Y66Fln1HXieVT2UnWq7/qekfT/Zg1yQhaPBsXh7
         8Puf/+Rz3BoltMX1/jKFUUVEO7f5NPkS0gbCs1jqeSi/emw0oKA3+NFCSy6JCqCnTdMj
         L4+sW+oHRI/tSd3HzOF6I7ACH617IX1NydqBcvthKVijnKPDzXqfIC1MeMYPfRI2yyHq
         maRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785240702; x=1785845502;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gVnIMBasyGsCgYKzJa454oI7ZPXv6Y6JMFDgs68eV4E=;
        b=F42UrrbiccUhcCUSVJCgw2tcCnaIjw608SkwFChMt+FV99UTr9rMAqlQpMruTCF+u5
         osuBs3v9BX17IR1L1wlLM1q6WgDg3LoXdojoJNdY895GpMUzSZ4RUq/1Wm08hPyQ/utV
         UJnrGFjlugHm6ubORrK6vOiFJuqcpOdxnYRbfokecdUz1RxAsoOkeAP2UKIbsHbEoa8F
         Ga7xo8BtQPap3FnMf1VCM+wbUNiutSam/429sJok5f4Hn3NmVXRan7wvMFjhnpwEx+FW
         K4D2QuG25n0PWwzfGWs8rFtam2+XoxOvzRSq8r/IGGl4slwjvL6RDg8rTsiId2ldybmw
         dYNg==
X-Forwarded-Encrypted: i=1; AHgh+RojJpJnnN4ZHr+4dU5xxGyye7LdxzoIMrkyhVwEFCD1Hnt8ju+N6NU25A1R9mN0IgGSWnl4OzrPyg==@kvack.org
X-Gm-Message-State: AOJu0Yyv7DfYHsK22WhyBq433fOw79iskThHUxDDJh7to7IRP0dw9yyz
	iyITQuDaj6UO17R/xR1E8lWwYzug7OQ0ZYS2Bb8N0JWFsFde/6dLzRmyIbmXjppDdf1A6pvlSDA
	svvJqTnrQs9EyuT8W4A==
X-Received: from edfy21.prod.google.com ([2002:a05:6402:a3d5:b0:698:3510:43a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2b93:b0:69f:d5a9:c957 with SMTP id 4fb4d7f45d1cf-6a034a765a3mr1074401a12.35.1785240701982;
 Tue, 28 Jul 2026 05:11:41 -0700 (PDT)
Date: Tue, 28 Jul 2026 12:11:28 +0000
In-Reply-To: <20260728121138.1103610-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728121138.1103610-2-tarunsahu@google.com>
Subject: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
From: Tarun Sahu <tarunsahu@google.com>
To: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: CE54E1C000C
X-Rspamd-Server: rspam01
X-Stat-Signature: 5tsscan7b6dgneqfnmwie8bwrpwrhs87
X-HE-Tag: 1785240703-572457
X-HE-Meta: U2FsdGVkX18+eoVGDn+eIMdvufean2alFQ91Vj/bkylxg9BAUbToyY9/Ltam66ZdVTK7Fcc89wKJG/kFmDIp2Cj/urZQpjqC6rjwDTnpslmqM3DUHnjGew3qvrzo+w6JWkC+d5agAxc3HdiBJiIkFLuAjWJL5z4I2T0vjzmjaJI4ZpD5F6We32sVGCv7Bfv/aoKfFiZU4ZPoiPeVVcd3MInei0EQESijdoZjgGMEcPhiYqUHP6ANW4V+RCUvS4HonfaVyBkSaoR5ROKspiWidt36fhQozluLrQXQqSDdxLGHUdiZHTrRhfFSZCairsLoI5DXw82DYxD6jY4QUMY/fnTC61jA7PSpBhiXLb2F0D50mvySYt/9jXPrAw+nZ8iGJynULNFzSB60iCj/znA7KbxSqihI8Qz1AkozzGfP3Boy68iAAadmqLhRoQGb9A4h4wizA6iVroWPjiBwKHLwX2QTXLBtzjUpxRl+//if1qUDBMrLpBihmzDqq6KeLfuEzy3ngE/ODjqUNos7VMFmwnRiUon9RjTatJyPZ5Kbsi5uKXHJER9lcM+jlUy/DOdogFuiSVo7eHge5PD1Rp/WipQoNwTfF2hu/AFcXTjCKVkR3jQJs1oExhSQ8zGGRaY47L49nqIC7JrPr3Eyk0Ac8J+FJXSk0oqn0kyavFyDvc3L1zdgajzBDPcUQZ5+07SkUQk6//ch5RtpmM4NDzBCjduR2uHaDBgjKCwy8ZruwtZ/7dv5NKoi0EOtrklacERRNdgz+y11vcW8IDyW9t/zXjshahN8Pq2zJqZfvBMqY/z3gnYFt3JQQMhO4gG+sXmwd9soCzRMuA8TVzH10lg/eNv5ZutvYkXojqHhb/WXkzI9Tvj7xL/Obnkq+F3LX3NyJaJMZRojhGoiWXFsj7LdrWE8whqRKzlyurHtVasYO5XXXwmRYeJs/hhvFo1rZq9leb2lqpPFfOSo5hbMp69
 9T56Jxbi
 9dOirqmVb48r6dBCQRBkY5NiAqtCDHIScood1XxmnvaQiIVfl1sjDx26sOls4Iem1GZ1GsdfQtUaL5oA9jxDi7TbKf5by23ixBnvggpb8+Q2M1J1tbu383eAMYsA3JIqSyvoYyx4/l7nDbESyvb11Y/vxPlEacTU289JEZ9kEIliIE4aE9vqlsQWqjOEw6KgPNdoXxZq4+kpDxyRbQPkAzukoTFj4d5Ez+pSSlWMQfIjQW2F2/8m3n2+abhq5ICSshzI0i4ib3m+ATmJl7RaNON61ixeEK73DGyRGWwvU4fCb4eAcNCdGY78U4WEEX7T2q6XLVTlffWfy2DANNk8k1qUq8tn/CjI2YkdOgy5oNNUmnEGIzCrLPvStLEiUbLueYtY7bwtuF4D47X2gC1ywwkMHDC/YW7yU/UPgu58Hxsl9cyCwj3b6ecEDmtNiv4nNE1cjXnXVXkZemE9i+gmS5hzKOhyy8sndJrr3+IBKrxBEl5+r2v/i4D/UHjuUGBOP12boLKRxfNflI9q04H08SMOcd0pvFccmv0fnsyU3VDQyP2OFo1M8Ronj6N6yx4siHTI4AXTapArmg1zCeqTOUMBZP0fk68DYnSAywjz73Mvkt4M6MEGacglxk3XwYDrOG2tWA+26Qa1ZWrrn2/m49kt/tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the LIVEUPDATE_GUEST_MEMFD Kconfig option. This option
enables live update support for KVM guest_memfd files, enabling
guest_memfd-backed memory preservation across kernel upgrades.

Currently this support only guest_memfd files that are full-shared
(INIT_SHARED and no support for private_mem).

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 kernel/liveupdate/Kconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index c13af38ba23a..2490f9a9b838 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -86,4 +86,19 @@ config LIVEUPDATE_MEMFD
 
 	  If unsure, say N.
 
+config LIVEUPDATE_GUEST_MEMFD
+	bool "Live update support for guest_memfd"
+	depends on LIVEUPDATE
+	depends on KVM_GUEST_MEMFD
+	default LIVEUPDATE
+	help
+	  Enable live update support for KVM guest_memfd files. This allows
+	  preserving VM Memory backed by guest_memfd file across kernel live
+	  updates.
+
+	  This can only be used for the guest_memfd that are fully-shared
+	  and pre-faulted.
+
+	  If unsure, say N.
+
 endmenu
-- 
2.55.0.229.g6434b31f56-goog


