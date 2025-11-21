Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6041CFA753
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 09:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22D9F6B008A; Fri, 21 Nov 2025 04:44:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205666B0092; Fri, 21 Nov 2025 04:44:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 142756B0093; Fri, 21 Nov 2025 04:44:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F2ABC6B008A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:44:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8D13B9DAD
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:44:17 +0000 (UTC)
X-FDA: 84134128554.03.3348995
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 148F6A0006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:44:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l2qVJFkH;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763718256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iac2+shAosSqIDM+XOc4XTNyGU9n2u/2T1hFhgp8Ccg=;
	b=f3O3AD0qNF9i3xNsp23oxLAFrDmBXNYkY8Nja+1BGFbxoXF3vFJSIgO0rKpmRKXVk6A61y
	YK0lgJ6sTn/lMFPxt5xsWpxm0sZzt2Fr5QVuKVcqkmJsLln7BMt8IHPi4DrIyr6CXnXF8Z
	vi52SO1RGJOkl9YNkN6yIyTqlxR2go0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l2qVJFkH;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763718256; a=rsa-sha256;
	cv=none;
	b=rA2yELQtDzhF042OU/zJmyF0ZL10Y3wfjacUc9eMUPlfTLjuyzYTO3hwjvNopXZzh+z2Ns
	ABprhZRZoEV4vmVailDkJDxgLyXLlR/qhOYqxthWMLEzd6fWLjahoCZne8mF4ngBXtCxfD
	x7oVB0Vj33hjmE/TxWp5b8iSyxNq1xs=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-11beb0a7bd6so2523334c88.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763718255; x=1764323055; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iac2+shAosSqIDM+XOc4XTNyGU9n2u/2T1hFhgp8Ccg=;
        b=l2qVJFkHIoCnA6HaYHUpNYcJk9Y3MuP6gXfv1UMbNXFoYGudlxSzuqwDqs7ZKdxBsY
         XJMR6nBmhADopoQFctVf75gEwqAunsfX2BJZsAa2oB/EuaZGW2VztJ8pJG9+WzKxeKos
         +JA5GYloWn4x+pipNym7vYNVrH22da4yt7YJgXCWOnrHpHLLvVyviqRwIUOFfLCEGJvq
         TqJqSDha3S18sJlV2iJgFe2xdRJASxTrmU7PgWCIC9odRESMZSLuU9iCQFhWLbsCjAiJ
         J0DHtI+Ikk2f/CkeUHQOrHV1i7sCOwCMDi0p1y8hSzbWQqAozjU2CHL4UtLjucFS4ekG
         OJzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763718255; x=1764323055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iac2+shAosSqIDM+XOc4XTNyGU9n2u/2T1hFhgp8Ccg=;
        b=o4tXzedbpuiXhT4fzxQHs747JmjRfHGgrNaU79609W6DVlF+KLlPRHQcsaZnZlz8mu
         Ibc7Ps/KUp4g1s9CmdBXfMI9Uq5309/f+0NHJ5Qcydi7HX6w1y+2sfPq/3wGn96WcCbx
         lEyxJNdS7MHoQM8xziCwUjzTYVlUiRPck6ZjDBV/Tn9W6HMEF4xOcNHQmQ3Qz87S5bed
         NBvdbE4tQtt287l1xAmzbUfN3ezpk4FrFe1kB+ILbAdmAQMmsTTNDRJmi6eyT/7GqAhk
         x+SUcLfy2iCxPqFKAUtPA1SikQ+Cq04iBAPocpzeg3hQbaEVzfAHyWjcHmWIgnkxFaWT
         xO4w==
X-Forwarded-Encrypted: i=1; AJvYcCXjyTJ2DLnrm2woLJTgZZYCGk9ZNZmrzYgFSrImwGlXX5itW9KbIedO6iUhOHUd8DgRtdrzN4p6Hg==@kvack.org
X-Gm-Message-State: AOJu0YwCQm+yoBLy8091KQR5O6D9n63NnQq5HOmtAm4hMCgO9ahE97WX
	wo82UT0MZqL5NJUzVtZTCHuvguIlEhw4jnrzKbWL3uef5uKAKk8rI4rz
X-Gm-Gg: ASbGncuzUX5iUs1QSKNh+hlmuHG/rRVLcyntmNd9zHuQYOa/bWtlqzCezZp8BNSVupX
	k7mzpc+1YCzlx42Ea5fQlK9QgqPgMl5MHLCgpPCi0qDWaDZq2VeDYwMSFFJzOaqtu1cQHaSTT2o
	rmHXe6UKkjAPCN1lzQtRDi9zpR8pmea/mAgEU2WF6CDymDGZ3YKFBmQtW4/J30JYLZKKd+NdzMp
	bZ8eJPw9uYaZCZikik2Sm4EdgOQFmNfHQs6NHJ9c39LY7D5uaXc7pFnE4aP4ggyTI1cgB7luTPy
	WYdrkdVP04TUJaZ8KE5CQjlQ2n/so43X7gWzEewS0zC72QzA60X+c/SZk6Tl0TfyWhU5wHIhh0X
	1GSjUpRf/f7KK5SiRlNNJUDRGNlPa5I0MlDWANtMdcSqLuRszwgAspND2rOmhvISonnrnn0lv+E
	3P57iVk0bQ0P/a3haQeUGKrG6T/iDX4tPgvpQfPx132vMiT+ZUpkQXPw==
X-Google-Smtp-Source: AGHT+IFvI/4n6X/UIvUIYWfUH9uidHOavQeX/3IyJh9gxOEFNK+i8k+uai8hGyuumF2905nUSzruOA==
X-Received: by 2002:a05:7022:1e14:b0:119:e569:f86d with SMTP id a92af1059eb24-11c9ca96a9cmr363858c88.10.1763718254594;
        Fri, 21 Nov 2025 01:44:14 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-11c93db4a23sm22430736c88.2.2025.11.21.01.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 01:44:13 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v4 0/4] make vmalloc gfp flags usage more apparent
Date: Fri, 21 Nov 2025 01:44:01 -0800
Message-ID: <20251121094405.40628-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 148F6A0006
X-Stat-Signature: 31e94hky34ys8nefhkhfnzo8bcb7nxpe
X-Rspam-User: 
X-HE-Tag: 1763718255-689905
X-HE-Meta: U2FsdGVkX19mkkuKV2C9Y0MPYL2/lEvO69byGSpGeFz2JSXbpATixTeUg6CSv+BbkI9M92LskNWElvOdv0eSgPrLLEU4Mm39qKkLZ3m8HD7h84rZSaXqqav8K16H9BMkS+A0L/N/6+1xEcfjpITe6+op0vLGsZOA6RG/2pAuPPFf33dx5UpVMEQvVL2Kq7XKPumNsOvaRvtL2TCYryLiXIGdw4C5ALeiSaYc6OeAOMt2nzuWRSaa7jVkL3USwzuDsjpBufyjghJjf3SCjZ8NQSwuLUJyKrkyIXhy5syi+6au2muO40XzaZ+Hl3jch5eXOqmSi842tu5OhMn5uENI+PW0Z1WUb9z/KjpCQUHsPk+xiPRtTwbEKZQMbSR9CzQtmweLg1Uk5RP9pmrmKAOZytqs2lZ3WOUEgH9KxrJ5jQFW2x0myNp+KMam3Zr4FSsw/qsQAZPxp0Mmf2Z53y5aLXrGymGwQL3R4zlR9M8Ea9XDbOgJ76qBxQFzKnPM4QKTSqcGuBMR8dyayrVHYsFAAwq17ocq5O1D5YqA5cRgn1C7EBbjALDEzysj/vo99vS5tdvclcPMVh9of2LEDZZqrMWicTxA6bBa5sLTHX9VuEAKZOQtPw3zY7SWM8QP5VjT+q+jxfezWYI6Ur2NbtNel13aFfrx+7c3gceU1ts/d8pXm4TMLA+/oix2LlGvT9i6KN5+JehyrpGWH5mlKhQ501QApVwvqUOF0qeKkjussOboROdFisZQT6Vt3Mz968dKkrvsFyhatxzre+bn1c2L+OnfSmgtzI97tJ8Tycn101NR6uCUNhyiKVijfTeS0lIAemogUN6CsJbzH8Stm0vVp7FEum3olgNUsou1A3MQCFWrMMe1TKyaGdBCBVBmt5SRqazGtbMhkK/3wkPKVtLs3J+hA39FXkBQjY5Cq1p0+rNfzWqpBCsejP7YustGo/P8hG0glagoYjv7fHAqQ/9
 dZK2juG3
 emrwsGh2La8z5wFD5SoM/vEheuZQXdsPBuBUaQBRNt9MrsO8v51pESH83B4AEDDHmU0pYjv1jL11/uHgxSbDzxx8CHVkw4OcxWj2p81N2xY+iYmx0eyDug1xgaFy1W0Kwrmyqpj/KbThSkIR03N4+9pmo3l1sJns8n0Jyt6TaDm3bp+ig6z0rDxGMsgIlm9IbWH0f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We should do a better job at enforcing gfp flags for vmalloc. Right now, we
have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
supported flags. If a caller were to pass in an unsupported flag, we may
BUG, silently clear it, or completely ignore it.

If we are more proactive about enforcing gfp flags, we can making sure
callers know when they may be asking for unsupported behavior.

This patchset lets vmalloc control the incoming gfp flags, and cleans up
some hard to read gfp code.

---
Based on current mm-new.

v3 -> v4:
  - Add __GFP_NOLOCKDEP to the list of supported flags[1]
  - Replace WARN() with WARN_ONCE() to ratelimit warnings[2]
  - Collect some tags

Previous iterations are linked through v3[3].

[1] https://lore.kernel.org/linux-mm/20251121072945.GA30438@lst.de/T/#m7cd63a45d0cde563158ddde5ea54e46715e34381
[2] https://lore.kernel.org/mm-commits/20251119164452.0f763efbb282f71438a2964a@linux-foundation.org/T/#t
[3] https://lore.kernel.org/linux-mm/20251117173530.43293-1-vishal.moola@gmail.com/

Vishal Moola (Oracle) (4):
  mm/vmalloc: warn on invalid vmalloc gfp flags
  mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
  mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
  mm/vmalloc: cleanup gfp flag use in new_vmap_block()

 mm/vmalloc.c | 50 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 8 deletions(-)

-- 
2.51.1


