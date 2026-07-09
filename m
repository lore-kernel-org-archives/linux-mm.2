Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2B6C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 23:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D245B6B008A; Thu,  9 Jul 2026 19:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD5B6B008C; Thu,  9 Jul 2026 19:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39756B0092; Thu,  9 Jul 2026 19:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 998636B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:12:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C7A61C1DB7
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:12:57 +0000 (UTC)
X-FDA: 84970790394.23.2BD94D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 59A4740003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:12:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xc1VO2lC;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783638775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I84lwClwr7WKYOtvw97IHdoAVdLHDfgnUPPS12fE478=;
	b=0qY4ibCGDPH0RWnFvFlfn2yCfwODvFb4fMH7qG11hkqIY2dWKao/QGH8nSZWs//BvyC1vW
	tq23VmtQDYn4TFrkKon6jqoFNe1ibuCXkfU0DNiMCTEEvDGlNytr9GI47zUqU/tOH6MEz/
	4ZeAY8E3UvV/avFu1yyd3mKsKr9awlw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Xc1VO2lC;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783638775;
	b=L7+D/ww5WmqOhLOSj5LdmJVqoiA9Oefif2boWy1xNhSbrvyX1BTagSj4fIhJaz3J+vdfoP
	UAZF7IhqT7KGkQ0EonMtCX+GTWHksFSFh/DOo1wj+2I6OKKbERe0OcU2RJU/yKgC+SFfaq
	/x5keIO5nuHd4UbLJGUiUw1HFNhLgmw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7889941081;
	Thu,  9 Jul 2026 23:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F7D1F000E9;
	Thu,  9 Jul 2026 23:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783638774;
	bh=I84lwClwr7WKYOtvw97IHdoAVdLHDfgnUPPS12fE478=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Xc1VO2lCqZ5yuD9RWJpNxpTLtDTt2YkmCIqYyXQ9lHeRvQmc+zjFTyG+pBIQVqPIo
	 l4auJZD9bWfgu77dxmLyRua39oGNL+sHbTtvsd7SRiup4JiREXagXOOxGffAnahqmF
	 ph8ZsdIfgIwOLcqBIsKUk36EjN1T1YtYuC4XyGy8=
Date: Thu, 9 Jul 2026 16:12:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Link Lin <linkl@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, "Michael S . Tsirkin"
 <mst@redhat.com>, David Hildenbrand <david@kernel.org>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com,
 duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, Ammar
 Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com,
 ahwilkins@google.com, Greg Thelen <gthelen@google.com>, Alexander Duyck
 <alexander.duyck@gmail.com>, stable@vger.kernel.org
Subject: Re: [RFC] virtio_balloon: fix Use-After-Free in page reporting
 during PM freeze
Message-Id: <20260709161253.6b5e9ba349f70a3ebfb8180f@linux-foundation.org>
In-Reply-To: <20260709224330.946683-1-linkl@google.com>
References: <20260709224330.946683-1-linkl@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yb6deowzfmp78nz5u4j1jahd8tq8aoim
X-Rspamd-Queue-Id: 59A4740003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783638775-538901
X-HE-Meta: U2FsdGVkX1/phU72gmQleJBjbOcHDUQCdJsbyvuAM7RO0aJvH56WwwoY7egN0AjETH6n5+3BUb0HKJvnN306d0UsI11V9pidjgYWdzJD/cm1GkHndu7cwNTdu+ZWJgHQE4Ig0OAedf1TxO4F8zIdfMkAwryqhLnjw10ICNVpGEFN5qR554ET31V0mJQ1n9Y0iLqgd/EvUTKH2gl3jOQy7MMsY0mQ5/77fpB/PZN/oCuw2h35Y64wpoX324bOpUvVKOJoGla0FNKbHS9pb/zXOA09I+TE8Lc56qbbPukUqZyf5uZ/ofdzJkCkc89lWP+hcpMN1GUMse1uBATOGtAQ7tibEdAGHWsZMSaFA4Befmdj/7SEEGk2Eybplu94rRw9BqdxWwLAJ1qgKep7f/kJlr0pcQD9xfBhT/M32baxA6Bttlu899nXZbklKgvXmpUP+Grzwdl19K3uGlUULI25ujGIHsoJ0fOfZhTWki6lwE5HUJ40K1UfOPh431+S9cKI7WjBq4hdfxuR+mf/YVwJhwucHn6arVwJh8rvxi0tQHaCmlrRbMZZb7hXLEeoxm9vnsQjzkqEVnYNLhJxtvBJpf9ksqIxNZAPKKab5yo+Az7SZp7zaQXOVTPoFEE/oIVfJT6EI2Otqln0iXII4UTSgpsL9AGoh0JClBwQ9Vx2VPbA1CgAl7LNwZy3LfrXWmn31fS8DG6Sy5TFS0M88bUx50z9IL14XIoaPwEAvenIO7Tmg5Tqg3M7Sq7YdkH+LuezzPj/ALA0zVHvTAtq1w4Z9nv6RddfDLfnwNhZ/won+LQfOYhhb3i+AgqzNqIl3YEVzQRyBSKfxOStKicxlmaQN8TVuyxpBc5aM61RDQqBixNOA7A1zLdcz3ToNef7jtMVOYzN0MELPTLyayvMzlccEif3AOwvrASEtSEmmPQm1gcG881/I6SxANMs46fojthUsFdFV7E9OpjoSb2RJP1
 kRU0egg7
 GZZ3m0Sz+LrCNWx/C+svECv8NiEOLvYkdJhyjlr5Q3viMsTbrSO70RQOzov4BLMctYTLpOXho8NNSQywJp6Yz0ZFOsy3UU3w60fliYbFzqpUEJrQHmaWJuKZMso8h5dcIE+c67Dd4n32QWMveHQ9Uf+3ZFEqgZYXFVzewhwINSPEdPE0EFb4uGYRvv1OouXkQsgNz+nmPOha0GKRTrgfeBuNom56unG+xNEBDc9iJF4lxHpHVejceUnMP/dTuEKyf6gV8GJRmJs5uBBTWZmJ6zfl6zA8YMvsbTAqrO5ft48OupwqF5IjvN8dDEbERxFp9MOBzI7lAq+lbBGlgkcS16m7xytopZjGX7g+Yg5n1bDVvHvY9ES9eWJ/+m8wJvhldb97jaDqx8kN92hyyukQX3B53VM+ulG480p5AUfTBroJX8xoifJFMRMXquC8AXbyqV8oxd6HzYk97ZBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 22:43:30 +0000 Link Lin <linkl@google.com> wrote:

> During system power management freeze (e.g. ACPI S3 suspend or S4
> hibernation), virtballoon_freeze() calls remove_common() to reset the
> virtio device and delete all virtqueues via vdev->config->del_vqs().
> However, unlike virtballoon_remove(), virtballoon_freeze() fails to call
> page_reporting_unregister(&vb->pr_dev_info).
> 
> ...
>
> If memory is freed into the buddy allocator or a delayed work timer
> expires while the device is being frozen, page_reporting_process() fires
> on system_wq and calls virtballoon_free_page_report(). This function
> passes vb->reporting_vq into virtqueue_add_inbuf() / virtqueue_add_split().
> Because the virtqueues were already destroyed by del_vqs(), this results
> in a Use-After-Free / General Protection Fault:
> 
>     [  250.709271] general protection fault, probably for non-canonical address 0x7f728084daf08d5e: 0000 [#1] SMP PTI
>     [  250.732967] CPU: 2 PID: 38 Comm: kworker/2:1 Not tainted 5.10.0-44-cloud-amd64 #1 Debian 5.10.257-1
>     [  250.751575] Workqueue: events page_reporting_process
>     [  250.756665] RIP: 0010:virtqueue_add_split+0x233/0x4c0 [virtio_ring]
>     ...
>     [  250.867678] virtballoon_free_page_report+0x3a/0xe0 [virtio_balloon]
>     [  250.883446] page_reporting_process+0x225/0x4f0

whoops

> Fix this by:
> 1. Unregistering page reporting in virtballoon_freeze() prior to calling
>    remove_common(). This clears the RCU pr_dev_info pointer and flushes/
>    cancels prdev->work on system_wq via cancel_delayed_work_sync().
> 2. Re-registering page reporting in virtballoon_restore() after the
>    virtqueues are re-initialized and virtio_device_ready() has been called.
> 3. Unwinding virtqueue initialization via remove_common() in 
>    virtballoon_restore() if page_reporting_register() fails.

AI review thinks the patch didn't do the above:
	https://sashiko.dev/#/patchset/20260709224330.946683-1-linkl@google.com

It also might have found a couple of pre-existing bugs in there.

