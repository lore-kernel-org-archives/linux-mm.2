Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC05606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 21:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=4V602Irk
Received: by kanga.kvack.org (Postfix)
	id 7F4C76B05B3; Sat, 14 Nov 2026 16:15:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CBD76B05B4; Sat, 14 Nov 2026 16:15:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2906B05B5; Sat, 14 Nov 2026 16:15:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1166B05B3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:15:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5B12803FE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:15:37 +0000 (UTC)
X-FDA: 85434981114.03.E158B5B
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf01.hostedemail.com (Postfix) with ESMTP id AE44B40007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:15:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=4V602Irk;
	spf=pass (imf01.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794690935;
	b=t2x0/7aCMxo06GqEjWelINBMUEsfHKewPhQ5ItuzheE5Fg9ISC3xNAajz0nf7Wn/PUpW0K
	q5922Mq6R35BhJQiMq0v3ZXLvQGDrsBfEFmjetmWR8W/N9Ru/eDNqMWWbkMUizPXtZsfPD
	JqXOQ1tUk6xolwUcAVM6bNte3KWWVto=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=4V602Irk;
	spf=pass (imf01.hostedemail.com: domain of shao.mingyin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=shao.mingyin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794690935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTNqZBLZ4V+Z/BDcsgHZJ6Lp5cyvyfZFCJCeJ7tg1SQ=;
	b=48RJ4VmMANQwST+L6QnAkxcR4a6sHF0mvvSph6ma+WR8v8SKCP6RwlstDA6hZSmCoyn6S5
	hezqr0Tlx9hKXOe3JUV0oL3hYDokKEo2W6lny6/dxqXyBi1uewOo6sELz6B3PK0js03xZg
	1wo/spmlkFB4eeeA/ZXSRs5jv1cjgu4=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jRn371RFlz8Xrnt;
	Sun, 15 Nov 2026 05:15:31 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794690931;
	bh=BTNqZBLZ4V+Z/BDcsgHZJ6Lp5cyvyfZFCJCeJ7tg1SQ=;
	h=In-Reply-To:References:Date:From:To:Cc:Subject;
	b=4V602Irk61zRHSbdH8wMgzBdkAbd+dRAIY/0+3OxCw5Tr8rvn10HRiZiWenUJ7JR0
	 bke3dzBztFy7yM4d50HX1U3mNHOatVT0m+IUQmj0NMXgEtY/mMdXyQgRHgEFz5YrsX
	 DJ5Vm3AQIM1fZyE+4xCyWq/lxckiA/0oljQlutPLSqhSA7l2yP9ecfvGpogImyabdN
	 /g1qtbmEuRx54fuhJ/OpfzLGxyg8QvWu4FLgHkd2OHqo82JP5yh82lmYSxRZFpjrJI
	 8+lI1/zwOyQKVSIsyicIDcjXg3DeGQragRyngnmb4pTjd5Us6dTeY9dgZ1Jn4gH1Tk
	 oVIESzhekUuDA==
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 6AELFReh002389;
	Sun, 15 Nov 2026 05:15:27 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 15 Nov 2026 05:15:26 +0800 (CST)
X-Zmail-TransId: 2afa6af8cf6e508-cb43d
X-Mailer: Zmail v1.0
Message-ID: <20261115051526117H0NSID837XMXH6qUeh_JS@zte.com.cn>
In-Reply-To: <179468563735.482102.182237761852902643.b4-reply@b4>
References: 20261115004655564ix3vefI54RZ3HhYOmxuKX@zte.com.cn,20261115025832904-wsPy8LPoyIcDJ6FMU1_H@zte.com.cn,179468563735.482102.182237761852902643.b4-reply@b4
Date: Sun, 15 Nov 2026 05:15:26 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <gourry@gourry.net>
Cc: <ljs@kernel.org>, <akpm@linux-foundation.org>, <liam@infradead.org>,
        <linux-mm@kvack.org>, <vbabka@kernel.org>, <jannh@google.com>,
        <pfalcato@suse.de>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vdm1hOiByZXN0b3JlIFZNQSBpdGVyYXRvciBvbiBmdWxsLXJhbmdlIG1lcmdlIGZhaWx1cmU=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6AELFReh002389
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sun, 15 Nov 2026 05:15:31 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF8CF73.001/4jRn371RFlz8Xrnt
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AE44B40007
X-Stat-Signature: szgxhxgnw9wamsz56q4r88mqcjdnbh5t
X-Rspam-User: 
X-HE-Tag: 1794690934-692885
X-HE-Meta: U2FsdGVkX1/w59igPsQpYUTAmT6ZD9om8ED8LAAA1+xBYBRmIRDt26bhdY3scYLxzVMQsw67W655LXoF+9aD8KvDFNo3wELcqTy5kewLHPar2Qf8k2C6BY6cS/oqCAEJNouyLx1DgsY+g4RBMZbr506Rjv4CIxCeATBDnnXaghlR6fWW2RFP2P/+0i0yaHk8nseVGVf2b256BUJn2RdoCtLTp2YpDEBQ5BbGuMJDPR4WcEG2rT3UUPzU150ptK9sN2yzC+2q3pvz8Qk7qgDcy4HYTIDBnyl1sWwT1pgbKNczMvt+za0HYv02ESY9ZD0LwuvehXDfRrA18/FnnYElnnpeiN+l4Jo+iovCsU+/kapTbbQbZizaZzOmaYFv44eiSIugQ3CasZ5nrbYhpGS//l9X6y+bggX7NNmXRYQ6g+NefZZEtP0igwoEJhSRkkvEs1p3xCbAmpBrau1eq24ONJt5cjYRKfSOxWzGE0lhlrn6o9CjIXAFrRxBCviPjDNBgBJCsNGeQ5od05lujx0XlXAUgrFKoT1i5HUqWarA3doli+Jdzu20E469+QxjOSmEXxMDARfsUjyr3g4zvOe34RgFte45hrUTOHjTHI0UEWn4MwHLOaILxtgyvsBGvaVCbA6LX1C7/W8xmNcE+29IgyEirxo9yL75epL6L5XVsj+ai9yjD2KObIaVdbbUsOHoybodxdTq7JySuivJ4nlRQ3OyKlCbPfzNeFL2r4O/s5bg7ZVaq8TI5Behq1HW+tVnwwlOgJHv6joGbe+5pMFV7bWnTPHVhUaQzEIRXI45V7C4O1FBLmo2OiYzitbrUBH+Z4HizQZuYM5Lij+bs41hrlxEyX1Vd3ISjR5mQZKlhgwyUdgsPducTsdjL2DQLhh/JcvUe3t/zn4kpvxwiZ1okJQUnpn8gW2i+ZBV9b4xEK+f9FfpiY0nhlhzT0SeGMK8aAX+vwl7sPepvy+eca1
 j+BK/FMh
 t9fpfJDkN86+8ETvjPthD415w0jEyvToLn2MuztAGrEE6Y1/RBIE3W6SJXkr7idOmfSGskI4GRUAjzAr496+Oxd7qq2QCEUdw2ZyoSgU85fWglGOAeDYOfJPJri7676ITGMLLQRnz1KrMu00L9dCPtHaeYjUCytDorQxItJYgsKDijALrGGbeOzd5i89u1Wp5K6ZzxRB8JsiaQSnUyYCSfbbCQ2uNntbU5o37aP5LJeDs/vevEOsAg+QD7AeGJ8/5ESe1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Gregory,

Thank you for the candid reply, and for taking the time to write it. I
appreciate that you explained the problem instead of just dismissing the
submission.

You are right about the triage cost. I had been treating an LLM-assisted
patch that gets applied as the measure of a useful contribution, and I
did not weigh the review time that every submission takes from
maintainers -- including the ones that are ultimately rejected. The VMA
iterator patch in this thread was exactly that kind of report: I could
show an internal invariant but not a user-visible effect, and the cost of
reading it was still real. I have withdrawn it.

I will change how I work before sending anything else. I will not submit
a patch until I can state a reachable trigger and a user-visible effect.
If I cannot establish that a report is worth your time, I will not send
it.

Thank you again for the honesty and the guidance. I will take it with me.

Thanks,
Shao

