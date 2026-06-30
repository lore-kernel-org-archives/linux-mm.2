Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1E3AC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9486B00F1; Tue, 30 Jun 2026 10:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD12E6B00F3; Tue, 30 Jun 2026 10:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC1526B00F4; Tue, 30 Jun 2026 10:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A51936B00F1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:25:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 202171681A5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:25:52 +0000 (UTC)
X-FDA: 84936802944.07.36FFA43
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 504CA4000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:25:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gSOOuZON;
	spf=pass (imf12.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829550;
	b=2z/H9YHbsmu5U3wLWtRcYw4XBtSKULF179dY0ta/CpbbrCfU0O11yemqAnpcpXnh0/s643
	ViJkk2boUbmmxFJqZPMnk/AA1C0vakkLgxZNN+fpx4znpEsj3+0xCneSOrR4iUF5K4hZe7
	eL4EDIYIzD4f3QE7sJdqNYN9KEN9UM8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LyaBlvtzLg3/D7avMailtRtNnHXXt7CQFthCD76A1P8=;
	b=O3V4niHSeMkWitWoQW33Bhcm/B08fGKMJfShWygQHzsbmc7Ynxfcf4pYUusf5W8WaRsMvn
	i/8flxoYFl7uDIl2Wi0D4HbjkGW3ppuFvgDkXPvCrQwxU9xJwKt6zbMLapxbdviTucwCB1
	VyNZQdw6Lkqb13Gl56NISvwecds8iWs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gSOOuZON;
	spf=pass (imf12.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5aebae2f310so1617926e87.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782829549; x=1783434349; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LyaBlvtzLg3/D7avMailtRtNnHXXt7CQFthCD76A1P8=;
        b=gSOOuZONM1dLhyCvHzPqfGmi0DPu5Vh7x7iAEyHmaK1lpUc8m63dJ3blwqAAOSYhAT
         6Fs3k2Ks/LaoqLsEIRqdHma3zGQlSCxvfAFDGbGyLE2F2gZtCn4CLSAZ8bvjPCQXOn8a
         DzkwmJxyYpk/k0Phegc9qo3UXCF6Uug6f3rzAWk8YSUXA1e0J3jOHwzWOX5ANgAJDXM0
         rnowpwy/oHyQIHJ3W+f8oSpv2rMxUZoOO4UifnJAA/RYV3Ip6xbY2b5px2k0W7LNfBcm
         WdLHCyjPQ1QswjsAoCDKgReU0x+Syzh8xw7I0OGyh4QKikKWH3TbUH6gl0slbgR2nH2l
         1IpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782829549; x=1783434349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LyaBlvtzLg3/D7avMailtRtNnHXXt7CQFthCD76A1P8=;
        b=KmHEo8CQjGu9txeWIR4/s1W9WXAdxJXupsiCf/o+RJ4rv65ZhICg1bxHKIu+xLQy8R
         X0eXccmCjPDyCM0rqAI2EtZ5q4DvwexRc/epunb2C4HDXpT/8z2KWiOZvg5GNroJu7jb
         +fobKvji7HL0861ycWoBAa51qnJc/VhZ63CfLOQFBhHdnlwpcedFIVBslUbnIBwyVu9K
         h63VKTVciA6swANIavZiwruG9CTK9h8C7qqpSk/azlBAxPvlij6zB6aojB+oefyeVi26
         8gdDHt8lnIBCpJYD6EFOUUl32Z9d4trs61G2e8M2octOoUXJ4xr5GAxz5W9yvuIzo4jf
         cTcg==
X-Forwarded-Encrypted: i=1; AHgh+Rp9A0AxftC4y5NfcPxmWw2k3CgYu5pwTXbe+CFs6p6X39Nas8SMgqTlLBSVNW3FHp21LcmxIcZ5oQ==@kvack.org
X-Gm-Message-State: AOJu0Ywg5f1aK1x42/Rz64WSkgzvXHJxRL27igGEMZNa3Zn3MyVVo+F9
	S545VPwCGM8QRnmWKSR/ayrxwiiWke+Q8IdB21W5Gy69A+OhHvmskF5g
X-Gm-Gg: AfdE7cnOPwGdw770nSZxBqPT+pvYQ/tW/24deqIt63CIfzn53I1c36ydogcUBB4iB2k
	Z+9vJGdEiUTPD1fk2Swetj7YdxBUrs212dN2wiBynuS2gcFUYuvn/Hto3EEtY2yFRMjBPeUE0ir
	4ih3eFVB07rmSiB3Cy39UNjLgXhSxifFiBYcBLdQRBHnEESTDZBSmPiNTQs+xHsXVHP58HkzPzh
	ysojFobbXaoZEdbNOnW530k6U5ieeq0vF82E2+u9MuvXgFwA+hlh1yB058sER+XIJf6VKEciA36
	6SdJT+uLdLJnccHDJJ20fJSO7kL5DcYCN6Lu9cOBzQ29s9YoEKOqkOdZDolDrcFroI27L5dS40J
	aFfT86yfYpGroSg1Gve7lXoxEA914rBFgw1cAO/2BLqB07SpKiqAfnLbzhXLkJMwoL7NBrBCdiE
	cZr5bBpZUd07vqft26uDanNPFmPa0AMwM+q47ymFyoOB524Iq2CVnms0ae9+gf+oPm7e6rlHy5F
	Dvp6hHMQzJQNi1j+g==
X-Received: by 2002:a05:6512:8050:b0:5aa:6fff:c3e3 with SMTP id 2adb3069b0e04-5aebdbc6e03mr726250e87.33.1782829548247;
        Tue, 30 Jun 2026 07:25:48 -0700 (PDT)
Received: from debian.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aebe4985eesm629795e87.46.2026.06.30.07.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 07:25:47 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/vaddr: remove redundant RCU lock
Date: Tue, 30 Jun 2026 17:25:22 +0300
Message-ID: <20260630102400.reply-damon@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629165349.4260-1-igorpetindev@gmail.com>
References: <20260629165349.4260-1-igorpetindev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iysef79ecfwbsxhhjfddk4egqiep4dq9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 504CA4000C
X-HE-Tag: 1782829550-844366
X-HE-Meta: U2FsdGVkX1/J3dAcHIdsG0rg6NRJ/ibIYQ5JDMt+nzZu8RU8cknI91RrxE1pr/wMangdb2iUQNs/G3prKdM2msyDFFvpehteU7L22KWTfris+IkoVHXzjD+sd/l7z5DQILZ22fzRhyyJdgh2gIk9LGJ/EWFM0NHAQRqgfxJ4VnOVlQ9UbvTtZC+/1vXaRXgC/04AX6cZmbYQEjQwCVrPvM8QKz8hATk9WB0kvWoPyx2dhMlpJzLmiRl7RUf3Hk4AY0yTU5JPbeaRlxgTOOMFpTMD+3bBftr8fM8dWgC2cZ7OiKxKgCrk49AePte6c0qC7/EzsfgkEzMhoyG/SpOgfMXoD1aIjn5b2Zzxd0odsvAgWHdttsHHxuxm7nmM4kzNQ0STeeEKW2b7ZWc9j5efjBZ0L/qtQuYQxCWYBwdZr0Y1FXw/zagldPQZt6fsHgDMgnsnRl0PhK+yWv4DeESqGyIeC5qKo3RE4b4V3F0duhCNOYOdHIvEDpd+4uQ2cxKanrpAs1gYpf1PyOQCtoU27ux2aaiJ1wae6ZvF5EVK9BSe+0vnVTRswtDmMA53FWVEQzQhAxcU0RJj4FVzFMWokPOhrK6/PcHa+6e5wRM6jsRdf+p/TgXWpTYDRj23J7nWA1Qxw6nPnxkHU0fpn92Km5+RQ6CQ/VsOkRfBg+0SB2VsfKbZRTSwtDyp5Rd2KQnOo88btHjpF/SOihOI2yg7jUyOE9FauPT0fUH6wCRKlCkhefmgoEwdS7Uh6HKrAaBh6M1+fh9syqtWFkjVgNSsCJtqOU+XeAeaC/2dvVhxFPOqJdPi+7qfPI2pU5pcr/Pnuok4C7ecSO+/ScG8UspELxHRXiOnS+8rt5qoD4pSy8lO5ZR4oonrkqPb4MSHWaLxqFiHRTOxetyKzONoUv7pB7yY2PQz0SZ17nzlzDJlAvbfSaFYscNJuKD+7frXASHXGCA1NJYxuNgnIx0YzTv
 7e687ort
 C36vAB5CAJh+iYibKp4yqHcHsoIsSbwLHRoJGoHL5nIfNwcpKPh2QIJK33UG9ybGARfjzPyJA415hsxisteE6V+UMXyOo9JmwNy4BZNi/pLog24lO3TYqMz9JDKFYQuIdjmz1gbw/LG9rgZzUxdBgQ0NqQTzvUtf1mx3/a5FBvC6vHLbU/ePyFkgOOsUSZ8fOc6QWCLVcQCfIqk8LyJ16rF1QO9hotcPyrUkq6NSWmjnLKuu/9e7qgTXLYZp5AHAiUldwajj47qwooypjQIQrKMqx+aZ5hEK+ruAzRWTn0OCEXG3nJgzW6tkrEx92P6kmXf/nMjtMpRW5DWQD6cXZiZcrlrPQowujNzsWRcvfv1AWRMfeqUOt7qNi+u5U6PZXNgZHg4lE4xhgeW1Ri9zkNLjyxaY+FEWIZAJ0fJOYOlRF09qwB32Hp1X3l/AHIBmSnav+7ISXXQ3YQK7fj/bV0LYpXa7vmTnPXwbWgRXR5ZppRkvo8yzVo9T+tcAgjAKJStaC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Thanks for the reply and the pointers!
Regarding the issue Sashiko AI flagged - I dug into damon/vaddr.c, and I think it's a real bug, but it's isolated to __damon_va_three_regions().
damon_va_walk_page_range() is fine here, since lock_vma_under_rcu() handles stability on its own. __damon_va_three_regions() is the problematic one: right after mmap_read_lock(mm) is taken in the caller, it sets up a VMA_ITERATOR and runs for_each_vma(). But mmap_read_lock doesn't stop the OOM reaper from running concurrently, setting MMF_UNSTABLE, and leaving empty markers in the maple tree. Walking the tree in that state without a check_stable_address_space(mm) call could lead to a NULL pointer dereference.
Since this looks like a separate issue, I'll prepare a dedicated fix and send it as its own patch thread, so it doesn't hold up the current cleanup. Let me know if that approach works for you.

Thanks,
Igor

