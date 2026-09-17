Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85521C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430C76B008A; Thu, 17 Sep 2026 19:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1606B008C; Thu, 17 Sep 2026 19:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7966B0092; Thu, 17 Sep 2026 19:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09E616B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:57:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A08D1C28B4
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:57:13 +0000 (UTC)
X-FDA: 85224917946.07.92B35CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7CA761C0002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:57:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=M41eWb1A;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789689431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okDvTsO6fMQp5UAsrpdoSDKyHL/mxyvqlyiV5FJOiJQ=;
	b=zk4thNpxgIcMPmDvAk8j6k8nYs1SRnsPFMJDhFNAGNKLMqVNQ0kzsRwKi0UFNtbvbCch+t
	i3YfBOLx/69A4mSojzhccqekjPXD9hMt4sU8dkoa1FBUAgyTBMwFpxOVOwYaXX0qTbgXdR
	tCQN0Lk7GevrGI6Y4EkdFBBAQJCmMV4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=M41eWb1A;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789689431;
	b=DN3L+jHjRwaeW/UdBNDghV9lYsla7cPZoou/sOh+cO6GWPU0HgO2RW38NY9ExDVYRaqz+w
	ueay1qgPEY8Js4X5BL0TkitogoO6+s8yP2M1bCuw5BcJt7QwmK0Co9x2/VNqJdj8CGFbny
	RFF2qVcxb0LRukXU0xjbCXwqiPr/AzA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F66043DDD;
	Thu, 17 Sep 2026 23:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6461F000FF;
	Thu, 17 Sep 2026 23:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789689430;
	bh=okDvTsO6fMQp5UAsrpdoSDKyHL/mxyvqlyiV5FJOiJQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=M41eWb1Aamc30Pu9mvZdY4CNShDDW5roFqOaWSyyS4sL1qEuksxPjyYFFmigSOsbg
	 ITwKrF9vU6YvlgyMOJxgZdeu4w+pkTCH7LPWY716hVQhlbzPxA+WJJTUSfJEUjGnHc
	 K/i58BTWTIfAaS26v0pvxgty4iCU/ynPraxtxBwU=
Date: Thu, 17 Sep 2026 16:57:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lisa Wang <wyihan@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan
 <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, Hidehiro
 Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, Yu
 Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, rientjes@google.com,
 seanjc@google.com, ackerleytng@google.com, vannapurve@google.com,
 michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com,
 dave.hansen@linux.intel.com, Isaku Yamahata <isaku.yamahata@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v6 0/5] mm: Fix MF_DELAYED handling on memory failure
Message-Id: <20260917165708.0ffa717945e3e81dc7c25544@linux-foundation.org>
In-Reply-To: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
References: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7CA761C0002
X-Stat-Signature: kd8is6sqzjgx4njygyr5trmok5hpsnx9
X-Rspam-User: 
X-HE-Tag: 1789689431-201456
X-HE-Meta: U2FsdGVkX18GnYs9K74EN0jB31aGIOOeLWOUAbvSf+5YTShKYfOXB3IMsqTdOLhT9Eqhb56UFBmo2Gs+OAYFASZHMdiOclFdeu9Rh2EZJZok7zIRIslVa+t723quqmDHDO8jdfxPwJcnPgC36hCtWZzPpn6WZs+HHS95IuTw+jkZjujKD9+k1af0BhbZQqMP5LsEevs7aEBXgefFDwIPdCS+plGqNp1fjpHB6BExVkKMtE/uNT42V4wVCy/7nTFveQqKZsByJJ6IgjTzugJQTF/YyzfmT6V9mKOwmmmGzZqrN4QPgkUEisZtDiqO3f3CHtMYTalqritNFTB7gpHjcyMGXjRzHVuNFmOCUQQl27mVrU71uxGKb6S40RF5/OybY2tin7K3eedpZu/cY6J1zmGlOD78iauGDuw+KennpjnR8aq6ayN9dhKnPbLoAoI4PG89cnc3+S+t3Ta3f2y3mPbVIFlM8CxAR6z/mgbyAC6TTQN0oqC3e4LsLm+tXQeE5dRIGwLBTz5Ivr5VBuk5A+sNYP8+IQt6aC4cJqnGNa/yOrUg6uuHYtPiDv7Koen1oWkWpjqmhvyfGZXJ4BTUL0NFjWhtOtE9AtlEp05M640ukgDjqUmlOkSXRT91T9556apRQCYgOVxcD5HBIDw/bHh/0G0/1KE/bxWkZhLJD84v5xFXeJljpgaUKm/+bU0WlaYuXJcQESZFyqpovDeRFTyF3N1wx0dc3qaYemurYNZW4VgmzjcyFONKYzNV5C0x0V2HoYMmfxTxHLyfBYs9AVAUaNkAFyqcq6jZqVPmWOofJqrxplJHvTeH+SdPTxkW77nx1kZZsTlBeUrWC+pIigq/shDCJFYkGTqlUhbdKx58gdTG2TsrFs6yaP7sZUX+cTrSZ2yLwx+eidFTougLlpDchCoHyyPe1pyBhQOR+bDbTPNX+uAuFCnU7nEy/XPfh1lvzL8jsS60QK+p1IT
 1Vuej087
 dULyrQwRWZKj8rdcnYz3/ZW8QiMytCznpzFgeywJWahkUlY9GeqhD2LsPpWVPtRwKqaCpS3YSdiRWuwHbEr9EcDA/StELmxhH30XpGea8lcXIonQ8Z3cJjdgxwclLpuPp2SqaJ4UjfwlkqA61Mn/b6oLBKbUrq4abcYhNLtOe2GJvF5XIsHYOTvYMvWwr2DSpmYiHaI/nQVyFkBe4S9Xh1j9C0J2vsVlxlbFWOul70uCJ532OD50QPnkEcUkWF+8yl5oPMmVQO7LKgkCRg2hPhfRi1mK7bRKaNscsx2bBR5DceOQSAlWCkAEs/suIpgC5bD9WdOpIF4P9VxYbcRa7mgC9S4+6aKXpMIjWnYi+WqY/7Pyjo+K2clhRpxndgoE8cLFBPnEcZjY2ghI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 20:43:46 +0000 Lisa Wang <wyihan@google.com> wrote:

> Here's a sixth revision to fix MF_DELAYED handling on memory failure.

Thanks.  Yourself and your reviewers.

I've added this to mm.git's mm-new branch.  If it doesn't break
horribly then after a few days I'll move it into the mm-unstable
branch, from where it will be pulled in linux-next.

All being well, a few weeks from now I'll move it into mm.git's
non-rebasing mm-stable branch.  mm-stable is where we assemble material
for upstreaming in the upcoming mainline merge window.



