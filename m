Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B056C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6333E6B00BE; Tue,  1 Sep 2026 01:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B5A6B00BF; Tue,  1 Sep 2026 01:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548A86B00C0; Tue,  1 Sep 2026 01:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33CF66B00BE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:26:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC61640243
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:26:37 +0000 (UTC)
X-FDA: 85164058434.11.B0AADC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3E83916000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:26:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nyr59aCU;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788240396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0d6uoxX59JE6CAN12/4QKhpNFVtXkpS8bIPHrIcY1g=;
	b=5M23HknXIpI8FU5pp0/WK9+Phk3eAPg6cGi8vf89HWnBEJVPF1Uwg5u14lFDyPkzc1blUx
	+5l/Ivp9kRLCUzvfx+N/CgKeXp0+k4YjF9GEmpgWyz3hFq2exMSuArjJ6W4c+NXe2yKoxm
	PJck4Sx9OFo93zTFtKAsMUUZnJsZS4w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788240396;
	b=S5dpUzDVArklFYScd0SqH3DS3K4B68+BQxdDJ1jnZDybgq11PTBysO3LdA9XwYr79J6U/G
	TR2xGeFRvzaMQW9PPzG//uCVN98VnSlwxgE4ujtJ4xgl0FFfEFnFv69nyZrov8dLDQJf20
	bmWQVPhtIZR1zmJSbmJ8Q+my/8dD6yk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nyr59aCU;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E9FF601DE;
	Tue,  1 Sep 2026 05:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C11B1F000E9;
	Tue,  1 Sep 2026 05:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788240394;
	bh=i0d6uoxX59JE6CAN12/4QKhpNFVtXkpS8bIPHrIcY1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nyr59aCUsrbXnN7xieacuiygyswVayN/35mPUGEaTYtflBfgXvg/AxzCVuwthR+RT
	 PldsjGvKuMechm69pCYLvgh6QB3NkIWNN0bMifNTEpPYjRwbrUg8Z7vTzj3al1CLqK
	 W2NItwsCAZCRC99LTtuAxx0lEnVExhA0dhQqlFa5X3GARo60iABAUiLkj2fGqLoU8/
	 VvWS05k7OvEUAPbfnhzcEWOXAydz8BGQPyjTYog/mN4LtjyqVnIHmDv2QTEhpJXE36
	 UiPMFLQfkGiexUsiRQ5+zX4XAR3FnN4w+tH6+/hgARbI1pwt/+8jf972udeYiaInKI
	 /Y3dOh0ARMmcg==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 00/17] mm/damon: introduce data access-as-a-data attribute
Date: Mon, 31 Aug 2026 22:26:26 -0700
Message-ID: <20260901052627.6526-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3E83916000E
X-Stat-Signature: ze8o19d91j597pbrxs1ozsbw9g4b3sap
X-HE-Tag: 1788240396-503347
X-HE-Meta: U2FsdGVkX19D0vOuvOi4GdTRyGwyXgES85Mb1ZotAgPGxdqIB0z+EBvAagmu4Bs5kB9OBPe2CwF+GRp++yzghhGXGaqhqASEemkz33wVVXQv3df+TiqiC9ZhBJuLq7e4U7X02Qb2a0ZpposcTgxyPjYKozNM2jFLkTRaFcHjw9hDj+6BfltouS3hyd2xnC2WGOtREJSpeGdfUoKW3zWhA8ASWVQjn6QtPpJHurXoDbAyvPioLhNIcb78Q4EyV/LiQl3THGtxDRrxTaglJbXS2DQipkUGuXJ6Fn1XjcaDUOwHAIHoBWyY5qY6b02XTbtYZlesCV74EuCVwch11VVXT/LXwqOzuAQ25MtKhgR8XGJb5s/CjwPCiJJQqm3aGChDwmqna3Q76uX5t3tocq7rAKd+gpK3k82t92b4i1avyAywNCQJGRs+zbCLsXoMHZKOGiBsa/FRoQwd5ZZBJre+1zlfAxBz/APBSbGRRKmnbXsJoqhA2w8eq/8THOgC8lzd4L3s2BrW6D+m3pv66Ztbq5XwgLnS39HJFv07AEnYRpSgsiIOjkVwOL3EYTpR4UeCuEzrZvwudse/aJHP3puaujc46syIL83eWAqayx+7/kBGb7aNuC6GaSQWhl+sPRP+7q/YxQTxAy92F9MRx99xlaC1dhe887mB87P5TexFNvVBOAWO04MdVUZln01iW67PdIJRoRqcnwZI1EFduf1p0QiIQ7Sq2McOxqD73/UStJl9PPgDb1H1rZhiKFXLjkOLuAeYVh5IrDk8CXoaTO6RTViu5cutqaPiHT7LACceNZnQTRJf9ETZlZ+eJrhxv650pf1CgLodgm35rWfeR/mg3FVzlIVmOA1b++a+t1AM3/vsn4VWs0GE2gyQ7xV0z0rRm8k4rmYzn72/03kbcTz1luNGzz7XgV7VFKV5Q0koSlvCwaYaY0VvTBWkdxEAr0MhXhF/4rRDOIyQLPcMg74
 xIFUhBOa
 /1jAKaTV2975vWr/ZSwPcDwD57ApiJkEwHvAnuUXALAFY/gL0q+B6HVdPJvKInPeY4HOp12blIe6Z61Je1Gn+u37d+vI87vPrIuQTWJrkG2CFdbEeWoEQoFbyRaF6Qxt2S3ZYauXnyKeghPLvwB98OxHpGLdc+PRu+xdmzV3PyJI9j8HUi7d0EyDecUUIKx/uCOmO1ElUPYVyaTCDS3aWQ/MXKbuw1R0QjHK9T4peuT0vkU8NC3KrEIFikYoClC6dCOBK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 21:33:56 -0700 SJ Park <sj@kernel.org> wrote:

> TL;DR: extend DAMON's data attributes monitoring system to support page
> table accessed bit and PG_idle based access monitoring.

Sashiko found [1] a possible race that is introduced by this series.  I will
fix it in the next revision.

[1] https://lore.kernel.org/20260901052446.4122-1-sj@kernel.org


Thanks,
SJ

[...]

