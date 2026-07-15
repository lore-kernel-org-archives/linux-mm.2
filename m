Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4B0FC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6BB16B009F; Wed, 15 Jul 2026 12:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43DC6B00A0; Wed, 15 Jul 2026 12:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C166B00A1; Wed, 15 Jul 2026 12:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AEF736B009F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:04:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FDEC160210
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:04:00 +0000 (UTC)
X-FDA: 84991482240.01.2322D91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8F5CA1A0010
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:03:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJzFvsXq;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784131438;
	b=h4XCbeQGff0u7KjN1qYZuKrQgRZ0Wt9hDRlHajKoLQQSMRYcv/gUAbIj3sxd9+HPWkr9OJ
	a1qLGcP4wAf8oFnTmowwjK/XFtchHyjpILjBHT6GcB+MTPVP7Xh1SPbsAm9EeOTHNuXgq1
	FU4vxTdhCJK6WBWR/HAP2KESCTduaz4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJzFvsXq;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784131438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=md/jEk0jwM/1EpvL4aXiOB03sTXekaC75/GjnFjny7s=;
	b=hCKD5KDnHx9dXNYrnbVioVwgrMkU38maFzia+G5MqQfuW/rcQ+W71mC9qGvHul10mxiIhQ
	1icl8Tcc4AeQqWjgBeGjfNXV5N2SNygRj19CYlkQbJuxGE9rM+shYtR+RziyzMSo4DBWOo
	WZH6/BjRYcBsBVaVvkOt6q3zWGaAVLk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E22156001D;
	Wed, 15 Jul 2026 16:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C614E1F000E9;
	Wed, 15 Jul 2026 16:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784131437;
	bh=md/jEk0jwM/1EpvL4aXiOB03sTXekaC75/GjnFjny7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DJzFvsXqDbNcfu5SjVj50xj+C83jpeSUODs9GeJaJ6gN6jvCtPFRttyMbHY4U+Li+
	 XdaKxNow5RNCa9sobV54MKYxfWym3ZKF+pVy5bCA1nPBwMWoN0+8ffR2s65W6xICWb
	 dp3cxeJv/n8gDCn6/lgnfESgr+OkJoBnSotjDJZzt2hTNu9ShV49YS98ZJlKxu2IBp
	 9104JoS/X0nPf4K7pd161nDup10h5wtw4W+BR6/zykBWFLSM4qUPdl266itlS5fw1R
	 kvJ1hxkiTXfaRNtFHQvYfUm8jrb94jP3iV7ELRPHU4cfCVd6mVtStHTJ1ArR5GuQuK
	 bsCtqAfKsCYPw==
Date: Wed, 15 Jul 2026 17:03:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, airlied@gmail.com, akhilesh@ee.iitb.ac.in, 
	akpm@linux-foundation.org, corbet@lwn.net, dakr@kernel.org, kees@kernel.org, 
	leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, lyude@redhat.com, 
	maarten.lankhorst@linux.intel.com, mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org, 
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com, rppt@kernel.org, 
	shuah@kernel.org, simona@ffwll.ch, skhan@linuxfoundation.org, surenb@google.com, 
	tzimmermann@suse.de, vbabka@kernel.org, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope
 HMM timeouts
Message-ID: <alevUbqdUmNkOef_@lucifer>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
 <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
 <alecaJ1FUso39D9k@skinsburskii>
 <20260715150210.GA3846105@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715150210.GA3846105@ziepe.ca>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8F5CA1A0010
X-Stat-Signature: y5gsgbz4b5tbp7wsht95r8rdu9ajyahw
X-HE-Tag: 1784131438-227058
X-HE-Meta: U2FsdGVkX18Go7xw8dlpKqfuacTwrfAqFauGeMNJ/QvUa9vMp63Z106XNeLwrD/tjYnCL7IzPc6QSwETm+QDB9eJEsppjqyDnMLXtf40D202XOk5c0f9RI6vfvRaiHJr2p7tfahgCMjhwMV/ULnWiK8Z3if4zs7AZjetipbulTAc6ZtXFCK03QGMECYZfOiLX7iPloMz1ZpPsq3M4M7cJMPll4TIII8yYGl3gRLArXXP1gSHX7GfAId+kFSGEvfh2rtSSUeHdBTUcCfHKmymHuHKOfXHItlK+q7rsRdcjf6vhfXbtenAIJYKPA5O2EJnoshHjek+yzkpt4ph+gOMk4PpgYxgvNvb24En2dLL0Jog/PJyXvinPHMyt3oRdSiSxaqH7u2uStzWNWJ8AxvOJ75w8ACGcIihnZySkx8UTz54voJgGxEEY/XAPqIuD6DPUMR50mOV+9kYT6ctrGAO4xa4Jrx5eesUoxEugnxY24Mo/iXzjkNu/UBzDPjYwryeCbtYOGa3lr6A4z/hrSd54B2YGmYdTh98rdG3d6w58FtwSemv+ryyGYu86+WGoAyPMJOOlUC7i7yXJe0jwFJ/jqZCM0xjG+yR9lMQ4yWvNX/NDTlD7kgNgPqtTu9gLfSddtlcB2hrXzIk69CAyJNc7jWXk2LjYadjy3gMnbAWhfXPTGz/3l/VME9PVnP2gZw7uBMNv6r1nrY9lScCi+M/96S0P/fipvY8yC59k0sETk0b2dSv1XZs/Yt6RcXeC08/3+aonttipp5g0qiehadl4gby1bJOo7FuxB2RFnoEdUI5jU/wn3DFd8rVDLFU7CAwSeR9UaVM972+nXOEmxnUU1SlF2FDj9hD/k+QGz0Ja2YnXowXOMo0X17QiY77MmjHwzia8qBdhIYOE5dZmmXr7u4QSYr5J/VUqjrLUqPo9GiPln7JXLBkDpe9q+esBcTigXdbIGUFNlrxWNVOf3+
 ZHOyd9MV
 gDmMUzOm5y8KLgqXjxw97RCXsPHn32dGEUH5bXJ6LvsC3hxszchn9Nr4v2bJ+ifpppThmlciUgLgcuXRwTsjFpwubRLwARscnZHxSfQ1vPqixUG3FwSsVqpCqXhFGt7z/mtt6Rsvy01GcWBVGYBdhW5jf/bpFJu7Ix/9oh6HiQt0mB8VtXgcJIa2RVZ2mOtHHoh55TSJTh38tQojIwQWeXB12YuNA7PnlRGwG9vi/aupb9nXLKiOLVwa2mVURGqiSeywk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 12:02:10PM -0300, Jason Gunthorpe wrote:
> On Wed, Jul 15, 2026 at 07:42:48AM -0700, Stanislav Kinsburskii wrote:
>
> > > > Stanislav Kinsburskii (4):
> > > >       fixup! mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
> > > >       fixup! drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
> > > >       fixup! accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
> > > >       fixup! drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults
> > >
> > > Why a fixup series instead of properly resending the full thing?
> > >
> >
> > The goal was to get a Sashiko review, and v8 has already been applied to
> > both `mm-new` and `linux-next`.
>
> I think if you send the whole thing with a base-commit tag that
> specifies a real base commit in linux-next sashiko should work
>
> Jason

Oh so just use b4 then :)

