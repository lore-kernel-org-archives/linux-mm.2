Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D418F55436
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 01:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4FF6B0088; Tue, 24 Feb 2026 20:04:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52C46B0089; Tue, 24 Feb 2026 20:04:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934806B008A; Tue, 24 Feb 2026 20:04:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8184D6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 20:04:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00EC6B8C47
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:04:35 +0000 (UTC)
X-FDA: 84481183752.25.D98C8A6
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id 104CA4000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:04:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nfX7JTYO;
	spf=pass (imf11.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771981474; a=rsa-sha256;
	cv=none;
	b=Men0EgAMftIOZR2qVEitAME6fUCZEOIjH9xNPoDjpwfv8k4Pfd73DsVdKl3eVnejm4xoe3
	sUSr5fO7UI3Tgti4pmfSaJpYX1VhLBVgA/2yrQIcAziBv/MIdJRxWu0WtD89A2S2UlJ0ra
	6/89T6DKDlKuc51rMZVjmn9CNS0fhFs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nfX7JTYO;
	spf=pass (imf11.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771981474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91/bJkQNN7qyadQSoaiseSGTAeJs7mqrmAw5bCkfU7E=;
	b=EbsiDkRjCymlX1J8d3G/EPpQih0dyRuUu0M79pVUJd1WOUWl8mY7iPlD4BwSQ0I91uViv9
	kpsSpQpVZKkIMUctwYjtIrzSZW66BK9laS9lYyY88O4xVS/EIILi+8V8I3nQHRhUKafJ3J
	cJH2azvPZbxihQbZGWRaoeeFY5etRaA=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48371119eacso71761425e9.2
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771981473; x=1772586273; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91/bJkQNN7qyadQSoaiseSGTAeJs7mqrmAw5bCkfU7E=;
        b=nfX7JTYO72J11juWuAln7oKYYMJmhUd6ZNYCit2/vU+g/N5l9Em282PD6rRWSbiNFl
         7lMw/dbQwEaYK9DwaNnv9ueu6F3URNdesNGlAnOzYVEANufFJQiqx62a0HqoYkpcO0sf
         zXcWSkgEPLb6cKUufh8C0ky2MGjxCddHULjEQ/PsH6Lm4bLz5HioKis+imRM0uyv3umR
         X46NHmXEsGuZQZoSOR7KpFN/qjoz0021hPH0YLrtxXzfOuJuo4TfDFDiHsS0BYBzOqlF
         +0UPhCoubD3kN1GrIBjVeIcUH65oQdZxEL0coK1S6bmuLnxAa0ExSw+CsQf1YBVxHZBf
         fhqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771981473; x=1772586273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=91/bJkQNN7qyadQSoaiseSGTAeJs7mqrmAw5bCkfU7E=;
        b=s1B7BHGbgZqrxKtmQqq9+1goxNSdbvjk11pvZCde/sGoln9JMPtR2Ssq2WAMKPh8ta
         fc3/+jar03Mz6WdFUCMfvrxXy1GHQLb1AR7heoDAEfr21an7wgguWYLGC2zNjHcCMSXJ
         1SR00/MTS/JMAnJhR7odnqVnHEDC0aSAJ6ISDCcraGxAldMlfOTCwxK7jY7guyddWZUQ
         xGenJcLDOttRRh7998pA9i6tIqV8GudmM8FvqKx+FCr78bC/g6IGqZnPVES7ray4X5J6
         R7AZiD7Dr7tkvHZV3VpM2cmeZN2H/iH2dq9pZKVqW0n66NkvPXCLyLGCJuEllMokZEHY
         Mthw==
X-Forwarded-Encrypted: i=1; AJvYcCVVJYjLIJ9W9QveVGci7w50tkXJ06Upk77VDhCnG2twHDFflNEqaZ7F+qNxHu2sHR0XO8cULkxq8g==@kvack.org
X-Gm-Message-State: AOJu0YzfiVC8P6xTcL6Ih2t6tSCM/dodvIrZTOzO8+RuTRqyMNjiU6s8
	e0Oo9+OFlTJL0MHjXlXvHHdf/kH+6ZT9faYpwL3kzeDjKopjtKPusDdz
X-Gm-Gg: ATEYQzyhqVq2cz9PZB3QH+aGtZedfaWMI7mt+hqsH5S+TAf9MxS5ci01lNcY+leBiwj
	BpIKEZfoYUwJv6bbekpq+13dI1ZNhimUK08FBfiWSwOHiHYMmeWYvkbR74muvmurfI63wWYTg85
	ol0WZ7mO2Gz2RotlejOgDaZX4R4h0TLRKGS2vqcj6rX9LV/AFfM6hfAjx/6Hekqu2K+SCzuTxim
	pwcEN70tMgTkBTCUZmTrZ8Dxet52YmUiwubpnvZfLJao4PpWTa/JHcYfuIHJBhQ7/EGofCHHaDR
	7U8rIUQ9MnCqyf6q15o2DNpHTydwLZF+DVagC9ccsGpTmbUvDLfXdU4rrC9e5PGGAmWbbACcqvM
	ttxuFyxVOxvAwoPKAzs1VqKhwNF+VmZfDabl+9WUgqeKyRzc6Is4qbf0hzo5OfxQLdwd5Y8HSdz
	HpdS7qXuhg75zAfs/YtMMPer0O1KmFrA==
X-Received: by 2002:a05:600d:640f:20b0:483:9139:4c1d with SMTP id 5b1f17b1804b1-483a9607e3cmr199650505e9.14.1771981472242;
        Tue, 24 Feb 2026 17:04:32 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-483bedda2d3sm4976455e9.21.2026.02.24.17.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Feb 2026 17:04:31 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: nphamcs@gmail.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	bhe@redhat.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	christophe.leroy@csgroup.eu,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	huang.ying.caritas@gmail.com,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	kasong@tencent.com,
	kernel-team@meta.com,
	len.brown@intel.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	npache@redhat.com,
	osalvador@suse.de,
	pavel@kernel.org,
	peterx@redhat.com,
	pfalcato@suse.de,
	rafael@kernel.org,
	riel@surriel.com,
	roman.gushchin@linux.dev,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	weixugc@google.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
Date: Wed, 25 Feb 2026 04:04:24 +0300
Message-ID: <20260225010425.2876986-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 104CA4000E
X-Stat-Signature: npsc73ez6kbziiofofb8fnz7fk59ndp7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771981473-49949
X-HE-Meta: U2FsdGVkX18YKOIZu1qUuvbSgeVjCxwxEi0c8BtB1Dqg0cKrb0B9L/kO7GkBGYwaBpY+vams85OGwlnYiVuQt+UpDl2RoOS2nAyB8JNdQxky46c8jImHEZEjyHHcU9xuG2rpgcQcwc4++EnslJb/uu5i9ve30A12NtWfKDCbVp4cRNhyZu24ayxdqC96pHkSMa+pzaLrAYRV1Mv17wMmGdDj8tRZyQxcnhBpqAZgh1/j3YBL+Byi4yMwV7QKdwNMdZmr9YptXuTG/AvL3jUuylUunBZQvxqsjlw/xT3P9adEFTHRo1XE0N7rmuGunDAH0+S3cxZ4LCbfaUz1dHecvXImErMNVoWMwpt9NzsNi1qNKcH2z2DnSE+ybm7hK7NONjcQUF/IXTbm/UpQZ23NPkaPyfOEVePaWbpAAHzRWfW2DPu/wzmk0jkSlRzgLEwu92ZIpsmfnDX+8mTm6HLQZfr2lNtsVkXV0xZYfAAsdwORLosTpZtso9d23U2kfzkxz2nfmcDUFM3duIZqzXESij1NfrdV76iUV8y7xEwD8GFmMGegEFDZvKHiTL4C0UxOQZlJTiORhl5ANN+c9Ic2dGoJUEGrbwLuuSpkspdvoC0L+fiHavS3GEirEpkPCG1l9je2n28SK3cd9jBn/9W6KiJEoVXlPDeRCjnhNSF6gDsMn+tFNRtnVF3U0oZhGkooAwCXqBHW3QKPgsdbinC+D96yiVaw+X75dnRHlZYI+U3ygV3QjDJs0Z5SMk0E3yStW+ExBmdGLYbaVs70479irfY43opl7Bkdzl90N0yKqs3b3JFuNo6EN1m1ew2qqWVcMG6A/E/fctBsYuMp9w72m8faSkeojiwK9X95Y4+9z359thkku1bq3Gg/uVrCjV/rQ5PPgX6qF6me/twPncu8hRpoEm2zC/t1fmcFGtkQmygPBnk3Yau76eaoJFNtcTc0tnw+jLJq36NWaT0Wuee
 /IcKVg1E
 f3ovHEfY8XTC5ZK4oe4cNLWu97wAetKqR6obyk7LHDU4twazR+BbSUZiPqu+otfMQWVh+HTSTUYwLRI/aan1t0IFSlV9Q+1/q7p7yE5UrkBmQrDSMVdp3fR/vTxYwYKIdjfGe1063e1Iun1B4Zpm3IrNqvGOW2ERVsD4CjY9akqHFhrjKm0VA5QqZo+Tk6o4RrggZvelxLcpu6QxQzyfcKKo7hoAy9+IZqliXNfFu8xQG0blXmshtbsTya+6JNC7Oz8Nup+LdoeK7xN6RsEuwJBcEKo/PPUjrxgA+2Uax+z2142gJavUjPMz3DOTeh6DcwE3SQiaa77OtgWl/j4M6/ctMrYdGYKtx6K4I5Xp9mfGRe5zL4NgOPuCnZYObMRloC6RolJrmLyCdaBB4wyi13zFFhzqgEPNG8K27lZnmOC0MVpiWw6wPPkH7lPW7cmb6Dt63gSh2+dJzCsIMmAzB6pH8QmRBCE6/+EsHoNzuhfCurhk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nhat Pham <nphamcs@gmail.com>:
> * Simplify and optimize swapoff: we only have to fault the page in and
>   have the virtual swap slot points to the page instead of the on-disk
>   physical swap slot. No need to perform any page table walking.

Some time ago on Linux 6.1.124 I typed "swapoff -a". OOM killer started
and killed all my apps. And "swapoff" itself eventially failed.

So, it seems swapoff is very destructive operation.

Please, make swapoff non-destructive. Or create some alternative
non-destructive swapoff. Such swapoff should try to swapoff without
killing anything. If this is not possible, it simply should return error.

I don't think optimizing current dangerous swapoff is right thing to do.

-- 
Askar Safin

