Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 524D3C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 11:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193056B00E3; Tue, 30 Jun 2026 07:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144FC6B00E4; Tue, 30 Jun 2026 07:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B536B00E5; Tue, 30 Jun 2026 07:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D36DA6B00E3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:27:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41E6CC23F3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:27:03 +0000 (UTC)
X-FDA: 84936352326.29.0452A80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D3674000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:27:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAQYdRBH;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782818821;
	b=DZ9K+LhfeeeBYWkp5qw0iCCocqaHpG8uQh94X5pCueSV+j2s7D///GaphbKVbf2GF1A/zn
	Ha1wNX7upETxGJqhcXmoDZDCHxkOMaE6C0syEiqWmIPh/L0nvPkLwe9J+/yAGHrAidR2Tz
	+VhPqkem+HGcY13h3Zj6wjeIhbzGpeU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782818821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxAG8h4kM/7rZXKZiQjQ2jQZg02pbMyL97Ta5atq9dQ=;
	b=4bcu7zt6fCk1Zyg17dAwNyyD0EFoTmdRFBDuq8IcxdJkoDBVDWNqVvQvHasAd2JDn14odd
	4Kyda7ZZM2tJ/4l5dnG+obY23C5S02Bsj9Sen7rS5Q4IevEe5tWOv4vvxUZJ0qEienvL4A
	E21lB4eENeC9xx3NkTRvgUzdYHlOuao=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAQYdRBH;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 871F2418EC;
	Tue, 30 Jun 2026 11:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5761F000E9;
	Tue, 30 Jun 2026 11:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782818820;
	bh=UxAG8h4kM/7rZXKZiQjQ2jQZg02pbMyL97Ta5atq9dQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DAQYdRBHw43lPzoq4fB0sWxUrU7IRLMyc6rm9Hb/CDz+cn2S3do12mU2eGjFgqIqO
	 fXoKfn4VLfwrVXSRAWvY1i8Bq3CMajXwOTuxZfXIbafRbnduQlQ5YurEo6QZmYdOdQ
	 3BotVc9Wf4jWn1pCS/xLMWtmWUYgQXlDk9qZBc+SP2eCy22Unq9iNbmxXtszBNmz6u
	 JBb/KHUwHAD9zDmuOAFelqzLevMgItOFy4by2jFWsnKKLwpwFL1W/BtDnoZaHmUa/X
	 XgwkOYJI4hhGhC78DQ1i/V6P0PxFtL5x7AwIYJDLpKnJnmdgItHtf8CIAf9Dzgf4Oo
	 z7ONLAINffgZw==
Message-ID: <f5b23496-3914-4b91-863a-cc27ab7ae233@kernel.org>
Date: Tue, 30 Jun 2026 13:26:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <e18f075a-2203-4ebb-8f4e-713d386d0ef3@kernel.org>
 <akK9yo20yelJ_M-a@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <akK9yo20yelJ_M-a@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D3674000D
X-Stat-Signature: w7oodh1bgyo3io6b53zsg7pstgthq5d7
X-HE-Tag: 1782818821-897535
X-HE-Meta: U2FsdGVkX1/OwRr0LoXBC5u/EK5QWoblYPKa40hCxuyVVbxB5u+5HXBb1i02oKK6L0/f+v6vph0xkv6jYPa94sfXUg252+O30oR+x8W9VT8019+BJwKi+lUxA2rDxuX3Vz2OQb3YPYqV5y0aRLUqOvXDD/VrqAnzPPAamONK7GD+CrgTJL8mgxnKCdgzI2N952u74CQMKgWn6+UnUnfSQhyQg/9JiYXJbRR14SwoPourjgQYcGClX/NPYKKzAonKblx3FgJ0Q7tC8gkXi12ofIH1eNwdOaO2MXJEwixspIeYyLCsGDzlKJUTWaPw52VY+hci3QPuQKJnpfi71DyRRCM4ocn81BC+FejptwKsp53rqU1nyd/2zW2cbBAeUgGy7QiC5eCiVaSCaBVEydWpX4PsSwMQRsxkuopFSyfT2U5RZrHrHQUULA5cuWxwYI84MF8m4CJ2vWgeWg3wWmOj1asu72rsOfOg13dvfaDAuN46mEnZK8KVhTU/h3sjUILL21EaTJN2l8EAfTQ6CmkfdkXUJnc1ePjP7wupiH8IUrh5Qd98jm6/W8qjVrYXpZ3X0uJT+Nr31DGzxoVB3zHqSWkflWD2ndwgHnPQ3EaItap+84fyI8GDkVbvJCY4wx/Fz17L8cOD3VTf06eDiWpQqWQXbYixHIEoEE6tJqXSEHcrDKRIWxyTtE6c/1112pIxPbxS0wrCyVyziZlCEAUrbsVp2VEHnqVaYDujZz20zkRwAYGAWVzkDS7jcQD9U6+nUAOcKCHOfLO7Uppr0h64623em71tTPrNxqtQeGo9USKF+24zQAdKcJdP/dMgE5Rnn4ZozJvLvQZ9urDgzMC8axw/96FUPYvyHbroPA5gGcHTtssTH0E7qhCDp8jNoxGV3Clfq+WefWq55FwNSoKpNduTQ0dnYdag+MbGJjDelLwi+9JUN5qA4Xz7AA87oIe+rol1fOyhy2PRMxLcad7
 Q8HV6Ue+
 2AzQXBlaQnT3bhyJzRWUNBrg37QTVUgoivsNf9KaLaUXzM1J0S0Mym3Znb1OpowACKIPrlMeZ1dW4oreu0gWoEue1YNlD/xveBOaIEYV2fNj6B2ZvySEn1KAGM0AQIrEOj77NRT7pjm8Lp3TheQsPVn/q5tZ8E6eSbUUwBdXw8oWonCfOI40aZtcUtMa3C/QyTKe3TJnCB/DqyOgvKMaHmkNBOGl7Ycjo5VcHF8R7ORK0jqgUEP7RTdXgrJfljugljDmWQeiHJ7V025+JBYtjh8ZXfAj2sJpZJlNWHxZnIXQ/q5qg6r66DWaM2v1y0IvI0xmSZsqH5PPysELBRy7gM4HNHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
>> Makes sense to me although this is a source of confusion for me.
> 
> How so? Is there anything I can improve in the changelog?


Oh, it was just a comment in general around NUMA policies :)

-- 
Cheers,

David

