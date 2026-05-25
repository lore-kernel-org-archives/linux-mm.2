Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF312CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43AC86B008C; Mon, 25 May 2026 11:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4112D6B0095; Mon, 25 May 2026 11:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34ED36B0096; Mon, 25 May 2026 11:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2561D6B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:19:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 603AF16050D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:19:45 +0000 (UTC)
X-FDA: 84806301930.05.95B6AFD
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf12.hostedemail.com (Postfix) with ESMTP id 70E8540005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:19:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=t5iZPTVd;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="L vvWtHK";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779722383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+fmVjGYU7bTYKBfSi8JXdSR+0SLMTaXTvd5eVBiWdg=;
	b=aLzU3uslliC/2I0wG1YU+vtakAncRrv1FtGq6N2wDk3tDqRgMTa/kq3lKc+O4a5/qnESRd
	4Cx/C5WmMVaDHCPoPYo8SUYbZQTEoKusOdmXuztNE1nb7BNji05uWQF9/vp7t9usYnvUqZ
	lVMQ1vbrUq1S9WwB9hmwjaZlZcCrGiU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=t5iZPTVd;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="L vvWtHK";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779722383; a=rsa-sha256;
	cv=none;
	b=d/jwFYZwFiQtrqEg539N2jL4w2ofNEMItA92yZUYh43HPZ9v4EA8AshuvqoBeH2Eo7VxqD
	EnTSdAXS2qbWhRON9+Wx7+JeE69tChPnV1PuI+ZiL9tzG/iK98dR1phRP+KfL5iBq7uheB
	TqG16u5SuYdadtcKGqpsaDgLjQJCiTA=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id BCD2A13004E9;
	Mon, 25 May 2026 11:19:41 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 25 May 2026 11:19:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779722381; x=1779729581; bh=p+fmVjGYU7bTYKBfSi8JXdSR+0SLMTaX
	Tvd5eVBiWdg=; b=t5iZPTVdUYy2gjJM6u+f7g13juYul2nhHeyx1ZN026RU7Ifc
	OAIsvHPGicnjSQCjK0b2OIkO5xgHmvf7OkPYQN8hvS0tHlVQBhwJVHotru8LEiaQ
	ouPF4NQdxQIcmApSKv8Kt+wlg7OgRWLV7bdmwrNvUk+XuQqs8hbQl/SSUJ4P9Zhi
	TLMDBMKktWtDxeSQkYySZI4eGy+XKsFuRfAzZAhX4JRDkbuoRDvnoZfV8Wdy7fnz
	aVWHWWL8+NUfv5hHdYd403ywHWK8w2hxxhVxDam8d6xbYDHOJefOuOAbpdRqXMff
	B67rA8a6oIs/XzGxwmxdKwvyuClg3SHJw5rz5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779722381; x=
	1779729581; bh=p+fmVjGYU7bTYKBfSi8JXdSR+0SLMTaXTvd5eVBiWdg=; b=L
	vvWtHK+I1ufwGppJp904MfdYVWUWeyTs0/OjnM1E1bHgnuhEn8ut9/l0e7U/wJxI
	+B92c2Nsq9mYwP4C505mIuce5pcXnjVO8NjKS9qEv/vo7ywHk3ez34ZarCrJxC/G
	G21BWWWeV5xTF28wu/i6KdJri9pxJ61/+pT+bYlbElWb/z3oUn64r4RqoPNO0sjo
	qG/eXme4QjgLYdRrehJ/4DSVqbEFZafEwbfbTqNLu8YMTo6qUQEsQjbhr0zIIesk
	A9/GkqGrzPDH06Hx9UIPNEF9Lv5+wTK7GWqWDi62TYcUhHSLcfu10UEyABxVHBOz
	vI9thrwnkRUocpPt1Scjg==
X-ME-Sender: <xms:jWgUaqXiTdJCGU5QNGCw-CXwtMDnurRrylimwdKu0qoYdrm7Sa4BLg>
    <xme:jWgUau9GQ5BCyt2CjVHYd7YSGSwpJDIFIiZ5y7TaCd3-hacAj-UmstbmZ2zWtEJ7_
    oPKOWovY9A502xMebjfPJb95_4UMJ0ySwIL7Vu3C9WYW74S89CnJ90>
X-ME-Received: <xmr:jWgUaooz6yUda5FVQzdGb6zTkbvvSFgvnVAmqhSm_m-Xi1-JFp78lb5u_jBcfg>
X-ME-Proxy-Cause: dmFkZTE3s0UX/p7Y+57GSix+5E7MJLV/+LsbqZvWSahNkNt4SjbTSMKpWb6koVAVGcaEvw
    hYXcOV79w/z83CC3VSmntG/LsIxf6d/Iuwh2YxHogqaalA4HDpe+wDf5JWdAZNJyXw4fwp
    QS+SC6TFjNPeWwjEQmA3MM3MGVymfh4tHY73r35pC7p5ziCMKaVqTC8p7NY+eUux76wU96
    WGtheyWb0qJPDVBQy8wVfThKaVFOzjHxkT54nB1aZBPzBuXY3ejgAj7FH8HeLAtbJR+bUy
    dP/7mOVCBcrXRaxrHp0uGmq3f7ekHavBCwAZ26yzsjpaext8EmB/McQ9c5Z2+HB7k5s5c5
    ZQYkW34v4wJJoyhoi5v8nRyJvc2guzdJ+BAIibHfWZjoLtUkfUelOmyF5ua4GqD5+wgna/
    beUgiegHroxJ4koA/KcZFRxM/EFbGBcYFGIwl71srWTHKOwPEq0kOK9MKqb3O9Yqa1cOxN
    vCiT0PwGSwiYw9UAqQ1sa3WL4ZSXlQNRyWw0yu2VKL3WQDd8uzVWB+0TXNncSc+jBB0FI6
    J0ck1nw+GzqlhQupDvK4l0hvpnhLOa5f7q+YNZFc18HDkrB8mQTs5Q1Ccf4FdnDHBqqgZx
    kUdBHZtKtitgksl+rgECzwK2FV2kpNyul7CjaTKor1Y/UKbQ28ZtJB4mvLuA
X-ME-Proxy: <xmx:jWgUal73ibyRK9TJtGZtiGqghxJ9kbJ4YyBfl8T-TJaPbILKWj4pxw>
    <xmx:jWgUah5GrJ9yc7vgaJilgZX4y45NeTSGrh-G_w4LcWxi5maVgjZRoA>
    <xmx:jWgUasmuXBTtjnIS1WoB3bNVaozC5RDzC45-tgHoMNm0JAwOj1eZMw>
    <xmx:jWgUagjpWc5qes8NA2dkZ9ygiXtXFl5W4LTKMBbrH8abRQZeJTJ8XQ>
    <xmx:jWgUaunxutpBWCeDb7X8kIGkEJgL7BG1S0FqTNDFaK1Kh--rGYlAeF38>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 11:19:39 -0400 (EDT)
Date: Mon, 25 May 2026 16:19:34 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 08/14] userfaultfd: add UFFDIO_REGISTER_MODE_RWP and
 UFFDIO_RWPROTECT plumbing
Message-ID: <ahRoPjww-xTjjl3O@thinkstation>
References: <20260525113737.1942478-9-kas@kernel.org>
 <20260525121111.E857E1F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525121111.E857E1F000E9@smtp.kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 70E8540005
X-Stat-Signature: 9xeakmrgg8hp8iyfajzzxiwhorf3n9qh
X-Rspam-User: 
X-HE-Tag: 1779722383-381381
X-HE-Meta: U2FsdGVkX1/LoZsakLNpXlVQTgg4YPb1ZcFDfQkPpCQHAASh70ep5P1RIM6R/bvEYr8yVilAa+PySy1VnkT+OHy0c4/DxmtRMqZdLRKRTSVcRpMc2P/PXChSYQOCAwpL0RJSxmyeKGTWKwoiUJ28hrW+oMorFvZJR9eJrGsdj6DEVOVpCH00JsoWeE8MwBV9htdQbrHCz2WOSumIMWSvdTAGPzfdy0nQqX65QK/pr65zFHgGaord/F5mJsIcavIAIrGGx22A0bZAmXQS+NankgI0U8sJFJ6aqz8iUuCMdy0fjFL/rP8ETtUp47NTIbU58UEfgdCQsPqZF10mg7Ei2EvtekriS1Z/kPSdHPPvkdfR6OG2ItbjwNSNZGny1Rq/f9VeLzhFh5rTS2HQbYihfmAaizxkQmAk7JA7ObxYJ4TAes74RdIVxw3gKReVmcJlq1WCu86yMGITT0ik9M9HrzIkxiiAaSX+YNY3zPm4NuJMEKK/b8wb8Tz1JKpjmGHaaL17VGvRL+Wj8xn5hG8cuzUJ4dhN6FnrCG3Fqw8aqgVN2t6f/Ppbn+1WJo3TF0k/anccuQZpY2Q4K+CR7kAUSzKGJ+CofVOzGkhPEzE2nB2RnjNu2w6gYr1QMQYEZdiTZDi5TpCi03NaTurAbphw401hFcm2iIGrja4Qie78ipYKAQg29mkokcxDGB3rSbxmAVI1uPxZGUN2a79HOpZlpAn/bUdVLtgPzIYfe3lJGtfnFr1i+F/GzQ8oUEbPM/80rhaDkbESolgmgYPN+kHsWSLYoufE1jE1y8XX/nQOswWs+pnS332NPgK+bqPeMeFhKL+To6TjJ4pgadZwWwfWd9if02K4ZVjsm7JYCtKDEJEyJ7GTpxdnu9AxpGZaMe8+2BQH68S8yZX3agwOUtVJKQfp4pKV/1LffKBKPOJIclBRPWNcRnplQyU4CHC8VZxawcTsiqr3PBSkH0eh10S
 3tLvKf/j
 Hqfx3CerEweFcqLs4/5KNJIXwkTgPo4MQnAljeJFA/vFjWRCOlNCjUnQ3gPn4kjJEJ0qsidyzloA7cJqykL5QPvf+Ro3TgeopkJsRF+Rsve9G7iAiONsJR4yJuB7oHfZbnvW67K+iInWW8TlbP+tA/cZK3V2F3IJ9GZen/9RYk2mPCxxEtrdL2p5VqhHQkIapNMxFrdIP64egAKyw71KwXvmtSYfCkqfopXO6M21oFUjSQcU0TMTkZ8dqdq1AE4Gq6JS8K2b27+WaDyZNxZRzzoo6uNHf4cQAYi7Z7V1xR2oWgOdES+pD/n/uum8Sff85JQbhKHV/7//64fuykK8+9BOKhchBcBPXERhFZYOl0edCgHWjcYso2842A2E9MT23mTbFbfltn5vdvaCkcvY6Xav2TTCRasdkEFLjMb2oYSrlkhpphL8Z763cyk/xx0Ie3oOP66w/v8vswnT6vsR1KLuExIDLByE1gSa3wNyJ8nlRQNUgNKV6ZNYUaQlfJqWhdMD7bYMPirUv34xoPauVEZ3CV8wc6RxhUBKV/fhdya960JDBiVU6ydRgZ/8AaQoCLTAZJeQ65HMTViToVllF30w5txD6gAKnQAps
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:11:11PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Page tables are accessed and modified under mmap_write_lock
> without first draining per-VMA lock holders via vma_start_write(),
> risking races with concurrent per-VMA readers.

Confirmed and pre-existing -- the pre-patch path called uffd_wp_range()
which has the same gap (no vma_start_write() before change_protection()
either). Will address in a follow-up that audits the userfaultfd
register/unregister paths together.

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=8

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

