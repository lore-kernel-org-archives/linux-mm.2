Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E2F5E9B243
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 09:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4C26B0089; Tue, 24 Feb 2026 04:40:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C9A6B008A; Tue, 24 Feb 2026 04:40:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB606B008C; Tue, 24 Feb 2026 04:40:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC8496B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:40:45 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73FD91B67D7
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:40:45 +0000 (UTC)
X-FDA: 84478855650.11.27287E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9F945C0007
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:40:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KqtuYhtv;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771926043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+AXKNanKGjupdxi/2gEXD1hmmFwH6IALmX/jtMIV00=;
	b=ldSxqAsC1oqi5Bh+EqKdEka2iPuW84ZjIBkKEx4VQ+HIPs66APdJigu596KddqZc1rlOKa
	g/yQlx6daKFDTo5xoqMH6oSBxPwPlWLTXDCr31pPqn35Dv78axoCsZtU0m8hRNWG3U4IU6
	Y7tXxiC5GkDljDJSqUzzQFS4582vYbU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KqtuYhtv;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771926043; a=rsa-sha256;
	cv=none;
	b=G4HssFGDTZPDDGnMGBCBCPrx1YU1dBmYpKPakdbibGpfhty5nzTleily8U7hzBYFgw7BSs
	tHZWJzEx2GxgC0845H8XoZNqi59nLD/HBY+4XVm0pHQSQ/x0Vr2LkZOmVw4ZBixF5cx7H4
	GklpAbP3ZrtPJ2TS6g3iScfymlEXVSQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB6194092F;
	Tue, 24 Feb 2026 09:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24845C116D0;
	Tue, 24 Feb 2026 09:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771926042;
	bh=j+2+godUz1XAh8cwg0aK4PoIjaBvri3SjlK5kyMt8lY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KqtuYhtv25KWFt6vqVb9KtRrmUdRt6EEg5OQl4q+pvTgATUNZ66VOxtY2VR47AeRM
	 o8FMb4uxot39FFZZEEA4224SjOLKPfdXtYw81PiDATKN7UyiG0chazjW4Z/HeomrPZ
	 qSEK7sPV97gfZuaSIBXTph461EQ+rZKA0v4Jlv83IMMhFDQjDohmtfmwvmfJ4xmjTw
	 jqCrGKe+YGKYSzCMVdHOJ3zi/9j0Z/niaRdjU8yxDquV1Gz9Za2OLsaEqdwPaKMAkl
	 mUr9dkQZ1HOPPV/4Q3GsljzzK1IkAF/RMQkIVSJFUr+6Ul1y+GYtIX9tgvjJNo8eKQ
	 Ke3BDGZSWKWaA==
Message-ID: <b82a5ac3-33e9-4cbf-892a-f0c7f6fe0c20@kernel.org>
Date: Tue, 24 Feb 2026 10:40:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/22] Add support for shared PTEs across processes
To: Kalesh Singh <kaleshsingh@google.com>,
 Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, andreyknvl@gmail.com,
 arnd@arndb.de, bp@alien8.de, brauner@kernel.org, bsegall@google.com,
 corbet@lwn.net, dave.hansen@linux.intel.com, dietmar.eggemann@arm.com,
 ebiederm@xmission.com, hpa@zytor.com, jakub.wartak@mailbox.org,
 jannh@google.com, juri.lelli@redhat.com, khalid@kernel.org,
 liam.howlett@oracle.com, linyongting@bytedance.com,
 lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
 maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
 mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de, osalvador@suse.de,
 pcc@google.com, peterz@infradead.org, pfalcato@suse.de, rostedt@goodmis.org,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 tglx@linutronix.de, vasily.averin@linux.dev, vbabka@suse.cz,
 vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com,
 willy@infradead.org, x86@kernel.org, xhao@linux.alibaba.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <CAC_TJvcaJdEzK8n9BK0qgEXdzjzXtbA_Zk-ybfmG8kjNExVCzw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAC_TJvcaJdEzK8n9BK0qgEXdzjzXtbA_Zk-ybfmG8kjNExVCzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ttq3ema3aqdi7rtzw9timdcw1d9og7ix
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F945C0007
X-HE-Tag: 1771926043-631910
X-HE-Meta: U2FsdGVkX1/y4Ve+Triwu3SAN7D9wnGZ7cMv/lNhdi+VOnePNDsugB6KEQzybh7gqLIyFDUpJzFH/ta7VbQ44jTDzSbJWgu4f/hjLg17dSo+REF92kPN4p/OUto9VxrRRRs2uqhtJMC9q7ZaMYD8bpmbJEs9W7oHQMroV/QYVfT5gPxkYBVxkIDiBFGB1Gtdv6CW0fFn1nh1UU2VbLe4uzNTfX8qgxfRsBkVvfnkr58TuF6rGlWUCfBCoFcvfGlQ6gmudxJRCdYGg6JSQ7VOlDwtMCjA/cIzzTLJ70E26BvZrGbQFW64sqq5yH4aTCCQk2GK+1IJy3wHMGbSrvAIwSEySjZ6qgZuS6bcn9e17yNWNIU0Umd3hDMTS52HbcrgngUxD/9VXu0R6qzIIxSMBZc4D0VKALv1Y3sZxPVHBdxnJA/AV0NxrjiAapjC2Bbq6/uXfR+LzjfEIporbUVt0ngH6udew27tTNhuQ6WD1jy8YOMcY74szxo6colHR1hihrzcRAHutmgp4LJCIFc4bhRJliApmr5bOkMyxqn7/+Clh6wQCNhEi5HZojru+aMmOB1lHe/q7CoDrmRAPrT3SPIBWKyiHBFRKqOegbzz42HSlcd1HX3/gS+sTfCYrNAlglH8y9KJiPiBfr+SjVFBM3m4krq2l3+bkzvFKSj5EK2KgpOjAKhFdkv9tgZoXe/sOYFttVb9QCI5S0g/w+Xu5Z3V7DDp9H/W1Jo2IUAkWXjNiEV5MqDapzwShWUL5gviz8FzUO98YmVK5Np5r1Gb30GBYfLCqxZbH2PuzzQ1t3W9RH2T2w9uEiNWRLUgw9nAEr4lzSsqoTQOhSfDoN19p98VgRD/4vCbT6wOMlalGgx7qNXzXvWvN5WXpEv6vH6eUfxo1k5b2HIFx6WYnt98MAmWj8uI5xNygVtkUERo46RlhIis+CKLx/i60GFHikLfPnlKFilA2qknt4X8wir
 wz1D2yFm
 48bQ1W/3Kxmh4EFnxNPfUdsm7ZTpKYAQBae12d3FtE428/fUDYexxvXWnw7YPR+zlugnLh1DGIfcW8cHoVeycWFwqfuUWXn21m2/HKU1YsBDn1dCQD7G6vyvxohsQBlnE5dQwpPu/ACQ24Yt/twwqKK5EYTqO4VOqvree/kyrPm5aigOtND4x09E2fj76GmzlW274F9M7GRkzsKnj1VSHWoQp1w9xnrtjRSO2TGObX67BCDS06eOGQ4+pyoUzehtmsdbS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I believe that managing a pseudo-filesystem (msharefs) and mapping via
> ioctl during process creation could introduce overhead that impacts
> app startup latency. Ideally, child apps shouldn't be aware of this
> sharing or need to manage the pseudo-filesystem on their end.
All process must be aware of these special semantics.

I'd assume that fork() would simply replicate mshare region into the
fork'ed child process. So from that point of view, it's "transparent" as
in "no special mshare() handling required after fork".

-- 
Cheers,

David

