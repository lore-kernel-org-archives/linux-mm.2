Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31AD610ED647
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6082F6B009E; Fri, 27 Mar 2026 05:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCE26B0099; Fri, 27 Mar 2026 05:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E926B0099; Fri, 27 Mar 2026 05:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05E6F6B00A1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6F52E16D9
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:43 +0000 (UTC)
X-FDA: 84591368526.01.143380C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A4D1512000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4p0vxGv;
	spf=pass (imf29.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774604921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvkkOWWRtbNRnIhkuJ7S8/auI8roWxjsEcP7iqhAdU8=;
	b=Xdp3MxWrygyq//nxIVNmIee9/3sPeOT36leOmtzIti//TVy6iwYNMUENhuAdPtbd5YKkCC
	cHvrB4gh+jEv1U6dmBpZCGV7idVEBbbZmO3LGaujQ/TL4KQ+k79uukZlsZPQM/8kOmRrzU
	wOwE+HHK+qi6gsAOMngCUnFX6bwdw10=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774604921; a=rsa-sha256;
	cv=none;
	b=gvfpc73Rcaiov6EnY4CfnH9HYc1fsxFFvsyr4kfui+N2Hn/ATv5nEIZYxkfgbhM+d15LHb
	GZkvKUd+bY4Q+187AHIqKfWNv4PndPs2PcmE9gxYEr7bVNA8RazVibKUd+WVBEY9iVZDt9
	c6XI+ectMldDK3j4hd3EQhuSTKeFjm0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4p0vxGv;
	spf=pass (imf29.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC68F44514;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DF0DC2BCB5;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774604920;
	bh=6f7TOEvk+v4ej1arN46RE3RzMBqAOnaX4qdIPzrc6Wc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=N4p0vxGvACzu6SJQ693+B0nTysqHWVCI3HVkGtz9AVMl7McDIWinDaCbqK9zHr3nX
	 uutu3RHr5+jf7Q5GsfKDg3O2AvwW/gJS1QSUVJQWQYn1cq+MQcFWWzQCj5byCqO9vf
	 SqXu0Od8pfI9w6Ew7NMQtpGd1B694ovtD1myrHX1ED7YYJQbRg9zpKrXTPYRQW1kjF
	 WsYTGo/mzqZKWmtsT6scaRzLIbs9d7PM6lXBRjkbb5HuuEuDtp0U86frpAUmMAUT5K
	 xHn87GNeeKh4WQpR/3zYY3yBJ8ePUlDXM4ADJ8UG+V3orFRmsNnskXXylV6K5UOrZY
	 dg0l2PxjpO5+A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8431110ED643;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Fri, 27 Mar 2026 15:18:42 +0530
Subject: [PATCH v8 6/6] lib/test_vmalloc: add vrealloc test case
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260327-vmalloc-shrink-v8-6-cc6b57059ed7@zohomail.in>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
In-Reply-To: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774604917; l=2848;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=q1HLhsQQ92caXQ9Tt0laK39H3cv2PUzBofvprsTi44k=;
 b=R0zROdvr8i0XX6srRKvEs7y5ZcvavZ3hzjKSDrUemQuMhSzNz/REZ8S6xHmVM5osq+FaQvBjq
 MEDVIjWXfGOBialWV0d7t7bHDRlk+HhpqGGPILoVSn1BG4qWkK198OY
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam12
X-Stat-Signature: 7s9r1h6wmm96wj9xas5iwucq96iety94
X-Rspamd-Queue-Id: A4D1512000A
X-Rspam-User: 
X-HE-Tag: 1774604921-27537
X-HE-Meta: U2FsdGVkX1+DV7wsxGPX1P912AePwb69rqmTul44xVe9WfUaqMPLfU1P+Es5AILc8ih0/RSREENbAeUeUQbh+nn3Rm5vAP+jthWaGI6aW0NJcMqY+mvTQCRhpXs6nhb1zcKvawI9S4d5WVT+0zKqOmpGDWf/IU6BZeG4M667nCYtsk3Uoi9eBUnZnzT9XywQC8Qnw0r58iADm/+eZ3h8agvUpkDNSR0D932FD/YbqdfzO+SWGs3SfcM4JWenuhSMcgdAOE4KXOpx2MH36wo9DYOabR8G2PbRkLN8PAneAqcI9TRl61apu95Imzhiza5GO9XYxKq8S70Ni/+El6mlNGazhn9ODpDj8JNpJZPNn70433CDZ3+JLgTNiHPLk8Z9zhWawISegbjhgh8+tR0cOBGgbcSSyoASvdRXokykkdL0+yKigFaZRie9esDarjW75g55WIas0Zu7+O0IIFAQO+108XxLd6wLPGTk8hGzt+kSNdDYtsKq9u+uWuea78fPUlBtfzGBYAyI6Dh1m3BDMHPOdqkOgLyGLNmnKgQmvhaLoIcFivNUImlhOb9hZMb4jR9yq05ghmgVmnP6TwbfO1KexDAPHe3D78SXlagzDk3qfxmLsYFnL2eEQ64fI6g56mTmMrCk8vYrpDGp2Fexa5ydtYo/ioH9k3PLjPCk+u1RbHI8ODRbBWnihcD2mmfHaU/hOQHGCmk71hnpCONHa2cbAgMfHOtB3dgMS3DH3cphzAl7hepPgf9Eel0ucwChSYcQXVR1aI6tmC7ANld+R7h7z2FmwM2uzDqtPl+MOr37+0CctmP86YMfDcI8A7EZaA/eZABucuFwJ1o8PzVd+bmhhQ1zDaJNsJkCrZ+rO0JT7sG8Yr9UgBxtJ7l8YhnWgK9UJJDrpRsG9Fi1GXZoTY19bSTP6010t4jgutTFxPODpRhDKKsw5v3f2kLiIN8Pl1JjScGeADveBfa3vMb
 qHnkK11O
 PPHAGsI3RsSCbjwAcjBnaeSwH8iZvvwRr35cToYSG0rbvX+PUPj0CxVHGUBZfw0fTq53pgQNQwwSowTETiRSCwQtKjNtcjGyl9B7C28OQ4JPq9MSi6yHmRCRGAQ/UPORKON8ipeozJSpNTvUIG1bIFaFzjC18/0Xo/Jym+PlBZB7BnG84oPgiqANaz5c89Vd67Mr55B72F1GNC3Mi3037SRgWJBfAxDq8oeyoQcfOPGQllpGLExdBIVJI+z73Q1gkeliBkKvVnPOzHHOnQy7jHALhTP1JEK0CFiFHVn1trt0bBvLwhUqVskRHxSrQ/wuBYqp18WMDal7SZQsQB6lYoLYAKONUTPMKQPniJqEEPAq0YrO3D7dQp11VfYF0yf4VTmRfvZ3h1ES/4G12F8esoPsahHoX96Tl2kC4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Introduce a new test case "vrealloc_test" that exercises the vrealloc()
shrink and in-place grow paths:

  - Grow beyond allocated pages (triggers full reallocation).
  - Shrink crossing a page boundary (frees tail pages).
  - Shrink within the same page (no page freeing).
  - Grow within the already allocated page count (in-place).

Data integrity is validated after each realloc step by checking that
the first byte of the original allocation is preserved.

The test is gated behind run_test_mask bit 12 (id 4096).

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 lib/test_vmalloc.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index 876c72c18a0c..b23f85e8f8ca 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -55,6 +55,7 @@ __param(int, run_test_mask, 7,
 		"\t\tid: 512,  name: kvfree_rcu_2_arg_vmalloc_test\n"
 		"\t\tid: 1024, name: vm_map_ram_test\n"
 		"\t\tid: 2048, name: no_block_alloc_test\n"
+		"\t\tid: 4096, name: vrealloc_test\n"
 		/* Add a new test case description here. */
 );
 
@@ -421,6 +422,66 @@ vm_map_ram_test(void)
 	return nr_allocated != map_nr_pages;
 }
 
+static int vrealloc_test(void)
+{
+	void *ptr, *tmp;
+	int i;
+
+	for (i = 0; i < test_loop_count; i++) {
+		int err = -1;
+
+		ptr = vrealloc(NULL, PAGE_SIZE, GFP_KERNEL);
+		if (!ptr)
+			return -1;
+
+		*((__u8 *)ptr) = 'a';
+
+		/* Grow: beyond allocated pages, triggers full realloc. */
+		tmp = vrealloc(ptr, 4 * PAGE_SIZE, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+		ptr = tmp;
+
+		if (*((__u8 *)ptr) != 'a')
+			goto error;
+
+		/* Shrink: crosses page boundary, frees tail pages. */
+		tmp = vrealloc(ptr, PAGE_SIZE, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+		ptr = tmp;
+
+		if (*((__u8 *)ptr) != 'a')
+			goto error;
+
+		/* Shrink: within same page, no page freeing. */
+		tmp = vrealloc(ptr, PAGE_SIZE / 2, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+		ptr = tmp;
+
+		if (*((__u8 *)ptr) != 'a')
+			goto error;
+
+		/* Grow: within allocated page, in-place, no realloc. */
+		tmp = vrealloc(ptr, PAGE_SIZE, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+		ptr = tmp;
+
+		if (*((__u8 *)ptr) != 'a')
+			goto error;
+
+		err = 0;
+error:
+		vfree(ptr);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 struct test_case_desc {
 	const char *test_name;
 	int (*test_func)(void);
@@ -440,6 +501,7 @@ static struct test_case_desc test_case_array[] = {
 	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test, },
 	{ "vm_map_ram_test", vm_map_ram_test, },
 	{ "no_block_alloc_test", no_block_alloc_test, true },
+	{ "vrealloc_test", vrealloc_test, },
 	/* Add a new test case here. */
 };
 

-- 
2.43.0



