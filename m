Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF659C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD596B0088; Mon, 31 Aug 2026 12:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5DDD6B008A; Mon, 31 Aug 2026 12:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4C586B0096; Mon, 31 Aug 2026 12:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB7C36B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:24:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 468E8A2324
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:24:53 +0000 (UTC)
X-FDA: 85162088466.17.D409BA1
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6642A4000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:24:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lTx1M50y;
	spf=pass (imf27.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788193491;
	b=ouTV/egOewxeYXajsP6ZpUxQQQ0Bf6euDUNrzHTHivHelVz48eRf5uY+B6wC5UUZ69yJmW
	fLWy7j8/MVIvSZxX3yRcWVFXUg7uDE2AZ5Z5OCRM68ICUq/HMWNhIuhU7o8ivpxFF9qIGX
	UDlvvgSjMSuWQ8v6eOTUI/Tp4nXF4tg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788193491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wASPUEGd3KOv6Fdubi246q8cZj4P8D3ytyUATn9DWg=;
	b=DQbiVq2Pwsl2AStyROsM2e4Q353Mct06y0qPnhH+gMQW/kFNyKRw2yLli7+kndqB0fypa2
	Zomnp4lIkabdz7V4Yoc+z9LqPb5/fq/KSQ692M3Jz+sHnPM9qQCX38W/SSQD6wLj60Qie7
	/S4KPRTH3e4TnZFMEPvGR+fs3WX0w8g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lTx1M50y;
	spf=pass (imf27.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3964e76d0f4so3928089a91.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788193490; x=1788798290; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4wASPUEGd3KOv6Fdubi246q8cZj4P8D3ytyUATn9DWg=;
        b=lTx1M50yL/3XMBm4BU50gJL7lZqBx7a432KzxF+9W4Yk07boVx4iG1DtYEkmRaWx0I
         Z3k7zrS3F8tNfAHNzmj0sCZIbXLfx4LmGWKarEr4x3rn7ktOBa2bTu2uoBW0sY/SwdEl
         FqAFVZiaeuDbXvztVnkGQ/dWiq1x/yAwOXR9bKDJqYzBGad/S9CJS0yejl+x3iTe4vGs
         sK2m+UFlBlYc5aSkSYsWlWLs+GVvziZzUslklhAN9kWs+XVBI84eCq3GvPVEHWB/774X
         cCTGlNm3PFAsUvYUlYDBd51IJs+ir/2zP4WnqHlElOrQvMcGE5oDCYtDcozQP0tul7Cw
         KpJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788193490; x=1788798290;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4wASPUEGd3KOv6Fdubi246q8cZj4P8D3ytyUATn9DWg=;
        b=iENOJyQOL1l5iQsR/loF2ZY6qftVTljaqS3xvuy292mduMHuWfWhQfx8zQvuN0Qa8i
         wWm6twX02WdLNHo5WoFyPuWoZzZpN936nnpSng/ao8eQ/r6pBUqYDeMe8Fn+M5HuF2Zf
         BIs23oILlRY/dFEmShq4whyAbYUOPLNxCvUbBpyzXQJW1mBGMVSF+Dpz1XgryJaB3bm2
         N3lK4NF/HVbiLpkQuuJ+h194rrMibjQBM+Svm8ubD0CtT5A4atm3Xloj+efC63yFDzeX
         YaDfKZZs5ffc2t/QtvdQa1+5M1UOpqYhr0oXm7WbEIGnxajugyP9HmzK3zTWMrCb+ru1
         z5ig==
X-Forwarded-Encrypted: i=1; AKwUvBzfjlAJpV+QpwBJYpgTZ/t7BNGxrCaOKCI+biHGGaQZly6nxxoo56SlNvSm5p/nja0kNG30iRZGPw==@kvack.org
X-Gm-Message-State: AFuF++knDLvkQkQ4uOpPBSqmtY0cM2v3TQjHyurQ/RSQzNa6lUksVbfR
	9IKXuYdxIbd3wh+qz+hx/BCXCjZTJxDmtrSNvD315y4mvfI22Y77B/DU
X-Gm-Gg: AYBFou0bgZFY3ohVE8aZN21WhDrbrH2HavTHIvk1jYRC+mv0xiZzQrIyCY03gxS1xUP
	rc8p+kYsC9H2pF5BV6df3lM9zXJBdSWUQ2ZCAFH0aDLjgtACcadG9zoI32E2BykTzRJeyyYLLoK
	kUVciuZDx2p2iA0Jn4NTZpV6PK9OSb812A1M+y2azzB+XBuy9MPnFAubg1HKeJluXATwQxxLy8W
	+b+rxpp51bLwKqx7LZVHf4aVNLyRxkbwxwvrS7jrcXcK5nl9HemwmIOyZ/VkqPhkW2tawXEobwH
	jT+chWWxksbeDrezjRJENU9rmmrZhrmwPeme4E5Zeg4MjOSWtKD4hTNb4lZqliMxTcJov/F0cXM
	YifKSGDsD/ZjW6UrGC2dAZNTduwiRuJqKED54BrOwnMYF8Bo9yqj7mOcEwSlcHmUV/246YQA99B
	rZJGOi1AKbE9bQWLoYg6hFVQXfRMD9v3rcW375U2ACrEwoGacBOjGWw94QvtL9bB8IDAAsBk9Mn
	EAK6kfh
X-Received: by 2002:a17:90a:e185:b0:37f:eafd:3505 with SMTP id 98e67ed59e1d1-396d0ecbdb9mr45635347a91.6.1788193490095;
        Mon, 31 Aug 2026 09:24:50 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:21dc:72d0:a033:17f7:ad44:4f35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990c40d0c9sm311768a91.7.2026.08.31.09.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:24:49 -0700 (PDT)
From: ThangNN99 <ngocthang2710.1999@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	ThangNN99 <ngocthang2710.1999@gmail.com>
Subject: Re: [PATCH] mm/slab: disallow kfree_rcu_sheaf() on PREEMPT_RT again
Date: Mon, 31 Aug 2026 23:24:42 +0700
Message-ID: <20260831162442.8176-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
References: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6642A4000C
X-Stat-Signature: s6dbuuimbunnojmmtq5aqgfuk5nw8xnx
X-HE-Tag: 1788193491-389846
X-HE-Meta: U2FsdGVkX1+VGcEmVinkwpPDDMRymofM6jWiLYMTHBFQuuIJPbJK14Hdc6BMt4NUvFd6n1bLxvgeqhU0omRI7455rkNp0zWq4ZjZ9+H9v85yKq69l2rt8mg4/HgWcFqeqQh4iPsripE0KCby2vPr+TtxTpWQFiyUpEvBLytzSo5otiybGWUXc5iN6U6Rv3ARFZFKlKZEnRC/DMBKuy/9itn34G0YbMyxy1Bf4Blgayv1O1B0QuUUhgWo0vizPriELkYomhjCP5dJaTymnAj+mBqk7vo39jANb7wQOXkbFYg5Fi/kU9/L6syJ+QIf/sQ3JKJbm4felw2/yUuIaM0yON5lASKvUbC0E/QfSgM0cRrCTs5jQDWJkiQCsacC8YhlQf7YkPWpXSAPGMrpYdalTzyCLW1D5TzwbphNr6ZblefI6cS7SWoCR8RGuBaYOb2TqtUX91nDxgqMgDyB2kprAOluuFFeGuPNvy0zxWiRhNh+Bq2LipYCh8JFFWFeLkbvMyEtwmvC2BzeqP2dFxMZAQGMOQ9gURGgZSgojlwIcnREhfPbak/umLhSxYm6h4MTAZjfV1NL2fBCyt+mvFVZQqv/uwbo/S/XA9eKULUWQYHM/zH603FiuKkb5evCuvaZbXeLErePX1J/m3CxYcR58TslHhcZU4aDJaYMfNP1qMoa2LM3IZOOY2jBA47bU0uEARxG3HcanTy0foD08Bthliz7rvvtLiJHtuGzT7QlPpv40oipihziFurwEeWzgPnitxIgbg8amM3BSWW9ipYqO3TU981qx/hIZSl/IRjXtz3bZ6tm+2T7nZzlnMnmnSkP7xT0fnAlKi44IHcSL7qaN4DXqYqbPakHME/NyY9AVN36YbiAIVg3ZQ7fiCR0Z6EtiNxmHE503PB8JXRd6m6t8yDAmemXH/bsmWPkEDyJaVFYiGw6x1k/nLTVGEKZGtjT1CMCWcDcEPx38KZHeh8
 2wA4iqiU
 y9p12BqB6ckglXUmJDYimN842zUI79tcXMj5GMbrQyXTlHwookjRye0CTh5kdLtE8hvbqKWVN1KQjCCEyz7DmyNvcFRd3md87/aWrwSoZTATeLcG03sCGFFI7X4+GRNDvz20J79zIE0Jcd55RKNvMo3wCSo6DFUJGtk64i2UFmxgpDq4bqTUnXFvPk9Li2+YzEdbiDRzuemOa9QExN9R+hk2Btea7LohbChJ3PKsRCAqOb3I3Qd6GxnMifYyos0pi7mAap7/+siCOga8QQ7j7gOo090Uf/uSvALO0DIgN/mi2xXV/2O2E/ZW9YD3Km4uf/JCtUFvCoj+GXDMVK91rBU971XDaC70WDABW1W+3gSFmvgBmd9e88wk3buopwR/CCYKYVY98yrMJR5ms+10rMxFvR8FDGvan9xNFcropbFSmdS9pVLSEcW8Gk0WJLnLih4qR74owkJx9nmHKeBFnmodBC7arl5x02Q7m0CyBW+xe2Q7T8c+T2LfAhZZMB9znKGZ9TNDNnBBEZXKfyf5I+dnJRCVKA+Bm6tDqRtF4N9pEKl0i14+46RqYfJQ6e+hfmFJcWYgQN+KVPEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Vlastimil, this matches what I found and is functionally the
same fix I had in my v3. I built this exact logic (skip
kfree_rcu_sheaf() under CONFIG_PREEMPT_RT in kvfree_call_rcu(), same
dead-code removal in kfree_rcu_sheaf()) against commit 08dbfad3f504
with the syzbot .config and reproduced the original splat with
syzbot's C repro (writing "off" to
/sys/devices/system/cpu/smt/control to trigger the
__balance_push_cpu_stop -> select_fallback_rq ->
cpuset_cpus_allowed_fallback -> set_cpus_allowed_force ->
kvfree_call_rcu chain) — confirmed the exact same lockdep report as
syzbot, then rebuilt with the fix and confirmed the splat no longer
appears while the same code path still executes.

Feel free to add:

Tested-by: ThangNN99 <ngocthang2710.1999@gmail.com>

Thanks for picking this up and for the pi_lock/waitlock explanation,
that's a much more precise description than what I had.

ThangNN99

