Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E47C5C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 01:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9F36B008A; Thu, 24 Jul 2025 21:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1AE6B008C; Thu, 24 Jul 2025 21:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE9B6B0092; Thu, 24 Jul 2025 21:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7026B008A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:37:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2CA5112932
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:37:11 +0000 (UTC)
X-FDA: 83701073862.20.8E0B5F2
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4337C180008
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:37:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uNfQ4Ypc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753407429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZovQDznqkF7J7kMTz8uO3SRnta3pooBtF53KCWVPljQ=;
	b=HRy6FoFHIlsOVO9VPSzJEnBUpvlelgZUxNjH1tLAKju6B1CFuPIEBemiTigOlQBhHNbrAw
	Nc2s/+kfblKjr5vv5TTlDqH8Whq9PMUeaihx85uStEHoJqVjrRvUsVP7Z1GUmXxJoxH/ob
	SPlWMOaBUHSR27o4fRnMugqIfFwJHO8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753407429; a=rsa-sha256;
	cv=none;
	b=if3AZDZKRjuIEIVS5cXLElDbAUSq4UFayg19M3PF71RBk4EcavIF4dMYslXsIjGM4IyfXh
	ckbOLqY/22sB46zx/BUjG5RWjTRpvV1xLEgZoJGOD42I/8UCN97HHGojWAhJOnzYCmlqM+
	TxH2TAug8TYPPXj2qro8lr8zsM7Nrbk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uNfQ4Ypc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753407425; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=ZovQDznqkF7J7kMTz8uO3SRnta3pooBtF53KCWVPljQ=;
	b=uNfQ4Ypc/PiDiML7vKZW7wRgV6BmcEU+eZK98Xy5UnGwbIcPQZli63DQZYsrPzHvwUkE+X9SmNBaogBuf1G7SAKk//cinYXiNlFVd8tZjKs2Nb0b9nzEfdRihhMijMujWt0QidEwcKSqx7XxpyWkr/7K5YXTyx5uEPggj/tDqFE=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WjudYyn_1753407422 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 25 Jul 2025 09:37:03 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Huan Yang <link@vivo.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@redhat.com>,  Rik
 van Riel <riel@surriel.com>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>,
  Vlastimil Babka <vbabka@suse.cz>,  Harry Yoo <harry.yoo@oracle.com>,  Xu
 Xin <xu.xin16@zte.com.cn>,  Chengming Zhou <chengming.zhou@linux.dev>,
  Mike Rapoport <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,
  Michal Hocko <mhocko@suse.com>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,  Rakie
 Kim <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  Alistair Popple <apopple@nvidia.com>,  "Matthew
 Wilcox (Oracle)" <willy@infradead.org>,  Christian Brauner
 <brauner@kernel.org>,  Usama Arif <usamaarif642@gmail.com>,  Yu Zhao
 <yuzhao@google.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] introduce PGTY_mgt_entry page_type
In-Reply-To: <40cb7d64-0b90-4561-8e10-06a808a2766a@vivo.com> (Huan Yang's
	message of "Thu, 24 Jul 2025 17:29:30 +0800")
References: <20250724084441.380404-1-link@vivo.com>
	<764c48ad-8869-4f69-898e-0a1c58684f7d@lucifer.local>
	<40cb7d64-0b90-4561-8e10-06a808a2766a@vivo.com>
Date: Fri, 25 Jul 2025 09:37:01 +0800
Message-ID: <87bjp93vb6.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4337C180008
X-Stat-Signature: cuo4x8r5f31efxcsn565taqt38uqmpcz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753407427-856016
X-HE-Meta: U2FsdGVkX1/qFhJSsNFptEEXMOi5pp57661hw+BcCSMSq7JK31u3WERBlzUdR2vQEZPcwNXxT0NKj7nHDsoG5eRYi9ott3epIYKtF0DHVaCOeNazUUM0JjuIVL+e1rDSMZtx+dST18r+A7YNW9U2pBX3wmpjkfwc5xga5AIsyFTBLeWBxSXq1uss9QkGBfdA55NXiVJS0tnOpTTSFjjaJ82VQOWrjaXIWsTG/NIvv/CZQ1ctcCEILKBtL4J73Wso+tTlTlnRU7dbgzplEa5I/j+dcZAI6A3PN0lNCEb2CnQ9zeft59nmUsAs0UAflScDMOmHgzaEFKZUJppqIf6bBsq9gQ6HnFcBpaIWL8QZ52SWh/32HLTle/vlOsMINpnF1Un7YkYv5a2vYK9pW/lIWmqRX96E3+yOch8Jdyv0sOv6m4kNckeLcl2crtsOKMi0O5BiZ1rpOIRli60eKM5n5jOu5sWIzkT7cEnJYpv+igxYOKCxgxBE8IRe4EzGaW1Llt3gJmMBpWUeZWeLDLnMDkahUwkiB3C12ntQ75lMCpunToV7ep6A42gksQwTjhCMHJC1hbJKVhxCtdUSXM8JvdDhAYMJklbpWYGIJu5qz0diWwUklm1FQRx9aKPd5tBr6ioqISNdUpV6MtyLQbG2oEPWF0renP8MjkQW9a9S1tT3cFlrYEGmJosPeJf+m7qWg+Ivj9mu295EfV5klhypc4xWYNB83/eQ3HwS+G0V0EmxKQhFdhEmQb9KT5+/vdvpbqKLV0TOv8SY2NS6SAbruj2YsvdCYY9KojkR0d+lOhSoJll07QI0lkub+l3XLDWdJWM9Qf2LQFKeWF6k+rDiJhQMVQOiIqniOOB1ii11YeL5PVTEmuOXzMbPyKOEPuFVGzJrsLkbP09Y8hblnu1pXDs9WQuB2b/k78DhHZTFt8Lm4cSPZcFEXX2eeQXhdSaRNomjDU8sGRmzCL3B8hQ
 kmXOMbxO
 RCmaMR5pddASViOS4xh0XWbJzJNmjahr9pBspqcxkKlyfZvzDnVfebuBcO2h6F9dnomkByw0anWBBeTTWGpQTzOk3mTfeObHdTh38Yd8fnSsVFRGZoAD+GMEF+kBLaelRWCZwo50lqcZNpM2j5QWagn1MO+rVYlWVv5LNDel8j1pqaA3rt6DI4lS6g8AHTVXo2ax17NIYVEjngS2tHP1nYSq5Zba8MVpLFY+j+tqkV6A3Hzw+4GFfBAWSg1V1lPAgfsGjCNjffGkBAvchzXeeZLC50U+dP9t7Ozxw9A5XIR+kBfM5aaLlInD9mch1SHKLtw8GIyFdujr4SE1Yzwh12Pv1ivyppbm0wWz/5RvYhQyxE4c9/sOR+/Zk+XdnWj0a+sTaks6sdp4x5duSswgC89W6UYf/BohgdmdiQYqs5V8h7WM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Huan Yang <link@vivo.com> writes:

> =E5=9C=A8 2025/7/24 17:15, Lorenzo Stoakes =E5=86=99=E9=81=93:

[snip]

>> On Thu, Jul 24, 2025 at 04:44:28PM +0800, Huan Yang wrote:
>>> Summary
>>> =3D=3D
>>> This patchset reuses page_type to store migrate entry count during the
>>> period from migrate entry setup to removal, enabling accelerated VMA
>>> traversal when removing migrate entries, following a similar principle =
to
>>> early termination when folio is unmapped in try_to_migrate.
>>>
>>> In my self-constructed test scenario, the migration time can be reduced
>>> from over 150+ms to around 30+ms, achieving nearly a 70% performance
>>> improvement. Additionally, the flame graph shows that the proportion of
>>> remove_migration_ptes can be reduced from 80%+ to 60%+.
>> This sounds completely contrived. I don't even know if you have a use ca=
se
>> here.
>
> The test case I provided does have an amplified effect, but the
> optimization it demonstrates is real. It's just that when scaled up to
> the system level, the effect becomes difficult to observe.
>

It's more important to sell your problems than selling your code :-)

If you cannot prove that the optimization has some practical effect,
it's hard to persuade others for increased complexity.

---
Best Regards,
Huang, Ying

