Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55548CCFA18
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF05B8E0008; Thu,  6 Nov 2025 16:29:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1128E0002; Thu,  6 Nov 2025 16:29:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE40F8E0008; Thu,  6 Nov 2025 16:29:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A0B988E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:29:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68C6C4AAC7
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:25 +0000 (UTC)
X-FDA: 84081473490.29.BF629D6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id A91171C0009
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R4M+wk+j;
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762464563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=skkktfIpg+zUdGSPDhLSirEh2xW0AQxE26iLGr0oL6Q=;
	b=ealrHMgivLHRx6FmIf3c7cuhHFf/jcsMQxgm3BWqMyhyC5lpGMrD9rwB5Da5EizxkaXXJ+
	3LHUym7hIud37XPzZInkFQuiLjxv3MPnRo8z8oj+M8EkKMyZG/iYNTi5aCjr7z+M7w73Cy
	Wf9syJltYH1AdyHeLXMLVLEtNF7uuvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762464563; a=rsa-sha256;
	cv=none;
	b=Mq6gb9DdFsQaI2tSaiUTShWztLCx0u3kv8OVHjl65RjyuhQU8a8d4bsPDXEUBYU3C2KkTY
	HUHciUAI+KO1eIWUxyZRS/afxItFt+B0Ju0CJsNOZRycoC0342fQKfoIhCNfFLVJufXf00
	IETjoDmV5A9hRolgi1jfFOsa1naXdJA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R4M+wk+j;
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762464563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=skkktfIpg+zUdGSPDhLSirEh2xW0AQxE26iLGr0oL6Q=;
	b=R4M+wk+jveCYtqigMzlYqfc4ONU7sm/tHImNnAnYnEWiNTcuJ7q5K5I9Hq1UmcjleLg5Uw
	NaMzORSspopyI1kkc3hSO3AmYds6kubN7FRO+RcNOwyXn0swPiNrqQgtUBKywNoAJLRjL9
	25WdkseI8eIog5FL6P535QswSlV+0wE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-T0ZVoLT1MG67aUGFddE1ww-1; Thu,
 06 Nov 2025 16:29:20 -0500
X-MC-Unique: T0ZVoLT1MG67aUGFddE1ww-1
X-Mimecast-MFC-AGG-ID: T0ZVoLT1MG67aUGFddE1ww_1762464559
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25A911800371;
	Thu,  6 Nov 2025 21:29:19 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.101])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0096C19560BA;
	Thu,  6 Nov 2025 21:29:17 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [RFC 03/10] drivers: dax: use pgtable_has_pmd_leaves()
Date: Thu,  6 Nov 2025 16:28:50 -0500
Message-ID: <1456ba4c025e9ea01abcadb8c3714c7ef84e0198.1762464515.git.luizcap@redhat.com>
In-Reply-To: <cover.1762464515.git.luizcap@redhat.com>
References: <cover.1762464515.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A91171C0009
X-Stat-Signature: 1mrgmesis4ijb849jkpwdiwkfbm3worj
X-Rspam-User: 
X-HE-Tag: 1762464563-832158
X-HE-Meta: U2FsdGVkX1/HJnsgAbkf04shtiyisUSRCaiTrhzrUjYLtFUYUAXfbM6O6VpCHJMlLlXZ95y2fey7xJApF2GLwOwGvJ9GjVv4h51JCHTjJZkT5SNkQl5725ngiJZdaNOr3YI5D3eYVkodLrucs6hikUB9DBszvoNUQY52ONqUfBcxeOuQvVyFMQaa3q+6Uz6e9nqjh8ZkbuNnKNlghat63DioRAINsu+PfKphnV/ekf+9YSDt+QI0aNy4pf4WE422k6cyYpiEbJC1la/V1nkcFNvBT5M3GnH/tOrYkhNl5EuP5gDGGg5rkMnKHMjmrN9a0S6CkWFvoetJBFOHTHE+1cAjh4Xtb/PRTpKMQiFBmS6cyclbygdr67MqeTfwXtqQkmN26HbTzTlDNNMrCuSTCObX4IakWkgBu4Pl+z2M3p7Jka/NJVjH7RxNkOoN4hZeFlHdiyGoFMAwzDD73eWFLZjk1muavjZ58ktl2xP6dc1sOPioDSNW7JjdyI3siTYPVjXcONTzXGdaTPWnWNgeLisbkpQccx9BeCeYp63ywcLHsGCkeSruhs34q/KBT8CUSlv0fDfIFQj/tyZQM2NFx+YlbjHds4bsSj4Q8DAe1zeIP0s0CU7MGjSe5CkOYR7qgZ3xCsSN9CyPkI1+9R32KNAwBIFU4iWVaGefuIdkMbTm/Ddza0MR9BzYs4/T4OJ6D3hLpOu91J7N6DWsGNRkG2ISC/wQ/GG2h53Fy6otbnAmBVr8816TvNRU29kfaAlQSfJgKX3eCD6FP0neoi274y4jhxmHx8isJTMjhEbhEHtnCnvmWQkgILNWTmpRM/1cKCV2PwlQu2l6RLJXJA5dw8H6jtSe5Se3I5qcMKGxsydqwygH8WGkkLHMMmXW189QZY0xxfaUYEYMB7GnPdOwpir6UrwXJm73KAg0KrAgF+Wf0CfFOtiBG/w6XNL+Q/LQ5/L/mbxabpHIT6K3EBh
 uCR111nA
 3rhrYs9LfQUdJ8J+Oiw7XjwTKYEqhnRGh7yZkPyKb628vkslEFWE6OPwhH9ZTKY7FDI8IipC6uGwkrs91Xith55EKng/d/+85eOwW0srq6Gd/spKl94uIhMUrmq3pXF2kPCAjhRXY+cU6asV2v/j5oRPzgfvOIQ7QFo1JtdQk0LxUKY+fNkLkLPjWXVDWvHWz3JVcvVe16rhEhjuWFRWAtKKAdjbK58FRHnR6nsRlNma9L1S7QoTPHP4NrDdbtAd3MfO2e7MnoZeNG/zBT8FXKWdWBvs3SjpP/+6TIZENicIMnOJTAUBFVIVPratF4G+30xaKbpf9AtrDNCZCq4uIwHsWl0TWD58P2YDRFWWBkl8JO2RCG9RBvZLG3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dav_align_valid() uses has_transparent_hugepage() to check if PMD-sized
pages are supported, use pgtable_has_pmd_leaves() instead.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 drivers/dax/dax-private.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 0867115aeef2..10aeaec9e789 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -117,7 +117,7 @@ static inline bool dax_align_valid(unsigned long align)
 {
 	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
 		return true;
-	if (align == PMD_SIZE && has_transparent_hugepage())
+	if (align == PMD_SIZE && pgtable_has_pmd_leaves())
 		return true;
 	if (align == PAGE_SIZE)
 		return true;
-- 
2.51.1


