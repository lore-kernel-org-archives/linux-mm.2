Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 779C1EE642F
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 12:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4B56B0089; Wed, 31 Dec 2025 07:21:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84F96B008A; Wed, 31 Dec 2025 07:21:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B326B008C; Wed, 31 Dec 2025 07:21:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BAA976B0089
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:21:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7028A160C3F
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:21:26 +0000 (UTC)
X-FDA: 84279676572.19.1C1128F
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8858A80003
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 12:21:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WjPNzhBO;
	spf=pass (imf02.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767183684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1zQ6x4JBvnjcii6rxQIcqW7gW9Zy85sg7DcmNPmmRU=;
	b=7VDeAxXZAKexyrUzi68P0YNG1XWquBaXPcTg9aX2votsXK6HiJE7GCXDNJeGyPzazaw1is
	2Gu5GPfcoYGdTvXzmJy8Kjfwuknm+ZGtmdl0m97RNyH0usFgVBcpKA+SzAL/X3P/t4S+dv
	tlthdzMWZSxXOpPs6HRkv1s67BOS80Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WjPNzhBO;
	spf=pass (imf02.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767183684; a=rsa-sha256;
	cv=none;
	b=FuI935fOJ8Fs/yloUlcQ1XAOdq7TJYDbm2n4RHvXtCRYKCJJidknK0V+4e4WKt6l1Plbry
	JKLlwF39JaLDcKGnTxu5GHbm1rwQrFTgR67grakwpq3j44c6Qc82YXeOM1/uVfgJ75ASM9
	bdP6cLcpbfsl0dNbMyS1MBkEN4GJQxY=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0d0788adaso97123205ad.3
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767183683; x=1767788483; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l1zQ6x4JBvnjcii6rxQIcqW7gW9Zy85sg7DcmNPmmRU=;
        b=WjPNzhBOTrDa5/g2zql5GX1sSHagIEObriHVpxYdAQmZliAtKJTX7rvXCuE4rsWB7Z
         +GLHoSbpT6EhmRTx9LgP1zLT5+WcoC7G9wkIECNXEgkcqMrVOtgfjNuMscx4+emxNEFx
         EVC/bYckbUGEoZKaMT/KAsQi1KEc6WKuoKfbk+W8YfWQj8FOrz4A5oqoAr8gkh+WoTaD
         IqtiQCqcfKXbfaJqNMRFVvJJCAogn+q3omRCVlaeJvJjZZ2z8ch8r30825fK3RVivb2r
         IinVQzL8zwoDXIhxvec/m02qhvBzdqnq1rjqx/g/k2NSoWwwVX+cfBBl3m3Z0XRp9uUI
         IEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767183683; x=1767788483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l1zQ6x4JBvnjcii6rxQIcqW7gW9Zy85sg7DcmNPmmRU=;
        b=Kg6coYoYVJ0rO9GkXHiMXrZbDMEY90J7iseMwBgrmy0HQEbHoLMyzQ2qQKKrOLiAuE
         di/A2FVStc7v5E6G2WLzHG3GFGHrAPoN5AT6zciV/x2i1xhCh27QJu/mJnfCKwYE7LLF
         1yOUyNSuLwbT5BbHhYAWgwRZwKuXa92NmaRlIbSc+yOTV1gOxVPzEW7xY+VdST0lrQd7
         Avx1cG23lgohgO/q65CqF3/+XqrwOTGczsSVR1nEEoIuzqcqPGzExEBLMJXQhDMDCEic
         CWIJpCxZZNU2SqKqQROIUTHIENLR5Exh7gvF5m6EtOU+4tbb/9+JJF88U/LbQAF+cCsh
         T4kw==
X-Forwarded-Encrypted: i=1; AJvYcCWa1O+RCwTYA0hvm+4S1PA6JdXeog5RVf7axZYjIkxiZkJUiEEpeyj1YaZJ9XdRSpXvkg+ne6Jw1A==@kvack.org
X-Gm-Message-State: AOJu0YxYoc8PHtFI5SHQnGeEvbP1dmJj2wwNH+yLXNhJiCUpjDowvLOu
	fXTh1jjqTZGhCYc8+pEcwOP2H66NpeV20IciCH5bmPycdj85H0zn7qh0Tx7FFU/zJm0=
X-Gm-Gg: AY/fxX6bU9Qv5aL0vC+BY9XLFF9Arq6/aF2FtyiaYY1q1AL7krOAwzkIlTx2KzmDDNa
	IMCrr2v0UuL/ul6/f/M2TR9vq8YKz5hD7vuiF/NFL+Uj+vI/r/VgfyXcCWH2skpLAZG4DS1o8m5
	s6TSHBlUEVcmwTodoiPQs9n7xy76is+9QrRa9j3gjm8jaAEFFUKhYBodVQ1igNzNKCJ/1xzLldw
	XVi58YkFz3nu889fEnXtnfqbgL9C6yCRDVNUCPNerEEcMsR8TYl5KgJ1HxCsXljSrag1BDvXcil
	dQNfsC9CRBpQgfwd7Gbd3YukgfdFD3FW14mXIMq/9PeNNDVnPcX96STpVdVXC6u4NVupndVvrEu
	Dn31NwHUnH/lkMi4mYOK3hKbcEGkABkicHhWSMwTwz3HIwTXi8wRx/hmj23JIMnS+0pqb0d5X8s
	b3c5/3/KA=
X-Google-Smtp-Source: AGHT+IG3HnaH+f6fsjU47HQdlXrZ7oQYX/xrU6Ub7MM9YQXarksQ4+8UuW9vEeF2U1f5e5gUpCwR+Q==
X-Received: by 2002:a17:902:d54b:b0:2a2:d2e8:9f25 with SMTP id d9443c01a7336-2a2f28368eamr365848575ad.33.1767183683334;
        Wed, 31 Dec 2025 04:21:23 -0800 (PST)
Received: from ubuntu.. ([103.163.65.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70dccd14sm35760786a91.16.2025.12.31.04.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 04:21:23 -0800 (PST)
From: Dipendra Khadka <kdipendra88@gmail.com>
To: akpm@linux-foundation.org
Cc: kdipendra88@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	rientjes@google.com,
	shakeel.butt@linux.dev
Subject: Re: [PATCH] mm/oom_kill: Remove unnecessary integer promotion in format string
Date: Wed, 31 Dec 2025 12:21:17 +0000
Message-ID: <20251231122117.7683-1-kdipendra88@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251230123336.ef33f8a55df71f3e3f782532@linux-foundation.org>
References: <20251230123336.ef33f8a55df71f3e3f782532@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: q9farj5pgcranurm5c37dh6szjw7ftm8
X-Rspam-User: 
X-Rspamd-Queue-Id: 8858A80003
X-HE-Tag: 1767183684-24082
X-HE-Meta: U2FsdGVkX1+fPLqe093xtSHHDDhfWJOKpY+cSPhcwaXl63cCNK6bNcmGT/vEZo4XgSbJT69mk52uWXIEK2Gc+FNgb1xhmEFYFpnHXEMcJiqVJdwrfPsajd8yB+k0EiVRHrxmBmZUqr9fpJqjvDLHzUdQJ7su2fGuC1Qb8YVkV5+skPMX3R/lPa0hhoNGWUSRSd7Tep2cYPTL7FlFbqwD/CbR2x+z0U2Pklw8i+pUaW2KqtJ+8AqXMy8uOBm/611eK7Bq4litON5frzDZOpoEE2WV1cSdeWfvhgGsAwT4fjCEJi60etlYw/kUqnl4pfesNyy2p4HYrZEpt4YxdmCfEJZvsR57exzW94pkFmOxhLkSIIHVwbBVL1yXYnwaYdqkB9LEZ/gAqi675uOGjFslZwt50j4MnRcCfn7RcTGm1ObAxrNrgy0JnJcxeQUvQerGbZQh3YkyrWurPEX3qs3DnbXeBhJj8NOGpy0cfm2Wt1Wuvj/0dTGfbcLFs8AS0igFNkeZGhZX8R46HDNSJetxHo4JOxZ8iEMDIEIqHwZKKW7lYR2z5oweHtKamKO9vHz7nBY3Ccu+cJxcL+G8NbZJj4z+GpOq9foZorCdzLmM7sIs90Quw33Co+WC/wK3yubQMpE8vstmsGr7Dm0X31+x1oCWY9U6t83gOya280Mq4b/o3IXezQBbkzN6Muc4YNsIOYxRTQKAa9BzTGBIOvcypvxvi5DTxDH8Bj7Eq423gePZcuS0dxfMjLmvz3gp/ZMUI2k0tfG/Nf9BHprrmXGdCRA/UksXeIhJJlmriAuZ0HwLI8BCANRmdrMSjX184x4jfsKv+zjTvPTxDeSIAssgv9vxLK4vfdtI/x+TUV4nYEShuJ2msFJ0GS9cdV1NYelIcgJQYzSDzTDSuJkTggslrBS9/RAXSvOlHBb2DonpItiCe41AYWzVb0giV491LEYuINFzvfo99dsuaC9tHPN
 0tKbNCKU
 waAXS1LNyw7++Shzn+zWD4gTOW/r5bBP5E1DVeEXtMPkHxh96Tu0kjUdul/AKyAjgg4rptiqH485VVvwLtukQDDfQYfVI0CC6V7wl7ZCkT+j/ZpwYQ2PPkG+ZV71jhJyGVo1qSVio13UCNOC803TlCcS0awEVkFDJNk1DfsxRvGzTegJrML1aJvQzBG00KQCHUCkRriIisCzLHN6EgjlGARXybzV1VZQ+g9iQaGAHj2dkQ8H3gizNv3SoYCSD+TWKbrnDToeoBFWL4QqSa0fkUe7Y4MP1mQqQZ1NpF7guakGtHXZmKh/snpM7WKT1EMfQIOP18WsZZNmCZnWcxR7ECRTcOjG8kXlvZIrGm8sjtXEI1RkvsiDQy0dHW6nnw8YyA+hJzECB440o03dQW9R56eNhMOWEyIISQvlxdmxmG5zErQAKJt4gWJIGv4SVmAiP8VyizeQQveBtI3Gc58Q7sf/w37gtFe8E10OXik/CybIZlKppDQOTTTPS134a5kJktpv+iw1+Lrigc9icRug6MHvbVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>It's a teeny issue but I do like the present code - be very explicit
>and careful about the types we're dealing with, don't rely on unobvious
>C rules.

Actually, the scenario here is that while printing a short, it is 
**promoted** to int due to C's variadic argument promotion rules.

Yes, we must use %hd when the **semantic type** is short. However, 
due to integer promotion, the value is already passed as a 4-byte int 
on the stack. The %hd format specifier then casts it back to short 
for display.

Since the value is already promoted to int internally, using %d is 
simpler and avoids the unnecessary cast. The checkpatch warning 
confirms this:

```
WARNING: Integer promotion: Using 'h' in '%hd' is unnecessary
#461: FILE: mm/oom_kill.c:461:
+	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\n",
+		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
+			current->signal->oom_score_adj);


WARNING: Integer promotion: Using 'h' in '%hd' is unnecessary
#961: FILE: mm/oom_kill.c:961:
+	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
+		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
+		K(get_mm_counter(mm, MM_ANONPAGES)),
+		K(get_mm_counter(mm, MM_FILEPAGES)),
+		K(get_mm_counter(mm, MM_SHMEMPAGES)),
+		from_kuid(&init_user_ns, task_uid(victim)),
+		mm_pgtables_bytes(mm) >> 10, victim->signal->oom_score_adj);
```

Checkpatch flags the 'h' modifier as unnecessary for this reason, 
and many other subsystems have moved to using %d for promoted types. 
Hence, I think this patch aligns with kernel coding practices.

Best Rgards,
Dipendra Khadka


