Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6AC7CD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 12:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CACD6B0005; Wed,  6 May 2026 08:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2E36B0088; Wed,  6 May 2026 08:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB746B008A; Wed,  6 May 2026 08:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E11D56B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:50:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB231140218
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:50:16 +0000 (UTC)
X-FDA: 84736978032.17.1AD15AD
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1C916140003
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:50:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=Q16USzME;
	spf=pass (imf23.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778071814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NM1ciYMorWnBjvbaoqYvdKEbEjW7wOX4Uu8SsdPCddY=;
	b=hWInyKwsSl0ZglmqJbCUk34t6stooyXx5HVQvWHbvultwkxoPVYZ6OIDvPqVREVvjFq/1W
	QfQSefG0i0qE2TacCGrdZOxatkqfChSFPom4DMwhLf20fO3R8BeARf69qJYIdwmv+BxyYD
	rY39+hVZdjuz39A4yHkWs1k3WuZx/FQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=Q16USzME;
	spf=pass (imf23.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778071814; a=rsa-sha256;
	cv=none;
	b=cTwoLsEhInCKyKE1GgzVS9pfSrhHbBaFWzeHJg+rAHKNnEwpc6Kd1h/KK4m1nzQooEOWeZ
	9VM9WlHkJnarluskO6Chxvs3pNadpWAIhqbsfuCjs2EKhvJ5Dr2a5BwAyTSMaxjz/91TQi
	2k8MyKWDfQW5MRBTb1nsiAyA5B9WreA=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=NM1ciYMorWnBjvbaoqYvdKEbEjW7wOX4Uu8SsdPCddY=;
	b=Q16USzME5QfQmqOJQVV549MfjXA8J3EDKzOGPYxNswClcA7eeJtM9XhivP7S6OERGkQQ8jhIm
	s5f19T9sQe0Vz9rul3fFJhGJ9aZEUTDU2XfLZ+BhiW7ero+I+DrRPG24kTa7q1uJsQ+aK5FzFXP
	aIyNTbEKpeSGtLJuKb2BWbc=
Received: from TW005.hihonor.com (unknown [10.72.0.123])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4g9ZvH0YGHzYmbVK;
	Wed,  6 May 2026 20:48:59 +0800 (CST)
Received: from TA005.hihonor.com (10.72.0.137) by TW005.hihonor.com
 (10.72.0.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 6 May
 2026 20:50:06 +0800
Received: from TA012.hihonor.com (10.77.228.68) by TA005.hihonor.com
 (10.72.0.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 6 May
 2026 20:50:06 +0800
Received: from TA012.hihonor.com ([fe80::9e31:9fdb:69fb:928c]) by
 TA012.hihonor.com ([fe80::9e31:9fdb:69fb:928c%8]) with mapi id
 15.02.2562.017; Wed, 6 May 2026 20:49:37 +0800
From: wangzicheng <wangzicheng@honor.com>
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
CC: wangxin 00023513 <wangxin23@honor.com>, gao xu <gaoxu2@honor.com>, wangtao
	<tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>, zhouxiaolong
	<zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>,
	"kasong@tencent.com" <kasong@tencent.com>, "21cnbao@gmail.com"
	<21cnbao@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "weixugc@google.com" <weixugc@google.com>, Randy Dunlap
	<rdunlap@infradead.org>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"willy@infradead.org" <willy@infradead.org>, Matthew Wilcox
	<willy@infradead.org>, "T . J . Mercier" <tjmercier@google.com>,
	"kaleshsingh@google.com" <kaleshsingh@google.com>, "android-mm@google.com"
	<android-mm@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "surenb@google.com"
	<surenb@google.com>
Subject: RE: RE: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Topic: RE: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Index: AdylO0tsrJ+MTD6TQuqKlap5pOdBLg4Gmr0g
Date: Wed, 6 May 2026 12:49:37 +0000
Message-ID: <2597ce355792455e94ee41fee6740dc1@honor.com>
References: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com>
In-Reply-To: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.11.91.159]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1C916140003
X-Stat-Signature: i13uu9jmiykmpjbucbsqrygynkeisnng
X-HE-Tag: 1778071812-950929
X-HE-Meta: U2FsdGVkX18AM/r7G+gXdR23OcbKSl0KWIcolfjTSvCEdVVNFc03oZkNI8DCdjx7FGKHube+Zbf/0A7yLHaV91/g84nj7tQ81J43P3UN9Tbx7k2eOay/YF3FQBLZqnuzecCLWVpiWVODbp1ZV4F+3wHPy2BnrkGoewSYZ/DS/zMcPQ1X+hMwRydZiJ8hxY+iz/mj52MV1fMn46D2heOMnn6SWbYlI3uyHBHm6CBOV8UXe+z42rXtpQCzGBy489rBGkrCwo0PsOYCcBiuuI2dc/E5Z6YQWGyqfFO91bWu0rBdua5u/G1Giv8MunNYUORgIGb/zF8r9U5CeP8eywVIwY8BObWnkOxVOY9CQRkc9PnWm+HFIV92cpQj8TU9pABjvgGK8kEQBS189pQ7F1eJmvfuED1P68nyUDj9IDHHt26TI4fcAkAWWnTqTAj/nzZYDYV03r6p9sq/N59M81CQFm5QlxNRab3eddPdoT22skwZfou1uJAXeRhWrvGIOoc1Ovso7+WmwZIICf3Rjkvx9pzu2ZAMJ9Wrhf3i6RquP6VHkYWCRrgoxuyIf0wmGdTau9KqJU6I5ihk6nWVLWJT1++r9cu2t76tXzbU890o7PG7Q7urSdC7AHVc1WzZ0S3R3CPDJfWFQmF1ZLrpc30WUuP8tAJFTxLAdJZ/3MhPlkUzoYNv3JqBEXba7jlJymOIrQ9+lboe0X6WvEswZkLwO7rE+qN38D3TQNVMuW4s/AyxT0NI4S4htVOG3Gct9hJPbEil8w7qCUSARHzdI5WhnKY5ZD8n+VDJSa+wNolz/JdjsnLyeh/qw7YSeWXPWPW3qEZu05+8GD5AfGErrF/aU3KMeRl+ohNpD6Q2j3rWJJaAI9MRWcfBs8CQEPZ8ku2iaNj/FZWuU5p09lkd6DLujlitIXUNSoORs4nQK3kGdSOAYlNDkhvsJ2C4H8jiJu2+Kt2x4kuHZSqRzzPeGe8
 H/7S/mVi
 rbG+AbbMjZx0ybiQLPOJEdXTJCBRK/smzVrtml5w+nh+EWM43BZDlJxJwvErhbSnZ7r5O1O0aL4C4Uk6jUPsbul+35YwBlOMCWnqa5lfzZdAMlx98Xz2aR68p2KKudDtnRWlwUWeRgASwszPyi6IU0IwcKLwgYrdJ7HSsZra+k/Vs6SgaWaVjX9fHXsWUT05HAyxIUUXWEm6ywCnGu5bRUN+sZQWSVOHtwuCaYDAVbKLgcp5lBfIAS23yOOrJcM3U6lKenDV3aRbnQCNg09oLrFMmXTaAriJSfYBFYId/badTSRLdAdaZv5wfYWwuQYQ3jl9ppYqL0ZGNcS260RTyieMr4vHq5Fq1SwX6HB0CowUh5rg4aykcZx6mku/EYiRhJTDnhOB30c5/yuLiUJ4OA5F8Zl3mLlAW1IJ3FC/U8fLQy4oHGcCRbKbe05TwA5QMKCGqRGUt2UKbctHONkC8BGjsxI2hxEqHv1eDoZA/ZQnoiybiyrE6hYIrPxOrHL1MUAC/T55NPDji7EiMZr6iA0ipjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgZXZlcnlvbmUsDQoNCkZvbGxvd2luZyB1cCBvbiBteSBwcmV2aW91cyBlbWFpbCBhbmQgb3Vy
IGRpc2N1c3Npb24gcmVnYXJkaW5nIA0KIk1HTFJVIG9uIEFuZHJvaWQ6IFJlYWwtV29ybGQgUHJv
YmxlbXMgYW5kIENoYWxsZW5nZXMiLCANCkkndmUgdXBsb2FkZWQgdGhlIHNsaWRlcyBmb3IgdGhl
IHRhbGsuDQoNCllvdSBjYW4gYWNjZXNzIHRoZW0gaGVyZTogDQpodHRwczovL2RvY3MuZ29vZ2xl
LmNvbS9wcmVzZW50YXRpb24vZC8xaFVvZ3o2SW55TG4xM2M4Q2pIdXZFSXpFNHJUN3NhVlJVVjZ4
cFdab05mUS9lZGl0P3VzcD1zaGFyaW5nDQoNCkkgbG9vayBmb3J3YXJkIHRvIGZ1cnRoZXIgZGlz
Y3Vzc2lvbnMgYW5kIGNvbGxhYm9yYXRpb24gb24gdGhlc2UgdG9waWNzLg0KDQpCdHcsIFdoYXQg
SSBtZWFuIHBvd2VyIGNvbnN1bXB0aW9uIGJlbmVmaXRzLCBpcyBNR0xSVSBjb21wYXJlZCB0byBM
UlUuDQpUaGVyZSBhcmUgMTAlIHBvd2VyIGNvbnN1bXB0aW9uIGluIE1HTFJVK0FjdGl2ZUFnaW5n
IGNvbXBhcmVkIHRvIG9yaWdpbiBNR0xSVShub3QgTFJVKS4NCg0KQmVzdCByZWdhcmRzLA0KDQpa
aWNoZW5nIFdhbmcNCg==

