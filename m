Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CF2AECD9BC
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 02:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944CB6B008A; Thu,  5 Feb 2026 21:47:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91C2F6B0092; Thu,  5 Feb 2026 21:47:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B086B0093; Thu,  5 Feb 2026 21:47:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DA6B6B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:47:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18B8213B5E2
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:47:31 +0000 (UTC)
X-FDA: 84412495902.28.0E5F7E8
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5617D4000A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:47:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=nKzwI3+B;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770346049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ob4om/ZUIH5VDpYQRLmM68bAMoFu+iin3OtrpO9F1uU=;
	b=FMh03mj9tBjI9kAOgnPsnO1Ixg08sJNtKcjluhJF7YPktTlLf55lZxf9ZxAMk9uyFkjp1l
	JijrT0EGvvxnzm4RnxE6tVgfgM6ZOj+5Ms/MC96NvJ2g7MXmtj877qBel9bcH+tEV10sF6
	k5FMVUQrCk16l/oW4P3SCtPGNBcqYJM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=nKzwI3+B;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770346049; a=rsa-sha256;
	cv=none;
	b=shryunXY6SXzEE4/bHWJYkeauSigjRh4a9S85XeWzWTpF/TMNTI2r7u9KjYLYC6rXGKuk+
	AhBqkC+q2QSW+Q9BTdog6epXtdfr7vB2Evp1tRaKiwT4/AF4bPz+ZDh/+b7RQKTEy3vaCd
	COTeTv5R9rpKSYQ/+Mgx5COBY5qAl+g=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a7b23dd036so918495ad.3
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 18:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770346048; x=1770950848; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ob4om/ZUIH5VDpYQRLmM68bAMoFu+iin3OtrpO9F1uU=;
        b=nKzwI3+Bf3JzhEsP+50HhW/dR22T90MCXGr0dFcN9zZ5nTDP6IAF9oNyLx7zLXvTZP
         SnO449sNU/qn10joiWzQB4CXp0keEhEfyqpv+Gs1FOeIC/8Q7POdnQ+i7Z5ZGXanGPYR
         2VOstU4MnGQm5hwAq1OHhvi5SywZscuOGL7YM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770346048; x=1770950848;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ob4om/ZUIH5VDpYQRLmM68bAMoFu+iin3OtrpO9F1uU=;
        b=nHcQxjwj/et5Wm3LWRTUubZGhn9NlNEqAwDxb/vvMQid2dsS3TnX1Npj0biPA0b4we
         oYVCrzE2D2H1dHabefftGZbKR261DCV7/QdDGr8SEqZqsRUAHHCaT61ObvCfmfHChv5e
         d4RWrOp4bEyPoUuKmmpmGvgKf0jGZ9/mZhIk4xsXeD20UOR9RkPTKZDscHk5pbu3KqT/
         w8Gi7iLLJ2r+q/Otb6r1XvoAi0qYLvp1QbW51Mfaaf4GujFJgpkKNKHZX8YzEJanmmlP
         AoiElhrtH+Rpy9yoJWnhQB3RolvZDXoeqMhrW6sYO6ikoJZS2kp15C2lb3M6VL6cHiw9
         bHvw==
X-Forwarded-Encrypted: i=1; AJvYcCWnfY1vfFLTcFyztLHmb9FPF1zMoNStoNNWoXT8/baWHqUy6iau54xDJWstR9rS439mAoXxob6Gjw==@kvack.org
X-Gm-Message-State: AOJu0YwKQZNqD+407Iv2R6oZURtIeBdIKNncs/apimruFcCRKceLvw7g
	ctegT5IBw9SVZhu/j12elhpxocouPeR24ZnhZ12ur4bdbE9dqrqKUIJLI0qWNeR/Ag==
X-Gm-Gg: AZuq6aIcXSX9QNDOXa5bicCNgEfW4eV8Y0KkrytPQylFxSM9KOu5o9SYn6xg5JGXBVi
	NnUN2f+8R9dvtxKHIUEy4LbrJ7oS57aWy25+5M7WJaQXvM+UYn56v5tjT4Ox14urZefIZsHbisV
	3O1irYu6UH+ZM3Kts2Ii10XhaQTVTLArnlkHRtatkUv9dgd3Qo7LIdRmnktuvORJgZ1hBKS/ijF
	6yWE1a8VPtBtZbP5dn3PGc4Sn2wnmCvlZyR7igKwmKIWKDjLJxwKBQEXH6MqoYp6mJZ7OJ6/rlE
	GePR+zYFbp4q5xKS3IjRhYWVI5lSNxRGpNjVznwu6jLXqEklSb/YjW2pnmm/2T2WODb1IN2370Q
	yvODUTGJUpL6oKl9Elc4hEp3YUnn7Y9lF4O9njxw0Db/tU9dJWHU9c39aCSG4NZDOG+UF2jwJxD
	fobLLEGTlDpz0NScWRty+d797VNTuyNjdO/v5Xf06ky6xPfDpqudY=
X-Received: by 2002:a17:902:fc43:b0:2a0:f0db:690e with SMTP id d9443c01a7336-2a95192f788mr12567545ad.52.1770346048063;
        Thu, 05 Feb 2026 18:47:28 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:7c0a:732a:f36b:6acc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521c4134sm8184765ad.50.2026.02.05.18.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 18:47:27 -0800 (PST)
Date: Fri, 6 Feb 2026 11:47:23 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [stable-6.6.y] mm: khugepaged refuses to freeze
Message-ID: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5617D4000A
X-Stat-Signature: ee8nwpsqk7uj37b11by5wu5t9rzobnkh
X-Rspam-User: 
X-HE-Tag: 1770346049-461624
X-HE-Meta: U2FsdGVkX1/zq9p+u7+WIgBcFzma+8RlebVyM49/vqvnPRWl039lCJrh5yo7q64tuoNYi2tShnbRTiIPgAx8iPekhcpXBbg+gBtLmgrz+YICkEiKcNzTqbTYUiIFE/Bj248GsNtZy4E+eTj2EFdW+ZPX2mX9nzMB1zx6RmthkoozbWlK6vHKE/flU1n7KqEfTx8gAJadEvBJUVTGVX2thipcBz2UeaZWm6u0/NqlDLGgjBGIflN2WJpjK4tzL0ftVg+dcVCaajTnXKngR6VlvwY2scbA4k8BOFCAd8w17PeOiTtB83miKo3wqOBFZdKk+y4xFOd/lQtP6V88IeOKJeevmgfKyLmYcsU0hGMDj7prXCz8K8gf8vcmruFqs8I1YYojeAy5jBkwJdOzQIzy8laK8H0AyFyuXybAtz6dLqaSaMalq+OXyTRvUKIwx9/5HseYF+xXX/Z7hUcmCkkOTdunLi9JckovLPamdUYtHTdLFVRypf1v4z/lQdgKhtoG3nRI+kypBkxchR9Pqrtrr7pBkgejrxi+ESFUIlT+w5KdOFFvcspEfmW8C3aEUekT9aipl82tEsmS7/D3w4KFwse85ImswbacG2Tps5WtbjnMkpk+esBwRz/PfFa4+ehcftTModY0knh3BT9cCnquF38IbaoGxTq6yNMJ9MTWonMK5JMxBk5z110jD2kIpNwPDrD1f67sKhrM31dl9rT6ghK91IrELNLn6c3z7qeQCazHXPASfp2CPP1WEbq/Bf9IEk3F8l3pVgaEfNkNYTGhw0onug9IsdXMu/cV/jEM8yNdYxP5nwLoBkGkel2/KXCD1maXU0M3P8WwKeC29LwLdBHQSAsccK3SjmS4l51S20AeOLijH8J+kZD7KLqy8XaMT70iVRMSPl5UyW3VK3JHHi1EyT8Zf3crqU1IwlmSZVyZofYF99q/9sB9PRzrBuoFZMNNiAvfb04WSdZ6JPc
 1qJsSr4g
 N2GpMntgJFOZdgT5hrDKgLbtiNDkho355VOO6F/3nqjjhJEwrSeH5YLN05n1mOXcgJJknHNijslhu1mYo8lHdTOaUcyeFXb7QWpie0IAZ0yAATgOPy6ienutCXiBcwGeR7ds3lEH/TeaxYoAcdVPRED32IXpHK20cA12kYtI/Nyw/mFrbmwpWKEK+PowYHpCnMQvvweYEy6gvy2hJfGvvTgslHJkBUVOrxfenoN24oh6nXIsR40P7U97BHj2Vz0pKs3Xf/eNORwEfgYTvz3IWp1AmxHHI2S/9fTw2wfvD5+q3d4y3d3sUA3za8ULetMeK80QkGKCsR7YrXnY/oKyrEPOIaS9219hAdbOSZ9fb9ymwlNI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Greetings,

I'm looking at a slightly unusual issue where khugepaged refuses to
freeze during system suspend:

...
 PM: suspend entry (s2idle)
 Filesystems sync: 0.003 seconds
 Freezing user space processes
 Freezing user space processes completed (elapsed 0.003 seconds)
 OOM killer disabled.
 Freezing remaining freezable tasks
 Freezing remaining freezable tasks failed after 20.004 seconds (1 tasks refusing to freeze, wq_busy=0):
 task:khugepaged      state:D stack:0     pid:1345  ppid:2      flags:0x00004000
 Call Trace:
  <TASK>
  schedule+0x523/0x16a0
  ? sysvec_apic_timer_interrupt+0xf/0x90
  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
  ? wait_for_completion_io_timeout+0xc5/0x170
  schedule_timeout+0x23b/0x6e0
  ? __pfx_process_timeout+0x10/0x10
  ? wait_for_completion_io_timeout+0xc5/0x170
  io_schedule_timeout+0x3f/0x80
  wait_for_completion_io_timeout+0xe4/0x170
  submit_bio_wait+0x79/0xc0
  swap_readpage+0x150/0x2d0
  ? __pfx_submit_bio_wait_endio+0x10/0x10
  swap_cluster_readahead+0x3be/0x750
  ? __pfx_workingset_update_node+0x10/0x10
  shmem_swapin+0xa7/0x100
  shmem_swapin_folio+0xcd/0x2e0
  shmem_get_folio+0x237/0x580
  collapse_file+0x247/0x1280
  hpage_collapse_scan_file+0x26e/0x380
  khugepaged+0x43b/0x810
  kthread+0xfb/0x120
  ? __pfx_khugepaged+0x10/0x10
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x38/0x50
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1b/0x30
  </TASK>
...

The system is using zram swap.  I wonder if khugepaged should
be suspend/freeze aware.  Does something like below make sense?
Or is the problem elsewhere?

---
 mm/khugepaged.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index eff9e3061925..fa6a018b20a8 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1894,6 +1894,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		xas_set(&xas, index);
 		folio = xas_load(&xas);
 
+		if (try_to_freeze())
+			goto xa_unlocked;
+
 		VM_BUG_ON(index != xas.xa_index);
 		if (is_shmem) {
 			if (!folio) {
-- 
2.53.0.rc2.204.g2597b5adb4-goog


