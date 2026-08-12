Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DFB8C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233506B0164; Wed, 12 Aug 2026 07:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20BB66B0165; Wed, 12 Aug 2026 07:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122A56B0166; Wed, 12 Aug 2026 07:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D80396B0164
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:32:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A530A2616
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:32:12 +0000 (UTC)
X-FDA: 85092403704.30.29DB469
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id A606B180003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:32:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Bgkzq1hs;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786534330;
	b=7cMFx/w4u+X7d91FYaXoY+hQpnOAJGu3PMJOv5OA6lm8P1dSGGql3L4V2+DiUIhv9YmzeP
	re0os7o6JvlkuFIJ+O85JRZlDpX1AUqEHFHJWuPPqm1NfAi2J6Ky90BRSERHXKzC+LzAV+
	97xzAPsPNqMYAiGF9+5TXhj++IcSWy4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Bgkzq1hs;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786534330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96LAzBjfGAx9nfZL8SX73XYEA1A5G1phryUkEZQ35/w=;
	b=fO5nK/84GjkSMjsPIdvoqvu7ZGulpWLgoYnojeWplJO/2wRItjZSBHbdK28RKY7EsFuLHp
	+KYGYtWHsknpGhMzMgNm6FP240gqXiPgzqvOqDAb1LEirYnF7j0FExolR7Gqogh1FlaOPb
	efRGUAZJ6BbyUt02NpIW03AEGGAFuR8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=96LAzBjfGAx9nfZL8SX73XYEA1A5G1phryUkEZQ35/w=; b=Bgkzq1hsvSlzCUSnGj2E/Lk8tY
	1dMyAR9AzJbQC4LpK1CNVMN3IMg2XiBBdGGpHkZxiyzZHzvIp3lUvfGekHCX5qso78dVIIz/RZzCU
	hVvG+mObEJqzW7JMq1qj9/03SAiuonCVJ7bOj/yPU94AS13q/qPSjmQLbpm0nHqqRNDSL9GTfJTki
	7cfn0GrGjen4rSZ9S7hRf+NKHoJNEtW8bP6rjSgwUqTSuMZ4Tvjn4LUfe7bBvffBhNfU4VO18ZqA4
	jZM4srYTplz+S6iuZ0U3OAwuI7bklGXi8w3NpWly3ODPPkf2aua3U5d1w/Dfozz2IlQpJhZVdTTkj
	YSjXuH3g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wu7Bo-004JJH-16;
	Wed, 12 Aug 2026 11:32:08 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 12 Aug 2026 04:31:51 -0700
Subject: [PATCH v6 1/2] kexec_file: stop the top-down search before it
 underflows
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-kexec_posioned-v6-1-e477887086f0@debian.org>
References: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
In-Reply-To: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Breno Leitao <leitao@debian.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, rmikey@meta.com, 
 riel@surriel.com, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=1669; i=leitao@debian.org;
 h=from:subject:message-id; bh=FmvGEkh2rRrjTsnxxpplsZ7+GnyJWiiOZt1q+BoClXI=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqfFmsyEno7+ZM8jNDTttS6/P8qtEqZPqoheexT
 8D0MQRonQuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCanxZrAAKCRA1o5Of/Hh3
 bXSJD/9jfrIbSU3oHTQv0L6n64XBO1LZMWRmaCcv4mpdb64PYKBuJ1vpA5i8Tqe5xgTSKXXA23c
 CuwqNJzcw1l3YXFoQsX3nttO24qrXYmd1hXK/jlkiBlgRxi+K3ue/Xmcz9108cNsRdieQmwVc6A
 h7veNRxUviUn1rvqU4UrdmgY5FZC5phM5rnABwFMz/hOju74BJ2YBer7UB23/KC81X5lPomJxQu
 DjRMiHU5OgXRDphVIdC1ehkv6d+D4L+kv2WGaJDqJ6qA6QsFScNowu+jY+WIbq+7nO2VY0RooHp
 IUm06Yv2t0eN2jtT05X0mve/wbxwzrHerIWupYY15hnhalruDg4iPLEv0UER95+Z28F/c7LpfXe
 8a6LbuH6JVQSr/lfxxoNSoqSatUe0YEGHWNecjZS85BdNG1pqw3mmN5N/1z9hxNC2KpPXtQXwSe
 nkAhZCovOV5Lnma3VIV4uFACGpv1O7NjkHsPX/xjEl/saVEWhnZW+Kk4/n577us+SJbLXQW+0Lm
 N1imHnRQQYBGccSPA8iyjrYOZhhJdUxEbGuISLllYItLB+g5UzJdx8wvHro047EPIzHVqffnTe8
 gofvKGUZtDyNj0/gzahda+W8EGVLlfGHHnyUE1bA3xQDQIiiTfONMjN28AA3hd0JGadH48d7q1+
 sSI7+Vo85i3O9sw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: A606B180003
X-Rspam-User: 
X-Stat-Signature: wx4re6njiffzpn7m3cquwjaj1xgp5q9d
X-Rspamd-Server: rspam06
X-HE-Tag: 1786534330-372865
X-HE-Meta: U2FsdGVkX1/Zk+digcZGPfxbzhQxyUVereL+7Zhvgrc1HlHuxaJmm/1Ko/V+FgM4HCv+yAwANbPW4d5/Eqb6QJI/V0XboWGkq1MYuSIjDa2D1TfPPX6q5juozj16rJXb0m2lb5adyYv1gV0DSPl4yOOPO0irAbFQ33B9g70vY/cQXAtSGPjm5DpsyZwtHzLyOqMlKVgDeZzqXZTa16TtFx+fAUy+EcBzHGQSMxuIwPPxcWG2FGAT54p0Ct041I3IRHLxPGzObywtG9hbhxzaYj2JQS0AEZ4JCX8/MAzXV7c0wVQfV4hFAGKVbOe2KwdLAdPaNsYgLOkbkTPSw0OIHhB7iGenRnQoGAZUDsl0A0Isi4HxhlALoHPJiUymGipD2OeUmfjh9ZhGm0vI+F9sDWBt9379E0zmjp6LquS3uh6LVYK0JtI1P3Af/oQtgeCpdc3cy2fD3jSC9TUZFP15G5WCIL825KcnimfblXOCI6OGy2KMb1RXoYHXJW0NlVU3gdLgVYS8uHPpycMQAYmve0tWUUhWjt9pP9HM4iyYbVubNl0Dc/LISN2zU2sqLj4Yxpeyoec9/5AE6/mfvLx9eArJolTXYfO1AUhmhwlorGMqnW+huaZCMICGdGatDcdmdyGxDCoen30r9+EKzC4QbwWy/1ejrJI1kY8OuCpplT6srAunbj/hQvFP4Hji0PSMVrd2SPAlUNfbVWwq+dgei+EpWjKbu3FoxOjc8x97R3OiKbESMsV3/L0wsMOUcyi0vSPCXPxNCjZsYCmRPKoGhYHLlmlatV9p1cn0nRzF6X5wdyrn2cz9zjq4CjjQ+C6kgyBOSAwaNj1VIZCePYnYGd82JnZwEpoKNb1wvSRxJY4sPrKWYHNwl5176zGeSE56gzcfArMLOdOtU+gO8KsnCQ1HIjevz+QxtDQZu8ps2HwoPVfaQsPObxfpqsLDJJGtkId/QRKih1wUvfFDLzq
 iUcfVQ/Z
 hEByd7+9E803iL2HOdpKklUBa+mzQ1v1SIqxMfU3iffMOQ9dGNTr5J+c2vHYV2rtDTmRBq3PSwUMlyvUzxioIbaIp8kx8tgnNMxoctqchtxAAXx7kZdhRvGJ+LVwA9uf3A3MmlXSNfQKeADBliGRt3R8fy97FuZTRsgcTY3f3XWhYhBHjo92TxJwtq8w/Mv2hnQSpnsPcPuXxlog8NQ03r1pXBKK4rRGt07m5lfNg0vOeqyjxXCdgHvoDL81433KWwCy/KwoTzIs4HtfSFgNu+K3YM8fsfaSR5xImQZPWxQrkOn3RIpsMOJgZv/vXf0wFeTRbeUySq9sH86GLlOhFENEqgA9ckTqClKHsU76XjrY4MLQ+/f9ZDzlSz60/ti3FLv+aqNXNQaQ5dTSG5R5yEPRTNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

locate_mem_hole_top_down() walks candidates downwards by subtracting
PAGE_SIZE whenever the window conflicts with an existing segment or with
an architecture exclude range.

Nothing stops that subtraction at zero, so a search that reaches the
bottom of the address space wraps temp_start around and continues.

The walk starts inside the range being scanned and only moves down, so
bail out once a candidate ends up above end. That covers every step in
the loop rather than the subtractions alone, and it matches
locate_mem_hole_bottom_up(), which already bounds its candidate on both
sides.

This is a better check than subtracting with check_sub_overflow(), given
that we would have 3 subtractions in this block, and this single fix
would take care of them all (instead of three check_sub_overflow()).

Fixes: cb1052581e2b ("kexec: implementation of new syscall kexec_file_load")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 kernel/kexec_file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 59fb9d71e9d86..01a64d98fbcd7 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -484,7 +484,9 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
 		/* align down start */
 		temp_start = ALIGN_DOWN(temp_start, kbuf->buf_align);
 
-		if (temp_start < start || temp_start < kbuf->buf_min)
+		/* A candidate above the range means the walk wrapped around */
+		if (temp_start < start || temp_start < kbuf->buf_min ||
+		    temp_start > end)
 			return 0;
 
 		temp_end = temp_start + kbuf->memsz - 1;

-- 
2.53.0-Meta


