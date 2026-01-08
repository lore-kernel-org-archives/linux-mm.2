Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CDB4D1489F
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 05:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89E4E6B0092; Thu,  8 Jan 2026 00:31:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821F16B0093; Thu,  8 Jan 2026 00:31:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9CC6B0095; Thu,  8 Jan 2026 00:31:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6B76B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:31:07 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04548B9D49
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:31:06 +0000 (UTC)
X-FDA: 84307672974.20.1A92D37
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	by imf30.hostedemail.com (Postfix) with ESMTP id 27BC38000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:31:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Fv/r9lyv";
	spf=pass (imf30.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767850265; a=rsa-sha256;
	cv=none;
	b=Tw1vb0i66BoYdPTMuBuwvponzTx09gZFi1CVz6FM7DD/FqVghS2q/VUbVDGtF4aHXztu5i
	Jd6+c/dC26UWQfozJSbgWua8cc02oGAfeP02nvi3uot2x4S9QmS3n2gXUUHdl9gxF8BnGi
	AI9+eGnnWrl4MjhKg3/v26NmzIxFM5U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Fv/r9lyv";
	spf=pass (imf30.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767850265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSwdeu7tKlsfiSUj4eNrRufNOD7Vq/gThbg2+UQyNgA=;
	b=JyHpfFXMJCnyCb24Utk8a9vvJrkrJCfSFzswQAagyhvcxXTnVDxEnJfwS004+o03ZqicGa
	V+OjfZpznr8pUE7Zxk7yS+6y7tmwQvAbf6dJ32sV5AHMwADP9N3ZQxRYNkpxHsuwpuMZBn
	LDQaHxq676klfEroMZnyi+1Vzq2k8tQ=
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2a09757004cso28207235ad.3
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 21:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767850264; x=1768455064; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OSwdeu7tKlsfiSUj4eNrRufNOD7Vq/gThbg2+UQyNgA=;
        b=Fv/r9lyvAMq2tszYqYcrp3BZ9dSzF3Fg7zxirnXyxhB83YBpCtokepjQFtyeRg7kHY
         xBxCh1Gb6fYnxkVnYhqnELeF18R7qEymTNELedvrC2Grq9M4xcHDb7bwVu5TgtAxHCPc
         xE7KBWoNbpAT2fhRt9XEF0SARPSwlXYGBT+V+z0LBQ4Ra9Cgj3hFmkXnRLV7lc9rHiVH
         mYD9iqbL0/PzliLNTek/qQFFOLRaS4+vTTMdKmnIjOy3I4xWbXqlAx6Hs6spQSwINcW/
         CYolMqrE9f2CbBp6/0HA2nOInnbvcSxrJVRNI44ZbKAqMNzmgIDkytDLBukrjFotMgy7
         kJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767850264; x=1768455064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OSwdeu7tKlsfiSUj4eNrRufNOD7Vq/gThbg2+UQyNgA=;
        b=qLfjgr7Igzee6KDXrdjXboDkv2Jvp2qxPkK2Mc0dXOrpraPNIMtFaZ0PQHA2ylTGS1
         4gJ77pRhwAlzcgGzaicSOryiUOM6o9m8AeikHwieJ9EtBg7438rskeusGPSJM0BfOIqq
         UU1jwON63t58qgtjyJILHVePL1nVlbZrqajRgcABNN8wbscVRlUm6XWK3oezUkS9lWWy
         xO8ue4+3oTFcWm9RfnEir4QVehNZZYOLnoK+mRyE8xZWrBdYc53umCRlvgdpGdzyYnRj
         85exR6kfTfBk5X1uQt5Du0Xej6kea+/ssPDRy1365aK7rt3A5A7pJdyRASwdlX3yeUL4
         saVA==
X-Forwarded-Encrypted: i=1; AJvYcCVZYBcNUvkvCwZJHHyAdhIjrcL5vRXCpLIVDbRf3k//VVFE3zHFB5rD/uiimWTQ7fZ/rbeDPtSUPA==@kvack.org
X-Gm-Message-State: AOJu0YzGVCNsocZXkYSWtR/FGkfuj0HItBB/wBo6UO2Xb6PN4doQi8ML
	MvutNM1NKQ/BOvhx+Lj9rhLDYci0KcqxMaYYbGY5D64br+Sza81CK82H
X-Gm-Gg: AY/fxX6vWaKG1bADX1G88TVjFg8LFACaLuDZmN5dyGKGsgnOjRFwxsRxVHqMNU0xwVg
	Yd+7uAikbj7FfGEgoKcR6spSNgRNz6ynDFCMhGcZk+DZ30QXnS78wHd3jIGFgP7Kev8BeC6tXQn
	yFBEkcLQS11Q5I2qKX+pfNndexC63H2gCZZ6d6U03s+spTCjC/vkd9Xa1tqTI4TX4uJ2yufYhJk
	HKD379Q6PqNBodeqiTrqSkGsaka6+wp1d6cJ2PCEHnvbEY5j4wff2GSXwHzrl82qgj2CznK3Z+R
	xTz+SlQYmaOCR7RBU1MikHqld6IKmUNS/jX5+0J56WT44kVBdeRnacvN8KK2G47MkwwQRtrfG2P
	+zyF0jCyyK6bFGuZa+08KpgaBvUQaLbd5jr7eOePDImTAzKn3FMTWjn/VH3khLhQ8azkn0MerTS
	2X+XS+Zixb3S6liV0Y+ESTczGZYRFPoJnaKejgjTMz0el5K3nk
X-Google-Smtp-Source: AGHT+IHcvX5WAM5IjNFTL15YS1zTlGO8G8SZde0fFfRsPM36HJ2veTs6Kn8MJvgpalqgHpUvZv4E6A==
X-Received: by 2002:a05:6a00:a902:b0:7e8:4433:8fa4 with SMTP id d2e1a72fcca58-81b7f7e59b6mr4302928b3a.44.1767843869380;
        Wed, 07 Jan 2026 19:44:29 -0800 (PST)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.217])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819c52fd938sm6092082b3a.43.2026.01.07.19.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 19:44:28 -0800 (PST)
From: Qing Wang <wangqing7171@gmail.com>
To: kees@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	dietmar.eggemann@arm.com,
	juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	mingo@redhat.com,
	peterz@infradead.org,
	rostedt@goodmis.org,
	syzbot+e0378d4f4fe57aa2bdd0@syzkaller.appspotmail.com,
	vschneid@redhat.com,
	wangqing7171@gmail.com
Subject: Re: [PATCH] fork/pid: Fix use-after-free in __task_pid_nr_ns
Date: Thu,  8 Jan 2026 11:44:22 +0800
Message-Id: <20260108034422.3871875-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <202601071238.F86C2B8@keescook>
References: <202601071238.F86C2B8@keescook>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 27BC38000B
X-Rspam-User: 
X-Stat-Signature: mq7khx66zah5iu7r795iuedmwemxbmaq
X-Rspamd-Server: rspam07
X-HE-Tag: 1767850264-200334
X-HE-Meta: U2FsdGVkX1+D0XDf0p3mTgWZ1eZZRQ1r5D9XSxadiG8cX/LYnIMC2QOU+qNGciwtQVCJ1KFCozfedDqRHHw5vWoLQ1aMtslRRimgzsgm8ybXGxV72Gj1H65bcwzd+dhLJiT17DF2qN5a3g2NjShcI/+0d+db2Edy5xE6GTn5tp8vDKTvZKS04QULXL2pCbQ5Lxed+IBPa8tom9Z7nr2pncmqiabV/0rBkCjdyRfibxguVnIeuHajSq/KXUWtCmJCHiZbDz8laaBt+GCZFDJ/BJ76a/iYHExHxPAyFencIsp4fnJPc2ZkHCvfdXz3Vds7frcyozK68xg3rNJXTO/sFG7lpXI00sDxzOBmpBDZxdh9BBC+e8MV78WA2R9XoLQwtvYykHczjU9RaIBemLrFbzBLmD+e0qBIOvjpNHrCD5lcoiEmJGRQb4HiYOYpGcASKh3VTEnO+BGRTrHfK60sk1XPY30RkjJDmbnQZD9ZVgt4R5d7k5I3ri3GdxfC6toxpvkP5fO94Py8259YI7IuWxxQAtcfypYv+qikTxauKEdjFwWvaFauzVRGiCC8wOzvW17X7//P69VMOhyy0hwuAJufqjt7I5IcV82bfbTa1Jt7QaKi0N0At0QXH0LVzi3m7HPIP4OjdN9AZsxBs+HHRz4AsabsN1plBhy+t9L2vX/rQxd4mZWv1oZNpR5LfEORm40roSzDRwe86cG6k6LJL6TfTOLDgfcxaCxe9HHh2HlZJDPSvARzrqRyWbG8FxLQMj6TvuI0J2YryHEPRVU5BQ9Nk6gjiD135mQ91heCiC3dPP7FuNFoTPYgE7A79goWdak4JmAa0w4MhhUFYlcsgJ274Yh6komWg5AktUlaBaAXr7H66ZLt3N/3Y+gd5+rmDVw3UryuOHdzwTNgwPcQK+d5KSiAQYBmqRDkx54qZkfrLpO5XS/sXZiP2iGvWxALKE6qTck2Hla16A5iVdd
 6psFkwAw
 t4BTa1EDzNv42E8BaHulX+bIgaNVruzQ0LBF6UkZNMmmgmxgUa0tawf56cIPjdmyBUsyYmEgumBrcmzrWzlHUjicoOieRJd+Xni48b5GscoBdKFHZNeIVfYqnAMo+3O6+M4xJ7uaygYzj7vQUv3i6XPzlQ6HK2uuXjLjA0gETUEzCeVuVZ13l+zEL6MDymF207LDIW72IH0RPZ6JhzExWZME5os9Yd4IfEhiKca78xen3sGyu9wDtjE8jeR3q7YxwWKv5qa8iC/u1KPVNsVI/bqbyHtVnSg3/8r6wbI7HrPq6GHKjW6J1SvDJTzf/6HQIQzvMqDFy1NEi3UIY1pQ0oBNFSg+ZGhBX5+avHg9vJCGGL2bzbzc8T6ukZ1E606rZogEweEWLWzOraZzw8xAzZ2j7b72BtywTyJyrx9exJCuNYeZsmSypJYUmk8hTXt1zhP9Bvpu/eQXUeY02eeW91A/0a7I+rvHRUu8xCyuoqQ4I2qvOu5nvOx047nieLFNX8ZtuNj8Gvjan+pRn/k+CzDfiulvsRO91354z7boPmpTWd5tR8LIXBu4sLV5dbUdndyZhDFSvJYa4Ot9A2Xoy+h8gO2P9fKKijuIUF0UiQVhkbOjrIrJ53fLNHs5wPklNNT662AyM61WGCOoAwqh7tcPZpZGDriEbvNOEpepE8xC5pb6Ebtx3mKKXNa7kxqxdJqi3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.010168, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 08 Jan 2026 at 04:39, Kees Cook <kees@kernel.org> wrote:
> It seems like there is synchronization missing between the task->signal
> assignment and its check in task_pid_ptr? Aren't there other ways of
> checking if a task is dead? This change doesn't look right to me...
> 
> -Kees

Thanks for your reply. Oleg and I discussed this and concluded that this
issue no longer exists.

Discussion: https://lore.kernel.org/all/aV5zkjzLTwKQOn9D@redhat.com/#R

Qing.

