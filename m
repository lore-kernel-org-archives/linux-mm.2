Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D9CEC98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 06:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082C46B0096; Sun, 27 Sep 2026 02:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034106B0098; Sun, 27 Sep 2026 02:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8BAD6B0099; Sun, 27 Sep 2026 02:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C92736B0096
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:02:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 593FF40984
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 06:02:36 +0000 (UTC)
X-FDA: 85258497912.03.0A4A0B4
Received: from mail-qk2-f38.google.com (mail-qk2-f38.google.com [74.125.230.230])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8918140007
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 06:02:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gdp5UK3m;
	spf=pass (imf17.hostedemail.com: domain of danielzgtg.opensource@gmail.com designates 74.125.230.230 as permitted sender) smtp.mailfrom=danielzgtg.opensource@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790488954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=1jCjtYoS8P7He0eHB/co+eUvc5U6jhinCxysS9BksKw=;
	b=tJcD1fgHCEaUpZHmhp+qNzByaO41FQIh2S+wGL2EyR8EkYhYAzxzswTOhAASkvWBa+sX7Q
	i0ZEYKVkaI5d8afejPNxqFOBJ/eK/kgGeCMBOp7Crs83v3rVLp5l3HzIqafIHvJrHOdDmJ
	JZiP0Oc+DypMA0RFrHsFutZ0IyqG6Sc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gdp5UK3m;
	spf=pass (imf17.hostedemail.com: domain of danielzgtg.opensource@gmail.com designates 74.125.230.230 as permitted sender) smtp.mailfrom=danielzgtg.opensource@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790488954;
	b=LnIHrDAfPlv2w4xzc6PYM4R4VWAXYIK+sbfT5poh95E0OCW0+g42+KSpUsJtBgS9+bG/H9
	wKYhjYZvbWyOWWdM1NtBrlLKcvgiX0B1q00AI/uJyUW+Gp3QMsXO4LdWrgmKZULqjK1/Hl
	Mr2jN2BJ+3nZYgo5n6DrqkHtWuRDAao=
Received: by mail-qk2-f38.google.com with SMTP id d75a77b69052e-5333a59e20cso1342791cf.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 23:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790488954; x=1791093754; darn=kvack.org;
        h=content-type:content-transfer-encoding:mime-version:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1jCjtYoS8P7He0eHB/co+eUvc5U6jhinCxysS9BksKw=;
        b=gdp5UK3mg48hxMjkI2Q8aPeie3MY7vDKWxRkNNyP4+N88moTyK9sOFzBqwRhZEM7Sy
         tkSCC4yKcPdFypJmc3DNfvvOaYFiE2CwBO/9cKBXc74zuwhROkM+UHDNNMemuqq/gSNO
         dMeV+wCUmLumTLeWPFe3WEA+/hh8h60t6tH2jzr8rT/8IYqSY/3XHBHaAyZlepqT4obL
         sq3P1/X8ViZmU2Wqlsu4j5NPItMSmCSvvBDono3bzRzzlzclR45Q9kuieSk7p9e6yy4K
         NklNdkkq0peHb6KMe1/P1RrRMPjkvg794sMXfFN+bQXb/4vPKjN40PsXxw538pdDqhuV
         12JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790488954; x=1791093754;
        h=content-type:content-transfer-encoding:mime-version:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1jCjtYoS8P7He0eHB/co+eUvc5U6jhinCxysS9BksKw=;
        b=PMnbSuyssukTvx2Yn5U/f4g3Nfz+eXmhBgvZF5TfKBj4K3gYLfgknN08Bhw+5V4DjR
         1yh18Fs+Xy92aDY6ksQ+9H6nZaQQ/0aMI2/V2FT7YwD9B5hQibucZL1CAfh0YUWTEpok
         CG9l/9ZZfuh7Bh3mastNl9VPioYrBKQVD2uJ1l9dCMA0EUwiusD33PBUeFza5vAak0ZN
         fpqU32ap7UJjqis0Ah164OKtlNxZKvNBhEWqurzF+1rBeWa6MjO3gKgV6Jq1vXAK85zg
         ynw8jkCUUjQoXx9IkyA8PGLklwSy95YtQksEzms3CJwKUNMjoiTEaTTvA3yhyp2ZHK50
         qlMQ==
X-Forwarded-Encrypted: i=1; AKwUvBya+auppU70VYjykjm3FujVS8Fuu8MqexwQKYxsLUZgOowPAW2iYa1bKCmm/ttQ+Wmi7ZahoJ173A==@kvack.org
X-Gm-Message-State: AFuF++mh3AHvsAAMHmIISegOpyQDEh/c3eIvuWmYrTKJ9uwC4u56O1jL
	zZ6GdsXcXhGdPbt040S8Cj0ErwVK3KcMJlk+ap48I8OVchC9wLMjlZ16
X-Gm-Gg: AYBFou1OmMuwlrYDxdUX28HR6OmP43fY2HA9zMtomdFk+lT8zTQtFsl+Gh2DsJPTbcG
	VZ5nt5fBvob+qUF2XhXKjQWpJhqgnXzfA4Yv9C0ZVyyrSc0UzivMSVi3ThRoozn88LFwm18vnR6
	v1+qt/Ygh0XRrGsOJwKTE0R4YIvvsvPjBW3LhY7jozZm59/8382qHox3thaNK7P5c8jDP28DupA
	3cdC5/RN+lpFZjNiUjet8UUnvCAXlkbZzIrgrfGaieIMTQJemDtUS7fX6Mm1BBldSFywdp5WzBv
	s4pJD3qQpPM3IfJib8R4kP9V1NJD/lYrD6c/GOQARLrvqrEc6/EPAODeWt+z2VwA0jN+8CtA09A
	xiFbuheHtfT5o8QtmrN9zg6aur0sj3VE31HmUdtk4RmaqP7pdJ8GoGRq16tVed3NnAW/ZQixmKW
	CnAf14eapBS5TUe5mL1k1qZHjbXvPDS0SRaLip3UDTSmM0XZzwrQ7DrrlAOB90Slqxxb51V4B1G
	fLO66OE5tY0SAlj2TSVBhzsXsqU
X-Received: by 2002:a05:622a:13c8:b0:530:e52a:8ef1 with SMTP id d75a77b69052e-5330b5dff3dmr142397731cf.26.1790488953719;
        Sat, 26 Sep 2026 23:02:33 -0700 (PDT)
Received: from daniel-desktop3.localnet ([204.48.76.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5332238c585sm34613801cf.20.2026.09.26.23.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 23:02:31 -0700 (PDT)
From: Daniel Tang <danielzgtg.opensource@gmail.com>
To: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
 Gabriel Krisman Bertazi <gabriel@krisman.be>,
 Gabriel Krisman Bertazi <krisman@suse.de>,
 Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Gabriel Krisman Bertazi <krisman@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, smcv@collabora.com, kernel-dev@igalia.com,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Subject: [BUG] Is casefold unreported in /proc/mounts?
Date: Sun, 27 Sep 2026 02:02:29 -0400
Message-ID: <5193732.31r3eYUQgx@daniel-desktop3>
In-Reply-To: <20241021-tonyk-tmpfs-v8-6-f443d5814194@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8918140007
X-Rspam-User: 
X-Stat-Signature: uc55s9ko6kwo6wjrqhbyet3umoqstys6
X-HE-Tag: 1790488954-809348
X-HE-Meta: U2FsdGVkX1+sGTd+uLSxyDMPT5e1Pv8MGltX8R4VIptrYuuYwrRKs5gorlhJrtA5Y02q00pDlI/EWaw9nYx8kAiMECQKE2HsacBdWmWXFr2IDkBzHtLK4z2cRSKMp8xAEokefpS7qHDYfmga/dhtQgku/owLvgcYoTJa5DyShP7/7ddXNOHO6jCSXJGFAXWuPV/dJk8n5YiSL3vafH4LGVX1mKjHq2HB7IrYOJzU5W/Jj9jap1Z0Gyb6qXHna/3gCKomzq1c2X021i+p1cDtc/nPgjc054z1oPEp69W1uCcxHOmqOe8jNjjBcmzvvBjPMn5/1z5z3AhO/VCpUBz0jy3xgSDOg1gURtZSXnVADVTjmMlm2U8L7Z6DNLjRA4pk0bQuRTK4qQg6hEf4ue2TZi1tgxH62fcB6IF3DByQjfB0z/nCN1mJ/rjXrRtpEzpdJCb+TKdTf4flEmtVfgvyaymiqqrsM3Q4bE2GiFVYC5T8OORvM0dQDzNG+OvVY3fdLMnMWU57iLE31E3rWyoudapvJDwMNvXUXttp/bsGA1CKMwNKJXu/QC4/Hhu6oOi3i9U5ZFIIT67qHy6SQYAcTXPO0rm5aoRgdtFhJP3jIsgY+J6LU3sF/B49/DUcdj8dgu6r3YXNAJtpQMeSMe1sRfvdf9avJ4h+R9WLESf7UFUk6pFUMwKgFfCsR1CXpY7LtQJyYoEZTab0nnaV7SucN2/Ml3amp5+B+6qw9BYHSOkEd9H/eKq21jEHN4+fU8he6bA6VMaj/vfxTPbGk3OnlbGmgMGp2wGzWB411EIxokr+z4UrCDPZVJZd4IyNFOXLWomIrtif8O0tI7ku7/NrLZGT+EIR5wVqcZxrPz6m6LpGyDEzc+Lt2DSAusXDpKptM0//SdonoMY3PETUEUa7il+JuLQKHuOwqH7cUYOtuUvWzhQGyV/J3J5rNRljg5Beucu4cqAOrXdZATra/UP
 S2reoT6/
 UKLdGMa36FCJv8hJXcV7YFIUKGhABAq7VcNPwKvso0NwnTViHaXROcwLRyAZrOlfTwZu+ywM6LbPqiW10L16UiI+4x6kuFcu3/O9zs6oyi4v1IrQRlGmD5A/4MRbuTdmo7+JFyR/52Xzd9kVqLLANBSC/u8V13exJdpzwPfn5dq65jOox+A/KyITTvZQUn+LLOGgWO00MWPu+ZFf4Z4ExBZdN/AnLPceMVT7CSVRBrq/TCeLQM6vWpAsTOjofmqO02GODu1E889B19hGbFWTMx+CGdC0w6IykHXbTPweEKx/H4ub7+RKOTp4nL3oXnADEI+iYfeMHAdG/jazd/eToR4TGo7tsB6gXxFclYrqxbX6EMfoTb9mX0ECKBmV+avQ+Pitw/LXBTyKbiceqri1q4vZ2ODY0DgPxr322ls7HHqLS9pNpBLC5UIFu+c1HKYjfra1XGQkmfbRgDU72TPFgL0SOxr5nciV+Y1oSaTSxbyfVrf5MB0hcpMkg471caxGftvVwsQe5URqusVdhdILPsNPmNaO94tqVeXO2mwJrMAGCVhxuDCNN8WhU054LhOctooFVoUmuzxZHmCXXLBU0xk5QntXrHbDCmx/dQISSPW5L+tHSsD8G4XWw1LbXZc3s7TpRHfh/wbPtap0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upon successfully mounting via `sudo mount -t tmpfs -o casefold test /mnt`, I
cannot find a read-only way to determine whether this option is enabled.
`mount`, `cat /proc/mounts`, and `cat /proc/mountinfo` only display "rw",
"relatime", and "inode64", never "casefold" for both with and without
`-o casefold`. The only way on 7.0.0-34-generic to test I found is
`mkdir test ; chattr +F test ; echo $?`, but that isn't atomic. Which command
can determine, without writing anything, whether someone or some program
specified `-o casefold`? If absent, I suggest adding the missing info to
`/proc/mounts`, likely `mm/shmem.c:shmem_show_options`.

Link: https://lore.kernel.org/r/20241021-tonyk-tmpfs-v8-6-f443d5814194@igalia.com



