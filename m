Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A23CC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574226B0088; Tue, 25 Aug 2026 14:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524316B008A; Tue, 25 Aug 2026 14:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413F26B0092; Tue, 25 Aug 2026 14:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 183966B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:39:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89114C0164
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:39:32 +0000 (UTC)
X-FDA: 85140654984.05.5A99466
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9439B20002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:39:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Mzg/XxUU";
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787683170;
	b=BC7VmGeoBI3IeGL3T0oZZ6bZme2VarF2dFzpFToBdoOiZ9NuX1sMuwZBCTINFB+J4T4Afe
	ce4RP/GoEfkZ1f2ek2yOuECaZ4Ekhe9nY9nGgzjSYy19ZOkgbobyAaSx+aCvmPYNCLPRbW
	rFmR1PlM+Qpqk7JUSfzDChMQO9n1f64=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Mzg/XxUU";
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787683170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tT3C8RmqnSUSZm6wZr0ulCb4Q+ThIVoSjKYEyKvDdpQ=;
	b=YFt8fo2j6LgfOcLqdguFiT6whQIMtW+8RinJm4WVC+KLG7dpclfOiznJ7GI5BFmd2VS8Jt
	PSvBUm6M643RDgpqZ7wnu1InISdmoIq1EA66UVTZrHzQRdZD3kA7syTa7Uv9xT8wOmCuQW
	whwnIex8StPNub4RnHMdvK5OCQMhXX4=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-69fec8b4638so2200a12.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787683169; x=1788287969; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tT3C8RmqnSUSZm6wZr0ulCb4Q+ThIVoSjKYEyKvDdpQ=;
        b=Mzg/XxUUZbl0iAANARPgSGGNjcepPZO2gn/tASNCOZ1Ab8yaQ3puG/Gp+OCHghMS2K
         oxdIqrB7dybxIYlbvvze2f6+6XMcrreOEyIQ6SFf6dBaqFCPxfvHlugXn9daeeFms6a8
         Evoy3F9RC0jkbUn/6LRGUXvcJkzv5s/h1iqrEaC7usaj62SpIq2509s4PMJmh+Q8XLuz
         SgQGf9dOy5sIaY4iARCNADXl/HFRKkIy7w+cshEKFhYfEJSxwIfhmzSPIB9VaJttrhm7
         09F4+F87xno7Grfelyv2Y0TMLg/18P2bTfq4vMdnm5HQ8ANXDZin46LomebrPgRlglPk
         wx9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787683169; x=1788287969;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tT3C8RmqnSUSZm6wZr0ulCb4Q+ThIVoSjKYEyKvDdpQ=;
        b=mfqpo9zFSeEJJEx5mpLJU2j4+dP5S0BjBbfTH8ZfCktIKhzhl1kZ75yfTF9wDRdfT3
         xRaXTkT8fSsspVlq6XyEm2qkoRtLC+wRHKKGBRUrFWUgS3EJt7dx4EoyxN5GH7A3k5Y5
         wEWc/5LZMVvU14c04LCZPn9dEbzxEdRUL0YwOs2GZVGFpnRhXLl6KXL4eg73/HbINl7G
         ouhTVJ4zBOWqNcnyHXnFopRaQv2F/0n3MXGbTKDSllDaGbrpQklZeurBHnIDjP5D5wDZ
         KAqwsLL0kjUos2dFsLmMH2ZnhU9QY/9n31ORjea4J2IyzxnfdiyFZtxQ7i0qQd1pDrpE
         RTgw==
X-Forwarded-Encrypted: i=1; AHgh+Rp922h/IR4cddHJWredcPlzu6UdJ1HAa2+QORpiKNOlSfqeK3nSw10mW35Mb3DopXshPF7aPjg8ow==@kvack.org
X-Gm-Message-State: AFuF++naRNjo2M0zXTseBL+8eirCL8+hnjxtTgoKbf+tb3KuUsOIPBne
	PxQsUWhS9GIm5jiJIa9EZjEAFnw2kZIDzNAY5N+vBzIa3uqbSb2jQenJNJPOQ33mGA==
X-Gm-Gg: AR+sD13lsm5MkevIuNf/i6Wh0BU+ovYQyTKMeNrzWiQ9Btaz0MM6F+2SgNk//hCP1lm
	h4le8qPiojIvlqB+ydyaHadueXZvo0+hQDSeJDOi0/57mcrxeUUmuNGr4JWNsaGRJgIipBCSOV8
	5pTTOc6vkRJJZ8GUmWEFUjRDug2eJ5k7XB6GuwKp7gk5jMHKkgWbfbb9D0W78uYDsB27KBB4M9h
	l6mUgd2dpjfAKqrl5zQcqrucKcdrdpqkPtnPOc8/vblnUmh+xE/ive8eTvVXQWOZGXxTPJARZU+
	PeeHpBdCyU7kmIVH1T7DTDU9a2hB+DvqBg6bXCCCT60JqXClXrG+beAmPCJyRq5G4XR0fNywADe
	Z+WYo+5uIqZN8PGacTkScb4VdZ4/teV+Ng1/PwwZz2ZT4jRVYyGVqoh9NpkMlQsa3mC8KJgW7rk
	tq+J3eSMCuUYUsE5WIFAMUEHdkluit7enq3rHVbG1C9X1xdn/QiNH80wtpupmrugqpJyTjoaWfP
	iFh9IzGyHZzy4avGCPh6fIMS57NyX0hOy4O034YUNd8l6Q=
X-Received: by 2002:a05:6402:b18:b0:6a3:f7d8:3ad4 with SMTP id 4fb4d7f45d1cf-6a5dfca7b3amr1462a12.9.1787683168580;
        Tue, 25 Aug 2026 11:39:28 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:980a:b43:2df6:51f2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a5d68f9sm80514866b.1.2026.08.25.11.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 11:39:27 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Subject: [PATCH v2 0/3] proc,security,selinux: let SELinux block FOLL_FORCE
 for /proc/self/mem
Date: Tue, 25 Aug 2026 20:39:16 +0200
Message-Id: <20260825-selinux-pokemem-v2-0-b46bc64916d8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFThjWoC/2WNwQ6CMBAFf4Xs2ZpSW0BO/ofhoGWFVUpJCwRD+
 u9SjCePk8ybt4JHR+ihTFZwOJMn228gDgno9tY3yKjeGAQXGS9SyTx21E8LG+wLDRomZSaUUrm
 WtYRtNTh80LIXr9WX/XR/oh5jJhot+dG69345p9H71Yu/+pwyzs5c1+KkckSuLo21TYdHbQ1UI
 YQPKEUY48EAAAA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787683163; l=2342;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=3my+l3PYWeZMFRCIaaE0JNhFutiymOpmnRDdudUrsB4=;
 b=CzHbK0+zJQEADKtDDA6uH3pn6OIbkz9AIyUC7L2oco+isP3+dILkPd73rgxSL8Zp2Mfh41/xz
 R/eca/Dd4dYAuMNNed8z8xlHOsoo0c0+4YBDeYEufBVe+D9K7QOAEz+
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspam-User: 
X-Stat-Signature: wpmcpn3wyis33mugbdnes5ur9r7gxark
X-Rspamd-Queue-Id: 9439B20002
X-Rspamd-Server: rspam06
X-HE-Tag: 1787683170-566963
X-HE-Meta: U2FsdGVkX19JgnUOPMey+jIgiUpHk/k2t7JACCa4B9h/tsY+HkeqgDaeXgNtRB6gE8pZh+SF9WNnm3UJgusAC0tNFEe01cf9iKZ7saeRz0WQlwd6jM4ajRDdOL+P38vIowRdHcEZ/ywwB6CuqVUtFTUZ/4K11svmBwSJkW+S56P9DRVVVCeVX4bUAg8cAcu9N0HAy7j83zIWCS+Zq7PLYiapf3X7bhMSrYfb/GQ3LrLgmWPk6h+KNfMjdZWkNldMS487L+p83yQQW7tEs/2RMbHBt7L6TVsjlL/rRp3ADW5BSHPyuhdknXZD/r6uOakC2EmL3jmzq8FJhPqwhWKdPy3a0Xkqx65HdcXx72FEbSqPl/NeeS0Pevfls/8EccT3ZFJFAjyKxSQVl1fQ5cj3F0zNMMTQCETd5BeYUjqERyfft/1kN+Q/gw4jBMg989Lk+QlzFyX9YmStTFvjnKLCEUWMM7tFxbHiPGQao/e9CQO5cUkNL3elQjsDplaaQYeX0kaKFm46PQ19qptVyQ8yMO4Op4Ve6LX377xH6FgLp3CwnGVP7pWE9dVC2kUbwAdjJSUQcrOynhCOF9l8VjTkhiYjMWDuL6Tz2bmcgcbuUNB1N04kl7qQXpbtA33sdiLraL1Z7J3JvaHT8YTIWziYLvv0ez5WgEdkzRAHZvsrE6KBm7GmuhxWcSUl6MtWMRg7x9elm32pm6cmlgf+QyvpeXpafeOL+Vtundv5m/n1On1yVla1EKRDiNIHUN5K+dbWnZHF+mKJ/OyJJiatB+lwMFt0m4HqgSsZUC27JAmpu3QIW5VGgfZaVIXvyoKQul0mZxk6NQ8W5u+YK/9bznxs16BIhpYaA63A97CCBl/HH8L+0TdD5jzABdK+2M/5LAxBJ2NXXYoOFJLa+ZDn5VDtEjLT783QQYH41ev5ZwnkLG57+9Q6GowIf7z6vT9lgCy1LPEiPIEt/HOkJ2HzMgO
 dYqe06Ma
 F4RYLLd8xkv3JZOuAS9v8L3g3P/3rlD0cYAjKlH4ZLt2MlSMtNzFqaeVynEUJlMc1lQZRjN+2O6ojnqIPm3UueLFkQF6fCjW7siJ99NGGhKy6ujDPnX1fN83fSCXb90qPIKvm9TjsKT6LbVuh/DWbaPUzki1fvf6Gj3jg9pZHcRCeIG74v5tF8tWPOPherQbztk0uKY3NIXlYDBnzDtwPacpRxMe7far/AYeB5klZGoXB3liHBUD3eBAbv+r4SpQEbELLydZtCBcE3bBOZcFKmD/HCnNbvHv8ejopw+PnGW5Fu43nVoSHc5mbft4fCsQ71zwCqOXiE4hGQyO+hN0oSj/j5yAVCaqokUgnxp2YSb/9Z9ML8NHvvg1yWpf8RoG0RqDEGHh+M8L98iDDZuWq1KBc48knHk5QFNJHg6L9RUQ2j1HItldH6ycbqT/oTnz5W68lkApExk3horPdLhJiLnM0/Z4N5ZxBB+42grpGQUbzbnczeFKjTxkQATpXcceetHFD8NVrY+ChZVY/EfdaIfta4kc7hUsiTiXelzCxv1+l9dfp87Xu8iMWccA7FIRVDHqtiHroyRu54g20z4NzPvSc6zLfvcQqe6ZznqyChXIusJmcsakec6G4lPzXCcXWWLobZ3yGtGBbD+O+FfEiWpaDsDhZNHggt9Q5
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

 fs/proc/base.c                | 38 +++++++++++++++++++++++++++++++++++---
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  6 ++++++
 security/security.c           | 20 ++++++++++++++++++++
 security/selinux/hooks.c      | 22 ++++++++++++++++++++++
 5 files changed, 84 insertions(+), 3 deletions(-)
---
base-commit: 2f1baf1fc8929e6c48370be543ad028ac7ad4131
change-id: 20260814-selinux-pokemem-44625557c4d4

Best regards,
--  
Jann Horn <jannh@google.com>


