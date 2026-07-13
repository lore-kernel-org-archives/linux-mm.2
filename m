Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1960FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 23:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3F36B0088; Mon, 13 Jul 2026 19:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E3D6B008A; Mon, 13 Jul 2026 19:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6476B008C; Mon, 13 Jul 2026 19:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 866716B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:18:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FB8A1C0123
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:18:25 +0000 (UTC)
X-FDA: 84985319370.14.A86DC92
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5955120002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:18:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="nZler/ys";
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783984703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f5EDysaFuDNgPurWzUMZsX1j7CfSV1oHh5QC4rjPyqo=;
	b=OZf1xlvYDqFLU4zGk8qeHdDZ90BSGHrYsX3V2I0uq0ZcJn8HhIsE5e9vjdf1weVnUwHRz8
	mtLJsaHVjKxVACsd4oA6yXqCTv6KQkG0TGAqlmXACTkNYhPg1EUKTRV7KU0GGe9yFl4esE
	GanI0YQuBnz+hpAINBQD48ziu3VjQuI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="nZler/ys";
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783984703;
	b=J3Iep0cYNQ5yNJO/hTD/cFE+0kfD3wqUdbRRni1jrKGGgAxyVXeNhuKsbv8ajzUTT7VL6+
	1+L+5igTvg+Jv0jWhpk2rBTBWh5199EVUXdvOI25olrFkvzSZsuxUn314lBgpZyBu7qW9B
	huAu8mXJT0A0goZhPflDp1gosdlTJAs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B6CC4170A;
	Mon, 13 Jul 2026 23:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E807B1F000E9;
	Mon, 13 Jul 2026 23:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783984702;
	bh=f5EDysaFuDNgPurWzUMZsX1j7CfSV1oHh5QC4rjPyqo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nZler/ysO6IBo934carYd2XqUDIMaFaeiUMVtZhtTP9n+0D4DjPtZs2k+yOsT1Fx5
	 TLAeqjC/pvL6zMH2/jytpd4FVcVHGbYHPanj59p1Zh69G+c1G/sD/6MLodFGtLct3E
	 XADqVu2KrZngtk7/bOTMrI43ujnTM80o4BDpBedk=
Date: Mon, 13 Jul 2026 16:18:20 -0700
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
Message-Id: <20260713161820.8f72577b91c730a2e853f6a5@linux-foundation.org>
In-Reply-To: <alUZZYIPY-UkhpY4@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371881847.900500.8789369230260725500.stgit@skinsburskii>
	<20260710151222.ddb35eab9c81a8720491464a@linux-foundation.org>
	<alG1k3JsoywE2CBM@skinsburskii>
	<20260710224833.9caf2a0a9906f0515e326a45@linux-foundation.org>
	<alUZZYIPY-UkhpY4@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i5446e6dbcfzusdh4sm9ay8qug1mg6uu
X-Rspamd-Queue-Id: 5955120002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783984703-303571
X-HE-Meta: U2FsdGVkX19JCYDvUDTLKJ2HYQjk6nYHdC26Pd+v/aWUDh49Q+HF3Q0SIqhOZ6pPd5KtGSp2P0D4s77xFCBHNDVulzY6llYXvjWrlVSKAXfQgna07J87+i+n+muiE+GSppsUeEjdt7/spx93Gn47QEkP1P9+U16weQHo1TcRs/OkXTaY+shgpzBR4OR9/tUDdrTO2UI5Bo9v0Cjra6K4YnsyQzUcAObx9kVlDHhNojtqlkK4sYmwzy1aNr1UfTKweEc18iygs5fP+I2+7D1XbZdkbF3MbATEnaQkES733c/lS/EqvkmTQayuITa+THT8FqeOHvbcWTz5wKBAplSVB3VbYcVdL1hvQbXFO7g6VRD1z1DJREk5DRGlM4YfrQVwNw6IJbPi26xz0ojW2zJv1p/SmVcYV7udMDv38ixjagdukKYe5p98MoZ2A0TGc2Wvy7VTH7tAWkEnAycKQ7mCVvDJA5Fxte9HcOz+8XdZAnKjCTF+I+TMNOv2NASMNUs/nuKYboXk7rIxSxkzMS8yjjPEnNT0eRx0B0xlHWuIjIQegEx9fiQuan4kAVFkkZA9YynhKBiyfbJw74qDDmgCJ4NwvgkcS/Dox1GS4cMrwm67QVBya/ejXSK2zzJ4a1pQpFL9yFqjeCgzmVnZgv9ptVD0BHkxWSae0ydcPQ/g774QMKQSpHwPZRcXrCaOCkbiPwPDoRsMQzLEyotDDrvrYH0EECMO3x5LaHHjhLeyKYV2dT+I1W2RZ8osROPw8x/194/8vvcBsK1J3oxnUoC3dMBmwocF6XQYCL6yUzKixEEoRea0KgeXOaLe/CyV0h+3tLrw43HjGNX+7aVQHrwyuVG5Qtr/RANpAfiTXdt/qgEP/+4IxSE1c90MsPOqfB2YraljbFhJkzaZoVJT9oRwaY4fHI9bdqQPEZ/0OnIcXZ6J4lXwh93pjNOOCWHfmtGVvAnbjDZXJzmMRz/7eGj
 wdVk+h4D
 acFxieqF5xqUqcvNqNYT0mxhbPVagx3Wt3VktGAZeswAfRduT/eHDY/WIvIYTdIAi6TRPnIvBGYXuKcImDVJjjN5rTDJmDSZMSX9iBXbNOCBK9uYYoTDqqXy+Bc9cuxu4jSReTOOr/mOLbTcudtb/6c34DPt2oqPkIScwlWTXBYRBeQ7lAJifjlVvXP+pdLWlLQhTnkEk1Wly0WTjJXmmYrdN2Gca9lpb8g60J6dJ0WO8BXUHpEOmGE9gxSopaUIKd60T0DSDbtoQeB5jz6HJU5lClikEhq92mGvtQ+zB/2XKPnaUKQMxp+OSa3vOjrmb/n6heu6J5D5tuuU6AQyyNbsJq1ubzIHbkdHL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026 09:59:17 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> > > I'm not sure... The "timeout - jiffies" can become negative.
> > > Won't 1UL convert both of them to "UL" and thus make the comparison
> > > overflow?
> > 
> > `timeout' and `jiffies' are both unsigned long.
> 
> Yeah, I’m sorry for the sloppy wording.
> 
> What I meant was: will "max(timeout - jiffies, 1UL)" correctly handle
> the case where jiffies < timeout?

That will return `timeout - jiffies': a smallish positive number.

I'm not sure what's intended here.  Perhaps the code should be
using time_after() or similar?

