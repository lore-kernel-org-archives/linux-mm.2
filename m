Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE72606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dLqtx658
Received: by kanga.kvack.org (Postfix)
	id 8F16D6B05B4; Sun,  8 Nov 2026 21:56:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9436B05B5; Sun,  8 Nov 2026 21:56:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFC96B05B7; Sun,  8 Nov 2026 21:56:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60E736B05B4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:56:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD683805C1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:56:30 +0000 (UTC)
X-FDA: 85414067340.19.104CDAC
Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9179D140002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:56:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dLqtx658;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 91.218.175.75 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794192989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+4TwEwtUO3KwUkahtVVwASlPtdRGoMNVNlYwVFyhNM=;
	b=6XMNRtiybqK/zFdeG5Kg2DrH7d4fMzNIQWbNP5zpNdxj01kmEewsdFI9dQpRhblrr//Yfp
	0KrrTX3gvIIQi9RMOAiSB+MIskSMmUN5yQOEt3zQLOZz/WVJApB6tB4ufuruvfk6b/y6A/
	w/6KkgM1oAMJpwOYeuMORE848CX9ImI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794192989;
	b=O2B4N9j5GY3tmvJe93sZ9I2kSmmMJrJO4EmQW5JhKtKpyDNYeX3p0NyqCsFGo2T5+ZHOrU
	M6cGl32/fEq3nZts1mqPMNc3FVC4I6SIfIQJv61dRR/ugJ9mCgbnbrEI9OJIMrTgiFgC7q
	jmXZLK8J4qq770CgB1P2Sw2Fj8xV2m4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dLqtx658;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 91.218.175.75 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=E6nbi2q9BWguhq7sUJJq5GhBbCo7Z1GUqwFoBaxZTl4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794192987; v=1; x=1794797787;
 b=dLqtx658wixUpSvGUIYbocKc3P4pgfJX8GTgBwqreDl3IuJU6xbu+Lu0V4Umg9JCwNa60YC9
 TXnhYXjCKoABDlBeUDyWdbEosq2Ehcab/fUJtYs9+j5MXJSm2RKsiD2PjThwK0KisbmXtWAPIOk
 Hcc2N5mMkDWoyD9t1jt7md5o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f9c8e6b6d36b6895;
	Mon, 09 Nov 2026 02:56:26 +0000
X-Mizu-Trace-ID: f9c8e6b6d36b6895
X-Migadu-Flow: FLOW_OUT
Message-ID: <f7f034f6-cc88-4f54-a37f-9e9fd2dbb62f@linux.dev>
Date: Mon, 9 Nov 2026 10:56:11 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 5/6] iomap: refuse dmabuf iterators on contents-encrypted
 inodes
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <djbw@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, asml.silence@gmail.com,
 Anuj Gupta <anuj1072538@gmail.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, Li Wang <liwang@kylinos.cn>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
 <20261105065847.196540-6-mengmeng.zhao@linux.dev>
 <20261106104403.GC5668@lst.de>
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
In-Reply-To: <20261106104403.GC5668@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ebtshe88opas3g7auiirswxzknazxcc1
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9179D140002
X-HE-Tag: 1794192988-581270
X-HE-Meta: U2FsdGVkX19K6vqRwYaFtUpNB9+hHTCsmG5FfLN3bZRD+k/fgyVq4DRF3aM0qxQQ4attp/e1y2fY5ezmjJC6Fb3mCZOwKXWCDvfuzcQUzLbbV6z9k+RM6Fh0yNYrcXNQNtQIDHHUBPygErF33MrdWRaVwPnoE+avYeaOyhIGolRwPhuv+83tSN8xs7cXqB2RYtjrKny2XfSOOU/ko6HPOBEWhyDU5v7MC0bLuIYvVIcR9F9We8EuUhnqtHyVbjsDhHyVoeaQdRuQ+8OsIzPaD9A6GKO2+Cy9W8Bdx3ccNOIoYIYqkgboShqol7V1VPGOXXdBZ2mCSogswUVZdIaPZHg3590AbE9Kvq3qWCFlRBWlSOFcSrc3CHGydr3bQhgiskiI413temLmhfQWH9CsOb53655eWx9Mm7IgZMTUt+AYKmYq8CEGMvcGwSln01EZsNiUIjXZ0Di0/zK8dP/cUAMWDx1hpymJ/fsHPhUbVO31SVVRwwzUpNMbf3+BM/dUVSY8oYIIG7yt3sZe3/ulfuQQoyK6V42zJk25GHasGMc9uSEHp/mz+ZhZ33L5CEMO3/QpycRKhGSXxOf2cY+vURFyV5fIFBc1T1Fgov3DRuVlrq69EuLktrV2JXiWNYswL75KCMJhdst+bhHIytMfiqzvagF5c6vG5cdDNxMtZmTMOGVIYMTEdO2i5cY0S6anoP0WYnCp6np2WIntE3VB/3a/CIaSQTpCLDVZ4vYQW8xNhPFcDfGOhad20iy2lIvrkDH2E8QKYhUpW9c/ucqtp9+PnP1OtrBMW8436ZdkStP687XH4dZdrR8v8MnCytA152hi3khXNHS/4t1yk+8rnbWyseuXJBxqTvEGdDvHFhHOmc6viHmGKdIvbUt5sAWF3p4miNmC7heP5d0gTdy8UFmmMVzESVLtAxQxG/pLU86HBI6gdCW5a5PPpaWayFySvEznSY68gGxIGG1yt/v
 YdFFJJrU
 25bME8bGJJsu2qRXLPE8ckRT4xGBWdbhpMlIpNa96Iia/t1lfM8AUPA8zXy+SlSDktzNA8EqgGvs9hX2+2DPzqIop6k8tHyTaMPF/hl7jOiNbiuXoKKGEoOUdvwTMS7JlIaeZXzTnX6eR75lRQbO+e6SMTGIFPCTB1l+iKluKzeRss6HBHoiVwUdIdeI6qhb1LvTqMskLRTW8Rj5EBR7+BdMOBO1VGitKYRvT2S/tOqH7zvIvlI5ps3gClzgiL+OEH4VrVvMF30exBtXXZ/c2CuVXK182WmjzOj278DOksIBXZGwO1gi/1IXv/9/Bx8b18WIsipGnpDazcT3Jwe2O3V/FcPs2bpcRD8xa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 18:44, Christoph Hellwig wrote:
> I think contents-encrypted should be content-encrypted.
> 
> But we really need to find a way to make these checks more
> systematic instead of sprinkling them everywhere.  E.g. have a flag
> in file->f_mode to allow it, which then only leaves the direct I/O
> to buffered I/O fallback as a special case.
> 

Agreed, adding the check to every file system is quite tedious.
We'll look into redesigning the implementation based on your
suggestion. Thanks for your time!

