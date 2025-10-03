Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69455CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 10:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8448E0007; Fri,  3 Oct 2025 06:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAFB78E0001; Fri,  3 Oct 2025 06:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ECB58E0007; Fri,  3 Oct 2025 06:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8900C8E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:03:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F86AC0718
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:03:06 +0000 (UTC)
X-FDA: 83956364772.20.CE640E2
Received: from smtp153-165.sina.com.cn (smtp153-165.sina.com.cn [61.135.153.165])
	by imf27.hostedemail.com (Postfix) with ESMTP id D33EF4000C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:03:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=X9Stc1yf;
	spf=pass (imf27.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.165 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759485784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4HQ0uAVuNYpOL8R6iiIPkx6KM+urvlZg5GZtsx+od4=;
	b=NYK21lROVc682dW3a+oKlxCSflWJ3d/3Pz1mOPGWIk1bP7qpVVh0VBVdsSGoy8CBYDptoV
	tchdrJdx02s4x39DyHHoC8Epf7EYQm3d8Z1ZbNt8BDhivfKbtOL+nD1WBdC6sFmExnzaau
	chXWt+5/8nwWI/FS8oXHoUCHml4pAOk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759485784; a=rsa-sha256;
	cv=none;
	b=BRG5E3UYlLlZ9RzdejfGhrt+jMUFWPrazdCWMS51yhRYImfvT05fQkJjVzjKm/nVgFC+cS
	16wPx1AV1+vpd8wPa9JUYktLlWzO5iTCgWIrSl1XNVvouI0n5Px3ww8FQ3Yx1utq4jllV+
	agbQhShxoS/7p2/7FJB6Qz/saCtKaW4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=X9Stc1yf;
	spf=pass (imf27.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.165 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1759485783;
	bh=R4HQ0uAVuNYpOL8R6iiIPkx6KM+urvlZg5GZtsx+od4=;
	h=From:Subject:Date:Message-ID;
	b=X9Stc1yfC699NIdBAacxKK++d718IqjOorWuBbnW1SpFpBaJLGmSZvuIHVaMDURqL
	 RzRShq7OuQipBvT+yTwkHWKIr0GMWZEoXf67JA5hM183YJua1JKjTmdYILg73+XGAl
	 9XyrYQoFtm2xOHSbotPnqVtfpvZNwmEIz0zyUw0M=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.32) with ESMTP
	id 68DF9F4F000025B7; Fri, 3 Oct 2025 18:02:58 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 3485894456768
X-SMAIL-UIID: 6D9997E2C9164F5BB6FF3147098067DD-20251003-180258-1
From: Hillf Danton <hdanton@sina.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
Date: Fri,  3 Oct 2025 18:02:39 +0800
Message-ID: <20251003100245.8029-1-hdanton@sina.com>
In-Reply-To: <db51bcc5-aaf6-4cb4-ab62-fed9d40d6caa@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D33EF4000C
X-Stat-Signature: pdi5876xp44cwgw18zqjfgjgx777w4as
X-Rspam-User: 
X-HE-Tag: 1759485782-871257
X-HE-Meta: U2FsdGVkX1+pVdK/fyaiP07AJ3w/FDeElET3FNdQCsh/2QIDTwBcRX3hR7gpie4cnC7Ok6ccPW9leHiK1ShxhrgkUbYsYoMyDX6vsimuA1l2lic6J6OtKhJYVARD1u/vCcFRoTpxAfKezBQmf2KCjfwrWVuMl5v9m/+pw7skHKWh89yXs+eKmaa75r0kpNrsyja2Z9Gl0PjRjJJG1c4uwhkp2IO002JqJsL8J4ULGkymI9kB2mlOAXKTemZCGrNTKaWTgjJUPL+IQNYTQNI/sblxYMJ45BfzMdQTQPzZY3ytrKfEpSuT9LlisX3B/iSiRE+HKFb40xfZ5mCygUTeZax38m/74nP1qAiJ9u2PG5M9xh/fYqpVYpK7S6WGHw9uxVQBP5ekYKgiiCPJ+adlQQksNWTzbqW7gOrVAU0VU9Kru2Akog0wlhzKWtKhcXWlovOgPykDx5mzlQU36PykX3ReevRxxD6oRzaWHAe2hJjkfahLozA6Bh/pVBpIH2kgJD9we1vok61xssEaec0Bxa7C9aIODoMUnHxtUtHI5fJhrCtfKNpVaVYtYWVzLMDvaAaGvLhj2wJCWL+uEtiJvpFvBGT/Rmo/dknaBoKmviiGiG+YgEpBwPbvCe7yfoadSb2IXh3Y4RLa6ppXmF0jP2JmyNM+fRszE896SaQjfWAigpmwHIQ5LeoI12crIa5S+ZXW4uFxd7lTEzEyrZD2iHbHf+ucp3FO7Qyi3su3hgq78p2ikSOawGXjHFL5UIVgfnRZNUN9GztVEe3P7j782cPJx4/NT7OIVVNsQG9Sf4U5B/DXyvEOD5w3Sw4zDWoTUNYnJLuaPknHUNOOj8EqYJlfDqcCvwOzne07l+ORmJ6OfUE2A4s1BwH94IJ3pCfXOvPdw5QhBlsGzZS1F2C4tZ1NJyPaT2OHwLgtIvUxd7gfV1qXkq3kGpcX+V8jDdTmK8RF5vg73as5NJwDuLu
 5SiszUSy
 eOAZB3B8doW60tuWuhjR+Xcoa9L196rvQ6fe86W9MP94uhwNA0rCWzsIVkiBQDBgqhk+HhSDHdLYz2DzJ4TKS+ZjGfGqlFa1SuY+/DZkAlTDqy+JvZzYsTtgR2/6r4zYg0nCCPqE2fWtlPkOExfuL8BTetqo+lujgO4IWY1xauWyLzSMYqUBaLMrSIh8Z3UHm1Nv2io3vudqZd6/2ydLsHOWBNZ20uSU0alcMDtA9Lhl4ijnzu5DHnpFgrsIwe8XzcKUN/x4OfH5wfDBmXmedP4KQUnNhV2eMSyD4AkTUmbKEew/INRW61sJ9w+Yk1bYTzvqFGn9jlQeiHb2Lx3sHVvwu6ITFRd+g5idc8bjwBD9KlKVoXHb79Xz5Dmb9teLA7qJLfm12JzGM0JwyLCzmP0PdS1asf2ZDVJOzlwLl4JLVIAPBykhWAHRcXtKwFzjrDAN0VWX0L+SIFGWtnMsaR3Ecaa2Xpwqsy3UZ3EV0hhCt3kHOIo5hp/lD/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Oct 2025 10:35:46 +0200 Vlastimil Babka wrote:
> 
> Also you should really stop dropping CC's on your replies, especially for
> maintainers of given code. I've only learned in the v3 changelog from "as
> suggested by Hillf Danton" that there was this subthread. This is not
> acceptable. When the feedback is wrong and uncorrected by others, it can
> mislead the patch author to do wrong changes in the next version.

The Cc list was cut mainly to avoid getting guys interrupted in accident
with Johannes Weiner still Cced. And nothing more.

