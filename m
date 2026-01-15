Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1758D46634
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 23:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF946B00A9; Thu, 15 Jan 2026 18:00:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B77F6B00AB; Thu, 15 Jan 2026 18:00:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F254D6B00AC; Thu, 15 Jan 2026 18:00:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E109E6B00A9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:00:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E5C6B9C82
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:00:53 +0000 (UTC)
X-FDA: 84335719986.08.95780E4
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id C4C6240003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:00:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gLuOF37P;
	spf=pass (imf04.hostedemail.com: domain of 3onFpaQgKCH0kbtponjvhpphmf.dpnmjovy-nnlwbdl.psh@flex--jasonmiu.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3onFpaQgKCH0kbtponjvhpphmf.dpnmjovy-nnlwbdl.psh@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768518051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dgz1DtuTuOXgXInLnCBHEUta7LHhfgJVWxb17yQm2vY=;
	b=3+W5uqrkhEBOE0L7IToNPdh3WkOqggodN/M1cgtohyWbdSxxn14C4LlVbUAjJzDLB5YQSO
	NmEdxrKco8G3uEuuLoRqSo4vDM9voRwST8xdpBHC3uy3JP5scwew2Ku1A+4krAY66Y/Tgc
	Jr+Jd4eoveEg1wAVZ8Gbr+AYjTnjvcw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gLuOF37P;
	spf=pass (imf04.hostedemail.com: domain of 3onFpaQgKCH0kbtponjvhpphmf.dpnmjovy-nnlwbdl.psh@flex--jasonmiu.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3onFpaQgKCH0kbtponjvhpphmf.dpnmjovy-nnlwbdl.psh@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768518051; a=rsa-sha256;
	cv=none;
	b=trgnggFAS5A8Xlc6kPNF1ikuEckcXVNVee+KU1aMpsQ8y6S8qqMB4SZH2/8RFGJMjJHjnA
	kb1hjnQ1zLmCiXlxmmSK5PEmqXZIjIwEFhNtLW1tAMzxyiCZyvojlDlUNZYWBSSYzjrN6g
	7jl68ZpZN6hSlrupMBzAZKGUcgJDk+I=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-11f4617e256so8592641c88.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768518050; x=1769122850; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dgz1DtuTuOXgXInLnCBHEUta7LHhfgJVWxb17yQm2vY=;
        b=gLuOF37PkC07cANu6sIhVb6yW3t8X2nerqN76Z9EAGcT+vs/Pjz7fqGkec+t13nfz4
         59d6hd05cd2j6wUbVfSjG8diycCDbMH3+hvNyAUeh7ka+3XNkeINo9oaN4Ke4HfI00o4
         INJ72zBtdxSadE/n7WErZvULEpi4Zc/opTEE5wo3VnKZN86jEhfrIMBpmGQ8t0Bq9tcj
         PEFpH1DMC2Lj4WPJ+vTgajxLyOyTxPb/qs7MIrYUeDUSgxNh2Yd8tEhtClUUPaOBRuXK
         pU/yej0K+/7o10AzmkiOKZUBzlWde/JsaOxWm/o2DuKO7YBNsjtrpr081rgj1GbZZVtU
         A7FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768518050; x=1769122850;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dgz1DtuTuOXgXInLnCBHEUta7LHhfgJVWxb17yQm2vY=;
        b=r3eDXdv4AGo1FnyjFNeKVKNnoOxK7ArWhl/6+aX0yRplXvuxxJX+ipeJdBykQ+h/Uq
         u+H7Ytu9bebxPZ0GGBqmffa+ty4QVI5mX4GegtF0wWVOlBwODNGg9ZG6GyFwtqLuddr4
         mFUZdh50JPfDF966DkcBmMRHYr9P2+UxBXDQBgLN8iPwQ8dsQpg7D1P9XMwKYc+MCHzn
         qpe/AVy+1vAuN1FWkp8tX2cnQnYxWkSWCsbDLVv69aHMbpkDTiQRU9pJnuHM1EaiTq/U
         ewYcFaXoJ36nPESlUsQd7rgX9F9d1sSQmt3t9ScuB5ve3goCO1II0IyEWPhT6j1jwk+z
         ycMw==
X-Forwarded-Encrypted: i=1; AJvYcCV7MhJ99JRVNgChtzrq6GDymFUzRCxOCF85REgKhPcbM5J/VTqWjVuLyrkeTxkKcPYIBpqbEqp3jQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+AbVQlAqwuqJzzPRrbtgB1cxQlvxeCfTrzMLcBCmviGuJu3EI
	p7Osbmg0d0CvYY6fRwTiC7vWcnZl8acbzcNYNLWj/uG/PqfmGtAkpXCadin86Ef7Bqfzs0ZwYSR
	lGrWrMOLXYQDK6w==
X-Received: from dlbdt13.prod.google.com ([2002:a05:7022:258d:b0:121:7b2a:193d])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2397:b0:11b:9386:a3c5 with SMTP id a92af1059eb24-1244b395f25mr900028c88.48.1768518050280;
 Thu, 15 Jan 2026 15:00:50 -0800 (PST)
Date: Thu, 15 Jan 2026 15:00:45 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115230047.1220580-1-jasonmiu@google.com>
Subject: [PATCH v6 0/2] Make KHO Stateless
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 91osm5mztfyyej1w49btrzgg8w8wpg7t
X-Rspam-User: 
X-Rspamd-Queue-Id: C4C6240003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768518051-603049
X-HE-Meta: U2FsdGVkX1/g2d7ERyG8McSUNcBCuCyebjQIoMLLGv3ov+WdCCob5sesjim2Em703Xodw6knKD2O22xH/HSHnh5UCbpmytzkKysCW3kji9XBWNVXugSWxDuNfmc/cOOYohJa8RTIup+IEQJ5kT8YxnCya5fxzeA3l+eSF/XBfBBiC2LzFy7PY+dMH978sa4ADnuGEa1ZH8vu+IbtlQKGSCwW5vsl2RED+PE1Is99T7n5rFoXmxBwG+2ORx2MvekpoC/8RS39ELN3C/y5UvkFBb5LmYrY+vSXfV/uRtpQnwJ7V2nc9z5osTBIPw9k0EmH/2QS5JstRctuXgXZBGU/dQMrRi08pnO4INnjskI3j6S0caJKeUr0pSX15bIGn+RHI6+PpULU7hwbmrEV9SXJ0nrvmY4HHk4JHo1Lq4ssnKGDVwYNqlO80hYd2Ca+lCZd7OVvIFdoXxIAY4TY5a5jk29YYcFSkNRA9EhpHfIApaZIo+Fg8abSgzbrDKNvcVoXtpz4iGQ0fcoRIlS3N679aBedknzE+llMMFa7XjMqDl42+F5iLQs4OzHP3sTZZ4nZZ6VaU0nv8Q+/RAh9BSXHkpduaAu8ij1iWEQVl2o7BRNHLBHQVX/SvKEJ9turrH/ljj4S5oKngPYAG4sDskWVE01U/symabHJnK45c+RnW8xHxOqA7CLAQnSKctqBE6pCVCag1DKdXwzLH6MV/Hy6j9bshBgvJjGQhFMQLRW9sYUZKL7d9DbzXJ7X0FXu1Gx9v0MO1L+0waiyp2bAoqiQuw5HXfWjNGFY15kvp6UpobnxL1bMLbpeCGS+8PsgB3txN4jKsZ7a62mSUORI6ffmdaO5Ey6plzp5ToTMmn51Rq8ZK7gvts71V7mypO+i2eh0x/HQIu+ac5f0hu5DD3+tgDxE1Bmffs0NFGTSnMh50HqOqhUGHmwabAAOMtYrctf46bdEPDJ8EHX+uua1VQR
 YQfXLKgS
 M9oJn2QHir84Ya2lwNlhOZMwIeatlUZEPqikcQZXZl8Nv8wopimu+/yiA5l90HjtbWR35W4oM4PooXKInGg1Fm8i2UGabHEgcKBdiFnsSzidN8QvZDFkyHsp+N2ngyF24rFU4k7vs3q3ydocjotlb8pEriTjnYxrR3TiYsCfxb2JnDRs55OrFG75rbFMkJknIwEL5G6rejidRDtgI9oT9taspNi7C8x6OPkgF9gS8fV9cYUSzlzQf/lW0Yy2vE+kH9s+IGiyVPBuEGA4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series transitions KHO from an xarray-based metadata tracking system
with serialization to a radix tree data structure that can be passed
directly to the next kernel.

The key motivations for this change are to:
- Eliminate the need for data serialization before kexec.
- Remove the KHO finalize state.
- Pass preservation metadata more directly to the next kernel via the FDT.

The new approach uses a radix tree to mark preserved pages. A page's
physical address and its order are encoded into a single value. The tree
is composed of multiple levels of page-sized tables, with leaf nodes
being bitmaps where each set bit represents a preserved page. The
physical address of the radix tree's root is passed in the FDT, allowing
the next kernel to reconstruct the preserved memory map.

This series is broken down into the following patches:

1.  kho: Adopt radix tree for preserved memory tracking:    
    Replaces the xarray-based tracker with the new radix tree
    implementation and increments the ABI version.

2.  kho: Remove finalize state and clients:
    Removes the now-obsolete kho_finalize() function and its usage
    from client code and debugfs.

---

Changelog since v5 [1]:
- Cleaned up header inclusions
- Rebased to the latest linux-next

[1] https://lore.kernel.org/lkml/20260113053524.84186-1-jasonmiu@google.com/

---

Jason Miu (2):
  kho: Adopt radix tree for preserved memory tracking
  kho: Remove finalize state and clients

 Documentation/admin-guide/mm/kho.rst        |  53 +-
 Documentation/core-api/kho/abi.rst          |   6 +
 Documentation/core-api/kho/index.rst        |  18 +-
 include/linux/kho/abi/kexec_handover.h      | 144 ++++-
 include/linux/kho_radix_tree.h              |  70 ++
 kernel/liveupdate/kexec_handover.c          | 682 ++++++++++----------
 kernel/liveupdate/kexec_handover_debugfs.c  |  23 -
 kernel/liveupdate/kexec_handover_internal.h |   3 -
 kernel/liveupdate/luo_core.c                |  12 +-
 kernel/liveupdate/luo_flb.c                 |   2 +-
 tools/testing/selftests/kho/init.c          |  20 -
 11 files changed, 560 insertions(+), 473 deletions(-)
 create mode 100644 include/linux/kho_radix_tree.h


base-commit: 9b7977f9e39b7768c70c2aa497f04e7569fd3e00
-- 
2.52.0.457.g6b5491de43-goog


