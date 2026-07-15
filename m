Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 913BAC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 17:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 324F16B0088; Wed, 15 Jul 2026 13:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC5C6B008A; Wed, 15 Jul 2026 13:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6A16B008C; Wed, 15 Jul 2026 13:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDAB46B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:14:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CEB180251
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:14:37 +0000 (UTC)
X-FDA: 84991660194.10.5590F3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7B05B40011
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:14:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="2QLj0B/E";
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784135675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfHHEaVjP268tDYxyafxZXD74CF9fG6Fu7sb5cedFpc=;
	b=FToorvzPe9Mjsck6XeM9EdE5YN+62nbkeMZEfvtMpppPUaYASRIfufd7vh5vqeIFlzWQXa
	CTILNuo5kLmBNomFxreaXIu+21eNLZHURU+5C+7YOGWX6dhNKGNCK4VrhGE0AkhiScfRW0
	V8InNbz9DPxVjgIz9BPm+rSIBXFZs7c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="2QLj0B/E";
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784135675;
	b=xguL7GcPfkTc/Jf7HFgmDiXNPrra0IKnmgHegypNnr6PHSMKPi0UiDFichPVdODgObREWG
	xJaL4nH9aD+tDc7xs3Y1Jjwtt93cD9dafCOX7qi6qiTOb4oTEaRvAMKiBw0yGTyvI+Ccfl
	a8JY3M1j7VIqd0RraCbEicsr0ejPm/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89B8E437DC;
	Wed, 15 Jul 2026 17:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F26D1F000E9;
	Wed, 15 Jul 2026 17:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784135674;
	bh=TfHHEaVjP268tDYxyafxZXD74CF9fG6Fu7sb5cedFpc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2QLj0B/EWa4lYbwGV5I4Q8S6EE2h+YoSscnlwHTueR2CgkYheQri+8JcigQG4CilI
	 gBtr1vMmIm2RnvVB9VFHABy+xQcmM99eg1Qt5ThrQfI5xX4O1/+LDp/iHJwv379AK4
	 UVN02ASUZrntaUlHn1ZMkt1GZEdVN+Y4TeFWC3h8=
Date: Wed, 15 Jul 2026 10:14:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "David Hildenbrand (Arm)"
 <david@kernel.org>, airlied@gmail.com, akhilesh@ee.iitb.ac.in,
 corbet@lwn.net, dakr@kernel.org, jgg@ziepe.ca, kees@kernel.org,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, lyude@redhat.com,
 maarten.lankhorst@linux.intel.com, mamin506@gmail.com, mhocko@suse.com,
 mripard@kernel.org, nouveau@lists.freedesktop.org, ogabbay@kernel.org,
 oleg@redhat.com, rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope
 HMM timeouts
Message-Id: <20260715101432.99957d2d33203fafe4af2e1c@linux-foundation.org>
In-Reply-To: <ale3ydkx1xt6ruuP@skinsburskii>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
	<4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
	<alecaJ1FUso39D9k@skinsburskii>
	<alet21wLwM6P_Km2@lucifer>
	<ale3ydkx1xt6ruuP@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B05B40011
X-Stat-Signature: xw3yhy6o3jmih3n6fscumgy3wx45hc6h
X-HE-Tag: 1784135675-977672
X-HE-Meta: U2FsdGVkX19B17xkjxWqQc590jwjG3vXFQAQ37qwcYnga5LmxZMEw/I70P14gOfvkmXAxLzapvquts7Z/UNBdXrQD9sXfiTREdVj5RiUHUMlXW+QINj3bQWeoNhjHN8aqo5xzPJpSvTtvffma3zaBEzWxjsfxXuinPTtabcQR+BtZ7nvLp++GLw1iAYSYEjB7tciPd3Klpt2nv5mfoHnQtjTGBMPJM5zjYM99r/jaLDN6m4YvUCOBftR1eCuN4xabNFA62EcWWhXQjbvnbcEcS5hLjpqWADMk2W2IVU7lDZTxxpX7NpjeLuIVRjuAezdrl96zTzRHP8OcnFzyZ9+v4Txp+uCi2z3ncKcZeF0pMtMbKgJI09u3TMNeTKwEviO/uLeW4teWpj7JzkIUzjXaN6rnu+9VU7XoBc6BIwwuUCaCaam3OyIWr5ZzsEjkWQKtfVMWNJpEyKZbctMnH4gKW8q+x9K/NGZzh3z8bc0pgbd9em8ZkfbZrxSk5ihju/EZGLI+ial8zvkvz+inkaUyR3hY9JbOSnjOAYnlkZ0r83+UjaFQSd2H+B1cYyMhP6iWBbadjQqR0uRZZCSLAJ9f0kJBiLSU5sjiF5jW88oRB5W/jhpY33x3hR80UCfWPi9AU1P2hDlpnpZkzGq93IH2SnCNOXojMId2tEsVi0VUqdgvLS3ywnskIvmTZvqUIdnrSo9wVY3sxm6nPOjiBX3Zp4hET3PxjDihxzyN+0ayGsS2VPbXRqBZHOG7QaASZsizggqXHUdVv1ZLuVy5nhNA0M87sL2uVhMgDn0dDkiQsD3AO308sQ3D1T+BSF17S2NljNG5riYDCb0IcyaSduibYfCaohZOdEqXSsxmPAV5xBWx8diNKVs3Hq+S3Ev33oQxJe2zkBoKkcmigyotU8dGZ+7jr+oanHmJzTTbc1HzngoHJ1/IUSOaS8lEObgkcdM4ISpCsPEozZ5pBsj+D8
 7sKLqSts
 BY5dJBqBuqJuAZTLdfc3MN7HPPqsQqnY1mj+C2V07SULKCy8J+dRXYwAR/lA5a6lK+zFRv3SjQIvPaKHjKWANsW0dsUaA97WzwtdA5144yzzziicH9udr+PWzsdF7NCaQ9lg78j+MRhssJ3/eh0dLBPJmdBchabAZEUK4hOyuBIUoeOeoXuCwDa1Y+vEcRsejolc1lLnW86ZdY4dB0TcV1pvYuXeMsNOD8sP0+8RsVPw8KTSonFASOIS6gHqq1pG1pvKOmGfwxAxe5Zczt0TVQ5m8oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 09:39:37 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> > > The goal was to get a Sashiko review, and v8 has already been applied to
> > > both `mm-new` and `linux-next`.
> > 
> > Please don't do this, this is completely impossible to track for review :)
> > 
> > mm review is currently very difficult based on volumes, it'll become impossible
> > to manage if people sound fragments of series.
> > 
> > Please just resend the whole thing at this point.
> > 
> 
> Well, I followed the guidance provided by Andrew, and I believe he
> applied all of the changes, including these, to the `mm` tree.
> 
> Do you still want me to send v9 under these circumstances?

Sure, if that's what reviewers prefer.

This is a bit unfriendly to people who have already reviewed the code. 
Which is one of the reasons why I respond to a new version with a
single diff showing reviewers (and the author, and myself) what changed
since the previous version.


