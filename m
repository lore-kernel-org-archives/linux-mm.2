Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBA90CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD016B008C; Wed,  3 Jun 2026 04:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6DD06B0092; Wed,  3 Jun 2026 04:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5CFB6B0093; Wed,  3 Jun 2026 04:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A25BD6B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:28:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F0A31C1296
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:28:23 +0000 (UTC)
X-FDA: 84837924486.06.6000165
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5F18AC0006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:28:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VB9Mr6Sc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780475301;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbxFhf/whaY2/lpRVxDROPHQUt8kRLkmb/44SJOLV3A=;
	b=xz8qZZ9wEVPwnxKWPwid3pyLwOpujof4OvBWm9IulasgQaH5JwlKp+4/7P2kdtaOfomxKy
	74Vkgd75tXQ1/jp1GCdS/rmtla5GHf0sCLU96Chl0GaoHHClc5dW/tBpYCKvRchk3j9ku+
	96ER7mbU2KFk9lTL3lA1SfkNRwD+Gjc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VB9Mr6Sc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780475301;
	b=W2FDVgrCLxp1cS+x3K9z/ikwK4nP1oEKLGjn6AN0+vFodC3ooeLzus+ARvdiTLKwJH9MCJ
	Eu0DkFVh6qbxMvURRIQ5iI0aPqDS9P3zInhpiyQyBu2gl59vx/kY/ZEYzMEnttfDuKLRh9
	IgaDjP8phrOzwKjsT1r2DDSb5yYPF6Q=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4906869f0cbso119396595e9.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 01:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780475300; x=1781080100; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbxFhf/whaY2/lpRVxDROPHQUt8kRLkmb/44SJOLV3A=;
        b=VB9Mr6ScSyWshzFvoraehkMqguMOI0CBsDwGS18AIdCDvnwrsFLZW06DZJAAn0x2di
         YYLTFymzjI/dPj+pyJM/gnqfvI+/UFjyRr8OageN9tx7e+CZIbeZQJBZgEIFF75m93Op
         ACw9NKNPwuiAmd8h/gc4/StZcOjqLFl83IxFbzy4sJ9224sJ5z1DSImvrXODwqu5hAB7
         zNqI2PrT3YQH6cQn8cD8LGVtma4fIJiatwFOdtKQQeY/+JgqOj/8rPJ5r/Cga6YEyZMj
         ms4emeoUmzAk+Fwj+3plj6010Y33zVG0NqhYbN+vtDVsFK3S4IPT6XZtnpRubCuCslTt
         kR0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780475300; x=1781080100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IbxFhf/whaY2/lpRVxDROPHQUt8kRLkmb/44SJOLV3A=;
        b=OqKPtASZ21feU35HUsYRgvneC5cjDjQ6i2fSTgQY+6UTByjdgByVAleHVZHG1K36fS
         ki96rB2aaseCr4MYVSe4IsX9amyPGQMZMZF/LKaFopFsiuZoCZmD2+8GjDEoUjJFSuu2
         Nau7Q8qGEftnDSlk2cEIUi4Kt8dFDpQBjI0vkUkW5VpYYeRBYbWJjAe2fCB+aLA27AEG
         GkXHylvyjvKIcyqxYLuc+yl0W7aaWnu0mGY5Obm3Tzu14+qCnhjk/HS844CbsDLW4UbK
         BAAleFKGygWvaz4Rx4Pa22ghwKLYzQsHHNphOkbSJcNjuYkzsHIvrQJAslfRPTX620Of
         LVKw==
X-Forwarded-Encrypted: i=1; AFNElJ+Km7TwxDy9f3tOCkSEo7ZA4pdW20yp+PXPeMFH6/yW8DXDBOnbNTQqzAHFELys5Tz5ThyZoeUziw==@kvack.org
X-Gm-Message-State: AOJu0YyaU/PM2VW7MuO6HywA+fNT8ioi5u34EDuiR7+kaEN4S596g4tm
	d7Vogj1ZrRwnPYPGwKOF+Cz1Gjc3WmHWnsb7p2PO+f1My7RGeM6Cmdbd
X-Gm-Gg: Acq92OFrvCoHnmYBywlLpRfky15/1xZ8aejLoj2jN+UI7z+0BvPG5LVpk8DQs/jMkzE
	Myd3EhGd7JAG5Wzo3LC4zHi+3+k66QiKVsxCv+wh6H+cT1J9AC6cE0dBMLQ/f+PZO7IqK/1OdrD
	1+2o4QfTgNOgBIv1wmwTMjBnFG5sabbSuLHS0lTDM0hbGZTAbhA8qLBI/joC9zNjMpDMUmoxGnT
	QRxitEHsbbI0a43RvyRgE7o6Ow3qKMP9iZ0Ab2hOPoJ1XqQLyybnGUzPhZ+Cst/ms/0SufBA7GV
	NeFbEGe6Gh/Rx+ONp/kKQ2EcGRAWn9TnHaxXc+/k55k4JiKTFG53pmxmQRVCmfGx4hUDnTWtksy
	bTCFFNu2N0GyVds0U1lZuQjtNtiz1TIVCOQ/IOQwzpL24N6L+QVqCuj2ZSpuGzKcaimFvKJcnwW
	p5SbvZObxXrHwUpDZUiI1X+S7pQXKB7NWhjk4=
X-Received: by 2002:a05:600c:3b10:b0:490:b1df:de4 with SMTP id 5b1f17b1804b1-490b60eca9fmr32057675e9.22.1780475299613;
        Wed, 03 Jun 2026 01:28:19 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b093:bb00::d167])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f351d69sm9083431f8f.29.2026.06.03.01.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 01:28:19 -0700 (PDT)
From: Alban Crequy <alban.crequy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Alban Crequy <albancrequy@microsoft.com>,
	Peter Xu <peterx@redhat.com>,
	Willy Tarreau <w@1wt.eu>,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org,
	Usama Arif <usama.arif@linux.dev>,
	David Laight <david.laight.linux@gmail.com>,
	Alban Crequy <alban.crequy@gmail.com>
Subject: Re: [PATCH v5 1/2] mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev
Date: Wed,  3 Jun 2026 10:27:07 +0200
Message-ID: <20260603082707.3831525-1-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260602100917.3641359-2-alban.crequy@gmail.com>
References: <20260602100917.3641359-1-alban.crequy@gmail.com> <20260602100917.3641359-2-alban.crequy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: mdgs6xywo4oquphjcicmh48scyu1oqrx
X-Rspamd-Queue-Id: 5F18AC0006
X-HE-Tag: 1780475301-154278
X-HE-Meta: U2FsdGVkX18hb1zbfvVpGTKB3KfVJtCXJSsS2bvpNHvSyq3h46wHbmS08//Nrks+QtDno7cTEZ6r81+8maCZm8IsgrA10Pev3VRkVLyQGaNsva6s4TmgASjw1DGNETPpHHv8s4hsL2Rrsviuacnm7u9mKYYOMwlON3DRFy9qxrm4KS6V/nELmNobY0tZbqwD3BZ23u1cNag4su5XBStPgT5EekDCI0tMlWuc7M9MaVaNkUiIECwc2JYLcKL6FxKup535sv/RFCTPC1sXoFwLi4h+Le4AD9pTIxEvSl6SO/4Maz+q+Rxa0SFVbmQXcNSJbeCB1rzJKlyo9BdoQTqgiOPBWjakNg1863KZk+BMgIbQBpVWoVgXPiLS+y+QQCwayW9FLibHZvWiwSnUDjg7vqtnBcsM9+Pyg1/2HWcUavTVdhp3npRwKVVfmFgx7Kt0udYH5wis4znGhdzFUAhofYFa5aic34CuVznz8AdpMbcO0kffhiuW6zQZpP2ekMpzxo9mdl8LXo5D6ckhbOngD+2D2IqsFAI+ZlTIk2fuP+ioHWWK6vPMUUZa74fdd73gGy+kK8LDdafO4pZJVwR77S42fpzSWOxQtB/2jXxzB1FsTqe4EQS9wsxb9E+YpHqYRraKmObU91ihjlw95Jg0wNjViWKtHndxLnySDKwQsKl/FhKYL10frSscpFFw0LleOEt3Qy4y8xEOCsUVCZDZEx97/ycPCYX3LDIw7W/OEeKzQRWC2RXRXJiWk4XgGWo4SD7EAcCRhKP1Cj/NdOU5xb+6zsKUg0tCp6chuvRI7sYN1KeACi9/GLXse5m12fe0QqXwCO7f8lZQfjVyU+jJHF2Wn9zGaY6kZmMPMUVhUg3P6n8b0+wPakINaDqKa/6OjmEVL19Y9AswTnRVUp0lPdHNtKhC0KNTYI/lsp+dX4bEdD5ZW1N7L4s39HDmMW0MzWJz5Spt/a4egpzips6
 tUmxPOrp
 ZvVanRy8SlElgCzBpLRvP0K0N4W6113y6jHbhxMmAFMPdzc+GIYW0hIN55WoJsAzUVi5A4pcAG0MEn7QTe4Cnro7XKVBABUAoVxBy4ulpH7O0b7hZByYsLhGhJy1/5Ev4uUhWlOYOi2ngaHIo6hzJEvB24OLmvq2XsjmXDohwDFajzFrpE0oRYfKY59IgGjOIN4nw5seqW4Qw2KPrYvkVkmL6u+ps/PSopfUFkibpSSxDhPU+8G6SNyLxtKnzAR/btgVZZiqcRdvFa2hc0EghDlM5/AGkradiQ1yJQAXtrosqVO3rP2oU3PiKZ2zPWumxLgWH1EaaApmvypdvTav3kK0XWCPQab97BMdpuAnIrJoIkbYZHnMP3sgye8sFhYr5nyxE5jWSO5CxBeBE1Ds9V9dYCO/uMPJNXPEN65iUJE7m+7fzOH7PkscoQU+5aeP+U+EFLpiC5l8mkRHyUrO4Me0+HUwT3qAXyLtYFC38elkva6Z96BCtZLUaRGE8TKpV6YnEf3xgfhzRhssApllX2c9DfG04qvNtxz6nlsLsJBT+JndjkkjE/TovKh/P9WA5AuJXGhj+cqR7QYb+dSBNCylhvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko raised a question about pidfd_get_task() and PIDFD_THREAD [1],
so I ran some tests to understand the behavior.
[1] https://sashiko.dev/#/patchset/20260602100917.3641359-1-alban.crequy@gmail.com

pidfd_get_task() always resolves pidfds using PIDTYPE_TGID (kernel/pid.c
line 640), regardless of whether the pidfd was created with PIDFD_THREAD.
This means:

 - A PIDFD_THREAD pidfd for a non-leader thread fails with ESRCH.
 - A regular pidfd for a process whose leader has exited (pthread_exit
   in main, secondary thread still alive) also fails with ESRCH.

This is not specific to my patch: process_madvise() uses pidfd_get_task()
in the same way and has the same behavior. I wrote a test program
confirming this:

  https://github.com/alban/tests/tree/alban_pvm_flags/pvm_flags/pidfd_thread_test

Results summary:

  All threads alive:
    pidfd_open(pid, 0)              + process_vm_readv: OK
    pidfd_open(tid, PIDFD_THREAD)   + process_vm_readv: OK (leader tid)
    pidfd_open(tid, PIDFD_THREAD)   + process_vm_readv: ESRCH (non-leader)

  Leader thread exited (secondary still alive):
    pidfd_open(pid, 0)              + process_vm_readv: ESRCH
    pidfd_open(pid, PIDFD_THREAD)   + process_vm_readv: ESRCH
    pidfd_open(tid, PIDFD_THREAD)   + process_vm_readv: ESRCH (non-leader)
    process_vm_readv(tid, flags=0)                    : OK (plain TID path)

  process_madvise() behaves identically in all cases above.

For the non-leader thread case when all threads are alive, this is fine in
practice: all threads share the same mm_struct, so profilers just use a regular
pidfd for the thread-group leader.

However, the exited-leader case is a real limitation for profilers.
OpenTelemetry eBPF Profiler wants to profile a process where the main thread
has exited but secondary threads are still running [2].
[2] https://github.com/open-telemetry/opentelemetry-ebpf-profiler/pull/376

Using plain TIDs (flags=0) would work, but it means users cannot use
PROCESS_VM_PIDFD in this scenario.

What do you think this patch should do? I see two options:
 - Address this limitation in a separate future patch that fixes
   pidfd_get_task() to use PIDTYPE_PID when PIDFD_THREAD is detected in
   f_flags, benefiting all callers (process_vm_readv, process_madvise,
   and any future users).
 - Address it in this patch series.

