Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45095C44506
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 05:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09FE66B0005; Sat, 11 Jul 2026 01:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 058C56B0088; Sat, 11 Jul 2026 01:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8F76B008A; Sat, 11 Jul 2026 01:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C92886B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 01:48:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6446F1C3EA5
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:48:38 +0000 (UTC)
X-FDA: 84975416316.18.70B5D4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A1240C0003
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:48:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zxP6H3RU;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783748916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bm56TdW2Rt1TzYZP4AwroZ1H/akE8N7PaZmAo9v49o=;
	b=1Y3oTA6wbUtWsTlagA2O7LSTox69f5V0UukCfUAKfkn6vftGlPjBcHyPBXi0MKY2JZOpDc
	64J2lM3o8wRCWWtdi9jXi3fY8yanmPV5jTqocYS4HKQ1dX0LYxXxeyzYMV7qwIVMJY4okh
	1+YfB4RgTK17fv8ugI7N0zxxKrkvgBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783748916;
	b=AetC5V94BWskC8PeE5kUlVr50LEz82CY+eah0sDEqydDF8esiGLYY3WVpgn7X8JAG987F8
	hKI7o7AvLGzTEjC2aMilMNxuPuarrx+jjXaqOYQV87lpwaNn64B5uZHtESC/X4AjcxHHKo
	INAuRza0df1RshNrsXiEOJUIi1bJEro=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zxP6H3RU;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 839E54166C;
	Sat, 11 Jul 2026 05:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B1C1F000E9;
	Sat, 11 Jul 2026 05:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783748915;
	bh=/bm56TdW2Rt1TzYZP4AwroZ1H/akE8N7PaZmAo9v49o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zxP6H3RUmBd6ihlhUQIdRJzfv+dWAy7/NIa1aujz+UJUigwYO9G60/3Bm1HoqfjnX
	 DZhiti+OpHf6AgYSszNldBtjYCKgg5QG6160LxG4/45mDd4arD7V/RUmAhgcW9bWTx
	 E9/cf5f5XfN6+ulL7h4VwT+i3BR5zKS6NdueS7go=
Date: Fri, 10 Jul 2026 22:48:33 -0700
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
Subject: Re: [PATCH v8 5/8] drm/nouveau: Use
 hmm_range_fault_unlocked_timeout() for SVM faults
Message-Id: <20260710224833.9caf2a0a9906f0515e326a45@linux-foundation.org>
In-Reply-To: <alG1k3JsoywE2CBM@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371881847.900500.8789369230260725500.stgit@skinsburskii>
	<20260710151222.ddb35eab9c81a8720491464a@linux-foundation.org>
	<alG1k3JsoywE2CBM@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A1240C0003
X-Stat-Signature: o7knx3ki3fedeotf7f57nmxpdfng3k38
X-HE-Tag: 1783748916-930568
X-HE-Meta: U2FsdGVkX1++WJYj7vSOiSIFEdUxZvwMSf4oUAwhE+gOSUCZyd0NeTJr/6+909pshBn3rdHz65W5pLtEBjbeF77fnrMUM0zcEwZheQ7y0oxzQoOfLK3SRX4ZIEc/qzP5ftLdbajx4vGemRbrp7VoVV192zlXOEghXT143LWJeSZnbZZagxWSzyYkCia2IMEtgcL68BMg1VFbzfaK9O7mGGn6PyGzqsc/fb19wrDyeoxBJwp/FNShoTqDdZ0+LMkl8EdSCNtTVa4urqQW9rH3MSLd1/+qiHjhFGo8EdpooikQdJYdBEH8EDXaQA6GE9ASK+gLtwC/EgRoMFnTEcIp/+0Tfoqxqn7fj5sgqPTLrIWpJTCy94iYL1QN4KERGG/cfL/hc3gpEwvU8/KXZ00bU1PlMkrTQRafos5C/h3HhbmvH8cTxQicOgLrg7fawzLUW/CyBNlOcUgiIdc/aCES6JfjzCwBr1FNkI+6eyMkBE6xzyBNX+ZdAwY5boAKb/yrv/yJ7MCbyTewHAy4j7PyxhcsWM1sbESYv84TfzjjcLDLLBAV8h394EeyEF8tvdvr0DNB7iJFhmfdWfK750rkrF2RrW7DUN9Wvu58ALe77d7/QIAeQ0H1q4PWqoUooRC9vaA3vlIJcG5SjazGKNxaOM5Q+B90FaLI1svkDFCiYDrzNTSw3NOR3iHDE7Ev2tKIWfOxtGnHteStoE/gTdUfFiB/YkHmlqJ62kKFD2x56yfZuq1X8nSYjbPorUo2rwAFTETQab4dbxDfImPjZt9naYvBl7hPkj/VtCcPT6Gf76Txfvb/gYwJujp2Tev3aMQvRjJlRMH7Dy0xIMYO8Eb6mrCSQ2cZGDOirn2Jr+6OVp971vTUiWexKnErsiR1HNJUyFohkMF95XOztdagKDfGfj7B9CIgiFT0kLaRMJxWIvoxH8gQ365UrOBAxo93wy4ZdQDvDZSbZzUlze7hK0A
 ht+p7MAU
 KPyujbEywYlvjZw5zADVesHNNXOdYGc8m2ObvvOJieD7rrsnhLPT9q9MQrRBx2ivVnE82kM4V8wdHUHXS0g9U08W72N3U6YaatDP0sYe/ok/hAPZ5mDzF5gyTFL9D/owr6nQh0Go9FZN46bBVKAAUQrV9VfkaNLcPTsq14bIzGsh5NwUoh2d60kq2Ce5cLa9ZFg5jmCRWjhsLOZkbNOG4osgwKz/AugaPpGGndhoj+hEH6fLVvZIOtaO8vLESc8+t5++sWQ88FGuRt7Af3BIiAgqNogtS8s0fg1hRazY9MgaxkbJytmU5XQq/kBPJXWC09Nkk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 20:16:35 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> On Fri, Jul 10, 2026 at 03:12:22PM -0700, Andrew Morton wrote:
> > On Fri, 10 Jul 2026 14:26:58 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > 
> > > @@ -683,15 +683,11 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
> > >  			goto out;
> > >  		}
> > >  
> > > -		range.notifier_seq = mmu_interval_read_begin(range.notifier);
> > > -		mmap_read_lock(mm);
> > > -		ret = hmm_range_fault(&range);
> > > -		mmap_read_unlock(mm);
> > > -		if (ret) {
> > > -			if (ret == -EBUSY)
> > > -				continue;
> > > +		ret = hmm_range_fault_unlocked_timeout(&range,
> > > +						       max(timeout - jiffies,
> > > +							   1L));
> > 
> > "1UL" here?  I'd have expected min() to warn, as it likes to do.
> 
> I'm not sure... The "timeout - jiffies" can become negative.
> Won't 1UL convert both of them to "UL" and thus make the comparison
> overflow?

`timeout' and `jiffies' are both unsigned long.

