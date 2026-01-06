Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA20BC47BE1
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 23:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA706B008A; Tue,  6 Jan 2026 18:48:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2176B0092; Tue,  6 Jan 2026 18:48:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA956B0093; Tue,  6 Jan 2026 18:48:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA7156B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:48:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4408513C56A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 23:48:48 +0000 (UTC)
X-FDA: 84303181536.18.B800CD2
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6ECFD80009
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 23:48:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=laveeshbansal.com header.s=zoho header.b=D6ArQYd6;
	dmarc=none;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf30.hostedemail.com: domain of laveeshb@laveeshbansal.com designates 136.143.188.15 as permitted sender) smtp.mailfrom=laveeshb@laveeshbansal.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767743326; a=rsa-sha256;
	cv=pass;
	b=gkJmWAgmHrMp+KP9C6q2uvdck691raeF8wUBVcba595yWBjNVjROKTC9E7uR9w4NUbqrkz
	0D8E21lU5H0IGEpUsOAiMXl1MC7fnV3UZZdrUknmsIdh88Prgf8FCS/G7NTvjvvTzr0fE6
	jex8j0A3j101HJfFztNa5xsxl2oTsEQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=laveeshbansal.com header.s=zoho header.b=D6ArQYd6;
	dmarc=none;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf30.hostedemail.com: domain of laveeshb@laveeshbansal.com designates 136.143.188.15 as permitted sender) smtp.mailfrom=laveeshb@laveeshbansal.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767743326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Lmr7mdc/8YeCB4SkZf2G+cx0l2ku/Gk1x04euv5l+rs=;
	b=n0NoDLraI+jFHXTCZU37nMInNu6a0tehHGmVQ1dvCcu8vcyvPmVlDMLoQmq0qpLv/WyufF
	gCg3S6kKK1Z2HNtCdMH7q7xani96vp2pygGgylwwnz1NrvNG2y9xBbF++dCzynp77L0zw7
	gLYNKwC1iyFJNldjTOnBS2BRGKNOH0w=
ARC-Seal: i=1; a=rsa-sha256; t=1767743321; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=DtVyfBHd7TcH8Csk7OT+Du7jve/48YB+Gx3G8j4wjnuNNIMR4MqS30fi988yp0yHMkf1hdsuk8VfMn/f4O6zKkoE7v+nfXevapl4+W+Ed/T3UfceVT/u4FW9Bm6sdb+xGn/6cInjeTwQuOLH9Szcg4iDREo9RYgAhSuuHjEbtQs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1767743321; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Lmr7mdc/8YeCB4SkZf2G+cx0l2ku/Gk1x04euv5l+rs=; 
	b=N0totdKahc1xjj9abvprcOUj3YKB51ir1fLL3X39Hav2dCVBM94KY++p/AziiFmTR02OCM7vA+6hQF6rPGfCd/RGkJA6wTD1TNldICATT5Zl9TostWszatfPkxnpzwxGluF3WE2iycua4BMeW9dfc6ESxh1eCEtIE0jEloViESQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1767743321;
	s=zoho; d=laveeshbansal.com; i=laveeshb@laveeshbansal.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Lmr7mdc/8YeCB4SkZf2G+cx0l2ku/Gk1x04euv5l+rs=;
	b=D6ArQYd6l6WxxBGr/d9yiONMbaTOFClQx4k+oDbTp/tNgRbzM0FRudohyPXYYzAl
	Dix8gFmBbXzSzinkm7ygka2joGJwXx9jncc7LRgrpo6nTxd3m/lYijp/WqqSFy394qT
	5/mZoQZb5q6BMU4GkCES0xgy76L2/rzCSiMeuhTw=
Received: by mx.zohomail.com with SMTPS id 1767743320289358.0160297415563;
	Tue, 6 Jan 2026 15:48:40 -0800 (PST)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: dakr@kernel.org
Cc: linux-mm@kvack.org
Subject: vrealloc() shrink TODO
Date: Tue,  6 Jan 2026 23:48:39 +0000
Message-ID: <20260106234839.586018-1-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 6ECFD80009
X-Stat-Signature: fcbyr5z4dnqp9mt985o6yrkmb8gu6o9q
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767743326-590373
X-HE-Meta: U2FsdGVkX18SXADbDhZz69nuMZH+foa+SQ6TXyqNjbn1OzqfJCUkbTyiHCKYjy7dsY84a//4jKXJ/T5S8wIBe49/vAnoq4vU7XGVjdgzuvlruIEjLV7Gh/XRKf872ksX2LbEIcF4EgjlWxi1ZMf46EBzpSx+kf2bXnKks+202fcDuRUh85zTxVBgbk3PGq9BkR5fn3x4dsm01hje59xPJryLC16Vgw2+8BOCxuIxJnUP3SK4vmsO2JEkrsg+Y+u5GoTcaoQy3flySaqAmSYmnd25Modo+UbXZu7hptNY5K4QxyE2mlbsStZ2RNU9+bMPfooGSDH8dB2anrR6fYEu5Estk4wc5yqGzE7gvxuNKfbg+v3JHTYMYgp1kzq/nUqVfUVMwo0WcFRyqW+Em+/EMI3mv9x153b7vYdlH9MMio4DUNpg+CG+yd5xShamGVT021pV/Envs2qD/FCl9vxXan1Rgqdbk6E3jbpyobsmXot5tWBKnMeNDIE2P07B5e5o/sEbPQrFqRaE4bGgOpl4nZH+7a9ZdHnz59Eo/BOPEv/uvS7Ml9LoLFM4C0n1fyP291/p63zWkZWNsk+Nt2/c3SZmQ0rL7Zj0PINvo4eorhziou7gosg7qgA+jnjLKdzhwzORC9JUPUT4g6qWB5EqpB+rJgU5LGIytwNnqWum5f2jd8YJxW0MC6yY6OB4dKpdfMJEE1dJU4hO11csjJmyb7oTfBDK/pv2FJjzahCsAQWRaceON4xt2Vr4eerDrTrEWxxv9eaGt9nXB6lyCiwYN2qK9nBo2WwPCGtC4rCoPt2XSo1zY/zkrpNKVXPl5CChmEKz7keG6vIm5y4FAhv+nVJbE2Rl+cfLHfypDhhy5m4pJGhHv2P5YyBOXriDlBN31goh1K+h5IpC5Sn+V/uR7WcB3fHD9CfHT1Qa9fcucWSFjqRjNkZ4/yvn5Vor9hQBdoc8nCz/trW/lDT0Yao
 Rcu3v8wn
 SNSicXeX8d9L/A+xnROkR8mfUOrLo6IEiP9MiWFGjvUhPZmmEHRZWfWv3yI7fIS5jxpqleMD44p2izCktIuyZDZlN4+Swm9V6aKYR/75o2rGLM+zT2p1yk6iie1ZEWKqL9/ziTJOmTNDufg9StFsM0mGWy+PGQyQsI4i8P2Xqv25hp+zdf3/4ucIk+utmyQ0gV1EFID+P+01k6zTryDgkxoLY7QUVRnTjMaqsIkTnXzw38U2OvCLfdfYR9UOHErtWQP6wbTB4FnRJcJfalX02peOxlh/huJ6KjLrp274W0I8712Xnws19KHvBYCThVxPD4MgJ41+7uM7FtfE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Danilo,

I came across the TODO you left in vrealloc_node_align_noprof() (mm/vmalloc.c:4317) about shrinking the vm_area when reallocating to a smaller size. I'd like to work on this if it's still relevant.

I wanted to check if this approach makes sense: keep the virtual address range unchanged, unmap pages from the end using vunmap_range(), free them, and update nr_pages and memcg accounting. This would avoid vmap_area allocator complexity while still reclaiming physical memory.

One thing I'm not sure about: for huge page allocations (page_order > 0), partial unmapping seems problematic - should shrink just be skipped in that case?

A few questions:
1. Is this optimization still wanted?
2. Does the approach above make sense, or is there a better way?
3. Any preference on the shrink heuristic?
4. Anything else I should watch out for?

Thanks,
Laveesh

