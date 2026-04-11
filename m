Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07737F45A13
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 00:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545736B0089; Fri, 10 Apr 2026 20:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5966B008A; Fri, 10 Apr 2026 20:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B436B0092; Fri, 10 Apr 2026 20:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E41C6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:04:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD92B8C16B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:04:57 +0000 (UTC)
X-FDA: 84644329434.09.AB231E6
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id EA6F580002
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:04:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ETlC9l9L;
	spf=pass (imf30.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775865896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSfSExwzC5aExbWCOmuuVkACJaQn7xM5T6CtW6BGQtE=;
	b=LgY7dN+nFYtxBCiuMURDZPptJc7SPDSgKx+vtWPdQgM6AR7TcIzynIZATOxf8S4mlIjGIX
	tBEbsHIZzum8yVgielhyLvY5ynsFE0PiZVfZyGT/udBJdBmXNSEfQbOr8hkoUNyBU7yHbh
	vhSrmvop16AGA3wKbNtlzB76l57TQG4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775865896; a=rsa-sha256;
	cv=none;
	b=b8lpVv4bOCT2ohlZ1+lv47wyL0gaVfNp1HmR/qjrXFG185cTeeQ9fQL2kKtwVMu9NL6FUm
	/NpICUGATobA/KvZOy5UlMId2R9wJoTckRs3ptdibcIltTuEdY/lRUPm3At4ZfyMch6JHn
	AWf4m1aEhh9ueAy2IBc0EwzBfbUHrRw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ETlC9l9L;
	spf=pass (imf30.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c76b95e652bso1107551a12.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775865895; x=1776470695; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XSfSExwzC5aExbWCOmuuVkACJaQn7xM5T6CtW6BGQtE=;
        b=ETlC9l9LasA6bbLlafjaa+XycYCc1Oga+unl+buVtw5IeE+qMR1hY2oUI/nSD7JIyT
         qrx4eal9V8SdvjAfKeF7vRW+QoTqV07onrXxVawDS5SteesnDRWvk49CrdNaL+lvm9lw
         kv0SKk82UpYzrs6DeERbTEax0lYdyP6iBL0LNvsTQHHeqO2AmNAIdxL8KvuZKKOIPE/S
         dCfL6j1AB+vPaK3+yj99tFAHuIXUWolNhXruNbkIEZsl7cF5AseooBMg5/oMiAf8xdDp
         Kt4idMuNjOdNcKErrsbOVmM1ZBzGlpm4OV60hH1Vlh+nqrDf/ob3rptnNJbJTCwsG8AG
         yTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775865895; x=1776470695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XSfSExwzC5aExbWCOmuuVkACJaQn7xM5T6CtW6BGQtE=;
        b=QFMupnpxZ6Hn+M0jOUmHWPlwli+crJ9CHG4F0lANCLYSQYEHlxCtelleMTiccrrXY7
         q81qZKSQyeKmdWqsDXFznyq6JUCBhN8ZEU0sbwGEzZkWvTA1Vyoh2P2RAW2kOJX+FR2c
         2/OSJEKKlSvWs5lG8Ct/ZQP5X9Ri4Q5AFvtT316HiWnTFjCdmdfdjjWlJgyRjoT1863l
         n2SmCJ9Z06xHZekw60yeaiwhW84w+P7KRXOPfZ/TA3VIMx3i9ChOPDX3yESO5xQ2SwJa
         ksHDUy33VQE7HyvMeWUoxveiXC8VD3u5ftFfNxindYv0fcdVMwZKWkXJbPt9wMw619Qo
         bCeA==
X-Forwarded-Encrypted: i=1; AJvYcCWDhFnPgqgLt2B79IcNnGXCNAH0K15SXr5ifnzl6FngIV32H7xuEJzZl68KaTRIflBITE5Ig2iw1Q==@kvack.org
X-Gm-Message-State: AOJu0YxV8456yS+bG83qWfmu++4lwIPH8rTQNPqBg7citZJkkW2OagrR
	8jOuTxbnLE63kxjsz9cnZ9Y84xLBT2pKilneTcgqNbzGDWQaYhocmLnn4312Sg==
X-Gm-Gg: AeBDievy+SI6qEH9prEvQEq6Ui41rGsusHrHz/hcFlfWbJyb8N9FV+AEbj9bM/SvDjA
	okFoG+GbLtkWFEzTWLs1B7fm4p+XtgLrBs6rFXfqNFnflgcc5tHjpMKgltVV3GaT6q6B2agRJvo
	D/UQUaMVcEnazOxCgKvOB07XGzDlt9EmrJlOPkujbAf6zFbDe9QokCY6zJCdYOiS+Rq9aLFqKHx
	hcoCE3fA7uHVpXZLETSApf5DNlFZZl1PGoiFa8sQOvW9mTVHgJ6QEVqIC0Npw4VcOd3TKpa+i/f
	pMVcGu/Sval+DgUm0YevcM2R2iVmfhYbiyiu3cdlk0i1A4ZUilDxULt4LsMVVTsrlEDnwoHgm6W
	KUL3cf7dI+GXdCgCJjlDMfu+fVoGz+JcLHbqaUGeg4Ry9QciFJW3BrT1uf8RfLb7o524umMsd5z
	V7q0//xnjS5Xy6qYQpv47528Yd2aVIz4c9gjK/A7m+jCrsYYro2A==
X-Received: by 2002:a17:903:350b:b0:2b0:5694:7b62 with SMTP id d9443c01a7336-2b2d5a78d4fmr59281715ad.44.1775865894667;
        Fri, 10 Apr 2026 17:04:54 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2001:f40:906:1c06:7a81:226b:e033:d971])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4dd610esm41422265ad.20.2026.04.10.17.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 17:04:54 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Sat, 11 Apr 2026 08:04:58 +0800
Message-ID: <20260411000458.11479-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260410170051.51008-1-sj@kernel.org>
References: <20260410170051.51008-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: fx81mwfhsung5efei3a8egxfwtgnhwyw
X-Rspamd-Queue-Id: EA6F580002
X-Rspam-User: 
X-HE-Tag: 1775865895-733279
X-HE-Meta: U2FsdGVkX18d4SROcqVr8uXxMUzL7RoNQHGEqI9I8KftdE9isF2cPGXhPsiUokkq/7XFvuDLaSClYd8Knf1zl8BYS2iavdV1CiYdMIr0jdqSsxfmMjtzn4LdP20yFfHUfhjngbvKpbxnXnX8TcujNDuPZIUuCQPaWExBQ38LaQ0yOctTmYS9zOmLW2SEQgolvuuRUDhRfybSneQkEk42wefXhC8KVAjggisATSlXcqzmTsmqz16NZY6ePuiuMXzJDA0BtRjAjMbnu5sJrgqqbPhf+oqDNYgp709DK9zGs7s/ckVtKn073EOvp1Z0SPByPoovuZy/11IQs2zKgofT88sJ/SYWZnl9bYE86d6VQsqsLAMxYd3nm5lpdjz7AzL0rhZlvd0bGGETZP+rIW8OOp+A/sVEJaCxkvr/bWc81u4yUZxMo2MVTvN17v1gdVeBKhjkKqPtIeJ4hS0JhiEZERNhSShrokw+gz8iBzZvtwfdPVlCTQlFMyGU8wa6esAs08+kACpoX2yY+5iWs9/eMukMO26mTiGmwiwbL0HBYLf+z/U38oNqfeIkAaSvZj8wPblDsZ96/5HLJh5ocnjJqmlTcbV4dVzD1wVzwna/hbtUTFWwXX3Ra0jWxTMGoVYPZasTOlhMqyZLiijKhwjv+BpXc37SlkLmExq2vpsjSGhdmKyJhwRKUityONapb/t/9iSWXVpCOiwZvmlkCEFpciCRYPz//pvS6ZbygprkOLuv/9FiFBzmRe9BhB1r7M4LZjMiXq94ZtyYWZEHZmHPJ6yHgyuuNY8/S7z2D2HY59IfB10ls86+CX7GtDPpamLSsd57dqUzOFSh5pzyxFStXA2XzFnlx4D3fzCUJxCSebx38Z4OoDY1WEUGt7uH6ji0kLWrLJ2FYIDJ8LGDOgUQtlkWvgwIuliDqcu9B+STMXfcz7n6JuQqkV0/0yiBomsZ5b60O8OPAhYDzMWRGNw
 jJgnDnGb
 wyBSfSGLz6x7TdiDno/+4K2eNdU54MmmkNyWf7SPFXS5SURY30mx5zZjK3BvWcBU/PaGO0tg9/5N0xhSrCCWcXIqS3Kth6CLqyfj6Lrd62YPh0WGOflk6Phy9n0hW5FgiXm2hHQxARNiCGUHe1Y7bKuZpTrnQlRGOvvKNFL15muhZp43VeHfp3i2qLgeFO5rcyH/yISTjeowRdtIqFWXcwLv0pZNIKIgsI9+deffyi425dONgbkanisLnVpAO+GHxRgQ3PpuenHTEN/OyWQphCZI+L80RF2B+5Kn2y0ITtPVs44v0s5DyzcmFETfXyHt+5m43LlvLULOSG5i4V7VgYC21f7nYeGxBp96TsCd7qYZIVzWcP0j/43aGLYRg1fQDfEMVhJgWBOBNr0vCguZ/F8P0zxqDd8/M9KRWWRGGtFuc17uqcuSUIChYsyb3lxuY3tHwUc81K9hw6Yw6A1NVGheADKFn3Y2H613RQCqo12xlskM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 10:00:50 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Sat, 11 Apr 2026 00:46:10 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > On Fri, 10 Apr 2026 06:55:00 -0700 SeongJae Park <sj@kernel.org> wrote:
> > 
> > > On Fri, 10 Apr 2026 17:40:04 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > 
> > > [...]
> > > 
> > > Agreed.  This was unclear to me in previous disucssions, though.  I still agree
> > > it is out of the scope of this patch.  But now I think we need to let users
> > > force-restart.  Adding this to my todo list.
> > 
> > Just to make sure - is this the same issue that my recent RFC patch [1]
> > aims to address? I want to make sure we're not duplicating efforts.
> 
> Hmm, this makes me confused about how we ended up working on this series, then.
> 
> > 
> > I'm still actively working on that patch, and I plan to send the next
> > version next week. I've been holding off because I didn't want to send
> > multiple patches in parallel.
> 
> Ok, seems I dropped a ball.  I was working like AI bot that only works with
> limited and nearly fresh context for each mail that on my inbox.  I will work
> on making another thing for tracking this kind of parallel works with good
> context.  But since I already dropped the ball for this, I'd like to make sure
> we are on the same page.  So I'd suggest below.
> 
> 1. Let's hold this patch series.  Andrew, please don't merge this for now until
>    this discussion is completed.
> 2. Please summarize your parallel works in progress with the context about how
>    you decided to do that in the way, with summaries of our previous
>    discussions.
> 
> Could you please do those, Liew?

TL;DR - There is no dependency between my parallel (2) works. I never
intended to merge these two works into a single series because they
address the problem at different level.

Yes, here is the summary of my parallel works and how I decided to
structure them.

My current parallel works
=========================
Series A - min_region_sz power-of-2 validation (this patch)
- Status: You gave Reviewed-by, asked Andrew to merge.
- Scope: Small, standalone fix for specific issue.
- Dependency: None

Series B - reset parameters (enabled/kdamond_pid) on unexpected
termination (RFC [1])
- Status: Preparing V2.
- Scope: Reset 'enabled' and 'kdamond_pid' when kdamond terminated
  unexpectedly.
- Dependency: None

Summary of Series B
===================
The design evolved through our discussion:
1. Extended 'struct damon_ctx' with 'thread_status' pointers
   - SJ pointed out: "This feels too much extension of core API for a
     problem that can more simply be fixed."

2. Alternative proposals discussed:
   - Option 1: Termination callback in core API (Too heavy for backport)
   - Option 2: Override '.get' operator for parameters (code duplication)
   - Option 3: On-demamd correction in enabled_store() (passive)

3. Final direction comfirmed:
   - SJ suggested: "Can't we catch damon_commit_ctx() failure from the
     calling place?"
   - We agreed: Simple, backportable fix is the priority.
   - Decision: Reset 'enabled' and 'kdamond_pid' immediately when
     damon_commit_ctx() fails, add a fallback in the damon_turn() 'N'
     path.

[1] https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com

Best regards,
Rui Yan

