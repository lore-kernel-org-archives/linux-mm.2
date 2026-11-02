Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C183760A260E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FRuYrE/7
Received: by kanga.kvack.org (Postfix)
	id DAAD96B05B2; Mon,  2 Nov 2026 06:40:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34976B05B3; Mon,  2 Nov 2026 06:40:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBAD6B05B6; Mon,  2 Nov 2026 06:40:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 917B66B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:40:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 300171C444D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:40:39 +0000 (UTC)
X-FDA: 85389986598.12.1B1569C
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5D8FB100006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:40:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="FRuYrE/7";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793619637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5smmWE+vGhxqhwgGmPR4F8hVHSCwizeNx+PLtfEMP9Q=;
	b=7XjruteXMJOmUIzSWUTzIdV2BkUEhAjvt7D+7wo8qG35Zm7k0/LZEEqcnK/Gz/IEUcc2qY
	es9fFNgi6aImT9278ggUGocplST4YbJrkHvIV5XWafwYqpUq1l4gdBqPPIk8Jw6q2lTIGe
	9m+xSYTA9vF6FEg8MVSO1QPDshSkDa0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="FRuYrE/7";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793619637;
	b=zJcPYq6aIcPQOgpI/2S4xWQg2Za96TYinEAgNdppsSANsS7i5fSLP9CNyHwKWRkdBG8ORj
	0Jg+0NR8K+bMAgSc5GY66skUf67dOL+u/i/ZGUMdlxPIkQzk+Lts6kmjXsrSOzb3uk+Hwu
	EGdYJp/jXYGqCNZpUOB9xbnk0yyugbk=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2eb0f1b592bso9386295ad.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 03:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793619636; x=1794224436; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5smmWE+vGhxqhwgGmPR4F8hVHSCwizeNx+PLtfEMP9Q=;
        b=FRuYrE/7Do93fQimBcfqVbk74S2bK3s0E/AxnChmHlSOj85XfxhLs3pP0mEljbYLug
         sh6X/XmJ1yguA6kSgMLnirVmnaSFfpjSUVCE6wb/hKoUbbzcRDy644YGSEDVafWVKee2
         +nUTy3DOjjptOP0XMoWtcVXz449OIWz9j2tdeQwxhAtSpzoG5ZuUj+qIf11wkjATSFVv
         WkSZe+6W/8hYwO7ZY6Rn8x99NcZ1Tf3GreRJmuXT0HPPZRjlYXHGySB/DMqSugKlIAKz
         smMyDZxq2VbGELHUi5b2W2Avk2sn7uA3gTehK44IxBkA4DZDzba7j6GDGSYWoH3CJqWd
         /WRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793619636; x=1794224436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5smmWE+vGhxqhwgGmPR4F8hVHSCwizeNx+PLtfEMP9Q=;
        b=ZTNLy7qxVWAVuhicAWoJJfa/yFXqN/yAvWCGnt7GL3/h6sT3lxFvD2zQrFs2FCdGyP
         IX9N5mBEdm9Fgigd2tKVC/klwv8K31PCLDo+JDP+kHzPs6vO5iadmv8ZLseW2obG/b+s
         /RMh5RfpHL4ahlpzn2rsI5dB0AJ4jKA0RXJtb2UYVwEuAtisXWKgobP4muB0BYE3Kq+7
         MMX2qYPClEQAnLYSbrcdq6QWIgRjrmy45DjLntgM4d6b6ykZ88GKfJsnfqQDmL8Qd9mE
         Nf5NDcpIXMr1L+96BkFz6+dMaopoQI160nRKdTpjeWW2cQ7Ynr6ysIbvcqulNsI+Uexq
         3z+w==
X-Forwarded-Encrypted: i=1; AKwUvBxpyC6WGFyXNPdMXlWF0pEevSxGxAI+TN8/HDVsv+ncV1R6a3VEe+dIVVlz0QTifqvnL7RAtlsQXg==@kvack.org
X-Gm-Message-State: APuU4Z/4gYPgDCcCgbvoWcvO/3wpkPquJpiPzPvR5BFu3Q+2f/g00K/M
	K03yGdOWoYYSYJmPkLmG/d0vzg0ZS51K7gjmhWj6LPPoFsVLDeIbsHyl
X-Gm-Gg: AYBFou2baNAGXgUocx/fz8tZUcZMEFBLSXjohrLb7uGQF/3E3SJ3co1Sfkx8BgrRJdK
	+L1rAux0D8JMo8r1Vgxs0cMuAPeXem+dyMd04d+0nYjIxyxs9N17ubgTirUc9dS7PC1BFTjFu/E
	MipnAviW+O7QzFBu64QpCPE3E0NTAWehPqHeyAPM0AX9+jRq54iENzJ1FTTZlmRK+Uck6zvqLJZ
	kPL96KwTHV4EKKQTMqMqkyhLJfRmJnMndHPR4M8c0lZR4IW9gHt0K76nP/4g6K1IAV3vZMDHDbv
	x/hvNC9etWQ4q6386oGcVBkrxTsyH4+I6fHPhMAa1UyODLfuAzXZNcIRsKJdaW183SxvDvAVhDq
	4S4tmBXQO2mg8debzJs03qH4AYbaAWIKpeSFhH615cEl7CztSAkgQP/Rctk2Sk2pHg1yMkIlvnz
	ImnXflwgGKVeMwpPeRlqlQPLb45WBXaxvAkmDp2yFRxZdDehvn5gfJSRCYw3sGVdATZEQ7EIKuZ
	2yuCdA6cwQxQ2MLvGQRQZjJuiMyYOrpuHP5kxfTXi4iYN4ap+AAUg593aK+KXO0E7DNFwzTzUyH
	uHIxWVX8Kb7Q12WPQypYT0bMGZ/TS6b1t0VupClxR3LiicZ5py4wNCbTGN8v9JW3ygYb
X-Received: by 2002:a17:902:f607:b0:2e9:a090:dd69 with SMTP id d9443c01a7336-2eb3646e967mr97761995ad.39.1793619636155;
        Mon, 02 Nov 2026 03:40:36 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb39262c47sm26652745ad.38.2026.11.02.03.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 03:40:35 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: mhocko@suse.com
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp,
	tj@kernel.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Mon,  2 Nov 2026 19:40:29 +0800
Message-ID: <20261102114029.1259655-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <auhiGqKJeukk7t3P@tiehlicka>
References: <auhiGqKJeukk7t3P@tiehlicka>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5D8FB100006
X-Stat-Signature: mcc9e1fzcaj8f5eragbq566gje37ru7y
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793619637-630085
X-HE-Meta: U2FsdGVkX1+OyKZUDUEw/Tc6bgWuOCC/LJvBUqj0Sejrl/TBl3hffYYYlGkCcu0LLFs3OquNFKGJKIAnkImXSbcvJS1oGvhdYvWOr5AsS+5VDUIacyqLak6JzuKmP4+PFv2teuxzWGMTO3K5MMfj4keTYVgE/dcRSw30HneVLo1bQxbYiMzO6COgngVDZKdKVX/7rj5KXaSEPg6B9vG510UEjZP9V4DbsYKgL7oHgKKbL/HwjOxHp7jQSkLklzJ1N3v7AwUbRikIZJ09ONIjFGHS0+fMcy2jbq1cpfeEjItGSg4VPrIvhenxSpw7xmPx5hnhdBmQwLhuh8H90FpntGW2+2z7Sil89iaqUDN597dUob6wmIsN88gOp3CJnyWeS3+s3H38/RRp85f/OXDFr5u3FFP5ciuVQgTC5sm9vb+mt5Lbup0C/c69RgQeYtQgGxPzCWr8fhFuGRXeDE1bqdAcOm5206mIj1d50xXFbw5G9DZSqplgZxTIY8FayATDa7Fr6pH/wDs+jTGe3AlMk+ajWF2fsZ17c7XytYqWId/vSi8ZJvo2WiZLiPDixPhu86Z0+TffsQXAw0ht3Mt4CWMHUSodB/rklMNASK86sK479/A7gaxay+uHkBkOCp1hZGrd0ngn1mzoxQBkGogWR3QzHX9WfqeEDCPktdDrDCdRH95jjAzE6hUqD1aPxdxFx3+4iqwaP7ajYk2kvLGQRE+MIYlYixX0OOgiOCkQ3YMab6d3RdSThz12U9FDJI0CO3iqW1AVm+WVeuIPfzBnNXI5Da/1YTcO0HYGoQqA8xVcVziRH9fkJtEODSnx9MDoGsuNnBy3lAt7gBZGZm1ieNJXjn6hiPFHsX8wuEBcd7Ug/ikifxHCGp4SBxZSyjK3Wv0/tTUiN9/V0y0ZgYsLGOQ76zJhpGZjz9z95Wlbm9J2d+zlbN2pOTSt/LeGoiTw/8vvydKB1ZhJDriaUxZ
 BYD0ZH2+
 hX/pHCyAXeG/0BeUgLizS++xK2jTpnElXrkgNxQvvMg8EKZHjpqy/cNCBYDmSaS6y+sMtgulNCLcD4vLQHzJMQDRJNcQ1tZTeyI8oHS1URl3ssKyOXcoXsGqomK2/VtZXNiiuimldLxHdz/ujSDsx112T0P4HBpfADoMgz8C/PN0g3Qc37KgFmr/uwHAwOnNvznVaILs9WbsBK0WdxMIyNWbeAj5qXUuqBJiDXxiQCCH+i/F5hxRukvXKVBEk0b4Ihai1hYaAgMgA3csDHfPGhiP5eaLpdxmf+BTr6KWnFiPLybB29RL2GIV9yxTPi9wV4/QpwU4iwFL78oH1f7cOz9TIfGvKCFXAyVUvrThemcAQdPOVBT/VqdL0DtO0Xj+80gUJ1lBqCZQZ9QNipFyLBjNdsJOHNpgMZbTi9S05ZxjeTVxMx/EYMmbYvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Michal,

This is v1. v2 [1] reworked the check, but your questions apply to
both.

On Mon, Nov 02, 2026 at 11:12:42AM +0100, Michal Hocko wrote:
> Is this a desirable/intended behavior? Shouldn't we move the dead leader
> along with the rest?

Userspace sees it too. After writing the PID of such a process to
dst/cgroup.procs:

  src: cgroup.procs = 85       cgroup.threads = (empty)
  dst: cgroup.procs = (empty)  cgroup.threads = 86 87

Moving the leader would fix that, and memcg would then need no change,
as the PROCS walk already returns a dying leader with live threads.
The catch is that the leader has already gone through
cgroup_task_dead() and is still accounted by controllers: pids, for
one, uncharges it through task_css() when it is reaped, so the move
would also have to transfer its pids charge. Tejun, would that be
acceptable in the core?

> Should CSS_TASK_ITER_PROCS iteration see all processes
> regardless leader being alive after or prior the migration?

With the leader moved, it would. Otherwise PROCS would have to pick a
stand-in thread, which is what this patch does inside memcg.

> Shouldn't this be CSS_TASK_ITER_THREADED instead of 0?

No. Walking a memcg css goes over e_csets[memory], which already
includes the csets of threaded descendants, as memory is not a
threaded controller. THREADED also walks each cset's threaded_csets,
so those would be visited twice. It is meant for walks over
cgrp->self, like cgroup.procs. 0 is also what this function used
before f168a9a54ec3.

[1] https://lore.kernel.org/all/20261027144016.2582880-1-zhanxusheng1024@gmail.com/

Thanks,
Zhan Xusheng

