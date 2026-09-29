Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85923CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C016B00A9; Tue, 29 Sep 2026 04:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3936B00AA; Tue, 29 Sep 2026 04:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730A66B00AB; Tue, 29 Sep 2026 04:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BDDB6B00A9
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:20:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9EB92C03FB
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:20:06 +0000 (UTC)
X-FDA: 85266102012.14.0FE55D1
Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id A5F7580002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:20:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fUywBQfm;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790670004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1j8wYUeavAheQqH3i69B3Vx14raVrATCv/xxEOsfdY=;
	b=UfjlirwtjcXNd6thRghQF0cig0L8Szu1g/cAuCOeKRhO54tcovuuDsKrEQbyoEBVfNUrQ+
	oTJfXCjtTFNYQZA/FI91FAFzaKKEHeIqdwquYEuklWT2sL4LrCJaGOJlTSwxdJgfdxs5E7
	7XhBPpH0yUXgw07MGaso2Bbo68RqAUM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790670004;
	b=pIU/CIv8X70ZgCUPVaT2zQny5AgLzvp5tpH+cq56JnXeEmnGLvVry+Nb782wugT0sg0Jw/
	y9se7yOVrsHsvwPjzquYVBBlPWIwQst2z9KBtPV0/vTuGaqum2nn3fEJjLSJ6R5PTQVR23
	LlZtvcaTl605OnFoXBWIJoTxiTMhcew=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fUywBQfm;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mEWPvX1FdDCMegEZd4lktZpkSzG9+EQuZUeCnBEnrM8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790670003; v=1; x=1791274803;
 b=fUywBQfmVrIpnyOcm5zCU9r/hPSXUL6ztvivVbohT+mRDCS39o56y3hUSieZJcbyW2Hbgf9+
 kSRfKgp19gzcrttVynEBgB2kxzHW7pjP3fC6OX1JxIh4/cBrKb0GfPlY5nwg9uoHowoCPTZC0tA
 v+7bgBLuW+fIbyaGjk0dRlRo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 343c75fff31967c5;
	Tue, 29 Sep 2026 08:20:02 +0000
X-Mizu-Trace-ID: 343c75fff31967c5
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	=Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v11 3/7] alloc_tag: clean up the populate failure path
Date: Tue, 29 Sep 2026 16:20:10 +0800
Message-Id: <20260929082014.160587-4-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260929082014.160587-1-hao.ge@linux.dev>
References: <20260929082014.160587-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A5F7580002
X-Stat-Signature: f6cdxh93q9cpqxiii7ugi8s5tej4xp6b
X-Rspam-User: 
X-HE-Tag: 1790670004-860812
X-HE-Meta: U2FsdGVkX19m9BZHPJy+z4be18gpypUwGVRrF6bDnjIwnXu6HJeRy+HI7xkhJUJxTEljw75htZhc4biHuNYSVfR1D3gvacMwfKlouRmY24zaV27uqL44L9Kju6Xg1i4RRj0hQoXOGAD92Rf2UDGFnqvgg1loO1FBwotIGrAOIJDXP8F/WjAmVR5nPq3l4XYtrr84vTsSfSkrFP+u72URnV0XABDbap2kxbJ/5yOT2t/26c01b1QRPC7rSwgB8B9Y5soKEgc5QaHVCfWvdx8gMYMmclFDHwU6+m/BcQOKWV718OAYtz8oh+5+d1UlQSgomPGigz3dpqlArdVwArSytsBGl6hMakpVcX+mBvhuUUtFVNxA7ZGLj0U2AXL8gtLM19WJX9oUPRN3Zy7sTWL9IElr8zitiFNCRwBbexJE4eYQi/BaZt/JxQfWOviZ+1VxtBwqlJzLiZUjeMIJN5wtn73rWVCU2CIcKylwIe0r8UWiBj4cywXw5/CIQnhab7glYWMAWURUXv+BxVrd7POhfUr8NNDmAep9/Y6zSkoVuZuMpkpSJzh3xdJWsH2C+mtxE01Wh3rQ7RZuPxX6s7iDusJfnS07yq7c4ahFxYc4BZVMUYP97egRJsBXNIdiWB3cWpM/WUGfKrbjQT4Iu8avgivEf/UbSJqevJ+LlQ2DDcq8VLVf0SN4xUMzRMZVjGTGn2kZumMK93ghTgtLgkpU1p/KHZdwdjpGUDIBhfXkPsjt6dILqFQGF3qjYAhH/GpE8zotZVCdVo/MIcCL/UjpTArCdSoifSqCZgSDmc+aFz2bJF+ZH7KkDssNqVuB+Co9SsoegofX8Ex++6ZhlSFJcCiIXpmP5Vawcj2vSoB2CH+QGSQCKxhWPk5+/2M1bDHx2yX9pNw2M7qMZOd4V+qfHYLe3+/MXlnbMA+AR7O33/WcgA4ZigIc8U1yQtT2f6vafu9r6zravGfL+zbMt3n
 JmvhUIEP
 BnODb4Jm8gyBhyemeEQcmlHbYt7DjhZnIlsMEZnuHhlnXT1PB/wPEeug6ObwVgbvtQawv7/WMs+6oTI7BkDUgLd6Y9Fju12sd+at6kNvlQnuIFFxbKRqQHUo4qgKSZUDadUzgnhCojVLSxMx54fInRKfu1kGZUG/i0IqMlXyFiqwUgyVV+GyGvlKHT7usxGdsRKuV0ORIP2tr+HDgbjMp8QOR7iL6fkdxmUzsrAX7pgFmzNgez9dpUaRQL7F5oDoodJh/+wTcnkvHD9rM49/W+RMlTLmG7wp6XoFs9lyccUHxutY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The reservation is already stored in the maple tree when
vm_module_tags_populate() fails. A failed load never unloads the
module, so nothing releases the entry. Release it and roll
module_tags.size back. Without the rollback a concurrent load that
already passed needs_section_mem() can reuse the freed gap, skip
vm_module_tags_populate() and write to unmapped memory.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/alloc_tag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 2070e682fe10..3e6306ee0764 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -947,6 +947,7 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 		return ret;
 
 	if (module_tags.size < offset + size) {
+		unsigned long prev_size = module_tags.size;
 		int grow_res;
 
 		module_tags.size = offset + size;
@@ -961,6 +962,8 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 			shutdown_mem_profiling(true);
 			pr_err("Failed to allocate memory for allocation tags in the module %s. Memory allocation profiling is disabled!\n",
 			       mod->name);
+			release_module_tags(mod, false);
+			module_tags.size = prev_size;
 			return ERR_PTR(grow_res);
 		}
 	}
-- 
2.25.1


