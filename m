Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A4BC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E696B00EB; Wed,  2 Sep 2026 11:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEEF26B00ED; Wed,  2 Sep 2026 11:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8CB6B00EE; Wed,  2 Sep 2026 11:24:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EAFF6B00EB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:24:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2662C120265
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:24:23 +0000 (UTC)
X-FDA: 85169193606.28.759CD2B
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf20.hostedemail.com (Postfix) with ESMTP id 34E441C0007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:24:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=P+pU8I64;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Z6ATPzeP;
	spf=pass (imf20.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788362661;
	b=Fo6PNj+1UJI1PgbrQxLi/MNzB1S801csBmgOQUfqjkWxk0135SX7nMo6i04wod7f6vSnX7
	TrGAljo/vXag2P3CnP9d04NvdveVj8Wqg5v5FXOYFY9lnGTBXGno9muqLZRppbdF+3GhH9
	NC1SY5QVjdNBUPvTnwpwoHEE3c8x110=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788362661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wjBje/KFV1Sml0wtdUTK7NRrAEQ7HaA06Bpw7iU4znA=;
	b=mfMF7DANNFhsQdVllFbr8idcBgn5RR2FKAI/HzioIs7ZGhFAmncNCb51l3JajRm7X0QbzL
	mGNn3oEh8Hg6X+0hO401Bwhu2IBs8XhbYY7i0BsdiC0L9hGIuAKUCCKSqe2QbyOblKNMXg
	ybUmCcf3V2hMaSDD/bS35NIylegeHMc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=P+pU8I64;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Z6ATPzeP;
	spf=pass (imf20.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4hZmjb38GpzKmTr;
	Wed, 02 Sep 2026 17:24:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788362659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wjBje/KFV1Sml0wtdUTK7NRrAEQ7HaA06Bpw7iU4znA=;
	b=P+pU8I64/YzT1ptN5r0xo3zWPioDdM92Hy2Ancv10qrrgrj9N5/DYeueNUiDhZIlOPQXVT
	z+dIxVKPNuTjBjjMQ7JRntMlFw2a7QdpkdtgeTiTRwASjoRzrdwwiVbLuRPBjph2nM62dU
	hAxZohGwGI5nxDOPpLjg6DaMefYrHtr2MJs02fY7DIfIdhr9r7z6Sa0pxj7w0b1Sn6JVZb
	AK+w0C47zgI3jvupm3HS72h5XBgUeFd2txVWMix9NCtt/vUyy23h0soaYpDj/jBgysVZZQ
	Wce0be1bxHOb/eRsGw1cbEi6d9MuLCnrKIXzWTv5ik7mJsTKOQBgr2v9+uBCRw==
From: Manuel Ebner <manuelebnerli@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788362658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wjBje/KFV1Sml0wtdUTK7NRrAEQ7HaA06Bpw7iU4znA=;
	b=Z6ATPzePoFX6gva05LDtPw+F3y+fx7FW/OBldTkyofW+vCwA/Y94xh9x9mVITqgjtzn3t5
	GsVj+kOkqJU5H82NX9X3GyqMysi86iRLJBc1VvsewAAXKH4HUAPPg8UbWtaTLzgX4KKbH9
	PHKG4VQ8+uYQMCp5TbkivsASK8b2eEAzU2jd9hfI9q4fYWlVqsRwhXmXsQ/cpVHTBX/LHp
	1iIgiuaRe/mafl9LD6Mg/dG9i7kqDBIFxbEp88g83DiSruRJIJh5aqeLDT82XyVGuZkV1m
	fhtDkaUrXbSLQoVxd8gw/hF1/3LKbokxW/tnDrrRWMmn98ZSv4TJNr8HrMPQcg==
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: admin-guide: Fix bracket
Date: Wed,  2 Sep 2026 17:23:47 +0200
Message-ID: <20260902152347.708070-2-manuelebnerli@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: 5b8ti7wdu137crny6pbb88wff1qcbep7
X-MBO-RS-ID: 2e771efcf8e80c989d1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 34E441C0007
X-Stat-Signature: yuz4oz18ku5nzky635f6s385xke36aku
X-HE-Tag: 1788362661-973573
X-HE-Meta: U2FsdGVkX1+wzcV6ik1Bepqhv+zCRyUL9+amaAR9KI1zHWKK1QrDGPfMKs2PwMMS+ZDj61o4/JQn/iS2jJhSjYKuy/JlwnQh6E1xeySSfSLTA3oYKYryVmPODwToarRczZhf137yqhIe3VsJ1AtOoHORiLP13Fr5adhgk9OCUlRsd4QwpoaDuYUo5OZMaahu4pESEG0aGaoRNAYc0OSHEZaHMPFmLvM5CV8JXTdrnIIHOrLskIkxWbMBhOqalwHI+pLy0aIOw/o1TMgoefWlE5X8v1fx1aetqvM3zAXUFSb+35AlgWPzQFtD7TbD0yiIqkrm5j3XFl5Vm3k2hET3f+Wwy6Ns3sTKdh39rYfWzs8/YUAE6eU3w8VLPoLW48XcToD9TmheYLlpOJCAeRuhtVunvfo9WYVyjB3/zdH76X0fMmVeFGvMMqTUCGZNh/umUQdt54fEe7zTiI2y0K+xBWirsD+8gzfyI9gBabyRZN/7CXwTrNjZ++QlmBhHporMHY2HeEk+AmE822CUR2K3/aJs6zJJ6Kdyjf0ISLOiEG58T4PD7JL2hjMsEt/3H+0etxvl4QLS5cCR5rzkVcrlv3UtgoOihxOsB2+jtTB4pOh14BFZXKlqHDxEJoQdZRzIVMz40+OXw9CH6ba3waFdgzklytmWU1heD76wteXWdfvFCwd/5VE8V81EQEC6pG5mV3H/M/Z1DAWoKWF7cN7MfTnmN0mnjrBtDyZUJTsDPrXfM/whYpYIClFGAYH3y3K9esIkpqqEfdODV7InQAMjihYoxM/3xN0SQswqxG5CZV2czPhMZV/jWBurWmJpAmzTd+X2yBMhuxPTWVwKW1GOSKaK764y5llkZoyoZsIf2dKJCm19QTlEYE34//d1SabZvVvx4uGoAMegA1ElzHt45LmZCkL/6rBZ0ispVzdqk3QOkZcvt3jjHS86YZ5rzEFWkOCKzS8Ul3HHtKGqz1O
 i2F8TEPT
 XzRT9P38klbYECZTeARKbIDYlq81L4H13dwzTC6d3smtfXNbW6g2J7QIP7CDvysls3U+fDj4/+CW0uChc1Dz+g96Hyf2Gi306Xvq0GJWpTwN1OH0okMdAAbTh4Upu77QElF9hvbLkn6vX6X0Per2UQWluOrqwefc1Hj3hl49h2xI5Oq2VWcL2fT3K9izvsNUumXzsaJemYPOxvc1dmHXNLuArfKFSSchGQs2xjHT9a9g0d9HolstqC0JBJ7okdzWTDStLp8nbaXgAD5nqEwaqCiIUDCuD9xyd1tqzsws8yZMKTsxxlYU/98swOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add missing ')'.

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
---
 Documentation/admin-guide/sysctl/vm.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 5b318d17a..ebc281e6d 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -438,7 +438,7 @@ zone[i]'s protection[j] is calculated by following expression::
     = (total sums of managed_pages from zone[i+1] to zone[j] on the node)
       / lowmem_reserve_ratio[i];
   (i = j):
-     (should not be protected. = 0;
+     (should not be protected. = 0;)
   (i > j):
      (not necessary, but looks 0)
 
-- 
2.54.0


