Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F12DD0EE04
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3C76B0010; Tue, 25 Nov 2025 11:30:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5184B6B0011; Tue, 25 Nov 2025 11:30:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3911C6B0012; Tue, 25 Nov 2025 11:30:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E33B6B0010
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:30:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF98812BB1
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:30:36 +0000 (UTC)
X-FDA: 84149667672.26.37CBA66
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9FA5A4001B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:30:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764088235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M/SDpXrlmB1blQxURg26m9LeZqZCb4wULSE82lCuGBc=;
	b=TQ0E38JiqK92ecV+prjRmWSiQMqgH7gY/BOYgEeGPTEnJh5XeGPVb9THlpXpUQ5ErPj7U2
	7IsvpNiSKzanevQCVOZzzaX++JIm6ujcnWLpc90FvgQ896kz6Jv2HQCElXRGVRmwsyJCFa
	ibcjDyE6jLNFx2S90yW+QgtwFpV8Z7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764088235; a=rsa-sha256;
	cv=none;
	b=m0LesppScFf3Nzhx2AhGnMxXIWtkxPa9lRrVeYAAeanih8Z1E7UCzPufDuaojZeS9Qvftq
	8ec0/IfIdjCdvrRjVethSipqmfgxzhIeE73nbYv9D9NjHqsbOTGQqwudPy8ruuWFT39cNk
	pv21399l5Y4XLrUACPvv0PWSAJkW9jo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 26 Nov 2025 01:30:31 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate
Date: Wed, 26 Nov 2025 01:30:27 +0900
Message-Id: <20251125163027.4165450-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251125163027.4165450-1-youngjun.park@lge.com>
References: <20251125163027.4165450-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jss7grc1suduo98jeaxszcy5j365up9f
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9FA5A4001B
X-HE-Tag: 1764088233-910150
X-HE-Meta: U2FsdGVkX1+au7M80NprUTkt7WC7HhahqKi2/t08uVjwQOjC8PkuYeFkpTU8NoO0PM/2eIYVoB0u7mPLPVw6gzzb6l/wU4gq1mDYDOezr2BVQa9KtICaTdmpF28t9e2UvjlruvMPumlhA2Fz/GVvy1ek4zsfRMjQ9BrJiM/tTFn5TwkQBbamXyXC/HLsNmxoUndz+RTBMEsPce0ZukCrBFnw6D6LrMWmZo0kVI1FAzmwYS19uFnb8U4BBq1db9ZpSlgq43DJsIPqsBRfmpYjqqKPiZfr7Iun/ZugY0VbhUULPw2r/n/yqrx3pXNctPKpzq95xrpv/D/UMki0aMvfcl8bZl/HgwyNxQNixN4066NcIFMFA6zsk98PkTaAjRLMWRmhQXRsw1kToujJ40DdmCcV4uJkZdbVX6BmfZNNRVQueFWdpY9EAZrsx+CtJytZDxXFFACLF+C4U4xACZ/edrMlTnh+QTNpvkwbP85rLX0dQ49Jee2GqTZVVsmE+0gZp1/a3mL+cGplQrHrNPwL035Lmz9d3ubrxedsHXgfxtt6bve61B2xZLCuLdxi7m7k+dXPesFYZDaa9sCDAz6/KonK01uD7onU4F9FruGgPHeeisOLg8gAjjqRly8NhpmG8u6JuNFdelQnj36JRI1pxkv4C2ZBYHfs6Gcf+u6eqlu60tzR0ziT+PRiYRWRbxA1spLc8keF897/Hc9Ne0tttK64pQPo9OVUWtBSb1i57sq4Qr26XYfOspZwGA+d9mLccxcL6I25Oq/m01uLfeqVUzKf9O3Cxn1ZTsFPZs/SsnEWleNL2iUcLUSHrY2ZFkITtVKvQ2CCF3ddqHgRMrwLGctSuRh5wztHuYhMON/9gHAe/VyfJfMiOBDx+KT5+5TDlLIDXayjIfQcMTkcNYuVzF5+/qAjV8FOQ3vSN9q+vGa5Fr/APaoU39IeqUz7jlORYt6pf0TPYYICovFKT59
 IiTG8On2
 3Q4CdNRjDhrlRAIDeKKv5E5/m1RqDmjeHTyEeNNF6suVpSnBMjK7OoBu/SWWo7Kgvuq1FSurHWf+HnAjBkm3D7BNPU9PGS2y3Gl52XbAeKMtuNJS4CL5XjWmf7TByK3i3KjttgNnIVb5FP5v/wR+milCiY4wI1zrpU2/DL3vn0+coCJKlDNLY/gnzxFGWBthv9kBO9mbmvaBKiRc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The loop breaks immediately after finding the first swap device and
never modifies the list. Replace plist_for_each_entry_safe() with
plist_for_each_entry() and remove the unused next variable.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 998271aa09c3..cc0990141171 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4023,7 +4023,7 @@ static bool __has_usable_swap(void)
 
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
-	struct swap_info_struct *si, *next;
+	struct swap_info_struct *si;
 
 	if (!(gfp & __GFP_IO))
 		return;
@@ -4042,8 +4042,7 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 		return;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_head,
-				  avail_list) {
+	plist_for_each_entry(si, &swap_avail_head, avail_list) {
 		if (si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
-- 
2.34.1


