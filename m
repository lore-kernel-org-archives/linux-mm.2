Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD29CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 09:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27F408E006B; Fri, 19 Sep 2025 05:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255BD8E0008; Fri, 19 Sep 2025 05:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1924F8E006B; Fri, 19 Sep 2025 05:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 051B68E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:03:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89D55119F07
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:03:41 +0000 (UTC)
X-FDA: 83905411842.08.9482740
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8A4B640002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:03:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="ctz5uZb/";
	spf=pass (imf27.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758272619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejv4+a1Szt6NXcbVGJywclqiPFjJOmBuKdS8czeKkZw=;
	b=hzRsBLmI+lGMAtE+iXc8rBfbEoWKGqabktHjeE0O8ULDR5W6F9ubOadK4i7W4l9UYrft21
	gKdA15GT22ZMJwi5K7LxR2A0HiPJHSk5k4fq7Eyt4x7umGN3EUkfvjxRRRB7Iw20i8MXFa
	SojqpRWqsz4W6R5qEeBYcdKLDRvSG88=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758272619; a=rsa-sha256;
	cv=none;
	b=H6Ok4ahteF2yL4nFyJbRiypZbaaVN7tjlCGBjwd01VTjFoxUesWzHGJSXsXNt3uFlxw0t1
	avklznUmEqG33o/7XmSmGST8fu5AfNABliJuXoWKLcaQx3ypyUWa0PB+3mazyA3prOv7pd
	LeUE7A4XJDZXwROTKz19v9iF4L0JTUw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="ctz5uZb/";
	spf=pass (imf27.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758272615; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=ejv4+a1Szt6NXcbVGJywclqiPFjJOmBuKdS8czeKkZw=;
	b=ctz5uZb/4wfA1BZXdAdFcq0aqhC5/rrbk/e5iRUv3Tun7BPkA3NmccnN81BxQFCwWiumiFyTLKwQRhzGw9f2n1bldMR8maT1RmcLQFugXGA56SdAg8dz5k6k832oqLE2UBwYPNTtHFqZxlPICHQJql5tWclxsgsBUPoO+3JH2Bw=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WoJInQG_1758272600 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Sep 2025 17:03:33 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,  Will Deacon <will@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@redhat.com>,  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
  Vlastimil Babka <vbabka@suse.cz>,  Zi Yan <ziy@nvidia.com>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Yang Shi <yang@os.amperecomputing.com>,
  "Christoph Lameter (Ampere)" <cl@gentwo.org>,  Dev Jain
 <dev.jain@arm.com>,  Barry Song <baohua@kernel.org>,  Anshuman Khandual
 <anshuman.khandual@arm.com>,  Yicong Yang <yangyicong@hisilicon.com>,
  Kefeng Wang <wangkefeng.wang@huawei.com>,  Kevin Brodsky
 <kevin.brodsky@arm.com>,  Yin Fengwei <fengwei_yin@linux.alibaba.com>,
  linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
In-Reply-To: <aMvbNvCsSxQjA2rq@arm.com> (Catalin Marinas's message of "Thu, 18
	Sep 2025 11:13:10 +0100")
References: <20250915032946.33203-1-ying.huang@linux.alibaba.com>
	<20250915032946.33203-3-ying.huang@linux.alibaba.com>
	<46dcddec-88a9-4b22-920c-8a3edeb2f027@arm.com>
	<87o6r833li.fsf@DESKTOP-5N7EMDA> <aMvbNvCsSxQjA2rq@arm.com>
Date: Fri, 19 Sep 2025 17:03:17 +0800
Message-ID: <87wm5uizl6.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A4B640002
X-Stat-Signature: arm9urmg5m1hu9esdxa3qf86abssepk4
X-Rspam-User: 
X-HE-Tag: 1758272618-289887
X-HE-Meta: U2FsdGVkX1/ZScvt8jPi9BHhdjRBAn18kkUFCgKvPT49p0MgYuF1TfRZws507wxbC9ErnCPu7fOQO+c/F6ICvaSipo5KYm85oidJfQ7Ys1nTR9ZyRNpEJ5AdvYnk+OtH2iza72lTRWjq03N580Hs9a036D3XlllWPHsjxQGCb1nQc6SIpytyOjZSdrLPIS4d0Jx17zNdUGpAyfLnOgsHKriUdg4HzQlk7zlc+5Dbnfjbp2XxafA8LGrrmLHKZLwz7CC6aZTk7fyPA60FWjTb1hxAwj14gXmX/cO7cZ+u8qd6wnL/TS/VfBc2mj6g7xEdKlvM7Hvu4XdYZOmoTaeQqYPK7Gt0oG/EEjVwq/I7t3zlLO9y7X1eh2jEjyvAeM/h0pZMQCMZ9yO/TgJgoZ31/O5IHBBc0ahI13fLTiYXYoMc4A3HRuwbpZpCkG4GMxBrAfWM+J9Njeu+3miVJ7DIcjII2Ezd/QxmVklZCPHZr/QaC85t5aF071tlOjvNS6M2/YIpRTMqLt3da7xYLnFhH9zOuD+RiW/UVMrx+4bh1e+j7O4Nx+2AUcS/UqIvAF6NohDnFC3/ZSquE6gkHzFxwP7FH90g4xRUs+qLx31CBuqwiI8Y9eEbe+oXuAkP3DkmDB0OAXIF1u6D2frb7PzogP0LRAkK/6Y4PjCcDFga5GmVClBzsVAtIpBax5xrnKhce/lY2vCye89/vd9aHAHnUmdcoB+nvoJIXjTH3NwZOgYDhrKWgXRpXQ1Ikle2rQPQkNySZBjT7/x0hrYokVXNbzXqERzFp8XzI50yDcER0oLRSgtsxt6B+scU33/Bir7sWx1lOTIr5sNrtgAhIDUQy3KOoHIA/0J8Q58E3wSo+u3n27moidqsvIXq1wVi2FiNeq2dRG1uGOnIiCOFYhMn7wejFiKGUszmLMpMW72dH8lhFiaK3896ZL7Dip0ybz9vq38b64ewpECs95QQoSq
 JMPOiJeN
 PRE8d2T8ed4t9qyMNcX1+4fI3x0AS498w0imqp7q3d5Xg+1V1uFRJTVdsCrG0rhQlWXJB8OoXQ2+VnBN8u0Jsn4YlylmbYQph8Fh5A1zXarKcJ3ylvT1t3GqU7hqQyZodNNA5hwuDl2Mf5Mq3t7DviAqsiF+BQBzvryw0EJcXHbiBEhl1kNq/oywUNoTgH72/ZKGyu/t3MogAobFeC9CnePMMHCjeB1h2efPw0iVb8ocqDMTZ4x1HpRwFYQw3S1rTQlwkBewclwRG2gFcL3jwvj6SQAvJFFhCm1kM3ib6GWcrJaMjIw9v8QuRaGEtiPAhKJnL+NWB9QBJIEg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Thu, Sep 18, 2025 at 10:18:49AM +0800, Huang, Ying wrote:
>> Ryan Roberts <ryan.roberts@arm.com> writes:
>> > contpte_ptep_set_access_flags() currently does a (broadcast) __flush_tlb_range()
>> > on the (pte_write(orig_pte) == pte_write(entry)) path. I think that should be
>> > changed to a local range invalidation to be consistent with this change.
>> 
>> Yes.  This should be changed too.  However, it means we need a local
>> variant of __flush_tlb_range() and flush_tlb_mm().  Is it OK to
>> introduce them first and tidy up later?
>
> If it's just for contpte, we'd never take the flush_tlb_mm() path. So we
> could instead add a specific local_flush_tlb_contpte_range().

Sure.

---
Best Regards,
Huang, Ying

