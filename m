Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6995D606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gMIV7vKD
Received: by kanga.kvack.org (Postfix)
	id 77C8A6B00EF; Thu, 29 Oct 2026 02:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705F86B05B4; Thu, 29 Oct 2026 02:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0FE6B05B5; Thu, 29 Oct 2026 02:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3272E6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:24:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B0CF3802D5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:24:45 +0000 (UTC)
X-FDA: 85374675330.17.D69EA5C
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id DB0251C0004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:24:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gMIV7vKD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793255083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3bbEEd0YswyM9gjR9hkxZR+uYtqrPZWlSsQUrKIRuMc=;
	b=OUIUn7dt7Qxg/yo8SUoUxfSMJviZoO3ROg63RPCcglnG/y84tVrIHlGDCBT42TUiJNGt21
	BuqZzYKVZEoN466jf95nOQu97F/MdLdhGtA9B5vI4BeBvbb76on4fvR1vlWnLH83Crikng
	01ZS60i3ZsfUpCGAbQ6XWPvdmWyc1ic=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gMIV7vKD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793255083;
	b=f1OGnFHZ81uf5qyLkW2sLrqwGY3M3dNFHOL4XcJN2XE3/D2bzGGuluUxj5gBpT+jIi3CxT
	VD13XB+F3m62G/1V2jshxjoL3zhDUZeJdGei12MF7gjIkXmPYG/ozHgK4IjrN7lWLNTNZy
	ykTPtpxuBEasunk0oxzmJoynDh+O29I=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-14394530ec6so1994002c88.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793255082; x=1793859882; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3bbEEd0YswyM9gjR9hkxZR+uYtqrPZWlSsQUrKIRuMc=;
        b=gMIV7vKDROMedvbh7vi5ofRoStuvhVINd8dXShfENxFIRsJQrxVWfdDku+hV6Q9xJq
         adJ1dPXinUEu5ngSqdIshRdGYlvicVsVNgzZvWF3TB0zYKAwLKhF9cBWzs4ZDC06lmKx
         /FFj0Gxo1zMh5ow2b/iIZspmNHEsxgq7SKsn5D3RtZ2Pa7LWX8BHgmDG502hMU5uOeYD
         /yb3+sL9O/1oq3UHnwuFw5/e4gy3MCps7cDtoqC4jtdi190V0ODiwUvT/uPg3izoPSsL
         SisDWMXrYewvTzbghTyAp7C8Ti7DimiaOXvfvAUkaAloiMDJtDCHTKFnodXwy9S97Cfn
         A9vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793255082; x=1793859882;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3bbEEd0YswyM9gjR9hkxZR+uYtqrPZWlSsQUrKIRuMc=;
        b=YWSFC3EQi/+tQ75vIFYJtgnbAmBXVgsXJfh6p6UJS7dgKA4yTOPMcBuzULdTPHOGDy
         ApEdVEZBaShbfP17oYcE/VwFXcvcU6hJJd8PwtsGjFFmswgWOKMu/MQf19Iwu5gqE6kK
         wM04jWeES6hpxRcdEEr/uoOPF1qrQ8aINn6wJFq1KRqfDDwtAmBbLfeE4MRPPqt9Lfr9
         wOud6PQhdEv8nFMvWIs5YfffSTsTlqQXr/FouFYYAXwhT+EuXQVueO5Z/0/8P3Dw/L2/
         gMbs/uArzh/6VokV3T9fBDdyoAtwD7mLz0LpZ4al7+TSnDQ5mHN5dbk5RztKRj+wGwxx
         iqDg==
X-Gm-Message-State: AFq9FYI5SXiER1qJuzqynzzmOFnSPHdAhzAdTb5y+4tYTxgjPci7KHT7
	nAnwOPsZqs6WMoOK3/8PkO8Ea5Q46PfFebZUSuA4tkpYS0061betY3Wc
X-Gm-Gg: AYBFou3J14CKZQBvCBNWzXXyvZUdJE0yBRJUgEI7xA2EsXdAMsdL6u04eowYQlHT8qS
	jJo17s9M3IxJUQlREgRknpRgYi4W5NRcK8IF1ewSVf82Xj3cHEfU+xvbsqkamwMiLbqKb3IpTYP
	+lTp9vRpJ7YNpvRda95pk44hwoRe3e1cyC3b7iAMrHyUPv0fsAOdwVuT6PQ9R2S9svFvy3Wnyeg
	AcDWgbujH++M/38v8lOVoQyAkcvOhxGDYtZ5WyyY56yF8FjoRY5TEuzOB+y8TQXxoICi+Ch2i9J
	XrpLl6VWKhtqWBoL68ccaxzYfyAI4wgKCU4+/Duu06YPYsVPICi+SWjrq6GTMAed7y9YKoTAg1K
	NtsqlvAVwqtP2CZIMWhAaool7AiEYfk2D/hJrC+dYgiyCZqVxUxiOfiAmnxKaxHdTsry59/iIia
	TEbA62osZUEJgh2V1+8y6izsA5dK0rnYRK7okhsimhz2hS4Zf/73nIde1ezQB681RYnGovirXls
	hwHEB8Dos/xCdsN9eDLibCviHlKY14GibsNu+G0h4DQoziY5eDfufPukfIP6/BX7D9dxiuY/cTR
	oeo5MI6MV86DHKWnLjN+qfDx
X-Received: by 2002:a05:7022:ed0a:b0:144:eb46:be0 with SMTP id a92af1059eb24-1a6ced912f1mr6332516c88.13.1793255082423;
        Wed, 28 Oct 2026 23:24:42 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1aa2f100684sm2152004c88.3.2026.10.28.23.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:24:42 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH v3 0/2] selftests/mm: run the XFS-backed THP tests when xfs
 is a module
Date: Thu, 29 Oct 2026 02:24:34 -0400
Message-Id: <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-0-16ad772850ee@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKLm4moC/52NsQ6DIBQAf8Uw9zWABmKn/kfTQeCpJCINKLEx/
 nvRLq7teDfcrSRisBjJrVhJwGSj9WOG8lIQ3Tdjh2BNZsIpF4wyAWruIOLQThinCM5BmEdI7ot
 Lm5U3r+AVgkEqamkqXWFNcu8VsLXL8Xo8M/c2Tj68j3Viu/3nkhgwUPnTalljLZt75xo7XLV3Z
 L8kfi7LX8ocKGilSqEoq0rOz+Vt2z6plHFZPAEAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: DB0251C0004
X-Rspam-User: 
X-Stat-Signature: 1e5w4n6x88dmyhoye1sc7jhbtgk7kqfa
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793255083-221786
X-HE-Meta: U2FsdGVkX1/PRgsbNEzV6ELY6mIUOxWSDoG4fmOVShUvAEVlX2Qg/7FVRxYdfqkUJltppS9CqaCiZCE3nD9d44oGuF4oQj8wICRDun72RqOK/Ps9CJ9WmZa0oC9cfmCzsswBonEvz7/8nvc7D9JaadJbu4aT8nbsthqWVcxzksTQM0NfN+5A4H4VZ7iv7CoNgVO52I2n6xaKKwA9K+HqIdgsGtAWD/EJsp9NIhS6WZTw0CPME1aSo/UE6LZNEx+F7kF61/3wQlWvVu5uZLbufWYjzPj38D4BioffSl9P+eHiOOxz+teXH+G4NPgpC2YY2xc0e4DDYsogQbCj7lpNrrghOQzY0w1aS7+scrAe5mxpC1o734qs7Lz3HXIyBAwMePlkmBdoqJNIEtxPP2UrZTfmyiUk3kFe/PcGs3QhJyIEJsv8aJjvAigY/mBkHpTPi9QST/e6knZyNUFMl27kpmj6N9cTJnPZTgf5924SOAPaTaIoFdpJjjrpkJypbwxMD8WW30+stBRZ9nhwD3BT+pECulAmsIOKXTk4m7gPekAUAv+hhLJ6eqB4/HD8PEcdWuFbttiBHtviLMFvUGccfjPrZVRkdp/VgtKU+Ca3ZAbllWd010xiAnmalWa3dMPRKiMhcD25m8Y6auVbXhVdNCT3Vl9VJacnzH6i2/g91fq7DQuaTAppkGUrzSd4vr90xxBt7qcPPKUOJOe5mojJzABdyjdebTN88owIrjjoLggK/s7Hq/mZNit/STSbQiBKxbvwBaaxFxSIFr7wZsWgbScyjMOFriSsQ2WfXzUp3OBO9pIyp0MLh0xdGG8MbV9fyS3Fo23vPpoXrAdCREZ2RjXXL/PxL5br5bS0uAN5XdTHszYPU9AcqX7LzSOIhBXGoDiPVK9RXvtAyjNS8809UdVoWFeju86dsy1oEW8KUIqO/0TWR5yvIX2Y4Xnqi693th0w3srrqDHVgmvA71t
 FvGVLcie
 IsBtGgaDNqfD9F/BHnDYNnaT8M7O6hTG5qDmbNEnWBompHvoBXxtYcUDnLuWp3s8kpQfgonU+XYFtIpaaeiKZN2kI7FZOlxIrgWRI32ox7IBK4CcdoAYKSQiXLoCg6oqT+Lzz1UcWrC5TNqZHsOSmMfbMmxOrHNcZ8fCR6NMjpM1hrKo7fj6oVH2mDH09O2FOi7Ic2lWAPghMd6NGrX1Vb+yuuYutvwg3olLrpj9WzxaTCGz5hpsyclxr6hru0LtWi7YRRfv6dG6NhqYc+UlV47fN65LLPep84/P270z0f1PJm6e8j05oBI6ghZxEpZqTEdfgDatI/GtHFYWJltCLEyBDsd5yiXmbnbyNtIwlxL/3LFRfur6YR4iy+a801tROGmqtaxOjVmqaiArhwDrN09+yTkuoi5/1nTRklGdqk52m380g+VQIaGOEH9v748XLvAi4GzXkgxXInfF9Br5Yberw94B7SAazhgGtmT4fekvXTEvfzt1W306EjHHx0EjpsoS+PaZHiSpIFo0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

run_vmtests.sh only creates the XFS that "khugepaged all:file" and the
pagecache folio split cases of split_huge_page_test need when xfs is
already registered, so with xfs built as a module and not loaded yet
those tests are all skipped.

Patch 1 adds load_module(), which records the modules the script loads
and unloads them again before it exits, and moves hwpoison_inject over
to it. Patch 2 loads xfs through it.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
V2 -> V3:
- Match xfs as a whole word so that selinuxfs and vxfs do not count
  (Jose A. Perez de Azpillaga)
- Rebase onto 6593a15af108 ("selftests/mm: skip khugepaged file tests
  if mkfs.xfs is unavailable")

V1 -> V2:
- Add load_module() and unload what the script loaded on exit (Zi Yan)
- Unload xfs again after the run (Zi Yan)
- Rebase onto mainline

v2: https://lore.kernel.org/r/20261017-bug-selftests-mm-run-vmtests-xfs-modprobe-v2-0-cbb36b014322@gmail.com
v1: https://lore.kernel.org/r/20261016-bug-selftests-mm-run-vmtests-xfs-modprobe-v1-1-b97dfc79e97a@gmail.com

---
Qiliang Yuan (2):
      selftests/mm: track the modules run_vmtests.sh loads
      selftests/mm: load xfs before checking for it in run_vmtests.sh

 tools/testing/selftests/mm/run_vmtests.sh | 33 ++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)
---
base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
change-id: 20261016-bug-selftests-mm-run-vmtests-xfs-modprobe-de0697d4c4e9

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


