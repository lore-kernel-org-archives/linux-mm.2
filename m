Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16689D47CD6
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:22:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A916B0096; Fri, 16 Jan 2026 06:22:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39E0F6B0098; Fri, 16 Jan 2026 06:22:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0746B0099; Fri, 16 Jan 2026 06:22:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6626B0096
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:22:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF4168C1B0
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:22:31 +0000 (UTC)
X-FDA: 84337588902.07.86A8D8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5C2BF8000B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:22:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KyoeoSDS;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768562550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=n49KhjW2NsQ+2SNxbG1v3wDY3eQ+clYh/VdzFfptK9k=;
	b=Cplt+fpGN6dtNvkYI1TYJOiUGVA66cLrN5Pbkv0KFToyE5YZNBtmTAbWSzO4DALPhtOlbs
	docZsT5xPsfz2jyPCxs2FxZQLVTaovhvmDEZAUZTXbNhQXylTtcDu/lNtUb7pvh+lq9qOV
	LT2lzwcDB9i5+IDRnZ1r9OFJMx1V/yk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KyoeoSDS;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768562550; a=rsa-sha256;
	cv=none;
	b=uQn0txmi+Zb3IOrn9Y8jF0PdUKjxwBDiqVaburnt/ch72n8uNcrY/5rKG55hPNXAX1kEP/
	jd4rpxxl8k4VkpEiheuIRcAoFFiUNXseG/WVQd6iOnXssoMFDCU88OLhLUL4Xu/z0PA2yd
	8ueohowPALwoejrEJHOtkL99nCV2Br8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ADA3C601A9;
	Fri, 16 Jan 2026 11:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C2BC19421;
	Fri, 16 Jan 2026 11:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768562549;
	bh=HI5uvGIlqzXI3+OmJCO8lS9DhG0KNYjy8q9FNzSY5eA=;
	h=From:To:Cc:Subject:Date:From;
	b=KyoeoSDSFo2BaxDmONFMoa04Ar+lKIkzTgYdZIGcIgVdOZFJQ/6Kdwp/IcXNswXAr
	 a6HNyddDo1qqChE/i3VKfZjTVtg4RRwkAVf5HA4QY+ja6W/C/ZIth4k/lTUl7WXq97
	 qSQ+yEca//KoslvyrCm9E/skYJwFDc6ZDcZgWmFETQ5Z1HpJee/7YELArcCCWha0bS
	 nWs8iuA/1KhN925Y/DVhRJv35n/csY0qmXF0Idq3wJb7OH5u6MZHINN3TOWan7oONr
	 4mkTt0+/9wMlLlhbYHOyq4I70XAEt2vWw2etx/DcvZveObtcuqPeOpwE/O7sCnxwMH
	 vb82CMnoDderg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH v2 0/2] kho: clean up page initialization logic
Date: Fri, 16 Jan 2026 11:22:13 +0000
Message-ID: <20260116112217.915803-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bzmntegboese159ngiin6guefhdidq97
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C2BF8000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768562550-866289
X-HE-Meta: U2FsdGVkX1+2V9/8SAdhOeNkWVQI9t3AhIQR/OSeEts6MoaYig1oyJy1OUz/Bimsb41HTXheDrYkO+PKe8B1v6beh53JcPEPhpbqelDOjOlz6gX0CpC+5r+i1iP2a2JETCz8fda2cEnK+XsJqcaRxxRFOzh3HDjnGqwUM/mh9+PNweQHbh5Kkmc4n91NkndUtdOB208jP+zf/Dmht0x4dSxhdy2TuApt/Lgl0sX0QosV+oewafxUGMCLcJ8ntooeO1W/onWc+j4Kweiu18qehxio8uk8x5M2Jc+BbPb/wS8LW2rjg3DlrI5LAaFwb1UAEum86wKSe2WMhxXj9oR763pbOinvheumRh4KtC3NBPhV9L2LxRfnOhU4jE5VONRDxrDWiTOrV6XJdZncEL0FswQ8FfZ9NIJ2pM7ljNdSdxtc54K4/v7/PqQ0Y/06aGB2OtSsRsrq5/P5z1EnWRd0eLE37EPxNCzzl+DsNSvTvOr2rqisGd1Kd9R1+lvn/CO2rhG2KP1DbgVW5JP3N+4vRA1mMPGvdHHnUy5siLD0mwuGNB1IrotOgeukRbBPUpgiclS0IQ4FZzMOBj+vZt4XDHTlqL1DbtjiKre6Po66Wy5AERTo1TPOLu+VbastbiSzkJ5gfS2Ujpp6yB3ytEeMQs6Gst76muZEE7udNQCo0TPOdRtjCY8zdI3UPzsqdAyfhjIjME4TyKwd9g/Ocub9L14rJFcxWhN2zArYy/DgiE2CDjgXyypNrEvkcsurSDZYeazNYrzCSJvO8925lfCXgq2EhZveeD6WDcYnA7NP9gP76qgIMQGMpXRZG1eN2hS80ZO9R/sNzaqJ5o4zeq8uwHruyKGtm7l0dnkXKs1LdGK2Xryuc8y2iRE1jrBYi7P48yk0dqgqXTKv0DBVkuh4gkc9ws6Uikepq7YtiRJiJU5umXs1hKIUy+2U+xadf1bNtauA8+rT0KZNMbQCcYj
 9azjZpLa
 qnaDUnKmupOXPVcqYFZVcS9AOHIba0dV9HAD24gZ1vkXDdqvWqOQ1PBgCaO4lF9LFD/d4l8/59aEQQxn/yeGOPUwewMJNXbQ4EEld1hTFGqLAnkdWL4Mb7W5c8I2KBv4Nqoi01FTixwBZXSmTPCSgQIgL4Qj7R05kLGkpzzLp4mGQQSJX+PuAkPKn9m5XdCxK/Bu1NCvNVF0c+3N5wDPk0WUuZ+hXPBi6km0O0C6LJqn1pMQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series simplifies the page initialization logic in kho_restore_page(). It
was originally only a single patch [0], but on Pasha's suggestion, I added
another patch to use unsigned long for nr_pages.

Technically speaking, the patches aren't related and can be applied
independently, but bundling them together since patch 2 relies on 1 and it is
easier to manage them this way.

Changes in v2:
- Use unsigned long for nr_pages.

[0] https://lore.kernel.org/all/20251223104448.195589-1-pratyush@kernel.org/

Pratyush Yadav (2):
  kho: use unsigned long for nr_pages
  kho: simplify page initialization in kho_restore_page()

 include/linux/kexec_handover.h     |  6 ++--
 kernel/liveupdate/kexec_handover.c | 47 +++++++++++++++++++-----------
 2 files changed, 33 insertions(+), 20 deletions(-)


base-commit: 0f61b1860cc3f52aef9036d7235ed1f017632193
-- 
2.52.0.457.g6b5491de43-goog


