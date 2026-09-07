Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E201AC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA5F6B0092; Mon,  7 Sep 2026 17:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892AC6B0093; Mon,  7 Sep 2026 17:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA156B0095; Mon,  7 Sep 2026 17:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 452F56B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:00:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE134C02F2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:00:28 +0000 (UTC)
X-FDA: 85188184536.03.B38FEE3
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id BD04318000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:00:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uXw0Ds5Q;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788814826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=D+b4993ZhKzGPpJvQnPmdXZLIrwAdhGEw0qUUSYMGJs=;
	b=gViB8J9GtniYTaTbcmuHn91XG6kwMe5QDdps/d12iIPhPRTh5+y+0wvK+HQ+NHXomG9FMd
	2MNXfhlPnRgW0umbsgqGTEgxSRpXmy9ytSxmHyMdvjBSUiXeyRRwAxar1ciRGI8LKnf1Zc
	mRuHxTBhNKlIe9UKWbGRYV4Nzsm7h3Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uXw0Ds5Q;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788814826;
	b=RbSrptsxMKg/5wWZ3ldhmJodGsy0tN4bC4qu5/HFPNQK/R85VuD6RICN2mGeXfnYo7d7wr
	4DE34oyuYhz4a41LlJ2g8n95Z933AoYKYyzv1fts+bDlIha3PgPp6x2nZKcKfYvQ+jpg0P
	gJeXLdyAIIZSX3enObrU5KGF73jznBM=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccf3bc34cso83695e9.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 14:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788814825; x=1789419625; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=D+b4993ZhKzGPpJvQnPmdXZLIrwAdhGEw0qUUSYMGJs=;
        b=uXw0Ds5Qju89fnc8Kx4XHkG4OltXztW4/cHKCA6XzjuGUw5zOCoIJEzDR/t8bnWEAT
         ZYoKNYu2z3oIsuDGBLZC0kuagXZnx+M73cysBGWNahMUz5QK7/5DLiYK29AGAF3rYS9i
         zEXqSV9NbP9G37IzLfNayjKULr4yw8chkgyd7J869uOn3jrKdevlJBtEYX72IijgjJZA
         zIO3RzAXTSCg/toFDgYRpBmOVPYsGyx7F/J7DfSzPX0MycYmARZ96Hdc5rO93qucjhH1
         jG2S74NVyPnVLvsHy6u1a7y+8Yz4zPLKJz7q3hSwm4h2J/eOmtDFlg6zqHinTfUbaSFU
         X+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788814825; x=1789419625;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=D+b4993ZhKzGPpJvQnPmdXZLIrwAdhGEw0qUUSYMGJs=;
        b=Zzl1E03GyEW9XNCnp/WR6fw3Jqqti2yPbRJcXYsYcbDWKJkDaph4fOrAptmDlTl4hB
         Ph1lQdFDtu56sElqeE6BEmY8SI3z/BbH4ozWqgTbX7jz99WnjJShJn7e/C+l527BJ3wo
         hqyh9QkXVrcOZ1bizuLF/QigW9gcVDTToDlRTaf2DkRYonNyH28/+hsrUWbgpaRxecug
         KpL5cetRklYl9bi72GXVDUXsGQ+l84qUQe2N2XG6ZRuPeBztWjUPpb6eqVIYDG2utG9/
         9cl1gH7V9++Dv577tRo9t7MaUgSb/leF5XGgj4tmvxDcTZXCubSM5bUC1RtpTInkpRBO
         /QNw==
X-Forwarded-Encrypted: i=1; AKwUvBzsko76pTjJoejZguTTJxLAzGGb4s+dMfSnS/niYWAqCwhhB2N7CAbZnCBTvep9Gi47OaP+7+dxhA==@kvack.org
X-Gm-Message-State: AFuF++mjKouju4cv7gHLarnfjYrFFdMrPPQKiuwY5vcG/bOympmIZP/K
	ngTG0eAMo3e85fYf2jUn1J45+Cr9TcsXpa22IlX0yaLdm7T0jnRUFfBYl4T2jFQ7lA==
X-Gm-Gg: AYBFou2KQ+kIduBUH0aunbdcBpW7vAXY9SO8rKjNI15Tu2FexbJWbWM2+pmmewnjfOl
	DRRbQcMgR0mgkKTkwusrQCr8gLhKeOFpcN0JPEYxKc+RC40d2tDDMt50dgQqoK8FxinY3s/XN61
	JlShqLf3+PLLMTRBTl7unFX0Is9z1z77olqeJS5KtvPNKYcqc7SSIO5wyz+Fyy3m/J1mzHFsVJ/
	RahMJUnvx+2v3aow5ch0cDMHiZschNCMk03xgQMY66AX5PfV4IU6iUDye9rGSzDI/4hkw1XL8IF
	sS1++AlX6yyJ9M8fEykwZKz5uuCA+vRzLMPxYc88cDyARHwvacaM5zFYbGNkF8yNZGC6vcJNFld
	ihfsuwM0dfVZxqLZ3JPDaLBulQe78acWClbKv9pxz7xW1I8+FT/az+On1LQpm5WRjf2fA+hyrQt
	isR1eef0suCR3I87KlnpHOFOsjw5bKPZSeVePy8KOirVTY2hVPcZYoSd7momu4iCdqmBGFRIPD8
	GfztJXYRqU0uxzJEVqX2Rm5c8vkyEd6YfnpPfd20YWLSGpR
X-Received: by 2002:a05:600c:4907:b0:499:c3da:6f40 with SMTP id 5b1f17b1804b1-49d010d5333mr1538805e9.4.1788814824871;
        Mon, 07 Sep 2026 14:00:24 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:437c:9ac6:4a41:e58b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883c81c3sm31385050f8f.26.2026.09.07.14.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 14:00:23 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Subject: [PATCH v3 0/3] proc,security,selinux: let SELinux block FOLL_FORCE
 for /proc/self/mem
Date: Mon, 07 Sep 2026 23:00:15 +0200
Message-Id: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN8ln2oC/2XN0Q6CIBTG8VdxXEdDBNSueo/WRcJJKRUHymzOd
 w9sbTUv/9t3fmdBDqwGh07Jgix47bTpQ2SHBMnm1teAtQqNKKGCFCnDDlrdTzMezBM66DBjgnL
 Oc8kUQ+FqsHDX8yZerp92U/UAOUYmLhrtRmNf20ufxt1XL3a6TzHBJZGKZjwHIPxcG1O3cJSmQ
 5H39AegfA/QAFRMVFKwMhWq+APWdX0D0PGq6AIBAAA=
X-Change-ID: 20260814-selinux-pokemem-44625557c4d4
To: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jeff Xu <jeffxu@google.com>, 
 =?utf-8?q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
 Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788814820; l=2679;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=/o20sFF/mtTU8L5mYAb/n1KYsEh2ORlv2YG9SP+nOdE=;
 b=ZmXwRrsF/uOMvXyg2m7GmtJZlNUc+YLd2/rhXAsPu69kHUhI7vrs5qtb/BA9P/iraL5bnyjG/
 PNa4GM+tlO1A+/0obRL7/8fzwsyCzvQVSba93+vtc8dnC/hvGRcnTz5
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Stat-Signature: g1sfn59cxea6x1ki8woqxaehpo9jssjs
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BD04318000C
X-Rspam-User: 
X-HE-Tag: 1788814826-749587
X-HE-Meta: U2FsdGVkX1/bBcSDmRuBNmZQi98dGRYgIgcI+CBgxb7PsNOGtQg1ilkU2Ezg78tCwNR5EE/rOdjqWhKgmZsNXfs2xVYSjIIZcSzhL2EHEGpnvoEA+lh3lKE87DLrasu1s3aq+WQaqa4LR24ra5rtkk2/BhK+m0GEmlxGMkDRhlSyhen0Isy8MV9M4zhbb2ZUPnWo4qkuZ+u24aS/DEaEO8MBSWIEt05UHb4i3n0IYSrYAuykFoFTUJngEQ4/yBK2LCLSpQVS5ClG2iHSmsVKtmuNNNkdohWYlprDUnHZZrfJKAPDV9TXDCKpCZcJfszNwTs8sU2aqiTmLgZfk50+wy9t5uVx/dsRegHzsond3ba0VrTLmeVBV4gF5so5SCkDfZeJmOQxhhFxxUJbqnG9yGjuUximTEi9Wu7ASY2lM403JPp0DU7wLvhvVcffKDhNRscrFZDXtPUDwThLvxdLLqgmerIgVVgJXDIh8YKJ01dRjvc07HiOb+bEcuDgmRik+m/+t4Qp8nNV0/IwVFZOdRHJjZu1RHGStSPtXc+ChBJDkoAsex1MiMO4pajp6UV9rFHgkhKErKSkOwkHthe6USy+W57xEvxwVMeqZPKEeZNaURlB5K/NqvQbB52ZqmzIM55Y6EaJWKA0K7f95omwc03hs/WCKVqVQ83Aon4cLbpZbgHAC1vcEILVp+WSdGziSOl3jIJ3MYCU/QzWTKIHaVd2MAEg/okjSfFMfYQzPAyCJuI8BYo6lIsxoaGTt37E8Jr8iJTjd7FKkj/EavFZ0NFaQsLcEMJf7jVG9yRi4243RgMdWYeAZzcwh4/dbSwxUQh5uNE/NiOgc/1QebATllNO1qGj8zlBcwjZ3ayf0ScN6ZlvuiH4wXAphcIMSCOAUH4HjHwjOJIm9lBSxrP5kwxvYqzF1EuAo6ZCPRwh053b6v+cek3jCPQeVr7lIMN8LoiFjUBRyZfANQFUt/0
 4304tasv
 aLM2soaOEli4JQNP417Ot0lj754DonIS8WhALESTI9VjIE5mljtjKqStgF7A/73LSSMoBostuZqu9pP6zBXbA/ij4N7YBDSubW/D84r5qXgGsytwCPLF8k3DYgp/cCmVNfiLI0zdRjfEH4eRUY38BHo+25AZYBAdeF68qvWNe3wuffKJa93ImidTK2n8RhqyVVFVhNhhTZ9R63zVIQOJ849w5Pjr7mVPBhaxS/nie+uFovhPCDV+vrbr6eGLmvXLR39Xk4uYyFYZe31+Iv+qXOTmMxTM3f4bmIf3rRFjfBYpXNUYjE4LoiNUOp+6ciryS6E122D1o347oZ+tw7D2SR5LYXyqTJRyPIyRMyr6Lqwsld/Gzj4LVkjJPAzfrt4nXU01sNqY5HS9ZulSCfzOEd8xJYdHoYAhHEQbIEpKIfVh6y9FwJdNtQpPtPrrTC5sDQY5W/XcMh8hvqujm8wzbh8JKd0GWV7PuVTDSPc8EUlhb9KbY+KfTe14/Z4l4FbLOU/yZsjqqJoM97ElOULOSPx/oyavKIybePqnLWc1WyxmkzUd5a0mQisAozW1l9XPrKjxt+W2rycDKieCds6lUVNUOca8YzS0CkVyifMevJyiGmNFGNB4C+HDf6a2dRQOi5KGCQzq3T+H3gBvV1KhOuM1q+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The goal of this series is to let SELinux prevent the use of FOLL_FORCE
when a process writes into /proc/self/mem and the system is configured
with PROC_MEM_FORCE_ALWAYS (which used to be the default behavior, and
is still used by current Android devices).

Android has SELinux policy that attempts to ensure that only trusted
code can be mapped as executable in several system processes, but this
protection can currently be bypassed by writing into /proc/self/mem.

I wrote this series after discussion with Android security folks about
the state of proc_mem_foll_force() restrictions on Android.

I'm sending this to:

 - maintainers for LSM hooks
 - maintainers for SELinux
 - maintainers for VFS (because I think they generally own procfs?)
 - some MM folks just as FYI since this touches GUP usage
 - the Android folks I talked to about this

I think this should probably go through either the VFS tree or the
LSM tree.

The motivation for this series is that Project Zero managed to write a
remote exploit for Google Pixel partly because of /proc/self/mem, see
<https://projectzero.google/2026/01/pixel-0-click-part-1.html#whats-the-plan-seth-and-jann>.

Signed-off-by: Jann Horn <jannh@google.com>
---
Changes in v3:
- pass opened_by_owner as boolean flag (Christian, Paul)
- call security hook independent of kernel config
- documentation changes (mainly to adjust for changes above or suggested by Paul)
- add acks
- Link to v2: https://patch.msgid.link/20260825-selinux-pokemem-v2-0-b46bc64916d8@google.com

Changes in v2:
- change SELinux hook to only check PROCESS__PTRACE (Stephen Smalley)
- rename ->introspection to ->opened_by_owner (David Hildenbrand)
- rename introspect_mem_foll_force hook to mem_foll_force_opened_by_owner
- improve comments
- add ack/review trailers
- Link to v1: https://patch.msgid.link/20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com

---
Jann Horn (3):
      proc: refactor /proc/$pid/mem to use struct as private_data
      proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
      selinux: require PROCESS__PTRACE for FOLL_FORCE introspection

 fs/proc/base.c                | 43 ++++++++++++++++++++++++++++++++++++++-----
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  7 +++++++
 security/security.c           | 25 +++++++++++++++++++++++++
 security/selinux/hooks.c      | 31 +++++++++++++++++++++++++++++++
 5 files changed, 102 insertions(+), 5 deletions(-)
---
base-commit: 2f1baf1fc8929e6c48370be543ad028ac7ad4131
change-id: 20260814-selinux-pokemem-44625557c4d4

Best regards,
--  
Jann Horn <jannh@google.com>


