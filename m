Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E4DBCA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346326B00D6; Thu, 21 Aug 2025 13:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7046B00D8; Thu, 21 Aug 2025 13:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5DA6B00D9; Thu, 21 Aug 2025 13:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 05A416B00D6
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:15:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 737E113871E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:14:59 +0000 (UTC)
X-FDA: 83801414718.11.4B1F634
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DD3B814000E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:14:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pk0po0Ju;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755796497; a=rsa-sha256;
	cv=none;
	b=I0cLfkyxUMHBKfdaAQghR+e0ceWkepqof8qC9boDMATtWJ9prn+e5yTtHpDsbMAIMp2Sye
	rNGzxTEYvkTmU5NBo4tD+l8GXAzXzdFYY0thNifBmxMPb6qWj6L5ro+v9CA8e1JxXnTgcK
	ODNqA33775pAIYLf/cyC5ou1f3aYzP4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pk0po0Ju;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755796497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWovGn3AAZ1iGaU3OXOZ/oB7zoKtK3AAKr4Cq8IxPS8=;
	b=GFScNWF/UKAwi2yfNvIx4uNcmoqO2KkQOrU3vj+u5u1Q6drnmPqPgND8LCaq5qfn6Xuz2u
	pn0a1LPFVDGrNX1ZPzNnsNA5uwKFQt1iog34UtUfOFR+knoYYQrqV+wl18NXHAEukJdiow
	52/MkSjfMQctHKPyvb+wDTuJjc0aKhk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9AB460200;
	Thu, 21 Aug 2025 17:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E452C4CEEB;
	Thu, 21 Aug 2025 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755796495;
	bh=1vDDyQ2wAyO54CObnl6lZo6V3Vc1WKcRhHbyiY2WM98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pk0po0JuG/OGdbRlFS5EkZOGFJwN8zM6BkdZ4VetwSLqGgBvUOLDdWBtB0kBmar8J
	 7Co0+7Rt0dl9btHy2uBveAcTAZVxaeiAbsOj7jqNzR2KAz+DYGJbkZRt8EX1bAwqMr
	 QyauX7LRl8K/qQ/KSR4Kjff2oFgAuEcs9EdYnblhOZot6kdMzfhxJBbi1uzND2d/Xe
	 fIVzm0zsMoFaMslY/NfoxdLR/WTjc+rhpxvQxPLMELoSYsRT8C7cJLiitcQv91qGQc
	 e0rES61qBQvfV5qh+yk+c/tu8SVY3iTgH40HOzYSth19Yg3jk5XcvLF7XLx6KCxUDZ
	 oSH4mz4tQnlCQ==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 03/11] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Thu, 21 Aug 2025 10:14:53 -0700
Message-Id: <20250821171453.81776-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821105159.2503894-4-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DD3B814000E
X-Stat-Signature: 7hmw56q7gxp6es8cxhz5scubike69pmn
X-HE-Tag: 1755796497-776784
X-HE-Meta: U2FsdGVkX19Ei3LAzFacdZMuw1d8jg3yo2PPm+IRSrTwaSitQgs5T5tGPB81su3xGDZiU7A/8g2+9JGmGlQTAt1uG6JbL76FImoTVNZLuEMZoDCMwrhGKJ32dyXTsJiema9ukVY5/f6QtpLAMWZ37vQD35FyyksXLzPIDFcsLkxCoTCsW976GW+6uRikSCEzEIIn0iyYzGXIK4o9ULGVqveVqAcFO6iiuMLk09XwHTPkDaz4yBy7H85acpIUJSfvWZB58pM9SS6zi6eFsK7SH+kyMG2efeYxRNIcSqBe4Yjhyl2cpqXp+IeqdVZ/vE1UI6D7O+fsAra9yjy0YQv/4PCTy+hdbqeFg+f7Nfc+s73HzjNm1TqmxTqUFKeNYzzFhcdZ6o0k0f+dl+nj9qjulxUWjUBLm1ps/qsGudl/l9twXik1joBi5dyBZDbu/8wXP28ByYXTF+RVu73agh9D8psrfjIAsQFAn5JyV6sSzgYVc85VMmMYHJDMybcjYy0M/dK8GL9nObqXsjb8iRElox7YKuDhaDiAbFHVmg3FhuOcD3cKUaBR0ZmDHhVufibtq6WNKybkqNhR2Iz6VdSkcSQtSo9TYBbTJEJgu8dQcbzXmtfXMpLX5NyUxb7syja4ZVYQgUlD7aEYoVNA4LLUkbXhSAancPOsnZCxqwEcBjO7pUmSyVeWcQKasDkIdRs58nXePeIXyVFiJokngP8Ug+fFQGaMMXGJvmDHZ8BMu4X0WwfBn9U90cotvrF/cLqshmdbMbUrwuMPzuAYnk2H8ZuElVukEGmaP1JkJ/8led/HnlrlWWjdRYFREXSigqvuDprzIZMkUsR1ijlzcIgGZYTfuOhfo1cAbpY/9f000agdqBCPBAJKaNR6GwR+snHoVrFKEviC8VgH1UfO8sICLT1EzHpHnF/z+HrnjjEE6BX7apRX9WKkicNEQyCxMDd/amDjwqT47F/Qpb45IZt
 HG9Ny9k7
 Pc/DUWZSPCi+4U5CTmk3vm+zGvfZ4+ouUExqSF9OqaryxwuVSCuSrvF1ZvBGLsD4h+C/dKdmmAr4oAXOSryxPwQ3A0oejZ7ve2WKHr51LeYvVMIJFdqLv2NZv5srpG/j+D/OHe2XwhXJOFWQVm35rSzTkTtE1ZTFxxDBaNCs3H6v1Cz/Xaoyh1Z66IR73rvJSTzOQ6NvtHy/bS5X9cJtoXQBaef5ci9aehThbJ+9TeorArxUKgbyci3EACCD0whUuHUYUCf9odx95Woo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 18:51:51 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add support of addr_unit for DAMOS_PAGEOUT action handling from the
> DAMOS operation implementation for the physical address space.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

