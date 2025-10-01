Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE2D4CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 04:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2566A8E0006; Wed,  1 Oct 2025 00:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E2D8E0002; Wed,  1 Oct 2025 00:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B0F8E0006; Wed,  1 Oct 2025 00:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08C8F8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 00:34:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B9E314087B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:34:57 +0000 (UTC)
X-FDA: 83948280234.26.51B4D0B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id C98E41C0004
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:34:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="a4E1OQP/";
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759293295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Znhdf6Y87JnsG1+sQUMQiEMHcz+cEz6iCwvXxyYyPkI=;
	b=uFvPjSuYYErUS6bKP5R/2youIqmMEhSbwYiYQBPIqAMIiHbgGVWNM3lzBeUziXkfH7yqE+
	+zSkwoqdJdnEe270mG7I5Tr7WekIDZJrWUpJK6ZSDWNo2KWlA4WBHCe2+ASBKDG1sJI1ns
	sJS1DNVxHKpHeFTqoxZqlIpvyPDLdEQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="a4E1OQP/";
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759293295; a=rsa-sha256;
	cv=none;
	b=V1Z1mgKhAVYxLiyY3BraOTn7blQNMXAxDAxtfegkLkcrH8D6F8CZd1+1cmQW6LNCAefqox
	ovCzW1eazUiXoAsz2xhhaFi+qlrgyppSfu7DtNE79omB9cm4StpGvpE4Y85stetLnsdsh8
	fVZsOCtzOvSAn9Z0EHcMKMQzLO3FPvY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759293295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Znhdf6Y87JnsG1+sQUMQiEMHcz+cEz6iCwvXxyYyPkI=;
	b=a4E1OQP/gd82aOQjg2TqNXb9cerfPVJwb8sbRHJFVsSmrWIAVvU/zi6E4/TZrvinnHB3h1
	Tr09WUAVjT/Q7HtUsDOMK/eeKt+pHvk2fxfHFW5YzUeLe66zTPm02qLXrxJwkz2G5kOvAX
	ZJnTTegc7VL0HXY9Ia/sl9OPSmK9Ams=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-270-W3Qi1xFONbq75KzVijjplA-1; Wed,
 01 Oct 2025 00:34:52 -0400
X-MC-Unique: W3Qi1xFONbq75KzVijjplA-1
X-Mimecast-MFC-AGG-ID: W3Qi1xFONbq75KzVijjplA_1759293290
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D9821800350;
	Wed,  1 Oct 2025 04:34:50 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.116.46])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 95BF01800577;
	Wed,  1 Oct 2025 04:34:46 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 1/3] mm/swapfile.c: remove __has_usable_swap()
Date: Wed,  1 Oct 2025 12:34:34 +0800
Message-ID: <20251001043436.41338-2-bhe@redhat.com>
In-Reply-To: <20251001043436.41338-1-bhe@redhat.com>
References: <20251001043436.41338-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V4OedhZf5uotC9rll-HlXU5R0WMvTXb1ztRawqsRvss_1759293290
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cqzmpyqeb5jh5stz78qhoieaii1kq9xi
X-Rspam-User: 
X-Rspamd-Queue-Id: C98E41C0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1759293295-416403
X-HE-Meta: U2FsdGVkX18y2RXh6nvn5or9z+nCEoIZ26BEDmx+Ia7xLv4Nrhb+0Ik/IhrNOGbUn80N4GmQcPiD7Y8qMdaNPLDonF7miO54SndvJ+s7x1tUrv4mwDYAiSDZBZRF8chVfQ/2V7P8XNwgs+OjeNkadCOsl8u6wnZ1niv1x9xNROWpfNnKvI+33oNVojJfT5PgjKihyZJM6EvZ6fkz4usvTbSo/m7kxh/3h+HQvDU+jX41RFxiB2gVqJ2Za29rR3TM0IgllekUGDb3xQpSjSZ7FBaOgFn+WkBFQiwAavaUpwNVwcA8klrnBw5d/8OV9FpmoUnhbsr8vuqvDv0s7zRl/w4ncfJUHI7MsPGp4oRzUIHvJKOtnqH3/tMXauEuCXM6AoDituRCScJU/u6Z+fZUHTXHhIo6+4muLEyU3ta415ZKl8Sgw5lHVXq4t8aO1Ok2B3FvxWp926vIaBaaUcm5fHUr8pnRtXf+KSFy07wJANefatrQm5Ps1hjv0ZOK9lra3/GaDmPyleO5567Bjkpf6NdoYg+27fxJbUjL1lx/2gSsRxygyclkROy4+hgzOnl0M4s1OwyTwwxfqEroFcKW8gT+uMgWexMCGLjC2UA1R1FDpX6G3CaicAQDucM6+DVRhz005L6VqaCO2qRs2pu4dIncQ6ynWXnAGlskJnWUb5lWSoRD3S743okm4Sr1SuP/chqSGYnRaZC6+Xxz/D9J1DnOt/x/G6zsPE6WOOflQeDcCfBshXaJOXU4IQjozfkMLClJb8Ui0MVa/ht/Gx5kTVruGm3esgr8eCJJdUPLiMcujfgpaxZSVrdeKWXJBC3ZuZO7HrKQ/Vc6+B1WGCoWsaTNFXxJhaBhq7zeuBAEOifVY+P1JMs7utWJ+hBuGW6BPm80CR5r6zQqjLvUS8kdecSYLN3Xi540PWIdRtQAd+zMh69GsnjjKEkHc0x67h6gXrGURPI3WiornRGVvPa
 C0Pwz9x7
 Fc/ujrLURT7Y2fVNeB9C/wDEA/RqsCJwE/elPQumNeHiz8tGk/0rk9x3vKJzDox49zlXUuPYZyoThgXDvcg9Gvh7w7BR120D4nZqXM8gs8MIHGjU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Global total_swap_pages can indicate if usable swap deivice is present,
use it instead of __has_usable_swap().

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 mm/swapfile.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2bd8bd76ea28..5d71c748a2fe 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3836,11 +3836,6 @@ static void free_swap_count_continuations(struct swap_info_struct *si)
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-static bool __has_usable_swap(void)
-{
-	return !plist_head_empty(&swap_active_head);
-}
-
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
 	struct swap_info_struct *si, *next;
@@ -3848,7 +3843,7 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 	if (!(gfp & __GFP_IO))
 		return;
 
-	if (!__has_usable_swap())
+	if (!total_swap_pages)
 		return;
 
 	if (!blk_cgroup_congested())
-- 
2.41.0


