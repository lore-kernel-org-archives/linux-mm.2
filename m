Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4DBC982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844476B0098; Wed, 16 Sep 2026 11:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CD6E6B00A0; Wed, 16 Sep 2026 11:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695716B00A1; Wed, 16 Sep 2026 11:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35A676B0098
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:11:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04368C0705
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:11:18 +0000 (UTC)
X-FDA: 85219963878.12.7B72286
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 353BFC0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:11:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k/2kdVXt";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789571476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6pJZlwL4vv3n0HS3phtnf+vf4448t/3gjdWcfUceqG0=;
	b=TvoIq9mm8MSsKWYXiDTYBK+Kp+tX+QQ1YE0fzXDR0iziqdHPjSz0jR2rIENGFJYREat4o3
	ss2mVt2mBLN57JKf8ru45yvlq8kIOzlX5RD2UT/iHzr1DthypI8i/4LuDgGLaYBg/n2aWT
	UbkjuiQURxPMJvWuhYegQwTp4car+b0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789571476;
	b=sUPKdikQ+fnO9KHGaPcuFPksGTIhWJ4U0+Lm2KKcTg1i8X03bo/iL6i/Fq7cYgkg6WnUcO
	zC4o3194Kxh2rAT+JZEfo422JPIFvWz0msCkxmSMvTa9aNNuJkbHZvsVtcQ+wxGBUhRDGa
	oGj2fTmpjYNf7Ad9rPQXQZWpoEV+qdI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k/2kdVXt";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2A38602D0;
	Wed, 16 Sep 2026 15:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74CC1F000FF;
	Wed, 16 Sep 2026 15:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789571474;
	bh=6pJZlwL4vv3n0HS3phtnf+vf4448t/3gjdWcfUceqG0=;
	h=Date:From:To:Cc:Subject;
	b=k/2kdVXtCQvMgh7swp8SCL+7ZpmoB8Wf3KF6uUxHIg/O/QJKckm1zOkiSogwJblfo
	 aYF4IgshxAL7U9EA+4gimQpQ7dog+5Bfe0r2edOz2yY3D95n22bz+j7NM/yScK3Ws4
	 F4DvtlVXKd6ArvyL/mlL5QLeqyZAIzAMTA2I7sl4Bx/s5R2gOWVzc3Zu5Hr8bNNcfJ
	 rQqPlC2+S+tmHPwvH5PyCLsI/gd22w/KEm1+MydzOgor/1cV6xHrXMKePA0HhRbEON
	 31WLVfe1rRsjHVioUXriSkMXpU/si/sCzQkZzIUGFgMz+qWGOBgM3soR96ai6YZALu
	 vYsKfpuP4fGug==
Message-ID: <b91dbfae-20f1-4b9f-a25b-4397afae80f9@kernel.org>
Date: Wed, 16 Sep 2026 17:11:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Cc: ackerleytng@google.com, amit@infradead.org,
 aneeshkumar.kizhakeveetil@arm.com, ashish.kalra@amd.com,
 dwmw2@infradead.org, eberman@quicinc.com, fvdl@google.com, gshan@redhat.com,
 jackmanb@google.com, jackyli@google.com, jthoughton@google.com,
 kalyazin@amazon.com, kas@kernel.org, kevinloughlin@google.com,
 liruxin@google.com, michael.day@amd.com, michael.roth@amd.com,
 mike.rapoport@gmail.com, mvaralar@redhat.com, pankaj.gupta@amd.com,
 papaluri@amd.com, patrick.roy@linux.dev, Peter Xu <peterx@redhat.com>,
 pheragu@quicinc.com, pkondeti@qti.qualcomm.com, prty@google.com,
 psalian@google.com, qinkun@google.com, seanjc@google.com,
 shan.gavin@gmail.com, shivankg@amd.com, sidtelang@google.com,
 suzuki.poulose@arm.com, tabba@google.com, tatashin@google.com,
 vannapurve@google.com, vbabka@suse.com, wyihan@google.com
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-09-16
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 353BFC0007
X-Stat-Signature: 7337uh8r759kq54n1x4d9tc54tek7g9w
X-Rspam-User: 
X-HE-Tag: 1789571475-137733
X-HE-Meta: U2FsdGVkX199JhjOkmr92otDfUfDmd9BksBiF5LducQNsKKf80UlULJfx92SFM1BwzIIGiMfITdshrX8HN/zHtkuswZL0vg/MOw/9AoLr6wZuOQ0umPsClxoQ8Hu2zpU0Rc5BDDmIJnrSLtt1A9lVEitMdxI7XveEJJt5SE1R27o8UCCJ3VEQl+wJB5qMDK8+qLyzW/qB/vFcrFH/kbibzaE2AlpWct6OWQFoAZx+4vGwAjfudJMmMPEHnFpDUIkS545GCe7YkI9ryoeED1bdraaGGlLa27er2loqWOJTNnhQ7o50EIdQPQlDUDZaLehNE/pxJv+3pFNThORoM9ziDmfCfDgxgLBmeM/P1lXey38Uo6iwSbgmhvAh16JGFMMZnZeO26dzc2Xy+A/lJ5qiJv6vtvAWE0XHGXvAbQ25jn1Uw9MyHsz8W1Pv6LHKbIgHyG1oStWF5lGAoYNgzNUw7dIO3wkZ+EXzP/R+VeAi+x7q1v8tzPZrm4oebRfgs++9/VHgX88AgKp+kuPd21H8ARQTGO5rKFCzAv1XOd9mcijFrrx0QRD52iR6MYa/vXK2JhbfHh9RlTMo836/ddEbcQ9sRb4xzGHhW7sZYgyYjJ4MrAGhqsiHLRv2qsu4XkVYs6gNybycBuRLNN6fPVO8f5LaApHDJDrjAkyVaDxDUtdx9lkTbORqaWNP993eSyXaY0CeRwcwHtrKCx12JjzFrOyLHD6RUIip5t+1UIcWflrW/0HgVOrtpUD4v5N7EHF1HCpBS8N5/EpSLbYh/rfHYnhG84YR/jwtFuuaUltWEHgOQMsSrYGVJN7nleAdcs3HWaanGIDcpdkHbwulQtqyR9iEpfuzEDGzM1Pbf9afTq6AreHW477UgpRBDzlUARA0pWLQQ+GdFdTQHdSNQr/uwET22Tnw6afZhD0i9mZbeI2LwbKnqxODAgPvYZAev1nVNbqylhzPRJN0ambcSs
 MylvADSo
 /xYmXN8Pb4TaD8XTRa5lOULcbew58te8jaW4C7A1aGnrLIvh7MrLkbaZrYtmQlI+K3O/VqS9Sy4xynfsS4//p5cfF1jQi0pVzx2CQrHjumtE5b078wKY6UF+mcwLRljalxYcQIN6Mf00MrUeWap3QgR450UJsnm9zAtCNQMqk50SLlCr9sxC6z9IGuufg2gse08dQQl1KDbdWmclyVR6VX+n2ak1z7IewNvm/xtqtHIQDdT1qND8dq+tpG8+dukxiu9Z7/+ETRp0SdR+TBL0i2u0m6HNtxi1WiKBqOedQdw7VWNwLgJkhR0CEJrtoIHScWb0K9KnyrQAHXWqk7NNZlxIxy5a0O7nZf+OT8iSlsvYY7ZtsRfCbtgmmy0sIi3MMs3ZXoZ1HERWtfmNNhF0nA+oASuaF2wjodShr/30NVNCb01btkpeY6gKfl1VAEDuDyioXZaS56aqBXV3H87I5a6HSRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2026-09-16 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

So far we don't have any topics, so I assume we'll just briefly sync on current
upstream work and discuss whatever comes up.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or Ackerley a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David


