Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE659C44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 05:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38756B0088; Sat, 11 Jul 2026 01:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7BE6B008A; Sat, 11 Jul 2026 01:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D254E6B008C; Sat, 11 Jul 2026 01:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5A496B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 01:49:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 58B4940653
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:49:54 +0000 (UTC)
X-FDA: 84975419508.04.44473B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A2E0940007
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:49:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kbiBT4UI;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783748992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORvew2lmZPoxsW3E1uuEKYOedhDenWUn2ruaSYxV7Zw=;
	b=5q9abaSewVbdhNChJ9a39eDNDXe+X0e0v7vZLNEGNQzaPNamyBCnDic240w5dq+J2JNEY8
	XvG7xdzkbLlWhiGrH82pLgmKNe6WKj/VtXKQfNcPOmgvrp7gTN63/X7x4fBTheyJTzvyqU
	OmMv+94nqSG87eFR4RsFZr+fi3M1mBQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kbiBT4UI;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783748992;
	b=HYFcKFE7CtQs/BQMKYvb1OWDx1wLGjPr+T/hy661MoWm1zl0vkzKRTOLVH9mX9TMg5ad8d
	amMNyY7oJJIPKyT+SjXJ1I/OB1xrl6vJwK7jCefVYyyhgDd/aZxEw0Z6L3Iv4AFMjhTkyw
	l3W6aJV2XBED3d2fb8gc9xmQqAR5OaI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B50F042EA4;
	Sat, 11 Jul 2026 05:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C7C1F000E9;
	Sat, 11 Jul 2026 05:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783748991;
	bh=ORvew2lmZPoxsW3E1uuEKYOedhDenWUn2ruaSYxV7Zw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kbiBT4UI8EsOzp5Z6jcjE98+zJxsZeeKjK7DQ8Q28feKtSsl5P2ADzs/pTEcqC0/J
	 QY82X8hqbvOUNwXy7z96UyQ9MiH9eTOe4kxzhnxuDvLyE2M7RAXChoKV7pn9eSdotM
	 zjLpw7SDmjk5NIon4EHpDP7oKzGvYv+jnEP2DHoA=
Date: Fri, 10 Jul 2026 22:49:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260710224950.53bcb43ce7e564f07a1f6a8c@linux-foundation.org>
In-Reply-To: <alG2-RSitzPWClAX@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
	<alG2-RSitzPWClAX@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ikgkit34mffk8eaepgaowskci1q69g6w
X-Rspamd-Queue-Id: A2E0940007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783748992-495490
X-HE-Meta: U2FsdGVkX1+UC0o0DIoawc3ehhx1qSL3QYiYGGOUuBV0F3aGyEO7jkDg1PshAG6OLA7P/tmiFoAjsNjKaVOduvUwSbDotD7S0k9G8k367VhhSEYwytoP5Vl9bjdLYk5Zp6NRkrjJUCbAz0B30OyHLb1ksNEIEeIKj455vlykz539XykPW0MBmlDPbaRD3fuFwWZGQo5WkmRRHe8eaCMpMwts7PeFx9ANSvi+iHpzYCSXDlxyYIalMihduwVABvW0ZqpuY19SPvIBvHNUCfHwXRsZGBtxgozyLTY5DKv1eUOOT9ATGZxBvnI+JHSwJlvKKqLNwetxy3l+cimwD9lqkWoZfNen+DZCLQZsDmTwIni5v6eHkZvIPOu+JHGSKjAW5z3LC2Ps0F/Pok3qFTtK1EGIHWU+sjI/N4D2c5+ZFzl+yumjl4z4MxKI5eOHTAWcAZeIXtvnM8rflH80EbJ9bmbT8c1+ECIT0O8FOtNxbTgPuN+k8Q+wgcyyFmhQZyOZn2nhLCDe/BpzYDMvpwnFeXWJsOsc+OlhD2oNuEuCweWtHHVhohYJhQy0rB5kyAbotlzd8EQQKRbdXzcQalHWiS+AVto394U4m+1xuvNJPBM+nvIz/yslWljkCT+xUkKRFZlEFIN5KaeHxAXqe0k4By/PNizf/OXYaF/1bVFPPTrvxG1fTTKQ0kLlHqNXPUyCs+ddWN5OmMU2XvIyLfa1BLLFxW4D8ZpGT8sj7PpgJvjJrKTeQxcoaBBuNbMNOFLJAid0UQ2y9bDYKSp769ZSqev260DrQXazaVgWObK2X5OYmL+36I/KkcwA/OnvAAZs94+FniSPOjsRW9oUquk3qeZ5X5sn60psfc0fYoECrdaDD3WbeJa/9fD0FyY6Zqwi50aSYtSpo/ee0QpIsQm5G9BF8jfBTE3jeJ8DKP0jEUzABnPr1wA2J3Y9QEKUjhtkvxxdm12jD9N7D7ltBWX
 dA9tpy3C
 iQFCBSCT45I2f2R2IiSBXfnwSN46NhK0vVYU2o2VdF8V0sTuHFSQIbOAVb7ir3mjKUXkxjOzMeBgX9j8IJzbjYyVNyyWVLROjFqU8KfvIDESraCS76B77wjKQUhwZOeUqwYksg0/t1lOORX3S+aC9f6jDIqjvzVwNEv7YY0FhYUTtU3kcq37PZoWnZXhr0hCiSor7guntSXAiXOol6c06J7n4IoOSwbInwDFPdwYiRZzgmXBZGgE9+lkSeRXTh1+PaSMAlKt2aEva/Bk7tD5wOlayrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 20:22:33 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> On Fri, Jul 10, 2026 at 03:11:51PM -0700, Andrew Morton wrote:
> > On Fri, 10 Jul 2026 14:26:20 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > 
> > > This series extends the HMM framework to support userfaultfd-backed memory
> > > by allowing the mmap read lock to be dropped during hmm_range_fault().
> > 
> > Thanks.  This seems fairly mature and mostly-reviewed so I'll give it a
> > spin in mm.git's mm-new branch.
> > 
> > Unfortunately Sashiko wasn't able to apply this or v7.  I'm not sure
> > what base you were using.  Hopefully there's a reason for a v9 so we
> > can retry this.
> > 
> 
> I rebased this series on top of mm-new right before sending it out.
> Should I have used a different branch?

mm-new is good - Sashiko attempts that.  But it's changing rapidly at
this point in the development cycle.


