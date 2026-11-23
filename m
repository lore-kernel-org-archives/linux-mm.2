Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB950606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cpqCxV3m
Received: by kanga.kvack.org (Postfix)
	id 1EDD26B05B1; Mon, 23 Nov 2026 10:05:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19DB56B05B2; Mon, 23 Nov 2026 10:05:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C856B05B5; Mon, 23 Nov 2026 10:05:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBA916B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:05:09 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79D38808D4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:05:09 +0000 (UTC)
X-FDA: 85466706738.14.58B16AC
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id A76D014000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:05:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cpqCxV3m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of lylin1023@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=lylin1023@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446307;
	b=dNGgY+/Pt33jIyvsttBdLQjGBIdA9ucoBNRg4gjn7THorLbwV5u9OyBzyXY55clzbq+m5o
	xnwBeXEXqxWyKhbvM2AscQ+n39kkk/xi1vyNAbIiY0GbMVmAAUYHfAqHPROjCss/ru21i9
	rEgoTmnNSJ0UynQrAEnADsC7lK7ro64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lv7P97cFEnUlqcS6xftzBXprT2lVDyXxXMjQGY9uQEo=;
	b=qfIsAAKuCUUu8fmE3VpdIAfXYx3VLiGUNvwTo7CK6eNH+WNCrXi2S/QHwGJx3dsEp0Y9lN
	0BFlkx29GitRtFje4pUasUmWdF8WMTyjOz5TlPSrAsmERDM2049x6zDag0rrMdN7jxNRqP
	R+xKqpMbrRKH/6B0MyAsw495DXiLD8Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cpqCxV3m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of lylin1023@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=lylin1023@gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cdb15cd8558so1444939a12.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795446306; x=1796051106; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lv7P97cFEnUlqcS6xftzBXprT2lVDyXxXMjQGY9uQEo=;
        b=cpqCxV3mohRoTHHuH/y355gp6nY5TTzDEwlwOTNpN9+ontk8Gvi6vnPa2RB5m+csQW
         A3vKF7FhkfsftT6yrs4jB9BLUP6Cddo7QSOwoOzRrDUyHTXAABW6K3cwyFAPvp/VMNdm
         7s67WnqQGvesXN/T6Ye9/u4GSl/XeGoHHwsi54dqKw+/3qzBi4yrt1jCqH8WvsjQ1xRs
         jN7SJABid3ARFqgtApzmrCcFKPXDmFn149efdevea1mduQ4g7Aga+IX7HF6Mrd6MrtxL
         8g3MclU5/Nw+rcjjBWzJE9ydGloV7odlUs8H+QBzwjACNwF2U2oSHSzPplOAAvg2XZ9Q
         B1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795446306; x=1796051106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lv7P97cFEnUlqcS6xftzBXprT2lVDyXxXMjQGY9uQEo=;
        b=pzEi26BupnF7z2SUaNFSjIu5wnQNVWf2PHKwpAjDTrP1V/ipy7BLvcLUZIatfs1yhw
         iny7DNe+yERByy4EtZgbFAyjpMh/tmqVfZvKFWKpBcMQfQWYuhod6q9EU+G9ArG/mEWf
         ndQfybbmT7/9PWWCNHFIORzNekuYbU2TL3vqnDWGDJ9IB3hgjo2RSJQx0z8P6fvAmv5J
         3mxrYUlmlsLB7JylLUYtPnAryp+3vpfIFVB7VwrmyqViNXojsXKYLnRVSvQ+THAd8Ugi
         /xPm2ArO5ZX4IqavLyInRIkZWMZ6eW2NY1dCdmRP0tLt3NwFbkkaM1LaCp+u/AlBGn5v
         Om5g==
X-Forwarded-Encrypted: i=1; AL+hErGcDj3nrZ4AledKu8ytSHkpE1PLhC0ssSRGYynHOdnGN1zlF8+5sMh9dN+xF7nXjvIbkWbCSTRCIg==@kvack.org
X-Gm-Message-State: APuU4Z+U1rNc6bYKLQYQW9I4uWGxJtDBy9dmjetVrNq75rT6L49Q5X9y
	a5wlmkdkT9XjVJQ8gusBgh17Ya4mU9kO8A4pYo+qYrTR8IF1nXeQ7gCh
X-Gm-Gg: AZFdTZddatNi5CRKmhaKQkVG+7lqJyOfF3lBS0fqUPNMo86qUb21G+51NhwPVWTzm8K
	dW+5YPi6urnVzWPMJEEJlWRpGPvsjU2GEQ5/bqTqoJd3ihqrNAt9Q6+hT2BrzuLK8nwTOOegTfr
	YXOLjs5KfKrMTi4MMrGt+xQUnpvdPB1JeHenr3Z5eLVXN6T8dlBw10btl27SYrejj76maEb3zCB
	Kq8wYy8JxrdfGHpGIkrX38Dx5H5nWkMQzwIQpwxuKiew2a8QKTEsgUNQmeLs4oioRsjXJLq60Pu
	llAApRPPAJSDlPoFzDOJEm+KA7PFULBntaIuGrnp+xzfwzozkxx7HFOtVKgJAZJ7l99QOrNR5wo
	qMwEJU1Xv1hHHG0dW0RmVaVW8hre0Wjb/y8ds3N+t5MB6ULjubdBcLUGy9rfxrn6w97fKKytMUS
	lxAqh57BVTanF5ZpTzYcwIOCRdAG6e63BiSXRfRYWjbTu4YBFmqNmfgtMrUwUSp87QN+y91T0rV
	8ApEKjSVQLQ/Ozpth+Ey42zkGDsdhqzMvHPOZxmeSuCOlBysGFJlCQoA1W0zIcaJwNvkSL4qwQ1
	SN3tDHhc1LN8CIqSHEK1wllU9j+DA/MJe5RUtQbeCTYrMgmRLhModVdWWdl1BFYNM0Gmp/g=
X-Received: by 2002:a17:90b:180b:b0:3b4:1336:4f53 with SMTP id 98e67ed59e1d1-3b41c7d5c11mr9976213a91.1.1795446306224;
        Mon, 23 Nov 2026 07:05:06 -0800 (PST)
Received: from localhost (218-35-178-218.cm.dynamic.apol.com.tw. [218.35.178.218])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b217a5bsm7853738a91.0.2026.11.23.07.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:05:05 -0800 (PST)
From: Kurt Lin <lylin1023@gmail.com>
To: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: skip hard dirty page-cache test on FUSE
Date: Mon, 23 Nov 2026 23:04:59 +0800
Message-ID: <20261123150459.2211177-1-lylin1023@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <25ecd9ad-7c5c-16ff-5197-5703622a88b1@huawei.com>
References: <25ecd9ad-7c5c-16ff-5197-5703622a88b1@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: A76D014000E
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: jddnb3bii7x6y7urmbo8ch1o5zggh8js
X-HE-Tag: 1795446307-455289
X-HE-Meta: U2FsdGVkX1/tgrKzjIHn8Sm+o0Z+rYUZdV36TlemQCen4HiMjKaaEOQyQsopFF16rCUT4MVIfBvcxRb0yt5xRiyla06dNa9BIG2m8ohw4VLfuhhTkpBoYTiM4mpcnt4hCm7C8BXwF2n6MZp9XzM+sepDKYWxRp0V71F3/8R68x7D+8LFi7rVdbr+BxqHuTyXjvmRpHyLttOXc/1DmcZ005kFq4HyLiFHDxiVHaiDZVJcCrIa1ESJJphZyMmC2B0MicSaV+OGsoqfMvPyjew7rfEFvPo/NQT0n7Jb3X7gyI6YLlow2/iDHWNMg/G11J7mseoC7/ik5P/RQhxMFdbeXPwiMmooy7thpzneIsM39vVMurU6bKtwcINjA25shKQMbv/7Q07QiiKPdeEJOJqbVlgzBARd7+/N79MABexX4aNBZWtd8bpuuH5pIdgn+WHP0nmgCsFNUSu9hIx2iO+Xp8FFUpJCij0c/HKqansXaOxUpUr3MoagdnwPbuFaoXAjEwbObAR2qa8XbaoTN51eLFCOi2GtJKw1JM7KzpG/fqHwLS4u4HJsN88ooHanN0Ojo/VJqqXnF6e9P/ksudPhwljrUmJyEdUdhoXYbBUBDjEmJuem6CZ5lACMwMNMUmsMVTJbyNM3snstz5iWeX8nra95lAPI4rNJA3AHb3wPEW/frQs8yvq3p1Pi86Mt4XJz22bsmPCuigzDJDdd+KCELlR9xm7Tc4FwQEYYdrN/84FOWM8SIv/+4Ju/XsfzJjxON+wRlMJuOGTTZEzClHtaLNwwdaFJOckwfu97sdE/iUQKX22OpxmCCBB8KyU7C/ko6kHAqsoP8tOWd2P8lekXXRZjn2TFO/y8gGRYq3iatnh7LJA5P3mf+jo0dMjiq3u4EaUmja46gvZ+ipMdlaPdFG1pMDfNTM6v1uGp2GnV1A69jCyDa+YnmNCMGjq1bCeswhewC6cYf9bIAIUXXYx
 urL4DQgk
 DG49WOx4mkumKbiUpgcKteD0L4XsCg1H4B3ZtGKP1SwPfwCu6R2HDnj0cXpD5f44VSc3/Gmo3qkroHUWfBszY5Jmfdv7nGGqF8YuvqxVIsGVl27OU24xjVWyKiOGo90bhpHalh+fXrbWZKkdz0sjRBjNoGZjc/Ertq+xUTIv2SPMEXk6stvR5JdLrnf7O3o4+7RWU9KaXvP9R9nsFjo1Cx1ogOClZ1SzWi0xrLkYTo0qmXmj2IicUImniFbpzxrYFLzEsN5pCK0JHEapTMOpayf9C6N4zFy5o8oDps8t7cTv9zI961TBrl8LtU5F38zCys08/PMhj6x/9WXFypPC5AKIuM9p9JZqu+e9UYwAfOhAF6xtI4k5wxHmgft0PIirLJ7nDwKYiOJaFgj97EkY2IXShN40GnN7UcCfcfr0aiOQibdgtVDVJHooFRdjNCgVecxRsWA3vHwTlPoNLOU9ANDSvn7e1soOsBtTflupNif2ZhjBDqKbb7Y5n3lp9levK/LerpYakApv6uIkX+yE59iYl4x6UJAN9JcpGeV2llipMiUn84oPzopSlHiJ37cdPTPNrhTFdanqg7Zma9bJfo+DQ+NEYCuLpWV9EFE+g35Q/buqbXlt89wxZtRATQ+wBz+U86Ps7sbBCMPYjHjkTo6G+1v4YqPnLdTzz/rL/Coorb4VXlPSk7qzHw5HQORrRpDuZBFFAxEZeiJvnX0GbaJeFBX6QKzoo0MQXFJWvUjtzZ3fje3bBaVJozKFmnTtwPiQ2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 11:06:45AM +0800, Miaohe Lin wrote:
> Would it be better to add a helper? I doubt there might be more
> unsupported filesystem.

Thanks for the ack. There are more (CIFS and orangefs also report the
error on close()), but Andrew has since replaced this patch in mm-new
with e747ed2c3418 ("selftests/mm: check that fsync() reports
hard-poisoned dirty page-cache"), which needs no per-filesystem list.
My patch can be dropped.

I tested mm-new 87cdbd9bd631, which has e747ed2c3418 and 44191f78d131,
in a virtme-ng guest. memory-failure now passes from virtiofs, where it
failed before, still passes on ext4, and 50 runs in a row on each were
clean. I did not hit the unpoison -EBUSY on virtiofs even without the
ftruncate(), so that part is not covered here.

Tested with the help of an AI coding assistant. For both e747ed2c3418
and 44191f78d131:

Tested-by: Kurt Lin <lylin1023@gmail.com>

