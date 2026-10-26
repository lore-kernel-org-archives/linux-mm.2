Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDD9D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 06:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TkiIF6yu
Received: by kanga.kvack.org (Postfix)
	id 183286B05B2; Mon, 26 Oct 2026 02:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10BEC6B05B3; Mon, 26 Oct 2026 02:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEEA46B05B4; Mon, 26 Oct 2026 02:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7AE76B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:09:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45C52A04CC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:09:40 +0000 (UTC)
X-FDA: 85363750920.21.C352A63
Received: from mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5EEC080003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:09:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TkiIF6yu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.58 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792994978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YF1uuN8vSqlU2rOKHVGJs/CBUWobe7SwbzRynZeYYE=;
	b=OJBC8lcKP3txDo9tWs9GKi0l8SOVcuDDSoZ39/6JNPsoLvi9RhhEbctmKm5Q+gcOH04cOj
	JxHD2yuezJ4AKR//y1a8F5pf/XuAMnf5qlvQQTmntd2V/Q7N/Gx8EngBzj+TGnMcbEQ1wU
	pf4/9yaSMR0CFQEY6SOD+BV22fjQ3A8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TkiIF6yu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.58 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792994978;
	b=XISgy28wHfJbSRb622gxxVjufKwxdalSaEA4jAwJLR26C656mpGZ7HVADPHBKPKn7hvwlL
	1BHJr7fwvyIkveEuVa2tT8Wh1HIfVpEvLIM+nVhovt/UtMpD7QkwGL7DLGY732JYGjhWi5
	QsYVBf7IfS0Zs6r7YO9gDG2+ulYhNpY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+Gh148DE2VMFS8ATJDVgo5IPfM8B6qMQjDKrc8U6oj4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792994977; v=1; x=1793599777;
 b=TkiIF6yuVJtr6nAf2/USF/K15C9zdPNVY4ELLntSEfEjQ/t/ZS0GaN0fB/nfjQDDaTSJmQS4
 VPLOK45yx5wMU7TfeCBV7ibNU3FrEBxcWLJfB2HOoQoL8Sz6mZF2+o9AdmEMadIGE9N5sYtOYqz
 URk7lT8s5lqCy9mPZI+S3uUQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 68994bf62ca272a5;
	Mon, 26 Oct 2026 06:09:37 +0000
X-Mizu-Trace-ID: 68994bf62ca272a5
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Mon, 26 Oct 2026 14:09:24 +0800
Subject: [PATCH 2/2] mm/vmalloc: warn on NULL page in
 remap_vmalloc_range_partial
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-vmalloc_remap-v1-2-b7a907814e90@linux.dev>
References: <20261026-vmalloc_remap-v1-0-b7a907814e90@linux.dev>
In-Reply-To: <20261026-vmalloc_remap-v1-0-b7a907814e90@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.17-dev-39d60
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5EEC080003
X-Stat-Signature: tr16a8cdpjzgk6c4sikgz8amiwqbnb31
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792994978-569375
X-HE-Meta: U2FsdGVkX18dAyHLDoWL5wxPv+iz9hN/QjR9MPR9JpIPRdntEEuJr9m63Rr/cOJuaohYtDscvzjbndbe5xOpeugnAfOqgAPtQ7mhN10ROEaN+yEGIZQn9DdGvUelWc+xXaJCK/tyl1hGd8TRtYWwQVgH+RhIhNlX7fxUBFWgb0ps73wO3mI1U8XgCaC2R7heJxCoYuhZIRc9asVw9eKtFvYBUqfmSprOlu4GMnHMRQSLj44D7loV8JR9PsreybEYeGSLW6s21Yk2XDVhGFlcqENfuo8oW4dm2ST2vp3y4hfhx4QWcxlLm3z/z1oGmUMnxZIED3LARW5LfTv9Prhu7G/4vsjwe7YGlbej5OmYjiPZWaD0lx46/l1G/U+HN8xRQNImR+zY91WrlOvvO7DKwpZdnFRQwbOWI6rbs/ZTpaDAi8m7lA0z4TcfTWWkOOpyHbL4XVCnDGBzu8TJf8TFJSiCX03syimWLo39x2K6eM2+Cc/ti25tGWuamnOe5eAOZYNCI7MFAmzk/KqwdXU39tQZZzTH04TNlQHH5LNVqvztNaa3GPIgLmsohKAcOZrlXsgA0mhC78Lb78OpaA/bKU42RfgHS6VL3AIr/n5fIsuh+jQfub+CspL097VSHU/kHTBvesVJQBpSPSXKdL9NAChHIgOhveknIsop7WD7/M5PJ/YTB64lDyEwk+ECH1gi733CZcJftF4JuOyvZ0ysxFtCkBrUsO//089cw7hZF822ps84ra4qPMcuGZaGHSMVDBNymfSicnFXx8MPu8vLS12ID54WF3QwhxQzpviI9BP38AZfTmwwR9KQzYp9N/+enhrlXmxCj8K3Hvwa9Z9UxhySiELIZPlCca949LlWqTNh2kqutFIqWw0X6xIW0AL7UPtq0xplAKvekSgq2U+uqhSPyOVTT/IfwE+jX1I1K8v/YAl91baiOvINRYXLwl3aG+bU2in1jH1yl6Oubex
 HHcbQcQ4
 OBZuu+z4ubYzt3KiT4n2UbghMVwkEim1X19E6QUD+ONBnyquxQ9K12HrJZWeTzjdNWuQOMOWCU7ugyVyR8t17i8697NHRCT4Gbx0ItjYAKLKu+V7m9yzybkBdrHFy1IZv9DyWp2tFKbeNXDi6mtTZcNc79/hFHLv7ghMaV3YSOh8/kyeUHdtz2hMcmreXIQFFXx5VuGEAUJQ40QyLq8rHvpRAuudnmuNDIOi8/PRp1vhOAPRdXy0yuZCmr0BAKgtsCir2P6PTn0W7AhqMKTMfIrQo7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ye Liu <liuye@kylinos.cn>

remap_vmalloc_range_partial() oopses if vmalloc_to_page() returns
NULL, which never happens today because VM_USERMAP areas keep every
page mapped. Add a WARN_ON(!page) to flag a break before the oops.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a888eca016a8..59ba203a4eff 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4906,6 +4906,7 @@ int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
 		struct page *page = vmalloc_to_page(kaddr);
 		int ret;
 
+		WARN_ON(!page);
 		ret = vm_insert_page(vma, uaddr, page);
 		if (ret)
 			return ret;

-- 
2.43.0


