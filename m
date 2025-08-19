Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9CECA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 16:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00E4D8E0022; Tue, 19 Aug 2025 12:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F284B8E0005; Tue, 19 Aug 2025 12:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E928E0022; Tue, 19 Aug 2025 12:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D407D8E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:15:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D3CD16013B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:15:06 +0000 (UTC)
X-FDA: 83794006212.14.9C6A02B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9E09C1A000D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:15:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E8JQcS13;
	spf=pass (imf19.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755620104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kr+F4blUg6FODR+2BQWkkRgkHiFy8Hzr+twDnZG4NyI=;
	b=J3cESpAFJlWHtA729wEZQH9vO9Ue/Aau1QLmwmQzxT7tmUlA6lWt7cfza3RX9NBWMMe6n/
	tG3LjKTAibcOXZwPWGljKJqWvVc1Q73j5ztoj972WUG4fJREsbJotK15vRlm30W4ymznDt
	AUNRRNEUSWa3uXerUcxkL/eZM70RaNg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E8JQcS13;
	spf=pass (imf19.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755620104; a=rsa-sha256;
	cv=none;
	b=c2pTAlx5v256YzB6aXNN6XvmgmeWV2x3FGHQ4K0HxEZC/ZqhKIkSEDgBp57TdyENYFOUcf
	eoODow0LZs36ZluJACXov/T5mr0EaWetvtusJrxQceGKYYtkWZbYFoTg32tiIyAvRtGS1J
	bczNxj/FTbY3DYW7WTw2+p8PoW7HuYQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755620104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kr+F4blUg6FODR+2BQWkkRgkHiFy8Hzr+twDnZG4NyI=;
	b=E8JQcS132o+/U5oNwTeM4KyAtLSY+jlin8vPIG+XKfTGaQYu9PW1pKY/pjvY8deVSa4yJE
	u7TnMXfym0gUp0brzlMKFFWC+qigM0mVCPg0pRlluyN9/UbeO19RuCGwBuIPqP1zc+NtV3
	KejO+mqfCTXrPW8Nm6yKiG5bdHGEJag=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-3o2EMjNHMyeBJ5Vh3nX_AA-1; Tue,
 19 Aug 2025 12:14:59 -0400
X-MC-Unique: 3o2EMjNHMyeBJ5Vh3nX_AA-1
X-Mimecast-MFC-AGG-ID: 3o2EMjNHMyeBJ5Vh3nX_AA_1755620096
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4928A180036E;
	Tue, 19 Aug 2025 16:14:56 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.225.95])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id AF8BF18004A3;
	Tue, 19 Aug 2025 16:14:49 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 19 Aug 2025 18:13:37 +0200 (CEST)
Date: Tue, 19 Aug 2025 18:13:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dominique Martinet <asmadeus@codewreck.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	syzbot <syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, dvyukov@google.com,
	elver@google.com, glider@google.com, jack@suse.cz,
	kasan-dev@googlegroups.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
	willy@infradead.org, v9fs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] 9p/trans_fd: p9_fd_request: kick rx thread if EPOLLIN
Message-ID: <20250819161329.GC11345@redhat.com>
References: <68a2de8f.050a0220.e29e5.0097.GAE@google.com>
 <20250819161013.GB11345@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819161013.GB11345@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 9E09C1A000D
X-Rspam-User: 
X-Stat-Signature: a678q1fxss1a8yasf4tyaai9gjth5khd
X-Rspamd-Server: rspam09
X-HE-Tag: 1755620104-501624
X-HE-Meta: U2FsdGVkX19RQw9YuuvauNbCpB2SlwaB3BK99uxLwiI+VSJxKhbnW1lLGagU1NhyUMwChyFm1VWzMwoeaMQzpbhIOIw53MFgWFGKTKJlmNCEv+jdqrv77MemcXGtlIYwqdMA1Uj6s0TQlfljLnydVFXN25YPDUH4CKbq6LL83Wjxa22VtR4w9DSwv+yafIKo2I5d5AvLfV3E3DB1ikSE1y+bOYs9lHfZn4/mx66g9eTYzozC/veshKdNoiVH6mHVH/3KuSy0ItVMnZA5+3mU3Oo8xiTzJdNMPhyXGMOR/xtkhFWHsKDKw7KQinwH8l2yNaaC/XPGUdHZhuQDAMZnp3v0MAp49hPhV8IuRJ6Wo8YEEEwPXTpnwLEDG4crNGKknZeI8Q3Y4Og1s0jv8cyLw4OE5AGn3YhOE+y0KR2lZhIBVs4Nr0sSEu/yN8EuBq25Y8EW+c44Nr4rWTdky/Oc0r1GyrS5X1MH6+00+la4WvkCXJNi415g5fLgS0GAlUzmXv2d+EouSLT3i2BtgmiVAJRM6JFYT9PfhtoSFEaNtPkcJr1smsp9aVkUnXG5qgrv42lv/mEiAV8YWIWIC+4RKs/IqYQnDOF6jGUrml9FSBeHqmq/Icjta4cb3xCq2UP3Hn/5LsOmWiBHgtBXY2cSn3zbKZsqIxszJiNv347UN/HbtDx8a4UjNyToVy6g+YHtiPRNBSJ1KF/x3RviK4B8BHjcYfs26lXAJlZ6cUMnH3bg+eTO2HddeISgDmUOLuflNxB+k638/GO2xX4nK8w4O4U3uUlbuOxpDelicK1uyEqe8SsOqhvTitFt0lVf9aex+v7kE552NsXXcD+gyVoGacVwiyfPD0FTqah4xxJmC6pQNR1M2Xc8B8oZnzfHUxp7HuB3nfsWTA9BaL11v9jWXYjWrPMw/tb0Hah07xlqHeQBi1MlVATIi7iZYvm7TUQ9snmWiGXbfyb4+vXE5NP
 i8NDmQp8
 uHJqItMiIgvCAdas1INfVvGlKykQyn4sV5sRJtmRaIZa9mi7ZsS5vsMyI9ihooE5mGGUztSSsTVVh7XVkuQLegr4zaXjYrljqSHpjVDtRWI67cqj8Vz3JY7IZgoj4Z0l5LCR7YjxBjl5RG/veJyw67JVjltajI4wiQBJvFvnTkmUZG8OSazg2bjpPERWJuupeKwl0kFktChAFB54stsVzmWX+9UNq1zoly+QkFm76Wo4sm+TCjKdSIf4AeKMqrX+abhGNbBZIt/0ProSElycHfOQl0Yeh2N1JER5dJ5rxGSX0j+PH8+I461ElpBcBvf+VtuO30GVvT6GmyXanwp0zAtFbusB48xkouEI+wEh1j6sOHA6UuO9KiWsy4+wo1ssNrtV146KQIh19BqGBjltf44cvG21rIYa9NF1FFdtbGuVyodCv1ya3Z4MhOpuzg6evdhlViAclMm+ZlOBh3arvvu6tHzLBGqOhUM50GekTAMVkyqtjR43QI6a9Hh/3ItWz1fPlqA2JZKcOXEEwPrceov+NSgSIqrbTu5vw5Kx4g7jy5Nmc/lrhlst+V6/n9SclOFercoIL7nHvNNPA1ph0A0KB6KpSyBk6gB0llGgsgc4pd7s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/19, Oleg Nesterov wrote:
>
> Reported-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
> Tested-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68a2de8f.050a0220.e29e5.0097.GAE@google.com/
> Link: https://lore.kernel.org/all/67dedd2f.050a0220.31a16b.003f.GAE@google.com/
> Co-developed-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Prateek, I turned your "Reviewed-by" from the previous discussion
https://lore.kernel.org/all/67dedd2f.050a0220.31a16b.003f.GAE@google.com/
into Co-developed-by + Signed-off-by, I hope you won't object?

Oleg.


